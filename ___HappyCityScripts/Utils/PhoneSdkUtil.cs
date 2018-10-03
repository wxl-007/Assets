using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System;

public class PhoneSdkUtil
{
    private static string mToolClass = "com.lx.aphone.APhoneTool";
 //android本地通知插件
    private static string mNoticeFullClassName = "net.agasper.unitynotification.UnityNotificationManager";
    private static string mNoticeMainActivityClassName = "com.unity3d.player.UnityPlayerNativeActivity";

    #region android本地通知插件
    public enum NotificationExecuteMode
    {
        Inexact = 0,
        Exact = 1,
        ExactAndAllowWhileIdle = 2
    }

    public static void SendAndroidNotice(int id, int delay, string title, string message)
    {
        Debug.LogError("..............................................." +id+"."+title + "." + delay + "." + title + "." + message);
        SendNotification(id, delay, title, message, Color.white);
    }

    private static void SendNotification(int id, long delay, string title, string message, Color32 bgColor, bool sound = true, bool vibrate = true, bool lights = true, string bigIcon = "", NotificationExecuteMode executeMode = NotificationExecuteMode.Inexact)
    {
#if UNITY_ANDROID && !UNITY_EDITOR
                AndroidJavaClass pluginClass = new AndroidJavaClass(mNoticeFullClassName);
                if (pluginClass != null)
                {
                    Debug.LogError("...............................................send11");
                    pluginClass.CallStatic("SetNotification", id, delay * 1000L, title, message, message, sound ? 1 : 0, vibrate ? 1 : 0, lights ? 1 : 0, bigIcon, "notify_icon_small", bgColor.r * 65536 + bgColor.g * 256 + bgColor.b, (int)executeMode, mNoticeMainActivityClassName);
                }else{
                     Debug.LogError("...............................................send2");
                }
#endif
    }

    private static void SendRepeatingNotification(int id, long delay, long timeout, string title, string message, Color32 bgColor, bool sound = true, bool vibrate = true, bool lights = true, string bigIcon = "")
    {
#if UNITY_ANDROID && !UNITY_EDITOR
            AndroidJavaClass pluginClass = new AndroidJavaClass(mNoticeFullClassName);
            if (pluginClass != null)
            {
                pluginClass.CallStatic("SetRepeatingNotification", id, delay * 1000L, title, message, message, timeout * 1000, sound ? 1 : 0, vibrate ? 1 : 0, lights ? 1 : 0, bigIcon, "notify_icon_small", bgColor.r * 65536 + bgColor.g * 256 + bgColor.b, mNoticeMainActivityClassName);
            }
#endif
    }

    public static void CancelAndroidNotice(int id)
    {
        #if UNITY_ANDROID && !UNITY_EDITOR
                AndroidJavaClass pluginClass = new AndroidJavaClass(mNoticeFullClassName);
                if (pluginClass != null) {
                    pluginClass.CallStatic("CancelNotification", id);
                }
        #endif
    }
    #endregion
    public static void readedIosNoticeNumber(int pNum)
    {
        try
        {
            #if UNITY_ANDROID  
                //callRawSdkApi(mToolClass,"readedNotice",pNum);
             #endif
            #if UNITY_IPHONE
                _readedNotice(pNum);
                Debug.Log("call _readedNotice:" + pNum);
            #endif
        }
        catch (Exception pErr)
        {
            Debug.Log("_readedNotice err:" + pErr.Message);
        }
    }
    /// <summary>
    /// ios本地通知
    /// </summary>
    /// <param name="pContent"></param>
    public static void SendIosNotice(string pContent,int pDelayTime,int pNum)
    {
        try
        {
            #if UNITY_ANDROID  
                //callRawSdkApi(mToolClass,"_initBaiduYuntui","",pContent);
             #endif
            #if UNITY_IPHONE
                _localNotice(pContent,pDelayTime,pNum);
                Debug.Log("call _localNotice:" + pContent);
            #endif
        }
        catch (Exception pErr)
        {
            Debug.Log("localNotice err:" + pErr.Message);
        }
    }
    
    /// <summary>
    /// 启动百度云推送,远程推送
    /// </summary>
    /// <param name="pContent"></param>
    public static void initBaiduYuntui(string pContent,string pGameObjName,int pMode)
    {
        try
        {
#if UNITY_ANDROID
                callRawSdkApi(mToolClass,"initBaiduYuntui",pContent,pGameObjName,pMode);
#endif
#if UNITY_IPHONE
                _initBaiduYuntui(pContent,pGameObjName,pMode);
                Debug.Log("call initBaiduYuntui:" + pContent+"   "+pGameObjName);
#endif
        }
        catch (Exception pErr)
        {
            Debug.Log("initBaiduYuntui err:" + pErr.Message);
        }
        Debug.Log("call initBaiduYuntui:" + pContent + "   " + pGameObjName);
    }
    /// <summary>
    /// 启动乐想推送,远程推送
    /// </summary>
    /// <param name="pContent"></param>
    public static void initLxYuntui(string pGameObjName)
    {
        try
        {
            #if UNITY_ANDROID  
                //callRawSdkApi(mToolClass,"_initBaiduYuntui","",pContent);
            #endif
            #if UNITY_IPHONE
                _initLxYuntui(pGameObjName);
                Debug.Log("call _initLxYuntui:" +pGameObjName);
            #endif
        }
        catch (Exception pErr)
        {
            Debug.Log("_initLxYuntui err:" + pErr.Message);
        }
    }
    /// <summary>
    /// 短信邀请好友
    /// </summary>
    /// <param name="pContent"></param>
    public static void addFriendFromSms(string pContent)
    {
        try
        {
            #if UNITY_ANDROID  
                callRawSdkApi(mToolClass,"addFriendFromSms","",pContent);
            #endif
            #if UNITY_IPHONE
                _addFriendFromSms(pContent);
            #endif
        }
        catch (Exception pErr)
        {
            Debug.Log("addFriendFromSms err:" + pErr.Message);
        }
    }
    public static string getImei()
    {
        try
        {
            #if UNITY_ANDROID
                return callRawSdkApiStr(mToolClass,"getImei");
            #endif
            #if UNITY_IPHONE
                return _getImei();
            #endif
        }
        catch (Exception pErr)
        {
            Debug.Log("getImei err:" + pErr.Message);
        }
        return "pc";
    }
    //----------ios     call--------------------------------------------------------------------
    #if UNITY_IPHONE 
        [DllImport("__Internal")]
        private static extern void _addFriendFromSms(string pContent);   //短信邀请好友
        [DllImport("__Internal")]  //获取imei
        private static extern string _getImei();
        [DllImport("__Internal")]
        private static extern void _initBaiduYuntui(string pContent,string pGameObjName,int pMode);   //配置百度云推送
        [DllImport("__Internal")]
        private static extern void _initLxYuntui(string pGameObjName);   //配置乐想云推送
        [DllImport("__Internal")]
        private static extern void _localNotice(string pContent,int pDelayTime,int pNum);   //配置百度云推送
        [DllImport("__Internal")]
        private static extern void _readedNotice(int pNum);//已读了几条消息
    #endif
    
    //----------android call --------------------------------------------------------------------
    #if UNITY_ANDROID 
        private static void callRawSdkApi(String className, String apiName, params object[] args)
        {
            try
            {
                Debug.Log("callRawSdkApi Unity3D " + apiName + " calling...");
                using (AndroidJavaClass cls = new AndroidJavaClass(className))
                {
                    cls.CallStatic(apiName, args);
                }
            }
            catch (Exception pErr)
            {
                Debug.Log("sdkerr:" + pErr.Message);
            }
        }
        private static String callRawSdkApiStr(string className, string apiName, params object[] args)
        {
            try
            {
                Debug.Log("callSdkApiReturnString Unity3D " + apiName + " calling...");
                using (AndroidJavaClass cls = new AndroidJavaClass(className))
                {

                    string result = cls.CallStatic<string>(apiName, args);
                    return result;

                }
            }
            catch (Exception pErr)
            {
                Debug.Log("sdkerr:" + pErr.Message);
            }
            return "";
        }
        private static int callRawSdkApiInt(String className, String apiName, params object[] args)
        {
            try
            {
                Debug.Log("callSdkApiReturnString Unity3D " + apiName + " calling...");
                using (AndroidJavaClass cls = new AndroidJavaClass(className))
                {

                    int result = cls.CallStatic<int>(apiName, args);
                    return result;

                }
            }
            catch (Exception pErr)
            {
                Debug.Log("sdkerr:" + pErr.Message);
            }
            return 0;
        }
        private static bool callRawSdkApiBool(String className, String apiName, params object[] args)
        {
            try
            {
                Debug.Log("callSdkApiReturnString Unity3D " + apiName + " calling...");
                using (AndroidJavaClass cls = new AndroidJavaClass(className))
                {

                    bool result = cls.CallStatic<bool>(apiName, args);
                    return result;

                }
            }
            catch (Exception pErr)
            {
                Debug.Log("sdkerr:" + pErr.Message);
            }
            return false;
        }
    #endif

	///-------打电话接口------
	#if UNITY_IPHONE 
	[DllImport ("__Internal")]
	private static extern void _callPhone (string pContent);
	#endif
	#if UNITY_IOS
	[DllImport ("__Internal")]
	private static extern float _isIOSApp (string urlshcema);


	[DllImport ("__Internal")]
	private static extern void _openIosAppURL (string pContent);
	#endif
	//打电话
	public static void callPhone(string num)
	{  
		#if UNITY_ANDROID  
			androidToActivity ("ACTION_CALL", "tel:" + num);
		#endif
		#if UNITY_IPHONE 
		_callPhone("tel://"+num); 
		#endif 
	}
	//判断IOS平台中是否有这个程序
	public static bool IsIOSApp(string urlshcema)
	{  
		
		#if UNITY_IOS
		float tempbool = _isIOSApp(urlshcema);
		if(tempbool == 1)
		{
			return true;
		}
		#endif
		return false;

	}
	//打开指定IOS中得应用程序的URL
	public static void OpenIosAppURL(string pContent)
	{   
		#if UNITY_IOS
		_openIosAppURL(pContent);
		#endif

	}
	//打开Android中指定的Activity
	public static string androidToActivity(string actionKey,string url)
	{
		string errMessage = "";
		string globalName;
		AndroidJavaObject Uriobj;
		using (AndroidJavaObject jc1 = new AndroidJavaObject ("android.content.Intent")) {
			globalName = jc1.GetStatic <string>(actionKey);
		} 
		using (AndroidJavaObject jc2 = new AndroidJavaObject ("android.net.Uri")) {
			Uriobj = jc2.CallStatic <AndroidJavaObject>("parse",url);
		}  

		try
		{
			using (AndroidJavaObject jc3 = new AndroidJavaObject ("android.content.Intent", globalName, Uriobj)) {

				using (AndroidJavaClass jc4 = new AndroidJavaClass ("com.unity3d.player.UnityPlayer")) { 
					AndroidJavaObject currentActivity = jc4.GetStatic <AndroidJavaObject>("currentActivity"); 

					currentActivity.Call ("startActivity", jc3); 
				} 
			} 
		}
		catch (System.Exception e)
		{
			errMessage = e.Message; 
		}

		return errMessage;
	}
}
