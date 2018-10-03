require "GameNN/Tools"
require "GameNN/DeskInfo"
require "GameNN/GPoker"
require "GameNN/UISoundManager"
require "GameNN/ExpsObj"
require "GameNN/MTimer"
require "GameNN/GToast"
require "GameNN/GPlayer"
require "GameNN/NetworkDataPool"

local cjson = require "cjson"

local this = LuaObject:New()
GameXJ = this

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
local nntype = {};
local backGs = {};
local betcount=0;
local AllBetMaxNum = 15;
local havesit= nil;
local userId = tonumber(SocketConnectInfo.Instance.userId);
local xiashuMyNum = 0; 
local xiashuMyArr = {};
local xiashuMyArrHou = {};


--local actNameAry = {"h_tip_", "h_kiss_"}

DeskPoolInfo = LuaObject:New() 
function DeskPoolInfo:New(deskPool,sps, money,  targetposition)
	o = {}	
	setmetatable(o,self)
	self.__index = self
	 o.deskPool = deskPool;
	 o.sps = sps;
	 o.money = money;
	 o.targetposition = targetposition;
	return o
end


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
	this.betTarget=nil;
	
	this.mTimer = nil
	this.mxWaitGameInfo = nil
	this.mxWaitGameInfo_1=nil;
	this.mxBakupToast = nil
	this.mxErrorToast = nil
	this.mBakupListGrid = nil
	this.mxBankupChangeButton = nil
	--this.mxFinalSettle0 = nil
	this.mxFinalSettle1 = nil
	this.own_avatar=nil;
	this.mxFinalSettle2=nil;
	this.own_avatar_2=nil;
	
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
	this._9Layout = nil
	this._10Layout= nil;
	this._11Layout= nil;
	this._13Layout= nil;

	--this.anima = nil
	--this.heartAnima = nil
	--this.count = 0;
	--this.aryIndex = 0;
	
	this.player = nil
	this.banker = nil
	this.pokers = nil
	this.expsObj = nil;
	this.point=0;
	
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
	nntype = nil;
	backGs = nil;
	betcount=0;
	havesit= nil;
	this.sitPlayer = nil
	userId = tonumber(SocketConnectInfo.Instance.userId);
	
	this.networkDataPool =  nil
	this.BetXiaZhu=false;
	this.BetMaxMun=0;
	this.DeskPoolArr = nil;
	
	this.target_00 = nil
	this.target_11 = nil
	this.target_22 = nil
	this.target_0 = nil
	this.target_1 = nil
	this.target_2 = nil
	this.target_ = nil
	this.switchSeatAnima  = nil
	this.wuzuosit = nil
	this.allPlayer = nil
	this.sitPlayer = nil
	this.wuzuoPlayer = nil
	this.liwu_nickname = nil;
	this.liwu_id = nil;
	this.liwu_chouma = nil;
	this.liwu_touxiang = nil;
	this.liwu_1 = nil;
	this.liwu_2 = nil;
	this.liwu_3 = nil;
	this.liwu_4 = nil;
	this.liwu_5 = nil;
	this.liwu_6 = nil;
	this.flower = nil;
	this.house = nil;
	this.xiong = nil;
	this.jiubei = nil;
	this.car = nil;
	this.startmoveposition = nil;
	this.prompt = nil;
	this.prompt_label = nil;
	this.jiantou = nil;
	
	this.wuzuoCount=nil;
	this.win_bg=nil;
	this.lose_bg=nil;
	this.pingju_bg=nil;
	this.dengdaiCount=nil;
	this.CanDengdai=false;
	this.ownBetFlyPosition=nil;
	this.startAnima=nil;
	this.winAnima=nil;
	this.loseAnima=nil;
	
	this.kuang = nil
	this.kuangShow=nil;
	this.time_show=nil;
	
	if this.InvokeLua ~= nil then 
		this.InvokeLua:clearLuaValue();
		this.InvokeLua = nil;
	end
	
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
	this._9Layout = this.transform:FindChild("9Layout");
	this._10Layout= this.transform:FindChild("10Layout");
	this._11Layout= this.transform:FindChild("11Layout");
	this._13Layout= this.transform:FindChild("13Layout");

	--荷官动画控制
	--this.anima = this._0Layout:FindChild("HeguanAnimaPrb").gameObject:GetComponent("UISpriteAnimation");
	--this.heartAnima = this._0Layout:FindChild("HeguanAnimaPrb/heart").gameObject:GetComponent("Animator");
	--this.count = 0;
	--this.aryIndex = 0;

	
	this.mxBackButton = this.transform:FindChild("0Layout/ChildButton0").gameObject:GetComponent("UISprite");
	this.mxSettButton = this.transform:FindChild("0Layout/ChildButton4").gameObject:GetComponent("UISprite");
	this.mxBakupButton = this.transform:FindChild("0Layout/ChildButton1").gameObject:GetComponent("UISprite")
	this.mxBakluButton = this.transform:FindChild("0Layout/ChildButton2").gameObject:GetComponent("UISprite")
	this.mxNoSitButton = this.transform:FindChild("0Layout/ChildButton3").gameObject:GetComponent("UISprite")
	
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
	this.betTarget=this.transform:FindChild("0Layout/ChildButton4").gameObject;--无座玩家实例化筹码位置
	
	local timergameobj =  this.transform:FindChild("0Layout/ChildTimer").gameObject--倒计时
	this.time_show=timergameobj.transform:FindChild("TimerBG_tishi").gameObject:GetComponent("UISprite");
	this.mTimer = MTimer:New(timergameobj);
	
	this.mxWaitGameInfo = this.transform:FindChild("3Layout/ChildTipLabel").gameObject
	this.mxWaitGameInfo_1 = this.transform:FindChild("3Layout/ChildTipLabel/ChildTipLabel").gameObject:GetComponent("UISprite")
	this.mxBakupToast = GToast:New(this.transform:FindChild("3Layout/GameToastBakup").gameObject)
	
	this.mxErrorToast = GToast:New(this.transform:FindChild("3Layout/GameToastError").gameObject)
	
	this.mBakupListGrid = this.transform:FindChild("5Layout/BakupList/BakupListView/UIGrid").gameObject:GetComponent("UIGrid")
	this.mxBankupChangeButton =  this.transform:FindChild("5Layout/BakupList/BakupButton").gameObject:GetComponent("UISprite")
	--this.mxFinalSettle0 = this.transform:FindChild("4Layout/win/LayoutLabel0").gameObject:GetComponent("UILabel")
	this.mxFinalSettle1 = this.transform:FindChild("4Layout/win/LayoutLabel1").gameObject:GetComponent("UILabel")
	this.own_avatar=this.transform:FindChild("4Layout/win/panel/Sprite_1").gameObject:GetComponent("UISprite")  --结算界面头像
	this.mxFinalSettle2=this.transform:FindChild("4Layout/lose/LayoutLabel1").gameObject:GetComponent("UILabel");
	this.own_avatar_2=this.transform:FindChild("4Layout/lose/panel/Sprite_1").gameObject:GetComponent("UISprite")  --结算界面头像;
	
	this.mxSettBGBar = this.transform:FindChild("7Layout/GameSettView/SettViewSBar0").gameObject:GetComponent("UISlider")
	this.mxSettEFBar = this.transform:FindChild("7Layout/GameSettView/SettViewSBar1").gameObject:GetComponent("UISlider")
	
	this.point=0;
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
	nntype = {};
	backGs = {};
	betcount=0;
	havesit= nil;
	userId = tonumber(SocketConnectInfo.Instance.userId);
	this.sitPlayer = {};
	
	this.pokers = {};
	for i = 0,8 do 
		this.pokers["Poker"..i] = GPoker:New(this._2Layout:FindChild("Poker"..i).gameObject)
	end
	this.expsObj = {};
	
	this.networkDataPool = NetworkDataPool:New();
	this.BetXiaZhu=false;
	this.BetMaxMun=0;
	this.DeskPoolArr = {};
	
	this.target_0 = {};
	for i = 1,6 do 
		table.insert(this.target_0,this.transform:FindChild("1Layout/BetDesk0/target_"..i));
	end
	this.target_1 = {};
	for i = 1,6 do 
		table.insert(this.target_1,this.transform:FindChild("1Layout/BetDesk1/target_"..i));
	end
	this.target_2 = {};
	for i = 1,6 do 
		table.insert(this.target_2,this.transform:FindChild("1Layout/BetDesk2/target_"..i));
	end
	this.target_ = {
		this.transform:FindChild("1Layout/BetDesk0/target_0"),
		this.transform:FindChild("1Layout/BetDesk1/target_0"),
		this.transform:FindChild("1Layout/BetDesk2/target_0"),
	};
	
	this.target_00 = this.transform:FindChild("1Layout/BetDesk0/target_00")
	this.target_11 = this.transform:FindChild("1Layout/BetDesk1/target_00")
	this.target_22 = this.transform:FindChild("1Layout/BetDesk2/target_00")
	
	this.switchSeatAnima = ResManager:LoadAsset("gamexj/prefab","switchSeatAnima"); 
	this.wuzuosit = {};
	for i = 1,10 do 
		table.insert(this.wuzuosit,this.transform:FindChild("9Layout/GameExitView/list_panel/wuzuo_"..i).gameObject);
	end
	
	this.allPlayer = {};
	this.sitPlayer = {};
	this.wuzuoPlayer = {};
	this.liwu_nickname = this.transform:FindChild("13Layout/GameSettView/SettViewBG0/Nickname/Name_1").gameObject:GetComponent("UILabel");
	this.liwu_id = this.transform:FindChild("13Layout/GameSettView/SettViewBG0/ID/ID_name_1").gameObject:GetComponent("UILabel");
	this.liwu_chouma = this.transform:FindChild("13Layout/GameSettView/SettViewBG0/Chouma/Chouma_name_1").gameObject:GetComponent("UILabel");
	this.liwu_touxiang = this.transform:FindChild("13Layout/GameSettView/SettViewBG0/touxiangPanel/Touxiang").gameObject:GetComponent("UISprite");
	
	this.liwu_1 = ResManager:LoadAsset("gamexj/liwu","liwu_1");
	this.liwu_2 = ResManager:LoadAsset("gamexj/liwu","liwu_2");
	this.liwu_3 = ResManager:LoadAsset("gamexj/liwu","liwu_3");
	this.liwu_4 = ResManager:LoadAsset("gamexj/liwu","liwu_4");
	this.liwu_5 = ResManager:LoadAsset("gamexj/liwu","liwu_5");
	this.liwu_6 = ResManager:LoadAsset("gamexj/liwu","liwu_6");
	this.flower = ResManager:LoadAsset("gamexj/liwu","flower");
	this.house = ResManager:LoadAsset("gamexj/liwu","house");
	this.xiong = ResManager:LoadAsset("gamexj/liwu","xiong");
	this.jiubei = ResManager:LoadAsset("gamexj/liwu","jiubei");
	this.car = ResManager:LoadAsset("gamexj/liwu","car");
	this.startmoveposition = this.transform:FindChild("10Layout/targetPosition");
	this.prompt = this.transform:FindChild("3Layout/PromptMessage").gameObject;
	this.prompt_label = this.transform:FindChild("3Layout/PromptMessage/ToastLabel").gameObject:GetComponent("UILabel");
	this.jiantou = ResManager:LoadAsset("gamexj/prefab","youzuo_1");
	
	this.wuzuoCount=this._0Layout.transform:FindChild("wuzuoCount/count").gameObject:GetComponent("UILabel");
	this.win_bg=this._4Layout.transform:FindChild("win").gameObject;
	this.lose_bg=this._4Layout.transform:FindChild("lose").gameObject;
	this.pingju_bg=this._4Layout.transform:FindChild("pingju").gameObject;
	this.dengdaiCount=this.pingju_bg.transform:FindChild("chip").gameObject:GetComponent("UILabel");
	
	xiashuMyArr = {[0]=0,[1]=0,[2]=0,[3]=0};
	xiashuMyArrHou ={[0]=0,[1]=0,[2]=0,[3]=0};
	this.DeskBetArr ={[0]=0,[1]=0,[2]=0,[3]=0};
	
	this.mybetNum = 0;
	this.betNumAll = 0;
	this.CanDengdai=false;
	this.ownBetFlyPosition=this._0Layout.transform:FindChild("nickname_bg");
	
	this.startAnima=this._0Layout.transform:FindChild("animator_1").gameObject;
	this.winAnima=this.win_bg.transform:FindChild("animator").gameObject;
	this.loseAnima=this.lose_bg.transform:FindChild("animator").gameObject;
	
	this.kuang = {
		this.transform:FindChild("3Layout/Shuyingkuang/Kuang_1").gameObject:GetComponent("UISprite"),
		this.transform:FindChild("3Layout/Shuyingkuang/Kuang_2").gameObject:GetComponent("UISprite"),
		this.transform:FindChild("3Layout/Shuyingkuang/Kuang_3").gameObject:GetComponent("UISprite")
	};
	this.kuangShow={false,false,false};
	
	this.InvokeLua = InvokeLua:New(this);
	
	this.Module_RechargeLua = Module_Recharge;
	if (Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer) then
		if(PlatformGameDefine.playform.IOSPayFlag)then
			this.Module_Recharge = ResManager:LoadAsset("happycity/Module_Recharge","Module_Recharge")
		else
			this.Module_Recharge = ResManager:LoadAsset("happycity/Module_Recharge_iOS","Module_Recharge_iOS")
			this.Module_RechargeLua = Module_Recharge_iOS;
		end
	else
		this.Module_Recharge = ResManager:LoadAsset("happycity/Module_Recharge","Module_Recharge")
	end
end
function this:Awake()
	log("------------------awake of GameXJZPanel")
	this:Init();
	
	--------初始化UISoundManager-------------
	UISoundManager.Init(this.gameObject);
	--添加背景音乐资源
	UISoundManager.AddAudioSource("GameXJ/sound","bg",true);
	--添加音效资源
	UISoundManager.AddAudioSource("gamenn/gamebr","nbet");
	UISoundManager.AddAudioSource("gamenn/gamebr","ncards");
	UISoundManager.AddAudioSource("gamenn/gamebr","nplos");
	UISoundManager.AddAudioSource("gamenn/gamebr","npwin");
	UISoundManager.AddAudioSource("gamenn/gamebr","nspbet");
	UISoundManager.AddAudioSource("gamenn/gamebr","nstbet");
	UISoundManager.AddAudioSource("gamexj/sound","fanpaiAction"); 
	
	----------绑定按钮事件--------
	this.mono:AddClick(this._0Layout:FindChild("ChildButton0").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildButton1").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildButton2").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildButton3").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildButton4").gameObject, this.OnButtonClick,this);
	
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton0").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton1").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton2").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton3").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton4").gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildRidButton5").gameObject, this.OnClickBetChange,this);
	
	this.mono:AddClick(this._1Layout:FindChild("BetDesk0").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk1").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk2").gameObject, this.OnBetButtonClick,this);

	
	this.mono:AddClick(this._5Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddClick(this._6Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddClick(this._7Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddClick(this._4Layout:FindChild("win/AMarkBG").gameObject, this.CloseMarkView_1,this);
	this.mono:AddClick(this._4Layout:FindChild("lose/AMarkBG").gameObject, this.CloseMarkView_1,this);
	
	
	this.mono:AddClick(this._5Layout:FindChild("BakupList/BakupButton").gameObject, this.OnButtonClick,this);
	
	this.mono:AddClick(this._8Layout:FindChild("GameExitView/ExitViewButton0").gameObject, this.CloseGame,this);
	this.mono:AddClick(this._8Layout:FindChild("GameExitView/ExitViewButton1").gameObject, this.CloseExitView,this);
	
	this.mono:AddSlider(this.mxSettBGBar, this.OnSoundBarChanged);
	this.mono:AddSlider(this.mxSettEFBar, this.OnSoundBarChanged);
	
	--座位按钮
	for i = 0,6 do 
		local sit = this._10Layout:FindChild("sit_"..i).gameObject;
		this.mono:AddClick(sit, this.OnChangeSit,this);
	end
	--无座玩家头像
	for key,value in ipairs(this.wuzuosit)  do 
		this.mono:AddClick(value, this.OnChangeSit,this);
	end
	--上一页下一页
	this.mono:AddClick(this._9Layout:FindChild("GameExitView/up").gameObject, this.OnPageMinus,this);
	this.mono:AddClick(this._9Layout:FindChild("GameExitView/down").gameObject, this.OnpageAdd,this);
	
	--礼物按钮
	for i = 1,6 do 
		this.mono:AddClick(this._13Layout:FindChild("GameSettView/SettViewBG0/Liwu_"..i).gameObject, this.OnSendGift,this);
	end
	
	local btn_AddMoney = this._11Layout.transform:FindChild("GameExitView/ExitViewButton1").gameObject
	this.mono:AddClick(btn_AddMoney, this.OnAddMoney); 
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
	coroutine.start(this.UpdatePool);
	coroutine.start(this.UpdateBet);
	--coroutine.start(this.UpdateReceiveMessage);
	
	
	--开启音乐
	UISoundManager.Start(true);
	
	this.HeGuanSNum = Vector3.New(1,1,1)

	--开启荷官动画
	--this.InvokeLua:InvokeRepeating("heguanHeartbeat",this.heguanHeartbeat, 1,1); 
	--this.anima:Pause();
	
end

local isSoundV = 0;
function this:UpdateBet()

	while this.gameObject do 
		if canBet then
			for i = 0,3 do
				if  this.DeskBetArr[isSoundV] > 0  then 
					this.mono:SendPackage(cjson.encode({type="xiaojiu",tag="bet",body={isSoundV,this.DeskBetArr[isSoundV]}})); 
					 this.DeskBetArr[isSoundV] = 0;  
					 break; 
				end
				isSoundV=isSoundV+1
				if isSoundV == 4 then
					isSoundV = 0
				end
			end 
		end 
		coroutine.wait(0.2);
	end
end 
local isSoundV = false;
function this:UpdatePool()

	while this.gameObject do 
		if  this.DeskPoolArr[1] ~= nil   then 
			if isSoundV then 
				isSoundV = false;
				local tempRun = function()
					UISoundManager.Instance.PlaySound("nbet");
				end 
				coroutine.start(this.AfterDoing,this,0.25,tempRun);
			else
				isSoundV = true;
			end 
			local tempNumPool = #(this.DeskPoolArr)/6
			if tempNumPool <3 then
				tempNumPool = 3;
			end
			tempNumPool = math.ceil(tempNumPool);
			for i = tempNumPool,1 ,-1 do
				if  this.DeskPoolArr[i] ~= nil   then
					this.DeskPoolArr[i].deskPool:updateDeskPool_5(this.DeskPoolArr[i].sps, this.DeskPoolArr[i].money, this.DeskPoolArr[i].targetposition);  
					table.remove(this.DeskPoolArr,i)
				end
			end 
		end	
		coroutine.wait(0.1);
	end
end 
function this:Update()

	while this.gameObject do
		if this.mTimer ~=nil then
			this.mTimer:Update();
			if this.CanDengdai then
				this.dengdaiCount.text=tostring(math.floor(this.mTimer.endTime));
				if this.dengdaiCount.text=="0" then
					this.lose_bg:SetActive(false);
				end
			end
		end
		this.BetMaxMun=0;
		coroutine.wait(0.1);
	end
end
function this:OnDestroy()
	log("--------------------ondestroy of GameXJPanel")
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
	local rp = nil;
	local tf = nil;
	local go = nil;
	local localScale = Vector3.zero;
	local x = 0
	local y = 0
	local w = 0
	local h = 0;
	--[[]]
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
	--spRect [1] = -this.ScreenW * 0.372;
	spRect [1] = 0;
	--spRect [2] = this.ScreenH * 0.5 - this.TargetH * 0.192;
	spRect [2] = 0;
	
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

	--各个筹码的显示位置
	tf = this._1Layout:FindChild("BetDesk0");
	--log(tf.gameObject.name.."========1");
	deskinfos[1] = DeskInfo:New(tf.gameObject,"xj");
	x = -this.ScreenW * 0.5 + offset * 0.5 + w * 0.5;
	this:ResetSizeTransform (tf, x, y, w, h);
	
	tf = this._1Layout:FindChild("BetDesk1");
	--log(tf.gameObject.name.."========2");
	deskinfos[2] = DeskInfo:New(tf.gameObject,"xj");
	x = x + offset + w;
	this:ResetSizeTransform (tf, x, y-75, w, h);
	
	tf = this._1Layout:FindChild("BetDesk2");
	--log(tf.gameObject.name.."========1");
	deskinfos[3] = DeskInfo:New(tf.gameObject,"xj");
	x = x + offset + w;
	this:ResetSizeTransform (tf, x, y, w, h);
	




	--下注的筹码图片	
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

	--初始化对象池 
	deskinfos[1]:InitObject(jettonPrefab[1].gameObject); 
	deskinfos[2]:InitObject(jettonPrefab[1].gameObject); 
	deskinfos[3]:InitObject(jettonPrefab[1].gameObject); 
	
	deskinfos[1]:SetWuParticle(this.transform:FindChild("0Layout/ChildButton3/GameObject/testCoinPtPrb0/testCoinParticles").gameObject:GetComponent("ParticleSystem"))
	deskinfos[2]:SetWuParticle(this.transform:FindChild("0Layout/ChildButton3/GameObject/testCoinPtPrb1/testCoinParticles").gameObject:GetComponent("ParticleSystem"))
	deskinfos[3]:SetWuParticle(this.transform:FindChild("0Layout/ChildButton3/GameObject/testCoinPtPrb2/testCoinParticles").gameObject:GetComponent("ParticleSystem"))
	
	
	w = this.ScreenW * 0.06771 --0.0552;
	h = this.TargetH * 0.16667 --0.14;
	x = -this.ScreenW * 0.0171875;--0.36;--
	y = this.ScreenH * 0.463 - h * 1;

	--[[
	rp = this._2Layout:FindChild ("Poker0"):GetComponent ("UISprite");
	this.pokers["Poker0"] = GPoker:New(this._2Layout:FindChild("Poker0").gameObject)
	this:ResetSize_1 (rp, x, y, w, h);
	for  i=1, 7 do 
		go = GameObject.Instantiate (rp.gameObject);
		sp = go:GetComponent ("UISprite");
		localScale = go.transform.localScale;
		go.transform.parent = rp.transform.parent;
		go.transform.localScale = localScale;
		go.name="Poker"..i;
		sp.depth=rp.depth+i;
		this.pokers["Poker"..i] = GPoker:New(go)
	end
	
	for i = 0,25 do 
		
	end
	for  i=0, 1 do 
		sp=this._2Layout:FindChild("Poker"..i):GetComponent("UISprite");
		--log(x.."==x=="..y.."==y=="..w.."===w==="..h.."===h");
	   --  -568.32==x==451.296==y==105.984===w134.4===h
		this:ResetSize_1(sp,x+w*0.5*i,y,w,h);
	end
	
	--w = this.TargetH * 0.12 * 1.2;
	--h = this.TargetH * 0.17 * 1.2;
	x = -this.ScreenW * 0.365 + w * 0.5;--这里加了120   0.4853f
	y = -this.ScreenH * 0.176 - h * 0.5;
	
	for  i=0, 5 do 
		sp=this._2Layout:FindChild("Poker"..(i+2)):GetComponent("UISprite");
		this:ResetSize_1(sp,x+w*0.5*i,y,w,h);
		if i%2 == 1 then
			x= x+this.ScreenW*0.24;
		end
	end	
	]]

	tf = this._3Layout:FindChild ("ChildSource0");
	w = this.ScreenW * 0.224;
	h = this.TargetH * 0.0874;
	x = -this.ScreenW * 0.5 + w * 1.25;
	y = this.ScreenH * 0.5 - this.TargetH*0.11;
	this:ResetSizeTransform (tf, x, y, w, h);

	w = this.ScreenW * 0.224;-- 0.224
	h = this.TargetH * 0.142;
	x = -this.ScreenW * 0.5 + this.ScreenW * 0.018 + this.ScreenW * 0.28 * 0.5;
	y = -this.ScreenH * 0.12 - this.TargetH * 0.17;
	tf = this._3Layout:FindChild ("ChildSource1");
	x = x + w * 0;
	this:ResetSizeTransform (tf, x, y, w, h);

	tf = this._3Layout:FindChild ("ChildSource2");
	x = x + this.ScreenW * 0.026 + this.ScreenW * 0.3;
	this:ResetSizeTransform (tf, x , y, w, h);

	tf = this._3Layout:FindChild ("ChildSource3");
	x = x + this.ScreenW * 0.026 + this.ScreenW * 0.3;
	this:ResetSizeTransform (tf, x , y, w, h);

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
	--tf.localPosition = position;

	local pathprefab=this._6Layout:FindChild("GamePathView"):FindChild("ZPathIcon"):GetComponent("UISprite");
	local  pathParent = this._6Layout:FindChild ("GamePathView"):FindChild ("PathViewGrid");
	Tools.initPathGrid (pathParent, pathprefab,Vector3.New(-475, 70, 0),-120,120,29,3,2);
	
	nntype = {
	 [0] = "0点",
	 [1] = "1点",
	 [2] = "2点",
	 [3] = "3点",
	 [4] = "4点",
	 [5] = "5点",
	 [6] = "6点",
	 [7] = "7点",
	 [8] = "8点",
	 [9] = "9点",
	 [10] = "豹子"
	 }
	backGs[1] = "xj_downmen";
	backGs[2] = "xj_skymen";
	backGs[3] = "xj_upmen";
	this.mxSettBGBar.value=SettingInfo.Instance.bgVolume;
	this.mxSettEFBar.value=SettingInfo.Instance.effectVolume;
	this:CheckBetButtonEnable (false);
	--this.mxWaitGameInfo.text = XMLResource.Instance:Str ("mx_wait_ready");
	--NGUITools.SetActive (this.mxWaitGameInfo.gameObject, true);
	if string.find(SocketConnectInfo.Instance.roomTitle,System.Text.RegularExpressions.Regex.Unescape("\\u521d\\u7ea7")) then
		isPrimary =  true;
	else
		isPrimary = false;
	end
	this:ResetDeskAva ();
end

function this:ResetSizeTransform( tf, x, y, w, h)
	--[[
	local  collider = tf:GetComponent("BoxCollider");
	local size = collider.size;
	local news = Vector3.zero;
	news.x = w / size.x;
	news.y = h / size.y;
	tf.localScale = news;
	tf.localPosition = Vector3.New (x, y, 0);
	]]
end
function this:ResetSize(uw, x, y, w, h)
	--uw.transform.localPosition = Vector3.New (x, y, 0);
	--uw.width = tonumber(w);
	--uw.height =tonumber (h);
end
function this:ResetSize_1(uw, x, y, w, h)
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
	--if  toggle ~= this.mxbtnBet0 then this.mxbtnBet0.value=false; end
	--if toggle ~= this.mxbtnBet1 then this.mxbtnBet1.value=false; end
	--if toggle ~= this.mxbtnBet2 then this.mxbtnBet2.value=false; end
	--if toggle ~= this.mxbtnBet3 then this.mxbtnBet3.value=false; end
	--if toggle ~= this.mxbtnBet4 then this.mxbtnBet4.value=false; end
	--if toggle ~= this.mxbtnBet5 then this.mxbtnBet5.value=false; end
	if toggle ~= this.mxbtnBet0 then   
		this.mxbtnBet0.value = false; 
		this.mxbtnBet0.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
	else
		this.mxbtnBet0.value = true; 
		this.mxbtnBet0.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 1; 
	end
	
	if toggle ~= this.mxbtnBet1 then  
		this.mxbtnBet1.value = false; 
		this.mxbtnBet1.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
	else
		this.mxbtnBet1.value = true; 
		this.mxbtnBet1.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 1; 
	end
	
	if toggle ~= this.mxbtnBet2 then  
		this.mxbtnBet2.value = false; 
		this.mxbtnBet2.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0;
	else
		this.mxbtnBet2.value = true; 
		this.mxbtnBet2.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 1; 
	end
	
	if toggle ~= this.mxbtnBet3 then 
		this.mxbtnBet3.value = false; 
		this.mxbtnBet3.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
	else
		this.mxbtnBet3.value = true; 
		this.mxbtnBet3.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 1; 
	end
	
	if toggle ~= this.mxbtnBet4 then
		this.mxbtnBet4.value = false; 
		this.mxbtnBet4.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
	else
		this.mxbtnBet4.value = true; 
		this.mxbtnBet4.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 1; 
	end
	--if tarToggle == toggle then
		--toggle.value=true;
		--return;
	--end

	if this.mxbtnBet0.value  then 
		selectMoney = 100;
	elseif this.mxbtnBet1.value  then
		selectMoney = 500;
	elseif this.mxbtnBet2.value then 
		selectMoney = 1000;
	elseif this.mxbtnBet3.value then
		selectMoney = 10000;
	elseif this.mxbtnBet4.value then
		selectMoney = 100000;
	elseif this.mxbtnBet5.value then
		selectMoney = 100000;
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
			
			this.mxbtnBet0.value=true;
			this:OnClickBetChange(this.mxbtnBet0.gameObject);
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
		this.mxbtnBet0.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
		this.mxbtnBet1.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
		this.mxbtnBet2.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
		this.mxbtnBet3.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
		this.mxbtnBet4.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 
		this.mxbtnBet5.gameObject.transform:FindChild("ButtonBG1"):GetComponent("UISprite").alpha = 0; 


		
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
		
	if selectMoney ~= 0 and  not this.mxErrorToast.Toast3 then
		local index = 0;
		for  i = 1, 3 do
			if target == deskinfos[i].gameObject then
				index = i-1;
				break;
			end
		end
		--if this.bai:GetComponent("UISprite").alpha == 0 and this.qian:GetComponent("UISprite").alpha == 0 and this.wan:GetComponent("UISprite").alpha == 0 and this.shiwan:GetComponent("UISprite").alpha == 0 and this.baiwan:GetComponent("UISprite").alpha == 0 then
			--canbet = false;
		--else
		
			canbet = true;
		--end
		if canbet then 
			 
			local isxiazhu = true
			if this.banker  ~= nil then 
				if tostring(SocketConnectInfo.Instance.userId) ==  tostring( this.banker.uid)  then 
					this.mxErrorToast:Show(1.5,"上庄中,无法下注!");
					isxiazhu = false
				end  
			end 
			if isxiazhu then
				--东南西北0123 
				if this.player.money >= tonumber(selectMoney) then  
					this:MybetSendPackage(index,selectMoney) 
				else
					--金钱不足
					this.mxErrorToast:Show(1.5,"余额不足,无法下注!");
				end 
			end 
		end
	end
end

function this:MybetSendPackage(index,selectMoney,arrxia)
	this.DeskBetArr[index] = this.DeskBetArr[index]+selectMoney
	
	selectMoney = tonumber(selectMoney);
	if math.floor(this.mTimer.endTime) >0 then 
		xiashuMyNum=xiashuMyNum+1;
		this:gameMyBetC(index,selectMoney,deskinfos[index+1].allMoney+selectMoney,arrxia)  
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
	elseif target==this.mxNoSitButton.gameObject   then
		NGUITools.SetActive(this._9Layout.gameObject,true);
		this:wuzuoShow();
	elseif target==this.mxBankupChangeButton.gameObject then 
		if  not canBet then 
			local sdat=nil;
			if "shangzhuang" == this.mxBankupChangeButton.spriteName then
				sdat = {type="xiaojiu",tag="updealer"};   
			else
				sdat = {type="xiaojiu",tag="downdealer"};   
			end
			local jsonStr = cjson.encode(sdat);
			this.mono:SendPackage(jsonStr);
		else
			if "shangzhuang"==this.mxBankupChangeButton.spriteName then
				this.mxErrorToast:Show(1.2,XMLResource.Instance:Str("mx_err_game_beting"));
			else
				this.mxErrorToast:Show(1.2,XMLResource.Instance:Str("mx_err_game_xiazhuang"));
			end	
			--this.mxErrorToast:Show(1.2,XMLResource.Instance:Str("mx_err_game_beting"));
		end
	end
end

function this:ShowBakupListAnim( show)
	--local  tf = this._5Layout:FindChild ("BakupList");
	--local position = tf.localPosition;
	--local tableC = iTween.Hash ("y",1320,"islocal",true,"time",0.5)
	
	if show then
		NGUITools.SetActive (this._5Layout.gameObject, true);
		--iTween.MoveFrom(tf.gameObject,tableC);
	else
		--iTween.MoveTo(tf.gameObject, tableC);
		--coroutine.start(this.AfterDoing,this, 0.5,function()
			NGUITools.SetActive(this._5Layout.gameObject,false);
			--tf.localPosition=position;
		--end);
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

function this:CloseMarkView_1()
	this.win_bg:SetActive(false);
	this.lose_bg:SetActive(false);
	this.pingju_bg:SetActive(true);
	this.CanDengdai=true;	
end


function this:CloseGame()
	this:OnClickBack();
end

function this:ResetBakupList()

	for  i = 0,this.mBakupListGrid.transform.childCount-1 do
		destroy(this.mBakupListGrid.transform:GetChild(i).gameObject);
	end
	
	local scrollview=this.mBakupListGrid.transform.parent:GetComponent("UIScrollView");
	scrollview:ResetPosition();
	
	local prefab = this.mBakupListGrid.transform.parent:FindChild("ListViewItem").gameObject;
	local localScale = prefab.transform.localScale;
	
	local i = 0;
	for  key,playerT in ipairs(bankupInfos) do
		local sp = GameObject.Instantiate(prefab);
		sp.transform.parent = this.mBakupListGrid.transform;
		sp.transform.localScale = localScale;
		sp.transform.localPosition = Vector3.New(0, -(key-1) * 90, 0);
		NGUITools.SetActive(sp, true);
		sp.transform:FindChild("ItemLabel0"):GetComponent("UILabel").text = playerT.nickname;
		sp.transform:FindChild("Touxiang"):GetComponent("UISprite").spriteName="avatar_"..playerT.avatar;
		local playerMoney = 0
		if playerT.money ~= nil then
			playerMoney = playerT.money * 0.0001
		end 
		sp.transform:FindChild("ItemLabel1"):GetComponent("UILabel").text =  System.String.Format("{0:###.00}{1}",playerMoney,XMLResource.Instance:Str("mx_bet_unit"));
		
	end

end

function this:ReturnInit()
	for i=0,8 do
		local sp=this._2Layout:FindChild("Poker"..i):GetComponent("UISprite");
		sp.spriteName="mx_poker_bg";
		sp.alpha=0.0;
	end
	
	
	for i=0,3 do
		NGUITools.SetActive(this._3Layout:FindChild("ChildSource"..i).gameObject,false);
	end
	this.mxWaitGameInfo.gameObject:SetActive(false);
	--NGUITools.SetActive (this._4Layout.gameObject, false);
	this.win_bg:SetActive(false);
	this.lose_bg:SetActive(false);
	this.pingju_bg:SetActive(false);
	if this.winAnima.activeSelf then
		this.winAnima:SetActive(false);
	end
	if this.loseAnima.activeSelf then
		this.loseAnima:SetActive(false);
	end
	this.CanDengdai=false;
	this:CheckBetButtonEnable (false);
	this.mTimer:SetMaxTime (0);
	canBet = false;
end

function this:ResetDeskAva()
	for i=1,3 do
		deskinfos[i].bgound.spriteName=backGs[i];
	end
end

function this:StartSendPokerAnim(pokersc)
	--[[
	local poker = nil;
	local v=0;
	for  i=0,1 do
		for j=0,7,2 do
			local d=v;
			v=v+1;
			poker=this.pokers["Poker"..(i+j)]
			poker.Value=pokersc[i+j+1];
			poker:MoveFrom(spRect[1],spRect[2],spRect[3],spRect[4],0.4,d*0.2);
			coroutine.start(this.AfterDoing,this, d*0.2+0.2,function()
				UISoundManager.Instance.PlaySound("ncards");
			end);
		end
	end
	]]
	local spobj = this._2Layout:FindChild("GameObject").gameObject;
	iTween.MoveTo(spobj,iTween.Hash ("x",-48,"islocal",true,"time",0.9,"easeType", iTween.EaseType.linear));  
	iTween.MoveTo(spobj,iTween.Hash ("x",0,"islocal",true,"time",0.7,"easeType", iTween.EaseType.linear,"delay",1.1));  
	local sp = spobj.transform:FindChild("Poker (1)"):GetComponent("UISprite");
	--local scaleVec3 =Vector3.New(  math.abs(spRect[3] / sp.width),  math.abs(spRect[4] / sp.height), 0);
	--local scaleVec3 =Vector3.New(0.9,0.9,0);
	local scaleVec3 =Vector3.one;
	for  j = 1,8 do
		local go = spobj.transform:FindChild("Poker ("..j..")"):GetComponent("UISprite");
		go.alpha=1.0;  
		go.transform.localScale = scaleVec3; 
		
		iTween.MoveTo(go.gameObject,iTween.Hash ("x",j*12,"islocal",true,"time",0.9,"easeType", iTween.EaseType.linear));  
		iTween.MoveTo(go.gameObject,iTween.Hash ("x",0,"islocal",true,"time",0.7,"easeType", iTween.EaseType.linear,"delay",1.1));  
	end 
	local flyTime = 0.25
	local tempRun = function() 
		
		local v  = 0;
		for  i = 1, 2 do
			for  j = 0, 7, 2 do
				local d = v;
				v = v+1;
				local poker = this.pokers["Poker"..(i + j)]; 
				poker.Value = pokersc[(i - 1) + j+1];
				poker.gameObject:GetComponent("UISprite").spriteName = "mx_poker_bg";
				
				local tempTime = poker:MoveFromNew(spRect[1], spRect[2], spRect[3], spRect[4], flyTime, d * 0.2);
				
				 
				local tempI = i  
				coroutine.start(this.AfterDoing,this, tempTime-0.05, function ()   
					if (tempI - 1) == 4 then
						--poker.gameObject:GetComponent("UISprite").spriteName = "mx_poker_bg";
					else
						--poker.gameObject:GetComponent("UISprite").spriteName = Define.NN_POKER_TYP[poker.Value+1];
					end
				end); 
				coroutine.start(this.AfterDoing,this, tempTime-0.1, function ()    
					UISoundManager.Instance.PlaySound("fanpaiAction"); 
				end); 
				coroutine.start(this.AfterDoing,this, tempTime-flyTime+0.02 ,  function ()   
					local go = spobj.transform:FindChild("Poker ("..(i + j)..")"):GetComponent("UISprite");
					go.alpha=0.0;  
				end);
			end
		end
	end
	--各个牌型的显示
	coroutine.start(this.AfterDoing,this,2.3,tempRun);
	return 2.3+0.2*7+flyTime;
end

function this:ScaleChangePokerAnim()
	local poker = nil;
	local v = 0;
	for i=0,1 do
		poker=this.pokers["Poker"..(i+1)]
		poker:ScaleChange(0.6,v);
		v=v+0.01;
	end
	v=v+1;
	for  i=2,7 do
		poker=this.pokers["Poker"..(i+1)]
		poker:ScaleChange(0.6,v);
		if i>2 and i%2==1 then
			v=v+1;
		else
			v=v+0.01;
		end
	end
	
end


function this:UpdateReceiveMessage() 
	while this.gameObject do  
		if this.networkDataPool.poolCount == 0 then
			coroutine.wait(0.1);
		else 
			for i = 1,this.networkDataPool.poolCount do
				local tempNet =  this.networkDataPool:GetObject()   
				
				local tag = tempNet.messageObj["tag"];  
				if this.isGameOverMessage then  
					if "enter"==tag or "waitplayerbet"==tag then 
						this.isGameOverMessage = false 
						local isGameOver = this:PurificationPoolReceiveMessage()
						if isGameOver then
							this.mxErrorToast:ShowToastNew3("text_4");
							this.mTimer:SetTime(20); 
						end
						coroutine.wait(0.05);
						break;
					else 
						this:PoolReceiveMessage(tempNet.messageObj);
						this.networkDataPool:GetRemoveObject()   
					end
				else 
					this:PoolReceiveMessage(tempNet.messageObj);
					this.networkDataPool:GetRemoveObject()   
					if "gameover"==tag then 
						 this.isGameOverMessage = true 
					end
				end 
				if tempNet.nextTime ~= 0  then 
					coroutine.wait(tempNet.nextTime);
					break;
				end
			end  
		end  
	end
end
function this:PurificationPoolReceiveMessage()
	
	local isEnter = false;
	local isGameOver = false;
	local isWaiPlay = false;
	local isupdate_dealers = false
	local isBet = 0;
	for i = this.networkDataPool.poolCount,1,-1 do
		local Message  = this.networkDataPool.Pool[i].messageObj 
		local tag = Message["tag"];  
		if isWaiPlay then
			if "enter"==tag then  
				isEnter = true;
				if not isEnter then
					isEnter =true
				else  
					this.networkDataPool:RemoveObject(i) 
				end 
			elseif "update_dealers"==tag then 
				if not isupdate_dealers then
					isupdate_dealers =true
				else  
					this.networkDataPool:RemoveObject(i) 
				end 
			else 
				this.networkDataPool:RemoveObject(i) 
			end
		else
			if isGameOver then 
				this.networkDataPool:RemoveObject(i) 
			else
				if "enter"==tag then 
					--进入游戏 
					isEnter = true; 
				elseif "waitplayerbet"==tag then
					--开始下注 
					isWaiPlay = true; 
				elseif "gameover"==tag then
					--下注结束 
					isGameOver = true;  
					this.networkDataPool:RemoveObject(i) 
				else 
					this.networkDataPool:RemoveObject(i) 
				end 
			end 
		end 
	end  
	 
	return isGameOver;
end


--请求接收
function this:SocketReceiveMessage (message)
	local Message = self;
	if  Message then
		--解析json字符串
		--local nextTime=0;
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];
		--log(Message)
		if "xiaojiu" == typeC then
			if "enter" == tag then
				log(Message)
				this:gameEnter(messageObj);
			elseif "come" == tag then
				log(Message)
				--nextTime=-1;
				this:gameCome(messageObj);
			elseif "leave" == tag then
				log(Message)
				--nextTime=-1;
				this:gameLeave(messageObj);
			elseif "waitupdealer" == tag then
				log(Message)
				this:gameWaitBankup(messageObj);
			elseif "updealer_fail_nomoney" == tag then
				log(Message)
				--nextTime=-1;
				this:gameBankUpFail(messageObj);
			elseif "updealer" == tag then
				log(Message)
				--nextTime=-1;
				this:gameBankUp(messageObj);
			elseif "downdealer" == tag then
				log(Message)
				--nextTime=-1;
				this:gameBankDown(messageObj);
			elseif "update_dealers" == tag then
				log(Message)
				this:gameBankUpdate(messageObj);
			elseif "waitplayerbet" == tag then
				log(Message)
				this:gameWaitBet(messageObj);
			elseif "badbet" == tag then
				log(Message)
				this:gameBadBet(messageObj);
			elseif "mybet" == tag then
				log(Message)
				this:gameMyBet(messageObj);
			elseif "bet" == tag then
				--log(Message)
				--nextTime=-1;
				--if this.BetXiaZhu and this.BetMaxMun <50 then
					--this.BetMaxMun=this.BetMaxMun+1;
					--this:gameBet(messageObj);
				--end
				this:gameBet(messageObj);
			elseif "gameover" == tag then
				log(Message)
				--nextTime=-1;
				coroutine.start(this.gameOver,this,messageObj);
			elseif "freetime" == tag then
				log(Message)
				this:gameFreeTime(messageObj);
			elseif 'seatinfo' == tag then 
				log(Message);
				--log("切换座位排名信息");
				this:RefreshSeat(messageObj)
			end
		elseif "game"==typeC then 
			if "buy_prop_success"==tag then
				log(Message);
				this:gameBuySuccess(messageObj);
			elseif "buy_prop_error"==tag then
				log(Message);
				this:gameBuyError(messageObj);
			end
		end
		--if nextTime>-1 then
			--this.networkDataPool:SetObject(messageObj,nextTime);
		--end
	end
end

function this:PoolReceiveMessage(messageObj) 
	if  messageObj then  
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];  
		if "xiaojiu"==typeC then  
			if "enter"==tag then 
				this:gameEnter(messageObj);
			elseif "come"==tag then
				this:gameCome(messageObj);
			elseif "leave"==tag then
				this:gameLeave(messageObj);
			elseif "waitupdealer"==tag then
				this:gameWaitBankup(messageObj);
			elseif "updealer_fail_nomoney"==tag then
				this:gameBankUpFail(messageObj);
			elseif "updealer"==tag then
				this:gameBankUp(messageObj);
			elseif "downdealer"==tag then
				this:gameBankDown(messageObj);
			elseif "update_dealers"==tag then
				this:gameBankUpdate(messageObj);
			elseif "waitplayerbet"==tag then
				this:gameWaitBet(messageObj);
			elseif "badbet"==tag then
				this:gameBadBet(messageObj);
			elseif "mybet"==tag then
				this:gameMyBet(messageObj);
			elseif "bet"==tag then
				this:gameBet(messageObj);
			elseif "gameover"==tag then				
				coroutine.start(this.gameOver,this ,messageObj); 
			elseif "freetime"==tag then
				this:gameFreeTime(messageObj);
			elseif "sitdown"==tag then
				this:gameSitDown(messageObj);
			elseif "situp"==tag then
				this:gameSitUp(messageObj);
			elseif "sitdown_fail"==tag then 
				this:gameSitDown_Fail(messageObj);
			elseif 'seatinfo' == tag then 
				this:RefreshSeat(messageObj)
			end
		elseif "game"==typeC then 
			if "emotion"==tag then
				this:gameEmotion(messageObj);
			elseif "buy_prop_success"==tag then
				this:gameBuySuccess(messageObj);
			elseif "buy_prop_error"==tag then
				this:gameBuyError(messageObj);
			
			end
		end
	end
end


function this:gameEnter(json)
	this:ReturnInit ();
	local winzodics = json ["body"] ["path"];--走势
	paths = {};
	if winzodics  and  #(winzodics) > 0 then
		local jsItem=nil;
		for  key,value in ipairs(winzodics) do 
			jsItem=value;
			table.insert(paths,tonumber(jsItem[1]));
			table.insert(paths,tonumber(jsItem[2]));
			table.insert(paths,tonumber(jsItem[3]));
		end
		while #(paths)>30 do
			table.remove(paths, 1);
		end
		Tools.drawPathGrid (this._6Layout:FindChild ("GamePathView"):FindChild ("PathViewGrid"), paths,29);
	end
	
	local bealerID = tonumber (json ["body"] ["dealer"]);--庄家id
	local jsarr = json ["body"] ["members"];--所有玩家信息
	local step = tonumber (json ["body"] ["step"]);
	
	local player = nil;
	players = {};
	for  i = 1,  #(jsarr) do
		player=GPlayer:New(jsarr[i]);
		players[player.uid] = player;
		if player.uid == tonumber(SocketConnectInfo.Instance.userId) then
			this.player = player;
			this.own_avatar.spriteName="avatar_"..(player.avatar+1);
			this.own_avatar_2.spriteName="avatar_"..(player.avatar+1);
			
		end
		table.insert(this.allPlayer,player.uid);
	end
	
	--开始游戏时的座位列表
	local seat = json["body"]["seats"];
	if seat~= nil then
		--log(#(seat).."====在座人数");
		for  i = 1, #(seat) do
			local seatList = seat[i];
			local sit = this._10Layout:FindChild("sit_"..(i-1));
			local label_0 = sit:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel");
			local label_1 = sit:FindChild("LayoutLabel1"):GetComponent("UILabel");
			local label_2 = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel");
			local sprite = sit:FindChild("LayoutBG/panel/Sprite_1"):GetComponent("UISprite");
			
			if seatList ~= nil and type(seatList)== "table"  and  #(seatList)>0 then
				
				local playerInfo = this:GetPlayer(tonumber(seatList[1]));
				if playerInfo ~=nil then
					 
					label_0.text =this:LengNameSub(playerInfo.nickname);   
					--log(label_0.text);
					label_1.text =  tostring(playerInfo.money);
					label_1.text =  this:uitextChange(label_1.text);  -- this:TextChange(label_1.text) --
					

					label_2.text =  tostring(playerInfo.uid);
					sprite.spriteName = "avatar_"..(playerInfo.avatar + 1);
					
					-- if  not  tableContains(this.sitPlayer,playerInfo.uid) then
					-- 	table.insert(this.sitPlayer,tonumber(seatList[1]));
					-- end
					this.sitPlayer[i] = playerInfo.uid

					if tostring(userId) ==  tostring(playerInfo.uid)  then 
						sit:FindChild("mykuang").gameObject:SetActive(true)
						coroutine.start(this.AfterDoing,this,4,function() sit:FindChild("mykuang").gameObject:SetActive(false)  end)
					else

						sit:FindChild("mykuang").gameObject:SetActive(false);
					end
				end
			else
				label_0.text = "";
				label_1.text = "";
				label_2.text = "";
				sprite.spriteName = "avatar_w";
			end
			
		end
	end
	
	this:getWuzuoList();
	
	
	if not  tableContains(this.sitPlayer,userId)   then
		havesit = false;
	else
		havesit = true;
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
			--this.mxtxtPlyInfo0.text=XMLResource.Instance:Str("mx_label_0")..this.banker.nickname;
			this.mxtxtPlyInfo0.text=this.banker.nickname;
		else
			--this.mxtxtPlyInfo0.text=XMLResource.Instance:Str("mx_label_0").."玩家";
			this.mxtxtPlyInfo0.text="玩家";
		end
		
		--this.mxtxtPlyInfo1.text=XMLResource.Instance:Str("mx_label_1")..json["body"]["dealer_winlost"];
		this.mxtxtPlyInfo1.text=this.banker.money;
		this.mxtxtPlyInfo2.text=XMLResource.Instance:Str("mx_label_2")..json["body"]["dealer_times"];
		--this.mxtxtPlyInfo3.text=XMLResource.Instance:Str("mx_label_3")..EginUser.Instance.nickname;
		this.mxtxtPlyInfo3.text=EginUser.Instance.nickname;
		--this.mxtxtPlyInfo4.text=XMLResource.Instance:Str("mx_label_4").."0";
		this.mxtxtPlyInfo4.text=json["body"]["mymoney"];
		this.mxtxtPlyInfo5.text=XMLResource.Instance:Str("mx_label_5")..json["body"]["mymoney"];
	end
	if step == 0 then 
		--this.mxWaitGameInfo.text=XMLResource.Instance:Str("mx_game_waiting");
		--NGUITools.SetActive(this.mxWaitGameInfo.gameObject,true);
		this.mTimer:SetMaxTime(0);
		return;
	end
	local timeout = tonumber (json ["body"] ["timeout"]);
	this.mTimer:SetMaxTime (timeout);
	if step == 1 then 
		local mybetMoneys=json["body"]["mybetmoneys"];
		local albetMoneys=json["body"]["betmoneys"];
		for  i=1,3 do
			local betmoney=tonumber(mybetMoneys[i]);
			local allMoney=tonumber(albetMoneys[i]);
			local add=allMoney-deskinfos[i].allMoney;
			--deskinfos[i]:updateDeskPool_5(jettonPrefab,add,200,this.mxtxtPlyInfo4.gameObject.transform);
			deskinfos[i]:updateDeskPool_5(jettonPrefab,add);
			UISoundManager.Instance.PlaySound("nbet",0);
			deskinfos[i].allMoney=allMoney;
			deskinfos[i].betMoney=deskinfos[i].betMoney+betmoney;
			deskinfos[i].betMoneytrue = deskinfos[i].betMoneytrue + betmoney;
			if allMoney>0 then
				--deskinfos[i].btextv0.text=System.String.Format("{0:###.00} {1}",allMoney*0.0001,XMLResource.Instance:Str("mx_bet_unit"));
				deskinfos[i].btextv0.text=System.String.Format("{0:###} {1}",allMoney,XMLResource.Instance:Str("mx_bet_unit"));
				NGUITools.SetActive(deskinfos[i].btextv0.gameObject,true);
				NGUITools.SetActive(deskinfos[i].btextv0BG.gameObject,true);
			end
			if betmoney>0 then
				deskinfos[i].btextv1.text=deskinfos[i].betMoney.."";
				NGUITools.SetActive(deskinfos[i].btextv1.gameObject,true);
				NGUITools.SetActive(deskinfos[i].btextv1BG.gameObject,true);
			end
		end
		this:ResetDeskAva ();
		this:CheckBetButtonEnable (true);
		canBet = true;
	elseif step==2 then
		--this.mxWaitGameInfo.text=XMLResource.Instance:Str("mx_wait_next_start");
		this.mxWaitGameInfo_1.spriteName="text_wait";
		this.mxWaitGameInfo.gameObject:SetActive(true);
	elseif step==3 then
		--this.mxWaitGameInfo.text=XMLResource.Instance:Str("mx_wait_ready");
		--NGUITools.SetActive(this.mxWaitGameInfo.gameObject,true);
	end

end
function this:gameCome(json)
	player = GPlayer:New(json["body"]);
	players[player.uid] = player;
	if player.uid ~= userId then
		table.insert(this.allPlayer,player.uid); 
	end
	this:getWuzuoList();
end
function this:gameLeave(json)
	local leaverID = tonumber (json ["body"]);
	players[leaverID] = nil;
	table.remove(this.allPlayer,tableKey(this.allPlayer,leaverID));
	this:getWuzuoList();
end
function this:gameWaitBankup(json)
	--this.mxWaitGameInfo.text = XMLResource.Instance:Str ("mx_wait_bankup");
	--NGUITools.SetActive (this.mxWaitGameInfo.gameObject, true);
end
function this:gameBankUpFail(json)
	this.mxErrorToast:Show (2.0, SimpleFrameworkUtilstringFormat(XMLResource.Instance:Str ("mx_updealer_fail_nomoney"),tonumber(json["body"])));
	this:CheckBetButtonEnable (true);
end
function this:gameBankUp(json)
	local uid = tonumber (json ["body"] [1]);
	if uid == tonumber (SocketConnectInfo.Instance.userId) then 
		this.mxBankupChangeButton.spriteName="xiazhuang";
		this.mxBakupButton.spriteName="downdealers";
	end
	table.insert(bankupInfos,this:GetPlayer(uid) ) 
	this:ResetBakupList ();
end
function this:gameBankDown(json)
	local uid = tonumber (json ["body"] [1]);
	if uid == tonumber (SocketConnectInfo.Instance.userId) then
		this.mxBankupChangeButton.spriteName="shangzhuang";
		this.mxBakupButton.spriteName="updealers";
	end
	table.remove(bankupInfos,tableKey(bankupInfos,this:GetPlayer(uid)))
	this:ResetBakupList ();
	
	if #(bankupInfos) > 0 then
		local player = bankupInfos[1];
		if this.banker==nil or this.banker.uid ~= player.uid then
			baktime = 0;
			bakWinMoney = 0;
			--this.mxtxtPlyInfo0.text = XMLResource.Instance:Str ("mx_label_0")..player.nickname;
			this.mxtxtPlyInfo0.text = player.nickname;
			--this.mxtxtPlyInfo1.text = XMLResource.Instance:Str ("mx_label_1")..bakWinMoney;
			this.mxtxtPlyInfo1.text = player.money;
			this.mxtxtPlyInfo2.text = XMLResource.Instance:Str ("mx_label_2")..baktime;
			this:ResetBakupList ();
			this.banker=player;
			--this.mxBakupToast:Show (2.0, System.String.Format (XMLResource.Instance:Str ("mx_bakup_label"), player.nickname));
		end
	end
end
function this:gameBankUpdate(json)
	--NGUITools.SetActive (this.mxWaitGameInfo.gameObject, false);
	this.mxWaitGameInfo_1.spriteName="text_updatezhunagjia";
	this.mxWaitGameInfo.gameObject:SetActive(true);
	local binfos = json ["body"];
	bankupInfos = {};
	for  i = 1, #(binfos) do
		table.insert(bankupInfos,this:GetPlayer(tonumber(binfos[i][1])));
	end
	local player = bankupInfos[1];
	if this.banker==nil or this.banker.uid ~= player.uid then
		baktime = 0;
		bakWinMoney = 0;
		--this.mxtxtPlyInfo0.text = XMLResource.Instance:Str("mx_label_0")..player.nickname;
		this.mxtxtPlyInfo0.text =player.nickname;
		--this.mxtxtPlyInfo1.text = XMLResource.Instance:Str("mx_label_1")..bakWinMoney;
		this.mxtxtPlyInfo1.text = player.money;
		this.mxtxtPlyInfo2.text = XMLResource.Instance:Str("mx_label_2")..baktime;
		this:ResetBakupList ();
		this.banker=player;
		--this.mxBakupToast:Show (2.0, System.String.Format (XMLResource.Instance:Str ("mx_bakup_label"), player.nickname));
	end
end
function this:gameWaitBet(json)
	this.BetXiaZhu=true;
	this.startAnima:SetActive(true);
	local timeout = tonumber (json["body"]["timeout"]);
	this.mxWaitGameInfo.gameObject:SetActive(false);
	this.mTimer:SetMaxTime (timeout);
	this.time_show.spriteName="timeshow_1";
	this.time_show.width=158;
	this:ResetDeskAva ();
	this:CheckBetButtonEnable (true);
	canBet = true;
	xiashuMyNum = 0;
	this.DeskBetArr ={[0]=0,[1]=0,[2]=0,[3]=0};
	UISoundManager.Instance.PlaySound ("nstbet");
	coroutine.start(this.AfterDoing,this,3, function()   
		 this.startAnima:SetActive(false);  
	end);
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


local alreadybet=false;
function this:gameMyBet(json) 
	alreadybet=true;
	xiashuMyNum = xiashuMyNum- 1;  
	local body = json["body"];
	local betmoney = tonumber(body[1]);
	local allMoney = tonumber(body[3]);
	local index = tonumber(body[2]);
	if math.floor(this.mTimer.endTime) <=3  and xiashuMyNum <= 0 then 
		this:gameMyBetC(index,betmoney,allMoney)
	end
	deskinfos[index+1].betMoneytrue = deskinfos[index+1].betMoneytrue +betmoney;
	
end

function this:gameMyBetC(index,betmoney,allMoney,arrxia)  

	xiashuMyArr[index] = xiashuMyArr[index]+betmoney 
	
	local add = allMoney - deskinfos[index+1].allMoney;

	local money = this.mxtxtPlyInfo4.text;
	money =  string.gsub(money,",", "");
	local mymoney = tonumber(money);
	mymoney = mymoney -tonumber(betmoney);
	this.mxtxtPlyInfo4.text =  tostring(mymoney);
	this.mxtxtPlyInfo4.text = this:uitextChange(this.mxtxtPlyInfo4.text);
	this.player.money = mymoney;
	
	
	if   tableContains(this.sitPlayer,userId) then
	
		for  i = 1, 6 do
		
			local sit = this._10Layout:FindChild("sit_".. i);
			if sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(userId) then
			
				sit:FindChild("LayoutLabel1"):GetComponent("UILabel").text = this.mxtxtPlyInfo4.text;
				if index == 0 then
					this.target_[index+1].localPosition = this.target_0[i].localPosition;
				elseif index == 1 then
					this.target_[index+1].localPosition = this.target_1[i].localPosition;
				elseif index == 2 then
					this.target_[index+1].localPosition = this.target_2[i].localPosition;
				elseif index == 3 then
					this.target_[index+1].localPosition = this.target_3[i].localPosition;
				end
				
				break;
			end
		end
		deskinfos[index+1]:addSitBetArr(tostring(userId))
		deskinfos[index+1]:updateDeskPool_5(jettonPrefab, add, this.target_[index+1]);
	  
	else
		if index == 0 then
			this.target_[index+1].localPosition = this.target_00.localPosition;
		elseif index == 1 then
			this.target_[index+1].localPosition = this.target_11.localPosition;
		elseif index == 2 then
			this.target_[index+1].localPosition = this.target_22.localPosition;
		end
		--if #this.DeskPoolArr < 31 then
			--table.insert(this.DeskPoolArr, DeskPoolInfo:New(deskinfos[index+1],jettonPrefab, add, nil))
			--table.insert(this.DeskPoolArr, DeskPoolInfo:New(deskinfos[index+1],jettonPrefab, add, this.target_[index+1]))
		--end
		deskinfos[index+1]:updateDeskPool_5(jettonPrefab, add, this.target_[index+1]);
		
		 --[[
		local owner = this:GetPlayer(userId);
		if owner ~= nil then
			owner.money = owner.money -add; 
		end
		]]
	end
 
	 
	--deskinfos[index+1].kuangliang.alpha = 1; 
	deskinfos[index+1].allMoney = allMoney;
	deskinfos[index+1].betMoney = deskinfos[index+1].betMoney +betmoney;
	if allMoney > 0 then
		deskinfos[index+1].btextv0.text =  tostring(allMoney);
		NGUITools.SetActive(deskinfos[index+1].btextv0.gameObject, true);
	end
	
	if betmoney > 0 then
		deskinfos[index+1].btextv1.text = deskinfos[index+1].betMoney.."";
		NGUITools.SetActive(deskinfos[index+1].btextv1.gameObject, true);
		NGUITools.SetActive(deskinfos[index+1].btextv1BG.gameObject,true);
	end
end
--[[
function this:gameMyBetC(index,betmoney,allMoney,arrxia)

	index=index+1;
	local add=allMoney-deskinfos[index].allMoney;
	local mybetPosition = {this.mxbtnBet0.gameObject.transform,
	this.mxbtnBet1.gameObject.transform,
	this.mxbtnBet2.gameObject.transform,
	this.mxbtnBet3.gameObject.transform,
	this.mxbtnBet4.gameObject.transform,
	this.mxbtnBet5.gameObject.transform}
	--deskinfos[index]:updateDeskPool_3(jettonPrefab,add,200,mybetPosition);
	deskinfos[index]:updateDeskPool_5(jettonPrefab,add);
	UISoundManager.Instance.PlaySound ("nbet");
	deskinfos[index].allMoney=allMoney;
	deskinfos[index].betMoney=deskinfos[index].betMoney+betmoney;
	if allMoney>0 then
		--deskinfos[index].btextv0.text=System.String.Format("{0:###.00} {1}",allMoney*0.0001,XMLResource.Instance:Str("mx_bet_unit"));
		deskinfos[index].btextv0.text=System.String.Format("{0:###} {1}",allMoney,XMLResource.Instance:Str("mx_bet_unit"));
		NGUITools.SetActive(deskinfos[index].btextv0.gameObject,true);
		NGUITools.SetActive(deskinfos[index].btextv0BG.gameObject,true);
	end
	if betmoney>0 then
		deskinfos[index].btextv1.text=deskinfos[index].betMoney.."";
		NGUITools.SetActive(deskinfos[index].btextv1.gameObject,true);
		NGUITools.SetActive(deskinfos[index].btextv1BG.gameObject,true);
	end
end
]]
function this:gameBet(json)
	
	local curTime = Tools.CurrentTimeMillis ();
	local body = json ["body"];
	local allMoney = tonumber (body[2]);
	local index = tonumber (body [1]);
	local otherid=tonumber(body[3]);
	local moneyadd=tonumber(body[4]);
	--log(moneyadd.."=====下注的金钱");
	--log(index);
	local add = allMoney - deskinfos [index+1].allMoney;
	--log(add.."=====相减的金钱");
	
	if tableContains(this.sitPlayer,otherid) then
		betcount=betcount+1;
		if betcount%3==0 then
			for i=1,6 do
				local sit=this._10Layout:FindChild("sit_"..i);
				if sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(otherid) then
					--log("有座玩家");
					local othermoney = sit:FindChild("LayoutLabel1"):GetComponent("UILabel");
					local money = othermoney.text;
					money =  string.gsub(money,",", "");
					local mymoney = tonumber(money);
					mymoney = mymoney -tonumber(add);
					othermoney.text =  tostring(mymoney);
					othermoney.text =  this:uitextChange(othermoney.text);  --this:TextChange(othermoney.text)   --
					
					if index == 0 then
						this.target_[index+1].localPosition = this.target_0[i].localPosition;
					end
					if index == 1 then
						this.target_[index+1].localPosition = this.target_1[i].localPosition;
					end
					if index == 2 then
						this.target_[index+1].localPosition = this.target_2[i].localPosition;
					end
					break;
				end
			end
			deskinfos[index+1]:addSitBetArr(tostring(otherid))
			deskinfos[index+1]:updateDeskPool_5(jettonPrefab, add, this.target_[index+1]);
		end
	else
		if #(this.DeskPoolArr) < 35 then
			table.insert(this.DeskPoolArr, DeskPoolInfo:New(deskinfos[index+1],jettonPrefab, add, nil))
		end
		local owner=this:GetPlayer(otherid);
		if owner~=nil then
			owner.money=owner.money-add;
		end
	end
	
	
	--deskinfos[index]:updateDeskPool_3(jettonPrefab,add,200,this.betTarget.transform);
	if curTime - bettime > 60 then 
		UISoundManager.Instance.PlaySound("nbet");
		bettime=curTime;
	end
	deskinfos [index+1].allMoney = allMoney;
	--deskinfos [index].btextv0.text = System.String.Format ("{0:###.00} {1}", allMoney , XMLResource.Instance:Str ("mx_bet_unit"));
	deskinfos [index+1].btextv0.text = System.String.Format ("{0:###} {1}", allMoney , XMLResource.Instance:Str ("mx_bet_unit"));
	NGUITools.SetActive(deskinfos[index+1].btextv0.gameObject,true);
	NGUITools.SetActive(deskinfos[index+1].btextv0BG.gameObject,true);
end

local timeoutSurplus = 0;
function this:gameOver(json)
	this.BetXiaZhu=false;
	betcount=0;
	for  j = 1,3 do 
		deskinfos[j].DeskBetPoolArr = {}
	end 

	--本局下注记录 
	xiashuMyArrHou = xiashuMyArr 
	xiashuMyArr =  {[0]=0,[1]=0,[2]=0,[3]=0}; 
	
	canBet = false;
	local body = json ["body"];
	local timeout = tonumber (body ["timeout"]);--20秒操作时间
	--this.mTimer:SetMaxTime (timeout);
	this:CheckBetButtonEnable (false);--禁用所有下注按钮
	UISoundManager.Instance.PlaySound ("nspbet");--声音：买定离手
	baktime=baktime+1;--完成局数
	local mywin = tonumber (body ["mywin"]);--我所赢取的金钱数
	plyWinMoney = plyWinMoney +mywin;--我的战绩
	local dealerwin = tonumber (body ["dealer_win"]);--庄家赢取金钱
	bakWinMoney = bakWinMoney +dealerwin;--庄家战绩
	--Tools.SetLabelForColor(this.mxFinalSettle0,dealerwin,"1d7f08","ba4000");--显示庄家所赢金钱数
	Tools.SetLabelForColor(this.mxFinalSettle1,mywin,"1d7f08","ba4000");--显示自己所赢金钱数
	Tools.SetLabelForColor(this.mxFinalSettle2,mywin,"1d7f08","ba4000");--显示自己所赢金钱数
	
	local winzodics = body ["win_zodics"];--走势
	
	this.mybetNum = 0;
	this.betNumAll = 0;   
	for  i = 1, 3 do 
		this.mybetNum  = this.mybetNum  + tonumber(deskinfos[i].betMoneytrue);
		--log(deskinfos[i].betMoneytrue.."=========="..i);
		if tonumber(deskinfos[i].betMoneytrue)==0 then
			deskinfos[i].btextv1.gameObject:SetActive(false);
			deskinfos[i].btextv1BG.gameObject:SetActive(false);
		else
			deskinfos[i].btextv1.text = deskinfos[i].betMoneytrue.."";
		end
		this.betNumAll = this.betNumAll  +tonumber(deskinfos[i].allMoney); 
	end  
	--[[
	local alreadybet=false;
	for i=1,3 do
		if deskinfos[i].btextv1.gameObject.activeSelf then
			alreadybet=true;
		end
		break;
	end
	log("是否下注");
	log(alreadybet);
	]]

	this.mybetNum = 0;
	this.betNumAll = 0;
	
	local winz = 0;
	if #(winzodics) > 0 then 
		local v= 0
		for  i=1,3 do
			v=tonumber(winzodics[i]);
			table.insert(paths,v)
			winz=winz+((v<0) and 1 or 0);
		end
		while #(paths)>30 do
			table.remove(paths,1)
		end
	end
	local t = winz;--赢的区域数量
	local moneys = body ["moneys"];--所有玩家的id和目前金钱数
	for key,value in ipairs(moneys) do
		local jsarr=value;
		local player=this:GetPlayer(tonumber(jsarr[1]));
		if player ~= nil then 
			player.money=tonumber(jsarr[2]);
		end
	end
	local hands = body ["hands"];--四个区域的牌和点数，以及牌型
	local handinfo = nil;
	local bealerType = -1;
	local cards={};
	local d = 1;
	local i = 0;
	
	local temp8SitWin = {}
	for  i = 1,6 do 
		local sit = this._10Layout:FindChild("sit_".. i);
		local idSit = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text;
		local tempwin ={};
		if idSit ~= "" then   
			
			for  j = 1,3 do 
				if  tonumber(winzodics[j]) > 0 then   
					for k1,v1 in pairs(deskinfos[j].sitBetArr) do 
						if v1== idSit then   
							tempwin[j] = j; 
							break;
						end
					end 
				end 
			end   
			
		end
		temp8SitWin[i] = tempwin;
	end 
	
	--local timeshow = 12;
	
	
	
	for key,value in ipairs(hands) do
		i = key-1;
		handinfo=value;
		for  j=1,2 do 
			cards[d]=tonumber(handinfo[j])-1;
			d=d+1;
		end
		local typeC=tonumber(handinfo[4]);--点数

		local typeTy=tonumber(handinfo[3]);

		if typeTy==1 then
			typeC  = 10+typeC;
		end

		local text=nil;
		if i==0 then
			--this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel"):GetComponent("UILabel").text=nntype[typeC];
			if typeC>=10 then
				this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel_1").gameObject:SetActive(true);
				this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel").gameObject:SetActive(false);
			else
				this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel_1").gameObject:SetActive(false);
				this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel").gameObject:SetActive(true);
				this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel/dian"):GetComponent("UISprite").spriteName="type_win_"..typeC;
			end
			this.point=typeC;
		else
			bealerType = tonumber(winzodics[i]);
			if bealerType>0 then
				bealerType=1;
			else
				bealerType=-1;
			end
			--local money=tonumber(deskinfos[i].betMoney*winzodics[i]);
			local money=tonumber(deskinfos[i].betMoneytrue*bealerType);
			local dianshu_label=this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel/dian"):GetComponent("UISprite");
			local dian=this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel/win"):GetComponent("UISprite");
			local win_0=this._3Layout:FindChild("ChildSource"..i):FindChild("winMoney/win_0").gameObject;
			local win_1=this._3Layout:FindChild("ChildSource"..i):FindChild("winMoney/win_1").gameObject:GetComponent("UILabel");
			local win_2=this._3Layout:FindChild("ChildSource"..i):FindChild("winMoney/win_2").gameObject:GetComponent("UILabel");
			local baozi=this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel_1").gameObject;
			local notbaozi=this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel").gameObject;
			--local formStr=nil;
			if typeC>this.point then
				if typeC>=10 then
					baozi:SetActive(true);
					notbaozi:SetActive(false);
					baozi:GetComponent("UISprite").spriteName="type_win_10";
				else
					baozi:SetActive(false);
					notbaozi:SetActive(true);
					dianshu_label.spriteName="type_win_"..typeC;
					dian.spriteName="win_dian";
				end	
				this.kuangShow[i]=true;
			else
				if typeC>=10 then
					baozi:SetActive(true);
					notbaozi:SetActive(false);
					baozi:GetComponent("UISprite").spriteName="type_lose_10";
				else
					baozi:SetActive(false);
					notbaozi:SetActive(true);
					dianshu_label.spriteName="type_lose_"..typeC;
					dian.spriteName="lose_dian";
				end
			end

			if money>0 then
					win_0:SetActive(false);
					win_1.gameObject:SetActive(true);
					win_2.gameObject:SetActive(false);
					win_1.text="+"..money;
					--formStr=XMLResource.Instance:Str("mx_settle_fmat_0");
					--text=System.String.Format(formStr,nntype[typeC],bealerType,money);
			elseif money<0 then
					win_0:SetActive(false);
					win_1.gameObject:SetActive(false);
					win_2.gameObject:SetActive(true);
					win_2.text=tostring(money);
					--formStr=XMLResource.Instance:Str("mx_settle_fmat_1");

			else
				win_0:SetActive(true);
				win_1.gameObject:SetActive(false);
				win_2.gameObject:SetActive(false);
				--formStr=XMLResource.Instance:Str("mx_settle_fmat_2");
				--text=System.String.Format(formStr,nntype[typeC],money);
			end
			
			--local label=this._3Layout:FindChild("ChildSource"..i):FindChild("SourceLabel"):GetComponent("UILabel");
			--label.text=System.String.Format("[ffffff]{0}[-]",nntype[typeC]);
			--this.expsObj[label.transform.parent.name] = ExpsObj:New(label.transform.parent);
			--this.expsObj[label.transform.parent.name].ObjRef =   {text, money, "22ff22", "ff2222" ,typeC};
		end
	end
	
	coroutine.wait(1.9);
	timeout = timeout-2;
	local timeshow = 9;
	this.mTimer:SetMaxTime(timeshow); 
	this.time_show.spriteName="timeshow_2";
	this.time_show.width=158;
	timeoutSurplus = timeout-timeshow;
	--发牌动画的播放
	local TempTimtA = this:StartSendPokerAnim(cards); 
	--this:StartSendPokerAnim (cards);
	
	coroutine.start(this.AfterDoing,this, 4.2,function()
		this:ScaleChangePokerAnim();
		this._2Layout.gameObject:GetComponent("UIPanel").depth=9;
		local v=0.5;
		for  i=0,0 do
			local index=i;
			coroutine.start(this.AfterDoing,this, v,function()
				NGUITools.SetActive(this._3Layout:FindChild("ChildSource"..index).gameObject,true);
			end);
			v=v+1;
		end
		for  i=1,3 do
			local index=i;
			coroutine.start(this.AfterDoing,this, v,function()
				NGUITools.SetActive(this._3Layout:FindChild("ChildSource"..index).gameObject,true);
				local win=this._3Layout:FindChild("ChildSource"..i):FindChild("winMoney").gameObject;
				win:SetActive(true);
				if this.kuangShow[index] then
					this.kuang[i].gameObject:SetActive(true);
				end
			end);
			v=v+1;
		end
	end);
	
	
	
	 --飞金币前缓动坐标准备
	coroutine.start(this.AfterDoing,this,timeshow-1, function()   
		for  j = 1,3 do 
			deskinfos[j]:ReadyBetExcursionAll();
		end     
	end);
	--飞金币前在座玩家金币准备
	coroutine.start(this.AfterDoing,this,timeshow-1, function()   
		for  i = 1,6 do 
			for  j = 1,3 do 
				if  temp8SitWin[i][j] ~= nil then  
					local tempLocalPos = 0;
					if j == 1 then
						tempLocalPos = this.target_0[i].localPosition;
					elseif j == 2 then
						tempLocalPos= this.target_1[i].localPosition;
					elseif j == 3 then
						tempLocalPos = this.target_2[i].localPosition;
					end  
					table.insert(deskinfos[j].sitArr,tempLocalPos); 
				end 
			end    
		end  
		
		for  j = 1,3 do 
			deskinfos[j]:ReadySitArrBet();
		end     
	end);
	
	
	--飞金币显示最后的结算信息
	coroutine.start(this.AfterDoing,this,timeshow-0.5, function() 
		this.mTimer:SetMaxTime(timeoutSurplus);  
		this.time_show.spriteName="timeshow_3";
		this.time_show.width=158;
		 --有座玩家特效
		local tempRunsit = function()
			for  i = 1,6 do  
				local sit = this._10Layout:FindChild("sit_".. i);
				local idSit = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text;
				if idSit ~= "" then
					local uid = tonumber(sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text);
					local user = this:GetPlayer(uid);
					local money = sit:FindChild("LayoutLabel1"):GetComponent("UILabel");
					if user ~= nil then
						money.text =  tostring(user.money);
						money.text =  this:uitextChange(money.text);  --this:TextChange(money.text) --
					end
					 
					local isliang = false;
					for j = 1,4 do
						if  temp8SitWin[i][j] ~= nil then
							isliang = true;  
							 break;
						end 
					end  
					
					if isliang then 
						sit:FindChild("win").gameObject:SetActive(true); 
						sit.transform:FindChild("pengjinbi").gameObject:SetActive(true);		 
						coroutine.start(this.AfterDoing,this,2, function()
							sit.transform:FindChild("pengjinbi").gameObject:SetActive(false);	
						end);
					end 
				end
			end
			coroutine.start(this.AfterDoing,this,2, function() 
				for  i = 1,3 do
					deskinfos[i].sitBetArr = {}
				end  
				for  i = 1,6 do 
					this._10Layout:FindChild("sit_".. i):FindChild("win").gameObject:SetActive(false); 
				end
			end);
		end
	
	
		--金币声音模拟
		local tempRunjinbiSound = function(temptime) 
			--金币声音
			coroutine.start(this.AfterDoing,this,temptime, function()
				 this.InvokeLua:InvokeRepeating("playsound",this.playsound, 0, 0.15);
				coroutine.start(this.AfterDoing,this,1.0, function()
						this.InvokeLua:CancelInvoke("playsound"); 
					end);
			end); 
		end 
	
	
	
		--荷官吐出金币
		local tempRunjinbiTu = function()
			for  i = 1,3 do
				if  tonumber(winzodics[i]) > 0 then 
					local deskinfobj = deskinfos[i]; 
					local countjettons = #(deskinfobj.jettons)
					--log(countjettons.."====桌上筹码数量");
					if countjettons >AllBetMaxNum then
						countjettons = AllBetMaxNum;
					end 
					tempNumPool =1
					local delayTime = 0
					for  j = 1,countjettons ,tempNumPool do
						 local tempJ = j;
						coroutine.start(this.AfterDoing,this,delayTime,function()  
							local tempObj = deskinfobj.jettons[tempJ]
							
							local goObj =deskinfobj.objPool:GetObject(); 
							local go =goObj.gameObj; 
							--go:SetActive(true); 
							goObj.sprite.depth = 301; 
							goObj.transform.localScale = Vector3.New(1.1,1.1,1);
							goObj.transform.localPosition = deskinfobj.endtarget.localPosition;   
							goObj.from = tempObj.from;
							
							local temppos = tempObj.gameObj.transform.localPosition:Add(Vector3.New(10, 10, 0))
							--Util.iTweenMoveLua(go,temppos,0.3) 
							iTween.MoveTo(go,iTween.Hash ("position",temppos,"islocal",true,"time",0.7,"easeType", iTween.EaseType.easeOutCubic));      
							--Util.DOMoveLua(go,tempObj.gameObj.transform.localPosition:Add(Vector3.New(10, 10, 0)),0.2)
							deskinfobj:ReadyBetExcursion(goObj,temppos) 
							table.insert(deskinfobj.jettons,goObj);	 
							 deskinfobj:OnLineControl()	
						end);   
						delayTime =delayTime+0.06;
					end
				end
			end 
		end
		--荷官收回金币
		local tempRunjinbishou = function()
			for  i = 1,3 do
				--log("回收金币");
				if  tonumber(winzodics[i]) <= 0 then
					deskinfos[i]:OnLineControlM(30);
					deskinfos[i]:ResetView_0(tonumber(winzodics[i]));
				end
			end 
		end
		--金币飞回改去的位置
		local tempRunjinbi = function() 
			for  i = 1,3 do   
				deskinfos[i]:OnLineControlM(25-(#(deskinfos[i].sitBetShootArr)*3));
				deskinfos[i]:ResetView_0(tonumber(winzodics[i]));
			end 
		end
		--在座玩家的金币飞回
		local tempidSitPos = function() 
			for  i = 1,3 do 
				deskinfos[i]:ShootSitArrBet()  
			end 
		end
		
		
		local timeT = 0;
		if t == 3 then 
			--通吃
			tempRunjinbi(); 
			timeT= timeT+0.8
			tempRunjinbiSound(0.2);
		elseif t == 0 then 
			--通赔  
			--吐金币
			tempRunjinbiTu(); 
			tempRunjinbiSound(0.2);
			timeT= timeT+2.5
			--收金币
			coroutine.start(this.AfterDoing,this,timeT, function() 
				tempidSitPos()
				tempRunjinbi()
				tempRunjinbiSound(0.2);
			end); 
			timeT= timeT+0.8
		else
			--收金币
			tempRunjinbishou()
			tempRunjinbiSound(0.2)  
			timeT= timeT+2.3
			--吐金币
			coroutine.start(this.AfterDoing,this,timeT, function()
				tempRunjinbiTu();--有问题
				tempRunjinbiSound(0.2);				
			end);
			timeT= timeT+2.5
			--收金币
			coroutine.start(this.AfterDoing,this,timeT, function() 
				tempidSitPos()
				tempRunjinbi()
				tempRunjinbiSound(0.2);
			end);
			timeT= timeT+0.8
		end 
		--收金币特效
		coroutine.start(this.AfterDoing,this,timeT, function() 
			tempRunsit();
			
			coroutine.start(this.AfterDoing,this, 1.5, function()
				--NGUITools.SetActive(this._4Layout.gameObject,true);
				--log(mywin.."======结算自己的输赢金钱==============");
				if alreadybet then
					--log("隐藏所有二级界面");
					this._5Layout.gameObject:SetActive(false);
					this._6Layout.gameObject:SetActive(false);
					this._7Layout.gameObject:SetActive(false);
					this._8Layout.gameObject:SetActive(false);
					this._9Layout.gameObject:SetActive(false);
					this._11Layout.gameObject:SetActive(false);
					this._13Layout.gameObject:SetActive(false);
					if mywin>=0 then
						--log("显示赢的界面");
						--NGUITools.SetActive(this.win_bg,true);
						this.win_bg:SetActive(true);
						this.winAnima:SetActive(true);
					else
						this.lose_bg:SetActive(true);
						this.loseAnima:SetActive(true);
					end
				else
					--log("显示输的界面");
					--NGUITools.SetActive(this.lose_bg,true);
					this.pingju_bg:SetActive(true);
					this.CanDengdai=true;	
				end
				for i=1,3 do
					this.kuang[i].gameObject:SetActive(false);
					this.kuangShow[i]=false;
				end
				if t==3 then--庄家赢了其他三家
					UISoundManager.Instance.PlaySound("npwin");
				elseif t==0 then
					UISoundManager.Instance.PlaySound("nplos");
				end
				Tools.drawPathGrid (this._6Layout:FindChild ("GamePathView"):FindChild ("PathViewGrid"), paths,29);
			end);
		end);
	end);
	
	
	
	
	
	
	
	coroutine.start(this.AfterDoing,this, 9.0,function()
		local temptable = {};
		local tempPosition = this._0Layout:FindChild ("ChildBakIcon")
		for  i=1,3 do
			local  trans=this._3Layout:FindChild("ChildSource"..i);
			--local refObjs =this.expsObj[trans.name].ObjRef;
			--Tools.SetLabelForColor5(trans:FindChild("SourceLabel"):GetComponent("UILabel"),tostring(refObjs[1]) , tonumber(refObjs[2]) , tostring(refObjs[3]), tostring(refObjs[4]));
			--temptable[i] = tonumber(refObjs[2]);
			
			--if tonumber(refObjs[5])> this.point then
				--deskinfos[i]:ResetView_3(this.mxtxtPlyInfo4.gameObject.transform);
			--else
				--deskinfos[i]:ResetView_3(tempPosition);
			--end 
		end
		--[[
		for j=1,3 do
			if dealerwin > 0 then
				deskinfos[j]:ResetView_3(tempPosition);
			else
				deskinfos[j]:ResetView_3(this.mxtxtPlyInfo4.gameObject.transform);
			end
		end
		]]
		local cplayer=bankupInfos[1];
		--this.mxtxtPlyInfo0.text=XMLResource.Instance:Str("mx_label_0")..cplayer.nickname;
		this.mxtxtPlyInfo0.text=cplayer.nickname;
		--this.mxtxtPlyInfo1.text=XMLResource.Instance:Str("mx_label_1")..bakWinMoney;
		this.mxtxtPlyInfo1.text=cplayer.money;
		this.mxtxtPlyInfo2.text=XMLResource.Instance:Str("mx_label_2")..baktime;
		--this.mxtxtPlyInfo3.text=XMLResource.Instance:Str("mx_label_3")..EginUser.Instance.nickname;
		this.mxtxtPlyInfo3.text=EginUser.Instance.nickname;
		--this.mxtxtPlyInfo4.text=XMLResource.Instance:Str("mx_label_4")..plyWinMoney;
		this.mxtxtPlyInfo4.text=this.player.money;
		this.mxtxtPlyInfo5.text=XMLResource.Instance:Str("mx_label_5")..this.player.money;
	end);
	
end
function this:gameFreeTime(json)
	alreadybet=false;
	this:ReturnInit ();
	local timeout = tonumber (json ["body"]);
	this.mTimer:SetMaxTime (timeout);
	--this.mxWaitGameInfo.text = XMLResource.Instance:Str("mx_wait_ready");
	--NGUITools.SetActive (this.mxWaitGameInfo.gameObject, true);
	this._2Layout.gameObject:GetComponent("UIPanel").depth=20;
end

function this:LengNameSub( text)
	
	if   LengthUTF8String(text) > 4 then
		return SubUTF8String(text,12).."...";
	end
	return text;
end
function this:uitextChange(uitext)
	if   LengthUTF8String(uitext) > 4 and   LengthUTF8String(uitext) <= 8 then
		local length_1 =   this:stringSub(uitext,1,   LengthUTF8String(uitext) - 4);
		local length_2 =   this:stringSub(uitext,  LengthUTF8String(uitext) - 4+1, 4);
		uitext = length_1..",".. length_2;
	elseif   LengthUTF8String(uitext) > 8 then
		local length_1 =   this:stringSub(uitext,1,   LengthUTF8String(uitext) - 8);
		local length_2 =	this:stringSub(uitext,  LengthUTF8String(uitext) - 8+1, 4);
		local length_3 = 	this:stringSub(uitext,  LengthUTF8String(uitext) - 4+1, 4);
		uitext = length_1..",".. length_2..",".. length_3;
	end
	return uitext;
end
function this:TextChange(pText)
	if LengthUTF8String(pText) > 5 then
		local tStr1 = string.sub(pText,1,-4)
		pText = this:uitextChange(tStr1)..'万'
	else
		pText = this:uitextChange(pText)
	end
	return pText
end
function this:stringSub(uitext,start,leng)
	return string.sub(uitext,start,start+leng-1);
end

function this:RefreshSeat(pMessageObj )
	-- print(cjson.encode(pMessageObj))
	local seat = pMessageObj["body"]["seats"]
	-- print('--------------------------------')
	-- print(cjson.encode(seat))
	local tIsZhuang = false 
	if seat~= nil then
		for  i = 1, #(seat) do
			local seatList = seat[i];
			local sit = this._10Layout:FindChild("sit_"..(i-1)); 
			local label_0 = sit:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel");
			local label_1 = sit:FindChild("LayoutLabel1"):GetComponent("UILabel");
			local label_2 = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel");
			local sprite = sit:FindChild("LayoutBG/panel/Sprite_1"):GetComponent("UISprite");
			-- print('Refresh  seat=============')
			-- print(cjson.encode(seatList))
			if seatList ~= nil and type(seatList)== "table"  and  #(seatList)>0 then
				
				local playerInfo = this:GetPlayer(tonumber(seatList[1]));
				if playerInfo ~=nil then
					local localName = this:LengNameSub(playerInfo.nickname); 
						
					 if label_0.text ~= localName then
						label_0.text = localName; 
						label_1.text =  tostring(playerInfo.money);
						-- print('money---------------'..playerInfo.money)
						label_1.text = this:uitextChange(label_1.text);  -- this:TextChange(label_1.text)  
						label_2.text =  tostring(playerInfo.uid);
						
						
						-- if  not  tableContains(this.sitPlayer,playerInfo.uid) then
						-- 	table.insert(this.sitPlayer,tonumber(seatList[1]));
						-- end
						this.sitPlayer[i] = playerInfo.uid					
						
						if tostring(userId) ==  tostring(playerInfo.uid)  then 
							sprite.spriteName = "avatar_"..(playerInfo.avatar + 1);
							
							sit:FindChild("mykuang").gameObject:SetActive(true);
							coroutine.start(this.AfterDoing,this,4,function() sit:FindChild("mykuang").gameObject:SetActive(false)  end)
							
							local aa = GameObject.Instantiate(this.jiantou);
							aa.transform.parent = sit.transform;
							aa.transform.localPosition = Vector3.zero;
							aa.transform.localScale = Vector3.New(2.1,2.1,2.1);
							coroutine.start(this.AfterDoing,this,1, function()
								destroy(aa);
							end);
						else
							sit:FindChild("mykuang").gameObject:SetActive(false);
							sprite.spriteName = "avatar_"..(playerInfo.avatar + 1);
							coroutine.start(this.AfterDoing,this,0.2, function()
								
								local aa = GameObject.Instantiate(this.switchSeatAnima);
								aa.transform.parent = sit.transform;
								aa.transform.localPosition = Vector3.zero;
								aa.transform.localScale = Vector3.New(1,1,1);
								coroutine.start(this.AfterDoing,this,1, function()
									destroy(aa);
								end);
							end);
							-- coroutine.start(this.AfterDoing,this,0.2, function()
							-- 	sprite.spriteName = "avatar_"..(playerInfo.avatar + 1);
							-- end);							 
						end
					 end 
					 if tostring(this.banker.uid) == tostring(playerInfo.uid) then 
					 	-- local tP = this:GetPlayer(tostring(playerInfo.uid))
					 	tIsZhuang = true 
					 	local sit = this._10Layout:FindChild("sit_".. i); 
						if tostring(SocketConnectInfo.Instance.userId) ==  tostring(this.banker.uid)  then  
							--this.IconZhuang.transform.position = this._0Layout:FindChild("ChildLabel3/Sprite").position
						else

						 	if i > 4 then
								--this.IconZhuang.transform.localPosition = sit.localPosition:Add(Vector3.New(-63,63,0));
							else
								--this.IconZhuang.transform.localPosition = sit.localPosition:Add(Vector3.New(63,63,0));
							end 
						end
					 	-- this:AddIconZhuang(tP)
					 end


				end
			else
				label_0.text = "";
				label_1.text = "";
				label_2.text = "";
				sprite.spriteName = "avatar_w";
			end
			
		end
		--log(#(this.sitPlayer));
		--for i=1,#(this.sitPlayer) do
			--log(this.sitPlayer[i].."====在座玩家uid");
		--end
		if tIsZhuang == false then 
			--his.IconZhuang.gameObject:SetActive(false)
		end
	end
end


function this:wuzuoShow()
	page_count = 1;
	this:getWuzuoList();   
	pageallcount = math.ceil( #(this.wuzuoPlayer) / 10);
	--if  #(this.wuzuoPlayer) % 12 ~= 0 then
	--	pageallcount = pageallcount +1;
	--end

	local wuzuo = this._9Layout:FindChild("GameExitView");
	wuzuo:FindChild("Label_up"):GetComponent("UILabel").text =  tostring(page_count);
	wuzuo:FindChild("Label_down"):GetComponent("UILabel").text =  tostring(pageallcount);
	
	if page_count * 10 >  #(this.wuzuoPlayer) then
		this:OnPageShow(0,  #(this.wuzuoPlayer), page_count);
	else
		this:OnPageShow(0, page_count * 10, page_count);
	end
end

function this:getWuzuoList()
	--[[
	for  i = 1, #(this.allPlayer) do
		if  not  tableContains(this.wuzuoPlayer,this.allPlayer[i]) then
			table.insert(this.wuzuoPlayer,this.allPlayer[i]);
		end
	end
	]]
	this.wuzuoPlayer = {};
	for  i = 1, #(this.allPlayer) do
		local player = this:GetPlayer(tonumber(this.allPlayer[i]));
		if player ~= nil then
			table.insert(this.wuzuoPlayer,this.allPlayer[i]);
		end 
	end
	--log(#(this.wuzuoPlayer).."===所有人");
	--for i=1,#(this.wuzuoPlayer) do
		--log(this.wuzuoPlayer[i].."==所有玩家");
	--end
	for  i = 1, #(this.sitPlayer) do
		if this.sitPlayer[i] ~= nil then
			--log("1========"..this.sitPlayer[i])
			if  tableContains(this.wuzuoPlayer,this.sitPlayer[i]) then 
				--log("2========"..this.sitPlayer[i])
				table.remove(this.wuzuoPlayer,tableKey(this.wuzuoPlayer,this.sitPlayer[i]))
			end 
		end 
	end
	--log(#(this.wuzuoPlayer).."===减掉之后人数");
	--for i=1,#(this.wuzuoPlayer) do
		--log(this.wuzuoPlayer[i].."==无座玩家");
	--end
	
	--if tableContains(this.wuzuoPlayer,this.player.uid) then 
		--log(this.player.uid);
		--log("包含主玩家");
	--end
	this.wuzuoCount.text=tostring(#(this.wuzuoPlayer));
end

function this:OnPageShow( firstNum,  endNum,  page)
	this:getWuzuoList();
	this:HideSit();
	
	for  i = firstNum,endNum - 1 do
		this.wuzuosit[(i - (page - 1) * 10)+1]:SetActive(true);   
		
		local player = this:GetPlayer(tonumber(this.wuzuoPlayer[i+1]));
		if player ~= nil then
			this.wuzuosit[(i - (page - 1) * 10)+1].transform:FindChild("LayoutBG/panel/Sprite_1"):GetComponent("UISprite").spriteName = "avatar_".. (player.avatar + 1);
			local name = this.wuzuosit[(i - (page - 1) * 10)+1].transform:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel");
			name.text = player.nickname;
			name.text = this:LengNameSub(name.text); 
			local money = this.wuzuosit[(i - (page - 1) * 10)+1].transform:FindChild("LayoutLabel1"):GetComponent("UILabel");
			this.wuzuosit[(i - (page - 1) * 10)+1].transform:FindChild("LayoutLabel_id"):GetComponent("UILabel").text =  tostring(player.uid);
			if this.wuzuosit[(i - (page - 1) * 10)+1].transform:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(userId) then
				money.text = this.mxtxtPlyInfo5.text;
			else
				money.text = tostring(player.money );
				money.text =   this:uitextChange(money.text); --this:TextChange(money.text)
			end
		end
		
	end
end

function this:OnpageAdd()

    UISoundManager.Instance.PlaySound("but");
	this:getWuzuoList();
	if page_count < pageallcount then
		page_count = page_count +1;
	end
	local wuzuo = this._9Layout:FindChild("GameExitView");
	wuzuo:FindChild("Label_up"):GetComponent("UILabel").text =  tostring(page_count);

	if page_count * 10 <  #(this.wuzuoPlayer) then
		this:OnPageShow((page_count - 1) * 10, page_count * 10, page_count);
	else
		this:OnPageShow((page_count - 1) * 10,  #(this.wuzuoPlayer), page_count);
	end
end
function this:OnPageMinus()

	UISoundManager.Instance.PlaySound("but");
	this:getWuzuoList();
	page_count = page_count -1;
	if page_count < 1 then
		page_count = 1;
	end
	local wuzuo = this._9Layout:FindChild("GameExitView");
	wuzuo:FindChild("Label_up"):GetComponent("UILabel").text =  tostring(page_count);
	if page_count * 10 <  #(this.wuzuoPlayer) then
		this:OnPageShow((page_count - 1) * 10, page_count * 10, page_count);
	else
		this:OnPageShow((page_count - 1) * 10,  #(this.wuzuoPlayer), page_count);
	end
end

function this:HideSit()
	for  i = 1,10 do
		this.wuzuosit[i].transform:FindChild("LayoutBG/panel/Sprite_1"):GetComponent("UISprite").spriteName = "avatar_w";
		this.wuzuosit[i].transform:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel").text = "";
		this.wuzuosit[i].transform:FindChild("LayoutLabel1"):GetComponent("UILabel").text = "";
		this.wuzuosit[i].transform:FindChild("LayoutLabel_id"):GetComponent("UILabel").text = "";
		this.wuzuosit[i]:SetActive(false);
	end
end

function this:OnChangeSit(target)

	local index = 0;
	local sitindex = 0;
	for  i = 0,6 do
		local sit = this._10Layout:FindChild("sit_".. i);
		if target == sit.gameObject and sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(userId) then
			index = i;
			local chip_in = {type="nn100",tag="situp"};   
			local jsonStr = cjson.encode(chip_in);
			this.mono:SendPackage(jsonStr);
			break;
		elseif target == sit.gameObject and sit:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel").text == "" then
			sitindex = i;
			local chip_in = {type="nn100",tag="sitdown",body=sitindex};   
			local jsonStr = cjson.encode(chip_in);
			this.mono:SendPackage(jsonStr);
			break;
		elseif target == sit.gameObject and sit:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel").text ~= "" then
			this._13Layout.gameObject:SetActive(true);
			local player = this:GetPlayer(tonumber(sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text));
			if player ~= nil then
				local name = player.nickname;
				if   LengthUTF8String(name) > 7 then
					name =  SubUTF8String(name,21);
				end
				this.liwu_nickname.text = name;
			else
				this.liwu_nickname.text = "玩家";
			end
			
			this.liwu_chouma.text = sit:FindChild("LayoutLabel1"):GetComponent("UILabel").text;
			this.liwu_touxiang.spriteName = sit:FindChild("LayoutBG/panel/Sprite_1"):GetComponent("UISprite").spriteName;
			this.liwu_id.text = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text;
		end
	end

	for  j = 1,10 do
	
		local nosit = this._9Layout:FindChild("GameExitView/list_panel"):FindChild("wuzuo_".. j);
		if target == nosit.gameObject and nosit:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel").text ~= nil then
		
			this._13Layout.gameObject:SetActive(true);
			this._9Layout.gameObject:SetActive(false);
			local player = this:GetPlayer(tonumber(nosit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text));
			if player ~= nil then
				local name = player.nickname;
				if   LengthUTF8String(name) > 7 then
					name =   SubUTF8String(name,21);
				end
				this.liwu_nickname.text = name;
			else
				this.liwu_nickname.text = "玩家";
			end
			
			this.liwu_chouma.text = nosit:FindChild("LayoutLabel1"):GetComponent("UILabel").text;
			this.liwu_touxiang.spriteName = nosit:FindChild("LayoutBG/panel/Sprite_1"):GetComponent("UISprite").spriteName;
			this.liwu_id.text = nosit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text;
		end
	end
end

function this:OnSendGift(target)
	UISoundManager.Instance.PlaySound("but");
	local index = 0;
	local textNum = 1;
	local otherid = 1;
	for  i = 0,5 do
		local gift = this._13Layout:FindChild("GameSettView"):FindChild("SettViewBG0");
		if target == gift:FindChild("Liwu_".. (i + 1)).gameObject then
			index = i + 20;
			otherid = tonumber(gift:FindChild("ID"):FindChild("ID_name_1"):GetComponent("UILabel").text);
			break;
		end

	end
	this._13Layout.gameObject:SetActive(false);
	local messageBody = {uid=userId,otherid=otherid,pid=index,num=textNum};
	local sendToken = {type="game",tag="props",body=messageBody};
	local ok = cjson.encode(sendToken);
	this.mono:SendPackage(ok);
end

function this:gameBuySuccess(json)
	local body = json["body"];
	local ownid = tonumber(body[1]);
	local otherId = tonumber(body[2]);
	local pid = tonumber(body[3]);
	local liwucount = tonumber(body[4]);
	local yuanbao = tonumber(body[5]);   
	local username = "";
	local otherusername = "";
	this:getWuzuoList();

	if  tableContains(this.wuzuoPlayer,ownid) then
		local user = this:GetPlayer(ownid);
		if user~=nil then
			username = user.nickname;
		else
			username = "玩家";
		end
		--log("无座玩家包含自己");
		startPosition = this.startmoveposition.localPosition;
	else
		local user = this:GetPlayer(ownid);
		if user~=nil then
			username = user.nickname;
		else
			username = "玩家";
		end
		--log("无座玩家不包含自己");
		for  i = 0,6 do
			local sit = this._10Layout:FindChild("sit_".. i);
			if sit:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel").text ~= nil and sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(ownid) then
				usersit = sit;
				startPosition = Vector3.New(usersit.localPosition.x, usersit.localPosition.y + 11.5, usersit.localPosition.z);
				break;
			end
		end
	end
	if   tableContains(this.wuzuoPlayer,otherId) then
		local otheruser = this:GetPlayer(otherId);
		if otheruser~=nil then
			otherusername = otheruser.nickname;
		else
			otherusername = "玩家";
		end
		endPosition = this.startmoveposition.localPosition;
	else
		local otheruser = this:GetPlayer(otherId);
		
		if otheruser~=nil then
			otherusername = otheruser.nickname;
		else
			otherusername = "玩家";
		end
		
		for  i = 0,6 do
			local sit = this._10Layout:FindChild("sit_".. i);
			if sit:FindChild("LayoutBG/panel/LayoutLabel0"):GetComponent("UILabel").text ~= nil and sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(otherId) then
				othersit = sit;
				endPosition = Vector3.New(othersit.localPosition.x, othersit.localPosition.y + 11.5, othersit.localPosition.z);
				break;
			end
		end
	end

	local liwu_name = "";
	local daxie_name = "";
	if   LengthUTF8String(username) > 9 then
		username =   SubUTF8String(username,27);
	end
	if   LengthUTF8String(otherusername) > 9 then
		otherusername =   SubUTF8String(otherusername,27);
	end
	local insPrefab = nil
	if pid == 20 then
		liwu_name = liwu_name.."朵玫瑰花";
		insPrefab = GameObject.Instantiate(this.liwu_1);
	elseif pid == 21 then
		liwu_name = liwu_name.."只小乌龟";
		insPrefab = GameObject.Instantiate(this.liwu_2); 
	elseif pid == 22 then
		liwu_name = liwu_name.."个水晶杯";
		insPrefab = GameObject.Instantiate(this.liwu_3);
	elseif pid == 23 then
		liwu_name = liwu_name.."枚钻戒";
		insPrefab = GameObject.Instantiate(this.liwu_4); 
	elseif pid == 24 then
		liwu_name = liwu_name.."辆跑车";
		insPrefab = GameObject.Instantiate(this.liwu_5);
	elseif pid == 25 then
		liwu_name = liwu_name.."栋豪宅";
		insPrefab = GameObject.Instantiate(this.liwu_6);
	end
	--log(liwu_name);
	--log(insPrefab.name);
	insPrefab.transform.parent = this._10Layout.transform:FindChild("parent").transform;
	insPrefab.transform.localPosition = startPosition;
	insPrefab:AddComponent(Type.GetType("TweenScale",true));
	insPrefab:GetComponent("TweenScale").from = Vector3.zero;
	insPrefab:GetComponent("TweenScale").to = Vector3.one;
	insPrefab:GetComponent("TweenScale").duration = 1;
	coroutine.start(this.AfterDoing,this,1, function()
	
		insPrefab:AddComponent(Type.GetType("TweenPosition",true));
		insPrefab:GetComponent("TweenPosition").from = insPrefab.transform.localPosition;
		insPrefab:GetComponent("TweenPosition").to = endPosition;
		insPrefab:GetComponent("TweenPosition").duration = 1;
		coroutine.start(this.AfterDoing,this,1, function()
		
			if pid == 21 or pid == 22 or pid == 24 then
				destroy(insPrefab);
			end
			local tempAnum = this:PlayAnimation(pid);
			coroutine.start(this.AfterDoing,this,1.5, function()
				if insPrefab ~= nil then
					destroy(insPrefab);
				end
				if tempAnum ~= nil then
					destroy(tempAnum);
				end
			end);
		end);
	end);

	if liwucount == 1 then
		daxie_name = daxie_name.."一";
	elseif liwucount == 2 then
		daxie_name = daxie_name.."二";
	elseif liwucount == 3 then
		daxie_name = daxie_name.."三";
	elseif liwucount == 4 then
		daxie_name = daxie_name.."四";
	elseif liwucount == 5 then
		daxie_name = daxie_name.."五";
	elseif liwucount == 6 then
		daxie_name = daxie_name.."六";
	end
	local zengsong = "赠送给";
	this.prompt:SetActive(true);
	this.prompt_label.text = "[08de06]"..username.."  ".."[ffffff]"..zengsong.."  ".."[08de06]"..otherusername.."  ".."[f8f802]"..daxie_name.."[f8f802]"..liwu_name;
	
	
	coroutine.start(this.AfterDoing,this,2.5, function()
		this.prompt:SetActive(false);
	end);
	if ownid == userId then
		--this.mxtxtPlyInfo6.text =  tostring(yuanbao);
	end
	
	
	
end

function this:PlayAnimation( number)
	if number == 20 then
		animationPrefab = GameObject.Instantiate(this.flower);
		animationPrefab.transform.parent = this._10Layout.transform:FindChild("parent").transform;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = Vector3.New(endPosition.x - 13, endPosition.y + 24, endPosition.z);
	elseif number == 21 then
		animationPrefab = GameObject.Instantiate(this.xiong);
		animationPrefab.transform.parent = this._10Layout.transform:FindChild("parent").transform;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
		animationPrefab:GetComponent("TweenPosition").from = animationPrefab.transform.localPosition;
		animationPrefab:GetComponent("TweenPosition").to = Vector3.New(animationPrefab.transform.localPosition.x - 100, animationPrefab.transform.localPosition.y, animationPrefab.transform.localPosition.z);
	elseif number == 22 then
		animationPrefab = GameObject.Instantiate(this.jiubei);
		animationPrefab.transform.parent = this._10Layout.transform:FindChild("parent").transform;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
	elseif number == 23 then
		animationPrefab = GameObject.Instantiate(this.house);
		animationPrefab.transform.parent = this._10Layout.transform:FindChild("parent").transform;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
	elseif number == 24 then
		animationPrefab = GameObject.Instantiate(this.car);
		animationPrefab.transform.parent = this._10Layout.transform:FindChild("parent").transform;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
		animationPrefab:GetComponent("TweenPosition").from = animationPrefab.transform.localPosition;
		animationPrefab:GetComponent("TweenPosition").to = Vector3.New(animationPrefab.transform.localPosition.x - 100, animationPrefab.transform.localPosition.y + 5.7, animationPrefab.transform.localPosition.z);
	elseif number == 25 then
		animationPrefab = GameObject.Instantiate(this.house);
		animationPrefab.transform.parent = this._10Layout.transform:FindChild("parent").transform;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
	end
	return animationPrefab;
end

function this:gameBuyError(json)
	local tempString = json["body"]
	if "buy_prop_fail_nomoney"==tostring(tempString) then
		this:gameBuyNoMoney(json);	
	else
		local errMsg = XMLResource.Instance:Str("mx_bet_err_10"); 
		if errMsg ~= nil then
			this.mxErrorToast:Show(1.2, errMsg);
		end
	end 
	
end


local rechatge = nil;
function this:GameFunction()  
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end 
	--sceneRoot = GameSettingManager.transform.root:GetComponent("UIRoot")
	--if sceneRoot then 
		--sceneRoot.manualHeight = 1080;
		--sceneRoot.manualWidth = 1920;
	--end 
	destroy(rechatge) 
end
function this:OnAddMoney()  
	rechatge =  GameObject.Instantiate(this.Module_Recharge) 
	local rechatgeTrans = rechatge.transform;
	
	rechatgeTrans.parent = this.transform;
	rechatgeTrans.localScale = Vector3.one;
	
	rechatge:GetComponent("UIPanel").depth = 50; 
	
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	
	if sceneRoot then 
		sceneRoot.manualHeight = 1280;
		sceneRoot.manualWidth = 1920;
	end 
	this.Module_RechargeLua.GameFunction = this.GameFunction;
	 
	
	EginTools.PlayEffect(this.but);
end

function this:playsound()
	UISoundManager.Instance.PlaySound("nbet");
end

function this:heguanHeartbeat() 
	this.count = this.count+1;
	if(this.count%10 == 0) then
		this.anima.loop = false;
		this.anima.namePrefix = actNameAry[this.aryIndex+1];
		if(actNameAry[this.aryIndex+1]  == "h_kiss_") then 
			this.InvokeLua:Invoke("delayHeartAnima",this.delayHeartAnima,0.8);
		end
		this.aryIndex = (1+this.aryIndex)%2;
		this.InvokeLua:CancelInvoke("heguanHeartbeat");
		
		this.anima:playWithCallback( Util.packActionLua(function() 
			this.anima.namePrefix = "h_stop_";
			this.anima.loop = false;
			this.anima:playWithCallback(nil);
			this.InvokeLua:InvokeRepeating("heguanHeartbeat",this.heguanHeartbeat, 1,1);  
		 end,this));

	elseif(this.count%3 == 0) then
		this.anima.loop = false;
		this.anima.namePrefix = "h_idle_";
		this.InvokeLua:CancelInvoke("heguanHeartbeat");
		
		this.anima:playWithCallback(Util.packActionLua(function() 
			this.anima.namePrefix = "h_stop_";
			this.anima.loop = false;
			this.anima:playWithCallback(nil);
			this.InvokeLua:InvokeRepeating("heguanHeartbeat",this.heguanHeartbeat, 1,1);  
		 end,this));
	end
end
 
function this:delayHeartAnima() 
	this.heartAnima:CrossFade("heguanheart1",0);
end