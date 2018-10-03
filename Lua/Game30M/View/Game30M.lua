require "GameNN/Tools"
require "GameNN/DeskInfo"
require "GameNN/GPoker"
require "GameNN/UISoundManager"
require "GameNN/MTimer"
require "GameNN/GToast"
require "GameNN/GPlayer"

local cjson = require "cjson"

local this = LuaObject:New()
Game30M = this;


local bettime = 0;
local selectMoney=0;
local isPrimary=false;
local setTimeout=0;
local curTimeout=0;
local baktime=0;
local bakWinMoney=0;
local plyWinMoney=0;
local canBet=false;
local tarToggle = nil;
local spRect={};
local players={};
local bankupInfos={};
local paths={};
local deskinfos={};
local jettonPrefab={};

function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	this.ScreenW = nil
	this.ScreenH = nil
	this.TargetH = nil;
	this.mxBackButton = nil
	this.mxSettButton = nil;
	this.mxBakupButton = nil
	this.mxBakluButton = nil
	this.mxbtnBet0 = nil
	this.mxbtnBet1 = nil
	this.mxbtnBet2 = nil
	this.mxbtnBet3 = nil
	this.mxbtnBet4 = nil
	this.mxbtnBet5 = nil
	this.mxtxtPlyInfo0 = nil
	this.mxtxtPlyInfo1 = nil
	this.mxtxtPlyInfo2 = nil
	this.mxtxtPlyInfo3 = nil
	this.mxtxtPlyInfo4 = nil
	this.mxtxtPlyInfo5 = nil
	this.mTimer = nil
	this.mxWaitGameInfo = nil
	this.mxBakupToast = nil
	this.mxErrorToast = nil
	this.mBakupListGrid = nil
	this.mxBankupChangeButton = nil
	this.mxFinalSettle0 = nil
	this.mxFinalSettle1 = nil
	this.mxSettBGBar = nil
	this.mxSettEFBar = nil
	this._0Layout = nil
	this._1Layout = nil
	this._2Layout = nil
	this._3Layout = nil
	this._4Layout = nil
	this._5Layout = nil
	this._6Layout = nil
	this._7Layout = nil
	this._8Layout = nil
	this.player = nil
	this.banker = nil
	this.pokers = nil
	this.expsObj = nil;
	
	selectMoney=0;
	isPrimary=false;
	setTimeout=0;
	curTimeout=0;
	baktime=0;
	bakWinMoney=0;
	plyWinMoney=0;
	canBet=false;
	tarToggle = nil;
	spRect=nil;
	players=nil;
	bankupInfos=nil;
	paths=nil;
	deskinfos=nil;
	jettonPrefab=nil;

	

	coroutine.Stop()
	UISoundManager.finish()
	LuaGC();
end
function this:Init()
	this.ScreenW = nil
	this.ScreenH = nil
	this.TargetH = nil;
	
	
	this._0Layout = this.transform:FindChild("0Layout")
	this._1Layout = this.transform:FindChild("1Layout")
	this._2Layout = this.transform:FindChild("2Layout")
	this._3Layout = this.transform:FindChild("3Layout")
	this._4Layout = this.transform:FindChild("4Layout")
	this._5Layout = this.transform:FindChild("5Layout")
	this._6Layout = this.transform:FindChild("6Layout")
	this._7Layout = this.transform:FindChild("7Layout")
	this._8Layout = this.transform:FindChild("8Layout")
	this.mxBackButton = this.transform:FindChild("0Layout/ChildButton0").gameObject:GetComponent("UISprite");
	this.mxSettButton = this.transform:FindChild("0Layout/ChildButton3").gameObject:GetComponent("UISprite");
	this.mxBakupButton = this.transform:FindChild("0Layout/ChildButton1").gameObject:GetComponent("UISprite")
	this.mxBakluButton = this.transform:FindChild("0Layout/ChildButton2").gameObject:GetComponent("UISprite")
	this.mxbtnBet0 = this.transform:FindChild("0Layout/ChildRidButton0").gameObject:GetComponent("UIToggle")
	this.mxbtnBet1 = this.transform:FindChild("0Layout/ChildRidButton1").gameObject:GetComponent("UIToggle")
	this.mxbtnBet2 = this.transform:FindChild("0Layout/ChildRidButton2").gameObject:GetComponent("UIToggle")
	this.mxbtnBet3 = this.transform:FindChild("0Layout/ChildRidButton3").gameObject:GetComponent("UIToggle")
	this.mxbtnBet4 = this.transform:FindChild("0Layout/ChildRidButton4").gameObject:GetComponent("UIToggle")
	this.mxbtnBet5 = this.transform:FindChild("0Layout/ChildRidButton5").gameObject:GetComponent("UIToggle")
	this.mxtxtPlyInfo0 = this.transform:FindChild("0Layout/ChildLabel0").gameObject:GetComponent("UILabel")
	this.mxtxtPlyInfo1 = this.transform:FindChild("0Layout/ChildLabel1").gameObject:GetComponent("UILabel")
	this.mxtxtPlyInfo2 = this.transform:FindChild("0Layout/ChildLabel2").gameObject:GetComponent("UILabel")
	this.mxtxtPlyInfo3 = this.transform:FindChild("0Layout/ChildLabel3").gameObject:GetComponent("UILabel")
	this.mxtxtPlyInfo4 = this.transform:FindChild("0Layout/ChildLabel4").gameObject:GetComponent("UILabel")
	this.mxtxtPlyInfo5 = this.transform:FindChild("0Layout/ChildLabel5").gameObject:GetComponent("UILabel")
	
	local timergameobj =  this.transform:FindChild("0Layout/ChildTimer").gameObject--倒计时
	this.mTimer = MTimer:New(timergameobj);
	
	this.mxWaitGameInfo = this.transform:FindChild("3Layout/ChildTipLabel").gameObject:GetComponent("UILabel")
	this.mxBakupToast = GToast:New(this.transform:FindChild("3Layout/GameToastBakup").gameObject)
	
	this.mxErrorToast = GToast:New(this.transform:FindChild("3Layout/GameToastError").gameObject)
	
	this.mBakupListGrid = this.transform:FindChild("5Layout/BakupList/BakupListView/UIGrid").gameObject:GetComponent("UIGrid")
	this.mxBankupChangeButton =  this.transform:FindChild("5Layout/BakupList/BakupButton").gameObject:GetComponent("UISprite")
	this.mxFinalSettle0 = this.transform:FindChild("4Layout/LayoutLabel0").gameObject:GetComponent("UILabel")
	this.mxFinalSettle1 = this.transform:FindChild("4Layout/LayoutLabel1").gameObject:GetComponent("UILabel")
	this.mxSettBGBar = this.transform:FindChild("7Layout/GameSettView/SettViewSBar0").gameObject:GetComponent("UISlider")
	this.mxSettEFBar = this.transform:FindChild("7Layout/GameSettView/SettViewSBar1").gameObject:GetComponent("UISlider")
	
	this.player = nil
	this.banker = nil
	
	bettime = 0;
	selectMoney=0;
	isPrimary=false;
	setTimeout=0;
	curTimeout=0;
	baktime=0;
	bakWinMoney=0;
	plyWinMoney=0;
	canBet=false;
	tarToggle = nil;
	spRect={};
	players={};
	bankupInfos={};
	paths={};
	deskinfos={};
	jettonPrefab={};

	this.pokers = {};
	this.expsObj = {};
end
function this:Awake()
	log("------------------awake of Game30MPanel")
	this:Init();
	
	--------初始化UISoundManager-------------
	UISoundManager.Init(this.gameObject);
	--添加背景音乐资源
	UISoundManager.AddAudioSource("game30m/sound","bj",true);
	--添加音效资源
	UISoundManager.AddAudioSource("gamenn/gamebr","nbet");
	UISoundManager.AddAudioSource("gamenn/gamebr","ncards");
	UISoundManager.AddAudioSource("gamenn/gamebr","nplos");
	UISoundManager.AddAudioSource("gamenn/gamebr","npwin");
	UISoundManager.AddAudioSource("gamenn/gamebr","nspbet");
	UISoundManager.AddAudioSource("gamenn/gamebr","nstbet");
	----------绑定按钮事件--------
	this.mono:AddClick(this._0Layout:FindChild("ChildButton0").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildButton1").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildButton2").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildButton3").gameObject, this.OnButtonClick,this);
	
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton0").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton1").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton2").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton3").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton4").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton5").gameObject, this.OnClickBetChange,this);
	
	this.mono:AddClick(this._1Layout:FindChild("BetDesk0").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk1").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk2").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk3").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk4").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk5").gameObject, this.OnBetButtonClick,this);
	
	this.mono:AddClick(this._5Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddClick(this._6Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddClick(this._7Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	
	this.mono:AddClick(this._5Layout:FindChild("BakupList/BakupButton").gameObject, this.OnButtonClick,this);
	
	this.mono:AddClick(this._8Layout:FindChild("GameExitView/ExitViewButton0").gameObject, this.CloseGame,this);
	this.mono:AddClick(this._8Layout:FindChild("GameExitView/ExitViewButton1").gameObject, this.CloseExitView,this);
	
	this.mono:AddSlider(this.mxSettBGBar, this.OnSoundBarChanged);
	this.mono:AddSlider(this.mxSettEFBar, this.OnSoundBarChanged);
	------------逻辑代码------------
end

function this:Start()
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end
	
		local ratio = Screen.width / Screen.height;     --实际运行游戏屏幕的宽高（game视图）
		this.ScreenH = sceneRoot.manualHeight;      
		this.ScreenW = ratio * this.ScreenH;       

		
	this.ScreenW = sceneRoot.manualWidth;     
	this.TargetH = this.ScreenW * 0.5;
	this:initLayout();
	
	this.mono:StartGameSocket();
	coroutine.start(this.Update);
	--开启音乐
	UISoundManager.Start(true);
end
function this:Update()

	while this.gameObject do
		if this.mTimer ~=nil then
			this.mTimer:Update();
		end
		coroutine.wait(0.1);
	end
end
function this:OnDestroy()
	log("--------------------ondestroy of Game30mPanel")
end
function this:OnDisable()
	this:clearLuaValue()
	
end
function this:AfterDoing(offset,run)
	coroutine.wait(offset);	
	if this.mono then
		run();
	end
end
function this:OnClickBack()
	SettingInfo.Instance.bgVolume = this.mxSettBGBar.value;
	SettingInfo.Instance.effectVolume = this.mxSettEFBar.value;
	SettingInfo.Instance:SaveInfo();
	this.mono:OnClickBack();
end
function this:initLayout()
	local sp = nil;
	local tf = nil;
	local x = 0
	local y = 0
	local w = 0
	local h = 0;

	sp = this._0Layout:FindChild ("Child1"):GetComponent ("UISprite");
	w = this.ScreenW;
	h = this.TargetH * 0.18;
	x = 0;
	y = this.ScreenH * 0.5 - h * 0.5;
	this:ResetSize (sp, 0, y, w, h);
	
	sp = this._0Layout:FindChild ("Child2"):GetComponent ("UISprite");
	w = this.ScreenW --sp.width;
	h = this.TargetH * 0.18;
	x = 0;
	y = -this.ScreenH * 0.5 + h * 0.5;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildButton0"):GetComponent ("UISprite");
	w = this.ScreenW * 0.06;
	h = this.TargetH * 0.10;
	x = -this.ScreenW * 0.5 + w * 0.52;
	y = this.ScreenH * 0.5 - h * 0.70;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildButton1"):GetComponent ("UISprite");
	w = this.ScreenW * 0.132;
	h = this.TargetH * 0.106;
	x = this.ScreenW * 0.298 + w * 0.5;
	y = this.ScreenH * 0.5 - h * 0.648;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildButton2"):GetComponent ("UISprite");
	w = this.ScreenW * 0.064;
	h = this.TargetH * 0.106;
	x = this.ScreenW*0.5 -w*1.05;
	y = this.ScreenH * 0.5 - h * 0.126;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildButton3"):GetComponent ("UISprite");
	w = this.TargetH * 0.105;
	h = w;
	x = this.ScreenW*0.5 -w*1.05;
	y = -this.ScreenH * 0.5 + h * 1.116;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildBakIcon"):GetComponent ("UISprite");
	w = this.TargetH * 0.14;
	h = w;
	x = -this.ScreenW*0.08 +w*0.55;
	y = this.ScreenH * 0.5 - h * 0.53;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildCline0"):GetComponent ("UISprite");
	w = this.ScreenW * 0.3;
	h = this.TargetH * 0.0064;
	x = this.ScreenW * 0.152;
	y = this.ScreenH*0.5-this.TargetH*0.064;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildCline1"):GetComponent ("UISprite");
	w = this.ScreenW * 0.32;
	h = this.TargetH * 0.0064;
	x = -this.ScreenW * 0.312;
	y = -this.ScreenH*0.5+this.TargetH*0.0614;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildLabel0"):GetComponent ("UILabel");
	w = this.ScreenW * 0.284;
	h = this.TargetH * 0.035;
	x = h * 0.24;
	y = this.ScreenH * 0.5 - this.TargetH * 0.043;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildLabel1"):GetComponent ("UILabel");
	w = this.ScreenW * 0.142;
	h = this.TargetH * 0.035;
	x = h * 0.24;
	y = this.ScreenH * 0.5 - this.TargetH * 0.086;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildLabel2"):GetComponent ("UILabel");
	w = this.ScreenW * 0.142;
	h = this.TargetH * 0.035;
	x =this.ScreenW*0.143+ h * 0.24;
	y = this.ScreenH * 0.5 - this.TargetH * 0.086;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildLabel3"):GetComponent ("UILabel");
	w = this.ScreenW * 0.32;
	h = this.TargetH * 0.035;
	x = -this.ScreenW * 0.472;
	y = -this.ScreenH*0.5+this.TargetH*0.0814;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildLabel4"):GetComponent ("UILabel");
	w = this.ScreenW * 0.16;
	h = this.TargetH * 0.035;
	x = -this.ScreenW * 0.472;
	y = -this.ScreenH*0.5+this.TargetH*0.038;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildLabel5"):GetComponent ("UILabel");
	w = this.ScreenW * 0.16;
	h = this.TargetH * 0.035;
	x = -this.ScreenW * 0.312;
	y = -this.ScreenH*0.5+this.TargetH*0.038;
	this:ResetSize (sp, x, y, w, h);
	
	sp = this._0Layout:FindChild ("ChildPokeBox"):GetComponent ("UISprite");
	w = this.ScreenW * 0.252;
	h = this.TargetH * 0.18;
	x = -this.ScreenW * 0.216;
	y = this.ScreenH * 0.5 - this.TargetH * 0.10;
	this:ResetSize (sp, x, y, w, h);
	
	tf = this._0Layout:FindChild ("ChildTimer");
	w = this.TargetH * 0.168;
	h = w;
	x = -this.ScreenW * 0.372;
	y = this.ScreenH * 0.5 - h * 0.50;
	this:ResetSizeTransform (tf, x, y, w, h);
	
	--[[*发牌位置*]]--
	spRect [3] = this.TargetH * 0.102;
	spRect [4] = spRect [3] * 1.2;
	spRect [1] = -this.ScreenW * 0.372;
	spRect [2] = this.ScreenH * 0.5 - this.TargetH * 0.192;
	
	w = this.TargetH * 0.18;
	h = w;
	y = -this.ScreenH*0.5 + h*0.5;
	local offset = this.ScreenW * 0.0912;
	
	tf = this._0Layout:FindChild ("ChildRidButton0");
	x = -this.ScreenW * 0.074;
	this:ResetSizeTransform (tf, x, y, w, h);
	tf = this._0Layout:FindChild ("ChildRidButton1");
	x = x+offset;
	this:ResetSizeTransform (tf, x, y, w, h);
	tf = this._0Layout:FindChild ("ChildRidButton2");
	x = x+offset;
	this:ResetSizeTransform (tf, x, y, w, h);
	tf = this._0Layout:FindChild ("ChildRidButton3");
	x = x+offset;
	this:ResetSizeTransform (tf, x, y, w, h);
	tf = this._0Layout:FindChild ("ChildRidButton4");
	x = x+offset;
	this:ResetSizeTransform (tf, x, y, w, h);
	tf = this._0Layout:FindChild ("ChildRidButton5");
	x = x+offset;
	this:ResetSizeTransform (tf, x, y, w, h);
	
	w = this.ScreenW * 0.224+40;
	h = w;
	y = this.ScreenH * 0.28 - w * 0.5;
	offset = this.ScreenW * 0.082;--0.026;


	deskinfos [1] = DeskInfo:New(this._1Layout:FindChild("BetDesk0").gameObject,"30m");
	deskinfos [3] = DeskInfo:New(this._1Layout:FindChild("BetDesk1").gameObject,"30m");
	deskinfos [4] = DeskInfo:New(this._1Layout:FindChild("BetDesk2").gameObject,"30m");
	deskinfos [6] = DeskInfo:New(this._1Layout:FindChild("BetDesk3").gameObject,"30m");
	deskinfos [7] = DeskInfo:New(this._1Layout:FindChild("BetDesk4").gameObject,"30m");
	deskinfos [8] = DeskInfo:New(this._1Layout:FindChild("BetDesk5").gameObject,"30m");

	
	tf = this._1Layout:FindChild ("JettonPrefab");
	w = w * 0.26;
	h = w;
	sp = tf:FindChild ("Jetton0"):GetComponent ("UISprite");
	jettonPrefab [1] = sp;
	this:ResetSize (sp, 0, 0, w, h);
	sp = tf:FindChild ("Jetton1"):GetComponent ("UISprite");
	jettonPrefab [2] = sp;
	this:ResetSize (sp, 0, 0, w, h);
	sp = tf:FindChild ("Jetton2"):GetComponent ("UISprite");
	jettonPrefab [3] = sp;
	this:ResetSize (sp, 0, 0, w, h);
	sp = tf:FindChild ("Jetton3"):GetComponent ("UISprite");
	jettonPrefab [4] = sp;
	this:ResetSize (sp, 0, 0, w, h);
	sp = tf:FindChild ("Jetton4"):GetComponent ("UISprite");
	jettonPrefab [5] = sp;
	this:ResetSize (sp, 0, 0, w, h);
	sp = tf:FindChild ("Jetton5"):GetComponent ("UISprite");
	jettonPrefab [6] = sp;
	this:ResetSize (sp, 0, 0, w, h);


	for  i=0, 5 do 
		this.pokers["Poker"..i] = GPoker:New(this._2Layout:FindChild ("Poker"..i).gameObject);
	end


	tf = this._3Layout:FindChild ("GameToastBakup");
	w = this.ScreenW * 0.46;
	h = this.TargetH * 0.06;
	x = this.ScreenW * 0.5 - w * 0.52;
	y = this.ScreenH * 0.5 - this.TargetH * 0.18;
	this:ResetSizeTransform (tf, x, y, w, h);

	tf = this._5Layout:FindChild ("BakupList");
	local position = Vector3.zero;
	position.y = 560;
	position.x = this.ScreenW * 0.176;
	tf.localPosition = position;

	local pathprefab=this._6Layout:FindChild("GamePathView"):FindChild("ZPathIcon"):GetComponent("UISprite");
	local  pathParent = this._6Layout:FindChild ("GamePathView"):FindChild ("PathViewGrid");
	Tools.initPathGrid (pathParent, pathprefab,Vector3.New(-498, 134, 0),-131,115,29,3,2);
	
	this.mxSettBGBar.value=SettingInfo.Instance.bgVolume;
	this.mxSettEFBar.value=SettingInfo.Instance.effectVolume;
	this:CheckBetButtonEnable (false);
	this.mxWaitGameInfo.text = XMLResource.Instance:Str ("mx_wait_ready");
	NGUITools.SetActive (this.mxWaitGameInfo.gameObject, true);
	if string.find(SocketConnectInfo.Instance.roomTitle,System.Text.RegularExpressions.Regex.Unescape("\\u521d\\u7ea7")) then
		isPrimary =  true;
	else
		isPrimary = false;
	end
end
function this:ResetSizeTransform( tf, x, y, w, h)
	local  collider = tf:GetComponent("BoxCollider");
	local size = collider.size;
	local news = Vector3.zero;
	news.x = w / size.x;
	news.y = h / size.y;
	tf.localScale = news;
	tf.localPosition = Vector3.New (x, y, 0);
end
function this:ResetSize(uw, x, y, w, h)
	uw.transform.localPosition = Vector3.New (x, y, 0);
	uw.width = tonumber(w);
	uw.height =tonumber (h);
end
function this:GetPlayer( uid)
	return players[uid];
end

function this:OnSoundBarChanged()
	UISoundManager.Instance.BGVolumeSet(this.mxSettBGBar.value);
	UISoundManager.Instance._EFVolume = this.mxSettEFBar.value;
end
function this:OnClickBetChange( target)
	local toggle = target:GetComponent("UIToggle");
	if  toggle ~= this.mxbtnBet0 then this.mxbtnBet0.value=false; end
	if toggle ~= this.mxbtnBet1 then this.mxbtnBet1.value=false; end
	if toggle ~= this.mxbtnBet2 then this.mxbtnBet2.value=false; end
	if toggle ~= this.mxbtnBet3 then this.mxbtnBet3.value=false; end
	if toggle ~= this.mxbtnBet4 then this.mxbtnBet4.value=false; end
	if toggle ~= this.mxbtnBet5 then this.mxbtnBet5.value=false; end
	if tarToggle == toggle then
		toggle.value=true;
		return;
	end

	if this.mxbtnBet0.value  then 
		selectMoney = 100;
	elseif this.mxbtnBet1.value  then
		selectMoney = 1000;
	elseif this.mxbtnBet2.value then 
		selectMoney = 10000;
	elseif this.mxbtnBet3.value then
		selectMoney = 100000;
	elseif this.mxbtnBet4.value then
		selectMoney = 500000;
	elseif this.mxbtnBet5.value then
		selectMoney = 1000000;
	end
end
function this:CheckBetButtonEnable( enable)
	selectMoney = 0;
	local sp = nil;
	tarToggle = nil;
	if enable  then
		this:CheckBetButtonEnable (false);
		local money=tonumber(this.player.money);
		if money>=100 then
			this.mxbtnBet0:GetComponent("BoxCollider").enabled=true;
			sp=this.mxbtnBet0.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
			sp.alpha=1.0;
		end
		if  not isPrimary then
			if money>=1000 then
				this.mxbtnBet1:GetComponent("BoxCollider").enabled=true;
				sp=this.mxbtnBet1.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=1.0;
			end
			if money>=10000 then
				this.mxbtnBet2:GetComponent("BoxCollider").enabled=true;
				sp=this.mxbtnBet2.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=1.0;
			end
			if money>=100000 then
				this.mxbtnBet3:GetComponent("BoxCollider").enabled=true;
				sp=this.mxbtnBet3.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=1.0;
			end
			if money>=500000 then
				this.mxbtnBet4:GetComponent("BoxCollider").enabled=true;
				sp=this.mxbtnBet4.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=1.0;
			end
			if money>=1000000 then
				this.mxbtnBet5:GetComponent("BoxCollider").enabled=true;
				sp=this.mxbtnBet5.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=1.0;
			end
		end
	else 
		this.mxbtnBet0.value=false;
		this.mxbtnBet1.value=false;
		this.mxbtnBet2.value=false;
		this.mxbtnBet3.value=false;
		this.mxbtnBet4.value=false;
		this.mxbtnBet5.value=false;
		
		this.mxbtnBet0:GetComponent("BoxCollider").enabled=false;
		sp=this.mxbtnBet0.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha=0.2;
		this.mxbtnBet1:GetComponent("BoxCollider").enabled=false;
		sp=this.mxbtnBet1.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha=0.2;
		this.mxbtnBet2:GetComponent("BoxCollider").enabled=false;
		sp=this.mxbtnBet2.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha=0.2;
		this.mxbtnBet3:GetComponent("BoxCollider").enabled=false;
		sp=this.mxbtnBet3.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha=0.2;
		this.mxbtnBet4:GetComponent("BoxCollider").enabled=false;
		sp=this.mxbtnBet4.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha=0.2;
		this.mxbtnBet5:GetComponent("BoxCollider").enabled=false;
		sp=this.mxbtnBet5.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha=0.2;
	end
end
function this:OnBetButtonClick( target)
	if selectMoney ~= 0 then 
		local index=1;
		for i=1,8 do
			if deskinfos[i]~=nil and target==deskinfos[i].gameObject then
				index=i;
				break;
			end
		end
		index=index-1;
		local chip_in = {type="zero",tag="bet",body={index,selectMoney}};   
		local jsonStr = cjson.encode(chip_in);
		this.mono:SendPackage(jsonStr);
	end
end

function this:OnButtonClick( target)
	if target == this.mxBackButton.gameObject then 
		NGUITools.SetActive (this._8Layout.gameObject, true);
	elseif target == this.mxSettButton.gameObject then  
		NGUITools.SetActive(this._7Layout.gameObject,true);
	elseif target==this.mxBakluButton.gameObject then 
		NGUITools.SetActive(this._6Layout.gameObject,true);
	elseif target==this.mxBakupButton.gameObject then 
		this:ShowBakupListAnim(true);
	elseif target==this.mxBankupChangeButton.gameObject then 
		if  not canBet then 
			local sdat=nil;
			if "mx_bakup_btn_c0" == this.mxBankupChangeButton.spriteName then
				sdat = {type="zero",tag="updealer"};   
			else
				sdat = {type="zero",tag="downdealer"};   
			end
			local jsonStr = cjson.encode(sdat);
			this.mono:SendPackage(jsonStr);
		else
			this.mxErrorToast:Show(1.2,XMLResource.Instance:Str("mx_err_game_beting"));
		end
	end
end
function this:ShowBakupListAnim( show)
	local  tf = this._5Layout:FindChild ("BakupList");
	local position = tf.localPosition;
	local tableC = iTween.Hash ("y",1320,"islocal",true,"time",0.5)
	
	if show then
		NGUITools.SetActive (this._5Layout.gameObject, true);
		iTween.MoveFrom(tf.gameObject,tableC);
	else
		iTween.MoveTo(tf.gameObject, tableC);
		coroutine.start(this.AfterDoing,this, 0.5,function()
			NGUITools.SetActive(this._5Layout.gameObject,false);
			tf.localPosition=position;
		end);
	end
end
function this:CloseExitView()
	NGUITools.SetActive (this._8Layout.gameObject, false);
end
function this:CloseMarkView()
	NGUITools.SetActive (this._8Layout.gameObject, false);
	NGUITools.SetActive (this._7Layout.gameObject, false);
	NGUITools.SetActive (this._6Layout.gameObject, false);
	if NGUITools.GetActive (this._5Layout.gameObject) then 
		this:ShowBakupListAnim(false);
	end
end
function this:CloseGame()
	this:OnClickBack();
end
function this:ResetBakupList()

	for  i = 0,this.mBakupListGrid.transform.childCount-1 do
		destroy(this.mBakupListGrid.transform:GetChild(i).gameObject);
	end
	
	local prefab = this.mBakupListGrid.transform.parent:FindChild("ListViewItem").gameObject;
	local localScale = prefab.transform.localScale;
	
	local i = 0;
	for  key,playerT in ipairs(bankupInfos) do
		local sp = GameObject.Instantiate(prefab);
		sp.transform.parent = this.mBakupListGrid.transform;
		sp.transform.localScale = localScale;
		sp.transform.localPosition = Vector3.New(0, -(key-1) * 72, 0);
		NGUITools.SetActive(sp, true);
		sp.transform:FindChild("ItemLabel0"):GetComponent("UILabel").text = playerT.nickname;
		local playerMoney = 0
		if playerT.money ~= nil then
			playerMoney = playerT.money * 0.0001
		end 
		sp.transform:FindChild("ItemLabel1"):GetComponent("UILabel").text =  System.String.Format("{0:###.00}{1}",playerMoney,XMLResource.Instance:Str("mx_bet_unit"));
		
	end

end
function this:ReturnInit()
	NGUITools.SetActive(this._3Layout:FindChild("SYava").gameObject,false);
	
	for i=0,5 do
		local sp=this._2Layout:FindChild("Poker"..i):GetComponent("UISprite");
		sp.spriteName="mx_poker_bg";
		sp.alpha=0.0;
	end
	
	for  i=1,8 do
		if deskinfos[i]~=nil then
			deskinfos[i]:ResetView();
		end
	end

	for i=0,1 do
		NGUITools.SetActive(this._3Layout:FindChild("ChildSource"..i).gameObject,false);
	end
	NGUITools.SetActive (this.mxWaitGameInfo.gameObject, false);
	NGUITools.SetActive (this._4Layout.gameObject, false);
	this:CheckBetButtonEnable (false);
	this.mTimer:SetMaxTime (0);
	canBet = false;
end
function this:StartSendPokerAnim( pokersc)
	local xianPai = {}
	xianPai[1] = pokersc[1];
	xianPai[2] = pokersc[2];
	xianPai[3] = pokersc[3];
	
	local zhuangPai = {};
	zhuangPai[1] = pokersc[4];
	zhuangPai[2] = pokersc[5];
	zhuangPai[3] = pokersc[6];
	
	
	local poker = nil;
	
	for  j=0,3 do
		local k = math.floor((j+1)/2);
	
		if j%2==0 then
			poker=this.pokers["Poker"..k]
			
			poker.transform.localPosition = Vector3.New (-180+k*60, 290, 0);
			poker.Value = (pokersc[k+1]);
		else
			local kk = k+2;
			poker=this.pokers["Poker"..kk]
			poker.Value = (pokersc[kk+1]);
		end
		poker:MoveFrom30M(spRect[1],spRect[2],spRect[3],spRect[4],0.4,j*0.2);
		coroutine.start(this.AfterDoing,this, j*0.15+0.2,function()
				UISoundManager.Instance.PlaySound("ncards");
			end);
	end

	coroutine.start(this.AfterDoing,this, 4 * 0.15 + 0.2, function()
		NGUITools.SetActive(this._3Layout:FindChild("ChildSource0").gameObject,true);

		if  pokersc[3] ~= -1 then
			local xian22 = {};
			xian22[1] = xianPai[1];
			xian22[2] = xianPai[2];
			this._3Layout:FindChild ("ChildSource0"):FindChild ("SourceLabel"):GetComponent("UILabel").text = "闲"..Tools.dianShu (xian22).."点,闲搏牌";

			coroutine.start(this.AfterDoing,this,1.1, function()
				for  n=0,1 do
					poker=this.pokers["Poker"..n]
					local xx = -240+n*60;
					poker.transform.localPosition =  Vector3.New (xx, 290, 0);
				end
			end);

			poker=this.pokers["Poker2"]
			poker:MoveFrom30M(spRect[1],spRect[2],spRect[3],spRect[4],0.4,1.2);
			poker.Value = (pokersc[3]);

			coroutine.start(this.AfterDoing,this,0.15+1.2, function()
				UISoundManager.Instance.PlaySound("ncards");
			end);

		else
			this._3Layout:FindChild ("ChildSource0"):FindChild ("SourceLabel"):GetComponent("UILabel").text = "闲"..Tools.dianShu (xianPai).."点";
		end
	end);

	coroutine.start(this.AfterDoing,this, 4*0.15+2.2,function()
		NGUITools.SetActive(this._3Layout:FindChild("ChildSource1").gameObject,true);
		this._3Layout:FindChild ("ChildSource0"):FindChild ("SourceLabel"):GetComponent("UILabel").text = "闲"..Tools.dianShu (xianPai).."点";
		if  pokersc[6] ~= -1 then
			local zhuang22 = {};
			zhuang22[1] = zhuangPai[1];
			zhuang22[2] = zhuangPai[2];

			this._3Layout:FindChild ("ChildSource1"):FindChild ("SourceLabel"):GetComponent("UILabel").text = "庄"..Tools.dianShu (zhuang22).."点,庄搏牌";

			poker=this.pokers["Poker5"]
			poker:MoveFrom30M(spRect[1],spRect[2],spRect[3],spRect[4],0.4,1.2);
			poker.Value = (pokersc[6]);

			coroutine.start(this.AfterDoing,this,0.15+1.2, function()
				UISoundManager.Instance.PlaySound("ncards");
			end);
		else
			this._3Layout:FindChild ("ChildSource1"):FindChild ("SourceLabel"):GetComponent("UILabel").text = "庄"..Tools.dianShu (zhuangPai).."点";
		end
	end);

	coroutine.start(this.AfterDoing,this, 4*0.15+4.2,function()
		
		this._3Layout:FindChild ("ChildSource0"):FindChild ("SourceLabel"):GetComponent("UILabel").text = "闲"..Tools.dianShu (xianPai).."点";
		this._3Layout:FindChild ("ChildSource1"):FindChild ("SourceLabel"):GetComponent("UILabel").text = "庄"..Tools.dianShu (zhuangPai).."点";
		
		NGUITools.SetActive(this._3Layout:FindChild("SYava").gameObject,true);
		
		if Tools.dianShu (xianPai)>Tools.dianShu (zhuangPai) then
			this._3Layout:FindChild ("SYava"):GetComponent("UISprite").spriteName = "xian";
		elseif Tools.dianShu (xianPai)<Tools.dianShu (zhuangPai) then
			this._3Layout:FindChild ("SYava"):GetComponent("UISprite").spriteName = "zhuang";
		else
			this._3Layout:FindChild ("SYava"):GetComponent("UISprite").spriteName = "he";
		end
	end);
	
end

--请求接收
function this:SocketReceiveMessage (message)

	 local Message = self;
	if  Message then
		--解析json字符串
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];
		--log(Message)
		if "zero" == typeC then
			if "enter" == tag then
			log(Message)
				this:gameEnter(messageObj);
			elseif "come" == tag then
				this:gameCome(messageObj);
			elseif "leave" == tag then
				this:gameLeave(messageObj);
			elseif "waitupdealer" == tag then
				this:gameWaitBankup(messageObj);
			elseif "updealer_fail_nomoney" == tag then
				this:gameBankUpFail(messageObj);
			elseif "updealer" == tag then
				this:gameBankUp(messageObj);
			elseif "downdealer" == tag then
				this:gameBankDown(messageObj);
			elseif "update_dealers" == tag then
				this:gameBankUpdate(messageObj);
			elseif "waitplayerbet" == tag then
				this:gameWaitBet(messageObj);
			elseif "badbet" == tag then
				this:gameBadBet(messageObj);
			elseif "mybet" == tag then
				this:gameMyBet(messageObj);
			elseif "bet" == tag then
				this:gameBet(messageObj);
			elseif "gameover" == tag then
			log(Message)
				this:gameOver(messageObj);
			elseif "freetime" == tag then
				this:gameFreeTime(messageObj);
			end
		end
	end
end
function this:gameEnter(json)
	this:ReturnInit ();
	local winzodics = json ["body"] ["path"];
	paths = {};
	if winzodics  and  #(winzodics) > 0 then
		local jsItem=nil;
		for  key,value in ipairs(winzodics) do 
			--[[jsItem=value;
			table.insert(paths,tonumber(jsItem[1]));
			table.insert(paths,tonumber(jsItem[2]));
			table.insert(paths,tonumber(jsItem[3]));]]
			jsItem=value[1];
			local x_x = -1;
			local z_z = -1;
			local p_p = -1;
			
			if jsItem==0 then
				x_x = 1;
			elseif jsItem == 3 then
				z_z = 1;
			elseif jsItem == 6 then 
				p_p = 1;
			end
				
			table.insert(paths,x_x)
			table.insert(paths,z_z)
			table.insert(paths,p_p)
			
		end
		while #(paths)>30 do
			table.remove(paths, 1);
		end
		Tools.drawPathGrid (this._6Layout:FindChild ("GamePathView"):FindChild ("PathViewGrid"), paths,29);
	end
	
	
	local bealerID = tonumber (json ["body"] ["dealer"]);
	local jsarr = json ["body"] ["members"];
	local step = tonumber (json ["body"] ["step"]);
	
	local player = nil;
	players = {};
	for  i = 1,  #(jsarr) do
		player=GPlayer:New(jsarr[i]);
		players[player.uid] = player;
		if player.uid == tonumber(SocketConnectInfo.Instance.userId) then
			this.player = player;
		end
	end
	
	
	local binfos = json ["body"] ["dealers"];
	bankupInfos = {};
	
	for  i = 1, #(binfos) do
		table.insert(bankupInfos,this:GetPlayer(tonumber(binfos[i][1])));
	end
	this:ResetBakupList ();
	if bealerID ~= 0 then 
		local bealer=this:GetPlayer(bealerID);
		if bealer ~= nil then
			this.banker=bealer;
			this.mxtxtPlyInfo0.text=XMLResource.Instance:Str("mx_label_0")..this.banker.nickname;
		else
			this.mxtxtPlyInfo0.text=XMLResource.Instance:Str("mx_label_0").."玩家";
		end
		
		this.mxtxtPlyInfo1.text=XMLResource.Instance:Str("mx_label_1")..json["body"]["dealer_winlost"];
		this.mxtxtPlyInfo2.text=XMLResource.Instance:Str("mx_label_2")..json["body"]["dealer_times"];
		this.mxtxtPlyInfo3.text=XMLResource.Instance:Str("mx_label_3")..EginUser.Instance.nickname;
		this.mxtxtPlyInfo4.text=XMLResource.Instance:Str("mx_label_4").."0";
		this.mxtxtPlyInfo5.text=XMLResource.Instance:Str("mx_label_5")..json["body"]["mymoney"];
	end
	if step == 0 then 
		this.mxWaitGameInfo.text=XMLResource.Instance:Str("mx_game_waiting");
		NGUITools.SetActive(this.mxWaitGameInfo.gameObject,true);
		this.mTimer:SetMaxTime(0);
		return;
	end
	local timeout = tonumber (json ["body"] ["timeout"]);
	this.mTimer:SetMaxTime (timeout);
	if step == 1 then 
		local mybetMoneys=json["body"]["mybetmoneys"];
		local albetMoneys=json["body"]["betmoneys"];
		for  i=1,8 do
			if deskinfos[i] ~= nil then
				local betmoney=tonumber(mybetMoneys[i]);
				local allMoney=tonumber(albetMoneys[i]);
				local add=allMoney-deskinfos[i].allMoney;
				deskinfos[i]:updateDeskPool_3(jettonPrefab,add,200,this.mxtxtPlyInfo4.gameObject.transform);
				UISoundManager.Instance.PlaySound("nbet",0);
				deskinfos[i].allMoney=allMoney;
				deskinfos[i].betMoney=deskinfos[i].betMoney+betmoney;
				if allMoney>0 then
					deskinfos[i].btextv0.text=System.String.Format("{0:###.00} {1}",allMoney*0.0001,XMLResource.Instance:Str("mx_bet_unit"));
					NGUITools.SetActive(deskinfos[i].btextv0.gameObject,true);
					NGUITools.SetActive(deskinfos[i].btextv0BG.gameObject,true);
				end
				if betmoney>0 then
					deskinfos[i].btextv1.text=deskinfos[i].betMoney.."";
					NGUITools.SetActive(deskinfos[i].btextv1.gameObject,true);
					NGUITools.SetActive(deskinfos[i].btextv1BG.gameObject,true);
				end
			end
		end
		
		this:CheckBetButtonEnable (true);
		canBet = true;
	elseif step==2 then
		this.mxWaitGameInfo.text=XMLResource.Instance:Str("mx_wait_next_start");
		NGUITools.SetActive(this.mxWaitGameInfo.gameObject,true);
	elseif step==3 then
		this.mxWaitGameInfo.text=XMLResource.Instance:Str("mx_wait_ready");
		NGUITools.SetActive(this.mxWaitGameInfo.gameObject,true);
	end
end
function this:gameCome(json)
	player = GPlayer:New(json["body"]);
	players[player.uid] = player;
end
function this:gameLeave(json)
	local leaverID = tonumber (json ["body"]);
	players[leaverID] = nil;
end
function this:gameWaitBankup(json)
	this.mxWaitGameInfo.text = XMLResource.Instance:Str ("mx_wait_bankup");
	NGUITools.SetActive (this.mxWaitGameInfo.gameObject, true);
end
function this:gameBankUpFail(json)
	this.mxErrorToast:Show (2.0, SimpleFrameworkUtilstringFormat(XMLResource.Instance:Str ("mx_updealer_fail_nomoney"),tonumber(json["body"])));
	this:CheckBetButtonEnable (true);
end
function this:gameBankUp(json)
	local uid = tonumber (json ["body"] [1]);
	if uid == tonumber (SocketConnectInfo.Instance.userId) then 
		this.mxBankupChangeButton.spriteName="mx_bakup_btn_c1";
	end
	table.insert(bankupInfos,this:GetPlayer(uid) ) 
	this:ResetBakupList ();
end
function this:gameBankDown(json)
	local uid = tonumber (json ["body"] [1]);
	if uid == tonumber (SocketConnectInfo.Instance.userId) then
		this.mxBankupChangeButton.spriteName="mx_bakup_btn_c0";
	end
	table.remove(bankupInfos,tableKey(bankupInfos,this:GetPlayer(uid)))
	if #(bankupInfos) > 0 then
		local player = bankupInfos[1];
		if this.banker==nil or this.banker.uid ~= player.uid then
			baktime = 0;
			bakWinMoney = 0;
			this.mxtxtPlyInfo0.text = XMLResource.Instance:Str ("mx_label_0")..player.nickname;
			this.mxtxtPlyInfo1.text = XMLResource.Instance:Str ("mx_label_1")..bakWinMoney;
			this.mxtxtPlyInfo2.text = XMLResource.Instance:Str ("mx_label_2")..baktime;
			this:ResetBakupList ();
			this.banker=player;
			this.mxBakupToast:Show (2.0, System.String.Format (XMLResource.Instance:Str ("mx_bakup_label"), player.nickname));
		end
	end
end
function this:gameBankUpdate(json)
	NGUITools.SetActive (this.mxWaitGameInfo.gameObject, false);
	local binfos = json ["body"];
	bankupInfos = {};
	for  i = 1, #(binfos) do
		table.insert(bankupInfos,this:GetPlayer(tonumber(binfos[i][1])));
	end
	local player = bankupInfos[1];
	if this.banker==nil or this.banker.uid ~= player.uid then
		baktime = 0;
		bakWinMoney = 0;
		this.mxtxtPlyInfo0.text = XMLResource.Instance:Str("mx_label_0")..player.nickname;
		this.mxtxtPlyInfo1.text = XMLResource.Instance:Str("mx_label_1")..bakWinMoney;
		this.mxtxtPlyInfo2.text = XMLResource.Instance:Str("mx_label_2")..baktime;
		this:ResetBakupList ();
		this.banker=player;
		this.mxBakupToast:Show (2.0, System.String.Format (XMLResource.Instance:Str ("mx_bakup_label"), player.nickname));
	end
end
function this:gameWaitBet(json)
	local timeout = tonumber (json["body"]["timeout"]);
	NGUITools.SetActive (this.mxWaitGameInfo.gameObject, false);
	NGUITools.SetActive(this._4Layout.gameObject,false);
	this.mTimer:SetMaxTime (timeout);
	this:CheckBetButtonEnable (true);
	canBet = true;
	UISoundManager.Instance.PlaySound ("nstbet");
end
function this:gameBadBet(json)
	local errCode = tonumber (json["body"]);
	local errMsg = nil;
	if errCode == 0 then
		errMsg=XMLResource.Instance:Str("mx_bet_err_0");
	elseif errCode == 1 then 
		errMsg=XMLResource.Instance:Str("mx_bet_err_1");
	elseif errCode == 2 then 
		errMsg=XMLResource.Instance:Str("mx_bet_err_2");
	elseif errCode == 3 then 
		errMsg=XMLResource.Instance:Str("mx_bet_err_3");
	end
	
	if errMsg ~= nil then 
		this.mxErrorToast:Show(1.2,errMsg);
		if errCode==1 or errCode==2 then
			local sp=nil;
			if this.mxbtnBet0.value then
				this.mxbtnBet0.value=false;
				this.mxbtnBet0:GetComponent("BoxCollider").enabled=false;
				sp=this.mxbtnBet0.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=0.2;
			elseif this.mxbtnBet1.value then
				this.mxbtnBet1.value=false;
				this.mxbtnBet1:GetComponent("BoxCollider").enabled=false;
				sp=this.mxbtnBet1.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=0.2;
			elseif this.mxbtnBet2.value then
				this.mxbtnBet2.value=false;
				this.mxbtnBet2:GetComponent("BoxCollider").enabled=false;
				sp=this.mxbtnBet2.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=0.2;
			elseif this.mxbtnBet3.value then
				this.mxbtnBet3.value=false;
				this.mxbtnBet3:GetComponent("BoxCollider").enabled=false;
				sp=this.mxbtnBet3.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=0.2;
			elseif this.mxbtnBet4.value then
				this.mxbtnBet4.value=false;
				this.mxbtnBet1:GetComponent("BoxCollider").enabled=false;
				sp=this.mxbtnBet4.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=0.2;
			elseif this.mxbtnBet5.value then
				this.mxbtnBet5.value=false;
				this.mxbtnBet5:GetComponent("BoxCollider").enabled=false;
				sp=this.mxbtnBet5.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha=0.2;
			end
		else
			this:CheckBetButtonEnable(false);
		end
	end
end
function this:gameMyBet(json)
	local body = json ["body"];

	local betmoney=tonumber(body[1]);
	local allMoney=tonumber(body[3]);
	local index = tonumber (body [2]);
	index=index+1;
	if deskinfos[index] ~= nil then
		local add=allMoney-deskinfos[index].allMoney;
		local mybetPosition = {this.mxbtnBet0.gameObject.transform,
		this.mxbtnBet1.gameObject.transform,
		this.mxbtnBet2.gameObject.transform,
		this.mxbtnBet3.gameObject.transform,
		this.mxbtnBet4.gameObject.transform,
		this.mxbtnBet5.gameObject.transform}
		deskinfos[index]:updateDeskPool_3(jettonPrefab,add,200,mybetPosition);
		UISoundManager.Instance.PlaySound ("nbet");
		deskinfos[index].allMoney=allMoney;
		deskinfos[index].betMoney=deskinfos[index].betMoney+betmoney;
		if allMoney>0 then
			deskinfos[index].btextv0.text=System.String.Format("{0:###.00} {1}",allMoney*0.0001,XMLResource.Instance:Str("mx_bet_unit"));
			NGUITools.SetActive(deskinfos[index].btextv0.gameObject,true);
			NGUITools.SetActive(deskinfos[index].btextv0BG.gameObject,true);
		end
		if betmoney>0 then
			deskinfos[index].btextv1.text=deskinfos[index].betMoney.."";
			NGUITools.SetActive(deskinfos[index].btextv1.gameObject,true);
			NGUITools.SetActive(deskinfos[index].btextv1BG.gameObject,true);
		end
	end
end
function this:gameBet(json)
	NGUITools.SetActive(this._4Layout.gameObject,false);

	local curTime = Tools.CurrentTimeMillis ();
	local body = json ["body"];
	local allMoney = tonumber (body[2]);
	local index = tonumber (body [1]);
	index=index+1;
	if deskinfos [index] ~= nil then
		local add = allMoney - deskinfos [index].allMoney;
		deskinfos[index]:updateDeskPool_3(jettonPrefab,add,200,this.mxtxtPlyInfo4.gameObject.transform);
		if curTime - bettime > 60 then 
			UISoundManager.Instance.PlaySound("nbet");
			bettime=curTime;
		end
		deskinfos [index].allMoney = allMoney;
		deskinfos [index].btextv0.text = System.String.Format ("{0:###.00} {1}", allMoney * 0.0001, XMLResource.Instance:Str ("mx_bet_unit"));
		NGUITools.SetActive(deskinfos[index].btextv0.gameObject,true);
		NGUITools.SetActive(deskinfos[index].btextv0BG.gameObject,true);
	end
	
end
function this:gameOver(json)
	canBet = false;
	local body = json ["body"];
	local timeout = tonumber (body ["timeout"]);
	this.mTimer:SetMaxTime (timeout);
	this:CheckBetButtonEnable (false);
	UISoundManager.Instance.PlaySound ("nspbet");
	baktime=baktime+1;
	local mywin = tonumber (body ["mywin"]);
	plyWinMoney = plyWinMoney +mywin;
	local dealerwin = tonumber (body ["dealer_win"]);
	bakWinMoney = bakWinMoney +dealerwin;
	Tools.SetLabelForColor(this.mxFinalSettle0,dealerwin,"1d7f08","ba4000");
	Tools.SetLabelForColor(this.mxFinalSettle1,mywin,"1d7f08","ba4000");
	local winzodics = body ["win_zodic"];

	if #(winzodics) > 0 then 
		local x_x = -1;
		local z_z = -1;
		local p_p = -1;
		
		--for  i=1,#(winzodics) do
			local v=tonumber(winzodics[1]);
			if v==0 then
				x_x = 1;
			elseif v == 3 then
				z_z = 1;
			elseif v == 6 then 
				p_p = 1;
			end
			
			table.insert(paths,x_x)
			table.insert(paths,z_z)
			table.insert(paths,p_p)
		--end
		while #(paths)>30 do
			table.remove(paths,1)
		end
	end

	local moneys = body ["moneys"];
	for key,value in ipairs(moneys) do
		local jsarr=value;
		local player=this:GetPlayer(tonumber(jsarr[1]));
		if player ~= nil then 
			player.money=tonumber(jsarr[2]);
		end
	end
	local hands = body ["win_hands"];
	local handinfo = nil;
	
	local cards={};
	local longg = 1;
	for key,value in ipairs(hands) do
		handinfo=value;
		
		for  j=1,3 do 
			if #(handinfo) == 3 then
				cards[longg]=tonumber(handinfo[j]);
			elseif #(handinfo) == 2 and j<=2 then
				cards[longg]=tonumber(handinfo[j]);
			else
				cards[longg]=-1;
			end
			longg=longg+1;
		end	
	end
	
	this:StartSendPokerAnim (cards);
	
	coroutine.start(this.AfterDoing,this, 7.0,function()
		local tempPosition = this._0Layout:FindChild ("ChildBakIcon")
		for j=1,8 do
			if deskinfos[j] ~= nil then
				if dealerwin > 0 then
					deskinfos[j]:ResetView_3(tempPosition);
				else
					deskinfos[j]:ResetView_3(this.mxtxtPlyInfo4.gameObject.transform);
				end
			end
		end
		local cplayer=bankupInfos[1];
		this.mxtxtPlyInfo0.text=XMLResource.Instance:Str("mx_label_0")..cplayer.nickname;
		this.mxtxtPlyInfo1.text=XMLResource.Instance:Str("mx_label_1")..bakWinMoney;
		this.mxtxtPlyInfo2.text=XMLResource.Instance:Str("mx_label_2")..baktime;
		this.mxtxtPlyInfo3.text=XMLResource.Instance:Str("mx_label_3")..EginUser.Instance.nickname;
		this.mxtxtPlyInfo4.text=XMLResource.Instance:Str("mx_label_4")..plyWinMoney;
		this.mxtxtPlyInfo5.text=XMLResource.Instance:Str("mx_label_5")..this.player.money;
	end);
	coroutine.start(this.AfterDoing,this, 8.0, function()
		NGUITools.SetActive(this._4Layout.gameObject,true);
		Tools.drawPathGrid (this._6Layout:FindChild ("GamePathView"):FindChild ("PathViewGrid"), paths,29);
	end);
end

function this:gameFreeTime(json)
	this:ReturnInit ();
	local timeout = tonumber (json ["body"]);
	this.mTimer:SetMaxTime (timeout);
	this.mxWaitGameInfo.text = XMLResource.Instance:Str("mx_wait_ready");
	NGUITools.SetActive (this.mxWaitGameInfo.gameObject, true);
end

