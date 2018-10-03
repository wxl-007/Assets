using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ProtocolHelper {

    #region 协议接口路径. 这部分只是字符串路径,如果有热更新需要可以在Lua中直接封装
    public const string account_login = "AccountService/account_login";
    public const string get_account = "AccountService/get_account";
    //public const string account_login = "AccountService/account_login";
    //public const string account_login = "AccountService/account_login";
    //public const string account_login = "AccountService/account_login";
    #endregion 协议接口路径
        
    public static System.Action OnSocketConnectTriggerAction;
    public static LoginType _LoginType = LoginType.Username;
    public static string NewLobbyLogin_lua = string.Empty;
    public static string NewGameLogin_lua = string.Empty;

    #region lobby大厅 socket相关协议
    /// <summary>
    /// socket登录协议
    /// 请求Send_login自动判断登入lobby还是登入game
    /// </summary>
    /// <param name="username"></param>
    /// <param name="password"></param>
    public static void Send_account_login()
    {
       
        _LoginType = LoginType.Username;
		SocketConnectInfo connectInfo = SocketConnectInfo.Instance;
        JSONObject bodyJson = new JSONObject();
        Debug.Log("====SendAccount  Login================    "+ connectInfo.lobbyUserName);
        bodyJson.AddField("username", connectInfo.lobbyUserName);
        bodyJson.AddField("password", connectInfo.lobbyPassword);
        //bodyJson.AddField("captcha", kPassword.value);
        //bodyJson.AddField("proving", kPassword.value);
//#if UNITY_EDITOR
//        bodyJson.AddField("machineCode", "123456");//测试用
//        bodyJson.AddField("device_id", "123456");//测试用
//#else
        bodyJson.AddField("machineCode", "unity_" + EginUser.Instance.device_id);
        bodyJson.AddField("device_id", "");//"unity_" + EginUser.Instance.device_id);//测试用
//#endif
        bodyJson.AddField("client_type", "0");

        JSONObject loginJson = new JSONObject();
        loginJson.AddField("type", "AccountService");
        loginJson.AddField("tag", "account_login");
        loginJson.AddField("body", bodyJson);

		BaseSceneLua.SocketSendMessage(loginJson);
    }

    /// <summary>
    /// 发送socket微信登录协议
    /// </summary>
    public static void Send_wechat_login()
    {
        ProtocolHelper._LoginType = LoginType.WeChat;
        JSONObject json = new JSONObject();
        json.AddField("openid", EginUser.Instance.wxOpenId);
        json.AddField("nickname", EginUser.Instance.wxNickname);
        json.AddField("sex", EginUser.Instance.wxSex);
        json.AddField("is_unity", 1);
        JSONObject loginJson = new JSONObject();
        loginJson.AddField("type", "AccountService");
        loginJson.AddField("tag", "wechat_oauth");
        loginJson.AddField("body", json);

		BaseSceneLua.SocketSendMessage(loginJson);
    }

    public static void Send_guest_login() {
        _LoginType = LoginType.Guest;
        JSONObject json = new JSONObject();
        long uid_long = 0;
        string GuestUID = PlayerPrefs.GetString("GuestUID", "" + uid_long);
        //UnityEngine.Debug.Log("CK : ----------------GuestUIDGuestUIDGuestUID-------------- GuestUID = " + GuestUID);
        
        if(!long.TryParse(GuestUID, out uid_long))
        {
            GuestUID = ""+uid_long;
        }

        if(uid_long == 0) json.AddField("uid", uid_long);//0 的时候只能用数字
        else json.AddField("uid", GuestUID);
        JSONObject loginJson = new JSONObject();
        loginJson.AddField("type", "AccountService");
        loginJson.AddField("tag", "guest_login");
        loginJson.AddField("body", json);

		BaseSceneLua.SocketSendMessage(loginJson);
    }

    /// <summary>
    /// 发送
    /// socket登入成功后, 获取用户信息
    /// </summary>
    public static void Send_get_account()
    {
        JSONObject json = new JSONObject();
        json.AddField("type", "AccountService");
        json.AddField("tag", "get_account");
        json.AddField("body", JSONObject.nullJO);
        BaseSceneLua.SocketSendMessage(json);
    }

    /// <summary>
    /// 接收
    /// 获取用户信息, 返回数据的处理
    /// </summary>
    /// <param name="result"></param>
    public static void Receive_get_ccount(JSONObject result)
    {
        string session = "";
        //if (www.responseHeaders.ContainsKey("SET-COOKIE"))
        //{
        //    session = www.responseHeaders["SET-COOKIE"];
        //}
        //Dictionary<string, string> resultDict = ((JSONObject)result.resultObject).ToDictionary();
        //对socket协议中 字段 的不同进行修正
        Dictionary<string, string> resultDict = result.ToDictionary();
        if (!resultDict.ContainsKey("id")) resultDict["id"] = resultDict["userid"];
        if (!resultDict.ContainsKey("exp")) resultDict["exp"] = resultDict["exp_value"];
        if (!resultDict.ContainsKey("next_exp")) resultDict["next_exp"] = resultDict["exp_value"];
        if (!resultDict.ContainsKey("avatar_img")) resultDict["avatar_img"] = "";
        if (!resultDict.ContainsKey("agent")) resultDict["agent"] = "";
        if (!resultDict.ContainsKey("weak")) resultDict["weak"] = "0";
        if (!resultDict.ContainsKey("gold_money")) resultDict["gold_money"] = "0";

        //处理登录返回信息
        EginUser.Instance.InitUserWithDict(resultDict, session);
        EginUser.Instance.isGuest = false;
    }
#endregion lobby大厅 socket相关协议

#region 游戏 socket相关协议
	//斗地主电视现场版房间在进入房间时需要密码.
	public static string entryRoom_password = "";
    /// <summary>
    /// 游戏登入协议
    /// 请求Send_login自动判断登入lobby还是登入game
    /// </summary>
    public static void Send_game_login()
    {
        if (!string.IsNullOrEmpty(NewGameLogin_lua))
        {
            SimpleFramework.Util.CallMethod("ProtocolHelper", NewGameLogin_lua);
            return;
        }

        SocketConnectInfo connectInfo = SocketConnectInfo.Instance;
        JSONObject messageBody = new JSONObject();
        messageBody.AddField("userid", connectInfo.userId);
        messageBody.AddField("password", connectInfo.userPassword);
        messageBody.AddField("dbname", connectInfo.roomDBName);
        messageBody.AddField("version", "0");                   ///0
        messageBody.AddField("client_type", "0");
        messageBody.AddField("roomid", connectInfo.roomId);
        messageBody.AddField("fixseat", true);
		//斗地主电视现场版房间在进入房间时需要密码.
		if(entryRoom_password.Length > 0){
			messageBody.AddField("entry_pwd", entryRoom_password);
		}else{
			//进入密码房间发client_info服务器会收不到消息，奇怪
			messageBody.AddField("client_info", "WIN");          // 0928  UNITY  解决排行榜 不显示的问题  更改  此处 .
		}
        //messageBody.AddField("first_money", "");
        JSONObject messageObj = new JSONObject();
        messageObj.AddField("type", "account");
        messageObj.AddField("tag", "login");
        messageObj.AddField("body", messageBody);
        SocketManager.Instance.SendPackageWithJson(messageObj);
		entryRoom_password = "";
    }
#endregion 游戏 socket相关协议

#region 辅助方法,helper
    public static void Send_Socketlobby_login()
    {
        UnityEngine.Debug.Log("CK : ------------]]]]]]]]]]]]]]]]]]]]]------------------ _LoginType = " + _LoginType);

        if(OnSocketConnectTriggerAction != null)
        {
            OnSocketConnectTriggerAction();
            OnSocketConnectTriggerAction = null;
            return;
        }

        if (!string.IsNullOrEmpty(NewLobbyLogin_lua))
        {
            SimpleFramework.Util.CallMethod("ProtocolHelper", NewLobbyLogin_lua);
            return;
        }

        switch (_LoginType)
        {
            case LoginType.WeChat:
                Send_wechat_login();
                break;
            case LoginType.Guest:
                Send_guest_login();
                break;
            default:
                Send_account_login();
                break;
        }
    }

    public static void Send_login()
    {
        Send_login(false);
    }

    public static void Send_login(bool isGame)
    {

        Debug.Log("))))))))))))))))))))  send  login "+ isGame.ToString());

        SimpleFramework.Util.CallMethod("ProtocolHelper", "Send_login",isGame);
        return;
        if (isGame)
        {
            //NewLobbyLogin_lua = "Send_game_login";
            //if (!string.IsNullOrEmpty(NewLobbyLogin_lua))
            //{
            //    SimpleFramework.Util.CallMethod("ProtocolHelper", NewLobbyLogin_lua);
            //    NewLobbyLogin_lua = "";
            //    return;
            //}
           
            Send_game_login();
        }
        else
        {
            //NewLobbyLogin_lua = "Send_Socketlobby_login";
            //if (!string.IsNullOrEmpty(NewLobbyLogin_lua))
            //{
            //    SimpleFramework.Util.CallMethod("ProtocolHelper", NewLobbyLogin_lua);
            //    NewLobbyLogin_lua = "";
            //    return;
            //}
            Send_Socketlobby_login();
        }
    }

    public static void Send(string path, JSONObject bodyJson)
    {
        JSONObject sendJson = new JSONObject();
        string[] split = path.Split('/');
        if (split == null || split.Length != 2) throw new System.Exception("the format of path \"" + path + "\" is wrong");
        sendJson.AddField("type", split[0]);
        sendJson.AddField("tag", split[1]);
        sendJson.AddField("body", bodyJson);
		BaseSceneLua.SocketSendMessage(sendJson);
    }
#endregion 辅助方法
}

public enum LoginType{
    Username = 0,
    WeChat,
    Guest,
}
