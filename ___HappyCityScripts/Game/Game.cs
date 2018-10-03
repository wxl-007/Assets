using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using SimpleFramework;

public class Game : LuaBehaviour, SocketListener {

    public static SocketManager socketManager
    {
        get
        {
            return SocketManager.Instance;
        }
    }

    //public virtual void Awake () {
    //		UIRoot sceneRoot = transform.root.GetComponent<UIRoot>();
    //		if (sceneRoot != null) {
    //			int manualHeight = 800;		// Android
    //			
    //			#if UNITY_IPHONE
    //			if((iPhone.generation.ToString()).IndexOf("iPad") > -1){	// iPad
    //				manualHeight = 1000;	
    //			}else if (Screen.width <= 960) {	// <= iPhone4s
    //				manualHeight = 900;
    //			}
    //			#endif
    //			
    //			sceneRoot.scalingStyle = UIRoot.Scaling.FixedSize;
    //			sceneRoot.manualHeight = manualHeight;
    //		}
    //}

    public void StartGameSocket () {
		StartCoroutine(DoStartGameSocket());
	}
	private IEnumerator DoStartGameSocket () {
		//SocketManager socketManager = SocketManager.Instance;
		yield return socketManager;
		
		socketManager.socketListener = this;
		SocketReady();
	}
	
	/* ------ Button Click ------ */
	public virtual void OnClickBack () {
		SocketConnectInfo.Instance.roomFixseat = true;  // For auto add desk.
        SocketConnectInfo.Instance.roomHost = "";
        socketManager.socketListener = null;
        socketManager.Disconnect("Exit from the game.");
//		EginUserUpdate.Instance.UpdateInfoNow();	// Update userinfo.
		//Application.LoadLevel("Module_Rooms");
		Utils.LoadLevelGUI("Hall");
		//Utils.LoadLevelGUI("Module_Rooms");

        //510k
        //EginUserUpdate.Instance.UpdateInfoNow();	// Update userinfo. 
        //Application.LoadLevel("Game_Desks");//Application.LoadLevel("Hall");修改返回大厅 15年12月31号
    }
	
	/* ------ Socket Sender ------ */
	public void SendPackage (string message) {
		//SocketManager socketManager = SocketManager.Instance;
		socketManager.SendPackage(message);
	}
	public void SendPackageWithJson(JSONObject messageObj) {
		//SocketManager socketManager = SocketManager.Instance;
		socketManager.SendPackageWithJson(messageObj);
	}
	
	/* ------ Socket Listener ------ */
	public virtual void SocketReady () {
		// Socket ready
		if (!SocketConnectInfo.Instance.roomFixseat) {
			// Auto select desk
			JSONObject messageBody = new JSONObject(JSONObject.Type.ARRAY);
			messageBody.Add(new JSONObject(0f));
			messageBody.Add(new JSONObject(-1f));
			JSONObject messageObj = new JSONObject();
			messageObj.AddField("type", "seatmatch");
			messageObj.AddField("tag", "sit");
			messageObj.AddField("body", messageBody);
            socketManager.SendPackageWithJson(messageObj);
		}
	}
	
	public virtual void SocketReceiveMessage (string message) {
		// Socket message
		JSONObject messageObj = new JSONObject(message);
        if (messageObj["type"] == null) return;
		string type = messageObj["type"].str;
		string tag = messageObj["tag"].str;
		if ("account".Equals(type)) {
			if ("login_success".Equals(tag)) {
				ProcessAccountSucess(messageObj);
			} else if (tag.Contains("login_failed_")) {
				string errorInfo = "";
				if ("login_failed_auth".Equals(tag)) {
					errorInfo = ZPLocalization.Instance.Get("Socket_login_failed_auth");
				} else if ("login_failed_inactive".Equals(tag)) {
					errorInfo = ZPLocalization.Instance.Get("Socket_login_failed_inactive");
				} else if ("login_failed_otherroom".Equals(tag)) {
					errorInfo = ZPLocalization.Instance.Get("Socket_login_failed_otherroom");
				} else if ("login_failed_nomoney".Equals(tag)) {
					errorInfo = ZPLocalization.Instance.Get("Socket_login_failed_nomoney");
					errorInfo += "\n";
					errorInfo += ZPLocalization.Instance.Get("Socket_login_failed_nomoney_min");
					errorInfo += SocketConnectInfo.Instance.roomMinMoney;
				} else if ("login_failed_nousemoney".Equals(tag)) {
					errorInfo = ZPLocalization.Instance.Get("Socket_login_failed_nousemoney");
					errorInfo += "\n";
					errorInfo += ZPLocalization.Instance.Get("Socket_login_failed_nomoney_min");
					errorInfo += SocketConnectInfo.Instance.roomMinMoney;
				} else if ("login_failed_notexist".Equals(tag)) {
					errorInfo = ZPLocalization.Instance.Get("Socket_login_failed_notexist");
				} else if ("login_failed_online".Equals(tag)) {
					errorInfo = ZPLocalization.Instance.Get("Socket_login_failed_online");
				} else if ("login_failed_closed".Equals(tag)) {
					errorInfo = ZPLocalization.Instance.Get("Socket_login_failed_closed");
					if (messageObj["body"] != null && messageObj["body"].str.Length > 0) {
						errorInfo += ZPLocalization.Instance.Get("Socket_login_failed_closed_reason");
						errorInfo += Regex.Unescape(messageObj["body"].str);
					}
				} else {
					errorInfo = ZPLocalization.Instance.Get("Socket_Unkonw");
				}
				ProcessAccountFailed(errorInfo);
			} else if ("login_from_somewhere".Equals(tag)) {
				ProcessAccountFailed(ZPLocalization.Instance.Get("Socket_login_from_somewhere"));
			} else if ("update_intomoney".Equals(tag)) {
				ProcessUpdateIntomoney(messageObj);
			} else if ("loadmoney".Equals(tag)) {
//				gameModuleManager.LoadMoneySuccess();
			} else if ("loadmoney_fail".Equals(tag)) {
//				gameModuleManager.LoadMoneyFail((int)(messageObj["body"].n));
			}else {
				//由于银行也用到了account 有新的tag标签进入
				if(!"storemoney".Equals(tag) && !"storemoney_fail".Equals(tag) && !"bankrecord_fail".Equals(tag) && !"bankrecord".Equals(tag)
					&& !"delivermoney".Equals(tag) && !"delivermoney_fail".Equals(tag)){
					ProcessAccountFailed(ZPLocalization.Instance.Get("Socket_Unkonw"));
				}
			}
		} 
	}
	
	public virtual void SocketDisconnect (string disconnectInfo) {

		// Socket disconnect
//		float promptTime = 2f;
		//Deleted by 2016.3.29 
//		ShowPromptHUD(disconnectInfo);
//		StartCoroutine(DoSocketDisconnect(promptTime));
	}

    public void OnSocketDisconnect(string disconnectInfo)
    {
        //socketManager.socketListener = null;
        //PlatformGameDefine.playform.swithGameHostUrl();
        StartCoroutine(reconnectSocket());
    }

    public virtual void OnSocketManagerDisconnect(string errMsg)
    {

    }

    public virtual void OnSocketManagerTimeOut(string errMsg)
    {
        OnClickBack();//连接超时(一直重连不上), 
    }
    protected IEnumerator reconnectSocket(){
		SocketConnectInfo.Instance.roomFixseat = true;
        //		EginUserUpdate.Instance.UpdateInfoNow();	// Update userinfo.
        yield return 0;
		//yield return new WaitForSeconds(2.0f);
        //socketManager.socketListener = this;
        //socketManager.Connect(SocketConnectInfo.Instance);
//		yield return new WaitForSeconds(2.0f);
	}
	private IEnumerator DoSocketDisconnect (float promptTime) {
		yield return new WaitForSeconds(promptTime);
		OnClickBack();
	}
	
	/* ------ Socket Process ------ */
	public virtual void ProcessAccountFailed (string errorInfo) {
		SocketDisconnect(errorInfo);

        float promptTime = 2f;
        //Deleted by 2016.3.29
        ShowPromptHUD(errorInfo);
        StartCoroutine(DoSocketDisconnect(promptTime));
    }

    public virtual void ProcessAccountSucess (JSONObject messageObj) {
	}

	public virtual void ProcessUpdateIntomoney (JSONObject messageObj) {
		// shawn.debug
	}
	
	/* ------ Other ------ */
	public virtual void ShowPromptHUD (string info) {
		EginProgressHUD.Instance.ShowPromptHUD(info);
	}
}
