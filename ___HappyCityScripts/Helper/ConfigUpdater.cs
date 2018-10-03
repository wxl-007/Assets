using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[DefaultClass(typeof(DownloadConfigUpdater))]
public abstract class ConfigUpdater
{
    protected System.Action<string, long,long> _OnDownloadProgressChanged;
    protected System.Action<JSONObject, string> _OnDownloadCompleted;
    //protected static List<string> m_DownloadingList = new List<string>();//正在下载的文件(存的是本地相对地址)的列表//暂时没有在用

    //protected MonoBehaviour m_Mono;
    protected string m_BaseSrcUrl = string.Empty;
    protected string m_BaseDesUrl = string.Empty;
    protected List<string> m_RelativeUrlList = null;
    protected Dictionary<string, string> m_FileMD5Map = null;//对应配置文件中 文件的md5
    protected Dictionary<string, long> m_RelativeUrlSizeMap = null;//对应配置文件中 文件的size
    protected Dictionary<string, int> m_RelativeUrlVersionCodeMap = null;//对应配置文件中 文件的versionCode
    protected JSONObject m_Config = null;
    protected JSONObject m_ResultConfig = null;

    protected int m_DownloadedFilesCount = 0;
    protected long m_DownloadedFilesBytes = 0;//这里存放的是所有已经下载好的文件的总大小,不包含正在下载的文件
    protected long m_DownloadedBytes = 0;//这里包含正在下载的文件的大小
    protected long m_TotalDownloadBytes = 0;//所有需要下载的文件总大小

    protected string m_CurrentRelativeUrl = string.Empty;
    protected long m_CurrentFileLength = 0;//当前下载中的文件的大小

    //private WebClient m_client;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="baseSrcUrl"></param>
    /// <param name="baseDesUrl"></param>
    /// <param name="relativeUrlList"></param>
    /// <returns>true m_RelativeUrlList 中有需要下载的文件,false 代表没有需要下载的文件</returns>
    protected bool Reset(string baseSrcUrl, string baseDesUrl, JSONObject config)
    {
        this.m_BaseSrcUrl = baseSrcUrl;
        this.m_BaseDesUrl = baseDesUrl;
        this.m_Config = config;
        this.m_ResultConfig = new JSONObject();
        //this.m_RelativeUrlList = relativeUrlList;

        m_DownloadedFilesCount = 0;
        m_DownloadedFilesBytes = 0;
        m_DownloadedBytes = 0;
        m_TotalDownloadBytes = 0;

        HandleConfig();

        if (m_RelativeUrlList.Count <= 0)
        {
            if (_OnDownloadCompleted != null)
                _OnDownloadCompleted(m_ResultConfig,null);
            return false;
        }

        return true;
    }

    /// <summary>
    /// 把json格式配置文件中所有需要下载的路径装到 m_RelativeUrlList 中
    /// </summary>
    private void HandleConfig()
    {
        m_RelativeUrlList = new List<string>();
        m_FileMD5Map = new Dictionary<string, string>();
        m_RelativeUrlSizeMap = new Dictionary<string, long>();
        m_RelativeUrlVersionCodeMap = new Dictionary<string, int>();
        if (m_Config == null) return;

        string relativeUrl = string.Empty;
        string fileSizeStr = string.Empty;
        long fileSize = 0;

        string[] splitStrs = null;
        foreach (var item in m_Config.keys)
        {
            if (m_Config[item] == null || m_Config[item].type == JSONObject.Type.NULL) continue;

            foreach (var key in m_Config[item].keys)
            {
                if (m_Config[item][key] == null || m_Config[item][key].type == JSONObject.Type.NULL) continue;

                //把路径添加到 m_RelativeUrlList 中
                relativeUrl = StaticUtils.CheckRelativeUrl(item,key);
                m_RelativeUrlList.Add(relativeUrl);

                splitStrs = m_Config[item][key].str.Split(new string[] { "|" }, System.StringSplitOptions.RemoveEmptyEntries);
                //计算总大小
                fileSizeStr = splitStrs[1];
                fileSize = System.Convert.ToInt64(fileSizeStr);
                m_FileMD5Map[relativeUrl] = splitStrs[0];
                m_RelativeUrlSizeMap[relativeUrl] = fileSize;
                m_RelativeUrlVersionCodeMap[relativeUrl] = System.Convert.ToInt32(splitStrs[2]);
                m_TotalDownloadBytes += fileSize;
            }
        }
    }

    /// <summary>
    /// 当有一个路径的文件下载完成时把路径记录到 m_ResultConfig 中
    /// </summary>
    protected void OnFileUpdated()
    {
        if (string.IsNullOrEmpty(m_CurrentRelativeUrl)) return;

        string[] split = m_CurrentRelativeUrl.Split(new string[] { "/"},2,System.StringSplitOptions.RemoveEmptyEntries);
        string gameModule = split.Length > 1 ? split[0] : "";
        string path = split[split.Length - 1];

        if (!m_ResultConfig.HasField(gameModule)) m_ResultConfig[gameModule] = new JSONObject();
        m_ResultConfig[gameModule][path] = m_Config[gameModule][path];
    }

    protected abstract void Update(MonoBehaviour mono, string baseSrcUrl, string baseDesUrl, JSONObject config);
    public void Update(MonoBehaviour mono, string baseSrcUrl, string baseDesUrl, JSONObject config, System.Action<string, long,long> onDownloadProgressChanged, System.Action<JSONObject, string> onDownloadCompleted)
    {
        this._OnDownloadCompleted = onDownloadCompleted;
        this._OnDownloadProgressChanged = onDownloadProgressChanged;
        Update(mono, baseSrcUrl, baseDesUrl, config);
    }

    /// <summary>
    /// ios 下 路径不会存储到icloud
    /// </summary>
    /// <param name="path"></param>
    public static void SetNoBackupFlag(string path)
    {
#if UNITY_IOS
            UnityEngine.iOS.Device.SetNoBackupFlag(path);
#endif
    }
}
