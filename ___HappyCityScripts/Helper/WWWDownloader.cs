using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//using System;
using System.IO;

public class WWWDownloader : FileListDownloader
{
    //private MonoBehaviour m_Mono;
    public WWWDownloader()
    {
    }

    public WWWDownloader(MonoBehaviour mono)
    {
        this.m_Mono = mono;
    }

    public override void DownloadFileList(MonoBehaviour mono,string baseUrl, string baseSaveDir, List<string> relativeUrlList)
    {
        if (!Reset(baseUrl, baseSaveDir, relativeUrlList)) return;
        m_Mono.StartCoroutine(DoDownload());
    }

    IEnumerator DoDownload()
    {
        m_CurrentRelativeUrl = m_RelativeUrlList[m_DownloadedFilesCount];
        string url = m_BaseUrl + m_CurrentRelativeUrl;

        Debug.Log("downloading...." + m_CurrentRelativeUrl);
        WWW www = new WWW(url);
        //yield return www;
        while (www.progress < 1)
        //while (!www.isDone)
        {
            //进度更新
            if (_OnDownloadProgressChanged != null)
                _OnDownloadProgressChanged(m_CurrentRelativeUrl,(long) www.progress);//m_DownloadedFilesBytes + www.bytesDownloaded);
            Debug.Log("www.progress = " + www.progress);
            yield return 0;
        }

        Debug.Log("www.progress = " + www.progress + ", bytesDownloaded = " + www.bytesDownloaded);

        //yield return www;

        if (www.error != null)
        {
            if (_OnDownloadCompleted != null)
                _OnDownloadCompleted(www.error);
            yield break;
        }
        else
        {
            string savePath = m_BaseSaveDir + m_CurrentRelativeUrl;
            string saveDir = Path.GetDirectoryName(savePath);
            if (!Directory.Exists(saveDir)) Directory.CreateDirectory(saveDir);//创建文件夹

            if (File.Exists(savePath)) File.Delete(savePath);
            File.WriteAllBytes(savePath, www.bytes);

            //文件下载完成
            m_DownloadedFilesCount++;
            m_DownloadedFilesBytes += m_CurrentFileLength;

            if (m_DownloadedFilesCount < m_RelativeUrlList.Count)
            {
                //文件列表未完成下载
                //m_mono.StartCoroutine(DoDownload());
            }
            else
            {
                //文件列表已经完成下载
                if (_OnDownloadCompleted != null)
                    _OnDownloadCompleted(null);
            }
        }
    }


}
