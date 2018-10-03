using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class WXPayUtil {

    public static string out_trade_no = string.Empty;

    #region wechatpay
    [DllImport ("__Internal")]
	private static extern float _OnWeChatPay (string jsonMsg);


    public static void OnWeChatPay(JSONObject jsonMsg, string callbackgGameObjectName)
	{
        //      Dictionary<string,string> msg = new Dictionary<string, string>();
        //msg["callbackGameObject"] = callbackgGameObjectName;//this.name;
        //msg["appId"] = PlatformGameDefine.playform.WXAppId;
        //msg["url"] = string.Format(PlatformGameDefine.playform.WXPayURL,EginUser.Instance.username, amount);
        //UnityEngine.Debug.Log("CK : ------------------------------ OnWeChatPay?jsonMsg = " + jsonMsg.ToString());

        //      JSONObject jsonMsg = new JSONObject(msg);
        if (jsonMsg == null) return;
        if (jsonMsg["out_trade_no"].IsAvailable()) out_trade_no = jsonMsg["out_trade_no"].str;

        if (jsonMsg["result_code"].IsAvailable() && jsonMsg["result_code"].str != "SUCCESS") jsonMsg.AddField("retcode",jsonMsg["result_code"]);
        if (jsonMsg["return_msg"].IsAvailable()) jsonMsg.AddField("retmsg",jsonMsg["return_msg"]);
        if (jsonMsg["appid"].IsAvailable()) jsonMsg.AddField("wxappid", jsonMsg["appid"].str);
        jsonMsg.AddField("callbackGameObject", callbackgGameObjectName);

        UnityEngine.Debug.Log("ck debug : -------------------------------- out_trade_no = " + out_trade_no);

        //UnityEngine.Debug.Log("CK : ------------------------------ OnWeChatPay2?jsonMsg = " + jsonMsg.ToString());

#if UNITY_IOS
		_OnWeChatPay(jsonMsg.ToString());
#elif UNITY_ANDROID
        using (AndroidJavaObject jc = new AndroidJavaObject ("net.sourceforge.simcpux.wxapi.WeChatPayUtil")) {
			jc.Call("Pay",jsonMsg.ToString());
		}
#endif
	}

	/// <summary>
	/// callback from android/ios to the callbackGameObject gameobject
	/// the callbackGameObject is required to hold this method
	/// </summary>
	/// <param name="message">Message.</param>
	void OnWechatPayCallback(string message){
		
		Debug.Log ("OnWechatPayCallback : message ------------------------------------ = " + message);
	}
	#endregion

	#region WeChatSendAuth
	[DllImport ("__Internal")]
	private static extern float _OnWeChatSendAuth (string jsonMsg);


	public static void OnWeChatSendAuth(string callbackgGameObjectName)
	{
		JSONObject jsonMsg = new JSONObject (); 
		jsonMsg.AddField("wxappid", PlatformGameDefine.playform.WXAppId);
		jsonMsg.AddField("callbackGameObject", callbackgGameObjectName);

		//UnityEngine.Debug.Log("CK : ------------------------------ OnWeChatSendAuth?jsonMsg = " + jsonMsg.ToString());

		#if UNITY_IOS
		_OnWeChatSendAuth(jsonMsg.ToString());
		#elif UNITY_ANDROID
		using (AndroidJavaObject jc = new AndroidJavaObject ("net.sourceforge.simcpux.wxapi.WeChatPayUtil")) {
		jc.Call("SendAuth",jsonMsg.ToString());
		}
		#endif
	}

	/// <summary>
	/// callback from android/ios to the callbackGameObject gameobject
	/// the callbackGameObject is required to hold this method
	/// </summary>
	/// <param name="message">Message.</param>
	void OnWechatSendAuthCallback(string message){

        Debug.Log("OnWechatPayCallback : message -----WXPayUtil------------------------------- = " + message);
	}
	#endregion

	#region WeChatSendWeb
	[DllImport ("__Internal")]
	private static extern float _OnWeChatSendWeb (string jsonMsg);


	/// <summary>
	/// Raises the we chat send web event.
	/// </summary>
	/// <param name="isTimeline"> true 是 朋友圈(分享)，false 是 会话(邀请).</param>
    public static void OnWeChatSendWeb
	(bool isTimeline, string callbackGameObject,JSONObject _jsonmsg)
	{
		JSONObject jsonMsg = new JSONObject (); 
		//jsonMsg.AddField("wxappid", PlatformGameDefine.playform.WXAppId);
		if (_jsonmsg["wxappid"].IsAvailable()) jsonMsg.AddField("wxappid",_jsonmsg["wxappid"].str); 

		jsonMsg.AddField("callbackGameObject", callbackGameObject); 
		jsonMsg.AddField("isTimeline", isTimeline);
		if (_jsonmsg["title"].IsAvailable()) jsonMsg.AddField("title", _jsonmsg["title"].str); 
		if (_jsonmsg["url"].IsAvailable()) jsonMsg.AddField("url", _jsonmsg["url"].str); 
		if (_jsonmsg["description"].IsAvailable()) jsonMsg.AddField("description",_jsonmsg["description"].str); 

		//jsonMsg.AddField("title", PlatformGameDefine.playform.PlatformName);
		//jsonMsg.AddField("url", PlatformGameDefine.playform.WXShareUrl);
		//jsonMsg.AddField("description", PlatformGameDefine.playform.WXShareDescription);

		string imgPath = Application.persistentDataPath+"/app_icon.png";
//		string imgSrcPath = Application.streamingAssetsPath+"/app_icon.png";

		if (!System.IO.File.Exists (imgPath)) {
			string img_bytes_name = PlatformGameDefine.playform.GetPlatformPrefix () + "_app_icon";
			TextAsset img_png = Resources.Load<TextAsset> (img_bytes_name);
			System.IO.File.WriteAllBytes (imgPath,img_png.bytes);
		}
		ConfigUpdater.SetNoBackupFlag (imgPath);
		jsonMsg.AddField("imgPath", imgPath);

//		jsonMsg.AddField("imgPath", false);

		UnityEngine.Debug.Log("CK : ------------------------------ OnWeChatSendWeb2?jsonMsg = " + jsonMsg.ToString());

		#if UNITY_IOS
		_OnWeChatSendWeb(jsonMsg.ToString());
		#elif UNITY_ANDROID
		using (AndroidJavaObject jc = new AndroidJavaObject ("net.sourceforge.simcpux.wxapi.WeChatPayUtil")) {
		jc.Call("SendWeb",jsonMsg.ToString());
		}
		#endif
	}
	public static void OnWeChatSendWeb(string _msg)
	{ 
		#if UNITY_IOS
		_OnWeChatSendWeb(_msg);
		#elif UNITY_ANDROID
		using (AndroidJavaObject jc = new AndroidJavaObject ("net.sourceforge.simcpux.wxapi.WeChatPayUtil")) {
		jc.Call("SendWeb",_msg);
		}
		#endif
	}
    void OnWechatSendWebCallback(string message)
    { 
        Debug.Log("OnWechatPayCallback : message ------------------------------------ = " + message);
    }
    #endregion


    #region WeChatSendWeb
    [DllImport("__Internal")]
    private static extern float _OnClick_WebActivity(string url);


    /// <summary>
    /// 加载 webview
    /// </summary>
    public static void OnClick_WebActivity(string url)
    {
#if UNITY_IOS
		_OnClick_WebActivity(url);
#elif UNITY_ANDROID
        using (AndroidJavaObject jc = new AndroidJavaObject("net.sourceforge.simcpux.wxapi.WeChatPayUtil"))
        {
            jc.Call("OnClick_WebActivity", url);
        }
#endif
    }
    #endregion


    #region IOSStartRecharge
    //ios充值请求
    [DllImport("__Internal")]
    private static extern float iOSStartRecharge(string uid, string host);

    public static void StartIOSStartRecharge(string uid)
    {
        iOSStartRecharge(uid, ConnectDefine.HostURL);
    }

    #endregion

    #region 调用 android/ios 系统的另一个应用, 没有的时候, 打开下载url
    public static void OpenAndroidApp(string bundleId, string downloadURL)
    {
        bool fail = false;
        //string bundleId = com.google.appname; // your target bundle id
        AndroidJavaClass up = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        AndroidJavaObject ca = up.GetStatic<AndroidJavaObject>("currentActivity");
        AndroidJavaObject packageManager = ca.Call<AndroidJavaObject>("getPackageManager");

        AndroidJavaObject launchIntent = null;
        try
        {
            launchIntent = packageManager.Call<AndroidJavaObject>("getLaunchIntentForPackage", bundleId);
        }
        catch (System.Exception e)
        {
            fail = true;
        }

        if (fail)
        { //open app in store
            Application.OpenURL(downloadURL);
        }
        else //open the app
            ca.Call("startActivity", launchIntent);

        up.Dispose();
        ca.Dispose();
        packageManager.Dispose();
        launchIntent.Dispose();
    }

    [DllImport("__Internal")]
    private static extern float _OpenIOSApp(string urlSchema, string downloadURL);
    public static void OpenIOSApp(string urlSchema, string downloadURL)
    {
        if(_OpenIOSApp(urlSchema, downloadURL) < 1)//如果能打开,那么返回1,如果不能打开, 那么返回0
        {
            Application.OpenURL(downloadURL);
        }
    }
    #endregion 调用 android/ios 系统的另一个应用, 没有的时候, 打开下载url
}

