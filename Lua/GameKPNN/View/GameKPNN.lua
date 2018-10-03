require "GameKPNN/KPNNPlayerCtrl"

local this = LuaObject:New()
GameKPNN = this

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

local m_UserAvatarSp
local m_UserNickNameLab
local m_UserBagmoneyLab
local m_UserLevelLab
local isgameover=false;
local m_PlayingPlayerObjList = {}
local m_WaitPlayerObjList = {}
local m_ReadyPlayerObjList = {}
local m_nnPlayerName = 'NNPlayer_'
local m_BankerPlayerObj

local m_UserIndex = 0
local m_IsPlaying = false 
local m_IsLate =false 
local m_IsReEnter =false 
local playerCtrlDc = {}


function this:ClearLuaValue()
    this.bankerUid="";
     this.NNCount = nil;
	  this.NNCountNum = nil;

    print('clear all ')
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
    m_MslayerObjList = {}
    m_WaitPlayerObjList = {}
    m_ReadyPlayerObjList = {}
    m_nnPlayerName = 'NNPlayer_'
    m_BankerPlayerObj = nil 
    isgameover=false;
    m_UserIndex       = 0
    m_IsPlaying      = false 
    m_IsLate    = false 
    m_IsReEnter = false 
    for k,v in pairs(playerCtrlDc) do
        v:OnDestroy()
    end
    this.lateMessage=nil;
    this.jiangchiBtn=nil;
    this.jiangchiShow=false;
    playerCtrlDc = {}
    coroutine.Stop()
    LuaGC()
end




function this:bindPlayerCtrl(objName, gameObj)
    playerCtrlDc[objName] = KPNNPlayerCtrl:New(gameObj)
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

function this:handleBtnsFunc()
    this.bankerUid="";
    this.lateMessage={};
    this.NNCount = this.transform:FindChild("Content/NNCount/NNCount").gameObject:GetComponent("Animator")	
	this.NNCountNum = this.transform:FindChild("Content/NNCount/NNCount/Sprite").gameObject:GetComponent("UILabel")	
    m_BtnBeginObj = this.transform:FindChild("Content/User/Button_begin").gameObject
    this.mono:AddClick(m_BtnBeginObj,this.UserReady)
    local tBackBtn = this.transform:FindChild('Panel_button/Button_back').gameObject
    this.mono:AddClick(tBackBtn,this.OnClickBack)
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
        this.mono:SendPackage( cjson.encode({type="djnn", tag="re_banker", body=1}) )
        m_MsgWaitBetObj:SetActive(true)
        m_BtnCallBankersObj:SetActive(false)
      end
    )

    local giveupBtn = this.transform:FindChild("Content/User/BtnCallBanker/Button0").gameObject
    this.mono:AddClick(giveupBtn, 
      function ()
        this.mono:SendPackage( cjson.encode({type="djnn", tag="re_banker", body=0}) )
        m_BtnCallBankersObj:SetActive(false)
      end
    )

    m_ChooseChipObj = this.transform:FindChild("Content/User/ChooseChips").gameObject         
    local btns = m_ChooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true),true)
    --local len  = btns.Length

    for i=0, btns.Length-1 do
      local btn = btns[i].gameObject
      if(string.find(btn.name, "Button") ~= nil)then
        this.mono:AddClick(btn, 
          function ()
            -- print("send {'type':'djnn', 'tag':'chip_in', 'body':**}")
            local chip =  tonumber(btn.name) 
            -- print("chip price:" .. tostring(chip))
            local jsonObj = { type="djnn", tag="chip_in", body=chip }
            local jsonStr = cjson.encode(jsonObj)
            this.mono:SendPackage(jsonStr)
          end
        )
      end
    end -- end for i

    local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
    this.mono:AddClick(btn_MsgQuit, this.UserQuit)

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
    log("************-awake of GameKPNNPanel **********")
    this:handleBtnsFunc()
 
        
    local sceneRoot = this.transform.root:GetComponent("UIRoot")
    if sceneRoot ~= nil then
        local manualHeight = 1920
        --  		if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
        --   			if UnityEngine.iPhone.generation:ToString().IndexOf("iPad") > -1 then
        --    			manualHeight = 1000; 
        --   			elseif Screen.width <= 960 then  -- iphone4s
        --   		 		manualHeight = 900;
        --   			end
        --  		end
    
        sceneRoot.scalingStyle= UIRoot.Scaling.ConstrainedOnMobiles;
        sceneRoot.manualHeight = manualHeight;
        sceneRoot.manualWidth  = 1080;
    end


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
    local footInfoPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalFootInfo")
    --local settingPrb = ResManager:LoadAsset("gamenn/verticalprefab","VerticalNewSettingPrb")
    GameObject.Instantiate(footInfoPrb)
    --GameObject.Instantiate(settingPrb)

    local footInfo = GameObject.Find("FootInfo")
	  local btn_AddMoney = footInfo.transform:FindChild("MsgAddMoney/Button_yes").gameObject
    this.mono:AddClick(btn_AddMoney, this.OnAddMoney); 
end

function this:Start()
    log("********* Start of GameKPNN*************")
    if(SettingInfo.Instance.autoNext == true) then
        m_BtnBeginObj=this:getUserObj("Button_begin").gameObject
        m_BtnBeginObj:SetActive(false)
    end
    
    this.mono:StartGameSocket()
    _isCallUpdate = true
    coroutine.start(this.Update);
    coroutine.start(this.UpdateInLua)
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
    elseif type1 == 'djnn' then
        if tag == "time"  then
          local t = msgData["body"]
          this:UpdateHUD(t)
        elseif tag == "late" then
            log(msgStr);
          this:ProcessLate(msgData)
        elseif tag == "ok" then
            log(msgStr);
          this:ProcessOk(msgData)
        elseif tag == "ask_banker" then
            log(msgStr);
          this:ProcessAskbanker(msgData)
        elseif tag == "start_chip" then
            log(msgStr);
          this:ProcessStartchip(msgData)
        elseif tag == 'chip' then
            log(msgStr);
          this:ProcessChip(msgData)
        elseif tag == "deal" then
            log(msgStr);
          coroutine.start(this.ProcessDeal,this,msgData);
        elseif tag == 'end' then
            log(msgStr);
          coroutine.start(this.ProcessEnd, msgData)
      
        elseif tag == 'run' then  
            log(msgStr);
            this:ProcessRun(msgData)
        end
    elseif type1 == "seatmatch"  then
        if tag == "on_update"  then
          this:ProcessUpdateAllIntomoney(msgData)
        end
    elseif type1 == "niuniu" then
        if tag == "pool" then
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
            if PlatformGameDefine.playform.IsPool then
                local chiFen = msgData['body']
                local info   = find('PoolInfo')
                if info ~=nil then
                   PoolInfo:setMyPool(chiFen)
                end
            end
        elseif tag == 'mylott' then
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

function this:ProcessLate(pMessageObj )
    print('*********ProcessLate*******')
    if m_IsReEnter == false then
      m_IsLate = true 
      m_MsgWaitNextObj:SetActive(true)
    end
    if m_BtnBeginObj == nil then
      m_BtnBeginObj=this:getUserObj("Button_begin").gameObject
    end

    m_BtnBeginObj:SetActive(false)
    
    local tBody = pMessageObj['body']
    
    local t = tonumber(tBody['t'])
    local tStep = tonumber(tBody['step'])
    local tNNBid = tonumber(tBody['bankid'])
    local tChip = tBody['chip']
    local tGid = tostring(tBody['gid'])
    this.bankerUid=tGid;
    this:UpdateHUD(t)

    if tNNBid~= 0 then
        m_BankerPlayerObj =find(m_nnPlayerName..tNNBid)
        if m_BankerPlayerObj then
            this:getPlayerCtrl(m_BankerPlayerObj.name):SetBanker(true)
        end
        -- m_BankerPlayerObj:GetComponent('KPNNPlayerCtrl'):SetBanker(true)
    end

    local tInfos = tBody['infos']
    -- print(' late   info == '..cjson.encode(tBody))
    for k,v in pairs(tInfos) do
        local tUid = tostring(v[1])

        local tWaitNum = tonumber(v[2])
        local tShowNum = tonumber(v[3])
        local tCards = v[4]
        local tCardType = tonumber(v[5])
        local tPerChip = tonumber(v[6])
        -- print('step == ' .. tostring(tStep))
        -- print('  perchip   ------------'..tostring(tPerChip))
        local tPlayer = find(m_nnPlayerName..tUid)
        if tPlayer ~= nil then
          local tCtrl =  this:getPlayerCtrl(tPlayer.name) --tPlayer:GetComponent('KPNNPlayerCtrl')
            if tWaitNum == 0 then
                if tPlayer ~= m_UserPlayerObj then
                    if tPerChip ~= 0 then
                        tCtrl:SetBet(tPerChip)
                    end

                    if tStep==3 then
                        tCtrl:SetLate(nil)
                        if tShowNum == 1 then
                            tCtrl:SetShow(true)
                        end
                    end
                else
                    if tStep == 1 then
                        if tGid == tostring(EginUser.Instance.uid) then
                            m_BtnCallBankersObj:SetActive(true)
                        end
                    elseif tStep == 2 then 
                        if tPerChip ~=0 then
                           tCtrl:SetBet(tPerChip)
                        elseif tPerChip == 0 then
                          -- print('------------in  choose chip obj ')
                          -- print(#tChip)
                            m_ChooseChipObj:SetActive(true)
                            local tBtns = m_ChooseChipObj:GetComponentsInChildren(Type.GetType('UIButton',true))
                            for i=0,#tChip-1 do
                                local tBtn = tBtns[i].gameObject
                                tBtn.name= tostring(tChip[i+1])
                                tBtn.transform:FindChild("BetLabel"):GetComponent("UILabel").text = tChip[iPlus] .. ""
                            end
                        end
                    elseif tStep == 3 then
                        tCtrl:SetLate(tCards)
                        if tShowNum == 1 then
                           tCtrl:SetCardTypeUser(tCards,tCardType,0)
                        else
                            tCtrl:SetShow(true)
                            m_BtnShowObj:SetActive(true)
                        end 
                    end
                end
            elseif tWaitNum ==1 then
               tCtrl:SetWait(true)
            end
        end
    end
end

function this:ProcessEnter(pMsgData)
      print("************* ProcessEnter***********")
      SettingInfo.Instance.deposit = false
      local body = pMsgData["body"]
      local memberinfos = body["memberinfos"]

      m_UserPlayerObj = this.transform:FindChild('Content/User').gameObject
    
      for index,value in pairs(memberinfos) do
          if(value ~= nil) then
              if( tostring(value["uid"]) == tostring(EginUser.Instance.uid) ) then
                  m_UserIndex = value['position']
                  local tISWaiting = value['waiting']
                  if tISWaiting == true  then
                     table.insert(m_WaitPlayerObjList,m_UserPlayerObj)
                  else
                     table.insert(m_PlayingPlayerObjList,m_UserPlayerObj)
                      m_IsReEnter = true
                  end

                  m_UserPlayerObj.name =  m_nnPlayerName .. EginUser.Instance.uid;
                  
                  if (SettingInfo.Instance.autoNext == true) then
                     this:UserReady()
                  end
                  break
              end
          end
      end

      this:bindPlayerCtrl(m_UserPlayerObj.name, m_UserPlayerObj )
      m_UserPlayerCtrl = this:getPlayerCtrl(m_UserPlayerObj.name)  
      for index,value in pairs(memberinfos) do
          if(value ~= null) then
              if( tostring(value["uid"]) ~= tostring( EginUser.Instance.uid ) ) then
                   this:AddPlayer(value,m_UserIndex)
              end
          end
      end
      
      local deskinfo = body["deskinfo"]
      this:UpdateHUD(deskinfo["continue_timeout"])
end


function this:AddPlayer(pMemberInfo,pUserIndex)
      local tUid = tostring(pMemberInfo['uid'])
      local tBagMoney = tostring(pMemberInfo['bag_money'])
      local tNickName = tostring(pMemberInfo['nickname'])
      local tAvatar_no = tonumber(pMemberInfo['avatar_no'])
      local tPos  = tonumber(pMemberInfo['position'])
      local tReady = pMemberInfo['ready']
      local tWait = pMemberInfo['waiting'] 
      local tLevel= tostring(pMemberInfo['level'])


      local contentObj = this.transform:FindChild("Content").gameObject
      local playerPrb = ResManager:LoadAsset("gamekpnn/kpnnplayer","KPNNPlayer")
      local tPlayer = NGUITools.AddChild(contentObj, playerPrb)


      -- local tPlayer = NGUITools.AddChild(this.gameObject,m_SrnnPlayerPreObj);
      tPlayer.name = m_nnPlayerName ..tUid
      this:SetAnchorPosition(tPlayer,pUserIndex,tPos)
      this:bindPlayerCtrl(tPlayer.name, tPlayer)
      local tCtrl = this:getPlayerCtrl(tPlayer.name) 
      tCtrl:SetPlayerInfo(tAvatar_no,tNickName,tBagMoney,tLevel)
      if tWait ==true then
          if tReady ==true then
            tCtrl:SetReady(true)
            table.insert(m_ReadyPlayerObjList,tPlayer);

          end
          table.insert(m_WaitPlayerObjList,tPlayer)
      else
          table.insert(m_PlayingPlayerObjList,tPlayer);
      end

      return tPlayer;
end


function this:ProcessDeskOver(pMsgData)
     print('Process desk over ')
end 





function this:SetAnchorPosition(pPlayer,pUserIndex,pPlayerIndex)
      print('**********  set anchor position  ***********')
      if pPlayerIndex == nil then 
           pPlayerIndex = 0
      end
      if pUserIndex == nil then
           pUserIndex = 0
      end
      local tPos_Span= tonumber(pPlayerIndex) - tonumber(pUserIndex);
      local tAnchor = pPlayer.gameObject:GetComponent('UIAnchor')
      if tPos_Span == 0 then
            tAnchor.side = UIAnchor.Side.Bottom
      elseif tPos_Span ==1 or tPos_Span ==-3 then
            tAnchor.side = UIAnchor.Side.Right 
            tAnchor.relativeOffset = Vector2.New(-0.09,0.08)
      elseif tPos_Span ==2 or tPos_Span == -2 then
            tAnchor.side = UIAnchor.Side.Top
            tAnchor.relativeOffset = Vector2.New(0,-0.07)
      elseif tPos_Span ==3 or tPos_Span == -1 then
            tAnchor.side = UIAnchor.Side.Left
            tAnchor.relativeOffset = Vector2.New(0.09,0.08)
      end
end



function this:ProcessReady(pMsg)
      print('********* process ready ******** ')
      local tUid = pMsg['body']
      local tPlayer = find(m_nnPlayerName..tUid)
      local tCtrl =this:getPlayerCtrl(tostring(tPlayer.name))
      if tostring(tUid) == tostring(EginUser.Instance.uid) then
            tCtrl:SetDeal(false,nil);
            tCtrl:SetCardTypeUser(nil,0,0)
            tCtrl:SetScore(-1)
      else
          if not m_BtnBeginObj.activeSelf then
              tCtrl:SetDeal(false,nil)
              tCtrl:SetCardTypeOther(nil,0,0)
              tCtrl:SetScore(-1)
              tCtrl:SetWait(false);
          end
      end
      tCtrl:SetReady(true)
      table.insert( m_PlayingPlayerObjList,tPlayer)
end


function this:UserReady()
      print('************* user  ready ***********')
      --if NNCount.Instance then
          --NNCount.Instance:DestroyHUD();
      --end
      if(this.mono == nil)then
           return
      end

      if m_BankerPlayerObj ~= nil then 
          this:getPlayerCtrl(m_BankerPlayerObj.name):SetBanker(false);
      end
      local tStartJson = {}
      tStartJson['type']='djnn'
      tStartJson['tag'] = 'start';
      this.mono:SendPackage(cjson.encode(tStartJson));
      local audioClip = ResManager:LoadAsset('gamenn/Sound','GAME_START');
      EginTools.PlayEffect(audioClip);
      if m_BtnBeginObj == nil then
           m_BtnBeginObj = this:getUserObj("Button_begin").gameObject
      end
      m_BtnBeginObj:SetActive(false)
  
end

function this:ProcessRun(pMessage)
      print(' ********  process run  *********** ')
      for k,v in pairs(m_ReadyPlayerObjList) do
          if tableContains(m_PlayingPlayerObjList,v) == false and tableContains(m_WaitPlayerObjList,v)== false then
            table.insert(m_PlayingPlayerObjList,v)
          end
      end 

    
      m_ReadyPlayerObjList = {}
      m_IsPlaying = true

      for k,v in pairs( m_PlayingPlayerObjList) do 
          if v ~= m_UserPlayerObj  and  IsNil(v) ==false then
              local tCtrl = this:getPlayerCtrl(v.name)
              tCtrl:SetDeal (false,nil)
              tCtrl:SetCardTypeOther(nil,0,0)
              tCtrl:SetScore(-1)
              tCtrl:SetCallBanker(false)
          end
      end

      for k,v in pairs(m_PlayingPlayerObjList) do
          this:getPlayerCtrl(v.name):SetReady(false)
      end
      local tBody = pMessage['body']
      local tBodyList =tBody['cards']
      for k,v in pairs(m_PlayingPlayerObjList) do 
          if v == m_UserPlayerObj then
          
              this:getPlayerCtrl(v.name):SetTwoDeal(true,tBodyList)
          else
              this:getPlayerCtrl(v.name):SetTwoDeal(true,nil)
          end
      end
end


function this:ProcessAskbanker(pMessage)
      print('************process ask banker ************')
      m_IsPlaying = true
      local tBody = pMessage['body']
      local tUid = tostring(tBody['uid'])
      if tostring(tUid) == tostring(EginUser.Instance.uid) then
           m_BtnCallBankersObj:SetActive(true)

      elseif tostring(tUid) ~= tostring(EginUser.Instance.uid) and m_IsLate == false then
          if m_BtnCallBankersObj.activeSelf then
             m_BtnCallBankersObj:SetActive(false)
          end 
          local tObj = find(m_nnPlayerName..tUid).gameObject
          local tCtrl =  this:getPlayerCtrl(tObj.name)--:GetComponent('KPNNPlayerCtrl')
          tCtrl:SetCallBanker(true)
          for k,v in pairs( m_PlayingPlayerObjList ) do
              if IsNil(v)== false then
                  if  tObj.name ~= v.name  then
                       this:getPlayerCtrl(v.name):SetCallBanker(false)
                  end    
              end
          end  
      end


      local tTimeOut = tBody['timeout']
      this:UpdateHUD(tTimeOut)
end

function this:UserCallBanker(pBtn)
      print('********** User call  banker    ***********')
      local tReBanker={}
      tReBanker['type']='djnn'
      tReBanker['tag'] = 're_banker'
      if pBtn.name == 'Button1' then
          tReBanker['body'] = 1
          m_MsgWaitBetObj:SetActive(true)
      elseif pBtn.name == 'Button0' then
          tReBanker['body']= 0
      end
      this.mono:SendPackage(cjson.encode(tReBanker))
      m_BtnCallBankersObj:SetActive(false)
end

function this:ProcessStartchip( pMessage)
      print('**********  process start chip   ***********')
      if m_BtnCallBankersObj.activeSelf then
           m_BtnCallBankersObj:SetActive(false)
      end

      local tBody = pMessage['body'];
      local tBid = tostring(tBody['bid'])
      this.bankerUid=tBid;
      m_BankerPlayerObj = find(m_nnPlayerName..tBid)
      if m_BankerPlayerObj then
          local tCtrl =  this:getPlayerCtrl(m_BankerPlayerObj.name)
          tCtrl:SetCallBanker(false)
          tCtrl:SetBanker(true)
      end
      -- print(m_IsLate,' late ')
      -- print(m_BankerPlayerObj.name  ..'  <=banker   user =>  ' .. m_UserPlayerObj.name)
      if m_IsLate == false and m_BankerPlayerObj ~= m_UserPlayerObj then
          local tChip = tBody['chip']
          m_ChooseChipObj:SetActive(true)
          local tBtns = m_ChooseChipObj:GetComponentsInChildren(Type.GetType('UIButton',true))  
          for i=0,#tChip-1 do
              local tBtn = tBtns[i].gameObject
              local iPlus = i + 1
              tBtn.name = tostring(tChip[i+1]..'')
              tBtn.transform:FindChild("BetLabel"):GetComponent("UILabel").text = tChip[iPlus] .. ""   
          end   
      end
      local tTimeOut = tonumber(tBody['timeout'])
      this:UpdateHUD(tTimeOut)

end

function this:ProcessChip(pMessage)
      print('**********  process chip   ***********')
      local tInfos = pMessage['body']
      local tUid = tostring(tInfos[1])
      local tChip = tonumber(tInfos[2])
      local tPlayer = find(m_nnPlayerName..tUid)
      if tPlayer then
          local tCtrl = this:getPlayerCtrl(tPlayer.name)  
          tCtrl:SetBet(tChip)
          if tPlayer == m_UserPlayerObj then
              m_ChooseChipObj:SetActive(false)
          end
          local tSound = ResManager:LoadAsset('gamenn/Sound','xiazhu')
          EginTools.PlayEffect(tSound)
      end
end



function this:UserChip(pObj )
      print('**********  User chip  ***********')
      local tChip = pObj.name
      local tChipIn  = {}
      tChipIn['type'] = 'djnn'
      tChipIn['tag'] = 'chip_in'
      tChipIn['body'] = tChip
      this.mono:SendPackage(cjson:encode(tChipIn))
end

function this:ProcessDeal(pMessage )
      print('**************   process Deal -******')
      if m_MsgWaitBetObj.activeSelf then
           m_MsgWaitBetObj:SetActive(false)
      end
      local tBody = pMessage['body']
      local tCards = tBody['cards']
      for k,v in pairs( m_PlayingPlayerObjList ) do
          if IsNil(v) ==false  then 
              if v == m_UserPlayerObj then
                  m_UserPlayerCtrl:SetDeal(true,tCards)
              else
                  local tCtrl = this:getPlayerCtrl(v.name);
                  tCtrl:SetDeal(true,nil)
              end
          end
      end
      coroutine.wait(1);
      if m_IsLate == false then
          m_BtnShowObj:SetActive(true)
      end
      
      local tTimeOut = tBody['t']
      this:UpdateHUD(tTimeOut)
end


function this:ProcessOk(pMessage)
      print('*************process OK******')
      local tBody =pMessage['body'];
      local tUid = tostring(tBody['uid'])
      if tUid ~= tostring(EginUser.Instance.uid) then
          local tPlayer = find(m_nnPlayerName..tUid)
          if tPlayer ~= nil then
              local tCtrl =  this:getPlayerCtrl(tPlayer.name)   
              tCtrl:SetShow(true)   
          end
      else
          local tCards = tBody['cards']
          local tCardType =tonumber(tBody['type'])
          local isgold=tonumber(tBody['is_gold_nn']);
          if isgold~=nil then
               m_UserPlayerCtrl:SetCardTypeUser(tCards,tCardType,isgold)
          else
               m_UserPlayerCtrl:SetCardTypeUser(tCards,tCardType,0)
          end
          
      end

      local tSoundTanover = ResManager:LoadAsset("gamenn/Sound","tanover")
      
      EginTools.PlayEffect(tSoundTanover)
end

function  this:UserShow()
      local tMsg = {}
      tMsg['type'] = 'djnn'
      tMsg['tag'] = 'ok'
      this.mono:SendPackage(cjson.encode(tMsg));
      m_BtnShowObj = this:getUserObj("Button_show").gameObject
      m_BtnShowObj:SetActive(false)
end

function this.ProcessEnd(pMessage)
      isgameover=true;
      print('************* process end ********** ')
      for k,v in pairs( m_PlayingPlayerObjList) do
         if IsNil(v)==false then 
            local tCtrl = this:getPlayerCtrl(v.name)
            tCtrl:SetBet(0)
            if v ~= m_UserPlayerObj then
                tCtrl:SetShow(false)
            end
         end
      end
      if m_MsgWaitNextObj.activeSelf then
          m_MsgWaitNextObj:SetActive(false)
      end
      m_PlayingPlayerObjList = {}
      
      local tBody = pMessage['body']
      local infos_2 = tBody["gold_nn"]
      local infos_1=tBody["infos"];
      local tInfos;
      local has_gold=false;
      if infos_2~=nil then
          tInfos=infos_2;
          has_gold=true;
      else
          tInfos=infos_1;
          has_gold=false;
      end
  
      local tSound 

       --新添加的飞金币判断
      local wincount=0;
      local winPositionList={};
      local losePositionList={};
      local loseposition=0;
      local playerBanker = find(m_nnPlayerName .. this.bankerUid);
      if playerBanker~=nil then
          loseposition=this:getPlayerCtrl(m_nnPlayerName..this.bankerUid).movetarget.transform.position;
          table.insert(losePositionList,loseposition);
      end
      local winUidList={};
      local loseUidList={};



      for k,v in pairs(tInfos) do
          local score = tonumber(v[4])
          local uid   = tostring(v[1])
          local player1 = find(m_nnPlayerName .. uid)
          local ctrl = this:getPlayerCtrl(player1.name)
          local targetposition=ctrl.movetarget.transform.position   --飞金币的位置
          if(score>0) and tostring(uid)~=this.bankerUid then
              wincount = wincount + 1
              table.insert(winPositionList, targetposition)
              table.insert(winUidList,tostring(uid));
          elseif score<0 and tostring(uid)~=this.bankerUid then
              table.insert(loseUidList,tostring(uid));
          end
      end


      for k,v in pairs(tInfos) do
          local tUid = tostring(v[1])--tostring(tJos['uid'])
          local tPlayer = find(m_nnPlayerName..tUid)
          if tPlayer ~= nil then
              local tCtrl = this:getPlayerCtrl(tPlayer.name)
              local tCards = v[2]--tJos['cards']
              
              local tCardType = tonumber(v[3])--tonumber(tJos['type'])
              local tScore = tonumber(v[4])--tonumber(tJos['final'])
              local isgold;--是否黄金牛牛
              local isgold_win;--黄金牛牛奖励
        
              if has_gold then
                  isgold=tonumber(v[5]);   --是否为黄金牛牛
                  isgold_win=tonumber(v[6]);  --奖励金钱数
              else
                  isgold=0;
              end  
        
              if tUid ~= tostring(EginUser.Instance.uid) then
                  tCtrl:SetCardTypeOther(tCards,tCardType,isgold)
                  tCtrl:SetScore(tScore)
              else
                  if m_BtnShowObj.activeSelf then
                      m_BtnShowObj:SetActive(false)
                     tCtrl:SetCardTypeUser(tCards,tCardType,isgold)
                  end
                  if isgold==1 then
                      tCtrl:SetJiangLi(isgold_win)
                  end
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
                  tCtrl:SetScore(tScore)
              end
          end
      end

      log(wincount.."====赢家数量");
      log(#(tInfos));
      if wincount==(#(tInfos)-1) then
          this:getPlayerCtrl(m_nnPlayerName..this.bankerUid):SetFlyBetAnimation(winPositionList,this.bankerUid);
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
              this:getPlayerCtrl(m_nnPlayerName..loseUidList[i]):SetFlyBetAnimation(losePositionList,loseUidList[i]);
          end
          coroutine.start(this.AfterDoing, 1.2, 
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
              local player=find(m_nnPlayerName..loseUidList[i]);
              if player then
                this:getPlayerCtrl(m_nnPlayerName..loseUidList[i]):SetFlyBetAnimation(losePositionList,loseUidList[i]);
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
          this:getPlayerCtrl(m_nnPlayerName..this.bankerUid):SetFlyBetAnimation(winPositionList,this.bankerUid);
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
      coroutine.wait(1.8);
      this:ChuLiXiaoXi();


      for k,v in pairs(m_WaitPlayerObjList) do
          if v ~= m_UserPlayerObj then
              this:getPlayerCtrl(v.name):SetWait(false)
              if not tableContains(m_PlayingPlayerObjList,v) then
                table.insert(m_PlayingPlayerObjList,v)
              end
          end
      end
      m_WaitPlayerObjList = {}
      if m_BtnBeginObj == nil then
          m_BtnBeginObj = this:getUserObj("Button_begin").gameObject
      end
      if m_IsLate == true then
          tSound = ResManager:LoadAsset('gamenn/Sound','GAME_END')
          EginTools.PlayEffect(tSound)
          m_IsLate = false
      else
        
          --m_BtnBeginObj.transform.localPosition = Vector3(300,-30,0)
      end
      if SettingInfo.Instance.autoNext == true then
          coroutine.wait(2)
          this:UserReady()
      else
         m_BtnBeginObj:SetActive(true)
      end
      local tTime = tBody['t']
      this:UpdateHUD(tTime)
      m_IsPlaying = false
end


function this:playsound()
	--ginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","nbet") )
    EginTools.PlayEffect(ResManager:LoadAsset("gamenn/Sound","Pool_Win") )
end

function this:ProcessUpdateAllIntomoney(pMessage )
      print('**********update all in money *********')
      local msgStr = cjson.encode(pMessage)
      if string.find(msgStr,tostring(EginUser.Instance.uid))== nil then
          return
      end
      local tInfos = pMessage['body']
      for k,v in pairs(tInfos) do
          local tUid = tostring(v[1])
          local tIntoMoney = tostring(v[2])
          local tPlayer = find(m_nnPlayerName..tUid)
          if tPlayer ~= nil then
            this:getPlayerCtrl(tPlayer.name):UpdateIntomoney(tIntoMoney)
          end
      end
end

function ProcessUpdateIntomoney(messageObj)
      print(cjson:encode(messageObj))
      if messageObj ~= nil then 
          local tIntoMoney = tostring(messageObj['body'])
          local tInfo = find('FootInfo')
          if tInfo ~= nil then
            -- local tFoot = tInfo.gameObject:GetComponent('FootInfo')
               FootInfo:UpdateIntomoney(tIntoMoney)
          end
      end
end

function this:ProcessCome( pMessage)
      print('********  process come **********')
      local tBody = pMessage['body']
      local tMemberInfo = tBody['memberinfo']
      local tPlayer =  this:AddPlayer(tMemberInfo,m_UserIndex)
      if m_IsPlaying == true then
          --tPlayer:GetComponent('KPNNPlayerCtrl'):SetWait(true)
          this:getPlayerCtrl(tPlayer.name):SetWait(true)
      end

end


function this:ProcessLeave(pMessage) 
      print('********   process leave  ********')
      local tUid = tostring(pMessage['body'])
      if tUid ~= tostring(EginUser.Instance.uid) then
          local tPlayer =  GameObject.Find(m_nnPlayerName..tUid)
          this:removePlayerCtrl(tPlayer.name)
          if tableContains(m_PlayingPlayerObjList,tPlayer) then
             tableRemove(m_PlayingPlayerObjList,tPlayer)
          end
          if tableContains(m_WaitPlayerObjList,tPlayer) then
              tableRemove(m_WaitPlayerObjList)
          end
          destroy(tPlayer)
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

function this:UserLeave(  )
      print('******User leave **********')
      local tUserleave = {}
      tUserleave['type']= 'game'
      tUserleave['tag'] = 'leave'
      tUserleave['body'] = EginUser.Instance.uid
      this.mono:SendPackage(cjson.encode(tUserleave))
end

function this:UserQuit( )
      print('**********   user quit  ***********')
      SocketConnectInfo.Instance.roomFixseat =true 
      local tUserQuit = {}
      tUserQuit['type'] = 'game'
      tUserQuit['tag'] = 'quit'
      this.mono:SendPackage(cjson.encode( tUserQuit))
      this.mono:OnClickBack()
end


function this:OnClickBack( )
      if  m_IsPlaying ==false then
          this:UserQuit()
      else
          if m_MsgQuitObj == nil then
              m_MsgQuitObj =   this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject
          end
          m_MsgQuitObj:SetActive(true)
      end
end


function this.ProcessNotcontinue( )
      if m_MsgNotContinueObj == nil then
          m_MsgNotContinueObj = this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject
           
      end
      m_MsgNotContinueObj:SetActive(true)
     
      coroutine.wait(3)
      this:UserQuit()
end

function this:ShowPromptHUD(pErrorInfo)
      if m_BtnBeginObj == nil then
           m_BtnBeginObj = this:getUserObj("Button_begin").gameObject
      end
      m_BtnBeginObj:SetActive(false)
      m_MsgAccountFailedObj:SetActive(true)
      m_MsgAccountFailedObj:GetComponentsInChildren(Type.GetType('UILabel',true)).text = pErrorInfo

end

-- function this:Back( )
--   this:OnClickBack()
-- end
-- function this:SocketReady()
--   this:SocketReady()
-- end

-- function this:SocketDisconnect(pDisconnect )
--   this:SocketDisconnect(pDisconnect)
-- end

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

function this:getUserObj( objName )
      local targetObj = this.transform:FindChild("Content/".. m_nnPlayerName .. EginUser.Instance.uid .."/"..objName)
      if(targetObj == nil)then
          targetObj = this.transform:FindChild("Content/User/".. objName)
      end
      return targetObj
end

function SocketReady( )
      this.mono:SocketReady()
end

function SocketDisconnect( pDisConnectInfo)
      this.mono:SocketDisconnect(pDisConnectInfo)
end

function this:OnDestroy()
      log("--------------------ondestroy of GameMXNNPanel")
      this:ClearLuaValue()
end
