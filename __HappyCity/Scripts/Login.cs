using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System;

public class Login : BaseScene,SocketListener {
	
	public UIInput kUsername;
	public UIInput kPassword;
	public UIToggle kRemberPs;
	public UIToggle kAutoLogin;

    public UILabel verifyTitle;
	public GameObject verifyView;
	public UIInput verifyCode;

	public GameObject yanView;
	public UIInput kYanZheng; 
	public GameObject kYanImg;
    public GameObject _Reload_Config_gobj;

    private string captcha_hiddentext;

	private int errNum=0;
	 
	
	// Use this for initialization
	protected void Start () {

        if(PlatformGameDefine.playform.IsSocketLobby)
            EndSocket(true);
        //if(PlatformGameDefine.playform.IsSocketLobby)
        //    StartSocket();
        if (Utils._IsIPTest)
        {
            if (this.GetType().Name == "Login")
            {
                EginLoadLevel("IPTest_Login");
                return;
            }
        }

        kRemberPs.value = (PlayerPrefs.GetInt("RemberPS", 1) == 1);
		kAutoLogin.value = kRemberPs.value?(PlayerPrefs.GetInt("AutoLogin2", 1) == 1):false;	// 因 AutoLogin 被占用，所以此处使用 AutoLogin2 作为Key
		kUsername.value = PlayerPrefs.GetString("EginUsername", "");
		if(kRemberPs.value && kUsername.value.Length > 0) {
			kPassword.value = PlayerPrefs.GetString(kUsername.value, "");
		}

		StartCoroutine(loadConf());

		if (!PlatformGameDefine.playform.IsSocketLobby && PlatformGameDefine.playform.IsYan) {//socket 连接不需要验证码
				yanView.SetActive (true);
  		} else {
				yanView.SetActive(false);
		}

        EginUser.Instance.device_id = SystemInfo.deviceUniqueIdentifier;

        if (_Reload_Config_gobj)
        {
            _Reload_Config_gobj.SetActive(false);
            this.Delay(20f,()=> {
                _Reload_Config_gobj
                .SetActive(true);
            });
        }
    }

    public void OnClick_Reload_Config()
    {
		EginProgressHUD.Instance.ShowWaitHUD("正在加载配置文件...",true);
        if (_Reload_Config_gobj) _Reload_Config_gobj.SetActive(false);

        StartCoroutine( PlatformGameDefine.playform.LoadAndSaveConfigData(()=> {
            if (_Reload_Config_gobj) _Reload_Config_gobj.SetActive(true);

            EginProgressHUD.Instance.HideHUD();
            if (!PlatformGameDefine.playform.IsSocketLobby && PlatformGameDefine.playform.IsYan)
            {
                yanView.SetActive(true);
                StartCoroutine(refreshYanImg());
                isClick = false;
            }
            else
            {
                yanView.SetActive(false);
            }
        }, 0f));
    }

	IEnumerator loadConf(){
		yield return StartCoroutine(PlatformGameDefine.playform.LoadConfig());
 		if (!PlatformGameDefine.playform.IsSocketLobby && PlatformGameDefine.playform.IsYan) {
			yanView.SetActive (true);
			StartCoroutine(refreshYanImg());
			isClick = false;
		} else {
			yanView.SetActive(false);
		}
	}
 
	void Update () {
		if (Application.platform == RuntimePlatform.Android 
		    && (Input.GetKeyDown(KeyCode.Escape)) )
		{
			Application.Quit();
		}
	}

    //protected override void OnDestroy()
    //{
    //    EndSocket(true);
    //}

	private bool isClick = false;
	/* ------ Button Click 点击获取验证码------ */
	void OnClickRefreshYanZheng () {
		if(isClick){
			errNum = 0;
 			StartCoroutine(refreshYanImg());
		}
 	}
	
	IEnumerator refreshYanImg(){
   		WWW www2 = HttpConnect.Instance.HttpRequest(ConnectDefine.YAN_ZHENG_URL,null);
		yield return www2;
		
		HttpResult result2 = HttpConnect.Instance.BaseResult(www2);
		string yanUrl;
   		if(HttpResult.ResultType.Sucess == result2.resultType) {
  			JSONObject resultObj2 = new JSONObject(result2.resultObject.ToString());
			yanUrl = ConnectDefine.HostURL+resultObj2["imageurl"].str;
			captcha_hiddentext =resultObj2["hiddentext"].str;
 			EginTools.Log("yanUrl:"+yanUrl);

			WWW www = new WWW (yanUrl);
			yield return www;
 
			UITexture uiT = kYanImg.GetComponent<UITexture>();
 			uiT.mainTexture = www.texture;

			errNum = 0;
			isClick = true;
  		}else {
			errNum++;
            if (!result2.isSwitchHost)
            {
                PlatformGameDefine.playform.swithWebHostUrl();
            }
            if (errNum<4){
				StartCoroutine(refreshYanImg());
			}else{
				isClick = true;
			}
 		}
  	}
	
	/* ------ Button Click ------ */
	void OnClickLogin () {
		string errorInfo = "";
		if (kUsername.value.Length == 0) {
			errorInfo = ZPLocalization.Instance.Get("LoginUsername");
		} else if (kPassword.value.Length == 0) {
			errorInfo = ZPLocalization.Instance.Get("LoginPassword");
		}
		
		if (errorInfo.Length > 0) {
			EginProgressHUD.Instance.ShowPromptHUD(errorInfo);
		}else {
            if (PlatformGameDefine.playform.IsSocketLobby)
            {
                StartCoroutine(DoClick_SocketLogin());   
            }
            else StartCoroutine(DoClickLogin());
        }
	}

    private int curReconnectCount;
	IEnumerator DoClickLogin () {
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"));

		//yield return StartCoroutine(PlatformGameDefine.playform.LoadConfig());

		WWWForm form = new WWWForm();
		form.AddField("username", kUsername.value);
		form.AddField("password", kPassword.value);
		form.AddField("device_id", "unity_"+SystemInfo.deviceUniqueIdentifier);//

		if (PlatformGameDefine.playform.IsYan) {
			form.AddField("captcha_text", kYanZheng.value??"");
			form.AddField("captcha_hiddentext", captcha_hiddentext??"");
		}
 
#if UNITY_ANDROID
		int mVersionCode = Mathf.Max (PlayerPrefs.GetInt ("VersionCode", PlatformGameDefine.game.VersionCode), PlatformGameDefine.game.VersionCode);
		//Debug.Log("======login======"+mVersionCode);
		form.AddField("version", mVersionCode);
		form.AddField("platform", "Android");
#else
		form.AddField("platform", "iOS");
#endif

		EginTools.Log ("ConnectDefine.LOGIN_URL:"+ConnectDefine.LOGIN_URL);

        WWW www = HttpConnect.Instance.HttpRequest(ConnectDefine.LOGIN_URL, form); //UnityEngine.Debug.Log("CK : ------------------------------ ConnectDefine.LOGIN_URL = " + ConnectDefine.LOGIN_URL);

        yield return www;
		
		HttpResult result = HttpConnect.Instance.UserLoginResult(www);
		//result.resultObject = "device_verify";
		 
		EginProgressHUD.Instance.HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType) {
			SaveLoginInfo();
			 
			EginLoadLevel("Hall");
		}else {
			if(result.resultObject.ToString() == "device_verify") {
				//SaveLoginInfo();
				verifyView.SetActive(true);
			}else{

                bool isSwitchHost = result.isSwitchHost && curReconnectCount < 2;

                if (Utils._IsIPTest)
                    isSwitchHost = string.IsNullOrEmpty(IPTest_Login._WebURL) && result.isSwitchHost && curReconnectCount < 2;

                if(isSwitchHost)
                {
                    curReconnectCount++;
                    //UnityEngine.Debug.Log("CK : ------------------------------ relogin = " + curReconnectCount);
                    StartCoroutine(DoClickLogin());//如果连接失败,则切换ip后重新登入
                }
                else
                {
                    curReconnectCount = 0;
				    //PlatformGameDefine.playform.swithWebHostUrl();

				    EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
                    //yield return new WaitForSeconds(1.5f);
                    //EginProgressHUD.Instance.HideHUD();
                    OnClickRefreshYanZheng();
                }
            }
 		}
	}

	void OnClickVerify () {
		verifyView.SetActive(false);
        if (PlatformGameDefine.playform.IsSocketLobby) SocketDevice_Verify();
        else StartCoroutine(DoVerify());
	}

	IEnumerator DoVerify () {
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"));

		string username = kUsername.value;// PlayerPrefs.GetString("EginUsername", "");
  		WWWForm form = new WWWForm();
		form.AddField("username", username);
		form.AddField("verify_code", verifyCode.value);
 		form.AddField("device_id", "unity_"+SystemInfo.deviceUniqueIdentifier);



		WWW www = HttpConnect.Instance.HttpRequest(ConnectDefine.VERIFY_CODE_URL, form);
		yield return www;


		HttpResult result = HttpConnect.Instance.BaseResult(www);
		
		EginProgressHUD.Instance.HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType) {
 			EginLoadLevel("Hall");
		}else {
 				EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
 		}
	}

	
	IEnumerator OnClickGuest () {
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"));
		
		WWW www = HttpConnect.Instance.HttpRequest(ConnectDefine.GUEST_LOGIN_URL, null);
		yield return www;
		
		HttpResult result = HttpConnect.Instance.GuestLoginResult(www);
		EginProgressHUD.Instance.HideHUD ();
		if(HttpResult.ResultType.Sucess == result.resultType) {
			EginLoadLevel("Hall");
		}else {
			EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string, 2.0f);
		}
	}
	
	void OnClickRegister () {
		EginLoadLevel("Register");
	}
	
	void OnClickForget () {
		Application.OpenURL(ConnectDefine.FORGET_PASSWORD_URL);
	}
	
	public void OnChangeRemberPs () {
		if (!kRemberPs.value) {
			kAutoLogin.value = false;
		}
	}
	
	public void OnChangeAutoLogin () {
		if (kAutoLogin.value) {
			kRemberPs.value = true;
		}
	}
	
	/* ------ Other ------ */
	private void SaveLoginInfo () {
		PlayerPrefs.SetString("EginUsername", kUsername.value);
		if (kRemberPs.value) {
			PlayerPrefs.SetString(kUsername.value, kPassword.value);
		}
		PlayerPrefs.SetInt("RemberPS", kRemberPs.value?1:0);
		PlayerPrefs.SetInt("AutoLogin2", kAutoLogin.value?1:0);
		PlayerPrefs.Save();
	}

    #region socket相关
    IEnumerator DoClick_SocketLogin()
    {
        ProtocolHelper._LoginType = LoginType.Username;
        EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"),true);
        //ProtocolHelper.Send_account_login(kUsername.value, kPassword.value);
        //EndSocket(true);
        Debug.Log("&&&&&&&&&&&&&&&&&&&&&&&&click  c#    &&&&&&&&&&&&&&&&" + SocketConnectInfo.Instance.lobbyUserName);
        SocketConnectInfo.Instance.lobbyUserName = kUsername.value;//设置登录用的用户名和密码
        SocketConnectInfo.Instance.lobbyPassword = kPassword.value;
        curReconnectCount = 0;
        m_account_login_error_str = null;
        //yield return StartCoroutine( PlatformGameDefine.playform.LoadConfByUser(kUsername.value));
        //StartSocket(true);
        yield return StartCoroutine(StartSocketLogin());
    }

    private IEnumerator StartSocketLogin(float delay = 0)
    {
        if (delay > 0) yield return new WaitForSeconds(delay);
        yield return StartCoroutine(PlatformGameDefine.playform.LoadConfByUser(kUsername.value));
        StartSocket(true);
    }

    private string m_account_login_error_str = null;
    public override void OnSocketDisconnect(string disconnectInfo)
    {
        //UnityEngine.Debug.Log("CK : ------------------------------ OnSocketDisconnect = " + disconnectInfo + ", curReconnectCount = " + curReconnectCount + ", m_account_login_error_str = " + m_account_login_error_str);

        //if (disconnectInfo.Contains(SocketManager.UNITY_HOST_EXCEPTION))
        //{//socket 连接时,如果 发生异常,就直接切换下一个ip
        //    PlatformGameDefine.playform.swithSocketLobbyHostUrl(() =>
        //    {
        //        if (this) StartSocket(true);//登录界面重连超过限制后不再重连//非登录界面则重连
        //    });

        //    return;
        //}

        if (m_account_login_error_str != null) return;

        if(curReconnectCount < 2)
        {
            base.OnSocketDisconnect(disconnectInfo);
        }
        else if(curReconnectCount == 2)
        {
            EginProgressHUD.Instance.ShowPromptHUD(disconnectInfo); 
        }
            curReconnectCount++;
    }

    private int m_AccountNotFoundCount = 0;
    public override void Process_account_login_Failed(string errorInfo, string body)
    {//登入错误,不是连接错误,这里已经连接上了,不用重连
        m_account_login_error_str = errorInfo;
        //UnityEngine.Debug.Log("CK : ------------------------------ errorInfo = " + errorInfo);

        EginProgressHUD.Instance.HideHUD();
        if (errorInfo != null && "device_verify".Equals(errorInfo.Trim('"'))) 
        {
            Dictionary<string, string> verifyTitleMap = new Dictionary<string, string>() {
                { "secret","请输入手机令牌码"},
                { "cert","请输入身份验证码"},
                { "wechat","请输入微信验证码" },
                { "phone","请输入手机验证码" }
            };
            body = body.Trim('"');
            if (verifyTitle && verifyTitleMap.ContainsKey(body)) verifyTitle.text = verifyTitleMap[body];
            verifyView.SetActive(true);
        }else if (errorInfo.Contains("账户不存在") && m_AccountNotFoundCount < 2)
        {
            m_AccountNotFoundCount++;
            StartCoroutine(StartSocketLogin(10));
        }
        else
        {
            m_AccountNotFoundCount = 0;
            Dictionary<string, string> verifyTitleMap = new Dictionary<string, string>() {
                { "failed","用户名或密码错误"},
                { "inactive","未激活" },
                { "locked","锁定" }
            };

            if (verifyTitleMap.ContainsKey(errorInfo.Trim('"')))
                errorInfo = verifyTitleMap[errorInfo.Trim('"')];

            EginProgressHUD.Instance.ShowPromptHUD(errorInfo);
        }
    }

    public override void Process_account_login(string info)
    {//登入成功,也代表重连成功, 因为重连后就会进行登入操作
        GetUserInfo_socket();
    }

    private void GetUserInfo_socket()
    {
        EginProgressHUD.Instance.ShowWaitHUD("正在获取用户数据...", true);

        ProtocolHelper.Send_get_account();//获取用户信息

        Request(ProtocolHelper.get_account, null, (result) =>
        {//socket 获取用户信息成功
            //UnityEngine.Debug.Log("CK : ------------------------------ result get account = " + result.ToString() );

            ProtocolHelper.Receive_get_ccount(result);
            if(ProtocolHelper._LoginType == LoginType.Guest && result["userid"].IsAvailable())
            {
                string GuestUID = PlayerPrefs.GetString("GuestUID", "0");
                if (GuestUID.Equals("0"))
                {
                    UnityEngine.Debug.Log("CK : ------------------------------ result[userid].ToString() = " + result["userid"].ToString() + ", result[userid].n = " + result["userid"].n);
                    PlayerPrefs.SetString("GuestUID", result["userid"].n.ToString());
                }
            }

            SaveLoginInfo();
            EginLoadLevel("Hall");
        });
    }

    private void SocketDevice_Verify()
    {
        EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"));

        JSONObject body = new JSONObject();
        body.AddField("username", EginUser.Instance.username);
        body.AddField("verify_code", verifyCode.value);
//#if UNITY_EDITOR
//        body.AddField("device_id", "123456");
//#else
        body.AddField("device_id", "unity_" + EginUser.Instance.device_id);
//#endif

        m_account_login_error_str = null;
        curReconnectCount = 0;

        ProtocolHelper.OnSocketConnectTriggerAction = () =>
        {
            Request("AccountService/device_verify", body, (result) =>
            {
                EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"));
                StartSocket(true);
            });//Process_account_login(null) );
        };
        StartSocket(true);
    }
    #endregion socket相关
    
    private string openId;
    private string access_token;
    private string refresh_token;
    private string unionId;
    private string nickname;
    private int sex;

    private const int WECHAT_STATE = 20160621;

    void OnWechatSendAuthCallback(string message)
    {

        Debug.Log("OnWechatPayCallback : message ------------------------------------ = " + message);

        if (message.StartsWith("0"))
        {
            string[] split = message.Split(',');
            string code = split.Length > 1 ? split[1] : string.Empty;
            if (!string.IsNullOrEmpty(code))
            {
                StartCoroutine(Do_Require_token(code));
            }
        }
    }

    IEnumerator Do_Require_token(string code)
    {
        string wxAppid = PlatformGameDefine.playform.WXAppId;
        string wxAppSecret = PlatformGameDefine.playform.WxAppSecret;
        string get_token_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + wxAppid + "&secret=" + wxAppSecret + "&code=" + code + "&grant_type=authorization_code";
        yield return StartCoroutine(Do_www(get_token_url, (str) => {
            Debug.Log("token str = " + str);

            JSONObject json = new JSONObject(str);
            if (!json["errcode"].IsAvailable() || json["errcode"].n == 0)
            {
                if (json["access_token"].IsAvailable()) access_token = json["access_token"].str;
                if (json["refresh_token"].IsAvailable()) refresh_token = json["refresh_token"].str;
                if (json["openid"].IsAvailable()) openId = json["openid"].str;
                if (json["unionid"].IsAvailable()) unionId = json["unionid"].str;

                StartCoroutine(Do_Require_userInfo());
            }
        }));
    }

    IEnumerator Do_Require_userInfo()
    {
        string userInfo_url = "https://api.weixin.qq.com/sns/userinfo?access_token=" + access_token + "&openid=" + openId;
        yield return StartCoroutine(Do_www(userInfo_url, (str) => {
            Debug.Log("userinfo str = " + str);
            JSONObject json = new JSONObject(str);
            if (json["unionid"].IsAvailable()) unionId = json["unionid"].str;
            if (json["nickname"].IsAvailable()) nickname = json["nickname"].str;
            if (json["sex"].IsAvailable()) sex = System.Convert.ToInt32(json["sex"].n);

            EginUser.Instance.wxOpenId = openId;
            EginUser.Instance.wxNickname = nickname;
            EginUser.Instance.wxSex = sex;

            Debug.Log("unionid = " + unionId + ", openid = " + openId + "nickname = " + nickname);

            if (PlatformGameDefine.playform.IsSocketLobby)
                StartCoroutine(Do_WeiXin_login_socket());
            else StartCoroutine(Do_WeiXin_login());
        }));
    }

    IEnumerator Do_www(string url, System.Action<string> onComplete)
    {
        WWW www = new WWW(url);
        yield return www;
        if (www.error == null)
        {
            if (onComplete != null) onComplete(www.text);
        }
        else
        {
            EginProgressHUD.Instance.ShowPromptHUD(www.error);
        }
    }


    /// <summary>
    /// Dos the wei xin login.
    /// 微信登陆
    ///	url: /account/openid/wechat_oauth/
    ///	params:
    ///	openid
    ///	nickname        呢称
    ///	sex             性别
    ///	is_unity: 1     1手机登陆 默认0,web登陆
    ///	return:
    ///		ok              登陆成功
    ///		wechat_verify   需要微信验证，绑定用户呢称，真实姓名，身份证号
    ///		其他都是出错
    /// </summary>
    /// <returns>The wei xin login.</returns>
    /// <param name="code">Code.</param>
    IEnumerator Do_WeiXin_login()
    {
        EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"), true);
        WWWForm form = new WWWForm();
        form.AddField("openid", openId);
        form.AddField("nickname", WWW.EscapeURL(nickname));
        form.AddField("sex", sex);
        form.AddField("is_unity", 1);
        //		WWW www = HttpConnect.Instance.HttpRequest(ConnectDefine.REGISTER_WEIXIN_URL,form);
        WWW www = HttpConnect.Instance.HttpRequest(ConnectDefine.REGISTER_WEIXIN_URL + "?openid=" + openId + "&nickname=" + WWW.EscapeURL(nickname) + "&sex=" + sex + "&is_unity=1", null);
        Debug.Log("ConnectDefine.REGISTER_WEIXIN_URL = " + www.url);
        yield return www;

        HttpResult result = HttpConnect.Instance.UserLoginResult(www);
        //result.resultObject = "device_verify";

        EginProgressHUD.Instance.HideHUD();
        if (HttpResult.ResultType.Sucess == result.resultType)
        {
            SaveLoginInfo();

            EginLoadLevel("Hall");
        }
        else
        {
            if (result.resultObject.ToString() == "device_verify")
            {
                //SaveLoginInfo();
                verifyView.SetActive(true);
            }
            else
            {
                EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
            }
        }
    }

    //	上行：
    //	{
    //		'tag': 'wechat_oauth',
    //		'type': 'AccountService',
    //		'body':{
    //			'is_unity': 1
    //			'openid': '',
    //			'nickname':'',
    //			'sex':0/1
    //		}
    //	}
    //	下行：
    //	{
    //		"type":AccountService,
    //		"tag": wechat_oauth,
    //		"result":'ok' --成功ok ,失败为说明
    //	}
    IEnumerator Do_WeiXin_login_socket()
    {
        ProtocolHelper._LoginType = LoginType.WeChat;
        EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"), true);
        //		SocketConnectInfo.Instance.lobbyUserName = kUsername.value;//设置登录用的用户名和密码
        //		SocketConnectInfo.Instance.lobbyPassword = kPassword.value;
        curReconnectCount = 0;
        m_account_login_error_str = null;
        yield return StartCoroutine(PlatformGameDefine.playform.LoadConfByUser(kUsername.value));
        EginUser.Instance.wxOpenId = openId;
        EginUser.Instance.wxNickname = nickname;
        EginUser.Instance.wxSex = sex;
        //ProtocolHelper.OnSocketConnectTriggerAction = () => {
        //    Debug.Log("---------------------socket wx login success, nickname = " + nickname);
        //    JSONObject json = new JSONObject();
        //    json.AddField("openid", openId);
        //    json.AddField("nickname", nickname);
        //    json.AddField("sex", sex);
        //    json.AddField("is_unity", 1);
        //    Request("AccountService/wechat_oauth", json, (resultJson) => {
        //        GetUserInfo_socket();
        //    });
        //};
        StartSocket(true);
    }

    public void On_Guest()
    {
        if (PlatformGameDefine.playform.IsSocketLobby)
        {
            StartCoroutine(Do_Guest_login_socket());
        }
    }

    IEnumerator Do_Guest_login_socket()
    {
        ProtocolHelper._LoginType = LoginType.Guest;
        EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectLogin"), true);
        //		SocketConnectInfo.Instance.lobbyUserName = kUsername.value;//设置登录用的用户名和密码
        //		SocketConnectInfo.Instance.lobbyPassword = kPassword.value;
        curReconnectCount = 0;
        m_account_login_error_str = null;
        yield return StartCoroutine(PlatformGameDefine.playform.LoadConfByUser(kUsername.value));
      
        StartSocket(true);
    }
}