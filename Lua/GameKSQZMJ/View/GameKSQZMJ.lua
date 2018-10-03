require "GameKSQZMJ/KSQZMJPlayerCtrl"
require "GameKSQZMJ/KSQZMJCount"
require "GameKSQZMJ/shuxing"
require "GameKSQZMJ/TextAnima_kq"
require "GameKSQZMJ/tingpaicaozuo"

local cjson=require "cjson"

local this = LuaObject:New()
GameKSQZMJ = this


local _userAvatar=nil;
local _userNickname=nil;
local _userBagmoney=nil;
local _userLevel=nil;
local _playingPlayerList={};
local _nnPlayerName="NNPlayer_";
local _bankerPlayer=nil;
local _isPlaying=false;
local _late=false;
local _reEnter=false;
local messageJiHe={};
local hengshu=0;
local othernickname="";
local StartGame=true;
local isContinue=false;
local isbanker=false;
local shaizicount_1=0;
local shaizicount_2=0;
local dianshu_allcount=0;
local chupaiOtherCount=0;
local isCGP=false;--主玩家可以进行吃牌、杠牌或者碰牌的操作
local fenzuOwn=0;
local fenzuOther=0;
local singtingpai=false;
local singtingpailist={};
local ownmopaicount=0;--主玩家摸牌次数
local isOwnMoPai=false;--是否主玩家摸牌
local isOtherMoPai=false;--是否对方摸牌
local startmopai=0;
local renter=false;
local gangpaicardcount=0;--摸牌时出现杠牌时的杠牌数值
local isOwnTingpai=false;
local isOtherTingpai=false;
local chupaiTing=false;
local ownzhuangtai=0;
local otherzhuangtai=0;
local gametime=10;--倒计时时间
local startgame=false;--游戏是否开始
local canTuoGuan=false;
local canget=true;
local isGameOver=false;
local canReady=true;
local cgpList={};
local otherChuPaiValue=0;
local chi_count=0;
local musiclast=0;
local music_index=-1;
local firstTime=0;
local endTime=-10;
local jiangeTime=10;
local languagefirstTime=0;
local languageEndTime = -10;
local language_index = -1;
local paixuId=0;
local playerCtrlDc = {}

function this:bindPlayerCtrl(objName,gameObj)
	playerCtrlDc[objName]=KSQZMJPlayerCtrl:New(gameObj);
	--log(objName);
	--log("##########");
end
function this:getPlayerCtrl(objName)
	--log("ssssssssss");
	--printf(playerCtrlDc);
	return playerCtrlDc[objName];
end
function this:removePlayerCtrl(objName)
	if playerCtrlDc[objName]~=nil then
		playerCtrlDc[objName]:OnDestroy();
	end
	playerCtrlDc[objName]=nil;
	--log("离开");
	--log(objName);
end
function this:ReplaceNamePlayerCtrl(oldName,newName)
	if oldName~=newName then
		local ksqzTemp=playerCtrlDc[oldName];
		if ksqzTemp~=nil then
			playerCtrlDc[newName]=ksqzTemp;
			playerCtrlDc[oldName]=nil;
			--log("newName");
			--log(newName);
			--log("oldName");
			--log(oldName);
		end
	end
end


function this:Init()
	playerCtrlDc = {};

	this.sliderBgVolume = this.transform:FindChild("GameSettingManager/Sprite_popup_container/Label_setting/Label_bgmusic/Slider").gameObject:GetComponent("UISlider")
	this.sliderEffectVolume = this.transform:FindChild("GameSettingManager/Sprite_popup_container/Label_setting/Label_bgsound/Slider").gameObject:GetComponent("UISlider")
	this.music=this.transform.gameObject:GetComponent("AudioSource");
	this.bg_music=ResManager:LoadAsset("gameksqzmj/sources","bgm_school");
	this.bg_tingmusic=ResManager:LoadAsset("gameksqzmj/sources","bgm_gamevsrich01");
	
	this.includePool=false;
	this.includeOptions=false;
	this.dznnPlayerPrefab=ResManager:LoadAsset("gameksqzmj/ksqzmjplayer","KSQZMJPlayer");--其他玩家预设
	this.userPlayerObj=this.transform:FindChild("Content/User").gameObject;--主玩家自己
	this.userPlayerCtrl=this:bindPlayerCtrl(this.userPlayerObj.name,this.userPlayerObj);
	
	this.btnBegin=this.userPlayerObj.transform:FindChild("Button_begin").gameObject;--开始按钮
	this.btnTuoguan=this.transform:FindChild("panel_button/Panel_tuoguan/Button_tuoguan").gameObject;--托管按钮
	this.btnCancelTuoGuanPanent=this.transform:FindChild("panel_button/Panel_tuoguan/Sprite_popup_container").gameObject;--托管界面
	this.btnCancelTuoGuan=this.btnCancelTuoGuanPanent.transform:FindChild("Button_cancel").gameObject;--取消托管按钮
	this.btnCancelButton=this.userPlayerObj.transform:FindChild("Output/ChiPaiMessage/Cancel").gameObject;--返回按钮
	this.continueGame=this.userPlayerObj.transform:FindChild("Output/jiesuan/button_panel/Button_continue").gameObject;--继续游戏按钮
	this.cancelGame=this.userPlayerObj.transform:FindChild("Output/jiesuan/button_panel/Button_cancel").gameObject;--退出游戏按钮
	this.shengyupai_parent=this.transform:FindChild("Content/shengyupai").gameObject;--剩余牌父物体
	this.shengyucount=this.shengyupai_parent.transform:FindChild("shengyu_bg/shengyu").gameObject:GetComponent("UILabel");--剩余牌Label
	this.timeParent=this.transform:FindChild("Content/NNCount").gameObject;--倒计时父物体
	--log(this.timeParent.name);
	this.NNCount=KSQZMJCount:New(this.timeParent);
	this.time_jiantou=this.timeParent.transform:FindChild("time_jiantou").gameObject;--倒计时箭头	
	
	
	
	local msg=this.transform:FindChild("Content/MsgContainer");--提示信息父物体
	--log(msg.name);
	this.msgQuit=msg.transform:FindChild("MsgQuit").gameObject;
	--log(this.msgQuit.name);
	this.msgAccountFailed=msg:FindChild("MsgAccountFailed").gameObject;
	this.msgNotContinue=msg:FindChild("MsgNotContinue").gameObject;
	this.message_error=msg:FindChild("MsgError").gameObject;
	
	this.shaizi=this.transform:FindChild("Content/shaizi"):GetComponent("Animator");--骰子
	this.shaizi_1=this.shaizi.transform:FindChild("shaizi_3"):GetComponent("UISprite");
	this.shaizi_2=this.shaizi.transform:FindChild("shaizi_4"):GetComponent("UISprite");
	
	local jishupanel=this.shaizi.transform:FindChild("jishuPanel");--基数
	this.jishu_num_1=jishupanel.transform:FindChild("jishu_num_1"):GetComponent("UILabel");
	this.jishu_num_shu_1=jishupanel:FindChild("jishu_num_shu_1"):GetComponent("UILabel");
	this.jishu_num_shu_2=jishupanel.transform:FindChild("jishu_num_shu_2"):GetComponent("UILabel");
	this.jishu_endnum=jishupanel.transform:FindChild("jishu_endnum"):GetComponent("UILabel");
	
	local cgpht=this.transform:FindChild("Content/CGPeffect");--吃杠碰动画父物体
	this.chi=cgpht:FindChild("chiParent").gameObject:GetComponent("Animator");
	this.peng=cgpht:FindChild("pengParent").gameObject:GetComponent("Animator");
	this.gang=cgpht:FindChild("gangParent").gameObject:GetComponent("Animator");
	this.hu=cgpht:FindChild("huParent").gameObject:GetComponent("Animator");
	this.tiantingAnima=cgpht:FindChild("tiantingParent").gameObject:GetComponent("Animator");
	this.tianhuAnima=cgpht:FindChild("tianhuParent").gameObject:GetComponent("Animator");


	
	this.buttonShowParent={};--点击取消按钮时需要显示的按钮集合
	this.otherUid="0";
	
	this.outAllPai={};--所有打出的牌
	this.paicount=64;
	this.standupCardObj=nil;--选中并且被提起的麻将牌
	this.chupaiOwnCount=0;
	this.istuoguan=false;
	this.isOwnChuPai=false;
	this.isOwnCanHuPai=false;
	this.isOwnCaoZuo=false;
	this.AlreadyTing=false;
	this.canCancelTuoguan=false;
	this.AnimatorPlayEnd=false;
	this.CanTingpai=false;
	
	this.liujuParent=this.transform:FindChild("Content/LiuJuParent").gameObject;
	this.yinying=this.transform:FindChild("Content/ButtonPanel/bottom_bg").gameObject:GetComponent("UISprite");
	selectcaozuo={};
	for i=1,6 do
		table.insert(selectcaozuo,this.yinying.transform:FindChild("caozuo_"..i).gameObject);
	end
	local caozuopanel=this.transform:FindChild("Content/ButtonPanel");
	selectcaozuo_Position={};
	for i=1,6 do
		table.insert(selectcaozuo_Position,caozuopanel:FindChild("caozuoposition_"..i));
	end
	
	local chitishi=this.transform:FindChild("Content/User/Output/ChiPaiMessage");
	this.chitishi_1=chitishi:FindChild("ChiPaiMessage_1").gameObject;
	this.chitishi_2=chitishi:FindChild("ChiPaiMessage_2").gameObject;
	this.chitishi_3=chitishi:FindChild("ChiPaiMessage_3").gameObject;
	
	
	
	this.talk=this.transform:FindChild("panel_button/Panel_talk/Sprite_popup_container").gameObject;
	this.biaoqingPanel=this.talk.transform:FindChild("smile_biaoqing").gameObject;
	this.biaoqingParent=this.biaoqingPanel.transform:FindChild("UIGrid").gameObject;
	this.languagePanel=this.talk.transform:FindChild("changyongyu").gameObject;
	this.changyongyu=this.languagePanel.transform:FindChild("UIGrid/Man").gameObject;
	this.button_talk=this.transform:FindChild("panel_button/Panel_talk/Button_talk").gameObject;
	
	local xiaoxi=this.talk.transform:FindChild("Label_setting");
	this.button_biaoqing=xiaoxi:FindChild("Sprite_biaoqing").gameObject:GetComponent("UISprite");
	this.button_language=xiaoxi:FindChild("Sprite_yuyin").gameObject:GetComponent("UISprite");
	
	
	this.playingIsOwn=false;
	
	
	
	_userAvatar=nil;
	_userNickname=nil;
	_userBagmoney=nil;
	_userLevel=nil;
	_playingPlayerList={};
	 _nnPlayerName="NNPlayer_";
	_bankerPlayer=nil;
	_isPlaying=false;
	_late=false;
	_reEnter=false;
	messageJiHe={};
	hengshu=0;
	othernickname="";
	StartGame=true;
	isContinue=false;
	isbanker=false;
	shaizicount_1=0;
	shaizicount_2=0;
	dianshu_allcount=0;
	chupaiOtherCount=0;
	isCGP=false;--主玩家可以进行吃牌、杠牌或者碰牌的操作
	fenzuOwn=0;
	fenzuOther=0;
	singtingpai=false;
	singtingpailist={};
	ownmopaicount=0;--主玩家摸牌次数
	isOwnMoPai=false;--是否主玩家摸牌
	isOtherMoPai=false;--是否对方摸牌
	startmopai=0;
	renter=false;
	gangpaicardcount=0;--摸牌时出现杠牌时的杠牌数值
	isOwnTingpai=false;
	isOtherTingpai=false;
	chupaiTing=false;
	ownzhuangtai=0;
	otherzhuangtai=0;
	gametime=10;--倒计时时间
	startgame=false;--游戏是否开始
	canTuoGuan=false;
	canget=true;
	isGameOver=false;
	canReady=true;
	cgpList={};
	otherChuPaiValue=0;
	chi_count=0;
	musiclast=0;
	music_index=-1;
	firstTime=0;
	endTime=-10;
	jiangeTime=10;
	languagefirstTime=0;
	languageEndTime = -10;
	language_index = -1;
	paixuId=0;

	this.bankerUid=0;
end

function this:clearLuaValue()
	playerCtrlDc = {}	
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	
	for k,v in pairs(playerCtrlDc) do
		v:OnDestroy()
	end
	playerCtrlDc = {}
	coroutine.Stop()
	LuaGC();

	this.sliderBgVolume = nil;
	this.sliderEffectVolume = nil;

	this.includePool=false;
	this.includeOptions=false;
	this.dznnPlayerPrefab=nil;
	this.userPlayerObj=nil;
	this.userPlayerCtrl=nil;
	this.btnBegin=nil;
	this.btnTuoguan=nil;
	this.btnCancelTuoGuanPanent=nil;
	this.btnCancelTuoGuan=nil;
	this.btnCancelButton=nil;
	this.shengyupai_parent=nil;
	this.shengyucount=nil;
	this.timeParent=nil;
	this.time_jiantou=nil;
	

	this.msgQuit=nil;
	this.msgAccountFailed=nil;
	this.msgNotContinue=nil;
	this.message_error=nil;
	
	this.zhaizi=nil;
	this.shaizi_1=nil;
	this.shaizi_2=nil;
	
	this.jishu_num_1=nil;
	this.jishu_num_shu_1=nil;
	this.jishu_num_shu_2=nil;
	this.jishu_endnum=nil;
	
	this.chi=nil;
	this.peng=nil;
	this.gang=nil;
	this.hu=nil;
	this.tianting=nil;
	this.tianhu=nil;
	
	this.buttonShowParent={};
	this.otherUid="0";
	
	this.outAllPai={};
	this.paicount=0;
	this.standupCardObj=nil;
	this.chupaiOwnCount=0;
	this.istuoguan=false;
	this.isOwnChuPai=false;
	this.isOwnCanHuPai=false;
	this.isOwnCaoZuo=false;
	this.AlreadyTing=false;
	this.canCancelTuoguan=false;
	this.AnimatorPlayEnd=false;
	this.CanTingpai=false;
	
	this.liujuParent=nil;
	this.yinying=nil;
	selectcaozuo={};
	selectcaozuo_Position={};
	
	this.chitishi_1=nil;
	this.chitishi_2=nil;
	this.chitishi_3=nil;
	
	this.music=nil;
	
	this.talk=nil;
	this.biaoqingPanel=nil;
	this.biaoqingParent=nil;
	this.languagePanel=nil;
	this.changyongyu=nil;
	this.changyongyu=nil;
	this.button_talk=nil;
	
	this.button_biaoqing=nil;
	this.button_language=nil;
	
	this.music=nil;
	this.bg_music=nil;
	this.bg_tingmusic=nil;

	this.playingIsOwn=false;
	
	
	

	_userAvatar=nil;
	_userNickname=nil;
	_userBagmoney=nil;
	_userLevel=nil;
	_playingPlayerList={};
	_nnPlayerName="NNPlayer_";
	_bankerPlayer=nil;
	_isPlaying=false;
	_late=false;
	_reEnter=false;
	messageJiHe={};
	hengshu=0;
	othernickname="";
	StartGame=false;
	isContinue=false;
	isbanker=false;
	shaizicount_1=0;
	shaizicount_2=0;
	dianshu_allcount=0;
	chupaiOtherCount=0;
	isCGP=false;--主玩家可以进行吃牌、杠牌或者碰牌的操作
	fenzuOwn=0;
	fenzuOther=0;
	singtingpai=false;
	singtingpailist={};
	ownmopaicount=0;--主玩家摸牌次数
	isOwnMoPai=false;--是否主玩家摸牌
	isOtherMoPai=false;--是否对方摸牌
	startmopai=0;
	renter=false;
	gangpaicardcount=0;--摸牌时出现杠牌时的杠牌数值
	isOwnTingpai=false;
	isOtherTingpai=false;
	chupaiTing=false;
	ownzhuangtai=0;
	otherzhuangtai=0;
	gametime=0;--倒计时时间
	startgame=false;--游戏是否开始
	canTuoGuan=false;
	canget=false;
	isGameOver=false;
	canReady=false;
	cgpList={};
	otherChuPaiValue=0;
	chi_count=0;
	musiclast=0;
	music_index=0;
	firstTime=0;
	endTime=0;
	jiangeTime=0;
	languagefirstTime=0;
	languageEndTime = 0;
	language_index =0;
	paixuId=0;
	
	this.bankerUid=0;
	this.NNCount:clearLuaValue();
	this.NNCount=nil;
end



function this:Awake()
	log("------------------awake of GameKSQZMJ")

	this.Init();
	this.timeParent:SetActive(false);
	local footInfoPrb = ResManager:LoadAsset("gameksqzmj/footinfoprb","FootInfoPrb")
	--local settingPrb = ResManager:LoadAsset("gametbwz/settingprb","SettingPrb")
	GameObject.Instantiate(footInfoPrb)
	
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		
		sceneRoot.minimumHeight = 768;
		sceneRoot.manualHeight = 800;
		sceneRoot.manualWidth = 1422;
	end
	this.transform.localPosition=Vector3.New(0,0,400);
	
	
	this.mono:AddSlider(this.sliderBgVolume, this.SetBgVolume);
	this.mono:AddSlider(this.sliderEffectVolume, this.SetEffectVolume);
	
	this.mono:AddClick(this.msgQuit.transform:FindChild("Button_yes").gameObject,this.UserQuit,this);--退出界面的确定按钮
	this.mono:AddClick(this.chitishi_1,this.OnButtonClick,this);
	this.mono:AddClick(this.chitishi_2,this.OnButtonClick,this);
	this.mono:AddClick(this.chitishi_3,this.OnButtonClick,this);
	this.mono:AddClick(this.btnCancelButton,this.HuanYuanCaoZuo,this);
	this.mono:AddClick(this.btnBegin,this.UserReady);
	this.mono:AddClick(this.btnTuoguan,this.UserTuoguan,this);
	this.mono:AddClick(this.btnCancelTuoGuan,this.UserTuoguan,this);
	this.mono:AddClick(this.continueGame,this.UserContinue,this);
	this.mono:AddClick(this.cancelGame,this.UserQuit,this);
	this.mono:AddClick(this.button_talk,this.TalkClick,this);
	
	for i=1,6 do
		this.mono:AddClick(this.yinying.transform:FindChild("caozuo_"..i).gameObject,this.OnButtonClick,this);
	end
	this.mono:AddClick(this.button_biaoqing.gameObject,this.TalkClick,this);
	this.mono:AddClick(this.button_language.gameObject,this.TalkClick,this);
	for i=1,27 do
		this.mono:AddClick(this.biaoqingParent.transform:FindChild("biaoqing_"..i).gameObject,this.OnSetBiaoQing,this);
	end
	for i=1,8 do
		this.mono:AddClick(this.changyongyu.transform:FindChild("label_"..i).gameObject,this.OnSendLanguage,this);
	end
	--this.mono:AddClick(this.transform:FindChild("Button_back/Button_back").gameObject,this.OnClickBack,this);
	local button_back = this.transform:FindChild("Button_back/Button_back").gameObject;
	--log(button_back.name);
	--log(type(button_back));
	this.mono:AddClick(button_back, this.OnClickBack,this)
	
	
	-----------初始化UISoundManager------------
	UISoundManager.Init(this.gameObject);

	--添加音效资源
	for i=1,39 do
		if i==8 or i==9 or i==10 or i==20 or i==30 then
		
		else
			UISoundManager.AddAudioSource("gameksqzmj/Sources","man_"..i);
			UISoundManager.AddAudioSource("gameksqzmj/Sources","woman_"..i);
		end	
	end
	UISoundManager.AddAudioSource("gameksqzmj/Sources","man_angang");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","man_chi");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","man_gang");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","man_peng");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","man_hu");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","man_ting");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","man_zimo");
	
	UISoundManager.AddAudioSource("gameksqzmj/Sources","woman_angang");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","woman_chi");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","woman_gang");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","woman_peng");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","woman_hu");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","woman_ting");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","woman_zimo");
	
	for i=0,7 do
		UISoundManager.AddAudioSource("gameksqzmj/Sources","mchat_"..i);
		UISoundManager.AddAudioSource("gameksqzmj/Sources","wchat_"..i);
	end
	
	UISoundManager.AddAudioSource("gameksqzmj/Sources","chupai");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","fanpai");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","huapai");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","jiesuanzapai");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","ready");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","shaizi");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","shandian");
	
	UISoundManager.AddAudioSource("gameksqzmj/Sources","tileclick");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","zimobg");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","xuanpai");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","win");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","lose");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","candy_hit_normal_3");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","candy_hit_score_bonus");
	
	UISoundManager.AddAudioSource("gameksqzmj/Sources","liuju");
	for i=0,2 do
		UISoundManager.AddAudioSource("gameksqzmj/Sources","m_chi_"..i);
	end
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_chi_other");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_fangpao_other_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_fangpao_other_1");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_gang_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_gang_1");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_gang_other");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_lose_other_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_lose_other_1");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_peng_0");	
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_peng_other");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_ting");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_zimo_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_zimo_1");
	for i=0,2 do
		UISoundManager.AddAudioSource("gameksqzmj/Sources","w_chi_"..i);
	end
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_chi_other");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_fangpao_other_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_fangpao_other_1");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_gang_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_gang_1");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_gang_other");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_lose_other_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_lose_other_1");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_peng_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_peng_other_1");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_peng_other_2");
	
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_ting"); 
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_zimo_0");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_zimo_1");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","tianting2");
	--UISoundManager.AddAudioSource("gameksqzmj/Sources","tianhuend");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_tianhu");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_tianhu");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","m_tianting");
	UISoundManager.AddAudioSource("gameksqzmj/Sources","w_tianting");



	UISoundManager.Instance._EFVolume = this.sliderEffectVolume.value;
--	local footInfoPrb = ResManager:LoadAsset("gamenn/footinfoprb","FootInfoPrb")
--	local settingPrb = ResManager:LoadAsset("gamenn/settingprb","SettingPrb")
--	GameObject.Instantiate(footInfoPrb)
--	GameObject.Instantiate(settingPrb)
end

function this:Start()
	if SettingInfo.Instance.autoNext == true or this.despoite==1 then 
		this.btnReady:SetActive(false);
	end

	this.mono:StartGameSocket();
	this.initLayout();
	UISoundManager.Start(true);
	UISoundManager.Instance._EFVolume=1;
	UISoundManager.Instance._BGVolume=1;
	--this.music.volume = SettingInfo.Instance.bgVolume;
	this:PlayMusic();
	coroutine.start(this.UpdateInLua);
	--this:UpdateInLua();

end

function this:SetBgVolume()
	SettingInfo.Instance.bgVolume = this.sliderBgVolume.value;
	if this.music ~= nil then
		this.music.volume = SettingInfo.Instance.bgVolume 
	end
end
function this:SetEffectVolume()
	--SettingInfo.Instance.effectVolume = this.sliderEffectVolume.value;
	UISoundManager.Instance._EFVolume = this.sliderEffectVolume.value;
end



function this:OnEnable() 

end


function this:OnDisable()
	this:clearLuaValue();
end

function this:initLayout()
        --判断是否只有一个选择下注的筹码
	if string.find(SocketConnectInfo.Instance.roomTitle,System.Text.RegularExpressions.Regex.Unescape("\\u521d\\u7ea7")) then
		isPrimary = true;
	else
		isPrimary=false;
	end     
end

function this:SocketReceiveMessage(message)
	local msgStr=self;
	--log(msgStr);
	if msgStr then
		local msgData = cjson.decode(msgStr)
		local typeC = msgData["type"]		
		if typeC==nil then
			return;
		end
		local tag= msgData["tag"]
		if "game"==typeC then
			if tag=="enter" then
				--log(msgStr);
				this:ProcessEnter(msgData);
			elseif tag=="ready" then
				--log(msgStr);
				this:ProcessReady(msgData);
			elseif tag=="come" or tag=="leave" or tag=="deskover"  then  -- or tag=="notcontinue" then
				--log(msgStr);
				table.insert(messageJiHe,msgData);
			elseif tag=="notcontinue" then
				--log(msgStr);
				--coroutine.start(this.ProcessNotcontinue,this,message);
				table.insert(messageJiHe,msgData);
			elseif tag=="actfinish" then
			
			elseif tag=="emotion" then
				--log(msgStr);
				this:ProcessEmotion(msgData);
			elseif tag=="hurry" then
				--log(msgStr);
				this:ProcessHurry(msgData);
			end
		elseif "mj7"==typeC then
			if tag=="run" then
				--log(msgStr);
				table.insert(messageJiHe,msgData);
			elseif tag=="run2" then
				--log(msgStr);
				coroutine.start(this.ProcessLate,this,msgData);
			elseif tag=="k" or tag=="time" or tag=="h" or tag=="o" or tag=="e" or tag=="p" or tag=="b" or tag=="m" or tag=="r" or tag=="t" or tag=="d" or tag=="y" or tag=="end" or tag=="error" then
				--log(msgStr);
				table.insert(messageJiHe,msgData);
			end
		elseif "seatmatch"==typeC then
			if tag=="on_update" then
				this:ProcessUpdateAllIntomoney(msgData);
			end
		elseif "niuniu"==typeC then
			if tag == "pool" then
				if PlatformGameDefine.playform.IsPool then
					local info = find("initJC")
					local chiFen = msgData["body"]["money"]
					local infos  = msgData["body"]["msg"]
					if(info ~= nil) then
						PoolInfo:show(chiFen, infos)
					end
				end
			elseif tag == "mypool" then
				if PlatformGameDefine.playform.IsPool then
					local chiFen = msgData["body"]
					local info = find("initJC")
					if info ~= nil then
						PoolInfo:setMyPool(chiFen)
					end
				end
			elseif tag == "mylott" then
				local msg = nil;
				if msgData["body"]["msg"] ~= nil then
					msg = msgData["body"]["msg"]
				else
					msg = msgData["body"]
				end
				
				if PlatformGameDefine.playform.IsPool  then
					local info = find("PoolInfo")
					if info ~= nil then
						PoolInfo:setMyPool(msg)
					end
				end
				
			end
		
		end
	end
end

function this:ChuLiXiaoXi()
	if this.AnimatorPlayEnd then
		local message=messageJiHe[1];
		--printf(message);
		iTableRemove(messageJiHe,messageJiHe[1]);
		local typeC=message["type"];
		local tag=message["tag"];
		if "mj7"==typeC then
			if tag=="time" then
				local t=tonumber(message["body"]);
			elseif tag=="run" then
				--log("发牌");
				coroutine.start(this.ProcessDeal,this,message);
			elseif tag=="run2" then
				coroutine.start(this.ProcessLate,this,message);
			elseif tag=="h" then
				this:ProcessDengdai(message);
			elseif tag=="o" then
				--printf(message);
				coroutine.start(this.ProcessChupai,this,message);
			elseif tag=="e" then
				coroutine.start(this.ProcessChipai,this,message);
			elseif tag=="p" then
				coroutine.start(this.ProcessPengpai,this,message);
			elseif tag=="b" then
				coroutine.start(this.ProcessGangpai,this,message);
			elseif tag=="m" then
				--log("摸牌");
				coroutine.start(this.ProcessMopai,this,message);
			elseif tag=="r" then
				this:ProcessCuopai(message);
			elseif tag=="t" then
				this:ProcessZhuangtai(message);
			elseif tag=="d" then
				this:ProcessLaoyue(message);
			elseif tag=="y" then
				this:ProcessLaoyue_1(message);
			elseif tag=="k" then
				this:ProcessStartChupai(message);
			elseif tag=="end" then
				coroutine.start(this.ProcessEnd,this,message);
			elseif tag=="error" then
			
			end
		elseif "game"==typeC then
			if tag=="deskover" then
				this:ProcessDeskOver(message);
			elseif tag=="notcontinue" then
				coroutine.start(this.ProcessNotcontinue,this,message);
			elseif tag=="come" then
				this:ProcessCome(message);
			elseif tag=="leave" then
				this:ProcessLeave(message);
			end
		elseif "seatmatch"==typeC then
			if tag=="on_update" then
				this:ProcessUpdateAllIntomoney(message);
			end
		end
	end
end

function this:ChiXuJieXiaoXi()
	if #(messageJiHe)>0 and tostring(messageJiHe[1])~="null" then
		this:ChuLiXiaoXi();
		this.AnimatorPlayEnd=false;
	else 
		if this.AnimatorPlayEnd then
			coroutine.wait(1);
			coroutine.start(this.ChiXuJieXiaoXi,this);
		end
	end
end

function this:ProcessLate(message)
	if not _reEnter then
		_late=true;
	end
	renter=true;
	canTuoGuan=true;
	_isPlaying=true;
	StartGame=false;
	canReady=false;
	
	this.btnBegin:SetActive(false);
	local cardAllCount=0;--目前所有牌的总数
	local body=message["body"];
	local step=tonumber(body[1]);--游戏阶段
	gametime=tonumber(body[2]);--剩余时间
	this.bankerUid=tonumber(body[3]);--庄家ID
	local showcards=body[4];--各个玩家应该展示出来的碰牌、吃牌和杠牌
	local outcards=body[5];--各个玩家打出的牌
	local cards=body[6];--自己手中所有的牌
	local huapai=body[7];--(中间偏右显示的)花牌
	local chupaiuid=tonumber(body[8]);--当前出牌的玩家
	local dengdaiuid=tonumber(body[9]);--等待操作的玩家
	local card=tonumber(body[10]);--最后打出的牌
	local zhuangtai=body[11];--可做的操作【胡，杠，碰，吃，听，【可杠的牌】，【可用哪些牌来吃】，【打出牌，【胡的牌，番数】】】
	local states=body[12];--【【uid，玩家状态，是否换过牌】】 0取消 1托管 2听牌
	local shaizicount=body[13];--骰子点数
	local liujucardcount=tonumber(body[14]);--目前还有多少张牌流局
	cardAllCount=64-liujucardcount;
	local othershoulipaiCount=tonumber(body[15]);
	
	--显示倒计时
	this.timeParent:SetActive(true);
	coroutine.start(this.nextFollow,this,tostring(dengdaiuid));
	if tostring(dengdaiuid)==EginUser.Instance.uid then
		this.isOwnChuPai=true;
	else
		this.isOwnChuPai=false;
	end
	
	--显示庄家
	if tostring(this.bankerUid)==EginUser.Instance.uid then
		isbanker=true;
	else
		isbanker=fase;
	end
	this:getPlayerCtrl(_nnPlayerName..this.bankerUid):SetCallBanker(true);
	
	local huapaiId=tonumber(huapai[#(huapai)]);
	this.userPlayerCtrl:SetHuaPai(huapaiId,false);
	
	for key,value in pairs(states) do
		local showuid=tonumber(value[1]);
		local tuoguan=tonumber(value[2]);
		this:TuoGuanState(showuid,tuoguan,true,true);
	end
	
	--吃杠碰牌显示
	for key,value in ipairs(showcards) do
		local showuid=tonumber(value[1]);
		local cgpcards=value[2];
		local player=this:getPlayerCtrl(_nnPlayerName..showuid);
		if #(cgpcards)>0 and tostring(cgpcards[1])~="null" then
			if player then
				local isown=false;
				if tostring(showuid)==EginUser.Instance.uid then
					isown=true;
					fenzuOwn=#(cgpcards);
					--log(fenzuOwn.."分组自己");
				else 
					isown=false;
					fenzuOther=#(cgpcards);
					--log(fenzuOther.."分组别人");
				end
				player:SetLateCGPpai(isown,cgpcards);
				for i=1,#(cgpcards) do
					table.insert(this.outAllPai,tonumber(cgpcards[i]));
				end
			end
		end
	end
	
	--所有打出的牌
	for key,value in ipairs(outcards) do
		local outuid=tonumber(value[1]);
		local outpai=value[2];
		if #(outpai)>0 and tostring(outpai[1])~="null" then
			if tostring(outuid)==EginUser.Instance.uid then
				this.chupaiOwnCount=#(outpai);
			else
				chupaiOtherCount=#(outpai);
			end
			
			for i=1,#(outpai) do
				table.insert(this.outAllPai,tonumber(outpai[i]));
			end
		end
		local player=this:getPlayerCtrl(_nnPlayerName..outuid);
		if player then
			if #(outpai)>0 and tostring(outpai[1])~="null" then
				player:SetLateDaChuPai(outpai,outuid);
			end
		end
	end
	
	this:getPlayerCtrl(_nnPlayerName..this.otherUid):SetLateOtherShoulipai(othershoulipaiCount,EginUser.Instance.uid);
	this:getPlayerCtrl(_nnPlayerName..this.otherUid).MopaiIndex=10;
	this.userPlayerCtrl.MopaiIndex=10;
	
	--主玩家手里的牌
	local shoulicards={};
	for i=1,#(cards) do
		table.insert(this.outAllPai,tonumber(cards[i]));
	end
	if #(cards)%3==1 then
		for i=1,#(cards) do
			table.insert(shoulicards,tonumber(cards[i]));
		end
		for i=1,#(shoulicards) do
			shoulicards[i]=this:paiXuID(shoulicards[i]);
		end
	else
		for i=1,#(cards)-1 do
			table.insert(shoulicards,tonumber(cards[i]));
		end
		for i=1,#(shoulicards) do
			shoulicards[i]=this:paiXuID(shoulicards[i]);
		end
		table.insert(shoulicards,this:paiXuID(tonumber(cards[#(cards)])));
	end
	
	this:paixu(shoulicards);
	this.userPlayerCtrl:SetLateShoulipai(shoulicards,this.istuoguan,this.AlreadyTing,fenzuOwn,this.otherUid);
	
	this.shengyupai_parent:SetActive(true);
	this.paicount=this.paicount-cardAllCount;
	this.shengyucount.text=tostring(this.paicount);
	if #(zhuangtai)>1 then
		if tonumber(zhuangtai[1])>0 or tonumber(zhuangtai[2])>0 or tonumber(zhuangtai[3])>0 or tonumber(zhuangtai[4])>0 or tonumber(zhuangtai[5])>0 then
			if not this.istuoguan then
				this:thisState(zhuangtai);
			end
		end
	end
	
	shaizicount_1=tonumber(shaizicount[1]);
	shaizicount_2=tonumber(shaizicount[2]);
	dianshu_allcount=shaizicount_1+shaizicount_2;
	
	local allUserCard={};
	local lieshu=cardAllCount/2;
	hengshu=cardAllCount%2;
	
	local zongshu=0;
	if hengshu==1 then
		zongshu=lieshu+dianshu_allcount+1;
	else
		zongshu=lieshu+dianshu_allcount;
	end
	
	if tostring(chupaiuid)==EginUser.Instance.uid then
		if chupaiuid==dengdaiuid then
			isOwnMoPai=true;
		else 
			isOwnMoPai=false;
		end
	else
		if chupaiuid==dengdaiuid then
			isOwnMoPai=true;
		else
			isOwnMoPai=false;
		end
		
	end
	
	coroutine.wait(0.2);
	this:HuiDiaoFunction();
end

function this:ProcessEnter(message)
	this:HuiDiaoFunction();
	
	local body=message["body"];
	local memberinfos=body["memberinfos"];
	--log("1111111111");
	this.userPlayerCtrl =  this:getPlayerCtrl(this.userPlayerObj.name);
	--log("222222222");
	for key,value in ipairs(memberinfos) do
		if value then
			if tostring(value["uid"])==EginUser.Instance.uid then
				table.insert(_playingPlayerList,this.userPlayerObj);
			end
			_reEnter=true;
			
			this:ReplaceNamePlayerCtrl(this.userPlayerObj.name,_nnPlayerName..EginUser.Instance.uid)
			this.userPlayerObj.name = _nnPlayerName..EginUser.Instance.uid;
			
			if tonumber(value["avatar_no"])%2==1 then
				this.userPlayerCtrl.sex=1;
			else
				this.userPlayerCtrl.sex=0;
			end
			
			if SettingInfo.Instance.autoNext==true or this.istuoguan then
				this:UserReady();
			else
				this.btnBegin:SetActive(true);
			end
			
		end
	end
	--log("33333333333333");
	for key,value in ipairs(memberinfos) do
		--printf(value);
		--log("进入玩家");
		if value~=nil then
			--log(EginUser.Instance.uid)
			if tostring(value["uid"])~=EginUser.Instance.uid then
				--log(EginUser.Instance.uid)
				--log("111111");
				this:AddPlayer(value);
				--log("222222222")
			end
		end
	end
	--log("4444444444444");
	
	local deskinfo=body["deskinfo"];	
end

function this:AddPlayer(memeberinfo)
	--printf(memeberinfo);
	this.otherUid=tostring(memeberinfo["uid"]);
	
	local uid=this.otherUid;
	local bag_money=tostring(memeberinfo["bag_money"]);
	local nickname=tostring(memeberinfo["nickname"]);
	local avatar_no=tonumber(memeberinfo["avatar_no"]);
	--log("========++++++++++++++++++++++");
	local level=tostring(memeberinfo["level"]);
	local tempCtrl=this:getPlayerCtrl(_nnPlayerName..uid);
	if tempCtrl==nil then
		local player=NGUITools.AddChild(this.gameObject,this.dznnPlayerPrefab);
		player.name=_nnPlayerName..uid;
		--log("添加");
		--log(player.name);
		--log("-----------");
		this:bindPlayerCtrl(player.name,player);
		local anchor=player:GetComponent("UIAnchor");
		anchor.side=UIAnchor.Side.Left;
		anchor.relativeOffset.x=0.2;
		anchor.relativeOffset.y=0.39;
		player.transform.localPosition=Vector3.New(-370,313,0);
		
		local ctrl=this:getPlayerCtrl(player.name);
		if avatar_no%2==1 then
			ctrl.sex=1;
		else
			ctrl.sex=0;
		end
		ctrl:SetPlayerInfo(avatar_no,nickname,bag_money,level);
		table.insert(_playingPlayerList,player);
	end
end

function this:ProcessReady(message)
	local uid=tostring(message["body"]);
	--log(uid);
	local player=GameObject.Find(_nnPlayerName..uid);
	if player then
		--log("存在");
		--log(player.name);
		local ctrl=this:getPlayerCtrl(player.name);
		if canReady then
			ctrl:SetReady(true);
		end
	end
	if uid==EginUser.Instance.uid then
	
	else
	
	end
end

function this:UserReady()
	if _bankerPlayer~=nil then
	
	end
	local sendData=nil;
	if StartGame then
		sendData={type="mj7",tag="start"};
	else
		sendData={type="game",tag="continue"};
	end
	this.mono:SendPackage(cjson.encode(sendData));
	
	this.btnBegin:SetActive(false);
	isContinue=true;
	this:HuiDiaoFunction();
end

function this:UserContinue()
	local sendData={type="game",tag="continue"};
	this.mono:SendPackage(cjson.encode(sendData));

	isGameOver=true;
	isContinue=true;
	--log("点击继续按钮");
	--log(isContinue);
	this.jishu_endnum.text="100";
	local OtherPlayer=GameObject.Find(_nnPlayerName..this.otherUid);
	
	this.userPlayerCtrl:ClearAllPrefab(true);
	canTuoGuan=false;
	this.btnTuoguan:GetComponent("BoxCollider").enabled=true;
	if OtherPlayer then
		local otherCtrl=this:getPlayerCtrl(OtherPlayer.name);
		otherCtrl:ClearAllPrefab(false);
	end
	if isGameOver then
		this.music.clip=this.bg_music;
		this.music:Play();
	end
	this:HuiDiaoFunction();
end


function this:ProcessDeal(message)
	this:getPlayerCtrl(_nnPlayerName..this.otherUid):ChongZhiState();
	this.userPlayerCtrl:ChongZhiState();
	StartGame=false;
	this.isOwnCaoZuo=false;
	fenzuOwn=0;
	fenzuOther=0;
	this.shaizi.enabled=false;
	_isPlaying=true;
	startgame=true;
	this.isOwnChuPai=false;
	coroutine.wait(1);
	this.userPlayerCtrl:SetReady(false);
	
	local player=GameObject.Find(_nnPlayerName..this.otherUid);
	local otherCtrl=this:getPlayerCtrl(player.name);
	otherCtrl:SetReady(false);

	this.shengyupai_parent:SetActive(true);
	this.shengyucount.text=tostring(this.paicount);
	
	coroutine.wait(1.5);
	
	local body=message["body"];
	local shaizicount=body["dice"];
	local cards=body["cards"];
	shaizicount_1=tonumber(shaizicount[1]);
	shaizicount_2=tonumber(shaizicount[2]);
	--log(shaizicount_1.."=======shaizi============"..shaizicount_2);
	this.shaizi_1.spriteName="shazi_"..shaizicount_1;
	this.shaizi_2.spriteName="shazi_"..shaizicount_2;
	--log("筛子");
	--log(this.shaizi_1.spriteName);
	--log(this.shaizi_2.spriteName);
	this.jishu_num_1.text=tostring(shaizicount_1+shaizicount_2);
	this.jishu_num_shu_1.text=tostring(shaizicount_1);
	this.jishu_num_shu_2.text=tostring(shaizicount_2);
	this.jishu_endnum.text=tostring((shaizicount_1+shaizicount_2)*100);
	--this.userPlayerCtrl.dishu.text="底数x"..this.jishu_endnum.text;
	
	--log("花牌");
	--log(cards[#(cards)]);
	local huapaiId=tonumber(cards[#(cards)]);
	this.userPlayerCtrl:SetHuaPai(huapaiId,false);
	for i=1,#(cards) do
		table.insert(this.outAllPai,tonumber(cards[i]));
	end
	
	--庄家图标的显示
	if #(cards)>8 then
		this.userPlayerCtrl:SetCallBanker(true);
		this.userPlayerCtrl:chongzhi();
		this.userPlayerCtrl.MopaiIndex=1;
		isbanker=true;
		this.time_jiantou.transform.eulerAngles=Vector3.zero;
		isOwnMoPai=true;
		this.isOwnCaoZuo=true;
	else
		isbanker=false;
		this.time_jiantou.transform.eulerAngles=Vector3.New(0,0,180);
		isOtherMoPai=true;
		otherCtrl:SetCallBanker(true);
		otherCtrl:chongzhi();
		otherCtrl.MopaiIndex=1;
	end
	
	--骰子旋转动画
	this.shaizi.enabled=true;
	this.shaizi:CrossFade("shaizi_1",0);
	--log("播放骰子声音");
	UISoundManager.Instance.PlaySound("shaizi");
	coroutine.wait(3);
	this:ShowShaizi(cards);
end

function this:ShowShaizi(cards)
	coroutine.start(this.hideShaizi,this);
	
	--自己的两次抓牌的的所有牌的点数列表
	local card_1={};
	local card_2={};
	local card_3={};
	for i=1,#(cards) do
		if i<5 then
			table.insert(card_1,tonumber(cards[i]));
		elseif i>4 and i<8 then
			table.insert(card_2,tonumber(cards[i]));
		elseif i==8 then
			table.insert(card_3,tonumber(cards[i]));
		end
	end
	
	--庄家、闲家的抓牌动画
	local v=0.5;
	local temp=0;
	for i=0,4 do
		local num=i;
		temp=v;
		coroutine.start(this.AfterDoing,this,temp,function()
			if num<2 then
				this.paicount=this.paicount-4;
				this.shengyucount.text=tostring(this.paicount);
			elseif num>=2 and num<4 then
				this.paicount=this.paicount-3;
				this.shengyucount.text=tostring(this.paicount);
			else
				this.paicount=this.paicount-1;
				this.shengyucount.text=tostring(this.paicount);
			end
			this:zhuapaiAnimation(num,card_1,card_2,card_3);
		end)
		v=v+0.2;
	end
end

function this:hideShaizi()
	local uid="";
	if isbanker then
		uid=EginUser.Instance.uid;
	else
		uid=this.otherUid;
	end
	coroutine.wait(1.5);
	
	this.timeParent:SetActive(true);--倒计时父物体
	gametime=10;
	coroutine.start(this.nextFollow,this,uid);
end

function this:zhuapaiAnimation(num,card_1,card_2,card_3)
	--log("开始抓牌");
	if isbanker then
		local player=GameObject.Find(_nnPlayerName..this.otherUid);
		local ctrl=this:getPlayerCtrl(player.name);
		if num%4==0 and num==0 then
			coroutine.start(this.userPlayerCtrl.chuangJianThisPais,this.userPlayerCtrl,card_1,1,isbanker);
		elseif num%4==2 then
			coroutine.start(this.userPlayerCtrl.chuangJianThisPais,this.userPlayerCtrl,card_2,2,isbanker);
		elseif num%4==1 then
			coroutine.start(ctrl.chuangJianThatPais,ctrl,4,1,false);
		elseif num%4==3 then
			coroutine.start(ctrl.chuangJianThatPais,ctrl,3,2,false);
		elseif num==4 then
			coroutine.start(this.userPlayerCtrl.chuangJianThisPais,this.userPlayerCtrl,card_3,3,isbanker);
		end
	else
		local player=GameObject.Find(_nnPlayerName..this.otherUid);
		local ctrl=this:getPlayerCtrl(player.name);
		if num%4==0 and num==0 then
			coroutine.start(ctrl.chuangJianThatPais,ctrl,4,1,true);
		elseif num%4==2 then
			coroutine.start(ctrl.chuangJianThatPais,ctrl,3,2,true);
		elseif num%4==1 then
			coroutine.start(this.userPlayerCtrl.chuangJianThisPais,this.userPlayerCtrl,card_1,1,isbanker);
		elseif num%4==3 then
			coroutine.start(this.userPlayerCtrl.chuangJianThisPais,this.userPlayerCtrl,card_2,2,isbanker);
		elseif num==4 then
			coroutine.start(ctrl.chuangJianThatPais,ctrl,1,3,true);
		end	
	end
end


function this:ProcessChupai(message)
	local body=message["body"];
	local chuPaiUid=tonumber(body[1]);
	local cards=tonumber(body[2]);
	local dengDaiUid=tostring(body[3]);
	local zhuangtai=body[4];
	if tostring(chuPaiUid)==EginUser.Instance.uid then--如果主玩家出牌
		this.chupaiOwnCount=this.chupaiOwnCount+1;
		isOtherMoPai=false;
		this.isOwnCaoZuo=false;
		if this.AlreadyTing or this.istuoguan then
			
		else
			this:HuiDiaoFunction();
		end
	
		if chupaiTing then
			this.AlreadyTing=true;
			chupaiTing=false;
		end
		if this.AlreadyTing then
			this.userPlayerCtrl:SetOwnChupai(cards,this.chupaiOwnCount,dengDaiUid,false,ownzhuangtai,true);
		elseif this.istuoguan then
			--log("托管出牌");
			this.userPlayerCtrl:SetOwnChupai(cards,this.chupaiOwnCount,dengDaiUid,false,ownzhuangtai,true);
		end
	else--如果其他玩家出牌
		isOwnMoPai=false;
		chupaiOtherCount=chupaiOtherCount+1;
		otherChuPaiValue=cards;
		table.insert(this.outAllPai,cards);
		local player=GameObject.Find(_nnPlayerName..chuPaiUid);
		if tonumber(zhuangtai[1])==1 or tonumber(zhuangtai[2])==1 or tonumber(zhuangtai[3])==1 or tonumber(zhuangtai[4])==1 then
			if tonumber(zhuangtai[1])==1 then
				this.isOwnCanHuPai=true;
			end
			isCGP=true;
		end
		
		if not IsNil(player) then
			--log("打出牌的其他玩家");
			--log(player.name);
			local ctrl=this:getPlayerCtrl(player.name);
			if isOtherTingpai then
				coroutine.start(ctrl.SetOtherChupai,ctrl,cards,chupaiOtherCount,dengDaiUid,true,otherzhuangtai,isCGP);
				isOtherTingpai = false;
			else
				coroutine.start(ctrl.SetOtherChupai,ctrl,cards,chupaiOtherCount,dengDaiUid,false,otherzhuangtai,isCGP);
			end
		end	
	end
	
	if tostring(dengDaiUid)==EginUser.Instance.uid then
		if tonumber(zhuangtai[1])>0 or tonumber(zhuangtai[2])>0 or tonumber(zhuangtai[3])>0 or tonumber(zhuangtai[4])>0 or tonumber(zhuangtai[5])>0 then
			coroutine.wait(1);
			--log("可以进行吃杠碰操作");
			this.userPlayerCtrl:JinZhiShouLiPai(false);		
			if this.istuoguan then
				if tonumber(zhuangtai[1])>0 then
					local liebiao={};
					table.insert(liebiao,1);
					local sendData={type="mj7",tag="f",body=liebiao};
					this.mono:SendPackage(cjson.encode(sendData));
				end
			else
				--log("显示吃杠碰弹框");
				this:thisState(zhuangtai);
				gametime=10;
			end		
		else
			gametime=10;
		end
	else
		gametime=10;
	end
	coroutine.start(this.nextFollow,this,dengDaiUid);
end

function this:ProcessChipai(message)
	local body=message["body"];
	local uid=tostring(body[1]);
	local chipaiList=body[2];
	if uid==EginUser.Instance.uid then
		isCGP=false;--主玩家已经进行了吃牌的操作
		if not this.istuoguan then
			this.isOwnCaoZuo=true;
		end
		fenzuOwn=fenzuOwn+1;
		--log(fenzuOwn.."分组吃自己");
		chupaiOtherCount=chupaiOtherCount-1;--别的玩家出牌数量减1
		this.isOwnChuPai=true;
		local tingpai=tonumber(body[3]);
		this.userPlayerCtrl:setChiPai(chipaiList,this.otherUid,true,fenzuOwn,tingpai);
		coroutine.start(this.userPlayerCtrl.PlayAnima,this.userPlayerCtrl,true,1,false,false,false);
		if tingpai==1 then
			if not this.istuoguan then
				this:SingleTing();
				singtingpai=true;
				singtingpailist=body[4];
			end
		end
	else
		fenzuOther=fenzuOther+1;
		--log(fenzuOther.."分组吃别人");
		this.chupaiOwnCount=this.chupaiOwnCount-1;
		for i=1,#(chipaiList) do
			table.insert(this.outAllPai,tonumber(chipaiList[i]));
		end
		local player=GameObject.Find(_nnPlayerName..this.otherUid);
		local ctrl=this:getPlayerCtrl(player.name);
		ctrl:setChiPai(chipaiList,EginUser.Instance.uid,false,fenzuOther,0);
		coroutine.start(ctrl.PlayAnima,ctrl,true,1,false,false,false);
	end
	coroutine.wait(0.3);
	this.chi.enabled=true;
	this.chi:CrossFade("chi_effect",0);
end


function this:ProcessPengpai(message)
	local body=message["body"];
	local uid=tostring(body[1]);
	local pengpaiId=tonumber(body[2]);
	if uid==EginUser.Instance.uid then
		isCGP=false;--主玩家进行了碰牌的操作
		if not this.istuoguan then
			this.isOwnCaoZuo=true;
		end
		fenzuOwn=fenzuOwn+1;
		--log(fenzuOwn.."分组碰自己");
		chupaiOtherCount=chupaiOtherCount-1;--别的玩家出牌数量减1
		this.isOwnChuPai=true;
		local canting=tonumber(body[3]);
		this.userPlayerCtrl:Pengpai(pengpaiId,true,this.otherUid,fenzuOwn,canting);
		coroutine.start(this.userPlayerCtrl.PlayAnima,this.userPlayerCtrl,true,2,false,false,false);
		if canting==1 then
			if not this.istuoguan then
				this:SingleTing();
				singtingpai=true;
				singtingpailist=body[4];
			end
		end
	else
		fenzuOther=fenzuOther+1;
		--log(fenzuOther.."分组碰别人");
		this.chupaiOwnCount=this.chupaiOwnCount-1;
		for i=1,2 do
			table.insert(this.outAllPai,pengpaiId);
		end
		local ctrl=this:getPlayerCtrl(_nnPlayerName..this.otherUid);
		ctrl:Pengpai(pengpaiId,false,EginUser.Instance.uid,fenzuOther,0);
		coroutine.start(ctrl.PlayAnima,ctrl,true,2,false,false,false);
	end
	coroutine.wait(0.3);
	this.peng.enabled=true;
	this.peng:CrossFade("peng_effect",0);	
end

function this:ProcessGangpai(message)
	--if #(this.buttonShowParent)>1 then
		--for i=1,#(this.buttonShowParent) do
			--this.buttonShowParent[i]:SetActive(false);
		--end
		--this.buttonShowParent={};
	--end
	this:HideTanKuang();
	local body=message["body"];
	local uid=tostring(body[1]);
	local gangpaiId=tonumber(body[2]);--杠牌值
	local gangpaiType=tonumber(body[3]);--杠牌状态 1.已经碰过的牌 2.暗杠 3.杠别人的牌
	local bupaiId=tonumber(body[4]);--杠后补的花牌
	this.userPlayerCtrl:SetHuaPai(bupaiId,true);
	if uid==EginUser.Instance.uid then
		coroutine.start(this.userPlayerCtrl.PlayAnima,this.userPlayerCtrl,true,3,false,false,false);
		isCGP=false;--主玩家已经进行了杠牌的操作
		if not this.istuoguan then
			this.isOwnCaoZuo=true;
		end
		if gangpaiType==2 or gangpaiType==3 then
			fenzuOwn=fenzuOwn+1;
			--log(fenzuOwn.."分组杠自己");
			if gangpaiType==3 then
				chupaiOtherCount=chupaiOtherCount-1;
			end
		end
		ownmopaicount=ownmopaicount+1;
		local bushoulipaiId=tonumber(body[5]);
		
		this.isOwnChuPai=true;
		local gangpaiting=false;
		local zhuangtai=body[6];
		if tonumber(zhuangtai[1])>0 or tonumber(zhuangtai[2])>0 or tonumber(zhuangtai[3])>0 or tonumber(zhuangtai[4])>0 or tonumber(zhuangtai[5])>0 then
			if tonumber(zhuangtai[1])>0 then
				gangpaiting=true;
			end
			if tonumber(zhuangtai[5])>0 then
				this.userPlayerCtrl.isCPTing=false;
				singtingpai=false;
			end
			if this.istuoguan then
				if tonumber(zhuangtai[1])>0 then
					local liebiao={};
					table.insert(liebiao,1);
					local sendData={type="mj7",tag="f",body=liebiao};
					this.mono:SendPackage(cjson.encode(sendData));
				end
			else
				this:thisState(zhuangtai);
			end
		end
		
		this.userPlayerCtrl:Gangpai(gangpaiId,gangpaiType,true,this.otherUid,fenzuOwn,bushoulipaiId,ownmopaicount,gangpaiting);
	else
		if gangpaiType==2 or gangpaiType==3 then
			fenzuOther=fenzuOther+1;
			--log(fenzuOther.."分组杠别人");
			if gangpaiType==3 then
				this.chupaiOwnCount=this.chupaiOwnCount-1;
			end
		end
		if gangpaiType==1 then
			table.insert(this.outAllPai,gangpaiId);
		end
		if gangpaiType==2 then
			for i=1,4 do
				table.insert(this.outAllPai,gangpaiId);
			end
		end
		if gangpaiType==3 then
			for i=1,3 do 
				table.insert(this.outAllPai,gangpaiId);
			end	
		end
		local ctrl=this:getPlayerCtrl(_nnPlayerName..this.otherUid);
		ctrl:Gangpai(gangpaiId,gangpaiType,false,EginUser.Instance.uid,fenzuOther,0,0,false);
		coroutine.start(ctrl.PlayAnima,ctrl,true,3,false,false,false);
	end
	coroutine.wait(0.3);
	this.gang.enabled=true;
	this.gang:CrossFade("gang_effect",0);
end

function this:HideTanKuang()
	if #(this.buttonShowParent)>1 then
		for i=1,#(this.buttonShowParent) do 
			this.buttonShowParent[i]:SetActive(false);
		end
		this.buttonShowParent={};
	end
	this.yinying:GetComponent("Animator").enabled=false;
	this.yinying.transform.localScale=Vector3.zero;
end

function this:ProcessMopai(message)
	this:HideTanKuang();
	local body=message["body"];
	local mopaiInfo=body;
	local uid=tostring(mopaiInfo[1]);
	if uid==EginUser.Instance.uid then
		isOwnMoPai=true;
		if this.AlreadyTing then
			this.userPlayerCtrl:JinZhiShouLiPai(false);
		else
			isOtherMoPai=true;
		end
	end
	
	if startgame then--如果刚开始游戏
		if not isbanker then
			startmopai=startmopai+1;
			this.paicount=this.paicount-1;
			this.shengyucount.text=tostring(this.paicount);
		else
			this:HuiDiaoFunction();
		end
		startgame=false;
	else
		if renter then
			if hengshu==1 then
				startmopai=startmopai+1;
			else
				startmopai=startmopai+2;
			end
			this.paicount=this.paicount-1;
			this.shengyucount.text=tostring(this.paicount);
			renter=false;
		else
			startmopai=startmopai+1;
			this.paicount=this.paicount-1;
			this.shengyucount.text=tostring(this.paicount);
		end
	end
	
	--真正第一次摸牌时   
    if startmopai> 0 then
    
    end      
     

	--这儿是操作牌桌上摸牌的时候，从桌子上获得当前可以抓取的牌
	--log(selectMoPaiIndex);
	
	if #(mopaiInfo)>2 then
		if uid==EginUser.Instance.uid then
			if not this.istuoguan then
				this.isOwnCaoZuo=true;
			end
			ownmopaicount=ownmopaicount+1;
			local cardcount=tonumber(mopaiInfo[3]);
			table.insert(this.outAllPai,cardcount);
			
			local zhuangtai=mopaiInfo[4];
			if isbanker and cardcount==0 then
				this.isOwnChuPai=true;
				--log("我是庄家");
				--log(this.isOwnChuPai);
			end
			
			if tonumber(zhuangtai[1])>0 or tonumber(zhuangtai[2])>0 or tonumber(zhuangtai[3])>0 or tonumber(zhuangtai[4])>0 or tonumber(zhuangtai[5])>0 then
				if tonumber(zhuangtai[1])>0 or tonumber(zhuangtai[2])>0 or tonumber(zhuangtai[3])>0 or tonumber(zhuangtai[4])>0 then
					this.userPlayerCtrl:JinZhiShouLiPai(false);
					this.userPlayerCtrl.isCPTing=true;
				else
					this.userPlayerCtrl.isCPTing=false;
				end
				singtingpai=false;
				--log("是否听牌and是否托管");
				--log(this.AlreadyTing);
				--log(this.istuoguan);
				if this.AlreadyTing or this.istuoguan then
					coroutine.wait(1.5);
					if tonumber(zhuangtai[1])>0 then
						local liebiao={};
						table.insert(liebiao,1);
						local sendData={type="mj7",tag="f",body=liebiao};					
						--log("发送胡牌");
						this.mono:SendPackage(cjson.encode(sendData));
					end
				else
					this:thisState(zhuangtai);
					if tonumber(zhuangtai[2])>0 then
						gangpaicardcount=tonumber(zhuangtai[6][0]);
					end
				end
			end
			
			if cardcount>0 then
				if this.istuoguan or this.AlreadyTing then
					this.userPlayerCtrl:setMoPai(cardcount,true,ownmopaicount,true);
				else
					this.userPlayerCtrl:setMoPai(cardcount,true,ownmopaicount,false);
				end
			end
		end
	else
		if uid==EginUser.Instance.uid then
			if tonumber(mopaiInfo[2])>0 or not this.istuoguan then
				
			end
		else
			local ctrl=this:getPlayerCtrl(_nnPlayerName..this.otherUid);
			ctrl:setMoPai(0,false,0,false);
		end	
	end
end

function this:ProcessCuopai(message)

end

function this:ProcessZhuangtai(message)
	local body=message["body"];
	local uid=tonumber(body[1]);
	local zhuangtai=tonumber(body[2]);
	this:TuoGuanState(uid,zhuangtai,false,true);
end

function this:TuoGuanState(uid,zhuangtai,islate,cancelTuoGuan)
	local cancelTuoGuan=cancelTuoGuan;
	if tostring(uid)==EginUser.Instance.uid then
		ownzhuangtai=zhuangtai;
		if ownzhuangtai==0 then
			canTuoGuan=true;
			this.canCancelTuoguan=false;
			this.istuoguan=false;
			this.btnCancelTuoGuanPanent:SetActive(false);
			this.btnTuoguan.transform:FindChild("Background"):GetComponent("UISprite").spriteName="tuoguan";
			this.userPlayerCtrl:tuoGuanChangeColor(false);
			this.btnTuoguan:GetComponent("BoxCollider").enabled=true;
			this.btnCancelTuoGuan:GetComponent("BoxCollider").enabled=false;
		elseif ownzhuangtai==1 then
			--log(cancelTuoGuan.."可以取消托管");
			if cancelTuoGuan then
				this.canCancelTuoguan=true;
			else
				this.canCancelTuoguan=false;
			end
			--log(this.canCancelTuoguan.."=========this.canCancelTuoguan");
			canTuoGuan=false;
			this.CanTingpai=false;
			this.istuoguan=true;
			--log("托管");
			--log(this.istuoguan);
			this.btnTuoguan:GetComponent("BoxCollider").enabled=false;
			this.btnCancelTuoGuan:GetComponent("BoxCollider").enabled=true;
			this.btnCancelTuoGuanPanent:SetActive(true);
			this.btnTuoguan.transform:FindChild("Background"):GetComponent("UISprite").spriteName="tuoguan_select";
			this.userPlayerCtrl:tuoGuanChangeColor(true);
			this.userPlayerCtrl:ClearFanshu(false);
			if this.chitishi_1.activeSelf then
				this.chitishi_1:SetActive(false);
			end
			if this.chitishi_2.activeSelf then
				this.chitishi_2:SetActive(false);
			end
			if this.chitishi_3.activeSelf then
				this.chitishi_3:SetActive(false);
			end
			if this.btnCancelButton.activeSelf then
				this.btnCancelButton:SetActive(false);
			end
			this:HideTanKuang();
			
			--for i=1,#(this.buttonShowParent) do
				--this.buttonShowParent[i]:SetActive(false);
			--end
			--this.buttonShowParent={};
			
			--this.yinying:GetComponent("Animator").enabled=false;
			--this.yinying.transform.localScale=Vector3.zero;
			
		else
			if islate then
				this.AlreadyTing=true;
				this.userPlayerCtrl.tingpai.gameObject:SetActive(true);
			else
				isOwnTingpai=true;
				chupaiTing=true;

				--this.music.clip=this.bg_tingmusic;
				--this.music:Play();
			end
		end
	else
		if zhuangtai==2 then
			if islate then
				local ctrl=this:getPlayerCtrl(_nnPlayerName..uid);
				ctrl.tingpai.gameObject:SetActive(true);
			else
				isOtherTingpai=true;
				otherzhuangtai=zhuangtai;
			end
		end
	end
	this:HuiDiaoFunction();
end


function this:ProcessLaoyue(message)

end

function this:ProcessLaoyue_1(message)

end

function this:ProcessStartChupai(message)
	canReady=false;
	local body=message["body"];
	local uid=tostring(body);
	canTuoGuan=true;
	this.btnTuoguan:GetComponent("BoxCollider").enabled=true;
	this:HuiDiaoFunction();
end

--倒计时的递减和替换以及方位图标的替换显示
function this:nextFollow(uid)
	coroutine.wait(0.3);
	this.NNCount.gameObject:SetActive(true);
	this.NNCount:UpdateHUD(gametime);
	if tostring(uid)==EginUser.Instance.uid then
		this.playingIsOwn=true;
		this.time_jiantou.transform.eulerAngles=Vector3.New(0,0,179.9);
		iTween.RotateTo(this.time_jiantou,this.mono:iTweenHashLua("rotation",Vector3.New(0,0,0),"time",0.2,"easeType",iTween.EaseType.linear));
	else
		this.playingIsOwn=false;
		iTween.RotateTo(this.time_jiantou,this.mono:iTweenHashLua("rotation",Vector3.New(0,0,-179.9),"time",0.2,"easeType",iTween.EaseType.linear));
	end
end

function this:UserTuoguan(target)
	if target==this.btnTuoguan then
		--log("点击按钮进行托管");
		if canTuoGuan then
			this.btnCancelTuoGuanPanent:SetActive(true);
			this.btnTuoguan.transform:FindChild("Background"):GetComponent("UISprite").spriteName="tuoguan_select";
			local sendData={type="mj7",tag="t",body=1};
			this.mono:SendPackage(cjson.encode(sendData));
			this.btnTuoguan:GetComponent("BoxCollider").enabled=false;
			this.btnCancelTuoGuan:GetComponent("BoxCollider").enabled=true;
			this:HideTanKuang();
		end
	else
		--log("点击取消按钮取消托管");
		--log(this.canCancelTuoguan.."可以取消托管");
		if this.canCancelTuoguan then
			this.btnCancelTuoGuanPanent:SetActive(false);
			this.btnTuoguan.transform:FindChild("Background"):GetComponent("UISprite").spriteName="tuoguan";
			local sendData={type="mj7",tag="t",body=0};
			this.mono:SendPackage(cjson.encode(sendData));
			this.btnTuoguan:GetComponent("BoxCollider").enabled=true;
			this.btnCancelTuoGuan:GetComponent("BoxCollider").enabled=false;
		end
	
	end
end

function this:ProcessEnd(messageObj)
	if this.talk.activeSelf then
		this.talk:SetActive(false);
	end
	this.timeParent:SetActive(false);
	this.btnCancelTuoGuanPanent:SetActive(false);
	this.shengyupai_parent:SetActive(false);
	this.paicount=64;
	this.shengyucount.text=tostring(this.paicount);
	
	local body=messageObj["body"];
	local message=body[1];
	local infos=body[2];
	
	local otherCtrl=this:getPlayerCtrl(_nnPlayerName..this.otherUid);
	otherCtrl.chiLinShiTarget:SetActive(false);
	if #(message)<3 then
		this.liujuParent:GetComponent("Animator").enabled=true;
		this.liujuParent:SetActive(true);
		this.liujuParent:GetComponent("Animator"):CrossFade("liuju",0);
		coroutine.wait(4);
		if this.liujuParent.activeSelf then
			this.liujuParent:SetActive(false);
		end
		isGameOver=true;
		this.timeParent:SetActive(false);
		this.userPlayerCtrl:ClearAllPrefab(true);
		if otherCtrl then
			otherCtrl:ClearAllPrefab(false);
		end
		if isGameOver then
			this.music.clip=this.bg_music;
			this.music:Play();
		end
		this.btnBegin:SetActive(true);	
	else
		local winuid=tonumber(message[1]);

		local tianhu=false;
		local fanshuzongji=message[5];
		for i=1,#(fanshuzongji) do
			--log(tonumber(fanshuzongji[i][1]));
			if tonumber(fanshuzongji[i][1])==1  then
				tianhu=true;
				break;
			end
		end
		if tianhu then
			this.tianhuAnima.enabled=true;
			this.tianhuAnima:CrossFade("tianhu",0);
		else
			this.hu.enabled=true;
			this.hu:CrossFade("hu_effect",0);
		end
		--log("是否天胡");
		--log(tianhu);

		for key,value in pairs(infos) do
			local uid=tostring(value[1]);
			local cards=value[2];
			local score=tonumber(value[3]);
			if uid~=EginUser.Instance.uid then
				local ctrl=this:getPlayerCtrl(_nnPlayerName..uid);
				ctrl:setJiesuan(message,score,false,cards,isOtherMoPai,isbanker);
			end
		end
		
		for key,value in pairs(infos) do 
			local uid=tonumber(value[1]);
			local score=tonumber(value[3]);
			local ctrl=this:getPlayerCtrl(_nnPlayerName..uid);
			if ctrl then
				ctrl:HideBiaoji();
			end
			if ctrl then
				if tostring(uid)==EginUser.Instance.uid then
					if winuid==uid then
						--log("是否我摸牌");
						--log(isOwnMoPai);
						if tianhu then
							ctrl.trueTianhu=true;
						else
							ctrl.trueTianhu=false;
						end
						if isOwnMoPai then
							--log("我自摸");
							coroutine.start(ctrl.PlayAnima,ctrl,false,0,false,false,true);
						else
							--log("我胡牌");
							coroutine.start(ctrl.PlayAnima,ctrl,true,4,false,false,false);
						end
					end
					coroutine.wait(2.5);
					local cards=value[2];
					--log(score.."结算自己");
					ctrl:setJiesuan(message,score,true,cards,isOwnMoPai,isbanker);
					this.music:Stop();
					if winuid==uid then
						UISoundManager.Instance.PlaySound("win");
					end
				else
					if winuid==uid then
						--log("是否别人摸牌");
						if tianhu then
							ctrl.trueTianhu=true;
						else
							ctrl.trueTianhu=false;
						end
						if isOtherMoPai then
							--log("别人自摸");
							coroutine.start(ctrl.PlayAnima,ctrl,false,0,false,false,true);
						else
							--log("别人胡牌");
							coroutine.start(ctrl.PlayAnima,ctrl,true,4,false,false,false);
						end
					end
					if winuid~=uid then
						isOtherMoPai=false;
					end
					coroutine.wait(0.5);
					local cards=value[2];
					--log(score.."结算别人");
					--ctrl:setJiesuan(message,score,false,cards,isOtherMoPai,isbanker);
					UISoundManager.Instance.PlaySound("lose");
				end
			end
		
		end
	end
	this.timeParent:SetActive(false);
	
	coroutine.start(this.AfterDoing,this,4,function()
		ownmopaicount=0;
		this.chupaiOwnCount=0;
		chupaiOtherCount=0;
		startmopai=0;
		canTuoGuan=false;
		this.CanTingpai=false;
		canReady=true;
		this.AlreadyTing=false;
		this.istuoguan=false;
		this.btnCancelTuoGuanPanent:SetActive(false);
		this.canCancelTuoguan=false;
		this.btnTuoguan.transform:FindChild("Background"):GetComponent("UISprite").spriteName="tuoguan";
		singtingpai=false;
		this.outAllPai={};
		if _late then
			this.userPlayerCtrl:HideLateShoulipai(true);
			if otherCtrl then
				otherCtrl:HideLateShoulipai(false);
			end
			_late=false;
		end	
	end)
	
	coroutine.wait(7);
	--log("是否继续");
	--log(isContinue);
	if not isContinue then
		--log("退出");
		coroutine.start(this.ProcessNotcontinue,this);
	end
	
	_isPlaying=false;
end


function this:ProcessDeskOver(message)
	this:HuiDiaoFunction();
end

function this:ProcessUpdateAllIntomoney(message)
	local msgStr=cjson.encode(message);
	if string.find(msgStr,EginUser.Instance.uid)==nil then
		return;
	end
	
	local infos=message["body"];
	for key,value in ipairs(infos) do
		local uid=tostring(value[1]);
		local intoMoney=tostring(value[2]);
		local player=find(_nnPlayerName..uid);
		if player~=nil then
			this:getPlayerCtrl(player.name):UpdateIntoMoney(intoMoney);
		end
	
	end
end

function this:ProcessUpdateIntoMoney(message)
	local intoMoney=tostring(message["body"]);
	local info=GameObject.Find("Panel_info");
	if info~=nil then
		info:GetComponent("FootInfo"):UpdateIntoMoney(intoMoney);
	end

end

function this:ProcessCome(message)
	local body=message["body"];
	local memberinfo=body["memberinfo"];
	this:AddPlayer(memberinfo);
end

function this:ProcessLeave(message)
	local body=message["body"];
	local uid=tostring(body);
	if uid~=EginUser.Instance.uid then
		local player=find(_nnPlayerName..uid);
		this:removePlayerCtrl(player.name);
		if tableContains(_playingPlayerList,player) then
			iTableRemove(_playingPlayerList,player);
		end
		destroy(player);
	end
	this:HuiDiaoFunction();
end

function this:UserLeave()
	local sendData={type="game",tag="leave",body=EginUser.Instance.uid};
	this.mono:SendPackage(cjson.encode(sendData));
end

function this:UserQuit()
	SocketConnectInfo.Instance.roomFixseat=true;
	local sendData={type="game",tag="quit"};
	this.mono:SendPackage(cjson.encode(sendData));
	this.mono:OnClickBack();
end

function this:OnClickBack()
	if not _isPlaying then
		this:UserQuit();
	else
		this.msgQuit:SetActive(true);
	end
end

function this:ProcessNotcontinue()
	coroutine.wait(1);
	this.msgNotContinue:SetActive(true);
	coroutine.wait(3);
	this:UserQuit();
end

function this:ShowPromptHUD(errorInfo)
	this.btnBegin:SetActive(false);
	this.msgAccountFailed:SetActive(true);
	this.msgAccountFailed:GetComponentInChildren(Type.GetType("UILabel",true)).text=errorInfo;
end

function this:MoveTarget(gObj,x,y,timeC,delay)
	iTween.MoveTo(gObj,iTween.Hash("position",Vector3.New(x,y,0),"time",timeC,"delay",delay,"islocal",true,"easeType",iTween.EaseType.linear));

end

function this:AfterDoing(offset,run,obj)
	coroutine.wait(offset);
	if this.gameObject==nil then
		return;
	end
	run(this,obj);
end

function this:OnButtonClick(target)
	--log(target.gameObject.name.."点击的麻将牌的名称");
	if target==selectcaozuo[1] or target==selectcaozuo[2] or target==selectcaozuo[3] or target==selectcaozuo[6] then
		local liebiao={};
		if target==selectcaozuo[1] then--胡牌
			--log("点击胡牌按钮");
			table.insert(liebiao,1);
		elseif target==selectcaozuo[2] or target==selectcaozuo[3] then--杠牌  碰牌
			local cardcount=0;
			local liebiaonei={};
			if target==selectcaozuo[2] then
				--log("点击杠牌按钮");
				table.insert(liebiao,2);
				cardcount=gangpaicardcount;
			elseif target==selectcaozuo[3] then
				--log("点击碰牌按钮");
				table.insert(liebiao,3);
				local otherCtrl=this:getPlayerCtrl(_nnPlayerName..this.otherUid);
				local geshu=#(otherCtrl.OtherSidePais[1]);
				cardcount=otherCtrl:getMahjong(otherCtrl.OtherSidePais[1][geshu].name).paiid;
			end
			table.insert(liebiao,liebiaonei);
		elseif target==selectcaozuo[6] then--过牌
			--log("点击弃牌按钮");
			local liebiaonei={"[]"};
			table.insert(liebiao,0);
			table.insert(liebiao,liebiaonei);
			if isCGP then
				isCGP=false;
			end
			if singtingpai then
				singtingpai=false;
			end
			this.userPlayerCtrl:JinZhiShouLiPai(true);
			this.userPlayerCtrl.isCPTing=false;
		end
		local sendData={type="mj7",tag="f",body=liebiao};
		this.mono:SendPackage(cjson.encode(sendData));
		
		--this.yinying:GetComponent("Animator").enabled=true;
		--this.yinying:GetComponent("Animator"):CrossFade("CGPbgChange",0);
		this:HideTanKuang();
		--this.buttonShowParent={};
		--for i=1,#(selectcaozuo) do
			--selectcaozuo[i]:SetActive(false);
		--end
		this.userPlayerCtrl:ClearFanshu(false);
	elseif target==selectcaozuo[4] then--吃牌
		--log("点击吃牌按钮");
		if #(cgpList)>6 then
			if cgpList[7]~=nil then
				local count=#(cgpList[7]);
				chi_count=count;
				this.yinying:GetComponent("Animator").enabled=true;
				this.yinying:GetComponent("Animator"):CrossFade("CGPbgChange",0);
				if count==1 then
					local liebiaonei={};
					for i=1,#(cgpList[7][1]) do 
						table.insert(liebiaonei,tonumber(cgpList[7][1][i]));
					end
					
					local liebiao={};
					table.insert(liebiao,4);
					table.insert(liebiao,liebiaonei);
					local sendData={type="mj7",tag="f",body=liebiao};
					this.mono:SendPackage(cjson.encode(sendData));
					--this.buttonShowParent={};
					--for i=1,#(selectcaozuo) do
						--selectcaozuo[i]:SetActive(false);
					--end
					this:HideTanKuang();
				elseif count==2 then
					local paixulist_1={};
					local paixulist_2={};
					for i=1,#(cgpList[7][1]) do
						table.insert(paixulist_1,tonumber(cgpList[7][1][i]));						
					end
					for i=1,#(cgpList[7][2]) do
						table.insert(paixulist_2,tonumber(cgpList[7][2][i]));
					end
					table.insert(paixulist_1,otherChuPaiValue);
					table.insert(paixulist_2,otherChuPaiValue);
					this:paixu(paixulist_1);
					this:paixu(paixulist_2);
					this.chitishi_1.transform.localPosition=Vector3.New(112,this.chitishi_2.transform.localPosition.y,0);
					this.chitishi_2.transform.localPosition=Vector3.New(-112,this.chitishi_1.transform.localPosition.y,0);
					
					this.chitishi_1:SetActive(true);
					this.chitishi_2:SetActive(true);
					for i=1,#(paixulist_1) do
						this.chitishi_1.transform:FindChild("Sprite_"..i.."/Sprite"):GetComponent("UISprite").spriteName="Mahjong_"..paixulist_1[i];
					end
					for i=1,#(paixulist_2) do
						this.chitishi_2.transform:FindChild("Sprite_"..i.."/Sprite"):GetComponent("UISprite").spriteName="Mahjong_"..paixulist_2[i];
					end
					
					this.btnCancelButton:SetActive(true);
				elseif count==3 then
					local paixulist_1={};
					local paixulist_2={};
					local paixulist_3={};
					for i=1,#(cgpList[7][1]) do
						table.insert(paixulist_1,tonumber(cgpList[7][1][i]));						
					end
					for i=1,#(cgpList[7][2]) do
						table.insert(paixulist_2,tonumber(cgpList[7][2][i]));
					end
					for i=1,#(cgpList[7][3]) do
						table.insert(paixulist_3,tonumber(cgpList[7][3][i]));
					end
					table.insert(paixulist_1,otherChuPaiValue);
					table.insert(paixulist_2,otherChuPaiValue);
					table.insert(paixulist_3,otherChuPaiValue);
					this:paixu(paixulist_1);
					this:paixu(paixulist_2);
					this:paixu(paixulist_3);
					this.chitishi_3.transform.localPosition=Vector3.New(-224,this.chitishi_1.transform.localPosition.y,0);
					this.chitishi_2.transform.localPosition=Vector3.New(0,this.chitishi_2.transform.localPosition.y,0);
					this.chitishi_1.transform.localPosition=Vector3.New(224,this.chitishi_3.transform.localPosition.y,0);				
					this.chitishi_1:SetActive(true);
					this.chitishi_2:SetActive(true);
					this.chitishi_3:SetActive(true);
					for i=1,#(paixulist_1) do
						this.chitishi_1.transform:FindChild("Sprite_"..i.."/Sprite"):GetComponent("UISprite").spriteName="Mahjong_"..paixulist_1[i];
					end
					for i=1,#(paixulist_2) do
						this.chitishi_2.transform:FindChild("Sprite_"..i.."/Sprite"):GetComponent("UISprite").spriteName="Mahjong_"..paixulist_2[i];
					end
					for i=1,#(paixulist_3) do
						this.chitishi_3.transform:FindChild("Sprite_"..i.."/Sprite"):GetComponent("UISprite").spriteName="Mahjong_"..paixulist_3[i];
					end
					this.btnCancelButton:SetActive(true);
				end
			end
		end
	elseif target==this.chitishi_1 or target==this.chitishi_2 or target==this.chitishi_3 then
		local liebiaonei={};
		if target==this.chitishi_1 then
			for i=1,#(cgpList[7][1]) do
				table.insert(liebiaonei,tonumber(cgpList[7][1][i]));
			end
		elseif target==this.chitishi_2 then
			for i=1,#(cgpList[7][2]) do
				table.insert(liebiaonei,tonumber(cgpList[7][2][i]));
			end
		elseif target==this.chitishi_3 then
			for i=1,#(cgpList[7][3]) do
				table.insert(liebiaonei,tonumber(cgpList[7][3][i]));
			end
		end
		this:HideTanKuang();
		--this.buttonShowParent={};
		--for i=1,#(selectcaozuo) do
			--selectcaozuo[i]:SetActive(false);
		--end
		
		local liebiao={};
		table.insert(liebiao,4);
		table.insert(liebiao,liebiaonei);
		local sendData={type="mj7",tag="f",body=liebiao};
		this.mono:SendPackage(cjson.encode(sendData));
		this.chitishi_1:SetActive(false);
		this.chitishi_2:SetActive(false);
		this.chitishi_3:SetActive(false);
		this.btnCancelButton:SetActive(false);
	elseif target==selectcaozuo[5] then--听牌
		--log("点击听牌按钮");
		this.userPlayerCtrl:HuanYuanTingpaiMessage();
		this.isOwnChuPai=true;
		this.CanTingpai=true;
		if #(cgpList)>7 and not singtingpai then
			if tostring(cgpList[8][1])~="nil" then
				local tingpaiList=cgpList[8];
				this.userPlayerCtrl:setTingPai(tingpaiList);
			end
		end
		if singtingpai then
			this.userPlayerCtrl:setTingPai(singtingpailist);
		end
		this.yinying:GetComponent("Animator").enabled=true;
		this.yinying:GetComponent("Animator"):CrossFade("CGPbgChange",0);
		this.btnCancelButton:SetActive(true);
 	end

end

function this:HuanYuanCaoZuo()
	this.btnCancelButton:SetActive(false);
	this.chitishi_1:SetActive(false);
	this.chitishi_2:SetActive(false);
	this.chitishi_3:SetActive(false);
	this.userPlayerCtrl.isCPTing=false;
	this.userPlayerCtrl:HuanYuanTingpaiMessage();
	this.userPlayerCtrl:ClearFanshu(false);
	this.CanTingpai=false;
	this.isOwnChuPai=true;
	
	
	if #(this.buttonShowParent)==2 then
		this:CGPbuttonPositionChange(65,380,-185);
	elseif #(this.buttonShowParent)==3 then
		this:CGPbuttonPositionChange(130,510,-250);
	elseif #(this.buttonShowParent)==4 then
		this:CGPbuttonPositionChange(195,640,-315);
	elseif #(this.buttonShowParent)==5 then
		this:CGPbuttonPositionChange(260,770,-380);
	end
end

--轮到者可做操作，如【胡，杠，碰，吃，听】
--0代表不可操作，1代表可操作
--zhuangtai长度为5
function this:thisState(zhuangtai)
	cgpList=zhuangtai;
	for i=1,#(selectcaozuo) do
		selectcaozuo[i]:SetActive(false);
	end
	--log("可以操作的弹框数量11111111111111");
	--log(#(this.buttonShowParent));
	if zhuangtai~=nil and #(zhuangtai)>0 then
		table.insert(this.buttonShowParent,selectcaozuo[6]);
		local count=0;
		for i=1,5 do
			if tonumber(zhuangtai[i])>0 then
				count=count+1;
				table.insert(this.buttonShowParent,selectcaozuo[i]);
			end
		end
	end
	--log("可以操作的弹框数量222222222222222");
	--log(#(this.buttonShowParent));
	if #(this.buttonShowParent)==2 then
		this:CGPbuttonPositionChange(65,380,-185);
	elseif #(this.buttonShowParent)==3 then
		this:CGPbuttonPositionChange(130,510,-250);
	elseif #(this.buttonShowParent)==4 then
		this:CGPbuttonPositionChange(195,640,-315);
	elseif #(this.buttonShowParent)==5 then
		this:CGPbuttonPositionChange(260,770,-380);
	end
end

function this:CGPbuttonPositionChange(buttonPosition_X,yinying_width,yinying_pos)
	this.yinying:GetComponent("Animator").enabled=false;
	local count=-1;
	for i=1,#(this.buttonShowParent) do
		count=count+1;
		this.buttonShowParent[i].transform.localPosition=Vector3.New(buttonPosition_X-count*130,0,0);
		this.buttonShowParent[i].transform.localScale=Vector3.New(0.1,0.1,0.1);
	end
	this.yinying.width=yinying_width;
	this.yinying.transform.localPosition=Vector3.New(yinying_pos,0,0);
	
	this.yinying.transform.localScale=Vector3.one;
	for i=1,#(this.buttonShowParent) do
		this.buttonShowParent[i]:SetActive(true);
		iTween.ScaleTo(this.buttonShowParent[i],iTween.Hash("scale",Vector3.one,"time",0.4,"easeType",iTween.EaseType.linear));
	end
end

function this:SingleTing()
	table.insert(this.buttonShowParent,selectcaozuo[6]);
	table.insert(this.buttonShowParent,selectcaozuo[5]);
	--log(#(this.buttonShowParent).."========数量");
	this:CGPbuttonPositionChange(65,380,-165);
end
--[[
function this:partition(list,low,high)
	local low=low;
	local high=high;
	local pivotKey=list[low];
	
	while low<high do
		while low<high and list[high]>=pivotKey do
			high=high-1;
		end
		swap(list,low,high);
		while low<high and list[low]<=pivotKey do 
			low=low+1;
		end
		swap(list,low,high);
	end
	return low;
end

function this:paixupaixu(list,low,high)
	if low<high then
		local pivotKeyIndex=this:partition(list,low,high);
		this:paixu(list,low,pivotKeyIndex-1);
		this:paixu(list,pivotKeyIndex+1,high);
	end
end
]]
function this:paixu(list)
	for i=1,#(list)-1 do
		local temp=0;
		for j=1,#(list)-1 do 
			if list[j]>list[j+1] then
				temp=list[j];
				list[j]=list[j+1];
				list[j+1]=temp;
			end
		end
	end
	--for i=1,#(list) do
		--log(list[i]);
	--end
end




function this:PlayMusic()
	this.music.clip=this.bg_music;
	this.music.volume=this.sliderBgVolume.value;
	this.music:Play();
end

function this:ProcessEmotion(message)
	endTime=Time.time;
	local body=message["body"];
	local id=tonumber(body[1]);
	local number=tonumber(body[2]);
	local ctrl=this:getPlayerCtrl(_nnPlayerName..id);
	ctrl:setEmotion(number);
end

function this:OnSetBiaoQing(target)
	firstTime=Time.time;
	if firstTime-endTime<jiangeTime then
		this.message_error:SetActive(true);
		this.message_error.transform:FindChild("Label"):GetComponent("UILabel").text=XMLResource.Instance:Str("message_error_5");																				 
		coroutine.start(this.AfterDoing,this,1.5,function()
			this.message_error:SetActive(false);
		end)
	else
		local index=0;
		for i=1,27 do
			local smile=this.biaoqingParent.transform:FindChild("biaoqing_"..i);
			if target==smile.gameObject then
				index=i;
				break;
			end
		end
		local sendData={type="game",tag="emotion",body=index};
		this.mono:SendPackage(cjson.encode(sendData));
	end
	NGUITools.SetActive(this.talk.gameObject,false);
	if not this.talk.activeSelf then
		NGUITools.SetActive(this.biaoqingPanel,true);
		NGUITools.SetActive(this.languagePanel,false);
	end
end

function this:ProcessHurry(message)
	languageEndTime=Time.time;
	local body=message["body"];
	local spokesman=tonumber(body["spokesman"]);
	local index=tonumber(body["index"]);
	--log(index.."语音");
	local ctrl=this:getPlayerCtrl(_nnPlayerName..spokesman);
	ctrl:setMessage(index);
end

function this:OnSendLanguage(target)
	languagefirstTime=Time.time;
	if languagefirstTime-languageEndTime<jiangeTime then
		this.message_error:SetActive(true);
		this.message_error.transform:FindChild("Label"):GetComponent("UILabel").text=XMLResource.Instance:Str("message_error_5");
		coroutine.start(this.AfterDoing,this,1.5,function()
			this.message_error:SetActive(false);
		end)
	else
		for i=1,8 do
			if target==this.changyongyu.transform:FindChild("label_"..i).gameObject then
				language_index=i;
				break;
			end
		end
		
		local messageBody={};
		messageBody['hurry_index'] = language_index;
		local sendData={type="game",tag="hurry",body=messageBody};
		this.mono:SendPackage(cjson.encode(sendData));
	end
	
	this.talk:SetActive(false);
	if not this.talk.activeSelf then
		NGUITools.SetActive(this.biaoqingPanel,true);
		NGUITools.SetActive(this.languagePanel,false);
		this.button_biaoqing.spriteName="biaoqing_select";
		this.button_language.spriteName="talk";
	end

end

function this:TalkClick(target)
	if target==this.button_biaoqing.gameObject then
		this.biaoqingPanel:SetActive(true);
		this.languagePanel:SetActive(false);
		this.button_biaoqing.spriteName="biaoqing_select";
		this.button_language.spriteName="talk";
	elseif target==this.button_language.gameObject then
		this.biaoqingPanel:SetActive(false);
		this.languagePanel:SetActive(true);
		this.button_biaoqing.spriteName="biaoqing";
		this.button_language.spriteName="talk_select";
	elseif target==this.button_talk then
		this.talk:SetActive(true);
		this.biaoqingPanel:SetActive(true);
		this.languagePanel:SetActive(false);
		this.button_biaoqing.spriteName="biaoqing_select";
		this.button_language.spriteName="talk";
	end

end

function this:paiXuID(paiId)
	if paiId>30 then
		paixuId=paiId-30;
	end
	if paiId>20 and paiId<30 then
		paixuId=paiId-10;
	end
	if paiId>10 and paiId<20 then
		paixuId=paiId+10;
	end
	if paiId>0 and paiId<10 then
		paixuId=paiId+30;
	end
	return paixuId;
end

function this:HuiDiaoFunction()
	coroutine.start(this.HuiDiaoFunction_1,this);
end

function this:HuiDiaoFunction_1()
	coroutine.wait(0.5);
	this.AnimatorPlayEnd=true;
	coroutine.start(this.ChiXuJieXiaoXi,this);
end

function this.ShexianSend(mahjongNameObj)
	--log(mahjongNameObj.name.."===========111111111111");
	this.userPlayerCtrl:SelectMahjong(mahjongNameObj);
end


function this:UpdateInLua()
	while(this.mono) do
		for k,v in pairs(playerCtrlDc) do
			if(v == nil)then
				print("?????")
			else
				v:UpdateInLua()
			end
		end
		if this.NNCount~=nil then
			this.NNCount:Update();
		end
		coroutine.wait(0.01)
	end
end

function this:OnDestroy()
	log("--------------------ondestroy of GameKSQZMJ")
end
