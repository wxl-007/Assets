require "GameDHSZ/DHSZPlayerCtrl"
 
local cjson = require "cjson"

local this = LuaObject:New()
GameDHSZ = this
local _nnPlayerName = "DHSZPlayer_"		--动态生成的玩家实例名字的前缀	
local _userIndex = 0					--玩家的位置
local _isPlaying = false	
local isgameover=false;		
local _late = false
local _reEnter = false
local keynum = 0;
local jiangeTime=10;
local languagefirstTime=0;
local languageEndTime = -10;
local language_index = -1;
local zhongtuEnter=false;

function this:clearLuaValue()
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	this.tbwzPlayerPrefab = nil		--GameObject同桌其他玩家的预设
	this.UserPlayerCtrl =nil			--TBWZPlayerCtrl游戏玩家的控制脚本
	this.userPlayerObj = nil			--GameObject

	this.btnGeShu=nil;
	this.btnDianShu=nil;
	this.btnJiaoDian=nil;
	this.SelectZhai=nil;
	this.panel_geshu=nil;
	this.panel_dianshu=nil;
	this.List_geshu=nil;
	this.List_dianshu=nil;
	this.geshuGrid=nil;
	this.own_geshu=nil;
	this.own_dianshu=nil;
	this.playerInfoPanel=nil;
	this.info_Uid=0;
	this.canOpenFirst=true;--是否第一次开骰
	
	this.btnBegin = nil				--GameObject
	--this.btnShow = nil				--GameObject
	this.jingcaiList=nil;--被竞猜人列表
	this.AllJingCaiList=nil;--竞猜人的列表
	this.alreadyJingCai=false;
	
	--this.msgWaitNext =	nil	--GameObject
	this.msgQuit = nil				--GameObject
	this.msgAccountFailed = nil		--GameObject
	this.msgNotContinue =nil			--GameObject
	this.msgError=nil;
	--音效
	this.soundCount = nil;
	this.but=nil;

	
	this._playingPlayerList = nil			--List<GameObject>游戏开始时正在游戏的玩家
	this._waitPlayerList = nil				--List<GameObject>游戏开始时等待的玩家
	this._readyPlayerList = nil			--List<GameObject>正常进入游戏时已经准备的玩家(wait=true ready=true)，需要在游戏开始时加入_playingPlayerList，并清空
	this.List_Desk_Uid=nil;
	
	self.isStart = false;
	this._currTime = 0;
	this._num = 20;
	this._numMax = 0;
	this.jiaodian_id=-1;
	this.isZhai=0;
	this.geshu=0;
	this.dianshu=0;
	this.jiaodian_geshu=0;
	this.jiaodian_dianshu=0;
	this.dangqiangeshu=0;
	this.canSelectZhai=false;
	this.zonggeshu=0;
	this.duijukaishi=nil;
	this.nextFollowMe=nil;
	this.nextoneId=-1;
	this.jingcaiPanel=nil;	
	this.jingcaiZhong=nil;
	this.btn_open=nil;
	this.btn_open_kai=nil;
	this.btn_open_qiangkai=nil;
	
	this.liwu_1 = nil;
	this.liwu_2 = nil;
	this.liwu_3 = nil;
	this.liwu_4 = nil;
	this.liwu_5 = nil;
	this.liwu_6 = nil;
	this.Sprite_Bet=nil;
	this.zancheng=nil;
	
	this.m_geshu = {};
	this.w_geshu = {};
	this.m_dianshu = {};
	this.w_dianshu = {};
	
	this.zhuangjia=0;
	this.xianjia=0;

	this.music=nil;
	this.bg_music_1=nil;
	this.bg_music_2=nil;

	this.playmusicPanel=nil;
	this.playmusicPanel_1=nil;
	
	zhongtuEnter=false;

	this._tbwzPlayerCtrl = nil
	this:RemoveAllTbwzPlayerCtrl();
	
	this.lateMessage=nil;
	coroutine.Stop()
	LuaGC();
end
function this:Init()
	--初始化变量
	_userIndex = 0		
	_isPlaying = false		
	isgameover=false;	
	_late = false
	_reEnter = false
	
	--GameObject同桌其他玩家 
	this.tbwzPlayerPrefab = {}
	for i = 1 ,5 do
		this.tbwzPlayerPrefab[i] = this.transform:FindChild("Content/DHSZPlayer_"..i).gameObject
	end 
	--log(#(this.tbwzPlayerPrefab).."===其他玩家个数");
	for i=1,#(this.tbwzPlayerPrefab) do
		--log(this.tbwzPlayerPrefab[i].name);
	end
	
	this.UserPlayerCtrl =0			--TBWZPlayerCtrl游戏玩家的控制脚本
	this.userPlayerObj = this.transform:FindChild("Content/User").gameObject			--GameObject
	local buttonPanel=this.userPlayerObj.transform:FindChild("buttonPanel");
	this.btnGeShu=buttonPanel:FindChild("Button_geshu").gameObject;--个数按钮
	this.btnDianShu=buttonPanel:FindChild("Button_dianshu").gameObject;--点数按钮
	this.btnJiaoDian=buttonPanel:FindChild("Button_jiaodian").gameObject;--叫点按钮
	this.btnJiaoDianSprite=this.btnJiaoDian.transform:FindChild("Background"):GetComponent("UISprite");
	this.SelectZhai=buttonPanel:FindChild("Button_danxuan").gameObject;--选斋按钮
	this.languagePanel=buttonPanel:FindChild("language_panel").gameObject
	this.language_Grid=buttonPanel:FindChild("language_panel/changyongyu/UIGrid").gameObject;--语音父物体
	this.open_help=this.userPlayerObj.transform:FindChild("Open_tishi").gameObject; --开骰位置提示
	this.Already_Zhai=this.userPlayerObj.transform:FindChild("Already_Zhai").gameObject;--已经叫斋提示
	
	this.label_Zhai=this.SelectZhai.transform:FindChild("zhai").gameObject:GetComponent("UISprite"); --图片斋字
	this.zhai_Sprite=this.SelectZhai.transform:FindChild("select").gameObject
	this.btn_open=this.userPlayerObj.transform:FindChild("Button_open").gameObject;--开骰按钮
	this.btn_open_kai=this.userPlayerObj.transform:FindChild("Button_open/kai").gameObject;
	this.btn_open_qiangkai=this.userPlayerObj.transform:FindChild("Button_open/qingkai").gameObject;
	
	this.playerInfoPanel=this.transform:FindChild("Content/PanelInfo").gameObject;--个人信息父物体
	local infoPanel=this.playerInfoPanel.transform:FindChild("message");
	this.info_avatar=infoPanel.transform:FindChild("avatar"):GetComponent("UISprite");--个人信息头像
	this.info_nickname=infoPanel.transform:FindChild("nickname_1"):GetComponent("UILabel");--个人信息昵称
	this.info_money=infoPanel.transform:FindChild("money_1"):GetComponent("UILabel");--个人信息金钱
	this.info_Uid=0;
	this.gift_Panel=this.transform:FindChild("Content/gift_Panel");--实例化礼物的父物体
	
	this.btnBegin=this.transform:FindChild("Content/caozuoPanel/Button_begin").gameObject;--开始按钮
	
	
	this.jiaodian_message=this.transform:FindChild("Content/caozuoPanel/Message").gameObject;--中间显示的所有人当前的叫点总个数
	this.message_dianshu=this.jiaodian_message.transform:FindChild("bg/Sprite"):GetComponent("UISprite");
	this.message_geshu=this.jiaodian_message.transform:FindChild("bg/label"):GetComponent("UILabel");
	this.jiaodian_message_all=this.transform:FindChild("Content/caozuoPanel/Message_all").gameObject;--结算时显示实际的叫点个数
	this.message_all_dianshu=this.jiaodian_message_all.transform:FindChild("bg/Sprite"):GetComponent("UISprite");
	this.message_all_geshu=this.jiaodian_message_all.transform:FindChild("bg/label"):GetComponent("UILabel");
	
	this.duijukaishi=this.transform:FindChild("Content/caozuoPanel/duijukaishi").gameObject;--对局开始
	this.nextFollowMe=this.transform:FindChild("Content/caozuoPanel/nextFollowMeBg").gameObject;--轮到你了
	this.duijukaishi_1=this.transform:FindChild("Content/caozuoPanel/duijukaishi_1").gameObject;--对局开始
	
	this.dizhu_label=buttonPanel.transform:FindChild("dizhu_panel/label_1"):GetComponent("UILabel");
	this.jingcaiPanel=buttonPanel:FindChild("panel_jingcai").gameObject;--竞猜父物体
	this.jingcaiTime=this.jingcaiPanel.transform:FindChild("jingcai_label_daojishi"):GetComponent("UILabel");--竞猜倒计时
	this.btnSelectGou=this.jingcaiPanel.transform:FindChild("select_2").gameObject;--够
	this.btnSelectBuGou=this.jingcaiPanel.transform:FindChild("select_1").gameObject;--不够
	this.jingcaiZhong=buttonPanel:FindChild("panel_jingcaizhong").gameObject;--竞猜中物体
	this.panel_geshu=buttonPanel:FindChild("panel_geshu").gameObject;--个数父物体
	this.ScrollView=this.panel_geshu.transform:FindChild("panel_geshu").gameObject:GetComponent("UIScrollView");--滑动组件
	this.panel_dianshu=buttonPanel:FindChild("panel_dianshu").gameObject;--点数父物体
	this.geshuGrid=this.panel_geshu.transform:FindChild("panel_geshu/UIGrid").gameObject;
	this.List_geshu={};
	for i=2,36 do
		table.insert(this.List_geshu,this.geshuGrid.transform:FindChild("select_"..i).gameObject);
	end
	
	this.List_dianshu={};
	for i=1,6 do
		table.insert(this.List_dianshu,this.panel_dianshu.transform:FindChild("select_"..i).gameObject);
	end
	
	this.own_geshu=this.btnGeShu.transform:FindChild("geshu"):GetComponent("UISprite");
	this.own_dianshu=this.btnDianShu.transform:FindChild("dianshu"):GetComponent("UISprite");
	
	
	--log(#(this.List_geshu).."========列表个数");
	--for i=1,#(this.List_geshu) do
		--log(this.List_geshu[i].name);
	--end
	
	--初始化NNCountLua 
	--this.NNCount = this.transform:FindChild("Content/NNCount").gameObject:GetComponent("UISprite")	
	--this.NNCountNum = this.transform:FindChild("Content/NNCount/NNCountNum").gameObject:GetComponent("UILabel")	
	--this.btnBegin = this.transform:FindChild("Content/User/Button_begin").gameObject				--GameObject
	--this.btnShow = this.transform:FindChild("Content/User/Button_show").gameObject				--GameObject
	
	
	--this.msgWaitNext =	this.transform:FindChild("Content/User/MsgWaitNext").gameObject;	--GameObject
	this.msgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject				--GameObject
	this.msgAccountFailed = this.transform:FindChild("Content/MsgContainer/MsgAccountFailed").gameObject		--GameObject
	this.msgNotContinue = this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject			--GameObject
	this.msgError=this.transform:FindChild("Content/MsgContainer/MsgError").gameObject	--叫点错误提示
	--音效
	this.soundCount = ResManager:LoadAsset("gamenn/Sound","djs1") 
	this.but = ResManager:LoadAsset("gamedhsz/sound","back") 
	
	self.isStart = false;
	this._currTime = 0;
	this._num = 20;
	this.jiaodian_id=-1;--当前叫点的玩家的位置id
	this.isZhai=0;
	this.geshu=0;
	this.dianshu=0;
	this.jiaodian_geshu=0;
	this.jiaodian_dianshu=0;
	this.dangqiangeshu=0;
	this.canSelectZhai=false;
	this.zonggeshu=0;
	this.nextoneId=-1;
	this.canOpenFirst=true;
	this.jingcaiList={};
	this.AllJingCaiList={};
	this.alreadyJingCai=false;
	
	this.zhuangjia=0;
	this.xianjia=0;
	this.lateMessage={};
	
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
	
	this.liwu_1 = ResManager:LoadAsset("gamedhsz/liwu","liwu_1");
	this.liwu_2 = ResManager:LoadAsset("gamedhsz/liwu","liwu_2");
	this.liwu_3 = ResManager:LoadAsset("gamedhsz/liwu","liwu_3");
	this.liwu_4 = ResManager:LoadAsset("gamedhsz/liwu","liwu_4");
	this.liwu_5 = ResManager:LoadAsset("gamedhsz/liwu","liwu_5");
	this.liwu_6 = ResManager:LoadAsset("gamedhsz/liwu","liwu_6");
	this.Sprite_Bet=ResManager:LoadAsset("gamedhsz/liwu","Sprite_Bet");
	this.zancheng=ResManager:LoadAsset("gamedhsz/liwu","zancheng");
	
	--this.playmusicPanel=this.transform:FindChild("Content/playmusic").gameObject:GetComponent("Animator");
	this.playmusicPanel=this.transform:FindChild("Content/playmusic").gameObject;
	this.playmusic_1=this.playmusicPanel.transform:FindChild("playmusic_1").gameObject:GetComponent("AudioSource");
	this.playmusic_2=this.playmusicPanel.transform:FindChild("playmusic_2").gameObject:GetComponent("AudioSource");

	this.playmusicPanel_1=this.transform:FindChild("Content/playmusic_1").gameObject;
	this.playmusic_11=this.playmusicPanel_1.transform:FindChild("playmusic_1").gameObject:GetComponent("AudioSource");
	this.playmusic_22=this.playmusicPanel_1.transform:FindChild("playmusic_2").gameObject:GetComponent("AudioSource");


	this.m_geshu = {};
	for i = 2,36 do 
		table.insert(this.m_geshu,ResManager:LoadAsset("gamedhsz/sound","m_g_"..i));
	end
	--log("geshu======="..#(this.m_geshu));
	--for i=1,#(this.m_geshu) do
		--log(this.m_geshu[i].name);
	--end
	this.w_geshu = {};
	for i = 2,36 do 
		table.insert(this.w_geshu,ResManager:LoadAsset("gamedhsz/sound","w_g_"..i));
	end
	this.m_dianshu = {};
	for i = 1,6 do 
		table.insert(this.m_dianshu,ResManager:LoadAsset("gamedhsz/sound","m_d_"..i));
	end
	this.w_dianshu = {};
	for i = 1,6 do 
		table.insert(this.w_dianshu,ResManager:LoadAsset("gamedhsz/sound","w_d_"..i));
	end
	
	this._playingPlayerList = {}			--List<GameObject>游戏开始时正在游戏的玩家
	this._waitPlayerList = {}				--List<GameObject>游戏开始时等待的玩家
	this._readyPlayerList = {}				--List<GameObject>正常进入游戏时已经准备的玩家(wait=true ready=true)，需要在游戏开始时加入_playingPlayerList，并清空
	this._tbwzPlayerCtrl = {}				--存放Lua对象
	
	this.List_Desk_Uid={};			--玩家游戏中对应position的玩家id   

	
	
	
	this.sliderBgVolume = this.transform:FindChild("Content/MsgContainer/Sprite_popup_container/Label_setting/Label_bgmusic/Button_special").gameObject;
	this.sliderBgVolumeSprite=this.sliderBgVolume.transform:FindChild("Background").gameObject:GetComponent("UISprite");
	this.sliderEffectVolume = this.transform:FindChild("Content/MsgContainer/Sprite_popup_container/Label_setting/Label_bgsound/Button_special").gameObject;
	this.sliderEffectVolumeSprite=this.sliderEffectVolume.transform:FindChild("Background").gameObject:GetComponent("UISprite");
	
	this.bg_music_1=ResManager:LoadAsset("gamedhsz/sound","BGM1");
	this.bg_music_2=ResManager:LoadAsset("gamedhsz/sound","BGM2");
	zhongtuEnter=false;
end
function this:Awake()
	log("------------------awake of GameTBWZ-------------")
	
	this:Init();
	
	----------绑定按钮事件--------
	--退出按钮
	local btn_back = this.transform:FindChild("Button_Panel/Button_back").gameObject
	this.mono:AddClick(btn_back, this.OnClickBack);
	--开始按钮
	--this.mono:AddClick(this.btnBegin, this.UserReady);
	--摊牌按钮
	--this.mono:AddClick(this.btnShow, this.UserShow);
	--确认退出按钮
	local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
	this.mono:AddClick(btn_MsgQuit, this.UserQuit);
	
	this.mono:AddClick(this.btnGeShu,this.OnButtonClick,this);
	this.mono:AddClick(this.btnDianShu,this.OnButtonClick,this);
	for i=1,#(this.List_geshu) do
		this.mono:AddClick(this.List_geshu[i].gameObject,this.OnButtonClick,this);
	end
	for i=1,#(this.List_dianshu) do
		this.mono:AddClick(this.List_dianshu[i].gameObject,this.OnButtonClick,this);
	end
	
	this.mono:AddClick(this.SelectZhai,this.OnButtonClick,this);
	this.mono:AddClick(this.btnJiaoDian,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_open,this.OnButtonClick,this);
	this.mono:AddClick(this.btnSelectGou,this.OnButtonClick,this);
	this.mono:AddClick(this.btnSelectBuGou,this.OnButtonClick,this);
	
	
	
	this.mono:AddClick(this.btnBegin,this.UserReady,this);
	
	for i = 1,6 do 
		this.mono:AddClick(this.playerInfoPanel.transform:FindChild("liwu_panel/liwu_"..i).gameObject, this.OnSendGift,this);
	end
	
	this.mono:AddClick(this.sliderBgVolume, this.SetBgVolume);
	this.mono:AddClick(this.sliderEffectVolume, this.SetEffectVolume);
	
	for i=1,8 do
		this.mono:AddClick(this.language_Grid.transform:FindChild("label_"..i).gameObject,this.OnSendLanguage,this);
	end
	------------逻辑代码------------
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end
	
	--log("11111111是否开奖池")
	--log(PlatformGameDefine.playform.IsPool);
	
	 
	
	local footInfo = GameObject.Find("FootInfo")
	local btn_AddMoney = footInfo.transform:FindChild("MsgAddMoney/Button_yes").gameObject
	this.mono:AddClick(btn_AddMoney, this.OnAddMoney); 
	
	
	
	
	this.music=this.transform.gameObject:GetComponent("AudioSource");
	UISoundManager.Init(this.gameObject);
	--UISoundManager.AddAudioSource("gamedhsz/sound","homepage",true);

	--添加音效资源
	for i=1,8 do
		UISoundManager.AddAudioSource("gamedhsz/sound","m_yuyin_"..i);
		UISoundManager.AddAudioSource("gamedhsz/sound","w_yuyin_"..i);
	end
	--[[
	for i=1,6 do
		UISoundManager.AddAudioSource("gamedhsz/sound","m_d_"..i);
		UISoundManager.AddAudioSource("gamedhsz/sound","w_d_"..i);
	end
	for i=2,36 do
		UISoundManager.AddAudioSource("gamedhsz/sound","m_g_"..i);
		UISoundManager.AddAudioSource("gamedhsz/sound","w_g_"..i);
	end
	]]
	UISoundManager.AddAudioSource("gamedhsz/sound","back");
	UISoundManager.AddAudioSource("gamedhsz/sound","baozi");
	UISoundManager.AddAudioSource("gamedhsz/sound","chips");
	UISoundManager.AddAudioSource("gamedhsz/sound","clock");
	UISoundManager.AddAudioSource("gamedhsz/sound","coin");
	UISoundManager.AddAudioSource("gamedhsz/sound","lose");
	UISoundManager.AddAudioSource("gamedhsz/sound","shaizi");
	UISoundManager.AddAudioSource("gamedhsz/sound","shunzi");
	UISoundManager.AddAudioSource("gamedhsz/sound","turn");
	UISoundManager.AddAudioSource("gamedhsz/sound","win");
	
	UISoundManager.AddAudioSource("gamedhsz/sound","m_addchip1");
	UISoundManager.AddAudioSource("gamedhsz/sound","m_addchip3");
	UISoundManager.AddAudioSource("gamedhsz/sound","m_addchip5");
	UISoundManager.AddAudioSource("gamedhsz/sound","m_addchip10");
	UISoundManager.AddAudioSource("gamedhsz/sound","m_check");
	UISoundManager.AddAudioSource("gamedhsz/sound","m_ding");
	UISoundManager.AddAudioSource("gamedhsz/sound","m_kai");
	UISoundManager.AddAudioSource("gamedhsz/sound","m_qiang");
	
	UISoundManager.AddAudioSource("gamedhsz/sound","w_addchip1");
	UISoundManager.AddAudioSource("gamedhsz/sound","w_addchip3");
	UISoundManager.AddAudioSource("gamedhsz/sound","w_addchip5");
	UISoundManager.AddAudioSource("gamedhsz/sound","w_addchip10");
	UISoundManager.AddAudioSource("gamedhsz/sound","w_check");
	UISoundManager.AddAudioSource("gamedhsz/sound","w_ding");
	UISoundManager.AddAudioSource("gamedhsz/sound","w_kai");
	UISoundManager.AddAudioSource("gamedhsz/sound","w_qiang");
	

end

function this:Start()
	if PlatformGameDefine.playform.IsPool then
		local jiangChiPrb = ResManager:LoadAsset("gamenn/JiangChiPrb","JiangChiPrb")
		GameObject.Instantiate(jiangChiPrb)
	end

	
	local info = GameObject.Find ("GameSettingManager");
	
	if not IsNil(info) then
		GameSettingManager:setDepositVisible(true);
	end
	this.mono:StartGameSocket();
	
	coroutine.start(this.Update);
	SettingInfo.Instance.bgVolume=1;
	SettingInfo.Instance.effectVolume=1;
	UISoundManager.Start(true);
	coroutine.start(this.PlayMusic,this);
end

function this:SetBgVolume()
	if this.sliderBgVolumeSprite.spriteName=="special_on" then
		this.sliderBgVolumeSprite.spriteName="special_off";
		this.sliderBgVolume:GetComponent("UIButton").normalSprite="special_off";
	    --UISoundManager.BGVolumeSet(0);
		this.music.volume=0;
		--this.music:Stop();
	else

		this.sliderBgVolumeSprite.spriteName="special_on"
		this.sliderBgVolume:GetComponent("UIButton").normalSprite="special_on";
		--UISoundManager.BGVolumeSet(1);
		this.music.volume=0.2;
		--this.music:Play();
	end

end
function this:SetEffectVolume()
	if this.sliderEffectVolumeSprite.spriteName=="special_on" then
		this.sliderEffectVolumeSprite.spriteName="special_off";
		this.sliderEffectVolume:GetComponent("UIButton").normalSprite="special_off";
		UISoundManager.Instance._EFVolume =0;
	else
		this.sliderEffectVolumeSprite.spriteName="special_on";
		this.sliderEffectVolume:GetComponent("UIButton").normalSprite="special_on";
		UISoundManager.Instance._EFVolume =1;
	end
	
end

function this:OnDisable()
	this:clearLuaValue()
	
end
--获取_tbwzPlayerCtrl对象
function this:GetTbwzPlayerCtrl(tbName,tbObj)
	
	local tbwzTemp = this._tbwzPlayerCtrl[tbName]
	if tbwzTemp == nil then
		
		if not IsNil(tbObj) then
			this._tbwzPlayerCtrl[tbName] = DHSZPlayerCtrl:New(tbObj);
			tbwzTemp = this._tbwzPlayerCtrl[tbName]
			
		else
		end
		
	end
	return tbwzTemp
end
function this:ReplaceNameTbwzPlayerCtrl(oldName,newName)
	
	if oldName ~= newName then
		local tbwzTemp = this._tbwzPlayerCtrl[oldName]
		if tbwzTemp ~= nil then
			this._tbwzPlayerCtrl[newName] = tbwzTemp
			this._tbwzPlayerCtrl[oldName] = nil
		end
	end

end

--删除_tbwzPlayerCtrl对象
function this:RemoveTbwzPlayerCtrl(tbName)
	
	local tbwzTemp = this._tbwzPlayerCtrl[tbName];
	if tbwzTemp then
		tbwzTemp._alive = false;
		tbwzTemp:clearLuaValue();
		this._tbwzPlayerCtrl[tbName] = nil;
		tbwzTemp = nil;
	end
end
function this:RemoveAllTbwzPlayerCtrl()
	if this._tbwzPlayerCtrl then
		for key,v in pairs(this._tbwzPlayerCtrl) do
			v._alive = false;
			v:clearLuaValue();
		end
		this._tbwzPlayerCtrl = nil;
	end
end


function this.ShowPromptHUD(errorInfo)
	--this.btnBegin:SetActive(false);
	this.msgAccountFailed:SetActive(true)
	this.msgAccountFailed:GetComponentInChildren(Type.GetType("UILabel",true)).text = errorInfo;
end


function this:OnDestroy()
	
	
end

function this:Update()
    while this._tbwzPlayerCtrl do
		
		for key,v in pairs(this._tbwzPlayerCtrl) do
			--log(v._alive);
			--log("真假");
			if v._alive then
				v:Update();
			end
		end
		
		--this:TimeUpdate()
		coroutine.wait(0.1);
		--coroutine.wait(Time.deltaTime);
	end
end 
local chazhiTime = 0;
function this:TimeUpdate()
	if this.isStart then
		this._num = this._num -0.1
		if this._num > 0 then 
			chazhiTime =  math.floor(this._num)
			--this.NNCountNum.text = chazhiTime<10 and "0"..chazhiTime or tostring(chazhiTime); 
			
			
			if this._num <= 5   then
				if this._currTime == 1 then
					EginTools.PlayEffect(this.soundCount);	 
				end
				this._currTime = this._currTime -0.1
				if this._currTime < 0 then
					this._currTime = 1;
				end
			end 
			
			 --this.NNCount.fillAmount = (this._num)/self._numMax;
		else
			--this.NNCount.gameObject:SetActive(false)
			this.isStart = false;
		end
		--[[
		chazhiTime = Time.time -this._currTime
		if chazhiTime >= 1 then
			
			if this._num > 0 then
				this._num = this._num-1;
				--this._currTime = Time.time; 
				
				local timerStr = this._num<10 and "0"..this._num or tostring(this._num);
				this.NNCountNum.text = timerStr; 
				
				
				if this._num <= 5 and this.soundCount ~= nil then
					EginTools.PlayEffect(this.soundCount);
				end 
				
				 this.NNCount.fillAmount = (this._num)/self._numMax;
			else
				this.NNCount.gameObject:SetActive(false)
				this.isStart = false;
			end
		else
			this.NNCount.fillAmount = (this._num-chazhiTime)/self._numMax;
		end
		]]
	end
end

function this:UpdateHUD( _time)
	_time = _time-1;
	--self._currTime = Time.time;
	this._currTime = 1;
	this._num =  math.floor(_time); 
	this._numMax = this._num; 
	this.isStart = true;
	
	--this.NNCount.gameObject:SetActive(true)
	
	-- this.NNCount.fillAmount = 1;
	 
	--local timerStr = this._num<10 and "0"..this._num or tostring(this._num);
	--this.NNCountNum.text = timerStr;  
end


function this:AfterDoing(offset,run)
	coroutine.wait(offset);	
	if this.mono then
		run();
	end
end

----解析JSON
function this:SocketReceiveMessage(Message)
	local Message = self;
	
	if  Message then
		--log("---------------Message="..Message) 
		--解析json字符串
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];
		if typeC=="game" then
			log(Message)
			if tag=="enter" then
				this:ProcessEnter(messageObj);		
			elseif tag=="ready" then
				if isgameover then
					table.insert(this.lateMessage,messageObj);
				else
					this:ProcessReady(messageObj);		
				end
			elseif tag=="come" then
				if isgameover then
					table.insert(this.lateMessage,messageObj);
				else
					this:ProcessCome(messageObj);		
				end
			elseif tag=="leave" then
				if isgameover then
					table.insert(this.lateMessage,messageObj);
				else
					this:ProcessLeave(messageObj);
				end
			elseif tag=="deskover" then
				this:ProcessDeskOver(messageObj);
			elseif tag=="notcontinue" then
				coroutine.start(this.ProcessNotcontinue,this);
			elseif tag=="newactfinish" then
				this:ProcessNewactfinish(messageObj);
			elseif "buy_prop_success"==tag then
				this:PrecessBuySuccess(messageObj);
			elseif "buy_prop_error"==tag then
				this:ProcessBuyError(messageObj); 
			elseif tag=="hurry" then
				this:ProcessHurry(messageObj);				
			end
		elseif typeC=="dhs" then
			log(Message)
			if tag=="time" then
				local t = messageObj["body"]
				this:UpdateHUD(t);
			elseif tag=="late" then
				this:ProcessLate(messageObj)
			elseif tag=="end" then 
				--{"body": [[2, 5, 2, 0, 0], [[0, 3, 5, 2, 4, 6], [2, 1, 3, 2, 5, 3]], [[0, -50000], [2, 47500.0]]], "tag": "end", "type": "dhs"}
				--【【赢家座位号 个数 点数 斋 是否抢开】，【【座位号，五个骰子点数】，【座位号，五个骰子点数】】，【【座位号，赢钱数】，【座位号，赢钱数】】】 
				coroutine.start(this.ProcessEnd,this,messageObj);
			elseif tag=="in" then 
				--{"body": [[121230, "小马哥哥哥", 1, 2, 0]], "tag": "in", "type": "dhs"}
				--           uid     nickname  waiting  座位号  
				this:ProcessIn(messageObj);
			elseif tag=="js" then 
				--{"body": [0, 3, 2, 0, 2], "tag": "js", "type": "dhs"}
				--       座位号 个数 点数  斋  下一家叫点座位号
				coroutine.start(this.ProcessJS,this,messageObj);
			elseif tag=="ks" then 
				--{"body": [3, 5, 2, 4, 6, 0], "tag": "ks", "type": "dhs"}			
				--		自己的骰子点数   先叫点的座位号
				coroutine.start(this.ProcessKS,this,messageObj);
			elseif tag=="ask_guess" then	
				coroutine.start(this.ProcessAskGuess,this,messageObj);
			elseif tag=="guess" then		
				this:ProcessGuess(messageObj);
			elseif tag=="k" then
				this:ProcessKai(messageObj);
			end
		elseif typeC=="seatmatch" then
			if tag=="on_update" then
				this:ProcessUpdateAllIntomoney(messageObj);
			end
		elseif typeC=="niuniu" then 
			log(Message)
			--log("是否开奖池")
			--log(PlatformGameDefine.playform.IsPool);
			if tag=="pool" then
				--if PlatformGameDefine.playform.IsPool then
				    --log("11111111111")
					local info = GameObject.Find("PoolInfo")
					local chiFen = messageObj["body"]["money"];
					local infos = messageObj ["body"]["msg"]
					if info then
						PoolInfo:show(chiFen,infos);
					end
				--end
			elseif tag=="mypool" then
			--log("2222222222")
				--if PlatformGameDefine.playform.IsPool then
					local info = GameObject.Find("PoolInfo")
					local chiFen = messageObj["body"];
					if info then
						PoolInfo:setMyPool(chiFen);
					end
				--end
				
			elseif tag=="mylott" then
			--log("333333333333333")
				--if PlatformGameDefine.playform.IsPool then
					local info = GameObject.Find("PoolInfo")
					if(messageObj["body"]["msg"] ~= nil)then
						local msg = messageObj["body"]["msg"]
					else
						local msg = messageObj["body"]
					end
					if info then
						PoolInfo:setMyPool(msg);
					end
				--end
			end
		end
	else
		log("---------------Message=nil")
	end

end

function this:ChuLiXiaoXi()
	if isgameover then
		if #(this.lateMessage)>0 then
			local message=this.lateMessage[1];	
			log("后续消息");
			printf(this.lateMessage);
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
			this.ChuLiXiaoXi();
		else
			isgameover=false;
			this.lateMessage={};
		end
	end
end

function this:ProcessNewactfinish(messageObj) 
	local body = messageObj["body"];
	
	local props = body["props"];
	  
	for index,value in pairs(props) do
		if value[1] == 104 then 
			Activity:SetAddBg(value[4]);
		end
	end 
end
----JSON解析后分发函数----
function this:ProcessEnter(messageObj)
	local body = messageObj["body"];
	local memberinfos = body["memberinfos"]
	this.UserPlayerCtrl = this:GetTbwzPlayerCtrl(this.userPlayerObj.name,this.userPlayerObj);
	
	local playing=false;
	for key,memberinfo in ipairs(memberinfos) do
		if memberinfo then
			local waiting = memberinfo["waiting"];
			if not waiting then
				playing=true;
				break;
			end
		end
	end
	
	for key,memberinfo in ipairs(memberinfos) do
		if memberinfo then
			if tostring(memberinfo["uid"])  == EginUser.Instance.uid then
				_userIndex = memberinfo["position"];
				local waiting = memberinfo["waiting"];
				local avatar=tonumber(memberinfo["avatar_no"]);				
				keynum = tonumber(memberinfo["keynum"])
				Activity:SetCountBgLabel(keynum);
				if waiting then
					table.insert(this._waitPlayerList,this.userPlayerObj);
					log(playing);
					log("是否开始游戏");
					if playing then
						this.btnBegin:SetActive(false);
						this.UserPlayerCtrl:SetWait(true);
						this.UserPlayerCtrl:SetReady(false);		
					else
						this.btnBegin:SetActive(true);
					end
				else
					table.insert(this._playingPlayerList,this.userPlayerObj)
					_reEnter = true;
				end
				local height = this.userPlayerObj.transform.root:GetComponent("UIRoot").manualHeight;
				this:ReplaceNameTbwzPlayerCtrl(this.userPlayerObj.name,_nnPlayerName..EginUser.Instance.uid);				
				this.userPlayerObj.name = _nnPlayerName..EginUser.Instance.uid;
				this.UserPlayerCtrl.nickname=this.UserPlayerCtrl:LengNameSub(EginUser.Instance.nickname);
				log(this.UserPlayerCtrl.nickname);
				this.UserPlayerCtrl.userAvatar.spriteName = "avatar_"..avatar;
				this.UserPlayerCtrl.position_id=0;
				this.UserPlayerCtrl.Uid=tonumber(EginUser.Instance.uid);
				
				if avatar%2==0 then
					this.UserPlayerCtrl.sex=0;
				else
					this.UserPlayerCtrl.sex=1;
				end
				if SettingInfo.Instance.autoNext ==true or SettingInfo.Instance.deposit == true then
					this:UserReady();
				end
				break;
			end
		end
	end
	
	for key,memberinfo in ipairs(memberinfos) do
		if memberinfo then
			if tostring(memberinfo["uid"]) ~= EginUser.Instance.uid then
				this:AddPlayer(memberinfo,_userIndex);
			end
		end
	end

	local deskinfo = body["deskinfo"]
	local t = deskinfo["continue_timeout"]
	local chipMoney=tonumber(deskinfo["unit_money"]);
	this.jingcaiPanel.transform:FindChild("jingcai_label_5"):GetComponent("UILabel").text=tostring(chipMoney).."金币/注";
	--log("当前房间底注"..chipMoney);
	this.dizhu_label.text=tostring(chipMoney);
	this:UpdateHUD(t);
end
function this:AddPlayer(memberinfo,_userIndex)
	local uid = memberinfo["uid"]
	local bag_money = memberinfo["bag_money"]
	local nickname = memberinfo["nickname"]
	local avatar_no = memberinfo["avatar_no"]
	local position = memberinfo["position"]
	local ready = memberinfo["ready"]
	local waiting = memberinfo["waiting"]
	local level = memberinfo["level"]
	
	--local content = this.transform:FindChild("Content").gameObject
	--local player = NGUITools.AddChild(content,this.tbwzPlayerPrefab);
	
	
	local player,localIndex =this:SetAnchorPosition(_userIndex,position);
	--log(localIndex.."=====index");
	player.name = _nnPlayerName..uid;
	local ctrl = this:GetTbwzPlayerCtrl(player.name,player)
	ctrl:SetPlayerInfo(uid,avatar_no,nickname,bag_money,level,localIndex);
	
	
	if waiting then
		if ready then
			ctrl:SetReady(true)
			ctrl:SetWait(false)
			table.insert(this._readyPlayerList,player);
		else
			ctrl:SetReady(false)
			ctrl:SetWait(true)
		end
		table.insert(this._waitPlayerList,player);
	else
		table.insert(this._playingPlayerList,player);
		ctrl:SetShaiZhong();
	end
	
	return player;
end
function this:ProcessLate(messageObj)
	if not _reEnter then
		_late = true
		--this.msgWaitNext:SetActive(true)
	end
	
	--this.btnBegin:SetActive(false)
	local body = messageObj["body"]
	local chip = body["chip"]
	if tonumber(chip) > 0 then
		local infos	= body["infos"]
		for key,info in pairs(infos) do
			local uid = info[1]
			local waitting = info[2]
			local show = info[3]
			local cards = info[4]
			local cardType = info[5]
			
			local player = GameObject.Find(_nnPlayerName..uid)
			if not IsNil(player) then
				local ctrl = this:GetTbwzPlayerCtrl(player.name);
				if tonumber(waitting) == 0 then
					ctrl:SetBet(chip);
					if player == this.userPlayerObj then
						ctrl:SetLate(cards);
						if tonumber(show) == 1 then
							ctrl:SetCardTypeUser(cards,cardType)
						else
							if SettingInfo.Instance.deposit == true then
								coroutine.wait(2);	
								if this.mono==nil then
									return;
								end
								this:UserShow();
							end
							--this.btnShow:SetActive(true)
						end
					else
						ctrl:SetLate(nil);
						if tonumber(show) == 1 then
							ctrl:SetShow(true)
						end
					end
				else
					ctrl:SetWait(true)
				end
				
			end
		
		end

	end
	
	local t = body["t"]
	this:UpdateHUD(t)
end
function this:SetAnchorPosition(_userIndex,playerIndex)
	local position_span = playerIndex-_userIndex; 
	local position_index=-1;
	local player = nil
	if position_span == 1 or position_span == -5 then 
		player = this.tbwzPlayerPrefab[1];
		position_index=1;
	elseif position_span == 2 or position_span == -4 then 
		player = this.tbwzPlayerPrefab[2];
		position_index=2;
	elseif position_span == 3 or position_span == -3 then 
		player = this.tbwzPlayerPrefab[3];
		position_index=3;
	elseif position_span == 4 or position_span == -2 then 
		player = this.tbwzPlayerPrefab[4];
		position_index=4;
	elseif position_span == 5 or position_span == -1 then 
		player = this.tbwzPlayerPrefab[5];
		position_index=5;
	else
		log("数据错误==SetAnchorPosition=="..position_span)
		return player,position_index;
	end
	--log(player.name);
	player:SetActive(true);
	return player,position_index;
end
function this:ProcessReady(messageObj)
	local uid = messageObj["body"]
	local player = GameObject.Find(_nnPlayerName..uid);
	local ctrl = this:GetTbwzPlayerCtrl(player.name);
	
	--coroutine.start(ctrl.SetDeal,ctrl,false,nil);
	if tostring(uid) == EginUser.Instance.uid then
		
		
	else
		--if not this.btnBegin.activeSelf then
		--end
			
	end
	
	ctrl:SetWait(false)
	ctrl:SetReady(true);
	ctrl:SetChuShiHua();
	ctrl:HideJiaoDian();
	table.insert(this._readyPlayerList,player);
end

function this:OnButtonClick(target)
	--log(target.gameObject.name);
	if target==this.btnGeShu then  --个数按钮
		this.panel_geshu:SetActive(true);
		this.panel_dianshu:SetActive(false);
		--this.ScrollView:UpdateScrollbars();
		--this.geshuGrid.transform.parent.transform.localPosition=Vector3.New(-209,272,0);
		this.geshuGrid:GetComponent("UIGrid").enabled=true;
		this.ScrollView:ResetPosition();
		coroutine.start(this.waitTime,this);
		--[[
		if this.canChangeCount then
			this:ShowDiceCount();	
		end
		this.canChangeCount=false;
		this.ScrollView:ResetPosition();
		]]
	elseif target==this.btnDianShu then  --点数按钮
		local now_geshu=tonumber(string.sub(this.own_geshu.spriteName,5));--当前的点数
		if now_geshu>this.geshu then
			for i=1,#(this.List_dianshu) do  --用来选择叫点的个数	
				this.List_dianshu[i]:GetComponent("BoxCollider").enabled=true;
				this.List_dianshu[i]:GetComponent("UISprite").alpha=1;
			end
		else
		    for i=1,#(this.List_dianshu) do  --用来选择叫点的个数
				if i<=this.dianshu then
					this.List_dianshu[i]:GetComponent("BoxCollider").enabled=false;
					this.List_dianshu[i]:GetComponent("UISprite").alpha=0.5;
				else
					this.List_dianshu[i]:GetComponent("BoxCollider").enabled=true;
					this.List_dianshu[i]:GetComponent("UISprite").alpha=1;
				end
			end
		end
		
		this.panel_geshu:SetActive(false);
		this.panel_dianshu:SetActive(true);
	elseif target==this.SelectZhai then  --是否选择斋
		if this.canSelectZhai then
			this.zhai_Sprite:SetActive(true);
			this.label_Zhai.spriteName="zhai_select";
			this.isZhai=1;
			--[[
			if this.zhai_Sprite.activeSelf then
				this.zhai_Sprite:SetActive(false);
				this.label_Zhai.spriteName="zhai_notselect";
				this.isZhai=0;
			else
				this.zhai_Sprite:SetActive(true);
				this.label_Zhai.spriteName="zhai_select";
				this.isZhai=1;
			end
			]]
			this.canSelectZhai=false;
		end
	elseif target==this.btnJiaoDian then  --叫点按钮
		--log(this.own_geshu.spriteName);
		--log(#(this.own_geshu.spriteName));
		--log(this.own_dianshu.spriteName);
		--log(#(this.own_dianshu.spriteName));	
		this.jiaodian_geshu=tonumber(string.sub(this.own_geshu.spriteName,5));
		this.jiaodian_dianshu=tonumber(string.sub(this.own_dianshu.spriteName,-1));
	
		if this.jiaodian_geshu==this.geshu and this.jiaodian_dianshu<=this.dianshu then
			this.msgError:SetActive(true);
			this.msgError.transform:FindChild("Label"):GetComponent("UILabel").text="个数相同时，你选择的点数必须大于对方的点数哦！";
			coroutine.start(this.AfterDoing,this,2,function()
				this.msgError:SetActive(false);
			end);
		else
			local ok={};
			table.insert(ok,this.jiaodian_geshu);
			table.insert(ok,this.jiaodian_dianshu);
			table.insert(ok,this.isZhai);
			local sendData=cjson.encode{type="dhs",tag="js",body=ok};
			this.mono:SendPackage(sendData);
			this.btnJiaoDian:GetComponent("BoxCollider").enabled=false;
			this.btnJiaoDian:GetComponent('UIButton').normalSprite="own_jiaodian_3";
			this.btnJiaoDianSprite.spriteName="own_jiaodian_3";
			
			this.btn_open:SetActive(false);
			if this.msgError.activeSelf then
				this.msgError:SetActive(false);
			end
		end		
	elseif target==this.btn_open then --开骰按钮
		local sendData=cjson.encode{type="dhs",tag="k"};
		this.mono:SendPackage(sendData);
		this.btn_open:SetActive(false);
		this.btnJiaoDian:GetComponent("BoxCollider").enabled=false;
		this.btnJiaoDian:GetComponent('UIButton').normalSprite="own_jiaodian_3";
		this.btnJiaoDianSprite.spriteName="own_jiaodian_3";
		this.UserPlayerCtrl:SetJiaoDian(0,0,true);
		this.canOpenFirst=false;
		if this.open_help.activeSelf then
			this.open_help:SetActive(false);
		end
	elseif target==this.btnSelectGou then
		local guess = {type="dhs",tag="guess",body=this.jingcaiList[1]};    --最终产生json的表
		local jsonStr = cjson.encode(guess);
		this.mono:SendPackage(jsonStr);
		this.jingcaiPanel:SetActive(false);
	elseif target==this.btnSelectBuGou then
		local guess = {type="dhs",tag="guess",body=this.jingcaiList[2]};    --最终产生json的表
		local jsonStr = cjson.encode(guess);
		this.mono:SendPackage(jsonStr);
		this.jingcaiPanel:SetActive(false);
	end

	for i=1,#(this.List_dianshu) do	--用来选择叫点的点数
		if target==this.List_dianshu[i].gameObject then
			this.own_dianshu.spriteName=this.List_dianshu[i].gameObject.transform:FindChild("sprite"):GetComponent("UISprite").spriteName;
			this.panel_dianshu:SetActive(false);
			break;
		end
	end

	for i=1,#(this.List_geshu) do  --用来选择叫点的个数
		if target==this.List_geshu[i].gameObject then
			this.own_geshu.spriteName=this.List_geshu[i].gameObject.transform:FindChild("sprite"):GetComponent("UISprite").spriteName;
			this.panel_geshu:SetActive(false);
			break;
		end
	end
	
end

function this.waitTime()
	coroutine.wait(0);
	this.ScrollView:ResetPosition();
end

--{"body": {"infos": [[118521, "苏黎丗丶", 1, 3], [107325, "明镜", 1, 2], [109001, "无聊伤人", 1, 1], 
--[107017, "赢钱小号012", 1, 5], [106843, "顶顶头", 1, 4], [866627886, "lx1234", 1, 0]], "t": 0}, "tag": "in", "type": "dhs"}
function this:ProcessIn(messageObj)
	this.AllJingCaiList={};
	zhongtuEnter=true;
	local body=messageObj["body"];
	for key,value in ipairs(body) do 
		local uid=tostring(value[1]);
		local deskId=tonumber(value[4]);
		
		this.List_Desk_Uid[deskId]=uid;
		--log(#(this.List_Desk_Uid).."准备玩家的个数");
		local player=GameObject.Find(_nnPlayerName..uid);
		local ctrl=this:GetTbwzPlayerCtrl(player.name);
		ctrl:SetChuShiHua(deskId);
		--[[
		if uid ~=EginUser.Instance.uid then
			this:GetTbwzPlayerCtrl(_nnPlayerName..uid):SetChuShiHua();
		else
			this.UserPlayerCtrl:SetChuShiHua();
		end]]
		table.insert(this._playingPlayerList,player);	
	end
end

--{"body": [2, 1, 2, 2, 4, 125865], "tag": "ks", "type": "dhs"}
function this:ProcessKS(messageObj)
	_isPlaying = true;
	donghuaPlay=false;
	jiaodianCount=0;
	this.AllJingCaiList={};
	this.alreadyJingCai=false;
	for key,player in ipairs(this._readyPlayerList) do
		if not tableContains(this._playingPlayerList,player) then
			table.insert(this._playingPlayerList,player)
		end
	end
	this._readyPlayerList = {};
	
	--清除未被清除的牌
	for key,player in ipairs(this._playingPlayerList) do
		if not IsNil(player) and player ~= this.userPlayerObj then
			local ctrl = this:GetTbwzPlayerCtrl(player.name)
		end
	end
	--去掉“准备”
	for key,player in ipairs(this._playingPlayerList) do
		if not IsNil(player) then
			local ctrl = this:GetTbwzPlayerCtrl(player.name)
			--log(player.name);
			ctrl:SetReady(false)
			
		end
	end
	log(#(this._playingPlayerList).."==开始摇色子时的玩家总数");
	this.own_geshu.spriteName="num_"..#(this._playingPlayerList);
	
	this.canSelectZhai=true;
	this.zhai_Sprite:SetActive(false);
	this.label_Zhai.spriteName="zhai_notselect";
	this.isZhai=0;
	this.dianshu=0;
	this.geshu=0;
	this.jiaodian_message:SetActive(false);
	this.jiaodian_message_all:SetActive(false);
	this.zonggeshu=0;
	this.Already_Zhai:SetActive(false);
	
	this.btnJiaoDian:GetComponent("BoxCollider").enabled=false;
	this.btnJiaoDian:GetComponent('UIButton').normalSprite="own_jiaodian_3";
	this.btnJiaoDianSprite.spriteName="own_jiaodian_3";
	
	--this.own_geshu.spriteName="num_2";
	this.own_dianshu.spriteName="shaizidianshu_2";
	this.dangqiangeshu=0;
	this:ShowDiceCount();
	local body=messageObj["body"];
	local shaizicount={};
	for i=1,5 do
		table.insert(shaizicount,tonumber(body[i]));
	end
	--for i=1,#(shaizicount) do
		--log(shaizicount[i].."======骰子点数");
	--end
	
	local deskId=tostring(body[#(body)]);
	this.jiaodian_id=deskId;
	
	
	for key,player in ipairs(this._playingPlayerList) do
		if player ~= this.userPlayerObj then
			if not IsNil(player) then
				local ctrl = this:GetTbwzPlayerCtrl(player.name)
				ctrl:SetStartAima(false,shaizicount)
				ctrl:SetCardTypeOther(nil,0,0);
			end
		else
			this.UserPlayerCtrl:SetStartAima(true,shaizicount);
			this.UserPlayerCtrl:SetCardTypeUser(nil,0,0);
		end
	end
	UISoundManager.Instance.PlaySound("shaizi");
	
	--this.duijukaishi:SetActive(true);
	this.duijukaishi_1:SetActive(true);
	coroutine.wait(3);
	--this.duijukaishi:SetActive(false);
	this.duijukaishi_1:SetActive(false);
	coroutine.wait(1.5);
	--local player=GameObject.Find(_nnPlayerName..this.List_Desk_Uid[deskId]);
	local player=GameObject.Find(_nnPlayerName..deskId);
	local isown=false;
	if player then
		if player==this.userPlayerObj then
			UISoundManager.Instance.PlaySound("turn");
			this.btnJiaoDian:GetComponent("BoxCollider").enabled=true;
			this.btnJiaoDian:GetComponent('UIButton').normalSprite="own_jiaodian_1";
			this.btnJiaoDianSprite.spriteName="own_jiaodian_1";
			this.nextFollowMe:SetActive(true);	
			isown=true;
			coroutine.start(this.AfterDoing,this,2,function()
				this.nextFollowMe:SetActive(false);
			end); 
		end
		local ctrl = this:GetTbwzPlayerCtrl(player.name)
		ctrl:SetTimeDown(15,isown,false);
	end

end

--此处用来判断可以选择叫点的最小和最大个数
function this:ShowDiceCount()
	local playerCount=#(this._playingPlayerList);
	--log("玩家个数=="..playerCount);
	local geshuCount=playerCount*5-1;
	--log("显示的骰子个数=="..geshuCount);
	
	for i=1,#(this.List_geshu) do
		if i<=geshuCount and i>=this.dangqiangeshu then
			this.List_geshu[i]:SetActive(true);
		else
			this.List_geshu[i]:SetActive(false);
		end
	end
	if this.panel_geshu.activeSelf then
		this.geshuGrid:GetComponent("UIGrid").enabled=true;
		this.ScrollView:ResetPosition();
		coroutine.start(this.waitTime,this);
	end
end

local jiaodianCount=0;
function this:ProcessJS(messageObj)
	local body=messageObj["body"];
	local deskId=tonumber(body[1]);
	this.geshu=tonumber(body[2]);
	this.dianshu=tonumber(body[3]);
	this.isZhai=tonumber(body[4]);
	this.nextoneId=tostring(body[5]);

	this.zhuangjia=tostring(deskId);

	jiaodianCount=jiaodianCount+1;
	if jiaodianCount%2==1 then
		if this.playmusicPanel.activeSelf then
			this.playmusicPanel:SetActive(false);
		end
	else
		if this.playmusicPanel_1.activeSelf then
			this.playmusicPanel_1:SetActive(false);
		end
	end
	
	
	coroutine.wait(0);
	if this.isZhai==1 then
		this.zhai_Sprite:SetActive(true);
		this.label_Zhai.spriteName="zhai_select";	
		this.canSelectZhai=false;
		this.Already_Zhai:SetActive(true);
	else
		this.zhai_Sprite:SetActive(false);
		this.label_Zhai.spriteName="zhai_notselect";	
		this.canSelectZhai=true;
		this.Already_Zhai:SetActive(false);
	end
	
	
	local upJiaodianPlayer=GameObject.Find(_nnPlayerName..this.jiaodian_id);
	if upJiaodianPlayer then
		local ctrl = this:GetTbwzPlayerCtrl(upJiaodianPlayer.name)
		ctrl:HideJiaoDian();
	end
	
	this.jiaodian_id=deskId;
	
	
	this.jiaodian_message:SetActive(true);
	this.message_geshu.text=tostring(this.geshu);
	this.message_dianshu.spriteName="shaizidianshu_"..this.dianshu;
	
	
	local player=GameObject.Find(_nnPlayerName..deskId);
	local nextPlayer=GameObject.Find(_nnPlayerName..this.nextoneId);
	if player then
		local ctrl = this:GetTbwzPlayerCtrl(player.name)
		--log(ctrl.sex);
		if ctrl.sex==0 then
			--log("男");
			if jiaodianCount%2==1 then
				this.playmusic_1.clip=this.m_geshu[this.geshu-1];
				this.playmusic_2.clip=this.m_dianshu[this.dianshu];
			else
				this.playmusic_11.clip=this.m_geshu[this.geshu-1];
				this.playmusic_22.clip=this.m_dianshu[this.dianshu];
			end
		else
			--log("女");
			if jiaodianCount%2==1 then
				this.playmusic_1.clip=this.w_geshu[this.geshu-1];
				this.playmusic_2.clip=this.w_dianshu[this.dianshu];
			else
				this.playmusic_11.clip=this.w_geshu[this.geshu-1];
				this.playmusic_22.clip=this.w_dianshu[this.dianshu];
			end
		end
		if jiaodianCount%2==1 then
			this.playmusicPanel:SetActive(true);
		else
			this.playmusicPanel_1:SetActive(true);
		end
		--if this.geshu>10 then
			--this.playmusicPanel:Play("music_2");
		--else
			--this.playmusicPanel:Play("music_1");
		--end
		
		if player~=this.userPlayerObj then
			if this.UserPlayerCtrl.cardsTrans.gameObject.activeSelf then
				this.btn_open:SetActive(true);
				if nextPlayer~=this.userPlayerObj then
					this.btn_open_qiangkai:SetActive(true);
					this.btn_open_kai:SetActive(false);
				else
					this.btn_open_qiangkai:SetActive(false);
					this.btn_open_kai:SetActive(true);
				end
			end
			this:ChangeBtnGeShu(deskId,this.geshu);
			ctrl:SetJiaoDian(this.geshu,this.dianshu,false);
		else
			this.btnJiaoDian:GetComponent("BoxCollider").enabled=false;
			this.btnJiaoDian:GetComponent('UIButton').normalSprite="own_jiaodian_3";
			this.btnJiaoDianSprite.spriteName="own_jiaodian_3";
			if this.open_help.activeSelf then
				this.open_help:SetActive(false);
			end
			this.btn_open:SetActive(false);
			if this.msgError.activeSelf then
				this.msgError:SetActive(false);
			end
			ctrl:SetJiaoDian(this.geshu,this.dianshu,true);
		end
	end
	
	local isown=false;
	if nextPlayer then
		if nextPlayer==this.userPlayerObj then
			--this.btn_open:SetActive(true);
			if this.canOpenFirst then
				--this.open_help:SetActive(true);
			end
			this.btnJiaoDian:GetComponent("BoxCollider").enabled=true;
			this.btnJiaoDian:GetComponent('UIButton').normalSprite="own_jiaodian_1";
			this.btnJiaoDianSprite.spriteName="own_jiaodian_1";
			this.nextFollowMe:SetActive(true);
			isown=true;
			UISoundManager.Instance.PlaySound("turn");
			coroutine.start(this.AfterDoing,this,2,function()
				this.nextFollowMe:SetActive(false);
			end); 
		else
			--this.btn_open:SetActive(false);
		end
		local ctrl = this:GetTbwzPlayerCtrl(nextPlayer.name)
		ctrl:SetTimeDown(15,isown,false);
	end
end

function this:ChangeBtnGeShu(id,geshu)
	local name=id;
	--log(name.."=============");
	--log(EginUser.Instance.uid);
	this.own_geshu.spriteName="num_"..(geshu+1);
	this.dangqiangeshu=geshu-1;
	this:ShowDiceCount();
end

--{"body": 120153, "tag": "k", "type": "dhs"}
local donghuaPlay=false;
function this:ProcessKai(messageObj)
	local body = messageObj["body"];
	this.xianjia=tostring(body);
	log(this.xianjia.."===闲家ID");
	--donghuaPlay=true;
	if this.zhuangjia~=0 then
		log("播放开动画");
		coroutine.start(this.CheckPlayAnima,this);
		donghuaPlay=true;
	end
	zhongtuEnter=false;
end

--{"body": [110835, 106185], "tag": "ask_guess", "type": "dhs"}
function this:ProcessAskGuess(messageObj)
	coroutine.wait(1);
	this.alreadyJingCai=true;
	this.panel_dianshu:SetActive(false);
	this.panel_geshu:SetActive(false);
	
	local body = messageObj["body"];
	this.jingcaiList=body;
	local hasOwn=false;
	for key,value in ipairs(this.jingcaiList) do
		if tostring(value)==EginUser.Instance.uid then
			hasOwn=true;
			break;
		end
	end
	
	this.zhuangjia=tostring(body[1]);
	this.xianjia=tostring(body[2]);
	local jsplayer=this:GetTbwzPlayerCtrl(_nnPlayerName..this.zhuangjia);
	local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..this.xianjia)
	--log("竞猜");
	--log(this.nextoneId);
	--log(tostring(body[2]));
	--log(this.nextoneId==tostring(body[2]));
	--[[
	if this.nextoneId==tostring(body[2]) then
		if ctrl.sex==0 then
			UISoundManager.Instance.PlaySound("m_kai");
		else
			UISoundManager.Instance.PlaySound("w_kai");
		end
	else
		if ctrl.sex==0 then
			UISoundManager.Instance.PlaySound("m_qiang");
		else
			UISoundManager.Instance.PlaySound("w_qiang");
		end
	end
	]]
	if not donghuaPlay then
		coroutine.start(this.CheckPlayAnima,this);
		donghuaPlay=true;
	end
	
	coroutine.wait(0.5);
	
	if hasOwn then
		this.jingcaiZhong:SetActive(true);
		
	else
		this.jingcaiPanel:SetActive(true);
		this.jingcaiPanel.transform:FindChild("vs_people_1/sprite/sprite"):GetComponent("UISprite").spriteName=this:GetTbwzPlayerCtrl(_nnPlayerName..tostring(this.jingcaiList[2])).userAvatar.spriteName;
		this.jingcaiPanel.transform:FindChild("vs_people_2/sprite/sprite"):GetComponent("UISprite").spriteName=this:GetTbwzPlayerCtrl(_nnPlayerName..tostring(this.jingcaiList[1])).userAvatar.spriteName;
		this.jingcaiPanel.transform:FindChild("jingcai_sprite"):GetComponent("UISprite").spriteName="shaizidianshu_"..this.dianshu;
		this.jingcaiPanel.transform:FindChild("jingcai_label_1"):GetComponent("UILabel").text=this:GetTbwzPlayerCtrl(_nnPlayerName..tostring(this.jingcaiList[2])).nickname;
		--this.jingcaiPanel.transform:FindChild("jingcai_label_2"):GetComponent("UILabel").text=tostring(this.geshu).."个";
		this.jingcaiPanel.transform:FindChild("jingcai_label_2"):GetComponent("UILabel").text=this:GetTbwzPlayerCtrl(_nnPlayerName..tostring(this.jingcaiList[1])).nickname;
		this.jingcaiPanel.transform:FindChild("jingcai_label_3"):GetComponent("UILabel").text=tostring(this.geshu);		
		this.UserPlayerCtrl:SetTimeDown(6,true,true);
	end
end

--{"body": {"uid": 109298, "guessuid": 2}, "tag": "guess", "type": "dhs"}
function this:ProcessGuess(messageObj)
	if not this.alreadyJingCai then
		this.alreadyJingCai=true;
	end
	local body = messageObj["body"];
	local uid=tonumber(body["uid"]);
	local guessuid=tostring(body["guessuid"]);
	this:gameBuySuccess(uid,guessuid,26,1);
	local ctrl=this:GetTbwzPlayerCtrl(_nnPlayerName..uid)
	ctrl.jingcai_duihao:SetActive(true);
	if ctrl.sex==0 then
		UISoundManager.Instance.PlaySound("m_ding")
	else
		UISoundManager.Instance.PlaySound("w_ding")
	end
	
	if guessuid==this.zhuangjia then
		ctrl.GuessTrueOrFalse=1;
	elseif guessuid==this.xianjia then
		ctrl.GuessTrueOrFalse=0;
	end
	
	table.insert(this.AllJingCaiList,tostring(uid));
end



function this:ProcessEnd(messageObj)
	isgameover=true;
	if #(this._playingPlayerList)==2 then
		coroutine.wait(2);
	end
	this.jiaodian_id=-1;
	this.jingcaiZhong:SetActive(false);
	this.jingcaiPanel:SetActive(false);
		
	local body = messageObj["body"]
	local end_message=body[1];
	local infos = body[2];
	local win_message=body[3];
	
	local win_deskid=tonumber(end_message[1]);
	local win_geshu=tonumber(end_message[2]);
	local win_dianshu=tonumber(end_message[3]);
	local win_iszhai=tonumber(end_message[4]);
	local win_isQiangkai=tonumber(end_message[5]);
	local win_jsID=tonumber(end_message[6]);
	
	if not this.alreadyJingCai then
		this.xianjia=tostring(win_deskid);
		this.zhuangjia=tostring(win_jsID);	
		if not donghuaPlay then
			coroutine.start(this.CheckPlayAnima,this);
			donghuaPlay=true;
		end
		
		--[[
		
		local jsplayer=this:GetTbwzPlayerCtrl(_nnPlayerName..this.zhuangjia);
		
		]]
		
		--[[
		this:HideTime();
		this.btn_open:SetActive(false);
		ctrl:SetOpen();
		ctrl:SetOpenAnimation(jsplayer.position_id);
		jsplayer:ShowOrHideShaiZhong(false);
		coroutine.wait(1.5);
		jsplayer:ShowOrHideShaiZhong(true);
		log("开");
		coroutine.wait(0.5);
		log("等待");
		]]
	end
	log("结束");
	
	--玩家扑克牌信息
	for key,info in ipairs(infos) do
		local jos = info
		local uid = tostring(jos[1]);
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..uid)
		if ctrl then
			local cards = {};
			if #(jos)>1 then
				for i=2,#(jos) do
					table.insert(cards,jos[i]);
				end
			end
			--for key,value in ipairs(cards) do
				--log(value.."====结算骰子值");
			--end
			--名牌
			if tostring(uid)~= EginUser.Instance.uid then
				if #(cards)>1 then
					ctrl:SetCardTypeOther(cards,win_dianshu,win_iszhai) 
				else
					ctrl:SetCardTypeOther(nil,win_dianshu,win_iszhai) 
				end
				ctrl:SetEndAnima();
				--coroutine.wait(0.1);
				if this.mono==nil then
					return;
				end
			else
				if #(cards)>1 then
					ctrl:SetCardTypeUser(cards,win_dianshu,win_iszhai) 
				else
					ctrl:SetCardTypeUser(nil,win_dianshu,win_iszhai) 
				end
				ctrl:SetEndAnima();
			end 
		end
	end
	
	
	
	local win_id=0;
	local lose_id=0;
	for key,info in ipairs(win_message) do
		local jos = info
		local uid = tonumber(jos[1])
		local uiAnchor = GameObject.Find(_nnPlayerName..uid)
		if uiAnchor then
			local ctrl = this:GetTbwzPlayerCtrl(uiAnchor.name)	
			local score = tonumber(jos[2])
			--[[
			if score>0 then
				win_id=uid;
			elseif score<0 then
				lose_id=uid;
			end
			]]
			--胜利动画
			ctrl:SetCardWinAnimation(score)
		end
	end
	coroutine.wait(1);
	--if win_id~=0 and lose_id~=0 then
		--this:SetBetMove(win_id,lose_id);
	--end
	
	--log(this.zonggeshu.."===结算总个数");
	this.jiaodian_message:SetActive(false);
	this.message_all_geshu.text="总共"..this.zonggeshu;
	this.message_all_dianshu.spriteName="shaizidianshu_"..win_dianshu;
	this.jiaodian_message_all:SetActive(true);
	
	local gou=false;
	if this.zonggeshu>=this.geshu then
		gou=true;
	else
		gou=false;
	end

	if gou then
		this:SetBetMove(this.zhuangjia,this.xianjia);
	else
		this:SetBetMove(this.xianjia,this.zhuangjia);
	end
	if this.alreadyJingCai then
		for key,value in ipairs(this.AllJingCaiList) do
				local ctrl=this:GetTbwzPlayerCtrl(_nnPlayerName..value)
				log(value.name);
				if gou then
					if ctrl.GuessTrueOrFalse==0 then
						this:SetBetMove(this.zhuangjia,ctrl.Uid);
					elseif ctrl.GuessTrueOrFalse==1 then
						this:SetBetMove(ctrl.Uid,this.xianjia);
					end
				else
					if ctrl.GuessTrueOrFalse==0 then
						this:SetBetMove(ctrl.Uid,this.zhuangjia);
					elseif ctrl.GuessTrueOrFalse==1 then
						this:SetBetMove(this.xianjia,ctrl.Uid);
					end
				end
		end
	end
	
	coroutine.wait(3);
	this.ChuLiXiaoXi();
	
	coroutine.wait(0.3)
	if this.mono==nil then
		return;
	end
	
	
	for key,player in ipairs(this._waitPlayerList) do
		if player ~= this.userPlayerObj then
			this:GetTbwzPlayerCtrl(player.name):SetWait(false)
		end
	end	
	this._waitPlayerList = {}
	
	if _late then
		_late = false;
	else
		--this.btnBegin.transform.localPosition = Vector3.New(300, 0, 0)
	end
	
	if SettingInfo.Instance.autoNext == true or SettingInfo.Instance.deposit == true then
		coroutine.wait(2)
		if this.mono==nil then
			return;
		end
		this:UserReady();
	else
		this.UserPlayerCtrl:SetWait(false);
		this.zhai_Sprite:SetActive(false);
		this.btnBegin:SetActive(true);
	end
	
	--local t = body["t"]
	--this:UpdateHUD(t);
	_isPlaying = false;
	
	
end

function this:OnSendGift(target)
	--log("进入送礼界面");
	local index = 0;
	local textNum = 1;
	local otherid = 1;
	for  i = 0,5 do
		local gift = this.playerInfoPanel.transform:FindChild("liwu_panel");
		if target == gift:FindChild("liwu_".. (i + 1)).gameObject then
			index = i + 20;
			otherid = this.info_Uid;
			break;
		end

	end
	local userId=tonumber(EginUser.Instance.uid);
	--log(userId.."=============userId");
	--log(otherid.."==============otherid");
	this.playerInfoPanel.gameObject:SetActive(false);
	local messageBody = {uid=userId,otherid=otherid,pid=index,num=textNum};
	local sendToken = {type="game",tag="props",body=messageBody};
	local ok = cjson.encode(sendToken);
	this.mono:SendPackage(ok);
	--
end

function this:ProcessBuyError(messageObj)
	local body=messageObj["body"];
	if body=="prop_is_closed" then
		this.msgError.transform:FindChild("Label"):GetComponent("UILabel").text="赠送功能已关闭";
	--elseif body=="no_such_props" then 
		--this.msgError.transform:FindChild("Label"):GetComponent("UILabel").text="道具不存在";
	--elseif body=="system_error" then 
		--this.msgError.transform:FindChild("Label"):GetComponent("UILabel").text="系统送礼功能错误";
	elseif body=="buy_prop_fail_nomoney" then 
		this.msgError.transform:FindChild("Label"):GetComponent("UILabel").text="没有足够的元宝，无法赠送礼物";
	end
	this.msgError:SetActive(true);		
	coroutine.start(this.AfterDoing,this,2,function()
		this.msgError:SetActive(false);
	end);
end

function this:PrecessBuySuccess(messageObj)
	local body = messageObj["body"];
	local ownid = tonumber(body[1]);
	local otherId = tonumber(body[2]);
	local pid = tonumber(body[3]);
	local liwucount = tonumber(body[4]);
	--local yuanbao = tonumber(body[5]); 
	this:gameBuySuccess(ownid,otherId,pid,liwucount);
end


function this:gameBuySuccess(ownid,otherId,pid,liwucount)
	--log("收到礼物");
	
	
	local ownid = ownid;
	local otherId = otherId;
	local pid = pid;
	local liwucount = liwucount;
	local insPrefab = nil
	local liwu_name = "";
	if pid == 20 then
		liwu_name = liwucount.."朵玫瑰花";
		insPrefab = GameObject.Instantiate(this.liwu_1);
	elseif pid == 21 then
		liwu_name = liwucount.."只小乌龟";
		insPrefab = GameObject.Instantiate(this.liwu_2); 
	elseif pid == 22 then
		liwu_name = liwucount.."个水晶杯";
		insPrefab = GameObject.Instantiate(this.liwu_3);
	elseif pid == 23 then
		liwu_name = liwucount.."枚钻戒";
		insPrefab = GameObject.Instantiate(this.liwu_4); 
	elseif pid == 24 then
		liwu_name = liwucount.."辆跑车";
		insPrefab = GameObject.Instantiate(this.liwu_5);
	elseif pid == 25 then
		liwu_name = liwucount.."栋豪宅";
		insPrefab = GameObject.Instantiate(this.liwu_6);
	elseif pid==26 then
		insPrefab = GameObject.Instantiate(this.zancheng);
	end
	--log(liwu_name);
	
	insPrefab.transform.parent = this.gift_Panel;
	insPrefab.transform.position=this:GetTbwzPlayerCtrl(_nnPlayerName..ownid).giftPosition;
	insPrefab.transform.localScale=Vector3.zero;
	local endPosition=this:GetTbwzPlayerCtrl(_nnPlayerName..otherId).giftPosition;
	
	local leixing={};
	leixing[0]=insPrefab;
	leixing[1]=endPosition;
	leixing[2]=pid;
	if pid>25 then
		iTween.ScaleTo(insPrefab,this.mono:iTweenHashLua("scale",Vector3.New(1,1,1),"time",0.3,"easeType", iTween.EaseType.linear,"oncomplete", this.MoveToTarget,"oncompleteparams",leixing,"oncompletetarget", this));
	else	
		iTween.ScaleTo(insPrefab,this.mono:iTweenHashLua("scale",Vector3.New(1.5,1.5,1.5),"time",1 ,"easeType", iTween.EaseType.linear,"oncomplete", this.MoveToTarget,"oncompleteparams",leixing,"oncompletetarget", this));
	end
end

function this:SetBetMove(win_id,lose_id)
	local startPosition=this:GetTbwzPlayerCtrl(_nnPlayerName..lose_id).giftPosition;
	local endPosition=this:GetTbwzPlayerCtrl(_nnPlayerName..win_id).giftPosition;
	local insPrefab=GameObject.Instantiate(this.Sprite_Bet);
	insPrefab.transform.parent = this.gift_Panel;
	insPrefab.transform.position=startPosition;
	insPrefab.transform.localScale=Vector3.one;
	UISoundManager.Instance.PlaySound("chips");
	iTween.MoveTo(insPrefab,this.mono:iTweenHashLua("position",endPosition,"time",1 ,"easeType", iTween.EaseType.linear));
	coroutine.start(this.AfterDoing,this,1, function()
		UISoundManager.Instance.PlaySound("coin");
		coroutine.start(this.AfterDoing,this,0.5, function()
			if insPrefab ~= nil then
				destroy(insPrefab);
			end		
		end);	
	end);
end


function this:ProcessHurry(message)
	languageEndTime=Time.time;
	local body=message["body"];
	local spokesman=tonumber(body["spokesman"]);
	local index=tonumber(body["index"]);
	--log(index.."语音");
	local ctrl=this:GetTbwzPlayerCtrl(_nnPlayerName..spokesman);
	ctrl:setMessage(index);
end

function this:MoveToTarget(leixing)
	local lei=leixing;
	local obj=lei[0];
	local endPosition=lei[1];
	local pid=lei[2];
	
	local leixing={};
	leixing[0]=obj;
	leixing[1]=pid;
	iTween.MoveTo(obj,this.mono:iTweenHashLua("position",endPosition,"time",0.5 ,"easeType", iTween.EaseType.linear,"oncomplete", this.PlayAnima,"oncompleteparams",leixing,"oncompletetarget", this));
end

function this:PlayAnima(leixing)
	local lei=leixing;
	local obj=lei[0];
	local pid=tonumber(lei[1]);
	--log(pid.."=======礼物id"..",礼物名称=="..obj.name);
	if pid==20 then
		obj.transform:FindChild("flower").gameObject:SetActive(true);
	elseif pid == 21 then
		local endPosition=Vector3.New(obj.transform.localPosition.x-100,obj.transform.localPosition.y,0);
		iTween.MoveTo(obj,this.mono:iTweenHashLua("position",endPosition,"islocal",true,"time",1.5 ,"easeType", iTween.EaseType.linear));
	elseif pid == 22 then
		obj:GetComponent("TweenRotation").enabled=true;
	elseif pid == 23 then
		obj.transform:FindChild("house").gameObject:SetActive(true);
	elseif pid == 24 then
		obj:GetComponent("TweenPosition").from=obj.transform.localPosition;
		obj:GetComponent("TweenPosition").to=Vector3.New(obj.transform.localPosition.x-100,obj.transform.localPosition.y-6,0);
		obj:GetComponent("TweenPosition").enabled=true;
		obj:GetComponent("TweenScale").enabled=true;
	elseif pid == 25 then
		obj.transform:FindChild("house").gameObject:SetActive(true);
	end
	coroutine.start(this.AfterDoing,this,1.5, function()
		if obj ~= nil then
			destroy(obj);
		end		
	end);
end

function this:OnSendLanguage(target)
	languagefirstTime=Time.time;
	if languagefirstTime-languageEndTime<jiangeTime then
		this.msgError:SetActive(true);
		this.msgError.transform:FindChild("Label"):GetComponent("UILabel").text=XMLResource.Instance:Str("message_error_5");
		coroutine.start(this.AfterDoing,this,1.5,function()
			this.msgError:SetActive(false);
		end)
	else
		for i=1,8 do
			if target==this.language_Grid.transform:FindChild("label_"..i).gameObject then
				language_index=i;
				break;
			end
		end
		
		local messageBody={};
		messageBody['hurry_index'] = language_index;
		local sendData={type="game",tag="hurry",body=messageBody};
		this.mono:SendPackage(cjson.encode(sendData));
	end
	
	this.languagePanel:SetActive(false);
end



function this:ProcessDeskOver(messageObj)
	--C#中代码被注释 Lua中暂不添加
end
function this:ProcessUpdateAllIntomoney(messageObj)
	local jsonStr = cjson.encode(messageObj);
	local a11=string.find(jsonStr,EginUser.Instance.uid);
	if not a11 then return nil; end
	
	local infos = messageObj["body"]
	for key,info in ipairs(infos) do
		local uid = info[1]
		local intoMoney = info[2]
		local player  = GameObject.Find(_nnPlayerName..uid);
		if not IsNil(player) then
			this:GetTbwzPlayerCtrl(player.name):UpdateIntoMoney(intoMoney);
		end
	end
end
function this.ProcessUpdateIntomoney(messageStr)
	
	local messageObj = cjson.decode(messageStr);
	local intoMoney = tostring(messageObj["body"]);
	local info = GameObject.Find("FootInfo");
	if not IsNil(info) then
		FootInfo:UpdateIntomoneyString(TBWZPlayerCtrl:NumberAddWan(intoMoney));
	end
end
function this:ProcessCome(messageObj)

		local body = messageObj["body"];
		local memberinfo = body["memberinfo"];
		local ready=memberinfo["ready"];
		local player = this:AddPlayer(memberinfo,_userIndex);
		
		if _isPlaying then
			local ctrl = this:GetTbwzPlayerCtrl(player.name);
			if ready then
				ctrl:SetReady(true);
			else
				ctrl:SetWait(true);
			end
		end

end
function this:ProcessLeave(messageObj)
	local uid = messageObj["body"]

		if tostring(uid) ~= EginUser.Instance.uid then
			local player = GameObject.Find(_nnPlayerName..uid);
			local ctrl = this:GetTbwzPlayerCtrl(player.name);
			ctrl:HideWinOrLoseCount();
			this:RemoveTbwzPlayerCtrl(player.name);
			if tableContains(this._playingPlayerList,player) then
				iTableRemove(this._playingPlayerList,player);
			end
			
			if tableContains(this._waitPlayerList,player) then
				iTableRemove(this._waitPlayerList,player);
			end
			if tableContains(this._readyPlayerList,player) then
				iTableRemove(this._readyPlayerList,player);
			end
			player:SetActive(false) 
		end
	
end
function this:ProcessNotcontinue()
	this.msgNotContinue:SetActive(true);
	--等待3秒
	coroutine.wait(3);	
	if this.mono==nil then
		return;
	end
	this:UserQuit()
end

---------end---------
-------向服务器发送消息---------
function this:UserReady()
	--组装好数据调用C#发送函数
	local startJson = {["type"]="dhs",tag="start"};    --最终产生json的表
	--将表数据编码成json字符串
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);
	
	EginTools.PlayEffect(this.but);
	this.btnBegin:SetActive(false);
	this.jingcaiZhong:SetActive(false);
	this.jingcaiPanel:SetActive(false);
	this.jiaodian_message_all:SetActive(false);
end
function this:UserShow()
	
	local ok = {type="tbwz",tag="ok"};    --最终产生json的表
	--将表数据编码成json字符串
	local jsonStr = cjson.encode(ok);
	this.mono:SendPackage(jsonStr);
	
	--this.btnShow:SetActive(false);
	EginTools.PlayEffect(this.but);
end
function this:UserLeave()
	local userLeave = {type="game",tag="leave",body=EginUser.Instance.uid};    --最终产生json的表
	--将表数据编码成json字符串
	local jsonStr = cjson.encode(userLeave);
	this.mono:SendPackage(jsonStr);
end
function this:UserQuit()
	
	SocketConnectInfo.Instance.roomFixseat = true;
	
	local userQuit = {type="game",tag="quit"};    --最终产生json的表
	--将表数据编码成json字符串
	local jsonStr = cjson.encode(userQuit);
	this.mono:SendPackage(jsonStr);
	this.mono:OnClickBack();
	
	this._tbwzPlayerCtrl = nil
	
	EginTools.PlayEffect(this.but);
end

----------end-------------
function this:OnClickBack()
	if not _isPlaying then
		this:UserQuit();
	else
		this.msgQuit:SetActive(true);
	end
	EginTools.PlayEffect(this.but);
end
local rechatge = nil;
function this:GameFunction()  
	 local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end 
	sceneRoot = GameSettingManager.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end 
	destroy(rechatge) 
end
function this:OnAddMoney()  
	rechatge =  GameObject.Instantiate(this.Module_Recharge) 
	local rechatgeTrans = rechatge.transform;
	
	rechatgeTrans.parent = this.transform;
	rechatgeTrans.localScale = Vector3.one;
	
	rechatge:GetComponent("UIPanel").depth = 30; 
	
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	
	if sceneRoot then 
		sceneRoot.manualHeight = 1280;
		sceneRoot.manualWidth = 1920;
	end 
	this.Module_RechargeLua.GameFunction = this.GameFunction;
	 
	
	EginTools.PlayEffect(this.but);
end

function this:LengNameSub( text)
	
	if   LengthUTF8String(text) > 6 then
		return SubUTF8String(text,18);
	end
	return text;
end

function this:HideTime()
	--log("进入隐藏区域");
	for key,player in ipairs(this._playingPlayerList) do
		if not IsNil(player) then
			local ctrl = this:GetTbwzPlayerCtrl(player.name)
			--log(player.name.."===玩家名称");
			ctrl.NNCount.gameObject:SetActive(false)
		end
	end
end

function this:PlayMusic()
	this.music.volume=0.2;
	this.music.clip=this.bg_music_1;
	this.music:Play();
	coroutine.wait(30);
	coroutine.start(this.ChangeBgMusic,this);
end

function this:ChangeBgMusic()
	if this.music.clip==this.bg_music_1 then
		this.music.clip=this.bg_music_2;
	else
		this.music.clip=this.bg_music_1;
	end
	this.music:Play();
	coroutine.wait(30);
	coroutine.start(this.ChangeBgMusic,this);
end

function this:CheckPlayAnima()
	log("开牌动画");
	local jsplayer=this:GetTbwzPlayerCtrl(_nnPlayerName..this.zhuangjia);
	local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..this.xianjia);
	if this.nextoneId~=-1 and this.nextoneId==this.xianjia then
		if ctrl.sex==0 then
			UISoundManager.Instance.PlaySound("m_kai");
		else
			UISoundManager.Instance.PlaySound("w_kai");
		end
	else
		if ctrl.sex==0 then
			UISoundManager.Instance.PlaySound("m_qiang");
		else
			UISoundManager.Instance.PlaySound("w_qiang");
		end
	end
	--if ctrl.sex==0 then
		--UISoundManager.Instance.PlaySound("m_kai");
	--else
		--UISoundManager.Instance.PlaySound("w_kai");
	--end
	this:HideTime();
	this.btn_open:SetActive(false);
	ctrl:SetOpen();
	ctrl:SetOpenAnimation(jsplayer.position_id);
	jsplayer:ShowOrHideShaiZhong(false);
	coroutine.wait(1.5);
	jsplayer:ShowOrHideShaiZhong(true);
end