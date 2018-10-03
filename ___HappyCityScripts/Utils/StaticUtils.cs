using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
//using SimpleFramework;
using System;
using System.Net;

public static class StaticUtils
{
    //private static long InstantUpdate_VersionTime;
    //private static int InstantUpdate_UpdateVersionControlCode = 0;//如果获取到有效的, 那么该值一定大于0


    #region 使用json作为配置文件,一次性比较所有模块中的文件变化,统一(使用ConfigUpdater)更新和解压(StreamingAssets目录下的资源),更新后更新(不直接覆盖)配置文件
    #region 比较配置文件,获得需要更新或者复制的文件的路径
    /// <summary>
    /// 比较src(源目录)和des(目的目录)配置文件,获得需要更新(从服务端更新或者从随包资源的StreamingAssets(随包资源更新)目录更新资源)
    /// </summary>
    /// <param name="src"></param>
    /// <param name="des"></param>
    /// <param name="onComplete"></param>
    /// <param name="isUpdate">true: 从后台更新, false 从StreamingAssets 目录更新</param>
    /// <param name="gameModuleList">如果该值为null 那么会更新所有配置文件中的模块,如果不为空那么只会更新该list 中有的模块</param>
    /// <returns></returns>
    public static Coroutine CompareConfig(this MonoBehaviour mono, string src, string des, List<string> gameModuleList, bool isUpdate, System.Action<JSONObject,JSONObject, string> onComplete)
    {
#if UNITY_EDITOR
        if (!Application.isPlaying)
        {
            IEnumerator enumerator = CompareConfig(src, des, gameModuleList, isUpdate, onComplete);
            while (enumerator.MoveNext()) ;//编辑器模式下,mono 无法一次性完成 coroutine(IEnumerator)
            return null;
        }
        else return mono.StartCoroutine(CompareConfig(src, des, gameModuleList, isUpdate, onComplete));
#else
        return mono.StartCoroutine(CompareConfig(src,des,gameModuleList,isUpdate,onComplete));
#endif
    }

    public static IEnumerator CompareConfig(string src, string des, List<string> gameModuleList, bool isUpdate, System.Action<JSONObject,JSONObject, string> onComplete)
    {
        yield return 0;
        string srcConfigFile = src + Constants.Config_File;
        string desConfigFile = des + Constants.Config_File;

        string error = null;

        JSONObject srcJson = null;
        JSONObject desJson = null;

        if ((isUpdate || Application.platform == RuntimePlatform.Android) && src != Constants.DownloadPath)
        {//从服务端更新 或者 是Android 平台,都需要用www
            #region 无超时判断, 不用了, 使用WWWReConnect代替
            //            WWW www = new WWW(srcConfigFile);
            //            yield return www;

            //            if (www.error != null)
            //            {//访问后台 或 Android下的 配置文件出错
            //#if UNITY_EDITOR
            //                error = "访问源目录下的配置文件出错@" + srcConfigFile + " : " + www.error;
            //#else
            //                error = "访问源目录下的配置文件出错@" + Constants.Config_File + " : " + www.error;
            //#endif
            //            }
            //            else
            //            {
            //                srcJson = new JSONObject(www.text);
            //            }
            #endregion 无超时判断, 不用了, 使用WWWReConnect代替


            CoroutineResult result = new CoroutineResult();
            yield return result.WWWReConnect(srcConfigFile);

            if (result._wwwResult != null && result._wwwResult.error == null)
            {
                srcJson = new JSONObject(result._wwwResult.text);
                if(!srcJson.IsAvailable()) error = "访问源目录下的配置文件出错@" + srcConfigFile + " : json 数据异常";
            }
            else
            {
#if UNITY_EDITOR
                error = "访问源目录下的配置文件出错@" + srcConfigFile + " : " + result.error;
#else
                error = "访问源目录下的配置文件出错@" + Constants.Config_File + " : " + result.error;
#endif
            }

        }
        else
        {//从StreamingAssets目录更新 并且不是Android 平台
            if (File.Exists(srcConfigFile))
                srcJson = new JSONObject(File.ReadAllText(srcConfigFile));
            else
#if UNITY_EDITOR
                error = "访问源目录下的配置文件出错@" + srcConfigFile;
#else
                error = "访问源目录下的配置文件出错@" + Constants.Config_File;
#endif
        }

        if (error != null)
        {
            if (onComplete != null) onComplete(null,null, error);
            yield break;
        }

        ////对配置文件的版本信息进行判断//采用更新地址与大版本号相关的方式,不比较版本号,直接从对应的版本号地址更新
        //if (isUpdate)
        //{//去后台更新资源的时候,大版本必须相同才能更新//Extract的配置文件没有版本号信息
        //    if (srcJson["version"].IsAvailable())
        //    {

        //        if (string.Compare(srcJson["version"].str, Application.version) != 0)
        //        {
        //            error = "debug_only:发现新版本,请下载最新版本";//这里的错误不在界面显示
        //        }
        //    }
        //    else
        //    {
        //        error = "debug_only:配置文件出错,缺少版本信息";//如果配置文件没有版本信息,就不进行更新
        //    }

        //    if (error != null)
        //    {
        //        if (onComplete != null) onComplete(null, error);
        //        yield break;
        //    }
        //}

        if (File.Exists(desConfigFile))//在输出目录下存在 配置文件
            desJson = new JSONObject(File.ReadAllText(desConfigFile));
        else//在输出目录下不存在配置文件
            desJson = null;

        //if(srcJson != null) srcJson.RemoveField("version");
        //if(desJson != null) desJson.RemoveField("version");
        double srcVersionTime = srcJson[Constants.InstantUpdate_VersionTime].n;
        double desVersionTime = desJson.IsAvailable() && desJson[Constants.InstantUpdate_VersionTime].IsAvailable() ? desJson[Constants.InstantUpdate_VersionTime].n : 0;
        if (des == Constants.DownloadPath)//Constants.DownloadPath地址进行判断
        {//热跟新下载的时候对版本时间进行判断, 如果不需要更新则不更新. 这样可以保证只更新最新版本,避免云端多个更新地址版本不一致,导致恶性循环下载问题.
            if (srcVersionTime < desVersionTime)
            {
                error = "源目录下的版本时间比目标目录下的版本时间小. 不进行更新";
                if (onComplete != null) onComplete(null,null, error);
                yield break;
            }

            if (File.Exists(Constants.ClickDownload_Config_download)) File.Delete(Constants.ClickDownload_Config_download);
            string clickDownload_Config_dir = Path.GetDirectoryName(Constants.ClickDownload_Config_download);
            if (!Directory.Exists(clickDownload_Config_dir)) Directory.CreateDirectory(clickDownload_Config_dir);
            File.WriteAllText(Constants.ClickDownload_Config_download, srcJson.ToString());//把静默热更新的版本配置文件保存到  Constants.ClickDownload_Config_download 中
        }
        //InstantUpdate_VersionTime = System.Convert.ToInt64(srcVersionTime);
        JSONObject srcReservedConfig = new JSONObject();//预留 时间和code
        srcReservedConfig[Constants.InstantUpdate_VersionTime] = srcJson[Constants.InstantUpdate_VersionTime];//预留versionTime
        srcReservedConfig[Constants.InstantUpdate_VersionCode] = srcJson[Constants.InstantUpdate_VersionCode];//预留versionCode
        //移除预留的key (不进行md5值的比较)
        srcJson.RemoveField(Constants.InstantUpdate_VersionTime);
        srcJson.RemoveField(Constants.InstantUpdate_VersionCode);

        if (desJson.IsAvailable()) desJson.RemoveField(Constants.InstantUpdate_VersionTime);
        if (onComplete != null) onComplete(CompareConfig(srcJson, desJson, gameModuleList), srcReservedConfig, null);
    }

    /// <summary>
    /// 比较配置文件的json,返回需要更新的json(该Json中的路径都是需要下载或者从StreamingAssets中复制的路径)
    /// </summary>
    /// <param name="srcJson"></param>
    /// <param name="desJson"></param>
    /// <param name="gameModuleList">如果该值为null 那么会更新所有配置文件中的模块,如果不为空那么只会更新该list 中有的模块,同时会忽略(不更新)该list中以:开头的模块(例如 :lua)</param>
    /// <returns></returns>
    private static JSONObject CompareConfig(JSONObject srcJson, JSONObject desJson, List<string> gameModuleList = null)
    {
        if (srcJson == null) return null;
        if (!desJson.IsAvailable() && gameModuleList == null) return srcJson;

        if(gameModuleList != null)
        {
            List<string> ignoreModuleList = gameModuleList.FindAll(a => a.StartsWith(":"));//冒号开头的代表忽略的模块,不进行更新
            gameModuleList.RemoveAll(a => a.StartsWith(":"));

            for (int i = 0; i < ignoreModuleList.Count; i++)
            {
                srcJson.RemoveField(ignoreModuleList[i].Substring(1));
            }
        }


        //JSONObject resultJson = new JSONObject();

        JSONObject srcJsonItem = null;
        JSONObject desJsonItem = null;
        List<string> srcKeys = new List<string>(srcJson.keys);
        foreach (var item in srcKeys)
        {
            //resultJson.AddField(item,new JSONObject());

            if (gameModuleList != null && gameModuleList.Count > 0)
            {//只需要更新 gameModuleList 中的模块即可
                if (!gameModuleList.Contains(item))
                {
                    srcJson.RemoveField(item);
                    continue;
                }
            }

            if (!desJson.IsAvailable() || !desJson[item].IsAvailable()) continue;

            srcJsonItem = srcJson[item];
            desJsonItem = desJson[item];

            List<string> srcItemkeys = new List<string>(srcJsonItem.keys);
            foreach (var key in srcItemkeys)
            {
                if (!desJsonItem[key].IsAvailable()) continue;
                if (srcJsonItem[key].str == desJsonItem[key].str || string.Compare(srcJsonItem[key].str, desJsonItem[key].str) == 0) srcJsonItem.RemoveField(key);
            }

            if (!srcJsonItem.IsAvailable()) srcJson.RemoveField(item);
        }

        return srcJson;
    }
    #endregion 比较配置文件,获得需要更新或者复制的文件的路径

    /// <summary>
    /// 更新所有需要更新的文件
    /// </summary>
    /// <param name="src"></param>
    /// <param name="des"></param>
    /// <param name="config"></param>
    /// <param name="onComplete"></param>
    /// <param name="isUpdate">true: 从后台更新, false 从StreamingAssets 目录更新</param>
    public static void UpdateFiles(this MonoBehaviour mono, string src, string des, JSONObject config,JSONObject srcReservedConfig, bool isUpdate, System.Action<string, long, long> onProgressChanged, System.Action<string, JSONObject> onComplete)
    {
        ConfigUpdater updater = null;
        //if (isUpdate) updater = new DownloadConfigUpdater();
        if (isUpdate) updater = new WWWConfigUpdater();
        else updater = new ExtractConfigUpdater();

        updater.Update(mono, src, des, config, onProgressChanged, (resultConfig, error) =>
        {
            UpdateConfig(des, resultConfig, srcReservedConfig);
            if (onComplete != null) onComplete(error, config);
        });
    }

    /// <summary>
    /// 更新配置文件
    /// </summary>
    public static void UpdateConfig(string des, JSONObject config, JSONObject srcReservedConfig)
    {
        if (!config.IsAvailable()) return;
        string desConfigFile = des + Constants.Config_File;
        JSONObject desJson = null;

        if (File.Exists(desConfigFile))//在输出目录下存在 配置文件
            desJson = new JSONObject(File.ReadAllText(desConfigFile));
        else//在输出目录下不存在配置文件
            desJson = null;

        if (!desJson.IsAvailable()) desJson = config;
        else
        {
            foreach (var item in new List<string>(config.keys))
            {
                if (!desJson[item].IsAvailable()) desJson[item] = config[item];
                else
                {
                    foreach (var key in new List<string>(config[item].keys))
                    {
                        desJson[item][key] = config[item][key];
                    }
                }
            }

            //foreach (var item in config.keys)
            //{
            //    if (!desJson[item].IsAvailable()) desJson[item] = config[item];
            //    foreach (var key in config[item].keys)//这里报错:InvalidOperationException: Collection was modified; enumeration operation may not execute. //原因不明//使用上面的方法就没有问题
            //    {
            //        desJson[item][key] = config[item][key];
            //    }
            //}
        }

        desJson.SetField(Constants.InstantUpdate_VersionTime, srcReservedConfig[Constants.InstantUpdate_VersionTime]);//对预留的 versionTime 进行更新
        desJson.SetField(Constants.InstantUpdate_VersionCode, srcReservedConfig[Constants.InstantUpdate_VersionCode]);//对预留的 versionCode 进行更新
        File.WriteAllText(desConfigFile, desJson.ToString());
    }

    #region 对上面的分步流程进行封装
    public static void UpdateGameModules(this MonoBehaviour mono, string src, string des, List<string> gameModuleList, bool isUpdate, System.Action<string, long, long> onProcess, System.Action<string, JSONObject> onComplete)
    {
        mono.CompareConfig(src, des, gameModuleList, isUpdate, (config,srcReservedConfig, error) =>
        {

            if (error != null)
            {
                if (onComplete != null) onComplete(error, null);
            }
            else
            {
                mono.UpdateFiles(src, des, config, srcReservedConfig, isUpdate, onProcess, onComplete);
            }
        });
    }

    public static void UpdateInstantUpdateConfig(this MonoBehaviour mono,  List<string> gameModuleList, System.Action<string, JSONObject> onComplete)
    {
        string src = Constants.DownloadPath;// + Constants.Config_File;
        string des = Constants.DataPath;// + Constants.Config_File;
        //System.Action<string, long, long> onProcess = null;
        bool isUpdate = false;
        mono.CompareConfig(src, des, gameModuleList, isUpdate, (config, srcReservedConfig, error) =>
        {

            if (error != null)
            {
                if (onComplete != null) onComplete(error, null);
            }
            else
            {
                //mono.UpdateFiles(src, des, config, srcReservedConfig, isUpdate, onProcess, onComplete);
                UpdateConfig(des, config, srcReservedConfig);
                if (onComplete != null) onComplete(null, config);
            }
        });
    }

    /// <summary>
    /// 使用在Constants中配置的路径
    /// </summary>
    /// <param name="mono"></param>
    /// <param name="gameModuleList"></param>
    /// <param name="isUpdate"></param>
    /// <param name="onProcess"></param>
    /// <param name="onComplete"></param>
    public static void UpdateGameModules(this MonoBehaviour mono, List<string> gameModuleList, bool isUpdate, System.Action<string, long, long> onProcess, System.Action<string, JSONObject> onComplete)
    {
        string src = isUpdate ? Constants.UpdateUrl : Constants.StreamingAssetsDataPath;
        string des = Constants.DataPath;

        if (isUpdate)
        {//热更新 阿里云 上的资源的情况
            int localVersionCode = GetLocalVersionControlCode();
            src = InsertUpdateUrlWithVersionCode(src, localVersionCode + "");

            mono.UpdateGameModules(src, des, gameModuleList, isUpdate, onProcess, (error,config)=> {//进行点击下载的时候,如果出现下载错误, 就重新下载
                if(error != null)
                {
                    Debug.LogError("下载出错了 : " + error);

                    mono.Delay(15f, () => mono.UpdateGameModules(gameModuleList, isUpdate,onProcess,onComplete));//如果下载出错了 没有下载完,那么重新下载
                }
                else
                {
                    if (onComplete != null) onComplete(error,config);
                }
            });
        }
        else
        {//解压的情况
            mono.UpdateGameModules(src, des, gameModuleList, isUpdate, onProcess, onComplete);
        }
    }

    public static void DownloadCloudAssets(this MonoBehaviour mono, System.Action<string, long, long> onProcess, System.Action<string, bool> onComplete)
    {
        string src = Constants.UpdateUrl;//调用热更新地址是会自动切换地址
        string des = Constants.DownloadPath;

        GetVersionUpdateControl((versionCode)=> {
#if UNITY_EDITOR
            if (SimpleFramework.Manager.GameManager._VersionControl_ali > 0)
                versionCode = SimpleFramework.Manager.GameManager._VersionControl_ali;
#endif

            if (versionCode <= 0)
            {//versionCode > 0 才是有效的
                Debug.LogError("下载出错了 : 阿里云上的版本号为 0");

                mono.Delay(30f, () => mono.DownloadCloudAssets(onProcess, onComplete));//如果下载出错了 没有下载完,那么重新下载
            }
            else
            {
                //JSONObject localConfig = GetLocalConfigJson(Constants.DataPath);
                //int localVersionCode = System.Convert.ToInt32(localConfig[Constants.InstantUpdate_VersionCode]);
                //if (localVersionCode == versionCode)
                //{//版本号相同, 不用热更新
                //    onComplete(null, false);
                //    return;
                //}

                //localConfig.RemoveField(Constants.InstantUpdate_VersionTime);
                //localConfig.RemoveField(Constants.InstantUpdate_VersionCode);
                //List<string> localGameModuleList = localConfig.keys;
                List<string> localGameModuleList = GetLocalModuleList();

                src = InsertUpdateUrlWithVersionCode(src,versionCode+"");//插入 热更新版本号

                if (!File.Exists(des + Constants.Config_File)) Copy(Constants.DataPath + Constants.Config_File, des);
                mono.UpdateGameModules(src, des, localGameModuleList, true, onProcess, (error, config) =>
                {
                    if (error != null)
                    {
                        Debug.LogError("下载出错了 : " + error);

                        mono.Delay(30f, () => mono.DownloadCloudAssets(onProcess, onComplete));//如果下载出错了 没有下载完,那么重新下载
                    }
                    else
                    {
                        //if (config.IsAvailable()) //有需要更新的资源
                        //    mono.StartCoroutine(mono.DoCheckDownloadComplete(src,des,onProcess, onComplete));
                        //else //没有需要更新的资源
                        //    if (onComplete != null) onComplete(null,false);//无资源更新,第二个参数为false
                        if(onComplete != null) onComplete(null, config.IsAvailable());
                    }
                });
            }

        });
    }

    #region 不采用这种方法
    /// <summary>
    /// 通过重新比较后台的配置文件来判断下载过程中后台的资源没有发生改变
    /// </summary>
    /// <param name="mono"></param>
    /// <param name="src"></param>
    /// <param name="des"></param>
    /// <param name="onProcess"></param>
    /// <param name="onComplete"></param>
    /// <returns></returns>
    //private static IEnumerator DoCheckDownloadComplete(this MonoBehaviour mono, string src, string des, System.Action<string, long, long> onProcess, System.Action<string, bool> onComplete)
    //{
    //    string srcConfigFile = src + Constants.Config_File;
    //    string desConfigFile = des + Constants.Config_File;
    //    WWW www = new WWW(srcConfigFile);
    //    yield return www;

    //    if (www.error != null)
    //    {//访问后台 或 Android下的 配置文件出错
    //        //error = "访问源目录下的配置文件出错@" + srcConfigFile + " : " + www.error;
    //        mono.DownloadCloudAssets(onProcess, onComplete);//重新下载
    //    }
    //    else
    //    {
    //        //srcJson = new JSONObject(www.text);
    //        string desTxt = string.Empty;

    //        if (File.Exists(desConfigFile))
    //            desTxt = File.ReadAllText(desConfigFile);

    //        JSONObject resultJson = CompareConfig(new JSONObject(www.text), new JSONObject(desTxt));

    //        if (!resultJson.IsAvailable())
    //            if (onComplete != null) onComplete(null, true);
    //            else mono.DownloadCloudAssets(onProcess, onComplete);
    //    }
    //}
    #endregion 不采用这种方法

    public static void ExtractGame(this MonoBehaviour mono, System.Action<string, JSONObject> onComplete, List<string> gameModuleList = null)
    {
        mono.UpdateGameModules(gameModuleList, false, null, onComplete);
    }
    #endregion 对上面的分步流程进行封装

    #region 对热更新相关内容进行升级 相关方法区
    /// <summary>
    /// 从 ali 云 获取热更新版本号
    /// </summary>
    /// <param name="onComplete"></param>
    public static void GetVersionUpdateControl(System.Action<int> onComplete)
    {
        MonoBehaviour mono = null;
        CoroutineResult result = new CoroutineResult();

        IEnumerator enumerator = result.WWWReConnect(Constants.UpdateVersionControlUrl, () =>
        {
            int InstantUpdate_UpdateVersionControlCode = 0;
            if (result._wwwResult != null && result._wwwResult.error == null)
            {
                int.TryParse(result._wwwResult.text, out InstantUpdate_UpdateVersionControlCode);
            }
            if (onComplete != null) onComplete(InstantUpdate_UpdateVersionControlCode);
        });

        if (Application.isPlaying)
        {
            mono = GetGameManager();
            mono.StartCoroutine(enumerator);
        }
        else
        {
            while (enumerator.MoveNext()) ;
        }
    }

    /// <summary>
    /// 在原来的下载地址中 插入 热更新版本号
    /// 例子: http://oss.aliyuncs.com/ggdownload/game597/InstantUpdate/Android/version_5.0/StreamingAssets/
    /// 添加上版本号以后是:
    ///       http://oss.aliyuncs.com/ggdownload/game597/InstantUpdate/Android/version_5.0/1/StreamingAssets/
    /// 注: 原来热更新版本中 不需要添加热更新版本号, 现在 添加了点击下载功能后, 需要考虑 手机上当前的 如果新版本号
    /// </summary>
    /// <param name="srcUrl"></param>
    /// <param name="versionCode"></param>
    /// <returns></returns>
    public static string InsertUpdateUrlWithVersionCode(string srcUrl, string versionCode)
    {
        return srcUrl.Insert(srcUrl.LastIndexOf(Constants.DirName), "/" + versionCode);
    }

    public static JSONObject GetLocalConfigJson(string dir)
    {
        string desConfigFile = dir + Constants.Config_File;
        JSONObject desJson = new JSONObject();
        if (File.Exists(desConfigFile))//在输出目录下存在 配置文件
            desJson = new JSONObject(File.ReadAllText(desConfigFile));
        //else//在输出目录下不存在配置文件
        //    desJson = null;
        return desJson;
    }

    public static int GetLocalVersionControlCode()
    {
        JSONObject localConfig = GetLocalConfigJson(Constants.DataPath);

        double result_n = localConfig[Constants.InstantUpdate_VersionCode].n;
        int result = System.Convert.ToInt32(result_n);// 这里要注意 不要把 JSONObject 类型 传进去

        return result;
    }

    public static List<string> GetLocalModuleList()
    {
        JSONObject localConfig = GetLocalConfigJson(Constants.DataPath);
        localConfig.RemoveField(Constants.InstantUpdate_VersionTime);
        localConfig.RemoveField(Constants.InstantUpdate_VersionCode);
        List<string> resultList = localConfig.keys;
        if (!resultList.Contains("lua")) resultList.Add("lua");//由于lua模块在解压的时候特殊处理了, 就没有按照原来的config进行解压, 这里获取的时候需要添加回去.
        return resultList;
    }

    //public static string ReplaceUpdateUrlWithVersionCode(string srcUrl, string versionCode)
    //{
    //    return srcUrl.Replace("/"+InstantUpdate_UpdateVersionControlCode +"/","/"+versionCode+"/");
    //}
    #endregion 对热更新相关内容进行升级 相关方法区

    #region 过时了, 使用下面的方法代替
    ///// <summary>
    ///// 检测配置文件中的所有文件是否都存在
    ///// </summary>
    ///// <param name="gameModuleList"></param>
    ///// <returns></returns>
    //public static List<string> CheckGameModulesExist(List<string> gameModuleList)
    //{
    //    string srcPath = Constants.DataPath;
    //    string srcFile = srcPath + Constants.Config_File;
    //    if (File.Exists(srcFile))
    //    {
    //        JSONObject srcJson = new JSONObject(File.ReadAllText(srcFile));
    //        string filePath = string.Empty;
    //        foreach (var item in new List<string>(gameModuleList))
    //        {
    //            bool isAllExist = true;// 用于标记该模块下的所有文件是否存在
    //            if (srcJson[item].IsAvailable())
    //            {
    //                foreach (var path in srcJson[item].keys)
    //                {
    //                    if (File.Exists(srcPath + CheckRelativeUrl(item, path))) continue;
    //                    else
    //                    {//有一个文件不存在,说明该模块的数据不完整,需要更新
    //                        //gameModuleList.Remove(item);
    //                        isAllExist = false;
    //                        break;
    //                    }
    //                }

    //                if (isAllExist) gameModuleList.Remove(item);
    //            }
    //        }
    //    }

    //    return gameModuleList;
    //}
    #endregion 过时了, 使用下面的方法代替

    /// <summary>
    /// 检测点击的时候 需要更新的模块
    /// 取代上面的方法
    /// </summary>
    /// <param name="gameModuleList"></param>
    /// <returns></returns>
    public static List<string> CheckGameModulesExist(List<string> gameModuleList)
    {
        string srcFile = Constants.ClickDownload_Config_data;
        string desPath = Constants.DataPath;
        string desFile = desPath + Constants.Config_File;

        JSONObject srcJson = null;
        JSONObject desJson = new JSONObject();

        if (File.Exists(srcFile))
            srcJson = new JSONObject(File.ReadAllText(srcFile));
        else UnityEngine.Debug.LogError("ck debug : -------------------------------- CheckGameModulesExist srcFile does not exist = ");
        
        if (File.Exists(desFile))
            desJson = new JSONObject(File.ReadAllText(desFile));
        else UnityEngine.Debug.LogError("ck debug : -------------------------------- CheckGameModulesExist desFile does not exist = ");

        srcJson.RemoveField(Constants.InstantUpdate_VersionTime);
        srcJson.RemoveField(Constants.InstantUpdate_VersionCode);

        JSONObject resultJson = CompareConfig(srcJson,desJson,gameModuleList);

        gameModuleList = resultJson.keys;
        UnityEngine.Debug.Log("ck debug : --------------------------------<color=red> CheckGameModulesExist result </color>= " + string.Join(",", gameModuleList.ToArray()));

        return gameModuleList;
    }

    public static string CheckRelativeUrl(string gameModule, string relativePath)
    {
        return string.IsNullOrEmpty(gameModule) ? relativePath : gameModule + "/" + relativePath;
    }
    #endregion 使用json作为配置文件,一次性比较所有模块中的文件变化,统一(使用ConfigUpdater)更新和解压(StreamingAssets目录下的资源),更新后更新(不直接覆盖)配置文件


    #region 文件IO相关
    public static void Copy(string src, string des)
    {
        if (!Directory.Exists(des)) Directory.CreateDirectory(des);
        string fileName = Path.GetFileName(src);
        string newDes = Path.Combine(des, fileName);

        if (Directory.Exists(src))
        {
            //if (!Directory.Exists(newDes)) Directory.CreateDirectory(newDes);
            foreach (var item in Directory.GetFileSystemEntries(src))
            {
                Copy(item, newDes);
            }
        }
        else if (File.Exists(src))
        {
            File.Copy(src, newDes, true);
        }
        else
        {
            throw new Exception("path : " + src + "is neighter a file or directory");
        }
    }

    public static void Cut(string src, string des)
    {
        Move(src, des);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="src">如果该目录以 / 结尾,那么该目录下(不包含该目录)的所有资源会移动到des. 如果该目录不是以 / 结尾,那么该目录(包含该目录)和该目录下的所有资源都会移动到des下</param>
    /// <param name="des"></param>
    public static void Move(string src, string des)
    {
        if (!Directory.Exists(des)) Directory.CreateDirectory(des);
        string fileName = Path.GetFileName(src);
        string newDes = Path.Combine(des, fileName);

        if (Directory.Exists(src))
        {
            foreach (var item in Directory.GetFileSystemEntries(src))
            {
                Move(item, newDes);
            }
            Directory.Delete(src, true);
        }
        else if (File.Exists(src))
        {
            if (File.Exists(newDes)) File.Delete(newDes);
            File.Move(src, newDes);
            new FileInfo(src).Delete();
        }
        else
        {
            throw new Exception("path : " + src + "is neighter a file or directory");
        }
    }
    #endregion 文件IO相关

    #region 加密解密相关
    #region 不用这种方法
    //public static void Encrypt(string path)
    //{
    //    if (File.Exists(path))
    //    {
    //        byte[] bytes = File.ReadAllBytes(path);
    //        if (bytes.Length <= 0) return;
    //        bytes[0] += 1;

    //        File.WriteAllBytes(path, bytes);
    //    }
    //    else throw new System.Exception("File : " + path + " is not exist!!!");
    //}

    //public static void Decrypt(string path)
    //{
    //    if (File.Exists(path))
    //    {
    //        byte[] bytes = File.ReadAllBytes(path);
    //        if (bytes.Length <= 0) return;
    //        bytes[0] -= 1;

    //        File.WriteAllBytes(path, bytes);
    //    }
    //    else throw new System.Exception("File : " + path + " is not exist!!!");
    //}

    //public static byte[] Encrypt(byte[] bytes)
    //{
    //    if (bytes.Length <= 0) return bytes;
    //    bytes[0] += 1;
    //    return bytes;
    //}

    //public static byte[] Decrypt(byte[] bytes)
    //{
    //    if (bytes.Length <= 0) return bytes;
    //    bytes[0] -= 1;
    //    return bytes;
    //}
    #endregion 不用这种方法

    public static void Crypt(string path)
    {
        if (File.Exists(path))
        {
            byte[] bytes = File.ReadAllBytes(path);
            if (bytes.Length <= 0) return;
            bytes[0] = (byte)~bytes[0];

            File.WriteAllBytes(path, bytes);
        }
        else throw new System.Exception("File : " + path + " is not exist!!!");
    }

    public static byte[] Crypt(byte[] bytes)
    {
        if (bytes.Length <= 0) return bytes;
        bytes[0] = (byte)~bytes[0];
        return bytes;
    }


    public static string md5(string file)
    {
        byte[] bytes = File.ReadAllBytes(file);
        return md5(bytes);
    }

    public static string md5(byte[] bytes)
    {
        try
        {
            //FileStream fs = new FileStream(file, FileMode.Open);
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(bytes);
            //fs.Close();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex)
        {
            throw new Exception("md5file() fail, error:" + ex.Message);
        }
    }
    #endregion 加密解密相关

    #region playerprefs 相关方法

    public static void SetDownloadCloudAssetsComplete(bool isComplete)
    {
        PlayerPrefs.SetInt("_isDownloadCloudAssetsComplete", isComplete ? 1 : 0);
        PlayerPrefs.Save();
    }

    public static bool GetDownloadCloudAssetComplete()
    {
        return PlayerPrefs.GetInt("_isDownloadCloudAssetsComplete") == 1;
    }
    #endregion playerprefs 相关方法

    #region www类扩展方法
    /// <summary>
    /// 异步释放www
    /// </summary>
    /// <param name="www"></param>
    public static void DisposeAsync(this WWW www)
    {
        if (www == null) return;

        System.Threading.ParameterizedThreadStart dispose = w => {
            try
            {
                if (w is WWW)
                {
                    ((WWW)w).Dispose();//www的dispose 方法 比较耗时,在协程中释放会卡住主线程
                }
            }
            catch (Exception e)
            {
                if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ DisposeAsync() : " + e.Message);
            }
        };

#if UNITY_STANDALONE_OSX || UNITY_EDITOR_OSX
		dispose(www);
#else
        new System.Threading.Thread(dispose).Start(www);
#endif
    }

    /// <summary>
    /// 给WWW 添加超时判断
    /// </summary>
    /// <param name="www"></param>
    /// <param name="onTimeOutAction"></param>
    /// <param name="result"> 该www访问的结果</param>
    /// <param name="TimeOut"></param>
    /// <returns></returns>
    public static IEnumerator CheckTimeOut(WWW www, System.Action onTimeOutAction, CoroutineResult result = null, float TimeOut = 20f)
    {
        if (result != null) result.error = null;
        float curTime = 0;
        bool is_www_disposed = false;
        if (www == null) yield break;

        //出错方法
        System.Action<string> onError = (errorStr) =>
        {
            if (string.IsNullOrEmpty(errorStr)) return;
            if (result != null)
            {
                result.error = errorStr;
                result._wwwResult = null; 
            }
            if (!is_www_disposed) www.DisposeAsync();//释放www
        };

        System.Func<bool> www_isDone_func = () =>
        {
            try
            {
                return www.isDone;
            }
            catch (Exception e)
            {
                if (Constants.isEditor) Debug.Log("<color=red>www_isDone_func : " + e.Message+"</color>");
                is_www_disposed = true;
                onError("www has been disposed");
                return false;
            }
        };

        //超时判断
        while (!www_isDone_func() && !is_www_disposed)
        {
            curTime += Time.deltaTime;
            if (curTime > TimeOut)
            {
                onError("TimeOut");
                if (onTimeOutAction != null) onTimeOutAction();
                yield break;
            }

            yield return 0;
        }

        //www访问出错判断
        if (!is_www_disposed) onError(www.error);
    }

    /// <summary>
    /// 在连接一个url的时候,如果连接超时或者连接不同的情况下,就进行重连
    /// 该方法执行完成后,如果 result.error 为空,那么 result._wwwResult 不为空. 如果 result.error 不为空,那么 result._wwwResult 为空,并且释放result._wwwResult
    /// 因此使用result._wwwResult前一定要判断 error
    /// </summary>
    /// <param name="url">连接地址</param>
    /// <param name="result">如果超时,那么result.error = "TimeOut", 如果连接失败,那么  result._wwwResult.error 不为空. 如果该值为空,那么该方法将直接抛出异常</param>
    /// <param name="TimeOut">超时时间</param>
    /// <param name="reconnectCount">重连次数,如果该值小于0,将不会进行连接</param>
    /// <returns></returns>
    public static IEnumerator WWWReConnect(this CoroutineResult result, string url, System.Action onComplete = null, float TimeOut = 8f, int reconnectCount = 1)
    {

        if (result == null) throw new System.Exception("the argument result of type CoroutineResult cannot be null");
        int curReconnectTime = 0;
        WWW www_config = null;
        while (curReconnectTime <= reconnectCount)
        {
            curReconnectTime++;


#if UNITY_STANDALONE_OSX || UNITY_EDITOR_OSX
//#else
            if(!url.StartsWith("file:///")){
                int statusCode = -1;
                new System.Threading.Thread(()=> {
                    statusCode = CheckHttpStatusCode(url, (int)TimeOut * 1000);
                }).Start();

                float timeOut = 0;
		        while(statusCode < 0){
			        timeOut += Time.deltaTime;
			        if(timeOut > TimeOut) break;
			        yield return 0;
		        }

                if (statusCode != 200)
                {
                    result.error = "status code is not 200";
                    continue;
                }
            }
#endif

            www_config = HttpConnect.Instance.HttpRequestAli(url);
            result.error = null; 
            result._wwwResult = www_config; 

            yield return StaticUtils.CheckTimeOut(www_config, null, result, TimeOut);//访问出错的信息会在CheckTimeOut方法内赋值给result
            
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {//在编辑器中, 游戏没有运行的情况下 yield return 无法有效执行. 这里用于替代上面的超时判断
                int tempTimeOut = (int)TimeOut * 1000;
                while(result._wwwResult != null && !result._wwwResult.isDone)
                {
                    System.Threading.Thread.Sleep(30);
                    tempTimeOut -= 30;
                    if (tempTimeOut < 0) break;
                }
            }
#endif

            if (result.error == null && www_config.error == null) break;//正常连接,获取数据后直接跳出循环
        } 
        if (onComplete != null) onComplete();
    }

    public static int CheckHttpStatusCode(string url, int timeout)
    {
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
        req.Timeout = Math.Max(timeout,5000) ;
        HttpWebResponse resp = null;
        try
        {
            resp = (HttpWebResponse)req.GetResponse();
        }
        catch (System.Exception ex)
        {
        }

        return resp == null ? 0 : (int) resp.StatusCode;
    }
    #endregion www类扩展方法

    #region 对泛型 List 的功能扩展
    public static void AddRange_Raw<T>(this List<T> source, List<T> collection)
    {
        if (source == null || collection == null) return;
        for (int i = 0; i < collection.Count; i++)
        {
            if (!source.Contains(collection[i])) source.Add(collection[i]);
        }
    }

    public static void Add_Raw<T>(this List<T> source, T addItem)
    {
        if (source == null || addItem == null) return;
        if (!source.Contains(addItem)) source.Add(addItem);
    }
    #endregion 对泛型 List 的功能扩展

    #region 对协程功能的扩展
    #region 协程的并联功能
    public static Coroutine Start_Coroutine(this MonoBehaviour mono, IEnumerator routine, System.Action onComplete = null)
    {
        return mono.Start_Coroutine(mono.StartCoroutine(routine), onComplete);
    }

    /// <summary>
    /// 添加了coroutine运行完成后的回调
    /// </summary>
    /// <param name="mono"></param>
    /// <param name="coroutine"></param>
    /// <param name="onComplete"></param>
    /// <returns></returns>
    public static Coroutine Start_Coroutine(this MonoBehaviour mono, Coroutine coroutine, System.Action onComplete = null)
    {
        return mono.StartCoroutine(StartCoroutine_internal(coroutine, onComplete));
    }

    private static IEnumerator StartCoroutine_internal(Coroutine coroutine, System.Action onComplete = null)
    {
        if (coroutine == null)
        {
            if (onComplete != null) onComplete();
            yield break;
        }

        yield return coroutine;
        if (onComplete != null) onComplete();
    }



    public static Coroutine Start_Coroutine(this MonoBehaviour mono, System.Action onComplete, params IEnumerator[] routines)
    {
        Coroutine[] coroutines = new Coroutine[routines.Length];

        for (int i = 0; i < routines.Length; i++)
        {
            coroutines[i] = routines[i] == null ? null : mono.StartCoroutine(routines[i]);
        }

        return mono.Start_Coroutine(onComplete, coroutines);
    }

    /// <summary>
    /// 在所有coroutine都执行完成后,该协程才完成运行
    /// 用于同时启动多个协程,并且这些协程都完成后才继续向下执行的功能扩展
    /// </summary>
    /// <param name="mono"></param>
    /// <param name="onComplete"></param>
    /// <param name="routines"></param>
    /// <returns></returns>
    public static Coroutine Start_Coroutine(this MonoBehaviour mono, System.Action onComplete, params Coroutine[] routines)
    {
        return mono.StartCoroutine(StartCoroutine_internal(mono, onComplete, routines));
    }

    private static IEnumerator StartCoroutine_internal(MonoBehaviour mono, System.Action onComplete, params Coroutine[] routines)
    {
        if (routines == null || routines.Length == 0)
        {
            if (onComplete != null) onComplete();
            yield break;
        }

        int completeCount = 0;
        for (int i = 0; i < routines.Length; i++)
        {
            mono.Start_Coroutine(routines[i], () => ++completeCount);
        }

        CompleteMode mode = CompleteMode.All;//目前没有放在参数上

        if (mode == CompleteMode.Single)//单个完成就算全部完成
        {
            while (completeCount < 1)
                yield return 0;
        }
        else if (mode == CompleteMode.All)//全部都完成才算完成
        {
            while (completeCount < routines.Length)
                yield return 0;
        }

        //停止所有协程
        for (int i = 0; i < routines.Length; i++)
        {
            if(mono && routines[i] != null)mono.StopCoroutine(routines[i]);
        }

        if (onComplete != null) onComplete();
    }
    #endregion 协程的并联功能

    #region Delay的封装
    public static Coroutine Delay(this MonoBehaviour mono, float time, System.Action onComplete)
    {
        return mono.StartCoroutine(Delay(time, onComplete));
    }
    private static IEnumerator Delay(float time, System.Action onComplete)
    {
        yield return new WaitForSeconds(time);
        if (onComplete != null) onComplete();
    }
    #endregion Delay的封装
    #endregion 对协程功能的扩展


    public static Ping ObtainPingFromUrl(string url)
    {
        try
        {
            System.Uri uri = new System.Uri(url);
            string host = uri.DnsSafeHost;

            IPAddress ipAddress = null;
            if (IPAddress.TryParse(host, out ipAddress)) { }
            else ipAddress = Dns.GetHostEntry(host).AddressList[0];

            return new Ping(ipAddress.ToString());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    public static bool IsAvailable(this JSONObject json)
    {
        return json != null && json.type != JSONObject.Type.NULL && string.Compare(json.print(), "null") != 0;
    }

    public static SimpleFramework.Manager.GameManager GetGameManager()
    {
        //System.Net.HttpWebRequest
        //System.Net.HttpWebResponse
        return AppFacade.Instance.GetManager<SimpleFramework.Manager.GameManager>(SimpleFramework.ManagerName.Game);
    }


    /// <summary>
    /// Lua中等待C#中协程开始函数
    /// </summary>
    /// <param name="coroutine">C#中要运行的协程</param> 
    public static void StartCoroutineLuaToC(IEnumerator coroutine, DoneCoroutine done)
    {
        StaticUtils.GetGameManager().StartCoroutine(CoroutineLuaToC(coroutine, done));
    }
    public static void StartCoroutineLuaToC(IEnumerator coroutine)
    {
        StaticUtils.GetGameManager().StartCoroutine(coroutine);
    }
    static IEnumerator CoroutineLuaToC(IEnumerator coroutine, DoneCoroutine done)
    {
        yield return StaticUtils.GetGameManager().StartCoroutine(coroutine);
        done.isDoneCoroutine = true;
    }

    
}

public enum CompleteMode
{
    Single,//单个完成即全部都完成
    All//全部完成才算完成
}