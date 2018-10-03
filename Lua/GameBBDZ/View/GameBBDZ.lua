require 'GameBBDZ/BBDZPlayerCtrl'
local this = LuaObject:New()
GameBBDZ = this

local m_DznnPlayerPreObj
local m_UserPlayerCtrl
local m_UserPlayerObj

local m_BtnBeginObj
local m_BtnCallBankersObj
local m_BtnShowObj
local m_MsgWaitNextObj
local m_MsgWaitBetObj
local m_ChooseChipObj
local m_MsgQuitObj
local m_MsgAccountFailedObj
local m_MsgNotContinueObj
local m_ShowCardSp
local isgameover=false;
local m_IsPlaying = false 
local m_IsLate=false 
local m_IsReEnter  = false
local m_PlayingPlayerObjList = {}

local m_nnPlayerName = 'NNPlayer_'
local m_OtherUid="0";
local playerCtrlDc = {}

function this:bindPlayerCtrl(objName, gameObj)
  playerCtrlDc[objName] = BBDZPlayerCtrl:New(gameObj)
end

function this:getPlayerCtrl(objName)
  return playerCtrlDc[objName]
end

function this:removePlayerCtrl( objName )
  if playerCtrlDc[objName] ~= nil then
    playerCtrlDc[objName]:OnDestroy() 
  end 
  playerCtrlDc[objName] = nil 
end

function this:ClearLuaValue()
  print('clear all ')
  this.mono = nil
  this.gameObject = nil
  m_UserPlayerObj  = nil 
  m_UserPlayerCtrl = nil
  m_BtnBeginObj    = nil 
  m_BtnCallBankersObj  = nil 
  m_BtnShowObj     = nil 
  m_MsgWaitNextObj = nil 
  m_MsgWaitBetObj  =nil 
  m_ChooseChipObj  =nil 
  m_MsgQuitObj     =nil 
  m_MsgAccountFailedObj =nil 
  m_nnPlayerName = 'NNPlayer_'
  m_OtherUid="0"
  m_BankerPlayerObj = nil 
  m_ShowCardSp = nil 
  isgameover=false;
  m_IsPlaying = false 
  m_IsLate    = false 
  m_IsReEnter = false 
  for k,v in pairs(playerCtrlDc) do
    v:OnDestroy()
  end
  this.jiangchiBtn=nil;
  m_PlayingPlayerObjList = {}
  playerCtrlDc = {}
  this.lateMessage=nil;
  this.jiangchiShow=false;
  coroutine.Stop()
  LuaGC()
end


function this:handleBtnsFunc(  )
  m_BtnBeginObj = this.transform:FindChild("Content/User/Button_begin").gameObject
   this.mono:AddClick(m_BtnBeginObj,this.UserReady)
  local tBackBtn = this.transform:FindChild('Panel_button/Button_back').gameObject
  this.mono:AddClick(tBackBtn,this.ClickBack)
 this.lateMessage={};

  m_UserPlayerObj = this.transform:FindChild('Content/User').gameObject
  m_MsgWaitBetObj  = this.transform:FindChild('Content/MsgContainer/MsgWaitBet').gameObject
  m_MsgWaitNextObj = this.transform:FindChild('Content/MsgContainer/MsgWaitNext').gameObject
  m_BtnCallBankersObj = this.transform:FindChild('Content/User/BtnCallBanker').gameObject
  m_BtnCallBankersObj.transform.localPosition = m_BtnCallBankersObj.transform.localPosition + Vector3.up*45
  m_BtnShowObj = this.transform:FindChild("Content/User/Button_show").gameObject
  this.mono:AddClick(m_BtnShowObj,this.UserShow)
  m_MsgAccountFailedObj = this.transform:FindChild('Content/MsgContainer/MsgAccountFailed')
   local tCallBankerBtn = this.transform:FindChild("Content/User/BtnCallBanker/Button1").gameObject
  this.mono:AddClick(tCallBankerBtn, 
    function ()
      this.mono:SendPackage( cjson.encode({type="bbnn", tag="re_banker", body=1}) )
      m_MsgWaitBetObj:SetActive(true)
      m_BtnCallBankersObj:SetActive(false)
    end
  )
  m_ShowCardSp = this.transform:FindChild('Panel_button/Button_back/liangPaiUi').gameObject:GetComponent('UISprite')
  local giveupBtn = this.transform:FindChild("Content/User/BtnCallBanker/Button0").gameObject
  this.mono:AddClick(giveupBtn, 
    function ()
      this.mono:SendPackage( cjson.encode({type="bbnn", tag="re_banker", body=0}) )
      m_BtnCallBankersObj:SetActive(false)
    end
  )

  m_ChooseChipObj = this.transform:FindChild("Content/User/ChooseChips").gameObject         
  local btns = m_ChooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true),true)

  for i=0, btns.Length-1 do
    local btn = btns[i].gameObject
    if(string.find(btn.name, "Button") ~= nil)then
      this.mono:AddClick(btn, 
        function ()
          local chip =  tonumber(btn.name) 
          local jsonObj = { type="bbnn", tag="chip_in", body=chip }
          local jsonStr = cjson.encode(jsonObj)
          this.mono:SendPackage(jsonStr)
        end
      )
    end
  end 
 
 local  btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
  this.mono:AddClick(btn_MsgQuit, this.UserQuit)
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

  local btn_AddMoney = this.FootInfoPrb.transform:FindChild("FootInfo/MsgAddMoney/Button_yes").gameObject
	this.mono:AddClick(btn_AddMoney, this.OnAddMoney); 
  --this.mono:AddClick( this.FootInfoPrb.transform:FindChild('FootInfo/Foot - Anchor/Info/Btn_Recharge').gameObject ,function ()
     -- this:OnAddMoney()
  --end)
  this.jiangchiShow=false;

end



function this:Awake()
	log("------------------awake of GameMXNNPanel")


  this.isStart = false;
        
 	local sceneRoot = this.transform.root:GetComponent("UIRoot")
 	if sceneRoot ~= nil then
  		-- local manualHeight = 800
  		sceneRoot.scalingStyle= UIRoot.Scaling.ConstrainedOnMobiles;
  		-- sceneRoot.manualHeight = manualHeight;
  		-- sceneRoot.manualWidth  = 1422;
      sceneRoot.scalingStyle= UIRoot.Scaling.ConstrainedOnMobiles;
      sceneRoot.manualHeight = 1920 
      sceneRoot.manualWidth = 1080
 	end
   log("是否开奖池");
   log(PlatformGameDefine.playform.IsPool);
  if PlatformGameDefine.playform.IsPool then
      local JiangChiPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalJiangChiPrb")
      local tJCObj = GameObject.Instantiate(JiangChiPrb)
      --tJCObj.transform:FindChild('PoolInfo/firstView').localPosition = Vector3.New(-310,1000,0)
      --tJCObj.transform:FindChild('PoolInfo/firstView').gameObject:GetComponent("UIWidget"):SetAnchor(tJCObj.transform:FindChild('PoolInfo').gameObject,-450,-142,942,1066);
      local anchortarget=tJCObj.transform:FindChild('PoolInfo/firstView').gameObject:GetComponent("UIWidget");
      this.jiangchiBtn=tJCObj.transform:FindChild('PoolInfo/firstView').gameObject;
      anchortarget.leftAnchor.absolute = -450;
      anchortarget.rightAnchor.absolute = -142;
      anchortarget.bottomAnchor.absolute = -138;
      anchortarget.topAnchor.absolute = -14;
      anchortarget.bottomAnchor.relative = 1;
      anchortarget.topAnchor.relative = 1;	
  end


  -- local footInfoPrb = ResManager:LoadAsset("gamenn/footinfo2prb","FootInfo2Prb")
 footInfoPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalFootInfo")
   this.FootInfoPrb  = GameObject.Instantiate(footInfoPrb)
  sceneRoot =  this.FootInfoPrb:GetComponent('UIRoot')
  sceneRoot.manualHeight = 1920 
  sceneRoot.manualWidth = 1080

  this.NNCount = this.transform:FindChild("Content/NNCount").gameObject:GetComponent("Animator")	
	this.NNCountNum = this.transform:FindChild("Content/NNCount/Sprite").gameObject:GetComponent("UILabel")	

  --local settingPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalNewSettingPrb")
  --local tSetting =  GameObject.Instantiate(settingPrb)
  --sceneRoot =  tSetting:GetComponent('UIRoot') 
  --sceneRoot.manualHeight = 1920 
  --sceneRoot.manualWidth = 1080
  this:handleBtnsFunc()


   --sthis.transform:FindChild('Content/NNCount'):GetComponent('UIAnchor').enabled =true
end



function this:Start()
   if(SettingInfo.Instance.autoNext == true) then
    if m_BtnBeginObj == nil then
      m_BtnBeginObj = this.gameObject:FindChild("Content/".. m_nnPlayerName .. EginUser.Instance.uid .."/Button_begin").gameObject
    end
    -- m_BtnBeginObj=this.gameObject:FindChild("Button_begin").gameObject
    m_BtnBeginObj:SetActive(false)
  end
  
  this.mono:StartGameSocket()
   _isCallUpdate = true
  coroutine.start(this.UpdateInLua) 
  coroutine.start(this.Update);

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
    this:TimeUpdate()
    coroutine.wait(0.3)
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


function this:SocketReceiveMessage( message )
  local msgStr = self
  local cjson = require "cjson"

  local msgData = cjson.decode(msgStr)
  local type1 = msgData["type"]
  local tag   = msgData["tag"]

  if type1 == "game" then
    if  tag == "enter"  then
      log(msgStr);
      this:ProcessEnter(msgData)
    elseif tag == "ready" then
      log(msgStr);
      if isgameover then
				table.insert(this.lateMessage,msgData);
			else
				this:ProcessReady(msgData)
			end	  
    elseif tag == "come"  then
      log(msgStr);
      if isgameover then
				table.insert(this.lateMessage,msgData);
			else
				this:ProcessCome(msgData)
			end	    
    elseif tag == "leave"  then
      log(msgStr);
      if isgameover then
				table.insert(this.lateMessage,msgData);
			else
				this:ProcessLeave(msgData)
			end	  
    elseif tag == "deskover"  then
      this:ProcessDeskOver(msgData)
    elseif tag == "notcontinue" then
      coroutine.start(this.ProcessNotcontinue)
    end
  elseif type1 == 'bbnn' then
    if tag == "time"  then
      local t = tonumber(msgData["body"])
      this:UpdateHUD(t)
    elseif tag == "re_enter" then
      this:ProcessLate(msgData)
    elseif tag == "commit" then
		  log(msgStr);
      this:ProcessOk(msgData)
	  
    elseif tag == "ask_banker" then
      log(msgStr);
      this:ProcessAskbanker(msgData)
    elseif tag == "start_chip" then
      log(msgStr);
      this:ProcessStartchip(msgData)
    -- elseif tag == 'chip' then
    --   this:ProcessChip(msgData)
    elseif tag == "deal" then
      log(msgStr);
      --this:ProcessDeal(msgData)
      coroutine.start(this.ProcessDeal, msgData)
    elseif tag == 'game_over' then
		  log(msgStr);
      coroutine.start(this.ProcessEnd, msgData)
    elseif tag == 'run' then  
     log(msgStr);
       local tStr = msgData['body']
        this:ProcessRun(tostring(tStr[1]))
    end
  elseif type1 == "seatmatch"  then
    if tag == "on_update"  then
      this:ProcessUpdateAllIntomoney(msgData)
    end
  elseif type1 == "niuniu" then
    if tag == "pool" then
        log(msgStr);
        if PlatformGameDefine.playform.IsPool  then
          -- print("PlatformGameDefine.playform.IsPool = true")
            local info = find('PoolInfo')
            local chiFen = tostring(msgData["body"]["money"])
            local infos  = msgData["body"]["msg"]
            if info ~= nil  then
              PoolInfo:show(chiFen, infos)
              this.jiangchiShow=true;
            end
        end
    
    elseif tag == 'mypool' then
      log(msgStr);
        if PlatformGameDefine.playform.IsPool then
            local chiFen = msgData['body']
            local info   = find('PoolInfo')
            if info ~=nil then
                PoolInfo:setMyPool(chiFen)
            end
        end
    elseif tag == 'mylott' then
       log(msgStr);
        local msg
        if msgData["body"]["msg"] ~= nil then
            msg = msgData["body"]["msg"]
        else
            msg = msgData["body"]
        end

        if PlatformGameDefine.playform.IsPool then
            local info = find('PoolInfo')
            if info ~= nil then
              PoolInfo:setMyPool(msg)
            end
        end
    end
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
function this:ProcessLate(pMessage)
  if m_IsReEnter == false then
    m_IsLate = true
    m_MsgWaitNextObj:SetActive(true)
  end
 if m_BtnBeginObj == nil then
    m_BtnBeginObj = this.gameObject:FindChild("Content/".. m_nnPlayerName .. EginUser.Instance.uid .."/Button_begin").gameObject
  end
  m_BtnBeginObj:SetActive(false)
  local tBody = pMessage['body']
  local t =tonumber(tBody['timeout'])
  local tStep = tonumber(tBody['step'])
  local tBid = tonumber(tBody['bid'])
  local tChip = tBody['chips']
  local tGid = tostring(tBody['bid'])
  local tShowC = tBody['showcard']
  local tShopP = tostring(tShowC[1])
  this:ProcessRun(tShopP)
  this:UpdateHUD(t)

  if tBid ~= 0 then 
    m_BankerPlayerObj = find(m_nnPlayerName..tBid)
    this:getPlayerCtrl(m_BankerPlayerObj.name):SetBanker(true)
  end

  local tInfos = tBody['infos']
  for k,v in pairs(tInfos) do
    local tUid = tostring(v['uid'])
    local tShowNum = tonumber(v['is_commit'])
    local tCards = v['cards']
    local tCardType= tonumber(v['type'])
    local tPerChip = tonumber(v['final'])
    local tPlayer = find(m_nnPlayerName..tUid)
    if tPlayer~= nil then
      local tCtrl = this:getPlayerCtrl(tPlayer.name)
      if tPlayer ~= m_UserPlayerObj then
        if tPerChip ~= 0 then
          tCtrl:SetBet(tPerChip)
        end
        if tStep == 3 then
          tCtrl:SetLate(nil)
          if tShowNum == 1 then 
            tCtrl:SetShow(true)
          end
        end
      else
        if tStep == 1 then
          if tGid == EginUser.Instance.uid then
            m_BtnCallBankersObj:SetActive(true)
          end
        elseif tStep == 2 then
          if tPerChip ~=0 then
            tCtrl:SetBet(tPerChip)
          else
              m_ChooseChipObj:SetActive(true)
            local tBtns = m_ChooseChipObj:GetComponentsInChildren(Type.GetType('UIButton',true))
            for i=0, btns.Length-1 do
									local tBtn = tBtn[i].gameObject 
									local iPlus = i+1
									btn.name = tostring( tChip[iPlus])
									btn.transform:FindChild("BetLabel"):GetComponent("UILabel").text = tostring( tChip[iPlus] )
							end 
          end
        elseif tStep ==3 then
          tCtrl:SetLate(tCards)
          if tShowNum ==1 then
            tCtrl:SetCardTypeUser(tCards,tCardType,0)
          else
            tCtrl:SetShow(true)
            coroutine.start(function (  )
              coroutine.wait(1)
              m_BtnShowObj:SetActive(true)
              
            end)
          end  
        end
      end
    end
  end
end

function this:ProcessRun(pMsg)
 
  m_ShowCardSp.gameObject:SetActive(true)
  m_ShowCardSp.spriteName = 'card_'..tostring(pMsg)
end

function this:ProcessEnter(pMessageObj)
  local tBody = pMessageObj['body']
  local tMemberInfos = tBody['memberinfos']
   m_UserPlayerObj = this.transform:FindChild('Content/User').gameObject
  
  for k,v in pairs(tMemberInfos) do
    if v ~= nil then
      if tostring(v['uid']) == tostring(EginUser.Instance.uid) then
        table.insert(m_PlayingPlayerObjList,m_UserPlayerObj)
        m_IsReEnter = true
        m_UserPlayerObj.name = m_nnPlayerName..EginUser.Instance.uid
        if SettingInfo.Instance.autoNext == true then
          this:UserReady()
        end
        break;
      end
    end
  end
  this:bindPlayerCtrl(m_UserPlayerObj.name,m_UserPlayerObj)
  m_UserPlayerCtrl = this:getPlayerCtrl(m_UserPlayerObj.name)
  for k,v in pairs(tMemberInfos) do
    if v ~= nil then
      if tostring(v['uid']) ~= tostring(EginUser.Instance.uid) then
        this:AddPlayer(v)
      end
    end
  end
  local tDeskInfo = tBody['deskinfo']
  local t = tonumber(tDeskInfo['continue_timeout'])
  this:UpdateHUD(t)
end


function this:AddPlayer(pMemberInfo)

  local tUid = tostring(pMemberInfo['uid'])
  m_OtherUid = tUid
  local tBagMoney = tostring(pMemberInfo['bag_money'])
  local tNickName = tostring(pMemberInfo['nickname'])
  local tAvatar_no = tonumber(pMemberInfo['avatar_no'])
  local tLevel = tostring(pMemberInfo['level'])

  local contentObj = this.transform:FindChild("Content").gameObject
  m_DznnPlayerPreObj = ResManager:LoadAsset("gamebbdz/bbdzplayer","BBDZPlayer")
  
  local tPlayer =  NGUITools.AddChild(contentObj,m_DznnPlayerPreObj)
  tPlayer.name = m_nnPlayerName..tUid 
  local tAnchor = tPlayer:GetComponent('UIAnchor')
  tAnchor.side = UIAnchor.Side.Top
  tAnchor.relativeOffset = Vector2.New(0,-0.07)
  this:bindPlayerCtrl(tPlayer.name, tPlayer)
  local tCtrl  = this:getPlayerCtrl(tPlayer.name)
  tCtrl:SetPlayerInfo(tAvatar_no,tNickName,tBagMoney,tLevel)
  table.insert(m_PlayingPlayerObjList,tPlayer)
  return tPlayer
end



function this:ProcessReady(pMessageObj)
  local tUid = tostring(pMessageObj['body'])
  local tPlayer = find(m_nnPlayerName..tUid)
  log(tPlayer.name);
  log("准备玩家名称");
  if tPlayer then
      local tCtrl = this:getPlayerCtrl(tPlayer.name)
      if tUid == tostring(EginUser.Instance.uid) then
         coroutine.start(tCtrl.SetDeal, tCtrl, false, nil)
         tCtrl:SetCardTypeUser(nil,0,0)
         tCtrl:SetScore(-1)
      else
         if m_BtnBeginObj.activeSelf == false then
             coroutine.start(tCtrl.SetDeal, tCtrl, false, nil)
             tCtrl:SetCardTypeOther(nil,0,0)
             tCtrl:SetScore(-1)
             tCtrl:SetWait(false);
         end
      end
      tCtrl:SetReady(true)
   end
end

function this:UserReady()
 
 if this.mono == nil then
  return
 end

   if m_BankerPlayerObj ~= nil then
     this:getPlayerCtrl(m_BankerPlayerObj.name):SetBanker(false)
   end

   local tStartJson = {}
   tStartJson['type'] = 'bbnn'
   tStartJson['tag'] = 'start'
   this.mono:SendPackage(cjson.encode(tStartJson))
  local audioClip = ResManager:LoadAsset('gamenn/Sound','GAME_START');
  EginTools.PlayEffect(audioClip);
   if m_BtnBeginObj == nil then
      m_BtnBeginObj = this.gameObject:FindChild("Content/".. m_nnPlayerName .. EginUser.Instance.uid .."/Button_begin").gameObject
    end
  m_BtnBeginObj:SetActive(false)
end 

function this:ProcessAskbanker(pMessageObj)
  m_IsPlaying = true
  for k,v in pairs(m_PlayingPlayerObjList) do
    if IsNil(v) ==false then
      local tCtrl = this:getPlayerCtrl(v.name)
      if v ~= m_UserPlayerObj then
        coroutine.start(tCtrl.SetDeal, tCtrl, false, nil)
        tCtrl:SetCardTypeOther(nil,0,0)
        tCtrl:SetScore(-1)
        tCtrl:SetCallBanker(false)
      end
      tCtrl:SetReady(false)
    end
  end
  local tBody = pMessageObj['body']
  local tUid = tostring(tBody['uid'])
  if tUid == tostring(EginUser.Instance.uid) then
    m_BtnCallBankersObj:SetActive(true)
  elseif tUid ~= tostring(EginUser.Instance.uid) and m_IsLate == false then 

    if m_BtnCallBankersObj.activeSelf then
      m_BtnCallBankersObj:SetActive(false)
    end
    local tObj = find(m_nnPlayerName..tUid)
    this:getPlayerCtrl(tObj.name):SetCallBanker(true)
  end
  local t = tonumber(tBody['timeout'])
  this:UpdateHUD(t)
end

function this:UserCallBanker(pBtn)
  local tRe_Banker = {}
  tRe_Banker['type'] = 'bbnn'
  tRe_Banker['tag'] = 're_banker'
  if tBtn.name == 'Button1' then
    tRe_Banker['body'] = 1 
    m_MsgWaitBetObj:SetActive(true)
  elseif tBtn.name == 'Button0' then
    tRe_Banker['body']=0
  end
  this.mono:SendPackage(cjson.encode(tRe_Banker) )
  m_BtnCallBankersObj:SetActive(false)
end


function this:ProcessStartchip(pMessageObj)

  for k,v in pairs( m_PlayingPlayerObjList ) do
    if IsNil(v) == false then
      if v ~= m_UserPlayerObj then
        this:getPlayerCtrl(v.name):SetCallBanker(false) 
      end
    end
  end
  if m_BtnCallBankersObj.activeSelf then
    m_BtnCallBankersObj:SetActive(false)
  end
  local tBody  = pMessageObj['body']
  local tBid = tostring(tBody['bid'])
  m_BankerPlayerObj = find(m_nnPlayerName..tBid)
  local tCtrl  = this:getPlayerCtrl(m_BankerPlayerObj.name)
  tCtrl:SetCallBanker(false)
  tCtrl:SetBanker(true)
  -- print('-----------start chip ------------')
  -- print(cjson.encode(tBody))
  if m_IsLate == false and m_BankerPlayerObj ~= m_UserPlayerObj then
    local tChip = tBody['chip']
    m_ChooseChipObj:SetActive(true)
    local tBtns = m_ChooseChipObj:GetComponentsInChildren(Type.GetType('UIButton',true))
    for i=0, tBtns.Length-1 do
		  local tBtn = tBtns[i].gameObject 
			local iPlus = i + 1
			local chipPrice = tChip[iPlus]
			tBtn.name = chipPrice .. ""
			tBtn.transform:FindChild("BetLabel"):GetComponent("UILabel").text = tChip[iPlus] .. ""
		end
  end
  local t = tonumber(tBody['timeout'])
  this:UpdateHUD(t)
end


function this:ProcessChip(pMessageObj)
  local tInfos = pMessageObj['body']
  local tUid = tonumber(tInfos[1])
  local tChip = tonumber(tInfos[2])
  local tPlayer = find(m_nnPlayerName..tUid)
  this:getPlayerCtrl(tPlayer.name):SetBet(tChip)
  if tPlayer == m_UserPlayerObj then
    m_ChooseChipObj:SetActive(false)
  end
  local tSound = ResManager:LoadAsset('gamenn/Sound','xiazhu')
  EginTools.PlayEffect(tSound)
end

function this:UserChip(pObj)
  local tChip = pObj.name
  local tChipIn = {}
  tChip['type'] = 'bbnn'
  tChip['tag'] = 'chip_in'
  tChip['body'] = tChip
  this.mono:SendPackage(cjson.encode(tChipIn))
end

function this.ProcessDeal(pMessageObj)
  if m_MsgWaitBetObj.activeSelf == true then
    m_MsgWaitBetObj:SetActive(false)
  end
  local tBody = pMessageObj['body']
  local tCard = tBody['cards']
  local tChip = tonumber(tBody['chipnum'])
  if m_BankerPlayerObj ~= m_UserPlayerObj then
    local tPlayer = find(m_nnPlayerName..EginUser.Instance.uid) 
    this:getPlayerCtrl(tPlayer.name):SetBet(tChip);
    m_ChooseChipObj:SetActive(false)
  else
    local tPlayer = find(m_nnPlayerName..m_OtherUid)
    this:getPlayerCtrl(tPlayer.name):SetBet(tChip)
  end
  local tSound = ResManager:LoadAsset('gamenn/Sound','xiazhu')
  EginTools.PlayEffect(tSound) 

  for k,v in pairs(m_PlayingPlayerObjList) do
    if IsNil(v) == false then
      local ctrl = this:getPlayerCtrl(v.name)
      if v == m_UserPlayerObj then
         coroutine.start(ctrl.SetDeal, ctrl, true, tCard)
      else
         coroutine.start(ctrl.SetDeal, ctrl, true, nil)
      end
    end
  end

  coroutine.wait(2.5);
  if m_IsLate== false then
      coroutine.start(function ( )
         m_BtnShowObj:SetActive(true)
      end)
  end
  local t = tonumber(tBody['timeout'])
  this:UpdateHUD(t)

end


function this:ProcessOk(pMessageObj)
  local tBody = pMessageObj['body']
  if tBody == nil or tBody['cards'] == nil then
    local tPlayer  = find(m_nnPlayerName..m_OtherUid)
    if tPlayer ~= nil then
      this:getPlayerCtrl(tPlayer.name):SetShow(true)
    end
  else
    local tCards =tBody['cards']
    local tCardType = tonumber(tBody['type'])
	local isgold=tonumber(tBody['is_gold_nn']);
	if isgold~=nil then
		m_UserPlayerCtrl:SetCardTypeUser(tCards,tCardType,isgold)
	else
		m_UserPlayerCtrl:SetCardTypeUser(tCards,tCardType,0)
	end
  end
  local tSound = ResManager:LoadAsset('gamenn/Sound','tanover')
  EginTools.PlayEffect(tSound)
end

function this:UserShow()
  local tOk = {}
  tOk['type']= 'bbnn'
  tOk['tag'] = 'commit'
  this.mono:SendPackage(cjson.encode(tOk))
  m_BtnShowObj:SetActive(false)
end



function this.ProcessEnd(pMessageObj)
    isgameover=true;
    for k,v in pairs(m_PlayingPlayerObjList) do
      if IsNil(v) == false then
        this:getPlayerCtrl(v.name):SetBet(0)
        if v~= m_UserPlayerObj then
          this:getPlayerCtrl(v.name):SetShow(false)
        end
      end
    end
    if m_MsgWaitNextObj.activeSelf then
      m_MsgWaitNextObj:SetActive(false)
    end
    -- m_PlayingPlayerObjList = {}
    local winposition=0;
    local tBody = pMessageObj['body']
    local tInfo = tBody['infos']
    for k,v in pairs(tInfo) do
        local tUid = tostring(v['uid'])
        local tPlayer = find(m_nnPlayerName..tUid)
        if tPlayer ~= nil then
            local tCtrl = this:getPlayerCtrl(tPlayer.name)
            local tScore = tonumber(v['final'])
            if tonumber(tScore)>0 then
                winposition=tCtrl.movetarget.transform.position;
            end
        end
    end


    for k,v in pairs(tInfo) do
        local isown=false;
        local tUid = tostring(v['uid'])
        local tPlayer = find(m_nnPlayerName..tUid)
        if tPlayer ~= nil then
            local tCtrl = this:getPlayerCtrl(tPlayer.name)
            local tCards = v['cards']
            local tCardType = tonumber(v['type'])
            local tScore = tonumber(v['final'])
            local isgold=tonumber(v['is_gold_niuniu']);--是否黄金牛牛
            local isgold_win=tonumber(v['gold_nn_win_money']);--黄金牛牛奖励
            if tUid ~= EginUser.Instance.uid then
                if isgold~=nil then
                  tCtrl:SetCardTypeOther(tCards,tCardType,isgold)
                else
                  tCtrl:SetCardTypeOther(tCards,tCardType,0)
                end
            else
                isown=true;
                if m_BtnShowObj.activeSelf == true then
                    m_BtnShowObj:SetActive(false)
                    if isgold~=nil then
                        tCtrl:SetCardTypeUser(tCards,tCardType,isgold)
                    else
                        tCtrl:SetCardTypeUser(tCards,tCardType,0)
                    end
                end
                if isgold~=nil and isgold==1 then
                  tCtrl:SetJiangLi(isgold_win);
                end
          
                local tSound
                if tCardType == 10 or tCardType ==11  then
                  tSound = ResManager:LoadAsset('gamenn/Sound','niuniu2')
                elseif tCardType ==12 then
                  tSound = ResManager:LoadAsset('gamenn/Sound','wuhuaniu')
                elseif tCardType ==13 then
                  tSound = ResManager:LoadAsset('gamenn/Sound','sizha')
                elseif tCardType ==14 then
                  tSound = ResManager:LoadAsset('gamenn/Sound','wuxiaoniu1')  
                end
                EginTools.PlayEffect(tSound)
                if tonumber(tScore)>0 then
                  tSound = ResManager:LoadAsset('gamenn/Sound','win')
                else
                  tSound = ResManager:LoadAsset('gamenn/Sound','fail')
                end
                EginTools.PlayEffect(tSound) 
            end
            tCtrl:SetScore(tScore,winposition,isown)
        end
    end
    coroutine.start(this.AfterDoing, 0.2, 
				function()
        --[[
				for i=1,8 do
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
    m_ShowCardSp.gameObject:SetActive(false)
    this:ChuLiXiaoXi();

    if m_BtnBeginObj == nil then
      m_BtnBeginObj = this.gameObject:FindChild("Content/".. m_nnPlayerName .. EginUser.Instance.uid .."/Button_begin").gameObject
    end
    if m_IsLate==true then
      local tSound = ResManager:LoadAsset('gamenn/Sound','GAME_END')
      EginTools.PlayEffect(tSound) 
      m_IsLate = false 
    else
     -- m_BtnBeginObj.transform.localPosition = Vector3.right*300
    end
    if SettingInfo.Instance.autoNext == true then
      coroutine.wait(2)
      this:UserReady()
    else
      m_BtnBeginObj:SetActive(true)
    end
    local t = tonumber(tBody['timeout'])
    this:UpdateHUD(t)
    m_IsPlaying = false 
end

function this:ProcessDeskOver (pMessageObj)
  print('in process desk over ')  
end

function this:playsound()
	  --EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","nbet") )
    EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","Pool_Win") )
end

function this:ProcessUpdateAllIntomoney(pMessageObj)
  -- print('**********update all in money *********')
   local msgStr = cjson.encode(pMessageObj)
  if string.find(msgStr,tostring(EginUser.Instance.uid))==nil then
    return
  end

  local tInfos = pMessageObj['body']
  for k,v in pairs(tInfos) do
    local tUid = tostring(v[1])
    local tIntoMoney = tostring(v[2])
    local tPlayer = find(m_nnPlayerName..tUid)
    if tPlayer ~= nil then
      this:getPlayerCtrl(tPlayer.name):UpdateIntomoney(tIntoMoney)
    end
  end
end

function ProcessUpdateIntomoney(pMessageObj)

    -- print('  update  into  money')
    local tIntoMoney = tostring(pMessageObj['body'])
    local tInfo = find('FootInfo')
    if tInfo ~= nil then
      -- local  this.FootInfoPrb  = tInfo.gameObject:GetComponent('FootInfo')
      FootInfo:UpdateIntomoney(tIntoMoney)
    end

end

function this:ProcessCome(pMessageObj )
  local tBody =  pMessageObj['body']
  local tMemberInfos = tBody['memberinfo']
  this:AddPlayer(tMemberInfos)  
end

function this:ProcessLeave(pMessageObj)
  local tUid = tostring(pMessageObj['body'])
  if tUid ~= tostring(EginUser.Instance.uid) then
    local tPlayer = find(m_nnPlayerName..tUid)
    this:removePlayerCtrl(tPlayer.name)
    if tableContains( m_PlayingPlayerObjList,tPlayer) then
      tableRemove( m_PlayingPlayerObjList,tPlayer)
    end
    destroy(tPlayer)
  end
end

function this:UserLeave( )
  -- print('  user leave  ')
  local tUserLeave = {}
  tUserleave['type'] = 'game'
  tUserleave['tag'] = 'leave'
  tUserleave['body'] = EginUser.Instance.uid
  this.mono:SendPackage(cjson:encode(tUserLeave))
end

function this:UserQuit()
  -- print('   quit  ')
  SocketConnectInfo.Instance.roomFixseat = true
  local tUserQuit = {}
  tUserQuit['type'] = 'game'
  tUserQuit['tag'] = 'quit'
  this.mono:SendPackage(cjson.encode(tUserQuit))
  this.mono:OnClickBack()
end

function this:ClickBack(  )
   print('   back  ')
  if m_IsPlaying ==false then
    this:UserQuit()
  else
    m_MsgQuitObj =  this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject
    m_MsgQuitObj:SetActive(true)
  end
end

function this.ProcessNotcontinue()
  m_MsgNotContinueObj = this.transform:FindChild('Content/MsgContainer/MsgNotContinue').gameObject
  m_MsgNotContinueObj:SetActive(true)
  coroutine.wait(3)
  this:UserQuit()
end

function this:ShowPromptHUD( pErrorInfo )
 if m_BtnBeginObj == nil then
    m_BtnBeginObj = this.gameObject:FindChild("Content/".. m_nnPlayerName .. EginUser.Instance.uid .."/Button_begin").gameObject
  end
  m_BtnBeginObj:SetActive(false)
  m_MsgAccountFailedObj:SetActive(true)
   m_MsgAccountFailedObj:GetComponentInChildren(Type.GetType("UILabel",true)).text = pErrorInfo
end

-- function SocketReady( )
--   this.mono:SocketReady()
-- end

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

function SocketDisconnect( pDisConnectInfo)
  this.mono:SocketDisconnect(pDisConnectInfo)
end

function this:OnDestroy()
	-- log("--------------------ondestroy of GameMXNNPanel")
  this:ClearLuaValue()
end
