require "GameSRFTWZ/SRFivePlayerCtrl"
--require "GameNN/GameSettingManager"

local cjson = require "cjson"


local this = LuaObject:New()
GameSRFTWZ = this

local _userIndex = 0
local _waitPlayerList = {}
local _readyPlayerList = {}

local userPlayerCtrl = 0
local _userAvatar = 0;
local _userNickname = 0;
local _userBagmoney = 0;
local _userLevel = 0
local otherUid="0";
local _playingPlayerList = {};
local _nnPlayerName = "FivePlayer_";
local _bankerPlayer = nil;
local _colorBtns ={};
local  _isPlaying = false;
local _late = false;
local  _reEnter = false;
local  ju_time = 30;
local _enterOutTime = 30;
local _readyOutTime = 30;
local  _currTime = 0;
local  _num = 0;
local gameRound = 0;--总局数
local  gameInnings = 0;--当前局数
local gameStep = 0;--当前游戏阶段
local readyST = 0;
local diChip = 0;---低注
local maxZhu = 0;---最大注
--local otherBetNum = 0;---其他人下注的数量
local selfBetNum = 0;---自己下注的数量
local inHandPaiNum = 0;
local is_guo = false --是否过牌
local isSelfQP = false;
local otherUname = "";
local curChatID = 0
local curMotionID = 0
local chatTime = -10
local motionTime = -10
local chatArr = nil
local isOverState = false -- 是否结算状态
local _delayLeaveComeMsg = {} 

function this:bindPlayerCtrl(objName, gameObj)
    this._ftwzPlayerCtrl[objName] = SRFivePlayerCtrl:New(gameObj)
end

function this:getPlayerCtrl(objName,tbObj)
	if this._ftwzPlayerCtrl[objName] == nil then
		error("getPlayerCtrl is nil :"..objName.." table:"..PrintTable(this._ftwzPlayerCtrl))
	end
    return this._ftwzPlayerCtrl[objName]
end

function this:removePlayerCtrl( objName )
    if(this._ftwzPlayerCtrl[objName] ~= nil)then
        this._ftwzPlayerCtrl[objName]:OnDestroy()
    end
    this._ftwzPlayerCtrl[objName] = nil;
end

function this:clearLuaValue()
	-- 停止播放背景音乐
    UISoundManager.PauseBGSound();
	userPlayerCtrl = 0
	_userAvatar = 0;
	_userNickname = 0;
	_userBagmoney = 0;
	_userLevel = 0
	otherUid="0";
	
	_delayLeaveComeMsg = {}
    _waitPlayerList = {}
    _playingPlayerList = {}
    _readyPlayerList = {}
	_nnPlayerName = "FivePlayer_";
	_bankerPlayer = nil;
	_colorBtns ={};
	_isPlaying = false;
	_late = false;
	_reEnter = false;
	ju_time = 30;
	_currTime = 0;
	_num = 0
	 gameRound = 0;--总局数
	gameInnings = 0;--当前局数
	gameStep = 0;--当前游戏阶段
	readyST = 0;
	diChip = 0;---低注
	maxZhu = 0;---最大注
	--otherBetNum = 0;---其他人下注的数量
	selfBetNum = 0;---自己下注的数量
	inHandPaiNum = 0;
	is_guo = false;
	isOverState = false

	isSelfQP = false;
	otherUname = ""
	curChatID = 0
	curMotionID = 0
	chatArr = nil
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	
	this.includePool = false;
	this.includeOptions = false;
	this.diChipBei = {0.5,1,2};---0.5 1 2
	this.dznnPlayerPrefab= nil;

	this.userPlayerObj = nil;
	this.btnCallBankers = nil;
	this.btnBegin = nil				--GameObject
	this.btnShow = nil				--GameObject
	this.msgWaitNext = nil;
	this.msgWaitBet = nil;
	this.chooseChipObj = nil;
	this.btnsObj = nil;
	this.chooseChipObj0 = nil;
	
	this.msgQuit = nil				--GameObject
	this.msgAccountFailed = nil		--GameObject
	this.msgNotContinue =nil			--GameObject
	--音效
	this.soundStart = nil				--AudioClip
	this.soundWanbi = nil;				--AudioClip
	this.soundXiazhu = nil;			--AudioClip
	this.soundTanover =nil;			--AudioClip
	this.soundWin = nil;				--AudioClip
	this.soundFail = nil;				--AudioClip	
	this.soundEnd = nil;				--AudioClip
	this.soundNiuniu = nil;			--AudioClip
	
	this.topScore1 = nil;
	this.topScore2 = nil;
	this.bottomScore1 = nil;
	this.bottomScore2 = nil;
	this.leftScore1 = nil;
	this.leftScore2 = nil;
	this.rightScore1 = nil;
	this.rightScore2 = nil;
	this.allScore = nil;
	this.allScore1 = nil;
	this.chipInfoMaxChip = nil;
	this.chipInfoCurChip = nil;

	this.jsk = nil;
	this.bm_view = nil;    --报名界面
	this.fuhuo_view = nil;    --复活界面
	this.jiangzhuang_view = nil;    --奖状界面
	this.paimingkuang_view = nil;    --排名框界面
	this.bm_fei = nil;    --报名费用
	this.bm_stime = nil;    --开始时间
	this.bm_pnum = nil;    --当亲人数
	this.bm_xian = nil;    --人数限制
	this.bm_time = nil;    --倒计时
	this.bm_JiangList = nil;    --奖励说明
	this.jz_name = nil;    --用户名
	this.jz_gameName = nil;    --游戏名
	this.jz_jNum = nil;    --名次
	this.jz_info = nil;    --奖励内容
	this.jz_time = nil;    --日期
	this.fh_tJian = nil;    --复活的条件
	this.pmk_bg = nil;    --排名框的 背景
	this.pmk_SATxt = nil;    --  自己名次/总人数
	this.pmk_myScoreTxt = nil;    -- 我的积分
	this.pmk_juLunTxt = nil;    --局数/轮数
	this.pmk_jinJuTxt = nil;    --晋级局数
	this.pmk_nickArr = {};    --排名框的 排名列表
	this.pmk_scoreArr = {};    --排名框的 分数列表
	this.pmk_listView = nil;    --排名框列表
	this.jsk_closeBtn = nil;
	this.jsk_exitBtn = nil
	this.jsk_startBtn = nil;
	
	
	this:RemoveAllFivePlayerCtrl();
	LuaGC();
end
function this:Init()
	--初始化变量
	userPlayerCtrl = nil;
	_userAvatar = 0;
	_userNickname = 0;
	_userBagmoney = 0;
	_userLevel = 0
	otherUid="0";
	_playingPlayerList = {};
	_nnPlayerName = "FivePlayer_";
	_bankerPlayer = nil;
	_colorBtns ={};
	_isPlaying = false;
	_late = false;
	_reEnter = false;
	ju_time = 30;
	_currTime = 0;
	_num = 0
	 gameRound = 0;--总局数
	gameInnings = 0;--当前局数
	gameStep = 0;--当前游戏阶段
	readyST = 0;
	diChip = 0;---低注
	maxZhu = 0;---最大注
	--otherBetNum = 0;---其他人下注的数量
	selfBetNum = 0;---自己下注的数量
	inHandPaiNum = 0;
	is_guo = false;

	isSelfQP = false;
	otherUname = "";
	
 

	this.includePool = false;
	this.includeOptions = false;
	this.diChipBei = {0.5,1,2};---0.5 1 2
	
	this.dznnPlayerPrefab= ResManager:LoadAsset("gamesrftwz/srfiveplayer","srfiveplayer");
	this.userPlayerObj = this.transform:FindChild("Content/User").gameObject;
	this.btnCallBankers = this.transform:FindChild("Content/User/BtnCallBanker").gameObject;
	this.btnBegin = this.transform:FindChild("Content/User/Button_begin").gameObject				--GameObject
	this.btnShow = this.transform:FindChild("Content/User/Button_show").gameObject				--GameObject
	
	this.msgWaitNext = this.transform:FindChild("Content/MsgContainer/MsgWaitNext").gameObject;
	this.msgWaitBet = this.transform:FindChild("Content/MsgContainer/MsgWaitBet").gameObject;
	
	this.chooseChipObj = this.transform:FindChild("Content/User/ChooseChips").gameObject;
	this.btnsObj = this.transform:FindChild("Content/User/btns").gameObject;
	this.chooseChipObj0 = this.transform:FindChild("Content/User/ChooseChips0").gameObject;
	
	this.msgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject				--GameObject
	this.msgAccountFailed = this.transform:FindChild("Content/MsgContainer/MsgAccountFailed").gameObject		--GameObject
	this.msgNotContinue = this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject			--GameObject
	
	--音效
	this.soundStart = ResManager:LoadAsset("gamenn/Sound","GAME_START") 	--AudioClip
	this.soundWanbi = ResManager:LoadAsset("gamenn/Sound","wanbi") 	--AudioClip
	this.soundXiazhu = ResManager:LoadAsset("gamenn/Sound","xiazhu") 	--AudioClip
	this.soundTanover = ResManager:LoadAsset("gamenn/Sound","tanover") 	--AudioClip
	this.soundWin = ResManager:LoadAsset("gamenn/Sound","win") 	--AudioClip
	this.soundFail = ResManager:LoadAsset("gamenn/Sound","fail") 	--AudioClip	
	this.soundEnd = ResManager:LoadAsset("gamenn/Sound","GAME_END") --resLoad("Sound/GAME_END");				--AudioClip
	this.soundNiuniu = ResManager:LoadAsset("gamenn/Sound","niuniu") --resLoad("Sound/niuniu");			--AudioClip
	
	--帮助
	this.btnHelp = this.transform:FindChild("Content/Button_help").gameObject	
	this.helpPanel = this.transform:FindChild("Content/helpPanel").gameObject
	this.helpPanelCloseBtn = this.transform:FindChild("Content/helpPanel/Button_exit").gameObject
	this.mono:AddClick(this.btnHelp, this.onClickHelp);
	this.mono:AddClick(this.helpPanelCloseBtn, this.onClickExitHelp);


	--表情
	this.motionBtnHelp = this.transform:FindChild("Content/Button_express").gameObject	
	this.motionPanel = this.transform:FindChild("Content/PanelEmotion").gameObject--:GetComponent("EmotionPanel")
	this.motionGridTransform = this.transform:FindChild("Content/PanelEmotion/Scroll View/Grid")
	this.mono:AddClick(this.motionBtnHelp, this.onClickMotion);
	--this:initMotion()
	for i=1,27 do
		this.mono:AddClick(this.motionGridTransform.transform:FindChild("biaoqing_"..i).gameObject,this.onClickSendMotion,this);
	end
	
	--聊天
    this.chatBtn = this.transform:FindChild("Content/Button_vocie").gameObject	
	this.mono:AddClick(this.chatBtn,this.onClickChat)
	this.chatPanel = this.transform:FindChild("Content/PanelChat").gameObject:GetComponent("ChatPanel")
	--this.chatPanel:initDataWithSex(EginUser.sex == 1)
	this:initChatData(EginUser.Instance.sex=="0")
	this.sendChatBtn = this.transform:FindChild("Content/PanelChat/bg2/sendBtn").gameObject
	this.mono:AddClick(this.sendChatBtn,this.onClickSendChat)

	this.bottomScore1 = this.transform:FindChild("Content/zhus/bottomScore1").gameObject;
	this.bottomScore2 = this.transform:FindChild("Content/zhus/bottomScore2").gameObject;
	this.topScore1 = this.transform:FindChild("Content/zhus/topScore1").gameObject;
	this.topScore2 = this.transform:FindChild("Content/zhus/topScore2").gameObject;
	this.rightScore1 = this.transform:FindChild("Content/zhus/rightScore1").gameObject;
	this.rightScore2 = this.transform:FindChild("Content/zhus/rightScore2").gameObject;
	this.leftScore1 = this.transform:FindChild("Content/zhus/leftScore1").gameObject;
	this.leftScore2 = this.transform:FindChild("Content/zhus/leftScore2").gameObject;
	this.allScore = this.transform:FindChild("Content/zhus/allScore").gameObject;
	this.allScore1 = this.transform:FindChild("Panel_background/AnchorChips/Sprite/AllChip").gameObject;
	this.chipInfoMaxChip = this.transform:FindChild("Panel_background/AnchorChips/Sprite/MaxChip").gameObject
	this.chipInfoCurChip = this.transform:FindChild("Panel_background/AnchorChips/Sprite/CurChip").gameObject
	this["bottomScore1"]:SetActive(false)

	this.jsk = this.transform:FindChild("Content/JSK").gameObject;
	this.nnCountAnchor = this.transform:FindChild("Content/NNCount").gameObject:GetComponent("UIAnchor")
	this.bm_view = this.transform:FindChild("Content/Panel_baoming").gameObject;    --报名界面
	this.fuhuo_view = this.transform:FindChild("Content/fuhuo").gameObject;    --复活界面
	this.jiangzhuang_view = this.transform:FindChild("Content/jiangZhuang").gameObject;    --奖状界面
	this.paimingkuang_view = this.transform:FindChild("Content/paiming/paimingKuang").gameObject;    --排名框界面
	this.bm_fei = this.transform:FindChild("Content/Panel_baoming/ziti/bm_fei").gameObject;    --报名费用
	this.bm_stime = this.transform:FindChild("Content/Panel_baoming/ziti/bm_stime").gameObject;    --开始时间
	this.bm_pnum = this.transform:FindChild("Content/Panel_baoming/ziti/bm_pnum").gameObject;    --当亲人数
	this.bm_xian = this.transform:FindChild("Content/Panel_baoming/ziti/bm_xian").gameObject;    --人数限制
	this.bm_time = this.transform:FindChild("Content/Panel_baoming/ziti/bm_time").gameObject;    --倒计时
	this.bm_JiangList = this.transform:FindChild("Content/Panel_baoming/jiangList").gameObject;    --奖励说明
	this.jz_name = this.transform:FindChild("Content/jiangZhuang/uname").gameObject;    --用户名
	this.jz_gameName = this.transform:FindChild("Content/jiangZhuang/ugameName").gameObject;    --游戏名
	this.jz_jNum = this.transform:FindChild("Content/jiangZhuang/uNum").gameObject;    --名次
	this.jz_info = this.transform:FindChild("Content/jiangZhuang/uInfo").gameObject;    --奖励内容
	this.jz_time = this.transform:FindChild("Content/jiangZhuang/riqi").gameObject;    --日期
	this.fh_tJian = this.transform:FindChild("Content/fuhuo/tjian").gameObject;    --复活的条件
	this.pmk_bg = this.transform:FindChild("Content/paiming/paimingKuang/bg").gameObject;    --排名框的 背景
	this.pmk_SATxt = this.transform:FindChild("Content/paiming/paimingKuang/txt1").gameObject;    --  自己名次/总人数
	this.pmk_myScoreTxt = this.transform:FindChild("Content/paiming/paimingKuang/score").gameObject;    -- 我的积分
	this.pmk_juLunTxt = this.transform:FindChild("Content/paiming/paimingKuang/ju_lun").gameObject;    --局数/轮数
	this.pmk_jinJuTxt = this.transform:FindChild("Content/paiming/paimingKuang/jinJu").gameObject;    --晋级局数
	this.pmk_listView = this.transform:FindChild("Content/paiming/paimingKuang/listView").gameObject;    --排名框列表
	
	this.jsk_closeBtn = this.transform:FindChild("Content/JSK/Button_close").gameObject;
	this.jsk_exitBtn = this.transform:FindChild("Content/JSK/Button_exit").gameObject;

	this.jsk_startBtn = this.transform:FindChild("Content/JSK/Button_start").gameObject;
	this.ButtonAllIn = this.btnsObj.transform:FindChild("ButtonAllIn").gameObject;
	this.pmk_nickArr = {};    --排名框的 排名列表
	for i=0,9  do
		table.insert(this.pmk_nickArr,this.transform:FindChild("Content/paiming/paimingKuang/listView/nick"..i).gameObject);	
	end
	this.pmk_scoreArr = {};    --排名框的 分数列表
	for i=0,9  do
		table.insert(this.pmk_scoreArr,this.transform:FindChild("Content/paiming/paimingKuang/listView/score"..i).gameObject);
	end
	this._ftwzPlayerCtrl = {};
	this.userPlayerObj = this.transform:FindChild("Content/User").gameObject
	this.userPlayerCtrl= this:bindPlayerCtrl(_nnPlayerName..EginUser.Instance.uid,this.userPlayerObj );
end

function this:Awake()
	log("------------------awake of GameFTWZ-------------")
	local footInfoPrb = ResManager:LoadAsset("gamesrftwz/FootInfo2Prb","FootInfo2Prb")
	GameObject.Instantiate(footInfoPrb)

	this:Init();

	----------绑定按钮事件--------
	--退出按钮
	local btn_back = this.transform:FindChild("Button_back").gameObject
	this.mono:AddClick(btn_back, this.OnClickBack);
	--开始按钮
	this.mono:AddClick(this.btnBegin, this.UserReady);
	--钱数按钮
	for i=0,this.chooseChipObj.transform.childCount-1  do
		local tempbutton = this.chooseChipObj.transform:GetChild(i).gameObject;
		this.mono:AddClick(tempbutton, this.UserChip,this);
	end
	--操作按钮
	local ButtonQi = this.btnsObj.transform:FindChild("ButtonQi").gameObject;
	this.mono:AddClick(ButtonQi, this.UserQi);
	
	this.mono:AddClick(this.ButtonAllIn, this.UserAllIn);
	local ButtonGen = this.btnsObj.transform:FindChild("ButtonGen").gameObject;
	this.mono:AddClick(ButtonGen, this.UserGen);
	--结算开始
	this.mono:AddClick(this.jsk_startBtn, this.JskContinueClick);
	--结算退出
	this.mono:AddClick(this.jsk_closeBtn, this.OnClickBack);
	this.mono:AddClick(this.jsk_exitBtn, this.OnClickBack);
	--确认退出
	local Button_yes = this.msgQuit.transform:FindChild("Button_yes").gameObject;
	this.mono:AddClick(Button_yes, this.UserQuit);
	
	--退赛按钮
	local exit_butt = this.bm_view.transform:FindChild("exit_butt").gameObject;
	this.mono:AddClick(exit_butt, this.OnClickBack);
	local jiang_listButt = this.bm_view.transform:FindChild("jiang_listButt").gameObject;
	this.mono:AddClick(jiang_listButt, this.showJiangList);
	--复活按钮
	local true_butt = this.fuhuo_view.transform:FindChild("true_butt").gameObject;
	this.mono:AddClick(true_butt, this.fuHuoTrue);
	local false_butt = this.fuhuo_view.transform:FindChild("false_butt").gameObject;
	this.mono:AddClick(false_butt, this.fuHuoFalse);
	--排名框列表
	this.mono:AddClick(this.paimingkuang_view, this.uListViewClick);
	
	------------逻辑代码------------
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 800;
		sceneRoot.manualWidth = 1422;
	end
	
	this.jiangzhuang_view:SetActive(false);
	this.bm_view:SetActive(false);
	this.fuhuo_view:SetActive(false);
	this.paimingkuang_view:SetActive(false);
	
	
	

	

	if PlatformGameDefine.game.GameID ~= "1097" then
		this.bm_view:SetActive(true);
		this.btnBegin:SetActive(false);
		this.jsk_closeBtn:SetActive(false);
		this.jsk_startBtn:SetActive(false);
		this.paimingkuang_view:SetActive(false);
		
		local info = GameObject.Find("Panel_info");
		if nil ~= info then
			info:SetActive(false);
		end
	 else 
		this.jsk_closeBtn:SetActive(true);
		this.jsk_startBtn:SetActive(true);
		local settingPrb = ResManager:LoadAsset("gamesrftwz/prefab","NewSettingPrb")
		local tSettingObj = GameObject.Instantiate(settingPrb)
		this.settBGBar = tSettingObj.transform:FindChild("GameSettingManager/Sprite_popup_container/Label_setting/Label_bgmusic/Slider").gameObject:GetComponent("UISlider")
		this.settEFBar = tSettingObj.transform:FindChild("GameSettingManager/Sprite_popup_container/Label_setting/Label_bgsound/Slider").gameObject:GetComponent("UISlider")
		this.mono:AddSlider(this.settBGBar, this.OnSoundBarChanged);
		this.mono:AddSlider(this.settEFBar, this.OnSoundBarChanged);
		this:initSound()
	end
end

function this:initSound()
	SettingInfo.Instance.LoadInfo()
	UISoundManager.Init(this.gameObject);
	for i=0,7 do
		UISoundManager.AddAudioSource("gamesrftwz/sounds","srwzmchat_"..i);
		UISoundManager.AddAudioSource("gamesrftwz/sounds","srwzwchat_"..i);
	end
	--添加背景音乐资源
	UISoundManager.AddAudioSource("gamesrftwz/sounds","srwzbgsound",true);
	UISoundManager.Start();
	UISoundManager.PlayBGSound("srwzbgsound");
end

function this:OnSoundBarChanged()
	UISoundManager.Instance.BGVolumeSet(this.settBGBar.value);
	UISoundManager.Instance._EFVolume = this.settEFBar.value;
end

function this:Start()
	if SettingInfo.Instance.autoNext then
		this.btnBegin:SetActive(false);
	end
	this.mono:StartGameSocket();
	coroutine.start(this.Update);
end

function this:OnDisable()
	this:clearLuaValue()
end
----解析JSON
function this:SocketReceiveMessage(Message)
	local Message = self;
	if  Message then
		--解析json字符串
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];
		if typeC ~= "seatmatch" then
			--error("receiveMessage: typc::"..typeC.."  tag::"..tag.." messageObj::"..PrintTable(messageObj)..os.date("%c"))
		end
		if typeC=="game" then
			if tag=="enter" then
				local info = GameObject.Find("Panel_info");
				if nil ~= info then
					info:SetActive(true);
				end
				_enterOutTime = messageObj["body"]["deskinfo"]["continue_timeout"]
				NNCount.Instance:UpdateHUD(_enterOutTime)
				this:nextJu();
				this:ProcessEnter(messageObj);
			elseif tag=="ready" then
				_readyOutTime = messageObj["body"][2]
				this:ProcessReady(messageObj);	
			elseif tag=="come" then
					if isOverState then
						_delayLeaveComeMsg["come"..os.time()] = messageObj
						--error("SocketReceiveMessage_delayLeaveComeMsg000000come.."..PrintTable(_delayLeaveComeMsg))
						return;
					else
						this:ProcessCome(messageObj);	
					end
 			elseif tag=="leave" then
					if isOverState then
						_delayLeaveComeMsg["leave"..os.time()] = messageObj
						--error("SocketReceiveMessage_delayLeaveComeMsg000000leave.."..PrintTable(_delayLeaveComeMsg))
						return;
					else
						this:ProcessLeave(messageObj)
					end
			elseif tag=="deskover" then
				this:ProcessDeskOver(messageObj);
			elseif tag=="notcontinue" then
				this:nextJu();
				NNCount.Instance:UpdateHUD(1);
				coroutine.start(this.ProcessNotcontinue,this);
			elseif tag=="emotion" then
				this:ProcessEmotion(messageObj);
			elseif tag=="hurry" then	
				this:ProcessHurry(messageObj);
			end
		elseif typeC=="gswz2" then
			if tag=="run" then
				_isPlaying = true;
 				this:nextJu();
				this:ProcessRun(messageObj);
			elseif tag=="run2" then
				_isPlaying = true;
				this:ProcessRun2(messageObj);
			elseif tag=="qp" then
				this:ProcessQP(messageObj);
			elseif tag=="gen" then
				this:ProcessGen(messageObj);
			elseif tag=="add" then
				this:ProcessAdd(messageObj);
			elseif tag=="guo" then
				this:ProcessGuo(messageObj);
			elseif tag=="h3" then
				this:ProcessH3(messageObj);
			elseif tag=="h4" then
				this:ProcessH4(messageObj);
			elseif tag=="h5" then
				this:ProcessH5(messageObj);
			elseif tag=="allin" then
				this:ProcessAllIn(messageObj);
			elseif tag=="over" then
				_isPlaying = false;
				coroutine.start(this.ProcessOver,this,messageObj);
			elseif tag=="kp" then
				this:ProcessKP(messageObj);
			end
		elseif typeC=="seatmatch" then
			if tag=="on_update" then
				this:ProcessUpdateAllIntomoney(messageObj);
			end
		elseif typeC=="gswzsm" then
			if tag=="apply" then
				this:ProcessApply(messageObj);
			elseif tag=="newcn" then
				this:ProcessNewcn(messageObj);
			elseif tag=="matchcancel" then
				this:ProcessReadystart(messageObj);
			elseif tag=="newranks" then
				this:ProcessNewranks(messageObj);
			elseif tag=="waitstart" then
				this:ProcessReadystart(messageObj);
			elseif tag=="readystart" then
				this:ProcessReadystart(messageObj);
			elseif tag=="roundover" then
				this:ProcessReadystart(messageObj);
			elseif tag=="waitingstep2" then
				this:ProcessWaitingstep2(messageObj);
			elseif tag=="groupover" then
				this:ProcessGroupover(messageObj);
			elseif tag=="sendaward" then
				this:ProcessSendaward(messageObj);
			elseif tag=="rebuy" then
				this:ProcessRebuy(messageObj);
			elseif tag=="wantrebuy" then
				this:ProcessWantrebuy(messageObj);
			elseif tag=="updatescore" then
				this:ProcessUpdatescore(messageObj);
			elseif tag=="unitgrowtip" then
				this:ProcessUnitgrowtip(messageObj);
			elseif tag=="cantrebuy" then
				this:ProcessCantrebuy(messageObj);
			elseif tag=="recheckin" then
				
				local info = GameObject.Find("Panel_info");
				if nil ~= info then
					info:SetActive(true);
				end
				local settingPrb = ResManager:LoadAsset("gamesrftwz/NewSettingPrb","NewSettingPrb")
				GameObject.Instantiate(settingPrb)
				this:ProcessRecheckin(messageObj);
			elseif tag=="gotofinalgroup" then
				this:ProcessGotofinalgroup(messageObj);
			elseif tag=="finalcoming" then
				this:ProcessReadystart(messageObj);
			elseif tag=="waitfinal" then
				this:ProcessWaitfinal(messageObj);
			end
		end
	else
		log("---------------Message=nil")
	end

end

----------消息处理------------
function this:ProcessApply(messageObj)
	this.jiangzhuang_view:SetActive(false);
	this.fuhuo_view:SetActive(false);
	this.paimingkuang_view:SetActive(false);
	this.bm_view:SetActive(true);

	
	local info = GameObject.Find("Panel_info");
	if nil ~= info then
		info:SetActive(false);
	end
	
	
	local body = messageObj["body"];
	local awards = body["awards"];

	_num = body["restseconds"];
	_currTime = Time.time;
	for key,awardsOne in ipairs(awards) do
		if key<8 then
			local mingTxt = this.bm_JiangList.transform:FindChild ("name"..(key-1)):GetComponent("UILabel");
			local jiangTxt = this.bm_JiangList.transform:FindChild ("jmoney"..(key-1)):GetComponent("UILabel");
			mingTxt.text = tostring(awardsOne[1]) ;
			jiangTxt.text = tostring(awardsOne[2]);
		end
	end

	local fei = this.bm_fei:GetComponent("UILabel");
	fei.text = "一张报名卡";
	local startTime = this.bm_stime:GetComponent("UILabel");
	startTime.text =tostring(body["matchtime"]);
	local pnumm = this.bm_pnum:GetComponent("UILabel");
	pnumm.text = tostring(body["cn"]);
	local xian = this.bm_xian:GetComponent("UILabel");
	xian.text = tostring(body["mincn"].."-"..body["maxcn"]);
	local daojishi = this.bm_time:GetComponent("UILabel");
	daojishi.text =  EginTools.miao2TimeStr(_num,false,false);
end

function this:ProcessNewcn(messageObj)
	local 	body = messageObj["body"];
	local pnumm = this.bm_pnum:GetComponent("UILabel");
	pnumm.text = tostring(body["playern"]);
end

function this:ProcessReadystart(messageObj)
	this.bm_view:SetActive(false);

	local body = tonumber(messageObj["body"]);

	if body~=nil then
		readyST = body;
		_currTime = Time.time;
		EginProgressHUD.Instance:ShowPromptHUD ("还有"..body.."秒  半决赛开始");
	else
		local body2 = tonumber(messageObj["body"]["round"]);
		if body2~=nil then
			readyST = body2;
			_currTime = Time.time;
			EginProgressHUD.Instance:ShowPromptHUD ("还有"..body2.."秒  半决赛开始");
		else
			readyST = 0;
			_currTime = Time.time;
			EginProgressHUD.Instance:ShowPromptHUD ("还有 0 秒  半决赛开始");
		end
	end
	
end

function this:ProcessNewranks( messageObj) 
	this.bm_view:SetActive(false);
	this.paimingkuang_view:SetActive(true);

	local body = messageObj["body"];
	 
	local ranks = body["ranks"];
	local top10 = body["top10"];
	for  k=1,10 do
		local nick = this.pmk_nickArr[k];
		local score = this.pmk_scoreArr[k];
		local nickLb = nick:GetComponent("UILabel");
		local scoreLb = score:GetComponent("UILabel");
		nickLb.text = "";
		scoreLb.text = "";
	end

	for h=1 ,#(ranks) do
		local ranksOne = ranks[h];
		if tostring(ranksOne[1])==EginUser.Instance.username then
			local myScore = this.pmk_myScoreTxt:GetComponent("UILabel");
			myScore.text = tostring(ranksOne[3]);

			local juLun = this.pmk_SATxt:GetComponent("UILabel");
			juLun.text = tostring(ranksOne[2].."/"..body["cn"]); 
		end
	end
	
	local jinJu = this.pmk_jinJuTxt:GetComponent("UILabel");
	jinJu.text = tostring(body["promotion_jushu"]);

	local pnumm = this.bm_pnum:GetComponent("UILabel");
	pnumm.text = tostring(body["cn"]);

	for j=1 ,#(top10) do
		local top10One = top10 [j];
		if j<11 then
			local nick = this.pmk_nickArr[j];
			local score = this.pmk_scoreArr[j];
			local nickLb = nick:GetComponent("UILabel");
			local scoreLb = score:GetComponent("UILabel");
			
			nickLb.text = tostring(top10One[3]);
			scoreLb.text = tostring(top10One[1]);
		end

		if tostring(top10One[3])==EginUser.Instance.username then
			local myScore = this.pmk_myScoreTxt:GetComponent("UILabel");
			myScore.text = tostring(top10One[1]);
		end
	end

	local julun = this.pmk_juLunTxt:GetComponent("UILabel");
	julun.text = gameInnings.."/"..gameRound;

end

function this:ProcessMatchcancel( messageObj)
	EginProgressHUD.Instance:ShowPromptHUD ("游戏未达到比赛人数,比赛取消");
end

function this:ProcessWaitingstep2(messageObj)
	EginProgressHUD.Instance:ShowPromptHUD ("恭喜你进入决赛!",3);
end

function this:ProcessGroupover(messageObj)
	EginProgressHUD.Instance:ShowPromptHUD ("本组结束等待其他桌结束,请勿关闭游戏!",3);
end

function this:ProcessSendaward(messageObj)
	this.fuhuo_view:SetActive(false);

	local body = messageObj["body"];
	if  tostring(body["reason"])=="lowjushu" then
		EginProgressHUD.Instance:ShowPromptHUD ("本组结束等待其他桌结束,请勿关闭游戏!",10);
	else
		this.jiangzhuang_view:SetActive(true);
		this.jsk:SetActive(false);
		local uname = this.jz_name:GetComponent("UILabel");
		uname.text = EginUser.Instance.username;
		 
		local dateTime = this.jz_time:GetComponent("UILabel");
		dateTime.text =tostring(body["datetime"]) ;

		local gameName = this.jz_gameName:GetComponent("UILabel");
		gameName.text = "欢腾五张";

		local rank = this.jz_jNum:GetComponent("UILabel");
		rank.text =  tostring(body["rank"]);
		 
		local jMoney = this.jz_info:GetComponent("UILabel");
		jMoney.text = tostring(body["award"]);

	end
end

function this:ProcessRebuy(messageObj)
	EginProgressHUD.Instance:ShowPromptHUD ("复活成功等待下一局比赛!");
	this.fuhuo_view:SetActive(false);
end

function this:ProcessWantrebuy(messageObj)
	local body = messageObj["body"];
	this.fuhuo_view:SetActive(true);
	local fh_mo = this.fh_tJian:GetComponent("UILabel");
	fh_mo.text =  tostring(body ["rebuymoney"]);
	
	NNCount.Instance:UpdateHUD(tonumber(body ["timeout"]));
end

function this:ProcessUpdatescore(messageObj)
	local body = messageObj["body"];
	if body["top10"] ~= nil then
		local top10 = body["top10"];
		for j,top10One in ipairs(top10) do
			if j<11 then
				local nick = this.pmk_nickArr[j];
				local score = this.pmk_scoreArr[j];
				local nickLb = nick:GetComponent("UILabel");
				local scoreLb = score:GetComponent("UILabel");
				
				nickLb.text =  tostring(top10One[3]);
				scoreLb.text =  tostring(top10One[1]);
			end

			if  tostring(top10One[3])==EginUser.Instance.username then
				local myScore = this.pmk_myScoreTxt:GetComponent("UILabel");
				myScore.text =  tostring(top10One[1]);
			end
		end
	end

	local julun = this.pmk_juLunTxt:GetComponent("UILabel");
	julun.text = gameInnings.."/"..gameRound;
end

function this:ProcessUnitgrowtip(messageObj)
	EginProgressHUD.Instance:ShowPromptHUD ("十秒钟后基数翻倍,比赛将更加激烈!");
end

function this:ProcessCantrebuy(messageObj)
	EginProgressHUD.Instance:ShowPromptHUD ("复活已截止!");
end


function this:ProcessRecheckin(messageObj)
	this:nextJu();
	this.jiangzhuang_view:SetActive(false);
	this.bm_view:SetActive(false);
	this.fuhuo_view:SetActive(false);
	this.paimingkuang_view:SetActive(true);

	local body = messageObj["body"];

	gameRound= tonumber(body["round"])
	gameInnings = 0;

	local julun = this.pmk_juLunTxt:GetComponent("UILabel");
	julun.text = gameInnings.."/"..gameRound;

	if body["top10"] ~= nil then
		local top10 = body["top10"];
		for j ,top10One in ipairs(top10) do
			if j<11 then
				local nick = this.pmk_nickArr[j];
				local score = this.pmk_scoreArr[j];
				local nickLb = nick:GetComponent("UILabel");
				local scoreLb = score:GetComponent("UILabel");
				
				nickLb.text =  tostring(top10One[3]);
				scoreLb.text =  tostring(top10One[1]);
			end

			if  tostring(top10One[3])==EginUser.Instance.username then
				local myScore = this.pmk_myScoreTxt:GetComponent("UILabel");
				myScore.text =  tostring(top10One[1]);
			end
		end
	end
end


function this:ProcessGotofinalgroup(messageObj)
end


function this:ProcessFinalcoming(messageObj)
	this.bm_view:SetActive(false);

	local body = tonumber(messageObj["body"])
	readyST = body;
	_currTime = Time.time;
	EginProgressHUD.Instance:ShowPromptHUD ("还有"..body.."秒  半决赛开始");
end


function this:ProcessWaitfinal(messageObj)
	EginProgressHUD.Instance:ShowPromptHUD ("恭喜你进入半决赛!");
end


function this:ProcessRoundover(messageObj)
	this.bm_view:SetActive(false);

	local body = messageObj["body"];
	EginProgressHUD.Instance:ShowPromptHUD ("恭喜你,你已成功晋级下一轮比赛!",3);
	if body["top10"] ~= nil then
		local top10 = body["top10"];
		for j,top10One in ipairs(top10) do

			if j<11 then
				local nick = this.pmk_nickArr[j];
				local score = this.pmk_scoreArr[j];
				local nickLb = nick:GetComponent("UILabel");
				local scoreLb = score:GetComponent("UILabel");
				
				nickLb.text =  tostring(top10One[3]);
				scoreLb.text =  tostring(top10One[1]);
			end

			if  tostring(top10One[3])==EginUser.Instance.username then
				local myScore = this.pmk_myScoreTxt:GetComponent("UILabel");
				myScore.text =  tostring(top10One[1]);
			end

		end
	end
end


function this:ProcessWaitstart( messageObj) 
	this.fuhuo_view:SetActive(false);
	this.bm_view:SetActive(false);
	EginProgressHUD.Instance:ShowPromptHUD ("请等待.....");

	local body = messageObj["body"];
	local top10 = body["top10"];
	local pnumm = this.bm_pnum:GetComponent("UILabel");
	pnumm.text =  tostring(body["cn"]);

	local ranks = body["ranks"];
	for key,ranksOne in ipairs(ranks) do
		if tostring(ranksOne[1])==EginUser.Instance.username then
			local myScore = this.pmk_myScoreTxt:GetComponent("UILabel");
			myScore.text =  tostring(ranksOne[3]);
			local juLun = this.pmk_SATxt:GetComponent("UILabel");
			juLun.text =  tostring(ranksOne[2].."/".. body["cn"]);
		end
	end

	for k=1, 10 do
		local nick = this.pmk_nickArr[k];
		local score = this.pmk_scoreArr[k];
		local nickLb = nick:GetComponent("UILabel");
		local scoreLb = score:GetComponent("UILabel");
		nickLb.text = "";
		scoreLb.text = "";
	end
	for key,top10One in ipairs(top10) do
		if  tostring(top10One[3])==EginUser.Instance.username then
			local myScore = this.pmk_myScoreTxt:GetComponent("UILabel");
			myScore.text =  tostring(top10One[1]);
		end
		if key<11 then
			local nick = this.pmk_nickArr[key];
			local score = this.pmk_scoreArr[key];
			local nickLb = nick:GetComponent("UILabel");
			local scoreLb = score:GetComponent("UILabel");
			
			nickLb.text =  tostring(top10One[3]);
			scoreLb.text =  tostring(top10One[1]);
		end
	end
end


function this:ProcessRun(messageObj) 
	local selfNameLabel = this.jsk.transform:FindChild("nickName0"):GetComponent("UILabel");
	selfNameLabel.text = EginUser.Instance.nickname;
	
	local otherNameLabel = this.jsk.transform:FindChild ("nickName1"):GetComponent("UILabel");
	otherNameLabel.text = otherUname; 

	inHandPaiNum = 2;

	local body = messageObj["body"];
	local chip = body["chip"];
	local second_cards = body["c2"];

	ju_time =  tonumber(body["time"])
 
	local c1 =  tonumber(body["c1"])
	--error("Processrun chip:"..PrintTable(chip))
	this.topScore2:SetActive(false);
	this.leftScore2:SetActive(false);
	this.rightScore2:SetActive(false);
	this.bottomScore2:SetActive(false);

	for i=1, 4 do
		local secds = second_cards[i];
		if secds ~= nil then
			if  tostring(secds[1]) == EginUser.Instance.uid then
				userPlayerCtrl:SetSelfH1_2(c1,tonumber(secds[2]));
				this.bottomScore2:SetActive(true)
			else
				local tNoSelfCtrl = this:getPlayerCtrl(_nnPlayerName..tostring(secds[1]))
				if tNoSelfCtrl~= nil then
					tNoSelfCtrl:SetOtherH1_2 (tonumber(secds[2]))
					local tScaleGameObject  = this[this:getScore(tNoSelfCtrl,2).."2"]
					tScaleGameObject:SetActive(true)
				end	
			end
		end
	end

	this.chooseChipObj0:SetActive(false);
	this:checkChooseChipMax(false)

	local genButt0 = this.btnsObj.transform:FindChild ("ButtonGen0").gameObject;
	genButt0:SetActive(false);

	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	allInButt0:SetActive(false);
	this.ButtonAllIn:SetActive(true)

	diChip = tonumber(chip[3])
	maxZhu = tonumber(chip[2])

	--otherBetNum = tonumber(chip[1])
	selfBetNum = tonumber(chip[1])


	userPlayerCtrl:SetStartChip(this.topScore2.gameObject, selfBetNum);
	userPlayerCtrl:SetStartChip(this.leftScore2.gameObject, selfBetNum);
	userPlayerCtrl:SetStartChip(this.rightScore2.gameObject, selfBetNum);
	userPlayerCtrl:SetStartChip(this.bottomScore2.gameObject, selfBetNum);
	this.allScore:SetActive(true);

	--最大注额
 	userPlayerCtrl:SetStartChip(this.chipInfoMaxChip,"最大注额:"..maxZhu)
	userPlayerCtrl:SetStartChip(this.chipInfoCurChip,"每局底注:"..chip[1])
	this:setAllChip(selfBetNum*4)
	--userPlayerCtrl:SetStartChip (this.allScore.gameObject, selfBetNum*4);
	if  tostring(body ["win"]) == EginUser.Instance.uid then
		this.chooseChipObj0:SetActive(false);
		this:checkChooseChipMax(false)
		this.chooseChipObj:SetActive(false);
		this.btnsObj:SetActive(false);
		allInButt0:SetActive(false);
		coroutine.start(this.AfterDoing,self,2,function() 
			this.btnsObj:SetActive(true)  
			this.chooseChipObj:SetActive(true);
			allInButt0:SetActive(true);
			
		end);
		
		is_guo = true;
		this:setNNCountPos(userPlayerCtrl)
		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for i=0, 2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn,(diChip*this.diChipBei[i+1]));
			btn.name =  tostring((diChip*this.diChipBei[i+1]));
		end
		--this.ButtonAllIn:SetActive(false)
	else
		this:yingKongButts();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(body ["win"])))
		 
	end
	NNCount.Instance:UpdateHUD(ju_time);
end

function delayShowSelfBtn()

end
function this:AfterDoing(offset, run)
    coroutine.wait(offset);
	if self.gameObject==nil then
		return;
	end
	run();
end
function this:setAllChip(pValue)
	userPlayerCtrl:SetStartChip (this.allScore.gameObject, pValue)
	userPlayerCtrl:SetStartChip (this.allScore1.gameObject, "当前总注:"..pValue)
end

function this:nextJu()
	this.topScore1:SetActive(false);
	this.topScore2:SetActive(false);
	this.bottomScore1:SetActive(false);
	this.bottomScore2:SetActive(false);
	this.leftScore1:SetActive(false);
	this.leftScore2:SetActive(false);
	this.rightScore1:SetActive(false);
	this.rightScore2:SetActive(false);
	this.allScore:SetActive(false);

	this.bm_view:SetActive(false);
	this.jsk:SetActive(false);
	this:yingKongButts ();

	if userPlayerCtrl then
		userPlayerCtrl:SetReady(false);
		userPlayerCtrl:clearPais ();
		userPlayerCtrl:SetDeal (false, nil);
		userPlayerCtrl:SetScore(-1);
		userPlayerCtrl:tiShi(nil);
	end
	for tKey, tCtrl in pairs(this._ftwzPlayerCtrl) do
		if  tKey ~= _nnPlayerName..EginUser.Instance.uid then
			tCtrl:tiShi("");
			tCtrl:SetReady(false);
			tCtrl:clearPais ();
			tCtrl:SetDeal (false, nil);
			tCtrl:SetScore(-1);
		end
    end
end


function this:yingKongButts()
	this.chooseChipObj:SetActive(false);
	this.btnsObj:SetActive(false);
	this.chooseChipObj0:SetActive(false);
	this:checkChooseChipMax(false)
	local genButt0 = this.btnsObj.transform:FindChild ("ButtonGen0").gameObject;
	genButt0:SetActive(false);

	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	allInButt0:SetActive(false);
	this.ButtonAllIn:SetActive(true)
end


function this:getScore(pPlayerCtrl,pNum)
	local position_span = pPlayerCtrl['deskPosition'] - _userIndex
    if(position_span == 0) then
		if pNum==1 then
			this.bottomScore1.transform.localPosition = Vector3.New(77.3,-37,0)
		end
		return "bottomScore"
    elseif (position_span == 1 or position_span == -3) then
		if pNum==1 then
			this.rightScore1.transform.localPosition = Vector3.New(251,34,0)
		end
        return "rightScore"
    elseif (position_span == 2 or position_span == -2) then
		if pNum==1 then
			this.topScore1.transform.localPosition = Vector3.New(77,117,0)
		end
        return "topScore"
    elseif(position_span == 3 or position_span == -1) then
		if pNum==1 then
			this.leftScore1.transform.localPosition = Vector3.New(-95,34,0)
		end
        return "leftScore"
    end
end


function this:setNNCountPos(pPlayerCtrl)
	if pPlayerCtrl ~= nil then
		if pPlayerCtrl == userPlayerCtrl then
			this.nnCountAnchor.relativeOffset = Vector2.New(0,-0.29)
		else
			local position_span = pPlayerCtrl['deskPosition'] - _userIndex
			if(position_span == 0) then
				this.nnCountAnchor.relativeOffset = Vector2.New(0,-0.29)
			elseif (position_span == 1 or position_span == -3) then
				this.nnCountAnchor.relativeOffset = Vector2.New(0.76,0.67)
			elseif (position_span == 2 or position_span == -2) then
				this.nnCountAnchor.relativeOffset = Vector2.New(0,0.67)
			elseif(position_span == 3 or position_span == -1) then
				this.nnCountAnchor.relativeOffset = Vector2.New(-0.76,0.67)
			end
		end
		this:SetIsEnableNNCount(true)
	else
		this:SetIsEnableNNCount(false)
	end
end

function this:SetIsEnableNNCount(pEnable)
	NNCount.Instance.gameObject:SetActive(pEnable)
	this.nnCountAnchor.enabled = pEnable
end

function this:ProcessRun2(messageObj)
	this:nextJu ();

	this.btnBegin:SetActive(false);

	local selfNameLabel = this.jsk.transform:FindChild ("nickName0"):GetComponent("UILabel");
	selfNameLabel.text = EginUser.Instance.nickname;

	local otherNameLabel = this.jsk.transform:FindChild ("nickName1"):GetComponent("UILabel");
	otherNameLabel.text = otherUname;

	local body = messageObj["body"];
	local chip = body["chip"];
	local chip2 = body["chip2"];
	local step = body["step"];
	local cs = body["cs"];
	ju_time =  tonumber(body["time"])

	inHandPaiNum = tonumber(step[4])---手机几张牌
	diChip =  tonumber(chip[3])
	maxZhu = tonumber(chip[2])
	selfBetNum = tonumber(chip[1])
	local c1 = tonumber(body["c1"])
	this.topScore2:SetActive(false);
	this.leftScore2:SetActive(false);
	this.rightScore2:SetActive(false);
	this.bottomScore2:SetActive(false);
	for i=1,4 do
		local scOne = cs[i];
		if scOne ~= nil then
			local pais = scOne[5];
			
			if  tostring(scOne[1]) == EginUser.Instance.uid then
				selfBetNum = tonumber(scOne[3])
				this.bottomScore2:SetActive(true)
				userPlayerCtrl:SetStartChip(this.bottomScore2, tonumber(scOne[3]));
				userPlayerCtrl:SetSelfH1_2 (c1,tonumber(pais[1]));
				for  i2=2, #(pais) do
					userPlayerCtrl:SetSelfH3_4_5(2+i2-1,tonumber(pais[i2]));
				end
				if tonumber(chip2[3]) >0 then
					this.bottomScore1:SetActive(true);
					userPlayerCtrl:SetStartChipSelf(this.bottomScore1.gameObject, tonumber(chip2[1]));
				end

			else
				local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(scOne[1]));
				local tScore2 = this:getScore(player1,2).."2"
				--otherBetNum = otherBetNum + tonumber(scOne[3])
				this[tScore2]:SetActive(true);
				userPlayerCtrl:SetStartChip(this[tScore2].gameObject, tonumber(scOne[3]));
				player1:SetOtherH1_2 (tonumber(pais[1]));
				for  i0=2, #(pais) do
					player1:SetOtherH3_4_5(2+i0-1,tonumber(pais[i0]));
				end
				if tonumber(chip2[3])>0 then
					local tScore1 = this:getScore(player1,1).."1"
					this[tScore1]:SetActive(true)
					userPlayerCtrl:SetStartChipOther(this[tScore1].gameObject,tonumber(chip2[1]));
				end
			end
		end	
	end

	if tostring(step[1]) == EginUser.Instance.uid then
		local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
		if inHandPaiNum >= 3 then
			allInButt0:SetActive(false);
			this.ButtonAllIn:SetActive(true)
		else
			allInButt0:SetActive(true);
			--this.ButtonAllIn:SetActive(false)
		end
		is_guo = true;
		this.chooseChipObj:SetActive(false);
		this.btnsObj:SetActive(false);
		coroutine.start(this.AfterDoing,self,2,function() 
			this.btnsObj:SetActive(true)  
			this.chooseChipObj:SetActive(true);
			NNCount.Instance:UpdateHUD(tonumber(step[5]));
		end);
		this.chooseChipObj0:SetActive(false);
		this:checkChooseChipMax(false)
		this:setNNCountPos(userPlayerCtrl)
		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for  i=0,2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn,tonumber(diChip*this.diChipBei[i+1]));
			btn.name =  tostring((diChip*this.diChipBei[i+1]));
		end
	else
		this:yingKongButts ();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(step[0])))
		NNCount.Instance:UpdateHUD(tonumber(step[5]));
	end
	--this.bottomScore2:SetActive(true);
	userPlayerCtrl:SetStartChip(this.bottomScore2.gameObject, selfBetNum);
	this.allScore:SetActive(true)
	--最大注额
 	userPlayerCtrl:SetStartChip(this.chipInfoMaxChip,"最大注额:"..maxZhu)
	userPlayerCtrl:SetStartChip(this.chipInfoCurChip,"每局底注:"..chip[1])
	this:setAllChip(selfBetNum*4)
	--userPlayerCtrl:SetStartChip (this.allScore.gameObject, selfBetNum*4)
end


--弃牌
function this:ProcessQP(messageObj)
	this:yingKongButts ();
	local body = messageObj["body"];
	if  tostring(body [1]) == EginUser.Instance.uid then
		isSelfQP = true;
		--userPlayerCtrl:SetCardTypeYing();
		userPlayerCtrl:QiPai(-1)
	else
		local tPlayer = this:getPlayerCtrl(_nnPlayerName..tostring(body [1]))
		tPlayer:SetCardTypeOther(-1,-1)
	end

	if  tostring(body [2]) == EginUser.Instance.uid then
 		this.chooseChipObj:SetActive(true);
		this.btnsObj:SetActive(true);
		this:setNNCountPos(userPlayerCtrl)
		if tonumber(body [3])  ~= 0 then
			--this.chooseChipObj:SetActive(false);
			--this.chooseChipObj0:SetActive(true);
			this:checkChooseChipMax(true)
		else
			this:checkChooseChipMax(false)
			this.chooseChipObj0:SetActive(false);
		end

		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for i=0, 2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn, (diChip*this.diChipBei[i+1]));
			btn.name = tostring(diChip*this.diChipBei[i+1]);
		end
	else
		this:yingKongButts ();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(body [2])))
	end
	if tostring(body[2]) ~= "0" then
		NNCount.Instance:UpdateHUD(ju_time)
	else
		this:SetIsEnableNNCount(false)
	end
end


---body：[uid,money,cutt_chip_money,cutt_totle_money,next_one_id,nextchipflag]
function this:ProcessAdd(messageObj)
	this.jsk:SetActive(false);
	EginTools.PlayEffect (this.soundXiazhu);

	local body = messageObj["body"];

	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	if inHandPaiNum >= 3 then
		allInButt0:SetActive(false);
		this.ButtonAllIn:SetActive(true)
	else
		--this.ButtonAllIn:SetActive(false)
		allInButt0:SetActive(true);
	end

	if  tostring(body [5]) == EginUser.Instance.uid then
		is_guo = false;
		this.chooseChipObj:SetActive(true);
		this.btnsObj:SetActive(true);
		this:setNNCountPos(userPlayerCtrl)
		if  tonumber(body [6]) ~= 0 then
			--this.chooseChipObj:SetActive(false);
			--this.chooseChipObj0:SetActive(true);
			this:checkChooseChipMax(true)
		else
			this:checkChooseChipMax(false)
			this.chooseChipObj0:SetActive(false);
		end
	 

		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for i=0, 2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn,tonumber(diChip*this.diChipBei[i+1]));
			btn.name = tostring(diChip*this.diChipBei[i+1]);
		end

	else
		this:yingKongButts();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(body [5])))
	end
	

	local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(body [1]));
	if  tostring(body [1]) == EginUser.Instance.uid then
		userPlayerCtrl:tiShi("jia");
		this.bottomScore1:SetActive(true);
		--userPlayerCtrl:SetStartChipSelf (this.bottomScore1.gameObject, tonumber(body [3])-selfBetNum);
		userPlayerCtrl:SetStartChipSelf (this.bottomScore1.gameObject,tonumber(body[2]));
		selfBetNum = tonumber(body [3]);
	else
		player1:tiShi("jia");
		local tScore1 = this:getScore(player1,1).."1"
		this[tScore1]:SetActive(true)
		--userPlayerCtrl:SetStartChipOther (this[tScore1].gameObject, tonumber(body [3]) - otherBetNum);
		userPlayerCtrl:SetStartChipOther(this[tScore1].gameObject, tonumber(body[2]));
		--otherBetNum =  tonumber(body [3])
	end

	if tonumber(body[3]) == maxZhu then---全压
		local genButt0 = this.btnsObj.transform:FindChild("ButtonGen0").gameObject;
		genButt0:SetActive(true);

		if  tostring(body [1]) == EginUser.Instance.uid then
			userPlayerCtrl:tiShi("all");
		else
			player1:tiShi("all");
		end
		this:checkChooseChipMax(tonumber(body[3]) == maxZhu)
	end
	
	this.allScore:SetActive(true);
	--userPlayerCtrl:SetStartChip (this.allScore.gameObject, tonumber(body [4]));
	this:setAllChip( tonumber(body [4]))
	--userPlayerCtrl:SetStartChip(this.chipInfoCurChip,"每局底注:"..tonumber(body[2]))
	if tostring(body [5]) ~= "0" then
		NNCount.Instance:UpdateHUD(ju_time)
	else
		this:SetIsEnableNNCount(false)
	end
end

function this:checkChooseChipMax(pState)
	for i=0, 2 do
		local tChooseBtnDisable = this.chooseChipObj.transform:FindChild("SpriteChip"..tostring(i)).gameObject
		local tUIEventListner = tChooseBtnDisable:GetComponent("UIEventListener")
		if tUIEventListner~=nil then
			destroy(tUIEventListner)
		end
		tChooseBtnDisable:SetActive(pState)
		local tChooseBtnDesalbeLabel = tChooseBtnDisable.transform:FindChild("numLabel"):GetComponent("UILabel")
		tChooseBtnDesalbeLabel.text = tostring(diChip*this.diChipBei[i+1])
	end	
end

---body：[uid,money,cutt_chip_money,cutt_totle_money,next_one_id,nextchipflag]
function this:ProcessGen(messageObj)
	local body = messageObj["body"];
	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	if inHandPaiNum >= 3 then
		this.ButtonAllIn:SetActive(true)
		allInButt0:SetActive(false);
	else
		--this.ButtonAllIn:SetActive(false)
		allInButt0:SetActive(true);
	end

	if  tostring(body[5]) == EginUser.Instance.uid then
		is_guo = false;
		this.chooseChipObj:SetActive(true);
		this.btnsObj:SetActive(true);
		this:setNNCountPos(userPlayerCtrl)
		if tonumber(body [6]) ~= 0 then
			--this.chooseChipObj:SetActive(false);
			--?this.chooseChipObj0:SetActive(true);
			this:checkChooseChipMax(true)
		else
			this:checkChooseChipMax(false)
			this.chooseChipObj0:SetActive(false);
		end

		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for  i=0, 2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn, tonumber(diChip*this.diChipBei[i+1]));
			btn.name = tostring(diChip*this.diChipBei[i+1]);
		end
	else
		this:yingKongButts ();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(body[5])))
	end

	if  tostring(body [1]) == EginUser.Instance.uid then
		this.bottomScore1:SetActive(true);
		local fen0 = tonumber(body [3]) - selfBetNum;
		-- if fen0>0 then
		-- 	userPlayerCtrl:tiShi("jia");
		-- 	EginTools.PlayEffect (this.soundXiazhu);
		-- else
		-- 	userPlayerCtrl:tiShi("gen");
		-- end
		userPlayerCtrl:tiShi("gen");
		userPlayerCtrl:SetStartChipSelf (this.bottomScore1.gameObject,tonumber(body [2]) );
		selfBetNum =  tonumber(body [3]);
	else
		--local fen1 = tonumber(body [3]) - otherBetNum;
		local fen1 = tonumber(body [2]) ;
		local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(body [1]));
		local tScore1 = this:getScore(player1,1).."1"
		this[tScore1]:SetActive(true);
		-- if fen1>0 then
		-- 	player1:tiShi("jia");
		-- 	EginTools.PlayEffect (this.soundXiazhu);
		-- else
		-- 	player1:tiShi("gen");
		-- end
		player1:tiShi("gen");
		userPlayerCtrl:SetStartChipOther (this[tScore1].gameObject, tonumber(body [2]) );
		--otherBetNum = tonumber(body [3]);
	end

	this.allScore:SetActive(true);
	--userPlayerCtrl:SetStartChip (this.allScore.gameObject, tonumber(body [4]));
	this:setAllChip( tonumber(body [4]))
	--userPlayerCtrl:SetStartChip(this.chipInfoCurChip,"每局底注:"..tonumber(body[2]))
	if tostring(body [5]) ~= "0" then
		NNCount.Instance:UpdateHUD(ju_time)
	else
		this:SetIsEnableNNCount(false)
	end
end


------body：[uid,next_one_id,nextchipflag]
function this:ProcessGuo(messageObj)
	local body = messageObj["body"];

	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	if inHandPaiNum >= 3 then
		this.ButtonAllIn:SetActive(true)
		allInButt0:SetActive(false);
	else
		--this.ButtonAllIn:SetActive(false)
		allInButt0:SetActive(true);
	end

	if  tostring(body [2]) == EginUser.Instance.uid then

		is_guo = true;
		this.chooseChipObj:SetActive(true);
		this.btnsObj:SetActive(true);
		this:setNNCountPos(userPlayerCtrl)
		if tonumber(body [3])  ~= 0 then
			--this.chooseChipObj:SetActive(false);
			--?this.chooseChipObj0:SetActive(true);
			this:checkChooseChipMax(true)
		else
			this:checkChooseChipMax(false)
			this.chooseChipObj0:SetActive(false);
		end

		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for i=0, 2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn, (diChip*this.diChipBei[i+1]));
			btn.name = tostring(diChip*this.diChipBei[i+1]);
		end
	else
		this:yingKongButts ();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(body [2])))
	end
	

	local tGuoID = tostring(body [1])
	if  tGuoID == EginUser.Instance.uid then
		userPlayerCtrl:tiShi("guo");
	else
		local player1 = this:getPlayerCtrl(_nnPlayerName..tGuoID);
		player1:tiShi("guo");
	end

	if tostring(body [2]) ~= "0" then
		NNCount.Instance:UpdateHUD(ju_time)
	else
		this:SetIsEnableNNCount(false)
	end
end


function this:otherTishi(pStr)
	for tKey, tCtrl in pairs(this._ftwzPlayerCtrl) do
		if tCtrl ~= nil then
			if  tKey ~= _nnPlayerName..EginUser.Instance.uid then
				tCtrl:tiShi(pStr);
			end
		end
    end
end


function this:placeScore()
	userPlayerCtrl:SetStartChipOther2 (this.topScore2.gameObject,selfBetNum,this.topScore1.gameObject);
	userPlayerCtrl:SetStartChipSelf2 (this.bottomScore2.gameObject,selfBetNum,this.bottomScore1.gameObject);

	userPlayerCtrl:SetStartChipOther2 (this.leftScore2.gameObject,selfBetNum,this.leftScore1.gameObject);
	userPlayerCtrl:SetStartChipOther2 (this.rightScore2.gameObject,selfBetNum,this.rightScore1.gameObject);
end


---win 谁先出牌
function this:ProcessH3(messageObj)
	this.jsk:SetActive(false);
	inHandPaiNum = 3;

	this:otherTishi("")
	userPlayerCtrl:tiShi("");

	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	allInButt0:SetActive(false);
	this.ButtonAllIn:SetActive(true)
	this:placeScore()

	local body = messageObj["body"];
	local cs   = body["cs"];
	local win  = tostring(body ["win"]);
	for i=1,4 do
		local csb = cs[i];
		if csb ~= nil then
			if  tostring(csb[1]) == EginUser.Instance.uid then
				userPlayerCtrl:SetSelfH3_4_5(3,tonumber(csb[2]),i*0.5);
			else
				local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(csb[1]));
				player1:SetOtherH3_4_5(3, tonumber(csb[2]),i*0.5);
			end
		end
	end

	if win == EginUser.Instance.uid then
		is_guo = true;
		this.chooseChipObj:SetActive(true);
		this.btnsObj:SetActive(true);

		this.chooseChipObj0:SetActive(false);
		this:checkChooseChipMax(false)
		this:setNNCountPos(userPlayerCtrl)
		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for i=0, 2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn,(diChip*this.diChipBei[i+1]));
			btn.name = tostring(diChip*this.diChipBei[i+1]);
		end
	else
		is_guo = false;
		this:yingKongButts ();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(win)))
	end

	
	NNCount.Instance:UpdateHUD(ju_time);
end


function this:ProcessH4(messageObj)
	this.jsk:SetActive(false);
	inHandPaiNum = 4;
	userPlayerCtrl:tiShi("");
	this:otherTishi("")
	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	allInButt0:SetActive(false);
	this.ButtonAllIn:SetActive(true)

	this:placeScore()

	local body = messageObj["body"];
	local cs   = body["cs"];
	local win  =  tostring(body ["win"]);
	for  i=1,4 do
		local csb = cs[i];
		if csb ~= nil then
			if  tostring(csb[1]) == EginUser.Instance.uid then
				userPlayerCtrl:SetSelfH3_4_5(4,tonumber(csb[2]),i*0.5);
			else
				local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(csb[1]));
				player1:SetOtherH3_4_5 (4,tonumber(csb[2]),i*0.5);
			end
		end
	end

	if win == EginUser.Instance.uid then
		is_guo = true;
		this.chooseChipObj:SetActive(true);
		this.btnsObj:SetActive(true);
		this.chooseChipObj0:SetActive(false);
		this:checkChooseChipMax(false)
		this:setNNCountPos(userPlayerCtrl)
		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for i=0, 2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn, (diChip*this.diChipBei[i+1]));
			btn.name = tostring(diChip*this.diChipBei[i+1]);
		end

	else
		is_guo = false;
		this:yingKongButts ();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(win)))
	end
	NNCount.Instance:UpdateHUD(ju_time);
end


function this:ProcessH5(messageObj)
	this.jsk:SetActive(false);
	inHandPaiNum = 5;

	userPlayerCtrl:tiShi("");
	this:otherTishi("")
	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	allInButt0:SetActive(false);
	this.ButtonAllIn:SetActive(true)
	this:placeScore()

	local body = messageObj["body"];
	local cs = body["cs"];
	local  win =  tostring(body ["win"]);
	for i=1,4 do
		local csb = cs[i];
		if csb ~= nil then
			if  tostring(csb[1]) == EginUser.Instance.uid then
				userPlayerCtrl:SetSelfH3_4_5(5,tonumber(csb[2]),i*0.5);
			else
				local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(csb[1]));
				player1:SetOtherH3_4_5 (5,tonumber(csb[2]),i*0.5);
			end
		end	
	end

	if win == EginUser.Instance.uid then
		is_guo = true;
		this.chooseChipObj:SetActive(true);
		this.btnsObj:SetActive(true);
		this.chooseChipObj0:SetActive(false);
		this:checkChooseChipMax(false)
		this:setNNCountPos(userPlayerCtrl)
		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
		for i=0, 2 do
			local btn = btns[i].gameObject;
			userPlayerCtrl:SetStartChip(btn, (diChip*this.diChipBei[i+1]));
			btn.name = tostring(diChip*this.diChipBei[i+1]);
		end

	else
		is_guo = false;
		this:yingKongButts ();
		this:setNNCountPos(this:getPlayerCtrl(_nnPlayerName..tostring(win)))
	end
	NNCount.Instance:UpdateHUD(ju_time);
end

---body:[[uid,剩余牌数组],]
function this:ProcessAllIn(messageObj)
	EginTools.PlayEffect (this.soundXiazhu);
	local body = messageObj["body"];
	for key,ones in ipairs(body) do
		local onePais = ones[2];
		for j,v in ipairs(onePais) do
			if  tostring(ones[1]) == EginUser.Instance.uid then
				userPlayerCtrl:tiShi("all");
				userPlayerCtrl:SetSelfH3_4_5(inHandPaiNum+j, tonumber(v),j*0.5);
			else
				local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(ones[1]));
				player1:tiShi("all");
				player1:SetOtherH3_4_5 (inHandPaiNum+j, tonumber(v),j*0.5);
			end
		end
	end

	--NNCount.Instance:UpdateHUD(ju_time);
end

---state:[[uid,输赢钱数,牌型],]
---cards:[[uid,card],]
function this:ProcessOver(messageObj)
	is_guo = false;
	
	inHandPaiNum = 0;
	this.jsk:SetActive(false)
	EginTools.PlayEffect (this.soundEnd);
	this:yingKongButts ();
	local allInButt0 = this.btnsObj.transform:FindChild ("ButtonAllIn0").gameObject;
	allInButt0:SetActive(false);
	this:placeScore()
	this.ButtonAllIn:SetActive(true)
	local body = messageObj["body"];
	local state = body["state"];
	local cards = body["cards"];
	local tResultSpriteWin = this.jsk.transform:FindChild("titleLabel/win").gameObject
	tResultSpriteWin:SetActive(false)
	local tResultSpriteLost = this.jsk.transform:FindChild("titleLabel/lost").gameObject
	tResultSpriteLost:SetActive(false)
	for tScoreIndex=0,3 do
		this.jsk.transform:FindChild("score"..tScoreIndex).gameObject:SetActive(false)
		this.jsk.transform:FindChild("nickName"..tScoreIndex).gameObject:SetActive(false)
	end
	--要显示底牌的玩家的牌
	local tPlayerCardsInfo = {}
	for tIndexCard,tPlayerCard12 in ipairs(cards) do
		tPlayerCardsInfo["uid"..tPlayerCard12[1]] = tPlayerCard12[2]
	end
	for i=1,4 do
		local tScoreLabel = this.jsk.transform:FindChild ("score"..(i-1)).gameObject;
		local tScoreLabelW = this.jsk.transform:FindChild ("score"..(i-1).."_w").gameObject;
		local tNameLabel = this.jsk.transform:FindChild ("nickName"..(i-1)).gameObject;
		tScoreLabel:SetActive(false)
		tScoreLabelW:SetActive(false)
		tNameLabel:SetActive(false)
	end
	local tIsSeflJoin = false
	--显示结果
	for i,stateOne in ipairs(state) do
		local tScoreLabel = this.jsk.transform:FindChild ("score"..(i-1)).gameObject:GetComponent("UILabel");
		local tScoreLabelW = this.jsk.transform:FindChild ("score"..(i-1).."_w").gameObject:GetComponent("UILabel");
		local tNameLabel = this.jsk.transform:FindChild ("nickName"..(i-1)).gameObject:GetComponent("UILabel");
		if stateOne  ~= nil then	
			local otherFisrtCardNum = -1;
			local cardOne = tPlayerCardsInfo["uid"..tostring(stateOne[1])];
			if cardOne ~= nil then
				otherFisrtCardNum =  cardOne
			end

			tNameLabel.gameObject:SetActive(true)	
			if(tonumber(stateOne[2])<0) then
				tScoreLabel.gameObject:SetActive(false)	
				tScoreLabelW.gameObject:SetActive(true)
				local tScore = tostring(stateOne[2])
				tScoreLabel.text = tScore
				tScoreLabelW.text = tScore
			else
				tScoreLabel.gameObject:SetActive(true)	
				tScoreLabelW.gameObject:SetActive(false)
				local tScore = "+"..tostring(stateOne[2])
				tScoreLabel.text = tScore
				tScoreLabelW.text = tScore
			end
			if  tostring(stateOne[1]) == EginUser.Instance.uid then
				tIsSeflJoin = true
				if tonumber(stateOne[2]) <=0 then
					tResultSpriteWin:SetActive(false)
					tResultSpriteLost:SetActive(true) 
				else
					tResultSpriteWin:SetActive(true)
					tResultSpriteLost:SetActive(false) 
				end
 				tNameLabel.text = EginUser.Instance.nickname
				if isSelfQP==false and #cards==1 then
					userPlayerCtrl:SetCardTypeYing();
				else
					userPlayerCtrl:SetCardTypeUser(tonumber(stateOne[3]),tonumber(stateOne[4]),tonumber(stateOne[5]));
				end
				userPlayerCtrl:tiShi("")
			else			
				local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(stateOne[1]));
				tNameLabel.text = player1.userNickname.text
				if isSelfQP == true and #cards==1 then
					player1:SetCardTypeYing();
				else
					player1:SetCardTypeOther (otherFisrtCardNum, tonumber(stateOne[3]),tonumber(stateOne[4]));
				end
				player1:tiShi("")
			end 
		end
	end

	this:checkChooseChipMax(false)
	this:setNNCountPos(userPlayerCtrl)
	NNCount.Instance:UpdateHUD(_enterOutTime);
	this:SetIsEnableNNCount(false)
	isSelfQP = false;
	if tIsSeflJoin then

		isOverState = true
		coroutine.wait(3);
		if this.mono==nil then
			return;
		end
		this:HandleDelayMsg()
		--userPlayerCtrl:clearPais()
		this.jsk:SetActive(true)
	else
		coroutine.wait(1);
		if this.mono==nil then
			return;
		end
		this.jsk:SetActive(false)
    	this:UserReady()
	end
end

function this:HandleDelayMsg()
	coroutine.start(this.AfterDoing,self,2,this.doHandleDelayMsg);
end

function this:doHandleDelayMsg()
		if this.mono==nil then
			return;
		end
		isOverState = false
		for tkey,tValue in pairs(_delayLeaveComeMsg) do
			--error("SocketReceiveMessage:delay handlemsg "..tkey)
			if string.sub(tkey,0,1) == "c" then
				this:ProcessCome(tValue)
			else
				this:ProcessLeave(tValue)
			end
		end
		_delayLeaveComeMsg = {}
end

---看牌消息
function this:ProcessKP(messageObj)
	if  tostring(messageObj["body"]) ~= EginUser.Instance.uid then
		local player1 = this:getPlayerCtrl(_nnPlayerName..tostring(messageObj["body"]));
		player1:tweenOtherPai();
	end
end

function this:ProcessEnter(messageObj)
	UISoundManager.PlayBGSound();
	local body = messageObj["body"];
	local memberinfos = body["memberinfos"];
	local deskInfo = body["deskinfo"]; 
	userPlayerCtrl = this:getPlayerCtrl(_nnPlayerName..EginUser.Instance.uid)
	for key, memberinfo in ipairs(memberinfos) do
		if memberinfo ~= nil then
			if  tostring(memberinfo["uid"]) == EginUser.Instance.uid then
                _userIndex = memberinfo["position"]
                local waiting = memberinfo["waiting"]
                if(waiting) then
                    table.insert(_waitPlayerList, userPlayerCtrl)
                else
                    table.insert(_playingPlayerList, userPlayerCtrl)
                    _reEnter = true
                end
				this:ReplaceNameFivePlayerCtrl(this.userPlayerObj.name,_nnPlayerName..EginUser.Instance.uid);
				this.userPlayerObj.name = _nnPlayerName..EginUser.Instance.uid;
				if PlatformGameDefine.game.GameID ~= "1097" then
					local myScore = this.pmk_myScoreTxt:GetComponent("UILabel");
					myScore.text =  tostring(memberinfo["score"]);
					local juLun = this.pmk_SATxt:GetComponent("UILabel");
					juLun.text = memberinfo["rank"].."/"..deskInfo["cn"];
					userPlayerCtrl:setPlayMoney( tostring(memberinfo["score"]));
				end
				if SettingInfo.Instance.autoNext then
					this:UserReady()
				end
				break
			end
		end
	end

	for key, memberinfo in ipairs(memberinfos) do
		if memberinfo ~= nil then
			if  tostring(memberinfo["uid"]) ~= EginUser.Instance.uid then
				this:AddPlayer(memberinfo,_userIndex);
			end
		end
    end

	if PlatformGameDefine.game.GameID ~= "1097" then
		gameRound =  tonumber(deskInfo ["round"])
		if gameStep ~=  tonumber(deskInfo ["step"]) then
			gameInnings = 0;
			gameStep =  tonumber(deskInfo ["step"])
		else
			if deskInfo ["playedtimes"] ~= nil and tonumber(deskInfo ["playedtimes"]) ~= 0 then
				gameInnings =  tonumber(deskInfo ["playedtimes"]);
			else
				gameInnings = gameInnings +1;
			end
		end

		local julun = this.pmk_juLunTxt:GetComponent("UILabel");
		julun.text = gameInnings.."/"..gameRound;

		local jinJu = this.pmk_jinJuTxt:GetComponent("UILabel");
		jinJu.text =  tostring(deskInfo ["promotion_jushu"]);

		local pnumm = this.bm_pnum:GetComponent("UILabel");
		pnumm.text =  tostring(deskInfo ["cn"]);

		this.paimingkuang_view:SetActive(true);

		local top10 = deskInfo ["top10"];

		for j,top10One in ipairs(top10) do

			if j < 11 then
				local nick = this.pmk_nickArr [j];
				local score = this.pmk_scoreArr [j];
				local nickLb = nick:GetComponent("UILabel");
				local scoreLb = score:GetComponent("UILabel");
				nickLb.text =  tostring(top10One [3]);
				scoreLb.text =  tostring(top10One [1]);
			end
		end
	end

end

function this:AddPlayer(memberinfo)
--[[local jsonStr = cjson.encode(memberinfo);

	local player1 = GameObject.Find (_nnPlayerName..otherUid);
	if player1 ~= nil then
		player1:SetActive(false);
		this:RemoveFivePlayerCtrl(player1.name);
		if tableContains(_playingPlayerList,player1) then
			tableRemove(_playingPlayerList,player1);
		end
		destroy(player1);
	end


	otherUid = tostring(memberinfo["uid"] );

	local uid =  tostring(memberinfo["uid"]);
	local bag_money = tostring( memberinfo["bag_money"]);

	local nickname = tostring(memberinfo["nickname"]);
	local avatar_no = tonumber(memberinfo["avatar_no"]);

	otherUname = nickname;

	local level =  tostring(memberinfo ["level"]);

	local player = NGUITools.AddChild (this.gameObject, this.dznnPlayerPrefab);
	player.name = _nnPlayerName..uid;
	this:GetFivePlayerCtrl(player.name,player);
	table.insert(_playingPlayerList,player);


	local anchor = player:GetComponent("UIAnchor");
	anchor.side = UIAnchor.Side.Top;
	anchor.relativeOffset.x = 0.13;
	anchor.relativeOffset.y = 0.09;


	local ctrl = this:GetFivePlayerCtrl(player.name);
	ctrl:SetPlayerInfo (avatar_no, nickname, bag_money, level);

	if PlatformGameDefine.game.GameID ~= "1097" then
		ctrl:setPlayMoney (tostring(memberinfo["score"] ));
	end

	ctrl:clearPais ();

	return player;--]]

    local uid = memberinfo["uid"]
    local bag_money = memberinfo["bag_money"]
    local nickname = memberinfo["nickname"]
    local avatar_no = memberinfo["avatar_no"]
    local position = memberinfo["position"]
    local ready = memberinfo ["ready"]
    local waiting = memberinfo["waiting"]
    local level = memberinfo ["level"]

    local player = NGUITools.AddChild(this.gameObject, this.dznnPlayerPrefab)
    player.name = _nnPlayerName .. uid
    this:SetAnchorPosition(player, _userIndex, position)

    this:bindPlayerCtrl(_nnPlayerName..uid, player)
    local ctrl = this:getPlayerCtrl(_nnPlayerName..uid)
	ctrl.deskPosition = position
    ctrl:SetPlayerInfo (avatar_no, nickname, bag_money, level)
	ctrl:clearPais()

	if PlatformGameDefine.game.GameID ~= "1097" then
		ctrl:setPlayMoney (tostring(memberinfo["score"] ));
	end

    if (waiting) then
        if( ready ) then
            ctrl:SetReady(true)
            table.insert(_readyPlayerList, player)
        end
        table.insert(_waitPlayerList, player)
    else
        table.insert(_playingPlayerList, player)
    end

    return player
end

function this:SetAnchorPosition(player, _userIndex, playerIndex)
    local position_span = playerIndex - _userIndex
    local anchor = player:GetComponent("UIAnchor")
	anchor.pixelOffset = Vector2.New(0,0,0)
    if(position_span == 0) then
        anchor.side = UIAnchor.Side.Bottom
    elseif (position_span == 1 or position_span == -3) then
        anchor.side = UIAnchor.Side.Right
        anchor.relativeOffset = Vector2.New(0.07, 0.09)
    elseif (position_span == 2 or position_span == -2) then
        anchor.side = UIAnchor.Side.Top
        anchor.relativeOffset = Vector2.New(0.05, -0.1)
    elseif(position_span == 3 or position_span == -1) then
        anchor.side = UIAnchor.Side.Left
        anchor.relativeOffset = Vector2.New(0.18, 0.09)
    end
end

function this:ProcessReady(messageObj)
	local uid =  tostring(messageObj["body"]);
	---去掉牌型显示
	if uid == EginUser.Instance.uid then
		this:nextJu();
        userPlayerCtrl:SetDeal (false, nil);
        userPlayerCtrl:clearPais()
        userPlayerCtrl:SetScore(-1)
		this:SetIsEnableNNCount(false)
	else
		if not this.btnBegin.activeSelf then
            local ctrl = this:getPlayerCtrl(_nnPlayerName..uid)
			if ctrl ~= nil then
				ctrl:SetDeal(false, nil)
				ctrl:clearPais()
				ctrl:SetScore(-1)
			end
			--ctrl:SetReady(true)
		end
	end
end

function this:ProcessDeskOver( messageObj)

end

function this:ProcessUpdateAllIntomoney(messageObj)
	local jsonStr = cjson.encode(messageObj);
	local a11=string.find(jsonStr,EginUser.Instance.uid);
	if not a11 then return nil; end

	local infos = messageObj["body"]
	for key,info in ipairs(infos) do
		local uid = info[1]
		local intoMoney = info[2]
        local ctrl = this:getPlayerCtrl(_nnPlayerName..uid)
        if ctrl ~= nil then
            if PlatformGameDefine.game.GameID == "1097" then
                ctrl:UpdateIntoMoney(intoMoney);
            else
                ctrl:setPlayMoney(intoMoney);
            end
        end
	end
end

function this.ProcessUpdateIntomoney( messageStr)
	local messageObj = cjson.decode(messageStr);
	local intoMoney = tostring(messageObj["body"]);
	local info = GameObject.Find ("Panel_info");
	if not IsNil(info) then
		FootInfo:UpdateIntomoney(intoMoney);
	end
end

function this:ProcessCome(messageObj)
	local body = messageObj["body"];
	local memberinfo = body["memberinfo"];
	this:AddPlayer(memberinfo,_userIndex);
end

function this:ProcessLeave(messageObj)
	local uid = messageObj["body"]
	if tostring(uid) ~= EginUser.Instance.uid then
		local player = GameObject.Find(_nnPlayerName..uid)
		this:RemoveFivePlayerCtrl(_nnPlayerName..uid)
		if tableContains(_playingPlayerList,player) then
			tableRemove(_playingPlayerList,player)
		end
		destroy(player)
	end
end

---弃牌按钮
function this:UserQi()
	is_guo = false;
	this:SetIsEnableNNCount(false)
	this.chooseChipObj:SetActive(false);
	this.btnsObj:SetActive(false);
	this.chooseChipObj0:SetActive(false);
	this:checkChooseChipMax(false)
	local chip_in = {type="gswz2",tag="qp"};
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);
end

---全压按钮
function this:UserAllIn()
	this:SetIsEnableNNCount(false)
	is_guo = false;
	this.chooseChipObj:SetActive(false);
	this.btnsObj:SetActive(false);
	this.chooseChipObj0:SetActive(false);
	this:checkChooseChipMax(false)
	local chip_in = {type="gswz2",tag="add",body = -1};
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);

end


---跟牌按钮
function this:UserGen()
	this:SetIsEnableNNCount(false)	
	this.chooseChipObj:SetActive(false);
	this.btnsObj:SetActive(false);
	this.chooseChipObj0:SetActive(false);
	this:checkChooseChipMax(false)
	local chip_in = nil;
	if is_guo then
		chip_in = {type="gswz2",tag="guo"};
	else
		chip_in = {type="gswz2",tag="gen"};
	end
	is_guo = false;
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);
end


---显示奖励列表
function this:showJiangList()
	this.bm_JiangList:SetActive(not this.bm_JiangList.activeSelf);
end


---复活按钮 单击
function this:fuHuoTrue()
	this.fuhuo_view:SetActive(false);

	local chip_in = {type="gswzsm",tag="rebuy",body=true};
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);

end


---不复活
function this:fuHuoFalse()
	this.fuhuo_view:SetActive(false);

	local chip_in = {type="gswzsm",tag="rebuy",body=false};
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);
end


---用户排名列表单击
function this:uListViewClick()
	local bgsp  = this.pmk_bg:GetComponent("UISprite");
	if this.pmk_listView.activeSelf then
		bgsp.height  = 330;
		this.pmk_listView:SetActive(false);
	else
		bgsp.height  = 800;
		this.pmk_listView:SetActive(true);
	end
end

function this:JskContinueClick()
	this:doHandleDelayMsg()
	this:setNNCountPos(userPlayerCtrl)
	NNCount.Instance:UpdateHUD(_readyOutTime);
	this:SetIsEnableNNCount(true)
	this:UserReady()
end

function this:UserReady()
	---避免了已经点击过开始按钮但是还是有倒计时声音
	NNCount.Instance:DestroyHUD();
	---新的一句开始时去掉庄家标志
	if _bankerPlayer ~= nil then
		--this:getPlayerCtrl(_bankerPlayer.name):SetBanker(false);
	end
	---向服务器发送消息（开始游戏）
	local chip_in = {type="game",tag="continue"};
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);

	EginTools.PlayEffect(soundStart);
	this.jsk:SetActive (false);
	this.btnBegin:SetActive(false);
	--[[this:setNNCountPos(userPlayerCtrl)
	NNCount.Instance:UpdateHUD(_readyOutTime);
	this:SetIsEnableNNCount(true)--]]
end


--- 将用户下注的筹码发送给服务器
function this:UserChip( go)
	this.chooseChipObj:SetActive (false);
	this.btnsObj:SetActive (false);
	this.chooseChipObj0:SetActive (false);
	this:SetIsEnableNNCount(false)
	local chip = tonumber(go.name);
	local chip_in = {type="gswz2",tag="add",body=chip};
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);
end

function this:UserLeave()
	local chip_in = {type="game",tag="leave",body=EginUser.Instance.uid};
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);
end


function this:UserQuit()
	SocketConnectInfo.Instance.roomFixseat = true;
	local chip_in = {type="game",tag="quit"};
	local jsonStr = cjson.encode(chip_in);
	this.mono:SendPackage(jsonStr);

	this.mono:OnClickBack ();
end


function this:Back()
	this.mono:OnClickBack();
end
 

function this:OnClickBack ()
	if not _isPlaying then
		this:UserQuit();
	else
		this.msgQuit:SetActive(true);
	end
end


function this:ProcessNotcontinue()
	this.msgNotContinue:SetActive(true);
	coroutine.wait(3);
	if this.mono==nil then
		return;
	end
	this:UserQuit();
end


function this.ShowPromptHUD(errorInfo)
	this.btnBegin:SetActive (false);
	this.msgAccountFailed:SetActive (true);
	this.msgAccountFailed:GetComponentInChildren(Type.GetType("UILabel",true)).text = errorInfo;
end


--获取_ftwzPlayerCtrl对象
--[[function this:GetFivePlayerCtrl(tbName,tbObj)
	
	local ftwzTemp = this._ftwzPlayerCtrl[tbName]
	if ftwzTemp == nil then
		
		if not IsNil(tbObj) then
			this._ftwzPlayerCtrl[tbName] = SRFivePlayerCtrl:New(tbObj);
			ftwzTemp = this._ftwzPlayerCtrl[tbName]
			
		else
		end
		
	end
	return ftwzTemp
end--]]
function this:ReplaceNameFivePlayerCtrl(oldName,newName)
	if oldName ~= newName then
		local ftwzTemp = this._ftwzPlayerCtrl[oldName]
		if ftwzTemp ~= nil then
			this._ftwzPlayerCtrl[newName] = ftwzTemp
			this._ftwzPlayerCtrl[oldName] = nil
		end
	end
end

--删除_ftwzPlayerCtrl对象
function this:RemoveFivePlayerCtrl(tbName)
	local ftwzTemp = this._ftwzPlayerCtrl[tbName];
	if ftwzTemp then
		ftwzTemp._alive = false;
		ftwzTemp:clearLuaValue();
		this._ftwzPlayerCtrl[tbName] = nil;
		ftwzTemp = nil;
	end
end

function this:RemoveAllFivePlayerCtrl()
	if this._ftwzPlayerCtrl then
		for key,v in pairs(this._ftwzPlayerCtrl) do
			v._alive = false;
			v:clearLuaValue();
		end
		this._ftwzPlayerCtrl = nil;
	end
end

function this:AfterDoing(offset,run)
	coroutine.wait(offset);
	if this.mono then
		run();
	end
end

function this:Update()
	while this._ftwzPlayerCtrl do
		if not IsNil(this.bm_view) then
			if this.bm_view.activeSelf then
				if (Time.time-_currTime)>=1 then
					_currTime = Time.time;
					if _num>0 then
						_num= _num-1;
						local daojishi = this.bm_time:GetComponent("UILabel");
						daojishi.text = EginTools.miao2TimeStr(_num,false,false);
					end
					if readyST>0 then
						readyST= readyST-1;
						EginProgressHUD.Instance:ShowPromptHUD ("还有"..readyST.."秒  半决赛开始");
					end
				end
			end
		end		
		for key,v in pairs(this._ftwzPlayerCtrl) do
			if v._alive then
				v:Update();
			end
		end
		coroutine.wait(Time.deltaTime);
	end
end


function this:onClickHelp()
	this.helpPanel:SetActive(true)
end

function this:onClickExitHelp()
	this.helpPanel:SetActive(false)
end


--表情
function this:onClickMotion()
	--if this.motionPanel then
		--this.motionPanel:Show()
	--end
	this.motionPanel:SetActive(true);
end

function this:initMotion()
	local tLen = this.motionGridTransform.transform.childCount-1
	for i=0,tLen do
		local tObj = this.motionGridTransform:GetChild(i).gameObject
		this.mono:AddClick(tObj,this.onClickSendMotion)
	end
end

function this:onClickSendMotion(pEmotionObj)
  if Time.time - motionTime >= 10 then
	--curMotionID = tonumber(pEmotionObj.name)
	local index=0;
	log("开始发送表情");
	for i=1,27 do
		local smile=this.motionGridTransform.transform:FindChild("biaoqing_"..i);
		log(pEmotionObj.name);
		if pEmotionObj==smile.gameObject then
			index=i;
			break;
		end
	end
	local chatMsg = {type="game",tag="emotion",body=index};
	local jsonStr = cjson.encode(chatMsg);
	this.mono:SendPackage(jsonStr);
	motionTime = Time.time
   else 
   	 EginProgressHUD.Instance:ShowPromptHUD("休息下吧，稍后再试")
   end
   this.motionPanel:SetActive(false);
end

function this:ProcessEmotion(message)
	local body=message["body"];
	local id=tonumber(body[1]);
	local number=tonumber(body[2]);
	if id == EginUser.Instance.uid then
	  userPlayerCtrl:setEmotion(number)
	else
	 local ctrl=this:getPlayerCtrl(_nnPlayerName..id);
	 ctrl:setEmotion(number);
	end 
end

--聊天
function this:initChatData(pIsMale)
	if pIsMale then
		chatArr = {'诚信五张不偷不抢','莫偷鸡，偷鸡必被抓！','别挣扎了，大奖非我莫属！','我的宝剑已经饥渴难耐了！','冷静！冲动是魔鬼！','对子再手，天下无敌！','这手牌打的不错，赢的漂亮！','快点下注吧！爷时间宝贵！'}
	else
		chatArr = {'很高兴能和大家一起打牌','赢钱了别走，留下你的姓名！','难道你看穿我的底牌了吗？','各位爷，让看看翻牌再加注吧！','输惨了啦!','似乎有埋伏，不可轻举妄动。','你牌技这么好，地球人知道吗？','想什么呢？快点！'}
	end
	for i=1,12 do
		local tChatTxt = this.transform:FindChild("Content/PanelChat/Scroll View/grid/lb"..i).gameObject:GetComponent("UILabel")
		if i<=#chatArr then
			local tGameObj = tChatTxt.gameObject
			tGameObj:SetActive(true)
			tGameObj.name = i
			tChatTxt.text = chatArr[i]
			this.mono:AddClick(tGameObj,this.onClickChatItem)	
		else
			tChatTxt.gameObject:SetActive(false)
		end
	end
	local tGrid = this.transform:FindChild("Content/PanelChat/Scroll View/grid").gameObject:GetComponent("UIGrid")
	tGrid:Reposition()
end

function this:onClickChat()
	if this.chatPanel~=nil then
		this.chatPanel.transform.localScale = Vector3.New(1,1,1)
		this.chatPanel.gameObject:SetActive(true)
		this.chatPanel.transform:FindChild("bg2").gameObject:SetActive(false)
	end
end

function this.onClickChatItem(pChatItem)
	curChatID = tonumber(pChatItem.name)
	this:onClickSendChat()
	this.chatPanel.gameObject:SetActive(false)
end

function this:onClickSendChat()
	if Time.time - chatTime >= 10 then
		local tBody 		 = {}
		tBody['hurry_index']    = curChatID
		local chatMsg = {type="game",tag="hurry",body=tBody};
		local jsonStr = cjson.encode(chatMsg);
		this.mono:SendPackage(jsonStr);
		chatTime = Time.time
	else
		EginProgressHUD.Instance:ShowPromptHUD("休息下吧，稍后再试")
	end
end

function this:ProcessHurry(message)
	languageEndTime=Time.time;
	local body=message["body"];
	local spokesman=tonumber(body["spokesman"]);
	local index=tonumber(body["index"]);
	--log(index.."语音");
	local ctrl=this:getPlayerCtrl(_nnPlayerName..spokesman);

	ctrl:setMessage(index,chatArr[index]);
end