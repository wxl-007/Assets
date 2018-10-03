using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class Constants {
    public static readonly bool isEditor = Application.isEditor;//不能在子线程中使用

    public const string DirName = "/StreamingAssets/";//AssetBundle 打包后的 配置文件名称
    public static readonly string UpdateDirName = "/version_" + Utils.version + DirName;//AssetBundle 打包后的 配置文件名称
    public static readonly string UpdateVersionControl = "/version_" + Utils.version + "/VersionControl.txt";//记录最新的热更新版本号
    public const string Config_File = "file.txt";//AssetBundle 打包后的 配置文件名称

    private static string m_InstantUpdateUrl;
    public static string InstantUpdateUrl
    {
        get
        {
            m_InstantUpdateUrl = PlatformGameDefine.playform.InstantUpdateUrl;
            return m_InstantUpdateUrl;
        }
    }
    /// <summary>
    /// 与上面的区别是: 上面的方法每次都会切换一个url地址, 这里的不会切换url地址(如果为空, 则会获取)
    /// </summary>
    public static string _InstantUpdateUrl
    {
        get
        {
            if(string.IsNullOrEmpty(m_InstantUpdateUrl))
                m_InstantUpdateUrl = InstantUpdateUrl;

            return m_InstantUpdateUrl;
        }
    }

#if UNITY_EDITOR
    //该值在编辑器下运行的,打包出来的extract对应的路径
    public static string UpdateUrl {
        get {
            if (SimpleFramework.Manager.GameManager.m_IsServerUrl) return InstantUpdateUrl;
            else return "file:///" + Path.GetDirectoryName(Application.dataPath.ToLower()) + "/extract" + Constants.UpdateDirName;//AssetBundle 更新地址,服务端url,可以通过url配置. 本地测试地址
            //else return PlatformGameDefine.playform.InstantUpdateUrl;
        }
    }
#else
    public static string UpdateUrl {get { return InstantUpdateUrl; }} //AssetBundle 更新地址,服务端url,可以通过url配置
#endif

    public static string UpdateVersionControlUrl {//热更新版本控制文件url
        get {
            return _InstantUpdateUrl.Replace(UpdateDirName, UpdateVersionControl);
        }
    }

    public static readonly string DataPath = SimpleFramework.Util.DataPath;//游戏解包和更新的目的地目录
    public static readonly string StreamingAssetsDataPath = SimpleFramework.Util.AppContentPath();//StreamingAssets 目录
    public static readonly string DownloadPath = DataPath + "Download/";
    public static readonly string VersionUpdatePath = DataPath + "VersionUpdate/";//大版本包更新保存路径
    public const string InstantUpdate_VersionTime = "InstantUpdate_VersionTime";
    public const string InstantUpdate_VersionCode = "InstantUpdate_VersionCode";
    public static readonly string Pack_Config_Path = Application.streamingAssetsPath+ "/Pack_Config.txt";
    //热更新升级后天就的点击热更新 用于判断需要下载的资源的 配置文件(实际上是该版本(本地正在使用的资源版本)的完整配置文件)
    public const string ClickDownload_Config_res = "Texts/file";//Resources 路径
    public const string ClickDownload_Config_resource = "Texts/file.txt";//Resources 路径
    public static readonly string ClickDownload_Config_download = DownloadPath + "Texts/file.txt";//从阿里云下载后保存在 Download下的 路径
    public static readonly string ClickDownload_Config_data = DataPath + "Texts/file.txt";//从Resources 解压或者 从 Download 移动到 DataPath下的 路径 //该路径下存的是当前版本的所有资源的配置文件(与DataPath 下的文件的区别是, DataPath 下存的是 当前游戏中有的模块的资源(不是所有的))
}
