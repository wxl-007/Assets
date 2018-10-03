local this = LuaObject:New()
BBDZPlayerCtrl = this

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
this.m_CardInitPos = 100
this.m_CardInterval = 50
this.m_CardPreStr = 'card_'
this.m_TimeInterval =3
this.m_TimeLasted =0

function this:clearLuaValue(  )
  self.gameObject= nil 
  self.transform = nil 

  self.m_CardTrans = nil
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
  self.m_cardScoreObj  =nil       -- 玩家得分
   
  
  self.m_BankerSpObj=nil
  
  self.m_JettonObj=nil
  self.m_InfoDetail=nil
  self.m_DetailNickNameLab=nil
  self.m_DetailLevelLab=nil
  self.m_DetailBagMoneyLab=nil

  self.m_gold_type=nil;
  self.jiangliMoney=nil;
  
  self.m_TimeLasted =nil

  self.m_SoundSend=nil
  self.m_CardScoreV=nil
  self.m_CardTypeV=nil
  self.m_ShopV=nil
  self.m_CallBankerV=nil
  self.m_InfoDetailV =nil
end

function this:Awake()
  self:init()
  self.m_ParentX = self.m_CardTrans.localPosition.x
  self.m_ParentY = self.m_CardTrans.localPosition.y
  self.m_ParentZ = self.m_CardTrans.localPosition.z
end

function this:Start( )
  self:UpdateSkinColor()
  if self.m_cardScoreObj ~= nil and self.m_CardTypeTrans ~= nil and self.m_ShowObj ~= nil and self.m_CallBankerObj~= nil then
    self.m_CardScoreV   = self.m_cardScoreObj.transform.localPosition
    self.m_CardTypeV    = self.m_CardTypeTrans.localPosition
    self.m_ShopV        = self.m_ShowObj.transform.localPosition
    self.m_CallBankerV  = self.m_CallBankerObj.transform.localPosition
    self.m_InfoDetailV  = self.m_InfoDetail.transform.localPosition
  end
  local tAnchor = self.gameObject:GetComponent('UIAnchor')
  if tAnchor.side == UIAnchor.Side.Right then
    
  elseif tAnchor.side == UIAnchor.Side.Top then
      local outputAnchor=self.transform:FindChild("Output");
      outputAnchor.transform.localPosition=Vector3.New(-235,-320,0);
      --self.chipParent.transform.localPosition=Vector3.New(0,-500,0);
  elseif tAnchor.side == UIAnchor.Side.Left then
   
  end
end

function this:init(  )
  this.m_TimeLasted =0
  self.m_CardTrans = self.transform:FindChild('Output/Cards')
  self.m_CardTypeTrans = self.transform:FindChild('Output/Cards/CardType')


  self.m_cardscoreParent = self.transform:FindChild("Output/CardScore").gameObject;
	self.m_cardScoreObj = self.transform:FindChild("Output/CardScore/CardScore").gameObject
	self.m_plusLabel = self.transform:FindChild("Output/CardScore/CardScore/win").gameObject:GetComponent("UILabel");
	self.m_minusLabel = self.transform:FindChild("Output/CardScore/CardScore/lose").gameObject:GetComponent("UILabel");
  

  self.m_InfoDetail = nil 
  self.cardsTransAnima = self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");

  if(self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) )then
    self.m_ShowObj = self.transform:FindChild("Output/Cards/Sprite_Over/Sprite_show").gameObject
    self.m_InfoDetail  = self.transform:FindChild("PlayerInfo/Info_detail").gameObject
    self.m_ReadyObj  = self.transform:FindChild("PlayerInfo/Panel/Sprite_ready").gameObject
    self.m_WaitObj    = self.transform:FindChild("PlayerInfo/Panel/Sprite_waitting").gameObject
    self.m_UserAvatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
    self.m_UserNickNameLab  = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel");
    self.m_UserIntoMoneyLab = self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");
    self.m_DetailNickNameLab  = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");   
    self.m_DetailLevelLab =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
    self.m_DetailBagMoneyLab  =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");
    self.m_BankerSpObj  = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject
    self.m_CallBankerObj  = self.transform:FindChild("PlayerInfo/Sprite_callBanker").gameObject
    self.m_gold_type = self.m_CardTypeTrans:FindChild("CardType_gold").gameObject;
	  self.jiangliMoney=nil;
    self.m_cardTypeSprite = self.m_CardTypeTrans:FindChild("Sprite"):GetComponent("UISprite");
    self.movePanel={};
		for i=1,8 do
			table.insert(self.movePanel,self.transform:FindChild("PlayerInfo/Label_bagmoney/bet_1/bet_"..i).gameObject);
		end
		self.chipParent=self.transform:FindChild("Output/chipBet").gameObject;
		self.movetarget=self.transform:FindChild("PlayerInfo/Label_bagmoney/bet").gameObject
  else
    self.m_ReadyObj   = self.transform:FindChild("Output/Sprite_ready").gameObject
    self.m_BankerSpObj = self.transform:FindChild("Output/Sprite_banker").gameObject
    self.m_InfoDetail  = nil
    self.m_gold_type = self.m_CardTypeTrans:FindChild("CardType_gold").gameObject;
  	self.jiangliMoney=self.transform:FindChild("Output/Label").gameObject:GetComponent("UILabel");
    self.m_cardTypeSprite = self.m_CardTypeTrans:FindChild("Sprite"):GetComponent("UISprite");
    self.movePanel={};
    local info = GameObject.Find("FootInfo");
		for i=1,8 do
			table.insert(self.movePanel,info.transform:FindChild("Foot - Anchor/Info/Money/Sprite_1/Sprite_"..i).gameObject);
		end
		self.chipParent = self.transform:FindChild("Output/chipBet").gameObject
    log(self.chipParent.name);
		self.movetarget=info.transform:FindChild("Foot - Anchor/Info/Money/Sprite").gameObject;
  end
 
  
  self.m_SoundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");

  self.m_JettonObj  = ResManager:LoadAsset("gamenn/prefabs","JettonPrefab") 

  if(self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) )then
    local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject
    GameBBDZ.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self)
   
  end
  
  self.m_CardArraySps = {}
  for i=1,5 do
		table.insert(self.m_CardArraySps,self.m_CardTrans:FindChild("Sprite_"..i).gameObject:GetComponent("UISprite"));
	end
end





function this:OnDestroy( )
  self:clearLuaValue()
end

function this:UpdateSkinColor()
  for k,v in pairs(self.m_CardArraySps) do
    v.spriteName = this.m_CardPreStr .."meihong";
  end
end

function this:SetPlayerInfo(pAvatar,pNickname,pIntoMoney,pLevel)
	self.m_UserAvatar.spriteName = 'avatar_'..pAvatar
	self.m_UserNickNameLab.text = pNickname
	self.m_UserIntoMoneyLab.text = EginTools.HuanSuanMoney(pIntoMoney)
	self.m_DetailNickNameLab.text = pNickname
	self.m_DetailLevelLab.text = pLevel
	self.m_DetailBagMoneyLab.text = pIntoMoney
end

function this:OnClickInfoDetail( )
	if self.m_InfoDetail.activeSelf ==true then
		self.m_InfoDetail:SetActive(false)
		self.m_TimeLasted = 0
	else
		self.m_InfoDetail:SetActive(true)
	end
end



function this:UpdateInLua()
  if self.m_InfoDetail ~= nil then
    if  self.m_InfoDetail.activeSelf ==true then
      self.m_TimeLasted = self.m_TimeLasted + 0.5 --Time.deltaTime
      if self.m_TimeLasted>= this.m_TimeInterval then
        self.m_InfoDetail:SetActive(false)
        self.m_TimeLasted = 0
      end
    end
  end
end

function this:UpdateIntomoney( pIntoMoney )
	if self.m_UserIntoMoneyLab ~= nil then
		
    self.m_UserIntoMoneyLab.text = EginTools.HuanSuanMoney(pIntoMoney)
  else
		find('Label_Bagmoney').gameObject:GetComponent('UILabel').text  = EginTools.HuanSuanMoney(pIntoMoney)
	end
end

function this:SetBanker(pToShow)
  if pToShow then
    self.m_BankerSpObj:SetActive(true)
    
  else
    self.m_BankerSpObj:SetActive(false)
    
  end
end

function this:SetDeal(pIsToShow,pInfos)
	if pIsToShow == false then 
		self.cardsTransAnima:Play("setcard_5");
	else
    local isown=false;
		--self.m_CardTrans.gameObject:SetActive(true)
    for k,v in ipairs(self.m_CardArraySps) do
       --v.gameObject:SetActive(true);  
       if pInfos ~= nil and #pInfos > 0 then
          v.spriteName = this.m_CardPreStr..tostring(pInfos[k])
          isown=true;
       end
       coroutine.wait(0.1)
			 if self.gameObject==nil then
				  return;
		 	end	
    end 
    self.cardsTransAnima.enabled = true;  
    if isown then
				self.cardsTransAnima:Play("setcard_1");
		else
				local count = math.random(8,11);
				self.cardsTransAnima:Play("setcard_"..count);
		end
		ResManager:LoadAsset('gamenn/Sound', self.m_SoundSend)
		for i=1,8 do
			self.movePanel[i].transform.localPosition=Vector3.zero;
		end
	end
end

function this:SetLate(pCards)
	
	-- for i=0,#self.m_CardTrans -1 do 
  for k,v in ipairs(self.m_CardArraySps) do
		v.gameObject:SetActive(true)
		if pCards ~= nil and #pCards>0 then
			v.spriteName = this.m_CardPreStr..tostring(pCards[k])
		end
	end
  self.m_CardTrans.gameObject:SetActive(true)
	self.cardsTransAnima.enabled=true;
	self.cardsTransAnima:Play("setcard_6");
end

function this:SetCardTypeUser(pCardsList,pCardType,isgold)
  if pCardsList == nil then
      self.m_CardTypeTrans.gameObject:SetActive(false)
      self.m_gold_type:SetActive(false)
      self.m_cardTypeSprite.gameObject:SetActive(false)
  else
    self.m_CardTypeTrans.gameObject:SetActive(true)
    for k,v in ipairs(self.m_CardArraySps) do
        v.spriteName = this.m_CardPreStr..tostring(pCardsList[k])
    end

    --local tCardTypeSp = self.m_CardTypeTrans:FindChild('CardType'):GetComponent('UISprite')
      
    if tonumber(pCardType) ==0 then
        self.m_cardTypeSprite.gameObject:SetActive(true)
        self.m_gold_type:SetActive(false)
        self.m_cardTypeSprite.spriteName = 'type_0'
        self.cardsTransAnima:Play("setcard_3");
    else
      if isgold ==1 then
        self.m_cardTypeSprite.gameObject:SetActive(false)
        self.m_gold_type:SetActive(true)
        local huangjin=self.m_gold_type.transform:FindChild("Sprite_1"):GetComponent("UISprite");
				local niuniu=self.m_gold_type.transform:FindChild("Sprite_2"):GetComponent("UISprite");
				huangjin.spriteName="type_15";
				niuniu.spriteName="type_10";
      else
        self.m_cardTypeSprite.gameObject:SetActive(true)
        self.m_gold_type:SetActive(false)
        self.m_cardTypeSprite.spriteName = 'type_'..pCardType
      end
      self.cardsTransAnima:Play("setcard_4");
    end



		

  end
end

function this:SetJiangLi(jiangliMoney)	
	self.jiangliMoney.text="大奖"..jiangliMoney.."游戏币到银行了";
	self.jiangliMoney.gameObject:SetActive(true);
	coroutine.start(self.AfterDoing,self,2,function()
		 self.jiangliMoney.gameObject:SetActive(false);
	end); 
end

function this:SetCardTypeOther(pCardsList,pCardType,isgold )
  if pCardsList == nil then
     self:UpdateSkinColor()
     self.m_CardTypeTrans.gameObject:SetActive(false)
     self.m_gold_type:SetActive(false)
     self.m_cardTypeSprite.gameObject:SetActive(false)
  else
    self.m_CardTypeTrans.gameObject:SetActive(true)
    for k,v in pairs(self.m_CardArraySps) do 
     v.spriteName = this.m_CardPreStr ..tostring(pCardsList[k]);
    end

    --local tCardTypeSp = self.m_CardTypeTrans:FindChild('Sprite'):GetComponent('UISprite')
   
    if tonumber(pCardType) ==0 then
        self.m_cardTypeSprite.gameObject:SetActive(true)
        self.m_gold_type:SetActive(false)
        self.m_cardTypeSprite.spriteName = 'type_0'
        self.cardsTransAnima:Play("setcard_3");
    elseif tonumber(pCardType) >0 then
        if isgold ==1 then
          self.m_cardTypeSprite.gameObject:SetActive(false)
          self.m_gold_type:SetActive(true)
          local huangjin=self.m_gold_type.transform:FindChild("Sprite_1"):GetComponent("UISprite");
          local niuniu=self.m_gold_type.transform:FindChild("Sprite_2"):GetComponent("UISprite");
          huangjin.spriteName="type_15";
          niuniu.spriteName="type_10";
        else
          self.m_cardTypeSprite.gameObject:SetActive(true)
          self.m_gold_type:SetActive(false)
          self.m_cardTypeSprite.spriteName = 'type_'..pCardType  
       end
       self.cardsTransAnima:Play("setcard_4");
    end

  end
end
function this:SetScore(pScore,targetPosition,isown )
    if(tonumber(pScore) == -1)then
	  	self.m_cardScoreObj:SetActive(false)
	  	self.m_cardscoreParent:SetActive(false);
  	else
	  	if self.m_cardScoreObj~=nil then
          self.m_cardScoreObj:SetActive(true)
          self.m_cardscoreParent:SetActive(true);
          if(tonumber(pScore) >= 0)then
            self.m_plusLabel.gameObject:SetActive(true)
            self.m_minusLabel.gameObject:SetActive(false)
            self.m_plusLabel.text ="+"  .. pScore
          elseif(tonumber(pScore)<0)then
            self.m_plusLabel.gameObject:SetActive(false)
            self.m_minusLabel.gameObject:SetActive(true)
            self.m_minusLabel.text = pScore
            self:MoveBet(targetPosition,isown);
            self.m_cardTypeSprite.spriteName="gray"..self.m_cardTypeSprite.spriteName;
            --[[
            local huangjin=self.m_gold_type.transform:FindChild("Sprite_1"):GetComponent("UISprite");
            local niuniu=self.m_gold_type.transform:FindChild("Sprite_2"):GetComponent("UISprite");
            huangjin.spriteName="gray"..huangjin.spriteName;
            niuniu.spriteName="gray"..niuniu.spriteName;
            ]]
          end
	  	end
  	end
end

function this:MoveBet(targetPosition,isown)
		local x=self.movetarget.transform.position.x;
		local y=self.movetarget.transform.position.y;
		local xx=targetPosition.x;
		local yy=targetPosition.y;
		local paths={};
		paths[1]=self.movetarget.transform.position;
		if isown then
			paths[2]=Vector3.New(xx,yy,0);
		else
			paths[2]=Vector3.New(x+(xx-x)*0.5,y+0.02,0);
			paths[3]=Vector3.New(xx,yy,0);
		end
		
		local pathse=Utils.Zhuanhuan(paths);
		local v = 0;	
		for   i = 1, 12 do	
			local temp = v;
			coroutine.start(self.AfterDoing,self,temp,function()
				if isown then
					log(i.."=============zhi");
				end
				if self.movePanel[i]~=nil then
					self.movePanel[i]:SetActive(true);
					--iTween.MoveTo(self.movePanel[i],GameJQNN.mono:iTweenHashLua("path",pathse,"time", 1.2-temp*0.5,"easeType", iTween.EaseType.easeOutQuart));
					iTween.MoveTo(self.movePanel[i],GameBBDZ.mono:iTweenHashLua("path",pathse,"time", 1.2-temp*0.5,"easeType", iTween.EaseType.easeOutCubic));
					iTween.ScaleTo(self.movePanel[i],GameBBDZ.mono:iTweenHashLua("scale",Vector3.New(1.2,1.2,1.2),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
					iTween.ScaleTo(self.movePanel[i],GameBBDZ.mono:iTweenHashLua("scale",Vector3.New(1,1,1),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
					coroutine.start(self.AfterDoing,self,1.4-temp*0.5,function()
						if self.movePanel[i]~=nil then
							self.movePanel[i]:SetActive(false);		
						end
					end); 				
				end	
			end);
			v=v+0.03;		
		end
end

function this:SetBet(pJetton )
    log(pJetton.."====下注筹码");
    if( (tonumber(pJetton) > 0) and (not self.m_cardScoreObj.activeSelf) )then
      self.chipParent:SetActive(true);
      self.chipParent.transform:FindChild("BetLabel"):GetComponent("UILabel").text=tostring(pJetton);
    else
      self.chipParent:SetActive(false);
    end
end


function this:SetReady(pToShow )
  if pToShow and self.m_ReadyObj.activeSelf == false then
    self.m_ReadyObj:SetActive(true)
  else
    self.m_ReadyObj:SetActive(false)
  end
end

function this:SetShow(pToShow )
  if self.m_ShowObj~= nil then 
    if pToShow and self.m_ShowObj.activeSelf == false then
      self.m_ShowObj:SetActive(true)
    else
      self.m_ShowObj:SetActive(false)
    end
  end
end


function this:SetCallBanker( pToShow)
  if self.m_CallBankerObj ~= nil then 
    if pToShow == true and self.m_CallBankerObj.activeSelf == false then
      self.m_CallBankerObj:SetActive(true)
    else
      self.m_CallBankerObj:SetActive(false)
    end
  end
end

function this:SetWait( pToShow )
  if self.m_WaitObj ~= nil then
    if pToShow and self.m_WaitObj.activeSelf == false then 
      self.m_WaitObj:SetActive(true)
    else
        self.m_WaitObj:SetActive(false)
    end
  end
end

function this:AfterDoing(offset, run)
    coroutine.wait(offset);
	if self.gameObject==nil then
		return;
	end
	run();
end
