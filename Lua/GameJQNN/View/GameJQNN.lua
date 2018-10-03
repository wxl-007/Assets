require "GameJQNN/JQNNPlayerCtrl"

local this = LuaObject:New()
GameJQNN = this

local _userIndex = 0
local _reEnter = false
local _late    = false
local _isPlaying = false
local _nnPlayerName = "NNPlayer_"
local _waitPlayerList = {}
local _playingPlayerList = {}
local _readyPlayerList = {}
local userPlayerObj --gameObject
local userPlayerCtrl --component
local keynum = 0;
local playerCtrlDc = {}
local isgameover=false;	
function this:bindPlayerCtrl(objName, gameObj)
	playerCtrlDc[objName] = JQNNPlayerCtrl:New(gameObj)
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

function this:clearLuaValue()
	print("clearLuaValue")
	_userIndex = 0
	_reEnter = false
	_late    = false
	_isPlaying = false
	_nnPlayerName = "NNPlayer_"
	_waitPlayerList = {}
	_playingPlayerList = {}
	_readyPlayerList = {}
	userPlayerObj = nil--gameObject
	userPlayerCtrl= nil --component
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	for k,v in pairs(playerCtrlDc) do
		v:OnDestroy()
	end	
	this.btnXiala=nil;
	this.btn_setting=nil;
	this.btn_help=nil;
	this.btn_emotion=nil;
	this.lateMessage=nil;
	this.jiangchiBtn=nil;
	isgameover=false;	
	this.jiangchiShow=false;
	playerCtrlDc = {}
	coroutine.Stop()
	LuaGC()
end

function this:handleBtnsFunc()
	this.lateMessage={};
	this.NNCount = this.transform:FindChild("Panel_Main/Content/NNCount/NNCount").gameObject:GetComponent("Animator")	
	this.NNCountNum = this.transform:FindChild("Panel_Main/Content/NNCount/NNCount/Sprite").gameObject:GetComponent("UILabel")	

	this.btnBegin = this:getUserObj("Button_begin").gameObject
	
	local backBtn = this.transform:FindChild("Panel_Main/Panel_button/Button_back").gameObject
	this.mono:AddClick(backBtn, this.OnClickBack)
	
	 local btn_MsgQuit = this.transform:FindChild("Panel_Main/Content/MsgContainer/MsgQuit/Button_yes").gameObject
	this.mono:AddClick(btn_MsgQuit, this.UserQuit)

	local btnBegin = this:getUserObj("Button_begin").gameObject
	this.mono:AddClick(btnBegin, this.UserReady)

	local btnShow = this:getUserObj("Button_show").gameObject
	this.mono:AddClick(btnShow, this.UserShow)
	this.betFly=ResManager:LoadAsset("gamenn/sound","nbet") ;
	this.betSound=ResManager:LoadAsset("gamenn/sound","Pool_Win") ;


	this.btnXiala=this.transform:FindChild("Panel_Main/Panel_button/Button_xiala").gameObject;
	this.btnXiala_bg=this.btnXiala.transform:FindChild("Background"):GetComponent("UISprite");
	this.mono:AddClick(this.btnXiala,this.OnButtonClick,this);
	this.btn_setting=this.transform:FindChild("Panel_Main/Panel_button/Button_xiala/panel/Button_setting").gameObject;
	this.btn_help=this.transform:FindChild("Panel_Main/Panel_button/Button_xiala/panel/Button_help").gameObject;
	this.btn_emotion=this.transform:FindChild("Panel_Main/Panel_button/Button_xiala/panel/Button_emotion").gameObject;
	this.btn_shelet=this.transform:FindChild("Panel_Main/Panel_button/Button_xiala/panel/shelet").gameObject;
	this.mono:AddClick(this.btn_setting,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_help,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_emotion,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_shelet,this.OnButtonClick,this);

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
	this.jiangchiShow=false;
end

function this:Awake()
Activity:ManualLock();
	log("------------------awake of GameJQNNPanel")
    --log(this.transform.root:GetComponent("UIRoot"))
   	this:handleBtnsFunc()
   	this.isStart = false;
   	local sceneRoot = this.transform.root:GetComponent("UIRoot")
 	if sceneRoot ~= nil then
  		local manualHeight = 1920
  		--[[if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
   			if UnityEngine.iPhone.generation:ToString().IndexOf("iPad") > -1 then
    			manualHeight = 1000; 
   			elseif Screen.width <= 960 then  -- iphone4s
   		 		manualHeight = 900;
   			end
  		end]]
  
  		--sceneRoot.scalingStyle= UIRoot.Scaling.ConstrainedOnMobiles;
  		sceneRoot.manualHeight = manualHeight;
  		sceneRoot.manualWidth  = 1080;
 	end
 


 	--Application.LoadLevelAdditive("FootInfo_TBNN");
 	--Application.LoadLevelAdditive("Game_Setting");
 	local footInfoPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalFootInfo")
 	--local settingPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalNewSettingPrb")
	GameObject.Instantiate(footInfoPrb)
	local footInfo = GameObject.Find("FootInfo")
	local btn_AddMoney = footInfo.transform:FindChild("MsgAddMoney/Button_yes").gameObject
	this.mono:AddClick(btn_AddMoney, this.OnAddMoney); 

	--local ObjSetting = GameObject.Instantiate(settingPrb)
 	if PlatformGameDefine.playform.IsPool then
  		--Application.LoadLevelAdditive("JiangChi");
  		local JiangChiPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalJiangChiPrb")
  		GameObject.Instantiate(JiangChiPrb)
		local JiangChi=GameObject.Find("VerticalJiangChiPrb(Clone)")
		--local firstJiangChi=JiangChi.transform:FindChild("PoolInfo/firstView").gameObject;
		--firstJiangChi.transform.localPosition=Vector3.New(-310,1000,0);
		local anchortarget=JiangChi.transform:FindChild('PoolInfo/firstView').gameObject:GetComponent("UIWidget");
		this.jiangchiBtn=JiangChi.transform:FindChild('PoolInfo/firstView').gameObject;
		anchortarget.leftAnchor.absolute = -450;
		anchortarget.rightAnchor.absolute = -142;
		anchortarget.bottomAnchor.absolute = -138;
		anchortarget.topAnchor.absolute = -14;
		anchortarget.bottomAnchor.relative = 1;
		anchortarget.topAnchor.relative = 1;
 	end
	 
	this.isStart = false;
	
 	SettingInfo.Instance.deposit = false;
        


end

function this:Start()
	log("lua log ------> Start of GameJQNN")
	if(SettingInfo.Instance.autoNext == true) then
		local btnBegin = this:getUserObj("Button_begin").gameObject
		btnBegin:SetActive(false)
	end
	
	this.mono:StartGameSocket()

	_isCallUpdate = true
	coroutine.start(this.UpdateInLua)
	coroutine.start(this.Update);
	Activity:SetScale(0.7429)
end

function this:Update()
    while this.mono do 
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
				this.NNCount:Play("time_anima");
				if this._currTime == 1 then
					EginTools.PlayEffect(this.soundCount);	 
				end
				this._currTime = this._currTime -0.1
				if this._currTime < 0 then
					this._currTime = 1;
				end
			else
				this.NNCount:Play("time_anima_default");
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
function this:SocketReceiveMessage(message)
	local message = self
	local cjson = require "cjson"
	local msgData = cjson.decode(message)
	local type1 = msgData["type"]
	local tag   = msgData["tag"]
	--print(message)
	if( type1 == "game") then
		print(message);
		if(tag == "enter") then
			this:ProcessEnter(msgData)
		elseif(tag == "ready") then
			if isgameover then
				table.insert(this.lateMessage,msgData);
			else
				this:ProcessReady(msgData)	
			end	
		elseif(tag == "come") then
			if isgameover then
				table.insert(this.lateMessage,msgData);
			else
				this:ProcessCome(msgData)	
			end	
		elseif(tag == "leave") then
			log(msgStr);
			if isgameover then
				table.insert(this.lateMessage,msgData);
			else
				this:ProcessLeave(msgData)
			end
		elseif(tag == "deskover") then
			this:ProcessDeskOver(msgData)
		elseif(tag == "notcontinue")then
			coroutine.start(this.ProcessNotcontinue)
		elseif tag=="newactfinish" then
				this:ProcessNewactfinish(msgData); 
		end
	elseif( type1 == "niu4p") then
		print(message);
		if(tag == "time") then
			local t = msgData["body"]
			this:UpdateHUD(t)
		elseif(tag == "late") then
			this:ProcessLate(msgData)
		elseif(tag == "ok") then
			this:ProcessOk(msgData)
		elseif(tag == "deal")then
			coroutine.start(this.ProcessDeal, msgData)
		elseif(tag == "end")then
			coroutine.start(this.ProcessEnd, msgData)
		end
	elseif(type1 == "seatmatch") then
		if(tag == "on_update") then
			this:ProcessUpdateAllIntomoney(msgData)
		end
	elseif(type1 == "niuniu") then
		if(tag == "pool") then
			log("lua ---> type = niuniu  tag = pool handle")
			if(PlatformGameDefine.playform.IsPool) then
				local info = find("PoolInfo")
				local chiFen = msgData["body"]["money"]
				local infos  = msgData["body"]["msg"]
				if(info ~= nil) then
					PoolInfo:show(chiFen, infos)
					this.jiangchiShow=true;
					--info:GetComponent("PoolInfo"):showByStr(chiFen, cjson.encode(infos))
				end
			end
			--新增奖池消息：
			--{'type': 'niuniu', 'tag': 'pool', 'body': {'money': 当前奖池金额, 'msg': *pm_msg}}
			--*pm_msg:[[昵称,累计积分],]
				
			--jchi.show(body.money,body.msg);
		elseif(tag == "mypool") then
			log(" my pool ")
			if (PlatformGameDefine.playform.IsPool) then
				local chiFen = msgData["body"]
				local info = find("PoolInfo")
				if(info ~= nil) then
					PoolInfo:setMyPool(chiFen)
					--info:GetComponent("PoolInfo"):setMyPool(chiFen)
				end
			end
			--更新自己的累计积分：
			--{'type': 'niuniu', 'tag': 'mypool', 'body': 自己的累计积分}
			--jchi.setJifei(body as Number);
			
		elseif(tag == "mylott") then
			log("mylott")
			--通知玩家获得名次奖励：
			--{'type': 'niuniu', 'tag': 'mylott', 'body': msg}
			--	msg：恭喜您获得牛牛奖池第%s名，共获得%s乐币！
			if(msgData["body"]["msg"] ~= nil)then
				local msg = msgData["body"]["msg"]
			else
				local msg = msgData["body"]
			end
			
			if (PlatformGameDefine.playform.IsPool) then
				local info = find("PoolInfo")
				if(info ~= nil) then
					PoolInfo:setMyPool(msg)
					--info:GetComponent("PoolInfo"):setMyPool(msg)
				end
			end
			
		end
	end 
end

function this:ChuLiXiaoXi()
	if isgameover then
		if #(this.lateMessage)>0 then
			local message=this.lateMessage[1];	
			--log("后续消息");
			--printf(this.lateMessage);
			--printf(message);
			
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

function this:ProcessNewactfinish(msgData)

	local body = msgData["body"];
	 
	local props = body["props"];
	  
	for index,value in pairs(props) do
		if value[1] == 104 then 
			Activity:SetAddBg(value[4]);
		end
	end 
	
end

function this:ProcessEnter(msgData)
	--print("lua log ---> ProcessEnter")
	--SettingInfo.Instance.deposit = false
	local body = msgData["body"]
	 
	local memberinfos = body["memberinfos"]
	userPlayerObj = this.transform:FindChild("Panel_Main/Content/User").gameObject
	--userPlayerCtrl = userPlayerObj:GetComponent("SRNNPlayerCtrl")
	for index,value in pairs(memberinfos) do
		--log(index)
		--print(value["uid"] .. " __ " .. EginUser.Instance.uid)
		--log(value["uid"] == EginUser.Instance.uid)
		--log(memberinfos[index]) = value
		if(value ~= nil) then
			if( tostring(value["uid"]) == tostring(EginUser.Instance.uid) ) then
				_userIndex = value["position"]
				local waiting = value["waiting"]
				
				if(waiting) then
					table.insert(_waitPlayerList, userPlayerObj) 
				else
					table.insert(_playingPlayerList, userPlayerObj)
					_reEnter = true
				end 
				local bagmoney=value["bag_money"];
				

				Activity:SetCountBgLabel(value["keynum"]);
				userPlayerObj.name = _nnPlayerName .. EginUser.Instance.uid;
				this:bindPlayerCtrl(userPlayerObj.name, userPlayerObj)
				userPlayerCtrl = this:getPlayerCtrl(userPlayerObj.name)
				userPlayerCtrl.MyMoney=tonumber(bagmoney);
				if (SettingInfo.Instance.autoNext == true) then
					this:UserReady()
				end
				break
			end
		end
		
	end

	
	for index,value in pairs(memberinfos) do
		if(value ~= null) then
			if( tostring(value["uid"]) ~= tostring( EginUser.Instance.uid ) ) then
				this:AddPlayer(value, _userIndex)
			end
		end
	end
	
	local deskinfo = body["deskinfo"]
	this:UpdateHUD(deskinfo["continue_timeout"])
	
end

function this:ProcessReady(msgData)
	print("ProcessReady")
	local uid = msgData["body"] 
	local player = GameObject.Find (_nnPlayerName .. uid)
	--local ctrl   = player:GetComponent("SRNNPlayerCtrl")
	if player then
		local ctrl   = this:getPlayerCtrl(player.name)
		
		--去掉牌型显示
		if( tostring(uid) == tostring(EginUser.Instance.uid) ) then
			coroutine.start(ctrl.SetDeal, ctrl, false, nil)
			ctrl:SetCardTypeUser(nil, 0,0)
			ctrl:SetScore(-1)
		else
			--如果主玩家已经重新开始，则清除当前用户的牌型显示
			if( not this.btnBegin.activeSelf )then
				coroutine.start(ctrl.SetDeal, ctrl, false, nil)
				ctrl:SetCardTypeOther(nil, 0,0)
				ctrl:SetScore(-1)
				ctrl:SetWait(false);
			end
		end
		
		
		--显示准备
		ctrl:SetReady(true)
		table.insert(_playingPlayerList, player)
	end
end

function this:ProcessCome(msgData) 
	local body = msgData["body"]
	local memberinfo = body["memberinfo"]
	local player = this:AddPlayer(memberinfo, _userIndex)
	if(_isPlaying)then
        this:getPlayerCtrl(player.name):SetWait(true)
	end

end

function this:ProcessLeave(msgData) 
	local uid = msgData["body"]
	if( tostring( uid)  ~= tostring( EginUser.Instance.uid) )then
		local player = GameObject.Find(_nnPlayerName .. uid)
		 
		this:removePlayerCtrl(player.name)

		if(tableContains(_playingPlayerList, player))then
			tableRemove(_playingPlayerList, player)
		end
		
		if(tableContains(_waitPlayerList, player))then
			tableRemove(_waitPlayerList, player)
		end
		
		destroy(player)
	end
	print("end ProcessLeave")

end

function this:ProcessDeskOver(msgData)
	--not use in this game
end

function this:ProcessNotcontinue()
	--log("ProcessNotcontinue coroutine ")
	this.transform:FindChild("Panel_Main/Content/MsgContainer/MsgNotContinue").gameObject:SetActive(true)
	coroutine.wait(3)
	--must be stop coroutine when this player quit 
	if(this.gameObject == nil)then
		error("stop coroutine in ProcessNotcontinue")
		return;
	end
	this:UserQuit()

end

-----jqnn---
------------
function this:ProcessLate(msgData)
	print("processLate")
	
	if(not _reEnter)then
		_late = true
		this.transform:FindChild("Panel_Main/Content/MsgContainer/MsgWaitNext").gameObject:SetActive(true)
	end
	--（late进入时不显示开始按钮，显示等待）
	local btnBegin = this:getUserObj("Button_begin").gameObject
	btnBegin:SetActive(false)

	local body = msgData["body"]
	local chip = body["chip"]
	local t = body["t"]
	
	--local gid  = body["gid"]
		
	this:UpdateHUD(t)

	if(tonumber(chip) > 0)then
		local infos = body["infos"]
		for index, value in pairs(infos) do
			local uid     = value[1]
			local waitNum = value[2]
			local showNum = value[3]
			local cards   = value[4]
			local cardType= value[5]

			local player = find(_nnPlayerName .. uid)
			if(player ~= nil)then
				local ctrl = this:getPlayerCtrl(player.name)
				if(tonumber(waitNum) == 0)then
					ctrl:SetBet(chip)
					if(player == userPlayerObj)then
						ctrl:SetLate(cards)
						if(tonumber(showNum) == 1)then
							ctrl:SetCardTypeUser(cards, cardType,0)
						else
							local btnShow = this:getUserObj("Button_show").gameObject
							btnShow:SetActive(true)
						end
					else
						--显示正在游戏的玩家的牌
						ctrl:SetLate(nil)
						if(tonumber(showNum) == 1)then
							ctrl:SetShow(true)
						end
					end
				else
					ctrl:SetWait(true)
				end
			end -- end if(player ~= nil)then
		end  --end for 
	end  -- end if(tonumber(chip) > 0)then

end

function this:ProcessOk(msgData)
	print("ProcessOk")
	local body = msgData["body"]
	local uid  = body["uid"]
	
	if( tostring( uid ) ~= tostring( EginUser.Instance.uid) )then
		local player = find(_nnPlayerName .. uid)
		if(player ~= nil)then
			--player:GetComponent("SRNNPlayerCtrl"):SetShow(true)
			this:getPlayerCtrl(player.name):SetShow(true)
		end
	else
		local cards = body["cards"]
		local cardType = body["type"]
		local isgold=tonumber(body["is_gold_nn"]);
		local player = find(_nnPlayerName .. uid)
		if isgold~=nil then
			this:getPlayerCtrl(player.name):SetCardTypeUser(cards, cardType,isgold)
		else
			this:getPlayerCtrl(player.name):SetCardTypeUser(cards, cardType,0)
		end
	end
	
	local soundTanover = ResManager:LoadAsset("gamenn/Sound","tanover") --resLoad("Sound/tanover")
	EginTools.PlayEffect (soundTanover)
	
end

function this.ProcessDeal(msgData)
	print("ProcessDeal")
	_isPlaying = true
	for key,player in pairs(_readyPlayerList) do
		if not tableContains(_playingPlayerList,player) then
			table.insert(_playingPlayerList,player)
		end
	end
	_readyPlayerList = {};
	
	--清除未被清除的牌
	for key,value in pairs(_playingPlayerList) do
		if(value ~= userPlayerObj)then
			local ctrl = this:getPlayerCtrl(value.name)
			coroutine.start(ctrl.SetDeal, ctrl, false, nil)
			ctrl:SetCardTypeOther(nil, 0,0)
			ctrl:SetScore(-1)
		end
	end
	--去掉“准备”
	for key,value in pairs(_playingPlayerList) do
		local ctrl = this:getPlayerCtrl(value.name)
		ctrl:SetReady(false)
		--TODO why??
		ctrl:SetBet(0)
	end

	local soundXiazhu = ResManager:LoadAsset("gamenn/Sound","xiazhu") --resLoad("Sound/xiazhu")
	EginTools.PlayEffect (soundXiazhu)

	local body = msgData["body"]
	local cards= body["cards"]
	local chip = body["chip"]
	local t = body["t"]
	this:UpdateHUD(t)

	--发牌
	for index, value in pairs(_playingPlayerList) do
		--log(value.name.."==正在玩的玩家");
		local ctrl = this:getPlayerCtrl(value.name)
		ctrl:SetBet(chip)
		if( value == userPlayerObj)then
			coroutine.start(ctrl.SetDeal, ctrl, true, cards)
		else 
			coroutine.start(ctrl.SetDeal, ctrl, true, nil)
		end
	end

	coroutine.wait(2.5)

	if(not _late)then

		if SettingInfo.Instance.deposit==true then
			coroutine.wait(1.5);
			if this.mono==nil then
				return;
			end
			this:UserShow();
		else
			local btnShow = this:getUserObj("Button_show").gameObject
			btnShow:SetActive(true)
		end
		
	end
	
end

function this.ProcessEnd(msgData)
	print("ProcessEnd1")
	isgameover=true;
	--去掉筹码显示
	for index, player in pairs(_playingPlayerList) do
		--player:GetComponent("SRNNPlayerCtrl"):SetBet(0)
		this:getPlayerCtrl(player.name):SetBet(0)
	end
	--去掉“摊牌”字样和下注额
	for index, player in pairs(_playingPlayerList) do
		if(player ~= userPlayerObj) then
			--player:GetComponent("SRNNPlayerCtrl"):SetShow(false)
			this:getPlayerCtrl(player.name):SetShow(false)
		end
	end

	 local msgWaitNext = this.transform:FindChild("Panel_Main/Content/MsgContainer/MsgWaitNext").gameObject
	 if(msgWaitNext.activeSelf) then
	 	msgWaitNext:SetActive(false)
	 end

	 _playingPlayerList = {}
	 

	 local body = msgData["body"]
	 local infos_2 = body["gold_nn"]
	 local infos_1=body["infos"];
	
	 local infos;
	 local has_gold=false;
	 if infos_2~=nil then
		infos=infos_2;
		has_gold=true;
	 else
		infos=infos_1;
		has_gold=false;
	 end
	 
	--新添加的飞金币判断
	local wincount=0;--赢家人数
	local winUidList={};--赢家列表
	local winList={};
	local loseUidList={};--输家列表
	local FalseBanker="";--赢钱少的玩家
	local TrueWinPlayer="";--赢钱多的玩家
	local loseposition=0;
	local winposition=0;
	local singleWinPosition=0;

	 for index,value in ipairs(infos) do
	 	local score = infos[index][4]
	 	local uid   = infos[index][1]
	 	if score>0  then
	 		wincount = wincount + 1
			table.insert(winUidList,tostring(uid));
			winList[tostring(uid)]=tonumber(score);

		else
			table.insert(loseUidList,tostring(uid));
	 	end
	 end

	 if wincount==2 then
	 	if winList[winUidList[1]]<winList[winUidList[2]] then
		 	FalseBanker=winUidList[1];
			TrueWinPlayer=winUidList[2];
		else
			FalseBanker=winUidList[2];
			TrueWinPlayer=winUidList[1];
		end
		--log(FalseBanker);
		--log("赢钱较少的玩家");
		local player1 = find(_nnPlayerName .. FalseBanker)
		local ctrl = this:getPlayerCtrl(player1.name)
		loseposition=ctrl.movetarget.transform.position   --飞金币的位置

		local player2 = find(_nnPlayerName .. TrueWinPlayer)
		local ctr2 = this:getPlayerCtrl(player2.name)
		winposition=ctr2.movetarget.transform.position
	 end


	

	 --玩家扑克牌信息
	 for key,info in pairs(infos) do
	 	local jos = info
	 	local uid = jos[1]
	 	local player = find(_nnPlayerName .. uid)
	 	
	 	if(player ~= nil)then
	 		--local ctrl = player:GetComponent("SRNNPlayerCtrl")
	 		local ctrl = this:getPlayerCtrl(player.name)
	 		local cards = jos[2]
	 		--牌型
	 		local cardType = jos[3]
	 		--得分
	 		local score = jos[4]
			local isgold;--是否黄金牛牛
			local isgold_win;--黄金牛牛奖励
			--log("has_gold");
			--log(has_gold);
			if has_gold then
				isgold=tonumber(jos[5]);   --是否为黄金牛牛
				jiangli_money=tonumber(jos[6]);  --奖励金钱数
			else
				isgold=0;
			end
			
			
	 		--明牌
	 		if( tostring(uid) ~= tostring(EginUser.Instance.uid)  )then
	 			ctrl:SetCardTypeOther(cards, cardType,isgold)
	 		else
	 			local btnShow = this:getUserObj("Button_show").gameObject
				if(btnShow.activeSelf)then
					btnShow:SetActive(false)
					ctrl:SetCardTypeUser(cards, cardType,isgold)
				end
				if isgold==1 then
					ctrl:SetJiangLi(jiangli_money)
				end
				
				if(cardType == 10)then
					EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","niuniu") )
				end
				if(score > 0)then
					EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","win") )
				else
					EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","fail"))
				end
	 		end
			coroutine.wait(0.1);
	 	end
	 end  --end for key,info in pairs(infos) do
	coroutine.wait(1);

	for key,info in ipairs(infos) do
			local jos = info
			local uid = tostring(jos[1])
			local uiAnchor = GameObject.Find(_nnPlayerName..uid)
			local score = jos[4]	--得分
			local ctrl=nil;
			--local sideposition="";
			if uiAnchor~=nil then
				ctrl = this:getPlayerCtrl(uiAnchor.name)
				--sideposition = uiAnchor:GetComponent("UIAnchor").side:ToString(); 
				if has_gold then
					if uid==EginUser.Instance.uid then
						ctrl:SetScore(score,jos[7])
					else
						ctrl:SetScore(score,jos[7])
					end
				else
					if uid==EginUser.Instance.uid then
						ctrl:SetScore(score,jos[5])
					else
						ctrl:SetScore(score,jos[5])
					end
				end
			end	
			--ctrl:ChoumaPosition(sideposition,this.endTargetPosition)
	end
	
	if wincount==1 then
		local player1 = find(_nnPlayerName .. winUidList[1])
		local ctrl = this:getPlayerCtrl(player1.name)
		singleWinPosition=ctrl.movetarget.transform.position;
		for i=1,#(loseUidList) do
			this:getPlayerCtrl(_nnPlayerName..loseUidList[i]):SetFlyBetAnimation(singleWinPosition,loseUidList[i]);
		end
		coroutine.start(this.AfterDoing, 0.2, function()
			--[[
			for i=1,8 do
				if(this.gameObject == nil)then
					return;
				end
				EginTools.PlayEffect(this.betFly);	
				coroutine.wait(0.02)
			end
			]]
			EginTools.PlayEffect(this.betSound);	
		end)
	elseif wincount==2 then
		for i=1,#(loseUidList) do
			this:getPlayerCtrl(_nnPlayerName..loseUidList[i]):SetFlyBetAnimation(loseposition,loseUidList[i]);
		end
		coroutine.start(this.AfterDoing, 0.2, function()
			--[[
			for i=1,8 do
				if(this.gameObject == nil)then
					return;
				end
				EginTools.PlayEffect(this.betFly);	
				coroutine.wait(0.02)
			end
			]]
			EginTools.PlayEffect(this.betSound);	
		end)
		coroutine.wait(1.2)
		this:getPlayerCtrl(_nnPlayerName..FalseBanker):SetFlyBetAnimation(winposition,FalseBanker);
		coroutine.start(this.AfterDoing, 0.2, function()
			--[[
			for i=1,8 do
				if(this.gameObject == nil)then
					return;
				end
				EginTools.PlayEffect(this.betFly);	
				coroutine.wait(0.02)
			end
			]]
			EginTools.PlayEffect(this.betSound);	
		end)
	end


	coroutine.wait(1.8);
	this.ChuLiXiaoXi();
	

	 --去掉所有等待中玩家的”等待中“， 显示开始换桌按钮
	for k,player in pairs(_waitPlayerList) do
	 	if(player ~= userPlayerObj)then
	 		this:getPlayerCtrl(player.name):SetWait(false)
	 		--[[if(not tableContains(_playingPlayerList, player))then
	 			table.insert(_playingPlayerList, player)
	 		end]]
	 	end
	end

	_waitPlayerList = {}

	if(_late)then
	 	EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","GAME_END"))
	 	_late = false
	else
	 	local btnBegin = this:getUserObj("Button_begin").gameObject
		--btnBegin.transform.localPosition = Vector3.New(300, 0, 0)
	end

	if(SettingInfo.Instance.autoNext == true or SettingInfo.Instance.deposit == true )then
	 	coroutine.wait(2)
	 	this:UserReady()

	else
	 	local btnBegin = this:getUserObj("Button_begin").gameObject
		btnBegin:SetActive(true)
	end
	
	local t = body["t"]
	this:UpdateHUD(t)

	_isPlaying = false
	
end

function this:ProcessUpdateAllIntomoney(msgData)
	--print("ProcessUpdateAllIntomoney")
	local msgStr = cjson.encode(msgData)
	if(string.find(msgStr, tostring(EginUser.Instance.uid)) == nil)then
		return
	end
	
	local infos = msgData["body"]
	for index, value in pairs(infos) do
		local uid = value[1]
		local intoMoney = value[2]
		local player = find(_nnPlayerName .. uid)
		if(player ~= nil)then
			--player:GetComponent("SRNNPlayerCtrl"):UpdateIntoMoney(intoMoney)
			this:getPlayerCtrl(player.name):UpdateIntoMoney(intoMoney)
		end
	end
	
end

function ProcessUpdateIntomoney( messageObj )
	print("ProcessUpdateIntomoney")
	local intoMoney = messageObj["body"]
	local info = find("FootInfo")
	if(info ~= nil)then
		FootInfo:UpdateIntomoney(intoMoney)
		--info:GetComponent("FootInfo"):UpdateIntomoney(intoMoney)
	end
end

function this:UserLeave()
	local userLeave = {type="game",tag="leave",body=EginUser.Instance.uid}
	local jsonStr = cjson.encode(userLeave)
	this.mono:SendPackage(jsonStr)
end

function this:UserQuit()
	--log("UserQuit")
	SocketConnectInfo.Instance.roomFixseat = true
	this.mono:SendPackage( cjson.encode( {type="game", tag="quit"} ) )
	this.mono:OnClickBack()

end

function this:UserChip(go)
	--print("send {'type':'srnn', 'tag':'chip_in', 'body':**}")
	local chip = go.name
	local jsonObj = { type="srnn", tag="chip_in", body=chip }
	local jsonStr = cjson.encode(jsonObj)
	this.mono:SendPackage(jsonStr)
end

function this:UserReady()
	--log("lua -> UserReady")
	--避免了已经点击过开始按钮但是还是有倒计时声音
	--[[if(NNCount.Instance)then
		NNCount.Instance:DestroyHUD()
	end]]
	
	--"{'type':'srnn','tag':'start'}"
	--向服务器发送消息（开始游戏）
	if(this.mono == nil)then
		return
	end
	local sendData = {type="niu4p", tag="start"}

	this.mono:SendPackage(cjson.encode(sendData))
	local audioClip = ResManager:LoadAsset("gamenn/Sound","GAME_START") --resLoad("Sound/GAME_START")
	EginTools.PlayEffect(audioClip)
	
	local btnBegin = this:getUserObj("Button_begin").gameObject
	btnBegin:SetActive(false)
	--log("lua -> end  UserReady")
end

function this:UserShow()
	print("UserShow")
	this.mono:SendPackage(cjson.encode( {type="niu4p", tag="ok"} ) )
	local btnShow = this:getUserObj("Button_show").gameObject
	btnShow:SetActive(false)
end

function this:AddPlayer(memberinfo, _userIndex)
	print("AddPlayer")
	local uid = memberinfo["uid"]
	local bag_money = memberinfo["bag_money"]
	local nickname = memberinfo["nickname"]
	local avatar_no = memberinfo["avatar_no"]
	local position = memberinfo["position"]
	local ready = memberinfo ["ready"]
	local waiting = memberinfo["waiting"]
	local level = memberinfo ["level"]
	
	local contentObj = this.transform:FindChild("Panel_Main/Content").gameObject
	local playerPrb = ResManager:LoadAsset("gamejqnn/jqnnplayer","JQNNPlayer")
	local player = NGUITools.AddChild(contentObj, playerPrb)
	player.name = _nnPlayerName .. uid
	this:SetAnchorPosition(player, _userIndex, position)
	--local ctrl = player:GetComponent("SRNNPlayerCtrl")
	this:bindPlayerCtrl(player.name, player)
	local ctrl = this:getPlayerCtrl(player.name)
	ctrl:SetPlayerInfo (avatar_no, nickname, bag_money, level)
	
	if (waiting) then
		if( ready ) then
			--ctrl:SetReady(true)
			table.insert(_readyPlayerList, player)
		end
		table.insert(_waitPlayerList, player)
	else
		table.insert(_playingPlayerList, player)
	end
	
	return player

end

function this:SetAnchorPosition(player, _userIndex, playerIndex)
	print("setAnchorPosition")
	local position_span = playerIndex - _userIndex
	local anchor = player:GetComponent("UIAnchor")
	if(position_span == 0) then
		anchor.side = UIAnchor.Side.Bottom
	elseif (position_span == 1 or position_span == -3) then
		anchor.side = UIAnchor.Side.Right
		--anchor.relativeOffset.x = -0.095
		--anchor.relativeOffset.y = 0.025
		anchor.relativeOffset = Vector2.New(-0.09, 0.08)
	elseif (position_span == 2 or position_span == -2) then
		anchor.side = UIAnchor.Side.Top
		--anchor.relativeOffset.x = -0.1
		--anchor.relativeOffset.y = -0.158
		anchor.relativeOffset = Vector2.New(0, -0.049)
	elseif(position_span == 3 or position_span == -1) then
		anchor.side = UIAnchor.Side.Left
		--anchor.relativeOffset.x = 0.09
		--anchor.relativeOffset.y = 0.025
		anchor.relativeOffset = Vector2.New(0.09, 0.08)
	end
end


function this:OnClickBack()
	--TODO  maybe need ignore base.OnClickBack()
	if(not _isPlaying)then
		this:UserQuit()
	else
		local msgQuit = this.transform:FindChild("Panel_Main/Content/MsgContainer/MsgQuit").gameObject
		msgQuit:SetActive(true)
	end
end

function this:ShowPromptHUD( errorInfo )
	--TODO  maybe need ignore base.ShowPromptHUD(errorInfo)
	local btnBegin = this:getUserObj("Button_begin").gameObject
	btnBegin:SetActive(false)
	local msgAccountFailed = this.transform:FindChild("Panel_Main/Content/MsgContainer/MsgAccountFailed").gameObject
	msgAccountFailed:SetActive(true)
	local luaErrorInfo = "lua error info"
	if(errorInfo == nil)then
		luaErrorInfo = self
	else
		luaErrorInfo = errorInfo
	end
	msgAccountFailed:GetComponent("UILabel").text = tostring(luaErrorInfo)
end

function this:getUserObj( objName )
	local targetObj = this.transform:FindChild("Panel_Main/Content/".. _nnPlayerName .. EginUser.Instance.uid .."/"..objName)
	--print("find-->" .. "Content/".. _nnPlayerName .. EginUser.Instance.uid .."/"..objName)
	if(targetObj == nil)then
		targetObj = this.transform:FindChild("Panel_Main/Content/User/".. objName)
		--print("find-->" .. "Content/User/".. objName)
	end
	return targetObj
end

function this.AfterDoing( offset, run )
	coroutine.wait(offset)
	--must be stop coroutine when this player quit 
	if(this.gameObject == nil)then
		error("##stop coroutine in AfterDoing")
		return;
	end
	run()
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

local rechatge = nil;
function this:OnAddMoney()  
  rechatge =  GameObject.Instantiate(this.Module_Recharge) 
  local rechatgeTrans = rechatge.transform;
  
  rechatgeTrans.parent = this.transform;
  rechatgeTrans.localScale = Vector3.one;
  
  rechatge:GetComponent("UIPanel").depth = 2100; 
  
  local sceneRoot = this.transform.root:GetComponent("UIRoot")
  
  if sceneRoot then 
    sceneRoot.manualHeight = 1920;
    sceneRoot.manualWidth = 1080;
  end 


  this.Module_RechargeLua.GameFunction = this.GameFunction;
   
  
  EginTools.PlayEffect(this.but);
end

function this:GameFunction()  
   local sceneRoot = this.transform.root:GetComponent("UIRoot")
  if sceneRoot then 
    sceneRoot.manualHeight = 1920;
    sceneRoot.manualWidth = 1080;
  end 
  sceneRoot = GameSettingManager.transform.root:GetComponent("UIRoot")
  if sceneRoot then 
    sceneRoot.manualHeight = 1920;
    sceneRoot.manualWidth = 1080;
  end 
  destroy(rechatge) 
end


--this Update call only in Lua layer
function this:UpdateInLua()
	--print("lua update")
	while(this.mono) do
		for k,v in pairs(playerCtrlDc) do
			if(v == nil)then
				print("?????")
			else
				v:UpdateInLua()
			end
		end
		coroutine.wait(0.5)
	end
end

function this:OnDestroy()
	log("--------------------ondestroy of GameJQNNPanel")
	this:clearLuaValue()
end
