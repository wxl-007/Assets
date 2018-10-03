using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Threading;
public class DownloadHelper
{
    private static List<DownloadHelper> m_DownloadHelper_list = new List<DownloadHelper>();

    /// <summary>
    /// 下载进度(百分比)
    /// </summary>
    public float progress { get; private set; }
    private bool isStop;
    private Thread thread;

    private long fileLength = 0;
    private long totalLength = 0;

    //private long m_curFileLength = 0;

    private string m_url;
    private string m_filePath;
    private bool m_IsDownloadComplete;
    private string m_Error;

    protected System.Action<float, long, long> _OnDownloadProgressChanged;
    protected System.Action<string> _OnDownloadCompleted;

    protected System.Action SetNoBackupFlagAction;

    /// <summary>
    /// 下载文件(断点续传)
    /// </summary>
    /// <param name="_url">下载地址</param>
    /// <param name="_filePath">本地文件存储路径</param>
    public void Download(MonoBehaviour mono, string _url, string _filePath, System.Action<float, long, long> onProcessAction, System.Action<string> onCompletedAction)
    {
        m_url = _url;
        m_filePath = _filePath;

        _OnDownloadProgressChanged = onProcessAction;
        _OnDownloadCompleted = onCompletedAction;

        m_IsDownloadComplete = false;
        m_Error = null;

        isStop = false;
        thread = new Thread(DoDownload);
        thread.IsBackground = true;
        thread.Start();

        if (mono != null) mono.StartCoroutine(OnDownloadCallback(mono));
    }

    /// <summary>
    /// 在主线程中对 进度 和 完成 的委托进行回调
    /// </summary>
    /// <param name="mono"></param>
    /// <returns></returns>
    private IEnumerator OnDownloadCallback(MonoBehaviour mono)
    {
        while (!m_IsDownloadComplete)
        {
            if (_OnDownloadProgressChanged != null)
                _OnDownloadProgressChanged(progress, fileLength, totalLength);
            yield return 0;

            if (SetNoBackupFlagAction != null)
            {
                SetNoBackupFlagAction();
                SetNoBackupFlagAction = null;
            }
        }

        if (string.IsNullOrEmpty(m_Error))
        {
            if (fileLength == totalLength)
            {
                UnityEngine.Debug.Log("CK : ------------------------------ 下载完成 fileLength = " + fileLength + ", totalLength = " + totalLength);
                m_Error = null;
            }
            else if (fileLength < totalLength)
            {
                UnityEngine.Debug.Log("CK : ------------------------------ 下载中断 fileLength = " + fileLength + ", totalLength = " + totalLength);

                if (isStop) m_Error = "下载中断";
                else
                {
                    Download(mono, m_url, m_filePath, _OnDownloadProgressChanged, _OnDownloadCompleted);
                    yield break;
                }
            }
            else
            {
                UnityEngine.Debug.Log("CK : ------------------------------ 下载异常 fileLength = " + fileLength + ", totalLength = " + totalLength);
                m_Error = "下载异常 @ 下载的文件大小大于原文件";
            }
        }


        if (SetNoBackupFlagAction != null)
        {
            SetNoBackupFlagAction();
            SetNoBackupFlagAction = null;
        }
        if (_OnDownloadCompleted != null) _OnDownloadCompleted(m_Error);
    }

    private void DoDownload()
    {
        try
        {
            m_DownloadHelper_list.Add(this);
            string fileDir = Path.GetDirectoryName(m_filePath);
            if (!Directory.Exists(fileDir)) Directory.CreateDirectory(fileDir);
            //string filePath = m_filePath  + m_url.Substring(m_url.LastIndexOf('/') + 1);
            if (!File.Exists(m_filePath))
            {
                FileStream fs = File.Create(m_filePath);
                fs.Close();
            }
            SetNoBackupFlagAction = ()=>ConfigUpdater.SetNoBackupFlag(m_filePath);

            FileStream fileStream = File.OpenWrite(m_filePath); //new FileStream(m_filePath, FileMode.OpenOrCreate, FileAccess.Write);//
            fileLength = fileStream.Length;
            totalLength = GetLength(m_url);

            UnityEngine.Debug.Log("CK : ------------------------------ fileLength = " + fileLength  + ", totalLength = " + totalLength);

            if (fileLength < totalLength)
            {
                UnityEngine.Debug.Log("CK : ------------------------------ startdownload fileLength = " + fileLength  + ", totalLength = " + totalLength);
                //UnityEngine.Debug.Log("CK : ------------------------------ start = ");

                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(m_url);
                request.Timeout = 5000;
                request.AddRange((int)fileLength);
                //UnityEngine.Debug.Log("CK : ------------------------------ request = ");
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                //UnityEngine.Debug.Log("CK : ------------------------------ response = ");
                fileStream.Seek(fileLength, SeekOrigin.Begin);
                Stream httpStream = response.GetResponseStream();
                byte[] buffer = new byte[1024];
                int length = httpStream.Read(buffer, 0, buffer.Length);
                while (length > 0)
                {
                    if (isStop)
                        break;
                    fileStream.Write(buffer, 0, length);
                    fileStream.Flush();
                    fileLength += length;
                    progress = (fileLength + 0f) / totalLength * 100;
                //UnityEngine.Debug.Log("CK : ------------------------------ response = " + 3);
                    length = httpStream.Read(buffer, 0, buffer.Length);
                }
                httpStream.Close();
                httpStream.Dispose();
            }
            else
                progress = (fileLength + 0f) / totalLength * 100;
            fileStream.Close();
            fileStream.Dispose();
            m_DownloadHelper_list.Remove(this);
        }
        catch (System.Exception e)
        {
            UnityEngine.Debug.Log("CK : ------------------------------ downloadhelper exeption = " + e.Message);
            if (string.IsNullOrEmpty(m_Error)) m_Error = "下载异常 @ " + e.Message;
        }

        m_IsDownloadComplete = true;
    }

    /// <summary>
    /// 关闭线程
    /// </summary>
    public void Close()
    {
        isStop = true;
    }

    /// <summary>
    /// 关闭所有的正在运行中的 下载
    /// </summary>
    public static void CloseAll()
    {
        foreach (var item in m_DownloadHelper_list)
        {
            item.Close();
        }

        m_DownloadHelper_list.Clear();
    }

    long GetLength(string _fileUrl)
    {
        HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(_fileUrl);
        request.Method = "HEAD";
        HttpWebResponse res = (HttpWebResponse)request.GetResponse();
        return res.ContentLength;
    }
}