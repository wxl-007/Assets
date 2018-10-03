//#define PC_RECORD

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.IO;
using System.Text;
using System;
//using System.Collections.Generic;
using System.Linq;


public class GameDDZ : Game {

	public GameObject ddzPlayerPrbL;
	public GameObject ddzPlayerPrbR;
	public GameObject flyCoinPrb;

    /// <summary>
    /// 游戏玩家的控制脚本
    /// </summary>
	public DDZPlayerCtrl userPlayerCtrl;

	private DDZPlayerCtrl prePlayer;
	private DDZPlayerCtrl roundLeader;

    public GameObject userPlayerObj;

    public GameObject userCardScore;

    public DDZUserBtnGroup btnGroup;
	public GameObject waitObj;

    public GameObject msgQuit;
	public GameObject settingPanel;
    public GameObject msgAccountFailed;
    public GameObject msgNotContinue;

    public AudioClip soundStart;

	public UIButton seePreCardBtn;
	public UIButton autoDrawBtn;
	public GameObject cancelAutoBtn;

	public UISprite _userAvatar;
    public UILabel _userNickname;
	public UILabel _userIntoMoney;
    private UILabel _userLevel;

	public VfxAnimaGroup vfxMgr;

	private bool _isMatch = false;

	//CMP objs
	public GameObject rulesBtn;
	public GameObject leaderboardBtn;
	public DDZLeaderboard leaderboard;
	public DDZBSRulesPanel rulesPanel;
	public DDZCWinAnima   resultAnima;
	public GameObject  coinIcon;
	public UISprite tipSpt;
//	public GameObject gameSettingBtn;

	#if PC_RECORD
	public static bool isPCRecord{get{return true;}}
	#else
	public static bool isPCRecord{get{return false;}}
	#endif

	public bool isMatch{
		get{
			return _isMatch;
		}
	}

    /// <summary>
    /// 游戏开始时正在游戏的玩家
    /// </summary>
	public List<GameObject> _playingPlayerList = new List<GameObject>();

    /// <summary>processok
    /// 游戏开始时等待的玩家
    /// </summary>
    private List<GameObject> _waitPlayerList = new List<GameObject>();

    /// <summary>
    /// 正常进入游戏时已经准备的玩家(wait=true ready=true)，
    /// 需要在游戏开始时加入_playingPlayerList，并清空
    /// </summary>
    private List<GameObject> _readyPlayerList = new List<GameObject>();

	private int curPlayerCount = 0;

    /// <summary>
    /// 动态生成的玩家实例名字的前缀
    /// </summary>
    private string _nnPlayerName = "NNPlayer_";

    /// <summary>
    /// 玩家的位置
    /// </summary>
    private int _userIndex = 0;

    private GameObject[] _colorBtns;

    private bool _isPlaying = false;
	//Using in DDZCwinAnima.cs for network lag bug.
	public bool isPlaying{get{return _isPlaying;}}

	public EmotionPanel emotionPl;
	public ChatPanel    chatPl;
	public DDZPreCardPanel  precardPl;
	public int passCount=0;//Round end if pass equal 2
	private bool hasCall = false;

	public bool isInBattle = false;
	//DDZ 5 mins match use this
	private bool isGameOverAnimaPlaying = false;
	private int timeupCount=0;
	private int noCallCount  = 0;
	private int roundCount = 0;
	private bool isFinalVS = false;

	public GameObject tipMsg;
	public GameObject networkTip;
	//直播现场版斗地主用------>
	private UILabel   roundCountLb;
	private int  liveRoundCount = 1;
	public bool isLiveRoom{ get{return PlatformGameDefine.game.GameTypeIDs == "20";}}
	private GameObject liveroomScoreboard;
	//131Game
	public GameObject logo131;
	public bool isObserver = false;
	public int obID = -1;
	private GameDDZOb gameDDZOb;
	private GameObject recordBtn;
	private GameObject recordDialog;

	//131 欢腾斗地主
	public bool is131Happy{ get{ return PlatformGameDefine.game.GameTypeIDs == "6" && PlatformGameDefine.game.GameID == "1095"; } }
	public DDZHappy131 ddz131;

    public void Awake()
    {
//		Debug.LogError("Enter game done-->"+ Time.realtimeSinceStartup + " gametypeids:"+PlatformGameDefine.game.GameTypeIDs);
//        base.Awake();
		if(PlatformGameDefine.game.GameTypeIDs == "6" || PlatformGameDefine.game.GameTypeIDs == "4" || PlatformGameDefine.game.GameTypeIDs == "7"
			|| PlatformGameDefine.game.GameTypeIDs == "8" || PlatformGameDefine.game.GameTypeIDs == "9"){
			_isMatch = true;
		}else{
			_isMatch = false;
		}
		GameObject quitTipTxt = transform.parent.parent.Find("infoBtnLayer/MsgContainer/MsgQuit/content").gameObject;
		GameObject quitTipNormalTxt = transform.parent.parent.Find("infoBtnLayer/MsgContainer/MsgQuit/des").gameObject;
		if(!isMatch){
			rulesBtn.SetActive(false);
			leaderboardBtn.SetActive(false);
			resultAnima.gameObject.SetActive(false);
			rgtPanel.gameObject.SetActive(false);
			quitTipTxt.SetActive(false);
			quitTipNormalTxt.SetActive(true);
		}else{
			coinIcon.SetActive(false);

			quitTipTxt.SetActive(true);
			quitTipNormalTxt.SetActive(false);
			if(PlatformGameDefine.game.GameTypeIDs == "9" || PlatformGameDefine.game.GameTypeIDs == "8"){
				rgtPanel.dailyQuitBtn.GetComponent<UIButton>().onClick.Add(new EventDelegate(this, "UserQuit"));
			}else{
				rgtPanel.quitBtn.onClick.Add(new EventDelegate(this, "UserQuit"));
			}
			if(PlatformGameDefine.game.GameTypeIDs == "6" || PlatformGameDefine.game.GameTypeIDs == "9"){
				rulesPanel.matchType = DDZRegtPanel.eMatchType.min5;
				rgtPanel.isHoursMatch = false;
				rgtPanel.matchType = DDZRegtPanel.eMatchType.min5;
				if(PlatformGameDefine.game.GameTypeIDs == "9"){
					rgtPanel.useDailyBg();
					leaderboard.titleLb.text = "斗地主日赛排名";
				}else{
					if(is131Happy){
						GameObject rgtPrb = SimpleFramework.Util.LoadAsset("GameDDZC/happy131","Module_DDZ131Reg") as GameObject;
						GameObject dialogPrb = SimpleFramework.Util.LoadAsset("GameDDZC/happy131","happy131Dialogs") as GameObject;
						GameObject rgtObj = NGUITools.AddChild(transform.parent.parent.gameObject, rgtPrb);
						rgtPanel.gameObject.SetActive(false);
						ddz131 = new DDZHappy131(this,  rgtObj.GetComponent<Happy131Regt>() );
						ddz131.dialog =  NGUITools.AddChild(transform.parent.parent.Find("infoBtnLayer").gameObject, dialogPrb).GetComponent<Happy131Dialogs>();
						ddz131.dialog.mainDoc = this;
						ddz131.dialog.hideDialog();
						ddz131.ddz131Rgt.mainDoc = this;
						_userIntoMoney.symbolStyle = NGUIText.SymbolStyle.Colored;
						_userIntoMoney.color = new Color(143.0f/255.0f, 1.0f, 162.0f/255.0f);
					}else{
						rgtPanel.useBg1();
					}
				}
			}else if(PlatformGameDefine.game.GameTypeIDs == "4"){
				rulesPanel.matchType = DDZRegtPanel.eMatchType.hour;
				rgtPanel.matchType = DDZRegtPanel.eMatchType.hour;
				rgtPanel.isHoursMatch = true;
				rgtPanel.useBg2();
				leaderboard.titleLb.text = "斗地主整点赛排名";
			}else if(PlatformGameDefine.game.GameTypeIDs == "7" || PlatformGameDefine.game.GameTypeIDs == "8"){
				rulesPanel.matchType = DDZRegtPanel.eMatchType.person3;
				rgtPanel.matchType = DDZRegtPanel.eMatchType.person3;
				leaderboard.titleLb.text = "斗地主3人赛排名";
				if( PlatformGameDefine.game.GameTypeIDs == "8"){
					rgtPanel.use6personBg();
					leaderboard.titleLb.text = "斗地主6人赛排名";
				}else{
					rgtPanel.useBg3();
				}
			}
//			GameObject rgtPrb = SimpleFramework.Util.LoadAsset("GameDDZ/regtLayer","regtLayer") as GameObject;
//			GameObject rgtObj = NGUITools.AddChild(transform.parent.parent.gameObject, rgtPrb);
//			rgtPanel = rgtObj.GetComponent<DDZRegtPanel>();
		}
		SettingInfo.Instance.autoNext = false;
		SettingInfo.Instance.deposit = false;
		SettingInfo.Instance.bgVolume = 1.0f;
        UIRoot sceneRoot = transform.root.GetComponent<UIRoot>();
        
        if (sceneRoot != null)
        {
            int manualHeight = 800;		// Android

//            sceneRoot.scalingStyle = UIRoot.Scaling.FixedSize;
//            sceneRoot.manualHeight = manualHeight;
        }
		emotionPl.sendEmotID = UserSendEmotion;
		chatPl.sendEmotID = UserChat;

		#if UNITY_STANDALONE && !UNITY_EDITOR
		if(isMatch){
			if(rgtPanel != null){
				rgtPanel.gameObject.SetActive(false);
			}
			resultAnima.hideAnima();
		}
		logo131.SetActive(true);
		#endif
		if(isLiveRoom){
			roundCountLb = transform.Find("Score/roundCount").GetComponent<UILabel>();
			roundCountLb.gameObject.SetActive(true);
			roundCountLb.text = "第"+ liveRoundCount +"局";
			quitTipTxt.SetActive(false);
			quitTipNormalTxt.SetActive(false);
			msgQuit.transform.Find("desLb").gameObject.SetActive(true);
			msgQuit.transform.Find("desLb").GetComponent<UILabel>().text = "玩家强制退出要扣除欢乐豆";
		}else{
			msgQuit.transform.Find("desLb").gameObject.SetActive(false);
		}

		#if PC_RECORD
		if(isLiveRoom){
			UTJ.MP4Recorder mp4Recrod = this.transform.parent.gameObject.AddComponent<UTJ.MP4Recorder>();
			recordBtn = transform.parent.parent.FindChild("infoBtnLayer/recordBtn").gameObject;
			recordDialog = transform.parent.parent.FindChild("infoBtnLayer/MsgContainer/RecordPathDialog").gameObject;
			recordBtn.SetActive(true);

			recordBtn.GetComponent<UIButton>().onClick.Add( new EventDelegate( ()=>{
				if(mp4Recrod.recording){
					recordBtn.transform.GetChild(0).GetComponent<UISprite>().color = new Color(1.0f,1.0f,1.0f,0);
					mp4Recrod.EndRecording();
					CancelInvoke("recordTimeInvoke");
					recordBtn.transform.FindChild("recordTime").GetComponent<UILabel>().text = "";
				}else{
					recordBtn.transform.GetChild(0).GetComponent<UISprite>().color = new Color(1.0f,1.0f,1.0f,1.0f);
					mp4Recrod.BeginRecording();
					recordTime = 0;
					CancelInvoke("recordTimeInvoke");
					InvokeRepeating("recordTimeInvoke",1.0f,1.0f);
					recordBtn.transform.FindChild("recordTime").GetComponent<UILabel>().text = recordTime+"";
				}
			})  );
		}
		#endif
    }

    void Start()
    {
		EginProgressHUD.Instance.HideHUD();
		if(isMatch){
			if(PlatformGameDefine.game.GameTypeIDs == "9"){
				EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
			}
		}
        Mybankerid = "";
        if (SettingInfo.Instance.autoNext == true || SettingInfo.Instance.deposit == true)
        {
			btnGroup.gameStart(false);
        }
        GameObject info = GameObject.Find("Panel_Setting");
        if (info)
        {
            info.GetComponent<GameSettingManager>().setDepositVisible(true);
        }

        base.StartGameSocket();
		precardPl.init();
		DDZCount.Instance.timeUpCallback = timeup;
		toggleAutoAndSeePre(false, false);
		initSettingPanel();
		InvokeRepeating("checkNetwork",5,2);
		if(PlatformGameDefine.game.GameTypeIDs == "9" || PlatformGameDefine.game.GameTypeIDs == "8"){
			DDZSoundMgr.instance.changeBGM(true);
		}else{
			DDZSoundMgr.instance.changeBGM(false);
		}
    }

	#if UNITY_STANDALONE && !UNITY_EDITOR
	private bool isSetup = false;
	private int  switchScreenCount = 0;
	void LateUpdate () {  
		if(Screen.fullScreen){
			if(!isSetup){
				transform.root.GetComponent<UIRoot>().scalingStyle = UIRoot.Scaling.Flexible;
				Screen.SetResolution(Screen.resolutions[Screen.resolutions.Length - 1].width, Screen.resolutions[Screen.resolutions.Length - 1].height, true);
				isSetup = true;
			}
		}else{
			if(isSetup){
				transform.root.GetComponent<UIRoot>().scalingStyle = UIRoot.Scaling.Constrained;
				Screen.SetResolution(1023 + switchScreenCount,708,false);
				switchScreenCount++;
				switchScreenCount = switchScreenCount%2;
				isSetup = false;
			}
		}
	}
	void Update(){
		if(Input.GetMouseButtonDown(1)){
			if( btnGroup.drawBtnHighlight ){
				BtnPlayCard();
			}
		}
	}
	#endif
	protected void OnEnable()
	{
	}
	
	protected void OnDisable()
	{
	}

	void OnDestroy()
	{
//		DDZTip._preCards = null;
		CancelInvoke("heartbeatHandle");
	}

	#region 消息接受
    public override void SocketReceiveMessage(string message)
    {
		
        base.SocketReceiveMessage(message);

        JSONObject messageObj = new JSONObject(message);
        string type = messageObj["type"].str;
        string tag = messageObj["tag"].str;
//		Debug.LogError(Time.time +"-><color=#00ff00>"+message+"</color>");
        if ("game".Equals(type))
        {
            switch (tag)
            {
                case "ready":
                    ProcessReady(messageObj);
                    break;
                case "come":
                    ProcessCome(messageObj);
                    break;
                case "enter":
                    ProcessEnter(messageObj);
                    break;
                case "leave":
                    ProcessLeave(messageObj);
                    break;
                case "deskover":
                    //ProcessDeskOver(messageObj);
                    break;
				case "emotion":
					ProcessEmotion(messageObj);
					break;
				case "hurry":
					ProcessHurry(messageObj);
					break;
				case "manage":
					ProcessManage(messageObj);
				break;
                case "notcontinue":
                    StartCoroutine(ProcessNotcontinue());
                    break;
            }
        }
        else if ("seatmatch".Equals(type))
        {
            switch (tag)
            {
                case "on_update": 
                    ProcessUpdateAllIntomoney(messageObj);
                    break;
				case "newober": 
					if(EginUser.Instance.uid == messageObj["body"].list[0].n+""){
						gameDDZOb = new GameDDZOb(this);
						isObserver = true;						  //{"body": [299016, 337666, 2, 1], "tag": "newober", "type": "seatmatch"}
//						obPos = (int)messageObj["body"].list[2].n;//{'body':(观察者ID,被观战的玩家ID,玩家座位,当前观战者总数)}#观察者ID是自己的ID
						obID  = (int)messageObj["body"].list[1].n;
//						gameSettingBtn.SetActive(false);
						_userIntoMoney.gameObject.SetActive(false);
						_userNickname.gameObject.SetActive(false);
					}
					break;
				default:
					break;
            }
        }

        else if ("ddz".Equals(type))
        {
//            Debug.Log(Time.time +"-->"+messageObj);
            switch (tag)
            {
                case "call":
					StartCoroutine( ProcessCall(messageObj) );
                    break;
                case "time":
                    int t = (int)messageObj["body"].n;
                    NNCount.Instance.UpdateHUD(t);
                    break;
                case "late":
                    break;
                case "deal":
					StopCoroutine("ProcessDeal");
                    StartCoroutine(ProcessDeal(messageObj));
                    break;
                case "startraise":
                    Processstartraise(messageObj);
                    break;
                case "raise":
                    ProcessRaise(messageObj);
                    break;
                case "show":
                    ProcessShow(messageObj);
                    break;
				case "showcard":
					ProcessShowDeck(messageObj);
					break;
				case "showcard_2":
					ProcessLimitTimeShowDeck(messageObj);
					break;
				case "allcards":
					ProcessAllDeck(messageObj);
					break;
                case "pass":
                    ProcessPass(messageObj);
                    break;
                case "play":
                    ProcessPlay(messageObj);
                    break;
				//DDZBS message
				case "startplay":
					ProcessStartPlay(messageObj);
					break;
                case "gameover":
                    StartCoroutine( ProcessGameover(messageObj) );
                    break;
                case "ok":
					Debug.LogError("=============");
					Debug.LogError("  ProcessOk");
					Debug.LogError("=============");
					break;
                case "end":
                    break;
                case "update":
					StartCoroutine( ProcessUpdate(messageObj) );
                    break;
				case "online":
					ProcessOnline(messageObj);
					break;
                case "cards_fail":
                    Processcardsfail(messageObj);
                    break;
				case "click_down":
					ProcessObUserSelectCard(messageObj);
					break;
				case "click_up":
					ProcessObUserCancelSelected(messageObj);
					break;
            }
		}
		else if ("ddz7".Equals(type))//DDZBS message
		{
			switch (tag)
			{
			case"apply":
				ProcessApply(messageObj);
				break;
			case "newcn":
				ProcessPersonChange(messageObj);
				break;
			case "recheckin":
				ProcessReChecking(messageObj);
				break;
			case"kick":
				ProcessKick(messageObj);
				break;
			case "newranks":
				ProcessNewRank(messageObj);
				break;
			case "deskover":
				ProcessDeskOver(messageObj);
				break;
			case "sendaward":
				ProcessShowAward(messageObj);
				break;
			case "unitgrow_start":
				ProcessUnitGrowStart(messageObj);
				break;
			case "unitgrowtip":
				ProcessGrowUpTip(messageObj);
				break;
			case "wantrebuy":
				ProcessRelive(messageObj);
				break;
			case "wait_over":
				StartCoroutine( ProcessWaitOver(messageObj) );
				break;
			case "cantrebuy":
				ProcessReliveTimeup(messageObj);
				break;
			case "ready_fail":
				//happy131
				ddz131.ProcessReadyFail();
				break;
			}
		}
		else if ("ddz9".Equals(type))//DDZBS message
		{
			switch (tag)
			{
			case"apply":
				ProcessApply(messageObj);
				break;
			case "newcn":
				ProcessPersonChange(messageObj);
				break;
			case "recheckin":
				ProcessReChecking(messageObj);
				break;
			case"kick":
				ProcessKick(messageObj);
				break;
			case "newranks":
				ProcessNewRank(messageObj);
				break;
			case "roundover":
				ProcessRoundover(messageObj);
				break;
			}
		}
        else if ("seatmatch".Equals(type))
        {
            switch (tag)
            {
                case "on_update":
                    ProcessUpdateAllIntomoney(messageObj);
                    break;
            }
        }
        else if ("niuniu".Equals(type))
        {
            switch (tag)
            {
                case "pool":
                    if (PlatformGameDefine.playform.IsPool)
                    {
                        GameObject info = GameObject.Find("initJC");

                        string chiFen = messageObj["body"]["money"].ToString();
                        List<JSONObject> infos = messageObj["body"]["msg"].list;
                        if (null != info)
                        {
                            //if(!info.activeSelf)info.SetActive (true);
                            info.GetComponent<PoolInfo>().show(chiFen, infos);
                        }
                    }
                    //新增奖池消息：
                    //{'type': 'niuniu', 'tag': 'pool', 'body': {'money': 当前奖池金额, 'msg': *pm_msg}}
                    //*pm_msg:[[昵称,累计积分],]

                    //jchi.show(body.money,body.msg);
                    break;
                case "mypool":
                    if (PlatformGameDefine.playform.IsPool)
                    {
                        string chiFen = messageObj["body"].ToString();
                        GameObject info = GameObject.Find("initJC");

                        if (null != info)
                        {
                            //if(!info.activeSelf)info.SetActive (true);
                            info.GetComponent<PoolInfo>().setMyPool(chiFen);
                        }

                    }
                    //	更新自己的累计积分：
                    //{'type': 'niuniu', 'tag': 'mypool', 'body': 自己的累计积分}
                    //jchi.setJifei(body as Number);
                    break;
                case "mylott":
                    //	通知玩家获得名次奖励：
                    //{'type': 'niuniu', 'tag': 'mylott', 'body': msg}
                    //	msg：恭喜您获得牛牛奖池第%s名，共获得%s乐币！
                    string msg = messageObj["body"]["msg"] != null ? messageObj["body"]["msg"].str : messageObj["body"].str;
                    //openAlert(msg,"消息提示",null,null,true,2);
                    if (PlatformGameDefine.playform.IsPool)
                    {
                        GameObject info = GameObject.Find("initJC");

                        if (null != info)
                        {
                            //if(!info.activeSelf)info.SetActive (true);
                            info.GetComponent<PoolInfo>().setMyPool(msg);
                        }
                    }
                    break;
            }
		}

    }
	#endregion

	private void ProcessEmotion(JSONObject messageObj) { 
		JSONObject body = messageObj["body"];
		int id = System.Convert.ToInt32(body[0].n);
		int number = System.Convert.ToInt32(body[1].n);
		Debug.LogError("Emotion: "+number +"___from__"+ id);
		if(userPlayerObj.name != _nnPlayerName+id){
			emotionPl.playEmotAt(number, getPlayerWithID(id).avatarIcon.gameObject);
		}
//		GameObject player = GameObject.Find(_nnPlayerName + id);
//		player.GetComponent<DZPKPlayerCtrl>().setEmotion(number);
	}
	private void ProcessHurry(JSONObject messageObj)
	{
//		Debug.Log(messageObj.ToString());
		JSONObject body = messageObj["body"];
		int talkID = (int)body["spokesman"].n;
		int index = (int)body["index"].n;
		Debug.LogError("Chat: "+index +"___from__"+ talkID);
		if(userPlayerObj.name != _nnPlayerName+talkID){
			getPlayerWithID(talkID).showChatBubble(index);
		}
	}
	
	public void Processcardsfail(JSONObject messageObj) { 
        //{'type': 'ddz', 'tag': 'cards_fail','body':1} #牌型不对
        //{'type': 'ddz', 'tag': 'cards_fail','body':2} #牌型小于上个的牌

        int failnumber = (int)messageObj["body"].n;
        DDZPlayerCtrl ctrl = userPlayerObj.GetComponent<DDZPlayerCtrl>();
        StartCoroutine(ctrl.CardsFail(failnumber));
		beginplay = true;
		btnGroup.playCard(true);
        
    }
	public void ProcessObUserSelectCard(JSONObject messageObj) { 
		//{"body": [299019, [43, 30]], "tag": "click_down", "type": "ddz"}
		if(isObserver){
			DDZPlayerCtrl playerDoc = getPlayerWithID((int)messageObj["body"].list[0].n);
			if(playerDoc != null){
				playerDoc.changeDeckColor(messageObj["body"].list[1].list);
			}
		}
	}
	public void ProcessObUserCancelSelected(JSONObject messageObj) {
		//{"body": [299019, [43, 30]], "tag": "click_up", "type": "ddz"}
		if(isObserver){
			DDZPlayerCtrl playerDoc = getPlayerWithID((int)messageObj["body"].list[0].n);
			if(playerDoc != null){
				playerDoc.changeDeckColor(new JSONObject("[99]").list);//所有牌都取消选择
			}
		}
	}

	public void BtnNotCallHandle()
	{
		UserCall(0);
	}
	public void BtnCallScore1()
	{
		UserCall(1);
	}
	public void BtnCallScore2()
	{
		UserCall(2);
	}
	public void BtnCallScore3()
	{
		UserCall(3);
	}

	public void BtnLimitShowDeck()
	{
		JSONObject startJson = new JSONObject();
		startJson.AddField("type", "ddz");
		startJson.AddField("tag", "showcard_2");
		startJson.AddField("body", btnGroup.getCurCount());
		base.SendPackageWithJson(startJson);
		btnGroup.stopCountDown();
		DDZSoundMgr.instance.playRandEftDc("openCard", userPlayerCtrl.isFemale);
	}

	public void BtnPass()
	{
		UserPass();
//		DDZTip._preCards = null;
		beginplay = false;
		btnGroup.hideAll();
		userPlayerCtrl.clearSelectedCards();
		sendSelectCardMsg(null);
	}

	public void BtnTip()
	{
		if(prePlayer == null){
			Debug.LogError("Error: dont need tips");
//			userPlayerCtrl.tip(true);
		}else{
			if(prePlayer == userPlayerCtrl){
				Debug.LogError("Error: dont need tips. My first.");
//				userPlayerCtrl.tip(true);
			}else{
				userPlayerCtrl.flashTip(prePlayer.deskcardCtrl.cardsData);
//				userPlayerCtrl.tip(false, prePlayer.deskcardCtrl.cardsData, prePlayer.deskcardCtrl.cardType);
			}
		}
	}

	public void dragToSelTip(List<GameObject> selC)
	{
		if( !userPlayerCtrl.selTip(selC, false, null, 5) ){
			userPlayerCtrl.selTip(selC, false, null, 6);
		}
//		if(prePlayer == null){
//			userPlayerCtrl.selTip(selC, true);
//		}else{
//			if(prePlayer == userPlayerCtrl){
//				userPlayerCtrl.selTip(selC, true);
//			}else{
//				userPlayerCtrl.selTip(selC, false, prePlayer.deskcardCtrl.cardsData, prePlayer.deskcardCtrl.cardType);
//			}
//		}
	}

	public void BtnPlayCard()
	{
		if(!hasNetwork()){
			networkTip.SetActive(true);
			Invoke("invokeNetworkTipHide",2.0f);
			return;
		}
		userPlayerCtrl.calcSelCards();
		if(userPlayerCtrl.selCard.Count > 0){
			UserPlay(userPlayerCtrl.selCard);
			int cardtype = userPlayerCtrl.drawCard(prePlayer,true);
			beginplay = false;
			btnGroup.hideAll();
			vfxMgr.cardTypeAnima(cardtype, userPlayerCtrl);
			//lxtd003 2016.11.11 added. for network lag  optimization.
			//disable this logic 2016.11.11.  (game designer dont need any danger modified.
//			for(int i=0; i<_playingPlayerList.Count; i++){
//				if(_playingPlayerList[i].transform.position.x> 0){
//					DDZCount.Instance.moveTo(_playingPlayerList[i].GetComponent<DDZPlayerCtrl>());
//					break;
//				}
//			}
		}

	}
	private void invokeNetworkTipHide()
	{
		if(hasNetwork()){
			networkTip.SetActive(false);
		}
	}
    //叫地主
    public void UserCall(int iscall)
    {

        JSONObject ok = new JSONObject();
        ok.AddField("type", "ddz");
        ok.AddField("tag", "call");
        ok.AddField("body", iscall);
        base.SendPackageWithJson(ok);
//		Debug.LogError("DDZ call number:"+iscall);
		btnGroup.hideAll();
    }
    public string Mybankerid;
	IEnumerator ProcessCall(JSONObject messageObj) {
        /*
         * 
         * 
         * 
{
'type': 'ddz', 'tag': 'call', 
'body': {
    'thisone': 100244,
    'callpt':callpt, #当前叫分0/1
    'call_times':self.call_times, #叫的次数
    'double':self.double, #当前总倍数
    'banker':self.banker.uid, #新庄家
    'nextone':nextone.uid, #下一个该谁, 下一个如果跟当前人一样就表示抢地主结束
    'timeout':CALL_TIMEOUT
    }
}
         */
        JSONObject body = messageObj["body"];
        int thisone = (int)body["thisone"].n;
        int nextone = (int)body["nextone"].n;
        int timeout = (int)body["timeout"].n;
		int callPt  = (int)body["callpt"].n;
		int callTimes = (int)body["call_times"].n;
		int mydouble = (int)body["double"].n;
		
        DDZCount.Instance.UpdateHUD(timeout, 1);
		DDZCount.Instance.moveTo(getPlayerWithID(nextone), isObserver);
		if(nextone == thisone){
			DDZCount.Instance.DestroyHUD();
		}

		DDZPlayerCtrl playerCtrl = getPlayerWithID(thisone);
		if(callPt == 0){
			if(isMatch){
				playerCtrl.showActBubble(DDZPlayerCtrl.eActType.nocall);
				DDZSoundMgr.instance.playRandEftDc("bujiao",playerCtrl.isFemale);
				noCallCount++;
				if(noCallCount == 3){
					resultAnima.waitTip("tipRedraw");
				}
			}else{
				if(hasCall){
					playerCtrl.showActBubble(DDZPlayerCtrl.eActType.noloot);
					DDZSoundMgr.instance.playRandEftDc("buqiang",playerCtrl.isFemale);
				}else{
					playerCtrl.showActBubble(DDZPlayerCtrl.eActType.nocall);
					DDZSoundMgr.instance.playRandEftDc("bujiao",playerCtrl.isFemale);
				}
			}
		}else{
			userPlayerCtrl.Setcalldouble(mydouble);
			if(isMatch){
				if(callPt == 1){
					playerCtrl.showActBubble(DDZPlayerCtrl.eActType.score1);
					DDZSoundMgr.instance.playRandEftDc("score1",playerCtrl.isFemale);
				}else if(callPt == 2){
					playerCtrl.showActBubble(DDZPlayerCtrl.eActType.score2);
					DDZSoundMgr.instance.playRandEftDc("score2",playerCtrl.isFemale);
				}else if(callPt == 3){
					playerCtrl.showActBubble(DDZPlayerCtrl.eActType.score3);
					DDZSoundMgr.instance.playRandEftDc("score3",playerCtrl.isFemale);
				}
			}else{
				if(hasCall){
					playerCtrl.showActBubble(DDZPlayerCtrl.eActType.loot);
					DDZSoundMgr.instance.playRandEftDc("qiangdizhu",playerCtrl.isFemale);
					playerCtrl.playCoinAnima(2);
				}else{
					playerCtrl.showActBubble(DDZPlayerCtrl.eActType.call);
					DDZSoundMgr.instance.playRandEftDc("jiaodizhu",playerCtrl.isFemale);
				}
			}
			hasCall = true;
		}

        if (thisone != nextone && _nnPlayerName + nextone == userPlayerObj.name)
        {
			if(!userPlayerCtrl.isDealCardCom){
				yield return new WaitForSeconds(4.7f);
			}else{
//				yield return new WaitForSeconds(0.5f);
			}
            DDZPlayerCtrl ctrl = userPlayerObj.GetComponent<DDZPlayerCtrl>();
			if(isLiveRoom){
				if(userPlayerCtrl.avatarIcon.atlas.GetSprite("DDZ_s_default") != null){
					yield break;
				}
			}
			if(isMatch){
				btnGroup.callMaster(true, true, true);
			}else{
				if(hasCall){
					btnGroup.callMaster(true, false, true);
				}else{
					btnGroup.callMaster(true, false, false);
				}
			}
        }

    }

    //开始加倍
    void Processstartraise(JSONObject messageObj) {
        /*
         * 
         * 
{
'type': 'ddz', 'tag': 'startraise',
'body': {
    'hide_cards': [3,4,5], #给地主三张补牌
    'double':self.double,  #当前倍数
    'banker':self.banker.id, #地主
    'thisone':self.this.id, #该谁
    'timeout':RAISE_TIMEOUT
    }
}
         * 
         * 
         */
        JSONObject body = messageObj["body"];
        List<JSONObject> thishide_cards = body["hide_cards"].list;
        int callpt = (int)body["double"].n;

        int banker = (int)body["banker"].n;
        int thisone = (int)body["thisone"].n;
		int timeout = isObserver?10:(int)body["timeout"].n;
        DDZCount.Instance.UpdateHUD(timeout, 1);
		DDZCount.Instance.moveTo( getPlayerWithID(thisone) , isObserver);
//		if(isLiveRoom){
//			roundCountLb.text = "第"+ liveRoundCount +"局";
//			liveRoundCount++;
//		}
        foreach (GameObject player in _playingPlayerList)
        {
            if (player != null)
            {
                DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
                
				if(_nnPlayerName + banker == player.name){
					ctrl.changeToBanker(isLiveRoom);
					ctrl.updateCardCount(20);
					ctrl.Addbankercards(thishide_cards);
				}else{
					ctrl.changeToSlave(isLiveRoom);
				}

                if (player == userPlayerObj)
                {
                    if (_nnPlayerName + banker == userPlayerObj.name)
                    {
                        Mybankerid = banker + "";
//                        ctrl.Addbankercards(thishide_cards);
                    }
                   
                    if (_nnPlayerName + thisone == userPlayerObj.name)
                    {
						if(isLiveRoom){//现场版强制加倍和不加倍
							if(liveRoundCount<=8){
								UserRaise(false);
							}else{
								UserRaise(true);
							}
						}else{
							btnGroup.increaseMultiple(true);
						}
                    }
                    ctrl.Setcalldouble(callpt);
                    ctrl.showbankercard(thishide_cards);
                }
            }
        }

    }

	public void UserConfirmRaise()
	{
		UserRaise(true);
		btnGroup.hideAll();
	}
	public void UserCancelRaise()
	{
		UserRaise(false);
		btnGroup.hideAll();
	}

    //向服务器发送消息（加倍）
    public void UserRaise(bool raise)
    {
        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "ddz");
        startJson.AddField("tag", "raise");
        startJson.AddField("body", raise?1:0);
        base.SendPackageWithJson(startJson);

        EginTools.PlayEffect(soundStart);

		btnGroup.gameStart(false);
    }
    private bool _beginplay = false;
	public bool beginplay{
		set{
			_beginplay = value;
			if(_beginplay){
				userPlayerCtrl.deskcardCtrl.hideCurCards();
//				seePreCardBtn.enabled = true;
//				seePreCardBtn.GetComponent<UISprite>().color = new Color(1.0f,1.0f,1.0f);
			}else{
//				seePreCardBtn.enabled = false;
//				seePreCardBtn.GetComponent<UISprite>().color = new Color(0.6f,0.6f,0.6f);
			}
		}
		get{
			return _beginplay;
		}
	}
    void ProcessRaise(JSONObject messageObj)
    {
        /*
         * 
         * 
         * 
    {
    'type': 'ddz', 'tag': 'raise',
    'body': {
        'israise': 0或1, #是否假倍 
        'double': 8, #当前倍数
        'thisone':100244, 
        'nextone':100459, #下一个如果和这一个一样就表示加倍结束, 直接开始出牌阶段
        'timeout':RAISE_TIMEOUT  #加倍结束后timeout变成等出牌的时间
        }
    }
            */
        JSONObject body = messageObj["body"];
        int thisone = (int)body["thisone"].n;
        int nextone = (int)body["nextone"].n;
		int calldouble = 2;
		if(isObserver){
			calldouble = (int)body["doubles"].list[0]["double"].n;
		}else{
			calldouble = (int)body["double"].n;
		}
        int timeout = (int)body["timeout"].n;
		int isRaise = (int)body["israise"].n;
        DDZCount.Instance.UpdateHUD(timeout, 1);
		DDZCount.Instance.moveTo(getPlayerWithID(nextone), isObserver);
		if(thisone == nextone && _nnPlayerName + Mybankerid != userPlayerObj.name){
			DDZCount.Instance.DestroyHUD();
		}
		DDZPlayerCtrl ctrl = userPlayerObj.GetComponent<DDZPlayerCtrl>();

		if(isRaise == 1){
			getPlayerWithID(thisone).showActBubble(DDZPlayerCtrl.eActType.multiple);
//			getPlayerWithID(thisone).playCoinAnima(calldouble);
			getPlayerWithID(thisone).playCoinAnima(2);
			ctrl.Setcalldouble(calldouble);
			DDZSoundMgr.instance.playRandEftDc("jiabei",getPlayerWithID(thisone).isFemale);
		}else{
			getPlayerWithID(thisone).showActBubble(DDZPlayerCtrl.eActType.nomul);
			DDZSoundMgr.instance.playRandEftDc("bujiabei",getPlayerWithID(thisone).isFemale);
		}

        
        if (thisone != nextone && _nnPlayerName + nextone == userPlayerObj.name)
        {
            ctrl.Setcalldouble(calldouble);
			Debug.LogError("nextone is me:"+ calldouble);
			if(isLiveRoom){//现场版强制加倍和不加倍
				if(liveRoundCount<=8){
					UserRaise(false);
				}else{
					UserRaise(true);
				}
			}else{
				btnGroup.increaseMultiple(true);
			}
        }

        foreach (GameObject player in _playingPlayerList)
        {
			if (player == userPlayerObj)
			{
				if (thisone == nextone)
				{
					if (_nnPlayerName + thisone == userPlayerObj.name)
					{
						ctrl.Setcalldouble(calldouble);
						Debug.LogError("thisone is me:"+ calldouble);
						beginplay = true;
					}
				}
			}
        }

		if(thisone == nextone){
			isInBattle = true;
		}

        if (thisone == nextone && _nnPlayerName + Mybankerid == userPlayerObj.name)
        {
            ctrl.Setcalldouble(calldouble);
			DDZCount.Instance.moveTo(userPlayerCtrl, isObserver);
			Debug.LogError("thisone & nextone all of me:"+ calldouble);
            beginplay = true;
			btnGroup.playCard(true);
			btnGroup.enablePassBtn(false);
			btnGroup.enableTip(false);
			userPlayerCtrl.selCardHandle();
			toggleAutoAndSeePre(true, false);
//			btnGroup.enableDrawBtn(false);
        }


    }

	private void ProcessStartPlay(JSONObject messageObj){
		//{"body": {"hide_cards": [42, 52, 48], "banker": 866627728, "timeout": 20}, "tag": "startplay", "type": "ddz"}
		JSONObject body = messageObj["body"];
		int bankerID = (int)body["banker"].n;
		int timeout = (int)body["timeout"].n;
		List<JSONObject> thishide_cards = body["hide_cards"].list;
		DDZCount.Instance.UpdateHUD(timeout, 1);
		DDZCount.Instance.moveTo(getPlayerWithID(bankerID), isObserver);
		beginplay = true;
		isInBattle = true;
		foreach (GameObject player in _playingPlayerList)
		{
			if (player != null)
			{
				DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
				
				if(_nnPlayerName + bankerID == player.name){
					ctrl.changeToBanker(isLiveRoom);
					ctrl.updateCardCount(20);
					ctrl.Addbankercards(thishide_cards);
				}else{
					ctrl.changeToSlave(isLiveRoom);
				}
				
				if (player == userPlayerObj)
				{
					if (_nnPlayerName + bankerID == userPlayerObj.name)
					{
						Mybankerid = bankerID + "";
						if(PlatformGameDefine.game.GameTypeIDs == "8" || PlatformGameDefine.game.GameTypeIDs == "9"){
							StartCoroutine(delayShowPlayBtn131());
						}else{
							btnGroup.playCard(true);
						}
						btnGroup.enablePassBtn(false);
						btnGroup.enableTip(false);
						userPlayerCtrl.selCardHandle();
					}
					toggleAutoAndSeePre(true, false);
					ctrl.showbankercard(thishide_cards);
					if(is131Happy){
						ddz131.dialog.showRoundStartDialog();
					}
				}
			}
		}
	}

	//131比赛可以出牌时立马出牌又bug,服务器会忽略消息.  gametype=8 or 9
	private IEnumerator delayShowPlayBtn131()
	{
		yield return new WaitForSeconds(3.0f);
		btnGroup.playCard(true);
	}

    // 明牌
    public void UserShow()
    {
		//Only banker allow to show deck.
        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "ddz");
        startJson.AddField("tag", "show");
        base.SendPackageWithJson(startJson);

//        EginTools.PlayEffect(soundStart);
		
		btnGroup.hideAll();
    }
	public void UserNoShow()
	{
		btnGroup.hideAll();
	}
    void ProcessShow(JSONObject messageObj)
    {
        /*
         * 
         * 
         * 
        'type': 'ddz', 'tag': 'show', 
        'body': {
            'banker_cards': [1,2,3,4,5,..], #地主牌
            'double': player.double * self.double #当前倍数
            }
         */
		//{"body":{"double":2,"banker_cards":[0,13,26,14,40,2,15,28,16,30,44,6,19,45,7,8,48,49,24,53]},"tag":"show","type":"ddz"}
        JSONObject body = messageObj["body"];
//        int timeout = (int)body["timeout"].n;
//        DDZCount.Instance.UpdateHUD(timeout);
        int mydouble = (int)body["double"].n;
        List<JSONObject> bankercardsList = body["banker_cards"].list;
        DDZPlayerCtrl ctrl = userPlayerObj.GetComponent<DDZPlayerCtrl>();
		ctrl.Setcalldouble(mydouble);
//		for(int i=0; i<_playingPlayerList.Count; i++){
//			if(_playingPlayerList[i].GetComponent<DDZPlayerCtrl>().isBanker){
//				_playingPlayerList[i].GetComponent<DDZPlayerCtrl>().showDeck(bankercardsList);
//				break;
//			}
//		}
    }
	private void ProcessShowDeck(JSONObject messageObj)
	{
		//Myself show deck
		//2.24. PM5:27-->{"body":[5,866627727,5,[null]],"tag":"showcard","type":"ddz"}
		//2.24. PM9:17-->{"body":[4,866627727,[13,2,15,28,16,29,42,4,31,44,6,20,34,22,35,11,51]],"tag":"showcard","type":"ddz"}
		// showcard的body属性：(当前总公共倍数，UID，该玩家明牌的倍数，牌值)
		int multipleNum = (int)messageObj["body"].list[0].n;
		int uid         = (int)messageObj["body"].list[1].n;
		int playerMul   = (int)messageObj["body"].list[2].n;
		Debug.Log("public multipe:"+ multipleNum +" player:"+ uid+" ||mul:"+playerMul);
		if(messageObj["body"].list.Count == 4){
			if(isObserver){
				getPlayerWithID(uid).isShowDeck = true;
			}else{
				if(messageObj["body"].list[3].list.Count> 1){
					StartCoroutine( getPlayerWithID(uid).showDeck(messageObj["body"].list[3].list) );
				}
			}
			getPlayerWithID(uid).playCoinAnima(playerMul);
		}else{
			//Sure be not enter this if server used same json.
			getPlayerWithID(uid).playCoinAnima(multipleNum);
			if(isObserver){
				getPlayerWithID(uid).isShowDeck = true;
			}else{
				if(messageObj["body"].list[2].list.Count> 1){
					StartCoroutine( getPlayerWithID(uid).showDeck(messageObj["body"].list[2].list) );
				}
			}
		}
		userPlayerCtrl.Setcalldouble(multipleNum);

//		userPlayerCtrl.showDeck();
	}
	private void ProcessLimitTimeShowDeck(JSONObject messageObj)
	{
		//{"body":[true,4,[[121810,false,[null]],[866627727,false,[null]],[111161,false,[null]]]],"tag":"showcard_2","type":"ddz"}
		List<JSONObject> body = messageObj["body"].list;
		bool needShowDeck = body[0].b;
		if(needShowDeck){
			StartCoroutine( btnGroup.clearCountDown() );
		}
		List<JSONObject> deckList = body[2].list;
		for(int i=0; i< deckList.Count; i++){
			List<JSONObject> content = deckList[i].list;
			int uid = (int)content[0].n;
			bool isShowDeck = content[1].b;
			if(isShowDeck){
				if(content[2].list.Count > 1){
					DDZPlayerCtrl playC = getPlayerWithID(uid);
					if(isObserver){
						playC.isShowDeck = true;
					}else{
						StartCoroutine( playC.showDeck(content[2].list) );
					}
//					if(playC != userPlayerCtrl){
//						playC.playCoinAnima(multipleNum);
//					}
				}
			}
		}
	}
	private void ProcessAllDeck(JSONObject messageObj)
	{
		//{"body":[[111115,false,1,[null]],[125524,false,1,[null]],[866627793,true,1,[26,2,41,3,43,45,33,8,9,35,48,10,23,36,49,12,51]]],"tag":"allcards","type":"ddz"}

		/*List<JSONObject> body = messageObj["body"].list;
		for(int i=0; i< body.Count; i++){
			List<JSONObject> content = body[i].list;
			int uid = (int)content[0].n;
			bool isShowDeck = content[1].b;
			int multipleNum = (int)content[2].n;
			if(isShowDeck){
				if(content[3].list.Count > 1){
					DDZPlayerCtrl playC = getPlayerWithID(uid);
					playC.showDeck(content[3].list);
					if(playC != userPlayerCtrl){
						playC.playCoinAnima(multipleNum);
					}
				}
			}
		}*/
	}
    
    //过
    public void UserPass() {
        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "ddz");
        startJson.AddField("tag", "pass");
        base.SendPackageWithJson(startJson);

        EginTools.PlayEffect(soundStart);
		
		btnGroup.gameStart(false);
    }
    void ProcessPass(JSONObject messageObj) {
        /*{
    'type': 'ddz', 'tag': 'pass',
    'body': {
        'thisone':this.id,
        'nextone':next.id,
        'mycards': [1,2,3,5,..], #自己剩余的牌
        'timeout':DEAL_TIMEOUT
        }
    }

         */
		passCount++;
        JSONObject body = messageObj["body"];
        int nextone = (int)body["nextone"].n;
		int thisone = (int)body["thisone"].n;
        int timeout = (int)body["timeout"].n;
        DDZCount.Instance.UpdateHUD(timeout,1);
		DDZCount.Instance.moveTo(getPlayerWithID(nextone), isObserver);
		DDZPlayerCtrl playerCtrl = getPlayerWithID(thisone);
		playerCtrl.showActBubble(DDZPlayerCtrl.eActType.pass);
		playerCtrl.deskcardCtrl.pass();
		DDZSoundMgr.instance.playRandEftDc("pass", playerCtrl.isFemale);

		if(getPlayerWithID(thisone) == roundLeader){
//			for(int i=0; i<_playingPlayerList.Count; i++){
//				DDZPlayerCtrl playCtrl = _playingPlayerList[i].GetComponent<DDZPlayerCtrl>();
//				if(playCtrl != roundLeader){
//					playCtrl.deskcardCtrl.roundEnd();
//				}
//			}
			toggleAutoAndSeePre(true, true);
		}


		bool isMyDeal = false;
		if(passCount == 2){
			isMyDeal = true;
			roundLeader = getPlayerWithID(nextone);
			passCount = 0;

		}
		if(!isObserver){
			if (body["mycards"].str != null)
			{
				DDZPlayerCtrl ctrl = userPlayerObj.GetComponent<DDZPlayerCtrl>();
				List<JSONObject> mycardsList = body["mycards"].list;
				ctrl.UpdateUserCard(mycardsList);
			}
		}
		if (_nnPlayerName + nextone == userPlayerObj.name)
        {
            beginplay = true;
//			DDZTip._preCards = null;
			if(isMyDeal){
				btnGroup.enablePassBtn(false);
				btnGroup.enableTip(false);
			}else{
				btnGroup.enablePassBtn(true);
				btnGroup.enableTip(true);
			}
//			btnGroup.enableDrawBtn(false);
			userPlayerCtrl.selCardHandle();
			if(prePlayer != null && prePlayer != userPlayerCtrl){
				if(userPlayerCtrl.checkCanHandle(true, prePlayer.deskcardCtrl.cardsData)){
//				if(userPlayerCtrl.checkCanHandle( prePlayer.deskcardCtrl.cardsData, prePlayer.deskcardCtrl.cardType, false)){
					btnGroup.playCard(true);
				}else{
					btnGroup.playCard(true, false);
				}
			}else{
				btnGroup.playCard(true);
			}
        }
		if(_nnPlayerName + thisone == userPlayerObj.name)
		{
			btnGroup.hideAll();
			userPlayerCtrl.cantHandleTag.SetActive(false);
			userPlayerCtrl.clearTipData();
		}

		//2016.11.29 added
		if(thisone+"" == EginUser.Instance.uid){
			List<JSONObject> serverMyCard = body["mycards"].list;
			userPlayerCtrl.matchServerCardToLocal(serverMyCard);
		}
		if(is131Happy){
			if(btnGroup.isManaged){
				if(!cancelAutoBtn.activeSelf){
					cancelAutoBtn.SetActive(true);
					userPlayerCtrl.autoDrawState();
				}
			}
		}

    }
    
    //出
    public void UserPlay(List<int> cards)
    {
        JSONObject[] cardsjson = new JSONObject[cards.Count];

        for (int i = 0; i <cards.Count; i++)
        {
            cardsjson[i] = new JSONObject(cards[i]);
        }

        //{'type':'ddz', 'tag':'play', 'body':[2,3,4,5,6,7]}
        JSONObject newjson = new JSONObject(cardsjson);
        
        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "ddz");
        startJson.AddField("tag", "play");
        startJson.AddField("body", newjson);
        base.SendPackageWithJson(startJson);
		
		btnGroup.gameStart(false);
    }

	#region 131现场版玩家选牌消息
	public void sendSelectCardMsg(JSONObject jsonObj)
	{
		if(isLiveRoom){
			if(isInBattle){
				JSONObject startJson = new JSONObject();
				startJson.AddField("type", "ddz");
				if(jsonObj != null){
					Debug.LogError("drag select: <color=#ff9900>"+jsonObj.ToString()+"</color>");
					startJson.AddField("tag", "click_down");
					startJson.AddField("body", jsonObj);
					base.SendPackageWithJson(startJson);
					//{'type':'ddz', 'tag':'click_down', 'body':[2,3,7...]}
				}else{
					startJson.AddField("tag", "click_up");
					startJson.AddField("body", new JSONObject("[0]"));//取消所有牌，所有 id随便填
					base.SendPackageWithJson(startJson);
				}
			}
		}
	}
	#endregion
    void ProcessPlay(JSONObject messageObj) { 
        /*
    {
'type': 'ddz', 'tag': 'play', 
'body': {
	'put_cards':[8,7,5,3,2], #出的牌
	'put_type':put_type,     #出的牌型
	'hold_num':len(this.cards),  #剩余牌数, 剩0张牌表示结束了, 立即清除闹钟
	'mycards': [1,2,3,5,..], #自己剩余的牌
	'thisone':this.id,
	'double': 16,	#倍数
	'nextone':next.id,
	'timeout':DEAL_TIMEOUT
	}
}
        */
        JSONObject body = messageObj["body"];
        int cardstype = (int)body["put_type"].n;
        List<JSONObject> deskcards = body["put_cards"].list;
        int nextone = (int)body["nextone"].n;
        int timeout = (int)body["timeout"].n;
		int thisone = (int)body["thisone"].n;
        DDZCount.Instance.UpdateHUD(timeout,1);
		DDZCount.Instance.moveTo(getPlayerWithID(nextone), isObserver);

		GameObject curDrawPlayer = GameObject.Find(_nnPlayerName + thisone);
		DDZPlayerCtrl ctrl = curDrawPlayer.GetComponent<DDZPlayerCtrl>();
        //单张0，对子1，三张2，三带单3，三带对4，单顺5，双顺6，飞机7，飞机带单8，飞机带双9，四带两单10，炸弹12，火箭13
        
		if(getPlayerWithID(thisone) == roundLeader){
//			for(int i=0; i<_playingPlayerList.Count; i++){
//				DDZPlayerCtrl playCtrl = _playingPlayerList[i].GetComponent<DDZPlayerCtrl>();
//				if(playCtrl != roundLeader){
//					playCtrl.deskcardCtrl.roundEnd();
//				}
//			}
			toggleAutoAndSeePre(true, true);
		}

		if(isMatch && rgtPanel.matchType != DDZRegtPanel.eMatchType.person3){
			if(userPlayerCtrl.bankercards[2] != null){
				if(userPlayerCtrl.bankercards[2].gameObject.activeSelf){
					if(!is131Happy)userPlayerCtrl.hideNormalBankerCards();
				}
			}
		}

		if(roundLeader == null){
			roundLeader = ctrl;
		}

		if( prePlayer != null && prePlayer != ctrl){
			ctrl.playAvatarAnima("handle");
			if(cardstype == 3 || cardstype == 4 || cardstype == 5 || cardstype == 6){
				DDZSoundMgr.instance.playRandEftDc("handleYou", ctrl.isFemale);
			}
		}
		
		prePlayer = ctrl;
//		DDZTip._preCards = null;
		userPlayerCtrl.checkSpecialCardType(cardstype);
		if(thisone+"" == EginUser.Instance.uid || thisone == obID){
			userPlayerCtrl.clearTipData();
		}
		if(isObserver){
			if(thisone == obID){
				ctrl.Updatedeskcards(deskcards,cardstype);
				ctrl.UpdateUserCard(deskcards);
				ctrl.updateCardCount((int)body["hold_num"].n);
			}
		}
		if( (thisone+"" != EginUser.Instance.uid && thisone != obID) || btnGroup.isManaged){
			ctrl.updateCardCount((int)body["hold_num"].n);
			ctrl.Updatedeskcards(deskcards,cardstype);
			ctrl.drawCountPlus();
			
			if (body["hold_num"].n > 0)
			{
				if(!isObserver){
					JSONObject[] mystr;
					mystr = body["mycards"].list.ToArray();
				}
	            
				ctrl.UpdateUserCard(deskcards);
//				Debug.LogError("user:--->"+ body["put_cards"].ToString());
			}else{
				ctrl.Clearcards();
				if(ctrl == userPlayerCtrl){
					ctrl.clearDeckTag.SetActive(false);
				}
			}
			vfxMgr.cardTypeAnima(cardstype, ctrl);
		}

        if (_nnPlayerName + nextone == userPlayerObj.name)
        {
			if (body["hold_num"].n > 0){
				beginplay = true;
				btnGroup.enablePassBtn(true);
				btnGroup.enableTip(true);
				//			btnGroup.enableDrawBtn(false);
				userPlayerCtrl.selCardHandle();
				if(prePlayer != userPlayerCtrl){
					if( userPlayerCtrl.checkCanHandle(true, deskcards) ){
						//				if( userPlayerCtrl.checkCanHandle(deskcards,cardstype, true) ){
						btnGroup.playCard(true);
					}else{
						btnGroup.playCard(true,false);
					}
				}else{
					btnGroup.playCard(true);
				}
			}
        }
		passCount = 0;

		//2016.11.29 added
		if(thisone+"" == EginUser.Instance.uid){
			List<JSONObject> serverMyCard = body["mycards"].list;
//			Debug.LogError(body["mycards"].list.Contains(null));
//			Debug.LogError(body["mycards"].list.Equals("null"));
//			Debug.LogError(body["mycards"].list[0]);
//			Debug.LogError(body["mycards"].list[0].str);
//			Debug.LogError(body["mycards"].list[0].IsNull);
//			Debug.LogError(body["mycards"].list[0].str == "Null");
//			Debug.LogError(body["mycards"].list[0].str == "null");
			ctrl.matchServerCardToLocal(serverMyCard);
		}
		if(is131Happy){
			if(btnGroup.isManaged){
				if(!cancelAutoBtn.activeSelf){
					cancelAutoBtn.SetActive(true);
					userPlayerCtrl.autoDrawState();
				}
			}
		}
    }

    //游戏结束
    IEnumerator ProcessGameover(JSONObject messageObj) {
        /*
         * {
'type': 'ddz', 'tag': 'gameover', 
'body': {
    'winner': 100244, #赢家
    'double': 16, #倍数
    'bomb_times':self.bomb_times, #炸弹数
    'rocket_times':self.rocket_times, #火箭数
    'is_spring': true/false, #是否春天 
    'system_win':20, #系统得分 
    'user_win_money': *user_win_money
    }
}

*user_win_money = [
    {'uid': 100244, #uid
     'winmoney': -1600, #本局得分  
     'tax': 0 #水费
     'cards': [1,2,3] #剩余的牌
     },
    ...
         * {"body":{"rocket_times":0,"bomb_times":0,"double":8,"winner":122076,"system_win":0,"user_win_money":
             *[
             *  {"cards":[39,14,40,3,16,29,42,30,5,31,44,22,23,49,24,12,38,51],"winmoney":-80000,"tax":0,"uid":35000001},
             *  {"cards":[null],"winmoney":40000,"tax":0,"uid":122076},
             *  {"cards":[26,2,15,4,17,43,18,6,19,20,21,35,36,11,37,25,52],"winmoney":40000,"tax":0,"uid":127078}
             *],
             * "is_spring":true},"tag":"gameover","type":"ddz"
         * }
]
         */
		_isPlaying = false;
		isInBattle = false;
		isGameOverAnimaPlaying = true;
		btnGroup.hideAll();
		prePlayer = null;
		timeupCount = 0;
		noCallCount   = 0;
		cancelAutoBtn.SetActive(false);
		toggleAutoAndSeePre(false, false);
		JSONObject selfInfo=null; //happy131 use
		if(is131Happy){ddz131.gameover(messageObj);}
        JSONObject body = messageObj["body"];
        int winner = (int)body["winner"].n;
        int bomb = (int)body["bomb_times"].n;
		int multiple = 2;
		if(isObserver){
			multiple = (int)body["doubles"].list[0]["double"].n;
		}else{
			multiple = (int)body["double"].n;
		}
        int rocket = (int)body["rocket_times"].n;
        bool spring = (bool)body["is_spring"].b;
        List<JSONObject> userinfo = body["user_win_money"].list;
        int money = 0;

		DDZPlayerCtrl winnerDoc = getPlayerWithID(winner);
		DDZPlayerCtrl fromPly = null;
		userPlayerCtrl.Setcalldouble(multiple);
//		if(winnerDoc == userPlayerCtrl){
//			isWin = true;
//		}else{
//			isWin = false;
//		}
		if(winnerDoc.isBanker){
			fromPly = winnerDoc;
			DDZSoundMgr.instance.playRandEftDc("lordWin", winnerDoc.isFemale);
		}else{
			foreach (JSONObject playerid in userinfo) {
				int winMoney = (int)playerid["winmoney"].n;
				if(winMoney< 0){
					fromPly = getPlayerWithID((int)playerid["uid"].n);
					break;
				}
			}
			DDZSoundMgr.instance.playRandEftDc("farmerWin", winnerDoc.isFemale);
		}
        foreach (JSONObject playerid in userinfo) {
			int winMoney = (int)playerid["winmoney"].n;
//            Debug.Log((int)playerid["uid"].n + "           " + (int)playerid["winmoney"].n);
			int temp_id = (int)playerid["uid"].n;
			if(isMatch){
				if(rgtPanel.isHoursMatch){
					if(temp_id+"" == EginUser.Instance.uid){
						int curSocre = int.Parse(_userIntoMoney.text);
						_userIntoMoney.text = (curSocre + winMoney)+"";
					}
				}
			}
			DDZPlayerCtrl playCtrl = getPlayerWithID(temp_id);
			if(PlatformGameDefine.game.GameTypeIDs == "1" && PlatformGameDefine.game.GameID == "1006"){//普通斗地主
				if(temp_id+"" == EginUser.Instance.uid){
					int curSocre = int.Parse(_userIntoMoney.text);
					_userIntoMoney.text = (curSocre + winMoney)+"";
				}else{
					int curSocre = int.Parse(playCtrl.kDetailBagmoney.text);
					playCtrl.userIntomoney.text = "¥ " + (curSocre + winMoney);
				}
			}
			if(isLiveRoom || is131Happy){
				playCtrl.liveRoomScore += winMoney;
				if(temp_id == obID || temp_id+"" == EginUser.Instance.uid){
					int curSocre = int.Parse(_userIntoMoney.text);
					if(is131Happy){
						_userIntoMoney.text = playerid["sum_score"].n+"";
					}else{
						_userIntoMoney.text = (curSocre + winMoney)+"";
						if(playCtrl.obCreateLbScore != null){
							playCtrl.obCreateLbScore.text = (curSocre + winMoney)+"";
						}
					}
				}else{
					int curSocre = int.Parse(playCtrl.userIntomoney.text);
					if(is131Happy){
						playCtrl.userIntomoney.text = playerid["sum_score"].n+"";
					}else{
						playCtrl.userIntomoney.text = (curSocre + winMoney)+"";
					}
				}
			}
			if(is131Happy){
				if(temp_id+"" == EginUser.Instance.uid){
					selfInfo = playerid;
				}
				playCtrl.showResultScore( Mathf.Abs( (int)playerid["winmoney"].n ) );
			}else{
				playCtrl.showResultScore((int)playerid["winmoney"].n);
			}
			List<JSONObject> cardlist = playerid["cards"].list;
			if(winnerDoc.isBanker){
				playCtrl.gameOverState(cardlist, playCtrl.isBanker);
			}else{
				playCtrl.gameOverState(cardlist, !playCtrl.isBanker);
			}
//			playCtrl.gameOverState(cardlist, int.Parse(playCtrl.uid) == winner);
            if(_nnPlayerName+(int)playerid["uid"].n == userPlayerObj.name){
                money = (int)playerid["winmoney"].n;
            }else{

			}
			if(winnerDoc.isBanker){
				if(winMoney< 0){
					coinMoveTo(playCtrl.avatarIcon.transform.position, fromPly.avatarIcon.transform.position);
				}
			}else{
				if(winMoney> 0){
					coinMoveTo(fromPly.avatarIcon.transform.position, playCtrl.avatarIcon.transform.position);
				}
			}
			if(isObserver){
				playCtrl.isShowDeck = false;
			}
        }
		if(spring){
			if(getPlayerWithID(winner).isBanker){
				vfxMgr.resultAnima(true);
			}else{
				vfxMgr.resultAnima(false);
			}
		}

        Mybankerid = "";
		if(DDZSoundMgr.sfxSound){
			DDZSoundMgr.instance.playEft("sound/gameover_eft");
		}
		if(winner+"" == EginUser.Instance.uid || winner == obID){
			userPlayerCtrl.Clearcards();
			userPlayerCtrl.clearDeckTag.SetActive(false);
			userPlayerCtrl.deskcardCtrl.clearCards();
		}
		foreach (JSONObject playerid in userinfo) {
			int temp_id = (int)playerid["uid"].n;
			DDZPlayerCtrl playCtrl = getPlayerWithID(temp_id);
			if(playCtrl != userPlayerCtrl){
				playCtrl.Clearcards();
			}
		}
		yield return new WaitForSeconds(2.5f);
		isGameOverAnimaPlaying = false;
		if(processHandle != null && delayNewRankObj != null){
			processHandle(delayNewRankObj);
			processHandle = null;
			delayNewRankObj = null;
		}

		DDZCount.Instance.DestroyHUD();
		if(isMatch){
			if(_isPlaying){
				//In final match, sometimes you will receive "deal" message when playing game over animation. This message make _isPlaying change to true
				userPlayerCtrl.resetBankercards(false);
				yield break;
			}
			if(rgtPanel.matchType == DDZRegtPanel.eMatchType.person3){
				yield break;
			}
		}
		foreach (JSONObject playerid in userinfo) {
			int temp_id = (int)playerid["uid"].n;
			DDZPlayerCtrl playCtrl = getPlayerWithID(temp_id);
			if(playCtrl != null){
				if(!isMatch){
					playCtrl.recoveryAvatar();
				}
				playCtrl.deskcardCtrl.clearCards();
				playCtrl.resultScoreTxt.gameObject.SetActive(false);
				playCtrl.Clearcards();
			}
		}
		if(isLiveRoom){
			show131ScorePanel(bomb, spring?1:0);
			liveRoundCount++;
		}
		if(!isMatch){
			_playingPlayerList.Clear();
		}
		userPlayerCtrl.cantHandleTag.SetActive(false);
		userPlayerCtrl.resetBankercards(false);
		userPlayerCtrl.Setcalldouble(0);
		userPlayerCtrl.clearDeckTag.SetActive(false);
		yield return new WaitForSeconds(2.6f);
		if(is131Happy){
			ddz131.dialog.updateData((int)selfInfo["round"].n, (int)selfInfo["sum_score"].n, (int)selfInfo["ave_score"].n);
			ddz131.dialog.showResultDialog( (int)selfInfo["add_score"].n  ,selfInfo["is_win"].b);
			userPlayerCtrl.cMPInfoPanel.totalScoreLb.text = "总积分: "+ddz131.dialog.score;
			userPlayerCtrl.cMPInfoPanel.avgScoreLb.text = "场均分: "+ddz131.dialog.avgScore;
			userPlayerCtrl.cMPInfoPanel.roundLb.text = "第"+ddz131.dialog.roundCount+"局";
			if(selfInfo["round"].n >= 15 && selfInfo["win_round"].n%8 == 0){
//			if(selfInfo["win_round"].n>15 && selfInfo["win_round"].n%10 == 0 ){
				SimpleFramework.Util.CallMethod("Module_Channel","handleCpl");
			}
		}else{
			btnGroup.gameStart(true);
		}
    }

	private void coinMoveTo(Vector3 startVc, Vector3 endVc)
	{
		int coinCount = 10;
		for(int i=0; i< coinCount; i++){
			GameObject coinObj = NGUITools.AddChild(gameObject, flyCoinPrb);
			coinObj.transform.position = startVc;
			coinObj.transform.localScale = new Vector3(0.01f,0.01f,0.01f);
			coinObj.GetComponent<UISprite>().depth = 3000;
			iTween.MoveTo(coinObj, iTween.Hash("position", endVc, "time", 0.5f, "delay", 0.2f*i, "islocal", false,"easetype",iTween.EaseType.linear,
			                                   "onstart","onCoinFlyStart","onstarttarget",gameObject, "onstartparams",coinObj,
			                                   "oncomplete", "coinFlyCom","oncompletetarget", gameObject, "oncompleteparams",coinObj) );
		}
	}
	private void onCoinFlyStart(GameObject coinObj)
	{
		coinObj.transform.localScale = Vector3.one;
	}
	private void coinFlyCom(GameObject coinObj)
	{
		Destroy(coinObj);
	}

    //重新一局
	IEnumerator ProcessUpdate(JSONObject messageObj){
//		yield return new WaitForEndOfFrame();
		yield return new WaitForSeconds(0.5f);
        /*{
    'type': 'ddz', 'tag': 'update',
    'body': {
        'deskid': 455001, #牌桌号
        'step': self.step, #0叫, 1加, 2出
        'call_times': self.call_times, #叫牌次数
        'double': 32, #当前倍数
        'mycards': [1,4,5,3,10,33], #我的牌
        'current_state': *current_state, #所有人的状态
        'thisone': self.this.uid if self.this else 0,
        'lastone': self.last.uid if self.last else 0,
        'showed_cards': [1,2,3,4,5,...], #已出过的牌,用于计牌器
        'hide_cards': [11,22,33], #补牌
        'banker': 100244, #地主
        'banker_cards': [] #地主的明牌
        'task': newplayer.task_value, #本局任务(同发牌消息)
        'timeout': 5, #倒计时剩余秒数
        }
    }

    *current_state = []
    {
    'uid': player.uid,
    'managed': player.managed, #是否托管
    'hold_num': len(player.cards), #剩余牌数
    'lastput': [c.val for c in player.lastput], #上一手出的牌
    'lastput_type': player.lastput_type, #上一手出的牌的牌型
    'callpt': player.callpt, #-1:还未叫;0:不叫; 1:叫
    'raised': player.raised, #-1:还未加倍, 0:不加倍, 1:加倍
    }
         */

		//example
		/*
		 * {"body":{"task_id":5,"banker_cards":[null],"double":1,"lastone":866627728,
"current_state":[
{"hold_num":4,"managed":false,"uid":108592,"lastput_type":0,"callpt":1,"raised":-1,"lastput":[44]},
{"hold_num":5,"managed":false,"uid":866627728,"lastput_type":1,"callpt":0,"raised":0,"lastput":[36,49]},
{"hold_num":17,"managed":false,"uid":116710,"lastput_type":0,"callpt":0,"raised":0,"lastput":[null]}
],
"thisone":116710,
"step":2,
"mycards":[3,24,50,38,53],
"banker":108592,
"timeout":14.7347459793,
"showed_cards":[2,5,6,7,8,9,10,11,12,13,15,16,18,19,21,22,25,26,28,29,31,35,36,42,44,45,48,49],
"hide_cards":[34,44,20],
"call_times":1},
"tag":"update","type":"ddz"}
		 */

		JSONObject body = messageObj["body"];
		Mybankerid = body["banker"].n + "";
		int step = (int)body["step"].n;
		int timeout = (int)body["timeout"].n;
		int thisone = (int)body["thisone"].n;
		int lastone = (int)body["lastone"].n;
		int multiple= (int)body["double"].n;
		int bankerid =  (int)body["banker"].n;
		List<JSONObject> hideCards = body["hide_cards"].list;
		List<JSONObject> players = body["current_state"].list;
		List<JSONObject> dropCards = body["showed_cards"].list;

		if(is131Happy)ddz131.ddz131Rgt.gameObject.SetActive(false);
		//reconnect in game
		if(_isPlaying){
			foreach (GameObject player in _playingPlayerList)
			{
				if (player != null)
				{
					DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
					List<JSONObject> matchList = new List<JSONObject>();
					for(int i=0; i< ctrl.handCards.Count; i++){
						int myCardID = ctrl.handCards[i].GetComponent<DDZPlayercard>().pokerD.cardID;
						for(int m=0; m< dropCards.Count; m++){
							if(myCardID == (int)dropCards[m].n){
								matchList.Add(dropCards[m]);
								break;
							}
						}
					}
					ctrl.UpdateUserCard( matchList);
				}
			}
			for(int i=0; i<players.Count; i++){
				//{"hold_num":5,"managed":false,"uid":866627728,"lastput_type":1,"callpt":0,"raised":0,"lastput":[36,49]},
				JSONObject info = players[i];
				int playerID = (int)info["uid"].n;
				List<JSONObject> deskcards = info["lastput"].list;
				if(deskcards[0].str != "null"){
					int cardstype = (int)info["lastput_type"].n;
					DDZPlayerCtrl playCtrl = getPlayerWithID(playerID);
					playCtrl.updateCardCount( (int)info["hold_num"].n );
					playCtrl.Updatedeskcards(deskcards,cardstype);
					playCtrl.drawCountPlus();
					
					if (playCtrl == userPlayerCtrl && info["hold_num"].n > 0)
					{
						playCtrl.UpdateUserCard(deskcards);
					}
					if(lastone == playerID){
						prePlayer = playCtrl;
					}
				}
			}
			
			if(thisone+"" == EginUser.Instance.uid || thisone == obID){
				beginplay = true;
				btnGroup.enablePassBtn(false);
				btnGroup.enableTip(false);
				btnGroup.enableDrawBtn(false);
				if(prePlayer != null && prePlayer != userPlayerCtrl){
					if(userPlayerCtrl.checkCanHandle(true, prePlayer.deskcardCtrl.cardsData)){
//					if(userPlayerCtrl.checkCanHandle( prePlayer.deskcardCtrl.cardsData, prePlayer.deskcardCtrl.cardType, false)){
						btnGroup.playCard(true);
					}else{
						btnGroup.playCard(true, false);
					}
				}else{
					btnGroup.playCard(true);
				}
			}
		}else{
			//游戏已经开始
			_isPlaying = true;
			isInBattle = true;
			btnGroup.isManaged = false;
			cancelAutoBtn.SetActive(false);
			btnGroup.gameStart(false);
			
			int Bplayerid = (int)body["banker"].n;
			DDZCount.Instance.UpdateHUD(timeout, 1);
			DDZCount.Instance.moveTo(getPlayerWithID(thisone), isObserver);
			
			foreach (GameObject player in _playingPlayerList)
			{
				if (player != null)
				{
					DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
					ctrl.resetState();
//					ctrl.Clearcards();
					if(ctrl.uid != Mybankerid){
						ctrl.changeToSlave(isLiveRoom);
					}
				}
			}
//			resetBankercards
			userPlayerCtrl.showbankercard(hideCards, true);
			userPlayerCtrl.Setcalldouble(multiple);
			if(!isObserver){
				List<JSONObject> cards = body["mycards"].list;
				userPlayerCtrl.SetDeal2(cards);
			}else{
				List<JSONObject> showDeckStates = body["show_card_info"].list;//{"cards": [5, 7, 53], "is_show": false, "uid": 299022, "show_double": 1}
				for(int i=0; i<showDeckStates.Count; i++){
					JSONObject info1 = showDeckStates[i];
					int playerID = (int)info1["uid"].n;
					List<JSONObject> cards = info1["cards"].list;
					DDZPlayerCtrl playerCtrl = getPlayerWithID(playerID);
					if(playerCtrl != null){
						if(playerCtrl.uid == obID+"")
						{
							playerCtrl.SetDeal2(cards);
						}else{
							StartCoroutine( playerCtrl.showDeck(cards) );
						}
					}
					playerCtrl.isShowDeck = showDeckStates[i]["is_show"].b;
				}
			}
			getPlayerWithID(bankerid).changeToBanker(isLiveRoom);
			int nextone = -1;
			if(step == 2){
				for(int i=0; i<players.Count; i++){
					//{"hold_num":5,"managed":false,"uid":866627728,"lastput_type":1,"callpt":0,"raised":0,"lastput":[36,49]},
					JSONObject info = players[i];
					int playerID = (int)info["uid"].n;
					if(playerID == thisone){
						nextone = (int)players[(i+1)%3]["uid"].n;
					}
					List<JSONObject> deskcards = info["lastput"].list;
					if(deskcards[0].str != "null"){
						int cardstype = (int)info["lastput_type"].n;
						DDZPlayerCtrl playCtrl = getPlayerWithID(playerID);
						playCtrl.updateCardCount( (int)info["hold_num"].n );
						playCtrl.Updatedeskcards(deskcards,cardstype);
						playCtrl.drawCountPlus();
						
						if (playCtrl == userPlayerCtrl && info["hold_num"].n > 0)
						{
							playCtrl.UpdateUserCard(deskcards);
						}
						if(lastone == playerID){
							prePlayer = playCtrl;
						}
					}
				}

				if(nextone+"" == EginUser.Instance.uid || nextone == obID){
					beginplay = true;
					btnGroup.enablePassBtn(false);
					btnGroup.enableTip(false);
					btnGroup.enableDrawBtn(false);
					if(prePlayer != null && prePlayer != userPlayerCtrl){
						if(userPlayerCtrl.checkCanHandle(true, prePlayer.deskcardCtrl.cardsData)){
//						if(userPlayerCtrl.checkCanHandle( prePlayer.deskcardCtrl.cardsData, prePlayer.deskcardCtrl.cardType, false)){
							btnGroup.playCard(true);
						}else{
							btnGroup.playCard(true, false);
						}
					}else{
						btnGroup.playCard(true);
					}
				}
				if(is131Happy)tipMsg.SetActive(false);
			}else if(step == 1){//jiabei
				if (thisone != lastone  && _nnPlayerName + thisone == userPlayerObj.name)
				{
					btnGroup.increaseMultiple(true);
				}
				
				if (thisone == lastone && _nnPlayerName + Mybankerid == userPlayerObj.name)
				{
					DDZCount.Instance.moveTo(userPlayerCtrl, isObserver);
					beginplay = true;
					btnGroup.playCard(true);
					btnGroup.enablePassBtn(false);
					btnGroup.enableTip(false);
					btnGroup.enableDrawBtn(false);
				}
			}else if(step == 0){//call
				if (_nnPlayerName + Mybankerid == userPlayerObj.name)
				{
					btnGroup.callMaster(true, isMatch, false);
				}
			}

		}
		hideScorePanel();
    }

    GameObject AddPlayer(JSONObject memberinfo, int _userIndex)
    {
        string uid = memberinfo["uid"].ToString();
        string bag_money = memberinfo["bag_money"].ToString();
		if(isMatch){
			if(rgtPanel.matchType != DDZRegtPanel.eMatchType.person3){
				if(is131Happy){
					bag_money = memberinfo["sum_score"].n +"";
				}else{
					bag_money = memberinfo["score"].n +"";
				}
			}
		}
        string nickname = memberinfo["nickname"].str;
        int avatar_no = (int)(memberinfo["avatar_no"].n);
        int position = (int)(memberinfo["position"].n);
		bool ready = true;
		if(memberinfo["ready"] != null){
			ready = (bool)memberinfo["ready"].b;
		}
		bool waiting =false;
		if(memberinfo["waiting"] != null){
			waiting = (bool)memberinfo["waiting"].b;
		}
        string level = memberinfo["level"].ToString();

		int position_span = position - _userIndex;
		GameObject player;
		if(position_span == 1 || position_span == -2){
			//Right side
			player = NGUITools.AddChild(this.gameObject, ddzPlayerPrbR);
		}else {
			//Left side
			player = NGUITools.AddChild(this.gameObject, ddzPlayerPrbL);
		}
       
        player.name = _nnPlayerName + uid;
        SetAnchorPosition(player, _userIndex, position);
        DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
		ctrl.SetPlayerInfo(avatar_no, nickname, bag_money, level, isMatch, isLiveRoom);
		if(PlatformGameDefine.game.GameTypeIDs == "20" && memberinfo["win_rate"] != null && ctrl.kDetailNickname != null){
			ctrl.kDetailNickname.text = memberinfo["win_rate"].n + "%";
			ctrl.kDetailNickname.transform.parent.GetComponent<UILabel>().text = "胜率：";
		}
		#if UNITY_STANDALONE && !UNITY_EDITOR
		ctrl.kDetailBagmoney.transform.parent.GetComponent<UILabel>().text = "欢乐豆：";
		#endif
		ctrl.uid = uid;
        if (waiting)
        {
            if (ready)
            {
                ctrl.SetReady(true);
                _readyPlayerList.Add(player);
            }
            _waitPlayerList.Add(player);
        }
        else
        {
            _playingPlayerList.Add(player);
        }

        return player;
    }

    void SetAnchorPosition(GameObject player, int _userIndex, int playerIndex)
    {
        int position_span = playerIndex - _userIndex;
        UIAnchor anchor = player.GetComponent<UIAnchor>();
        if (position_span == 0)
        {
            anchor.side = UIAnchor.Side.Bottom;
        }
        else if (position_span == 1 || position_span == -2)
        {
            anchor.side = UIAnchor.Side.TopRight;
            //			anchor.pixelOffset.x = -80f;
            anchor.relativeOffset.x = -.06f;
            anchor.relativeOffset.y = -.28f;
        }
        else if (position_span == 2 || position_span == -1)
        {
            anchor.side = UIAnchor.Side.TopLeft;
            //			anchor.pixelOffset.x = -80f;
            anchor.relativeOffset.x = .06f;
            anchor.relativeOffset.y = -.28f;
        }
        
    }

    void ProcessReady(JSONObject messageObj)
    {
        string uid = messageObj["body"].ToString();
        GameObject player = GameObject.Find(_nnPlayerName + uid);
        DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();

        //显示准备
        ctrl.SetReady(true);
		if(!_playingPlayerList.Contains(player)){
			_playingPlayerList.Add(player);
		}
    }
    //托管
    public void UserManage() {
		bool isManage = true;
		btnGroup.isManaged = true;
        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "game");
        startJson.AddField("tag", "manage");
        startJson.AddField("body", isManage);
        base.SendPackageWithJson(startJson);

        EginTools.PlayEffect(soundStart);

		btnGroup.gameStart(false);
		if(!cancelAutoBtn.activeSelf){
			userPlayerCtrl.autoDrawState();
		}
		cancelAutoBtn.SetActive(true);
		userPlayerCtrl.cantHandleTag.SetActive(false);
    }
	public void UserCancelAutoDraw()
	{
		bool isManage = false;
		btnGroup.isManaged = false;
		JSONObject startJson = new JSONObject();
		startJson.AddField("type", "game");
		startJson.AddField("tag", "manage");
		startJson.AddField("body", isManage);
		base.SendPackageWithJson(startJson);
		cancelAutoBtn.SetActive(false);
		userPlayerCtrl.cancelAutoDraw();
	}
    public void ProcessManage(JSONObject messageObj) { 
		// {'type':'game', 'tag':'manage', 'body':{'uid':player.uid, 'managed':true/flase,'offline':offline}
		if(isObserver)return;
        JSONObject body = messageObj["body"];
		int uid = (int)body["uid"].n;
		if(_nnPlayerName + uid == userPlayerObj.name){
			if(body["managed"].b){
				cancelAutoBtn.SetActive(true);
				btnGroup.hideAll();
				btnGroup.isManaged = true;
				userPlayerCtrl.autoDrawState();
			}else{
				btnGroup.isManaged = false;
			}
		}else{
			if(body["managed"].b){
				getPlayerWithID(uid).autoDrawState();
			}else{
				getPlayerWithID(uid).cancelAutoDraw();
			}
			getPlayerWithID(uid).managedFlag.SetActive(body["managed"].b);
//			getPlayerWithID(uid).disconnectFlag.SetActive(body["offline"].b);
		}
    }
	public void ProcessOnline(JSONObject messageObj) { 
		// {'type':'ddz','tag':'online','body':[true,uid]}
		// true 在线  false 离线
		List<JSONObject> body = messageObj["body"].list;
		int uid = (int)body[1].n;
		bool isOnline = body[0].b;
		if(uid+"" != EginUser.Instance.uid && uid != obID){
			getPlayerWithID(uid).disconnectFlag.SetActive(!isOnline);
		}
	}

    //结束后继续
    //继续一局
    public void UserContinue()
    {

        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "game");
        startJson.AddField("tag", "continue");
        base.SendPackageWithJson(startJson);
        EginTools.PlayEffect(soundStart);
		userPlayerCtrl.Setcalldouble(0);
		btnGroup.gameStart(false);
		hideScorePanel();
    }
	public void UserShowDeckContinue()
	{
		JSONObject startJson = new JSONObject();
		JSONObject body = new JSONObject("["+int.Parse(EginUser.Instance.uid)+","+ true+"]");
		startJson.AddField("type", "ddz");
		startJson.AddField("tag", "showcard_1");
		startJson.AddField("body", body);
		base.SendPackageWithJson(startJson);
		EginTools.PlayEffect(soundStart);
		userPlayerCtrl.Setcalldouble(0);
		btnGroup.gameStart(false);
		DDZSoundMgr.instance.playRandEftDc("openCard", userPlayerCtrl.isFemale);
		hideScorePanel();
	}

    //继续广播

    //点换桌
    public void UserChangedesk()
    {

        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "game");
        startJson.AddField("tag", "changedesk");
        startJson.AddField("body", EginUser.Instance.uid);
        base.SendPackageWithJson(startJson);

		btnGroup.gameStart(false);
        UserQuit();
    }

    //某人离开牌桌(发生于断线或换桌后)
    public void ProcessLeave(JSONObject messageObj)
    {
        //{'type':'game', 'tag':'leave', 'body':uid}
        string uid = messageObj["body"].ToString();
		if (!uid.Equals(EginUser.Instance.uid) && uid != obID+"")
        {
            GameObject player = GameObject.Find(_nnPlayerName + uid);
            if (_playingPlayerList.Contains(player))
            {
                _playingPlayerList.Remove(player);
            }
            if (_waitPlayerList.Contains(player))
            {
                _waitPlayerList.Remove(player);
            }
			if(_readyPlayerList.Contains(player))
			{
				_readyPlayerList.Remove(player);
			}
            Destroy(player);
        }
    }

    //出牌延迟报告


    public void UserReady()
    {
        //向服务器发送消息（开始游戏）
        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "game");
		//Modified by xiaoyong 2016/2/16  change to "ready"
//        startJson.AddField("tag", "start");
		startJson.AddField("tag", "ready");
		startJson.AddField("body", int.Parse(EginUser.Instance.uid) );
        base.SendPackageWithJson(startJson);

        EginTools.PlayEffect(soundStart);

		btnGroup.gameStart(false);
    }

    /// <summary>
    /// Processes the deal.(带发牌动画)
    /// </summary>
    /// <returns>The deal.</returns>
    /// <param name="messageObj">Message object.</param>
    IEnumerator ProcessDeal(JSONObject messageObj)
    {
        //游戏已经开始
        _isPlaying = true;
		btnGroup.isManaged = false;
		hasCall = false;
		cancelAutoBtn.SetActive(false);
		btnGroup.gameStart(false);
//		DDZTip._preCards = null;
		roundLeader = null;
		noCallCount = 0;
		if(isLiveRoom){
			roundCountLb.text = "第"+ liveRoundCount +"局";
//			liveRoundCount++;
		}
        foreach (GameObject player in _readyPlayerList)
        {
            if (!_playingPlayerList.Contains(player))
            {
                _playingPlayerList.Add(player);
            }
        }
        _readyPlayerList.Clear();
		
        //去掉“准备”
        foreach (GameObject player in _playingPlayerList)
        {
            if (player != null)
            {
                player.GetComponent<DDZPlayerCtrl>().SetReady(false);
            }
        }
		if(DDZSoundMgr.sfxSound){
			DDZSoundMgr.instance.playEft("sound/kaishi");
		}
		if(resultAnima.IsInvoking("delayShowTips")){
			resultAnima.CancelInvoke("delayShowTips");
		}
		resultAnima.tipSpt.gameObject.SetActive(false);
		tipMsg.SetActive(false);//happy131 will show up tipMsg object.
        /*
         
=> 发牌
{
'type':'ddz', 'tag':'deal', 
'body':{
   'visible_card': 46,			#发牌的时候亮出来的一张
   'mycards': [5,3,4,16,47,28,39,...],	#我的17张牌
   'banker': 100244,			#从谁开始
   'task_id': 任务ID， 0表示没任务
   'timeout': 15,			#15秒等叫地主
}
}
         */
		if(isObserver){
			gameDDZOb.ProcessDeal(messageObj);
			hideScorePanel();
		}else{
			JSONObject body = messageObj["body"];
			List<JSONObject> cards = body["mycards"].list;
			//		List<JSONObject> tempCards = new List<JSONObject>();
			//		for(int i= cards.Count-1; i>=0; i--){
			//			tempCards.Add(cards[i]);
			//		}
			int thisvisible_card = (int)body["visible_card"].n;
			int Bplayerid = (int)body["banker"].n;
			//deleted at 2016.3.31 not use.
			//        int Mid = (int)body["task_id"].n;
			int timeout = (int)body["timeout"].n;
			//        DDZCount.Instance.UpdateHUD(timeout, 1);
			DDZCount.Instance.DestroyHUD();
			//		DDZCount.Instance.moveTo(getPlayerWithID(Bplayerid));
			//发牌
			//if (_nnPlayerName + Bplayerid == userPlayerObj.name){

			//        userPlayerObj.GetComponent<DDZPlayerCtrl>().Clearcards();
			foreach (GameObject player in _playingPlayerList)
			{
				if (player != null)
				{
					DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
					ctrl.resetState();
					//				ctrl.changeToSlave();
					ctrl.Clearcards();
				}
			}
			StartCoroutine(cardCountPlusPlus());
			userPlayerCtrl.SetDeal(cards);
			if (_nnPlayerName + Bplayerid == userPlayerObj.name)
			{
				yield return new WaitForSeconds(4.7f);
				DDZCount.Instance.UpdateHUD(timeout, 1);
				DDZCount.Instance.moveTo(getPlayerWithID(Bplayerid), isObserver);
				btnGroup.callMaster(true, isMatch, false);
			}
		}
    }

	private IEnumerator cardCountPlusPlus()
	{
		for(int i=1; i< 18 ; i++){
			foreach (GameObject player in _playingPlayerList)
			{
				if (player != null)
				{
					DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
					ctrl.updateCardCount(i,true);
					yield return new WaitForSeconds(0.07f);
				}
			}
		}
	}

//    void ProcessOk(JSONObject messageObj)
//    {
//		Debug.LogError("=============");
//		Debug.LogError("  ProcessOk");
//		Debug.LogError("=============");
//        JSONObject body = messageObj["body"];
//        string uid = body["uid"].ToString();
//
//        if (uid != EginUser.Instance.uid)
//        {
//            GameObject.Find(_nnPlayerName + uid).GetComponent<DDZPlayerCtrl>().SetShow(true);
//        }
//        else
//        {
//            List<JSONObject> cards = body["cards"].list;
//            int cardType = (int)body["type"].n;
//            userPlayerCtrl.SetCardTypeUser(cards, cardType);
//        }
//
//        EginTools.PlayEffect(soundTanover);
//    }

    
    void ProcessUpdateAllIntomoney(JSONObject messageObj)
    {
		if(isLiveRoom)return;
		if (!messageObj.ToString().Contains(EginUser.Instance.uid) && !messageObj.ToString().Contains(obID+"")) { return; }

        List<JSONObject> infos = messageObj["body"].list;
        foreach (JSONObject info in infos)
        {
            string uid = info[0].ToString();
            string intoMoney = info[1].ToString();
            GameObject player = GameObject.Find(_nnPlayerName + uid);
            if (player != null)
            {
                GameObject.Find(_nnPlayerName + uid).GetComponent<DDZPlayerCtrl>().UpdateIntoMoney(intoMoney);
            }
        }
    }

    public override void ProcessUpdateIntomoney(JSONObject messageObj)
    {
		if(isLiveRoom)return;
        string intoMoney = messageObj["body"].ToString();
		_userIntoMoney.text = intoMoney+"";
    }

    void ProcessCome(JSONObject messageObj)
    {
        JSONObject body = messageObj["body"];
        JSONObject memberinfo = body["memberinfo"];
        GameObject player = AddPlayer(memberinfo, _userIndex);

		curPlayerCount++;
		if(curPlayerCount == 3){
			waitObj.SetActive(false);
			btnGroup.gameStart(true);
		}

    }
    void ProcessEnter(JSONObject messageObj)
    {
		if(_isPlaying){
			if(noCallCount != 3){
				return;
			}
		}
		curPlayerCount = 1;
		roundCount++;
        JSONObject body = messageObj["body"];
        List<JSONObject> memberinfos = body["memberinfos"].list;
		JSONObject deskInfo = body["deskinfo"];
        userPlayerCtrl = userPlayerObj.GetComponent<DDZPlayerCtrl>();
		userPlayerCtrl.isObserver = isObserver;
		userPlayerCtrl.createliveRoomObLb(_userNickname.gameObject);

//		btnGroup.gameStart(true);
		if(isMatch){
			foreach(GameObject player in _playingPlayerList){
				if(player != userPlayerObj){
					Destroy(player);
				}
			}
			_playingPlayerList.Clear();
			if(rgtPanel != null){
				rgtPanel.gameObject.SetActive(false);
			}
			resultAnima.hideAnima();
			if(rgtPanel.matchType != DDZRegtPanel.eMatchType.person3 && !is131Happy){
				if(isFirstRound != deskInfo["step"].n){
					if( deskInfo["step"].n == 1){
						resultAnima.beginMatch();
					}else if( deskInfo["step"].n == 2){
						resultAnima.beginFinalMatch();
						userPlayerCtrl.cMPInfoPanel.titleSpt.spriteName = "txtFinalVS";
						userPlayerCtrl.cMPInfoPanel.isFinalVS = true;
					}
					isFirstRound = (int)deskInfo["step"].n;
				}
				isFinalVS = (deskInfo["step"].n == 2);
			}
			if(is131Happy){
				userPlayerCtrl.cMPInfoPanel.gameObject.SetActive(true);
				userPlayerCtrl.scoreLb.transform.parent.gameObject.SetActive(true);
				userPlayerCtrl.cMPInfoPanel.toHappy131Mode();
				userPlayerCtrl.cMPInfoPanel.totalScoreLb.text = "总积分: "+ddz131.dialog.score;
				userPlayerCtrl.cMPInfoPanel.avgScoreLb.text = "场均分: "+ddz131.dialog.avgScore;
				userPlayerCtrl.cMPInfoPanel.roundLb.text = "第"+(ddz131.dialog.roundCount+1)+"局";
			}
			resultAnima.tipSpt.gameObject.SetActive(false);
		}
        foreach (JSONObject memberinfo in memberinfos)
        {
            if (memberinfo != null)
            {
				if (memberinfo["uid"].ToString() == EginUser.Instance.uid || memberinfo["uid"].n == obID)
                {
                    _userIndex = (int)(memberinfo["position"].n);
					//deleted bool waiting = (bool)memberinfo["waiting"].b; at 2016.3.31  Actually, no places use this value in this function.
//                   bool waiting = (bool)memberinfo["waiting"].b;
                    //if (waiting)
                    //{
                    //    _waitPlayerList.Add(userPlayerObj);
                    //}
                    //else
                    //{
					if(!_playingPlayerList.Contains(userPlayerObj)){
						_playingPlayerList.Add(userPlayerObj);
					}
                    //}
                    int height = userPlayerObj.transform.root.GetComponent<UIRoot>().manualHeight;
                    userCardScore.transform.localPosition = new Vector3(0, (-.07f * height - 52) - userPlayerObj.transform.localPosition.y, 0);

					if(isObserver){
						userPlayerObj.name = _nnPlayerName + obID;
					}else{
						userPlayerObj.name = _nnPlayerName + EginUser.Instance.uid;
					}
					_userAvatar.spriteName = "avatar_" + memberinfo["avatar_no"].n;
					userPlayerCtrl.avatarID = (int)memberinfo["avatar_no"].n;
					userPlayerCtrl.setSelfSex();
					userPlayerCtrl.Setcallpt((int)deskInfo["unit_money"].n);
					userPlayerCtrl.Setcalldouble(1);
					if(isObserver){
						userPlayerCtrl.uid = obID+"";
						userPlayerObj.transform.Find("anchorLeft").GetComponent<UIAnchor>().relativeOffset = new Vector2(0.06f, -0.25f);
						userPlayerObj.transform.Find("anchorLeft").GetComponent<UIAnchor>().enabled = false;
						userPlayerObj.transform.Find("anchorLeft").GetComponent<UIAnchor>().enabled = true;
						if(userPlayerCtrl.obCreateLbUserName != null){
							userPlayerCtrl.obCreateLbUserName.text = memberinfo["nickname"].str;
						}
					}else{
						userPlayerCtrl.uid = EginUser.Instance.uid;
					}
					chatPl.initDataWithSex(userPlayerCtrl.isFemale);
					_userNickname.text = memberinfo["nickname"].str;

					if(isMatch){
						if(rgtPanel.matchType == DDZRegtPanel.eMatchType.person3){
							userPlayerCtrl.ddz3RoundLb.text = "1/"+(deskInfo["playedtimes"].n+1);
						}else{
							resultAnima.initRank((int)memberinfo["rank"].n);
							if(is131Happy){
								ddz131.initEnterData((int)memberinfo["rank"].n, 30, (int)memberinfo["ave_score"].n, body["top50"].list);
							}else{
								userPlayerCtrl.cmpInfoInit((int)memberinfo["rank"].n, (int)deskInfo["cn"].n, (int)deskInfo["matchtime"].n);
								leaderboard.initLeaderboard(deskInfo["top10"].list, DDZRegtPanel.eMatchType.hour);
								leaderboard.updateSelfInfo( (int)memberinfo["rank"].n, (int)memberinfo["score"].n );
								_userIntoMoney.text = memberinfo["score"].n + "";
								if(rgtPanel.isHoursMatch){
									userPlayerCtrl.cMPInfoPanel.lvupTipLb.text = "前12名晋级决赛";
								}
							}
						}

					}else{
						if(isLiveRoom){
							_userIntoMoney.text = "0";
						}else{
							if(is131Happy){
								_userIntoMoney.text = memberinfo["sum_score"].n + "";
							}else{
								_userIntoMoney.text = memberinfo["into_money"].n + "";
							}
						}
					}

                    if (SettingInfo.Instance.autoNext == true || SettingInfo.Instance.deposit == true)
                    {
                        UserReady();
                    }
					if(isMatch && roundCount>1){
						userPlayerCtrl.recoveryAvatar();
					}
                    break;
                }
            }
        }

        foreach (JSONObject memberinfo in memberinfos)
        {
            if (memberinfo != null)
            {
				if (memberinfo["uid"].ToString() != EginUser.Instance.uid && memberinfo["uid"].n != obID)
                {
					GameObject playerObj = AddPlayer(memberinfo, _userIndex);
					curPlayerCount++;
					if(isMatch && roundCount>1){
						DDZPlayerCtrl playerMono = playerObj.GetComponent<DDZPlayerCtrl>();
						playerObj.GetComponent<DDZPlayerCtrl>().recoveryAvatar();
					}
					if(isMatch && rgtPanel.matchType == DDZRegtPanel.eMatchType.person3){
						foreach(JSONObject jobj in deskInfo["ranks"].list){
							if(jobj["uid"].n+"" ==  memberinfo["uid"].ToString()){
								playerObj.GetComponent<DDZPlayerCtrl>().userIntomoney.text = jobj["score"].n+"";
								break;
							}
						}
					}
					playerObj.GetComponent<DDZPlayerCtrl>().isObserver = isObserver;
                }
            }
        }

		if(curPlayerCount == 3){
			waitObj.SetActive(false);
			btnGroup.gameStart(true);
		}
    }


    public void UserLeave()
    {
		if(isObserver)return;
        JSONObject userLeave = new JSONObject();
        userLeave.AddField("type", "game");
        userLeave.AddField("tag", "leave");
        userLeave.AddField("body", EginUser.Instance.uid);
        base.SendPackageWithJson(userLeave);
    }

    IEnumerator ProcessNotcontinue()
    {
        msgNotContinue.SetActive(true);
        yield return new WaitForSeconds(3f);
        UserQuit();
    }

    public void UserQuit()
    {
        SocketConnectInfo.Instance.roomFixseat = true;

        JSONObject userQuit = new JSONObject();
        userQuit.AddField("type", "game");
        userQuit.AddField("tag", "quit");
        base.SendPackageWithJson(userQuit);

        base.OnClickBack();
    }

	public void UserSeePreDeck()
	{
		precardPl.showPreCard(_playingPlayerList);
	}

	public void UserSendEmotion(int emotID)
	{
		JSONObject emotJson = new JSONObject();
		emotJson.AddField("type", "game");
		emotJson.AddField("tag", "emotion");
		emotJson.AddField("body", emotID);
		base.SendPackageWithJson(emotJson);
		emotionPl.playEmotAt(emotID, userPlayerCtrl.avatarIcon.gameObject);
	}
	public void UserChat(int sentenceID){
		JSONObject messageBody = new JSONObject();
		messageBody.AddField("hurry_index", sentenceID);
		JSONObject sendMgs = new JSONObject();
		sendMgs.AddField("type", "game");
		sendMgs.AddField("tag", "hurry");
		sendMgs.AddField("body", messageBody);
		base.SendPackageWithJson(sendMgs);
		userPlayerCtrl.showChatBubble(sentenceID);
	}
	
	public DDZPlayerCtrl getPlayerWithID(int id)
	{
		for(int i=0; i<_playingPlayerList.Count; i++){
			if(_playingPlayerList[i].name == (_nnPlayerName + id)){
				return _playingPlayerList[i].GetComponent<DDZPlayerCtrl>();
			}
		}
		for(int i=0; i<_waitPlayerList.Count; i++){
			if(_waitPlayerList[i].name == (_nnPlayerName + id)){
				return _waitPlayerList[i].GetComponent<DDZPlayerCtrl>();
			}
		}
		return null;
	}

	public void updateDrawBtnState(bool isEnable)
	{
		if(prePlayer == null){
			isEnable = userPlayerCtrl.checkSelCard(true);
//			userPlayerCtrl.selTip(selC, true);
		}else{
			if(prePlayer == userPlayerCtrl){
				isEnable = userPlayerCtrl.checkSelCard(true);
//				userPlayerCtrl.selTip(selC, true);
			}else{
//				userPlayerCtrl.selTip(selC, false, prePlayer.deskcardCtrl.cardsData, prePlayer.deskcardCtrl.cardType);
				if(isEnable){
					isEnable = userPlayerCtrl.checkSelCard(true, prePlayer.deskcardCtrl.cardsData, prePlayer.deskcardCtrl.cardType);
				}
			}
		}
		btnGroup.enableDrawBtn(isEnable);
	}

	public void timeup()
	{
		if(beginplay && _isPlaying && isInBattle){
			if(isMatch){
				timeupCount++;
				if(timeupCount == 1){
					popupTipText("tipDeTo10");
				}else if(timeupCount == 2){
					popupTipText("tipDeTo5");
				}
			}
			if(!isObserver){
				UserManage();
			}
		}
	}
	private void toggleAutoAndSeePre(bool isEnAutoDrawBtn, bool isEnSeePreBtn)
	{
		if(isEnAutoDrawBtn){
			autoDrawBtn.enabled = true;
			autoDrawBtn.GetComponent<UISprite>().color = new Color(1,1,1);
			autoDrawBtn.GetComponent<UIPlaySound>().enabled = true;
		}else{
			autoDrawBtn.enabled = false;
			autoDrawBtn.GetComponent<UISprite>().color = new Color(0.6f,0.6f,0.6f);
			autoDrawBtn.GetComponent<UIPlaySound>().enabled = false;
		}
		if(isEnSeePreBtn){
			seePreCardBtn.enabled = true;
			seePreCardBtn.GetComponent<UISprite>().color = new Color(1,1,1);
			seePreCardBtn.GetComponent<UIPlaySound>().enabled = true;
		}else{
			seePreCardBtn.enabled = false;
			seePreCardBtn.GetComponent<UISprite>().color = new Color(0.6f,0.6f,0.6f);
			seePreCardBtn.GetComponent<UIPlaySound>().enabled = false;
		}
	}

	//About Setting Panel------------------
	public GameObject settingTogglePerson;
	public GameObject settingToggleBGM;
	public GameObject settingToggleSFX;
	public void showSettingPanel()
	{
		settingPanel.SetActive(true);
	}
	public void togglePersonSound(GameObject btn)
	{
		DDZSoundMgr.personSound = !DDZSoundMgr.personSound;
		if(DDZSoundMgr.personSound){
			btn.GetComponent<UISprite>().spriteName = "toggleOpen";
		}else{
			btn.GetComponent<UISprite>().spriteName = "toggleClose";
		}
	}
	public void toggleBGMSound(GameObject btn)
	{
		DDZSoundMgr.bgmSound = !DDZSoundMgr.bgmSound;
		if(DDZSoundMgr.bgmSound){
			btn.GetComponent<UISprite>().spriteName = "toggleOpen";
		}else{
			btn.GetComponent<UISprite>().spriteName = "toggleClose";
		}
	}
	public void toggleSFXSound(GameObject btn)
	{
		DDZSoundMgr.sfxSound = !DDZSoundMgr.sfxSound;
		if(DDZSoundMgr.sfxSound){
			btn.GetComponent<UISprite>().spriteName = "toggleOpen";
		}else{
			btn.GetComponent<UISprite>().spriteName = "toggleClose";
		}
	}
	private void initSettingPanel()
	{
		if(DDZSoundMgr.personSound){
			settingTogglePerson.GetComponent<UISprite>().spriteName = "toggleOpen";
		}else{
			settingTogglePerson.GetComponent<UISprite>().spriteName = "toggleClose";
		}
		if(DDZSoundMgr.bgmSound){
			settingToggleBGM.GetComponent<UISprite>().spriteName = "toggleOpen";
		}else{
			settingToggleBGM.GetComponent<UISprite>().spriteName = "toggleClose";
		}
		if(DDZSoundMgr.sfxSound){
			settingToggleSFX.GetComponent<UISprite>().spriteName = "toggleOpen";
		}else{
			settingToggleSFX.GetComponent<UISprite>().spriteName = "toggleClose";
		}
	}
	//<-----------------

    /* ------ Button Click ------ */
    public override void OnClickBack()
    {
        if (!_isPlaying)
        {
            UserQuit();
        }
        else
        {
			if(isObserver){
				UserQuit();
			}else{
				if(is131Happy){
					ddz131.dialog.showQuitDialog();
				}else{
					msgQuit.SetActive(true);
				}
			}
        }
    }

    public override void ShowPromptHUD(string errorInfo)
    {
		btnGroup.gameStart(false);
        msgAccountFailed.SetActive(true);
        msgAccountFailed.GetComponentInChildren<UILabel>().text = errorInfo;
    }

    /* ------ Socket Listener ------ */
    public override void SocketReady()
    {
        base.SocketReady();
//		Debug.LogError(isMatch + "==" + rgtPanel.isHoursMatch);
		if(!isMatch){
			if(!rgtPanel.isHoursMatch){
				InvokeRepeating("heartbeatHandle",2.0f, 5.0f);
			}
		}
//		Debug.LogError("SocketReady===>");
    }

    public override void SocketDisconnect(string disconnectInfo)
    {
//		Debug.LogError("GameDDZ disconnect !!!!");
//		SocketManager.Instance.socketListener = null;
//		CancelInvoke("heartbeatHandle");
//        base.SocketDisconnect(disconnectInfo);
    }

	private void heartbeatHandle()
	{
		JSONObject messageBody = new JSONObject();
		JSONObject sendMgs = new JSONObject();
		sendMgs.AddField("type", "ddz");
		sendMgs.AddField("tag", "heartbeat");
//		sendMgs.AddField("body", messageBody);
		base.SendPackageWithJson(sendMgs);
//		Debug.Log("==>"+sendMgs.ToString());
//		userPlayerCtrl.showChatBubble(sentenceID);
	}

	private void checkNetwork()
	{
		if(!hasNetwork()){
			networkTip.SetActive(true);
//			if(isLiveRoom){
//				if(!IsInvoking("reconnectServer")){
//					Invoke("reconnectServer",10.0f);
//				}
//			}
		}else{
//			if(isLiveRoom){
//				CancelInvoke("reconnectServer");
//			}
			networkTip.SetActive(false);
		}
	}

	private void reconnectServer()
	{
		if(hasNetwork()){
			StartCoroutine(reconnectServerStep());
		}
	}

	private IEnumerator reconnectServerStep()
	{
		CancelInvoke("checkNetwork");
		SocketConnectInfo.Instance.roomFixseat = true;
		SocketManager.Instance.socketListener = null;
		SocketManager.Instance.Disconnect("GameDDZ force disconnect");
		yield return new WaitForSeconds(1.0f);
		SocketManager.Instance.socketListener = this;
		SocketManager.Instance.Connect(SocketConnectInfo.Instance);
		yield return new WaitForSeconds(2.0f);
		InvokeRepeating("checkNetwork",5.0f, 2.0f);
		//		SocketReady();
	}

	public bool hasNetwork()
	{
#if UNITY_EDITOR || UNITY_STANDALONE
//		Debug.Log(Network.player.ipAddress);
		if (Network.player.ipAddress.ToString() == "127.0.0.1" || Network.player.ipAddress.ToString() == "0.0.0.0")
		{
			return false;
		}else{
			return true;
		}
#endif
		if(Application.internetReachability == NetworkReachability.NotReachable){
			return false;
		}else if( Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork){
			return true;//2/3/4G
		}else if(Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork){
			return true;//wifi
		}else{
			return false;
		}
	}

	#region 斗地主5分钟赛 socket处理函数
	public DDZRegtPanel rgtPanel;
	private delegate void ProcessHandle(JSONObject msgObj);
	private ProcessHandle processHandle;
	private JSONObject delayNewRankObj;
	private JSONObject curRankInfo;
//	private bool isWin;
	private bool isOut;
	private int isFirstRound=-1;
	private void ProcessApply(JSONObject messageObj)
	{
		//{"body": {"initscore": 1000, "step2_initscore": 1000, "full": false, "requirements": "\\u65e0", 
		//"cn": 0, "mincn": 3, "matchtime": "", "maxcn": 500, "step2time": 300, "delay": false, "unit_money": 100, 
		//"restseconds": 10, "strange": false, "awards": [["第1名", "5000金币+1快乐卡"], ["第2名", "2000金币+1快乐卡"], 
		//["第3名", "1000金币+1快乐卡"], ["第4名", "4张快乐卡"], ["第5名", "3张快乐卡"], ["第6~9名", "1张快乐卡"]], 
		//"cantrebuy": true, "late": false, "close": false, "step1time": 300, "join_rank": 3, 
		//"champion_award": "25\\u5143\\u5b9d+1\\u5feb\\u4e50\\u5361", "step2_line": 9}, "tag": "apply", "type": "ddz7"}
		if(is131Happy){
			ddz131.ProcessApply(messageObj);
			return;
		}
		JSONObject body = messageObj["body"];
		DDZRegtPanel rgt = rgtPanel;
		EginProgressHUD.Instance.HideHUD();
		rgt.gameObject.SetActive(true);
//		if(rgtPanel != null){
//			rgt = rgtPanel;
//			rgt.gameObject.SetActive(true);
//		}else{
//			GameObject rgtPrb = SimpleFramework.Util.LoadAsset("GameDDZ/regtLayer","regtLayer") as GameObject;
//			GameObject rgtObj = NGUITools.AddChild(transform.parent.parent.gameObject, rgtPrb);
//			rgt = rgtObj.GetComponent<DDZRegtPanel>();
//			rgtPanel = rgt;
//		}

		if(messageObj["type"].str == "ddz7"){
			if(body["full"].b){
				rgt.showTip("人数已满,不能参加比赛。", UserQuit);
				return;
			}
			if(body["late"].b){
				rgt.showTip("比赛已经开始。", UserQuit);
				return;
			}
			if(body["strange"].b){
				rgt.showTip("现在不允许参加比赛。", UserQuit);
				return;
			}
			rgt.rgtPriceLb.text = SocketConnectInfo.Instance.entry_fee+"";
			if(PlatformGameDefine.game.GameTypeIDs == "9"){
				rgt.rgtPriceLb.text = "日赛门票";
				rgt.dailyStartTime.text = body["matchtime"].str;
				rgt.dailyPerson.text = body["cn"].n+"";
				rgt.dailyPersonLimit.text = body["mincn"].n +"-"+ body["maxcn"].n;
				rgt.dailyTickets.text = body["ticketnum"].n +"";
				if(body["top_rank10"] != null){
					rgt.initRankList(body["top_rank10"].list);
				}
			}
			if( body["matchtime"].str.Length > 0){
				rgt.startTimeLb.text = body["matchtime"].str;
			}else{
				rgt.startTimeLb.text = "5分钟一场";
			}
			rgt.personLb.text = body["cn"].n+"";
			rgt.personLimitLb.text = body["mincn"].n +"-"+ body["maxcn"].n;
			rgt.startCD( (int)body["restseconds"].n );
			rgt.initAward(body["awards"].list, DDZRegtPanel.eMatchType.hour);
			rulesPanel.initAward(body["awards"].list, DDZRegtPanel.eMatchType.hour);
		}else if(messageObj["type"].str == "ddz9"){
			//{"body": {"awards": [["第1名", "1快乐卡"], ["第2名", ""], ["第3名", ""]], "deckn": 3, "fee": 10000, "playern": 0, "close": false}, "tag": "apply", "type": "ddz9"}
			if(body["close"].b){
				rgt.showTip("比赛已关闭。", UserQuit);
				return;
			}
			rgt.rgtPriceLb.text = body["fee"].n + "";
			if(PlatformGameDefine.game.GameTypeIDs == "8"){
				rgt.n131require.text = "满6人开赛";//rgt.startTimeLb.text = "满6人开赛";
				rgt.n131RgtPrice.text = body["fee"].n + "";
				rgt.n131Person.text =  body["playern"].n+"";
				rgt.n131NeedPerson.text = (6 - body["playern"].n)+"";
			}else{
				rgt.startTimeLb.text = "满3人开赛";
			}
			rgt.personLb.text = body["playern"].n+"";
			rgt.personLimitLb.text = body["deckn"].n + "";
			rgt.startCD( 0 );
			rgt.initAward(body["awards"].list, DDZRegtPanel.eMatchType.person3);
			rulesPanel.initAward(body["awards"].list, DDZRegtPanel.eMatchType.person3);
		}
	}

	private void ProcessPersonChange(JSONObject messageObj)
	{
		//{"body": {"playern": 6}, "tag": "newcn", "type": "ddz7"}
		JSONObject body = messageObj["body"];
		if(rgtPanel != null){
			if(PlatformGameDefine.game.GameTypeIDs == "9"){
				rgtPanel.dailyPerson.text = body["playern"].n+"";
			}else if(PlatformGameDefine.game.GameTypeIDs == "8"){
				rgtPanel.n131Person.text =  body["playern"].n+"";
				rgtPanel.n131NeedPerson.text = (6 - body["playern"].n)+"";
			}else{
				rgtPanel.personLb.text = body["playern"].n+"";
			}
		}
	}
	private void ProcessReChecking(JSONObject messageObj)
	{
		//{"body": {"step": 1, "top10": [[1000, 866627772, "bj123456789"], [1000, 111052, "李少"], 
		//[1000, 118135, "艾你娜娜"], [1000, 108323, "我是小孩"], [1000, 116494, "yiyia"], [1000, 110682, "艳舞表演"], [1000, 123060, "樱——千月"], 
		//[1000, 115903, "瞬间精彩"], [1000, 124184, "金色之恋"], [1000, 110969, "resonly"], [1000, 115475, "聽雨季憂傷"], [1000, 109888, "紫星珊澜"], 
		//[1000, 106218, "疑人勿用王雪梅"], [1000, 110035, "fgjhjgyjg"], [1000, 110727, "美雪"], [1000, 106387, "黄俊耀"], [1000, 124145, "碍事"], [1000, 117206, "等猫的鱼"], 
		//[1000, 116757, "菜刀派、十二阿哥"], [1000, 121933, "或许"]], 
		//"awards": [["第1名", "5000金币+1快乐卡"], ["第2名", "2000金币+1快乐卡"], ["第3名", "1000金币+1快乐卡"], ["第4名", "4张快乐卡"], ["第5名", "3张快乐卡"], ["第6~9名", "1张快乐卡"]], 
		//"round": 0, "playing": true}, "tag": "recheckin", "type": "ddz7"}
		if(is131Happy){ ddz131.ProcessReChecking(messageObj); return;}
		JSONObject body = messageObj["body"];
		rulesPanel.initAward(body["awards"].list, rgtPanel.matchType);
		rgtPanel.gameObject.SetActive(false);
		resultAnima.hideAnima();
		if(rgtPanel.matchType != DDZRegtPanel.eMatchType.person3){
			//step == 2 是否是总决赛
			if(body["step"].n == 2){
				userPlayerCtrl.cMPInfoPanel.titleSpt.spriteName = "txtFinalVS";
			}
		}else{
			//{"body": {"deckn": 3, "fee": 10000, "ranks": [{"score": 0, "uid": 866627772, "rank": 0, "name": "bj123456789"}, {"score": 0, "uid": 126088, "rank": 1, "name": "世界上唯一我的"}, 
			//{"score": 0, "uid": 109659, "rank": 2, "name": "朦胧之恋"}], "playedtimes": 0, "playing": true, "awards": ["1:20000金币", "2:0金币", "3:0金币"], "round": 0}, "tag": "recheckin", "type": "ddz9"}
			leaderboard.initLeaderboard(body["ranks"].list, rgtPanel.matchType);
			int myrank = -1;
			int myscore = 0;
			for(int i=0; i< body["ranks"].Count; i++){
				JSONObject jobj = body["ranks"][i];
				if(jobj["uid"].n+"" == EginUser.Instance.uid){
					myrank = (int)jobj["rank"].n +1;
					myscore = (int)jobj["score"].n;
				}
			}
			leaderboard.updateSelfInfo(myrank,myscore);
			_userIntoMoney.text = myscore + "";
		}
	}

	private int kickCount=0;
	private void ProcessKick(JSONObject messageObj)
	{
//		if(!_isPlaying){
//			return;
//		}
		//114385玩家淘汰
		//{"body": {"kick_uid": 114385, "kick_name":"Jason li"}, "tag": "kick", "type": "ddz7"}
		JSONObject body = messageObj["body"];
		double uid = body["kick_uid"].n;
		string nickname = "";
		if(body["kick_name"] != null){
			nickname = body["kick_name"].str;
		}else{
			nickname = uid+"";
		}
		if(uid+"" == EginUser.Instance.uid){
			UserQuit();
		}else{
			DDZPlayerCtrl kickPlayer = getPlayerWithID((int)uid);
			if(kickPlayer == null){
				return;
			}
			GameObject tipPrb = SimpleFramework.Util.LoadAsset("GameDDZ/PFB","tipsLb") as GameObject;
			GameObject parentObj = settingPanel.transform.parent.Find("kickOutTip").gameObject;
			GameObject tipObj  = NGUITools.AddChild(parentObj, tipPrb);
			UILabel tipLb = tipObj.GetComponent<UILabel>();
			int tempK = kickCount%4;
			float delayValue = tempK*1.0f;
			tipLb.transform.localPosition = new Vector3(0, 118, 0);
			if(kickPlayer == null){
				tipLb.text = nickname + " 已被淘汰出比赛。";
			}else{
				tipLb.text = kickPlayer.nickNameStr + " 已被淘汰出比赛。";
			}
			tipLb.alpha = 0;
			iTween.MoveFrom(tipObj, iTween.Hash("y",-57.0f, "time", 1.0f,"islocal", true,"delay",delayValue,
				"easetype", iTween.EaseType.easeOutBack, "oncomplete","destroyTipLb","oncompletetarget",gameObject, "oncompleteparams", tipObj,
				"onstart","showTipLb","onstarttarget",gameObject, "onstartparams",tipLb) );
			kickCount++;
			GameObject player = GameObject.Find(_nnPlayerName + uid);
			if (_playingPlayerList.Contains(player))
			{
				_playingPlayerList.Remove(player);
			}
			if(player != null){
				Destroy(player);
			}
			int temp_total = int.Parse( userPlayerCtrl.cMPInfoPanel.totalRank.text);
			temp_total -= 1;
			userPlayerCtrl.cMPInfoPanel.totalRank.text = temp_total+"";
		}
	}

	private void ProcessNewRank(JSONObject messageObj)
	{
		//{"body": {"ranks": [["bj123456789", 2, 2500.0], ["男优", 12, 1300.0], ["芝伟", 15, 1100.0]], "lefttime": 76.4262669086, "step": 1, 
		//"top10": [[3800.0, 125497, "榮少"], [2500.0, 866627772, "bj123456789"], [2200.0, 126461, "离家人"], [2100.0, 121474, "末星空影"], [1700.0, 124796, "秒杀一方"], 
		//[1700.0, 116737, "郑郑郑"], [1600.0, 114865, "齐齐齐齐"], [1500.0, 109831, "哭色粉瑞泰科技"], [1500.0, 125077, "淘气的猫猫"], [1400.0, 106392, "神在看你"], [1400.0, 121476, "叮当猫网赚网"], 
		//[1300.0, 109781, "男优"], [1300.0, 117186, "顶替夫"], [1200.0, 120236, "一切情缘"], [1100.0, 115689, "芝伟"], [1000.0, 108732, "无敌小可乐"], [900.0, 123616, "龙城少主"], 
		//[900.0, 126717, "滴水"], [900.0, 119498, "8652"], [800.0, 114507, "拖呀拖呀"]], "cn": 29}, "tag": "newranks", "type": "ddz7"}
		if(messageObj["type"].str == "ddz7"){
			curRankInfo = messageObj;
//			dailyMatchResultAnima(messageObj);
		}else if(messageObj["type"].str == "ddz9"){
			//{"body": {"ranks": [{"score": 0, "uid": 866627772, "rank": 0, "name": "bj123456789"}, 
			//{"score": 0, "uid": 115299, "rank": 1, "name": "小李肥刀"}, {"score": 0, "uid": 118784, "rank": 2, "name": "晨露夕梅"}]}, "tag": "newranks", "type": "ddz9"}
			JSONObject body = messageObj["body"];
			int myrank = 1;
			int myscore = 1;
			for(int i=0; i<body["ranks"].list.Count; i++){
				if( body["ranks"].list[i]["uid"].n+"" == EginUser.Instance.uid){
					myrank = (int)body["ranks"].list[i]["rank"].n;
					myscore= (int)body["ranks"].list[i]["score"].n;
					break;
				}
			}
			leaderboard.initLeaderboard(body["ranks"].list, DDZRegtPanel.eMatchType.person3);
			if(rgtPanel.matchType == DDZRegtPanel.eMatchType.person3){
				myrank += 1;
			}
			leaderboard.updateSelfInfo(myrank,myscore);
			_userIntoMoney.text = myscore + "";
		}
	}

//	private void dailyMatchResultAnima(JSONObject messageObj){
//		//{"body": {"ranks": [["╮小", 10, 2400.0], ["七彩邪云", 52, 1300.0], ["ainilan2", 112, -900]], "top10": [[3900.0, 121607, "武小傻"], [3600.0, 123928, "annayaozhikun"], [3200.0, 107698, "秋天得风"], [2900.0, 120039, "月晓宇"], [2700.0, 117556, "不想赢"], [2600.0, 118004, "蓝色穹宇"], [2500.0, 121500, "mada"], [2500.0, 122102, "一了"], [2500.0, 110301, "按照相应"], [2400.0, 122049, "╮小"], [2400.0, 119656, "看的"], [2300.0, 116610, "叶末未晓"]], "cn": 114, "promotion_jushu": 0}, "tag": "newranks", "type": "ddz7"}
//		if(PlatformGameDefine.game.GameTypeIDs == "9"){
//			JSONObject body = messageObj["body"];
//			int myrank = 1;
//			int myscore = 1;
//			for(int i=0; i<body["ranks"].list.Count; i++){
//				if( body["ranks"].list[i][0].str == EginUser.Instance.nickname){
//					myrank = (int)body["ranks"].list[i][1].n;
//					myscore= (int)body["ranks"].list[i][2].n;
//					break;
//				}
//			}
//
//			leaderboard.initLeaderboard(body["ranks"].list, DDZRegtPanel.eMatchType.hour);
//			leaderboard.updateSelfInfo(myrank,myscore);
//			_userIntoMoney.text = myscore + "";
//
//			if(!_isPlaying){
//				if(myrank - resultAnima.roadmap.curRank <=0){
//					resultAnima.setTxt("rankUp");
//					resultAnima.playWin(myrank, (int)body["cn"].n);
//				}else{
//					resultAnima.setTxt("levelDown");
//					resultAnima.playLose(myrank, (int)body["cn"].n);
//				}
//			}
//		}
//	}

	private void ProcessDeskOver(JSONObject messageObj)
	{
		//{"body": false, "tag": "deskover", "type": "ddz7"}
		if(messageObj["tag"].str == "deskover"){
			isOut = messageObj["body"].b;
		}
		if(curRankInfo == null){
			Debug.LogError("Have not a rank message.");
		}
		if(!isGameOverAnimaPlaying){
			JSONObject body = curRankInfo["body"];// messageObj["body"];
			int myrank = 1;
			int myscore = 1;
			for(int i=0; i<body["ranks"].list.Count; i++){
#if UNITY_STANDALONE_WIN
				if( body["ranks"].list[i].list[0].str == _userNickname.text){
#else
				if( body["ranks"].list[i].list[0].str == EginUser.Instance.nickname){
#endif
					myrank = (int)body["ranks"].list[i].list[1].n;
					myscore= (int)body["ranks"].list[i].list[2].n;
					//myscore = myscore<=0?0:myscore;
					break;
				}
			}
			leaderboard.initLeaderboard(body["top10"].list, DDZRegtPanel.eMatchType.hour);
			leaderboard.updateSelfInfo(myrank,myscore);
			_userIntoMoney.text = myscore + "";

			if(!isFinalVS){
				if(isOut){
					resultAnima.setTxt("out");
					resultAnima.playLose(myrank, (int)body["cn"].n);
				}else{
					if(myrank - resultAnima.roadmap.curRank <=0){
						resultAnima.setTxt("rankUp");
						resultAnima.playWin(myrank, (int)body["cn"].n);
					}else{
						resultAnima.setTxt("levelDown");
						resultAnima.playLose(myrank, (int)body["cn"].n);
					}
					if(userPlayerCtrl.cMPInfoPanel.isFinalVS){
						resultAnima.waitTip("tipWaitOtherPlayer", 3);
					}else{
						resultAnima.waitTip("tipOpponentS", 3);
					}
				}
			}
			int lifeTime = -1;
			if(body["lefttime"] != null){
				lifeTime = (int)body["lefttime"].n;
			}
			userPlayerCtrl.cmpInfoInit(myrank, (int)body["cn"].n, lifeTime);
		}else{
			delayNewRankObj = curRankInfo;
			processHandle = ProcessDeskOver;
		}
	}

	private void ProcessShowAward(JSONObject messageObj)
	{
		//{"body": {"cn": 29, "gotticket": false, "top10": [[4900.0, 118553, "扬帆起航"], [3700.0, 116183, "乱战天下"], [3100.0, 126377, "郎图"], [2000.0, 124155, "为枫斩情"], 
		//[1900.0, 116814, "笨蛋飞儿"], [1600.0, 120000, "流星淚"], [1500.0, 117503, "da54s4d8as6"], [1500.0, 124214, "曼珠沙华；"], [1500.0, 109674, "毛哥威武"], [1500.0, 126748, "爱拼凑"], 
		//[1400.0, 114922, "男儿泪"], [1400.0, 118412, "zqylolq251016"], [1300.0, 127159, "半米阳光"], [1300.0, 110902, "喜欢玩游戏"], [1300.0, 123530, "倒转木鱼"], [1100.0, 117970, "猛哥来了"], 
		//[1000.0, 126168, "神说你去屎"], [1000.0, 114378, "跟风在打"], [800.0, 125544, "小青年好狂"], [800.0, 108915, "徐州龙溪堂茶业"]],
		//"award": "", "datetime": "2016-04-01 19:24:45", "item": 0, "reason": "cantrebuy", "rank": 29}, "tag": "sendaward", "type": "ddz7"}
		if(is131Happy){
			ddz131.ProcessShowAward(messageObj);
		}else{
			JSONObject body = messageObj["body"];
			showAward((int)body["rank"].n, body["award"].str);
		}
//		userPlayerCtrl.cmpInfoInit((int)body["rank"].n, (int)body["cn"].n, -1);
	}

	private void showAward(int rank, string awardInfo)
	{
		GameObject parentObj = settingPanel.transform.parent.Find("kickOutTip").gameObject;
		parentObj.SetActive(false);
		tipSpt.gameObject.SetActive(false);
		resultAnima.showAward( rank, awardInfo);
		userPlayerCtrl.cMPInfoPanel.stopAllInvoke();
		Transform rootTr = this.transform.parent.parent;
		Transform settingTr = rootTr.Find("Panel_Main/settingBtn");
		Transform footInfoTr = rootTr.Find("infoBtnLayer/footInfoAnchor");
		Transform backBtnTr  = rootTr.Find("Panel_Main/Button_back");
		Transform topInfoTr = userPlayerObj.transform.Find("Output");
		Transform topPanelNormal = this.transform.Find("Score");
		Transform topPanelMatch = this.transform.Find("CMPScore");
		foreach(GameObject playerObj in _playingPlayerList){
			playerObj.SetActive(false);
		}
		settingTr.gameObject.SetActive(false);
		footInfoTr.gameObject.SetActive(false);
		topInfoTr.gameObject.SetActive(false);
		backBtnTr.gameObject.SetActive(false);
		topPanelNormal.gameObject.SetActive(false);
		topPanelMatch.gameObject.SetActive(false);
		JSONObject userQuit = new JSONObject();
		userQuit.AddField("type", "game");
		userQuit.AddField("tag", "quit");
		base.SendPackageWithJson(userQuit);
		SocketConnectInfo.Instance.roomFixseat = true;	// For auto add desk.
		SocketManager.Instance.socketListener = null;
		SocketManager.Instance.Disconnect("ForRe");
		CancelInvoke("heartbeatHandle");
		CancelInvoke("checkNetwork");
	}
	private void ProcessUnitGrowStart(JSONObject messageObj)
	{
		//{"body": 120, "tag": "unitgrow_start", "type": "ddz7"}
		userPlayerCtrl.cMPInfoPanel.startScorePlusCD( (int)messageObj["body"].n );
	}
	private void ProcessGrowUpTip(JSONObject messageObj)
	{
		//{"body": 10, "tag": "unitgrowtip", "type": "ddz7"}
		userPlayerCtrl.cMPInfoPanel.startScorePlusCD( (int)messageObj["body"].n , true);
		popupTipText("tipScoreDouble");
	}
	private void ProcessRelive(JSONObject messageObj){
		//{"body": {"reason": "", "rebuyscore": 1200, "rebuymoney": 5000, "timeout": 12, "rebuytimes": 0}, "tag": "wantrebuy", "type": "ddz7"}
		//整点赛复活
		JSONObject body = messageObj["body"];
		GameObject reliveDialogPrb = SimpleFramework.Util.LoadAsset("GameDDZ/PFB","reliveDialog") as GameObject;
		GameObject reliveDialogObj  = NGUITools.AddChild(transform.parent.parent.gameObject, reliveDialogPrb);
		ReliveDialog reliveD = reliveDialogObj.GetComponent<ReliveDialog>();
		reliveD.initData(3-(int)body["rebuytimes"].n, (int)body["rebuymoney"].n, (int)body["timeout"].n);
		reliveD.yesBtn.onClick.Add(new EventDelegate( ()=>{ Destroy(reliveDialogObj); } ));
		reliveD.yesBtn.onClick.Add(new EventDelegate(this, "reliveOk"));
		reliveD.noBtn.onClick.Add(new EventDelegate(this, "reliveCancel"));
		reliveD.noBtn.onClick.Add(new EventDelegate( ()=>{ Destroy(reliveDialogObj); } ));
	}
	private void ProcessReliveTimeup(JSONObject messageObj=null){
		//{"body": "", "tag": "cantrebuy", "type": "ddz7"}
		GameObject tipReliveTimeupPrb = SimpleFramework.Util.LoadAsset("GameDDZ/PFB","tipReliveTimeup") as GameObject;
		GameObject tipObj  = NGUITools.AddChild(settingPanel.transform.parent.gameObject, tipReliveTimeupPrb);
		tipObj.transform.localPosition = new Vector3(0, 118, 0);
		iTween.MoveFrom(tipObj, iTween.Hash("y",-57.0f, "time", 2.0f,"islocal", true,
			"easetype", iTween.EaseType.easeOutBack, "oncomplete","destroyTipLb","oncompletetarget",gameObject, "oncompleteparams", tipObj) );

	}
	private void hideReliveTimeup()
	{
		if(_isPlaying){
			resultAnima.tipSpt.gameObject.SetActive(false);
		}
	}
	private void reliveOk()
	{
		//receive:{"body": {"rebuyscore": 600}, "tag": "rebuy", "type": "ddz7"}
		JSONObject sendMgs = new JSONObject();
		sendMgs.AddField("type", "ddz7");
		sendMgs.AddField("tag", "rebuy");
		sendMgs.AddField("body", true);
		base.SendPackageWithJson(sendMgs);
	}
	private void reliveCancel()
	{
		JSONObject sendMgs = new JSONObject();
		sendMgs.AddField("type", "ddz7");
		sendMgs.AddField("tag", "rebuy");
		sendMgs.AddField("body", false);
		base.SendPackageWithJson(sendMgs);
	}

	private void ProcessRoundover(JSONObject messageObj){
		//{"body": {"ranks": [{"score": 900, "uid": 889657154, "rank": 0, "name": "罐头食物"}, {"score": 900, "uid": 125687, "rank": 1, "name": "诱人丁字裤"}, 
		//{"score": -1800, "uid": 119025, "rank": 2, "name": "柒鬼"}], "outmen": [{"money": 0, "hpcard": 1, "uid": 889657154, "unit": 0, "item": 0}, 
		//{"money": 0, "hpcard": 0, "uid": 125687, "unit": 0, "item": 0}, {"money": 0, "hpcard": 0, "uid": 119025, "unit": 0, "item": 0}], 
		//"round": 0, "datetime": "2016-05-25"}, "tag": "roundover", "type": "ddz9"}

		if(messageObj["type"].str == "ddz9"){
			JSONObject body = messageObj["body"];
			int rank = 1;
			string awardInfo = "";
			List<JSONObject> ranksList = body["ranks"].list;
			foreach(JSONObject jobj in ranksList){
				if(jobj["uid"].n+"" == EginUser.Instance.uid){
					rank = (int)jobj["rank"].n+1;
					break;
				}
			}
			foreach(JSONObject obj2 in body["outmen"].list){
				if(obj2["uid"].n+"" == EginUser.Instance.uid){
					if(obj2["money"].n > 0){
						awardInfo = obj2["money"].n+"金币";
					}
					if(obj2["hpcard"].n > 0){
						if(awardInfo.Length > 0){
							awardInfo += " + ";
						}
						awardInfo += obj2["hpcard"].n+"快乐卡";
					}
				}
			}
			showAward(rank, awardInfo);
		}
	}

	private IEnumerator ProcessWaitOver(JSONObject messageObj){
		//等待决赛排名Receive->{"body": 1, "tag": "wait_over", "type": "ddz7"}
		if(isGameOverAnimaPlaying){
			yield return new WaitForSeconds(2.5f);
		}else{
			yield return new WaitForSeconds(0.2f);
		}
		if(!resultAnima.awardObj.activeSelf){
			resultAnima.waitTip("tipWaitResult");
		}
	}

	public void showLeaderboard()
	{
		if(is131Happy){
			ddz131.showLeaderboard();
		}else{
			leaderboard.gameObject.SetActive(true);
			leaderboard.transform.localScale = Vector3.one;
			iTween.ScaleFrom(leaderboard.gameObject, iTween.Hash("scale",new Vector3(0.7f, 0.7f,1.0f), "time", 0.3f,
				"easetype", iTween.EaseType.easeOutBack) );
		}
	}
	public void showRules()
	{
		if(is131Happy){
			ddz131.showRulesPanel();
		}else{
			rulesPanel.gameObject.SetActive(true);
			rulesPanel.transform.localScale = Vector3.one;
			iTween.ScaleFrom(rulesPanel.gameObject, iTween.Hash("scale",new Vector3(0.7f, 0.7f,1.0f), "time", 0.3f,
				"easetype", iTween.EaseType.easeOutBack) );
		}
	}

	public void popupTipText(string sptName, bool needAnima=true)
	{
		tipSpt.gameObject.SetActive(true);
		tipSpt.spriteName = sptName;
		tipSpt.MakePixelPerfect();
		tipSpt.transform.localPosition = Vector3.zero;
		if(needAnima){
			iTween.MoveFrom(tipSpt.gameObject, iTween.Hash("y",-77.0f, "time", 1.0f,"islocal", true,
				"easetype", iTween.EaseType.easeOutBack, "oncomplete","hideTipSpt","oncompletetarget",gameObject) );
		}
	}
//	public IEnumerator delayShowTips(string sptName, float sec){
//		yield return new WaitForSeconds(sec);
//		tipSpt.gameObject.SetActive(true);
//		tipSpt.spriteName = sptName;
//		tipSpt.MakePixelPerfect();
//	}

	private void hideTipSpt(){ tipSpt.gameObject.SetActive(false); }
	private void showTipLb(UILabel obj){ obj.alpha=1; }
	private void destroyTipLb(GameObject obj){ Destroy(obj); }

	public void btnHandleRgt()
	{
		Debug.Log("btnHandleRgt");
		btnHandleRgtFlow();
	}
	private void btnHandleRgtFlow()
	{
//		JSONObject userQuit = new JSONObject();
//		userQuit.AddField("type", "game");
//		userQuit.AddField("tag", "quit");
//		base.SendPackageWithJson(userQuit);

//		EginUserUpdate.Instance.UpdateInfoNow();
//		resultAnima.awardObj.SetActive(false);
//		if(rgtPanel != null){
//			rgtPanel.gameObject.SetActive(true);
//		}
//		userPlayerCtrl.cMPInfoPanel.resetState();
//		yield return new WaitForSeconds(1.0f);
//		SocketManager.Instance.socketListener = this;
		SocketManager.Instance.Connect(SocketConnectInfo.Instance);
//		base.StartGameSocket();
		PlatformGameDefine.game.StartGame();
	}
	#endregion

	#region 斗地主现场版相关
	private void show131ScorePanel(int bombCount, int springCount)
	{
		if(liveroomScoreboard == null){
			GameObject panelPrb = SimpleFramework.Util.LoadAsset("GameDDZ/LiveRoomScorePanel","LiveRoomScorePanel") as GameObject;
			liveroomScoreboard = NGUITools.AddChild(transform.parent.parent.Find("infoBtnLayer").gameObject, panelPrb);
		}else{
			liveroomScoreboard.SetActive(true);
		}
		_playingPlayerList.Sort( (GameObject a, GameObject b)=>{  
			if(a.GetComponent<DDZPlayerCtrl>().liveRoomScore < b.GetComponent<DDZPlayerCtrl>().liveRoomScore){
				return 1;
			}else if(a.GetComponent<DDZPlayerCtrl>().liveRoomScore == b.GetComponent<DDZPlayerCtrl>().liveRoomScore){
				return 0;
			}else if(a.GetComponent<DDZPlayerCtrl>().liveRoomScore > b.GetComponent<DDZPlayerCtrl>().liveRoomScore){
				return -1;
			}else{
				return -1;
			}
		});
		for(int i=0; i<3; i++){
			DDZPlayerCtrl playCtrl = _playingPlayerList[i].GetComponent<DDZPlayerCtrl>();
			UILabel nameTxt = liveroomScoreboard.transform.Find("list/item"+i+"/name").GetComponent<UILabel>();
			UISprite arrowSpt = liveroomScoreboard.transform.Find("list/item"+i+"/arrow").GetComponent<UISprite>();
			if(playCtrl.isMyself){
				Debug.LogError(i +"==========>" +nameTxt.text);
				if(i==0){
					if(nameTxt.text != _userNickname.text && nameTxt.text.Length != 0){
						arrowSpt.gameObject.SetActive(true);
					}else{
						arrowSpt.gameObject.SetActive(false);
					}
				}else if(i == 1){
					if(nameTxt.text != _userNickname.text && nameTxt.text.Length != 0){
						arrowSpt.gameObject.SetActive(true);
						if(liveroomScoreboard.transform.Find("list/item2/name").GetComponent<UILabel>().text != _userNickname.text){
							arrowSpt.spriteName = "lrankDown";
						}else{
							arrowSpt.spriteName = "lrankUp";
						}
					}else{
						arrowSpt.gameObject.SetActive(false);
					}
				}else{
					if(nameTxt.text != _userNickname.text && nameTxt.text.Length != 0){
						arrowSpt.spriteName = "lrankDown";
						arrowSpt.gameObject.SetActive(true);
					}else{
						arrowSpt.gameObject.SetActive(false);
					}
				}
				nameTxt.text = _userNickname.text;
			}else{
				Debug.LogError(i +"---------->" +nameTxt.text);
				if(i==0){
					if(nameTxt.text != playCtrl.nickNameStr && nameTxt.text.Length != 0){
						arrowSpt.gameObject.SetActive(true);
					}else{
						arrowSpt.gameObject.SetActive(false);
					}
				}else if(i == 1){
					if(nameTxt.text != playCtrl.nickNameStr && nameTxt.text.Length != 0){
						arrowSpt.gameObject.SetActive(true);
						if(liveroomScoreboard.transform.Find("list/item2/name").GetComponent<UILabel>().text != playCtrl.nickNameStr){
							arrowSpt.spriteName = "lrankDown";
						}else{
							arrowSpt.spriteName = "lrankUp";
						}
					}else{
						arrowSpt.gameObject.SetActive(false);
					}
				}else{
					if(nameTxt.text != playCtrl.nickNameStr && nameTxt.text.Length != 0){
						arrowSpt.spriteName = "lrankDown";
						arrowSpt.gameObject.SetActive(true);
					}else{
						arrowSpt.gameObject.SetActive(false);
					}
				}
				nameTxt.text = playCtrl.nickNameStr;
			}
			if(arrowSpt.gameObject.activeSelf){
				iTween.ScaleFrom(arrowSpt.gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
					"easetype", iTween.EaseType.easeOutBack) );
			}
			liveroomScoreboard.transform.Find("list/item"+i+"/score").GetComponent<UILabel>().text = _playingPlayerList[i].GetComponent<DDZPlayerCtrl>().liveRoomScore+"";
		}
		liveroomScoreboard.transform.Find("txtLbomb/count").GetComponent<UILabel>().text = bombCount+"";
		liveroomScoreboard.transform.Find("txtLspring/count").GetComponent<UILabel>().text = springCount+"";
	}
	private void hideScorePanel()
	{
		if(!isLiveRoom)return;
		if(liveroomScoreboard != null){
			liveroomScoreboard.SetActive(false);
		}
//		Transform tr = transform.parent.parent.FindChild("infoBtnLayer/LiveRoomScorePanel(Clone)");
//		if(tr != null){
//			Destroy(tr.gameObject);
//		}
	}
	#endregion

	#if PC_RECORD
	#region PC 录制相关

	public void popupMp4PathDialog()
	{
		recordDialog.SetActive(true);
		UTJ.MP4Recorder mp4Recrod = this.transform.parent.GetComponent<UTJ.MP4Recorder>();
		recordDialog.transform.FindChild("des").GetComponent<UILabel>().text = mp4Recrod.GetOutputPath();
	}
	public void closePathDialog()
	{
		recordDialog.SetActive(false);
	}
	private int recordTime = 0;
	private void recordTimeInvoke()
	{
		recordTime++;
		recordBtn.transform.FindChild("recordTime").GetComponent<UILabel>().text = recordTime+"";
	}
	#endregion
	#endif
}
