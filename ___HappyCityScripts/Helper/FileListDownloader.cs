using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[DefaultClass(typeof(WebClientDownloader))]
public abstract class FileListDownloader{

    public System.Action<string,long> _OnDownloadProgressChanged;
    public System.Action<string> _OnDownloadCompleted;

    protected MonoBehaviour m_Mono;
    protected string m_BaseUrl = string.Empty;
    protected string m_BaseSaveDir = string.Empty;
    protected List<string> m_RelativeUrlList = null;

    protected int m_DownloadedFilesCount = 0;
    protected long m_DownloadedFilesBytes = 0;//这里存放的是所有已经下载好的文件的总大小,不包含正在下载的文件
    protected long m_DownloadedBytes = 0;//这里包含正在下载的文件的大小

    protected string m_CurrentRelativeUrl = string.Empty;
    protected long m_CurrentFileLength = 0;//当前下载中的文件的大小

    //private WebClient m_client;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="baseUrl"></param>
    /// <param name="baseSaveDir"></param>
    /// <param name="relativeUrlList"></param>
    /// <returns>true m_RelativeUrlList 中有需要下载的文件,false 代表没有需要下载的文件</returns>
    protected bool Reset(string baseUrl, string baseSaveDir, List<string> relativeUrlList)
    {
        this.m_BaseUrl = baseUrl;
        this.m_BaseSaveDir = baseSaveDir;
        this.m_RelativeUrlList = relativeUrlList;

        m_DownloadedFilesCount = 0;
        m_DownloadedFilesBytes = 0;
        m_DownloadedBytes = 0;

        if (m_RelativeUrlList.Count <= 0)
        {
            if (_OnDownloadCompleted != null)
                _OnDownloadCompleted(null);
            return false;
        }

        return true;
    }

    public abstract void DownloadFileList(MonoBehaviour mono, string baseUrl, string baseSaveDir, List<string> relativeUrlList);
    public void DownloadFileList(MonoBehaviour mono, string baseUrl, string baseSaveDir, List<string> relativeUrlList, System.Action<string, long> onDownloadProgressChanged, System.Action<string> onDownloadCompleted)
    {
        this._OnDownloadCompleted = onDownloadCompleted;
        this._OnDownloadProgressChanged = onDownloadProgressChanged;
        DownloadFileList(mono,baseUrl,baseSaveDir,relativeUrlList);
    }
    //{
    //    this.m_BaseUrl = baseUrl;
    //    this.m_BaseSaveDir = baseSaveDir;
    //    this.m_RelativeUrlList = relativeUrlList;

    //    m_DownloadedFilesCount = 0;
    //    m_DownloadedFilesBytes = 0;
    //    //m_DownloadedBytes = 0;


    //    if (m_RelativeUrlList.Count <= 0)
    //    {
    //        if (_OnDownloadCompleted != null)
    //            _OnDownloadCompleted(null);
    //        return;
    //    }

    //    m_client = new WebClient();
    //    DoDownload();
    //}

    //void DoDownload() {
    //    m_CurrentRelativeUrl = m_RelativeUrlList[m_DownloadedFilesCount];

    //    m_client.DownloadProgressChanged += OnDownloadProgressChanged;
    //    m_client.DownloadFileCompleted += OnDownloadFileCompleted;

    //    string savePath = m_BaseSaveDir + m_CurrentRelativeUrl;
    //    string saveDir = Path.GetDirectoryName(savePath);
    //    if (!Directory.Exists(saveDir)) Directory.CreateDirectory(saveDir);//创建文件夹

    //    m_client.DownloadFileAsync(new System.Uri(m_BaseUrl + m_CurrentRelativeUrl), savePath);
    //}

    //void OnDownloadProgressChanged(object sender, DownloadProgressChangedEventArgs ev)
    //{
    //    Debug.Log("=================================================" + ev.BytesReceived + " / " + ev.TotalBytesToReceive);
    //    m_CurrentFileLength = ev.TotalBytesToReceive;

    //    if (_OnDownloadProgressChanged != null)
    //        _OnDownloadProgressChanged(m_CurrentRelativeUrl, m_DownloadedFilesBytes + ev.BytesReceived);//正在下载文件 m_CurrentRelativeUrl,目前总共下载的资源大小 m_DownloadedFilesBytes + ev.BytesReceived
    //}

    //void OnDownloadFileCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs ev)
    //{
    //    if(ev.Error != null)
    //    {
    //        //出错了,下载没有完成
    //        if (_OnDownloadCompleted != null)
    //            _OnDownloadCompleted(m_CurrentRelativeUrl + "@" +ev.Error.Message);
    //            CloseWebClient();
    //    }
    //    else
    //    {
    //        //文件下载完成
    //        m_DownloadedFilesCount++;
    //        m_DownloadedFilesBytes += m_CurrentFileLength;

    //        if(m_DownloadedFilesCount < m_RelativeUrlList.Count)
    //        {
    //            //文件列表未完成下载
    //            DoDownload();
    //        }
    //        else
    //        {
    //            //文件列表已经完成下载
    //            if(_OnDownloadCompleted != null)
    //                _OnDownloadCompleted(null);
    //            CloseWebClient();
    //        }
    //    }
    //}

    //void CloseWebClient()
    //{
    //    m_client.Dispose();
    //    m_client = null;
    //}
}
