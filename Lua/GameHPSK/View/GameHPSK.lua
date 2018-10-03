require "GameHPSK/HPSKPlayerCtrl"
require "GameHPSK/HPSKPlayer"
require "GameHPSK/HPSKCardRule"


 
local cjson = require "cjson"

local this = LuaObject:New()
GameHPSK = this
local _nnPlayerName = "NNPlayer_"		--动态生成的玩家实例名字的前缀	
local _userIndex = 0					--玩家的位置
local _isPlaying = false			
local _late = false
local _reEnter = false
local keynum = 0;
local firstTime=0;
local endTime=-10;
local jiangeTime=10;
local languagefirstTime=0;
local languageEndTime = -10;
local language_index = -1;

local autoOutCard="";
local systemOutCard="";

function this:clearLuaValue()
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	this.tbwzPlayerPrefab = nil		--GameObject同桌其他玩家的预设
	this.UserPlayerCtrl =nil			--TBWZPlayerCtrl游戏玩家的控制脚本
	this.userPlayerObj = nil			--GameObject

	this.game_bg=nil;
	this.btnBegin = nil				--GameObject

	this.msgQuit = nil				--GameObject
	this.msgAccountFailed = nil		--GameObject
	this.msgNotContinue =nil			--GameObject
	
	this.biaoqing_shelet=false;
	this.yuyin_shelet=false;
	this.biaoqingBgShow=false;
	this.tuoguanBgShow=false;
	this.autoOutCardList={};
	--音效
	this.tishiArray={};
	
	this._playingPlayerList = nil			--List<GameObject>游戏开始时正在游戏的玩家
	this._waitPlayerList = nil				--List<GameObject>游戏开始时等待的玩家
	this._readyPlayerList = nil			--List<GameObject>正常进入游戏时已经准备的玩家(wait=true ready=true)，需要在游戏开始时加入_playingPlayerList，并清空
	this.soundCount = nil
	self.isStart = false;
	this._currTime = 0;
	this._num = 20;
	this._numMax = 0;
	this.tishiCount=0;
	this.jiesuan_btn_back=nil;
	this.jiesuan_btn_continue=nil;
	this.language_panel=nil;
	this.sliderEffectVolume = nil;
	
	this.upPlayer=nil;
	this.NowState=false;
	this._tbwzPlayerCtrl = nil
	this:RemoveAllTbwzPlayerCtrl();
	coroutine.Stop()
	LuaGC();
end
function this:Init()
	--初始化变量
	_userIndex = 0		
	_isPlaying = false			
	_late = false
	_reEnter = false
	autoOutCard="";
	systemOutCard="";
	this.autoOutCardList={};
	--GameObject同桌其他玩家 
	this.tbwzPlayerPrefab = this.transform:FindChild("Content/TBNNPlayer").gameObject

	this.game_bg=this.transform:FindChild("Panel_background/Sprite6_desk").gameObject;--背景界面
	this.UserPlayerCtrl =0			--TBWZPlayerCtrl游戏玩家的控制脚本
	this.userPlayerObj = this.transform:FindChild("Content/User").gameObject			--GameObject
	--初始化NNCountLua 
	this.NNCount = this.transform:FindChild("Content/NNCount").gameObject:GetComponent("UISprite")	
	this.NNCountNum = this.transform:FindChild("Content/NNCount/NNCountNum").gameObject:GetComponent("UILabel")	
	this.btnBegin = this.transform:FindChild("Content/User/Button_begin").gameObject				--GameObject
	this.setting= this.transform:FindChild("GameSettingManager/Sprite_popup_container").gameObject;--设置界面
	
	this.tuoguanState=this.userPlayerObj.transform:FindChild("Output/tuoguanState").gameObject;
	this.ButtonTuoguan=this.transform:FindChild("ButtonPanel/Button_tuoguan").gameObject;--托管按钮
	this.ButtonBiaoqing=this.transform:FindChild("ButtonPanel/Button_biaoqing").gameObject;--表情按钮
	this.ButtonYuyin=this.transform:FindChild("ButtonPanel/Button_yuyin").gameObject;--语音按钮
	this.biaoqing_panel=this.transform:FindChild("ButtonPanel/talk/biaoqing_panel").gameObject;--表情语音父物体
	this.biaoqingPanel=this.biaoqing_panel.transform:FindChild("smile_biaoqing").gameObject;
	this.biaoqingParent=this.biaoqingPanel.transform:FindChild("UIGrid").gameObject;
	this.talk_panel=this.transform:FindChild("ButtonPanel/talk/yuyin_panel").gameObject;--表情语音父物体
	this.languagePanel=this.talk_panel.transform:FindChild("changyongyu").gameObject;
	this.changyongyu=this.languagePanel.transform:FindChild("UIGrid").gameObject;
	this.biaoqing_shelet=this.biaoqing_panel.transform:FindChild("shelet").gameObject;
	this.yuyin_shelet=this.talk_panel.transform:FindChild("shelet").gameObject;
	
	this.language_panel=nil;
	
	this.biaoqingBgShow=false;
	this.tuoguanBgShow=false;

	this.msgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject				--GameObject
	this.msgAccountFailed = this.transform:FindChild("Content/MsgContainer/MsgAccountFailed").gameObject		--GameObject
	this.msgNotContinue = this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject			--GameObject
	this.message_error=this.transform:FindChild("Content/MsgContainer/MsgError").gameObject;
	
	this.caozuoPanel=this.transform:FindChild("caozuoPanel").gameObject;--出牌操作按钮显示
	this.buchuBtn=this.caozuoPanel.transform:FindChild("Button_buchu/Background").gameObject:GetComponent("UISprite");
	this.tishiBtn=this.caozuoPanel.transform:FindChild("Button_tishi/Background").gameObject:GetComponent("UISprite");
	this.chupaiBtn=this.caozuoPanel.transform:FindChild("Button_chupai/Background").gameObject:GetComponent("UISprite");
	this.ButtonBuChu=this.caozuoPanel.transform:FindChild("Button_buchu").gameObject;--不出按钮
	this.ButtonTiShi=this.caozuoPanel.transform:FindChild("Button_tishi").gameObject;--提示按钮
	this.ButtonChuPai=this.caozuoPanel.transform:FindChild("Button_chupai").gameObject;--出牌按钮
	this.outCardParent=this.transform:FindChild("Content/outCardParent");
	
	this.jiesuanMessage=this.transform:FindChild("jiesuan").gameObject;--结算父物体
	this.win_message=this.jiesuanMessage.transform:FindChild("win_message").gameObject;--胜利消息父物体
	this.jiesuan_1=this.jiesuanMessage.transform:FindChild("jiesuan_1").gameObject;
	this.jiesuan_2=this.jiesuanMessage.transform:FindChild("jiesuan_2").gameObject;
	
	this.jiesuan_btn_back=this.jiesuanMessage.transform:FindChild("back").gameObject;
	this.jiesuan_btn_continue=this.jiesuanMessage.transform:FindChild("continue").gameObject;
	
	this.NowState=false;
	this.tishiArray={};
	
	--音效
	this.soundCount = ResManager:LoadAsset("gamenn/Sound","djs1") 
	this.but = ResManager:LoadAsset("gamehpsk/but","but") 
	
	self.isStart = false;
	this._currTime = 0;
	this._num = 20;
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
	
	
	this._playingPlayerList = {}			--List<GameObject>游戏开始时正在游戏的玩家
	this._waitPlayerList = {}				--List<GameObject>游戏开始时等待的玩家
	this._readyPlayerList = {}				--List<GameObject>正常进入游戏时已经准备的玩家(wait=true ready=true)，需要在游戏开始时加入_playingPlayerList，并清空
	this._tbwzPlayerCtrl = {}				--存放Lua对象

	this.upPlayer=nil;
	--LRDDZ_ResourceManager.Instance:CreatePanel('Player','Player',true,function(obj)
			--end);
	this.tishiCount=0;
	
	this.sliderEffectVolume = this.transform:FindChild("GameSettingManager/Sprite_popup_container/Label_setting/Label_bgsound/Slider").gameObject:GetComponent("UISlider")
end
function this:Awake()
	log("------------------awake of GameTBWZ-------------")
	
	this:Init();
	
	----------绑定按钮事件--------
	--退出按钮
	local btn_back = this.transform:FindChild("Setting_btn/Button_back").gameObject
	this.mono:AddClick(btn_back, this.OnClickBack);
	--开始按钮
	this.mono:AddClick(this.btnBegin, this.UserReady);
	--确认退出按钮
	local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
	this.mono:AddClick(btn_MsgQuit, this.UserQuit);
	
	------------逻辑代码------------
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end
	this.transform.localPosition=Vector3.New(0,0,400);
	local footInfoPrb = ResManager:LoadAsset("gamehpsk/footinfoprb","FootInfoPrb")
	--local settingPrb = ResManager:LoadAsset("gametbwz/settingprb","SettingPrb")
	GameObject.Instantiate(footInfoPrb)
	--GameObject.Instantiate(settingPrb)
	 --ccc
	 --log("11111111是否开奖池")
	--log(PlatformGameDefine.playform.IsPool);
	if PlatformGameDefine.playform.IsPool then
		local jiangChiPrb = ResManager:LoadAsset("gamenn/JiangChiPrb","JiangChiPrb")
		GameObject.Instantiate(jiangChiPrb)
	end
	 
	
	local footInfo = GameObject.Find("FootInfo")
	local btn_AddMoney = footInfo.transform:FindChild("MsgAddMoney/Button_yes").gameObject
	this.mono:AddClick(btn_AddMoney, this.OnAddMoney); 
	this.mono:AddClick(footInfo.transform:FindChild("MsgAddMoney/Button_no").gameObject, this.PlayButEffect);
	this.mono:AddClick(footInfo.transform:FindChild("MsgAddMoney/Button_close").gameObject, this.PlayButEffect);
	this.mono:AddClick(footInfo.transform:FindChild("Foot - Anchor/Info/Money/AddMoney").gameObject, this.PlayButEffect);
	 
	 
	this.mono:AddClick(this.transform:FindChild("Setting_btn/Button_setting").gameObject, this.PlayButEffect);
	 this.mono:AddClick(this.transform:FindChild("Setting_btn").gameObject, this.PlayButEffect);
	 
	this.mono:AddClick(this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_no").gameObject, this.PlayButEffect);
	this.mono:AddClick(this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_close").gameObject, this.PlayButEffect);
	
	this.mono:AddClick(this.ButtonBuChu,this.OnButtonClick,this);
	this.mono:AddClick(this.ButtonTiShi,this.OnButtonClick,this);
	this.mono:AddClick(this.ButtonChuPai,this.OnButtonClick,this);
	this.mono:AddClick(this.ButtonTuoguan,this.OnButtonClick,this);
	this.mono:AddClick(this.ButtonBiaoqing,this.OnButtonClick,this);
	this.mono:AddClick(this.ButtonYuyin,this.OnButtonClick,this);
	this.mono:AddClick(this.biaoqing_shelet,this.OnButtonClick,this);
	this.mono:AddClick(this.yuyin_shelet,this.OnButtonClick,this);
	this.mono:AddClick(this.game_bg,this.OnButtonClick,this);
	
	
	this.mono:AddClick(this.jiesuan_btn_continue,this.UserContinue,this);
	this.mono:AddClick(this.jiesuan_btn_back,this.OnClickBack);
	
	

	
	for i=1,27 do
		this.mono:AddClick(this.biaoqingParent.transform:FindChild("biaoqing_"..i).gameObject,this.OnSetBiaoQing,this);
	end
	for i=1,9 do
		this.mono:AddClick(this.changyongyu.transform:FindChild("Man/label_"..i).gameObject,this.OnSendLanguage,this);
		this.mono:AddClick(this.changyongyu.transform:FindChild("Woman/label_"..i).gameObject,this.OnSendLanguage,this);
	end
	
	this.mono:AddSlider(this.sliderEffectVolume, this.SetEffectVolume);
	
	-----------初始化UISoundManager------------
	UISoundManager.Init(this.gameObject);

	--添加音效资源
	for i=1,9 do
		UISoundManager.AddAudioSource("gamehpsk/sounds","man_"..i);
		UISoundManager.AddAudioSource("gamehpsk/sounds","woman_"..i);
	end
	for i=0,12 do
		UISoundManager.AddAudioSource("gamehpsk/sounds","man_type_"..i);
		UISoundManager.AddAudioSource("gamehpsk/sounds","woman_type_"..i);
	end
	UISoundManager.AddAudioSource("gamehpsk/sounds","man_type_13");
	UISoundManager.AddAudioSource("gamehpsk/sounds","man_type_14");
	
	UISoundManager.AddAudioSource("gamehpsk/sounds","man_begin");
	UISoundManager.AddAudioSource("gamehpsk/sounds","man_fanning");
	UISoundManager.AddAudioSource("gamehpsk/sounds","man_onekou");
	UISoundManager.AddAudioSource("gamehpsk/sounds","man_pingkou");
	UISoundManager.AddAudioSource("gamehpsk/sounds","man_twokou");
	
	UISoundManager.AddAudioSource("gamehpsk/sounds","woman_begin");
	UISoundManager.AddAudioSource("gamehpsk/sounds","woman_fanning");
	UISoundManager.AddAudioSource("gamehpsk/sounds","woman_onekou");
	UISoundManager.AddAudioSource("gamehpsk/sounds","woman_pingkou");
	UISoundManager.AddAudioSource("gamehpsk/sounds","woman_twokou");
	
	UISoundManager.AddAudioSource("gamehpsk/sounds","fa");
	UISoundManager.AddAudioSource("gamehpsk/sounds","pass");
	UISoundManager.AddAudioSource("gamehpsk/sounds","play");
	UISoundManager.AddAudioSource("gamehpsk/sounds","zha");
	
	UISoundManager.Instance._EFVolume = this.sliderEffectVolume.value;
end
function this.PlayButEffect()
	EginTools.PlayEffect(this.but);
end
function this:Start()

	if SettingInfo.Instance.autoNext == true or SettingInfo.Instance.deposit == true then
		this.btnBegin:SetActive (false);  
	end
	
	local info = GameObject.Find ("GameSettingManager");
	
	if not IsNil(info) then
		GameSettingManager:setDepositVisible(true);
	end
	this.mono:StartGameSocket();
	
	coroutine.start(this.Update);
	 
	
end

function this:OnDisable()
	this:clearLuaValue()
	
end
--获取_tbwzPlayerCtrl对象
function this:GetTbwzPlayerCtrl(tbName,tbObj)
	
	local tbwzTemp = this._tbwzPlayerCtrl[tbName]
	if tbwzTemp == nil then
		
		if not IsNil(tbObj) then
			this._tbwzPlayerCtrl[tbName] = HPSKPlayerCtrl:New(tbObj);
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
	this.btnBegin:SetActive(false);
	this.msgAccountFailed:SetActive(true)
	this.msgAccountFailed:GetComponentInChildren(Type.GetType("UILabel",true)).text = errorInfo;
end

function this:SetEffectVolume()
	--SettingInfo.Instance.effectVolume = this.sliderEffectVolume.value;
	UISoundManager.Instance._EFVolume = this.sliderEffectVolume.value;
end

function this:OnDestroy()
	
	
end

function this:Update()
    while this._tbwzPlayerCtrl do
		for key,v in pairs(this._tbwzPlayerCtrl) do
			if v._alive then
				v:UpdateSelect();
			end
		end
		--HPSKPlayer.Update();
		this:TimeUpdate()
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
			this.NNCountNum.text = chazhiTime<10 and "0"..chazhiTime or tostring(chazhiTime); 
			
			
			if this._num <= 5   then
				if this._currTime == 1 then
					EginTools.PlayEffect(this.soundCount);	 
				end
				this._currTime = this._currTime -0.1
				if this._currTime < 0 then
					this._currTime = 1;
				end
			end 
			
			 this.NNCount.fillAmount = (this._num)/self._numMax;
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
	
	this.NNCount.gameObject:SetActive(true)
	
	 this.NNCount.fillAmount = 1;
	 
	local timerStr = this._num<10 and "0"..this._num or tostring(this._num);
	this.NNCountNum.text = timerStr;  
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
			log(Message);
			if tag=="enter" then
				this:ProcessEnter(messageObj);		
			elseif tag=="ready" then
				this:ProcessReady(messageObj);		
			elseif tag=="come" then
				this:ProcessCome(messageObj);		
			elseif tag=="leave" then
				this:ProcessLeave(messageObj);	
			elseif tag=="deskover" then
				this:ProcessDeskOver(messageObj);
			elseif tag=="notcontinue" then
				coroutine.start(this.ProcessNotcontinue,this);
			elseif tag=="newactfinish" then
				this:ProcessNewactfinish(messageObj);
			elseif tag=="manage" then
				--{"body": {"managed": true, "uid": 866627887}, "tag": "manage", "type": "game"}
				this:ProcessTuoGuan(messageObj);
			elseif tag=="emotion" then
				--log(msgStr);
				this:ProcessEmotion(messageObj);
			elseif tag=="hurry" then
				--log(msgStr);
				this:ProcessHurry(messageObj);
			end
		elseif typeC=="shuangkou" then
			log(Message);
			if tag=="time" then
				local t = messageObj["body"]
				this:UpdateHUD(t);
			elseif tag=="update" then
				this:ProcessLate(messageObj)
			elseif tag=="deal" then 
				coroutine.start(this.ProcessDeal,this,messageObj);
			elseif tag == "play" then
				print("-------------play------------");
				this:ProcessPlay(messageObj)
			elseif tag == "pass" then
				print("-------------pass------------");
				this:ProcessPass(messageObj)
			elseif tag == "gameover" then
				print("-------------gameover------------");
				coroutine.start(this.ProcessGameover,this,messageObj)
			elseif tag=="ok" then
				this:ProcessOk(messageObj);
			elseif tag=="end" then 
				coroutine.start(this.ProcessEnd,this,messageObj);
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
				if PlatformGameDefine.playform.IsPool then
				    --log("11111111111")
					local info = GameObject.Find("PoolInfo")
					local chiFen = messageObj["body"]["money"];
					local infos = messageObj ["body"]["msg"]
					if info then
						PoolInfo:show(chiFen,infos);
					end
				end
			elseif tag=="mypool" then
			--log("2222222222")
				if PlatformGameDefine.playform.IsPool then
					local info = GameObject.Find("PoolInfo")
					local chiFen = messageObj["body"];
					if info then
						PoolInfo:setMyPool(chiFen);
					end
				end
				
			elseif tag=="mylott" then
			--log("333333333333333")
				if PlatformGameDefine.playform.IsPool then
					local info = GameObject.Find("PoolInfo")
					if(messageObj["body"]["msg"] ~= nil)then
						local msg = messageObj["body"]["msg"]
					else
						local msg = messageObj["body"]
					end
					if info then
						PoolInfo:setMyPool(msg);
					end
				end
			end
		end
	else
		log("---------------Message=nil")
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
		
	for key,memberinfo in ipairs(memberinfos) do
		if memberinfo then
			if tostring(memberinfo["uid"])  == EginUser.Instance.uid then
				_userIndex = memberinfo["position"];
				local waiting = memberinfo["waiting"];
				local readying = memberinfo["ready"];
				keynum = tonumber(memberinfo["keynum"])
				
				if tonumber(memberinfo["avatar_no"])%2==1 then		
					this.UserPlayerCtrl.sex=1;
					this.changyongyu.transform:FindChild("Woman").gameObject:SetActive(true);
					this.language_panel=this.changyongyu.transform:FindChild("Woman").gameObject;
				else
					this.UserPlayerCtrl.sex=0;
					this.changyongyu.transform:FindChild("Man").gameObject:SetActive(true);
					this.language_panel=this.changyongyu.transform:FindChild("Man").gameObject;
				end
				Activity:SetCountBgLabel(keynum);
				if waiting then
					table.insert(this._waitPlayerList,this.userPlayerObj);
					if readying then
						table.insert(this._playingPlayerList,this.userPlayerObj)
					end
				else
					table.insert(this._playingPlayerList,this.userPlayerObj)
					_reEnter = true;
				end
				local height = this.userPlayerObj.transform.root:GetComponent("UIRoot").manualHeight;
				
				this:ReplaceNameTbwzPlayerCtrl(this.userPlayerObj.name,_nnPlayerName..EginUser.Instance.uid);				
				this.userPlayerObj.name = _nnPlayerName..EginUser.Instance.uid;
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
	
	local content = this.transform:FindChild("Content").gameObject
	local player = this.tbwzPlayerPrefab;
	player:SetActive(true);
	player.name = _nnPlayerName..uid;
	local ctrl = this:GetTbwzPlayerCtrl(player.name,player)
	ctrl:SetPlayerInfo(avatar_no,nickname,bag_money,level);
	
	if avatar_no%2==1 then
		ctrl.sex=1;
	else
		ctrl.sex=0;
	end
	if waiting then
		if ready then
			ctrl:SetReady(true)
			ctrl:SetWait(false)
			table.insert(this._readyPlayerList,player);	
		end
		table.insert(this._waitPlayerList,player);
	else
		table.insert(this._playingPlayerList,player);
	end
	
	return player;
end

--{"body": {"mycards": [49, 36, 23, 10, 38, 25, 12, 48, 35, 22, 9, 11, 45, 32, 19, 6, 45, 32, 34, 21, 8, 47, 34], "lastone": 110554,
-- "current_state": [{"hold_num": 23, "managed": false, "byerank": 0, "userid": 866627889, "lastput_type": 49, "lastput": [0, 13, 26, 52]},
-- {"hold_num": 11, "managed": false, "byerank": 0, "userid": 110554, "lastput_type": 59, "lastput": [0, 13, 26, 39, 39]}],
-- "timeout": 29.3156428337, "thisone": 110554}, "tag": "update", "type": "shuangkou"}
function this:ProcessLate(messageObj)
	if not _reEnter then
		_late = true	
	end
	
	local body = messageObj["body"]
	local mycards=body["mycards"];--自己手里牌
	local lastone=tostring(body["lastone"]);
	local current_state=body["current_state"];--各个玩家当前信息
	local thisone=tostring(body["thisone"]);--当前玩家
	for key,value in ipairs(current_state) do
		local uid=tostring(value["userid"]);
		local hold_num=tonumber(value["hold_num"]);
		local managed=value["managed"];
		local lastput_type=tonumber(value["lastput_type"]);
		local lastput=value["lastput"];
		if uid==EginUser.Instance.uid then
			if thisone==uid then
				HPSKPlayer.SetLatePutOut(lastput_type,lastput);
			end
		else
			local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..uid);
			ctrl:SetLate(hold_num);
			if thisone==uid then
				ctrl:SetLatePutOut(lastput_type,lastput);
			end
		end
	end
	
	coroutine.start(HPSKPlayer.PutLateUICards,mycards);
	this.upPlayer=lastone;
		

	local t = body["timeout"]
	this:UpdateHUD(t)
end
function this:SetAnchorPosition(_userIndex,playerIndex)
	local position_span = playerIndex-_userIndex; 
	local player = nil
	if position_span == 1 or position_span == -5 then 
		player = this.tbwzPlayerPrefab[5];
	elseif position_span == 2 or position_span == -4 then 
		player = this.tbwzPlayerPrefab[4];
	elseif position_span == 3 or position_span == -3 then 
		player = this.tbwzPlayerPrefab[1];
	elseif position_span == 4 or position_span == -2 then 
		player = this.tbwzPlayerPrefab[2];
	elseif position_span == 5 or position_span == -1 then 
		player = this.tbwzPlayerPrefab[3];
	else
		log("数据错误==SetAnchorPosition=="..position_span)
		return player;
	end
	player:SetActive(true);
	return player;
end
function this:ProcessReady(messageObj)
	local uid = messageObj["body"]
	local player = GameObject.Find(_nnPlayerName..uid);
	local ctrl = this:GetTbwzPlayerCtrl(player.name);
	--log("准备");
	coroutine.start(ctrl.SetDeal,ctrl,false,0,nil);
	if tostring(uid) == EginUser.Instance.uid then

		ctrl:SetScore(-1);
	else
		--if not this.btnBegin.activeSelf then
		--end
	
		ctrl:SetScore(-1);
		ctrl:SetWait(false)
	end
	
	ctrl:SetReady(true);
	if not tableContains(this._playingPlayerList,player) then
		table.insert(this._playingPlayerList,player)
	end
end
--Processes the deal.(带发牌动画)
--{"body": {"mycards": [23, 10, 49, 12, 43, 30, 17, 4, 41, 26, 13, 0, 5, 40, 27, 14, 3, 42, 29, 22, 8, 44, 50, 37, 24, 19, 6], 
--"banker": 866627887, "timeout": 30, "visible_card": 23}, "tag": "deal", "type": "shuangkou"}
function this:ProcessDeal(messageObj)
	--log("游戏已经开始");
	_isPlaying = true;
	this.ButtonTuoguan:GetComponent("BoxCollider").enabled=false;
	
	for key,player in ipairs(this._readyPlayerList) do
		if not tableContains(this._playingPlayerList,player) then
			table.insert(this._playingPlayerList,player)
		end
	end
	this._readyPlayerList = {};
	
	--清除未被清除的牌
	for key,player in ipairs(this._playingPlayerList) do
		if not IsNil(player)  then
			
			local ctrl = this:GetTbwzPlayerCtrl(player.name)
			--log("发牌111111111");
			coroutine.start(ctrl.SetDeal,ctrl,false,0,nil);
			
			ctrl:SetScore(-1);
			ctrl:SetReady(false);
		end
	end

	local body = messageObj["body"];
	local cards = body ["mycards"];
	local banker=tostring(body["banker"]);
	local visible_card=tonumber(body["visible_card"]);
	local t = body ["timeout"];
	this:UpdateHUD(t);
	
	local isBanker=false;
	if banker==EginUser.Instance.uid then
		isBanker=true;
	else
		isBanker=false;
	end
	
	--[[
	log(#(cards));
	for i=1,#(cards) do
		log(cards[i].."=====================");
	end
	]]
	--发牌
	printf(this._playingPlayerList);
	for key,player in ipairs(this._playingPlayerList) do
		if not IsNil(player) then
			local ctrl = this:GetTbwzPlayerCtrl(player.name)
			if player == this.userPlayerObj then
				--log("自己发牌");
				coroutine.start(ctrl.SetDeal,ctrl,true,#(cards),isBanker,cards);
			else
				--log("别人发牌");
				coroutine.start(ctrl.SetDeal,ctrl,true,#(cards),not isBanker,nil);
			end
			coroutine.wait(0.1);
			if this.mono==nil then
				return;
			end
		end
	end
	
	coroutine.wait(0.2);
	if this.mono==nil then
		return;
	end
	
	--非late进入时才显示摊牌按钮
	if not _late then
		if SettingInfo.Instance.deposit==true then
			coroutine.wait(2);
			if this.mono==nil then
				return;
			end
		end
		
	end
	
end

--{"body": {"managed": true, "uid": 866627887}, "tag": "manage", "type": "game"}
function this:ProcessTuoGuan(messageObj)
	local body = messageObj["body"];
	local uid=tostring(body["uid"]);
	local managed=body["managed"];
	if uid==EginUser.Instance.uid then
		this.NowState=managed;
		if managed then
			this.ButtonTuoguan.transform:FindChild("Background"):GetComponent("UISprite").color=Color.New(124/255, 124/255, 124/255, 1);
			this.tuoguanState:SetActive(true);
			if this.caozuoPanel.activeSelf then
				this.caozuoPanel:SetActive(false);
			end
			this.tuoguanBgShow=true;
		else
			this.ButtonTuoguan.transform:FindChild("Background"):GetComponent("UISprite").color=Color.New(1, 1, 1, 1);
			this.tuoguanState:SetActive(false);
			this.tuoguanBgShow=false;
		end
	else
		
	end
	
end


--{"body": {"hold_num": 7, "mycards": [], "byerank": 0, "put_type": 59, 
--"put_cards": [12, 25, 38, 51, 51], "timeout": 30, "nextone": 866627887, "thisone": 124021}, "tag": "play", "type": "shuangkou"}
function this:ProcessPlay(messageObj)
	if this.upPlayer~=nil then
		if this.upPlayer==EginUser.Instance.uid then
			HPSKPlayer.DestroyCards();
		else
			local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..this.upPlayer);
			ctrl:DestroyCards();
		end
	end
	for key,player in ipairs(this._playingPlayerList) do
		if not IsNil(player) then
			local ctrl = this:GetTbwzPlayerCtrl(player.name)
			ctrl:HideOrShowBuChuState(false);
		end
	end
	
	UISoundManager.Instance.PlaySound("play")
	
	local body = messageObj["body"];
	local thisone=tostring(body["thisone"]);--当前出牌人
	local nextone=tostring(body["nextone"]);--下一家
	local timeOut=tonumber(body["timeout"]);--倒计时时间
	local put_cards=body["put_cards"];--打出牌的值
	local put_type=tonumber(body["put_type"]);--打出牌类型
	local mycards=body["mycards"];--自己手里的所有牌的值
	local hold_num=tonumber(body["hold_num"]);--当前手里剩余牌个数
	local byerank=tonumber(body["byerank"]);
	
	local HideOrShowCaoZuo=false;
	
	this.upPlayer=thisone;
	
	if thisone==EginUser.Instance.uid then
		this.UserPlayerCtrl:HideOrShowTime(false);
		this.tishiCount=0;
		--HPSKPlayer.isCanSelected=false;
		
		if #(this.autoOutCardList)>0 then
			autoOutCard="";
			systemOutCard="";
			for i=1,#(put_cards) do
				systemOutCard=systemOutCard..tostring(put_cards[i]);
			end
			
			for i=1,#(this.autoOutCardList) do
				autoOutCard=autoOutCard..tostring(this.autoOutCardList[#(this.autoOutCardList)-i+1]);
			end
			log(systemOutCard);
			log(autoOutCard);
			if systemOutCard==autoOutCard then
				log("出牌相同");
			else
				log("出牌不同");
				HPSKPlayer.ClearPrefab();
				coroutine.start(HPSKPlayer.PutLateUICards,mycards);
				HPSKPlayer.SetLatePutOut(put_type,put_cards);
			end
		else
			HPSKPlayer.ClearPrefab();
			coroutine.start(HPSKPlayer.PutLateUICards,mycards);
			HPSKPlayer.SetLatePutOut(put_type,put_cards);
		end
		
	else
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..thisone);
		ctrl:SetOtherOutPai(put_cards,put_type,hold_num);
		HPSKPlayer.ChongZhiCards();
		if hold_num>0 then
			HideOrShowCaoZuo=true;
		else
			HideOrShowCaoZuo=false;
		end
		ctrl:HideOrShowTime(false);
		this.tishiArray=HPSKPlayer.SetOtherCardInfo(put_type,put_cards);--获取提示数组
	end
	
	--log(#(this.tishiArray).."=====可以出的牌的个数");
	--printf(this.tishiArray);
	
	if nextone==EginUser.Instance.uid then
		this.UserPlayerCtrl:HideOrShowTime(true);
		if HideOrShowCaoZuo then
			this.caozuoPanel:SetActive(true);
		end
		this.buchuBtn.color =  Color.New(1, 1, 1, 1);
		this.ButtonBuChu:GetComponent("BoxCollider").enabled=true;
		if #(this.tishiArray)>0 then
			this.tishiBtn.color =  Color.New(1, 1, 1, 1);
			this.ButtonTiShi:GetComponent("BoxCollider").enabled=true;
		else
			this.tishiBtn.color =  Color.New(124/255, 124/255, 124/255, 1);
			this.ButtonTiShi:GetComponent("BoxCollider").enabled=false;
		end
		this.chupaiBtn.color=  Color.New(124/255, 124/255, 124/255, 1);
		this.ButtonChuPai:GetComponent("BoxCollider").enabled=false;
		--HPSKPlayer.isCanSelected=true;
	else
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..nextone);
		ctrl:HideOrShowTime(true);
	end
	this:UpdateHUD(timeOut);
end

function this:PlayCardSound(cardType,sex)
	if cardType%10==3 or cardType%10==4 or cardType%10==5 or cardType%10==6 then
		local count=cardType%10;
		if sex==0 then
			UISoundManager.Instance.PlaySound("man_type_"..(count-3));
		else
			UISoundManager.Instance.PlaySound("woman_type_"..(count-3));
		end
	elseif cardType==60 then
		if sex==0 then
			UISoundManager.Instance.PlaySound("man_type_4");
		else
			UISoundManager.Instance.PlaySound("woman_type_4");
		end
	elseif cardType==70 then
		if sex==0 then
			UISoundManager.Instance.PlaySound("man_type_5");
		else
			UISoundManager.Instance.PlaySound("woman_type_5");
		end
	elseif cardType%10==9 then
		local count=math.floor(cardType/10);
		if count<=10 then
			if sex==0 then
				UISoundManager.Instance.PlaySound("man_type_"..(count+2));
			else
				UISoundManager.Instance.PlaySound("woman_type_"..(count+2));
			end
		else
			UISoundManager.Instance.PlaySound("man_type_"..(count+2));
		end
	end
end

--{"body": {"mycards": [10, 49, 12, 43, 30, 17, 4, 41, 26, 13, 0, 5, 40, 27, 14, 3, 42, 29, 22, 8, 44, 50, 37, 24, 19, 6], 
--"timeout": 30, "nextone": 124021, "thisone": 866627887}, "tag": "pass", "type": "shuangkou"}
function this:ProcessPass(messageObj)
	local body = messageObj["body"];
	local thisone=tostring(body["thisone"]);--当前出牌人
	local nextone=tostring(body["nextone"]);--下一家
	local timeOut=tonumber(body["timeout"]);--倒计时时间
	local mycards=body["mycards"];--自己手里的所有牌的值
	
	UISoundManager.Instance.PlaySound("pass")
	
	if thisone==EginUser.Instance.uid then
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..this.upPlayer);
		ctrl:DestroyCards();
		this.UserPlayerCtrl:HideOrShowTime(false);
		this.UserPlayerCtrl:HideOrShowBuChuState(true);
		this.caozuoPanel:SetActive(false);
		this.tishiCount=0;
		--HPSKPlayer.isCanSelected=false;
		HPSKPlayer.ChongZhiCards();
	else
		HPSKPlayer.DestroyCards();
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..thisone);
		ctrl:HideOrShowTime(false);
		ctrl:HideOrShowBuChuState(true);
		HPSKPlayer.SetOtherCardInfo(0,nil);
		HPSKPlayer.ChongZhiCards();
	end
	
	if nextone==EginUser.Instance.uid then
		this.UserPlayerCtrl:HideOrShowTime(true);
		this.caozuoPanel:SetActive(true);
		this.buchuBtn.color =  Color.New(124/255, 124/255, 124/255, 1);
		this.tishiBtn.color =  Color.New(124/255, 124/255, 124/255, 1);
		this.chupaiBtn.color=  Color.New(124/255, 124/255, 124/255, 1);
		--HPSKPlayer.isCanSelected=true;
	else
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..nextone);
		ctrl:HideOrShowTime(true);
		
	end
	
	this.upPlayer=thisone;
	
	this:UpdateHUD(timeOut);
end

--{"body": {"gameinfos": [{"money": -280, "basemoney": -240, "uid": 866627887, "bombs": [], "hand_cards": []}, 
--{"money": 266.0, "basemoney": 240, "uid": 124021, "bombs": [{"star": 4, "n": 1}, {"star": 5, "n": 2}, {"star": 6, "n": 1}], "hand_cards": []}], 
--"winners": [124021], "maxstar": 7, "system_win": 14.0, "wintype": 1}, "tag": "gameover", "type": "shuangkou"}

--{"body": {"gameinfos": [{"money": 456.0, "basemoney": 320, "uid": 109243, "bombs": [{"star": 9, "n": 1}, {"star": 4, "n": 1}], "hand_cards": []}, 
--{"money": -480, "basemoney": -320, "uid": 866627885, "bombs": [{"star": 4, "n": 2}], "hand_cards": []}], "winners": [109243], 
--"maxstar": 8, "system_win": 24.0, "wintype": 2}, "tag": "gameover", "type": "shuangkou"}
function this:ProcessGameover(messageObj)
	HPSKPlayer.isCanSelected=false;
	this.biaoqing_panel:SetActive(false);
	this.talk_panel:SetActive(false);
	this.setting:SetActive(false);
	
	local body = messageObj["body"];
	local gameinfos=body["gameinfos"];
	local winners=tostring(body["winners"][1]);
	local maxstar=tonumber(body["maxstar"]);
	local wintype=tonumber(body["wintype"]);--0 ""  1  双扣   2  单扣   3 平扣
	
	local winNickname="";
	if winners==EginUser.Instance.uid then
		winNickname=EginUser.Instance.nickname;
		this.UserPlayerCtrl:PlayWinSound(wintype);
	else
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..winners);
		winNickname=ctrl.userNickname.text;
		ctrl:PlayWinSound(wintype);
	end
	if  LengthUTF8String(winNickname) > 5 then
			winNickname =   SubUTF8String(winNickname,8).."...";
	end
	
	local winTypeLabel="";
	if wintype==1 then
		winTypeLabel="双扣!";
	elseif wintype==2 then
		winTypeLabel="单扣!";
	elseif wintype==3 then
		winTypeLabel="平扣！";
	end
	
	local winXiang="";
	if maxstar>=6 then
		winXiang="-"..maxstar;
	else
		winXiang=tostring(maxstar);
	end
	
	this.win_message.transform:FindChild("name"):GetComponent("UILabel").text=winNickname;
	this.win_message.transform:FindChild("koupai"):GetComponent("UILabel").text=winTypeLabel;
	this.win_message.transform:FindChild("fanshu"):GetComponent("UILabel").text=winXiang;
	
	for key,value in ipairs(gameinfos) do
		if tostring(value["uid"])==EginUser.Instance.uid then
			this:SetWinMessage(value,this.jiesuan_1);
		else
			this:SetWinMessage(value,this.jiesuan_2);
		end
	end
	coroutine.wait(1.5);
	this.jiesuanMessage:SetActive(true);
	_isPlaying = false;
	this.NowState=false;
	this.tuoguanState:SetActive(false);
	this.ButtonTuoguan.transform:GetComponent("BoxCollider").enabled=false;
	this.ButtonTuoguan.transform:FindChild("Background"):GetComponent("UISprite").color=Color.New(1, 1, 1, 1);
	this.biaoqingBgShow=false;
end

function this:SetWinMessage(infos,target)
	local liebiao={};
	for i=1,3 do
		table.insert(liebiao,target.transform:FindChild("libiao_"..i).gameObject);
	end
	for i=1,3 do
		liebiao[i]:SetActive(false);
		--log(liebiao[i].name);
	end
	local money=tonumber(infos["money"]);
	local basemoney=tonumber(infos["basemoney"]);
	local uid=tostring(infos["uid"]);
	local bombs=infos["bombs"];
	if #(bombs)>0 then
		--log(#(bombs));
		--log(tostring(bombs[1]["star"]).."========="..tostring(bombs[1]["n"]));
		for i=1,#(bombs) do
			liebiao[i].transform:FindChild("xing/Label"):GetComponent("UILabel").text=tostring(bombs[i]["star"]);
			liebiao[i].transform:FindChild("dilei/Label_1"):GetComponent("UILabel").text=tostring(bombs[i]["n"]);
			liebiao[i]:SetActive(true);
			if i==3 then
				break;
			end
		end
	end
	
	target.transform:FindChild("Score"):GetComponent("UILabel").text=tostring(money);
	local winNickname="";
	if uid==EginUser.Instance.uid then
		winNickname=EginUser.Instance.nickname;
	else
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..uid);
		winNickname=ctrl.userNickname.text;
		ctrl.CardCount:SetActive(false);	
	end
	if  LengthUTF8String(winNickname) > 5 then
			winNickname =   SubUTF8String(winNickname,8).."...";
	end
	target.transform:FindChild("win_panel/name"):GetComponent("UILabel").text=winNickname;
	target.transform:FindChild("win_panel/money"):GetComponent("UILabel").text=tostring(basemoney);
end

function this:ProcessOk(messageObj)
	local body = messageObj["body"];
	local uid = body["uid"]
	if tostring(uid) ~=EginUser.Instance.uid then
		
	else
		local cards = body["cards"]
		local cardType = body["type"];

	end

end

function this:ProcessEnd(messageObj)
	coroutine.wait(1);
	
	this._playingPlayerList = {}
	
	local body = messageObj["body"]
	local infos = body["infos"]

	--玩家扑克牌信息
	for key,info in ipairs(infos) do
		local jos = info
		local uid = jos[1] 
		local ctrl = this:GetTbwzPlayerCtrl(_nnPlayerName..uid)
		
		local cards = jos[2]
		local cardType = jos[3] --牌型 
		 
		--名牌
		if tostring(uid)  ~= EginUser.Instance.uid then
			if ctrl ~= nil then 
				
				coroutine.wait(0.1)
				if this.mono==nil then
					return;
				end
			end
		end  
	end
	
	for key,info in ipairs(infos) do
		local jos = info
		local uid = jos[1]
		local uiAnchor = GameObject.Find(_nnPlayerName..uid)
		if uiAnchor ~= nil then 
			local ctrl = this:GetTbwzPlayerCtrl(uiAnchor.name)
			
			local cards = jos[2]
			local cardType = jos[3] --牌型
			local score = jos[4]	--得分
			 
			
			--名牌
			if tostring(uid)  == EginUser.Instance.uid then 
				
				
			end 
			ctrl:SetScore(score) 
		end
	end
	
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
		this.btnBegin:SetActive(true)
	end
	
	local t = body["t"]
	this:UpdateHUD(t);
	
	_isPlaying = true;
	
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
		FootInfo:UpdateIntomoneyString(HPSKPlayerCtrl:NumberAddWan(intoMoney));
	end
end
function this:ProcessCome(messageObj)
	local body = messageObj["body"];
	local memberinfo = body["memberinfo"];
	local player = this:AddPlayer(memberinfo,_userIndex);
	
	if _isPlaying then
		local ctrl = this:GetTbwzPlayerCtrl(player.name);
		ctrl:SetWait(true);
	end

end
function this:ProcessLeave(messageObj)
	local uid = messageObj["body"]
	if tostring(uid) ~= EginUser.Instance.uid then
		local player = GameObject.Find(_nnPlayerName..uid);
		this:RemoveTbwzPlayerCtrl(player.name);
		if tableContains(this._playingPlayerList,player) then
			tableRemove(this._playingPlayerList,player);
		end
		
		if tableContains(this._waitPlayerList,player) then
			tableRemove(this._waitPlayerList,player);
		end
		player:SetActive(false) 
	end
end
function this:ProcessNotcontinue()
	this.msgNotContinue:SetActive(true);
	if this.jiesuanMessage.activeSelf then
		this.jiesuanMessage:SetActive(false);
	end
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
	local startJson = {["type"]="shuangkou",tag="start"};    --最终产生json的表
	--将表数据编码成json字符串
	local jsonStr = cjson.encode(startJson);
	this.mono:SendPackage(jsonStr);
	
	EginTools.PlayEffect(this.but);
	this.btnBegin:SetActive(false);
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

function this.ShexianSend(mahjongNameObj)
	this.UserPlayerCtrl:SelectMahjong(mahjongNameObj);
end

function this.SelectCardList()
	this.UserPlayerCtrl:ShowOutPai();
end

function this:SetTiShi(isDeal,cardtype)
	if isDeal then
		this.caozuoPanel:SetActive(true);
		this.buchuBtn.color =  Color.New(124/255, 124/255, 124/255, 1);
		this.tishiBtn.color =  Color.New(124/255, 124/255, 124/255, 1);
		this.chupaiBtn.color=  Color.New(124/255, 124/255, 124/255, 1);
		this.ButtonBuChu:GetComponent("BoxCollider").enabled=false;
		this.ButtonChuPai:GetComponent("BoxCollider").enabled=false;
		this.ButtonTiShi:GetComponent("BoxCollider").enabled=false;
	else
		if cardtype>0 then	
			this.chupaiBtn.color=  Color.New(1, 1, 1, 1);
			this.ButtonChuPai:GetComponent("BoxCollider").enabled=true;	
		else		
			this.chupaiBtn.color=  Color.New(124/255, 124/255, 124/255, 1);
			this.ButtonChuPai:GetComponent("BoxCollider").enabled=false;	
		end
	end
end

function this:OnButtonClick(target)
	if target==this.ButtonBuChu then
		local pass = {type="shuangkou",tag="pass"};    --最终产生json的表
		local jsonStr = cjson.encode(pass);
		this.mono:SendPackage(jsonStr);
	elseif target==this.ButtonTiShi then
		this.tishiCount=this.tishiCount+1;
		local count=#(this.tishiArray);
		log(count);
		printf(this.tishiArray);
		--log(this.tishiCount.."===提示次数");
		--printf(this.tishiArray[this.tishiCount]);
		HPSKPlayer.SetTiShiMessage(this.tishiArray[this.tishiCount]);
		if this.tishiCount==count then
			this.tishiCount=0;
		end
	elseif target==this.ButtonChuPai then
		HPSKPlayer.OutCard();
		this.caozuoPanel:SetActive(false);
	elseif target==this.ButtonTuoguan then
		if this.NowState then
			local sendData={type="game",tag="manage",body=false};
			this.mono:SendPackage(cjson.encode(sendData));
		else
			local sendData={type="game",tag="manage",body=true};
			this.mono:SendPackage(cjson.encode(sendData));
			this.caozuoPanel:SetActive(false);
		end
	elseif target==this.ButtonBiaoqing then
		this.biaoqingBgShow=true;
		this.biaoqing_panel:SetActive(true);
		this.talk_panel:SetActive(false);
		this.biaoqingPanel:SetActive(true);	
	elseif target==this.ButtonYuyin then
		this.biaoqingBgShow=true;
		this.talk_panel:SetActive(true);
		this.biaoqing_panel:SetActive(false);
		this.languagePanel:SetActive(true);
	elseif target==this.biaoqing_shelet then
		this.biaoqingBgShow=false;
		this.biaoqing_panel:SetActive(false);
	elseif target==this.yuyin_shelet then
		this.biaoqingBgShow=false;
		this.talk_panel:SetActive(false);
	elseif target==this.game_bg then
		HPSKPlayer.ChongZhiCards();
	end
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
	NGUITools.SetActive(this.biaoqing_panel.gameObject,false);
	this.biaoqingBgShow=false;
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
		for i=1,9 do
			if target==this.language_panel.transform:FindChild("label_"..i).gameObject then
				language_index=i;
				--log(i.."====当前语音index");
				break;
			end
		end
		
		local messageBody={};
		messageBody['hurry_index'] = language_index;
		local sendData={type="game",tag="hurry",body=messageBody};
		this.mono:SendPackage(cjson.encode(sendData));
	end
	
	this.talk_panel:SetActive(false);
	this.biaoqingBgShow=false;
end

function this:ProcessEmotion(message)
	endTime=Time.time;
	local body=message["body"];
	local id=tonumber(body[1]);
	local number=tonumber(body[2]);
	local ctrl=this:GetTbwzPlayerCtrl(_nnPlayerName..id);
	
	ctrl:setEmotion(number);
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


function this:UserContinue()
	this.jiesuanMessage:SetActive(false);
	this.caozuoPanel:SetActive(false);
	HPSKPlayer.ClearPrefab();
	for key,player in ipairs(this._playingPlayerList) do
		if not IsNil(player) then
			local ctrl = this:GetTbwzPlayerCtrl(player.name)
			if player ~= this.userPlayerObj then
				ctrl:ClearPrefab();	
			else
				ctrl:HideOrShowTime(false);	
			end
		end
	end
	coroutine.start(this.AfterDoing,this,1,function()
		local sendData={type="game",tag="continue"};
		this.mono:SendPackage(cjson.encode(sendData));
	end)
end

