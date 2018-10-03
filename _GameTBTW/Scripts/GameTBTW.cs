using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class GameTBTW : Game
{
    public static int Playercont;

    public GameObject tbtwPlayerPrefab;

    /// <summary>
    /// 游戏玩家的控制脚本
    /// </summary>
    private TBTWPlayerCtrl userPlayerCtrl;

    public GameObject userPlayerObj;

    public GameObject userCardScore;

    public GameObject btnBegin;
    public GameObject btnShow;

    public GameObject msgWaitNext;

    public GameObject msgQuit;
    public GameObject msgAccountFailed;
    public GameObject msgNotContinue;

    public AudioClip soundStart;
    public AudioClip soundWanbi;
    public AudioClip soundXiazhu;
    public AudioClip soundTanover;
    public AudioClip soundWin;
    public AudioClip soundFail;
    public AudioClip soundEnd;
    public AudioClip soundNiuniu;


    private UISprite _userAvatar;
    private UILabel _userNickname;
    private UILabel _userBagmoney;
    private UILabel _userLevel;

    /// <summary>
    /// 游戏开始时正在游戏的玩家
    /// </summary>
    private List<GameObject> _playingPlayerList = new List<GameObject>();

    /// <summary>processok
    /// 游戏开始时等待的玩家
    /// </summary>
    private List<GameObject> _waitPlayerList = new List<GameObject>();

    /// <summary>
    /// 正常进入游戏时已经准备的玩家(wait=true ready=true)，
    /// 需要在游戏开始时加入_playingPlayerList，并清空
    /// </summary>
    private List<GameObject> _readyPlayerList = new List<GameObject>();

    /// <summary>
    /// 动态生成的玩家实例名字的前缀
    /// </summary>
    private string _nnPlayerName = "TBTWPlayer_";

    /// <summary>
    /// 玩家的位置
    /// </summary>
    private int _userIndex = 0;

    private GameObject[] _colorBtns;

    private bool _isPlaying;
    private bool _late;
    private bool _reEnter;

    /// <summary>
    /// 提示框
    /// </summary>
    public UISprite promptDialog;


    public void Awake()
    {
        //base.Awake();

        UIRoot sceneRoot = transform.root.GetComponent<UIRoot>();
        
            float TheDimensions;
        if (sceneRoot != null)
        {
            int manualHeight = 800;		// Android
            TheDimensions = 1280/800;
            promptDialog.height *= (int)TheDimensions;
            promptDialog.width *= (int)TheDimensions;
                //= TheDimensions * 800;

#if UNITY_IPHONE
			if((UnityEngine.iOS.Device.generation.ToString()).IndexOf("iPad") > -1){	// iPad
                manualHeight = 1000;
                TheDimensions = 1280 / 1000;
                promptDialog.height *= (int)TheDimensions;
                promptDialog.width *= (int)TheDimensions;
            }
            else if (Screen.width <= 960)
            {	// <= iPhone4s
                TheDimensions = 1280 / 960;
                promptDialog.height *= (int)TheDimensions;
                promptDialog.width *= (int)TheDimensions;
				manualHeight = 900;
			}
#endif

            sceneRoot.scalingStyle = UIRoot.Scaling.ConstrainedOnMobiles;
            sceneRoot.manualHeight = manualHeight;
            TheDimensions = 1280 / manualHeight;
            promptDialog.height *= (int)TheDimensions;
            promptDialog.width *= (int)TheDimensions;
        }

        Application.LoadLevelAdditive("FootInfo_TBTW");

        Application.LoadLevelAdditive("Game_Setting");

        if (PlatformGameDefine.playform.IsPool)
        {
            Application.LoadLevelAdditive("JiangChi");
        }
    }

    protected void OnEnable()
    {
    }

    protected void OnDisable()
    {
    }

    //-----------------------------------------------------------------
    protected void OnDestroy()
    {
    }


    void Start()
    {
        GameTBTW.Playercont = 0;
        if (SettingInfo.Instance.autoNext == true || SettingInfo.Instance.deposit == true)
        {
            btnBegin.SetActive(false);
        }
        GameObject info = GameObject.Find("Panel_Setting");
        if (info)
        {
            info.GetComponent<GameSettingManager>().setDepositVisible(true);
        }

        base.StartGameSocket();
    }

    public override void SocketReceiveMessage(string message)
    {
        base.SocketReceiveMessage(message);

        JSONObject messageObj = new JSONObject(message);
        string type = messageObj["type"].str;
        string tag = messageObj["tag"].str;
        if ("game".Equals(type))
        {
            switch (tag)
            {
                case "enter":
                    ProcessEnter(messageObj);
                    break;
                case "ready":
                    ProcessReady(messageObj);
                    break;
                case "come":
                    ProcessCome(messageObj);
                    break;
                case "leave":
                    ProcessLeave(messageObj);
                    break;
                case "deskover":
                    ProcessDeskOver(messageObj);
                    break;
                case "notcontinue":
                    StartCoroutine(ProcessNotcontinue());
                    break;
            }
        }
        else if ("tbtw".Equals(type))
        {
            switch (tag)
            {
                case "time":
                    int t = (int)messageObj["body"].n;
                    NNCount.Instance.UpdateHUD(t);
                    break;
                case "late":
                    ProcessLate(messageObj);
                    break;
                case "deal":
                    StartCoroutine(ProcessDeal(messageObj));
                    break;
                case "ok":
                    ProcessOk(messageObj);
                    break;
                case "end":
                    StartCoroutine(ProcessEnd(messageObj));
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

    void ProcessEnter(JSONObject messageObj)
    {
        JSONObject body = messageObj["body"];
        List<JSONObject> memberinfos = body["memberinfos"].list;
        userPlayerCtrl = userPlayerObj.GetComponent<TBTWPlayerCtrl>();
        foreach (JSONObject memberinfo in memberinfos)
        {
            if (memberinfo != null)
            {
                if (memberinfo["uid"].ToString() == EginUser.Instance.uid)
                {
                    _userIndex = (int)(memberinfo["position"].n);
                    bool waiting = (bool)memberinfo["waiting"].b;

                    if (waiting)
                    {
                        _waitPlayerList.Add(userPlayerObj);
                    }
                    else
                    {
                        _playingPlayerList.Add(userPlayerObj);
                        _reEnter = true;
                    }
                    int height = userPlayerObj.transform.root.GetComponent<UIRoot>().manualHeight;
                    userCardScore.transform.localPosition = new Vector3(0, (-.07f * height - 52) - userPlayerObj.transform.localPosition.y, 0);

                    userPlayerObj.name = _nnPlayerName + EginUser.Instance.uid;

                    if (SettingInfo.Instance.autoNext == true || SettingInfo.Instance.deposit == true)
                    {
                        UserReady();
                    }
                    break;
                }
            }
        }
         
        foreach (JSONObject memberinfo in memberinfos)
        {
            if (memberinfo != null)
            {
                if (memberinfo["uid"].ToString() != EginUser.Instance.uid)
                {
                    AddPlayer(memberinfo, _userIndex);
                }
            }
        }

        JSONObject deskinfo = body["deskinfo"];
        int t = (int)deskinfo["continue_timeout"].n;
        TBTWCount.Instance.UpdateHUD(t);
    }

    GameObject AddPlayer(JSONObject memberinfo, int _userIndex)
    {
        string uid = memberinfo["uid"].ToString();
        string bag_money = memberinfo["bag_money"].ToString();
        string nickname = memberinfo["nickname"].str;
        int avatar_no = (int)(memberinfo["avatar_no"].n);
        int position = (int)(memberinfo["position"].n);
        bool ready = (bool)memberinfo["ready"].b;
        bool waiting = (bool)memberinfo["waiting"].b;
        string level = memberinfo["level"].ToString();

        GameObject player = NGUITools.AddChild(this.gameObject, tbtwPlayerPrefab);
        player.name = _nnPlayerName + uid;


        //myplayer.Add(player);


        SetAnchorPosition(player, _userIndex, position);
        TBTWPlayerCtrl ctrl = player.GetComponent<TBTWPlayerCtrl>();
        ctrl.SetPlayerInfo(avatar_no, nickname, bag_money, level);

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

    IEnumerator ProcessLate(JSONObject messageObj)
    {
        if (!_reEnter)
        {
            _late = true;
            msgWaitNext.SetActive(true);
        }
        //（late进入时不显示开始按钮，显示等待）
        btnBegin.SetActive(false);

        JSONObject body = messageObj["body"];

        int chip = (int)body["chip"].n;
        if (chip > 0)
        {
            List<JSONObject> infos = body["infos"].list;
            foreach (JSONObject info in infos)
            {
                string uid = info[0].ToString();
                int waitting = (int)info[1].n;
                int show = (int)info[2].n;
                List<JSONObject> cards = info[3].list;
                int cardType = (int)info[4].n;

                GameObject player = GameObject.Find(_nnPlayerName + uid);
                if (player != null)
                {
                    TBTWPlayerCtrl ctrl = player.GetComponent<TBTWPlayerCtrl>();
                    if (waitting == 0)
                    {
                        //显示筹码
                        ctrl.SetBet(chip);

                        if (player == userPlayerObj)
                        {
                            ctrl.SetLate(cards);
                            if (show == 1)
                            {
                                ctrl.SetCardTypeUser(cards, cardType);
                            }
                            else
                            {
                                if (SettingInfo.Instance.deposit == true)
                                {
                                    yield return new WaitForSeconds(2.5f);
                                    UserShow();
                                }
                                //btnShow.SetActive(true);
                            }
                        }
                        else
                        {
                            //显示正在游戏的玩家的牌
                            ctrl.SetLate(null);
                            if (show == 1)
                            {
                                ctrl.SetShow(true);
                            }
                        }
                    }
                    else
                    {
                        ctrl.SetWait(true);
                    }
                }
            }
        }

        int t = (int)body["t"].n;
        TBTWCount.Instance.UpdateHUD(t);
    }

    void SetAnchorPosition(GameObject player, int _userIndex, int playerIndex)
    {
        int position_span = playerIndex - _userIndex;
        UIAnchor anchor = player.GetComponent<UIAnchor>();
        if (position_span == 0)
        {
            anchor.side = UIAnchor.Side.Bottom;
        }
        else if (position_span == 1 || position_span == -5)
        {
            anchor.side = UIAnchor.Side.BottomRight;
            //			anchor.pixelOffset.x = -80f;
            anchor.relativeOffset.x = -.06f;
            anchor.relativeOffset.y = .43f;
        }
        else if (position_span == 2 || position_span == -4)
        {
            anchor.side = UIAnchor.Side.TopRight;
            //			anchor.pixelOffset.x = -80f;
            anchor.relativeOffset.x = -.06f;
            anchor.relativeOffset.y = -.28f;
        }
        else if (position_span == 3 || position_span == -3)
        {
            anchor.side = UIAnchor.Side.Top;
            //			anchor.pixelOffset.x = -65f;
            //			anchor.pixelOffset.y = -80f;
            anchor.relativeOffset.x = -.06f;
            anchor.relativeOffset.y = -.11f;
            //			anchor.relativeOffset.y = 0f;
        }
        else if (position_span == 4 || position_span == -2)
        {
            anchor.side = UIAnchor.Side.TopLeft;
            //			anchor.pixelOffset.x = 80f;
            anchor.relativeOffset.x = .06f;
            anchor.relativeOffset.y = -.28f;
        }
        else if (position_span == 5 || position_span == -1)
        {
            anchor.side = UIAnchor.Side.BottomLeft;
            //			anchor.pixelOffset.x = 80f;
            anchor.relativeOffset.x = .06f;
            anchor.relativeOffset.y = .43f;
        }
    }

    void ProcessReady(JSONObject messageObj)
    {
        string uid = messageObj["body"].ToString();
        GameObject player = GameObject.Find(_nnPlayerName + uid);
        TBTWPlayerCtrl ctrl = player.GetComponent<TBTWPlayerCtrl>();

        //去掉牌型显示
        if (uid == EginUser.Instance.uid)
        {
            //StartCoroutine(ctrl.SetDeal(false, null));
            ctrl.SetDeal(false, null);
            ctrl.SetCardTypeUser(null, 0);
            ctrl.SetScore(-1);
        }
        else
        {
            //如果主玩家已经重新开始，则清除当前用户的牌型显示
            if (!btnBegin.activeSelf)
            {
                //StartCoroutine(ctrl.SetDeal(false, null));
                ctrl.SetDeal(false, null);
                ctrl.SetCardTypeOther(null, 0);
                ctrl.SetScore(-1);
            }
        }

        //显示准备
        ctrl.SetReady(true);
        _playingPlayerList.Add(player);
    }

    public void UserReady()
    {
        //向服务器发送消息（开始游戏）
        JSONObject startJson = new JSONObject();
        startJson.AddField("type", "tbtw");
        startJson.AddField("tag", "start");
        base.SendPackageWithJson(startJson);

        EginTools.PlayEffect(soundStart);

        btnBegin.SetActive(false);
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
        foreach (GameObject player in _readyPlayerList)
        {
            if (!_playingPlayerList.Contains(player))
            {
                Debug.Log(player.name);
                _playingPlayerList.Add(player);
                
            }
        }
        _readyPlayerList.Clear();

        StartCoroutine(TimeAnimation());
        //清除未被清除的牌
        foreach (GameObject player in _playingPlayerList)
        {
            if (player != null && player != userPlayerObj)
            {
                TBTWPlayerCtrl ctrl = player.GetComponent<TBTWPlayerCtrl>();
                //StartCoroutine(ctrl.SetDeal(false, null));
                ctrl.SetDeal(false, null);
                ctrl.SetCardTypeOther(null, 0);
                ctrl.SetScore(-1);
            }
        }
        //去掉“准备”
        foreach (GameObject player in _playingPlayerList)
        {
            if (player != null)
            {
                player.GetComponent<TBTWPlayerCtrl>().SetReady(false);
            }
        }
        //去掉筹码显示
        foreach (GameObject player in _playingPlayerList)
        {
            if (player != null)
            {
                player.GetComponent<TBTWPlayerCtrl>().SetBet(0);
            }
        }
        EginTools.PlayEffect(soundXiazhu);

        JSONObject body = messageObj["body"];
        List<JSONObject> cards = body["cards"].list;
        int chip = (int)body["chip"].n;
        int t = (int)body["t"].n;

        TBTWCount.Instance.UpdateHUD(t);
        //下注
        foreach (GameObject player in _playingPlayerList)
        {
            if (player != null)
            {
                TBTWPlayerCtrl ctrl = player.GetComponent<TBTWPlayerCtrl>();

                ctrl.SetBet(chip);
                ctrl.SetUserChip(chip);
            }
        }

        //发牌
        foreach (GameObject player in _playingPlayerList)
        {
            if (player != null)
            {
                TBTWPlayerCtrl ctrl = player.GetComponent<TBTWPlayerCtrl>();
                ctrl.SetBet(chip);
                ctrl.SetUserChip(chip);
                if (player == userPlayerObj)
                {
                    //StartCoroutine(ctrl.SetDeal(true, cards));
                    ctrl.SetDeal(true, cards);
                }
                else
                {
                    //StartCoroutine(ctrl.SetDeal(true, null));
                    ctrl.SetDeal(true, null);
                }
            }
        }

        yield return new WaitForSeconds(2.5f);

        //非late进入时才显示摊牌按钮
        if (!_late)
        {
            if (SettingInfo.Instance.deposit == true)
            {
                yield return new WaitForSeconds((_playingPlayerList.Count*0.5f));
                UserShow();
            }
        }
    }

    void ProcessOk(JSONObject messageObj)
    {
        JSONObject body = messageObj["body"];
        string uid = body["uid"].ToString();

        if (uid != EginUser.Instance.uid)
        {
            GameObject.Find(_nnPlayerName + uid).GetComponent<TBTWPlayerCtrl>().SetShow(true);
        }
        else
        {
            List<JSONObject> cards = body["cards"].list;
            int cardType = (int)body["type"].n;
            userPlayerCtrl.SetCardTypeUser(cards, cardType);
        }

        EginTools.PlayEffect(soundTanover);
    }

    void UserShow()
    {
        JSONObject ok = new JSONObject();
        ok.AddField("type", "tbtw");
        ok.AddField("tag", "ok");
        base.SendPackageWithJson(ok);

        btnShow.SetActive(false);
    }

    IEnumerator ProcessEnd(JSONObject messageObj)
    {
        //去掉下注额
        foreach (GameObject player in _playingPlayerList)
        {
            if (player != userPlayerObj)
            {
                player.GetComponent<TBTWPlayerCtrl>().SetShow(false);
            }
        }

        if (msgWaitNext.activeSelf) msgWaitNext.SetActive(false);

        _playingPlayerList.Clear();


        JSONObject body = messageObj["body"];
        List<JSONObject> infos = body["infos"].list;

        //玩家扑克牌信息
        foreach (JSONObject info in infos)
        {
            List<JSONObject> jos = info.list;
            string uid = jos[0].ToString();
            TBTWPlayerCtrl ctrl = GameObject.Find(_nnPlayerName + uid).GetComponent<TBTWPlayerCtrl>();
            List<JSONObject> cards = jos[1].list;
            //牌型
            int cardType = (int)jos[2].n;
            //得分
            int score = (int)jos[3].n;

            //明牌
            if (uid != EginUser.Instance.uid)
            {
                ctrl.SetCardTypeOther(cards, cardType);
            }
            else
            {
                if (btnShow.activeSelf)
                {
                    btnShow.SetActive(false);
                    ctrl.SetCardTypeUser(cards, cardType);
                }
                if (cardType == 10)
                {
                    EginTools.PlayEffect(soundNiuniu);
                }
                if (score > 0)
                {
                    EginTools.PlayEffect(soundWin);
                }
                else if (score < 0)
                {
                    EginTools.PlayEffect(soundFail);
                }
            }
            //更新bagmoney
            //			ctrl.UpdateIntoMoney(score);
            ctrl.SetScore(score);
        }


        //去掉所有等待中玩家的”等待中“， 显示开始换桌按钮
        foreach (GameObject player in _waitPlayerList)
        {
            if (player != userPlayerObj)
            {
                player.GetComponent<TBTWPlayerCtrl>().SetWait(false);
            }
        }
        _waitPlayerList.Clear();


        if (_late)
        {
            EginTools.PlayEffect(soundEnd);
            _late = false;
        }
        else
        {
            btnBegin.transform.localPosition = new Vector3(350, 0, 0);
        }

        if (SettingInfo.Instance.autoNext == true || SettingInfo.Instance.deposit == true)
        {
            yield return new WaitForSeconds(2);
            UserReady();
        }
        else
        {
            btnBegin.SetActive(true);
        }

        int t = (int)body["t"].n;
        TBTWCount.Instance.UpdateHUD(t);

        _isPlaying = false;
    }

    void ProcessDeskOver(JSONObject messageObj)
    {
        //		if(_late) {
        //			EginTools.PlayEffect(soundEnd);
        //			_late = false;
        //		}
        //
        //		//去掉所有等待中玩家的”等待中“， 显示开始换桌按钮
        //		foreach(GameObject player in _waitPlayerList) {
        //			if(player != userPlayerObj) {
        //				player.GetComponent<TBTWPlayerCtrl>().SetWait(false);
        //			}
        //		}
        //		_waitPlayerList.Clear ();
        //
        //		btnBegin.transform.localPosition = new Vector3 (300, 0, 0);
        //		btnBegin.SetActive (true);
        //
        //		int t = (int)messageObj["body"].n;
        //		NNCount.Instance.UpdateHUD(t);
        //
        //		_isPlaying = false;
    }

    void ProcessUpdateAllIntomoney(JSONObject messageObj)
    {
        if (!messageObj.ToString().Contains(EginUser.Instance.uid)) { return; }

        List<JSONObject> infos = messageObj["body"].list;
        foreach (JSONObject info in infos)
        {
            string uid = info[0].ToString();
            string intoMoney = info[1].ToString();
            GameObject player = GameObject.Find(_nnPlayerName + uid);
            if (player != null)
            {
                GameObject.Find(_nnPlayerName + uid).GetComponent<TBTWPlayerCtrl>().UpdateIntoMoney(intoMoney);
            }
        }
    }

    public override void ProcessUpdateIntomoney(JSONObject messageObj)
    {
        string intoMoney = messageObj["body"].ToString();
        GameObject info = GameObject.Find("Panel_info");
        if (null != info)
        {
            info.GetComponent<FootInfo_TBTW>().UpdateIntomoney(intoMoney);
        }
    }

    void ProcessCome(JSONObject messageObj)
    {
        JSONObject body = messageObj["body"];
        JSONObject memberinfo = body["memberinfo"];
        GameObject player = AddPlayer(memberinfo, _userIndex);

        if (_isPlaying) player.GetComponent<TBTWPlayerCtrl>().SetWait(true);
    }

    void ProcessLeave(JSONObject messageObj)
    {
        string uid = messageObj["body"].ToString();
        if (!uid.Equals(EginUser.Instance.uid))
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
            Destroy(player);
        }
    }

    void UserLeave()
    {
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

    /* ------ Button Click ------ */
    public override void OnClickBack()
    {
        if (!_isPlaying)
        {
            UserQuit();
        }
        else
        {
            msgQuit.SetActive(true);
        }
    }

    public override void ShowPromptHUD(string errorInfo)
    {
        btnBegin.SetActive(false);
        msgAccountFailed.SetActive(true);
        msgAccountFailed.GetComponentInChildren<UILabel>().text = errorInfo;
    }

    /* ------ Socket Listener ------ */
    public override void SocketReady()
    {
        base.SocketReady();
    }

    public override void SocketDisconnect(string disconnectInfo)
    {
        base.SocketDisconnect(disconnectInfo);
    }

    public Vector3[] myrotation;
    public GameObject myTimeAnimation;
    public List<GameObject> myplayer;
    public IEnumerator TimeAnimation()
    {
        Debug.Log("doing");

        iTween.RotateTo(myTimeAnimation, myrotation[0], 0.5f);
        yield return new WaitForSeconds(0.5f);
        userPlayerObj.gameObject.GetComponent<TBTWPlayerCtrl>().bosonA.SetActive(true);
        for(int i = 0;i<_playingPlayerList.Count;i++){
            foreach (GameObject player2 in _playingPlayerList)
            {
                switch (player2.gameObject.GetComponent<UIAnchor>().side)
                {
                    case UIAnchor.Side.TopRight:
                        if (i == 3)
                        {
                            iTween.RotateTo(myTimeAnimation, myrotation[4], 0.5f);
                            yield return new WaitForSeconds(0.5f);
                            player2.gameObject.GetComponent<TBTWPlayerCtrl>().bosonA.SetActive(true);
                        }
                        break;
                    case UIAnchor.Side.BottomRight:
                        if (i == 4)
                        {
                            iTween.RotateTo(myTimeAnimation, myrotation[5], 0.5f);
                            yield return new WaitForSeconds(0.5f);
                            player2.gameObject.GetComponent<TBTWPlayerCtrl>().bosonA.SetActive(true);
                        }
                        break;
                    case UIAnchor.Side.Top:
                        if (i == 2)
                        {
                            iTween.RotateTo(myTimeAnimation, myrotation[3], 0.5f);
                            yield return new WaitForSeconds(0.5f);
                            player2.gameObject.GetComponent<TBTWPlayerCtrl>().bosonA.SetActive(true);
                        }
                        break;
                    case UIAnchor.Side.TopLeft:
                        if (i == 1)
                        {
                            iTween.RotateTo(myTimeAnimation, myrotation[2], 0.5f);
                            yield return new WaitForSeconds(0.5f);
                            player2.gameObject.GetComponent<TBTWPlayerCtrl>().bosonA.SetActive(true);
                        }
                        break;
                    case UIAnchor.Side.BottomLeft:
                        if (i == 0)
                        {
                            iTween.RotateTo(myTimeAnimation, myrotation[1], 0.5f);
                            yield return new WaitForSeconds(0.5f);
                            player2.gameObject.GetComponent<TBTWPlayerCtrl>().bosonA.SetActive(true);
                        }
                        break;
                    case UIAnchor.Side.Center:
                        iTween.RotateTo(myTimeAnimation, myrotation[0], 0.5f);
                        break;
                }
            }
        }

        foreach (GameObject player in _playingPlayerList)
        {
            player.gameObject.GetComponent<TBTWPlayerCtrl>().bosonA.GetComponent<RAnimation>().OnAnimationPlay();
        }
        userPlayerObj.gameObject.GetComponent<TBTWPlayerCtrl>().bosonA.GetComponent<RAnimation>().OnAnimationPlay();

        yield return new WaitForSeconds(2.3f);
        if(SettingInfo.Instance.deposit != true)
        btnShow.SetActive(true);
    }
}
