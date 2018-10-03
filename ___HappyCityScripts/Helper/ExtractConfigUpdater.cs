using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.IO;

public class ExtractConfigUpdater : ConfigUpdater {

    //private bool m_IsComplete;
    //private bool m_HasMono;
    private string m_Error;

    protected override void Update(MonoBehaviour mono, string baseSrcUrl, string baseDesUrl, JSONObject config)
    {

        if (!Reset(baseSrcUrl, baseDesUrl, config)) return;
        m_Error = null;

#if UNITY_EDITOR
        if (!Application.isPlaying)//编辑器模式下
        {
            IEnumerator enumerator = Extract(mono);
            while (enumerator.MoveNext()) ;
        }else mono.StartCoroutine(Extract(mono));
#else
        mono.StartCoroutine(Extract(mono));
#endif
    }

    IEnumerator Extract(MonoBehaviour mono)
    {
        string resPath = string.Empty;
        string desPath = string.Empty;
        for (m_DownloadedFilesCount = 0; m_DownloadedFilesCount < m_RelativeUrlList.Count; m_DownloadedFilesCount++)
        {
            m_CurrentRelativeUrl = m_RelativeUrlList[m_DownloadedFilesCount];

            resPath = m_BaseSrcUrl + m_CurrentRelativeUrl;
            desPath = m_BaseDesUrl + m_CurrentRelativeUrl;

            yield return mono.StartCoroutine(DoExtractFile(resPath, desPath));

            if (m_Error != null) break;

            OnFileUpdated();

            if (_OnDownloadProgressChanged != null) _OnDownloadProgressChanged(m_CurrentRelativeUrl, m_DownloadedFilesCount + 1, m_RelativeUrlList.Count);
        }

        if (_OnDownloadCompleted != null) _OnDownloadCompleted(m_ResultConfig, m_Error);
    }

    IEnumerator DoExtractFile(string resPath, string desPath)
    {
        string dir = Path.GetDirectoryName(desPath);
        if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
        if (File.Exists(desPath)) File.Delete(desPath);

        //Debug.Log("正在解包文件:> " + resPath);

        if (Application.platform == RuntimePlatform.Android)
        {
            using (WWW www = new WWW(resPath))
            {
                yield return www;

                if (www.error != null)
                {
                    m_Error = www.error + ":访问文件出错@" + resPath;
                }
                else
                {
                    //UnityEngine.Debug.Log("CK : ------------------------------ desPath = " + desPath);
                    
                    File.WriteAllBytes(desPath, StaticUtils.Crypt(www.bytes));
                    //UnityEngine.Debug.Log("CK : ------------------------------ size = " + www.bytes);
                    if (www.assetBundle) www.assetBundle.Unload(false);//释放assetbundle资源
                    //www.Dispose();//使用Using 替换
                    //www = null;//使用using 替换
                }
            }
            yield return 0;
        }
        else if (File.Exists(resPath)) File.WriteAllBytes(desPath, StaticUtils.Crypt(File.ReadAllBytes(resPath)));
        else m_Error = ":访问文件出错@" + resPath;
        SetNoBackupFlag(desPath);
    }
}
