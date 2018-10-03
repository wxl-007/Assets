require "Game20DN/DN20PlayerCtrl"
local cjson = require "cjson"

local this = LuaObject:New()
Game20DN = this

local _userAvatar=nil;
local _userNickname=nil;
local _userBagmoney=nil;
local _userLevel=nil;
local otherUid="0";
--/ 游戏开始时正在游戏的玩家
local _playingPlayerList = {};
--/ 动态生成的玩家实例名字的前缀
local _nnPlayerName = "NNPlayer_";
local _bankerPlayer=nil;
local _colorBtns = {};
local _isPlaying=nil;
local _late=nil;
local _reEnter=nil;
--闲家选择下注的筹码大小
local chipcount = 0;
--自己发了两张牌之后的牌型
local owncardtype = -2;
local banker_commit = false;
local canget = true;
local playerCtrlDc = {}
local isre_enter = false;
local isOwnFanBei=false;  --结算是否再次翻倍
local isOtherFanBei=false;
--local ownCanMingpai=false;
--local otherCanMingpai=false;
local ownMingpai=false;
local ownMiaosha=false;
local otherMingpai=false;
local otherMiaosha=false;
local isOwnReady=false;

local leaveUid="";
local otherReadyUid="";
local bodyCome=nil;
local isGameOver=true;
local isStartGame=true;
local ownTanpai=false;
function this:bindPlayerCtrl(objName, gameObj)
	playerCtrlDc[objName] = DN20PlayerCtrl:New(gameObj)
end

function this:getPlayerCtrl(objName)
	return playerCtrlDc[objName]
end

function this:removePlayerCtrl( objName )
	if(playerCtrlDc[objName] ~= nil)then
		playerCtrlDc[objName]:OnDestroy()
	end
	playerCtrlDc[objName] = nil;	
end

function this:ReplaceNamePlayerCtrl(oldName,newName)
	
	if oldName ~= newName then
		local yszTemp =  playerCtrlDc[oldName]
		if yszTemp ~= nil then
			playerCtrlDc[newName] = yszTemp
			playerCtrlDc[oldName] = nil
		end
	end
end
function this:clearLuaValue() 
	 --/ 同桌其他玩家的预设
	this.dznnPlayerPrefab=nil;
	--/ 游戏玩家的控制脚本
	this.userPlayerCtrl=nil;
	this.userPlayerObj=nil;
	this.btnReady=nil;    --准备按钮
	this.btnPanel=nil;    --开始、明牌与秒杀父物体
	this.btnCallBankers=nil;
	this.btnCallBankerTargetFrom=nil;
	this.btnCallBankerTargetTo=nil;
	this.buttonPanel=nil;
	this.btnShow=nil;
	this.btnGetCards=nil;
	this.btnTuoguan=nil;
	this.btnTuoGuanSprite=nil;
	this.tuoguanzhong=nil;  --托管按钮图片    托管中   庄的图片
	this.buttonPanelPosition=nil;
	this.despoite =0;
	this.msgWaitNext=nil;
	this.msgWaitBet=nil;
	--/ 供选择的筹码
	this.chooseChipObj=nil;
	this.msgQuit=nil;
	this.msgAccountFailed=nil;
	this.msgNotContinue=nil;
	this.soundStart=nil;
	this.soundWanbi=nil;
	this.soundXiazhu=nil;
	this.soundTanover=nil;
	this.soundWin=nil;
	this.soundFail=nil;
	this.soundEnd=nil;
	this.soundNiuniu=nil;
	this.canTanpai = true;--可以摊牌
	
	this.button_begin = nil;
	this.button_mingpai=nil;
	this.button_miaosha=nil;
	
	isre_enter = false;
	_userAvatar=nil;
	_userNickname=nil;
	_userBagmoney=nil;
	_userLevel=nil;
	otherUid="0";
--/ 游戏开始时正在游戏的玩家
	_playingPlayerList = {};
--/ 动态生成的玩家实例名字的前缀
	_nnPlayerName = "NNPlayer_";
	_bankerPlayer=nil;
	_colorBtns = {};
	_isPlaying=nil;
	_late=nil;
	_reEnter=nil;
--闲家选择下注的筹码大小
	chipcount = 0;
--自己发了两张牌之后的牌型
	owncardtype = -2;
	banker_commit = false;
	ownTanpai=false;
	canget = true;
	playerCtrlDc = {}
	this.settingtuoguan=nil;
	
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	for k,v in pairs(playerCtrlDc) do
		v:OnDestroy()
	end
	this.jiangchiBtn=nil;
	this.jiangchiShow=false;
	GameSettingManager.depositFunc=nil;
	playerCtrlDc = {}
	coroutine.Stop()
	LuaGC()
end
function this:Init()
	_userAvatar=nil;
	_userNickname=nil;
	_userBagmoney=nil;
	_userLevel=nil;
	otherUid="0";
	--/ 游戏开始时正在游戏的玩家
	_playingPlayerList = {};
	--/ 动态生成的玩家实例名字的前缀
	_nnPlayerName = "NNPlayer_";
	_bankerPlayer=nil;
	_colorBtns = {};
	_isPlaying=nil;
	_late=nil;
	_reEnter=nil;
	--闲家选择下注的筹码大小
	chipcount = 0;
	--自己发了两张牌之后的牌型
	owncardtype = -2;
	banker_commit = false;
	canget = true;
	playerCtrlDc = {}
	isre_enter = false;
	isOwnReady=false;
	isStartGame=false;
	isOwnFanBei=false;
	isOtherFanBei=false;
	--ownCanMingpai=false;
	--otherCanMingpai=false;
	ownMingpai=false;
	ownMiaosha=false;
	otherMingpai=false;
	otherMiaosha=false;
	--log("清除翻倍");
	--log(isFanBei);
	
	--初始化变量
	--/ 同桌其他玩家的预设
	this.dznnPlayerPrefab= ResManager:LoadAsset("game20dn/twentydnplayer","TwentyDNPlayer");
	
	this.userPlayerObj=this.transform:FindChild("Content/User").gameObject;
	--/ 游戏玩家的控制脚本
	this.userPlayerCtrl=this:bindPlayerCtrl(this.userPlayerObj.name, this.userPlayerObj)
	this.btnReady=this.transform:FindChild("Content/User/Button_ready").gameObject;    --开始按钮父物体
	this.btnCancelTuoguan=this.transform:FindChild("Content/User/Button_CancelTuoguan").gameObject;
	this.btnPanel=this.transform:FindChild("Content/User/btnParent").gameObject;    --明牌按钮父按钮父物体
	this.btnCallBankers=this.transform:FindChild("Content/User/Output/BtnCallBanker").gameObject;
	this.btnCallBankerTargetFrom=this.transform:FindChild("Content/User/Output/BtnCallBankerTargetFrom").gameObject;
	this.btnCallBankerTargetTo=this.transform:FindChild("Content/User/Output/BtnCallBankerTargetTo").gameObject;
	this.buttonPanel=this.transform:FindChild("Content/User/buttonPanel").gameObject;
	this.btnShow=this.transform:FindChild("Content/User/buttonPanel/Button_show").gameObject;
	this.btnGetCards=this.transform:FindChild("Content/User/buttonPanel/Button_getcard").gameObject;
	this.btnTuoguan=this.transform:FindChild("Content/User/buttonPanel/Button_tuoguan").gameObject;
	this.btnTuoGuanSprite=this.transform:FindChild("Content/User/buttonPanel/Button_tuoguan/Background").gameObject:GetComponent("UISprite");
	this.tuoguanzhong=this.transform:FindChild("Content/User/Output/Sprite_tuoguanzhong").gameObject;  --托管按钮图片    托管中   庄的图片
	this.buttonPanelPosition=nil;
	this.despoite =0;
	this.msgWaitNext=this.transform:FindChild("Content/MsgContainer/MsgWaitNext").gameObject;
	this.msgWaitBet=this.transform:FindChild("Content/MsgContainer/MsgWaitBet").gameObject;
	--/ 供选择的筹码
	this.chooseChipObj=nil;
	this.msgQuit=this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject;
	this.msgAccountFailed=this.transform:FindChild("Content/MsgContainer/MsgAccountFailed").gameObject;
	this.msgNotContinue=this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject;
	
	this.soundStart=ResManager:LoadAsset("gamenn/Sound","GAME_START");
	this.soundWanbi=ResManager:LoadAsset("gamenn/Sound","wanbi");
	this.soundXiazhu=ResManager:LoadAsset("gamenn/Sound","xiazhu");
	this.soundTanover=ResManager:LoadAsset("gamenn/Sound","tanover");
	this.soundWin=ResManager:LoadAsset("gamenn/Sound","win");
	this.soundFail=ResManager:LoadAsset("gamenn/Sound","fail");
	this.soundEnd=ResManager:LoadAsset("gamenn/Sound","GAME_END");
	this.soundNiuniu=ResManager:LoadAsset("gamenn/Sound","niuniu");
	this.canTanpai = true;--可以摊牌
	this.button_begin = this.transform:FindChild("Content/User/btnParent/Button_begin").gameObject
	this.button_mingpai=this.transform:FindChild("Content/User/btnParent/Button_mingpai").gameObject
	this.button_miaosha=this.transform:FindChild("Content/User/btnParent/Button_miaosha").gameObject
	this.settingtuoguan=this.transform:FindChild("GameSettingManager/Sprite_popup_container/Label_setting/Label_deposit/Button_deposit/Background").gameObject:GetComponent("UISprite");
	this.settingtuoguanButton=this.transform:FindChild("GameSettingManager/Sprite_popup_container/Label_setting/Label_deposit/Button_deposit").gameObject:GetComponent("UIButton");
	this.jiangchiShow=false;
end


function this:cancelDeposite()
	--todo	
	--log("111111111");
	this.btnCancelTuoguan:SetActive(true);
	this.tuoguanzhong:SetActive(true);
	this.despoite=1;
	if this.btnReady.activeSelf then
		this.btnReady:SetActive(false);
		this:UserReady();
	end
end

function this:cancelDeposite_1()
	--log("2222222222");
	this.despoite=0;
	this.btnCancelTuoguan:SetActive(false);
	this.tuoguanzhong:SetActive(false);
end

function this:handleBtnsFunc()

	local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
	this.mono:AddClick(btn_MsgQuit, this.UserQuit,this)


	local callBankerBtn = this.transform:FindChild("Content/User/Output/BtnCallBanker/Button1").gameObject
	this.mono:AddClick(callBankerBtn, this.UserCallBanker,this )

	local giveupBtn = this.transform:FindChild("Content/User/Output/BtnCallBanker/Button0").gameObject
	this.mono:AddClick(giveupBtn, this.UserCallBanker,this )
	
	local btnShow = this.transform:FindChild("Content/User/buttonPanel/Button_show").gameObject
	this.mono:AddClick(btnShow, this.UserShow,this)
	
	local button_getcard = this.transform:FindChild("Content/User/buttonPanel/Button_getcard").gameObject
	this.mono:AddClick(button_getcard, this.UserGet,this)
	
	local button_tuoguan = this.transform:FindChild("Content/User/buttonPanel/Button_tuoguan").gameObject
	this.mono:AddClick(button_tuoguan, this.UserTuoguan,this)
	this.mono:AddClick(this.btnCancelTuoguan,this.UserTuoguan,this);
	
	for i = 0 ,3 do
		local spriteChip = this.transform:FindChild("Content/User/ChooseChips/SpriteChip"..i).gameObject
		this.mono:AddClick(spriteChip, this.UserChip,this)
	end
	
	
	--4  chip btn
	local chooseChipObj = this.transform:FindChild("Content/User/ChooseChips").gameObject					
	local btns = chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true), true) 
	for i=0, btns.Length-1 do
		local btn = btns[i].gameObject
		if btn.name == "Button" then
			this.mono:AddClick(btn, this.UserChip,this)
		end
	end 
	
	local endPosition = this.transform:FindChild("Content/User/ChooseChips/ButtonPrefabEndPosition").gameObject
		this.mono:AddClick(endPosition, this.UserChip,this)
		
	--local button_begin = this.transform:FindChild("Content/User/btnParent/Button_begin").gameObject
	--local button_mingpai=this.transform:FindChild("Content/User/btnParent/Button_mingpai").gameObject
	--local button_miaosha=this.transform:FindChild("Content/User/btnParent/Button_miaosha").gameObject
	this.mono:AddClick(this.btnReady, this.UserReady,this)
	--this.mono:AddClick(this.button_mingpai, this.UserReady,this)
	--this.mono:AddClick(this.button_miaosha , this.UserReady,this)
	this.mono:AddClick(this.button_begin, this.OnButtonClick,this)
	this.mono:AddClick(this.button_mingpai, this.OnButtonClick,this)
	this.mono:AddClick(this.button_miaosha , this.OnButtonClick,this)
	
	local button_back = this.transform:FindChild("GameSettingManager/Panel_button/Button_back").gameObject
	this.mono:AddClick(button_back, this.OnClickBack,this)

	this.btnXiala=this.transform:FindChild("GameSettingManager/Panel_button/Button_xiala").gameObject;
	this.btnXiala_bg=this.btnXiala.transform:FindChild("Background"):GetComponent("UISprite");
	this.mono:AddClick(this.btnXiala,this.OnButtonClick_1,this);
	this.btn_setting=this.transform:FindChild("GameSettingManager/Panel_button/Button_xiala/panel/Button_setting").gameObject;
	this.btn_help=this.transform:FindChild("GameSettingManager/Panel_button/Button_xiala/panel/Button_help").gameObject;
	this.btn_emotion=this.transform:FindChild("GameSettingManager/Panel_button/Button_xiala/panel/Button_emotion").gameObject;
	this.btn_shelet=this.transform:FindChild("GameSettingManager/Panel_button/Button_xiala/panel/shelet").gameObject;
	this.mono:AddClick(this.btn_setting,this.OnButtonClick_1,this);
	this.mono:AddClick(this.btn_help,this.OnButtonClick_1,this);
	this.mono:AddClick(this.btn_emotion,this.OnButtonClick_1,this);
	this.mono:AddClick(this.btn_shelet,this.OnButtonClick_1,this);


end
function this:Awake() 
	local footInfoPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalFootInfo")
	GameObject.Instantiate(footInfoPrb)
	--初始化变量
	if PlatformGameDefine.playform.IsPool then
  		--Application.LoadLevelAdditive("JiangChi");
  		local JiangChiPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalJiangChiPrb")
  		local JiangChi=GameObject.Instantiate(JiangChiPrb)
		local anchortarget=JiangChi.transform:FindChild('PoolInfo/firstView').gameObject:GetComponent("UIWidget");
		this.jiangchiBtn=JiangChi.transform:FindChild('PoolInfo/firstView').gameObject;
		anchortarget.leftAnchor.absolute = -315;
		anchortarget.rightAnchor.absolute = -7;
		anchortarget.bottomAnchor.absolute = 13;
		anchortarget.topAnchor.absolute = 137;
		anchortarget.bottomAnchor.relative = 0;
		anchortarget.topAnchor.relative = 0;
 	end
	this:Init()
	GameSettingManager.depositFunc = this.cancelDeposite;
	GameSettingManager.depositFunc_1 = this.cancelDeposite_1;
	--初始化按钮事件
	this:handleBtnsFunc()
	-----游戏逻辑----
   	local sceneRoot = this.transform.root:GetComponent("UIRoot")
 	if sceneRoot ~= nil then
  		sceneRoot.manualHeight = 1920;
  		sceneRoot.manualWidth  = 1080;
 	end
	
end

function this:Start() 
	if SettingInfo.Instance.autoNext == true or this.despoite==1 then 
		this.btnReady:SetActive(false);
		--this.btnReady.transform.localPosition=Vector3.New(0,-400,0);
	end

	this.mono:StartGameSocket();
	this.buttonPanelPosition = this.buttonPanel.transform.localPosition;
	coroutine.start(this.UpdateInLua) 
	
end

function this:OnEnable() 

end
--this Update call only in Lua layer
function this:UpdateInLua()
	--print("lua update")
	while(this.mono) do
		for k,v in pairs(playerCtrlDc) do
			if(v == nil)then
				--print("?????")
			else
				v:UpdateInLua()
			end
		end
		
		coroutine.wait(0.1)
	end
end
function this:OnDisable()
	this:clearLuaValue()
	
end

function this:SocketReceiveMessage ( message) 
	local msgStr = self;
	if msgStr then 
	    local nextTime=0;
		
		local msgData = cjson.decode(msgStr)
		local type1 = msgData["type"]
		local tag   = msgData["tag"]
		--log("~~~~消息~~~!!!"..msgStr)
		if( type1 == "game") then
			--log("~~~~消息~~~!!!"..msgStr)
			if(tag == "enter") then
				this:ProcessEnter(msgData)
			elseif(tag == "ready") then
				this:ProcessReady(msgData)
			elseif(tag == "come") then
				this:ProcessCome(msgData)
			elseif(tag == "leave") then
				this:ProcessLeave(msgData)
			elseif(tag == "deskover") then
				this:ProcessDeskOver(msgData)
			elseif(tag == "notcontinue")then
				coroutine.start(this.ProcessNotcontinue)
			end
		elseif( type1 == "dz20p") then	
			--log("~~~~消息~~~!!!"..msgStr)
			if(tag == "re_enter") then
				isre_enter = true;
				coroutine.start(this.ProcessLate,this,msgData) 
			elseif(tag == "commit") then 
				log("~~~~消息~~~!!!"..msgStr) 
				if(isre_enter) then
					coroutine.start(this.AfterDoing,this,0.2, this.ProcessOk,msgData);  
				else			
					this:ProcessOk(msgData)
				end 
			elseif(tag == "ask_banker")then
				log("~~~~消息~~~!!!"..msgStr)
				this:ProcessAskbanker(msgData)
			elseif(tag == "start_chip")then
				this:ProcessStartchip(msgData)
			elseif(tag == "deal")then 
				log("~~~~消息~~~!!!"..msgStr) 
				this:ProcessDeal(msgData)
			elseif(tag=="show") then
				log("~~~~消息~~~!!!"..msgStr)
				this:ProcessMPorMS(msgData);
			elseif(tag=="ask_show") then
				log("~~~~消息~~~!!!"..msgStr)
				this:ProcessAskShow(msgData);
			elseif(tag == "game_over")then 
				log("~~~~消息~~~!!!"..msgStr)
				coroutine.start(this.ProcessEnd,this, msgData)
			elseif(tag == "ask_get")then 
				log("~~~~消息~~~!!!"..msgStr)
				if(isre_enter)  then
					coroutine.start(this.AfterDoing,this,0.2, this.ProcessAskGetCard,msgData);  
				else 
					this:ProcessAskGetCard(msgData)
				end 
			elseif(tag == "get")then  
				if(isre_enter)  then
					coroutine.start(this.AfterDoing,this,0.2, this.ProcessGetCard,msgData);  
				else		
					this:ProcessGetCard(msgData) 
				end 
			end
		elseif(type1 == "seatmatch") then
			if(tag == "on_update") then
				this:ProcessUpdateAllIntomoney(msgData)
			end
		elseif(type1 == "niuniu") then	
			
			if(tag == "pool") then
				if(PlatformGameDefine.playform.IsPool) then
					local info = find("initJC")
					local chiFen = msgData["body"]["money"]
					local infos  = msgData["body"]["msg"]
					if(info ~= nil) then
						PoolInfo:show(chiFen, infos)
						this.jiangchiShow=false;
					end
				end
			elseif(tag == "mypool") then
				if (PlatformGameDefine.playform.IsPool) then
					local chiFen = msgData["body"]
					local info = find("initJC")
					if(info ~= nil) then
						PoolInfo:setMyPool(chiFen)
					end
				end
			elseif(tag == "mylott") then
				local msg = nil;
				if(msgData["body"]["msg"] ~= nil)then
					msg = msgData["body"]["msg"]
				else
					msg = msgData["body"]
				end
				
				if (PlatformGameDefine.playform.IsPool) then
					local info = find("PoolInfo")
					if(info ~= nil) then
						PoolInfo:setMyPool(msg)
					end
				end
				
			end
		end
	end
end
 
 
--{"type":"dz20p","body":{"step":3,"bid":866627886,"infos":[{"uid":110074,"final":0,"type":2,"is_commit":0,"cards":[2,31,28],"showType":1},
--{"uid":866627886,"final":0,"type":1,"is_commit":0,"cards":[43,18],"showType":2}],"chips":[5043,2521,1260,630],"timeout":5,"chipnum":1260},"tag":"re_enter"}
function this:ProcessLate(messageObj) 
	coroutine.wait(0); 
	--log("重新进入，是否准备");
	--log(isOwnReady);
	if not _reEnter then 
		_late = true;
		this.msgWaitNext:SetActive(true);
	end
	--（late进入时不显示开始按钮，显示等待）
	this.btnReady:SetActive(false); 
	--this.btnPanel.transform.localPosition=Vector3.New(0,-400,0);
	--log(cjson.encode(messageObj)) 
	local body = messageObj["body"];
	local t = tonumber(body["timeout"]);
	local step = tonumber(body["step"]);
	local nnBid = tonumber(body["bid"]);
	local chip = body["chips"] ;
	local gid =  tostring(body ["bid"]);
	chipcount = tonumber(body["chipnum"])
	
	--庄家
	if nnBid ~= 0 then
		_bankerPlayer = GameObject.Find(_nnPlayerName..nnBid);
		this:getPlayerCtrl(_bankerPlayer.name).isBanker = 1;
		this:getPlayerCtrl(_bankerPlayer.name).zhuangjia:GetComponent("UIPanel").baseClipRegion = Vector4.New(0, 0, 150, 150) 
		--log("庄家".._bankerPlayer.name)
	end
	
	local infos = body["infos"] ;
	for  index, info in pairs(infos) do		 
		local uid =  tostring(info["uid"]);	
		local showtype=tonumber(info["showType"]);
		if uid==EginUser.Instance.uid then		 		
			if showtype==2 or showtype==3 then
				--isFanBei=true;
				isOwnFanBei=true;
				--log("是否翻倍");
				--log(isFanBei);
			else
				isOwnFanBei=false;
			end
		else
			if showtype==2 or showtype==3 then
				--isFanBei=true;
				isOtherFanBei=true;
				--log("是否翻倍");
				--log(isFanBei);
			else
				isOtherFanBei=false;
			end
		end
	end
	for  index, info in pairs(infos) do
		 
		local uid =  tostring(info["uid"]);
		local showNum = tonumber(info["is_commit"]) ;
		local cards = info["cards"] ;
		local cardType = tonumber(info["type"]) ;
		local perChip = tonumber(info["final"]) ;
		local showtype=tonumber(info["showType"]);						
		local player = GameObject.Find(_nnPlayerName..uid);
		if player ~= nil then  
			--log("遍历玩家"..player.name)
			local ctrl =   this:getPlayerCtrl(player.name);
			if tostring(nnBid) ~=  uid then
				ctrl.isBanker = 2;
				--log("设置闲家")
			end 
			
			if player ~= this.userPlayerObj then  
			    ctrl:SetLateMingpai(EginUser.Instance.uid,showtype,isOwnFanBei);
				if step == 3 then
					if player ~= _bankerPlayer then  
						ctrl:SetLateChip(chipcount);
					end
					
					if showNum ==1 then 
						ctrl:SetLate(cards, false, true, cardType);
						--ctrl:SetCardTypeUser(cards, cardType);
						ctrl:setCommitCardType(false);
						ctrl:HideTimedown();
					else  
						ctrl:SetLate(cards, false, false, cardType);
					end
				elseif step == 2 then
					ctrl:SelectedChip(chip,false)
				end
			else
			    ctrl:SetLateMingpai(otherUid,showtype,isOtherFanBei);
				 if step == 1 then
					if gid == EginUser.Instance.uid then
						this.btnCallBankers:SetActive(true);
						this:MoveTarget(this.btnCallBankers,this.btnCallBankerTargetTo.transform.localPosition.y,0.3);
						ctrl:PlayerTimedown(t, false,false,2);
					end
				elseif step == 2 then
					if chipcount ~= 0 then
						ctrl:SetLateChip(chipcount);
					elseif chipcount == 0 then
						ctrl:SetChip(chip, true);
					end
				elseif step == 3 then 
					if player ~= _bankerPlayer then  
						ctrl:SetLateChip(chipcount);
					end
					if showNum ==1 then 
						ctrl:SetLate(cards, true, true, cardType);
						--ctrl:SetCardTypeUser(cards, cardType);
						ctrl:setCommitCardType(true);
						ctrl:HideTimedown();
					else  
						ctrl:SetLate(cards, true, false, cardType);
						ctrl:setSecondCardType(true,false)
					end
				end
			end
		end
	end 
	
	isre_enter = false;
end

function this:ProcessEnter(messageObj) 
	UISoundManager.Instance:PlayBGSound();
	this:ChongZhi();
  
	local body = messageObj["body"];
	local memberinfos = body["memberinfos"] ;
	this.userPlayerCtrl =   this:getPlayerCtrl(this.userPlayerObj.name);
	for index,memberinfo in pairs(memberinfos) do 
		if memberinfo ~= nil then 
			if  tostring(memberinfo["uid"]) == EginUser.Instance.uid then
				 table.insert(_playingPlayerList,this.userPlayerObj);
				 
				_reEnter = true;
				this:ReplaceNamePlayerCtrl(this.userPlayerObj.name,_nnPlayerName..EginUser.Instance.uid)
				this.userPlayerObj.name = _nnPlayerName..EginUser.Instance.uid;
				if SettingInfo.Instance.deposit then
					this.btnCancelTuoguan:SetActive(true);
					this.settingtuoguan.spriteName="special_on";
					this.settingtuoguanButton.normalSprite="special_on";
				else
					this.btnCancelTuoguan:SetActive(false);
					this.settingtuoguan.spriteName="special_off";
					this.settingtuoguanButton.normalSprite="special_off";
				end
				if SettingInfo.Instance.autoNext == true or SettingInfo.Instance.deposit  then
					this:UserReady();
				else
					this.btnReady:SetActive(true);					
				end                                 
				break;
			end	
		end
	end
	
	for index,value in pairs(memberinfos) do
		if(value ~= nil) then
			if( tostring(value["uid"]) ~= tostring( EginUser.Instance.uid ) ) then
				this:AddPlayer(value)
			end
		end
	end

	local deskinfo = body["deskinfo"];
	local t = tonumber(deskinfo ["continue_timeout"] );
	this:getPlayerCtrl(this.userPlayerObj.name):PlayerTimedown(t,false, false,0);

end


function this:AddPlayer(memberinfo) 
	otherUid =  tostring(memberinfo["uid"]);
	--log("创建人物")
	local uid = otherUid
	local bag_money =  tostring(memberinfo["bag_money"]);
	local nickname =  tostring(memberinfo["nickname"]);
	local avatar_no = tonumber(memberinfo["avatar_no"] );

	local level = memberinfo ["level"] ;
	local tempCtrl=   this:getPlayerCtrl(_nnPlayerName..uid);
	if tempCtrl ==nil then
		local player = NGUITools.AddChild(this.gameObject, this.dznnPlayerPrefab);
		player.name = _nnPlayerName..uid;
		this:bindPlayerCtrl(player.name, player)
		local anchor = player:GetComponent("UIAnchor");
		anchor.side = UIAnchor.Side.Top;
		anchor.relativeOffset.x = -0.3;
		anchor.relativeOffset.y = -0.08;
		
		local ctrl =   this:getPlayerCtrl(player.name);
		ctrl:SetPlayerInfo (avatar_no, nickname, bag_money, level);
		 table.insert(_playingPlayerList,player);
	end

end

--"body":866627772,"tag":"ready","type":"game"end
function this:ProcessReady(messageObj) 
	local uid = tostring(messageObj["body"]) ;
	local player = GameObject.Find (_nnPlayerName..uid);
	local ctrl =   this:getPlayerCtrl(player.name);
	--去掉牌型显示
	if uid == EginUser.Instance.uid then
        isOwnReady=true;
		--log("自己准备");
		--log(isOwnReady);
		ctrl:SetDeal(false, nil);
		ctrl:SetCardTypeUser(nil, 0);
		ctrl:SetScore(-1);
		ctrl:ClipReset(true);
		--显示准备
	    ctrl:SetReady(true);
	else
	    if #(tostring(uid))<8  then
		    if isStartGame then
			    ctrl:SetReady(true);
				isStartGame=false;
			else
			    otherReadyUid=uid;
			end
		else
			ctrl:SetDeal(false, nil);
			ctrl:SetCardTypeOther(nil, 0);
			ctrl:SetScore(-1);
			ctrl:ClipReset(false);
			--显示准备
		    ctrl:SetReady(true);
	    end
	end
	ctrl.isBanker = 0;
	
	
end

function this:OtherPlayerReady()
      --log("其他玩家准备");
      --log(otherReadyUid);  
	  --log(isOwnReady);
	if otherReadyUid~="" then
	    local player = GameObject.Find (_nnPlayerName..otherReadyUid);
		local ctrl =   this:getPlayerCtrl(player.name);
		ctrl:ClipReset(false);
    end
    if otherReadyUid~="" and  not isOwnReady then
		local player = GameObject.Find (_nnPlayerName..otherReadyUid);
		local ctrl =   this:getPlayerCtrl(player.name);
		ctrl:SetDeal(false, nil);
		ctrl:SetCardTypeOther(nil, 0);
		ctrl:SetScore(-1);
		ctrl:ClipReset(false);
		--显示准备
		ctrl:SetReady(true);
		otherReadyUid="";
	end
end

function this:UserReady() 
	--避免了已经点击过开始按钮但是还是有倒计时声音
	this:getPlayerCtrl(this.userPlayerObj.name):HideTimedown();
	--新的一句开始时去掉庄家标志
	if not IsNil(_bankerPlayer) then
		local bankerPlayerCtrl = this:getPlayerCtrl(_bankerPlayer.name)
		if bankerPlayerCtrl~=nil then
			bankerPlayerCtrl:SetBanker(false,false);
		end 
	end   
	--向服务器发送消息（开始游戏）
	local sendData = {type="dz20p", tag="start"}
	this.mono:SendPackage(cjson.encode(sendData)); 
	EginTools.PlayEffect (this.soundStart);
	this.btnReady:SetActive(false); 	
	--iTween.MoveTo(self.btnPanel.gameObject,iTween.Hash ("position", Vector3.New(0, -400, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));
end


function this:OnButtonClick( target)    
    --避免了已经点击过开始按钮但是还是有倒计时声音
	this:getPlayerCtrl(this.userPlayerObj.name):HideTimedown();
	--新的一句开始时去掉庄家标志
	if not IsNil(_bankerPlayer) then
		local bankerPlayerCtrl = this:getPlayerCtrl(_bankerPlayer.name)
		if bankerPlayerCtrl~=nil then
			bankerPlayerCtrl:SetBanker(false,false);
		end 
	end
	
	
	this.btnReady:SetActive(false); 	
	local sendData = nil;
	local tempNum=0;
	if target == this.button_begin then 	
		--print("aaaaaaaaaaaaaa");
		sendData = {type="dz20p", tag="show",body=1}
		EginTools.PlayEffect (this.soundStart);
        this.mono:SendPackage(cjson.encode(sendData)); 		
	elseif target == this.button_mingpai then  
		--print("bbbbbbbbbbbbbb");
		sendData = {type="dz20p", tag="show",body=2}
		this.mono:SendPackage(cjson.encode(sendData));	
	elseif target==this.button_miaosha then 
		--print("ccccccccccccccc");	
		sendData = {type="dz20p", tag="show",body=3}	
        this.mono:SendPackage(cjson.encode(sendData)); 	       
	end
	this:MPorMSMoveDown();
	--iTween.MoveTo(self.btnPanel.gameObject,iTween.Hash ("position", Vector3.New(0, -400, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));				
end

function this:OnButtonClick_1(target)
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
		if this.jiangchiBtn~=nil and this.jiangchiShow  then
			this.jiangchiBtn:SetActive(false);
		end
	elseif target==this.btn_setting or target==this.btn_help or target==this.btn_emotion or target==this.btn_shelet then
		this.btnXiala_bg.spriteName="button_down";
		this.btnXiala:GetComponent("UIButton").normalSprite="button_down";
		if this.jiangchiBtn~=nil and this.jiangchiShow  then
			this.jiangchiBtn:SetActive(true);
		end
	end
end


--"body":"uid":866627772,"timeout":15,"money_list":["money":10000,"uid":866627772end,"money":10000,"uid":120260end]end,"tag":"ask_banker","type":"dz20p"end
function this:ProcessAskbanker(messageObj) 
	--游戏开始，将_readyPlayerList中的玩家放入_playingPlayerList
	_isPlaying = true;
	--[[
	--清除未被清除的牌,清楚叫庄中提示
	for index, player in pairs(_playingPlayerList) do
		local ctrl =   this:getPlayerCtrl(player.name);
		if player ~= this.userPlayerObj then 
			ctrl:SetDeal (false, nil);
			ctrl:SetCardTypeOther(nil, 0);
			ctrl:SetScore(-1);
			ctrl:SetCallBanker(false);
			ctrl.isFanPai = false;
			log("====重置标记为")
		end
		--去掉“准备”
		ctrl:SetReady(false)
	end
	]]
	 for index, player in pairs(_playingPlayerList) do
		local ctrl =   this:getPlayerCtrl(player.name);	
		ctrl:SetReady(false)
	end
	
	local body = messageObj["body"];
	local uid = tostring(body["uid"])  ;
	local t = tonumber(body["timeout"]) ;
	--显示叫庄提示信息
	if uid == EginUser.Instance.uid then
		if this.despoite == 1  then
			this:UserCallBanker(this.btnCallBankers.transform:FindChild("Button1").gameObject);
		else
			this.btnCallBankers:SetActive(true);
			this:getPlayerCtrl(_nnPlayerName..otherUid):HideTimedown();
			this:getPlayerCtrl(this.userPlayerObj.name):PlayerTimedown(t, false, false,0);
			this:MoveTarget(this.btnCallBankers,this.btnCallBankerTargetTo.transform.localPosition.y, 0.3);
		end
	elseif  uid ~= EginUser.Instance.uid  and  not _late then
		if this.btnCallBankers.activeSelf then
			this:MoveTarget(this.btnCallBankers,this.btnCallBankerTargetFrom.transform.localPosition.y, 0.3);
		end
		  this:getPlayerCtrl(_nnPlayerName..uid):SetCallBanker(true);
		  this:getPlayerCtrl(_nnPlayerName..uid):PlayerTimedown(t,false, false,0);
	end
end

--{"body": {"showType": 1, "uid": 866627887}, "tag": "show", "type": "dz20p"}
function this:ProcessMPorMS(messageObj)
    local body = messageObj["body"];
	local showtype=tonumber(body["showType"]);
	local uid=tostring(body["uid"]);
	if uid==EginUser.Instance.uid then
	    if showtype==2 or showtype==3 then
			isOwnFanBei=true;
			if showtype==2 then
				ownMingpai=true;
			else 
				ownMiaosha=true;
			end
		else
            isOwnFanBei=false;		
		end		
	    this:getPlayerCtrl(_nnPlayerName..uid):HideTimedown();	
		this:getPlayerCtrl(_nnPlayerName..uid):SetMingpaiOrMiaosha(uid,showtype,otherUid);			
	else
	    if showtype==2 or showtype==3 then
			isOtherFanBei=true;
			if showtype==2 then
				otherMingpai=true;
			else 
				otherMiaosha=true;
			end
		else
		    isOtherFanBei=false;
		end		
	    this:getPlayerCtrl(_nnPlayerName..uid):HideTimedown();	
		this:getPlayerCtrl(_nnPlayerName..uid):SetMingpaiOrMiaosha(uid,showtype,EginUser.Instance.uid);	
	end
end

--{"body": {"timeout": 5}, "tag": "ask_show", "type": "dz20p"}
function this:ProcessAskShow(messageObj)
     isGameOver=false;
	--清除未被清除的牌,清楚叫庄中提示
	for index, player in pairs(_playingPlayerList) do
		local ctrl =   this:getPlayerCtrl(player.name);
		if player ~= this.userPlayerObj then 
			ctrl:SetDeal (false, nil);
			ctrl:SetCardTypeOther(nil, 0);
			ctrl:SetScore(-1);
			ctrl:SetCallBanker(false);
			ctrl.isFanPai = false;
			--log("====重置标记为")
		end
		--去掉“准备”
		ctrl:SetReady(false)
	end
		

     local body = messageObj["body"];
     local t=tonumber(body["timeout"]);	 	 	 
	 this:MPorMSMoveUp();
	 this:getPlayerCtrl(this.userPlayerObj.name):PlayerTimedown(t,true,false,1);	
     this:getPlayerCtrl(_nnPlayerName..otherUid):PlayerTimedown(t,false,false,0);	 
end

function this:MPorMSMoveUp()
   
	iTween.MoveTo(self.btnPanel.gameObject,iTween.Hash ("position", Vector3.New(0, 775, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));
end
function this:MPorMSMoveDown()

	iTween.MoveTo(self.btnPanel.gameObject,iTween.Hash ("position", Vector3.New(0, -200, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));
end


function this:UserCallBanker(btn) 
	local tempNum = 0;
	if btn.name == "Button1" then
		tempNum = 1;
		this.msgWaitBet:SetActive(true);
	end
	  this:getPlayerCtrl(this.userPlayerObj.name):HideTimedown();
	local sendData = {type="dz20p", tag="re_banker",body = tempNum}
	this.mono:SendPackage(cjson.encode(sendData));
	
	this:MoveTarget(this.btnCallBankers, this.btnCallBankerTargetFrom.transform.localPosition.y, 0.3);
end

--"body":"bid":120260,"chip":[2000,1000,500,250],"timeout":20end,"tag":"start_chip","type":"dz20p"end
function this:ProcessStartchip(messageObj) 
	for key,value in pairs(_playingPlayerList) do
		if(value ~= userPlayerObj)then
			local ctrl1 = this:getPlayerCtrl(value.name)
			ctrl1:SetCallBanker(false)
		end
	end
	if this.btnCallBankers.activeSelf then
		this:MoveTarget(this.btnCallBankers,this.btnCallBankerTargetFrom.transform.localPosition.y, 0.3);
	end

	local body = messageObj["body"];
	local bid = body["bid"] ;
	local t = tonumber(body["timeout"]) ;
	_bankerPlayer = GameObject.Find(_nnPlayerName..bid);
	 
	local ctrl =   this:getPlayerCtrl(_bankerPlayer.name);
	ctrl:SetCallBanker (false);
	ctrl.isBanker = 1;
	--庄家
	if _bankerPlayer == this.userPlayerObj then
		ctrl:SetBanker(true,true);
	else
		ctrl:SetBanker(true,false);
	end
	 
	if _bankerPlayer == this.userPlayerObj then 
		 iTableRemove(_playingPlayerList,this.userPlayerObj);
		 table.insert(_playingPlayerList,1,this.userPlayerObj); 
	else
		 ctrl:HideTimedown();
		  iTableRemove(_playingPlayerList,this.userPlayerObj);
		 table.insert(_playingPlayerList,this.userPlayerObj); 
	 
	end
	 
	local chip = body["chip"] ;
	if not _late  and  _bankerPlayer ~= this.userPlayerObj then
	
		--可选的筹码
		local temp = this:getPlayerCtrl(this.userPlayerObj.name);
		 temp:SetChip(chip,true);
		temp.isBanker = 2;
		local selectchip =  tonumber(chip[1]) ;
		if this.despoite == 1  then
			coroutine.start(this.AfterDoing,this,2, function()
				local sendData = {type="dz20p", tag="chip_in",body=selectchip}
				this.mono:SendPackage(cjson.encode(sendData))
			end);            
		end
		  temp:PlayerTimedown(t,false, false,0);
	else
		local temp = this:getPlayerCtrl(_nnPlayerName..otherUid)
		temp:SetChip(chip,false);
		temp.isBanker = 2;
		temp:PlayerTimedown(t,false, false,0);
		
	end
end

function this:ProcessChip(messageObj) 
	local infos = messageObj["body"] ;
	local uid = infos[1] ;
	local chip = tonumber(infos[2]) ;

	local player = GameObject.Find (_nnPlayerName..uid);
	 this:getPlayerCtrl(player.name):SetBet(chip);

	--如果收到主玩家的下注消息则隐藏可选筹码
	if player == this.userPlayerObj then 
		this.chooseChipObj:SetActive(false);
	end
	EginTools.PlayEffect (this.soundXiazhu);
end

--/ <summary>
--/ 将用户下注的筹码发送给服务器
--/ </summary>
--/ <param name='go'>
--/ Go.
--/ </param>
function this:UserChip(go) 
	local chip = tonumber(go.name);
	local sendData = {type="dz20p", tag="chip_in", body=chip}
	this.mono:SendPackage(cjson.encode(sendData));
end

--"body":"cards":[2,11],"chipnum":250,"timeout":5,"othercards":[40,16]end,"tag":"deal","type":"dz20p"end
--{"body": {"chipnum": 219670, "othertype": 0, "othercards": [29, 43], "timeout": 5, "cards": [37, 30], "type": 5}, "tag": "deal", "type": "dz20p"}
function this:ProcessDeal(messageObj) 
	--去掉“等待闲家下注”
	isOwnReady=false;
	if this.msgWaitBet.activeSelf then this.msgWaitBet:SetActive(false); end
    if not ownMiaosha  then
		this.buttonPanel:SetActive(true);
		this:SelectShowAndGet(false);
    end
	local body = messageObj["body"];
	local chip = tonumber(body["chipnum"]) ;
	local cards = body ["cards"] ;
	local othercards = body["othercards"] ;	
	local owntype = tonumber(body["type"]) ;
	local othertype = tonumber(body["othertype"]) ;
	chipcount = chip;
	owncardtype = owntype;
	
	--闲家选择下注筹码的动画
	if _bankerPlayer ~= this.userPlayerObj then		
	
		  this:getPlayerCtrl(this.userPlayerObj.name):SelectedChip(chip, false);		
	else 
		this:getPlayerCtrl(_nnPlayerName..otherUid):SelectedChip(chip,true);
	end
	EginTools.PlayEffect (this.soundXiazhu);

	local firstCard={};
	local secondCard={};
	if _bankerPlayer == this.userPlayerObj then
		 table.insert(firstCard,tonumber(cards[1]));
		 table.insert(firstCard,tonumber(othercards[1]));
		 table.insert(secondCard,tonumber(cards[2]));
		 table.insert(secondCard,tonumber(othercards[2]));
	else
		table.insert(firstCard,tonumber(othercards[1]));
		table.insert(firstCard,tonumber(cards[1]));
		table.insert(secondCard,tonumber(othercards[2]));
		table.insert(secondCard,tonumber(cards[2]));
	end
	local v = 0.1;
	local timeL = 0.2;
	local temp = 0;
	local tempt = 0;
	for i = 1, 2 do
		local num = i;
		temp = v;
		coroutine.start(this.AfterDoing,this,temp, function()			
			 this:getPlayerCtrl(_playingPlayerList[num].name):SetCard(0, firstCard[num],13,2,false,true,false,false,false,false,num,false);
			 this:getPlayerCtrl(_playingPlayerList[num].name ):HideTimedown();
		end);
		v = v +0.2;
	end
	coroutine.start(this.AfterDoing,this,temp, function()

		for j = 1,2 do
			local numb = j;
			tempt = timeL;
			coroutine.start(this.AfterDoing,this,tempt, function()
				if _playingPlayerList[numb] == this.userPlayerObj then
				      --log(isMiaoSha);
					  --log("自己这边");
				      if ownMiaosha then			
							--log("已经秒杀1");
					    --this:getPlayerCtrl(_playingPlayerList[numb].name):SetCard(1, secondCard[numb], owntype, 2, false, false,true,false,false,true,numb,isOtherFanBei);
						this:getPlayerCtrl(_playingPlayerList[numb].name):SetCard(1, secondCard[numb], owntype, 2, false, false,true,false,true,true,numb,isOtherFanBei);
					  else
						this:getPlayerCtrl(_playingPlayerList[numb].name):SetCard(1, secondCard[numb], owntype, 2, false, false,false,false,true,false,numb,isOtherFanBei);
					  end
				else
				     if otherMingpai or otherMiaosha then
						  --log(isMiaoSha);
						  --log("别人这边");
					    if otherMiaosha then
						    --log("已经秒杀2");
						    --this:getPlayerCtrl(_playingPlayerList[numb].name):SetCard(1, secondCard[numb], othertype, 2, false, false,true,false,false,true,numb,isOwnFanBei);
							this:getPlayerCtrl(_playingPlayerList[numb].name):SetCard(1, secondCard[numb], othertype, 2, false, false,true,false,false,true,numb,isOwnFanBei);
						else
						    this:getPlayerCtrl(_playingPlayerList[numb].name):SetCard(1, secondCard[numb], othertype, 2, false, false,false,false,false,false,numb,isOwnFanBei);
						end						
					 else
						this:getPlayerCtrl(_playingPlayerList[numb].name):SetCard(1, secondCard[numb], othertype, 2, true, true,false,false,false,false,numb,isOwnFanBei);
					 end
					  
				end 
                
			end);
			timeL = timeL +0.2;
		end 		
	end);
	--非late进入时才显示摊牌按钮
	if not _late then this.btnShow:SetActive(true); end 
	
end

--"body":"uid":120260,"timeout":5end,"tag":"ask_get","type":"dz20p"end
--"body":"cards":[40,16,30],"type":1,"uid":120260,"timeout":5end,"tag":"get","type":"dz20p"end
--"body":"cards":[40,16,30,18],"type":7,"uid":120260,"timeout":5end,"tag":"commit","type":"dz20p"end

function this:ProcessOk(messageObj)
	local body = messageObj["body"];
	local uid = tonumber(body["uid"]);
	local cards = body["cards"] ;
	local cardType = tonumber(body["type"]) ;
	local t=tonumber(body["timeout"] )
	--获取摊牌玩家摊牌时手里扑克牌的数量
	local cardcount =  #(cards);
	local commitPlayer = GameObject.Find(_nnPlayerName..uid);
	local playerCtrl = this:getPlayerCtrl(commitPlayer.name);
	
	local temprun = function()
		
		--获取摊牌玩家摊牌前手里扑克牌的数量
		local cardsShowcont=   playerCtrl:CheckShowCardsCount();

		--判断结算消息的延迟时间
		if _bankerPlayer == commitPlayer  and  cardType == -1 then
			banker_commit = true;
		else
			banker_commit = false;
		end
		if  tostring(uid) == EginUser.Instance.uid then
			ownTanpai=true;
			this.buttonPanel:SetActive(false);
			this:SelectShowAndGet(false);
			if cardsShowcont <  #(cards) then 
				this.userPlayerCtrl:SetCard(cardcount - 1, tonumber(cards[cardcount]) , cardType, cardcount, false, false,true,false,true,false,0,isOtherFanBei);
				
			else
				--this.userPlayerCtrl:SetCardTypeOther(cards, cardType);				
				this.userPlayerCtrl.secondCardType=cardType;
				this.userPlayerCtrl:setCommitCardType(true);				
			end
		else
			local player = GameObject.Find(_nnPlayerName..uid);
			if cardsShowcont <  #(cards) then
				 this:getPlayerCtrl(player.name ):SetCard(cardcount - 1, tonumber(cards[cardcount]) , cardType, cardcount, true, false,true,false,false,false,0,isOwnFanBei);
			else
				 --this:getPlayerCtrl(player.name ):SetCardTypeOther(cards, cardType);
				 this:getPlayerCtrl(player.name ).secondCardType=cardType;
				 this:getPlayerCtrl(player.name ):setCommitCardType(false);
			end
		end
		this:getPlayerCtrl(_nnPlayerName..uid):HideTimedown();
		 
	end
	
	
	if playerCtrl:setSecondCardType(false,false) then
		coroutine.start(this.AfterDoing,this,0.5, temprun);  
	else
		temprun();
	end
	
	
end

function this:UserShow()  
	if this.canTanpai then 
		--if SettingInfo.Instance.deposit then
			--this.despoite = 1;
		--else
			--this.despoite = 0;
		--end
		local sendData = {type="dz20p", tag="commit", body= this.despoite}
		this.mono:SendPackage(cjson.encode(sendData)) ;
	end
end

function this:UserGet()

	this.canTanpai = false;
	--if SettingInfo.Instance.deposit then 
		--this.despoite = 1;
	--else 
		--this.despoite = 0;
	--end

	if canget then  
		local sendData = {type="dz20p", tag="get", body=this.despoite}
		this.mono:SendPackage(cjson.encode(sendData));
		canget = false;
		coroutine.start(this.AfterDoing,this,1, function()
			canget = true;             
		end);
	end
end

function this:UserTuoguan(target)
	if target==this.btnTuoguan then
		SettingInfo.Instance.deposit = true;
		this.settingtuoguan.spriteName="special_on";
		this.settingtuoguanButton.normalSprite="special_on";
		this.buttonPanel:SetActive(false);
		this.btnCancelTuoguan:SetActive(true);
		this.despoite = 1;
		this.tuoguanzhong:SetActive(true);
		if owncardtype < 4 then
			this:UserGet();
		else 
			this:UserShow();
		end
	elseif target==this.btnCancelTuoguan then
		SettingInfo.Instance.deposit = false;
		this.settingtuoguan.spriteName="special_off";
		this.settingtuoguanButton.normalSprite="special_off";
		if ownTanpai then
			this.buttonPanel:SetActive(false);
		else
			this.buttonPanel:SetActive(true);
		end	
		this.btnCancelTuoguan:SetActive(false);
		this.despoite = 0;
		this.tuoguanzhong:SetActive(false);
	end
end
 
--"body":"infos":["cards":[2,11,5],"type":9,"uid":866627772,"final":250end,"cards":[40,16,30,18],"type":7,"uid":120260,"final":-250end],"timeout":20end,"tag":"game_over","type":"dz20p"end
function this:ProcessEnd(messageObj)  
    local body = messageObj["body"];
	--[玩家id, cards, 牌型, 输赢钱数]
	--uid:100000 , cards:[前三张 牛 后二张 几]  ,type:版型数值0-10 , final:结算-100end 
	local infos = body["infos"] ;

    coroutine.wait(2);
	for k,info in pairs(infos) do	
		local jos = info;
		local uid = tostring(jos["uid"])  		
		local player = GameObject.Find(_nnPlayerName..uid);
		if player ~= nil then		
			local ctrl =  this:getPlayerCtrl(player.name);			
			local cardtype=tonumber(jos["type"]);
			--log(uid);
			--log(cardtype);
			local cards = jos["cards"] ;
            if uid==EginUser.Instance.uid then
			    coroutine.start(ctrl.SetCardTypeUser,ctrl,cards,cardtype);
				--ctrl:SetCardTypeUser(cards,cardtype);
            else
				coroutine.start(ctrl.SetCardTypeOther,ctrl,cards,cardtype);
				--ctrl:SetCardTypeOther(cards,cardtype);
            end			
		end
	end
	coroutine.wait(1);
	
	for k,info in pairs(infos) do	
		local jos = info;
		local uid = tostring(jos["uid"])  		
		local player = GameObject.Find(_nnPlayerName..uid);
		if player ~= nil then		
			local ctrl =  this:getPlayerCtrl(player.name);			
			--得分
			local score = tonumber(jos["final"]) ;	
            if score>0 then
				ctrl:SetMingPaiMove(true);
			else
				ctrl:SetMingPaiMove(false);
			end			
		end
	end
    --if isFanBei then 
		--for index, player in pairs(_playingPlayerList) do
		    --local ctrl =   this:getPlayerCtrl(player.name);	
		    --ctrl:SetMingPaiMove();
	    --end		
	--end
	--ownCanMingpai=false;
	--otherCanMingpai=false;
	ownMingpai=false;
	ownMiaosha=false;
	otherMingpai=false;
	otherMiaosha=false;
	--isMiaoSha=false;
	if banker_commit then
		coroutine.wait(1);
	else
		coroutine.wait(1);
	end     
	local ChoumaList = {};--筹码的队列
	--去掉筹码显示
	for k, player in pairs(_playingPlayerList)  do
		  this:getPlayerCtrl(player.name):SetBet(0);
	end

	--去掉“摊牌”字样和下注额
	for  k,player in pairs(_playingPlayerList)  do
		if player ~= this.userPlayerObj then
			  this:getPlayerCtrl(player.name):SetShow(false);
		end
	end

	if this.msgWaitNext.activeSelf then this.msgWaitNext:SetActive(false); end


	
	--玩家扑克牌信息
	for k,info in pairs(infos) do
	
		local jos = info;
		local uid = tostring(jos["uid"])  
		local player = GameObject.Find(_nnPlayerName..uid);
		if player ~= nil then
		
			local ctrl =   this:getPlayerCtrl(player.name);			
			--牌型
			local cardType = tonumber(jos["type"]) ;
			--得分
			local score = tonumber(jos["final"]) ;

			--明牌
			if uid == EginUser.Instance.uid then
				--if cardType >= 10 then
					--EginTools.PlayEffect(this.soundNiuniu);
				--end
				if score > 0 then
					EginTools.PlayEffect(this.soundWin);
				else
					EginTools.PlayEffect(this.soundFail);
				end
			end
			if _bankerPlayer ~= player then
				coroutine.start(ctrl.SetBetScore,ctrl,score,chipcount, true,uid);
			else
				coroutine.start(ctrl.SetBetScore,ctrl,score, chipcount, false, uid);
			end
			--添加的玩家到桌子中间的筹码动画
		end
	end
	--遍历数组找到赢家的位置 获得赢家个数
	local nCountWiner = 0;--赢家个数
	local WinerTransform = {}
	for k,info in pairs(infos) do
	
		local jos = info;
		local uid = jos["uid"] ;
		local player = GameObject.Find(_nnPlayerName..uid);
		if player ~= nil then
		
			local ctrl =   this:getPlayerCtrl(player.name);
			local cards = jos["cards"] ;
			--牌型
			local cardType = tonumber(jos["type"] );
			--得分
			local score = tonumber(jos["final"]) ;

			if score > 0 then
				local temp = player.transform;
				 table.insert(WinerTransform,temp);
				nCountWiner=nCountWiner+1;
			end
		end
	end
	--设置每个赢家得到的筹码数量
	local nCount = 0;--每个赢家获得到的筹码数量
	local nBeginIndex = 0;--筹码开始的索引
	local nEndIndex = 0;--筹码结束的索引
	local nRemainChouma = 0;--余下的筹码

	nCount =  #(ChoumaList) / nCountWiner;
	if 0 ==  #(ChoumaList) % nCountWiner then
		for i = 0, nCountWiner-1 do
			if i == 0  then
				nBeginIndex = 0;
				nEndIndex = nCount;
			else
			
				nBeginIndex = i * nCount;
				nEndIndex = i * nCount + nCount;
			end
			this:SetChoumaToWiner(ChoumaList, nBeginIndex, nEndIndex, WinerTransform[i+1]);
		end
	else
		nRemainChouma =  #(ChoumaList) % nCountWiner;
		for i = 0, nCountWiner-1 do
			if i == 0 then
				nBeginIndex = 0;
				nEndIndex = nCount;
			else 
				nBeginIndex = i * nCount;
				nEndIndex = i * nCount + nCount;
			end
			if i == nCountWiner - 1 then
				nEndIndex = nEndIndex +nRemainChouma;
			end
			this:SetChoumaToWiner(ChoumaList, nBeginIndex, nEndIndex, WinerTransform[i+1]);
		end
	end

	if _late then
		EginTools.PlayEffect(this.soundEnd);
		_late = false;
	else 
		--this.btnReady.transform.localPosition = Vector3.New (367, -15, 0);
	end

	--log("游戏结束");
	--log(SettingInfo.Instance.autoNext);
	--log(this.despoite);
	if SettingInfo.Instance.autoNext == true or SettingInfo.Instance.deposit  then 
	    --log("托管");
		coroutine.wait(9);		
		--isFanBei=false;
		if not isOwnReady then
		    this:UserReady();
		end
	--[[
	else
		coroutine.wait(7);
		if not isOwnReady then
			isFanBei=false;
			this.buttonPanel:SetActive(false);
			this.btnReady:SetActive(true);
			--iTween.MoveTo(self.btnBegin.gameObject,iTween.Hash ("position", Vector3.New(0, 105, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));
			this:ChongZhi();  
		end	]]	
	end
	_isPlaying = false;
end


function this:setOwnReady()
    --log("自己是否准备");
    --log(isOwnReady);
	
    if not isOwnReady then
		isGameOver=true;
		this.buttonPanel:SetActive(false);
		if this.despoite==0  then
			this.btnReady:SetActive(true);		
		else
			this.btnReady:SetActive(false);	
		end
		--log("显示准备按钮");
		--iTween.MoveTo(self.btnBegin.gameObject,iTween.Hash ("position", Vector3.New(0, 105, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));
		this:ChongZhi();  
	end
	coroutine.start(this.PlayerLeave);	
end


function this:ProcessDeskOver(messageObj) 
end

function this:ProcessUpdateAllIntomoney(messageObj) 
	local msgStr = cjson.encode(messageObj)
	if(string.find(msgStr, tostring(EginUser.Instance.uid)) == nil)then
		return
	end
	
	local infos = messageObj ["body"] ;
	for index, value in pairs(infos) do
		local uid = value[1]
		local intoMoney = value[2]
		local player = find(_nnPlayerName .. uid)
		if(player ~= nil)then
			this:getPlayerCtrl(player.name):UpdateIntoMoney(intoMoney)
		end
	end
end

function this:ProcessUpdateIntomoney(messageObj) 
	--local intoMoney = messageObj["body"]
	--local info = find("FootInfo")
	--if(info ~= nil)then
	--	FootInfo:UpdateIntomoney(intoMoney) 
	--end
end

--"body":"memberinfos":["uid":866627772,"stream":"","bag_money":173868071,"into_money":10000,"sex":1,"is_staff":false,"ready":false,"client_address":"北京市",
--"wzcardnum":0,"winning":36,"waiting":true,"vip_level":0,"avatar_img":"","lose_times":1971,"win_times":1109,"mobile_type":3,"avatar_no":18,"is_authed":0,"keynum":24,
--"nickname":"bj123456789","user_honor":nil,"active_point":0,"level":6,"user_sign":nil,"exp":46294,"position":0end],"deskinfo":"top_money":500,"continue_timeout":20,
--"unit_money":200,"init_money":200,"max_player_num":2,"p2p":0endend,"tag":"enter","type":"game"end
function this:ProcessCome(messageObj) 
	bodyCome = messageObj["body"];
	if #(_playingPlayerList)==1 then
	     local memberinfo = bodyCome["memberinfo"];
	     this:AddPlayer(memberinfo);
		 bodyCome=nil;		 
	end
	if isGameOver then
	     this:PlayerCome();
	end
	
	
	
end


function this:PlayerCome()
    if  bodyCome~=nil then	
	     local memberinfo = bodyCome["memberinfo"];
	     this:AddPlayer(memberinfo);
		 bodyCome=nil;		
	end
end




function this:ProcessLeave(messageObj) 
     leaveUid=messageObj["body"];
     coroutine.start(this.PlayerLeave);	
	--local uid = messageObj["body"]		
end

function this:PlayerLeave()
   if  isGameOver and leaveUid~=""  then
       if(tostring(leaveUid)  ~= tostring( EginUser.Instance.uid) )then
			local player = GameObject.Find(_nnPlayerName .. leaveUid)
			this:removePlayerCtrl(player.name)
			if(tableContains(_playingPlayerList, player))then
				iTableRemove(_playingPlayerList, player)
			end		
			destroy(player);
			leaveUid="";
			coroutine.wait(0.5);
			this:PlayerCome();
		end
   end
end




function this:UserLeave() 
	local userLeave = {type="game",tag="leave",body=EginUser.Instance.uid}
	local jsonStr = cjson.encode(userLeave)
	this.mono:SendPackage(jsonStr)
end

function this:UserQuit() 
	SocketConnectInfo.Instance.roomFixseat = true
	this.mono:SendPackage( cjson.encode( {type="game", tag="quit"} ) )
	this.mono:OnClickBack()
end

--[[ ------ Button Click ------ ]]--
function this:OnClickBack () 
	if not _isPlaying then 
		this:UserQuit();
	else 
		this.msgQuit:SetActive(true);
	end
end

function this:ProcessNotcontinue() 
 
	this.msgNotContinue:SetActive(true);
	coroutine.wait (3);
	this:UserQuit();
end

function this:ShowPromptHUD( errorInfo) 
	this.btnReady:SetActive(false);
	--iTween.MoveTo(self.btnBegin.gameObject,iTween.Hash ("position", Vector3.New(0, -400, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));
	this.msgAccountFailed:SetActive(true);
	this.msgAccountFailed:GetComponentInChildren(Type.GetType("UILabel",true)).text = errorInfo;
	
end

function this:SetChoumaToWiner(ChoumaList,  nBeginIndex,  nEndIndex,  winer)

	coroutine.start(this.AfterDoing,this,0.3, function()
		local v = 0;
		for i = nBeginIndex+1, nEndIndex do
			local temp = v;
			local num = i;
			coroutine.start(this.AfterDoing,this,temp, function() 
				if not ChoumaList[num]:GetComponent("TweenPosition") then 
					--新增加一个组建，设置当前组建的效果
					local tweenpos = ChoumaList[num].gameObject.AddComponent("TweenPosition");
					tweenpos.from = ChoumaList[num].transform.localPosition;
					tweenpos.to = winer.transform.localPosition;
					tweenpos.duration = 0.3;
					local tempObj = ChoumaList[num].gameObject;
					coroutine.start(this.AfterDoing,this,0.3, function() 
						EginTools.PlayEffect(this.soundXiazhu);
						destroy(tempObj);
					end);
				end
			end);
			v =v + 0.08;
		end
	end);
end

--"body":"uid":866627772,"timeout":5end,"tag":"ask_get","type":"dz20p"end
function this:ProcessAskGetCard(messageObj)

	local body = messageObj["body"];
	local uid = tonumber(body["uid"]) ;
	local t=tonumber(body["timeout"]) ;
	if  tostring(uid) == EginUser.Instance.uid then 
		if this.despoite == 0 then 
			this:SelectShowAndGet(true);              
			this:getPlayerCtrl(this.userPlayerObj.name):setSecondCardType(true,false); 
			this:getPlayerCtrl(this.userPlayerObj.name):PlayerTimedown(t, true, true,2); 
		else 	
			this:SelectShowAndGet(false); 
			if owncardtype < 4 then 
				this:UserGet();
			else 
				this:UserShow();
			end
		end 
	else 
		this:SelectShowAndGet(false); 
		--log("开始翻牌");
		this:getPlayerCtrl(_nnPlayerName..otherUid):setSecondCardType(false,false);
		this:getPlayerCtrl(_nnPlayerName..otherUid):PlayerTimedown(t,false, true,0); 
	end

end 
--"body":"cards":[2,11,5],"type":9,"uid":866627772,"timeout":5end,"tag":"get","type":"dz20p"end
function this:ProcessGetCard(messageObj)
	
	local body = messageObj["body"];
	local uid = tonumber(body["uid"]) ;
	local cards = body["cards"] ;
	local cardType = tonumber(body["type"]) ;
	local t = tonumber(body["timeout"]) ;
	local playerCtrl = this:getPlayerCtrl(_nnPlayerName..uid);
	local temprun = function()
		owncardtype = cardType; 
		local cardcount =  #(cards);
		if  tostring(uid) == EginUser.Instance.uid then 
			playerCtrl:SetCard(cardcount - 1, tonumber(cards[cardcount]) ,cardType,cardcount,false,false,false,true,true,false,0,isOtherFanBei);
			playerCtrl:PlayerTimedown(t,true, true,2); 
		else  
			playerCtrl:SetCard(cardcount - 1, (cards[cardcount ] ), cardType,cardcount,true,false,false,true,false,false,0,isOwnFanBei);
			playerCtrl:PlayerTimedown(t,false, true,0);
		end
		if this.despoite == 1  then 
			coroutine.start(this.UserGetCards,this,(owncardtype));
		end 
	end
	
	if playerCtrl:setSecondCardType(false,false) then
		coroutine.start(this.AfterDoing,this,0.5, temprun);  
	else
		temprun();
	end
end 
function this:UserGetCards(cardtype)
	coroutine.wait(1.5);
	if cardtype < 4 then
		this:UserGet();
	else
		this:UserShow();
	end
end


function this:MoveTarget(gObj,  y,  timeL )  
 
	--log("iTween.MoveTo"..gObj.name)
	iTween.MoveTo(gObj,iTween.Hash ("y",y,"time", timeL,"islocal", true,"delay",0.5,"easeType", "easeInExpo"));
end

function this:SelectShowAndGet(isShowOrGet)
	 
	if isShowOrGet then 
	    this.buttonPanel:SetActive(true);
		this.btnShow:GetComponent("BoxCollider").enabled = true;
		this.btnShow.transform:FindChild("Background"):GetComponent("UISprite").alpha = 1;
		this.btnShow.transform:FindChild("Background"):GetComponent("UISprite").spriteName = "btn_tanpai";
		this.btnGetCards:GetComponent("BoxCollider").enabled = true;
		this.btnGetCards.transform:FindChild("Background"):GetComponent("UISprite").alpha = 1;
		this.btnGetCards.transform:FindChild("Background"):GetComponent("UISprite").spriteName = "btn_yaopai";
	else 
		this.buttonPanel:SetActive(false);
		this.btnShow:GetComponent("BoxCollider").enabled = false;
		this.btnShow.transform:FindChild("Background"):GetComponent("UISprite").alpha = 0.7;     
		this.btnShow.transform:FindChild("Background"):GetComponent("UISprite").spriteName = "btn_tanpaiclick";
		this.btnGetCards:GetComponent("BoxCollider").enabled = false;
		this.btnGetCards.transform:FindChild("Background"):GetComponent("UISprite").alpha = 0.7;
		this.btnGetCards.transform:FindChild("Background"):GetComponent("UISprite").spriteName = "btn_yaopaiclick";
	end
end

function this:ChongZhi()
	SettingInfo.Instance.deposit = false;
	this.btnTuoGuanSprite.spriteName = "btn_tuoguan";
	this.btnTuoguan.transform.parent = this.buttonPanel.transform
	--this.tuoguanzhong:SetActive(false);
	--this.btnCancelTuoguan:SetActive(false);
end

function this:AfterDoing(offset,  run,obj)
	coroutine.wait(offset) 
	if(this.gameObject == nil)then 
		return;
	end
	run(this,obj)
end   