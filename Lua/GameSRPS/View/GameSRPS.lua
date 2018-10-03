require "GameSRPS/SRPSPlayerCtrl"

local this = LuaObject:New()
GameSRPS = this

local m_Menu0 					--Menu
local m_Menu1					--Menu1
local m_Menu2					--Menu2
local m_BGVoice					--yuyingbg
local m_Sound
local m_LiShi
local m_Help
local m_Exit

local m_PlayersObj
local m_UserPlayerObj
local m_UserPlayerCtrl
local m_BtnBeginObj
local m_BtnCallBankersObj
local m_BtnShowObj
local m_MsgWaitNextObj
local m_MsgWaitBetObj
local m_ChooseChipObj
local m_MsgNotContinueObj
local m_MsgAccountFailedObj

local m_BMView
local m_BMFei
local m_BMStartTime
local m_BMPlayerNum
local m_BMMaxPlayer
local m_BMLeftTime
local m_BMRewardListObj
local m_BMPlayerTip
local m_RankParentObj
local m_BMMatchDetail   -- 赛制说明  底板 Obj
local m_BMAwardsObj  	--奖励说明 btn
--奖状界面
local m_InfoPanelView
local m_InfoSATxt


local m_PlayingPlayerObjList ={}
local m_WaitPlayerObjList ={}
local m_ReadyPlayerObjList = {}

local m_MultipleNum
local m_LastCardType = {}
local m_LastCard = {}
local m_nnPlayerName = 'NNPlayer_'
local m_BankerPlayerObj
local m_UserIndex =0
local m_IsPlaying = false 
local m_IsLate = false 
local m_IsReEnter = false
local m_BtnCom	--托管
local m_BtnZiDongMin
local m_BiaoQingParent

local m_Sex 
local m_MatchTime
local playerCtrlDc = {}
local m_ReadSt = 0;
local m_StartTimes = 0 
local m_LevelLab
local m_BGSource = nil 
local m_MinTime = 0
local m_BankId = 0;
local m_CardNumList = {}
local m_CardList = {}
local m_LastPlayer = {}
local m_EndCount = 0
local m_AddTimeLab
local m_AddTime = 10
local m_IsShowCard = false 
local m_ChouMaGroup = nil 
local m_ChouMaList = {}
local m_RankCell = {} 
local m_EndTime = 0
local m_MsgLab
local m_IsSetText = false 
local m_SoundIndex = -1
local m_LanguageEndTime = 0
local m_SendMsgList = {
	'莫偷鸡,偷鸡必被抓!',
	'别挣扎了,大奖非我莫属!',
	'我的宝剑已经饥渴难耐了!',
	'冷静!冲动是魔鬼!',
	'对子再手,天下无敌!',
	'这手牌打的不错,赢的漂亮!',
	'快点下注吧!爷时间宝贵!',
}
local m_SendMsgListOne = {
	'很高兴能和大家一起打牌',
	'赢钱了别走,留下你的姓名!',
	'难道你看穿我的底牌了吗?',
	'各位爷,让看看翻牌再加注吧!',
	'输惨了啦!',
	'似乎有埋伏,不可轻举妄动。',
	'你牌技这么好,地球人知道吗?',
	'想什么呢？快点！',
}
-- 0 男人  1 女人
local m_Sex =0
local m_IsGameOver = false
function this:ClearLuaValue( )
	print('Clear all ')
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
	m_WaitPlayerObjList = {}
	m_ReadyPlayerObjList = {}
	m_PlayingPlayerObjList = {}
	m_nnPlayerName = 'NNPlayer_'
	m_BankerPlayerObj = nil 
  	m_BGSource = nil 
  	m_UserIndex = 0
  	m_IsPlaying = false 
  	m_IsLate    = false 
 	m_IsReEnter = false 
 	m_CardNumList = {}
 	m_LastPlayer = {}
 	m_MatchTime = nil 	
 	m_ChouMaGroup = nil
 	m_ChouMaList = {}
 	m_RankCell = {} 
 	m_MinTime = 0
	 m_ReadSt = 0
	 m_EndTime =0 
	 m_StartTimes = 0 
	 m_LevelLab = nil 
	 m_BankId = 0
	 m_CardList = {}
	 m_EndCount = 0
	 m_AddTimeLab = nil 
	 m_AddTime = 10
	 m_IsShowCard = false 
	 m_MsgLab = nil 
	 m_IsSetText = false 
	 m_SoundIndex = -1
	 m_LanguageEndTime = 0
	for k,v in pairs(playerCtrlDc) do
	    v:OnDestroy()
	end
	playerCtrlDc = {}
	coroutine.Stop()
	LuaGC()
end


function this:bindPlayerCtrl(objName, gameObj)
  playerCtrlDc[objName] = SRPSPlayerCtrl:New(gameObj)
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
   m_BtnBeginObj = this.transform:FindChild("Content/User/Button_begin").gameObject
   this.mono:AddClick(m_BtnBeginObj,this.UserReady)
  local tBackBtn = this.transform:FindChild('Button_back').gameObject
   this.mono:AddClick(tBackBtn,this.OnClickBack)
  local tQuitMatch = this.transform:FindChild('Panel_baoming/BtnQuitMatch').gameObject
  this.mono:AddClick(tQuitMatch,this.OnClickBack)
  m_UserPlayerObj = this.transform:FindChild('Content/User').gameObject
  m_MsgWaitBetObj  = this.transform:FindChild('Content/MsgContainer/MsgWaitBet').gameObject
  m_MsgWaitNextObj = this.transform:FindChild('Content/MsgContainer/MsgWaitNext').gameObject
  m_BtnCallBankersObj = this.transform:FindChild('Content/User/BtnCallBanker').gameObject
  m_BtnCallBankersObj.transform.localPosition = m_BtnCallBankersObj.transform.localPosition + Vector3.up*45
  m_BtnShowObj = this.transform:FindChild('Content/User/Output/ShowCardtype').gameObject
  m_MsgAccountFailedObj = this.transform:FindChild('Content/MsgContainer/MsgAccountFailed')
   local tCallBankerBtn = this.transform:FindChild("Content/User/BtnCallBanker/Button1").gameObject
  this.mono:AddClick(tCallBankerBtn, 
    function ()
      this.mono:SendPackage( cjson.encode({type="sr5m", tag="re_banker", body=1}) )
      m_MsgWaitBetObj:SetActive(true)
      m_BtnCallBankersObj:SetActive(false)
    end
  )

  local giveupBtn = this.transform:FindChild("Content/User/BtnCallBanker/Button0").gameObject
  this.mono:AddClick(giveupBtn, 
    function ()
      this.mono:SendPackage( cjson.encode({type="sr5m", tag="re_banker", body=0}) )
      m_BtnCallBankersObj:SetActive(false)
    end)

  m_ChooseChipObj = this.transform:FindChild("Content/User/ChooseChips").gameObject         
  local btns = m_ChooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true))

  for i=0, btns.Length-1 do
    local btn = btns[i].gameObject
    if(string.find(btn.name, "Button") ~= nil)then
      this.mono:AddClick(btn, 
        function ()
          this:UserChip(btn)
        end
      )
    end
  end
  m_BMView = this.transform:FindChild('Panel_baoming').gameObject
  local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
  this.mono:AddClick(btn_MsgQuit, this.UserQuit)
  --菜单按钮 
  	m_InfoPanelView = this.transform:FindChild('jiangZhuang').gameObject
  	m_BMPlayerNum = this.transform:FindChild('Panel_baoming/ziti/bm_pnum').gameObject:GetComponent('UILabel')
  	m_BMFei =  this.transform:FindChild('Panel_baoming/ziti/bm_fei').gameObject:GetComponent('UILabel')
	m_BMStartTime =  this.transform:FindChild('Panel_baoming/ziti/bm_stime').gameObject:GetComponent('UILabel')
	m_BMMaxPlayer =this.transform:FindChild('Panel_baoming/ziti/bm_xian').gameObject:GetComponent('UILabel')
	m_BMLeftTime = this.transform:FindChild('Panel_baoming/ziti/bm_time').gameObject:GetComponent('UILabel')
	
	m_InfoSATxt = this.transform:FindChild('Panel_background/Sprite_menu3/BtnRank/Ranking_Lab'):GetComponent('UILabel')
  	m_BMPlayerTip = this.transform:FindChild('Panel_baoming/tishi').gameObject:GetComponent('UISprite')
  	m_LevelLab =this.transform:FindChild('Panel_background/Sprite_menu3/details/Lab/jishu_Lab').gameObject:GetComponent('UILabel')
  	--比赛时间 左上角
  	m_MatchTime = this.transform:FindChild('Panel_background/Sprite_menu3/bisaitime/bisaitime_lab').gameObject:GetComponent('UILabel')
	m_AddTimeLab = this.transform:FindChild('Panel_background/Sprite_menu3/details/Lab1/AddTime_LabR'):GetComponent('UILabel')
  	m_MessageError = this.transform:FindChild('Content/MsgContainer/MsgError').gameObject
  	this:InitMenuBtn()
end

function this:Awake()
	log("------------------awake of GameSRPSPanel")
	this:handleBtnsFunc()
    local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		
		sceneRoot.scalingStyle= UIRoot.Scaling.ConstrainedOnMobiles;
  		sceneRoot.manualHeight =  800;
        sceneRoot.manualWidth = 1422;
	end
	local footInfoPrb = ResManager:LoadAsset("gamesrps/srpsfootinfo","SRPSFootInfo")
	-- local settingPrb = ResManager:LoadAsset("gamenn/settingprb","SettingPrb")
	GameObject.Instantiate(footInfoPrb)
	-- GameObject.Instantiate(settingPrb)

 	if PlatformGameDefine.playform.IsPool then
  		local JiangChiPrb = ResManager:LoadAsset("gamenn/jiangchiprb","JiangChiPrb")
  		GameObject.Instantiate(JiangChiPrb)
 	end  
 	
 	
end

function this:Start()
	-- print('----------Start-------')
	if PlatformGameDefine.game.GameID == tostring(1065) then
		m_BMView:SetActive(true)
	end
	this.mono:StartGameSocket()
	 _isCallUpdate = true
  	coroutine.start(this.UpdateInLua)
  	if NNCount.Instance then
 		NNCount.Instance:DestroyHUD()
 	end
	
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
    coroutine.wait(0.5)
  end
end


function this:ProcessReadystart(pMessage)
	m_BMView:SetActive(false)
	local tBody = tonumber(pMessage['body'])
	m_ReadSt = tBody;
	EginProgressHUD.Instance:SrpsShowWaitHUD('还有'..tBody..'秒  半决赛开始')
end


function this:SocketReceiveMessage( message )
  local msgStr = self
  local cjson = require "cjson"

  local msgData = cjson.decode(msgStr)
  local type1 = msgData["type"]
  local tag   = msgData["tag"]
  -- print(tag)
  if type1 ==nil or tag ==nil then
  	return
  end
  if type1 == 'sr5m' then 
	-- print('@@@@@@@@@@@@@@@@@@@@   ' .. tag..'   @@@@@@@@@@@@@@@@')

  local tSR5M = {
	  ['apply'] = function (pMsg)
	  -- print('==== ' .. tag..'========  ')
	  	this:Apply(pMsg)
	  end,
	  ['newcn'] = function ( pMsg )
	  	this:ProcessNewcn(pMsg)
	  end,
	  ['matchcancel'] = function (pMsg)
	  	this:ProcessMatchCancel(pMsg)
	  end,
	  ['waitstart'] = function ( pMsg)
	  	this:ProcessWaitStart(pMsg)
	  end,
	  ['leave'] = function ( pMsg )
	  	this:ProcessLeave(pMsg)
	  end,
	  ['actfinish'] = function ( pMsg)
	  	this:ProcessLeave(pMsg)
	  end,
	  ['deskover'] = function (pMsg)
	  	this:ProcessDeskOver(pMsg)
	  end,
	  ['notcontinue'] = function ( pMsg )
	  	coroutine.start(this.ProcessNotcontinue)
	  end,
	  ['unitgrowtip'] = function (pMsg )
	  	this:ProcessUnitgrowtip(pMsg)
	  end,
	  ['cantrebuy'] = function ( pMsg)
	  	this:ProcessCantrebuy(pMsg)
	  end,
	  ['sendaward'] = function ( pMsg )
	  	this:ProcessSendaward(pMsg)
	  end,
	  ['recheckin'] = function ( pMsg )
	  	coroutine.start(this.ProcessRecheckin,pMsg)
	  end,
	  ['newranks'] = function ( pMsg )
	  	this:ProcessNewranks(pMsg)
	  end,
	  ['wantrebuy'] = function (pMsg )
	  	-- this:ProcessWantrebuy(pMsg)
        local body = pMsg["body"];
        NNCount.Instance:UpdateHUD(body["timeout"])
	  end,
	  ['time'] = function (pMsg)
	  	local t = tonumber(pMsg['body'])
	  	NNCount.Instance:UpdateHUD(t)
	  end,
	  ['late'] = function (pMsg )
	 	-- change  
	 	EginProgressHUD.Instance:SrpsShowWaitHUD1("正在登录房间...")
	  end,
	  ['ok'] = function (pMsg )
	  	this:ProcessOk(pMsg)
	  end,
	  ['ask_banker'] = function ( pMsg )
	  	this:ProcessAskbanker(pMsg)
	  end,
	  ['start_chip'] = function ( pMsg )
	  	this:ProcessStartchip(pMsg)
	  end,
	  ['chip'] = function (pMsg )
	  	this:ProcessChip(pMsg)
	  end,
	  ['deal'] = function ( pMsg )
	  	this:ProcessDeal(pMsg)
	  end,
	  ['end'] = function ( pMsg )
	  	coroutine.start(this.ProcessEnd,pMsg)
	  end,
	  ['max_time_tip'] = function ( pMsg )
	  	print('----------------max time tip ')
	  	print(cjson.encode(pMsg))
	  end,
	}

		if(tSR5M[tag]) then tSR5M[tag](msgData) end
	end


  if type1 == "game" then
    if  tag == "enter"  then
    	coroutine.start(this.ProcessEnter,msgData)
      -- this:ProcessEnter(msgData)
    elseif tag == "ready" then
      this:ProcessReady(msgData)
    elseif tag == "come"  then
      this:ProcessCome(msgData)
    elseif tag == "leave" or  tag == 'actfinish'  then
      this:ProcessLeave(msgData)
    

    elseif tag == "deskover"  then
      this:ProcessDeskOver(msgData)
    elseif tag == "notcontinue" then
      coroutine.start(this.ProcessNotcontinue)
    elseif tag == 'emotion' then
    	m_EndTime = Time.time 
    	local tBody = msgData['body']
    	local tId = tostring(tBody[1])
    	local tNum = tonumber(tBody[2])
    	local tPlayer = find(m_nnPlayerName..tId)
    	this:getPlayerCtrl(tPlayer.name):SetEmotion(tNum)
    elseif tag == 'hurry' then
    	m_LanguageEndTime = Time.time
    	local tBody = msgData['body']
    	local tSpokesman = tonumber(tBody['spokesman'])
    	local tIndex = tonumber(tBody['index'])
    	local tPlayer = find(m_nnPlayerName..tSpokesman).gameObject
    	local tSound = m_SendMsgList[tIndex+1]
    	if m_Sex == 1 then
    		tSound = m_SendMsgListOne[tIndex+1]
    	end

    	this:getPlayerCtrl(tPlayer.name):SetMessage(tIndex,tSound)
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
        end
      end
    end
    elseif tag == 'mypool' then
      if PlatformGameDefine.playform.IsPool then
        local chifen = msgData['body']
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

function this.ProcessEnter(pMessageObj )
	local tPlayerNum = 0
	m_StartTimes = m_StartTimes +1 
	m_BMView:SetActive (false)

	-- if SettingInfo.Instance.deposit == true  then
	-- 	print('in deposit   in  enter  ')
	-- 	m_BtnCom.gameObject:GetComponent('UISprite').spriteName = 'Trusteeship_no'
	-- 	SettingInfo.Instance.deposit = false
	-- end
	-- if SettingInfo.Instance.chipmin ==true then
	-- 	m_BtnZiDongMin.gameObject:GetComponent('UISprite').spriteName = 'xiazhumin_no'
	-- 	SettingInfo.Instance.chipmin = false
	-- end
	if SettingInfo.Instance.deposit == true  then
		m_BtnCom.gameObject:GetComponent('UISprite').spriteName = 'Trusteeship'
	end
	if SettingInfo.Instance.chipmin ==true then
		m_BtnZiDongMin.gameObject:GetComponent('UISprite').spriteName = 'xiazhumin'
	end
	
	this:ShowPlayerInfo()
	for k,v in pairs(m_LastPlayer) do 
		if v ~= nil then
			if v ~= tostring(EginUser.Instance.uid) then
				local tObj = find(m_nnPlayerName..v)
				destroy(tObj)
			end
		end
	end
	m_LastPlayer = {}
	
	local tBody = pMessageObj['body']
	local tMemberInfo = tBody['memberinfos']
	tPlayerNum =  #tMemberInfo
	local tDeskInfo = tBody['deskinfo']
	if m_StartTimes == 1 then
		m_MinTime = tonumber(tBody['left_time'])
		--启动左上角计时
		local m_LeftTime = 1
		local tMinTime = m_MinTime
		coroutine.start(function ()
			while (tonumber(m_MinTime)>0)
			do
				if m_MatchTime ~= nil then
					m_MinTime = m_MinTime-1;
					coroutine.wait(1)
					local t = EginTools.miao2TimeStr(tonumber(m_MinTime),false,false)
					if m_MatchTime ~= nil then
						m_MatchTime.text  =  t
					end
				end
			end

		end)
	end
	local tGameIn = '1'
	local tRank 
	
	for k,v in pairs( tMemberInfo) do
		if v ~= nil then 
			if tostring(v['uid']) == tostring(EginUser.Instance.uid) then
				m_UserIndex = tonumber(v['position'])
				local tIsWin = v['winning']
				tGameIn = tostring(v['playedrounds'])
				local tUserScoreLab = find('Label_Bagmoney'):GetComponent('UILabel')
				tUserScoreLab.text = EginTools.NumberAddComma(tostring(v['score']))
				if tIsWin == true then
					table.insert(m_WaitPlayerObjList,m_UserPlayerObj)
				else
					table.insert(m_PlayingPlayerObjList,m_UserPlayerObj)
					m_IsReEnter = true
				end
				tRank = tostring(v['rank'])
				m_UserPlayerObj.name =  m_nnPlayerName..tostring(EginUser.Instance.uid)
				
				break
			end
		end
	end





	this:bindPlayerCtrl(m_UserPlayerObj.name,m_UserPlayerObj)
	m_UserPlayerCtrl = this:getPlayerCtrl(m_UserPlayerObj.name)

	for k,v in pairs(tMemberInfo) do
		if v ~= nil then 
			if tostring(v['uid']) ~= tostring(EginUser.Instance.uid) then
				if m_PlayingPlayerObjList==nil  or #m_PlayingPlayerObjList == 0 then
					EginProgressHUD.Instance:SrpsShowWaitHUD('人数不足，取消比赛!')
				else

					this:AddPlayer(v,m_UserIndex)
					table.insert(m_LastPlayer,v['uid'])
				end
			else
				local tScore = tostring(v['score'])
				-- local tBagMoney = tostring(v['bag_money'])
				local tNickName = tostring(v['nickname'])
				local tAvatar_no = tonumber(v['avatar_no'])
				local tLevel = tostring(v['level'])
				m_UserPlayerCtrl:SetPlayerInfo(tAvatar_no,tNickName,tScore,tLevel)
				m_Sex = tAvatar_no%2
			end 
		end
	end
	if SettingInfo.Instance.deposit == true then
		this:UserReady()
		coroutine.wait(0.5)
	end

	--change
	local tMatchTimeLab = this.transform:FindChild('Panel_background/Sprite_menu3/jushu_Lab'):GetComponent('UILabel')
	tMatchTimeLab.text  = '第'..tGameIn .. '局'
	local tCountDown = tDeskInfo['countdown']
	local tTimeDown = tCountDown - 10
	m_BMPlayerNum.text = tDeskInfo['cn']
	m_InfoSATxt.text = tRank..'/'..tostring(tDeskInfo['cn'])
	m_MultipleNum = tostring(tDeskInfo['unit_money'])
	local tTop10 = tDeskInfo['top10']
	--change  排行榜
	local tRes = ResManager:LoadAsset('gamesrps/paimingchild','paimingchild')
	local tLen = 0
	for k,v in pairs(tTop10) do 
		tLen = tLen +1
	end

	for i =1, tLen do
		local tCell 
		local tNickN = tostring(tTop10[i][3]) 
		if string.len(tNickN) >7 then
			tNickN = string.sub(tNickN,0,7)
		end
		local tScore = tostring(tTop10[i][1])
		if i<= #m_RankCell then
			tCell = m_RankCell[i]
		else
			tCell = GameObject.Instantiate(tRes)
			tCell.transform.parent = m_BMAwardsObj.transform:FindChild('paiming/paiming/UIGrid')
			tCell.transform.localPosition =Vector3.New(0,0-(i-1)*45,0);
			tCell.transform.localScale = Vector3.one
			m_RankCell[i] = tCell
		end

		tCell.transform:FindChild('mingci'):GetComponent('UILabel').text = "第"..(i + 1) .. "名"
		tCell.transform:FindChild('nickname'):GetComponent('UILabel').text = tNickN
		tCell.transform:FindChild('jifen'):GetComponent('UILabel').text = tScore
	end


	if SettingInfo.Instance.deposit == false then
		if m_BtnBeginObj == nil then 
			m_BtnBeginObj = m_UserPlayerObj.transform:FindChild('Button_begin').gameObject
		end

		m_BtnBeginObj:SetActive(true)
		coroutine.wait(5)
		if m_BtnBeginObj ~= nil then
			if m_BtnBeginObj.activeSelf ==true  then
				this:UserReady()
			end
		end
	end
end
-- 忽略一个 playerTimedown方法 还有 hidNNCount 方法


function this:AddPlayer(pMemberInfo,pUserIndex)
	local tCtrl
	for k,v in pairs(m_PlayingPlayerObjList) do
		if IsNil(v) == false then 
			if v ~= nil and v == m_UserPlayerObj then
				tCtrl = this:getPlayerCtrl(v.name)
				tCtrl:SetDeal(false,nil)
				tCtrl:CardPlayAnimation(nil,11)
				tCtrl:SetScore(-1)
			end
		end
	end
	local tUid = tostring(pMemberInfo['uid'])
	local tScore = tostring(pMemberInfo['score'])
	local tBagMoney = tostring(pMemberInfo['bag_money'])
	local tNickName = tostring(pMemberInfo['nickname'])
	local tAvatar_no = tonumber(pMemberInfo['avatar_no'])
	local tLevel = tostring(pMemberInfo['level'])
	local tPos = tonumber(pMemberInfo['position'])
	local tIsReady = pMemberInfo['is_staff'] 
	local tIsWining = pMemberInfo['winning']  

	local contentObj = this.transform:FindChild("Content").gameObject
  	local playerPrb = ResManager:LoadAsset("gamesrps/srpsplayer","SRPSPlayer")
 	local tPlayer = NGUITools.AddChild(contentObj,playerPrb)
 	tPlayer.name = m_nnPlayerName..tUid
 	this:SetAnchorPosition(tPlayer,pUserIndex,tPos)
 	this:bindPlayerCtrl(tPlayer.name,tPlayer)
	tCtrl = this:getPlayerCtrl(tPlayer.name)
	tCtrl:SetPlayerInfo(tAvatar_no,tNickName,tScore,tLevel)
	if tIsWining == true then
		if tIsReady == true then
			tCtrl:SetReady(true)
			table.insert(m_ReadyPlayerObjList,tPlayer)
		end
		table.insert(m_WaitPlayerObjList,tPlayer)
	else
		table.insert(m_PlayingPlayerObjList,tPlayer)
	end

end
	--change 
	-- local tPlayer  = GameObject.Find("Panel_info/Foot - Anchor/Info/Sprite_Avatar"):GetComponent('UISprite').spriteName;
	-- local tAId = string.sub(tPlayer,7)
	-- print('ID-------------' .. tAId)
	-- return tPlayer



function this:SetAnchorPosition(pPlayer,pUserIndex,pPlayerIndex)
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
    tAnchor.relativeOffset = Vector2.New(-0.06,0.075)
  elseif tPos_Span ==2 or tPos_Span == -2 then
    tAnchor.side = UIAnchor.Side.Top
    tAnchor.relativeOffset = Vector2.New(-0.14,-0.11)
  elseif tPos_Span ==3 or tPos_Span == -1 then
      tAnchor.side = UIAnchor.Side.Left
      tAnchor.relativeOffset = Vector2.New(0.06,0.075)
  end
end

function this:ProcessReady (pMessageObj)
	-- print(cjson.encode(pMessageObj))
	local tUid = tostring(pMessageObj['body'])
	local tPlayer = find(m_nnPlayerName..tUid)
	local tCtrl = this:getPlayerCtrl(tPlayer.name)
	tCtrl:SetPaiAvailable()
	if tUid == tostring(EginUser.Instance.uid) then
		tCtrl:SetDeal(false,nil)
		tCtrl:CardPlayAnimation(nil,11)
		tCtrl:SetScore(-1)
	else
		tCtrl:SetReady(true)
		if m_BtnBeginObj.activeSelf == false then
			tCtrl:SetDeal(false,nil)
			tCtrl:SetCardTypeOther(nil,11)
			tCtrl:SetScore(-1)
		end
	end
	if tableContains(m_PlayingPlayerObjList,tPlayer)==false then
		table.insert(m_PlayingPlayerObjList,tPlayer)
	end
end

function this:UserReady()
	print('UserReady')
	NNCount.Instance:DestroyHUD()
	if m_BankerPlayerObj ~= nil and IsNil(m_BankerPlayerObj) == false then
		this:getPlayerCtrl( m_BankerPlayerObj.name):SetBanker(false)
	end
	local tStartJson={}
	tStartJson['type'] = 'sr5m'
	tStartJson['tag'] = 'start'
	this.mono:SendPackage(cjson.encode(tStartJson) )
	m_BtnBeginObj:SetActive(false)
	
	if m_UserPlayerObj == nil or m_UserPlayerCtrl ==nil  then
		m_UserPlayerObj = find(m_nnPlayerName..EginUser.Instance.uid)
		m_UserPlayerCtrl = this:getPlayerCtrl(m_UserPlayerObj.name)
	end


	m_UserPlayerCtrl:SetReady(true)
	--change 
	coroutine.start(function ( )
		coroutine.wait(2)
		EginProgressHUD.Instance:SrpsShowWaitHUD1("请等待玩家叫庄中.....")
	end)
	local tClip = ResManager:LoadAsset('gamenn/Sound','GAME_START');
  	EginTools.PlayEffect(tClip);
end

function this:ProcessAskbanker(pMessageObj )
	for k,v in pairs(m_ReadyPlayerObjList) do
		if IsNil(v) == false then
			if tableContains(m_PlayingPlayerObjList,v) == false and tableContains( m_WaitPlayerObjList,v) ==false then
				table.insert(m_PlayingPlayerObjList,v)
			end
		end
	end

	m_IsPlaying = true
	for k,v in pairs(m_PlayingPlayerObjList ) do
		if IsNil(v) == false then
			if v ~= nil then 
				local tCtrl = this:getPlayerCtrl(v.name)
				tCtrl:SetDeal(false,nil)
				tCtrl:SetScore(-1)
				tCtrl:SetCallBanker(false)
				tCtrl:SetPaiAvailable()
				if v ~= m_UserPlayerObj then
					tCtrl:SetCardTypeOther(nil,11)
				else
					tCtrl:CardPlayAnimation(nil,11)
				end
				
				tCtrl:SetReady(false)
			end
		end
	end

	local tBody = pMessageObj['body']
	local tUid = tostring(tBody['uid'])
	if tUid == tostring(EginUser.Instance.uid) then
		EginProgressHUD.Instance:SrpsShowWaitHUD1('开始叫庄中....')
		m_BtnCallBankersObj:SetActive(true)
		if m_BtnBeginObj.activeSelf == true then
			m_BtnBeginObj:SetActive(false)
		end
		if SettingInfo.Instance.deposit == true then
			local tBtn = m_BtnCallBankersObj.transform:FindChild('Button1').gameObject
			local tMsg = {}
			tMsg['type'] = 'sr5m'
			tMsg['tag'] = 're_banker'
			if tBtn == 'Button1' then
				tMsg['body'] = 1

				m_MsgWaitBetObj:SetActive(true)
				m_UserPlayerCtrl:SetReady(false)
			else
				tMsg['body'] = 0
				EginProgressHUD.Instance:SrpsShowWaitHUD1('等待玩家叫庄中....')
			end

			this.mono:SendPackage(cjson.encode(tMsg))
			m_BtnCallBankersObj:SetActive(true)
			NNCount.Instance:DestroyHUD()
		end
	end
	NNCount.Instance:UpdateHUD(tBody['timeout']);
end
--change    省略 UserCallBanker  和 UserBanker
function this:ProcessStartchip(pMessageObj)
	EginProgressHUD.Instance:SrpsShowWaitHUD1('开始下注...')
	if m_BtnCallBankersObj.activeSelf ==true  then m_BtnCallBankersObj:SetActive(false) end
	local tBody = pMessageObj['body']
	local tBid = tostring(tBody['bid'])
	m_BankId = tonumber(tBid)
	m_BankerPlayerObj = find(m_nnPlayerName..tBid)
	local tCtrl  = this:getPlayerCtrl( m_BankerPlayerObj.name)
	tCtrl:SetCallBanker(false)
	if m_BankerPlayerObj ~= nil then
		local tBankerAni = ResManager:LoadAsset('gamesrps/zhuangsprite','zhuangsprite')  --  this.transform:FindChild('Content/zhuangAniUp')
		tBankerAni =GameObject.Instantiate(tBankerAni)
		tBankerAni.transform.parent = this.transform:FindChild('Content/zhuangps')
		tBankerAni.transform.localPosition = Vector3.zero
		tBankerAni.transform.localScale = Vector3.one
		-- tBankerAni.gameObject:SetActive(true)
		-- tBankerAni:GetComponent('UISpriteAnimation'):Play()
		local tClip = ResManager:LoadAsset('gamenn/Sound','zhuangfen')
		local tAni = tBankerAni:GetComponent('UISpriteAnimation')
		  --this.transform:FindChild('Content/zhuangAniDown')

		local tEmpObj = nil 
		local tEmpO = nil 
		if tBid == tostring(EginUser.Instance.uid) then
			tempObj = find('Panel_info/Foot - Anchor/Info/Sprite_bankertarget').gameObject
			tEmpO = find('Panel_info/Foot - Anchor/Info/Sprite_Avatar').gameObject
		else
			tempObj = find("NNPlayer_" ..tBid .. "/PlayerInfo/Panel_Head/Sprite_bankertarget").gameObject;
			tEmpO = find("NNPlayer_" .. tBid .. "/PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject;
		end
		coroutine.start(function ()
			coroutine.wait(1)
			while(true)
			do
				
				if tAni.isPlaying ==false then
					iTween.MoveTo(tBankerAni.gameObject,iTween.Hash('position',tempObj.transform.position,'easytype',iTween.EaseType.linear,'time',1))
					iTween.ScaleTo(tBankerAni.gameObject,iTween.Hash('scale',Vector3.New(0.3,0.3,1),'time',1,'easetype',iTween.EaseType.linear))
					coroutine.start(function ()
						coroutine.wait(1)
						-- tBankerAni.parent = this.transform:FindChild('Content')
						-- tBankerAni.gameObject:SetActive(false)
						-- tBankerAni.localPosition = Vector3.zero
						-- tBankerAni.localScale = Vector3.one
						-- tAni.Play() 
						if tBankerAni ~= nil and IsNil(tBankerAni)==false then
							destroy(tBankerAni)
						end
						local tBankerAniD = ResManager:LoadAsset('gamesrps/zhuangeffects','zhuangeffects')
						tBankerAniD = GameObject.Instantiate(tBankerAniD)
						if m_BankerPlayerObj.name == m_UserPlayerObj.name then
							tBankerAniD.transform.parent = m_UserPlayerObj.transform:FindChild('UserChiptransform')
						else
							tBankerAniD.transform.parent = m_BankerPlayerObj.transform:FindChild('PlayerInfo/Panel_Head/Sprite (avatar_6)')
						end
						
						tBankerAniD.transform.localPosition = Vector3.New(-4,-10,0)
						tBankerAniD.transform.localScale = Vector3.one
						coroutine.wait(0.5)
						if IsNil(m_BankerPlayerObj) == false then 
							this:getPlayerCtrl(m_BankerPlayerObj.name):SetBanker(true)
						end	
						coroutine.wait(1)
						if tBankerAniD ~= nil and IsNil(tBankerAniD)==false then
							destroy(tBankerAniD)
						end
					end)
					break
				else
					coroutine.wait(0.5)
				end


			end 
		end)
	end
	if m_IsLate ==false and m_BankerPlayerObj ~= m_UserPlayerObj then
		local tChip = tBody['chip']
		m_ChooseChipObj:SetActive(true)
		
		if m_BtnCallBankersObj.activeSelf then
			m_BtnBeginObj:SetActive(false)
		end
		local tBtns = m_ChooseChipObj:GetComponentsInChildren(Type.GetType('UIButton',true))  
	    for i=0,#tChip-1 do
		    local tBtn = tBtns[i].gameObject
		    tBtn.transform.localPosition = Vector3(-415+157*i,100,0)   
		    m_UserPlayerCtrl:SetStartChip(tBtn,tonumber(tChip[i+1]))
		    tBtn.name = tostring(tChip[i+1]..'')
	    end
	    if SettingInfo.Instance.chipmin == true then
	    	this:UserChip(tBtns[#tChip-1])
	    end
	end
	NNCount.Instance:UpdateHUD(tBody['timeout']);
end
--change 省略一个AnimationOver 动画方法 省略 yanchizhuangsound


function this:ProcessChip(pMessageObj )
	local tInfos = pMessageObj['body']
	local tUid = tostring(tInfos[1])
	local tChips = tonumber(tInfos[2])
	local tPlayer = find(m_nnPlayerName..tUid)

	local tCtrl = this:getPlayerCtrl(tPlayer.name)
	tCtrl:SetBet(tChips)
	tCtrl:SetChip(true)
	if m_BtnCallBankersObj.activeSelf then
	 	m_BtnBeginObj:SetActive(false)
	end
	-- print('ProcessChip  ')
	tCtrl:SetReady(false)
	if tPlayer == m_UserPlayerObj then
		m_ChooseChipObj:SetActive(false)
		NNCount.Instance:DestroyHUD()
	end
	local tClip = ResManager:LoadAsset('gamenn/Sound','xiazhu')
	EginTools.PlayEffect(tClip)
end

function this:UserChip(pObj)
	local tChip = pObj.name
	local tChipIn = {}
	tChipIn['type'] = 'sr5m'
	tChipIn['tag'] = 'chip_in'
	tChipIn['body'] = tChip
	this.mono:SendPackage(cjson.encode(tChipIn))
	m_UserPlayerCtrl:SetUserChipShow(true)
	m_UserPlayerCtrl:SetReady(false)
end

function this:ProcessDeal( pMessageObj )
	if m_MsgWaitBetObj.activeSelf then
		m_MsgWaitBetObj:SetActive(false)
	end
	local tBody = pMessageObj['body']
	local tCards = tBody['cards']
	-- print(  'ProcessDeal  ============ '  )
	-- print( cjson.encode(pMessageObj))
	m_CardList = tCards
	for k,v in pairs(m_PlayingPlayerObjList ) do

		if IsNil(v) ==false then
			if v == m_UserPlayerObj then
				m_UserPlayerCtrl:UserSetDeal(true,tCards,0.2,0.2)
			else
				if v ~= nil then
					local tCtrl = this:getPlayerCtrl(v.name)
					tCtrl:SetDeal(true,nil)
				end

			end
		end
	end

	if not m_IsLate then
		coroutine.start(function ( )
			coroutine.wait(2.9)
			if IsNil(m_BtnShowObj) == false then
				m_BtnShowObj:SetActive(true)
			end
			if SettingInfo.Instance.deposit == true then
				this:SumNumBtn()
			end
		end)
	end
	NNCount.Instance:UpdateHUD(tBody['t']);
end
--change 省略一个 SetCardNum 最下面

function this:ProcessOk(pMessageObj )
	print('ProcessOk')
	local tBody = pMessageObj['body']
	local tUid = tostring(tBody['uid'])
	if tUid ~= tostring(EginUser.Instance.uid) then
		local tPlayer = find(m_nnPlayerName..tUid)
		if tPlayer ~= nil then
			this:getPlayerCtrl(tPlayer.name):SetShow(true)
			local tClip = ResManager:LoadAsset('gamenn/Sound','zhunbei')
			EginTools.PlayEffect(tClip)
		end
	else
		if m_IsShowCard == false then
			local tCards = tBody['cards']
			local tCardType = tBody['type']
			m_CardList = tCards
			--change istanpai 省略
			m_IsShowCard = true
			m_UserPlayerCtrl:CardPlayAnimation(tCards,tCardType)
			m_UserPlayerCtrl:SetPaiunavailable()
			m_CardNumList={}
			for i=1 ,3 do 
				local tLab = m_BtnShowObj.transform:FindChild('UILab_'..tostring(i)):GetComponent('UILabel')
				tLab.text = ''
			end
			m_BtnShowObj.transform:FindChild('UILabSum'):GetComponent('UILabel').text  = '0'
			NNCount.Instance:DestroyHUD()
		end
	end
end
--change 省略  UserShowniu0
function this:UserShow( )
	local tSendMsg = {}
	tSendMsg['type'] = 'sr5m'
	tSendMsg['tag'] = 'ok'
	tSendMsg['body'] = 1 
	this.mono:SendPackage(cjson.encode(tSendMsg))
	m_CardNumList = {}
	for k,v in pairs(m_PlayingPlayerObjList) do
		if IsNil(v) == false then
			local tCtrl = this:getPlayerCtrl(v.name)
			if tCtrl ~= nil then
				if v ~= m_UserPlayerObj then
					tCtrl:SetShow(false)
					tCtrl:SetUserChipShow(false)
					tCtrl:SetCardClosing(false)

				end
			end
		end
	end
	m_BtnShowObj:SetActive(false)
end
function this.ProcessEnd(pMessageObj )
	--change  is up 
	print('=================ProcessEnd ')
	for i=1 ,3 do 
		local tLab = m_BtnShowObj.transform:FindChild('UILab_'..tostring(i)):GetComponent('UILabel')
		tLab.text = ''
	end
	m_BtnShowObj.transform:FindChild('UILabSum'):GetComponent('UILabel').text  = '0'
	coroutine.wait(0.1)
	m_UserPlayerCtrl:SetUserChipShow(false)

	m_BtnShowObj:SetActive(false)
	local tBody = pMessageObj['body']
	local tInfos = tBody['infos']
	local tOuts = tBody['outs']
	for k,v in pairs(m_PlayingPlayerObjList) do 
		if IsNil(v)==false then
			this:getPlayerCtrl(v.name):SetBet(0)
			if v ~= m_UserPlayerObj then
				
				this:getPlayerCtrl(v.name):SetShow(false)
			end
		end
	end 
	local tWinPos ={}	--endpos
	local tWinUid = {}
	local tWinCount = 0
	local tBg = this.transform:FindChild('Panel_background/Sprite_Texture').gameObject
	if tInfos ~= nil and tInfos ~= {} then
		for k,v in pairs(tInfos) do 
			local tScore = v[4]
			local tUid = tostring(v[1])
			local tPlayer = find(m_nnPlayerName..tUid)
			local tAnc = tostring(tPlayer:GetComponent('UIAnchor').side);
			if tScore>0 then
				tWinCount= tWinCount+1
				table.insert(tWinUid,tUid)
				local tEndPos = nil 
				if tostring(tUid) == tostring(EginUser.Instance.uid) then 
					-- tEndPos = tPlayer.transform:FindChild('UserChiptransform').localPosition
					tEndPos =tBg.transform:FindChild(tAnc).localPosition + Vector3.New(0,-35,0)
				else
					tEndPos =tBg.transform:FindChild(tAnc).localPosition 
				end
				if tEndPos ~= nil then 
					table.insert(tWinPos, tEndPos)
				end
			end
		end
	end
	if m_MsgWaitNextObj.activeSelf then m_MsgWaitNextObj:SetActive(false) end
	--change 排序  
	-- print('------tinfos --------')
	-- print(cjson.encode(tInfos))
	if tInfos ~= nil then
		for k,v in pairs(tInfos) do 
			if v~= nil  then
				local tUid = tostring(v[1])
				local tPlayer = find(m_nnPlayerName..tUid)
				local tCtrl = this:getPlayerCtrl(tPlayer.name)
				local tScore =tonumber(v[4])
				local tCardType = tonumber(v[3])
				local tUserCard = v[2]
				if IsNil(tPlayer) == false then
					if tUid == tostring(EginUser.Instance.uid) then
						if m_IsShowCard == false then
							tCtrl:CardPlayAnimation(tUserCard,tCardType)
							m_IsShowCard =true
						end
							
						local tMultiple = tScore/m_MultipleNum
						if tMultiple >5 then
							tMultiple = 5
						elseif tMultiple <-5 then
							tMultiple = -5
						end
						--m_LastCardType -- 历史牌型
						local tCardTypeL ={}
						table.insert(tCardTypeL,tostring(tCardType))
						table.insert(tCardTypeL,tScore)
						table.insert(tCardTypeL,tostring(tMultiple))
						table.insert(m_LastCardType,tCardTypeL)
						print('---------------------card ----------------')
						print(tUserCard)
						--local tUserCard = {0-(m_EndCount-1)*3,1-(m_EndCount-1)*3,2-(m_EndCount-1)*3 }
						m_EndCount = m_EndCount+1
						tCtrl:SetUserCards(m_EndCount,tUserCard,m_LastCardType[m_EndCount][1],m_LastCardType[m_EndCount][2],m_LastCardType[m_EndCount][3])
						--change  增加历史记录 
						tCtrl:SetPaiunavailable()
						m_CardNumList = {}
						m_CardList = {}
						
					end
					coroutine.wait(1.5)
					if tUid ~= tostring(EginUser.Instance.uid) then
						tCtrl:SetCardTypeOther(tUserCard,tCardType)
					else 
						if m_BtnShowObj.activeSelf then
							m_BtnShowObj:SetActive(false)
							m_UserPlayerCtrl:SetUserChipShow(false)
							-- tCtrl:CardPlayAnimation(tUserCard,tCardType)
						end
					end
				end
				
			end
		end
	end
	-- coroutine.wait(1)
	local tList = {}
	if tInfos ~= nil then
		local tTarget = m_ChouMaGroup.parent:FindChild('target').gameObject
		m_ChouMaGroup.gameObject:SetActive(true)
		local tIndex = 0
		for k,v in pairs(tInfos) do
			local tUid = tostring(v[1])
			local tPlayer = find(m_nnPlayerName..tUid)
			local tCtrl = this:getPlayerCtrl(tPlayer.name)
			local tScore = tonumber(v[4])
			tCtrl:SetScore(tScore)
			local tSideposition = tostring(tPlayer:GetComponent('UIAnchor').side);
			if tScore < 0 and tCtrl ~=nil then
				-- tCtrl:ChoumaPosition(false,true)
				tIndex = (tIndex + 1)


				for j=1,6 do 
					local tPos =m_ChouMaGroup.parent:FindChild(tSideposition..'1')  --tPlayer.transform:FindChild('Output/Cards') 
					local tX = math.random(-30,30)
					local tY = math.random(-30,30)
					local tCount = math.random(2,6)
					m_ChouMaList[tIndex][j]:GetComponent('UISprite').spriteName = 'Chip'..tostring(tCount)
					m_ChouMaList[tIndex][j].transform.parent = m_ChouMaGroup.parent
					local tL = Vector3.New(tPos.localPosition.x +tX,tPos.localPosition.y +tY,0)
					m_ChouMaList[tIndex][j].transform.localPosition =  tL

					local tTar = Vector3.New(tTarget.transform.localPosition.x+tX,tTarget.transform.localPosition.y+tY,0)
					m_ChouMaList[tIndex][j].gameObject:SetActive(true)
					iTween.MoveTo(m_ChouMaList[tIndex][j].gameObject,iTween.Hash('position',tTar,'time',0.2,'islocal',true))
					table.insert(tList,m_ChouMaList[tIndex][j])
					coroutine.wait(0.1)
				end
			end
		end
	end
	coroutine.wait(1)
	for i=1,#tList do
		local tI = i % tWinCount + 1 
		if tI > tWinCount then
			tI = tWinCount
		end
		iTween.MoveTo(tList[i].gameObject,iTween.Hash('position',tWinPos[tI],'time',0.15,'islocal',true))
		coroutine.wait(0.1)
	end
	coroutine.wait(0.8)
	for i=1,#tList do
		tList[i].gameObject:SetActive(false)
		tList[i].transform.parent = m_ChouMaGroup
		tList[i].transform.localPosition = Vector3.zero
	end
	m_ChouMaGroup.gameObject:SetActive(false)


	for k,v in pairs(tOuts) do 
		local tP = find(m_nnPlayerName..v)
		if IsNil(tP)== false and tP ~= nil then
			this:getPlayerCtrl(tP.name):SetEliminatePlayerUser(tOuts,v,tP)
		end
	end
	-- if tWinCount == 1 then
		for k,v in pairs(tWinUid) do 
			if tonumber(v) == m_BankId then

				local tClip = ResManager:LoadAsset('gamenn/Sound','zhuangtongchi')
				if tClip ~= nil then
					EginTools.PlayEffect(tClip)
				end
				local tA = ResManager:LoadAsset('gamenn/Sound','zhuangtongchi')
				if tA ~= nil then
					EginTools.PlayEffect(tClip)
				end
			end
		end

	coroutine.wait(1.9)
	local tClip = ResManager:LoadAsset('gamenn/Sound','choumafei')
	if tClip ~= nil then
		EginTools.PlayEffect(tClip)
	end

	for k,v in pairs(m_WaitPlayerObjList) do
		if IsNil(v) == false then 
			if v ~= m_UserPlayerObj then
				this:getPlayerCtrl(v.name):SetWait(false)
				if tableContains(m_PlayingPlayerObjList,v) == false then
					table.insert(m_PlayingPlayerObjList,v)
				end
			end
		end 
	end
	m_WaitPlayerObjList = {}

	if m_IsLate == true then
	    local tSound = ResManager:LoadAsset('gamenn/Sound','GAME_END')
	    EginTools.PlayEffect(tSound)
	    m_IsLate = false
	else
	    m_BtnBeginObj.transform.localPosition = Vector3(442,50,0)
	end
	NNCount.Instance:UpdateHUD(tonumber(tBody['t']))
	m_IsPlaying =false
	m_IsShowCard = false
	coroutine.wait(0.5)
	EginProgressHUD.Instance:SrpsShowWaitHUD1('等待下一局....')
	-- m_PlayingPlayerObjList = {}
end
--change  省略choumaDestroy   playsound  AfterDoing  OpenPai

function this:ProcessDeskOver( pMessageObj)
	print('over')
end

function this:ProcessUpdateAllIntomoney(pMessageObj )
	 local msgStr = cjson.encode(pMessageObj)
  if string.find(msgStr,tostring(EginUser.Instance.uid))== nil then
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
  -- print(cjson:encode(pMessageObj))
  if pMessageObj ~= nil then 
    local tIntoMoney = tostring(pMessageObj['body'])
    local tInfo = find('FootInfo')
    if tInfo ~= nil then
      -- local tFoot = tInfo.gameObject:GetComponent('FootInfo')
      FootInfo:UpdateIntomoney(tIntoMoney)
    end
  end
end

function this:ProcessCome(pMessageObj )
	local tBody = pMessageObj['body']
	local tMemberInfo = tBody['memberinfo']
	local tPlayer = this:AddPlayer(tMemberInfo,m_UserIndex)
	if m_IsPlaying ==true then
		this:getPlayerCtrl(tPlayer.name):SetWait(true)
	end
end

function this:ProcessLeave( pMessageObj )
	local tUid = tostring(pMessageObj['body'])
	if tUid ~= tostring(EginUser.Instance.uid) then
		local tPlayer = find(m_nnPlayerName..tUid)
		if tableContains(m_PlayingPlayerObjList,tPlayer) then
			tableRemove(m_PlayingPlayerObjList,tPlayer)
		end
		if tableContains( m_WaitPlayerObjList ,tPlayer) then
			tableRemove(m_WaitPlayerObjList,tPlayer)
		end
		destroy(tPlayer)	
	end
end

function this:UserQuit( )
	-- print('quit============')
	 SocketConnectInfo.Instance.roomFixseat = true;
	 local tUserQuit = {}
	 tUserQuit['type'] = 'game'
	 tUserQuit['tag'] = 'quit'
	 this.mono:SendPackage(cjson.encode(tUserQuit))
	 this.mono:OnClickBack()
end

--change 省略userbaoming BaoMingRoom
function this:ProcessNotcontinue()
	m_MsgNotContinueObj:SetActive(true)
	coroutine.wait(3)
	this:UserQuit()
end
function this:OnClickBack( )
	-- print('back============')
	SocketConnectInfo.Instance.roomFixseat = true;
	 local tUserQuit = {}
	 tUserQuit['type'] = 'game'
	 tUserQuit['tag'] = 'quit'
	 this.mono:SendPackage(cjson.encode(tUserQuit))
	 this.mono:OnClickBack()
 
end
--change 
--[[ShowPromptHUD Back SocketReady SocketDisconnect LeaveWindow
SendPackage  DetailsMenu OwnMenu Ownzhuang OpenMenu Chat Yuyin
PlayerDetails jinfen PlayerAward Lis
hiWindow SoundWindow HelpWindow ExitWindow CloseWindow
showJiangList showshaizhiList Closeshowbaoming
]]
local m_IsApply = false 
function this:Apply( pMessageObj )
	m_StartTimes = 0
	m_EndCount = 0
	m_AddTime = 10
	m_IsApply = true
	m_IsGameOver = false 
	local tClip = ResManager:LoadAsset('gamenn/Sound','matchbg')
	EginTools.PlayEffect(tClip)
	local tBody = pMessageObj['body']
	local tInitJin = tBody['init_money']
	m_MinTime = tonumber(tBody['unitgrow_dt'])
	local zJin = tBody['increment']
	m_InfoPanelView:SetActive(false)
	
	m_BMView:SetActive(true)
	m_BMPlayerTip.gameObject:SetActive(true)
	local tMinTimeShow =string.sub(EginTools.miao2TimeStr(tonumber(m_MinTime),false,false),0,1)

	local tLab = m_BMMatchDetail.transform:FindChild('saizhiExplain').gameObject:GetComponent('UILabel')
  	tLab.text = "[7b551e]分组打立出局,初始化积分" .. tInitJin .. ",每" .. tMinTimeShow .. "分钟积分增加" .. zJin .. ",积分低于当前基数即被打立,每组根据排名可获得丰富的奖励。";

  
	local tDesp = m_Help.transform:FindChild('View/award').gameObject
	local awardlab = tDesp.transform:FindChild("awardLab"):GetComponent('UILabel')
    if tostring(SocketConnectInfo.Instance.roomMinMoney) == "0" then
        awardlab.text = "分组打立出局,初始化积分[ff0101]" .. tInitJin .. "[-],每[ff0101]" .. tMinTimeShow .. "[-]分钟积分增加[ff0101]" .. zJin .. "[-],积分低于当前基数即被打立,每组[ff0101]前五名[-]可获得丰富的奖励。"
    else
    
        awardlab.text = "分组打立出局,初始化积分[ff0101]" .. tInitJin .. "[-],每[ff0101]" ..tMinTimeShow .. "[-]分钟积分增加[ff0101]" ..zJin .. "[-],积分低于当前基数即被打立,每组[ff0101]前七名[-]可获得丰富的奖励。"
    end
	local tMenPiao = tonumber(tBody['ticketnum'])
	if tMenPiao >0 then
		EginProgressHUD.Instance:SrpsShowWaitHUD("你现在有" .. tMenPiao .. "张快乐卡,开赛将扣除一张快乐卡！")
	else
		EginProgressHUD.Instance:SrpsShowTishi()
		Utils.LoadLevelGUI('Hall')
	end
	--change 
	local m_LeftTime = tonumber(tBody['restseconds'])
	local tMinTime = m_MinTime
	coroutine.start(function ()
		while (m_LeftTime>0)
		do
			m_LeftTime = m_LeftTime-1;
			coroutine.wait(1)
			m_BMLeftTime.text  = m_LeftTime..' 秒'
			-- 基数增加时间	
		end
		while (tonumber(tMinTime)>0)
		do
			tMinTime = tMinTime-1
			if tMinTime <= 9 and tMinTime >=0 then
				m_AddTimeLab.text  = '0'..tostring(tMinTime)
			else

				m_AddTimeLab.text  = tostring(tMinTime%60)
			end
			if tMinTime == m_AddTime then
				if m_IsGameOver == false then
				tInitJin  = tInitJin + zJin
				EginProgressHUD.Instance.SrpsGametishi2:SetActive(true);
				EginProgressHUD.Instance:SrpsShowWaitHUD2(m_AddTime .. "秒钟后基数将增长翻倍至" .. tInitJin);
				end
			end
			if tMinTime >10 then
				if m_IsGameOver == false then
					if EginProgressHUD.Instance.SrpsGametishi2.activeSelf then
						EginProgressHUD.Instance.SrpsGametishi2:SetActive(false)
					end
				end
			end
			if tMinTime ==0 then
				m_LevelLab.text = tostring(tInitJin)
				tMinTime = 60
			end
			coroutine.wait(1)
		end
	end)

	
	-- m_Current = Time.time
	m_BMStartTime.text =  '五分钟一场'
	m_BMPlayerNum.text = tBody['cn']
	m_BMMaxPlayer.text = tBody["mincn"].."-" .. tBody["maxcn"];
	m_BMLeftTime.text  = tBody['restseconds']
	local tIsBaoming = tBody['strange']
	local tIsBisai = tBody['late']
	local tIsFull = tBody['full']
	local tIsDelay = tBody['delay']
	local tIsClose = tBody['close']
	local tMaxCn = tBody['maxcn']
	local tPnum = tonumber(tBody["cn"])
	if tIsBaoming then
		m_BMPlayerTip.spriteName = 'strange'
		Invoke(function()
			Utils.LoadLevelGUI('Module_Rooms')
		end,2)
	end
	if tIsBisai then
		m_BMPlayerTip.spriteName = 'late'
		Invoke(function()
			Utils.LoadLevelGUI('Module_Rooms')
		end,2)
	end
	if tIsFull or tPnum >= tMaxCn then
		m_BMPlayerTip.spriteName = 'selfis_full'
		Invoke(function()
			Utils.LoadLevelGUI('Module_Rooms')
		end,2)
	end
	if tIsClose then
		m_BMPlayerTip.spriteName = 'is_close'
		Invoke(function()
			Utils.LoadLevelGUI('Module_Rooms')
		end,2)
	end
	
	m_BMPlayerTip.spriteName = 'waiting'

	 


	if tInitJin ~= nil and m_IsApply then
		m_LevelLab.text = tostring(tInitJin)
	else
		m_LevelLab.text = '1000'
	end

	local awards = tBody["awards"];
	local tRewardBG = this.transform:FindChild('Panel_baoming/jiang_Bg').gameObject
	local tRankObj = this.transform:FindChild('Panel_background/Sprite_menu3/View/award/jianglipanel').gameObject
	if awards ~= nil and #awards>0 then
		for i =1,#awards do
			--报名排名
			local tObj= tRewardBG.transform:FindChild('awardsLab'..i)
			local tLabM = tObj:GetComponent('UILabel')
			local tLabD = tObj:FindChild('awardsDetail'):GetComponent('UILabel')
			--比赛排名 
			local tPanel = tRankObj.transform:FindChild('awardsLab'..i)
			local tPanelLab = tPanel:GetComponent('UILabel')
			local tPanelDetail = tPanel:FindChild('awardsLab'):GetComponent('UILabel')
			
			local tRank = awards[i][1]
			local tAward = awards[i][2]
			tLabM.text = tRank
			tLabD.text = tAward

			tPanelLab.text  = tRank..':'
			tPanelDetail.text = tAward
			if #awards ==4 then
				tObj.gameObject:SetActive(false)
				tPanel.gameObject:SetActive(false)
			else
				tObj.gameObject:SetActive(true)
				tPanel.gameObject:SetActive(true)
			end
		end
	end
end
--change LoadModule rooms    load hall  
function this:ShowPlayerInfo(  )
	local tBaoMing = find('Panel_baoming')
	if m_BMView.activeSelf ==false then 
		if m_BGSource ~= nil then
			m_BGSource.Stop()
		end
	end
	if tBaoMing ~= nil then
		if m_BGSource ~= nil then
			m_BGSource.Stop()
		end
	end
end

function this:ProcessMatchCancel(  pMessageObj)
	EginProgressHUD.Instance:SrpsShowWaitHUD('游戏未达到比赛人数,比赛取消')
end
function this:ProcessNewcn(pMessageObj )
	local tBody = pMessageObj['body']
	m_BMPlayerNum.text = tBody['playern']
	-- coroutine.start(this.ProcessEnd,pMessageObj)
	-- this:ProcessEnd(pMessageObj)
	--change playernsum.Add(body["playern"].ToString());
end

function this:ProcessWaitStart(pMessageObj)
	EginProgressHUD.Instance:SrpsShowWaitHUD1('请等待其他牌桌进行排名')
	m_BMView:SetActive(false)
end

function this:ProcessSendaward(pMessageObj)
	local tBody = pMessageObj['body']
	if tostring(tBody['reason']) == 'lowjushu' then
		EginProgressHUD.Instance:SrpsTishi('本组结束等待其他桌结束,请勿关闭游戏!',10)
	else
		local tInfoBGObj =m_InfoPanelView
		m_InfoPanelView:SetActive(true)
		m_IsGameOver = true 
		coroutine.Stop()
		local tInfoName = tInfoBGObj.transform:FindChild('uname'):GetComponent('UILabel')
		tInfoName.text = EginUser.Instance.username
		local tInfoDate = tInfoBGObj.transform:FindChild('riqi'):GetComponent('UILabel')
		tInfoDate.text = tBody['datetime']
		local tNickName = tInfoBGObj.transform:FindChild('ugameName'):GetComponent('UILabel')
		tNickName.text = SocketConnectInfo.Instance.roomTitle;
		local tInfo = tInfoBGObj.transform:FindChild('uInfo'):GetComponent('UILabel')
		tInfo.text = tostring(tBody['award'])
		local tRankNum = tInfoBGObj.transform:FindChild('uNum'):GetComponent('UILabel')
		tRankNum.text = tostring(tBody['rank'])  
		
		local tBg = tInfoBGObj.transform:FindChild('Infobackground').gameObject
		local tSubTxt = tNickName.gameObject.transform:FindChild('subtxt').gameObject
		if tBody['award'] ~= nil and tostring(tBody['award']) ~= '' and string.len(tostring(tBody['award']))>0 then
			tBg:SetActive(true)
			tSubTxt.gameObject:SetActive(true)
		else
			tBg:SetActive(false)
			tSubTxt.gameObject:SetActive(false)
		end
		local tPlatformName = PlatformGameDefine.playform.PlatformName
		local tPlatName = tInfoBGObj.transform:FindChild('platformName'):GetComponent('UILabel')
		if string.find(tPlatformName,'597')~= nil or string.find(tPlatformName,'1977') ~=nil then 
			tPlatName.text = '597游戏中心'
		elseif string.find(tPlatformName,'407')~=nil or string.find(tPlatformName,'131')~=nil  then
			tPlatName.text = '131游戏中心'
		else
			tPlatName.text = '597游戏中心'	
		end
	end

end

function this:ProcessUnitgrowtip( pMessageObj)	
	local tBody = pMessageObj['body']
	m_AddTime = tBody;
end
--change jishuZJ
function this:ProcessCantrebuy( pMessageObj )
	local tBody = pMessageObj['body']
	local tMaxreBuy = tostring(tBody['maxrebuycn'])
	EginProgressHUD.Instance:SrpsShowWaitHUD('人数少于'..tMaxreBuy..'复活已截止!') 
end

function this.ProcessRecheckin(pMessageObj )

	m_IsApply =true
	m_BMView:SetActive(true)
	local tBody = pMessageObj['body']
	print(cjson.encode(tBody))
	local tIsPlaying = tBody['playing']
	--change zjin initjin
	local tInitJin = tonumber(tBody['init_money']) or 0
	local zJin = tonumber(tBody['increment']) or 0
	
	m_MinTime = tonumber(tBody['left_time'])
	if tInitJin ~= nil and m_IsApply then
		m_LevelLab.text = tostring(tInitJin + zJin)
	else
		m_LevelLab.text = '1000'
	end

	local tDesp = m_Help.transform:FindChild('View/award').gameObject
	local awardlab = tDesp.transform:FindChild("awardLab"):GetComponent('UILabel')
    if tostring(SocketConnectInfo.Instance.roomMinMoney) == "0" then
        awardlab.text = "分组打立出局,初始化积分[ff0101]" .. tInitJin .. "[-],每[ff0101]" ..'1' .. "[-]分钟积分增加[ff0101]" .. zJin .. "[-],积分低于当前基数即被打立,每组[ff0101]前五名[-]可获得丰富的奖励。"
    else
    
        awardlab.text = "分组打立出局,初始化积分[ff0101]" .. tInitJin .. "[-],每[ff0101]" ..'1' .. "[-]分钟积分增加[ff0101]" ..zJin .. "[-],积分低于当前基数即被打立,每组[ff0101]前七名[-]可获得丰富的奖励。"
    end

    local awards = tBody["awards"];
	local tRewardBG = this.transform:FindChild('Panel_baoming/jiang_Bg').gameObject
	local tRankObj = this.transform:FindChild('Panel_background/Sprite_menu3/View/award/jianglipanel').gameObject
	if awards ~= nil and #awards>0 then
		for i =1,#awards do
			--报名排名
			local tObj= tRewardBG.transform:FindChild('awardsLab'..i)
			local tLabM = tObj:GetComponent('UILabel')
			local tLabD = tObj:FindChild('awardsDetail'):GetComponent('UILabel')
			--比赛排名 
			local tPanel = tRankObj.transform:FindChild('awardsLab'..i)
			local tPanelLab = tPanel:GetComponent('UILabel')
			local tPanelDetail = tPanel:FindChild('awardsLab'):GetComponent('UILabel')
			
			local tRank = awards[i][1]
			local tAward = awards[i][2]
			tLabM.text = tRank
			tLabD.text = tAward

			tPanelLab.text  = tRank..':'
			tPanelDetail.text = tAward
			if #awards ==4 then
				tObj.gameObject:SetActive(false)
				tPanel.gameObject:SetActive(false)
			else
				tObj.gameObject:SetActive(true)
				tPanel.gameObject:SetActive(true)
			end
		end
	end


    
	local tMinTime = m_MinTime % 60
	if m_MinTime > 0 then
		coroutine.start(function ()
			while (tonumber(m_MinTime)>0)
			do
				-- if m_MatchTime ~= nil then
				-- 	m_MinTime = m_MinTime-1;
				-- 	local t = EginTools.miao2TimeStr(tonumber(m_MinTime))
				-- 	if m_MatchTime ~= nil then
				-- 		m_MatchTime.text  =  t
				-- 	end
				-- end

				tMinTime = tMinTime-1
				if tMinTime <= 9 and tMinTime >=0 then
					m_AddTimeLab.text  = '0'..tostring(tMinTime)
				else
					m_AddTimeLab.text  = tostring(tMinTime%60)
				end
				if tMinTime == m_AddTime then
					if m_IsGameOver == false then
						tInitJin  = tInitJin + zJin
						EginProgressHUD.Instance.SrpsGametishi2:SetActive(true);
						EginProgressHUD.Instance:SrpsShowWaitHUD2(m_AddTime .. "秒钟后基数将增长翻倍至" .. tInitJin);
					end
				end
				if tMinTime >10 then
					if m_IsGameOver == false then
						if EginProgressHUD.Instance.SrpsGametishi2.activeSelf then
							EginProgressHUD.Instance.SrpsGametishi2:SetActive(false)
						end
					end
				end
				if tMinTime ==0 then
					m_LevelLab.text = tostring(tInitJin)
					tMinTime = 60
				end
				coroutine.wait(1)
			end
		end)
	else
		m_AddTimeLab.text  = '0'..tostring(tMinTime)
	end


	local tLab = m_BMMatchDetail.transform:FindChild('saizhiExplain').gameObject:GetComponent('UILabel')
  	tLab.text = "[7b551e]分组打立出局,初始化积分" .. tInitJin .. ",每" .. m_MinTime .. "分钟积分增加" .. zJin .. ",积分低于当前基数即被打立,每组根据排名可获得丰富的奖励。";

	local tDesp = m_Help.transform:FindChild('View/award').gameObject
	local awardlab = tDesp.transform:FindChild("awardLab"):GetComponent('UILabel')
    if tostring(SocketConnectInfo.Instance.roomMinMoney) == "0" then
        awardlab.text = "分组打立出局,初始化积分[ff0101]" .. tInitJin .. "[-],每[ff0101]" ..'1' .. "[-]分钟积分增加[ff0101]" .. zJin .. "[-],积分低于当前基数即被打立,每组[ff0101]前五名[-]可获得丰富的奖励。"
    else
    
        awardlab.text = "分组打立出局,初始化积分[ff0101]" .. tInitJin .. "[-],每[ff0101]" ..'1' .. "[-]分钟积分增加[ff0101]" ..zJin .. "[-],积分低于当前基数即被打立,每组[ff0101]前七名[-]可获得丰富的奖励。"
    end

	if tIsPlaying == false then
		m_BMPlayerTip.spriteName = 'late'
		coroutine.wait(2.5)
		Utils.LoadLevelGUI('Module_Desks')
	end
end

function this:ProcessNewranks(pMessageObj )
	NNCount.Instance:DestroyHUD()
	m_BMView:SetActive(false)
	local tBody = pMessageObj['body']
	local tRanks = tBody['ranks']
	local tTop = tBody['top10']
	local tAllnum = tonumber(tBody['cn'])

	for k,v in pairs(tRanks ) do
		if v[1] == EginUser.Instance.nickname then
			m_InfoSATxt.text = v[2]..'/'..tostring(tAllnum)
		end
	end
	 m_BMPlayerNum.text = tostring(tBody['cn'])
end

--change  省略 SetDeposit SetChipmin OnShowGetViewAward
function this:ProcessEmotion( pMessageObj )
	local tBody = pMessageObj['body']
	local tId  = tonumber(tBody[1])
	local tNum = tonumber(tBody[2])
	m_EndTime = Time.time
	this:getPlayerCtrl(m_nnPlayerName..tId):SetEmotion(tNum)
end
--change 
function this:Startchip()
	coroutine.wait(1)
	EginProgressHUD.Instance:SrpsShowWaitHUD1('请等待玩家叫庄中')
end
--change  省略 OnSetBiaoQing
function this:ProcessHurry( pMessageObj )
	m_LanguageEndTime = Time.time
	local tBody = pMessageObj['body']
	local tSpokesman = tonumber(tBody['spokesman'])
	local tIndex = tonumber(tBody['index'])
	-- print('  process  == '..tIndex)
	local tSound = m_SendMsgList[tIndex+1]
	if m_Sex == 1 then
		tSound = m_SendMsgListOne[tIndex+1]
	end
	this:getPlayerCtrl(m_nnPlayerName..tSpokesman):SetMessage(tIndex,tSound)
end

--change  省略 OnSetYuyin OnSetText
-------------------------wxl ------------------

function this:InitMenuBtn()
	--初始化菜单按钮
	--右上角菜单按钮
	m_MsgLab = m_UserPlayerObj.transform:FindChild('Output/messages_bg/messages'):GetComponent('UILabel')
	m_BtnZiDongMin = this.transform:FindChild('Panel_background/Sprite_menu2/GameObject/menu/Button_zidongmin/ZdBackground').gameObject
	m_BMAwardsObj = this.transform:FindChild('Panel_background/Sprite_menu3/View/award').gameObject
	m_Menu2 = this.transform:FindChild('Panel_background/Sprite_menu2/GameObject/menu').gameObject
  	m_Menu1 = this.transform:FindChild('Panel_background/Sprite_menu1/Chat_Texture').gameObject
  	m_Menu0 = this.transform:FindChild('Panel_background/Sprite_menu/Menu_Texture').gameObject
 	local tMainMenu = this.transform:FindChild('Panel_background/Sprite_menu').gameObject
  	m_LiShi = tMainMenu.transform:FindChild('Lishi').gameObject
 	local tVChatBtn = this.transform:FindChild('Panel_background/Sprite_menu4').gameObject
  	m_BGVoice = tVChatBtn.transform:FindChild('yuyin_Texture').gameObject


  	local tMenu2Btn =  this.transform:FindChild('Panel_background/Sprite_menu2').gameObject
  	this.mono:AddClick(tMenu2Btn,function ( )
		m_Menu0:SetActive(false)
		m_Menu1:SetActive(false)
  		m_BGVoice:SetActive(false)
  		m_LiShi:SetActive(false)
  		m_BMAwardsObj:SetActive(false)
  		if m_Menu2.activeSelf == false then
  			m_Menu2:SetActive(true)
  		else
  			m_Menu2:SetActive(false)
  		end
  	end)
  	local tRewardBG = this.transform:FindChild('Panel_baoming/jiang_Bg').gameObject
  	local tDetailBtn = this.transform:FindChild('Panel_baoming/BtnMatchDetail').gameObject
  	--查看赛制说明按钮
  	m_BMMatchDetail = this.transform:FindChild('Panel_baoming/explain').gameObject
  	this.mono:AddClick(tDetailBtn,function()
  		if tRewardBG.activeSelf == true then
  			tRewardBG:SetActive(false)
  		end
  		local tIsAct = not m_BMMatchDetail.activeSelf
  		m_BMMatchDetail:SetActive(tIsAct)
  	end)
  	--查看奖励
  	local  tBtnShowReward = this.transform:FindChild('Panel_baoming/BtnRewardsDetail').gameObject
  	this.mono:AddClick(tBtnShowReward,function ( )
  		if m_BMMatchDetail.activeSelf == true then
  			m_BMMatchDetail:SetActive(false)
  		end
  		local tIsShow = tRewardBG.activeSelf
  		tRewardBG:SetActive( not tIsShow)
  	end)
  	--关闭赛事奖励
  	local tRegisterBG = this.transform:FindChild('Panel_baoming/BtnCloseRegister').gameObject
  	this.mono:AddClick(tRegisterBG,function (  )
  		if m_BMMatchDetail ~= nil then 
  			m_BMMatchDetail:SetActive(false)
  		end
  		if tRewardBG ~= nil then 
  			tRewardBG:SetActive(false)
  		end
  	end)

  	--左上角排名
  	local tOpenRankBtn = this.transform:FindChild('Panel_background/Sprite_menu3/BtnRank').gameObject
  	local tBtnRank = m_BMAwardsObj.transform:FindChild('rank').gameObject
	local tBtnReward = m_BMAwardsObj.transform:FindChild('jiangli').gameObject
  	this.mono:AddClick(tOpenRankBtn,function ()
  		-- local tRankPanel = this.transform:FindChild('Panel_background/Sprite_menu3/View/award/paiming').gameObject
  		
  		-- tRankPanel:SetActive(true)
  		m_BMAwardsObj:SetActive(true)
  		--change 
  	end)

  	--左上角
  	-- local tRightUp = this.transform:FindChild('Panel_background/Sprite_menu').gameObject
  	this.mono:AddClick(tMainMenu,function ()
  		m_Menu2:SetActive(false)
	  	m_Menu1:SetActive(false)
	  	m_BMAwardsObj:SetActive(false)
	  	if m_Menu0.activeSelf ==false then
	  		 this:CloseWindow()
	  		 m_Menu0:SetActive(true)
	  	else
	  		m_Menu0:SetActive(false)
	  	end 
  	end)
  	--右下角 voice Chat  and emotion 
  	
  	this.mono:AddClick(tVChatBtn,function ()
  	  	m_Menu0:SetActive(false)
  		m_Menu1:SetActive(false)
  		m_Menu2:SetActive(false)
  	  	m_BMAwardsObj:SetActive(false)
  	  	m_LiShi:SetActive(false)
  	  	if m_BGVoice.activeSelf ==false then
  	  		if m_Sex == 1 then 
  	  			m_BGVoice.transform:FindChild('biaoqing_panel/smile_biaoqing/UIGrid 1').gameObject:SetActive(true)
  	  			m_BGVoice.transform:FindChild('biaoqing_panel/smile_biaoqing/UIGrid').gameObject:SetActive(false)
  	  		else
	  			m_BGVoice.transform:FindChild('biaoqing_panel/smile_biaoqing/UIGrid 1').gameObject:SetActive(false)
  	  			m_BGVoice.transform:FindChild('biaoqing_panel/smile_biaoqing/UIGrid').gameObject:SetActive(true)
  	  		end

  	  		m_BGVoice:SetActive(true)
  	  	else
  	  		m_BGVoice:SetActive(false)
  	  	end

	end)

	local tEBtn = this.transform:FindChild('Panel_background/Sprite_menu1').gameObject
	this.mono:AddClick(tEBtn,function (  )
		m_Menu0:SetActive(false)
  		m_Menu2:SetActive(false)
  		m_Menu1.gameObject.transform.localScale = Vector3.one
  	  	-- m_BGVoice.transform.localScale = Vector3.zero
  	  	m_BGVoice:SetActive(false)
  	  	m_BMAwardsObj:SetActive(false)
  	  	m_LiShi:SetActive(false)
  	  	if m_Menu1.activeSelf == false then
  	  			m_Menu1:SetActive(true)
  	  	else
  	  		m_Menu1:SetActive(false)
  	  	end
	end)
	--展示牌时候的确定按钮 就是原来的亮牌
	local tShowBtn = m_BtnShowObj.transform:FindChild('Determine').gameObject
	this.mono:AddClick(tShowBtn,function (  )
		this:SumNumBtn()
	end)
	--增加牌的点击方法
	for i=0,4 do 
		local tCards = m_UserPlayerObj.transform:FindChild('Output/Cards/Sprite'..tostring(i))
		this.mono:AddClick(tCards.gameObject,function ()
			this:ClickCards(tCards,i)
		end)
	end
	m_ChouMaGroup = this.transform:FindChild('Panel_background/Sprite_Texture/ChoumaGroup')
	local tI = 0
	for i=0 ,17 do
		local tChou = m_ChouMaGroup:FindChild('Chouma'..i+1).gameObject
		if i%6 ==0 then
			tI = tI + 1
			m_ChouMaList[tI] = {}
		end
		 table.insert(m_ChouMaList[tI],tChou)
	end
	--关闭所有弹窗按钮
	local tCloseAllBtn = this.transform:FindChild('Panel_background/CloseWindow').gameObject
	this.mono:AddClick(tCloseAllBtn,function ( )
		this.CloseWindow()
	end)
	--托管按钮
	 
	this.mono:AddClick(m_BtnZiDongMin,function ( )
		local tSp = m_BtnZiDongMin:GetComponent('UISprite')
		if tSp.spriteName == 'xiazhumin' then
			tSp.spriteName  ='xiazhumin_no'
			SettingInfo.Instance.chipmin = false
		elseif tSp.spriteName == 'xiazhumin_no' then
			tSp.spriteName  ='xiazhumin'
			SettingInfo.Instance.chipmin = true
		end
	end)
	local tBtntuo = m_Menu2.transform:FindChild('Button_tuoguan').gameObject
	m_BtnCom =  tBtntuo.transform:FindChild('TgBackground').gameObject
	this.mono:AddClick(m_BtnCom,function ( )
		local tSp = m_BtnCom:GetComponent('UISprite')
		if tSp.spriteName == 'Trusteeship_no' then
			tSp.spriteName  ='Trusteeship'
			m_BtnZiDongMin:GetComponent('UISprite').spriteName = 'xiazhumin'
			SettingInfo.Instance.chipmin = true
			SettingInfo.Instance.deposit = true
		elseif tSp.spriteName == 'Trusteeship' then
			tSp.spriteName  ='Trusteeship_no'
			SettingInfo.Instance.deposit = false
		end
	end)
	--排名 奖励按钮 
	
	this.mono:AddClick(tBtnRank,function ()
		if tBtnRank:GetComponent('UISprite').spriteName == 'rank_click' then
			tBtnRank:GetComponent('UISprite').spriteName = 'rank'
			tBtnReward:GetComponent('UISprite').spriteName = 'jiangli_click'
			m_BMAwardsObj.transform:FindChild('paiming').gameObject:SetActive(false)
			m_BMAwardsObj.transform:FindChild('jianglipanel').gameObject:SetActive(true)

		end

	end)
	this.mono:AddClick(tBtnReward,function ()
		if tBtnReward:GetComponent('UISprite').spriteName == 'jiangli_click' then
			tBtnReward:GetComponent('UISprite').spriteName = 'jiangli'
			tBtnRank:GetComponent('UISprite').spriteName = 'rank_click'
			m_BMAwardsObj.transform:FindChild('paiming').gameObject:SetActive(true)
			m_BMAwardsObj.transform:FindChild('jianglipanel').gameObject:SetActive(false)
		end
	end)

	-- 看历史牌型
	local tBtnHistory = tMainMenu.transform:FindChild('Menu_Texture/Pai_PointCount').gameObject

	this.mono:AddClick(tBtnHistory,function ( )
		m_Menu0:SetActive(false)
		m_Menu1:SetActive(false)
		m_Menu2:SetActive(false)
		if m_LiShi.activeSelf == false then
			m_LiShi:SetActive(true)
		else
			m_LiShi:SetActive(false)
		end
	end)
	--开关音效
	local tSoundBtn = tMainMenu.transform:FindChild('Menu_Texture/Sound').gameObject
	m_Sound = tMainMenu.transform:FindChild('SoundString').gameObject
	
	this.mono:AddClick(tSoundBtn,function ( )
		m_Menu0:SetActive(false)
		m_Menu1:SetActive(false)
		m_Menu2:SetActive(false)
		-- m_BGVoice.transform.localScale = Vector3.zero
		m_BGVoice:SetActive(false)
		m_LiShi:SetActive(false)
		if m_Sound.activeSelf == false then
			m_Sound:SetActive(true)
		else
			m_Sound:SetActive(false)
		end
	end)
	--帮助
	local tBtnHelp = tMainMenu.transform:FindChild('Menu_Texture/help').gameObject
	m_Help = tMainMenu.transform:FindChild('Help').gameObject
	this.mono:AddClick(tBtnHelp,function ( )
		this:CloseWindow()
		if m_Help.activeSelf == false then
			m_Help:SetActive(true)
		else
			m_Help:SetActive(false)
		end
	end)

	local tBtnExit = tMainMenu.transform:FindChild('Menu_Texture/Exit').gameObject
	m_Exit = tMainMenu.transform:FindChild('Exit').gameObject
	this.mono:AddClick(tBtnExit,function ( )
		m_Menu0:SetActive(false)
		m_Menu1:SetActive(false)
		m_Menu2:SetActive(false)
		-- m_BGVoice.transform.localScale = Vector3.zero
		m_BGVoice:SetActive(false)
		m_LiShi:SetActive(false)
		m_Sound:SetActive(false)
		m_Help:SetActive(false)

		if m_Exit.activeSelf == false then
			m_Exit:SetActive(true)
		else
			m_Exit:SetActive(false)
		end
	end)
	--奖状界面的两个按钮
	local tBtnSure = m_InfoPanelView.transform:FindChild('Determine').gameObject
	this.mono:AddClick(tBtnSure,function ( )
		this:UserQuit()
	end)
	local tBtnRe = m_InfoPanelView.transform:FindChild('baoming').gameObject
	this.mono:AddClick(tBtnRe,function ( )
		print(' baoming ')
		local tMsg = {}
		tMsg['type'] = 'game'

		tMsg['tag'] = 'quit'
		this.mono:SendPackage(cjson.encode(tMsg))
		 SocketConnectInfo.Instance.roomFixseat = true	 
        Utils.ClearListener()
        Utils.Disconnect('Exit from the game.')
        -- this.mono:Disconnect('Exit from the game.')
        EginUserUpdate.Instance:UpdateInfoNow()
        coroutine.start(function ( )
        	coroutine.wait(0.5)
        	this.mono:StartGameSocket()
        	 Utils.ConnectSocket(SocketConnectInfo.Instance);

			EginProgressHUD.Instance:HideHUD();
			PlatformGameDefine.game:StartGame();
        end)
	end)

	m_BiaoQingParent = m_Menu1.transform:FindChild('biaoqing_panel/smile_biaoqing').gameObject
	for i=1,27 do 
		local tEmo = m_BiaoQingParent.transform:FindChild('UIGrid/biaoqing_'..i).gameObject
		this.mono:AddClick(tEmo,function ( )
			this:OnSetBiaoQing(tEmo)
		end)
	end

	local tMsgParent = this.transform:FindChild('Panel_background/Sprite_menu4/yuyin_Texture/biaoqing_panel/smile_biaoqing/UIGrid').gameObject
	
	for i=1,7 do 
		local tLab = tMsgParent.transform:FindChild('yuyinLab_'..(i-1)).gameObject
		this.mono:AddClick(tLab,function ( )
			this:OnSetText(tLab,i-1)
		end)
		
	end
	tMsgParent = this.transform:FindChild('Panel_background/Sprite_menu4/yuyin_Texture/biaoqing_panel/smile_biaoqing/UIGrid 1').gameObject
	for i=1,8 do 
		local tLab = tMsgParent.transform:FindChild('yuyinLab_'..(i-1)).gameObject
		this.mono:AddClick(tLab,function ( )
			this:OnSetText(tLab,i-1)
		end)
	end
	local tBtnSend = m_BGVoice.transform:FindChild('biaoqing_panel/yuyinBtn').gameObject
	this.mono:AddClick(tBtnSend,function ( )
		this:OnSetYuyin(tBtnSend)
	end)
	--背景音乐
	local tBGMusicBtn = m_Sound.transform:FindChild('BackgroundMusic').gameObject
	this.mono:AddClick(tBGMusicBtn,function (  )
		this:SetBGMusic(tBGMusicBtn)
	end)
	--音效
	local tSoundEffectBtn = m_Sound.transform:FindChild('GameAudio').gameObject
	this.mono:AddClick(tSoundEffectBtn,function ()
		local tSp = tSoundEffectBtn.transform:GetComponent('UISprite')
		if tSp.spriteName == "Voice_close" then
            tSp.spriteName = "Voice_open"
            SettingInfo.Instance.specialEfficacy = true
            SettingInfo.Instance.effectVolume = 1.0
        else
            tSp.spriteName = "Voice_close"
            SettingInfo.Instance.specialEfficacy = false
            SettingInfo.Instance.effectVolume = 0.0
        end
	end)
	local tVoiceBtn = m_Sound.transform:FindChild('GameVoice').gameObject
	this.mono:AddClick(tVoiceBtn,function ( )
		local tSp = tVoiceBtn:GetComponent('UISprite')
		  if tSp.spriteName == "Voice_close" then
            tSp.spriteName = "Voice_open";
            SettingInfo.Instance.gameVoice = true
        else
            tSp.spriteName = "Voice_close";
            SettingInfo.Instance.gameVoice = false
        end
	end)

	local tBtnCancel = m_Exit.transform:FindChild('Continue').gameObject
	this.mono:AddClick(tBtnCancel,function ()
		m_Exit.gameObject:SetActive(false)
	end)
	local tBtnLeave = m_Exit.transform:FindChild('Leave').gameObject
	this.mono:AddClick(tBtnLeave,function ()
		this:CloseWindow()
		this:OnClickBack()
		-- m_Exit.gameObject:SetActive(false)
	end)
	-- local tDesp = m_Help.transform:FindChild('View/award').gameObject
	-- this.mono:AddClick(tDesp,function ( )
		 -- local awardlab = tDesp.transform:FindChild("awardLab"):GetComponent('UILabel')
   --          if SocketConnectInfo.Instance.roomMinMoney == "0" then

   --              awardlab.text = "分组打立出局,初始化积分[ff0101]" + initjin + "[-],每[ff0101]" .. fenzhong + "[-]分钟积分增加[ff0101]" + Zjin + "[-],积分低于当前基数即被打立,每组[ff0101]前五名[-]可获得丰富的奖励。"
   --          else
            
   --              awardlab.text = "分组打立出局,初始化积分[ff0101]" + initjin + "[-],每[ff0101]" ..fenzhong + "[-]分钟积分增加[ff0101]" + Zjin + "[-],积分低于当前基数即被打立,每组[ff0101]前七名[-]可获得丰富的奖励。"
   --          end
	-- end)
end

function this:OnSetText( pLab ,pIndex)
	-- print('OnSetText')
	-- print(pLab)
	-- print(pIndex)
	m_MsgLab.text = pLab:GetComponent('UILabel').text 
	local tText = m_BGVoice.transform:FindChild('message_lab'):GetComponent('UILabel')
	tText.text = pLab:GetComponent('UILabel').text 
	m_IsSetText = true
	m_SoundIndex = pIndex
end

function this:OnSetYuyin(pSoundObj)
	if m_SoundIndex == -1 then
		m_MessageError:SetActive(true)
		m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text = XMLResource.Instance:Str('message_error_6') --'发送失败' 
		coroutine.start(function (  )
			coroutine.wait(1.5)
			m_MessageError:SetActive(false)
		end)	
	else
		if m_IsSetText == true then
			if Time.time - m_LanguageEndTime < 10 then
				m_MessageError:SetActive(true)
				m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text =XMLResource.Instance:Str('message_error_5') --'发送失败'  
				coroutine.start(function (  )
					coroutine.wait(1.5)
					m_MessageError:SetActive(false)
				end)	
			else
				local tContinue = {}
				tContinue['hurry_index'] = m_SoundIndex
				local tNew = {}
				tNew['type'] = 'game'
				tNew['tag'] = 'hurry'
				tNew['body'] = tContinue 
				this.mono:SendPackage(cjson.encode(tNew))
			end 
		else
			local tLab = this.transform:FindChild('GameToastError/ToastLabel').gameObject
			local tBg = this.transform:FindChild('GameToastError/ToastBG').gameObject
			local  errMsg = '你尚未没有在游戏中，无法发送聊天'
			tLab:GetComponent('UILabel').text = errMsg
			
			coroutine.start(function ( )
				coroutine.wait(1)
				local tAlpha = 1 
				while (tAlpha >=0)
				do
					tAlpha = tAlpha -0.1
					tLab:GetComponent('UILabel').alpha = tAlpha
					tBg:GetComponent('UISprite').alpha = tAlpha
					coroutine.wait(0.1)
				end
			end)
		end
		 m_MsgLab.text = "说点什么吧!"
        -- m_BGVoice.transform.localScale = Vector3.zero
        m_BGVoice:SetActive(false)
        m_SoundIndex = -1;
	end
end

function this:OnSetBiaoQing(pBtn)
	if Time.time - m_EndTime < 10 then
		m_MessageError:SetActive(true)
		m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text ='发送失败'
		coroutine.start(function (  )
			coroutine.wait(1.5)
			m_MessageError:SetActive(false)
		end)
	else
		local tPlayer = find(m_nnPlayerName..EginUser.Instance.uid)
		local tIsIn = false
		local tIndex =0
		if tableContains(m_PlayingPlayerObjList,tPlayer) == true then 
			tIsIn = true			
		end

		if m_BiaoQingParent.activeSelf == true then
			for i=1 , 27 do 
				local tSmile = m_BiaoQingParent.transform:FindChild('UIGrid/biaoqing_'..i).gameObject
				if pBtn == tSmile then
					tIndex = i 
					break
				end
			end
		end
		if tIsIn then
			local tContinue = {}
			tContinue['type'] = 'game'
			tContinue['tag'] = 'emotion'
			tContinue['body'] = tIndex 
			this.mono:SendPackage(cjson.encode(tContinue))
		end
	end
	m_Menu1:SetActive(false)
end
--统计牌结束后的决定按钮
function this:SumNumBtn( )
	local tShowCards = {}
	tShowCards['type'] = 'sr5m'
	tShowCards['tag'] = 'ok'
	tShowCards['body'] = 0
	this.mono:SendPackage(cjson.encode(tShowCards))
	for k,v  in pairs(m_PlayingPlayerObjList) do
		if IsNil(v) == false then
			if v ~= nil then
				local tCtrl = this:getPlayerCtrl(v.name)
				if v ~= m_UserPlayerObj then
					tCtrl:SetShow(false)
					tCtrl:SetUserChipShow(false)
					tCtrl:SetCardClosing(false)
				end
			end
		end
	end
	m_BtnShowObj:SetActive(false)

	NNCount.Instance:DestroyHUD()
	m_CardNumList = {}
	m_CardList = {}
end

function this:ClickCards(pCard,pCardNum)
	if pCard ~= nil then
		local tLen = 0 
		for k,v in pairs(m_CardNumList) do
			if v ~= nil then 
				tLen = tLen +1 
			end
		end
		
		if m_CardList ~= nil then
 			local tNNum = (tonumber(m_CardList[pCardNum+1]) +1)%13
 			if tNNum >10 or tNNum ==0 then
 				tNNum = 10 
 			end
			if m_CardNumList[tostring(pCardNum)] ~= nil then
				pCard:GetComponent('TweenPosition'):PlayReverse()	
				m_CardNumList[tostring(pCardNum)] = nil 
			else
				if tLen >= 3 then
					return
				end
				
				local tIndex = tLen + 1	
				local tCell = {}
				local tIsIn = false
				local tIsIn1 = false
				local tIsIn2 = false
				local tIndex1 
				local tIndex2
				if tIndex == 1 then
					tIndex1 = 2
					tIndex2 = 3
				elseif tIndex == 3 then
					tIndex1 = 1
					tIndex2 = 2
				elseif tIndex ==2 then
					tIndex1 = 1
					tIndex2 = 3
				end

				for k,v in pairs(m_CardNumList) do 
					if v.index == tIndex then
						tIsIn = true 						
					elseif v.index == tIndex1 then 
						tIsIn1 = true
					elseif v.index == tIndex2 then
						tIsIn2 = true
					end
				end

				if tIsIn == true  then
					if tIsIn1 == true then
						if tIsIn2 == true then
							return 
						else
							tIndex = tIndex2
						end
					else
						tIndex = tIndex1
					end
				end
				pCard:GetComponent('TweenPosition'):PlayForward()

				tCell['index'] = tIndex
				tCell['num'] = tNNum
				tCell['realNum'] = tonumber(m_CardList[pCardNum+1]) +1
				m_CardNumList[tostring(pCardNum)] = tCell
			end
		end
		-- local tShowCardSum = m_UserPlayerObj.transform:FindChild('Output/ShowCardtype').gameObject
		local tSum = 0
		local tTotal = 0
		for i= 1,3 do 
			local tLab = m_BtnShowObj.transform:FindChild('UILab_'..tostring(i)):GetComponent('UILabel')
			local tIsIn = false 
			for k,v in pairs(m_CardNumList) do 
				if v ~= nil then
					if v['index'] == i then
						tLab.text = tostring(v['num'])
						tIsIn = true
						tSum = tSum + v['num']
						tTotal = tTotal +1
						break;
					end
				end
			end
			if tIsIn ==false then
				tLab.text = ''
			end
		end
		m_BtnShowObj.transform:FindChild('UILabSum'):GetComponent('UILabel').text = tSum
		if tTotal ==3 and tSum%10 ==0 then
			this:UserShow()
		elseif tTotal ==2 then
			
			for k,v in pairs(m_CardList) do
				local tSumNext = tSum
				local tIsIn = false 
				for x,y in pairs(m_CardNumList) do 
					if tonumber(v)+1 == tonumber(y['realNum']) then
						tIsIn = true 
						break
					end  
				end
				if tIsIn == false then
					 local tN= ((tonumber(v)+1)%13)
					 if tN == 0 or tN >=10 then
					 	tN = 10
					 end

					tSumNext =  tSumNext+tN
					if tSumNext %10 ==0 then
						this:UserShow()
						break
					end
				end
			end
		end
	end
end

function this:SetCardNum(pSum)
	local tNum = 0
	for k,v in pairs(m_CardNumList) do
		tNum = tNum + v['num']
	end
	if tNum %10 ==0 then
		this:UserShow()
	end
end

function this:OnDestroy()
	log("--------------------ondestroy of GameMXNNPanel")
	this:ClearLuaValue()
end

function this:SetBGMusic(pParent)
	local tSp = pParent.transform:GetComponent('UISprite')
	 if tSp.spriteName == "Voice_close" then
        tSp.spriteName = "Voice_open"
        SettingInfo.Instance.specialEfficacy = true
        SettingInfo.Instance.effectVolume = 1.0
    else
        tSp.spriteName = "Voice_close"
        SettingInfo.Instance.specialEfficacy = false
        SettingInfo.Instance.effectVolume = 0.0
    end
end
 


function this:CloseWindow()
	m_Menu0:SetActive(false)
	m_Menu2:SetActive(false)
    m_Menu1:SetActive(false)
    m_BGVoice:SetActive(false)
    m_BMAwardsObj:SetActive(false)
    m_LiShi:SetActive(false)
    m_Help:SetActive(false)
    m_Exit:SetActive(false)
    m_Sound:SetActive(false)
    local closewindow = GameObject.Find("PlayerMenu");
    if closewindow ~= nil then
        for  i = 0, closewindow.Length-1 do 
            GameObject.FindGameObjectWithTag("PlayerMenu").SetActive(false);
        end
    end
end

