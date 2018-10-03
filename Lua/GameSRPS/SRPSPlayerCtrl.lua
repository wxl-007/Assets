local this = LuaObject:New()
SRPSPlayerCtrl = this

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
this.SendPos = Vector3.New(144)

function this:clearLuaValue(  )
  self.gameObject= nil 
  self.transform = nil 

  self.m_ReadyObj  =nil           --提示字“准备”
  self.m_ShowObj   =nil           --提示字 攤牌
  self.m_CallBankerObj  =nil       --提示字 叫庒中
  self.m_WaitObj        =nil      -- 提示字 等待中
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
  
  self.m_JettonObj=nil
  self.m_InfoDetail=nil
  self.m_DetailNickNameLab=nil
  self.m_DetailLevelLab=nil
  self.m_DetailBagMoneyLab=nil

  self.m_TimeLasted =0

  self.m_SoundSend=nil
  self.m_CardScoreV=nil
  self.m_CardTypeV=nil
  self.m_ShopV=nil
  self.m_CallBankerV=nil
  self.m_InfoDetailV =nil
  self.m_ChouMaGroup = nil 
end


function this:init( )
  print(' SRPS player ctrl init ')
  this.m_TimeLasted =0
  self.m_CardTrans = self.transform:FindChild('Output/Cards')
  self.m_CardTypeTrans = self.transform:FindChild('Output/CardType')
  self.m_Type =self.m_CardTypeTrans:FindChild('CardTypeSp')
  self.m_NiuNiuAni = self.m_CardTypeTrans:FindChild('niuniuType')
  self.m_NiuAni = self.m_CardTypeTrans:FindChild('niuType')

  self.m_CardScoreObj = self.transform:FindChild("Output/CardScore").gameObject
  self.m_CardScoreSp = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
  self.m_InfoDetail = nil 
  self.m_CloseingObj = self.transform:FindChild('Output/CardClosing').gameObject 
  self.m_UserchipBtns = nil  
  
  self.m_NewCardTransform =nil 
  self.m_JettonObjs = {} 
  self.m_CardArraySps = {}
  self.m_UserChipTrans = nil
  self.m_MessageBg = self.transform:FindChild('Output/messages_bg').gameObject
  self.m_MessageLab = self.transform:FindChild('Output/messages_bg/messages'):GetComponent('UILabel')
  self.m_Sex = 0 --男人 1 女人

  if self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) then
    self.m_ShowObj = self.transform:FindChild("Output/Sprite_show").gameObject
    self.m_InfoDetail  = self.transform:FindChild("PlayerInfo/Info_detail").gameObject
    self.m_ReadyObj  = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_ready").gameObject
    self.m_WaitObj    = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_waitting").gameObject
    self.m_UserAvatar = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
    self.m_UserNickNameLab  = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel");
    self.m_UserIntoMoneyLab = self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");
    self.m_DetailNickNameLab  = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");   
    self.m_DetailLevelLab =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
    self.m_DetailBagMoneyLab  =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");
    self.m_UserchipBtns = self.transform:FindChild('Output/ChooseChips').gameObject   	--是下注的实体
    self.m_BankerBgObj  = self.transform:FindChild("PlayerInfo/Sprite_headframe_banker").gameObject
    self.m_BankerSpObj  = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject
    self.m_CallBankerObj  = self.transform:FindChild("Output/Sprite_callBanker").gameObject
  	for i=0,self.m_CardTrans.childCount-1  do
	    local card = self.m_CardTrans:GetChild(i).gameObject;
	    if card.name == "Sprite" then
	      table.insert(self.m_CardArraySps,card:GetComponent("UISprite"));  
	    end
  	end
  	 self.m_DetailPlayerNameLab  = self.transform:FindChild("PlayerInfo/Info_detail/nickname").gameObject:GetComponent("UILabel")  
  	local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject
    GameSRPS.mono:AddClick(btn_Avatar,function ( )
    	self:OnClickInfoDetail()
    end)
    --玩家处生成筹码
    self.m_OtherChipTrans = self.transform:FindChild('PlayerInfo/OtherRandomChipTransform')
 	self.m_EmotionPos = self.transform:FindChild('PlayerInfo/Panel_Head/Sprite (avatar_6)').gameObject
  else
    self.m_ReadyObj   = self.transform:FindChild("Output/Sprite_ready").gameObject
    self.m_UserchipBtns = self.transform:FindChild('ChooseChips').gameObject    	--下注按钮父物体
    --下注地址
    
   	self.m_BankerSpObj  = self.transform:FindChild('Output/banker').gameObject
    self.m_UserchipBtns:GetComponent('UIAnchor').relativeOffset = Vector2.New(0.13,-0.32)
    local tParent  = find('SRPSFootInfo(Clone)')
    self.m_InfoDetail  = tParent.transform:FindChild('Panel_info/Foot - Anchor/Info/Info_detail').gameObject
	for i=0,self.m_CardTrans.childCount-1  do
	    local tCard = self.m_CardTrans:FindChild('Sprite'..tostring(i)).gameObject
	    if tCard ~= nil then
	      table.insert(self.m_CardArraySps,tCard:GetComponent("UISprite"));  
	    end
  	end

  	local btn_Avatar = tParent.transform:FindChild("Panel_info/Foot - Anchor/Info/Sprite_Avatar").gameObject
   	self.m_UserAvatar = btn_Avatar.transform:GetComponent('UISprite')
    GameSRPS.mono:AddClick(btn_Avatar,function ( )
    	self:OnClickInfoDetail()
    end)
  	self.m_NewCardTransform = self.transform.parent.parent:FindChild('Panel_background/Sprite_menu/Lishi/lishiTransform')
  	--玩家处生成筹码
  	self.m_OtherChipTrans = self.transform:FindChild('RandomChipTransform')
  	self.m_EmotionPos = self.transform:FindChild('UserChiptransform').gameObject
  	self.m_UserNickNameLab  = tParent.transform:FindChild("Panel_info/Foot - Anchor/Info/Label_Nickname").gameObject:GetComponent("UILabel")
  	self.m_DetailBagMoneyLab  =   self.m_InfoDetail.transform:FindChild("Label3/BagMoney").gameObject:GetComponent("UILabel")
    self.m_DetailNickNameLab  = self.m_InfoDetail.transform:FindChild("Label1/Nickname").gameObject:GetComponent("UILabel")
    self.m_UserIntoMoneyLab = tParent.transform:FindChild("Panel_info/Foot - Anchor/Info/Money/Label_Bagmoney").gameObject:GetComponent("UILabel")
    self.m_DetailLevelLab =  self.m_InfoDetail.transform:FindChild("Label2/Level").gameObject:GetComponent("UILabel")
    self.m_DetailPlayerNameLab = self.m_InfoDetail.transform:FindChild('nickname'):GetComponent('UILabel')
  end
  self.m_SoundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") 
  self.m_JettonObj  = ResManager:LoadAsset("gamenn/prefabs","JettonPrefab") 
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
	self:UpdateSkinColor()
	if self.m_CardScoreObj ~= nil and self.m_CardTypeTrans ~= nil  and self.m_UserchipBtns ~= nil and self.m_CallBankerObj~= nil   then
		self.m_CardScoreV = self.m_CardScoreObj.transform.localPosition
		self.m_CardTrans.localPosition = Vector3.New(25,-45,self.m_ParentZ)
		self.m_CardTypeV = self.m_CardTypeTrans.localPosition
		self.m_ShopV = self.m_UserchipBtns.transform.localPosition
		self.m_CallBankerV = self.m_CallBankerObj.transform.localPosition
		self.m_InfoDetailV = self.m_InfoDetail.transform.localPosition
		self.m_CloseingObj.transform.localPosition = Vector3.New(20,60,0)
		self.m_ChopObjV = self.m_UserchipBtns.transform.localPosition
		self.m_UserChipTrans = self.m_UserAvatar.transform.localPosition
	end
	local tAnchor = self.gameObject:GetComponent('UIAnchor')
	
	if tAnchor.side == UIAnchor.Side.Right then
		self.m_ParentX =-225
		self.m_CardTrans.localPosition = Vector3.New(self.m_ParentX,0,self.m_ParentZ)
		self.m_CardScoreObj.transform.localPosition = Vector3.New(-255,-38,self.m_CardScoreV.z)
		self.m_CardTypeTrans.localPosition = Vector3.New(-self.m_CardTypeV.x,self.m_CardTypeV.y,self.m_CardTypeV.z)
		self.m_ShowObj.transform.localPosition = Vector3.New(-239,self.m_CardTrans.localPosition.y,self.m_ShopV.z)
		self.m_InfoDetail.transform.localPosition = Vector3.New(-self.m_InfoDetailV.x,self.m_InfoDetailV.y,self.m_InfoDetailV.z)
		self.m_CloseingObj.transform.localPosition = Vector3.New(self.m_ParentX-227,110,self.m_ParentZ)
		self.m_CallBankerObj.transform.localPosition = Vector3.New(-self.m_CallBankerV.x,self.m_CallBankerV.y,self.m_CallBankerV.z)
		self.m_UserchipBtns.transform.localPosition = Vector3.New(-170,-49,self.m_ParentZ)
		self.m_UserChipTrans = self.m_UserAvatar.transform.localPosition
		self.m_ReadyObj.transform.localPosition = Vector3.New(self.m_ParentX,-40,0)
		self.m_OtherChipTrans.transform.localPosition = Vector3.New(-677, 78, 0)
		self.m_MessageBg.transform.localPosition = Vector3.New(133,0,0)
		self.m_MessageBg.transform.localRotation = Quaternion.New(0,0,180,0)
		self.m_MessageLab.transform.localPosition = Vector3.New(-133,0,0)
		self.m_MessageLab.transform.localRotation = Quaternion.New(0,0,180,0)
		--change  省略位置
	elseif tAnchor.side == UIAnchor.Side.Top then
		self.m_ParentX =226
		self.m_CardScoreObj.transform.localPosition = Vector3.New(230,-38,self.m_CardScoreV.z)
		self.m_CardTrans.localPosition = Vector3.New(-self.m_ParentX,0,self.m_ParentZ)
		self.m_CardTypeTrans.localPosition = Vector3.New(180,-60,self.m_CardTypeV.z)
		self.m_ShowObj.transform.localPosition = Vector3.New(205,self.m_CardTrans.localPosition.y,self.m_ShopV.z)
		self.m_InfoDetail.transform.localPosition = Vector3.New(self.m_InfoDetailV.x,self.m_InfoDetailV.y,self.m_InfoDetailV.z)
		self.m_CloseingObj.transform.localPosition = Vector3.New(0,-66,self.m_ParentZ)
		self.m_CallBankerObj.transform.localPosition = Vector3.New(-self.m_CallBankerV.x,self.m_CallBankerV.y,self.m_CallBankerV.z)
		self.m_UserchipBtns.transform.localPosition = Vector3.New(170,-50,self.m_ParentZ)
		self.m_UserChipTrans = self.m_UserAvatar.transform.localPosition
		self.m_OtherChipTrans.transform.localPosition = Vector3.New(141, -180, 0)
	elseif tAnchor.side == UIAnchor.Side.Left then
		self.m_ParentX = 230
		self.m_CardTrans.localPosition = Vector3.New(-self.m_ParentX,0,self.m_ParentZ)
		self.m_CardScoreObj.transform.localPosition = Vector3.New(230,-38,self.m_CardScoreV.z)
		self.m_CardTypeTrans.localPosition = Vector3.New(180,-60,self.m_CardTypeV.z)
		self.m_CloseingObj.transform.localPosition = Vector3.New(self.m_ParentX-227,110,self.m_ParentZ)
		self.m_UserchipBtns.transform.localPosition = Vector3.New(167,-49,self.m_ParentZ)
		self.m_ShowObj.transform.localPosition = Vector3.New(205,self.m_CardTrans.localPosition.y,self.m_ShopV.z)
		self.m_UserChipTrans = self.m_UserAvatar.transform.localPosition
		self.m_OtherChipTrans.transform.localPosition = Vector3.New(650, 129, 0)
		--change   
	end
end
function this:OnDestroy(  )
	self:clearLuaValue()
end

function this:SetPlayerInfo(pAvatar,pNickname,pIntoMoney,pLevel)
	print(' set player info ')
	-- print('===========avatar   '..pAvatar)
	self.m_UserAvatar.spriteName = 'avatar_'..tostring(pAvatar)
	self.m_UserNickNameLab.text=  pNickname
	self.m_UserIntoMoneyLab.text = EginTools.NumberAddComma(pIntoMoney)
	self.m_DetailNickNameLab.text = pNickname
	--change  性别  以及  playername
	self.m_DetailLevelLab.text = pLevel
	self.m_DetailPlayerNameLab.text = pNickname


	self.m_Sex = pAvatar%2

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
--change 省略update
function this:UpdateIntomoney(pIntoMoney)
	if self.m_UserIntoMoneyLab == nil then
		find('Label_bagmoney'):GetComponent('UILabel').text = EginTools.NumberAddComma(pIntoMoney)
	else
		m_UserIntoMoneyLab.text = EginTools.NumberAddComma(pIntoMoney)
	end
end

function this:SetBanker(pIsShow )

	if pIsShow  == true  then
	    self.m_BankerSpObj:SetActive(true)
	    if self.m_BankerBgObj ~= nil then
	      self.m_BankerBgObj:SetActive(false)
	    end
  	else
	    self.m_BankerSpObj:SetActive(false)
	    if self.m_BankerBgObj~= nil then 
	      self.m_BankerBgObj:SetActive(true)
	    end
 	 end
end

function this:UserSetDeal( pIsShow,pInfos,pTime,pDelay )
	if not pIsShow then
		self.m_CardTrans.gameObject:SetActive(false)
	else
		self.m_CardTrans.gameObject:SetActive(true)

		if pInfos ~= nil and #pInfos>0 then
			local tTempV = Vector3.zero
			local tV = 0
			for i=1,#pInfos do 
				if pInfos[i] ~= nil then
					local tempObj = self.m_CardTrans:FindChild('Sprite'..i-1).gameObject
					tempObj:GetComponent('UISprite').spriteName= 'card_blue'
					if tV == 0 then
						tTempV = Vector3.New(-280,tempObj.transform.localPosition.y,0)  --tempObj.transform.localPosition
					end
					local tTargetPos = Vector3.New(-280 + (i-1)*132,tempObj.transform.localPosition)
					tempObj.transform.localPosition = tTempV
					iTween.MoveTo(tempObj,iTween.Hash('position',tTargetPos,'time',tV,'delay',0.2,'easetype',iTween.EaseType.linear,'islocal',true))
					tV = tV +0.2
				end
			end
			tV = tV + 0.1
			local tClip = ResManager:LoadAsset('gamenn/Sound','cardfan')
			coroutine.start(function ()
				coroutine.wait(tV)
				local tDelayTemp = 0
				for i=#pInfos,1,-1 do
					if pInfos[i] ~= nil then
						local tPoker = self.m_CardTrans:FindChild('Sprite'..i-1).gameObject
						if tPoker ~= nil then 
							iTween.ScaleTo(tPoker,iTween.Hash('x',0.001,'time',0.2,'easeType',iTween.EaseType.linear)) --,'delay',tDelayTemp
							-- coroutine.wait(tDelayTemp)
							tPoker.gameObject:GetComponent('UISprite').spriteName = this.m_CardPreStr..tostring(pInfos[i])
							iTween.ScaleTo(tPoker,iTween.Hash('x',1,'time',0.2,'delay',0.3))
							coroutine.wait(0.4)
						end
						if tClip ~= nil then
							EginTools.PlayEffect(tClip)
						end
						tDelayTemp = tDelayTemp+0.1
					end
					coroutine.wait(0.1)
				end
			end)
		end
	end
end

function this:SetDeal( pIsShow,pInfos )
	if  pIsShow == false  then
		self.m_CardTrans.gameObject:SetActive(false)
	else
		-- local x = self.m_ParentX + 2*this.m_CardInterval;
		self.m_CardTrans.gameObject:SetActive(true)
		local tempV = Vector3.one
		if self.m_ParentX >0 then
			self.m_CardTrans.localPosition = Vector3.New(230,0,0)
			self.m_CardTypeTrans.localPosition = Vector3.New(188,-60,0)
		else
			self.m_CardTrans.localPosition = Vector3.New(-225,0,0)
			self.m_CardTypeTrans.localPosition = Vector3.New(-270,-60,0)
		end 
	
		local tCardsNiuPos = {-80,-40,0,40,80}
		local tV = 200
		for i=1,#self.m_CardArraySps do 
			local tClip = ResManager:LoadAsset('gamenn/Sound','SEND_CARD')
			EginTools.PlayEffect(tClip)
			self.m_CardArraySps[i].transform.localPosition = Vector3.New(tCardsNiuPos[1],0,0)
			self.m_CardArraySps[i].gameObject:SetActive(true)
			if pInfos ~= nil and #pInfos>0 then
				self.m_CardArraySps[i].spriteName = this.m_CardPreStr..tostring(pInfos[i])
			end
			local tTemp = tCardsNiuPos[i] - tCardsNiuPos[1]
			if tTemp <0 then
				tTemp =0 
			end
			local tS = tTemp/tV
			iTween.MoveTo(self.m_CardArraySps[i].gameObject,iTween.Hash('x',tCardsNiuPos[i],'time',tS,'delay',0.2,'islocal',true,'easytype',iTween.EaseType.linear))
		end
		-- coroutine.wait(0.2)
	end
end

function this:SetEliminatePlayerUser(pUid,pUidCount,pRemovePlayer )
	local tContent = find('Content')
	local tRemoveNameObj
	if tUid ~= nil then
		local tObj  = ResManager:LoadAsset('gamenn/prefabs','remove_uid')
		if tostring(pUidCount) ~= tostring(EginUser.Instance.uid) then
			if #pUid ==1 then
				
				tRemoveNameObj = GameObject.Instantiate(tObj)
				tRemoveNameObj.transform.parent = content.transform.parent
				tRemoveNameObj.transform.localPosition = Vector2.New(0,140-(#pUid)*30)
				tRemoveNameObj.transform.localScale = Vector3.one
				local tRemove = pRemovePlayer.gameObject.transform:FindChild('PlayerInfo'):FindChild('Label_nickname'):GetComponent('UILabel').text 
				tRemoveNameObj:GetComponent('UILabel').text = "玩家" .. tRemove .. "淘汰出局";
				coroutine.start(function (  )
					if tRemoveNameObj ~= nil then
						destroy(tRemoveNameObj,1.5)
						coroutine.wait(0.5)
					end
				end)
			end
		end
		if tostring(pUidCount) == EginUser.Instance.uid then
			tRemoveNameObj  = GameObject.Instantiate(tObj)
			tRemoveNameObj.transform.parent = content.transform.parent
			tRemoveNameObj.transform.localPosition = Vector2.New(0,140-(#pUid)*30)
			tRemoveNameObj.transform.localScale = Vector3.one
			tRemoveNameObj:GetComponent('UILabel').text = '玩家  '..EginUser.Instance.nickname..'淘汰出局'
			coroutine.start(function (  )
				if tRemoveNameObj ~= nil then
					destroy(tRemoveNameObj,1.5)
					coroutine.wait(0.5)
				end
			end)
		end
	end	
end
--玩家比牌情況
function this:SetCardTypeUser(pCardType)
	local tCardTypeSp = self.m_Type.gameObject:GetComponent('UISprite') 

	if pCardType <= 0  or pCardType>10 then
		self.m_Type.gameObject:SetActive(true)
		tCardTypeSp.spriteName = 'own_0'
		local tClip = ResManager:LoadAsset('gamenn/Sound','niu0')
		if tClip ~= nil then
			EginTools.PlayEffect(tClip)
		end
	else
		self.m_Type.localScale = Vector3.New(3,3,1)
		self.m_Type.gameObject:SetActive(true)
		if pCardType == 10 then
			tCardTypeSp.spriteName = 'own_da'
		elseif pCardType >0 and pCardType <= 9 then
			tCardTypeSp.spriteName = 'own_xiao'
		end
		
		-- self.m_Type.gameObject:SetActive(true)
		-- local tAlp = 1
		-- coroutine.start(function (  )
		-- 	for i=1,3 do
		-- 		tAlp = tAlp -0.1
		-- 		self.m_Type:GetComponent('UISprite').alpha =tAlp
		-- 		coroutine.wait(0.1) 
		-- 	end
		-- end)
		self.m_Type:GetComponent('UISprite').alpha =0.7
		local tAlp = 0.7
		iTween.ScaleTo(self.m_Type.gameObject,iTween.Hash('x',1.0,'y',1.0,'time',0.3,'delay',0.1))  --'scale',Vector3.one,
		-- local tScale = 1.3
		local tObj = {}
		tObj[1] = pCardType
		tObj[2] = false
		coroutine.start(function ()
    		coroutine.wait(0.4)
    		self.m_Type.localScale = Vector3.one
    		self:dengdai(tObj,self.m_Type.gameObject)

			for i=1,3 do
				tAlp = tAlp +0.1
				-- tScale = tScale-0.1
				self.m_Type:GetComponent('UISprite').alpha =tAlp
				-- self.m_Type.localScale = Vector3.New(tScale,tScale,1)
				coroutine.wait(0.1) 
			end
		end)
		iTween.ShakeScale(self.m_Type.gameObject,iTween.Hash('amount',Vector3.one*0.05,'time',0.5,'delay',0.4,'easytype',iTween.EaseType.linear))
	end
end

function this:dengdai(pType,pObj)
	local tIsOwn = pType[2]
	local tCardType = tonumber(pType[1])
	
	if tCardType == 10 then
		self.m_NiuNiuAni.gameObject:SetActive(true)
		self.m_NiuAni.gameObject:SetActive(false)
		self.m_Type.gameObject:SetActive(false)
		self.m_NiuNiuAni:GetComponent('UISpriteAnimation').enabled = true
		self.m_NiuNiuAni:GetComponent('UISpriteAnimation'):playWithCallback(Util.packActionLua(function (self)
			self.m_NiuNiuAni.gameObject:SetActive(false)
			self.m_Type.gameObject:SetActive(true)
			self.m_NiuNiuAni:GetComponent('UISpriteAnimation').enabled = false
		end,self))
	else
		self.m_NiuNiuAni.gameObject:SetActive(false)
		self.m_NiuAni.gameObject:SetActive(true)
		-- self.m_Type.gameObject:SetActive(false)
		self.m_NiuAni:GetComponent('UISpriteAnimation').enabled = true
		self.m_NiuAni:GetComponent('UISpriteAnimation'):playWithCallback(Util.packActionLua(function (self)
			self.m_NiuAni.gameObject:SetActive(false)
			self.m_Type.gameObject:SetActive(true)
			self.m_NiuAni:GetComponent('UISpriteAnimation').enabled = false
		end,self))
	end

	local tSp = self.m_Type.gameObject:GetComponent('UISprite')
    if tIsOwn ==true then
    	tSp.spriteName = "own_" .. tostring(tCardType)
    else
    	tSp.spriteName = "other_" .. tCardType;
    end
    local tClip = ResManager:LoadAsset('gamenn/Sound','niu'..tostring(tCardType))
    if tClip ~= nil then
    	EginTools.PlayEffect(tClip)
    end

    if self.m_BtnShowObj ~= nil then
    	self.m_BtnShowObj:SetActive(false)
    end
end

function this:CardPlayAnimation( pCardsList ,pCardType)
	if pCardsList == nil then
		for i=1,#self.m_CardArraySps do 
			self.m_CardArraySps[i].gameObject.transform.localPosition = Vector3.New((i-2)*this.m_CardInterval,0,0)
		end
		self.m_CardTrans.localPosition = Vector3.New(self.m_ParentX,self.m_ParentY,self.m_ParentZ)
		self.m_CardTypeTrans.gameObject:SetActive(false)
	else
		local tCardsNiuPos = {-100,-60,-20,60,100}
		local tCardsNiuPos2 = {-80,-40,0,40,80}
		if pCardType == 10 then
			self.m_Type:GetComponent('UISprite').spriteName = 'own_da'
			self.m_Type.gameObject:SetActive(false)
		elseif pCardType >0 and pCardType <= 9 then
			self.m_Type:GetComponent('UISprite').spriteName = 'own_xiao'
			self.m_Type.gameObject:SetActive(false)
		elseif pCardType ==0 then
			self.m_Type:GetComponent('UISprite').spriteName = 'own_0'

		end
		self.m_CardTypeTrans.gameObject:SetActive(true)

		local tV = 260
		if pCardType>10 or pCardType<= 0 then
			pCardType =0
		end


		for i=1,#self.m_CardArraySps  do 
			self.m_CardArraySps[i].gameObject:SetActive(true)
			self.m_CardArraySps[i].gameObject.transform.localPosition = Vector3.right*(-110)
			self.m_CardArraySps[i].spriteName = this.m_CardPreStr..tostring(pCardsList[i])
			local tTempM = tCardsNiuPos[i] - self.m_CardArraySps[i].gameObject.transform.localPosition.x
			if tTempM <0 then
				tTempM = 0
			end
			local s = tTempM/tV 
			
			if pCardType >=0 and pCardType <=10 then
				iTween.MoveTo(self.m_CardArraySps[i].gameObject,iTween.Hash('x',tCardsNiuPos[i],'time',s,'islocal',true,'easeType',iTween.EaseType.linear))--'oncomplete','iTweenCompleted','oncompleteparams',pCardType,'oncompletetarget',self.gameObject
			else
				iTween.MoveTo(self.m_CardArraySps[i].gameObject,iTween.Hash('x',tCardsNiuPos2[i],'time',s,'islocal',true,'easeType',iTween.EaseType.linear))--'oncomplete','iTweenCompleted','oncompleteparams',pCardType,'oncompletetarget',self.gameObject
			end
			if i ==5 then
				coroutine.start(function ()
					coroutine.wait(s+0.1)
					self:SetCardTypeUser(pCardType)
				end)
			end	
		end
	end
end



function this:SetUserCards(pCount,pCardsList,pCardType,pPlayerScore,pMultiple)
	if pCardType =='10' then
		pCardType = 'niuniu'
	end
	local tNewCard = ResManager:LoadAsset('gamesrps/prefabs','lishicards')
	if pCount >0 then
		if pCount>3 then

			if self.m_NewCardTransform.childCount >2 then
			-- 	local tLastRecord = self.m_NewCardTransform:GetChild(0).gameObject
			-- 	destroy(tLastRecord)
			-- 	coroutine.start(function ()
			-- 		local tPos  = self.m_NewCardTransform:GetChild(0).transform.position 
			-- 		 self.m_NewCardTransform:GetChild(1).transform.position = tPos
			-- 		 self.m_NewCardTransform:GetChild(1):FindChild('Sort_num').gameObject:GetComponent('UILabel').text = '1'
			-- 		self.m_NewCardTransform:GetChild(2):FindChild('Sort_num').gameObject:GetComponent('UILabel').text = '2'
			-- 		coroutine.wait(0.3)
			-- 	end)
				local tFirst = self.m_NewCardTransform:FindChild('1').gameObject
				local tFirstPos = tFirst.transform.localPosition 

				destroy(tFirst)
				tFirst = self.m_NewCardTransform:FindChild('2').gameObject
				local tSecondPos = tFirst.transform.localPosition
				tFirst.transform.localPosition = tFirstPos
				tFirst.transform:FindChild('Sort_num'):GetComponent('UILabel').text = '1'
				tFirst.name = '1'
				tFirst = self.m_NewCardTransform:FindChild('3').gameObject
				tFirst.transform.localPosition = tSecondPos
				tFirst.name = '2'
				tFirst.transform:FindChild('Sort_num'):GetComponent('UILabel').text = '2'
			end
			pCount =3 
			tNewCard = GameObject.Instantiate(tNewCard)
			tNewCard.transform.parent = self.m_NewCardTransform.transform
			tNewCard.transform.localPosition = Vector3.New(0,-(pCount-1)*150,0)
			tNewCard.transform.localScale = Vector3.one
			tNewCard.name = tostring(pCount)
			for i=1,5 do 
				tNewCard.transform:FindChild('Lishi_Cards'):FindChild('Sprite'..i):GetComponent('UISprite').spriteName = this.m_CardPreStr.. tostring(pCardsList[i])
				if pCardType ~= 0 and i>3 then 
					tNewCard.transform:FindChild('Lishi_Cards'):FindChild('Sprite'..i).localPosition = tNewCard.transform:FindChild('Lishi_Cards'):FindChild('Sprite'..i).localPosition+Vector3.right*40
				end

			end
			tNewCard.transform:FindChild('Sort_num'):GetComponent('UILabel').text = tostring(pCount)
			tNewCard.transform:FindChild('Lishi_CardType'):GetComponent('UILabel').text = tostring(pCardType)
			tNewCard.transform:FindChild('chipLab'):GetComponent('UILabel').text = tostring(pPlayerScore)
			if string.len( tostring(pMultiple))>5 then
				pMultiple = string.sub(tostring(pMultiple),0,5)
			end

			tNewCard.transform:FindChild('winorlose'):GetComponent('UILabel').text = tostring(pMultiple)
		else
			tNewCard = GameObject.Instantiate(tNewCard)
			tNewCard.transform.parent = self.m_NewCardTransform.transform
			tNewCard.transform.localPosition = Vector3.New(0,-(pCount-1)*150,0 )
			tNewCard.transform.localScale = Vector3.one
			for i=1,5 do 
				tNewCard.transform:FindChild('Lishi_Cards'):FindChild('Sprite'..i):GetComponent('UISprite').spriteName = this.m_CardPreStr.. tostring(pCardsList[i])
				if pCardType ~= 0 and i>3 then 
					tNewCard.transform:FindChild('Lishi_Cards'):FindChild('Sprite'..i).localPosition = tNewCard.transform:FindChild('Lishi_Cards'):FindChild('Sprite'..i).localPosition+Vector3.right*40
				end
			end
			tNewCard.transform:FindChild('Sort_num'):GetComponent('UILabel').text = tostring(pCount)
			tNewCard.transform:FindChild('Lishi_CardType'):GetComponent('UILabel').text = tostring(pCardType)
			tNewCard.transform:FindChild('chipLab'):GetComponent('UILabel').text = tostring(pPlayerScore)
			if string.len( tostring(pMultiple))>5 then
				pMultiple = string.sub(tostring(pMultiple),0,5)
			end
			tNewCard.name = tostring(pCount)
			tNewCard.transform:FindChild('winorlose'):GetComponent('UILabel').text = tostring(pMultiple)
		end
		-- self.m_NewCardTransform:GetComponent('UIGrid'):Reposition()
	end
end
function this:SetCardTypeOther( pCardsList,pCardType)
	if pCardType==11 then
		self.m_CardTypeTrans.gameObject:SetActive(true)
		self.m_Type.gameObject:SetActive(true)
		self.m_Type.gameObject:GetComponent('UISprite').spriteName = 'other_0'
		pCardType = 0
	end
	if pCardsList ==nil then
		self.m_CardTrans.localPosition = Vector3.New(self.m_ParentX,0,self.m_ParentZ)
		self:UpdateSkinColor()
		self.m_CardTypeTrans.gameObject:SetActive(false)
	else
		self.m_CardTrans.gameObject:SetActive(true)
		self.m_CardTypeTrans.gameObject:SetActive(true)
		for i=1,#self.m_CardArraySps do
			self.m_CardArraySps[i].gameObject:SetActive(true)
			self.m_CardArraySps[i].spriteName = this.m_CardPreStr..tostring(pCardsList[i])
			if i== 5 then
				if pCardType <= 10 then
					for j=1,5 do 
						if self.m_CardArraySps[j] ~= nil then
							self.m_CardArraySps[j].depth = 14+i
						end
					end
					local tPos = { -100, -60, -20, 60, 100 }
			        local tPos1 = { -80, -40, 0, 40, 80 }
			        local tV = 200
			        for j =1, #self.m_CardArraySps do 
			        	self.m_CardArraySps[j].gameObject.transform.localPosition = Vector3.right*tPos[3]
			       
			       		local tTempM = tPos[j] - tPos[3]
			       		if tTempM <0 then
			       			tTempM =0
			       		end
			       		local tS = tTempM/tV
			       		local tP = tPos[j]
			       		if cardType ==0 then
			   				tP = tPos1[j]
			   			end
			   			iTween.MoveTo(self.m_CardArraySps[j].gameObject,iTween.Hash('x',tP,'time',tS,'islocal',true,'easetype',iTween.EaseType.linear))
			        end
			       -- local tCardSp = self.m_CardTypeTrans.transform:FindChild('Sprite'):GetComponent('UISprite')
			       local tSp = self.m_Type:GetComponent('UISprite')
			        if pCardType ==0 then
			        	tSp.spriteName = 'other_0'
			        	local tClip = ResManager:LoadAsset('gamenn/Sound','niu0')
			        	if tClip ~= nil then
			        		EginTools.PlayEffect(tClip)
			        	end
			        else
			        	if pCardType ==10 then
				        	tSp.spriteName = 'other_da'
				        elseif pCardType >0 and pCardType <10 then
				        	tSp.spriteName = 'other_xiao'
				        end
			        	self.m_Type.transform.localScale = Vector3.New(3,3,1)
			        	local tAlp = 1 
			        	coroutine.start(function (  )
							for i=1,3 do
								tAlp = tAlp -0.1
								tSp.alpha =tAlp
								coroutine.wait(0.1) 
							end
						end)
			        	-- iTween.ValueTo(self.m_Type.gameObject,iTween.Hash('from',1,'to',0.7,'time',0.3,'onupdate','changeAlpha','onupdatetarget',self.gameObject,'easeType',iTween.EaseType.linear))
			        	local tP = {}
			        	tP[1] = pCardType
			        	tP[2]=false
			        	iTween.ScaleTo(self.m_Type.gameObject,iTween.Hash('scale',Vector3.one,'time',0.3,'easytype',iTween.EaseType.linear))--,'oncomplete','dengdai','oncompleteparams',tP,'oncompletetarget',self.gameObject,
		        		-- self:dengdai(tP,self.m_Type.gameObject)
			       		-- iTween.ValueTo(self.m_Type.gameObject,iTween.Hash('from',0.7,'to',1,'time',0.1,'delay',0.3,'easetype',iTween.EaseType.linear))--,'onupdate','changeAlpha','onupdatetarget',self.gameObject
			        	coroutine.start(function ()
			        		coroutine.wait(0.4)
			        		self:dengdai(tP,self.m_Type.gameObject)
							for i=1,3 do
								tAlp = tAlp +0.1
								self.m_Type:GetComponent('UISprite').alpha =tAlp
								coroutine.wait(0.1) 
							end
			        		
			        	end)
			        	iTween.ShakeScale(self.m_Type.gameObject,iTween.Hash('amount',Vector3.one*0.05,'time',0.5,'delay',0.3,'easetype',iTween.EaseType.linear))
			        end
			        if self.m_ParentX >0 then
			        	self.m_CardTrans.localPosition = Vector3.New(230,0,0)
			        	self.m_CardTypeTrans.localPosition = Vector3.New(188,-60,0)
			        else
			        	self.m_CardTrans.localPosition = Vector3.New(-225,0,0)
			        	self.m_CardTypeTrans.localPosition = Vector3.New(-270,-60,0)
			        end
			    else
			    	-- local tCardSp = self.m_CardTypeTrans.transform:FindChild('Sprite'):GetComponent('UISprite')
			    	-- tCardSp.spriteName = 'other_0'
			    	self.m_Type.gameObject:GetComponent('UISprite').spriteName = 'other_0'
				end
			end
		end
	end
end


function this:SetPaiAvailable(  )
	for k,v in pairs(self.m_CardArraySps) do 
		if IsNil(v)==false then
			v.gameObject.transform:GetComponent('BoxCollider').enabled = true 
		end
	end
end

function this:SetPaiunavailable()
	for k,v in pairs(self.m_CardArraySps) do
		if IsNil(v)==false then
			v.gameObject.transform:GetComponent('BoxCollider').enabled = false 
		end
	end
end
--结算
function this:SetScore(pScore)
	self.m_CardScoreObj.transform:FindChild('Sprite_bg/Lab_Num'):GetComponent('UILabel').text = ''
	if pScore ==-1 then
		self.m_CloseingObj:SetActive(false)
		self.m_CardScoreObj.transform:FindChild('Sprite_bg/Lab_Num'):GetComponent('UILabel').text = ''
	else
		if self.m_CloseingObj ~= nil then
			self.m_CloseingObj:SetActive(true)
		end
		if pScore >= 1000000 or pScore <= -1000000 then
			self.m_CardScoreSp.width = 260
		end


		local tYazhu = self.m_CloseingObj.transform:FindChild('Closing')
		local tBasic 
		if pScore <0 then
			tBasic= 'money_'
		else
			tBasic ='money_+'
		end
		local tStr = tostring(math.abs(pScore))
		for i=1,7 do
			local tObj = tYazhu.transform:FindChild('SRPSPre'..i)
			local tIndex =tObj:GetComponent('UISprite')
			if tIndex ~= nil then 
				if i ==1 then
					if pScore >0 then
						tIndex.spriteName = tBasic..'+'
					else
						tIndex.spriteName = tBasic..'-'
					end
				else
					if string.len(tStr) >=i-1 then
						local tN = string.sub(tStr,i-1,i-1)

						if tN ~= nil then
							tObj.gameObject:SetActive(true)
							tIndex.spriteName = tBasic..tN
						else
							tObj.gameObject:SetActive(false)
						end
					else
						tObj.gameObject:SetActive(false)
					end
				end				
			end
		end
	end
end

function this:SetBet(pJetton)

	if pJetton >0 and self.m_CardScoreObj.activeSelf == false   then
		self.m_CardScoreObj.transform:FindChild('Sprite_bg/Lab_Num'):GetComponent('UILabel').text = '[b]'..tostring(pJetton)
		self.m_CardScoreObj:SetActive(true)
	else
		self.m_CardScoreObj:SetActive(false)
	end
end


function this:SetStartChip(pParent,pJetton)
	-- local tSp = pParent:GetComponentsInChildren(Type.GetType('UISprite',true))
	-- if tSp.Length >1 then
	-- 	for k,v in pairs(tSp) do
	-- 		if IsNil(v) ==false then
	-- 			if v.gameObject.name ~= 'Sprite_bg' then
	-- 				destroy(v.gameObject)
	-- 			end
	-- 		end
	-- 	end
	-- end
	if pJetton >0  then
		pParent.transform:FindChild('Lab_Num'):GetComponent('UILabel').text = '[b]'..tostring(pJetton)
		-- local tYazhuPre =ResManager:LoadAsset('gamesrps/srpspre','SRPSPre')
		-- tYazhuPre.gameObject:GetComponent('UISprite').spriteName = 'yazhu_2'
		-- EginTools.AddNumberSpritesCenter_Srps(tYazhuPre,pParent.transform,tostring(pJetton),'yanzhu_',0.8)
	else
		self.m_CardScoreObj:SetActive(false)
	end
end

function this:SetReady( pToShow )
	if pToShow==true and self.m_ReadyObj.activeSelf ==false then
		self.m_ReadyObj:SetActive(true)
	else
		self.m_ReadyObj:SetActive(false)
	end
end
function this:SetShow( pIsShow )
	if pIsShow ~= nil then
		if pIsShow==true and self.m_ShowObj.activeSelf == false  then
			self.m_ShowObj:SetActive(true)
		else
			self.m_ShowObj:SetActive(false )
		end
	end
end

function this:SetUserChipShow( pIsShow )
	local tChipObj = self.transform:FindChild('Output/ChooseChips').gameObject
	if tChipObj~= nil then
		if pIsShow and tChipObj.activeSelf == false then
			tChipObj:SetActive(true)
		else
			tChipObj:SetActive(false)
		end
	end
end 

function this:SetCardClosing( pIsShow )
	if self.m_CloseingObj ~= nil then
		if pIsShow and self.m_CloseingObj.activeSelf == false then
			self.m_CloseingObj:SetActive(true)
		else
			self.m_CloseingObj:SetActive(false)
		end
	end
end

function this:SetChip( pIsShow )

	if self.m_UserchipBtns ~= nil then
		if pIsShow and not self.m_UserchipBtns.activeSelf then
			self.m_UserchipBtns:SetActive(true)
		else
			self.m_UserchipBtns:SetActive(false)
		end
	end
end
--change 
-- pIsBack == true  筹码回来方法   false 筹码投入方法
function this:ChoumaPosition(pIsBack,pIsShow)--pPos ,
	--[[ local tBg = self.transform.parent.parent:FindChild('Panel_background/Sprite_Texture')
	local tTarget = tBg:FindChild('target').gameObject:GetComponent('UISprite') 
	-- local tOb = ResManager:LoadAsset('gamesrps/srpspre','srpspre')
	-- local tChouma = tBg:FindChild(tostring(pPos))
	local tParent = self.m_ChouMaGroup.gameObject
	self.m_ChouMaGroup:SetActive(pIsShow)
	for i=1,6 do 
		local tChouma = tParent.transform:FindChild('Chouma'..i)
		if pIsShow == true then
			local tX = math.random(-tTarget.width*0.5,tTarget.width*0.5)
			local tY = math.random(tTarget.transform.localPosition.y - 	tTarget.height*0.5, tTarget.transform.localPosition.y + tTarget.height*0.5)
			local tCount = math.random(2,6)
			tChouma:GetComponent('UISprite').spriteName = 'Chip'..tostring(tCount)
			tChouma:GetComponent('TweenPosition').from = tChouma.transform.position
	        
	        tChouma:GetComponent('TweenPosition').duration = 0.2
	        if pIsBack == false then
	       		tChouma:GetComponent('TweenPosition').to =tTarget.transform.position   -- + Vector3.New(tX,tY,0)
	       	else
	       		tChouma:GetComponent('TweenPosition').to =self.m_UserChipTrans
	        end
	        tChouma:GetComponent('TweenPosition'):PlayForward()
	    else
	    	if pIsBack == false then
    			local tX = math.random(-tTarget.width*0.5,tTarget.width*0.5)
				local tY = math.random(tTarget.transform.localPosition.y - 	tTarget.height*0.5, tTarget.transform.localPosition.y + tTarget.height*0.5)
				local tCount = math.random(2,6)
	    		tChouma.transform.localPosition = tTarget.transform.localPosition +  Vector3.New(tX,tY,0)
	    	else
	    		tChouma.transform.localPosition = Vector3.zero
	    	end
	    	
	    end
	end
	]] 
end


function this:BackPos()
	-- local tParent = self.m_ChouMaGroup.gameObject:FindChild('ChoumaGroup').gameObject
	-- self.m_ChouMaGroup:SetActive(pIsShow)
	return self.m_CardTypeTrans.localPosition
end

function this:removechips( )
	local tChips = GameObject:FindGameObjectsWithTag('chips')
	if tChips.Length >0 then
		for k,v in pairs(tChips) do
			destroy(v)
		end
	end
	coroutine.wait(1)
end
--change reset view
function this:ResetView()
	print('resetView')
end
function this:RemoveJettons(  )
	for k,v in pairs(self.m_JettonObjs) do
		destroy(v)
	end
	self.m_JettonObjs = {}
end

function this:SetCallBanker( pIsShow )
	if self.m_CallBankerObj ~= nil then
		if pIsShow == true  and self.m_CallBankerObj.activeSelf ==false then
			self.m_CallBankerObj:SetActive(true)
		else
			self.m_CallBankerObj:SetActive(false)
		end
	end
end

function this:SetWait(pIsShow)
	if self.m_WaitObj ~= nil then
		if pIsShow and self.m_WaitObj.activeSelf == false then
			self.m_WaitObj:SetActive(true)
		else
			self.m_WaitObj:SetActive(false)
		end
	end
end

--change SetChipMove1 
function this:SetMessage(pIndex ,pText)
	-- print('set message ') 
	local tMale = 'man'
	if self.m_Sex == 1 then
		tMale = 'woman'
	end

	local tClip = ResManager:LoadAsset('gamenn/Sound',tMale..'_'..(pIndex+1))
	if tClip ~= nil then
		EginTools.PlayEffect(tClip)
	end
	if self.m_MessageBg.activeSelf ==false then
		self.m_MessageBg:SetActive(true)
		self.m_MessageLab.text = pText
	end

	coroutine.start(function ( )
		coroutine.wait(2)
		self.m_MessageLab.text  = ''
		self.m_MessageBg:SetActive(false)
	end)

end

function this:SetEmotion(pIndex)
	-- print('set emotion ')
	if self.m_EmotionPos.transform:FindChild('Emotion') ~= nil then
		destroy(self.m_EmotionPos.transform:FindChild('Emotion').gameObject)
	end
	local tObj = ResManager:LoadAsset('expressionpackage/biaoqing_'..pIndex,'biaoqing_'..pIndex)
	local tObj = GameObject.Instantiate(tObj)
   	tObj.transform.parent = self.m_EmotionPos.transform
    tObj.transform.localScale = Vector3.one
    tObj.transform.localPosition = Vector3.zero
   	coroutine.start(function ( )
   		coroutine.wait(1.25)
   		destroy(tObj)
   	end)
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