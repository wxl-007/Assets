local this = LuaObject:New()
DZPKPlayerCtrl = this

function this:New( gameObj)
  local obj = {}
  setmetatable(obj,self )
  self.__index = self 
  obj.gameObject = gameObj
  obj.transform = gameObj.transform
  obj:Awake()
  obj:Start()
  return obj
end

this.m_ParentX = 0
this.m_ParentY = 30
this.m_ParentZ = 0
this.m_CardInterval = 40
this.m_CardPreStr = 'card_'
this.m_TimeInterval =3
this.m_TimeLasted =0
this.cardMoveCount=0


this.m_SendMsgList = {
	'莫偷鸡,偷鸡必被抓!',
	'别挣扎了,大奖非我莫属!',
	'我的宝剑已经饥渴难耐了!',
	'冷静!冲动是魔鬼!',
	'对子再手,天下无敌!',
	'这手牌打的不错,赢的漂亮!',
	'快点下注吧!爷时间宝贵!',
	'很高兴能和大家一起打牌',
	'赢钱了别走,留下你的姓名!',
	'难道你看穿我的底牌了吗?',
	'各位爷,让看看翻牌再加注吧!',
	'输惨了啦!',
	'似乎有埋伏,不可轻举妄动。',
	'你牌技这么好,地球人知道吗?',
	'想什么呢？快点！',
}


function this:clearLuaValue(  )
  self.gameObject= nil 
  self.transform = nil 
  self.m_CardTypeTrans  =nil      -- 提示字比牌結果
  self.m_UserAvatar     =nil     --玩家头像
  self.m_UserNickNameSp     =nil  --玩家昵称
  self.m_UserIntoMoneyLab     =nil--玩家现金

  self.m_CardArraySps = {}    --玩家的扑克牌
  self.m_CardTrans    =nil        --玩家的牌的 父物体
  self.m_CardScoreObj  =nil       -- 玩家得分
  self.m_CardScoreSp    =nil       
  
  self.m_BankerSpObj=nil
  self.m_BankerBgObj=nil
  
  self.m_InfoDetail=nil
  self.m_DetailNickNameLab=nil
  self.m_DetailLevelLab=nil
  self.m_DetailBagMoneyLab=nil
  self.m_TimeLasted =0
  self.m_ChouMaCount =0
  self.m_ShowObj = nil
	
	self.m_UserInfoMoney = nil  
	self.m_PublicCardsArray = nil 
	self.m_PublicTarget = nil 
	self.m_BankerSpObj1 = nil 
	self.m_InfoDetail = nil 
	self.m_DetailLevelLab  =nil
	self.m_DetailNickNameLab = nil 
	self.m_DetailBagMoneyLab =  nil 
	self.m_Target = nil 
	self.m_ZuiDaCardType = {}
	self.m_ZuiDaCard = {}
	self.m_EmotionParent = nil 
	self.m_WinTeXiao = nil
	self.m_WinRoate = nil 
	self.m_ChouMaHuiShou = nil 
	self.MyID = -1
  	coroutine.Stop()
end

function this:Awake()
	self:init()
	self.m_ParentX = self.m_CardTrans.localPosition.x
	self.m_ParentY = self.m_CardTrans.localPosition.y
	self.m_ParentZ = self.m_CardTrans.localPosition.z
end

function this:UpdateSkinColor()
  for k,v in pairs(self.m_CardArraySps) do
    v.spriteName = this.m_CardPreStr .. GlobalVar.SKINCARD_COLOR;
  end
end

function this:Start( )

	-- print(' ctrl start end  =========')
end

function this:init()
	-- print('  ctrl  init +++++++++++   ')
  	this.m_TimeLasted =0
  	self.m_FristCNum  = -1
  	self.m_Time = 15 
  	self.m_Count = 0
  	self.m_IsSetTime = true 
  	self.m_PlaySound = true
  	self.m_CardTrans = self.transform:FindChild('Output/Cards')
  	self.m_CardTypeTrans  = self.transform:FindChild('Output/CardType')
  	self.m_CardArraySps = {}
  	self.MyID = -1

  	self.m_CardScoreObj = self.transform:FindChild('Output/CardScore').gameObject
  	self.m_CardScoreSp = self.m_CardScoreObj.transform:FindChild('Sprite_bg').gameObject
  	self.m_UserInfo = self.transform:FindChild('wanjiaxinxi').gameObject
  	self.m_ChouMaCount =0
  	if self.gameObject.name ~= "User" and self.gameObject.name ~= ("DZPKPlayer_"..tostring(EginUser.Instance.uid)) then
	  	-- self.m_ReadyObj = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_ready').gameObject
	  	self.m_ShowObj = self.transform:FindChild('Output/Sprite_show').gameObject
		-- self.m_CallBankerObj = self.transform:FindChild('Output/Sprite_callBanker').gameObject
		-- self.m_WaitObj = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_waitting').gameObject
		self.m_UserAvatar = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite (avatar_6)'):GetComponent('UISprite')
		self.m_UserNickNameLab = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_headFrame/Label_nickname'):GetComponent('UILabel')
		self.m_UserNickName1 = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_headFrame/Label_nickname_1'):GetComponent('UILabel')
		self.m_LiPinBtn1 = self.transform:FindChild('Output/Sprite_lipin_1').gameObject
		self.m_LiPinBtn = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_lipin').gameObject
		self.m_UserIntoMoneyLab = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_headFrame/Label_bagmoney'):GetComponent('UILabel')
		self.m_UserInfoMoney = nil  
		self.m_PublicCardsArray = nil 
		self.m_PublicTarget = nil 
		self.m_BankerSpObj = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_banker').gameObject
		self.m_BankerBgObj = self.transform:FindChild('PlayerInfo/Sprite_headframe_banker').gameObject
		self.m_BankerSpObj1 = self.transform:FindChild('Output/Sprite_banker_1').gameObject
		self.m_InfoDetail = self.transform:FindChild('PlayerInfo/Info_detail').gameObject
		self.m_DetailLevelLab  =self.m_InfoDetail.transform:FindChild('Label2/Level'):GetComponent('UILabel')
		self.m_DetailNickNameLab = self.m_InfoDetail.transform:FindChild('Label1/Nickname'):GetComponent('UILabel')
		self.m_DetailBagMoneyLab =  self.m_InfoDetail.transform:FindChild('Label3/BagMoney'):GetComponent('UILabel')
		-- self.m_Target = nil 
		self.m_ZuiDaCardType = {}
		self.m_ZuiDaCard = {}
		self.m_EmotionParent = self.m_UserAvatar.transform
		self.m_WinTeXiao = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_win'):GetComponent('UISprite')
		self.m_WinRoate = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_winrotate'):GetComponent('UISprite')
		self.m_ChouMaHuiShou = self.m_CardScoreObj.transform:FindChild('Sprite_bg_target'):GetComponent('UISprite')
		for i=0,self.m_CardTrans.childCount-1 do
		    local card = self.m_CardTrans:GetChild(i):GetComponent('UISprite')
		    if card ~= nil then
		    	table.insert(self.m_CardArraySps,card)
		    end  
	  	end
	  	self.m_UserBagmoneyActualLab = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_headFrame/Label_bagmoney_actual'):GetComponent('UILabel')
		self.m_LiPinSp = self.transform:FindChild('Output/Sprite_lipin_1'):GetComponent('UISprite')
		self.m_UserIdLab = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite_headFrame/Label_id'):GetComponent('UILabel') 
	
	else
		for i=1,5 do
		    local card = self.m_CardTrans:FindChild('Sprite'..i):GetComponent('UISprite')
		    if card ~= nil then
		    	table.insert(self.m_CardArraySps,card)
		    end  
  		end

		self.m_ShouObj = self.m_CardTrans:FindChild('Sprite1/Sprite').gameObject
		local tRoot =  find('FootInfo_DZPK(Clone)')
		local  tParent = tRoot.transform:FindChild('Panel_info/Foot - Anchor/Info')
		self.m_UserAvatar =  tParent:FindChild('Sprite_Avatar'):GetComponent('UISprite')
		self.m_UserNickNameLab = tParent:FindChild('Label_Nickname'):GetComponent('UILabel')
		self.m_UserNickName1 = tParent:FindChild('Label_Nickname_1'):GetComponent('UILabel')
		self.m_UserIntoMoneyLab = tParent.transform:FindChild('Money/Label_Bagmoney'):GetComponent('UILabel')
		self.m_BankerBgObj = nil 
		self.m_BankerSpObj = tParent.transform:FindChild('Sprite_banker').gameObject

		self.m_UserBagmoneyActualLab = self.transform:FindChild('bagmoney_actual'):GetComponent('UILabel')
		self.m_PublicCardsArray = {}
		local tPublicParent = self.transform:FindChild('Output/PublicCards')
		for i=0,tPublicParent.childCount-1  do
	    	local tCard = tPublicParent:GetChild(i).gameObject;
	    	if tCard.name == 'Sprite' then 
	      		table.insert(self.m_PublicCardsArray,tCard:GetComponent("UISprite"))
	      	end  
  		end
  		self.m_PublicTarget = tPublicParent:FindChild('target')
  		self.m_CardAnimationParent = self.transform:FindChild('Output').gameObject
		self.m_BankerSpObj1 = self.transform:FindChild('banker_1').gameObject
		
		self.m_ChouMaHuiShou = self.m_CardScoreObj.transform:FindChild('Sprite_bg_target'):GetComponent('UISprite')
		
		self.m_YouWin = self.transform:FindChild('Output/win').gameObject
		self.m_MessagePrompt = self.transform:FindChild('Output/message_prompt'):GetComponent('UISprite')
		
		self.m_EmotionParent = self.m_UserAvatar.transform
		self.m_WinTeXiao = self.transform:FindChild('Sprite_win'):GetComponent('UISprite')
		self.m_WinRoate = self.transform:FindChild('Output/Sprite_winrotate'):GetComponent('UISprite')
		self.m_LiPinSp = tParent:FindChild('Sprite_lipin'):GetComponent('UISprite')
		self.m_UserIdLab = tParent.transform:FindChild('Sprite_id'):GetComponent('UILabel') 
	end
	self.m_UserBagmoneyActualNum = 0 
	self.m_FirstCardPos  = self.m_CardArraySps[1].transform.localPosition
	self.m_BetTarge =   self.m_CardScoreObj.transform:FindChild('bet_target')
	self.m_PaiJiXin = self.m_UserInfo.transform:FindChild('userinfo/panel_paijixinxi').gameObject
	self.m_Target = self.m_CardTrans:FindChild('target'):GetComponent('UISprite')
	self.m_BetLab =self.m_CardScoreObj.transform:FindChild('bet_label'):GetComponent('UILabel')
	self.m_WinBetLab = self.m_CardScoreObj.transform:FindChild('winbet_label'):GetComponent('UILabel')
	self.m_BetChoumaSp = self.m_CardScoreObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite')
	self.m_UserInfoName = self.m_UserInfo.transform:FindChild('userinfo/username_label'):GetComponent('UILabel')
	self.m_UserInfoMoney = self.m_UserInfo.transform:FindChild('userinfo/bagmoney_label'):GetComponent('UILabel') 
	self.m_UserInfoAvatar = self.m_UserInfo.transform:FindChild('userinfo/avatar/Sprite'):GetComponent('UISprite') 
	self.m_UserInfoID = self.m_UserInfo.transform:FindChild('userinfo/ID_label'):GetComponent('UILabel')
	self.m_SpecialCardType =self.transform:FindChild('Output/special_cardtype').gameObject
	

	self.m_HuDongBtn =self.m_UserInfo.transform:FindChild('userinfo/hudongdaoju'):GetComponent('UISprite') 
	self.m_PaiJiBtn =self.m_UserInfo.transform:FindChild('userinfo/paijixinxi'):GetComponent('UISprite')
	self.m_SendGiftParent = self.m_UserInfo.transform:FindChild('userinfo/panel_hudongdaoju').gameObject
	self.m_ZhongPaiJu =self.m_PaiJiXin.gameObject.transform:FindChild('zongpaiju_1'):GetComponent('UILabel') 
	self.m_ShengFu =self.m_PaiJiXin.gameObject.transform:FindChild('shengfu_1'):GetComponent('UILabel') 
	self.m_ShengLv =self.m_PaiJiXin.gameObject.transform:FindChild('shenglv_1'):GetComponent('UILabel')
	self.m_ZuiDaYingQu =self.m_PaiJiXin.gameObject.transform:FindChild('zuiduoyingqu_1'):GetComponent('UILabel')
	self.m_ZuiDaCardType = {}
	self.m_ZuiDaCard = {}
	local tObj = self.m_PaiJiXin.gameObject.transform:FindChild('zuidachengpai_1')
	for i=1,5 do 
		local tLab = tObj:FindChild('card_'..i):GetComponent('UILabel')
		local tSprite = tObj:FindChild('type_'..i):GetComponent('UISprite')
		table.insert(self.m_ZuiDaCardType,tSprite)
		table.insert(self.m_ZuiDaCard,tLab)
	end
	self.m_jinQianPos = self.m_CardScoreObj.transform:FindChild('winbet_label_targetposition')
	if self.m_PublicCardsArray ~= nil then
		self.m_PublicCardsPos = self.m_PublicCardsArray[1].transform.localPosition
	end
	self:InitBtnFunc()
end


function this:InitBtnFunc(  )
	if self.gameObject.name ~= "User" and self.gameObject.name ~= ("DZPKPlayer_"..tostring(EginUser.Instance.uid)) then
		
		GameDZPK.mono:AddClick(self.m_UserAvatar.gameObject,function (  )
			self:PlayerInfoShow()
		end)
	else
		GameDZPK.mono:AddClick(self.transform:FindChild('Avatar').gameObject,function ()
			self.m_UserInfo:SetActive(true)
			self.m_UserInfoID.text = tostring(self.MyID)
			self.m_UserInfoName.text = self.m_UserNickName1.text 
			self.m_UserInfoMoney.text = '$'..self.m_UserBagmoneyActualLab.text 
			self.m_UserInfoAvatar.spriteName = self.m_UserAvatar.spriteName
		end)
	end
	GameDZPK.mono:AddClick(self.m_LiPinBtn1,function (  )
		self:LiPinShow()
	end)
	GameDZPK.mono:AddClick(self.m_UserInfo.transform:FindChild('userinfo/CloseButton').gameObject,function (  )
		self:Close()
	end)
	for i=1,8 do 
		local tObj = self.m_SendGiftParent.transform:FindChild('liwu_'..i).gameObject
		GameDZPK.mono:AddClick(tObj,function (  )
			self:OnSendGift(tObj)
		end)
	end
	GameDZPK.mono:AddClick(self.m_HuDongBtn.gameObject,function (  )
		self:OnButtonClick(self.m_HuDongBtn.gameObject)
	end)
	-- 	GameDZPK.mono:AddClick(self.m_HuDongBtn.gameObject,function (  )
	-- 	self:OnButtonClick(self.m_HuDongBtn.gameObject)
	-- end)
end


function this:UpdateIntomoney(pIntoMoney)
	if self.m_UserIntoMoneyLab == nil then
		find('Label_bagmoney'):GetComponent('UILabel').text = EginTools.NumberAddComma(pIntoMoney)
	else
		self.m_UserIntoMoneyLab.text = pIntoMoney  -- EginTools.NumberAddComma(tonumber(pIntoMoney))
	end
end

function this:GetChouMaCount()
	return self.m_ChouMaCount
end

function this:SetPlayerInfo( pAvatar,pNickname,pBagMoney,pLevel,pUid,pIntoMoney,mIsWait)
	self.m_UserAvatar.spriteName = 'avatar_'..pAvatar
	self.m_UserNickNameLab.text = pNickname
	self.m_UserNickName1.text = pNickname
	self.m_UserIdLab.text = tostring(pUid)
	self.m_UserInfoID.text = tostring(pUid)
	if string.len(self.m_UserNickNameLab.text) > 5 then
		self.m_UserNickNameLab.text = string.sub(pNickname,0,5)
	end

	self.m_UserIntoMoneyLab.text = EginTools.NumberAddComma(pIntoMoney)
	if self.m_DetailNickNameLab ~= nil then
		self.m_DetailNickNameLab.text = pNickname
	end
	if self.m_DetailLevelLab ~= nil then
		self.m_DetailLevelLab.text = pLevel
	end
	self.m_Sex = pAvatar%2
	self.MyID = tonumber(pUid)
	print('sent  infor  ============== ' .. pUid)
	print('sent  my id   ============== ' .. self.MyID )
	
	if mIsWait then
		self.m_UserAvatar.alpha = 0.3
	end

end

function this:SetPlayMoney(pIntoMoney)
	-- print('SetPlayMoney ')
	if self.m_UserIntoMoneyLab ~= nil then
		local tGameKK = find('Label_Bagmoney')
		if tGameKK ~= nil then
			tGameKK:Getcomponent('UILabel').text = EginTools.NumberAddComma(pIntoMoney)
		end
	else
		self.m_UserIntoMoneyLab.text = EginTools.NumberAddComma(pIntoMoney)
	end
end

function this:SetMessage(pIndex )
	-- print('set message ')
	self.m_MessagePrompt.gameObject:SetActive(true)
	self.m_MessagePrompt.transform:FindChild('Label'):GetComponent('UILabel').text = this.m_SendMsgList[pIndex]
	if pIndex < 7 then
		local tClip = ResManager:LoadAsset("gamenn/Sound",'man'..(pIndex+2))
		EginTools.PlayEffect(tClip)
	else
		local tClip = ResManager:LoadAsset("gamenn/Sound",'woman'..(pIndex+2))
		EginTools.PlayEffect(tClip)
	end
	coroutine.start(function ()
		coroutine.wait(2)
		self.m_MessagePrompt.transform:FindChild('Label'):GetComponent('UILabel').text = ''
		self.m_MessagePrompt.gameObject:SetActive(false)
	end)
	-- print('set message end ')
end



function this:SetDeal(pToShow,pInfo)
	-- print('set deal  ')
	if pToShow == false then
		self.m_CardTrans.gameObject:SetActive(false)
	else
		self.m_CardTrans.gameObject:SetActive(true)
		local tClip = ResManager:LoadAsset('gamenn/Sound','send')
		EginTools.PlayEffect(tClip)
		-- if pInfos ~= nil and pInfos.Length >0 then
		-- 	for i=1,pInfos.Length do 
		-- 		if pInfos[i]~= nil then
		-- 			self.m_CardArraySps[i].spriteName = self.m_CardPreStr..tostring(pInfo[i])
		-- 		end
		-- 	end
		-- end
	end
end

function this:SetOther(pIndex )
	-- print('  set other  ========================')
	self.m_CardTrans.gameObject:SetActive(true)
	if self.m_ShouObj ~= nil then
		self.m_ShouObj:SetActive(false)
	end

	self.m_CardTrans.localPosition = Vector3.New(self.m_ParentX,self.m_ParentY,self.m_ParentZ)
	self.m_CardArraySps[1].transform.localPosition = self.m_FirstCardPos 
	self:FaPai(self.m_CardArraySps[pIndex],'green',self.m_Target.transform.localPosition.x,self.m_Target.transform.localPosition.y,0.2,0.2)
end


function this:ClearPais(  )
	-- print('clear pairs  ')
	self.m_FristCNum = -1 
	if self.m_ShouObj ~= nil then
		self.m_ShouObj.gameObject:SetActive(false)

	end
	self.m_CardTypeTrans.gameObject:SetActive(false)
	-- print('clear pairs end ')
end



function this:GetName( )
	return self.m_UserNickName1.text 
end
function this:SetNickname( )
	self.m_UserNickNameLab.text = '[FFFFFF]下注中...'
end

function this:SetBet(pSex,pUid,pFollowMoney,pJetton ,pZhuangTai,pBagMoney)
	-- print('set Bet ')
	this.m_AllFollowMoney = pFollowMoney
	self.m_CardScoreObj:SetActive(true)
	if self.m_BankerBgObj ~= nil then 
		-- if self.m_BankerSpObj:GetComponent('UISprite').fillAmount ~= 1 then
			self.m_BankerSpObj:GetComponent('UISprite').fillAmount =1
			self.m_BankerSpObj:GetComponent('UISprite').alpha =0
		-- end
	end
	local tClip
	if pZhuangTai == 2 then
		self.m_UserNickNameLab.text = '[3a5fcd]过牌'
		
		if self.m_Sex ==0 then
			tClip = ResManager:LoadAsset('gamenn/Sound','check_boy')
		else
			tClip = ResManager:LoadAsset('gamenn/Sound','check_girl')
		end
	elseif pZhuangTai == 3 then
		self.m_UserNickNameLab.text = '[00ff99]跟注'
		if self.m_Sex ==0 then
			tClip = ResManager:LoadAsset('gamenn/Sound','avatar6_call')
		else
			tClip = ResManager:LoadAsset('gamenn/Sound','avatar21_call')
		end
	elseif pZhuangTai == 4 then
		self.m_UserNickNameLab.text = '[FF4500]加注'
		if self.m_Sex ==0 then
			tClip = ResManager:LoadAsset('gamenn/Sound','raise_boy')
		else
			tClip = ResManager:LoadAsset('gamenn/Sound','raise_girl')
		end
	elseif pZhuangTai == 5 then
		self.m_UserNickNameLab.text = '[FF0000]All-in'
		if self.m_Sex ==0 then
			tClip = ResManager:LoadAsset('gamenn/Sound','allin_boy')
		else
			tClip = ResManager:LoadAsset('gamenn/Sound','allin_girl')
		end
	end
	if pZhuangTai ~= 2 then
		self.m_UserIntoMoneyLab.text = tostring(pBagMoney)
		local tChouMaCount = 0 
		if pJetton <= 100 and pJetton >0 then
			tChouMaCount = 2 
		elseif pJetton>100 and pJetton <=300 then
			tChouMaCount = 3 
		elseif pJetton > 300 then
			tChouMaCount = 4			
		end
		self.m_ChouMaCount = self.m_ChouMaCount + tChouMaCount
		local tTime = 0 
		local tV = 0
		local tSource = ResManager:LoadAsset('gamedzpk/chouma','Chouma')
		local tChip = ResManager:LoadAsset('gamenn/Sound','chip')
		for i =1 ,tChouMaCount do 
			local tTemp = tV
			local tNum = i 
			coroutine.start(function ()
				coroutine.wait(tTemp)
				tTime = tTemp
				local tCount = math.random(1,6)
				local tObj =GameObject.Instantiate(tSource)
				tObj.transform.parent = self.m_CardScoreObj.transform
				tObj.transform.localPosition = Vector3.New(self.m_BetTarge.localPosition.x,self.m_BetTarge.localPosition.y+5*tNum,0)
				tObj:GetComponent('UISprite').depth = tNum
				tObj:GetComponent('UISprite').spriteName = 'chouma_'..tCount
				tObj.transform.localScale = Vector3.one
				-- if tObj:GetComponent('TweenPosition') == nil then
				-- 	tObj:AddComponent(Type.GetType('TweenPosition',true))
				-- 	tObj:GetComponent('TweenPosition').from= tObj.transform.localPosition
					-- tObj:GetComponent('TweenPosition').to= Vector3.New(self.m_BetTarge.localPosition.x,self.m_BetTarge.localPosition.y+5*tNum,0)
				-- 	tObj:GetComponent('TweenPosition').duration = 0.25 
					local tTarget =  Vector3.New(self.m_BetChoumaSp.gameObject.transform.localPosition.x,self.m_BetChoumaSp.gameObject.transform.localPosition.y+5*tNum,0)
					iTween.MoveTo(tObj,iTween.Hash('position',tTarget,'time',0.23,'islocal',true))
					coroutine.wait(0.25)
					EginTools.PlayEffect(tChip)
				-- end

			end)
			tV = tV +0.1
		end

		coroutine.start(function (  )
			coroutine.wait(tTime+0.5)
			if self.m_BetLab.text ~= '' then
				local tBetMoney = tonumber(self.m_BetLab.text )
				local tMoneyAdd =   tBetMoney + pJetton
				if tMoneyAdd > 0 then
					self.m_BetLab.text = tMoneyAdd
				end 
			else
				if pJetton > 0 then
					self.m_BetLab.text = tostring(pJetton)
				end

			end

		end)
	end
	-- print('set bet end  ')
	return self.m_ChouMaCount*0.1*0.25
end

function this:SetChuShiMoney(pBagMoney,pChipMoney )
	pChipMoney = pChipMoney or 0 
	self.m_ActualDealMoney = pBagMoney + pChipMoney
end

function this:SetAutoUpdateBagMoney( pWinMoney )
	-- print('set SetAutoUpdateBageMoney ')
	if pWinMoney>0 then
		-- local tMoney = tonumber(self.m_UserBagmoneyActualLab.text)..pWinMoney
		self.m_UserBagmoneyActualNum  = self.m_UserBagmoneyActualNum + pWinMoney
		self.m_UserBagmoneyActualLab.text = self.m_UserBagmoneyActualNum 
	else
		self.m_ActualChangeMoney = tonumber(self.m_ActualDealMoney) - tonumber(self.m_UserIntoMoneyLab.text) 
		local tMoney = tonumber(self.m_UserBagmoneyActualNum) - self.m_ActualChangeMoney
		self.m_UserBagmoneyActualLab.text = tostring(tMoney)
	end
	-- print('SetAutoUpdateBageMoney  end ')
end



--change SetTimeMinus  TimeCountMinus PlayTime SetTime SetCancelTime TimeMinus

function this:SetCardShow()
	self.m_CardArraySps[1].spriteName = 'card_green'
	self.m_CardArraySps[2].spriteName = 'card_green'
	self.m_CardArraySps[1].alpha = 1 
	self.m_CardArraySps[2].alpha = 1 

end

function this:SetCardShowPoke( pUid,pCards)
	print('SetCardShowPoke')
	if #pCards > 1 then
		if tostring(pUid) ==tostring(EginUser.Instance.uid) then
			self.m_CardArraySps[5].alpha = 0 
		else
			self.m_CardArraySps[1].alpha = 0
			self.m_CardArraySps[2].alpha = 0
		end

		for i=1,#pCards do 
			self.m_CardArraySps[i+2].alpha = 1
			self.m_CardArraySps[i+2].spriteName = 'card_'..tostring(pCards[i])
		end
	end
end

function this:ChangePoKeValue( pHandCards )
	-- print('ChangePoKeValue  ')
	for i=1,pHandCards.Length do
		if tonumber(pHandCards[i])<=52 then 
			local tCardCount = pHandCards[i] +1 
			if tCardCount == 13 then
				tCardCount = 0 
			elseif tCardCount == 26 then
				tCardCount = 13
			elseif tCardCount == 39 then
				tCardCount= 26
			elseif tCardCount == 52 then
				tCardCount = 39		
			end
			pHandCards[i] = tCardCount
		end
	end
	-- print('ChangePoKeValue end  ')
end



function this:SetBanker(pIsShow )
	if self.m_BankerSpObj1 ~= nil then
		self.m_BankerSpObj1.gameObject:SetActive(pIsShow)
	end
end


function this:OnClickInfoDetail( )
	if self.m_InfoDetail.activeSelf == true then
		self.m_InfoDetail:SetActive(false)
		this.m_TimeLasted =0
	else
		self.m_InfoDetail:SetActive(true)
		self.m_DetailBagMoneyLab.text = self.m_UserIntoMoneyLab.text 
	end
end

function this:SetQi(pIsOwn)
	-- print('SetQi  ')
	local tClip 
	if self.m_Sex ==0 then
		tClip = ResManager:LoadAsset('gamenn/Sound','check_boy')
	else
		tClip = ResManager:LoadAsset('gamenn/Sound','check_girl')
	end
	self.m_SoundPlay = false 
	self.m_UserNickNameLab.text = '[ffffff]弃牌'
	self.m_UserAvatar.alpha = 0.3 

	self:SetCancelTime()
	-- if self.m_BankerSpObj ~= nil then
	-- 	self.m_BankerSpObj:GetComponent('UISprite').fillAmount = 1 
	-- 	self.m_BankerSpObj:GetComponent('UISprite').alpha = 0
	-- end 
	if pIsOwn then
		self.m_CardArrayPos1 = self.m_CardArraySps[1].transform.localPosition
		self.m_CardArrayPos2 = self.m_CardArraySps[2].transform.localPosition
		self:QiPai(self.m_CardArraySps[1],'green',self.m_Target.transform.localPosition.x-30,self.m_Target.transform.localPosition.y,1,0.2)
		self:QiPai(self.m_CardArraySps[2],'green',self.m_Target.transform.localPosition.x,self.m_Target.transform.localPosition.y,1,0.2)
		coroutine.start(function ( )
			coroutine.wait(1.3)
			self.m_CardArraySps[1].transform.localPosition = self.m_CardArrayPos1
			self.m_CardArraySps[2].transform.localPosition = self.m_CardArrayPos2
		end)
	else
		self.m_CardArraySps[5].transform:FindChild('Sprite_1'):GetComponent('UISprite').alpha = 0.5 
		self.m_CardArraySps[5].transform:FindChild('Sprite_2'):GetComponent('UISprite').alpha = 0.5
	end
	-- print('SetQi end  ')
end

function this:OnSendGift(pTarget)
	self.GiftFirstTime = Time.time 
	local tIndex = 0 
	local tTextNum = 1 
	local tOtherId = 1 
	-- local tLiPinPanel = find('GUI').transform.FindChild('Camera/GameDZPK/Content').gameObject
	--change 
	-- print('------------------on send gift -----------------------')
	-- print(GameDZPK:BackIsContain())
	local tMessageError = GameDZPK:ReturnMessageError()
	local tEndTime = GameDZPK:GetEndTime()
	if  GameDZPK:BackIsContain() then
		if self.GiftFirstTime - tEndTime < 5 then
			tMessageError:SetActive(true)
			tMessageError.transform:FindChild('Label'):GetComponent('UILabel').text = '操作过于频繁，请稍后发送'
			coroutine.start(function ( )
				coroutine.wait(1.5)
				tMessageError:SetActive(false)
			end)
		else
			for i=1,8 do 
				if pTarget == self.m_SendGiftParent.transform:FindChild('liwu_'..i).gameObject then
					tIndex = i + 25 
					tOtherId = self.MyID
					break
				end
			end
			print('Other  id   ===  '.. self.MyID)
			local tSendMsg = {}
			tSendMsg['otherid'] = tostring(tOtherId)
			tSendMsg['pid'] = tIndex
			tSendMsg['num'] = tTextNum
			local tOther = {}
			tOther['type'] = 'game'
			tOther['tag'] = 'props'
			tOther['body'] = tSendMsg 
			GameDZPK.mono:SendPackage(cjson.encode(tOther))
		end
	else
		tMessageError:SetActive(true)
		tMessageError.transform:FindChild('Label'):GetComponent('UILabel').text = '还未开始游戏，无法互送道具'
		coroutine.start(function (  )
			coroutine.wait(1.5)
			tMessageError:SetActive(false)
		end)
		
	end
	self.m_UserInfo:SetActive(false)
end

function this:SetBagMoney(pCostMoney )
	self.m_UserBagmoneyActualNum =self.m_UserBagmoneyActualNum  - pCostMoney
	self.m_UserBagmoneyActualLab.text = tostring(self.m_UserBagmoneyActualNum)
	self.m_UserInfoMoney.text = self.m_UserBagmoneyActualNum
end

this.EmotionPos = {
	Vector3.New(-5, 0, 0),
	Vector3.New(-5, 7, 0),
	Vector3.New(0, 15, 0),
	Vector3.New(-2, 7, 0),
	Vector3.New(4, 12, 0),
	Vector3.New(-5, 1, 0),
	Vector3.New(17, 15, 0),
	Vector3.New(-3, 27, 0),
	Vector3.New(0, 12, 0),
	Vector3.New(-31, 0, 0),
	Vector3.New(0, -28, 0),
	Vector3.New(-6, 3, 0),
	Vector3.New(0, 15, 0),
	Vector3.New(0, -20, 0),
	Vector3.New(-3, 0, 0),
	Vector3.New(0, 9, 0),
	Vector3.New(15, 15, 0),
	Vector3.New(0, -5, 0),
	Vector3.New(25, 0, 0),
	Vector3.New(-13, 21, 0),
}

function this:SetEmotion(pNum)
	-- print('set emotion')
	local tResouse = ResManager:LoadAsset('expressionpackage/biaoqing_'..pNum,'biaoqing_'..pNum)
	local tPrefab = GameObject.Instantiate(tResouse)
	tPrefab.transform.parent = self.m_EmotionParent
	tPrefab.transform.localScale = Vector3.one
	if this.EmotionPos[pNum] == nil then
		tPrefab.transform.localPosition = Vector3.zero
	else
		tPrefab.transform.localPosition = this.EmotionPos[pNum]
	end
	coroutine.start(function ( )
		coroutine.wait(1.25)
		destroy(tPrefab)
	end)
end

function this:SetPublicCards(pStep,pCards )
	-- print('SetPublicCards')
	if pStep == 1 then
		local tV = 0.3 
		for i=1,#pCards do 
			local tNum = i
			local tTemp = tV
			coroutine.start(function ()
				coroutine.wait(tTemp)
				self:FaPai(self.m_PublicCardsArray[tNum],tostring(pCards[i]),self.m_PublicTarget.localPosition.x,self.m_PublicTarget.localPosition.y,0.3,0.2)
			
			end)			
			tV = tV +0.3
		end
	elseif pStep ==2 then
		self:FaPai(self.m_PublicCardsArray[4],tostring(pCards[1]),self.m_PublicTarget.localPosition.x,self.m_PublicTarget.localPosition.y,0.3,0.2)
	elseif pStep == 3 then 
		self:FaPai(self.m_PublicCardsArray[5],tostring(pCards[1]),self.m_PublicTarget.localPosition.x,self.m_PublicTarget.localPosition.y,0.3,0.2)
	elseif pStep ==4 then
		local tV = 0.3
		if #pCards ==2 then
			for i=1,#pCards do 
				local tNum = i 
				local tTemp = tV
				coroutine.start(function ()
					coroutine.wait(tTemp)
					self:FaPai(self.m_PublicCardsArray[tNum + 3],tostring(pCards[i]),self.m_PublicTarget.localPosition.x,self.m_PublicTarget.localPosition.y,0.3,0.2)
				end)
				tV = tV +0.3
			end
		elseif  #pCards ==1 then 
			self:FaPai(self.m_PublicCardsArray[5],tostring(pCards[1]),self.m_PublicTarget.localPosition.x,self.m_PublicTarget.localPosition.y,0.3,0.2)
		elseif #pCards ==5 then
			for i=1,#pCards do 
				local tNum = i 
				local tTemp = tV
				coroutine.start(function ()
					coroutine.wait(tTemp)
					self:FaPai(self.m_PublicCardsArray[tNum],tostring(pCards[i]),self.m_PublicTarget.localPosition.x,self.m_PublicTarget.localPosition.y,0.3,0.2)
				end)
				tV = tV +0.3
			end
		end
	end
	-- print('SetPublicCards  end   ')
end

function this:SetPublicCardsStep(pStep,pCards )
	for i =1,#pCards do 
		self.m_PublicCardsArray[i].alpha =1 
		self.m_PublicCardsArray[i].spriteName = 'card_'..tostring(pCards[i])
	end
end

function this:SetOwnCardsStep( pCards )
	-- print('SetOwnCardsStep     ')
	if #pCards > 0 then
		self.m_CardArraySps[5].alpha = 1 
		self.m_CardArraySps[1].alpha =0 
		self.m_CardArraySps[2].alpha =0 
		local tCard1 = self.m_CardArraySps[5].transform:FindChild('Sprite_left'):GetComponent('UISprite')
		local tCard2 = self.m_CardArraySps[5].transform:FindChild('Sprite_right'):GetComponent('UISprite')
		tCard1.spriteName = 'card_'..tostring(pCards[1])
		tCard2.spriteName = 'card_'..tostring(pCards[2])
		self.m_CardArraySps[5].transform:FindChild('Sprite_1'):GetComponent('UISprite').alpha = 0 
		self.m_CardArraySps[5].transform:FindChild('Sprite_2'):GetComponent('UISprite').alpha = 0 
		print('SetOwnCardsStep   end   ')	
	end
	
end

 function this:SetBankerOne(pIsShow)
 	if self.m_BankerSpObj ~= nil then
 		self.m_BankerSpObj:SetActive(pIsShow)
 	end
 end

function this:HidePublicCards( )
	for i=1,#self.m_PublicCardsArray do
		self.m_PublicCardsArray[i].alpha = 0
		self.m_PublicCardsArray[i].transform:FindChild('Kuang'):GetComponent('UISprite').alpha = 0 
		self.m_PublicCardsArray[i].transform.localPosition = Vector3.New(self.m_PublicCardsArray[i].transform.localPosition.x,self.m_PublicCardsPos.y,self.m_PublicCardsArray[i].transform.localPosition.z)
	end
end

function this:XunHuan( )
	for i=1,self.m_PublicCardsArray.Length do 
		self.m_PublicCardsArray[i].transform:FindChild('Kuang'):GetComponent('UISprite').alpha = 0 
	end
end

function this:HideOwnPoke(  )
	for i=1,4 do 
		self.m_CardArraySps[i].alpha = 0
	end
end

function this:SetStartChip( pParent,pJetton)
	-- print('SetStartChip     ')
	local tSp = pParent:GetComponentsInChildren(Type.GetType('UISprite',true))
	if tSp.Length>1 then
		for k,v in pairs(tSp) do 
			if v.name ~= 'Spite_bg' and v.name  ~= 'Sprite_bg_target' then
				destroy(v.gameObject)
			end
		end
	end
	if pJetton > 0 then
		local tSource = ResManager:LoadAsset('gamedzpk/jettonPre','JettonPre')
		EginTools.AddNumberSpritesCenter(tSource,pParent.transform,'plus_',0.8)
	end
end

function this:DestroyBetChouma(  )
	self.m_BetLab.text = ''
	self.m_ChouMaCount =0
	local tList = {}
	local tSp = self.m_CardScoreObj:GetComponentsInChildren(Type.GetType('UISprite',true))
	if tSp.Length >1 then
		for i=0,tSp.Length-1 do 
			if tSp[i].gameObject.name == 'chouma(Clone)'  then
				table.insert(tList,tSp[i].gameObject)
			end
		end
	end
	-- tList
	local tX = math.random(-25,25)
	local tY = math.random(-10,10)
	coroutine.start(function ()
		coroutine.wait(0.3)
		local tClip = ResManager:LoadAsset('gamenn/Sound','hechip')
		EginTools.PlayEffect(tClip)
		local tV = 0.08
		for i=1,#tList do 
			local tTemp = tV
			local tNum = i 
			coroutine.wait(0.05)
			local tPos = self.m_ChouMaHuiShou.transform.localPosition + Vector3.New(tX,tY,0)
			iTween.MoveTo(tList[i].gameObject,iTween.Hash('position',tPos,'time',0.4,'easytype',iTween.EaseType.linear,'islocal',true))
			coroutine.start(function (  )
				coroutine.wait(0.25)
				destroy(tList[i])
			end)			
		end
	end)
end

function this:SetWait( pShow )
	self.m_UserNickNameLab.text = '[FFFFFF]等待下一局'
	self.m_UserAvatar.alpha = 0.3
end

function this:FaPai( pSp,pPai,pX,pY,pTime,pDelay )
	coroutine.start(function (  )
		coroutine.wait(pDelay)
		UISoundManager.Instance:PlaySound('fapaia')
		pSp.spriteName = this.m_CardPreStr..pPai
		pSp.alpha = 1 
		local tPos = pSp.transform.localPosition
		pSp.gameObject.transform.localPosition = Vector3.New(pX,pY,0)

		iTween.MoveTo(pSp.gameObject,iTween.Hash('position',tPos,'time',pTime,'islocal',true))
	end)
end


function this:QiPai( pSp,pPai,pX,pY,pTime,pDelay)
	-- print(' this qiPai     ')
	coroutine.start(function ()
		coroutine.wait(pDelay)
		local tClip = ResManager:LoadAsset('gamenn/Sound','soundsend')
		if tClip ~= nil then
			EginTools.PlayEffect(tClip)
		end
		pSp.spriteName = this.m_CardPreStr..pPai
		if pSp:GetComponent('TweenAlpha') ~= nil then
			pSp:GetComponent('TweenAlpha').enabled = false 
		end
		pSp.alpha = 1 
		iTween.MoveTo(pSp.gameObject,iTween.Hash('position',Vector3.New(pX,pY,0),'time',pTime,'islocal',true))
		local tAlpha = 1 
		while( tAlpha>0) do
			tAlpha = tAlpha - 0.1
			pSp.alpha = tAlpha 
			coroutine.wait(pTime/10)
		end

		-- if pSp:GetComponent('TweenAlpha') == nil then
		-- 	pSp.gameObject:AddComponent(Type.GetType('TweenAlpha',true))
		-- 	pSp:GetComponent('TweenAlpha').from = 1
		-- 	pSp:GetComponent('TweenAlpha').to = 0 
		-- 	pSp:GetComponent('TweenAlpha').duration = pTime
		-- end
		-- coroutine.wait(pTime)

		-- destroy(pSp:GetComponent('TweenAlpha'))
		-- pSp:GetComponent('TweenAlpha').enabled =false
	end)
end

function this:SetBetInfo( pName )
	self.m_UserNickNameLab.text = pName
end
function this:SetStartInfo( pMoney)
	self.m_UserIntoMoneyLab.text = tostring(pMoney)
	self.m_UserAvatar.alpha = 1 
end

function this:SetStartInfoName( )
	self.m_UserNickNameLab.text = self.m_UserNickName1.text 
	if string.len(self.m_UserNickNameLab.text) >4 then
		self.m_UserNickNameLab.text = string.sub( self.m_UserNickNameLab.text,0,4 )..'...'
	end 
end

function this:PlayerInfoShow(  )
	-- print(' this PlayerInfoShow     ')
	self.m_UserInfo:SetActive(true)
	self.m_UserInfoID.text = self.MyID 
	self.m_UserInfoName.text = tostring(self.m_UserNickName1.text) 
	self.m_UserInfoMoney.text = '$'..self.m_UserBagmoneyActualNum
	self.m_UserInfoAvatar.spriteName = self.m_UserAvatar.spriteName 
	self.m_HuDongBtn.spriteName = 'interact_click'
	self.m_PaiJiBtn.spriteName = 'info_card'
	self.m_SendGiftParent:SetActive(true)
	self.m_PaiJiXin:SetActive(false)
	-- print(' this PlayerInfoShow   end    ')
end

function this:LiPinShow( )
	-- local tLiPinPanel = find('Camera').transform:FindChild('GameDZPK/Content').gameObject
	local tParent = self.transform.parent
	local tObj = tParent.transform:FindChild('xiedaidaoju').gameObject
	tObj.gameObject:SetActive(true)
	GameDZPK:ChuShiDaoJu()
	GameDZPK:SetPresentUid(self.MyID)
	-- self.MyID 
end

function this:Close( )
	self.m_UserInfo:SetActive(false)
end


function this:SetCardAnimation( pMyCard)
	-- print(' this SetCardAnimation====================')
	self.m_CardArraySps[1].alpha =0 
	self.m_CardArraySps[2].alpha = 0 
	local tCard1 = self.m_CardArraySps[5].transform:FindChild('Sprite_left'):GetComponent('UISprite')
	local tCard2 = self.m_CardArraySps[5].transform:FindChild('Sprite_right'):GetComponent('UISprite')
	tCard1.spriteName = 'card_'..tostring(pMyCard[1])
	tCard2.spriteName = 'card_'..tostring(pMyCard[2])
	self.m_CardArraySps[5].transform:FindChild('Sprite_1'):GetComponent('UISprite').alpha = 0 
	self.m_CardArraySps[5].transform:FindChild('Sprite_2'):GetComponent('UISprite').alpha = 0 
	coroutine.start(function (  )
		coroutine.wait(0.2)
		local tObj = ResManager:LoadAsset('gamedzpk/ownpokeanimation','OwnPokeAnimation')
		if tObj ~= nil then 
			tObj = GameObject.Instantiate(tObj)
			tObj.transform.parent = self.m_CardAnimationParent.transform
			tObj.transform.localScale  = Vector3.one 
			tObj.transform.localPosition = Vector3.zero
			coroutine.wait(0.3)
			destroy(tObj)
		end
		self.m_CardArraySps[5].alpha  =1 
	end)
	-- print(' this SetCardAnimation  end    ')
end

function this:SetGameOverNext( pUid,pWinMoney,pHandType,pCards )
	-- print('game over next ')
	self.m_CardTypeTrans.gameObject:SetActive(true)
	local tCardTypeSprite = self.m_CardTypeTrans:GetComponentInChildren(Type.GetType('UISprite',true))
	if tostring(pUid) == tostring(EginUser.Instance.uid) then
		tCardTypeSprite.spriteName = 'own_'..pHandType
	else
		tCardTypeSprite.spriteName = 'other_'..pHandType
	end
	if tonumber(pWinMoney) >0 then
		self.m_WinTeXiao.gameObject:SetActive(true)
		self.m_WinRoate.gameObject:SetActive(true)
	end
	self:SetCardShowPoke(pUid,pCards)
	-- print('game over next  enddddd')
end

function this:SetGameOver( pUid,pWinChip,pWinMoney,pHandType, pCards,pHandCards)
	-- print('  SetGameOver     ')
	if tostring(pUid) == tostring(EginUser.Instance.uid)then
		if pWinMoney >0 then
			self.m_YouWin:SetActive(true)
		end
	end
	local tZhanPai1 = false 
	local tZhanPai2 = false 
	if #pHandCards>1 then
		for i=1,#pHandCards do 
			local tCardSpriteName = 'card_'..pHandCards[i]
			if self.m_CardArraySps[3].spriteName == tCardSpriteName then
				tZhanPai1 = true 
			end
			if tZhanPai1 == true then
				self.m_CardArraySps[3].gameObject.transform:FindChild('Kuang'):GetComponent('UISprite').alpha = 0 
			else
				self.m_CardArraySps[3].gameObject.transform:FindChild('Kuang'):GetComponent('UISprite').alpha = 0.7 
			end
			if self.m_CardArraySps[4].spriteName == tCardSpriteName then
				tZhanPai2 = true  
			end
			if tZhanPai2 == true then
				self.m_CardArraySps[4].gameObject.transform:FindChild('Kuang'):GetComponent('UISprite').alpha = 0 
			else
				self.m_CardArraySps[4].gameObject.transform:FindChild('Kuang'):GetComponent('UISprite').alpha = 0.7 
			end
		end
	end
	-- print('  SetGameOver   end   ')
end

function this:SetGameOverTiGao(pWinMoney,pHandType,pHandCards,pChouMaNum )
	-- print('  SetGameOverTiGao     ')
	for i=1,#self.m_PublicCardsArray do 
		self.m_PublicCardsArray[i].transform:FindChild('Kuang'):GetComponent('UISprite').alpha = 0
		self.m_PublicCardsArray[i].transform.localPosition = Vector3.New(self.m_PublicCardsArray[i].transform.localPosition.x,self.m_PublicCardsPos.y,self.m_PublicCardsArray[i].transform.localPosition.z)
	end
	if #pHandCards > 1 then
		for i=1,#pHandCards do 
			local tSN  = 'card_'..pHandCards[i]
			for j=1 ,#self.m_PublicCardsArray do 
				if self.m_PublicCardsArray[j].spriteName == tSN then
					self.m_PublicCardsArray[j].transform:FindChild('Kuang'):GetComponent('UISprite').alpha = 1
					self.m_PublicCardsArray[j].transform.localPosition = self.m_PublicCardsArray[j].transform.localPosition + Vector3.up*20
				end
			end
		end
	end
	local tClip 
	if pWinMoney >0 then
		if #pHandCards <6 then
			if pWinMoney < 10000 then
				tClip = ResManager:LoadAsset('gamenn/Sound','ying')
				-- UISoundManager.Instance:PlaySound('ying')
			else
				tClip = ResManager:LoadAsset('gamenn/Sound','bigying')
				-- UISoundManager.Instance:PlaySound('bigying')
			end
		end
		EginTools.PlayEffect(tClip)
		if pHandType > 5 then
			if pHandType == 6 then 
				tClip = ResManager:LoadAsset('gamenn/Sound','cardtype_hulu')
			elseif pHandType == 7 then
				tClip = ResManager:LoadAsset('gamenn/Sound','cardtype_huangjiatonghua')
			elseif pHandCards == 8 then
					tClip = ResManager:LoadAsset('gamenn/Sound','pineapple_card_succ')
			elseif pHandCards ==9 then
					tClip = ResManager:LoadAsset('gamenn/Sound','pineapple_win')
			end
			EginTools.PlayEffect(tClip)
			local tObj = ResManager:LoadAsset('gamedzpk','specialtype')
			tObj.transform.parent = self.m_SpecialCardType.transform
			tObj.transform.localPosition = Vector3.zero
			tObj.transform.localScale = Vector3.one
			coroutine.start(function ( )
				coroutine.wait(1.4)
				destroy(tObj)
			end)
		end
	end
end


function this:SetGameOverJinQian(pUid,pWinMoney,pChouMaNum,pWinChip,pXiaZhuMoney)
	local tTime = 0.3 + 0.08 * pChouMaNum
	local tNewPos = self.m_WinBetLab.gameObject.transform.localPosition
	coroutine.start(function ( )
		self.m_WinBetLab.text = '+'..(pWinMoney+pXiaZhuMoney)
		self.m_UserIntoMoneyLab.text =tostring(self.m_ActualDealMoney+pWinMoney)
		if self.m_WinBetLab:GetComponent('TweenPosition') ~= nil then 
			self.m_WinBetLab:GetComponent('TweenPosition').enabled = false
		end 
		iTween.MoveTo(self.m_WinBetLab.gameObject,iTween.Hash('position',self.m_jinQianPos.localPosition,'time',0.5,'islocal',true))
		coroutine.wait(1)
		self.m_WinBetLab.text = ''
		self.m_WinBetLab.gameObject.transform.localPosition = tNewPos
	end)	
end


function this:DoClear( )
	self.m_CardTypeTrans.gameObject:SetActive(false)
	self.m_WinTeXiao.gameObject:SetActive(false)
	self.m_WinRoate.gameObject:SetActive(false)
	if self.m_YouWin~= nil and self.m_YouWin.gameObject.activeSelf then
		self.m_YouWin:SetActive(false)
	end
	self.m_CardArraySps[5].alpha = 0
end

function this:OnButtonClick(pTarget )
	if pTarget == self.m_HuDongBtn.gameObject then
		self.m_SendGiftParent:SetActive(true )
		self.m_PaiJiXin:SetActive(false)
		self.m_HuDongBtn.spriteName = 'interact_click'
		self.m_PaiJiBtn.spriteName = 'info_card'
	elseif pTarget == self.m_PaiJiBtn.gameObject then
		self.m_SendGiftParent:SetActive(false )
		self.m_PaiJiXin:SetActive(true)
		self.m_HuDongBtn.spriteName = 'interact'
		self.m_PaiJiBtn.spriteName = 'info_card_click'
	end

end

function this:SetTimeMinus(  )
	local tClip = ResManager:LoadAsset('gamenn/Sound','playtime')
	coroutine.start(function ()
		while( self.m_Time  > 0 ) do 	
			self.m_Time  = self.m_Time -1
			if self.m_Time <=5 then 
				if tClip ~= nil then 
					EginTools.PlayEffect(tClip)
				end
			end
		end
	end)
end

function this:SetCancelTime()
	self.m_PlaySound = false  
	if self.m_BankerSpObj ~= nil then
		self.m_BankerSpObj.transform:GetComponent('UISprite').fillAmount =1
		self.m_BankerSpObj.transform:GetComponent('UISprite').alpha =0
	end
	self.m_Count  =0 
end

function this:SetTime( )
	-- print('  set time      ')
	self.m_Time = 15 
	self.m_Count = 1
	local tSp = nil 
	if self.m_BankerSpObj then
		tSp = self.m_BankerSpObj:GetComponent('UISprite')
		tSp.fillAmount =self.m_Count 
		tSp.alpha =1
	end
	local tClip = ResManager:LoadAsset('gamenn/Sound','half_time')
	coroutine.start(function ()
		while(self.m_Count  <= 1 and self.m_Count  >= 0 ) do 	
			self.m_Count  = self.m_Count  - 0.0067
			if tSp ~= nil  and self.m_BankerSpObj ~= nil  then

				tSp.fillAmount  = self.m_Count 
			else
				break;
			end
			if self.m_Count  <=0.5 and self.m_PlaySound ==true then
				self.m_PlaySound = false 
				EginTools.PlayEffect(tClip)
			end
			coroutine.wait(0.1)
		end
	end)
	-- print('  set time end    ')
end

function this:SetPaiJiMessage( pRoundNum,pWinNum,pLoseNum,pWinRate,pMaxWinMoney,pMaxCardType,pMaxCard )
		-- print('set pai ji message ')
	if self.m_ZhongPaiJu ~= nil then
		self.m_ZhongPaiJu.text = tostring(pRoundNum)..'局'
	end
	if self.m_ShengFu ~= nil then
		self.m_ShengFu.text = tostring(pWinNum)..'胜/'..tostring(pLoseNum)..'负'
	end
	if self.m_ShengLv ~= nil then
		self.m_ShengLv.text = tostring(pWinRate)..'%'
	end
	if self.m_ZuiDaYingQu ~= nil then
		self.m_ZuiDaYingQu.text = tostring(pMaxWinMoney)
	end

	for i=1 ,#pMaxCard do 
		local tCardCountT = tonumber(pMaxCard[i])/13
		if self.m_ZuiDaCardType[i] ~= nil then
			self.m_ZuiDaCardType[i].spriteName = 'type_'..math.floor((tCardCountT +1))
		end
		local pCardC = tonumber( pMaxCard[i]) %13
		if pCardC <=8 then
			self.m_ZuiDaCard[i].text = tostring(pCardC+2)
		elseif pCardC ==9 then
			self.m_ZuiDaCard[i].text = 'J'
		elseif pCardC ==9 then
			self.m_ZuiDaCard[i].text = 'Q'
		elseif pCardC ==9 then
			self.m_ZuiDaCard[i].text = 'K'
		elseif pCardC ==9 then
			self.m_ZuiDaCard[i].text = 'A'
		end
	end
	-- print('set pai ji message end  ')
end

this.LebPos = {
	Vector3.New(20,-10,0),
	Vector3.New(30,-15,0),
	Vector3.New(20,20,0),
	Vector3.New(-20,20,0),
	Vector3.New(-40,-15,0),
	Vector3.New(-20,-10,0),
}
this.m_BetTargePos = {
	Vector3.New(539,969,0),
	Vector3.New(1052,431,0),
	Vector3.New(534,-114,0),
	Vector3.New(-736 ,-113,0),
	Vector3.New(-1272,430 ,0),
	Vector3.New(-736,969 ,0),
}
this.m_BetChouMaPos = {
	Vector3.New(0,-10.6,0),
	Vector3.New(10,-15,0),
	Vector3.New(0,20,0),
	Vector3.New(0,20,0),
	Vector3.New(-20,-15,0),
	Vector3.New(0,-11,0),
}
this.m_BGTarge = {
	Vector3.New(319,201,0),
	Vector3.New(425,85,0),
	Vector3.New(319,13,0),
	Vector3.New(-295,12,0),
	Vector3.New(-431,84,0),
	Vector3.New(-296,201,0),
}

this.m_ScorePos = {
	Vector3.New(13,97,0),
	Vector3.New(107,0,0),
	Vector3.New(13,-145,0),
	Vector3.New(-27,-145,0),
	Vector3.New(-101,0,0),
	Vector3.New(-27,97,0),
}
this.WinBetPos = {
	Vector3.New(-17,-55,0),
	Vector3.New(-112,40,0),
	Vector3.New(-15,187,0),
	Vector3.New(23,187,0),
	Vector3.New(97,40,0),
	Vector3.New(23,-56,0),
}
this.SelfPos = {
	Vector3.New(-14,-98,0),
	Vector3.New(-107,40,0),
	Vector3.New(-13,145,0),
	Vector3.New(23,187,0),
	Vector3.New(97,40,0),
	Vector3.New(23,-56,0),
}

this.MyDetailPos = { 
	Vector3.New(328,196.4,0),
	Vector3.New(533,-20,0),
	Vector3.New(328,-237,0),
	Vector3.New(-328,-237,0),
	Vector3.New(-536,-20,0),
	Vector3.New(-328,196,0),
}

function this:SetCardTarget(tIndex,pPos)
	tIndex = tIndex -1
	if tIndex <=3 then
		self.m_CardTrans.localPosition = Vector3.New(112,-9,0)
		self.m_CardArraySps[1].gameObject.transform.localPosition = Vector3.New(-110,0,0) 
		self.m_CardArraySps[2].gameObject.transform.localPosition = Vector3.New(-75,0,0) 
		self.m_CardArraySps[3].gameObject.transform.localPosition = Vector3.New(-315,17,0) 
		self.m_CardArraySps[4].gameObject.transform.localPosition = Vector3.New(-240,17,0) 
		self.m_LiPinBtn.transform.localPosition = Vector3.left *60
		self.m_LiPinBtn1.transform.localPosition = Vector3.left *60
		
	else
		self.m_CardTrans.localPosition = Vector3.New(-33,-9,0)
		self.m_CardArraySps[1].gameObject.transform.localPosition = Vector3.New(-80,0,0) 
		self.m_CardArraySps[2].gameObject.transform.localPosition = Vector3.New(-50,0,0) 
		self.m_CardArraySps[3].gameObject.transform.localPosition = Vector3.New(55,17,0) 
		self.m_CardArraySps[4].gameObject.transform.localPosition = Vector3.New(120,17,0) 
		self.m_LiPinBtn.transform.localPosition = Vector3.right *60
		self.m_LiPinBtn1.transform.localPosition = Vector3.right *60
		self.m_BetLab.pivot = UIWidget.Pivot.Right
	end
	self.m_ParentX = self.m_CardTrans.localPosition.x
	self.m_ParentY = self.m_CardTrans.localPosition.y
	self.m_ParentZ = self.m_CardTrans.localPosition.z
	self.m_Target.transform.localPosition =  this.m_BetTargePos[tIndex] 
	-- self.m_BetTarge.transform.localPosition =    self.m_WinBetLab.gameObject.transform.localPosition 
	self.m_BetTarge.transform.localPosition = this.m_ScorePos[tIndex]*(-1) 	
	self.m_BetLab.transform.localPosition = this.LebPos[tIndex]
	self.m_BetChoumaSp.gameObject.transform.localPosition = this.m_BetChouMaPos[tIndex]
	self.m_ChouMaHuiShou.gameObject.transform.localPosition = this.m_BGTarge[tIndex]
	self.m_CardScoreObj.transform.localPosition = this.m_ScorePos[tIndex]
	self.m_WinBetLab.gameObject.transform.localPosition = this.WinBetPos[tIndex]
	self.m_jinQianPos.localPosition = this.WinBetPos[tIndex] + Vector3.up*40
	self.m_UserInfo.transform.localPosition = this.MyDetailPos[tIndex]
end


function this:UpdateInLua()
  if IsNil(self.m_InfoDetail) == false then
    if  self.m_InfoDetail.activeSelf == true then
      self.m_TimeLasted = self.m_TimeLasted + 0.5 --Time.deltaTime
      if self.m_TimeLasted>= this.m_TimeInterval then
    	self.m_InfoDetail:SetActive(false)
        self.m_TimeLasted = 0
      end
    end
  end
end

function this:OnDestroy(  )
	self:clearLuaValue()
end

function this:GetSex( )
	return self.m_Sex 
end
function this:SetPresentObjAct( pIsAct)
	self.m_LiPinSp.gameObject:SetActive(pIsAct)
end

function this:SetBagMone( pMoney )
	pMoney = pMoney or '0'
	self.m_UserBagmoneyActualLab.text = tostring(pMoney)
end
