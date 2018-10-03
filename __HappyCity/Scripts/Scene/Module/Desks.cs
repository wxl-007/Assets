using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq; 
using System.Text.RegularExpressions;

public enum DeskType {
	DeskType_2 = 2, 
	DeskType_3 = 3,
	DeskType_4 = 4,
	DeskType_5 = 5,
	DeskType_6 = 6,
	DeskType_7 = 7,
    DeskType_16 = 16,
	DeskType_All = 10
}

public enum GameType {
	Poker, 
	Mahjong,
	dice
}

public class Desks : ModuleBase, SocketListener {
	
	public GameType mGameType = GameType.Poker;
	public DeskType mDeskType = DeskType.DeskType_3;

	public UILabel kRoomTitle;
	public Transform vDesks;
	public GameObject kQuickPlayButton;

	// Use this for initialization
	void Start () {
		mGameType = PlatformGameDefine.game.GameIconType;
		mDeskType = PlatformGameDefine.game.GameDeskType;
		kRoomTitle.text = SocketConnectInfo.Instance.roomTitle;
		if (mDeskType == DeskType.DeskType_All) {
			kQuickPlayButton.SetActive(false);
		}
		
		StartCoroutine(DoSocketConnect());
	}

	void OnDestroy()
	{
		EginProgressHUD.Instance.HideHUD();
	}
	
	/* ------ Button Click ------ */
	public override void OnClickBack () {
		SocketManager.Instance.socketListener = null;
		SocketManager.Instance.Disconnect("Exit from the table.");
		base.OnClickBack();
	}
	
	void OnQuickPlayButtonClick () {
		// shawn.debug IsConnect
		DoSitDownClick("0", -1);
	}
	void OnSeatButtonClick (GameObject seat) {
		DeskSeatInfo seatInfo = (DeskSeatInfo)seat.GetComponent(typeof(DeskSeatInfo));
		DoSitDownClick(seatInfo.deskId, seatInfo.seatId);
	}
	void DoSitDownClick (string deskId, int seatId) {
		JSONObject messageBody = new JSONObject(JSONObject.Type.ARRAY);
		messageBody.Add(new JSONObject(deskId));
		messageBody.Add(new JSONObject(seatId));
		JSONObject messageObj = new JSONObject();
		messageObj.AddField("type", "seatmatch");
		messageObj.AddField("tag", "sit");
		messageObj.AddField("body", messageBody);
		SocketManager.Instance.SendPackageWithJson(messageObj);
        EginProgressHUD.Instance.ShowWaitHUD("正在进入游戏...",true);
	}

    /* ------ Socket Listener ------ */
    public void SocketReceiveMessage(string message)
    {
        //UnityEngine.Debug.Log("CK : ------------------------------desks SocketReceiveMessage = " + message);

        JSONObject messageObj = new JSONObject(message);
		string type = messageObj["type"].str;
		string tag = messageObj["tag"].str;
		EginTools.Log (type+"===="+tag);
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
				// shawn.debug
			} else {
				ProcessAccountFailed(ZPLocalization.Instance.Get("Socket_Unkonw"));
			}
		} else if ("seatmatch".Equals(type)) {
			if ("seatlist".Equals(tag)) {
				ProcessSeatlist(messageObj);
			} else if ("on_sitdown".Equals(tag)) {
				ProcessSitdown(messageObj);
			} else if ("on_situp".Equals(tag)) {
				ProcessSitup(messageObj);
			}  else if ("on_begin".Equals(tag)) {
				ProcessGameBegin(messageObj);
			} else if ("on_end".Equals(tag)) {
				ProcessGameEnd(messageObj);
			} else if ("sit_fail".Equals(tag)) {
				ProcessSitFail(messageObj);
			}
		} else if ("game".Equals(type)) {
			if ("enter".Equals(tag)) {
				SocketManager.Instance.socketListener = null;
				SocketManager.Instance.SocketMessageRollback(message);
				PlatformGameDefine.game.StartGame();
			}
		}
	}
	
	public void SocketDisconnect (string disconnectInfo) {
		//float promptTime = 2f;
		//EginProgressHUD.Instance.ShowPromptHUD(disconnectInfo, promptTime);
		
		//StartCoroutine(DoSocketDisconnect(promptTime));
	}
	private IEnumerator DoSocketDisconnect (float promptTime) {
		yield return new WaitForSeconds(promptTime);
		OnClickBack();
	}

    private int m_ReconnectCount;
    public override void OnSocketDisconnect(string disconnectInfo)
    {
        if(m_ReconnectCount < 2)
        {
            m_ReconnectCount++;
            //base.OnSocketDisconnect(disconnectInfo);
            PlatformGameDefine.playform.swithGameHostUrl();
		    StartCoroutine(DoSocketConnect());
        }
        else
        {
            m_ReconnectCount = 0;
            float promptTime = 2f;
            EginProgressHUD.Instance.ShowPromptHUD(disconnectInfo, promptTime);

            StartCoroutine(DoSocketDisconnect(promptTime));
        }
    }

    /* ------ Socket Process ------ */
    private void ProcessAccountFailed (string errorInfo) {
		SocketManager.Instance.socketListener = null;
		//SocketDisconnect(errorInfo);

        EginProgressHUD.Instance.ShowPromptHUD(errorInfo);

        StartCoroutine(DoSocketDisconnect(2));
    }

    private void ProcessAccountSucess (JSONObject messageObj) {
		// （百人类游戏 || 玩家为断开重进） 则直接进入游戏
		if (mDeskType == DeskType.DeskType_All || messageObj["body"]["re_enter"].b) {
			ProcessSitSucess();
		}
	}

	private void ProcessSeatlist (JSONObject messageObj) {
		List<JSONObject> tempDeskInfos = messageObj["body"]["desks"].list;
		System.Linq.IOrderedEnumerable<JSONObject> deskInfos = tempDeskInfos.OrderBy(obj => int.Parse(obj[0].ToString()));
		
		GameObject deskPrefab = DeskPrefab();
		UIGrid desksGrid = (UIGrid)vDesks.GetComponent(typeof(UIGrid));
		
		Vector2 padding = DeskPadding();
		desksGrid.cellWidth = padding.x;
		desksGrid.cellHeight = padding.y;
		desksGrid.maxPerLine = DeskRowCount();
			
		foreach (JSONObject deskInfo in deskInfos) {
			if (deskInfo.type == JSONObject.Type.NULL) { break; }
			
			string deskId = deskInfo[0].ToString();
			bool isPlaying = deskInfo[1].b;
			List<JSONObject> seatInfos = deskInfo[2].list;
			
			GameObject desk = (GameObject)Instantiate(deskPrefab);
			desk.name = "Desk_"+deskId;
			desk.transform.parent = vDesks;
			desk.transform.localScale = Vector3.one;
			
			((UILabel)desk.transform.Find("ID").GetComponentInChildren(typeof(UILabel))).text = deskId;
			UpdateDeskState(desk.transform, isPlaying);
			for (int j=0; j<seatInfos.Count; j++) {
				Transform deskSeat = desk.transform.Find("Seat_"+j);
				if (deskSeat == null) { continue; }

				DeskSeatInfo seatInfo = (DeskSeatInfo)deskSeat.GetComponent(typeof(DeskSeatInfo));
				seatInfo.deskId = deskId;
				seatInfo.seatId = j;
				
				UIButtonMessage messageButton = (UIButtonMessage)deskSeat.GetComponent(typeof(UIButtonMessage));
				messageButton.target = this.gameObject;
				messageButton.functionName = "OnSeatButtonClick";
				
				if (seatInfos[j].type == JSONObject.Type.ARRAY) {
					DoSitdown(deskSeat, seatInfos[j][0].ToString(), j, (int)seatInfos[j][1].n);
				} else {
					DoSitup(deskSeat);
				}
			}
		}
		desksGrid.repositionNow = true;
	}
	
	private void ProcessSitdown (JSONObject messageObj) {
		JSONObject body = messageObj["body"];
		string deskId = body[0].ToString();
		string uid = body[1].ToString();
		Transform desk = vDesks.Find("Desk_"+deskId);
		if (desk != null) {
			int seatNo = (int)body[3].n;
			Transform deskSeat = desk.Find("Seat_"+seatNo);
			DoSitdown(deskSeat, uid, seatNo, (int)body[2].n);
		}
		if (uid.Equals(SocketConnectInfo.Instance.userId)) {
			ProcessSitSucess();
		}
	}
	private void DoSitdown (Transform deskSeat, string uid, int seatNo, int avatarNo) {
		if (deskSeat != null) {
			BoxCollider seatBoxCollider = (BoxCollider)deskSeat.GetComponent(typeof(BoxCollider));
			seatBoxCollider.enabled = false;
			
			UISprite playerAvatar = (UISprite)deskSeat.GetChild(0).GetComponent(typeof(UISprite));
			playerAvatar.spriteName = DeskAvatar(seatNo, avatarNo);
	    	playerAvatar.alpha = 1f;
			
			deskSeat.name = "Seat_"+uid;
		}
	}
	
	private void ProcessSitup (JSONObject messageObj) {
		JSONObject body = messageObj["body"];
		string deskId = body[0].ToString();
		Transform desk = vDesks.Find("Desk_"+deskId);
		if (desk != null) {
			string uid = body[1].ToString();
			Transform deskSeat = desk.Find("Seat_"+uid);
			DoSitup(deskSeat);
		}
	}
	private void DoSitup (Transform deskSeat) {
		if (deskSeat != null) {
	    	((UISprite)deskSeat.GetChild(0).GetComponent(typeof(UISprite))).alpha = 0f;
			
			DeskSeatInfo seatInfo = (DeskSeatInfo)deskSeat.GetComponent(typeof(DeskSeatInfo));
			deskSeat.name = "Seat_"+seatInfo.seatId;
					
			BoxCollider seatBoxCollider = (BoxCollider)deskSeat.GetComponent(typeof(BoxCollider));
			seatBoxCollider.enabled = true;
		}
	}
	
	private void ProcessGameBegin (JSONObject messageObj) {
		string deskId = messageObj["body"].ToString();
		Transform desk = vDesks.Find("Desk_"+deskId);
		UpdateDeskState(desk, true);
	}
	
	private void ProcessGameEnd (JSONObject messageObj) {
		string deskId = messageObj["body"].ToString();
		Transform desk = vDesks.Find("Desk_"+deskId);
		UpdateDeskState(desk, false);
	}
	
	private void ProcessSitFail (JSONObject messageObj) {
		int errorCode = (int)messageObj["body"].n;
		string errorInfo = "";
		
		switch (errorCode) {
		case 1:
		case 2:
		case 3: 
			errorInfo = ZPLocalization.Instance.Get("Socket_sit_fail_"+errorCode);
			break;
		default:
			errorInfo = ZPLocalization.Instance.Get("Socket_sit_Unkonw");
			break;
		}
		EginProgressHUD.Instance.ShowPromptHUD(errorInfo);
	}
	
	public virtual void ProcessSitSucess () {
		SocketManager.Instance.socketListener = null;
		PlatformGameDefine.game.StartGame();
	}
	
	/* ------ Desk Type ------ */	
	private GameObject DeskPrefab () {
		string filePath = "Prefabs/Desk_" + (int)mDeskType;
		//GameObject prefab = Resources.Load(filePath, typeof(GameObject)) as GameObject;
		GameObject prefab = SimpleFramework.Util.LoadAsset("happycity/Module_Desks", "Desk_"+ (int)mDeskType) as GameObject;
		return prefab;
	}
	
	private string DeskAvatar (int sitNo, int avatarNo) {
		string avatarName = "avatar_" + avatarNo + "_";
		
		switch (mDeskType) {
		case DeskType.DeskType_2:
			switch (sitNo) {
			case 0: avatarName += "left"; break;
			case 1: avatarName += "right"; break;
			}
			break;
		case DeskType.DeskType_3:
			switch (sitNo) {
			case 0: avatarName += "top"; break;
			case 1: avatarName += "left"; break;
			case 2: avatarName += "right"; break;
			}
			break;
		case DeskType.DeskType_4:
			switch (sitNo) {
			case 0: avatarName += "top"; break;
			case 1: avatarName += "left"; break;
			case 2: avatarName += "bottom"; break;
			case 3: avatarName += "right"; break;
			}
			break;
		case DeskType.DeskType_5:
			switch (sitNo) {
			case 0: case 1: avatarName += "top"; break;
			case 2: avatarName += "left"; break;
			case 3: case 4: avatarName += "bottom"; break;
			}
			break;
		case DeskType.DeskType_6:
			switch (sitNo) {
			case 0: case 1: avatarName += "top"; break;
			case 2: avatarName += "left"; break;
			case 3: case 4: avatarName += "bottom"; break;
			case 5: avatarName += "right"; break;
			}
			break;
		case DeskType.DeskType_7:
			switch (sitNo) {
			case 0: case 1: avatarName += "top"; break;
			case 2: avatarName += "left"; break;
			case 3: case 4: case 5: avatarName += "bottom"; break;
			case 6: avatarName += "right"; break;
			}
			break;
		}
		return avatarName;
	}
	
	private Vector2 DeskPadding () {
		Vector2 padding = new Vector2(0, 0);
		
		switch (mDeskType) {
		case DeskType.DeskType_2:
		case DeskType.DeskType_3:
		case DeskType.DeskType_4:
			padding = new Vector2(325, 325);
			break;
		case DeskType.DeskType_5:
		case DeskType.DeskType_6:
			padding = new Vector2(433, 325);
			break;
		case DeskType.DeskType_7:
			padding = new Vector2(650, 325);
			break;
		}
		return padding;
	}
	
	private int DeskRowCount () {
		int count = 5;
		
		switch (mDeskType) {
		case DeskType.DeskType_2:
		case DeskType.DeskType_3:
		case DeskType.DeskType_4:
			count = 5;
			break;
		case DeskType.DeskType_5:
		case DeskType.DeskType_6:
			count = 4;
			break;
		case DeskType.DeskType_7:
			count = 3;
			break;
		}
		return count;
	}
	
	private string DeskGameSprite (bool isPlaying) {
		string spriteName = "game_poker";
		
		switch (mGameType) {
		case GameType.Mahjong:
			spriteName = "game_mahjong";
			break;
		}
		if (isPlaying) { spriteName += "_p"; }
		
		return spriteName;
	}
	
	/* ------ Other ------ */	
	private IEnumerator DoSocketConnect () {
		SocketConnectInfo connectInfo = SocketConnectInfo.Instance;
		if (connectInfo.ValidInfo()) {
			SocketManager socketManager = SocketManager.Instance;
			yield return socketManager;

			if( PlatformGameDefine.game.GameTypeIDs == "6" || (PlatformGameDefine.game.GameName == "DDZ" && PlatformGameDefine.game.GameTypeIDs == "4") 
				|| (PlatformGameDefine.game.GameName == "DDZ" && (PlatformGameDefine.game.GameTypeIDs == "7" || PlatformGameDefine.game.GameTypeIDs == "8") )){
				EginProgressHUD.Instance.ShowWaitHUD("正在进入比赛场...",true);
			}
			socketManager.socketListener = this;
			socketManager.Connect(connectInfo);
        }else {
			EginProgressHUD.Instance.ShowPromptHUD(ZPLocalization.Instance.Get("Socket_Valid"));
		}
	}
	
	private void UpdateDeskState (Transform desk, bool isPlaying) {
		if (desk != null) {
			UISprite gameSprite = (UISprite)desk.Find("Game").GetComponent(typeof(UISprite));
			gameSprite.spriteName = DeskGameSprite(isPlaying);
			gameSprite.MakePixelPerfect();
		}
	}
}
