using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.IO;
using System.Threading;

public class WWWConfigUpdater : ConfigUpdater {


    //private WebClient m_client;

    //private bool m_IsComplete;
    //private bool m_HasMono;
    //private string m_Error;

    //用于连接超时的判断
    private const float TimeOut = 20f;
    private float m_CurConnectTime;
    private float m_PreProcess;
    private string fileMD5 = null;
    //热更新升级后 添加了 热更新 版本号
    private string m_BaseSrcUrl_raw = null;//用于存储 m_BaseSrcUrl 去掉 /versionCode(这里是热更新版本号数字)/StreamingAssets/


    protected override void Update(MonoBehaviour mono,string baseSrcUrl, string baseDesUrl, JSONObject config)
    {
        //if(m_client != null)
        //{
        //    throw new System.Exception("this WebClientDownloader is in Use, please use another one");
        //}

        if (!Reset(baseSrcUrl, baseDesUrl, config)) return; //UnityEngine.Debug.LogError("ck debug : -------------------------------- m_BaseSrcUrl = " + m_BaseSrcUrl);

        m_BaseSrcUrl_raw = m_BaseSrcUrl.Replace(Constants.DirName,"");
        m_BaseSrcUrl_raw = m_BaseSrcUrl_raw.Substring(0,m_BaseSrcUrl_raw.LastIndexOf("/")+1);
        //UnityEngine.Debug.Log("ck debug : -------------------------------- m_BaseSrcUrl_raw = " + m_BaseSrcUrl_raw);


        mono.StartCoroutine(DoDownload());
    }

    IEnumerator DoDownload(Dictionary<string, long> m_RelativeUrlSizeMap_temp = null)
    {
        string error = string.Empty;
        System.Random ro = new System.Random();
        byte[] bytes = null;
        if (m_RelativeUrlSizeMap_temp == null) m_RelativeUrlSizeMap_temp = m_RelativeUrlSizeMap;
        //Dictionary<string, long> m_RelativeUrlSizeMap_pending = new Dictionary<string, long>();// 这个用来把正在下载的文件(以保持在本地的位置为准, 避免本地文件被多个地方修改) 先挂起来, 下下载其他文件, 都下载好了 再重新回来检查下载情况//目前还没在用

        foreach (var item in m_RelativeUrlSizeMap_temp)
        {
            m_CurrentRelativeUrl = item.Key;

            string resUrl = m_BaseSrcUrl_raw + m_RelativeUrlVersionCodeMap[m_CurrentRelativeUrl]+ Constants.DirName + m_CurrentRelativeUrl;//热更新升级后 会有 热更新版本号
            //UnityEngine.Debug.Log("ck debug : -------------------------------- resUrl = " + resUrl);

            string savePath = m_BaseDesUrl + m_CurrentRelativeUrl;
            string saveDir = Path.GetDirectoryName(savePath);
            if (!Directory.Exists(saveDir)) Directory.CreateDirectory(saveDir);//创建文件夹

            //热更新升级, 添加在下载文件前检查文件是否已经下载完成
            if (File.Exists(savePath))
            {
                bytes = File.ReadAllBytes(savePath);
                if(bytes.Length > 0)
                {
                    CheckMD5(bytes);

                    while (fileMD5 == null)
                    {
                        yield return 0;
                    }

                    if (fileMD5 == m_FileMD5Map[item.Key])
                    {
                        OnFileUpdated();//把已经完成的下载配置 记录到 配置文件中

                        continue;//文件已经下载完成了
                    }
                }
            }
                

            using (WWW www = new WWW(resUrl + "?" + ro.NextDouble()))
            {//这段代码可以抽取下
                while (!www.isDone)
                {

                    //while(Application.internetReachability != NetworkReachability.ReachableViaLocalAreaNetwork)
                    //{//只在wifi环境下下载资源
                    //    yield return new WaitForSeconds(10);
                    //}

                    error = CheckTimeOut(www);

                    if (www.error != null)
                    {
                        error = " @ " + www.error;
                    }
                    else
                    {
                        if (_OnDownloadProgressChanged != null)
                        {
                            _OnDownloadProgressChanged(m_CurrentRelativeUrl, System.Convert.ToInt64(m_DownloadedFilesBytes + www.progress * item.Value), m_TotalDownloadBytes);
                        }
                    }

                    if (string.IsNullOrEmpty(error)) yield return 0;
                    else
                    {
                        OnComplete(error);
                        //www.Dispose();
                        //www = null;
                        yield break;
                    }
                }

                //启用线程,避免MD5计算时间过程导致卡顿//同时使用while循环阻塞该协程,直到md5计算完后才继续后面的计算

                bytes = StaticUtils.Crypt(www.bytes);
                CheckMD5(bytes);

                while (fileMD5 == null)
                {
                    yield return 0;
                }

                if (fileMD5 != m_FileMD5Map[item.Key])
                {
                    if (Constants.isEditor) UnityEngine.Debug.LogError("ck debug : -------------------------------- <color=red>下载出错 = " + m_CurrentRelativeUrl + " @ 文件md5出错了</color>" + ", error = " + error + ", www.bytes.length = " + (www.bytes != null ? www.bytes.Length : 0) + ", resUrl = " + resUrl);

                    OnComplete(" @ 文件md5出错了");
                    yield break;
                }

                //UnityEngine.Debug.Log("CK : ------------------------------ www config updater fileMD5 = " + fileMD5 + ", savePath = " + savePath);

                m_DownloadedFilesCount++;
                m_DownloadedFilesBytes += item.Value;
                if (File.Exists(savePath)) File.Delete(savePath);
                File.WriteAllBytes(savePath, bytes);
                SetNoBackupFlag(savePath);

                //UnityEngine.Debug.Log("CK : ------------------------------ www config updater = " + www.assetBundle + ", savePath = " + savePath);

                OnFileUpdated();
                //UnityEngine.Debug.Log("CK : ------------------------------ www config updater = " + 1);
                if (www.assetBundle) www.assetBundle.Unload(false);//释放assetbundle资源
                //www.Dispose();
                //www = null;
            }
        }

        //UnityEngine.Debug.Log("CK : ------------------------------ download complete = "  );

        OnComplete(null);
    }

    private void CheckMD5(byte[] bytes)
    {
        fileMD5 = null;
        if (bytes.Length > 1024 * 1024)
        {
            Thread thread = new Thread(() =>
            {
                fileMD5 = StaticUtils.md5(bytes);
            });
            thread.IsBackground = true;
            thread.Start();
        }
        else
        {
            fileMD5 = StaticUtils.md5(bytes);
        }
    }

    private string CheckTimeOut(WWW www)
    {
        if (m_PreProcess != www.progress)
        {
            m_PreProcess = www.progress;
            m_CurConnectTime = 0;
        }
        else
        {
            m_CurConnectTime += Time.deltaTime;
            if (m_CurConnectTime > TimeOut)
            {
                return " @ 连接超时,请稍后重试";
            }
        }

        return null;
    }

    private void OnComplete(string error)
    {
        if (_OnDownloadCompleted != null) _OnDownloadCompleted(m_ResultConfig, string.IsNullOrEmpty(error) ? null : m_CurrentRelativeUrl + error);
    }
}
