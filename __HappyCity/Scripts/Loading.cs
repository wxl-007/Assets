using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;


public delegate bool BoolAction();
public class Loading : BaseScene {
    public System.Action _OnDestroyAction;
    public System.Action _InstantUpdateAction;
    public BoolAction _IsInstantUpdateCompleted;

	public enum LodaingStage {
		CheckVersion, 
		LoadInfo,
		DoLogin,
		Download,
		GoLogin,
		GoHall
	}
	
	public UILabel kLabel;
	
	public GameObject vVersion;
	public UILabel kVersionContent;
	public GameObject kVersionCancel;
	
	private int mVersionCode;
	private int mNewVersionCode;
	private string mVersionUpdateUrl;
    private bool mCanCancel;
    //时间网站数组
    private string[] mTimeUrl = { "http://time.tianqi.com/beijing/","http://www.timedate.cn/worldclock/ti.asp"  };
	// Use this for initialization
	void Start () {
        StartCoroutine(StartLoading());
    }

    protected void OnDestroy()
    {
        //EndSocket(true);
        if (_OnDestroyAction != null) _OnDestroyAction();
    }

    //  public void Init()
    //  {
    //StartCoroutine(StartLoading());
    //  }

    private int m_CurTimeOutCount = 0;
    IEnumerator StartLoading () {

        if(!PlatformGameDefine.playform.IsSocketLobby)
            yield return StartCoroutine(DoCheckBaiduTime());
        else EginTools.localBeiJingTime = 0;
        UnityEngine.Debug.Log("CK : ------------------------------ loading = " + 0 );

        yield return StartCoroutine(PlatformGameDefine.playform.LoadLocalConfig());
        PlatformGameDefine.playform.Start_LoadAndSaveConfigData();

        UnityEngine.Debug.Log("CK : ------------------------------ loading = " + 1);

        if (!PlatformGameDefine.playform.IsSocketLobby)
        {
            string gfname = PlayerPrefs.GetString("GFname" + PlatformGameDefine.playform.PlatformName);
            string wfname = PlayerPrefs.GetString("WFname" + PlatformGameDefine.playform.PlatformName);
            PlatformGameDefine.playform.UpdateGFnameURL(gfname);
            PlatformGameDefine.playform.UpdateWFnameURL(wfname);

            UnityEngine.Debug.Log("CK : ------------------------------ loading = " + 2);

            yield return StartCoroutine(PlatformGameDefine.playform.LoadConfig_game_hostArr());
            yield return StartCoroutine(PlatformGameDefine.playform.LoadConfig_web_hostArr());
        }

        UnityEngine.Debug.Log("CK : ------------------------------ loading = " + 3 );
#if UNITY_ANDROID || (UNITY_IPHONE && _IsEnterprise) || UNITY_STANDALONE_OSX
        StartCoroutine(DoChekcVersion());
#else
        StartCoroutine(DoLoading());
#endif

        Utils.StartInstantDownload();//启动热更新资源下载
    }

    private IEnumerator DoCheckBaiduTime()
    {
        if (m_CurTimeOutCount >= mTimeUrl.Length*2)//超时重连只进行1次
        {
            EginTools.localBeiJingTime = 0;
            yield break;
        }



        using (WWW www = HttpConnect.Instance.HttpRequestAli(mTimeUrl[m_CurTimeOutCount/2]))
        {
            bool isTimeOut = false;
            yield return StartCoroutine(CheckTimeOut(www, () => isTimeOut = true));
            if (isTimeOut)
            {
                m_CurTimeOutCount++;
                StartCoroutine(DoCheckBaiduTime());
                yield break;
            }

            yield return www;
            Debug.Log("加载网络时间");
            if (www.error != null)
            {
                EginTools.Log("加载网络时间出错: " + www.error);
                EginTools.localBeiJingTime = 0;
            }
            else
            {
                string tempResultStr = www.text.Trim();
                Debug.Log("网络时间数据打印====>" + tempResultStr);

                long time = 0;
                //第一个和第二个时间网站的数据处理
                if (m_CurTimeOutCount / 2 == 0 || m_CurTimeOutCount / 2 == 1)
                { 
                    try
                    { 
                        int firstIndex = tempResultStr.IndexOf("new Date().getTime();", 0);
                        int secondIndex = tempResultStr.IndexOf("s=document.URL", firstIndex);

                        string childStr = tempResultStr.Substring(firstIndex + 21, secondIndex - firstIndex - 21);

                        //Debug.Log("截取的数据====>" + childStr);
                        //  nyear=2016;nmonth=5;nday=12;nwday=4;nhrs=16;nmin=0;nsec=47;
                        int firstTinmeIndex = 0;
                        int secondTinmeIndex = 0;
                        firstTinmeIndex = childStr.IndexOf("nyear=", firstTinmeIndex);
                        secondTinmeIndex = childStr.IndexOf(";", firstTinmeIndex);
                        int year = int.Parse(childStr.Substring(firstTinmeIndex + 6, secondTinmeIndex - firstTinmeIndex - 6));

                        firstTinmeIndex = childStr.IndexOf("nmonth=", firstTinmeIndex);
                        secondTinmeIndex = childStr.IndexOf(";", firstTinmeIndex);
                        int month = int.Parse(childStr.Substring(firstTinmeIndex + 7, secondTinmeIndex - firstTinmeIndex - 7));

                        firstTinmeIndex = childStr.IndexOf("nday=", firstTinmeIndex);
                        secondTinmeIndex = childStr.IndexOf(";", firstTinmeIndex);
                        int day = int.Parse(childStr.Substring(firstTinmeIndex + 5, secondTinmeIndex - firstTinmeIndex - 5));

                        firstTinmeIndex = childStr.IndexOf("nhrs=", firstTinmeIndex);
                        secondTinmeIndex = childStr.IndexOf(";", firstTinmeIndex);
                        int hour = int.Parse(childStr.Substring(firstTinmeIndex + 5, secondTinmeIndex - firstTinmeIndex - 5));

                        firstTinmeIndex = childStr.IndexOf("nmin=", firstTinmeIndex);
                        secondTinmeIndex = childStr.IndexOf(";", firstTinmeIndex);
                        int minute = int.Parse(childStr.Substring(firstTinmeIndex + 5, secondTinmeIndex - firstTinmeIndex - 5));

                        firstTinmeIndex = childStr.IndexOf("nsec=", firstTinmeIndex);
                        secondTinmeIndex = childStr.IndexOf(";", firstTinmeIndex);
                        int second = int.Parse(childStr.Substring(firstTinmeIndex + 5, secondTinmeIndex - firstTinmeIndex - 5));

                        Debug.Log(year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second);
                        DateTime tempTime = new DateTime(year, month, day, hour, minute, second);
                        System.DateTime d1 = new System.DateTime(1970, 1, 1);
                        System.TimeSpan ts = new System.TimeSpan(tempTime.ToUniversalTime().Ticks - d1.Ticks);
                        time = (long)ts.TotalMilliseconds; 

                    }
                    catch
                    {
                        Debug.Log("错误====" + m_CurTimeOutCount);
                        m_CurTimeOutCount++;
                        StartCoroutine(DoCheckBaiduTime());
                        yield break;
                    } 
                } 
                long ms = EginTools.nowMinis(); //返回 1970 年 1 月 1 日至今的毫秒数 
                EginTools.localBeiJingTime = time - ms;
                 
                Debug.Log(time + "EginTools.localBeiJingTime====>" + EginTools.localBeiJingTime); 
            }
        }
    }

    public static IEnumerator CheckTimeOut(WWW www, System.Action onTimeOutAction, float TimeOut = 20f)
    {
        float curTime = 0;
        while (!www.isDone)
        {
            curTime += Time.deltaTime;
            if (curTime > TimeOut)
            {
                if (onTimeOutAction != null) onTimeOutAction();
                yield break;
            }

            yield return 0;
        }
    }

    //private int m_CurReconnectCount;
    /* ------ Button Click ------ */
    IEnumerator DoChekcVersion () {
		UpdateSlider(LodaingStage.CheckVersion);
        mVersionCode = Mathf.Max(PlayerPrefs.GetInt("VersionCode", PlatformGameDefine.game.VersionCode), PlatformGameDefine.game.VersionCode);
        if(PlatformGameDefine.playform.VersionCode > 0 && mVersionCode >= PlatformGameDefine.playform.VersionCode)//不用更新, 这样做可以减少一次网络访问
        {
            StartCoroutine(DoLoading());
            yield break;
        }
        UnityEngine.Debug.Log("CK : ----------------------DoChekcVersion-------- name = " + 0 );

        CoroutineResult coroutineResult = new CoroutineResult();
        //string test_version_url = "http://oss.aliyuncs.com/bak998899/test/version_All.txt";
        yield return coroutineResult.WWWReConnect(PlatformGameDefine.game.ChekcVersionURL());//test_version_url);// 
        UnityEngine.Debug.Log("CK : ----------------------DoChekcVersion-------- coroutineResult.error = " + coroutineResult.error);
        if (coroutineResult.error != null)
        {
            StartCoroutine(DoLoading());
            yield break;
        }

        WWW www = coroutineResult._wwwResult; //HttpConnect.Instance.HttpRequestAli(PlatformGameDefine.game.ChekcVersionURL());
        if(Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ www URL = " + www.url + ", txt = " + www.text); 

        //yield return www;
        HttpResult result = HttpConnect.Instance.BaseResult (www);
 		if (HttpResult.ResultType.Sucess == result.resultType) {

			//JSONObject versionObj = (JSONObject)(result.resultObject);
			//mVersionCode = Mathf.Max (PlayerPrefs.GetInt ("VersionCode", PlatformGameDefine.game.VersionCode), PlatformGameDefine.game.VersionCode);
			//mNewVersionCode = int.Parse (versionObj["version_code"].str);
            JSONObject versionObj = (JSONObject)(result.resultObject);
            mNewVersionCode = 0;
            if (versionObj.IsAvailable() && versionObj["version_code"].IsAvailable() && !string.IsNullOrEmpty(versionObj["version_code"].str))
            {
                if (int.TryParse(versionObj["version_code"].str, out mNewVersionCode)) { }
                else mNewVersionCode = 0;
            }
            //Debug.Log("======1212======"+mNewVersionCode);
            UnityEngine.Debug.Log("CK : ------------------------------ mNewVersionCode = " + mNewVersionCode + ", mVersionCode = " + mVersionCode);

            if (mNewVersionCode > mVersionCode) {
				ShowUpdateView (versionObj);
			} else {
                if (System.IO.Directory.Exists(Constants.VersionUpdatePath))//不需要更新大版本,确保大版本文件(更新下载的)已删除
                    System.IO.Directory.Delete(Constants.VersionUpdatePath,true);

                StartCoroutine (DoLoading ());
			}
		} else {
            StartCoroutine (DoLoading ());
		}
	}
	
	void OnClickVersionCancel () {
		vVersion.SetActive(false);
		//PlayerPrefs.SetInt("VersionCode", mNewVersionCode);
		//PlayerPrefs.Save();
		StartCoroutine(DoLoading());
	}
	
	void OnClickVersionUpdate () {
		Application.OpenURL(mVersionUpdateUrl);
        if (mCanCancel)
        {
            vVersion.SetActive(false);
            StartCoroutine(DoLoading());
        }
    }
	
	IEnumerator DoLoading () {
        //UnityEngine.Debug.Log("CK : ------------------------------ ckeckversion = " + 0 );
        if (_InstantUpdateAction != null) _InstantUpdateAction();
        //UnityEngine.Debug.Log("CK : ------------------------------ ckeckversion = " + 1 );
        if (_IsInstantUpdateCompleted != null)
        {
            while (!_IsInstantUpdateCompleted()) yield return new WaitForEndOfFrame();
        }

        //UnityEngine.Debug.Log("CK : ------------------------------ ckeckversion = " + 2 );
        UpdateSlider(LodaingStage.LoadInfo);
        bool isRemberPs = (PlayerPrefs.GetInt("RemberPS", 0) == 1);
		bool isAutoLogin = (PlayerPrefs.GetInt("AutoLogin2", 0) == 1);
  
		if(isRemberPs && isAutoLogin) {
			string username = PlayerPrefs.GetString("EginUsername", "");
			string password = PlayerPrefs.GetString(username, "");
            

            if (username.Length > 0 && password.Length > 0) {
				UpdateSlider(LodaingStage.DoLogin);

                if (PlatformGameDefine.playform.IsSocketLobby)
                {
                    //加载用户对应的ip
                    yield return StartCoroutine(PlatformGameDefine.playform.LoadConfByUser(username));

                    //ProtocolHelper.Send_get_account();//后面的处理在SocketReceiveMessage中处理
                    SocketConnectInfo.Instance.lobbyUserName = username;
                    SocketConnectInfo.Instance.lobbyPassword = password;
                    Debug.Log("=======================setttttttt   loading     ==================    " + SocketConnectInfo.Instance.lobbyPassword);
                    StartSocket(true);
                    StartCoroutine(ForceLoadLogin());
                }
                else
                {
                    WWWForm form = new WWWForm();
                    form.AddField("username", username);
                    form.AddField("password", password);
                    form.AddField("device_id", "unity_" + SystemInfo.deviceUniqueIdentifier);
#if UNITY_ANDROID
				mVersionCode = Mathf.Max (PlayerPrefs.GetInt ("VersionCode", PlatformGameDefine.game.VersionCode), PlatformGameDefine.game.VersionCode);
				//Debug.Log("======00000======"+mVersionCode);
				form.AddField("platform", "Android");
				form.AddField("version", mVersionCode);
#else
                    form.AddField("platform", "iOS");
#endif


                    WWW www = HttpConnect.Instance.HttpRequest(ConnectDefine.LOGIN_URL, form); //UnityEngine.Debug.Log("CK : ------------------------------ ConnectDefine.LOGIN_URL = " + ConnectDefine.LOGIN_URL);
                    yield return www;

                    HttpResult result = HttpConnect.Instance.UserLoginResult(www);

                    if (HttpResult.ResultType.Sucess == result.resultType)
                    {
                        UpdateSlider(LodaingStage.GoHall);
                    }
                    else
                    {
                        UpdateSlider(LodaingStage.GoLogin);
                    }
                }
			}else {
				UpdateSlider(LodaingStage.GoLogin);
			}
		}else {
			UpdateSlider(LodaingStage.GoLogin);
		}
	}

    private bool m_IsGoLogin = false;
	/* ------ Other ------ */
	private void UpdateSlider (LodaingStage stage) {
		switch (stage) {
		case LodaingStage.CheckVersion:
			kLabel.text = "V" + Utils.version + " " + ZPLocalization.Instance.Get("LoadingCheckVersion");
			break;
		case LodaingStage.LoadInfo:
			kLabel.text = ZPLocalization.Instance.Get("LoadingLoadInfo");
			break;
		case LodaingStage.DoLogin:
			kLabel.text = ZPLocalization.Instance.Get("LoadingDoLogin");
			break;
		case LodaingStage.GoLogin:
			kLabel.text = "";
                if(m_IsGoLogin == false)
                {
                    m_IsGoLogin = true;
			        EginLoadLevel("Login");
                }
			break;
		case LodaingStage.GoHall:
			kLabel.text = "";
			EginLoadLevel("Hall");
                break;
		}
	}
	
	private void ShowUpdateView (JSONObject versionObj) {
		mVersionUpdateUrl = versionObj["url"].str;
		kVersionContent.text = versionObj ["update"].str;

		int deprecatedCode = int.Parse(versionObj ["deprecated_code"].str);
        mCanCancel = (mVersionCode > deprecatedCode);
		kVersionCancel.SetActive(mCanCancel);

#if UNITY_ANDROID
        //if (mCanCancel)
        //{
            string fileName = System.IO.Path.GetFileName(mVersionUpdateUrl);
            string fileNameWithOutExtention = System.IO.Path.GetFileNameWithoutExtension(mVersionUpdateUrl);
            fileName = fileName.Replace(fileNameWithOutExtention,mNewVersionCode+"");
            Utils.StartVersionUpdate(mVersionUpdateUrl,fileName);
            StartCoroutine(DoLoading());
            return;
        //}
#else
        vVersion.SetActive(true);
#endif

	}



    #region socket相关
    public override void SocketDisconnect(string disconnectInfo)
    {//loading界面中连接不上socket,就等于登录失败
        UpdateSlider(LodaingStage.GoLogin);//socket登入失败,进入登入界面
    }
    /// <summary>
    /// 断开连接
    /// </summary>
    /// <param name="disconnectInfo"></param>
    public override void OnSocketDisconnect(string disconnectInfo)
    {//loading界面中连接不上socket,就等于登录失败
        UpdateSlider(LodaingStage.GoLogin);//socket登入失败,进入登入界面
    }

    /// <summary>
    /// 登录失败
    /// </summary>
    /// <param name="errorInfo"></param>
    public override void Process_account_login_Failed(string errorInfo, string body)
    {
        UpdateSlider(LodaingStage.GoLogin);//socket登入失败,进入登入界面
    }

    /// <summary>
    /// 登录成功
    /// </summary>
    /// <param name="info"></param>
    public override void Process_account_login(string info)
    {//登入成功,也代表重连成功, 因为重连后就会进行登入操作
        ProtocolHelper.Send_get_account();
        Request(ProtocolHelper.get_account,null,(result,error)=> {//socket 获取用户信息成功
            if(error != null)
            {
                UpdateSlider(LodaingStage.GoLogin);//socket登入成功,获取用户信息失败,进入登入界面
            }else{
                ProtocolHelper.Receive_get_ccount(result);

                UpdateSlider(LodaingStage.GoHall);//socket登入成功,进入大厅
            }
        });
    }

    IEnumerator ForceLoadLogin()
    {
        yield return new WaitForSeconds(15);
        EndSocket(true);
        UpdateSlider(LodaingStage.GoLogin);
    }
    #endregion socket相关
}
