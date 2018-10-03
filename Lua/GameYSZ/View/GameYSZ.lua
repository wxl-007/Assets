require "GameYSZ/YSZPlayerCtrl"
require "GameNN/GToast"
require "GameNN/FootInfo"
require "GameYSZ/VSAnima"
require "GameYSZ/UserActionBtns"
require "GameYSZ/TextAnima"
require "GameYSZ/SoundMgr"
require "GameNN/GPoker"
require "GameYSZ/SendPokerAnimation"

local cjson = require "cjson"

local this = LuaObject:New()
GameYSZ = this


local _nnPlayerName = "YSZPlayer_";--/ 动态生成的玩家实例名字的前缀
local _bankerPlayer = nil;
local _isPlaying = nil;
local _late = nil;
local _reEnter = nil;
local _isfapai = false;--是否已发牌
local ju_time = 15;
local    stepCount = 0;
local init_money = nil;--底注
local Userinto_money = nil;--初始化带入币
local beishu = nil;--下注倍数
local unit_money = nil;--自己下注钱数
local  delayLeaveList = nil;
local delayCallDeskOver = nil;
local checkDelayDeskOver = false;
local _userBagmoney = nil;
local _userIndex = 0;
local isuservs = false;
local isSelfkanpai = false;
local isSelfQ = nil;
local multiple = nil;
local  _playingPlayerList = {};--/ 游戏开始时正在游戏的玩家
local  _waitPlayerList = {};--/ 游戏开始时等待的玩家
local chipMoney = {};
local currentRoundPlayer = {};
local isgameover=false;

function this:clearLuaValue()
	_nnPlayerName = "YSZPlayer_";--/ 动态生成的玩家实例名字的前缀
	_bankerPlayer = nil;
	_isPlaying = nil;
	_late = nil;
	_reEnter = nil;
	_isfapai = false;--是否已发牌
	ju_time = 15;
	stepCount = 0;
	init_money = nil;--底注
	Userinto_money = nil;--初始化带入币
	beishu = nil;--下注倍数
	unit_money = nil;--自己下注钱数
	delayLeaveList = nil;
	delayCallDeskOver = nil;
	checkDelayDeskOver = false;
	_userBagmoney = nil;
	_userIndex = 0;
	isuservs = false;
	isSelfkanpai = false;
	isSelfQ = nil;
	multiple = nil;
	_playingPlayerList = {};--/ 游戏开始时正在游戏的玩家
	_waitPlayerList = {};--/ 游戏开始时等待的玩家
	chipMoney = {};
	currentRoundPlayer = {};
	isgameover=false;
	
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	this.changci = nil; --场次
	this.SceneNo = nil; --游戏场次
	
	this.userPlayerCtrl = nil;--/ 游戏玩家的控制脚本
	this.userPlayerObj = nil;
	this.btnBegin = nil;
	this.MenuBtn = nil
	this.helpBtn = nil
	this.settingBtn = nil
	--this.helpBtnClose = nil
	--this.settingBtnClose = nil
	this.weituoClose = nil;--帮助 --设置
	this.Menu = nil;
	this.help = nil
	this.setting = nil; --帮助设置menu
	this.weituo = nil;
	this.weituobg = nil;
	this.yizhigen = nil
	this.zidongbipai = nil;
	this.zongzhu = nil;--锅底
	this.dzhu = nil;--底注
	this.fzhu = nil;--封顶
	this.shouNum = nil;--手数
	this.paiType = nil;--自己的牌型
	this.msgQuit = nil;--退出
	this.msgAccountFailed = nil;
	this.msgNotContinue = nil;
	this.soundStart = nil;
	this.light = nil;
	this.UserPlayer = nil;--/ 自己
	this.bagmoney = nil;--初始玩家所有的钱
	this.selectPlayerBlack = nil;
	GameYSZ.jettonObjList = nil;
	this.userBtns = nil;
	this.vsAnima = nil;
	this.mxErrorToast = nil;  --错误消息
	this.sendPokerAnima = nil;
	
	this.yszPlayerPrefabs =nil;--/ 同桌其他玩家的预设
	this._yszPlayerCtrl =nil

	this.NNCount = nil;
	this.NNCountNum = nil;
	this.NNCountBg=nil;
	this.lateMessage=nil;

	this.InvokeLua:clearLuaValue();
	this.InvokeLua = nil;
	SoundMgr:clearLuaValue()
	this:RemoveAllYSZPlayerCtrl();
	coroutine.Stop()
	LuaGC();
end
function this:Init()
	
	--初始化变量
	_nnPlayerName = "YSZPlayer_";--/ 动态生成的玩家实例名字的前缀
	_bankerPlayer = nil;
	_isPlaying = nil;
	_late = nil;
	_reEnter = nil;
	_isfapai = false;--是否已发牌
	ju_time = 15;
	stepCount = 0;
	init_money = nil;--底注
	Userinto_money = nil;--初始化带入币
	beishu = nil;--下注倍数
	unit_money = nil;--自己下注钱数
	delayLeaveList = nil;
	delayCallDeskOver = nil;
	checkDelayDeskOver = false;
	_userBagmoney = nil;
	_userIndex = 0;
	isuservs = false;
	isSelfkanpai = false;
	isSelfQ = nil;
	multiple = nil;
	_playingPlayerList = {};--/ 游戏开始时正在游戏的玩家
	_waitPlayerList = {};--/ 游戏开始时等待的玩家
	chipMoney = {};
	currentRoundPlayer = {};
	this.lateMessage={};
	GameYSZ.jettonObjList = {};
	
	this.changci = this.transform:FindChild("Content/scene_bg").gameObject; --场次
	this.SceneNo = this.transform:FindChild("Content/scene_bg/scene_no").gameObject:GetComponent("UILabel"); --游戏场次
	
	this.userPlayerCtrl = nil;--/ 游戏玩家的控制脚本
	this.userPlayerObj = this.transform:FindChild("Content/User").gameObject;
	this.btnBegin = this.transform:FindChild("Content/User/Button_begin").gameObject;
	this.MenuBtn = this.transform:FindChild("Button_Menu").gameObject:GetComponent("UISprite")
	
	this.Menu = this.transform:FindChild("Content/Menus/menulist").gameObject;
	this.help = this.transform:FindChild("Content/Menus/helpmenu").gameObject
	this.setting = this.transform:FindChild("Content/Menus/settingmenu").gameObject; --帮助设置menu
	this.weituo = this.transform:FindChild("Content/FootInfo/Foot - Anchor/Info/weituo").gameObject;
	this.weituobg = this.transform:FindChild("weituo").gameObject;
	this.yizhigen = this.transform:FindChild("weituo/weituobg/gendaodi").gameObject
	this.zidongbipai = this.transform:FindChild("weituo/weituobg/zidongbipai").gameObject;
	this.zongzhu = this.transform:FindChild("zongzhu/zongzhu_Lab").gameObject:GetComponent("UILabel");--锅底
	
	this.btnXiala=this.transform:FindChild("Panel_button/Button_xiala").gameObject;
	this.btnXiala_bg=this.btnXiala.transform:FindChild("Background"):GetComponent("UISprite");
	this.btn_shelet=this.transform:FindChild("Panel_button/Button_xiala/panel/shelet").gameObject;
	this.helpBtn = this.transform:FindChild("Panel_button/Button_xiala/panel/Button_help").gameObject
	this.settingBtn = this.transform:FindChild("Panel_button/Button_xiala/panel/Button_setting").gameObject
	this.btn_emotion=this.transform:FindChild("Panel_button/Button_xiala/panel/Button_emotion").gameObject;
	--this.helpBtnClose = this.transform:FindChild("Content/Menus/helpmenu/Close").gameObject:GetComponent("UISprite")
	--this.settingBtnClose = this.transform:FindChild("Content/Menus/settingmenu/close").gameObject:GetComponent("UISprite")
	this.weituoClose = this.transform:FindChild("weituo/weituobg/Colse").gameObject:GetComponent("UISprite");--帮助 --设置



	this.dzhu =  this.transform:FindChild("Content/Dchip/Dzhu").gameObject:GetComponent("UILabel");--底注
	this.fzhu =  this.transform:FindChild("Content/Dchip/Fzhu").gameObject:GetComponent("UILabel");--封顶
	this.shouNum =  this.transform:FindChild("Content/Dchip/shouNum").gameObject:GetComponent("UILabel");--手数
	this.paiType = this.transform:FindChild("Content/User/Output/ShowpaiType").gameObject;--自己的牌型
	this.msgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject;--退出
	this.msgAccountFailed = this.transform:FindChild("Content/MsgContainer/MsgAccountFailed").gameObject;
	this.msgNotContinue = this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject;
	this.soundStart = ResManager:LoadAsset("gameysz/YSZ_REF_SFX","start");
	
	this.light = this.transform:FindChild("Content/light").gameObject;
	this.UserPlayer = this.transform:FindChild("Content/FootInfo").gameObject;--/ 自己
	this.bagmoney = 0;--初始玩家所有的钱
	this.selectPlayerBlack = this.transform:FindChild("chooseVSBg").gameObject;
	
	local userBtnsObj = this.transform:FindChild("Content/User/Btngroup").gameObject
	this.userBtns = UserActionBtns:New(userBtnsObj);
	this.userBtns.yszMain = this;
	local vsAnimaObj = this.transform:FindChild("VS_AnimaLayer").gameObject
	this.vsAnima = VSAnima:New(vsAnimaObj);
	local mxErrorToastObj = this.transform:FindChild("GameToastError").gameObject
	this.mxErrorToast = GToast:New(mxErrorToastObj);  --错误消息
	local sendPokerAnimaObj = this.transform:FindChild("Content/SendPoker").gameObject
	this.sendPokerAnima = SendPokerAnimation:New(sendPokerAnimaObj);
	
	this.yszPlayerPrefabs ={
	ResManager:LoadAsset("gameysz/Prefabs","YSZPlayer_1"),
	ResManager:LoadAsset("gameysz/Prefabs","YSZPlayer_2"),
	ResManager:LoadAsset("gameysz/Prefabs","YSZPlayer_3"),
	ResManager:LoadAsset("gameysz/Prefabs","YSZPlayer_4"),};--/ 同桌其他玩家的预设
	
	this._yszPlayerCtrl ={}
	this.NNCount = this.transform:FindChild("Content/NNCount/NNCount").gameObject:GetComponent("Animator")	
	this.NNCountNum = this.transform:FindChild("Content/NNCount/NNCount/Sprite").gameObject:GetComponent("UILabel")	
	this.NNCountBg= this.transform:FindChild("Content/NNCount/NNCount/Time_count").gameObject:GetComponent("UISprite")	
	this.InvokeLua = InvokeLua:New(this);
end

function this:Awake()
	log("------------------awake of GameYSZPanel")
	--local changeScreen=Utils.changeScreen();

	this:Init();
	
	----------绑定按钮事件--------

	--确认退出按钮--
	local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
	this.mono:AddClick(btn_MsgQuit, this.UserQuit);
	
	local btn_jia = this.transform:FindChild("Content/User/BtnJia").gameObject
	this.mono:AddClick(btn_jia, this.UserButton,this);
	
	this.mono:AddClick(this.btnBegin, this.UserReady,this);
	
	local btnkanpai = this.transform:FindChild("Content/User/Btngroup/Btnkanpai").gameObject
	this.mono:AddClick(btnkanpai, this.UserShowpai,this);
	
	local btnqipai = this.transform:FindChild("Content/User/Btngroup/Btnqipai").gameObject
	this.mono:AddClick(btnqipai, this.UserQipai,this);
	
	local btnbipai = this.transform:FindChild("Content/User/Btngroup/Btnbipai").gameObject
	this.mono:AddClick(btnbipai, this.UserSelectCharacter,this);
	
	for i= 0 ,3 do
		local tempNum = this.transform:FindChild("Content/User/Btngroup/"..i).gameObject
		this.mono:AddClick(tempNum, this.UserChip,this);
	end
	
	this.mono:AddClick(this.weituo, this.UserButton,this);
	--this.mono:AddClick(this.settingBtnClose.gameObject, this.UserButton,this);
	
	--this.mono:AddClick(this.helpBtnClose.gameObject, this.UserButton,this);
	
	local Exit = this.transform:FindChild("Panel_button/Button_back").gameObject
	this.mono:AddClick(Exit, this.OnClickBack,this);
	
	local changedesk = this.transform:FindChild("Content/Menus/menulist/changedesk").gameObject
	this.mono:AddClick(changedesk, this.UserChangedesk,this);
	
	
	this.mono:AddClick(this.helpBtn.gameObject, this.UserButton,this);
	
	this.mono:AddClick(this.settingBtn.gameObject, this.UserButton,this);
	
	this.mono:AddClick(this.MenuBtn.gameObject, this.UserButton,this);
	
	this.mono:AddClick(this.zidongbipai, this.autoVSHandle,this);
	
	this.mono:AddClick(this.weituoClose.gameObject, this.UserButton,this);
	
	this.mono:AddClick(this.yizhigen, this.SetChipmin,this);

	this.mono:AddClick(this.btnXiala,this.OnButtonClick,this);
	this.mono:AddClick(this.settingBtn,this.OnButtonClick,this);
	this.mono:AddClick(this.helpBtn,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_emotion,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_shelet,this.OnButtonClick,this);
	
	local sprite5_glow_black = this.transform:FindChild("Panel_background/Sprite5_glow_black").gameObject
	this.mono:AddClick(sprite5_glow_black, this.CloseView,this);
	this.userBtns:AddClick(this.mono);
	
	----------初始化声音模块--------
	SoundMgr:Awake(this.transform:FindChild("SoundMgr").gameObject,ResManager:LoadAsset("gameysz/YSZ_REF_SFX","bgm"),this.transform:FindChild("Content/Menus/settingmenu/MusicSlider").gameObject:GetComponent("UISlider"),this.transform:FindChild("Content/Menus/settingmenu/SoundSlider").gameObject:GetComponent("UISlider"),this.mono);
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","addJ0"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","addJ1"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","follow0"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","follow1"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","giveup0"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","giveup1"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","seeCard0"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","seeCard1"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","vs0"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","vs1"));
	SoundMgr:AddClipAry1(ResManager:LoadAsset("gameysz/YSZ_REF_SFX","giveupOver"));

	SoundMgr.clipDeal = ResManager:LoadAsset("gameysz/YSZ_REF_SFX","deal");
	SoundMgr.clipBet = ResManager:LoadAsset("gameysz/YSZ_REF_SFX","Bet");
	SoundMgr.clipWin = ResManager:LoadAsset("gameysz/YSZ_REF_SFX","win");
	SoundMgr.clipLose = ResManager:LoadAsset("gameysz/YSZ_REF_SFX","game_lost");
	SoundMgr.clipVs = ResManager:LoadAsset("gameysz/YSZ_REF_SFX","bipai");

	
	
	------------逻辑代码------------	
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1920;
		sceneRoot.manualWidth = 1080;
	end


	local info = GameObject.Find("FootInfo");
	if nil == info then
		
		this.UserPlayer:SetActive(true);
	end
	delayLeaveList = {};
	this.userBtns:hideGroup();
end

function this:Start()

	this.SceneNo.text = SocketConnectInfo.Instance.roomTitle;
	SettingInfo.Instance.chipmin = false;
	SettingInfo.Instance.YSZ_autoVS = false;

	local info = GameObject.Find("FootInfo");
	if info ~= nil then
		FootInfo.AvatarPrefix = "avatar_";
		_userBagmoney = info.transform:FindChild("Foot - Anchor"):FindChild("Info"):FindChild("Money"):FindChild("Label_Bagmoney"):GetComponent("UILabel");
	end

	---if SettingInfo.Instance.autoNext == true then
		--this.btnBegin:SetActive(false);
	--end
	--声音模块执行开始函数
	SoundMgr:Start();
	
	this.mono:StartGameSocket();
	--NNCount.Instance:toShakeStyle();
	
	coroutine.start(this.Update);
	coroutine.start(this.UpdateTime);
end

function this:OnDisable()
	this:clearLuaValue()
	
end

function this:Update()
	while this.mono do
		for key,v in pairs(this._yszPlayerCtrl) do
			if v.gameObject then
				v:Update();
			end
		end
		coroutine.wait(Time.deltaTime);
	end
end


--Hide
function this:Hidechangci()

	if this.changci:GetComponent("UISprite").alpha > 0 then
		this.InvokeLua:InvokeRepeating("TimeSprite",this.TimeSprite, 0, 0.9);
	end

	this.InvokeLua:InvokeRepeating("DisableHidechangci",this.DisableHidechangci, 5, 1);
end
function this:DisableHidechangci()
	this.InvokeLua:CancelInvoke("TimeSprite");
end

function this:TimeSprite()
	this.changci:GetComponent("UISprite").alpha = this.changci:GetComponent("UISprite").alpha -0.3;
end
--获取_YSZPlayerCtrl对象YSZPlayerCtrl
function this:GetYSZPlayerCtrl(tbName,tbObj)
	
	local yszTemp = this._yszPlayerCtrl[tbName]
	if yszTemp == nil then
		
		if not IsNil(tbObj) then
			this._yszPlayerCtrl[tbName] = YSZPlayerCtrl:New(tbObj);
			yszTemp = this._yszPlayerCtrl[tbName]
		end
	end
	return yszTemp
end
function this:ReplaceNameYSZPlayerCtrl(oldName,newName)
	
	if oldName ~= newName then
		local yszTemp = this._yszPlayerCtrl[oldName]
		if yszTemp ~= nil then
			this._yszPlayerCtrl[newName] = yszTemp
			this._yszPlayerCtrl[oldName] = nil
		end
	end
end
--删除_tbwzPlayerCtrl对象
function this:RemoveYSZPlayerCtrl(tbName)
	
	local yszTemp = this._yszPlayerCtrl[tbName];
	if yszTemp then
		yszTemp._alive = false;
		yszTemp:clearLuaValue();
		this._yszPlayerCtrl[tbName] = nil;
		yszTemp = nil;
	end
end
function this:RemoveAllYSZPlayerCtrl()
	if this._yszPlayerCtrl then
		for key,v in ipairs(this._yszPlayerCtrl) do
			v._alive = false;
			v:clearLuaValue();
		end
		this._yszPlayerCtrl = nil;
	end
end
----解析JSON
function this:SocketReceiveMessage(Message)
	local Message = self;
	if  Message then
		--解析json字符串
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];
		--log(Message) 
		if "game"==typeC then 
			if "enter"==tag then
				log(Message)
				local info = GameObject.Find("FootInfo");
				if info ~= nil then
					info:SetActive(true);
				end
				coroutine.start(this.ProcessEnter,this,(messageObj));
			elseif "ready"==tag then
				log(Message)
				--log(isgameover);		
				if isgameover then
					table.insert(this.lateMessage,messageObj);
				else
					this:ProcessReady(messageObj);
				end	
			elseif "come"==tag then
				log(Message)
				--log(isgameover);			
				if isgameover then
					table.insert(this.lateMessage,messageObj);
				else
					this:ProcessCome(messageObj);
				end	
			elseif "leave"==tag then
				log(Message)
				--log(isgameover);		
				if isgameover then
					table.insert(this.lateMessage,messageObj);
				else
					this:ProcessLeave(messageObj);
				end	
			elseif "actfinish"==tag then
				this:Processactfinish(messageObj);
			elseif "deskover"==tag then
				if checkDelayDeskOver then
					delayCallDeskOver =  DelayCallMsg:New(messageObj, this.ProcessDeskOver,this);
				else
					coroutine.start(this.ProcessDeskOver,this,(messageObj));
				end
			elseif "notcontinue"==tag then
				coroutine.start(this.ProcessNotcontinue,this,(messageObj));
			elseif "dj"==tag then
				this:ProcessDJ(messageObj);
			end
		elseif "staff"==typeC then
			if "enter"==tag then
				this:ProcessStaff(messageObj);
			end
		elseif "account"==typeC then
			if "update_intomoney"==tag then
				this:ProcessUpdate_intomoney(messageObj);
			end
		elseif "gold2"==typeC then
			if "run"==tag then
				log(Message) 
				_isPlaying = true;
				coroutine.start(this.ProcessRun,this,(messageObj));
				_isfapai = true;
			elseif "add"==tag then
				log(Message) 
				if this.vsAnima.isPlaying then
					this.vsAnima.playCompleted2 = this.ProcessAdd;
					this.vsAnima.delayJsonObj2 = messageObj;
					this.vsAnima.playClass2 = this;
					
				else
					coroutine.start(this.ProcessAdd,this,(messageObj));
				end
			elseif "run2"==tag then
				log(Message)
				_isPlaying = true;
				coroutine.start(this.ProcessRun2,this,(messageObj));
			elseif "show"==tag then
				log(Message)
				--看牌
				this:ProcessShow(messageObj);
			elseif "drop"==tag then
				log(Message)
				--弃牌
				coroutine.start(this.ProcessQP,this,(messageObj));
			elseif "vs"==tag then
				log(Message)
				this:ProcessVs(messageObj);
			elseif "over"==tag then
				log(Message)
				checkDelayDeskOver = true;
				if this.vsAnima.isPlaying then
					this.vsAnima.playCompleted = this.ProcessOver;
					this.vsAnima.delayJsonObj = messageObj;
					this.vsAnima.playClass = this;
				else
					coroutine.start(this.ProcessOver,this,(messageObj));
				end
			elseif "ask_banker"==tag then
				log(Message)
				this:ProcessAskbanker(messageObj);
			end
		elseif "seatmatch"==typeC then
			if "on_update"==tag then
				this:ProcessUpdateAllIntomoney(messageObj);
			end
		elseif "gold2"==typeC then
			if "recheckin"==tag then
				local info = GameObject.Find("FootInfo");
				if nil ~= info then
					info:SetActive(true);
				end
				Application.LoadLevelAdditive("Game_Setting");
			end
		end
	end
end

function this:ChuLiXiaoXi()
	if isgameover then
		if #(this.lateMessage)>0 then
			local message=this.lateMessage[1];	
			log("后续消息");
			--printf(this.lateMessage);
			printf(message);
			
			iTableRemove(this.lateMessage,this.lateMessage[1]);
			local typeC=message["type"];
			local tag=message["tag"];
			if tag=="leave" then
				this:ProcessLeave(message);
			elseif tag=="come" then
				this:ProcessCome(message);
			elseif tag=="ready" then
				this:ProcessReady(message);
			end
			coroutine.wait(0.1);
			coroutine.start(this.ChuLiXiaoXi,this);
		else
			isgameover=false;
			this.lateMessage={};
		end
	end
end


function this:ProcessRun(messageObj)
	this.alreadyOver=false;
	isSelfkanpai = false;
	isuservs = false;
	if this.userPlayerCtrl ~= nil then
		this.userPlayerCtrl:SetReady(false);
	end
	this.userBtns:cancelAutoFollow();
	this.btnBegin:SetActive(false);
	currentRoundPlayer = {};
	--初始化发牌
	this.zongzhu.text = "0";
	stepCount = 0;
	this.shouNum.text = stepCount.."";
	local body = messageObj["body"];
	local pk = tonumber(body["pk"]);
	local  rm = body["rm"]; --最大押注倍数，当前押注倍数
	local  us = body["us"];--所有用户Id
	local ply =  tostring(body["ply"]); --当前玩家=庄家5.打包Assetbundle丢失Shader问题（贴图显示不了）
	local runtime = tonumber(body["time"]) ;
	--NNCount.Instance:UpdateHUD(runtime);
	this:UpdateHUD(runtime);
	this.NNCount.transform.parent.gameObject:SetActive(false);
	beishu = tonumber(rm[2]);
	if beishu == 0 then
		beishu = 1;
	end
	chipMoney = { beishu * unit_money, beishu * unit_money * 2, beishu * unit_money * 3, beishu * unit_money * 4 };

	for key,uid in ipairs(us) do
		if uid ~= nil then
			local player = GameObject.Find(_nnPlayerName..uid);
			if player~=nil and not tableContains(_playingPlayerList,player) then
				table.insert(_playingPlayerList,player);
			end
		end
	end

	if ply ~= nil then
		_bankerPlayer = GameObject.Find(_nnPlayerName..ply);
		local playerCtrlTemp = this:GetYSZPlayerCtrl(_bankerPlayer.name);
		playerCtrlTemp:SetBanker(true);
		playerCtrlTemp:SetTime();
	end

	local t = 0.5;
	for  i = 1, #(us) do 
		local num = i;
		local playerCtrl = this:GetYSZPlayerCtrl(_nnPlayerName..tostring(us[num]));
		this.sendPokerAnima:setupPlayer(playerCtrl);
		playerCtrl:SetBet(tonumber(init_money), 0, tonumber(Userinto_money) - tonumber(init_money));
		playerCtrl:SetWait(false);
		playerCtrl:SetShow(true, "xz");
		playerCtrl:showUpNickName();
		playerCtrl:resetCardRotate();
		playerCtrl:resetDeckPos();
		table.insert(currentRoundPlayer,playerCtrl);
	end
	--发牌
	local sendPokerAnimaTime = this.sendPokerAnima:pokerShow();
	EginTools.PlayEffect(this.soundStart);
	coroutine.wait(sendPokerAnimaTime+0.6);
	--log("等待时间"..sendPokerAnimaTime)

	if ply == EginUser.Instance.uid then
		this:lightTo(this:GetYSZPlayerCtrl(_nnPlayerName..EginUser.Instance.uid):getlightPos());
		this.userBtns:showGroup(chipMoney);
		this.userBtns:toggleVS(pk);
		this.userBtns:toggleSeeCard(isSelfkanpai);
	end
end

--{"body": {"chip": [2, 3300, 5], "time": 10.9458069801, "pid": [110967, 110967], "cards": [], "pk": 1, "cs": [[109793, 1, 1700, 0, 1], [110967, 2, 1600, 0, 1], [881742, 0, 0, 1, 0]], "rm": [19, 2]}, "tag": "run2", "type": "gold2"}
function this:ProcessRun2(messageObj)
	_late = true;
	local body = messageObj["body"];
	local  rm = body["rm"]; --最大倍数，当前倍数
	local  pid = body["pid"];--庄家id，用户id(当前操作玩家add)
	local  cs = body["cs"];--cs[0=uid,1=0暗牌 1明牌 2弃牌 3输 4赢end,2=当前下注钱数,3=是否在游戏0是在游戏1是不在游戏4=表示这次操作所用的时间]
	local  cards = body["cards"];--
	ju_time = tonumber(body["time"]) ;
	beishu = tonumber(rm[2]) ;
	if beishu == 0 then
		beishu = 1;
	end
	local multiple = tonumber(rm[2])  * unit_money;--当前倍数*unit_money
	local zhuang = GameObject.Find(_nnPlayerName..pid[1]);
	--2016.1.20 
	_bankerPlayer = zhuang;
	this:GetYSZPlayerCtrl(zhuang.name):SetBanker(true);--庄家
	local usermoney = tonumber(Userinto_money) - multiple;
	local t = 0.5;
	local ctrl = nil;
	for  i = 1, #(cs) do 
		local num = i;
		if  tostring(cs[num][1]) ~= EginUser.Instance.uid then
			ctrl =  this:GetYSZPlayerCtrl(_nnPlayerName..tostring(cs[num][1]));
			ctrl:SetBet(multiple, 0, usermoney);
			ctrl:SetShow(true, "xz");
			--log("44444444");
			ctrl:SetDeal(true, cards,tonumber(cs[num][2]));
		else
			this:GetYSZPlayerCtrl(_nnPlayerName..EginUser.Instance.uid):SetWait(true);
			this.userBtns:hideGroup();
		end
	end
	this:UpdateHUD(ju_time);
	--NNCount.Instance:UpdateHUD(ju_time);
	this.NNCount.transform.parent.gameObject:SetActive(false);
end

--{"body": {"pk": 1, "chip": [3000, 6, 6200, 4500, 5500], "pid": [[881745, 881745, 881744]], "ply": 0, "time": 15}, "tag": "vs", "type": "gold2"}
function this:ProcessVs(messageObj)

	local body = messageObj["body"];
	local pk = tonumber(body["pk"]);
	local  chip = body["chip"]; --chip[0]=加注的钱数,chip[1]=倍数  chip[2]=本牌桌总下注钱数  chip[3]=当前玩家已下注钱数chip[4]=当前玩家剩余钱数
	local  pid = body["pid"];--
	local ply =  tostring(body["ply"]);
	local timeC = tonumber(body["time"]) ;
	this:UpdateHUD(timeC);
	--NNCount.Instance:UpdateHUD(timeC);
	
	local chip0 = tonumber(chip[1]) ;
	local chip1 = tonumber(chip[2]) ;--倍数
	this.zongzhu.text =  tostring(chip[3]);
	
	local chip3 = tonumber(chip[4]);--当前玩家已下注
	local usermoney = tonumber(chip[5]);--当前玩家剩余的钱

	for   i=1,  #(pid) do 
		local bipaizhe =  tostring(pid[i][1]);--当前的人
		if chip0 > 0 then
			this:GetYSZPlayerCtrl(_nnPlayerName..bipaizhe):SetBet(chip0, 0, usermoney);
		end
	end

	for   i=1,  #(pid) do 
		local bipaizhe =  tostring(pid[i][1]);--当前的人
		local win =  tostring(pid[i][2]);--赢的人
		local lose =  tostring(pid[i][3]);--输的人
		
		local winplayer = GameObject.Find(_nnPlayerName..win);
		local loseplayer = GameObject.Find(_nnPlayerName..lose);
		 this:GetYSZPlayerCtrl(loseplayer.name).isVSLose = true;
		if this.userPlayerObj == loseplayer then
			this.vsAnima:setCompletedCallBack(this.userBtns.disableFollowBtn,this.userBtns);
		end
		this.vsAnima:pushToAnimaQueue(winplayer, loseplayer);
	end
	
	if ply == EginUser.Instance.uid then
		this.vsAnima:setCompletedCallBack( 
		function()
			if this.userPlayerCtrl.isVSLose then
				this.userBtns:disableFollowBtn();
			end
			this.userBtns:showGroup(chipMoney);
			this.userBtns:toggleSeeCard(isSelfkanpai);
			this.userBtns:toggleVS(pk);
			if SettingInfo.Instance.chipmin == true then
				this:autoFollowChip();
			end
		end,this);
	end
end
--/ user发比牌消息
function this:UserVs(go)
	local uid = "";
	this.selectPlayerBlack:SetActive(false);
	if go ~= nil then
		uid =  this:GetYSZPlayerCtrl(go.transform.parent.parent.gameObject.name).userID;
		for key, player in ipairs(currentRoundPlayer) do
			if not player:isSelf() then
				player:refVSstate(true);
			end
		end
	else
		for key, player in ipairs(currentRoundPlayer) do
			if not player:isSelf() then
				if not player.isGiveUp then
					uid = player.userID;
				end
			end
		end
	end
	isuservs = true;
	this.userBtns:hideGroup();
	

	local jsonStr = "{\"type\":\"gold2\", \"tag\":\"vs\", \"body\":".. uid .."}";
	this.mono:SendPackage(jsonStr);
	
	stepCount=stepCount+1;
	this.shouNum.text = tostring(stepCount);
	SoundMgr:talkVS(this.userPlayerCtrl:isFemale());
end
function this:UserSelectCharacter(btn)
	if not btn:GetComponent("UIEventListener").enabled then return; end
	--log("开始比牌");
	this:cancelAutoFollowChip();
	local onlyOnePlayer = nil;
	local activePlayerCount = 0;
	--log("在线人数");
	--log(#(currentRoundPlayer));
	for key, player in ipairs(currentRoundPlayer) do
		--log(player.gameObject.name);
		--log(player:isSelf());
		--log(player.isGiveUp);
		--log(player.isVSLose);
		if not player:isSelf()  and  not player.isGiveUp  and  not player.isVSLose then
			onlyOnePlayer = player;
			activePlayerCount=activePlayerCount+1;
			--log("增加一人");
		end
	end
	--log("人数");
	--log(activePlayerCount);
	if activePlayerCount == 1 then
		--log("只有一人");
		this:UserVs();
	else
		this.userBtns:hideGroup();
		this.selectPlayerBlack:SetActive(true);
		for key, player in ipairs(currentRoundPlayer) do
			if not player:isSelf() then
				--log("111111111111111111");
				player:refVSstate();		
			end
		end
	end
end
function this:ProcessQP(messageObj)
	isSelfQ = true;
	local body = messageObj["body"];
	local pk = tonumber(body["pk"]) ;
	local uid = tostring(body["uid"] );
	local ply =  tostring(body["ply"]);
	local droptime = tonumber(body["time"]) ;
	local userDoc =  this:GetYSZPlayerCtrl(_nnPlayerName..uid);
	local nextone=	this:GetYSZPlayerCtrl(_nnPlayerName..ply);
	userDoc.isGiveUp = true;
	userDoc:SetShow(true, "fq");
	if nextone then
		this:lightTo (  nextone:getlightPos());
	end
	if uid == EginUser.Instance.uid then
		this.userBtns:hideGroup();
		this.userBtns:disableFollowBtn();
		this.selectPlayerBlack:SetActive(false);
		for key, player in ipairs(currentRoundPlayer) do
			if not player:isSelf() then
				player:refVSstate(true);
			end
		end
	else
		SoundMgr:talkGiveup( userDoc:isFemale());
		userDoc:refVSstate();
	end
	userDoc: giveUpCardAnima();

	if ply ~= "0" then
		this:GetYSZPlayerCtrl(_nnPlayerName..ply):SetTime();
	end

	if ply == EginUser.Instance.uid then
		this:SetQipai(body, ply, pk);
	end
	this:UpdateHUD(droptime);
	--NNCount.Instance:UpdateHUD(droptime);
	userDoc:SetCancelTime();
end
function this:SetQipai(body,  ply,  pk)
	if body ~= nil then
		this:GetYSZPlayerCtrl(_nnPlayerName..ply):SetTime();
		if ply == EginUser.Instance.uid then
			this.userBtns:showGroup(chipMoney);
			this.userBtns:toggleSeeCard(isSelfkanpai);
			this.userBtns:toggleVS(pk);
			if SettingInfo.Instance.chipmin == true then
				this:autoFollowChip();
			end
		end
	end
end
function this:setupChooseChipObj()
	this.userBtns:initChip(chipMoney);
end
--body：[uid,money,cutt_chip_money,cutt_totle_money,next_one_id,nextchipflag]
function this:ProcessAdd(messageObj)
	local body = messageObj["body"];
	local pk = tonumber(body["pk"]) ;
	local  chip = body["chip"];
	local uid =  tostring(body["uid"]);
	local ply =  tostring(body["ply"]);
	local timeC = tonumber(body["time"]) ;
	local tempMultiples = 1;
	if chip[1]  ~= 0 then
		tempMultiples = tonumber(chip[1]) ;
	end
	local iskanpai = false;
	--add 2016.1.21
	if uid ~= EginUser.Instance.uid then
		local otherGuyDoc =  this:GetYSZPlayerCtrl(_nnPlayerName..uid);
		if tempMultiples*unit_money == multiple then
			SoundMgr:talkFollowJetton(otherGuyDoc:isFemale());
			otherGuyDoc:SetShow(true, "gz");
		else
			otherGuyDoc:SetShow(true, "jz");
			SoundMgr:talkAddJetton(otherGuyDoc:isFemale());
		end
		iskanpai = otherGuyDoc.isSeeCard;
		if chip[1]  == 0 then
			beishu = 1;
		else
			beishu = tonumber(chip[1]) ;
		end
	else
		iskanpai = isSelfkanpai;
	end

	if iskanpai == true then
		multiple = tempMultiples * unit_money * 2;
	else
		multiple = tempMultiples * unit_money;
	end
	local ctrl = nil;
	this.zongzhu.text =  tostring(chip[2]);--桌子上的钱
	local playermoney = tonumber(chip[3]) ;--刷新每个人的钱

	if body ~= nil then
		this:GetYSZPlayerCtrl(_nnPlayerName..ply): SetTime();
		this:lightTo(this:GetYSZPlayerCtrl(_nnPlayerName..ply):getlightPos());
		if ply == EginUser.Instance.uid then
			this:setupChipMoney(isSelfkanpai);
			this.userBtns:showGroup(chipMoney);
			this.userBtns:toggleSeeCard(isSelfkanpai);
			this.userBtns:toggleVS(pk);
			if SettingInfo.Instance.chipmin == true then
				this:autoFollowChip();
			end
		end
		
		ctrl = this:GetYSZPlayerCtrl(_nnPlayerName..uid);
		ctrl:SetBet(multiple, 0, playermoney);
		if uid ~= EginUser.Instance.uid then
			ctrl:SetCancelTime();
		end
		this:UpdateHUD(timeC);
		--NNCount.Instance:UpdateHUD(timeC);
	end
end
function this:setupChipMoney( userHasSeeCard)

	if userHasSeeCard == true then
		if beishu == 10 then
			chipMoney = {beishu * unit_money * 2};
		elseif beishu == 9 then
			chipMoney = {beishu * unit_money * 2, (beishu * unit_money  + (unit_money * 2))*2 };
		elseif beishu == 8 then
			chipMoney = {beishu * unit_money * 2, (beishu * unit_money  + (unit_money * 2))* 2, (beishu * unit_money+ (unit_money * 3))* 2  };
		else
			chipMoney = {beishu * unit_money * 2, (beishu * unit_money  + unit_money)*2, (beishu * unit_money + unit_money * 2)*2, (beishu * unit_money  + unit_money * 3)* 2 };
		end
	else
		if beishu == 10 then
			chipMoney = {beishu * unit_money};
		elseif beishu == 9 then
			chipMoney = {beishu * unit_money, beishu * unit_money + unit_money };
		elseif beishu == 8 then
			chipMoney = {beishu * unit_money, beishu * unit_money + unit_money, beishu * unit_money + (unit_money * 2) };
		else
			chipMoney = {beishu * unit_money, beishu * unit_money + unit_money, beishu * unit_money + (unit_money * 2), beishu * unit_money + (unit_money * 3) };
		end
	end
end
--自己下注
function this:UserChip( go )
	local chip = 0;
	if go ~= nil then
		if not go:GetComponent("UIEventListener").enabled then return; end
		chip = tonumber(go.name);
		this:cancelAutoFollowChip();
	end
	
	
	local startJson = {["type"]="gold2",tag="add",body=chip};   
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);
	
	stepCount=stepCount+1;
	this.shouNum.text = stepCount.."";
	if chip == 0 then
		SoundMgr:talkFollowJetton(this.userPlayerCtrl:isFemale());
		this.userPlayerCtrl:SetShow(true, "gz");
	else
		SoundMgr:talkAddJetton(this.userPlayerCtrl:isFemale());
		this.userPlayerCtrl:SetShow(true, "jz");
	end
	this.userBtns:hideGroup();
	this.userPlayerCtrl:SetCancelTime();
	this.userPlayerCtrl:SetReady(false);
end
--自己弃牌
function this:UserQipai(btn)
	if not btn:GetComponent("UIEventListener").enabled then return; end
	this:cancelAutoFollowChip();
	local startJson = {["type"]="gold2",tag="drop",body= EginUser.Instance.uid};   
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);
	
	this.userBtns:hideGroup();
	SoundMgr:talkGiveup(this.userPlayerCtrl:isFemale());
	SoundMgr:playEft(SoundMgr.clipAry1[11], 1);
	stepCount=stepCount+1;
	this.shouNum.text = stepCount.."";
end
--over--"body":"cs":[[126514,304,[nil],nil,0],[866627727,-320,[nil],nil,0]],"win":126514,"xj":[nil],"time":15end,"tag":"over","type":"gold2"end
function this:ProcessOver(messageObj)
	isgameover=true;
	--log("已经结束");
	this.alreadyOver=true;
	_isPlaying = false;
	_waitPlayerList={};
	_playingPlayerList={};
	this.paiType:SetActive(false);
	if _bankerPlayer ~= nil and not IsNil(_bankerPlayer)  then
		local tempCtrl = this:GetYSZPlayerCtrl(_bankerPlayer.name)
		if tempCtrl ~= nil then
			tempCtrl:SetBanker(false);
		end
		
		
	end
	
	local body = messageObj["body"];
	local  cs = body["cs"];
	local win =  tostring(body["win"]);
	local timeC = tonumber(body["time"]) ;
	local  card = nil;
	
	for  i = 1,  #(cs) do 
		local uid =  tostring(cs[i][1]);
		local  money = cs[i][2] ;
		card = cs[i][3];
		local cardtype = tonumber(cs[i][4]) ;
		local playerCtrl = this:GetYSZPlayerCtrl(_nnPlayerName..uid);
		playerCtrl.isWinner = false;
		if  #(card)  > 1 then
			--add by xiaoyong 2016.1.14
			playerCtrl:resetCardRotate(false);
			if uid ~= EginUser.Instance.uid then
				coroutine.start(playerCtrl.SetCardTypeOther,playerCtrl,card, cardtype,tonumber(money));
			else
				if money> 0 then
					SoundMgr:gameWin();
				else
					SoundMgr:gameLose();
				end
				coroutine.start( playerCtrl.showSelfCard,playerCtrl,card, cardtype, isSelfkanpai, true, tonumber(money));
			end
		end
		playerCtrl:winMoney(tonumber(money));
		--add  2016.1.18
		playerCtrl:showUpWinLoseMoney(money);
	end

	this.light.gameObject:SetActive(false);
	local winner = GameObject.Find(_nnPlayerName..win);
	if winner ~= nil then
		--log("胜利回收筹码");
		this:GetYSZPlayerCtrl(winner.name): playWinAnima();
		this:GetYSZPlayerCtrl(winner.name): jettonFlyTo(winner.transform.position);
	else
		this:jettonFlyCompleted();
	end
	this.userBtns:hideGroup();
	this.userBtns:disableFollowBtn();
	coroutine.wait(1);
	this:UpdateHUD(timeC);
	this.NNCount.transform.parent.gameObject:SetActive(true);
	--NNCount.Instance:UpdateHUD(timeC);
	coroutine.wait(2);
	--log("开始调用");
	coroutine.start(this.ChuLiXiaoXi,this);
	--[[
	if  #(delayLeaveList) > 0 then
		for key, leavePlayerObj in ipairs(delayLeaveList) do
			this:ProcessLeave(leavePlayerObj);
		end
		delayLeaveList ={};
	end
	]]
	--add 2016.1.23
	checkDelayDeskOver = false;
	if delayCallDeskOver ~= nil then
		coroutine.start( delayCallDeskOver.delayCallFunc,delayCallDeskOver.FuncClass,delayCallDeskOver.socketJsonObj );
	end
end
function this:ProcessAskbanker(messageObj)
end
function this:ProcessEnter(messageObj)
	this:Hidechangci();--隐藏场次
	--清除庄
	if _bankerPlayer ~= nil and not IsNil(_bankerPlayer) then
		local bankerCtrl = this:GetYSZPlayerCtrl(_bankerPlayer.name);
		if bankerCtrl ~= nil then
			bankerCtrl:SetBanker(false);
		end
	end

	SettingInfo.Instance.deposit = false;
	local body = messageObj["body"];
	local  memberinfos = body["memberinfos"];
	local deskInfo = body["deskinfo"];
	local info = GameObject.Find("FootInfo");

	init_money =  tostring(deskInfo["init_money"]);
	unit_money = tonumber(deskInfo["unit_money"]) ;--最小下注钱数
	this.dzhu.text = init_money;--底注
	this.fzhu.text =  tostring(deskInfo["top_money"]);
	this.userPlayerCtrl =  this:GetYSZPlayerCtrl(this.userPlayerObj.name,this.userPlayerObj);
	
	for key, memberinfo in ipairs(memberinfos) do
		if memberinfo ~= nil then
			_userIndex = tonumber(memberinfo["position"] );
			local waiting = toBoolean(memberinfo["waiting"]);
			this.bagmoney = tonumber(memberinfo["bag_money"] );
			Userinto_money =  tostring(memberinfo["into_money"]);
			
			local uid =  tostring(memberinfo["uid"]);
			if  #(memberinfos)  == 1 then
				_isPlaying = false;
			end
			if  tostring(memberinfo["uid"]) == EginUser.Instance.uid then
				--_userBagmoney.text =  tostring(this.bagmoney);
				_userBagmoney.text =  EginTools.HuanSuanMoney(this.bagmoney);	
				if waiting == false then
					 table.insert(_waitPlayerList,this.userPlayerObj);
				else
					 table.insert(_playingPlayerList,this.userPlayerObj);
					_reEnter = true;
				end
				
				this:ReplaceNameYSZPlayerCtrl(this.userPlayerObj.name,_nnPlayerName..EginUser.Instance.uid);
				this.userPlayerObj.name = _nnPlayerName..EginUser.Instance.uid;
				this.userPlayerCtrl.userNickname = info.transform:FindChild("Foot - Anchor"):FindChild("Info"):FindChild("Label_Nickname"):GetComponent("UILabel");
				this.userPlayerCtrl.userIntomoney = info.transform:FindChild("Foot - Anchor"):FindChild("Info"):FindChild("Money"):FindChild("Label_Bagmoney"):GetComponent("UILabel");
				this.userPlayerCtrl.countDown = info.transform:FindChild("Foot - Anchor"):FindChild("Info"):FindChild("daojishi"):GetComponent("UISprite").gameObject;
				break;
			end
		end
	end
	--其他人
	for key, memberinfo in ipairs(memberinfos) do
		if memberinfo ~= nil then
			if  tostring(memberinfo["uid"]) ~= EginUser.Instance.uid then
				this:AddPlayer(memberinfo, _userIndex);
			end
		end
	end
	local t = tonumber(deskInfo["continue_timeout"]) ;
	this:UpdateHUD(t);
	--NNCount.Instance:UpdateHUD(t);
end


function this:AddPlayer(memberinfo, _userIndex)
	local uid =  tostring(memberinfo["uid"]);
	local bag_money =  tostring(memberinfo["bag_money"]);
	local nickname = tostring(memberinfo["nickname"]);
	local avatar_no = tonumber(memberinfo["avatar_no"] );
	local position = tonumber(memberinfo["position"] );
	local ready = toBoolean(memberinfo["ready"]);
	local waiting = toBoolean(memberinfo["waiting"]);
	local level =  tostring(memberinfo["level"]);

	local position_span = position - _userIndex;
	local player = nil;
	if position_span == 1  or  position_span == -4 then
		player = NGUITools.AddChild(this.gameObject, this.yszPlayerPrefabs[1]);
	elseif position_span == 2  or  position_span == -3 then
		player = NGUITools.AddChild(this.gameObject, this.yszPlayerPrefabs[2]);
	elseif position_span == 3  or  position_span == -2 then
		player = NGUITools.AddChild(this.gameObject, this.yszPlayerPrefabs[3]);
	elseif position_span == 4  or  position_span == -1 then
		player = NGUITools.AddChild(this.gameObject, this.yszPlayerPrefabs[4]);
	end

	player.name = _nnPlayerName..uid;
	this:SetAnchorPosition(player, _userIndex, position);
	local ctrl = this:GetYSZPlayerCtrl( player.name,player);
	ctrl:SetPlayerInfo(avatar_no, nickname, bag_money, level, uid);
	 table.insert(_playingPlayerList,player);--游戏
	return player;
end
function this:SetAnchorPosition( player,  _userIndex,  playerIndex)
	local position_span = playerIndex - _userIndex;
	local anchor = player:GetComponent("UIAnchor");
	if position_span == 0 then
		anchor.side = UIAnchor.Side.Bottom;
	elseif position_span == 2  or  position_span == -3 then
		anchor.side = UIAnchor.Side.Top;
		anchor.relativeOffset.x = 0.29;
		anchor.relativeOffset.y = -0.12;
	elseif position_span == 1  or  position_span == -4 then
		anchor.side = UIAnchor.Side.Top;
		anchor.relativeOffset.x = 0;
		anchor.relativeOffset.y = -0.08;
	elseif position_span == 3  or  position_span == -2 then
		anchor.side = UIAnchor.Side.Bottom;
		anchor.relativeOffset.x = 0.29;
		anchor.relativeOffset.y = 0.12;
	elseif position_span == 4  or  position_span == -1 then
		anchor.side = UIAnchor.Side.Bottom;
		anchor.relativeOffset.x = 0;
		anchor.relativeOffset.y = 0.08;
	end
end
function this:ProcessReady(messageObj)
	local uid =  tostring(messageObj["body"]);
	local player = GameObject.Find(_nnPlayerName..uid);
	local ctrl = this:GetYSZPlayerCtrl( player.name);
	--去掉牌型显示
	if uid == EginUser.Instance.uid then
		ctrl:SetDeal(false);
		ctrl:clearPais();
		ctrl:SetScore(-1);
	else
		--log("玩家准备");
		ctrl:SetWait(false);
		--log(this.alreadyOver);
		if this.alreadyOver then
			--log("55555555555");
			ctrl:SetDeal(false);
			ctrl:clearPais();
			ctrl:SetScore(-1);
		end
	end
	--显示准备
	if not  tableContains(_playingPlayerList ,player) then
		 table.insert(_playingPlayerList,player);
	end
end
function this:UserReady()
	--避免了已经点击过开始按钮但是还是有倒计时声音
	--NNCount.Instance:DestroyHUD();
	--新的一句开始时去掉庄家标志
	if _bankerPlayer ~= nil and not IsNil(_bankerPlayer) then
		 this:GetYSZPlayerCtrl(_bankerPlayer.name): SetBanker(false);
	end
	--向服务器发送消息（开始游戏）
	local startJson = {["type"]="game",tag="start",body= EginUser.Instance.uid};   
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);

	local startJson2 = {["type"]="game",tag="continue",body= EginUser.Instance.uid};   
	local jsonStr2 = cjson.encode(startJson2);
	this.mono:SendPackage(jsonStr2);

	this.btnBegin:SetActive(false);
	this:GetYSZPlayerCtrl(_nnPlayerName..EginUser.Instance.uid): SetReady(true);
end
function this:ProcessDeskOver(messageObj)
	local overtime = tonumber(messageObj["body"]) ;
	overtime = overtime -1;
	coroutine.wait(1.0);
	this:UpdateHUD(overtime);
	--NNCount.Instance:UpdateHUD(overtime);
	if not _late then
		this.btnBegin:SetActive(true);
		this.userPlayerCtrl.resultAnima.gameObject:SetActive(false);
	end
	_late = false;
end
function this:ProcessUpdateAllIntomoney(messageObj)
	local jsonStr = cjson.encode(messageObj);
	local a11=string.find(jsonStr,EginUser.Instance.uid);
	if not a11 then return nil; end

	local  infos = messageObj["body"];
	for key, info in ipairs(infos) do
		local uid =  tostring(info[1]);
		local intoMoney =  tostring(info[2]);
		local player = GameObject.Find(_nnPlayerName..uid);
		if player ~= nil then
			 this:GetYSZPlayerCtrl(player.name):UpdateIntoMoney(intoMoney);
		end
	end
end
function this.ProcessUpdateIntomoney(messageObj) 
	--可省略,数据有可能为空
	--[[
	local intoMoney =  tostring(messageObj["body"]);
	
	local info = GameObject.Find("FootInfo");
	if nil ~= info then
		FootInfo:UpdateIntomoney(intoMoney);
	end
	]]
end
function this:ProcessCome(messageObj)
	local body = messageObj["body"];
	local memberinfo = body["memberinfo"];
	local uid =  tostring(memberinfo["uid"]);
	local waiting = toBoolean(memberinfo["waiting"]);
	if _isPlaying == true then
		local playeruid = GameObject.Find(_nnPlayerName..uid);
		if playeruid==nil and  not  tableContains(_playingPlayerList,playeruid) then
			local player = this:AddPlayer(memberinfo, _userIndex);
			 this:GetYSZPlayerCtrl(player.name): SetWait(true);
			this:GetYSZPlayerCtrl(player.name): SetReady(false);
			 table.insert(_waitPlayerList,player);
		end
	else
		local player = this:AddPlayer(memberinfo, _userIndex);
		 table.insert(_playingPlayerList,player);
	end
end
-- 退出
function this:UserQuit()
	SocketConnectInfo.Instance.roomFixseat = true;
	local startJson = {["type"]="game",tag="quit"};   
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);
	log("UserQuit=======================1");
	this.mono:OnClickBack();
end
--点换桌
function this:UserChangedesk()
	local UserPlayer = GameObject.Find(_nnPlayerName..EginUser.Instance.uid);
	if  tableContains(_playingPlayerList,this.UserPlayer) then
		local errMsg = YSZResourceXML.Instance.Str("mx_bet_err_13");
		if errMsg ~= nil then
			this.mxErrorToast:Show(1.2, errMsg);
		end
	end
	local errMsg1 = YSZResourceXML.Instance.Str("mx_bet_err_13");
	if errMsg1 ~= nil then
		this.mxErrorToast:Show(1.2, errMsg1);
	end
	local startJson = {["type"]="game",tag="changedesk",body = EginUser.Instance.uid};   
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);

	this.btnBegin:SetActive(false);
end
function this:UserButton( target)
	--帮助
	if target == this.MenuBtn.gameObject then
		NGUITools.SetActive(this.Menu.gameObject, true);
	elseif target == this.helpBtn.gameObject then
		NGUITools.SetActive(this.help.gameObject, true);
	elseif target == this.settingBtn.gameObject then
		NGUITools.SetActive(this.setting.gameObject, true);
	--elseif target == this.helpBtnClose.gameObject then
		--NGUITools.SetActive(this.help, false);
	--elseif target == this.settingBtnClose.gameObject then
		--NGUITools.SetActive(this.setting, false);
	elseif target == this.weituoClose.gameObject then
		NGUITools.SetActive(this.weituobg, false);
	elseif target == this.weituo then
		--委托
		if this.weituobg.activeSelf == true  then
			NGUITools.SetActive(this.weituobg, false);
		else
			NGUITools.SetActive(this.weituobg, true);
		end
	end
end

function this:OnButtonClick(target)
	if target==this.btnXiala then	
		--log("点击下拉按钮");
		if this.btnXiala_bg.spriteName=="button_up" then
			--log("隐藏");
			this.btnXiala.transform:FindChild("panel").gameObject:SetActive(false);
			this.btnXiala_bg.spriteName="button_down";	
			this.btnXiala:GetComponent("UIButton").normalSprite="button_down";
		else
			--log("显示");
			this.btnXiala_bg.spriteName="button_up";
			this.btnXiala.transform:FindChild("panel").gameObject:SetActive(true);
			this.btnXiala:GetComponent("UIButton").normalSprite="button_up";
		end	
	elseif target==this.settingBtn or target==this.helpBtn or target==this.btn_emotion or target==this.btn_shelet then
		this.btnXiala_bg.spriteName="button_down";
		this.btnXiala:GetComponent("UIButton").normalSprite="button_down";
	end
end
--/ send看牌
function this:UserShowpai(btn)
	if not btn:GetComponent("UIEventListener").enabled then return; end
	this:cancelAutoFollowChip();
	local startJson = {["type"]="gold2",tag="show",body =EginUser.Instance.uid };   
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);

	isSelfkanpai = true;
	this.userBtns:toggleSeeCard(isSelfkanpai);
	stepCount=stepCount+1;
	this.shouNum.text = tostring(stepCount);
end
--/ receive 看牌
function this:ProcessShow(messageObj)
	local body = messageObj["body"];
	local  cards = body["cards"];
	local uid =  tostring(body["uid"]);
	local card_type = tonumber(body["card_type"]) ;
	local player = GameObject.Find(_nnPlayerName..uid);

	if uid == EginUser.Instance.uid then
		this:setupChipMoney(isSelfkanpai);
		this.userBtns:initChip(chipMoney);
		coroutine.start(this:GetYSZPlayerCtrl(player.name).showSelfCard,this:GetYSZPlayerCtrl(player.name),cards, card_type, false, false);
		--显示牌型和牛几
		 this:GetYSZPlayerCtrl(player.name): SetShow(true, "kp");
		--[[
		this.paiType:SetActive(true);
		local paitype = this.paiType.transform:GetComponentInChildren(Type.GetType("UISprite",true));
		--显示牌型和牛几
		 this:GetYSZPlayerCtrl(player.name): SetShow(true, "kp");
		if card_type == 0 then
			paitype.spriteName = "n_0";
		elseif card_type == 10 then
			paitype.spriteName = "n_".. card_type;
		elseif card_type > 0  and  card_type <= 9 then
			paitype.spriteName = "n_".. card_type;
		end
		]]
	else
		 this:GetYSZPlayerCtrl(player.name): SetShow(true, "kp");
		 this:GetYSZPlayerCtrl(player.name): otherUserSeeCardAnima();
	end
	SoundMgr:talkSeeCard( this:GetYSZPlayerCtrl(player.name):isFemale());
end
----某人离开牌桌(发生于断线或换桌后)
function this:ProcessLeave(messageObj)
	local uid =  tostring(messageObj["body"]);
	if not (uid == EginUser.Instance.uid) then
		local player = GameObject.Find(_nnPlayerName..uid);
		if not this.vsAnima.isPlaying then
			
			this:RemoveYSZPlayerCtrl(player.name);
			if  tableContains(_playingPlayerList,player) then
				tableRemove(_playingPlayerList,player);
			end
			if  tableContains(_waitPlayerList,player) then
				tableRemove(_waitPlayerList,player);
			end
			destroy(player);
		else
			 table.insert(delayLeaveList,tableCopy(messageObj));
		end
	end
end
function this:Processactfinish(messageObj)
end
function this:UserLeave()
	local startJson = {["type"]="game",tag="leave",body=EginUser.Instance.uid};   
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);	
end
--[[ ------ Button Click ------ ]]--
function this:OnClickBack()
	if _isPlaying then
		this.msgQuit:SetActive(true);
	else
		this:UserQuit();
	end
end
--/ 机器人
function this:ProcessStaff(messageObj)
end
function this:ProcessUpdate_intomoney(messageObj)
	local jsonStr = cjson.encode(messageObj);
	local a11=string.find(jsonStr,EginUser.Instance.uid);
	if not a11 then return nil; end
	
	local  infos = messageObj["body"];
	for key, info in ipairs(infos) do
		local uid =  tostring(info[1]);
		local intoMoney =  tostring(info[2]);
		local player = GameObject.Find(_nnPlayerName..uid);
		if player ~= nil then
			this:GetYSZPlayerCtrl(player.name): UpdateIntoMoney(intoMoney);
		end
	end
end
function this:ProcessDJ(messageObj)

end
function this:ProcessNotcontinue(messageObj)
	this.msgNotContinue:SetActive(true);
	coroutine.wait(3);
	this:UserQuit();
end
function this:ShowPromptHUD(errorInfo)
	this.btnBegin:SetActive(false);
	this.msgAccountFailed:SetActive(true);
	this.msgAccountFailed:GetComponentInChildren(Type.GetType("UILabel",true)).text = errorInfo;
end

function this:CloseView()
	NGUITools.SetActive(this.Menu.gameObject, false);
	NGUITools.SetActive(this.help.gameObject, false);
	NGUITools.SetActive(this.setting.gameObject, false);
end
--一直跟注
function this:SetChipmin()
	local strTemp = this.yizhigen:GetComponentInChildren(Type.GetType("UISprite",true)).spriteName;
	if strTemp == "yougou" then
		this.yizhigen:GetComponentInChildren(Type.GetType("UISprite",true)).spriteName = "wugou";
		SettingInfo.Instance.chipmin = false;
	elseif strTemp =="wugou" then
		this.yizhigen:GetComponentInChildren(Type.GetType("UISprite",true)).spriteName = "yougou";
		SettingInfo.Instance.chipmin = true;
	end
end
function this:autoVSHandle()
	if this.zidongbipai:GetComponentInChildren(Type.GetType("UISprite",true)).spriteName == "wugou" then
		this.zidongbipai:GetComponent("UISprite").spriteName = "yougou";
		SettingInfo.Instance.YSZ_autoVS = true;
	else
		this.zidongbipai:GetComponent("UISprite").spriteName = "wugou";
		SettingInfo.Instance.YSZ_autoVS = false;
	end
end
function this:lightTo( vc3)
	this.light.gameObject:SetActive(true);
	local originVc3 = this.light.transform.position;
	local angle = math.atan2(originVc3.y -vc3.y ,  originVc3.x - vc3.x);
	this.light.transform.eulerAngles = Vector3.New(0,0, angle*180/math.pi-90);
end
function this:autoFollowChip()
	this.InvokeLua:Invoke("autoFollowInvoke",this.autoFollowInvoke,1.0);
end
function this:cancelAutoFollowChip()
	this.InvokeLua:CancelInvoke("autoFollowInvoke");
end
function this:autoFollowInvoke()
	this:UserChip();
end
function this:autoUserVs()
	coroutine.wait(1.0);
	--this:UserVs();
end


DelayCallMsg =  LuaObject:New();
function DelayCallMsg:New(jsonObj,delayFunc,class)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
        setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.socketJsonObj = jsonObj;
	o.delayCallFunc = delayFunc;
	o.FuncClass = class;
	return o;    --返回自身
end


function this:UpdateTime()
    while true do
		this:TimeUpdate()
		coroutine.wait(0.1);
	end
end 
local chazhiTime = 0;
function this:TimeUpdate()
	if this.isStart then
		this._num = this._num -0.1
		if this._num > 0 then 
			chazhiTime =  math.floor(this._num)
			this.NNCountNum.text = chazhiTime<10 and "0"..chazhiTime or tostring(chazhiTime); 
				
			if this._num <= 5   then
				this.NNCount:Play("time_anima");
				if this._currTime == 1 then
					EginTools.PlayEffect(this.soundCount);	 
				end
				this._currTime = this._currTime -0.1
				if this._currTime < 0 then
					this._currTime = 1;
				end
				--this.NNCountNum.alpha=1;
				--this.NNCountBg.alpha=1;
			else
				this.NNCount:Play("time_anima_default");
				--this.NNCountNum.alpha=0;
				--this.NNCountBg.alpha=0;
			end 
			
			 --this.NNCount.fillAmount = (this._num)/self._numMax;
		else
			this.isStart = false;
		end
	
	end
end

function this:UpdateHUD( _time)
	_time = _time-1;
	--self._currTime = Time.time;
	this._currTime = 1;
	this._num =  math.floor(_time); 
	this._numMax = this._num; 
	this.isStart = true;
	
	this.NNCount.gameObject:SetActive(true)
	
	 --this.NNCount.fillAmount = 1;
	 
	local timerStr = this._num<10 and "0"..this._num or tostring(this._num);
	this.NNCountNum.text = timerStr;  
end

function this:jettonFlyCompleted( )
	--log("赢家消失，毁掉筹码");
	for key,value in this.jettonObjList do
		tableRemove(this.jettonObjList,value);
		destroy( value );
	end
end