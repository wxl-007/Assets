require "GameSRNN/SRNNPlayerCtrl"

local this = LuaObject:New()
GameSRNN = this

local _userIndex = 0
local _reEnter = false
local _late    = false
local _isPlaying = false
local _nnPlayerName = "NNPlayer_"
local _waitPlayerList = {}
local _playingPlayerList = {}
local _readyPlayerList = {}
local userPlayerCtrl --component
local _bankerPlayer --gameObject
local chooseChipObj --gameObject
local keynum = 0;
local playerCtrlDc = {}
local isgameover=false;	

function this:bindPlayerCtrl(objName, gameObj)
	playerCtrlDc[objName] = SRNNPlayerCtrl:New(gameObj)
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
	--print("clearLuaValue")
	_userIndex = 0
	_reEnter = false
	_late    = false
	_isPlaying = false
	this.userPlayerObj=nil;
	this.bankerUid="";
	_nnPlayerName = "NNPlayer_"
	_waitPlayerList = {}
	_playingPlayerList = {}
	_readyPlayerList = {}
	userPlayerObj = nil--gameObject
	userPlayerCtrl= nil --component
	_bankerPlayer = nil--gameObject
	chooseChipObj = nil --gameObject
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	this.lateMessage=nil;
	isgameover=false;
	this.jiangchiBtn=nil;
	this.jiangchiShow=false;	
	for k,v in pairs(playerCtrlDc) do
		v:OnDestroy()
	end
	playerCtrlDc = {}
	coroutine.Stop()
	LuaGC()
end

function this:handleBtnsFunc()
	this.NNCount = this.transform:FindChild("Content/NNCount/NNCount").gameObject:GetComponent("Animator")	
	this.NNCountNum = this.transform:FindChild("Content/NNCount/NNCount/Sprite").gameObject:GetComponent("UILabel")	
	this.userPlayerObj = this.transform:FindChild("Content/User").gameObject
	this.bankerUid="";
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


	local backBtn = this.transform:FindChild("Panel_button/Button_back").gameObject
	this.mono:AddClick(backBtn, this.OnClickBack)

	local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
	this.mono:AddClick(btn_MsgQuit, this.UserQuit)

	local btnBegin = this:getUserObj("Button_begin").gameObject
	this.mono:AddClick(btnBegin, this.UserReady)
	local callBankerBtn = this:getUserObj("BtnCallBanker/Button1").gameObject
	this.mono:AddClick(callBankerBtn, 
		function ()
			this.mono:SendPackage( cjson.encode({type="srnn", tag="re_banker", body=1}) )
			this.transform:FindChild("Content/MsgContainer/MsgWaitBet").gameObject:SetActive(true)
			this:getUserObj("BtnCallBanker").gameObject:SetActive(false)
		end
	)

	local giveupBtn = this:getUserObj("BtnCallBanker/Button0").gameObject
	this.mono:AddClick(giveupBtn, 
		function ()
			this.mono:SendPackage( cjson.encode({type="srnn", tag="re_banker", body=0}) )
			this:getUserObj("BtnCallBanker").gameObject:SetActive(false)
		end

	)

	local btnShow = this:getUserObj("Button_show").gameObject
	this.mono:AddClick(btnShow, this.UserShow)

	--4  chip btn
	local chooseChipObj = this:getUserObj("ChooseChips").gameObject					
	local btns = chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true), true)
	--print("lua access C# array " .. btns.Length)
	--local len  = btns.Length
	for i=0, btns.Length-1 do
		local btn = btns[i].gameObject
		if(string.find(btn.name, "Button") ~= nil)then
			this.mono:AddClick(btn, 
				function ()
					--print("send {'type':'srnn', 'tag':'chip_in', 'body':**}")
					local chip = btn.name
					--print("chip price:" .. chip)
					local jsonObj = { type="srnn", tag="chip_in", body=chip }
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
	log("------------------awake of GameSRNNPanel")
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
 
 	--Application.LoadLevelAdditive("FootInfo_TBNN");
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
 
 	SettingInfo.Instance.deposit = false;
    
	local footInfo = GameObject.Find("FootInfo")
	local btn_AddMoney = footInfo.transform:FindChild("MsgAddMoney/Button_yes").gameObject
	this.mono:AddClick(btn_AddMoney, this.OnAddMoney);
	
    --[[
    SettingInfo.Instance.deposit = false;
    --]]
end

function this:Start()
	log("lua log ------> Start of GameSRNNPanel")
	--log(SettingInfo.Instance.autoNext)
	--log(this.transform)
	--log(this.transform.parent)
	if(SettingInfo.Instance.autoNext == true or SettingInfo.Instance.deposit == true) then
		local btnBegin = this:getUserObj("Button_begin").gameObject
		btnBegin:SetActive(false)
	end
	local info = GameObject.Find ("GameSettingManager");
	
	if ( not IsNil(info) ) then
		GameSettingManager:setDepositVisible(true);
	end
	this.mono:StartGameSocket()

	_isCallUpdate = true
	coroutine.start(this.UpdateInLua)
	coroutine.start(this.Update);
	
	 
	Activity:SetScale(0.7429)
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
		elseif(tag == "actfinish") then
			-- this:ProcessLeave(msgData)
		elseif(tag == "deskover") then
			this:ProcessDeskOver(msgData)
		elseif(tag == "notcontinue")then
			coroutine.start(this.ProcessNotcontinue)
		elseif tag=="newactfinish" then
				this:ProcessNewactfinish(msgData); 
		end
	elseif( type1 == "srnn") then
		if(tag == "time") then
			local t = msgData["body"]
			this:UpdateHUD(t);
		elseif(tag == "late") then
			log(msgStr);
			coroutine.start(this.ProcessLate, msgData)
		elseif(tag == "ok") then
			log(msgStr);
			this:ProcessOk(msgData)
		elseif(tag == "ask_banker") then
			log(msgStr);
			coroutine.start(this.ProcessAskbanker, msgData)
		elseif(tag == "start_chip") then
			log(msgStr);
			coroutine.start(this.ProcessStartchip, msgData)
		elseif(tag == "chip") then
			log(msgStr);
			this:ProcessChip(msgData)
		elseif(tag == "deal")then
			log(msgStr);
			coroutine.start(this.ProcessDeal,this, msgData)
		elseif(tag == "end")then
			log(msgStr);
			coroutine.start(this.ProcessEnd, msgData)
		end
	elseif(type1 == "seatmatch") then
		if(tag == "on_update") then
			this:ProcessUpdateAllIntomoney(msgData)
		end
	elseif(type1 == "niuniu") then
		log(msgStr);
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

	--SettingInfo.Instance.deposit = false
	local body = msgData["body"]
	 
	local memberinfos = body["memberinfos"]
	
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
					table.insert(_waitPlayerList, this.userPlayerObj) 
				else
					table.insert(_playingPlayerList, this.userPlayerObj)
					_reEnter = true
				end
				 keynum = tonumber(value["keynum"])
				 Activity:SetCountBgLabel(keynum);
				this.userPlayerObj.name = _nnPlayerName .. EginUser.Instance.uid;
				this:bindPlayerCtrl(this.userPlayerObj.name, this.userPlayerObj)
				userPlayerCtrl = this:getPlayerCtrl(this.userPlayerObj.name)

				local bagmoney=value["bag_money"];
				userPlayerCtrl.MyMoney=tonumber(bagmoney);

				if (SettingInfo.Instance.autoNext == true or SettingInfo.Instance.deposit == true) then
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
	this:UpdateHUD(deskinfo["continue_timeout"]);
end


function this:ProcessReady(msgData)
	--log("ProcessReady")
	local uid = msgData["body"]
	--log(_nnPlayerName .. uid)
	local player = GameObject.Find (_nnPlayerName .. uid)
	--local ctrl   = player:GetComponent("SRNNPlayerCtrl")
	if player~=nil then
		local ctrl   = this:getPlayerCtrl(player.name)
		
		--去掉牌型显示
		
		if( tostring(uid) == tostring(EginUser.Instance.uid) ) then
			ctrl:SetCardTypeUser(nil, 0,0)
			ctrl:SetScore(-1)
			coroutine.start(ctrl.SetDeal, ctrl, false, nil)
		else
			local btnBegin = this:getUserObj("Button_begin").gameObject
			if not btnBegin.activeSelf then
				ctrl:SetCardTypeOther(nil, 0,0)
				ctrl:SetScore(-1)
				ctrl:SetWait(false);				
				coroutine.start(ctrl.SetDeal, ctrl, false, nil)
			end
			ctrl:SetBanker(false)
		end
		
		
		--显示准备
		ctrl:SetReady(true)
		table.insert(_playingPlayerList, player)
	end
end

function this:ProcessCome(msgData)
	--log("ProcessCome")
	local body = msgData["body"]
	local memberinfo = body["memberinfo"]
	local player = this:AddPlayer(memberinfo, _userIndex)
	if(_isPlaying)then
		--player:GetComponent("SRNNPlayerCtrl"):SetWait(true)
        --player:GetComponent("SRNNPlayerCtrl"):SetReady(false)
        this:getPlayerCtrl(player.name):SetWait(true)
        this:getPlayerCtrl(player.name):SetReady(false)
	end
	
end

function this:ProcessLeave(msgData)
	--log("ProcessLeave")
	local uid = msgData["body"]
	if( tostring( uid)  ~= tostring( EginUser.Instance.uid) )then
		local player = GameObject.Find(_nnPlayerName .. uid)
		--log(player)
		this:removePlayerCtrl(player.name)

		if(tableContains(_playingPlayerList, player))then
			tableRemove(_playingPlayerList, player)
		end
		
		if(tableContains(_waitPlayerList, player))then
			tableRemove(_waitPlayerList, player)
		end
		
		destroy(player)
	end
	--print("end ProcessLeave")
end

function this:ProcessDeskOver(msgData)
	--not use in this game
end

function this:ProcessNotcontinue()
	--log("ProcessNotcontinue coroutine ")
	this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject:SetActive(true)
	coroutine.wait(3)
	--must be stop coroutine when this player quit 
	if(this.gameObject == nil)then
		error("stop coroutine in ProcessNotcontinue")
		return;
	end
	this:UserQuit()
end

-----srnn---
------------
function this.ProcessLate(msgData)
	--print("processLate")
	--log("中途进入1111");
	--log(_reEnter);
	if(not _reEnter)then
		_late = true
		this.transform:FindChild("Content/MsgContainer/MsgWaitNext").gameObject:SetActive(true)
	end
	--log("11111111111111");
	--log(_late);
	--（late进入时不显示开始按钮，显示等待）
		local btnBegin = this:getUserObj("Button_begin").gameObject
		btnBegin:SetActive(false)
		SettingInfo.Instance.deposit = false
		local body = msgData["body"]
		local t = body["t"]
		local step = body["step"]
		local nnBid = body["bankid"]
		local chip = body["chip"]
		local gid  = body["gid"]
		
		this:UpdateHUD(t);
		
		
		--庄家
		if(tonumber(nnBid) ~= 0) then
			_bankerPlayer = find(_nnPlayerName .. nnBid)
			--_bankerPlayer:GetComponent("SRNNPlayerCtrl"):SetBanker(true)
			this.bankerUid=tostring(nnBid);
			this:getPlayerCtrl(_bankerPlayer.name):SetBanker(true)
		end
		local infos = body["infos"]
		for index, value in pairs(infos) do
			local uid     = value[1]
			local waitNum = value[2]
			local showNum = value[3]
			local cards   = value[4]
			local cardType= value[5]
			local perChip = value[6]
			
			local player = find(_nnPlayerName .. uid)
			if(player ~= nil)then
				--local ctrl = player:GetComponent("SRNNPlayerCtrl")
				local ctrl = this:getPlayerCtrl(player.name)
				if(waitNum == 0) then
					if( player ~= this.userPlayerObj ) then
						if(perChip ~= 0) then
							ctrl:SetBet(perChip)
						end
						if(step == 3 )then
							ctrl:SetLate(null)
							if(showNum == 1)then 
								ctrl:SetShow(true)
							end
						end
						
					else
						if(step == 1) then
							if( tostring( gid ) == tostring( EginUser.Instance.uid) ) then
								local btnCallBankers = this:getUserObj("BtnCallBanker").gameObject
								btnCallBankers:SetActive(true)
							else 
								--msgWaitCallBanker.SetActive(true);
							end

						elseif( step == 2) then
							if( perChip ~= 0) then
								ctrl:SetBet(perChip)
							elseif(perChip == 0) then
								local chooseChipObj = this:getUserObj("ChooseChips").gameObject
								chooseChipObj:SetActive(true)
								
								local btns = chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true))
								--print("lua access C# array")
								--local len  = btns.Length
								for i=0, btns.Length-1 do
									local btn = btns[i].gameObject
									local iPlus = i+1
									btn.name = tostring( chip[iPlus])
									btn.transform:FindChild("BetScore"):GetComponent("UILabel").text = tostring( chip[iPlus] )
								end -- end for index , value in ipairs(btns) do
							end
							
						elseif(step == 3) then
							ctrl:SetLate(cards)
							if(showNum == 1) then
								ctrl:SetCardTypeUser(cards, cardType,0)
							else
								if(SettingInfo.Instance.deposit == true)then
									coroutine.wait(2)
                                    this:UserShow()
								end
								ctrl:SetShow(true)
								local btnShow = this:getUserObj("Button_show").gameObject
								btnShow:SetActive(true)
							end

						end -- end step ==  x
						
					end --end if( player ~= userPlayerObj ) then
					
				elseif(waitNum == 1) then
					ctrl:SetWait(true)
				end -- end if(waitNum == 0) then
			end -- end if(player ~= nil)then
		end -- end for
		
end

function this:ProcessOk(msgData)
	--print("ProcessOk")
	local body = msgData["body"]
	local uid  = body["uid"]
	
	if( tostring( uid ) ~= tostring( EginUser.Instance.uid) )then
		local player = find(_nnPlayerName .. uid)
		if(player ~= nil)then
			--player:GetComponent("SRNNPlayerCtrl"):SetShow(true)
			this:getPlayerCtrl(player.name):SetShow(true)
			--this:getPlayerCtrl(player.name):SetBanker(false);
		end
	else
		local cards = body["cards"]
		local cardType = body["type"]
		local player = find(_nnPlayerName .. uid)
		local isgold=tonumber(body["is_gold_nn"]);		
		if isgold~=nil then
			this:getPlayerCtrl(player.name):SetCardTypeUser(cards, cardType,isgold)
		else
			this:getPlayerCtrl(player.name):SetCardTypeUser(cards, cardType,0)
		end
	end
	
	local soundTanover = ResManager:LoadAsset("gamenn/Sound","tanover") --resLoad("Sound/tanover")
	EginTools.PlayEffect (soundTanover)
	
end

function this.ProcessAskbanker(msgData)
	--print("ProcessAskbanker")
	
	--游戏开始，将_readyPlayerList中的玩家放入_playingPlayerList
	for index, value in pairs(_readyPlayerList) do
		if( (not tableContains(_playingPlayerList, value)) and (not tableContains(_waitPlayerList, value)) )then
			table.insert(_playingPlayerList, value)
		end
	end
	_readyPlayerList = {}
	
	_isPlaying = true
	--清除未被清除的牌,清楚叫庄中提示
	for index, value in pairs(_playingPlayerList) do
		if(value ~= this.userPlayerObj)then
			--local ctrl = value:GetComponent("SRNNPlayerCtrl")
			if value then
				local ctrl = this:getPlayerCtrl(value.name)
				coroutine.start(ctrl.SetDeal, ctrl, false, nil)
				--ctrl:SetDeal (false, null);
				ctrl:SetCardTypeOther(nil,0,0)
				ctrl:SetScore(-1)
				
				ctrl:SetCallBanker(false)
			end
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
		if(SettingInfo.Instance.deposit == true) then
			--int betnum = Random.Range(1,5);
			coroutine.wait(1)
            local btn = btnCallBankers.transform:FindChild("Button1").gameObject
            this:UserCallBanker(btn)
		end
	elseif( tostring( uid ) ~= tostring( EginUser.Instance.uid )  and (not _late) ) then
		local btnCallBankers = this:getUserObj("BtnCallBanker").gameObject
		btnCallBankers:SetActive(true)
		if(btnCallBankers.activeSelf) then
			btnCallBankers:SetActive(false)
		end
		local player = find(_nnPlayerName .. uid)
		--player:GetComponent("SRNNPlayerCtrl"):SetCallBanker(true)
		this:getPlayerCtrl(player.name):SetCallBanker(true)
		--msgWaitCallBanker.SetActive(true);
	end
	
	local t = body["timeout"]
    this:UpdateHUD(t);
    
end

function this.ProcessStartchip(msgData)
	--print("ProcessStartchip")
	local btnCallBankers = this:getUserObj("BtnCallBanker").gameObject
	if(btnCallBankers.activeSelf)then
		btnCallBankers:SetActive(false)
	end

	local body = msgData["body"]
	local bid  = body["bid"]
	
	_bankerPlayer = find(_nnPlayerName .. bid)
	this.bankerUid=tostring(bid);
	--local ctrl = _bankerPlayer:GetComponent("SRNNPlayerCtrl")
	local ctrl = this:getPlayerCtrl(_bankerPlayer.name)
	ctrl:SetCallBanker (false)
	--庄家
	ctrl:SetBanker(true)
	
	if(not _late and  _bankerPlayer ~= this.userPlayerObj) then
		--可选的筹码
		local chip = body["chip"]
		local chooseChipObj = this:getUserObj("ChooseChips").gameObject
		chooseChipObj:SetActive(true)
		
		
		local btns = chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true))
		--print("lua access C# array ->" .. btns.Length)
		for i=0, btns.Length-1 do
			--log(btns[i])
			local btn = btns[i].gameObject
			local iPlus = i + 1
			local chipPrice = chip[iPlus]
			btn.name = chipPrice .. ""
			btn.transform:FindChild("BetLabel"):GetComponent("UILabel").text = chip[iPlus] .. ""
		end
		if (SettingInfo.Instance.deposit == true) then
        	--int betnum = Random.Range(1,5);
        	coroutine.wait(1)
            this:UserChip(btns[1].gameObject)
        end
        
	end
	
	--倒计时
	local t = body["timeout"]
	this:UpdateHUD(t);
	
end

function this:ProcessChip(msgData)
	--print("ProcessChip")
	local infos = msgData["body"]
	local uid = infos[1]
	local chip = infos[2]
	local player = find(_nnPlayerName .. uid)
	--player:GetComponent("SRNNPlayerCtrl"):SetBet(chip)
	this:getPlayerCtrl(player.name):SetBet(chip)
	this:getPlayerCtrl(player.name):SetReady(false)
	this:getPlayerCtrl(player.name):SetWait(false)
	--如果收到主玩家的下注消息则隐藏可选筹码
	if(player == this.userPlayerObj) then
		--chooseChipObj
		this:getUserObj("ChooseChips").gameObject:SetActive(false)
	end
	local soundXiazhu = ResManager:LoadAsset("gamenn/Sound","xiazhu") --resLoad("Sound/xiazhu")
	EginTools.PlayEffect (soundXiazhu)
	
end

function this:ProcessDeal(msgData)
	--print("ProcessDeal")
	--去掉“等待闲家下注”
	local msgWaitBet = this.transform:FindChild("Content/MsgContainer/MsgWaitBet").gameObject
	if(msgWaitBet.activeSelf)then
		msgWaitBet:SetActive(false)
	end
	
	local body = msgData["body"]
	local cards= body["cards"]
	
	
	for key,player in ipairs(_readyPlayerList) do
		if not tableContains(_playingPlayerList,player) then
			table.insert(_playingPlayerList,player)
		end
	end
	_readyPlayerList = {};
	--发牌
	for index, value in pairs(_playingPlayerList) do
		if value then
			if( value == this.userPlayerObj)then
				local ctrl = this:getPlayerCtrl(value.name)
				--print("ProcessDeal-> SetDeal".. value.name .. "---" .. ctrl.gameObject.name)
				coroutine.start(ctrl.SetDeal, ctrl, true, cards)
			else 
				local ctrl = this:getPlayerCtrl(value.name)
				--print("ProcessDeal-> SetDeal".. value.name .. "---" .. ctrl.gameObject.name)
				coroutine.start(ctrl.SetDeal, ctrl, true, nil)
			end
		end
	end

	coroutine.wait(2.5);
	--非late进入时才显示摊牌按钮
	--log("是否中途进入");
	--log(_late);
	if(not _late)then
		
		local btnShow = this:getUserObj("Button_show").gameObject
		--log("显示摊牌");
		btnShow:SetActive(true)
        if (SettingInfo.Instance.deposit == true) then
            coroutine.wait(1)
            this:UserShow()
        end
	end
	
	local t = body["t"]
	this:UpdateHUD(t);
	
end

function this.ProcessEnd(msgData)
	isgameover=true;
	--print("ProcessEnd1 ----------------------------- =\r\n " .. cjson.encode(msgData))
	--去掉筹码显示
	for index, player in pairs(_playingPlayerList) do
		--player:GetComponent("SRNNPlayerCtrl"):SetBet(0)
		this:getPlayerCtrl(player.name):SetBet(0)
	end
	--去掉“摊牌”字样和下注额
	for index, player in pairs(_playingPlayerList) do
		if(player ~= this.userPlayerObj) then
			--player:GetComponent("SRNNPlayerCtrl"):SetShow(false)
			this:getPlayerCtrl(player.name):SetShow(false)
		end
	end

	 local msgWaitNext = this.transform:FindChild("Content/MsgContainer/MsgWaitNext").gameObject
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
	local wincount=0;
	local winPositionList={};
	local losePositionList={};
	local loseposition=0;
	local playerBanker = find(_nnPlayerName .. this.bankerUid);
	if playerBanker~=nil then
		loseposition=this:getPlayerCtrl(_nnPlayerName..this.bankerUid).movetarget.transform.position;
		table.insert(losePositionList,loseposition);
	end
	local winUidList={};
	local loseUidList={};

	 --local winposition = {}


	 for index,value in ipairs(infos) do
	 	local score = infos[index][4]
	 	local uid   = infos[index][1]
	 	--local ctrl = find(_nnPlayerName .. uid):GetComponent("SRNNPlayerCtrl")
	 	local player1 = find(_nnPlayerName .. uid)
	 	local ctrl = this:getPlayerCtrl(player1.name)
	 	local fangwei = tostring( player1:GetComponent("UIAnchor").side )
		local targetposition=ctrl.movetarget.transform.position   --飞金币的位置
	 	if(score>0) and tostring(uid)~=this.bankerUid then
	 		wincount = wincount + 1
	 		table.insert(winPositionList, targetposition)
			 table.insert(winUidList,tostring(uid));
	 		--table.insert(winposition, fangwei)
		elseif score<0 and tostring(uid)~=this.bankerUid then
			 table.insert(loseUidList,tostring(uid));
	 	end
	 end
	 
    
	
	

	 --玩家扑克牌信息
	 for key,info in pairs(infos) do
	 	local jos = info
	 	local uid = jos[1]
	 	local player = find(_nnPlayerName .. uid)
	 	
	 	if(player ~= nil)then
	 		--local ctrl = player:GetComponent("SRNNPlayerCtrl")
	 		local ctrl = this:getPlayerCtrl(player.name)
	 		local sideposition = tostring( player:GetComponent("UIAnchor").side )
	 		local cards = jos[2]
	 		--牌型
	 		local cardType = jos[3]
	 		--得分
	 		local score = jos[4]
			local isgold;   --是否为黄金牛牛
			local jiangli_money;  --奖励金钱数
	 		
			if has_gold then
				isgold=tonumber(jos[5]);   --是否为黄金牛牛
				jiangli_money=jos[6];  --奖励金钱数
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
					ctrl:SetJiangLi(jiangli_money);
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
	 		ctrl:SetScore(score)
	 	end
	 end  --end for key,info in pairs(infos) do
	 
	 
	 if wincount==(#(infos)-1) then
	 		this:getPlayerCtrl(_nnPlayerName..this.bankerUid):SetFlyBetAnimation(winPositionList,this.bankerUid);
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
	 elseif  wincount==0 then
	 		for i=1,#(loseUidList) do
			 	this:getPlayerCtrl(_nnPlayerName..loseUidList[i]):SetFlyBetAnimation(losePositionList,loseUidList[i]);
			end
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
	 else
	 		for i=1,#(loseUidList) do
			 	local player=find(_nnPlayerName..loseUidList[i]);
				if player then
			 		this:getPlayerCtrl(_nnPlayerName..loseUidList[i]):SetFlyBetAnimation(losePositionList,loseUidList[i]);
				end
			end
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
			coroutine.wait(1.5)
			this:getPlayerCtrl(_nnPlayerName..this.bankerUid):SetFlyBetAnimation(winPositionList,this.bankerUid);
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
	 end

	
	 	

	coroutine.wait(2);
	this.ChuLiXiaoXi();


	 --去掉所有等待中玩家的”等待中“， 显示开始换桌按钮
	 for k,player in pairs(_waitPlayerList) do
	 	if(player ~= this.userPlayerObj)then
	 		--player:GetComponent("SRNNPlayerCtrl"):SetWait(false)
	 		this:getPlayerCtrl(player.name):SetWait(false)
	 		if(not tableContains(_playingPlayerList, player))then
	 			table.insert(_playingPlayerList, player)
	 		end
	 	end
	 end

	 _waitPlayerList = {}

	 if(_late)then
	 	EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","GAME_END"))
		 --coroutine.wait(3);
	 	_late = false
	 else
	 	--local btnBegin = this:getUserObj("Button_begin").gameObject
		--btnBegin.transform.localPosition = Vector3.New(370, -56, 0)
	 end

	 if(SettingInfo.Instance.autoNext == true or SettingInfo.Instance.deposit == true)then
	 	coroutine.wait(2)
	 	this:UserReady()

	 else
	 	local btnBegin = this:getUserObj("Button_begin").gameObject
		btnBegin:SetActive(true)
	 end
	
	 local t = body["t"]
	 this:UpdateHUD(t);

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
	--print("ProcessUpdateIntomoney")
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
	if(this.mono == nil)then
		return
	end
	--避免了已经点击过开始按钮但是还是有倒计时声音
	--if(TBNNCount.Instance)then
		--TBNNCount.Instance:DestroyHUD()
	--end
	
	--新的一句开始时去掉庄家标志
	--[[
	if(_bankerPlayer ~= nil) then
		local targetPlayer = this:getPlayerCtrl(_bankerPlayer.name)
		if(targetPlayer ~= nil)then
			this:getPlayerCtrl(_bankerPlayer.name):SetBanker(false)
		end
	end
	]]
    userPlayerCtrl:SetBanker(false);
	
	--"{'type':'srnn','tag':'start'}"
	--向服务器发送消息（开始游戏）
	local sendData = {type="srnn", tag="start"}
	this.mono:SendPackage(cjson.encode(sendData))
	local audioClip = ResManager:LoadAsset("gamenn/Sound","GAME_START") --resLoad("Sound/GAME_START")
	EginTools.PlayEffect(audioClip)
	
	local btnBegin = this:getUserObj("Button_begin").gameObject
	btnBegin:SetActive(false)
	--log("lua -> end  UserReady")
end

function this:UserShow()
	--print("UserShow")
	this.mono:SendPackage(cjson.encode( {type="srnn", tag="ok"} ) )
	local btnShow = this:getUserObj("Button_show").gameObject
	btnShow:SetActive(false)
end

function this:AddPlayer(memberinfo, _userIndex)
	--print("AddPlayer")
	local uid = memberinfo["uid"]
	local bag_money = memberinfo["bag_money"]
	local nickname = memberinfo["nickname"]
	local avatar_no = memberinfo["avatar_no"]
	local position = memberinfo["position"]
	local ready = memberinfo ["ready"]
	local waiting = memberinfo["waiting"]
	local level = memberinfo ["level"]
	
	local contentObj = this.transform:FindChild("Content").gameObject
	local playerPrb = ResManager:LoadAsset("gamesrnn/srnnplayer","SRNNPlayer")
	local player = NGUITools.AddChild(contentObj, playerPrb)
	player.name = _nnPlayerName .. uid
	this:SetAnchorPosition(player, _userIndex, position)
	--local ctrl = player:GetComponent("SRNNPlayerCtrl")
	this:bindPlayerCtrl(player.name, player)
	local ctrl = this:getPlayerCtrl(player.name)
	ctrl:SetPlayerInfo (avatar_no, nickname, bag_money, level)
	
	if (waiting) then
		
		if( ready ) then
			ctrl:SetReady(true)
			table.insert(_readyPlayerList, player)
		else
			table.insert(_waitPlayerList, player)
		end
	else
		table.insert(_playingPlayerList, player)
	end
	return player
	--[[
		
		GameObject player = NGUITools.AddChild(this.gameObject, srnnPlayerPrefab);
		player.name = _nnPlayerName + uid;
		SetAnchorPosition(player, _userIndex, position);
		SRNNPlayerCtrl ctrl = player.GetComponent<SRNNPlayerCtrl>();
		ctrl.SetPlayerInfo (avatar_no, nickname, bag_money, level);

		if (waiting) {
			if(ready) {
				ctrl.SetReady(true);
				_readyPlayerList.Add(player);
			}
			_waitPlayerList.Add(player);
		}else {
			_playingPlayerList.Add(player);
		}

		return player;
	--]]
end

function this:SetAnchorPosition(player, _userIndex, playerIndex)
	--print("setAnchorPosition")
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
		anchor.relativeOffset = Vector2.New(0, -0.07)
	elseif(position_span == 3 or position_span == -1) then
		anchor.side = UIAnchor.Side.Left
		--anchor.relativeOffset.x = 0.09
		--anchor.relativeOffset.y = 0.025
		anchor.relativeOffset = Vector2.New(0.09, 0.08)
	end
	
end

function this:UserCallBanker(btn)
	--print("UserCallBanker")
	if(btn.name == "Button1")then
		this.mono:SendPackage( cjson.encode({type="srnn", tag="re_banker", body=1}) )
		this.transform:FindChild("Content/MsgContainer/MsgWaitBet").gameObject:SetActive(true)
	elseif(btn.name == "Button0") then
		this.mono:SendPackage( cjson.encode({type="srnn", tag="re_banker", body=0}) )
		--msgWaitCallBanker.SetActive(true);
	end
	
	local btnCallBankers = this:getUserObj("BtnCallBanker").gameObject
	btnCallBankers:SetActive(false)

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

function this:playsound()
	--EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","nbet") )
	EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","Pool_Win") )
end

function this:choumaDestroy( list, endTargetPosition, start, p_end, xiabiao, time )
	--print("choumaDestroy")
	local v = 0
	--print("========>" .. #(list))
	local tempList = list
	for i=start,p_end do
		local temp = v
		local num = i
		local curChip = list[num]
		local targetTr = endTargetPosition[xiabiao]:FindChild(endTargetPosition[xiabiao].gameObject.name)
		local endVc3 = endTargetPosition[xiabiao].localPosition
		local vc3 = Vector3.New(endVc3.x + targetTr.localPosition.x, endVc3.y + targetTr.localPosition.y, endVc3.z)
		if(curChip ~= nil)then
			coroutine.start(this.AfterDoing, temp, 
				function()
					if(curChip ~= nil)then
						if(curChip:GetComponent("TweenPosition") == nil)then
							curChip.gameObject:AddComponent(Type.GetType("TweenPosition",true))
							local uiTween = curChip:GetComponent("TweenPosition")
							uiTween.from = curChip.transform.localPosition
							uiTween.to   = vc3
							uiTween.duration = 0.3
							coroutine.start(this.AfterDoing,0.3,
								function ()
									EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","xiazhu") )
									destroy(curChip.gameObject)
								end
							)
						end	
					end
				end
			)
		else
			--error(" due to Unity crash ---> choumaDestroy")
		end
		v = v + time
	end
	--print("end choumaDestroy")
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

function this.AfterDoing( offset, run )
	coroutine.wait(offset)
	--must be stop coroutine when this player quit 
	if(this.gameObject == nil)then
		--error("##stop coroutine in AfterDoing")
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
				--print("?????")
			else
				v:UpdateInLua()
			end
		end
		coroutine.wait(0.5)
	end
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


function this:OnDestroy()
	log("--------------------ondestroy of GameSRNNPanel")
	this:clearLuaValue()
end
