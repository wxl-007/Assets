using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.IO;

public class DownloadConfigUpdater : ConfigUpdater {


    private WebClient m_client;

    private bool m_IsComplete;
    private bool m_HasMono;
    private string m_Error;

    //用于连接超时的判断
    private const float TimeOut = 20f;
    private float m_CurConnectTime;
    private long m_PreDownloadedBytes;

    protected override void Update(MonoBehaviour mono,string baseSrcUrl, string baseDesUrl, JSONObject config)
    {
        if(m_client != null)
        {
            throw new System.Exception("this WebClientDownloader is in Use, please use another one");
        }

        if (!Reset(baseSrcUrl, baseDesUrl, config)) return;

        m_HasMono = mono != null;
        m_IsComplete = false;
        m_Error = null;

        m_client = new WebClient();

        m_client.DownloadProgressChanged -= OnDownloadProgressChanged;
        m_client.DownloadProgressChanged += OnDownloadProgressChanged;

        m_client.DownloadFileCompleted -= OnDownloadFileCompleted;
        m_client.DownloadFileCompleted += OnDownloadFileCompleted;

        Download();

        if (m_HasMono) mono.StartCoroutine(DoDownloadCallback());//这样处理的目的是确保回调方法中能够使用只能在主线程中使用的方法
    }

    IEnumerator DoDownloadCallback()
    {
        while (!m_IsComplete)
        {
            yield return 0;
            if (_OnDownloadProgressChanged != null) _OnDownloadProgressChanged(m_CurrentRelativeUrl,m_DownloadedBytes,m_TotalDownloadBytes);

            if(m_PreDownloadedBytes != m_DownloadedBytes)
            {
                m_PreDownloadedBytes = m_DownloadedBytes;
                m_CurConnectTime = 0;
            }
            else
            {
                m_CurConnectTime += Time.deltaTime;
                if(m_CurConnectTime > TimeOut)
                {
                    if(m_client != null) m_client.CancelAsync();
                }
            }
        }

        if (_OnDownloadCompleted != null) _OnDownloadCompleted(m_ResultConfig, m_Error);

        m_IsComplete = false;
        m_Error = null;
    }

    void Download()
    {
        m_CurrentRelativeUrl = m_RelativeUrlList[m_DownloadedFilesCount];
        
        string savePath = m_BaseDesUrl + m_CurrentRelativeUrl;
        string saveDir = Path.GetDirectoryName(savePath);
        if (!Directory.Exists(saveDir)) Directory.CreateDirectory(saveDir);//创建文件夹

        m_client.DownloadFileAsync(new System.Uri(m_BaseSrcUrl + m_CurrentRelativeUrl), savePath);
    }

    void OnDownloadProgressChanged(object sender, DownloadProgressChangedEventArgs ev)
    {
        //Debug.Log("=================================================" + ev.BytesReceived + " / " + ev.TotalBytesToReceive);
        m_CurrentFileLength = ev.TotalBytesToReceive;

        m_DownloadedBytes = m_DownloadedFilesBytes + ev.BytesReceived;
        if (!m_HasMono && _OnDownloadProgressChanged != null)
            _OnDownloadProgressChanged(m_CurrentRelativeUrl, m_DownloadedBytes,m_TotalDownloadBytes);//正在下载文件 m_CurrentRelativeUrl,目前总共下载的资源大小 m_DownloadedFilesBytes + ev.BytesReceived
    }

    void OnDownloadFileCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs ev)
    {
        if (ev.Error != null)
        {
            m_Error = m_CurrentRelativeUrl + "@" + ev.Error.Message;
            OnComplete(m_Error);
        }else if (ev.Cancelled)
        {
            m_Error = "连接超时,请稍后再试";
            OnComplete(m_Error);
        }
        else
        {
            //文件下载完成
            OnFileUpdated();//把已下载的路径添加到 m_ResultConfig 配置中
            m_DownloadedFilesCount++;
            m_DownloadedFilesBytes += m_CurrentFileLength;

            if (m_DownloadedFilesCount < m_RelativeUrlList.Count)
            {
                m_IsComplete = false;
                //文件列表未完成下载
                Download();
            }
            else
            {
                OnComplete(null);
            }
        }
    }

    void OnComplete(string error)
    {
        CloseWebClient();
        m_IsComplete = true;

        //文件列表已经完成下载
        if (!m_HasMono && _OnDownloadCompleted != null)
            _OnDownloadCompleted(m_ResultConfig, error);
    }

    void CloseWebClient()
    {
        m_client.Dispose();
        m_client = null;
    }
}
