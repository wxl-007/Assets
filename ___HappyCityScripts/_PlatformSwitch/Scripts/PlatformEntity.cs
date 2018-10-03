using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.IO;
using System.Security.Cryptography;  
using System.Text;
using System;
using System.Threading;

public class PlatformEntity {
 	protected string platformName;		// 平台代号

    protected string game_URL;          // 当前使用的IP
    protected string web_URL;           // 当前使用的IP. 已过时,使用 hostURL 替代
    protected string hostURL;			// 平台地址 --- 跟web一样的
    protected string hostURL_socketLobby;    //使用socket登录的时候 原来的hostURL变成了socket用的 ip地址. 因此该值用来表示socket登录模式下的http固定地址

    //----------------兼容ios ipv6 审核用----------------------
    protected string game_URL_ipv6;          // 当前使用的IP
    protected string hostURL_ipv6;          // 平台地址 --- 跟web一样的

    protected string downloadURL;		// 平台下载目录地址
	protected string rechargeURL;		// 平台充值地址：如为空则需接入第三方充值
	protected string feedbackContent;	// 平台客服信息
	protected string unityMoney;		// 平台游戏币单位
    protected string iOSFlagValidVersion;//控制当前的配置的版本号进行app store 充值
    protected bool iOSPayFlag = false;	// 平台苹果充值标志
    protected bool iOSPayFlag_bundle_version_contains = false;//热更新地址下(由melissa管理)是否包含了该 bundleid=version 的配置条目
    protected string[] config_urls;		// 平台配置文件地址列表

	protected string hostURLInconfig;

    protected bool isInstantUpdate = false;     //是否开启热更新//默认开启
    protected string[] instantUpdateUrl;  //热更新url地址
    protected string[] instantUpdateUrl_test;  //热更新url地址
    protected string testers;

    protected int versionCode;//(如果不用更新)用于减少一次对version文件的网络访问
    protected string register_url;//用于 注册界面 使用系统的webView 加载web网页进行注册

    //-----------------------------------缓存相关---------------------------
    protected bool isCache_UserIp = true;//是否 使用 用户ip(加密数据) 和 conf加密数据的缓存
    protected bool isCache_config = false;

    //----------------------SocketManager配置信息------------------------------------
    protected string socketManager_config_str;

    //-----------------------------------------------------
    protected string game_HostURL;			// 游戏IP数组地址
	protected string web_HostURL;			// 网页IP数组地址 
	protected string socketLobby_HostURL;           // 网页IP数组地址 

    // shawn.update
    protected ArrayList game_HostURL_Arr = new ArrayList();	// 游戏IP数组
	protected ArrayList web_HostURL_Arr = new ArrayList();	// 网页IP数组


    protected int game_Cutt = 0;			// 当前第几个
	protected int web_Cutt=0;			// 当前第几个
    protected int socketLobby_Cutt = 0;
	//--------------------------------------------------------

	protected bool isPool = false;	// 是否开启牛牛奖池

	protected bool isYan = false;   // 是否开启验证码

	protected string aliAppId;       //支付宝appid
    protected string wxAppId;       //微信appid
    protected string wxAppSecret;	//微信appsecret
	protected string wxPayAppId;       //微信支付appid
	protected string wxPayAppSecret;       //微信支付appsecret

    //protected string wxPayURL;          //微信支付url
    protected string wxShareUrl;    //微信分享 url
    protected string wxShareDesciption;	//微信分享描述信息

	public string[] wxShareAppIds;		// 微信分享appid

    public virtual string PlatformName { get { return platformName; } }

    public virtual string HostURL
    {
        get
        {
            //return "http://121.42.35.14/";
            //return "http://139.224.33.27:80/";
            if (Utils._IsIPTest)
            {
                if (!string.IsNullOrEmpty(IPTest_Login._WebURL))
                {
                    string prefix = "http://";
                    if (IPTest_Login._WebURL.StartsWith(prefix)) prefix = string.Empty;
                    return prefix + IPTest_Login._WebURL;
                }
            }

            if (IsSocketLobby) return hostURL_socketLobby;//socket大厅模式下使用 hostURL_socketLobby
            if (PlatformGameDefine.playform is PlatformGame7997) return "http://54.254.211.231:80";
            return hostURL;
        } }
    public virtual string DownloadURL { get { return downloadURL; } }
    public virtual string RechargeURL { get { return rechargeURL; } }
    public virtual string FeedbackContent { get { return feedbackContent; } }
    public virtual string UnityMoney { get { return unityMoney; } }
    public virtual bool IOSPayFlag
    {
        get
        {

#if (UNITY_IOS || UNITY_IPHONE) && !_IsEnterprise
            if (iOSPayFlag_bundle_version_contains) return false;//如果热更新地址下配置了,就代表要关闭热更新
            if (!string.IsNullOrEmpty(iOSFlagValidVersion))
            {
                if(iOSFlagValidVersion.Contains(Utils.version)) return false;
            }
#endif
            return iOSPayFlag;
        }
    }
    public virtual bool IsPool { get { return isPool; } }
    public virtual bool IsYan { get { return isYan; } }

    public virtual int VersionCode { get { return versionCode; } }
    public virtual string Register_url
    {
        get {
            if(!string.IsNullOrEmpty(Utils.Agent_Id)) return string.Empty;//如果存在 代理 号,这里返回空, 就使用unity的注册. (不使用web网页注册)

            return "";// register_url;  
        } }

    public virtual string gameUrl
    {
        get
        {
			if(Utils.isLocalServer){
				if (!string.IsNullOrEmpty(Local_Login.serverIP)) return Local_Login.serverIP+":9012";
			}
            if (Utils._IsIPTest)
            {
                if (!string.IsNullOrEmpty(IPTest_Login._GameURL)) return IPTest_Login._GameURL;
            }

            if (!IOSPayFlag)
            {
                if (!string.IsNullOrEmpty(game_URL_ipv6)) return game_URL_ipv6;
            }

//            if (PlatformGameDefine.playform is PlatformGame7997) return "54.254.229.244:8211";
			//水浒
			if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:11078";
            return game_URL;
        }
    }
    public virtual string webUrl { get { return web_URL; } }

    public virtual string SocketLobbyUrl
    {
        get
        {
            //return "114.215.87.65:9560";//597测试地址//"120.76.142.110:9011";
 
            if (Utils.isLocalServer){
				if (!string.IsNullOrEmpty(Local_Login.serverIP)) return Local_Login.serverIP+":9013";
			}
            if (Utils._IsIPTest)
            {
                if (!string.IsNullOrEmpty(IPTest_Login._SocketLobbyURL)) return IPTest_Login._SocketLobbyURL;
            }

            if (!IOSPayFlag)
            {
                if (!string.IsNullOrEmpty(hostURL_ipv6)) return hostURL_ipv6;
            }

            if (PlatformGameDefine.playform is PlatformGame7997)
//                return "54.254.229.244:9520"; //7997测试地址
				return "52.220.39.106:9520";

            //return "120.25.88.105:9011";
            //return "114.215.87.65:9520";//597测试地址
            return hostURL;//socketlobby 的url地址就是之前的 http的web地址
        }
    }

    protected bool isSocketLobby = true;
    public virtual bool IsSocketLobby { get { return isSocketLobby; } }

	public virtual string AliAppId { get { return aliAppId; } }
    public virtual string WXAppId { get { return wxAppId; } }
    public virtual string WxAppSecret { get { return wxAppSecret; } }
	public virtual string WXPayAppId { get { return wxPayAppId; } }
	public virtual string WXPayAppSecret { get { return wxPayAppSecret; } }

    //public string WXPayURL { get { return wxPayURL; } }
    public virtual string WXShareUrl { get { return wxShareUrl; } }
    public virtual string WXShareDescription { get { return wxShareDesciption; } }

    //510k
    protected string hallHomeInfos;
    public virtual string HallHomeInfos { get { return hallHomeInfos; } }

    private List<string> web_conf_list = new List<string>();//web conf 文件对应的url地址列表
    private List<string> game_conf_list = new List<string>();//game conf 文件对应的url地址列表
    private int m_cur_game_conf_index;
    private int m_cur_web_conf_index;

    //private List<string> web_conf_cryptedStr_list = new List<string>();//web conf 获取的加密字符串列表
    //private List<string> game_conf_cryptedStr_list = new List<string>();//game conf 获取的加密字符串列表

    private int instantUpdateUrl_index = 0;
    public virtual bool IsInstantUpdate { get { return isInstantUpdate; } }
    public virtual string InstantUpdateUrl
    {
        get{ 
            string[] instantUpdateUrl_array = this.instantUpdateUrl;

            //设置测试人员专用 热更新地址
            if (IsTester() && !IsInstantUpdate)
            {
                if (instantUpdateUrl_test != null && instantUpdateUrl_test.Length > 0)
                {
                    instantUpdateUrl_array = this.instantUpdateUrl_test;
                }
            }
            string instantUpdateUrl = instantUpdateUrl_array[instantUpdateUrl_index];
            instantUpdateUrl_index = (++instantUpdateUrl_index) % instantUpdateUrl_array.Length;

            string gameName = Utils.GameName;
            if (gameName == "All") gameName = string.Empty;
            else gameName = "_" + gameName;

#if UNITY_IOS
            return instantUpdateUrl + "IOS" + gameName + Constants.UpdateDirName;
#elif UNITY_STANDALONE_OSX
            return instantUpdateUrl + "OSX" + gameName + Constants.UpdateDirName;
#else 
            return instantUpdateUrl + "Android" + gameName + Constants.UpdateDirName;
#endif
        } }
    /// <summary>
    /// 检测用户是否是测试人员(上一次登录成功是否是测试人员)
    /// </summary>
    /// <returns></returns>
    public virtual bool IsTester()
    {
        if (string.IsNullOrEmpty(testers)) return false;
        string username = PlayerPrefs.GetString("EginUsername", "");
        if (string.IsNullOrEmpty(username)) return false;//如果username 是空的, testers.Contains(username) 就是true;
        if (!testers.StartsWith(",")) testers = "," + testers;
        if (!testers.EndsWith(",")) testers = testers + ",";
        return testers.Contains(username);
    }

    public virtual string ConfigURL()
    {
		string versionUrl = downloadURL + "config.xml";
		return versionUrl;
	}

    public virtual string GameNoticeURL()
    {
		string noticeUrl = downloadURL + "game_notices.xml";
		return noticeUrl;
	}
    public virtual void LoadURL(string game, string web)
    {

        if (game != "")
        {
            game_HostURL = game;
        }
        if (web != "")
        {
            web_HostURL = web;
        }
    }

    //-----------------------------------------缓存相关------------------------
    public virtual bool IsCache_UserIp { get { return isCache_UserIp; } }
    public virtual bool IsCache_config { get { return isCache_config; } }
    //----------------------SocketManager配置信息------------------------------------
    public virtual string SocketManager_config_str { get { return socketManager_config_str; } }




    #region 更新总配置信息
    public virtual void UpdateConfig(JSONObject configObj)
    { 
        if (configObj.IsAvailable())
        {
            try
            {
                web_conf_list = ParseArrayOrStringJson(configObj["web_hosts"], web_conf_list);
                game_conf_list = ParseArrayOrStringJson(configObj["game_hosts"], game_conf_list);
                if (web_conf_list != null && web_conf_list.Count > 0) web_HostURL = web_conf_list[0];
                if (game_conf_list != null && game_conf_list.Count > 0) game_HostURL = game_conf_list[0];

                platformName = Regex.Unescape(configObj["platformName"].str);

                if(IsSocketLobby) hostURL_socketLobby = Regex.Unescape(configObj["hostURL"].str);
                else hostURL = Regex.Unescape(configObj["hostURL"].str);

                if (configObj["hostURL_ipv6"].IsAvailable()) hostURL_ipv6 = Regex.Unescape(configObj["hostURL_ipv6"].str);
                if (configObj["game_URL_ipv6"].IsAvailable()) game_URL_ipv6 = Regex.Unescape(configObj["game_URL_ipv6"].str);

                hostURLInconfig = Regex.Unescape(configObj["hostURL"].str);

                rechargeURL = Regex.Unescape(configObj["rechargeURL"].str);
                feedbackContent = Regex.Unescape(configObj["feedbackContent"].str);
                unityMoney = Regex.Unescape(configObj["unityMoney"].str);
                iOSPayFlag = configObj["ios_pay_flag"].b;
                if (configObj["iOSFlagValidVersion"].IsAvailable()) iOSFlagValidVersion = Regex.Unescape(configObj["iOSFlagValidVersion"].str);//ios_pay_flag 生效的版本号
                isPool = configObj["is_pool"].b;
                isYan = configObj["is_yan"] ? configObj["is_yan"].b : false;
                downloadURL = Regex.Unescape(configObj["downloadURL"].str);
                //game_HostURL = Regex.Unescape(configObj["game_hosts"].str);
                //web_HostURL = Regex.Unescape(configObj["web_hosts"].str);

                if (configObj["versionCode"].IsAvailable()) versionCode = System.Convert.ToInt32(configObj["versionCode"].n);
                if (configObj["socketLobby_hosts"].IsAvailable()) socketLobby_HostURL = Regex.Unescape(configObj["socketLobby_hosts"].str);
                if (configObj["register_url"].IsAvailable()) register_url = Regex.Unescape(configObj["register_url"].str);

                
                if (configObj["isCache_UserIp"].IsAvailable()) isCache_UserIp = configObj["isCache_UserIp"].b;//是否开用户ip缓存
                if (configObj["isCache_config"].IsAvailable()) isCache_config = configObj["isCache_config"].b;//是否使用 config 缓存
                
                if (configObj["isInstantUpdate"].IsAvailable()) isInstantUpdate = configObj["isInstantUpdate"].b;//是否开启热更新
                ParseInstantUpdateUrl(configObj["instantUpdateUrl"]);//热跟新地址解析
                instantUpdateUrl_test = ParseArrayOrStringJson(configObj["instantUpdateUrl_test"]).ToArray();//测试热更新地址解析
                if (configObj["testers"].IsAvailable()) testers = Regex.Unescape(configObj["testers"].str);//测试人员用户名

				if (configObj["aliAppId"].IsAvailable()) aliAppId = Regex.Unescape(configObj["aliAppId"].str);       //ali appid

                if (configObj["wxAppId"].IsAvailable()) wxAppId = Regex.Unescape(configObj["wxAppId"].str);       //微信appid
                if (configObj["wxAppSecret"].IsAvailable()) wxAppSecret = Regex.Unescape(configObj["wxAppSecret"].str);	//微信appsecret
                if (configObj["wxShareUrl"].IsAvailable()) wxShareUrl = Regex.Unescape(configObj["wxShareUrl"].str);    //微信分享 url
                if (configObj["wxShareDesciption"].IsAvailable()) wxShareDesciption = Regex.Unescape(configObj["wxShareDesciption"].str);	//微信分享描述信息

                JSONObject config_urlsJson = configObj["config_urls"];
                if (config_urlsJson.IsAvailable())
                {
                    for (int i = 0; i < config_urlsJson.list.Count; i++)
                    {
                        config_urlsJson.list[i].str = Regex.Unescape(config_urlsJson.list[i].str);
                    }
                    Utils.SetConfig_urls(config_urlsJson.ToString());
                }
                else
                {
                    Utils.SetConfig_urls(null);
                }

                if (configObj["socketManager_config_str"].IsAvailable()) socketManager_config_str = Regex.Unescape(configObj["socketManager_config_str"].str);
                SocketManager.UpdateConfigStr(socketManager_config_str);
                ConnectDefine.updateConfig();//重新加载 http 的 url
            }
            catch (Exception e)
            {
                EginTools.Log("Send Error: " + e);
            }
        }

        UnityEngine.Debug.Log("CK : ------------------------------ web_conf_list = " + web_conf_list.Count + ", game_conf_list = " + game_conf_list.Count);
        if ((web_conf_list == null || web_conf_list.Count <= 0) && !string.IsNullOrEmpty(web_HostURL)) web_conf_list = new List<string>() { web_HostURL };
        if ((game_conf_list == null || game_conf_list.Count <= 0) && !string.IsNullOrEmpty(game_HostURL)) game_conf_list = new List<string>() { game_HostURL };
    }

    private void ParseInstantUpdateUrl(JSONObject instantUpdateUrlJson)
    {
        if (instantUpdateUrlJson.IsAvailable())
        {
            if (instantUpdateUrlJson.list != null)
            {
                instantUpdateUrl = new string[instantUpdateUrlJson.list.Count];
                for (int i = 0; i < instantUpdateUrlJson.list.Count; i++)
                {
                    instantUpdateUrl[i] = Regex.Unescape(instantUpdateUrlJson.list[i].str);//热更新url地址
                }
            }
            else
            {
                instantUpdateUrl = new string[1];
                instantUpdateUrl[0] = Regex.Unescape(instantUpdateUrlJson.str);//热更新url地址
            }
        }
    }
    #endregion 更新总配置信息

    #region 加载总配置文件
    public virtual IEnumerator LoadLocalConfig()
    {
        StaticUtils.GetGameManager().StartCoroutine(LoadNewIosPayConfig());//加载ios支付额外控制配置文件//该文件需要在显示登录界面前显示

        JSONObject resultJson = null;

        if (isCache_config)
        {
            JSONObject savedJson = new JSONObject(PlayerPrefs.GetString(EginUser.ObtainPlatformKey("m_config_str"), ""));
            if (savedJson.IsAvailable()) savedJson = savedJson["body"];

            if (savedJson.IsAvailable() && savedJson["application_version"].IsAvailable() && savedJson["application_version"].str.CompareTo(Utils.version) == 0)
            {
                resultJson = savedJson;
            }
            else
            {
                TextAsset textAsset = Resources.Load<TextAsset>(FixConfig("Texts/config", IsSocketLobby));
                savedJson = null;
                if (textAsset) savedJson = new JSONObject(textAsset.text);
                if (savedJson.IsAvailable()) savedJson = savedJson["body"];

                if (savedJson.IsAvailable() && savedJson["game_hosts"].IsAvailable() && savedJson["web_hosts"].IsAvailable() && savedJson["downloadURL"].IsAvailable() && savedJson["unityMoney"].IsAvailable())
                {
                    resultJson = savedJson;
                }
            }
        }

        if (resultJson == null) yield return LoadConfig();//本地没有数据,加载网络数据
        else UpdateConfig(resultJson);
    }

    public virtual IEnumerator LoadConfig()
    {
        string[] config_urls = this.config_urls;

        string config_urls_json_str = PlayerPrefs.GetString("config_urls", "");
        string config_urls_version_str = PlayerPrefs.GetString("config_urls_version", "");
        if (!string.IsNullOrEmpty(config_urls_json_str) && !string.IsNullOrEmpty(config_urls_version_str) && config_urls_version_str == Utils.version)//从config 文件中保存了config_urls 到 PlayerPrefs 中//如果
        {
            JSONObject json = new JSONObject(config_urls_json_str);
            List<string> configList = new List<string>();
            //config_urls = new string[json.list.Count + this.config_urls.Length];

            foreach (var item in json.list)
            {
                //UnityEngine.Debug.Log("CK : ------------------------------ name = " + item.str );

                if (!configList.Contains(item.ToString())) configList.Add(item.str);
            }

            foreach (var item in this.config_urls)
            {
                if (!configList.Contains(item.ToString())) configList.Add(item);
            }

            config_urls = configList.ToArray();
        }

        JSONObject configObj = null;
        if (config_urls != null && config_urls.Length > 0)
        {
            System.Random ro = new System.Random();
            Queue<string> config_urls_queue = new Queue<string>();
            foreach (var item in config_urls)
            {
                config_urls_queue.Enqueue(item + "?" + ro.NextDouble());
            }
            CoroutineResult result = new CoroutineResult();
            MonoBehaviour mono = StaticUtils.GetGameManager();

            yield return mono.Start_Coroutine(null,
                LoadConfig_concurrent(mono, config_urls_queue, result),
                LoadConfig_concurrent(mono, config_urls_queue, result),
                LoadConfig_concurrent(mono, config_urls_queue, result));//同时启动3个协程
            //UnityEngine.Debug.Log("CK : ------------------------------ load config completed = "  );
            
            configObj = (JSONObject)(result._objectResult);

            #region 注掉了,使用同时启动多个协程的方法替代
            //List<string> pingableUrlList = new List<string>();
            //string curUrl = null;
            //yield return StaticUtils.GetGameManager().StartCoroutine(ObtainPingUrls(config_urls, pingableUrlList));
            //for (int i = 0; i < pingableUrlList.Count; i++)
            //{
            //    curUrl = pingableUrlList[i];
            //    if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ curUrl = " + curUrl);

            //    result = new CoroutineResult();
            //    yield return StaticUtils.GetGameManager().StartCoroutine(result.WWWReConnect(curUrl));
            //    www = result._wwwResult;



            //    if (result.error == null && www.error == null)
            //    {
            //        HttpResult result_config = HttpConnect.Instance.BaseResult(www, false);
            //        www.Dispose();
            //        www = null;
            //        if (HttpResult.ResultType.Sucess == result_config.resultType)
            //        {
            //            if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------//// curUrl valid = " + curUrl);
            //            JSONObject configObj = (JSONObject)(result_config.resultObject);
            //            web_conf_list = ParseArrayOrStringJson(configObj["web_hosts"], web_conf_list);
            //            game_conf_list = ParseArrayOrStringJson(configObj["game_hosts"], game_conf_list);
            //            UpdateConfig(configObj);//更新配置文件信息
            //            break;
            //        }
            //    }
            //}
            #endregion 注掉了
        }
        
        UpdateConfig(configObj);//更新配置文件信息

        SaveConfig_json_str(configObj);

        #region 弃用,使用ping url 的方法 
        //if (config_urls != null && config_urls.Length > 0)
        //{
        //    System.Random ro = new System.Random();
        //    foreach (string temp_url in config_urls)
        //    {
        //        string config_url = temp_url + "?" + ro.NextDouble();
        //        //UnityEngine.Debug.Log("CK : ------------------------------ config_url = " + config_url);

        //        WWW www_config = HttpConnect.Instance.HttpRequestAli(config_url);
        //        CoroutineResult result = new CoroutineResult();
        //        yield return StaticUtils.CheckTimeOut(www_config, null, result, 8);

        //        if (result.error != null)//第一次超时后重连
        //        {
        //            www_config.Dispose();
        //            www_config = null;

        //            www_config = HttpConnect.Instance.HttpRequestAli(config_url);//重连该地址
        //            result = new CoroutineResult();
        //            yield return StaticUtils.CheckTimeOut(www_config, null, result, 8);//第二次超时判断
        //        }

        //        if (result.error == null)
        //        {
        //            yield return www_config;
        //            HttpResult result_config = HttpConnect.Instance.BaseResult(www_config);
        //            if (HttpResult.ResultType.Sucess == result_config.resultType)
        //            {
        //                JSONObject configObj = (JSONObject)(result_config.resultObject);
        //                UpdateConfig(configObj);
        //                break;
        //            }
        //        }

        //        #region 弃用,使用上面的方法,添加超时判断和第一次超时重连功能
        //        //WWW www_config = HttpConnect.Instance.HttpRequestAli(config_url);
        //        //yield return www_config;
        //        //HttpResult result_config = HttpConnect.Instance.BaseResult(www_config);
        //        //if (HttpResult.ResultType.Sucess == result_config.resultType)
        //        //{
        //        //    JSONObject configObj = (JSONObject)(result_config.resultObject);
        //        //    //UnityEngine.Debug.Log("CK : ------------------------------ config_url // = " + config_url);

        //        //    UpdateConfig(configObj);
        //        //    break;
        //        //}
        //        #endregion 弃用,使用上面的方法,添加超时判断和第一次超时重连功能
        //    }
        //}
        #endregion 弃用,使用ping url 的方法 
    }

    private IEnumerator LoadNewIosPayConfig()
    {
        iOSPayFlag_bundle_version_contains = false;
        
        if (Utils.BUILDPLATFORM == BuildPlatform.IOS_AppStore && instantUpdateUrl.Length > 0)
        {
            CoroutineResult result = new CoroutineResult();
            yield return result.WWWReConnect(instantUpdateUrl[0] + "socket_config.xml");

            if (result._wwwResult != null && result._wwwResult.error == null)
            {
                string bundle_version = Utils.bundleId + "=" + Utils.version;
                iOSPayFlag_bundle_version_contains = result._wwwResult.text.Contains(bundle_version);
            }
        }
    }

    private static void SaveConfig_json_str(JSONObject configObj)
    {
        if (configObj.IsAvailable())
        {
            configObj.AddField("application_version", Utils.version);
            PlayerPrefs.SetString(EginUser.ObtainPlatformKey("m_config_str"), configObj.ToString());
            PlayerPrefs.Save();
        }
    }

    /// <summary>
    /// 用于同时启动多个url加载
    /// </summary>
    /// <param name="config_urls_queue"></param>
    /// <param name="outResult">_BoolResult 即为 isDone; _wwwResult 为最终的 www</param>
    /// <returns></returns>
    IEnumerator LoadConfig_concurrent(MonoBehaviour mono, Queue<string> config_urls_queue, CoroutineResult outResult)
    {
        if (outResult == null)
        {
            string error = "LoadConfig_concurrent : outResult cannot be null";
            if (Constants.isEditor) throw new Exception(error);
            else UnityEngine.Debug.LogError("CK : ------------------------------ error = " + error);
            yield break;
        }

        Coroutine coroutine = null;
        CoroutineResult result = null;
        //bool isDone = false;

        while (!outResult._BoolResult && config_urls_queue.Count > 0)
        {
            while (!outResult._BoolResult && coroutine != null) yield return 0;//同一时间只启动一个url

            if (outResult._BoolResult || config_urls_queue.Count <= 0) break;

            string curUrl = config_urls_queue.Dequeue();
#if UNITY_EDITOR
            string filename = Path.GetFileName(curUrl);
            filename = filename.Substring(0,filename.IndexOf("?"));
#endif
            if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ curUrl = " + curUrl);
            result = new CoroutineResult();
            coroutine = mono.StartCoroutine(result.WWWReConnect(curUrl, () => 
            {
                if(!outResult._BoolResult && result.error == null && result._wwwResult.error == null)
                {
                    if (result._wwwResult != null)
                    {
                        HttpResult result_config = HttpConnect.Instance.BaseResult(result._wwwResult, false);
                        if (HttpResult.ResultType.Sucess == result_config.resultType)
                        {
                            outResult._objectResult = result_config.resultObject;
                            outResult._BoolResult = true;

#if UNITY_EDITOR
								string path = "Assets/__BaseLobby/Resources/Texts/";
                            if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                            File.WriteAllText(path + filename, result._wwwResult.text);
                            UnityEngine.Debug.Log("CK : ------------------------------<color=green> 平台: = " + platformName + ", 配置文件: = " + filename +" 已更新</color>" );
#endif
                        }
                    }

                    if (Constants.isEditor)
                        UnityEngine.Debug.Log("CK : ------------------------------//// curUrl valid = " + curUrl + ", text = " + result._wwwResult.text);
                }

                if (coroutine != null) mono.StopCoroutine(coroutine);
                coroutine = null;
            }));
        }

        while (coroutine != null && outResult._BoolResult == false) yield return 0;//直到有一个ip获取到或者最后一个url完成连接为止

        if (result)
        {
            result._wwwResult.DisposeAsync();
            result._wwwResult = null;
        }
        result = null;

        if (coroutine != null) mono.StopCoroutine(coroutine);
        coroutine = null;

        //UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_concurrent complete = "  );
    }
    #endregion 加载总配置文件

    #region ip地址不通是,切换ip
    //切换游戏IP
    public virtual void swithGameHostUrl(System.Action onComplete = null)
    {
        //if (!string.IsNullOrEmpty(SocketConnectInfo.Instance.roomHost)) return;

        if (game_HostURL_Arr == null || (game_HostURL_Arr != null && game_HostURL_Arr.Count <= 0))
        {
            if (onComplete != null) onComplete();
            return;
        }

        game_Cutt++;

        if (game_Cutt >= game_HostURL_Arr.Count)
        {
            game_Cutt = 0;
            StaticUtils.GetGameManager().StartCoroutine(LoadConf_game_hostArr(()=>swithGameHostUrl_internal(onComplete)));
        }else swithGameHostUrl_internal(onComplete);// shawn.update

        EginTools.Log("切换game IP：" + game_URL);
    }

    private void swithGameHostUrl_internal(System.Action onComplete = null)
    {
        if (game_Cutt < game_HostURL_Arr.Count)
        {
            game_URL = game_HostURL_Arr[game_Cutt].ToString();
        }

        if (onComplete != null) onComplete();
    }

    //切换网页IP
    /// <summary>
    /// 
    /// </summary>
    /// <param name="isHttp">由于加了socket大厅后这里有http请求和 socket 大厅请求的切换,因此用 itHttp 来判断是否是http地址. 避免原本为了切换http地址而切换了socket地址</param>
    public virtual void swithWebHostUrl(bool isHttp = true, System.Action onComplete = null)
    {
        if (isHttp && this.IsSocketLobby)
        {
            if (onComplete != null) onComplete();
            return;//请求http地址切换,在socket 大厅模式下,将不会进行切换
        }
        if (web_HostURL_Arr == null || (web_HostURL_Arr != null && web_HostURL_Arr.Count <= 0))
        {
            if (onComplete != null) onComplete();
            return;
        }
        web_Cutt++;

        if (web_Cutt >= web_HostURL_Arr.Count)
        {
            web_Cutt = 0;
            StaticUtils.GetGameManager().StartCoroutine(LoadConf_web_hostArr(()=>swithWebHostUrl_internal(onComplete)));
        }else swithWebHostUrl_internal(onComplete);

        EginTools.Log("切换web IP：" + web_URL);
    }

    private void swithWebHostUrl_internal(System.Action onComplete = null)
    {
        if (web_Cutt < web_HostURL_Arr.Count)
        {
            hostURL = web_HostURL_Arr[web_Cutt].ToString();//
            web_URL = web_HostURL_Arr[web_Cutt].ToString();//web_URL 和 hostURL 是同一个，为了兼容而写成2个
            ConnectDefine.updateConfig();

        }

        if (onComplete != null) onComplete();
    }

    //切换socket大厅ip, 已弃用
    public virtual void swithSocketLobbyHostUrl(System.Action onComplete = null)
    {
        swithWebHostUrl(false, onComplete);
    }
    #endregion ip地址不通是,切换ip


    //------------------------------------------------------------------------

    #region 获取conf配置文件及ip 相关方法区
    public virtual IEnumerator LoadConfByUser(string username)
    {
        MonoBehaviour mono = StaticUtils.GetGameManager();
        EginUser.Instance.username = username;
        
        yield return mono.Start_Coroutine(null, 
            LoadConf_web_hostArr(), 
            LoadConf_game_hostArr());//并联式启动和停止2个协程
    }

    public virtual void Start_LoadAndSaveConfigData(System.Action onComplete = null)
    {
        MonoBehaviour mono = StaticUtils.GetGameManager();
        mono.StartCoroutine(LoadAndSaveConfigData(onComplete, 0));
    }

    /// <summary>
    /// 从网络获取最新的config和conf数据并进行持久化存储(用于加快游戏启动速度, 启动时 首先从本地获取config和ip)
    /// </summary>
    /// <returns></returns>
    public virtual IEnumerator LoadAndSaveConfigData(System.Action onComplete = null, float delayTime = 15f)
    {
        yield return new WaitForSeconds(delayTime);
        MonoBehaviour mono = StaticUtils.GetGameManager();

        yield return mono.StartCoroutine(LoadConfig());//重新加载config文件
        yield return mono.Start_Coroutine(null,
            LoadConfig_web_hostArr(null,true),
            LoadConfig_game_hostArr(null,true));//把所有conf文件中有效的 加密的ip 字符串 进行持久化存储

        if (onComplete != null) onComplete();
    }
    #region 加载游戏ip相关方法
    /// <summary>
    /// 把所有的conf 的 url 加到一个list中
    /// </summary>
    /// <returns></returns>
    public virtual IEnumerator LoadConfig_game_hostArr(System.Action onComplete = null, bool isSaveAllConf = false)
    {
        if (Constants.isEditor) UnityEngine.Debug.Log("CK : ----------------**********-------------- LoadConfig_Game_hostArr = ");

        MonoBehaviour mono = StaticUtils.GetGameManager();
        List<string> resultList = new List<string>() { "", "" };//2个空字符串,是2个占位符,分表代表默认的wfname1和wfname的url地址

        if (!string.IsNullOrEmpty(EginUser.Instance.username))
        {
            string gfname1 = PlayerPrefs.GetString(EginUser._GFname1);
            //if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------LoadConfig_Game_hostArr wfname1 = " + gfname1);

            if (!string.IsNullOrEmpty(gfname1)) resultList[0] = gfname1;

            string gfname = PlayerPrefs.GetString(EginUser._GFname);
            if (!string.IsNullOrEmpty(gfname))
            {
                string Game_HostURL = PlatformGameDefine.playform.UpdateGFnameURL(gfname);
                resultList[1] = Game_HostURL;
                //if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------LoadConfig_Game_hostArr Game_HostURL = " + Game_HostURL);
            }
        }

        resultList.AddRange_Raw(game_conf_list);

#if UNITY_EDITOR
        string str = null;
        for (int i = 0; i < resultList.Count; i++)
        {
            str += i + " = " + resultList[i] + "\r\n";
        }
        if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ <color=red>result list game</color> = " + str);
#endif
        yield return mono.StartCoroutine(SwitchConf(resultList, m_cur_game_conf_index, LoadGameIPs, (index, list) =>
        {
            if (isSaveAllConf) Save_ListString("game_conf_cryptedStr_list", list);//重新获取conf 加密 字符串列表,并持久化存储
            m_cur_game_conf_index = index;
        }, isSaveAllConf));

        if (onComplete != null) onComplete();
    }

    /// <summary>
    /// 加载 conf 文件里面的加密字符串(保存在本地) 里的ip
    /// </summary>
    /// <param name="onComplete"></param>
    /// <returns></returns>
    public virtual IEnumerator LoadConf_game_hostArr(System.Action onComplete = null)
    {
        if (Constants.isEditor) UnityEngine.Debug.Log("CK : ----------------**********-------------- LoadConf_Game_hostArr ");
        MonoBehaviour mono = StaticUtils.GetGameManager();
        List<string> resultList = new List<string>() { ""};//1个空字符串,是1个占位符,为用户对应的默认ip

        if (!string.IsNullOrEmpty(EginUser.Instance.username))
        {
            string gameIP = EginUser._GameIPForCurUser;
            //if (Constants.isEditor) UnityEngine.Debug.Log("CK : ---------------LoadConf_game_hostArr--------------- gameIP = " + gameIP);

            if (!string.IsNullOrEmpty(gameIP))
                resultList[0] = gameIP;
        }
        
        resultList.AddRange_Raw(Load_ListString("game_conf_cryptedStr_list"));

        if(!resultList.Exists(a=>!string.IsNullOrEmpty(a)) || !IsCache_UserIp)//不存在有效的conf数据 或者 不使用缓存
        {
            yield return mono.StartCoroutine(LoadConfig_game_hostArr(onComplete));//如果本地没有数据,就从conf 的 url 中加载 ip
            yield break;
        }
#if UNITY_EDITOR
        string str = null;
        for (int i = 0; i < resultList.Count; i++)
        {
            str += i + " = " + resultList[i] + "\r\n";
        }
        if (Constants.isEditor) UnityEngine.Debug.Log("CK : ---------------LoadConf_Game_hostArr--------------- result list game = " + str);
#endif
        yield return mono.StartCoroutine(SwitchConf(resultList, m_cur_game_conf_index, LoadGameIPs, (index, List) => m_cur_game_conf_index = index));

        if (onComplete != null) onComplete();
    }

    #region 已弃用, 使用 把所有的conf加到一个list中 的方式代替这种方案
    //加载游戏IP
    /// <summary>
    /// 加载游戏配置文件的逻辑判断
    /// </summary>
    /// <returns></returns>
    //public IEnumerator LoadConfig_game_hostArr()
    //{
    //    //UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_game_hostArr = " );

    //    MonoBehaviour mono = StaticUtils.GetGameManager();
    //    CoroutineResult result = new CoroutineResult();

    //    if (!string.IsNullOrEmpty(EginUser.Instance.username))
    //    {
    //        //用户存在时,首先使用gfname1地址 获取ip
    //        string gfname1 = PlayerPrefs.GetString(EginUser._GFname1);
    //        //UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_game_hostArr gfname1 = " + gfname1);
    //        if (!string.IsNullOrEmpty(gfname1))
    //            yield return mono.StartCoroutine(LoadConfig_game_hostArr(gfname1, result, true));
    //        else result.error = "gfname1 not exist";

    //        //用户存在且gfname1不通时,使用默认地址+gfname 文件名(替换) 获取ip
    //        if (!string.IsNullOrEmpty(result.error))
    //        {
    //            string gfname = PlayerPrefs.GetString(EginUser._GFname);
    //            string game_HostURL = PlatformGameDefine.playform.UpdateGFnameURL(gfname);
    //            //UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_game_hostArr game_HostURL = " + game_HostURL);
    //            result.error = null;
    //            yield return mono.StartCoroutine(LoadConfig_game_hostArr(game_HostURL, result, false));
    //        }
    //    }
    //    else result.error = "username is null";

    //    //以上操作都没有成功时,使用默认地址 获取ip
    //    if (!string.IsNullOrEmpty(result.error))
    //    {
    //        yield return mono.StartCoroutine(LoadConfig_game_hostArr(game_HostURL, null, false));//最后的地址,这里可以添加切换
    //    }
    //}
    #endregion 已弃用,使用 把所有的conf加到一个list中 的方式代替这种方案

    #region 已弃用,使用辅助区的SwitchConf方法替代
    /// <summary>
    /// 通过url地址获取 配置文件
    /// </summary>
    /// <param name="config_url"></param>
    /// <param name="result"></param>
    /// <param name="isSaveIP"></param>
    /// <returns></returns>
    //public IEnumerator LoadConfig_game_hostArr(string game_HostURL, CoroutineResult result, bool isSaveIP)
    //{
    //    //UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_game_hostArr = " + config_url + ", isSaveIP = " + isSaveIP + ", game_HostURL = " + game_HostURL);

    //    //game_HostURL_Arr.Clear();
    //    System.Random ro = new System.Random();
    //    string config_url = game_HostURL + "?" + ro.NextDouble();


    //    WWW www_config = HttpConnect.Instance.HttpRequestAli(config_url);
    //    yield return www_config;
    //    // shawn.update 不判断无错的话，会崩溃
    //    if (www_config.error == null)
    //    {
    //        string tempResultStr = www_config.text.Trim();
    //        if (isSaveIP && !string.IsNullOrEmpty(EginUser.Instance.username))
    //        {//保存用户的ip
    //            PlayerPrefs.SetString(EginUser._GameIP, tempResultStr);
    //            PlayerPrefs.Save();
    //            EginUser.AddGameIPUsers();
    //        }
    //        // tempResultStr = "Gt2v7jRQkwW6XjfDPQWES+nF3qFNUFyRXFmzQaZn+8U91LH4Y2zNmyhchPGw5fPO";
    //        LoadGameIPs(tempResultStr);
    //    }

    //    if (result) result.error = www_config.error;
    //}
    #endregion 已弃用,使用辅助区的SwitchConf方法替代

    public virtual bool LoadGameIPs(bool isSaveIP, string tempResultStr, bool isSaveAllConf = false)
    {
        bool isValidIpLoaded = LoadGameIPs(tempResultStr, isSaveAllConf);//LoadGameIPs(tempResultStr);
        if (isValidIpLoaded && isSaveIP) EginUser.AddGameIPUsers(tempResultStr);//保存用户的ip
        return isValidIpLoaded;
    }

    /// <summary>
    /// 通过加密字符串获取ip地址
    /// </summary>
    /// <param name="tempResultStr"></param>
    public virtual bool LoadGameIPs(string tempResultStr, bool isSaveAllConf = false)
    {
        //UnityEngine.Debug.Log("CK : ------------------------------//////// LoadGameIPs = " + tempResultStr);
        ArrayList game_HostURL_Arr = aesDecryptToUrlList(tempResultStr);
        if (game_HostURL_Arr == null || game_HostURL_Arr.Count <= 0) return false;

        if (!isSaveAllConf || !IsCache_UserIp)//不存在有效的conf数据 或者 不使用缓存
        {
            game_Cutt = 0;
            this.game_HostURL_Arr.Clear();
            this.game_HostURL_Arr = game_HostURL_Arr;
            game_URL = this.game_HostURL_Arr[0].ToString();
        }

#if UNITY_EDITOR
        string tempStr = string.Empty;
        for (int i = 0; i < game_HostURL_Arr.Count; i++)
        {
            tempStr += game_HostURL_Arr[i] + ",";
        }
        UnityEngine.Debug.Log("ck debug : -------------------------------- <color=orange>LoadGameIPs </color>= " + tempStr); 
#endif

        return game_HostURL_Arr.Count > 0;//大于0 说明获得了有效的ip
    }

    /// <summary>
    /// 替换游戏配置文件名
    /// </summary>
    /// <param name="game"></param>
    /// <returns></returns>
    public virtual string UpdateGFnameURL(string game)
    {
        string game_HostURL = this.game_HostURL;
        if (game != "")
        {

            string[] arr = game_HostURL.Split('/');
            game_HostURL = "";
            for (int i = 0; i < arr.Length - 1; i++)
            {
                if (i == 0)
                {
                    game_HostURL = arr[i];
                }
                else
                {
                    game_HostURL = game_HostURL + "/" + arr[i];
                }
            }
            game_HostURL = game_HostURL + "/" + game;
        }
        return game_HostURL;
    }
    #endregion 加载游戏ip相关方法

    #region 加载web(大厅)ip 相关方法
    /// <summary>
    /// 把所有的conf 的 url加到一个list中
    /// </summary>
    /// <returns></returns>
    public virtual IEnumerator LoadConfig_web_hostArr(System.Action onComplete = null, bool isSaveAllConf = false)
    {
        UnityEngine.Debug.Log("CK : -------------------**********----------- LoadConfig_web_hostArr ");

        MonoBehaviour mono = StaticUtils.GetGameManager();
        List<string> resultList = new List<string>() { "",""};//2个空字符串,是2个占位符,分表代表默认的wfname1和wfname的url地址

        if (!string.IsNullOrEmpty(EginUser.Instance.username))
        {
            string wfname1 = PlayerPrefs.GetString(EginUser._WFname1);
            //if(Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------LoadConfig_web_hostArr wfname1 = " + wfname1);

            if (!string.IsNullOrEmpty(wfname1)) resultList[0] = wfname1;
            
            string wfname = PlayerPrefs.GetString(EginUser._WFname);

            if (!string.IsNullOrEmpty(wfname))
            {
                string web_HostURL = PlatformGameDefine.playform.UpdateWFnameURL(wfname);
                resultList[1] = web_HostURL;
                //if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------LoadConfig_web_hostArr web_HostURL = " + web_HostURL);
            }
        }

        resultList.AddRange_Raw(web_conf_list);

#if UNITY_EDITOR
        string str = null;
        for (int i = 0; i < resultList.Count; i++)
        {
            str += i +" = " + resultList[i] + "\r\n";
        }
        UnityEngine.Debug.Log("CK : ------------------------------ result list web = " + str );
#endif
        yield return mono.StartCoroutine(SwitchConf(resultList, m_cur_web_conf_index, LoadWebIPs, (index, list) =>
        {
            m_cur_web_conf_index = index;
            if (isSaveAllConf)  Save_ListString("web_conf_cryptedStr_list", list);//重新获取conf 加密 字符串列表,并持久化存储
        },isSaveAllConf));

        if (onComplete != null) onComplete();
    }

    /// <summary>
    /// 加载 conf 文件里面的加密字符串(保存在本地) 里的ip
    /// </summary>
    /// <param name="onComplete"></param>
    /// <returns></returns>
    public virtual IEnumerator LoadConf_web_hostArr(System.Action onComplete = null)
    {
        UnityEngine.Debug.Log("CK : -------------------**********----------- LoadConf_web_hostArr = ");

        MonoBehaviour mono = StaticUtils.GetGameManager();
        List<string> resultList = new List<string>() { "" };//1个空字符串,是1个占位符,分表代表默认的wfname1和wfname的url地址

        if (!string.IsNullOrEmpty(EginUser.Instance.username))
        {
            string webIP = EginUser._WebIPForCurUser;
            //if (Constants.isEditor) UnityEngine.Debug.Log("CK : ----------------LoadConf_web_hostArr-------------- webIP = " + webIP);

            if (!string.IsNullOrEmpty(webIP))
                resultList[0] = webIP;
        }

        resultList.AddRange_Raw(Load_ListString("web_conf_cryptedStr_list"));

        if (!resultList.Exists(a=>!string.IsNullOrEmpty(a)) || !IsCache_UserIp)//不存在有效的conf数据 或者 不使用缓存
        {
            yield return mono.StartCoroutine(LoadConfig_web_hostArr(onComplete));
            yield break;
        }
        
#if UNITY_EDITOR
        string str = null;
        for (int i = 0; i < resultList.Count; i++)
        {
            str += i + " = " + resultList[i] + "\r\n";
        }
        if (Constants.isEditor) UnityEngine.Debug.Log("CK : --------------LoadConf_web_hostArr---------------- result list web = " + str);
#endif   
        yield return mono.StartCoroutine(SwitchConf(resultList, m_cur_web_conf_index, LoadWebIPs, (index,list) => m_cur_web_conf_index = index));
        if (onComplete != null) onComplete();
    }


    #region 已弃用,使用 把所有的conf加到一个list中 的方案代替
    /// <summary>
    /// 加载web配置文件的逻辑判断
    /// </summary>
    /// <returns></returns>
    //public IEnumerator LoadConfig_web_hostArr()
    //{
    //    //UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_web_hostArr = ");

    //    MonoBehaviour mono = StaticUtils.GetGameManager();
    //    CoroutineResult result = new CoroutineResult();

    //    if (!string.IsNullOrEmpty(EginUser.Instance.username))
    //    {
    //        string wfname1 = PlayerPrefs.GetString(EginUser._WFname1);
    //        //UnityEngine.Debug.Log("CK : ------------------------------LoadConfig_web_hostArr wfname1 = " + wfname1);

    //        if (!string.IsNullOrEmpty(wfname1))
    //            yield return mono.StartCoroutine(LoadConfig_web_hostArr(wfname1, result, true));
    //        else result.error = "wfname1 not exist";

    //        if (!string.IsNullOrEmpty(result.error))
    //        {
    //            string wfname = PlayerPrefs.GetString(EginUser._WFname);
    //            string web_HostURL = PlatformGameDefine.playform.UpdateWFnameURL(wfname);
    //            //UnityEngine.Debug.Log("CK : ------------------------------LoadConfig_web_hostArr web_HostURL = " + web_HostURL);
    //            result.error = null;
    //            yield return mono.StartCoroutine(LoadConfig_web_hostArr(web_HostURL, result, false));
    //        }
    //    }
    //    else result.error = "username is null";

    //    if (!string.IsNullOrEmpty(result.error))
    //    {
    //        yield return mono.StartCoroutine(LoadConfig_web_hostArr(web_HostURL, null, false));
    //    }
    //}
    #endregion 已弃用,使用 把所有的conf加到一个list中 的方案代替

    #region 已弃用,使用SwitchConf代替
    //加载网页IP
    /// <summary>
    /// 通过url获取配置文件
    /// </summary>
    /// <param name="web_HostURL"></param>
    /// <param name="result"></param>
    /// <param name="isSaveIP"></param>
    /// <returns></returns>
    //public IEnumerator LoadConfig_web_hostArr(string web_HostURL, CoroutineResult result, bool isSaveIP)
    //{
    //    //UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_web_hostArr = " + web_HostURL + ", isSaveIP = " + isSaveIP);

    //    //web_HostURL_Arr.Clear();
    //    System.Random ro = new System.Random();
    //    string config_url = web_HostURL + "?" + ro.NextDouble();

    //    WWW www_config = HttpConnect.Instance.HttpRequestAli(config_url);
    //    yield return www_config;
    //    // shawn.update 不判断无错的话，会崩溃

    //    if (www_config.error == null)
    //    {
    //        string tempResultStr = www_config.text.Trim();
    //        if (isSaveIP && !string.IsNullOrEmpty(EginUser.Instance.username))
    //        {//保存用户的ip
    //            PlayerPrefs.SetString(EginUser._WebIP, tempResultStr);
    //            PlayerPrefs.Save();
    //            EginUser.AddWebIPUsers();
    //        }
    //        LoadWebIPs(tempResultStr);
    //    }

    //    if (result) result.error = www_config.error;
    //}
    #endregion 已弃用,使用SwitchConf代替

    public virtual bool LoadWebIPs(bool isSaveIP, string tempResultStr, bool isSaveAllConf = false)
    {
        bool isValidIpLoaded = LoadWebIPs(tempResultStr,isSaveAllConf);//LoadGameIPs(tempResultStr);
        if (isValidIpLoaded && isSaveIP) EginUser.AddWebIPUsers(tempResultStr);//保存用户的ip
        return isValidIpLoaded;
    }

    /// <summary>
    /// 从加密字符串中获取web ip地址
    /// </summary>
    /// <param name="tempResultStr"></param>
    public virtual bool LoadWebIPs(string tempResultStr, bool isSaveAllConf = false)
    {
        ArrayList web_HostURL_Arr = aesDecryptToUrlList(tempResultStr,!this.IsSocketLobby);
        if (web_HostURL_Arr == null || web_HostURL_Arr.Count <= 0) return false;

        if (!isSaveAllConf || !IsCache_UserIp)//不存在有效的conf数据 或者 不使用缓存
        {
            web_Cutt = 0;
            this.web_HostURL_Arr.Clear();
            this.web_HostURL_Arr = web_HostURL_Arr;
            web_URL = this.web_HostURL_Arr[0].ToString();
            hostURL = this.web_HostURL_Arr[0].ToString();

            if (Constants.isEditor)
            {
                string tempStr = string.Empty;
                foreach (var item in web_HostURL_Arr)
                {
                    tempStr += item + ", ";
                }

                UnityEngine.Debug.Log("ck debug : -------------------------------- LoadWebIPs = " + tempStr);
            }
        }

        return this.web_HostURL_Arr.Count > 0;//大于0 数目存在有效ip
    }

    /// <summary>
    /// 替换web配置文件名
    /// </summary>
    /// <param name="web"></param>
    /// <returns></returns>
    public virtual string UpdateWFnameURL(string web)
    {
        string web_HostURL = this.web_HostURL;
        if (web != "")
        {
            string[] arr = web_HostURL.Split('/');
            web_HostURL = "";
            for (int i = 0; i < arr.Length - 1; i++)
            {
                if (i == 0)
                {
                    web_HostURL = arr[i];
                }
                else
                {
                    web_HostURL = web_HostURL + "/" + arr[i];
                }
            }
            web_HostURL = web_HostURL + "/" + web;
        }

        EginTools.Log("web_HostURL" + web_HostURL);
        return web_HostURL;
    }
    #endregion 加载web(大厅)ip 相关方法

    #region 解密配置文件中的加密字符串的方法
    /// <summary>
    /// 把加密数据的解密后数据装换成list
    /// </summary>
    /// <param name="isHttp"></param>
    /// <param name="tempResultStr"></param>
    /// <returns></returns>
    protected virtual ArrayList aesDecryptToUrlList(string tempResultStr, bool isHttp = false)
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

    protected virtual string aesDecrypt(string encrypted_data)
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
    #endregion 获取conf配置文件及ip 相关方法区


    #region 辅助方法区
    #region 把xml配置文件中的某项值解析到List中,该值可以是string也可以是string 数组
    private List<string> ParseArrayOrStringJson(JSONObject arrayOrStringJson, List<string> result_List = null)
    {
        if (result_List == null) result_List = new List<string>();
        string url = null;
        if (arrayOrStringJson.IsAvailable())
        {
            if (arrayOrStringJson.type == JSONObject.Type.ARRAY && arrayOrStringJson.list != null)
            {
                for (int i = 0; i < arrayOrStringJson.list.Count; i++)
                {
                    url = Regex.Unescape(arrayOrStringJson.list[i].str);//热更新url地址
                    if (!result_List.Contains(url)) result_List.Add(url);
                }
            }
            else if (arrayOrStringJson.type == JSONObject.Type.STRING && !string.IsNullOrEmpty(arrayOrStringJson.str))
            {
                url = Regex.Unescape(arrayOrStringJson.str);//热更新url地址
                if (!result_List.Contains(url)) result_List.Add(url);
            }
        }

        return result_List;
    }
    #endregion 把xml配置文件中的某项值解析到List中,该值可以是string也可以是string 数组

    #region 对所有的url进行ping处理,如果在2秒内没有ping通,那么就认为该地址无法连接
    private IEnumerator ObtainPingUrls(string[] urls, List<string> resultList)
    {
        if (resultList == null) throw new Exception("method ObtainPingUrls, the argument resultList cannot be null ");
        Dictionary<string, Ping> pingMap = new Dictionary<string, Ping>();
        //List<string> resultList = new List<string>();

        for (int i = 0; i < urls.Length; i++)
        {
            Ping ping = StaticUtils.ObtainPingFromUrl(urls[i]);//获取所有的ping对象
            if (ping != null) pingMap[urls[i]] = ping;// StaticUtils.ObtainPingFromUrl(urls[i]);//获取所有的ping对象
        }

        Dictionary<Ping, string> pingMapTime = new Dictionary<Ping, string>();
        List<Ping> pingList = new List<Ping>();
        float curTime = 0;

        while (pingList.Count < pingMap.Count && curTime < 2)//1秒内ping通为有效
        {
            curTime += Time.deltaTime;
            foreach (var item in pingMap)
            {
                if (item.Value.isDone && !pingList.Contains(item.Value) && !"127.0.0.1".Equals(item.Value.ip))
                {
                    pingList.Add(item.Value);//添加用于排序的ping list
                    pingMapTime[item.Value] = item.Key;//添加ping 和 原路径的映射关系
                }
            }
            yield return 0;
        }

        pingList.Sort((a, b) => a.time - b.time);//通过时间排序
        foreach (var item in pingList)
        {
            resultList.Add(pingMapTime[item]);//获得排序后的连接地址
        }

        foreach (var item in urls)
        {
            if (!resultList.Contains(item)) resultList.Add(item);//获得排序后没有添加在内的地址//避免默写host ping的时间大于2秒被遗漏. 连不通的地址很快就会被断开
        }

        foreach (var item in pingMap)
        {
            item.Value.DestroyPing();//销毁ping对象
        }

        pingList.Clear();//清空
        pingMapTime.Clear();//清空
        pingMap.Clear();//清空
        pingMap = null;
    }
    #endregion 对所有的url进行ping处理,如果在2秒内没有ping通,那么就认为该地址无法连接

    #region 切换 conf 文件. 并通过conf,切换ip地址
    public virtual IEnumerator SwitchConf(List<string> game_HostURL, int curIndex, System.Func<bool, string, bool, bool> loadIpsFunc, System.Action<int, List<string>> onComplete, bool isSaveAllConf = false)
    {
        //UnityEngine.Debug.Log("CK : ------------------------------ LoadConfig_game_hostArr = " + config_url + ", isSaveIP = " + isSaveIP + ", game_HostURL = " + game_HostURL);

        //game_HostURL_Arr.Clear();
        System.Random ro = new System.Random();
        CoroutineResult result = null;
        string config_url = null;// game_HostURL + "?" + ro.NextDouble();
        WWW www_config = null;// HttpConnect.Instance.HttpRequestAli(config_url);
        string tempResultStr = null;// www_config.text.Trim();
        bool isConfUrl = false;
        if (curIndex >= game_HostURL.Count) curIndex = 0;
        List<string> conf_crypted_list = new List<string>();
        for (; curIndex < game_HostURL.Count; curIndex++)
        {
            if (string.IsNullOrEmpty(game_HostURL[curIndex])) continue;//如果字符串(url)为空,就遍历后面的,
            config_url = game_HostURL[curIndex];
            tempResultStr = null;
            isConfUrl = config_url.ToLower().EndsWith(".conf");
            if (isConfUrl)//是conf文件的url
            {
                result = new CoroutineResult();
                config_url = config_url + "?" + ro.NextDouble();
                yield return result.WWWReConnect(config_url);

                www_config = result._wwwResult;
                if (result.error == null && www_config.error == null)
                {
                    tempResultStr = www_config.text.Trim();
                    www_config.DisposeAsync();
                    www_config = null;
                }
            }
            else//字符串不是conf文件//这里的情况为直接base64加密后的字符串,也就是conf文件里面的内容
            {
                tempResultStr = config_url;
            }

            if (tempResultStr != null && loadIpsFunc(curIndex == 0 && isConfUrl, tempResultStr, isSaveAllConf)) //break;//获得到有效ip后跳出循环//只有第一个是需要保存ip加密数据的url地址
            {
                if (isSaveAllConf) conf_crypted_list.Add_Raw(tempResultStr);
                else
                {
                    curIndex++;//获取成功后curIndex 需要+1. 避免死循环加载出有效的ip地址,而ip地址却无法正常连接到后台的bug
                    break;
                }
            }
        }

        if (onComplete != null) onComplete(curIndex, conf_crypted_list);
    }
    #endregion 切换 conf 文件,

    #region 加载/存储 conf 加密数据列表
    public virtual List<string> Load_ListString(string key)
    {
        string str = PlayerPrefs.GetString(EginUser.ObtainPlatformKey(key), "");
        List<string> resultList = new List<string>(str.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries));
        return resultList;
    }

    public virtual void Save_ListString(string key, List<string> list)
    {
        if (list == null || list.Count <= 0) return;
        string str = ",";
        for (int i = 0; i < list.Count; i++)
        {
            str += list[i] + ",";
        }

        PlayerPrefs.SetString(EginUser.ObtainPlatformKey(key), str);
        PlayerPrefs.Save();
    }
    #endregion 加载/存储 conf 加密数据列表


    #region 修改不同平台下的config.xml文件名
    protected virtual void FixConfigUrls(string[] urls)
    {
        if (urls == null) return;

        for (int i = 0; i < urls.Length; i++)
        {
            urls[i] = FixConfig(urls[i], IsSocketLobby);
        }
    }

    private string FixConfig(string url, bool isSocket)
    {
        if (string.IsNullOrEmpty(url)) return url;

        string fileName = System.IO.Path.GetFileName(url);
        string resultFileName = fileName;
        string fileNameWithOutExtension = System.IO.Path.GetFileNameWithoutExtension(url);
        
        switch (Utils.BUILDPLATFORM)
        {
            case BuildPlatform.IOS_AppStore://ios app stroe 使用 config.xml
                break;
            case BuildPlatform.IOS_Enterprise://企业版使用 config888.xml
                resultFileName = fileName.Replace(fileNameWithOutExtension, fileNameWithOutExtension + "888");
                break;
            case BuildPlatform.OSX://mac osx 版本, 使用 config777.xml
                resultFileName = fileName.Replace(fileNameWithOutExtension, fileNameWithOutExtension + "777");
                break;
            case BuildPlatform.Win://暂时没有
            case BuildPlatform.Android://android 使用 config999.xml
            default:
                resultFileName = fileName.Replace(fileNameWithOutExtension, fileNameWithOutExtension + "999");
                break;
        }

        if (isSocket) resultFileName = "socket_" + resultFileName;//socket 协议的xml, 文件名添加 socket_ 前缀
        
        return url.Replace(fileName, resultFileName);
    }
    #endregion 修改不同平台下的config文件名

    public virtual string GetPlatformPrefix()
    {
        string platform_prefix = string.Empty;
        if (this is PlatformGame1977 || this is PlatformGame597)
            platform_prefix = "597";
        else if (this is PlatformGame407)
            platform_prefix = "131";
        else if (this is PlatformGame510k)
            platform_prefix = "510k";

        return platform_prefix;
    }
    #endregion 辅助方法区

    //510k
    public virtual JSONObject DefaultHallHomeInfos()
    {
        //        string infoStr = ZPLocalization.Instance.Get("HallHomeInfos");
        if (HallHomeInfos == null) return null;

        string infoStr = HallHomeInfos;
        JSONObject defaultInfos = new JSONObject(infoStr);
        return defaultInfos;
    }

}



//把所有confurl都先拿到加密字符串