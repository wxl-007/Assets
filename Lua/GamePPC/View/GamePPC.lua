require "GameNN/Tools"
require "GameNN/UISoundManager"
require "GameNN/GToast"
require "GameNN/GPlayer"
require "GamePPC/MTimerPPC"
local cjson=require "cjson"

local this = LuaObject:New()
GamePPC = this;

local animaIndex={{},{},{},{},{},{},{},{}};
--8个车标在中心区的所有位置下标
local lanbojini={};
local benchi={};
local falali={};
local leikesasi={};
local baoshijie={};
local fengtian={};
local baoma={};
local xiandai={};

local beishu={};
local Banker_uid=0;
local nextBanker_uid=0;
local bankerWinAllMoney=0;
local selectMoney=100;--选择下注的金额
local isPrimary=false;--是否只有一个可选择的筹码金额
local players={};--所有玩家列表
local bankupInfos={};--庄家列表
local day_rank_paiming={};--当日排名列表
local paths={};--最新六局的选中车标信息
local ownBetCount={};--自己在八个区域下注的金钱数
local ownBetCount_1={};--自己在八个区域下注的金钱数（虚假的）
local ownBetCount_2={};--自己在八个区域下注的金钱数（虚假的）
local ownAllBetCount={};--所有人在八个区域金钱显示
local ownAllBetCount_1={};--所有人在八个车标分别下注的总数
local canChips={};--本场次可以选择下注的筹码金额

local lianzhuangCount=0;--庄家连庄次数
local shengyuzhuangCount=0;--剩余可做庄次数
local eDuIndex=0;--可选下注金额的下标
local updateBanker=false;--是否换庄
local showBetAllCount=false;--是否需要显示全部的下注金额
local alreadyBet=false;
local clickXuYa=false;
local enterGame=false;
local enterCanBet=false;
local ownbetMoneyCount=0;--自己开始下注时的背包金钱数量
local baktime=0;
local canBet=false;--是否可下注
local betIndex=1;--选择下注的下标
local bettime=0;
local endposition=0;--结算时的车标走动的起始位置
local jiesuanPosition=0;
local re_enter=false;
local ownInBanker=false;

function this:clearLuaValue()
	this.ScreenW = nil
	this.ScreenH = nil
	this.TargetH = nil;

	this.mono=nil;
	this.gameObject=nil;
	this.transform=nil;
	
	this.ownplayer=nil;
	this.banker=nil;
	
	animaSprite=nil;
	selected_chebiao=nil;	
	this.mTimer=nil;
    this.mDaoJiShi=nil;
    this.mxBakupToast=nil;
	this.mxErrorToast=nil;
	this.mBakupListGrid=nil;
    this.shangzhuangPrefab=nil;
	this.updateBankerPanel=nil;
	this.huanzhuang_banker_avatar=nil;
	this.huanzhuang_banker_level=nil;
	this.huanzhuang_banker_nickname=nil;
	this.huanzhuang_banker_money=nil;
	this.next_banker_avatar=nil;
	this.next_banker_level=nil;
    this.next_banker_nickname=nil;
	this.next_banker_money=nil;
	
	this.winorlose_Sprite=nil;
	this.huanzhuang_banker_winmoney=nil;
	
	deskBet=nil;
	deskBetBg=nil;
	betOwn=nil;
	betAll=nil;
	this.SelectMoney=nil;
	this.Edu=nil;
	this.Xuya=nil;
	this.EduZhizhen=nil;
	this.XuyaZhizhen=nil;
	
	this.chebiaoPath=nil;
	this.banker_avatar=nil;
	this.banker_shengyujushu=nil;
	this.banker_name=nil;
	this.banker_level=nil;
	this.banker_money=nil;
	
	this.banker_winMoney=nil;
	this.banker_loseMoney=nil;
	this.winorloseTarget=nil;
	this.own_avatar=nil;
	this.own_nickname=nil;
	this.own_bagmoney=nil;
	this.shangzhuangButton=nil;
    this.shangzhuangPanel=nil;
	this.dangri=nil;
	this.benju=nil;
	this.dangriPanel=nil;
	this.benjuPanel=nil;
    this.chongzhiButton=nil;
	this.chongzhiPanel=nil;
	dangriPaiming=nil;
	benjuPaiming=nil;
	dangriName=nil;
	dangriMoney=nil;
	benjuName=nil;
	benjuMoney=nil;

    this.wantUpBanker=nil;
	
	this.jiesuan_winPanel=nil;
	this.win_avatar=nil;
	this.guang_1=nil;
	this.guang_2=nil;
	this.winMessage_bg=nil;
	this.win_level=nil;
	this.win_nickname=nil;
	this.win_money=nil;
	this.guang_1_startposition=nil;
	this.guang_1_endposition=nil;
	this.guang_2_startposition=nil;
	this.guang_2_endposition=nil;
	this.chedeng=nil;
	this.banker_kaijiang=nil;
	this.xianjia_bet=nil;
  
    this.NeedEnabled=false;
	
	this.music=nil;
	this.bg_music=nil;
	
	
	animaIndex={{},{},{},{},{},{},{},{}};
	lanbojini={};
	benchi={};
	falali={};
	leikesasi={};
	baoshijie={};
	fengtian={};
	baoma={};
	xiandai={};

	beishu={};
	Banker_uid=0;
	nextBanker_uid=0;
	bankerWinAllMoney=0;
	selectMoney=0;
	isPrimary=false;
	players={};
	bankupInfos={};
	day_rank_paiming={};
	paths={};
	ownBetCount={};
	ownBetCount_1={};
	ownBetCount_2={};
	ownAllBetCount={};
	ownAllBetCount_1={};
	canChips={};

	lianzhuangCount=0;
	shengyuzhuangCount=0;
	eDuIndex=0;
	updateBanker=false;
	showBetAllCount=false;
	alreadyBet=false;
	clickXuYa=false;
	enterGame=false;
	enterCanBet=false;
	ownbetMoneyCount=0;
	baktime=0;
	canBet=false;
	betIndex=1;
	bettime=0;
	endposition=0;
	ljiesuanPosition=0;
	re_enter=false;
	ownInBanker=false;
	
	this.InvokeLua:clearLuaValue();
	this.InvokeLua=nil;
	
	coroutine.Stop()
	UISoundManager.finish()
	LuaGC();
end


function this:Init()
	this.ScreenW = nil
	this.ScreenH = nil
	this.TargetH = nil;
	
	this.Module_RechargeLua = Module_Recharge;
	if (Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer) then
		if(PlatformGameDefine.playform.IOSPayFlag)then
			this.Module_Recharge = ResManager:LoadAsset(Utils._hallResourcesName.."/Module_Recharge","Module_Recharge")
		else
			this.Module_Recharge = ResManager:LoadAsset(Utils._hallResourcesName.."/Module_Recharge_iOS","Module_Recharge_iOS")
			this.Module_RechargeLua = Module_Recharge_iOS;
		end
	else
		this.Module_Recharge = ResManager:LoadAsset(Utils._hallResourcesName.."/Module_Recharge","Module_Recharge")
	end
	
	--22个中心区的车标动画
	animaSprite={};
	selected_chebiao={};
	for i=1,22 do
		table.insert(animaSprite,this.transform:FindChild("Panel_choujiang/choujiang_"..i.."/Sprite_1").gameObject:GetComponent("Animator"));
	end
	for i=1,8 do
	    table.insert(selected_chebiao,this.transform:FindChild("panel_button/select_chebiao_Panel/select_"..i.."/chebiao").gameObject:GetComponent("Animator"));
	end
	local timergameobj=this.transform:FindChild("Content/NNCount").gameObject;--倒计时
	this.mTimer= MTimerPPC:New(timergameobj);
    this.mDaoJiShi=this.transform:FindChild("panel_button/NNCount").gameObject:GetComponent("Animator");--开奖时的三秒倒计时
    this.mxBakupToast=GToast:New(this.transform:FindChild("Content/MsgContainer/GameToastBakup").gameObject);
	this.mxErrorToast=GToast:New(this.transform:FindChild("Content/MsgContainer/GameToastError").gameObject);
	this.mBakupListGrid=this.transform:FindChild("panel_button/shangzhuangList/back_bg/panel/BakupListView/UIGrid").gameObject:GetComponent("UIGrid");
    this.shangzhuangPrefab=ResManager:LoadAsset("gameppc/prefab","banker");
	this.updateBankerPanel=this.transform:FindChild("panel_button/huanzhuang").gameObject;
	local huanzhuanginfo=this.updateBankerPanel.transform:FindChild("back_bg/banker/info");	
	this.huanzhuang_banker_avatar=huanzhuanginfo:FindChild("avatar_bg/avatar").gameObject:GetComponent("UISprite");
	this.huanzhuang_banker_level=huanzhuanginfo:FindChild("banker_level").gameObject:GetComponent("UILabel");
	this.huanzhuang_banker_nickname=huanzhuanginfo:FindChild("banker_name").gameObject:GetComponent("UILabel");
	this.huanzhuang_banker_money=huanzhuanginfo:FindChild("banker_money_board/win_money").gameObject:GetComponent("UILabel");
	
	local nextzhuanginfo=this.updateBankerPanel.transform:FindChild("back_bg/xialun/banker");	
	this.next_banker_avatar=nextzhuanginfo:FindChild("avatar_bg/avatar").gameObject:GetComponent("UISprite");
	this.next_banker_level=nextzhuanginfo:FindChild("banker_level").gameObject:GetComponent("UILabel");	
    this.next_banker_nickname=nextzhuanginfo:FindChild("banker_name").gameObject:GetComponent("UILabel");
	this.next_banker_money=nextzhuanginfo:FindChild("banker_money_board/win_money").gameObject:GetComponent("UILabel");
	
	this.winorlose_Sprite=this.updateBankerPanel.transform:FindChild("back_bg/banker/winorlose/win").gameObject:GetComponent("UISprite");
	this.huanzhuang_banker_winmoney=this.updateBankerPanel.transform:FindChild("back_bg/banker/winorlose/win_money").gameObject:GetComponent("UILabel");
	
	deskBet={};--下注的八个区域
	deskBetBg={};--八个区域的阴影背景
	for i=1,8 do
		table.insert(deskBet,this.transform:FindChild("Panel_yazhuqu/chebiao_"..i.."/chebiao").gameObject);
	end
	for i=1,8 do
		table.insert(deskBetBg,this.transform:FindChild("Panel_yazhuqu/chebiao_"..i.."/chebiao/chebiao_bg").gameObject);
	end
	
	betOwn={};--自己在八个区域金钱显示
	betAll={};--所有人在八个区域金钱显示

	for i=1,8 do
		table.insert(betOwn,this.transform:FindChild("Panel_yazhuqu/chebiao_"..i.."/bet_own").gameObject:GetComponent("UILabel"));
	end
	for i=1,8 do
		table.insert(betAll,this.transform:FindChild("Panel_yazhuqu/chebiao_"..i.."/bet_all").gameObject:GetComponent("UILabel"));
	end
	
	local youbiao=this.transform:FindChild("Panel_right/youbiao");
	this.SelectMoney=youbiao:FindChild("label_1").gameObject:GetComponent("UILabel");
	this.Edu=youbiao:FindChild("edu").gameObject:GetComponent("UISprite");
	this.Xuya=youbiao:FindChild("xuya").gameObject:GetComponent("UISprite");
	this.EduZhizhen=youbiao:FindChild("edu_zhizhen").gameObject:GetComponent("Animator");
	this.XuyaZhizhen=youbiao:FindChild("xuya_zhizhen").gameObject:GetComponent("Animator");
	
	this.chebiaoPath=this.transform:FindChild("Panel_zhongxinqu/chebiao");
	local zhongxinqu_banker=this.transform:FindChild("Panel_zhongxinqu/banker");
	this.banker_avatar=zhongxinqu_banker:FindChild("bank_avatar").gameObject:GetComponent("UISprite");
	this.banker_shengyujushu=zhongxinqu_banker:FindChild("bank_shengyu/bank_shengyujushu").gameObject:GetComponent("UISprite");
	this.banker_name=zhongxinqu_banker:FindChild("bank_name").gameObject:GetComponent("UILabel");
	this.banker_level=zhongxinqu_banker:FindChild("bank_level").gameObject:GetComponent("UILabel");
	this.banker_money=zhongxinqu_banker:FindChild("bank_money_board/banker_money").gameObject:GetComponent("UILabel");
	
	this.banker_winMoney=this.transform:FindChild("panel_button/winMoney_panel/win_money").gameObject:GetComponent("UILabel");
	this.banker_loseMoney=this.transform:FindChild("panel_button/winMoney_panel/lose_money").gameObject:GetComponent("UILabel");
	this.winorloseTarget=this.transform:FindChild("panel_button/winMoney_panel/winorloseTarget");--庄家输赢金钱数的最终上升位置
	
	--自己的信息
	local ownInfo=this.transform:FindChild("Panel_right/message");
	this.own_avatar=ownInfo:FindChild("avatar/avatar").gameObject:GetComponent("UISprite");
	this.own_nickname=ownInfo:FindChild("name").gameObject:GetComponent("UILabel");
	this.own_bagmoney=ownInfo:FindChild("money/label").gameObject:GetComponent("UILabel");
 
	--当日和本局前十玩家信息
	this.shangzhuangButton=zhongxinqu_banker:FindChild("bank_shangzhuang").gameObject;
    this.shangzhuangPanel=this.transform:FindChild("panel_button/shangzhuangList").gameObject;	
	local dangriPanelParent=this.transform:FindChild("Panel_right/paiming");
	this.dangri=dangriPanelParent:FindChild("dangri").gameObject;
	this.benju=dangriPanelParent:FindChild("benju").gameObject;
	this.dangriPanel=dangriPanelParent:FindChild("dangripanel").gameObject;
	--log(this.dangriPanel.name);
	this.benjuPanel=dangriPanelParent:FindChild("benjupanel").gameObject;
	--log(this.benjuPanel.name);
    this.chongzhiButton=this.transform:FindChild("Panel_right/chongzhi").gameObject;
	this.chongzhiPanel=this.transform:FindChild("panel_button/chongzhi_panel").gameObject;
	
	local dangripaiming_Panel=this.transform:FindChild("Panel_right/paiming/dangripanel/changyongyu/UIGrid/Man");
	local benjupaiming_Panel=this.transform:FindChild("Panel_right/paiming/benjupanel/changyongyu/UIGrid/Man");
	dangriPaiming={};
	benjuPaiming={};
	dangriName={};
	dangriMoney={};
	benjuName={};
	benjuMoney={};
	for i=1,10 do
		table.insert(dangriPaiming,dangripaiming_Panel:FindChild("label_"..i).gameObject);
	end
	for i=1,10 do
		table.insert(benjuPaiming,benjupaiming_Panel:FindChild("label_"..i).gameObject);
	end
	for i=1,10 do
		table.insert(dangriName,dangripaiming_Panel:FindChild("label_"..i.."/label").gameObject:GetComponent("UILabel"));
	end
	for i=1,10 do
		table.insert(dangriMoney,dangripaiming_Panel:FindChild("label_"..i.."/label_1").gameObject:GetComponent("UILabel"));
	end
	for i=1,10 do
		table.insert(benjuName,benjupaiming_Panel:FindChild("label_"..i.."/label").gameObject:GetComponent("UILabel"));
	end
     for i=1,10 do
		table.insert(benjuMoney,benjupaiming_Panel:FindChild("label_"..i.."/label_1").gameObject:GetComponent("UILabel"));
	end

    this.wantUpBanker=this.shangzhuangPanel.transform:FindChild("xiazhuang").gameObject:GetComponent("UISprite");
	
	this.jiesuan_winPanel=this.transform:FindChild("panel_button/win_panel").gameObject;
	this.win_avatar=this.jiesuan_winPanel.transform:FindChild("win_bg/avatar_bg/avatar").gameObject:GetComponent("UISprite");
	this.guang_1=this.jiesuan_winPanel.transform:FindChild("win_bg/win_guang_1").gameObject:GetComponent("UISprite");
	this.guang_2=this.jiesuan_winPanel.transform:FindChild("win_bg/win_guang_2").gameObject:GetComponent("UISprite");
	this.winMessage_bg=this.jiesuan_winPanel.transform:FindChild("win_bg").gameObject:GetComponent("UITexture");
	this.win_level=this.jiesuan_winPanel.transform:FindChild("win_bg/win_level").gameObject:GetComponent("UILabel");
	this.win_nickname=this.jiesuan_winPanel.transform:FindChild("win_bg/win_name").gameObject:GetComponent("UILabel");
	this.win_money=this.jiesuan_winPanel.transform:FindChild("win_bg/win_money_board/win_money").gameObject:GetComponent("UILabel");
	this.guang_1_startposition=this.jiesuan_winPanel.transform:FindChild("win_bg/win_guang_1_startPosition");
	this.guang_1_endposition=this.jiesuan_winPanel.transform:FindChild("win_bg/win_guang_1_endPosition");
	this.guang_2_startposition=this.jiesuan_winPanel.transform:FindChild("win_bg/win_guang_2_startPosition");
	this.guang_2_endposition=this.jiesuan_winPanel.transform:FindChild("win_bg/win_guang_2_endPosition");
	
    --车灯  庄开奖  闲家下注
	this.chedeng=zhongxinqu_banker:FindChild("chedeng").gameObject;
	this.banker_kaijiang=zhongxinqu_banker:FindChild("bank_kaijiang").gameObject;
	this.xianjia_bet=zhongxinqu_banker:FindChild("xianjia_xiazhu").gameObject;
  
    this.NeedEnabled=false;
	
	this.music=this.transform.gameObject:GetComponent("AudioSource");
	this.bg_music=ResManager:LoadAsset("gameppc/sound","bgm");
	
	
	animaIndex={{},{},{},{},{},{},{},{}};
	lanbojini={4,15};
	benchi={5,11,16};
	falali={9,20};
	leikesasi={3,8,14};
	baoshijie={10,21};
	fengtian={6,17,22};
	baoma={1,7,12,18};
	xiandai={2,13,19};
	
	beishu={38,8,28,6,18,4,10,4};
	Banker_uid=0;
	nextBanker_uid=0;
	bankerWinAllMoney=0;
	selectMoney=0;
	isPrimary=false;
	players={};
	bankupInfos={};
	day_rank_paiming={};
	paths={};
	ownBetCount={0,0,0,0,0,0,0,0};
	ownBetCount_1={0,0,0,0,0,0,0,0};
	ownBetCount_2={0,0,0,0,0,0,0,0};
	ownAllBetCount={0,0,0,0,0,0,0,0};
	ownAllBetCount_1={0,0,0,0,0,0,0,0};
	canChips={};

	lianzhuangCount=0;
	shengyuzhuangCount=0;
	eDuIndex=0;
	updateBanker=false;
	showBetAllCount=false;
	alreadyBet=false;
	clickXuYa=false;
	enterGame=false;
	enterCanBet=false;
	ownbetMoneyCount=0;
	baktime=0;
	canBet=false;
	betIndex=1;
	bettime=0;
	endposition=0;
	ljiesuanPosition=0;
	re_enter=false;
	ownInBanker=false;
	
	this.InvokeLua=InvokeLua:New(this);
end

function this:handleBtnsFunc()
	
end


function this:Awake()
	--log("------------------awake of GamePPCPanel")
	this.Init();
    this:handleBtnsFunc();
	this:AddChild();
	
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 	
		sceneRoot.minimumHeight = 768;
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;		
	end

	UISoundManager.Init(this.gameObject);
	UISoundManager.AddAudioSource("gameppc/sound","choujiang_paodeng");
	UISoundManager.AddAudioSource("gameppc/sound","daojishi_321");
	--綁定按鈕事件
	--充值界面
	this.mono:AddClick(this.chongzhiButton,this.OnButtonClick,this);
	local chongzhi_sure=this.chongzhiPanel.transform:FindChild("Button_sure").gameObject;
	this.mono:AddClick(chongzhi_sure,this.UserChongZhi);
	local chongzhi_cancel=this.chongzhiPanel.transform:FindChild("Button_cancel").gameObject;
	this.mono:AddClick(chongzhi_cancel,this.OnClose,this);
	local chongzhi_close=this.chongzhiPanel.transform:FindChild("close").gameObject;
	this.mono:AddClick(chongzhi_close,this.OnClose,this);
	--上庄列表
	local shangzhuang_close=this.transform:FindChild("panel_button/shangzhuangList/close").gameObject;
	--local shangzhuang_close=this.shangzhuangPanel.transform:FindChild("close").gameObject;
	this.mono:AddClick(shangzhuang_close,this.OnClose,this);
	this.mono:AddClick(this.wantUpBanker.gameObject,this.OnButtonClick,this);
	this.mono:AddClick(this.shangzhuangButton,this.OnButtonClick,this);
	
	--下注区八个图标
	for i=1,8 do
		this.mono:AddClick(deskBet[i],this.OnBetButtonClick,this);
	end
	--返回按钮
	local back_button=this.transform:FindChild("Panel_right/back").gameObject;
	this.mono:AddClick(back_button,this.UserQuit);
	--额度和续压按钮
	this.mono:AddClick(this.Edu.gameObject,this.OnButtonClick,this);
	this.mono:AddClick(this.Xuya.gameObject,this.OnButtonClick,this);
	--当日和本局排名按钮
	this.mono:AddClick(this.dangri,this.OnButtonClick,this);
	this.mono:AddClick(this.benju,this.OnButtonClick,this);
end

function this:AddChild()
    animaIndex[1]=lanbojini;
	animaIndex[2] = benchi;
	animaIndex[3] = falali;
	animaIndex[4] = leikesasi;
	animaIndex[5] = baoshijie;
	animaIndex[6] = fengtian;
	animaIndex[7] = baoma;
	animaIndex[8] = xiandai;

	
	for i=1,#(animaIndex) do
	   --log(#(animaIndex[i]))
	end
end

function this:Start()
	this.initLayout();
	coroutine.start(this.Update);
	coroutine.start(this.UpdateBet);
	this.mono:StartGameSocket();	
	UISoundManager.Start(true);
	UISoundManager.Instance._EFVolume=1;
	UISoundManager.Instance._BGVolume=1;
	this:PlayMusic();
	
end


function this:initLayout()
        --判断是否只有一个选择下注的筹码
	if string.find(SocketConnectInfo.Instance.roomTitle,System.Text.RegularExpressions.Regex.Unescape("\\u521d\\u7ea7")) then
		isPrimary = true;
	else
		isPrimary=false;
	end     
end

function this:GetPlayer(uid)
	return players[uid];
end

function this:UpdateBet()
	while this.gameObject do
		if canBet then
			for i=0,7 do 
				if ownBetCount[i+1]~=0 then
					--log("下注下标");
					--log(i+1);
					this.mono:SendPackage(cjson.encode({type="jshc",tag="bet",body={i,ownBetCount[i+1]}}));
					ownBetCount[i+1]=0;
					coroutine.wait(0.2);
				end
				betIndex=betIndex+1;
			end
			if betIndex==8 then
				betIndex=0;
			end
		end
		coroutine.wait(0.2);
	end
end

function this:OnBetButtonClick(target)
    --log("下注时的金额");
	--log(selectMoney);
	if selectMoney~=0 then
		local index=0;
		for i=0,7 do 
			if deskBet[i+1]~=nil and target==deskBet[i+1].gameObject then
				clickXuYa=false;
				index=i+1;
				ownBetCount[index]=tonumber(ownBetCount[index])+tonumber(selectMoney);
				--log("前方");
				--log(ownBetCount_1[index]);
				ownBetCount_1[index]=tonumber(ownBetCount_1[index])+tonumber(selectMoney);--前端显示自己每点击一次，下注金额变动一次
				--log(ownBetCount_1[index]);
				alreadyBet=true;
				if alreadyBet then
					this.ShowOrHideXuYa(false);
				end

				betOwn[index].text=this:HuanSuanMoney(ownBetCount_1[index]);
				break;
			end
		end
	end
end

function this:OnButtonClick(target)
	--log("进入点击按钮");
	if target==this.dangri then
		--log("当日");
		NGUITools.SetActive(this.dangriPanel, true);
		NGUITools.SetActive(this.benjuPanel,false);
	elseif target==this.benju  then
		--log("本局");
		NGUITools.SetActive(this.dangriPanel,false);
		NGUITools.SetActive(this.benjuPanel,true);
	elseif target==this.shangzhuangButton then
		this.shangzhuangPanel:SetActive(true);
	elseif target==this.chongzhiButton then
		this.chongzhiPanel:SetActive(true);
	elseif target==this.Edu.gameObject then
		--log("额度");
		--log(eDuIndex);
		eDuIndex=eDuIndex+1;
		if eDuIndex>#(canChips) then
			eDuIndex=1;
		end
		selectMoney=canChips[eDuIndex];
		--log("选择下注金额11111");
		--log(selectMoney);
		if selectMoney>99000 then
			this.SelectMoney.text=this:HuanSuanMoney(tonumber(selectMoney));
		else
			this.SelectMoney.text=tostring(selectMoney);
		end
		if isPrimary then
			this.EduZhizhen.enabled=true;
			this.EduZhizhen:CrossFade("edu",0);
		else
			this.EduZhizhen.enabled=false;
			local rotateCount=0;
			if eDuIndex==1 then
				rotateCount=0;
			elseif eDuIndex==2 then
				rotateCount=-25;
			elseif eDuIndex==3 then
				rotateCount=-54;
			elseif eDuIndex==4 then
				rotateCount=-91;
			elseif eDuIndex==5 then
				rotateCount=-140;
			end
			iTween.RotateTo(this.EduZhizhen.gameObject,this.mono:iTweenHashLua("rotation",Vector3.New(0,0,rotateCount),"time",0.5,"easeType",iTween.EaseType.linear));
		end
	elseif target==this.Xuya.gameObject then
		clickXuYa=true;
		
		local sendData=nil;
		local liebiao={};
		for i=0,#(ownAllBetCount)-1 do
			local liebiaonei={};
			table.insert(liebiaonei,i);
			table.insert(liebiaonei,ownAllBetCount[i+1]);
			table.insert(liebiao,liebiaonei);
		end
		sendData={type="jshc",tag="repeat_bet",body=liebiao};
		this.mono:SendPackage(cjson.encode(sendData));
		
		this.ShowOrHideXuYa(false);
		
		this.XuyaZhizhen.enabled=true;
		this.XuyaZhizhen:CrossFade("xuya",0);	
	elseif target==this.wantUpBanker.gameObject then
		--log("请求上庄");
		if not canBet then
			local sendData=nil;
			if "shangzhuang"==this.wantUpBanker.spriteName then
				sendData={type="jshc",tag="updealer"};
			else
			    sendData={type="jshc",tag="downdealer"};
			end
			this.mono:SendPackage(cjson.encode(sendData));
		else
		    if "shangzhuang"==this.wantUpBanker.spriteName then
				this.mxErrorToast:Show(1.2,XMLResource.Instance:Str("mx_err_game_beting"));
			else
				this.mxErrorToast:Show(1.2,XMLResource.Instance:Str("mx_err_game_xiazhuang"));
			end	
		end
	end
end

function this:UserQuit()
	SocketConnectInfo.Instance.roomFixseat=true;
	this.mono:SendPackage(cjson.encode({type="game",tag="quit"}));
	this.mono:OnClickBack();
end


function this:ShowBakupListAnim(show)

end

function this:CloseExitView()

end

function this:CloseMarkView()

end

function this:CloseGame()
   this:OnClickBack();
end

function this:ResetBakupList()
	for i=0,this.mBakupListGrid.transform.childCount-1 do 
		destroy(this.mBakupListGrid.transform:GetChild(i).gameObject);
	end
	
	local scrollview=this.mBakupListGrid.transform.parent:GetComponent("UIScrollView");
	scrollview:ResetPosition();
	ownInBanker=false;
	for key,playerT in ipairs(bankupInfos) do
		--log(playerT.uid);
		--log(EginUser.Instance.uid);
		if tostring(playerT.uid)==EginUser.Instance.uid then
			ownInBanker=true;		
			--log(ownInBanker);
		end
		
		local sp=GameObject.Instantiate(this.shangzhuangPrefab);
		sp.transform.parent=this.mBakupListGrid.transform;
		sp.transform.localScale=Vector3.one;
		sp.transform.localPosition=Vector3.New(0,-(key-1)*160,0);
		NGUITools.SetActive(sp,true);
		sp.transform:FindChild("info/banker_name"):GetComponent("UILabel").text=playerT.nickname;
		sp.transform:FindChild("info/paixu"):GetComponent("UISprite").spriteName = "changebanker_"..tostring(key);
		sp.transform:FindChild("info/banker_money_board/win_money"):GetComponent("UILabel").text = tostring(playerT.money);
		sp.transform:FindChild("info/avatar_bg/avatar"):GetComponent("UISprite").spriteName = "avatar_" .. tostring(playerT.avatar);
		sp.transform:FindChild("info/banker_level"):GetComponent("UILabel").text = "a"..tostring(playerT.level);           
	end
	--log("自己是否在庄家列表");
	--log(ownInBanker);
	if ownInBanker then
		this.wantUpBanker.spriteName="xiazhuang";
		this.shangzhuangButton:GetComponent("UISprite").spriteName="xiazhuang";
	else
		this.wantUpBanker.spriteName="shangzhuang";
		this.shangzhuangButton:GetComponent("UISprite").spriteName="shangzhuang";
	end
end

function this:ReturnInit()
	canBet=false;
end

function this:OnClickBack()
    this.mono:OnClickBack();
end

function this:SocketReceiveMessage(message)
	local Message=self;
	if Message then
		local messageObj=cjson.decode(Message);
		local typeC=messageObj["type"];
		local tag=messageObj["tag"];
		if "jshc"==typeC then  	
            if "enter"==tag then
			--log(Message);					
				this:gameEnter(messageObj);
				re_enter=true;
				
            elseif "come"==tag then
			--log(Message);
                this:gameCome(messageObj);
            elseif "leave"==tag then
			--log(Message);
                this:gameLeave(messageObj);
            elseif "waitupdealer"==tag then --提示：等待玩家上庄
			--log(Message);
                this:gameWaitBankup(messageObj);
            elseif "updealer_fail_nomoney"==tag then--提示：钱数不足xxx，无法上庄
			--log(Message);
                this:gameBankUpFail(messageObj);
            elseif "updealer"==tag then--加入上庄列表
			--log(Message);
                this:gameBankUp(messageObj);
            elseif "downdealer"==tag then--下庄
			--log(Message);
                this:gameBankDown(messageObj);
            elseif "update_dealers"==tag then--换庄
			--log(Message);
                coroutine.start(this.gameBankUpdate,this,messageObj);
            elseif "waitplayerbet"==tag then--提示：等待玩家下注
			--log(Message);
                coroutine.start(this.gameWaitBet,this,messageObj,false);
            elseif "badbet"==tag then--下注失败
			--log(Message);
                this:gameBadBet(messageObj);
            elseif "mybet"==tag then--我下注成功
			--log(Message);
                this:gameMyBet(messageObj);
            elseif "bet"==tag then--其他人下注
                this:gameBet(messageObj);
            elseif "gameover"==tag then--本局结束
			--log(Message);
                coroutine.start(this.gameOver,this,messageObj);
            elseif "freetime"==tag then--空闲阶段
			--log(Message);
                this:gameFreeTime(messageObj);
            elseif "waitdealer"==tag then--提示：等待庄家押宝
			--log(Message);
                this:gameWaitDealer(messageObj);
            elseif "dealerbet"==tag then--庄家押宝
			--log(Message);
                this:gameDealerBet(messageObj);
            elseif "hurry"==tag then--庄家押宝
			--log(Message);
                this:gameHurry(messageObj);
            elseif "repeat_bet"==tag then
			--log(Message);
                this:gameRepeat_bet(messageObj);
			end
        elseif "sys"==type then
        
            if "error"==tag then
			--log(Message);
                coroutine.start(this.gameUserQuit,this,messageObj);
			end
        end
	end
end

function this:gameEnter(json)
	this:ReturnInit();
	local body=json["body"];
	local mymoney=body["mymoney"];--我带入的钱数
	local betmoneys = body["betmoneys"];--所有人在八个车标分别下注的金钱总数
	local mybetmoneys = body["mybetmoneys"];--自己在八个车标分别下注的金钱总数
    local pot = body["pot"];--所有下注区域总钱数
    local min_dealermoney = body["min_dealermoney"];--最小上庄钱数
    local day_rank10 = body["day_rank10"];--当日排名  金钱排名前十的玩家信息【uid，赢钱，昵称，总钱数，头像,是否NPC】
    local unit_money = body["unit_money"];--最小筹码钱数
    local step = body["step"];--当前阶段( 0:等待开始 1:庄家押宝 2:闲家下注 3:结束阶段 ),
    local dealer_times = body["dealer_times"];--当前连庄的次数
    local max_dealertimes = body["max_dealertimes"];--最大连庄局数
    local jsarr = body["members"];--所有进入的玩家信息
    local seats = body["seats"];--在座玩家（暂时没有）
    local winzodics = body["path"];--前十五局的选中车标
    local chips = body["chips"];--下注筹码的选择
    Banker_uid = tonumber(body["dealer"]);--庄家的id
    local max_playerbetmoney = body["max_playerbetmoney"];--玩家最大的下注金额
    local dealers = body["dealers"];--上庄列表
    local mybetmoney = body["mybetmoney"];--我的下注金钱总数
    bankerWinAllMoney = tonumber(body["dealer_winlost"]);--庄家赢的次数

	--每局选中的车标
	paths={};
	local leng=#(winzodics);
	--log(tostring(leng));
	if winzodics and leng>0 then
		local jsItem=nil;
		for i=1,leng do
			jsItem=winzodics[i];
			--log(tostring(jsItem));
			table.insert(paths,1,(tonumber(jsItem)+1));
		end
		while(#(paths)>6) do
			table.remove(paths,7);
		end
		--log("paths个数");
		--log(#(paths));
		--log("所有的paths");
		--for i=1,#(paths) do
			--log(paths[i]);
		--end
		Tools.drawPathGrid_1(this.chebiaoPath,paths,#(paths));
	end
	
	lianzhuangCount=tonumber(max_dealertimes);
	shengyuzhuangCount=lianzhuangCount-tonumber(dealer_times);
	if shengyuzhuangCount<1 then
		shengyuzhuangCount=tonumber(max_dealertimes);
	end
	
	if not re_enter then
		if isPrimary then
			table.insert(canChips,tonumber(chips[1]));
			eDuIndex=1;
			selectMoney=canChips[1];
			this.EduZhizhen.transform.localEulerAngles=Vector3.New(0,0,0);
		else
			for i=1,#(chips) do
				table.insert(canChips,tonumber(chips[i]));
			end
			eDuIndex=#(canChips);
			selectMoney=canChips[eDuIndex];
			this.EduZhizhen.transform.localEulerAngles=Vector3.New(0,0,-140);
		end	
		this.SelectMoney.text=this:HuanSuanMoney(selectMoney);
	end
	
	local player=nil;
	players={};
	for i=1,#(jsarr) do
		player=GPlayer:New(jsarr[i]);
		players[player.uid]=player;
		if player.uid==tonumber(SocketConnectInfo.Instance.userId) then
			this.ownplayer=player;
		end
	end
 	
	ownbetMoneyCount=tonumber(this.ownplayer.money);
	
	--上庄列表上信息的显示
	bankupInfos={};
	for i=1,#(dealers) do
		table.insert(bankupInfos,this:GetPlayer(tonumber(dealers[i][1])));
	end
	this:ResetBakupList();
	
	--庄家信息的显示
	if Banker_uid~=0 then
		if tostring(Banker_uid)==EginUser.Instance.uid then
			this.wantUpBanker.spriteName="xiazhuang";
			this.shangzhuangButton:GetComponent("UISprite").spriteName="xiazhuang";
			for i=1,8 do
				deskBet[i]:GetComponent("BoxCollider").enabled=false;
				deskBetBg[i]:SetActive(true);
			end
			this:ShowOrHideXuYa(false);
		end
	end
	
	--获取到庄家的信息
	local bealer=this:GetPlayer(Banker_uid);
	this.banker=bealer;
	if #(this.banker.nickname)>6 then
		this.banker_name.text=SubUTF8String(this.banker.nickname,12).."...";
	else
	   this.banker_name.text=this.banker.nickname;
	end
 	this.banker_level.text="a"..tostring(this.banker.leave);
	this.banker_avatar.spriteName="avatar_"..tostring(this.banker.avatar);
	local money=tonumber(this.banker.money);
	this.banker_money.text=this:HuanSuanMoney(money);
	this.banker_shengyujushu.spriteName="shengyujushu_"..tostring(shengyuzhuangCount);
	
	--自己所有信息的显示
	local userplayObj=this:GetPlayer(tonumber(EginUser.Instance.uid));
	this.own_avatar.spriteName="avatar_"..tostring(userplayObj.avatar);
	this.own_bagmoney.text=this:HuanSuanMoney(mymoney);	
	if #(userplayObj.nickname)>6 then
		this.own_nickname.text=SubUTF8String(userplayObj.nickname,12).."...";
	else
	    this.own_nickname.text=userplayObj.nickname;
	end
	
	--进入游戏时的所有下注消息的显示
	for i=1,#(mybetmoneys) do
		betOwn[i].text=this:HuanSuanMoney(mybetmoneys[i]);
		ownBetCount_1[i]=tonumber(mybetmoneys[i]);
		ownBetCount_2[i]=tonumber(mybetmoneys[i]);
		if tonumber(mybetmoneys[i])>0 then
			alreadyBet=true;
		end
	end
	for i=1,#(betmoneys) do
		betAll[i].text=this:HuanSuanMoney(betmoneys[i]);
	end
	if not alreadyBet then
		this:ShowOrHideXuYa(false);
	end
	
	if #(day_rank10)>1 then
		for i=1,#(day_rank10) do
			dangriPaiming[i]:SetActive(true);
			local leng=#(tostring(day_rank10[i][3]));
			if leng>6 then
				dangriName[i].text=SubUTF8String(tostring(day_rank10[i][3]),12).."...";
			else
				dangriName[i].text=tostring(day_rank10[i][3]);
			end
			local money=tonumber(day_rank10[i][2]);
			dangriMoney[i].text=this:HuanSuanMoney(money);
		end
	end
	
	--log("step");
	--log(step);
	if step==0 then
		this.mTimer:SetMaxTime(0);
		return;
	end
	local timeout=tonumber(body["timeout"]);
	this.mTimer:SetMaxTime(timeout);
	if step==1 then
		canBet=true;
		enterCanBet=true;
		this.chedeng:SetActive(false);
		this.xianjia_bet:SetActive(true);
		this.NeedEnabled=true;
		this:ShowOrHideEdu(true);
		this:ShowOrHideXuYa(false);
		for i=1,#(deskBet) do
			deskBet[i]:GetComponent("BoxCollider").enabled=true;
			deskBetBg[i]:SetActive(false);
		end
	elseif step==2 then
		canBet=false;
		enterGame=true;
		for i=1,#(deskBet) do
			deskBet[i]:GetComponent("BoxCollider").enabled=false;
			deskBetBg[i]:SetActive(true);
		end
		--log("隐藏额度和续压");
		this:ShowOrHideEdu(false);
		this:ShowOrHideXuYa(false);
	elseif step==3 then
	     --等待玩家就绪
 	end
	
	
end

function this:gameCome(json)
	local body=json["body"];
	if #(body)>6 then
		table.insert(players,GPlayer:New(body));
	end
end

function this:gameLeave(json)

	local leaveID=tonumber(json["body"]);
	players[leaveID]=nil;
end

function this:gameWaitBankup(json)

end

function this:gameBankUpFail(json)

	--金钱不足xxx，无法上庄
	this.mxErrorToast:Show(2,SimpleFrameworkUtilstringFormat(XMLResource.Instance:Str("mx_updealer_fail_nomoney"), tonumber(json["body"])));
	this:CheckBetButtonEnable(true);
end


function this:gameBankUp(json)

	local uid=tonumber(json["body"][1]);
	if uid==tonumber(SocketConnectInfo.Instance.userId) then
		ownInBanker=true;
	end
	table.insert(bankupInfos,this:GetPlayer(uid));
	this:ResetBakupList();
end

function this:gameBankDown(json)

	local uid=tonumber(json["body"][1]);
	if uid==tonumber(SocketConnectInfo.Instance.userId) then
		ownInBanker=false;
	end
	table.remove(bankupInfos,tableKey(bankupInfos,this:GetPlayer(uid)));
	this:ResetBakupList();
	if #(bankupInfos)>0 then
		local player=bankupInfos[1];
		if this.banker==nil or this.banker.uid~=player.uid then
			baktime=0;
			if #(player.nickname)>6 then
				this.banker_name.text=SubUTF8String(player.nickname,12).."...";
			else
			    this.banker_name.text=player.nickname;
			end
			this.banker_level.text="a"..tostring(player.level);
			this.banker_avatar.spriteName="avatar_"..tostring(player.avatar);
			local money=tonumber(player.money);
			this.banker_money.text=this:HuanSuanMoney(money);
			this.banker_shengyujushu.spriteName="shengyujushu_"..3;
			
			this:ResetBakupList();
			this.banker=player;
			Banker_uid=this.banker.uid;
		end
	end
end

--{"body": [[124843, "aisnil", true, 177812307, -50341400]], "tag": "update_dealers", "type": "jshc"}
function this:gameBankUpdate(json)

	updateBanker=true;
	local binfos=json["body"];
	bankupInfos={};
	for i=1,#(binfos) do
		table.insert(bankupInfos,this:GetPlayer(tonumber(binfos[i][1])));
	end
	
	local player=bankupInfos[1];
	local bankerPlayer=this:GetPlayer(Banker_uid);
	this.huanzhuang_banker_avatar.spriteName="avatar_"..tostring(bankerPlayer.avatar);
	this.next_banker_avatar.spriteName="avatar_"..tostring(player.avatar);
	this.huanzhuang_banker_level.text="a"..tostring(bankerPlayer.level);
	this.next_banker_level.text="a"..tostring(player.level);
	this.huanzhuang_banker_nickname.text=bankerPlayer.nickname;
	this.next_banker_nickname.text=player.nickname;
	this.huanzhuang_banker_money.text=tostring(bankerPlayer.money);
	this.next_banker_money.text=tostring(player.money);
	if tonumber(bankerWinAllMoney)>=0 then
		this.winorlose_Sprite.spriteName="win";
	else
	    this.winorlose_Sprite.spriteName="lose";
	end
	this.huanzhuang_banker_winmoney.text=tostring(bankerWinAllMoney);
	bankerWinAllMoney=0;
	if this.shangzhuangPanel.activeSelf then
		this.shangzhuangPanel:SetActive(false);
	end
	this.updateBankerPanel:SetActive(true);
	
	Banker_uid=tonumber(player.uid);
	if Banker_uid==tonumber(EginUser.Instance.uid) then
		this.wantUpBanker.spriteName="xiazhuang";
		this.shangzhuangButton:GetComponent("UISprite").spriteName="xiazhuang";
		for i=1,#(deskBet) do
			deskBet[i]:GetComponent("BoxCollider").enabled=false;
			deskBetBg[i]:SetActive(true);
		end
		this:ShowOrHideXuYa(false);
	end
	
	if this.banker==nil or this.banker.uid~=player.uid then
		baktime=0;
		local leng=#(player.nickname);
		if leng>6 then
			this.banker_name.text=SubUTF8String(player.nickname,12).."...";
		else
			this.banker_name.text=player.nickname;
		end
		this.banker_level.text="a"..tostring(player.level);
		this.banker_avatar.spriteName="avatar_"..tostring(player.avatar);
		local money=tonumber(player.money);
		this.banker_money.text=this:HuanSuanMoney(money);
		this.banker_shengyujushu.spriteName="shengyujushu_"..tostring(lianzhuangCount);
		this:ResetBakupList();
		this.banker=player;
	end
	
	shengyuzhuangCount=lianzhuangCount;
	coroutine.wait(3);
	this.updateBankerPanel:SetActive(false);	
end

--{"body": {"timeout": 22}, "tag": "waitplayerbet", "type": "jshc"}
function this:gameWaitBet(json,chonglian)

    this.NeedEnabled=false;
	for i=1,#(ownBetCount_2) do    
		if ownBetCount_2[i]>0 then
			alreadyBet=true;
		end
	end
	
	
	for i=1,#(ownBetCount) do
		ownBetCount[i]=0;
		ownBetCount_1[i]=0;
		ownBetCount_2[i]=0;
	end
    canBet=true;
	if updateBanker then
		updateBanker=false;
	else
		if not chonglian then
			shengyuzhuangCount=shengyuzhuangCount-1;
		end
		if shengyuzhuangCount<1 then
			shengyuzhuangCount=lianzhuangCount;
		end
	end
	this.banker_shengyujushu.spriteName="shengyujushu_"..tostring(shengyuzhuangCount);
	showBetAllCount=false;
	
	if Banker_uid==tonumber(EginUser.Instance.uid) then
		this.wantUpBanker.spriteName="xiazhuang";
		this.shangzhuangButton:GetComponent("UISprite").spriteName="xiazhuang";
		for i=1,#(deskBet) do
			deskBet[i]:GetComponent("BoxCollider").enabled=false;
			deskBetBg[i]:SetActive(true);
		end
		this:ShowOrHideXuYa(false);
	else
		for i=1,#(deskBet) do
			deskBet[i]:GetComponent("BoxCollider").enabled=true;
			deskBetBg[i]:SetActive(false);
		end
		this:ShowOrHideEdu(true);
		if alreadyBet then
			this:ShowOrHideXuYa(true);
		else
			this:ShowOrHideXuYa(false);
		end
	end
	
	--local timeout=tonumber(json["body"]["timeout"]);
	local time_1=7;
	this.mTimer:SetMaxTime(time_1);
	this.banker_kaijiang:SetActive(true);
	this.xianjia_bet:SetActive(false);
	this.chedeng:SetActive(false);
	
	if Banker_uid~=tonumber(EginUser.Instance.uid) then
		coroutine.start(this.showAllMoney,this);
	end
	coroutine.wait(7);
	this.NeedEnabled=true;
	local time_2=15;
	this.mTimer:SetMaxTime(time_2);
	this.banker_kaijiang:SetActive(false);
	this.xianjia_bet:SetActive(true);
	this.chedeng:SetActive(false);
end

function this:showAllMoney()
	coroutine.wait(6.9);
	showBetAllCount=true;
	for i=1,#(betOwn) do 
		--log(ownAllBetCount_1[i]);
		if ownAllBetCount_1[i]<ownBetCount_1[i] then
			betAll[i].text=betOwn[i].text;
		end
	end
end

function this:gameBadBet(json)

	local errCode=tonumber(json["body"]);
	local errMsg=nil;
	if errCode==0 then
		errMsg=XMLResource.Instance.Str("mx_bet_err_0");
	elseif errCode==1 then
		errMsg=XMLResource.Instance.Str("mx_bet_err_1");
	elseif errCode==2 then
		errMsg=XMLResource.Instance.Str("mx_bet_err_2");
	elseif errCode==3 then
		errMsg=XMLResource.Instance.Str("mx_bet_err_3");
	end
	
end

function this:gameMyBet(json)

	local body=json["body"];
	local betmoney=tonumber(body[1]);
	local allMoney=tonumber(body[3]);
	local index=tonumber(body[2]);
	index=index+1;
	ownBetCount_2[index]=ownBetCount_2[index]+betmoney;
	if clickXuYa or enterCanBet or this.NeedEnabled then
		if clickXuYa then
		--log("点击续压");
		--log(index);
			betOwn[index].text=this:HuanSuanMoney(betmoney);
			ownBetCount_1[index]=ownBetCount_1[index]+betmoney;
		end
		--log("改变总下注");
		if this.NeedEnabled then
			betAll[index].text=this:HuanSuanMoney(allMoney);
		end
	end
	
	
	ownbetMoneyCount=ownbetMoneyCount-betmoney;
	this.own_bagmoney.text=this:HuanSuanMoney(ownbetMoneyCount);
end

--{"body": [5, 629200, 100], "tag": "bet", "type": "jshc"}
function this:gameBet(json)
	local curTime=Tools.CurrentTimeMillis();
	local body=json["body"];
	local allMoney=tonumber(body[2]);
	local index=tonumber(body[1]);
	--log(tostring(allMoney));
	ownAllBetCount_1[index+1]=allMoney;
	betAll[index+1].text=this:HuanSuanMoney(allMoney)
end

function this:gameOver(json)
	enterCanBet=false;
	alreadyBet=false;
	for i=1,#(ownBetCount_2) do
		betOwn[i].text=this:HuanSuanMoney(ownBetCount_2[i]);
		ownAllBetCount[i]=ownBetCount_2[i];
		ownAllBetCount_1[i]=0;
	end
	for i=1,#(animaSprite) do
		animaSprite[i].enabled=false;
		animaSprite[i]:GetComponent("UISprite").alpha=1;
	end
	this.chedeng:SetActive(true);
	this.banker_kaijiang:SetActive(false);
	this.xianjia_bet:SetActive(false);
	
	local body=json["body"];
	local timeout=tonumber(body["timeout"]);--倒计时时间
	local winzodics=tonumber(body["win_zodic"]);--抽奖区最后选中的车标的index
	local day_rank10=body["day_rank10"];--当日前十排名
	local cur_rank10=body["cur_rank10"];--本局前十排名
	canBet=false;--不可以再下注
	
	--本局赢钱最多的人
	local winuserId=tonumber(cur_rank10[1][1]);
	--log(tostring(winuserId));
	local winmoney=tonumber(cur_rank10[1][2]);
	--log(tostring(winmoney));
	
	--判断是否存在此玩家
	--[[
	local cunzai=false;
	for key,value in pairs(players) do
		log(value.uid);
		if tonumber(value.uid)==winuserId then
			cunzai=true;
			log("存在此玩家");
			log("true");
		end
	end
	log(cunzai);
	
	if not cunzai then
		log("不存在此玩家");
	end
	]]
	local Winplayer=this:GetPlayer(winuserId);
	--log(Winplayer.nickname);
	if Winplayer~=nil then
		this.win_avatar.spriteName="avatar_"..tostring(Winplayer.avatar);
		this.win_level.text="a"..tostring(Winplayer.level);
		if #(Winplayer.nickname)>6 then
			this.win_nickname.text=SubUTF8String(Winplayer.nickname,12).."...";
		else
			this.win_nickname.text=Winplayer.nickname;
		end
 	end
	this.win_money.text=this:HuanSuanMoney(winmoney);
	--log(this.win_money.text);
	if #(tostring(winmoney))>5 then
		this.win_money.text=SubUTF8String(this.win_money.text,#(this.win_money.text)-2).."a";
	end
	--log(this.win_money.text);
	
	this.mDaoJiShi.enabled=true;
	
	this.mDaoJiShi:CrossFade("daojishi",0);
	
	this.InvokeLua:InvokeRepeating("playAnimaMusic",this.playAnimaMusic,0,1);
	coroutine.wait(3);
	this.InvokeLua:CancelInvoke("playAnimaMusic");
	--log("音量");
	--log(UISoundManager.Instance._EFVolume);
	UISoundManager.Instance.PlaySound("choujiang_paodeng");
	--log("选中的车标");
	--log(tostring(winzodics));
	winzodics=winzodics+1;
	coroutine.start(this.PlayAnima,this,winzodics);
	
	coroutine.wait(5);
	local betThiscount=0;
	if SubUTF8String(betOwn[winzodics].text,-2)=="万" then
		local money=SubUTF8String(betOwn[winzodics].text,#(betOwn[winzodics].text)-2);
		betThiscount=tonumber(tonumber(money)*10000);
	else
		betThiscount=tonumber(betOwn[winzodics].text);
	end
	local Label=animaSprite[jiesuanPosition].transform:FindChild("Label"):GetComponent("UILabel");
	if betThiscount>0 then
		Label.text=this:HuanSuanMoney(betThiscount*beishu[winzodics]);
		Label.gameObject:SetActive(true);
		iTween.MoveTo(Label.gameObject,this.mono:iTweenHashLua("y",Label.transform.localPosition.y+65,"time",1,"delay",1,"easeYype",iTween.EaseType.linear,"islocal",true,"oncomplete",this.HideJieSuanMoney,"oncompleteparams",Label.gameObject,"oncompletetarget",this));
	end
	
	selected_chebiao[winzodics].enabled=true;
	selected_chebiao[winzodics]:CrossFade("chebiao_show",0);
	coroutine.wait(2.5);
	this.jiesuan_winPanel:SetActive(true);
	this:MoveTarget(this.guang_1.gameObject,this.guang_1_endposition.localPosition.x,this.guang_1_endposition.localPosition.y,1,false);
	this:MoveTarget(this.guang_2.gameObject,this.guang_2_endposition.localPosition.x,this.guang_2_endposition.localPosition.y,1,true);
	for i=1,8 do 
		betOwn[i].text=tostring(0);
		betAll[i].text=tostring(0);
	end
	--输赢金钱Lable移动
	local dealer_win=tonumber(body["dealer_win"]);
	bankerWinAllMoney=bankerWinAllMoney+dealer_win;
	
	local moveMoney=nil;
	if dealer_win>=0 then
		this.banker_winMoney.text="+"..this:HuanSuanMoney(dealer_win);
		this.banker_winMoney.gameObject:SetActive(true);
		this.banker_loseMoney.gameObject:SetActive(false);
		moveMoney=this.banker_winMoney.gameObject;
	else
		this.banker_loseMoney.text="-"..this:HuanSuanMoney(math.abs(dealer_win));
		this.banker_winMoney.gameObject:SetActive(false);
		this.banker_loseMoney.gameObject:SetActive(true);
		moveMoney=this.banker_loseMoney.gameObject;
	end
	iTween.MoveTo(moveMoney.gameObject,this.mono:iTweenHashLua("y",moveMoney.transform.localPosition.y+115,"time",1,"easeType",iTween.EaseType.linear,"islocal",true,"oncomplete",this.HideMoneyLabel,"oncompleteparams",moveMoney.gameObject,"oncompletetarget",this));
	
	--中心区六个车标的刷新
	table.insert(paths,1,winzodics);
	while(#(paths)>6) do
			table.remove(paths,7);
	end
	Tools.drawPathGrid_1(this.chebiaoPath,paths,#(paths));--刷新中心区的六个图标
	
	--刷新当日排名以及本局排名
	for i=1,#(day_rank10) do
		dangriPaiming[i]:SetActive(true);
		if #(day_rank10[i][3])>6 then
			dangriName[i].text=SubUTF8String(tostring(day_rank10[i][3]),12).."...";
		else
			dangriName[i].text=tostring(day_rank10[i][3]);
		end
		local money=tonumber(day_rank10[i][2]);
		dangriMoney[i].text=this:HuanSuanMoney(money);
	end
	for i=1,#(cur_rank10) do
		benjuPaiming[i]:SetActive(true);
		local userId=tonumber(cur_rank10[i][1]);
		local player=this:GetPlayer(userId);
		if player~=nil then
			if #(player.nickname)>6 then
				benjuName[i].text=SubUTF8String(player.nickname,12).."...";
			else
				benjuName[i].text=player.nickname;
			end
		end
		local money=tonumber(cur_rank10[i][2]);
		benjuMoney[i].text=this:HuanSuanMoney(money);
	end
	
	local curTime=Tools.CurrentTimeMillis();
	coroutine.wait(3);
	--log("赢家透明度改变");
	--iTween.ValueTo(this.winMessage_bg.gameObject,this.mono:iTweenHashLua("from",1,"to",0,"time",1.5,"onupdate",this.AnimationUpdata2));
	for i=1,15 do
			coroutine.wait(0.1)
			this.winMessage_bg.alpha = 1-0.66*i
			if this.winMessage_bg.alpha <=0 then
				break
			end
		end
		this.winMessage_bg.alpha = 0
	
	
	coroutine.wait(2);
	this.jiesuan_winPanel:SetActive(false);
	this.guang_1.transform.localScale=Vector3.one;
	this.guang_2.transform.localScale=Vector3.one;
	this.winMessage_bg.alpha=1;
	
	local mywin=tonumber(body["mywin"]);--自己赢的的钱数
	this.ownplayer.money=this.ownplayer.money+mywin;
	this.own_bagmoney.text=this:HuanSuanMoney(this.ownplayer.money);
	
	local myIntoMoney=tonumber(body["into_money"]);--玩家下局带入的金钱
	ownbetMoneyCount=myIntoMoney;
	this.own_bagmoney.text=this:HuanSuanMoney(myIntoMoney);
	
	local moneys=body["moneys"];--刷新所有人身上的钱数
	for i=1,#(moneys) do
		local jsarr=moneys[i];
		local player=this:GetPlayer(tonumber(jsarr[1]));
		if player~=nil then
			player.money=tonumber(jsarr[2]);
		end
	end	
	
end


function this:gameFreeTime(json)
	if enterGame then
		for i=1,#(betOwn) do
			betOwn[i].text=tostring(0);
			betAll[i].text=tostring(0);
		end
		enterGame=false;
	end
	this.NeedEnabled=false;
end

function this:AfterDoing(offset,run)
	coroutine.wait(offset);
	if this.mono then
		run();
	end
end

function this:gameWaitDealer(json)

end

function this:gameDealerBet(json)

end

function this:gameHurry(json)

end

function this:gameRepeat_bet(json)

end

function this:OnClose(target)
	--log(target.name);
	--log(target.transform.parent.name);
	if target.transform.parent.gameObject.activeSelf then
		target.transform.parent.gameObject:SetActive(false);
	end
end


function this:HuanSuanMoney(money)
	local betmoney=tonumber(money);
	local betmoney=tonumber(money);
	local huansuanMoney=nil;
	if betmoney<100000 then
		huansuanMoney=tostring(betmoney);
	elseif betmoney>=100000 and betmoney<10000000 then
		local chushu=tonumber(betmoney/10000);
		--local zhengshu=tostring(tonumber(betmoney)/10000);
		local zhengshu=math.floor(chushu);
		local yushu=betmoney%10000;
		if yushu~=0 then
			local shuzi=tostring(chushu);
			huansuanMoney=SubUTF8String(shuzi,#(tostring(zhengshu))+2).."万";
		else
			huansuanMoney=zhengshu.."万";
		end
	elseif betmoney>=10000000 and betmoney<100000000 then
		--local chushu=betmoney/10000;
		--huansuanMoney=tostring(chushu).."万";
		local chushu=betmoney/10000;
		local zhengshu=math.floor(chushu);
		local yushu=betmoney%10000;
		if yushu~=0 then
			local shuzi=tostring(chushu);
			huansuanMoney=SubUTF8String(shuzi,#(tostring(zhengshu))+2).."万";
		else
			huansuanMoney=zhengshu.."万";
		end
	else
		local chushu=tonumber(betmoney/100000000);		
		--local zhengshu=tostring(tonumber(betmoney)/100000000);
		local zhengshu=math.floor(chushu);
		local yushu=betmoney%100000000;
		if yushu~=0 then
			local shuzi=tostring(chushu);
			huansuanMoney=SubUTF8String(shuzi,#(tostring(zhengshu))+2).."亿";
		else
			huansuanMoney=zhengshu.."亿";
		end
	end
	return huansuanMoney;
end

function this:playAnimaMusic()
	UISoundManager.Instance.PlaySound("daojishi_321");
end

function this:PlayMusic()
	this.music.volume=1;
	this.music.clip=this.bg_music;
	this.music:Play();
end

function this:MoveTarget(gObj,x,y,timer,show)
	local leixing={};
	leixing[0]=gObj;
	leixing[1]=show;
	leixing[2]=1.0;
	leixing[3]=0.0;
	--log("移动");
	iTween.MoveTo(gObj.gameObject,this.mono:iTweenHashLua("position",Vector3.New(x,y,0),"time",timer,"islocal",true,"oncomplete",this.ScaleChange,"oncompleteparams",leixing,"oncompletetarget",this,"easeType",iTween.EaseType.linear));
	
end

function this:ScaleChange(leixing)
	--log("变形");
	local lei=leixing;
	local x=lei[2];
	local y=lei[3];
	local obj=lei[0];
	local show=lei[1];
	
	iTween.ScaleTo(obj,iTween.Hash("x",x,"y",y,"time",1,"easeType",iTween.EaseType.linear));
end


function this:HideMoneyLabel(target)
	--log("隐藏金钱");
	coroutine.start(this.HideMoveMoney,this,target);
end

function this:HideMoveMoney(target)
	coroutine.wait(0.5);
	--log("开始隐藏金钱");
	target:SetActive(false);
	target.transform.localPosition=this.winorloseTarget.transform.localPosition;
end

function this:HideJieSuanMoney(target)
	target:SetActive(false);
	target.transform.localPosition=Vector3.New(0,-25,0);
end

function this:PlayAnima(index)
    local index_1=tonumber(index);
	for i=1,#(animaSprite) do
		animaSprite[i]:GetComponent("UISprite").alpha=1;
	end
	coroutine.wait(0.01);
	--log("个数");
	--log(tostring(#(animaIndex[index_1])));
	local xiabiao=math.random(#(animaIndex[index_1]));
	--log("xiabiao");
	--log(xiabiao);
	endposition=animaIndex[index_1][xiabiao];
	jiesuanPosition=animaIndex[index_1][xiabiao];
	--log(endposition);
	if endposition-9<1 then
		endposition=endposition+13;
	else
		endposition=endposition-9;
	end

	local v = 0;	
	for   i = 1, 76 do	
		local temp = v;
		--log("开始旋转");
		--log(temp);
		coroutine.start(this.AfterDoing,this,temp,function()
			if endposition>22 then
				endposition=1;
			end
			if i==76 then
				animaSprite[endposition].enabled=true;
				animaSprite[endposition]:Play("selectedChebiao");
			else
			--log("旋转");
			--log(endposition);
				animaSprite[endposition].enabled=true;
				animaSprite[endposition]:CrossFade("zhuandong",0);
			end	
			endposition=endposition+1;
			
		end);
		
		if i<17 then
			--log("11111111111111");
			v = v +(16-i)*0.007+0.03;
		elseif i>=17 and i<=60 then
			--log("22222222222");
			v=v+0.03;
		else
			--log("3333333333333");
			v=v+(i-60)*0.007+0.03;
		end
		
		
	end
	
	
	--[[
	for i=0,76 do
		if endposition>22 then
			endposition=1;
		end
		if i==76 then
			animaSprite[endposition].enabled=true;
			animaSprite[endposition]:Play("selectedChebiao");
		else
			--log("旋转");
			--log(endposition);
			animaSprite[endposition].enabled=true;
			animaSprite[endposition]:CrossFade("zhuandong",0);
		end
		if i<16 then
			coroutine.wait(0.035+(16-i)*0.005);
		elseif i>=16 and i<60 then 
			coroutine.wait(0.035);
		else
		coroutine.wait(0.035+(i-60)*0.005);
		end
		endposition=endposition+1;
	end
	]]
end

function this:AnimationUpdata2(obj)
	--log("改变透明度");
	local per=tonumber(obj);
	this.winMessage_bg.alpha=per;
end

function this:paixu(arr)
	arr.Sort(sortOnLengthMax);
	return arr;
end

function this:sortOnLengthMax(arr_1,arr_2)
	if arr_1>arr_2 then
		return 1;
	elseif arr_1<arr_2 then
		return -1;
	end
	return 0;
end

function this:GameFunction()  
	 local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end 
	--[[
	sceneRoot = GameSettingManager.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	
	end ]]
	destroy(rechatge) 
end
function this:UserChongZhi()
	this.chongzhiPanel:SetActive(false);
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
end




function this:ShowOrHideXuYa(show)
	this.Xuya.transform.localScale=Vector3.one;
	if show then
		this.Xuya:GetComponent("BoxCollider").enabled=true;
		this.Xuya.transform:FindChild("Sprite_1").gameObject:SetActive(false);
		this.Xuya.transform:FindChild("Sprite_2").gameObject:SetActive(true);
		this.Xuya.transform:FindChild("Sprite_3").gameObject:SetActive(true);
	else
		this.Xuya:GetComponent("BoxCollider").enabled=false;
		this.Xuya.transform:FindChild("Sprite_1").gameObject:SetActive(true);
		this.Xuya.transform:FindChild("Sprite_2").gameObject:SetActive(false);
		this.Xuya.transform:FindChild("Sprite_3").gameObject:SetActive(false);	
	end
end


function this:ShowOrHideEdu(show)
	if show then
		this.Edu:GetComponent("BoxCollider").enabled=true;
		this.Edu.transform:FindChild("Sprite_1").gameObject:SetActive(false);
		this.Edu.transform:FindChild("Sprite_2").gameObject:SetActive(true);
		this.Edu.transform:FindChild("Sprite_3").gameObject:SetActive(true);
	else
		this.Edu:GetComponent("BoxCollider").enabled=false;
		this.Edu.transform:FindChild("Sprite_1").gameObject:SetActive(true);
		this.Edu.transform:FindChild("Sprite_2").gameObject:SetActive(false);
		this.Edu.transform:FindChild("Sprite_3").gameObject:SetActive(false);
	end
end

function this:NotClick()
	for i=1,#(deskBet) do
		deskBet[i]:GetComponent("BoxCollider").enabled=false;
		deskBetBg[i]:SetActive(true);
	end
	this:ShowOrHideEdu(false);
	this:ShowOrHideXuYa(false);
end

function this:gameUserQuit(json)
	coroutine.wait(4);
	this.mono:SendPackage(cjson.encode({type="game",tag="quit"}));
	SocketConnectInfo.Instance.rootFixseat=true;
	SocketManager.Instance.socketListener=nil;
	SocketManager.Instance.Disconnect("Exit form the game.");
	EginUserUpdate.Instance.UpdateInfoNow();
end


function this:Update()
	while this.gameObject do
		--log("222222222222222");
		if this.mTimer ~=nil then
			this.mTimer:Update();
		end
		coroutine.wait(0.1);
	end
end


function this:OnDisable()
	this:clearLuaValue()
	
end











function this:AfterDoing(offset, run)
    coroutine.wait(offset);
	if this.gameObject==nil then
		return;
	end
	run();
end





function this:OnDestroy()
	log("--------------------ondestroy of GamePPCPanel")
end