using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SimpleFramework;
using System.Text.RegularExpressions;
using LuaInterface;


public class BaseSceneLua : LuaBehaviour, SocketListener
{

    //private Dictionary<string, System.Action<JSONObject>> m_SocketRequestMap = new Dictionary<string, System.Action<JSONObject>>();
    //private Dictionary<string, System.Action<string>> m_SocketRequest_StrResult_Map = new Dictionary<string, System.Action<string>>();
    private Dictionary<string, LuaFunction> m_SocketRequest_Lua_Map = new Dictionary<string, LuaFunction>();

    //private Dictionary<string, System.Action<string>> m_SocketRequestErrorMap = new Dictionary<string, System.Action<string>>();
    private Dictionary<string, LuaFunction> m_SocketRequestError_Lua_Map = new Dictionary<string, LuaFunction>();
    private Dictionary<string, string> m_SocketReSendMap = new Dictionary<string, string>();//通过request发送的需要接受请求的消息中,如果没有成功处理消息,那么在socket重连后会重新发送//需要发送且需要接收的协议才有效

    private const int ReconnectTimeOut = 25;//重连(登录不成功) timeout 时间
    private int m_curReconnectCount = 0;//当前重连次数
    private Coroutine m_ReconnectCoroutine;

    //用于lua中覆盖c#方法
    [HideInInspector]
    public bool _IsOverride_SocketReceiveMessage = false;//是否在lua中覆盖该方法,如果覆盖,那么c#中该方法的代码将不执行
    //public bool _IsOverride_SocketDisconnect = false;
    [HideInInspector]
    public bool _IsOverride_OnSocketDisconnect = false;
    [HideInInspector]
    public bool _IsOverride_Process_account_login = false;
    [HideInInspector]
    public bool _IsOverride_Process_account_login_Failed = false;
    [HideInInspector]
    public bool _IsOverride_OnSocketManagerTimeOut = false;
    [HideInInspector]
    public bool _IsLoginScene = false;

    private string m_account_login_error_str;

    public static SocketManager socketManager
    {
        get
        {
            return SocketManager.LobbyInstance;
        }
    }

    // Use this for initialization
    public void Awake()
    { 
        base.Awake();
        EginProgressHUD.Instance.HideHUD();

        UIRoot sceneRoot = GameObject.FindObjectOfType(typeof(UIRoot)) as UIRoot;
        if (sceneRoot != null)
        {

            int manualHeight = 1280;        // Android

            if (Utils.HallName == "__HappyCity")
            {
                manualHeight = 1280;
            }
            else
            {
                manualHeight = 1080;
            }

#if UNITY_IPHONE
			if((iPhone.generation.ToString()).IndexOf("iPad") > -1){	// iPad
				manualHeight = 1536;	
			}else if (Screen.width <= 960) {	// <= iPhone4s
				manualHeight = 1400;
			}
#endif

            //sceneRoot.scalingStyle = UIRoot.Scaling.FixedSize;
            sceneRoot.manualHeight = manualHeight;
        }
    }

    protected void OnDestroy()
    {
        base.OnDestroy();
        EndSocket(false);
    }

    public void EginLoadLevel(string levelName)
    {
        if (levelName != "Hall")
        {
            EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("ScreenLoading"));
        }
        Utils.LoadLevelGUI(levelName);
    }
    void OnWechatPayCallback(string message)
    {
        //Debug.Log("OnWechatPayCallback : message ------------------------------------ = " + message);
        CallMethod("OnWechatPayCallback", message);
    }
	void OnAliPayCallback(string message)
	{
		Debug.Log("jun : ~~~~~~~~------ = " + message);
		CallMethod("OnAliPayCallback", message);
	}
    public void OnWechatSendWebCallback(string message)
    { 
        CallMethod("OnWechatSendWebCallback", message);
    }
    #region socket相关
    #region 启动关闭socket连接
    public void StartSocket(bool force = false)//, float delay = 0)
    {
        StartCoroutine(DoStartSocket(force));
    }

    IEnumerator DoStartSocket(bool force, float delay = 0)
    {
        if (delay > 0) yield return new WaitForSeconds(delay);
        SocketConnectInfo connectInfo = SocketConnectInfo.Instance;
        //connectInfo.roomId = string.Empty;//把房间号置为空后就不会进行游戏登入了

        //SocketManager socketManager = SocketManager.Instance;
        yield return socketManager;
        if (socketManager)
        {
            socketManager.socketListener = this;
            if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ <color=green>PlatformGameDefine.playform.SocketLobbyUrl = " + PlatformGameDefine.playform.SocketLobbyUrl + "</color>");
            socketManager.Connect(connectInfo, PlatformGameDefine.playform.SocketLobbyUrl, force);
        }
    }

    public void EndSocket(bool disconnect = false)
    {
        if (socketManager)
        {
            if (socketManager.socketListener == this) socketManager.socketListener = null;
            if (disconnect) socketManager.Disconnect("Exit Scene " + name);
        }
    }
    #endregion 启动关闭socket连接

    #region 发送socket消息
	//发送内容,发送优先级和相同请求的间隔时间
	public void SocketSendMessage(string message,int level,float time)
	{ 
		socketManager.SendPackage(message,level,time);
	}
	//发送内容和发送优先级
	public void SocketSendMessage(string message,int level)
	{

		socketManager.SendPackage(message,level);
	}
    public void SocketSendMessage(string message)
    {
        //UnityEngine.Debug.Log("CK : ------------------------------ SocketSendMessage = " + message);

        socketManager.SendPackage(message);
    }

    public static void SocketSendMessage(JSONObject loginJson)
    {
        socketManager.SendPackageWithJson(loginJson);
    }
    #endregion 发送socket消息

    #region SocketListener回调方法
    public virtual void SocketReceiveMessage(string message)
    {
        if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ SocketReceiveMessage = " + message); 
        if (!_IsOverride_SocketReceiveMessage)
        {
            // Socket message
            #region socket消息基本处理
            JSONObject messageObj = new JSONObject(message);
            if (messageObj["type"] == null) return;
            string type = messageObj["type"].str;
            string tag = messageObj["tag"].str;

            if ("AccountService".Equals(type))
            {
                if ("account_login".Equals(tag) || "wechat_oauth".Equals(tag) || "guest_login".Equals(tag))
                {
                    if (messageObj["result"].IsAvailable() && !"ok".Equals(messageObj["result"].str))//先确认消息没有错误
                    {
                        Process_account_login_Failed(messageObj["result"].ToString(), messageObj["body"].ToString());
                    }
                    else
                    {
                        Process_account_login(messageObj["body"].ToString());
                    }
                }
                else if ("get_account".Equals(tag) && EginUserUpdate.Instance.updateLoopHasStart)
                {
                    //				Debug.Log("<color=#00ff00>lua update info->"+ message +"</color>");
                    EginUser.Instance.UpdateUserWithDict(messageObj["body"].ToDictionary());
                }
            }
            #endregion socket消息基本处理

            OnReceive(messageObj);
        }

        CallMethod("SocketReceiveMessage", message);
    }


    #region socket断开连接
    public virtual void SocketDisconnect(string disconnectInfo)
    {
        CallMethod("SocketDisconnect", disconnectInfo);
    }


    public virtual void OnSocketDisconnect(string disconnectInfo)
    {
        UnityEngine.Debug.Log("CK : ------------------------------ m_curReconnectCount = " + m_curReconnectCount);

        //if (!_IsOverride_OnSocketDisconnect)
        //{
        //    if (gameObject == null) return;

        //    //判断是否是登录界面,登录失败的情况,登录失败网络正常,不需要重连
        //    if (_IsLoginScene && m_account_login_error_str != null)
        //    {
        //        m_account_login_error_str = null;
        //        return;
        //    }

        //    //if (disconnectInfo.Contains(SocketManager.UNITY_HOST_EXCEPTION))
        //    //{//socket 连接时,如果 发生异常,就直接切换下一个ip
        //    //    PlatformGameDefine.playform.swithSocketLobbyHostUrl(() =>
        //    //    {
        //    //        m_curReconnectCount = 0;
        //    //        if (this && !_IsLoginScene) StartSocket(true);//登录界面重连超过限制后不再重连//非登录界面则重连
        //    //    });

        //    //    return;
        //    //}

        //    //非登录界面进行重连超时判断
        //    if (m_ReconnectCoroutine == null && this) m_ReconnectCoroutine = StartCoroutine(CheckReconnectTimeOut());//启动超时判断

        //    socketManager.socketListener = null;

        //    //重连次数判断
        //    if (this) m_curReconnectCount++;
        //    if (m_curReconnectCount < 3)
        //    {
        //        if (this) StartSocket(true);
        //    }
        //    else
        //    {
        //        if (_IsLoginScene)
        //        {
        //            m_curReconnectCount = 0;
        //            EginProgressHUD.Instance.ShowPromptHUD(disconnectInfo);//登录界面重连超过限制后提示错误信息
        //        }

        //        PlatformGameDefine.playform.swithSocketLobbyHostUrl(() =>
        //        {
        //            m_curReconnectCount = 0;
        //            if (this && !_IsLoginScene) StartSocket(true);//登录界面重连超过限制后不再重连//非登录界面则重连
        //        });
        //    }
        //}

        CallMethod("OnSocketDisconnect", disconnectInfo);
    }

    public virtual void OnSocketManagerDisconnect(string errMsg)
    {

    }

    public virtual void OnSocketManagerTimeOut(string errMsg)
    {
        if (!_IsOverride_OnSocketManagerTimeOut)
        {
            OnTimeOut();
        }

        CallMethod("OnSocketDisconnect", errMsg);//返回, 角标0: 是否覆盖
    }
    #endregion socket断开连接
    #endregion SocketListener回调方法

    IEnumerator CheckReconnectTimeOut()
    {
        yield return new WaitForSeconds(ReconnectTimeOut);
        OnTimeOut();
    }

    public void OnTimeOut()
    {
        if (_IsLoginScene)
        {
            EndSocket(true);
            EginProgressHUD.Instance.ShowPromptHUD("连接超时,请稍后再试");//连接超时(一直重连不上), 就重新回到登入界面,避免一直连接不上的bug
        }
        else EginProgressHUD.Instance.ShowPromptHUD("连接超时,请稍后再试", () => EginLoadLevel("Login"));//连接超时(一直重连不上), 就重新回到登入界面,避免一直连接不上的bug
    }

    /* ------ Socket Process ------ */
    #region 大厅登入相关
    public virtual void Process_account_login_Failed(string errorInfo, string body)
    {
        if (!_IsOverride_Process_account_login_Failed)
        {
            if (_IsLoginScene)
            {
                m_account_login_error_str = errorInfo;
                socketManager.Disconnect(errorInfo);
            }
            SocketDisconnect(errorInfo);//登入界面重新该方法,并需要对重连进行限定,避免死循环//登入成功后就可以对重连了
        }

        CallMethod("Process_account_login_Failed", errorInfo);
    }

    public virtual void Process_account_login(string info)
    {//登入成功,也代表重连成功, 因为重连后就会进行登入操作

        if (!_IsOverride_Process_account_login)
        {
            if (m_ReconnectCoroutine != null)
            {//登录成功,关闭超时判断
                this.StopCoroutine(m_ReconnectCoroutine);
                m_ReconnectCoroutine = null;
            }

            if (!_IsLoginScene)
                foreach (var item in m_SocketReSendMap)
                {
                    ProtocolHelper.Send(item.Key, new JSONObject(item.Value));
                    //UnityEngine.Debug.Log("CK : ------------------------------ item.Key = " + item.Key + ", item.Value =  " +  item.Value);
                }
        }

        CallMethod("Process_account_login", info);
    }
    #endregion 大厅登入相关


    #region 对socket请求和监听消息的结构处理
    /// <summary>
    /// 对 SocketReceiveMessage 监听的封装
    /// </summary>
    /// <param name="messageObj"></param>
    private void OnReceive(JSONObject messageObj)
    {
        if (!messageObj.IsAvailable() || !messageObj["result"].IsAvailable()) return;

        string path = messageObj["type"].str + "/" + messageObj["tag"].str;
        string result = messageObj["result"].str;

        if (m_SocketReSendMap.ContainsKey(path)) m_SocketReSendMap.Remove(path);//已经处理的消息,从这里移除

        if ("ok".Equals(result))
        {
            //if (m_SocketRequestMap.ContainsKey(path) && m_SocketRequestMap[path] != null)
            //    m_SocketRequestMap[path](messageObj["body"]);

            //if (m_SocketRequest_StrResult_Map.ContainsKey(path) && m_SocketRequest_StrResult_Map[path] != null)
            //    m_SocketRequest_StrResult_Map[path](messageObj["body"].ToString());

            if (m_SocketRequest_Lua_Map.ContainsKey(path) && m_SocketRequest_Lua_Map[path] != null)
                m_SocketRequest_Lua_Map[path].Call(messageObj["body"].ToString());
        }
        else
        {
            //if (m_SocketRequestErrorMap.ContainsKey(path) && m_SocketRequestErrorMap[path] != null)
            //    m_SocketRequestErrorMap[path](result);

            if (m_SocketRequestError_Lua_Map.ContainsKey(path) && m_SocketRequestError_Lua_Map[path] != null)
                m_SocketRequestError_Lua_Map[path].Call(result);
        }
    }

    public void Receive_lua_fun(string path, LuaInterface.LuaFunction onReceiveAction, LuaInterface.LuaFunction onErrorAction)
    {
        if (onReceiveAction != null) m_SocketRequest_Lua_Map[path] = onReceiveAction;
        if (onErrorAction != null) m_SocketRequestError_Lua_Map[path] = onErrorAction;
    }

    /// <summary>
    /// 请求socket接口,直接处理string格式数据, onReceiveAction 直接处理body内容
    /// 主要考虑lua中的使用string 比较方便
    /// </summary>
    /// <param name="path"></param>
    /// <param name="bodyJsonStr">如果body为空,那么该项填空字符串, 如果该项为null,那么只会进行Receive操作</param>
    /// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    /// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    public void Request_lua_fun(string path, string bodyJsonStr, LuaInterface.LuaFunction onReceiveAction, LuaFunction onErrorAction)
    { 
        if (bodyJsonStr != null) ProtocolHelper.Send(path, new JSONObject(bodyJsonStr));
        Receive_lua_fun(path, onReceiveAction, onErrorAction);

        if (bodyJsonStr != null && (onReceiveAction != null || onErrorAction != null)) m_SocketReSendMap[path] = bodyJsonStr;
    }

    #region 已弃用
    /// <summary>
    /// 监听 SocketReceiveMessage 的消息
    /// </summary>
    /// <param name="path"></param>
    /// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    /// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    //public void Receive(string path, System.Action<JSONObject> onReceiveAction, System.Action<string> onErrorAction)
    //{
    //    if (onReceiveAction != null) m_SocketRequestMap[path] = onReceiveAction;
    //    if (onErrorAction != null) m_SocketRequestErrorMap[path] = onErrorAction;
    //}

    #region 已弃用,使用Receive_lua_fun替换
    /// <summary>
    /// 监听 SocketReceiveMessage 的消息
    /// 主要考虑lua中使用
    /// </summary>
    /// <param name="path"></param>
    /// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    /// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    //public void Receive_lua(string path, System.Action<string> onReceiveAction, System.Action<string> onErrorAction)
    //{
    //    if (onReceiveAction != null) m_SocketRequest_StrResult_Map[path] = onReceiveAction;
    //    if (onErrorAction != null) m_SocketRequestErrorMap[path] = onErrorAction;
    //}
    #endregion 已弃用,使用Receive_lua_fun替换



    /// <summary>
    /// 请求socket接口,处理 JSONObject 数据, onReceiveAction 直接处理body内容
    /// </summary>
    /// <param name="path"></param>
    /// <param name="body">如果body为空,那么该项填空字符串, 如果该项为null,那么只会进行Receive操作</param>
    /// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    /// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    //public void Request(string path, JSONObject body, System.Action<JSONObject> onReceiveAction, System.Action<string> onErrorAction)
    //{
    //    if (body != null) ProtocolHelper.Send(path, body);
    //    Receive(path, onReceiveAction, onErrorAction);

    //    if(body != null && (onReceiveAction != null || onErrorAction != null)) m_SocketReSendMap[path] = body.ToString();
    //}

    #region 已弃用,lua的delegate在这里回调时存在问题,目前使用Request_lua_fun替换
    /// <summary>
    /// 请求socket接口,直接处理string格式数据, onReceiveAction 直接处理body内容
    /// 主要考虑lua中的使用string 比较方便
    /// </summary>
    /// <param name="path"></param>
    /// <param name="bodyJsonStr">如果body为空,那么该项填空字符串, 如果该项为null,那么只会进行Receive操作</param>
    /// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    /// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    //public void Request_lua(string path, string bodyJsonStr, System.Action<string> onReceiveAction, System.Action<string> onErrorAction)
    //{
    //    //UnityEngine.Debug.Log("CK : ------------------------------ path = " + path + ", bodyJsonStr =  " + bodyJsonStr + ", onReceiveAction = " + onReceiveAction + ", onErrorAction = " + onErrorAction);

    //    if (bodyJsonStr != null) ProtocolHelper.Send(path, new JSONObject(bodyJsonStr));
    //    Receive_lua(path, onReceiveAction, onErrorAction);

    //    if (bodyJsonStr != null && (onReceiveAction != null || onErrorAction != null)) m_SocketReSendMap[path] = bodyJsonStr;
    //}
    #endregion 已弃用,lua的delegate在这里回调时存在问题,目前使用Request_lua_fun替换

    #endregion 已弃用

    #endregion 对socket请求和监听消息的结构处理
    #endregion socket相关


    /// <summary>
    /// Lua中等待C#中协程开始函数
    /// </summary>
    /// <param name="coroutine">C#中要运行的协程</param> 
    public void StartCoroutineLuaToC(IEnumerator coroutine, DoneCoroutine done)
    {
        StartCoroutine(CoroutineLuaToC(coroutine, done));
    }
    public void StartCoroutineLuaToC(IEnumerator coroutine)
    {
        StartCoroutine(coroutine);
    }
    IEnumerator CoroutineLuaToC(IEnumerator coroutine, DoneCoroutine done)
    {
        yield return StartCoroutine(coroutine);
        done.isDoneCoroutine = true;
    }

    public void WeChatLogin(string pCallBackObjName)
    {
        WXPayUtil.OnWeChatSendAuth(pCallBackObjName);
    }

    public void OnWechatSendAuthCallback(string pMessage)
    {
        //Debug.Log("OnWechatSendAuthCallback : message ------------------------------------ = " + pMessage);
        CallMethod("OnWechatSendAuthCallback", pMessage);
    }
    private WWW mResultWWW;

    public void WWWReconnectCall(string pUrl,string pName , WaitCoroutine done)
    {
        StartCoroutine(WWWReconnect(pUrl ,pName, done));

    }

    public IEnumerator WWWReconnect(string pUrl,string pName, WaitCoroutine done)
    {
        CoroutineResult tCorountineResult = new CoroutineResult();

        //Debug.Log(pUrl);
        yield return tCorountineResult.WWWReConnect(pUrl);
        if (tCorountineResult.error != null)
        {
            yield return StartCoroutine(PlatformGameDefine.playform.LoadConfByUser(pName));
            //CallMethod("DoLoading",false);
          
            done.isDoneCoroutine = false;
            yield return null;
        }

        done.isDoneCoroutine = true;
        done.DownWWW = tCorountineResult._wwwResult;
    }

    public IEnumerator CheckTimeOut(WWW www, System.Action onTimeOutAction, float TimeOut)
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

    public void ResetScreenResize()
    {
        if ( UICamera.onScreenResize != null) UICamera.onScreenResize();
    }

    #region IOSStartRecharge
    //ios充值回调
    public void DoRechargeSucess()
    {
        CallMethod("DoRechargeSucess");
    }

    public void DoRechargeCancel()
    {
        CallMethod("DoRechargeCancel");
    }
    #endregion
    public void DoReceiveNotice(string pMsg)
    {
        //Debug.Log(">>>>>>>>>>getNoticeMsg:"+pMsg);
        //--CallMethod("Login","getNoticeMsg",pMsg);
        SimpleFramework.Util.CallMethod("Module_Channel","getNoticeMsg",pMsg);
        //Debug.Log(">>>>>>>>>>getNoticeMsg111111:"+pMsg);
    }

}
public class DoneCoroutine
{
    //Lua中等待C#中协程结束标记
    public bool isDoneCoroutine = false;
}

public class WaitCoroutine
{
    //Lua中等待C#中协程结束标记
    public bool isDoneCoroutine = false;
    public WWW DownWWW = null;
}


