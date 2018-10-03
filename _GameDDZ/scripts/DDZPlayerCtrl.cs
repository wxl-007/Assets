using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZPlayerCtrl : MonoBehaviour {
    public GameDDZ myDDZ;
    public GlobalVar.PlayerPosition position;

	//act bubble sprite name enum.  value means sprite name.
	public enum eActType{ call, nocall, multiple, nomul, pass, loot, noloot, show , score1, score2,score3}
    /// <summary>
    /// 提示字“准备”
    /// </summary>
    public GameObject readyObj;

	public UIPanel headClip;

	public Animator coinAnima;
	public UISprite coinMultipleSpt;

    /// <summary>
    ///  提示字"等待中"
    /// </summary>
    public GameObject waitObj;

    /// <summary>
    /// 玩家头像
    /// </summary>
    public UISprite userAvatar;

    /// <summary>
    /// 玩家昵称
    /// </summary>
    public UILabel userNickname;

    /// <summary>
    /// 玩家带入金额
    /// </summary>
    public UILabel userIntomoney;


    /// <summary>
    /// 扑克牌的父物体
    /// </summary>
    public Transform cardsTrans;
	/// <summary>
	/// Only myself playerctrl has this prb.
	/// </summary>
	public GameObject clearDeckTag;
	public GameObject cantHandleTag;

    public AudioClip soundSend;

    public GameObject infoDetail;
    public UILabel kDetailNickname;
    public UILabel kDetailLevel;
    public UILabel kDetailBagmoney;
	public UILabel cardCountLb;
	public UILabel scoreLb;
	public UILabel multipleLb;

	public GameObject managedFlag;
	public GameObject disconnectFlag;

    //扑克牌父物体的位置
    private float parentX = 113;
    private float parentY = 30;
    private float parentZ = 0;

    /// <summary>
    /// 牌间距
    /// </summary>
    private const float _cardInterval = 50;

    private const string _cardPre = "card_";

    private const float _timeInterval = 3;
    private float _timeLasted;
    private string bankerid_s;
	private int _drawCount = 0;

	public int avatarID;
	private UIAtlas originAvatarAtlas;
	public UIAtlas  ddzAvatarAnimaAtlas;
	/// <summary>
	/// How many cards in your hand. 
	/// Dont try to change this value, should be from server side.
	/// </summary>
	private int cardCount = 0;
	public  string uid;
    /// <summary>
    /// 提示信息
    /// </summary>
    public UILabel promptMessage;
	public TextAnima resultScoreTxt;

	public bool isBanker = false;
	public bool isFemale = false;
	public bool isShowDeck = false;
	public bool isManaged = false;
	private float originDeskCtrlX;

	public UISprite chatBubble;
	public UISprite actBubble;
	public UISprite avatarFrame;
	public UISprite avatarIcon;

	public UISpriteAnimation vfxSmoke;
	public UISpriteAnimation vfxWarning;

	public CMPInfoPanel cMPInfoPanel;
	public GameObject   ddz3RoundPanel;
	public UILabel      ddz3RoundLb;

	private  float leftEdge = -573f;//-427.5f;
	private  float cardPadding2 = 60.0f;//45.0f;
	private  float cardPadding = 70.0f;//45.0f;

	private Dictionary<string , string> animaDc = new Dictionary<string, string>();
	public string nickNameStr;

	private bool _isObserver = false;
	public bool isObserver{
		set{
			_isObserver = value;
			liveRoomObState();
		}
		get{
			return _isObserver;
		}

	}
	public int liveRoomScore = 0;

	public UILabel obCreateLbUserName;//observer mode used.
	public UILabel obCreateLbScore;//observer mode used.

    void Awake()
    {
        //		parentX = cardsTrans.localPosition.x ;
        parentY = cardsTrans.localPosition.y;
        parentZ = cardsTrans.localPosition.z;
		chatBubble.gameObject.SetActive(false);
		actBubble.gameObject.SetActive(false);
		vfxSmoke.gameObject.SetActive(false);
		resultScoreTxt.gameObject.SetActive(false);
		if(cardCountLb != null){
			cardCountLb.text = "";
		}
		if(vfxWarning != null){
			vfxWarning.gameObject.SetActive(false);
		}
		originAvatarAtlas = avatarIcon.atlas;
		originDeskCtrlX = deskcardCtrl.transform.localPosition.x;

		animaDc["auto"] = "_d_";
		animaDc["idle"] = "_i_";
		animaDc["speak"] = "_s_";
		animaDc["handle"] = "_h_";
		animaDc["pass"] = "_p_";
		animaDc["win"] = "_win";
		animaDc["lose"] = "_lose";
		animaDc["default"] = "_default";
		if(avatarIcon.GetComponent<UISpriteAnimation>() != null){
			avatarIcon.GetComponent<UISpriteAnimation>().enabled = false;
		}
    }
    void Start()
    {
		if(myDDZ != null && !myDDZ.isMatch){
			cMPInfoPanel.gameObject.SetActive(false);
		}else if(myDDZ != null && myDDZ.isMatch){
			if(PlatformGameDefine.game.GameTypeIDs == "7" || PlatformGameDefine.game.GameTypeIDs == "8"){
				cMPInfoPanel.gameObject.SetActive(false);
				ddz3RoundPanel.SetActive(true);
			}
			if(myDDZ.is131Happy){
				cMPInfoPanel.gameObject.SetActive(false);
				scoreLb.transform.parent.gameObject.SetActive(false);
			}
		}
//		StartCoroutine( unitTest() );
//		StartCoroutine( unitTest2() );
//		unitTest3();

//		playCoinAnima(2);
//		SetReady(true);
//		Debug.LogError( DDZTip.sortCards(new JSONObject("[1,0,13,26]").list, 3)[0].n);
//		StartCoroutine( showDeck(new JSONObject("[26,39,1,2,42,4,30,43,31,6,45,47,35,49,37,51,53]").list) );
//		StartCoroutine(test334455(new JSONObject("[0,46,33]").list));
//		testSort();
//		deskcardCtrl.drawCards(new JSONObject("[26,39,1,2,42,4,30,43,31,6,45,47,35,49,37,51,53]").list, 5,true);
//		deskcardCtrl.drawCards(new JSONObject("[12,25,38,51]").list,1,true);
    }

	private void testSort()
	{
		List<JSONObject> list = new JSONObject("[0,3,4,7,12,30,6,44,26,37]").list;
		List<DDZPokerData> pdList = new List<DDZPokerData>();
		for(int i=0; i<list.Count; i++){
			DDZPokerData pd = new DDZPokerData( (int)list[i].n );
			pdList.Add(pd);
		}
		pdList.Sort(compress1);
		for(int i=0; i<pdList.Count; i++){
			Debug.Log(pdList[i].ToString());
		}
	}

	private int compress1(DDZPokerData pd1, DDZPokerData pd2)
	{
		if((int)pd1.pokerNum > (int)pd2.pokerNum){
			return 1;
		}else if((int)pd1.pokerNum < (int)pd2.pokerNum){
			return -1;
		}else{
			return 0;
		}
	}


	private IEnumerator test334455(List<JSONObject> list)
	{
		yield return new WaitForSeconds(5.0f);
		Addbankercards(list);
	}

	private IEnumerator unitTest()
	{
//		string jsonStr = Resources.Load<TextAsset>("dealMgsError").text;
		string jsonStr = Resources.Load<TextAsset>("dealMgs 2").text;
		JSONObject messageObj = new JSONObject(jsonStr);
		JSONObject body = messageObj["body"];
		List<JSONObject> cards = body["mycards"].list;
		SetDeal(cards);

		yield return new WaitForSeconds(5);

		//[9,13,46]
		//dealMgs 3  [42,23,40]
		JSONObject jsonObj = new JSONObject("[42,23,40]");
//		JSONObject jsonObj = new JSONObject("[0,23,53]");
		Addbankercards(jsonObj.list );

//		Addbankercards( body["hide_card"].list );
	}

	private IEnumerator unitTest2()
	{
		yield return new WaitForSeconds(3);
//		JSONObject jsonObj = new JSONObject("[42,23,40]");
//		deskcardCtrl.drawCards(jsonObj.list);
//		JSONObject jsonObj2 = new JSONObject("[0,13,26,14,40,2,15,28,16,30,44,6,19,45,7,8,48,49,24,53]");
//		showDeck(jsonObj2.list);

//		if(!isMyself){
//			showDeck(new JSONObject("[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]").list);
//		}
	}

	private void unitTest3()
	{
//		JSONObject jsonObj2 = new JSONObject("[0,13,26,14,40,2,15,28,16,30,44,6,19,45,7,8,48,49,24,12]");
//		JSONObject jsonObj2 = new JSONObject("[26,1,2,15,28,16,29,42,30,17,4,44,45,7,8,48,23,36,49,24]");//AAABBB
		JSONObject jsonObj2 = new JSONObject("[26,39,1,2,42,4,30,43,31,6,45,47,35,49,37,51,53]");//53,51,37,49,35,47,45,6,31,43,30,4,42,2,1,39,26
//		JSONObject jsonObj2 = new JSONObject("[0, 39, 28, 16, 42, 4, 43, 19, 32, 46, 8, 34, 9, 22, 23, 36, 25]");
//		JSONObject jsonObj2 = new JSONObject("[4, 5, 6, 7, 8]");
//		SetDealTest(jsonObj2.list);
		SetDeal2(jsonObj2.list);
	}

	public void testSSSS()
	{
		calcSelCards();
		drawCard(null);
	}

	public void testTip()
	{
		//单张0，对子1，三张2，三带单3，三带对4，单顺5，双顺6，飞机7，飞机带单8，飞机带双9，四带两单10，炸弹12，火箭13
		//3-> 0, 13, 26, 39
		//6-> 3, 16, 29, 42
//		JSONObject jsonObj2 = new JSONObject("[0,13,1,14,2,15]");
		Debug.LogError("testTip");
//		JSONObject jsonObj2 = new JSONObject("[ 2,15, 28,40]");
//		JSONObject jsonObj2 = new JSONObject("[ 0,13, 26,40]");
		JSONObject jsonObj2 = new JSONObject("[0]");
//		JSONObject jsonObj2 = new JSONObject("[ 3, 16, 4, 17, 5,18]");//AABBCC
//		JSONObject jsonObj2 = new JSONObject("[29,16,29,42]");//AAAA
//		JSONObject jsonObj2 = new JSONObject("[0, 13, 26, 39]");//AAAA
//		JSONObject jsonObj2 = new JSONObject("[29,16,29,42, 0, 4]");//AAAA_12
//		JSONObject jsonObj2 = new JSONObject("[ 0, 13, 26, 1,14,27, 2,3 ]");//AAABBB_12
//		JSONObject jsonObj2 = new JSONObject("[ 0, 13, 26, 1,14,27, 2,15,3,16 ]");//AAABBB_NN
		List<GameObject> result = DDZTip.tip(usercards, jsonObj2.list, 0);
//		List<GameObject> result = DDZTip.tip(usercards, null, 0);
		for(int i=0; i<usercards.Count; i++){
			usercards[i].GetComponent<DDZPlayercard>().resetState();
		}
		foreach(GameObject obj in result){
			obj.GetComponent<DDZPlayercard>().Buttonc();
		}
	}

	public void tip(bool isMainDraw, List<JSONObject> cardsData =null, int cardType= -1)
	{
		List<GameObject> result = null;
		if(isMainDraw){
			result = DDZTip.tip2(usercards);
		}else{
			result = DDZTip.tip(usercards, cardsData, cardType);
		}
		for(int i=0; i<usercards.Count; i++){
			usercards[i].GetComponent<DDZPlayercard>().resetState();
		}
//		for(int i=0; i<readycards.Count; i++){
//			readycards[i].GetComponent<DDZPlayercard>().resetState();
//		}
		readycards.Clear();
		readysendcardList.Clear();
		foreach(GameObject obj in result){
//			obj.GetComponent<DDZPlayercard>().Buttonc();
			obj.GetComponent<DDZPlayercard>().selectCard();
		}

		for(int i=0; i< usercards.Count; i++){
			if( usercards[i].GetComponent<DDZPlayercard>().isSelected){
				myDDZ.btnGroup.enableDrawBtn(true);
				return;
			}
		}
		myDDZ.btnGroup.enableDrawBtn(false);
	}

	private List<List<GameObject>> tipList = new List<List<GameObject>>();
	private int tipIndex = 0;
	private void flashTipInit(List<JSONObject> cardsData)
	{
		tipList = DDZTip2.tishiWrap(usercards, cardsData);
	}
	public void clearTipData()
	{
		tipIndex =0; 
		tipList.Clear();
	}
	public void flashTip(List<JSONObject> cardsData)
	{
		if(tipList.Count == 0){
			flashTipInit(cardsData);
		}
		if(tipList.Count > 0){
			List<GameObject> tipTarget = tipList[tipIndex];
			tipIndex++;
			tipIndex=tipIndex%tipList.Count;

			for(int i=0; i<usercards.Count; i++){
				usercards[i].GetComponent<DDZPlayercard>().resetState();
			}
			readycards.Clear();
			readysendcardList.Clear();
			List<JSONObject> cardDataToServer = new List<JSONObject>();
			foreach(GameObject obj in tipTarget){
				obj.GetComponent<DDZPlayercard>().selectCard();
				if(myDDZ != null){
					if(myDDZ.isLiveRoom){
						cardDataToServer.Add( new JSONObject(obj.GetComponent<DDZPlayercard>().pokerD.cardID));
					}
				}
			}
			for(int i=0; i< usercards.Count; i++){
				if( usercards[i].GetComponent<DDZPlayercard>().isSelected){
					myDDZ.btnGroup.enableDrawBtn(true);
					if(myDDZ != null){
						if(myDDZ.isLiveRoom){
							myDDZ.sendSelectCardMsg(new JSONObject (cardDataToServer.ToArray()));
						}
					}
					return;
				}
			}
			myDDZ.btnGroup.enableDrawBtn(false);
		}
	}

	public bool selTip(List<GameObject> selC,bool isMainDraw, List<JSONObject> cardsData =null, int cardType= -1){
		List<GameObject> result = null;
		if(isMainDraw){
			result = DDZTip.tip2(selC);
		}else{
			result = DDZTip.tip(selC, cardsData, cardType);
		}
//		DDZTip._preCards = null;
		for(int i=0; i<selC.Count; i++){
			bool isMatch = false;
			foreach(GameObject obj in result){
				if(selC[i] == obj){
					isMatch = true;
					break;
				}
			}
			if(isMatch){
				selC[i].GetComponent<DDZPlayercard>().selectCard();
			}else{
				selC[i].GetComponent<DDZPlayercard>().resetState();
			}
		}
		selCardHandle();
		return result.Count != 0;
	}

	public bool checkCanHandle(bool flashVer, List<JSONObject> cardsData)
	{
		List<List<GameObject>> tempCheckList = DDZTip2.tishiWrap(usercards, cardsData);
		if(tempCheckList.Count == 0){
			cantHandleTag.SetActive(true);
			return false;
		}else{
			cantHandleTag.SetActive(false);
			return true;
		}
	}

	//dont use for now 2016.3.11
//	public bool checkCanHandle(List<JSONObject> cardsData =null, int cardType= -1, bool isLtoH = false)
//	{
//		DDZTip._preCards = null;
//		List<GameObject> result = DDZTip.tip(usercards, cardsData, cardType, isLtoH);
//		DDZTip._preCards = null;
//		if(result.Count == 0){
//			cantHandleTag.SetActive(true);
//			return false;
//		}else{
//			cantHandleTag.SetActive(false);
//			return true;
//		}
//	}

	public bool checkSelCard(bool flashVer, List<JSONObject> cardsData =null, int cardType= -1)
	{
		List<GameObject> selCard = new List<GameObject>();
		for(int i=0; i< usercards.Count; i++){
			if( usercards[i].GetComponent<DDZPlayercard>().isSelected){
				selCard.Add(usercards[i]);
			}
		}

		List<DDZPokerData> pdList = getPokeDList(selCard);
		
		List<int> pdType = DDZTip2.typePai(pdList);
		if(pdType.Count>0){
			if(cardsData == null){
				return true;
			}
			List<DDZPokerData> prePdList = getPokeDList(cardsData);
			if( DDZTip2.isCheckChu( pdType, DDZTip2.typePai(prePdList)) ){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}

	public bool checkSelCard(List<JSONObject> cardsData =null, int cardType= -1)
	{
		List<GameObject> selCard = new List<GameObject>();
		for(int i=0; i< usercards.Count; i++){
			if( usercards[i].GetComponent<DDZPlayercard>().isSelected){
				selCard.Add(usercards[i]);
			}
		}
//		List<GameObject> result = DDZTip.tip(selCard, cardsData, cardType);
//		DDZTip._preCards = null;


		int checkCardType = DDZTip.isAllowType(selCard);
		Debug.LogError("Check cardType:"+ checkCardType);
		if(checkCardType != -1){
			if(checkCardType == cardType){
				if(selCard.Count != cardsData.Count){
					return false;
				}
				List<GameObject> result = DDZTip.tip(selCard, cardsData, cardType);
				return result.Count>0;
			}else if(checkCardType == 12 || checkCardType == 13){
				//炸弹12，火箭13
				List<GameObject> result = DDZTip.tip(selCard, cardsData, cardType);
				return result.Count>0;
			}else{
				return false;
			}

		}else{
			return false;
		}
	}

	public void resetState()
	{
		isBanker = false;
		isShowDeck = false;
		isDealCardCom = false;
		_drawCount = 0;
		resultScoreTxt.gameObject.SetActive(false);
		if(isMyself){
			clearDeckTag.SetActive(false);
			cardsTrans.transform.localPosition = new Vector3(0, parentY, parentZ);
		}

		if(cardCountLb != null){
			cardCountLb.text = "";
		}
		if(vfxWarning != null){
			vfxWarning.gameObject.SetActive(false);
		}
		if(cantHandleTag != null){
			cantHandleTag.SetActive(false);
		}
		if(managedFlag != null){
			managedFlag.SetActive(false);
		}
		if(disconnectFlag != null){
			disconnectFlag.SetActive(false);
		}

		readycards.Clear();
		readysendcardList.Clear();
		deskcardCtrl.clearCards();
		if(deskcardCtrl.deskCardType != DeskCardCtrl.eDeskCardType.bottom){
			deskcardCtrl.transform.localPosition = new Vector3(originDeskCtrlX, 0,0);
		}

		resetBankercards(false);
		clearTipData();
	}

	public void drawCountPlus()
	{
		_drawCount++;
	}
	public int drawCount{get{return _drawCount;}}

	public void updateCardCount(int serverCardCount, bool ignoreWarning = false)
	{
		cardCount = serverCardCount;
		if(!isMyself){
			if(!isShowDeck){
				if(cardCount == 0){
					cardCountLb.text = "";
				}else{
					cardCountLb.text = cardCount+"";
				}
			}else{
				cardCountLb.text = "";
			}
			if(!ignoreWarning){
				if(cardCount<=2 && cardCount >0){
					vfxWarning.gameObject.SetActive(true);
					vfxWarning.playWithCallback();
					if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.left){
						deskcardCtrl.transform.localPosition = new Vector3(192.0f,0,0);
					}else if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.right){
						deskcardCtrl.transform.localPosition = new Vector3(-191.0f,0,0);
					}
					if(DDZSoundMgr.sfxSound){
						DDZSoundMgr.instance.playEft("sound/sound_baojing");
					}
					if(cardCount == 2){
						DDZSoundMgr.instance.playRandEftDc("last2Cards", isFemale);
					}else if(cardCount == 1){
						DDZSoundMgr.instance.playRandEftDc("last1Card", isFemale);
					}
				}else if(cardCount == 0){
					vfxWarning.gameObject.SetActive(false);
				}
			}
		}else{
			if(isObserver && cardCountLb != null){
				if(cardCount == 0){
					cardCountLb.text = "";
				}else{
					cardCountLb.text = cardCount+"";
				}
			}
		}
	}

	public void SetPlayerInfo(int avatar, string nickname, string intomoney, string level, bool isMatch=false, bool isLiveRoom=false)
    {
		avatarID = avatar;
        userAvatar.spriteName = "avatar_" + avatar;
        userNickname.text = nickname;
		nickNameStr = nickname;
		if(!isMatch){
			userIntomoney.text = "¥ " + EginTools.NumberAddComma(intomoney);
		}else{
			BoxCollider bc = avatarIcon.gameObject.GetComponent<BoxCollider>();
			if(bc != null){
				bc.enabled = false;
			}
			userIntomoney.text = intomoney;
		}

        kDetailNickname.text = nickname;
        kDetailLevel.text = level;
        kDetailBagmoney.text = intomoney;

		if(isLiveRoom){
			userIntomoney.text = liveRoomScore+"";
			kDetailBagmoney.text = liveRoomScore+"";
		}

		if(avatar%2 == 0){
			isFemale = false;
		}else{
			isFemale = true;
		}

    }

	private void liveRoomObState()
	{
		if(isObserver){
			if(gameObject.GetComponent<UIAnchor>().side == UIAnchor.Side.TopLeft){
				actBubble.transform.localPosition = new Vector3(425.0f,78.0f,0);
			}else if(gameObject.GetComponent<UIAnchor>().side == UIAnchor.Side.TopRight){
				actBubble.transform.localPosition = new Vector3(-425.0f,78.0f,0);
			}else{
				actBubble.transform.localPosition = new Vector3(381.0f,96.0f,0);
			}
			if(userNickname == null)return;
			userNickname.color = Color.white;
			userIntomoney.color = Color.white;
			userNickname.effectStyle = UILabel.Effect.None;
			userIntomoney.effectStyle = UILabel.Effect.None;
			if(gameObject.GetComponent<UIAnchor>().side == UIAnchor.Side.TopLeft){
				userNickname.transform.localPosition = new Vector3(280.0f, 28.0f, 0);
				userIntomoney.transform.localPosition = new Vector3(285.0f, -30.0f, 0);
				resultScoreTxt.transform.localPosition = new Vector3(268.0f, 162.0f,0);
				readyObj.transform.localPosition = new Vector3(282.0f, 79.0f,0);
				cardCountLb.transform.localPosition = new Vector3(300.0f,90.0f,0);
			}else{
				userNickname.transform.localPosition = new Vector3(-280.0f, 28.0f, 0);
				userIntomoney.transform.localPosition = new Vector3(-285.0f, -30.0f, 0);
				resultScoreTxt.transform.localPosition = new Vector3(-272.3f, 162.0f,0);
				readyObj.transform.localPosition = new Vector3(-282.0f, 79.0f,0);
				cardCountLb.transform.localPosition = new Vector3(-300.0f,90.0f,0);
			}
			this.deskcardCtrl.offsetPos();
		}
	}
	public void createliveRoomObLb(GameObject copyObj)
	{
		if(!isObserver)return;
		GameObject obj = Instantiate<GameObject>(copyObj);
		obj.SetActive(true);
		UILabel lb = obj.GetComponent<UILabel>();
		obCreateLbUserName = lb;
		obj.transform.parent = transform.Find("anchorLeft");
		obj.transform.localScale = Vector3.one;
		obj.transform.localPosition = new Vector3(-62, -93.0f, 0);
		lb.color = Color.white;
		lb.width = 161;
		lb.fontSize = 25;
//		lb.effectStyle = UILabel.Effect.Outline;
//		lb.effectColor = new Color(99.0f/255.0f, 96.0f/255.0f, 1.0f,1.0f);
		GameObject obj2 = Instantiate<GameObject>(copyObj);
		obj2.SetActive(true);
		UILabel lb2 = obj2.GetComponent<UILabel>();
		obj2.transform.parent = transform.Find("anchorLeft");
		obj2.transform.localScale = Vector3.one;
		obj2.transform.localPosition = new Vector3(106, -93.0f, 0);
		lb2.color = Color.white;
//		lb.effectStyle = UILabel.Effect.Outline;
//		lb.effectColor = new Color(99.0f/255.0f, 96.0f/255.0f, 1.0f, 1.0f);
		lb2.fontSize = 25;
		lb2.text = "0";
		obCreateLbScore = lb2;
		return;
	}

	public void setSelfSex()
	{
		string[] sptIndex = avatarIcon.spriteName.Split('_');
		if(int.Parse(sptIndex[1])%2 == 0){
			isFemale = false;
		}else{
			isFemale = true;
		}
	}

    public void OnClickInfoDetail()
    {
        if (infoDetail.activeSelf)
        {
            infoDetail.SetActive(false);
            _timeLasted = 0;
        }
        else
        {
            infoDetail.SetActive(true);
        }
    }

    void Update()
    {
        if (infoDetail != null && infoDetail.activeSelf)
        {
            _timeLasted += Time.deltaTime;
            if (_timeLasted >= _timeInterval)
            {
                infoDetail.SetActive(false);
                _timeLasted = 0;
            }
        }
    }

    public void UpdateIntoMoney(string intomoney)
    {
        if (userIntomoney == null)
        {
			//TODO
//            GameObject.Find("Label_Bagmoney").GetComponent<UILabel>().text =
//                EginTools.NumberAddComma(intomoney);
        }
        else
        {
            userIntomoney.text = "¥ " + EginTools.NumberAddComma(intomoney);
        }
        //		userIntomoney = userIntomoney == null ? GameObject.Find ("Label_Bagmoney").GetComponent<UILabel>() : userIntomoney;
        //		userIntomoney.text = "¥ " + EginTools.NumberAddComma(intomoney);
    }
    public GameObject usercardPrb;

	//when reconnect in game .
	public List<GameObject> handCards{
		get{
			return usercards;
		}
	}
	public bool isDealCardCom = false;
    private List<GameObject> usercards = new List<GameObject>();
    /// <summary>
    /// 发牌（带动画效果,需要在编辑器里将扑克牌的Active设为false）
    /// </summary>
    /// <returns>The deal.</returns>
    /// <param name="toShow">If set to <c>true</c> to show.</param>
    /// <param name="infos">Infos.</param>
    /// 
    public void SetDeal(List<JSONObject> infos)
    {
		dealCount=0;
		cardsTrans.transform.localScale = Vector3.one;
		usercards.Clear();
		for(int i= infos.Count-1; i>= 0; i--){
//		for(int i=0; i< infos.Count; i++){
			GameObject card = NGUITools.AddChild(cardsTrans.gameObject, usercardPrb);
			card.transform.localPosition = new Vector3(1050,0,0);
			if(isObserver){
				if(isMyself){
					leftEdge = -380f;
					cardPadding = 50.0f;
					cardPadding2 = 42.0f;
					card.GetComponent<UISprite>().width = 107;
					card.GetComponent<UISprite>().height = 140;
				}
			}
			card.gameObject.name = infos[i].ToString();
			card.GetComponent<DDZPlayercard>().myfather = this;
			card.GetComponent<DDZPlayercard>().pokerD = new DDZPokerData(int.Parse( infos[i].ToString()));
			int depthIndex = infos.Count-i-1;
			card.GetComponent<UISprite>().depth += depthIndex;
			card.GetComponent<BoxCollider>().center = new Vector3(0,0,-depthIndex);
			card.GetComponent<UISprite>().spriteName = _cardPre + infos[i].ToString();
			usercards.Add(card);
//			if(i == infos.Count - 1){
//				card.GetComponent<DDZPlayercard>().resizeCollider(true);
//			}else{
//				card.GetComponent<DDZPlayercard>().resizeCollider(false);
//			}
			iTween.MoveTo( card, iTween.Hash("x", leftEdge+ depthIndex*cardPadding, "time", 0.1f, "delay", 0.24f*depthIndex, "islocal", true,
			                                 "onstart","dealCardStart","onstarttarget",gameObject,
			                                 "oncomplete", "dealCardComplete", "oncompletetarget",gameObject));
		}

//		calctest = Time.time;
		DragToSelCards dragSel = cardsTrans.GetComponent<DragToSelCards>();
		if(dragSel != null){
			dragSel.init();
		}
		//for test
//		clearDeckTag.SetActive(true);
		if(isObserver){
			if(cardCountLb == null){//only myself cardCountLb equal null.
				for(int i=0; i<myDDZ._playingPlayerList.Count; i++){
					DDZPlayerCtrl playCtrl = myDDZ._playingPlayerList[i].GetComponent<DDZPlayerCtrl>();
					if(!playCtrl.isMyself){
						GameObject obj = Instantiate<GameObject>(playCtrl.cardCountLb.gameObject);
						UILabel lb = obj.GetComponent<UILabel>();
						obj.transform.parent = this.transform;
						obj.transform.localScale = Vector3.one;
						obj.transform.localPosition = new Vector3(-457.0f, 136.0f, 0);
						lb.text = "17";
						lb.color = Color.white;
						cardCountLb = obj.GetComponent<UILabel>();
						cardCountLb.pivot = UIWidget.Pivot.Left;
						return;
					}
				}
			}
		}

	}
//	private float calctest;
	private int dealCount = 0;
	private void dealCardStart(){
		if(DDZSoundMgr.sfxSound){
			DDZSoundMgr.instance.playEft("sound/fapai");
		}
	}
	private void dealCardComplete()
	{
		dealCount++;
//		updateCardCount(dealCount, true);
		if(dealCount == 17){
//			Debug.LogError("@@@==>"+(Time.time - calctest) );
			isDealCardCom = true;
			//this 'if' is ddz person3 match  network lag handle.
			if(myDDZ != null){
				if(myDDZ.rgtPanel.matchType != DDZRegtPanel.eMatchType.person3){
					resetBankercards(true);
				}else{
					if(!myDDZ.isInBattle){
						resetBankercards(true);
					}
				}
			}
			for(int i=0; i<usercards.Count; i++){
				iTween.ScaleTo(usercards[i], iTween.Hash("scale", new Vector3(1.08f, 1.08f, 1.0f), "time", 0.4f) );
				if(i == 16){
					iTween.ScaleTo(usercards[i], iTween.Hash("scale", new Vector3(1, 1, 1.0f),"delay", 0.4f, "time", 0.4f, 
					                                         "oncomplete", "stickREdgeCard", "oncompletetarget",gameObject) );
				}else{
					iTween.ScaleTo(usercards[i], iTween.Hash("scale", new Vector3(1, 1, 1.0f),"delay", 0.4f, "time", 0.4f));
				}
			}
		}
	}

	//Not card fly animation
	public void SetDeal2(List<JSONObject> infos)
	{
		isDealCardCom = true;
		usercards.Clear();
		int offset = 17 - infos.Count;
		for(int i= infos.Count-1; i>= 0; i--){
//		for(int i=0; i< infos.Count; i++){
			GameObject card = NGUITools.AddChild(cardsTrans.gameObject, usercardPrb);
			if(isObserver){
				if(isMyself){
					leftEdge = -458f;
					cardPadding = 56.0f;
					cardPadding2 = 48.0f;
					card.GetComponent<UISprite>().width = 107;
					card.GetComponent<UISprite>().height = 140;
				}
			}
			int depthIndex = infos.Count-i-1;
			if(offset< 0){
				card.transform.localPosition = new Vector3(leftEdge+ depthIndex*cardPadding2,0,0);
			}else{
				card.transform.localPosition = new Vector3(leftEdge+ depthIndex*cardPadding,0,0);
			}
			card.gameObject.name = infos[i].ToString();
			card.GetComponent<DDZPlayercard>().myfather = this;
			card.GetComponent<DDZPlayercard>().pokerD = new DDZPokerData(int.Parse( infos[i].ToString()));
			card.GetComponent<UISprite>().depth += depthIndex;
			card.GetComponent<BoxCollider>().center = new Vector3(0,0,-depthIndex);
			card.GetComponent<UISprite>().spriteName = _cardPre + infos[i].ToString();
//			if(i == infos.Count - 1){
//				card.GetComponent<DDZPlayercard>().resizeCollider(true);
//			}else{
//				card.GetComponent<DDZPlayercard>().resizeCollider(false);
//			}
			usercards.Add(card);
		}

		if(offset > 0){
			cardsTrans.localPosition += new Vector3(cardPadding/2*offset, 0,0);
		}

		DragToSelCards dragSel = cardsTrans.GetComponent<DragToSelCards>();
		if(dragSel != null){
			dragSel.init();
		}
		stickREdgeCard();
	}

	public void Clearcards(){
		if (cardsTrans.transform.childCount > 0)
		{
			for (int i = 0; i < cardsTrans.transform.childCount; i++)
			{
				GameObject go = cardsTrans.transform.GetChild(i).gameObject;
				if( go.transform.childCount > 0 ){
					go.transform.GetChild(0).parent = transform;
				}
                Destroy(go);
            }
            usercards.Clear();
        }
    }

    public void Setcallpt(int callpt)
    {
		scoreLb.text = callpt+"";
		if(myDDZ.isMatch){
			cMPInfoPanel.scoreLb.text = callpt+"";
		}
    }
	public void Setcalldouble(int calldouble)
	{
		if(calldouble == 0){
			multipleLb.text = "0";
		}else{
			multipleLb.text = "x"+calldouble;
		}
		if(myDDZ.isMatch){
			cMPInfoPanel.myMulLb.text = "x"+calldouble;
		}
	}
	
	public void changeToSlave(bool isLiveRoom)
	{
		Vector4 originClip = headClip.baseClipRegion;
		originClip.z = 146;
		headClip.baseClipRegion = originClip;
		avatarFrame.atlas = actBubble.atlas;
		avatarFrame.spriteName = "avtFrame";
		avatarFrame.MakePixelPerfect();
		avatarIcon.atlas = ddzAvatarAnimaAtlas;
//		avatarIcon.spriteName = isFemale?"avtSlave1":"avtSlave2";
		string preStr = isBanker?"l":"s";
		string femaleStr = isFemale?"f_":"";
		avatarIcon.spriteName = femaleStr+"DDZ_"+preStr+animaDc["default"];
		avatarIcon.GetComponent<UISpriteAnimation>().namePrefix = avatarIcon.spriteName;
		avatarIcon.GetComponent<UISpriteAnimation>().enabled = true;
		avatarIcon.MakePixelPerfect();
		avatarIcon.transform.localPosition = new Vector3(0, 1, 0);
		vfxSmoke.gameObject.SetActive(true);
		vfxSmoke.playWithCallback(()=>{ vfxSmoke.gameObject.SetActive(false); });
		if(isObserver){
			if(codeCreateSpt == null){
				GameObject cloneAvatar = Instantiate<GameObject>(avatarIcon.gameObject);
				cloneAvatar.transform.parent = this.transform;
				cloneAvatar.transform.localScale = new Vector3(0.5f,0.5f,0.5f);
				codeCreateSpt = cloneAvatar.GetComponent<UISprite>();
			}else{
				codeCreateSpt.gameObject.SetActive(true);
				codeCreateSpt.spriteName = avatarIcon.spriteName;
			}
			if(isMyself){
				codeCreateSpt.transform.localPosition = new Vector3(-370.0f, 131.0f, 0);
//				creatLabel(new Vector3(-370.0f, 131.0f, 0), this.transform, "农民");
			}else{
				if(transform.position.x< 0){
					codeCreateSpt.transform.localPosition = new Vector3(256.0f,90.0f,0);
//					creatLabel(new Vector3(256.0f,90.0f,0), this.transform, "农民");
				}else{
					codeCreateSpt.transform.localPosition = new Vector3(-256.0f,90.0f,0);
//					creatLabel(new Vector3(-256.0f,90.0f,0), this.transform, "农民");
				}
			}

		}
		if(isLiveRoom)return;
		if(!isMyself){
			userNickname.text = "";
			userIntomoney.transform.localPosition = userNickname.transform.localPosition;
		}
	}

	public void changeToBanker(bool isLiveRoom)
    {
		isBanker = true;
		Vector4 originClip = headClip.baseClipRegion;
		originClip.z = 146;
		headClip.baseClipRegion = originClip;
		avatarFrame.atlas = actBubble.atlas;
		avatarFrame.spriteName = "avtFrame2";
		avatarFrame.MakePixelPerfect();
		avatarIcon.atlas = ddzAvatarAnimaAtlas;
//		avatarIcon.spriteName = isFemale?"avtMaster1":"avtMaster2";
		string preStr = isBanker?"l":"s";
		string femaleStr = isFemale?"f_":"";
		avatarIcon.spriteName = femaleStr+"DDZ_"+preStr+animaDc["default"];
		avatarIcon.GetComponent<UISpriteAnimation>().namePrefix = avatarIcon.spriteName;
		avatarIcon.GetComponent<UISpriteAnimation>().enabled = true;
		avatarIcon.MakePixelPerfect();
		avatarIcon.transform.localPosition = new Vector3(0, 1, 0);
		vfxSmoke.gameObject.SetActive(true);
		vfxSmoke.playWithCallback(()=>{ vfxSmoke.gameObject.SetActive(false); });
		if(isObserver){
			if(codeCreateSpt == null){
				GameObject cloneAvatar = Instantiate<GameObject>(avatarIcon.gameObject);
				cloneAvatar.transform.parent = this.transform;
				cloneAvatar.transform.localScale = new Vector3(0.5f,0.5f,0.5f);
				codeCreateSpt = cloneAvatar.GetComponent<UISprite>();
			}else{
				codeCreateSpt.gameObject.SetActive(true);
				codeCreateSpt.spriteName = avatarIcon.spriteName;
			}
			if(isMyself){
				codeCreateSpt.transform.localPosition = new Vector3(-370.0f, 131.0f, 0);
//				creatLabel(new Vector3(-370.0f, 131.0f, 0), this.transform, "地主");
			}else{
				if(transform.position.x< 0){
					codeCreateSpt.transform.localPosition = new Vector3(256.0f,90.0f,0);
//					creatLabel(new Vector3(256.0f,90.0f,0), this.transform, "地主");
				}else{
					codeCreateSpt.transform.localPosition = new Vector3(-256.0f,90.0f,0);
//					creatLabel(new Vector3(-256.0f,90.0f,0), this.transform, "地主");
				}
			}
		}
		if(isLiveRoom)return;
		if(!isMyself){
			userNickname.text = "";
			userIntomoney.transform.localPosition = userNickname.transform.localPosition;
		}
    }

	public void recoveryAvatar()
	{
		if(avatarIcon.atlas == originAvatarAtlas){
			return;
		}
		Vector4 originClip = headClip.baseClipRegion;
		originClip.z = 109;
		headClip.baseClipRegion = originClip;
		avatarFrame.atlas = actBubble.atlas;
		avatarFrame.spriteName = "avtFrame";
		avatarIcon.GetComponent<UISpriteAnimation>().enabled = false;
		avatarIcon.atlas = originAvatarAtlas;
		avatarIcon.spriteName = "avatar_"+ avatarID;
		avatarIcon.MakePixelPerfect();
		avatarIcon.width = 96;
		avatarIcon.height = 96;
		avatarIcon.transform.localScale = Vector3.one;
		avatarIcon.transform.localPosition = Vector3.zero;
//		avatarIcon.transform.localScale = new Vector3(0.6f, 0.6f, 1);
//		if(avatarID == 0){
//			avatarIcon.transform.localPosition = new Vector3(-0.52f, 5.0f, 0);
//		}else{
//			avatarIcon.transform.localPosition = new Vector3(6.0f, 16.0f, 0);
//		}
		vfxSmoke.gameObject.SetActive(true);
		vfxSmoke.playWithCallback(()=>{ vfxSmoke.gameObject.SetActive(false); });
		if(!isMyself){
			userNickname.text = nickNameStr;
			if(!isObserver){
				userIntomoney.transform.localPosition = new Vector3(0,-112.0f,0);
			}
		}
		if(isObserver){
			if(codeCreateSpt != null)codeCreateSpt.gameObject.SetActive(false);
		}
	}

	public void playAvatarAnima(string animaName)
	{
		if(avatarIcon.atlas != ddzAvatarAnimaAtlas)return;// player avatar miss bug fix.
		if(isManaged && animaName!= "auto" && animaName != "default"){
			return;
		}else{
			string preStr = isBanker?"l":"s";
			string femaleStr = isFemale?"f_":"";
			UISpriteAnimation avatarAnima = avatarIcon.GetComponent<UISpriteAnimation>();
			if(animaName == "auto"){
				avatarAnima.loop = true;
			}else{
				avatarAnima.loop = false;
			}
			avatarAnima.namePrefix = femaleStr+preStr+animaDc[animaName];
			if(animaName == "default"){
				if(avatarFrame.atlas == actBubble.atlas){
					avatarIcon.spriteName = femaleStr+"DDZ_"+preStr+animaDc["default"]; 
				}
			}else{
				if(femaleStr.Length>0){
					avatarAnima.playWithCallback(2,()=>{ 
						avatarAnima.namePrefix = femaleStr+"DDZ_"+preStr+animaDc["default"]; 
						avatarIcon.spriteName = femaleStr+"DDZ_"+preStr+animaDc["default"]; 
					});
				}else{
					avatarAnima.playWithCallback(()=>{ 
						avatarAnima.namePrefix = femaleStr+"DDZ_"+preStr+animaDc["default"]; 
						avatarIcon.spriteName = femaleStr+"DDZ_"+preStr+animaDc["default"]; 
					});
				}
			}
		}
	}

	private void setupPadding()
	{
		float curPadding = isBanker? cardPadding2 : cardPadding;
		for(int i=0; i< usercards.Count; i++){
			usercards[i].transform.localPosition = new Vector3(leftEdge+ curPadding*i, 0, 0);
		}
		readycards.Clear();
		readysendcardList.Clear();
	}

	public void Addbankercards(List<JSONObject> hide_cards, bool isNeedAnimation=true) {
		if(isMyself){
			//if select cards until confirm master that have a error
			for(int i=0; i< usercards.Count; i++){
				usercards[i].GetComponent<DDZPlayercard>().resetState();
			}
			setupPadding();
			DragToSelCards dragSel = cardsTrans.GetComponent<DragToSelCards>();
			int insertCount = hide_cards.Count;
			for(int i=0;i<insertCount;i++){
				GameObject card = NGUITools.AddChild(cardsTrans.gameObject, usercardPrb);
				if(isObserver){
					card.GetComponent<UISprite>().width = 107;
					card.GetComponent<UISprite>().height = 140;
				}
				card.GetComponent<BoxCollider>().enabled = false;
				card.GetComponent<Transform>().localPosition = new Vector3(leftEdge + ((usercards.Count + 1+i) * cardPadding), 0, 0);
				card.gameObject.name = hide_cards[i].ToString();
				DDZPlayercard playCard = card.GetComponent<DDZPlayercard>();
				playCard.myfather = this;
				playCard.pokerD = new DDZPokerData( int.Parse( hide_cards[i].ToString() ) );
				card.GetComponent<UISprite>().depth += (usercards.Count + i + 1);
				card.GetComponent<UISprite>().spriteName = _cardPre + hide_cards[i].ToString();
				
				int insertIndex = findInsertPos( playCard );
				float insertPos;
				if(insertIndex == -1){
					insertPos = usercards[usercards.Count -1].transform.localPosition.x;
				}else{
					insertPos = usercards[insertIndex].transform.localPosition.x;
				}
				
				Vector3 vc3 = card.transform.localPosition;
				if(isNeedAnimation){
					vc3.y = 50;
				}else{
					vc3.y = 0;
				}
				if(insertIndex == 0){
					updateDeckPos(insertIndex);
					vc3.x = insertPos;
					card.transform.localPosition = vc3;
					//				usercards[insertIndex].GetComponent<UISprite>().color = new Color(0.8f,0.8f,0.8f);
					playCard.GetComponent<UISprite>().depth = usercards[insertIndex].GetComponent<UISprite>().depth-1;
					playCard.GetComponent<BoxCollider>().center = usercards[insertIndex].GetComponent<BoxCollider>().center + new Vector3(0,0,0.3f); 
					usercards.Insert(insertIndex, card);
					if(dragSel != null){
						dragSel.insertBankerCards(card, insertIndex);
					}
				}else if(insertIndex == -1){
					//				updateDeckPos(usercards.Count-1);
					vc3.x = insertPos+ cardPadding2;
					card.transform.localPosition = vc3;
					//				usercards[usercards.Count-1].GetComponent<UISprite>().color = new Color(1.0f,0.8f,0.8f);
					playCard.GetComponent<UISprite>().depth = usercards[usercards.Count-1].GetComponent<UISprite>().depth+1;
					playCard.GetComponent<BoxCollider>().center = usercards[usercards.Count-1].GetComponent<BoxCollider>().center + new Vector3(0,0,-0.3f); 
					//				usercards.Insert(1,card);
					usercards.Add(card);
					if(dragSel != null){
						//					dragSel.insertBankerCards(card, 1);
						dragSel.insertBankerCards(card, usercards.Count-1);
					}
					//				Debug.LogError(playCard.pokerD.ToString() + " insertX--> special "+ 1);
				}else{
					updateDeckPos(insertIndex);
					vc3.x = insertPos;
					card.transform.localPosition = vc3;
					//				usercards[insertIndex].GetComponent<UISprite>().color = new Color(0.8f,0.8f,1.0f);
					playCard.GetComponent<UISprite>().depth = usercards[insertIndex].GetComponent<UISprite>().depth-1;
					playCard.GetComponent<BoxCollider>().center = usercards[insertIndex].GetComponent<BoxCollider>().center + new Vector3(0,0,0.3f); 
					usercards.Insert(insertIndex, card);
					if(dragSel != null){
						dragSel.insertBankerCards(card, insertIndex);
					}
					//				Debug.LogError(playCard.pokerD.ToString() + " insertX-->"+insertIndex);
				}
				if(isNeedAnimation){
					iTween.MoveTo(card, iTween.Hash("delay",1.5f, "y", 0, "time",0.5f, "islocal", true, 
						"oncomplete","iTweenInsertCardCom", "oncompletetarget",gameObject, "oncompleteparams", card));
				}else{
					card.GetComponent<BoxCollider>().enabled = true;
				}
				//usercards.Add(card);
				
			}
			//2016.11.29  此处用于出出去的牌，因为网络延迟没发送到服务器，此处收回，牌组需要往左移，因为出牌时往右偏移了。
			if(!isNeedAnimation){
				if(isBanker){
					cardsTrans.localPosition -= new Vector3( (cardPadding2/2)*insertCount , 0,0);
				}else{
					cardsTrans.localPosition -= new Vector3( (cardPadding2/2)*insertCount , 0,0);
				}
			}
			stickREdgeCard();
		}else{
			if(!isObserver){
				if(!isShowDeck)return;
			}
			List<GameObject> cloneUsercards = new List<GameObject>();
			if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.right){
				for(int i=usercards.Count-1; i>=0; i--){
					cloneUsercards.Add(usercards[i]);
				}
				usercards = cloneUsercards;
			}

			for(int i=0;i<3;i++){
				GameObject card = NGUITools.AddChild(cardsTrans.gameObject, usercardPrb);
				card.gameObject.name = hide_cards[i].ToString();
				DDZPlayercard playCard = card.AddComponent<DDZPlayercard>();
				playCard.pokerD = new DDZPokerData( int.Parse( hide_cards[i].ToString() ) );
				card.GetComponent<UISprite>().spriteName = _cardPre + hide_cards[i].ToString();
				if(isObserver){
					card.GetComponent<UISprite>().width = 71;
					card.GetComponent<UISprite>().height = 100;
				}

				int insertIndex = findInsertPos( playCard );
				float insertPos;
				if(insertIndex == -1){
					usercards.Add(card);
				}else{
					usercards.Insert(insertIndex, card);
				}
			}

			if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.left){
				for(int i=usercards.Count-1; i>=0; i--){
					int index = usercards.Count - i -1;
					GameObject cardObj = usercards[index];
					if(isObserver){
						cardObj.transform.localPosition = new Vector3((index%10)*30,-Mathf.Floor(index/10.0f)*35,0);
					}else{
						cardObj.transform.localPosition = new Vector3((index%10)*25,-Mathf.Floor(index/10.0f)*30,0);
					}
					cardObj.GetComponent<UISprite>().depth = 113;
					cardObj.GetComponent<UISprite>().depth += index;
				}
			}else if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.right){
				cloneUsercards = new List<GameObject>();
				if(!isObserver){
					for(int i=usercards.Count-1; i>=0; i--){
						cloneUsercards.Add(usercards[i]);
					}
					usercards = cloneUsercards;
				}
				for(int i=0; i< usercards.Count; i++){
					GameObject cardObj = usercards[i];
					if(isObserver){
						cardObj.transform.localPosition = new Vector3(-(i%10)*30,-Mathf.Floor(i/10.0f)*35,0);
					}else{
						cardObj.transform.localPosition = new Vector3(-(i%10)*25,-Mathf.Floor(i/10.0f)*30,0);
					}
					cardObj.GetComponent<UISprite>().depth = 113;
					cardObj.GetComponent<UISprite>().depth -= (i - (int)Mathf.Floor(i/10.0f)*20);
				}
			}

		}

    }

	private void iTweenInsertCardCom(GameObject obj)
	{
		obj.GetComponent<BoxCollider>().enabled = true;
	}

	public int findInsertPos(DDZPlayercard playerCard)
	{
		DDZC.PokerNum pNum = playerCard.pokerD.pokerNum;
		int len = usercards.Count;
		int min = 99;
		int resultIndex = -1;
		for(int i=0; i<len ; i++){
			GameObject cardObj = usercards[i];
			DDZPlayercard playerCard1 = cardObj.GetComponent<DDZPlayercard>();
			int sub = playerCard.pokerD.pokerNum - playerCard1.pokerD.pokerNum;
			if(sub == 0){
				resultIndex = i;
				break;
			}else{
				if(sub> 0 && sub < min){
					min = sub;
					resultIndex = i;
				}else if(sub < 0){
					resultIndex = i;
					if(resultIndex == (len-1)){
						resultIndex = -1;
					}
				}
			}
		}
//		Debug.LogError(resultIndex);
		return resultIndex;
	}

	private void updateDeckPos(int insertIndex){
		int len = usercards.Count;
		if(insertIndex>=  len)return;
		for(int i=insertIndex; i< len; i++){
			Vector3 vc3 = usercards[i].gameObject.transform.localPosition;
			vc3.x += cardPadding2;
			usercards[i].gameObject.transform.localPosition = vc3;
			usercards[i].gameObject.GetComponent<UISprite>().depth += 1;
		}
		for(int i=0; i< len; i++){
			usercards[i].gameObject.GetComponent<DDZPlayercard>().index = i;
		}

	}

    public UISprite[] bankercards;
	public UISprite[] cmpBankercards;
    public void showbankercard(List<JSONObject> cardsList, bool skipAnima = false)
    {
		UISprite[] targetCards = bankercards;
		for (int i = 0; i < targetCards.Length; i++)
        {
			targetCards[i].gameObject.SetActive(true);
            if (null != cardsList && cardsList.Count > i)
            {
//                bankercard[i].spriteName = _cardPre + cardsList[i].ToString();
				if(skipAnima){
					if(myDDZ != null && myDDZ.isMatch && myDDZ.rgtPanel.matchType != DDZRegtPanel.eMatchType.person3){
						cmpBankercards[i].gameObject.SetActive(true);
						cmpBankercards[i].GetComponent<OpenCardAnima>().skipAnima( _cardPre + cardsList[i].ToString() , 1.0f);
						if(!myDDZ.is131Happy){
							hideNormalBankerCards();
						}else{
							targetCards[i].GetComponent<OpenCardAnima>().play( _cardPre + cardsList[i].ToString() );
						}
					}else{
						targetCards[i].GetComponent<OpenCardAnima>().skipAnima( _cardPre + cardsList[i].ToString() );
					}
				}else{
					targetCards[i].GetComponent<OpenCardAnima>().play( _cardPre + cardsList[i].ToString() );
					if(myDDZ != null && myDDZ.isMatch && myDDZ.rgtPanel.matchType != DDZRegtPanel.eMatchType.person3){
						cmpBankercards[i].GetComponent<OpenCardAnima>().play( _cardPre + cardsList[i].ToString() );
						if(!myDDZ.is131Happy){
							Invoke("hideNormalBankerCards",1.0f);
						}
					}
				}
            }
        }
    }

	public void hideNormalBankerCards()
	{
		for (int i = 0; i < bankercards.Length; i++)
		{
			bankercards[i].gameObject.SetActive(false);
		}
	}

	public void resetBankercards(bool isShow)
	{
		UISprite[] targetCards = bankercards;
		for (int i = 0; i < targetCards.Length; i++)
		{
			if(myDDZ != null && myDDZ.is131Happy){
				targetCards[i].GetComponent<OpenCardAnima>().originScale = new Vector3(0.44f,0.44f,1);
				targetCards[i].gameObject.transform.localScale = new Vector3(0.44f,0.44f,1);
				targetCards[i].gameObject.transform.localPosition = new Vector3(-49.0f+ i*49.0f, -1.6f, 0);
				targetCards[i].GetComponent<OpenCardAnima>().needMove = false;
				targetCards[i].spriteName = targetCards[i].GetComponent<OpenCardAnima>().closeSptname;
				if(myDDZ.isInBattle){
					targetCards[i].gameObject.SetActive(false);
				}else{
					targetCards[i].gameObject.SetActive(isShow);
				}
				continue;
			}
			if(myDDZ != null && myDDZ.isMatch  && myDDZ.rgtPanel.matchType != DDZRegtPanel.eMatchType.person3){
				targetCards[i].GetComponent<OpenCardAnima>().originScale = new Vector3(0.6f,0.6f,0.6f);
				targetCards[i].gameObject.transform.localScale = new Vector3(0.6f,0.6f,0.6f);
				targetCards[i].gameObject.transform.localPosition = new Vector3(71.0f*i -71.0f, -166.0f, 0);
				targetCards[i].GetComponent<OpenCardAnima>().needMove = false;
				targetCards[i].spriteName = targetCards[i].GetComponent<OpenCardAnima>().closeSptname;
				if(myDDZ.isInBattle){
					targetCards[i].gameObject.SetActive(false);
				}else{
					targetCards[i].gameObject.SetActive(isShow);
				}
			}else{
				if(myDDZ != null && myDDZ.isMatch  && myDDZ.rgtPanel.matchType == DDZRegtPanel.eMatchType.person3){
					targetCards[i].GetComponent<OpenCardAnima>().originScale = new Vector3(0.75f,0.75f,0.75f);
					targetCards[i].gameObject.transform.localScale = new Vector3(0.75f,0.75f,0.75f);
				}else{
					targetCards[i].gameObject.transform.localScale = new Vector3(0.9f,0.9f,0.9f);
				}

				targetCards[i].gameObject.transform.localPosition = new Vector3(124.3f*i -124.3f, -150.0f, 0);
				targetCards[i].spriteName = targetCards[i].GetComponent<OpenCardAnima>().closeSptname;
				targetCards[i].gameObject.SetActive(isShow);
			}
		}
		if(myDDZ != null && myDDZ.is131Happy)return;
		if(myDDZ != null && myDDZ.isMatch  && myDDZ.rgtPanel.matchType != DDZRegtPanel.eMatchType.person3){
			targetCards = cmpBankercards;
			for (int i = 0; i < targetCards.Length; i++)
			{
				targetCards[i].gameObject.transform.localScale = Vector3.one;
				targetCards[i].gameObject.transform.localPosition = new Vector3(68.0f*i -68.0f, 0, 0);
				targetCards[i].spriteName = targetCards[i].GetComponent<OpenCardAnima>().closeSptname;
				targetCards[i].gameObject.SetActive(isShow);
			}
		}
	}

    public string bankername;
    public UISprite[] othercardsArray;

	public IEnumerator showDeck(List<JSONObject> cardsList=null)
	{
		isShowDeck = true;
		if(isMyself){
//			stickREdgeCard();
		}else{
			if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.left){
				if(usercards.Count>0){
					for(int i=0; i<usercards.Count; i++){
						Destroy(usercards[i]);
					}
					usercards.Clear();
				}
				if(isObserver){
					cardsTrans.transform.localPosition = new Vector3(-37.0f, -115.1f, 0);
				}
				for(int i=cardsList.Count-1; i>=0; i--){
					//			for(int i=0; i< cardsList.Count; i++){
					GameObject card = NGUITools.AddChild(cardsTrans.gameObject, usercardPrb);
					int index = cardsList.Count - i -1;
					if(isObserver){
						card.GetComponent<UISprite>().width = 71;
						card.GetComponent<UISprite>().height = 100;
						card.transform.localPosition = new Vector3((index%10)*30,-Mathf.Floor(index/10.0f)*35,0);
					}else{
						card.transform.localPosition = new Vector3((index%10)*25,-Mathf.Floor(index/10.0f)*30,0);
					}
					card.gameObject.name = cardsList[i].ToString();
					DDZPlayercard ddzPlayerCard = card.AddComponent<DDZPlayercard>();
					ddzPlayerCard.pokerD = new DDZPokerData((int)cardsList[i].n);
					card.GetComponent<UISprite>().depth += index;
					card.GetComponent<UISprite>().spriteName = _cardPre + cardsList[i].ToString();
					usercards.Add(card);
					yield return new WaitForSeconds(0.1f);
				}
			}else if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.right){
				if(usercards.Count>0){
					for(int i=0; i<usercards.Count; i++){
						Destroy(usercards[i]);
					}
					usercards.Clear();
				}
				if(isObserver){
					cardsTrans.transform.localPosition = new Vector3(37.0f, -115.1f, 0);
					cardsList.Reverse();
				}
				for(int i=0; i< cardsList.Count; i++){
					GameObject card = NGUITools.AddChild(cardsTrans.gameObject, usercardPrb);
					if(isObserver){
						card.GetComponent<UISprite>().width = 71;
						card.GetComponent<UISprite>().height = 100;
						card.transform.localPosition = new Vector3(-(i%10)*30,-Mathf.Floor(i/10.0f)*35,0);
					}else{
						card.transform.localPosition = new Vector3(-(i%10)*25,-Mathf.Floor(i/10.0f)*30,0);
					}
					card.gameObject.name = cardsList[i].ToString();
					DDZPlayercard ddzPlayerCard = card.AddComponent<DDZPlayercard>();
					ddzPlayerCard.pokerD = new DDZPokerData((int)cardsList[i].n);
					card.GetComponent<UISprite>().depth -= (i - (int)Mathf.Floor(i/10.0f)*10);
					card.GetComponent<UISprite>().spriteName = _cardPre + cardsList[i].ToString();
					if(isObserver){
						usercards.Insert(0,card);
					}else{
						usercards.Add(card);
					}
					yield return new WaitForSeconds(0.1f);
				}
			}

		}

	}

	public void stickREdgeCard()
	{
		if(isShowDeck){
			clearDeckTag.SetActive(true);
		}
		if(usercards.Count > 0){
			GameObject rightEdgeCard = usercards[usercards.Count-1];
			clearDeckTag.transform.SetParent(rightEdgeCard.transform);
			if(isObserver){
				clearDeckTag.transform.localScale = new Vector3(0.45f,0.45f,1);
				clearDeckTag.transform.localPosition = new Vector3(34.0f, 52.0f, 0);
			}else{
				clearDeckTag.transform.localPosition = new Vector3(22.0f, 52.0f, 0);
			}
		}
	}

	public void clearSelectedCards()
	{
		clickScreenClearSelCards();
		cantHandleTag.SetActive(false);
	}

	public void clickScreenClearSelCards()
	{
		for(int i=0; i<usercards.Count; i++){
			usercards[i].GetComponent<DDZPlayercard>().resetState();
		}
		selCardHandle();
		readycards.Clear();
		readysendcardList.Clear();
	}

	public int drawCard(DDZPlayerCtrl prePlayer , bool flashVer)
	{
		List<DDZPokerData> pdList = getPokeDList(readycards);

		List<int> pdType = DDZTip2.typePai(pdList);
		if(pdType.Count>0){
			List<JSONObject> selCardData = DDZTip.sortCards(readycards, pdType[0]);
			if(prePlayer == null){
				selfSimDraw(selCardData,pdType[0]);
			}else if(prePlayer == this){
				selfSimDraw(selCardData,pdType[0]);
			}else{
				List<DDZPokerData> prePdList = getPokeDList(prePlayer.deskcardCtrl.cardsData);
				if( DDZTip2.isCheckChu( pdType, DDZTip2.typePai(prePdList)) ){
					selfSimDraw(selCardData,pdType[0]);
				}else{
					StartCoroutine( CardsFail(2) );
					return -1;
				}
			}
			return pdType[0];
		}else{
			StartCoroutine( CardsFail(1) );
			return -1;
		}
	}

	private List<DDZPokerData> getPokeDList(List<GameObject> listObj){
		List<DDZPokerData> result = new List<DDZPokerData>();
		for(int i=0; i< listObj.Count; i++){
			result.Add(new DDZPokerData(listObj[i].GetComponent<DDZPlayercard>().pokerD.cardID));
		}
		return result;
	}
	private List<DDZPokerData> getPokeDList(List<JSONObject> listJson){
		List<DDZPokerData> result = new List<DDZPokerData>();
		for(int i=0; i< listJson.Count; i++){
			result.Add(new DDZPokerData((int)listJson[i].n));
		}
		return result;
	}

	public int drawCard(DDZPlayerCtrl prePlayer )
	{
		int cardType = DDZTip.isAllowType(readycards);
//		Debug.LogError("DrawCard--->cardtype:"+ cardType);
		if(cardType != -1){
			List<JSONObject> selCardData = DDZTip.sortCards(readycards, cardType);
			if(prePlayer == null){
				Debug.LogError("prePlayer == null");
				selfSimDraw(selCardData, cardType);
			}else{
				if(prePlayer == this){
					Debug.LogError("prePlayer == this");
					selfSimDraw(selCardData, cardType);
				}else if(prePlayer.deskcardCtrl.cardsData != null){
					DDZPokerData mySelfPd = new DDZPokerData( (int)selCardData[0].n );
					int preCardType = prePlayer.deskcardCtrl.cardType;
					List<JSONObject> preCardsFix = DDZTip.sortCards(prePlayer.deskcardCtrl.cardsData, preCardType);
					DDZPokerData pd = new DDZPokerData((int)preCardsFix[0].n);
//					Debug.LogError(mySelfPd.ToString() +" vs "+ pd.ToString());
//					DDZPokerData pd = new DDZPokerData((int)prePlayer.deskcardCtrl.cardsData[0].n);
//					Debug.LogError(mySelfPd.ToString() +"  pre: "+pd.ToString());
					if(cardType == preCardType){
						if(selCardData.Count != prePlayer.deskcardCtrl.cardsData.Count){
							StartCoroutine( CardsFail(1) );
							return -1;
						}
					}
					bool canDraw = DDZTip.greaterThan(mySelfPd, pd, cardType, preCardType);
					if(canDraw){
						selfSimDraw(selCardData, cardType);
					}else{
						StartCoroutine( CardsFail(2) );
					}
				}
			}
		}else{
			StartCoroutine( CardsFail(1) );
		}
		readysendcardList.Clear();
		return cardType;
	}
	
	private void selfSimDraw(List<JSONObject> cards, int cardType){
//		DDZTip._preCards = null;
		Updatedeskcards(cards, cardType);
		UpdateUserCard(cards);
		drawCountPlus();
		updateCardCount(usercards.Count);
		DDZCount.Instance.DestroyHUD();
		Debug.LogError("selfSimDraw--->"+usercards.Count);
		if(usercards.Count == 0){
			clearDeckTag.SetActive(false);
		}
	}

	public List<int> selCard{
		get{
			return readysendcardList;
		}
	}

    public GameObject PopBox;
    public UILabel Popmessage;
    public IEnumerator CardsFail(int failtype)
    {
        PopBox.SetActive(true);
        if (failtype == 1)
        {
            Popmessage.text = "牌型有误";
        }
        else if (failtype == 2)
        {
            Popmessage.text = "牌型小于上家";
        }

		clearSelectedCards();

        yield return new WaitForSeconds(1.5f);
        PopBox.SetActive(false);
    }

    public void UpdateUserCard(List<JSONObject> cardsList)
    {
		List<GameObject> matchObjs = new List<GameObject>();
		for(int i=0; i< cardsList.Count; i++){
			for(int j=0; j<usercards.Count; j++){
				if( usercards[j].GetComponent<DDZPlayercard>().pokerD.cardID == cardsList[i].n ){
					matchObjs.Add(usercards[j]);
					break;
				}
			}
		}

		if(isMyself){
			foreach(GameObject card in matchObjs){
				if(card.transform.childCount> 0){
					Transform clearTag = card.transform.GetChild(0);
					if(clearTag != null){
						clearTag.parent = this.transform;
					}
				}
				Destroy(card);
				usercards.Remove(card);
				if(isBanker){
					cardsTrans.localPosition += new Vector3(cardPadding2/2, 0,0);
				}else{
					cardsTrans.localPosition += new Vector3(cardPadding/2, 0,0);
				}
			}
			for(int i=0; i<readycards.Count; i++){
				readycards[i].GetComponent<DDZPlayercard>().resetState();
			}
			setupPadding();
			stickREdgeCard();
		}else{
			foreach(GameObject card in matchObjs){
				Destroy(card);
				usercards.Remove(card);
			}
			if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.left){
				for(int i=usercards.Count-1; i>=0; i--){
					int index = usercards.Count - i -1;
					GameObject cardObj = usercards[index];
					cardObj.transform.localPosition = new Vector3((index%10)*25,-Mathf.Floor(index/10.0f)*30,0);
					cardObj.GetComponent<UISprite>().depth = 113;
					cardObj.GetComponent<UISprite>().depth += index;
				}
			}else if(deskcardCtrl.deskCardType == DeskCardCtrl.eDeskCardType.right){
				for(int i=0; i< usercards.Count; i++){
					GameObject cardObj = null;
					if(isObserver && !isBanker){
						cardObj = usercards[(usercards.Count-1) - i];
					}else{
						cardObj = usercards[i];
					}
					cardObj.transform.localPosition = new Vector3(-(i%10)*25,-Mathf.Floor(i/10.0f)*30,0);
					cardObj.GetComponent<UISprite>().depth = 113;
					cardObj.GetComponent<UISprite>().depth -= (i - (int)Mathf.Floor(i/10.0f)*10);
				}
			}
		}
    }
    private List<int> readysendcardList = new List<int>();
    private List<GameObject> readycards = new List<GameObject>();

	public void matchServerCardToLocal(List<JSONObject> serverCards)
	{
		List<JSONObject> MissObjs = new List<JSONObject>();
		int len = serverCards.ToArray().Length;
		if(len == 0)return;
		if(serverCards[0].IsNull)return;
		if( len > usercards.Count){
			for(int i=0; i< len; i++){
				bool isMatch = false;
				for(int j=0; j<usercards.Count; j++){
					if( usercards[j].GetComponent<DDZPlayercard>().pokerD.cardID == serverCards[i].n ){
						isMatch = true;
						break;
					}
				}
				if(!isMatch){
					MissObjs.Add(serverCards[i]);
				}
			}
			if(MissObjs.Count>0){
				Addbankercards(MissObjs, false);
			}
		}
	}

//	public void coverSelCards(List<GameObject> selc){
//		readycards.Clear();
//		readysendcardList.Clear();
//		for(int i=0; i<selc.Count; i++){
//			readycards.Add(selc[i]);
//			readysendcardList.Add(int.Parse(selc[i].name));
//		}
//	}
	public void calcSelCards()
	{
		for(int i=0; i< usercards.Count; i++){
			if(usercards[i].GetComponent<DDZPlayercard>().isSelected){
				readycards.Add(usercards[i]);
				readysendcardList.Add(int.Parse(usercards[i].name));
			}
		}
	}

	public DeskCardCtrl deskcardCtrl;
    public void Updatedeskcards(List<JSONObject> cardsList1,int cardstype)
    {
		List<JSONObject> cardsList = new List<JSONObject>();
		if(isMyself){
			cardsList = cardsList1;
		}else{
			for(int i=cardsList1.Count-1 ; i>=0; i--){
				cardsList.Add(cardsList1[i]);
			}
		}

		deskcardCtrl.drawCards(cardsList, isObserver, cardstype, isShowDeck, cardCount);
		if(cardsList != null){
			DDZPokerData pd = new DDZPokerData((int)cardsList[0].n);
//			Debug.LogError(uid+"--->"+ pd.ToString());
			DDZSoundMgr.instance.drawCard(cardstype,isFemale, (int)pd.pokerNum);
			if(DDZSoundMgr.sfxSound){
				DDZSoundMgr.instance.playEft("sound/pukeChenge");
			}
		}
    }

	public void showResultScore(int score)
	{
		resultScoreTxt.gameObject.SetActive(true);
		resultScoreTxt.play(score);
	}

	public void gameOverState(List<JSONObject> cardsList = null, bool isWinner = false)
	{
		if(vfxWarning != null){
			vfxWarning.gameObject.SetActive(false);
		}
		if(cardCountLb != null){
			cardCountLb.text = "";
		}
		if(vfxWarning != null){
			vfxWarning.gameObject.SetActive(false);
		}


		if(!isMyself){
			if(cardsList != null){
//				Debug.LogError("This really a fault:"+ cardsList[0]);
				if(cardsList.Count> 0 && cardsList[0].ToString() != "null"){
					deskcardCtrl.drawCards(cardsList,isObserver);
				}
				
			}
		}
		string preStr = isBanker?"l":"s";
		string femaleStr = isFemale?"f_":"";
		if(isWinner){
			avatarIcon.spriteName = femaleStr+preStr+animaDc["win"]; 
		}else{
			avatarIcon.spriteName = femaleStr+preStr+animaDc["lose"]; 
		}
		if(managedFlag != null){
			managedFlag.SetActive(false);
		}
    }

	public void showChatBubble(int sentenceID){
		chatBubble.gameObject.SetActive(true);
		string talkInfo = XMLResource.Instance.Str("msg_ddz_" + sentenceID%12);
		if(sentenceID == 19){
			talkInfo = talkInfo.Replace("#","姐");
		}else if(sentenceID == 7){
			talkInfo = talkInfo.Replace("#","哥");
		}
		chatBubble.transform.GetChild(0).GetComponent<UILabel>().text = talkInfo;
		DDZSoundMgr.instance.chat(sentenceID);
		playAvatarAnima("speak");
		Invoke("delayHideChatBubble",2.0f);
	}

	public void checkSpecialCardType(int cardstype)
	{
		//炸弹12，火箭13
		if(cardstype == 12 || cardstype == 13){
			playCoinAnima(2);
			string doubleStr = multipleLb.text;
			doubleStr = doubleStr.Replace("x","");
			int doubleNum = int.Parse(doubleStr);
			Setcalldouble(doubleNum*2);
		}
	}

	private void delayHideChatBubble(){
		chatBubble.gameObject.SetActive(false);
	}

	public void showActBubble(eActType actType){
		string preFix = "_L";
		if(this.GetComponent<UIAnchor>().side == UIAnchor.Side.TopRight){
			preFix = "_R";
		}
		actBubble.gameObject.SetActive(true);
		actBubble.spriteName = actType.ToString() + preFix;

		if(actType == eActType.pass){
			playAvatarAnima("pass");
		}
		Invoke("delayHideActBubble",2.0f);
//		DDZCount.Instance.DestroyHUD();
	}
	private void delayHideActBubble()
	{
		actBubble.gameObject.SetActive(false);
	}

	public void forceHideAllBubble()
	{
		actBubble.gameObject.SetActive(false);
	}


	public bool isMyself{
		get{
			if(myDDZ != null){
				return uid == EginUser.Instance.uid || uid == myDDZ.obID+"";
			}else{
				return uid == EginUser.Instance.uid;
			}
		}
	}

    public void SetReady(bool toShow)
    {
        if (toShow)
        {
            readyObj.SetActive(true);
			readyObj.GetComponent<Animator>().CrossFade("readyAnima",0);
			Debug.Log(this.uid+ "-->Ready");
        }
        else
        {
            readyObj.SetActive(false);
        }
    }

	public void selCardHandle()
	{
		for(int i=0; i< usercards.Count; i++){
			if( usercards[i].GetComponent<DDZPlayercard>().isSelected){
				myDDZ.updateDrawBtnState(true);
				return;
			}
		}
		myDDZ.updateDrawBtnState(false);
	}

    public void SetWait(bool toShow)
    {
        if (waitObj != null)
        {
            if (toShow && !waitObj.activeSelf)
            {
                waitObj.SetActive(true);
            }
            else
            {
                waitObj.SetActive(false);
            }
        }
    }

	public void playCoinAnima(int mulNum)
	{
		if(myDDZ!= null && !myDDZ.isMatch){
			coinAnima.gameObject.SetActive(true);
			coinAnima.CrossFade("coinAnima",0);
			if(DDZSoundMgr.sfxSound){
				DDZSoundMgr.instance.playEft("sound/jiabei_bg");
			}
			if(mulNum == 5 || mulNum == 4 || mulNum == 3 || mulNum == 2){
				coinMultipleSpt.spriteName = "mx"+mulNum;
			}else{
				coinMultipleSpt.spriteName = "mx2";
			}
		}
	}

	public void autoDrawState(){
		if(!isManaged){
			chatBubble.gameObject.SetActive(true);
			chatBubble.transform.GetChild(0).GetComponent<UILabel>().text = "管家助手替我打牌";
			Invoke("delayHideChatBubble",2.0f);
		}
		isManaged = true;

		playAvatarAnima("auto");
		for(int i=0; i< usercards.Count; i++){
			UISprite cardSpt = usercards[i].GetComponent<UISprite>();
			DDZPlayercard card = usercards[i].GetComponent<DDZPlayercard>();
			cardSpt.color = new Color(0.6f,0.6f,0.6f);
			card.resetState();
		}
	}
	public void cancelAutoDraw(){
		isManaged = false;
		playAvatarAnima("default");
		for(int i=0; i< usercards.Count; i++){
			UISprite cardSpt = usercards[i].GetComponent<UISprite>();
			cardSpt.color = new Color(1.0f,1.0f,1.0f);
		}
	}

	public void cmpInfoInit(int rank, int totalRank, int matchTime){
		if(myDDZ != null && myDDZ.is131Happy){
			cMPInfoPanel.myRankLb.text = rank+"";
		}else{
			cMPInfoPanel.myRankLb.text = rank+"/";
		}
		cMPInfoPanel.totalRank.text = totalRank+"";
		if(matchTime != -1){
			cMPInfoPanel.startFinalCD(matchTime);
		}
	}

	#region 观战功能相关
	public void changeDeckColor(List<JSONObject> cards)
	{
		int count = this.usercards.Count;
		int count2 = cards.Count;
		for(int i=0; i< count; i++){
			bool isSelect = false;
			for(int j=0; j<count2; j++){
				if(this.usercards[i].GetComponent<DDZPlayercard>().pokerD.cardID == (int)cards[j].n){
					isSelect = true;
					break;
				}
			}
			if(isSelect){
				this.usercards[i].GetComponent<UISprite>().color = new Color(0.8f, 0.8f, 1.0f);
			}else{
				this.usercards[i].GetComponent<UISprite>().color = new Color(1.0f, 1.0f, 1.0f);
			}
		}
	}

	public void sendSelectCardToServer()
	{
		if(myDDZ != null){
			if(myDDZ.isLiveRoom){
				List<JSONObject> cardDataToServer = new List<JSONObject>();
				int count = usercards.Count;
				for(int i=0; i<count; i++){
					if(usercards[i].GetComponent<DDZPlayercard>().isSelected){
						cardDataToServer.Add(new JSONObject( usercards[i].GetComponent<DDZPlayercard>().pokerD.cardID ));
					}
				}
				if(cardDataToServer.Count>0){
					myDDZ.sendSelectCardMsg( new JSONObject( cardDataToServer.ToArray()) );
				}else{
					myDDZ.sendSelectCardMsg( null );
				}
			}
		}
	}

	private UISprite codeCreateSpt;
//	public void creatLabel(Vector3 vc3, Transform parent, string showStr)
//	{
//		if(codeCreateLb != null)Destroy(codeCreateLb);
//		codeCreateLb = null;
//		if(!isMyself){
//			GameObject obj = Instantiate<GameObject>(userNickname.gameObject);
//			UILabel lb = obj.GetComponent<UILabel>();
//			obj.transform.parent = parent;
//			obj.transform.localScale = Vector3.one;
//			obj.transform.localPosition = vc3;
//			lb.text = showStr;
//			lb.color = Color.white;
//			codeCreateLb = obj;
//		}else{
//			Debug.LogError("creatLabel===>"+ showStr);
//			for(int i=0; i<myDDZ._playingPlayerList.Count; i++){
//				DDZPlayerCtrl playCtrl = myDDZ._playingPlayerList[i].GetComponent<DDZPlayerCtrl>();
//				if(!playCtrl.isMyself){
//					GameObject obj = Instantiate<GameObject>(playCtrl.userNickname.gameObject);
//					UILabel lb = obj.GetComponent<UILabel>();
//					obj.transform.parent = parent;
//					obj.transform.localScale = Vector3.one;
//					obj.transform.localPosition = vc3;
//					lb.text = showStr;
//					lb.color = Color.white;
//					codeCreateLb = obj;
//					return;
//				}
//			}
//		}
//	}
	#endregion

}
