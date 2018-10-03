//#define __HappyCity_510k
#if Platform_510k
#define __HappyCity_510k
#else
#endif
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using LuaInterface;
using System.Security.Cryptography;
using System; 
//#if UNITY_EDITOR || UNITY_STANDALONE
using UnityEngine.SceneManagement;
//#endif

 

 
public static class Utils
{
    #region 版本与打包相关内容
    private static GameEntity game = new GameEntityAll();
    public static string bundleId
    {
        get
        {
            return game.BundleId;
        }
    }

    public static string version
    {
        get
        {
            return game.VersionName;
        }
    }
    public static int VersionCode
    {
        get
        {
            return game.VersionCode;
        }
    }

    public static string GameName
    {
        get
        {
            return game.GameName;
        }
    }

    public static string Agent_Id {get {return agent_Id;}}
    private static string agent_Id ="";//"4716";

    public static BuildPlatform BUILDPLATFORM
    {
        get
        {
            return
#if UNITY_IPHONE
#if _IsEnterprise//企业版
        BuildPlatform.IOS_Enterprise;
#else//ios app stroe
        BuildPlatform.IOS_AppStore;
#endif
#elif UNITY_STANDALONE_OSX
        BuildPlatform.OSX;
#else//android 
    BuildPlatform.Android;
#endif
        }
    }
    #endregion 版本与打包相关内容

#if __HappyCity_510k
    public static string HallName = "__HappyCity_510k";
    public static string _hallResourcesName = "happycity_510k";
#elif __HappyCity_597New
    public static string HallName = "__HappyCity_597New";
    public static string _hallResourcesName = "happycity_597new";
#elif __HappyCity_597GD
    public static string HallName = "__HappyCity_597GD";
    public static string _hallResourcesName = "happycity_597gd";
#else
    public static string HallName = "__HappyCity";
    public static string _hallResourcesName = "happycity";

#endif

#if Platform_597wangwei // Game1977   747   597
    public static string PlayformName = "PlatformGame597";
#elif Platform_131     // game1517 407 131
    public static string PlayformName = "PlatformGame407";
#elif Platform_510k // game510k
    public static string PlayformName = "PlatformGame510k";
#elif Platform_7997    // Game7997
    public static string PlayformName = "PlatformGame7997";
#else //Platform_597
    public static string PlayformName = "PlatformGame1977"; 
#endif 
 
#if _IsFish
    public static bool _IsFish = true;
#else
    public static bool _IsFish = false;
#endif

#if _IPTest
	public static bool _IsIPTest = true;
#else
    public static bool _IsIPTest = false;
#endif

#if _IPTest2
public static bool _IsIPTest2 = true;
#else
public static bool _IsIPTest2 = false;
#endif

#if _TestAgreement
public static bool _IsTestAgreement = true;
#else
public static bool _IsTestAgreement = false;
#endif

#if _LocalServer
	public static bool isLocalServer = true;
#else
	public static bool isLocalServer = false;
#endif

    //控制热更新功能 的开启和关闭
#if _IsNoInstantUpdate
    public static bool _IsNoInstantUpdate = true;
#else
    public static bool _IsNoInstantUpdate = false;
#endif

    //控制所有微信相关内容的显示
#if _IsNoWeChat
    public static bool _IsNoWeChat = true;
#else
    public static bool _IsNoWeChat = false;
#endif

    //打包控制,发布单个包
#if _SingleGame
    public static bool _SingleGame = true;
#else
    public static bool _SingleGame = false;
#endif
    //开发中使用单个游戏的大厅
    public static bool _IsSingleGame = false;

 	//当前版本是否可用控制判断
public static bool IsVersionUsable(string _version)
{
	float _versionF;
	float presentF;
	if (float.TryParse(_version, out _versionF) && float.TryParse(Utils.version, out presentF))
	{ 
		if(_versionF <= presentF)
		{
			return true;
		} 
	} 
	return false;
}

    public static object NullObj = null;
#region 请求网络的封装
    public static void Request(this MonoBehaviour host, string url, WWWForm form, System.Action<string> onSuccessAction, System.Action<string> onFailAction = null)
    {
        host.StartCoroutine(DoRequest(url, form, onSuccessAction, onFailAction,true,true));
    }

    public static void Request(this MonoBehaviour host, string url, WWWForm form, System.Action<string> onSuccessAction, System.Action<string> onFailAction, bool isShowWait, bool isShowError)
    {
        host.StartCoroutine(DoRequest(url, form, onSuccessAction, onFailAction, isShowWait, isShowError));
    }

    private static IEnumerator DoRequest(string url, WWWForm form, System.Action<string> onSuccessAction, System.Action<string> onFailAction, bool isShowWait = true, bool isShowError = true)
    {
        if (isShowWait) EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
        //		string url = "http://112.74.205.73/client_unity/bag_list/";
        //		WWWForm form = new WWWForm();
        //		WWW www = HttpConnect.Instance.HttpRequestWithSession(url,null);

        WWW www = HttpConnect.Instance.HttpRequestWithSession(url, form);
        yield return www;

        HttpResult result = HttpConnect.Instance.BaseResult(www);

        if (isShowWait) EginProgressHUD.Instance.HideHUD();
        if (HttpResult.ResultType.Sucess == result.resultType)
        {
            if (onSuccessAction != null) onSuccessAction(result.resultObject.ToString());
        }
        else
        {
            if (onFailAction != null) onFailAction(result.resultObject.ToString());
            if (isShowError) EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
        }
    }
#endregion 请求网络的封装

#region 加载场景相关
    /// <summary>
    /// 添加新的界面(切换场景)
    /// </summary>
    /// <param name="name">场景名称(主界面)名称</param>
    /// <param name="isGame">true: 使用GameLua, false: 使用LuaBehaviour</param>
    /// <param name="isAdditive">true: 使用在当前场景添加新的界面, false: 切换新场景</param>
    public static void LoadLevelGUI(string name,bool isGame, bool isAdditive)
    {
        //if(!isAdditive) Application.LoadLevel("nil");
        SimpleFramework.LuaHelper.GetPanelManager().CreatePanel(name,isGame, isAdditive);
    }

    public static void LoadLevelGUI(string name)
    {
        LoadLevelGUI(name,false,false);
    }

    /// <summary>
    /// 添加 LuaBehaviour
    /// </summary>
    /// <param name="name"></param>
    public static void LoadLevelAdditiveGUI(string name)
    {
        LoadLevelGUI(name, false, true);
    }

    //------------------------------------------------LoadLevelGameGUI------------------------------------------------
    public static void LoadLevelGameGUI(string name)
    {
        LoadLevelGUI(name,true,false);
    }

    /// <summary>
    /// 添加 GameLua
    /// </summary>
    /// <param name="name"></param>
    public static void LoadLevelAdditiveGameGUI(string name)
    {
        LoadLevelGUI(name, true, true);
    }


    /// <summary>
    /// 添加 GameLua add by 004  making the prefab in certain location
    /// </summary>
    /// <param name="name"></param>
    public static void LoadAdditiveGameUIwithFunc(string name,Vector3 pV,LuaFunction pFunc)
    {
        SimpleFramework.LuaHelper.GetPanelManager().CreateNewGamePanel(name,pV, pFunc);
    }
    public static void LoadAdditiveGameUI(string name, Vector3 pV)
    {
        SimpleFramework.LuaHelper.GetPanelManager().CreateNewGamePanel(name, pV,null);
    }
    //public static void LoadGameMXNN()
    //{
    //    PlatformGameDefine.game = new GameEntityNNBR();
    //    Application.LoadLevel("Module_Rooms");
    //}
#endregion 加载场景相关

#region 使用Json作为配置文件,游戏模块更新
    /// <summary>
    /// 检测游戏是否需要下载
    /// 大厅游戏入口
    /// </summary>
    /// <param name="mono"></param>
    /// <param name="gameModulesList">模块列表,与assetbundle资源的模块相同</param>
    /// <param name="btnName">hall 中 游戏按钮的名字</param>
    public static void CheckGameModulesUpdate(this MonoBehaviour mono, ArrayList gameModulesList, string btnName, LuaFunction function, LuaFunction func)
    {
        if (Utils.version.CompareTo(PlayerPrefs.GetString("instantUpdateVersion", "")) != 0)//解压未完成
        {
            EginProgressHUD.Instance.ShowPromptHUD("游戏正在解压中, 请5秒后再进游戏...");
            return;
        }

        if (typeof(SimpleFramework.Manager.GameManager).GetField("_IsDevelop") != null)
        {//用于开发版本进入游戏

            if (Utils.HallName == "__HappyCity")
            {
                //LoadLevelGUI("Module_Rooms");
               // LoadAdditiveGameUI("Module_Rooms",new Vector3(0,2000,0));
                LoadAdditiveGameUIwithFunc("Module_Rooms", new Vector3(0, 2000, 0), func);
                //if (func != null) func.Call();
            }
            else
            {
                if (function != null) function.Call();
            }

            return;
        }

        List<string> updateGameModuleList = new List<string>();
        //UnityEngine.Debug.Log("ck debug : -------------------------------- gameModulesList.Count = " + gameModulesList.Count);

        string gameModule = string.Empty;
        foreach (var item in gameModulesList)
        {
            //UnityEngine.Debug.Log("ck debug : ---------------------gameModulesList----------- name = " + item);
            
            gameModule = ((string)item).ToLower();
            if (updateGameModuleList.Contains(gameModule) || string.IsNullOrEmpty(gameModule)) continue;

            updateGameModuleList.Add(gameModule);//检测没有添加过的模块
        }
        //Debug.Log(updateGameModuleList.Count+"==========geshu1111111111");
        //for (int i = 0; i < updateGameModuleList.Count; i++)
        //{
        //    Debug.Log(updateGameModuleList[i]);
        //    Debug.Log("kaishi");
        //}
        updateGameModuleList = StaticUtils.CheckGameModulesExist(updateGameModuleList);
        //Debug.Log(updateGameModuleList.Count + "==========geshu2222222222");
        //for (int i = 0; i < updateGameModuleList.Count; i++)
        //{
        //    Debug.Log(updateGameModuleList[i]);
        //    Debug.Log("jieshu");
        //}
        if(updateGameModuleList.Count > 0)
        {
            //#region 进行单个游戏模块的下载.更新方案改变后这个就不需要了
            UpdateGameModules(StaticUtils.GetGameManager(), updateGameModuleList, () =>
            {
                //LoadLevelGUI("Module_Rooms");
            }, true, btnName == null ? null : GetHallGameModuleName(btnName));
            //#endregion 进行单个游戏模块的下载.更新方案改变后这个就不需要了


            #region 热更新方案第二次升级, 游戏部分点击更新, 大厅部分在进入到大厅后进行下载,下载完后再次启动才更新, 因此不再使用该区域
            //if (StaticUtils.GetDownloadCloudAssetComplete())
            //{
            //    if(File.Exists(Constants.DownloadPath + Constants.Config_File))
            //        EginProgressHUD.Instance.ShowPromptHUD("游戏资源已完成下载,请重启游戏平台进行升级");
            //    else EginProgressHUD.Instance.ShowPromptHUD("请移动到WIFI环境下下载资源");
            //}
            //else
            //{
            //    EginProgressHUD.Instance.ShowPromptHUD("游戏资源正在下载中(只在WIFI环境下载)");
            //}
            #endregion 热更新方案第二次升级, 游戏部分点击更新, 大厅部分在进入到大厅后进行下载,下载完后再次启动才更新
        }
        else
        {//没有需要更新的游戏模块. 直接进入游戏房间 
            if (Utils.HallName == "__HappyCity")
            {
                //LoadLevelGUI("Module_Rooms");
                LoadAdditiveGameUI("Module_Rooms", new Vector3(0, 2000, 0));
            }
            else
            {
                if (function != null) function.Call();
            } 
        }
    }

    public static void UpdateGameModules(this MonoBehaviour mono, List<string> gameModules, System.Action onComplete, bool isSingleGameModule = false,string btnGameModule = null)
    {
        string singleGameModule = btnGameModule;//string.Join(",", gameModules.ToArray());
        string singleGameModuleName = StaticUtils.GetGameManager().GetGameModuleName(btnGameModule);
        if (isSingleGameModule)
        {
            //foreach (var item in gameModules)
            //{
            //    if (!string.IsNullOrEmpty(item) && "gamenn" != item)
            //    {
            //        singleGameModule = item;
            //        if (btnGameModule == null) btnGameModule = singleGameModule;
            //        singleGameModuleName = StaticUtils.GetGameManager().GetGameModuleName(btnGameModule);
            //    }
            //}

            if (StaticUtils.GetGameManager().IsGameModuleDownloading(singleGameModule))
            {
                EginProgressHUD.Instance.ShowPromptHUD(singleGameModuleName + "游戏正在下载中...", 3f);
                return;//Hall 中该游戏已经点击了下载,正在下载该游戏. 不用重复下载
            }
            else
            {
                StaticUtils.GetGameManager().UpdateHallGameModuleDownloadProgress(btnGameModule, singleGameModule, 0f);//不显示正在下载(单个游戏模块)
                EginProgressHUD.Instance.ShowPromptHUD(singleGameModuleName + "游戏开始下载...",3f);
            }
        }

        mono.UpdateGameModules(gameModules, true, (path, downloadSize, size) =>
        {
            if (isSingleGameModule)
            {
                StaticUtils.GetGameManager().UpdateHallGameModuleDownloadProgress(btnGameModule, singleGameModule, (downloadSize + 0f) / size);//不显示正在下载(单个游戏模块)
                //EginProgressHUD.Instance.HideHUD();
            }
            else EginProgressHUD.Instance.ShowWaitHUD("正在下载 : " + path + ",\r\n 总进度 : " + downloadSize + "/" + size, true);//显示正在下载(更新整个游戏)
        }, (error,config) =>
        {
            if (error != null)
            {
                Debug.Log("下载出错了 : " + error);
                EginProgressHUD.Instance.ShowPromptHUD("下载出错了 : " + error, 3f);
            }
            else
            {
                if(isSingleGameModule) EginProgressHUD.Instance.ShowPromptHUD(singleGameModuleName + "游戏下载完成", 3f);
                else EginProgressHUD.Instance.HideHUD();
                if (onComplete != null) onComplete();
            }

            if(isSingleGameModule) StaticUtils.GetGameManager().UpdateHallGameModuleDownloadProgress(btnGameModule, singleGameModule,1);//删除该模块的下载进度条
        });
    }

    //从UI 的 按钮名字中获取模块的名称
    public static string GetHallGameModuleName(string btnName)
    {
        return ("game" + btnName.Substring(btnName.LastIndexOf("_") + 1)).ToLower();
    }

    #region 静默热更新
    public static LuaTable InstantUpdateCallback;
    public static void SetInstantUpdateCallbackNull()
    {
        InstantUpdateCallback = null;
    }
   
    /// <summary>
    /// 热更新,资源下载
    /// </summary>
    /// <param name="mono"></param>
    /// <param name="onComplete"></param>
    public static void DownloadCloudAssets(this MonoBehaviour mono, System.Action<string, bool> onComplete)
    {
        mono.DownloadCloudAssets((path, downloadSize, size) =>
        {
            //EginProgressHUD.Instance.ShowWaitHUD("正在下载 : " + path + ",\r\n 总进度 : " + downloadSize + "/" + size);//显示正在下载(更新整个游戏)
            if (InstantUpdateCallback != null)
                InstantUpdateCallback.RawGetFunc("OnProcess").Call(path,downloadSize,size);

        }, (error, isDownloaded) =>
        {
            if (error != null)
            {
                //Debug.LogError("下载出错了 : " + error);
                //EginProgressHUD.Instance.ShowPromptHUD("下载出错了 : " + error, 3f);
            }
            else
            {
                //EginProgressHUD.Instance.HideHUD();
                if (onComplete != null) onComplete(error, isDownloaded);
            }

            if (InstantUpdateCallback != null)
                InstantUpdateCallback.RawGetFunc("OnFinish").Call(error,isDownloaded);
        });
    }


    public static void StartInstantDownload()//StaticUtils.GetGameManager()
    {
        MonoBehaviour mono = StaticUtils.GetGameManager();
        mono.StartCoroutine(StartInstantDownload_until_Extracted(mono));
    }

    private static IEnumerator StartInstantDownload_until_Extracted(MonoBehaviour mono)
    {
        while (Utils.version.CompareTo(PlayerPrefs.GetString("instantUpdateVersion", "")) != 0)
        {
            yield return new WaitForSeconds(5f);
        }

        StartInstantDownload(mono);
    }

    /// <summary>
    /// 热更新, 下载
    /// </summary>
    private static void StartInstantDownload(MonoBehaviour mono)//StaticUtils.GetGameManager()
    {
        if (_IsNoInstantUpdate) return;//打包控制,对于不进行热更新的包,设置 编译 指令即可 
        //UnityEngine.Debug.LogError("ck debug : -------------------------------- isUpdate = " + PlatformGameDefine.playform.IsInstantUpdate + ", isTester = " + PlatformGameDefine.playform.IsTester());

        try
        {
            if (PlatformGameDefine.playform.IsInstantUpdate || PlatformGameDefine.playform.IsTester())
            {
                //热更新,资源下载
                StaticUtils.SetDownloadCloudAssetsComplete(false);
                mono.DownloadCloudAssets((error, isDownloaded) =>
                {//该回调只有在全部下载完成,并且确认下载到的资源是最新的资源后才会进行
                    StaticUtils.SetDownloadCloudAssetsComplete(true);
                    UnityEngine.Debug.Log("CK : ------------------------------ <color=orange>DownloadCloudAssets Complete, isDownloaded</color> = " + isDownloaded);

                    if (isDownloaded) { /*EginProgressHUD.Instance.ShowPromptHUD("资源更新完成");*/ }
                    else
                    {
                        if (File.Exists(Constants.DownloadPath + Constants.Config_File))
                            File.Delete(Constants.DownloadPath + Constants.Config_File);
                    }
                });
            }
        }
        catch (System.Exception e)
        {
            UnityEngine.Debug.Log("CK : ------------------------------ instantupdate StartDownload exception = " + e.Message);
        }
    }

    public static bool IsDownloadCloudAssetComplete()
    {
        if (File.Exists(Constants.DownloadPath + Constants.Config_File) && StaticUtils.GetDownloadCloudAssetComplete()) return true;

        return false;
    }
#endregion 静默热更新
#endregion 使用Json作为配置文件,游戏模块更新

#region 更新大版本方法区
    public static LuaTable VersionUpdateCallback;
    public static void SetVersionUpdateCallbackNull()
    {
        VersionUpdateCallback = null;
    }

    /// <summary>
    /// 大版本更新方法
    /// </summary>
    public static void StartVersionUpdate(string url,string fileName)
    {
        MonoBehaviour mono = StaticUtils.GetGameManager();
        DownloadHelper dh = new DownloadHelper();
        string filePath = Constants.VersionUpdatePath + fileName;
        dh.Download(mono,url, filePath, (progress,downloadSize,size)=> {
            if (VersionUpdateCallback != null)
                VersionUpdateCallback.RawGetFunc("OnVersionUpdateProcess").Call(progress, downloadSize, size);
            //EginProgressHUD.Instance.ShowWaitHUD("测试用,正式版不会显示大包下载进度: progress = " + progress);
        },(error)=> {
            if (VersionUpdateCallback != null)
                VersionUpdateCallback.RawGetFunc("OnVersionUpdateFinish").Call(error);
            //EginProgressHUD.Instance.HideHUD();
            if(string.IsNullOrEmpty(error)) Application.OpenURL(filePath);
        });
    }
    #endregion 更新大版本方法区


    #region 加载打包配置文件
    public static void InitPackConfig(MonoBehaviour mono)
    {
        //UnityEngine.Debug.Log("ck debug : -------------------------------- mono = " + mono);

        if (mono == null) return;
        //加载打包配置
        mono.StartCoroutine(LoadText(Constants.Pack_Config_Path, (json, err) =>
        {

            if (string.IsNullOrEmpty(err) && json.IsAvailable())
            {
                if (json["AgentId"].IsAvailable()) agent_Id = json["AgentId"].str;
            }
        }));
    }

    public static IEnumerator LoadText(string uri, System.Action<JSONObject, string> onComplete)
    {
        JSONObject resultJson = null;
        string err = null;
        if (Application.platform == RuntimePlatform.Android)
        {
            WWW www = new WWW(uri);
            yield return www;
            if (www.error != null)
            {
                err = www.error;
            }
            else
            {
                resultJson = new JSONObject(www.text);
            }
        }
        else
        {
            if (File.Exists(uri))
            {
                resultJson = new JSONObject(File.ReadAllText(uri));
            }
            else
            {
                err = "File not exist at " + uri;
            }
        }

        if (onComplete != null) onComplete(resultJson, err);
    }
    #endregion 加载打包配置文件


    #region playerprefs 相关方法
    /// <summary>
    /// 用于后台配置config_urls 数据,或者从lua中设置config_urls数据
    /// </summary>
    /// <param name="config_urls"></param>
    public static void SetConfig_urls(string config_urls)
    {
        if(!string.IsNullOrEmpty(config_urls))
        {
            PlayerPrefs.SetString("config_urls", config_urls);
            PlayerPrefs.SetString("config_urls_version", Utils.version);
        }
        else
        {
            PlayerPrefs.SetString("config_urls", "");
            PlayerPrefs.SetString("config_urls_version", "");
        }

        PlayerPrefs.Save();
    }
#endregion playerprefs 相关方法

	//add at 2016.3.31 call in lua
	//检测需要显示正在下载的进度条
	public static void CheckHallGameModuleDownloadProgress(LuaTable luaTb)
	{
		StaticUtils.GetGameManager().CheckHallGameModuleDownloadProgress(luaTb,true);//检测需要显示正在下载的进度条
	}

	public static void initSocket()
	{
		SocketManager socketManager = SocketManager.LobbyInstance;
	}

	//add at 2016.4.11 call in lua
	public static void ConnectGameSocket()
	{
		SocketConnectInfo connectInfo = SocketConnectInfo.Instance;
		if (connectInfo.ValidInfo()) {
			SocketManager socketManager = SocketManager.LobbyInstance;
			socketManager.Connect(connectInfo);
		}else {
			EginProgressHUD.Instance.ShowPromptHUD(ZPLocalization.Instance.Get("Socket_Valid"));
		}
	}

    public static void ClearListener()
    {
        SocketManager.Instance.socketListener = null;
    }
    public static void Disconnect(string info) {
        SocketManager.Instance.Disconnect(info);
    }
    public static void ConnectSocket(SocketConnectInfo info ) {
        SocketManager.Instance.Connect(info);
    }
//#if UNITY_EDITOR || UNITY_STANDALONE
	public static void loadScene(string sceneName)
	{
		SceneManager.LoadScene(sceneName);
	}
//#endif

    public static void CallDelegate(System.Delegate de)
    {
        if (de != null) de.DynamicInvoke();
    }

    public static void CallDelegate(System.Delegate de, object param)
    {
        if (de != null) de.DynamicInvoke(param);
    }


    public static string encrypTime(string plaintext_data)
    {
        return EginTools.encrypTime(plaintext_data);
    }

    public static void Log(string plaintext_data)
    {
        Debug.LogError(plaintext_data);
    }

    #region 解密配置文件中的加密字符串的方法
    /// <summary>
    /// 把加密数据的解密后数据装换成list
    /// </summary>
    /// <param name="isHttp"></param>
    /// <param name="tempResultStr"></param>
    /// <returns></returns>
    public static ArrayList aesDecryptToUrlList(string tempResultStr, bool isHttp = false)
    {
        ArrayList hostURL_Arr = new ArrayList();
        //if(hostURLInconfig!="" && hostURLInconfig!=null){
        //	web_HostURL_Arr.Add(hostURLInconfig);
        //}
        try
        {
            char[] splS = "\n".ToCharArray();

            string urlStrs = aesDecrypt(tempResultStr);
            //UnityEngine.Debug.Log("CK : ------------------------------ urlStrs = " + urlStrs + ", tempResultStr = " + tempResultStr);

            string[] urlArr = urlStrs.Split(splS);
            for (int i = 0; i < urlArr.Length; i++)
            {
                string stUrl = urlArr[i].ToString();

                if (stUrl != "" && stUrl != null && (stUrl.IndexOf(".") >= 0))
                {
                    //Debug.Log ("222====:");
                    if (isHttp && stUrl.IndexOf("http://") < 0)
                    {
                        stUrl = "http://" + stUrl;//"www.game747.com";//http://123.57.237.136:8000/client_unity/bank_login/
                        //stUrl = "http://"+"123.57.245.252:8000";
                        EginTools.Log("网页IP====:" + stUrl);
                    }

                    hostURL_Arr.Add(stUrl);
                }
            }
        }
        catch (Exception e)
        {
            if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_web_hostArr exception = " + e.Message);
        } 
        return hostURL_Arr;
    }

    public static string aesDecrypt(string encrypted_data)
    {
        byte[] keyBytes = System.Convert.FromBase64String("NjFzM0ZkNzZoVDRrMHNtTA==");

        byte[] encrypted = System.Convert.FromBase64String(encrypted_data);//System.Text.ASCIIEncoding.ASCII.GetBytes(encrypted_data);

        byte[] iv = new byte[16];
        for (int k = 0; k < 16; k++)
        {
            iv[k] = encrypted[k];
        }

        byte[] e_bytes = new byte[encrypted.Length - 16];
        for (int k = 16; k < encrypted.Length; k++)
        {
            e_bytes[k - 16] = encrypted[k];
        }

        RijndaelManaged rijalg = new RijndaelManaged();
        rijalg.BlockSize = 128;
        rijalg.KeySize = 128;
        rijalg.FeedbackSize = 128;
        rijalg.Padding = PaddingMode.None;
        rijalg.Mode = CipherMode.CBC;

        rijalg.Key = keyBytes;//(new SHA256Managed()).ComputeHash(Encoding.ASCII.GetBytes("IHazSekretKey"));  
        rijalg.IV = iv;//System.Text.Encoding.ASCII.GetBytes("1234567890123456");

        string decrypted = "";
        int llen = e_bytes.Length / 16;
        for (int i = 0; i < llen; i++)
        {
            byte[] _bytes = new byte[16];
            for (int k = 0; k < 16; k++)
            {
                _bytes[k] = e_bytes[i * 16 + k];
            }

            ICryptoTransform decryptor = rijalg.CreateDecryptor(rijalg.Key, rijalg.IV);

            string plaintext;
            using (MemoryStream msDecrypt = new MemoryStream(_bytes))
            {
                using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                {
                    using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                    {
                        plaintext = srDecrypt.ReadToEnd();
                    }
                }
            }
            decrypted += plaintext;
        }
        return decrypted;
    }
    #endregion 解密配置文件中的加密字符串的方法

    #region PlatformEntity Lua化相关
   
    //在Lua中调用Action
    public static void CallAction(System.Action onComplete = null)
    {
        if (onComplete != null) onComplete();
    }
    //在Action中调用Lua函数
    public static System.Action ActionToLua(LuaFunction luafunc, LuaTable luaself)
    {
        return () =>
        {
            luafunc.Call(luaself);
        };
    }

    public static string JSONObjectToString(object json)
    {
        return ((JSONObject)json).ToString();
    }
    //将ArrayList中的数据包装到LuaTable中
    public static void ArryListToLuaTable(ArrayList _arr, LuaTable _table)
    {
        for (int i = 0; i < _arr.Count; i++)
        {
            _table[i + 1] = _arr[i];
        }
    }
     
    //Lua和C#数据之间的数据交换
    public static int ArryLength(string[] _arr)
    {
        return _arr.Length;
    }
    public static void SetArry(string[] _arr,int _k, string _v)
    {
        _arr[_k] = _v;
    }
    public static string GetArry(string[] _arr, int _k)
    {
        return _arr[_k];
    }
       
    
    public static bool Lua_UNITY_EDITOR
    {
        get
        {
#if UNITY_EDITOR
            return true;
#endif
            return false;
        }
    }
    #endregion PlatformEntity Lua化相关

    //快速七张麻将添加方法  将table转换为数组，用于iTweenPath路径的使用
    public static Vector3[] Zhuanhuan(LuaTable lua)
    {
        Vector3[] position = new Vector3[lua.Count];
        for (int i = 1; i <= lua.Count; i++)
        {
            position[i - 1] = (Vector3)lua[i];
        }
        return position;
    }
}