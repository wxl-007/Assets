require "GameNN/Tools"
require "GameNN/DeskInfo"
require "GameNN/ExpsObj"
require "GameNN/GPlayer"
require "GameNN/GPoker"
require "GameNN/GToast"
require "GameNN/MTimer"
require "GameNN/UISoundManager"
require "GameNN/Define"
require "GameNN/NetworkDataPool"
require "GameMXNN/BestPaiXu"
require "GameMXNN/SitPlayer"
local cjson = require "cjson"
local this = LuaObject:New()
GameMXNN = this
--最大筹码数
local AllBetMaxNum = 15;	--红米--25

local ScreenW = nil
local ScreenH = nil
local TargetH = nil;
local selectMoney = 0;
--如果是主玩家
local isPrimary = false;
local setTimeout = nil;
local curTimeout = nil;

local baktime = 0;
local bakWinMoney = 0;
local plyWinMoney = 0;
local canBet = false;
local userId = tonumber(SocketConnectInfo.Instance.userId);
local canbet = nil;
local tarToggle = nil;
local sheng_1 = 0
local sheng_2 = 0
local sheng_3 = 0
local sheng_4 = 0;
local sheng_11 = nil
local sheng_22 = nil
local sheng_33 = nil
local sheng_44 = nil;
local isSystem = nil;
local bettime = 0;
local betcount = 0;
local usersit = nil
local othersit = nil;
local insPrefab = nil
local animationPrefab = nil;
local startPosition = nil
local endPosition = nil;
local page_count = 1;
local pageallcount = nil;
local type_1 = nil
local type_2 = nil
local type_3 = nil
local type_4 = nil
local type_0 = nil;
local own= nil;
local havesit= nil;
local players = {};
local bankupInfos = {};
local paths = {};
local deskinfos = {};
local jettonPrefab = {};
local nntype = {};
local spRect ={};
local pai_0 = {};
local pai_1 = {};
local pai_2 = {};
local pai_3 = {};
local pai_4 = {};
local   path_1 = {};
local  path_2 = {};
local   path_3 = {};
local  path_4 = {};
local isJinbiSource = false;
local actNameAry = {"h_tip_", "h_kiss_"}
local xiashuMyNum = 0; 
local xiashuMyArr = {};
local xiashuMyArrHou = {};
--选择牌型
local tempLabelNiu = {[0]="无牛",[1]="牛一", [2]="牛二", [3]="牛三", [4]="牛四", [5]="牛五", [6]="牛六", [7]="牛七", [8]="牛八", [9]="牛九",[10]="牛牛",[11]="银牛",[12]="金牛",[13]="炸弹",[14]="五小牛"};
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
	ScreenW = nil
	ScreenH = nil
	TargetH = nil;
	selectMoney = 0;
	isPrimary = false;
	setTimeout = nil;
	curTimeout = nil;
	
	baktime = nil;
	bakWinMoney = 0;
	plyWinMoney = 0;
	canBet = false;
	userId = tonumber(SocketConnectInfo.Instance.userId);
	canbet = nil;
	tarToggle = nil;
	sheng_1 = 0
	sheng_2 = 0
	sheng_3 = 0
	sheng_4 = 0;
	sheng_11 = nil
	sheng_22 = nil
	sheng_33 = nil
	sheng_44 = nil;
	isSystem = nil;
	bettime = 0;
	betcount = 0;
	usersit = nil
	othersit = nil;
	insPrefab = nil
	animationPrefab = nil;
	startPosition = nil
	endPosition = nil;
	page_count = 1;
	pageallcount = nil;
	type_1 = nil
	type_2 = nil
	type_3 = nil
	type_4 = nil
	type_0 = nil;
	own= nil;
	havesit= nil;
	players = nil
	bankupInfos = nil
	paths = nil
	deskinfos = nil
	jettonPrefab = nil
	nntype = nil
	spRect =nil
	pai_0 = nil
	pai_1 = nil
	pai_2 = nil
	pai_3 = nil
	pai_4 = nil
	path_1 = nil
	path_2 = nil
	path_3 = nil
	path_4 = nil
	
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	this.allPlayer = nil
	this.sitPlayer = nil
	this.wuzuoPlayer = nil
	this.gameNum = 0
	-- 下拉列表功能按钮     离开功能按钮   站起      换桌           无座      表情      聊天
	this.mxXialaButton = nil;
	this.mxLeaveButton = nil;
	this.mxStandUp = nil;
	this.mxChangeTable = nil;
	this.mxNoSait = nil;
	this.mxBiaoQing = nil;
	this.mxTalk = nil;
	this.mxBackButton = nil;
	this.mxSettButton = nil;
	this.mxMusicButton = nil;  --返回按钮   原来的设置按钮    新的设置按钮
	this.mxBakupButton = nil;
	this.mxBakluButton = nil;        --申请上庄按钮     原来的胜率显示按钮
	this.mxbtnBet0 = nil;
	this.mxbtnBet1 = nil;
	this.mxbtnBet2 = nil;     --六个下注按钮
	this.mxbtnBet3 = nil;
	this.mxbtnBet4 = nil;
	this.mxbtnBet5 = nil;
	-- 庄家的昵称      战绩        玩游戏的局数
	this.mxtxtPlyInfo0 = nil;
	this.mxtxtPlyInfo1 = nil;
	this.mxtxtPlyInfo2 = nil;
	--自己的昵称       战绩          筹码
	this.mxtxtPlyInfo3 = nil;
	this.mxtxtPlyInfo4 = nil;
	this.mxtxtPlyInfo5 = nil;
	this.mTimer = nil; --倒计时
	this.mxWaitGameInfo = nil;  --等待玩家上庄的提示 
	this.mxBakupToast = nil;
	this.mxErrorToast = nil;  --某玩家上庄   错误消息
	this.mBakupListGrid = nil;   --所有申请上庄的列表的父物体
	this.mxBankupChangeButton = nil;    --我要上庄按钮
	this.mxFinalSettle0 = nil;
	this.mxFinalSettle1 = nil;    --最后结算时候庄家的输赢钱数     自己的输赢钱数
	this.mxSettBGBar = nil;
	this.mxSettEFBar = nil;  --原来的背景音乐   游戏音效的设置
	this._0Layout = nil;
	this._1Layout = nil;
	this._2Layout = nil;
	this._3Layout = nil;   --整个界面的父物体     四个下注台的父物体       所有的扑克牌父物体    所有牌型的父物体
	this._4Layout = nil;
	this._5Layout = nil;
	this._6Layout = nil;       --结算框的父物体    上庄列表的父物体       所有胜率显示的父物体
	this._7Layout = nil;
	this._8Layout = nil;
	this._9Layout = nil;
	this._10Layout = nil;
	this._11Layout = nil;
	this._12Layout = nil;
	this._13Layout = nil;
	this._14Layout = nil;
	this._15Layout = nil;   --音乐设置的父物体   退出的提示框父物体   座位  新加下拉列表父物体  新的音乐设置的父物体  无座列表   表情列表  
	this.shuyingkuang = nil;
	this.startmoveposition = nil;
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
	this.shenglv_1 = nil;
	this.shenglv_2 = nil;
	this.shenglv_3 = nil;
	this.shenglv_4 = nil;
	this.prompt = nil;
	this.prompt_label = nil;
	this.musicOn = nil;
	this.yinxiaoOn = nil;
	this.puketarget = nil;
	this.bai = nil;
	this.qian = nil;
	this.wan = nil;
	this.shiwan = nil;
	this.baiwan = nil;
	this.sit_0 = nil;
	this.heguan = nil;
	this.tishi = nil;
	this.jiantou = nil;
	this.liwu_nickname = nil;
	this.liwu_id = nil;
	this.liwu_chouma = nil;
	this.liwu_touxiang = nil;
	this.repetition = nil
	this.mxFinalSettle2 = nil
	this.mxFinalSettle3 = nil
	this.mxFinalSettle4 = nil 
	this.pokers = nil
	this.pokePosition = nil
	this.target_0 = nil
	this.target_1 = nil
	this.target_2 = nil
	this.target_3 = nil
	this.target_ = nil
	this.beishu = nil
	this.kuang = nil
	this.biaoqing = nil
	this.wuzuosit = nil
	this.player = nil;
	this.banker = nil;
	this.expsObj = nil;
	this.DeskPoolArr = nil;
	this.winTop4LabelName = nil;
	this.winTop4LabelMoney = nil;
	this.PanelAnim = nil 
	this.titleTongChi = nil
	this.titleTongChiAnim1 = nil 
	this.titleTongPei =nil
	this.titleTongPeiAnim1 =nil
	this.titleTongPeiAnim2 =nil 
	this.titleBai =nil
	this.titleBaiAnim1 =nil 
	this.titlePing =nil
	this.titlePingAnim1 = nil
	this.titlePingAnim2 = nil 
	this.titleSheng = nil
	this.titleShengAnim1 = nil
	this.titleShengAnim2 = nil
	this.switchSeatAnima  = nil
	this.networkDataPool =  nil
	isJinbiSource = false; 
	this.anima = nil
	this.heartAnima = nil
	this.count = 0;
	this.aryIndex = 0;
	if this.InvokeLua ~= nil then 
		this.InvokeLua:clearLuaValue();
		this.InvokeLua = nil;
	end
	
	coroutine.Stop()
	UISoundManager.finish()
	LuaGC();
end
--lxtd004 change  防止加载卡顿
function this:InitFirst()
	-- coroutine.start(function (  )
		-- coroutine.wait(0.5)
		-- local tMainSource = ResManager:LoadAsset("gamemxnn/gamemxnn1","gamemxnn1")
		-- local tMainObj = GameObject.Instantiate(tMainSource)
		-- tMainObj.transform.parent = this.transform.parent 
		-- tMainObj.transform.localScale = Vector3.one
		-- tMainObj.transform.localPosition = Vector3.zero
		-- for i=1,15 do 
		-- 	local tLayout = tMainObj.transform:FindChild(i..'Layout')
		-- 	if tLayout ~= nil then 
		-- 		tLayout.transform.parent = this.transform
		-- 	end
		-- end

		-- local tLayout =  tMainObj.transform:FindChild('Puke')
		-- if tLayout ~= nil then 
		-- 	tLayout.transform.parent = this.transform
		-- end
		-- this:Init()
		-- if  SettingInfo.Instance.bgVolume > 0 then
		-- SettingInfo.Instance.bgVolume = 0.1
		-- this.musicOn.spriteName = "voice_on";
		-- else
		-- 	this.musicOn.spriteName = "voice_off";
		-- end 
		
		-- if  SettingInfo.Instance.effectVolume > 0 then
		-- 	this.yinxiaoOn.spriteName = "voice_on";
		-- else
		-- 	this.yinxiaoOn.spriteName = "voice_off";
		-- end 
	-- end)
end

function this:Init()
	--初始化变量
	ScreenW = nil
	ScreenH = nil
	TargetH = nil;
	selectMoney = 0;
	isPrimary = false;
	setTimeout = nil;
	curTimeout = nil;
	
	xiashuMyArr = {[0]=0,[1]=0,[2]=0,[3]=0};
	xiashuMyArrHou ={[0]=0,[1]=0,[2]=0,[3]=0};
	
	this.DeskBetArr ={[0]=0,[1]=0,[2]=0,[3]=0};

	baktime = 0;
	bakWinMoney = 0;
	plyWinMoney = 0;
	canBet = false;
	userId = tonumber(SocketConnectInfo.Instance.userId);
	canbet = nil;
	tarToggle = nil;
	sheng_1 = 0
	sheng_2 = 0
	sheng_3 = 0
	sheng_4 = 0;
	sheng_11 = nil
	sheng_22 = nil
	sheng_33 = nil
	sheng_44 = nil;
	isSystem = nil;
	bettime = 0;
	betcount = 0;
	usersit = nil
	othersit = nil;
	insPrefab = nil
	animationPrefab = nil;
	startPosition = nil
	endPosition = nil;
	page_count = 1;
	pageallcount = nil;
	type_1 = nil
	type_2 = nil
	type_3 = nil
	type_4 = nil
	type_0 = nil;
	own= nil;
	havesit= nil;
	players = {};
	bankupInfos = {};
	paths = {};
	deskinfos = {};
	jettonPrefab = {};
	nntype = {};
	spRect ={};
	pai_0 = {};
	pai_1 = {};
	pai_2 = {};
	pai_3 = {};
	pai_4 = {};
	path_1 = {};
	path_2 = {};
	path_3 = {};
	path_4 = {};
	this.DeskPoolArr = {};
	
	this.player = nil;
	this.banker = nil;
	this.repetition = nil
	this.mybetNum = 0;
	this.betNumAll = 0;
	isJinbiSource = false;
	this.gameNum = 0
	this.isGameOverMessage = false;
	-- 下拉列表功能按钮     离开功能按钮   站起      换桌           无座      表情      聊天
	this.mxXialaButton = this.transform:FindChild("0Layout/xialaliebiao").gameObject:GetComponent("UISprite");
	this.mxLeaveButton = this.transform:FindChild("10Layout/BakupList/LeaveButton").gameObject:GetComponent("UISprite");
	this.mxStandUp = this.transform:FindChild("10Layout/BakupList/StandUpButton").gameObject:GetComponent("UISprite");
	this.mxChangeTable = this.transform:FindChild("10Layout/BakupList/ChangeDeskButton").gameObject:GetComponent("UISprite");
	this.mxNoSait = this.transform:FindChild("0Layout/ChildButton4").gameObject:GetComponent("UISprite");
	this.mxBiaoQing = this.transform:FindChild("0Layout/ChildButton7").gameObject:GetComponent("UISprite");
	this.mxTalk = this.transform:FindChild("0Layout/ChildButton8").gameObject:GetComponent("UISprite");
	this.mxBackButton = this.transform:FindChild("0Layout/ChildButton0").gameObject:GetComponent("UISprite");
	this.mxSettButton = this.transform:FindChild("0Layout/ChildButton3").gameObject:GetComponent("UISprite");
	this.mxMusicButton = this.transform:FindChild("10Layout/BakupList/SettingButton").gameObject:GetComponent("UISprite");  --返回按钮   原来的设置按钮    新的设置按钮
	this.mxBakupButton = this.transform:FindChild("0Layout/ChildButton1").gameObject:GetComponent("UISprite");
	this.mxBakluButton = this.transform:FindChild("0Layout/ChildButton2").gameObject:GetComponent("UISprite");        --申请上庄按钮     原来的胜率显示按钮
	this.mxbtnBet0 = this.transform:FindChild("0Layout/ChildRidButton0").gameObject:GetComponent("UIToggle");
	this.mxbtnBet1 = this.transform:FindChild("0Layout/ChildRidButton1").gameObject:GetComponent("UIToggle");
	this.mxbtnBet2 = this.transform:FindChild("0Layout/ChildRidButton2").gameObject:GetComponent("UIToggle");     --六个下注按钮
	this.mxbtnBet3 = this.transform:FindChild("0Layout/ChildRidButton3").gameObject:GetComponent("UIToggle");
	this.mxbtnBet4 = this.transform:FindChild("0Layout/ChildRidButton4").gameObject:GetComponent("UIToggle");
	this.mxbtnBet5 = this.transform:FindChild("0Layout/ChildRidButton5").gameObject:GetComponent("UIToggle");
	-- 庄家的昵称      战绩        玩游戏的局数
	this.mxtxtPlyInfo0 = this.transform:FindChild("9Layout/sit_0/LayoutLabel0").gameObject:GetComponent("UILabel");
	this.mxtxtPlyInfo1 = this.transform:FindChild("0Layout/ChildLabel1").gameObject:GetComponent("UILabel");
	this.mxtxtPlyInfo2 = this.transform:FindChild("0Layout/ChildLabel2").gameObject:GetComponent("UILabel");
	--自己的昵称       战绩          筹码
	this.mxtxtPlyInfo3 = this.transform:FindChild("0Layout/ChildLabel3").gameObject:GetComponent("UILabel");
	this.mxtxtPlyInfo4 = this.transform:FindChild("0Layout/ChildLabel4").gameObject:GetComponent("UILabel");
	this.mxtxtPlyInfo5 = this.transform:FindChild("0Layout/ChildLabel5").gameObject:GetComponent("UILabel");
	this.mxtxtPlyInfo6 = this.transform:FindChild("0Layout/ChildLabel6").gameObject:GetComponent("UILabel");
	local timergameobj =  this.transform:FindChild("0Layout/ChildTimer").gameObject--倒计时
	this.mTimer = MTimer:New(timergameobj);
	this.mxWaitGameInfo = this.transform:FindChild("3Layout/ChildTipLabel").gameObject:GetComponent("UILabel");  --等待玩家上庄的提示 
	this.mxBakupToast = GToast:New(this.transform:FindChild("3Layout/GameToastBakup").gameObject)
	--this.transform:FindChild("3Layout/GameToastBakup").gameObject:GetComponent("GToast");
	this.mxErrorToast = GToast:New(this.transform:FindChild("3Layout/GameToastError").gameObject)
	--this.transform:FindChild("3Layout/GameToastError").gameObject:GetComponent("GToast");  --某玩家上庄   错误消息
	this.mBakupListGrid = this.transform:FindChild("5Layout/BakupList/BakupListView/UIGrid").gameObject:GetComponent("UIGrid");   --所有申请上庄的列表的父物体
	this.mxBankupChangeButton = this.transform:FindChild("5Layout/BakupList/BakupButton").gameObject:GetComponent("UISprite");    --我要上庄按钮
	this.mxFinalSettle0 = this.transform:FindChild("4Layout/panel/LayoutLabel0-").gameObject:GetComponent("UILabel");
	this.mxFinalSettle1 = this.transform:FindChild("4Layout/panel/LayoutLabel1-").gameObject:GetComponent("UILabel");  
	this.mxFinalSettleAdd0 = this.transform:FindChild("4Layout/panel/LayoutLabel0+").gameObject:GetComponent("UILabel");
	this.mxFinalSettleAdd1 = this.transform:FindChild("4Layout/panel/LayoutLabel1+").gameObject:GetComponent("UILabel");  
	this.mxFinalSettle2 = this.transform:FindChild("4Layout/panel/LayoutLabel2").gameObject:GetComponent("UILabel");
	this.mxFinalSettle3 = this.transform:FindChild("4Layout/panel/LayoutLabel3").gameObject:GetComponent("UILabel");    
	this.mxFinalSettle4 = this.transform:FindChild("4Layout/panel/jixuButton/Label").gameObject:GetComponent("UILabel");  
	--最后结算时候庄家的输赢钱数     自己的输赢钱数
	this.mxSettBGBar = this.transform:FindChild("7Layout/GameSettView/SettViewSBar0").gameObject:GetComponent("UISlider");
	this.mxSettEFBar = this.transform:FindChild("7Layout/GameSettView/SettViewSBar1").gameObject:GetComponent("UISlider");  --原来的背景音乐   游戏音效的设置
	this._0Layout = this.transform:FindChild("0Layout");
	this._1Layout = this.transform:FindChild("1Layout");
	this._2Layout = this.transform:FindChild("2Layout");
	this._3Layout = this.transform:FindChild("3Layout");   --整个界面的父物体     四个下注台的父物体       所有的扑克牌父物体    所有牌型的父物体
	this._4Layout = this.transform:FindChild("4Layout");
	this._5Layout = this.transform:FindChild("5Layout");
	this._6Layout = this.transform:FindChild("6Layout");       --结算框的父物体    上庄列表的父物体       所有胜率显示的父物体
	this._7Layout = this.transform:FindChild("7Layout");
	this._8Layout = this.transform:FindChild("8Layout");
	this._9Layout = this.transform:FindChild("9Layout");
	this._10Layout = this.transform:FindChild("10Layout");
	this._11Layout = this.transform:FindChild("11Layout");
	this._12Layout = this.transform:FindChild("12Layout");
	this._13Layout = this.transform:FindChild("13Layout");
	this._14Layout = this.transform:FindChild("14Layout");
	this._15Layout = this.transform:FindChild("15Layout");   --音乐设置的父物体   退出的提示框父物体   座位  新加下拉列表父物体  新的音乐设置的父物体  无座列表   表情列表  
	
	--荷官动画控制
	
	this.anima = this._0Layout:FindChild("HeguanAnimaPrb").gameObject:GetComponent("UISpriteAnimation");
	this.heartAnima = this._0Layout:FindChild("HeguanAnimaPrb/heart").gameObject:GetComponent("Animator");
	this.count = 0;
	this.aryIndex = 0;
	
	
	this.shuyingkuang = this.transform:FindChild("3Layout/Shuyingkuang");
	this.startmoveposition = this.transform:FindChild("9Layout/targetPosition");
	this.liwu_1 = ResManager:LoadAsset("gamemxnn/liwu","liwu_1");
	this.liwu_2 = ResManager:LoadAsset("gamemxnn/liwu","liwu_2");
	this.liwu_3 = ResManager:LoadAsset("gamemxnn/liwu","liwu_3");
	this.liwu_4 = ResManager:LoadAsset("gamemxnn/liwu","liwu_4");
	this.liwu_5 = ResManager:LoadAsset("gamemxnn/liwu","liwu_5");
	this.liwu_6 = ResManager:LoadAsset("gamemxnn/liwu","liwu_6");
	this.flower = ResManager:LoadAsset("gamemxnn/liwu","flower");
	this.house = ResManager:LoadAsset("gamemxnn/liwu","house");
	this.xiong = ResManager:LoadAsset("gamemxnn/liwu","xiong");
	this.jiubei = ResManager:LoadAsset("gamemxnn/liwu","jiubei");
	this.car = ResManager:LoadAsset("gamemxnn/liwu","car");
	this.shenglv_1 = this.transform:FindChild("6Layout/GamePathView/path_1").gameObject:GetComponent("UILabel");
	this.shenglv_2 = this.transform:FindChild("6Layout/GamePathView/path_2").gameObject:GetComponent("UILabel");
	this.shenglv_3 = this.transform:FindChild("6Layout/GamePathView/path_3").gameObject:GetComponent("UILabel");
	this.shenglv_4 = this.transform:FindChild("6Layout/GamePathView/path_4").gameObject:GetComponent("UILabel");
	this.prompt = this.transform:FindChild("3Layout/PromptMessage").gameObject;
	this.prompt_label = this.transform:FindChild("3Layout/PromptMessage/ToastLabel").gameObject:GetComponent("UILabel");
	this.musicOn = this.transform:FindChild("11Layout/GameSettView/SettViewSBar0/SettBarBG0").gameObject:GetComponent("UISprite");
	this.yinxiaoOn = this.transform:FindChild("11Layout/GameSettView/SettViewSBar1/SettBarBG0").gameObject:GetComponent("UISprite");
	this.puketarget = nil;
	this.bai = this.transform:FindChild("0Layout/ChildRidButton0/ButtonBG/ButtonBG").gameObject:GetComponent("UISprite");
	this.qian = this.transform:FindChild("0Layout/ChildRidButton1/ButtonBG/ButtonBG").gameObject:GetComponent("UISprite");
	this.wan = this.transform:FindChild("0Layout/ChildRidButton2/ButtonBG/ButtonBG").gameObject:GetComponent("UISprite");
	this.shiwan = this.transform:FindChild("0Layout/ChildRidButton3/ButtonBG/ButtonBG").gameObject:GetComponent("UISprite");
	this.baiwan = this.transform:FindChild("0Layout/ChildRidButton5/ButtonBG/ButtonBG").gameObject:GetComponent("UISprite");
	this.sit_0 =  this.transform:FindChild("9Layout/sit_0");
	this.heguan = this.transform:FindChild("0Layout/ChildBakIcon").gameObject:GetComponent("UISprite");
	this.tishi = this.transform:FindChild("0Layout/ChildButton1/Label 1").gameObject:GetComponent("UILabel");
	this.jiantou = ResManager:LoadAsset("gamemxnn/prefab","youzuo_1");
	this.switchSeatAnima = ResManager:LoadAsset("gamemxnn/prefab","switchSeatAnima"); 
	this.liwu_nickname = this.transform:FindChild("13Layout/GameSettView/SettViewBG0/Nickname/Name_1").gameObject:GetComponent("UILabel");
	this.liwu_id = this.transform:FindChild("13Layout/GameSettView/SettViewBG0/ID/ID_name_1").gameObject:GetComponent("UILabel");
	this.liwu_chouma = this.transform:FindChild("13Layout/GameSettView/SettViewBG0/Chouma/Chouma_name_1").gameObject:GetComponent("UILabel");
	this.liwu_touxiang = this.transform:FindChild("13Layout/GameSettView/SettViewBG0/Touxiang").gameObject:GetComponent("UISprite");
	--lxtd004 
	this.ReBetBtn = this._0Layout:FindChild("ChildButton9").gameObject
	
 
	this.IconZhuang = this._0Layout.transform:FindChild("iconAnima").gameObject:GetComponent("Animator")
	this.IconZhuang.gameObject:SetActive(true)
	this.pokePosition = {};
	this.pokers = {};
	for i = 0,25 do 
		this.pokers["Poker"..i] = GPoker:New(this._2Layout:FindChild("Poker"..i).gameObject)
	end
	this.target_0 = {};
	for i = 1,12 do 
		table.insert(this.target_0,this.transform:FindChild("1Layout/BetDesk0/target_"..i));
	end
	this.target_1 = {};
	for i = 1,12 do 
		table.insert(this.target_1,this.transform:FindChild("1Layout/BetDesk1/target_"..i));
	end
	this.target_2 = {};
	for i = 1,12 do 
		table.insert(this.target_2,this.transform:FindChild("1Layout/BetDesk2/target_"..i));
	end
	this.target_3 = {};
	for i = 1,12 do 
		table.insert(this.target_3,this.transform:FindChild("1Layout/BetDesk3/target_"..i));
	end
	this.target_ = {
		this.transform:FindChild("1Layout/BetDesk0/target_0"),
		this.transform:FindChild("1Layout/BetDesk1/target_0"),
		this.transform:FindChild("1Layout/BetDesk2/target_0"),
		this.transform:FindChild("1Layout/BetDesk3/target_0")
	};
	
	this.beishu = {
		this.transform:FindChild("3Layout/ChildSource1/Beishu").gameObject:GetComponent("UISprite"),
		this.transform:FindChild("3Layout/ChildSource2/Beishu").gameObject:GetComponent("UISprite"),
		this.transform:FindChild("3Layout/ChildSource3/Beishu").gameObject:GetComponent("UISprite"),
		this.transform:FindChild("3Layout/ChildSource4/Beishu").gameObject:GetComponent("UISprite")
	};
	this.kuang = {
		this.transform:FindChild("3Layout/Shuyingkuang/Kuang_0").gameObject:GetComponent("UISprite"),
		this.transform:FindChild("3Layout/Shuyingkuang/Kuang_1").gameObject:GetComponent("UISprite"),
		this.transform:FindChild("3Layout/Shuyingkuang/Kuang_2").gameObject:GetComponent("UISprite"),
		this.transform:FindChild("3Layout/Shuyingkuang/Kuang_3").gameObject:GetComponent("UISprite")
	};
	this.winTop4LabelName = {
		this.transform:FindChild("4Layout/panel/top4/LayoutLabel1").gameObject:GetComponent("UILabel"),
		this.transform:FindChild("4Layout/panel/top4/LayoutLabel2").gameObject:GetComponent("UILabel"),
		this.transform:FindChild("4Layout/panel/top4/LayoutLabel3").gameObject:GetComponent("UILabel"),
		this.transform:FindChild("4Layout/panel/top4/LayoutLabel4").gameObject:GetComponent("UILabel")
	};
	this.winTop4LabelMoney= {
		this.winTop4LabelName[1].transform:FindChild("Label").gameObject:GetComponent("UILabel"),
		this.winTop4LabelName[2].transform:FindChild("Label").gameObject:GetComponent("UILabel"),
		this.winTop4LabelName[3].transform:FindChild("Label").gameObject:GetComponent("UILabel"),
		this.winTop4LabelName[4].transform:FindChild("Label").gameObject:GetComponent("UILabel")
	};
	this.winTop4LabelAddMoney= {
		this.winTop4LabelName[1].transform:FindChild("LabelAdd").gameObject:GetComponent("UILabel"),
		this.winTop4LabelName[2].transform:FindChild("LabelAdd").gameObject:GetComponent("UILabel"),
		this.winTop4LabelName[3].transform:FindChild("LabelAdd").gameObject:GetComponent("UILabel"),
		this.winTop4LabelName[4].transform:FindChild("LabelAdd").gameObject:GetComponent("UILabel")
	};
	--结算动画
	this.PanelAnim = this._4Layout.transform:FindChild("panel").gameObject:GetComponent("TweenAlpha"); 
	
	this.titleTongChi = this._4Layout.transform:FindChild("titleTongChi").gameObject;
	this.titleTongChiAnim1 = this.titleTongChi.transform:FindChild("jieguo").gameObject:GetComponent("Animation");
	
	this.titleTongPei = this._4Layout.transform:FindChild("titleTongPei").gameObject;
	this.titleTongPeiAnim1 = this.titleTongPei.transform:FindChild("jieguo").gameObject:GetComponent("Animation");
	this.titleTongPeiAnim2 = this.titleTongPei.transform:FindChild("xing").gameObject:GetComponent("Animation");
	
	this.titleBai = this._4Layout.transform:FindChild("titleBai").gameObject;
	this.titleBaiAnim1 = this.titleBai.transform:FindChild("jieguo").gameObject:GetComponent("Animation");
	
	this.titlePing = this._4Layout.transform:FindChild("titlePing").gameObject;
	this.titlePingAnim1 = this.titlePing.transform:FindChild("jieguo").gameObject:GetComponent("Animation");
	this.titlePingAnim2 = this.titlePing.transform:FindChild("xing").gameObject:GetComponent("Animation");
	
	this.titleSheng = this._4Layout.transform:FindChild("titleSheng").gameObject;
	this.titleShengAnim1 = this.titleSheng.transform:FindChild("jieguo").gameObject:GetComponent("Animation");
	this.titleShengAnim2 = this.titleSheng.transform:FindChild("xing").gameObject:GetComponent("Animation");
	
	
	
	this.biaoqing = {};
	for i = 0,26 do 
		table.insert(this.biaoqing,ResManager:LoadAsset("expressionpackage/biaoqing_"..(i+1),"biaoqing_"..(i+1)));
	end
	this.wuzuosit = {};
	for i = 0,11 do 
		table.insert(this.wuzuosit,this.transform:FindChild("12Layout/GameSettView/SettViewBG0/wuzuo_"..i).gameObject);
	end

	this.mxStandUp.gameObject:GetComponent("BoxCollider").enabled = false;
	this.mxStandUp.gameObject:GetComponent("UIButtonColor").enabled = false;
	this.mxStandUp.alpha = 0.2; 
	
	this.BetMaxMun = 0;
	this.BetXiaZhu = false;

	this.allPlayer = {};
	this.sitPlayer = {};
	this.wuzuoPlayer = {};
	this.expsObj = {};

	this.InvokeLua = InvokeLua:New(this);
	 
	this.networkDataPool = NetworkDataPool:New();
end


function this:Awake()
	log("------------------awake of GameMXNNPanel")
	this:Init();
	-- this:InitFirst()
	
	if  SettingInfo.Instance.bgVolume > 0 then
		SettingInfo.Instance.bgVolume = 0.15
		this.musicOn.spriteName = "voice_on";
	else
		this.musicOn.spriteName = "voice_off";
	end 
	
	if  SettingInfo.Instance.effectVolume > 0 then
		this.yinxiaoOn.spriteName = "voice_on";
	else
		this.yinxiaoOn.spriteName = "voice_off";
	end 
	
	--------初始化UISoundManager-------------
	UISoundManager.Init(this.gameObject);
	
	--添加背景音乐资源
	UISoundManager.AddAudioSource("gamemxnn/sounds","one",true);
	--添加音效资源
	UISoundManager.AddAudioSource("gamemxnn/sounds","betback");
	UISoundManager.AddAudioSource("gamemxnn/sounds","nbet");  
	UISoundManager.AddAudioSource("gamemxnn/sounds","nspbet");
	UISoundManager.AddAudioSource("gamemxnn/sounds","nstbet");
	UISoundManager.AddAudioSource("gamemxnn/sounds","nstbet2");
	UISoundManager.AddAudioSource("gamemxnn/sounds","but");
	UISoundManager.AddAudioSource("gamemxnn/sounds","fanpaiAction"); 
	UISoundManager.AddAudioSource("gamemxnn/sounds","lose");
	UISoundManager.AddAudioSource("gamemxnn/sounds","win");
	UISoundManager.AddAudioSource("gamemxnn/sounds","draw");
	for i = 0 ,12 do
		UISoundManager.AddAudioSource("gamemxnn/sounds","Cow"..i);
	end
	

	----------绑定按钮事件--------
	--设置按钮
	this.mono:AddClick(this.mxXialaButton.gameObject, this.OnButtonClick,this);
	--音量设置
	this.mono:AddClick(this._7Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddSlider(this.mxSettBGBar, this.OnSoundBarChanged);
	this.mono:AddSlider(this.mxSettEFBar, this.OnSoundBarChanged);
	
	this.mono:AddClick(this._11Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddSlider(this._11Layout:FindChild("GameSettView/SettViewSBar0").gameObject:GetComponent("UISlider"), this.OnSoundBarChanged);
	this.mono:AddSlider(this._11Layout:FindChild("GameSettView/SettViewSBar1").gameObject:GetComponent("UISlider"), this.OnSoundBarChanged);
	
	this.mono:AddClick(this.musicOn.gameObject, this.ChangeMusic,this);
	this.mono:AddClick(this.yinxiaoOn .gameObject, this.ChangeYinxiao,this);
	 
	 
	
	--是否退出
	this.mono:AddClick(this._8Layout:FindChild("GameExitView/ExitViewButton0").gameObject, this.CloseGame,this);
	this.mono:AddClick(this._8Layout:FindChild("GameExitView/ExitViewButton1").gameObject, this.CloseExitView,this);
	--设置菜单
	this.mono:AddClick(this._10Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddClick(this._10Layout:FindChild("BakupList/ChangeDeskButton").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._10Layout:FindChild("BakupList/SettingButton").gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._10Layout:FindChild("BakupList/StandUpButton").gameObject, this.OnStandUp,this);
	this.mono:AddClick(this._10Layout:FindChild("BakupList/LeaveButton").gameObject, this.OnButtonClick,this);
	--座位按钮
	for i = 0,12 do 
		local sit = this._9Layout:FindChild("sit_"..i).gameObject;
		this.mono:AddClick(sit, this.OnChangeSit,this);
	end
	--无座玩家
	this.mono:AddClick(this.mxNoSait.gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._12Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	--无座玩家头像
	for key,value in ipairs(this.wuzuosit)  do 
		this.mono:AddClick(value, this.OnChangeSit,this);
	end
	--上一页下一页
	this.mono:AddClick(this._12Layout:FindChild("GameSettView/SettViewBG0/forward_page").gameObject, this.OnPageMinus,this);
	this.mono:AddClick(this._12Layout:FindChild("GameSettView/SettViewBG0/next_page").gameObject, this.OnpageAdd,this);
	--申请上庄
	this.mono:AddClick(this.mxBakupButton.gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this.mxBankupChangeButton.gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._5Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	--下注按钮
	this.mono:AddClick(this.mxbtnBet0.gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this.mxbtnBet1.gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this.mxbtnBet2.gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this.mxbtnBet3.gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this.mxbtnBet4.gameObject, this.OnClickBetChange,this);
	this.mono:AddClick(this.mxbtnBet5.gameObject, this.OnClickBetChange,this);
	--表情按钮
	this.mono:AddClick(this.mxBiaoQing.gameObject, this.OnButtonClick,this);
	this.mono:AddClick(this._14Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	--表情按钮
	for i = 0,26 do 
		this.mono:AddClick(this._14Layout:FindChild("GameSettView/SettViewBG0/BiaoQing_"..i).gameObject, this.OnSetBiaoQing,this);
	end
	--聊天界面
	this.mono:AddClick(this._15Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	this.mono:AddClick(this._15Layout:FindChild("GameSettView/SettViewBG0/SettBarBG0").gameObject, this.ChangeMusic,this);
	this.mono:AddClick(this._15Layout:FindChild("GameSettView/SettViewBG0/SettBarBG1").gameObject, this.ChangeYinxiao,this);
	--下注区域
	this.mono:AddClick(this._1Layout:FindChild("BetDesk0").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk1").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk2").gameObject, this.OnBetButtonClick,this);
	this.mono:AddClick(this._1Layout:FindChild("BetDesk3").gameObject, this.OnBetButtonClick,this);
	
	--玩家详情
	this.mono:AddClick(this._13Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this);
	--礼物按钮
	for i = 1,6 do 
		this.mono:AddClick(this._13Layout:FindChild("GameSettView/SettViewBG0/Liwu_"..i).gameObject, this.OnSendGift,this);
	end
	
	this.mono:AddClick(this._0Layout:FindChild("ChildButton9").gameObject, this.OnButtonClick9,this);
	this.mono:AddClick(this._0Layout:FindChild("ChildButton10").gameObject, this.OnButtonClick10,this);
	this.mono:AddClick(this._6Layout:FindChild("AMarkBG").gameObject, this.CloseMarkView,this); 
	this.mono:AddClick(this._4Layout:FindChild("panel/jixuButton").gameObject, this.CloseMarkView,this);
	------------逻辑代码------------
	 
end
function this:OnButtonClick9() 

	UISoundManager.Instance.PlaySound("but"); 
	if this.ReBetBtn:GetComponent('UIButton').isEnabled and  not this.mxErrorToast.Toast3  then 
		local isxiazhu = true
		if this.banker  ~= nil then 
			if tostring(SocketConnectInfo.Instance.userId) ==  tostring( this.banker.uid)  then 
				this.mxErrorToast:Show(1.5,"上庄中,无法下注!");
				isxiazhu = false
			end  
		end  
		if isxiazhu then
			local AllMoney = 0
			for i = 0 ,3 do  
				AllMoney= AllMoney+tonumber(xiashuMyArrHou[i]); 
			end
			 
			if tonumber(this.player.money) >= AllMoney then  
				for i = 0 ,3 do  
					if xiashuMyArrHou[i] ~= 0 then   
						this:MybetSendPackage(i,xiashuMyArrHou[i],true); 
					end
				end
				this.ReBetBtn:GetComponent('UIButton').isEnabled = false
			else
				--金钱不足
				this.mxErrorToast:Show(1.5,"余额不足,无法下注!");
			end
		end
		 
	end
end 
function this:OnButtonClick10() 
	UISoundManager.Instance.PlaySound("but");
	this._6Layout.gameObject:SetActive(true);
end
function this:Start()
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end
	
        local ratio = Screen.width / Screen.height;     --实际运行游戏屏幕的宽高（game视图）
        ScreenH = sceneRoot.manualHeight;      
        ScreenW = ratio * ScreenH;       
	
        if  ratio < 1.77777777778 then
            TargetH = ScreenW * 0.5625;
        else
            TargetH = ScreenH;
	end
	
	--计算粒子适配基数
	this.HOrW =  Screen.height/ Screen.width 
	if this.HOrW >0.56 then
		this.HeGuanSNum = 1.585-1.045*this.HOrW  
		this.HeGuanSNum = Vector3.New(this.HeGuanSNum,this.HeGuanSNum,this.HeGuanSNum)
		this.BetSNum = 1.514-0.914*this.HOrW 
		this.BetSNum = Vector3.New(this.BetSNum,this.BetSNum,this.BetSNum)
		this.BetRNum = 22.857*this.HOrW -12.857   
		
		--0==1.1-0.8*this.HOrW  R==-100-21.3333*this.HOrW  
		--1==1.2-1.0667*this.HOrW  R==-92-48*this.HOrW 
		--2==1.1-1.0667*this.HOrW  R==-94-64*this.HOrW 
		--3==1.25-1.333*this.HOrW  R==-104-64*this.HOrW 
	else
		this.HeGuanSNum = Vector3.New(1,1,1)
		this.BetSNum = Vector3.New(1,1,1)
	end 
		
	this:initLayout();
	
	this.mono:StartGameSocket();
	
	coroutine.start(this.Update);
	coroutine.start(this.UpdatePool);
	coroutine.start(this.UpdateBet);
	coroutine.start(this.UpdateReceiveMessage);
	
	UISoundManager.Start(true);
	--开启荷官动画
	this.InvokeLua:InvokeRepeating("heguanHeartbeat",this.heguanHeartbeat, 1,1); 
	this.anima:Pause();
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

----解析JSON
function this:SocketReceiveMessage(Message)
	local Message = self;
	if  Message then
		local nextTime = 0;
		--log(Message)
		--解析json字符串
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"]; 
		
		if "nn100"==typeC then  
			if "enter"==tag then  
			elseif "come"==tag then
				nextTime = -1
				this:gameCome(messageObj);
			elseif "leave"==tag then
				nextTime = -1
				this:gameLeave(messageObj);
			elseif "waitupdealer"==tag then 
			elseif "updealer_fail_nomoney"==tag then 
				nextTime = -1
				this:gameBankUpFail(messageObj);
			elseif "updealer"==tag then 
				nextTime = -1
				this:gameBankUp(messageObj);
			elseif "downdealer"==tag then 
				nextTime = -1
				this:gameBankDown(messageObj);
			elseif "update_dealers"==tag then  
			elseif "waitplayerbet"==tag then 
			elseif "badbet"==tag then 
			elseif "mybet"==tag then 
				 
			elseif "bet"==tag then 
				nextTime = -1
				if this.BetXiaZhu and this.BetMaxMun <50 then
					this.BetMaxMun=this.BetMaxMun+1;
					this:gameBet(messageObj);
				end 
			elseif "gameover"==tag then
				--log(Message)
				nextTime = 24;  
			elseif "freetime"==tag then 
			elseif "sitdown"==tag then 
			elseif "situp"==tag then 
			elseif "sitdown_fail"==tag then  
			elseif 'seatinfo' == tag then  
			end
		elseif "game"==typeC then
			nextTime = -1
			if "emotion"==tag then
				this:gameEmotion(messageObj);
			elseif "buy_prop_success"==tag then
				this:gameBuySuccess(messageObj);
			elseif "buy_prop_error"==tag then
				this:gameBuyError(messageObj); 
			end
		end 
		if nextTime > -1 then
			--log("接收到的信息==============================="..tag)
			this.networkDataPool:SetObject(messageObj,nextTime);
		end
		
	end
end 
function this:PoolReceiveMessage(messageObj) 
	if  messageObj then  
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];  
		if "nn100"==typeC then  
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
local isSoundV = 0;
function this:UpdateBet()

	while this.gameObject do 
		if canBet then
			for i = 0,3 do
				if  this.DeskBetArr[isSoundV] > 0  then 
					this.mono:SendPackage(cjson.encode({type="nn100",tag="bet",body={isSoundV,this.DeskBetArr[isSoundV]}})); 
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
					this.DeskPoolArr[i].deskPool:updateDeskPool_4(this.DeskPoolArr[i].sps, this.DeskPoolArr[i].money, this.DeskPoolArr[i].targetposition);  
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
		end 
		if this._4Layout.gameObject.activeSelf then
			this.mxFinalSettle4.text = tostring(math.floor(this.mTimer.endTime)) 
		end 
		this.BetMaxMun = 0;
	
		coroutine.wait(0.1);
	end
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
	local  w = 0
	local  h = 0;

	--[[*扑克牌的发牌位置*]]--
	spRect[3] = TargetH * 0.102;
	spRect[4] = spRect[3] * 1.2;
	spRect[1] = 0;
	spRect[2] = 0;

	local offset = ScreenW * 0.0912;
	w = ScreenW * 0.224;
	h = w;
	y = ScreenH * 0.28 - w * 0.5;
	offset = ScreenW * 0.026;

	--各个筹码的显示位置
	deskinfos[1] = DeskInfo:New(this._1Layout:FindChild("BetDesk0").gameObject,"mxnn");

	deskinfos[2] = DeskInfo:New(this._1Layout:FindChild("BetDesk1").gameObject,"mxnn");

	deskinfos[3] = DeskInfo:New(this._1Layout:FindChild("BetDesk2").gameObject,"mxnn");
	
	deskinfos[4] = DeskInfo:New(this._1Layout:FindChild("BetDesk3").gameObject,"mxnn");
	
	
	tf = this._1Layout:FindChild("JettonPrefab");
	w = w * 0.131;
	h = w * 0.92857;
	--下注的筹码图片
	jettonPrefab[1] = tf:FindChild("Jetton0"):GetComponent("UISprite");
	jettonPrefab[2] = tf:FindChild("Jetton1"):GetComponent("UISprite");
	jettonPrefab[3] = tf:FindChild("Jetton2"):GetComponent("UISprite");
	jettonPrefab[4] = tf:FindChild("Jetton3"):GetComponent("UISprite");
	jettonPrefab[5] = tf:FindChild("Jetton5"):GetComponent("UISprite");
	jettonPrefab[6] = tf:FindChild("Jetton4"):GetComponent("UISprite");
	--初始化对象池 
	deskinfos[1]:InitObject(jettonPrefab[1].gameObject); 
	deskinfos[2]:InitObject(jettonPrefab[1].gameObject); 
	deskinfos[3]:InitObject(jettonPrefab[1].gameObject); 
	deskinfos[4]:InitObject(jettonPrefab[1].gameObject); 
	--初始化粒子
	 
	
	deskinfos[1]:SetWuParticle(this.transform:FindChild("0Layout/ChildButton4/GameObject/testCoinPtPrb0/testCoinParticles").gameObject:GetComponent("ParticleSystem"))
	deskinfos[2]:SetWuParticle(this.transform:FindChild("0Layout/ChildButton4/GameObject/testCoinPtPrb1/testCoinParticles").gameObject:GetComponent("ParticleSystem"))
	deskinfos[3]:SetWuParticle(this.transform:FindChild("0Layout/ChildButton4/GameObject/testCoinPtPrb2/testCoinParticles").gameObject:GetComponent("ParticleSystem"))
	deskinfos[4]:SetWuParticle(this.transform:FindChild("0Layout/ChildButton4/GameObject/testCoinPtPrb3/testCoinParticles").gameObject:GetComponent("ParticleSystem"))
	
	
	--[[
	for i = 1,600 do
		local tempPool = this.objPool.Pool[i];
		tempPool.anima = tempPool.gameObj.transform:FindChild("coinDropAnima"):GetComponent("UISpriteAnimation"); 
	end  
	]]
	w = ScreenW * 0.046;
	h = TargetH * 0.1;
	x = -ScreenW * 0.03124;
	y = ScreenH * 0.2 - h * 0.66;     

	--所有扑克牌的位置以及宽高的设置
	this.pokePosition = {};
	for  i = 1,25 do
		this.pokePosition[i] = this._2Layout:FindChild("Poker".. (i )).transform.localPosition;
	end

	
	--所有上庄玩家信息列表
	tf = this._5Layout:FindChild("BakupList");
	--输赢概率列表中的对号与叉号
	local pathprefab = this._6Layout:FindChild("GamePathView"):FindChild("ZPathIcon"):GetComponent("UISprite");
	--所有对号与叉号的父物体
	local pathParent = this._6Layout:FindChild("GamePathView"):FindChild("PathViewGrid");
	Tools.initPathGrid(pathParent, pathprefab,Vector3.New(505, 148, 0),113,120,39,4,3);
	
	--牌型的数组 
	nntype =tempLabelNiu 
	--nntype = XMLResource.Instance:Str("mx_nn_type"); 
	this.mxSettBGBar.value = SettingInfo.Instance.bgVolume;
	this.mxSettEFBar.value = SettingInfo.Instance.effectVolume;
	this:CheckBetButtonEnable(false);
	--等待玩家就绪
	--this.mxWaitGameInfo.text = XMLResource.Instance:Str("mx_wait_ready");
	--NGUITools.SetActive(this.mxWaitGameInfo.gameObject, true);
	--this.mxErrorToast:ShowToastNew3("text_4");
	
	if string.find(SocketConnectInfo.Instance.roomTitle,System.Text.RegularExpressions.Regex.Unescape("\\u521d\\u7ea7")) then
		isPrimary =  true;
	else
		isPrimary = false;
	end
	
	this:ResetDeskAva();
end



function this:InstantiatePuke(sp,  rp,  go, localScale,  x, y,  w, h)

	rp = this._2Layout:FindChild("Poker0"):GetComponent("UISprite");
	this:ResetSize(rp, x, y, w, h);
	for  i = 1,  25 do
	
		go = GameObject.Instantiate(rp.gameObject);
		sp = go:GetComponent("UISprite");
		localScale = go.transform.localScale;
		go.transform.parent = rp.transform.parent;
		go.transform.localScale = localScale;
		go.name = "Poker".. i;
		sp.depth = rp.depth + i;
	end
	--庄家五张牌的位置以及宽高的设置
	for  i = 1,5 do
	
		sp = this._2Layout:FindChild("Poker".. i):GetComponent("UISprite");
		this:ResetSize(sp, x + w * 0.32 * (i - 1), y, w, h);
	end
	
	w = TargetH * 0.082;        --88.61189      1080.633*0.082
	h = TargetH * 0.1;          
	x = -ScreenW * 0.294 + w * 0.5;          
	y = -ScreenH * 0.06 - h * 0.5;         
	--其余四个闲家的牌的位置和宽高设置
	for  i = 1, 20 do
		sp = this._2Layout:FindChild("Poker".. (i + 5)):GetComponent("UISprite");
		this:ResetSize(sp, x + w * 0.32 * (i - 1), y, w, h);
		if (i - 1) % 5 == 4 then
			x = x +ScreenW * 0.0875;
		end
	end
	
end
function this:ResetSize(tf,  x,  y,  w,  h)

	local collider = tf:GetComponent("BoxCollider");
	local size = collider.size;
	local news = Vector3.zero;
	news.x = w / size.x;
	news.y = h / size.y;
	tf.localScale = news;
	tf.localPosition = Vector3.New(x, y, 0);
end
function this:ResetSize( uw,  x,  y,  w,  h)
	uw.transform.localPosition = Vector3.New(x, y, 0);
	uw.width = tonumber(w);
	uw.height = tonumber(h);
end


function this:GetPlayer( uid)
	if type(uid)=="string" then
		for key,value in pairs(players) do
			if value.nickname == uid then
				return value;
			end
		end
			
	else
		return players[uid];
	end
	
end


function this:OnSoundBarChanged()

	UISoundManager.Instance.BGVolumeSet(this.mxSettBGBar.value);
	UISoundManager.Instance._EFVolume = this.mxSettEFBar.value;
end



function this:OnClickBetChange(target)
	UISoundManager.Instance.PlaySound("but");
	local toggle = target:GetComponent("UIToggle");
	
	if toggle ~= this.mxbtnBet0 then   
		this.mxbtnBet0.value = false; 
		this.mxbtnBet0.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 0; 
	else
		this.mxbtnBet0.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 1; 
	end
	
	if toggle ~= this.mxbtnBet1 then  
		this.mxbtnBet1.value = false; 
		this.mxbtnBet1.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 0; 
	else
		this.mxbtnBet1.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 1; 
	end
	
	if toggle ~= this.mxbtnBet2 then  
		this.mxbtnBet2.value = false; 
		this.mxbtnBet2.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 0;
	else
		this.mxbtnBet2.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 1; 
	end
	
	if toggle ~= this.mxbtnBet3 then 
		this.mxbtnBet3.value = false; 
		this.mxbtnBet3.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 0; 
	else
		this.mxbtnBet3.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 1; 
	end
	
	if toggle ~= this.mxbtnBet5 then
		this.mxbtnBet5.value = false; 
		this.mxbtnBet5.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 0; 
	else
		this.mxbtnBet5.gameObject.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite").alpha = 1; 
	end
	
	if this.mxbtnBet0.value then
		selectMoney = 100;
	elseif this.mxbtnBet1.value then
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

function this:CheckBetButtonEnable(enable)
	
	selectMoney = 0;
	local sp = nil;
	local sg = nil;
	tarToggle = nil;
	if enable then 
		this:CheckBetButtonEnable(false);
		local money = 0;
		if this.player ~= nil then
			money = tonumber(this.player.money)/10
		end
		if money >= 100 then
		
			this.mxbtnBet0:GetComponent("BoxCollider").enabled = true;
			sp = this.mxbtnBet0.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
			sp.alpha = 1.0;
		
			this.mxbtnBet0.value = true;
			this:OnClickBetChange(this.mxbtnBet0.gameObject);
			
		end
		if  not isPrimary then
			if money >= 1000 then
				this.mxbtnBet1:GetComponent("BoxCollider").enabled = true;
				sp = this.mxbtnBet1.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 1.0;
			end
			if money >= 10000 then
				this.mxbtnBet2:GetComponent("BoxCollider").enabled = true;
				sp = this.mxbtnBet2.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 1.0;
			end
			if money >= 100000 then
			
				this.mxbtnBet3:GetComponent("BoxCollider").enabled = true;
				sp = this.mxbtnBet3.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 1.0;
			end
			if money >= 500000 then
			
				this.mxbtnBet4:GetComponent("BoxCollider").enabled = true;
				sp = this.mxbtnBet4.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 1.0;
			end
			if money >= 1000000 then
			
				this.mxbtnBet5:GetComponent("BoxCollider").enabled = true;
				sp = this.mxbtnBet5.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 1.0;
			end
		end
	else
	
		this.mxbtnBet0.value = false;
		this.mxbtnBet1.value = false;
		this.mxbtnBet2.value = false;
		this.mxbtnBet3.value = false;
		this.mxbtnBet4.value = false;
		this.mxbtnBet5.value = false;

		this.mxbtnBet0:GetComponent("BoxCollider").enabled = false;
		sp = this.mxbtnBet0.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha = 0.2;
		sg = this.mxbtnBet0.transform:FindChild("ButtonBG/ButtonBG"):GetComponent("UISprite");
		sg.alpha = 0;
		this.mxbtnBet1:GetComponent("BoxCollider").enabled = false;
		sp = this.mxbtnBet1.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha = 0.2;
		this.mxbtnBet2:GetComponent("BoxCollider").enabled = false;
		sp = this.mxbtnBet2.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha = 0.2;
		this.mxbtnBet3:GetComponent("BoxCollider").enabled = false;
		sp = this.mxbtnBet3.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha = 0.2;
		this.mxbtnBet4:GetComponent("BoxCollider").enabled = false;
		sp = this.mxbtnBet4.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha = 0.2;
		this.mxbtnBet5:GetComponent("BoxCollider").enabled = false;
		sp = this.mxbtnBet5.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
		sp.alpha = 0.2;
	end
end
function this:OnBetButtonClick(target) 
	if selectMoney ~= 0 and  not this.mxErrorToast.Toast3 then
		local index = 0;
		for  i = 1, 4 do
			if target == deskinfos[i].gameObject then
				index = i-1;
				break;
			end
		end
		if this.bai:GetComponent("UISprite").alpha == 0 and this.qian:GetComponent("UISprite").alpha == 0 and this.wan:GetComponent("UISprite").alpha == 0 and this.shiwan:GetComponent("UISprite").alpha == 0 and this.baiwan:GetComponent("UISprite").alpha == 0 then
			canbet = false;
		else
		
			canbet = true;
		end
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
	if math.floor(this.mTimer.endTime) >3 then 
		xiashuMyNum=xiashuMyNum+1;
		this:gameMyBetC(index,selectMoney,deskinfos[index+1].allMoney+selectMoney,arrxia)  
	end
end

function this:OnButtonClick(target)
	UISoundManager.Instance.PlaySound("but");
	if target == this.mxBackButton.gameObject or target == this.mxLeaveButton.gameObject then
		--[[
		if havesit then
			local errMsg = XMLResource.Instance:Str("mx_bet_err_9");
			if errMsg ~= nil then
				this.mxErrorToast:Show(1.2, errMsg);
			end
		else
			
		end
		]]
		NGUITools.SetActive(this._8Layout.gameObject, true);
	elseif target == this.mxChangeTable.gameObject then
		local errMsg = XMLResource.Instance:Str("mx_bet_err_12");
		if errMsg ~= nil then
			this.mxErrorToast:Show(1.2, errMsg);
		end
	elseif target == this.mxSettButton.gameObject then
		NGUITools.SetActive(this._7Layout.gameObject, true);
	elseif target == this.mxMusicButton.gameObject then
		NGUITools.SetActive(this._11Layout.gameObject, true);
	elseif target == this.mxBakluButton.gameObject then
		NGUITools.SetActive(this._6Layout.gameObject, true);
	elseif target == this.mxXialaButton.gameObject then
		local tIsShow = not this._10Layout.gameObject.activeSelf 
		NGUITools.SetActive(this._10Layout.gameObject,tIsShow );
	elseif target == this.mxNoSait.gameObject then
		NGUITools.SetActive(this._12Layout.gameObject, true);
		this:wuzuoShow();
	elseif target == this.mxBiaoQing.gameObject then
		NGUITools.SetActive(this._14Layout.gameObject, true);
	elseif target == this.mxTalk.gameObject then
		NGUITools.SetActive(this._15Layout.gameObject, true);
	elseif target == this.mxBakupButton.gameObject then
		this:ShowBakupListAnim(true);
	elseif target == this.mxBankupChangeButton.gameObject then
	
		if "apply_shangzhuangkuang"==this.mxBankupChangeButton.spriteName then 
			if  not canBet then 
				--如果申请上庄  
				local chip_in = {type="nn100",tag="updealer"};   
				local jsonStr = cjson.encode(chip_in);
				this.mono:SendPackage(jsonStr);
			else
				--下注阶段无法申请上庄 
				this.mxErrorToast:Show(1.2, XMLResource.Instance:Str("mx_err_game_beting"));
			end
		else 
			if  not canBet then 
				local chip_in = {type="nn100",tag="downdealer"};   
				local jsonStr = cjson.encode(chip_in);
				this.mono:SendPackage(jsonStr);
			else 
				this.mxErrorToast:Show(1.2, "下注阶段无法申请下庄");
			end
			
		end
		
	end
end
function this:ShowBakupListAnim(show)

	local tf = this._5Layout:FindChild("BakupList");
	NGUITools.SetActive(this._5Layout.gameObject, show);
end
function this:CloseExitView()
	UISoundManager.Instance.PlaySound("but");	
	NGUITools.SetActive(this._8Layout.gameObject, false);
end
function this:CloseMarkView()

	NGUITools.SetActive(this._4Layout.gameObject, false);
	NGUITools.SetActive(this._6Layout.gameObject, false);
	NGUITools.SetActive(this._8Layout.gameObject, false);
	NGUITools.SetActive(this._7Layout.gameObject, false);
	NGUITools.SetActive(this._10Layout.gameObject, false);
	NGUITools.SetActive(this._11Layout.gameObject, false);
	NGUITools.SetActive(this._12Layout.gameObject, false);
	NGUITools.SetActive(this._13Layout.gameObject, false);
	if  not this._12Layout.gameObject.activeSelf or  not this._13Layout.gameObject.activeSelf then
		this.wuzuoPlayer = {}; 
	 end
	NGUITools.SetActive(this._14Layout.gameObject, false);
	NGUITools.SetActive(this._15Layout.gameObject, false);
	if NGUITools.GetActive(this._5Layout.gameObject) then
		this:ShowBakupListAnim(false);
	end
end
function this:CloseGame()
	UISoundManager.Instance.PlaySound("but");
	this:OnClickBack();
end
function this:ResetBakupList()
	
	
	for  i = 0,this.mBakupListGrid.transform.childCount-1 do
		destroy(this.mBakupListGrid.transform:GetChild(i).gameObject);
	end
	
	local prefab = this.mBakupListGrid.transform.parent:FindChild("ListViewItem").gameObject;
	local localScale = prefab.transform.localScale;
	
	local i = 0;
	for  key,player in ipairs(bankupInfos) do
	
		local sp = GameObject.Instantiate(prefab);
		sp.transform.parent = this.mBakupListGrid.transform;
		sp.transform.localScale = localScale;
		sp.transform.localPosition = Vector3.New(0, -(key-1) * 72, 0);
		NGUITools.SetActive(sp, true);
		sp.transform:FindChild("ItemLabel0"):GetComponent("UILabel").text = player.nickname;
		sp.transform:FindChild("ItemLabel1"):GetComponent("UILabel").text =  tostring(player.money);
		
	end
end
function this:ReturnInit()

	for  i = 1, 25 do
		local sp = this._2Layout:FindChild("Poker".. i):GetComponent("UISprite");
		sp.gameObject.transform.localPosition = this.pokePosition[i];
		sp.depth = 317 + (i - 1);
		sp.spriteName = "mx_poker_bg";
		sp.alpha = 0.0;
	end
	
	for  i = 0, 4 do
		NGUITools.SetActive(this._3Layout:FindChild("ChildSource".. i).gameObject, false);
	end
	NGUITools.SetActive(this.mxWaitGameInfo.gameObject, false);
	NGUITools.SetActive(this._4Layout.gameObject, false);
	this:CheckBetButtonEnable(false);
	this.mTimer:SetTime(0);
	canBet = false;
end
function this:ResetDeskAva()

	local avaList = {};
	for  i = 0, 5 do
		table.insert(avaList,Define.NN_AVATA_DBG[i+1]);	
	end
	
	local index = 0;
	for  i = 1, 4 do
		index = math.Random(1,#(avaList));
		deskinfos[i].bgound.spriteName = "kuang";
		avaList[index] = nil;
	end
end


--开始发牌的动画以及声音
function this:StartSendPokerAnim( pokers)
	local spobj = this._2Layout:FindChild("GameObject").gameObject;
	iTween.MoveTo(spobj,iTween.Hash ("x",-100,"islocal",true,"time",1.0,"easeType", iTween.EaseType.linear));  
	iTween.MoveTo(spobj,iTween.Hash ("x",0,"islocal",true,"time",0.8,"easeType", iTween.EaseType.linear,"delay",1.2));  
	local sp = spobj.transform:FindChild("Poker (1)"):GetComponent("UISprite");
	local scaleVec3 =Vector3.New(  math.abs(spRect[3] / sp.width),  math.abs(spRect[4] / sp.height), 0);
	for  j = 1,25 do
		local go = spobj.transform:FindChild("Poker ("..j..")"):GetComponent("UISprite");
		go.alpha=1.0;  
		go.transform.localScale = scaleVec3; 
		
		iTween.MoveTo(go.gameObject,iTween.Hash ("x",j*8,"islocal",true,"time",1.0,"easeType", iTween.EaseType.linear));  
		iTween.MoveTo(go.gameObject,iTween.Hash ("x",0,"islocal",true,"time",0.8,"easeType", iTween.EaseType.linear,"delay",1.2));  
	end 
	 local flyTime = 0.25
	local tempRun = function() 
		
		local v  = 0;
		for  i = 1,  5 do
			for  j = 0, 24, 5 do
				local d = v;
				v = v+1;
				local poker = this.pokers["Poker"..(i + j)]; 
				poker.Value = pokers[(i - 1) + j+1];
				poker.gameObject:GetComponent("UISprite").spriteName = "mx_poker_bg";
				
				local tempTime = poker:MoveFromNew(spRect[1], spRect[2], spRect[3], spRect[4], flyTime, d * 0.125);
				
				 
				local tempI = i  
				coroutine.start(this.AfterDoing,this, tempTime-0.05, function ()   
					if (tempI - 1) == 4 then
						poker.gameObject:GetComponent("UISprite").spriteName = "mx_poker_bg";
					else
						poker.gameObject:GetComponent("UISprite").spriteName = Define.NN_POKER_TYP[poker.Value+1];
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
	coroutine.start(this.AfterDoing,this,2,tempRun);
	return 2+0.125*24+flyTime;
end

--25张扑克牌动画
function this:ScaleChangePokerAnim()


	local poker = nil;
	local v = 0;
	
	for  i = 1, 5 do
		poker =this.pokers["Poker"..i]
		if (i - 1) == 4 then
			poker:ScaleChange(0.25, v);
		end
		v = v +0.01;
	end
	v = v +1;
	
	for  i = 6, 25 do
	
		poker =this.pokers["Poker"..i]
		if (i - 1) % 5 == 4 then
			poker:ScaleChange(0.25, v);
		end
		
		if (i - 1) > 5 and (i - 1) % 5 == 4 then
			v = v +1;
		else
			v = v +0.01;
		end
	end
	
end

function this:PaiXuFor(is,ie,pai,_type)
 
	local depths = 117;
	local xNum = this.pokePosition[is].x; 
	for  i = is, ie do 
		local poker = this.pokers["Poker"..i]
		if _type ~= 0 then 
			local index = i - (is-1);
			for  j = 0, #(pai)-1 do 
				if index == (tonumber(pai[j+1]) + 1) then
					if j == 0 or j == 1 then 
						local templocalPosition = Vector3.New(xNum + (j + 4) * 35.5 - 18, poker.transform.localPosition.y, 0); 
						iTween.MoveTo(poker.gameObject,iTween.Hash ("x",templocalPosition.x,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear)); 
						poker.Depth = depths + j + 3; 
					else
						local templocalPosition = Vector3.New(xNum + (j - 2) * 35 - 18, poker.transform.localPosition.y, 0); 
						iTween.MoveTo(poker.gameObject,iTween.Hash ("x",templocalPosition.x,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear)); 
						poker.Depth = depths + j - 2; 
					end
					
					coroutine.start(this.AfterDoing,this,0.1,function() 
											poker.transform:GetComponent("UISprite").depth = poker.Depth
										end);
				end

			end
		else  
			local tempSprite = poker.transform:GetComponent("UISprite")
			tempSprite.depth = tempSprite.depth - 100;
			iTween.MoveTo(poker.gameObject,iTween.Hash ("x",this.pokePosition[i].x,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear)); 
		end
	end
end
function this:PaiXu()

	local v = 0; 
	local depths =117;
	
	local tempRun5 = function ()   
		local tempNumPos = this.pokePosition[1].x;
		for  i = 1, 5 do 
			local poker = this.pokers["Poker"..i]
			if type_0 ~= 0 then  
				for  j = 0, #(pai_0)-1 do
					if i == (tonumber(pai_0[j+1]) + 1) then
						if j == 0 or j == 1 then
							local templocalPosition = Vector3.New(tempNumPos+ (j + 4) * 32-16, poker.transform.localPosition.y, 0);
							iTween.MoveTo(poker.gameObject,iTween.Hash ("x",templocalPosition.x,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear)); 
							poker.Depth = depths + j + 3; 
						else
							local templocalPosition = Vector3.New(tempNumPos + (j - 2) * 32-14, poker.transform.localPosition.y, 0);
							iTween.MoveTo(poker.gameObject,iTween.Hash ("x",templocalPosition.x,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear)); 
							poker.Depth = depths + j - 2; 
						end
						coroutine.start(this.AfterDoing,this,0.1,function() 
							poker.transform:GetComponent("UISprite").depth = poker.Depth
						end);

					end 
				end
			else  
				local tempSprite = poker.transform:GetComponent("UISprite")
				tempSprite.depth = tempSprite.depth - 100;
				iTween.MoveTo(poker.gameObject,iTween.Hash ("x",this.pokePosition[i].x,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear)); 
			end
		end
	end 
	coroutine.start(this.AfterDoing,this,v,tempRun5);
	v = v +1;
	
	
	local tempRun = function ()   
		this:PaiXuFor(6,10,pai_1,type_1) 
	end
	coroutine.start(this.AfterDoing,this,v,tempRun );
	v = v +1;
	
	local tempRun2 = function ()   
		this:PaiXuFor(11,15,pai_2,type_2) 
	end
	coroutine.start(this.AfterDoing,this,v,tempRun2);
	v = v +1;
	
	local tempRun3 = function ()   
		this:PaiXuFor(16,20,pai_3,type_3)
	end
	coroutine.start(this.AfterDoing,this,v,tempRun3)
	v = v +1;
	
	local tempRun4 = function ()   
		this:PaiXuFor(21,25,pai_4,type_4)
	end
	coroutine.start(this.AfterDoing,this,v,tempRun4);
	v = v +1;		
	
	
	
end




function this:cumulativeNum(_path)
	local sheng = 0;
	for  i = 1, #(_path) do
		if _path[i] > 0 then
			sheng = sheng +1;
		end
	end
	return sheng;
end
function this:gameEnter(json) 
	this:ReturnInit();
	local winzodics = json["body"]["path"];
	this.gameNum = 0
	paths = {};
	local leng = #(winzodics);
	if leng > 0 then
		local jsItem = nil;
		for  i = 1, leng do
			jsItem = winzodics[i];
			table.insert(paths,tonumber(jsItem[1]));
			table.insert(paths,tonumber(jsItem[2]));
			table.insert(paths,tonumber(jsItem[3]));
			table.insert(paths,tonumber(jsItem[4]));
			table.insert(path_1,tonumber(jsItem[1]));
			table.insert(path_2,tonumber(jsItem[2]));
			table.insert(path_3,tonumber(jsItem[3]));
			table.insert(path_4,tonumber(jsItem[4]));
		end
		 
                
        while(#(paths) > 36) do table.remove(paths,1); end
		Tools.drawPathGrid(this._6Layout:FindChild("GamePathView"):FindChild("PathViewGrid"), paths,35);
	end
	
	
	sheng_1 =sheng_1 +this:cumulativeNum(path_1);
	sheng_2 =sheng_2 +this:cumulativeNum(path_2);
	sheng_3 =sheng_3 +this:cumulativeNum(path_3);
	sheng_4 =sheng_4 +this:cumulativeNum(path_4);
	sheng_11 = math.ceil(sheng_1 /  #(path_1) * 100);
	sheng_22 = math.ceil (sheng_2 / #(path_2) * 100);
	sheng_33 = math.ceil (sheng_3 / #(path_3) * 100);
	sheng_44 = math.ceil(sheng_4 / #(path_4) * 100);
	this.shenglv_1.text =  tostring(sheng_11).."%";
	this.shenglv_2.text =  tostring(sheng_22).."%";
	this.shenglv_3.text =  tostring(sheng_33).."%";
	this.shenglv_4.text =  tostring(sheng_44).."%";
	
	
	local bealerID = tonumber(json["body"]["dealer"]);
	--进入游戏成员信息
	local jsarr = json["body"]["members"];
	--开始游戏时的座位列表
	local seat = json["body"]["seats"];
	
	local player = nil;
	local step = tonumber(json["body"]["step"]);
	players = {};
	for  i = 1,  #(jsarr) do
		player = GPlayer:New(jsarr[i]); 
		players[player.uid] = player; 
		if player.uid == tonumber(SocketConnectInfo.Instance.userId) then
			this.player = player;
			this.mxtxtPlyInfo6.text =  tostring(this.player.yuanbao);
		end
		table.insert(this.allPlayer,player.uid);
	end
	
	if seat~= nil then
		log(#(seat).."====在座人数");
		for  i = 1, #(seat) do
			local seatList = seat[i];
			local sit = this._9Layout:FindChild("sit_"..(i-1));
			local label_0 = sit:FindChild("LayoutLabel0"):GetComponent("UILabel");
			local label_1 = sit:FindChild("LayoutLabel1"):GetComponent("UILabel");
			local label_2 = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel");
			local sprite = sit:FindChild("LayoutBG"):FindChild("Sprite_1"):GetComponent("UISprite");
			
			if seatList ~= nil and type(seatList)== "table"  and  #(seatList)>0 then
				
				local playerInfo = this:GetPlayer(tonumber(seatList[1]));
				if playerInfo ~=nil then
					 
					label_0.text =this:LengNameSub(playerInfo.nickname);   
					log(label_0.text);
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
	
	if not  tableContains(this.sitPlayer,userId)   then
		havesit = false;
		this.mxStandUp.gameObject:GetComponent("BoxCollider").enabled = false;
		this.mxStandUp.gameObject:GetComponent("UIButtonColor").enabled = false;
		this.mxStandUp.alpha = 0.2; 
	end

	local binfos = json["body"]["dealers"];
	bankupInfos = {};
	for  i = 1, #(binfos) do
		table.insert(bankupInfos,this:GetPlayer(tonumber(binfos[i][1])));
	end
	this:ResetBakupList(); 
	--[[
	isSystem = toBoolean(binfos[1][3]);
	if isSystem then 
		this.tishi:GetComponent("UILabel").text = "系统坐庄";
	else 
		this.tishi:GetComponent("UILabel").text = "连庄次数：".. json["body"]["dealer_times"];
	end
	]]
	if bealerID ~= 0 then
		
		local bealer = this:GetPlayer(bealerID);
		
		if bealer ~= nil then
			this.banker = bealer;
			this.mxtxtPlyInfo0.text = this.banker.nickname;
		else
			this.mxtxtPlyInfo0.text = "玩家"
		end
		this:AddIconZhuang(bealer) 
		if   LengthUTF8String(this.mxtxtPlyInfo0.text) > 4 then
			this.mxtxtPlyInfo0.text =   SubUTF8String(this.mxtxtPlyInfo0.text,12);
		end
		--战绩
		this.mxtxtPlyInfo1.text = XMLResource.Instance:Str("mx_label_1")..json["body"]["dealer_winlost"];
		
		this.mxtxtPlyInfo3.text = EginUser.Instance.nickname;
		if  LengthUTF8String(this.mxtxtPlyInfo3.text ) > 7 then
			this.mxtxtPlyInfo3.text =   SubUTF8String(this.mxtxtPlyInfo3.text,21);
		end

		--战绩
		this.mxtxtPlyInfo4.text = XMLResource.Instance:Str("mx_label_4")..0;
		this.mxtxtPlyInfo5.text = tostring(json["body"]["mymoney"]);
		this.mxtxtPlyInfo5.text = this:uitextChange(this.mxtxtPlyInfo5.text);
		
	end
	if step == 0 then
		this.mxErrorToast:ShowToastNew3("text_4"); 
		this.mTimer:SetTime(0);
		return;
	end
	
	local timeout = tonumber(json["body"]["timeout"]);
	this.mTimer:SetTime(timeout);
	if step == 1 then
		this.mxErrorToast:ShowToastNew3("text_4");
		local mybetMoneys = json["body"]["mybetmoneys"];
		local albetMoneys = json["body"]["betmoneys"];
		for  i = 1, 4 do
		
			local betmoney = tonumber(mybetMoneys[i]);
			local allMoney = tonumber(albetMoneys[i]);
			local add = allMoney - deskinfos[i].allMoney;
			--实例化押注的筹码
			deskinfos[i]:updateDeskPool_4(jettonPrefab, add); 
			local tempRun = function()
				--筹码的声音的播放
				UISoundManager.Instance.PlaySound("nbet", 0);
			end
			coroutine.start(this.AfterDoing,this,0.25,tempRun); 
			deskinfos[i].allMoney = allMoney;
			deskinfos[i].betMoney = deskinfos[i].betMoney + betmoney; 
			deskinfos[i].betMoneytrue = deskinfos[i].betMoneytrue + betmoney;
			
			if allMoney > 0 then
			
				deskinfos[i].btextv0.text =  tostring(allMoney);
				NGUITools.SetActive(deskinfos[i].btextv0.gameObject, true);
			end
			if betmoney > 0 then
			
				deskinfos[i].btextv1.text = deskinfos[i].betMoney.."";
				NGUITools.SetActive(deskinfos[i].btextv1.gameObject, true);
			end
		end
		this:ResetDeskAva();
		this:CheckBetButtonEnable(true);
	elseif step == 2 then 
		--等待下一局的开始
		this.mxErrorToast:ShowToastNew3("text_4"); 
	elseif step == 3 then
		this.mxErrorToast:ShowToastNew3("text_4");
		--等待玩家就绪 
	end
	
	
end
function this:AddIconZhuang(tempZhuang) 

	this.IconZhuang:Play("zhuangHide"); 
	 
	local iszhuangIcon = false;
	for  i = 1,8 do
		local sit = this._9Layout:FindChild("sit_".. i); 
		if sit:FindChild("LayoutLabel0"):GetComponent("UILabel").text ~= nil and sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(tempZhuang.uid) then
		
			if i > 4 then
				this.IconZhuang.transform.localPosition = sit.localPosition:Add(Vector3.New(-63,63,0));
			else
				this.IconZhuang.transform.localPosition = sit.localPosition:Add(Vector3.New(63,63,0));
			end 
			this.IconZhuang:Play("zhuangPlay"); 
			 iszhuangIcon = true;
			break;
		end
	end 
	
	if not iszhuangIcon then 
		if tostring(SocketConnectInfo.Instance.userId) ==  tostring(tempZhuang.uid)  then  
			this.IconZhuang.transform.position = this._0Layout:FindChild("ChildLabel3/Sprite").position
			this.IconZhuang:Play("zhuangPlay");  
		end 
	end
	
end
function this:gameCome(json) 
	player = GPlayer:New(json["body"]);
	players[player.uid] = player;
	if player.uid ~= userId then
		table.insert(this.allPlayer,player.uid); 
	end
end

function this:gameLeave(json)

	local leaverID = tonumber(json["body"]);

	players[leaverID] = nil; 

	table.remove(this.allPlayer,tableKey(this.allPlayer,leaverID));
end
function this:gameWaitBankup(json)

	--等待玩家上庄
	this.mxWaitGameInfo.text = XMLResource.Instance:Str("mx_wait_bankup");
	NGUITools.SetActive(this.mxWaitGameInfo.gameObject, true);
end
function this:gameBankUpFail(json)

	--金钱不足xxx，无法上庄
	this.mxErrorToast:Show(2,SimpleFrameworkUtilstringFormat(XMLResource.Instance:Str("mx_updealer_fail_nomoney"), tonumber(json["body"])));
	this:CheckBetButtonEnable(true);
end
function this:gameBankUp(json)

	local uid = tonumber(json["body"][1]);
	if uid == tonumber(SocketConnectInfo.Instance.userId) then
		--申请下庄
		this.mxBankupChangeButton.spriteName = "xiazhuang";   
	end
	table.insert(bankupInfos,this:GetPlayer(uid) ) 
	this:ResetBakupList();
end
function this:gameBankDown(json)

	local uid = tonumber(json["body"][1]);
	if uid == tonumber(SocketConnectInfo.Instance.userId) then
		--申请上庄
		this.mxBankupChangeButton.spriteName = "apply_shangzhuangkuang"; 
	end
	table.remove(bankupInfos,tableKey(bankupInfos,this:GetPlayer(uid)))
	this:ResetBakupList();

	if #(bankupInfos) > 0 then
	
		local player = bankupInfos[1];
		if this.banker == nil or this.banker.uid ~= player.uid then
			baktime = 0;
			bakWinMoney = 0;
			this.mxtxtPlyInfo0.text = player.nickname;
			if   LengthUTF8String(this.mxtxtPlyInfo0.text) > 4 then
				this.mxtxtPlyInfo0.text =   SubUTF8String(this.mxtxtPlyInfo0.text,12);
			end
			--战绩
			this.mxtxtPlyInfo1.text = XMLResource.Instance:Str("mx_label_1")..bakWinMoney;
			--局数
			this.mxtxtPlyInfo2.text =  tostring(baktime);
			this:ResetBakupList();
			this.banker = player;
			
			--xxx上庄
			if tostring(SocketConnectInfo.Instance.userId) ==  tostring(player.uid)  then 
				this.mxErrorToast:ShowToastNew2("text_18");  
			else 
				this.mxErrorToast:ShowToastNew2("text_3");  
			end  
			this:AddIconZhuang(player)  
		end
	end
end
function this:gameBankUpdate(json)

	NGUITools.SetActive(this.mxWaitGameInfo.gameObject, false);
	local binfos = json["body"];
	bankupInfos = {};
	for  i = 1, #(binfos) do
		table.insert(bankupInfos,this:GetPlayer(tonumber(binfos[i][1])));
	end
	local player = bankupInfos[1];
	if this.banker == nil or this.banker.uid ~= player.uid then
	
		baktime = 0;
		bakWinMoney = 0;
		--昵称
		this.mxtxtPlyInfo0.text = player.nickname;
		if   LengthUTF8String(this.mxtxtPlyInfo0.text) > 4 then
			this.mxtxtPlyInfo0.text =   SubUTF8String(this.mxtxtPlyInfo0.text,12);
		end
		--战绩
		this.mxtxtPlyInfo1.text = XMLResource.Instance:Str("mx_label_1")..bakWinMoney;
		--局数
		this.mxtxtPlyInfo2.text = tostring(baktime + 1);
		this:ResetBakupList();
		
		--if tostring(SocketConnectInfo.Instance.userId) ==  tostring(this.banker.uid)  then 
		--	this.mxBankupChangeButton.spriteName = "apply_shangzhuangkuang";    
		--end
		this.banker = player;
		
		 
		 
		--xxx上庄
		if tostring(SocketConnectInfo.Instance.userId) ==  tostring(player.uid)  then 
			this.mxErrorToast:ShowToastNew2("text_18");  
		else 
			this.mxErrorToast:ShowToastNew2("text_3");  
		end  
		this:AddIconZhuang(player) 
	end
	isSystem = toBoolean(binfos[1][3]); 
	if isSystem then 
		this.tishi:GetComponent("UILabel").text = "系统坐庄";
	else 
		
		local name = this.sit_0:FindChild("LayoutLabel0"):GetComponent("UILabel");
		name.text =this:LengNameSub(player.nickname); 
		local money = this.sit_0:FindChild("LayoutLabel1"):GetComponent("UILabel");
		money.text =  tostring(player.money);
		money.text =    this:uitextChange(money.text);  --this:TextChange(money.text)   --
		
		this.sit_0:FindChild("LayoutLabel_id"):GetComponent("UILabel").text =  tostring(player.uid);
		this.sit_0:FindChild("LayoutBG"):FindChild("Sprite_1"):GetComponent("UISprite").spriteName = "avatar_".. (player.avatar + 1);

		--this.heguan.gameObject:SetActive(false);
		this.tishi:GetComponent("UILabel").text = "连庄次数：".. this.mxtxtPlyInfo2.text;
	end
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

function this:gameWaitBet(json)
	--开始下注请求
	this.mxErrorToast:EndToastNew3();
	this.BetXiaZhu = true;
	local timeout = tonumber(json["body"]["timeout"]);
	NGUITools.SetActive(this.mxWaitGameInfo.gameObject, false);
	this.mxErrorToast:ShowToastNew1("text_1"); 
	--增加游戏次数
	this.gameNum = this.gameNum +1;
	this.repetition = true;
	
	this.ReBetBtn:GetComponent('UIButton').isEnabled = false
	for i = 0, 3 do
		if xiashuMyArrHou[i] ~= 0 then
			this.ReBetBtn:GetComponent('UIButton').isEnabled = true
			break;
		end
	end 
	
	this.mTimer:SetTime(timeout);
	this:ResetDeskAva();
	this:CheckBetButtonEnable(true);
	canBet = true
	this.DeskBetArr ={[0]=0,[1]=0,[2]=0,[3]=0};
	xiashuMyNum = 0;
	UISoundManager.Instance.PlaySound("nstbet2"); 
	coroutine.start(this.AfterDoing,this,1.0,function ()    
		UISoundManager.Instance:PlaySound("nstbet");
	end);
	
end
function this:gameBadBet(json)

	local errCode = tonumber(json["body"]);
	-- print(json["body"])
	
	local errMsg = nil;
	if errCode >=0 and errCode <=3 then
		errMsg = XMLResource.Instance:Str("mx_bet_err_"..errCode);
	end

	if errMsg ~= nil then
	
		this.mxErrorToast:Show(1.2, errMsg);
		if errCode == 1 or errCode == 2 then
			local sp = nil;
			if this.mxbtnBet0.value then
				this.mxbtnBet0.value = false;
				this.mxbtnBet0:GetComponent("BoxCollider").enabled = false;
				sp = this.mxbtnBet0.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 0.2;
			elseif this.mxbtnBet1.value then
				this.mxbtnBet1.value = false;
				this.mxbtnBet1:GetComponent("BoxCollider").enabled = false;
				sp = this.mxbtnBet1.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 0.2;
			elseif this.mxbtnBet2.value then
				this.mxbtnBet2.value = false;
				this.mxbtnBet2:GetComponent("BoxCollider").enabled = false;
				sp = this.mxbtnBet2.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 0.2;
			elseif this.mxbtnBet3.value then
				this.mxbtnBet3.value = false;
				this.mxbtnBet3:GetComponent("BoxCollider").enabled = false;
				sp = this.mxbtnBet3.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 0.2;
			elseif this.mxbtnBet4.value then
				this.mxbtnBet4.value = false;
				this.mxbtnBet1:GetComponent("BoxCollider").enabled = false;
				sp = this.mxbtnBet4.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 0.2;
			elseif this.mxbtnBet5.value then
				this.mxbtnBet5.value = false;
				this.mxbtnBet5:GetComponent("BoxCollider").enabled = false;
				sp = this.mxbtnBet5.transform:FindChild("ButtonBG0"):GetComponent("UISprite");
				sp.alpha = 0.2;
			end
		else
			this:CheckBetButtonEnable(false);
		end
	end
end


function this:gameMyBet(json) 
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
 
	
	if arrxia ==nil then 
		if (this.repetition) then
			this.repetition = false
			this.ReBetBtn:GetComponent('UIButton').isEnabled = false
		end 
		
	end 
	xiashuMyArr[index] = xiashuMyArr[index]+betmoney 
	
	local add = allMoney - deskinfos[index+1].allMoney;

	local money = this.mxtxtPlyInfo5.text;
	money =  string.gsub(money,",", "");
	local mymoney = tonumber(money);
	mymoney = mymoney -tonumber(betmoney);
	this.mxtxtPlyInfo5.text =  tostring(mymoney);
	this.mxtxtPlyInfo5.text = this:uitextChange(this.mxtxtPlyInfo5.text);
	this.player.money = mymoney;
	
	
	if   tableContains(this.sitPlayer,userId) then
	
		for  i = 1, 8 do
		
			local sit = this._9Layout:FindChild("sit_".. i);
			if sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(userId) then
			
				sit:FindChild("LayoutLabel1"):GetComponent("UILabel").text = this.mxtxtPlyInfo5.text;
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
		deskinfos[index+1]:updateDeskPool_4(jettonPrefab, add, this.target_[index+1]);
	  
	else
		if #this.DeskPoolArr < 31 then
			table.insert(this.DeskPoolArr, DeskPoolInfo:New(deskinfos[index+1],jettonPrefab, add, nil))
		end
		 --[[
		local owner = this:GetPlayer(userId);
		if owner ~= nil then
			owner.money = owner.money -add; 
		end
		]]
	end
 
	 
	deskinfos[index+1].kuangliang.alpha = 1; 
	deskinfos[index+1].allMoney = allMoney;
	deskinfos[index+1].betMoney = deskinfos[index+1].betMoney +betmoney;
	if allMoney > 0 then
		deskinfos[index+1].btextv0.text =  tostring(allMoney);
		NGUITools.SetActive(deskinfos[index+1].btextv0.gameObject, true);
	end
	
	if betmoney > 0 then
		deskinfos[index+1].btextv1.text = deskinfos[index+1].betMoney.."";
		NGUITools.SetActive(deskinfos[index+1].btextv1.gameObject, true);
	end
end

function this:gameBet(json)
	-- print('========= json  =======')
		-- print(cjson.encode(json) )
	local curTime = Tools.CurrentTimeMillis();
	local body = json["body"];
	local allMoney = tonumber(body[2]);
	local index = tonumber(body[1]);
	local otherid = tonumber(body[3]);
	-- print( deskinfos[index+1])
	local add = allMoney - deskinfos[index+1].allMoney;

	if tableContains(this.sitPlayer,otherid) then
	
		betcount = betcount +1;
		if betcount % 3 == 0 then
			for  i = 1, 12 do
				local sit = this._9Layout:FindChild("sit_".. i);
				if sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(otherid) then
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
					if index == 3 then
						this.target_[index+1].localPosition = this.target_3[i].localPosition;
					end
					break;
				end
			end
			deskinfos[index+1]:addSitBetArr(tostring(otherid))
			deskinfos[index+1]:updateDeskPool_4(jettonPrefab, add, this.target_[index+1]);
			 
			--table.insert(this.DeskPoolArr, DeskPoolInfo:New(deskinfos[index+1],jettonPrefab, add, this.target_[index+1]))
			 
		end
	else
		if #this.DeskPoolArr < 31 then
			table.insert(this.DeskPoolArr, DeskPoolInfo:New(deskinfos[index+1],jettonPrefab, add, nil))
		end
		
		--deskinfos[index+1]:updateDeskPool_4(jettonPrefab, add);
		local owner = this:GetPlayer(otherid);
		if owner ~= nil then
			owner.money = owner.money -add;
		end
	end

	if curTime - bettime > 60 then
		--[[
		local tempRun = function()
			UISoundManager.Instance.PlaySound("nbet");
		end
		
		coroutine.start(this.AfterDoing,this ,0.25,tempRun);
		]]
		bettime = curTime;
	end
	deskinfos[index+1].allMoney = allMoney;
	deskinfos[index+1].btextv0.text =  tostring(allMoney);
	NGUITools.SetActive(deskinfos[index+1].btextv0.gameObject, true);
end

local timeoutSurplus = 0;

function this:gameOver(json)
	 
	this.mxErrorToast:ShowToastNew1("text_2");
	for  j = 1,4 do 
		deskinfos[j].DeskBetPoolArr = {}
	end     
	this.BetXiaZhu = false;
	--本局下注记录 
	xiashuMyArrHou = xiashuMyArr 
	xiashuMyArr =  {[0]=0,[1]=0,[2]=0,[3]=0}; 
	
	this.ReBetBtn:GetComponent('UIButton').isEnabled = false
	betcount = 0;
	canBet = false;
	local body = json["body"]; 
	local timeout = tonumber(body["timeout"]);
	
	this:CheckBetButtonEnable(false);
	UISoundManager.Instance.PlaySound("nspbet");
	baktime=baktime+1;
	local mywin = tonumber(body["mywin"]);
	plyWinMoney = plyWinMoney +mywin;
	local dealerwin = tonumber(body["dealer_win"]);
	bakWinMoney = bakWinMoney +dealerwin;
	Tools.SetLabelForColorMX(this.mxFinalSettle0,this.mxFinalSettleAdd0, dealerwin); 
	Tools.SetLabelForColorMX(this.mxFinalSettle1,this.mxFinalSettleAdd1, mywin);  
	 local winTop4 = body["top4_wins"];
	 
	 this.mybetNum = 0;
	this.betNumAll = 0;   
	for  i = 1, 4 do 
		this.mybetNum  = this.mybetNum  + tonumber(deskinfos[i].betMoneytrue);
		deskinfos[i].btextv1.text = deskinfos[i].betMoneytrue.."";
		this.betNumAll = this.betNumAll  +tonumber(deskinfos[i].allMoney); 
	end  
	this.mxFinalSettle2.text = tostring(this.mybetNum)
	this.mxFinalSettle3.text = tostring(body["pot"]) 
	this.mybetNum = 0;
	this.betNumAll = 0;
	local winzodics = body["win_zodics"];

	table.insert(path_1,tonumber(winzodics[1]))
	table.insert(path_2,tonumber(winzodics[2]))
	table.insert(path_3,tonumber(winzodics[3]))
	table.insert(path_4,tonumber(winzodics[4]))
	
	if tonumber(winzodics[1]) > 0 then
		sheng_1 =sheng_1 + 1;
	end
	if tonumber(winzodics[2]) > 0 then
		sheng_2 =sheng_2 + 1;
	end
	if tonumber(winzodics[3]) > 0 then
		sheng_3 = sheng_3 +1;
	end
	if tonumber(winzodics[4]) > 0 then
		sheng_4 =sheng_4 + 1;
	end
	sheng_11 = math.ceil(sheng_1 / #(path_1) * 100);
	sheng_22 = math.ceil(sheng_2 / #(path_2) * 100);
	sheng_33 = math.ceil(sheng_3 / #(path_3) * 100);
	sheng_44 = math.ceil(sheng_4 / #(path_4) * 100);



	local winz = 0;
	if  #(winzodics) > 0 then
		local v = 0
		for  i = 1,  4 do
		
			v = tonumber(winzodics[i]);
			table.insert(paths,v);
			if v < 0 then
				winz =  winz +1 ;
			end 
			this.kuang[i].gameObject:SetActive(false);
		 
		end
		while(#(paths) > 36) do table.remove(paths,1); end
	end
	local t = winz;
	local moneys = body["moneys"];
	for  i = 1, #(moneys) do
	
		local jsarr = moneys[i];
		local player = this:GetPlayer(tonumber(jsarr[1]));
		if player ~= nil then
			player.money = tonumber(jsarr[2]);
		end
	end
	
	local hands = body["hands"];

	for  i = 1,#(hands[1][1]) do
		table.insert(pai_0,tonumber(hands[1][1][i]));
	end
	for  i = 1,#(hands[2][1]) do
	
		table.insert(pai_1,tonumber(hands[2][1][i]));
	end
	for  i = 1,#(hands[3][1]) do
	
		table.insert(pai_2,tonumber(hands[3][1][i]));
	end
	for  i = 1,#(hands[4][1]) do
	
		table.insert(pai_3,tonumber(hands[4][1][i]));
	end
	for  i = 1,#(hands[5][1]) do
	
		table.insert(pai_4,tonumber(hands[5][1][i]));
	end
	type_0 = tonumber(hands[1][2]);
	type_1 = tonumber(hands[2][2]);
	type_2 = tonumber(hands[3][2]);
	type_3 = tonumber(hands[4][2]);
	type_4 = tonumber(hands[5][2]);

	pai_0 = BestPaiXu.getBestPaiType(pai_0, type_0);
	pai_1 = BestPaiXu.getBestPaiType(pai_1, type_1);
	pai_2 = BestPaiXu.getBestPaiType(pai_2, type_2);
	pai_3 = BestPaiXu.getBestPaiType(pai_3, type_3);
	pai_4 = BestPaiXu.getBestPaiType(pai_4, type_4);

	this:DebugArray(pai_0);
	this:DebugArray(pai_1);
	this:DebugArray(pai_2);
	this:DebugArray(pai_3);
	this:DebugArray(pai_4);

	local sources = body["mypool"];
	local handinfo = nil;
	local bealerType = -1;
	local cards = {};
	local music_index = {};
	local d = 1;
	local nntypezhuang = 0;
	local niuXing = {};
	for  i = 0,   #(hands)-1 do
		handinfo = hands[i+1];
		for  j = 1, 5 do
			cards[d] = tonumber(handinfo[1][j]);
			d = d+1;
		end
		local typeC = tonumber(handinfo[2]);

		if i == 0 then
			bealerType = typeC;
			if typeC <= 1 then
				bealerType = 1;
			end
		end
		local text = nil;
		if i == 0 then
			
			local label = nntype[typeC];
			this._3Layout:FindChild("ChildSource".. i):FindChild("SourceLabel"):GetComponent("UILabel").text = label;
			local niuniu = 0;
			niuniu = this:SelectNiuniuType(label);
			niuXing[0] = niuniu;
			music_index[i+1] = niuniu;
			local sprite = this._3Layout:FindChild("ChildSource".. i):FindChild("SourceBG"):GetComponent("UISprite");
			sprite.spriteName = "niu_".. niuniu;
			if niuniu>12 then
				sprite.width=154;
			else
				sprite.width=104;
			end
			nntypezhuang = niuniu;
		else
			local money = tonumber(sources[i]);
			local formStr = nil;
			if money > 0 then
				--牌型+倍数+/n+钱数
				formStr = XMLResource.Instance:Str("mx_settle_fmat_0");
				text = System.String.Format (formStr, nntype[typeC], typeC, money);
			elseif money < 0 then
				--牌型+倍数+/n+钱数
				formStr = XMLResource.Instance:Str("mx_settle_fmat_1");
				text = System.String.Format (formStr, nntype[typeC], bealerType, money);
			else
				--牌型+无成绩
				formStr = XMLResource.Instance:Str("mx_settle_fmat_2");
				text = System.String.Format (formStr, nntype[typeC], money);
			end
			
			local niu_q = ""
			local beishu_q = "beishu_"
			if   tonumber(winzodics[i]) > 0  then
				 
			else
				niu_q = "_gray"
				beishu_q = "l_beishu_"
			end
			
			local label = this._3Layout:FindChild("ChildSource".. i):FindChild("SourceLabel"):GetComponent("UILabel");
			label.text = nntype[typeC];
			local niuniu = 0;
			
			niuniu = this:SelectNiuniuType(label.text);
			 
			niuXing[i] = niuniu;
			music_index[i+1] = niuniu;
			local sprite = this._3Layout:FindChild("ChildSource".. i):FindChild("SourceBG"):GetComponent("UISprite");
			
			sprite.spriteName = "niu_".. niuniu..niu_q;
			if niuniu>12 then
				sprite.width=154;
			else
				sprite.width=104;
			end
			
			if niuniu == 0 then
				this.beishu[i].spriteName = beishu_q.."1";
			elseif niuniu == 11 or niuniu == 12 or  niuniu == 13 or niuniu == 14 then
				this.beishu[i].spriteName = beishu_q.."10";
			else
				this.beishu[i].spriteName = beishu_q..niuniu;
			end
			--有没有下注
			if not  deskinfos[i].btextv1.gameObject.activeSelf then
				this.beishu[i].spriteName = "meiyouxiazhu";
			end
			this.beishu[i]:MakePixelPerfect();
			
			this.expsObj[label.transform.parent.name] = ExpsObj:New(label.transform.parent);
			this.expsObj[label.transform.parent.name].ObjRef =   {text, money, "22ff22", "ff2222" };
		end
	end
	coroutine.wait(1.9); 
	timeout = timeout-2;
	local timeshow = 12;
	this.mTimer:SetTime(timeshow); 
	timeoutSurplus = timeout-timeshow;
	--发牌动画的播放
	local TempTimtA = this:StartSendPokerAnim(cards); 
	--翻牌
	coroutine.start(this.AfterDoing,this,TempTimtA,function() this:ScaleChangePokerAnim();  end); 
	TempTimtA =TempTimtA+0.5
	--合牌
	coroutine.start(this.AfterDoing,this,TempTimtA,function()
		 
		local v = 0;
		
		for  i = 1, 5 do
			local poker =this.pokers["Poker"..i]
			iTween.MoveTo(poker.gameObject,iTween.Hash ("x",this.pokers["Poker3"].transform.localPosition.x,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear,"delay",v)); 
		end  
		v = v +1; 
		local tempNum = 8;
		for  i = 6, 25 do 
			local poker =this.pokers["Poker"..i]
			iTween.MoveTo(poker.gameObject,iTween.Hash ("x",this.pokers["Poker"..tempNum].transform.localPosition.x,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear,"delay",v));  
 
			if (i - 1) > 5 and (i - 1) % 5 == 4 then
				v = v +1; 
				tempNum = tempNum+5;
			end
		end
		 
	end); 
	
	--排序
	TempTimtA =TempTimtA+0.3
	coroutine.start(this.AfterDoing,this,TempTimtA,function() this:PaiXu();  end);
	 
	--牌型
	local tempRun = function()  
		local v = 0.3;
		local index = 0;
		
		coroutine.start(this.AfterDoing,this,v, function()
		
			NGUITools.SetActive(this._3Layout:FindChild("ChildSource".. index).gameObject, true);
			UISoundManager.Instance.PlaySound("Cow".. music_index[index+1]);
			this.shuyingkuang.gameObject:SetActive(true);
			local tempBG = this._3Layout:FindChild("ChildSource".. index.."/Sprite").gameObject:GetComponent("UISprite");
			 tempBG:MakePixelPerfect();
			 
			 if niuXing[0] ~= 0 then
				tempBG.width = tempBG.width+5
			else
				tempBG.width = tempBG.width
			 end
			
		end);
		v = v +1;
		
		for  i = 1, 4 do
			local index = i;
			coroutine.start(this.AfterDoing,this,v, function()
				NGUITools.SetActive(this._3Layout:FindChild("ChildSource".. index).gameObject, true);
				UISoundManager.Instance.PlaySound("Cow".. music_index[index+1]); 
				local tempBG = this._3Layout:FindChild("ChildSource".. index.."/Sprite").gameObject:GetComponent("UISprite");
				tempBG:MakePixelPerfect();
				if niuXing[i] ~= 0 then
					tempBG.width = tempBG.width+20
				else
					tempBG.width = tempBG.width-10
				end 
				if  tonumber(winzodics[index]) > 0 then  
					this.kuang[index].gameObject:SetActive(true);  
				else
					this.kuang[index].gameObject:SetActive(false);
				end
			end);
			v = v +1;
		end
			
	end
	--各个牌型的显示
	coroutine.start(this.AfterDoing,this,TempTimtA,tempRun);

	
	local temp8SitWin = {}
	for  i = 1,8 do 
		local sit = this._9Layout:FindChild("sit_".. i);
		local idSit = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text;
		local tempwin ={};
		if idSit ~= "" then   
			
			for  j = 1,4 do 
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
	 
	 --飞金币前缓动坐标准备
	coroutine.start(this.AfterDoing,this,timeshow-3, function() 
		  
		for  j = 1,4 do 
			deskinfos[j]:ReadyBetExcursionAll();
		end     
	end);
	--飞金币前在座玩家金币准备
	coroutine.start(this.AfterDoing,this,timeshow-3, function() 
		 
		  
		for  i = 1,8 do 
			for  j = 1,4 do 
				if  temp8SitWin[i][j] ~= nil then  
					local tempLocalPos = 0;
					if j == 1 then
						tempLocalPos = this.target_0[i].localPosition;
					elseif j == 2 then
						tempLocalPos= this.target_1[i].localPosition;
					elseif j == 3 then
						tempLocalPos = this.target_2[i].localPosition;
					elseif j == 4 then
						tempLocalPos = this.target_3[i].localPosition;
					end  
					table.insert(deskinfos[j].sitArr,tempLocalPos); 
				end 
			end    
		end  
		
		for  j = 1,4 do 
			deskinfos[j]:ReadySitArrBet();
		end     
	end);
	--数据计算和显示
	coroutine.start(this.AfterDoing,this,timeshow-1, function() 
		for  i = 1,4 do
			local trans = this._3Layout:FindChild("ChildSource".. i);
			local refObjs =this.expsObj[trans.name].ObjRef;
			Tools.SetLabelForColor5(trans:FindChild("SourceLabel"):GetComponent("UILabel"),tostring(refObjs[1]),tonumber(refObjs[2]), tostring(refObjs[3]), tostring(refObjs[4]));
		end
		local cplayer = bankupInfos[1];
		this.mxtxtPlyInfo0.text = cplayer.nickname;
		if   LengthUTF8String(this.mxtxtPlyInfo0.text) > 4 then
			this.mxtxtPlyInfo0.text =   SubUTF8String(this.mxtxtPlyInfo0.text,12);
		end
		--战绩
		this.mxtxtPlyInfo1.text = XMLResource.Instance:Str("mx_label_1")..bakWinMoney;
		--局数
		this.mxtxtPlyInfo2.text = XMLResource.Instance:Str("mx_label_2")..baktime;
		this.mxtxtPlyInfo3.text = EginUser.Instance.nickname;
		if  LengthUTF8String(this.mxtxtPlyInfo3.text ) > 7 then
			this.mxtxtPlyInfo3.text =   SubUTF8String(this.mxtxtPlyInfo3.text,21);
		end
		--战绩
		this.mxtxtPlyInfo4.text = XMLResource.Instance:Str("mx_label_4")..plyWinMoney;
		--游戏币
		this.mxtxtPlyInfo5.text =  tostring(this.player.money);
		this.mxtxtPlyInfo5.text = this:uitextChange(this.mxtxtPlyInfo5.text);
		
		  
	end);
	
	
	--飞金币显示最后的结算信息
	coroutine.start(this.AfterDoing,this,timeshow, function() 
		this.mTimer:SetTime(timeoutSurplus);  
		
		 --有座玩家特效
		local tempRunsit = function()
			 
			for  i = 1,8 do
				  
				local sit = this._9Layout:FindChild("sit_".. i);
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
				for  i = 1,4 do
					deskinfos[i].sitBetArr = {}
				end  
				for  i = 1,8 do 
					this._9Layout:FindChild("sit_".. i):FindChild("win").gameObject:SetActive(false); 
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
			for  i = 1,4 do
				if  tonumber(winzodics[i]) > 0 then 
					local deskinfobj = deskinfos[i]; 
					local countjettons = #(deskinfobj.jettons)
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
			for  i = 1,4 do
				if  tonumber(winzodics[i]) <= 0 then
					deskinfos[i]:OnLineControlM(30);
					deskinfos[i]:ResetView_0(tonumber(winzodics[i]));
				end
			end 
		end
		--金币飞回改去的位置
		local tempRunjinbi = function() 
			for  i = 1,4 do   
				deskinfos[i]:OnLineControlM(25-(#(deskinfos[i].sitBetShootArr)*3));
				deskinfos[i]:ResetView_0(tonumber(winzodics[i]));
			end 
		end
		--在座玩家的金币飞回
		local tempidSitPos = function() 
			for  i = 1,4 do 
				deskinfos[i]:ShootSitArrBet()  
			end 
		end
		
		local timeT = 0;
		if t == 4 then 
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
				tempRunjinbiTu();
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
			tempRunsit()
		end);
	end);
	
	local timeTemp = -0.5
	if t == 4 then 
		  timeTemp = 3
	elseif t == 0 then 
		timeTemp = 1 
	end 
	local tempGameNum = this.gameNum;
	--显示最后的结算信息
	coroutine.start(this.AfterDoing,this,timeshow+9-timeTemp, function() 
	
		this.mxFinalSettle4.text = tostring(math.floor(this.mTimer.endTime))
		NGUITools.SetActive(this._4Layout.gameObject, true);
		this.shuyingkuang.gameObject:SetActive(false);
		
		this.titleSheng:SetActive(false);
		this.titleBai:SetActive(false);
		this.titlePing:SetActive(false);
		this.titleTongChi:SetActive(false);
		this.titleTongPei:SetActive(false);
		 
		local tempSound = "win"
		local tempAnimationNum = 0;
		if mywin>0 then
			tempAnimationNum = 0; 
		elseif mywin<0 then
			tempAnimationNum = 1; 
			 tempSound = "lose"
		else
			tempAnimationNum = 2; 
			tempSound = "draw"
		end
		
		if t == 4 then 
			tempAnimationNum = 3; 
		elseif t == 0 then 
			tempAnimationNum = 4;
			 tempSound = "lose" 
		end
		UISoundManager.Instance.PlaySound(tempSound);
		
		--从新播放面板显示动画
		if tempAnimationNum == 0 then  
			this.titleSheng:SetActive(true);
			this.titleShengAnim1:Play();
			this.titleShengAnim2:Play();
		elseif tempAnimationNum == 1 then  
			this.titleBai:SetActive(true);
			this.titleBaiAnim1:Play();
		elseif tempAnimationNum == 2 then  
			this.titlePing:SetActive(true);
			this.titlePingAnim1:Play();
			this.titlePingAnim2:Play();
		elseif tempAnimationNum == 3 then 
			this.titleTongChi:SetActive(true);
			this.titleTongChiAnim1:Play();
		elseif tempAnimationNum == 4 then  	 
			this.titleTongPei:SetActive(true);
			this.titleTongPeiAnim1:Play();
			this.titleTongPeiAnim2:Play();
		end
		
		--this.PanelAnim:ResetToBeginning()
		--this.PanelAnim:Play()
		
		Tools.drawPathGrid(this._6Layout:FindChild("GamePathView"):FindChild("PathViewGrid"), paths,23);
		this.shenglv_1.text =  sheng_11.."%";
		this.shenglv_2.text =  sheng_22.."%";
		this.shenglv_3.text =  sheng_33.."%";
		this.shenglv_4.text =  sheng_44.."%";
		pai_0={}; 
		pai_1={}; 
		pai_2={};
		pai_3={}; 
		pai_4={};
		 
		--前4名
		if winTop4 ~= nil then
			for i=1,4 do
				if winTop4[i] ~= nil then
					local winId = tonumber(winTop4[i][1])  
					local winIdM =  tonumber(winTop4[i][2])
					local winPlayer = this:GetPlayer(winId)
					if winPlayer ~= nil then 
						this.winTop4LabelName[i].text = winPlayer.nickname;  
						Tools.SetLabelForColorMX(this.winTop4LabelMoney[i],this.winTop4LabelAddMoney[i], winIdM);   
					end
				end
			end
		end 
		
		if tempGameNum ~= this.gameNum then
			coroutine.start(this.AfterDoing,this,1, function()  
				NGUITools.SetActive(this._4Layout.gameObject, false);
			end);
		end 
	end);
end

function this:playsound()
	UISoundManager.Instance.PlaySound("nbet");
end

function this:DebugArray( pai_0)
	local str = "";
	for  i = 1, #(pai_0) do
		str = str..pai_0[i]..",";
	end
end
function this:gameFreeTime(json)

	this:ReturnInit();
	local timeout = tonumber(json["body"]);
	this.mTimer:SetTime(timeout);
	--this.mxErrorToast:ShowToastNew3("text_4");
	--等待玩家就绪
	--this.mxWaitGameInfo.text = XMLResource.Instance:Str("mx_wait_ready");
	--NGUITools.SetActive(this.mxWaitGameInfo.gameObject, true);
end


function this:gameSitDown(json)  
	local body = json["body"];
	local id = tonumber(body["members"][1]);
	local nickname = body["members"][2];
	local number = tonumber(body["no"]);
	
	local playerinfo = this:GetPlayer(id);

	if playerinfo == nil then  return; end
	local target = this._9Layout:FindChild("sit_".. number);
	local name = target:FindChild("LayoutLabel0"):GetComponent("UILabel");
	local localName = this:LengNameSub(nickname);  
	
	
	if name.text ~= localName then
		name.text = localName;  
		table.insert(this.sitPlayer,id);
		 
		target:FindChild("mykuang").gameObject:SetActive(false); 
		 
		local money = target:FindChild("LayoutLabel1"):GetComponent("UILabel");
		 
		if id == userId then
		
			this.player = playerinfo;
			havesit = true;
			-- this.mxStandUp.gameObject:GetComponent("BoxCollider").enabled = true;
			-- this.mxStandUp.gameObject:GetComponent("UIButtonColor").enabled = true;
			-- this.mxStandUp.alpha = 1.0;
			
			target:FindChild("mykuang").gameObject:SetActive(true);
			coroutine.start(this.AfterDoing,this,4,function() target:FindChild("mykuang").gameObject:SetActive(false)  end) 
		 
			 
			money.text = this.mxtxtPlyInfo5.text;
			
			local aa = GameObject.Instantiate(this.jiantou);
			aa.transform.parent = target.transform;
			aa.transform.localPosition = Vector3.zero;
			aa.transform.localScale = Vector3.New(2.1,2.1,2.1);
			coroutine.start(this.AfterDoing,this,1, function()
				destroy(aa);
			end);
		else
			local aa = GameObject.Instantiate(this.switchSeatAnima);
			aa.transform.parent = target.transform;
			aa.transform.localPosition = Vector3.zero;
			aa.transform.localScale = Vector3.New(1,1,1);
			coroutine.start(this.AfterDoing,this,1, function()
				destroy(aa);
			end);
		
			money.text =  tostring(playerinfo.money);
			money.text =  this:uitextChange(money.text);   --this:TextChange(money.text) 
			
		end

		target:FindChild("LayoutLabel_id"):GetComponent("UILabel").text =  tostring(id);
		target:FindChild("LayoutBG"):FindChild("Sprite_1"):GetComponent("UISprite").spriteName = "avatar_".. (playerinfo.avatar + 1);
	
	
	end
	
	
	
end

function this:gameSitUp(json)

	local body = json["body"];
	local id = tonumber(body["members"][1]);
	local nickname = tostring(body["members"][2]) ;
	local number = tonumber(body["no"]);

	local tempSit = this._9Layout:FindChild("sit_".. number);
	if id == userId then
		havesit = false;
		this.mxStandUp.gameObject:GetComponent("BoxCollider").enabled = false;
		this.mxStandUp.gameObject:GetComponent("UIButtonColor").enabled = false;
		this.mxStandUp.alpha = 0.2;
		
		
		
		tempSit:FindChild("mykuang").gameObject:SetActive(false);
	end
	tableRemove(this.sitPlayer,id);
	
	tempSit:FindChild("LayoutLabel0"):GetComponent("UILabel").text = "";
	tempSit:FindChild("LayoutLabel1"):GetComponent("UILabel").text = "";
	tempSit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text = "";
	tempSit:FindChild("LayoutBG/Sprite_1"):GetComponent("UISprite").spriteName = "avatar_w";
	--
	
end

function this:gameSitDown_Fail(json)

	local errCode = tonumber(json["body"]);
	local errMsg = nil;
	if errCode>=0 and errCode <=3 then
		errMsg = XMLResource.Instance:Str("mx_bet_err_"..(errCode+4));
	end
	
	if errMsg ~= nil then
		this.mxErrorToast:Show(1.2, errMsg);
	end
end


function this:gameEmotion(json)

	local body = json["body"];
	local id = tonumber(body[1]);
	local num = tostring(body[2]);
	local number = tonumber(num);

	for  i = 1,12 do
		local sit = this._9Layout:FindChild("sit_".. i);
		if sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(id) then
			own = sit;
			local aa = GameObject.Instantiate(this.biaoqing[number+1]);
			aa.transform.parent = own;
			aa.transform.localScale = Vector3.one;
			aa.transform.localPosition=Vector3.zero;
			if number==0 then
				aa.transform.localPosition=Vector3.New(0,0,0);
			elseif number==1 then
				aa.transform.localPosition=Vector3.New(-5,7,0);
			elseif number==2 then
				aa.transform.localPosition=Vector3.New(-5,8,0);
			elseif number==3 then
				aa.transform.localPosition=Vector3.New(0,15,0);
			elseif number==4 then
				aa.transform.localPosition=Vector3.New(-3,12,0);
			elseif number==5 then
				aa.transform.localPosition=Vector3.New(0,13,0);
			elseif number==6 then
				aa.transform.localPosition=Vector3.New(-6,5,0);
			elseif number==7 then
				aa.transform.localPosition=Vector3.New(15,15,0);
			elseif number==8 then
				aa.transform.localPosition=Vector3.New(-5,25,0);
			elseif number==9 then
				aa.transform.localPosition=Vector3.New(0,20,0);
			elseif number==10 then
				aa.transform.localPosition=Vector3.New(0,0,0);
			elseif number==11 then
				aa.transform.localPosition=Vector3.New(-30,0,0);
			elseif number==12 then
				aa.transform.localPosition=Vector3.New(0,-30,0);
			elseif number==13 then
				aa.transform.localPosition=Vector3.New(0,0,0);
			elseif number==14 then
				aa.transform.localPosition=Vector3.New(-5,5,0);
			elseif number==15 then
				aa.transform.localPosition=Vector3.New(0,15,0);
			elseif number==16 then
				aa.transform.localPosition=Vector3.New(0,0,0);
			elseif number==17 then
				aa.transform.localPosition=Vector3.New(0,-30,0);
			elseif number==19 then
				aa.transform.localPosition=Vector3.New(0,15,0);
			elseif number==21 then
				aa.transform.localPosition=Vector3.New(0,0,0);
			elseif number==22 then
				aa.transform.localPosition=Vector3.New(0,5,0);
			elseif number==23 then
				aa.transform.localPosition=Vector3.New(15,15,0);
			elseif number==24 then
				aa.transform.localPosition=Vector3.New(0,-5,0);
			elseif number==25 then
				aa.transform.localPosition=Vector3.New(25,0,0);
			elseif number==26 then
				aa.transform.localPosition=Vector3.New(-15,20,0);
			end
		   
			this._14Layout.gameObject:SetActive(false);
			coroutine.start(this.AfterDoing,this,1.25, function()
				destroy(aa);
			end);
		end
	end

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
		
		startPosition = this.startmoveposition.localPosition;
	else
		local user = this:GetPlayer(ownid);
		if user~=nil then
			username = user.nickname;
		else
			username = "玩家";
		end
		
		for  i = 0,12 do
			local sit = this._9Layout:FindChild("sit_".. i);
			if sit:FindChild("LayoutLabel0"):GetComponent("UILabel").text ~= nil and sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(ownid) then
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
		
		for  i = 0,12 do
			local sit = this._9Layout:FindChild("sit_".. i);
			if sit:FindChild("LayoutLabel0"):GetComponent("UILabel").text ~= nil and sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(otherId) then
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
	
	insPrefab.transform.parent = this._9Layout;
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
		this.mxtxtPlyInfo6.text =  tostring(yuanbao);
	end
	
	
	
end

function this:PlayAnimation( number)
	if number == 20 then
		animationPrefab = GameObject.Instantiate(this.flower);
		animationPrefab.transform.parent = this._9Layout;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = Vector3.New(endPosition.x - 13, endPosition.y + 24, endPosition.z);
	elseif number == 21 then
		animationPrefab = GameObject.Instantiate(this.xiong);
		animationPrefab.transform.parent = this._9Layout;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
		animationPrefab:GetComponent("TweenPosition").from = animationPrefab.transform.localPosition;
		animationPrefab:GetComponent("TweenPosition").to = Vector3.New(animationPrefab.transform.localPosition.x - 100, animationPrefab.transform.localPosition.y, animationPrefab.transform.localPosition.z);
	elseif number == 22 then
		animationPrefab = GameObject.Instantiate(this.jiubei);
		animationPrefab.transform.parent = this._9Layout;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
	elseif number == 23 then
		animationPrefab = GameObject.Instantiate(this.house);
		animationPrefab.transform.parent = this._9Layout;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
	elseif number == 24 then
		animationPrefab = GameObject.Instantiate(this.car);
		animationPrefab.transform.parent = this._9Layout;
		animationPrefab.transform.localScale = Vector3.one;
		animationPrefab.transform.localPosition = endPosition;
		animationPrefab:GetComponent("TweenPosition").from = animationPrefab.transform.localPosition;
		animationPrefab:GetComponent("TweenPosition").to = Vector3.New(animationPrefab.transform.localPosition.x - 100, animationPrefab.transform.localPosition.y + 5.7, animationPrefab.transform.localPosition.z);
	elseif number == 25 then
		animationPrefab = GameObject.Instantiate(this.house);
		animationPrefab.transform.parent = this._9Layout;
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

function this:gameBuyNoMoney(json)
	this.mxErrorToast:ShowToastNew2("text_17");
	--local errMsg = nil;
	--errMsg = XMLResource.Instance:Str("mx_bet_err_11");
	--if errMsg ~= nil then
	--	this.mxErrorToast:Show(1.2, errMsg);
	--end
end

--音乐设置
function this:ChangeMusic()
	if  this.musicOn.spriteName == "voice_on" then
		this.musicOn.spriteName = "voice_off";
		this.mxSettBGBar.value = 0;
		UISoundManager.BGVolumeSet(this.mxSettBGBar.value);
		
	elseif this.musicOn.spriteName == "voice_off" then
		this.musicOn.spriteName = "voice_on";
		this.mxSettBGBar.value = 0.15;
		UISoundManager.BGVolumeSet(this.mxSettBGBar.value);
	end
	SettingInfo.Instance.bgVolume = this.mxSettBGBar.value;
end
function this:ChangeYinxiao()
	if this.yinxiaoOn.spriteName == "voice_on" then
		this.yinxiaoOn.spriteName = "voice_off";
		this.mxSettEFBar.value = 0;
		UISoundManager._EFVolume =this.mxSettEFBar.value;
		
	elseif this.yinxiaoOn.spriteName == "voice_off" then
		this.yinxiaoOn.spriteName = "voice_on";
		this.mxSettEFBar.value = 1;
		UISoundManager._EFVolume =this.mxSettEFBar.value;
	end
	SettingInfo.Instance.effectVolume =this.mxSettEFBar.value
end



function this:SelectNiuniuType(label)
	local niuniu = tableKey(tempLabelNiu,label);
	return niuniu;
end

function this:OnChangeSit(target)

	local index = 0;
	local sitindex = 0;
	for  i = 0,12 do
	
		local sit = this._9Layout:FindChild("sit_".. i);
		if target == sit.gameObject and sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(userId) then
			index = i;
			local chip_in = {type="nn100",tag="situp"};   
			local jsonStr = cjson.encode(chip_in);
			this.mono:SendPackage(jsonStr);
			break;
		elseif target == sit.gameObject and sit:FindChild("LayoutLabel0"):GetComponent("UILabel").text == "" then
			sitindex = i;
			local chip_in = {type="nn100",tag="sitdown",body=sitindex};   
			local jsonStr = cjson.encode(chip_in);
			this.mono:SendPackage(jsonStr);
			break;
		elseif target == sit.gameObject and sit:FindChild("LayoutLabel0"):GetComponent("UILabel").text ~= "" then
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
			this.liwu_touxiang.spriteName = sit:FindChild("LayoutBG"):FindChild("Sprite_1"):GetComponent("UISprite").spriteName;
			this.liwu_id.text = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text;
		end
	end

	for  j = 0,11 do
	
		local nosit = this._12Layout:FindChild("GameSettView"):FindChild("SettViewBG0"):FindChild("wuzuo_".. j);
		if target == nosit.gameObject and nosit:FindChild("LayoutLabel0"):GetComponent("UILabel").text ~= nil then
		
			this._13Layout.gameObject:SetActive(true);
			this._12Layout.gameObject:SetActive(false);
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
			this.liwu_touxiang.spriteName = nosit:FindChild("LayoutBG"):FindChild("Sprite_1"):GetComponent("UISprite").spriteName;
			this.liwu_id.text = nosit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text;
		end
	end
end

function this:OnSetBiaoQing(target)
	UISoundManager.Instance.PlaySound("but");
	local index = 0;
	for  i = 0,   #(this.biaoqing)-1 do
		local smile = this._14Layout:FindChild("GameSettView"):FindChild("SettViewBG0"):FindChild("BiaoQing_".. i);
		if target == smile.gameObject then
			index = i;
			break;
		end
	end
	
	if havesit then
		
		local chip_in = {type="game",tag="emotion",body = index};   
		local jsonStr = cjson.encode(chip_in);
		this.mono:SendPackage(jsonStr);
	else
		local errMsg = XMLResource.Instance:Str("mx_bet_err_8");
		if errMsg ~= nil then
			this._14Layout.gameObject:SetActive(false);
			this.mxErrorToast:Show(1.2, errMsg);
		end
	end
end

function this:OnStandUp()
	UISoundManager.Instance.PlaySound("but");
	local index = 0;
	for  i = 1,12 do
		local sit = this._9Layout:FindChild("sit_".. i);
		if sit:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(userId) then
			index = i;
			if havesit then
				local chip_in = {type="nn100",tag="situp"};   
				local jsonStr = cjson.encode(chip_in);
				this.mono:SendPackage(jsonStr);
			end
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

function this:wuzuoShow()
	page_count = 1;
	this:getWuzuoList();   
	pageallcount = math.ceil( #(this.wuzuoPlayer) / 12);
	--if  #(this.wuzuoPlayer) % 12 ~= 0 then
	--	pageallcount = pageallcount +1;
	--end

	local wuzuo = this._12Layout:FindChild("GameSettView/SettViewBG0");
	wuzuo:FindChild("page_count_1"):GetComponent("UILabel").text =  tostring(page_count);
	wuzuo:FindChild("page_count_2"):GetComponent("UILabel").text =  tostring(pageallcount);
	
	if page_count * 12 >  #(this.wuzuoPlayer) then
		this:OnPageShow(0,  #(this.wuzuoPlayer), page_count);
	else
		this:OnPageShow(0, page_count * 12, page_count);
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
	for  i = 1, #(this.sitPlayer) do
		if this.sitPlayer[i] ~= nil then
			log("1========"..this.sitPlayer[i])
			if  tableContains(this.wuzuoPlayer,this.sitPlayer[i]) then 
				log("2========"..this.sitPlayer[i])
				table.remove(this.wuzuoPlayer,tableKey(this.wuzuoPlayer,this.sitPlayer[i]))
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
	local wuzuo = this._12Layout:FindChild("GameSettView/SettViewBG0");
	wuzuo:FindChild("page_count_1"):GetComponent("UILabel").text =  tostring(page_count);

	if page_count * 12 <  #(this.wuzuoPlayer) then
		this:OnPageShow((page_count - 1) * 12, page_count * 12, page_count);
	else
		this:OnPageShow((page_count - 1) * 12,  #(this.wuzuoPlayer), page_count);
	end
end
function this:OnPageMinus()

         UISoundManager.Instance.PlaySound("but");
	this:getWuzuoList();
	page_count = page_count -1;
	if page_count < 1 then
		page_count = 1;
	end
	local wuzuo = this._12Layout:FindChild("GameSettView/SettViewBG0");
	wuzuo:FindChild("page_count_1"):GetComponent("UILabel").text =  tostring(page_count);
	if page_count * 12 <  #(this.wuzuoPlayer) then
		this:OnPageShow((page_count - 1) * 12, page_count * 12, page_count);
	else
		this:OnPageShow((page_count - 1) * 12,  #(this.wuzuoPlayer), page_count);
	end
end
function this:LengNameSub( text)
	
	if   LengthUTF8String(text) > 4 then
		return SubUTF8String(text,12).."...";
	end
	return text;
end
function this:OnPageShow( firstNum,  endNum,  page)
	this:getWuzuoList();
	this:HideSit();
	
	for  i = firstNum,endNum - 1 do
		this.wuzuosit[(i - (page - 1) * 12)+1]:SetActive(true);   
		
		local player = this:GetPlayer(tonumber(this.wuzuoPlayer[i+1]));
		if player ~= nil then
			this.wuzuosit[(i - (page - 1) * 12)+1].transform:FindChild("LayoutBG"):FindChild("Sprite_1"):GetComponent("UISprite").spriteName = "avatar_".. (player.avatar + 1);
			local name = this.wuzuosit[(i - (page - 1) * 12)+1].transform:FindChild("LayoutLabel0"):GetComponent("UILabel");
			name.text = player.nickname;
			name.text = this:LengNameSub(name.text); 
			local money = this.wuzuosit[(i - (page - 1) * 12)+1].transform:FindChild("LayoutLabel1"):GetComponent("UILabel");
			this.wuzuosit[(i - (page - 1) * 12)+1].transform:FindChild("LayoutLabel_id"):GetComponent("UILabel").text =  tostring(player.uid);
			if this.wuzuosit[(i - (page - 1) * 12)+1].transform:FindChild("LayoutLabel_id"):GetComponent("UILabel").text ==  tostring(userId) then
				money.text = this.mxtxtPlyInfo5.text;
			else
				money.text = tostring(player.money );
				money.text =   this:uitextChange(money.text); --this:TextChange(money.text)
			end
		end
		
	end
end
function this:HideSit()
	for  i = 1,12 do
		this.wuzuosit[i].transform:FindChild("LayoutBG"):FindChild("Sprite_1"):GetComponent("UISprite").spriteName = "avatar_w";
		this.wuzuosit[i].transform:FindChild("LayoutLabel0"):GetComponent("UILabel").text = "";
		this.wuzuosit[i].transform:FindChild("LayoutLabel1"):GetComponent("UILabel").text = "";
		this.wuzuosit[i].transform:FindChild("LayoutLabel_id"):GetComponent("UILabel").text = "";
		this.wuzuosit[i]:SetActive(false);
	end
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
			local sit = this._9Layout:FindChild("sit_"..(i-1)); 
			local label_0 = sit:FindChild("LayoutLabel0"):GetComponent("UILabel");
			local label_1 = sit:FindChild("LayoutLabel1"):GetComponent("UILabel");
			local label_2 = sit:FindChild("LayoutLabel_id"):GetComponent("UILabel");
			local sprite = sit:FindChild("LayoutBG"):FindChild("Sprite_1"):GetComponent("UISprite");
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
					 	local sit = this._9Layout:FindChild("sit_".. i); 
						if tostring(SocketConnectInfo.Instance.userId) ==  tostring(this.banker.uid)  then  
							this.IconZhuang.transform.position = this._0Layout:FindChild("ChildLabel3/Sprite").position
						else

						 	if i > 4 then
								this.IconZhuang.transform.localPosition = sit.localPosition:Add(Vector3.New(-63,63,0));
							else
								this.IconZhuang.transform.localPosition = sit.localPosition:Add(Vector3.New(63,63,0));
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
		if tIsZhuang == false then 
			this.IconZhuang.gameObject:SetActive(false)
		end
	end
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
 
	