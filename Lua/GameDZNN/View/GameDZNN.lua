require "GameDZNN/DZNNPlayerCtrl"

local this = LuaObject:New()
GameDZNN = this

local _reEnter = false
local _late    = false
local _isPlaying = false
local _nnPlayerName = "NNPlayer_"
local _playingPlayerList = {}
local userPlayerObj --gameObject
local userPlayerCtrl --component
local _bankerPlayer --gameObject
local chooseChipObj --gameObject
local isgameover=false;
local otherUid = "0"

local playerCtrlDc = {}

function this:bindPlayerCtrl(objName, gameObj)
	playerCtrlDc[objName] = DZNNPlayerCtrl:New(gameObj)
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
	_reEnter = false
	_late    = false
	_isPlaying = false
	_nnPlayerName = "NNPlayer_"
	_playingPlayerList = {}
	userPlayerObj = nil--gameObject
	userPlayerCtrl= nil --component
	_bankerPlayer = nil
	chooseChipObj = nil
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	for k,v in pairs(playerCtrlDc) do
		v:OnDestroy()
	end
	this.lateMessage=nil;
	this.jiangchiBtn=nil;
	isgameover=false;
	this.jiangchiShow=false;
	playerCtrlDc = {}
	coroutine.Stop()
	LuaGC()
end

function this:handleBtnsFunc()
	this.NNCount = this.transform:FindChild("Content/NNCount").gameObject:GetComponent("Animator")	
	this.NNCountNum = this.transform:FindChild("Content/NNCount/Sprite").gameObject:GetComponent("UILabel")	
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


	print(this.gameObject.name ..'-------------------')
	this.btnBegin = this:getUserObj("Button_begin").gameObject
	
	 local backBtn = this.transform:FindChild("Panel_button/Button_back").gameObject
	 this.mono:AddClick(backBtn, this.OnClickBack)

	 local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
	this.mono:AddClick(btn_MsgQuit, this.UserQuit)

	local btnBegin = this:getUserObj("Button_begin").gameObject
	this.mono:AddClick(btnBegin, this.UserReady)

	local btnShow = this:getUserObj("Button_show").gameObject
	this.mono:AddClick(btnShow, this.UserShow)

	local callBankerBtn = this:getUserObj("BtnCallBanker/Button1").gameObject
	this.mono:AddClick(callBankerBtn, 
		function ()
			this.mono:SendPackage( cjson.encode({type="niu2p", tag="re_banker", body=1}) )
			this.transform:FindChild("Content/MsgContainer/MsgWaitBet").gameObject:SetActive(true)
			this:getUserObj("BtnCallBanker").gameObject:SetActive(false)
		end
	)

	local giveupBtn = this:getUserObj("BtnCallBanker/Button0").gameObject
	this.mono:AddClick(giveupBtn, 
		function ()
			this.mono:SendPackage( cjson.encode({type="niu2p", tag="re_banker", body=0}) )
			this:getUserObj("BtnCallBanker").gameObject:SetActive(false)
		end

	)

	--4  chip btn
	local chooseChipObj = this:getUserObj("ChooseChips").gameObject					
	local btns = chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true), true)
	--local len  = btns.Length
	for i=0, btns.Length-1 do
		local btn = btns[i].gameObject
		if(string.find(btn.name, "Button") ~= nil)then
			this.mono:AddClick(btn, 
				function ()
					print("send {'type':'niu2p', 'tag':'chip_in', 'body':**}")
					local chip = tonumber( btn.name )
					print("chip price:" .. chip)
					local jsonObj = { type="niu2p", tag="chip_in", body=chip }
					local jsonStr = cjson.encode(jsonObj)
					this.mono:SendPackage(jsonStr)
				end
			)
		end
	end -- end for index , value in ipairs(btns) do

	this.btnXiala=this.transform:FindChild("Panel_button/Button_xiala").gameObject;
	this.btnXiala_bg=this.btnXiala.transform:FindChild("Background"):GetComponent("UISprite");
	this.mono:AddClick(this.btnXiala,this.OnButtonClick,this);
	this.btn_setting=this.transform:FindChild("Panel_button/Button_xiala/panel/Button_setting").gameObject;
	this.btn_help=this.transform:FindChild("Panel_button/Button_xiala/panel/Button_help").gameObject;
	this.btn_emotion=this.transform:FindChild("Panel_button/Button_xiala/panel/Button_emotion").gameObject;
	this.btn_shelet=this.transform:FindChild("Panel_button/Button_xiala/panel/shelet").gameObject;
	this.mono:AddClick(this.btn_setting,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_help,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_emotion,this.OnButtonClick,this);
	this.mono:AddClick(this.btn_shelet,this.OnButtonClick,this);
	this.jiangchiShow=false;
end

function this:Awake()
	log("------------------awake of GameDZNNPanel")
    --log(this.transform.root:GetComponent("UIRoot"))
   	this:handleBtnsFunc()
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
 
 	--Application.LoadLevelAdditive("Game_Setting");
 	local footInfoPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalFootInfo")
 	--local settingPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalNewSettingPrb")
	GameObject.Instantiate(footInfoPrb)
	--GameObject.Instantiate(settingPrb)

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
 
	local footInfo = GameObject.Find("FootInfo")
	local btn_AddMoney = footInfo.transform:FindChild("MsgAddMoney/Button_yes").gameObject
	this.mono:AddClick(btn_AddMoney, this.OnAddMoney);
 	--SettingInfo.Instance.deposit = false;
        
    --[[
    SettingInfo.Instance.deposit = false;
    --]]
end

function this:Start()
	log("lua log ------> Start of GameDZNN")
	if(SettingInfo.Instance.autoNext == true) then
		local btnBegin = this:getUserObj("Button_begin").gameObject
		btnBegin:SetActive(false)
	end
	
	this.mono:StartGameSocket()

	_isCallUpdate = true
	coroutine.start(this.UpdateInLua)
	coroutine.start(this.Update);
end

function this:SocketReceiveMessage(message)
	local msgStr = self
	local cjson = require "cjson"
	local msgData = cjson.decode(msgStr)
	local type1 = msgData["type"]
	local tag   = msgData["tag"]
	
	if( type1 == "game") then
		if(tag == "enter") then
			log(msgStr);
			this:ProcessEnter(msgData)
		elseif(tag == "ready") then
			log(msgStr);
			if isgameover then
				table.insert(this.lateMessage,msgData);
			else
				this:ProcessReady(msgData)
			end	  
		elseif(tag == "come") then
			log(msgStr);
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
		end
	elseif( type1 == "niu2p") then
		if(tag == "time") then
			local t = msgData["body"]
			this:UpdateHUD(t);
		elseif(tag == "re_enter") then
			log(msgStr);
			this:ProcessLate(msgData)
		elseif(tag == "commit") then
			log(msgStr);
			this:ProcessOk(msgData)
		elseif(tag == "ask_banker")then
			log(msgStr);
			this:ProcessAskbanker(msgData)
		elseif(tag == "start_chip")then
			log(msgStr);
			this:ProcessStartchip(msgData)
		elseif(tag == "deal")then
			log(msgStr);
			coroutine.start(this.ProcessDeal, this,msgData)
		elseif(tag == "game_over")then
			log(msgStr);
			coroutine.start(this.ProcessEnd, msgData)
		end
	elseif(type1 == "seatmatch") then
		if(tag == "on_update") then
			this:ProcessUpdateAllIntomoney(msgData)
		end
	elseif(type1 == "niuniu") then
		if(tag == "pool") then
			log("奖池");
			print("lua ---> type = niuniu  tag = pool handle")
			if(PlatformGameDefine.playform.IsPool) then
				print("PlatformGameDefine.playform.IsPool = true")
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
			print(" my pool ")
				log("我的奖池");
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
			print("mylott")
			log("我的名次");
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
	
	-----debug scocket message------
	--if(type1 == "game" and tag == "enter")then
	--	local simulaStr = "{\"body\": {\"msg\": [[\"zxc01230\", 10985002920.0, 889276700], [\"Hugfdss\", 7765577760.0, 889129871], [\"lirenjie8\", 6512094000.0, 889063854], [\"输赢论英雄\", 6410005647.0, 123716054], [\"不辜负车站\", 3213691980.0, 888908959], [\"工具记录\", 2863585596.0, 889327107], [\"liumin369\", 2183031549.0, 889276391], [\"吃飯睡覺打豆豆。\", 2050792071.0, 889166457]], \"money\": 807966934}, \"tag\": \"pool\", \"type\": \"niuniu\"}";
	--[[
		local cjson1 = require "cjson"
		local msgData1 = cjson1.decode(simulaStr)
		local type11 = msgData1["type"]
		local tag1   = msgData1["tag"]

		if(type11 == "niuniu" and tag1 == "pool") then
			if(PlatformGameDefine.playform.IsPool) then
				print("PlatformGameDefine.playform.IsPool = true")
				local info = find("PoolInfo")
				local chiFen = msgData1["body"]["money"]
				local infos  = msgData1["body"]["msg"]
				if(info ~= nil) then
					PoolInfo:show(chiFen, infos)
				end
			end
		end
		
		local simulaStr2 = "{\"body\": 4219, \"tag\": \"mypool\", \"type\": \"niuniu\"}";
		local msgData2 = cjson1.decode(simulaStr2)
		local type2  = msgData2["type"]
		local tag2   = msgData2["tag"]
		if(type2 == "niuniu" and tag2 == "mypool") then
			if (PlatformGameDefine.playform.IsPool) then
				local chiFen = msgData2["body"]
				local info = find("PoolInfo")
				if(info ~= nil) then
					PoolInfo:setMyPool(chiFen)
				end
			end
		end

	end
	]]
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

function this:ProcessEnter(msgData)
	print("lua log ---> ProcessEnter")
	local body = msgData["body"]
	local memberinfos = body["memberinfos"]
	userPlayerObj = this.transform:FindChild("Content/User").gameObject
	--userPlayerCtrl = userPlayerObj:GetComponent("SRNNPlayerCtrl")
	for index,value in pairs(memberinfos) do
		if(value ~= nil) then
			if( tostring(value["uid"]) == tostring(EginUser.Instance.uid) ) then
				
				table.insert(_playingPlayerList, userPlayerObj)
				_reEnter = true
				
				userPlayerObj.name = _nnPlayerName .. EginUser.Instance.uid;
				this:bindPlayerCtrl(userPlayerObj.name, userPlayerObj)
				userPlayerCtrl = this:getPlayerCtrl(userPlayerObj.name)
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
				this:AddPlayer(value)
			end
		end
	end
	
	local deskinfo = body["deskinfo"]
	this:UpdateHUD(deskinfo["continue_timeout"])
end

function this:ProcessReady(msgData)
	print("ProcessReady")
	local uid = msgData["body"]
	log(_nnPlayerName .. uid)
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
			end
		end
		
		
		--显示准备
		ctrl:SetReady(true)
		--table.insert(_playingPlayerList, player)
	end

end

function this:ProcessCome(msgData)
	log("ProcessCome")
	local body = msgData["body"]
	local memberinfo = body["memberinfo"]
	this:AddPlayer(memberinfo)

end

function this:ProcessLeave(msgData)
	print("ProcessLeave")
	local uid = msgData["body"]
	if( tostring( uid)  ~= tostring( EginUser.Instance.uid) )then
		local player = GameObject.Find(_nnPlayerName .. uid)
		log(player)
		this:removePlayerCtrl(player.name)

		if(tableContains(_playingPlayerList, player))then
			tableRemove(_playingPlayerList, player)
		end
		
		destroy(player)
	end
	print("end ProcessLeave")

end

function this:ProcessDeskOver(msgData)
	--not use in this game
end

function this:ProcessNotcontinue()
	log("ProcessNotcontinue coroutine ")
	this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject:SetActive(true)
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
		this.transform:FindChild("Content/MsgContainer/MsgWaitNext").gameObject:SetActive(true)
	end
	--（late进入时不显示开始按钮，显示等待）
	local btnBegin = this:getUserObj("Button_begin").gameObject
	btnBegin:SetActive(false)

	local body = msgData["body"]
	local chip = body["chipnum"]
	local t = body["timeout"]
	
	local gid  = body["bid"]
		
	this:UpdateHUD(t)

	if(tonumber(chip) > 0)then
		local infos = body["infos"]
		for index, value in pairs(infos) do
			local uid     = value["uid"]
			local waitNum = value["final"]
			local showNum = value["is_commit"]
			local cards   = value["cards"]
			local cardType= value["type"]

			local player = find(_nnPlayerName .. uid)
			if(player ~= nil)then
				local ctrl = this:getPlayerCtrl(player.name)
				if(tonumber(waitNum) == 0)then
					if tonumber(gid)~=tonumber(uid) then
						ctrl:SetBet(chip)
					end
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
	--local uid  = body["uid"]
	
	if( body == nil or body["cards"] == nil )then
		local player = find(_nnPlayerName .. otherUid)
		if(player ~= nil)then
			--player:GetComponent("SRNNPlayerCtrl"):SetShow(true)
			this:getPlayerCtrl(player.name):SetShow(true)
		end
	else
		local cards = body["cards"]
		local cardType = body["type"]
		local isgold=tonumber(body["is_gold_nn"]);
		if isgold~=nil then
			userPlayerCtrl:SetCardTypeUser(cards, cardType,isgold)
		else
			userPlayerCtrl:SetCardTypeUser(cards, cardType,0)
		end
		
	end
	
	local soundTanover = ResManager:LoadAsset("gamenn/Sound","tanover") --resLoad("Sound/tanover")
	EginTools.PlayEffect (soundTanover)
	
end

function this:ProcessDeal(msgData)
	print("ProcessDeal")
	--去掉“等待闲家下注”
	local msgWaitBet = this.transform:FindChild("Content/MsgContainer/MsgWaitBet").gameObject
	if(msgWaitBet.activeSelf)then
		msgWaitBet:SetActive(false)
	end
	
	local body = msgData["body"]
	local cards= body["cards"]
	local chip = body["chipnum"]

	if(_bankerPlayer ~= userPlayerObj)then
		local chooseChipObj = this:getUserObj("ChooseChips").gameObject
		chooseChipObj:SetActive(false)
		userPlayerCtrl:SetBet(chip);
	else
		this:getPlayerCtrl(_nnPlayerName .. otherUid):SetBet(chip)
	end
	
	local soundXiazhu = ResManager:LoadAsset("gamenn/Sound","xiazhu") --resLoad("Sound/xiazhu")
	EginTools.PlayEffect (soundXiazhu)
	coroutine.wait(0.2);
	--发牌
	for index, value in pairs(_playingPlayerList) do
		if value then
			local ctrl = this:getPlayerCtrl(value.name)
			if( value == userPlayerObj)then
				coroutine.start(ctrl.SetDeal, ctrl, true, cards)
			else 
				coroutine.start(ctrl.SetDeal, ctrl, true, nil)
			end
		end
		
	end
	coroutine.wait(2.5);
	--非late进入时才显示摊牌按钮
	if(not _late)then
		local btnShow = this:getUserObj("Button_show").gameObject
		btnShow:SetActive(true)
	end
	
	local t = body["timeout"]
	this:UpdateHUD(t)
	
end

function this.ProcessEnd(msgData)
	isgameover=true;
	print("ProcessEnd1")
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

	 local msgWaitNext = this.transform:FindChild("Content/MsgContainer/MsgWaitNext").gameObject
	 if(msgWaitNext.activeSelf) then
	 	msgWaitNext:SetActive(false)
	 end

	 --_playingPlayerList = {}
	 

	 local body = msgData["body"]
	 local infos = body["infos"]

	 local winposition=0;
   	 for key,info in pairs(infos) do
        local jos = info
	 	local uid = jos["uid"]
	 	local player = find(_nnPlayerName .. uid)
        if player ~= nil then
            local ctrl = this:getPlayerCtrl(player.name)
            local score = jos["final"]
            if tonumber(score)>0 then
                winposition=ctrl.movetarget.transform.position;
            end
        end
   	 end
	 
	 --玩家扑克牌信息
	 for key,info in pairs(infos) do
	 	local jos = info
	 	local uid = jos["uid"]
	 	local player = find(_nnPlayerName .. uid)
	 	local isown=false;
	 	if(player ~= nil)then
	 		--local ctrl = player:GetComponent("SRNNPlayerCtrl")
	 		local ctrl = this:getPlayerCtrl(player.name)
	 		local cards = jos["cards"]
	 		--牌型
	 		local cardType = jos["type"]
	 		--得分
	 		local score = jos["final"]
	 		local isgold=tonumber(jos["is_gold_niuniu"]);--是否为黄金牛牛
			local is_gold_win=tonumber(jos["gold_nn_win_money"]);--黄金牛牛奖励
			
			
	 		--明牌
	 		if( tostring(uid) ~= tostring(EginUser.Instance.uid)  )then
				if isgold~=nil then
					ctrl:SetCardTypeOther(cards, cardType,isgold)
				else
					ctrl:SetCardTypeOther(cards, cardType,0)
				end
	 		else
			 	isown=true;
	 			local btnShow = this:getUserObj("Button_show").gameObject
				if(btnShow.activeSelf)then
					btnShow:SetActive(false)
					if isgold~=nil then
						ctrl:SetCardTypeUser(cards, cardType,isgold)
					else
						ctrl:SetCardTypeUser(cards, cardType,0)
					end
				end
				if isgold~=nil and isgold==1 then
					ctrl:SetJiangLi(is_gold_win);
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

	 		ctrl:SetScore(score,winposition,isown)

	 	end
	 end  --end for key,info in pairs(infos) do
	 coroutine.start(this.AfterDoing, 0.2, 
				function()
				--[[
				for i=1,8 do
				--must be stop coroutine when this player quit 
					if(this.gameObject == nil)then
						return;
					end
					this:playsound()
					coroutine.wait(0.03)
				end
				]]
				this:playsound()
	end)

	coroutine.wait(1.8);
    this:ChuLiXiaoXi();
	 if(_late)then
	 	EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","GAME_END"))
	 	_late = false
	 else
	 	local btnBegin = this:getUserObj("Button_begin").gameObject
		--btnBegin.transform.localPosition = Vector3.New(300, 0, 0)
	 end

	 if(SettingInfo.Instance.autoNext == true )then
	 	coroutine.wait(2)
	 	this:UserReady()

	 else
	 	local btnBegin = this:getUserObj("Button_begin").gameObject
		btnBegin:SetActive(true)
	 end
	
	 local t = body["timeout"]
	 this:UpdateHUD(t)

	 _isPlaying = false
	
end

function this:playsound()
	--EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","nbet") )
	EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","Pool_Win") )
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
	log("UserQuit")
	SocketConnectInfo.Instance.roomFixseat = true
	this.mono:SendPackage( cjson.encode( {type="game", tag="quit"} ) )
	this.mono:OnClickBack()

end

function this:UserChip(go)
	print("send {'type':'niu2p', 'tag':'chip_in', 'body':**}")
	local chip = go.name
	local jsonObj = { type="niu2p", tag="chip_in", body=chip }
	local jsonStr = cjson.encode(jsonObj)
	this.mono:SendPackage(jsonStr)
end

function this:UserReady()
	log("lua -> UserReady")
	--避免了已经点击过开始按钮但是还是有倒计时声音
	--if(NNCount.Instance)then
		--NNCount.Instance:DestroyHUD()
	--end
	
	--"{'type':'niu2p','tag':'start'}"
	--向服务器发送消息（开始游戏）
	if(this.mono == nil)then
		return
	end

	--新的一句开始时去掉庄家标志
	if(_bankerPlayer ~= nil) then
		log(_bankerPlayer)
		log(_bankerPlayer.name)
		local targetPlayer = this:getPlayerCtrl(_bankerPlayer.name)
		if(targetPlayer ~= nil)then
			this:getPlayerCtrl(_bankerPlayer.name):SetBanker(false)
		end
	end

	local sendData = {type="niu2p", tag="start"}
	this.mono:SendPackage(cjson.encode(sendData))
	local audioClip = ResManager:LoadAsset("gamenn/Sound","GAME_START") --resLoad("Sound/GAME_START")
	EginTools.PlayEffect(audioClip)
	
	local btnBegin = this:getUserObj("Button_begin").gameObject
	btnBegin:SetActive(false)
	log("lua -> end  UserReady")
end

function this:UserShow()
	print("UserShow")
	this.mono:SendPackage(cjson.encode( {type="niu2p", tag="commit"} ) )
	local btnShow = this:getUserObj("Button_show").gameObject
	btnShow:SetActive(false)
end

function this:AddPlayer(memberinfo)
	print("AddPlayer")
	local uid = memberinfo["uid"]
	otherUid = uid
	local bag_money = memberinfo["bag_money"]
	local nickname = memberinfo["nickname"]
	local avatar_no = memberinfo["avatar_no"]
	--local position = memberinfo["position"]
	--local ready = memberinfo ["ready"]
	--local waiting = memberinfo["waiting"]
	local level = memberinfo ["level"]
	
	local contentObj = this.transform:FindChild("Content").gameObject
	local playerPrb = ResManager:LoadAsset("gamedznn/dznnplayer","DZNNPlayer")
	local player = NGUITools.AddChild(contentObj, playerPrb)
	player.name = _nnPlayerName .. uid
	
	local anchor = player:GetComponent("UIAnchor")
	anchor.side = UIAnchor.Side.Top
	anchor.relativeOffset = Vector2.New(0, -0.07)

	this:bindPlayerCtrl(player.name, player)
	local ctrl = this:getPlayerCtrl(player.name)
	ctrl:SetPlayerInfo (avatar_no, nickname, bag_money, level)
	
	table.insert(_playingPlayerList, player)
	
	return player

end

function this:ProcessAskbanker(msgData)
	print("ProcessAskbanker")
	
	_isPlaying = true
	--清除未被清除的牌,清楚叫庄中提示
	for index, value in pairs(_playingPlayerList) do
		if(value ~= userPlayerObj)then
			--local ctrl = value:GetComponent("SRNNPlayerCtrl")
			local ctrl = this:getPlayerCtrl(value.name)
			coroutine.start(ctrl.SetDeal, ctrl, false, nil)
			ctrl:SetCardTypeOther(nil,0,0)
			ctrl:SetScore(-1)
			
			ctrl:SetCallBanker(false)
		end
	end
	
	--去掉“准备”
	for index, value in pairs(_playingPlayerList) do
		--value:GetComponent("SRNNPlayerCtrl"):SetReady(false)
		this:getPlayerCtrl(value.name):SetReady(false)
	end
	
	local body = msgData["body"]
	local uid  = body["uid"]
	
	--显示叫庄提示信息
	if(tostring( uid ) == tostring( EginUser.Instance.uid ) )then
		local btnCallBankers = this:getUserObj("BtnCallBanker").gameObject
		btnCallBankers:SetActive(true)
	elseif( tostring( uid ) ~= tostring( EginUser.Instance.uid )  and (not _late) ) then
		local btnCallBankers = this:getUserObj("BtnCallBanker").gameObject
		if(btnCallBankers.activeSelf) then
			btnCallBankers:SetActive(false)
		end
		local player = find(_nnPlayerName .. uid)
		if player then
			this:getPlayerCtrl(player.name):SetCallBanker(true)
		end
	end
	
	local t = body["timeout"]
    this:UpdateHUD(t)
    
end

function this:UserCallBanker(btn)
	print("UserCallBanker")
	if(btn.name == "Button1")then
		this.mono:SendPackage( cjson.encode({type="niu2p", tag="re_banker", body=1}) )
		this.transform:FindChild("Content/MsgContainer/MsgWaitBet").gameObject:SetActive(true)
	elseif(btn.name == "Button0") then
		this.mono:SendPackage( cjson.encode({type="niu2p", tag="re_banker", body=0}) )
		--msgWaitCallBanker.SetActive(true);
	end
	
	local btnCallBankers = this:getUserObj("BtnCallBanker").gameObject
	btnCallBankers:SetActive(false)

end

function this:ProcessStartchip(msgData)
	print("ProcessStartchip")

	for key,value in pairs(_playingPlayerList) do
		if(value ~= userPlayerObj)then
			local ctrl1 = this:getPlayerCtrl(value.name)
			ctrl1:SetCallBanker(false)
		end
	end
	local btnCallBankers = this:getUserObj("BtnCallBanker").gameObject
	if(btnCallBankers.activeSelf)then
		btnCallBankers:SetActive(false)
	end
	local body = msgData["body"]
	local bid  = body["bid"]
	
	_bankerPlayer = find(_nnPlayerName .. bid)
	--local ctrl = _bankerPlayer:GetComponent("SRNNPlayerCtrl")
	if _bankerPlayer then
		local ctrl = this:getPlayerCtrl(_bankerPlayer.name)
		ctrl:SetCallBanker (false)
		--庄家
		ctrl:SetBanker(true)
	end
	
	if(not _late and  _bankerPlayer ~= userPlayerObj) then
		--可选的筹码
		local chip = body["chip"]
		local chooseChipObj = this:getUserObj("ChooseChips").gameObject
		chooseChipObj:SetActive(true)
		
		
		local btns = chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true))
		for i=0, btns.Length-1 do
			local btn = btns[i].gameObject
			local iPlus = i + 1
			local chipPrice = chip[iPlus]
			btn.name = chipPrice .. ""
			btn.transform:FindChild("BetLabel"):GetComponent("UILabel").text = chip[iPlus] .. ""		
		end   
	end
	
	--倒计时
	local t = body["timeout"]
    this:UpdateHUD(t)
	
end

function this:ProcessChip(msgData)
	print("ProcessChip")
	local infos = msgData["body"]
	local uid = infos[1]
	local chip = infos[2]
	local player = find(_nnPlayerName .. uid)
	--player:GetComponent("SRNNPlayerCtrl"):SetBet(chip)
	this:getPlayerCtrl(player.name):SetBet(chip)
	--如果收到主玩家的下注消息则隐藏可选筹码
	if(player == userPlayerObj) then
		--chooseChipObj
		this:getUserObj("ChooseChips").gameObject:SetActive(false)
	end
	local soundXiazhu = ResManager:LoadAsset("gamenn/Sound","xiazhu") --resLoad("Sound/xiazhu")
	EginTools.PlayEffect (soundXiazhu)
	
end

function this:OnClickBack()
	--TODO  maybe need ignore base.OnClickBack()
	if(not _isPlaying)then
		this:UserQuit()
	else
		local msgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject
		msgQuit:SetActive(true)
	end
end

function this:ShowPromptHUD( errorInfo )
	--TODO  maybe need ignore base.ShowPromptHUD(errorInfo)
	local btnBegin = this:getUserObj("Button_begin").gameObject
	btnBegin:SetActive(false)
	local msgAccountFailed = this.transform:FindChild("Content/MsgContainer/MsgAccountFailed").gameObject
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
	local targetObj = this.transform:FindChild("Content/".. _nnPlayerName .. EginUser.Instance.uid .."/"..objName)
	--print("find-->" .. "Content/".. _nnPlayerName .. EginUser.Instance.uid .."/"..objName)
	if(targetObj == nil)then
		targetObj = this.transform:FindChild("Content/User/".. objName)
		--print("find-->" .. "Content/User/".. objName)
	end
	return targetObj
end

function this:Update()
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

local rechatge = nil;
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
function this:OnAddMoney()  
	rechatge =  GameObject.Instantiate(this.Module_Recharge) 
	local rechatgeTrans = rechatge.transform;
	
	rechatgeTrans.parent = this.transform;
	rechatgeTrans.localScale = Vector3.one;
	
	rechatge:GetComponent("UIPanel").depth = 30; 
	
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	
	if sceneRoot then 
		sceneRoot.manualHeight = 1920;
		sceneRoot.manualWidth = 1080;
	end 
	this.Module_RechargeLua.GameFunction = this.GameFunction;
	 
	
	EginTools.PlayEffect(this.but);
end

function this:OnButtonClick(target)
	if target==this.btnXiala then	
		log("点击下拉按钮");
		if this.btnXiala_bg.spriteName=="button_up" then
			log("隐藏");
			this.btnXiala.transform:FindChild("panel").gameObject:SetActive(false);
			this.btnXiala_bg.spriteName="button_down";	
			this.btnXiala:GetComponent("UIButton").normalSprite="button_down";
		else
			log("显示");
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

function this.AfterDoing( offset, run )
	coroutine.wait(offset)
	--must be stop coroutine when this player quit 
	if(this.gameObject == nil)then
		error("##stop coroutine in AfterDoing")
		return;
	end
	run()
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
