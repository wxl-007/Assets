using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//using System;
using System.Text.RegularExpressions;

public class BaseScene : MonoBehaviour, SocketListener {

    private Dictionary<string, System.Action<JSONObject,string>> m_SocketRequestMap = new Dictionary<string, System.Action<JSONObject,string>>();
    //private Dictionary<string, System.Action<JSONObject>> m_SocketRequestMap = new Dictionary<string, System.Action<JSONObject>>();
    //private Dictionary<string, System.Action<string>> m_SocketRequest_StrResult_Map = new Dictionary<string, System.Action<string>>();
    //private Dictionary<string, System.Action<string>> m_SocketRequestErrorMap = new Dictionary<string, System.Action<string>>();
    private Dictionary<string, string> m_SocketReSendMap= new Dictionary<string, string>();//通过request发送的需要接受请求的消息中,如果没有成功处理消息,那么在socket重连后会重新发送//需要发送且需要接收的协议才有效
    private float m_CurReconnectTime;
    private const int ReconnectTimeOut = 12;

    private int m_curReconnectCount = 0;

    //510k
    public static string myusername;
    public static string myusernc;
    public void EginLoadAdditiveLevel(string levelName)
    {
        EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("ScreenLoading"));
        StartCoroutine(DoLoadAdditiveLevel(levelName));
    }
    private IEnumerator DoLoadAdditiveLevel(string levelName)
    {
        AsyncOperation async_level = Application.LoadLevelAdditiveAsync(levelName);
        yield return async_level;
    }



    public static SocketManager socketManager
    {
        get
        {
            return SocketManager.LobbyInstance;
        }
    }

    // Use this for initialization
    public void Awake () {
		EginProgressHUD.Instance.HideHUD();

		UIRoot sceneRoot = GameObject.FindObjectOfType(typeof(UIRoot)) as UIRoot;
		if (sceneRoot != null) {
			int manualHeight = 1280;		// Android

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
        EndSocket(false);
    }

    public void EginLoadLevel(string levelName){
        //if ("Hall" == levelName) {
        //    Utils.LoadLevelGUI("HappyCity", "HallPanel");// HallConsts.GameModule_hall, "HallPanel");
        //    return;
        //}
        if (levelName != "Hall")
        {
            EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("ScreenLoading"));
        }
        //StartCoroutine (DoLoadLevel (levelName));
        Utils.LoadLevelGUI(levelName);
	}


    #region socket相关
    #region 启动关闭socket连接
    public void StartSocket(bool force = false)
    {
        StartCoroutine(DoStartSocket(force));
    }

    IEnumerator DoStartSocket(bool force = true)
    {

        Debug.Log(">>>>>>>>>>>>>>>>>>>>Mark  do start socket ");
        SocketConnectInfo connectInfo = SocketConnectInfo.Instance;
        //connectInfo.roomId = string.Empty;//把房间号置为空后就不会进行游戏登入了

        //SocketManager socketManager = SocketManager.Instance;
        yield return socketManager;
        if (socketManager)
        {
            socketManager.socketListener = this;
            if (Constants.isEditor) UnityEngine.Debug.LogError("CK : ------------------------------ <color=green>PlatformGameDefine.playform.SocketLobbyUrl = " + PlatformGameDefine.playform.SocketLobbyUrl+"</color>");
            socketManager.Connect(connectInfo, PlatformGameDefine.playform.SocketLobbyUrl, force);
            Debug.Log(">>>>>>>>>>>>>>>>>>>>Mark  do start socket     1111 ");
        }
    }

    public void EndSocket(bool disconnect = false)
    {//不会回调 SocketDisconnect
        if (socketManager)
        {
            if(socketManager.socketListener == this) socketManager.socketListener = null;
            if (disconnect) socketManager.Disconnect("Exit Scene " + name);//false
        }

    }
    #endregion 启动关闭socket连接

    #region 发送socket消息
    public static void SocketSendMessage(JSONObject json)
    {
        //UnityEngine.Debug.Log("CK : ------------------------------SocketSendMessage json = " + json);

        socketManager.SendPackageWithJson(json);
    }
    #endregion 发送socket消息

    #region SocketListener回调方法
    public virtual void SocketReceiveMessage(string message)
    {
        if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ SocketReceiveMessage = " + message);

        // Socket message
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
            else if("get_account".Equals(tag) && EginUserUpdate.Instance.updateLoopHasStart){
//				Debug.Log("<color=#00ff00>update info->"+ message +"</color>");
				EginUser.Instance.UpdateUserWithDict(messageObj["body"].ToDictionary());
			}
        }

        OnReceive(messageObj);
    }


    #region socket断开连接
    public virtual void SocketDisconnect(string disconnectInfo)
    {
    }

    public virtual void OnSocketDisconnect(string disconnectInfo)
    {

        //if (disconnectInfo.Contains(SocketManager.UNITY_HOST_EXCEPTION))
        //{//socket 连接时,如果 发生异常,就直接切换下一个ip
        //    PlatformGameDefine.playform.swithSocketLobbyHostUrl(() =>
        //    {
        //        m_curReconnectCount = 0;
        //        if (this) StartSocket(true);//登录界面重连超过限制后不再重连//非登录界面则重连
        //    });

        //    return;
        //}

        //if (gameObject == null) return;
        //UnityEngine.Debug.Log("CK : --------------------------OnSocketDisconnect---- disconnectInfo = " + disconnectInfo);
        //foreach (var item in m_SocketReSendMap)
        //{
        //    UnityEngine.Debug.Log("CK : ------------------------------ key = " + item.Key + ", value = " + item.Value );

        //}

        //if(m_CurReconnectTime > ReconnectTimeOut)//超时判断
        //{
        //    EginProgressHUD.Instance.ShowPromptHUD(disconnectInfo, ()=>EginLoadLevel("Login"));
        //    return;
        //}

        //if(m_CurReconnectTime < 0)
        //{
        //    m_CurReconnectTime = 0;
        //    StartCoroutine(CheckReconnectTimeOut());
        //}

        //socketManager.socketListener = null;

        //if(this) m_curReconnectCount++;
        //if(m_curReconnectCount < 2)
        //{
        //    if (this) StartSocket(true);
        //}
        //else
        //{
        //    PlatformGameDefine.playform.swithSocketLobbyHostUrl(()=> {
        //        m_curReconnectCount = 0;
        //        if (this) StartSocket(true);
        //    });
        //}
    }

    public virtual void OnSocketManagerDisconnect(string errMsg)
    {

    }
    public virtual void OnSocketManagerTimeOut(string errMsg)
    {
        EginProgressHUD.Instance.ShowPromptHUD("连接超时,请稍后再试");//连接超时(一直重连不上), 就重新回到登入界面,避免一直连接不上的bug
    }
    #endregion socket断开连接
    #endregion SocketListener回调方法

    IEnumerator CheckReconnectTimeOut()
    {
        while (m_CurReconnectTime >= 0 && m_CurReconnectTime <= ReconnectTimeOut)
        {
            m_CurReconnectTime += Time.deltaTime;
            yield return 0;
        }
    }

    /* ------ Socket Process ------ */

    #region 大厅登入相关
    public virtual void Process_account_login_Failed(string errorInfo, string body)
    {
        SocketDisconnect(errorInfo);//登入失败会自动断开,断开后会自动在OnSocketDisconnect 重连
    }

    public virtual void Process_account_login(string info)
    {//登入成功,也代表重连成功, 因为重连后就会进行登入操作
        m_CurReconnectTime = -1;//设置成负的,用于结束超时时间的协程
        foreach (var item in m_SocketReSendMap)
        {
            ProtocolHelper.Send(item.Key, new JSONObject(item.Value)); 
        }
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

        if (m_SocketRequestMap.ContainsKey(path) && m_SocketRequestMap[path] != null)
        {
            m_SocketRequestMap[path](messageObj["body"], "ok".Equals(result) ? null : result);
        }

        //if ("ok".Equals(result))
        //{
        //    if (m_SocketRequestMap.ContainsKey(path) && m_SocketRequestMap[path] != null)
        //        m_SocketRequestMap[path](messageObj["body"]);

        //    if (m_SocketRequest_StrResult_Map.ContainsKey(path) && m_SocketRequest_StrResult_Map[path] != null)
        //        m_SocketRequest_StrResult_Map[path](messageObj["body"].ToString());
        //}
        //else
        //{
        //    if (m_SocketRequestErrorMap.ContainsKey(path) && m_SocketRequestErrorMap[path] != null)
        //        m_SocketRequestErrorMap[path](result);
        //}
    }

    /// <summary>
    /// 监听 SocketReceiveMessage 的消息
    /// </summary>
    /// <param name="path"></param>
    /// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    /// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    public void Receive(string path, System.Action<JSONObject,string> onReceiveAction)
    {
        if (onReceiveAction != null) m_SocketRequestMap[path] = onReceiveAction;
    }

    /// <summary>
    /// 请求socket接口,处理 JSONObject 数据, onReceiveAction 直接处理body内容
    /// </summary>
    /// <param name="path"></param>
    /// <param name="body">如果body为空,那么该项填空字符串, 如果该项为null,那么只会进行Receive操作</param>
    /// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    /// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    public void Request(string path, JSONObject body, System.Action<JSONObject,string> onReceiveAction)
    {
        if (body != null) ProtocolHelper.Send(path, body);
        Receive(path, onReceiveAction);

        if (body != null && onReceiveAction != null) m_SocketReSendMap[path] = body.ToString();
    }


    /// <summary>
    /// 对方法Request(string path, JSONObject body, System.Action<JSONObject,string> onReceiveAction)在error部位空的时候的默认显示错误信息
    /// </summary>
    /// <param name="path"></param>
    /// <param name="body"></param>
    /// <param name="onReceiveAction"></param>
    public void Request(string path, JSONObject body, System.Action<JSONObject> onReceiveAction)
    {
        if (body != null)
        {
            if (onReceiveAction != null) EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
            ProtocolHelper.Send(path, body);
        }
        Receive(path, (result,error)=> {
            //EginProgressHUD.Instance.HideHUD();
            if (error != null)
            {//获取用户信息失败
                EginProgressHUD.Instance.ShowPromptHUD(error);
            }else
            {
                if (onReceiveAction != null) onReceiveAction(result);
            }
        });

        if (body != null && onReceiveAction != null) m_SocketReSendMap[path] = body.ToString();
    }

    ///// <summary>
    ///// 监听 SocketReceiveMessage 的消息
    ///// </summary>
    ///// <param name="path"></param>
    ///// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    ///// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    //public void Receive(string path, System.Action<JSONObject> onReceiveAction, System.Action<string> onErrorAction)
    //{
    //    if(onReceiveAction != null) m_SocketRequestMap[path] = onReceiveAction;
    //    if(onErrorAction != null) m_SocketRequestErrorMap[path] = onErrorAction;
    //}

    ///// <summary>
    ///// 监听 SocketReceiveMessage 的消息
    ///// 主要考虑lua中使用
    ///// </summary>
    ///// <param name="path"></param>
    ///// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    ///// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    //public void Receive_lua(string path, System.Action<string> onReceiveAction, System.Action<string> onErrorAction)
    //{
    //    if(onReceiveAction != null) m_SocketRequest_StrResult_Map[path] = onReceiveAction;
    //    if(onErrorAction != null) m_SocketRequestErrorMap[path] = onErrorAction;
    //}

    ///// <summary>
    ///// 请求socket接口,处理 JSONObject 数据, onReceiveAction 直接处理body内容
    ///// </summary>
    ///// <param name="path"></param>
    ///// <param name="body">如果body为空,那么该项填空字符串, 如果该项为null,那么只会进行Receive操作</param>
    ///// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    ///// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    //public void Request(string path, JSONObject body, System.Action<JSONObject> onReceiveAction, System.Action<string> onErrorAction)
    //{
    //    if(body != null) ProtocolHelper.Send(path, body);
    //    Receive(path, onReceiveAction, onErrorAction);

    //    if(body != null && (onReceiveAction != null || onErrorAction != null)) m_SocketReSendMap[path] = body.ToString();
    //}

    ///// <summary>
    ///// 请求socket接口,直接处理string格式数据, onReceiveAction 直接处理body内容
    ///// 主要考虑lua中的使用string 比较方便
    ///// </summary>
    ///// <param name="path"></param>
    ///// <param name="bodyJsonStr">如果body为空,那么该项填空字符串, 如果该项为null,那么只会进行Receive操作</param>
    ///// <param name="onReceiveAction">请求成功的回调,该值为空则不会添加该接受action</param>
    ///// <param name="onErrorAction">请求出错的回调,该值为空则不会添加该接受action</param>
    //public void Request_lua(string path, string bodyJsonStr, System.Action<string> onReceiveAction, System.Action<string> onErrorAction)
    //{
    //    if (bodyJsonStr != null) ProtocolHelper.Send(path, new JSONObject(bodyJsonStr));
    //    Receive_lua(path, onReceiveAction, onErrorAction);

    //    if (bodyJsonStr != null && (onReceiveAction != null || onErrorAction != null)) m_SocketReSendMap[path] = bodyJsonStr;
    //}
    #endregion 对socket请求和监听消息的结构处理
    #endregion socket相关
}
