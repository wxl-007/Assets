
local this = LuaObject:New()
TBSZPlayerCtrl = this



	
function this:New(gameobj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.gameObject = gameobj;
	o.transform = gameobj.transform;
	o:Awake();
	o:Start();
    return o;    --返回自身
end

function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	self.readyObj = nil
	self.showObj =nil
	self.waitObj = nil
	self.userAvatar = nil
	self.userNickname = nil
	self.userIntomoney =nil
	self.infoDetail = nil	
	self.kDetailNickname = nil		
	self.kDetailLevel =  nil
	self.kDetailBagmoney =  nil
	self.cardTypeTrans = nil	
	self.cardsTrans = nil
	self.cardScoreObj =nil
	self.cardScoreBg =nil
	self.soundSend =nil	
	self.jettonPrefab = nil
	self.promptMessage = nil
	
	self.cardScoreP = nil;
        self.cardTypeP = nil;
        self.showP = nil;
        self.infoDetailP = nil;
	self.WinIconAnima = nil
	self.AddNumAnima = nil
	self.MinusNumAnima = nil
	
	self.cardsArray = nil;	
	self.UserChip = 0;
end
function this:Init()
--初始化变量
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	self._cardInterval = 50;
	self._cardPre = "card_";
	self._timeInterval = 3;
	self._timeLasted = 0;
	self.cardScoreP = nil;
        self.cardTypeP = nil;
        self.showP = nil;
        self.infoDetailP = nil;
		
	self._alive = false;
	self.UserChip = 100;
	
	self.position = GlobalVar.PlayerPosition.Down;
	
	self.cardTypeTrans = self.transform:FindChild("Output/CardType")--比牌结果		
	self.cardTypeSprite = self.transform:FindChild("Output/CardType/Sprite").gameObject:GetComponent("UISprite");
	self.cardsTrans = self.transform:FindChild("Output/Cards")		--扑克牌的父物体
	self.cardsTransAniam = self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");	--扑克牌的父物体
	self.cardScoreObj = self.transform:FindChild("Output/CardScore").gameObject		--玩家得分
			
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");		
	self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab") -- resLoad("Prefabs/JettonPrefab");
	

	self.cardsArray = {};		--玩家的扑克牌(排序后)
	--[[for i=0,self.cardsTrans.childCount-1  do
		local card = self.cardsTrans:GetChild(i).gameObject;
		table.insert(self.cardsArray,card:GetComponent("UISprite"));	
	end]]
	table.insert(self.cardsArray,self.cardsTrans:FindChild("Sprite1"):GetComponent("UISprite"));
	table.insert(self.cardsArray,self.cardsTrans:FindChild("Sprite2"):GetComponent("UISprite"));
	table.insert(self.cardsArray,self.cardsTrans:FindChild("Sprite3"):GetComponent("UISprite"));
	
	if self.gameObject.name == "User" then
		self.readyObj = self.transform:FindChild("Output/Sprite_ready").gameObject
		self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
		self.cardScoreNum = self.transform:FindChild("Output/CardScore/Sprite_Num").gameObject:GetComponent("UILabel");
		self.cardScoreWin = self.transform:FindChild("Output/CardScore/Sprite_win").gameObject:GetComponent("UILabel");
		self.cardScoreLose = self.transform:FindChild("Output/CardScore/Sprite_lose").gameObject:GetComponent("UILabel");
		self.WinIconAnima = self.transform:FindChild("Output/WinIconAnima").gameObject 
		local userInfo = GameObject.Find("FootInfo/Foot - Anchor/Info").transform
		--self.WinIconAnima = userInfo:FindChild("WinIconAnima").gameObject 
		self.AddNumAnima = userInfo:FindChild("NumAnima/AddNumAnima").gameObject:GetComponent("UILabel")	
		self.MinusNumAnima = userInfo:FindChild("NumAnima/MinusNumAnima").gameObject:GetComponent("UILabel")	
		
		self.showObj =nil
		self.waitObj = nil
		self.userAvatar = nil
		self.userNickname = nil
		self.userIntomoney =nil
		self.infoDetail = nil	
		self.kDetailNickname = nil		
		self.kDetailLevel =  nil
		self.kDetailBagmoney =  nil
	else
		--提示字“准备”
		self.readyObj = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_ready").gameObject
		self.showObj =self.transform:FindChild("Output/Sprite_show").gameObject		--提示字"摊牌"
		self.waitObj = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_waitting").gameObject		--提示字"等待中"
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel_Head/Panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite")	-- 玩家头像	
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel")	--玩家昵称
		self.userIntomoney =self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");	--玩家带入金额
		self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject;	
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");		
		self.kDetailLevel =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");	
		self.cardScoreBg = nil
		self.WinIconAnima = self.transform:FindChild("Output/WinIconAnima").gameObject 
		self.AddNumAnima = self.transform:FindChild("PlayerInfo/NumAnima/AddNumAnima").gameObject:GetComponent("UILabel")	
		self.MinusNumAnima = self.transform:FindChild("PlayerInfo/NumAnima/MinusNumAnima").gameObject:GetComponent("UILabel")	
	end
	
	
	
end
function this:Awake()
	
	self:Init();

	
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel_Head/Panel/Sprite (avatar_6)").gameObject
		GameTBSZ.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
	
	end
	
	------------逻辑代码------------
	self.parentX = self.cardsTrans.localPosition.x
	self.parentY = self.cardsTrans.localPosition.y
	self.parentZ = self.cardsTrans.localPosition.z
	
end

function this:Start()
	--[[
	if not self.cardScoreBg then
		local sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true));
		if sprites.Length > 1 then
			for i=0,sprites.Length-1 do
				local sprite = sprites[i];
				destroy(sprite.gameObject);
			end
		end
	end
	]]
	self:UpdateSkinColor();
	 --[[

	
	if self.cardScoreObj and self.cardTypeTrans and self.showObj and  self.infoDetail  then
		self.cardScoreP = self.cardScoreObj.transform.localPosition;
        self.cardTypeP = self.cardTypeTrans.localPosition;
        self.showP = self.showObj.transform.localPosition;
        self.infoDetailP = self.infoDetail.transform.localPosition;
	end
	
	local anchor = self.gameObject:GetComponent("UIAnchor");

	if anchor.side == UIAnchor.Side.BottomRight then

            self.parentX = -195;
            self.cardsTrans.localPosition =  Vector3.New(self.parentX, self.parentY, self.parentZ);
            self.cardScoreObj.transform.localPosition = Vector3.New(-self.cardScoreP.x , self.cardScoreP.y + 5, self.cardScoreP.z);
            self.cardTypeTrans.localPosition = Vector3.New(-self.cardTypeP.x , self.cardTypeP.y, self.cardTypeP.z);
            self.showObj.transform.localPosition = Vector3.New(-self.showP.x , self.showP.y, self.showP.z);
            self.infoDetail.transform.localPosition = Vector3.New(-self.infoDetailP.x, self.infoDetailP.y, self.infoDetailP.z);
            --self.readyObj.transform.localPosition = Vector3.New(-self.readyObj.transform.localPosition.x, self.readyObj.transform.localPosition.y, 0);
			
			self.waitObj.transform.localPosition = self.readyObj.transform.localPosition
	elseif anchor.side == UIAnchor.Side.TopRight then

            self.parentX = -195;
            self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
            self.cardScoreObj.transform.localPosition = Vector3.New(-self.cardScoreP.x, self.cardScoreP.y, self.cardScoreP.z);
            self.cardTypeTrans.localPosition = Vector3.New(-self.cardTypeP.x , self.cardTypeP.y, self.cardTypeP.z);
            self.showObj.transform.localPosition = Vector3.New(-self.showP.x , self.showP.y, self.showP.z);
            self.infoDetail.transform.localPosition = Vector3.New(-self.infoDetailP.x, self.infoDetailP.y, self.infoDetailP.z);
            --self.readyObj.transform.localPosition = Vector3.New(-self.readyObj.transform.localPosition.x, self.readyObj.transform.localPosition.y, 0);
			
			self.waitObj.transform.localPosition =self.readyObj.transform.localPosition
    elseif anchor.side == UIAnchor.Side.Top then
		
            self.cardScoreObj.transform.localPosition = Vector3.New(-self.transform.localPosition.x,self.transform.localPosition.y-100, 0);
            self.parentX = 170;
            self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
    elseif anchor.side == UIAnchor.Side.TopLeft then

            self.parentX = 170;
            self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
    elseif anchor.side == UIAnchor.Side.BottomLeft then

            self.parentX = 170;
            self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
            self.cardScoreObj.transform.localPosition = Vector3.New(self.cardScoreP.x , self.cardScoreP.y + 5, self.cardScoreP.z);
            
	end
	]]
	self._alive = true;
end




--动态发牌时用
function this:SetLate(cards)
	self.cardsTrans.gameObject:SetActive(true);
	for key,v in ipairs(self.cardsArray) do
		v.gameObject:SetActive(true);
		if cards and #(cards) >0 then
			
			if tonumber(cards[key]) < 52 then
				local cardcount = tonumber(cards[key])+1;
				
				if cardcount==13 then
					cardcount=0;
				elseif cardcount==26 then
					cardcount=13;
				elseif cardcount==39 then
					cardcount=26;
				elseif cardcount==52 then
					cardcount=39;
				end
				v.spriteName = self._cardPre..tostring(cardcount)
			else
				v.spriteName = self._cardPre..cards[key]
			end
		end
	end
end
function this:UpdateSkinColor()
    for key,sprite in ipairs(self.cardsArray) do
		sprite.spriteName = "card_green"
	end
end

function this:NumberAddWan(intomoney)
	intomoney = tonumber(intomoney)
	return (intomoney/10000).."万"
end
function this:SetPlayerInfo(avatar, nickname, intomoney, level)
	self.userAvatar.spriteName = "avatar_"..avatar
	self.userNickname.text = this:LengNameSub(nickname);
	self.userIntomoney.text = self:NumberAddWan(intomoney)
	
	self.kDetailNickname.text = nickname;
	self.kDetailBagmoney.text = intomoney
	self.kDetailLevel.text = level;
	
	self.cardTypeTrans.gameObject:SetActive(false);
	self.cardsTrans.gameObject:SetActive(false);
end
function this:LengNameSub( text)
	
	if   LengthUTF8String(text) > 6 then
		return SubUTF8String(text,18);
	end
	return text;
end

function this:OnClickInfoDetail()
	
    if self.infoDetail.activeSelf then
		self.infoDetail:SetActive(false);
		self._timeLasted = 0;
	else
		self.infoDetail:SetActive(true);
	end
end

function this:Update()
   if not IsNil(self.infoDetail) and self.infoDetail.activeSelf then
		self._timeLasted = self._timeLasted + Time.deltaTime;
		if self._timeLasted >= self._timeInterval then
			self.infoDetail:SetActive(false)
			self._timeLasted = 0;
		end
	end
end

function this:UpdateIntoMoney(intomoney)
 
    if self.userIntomoney==nil then
		--self.transform:FindChild("PlayerInfo/Label_bagmoney"):GetComponent("UILabel").text = self:NumberAddWan(intomoney); 
	else
		self.userIntomoney.text =  self:NumberAddWan(intomoney);
	end
	
end

--发牌（带动画效果,需要在编辑器里将扑克牌的Active设为false）
function this:SetDeal(toShow, infos)
	if not toShow then
		
		for key,sprite in ipairs(self.cardsArray) do
			sprite.gameObject:SetActive(false);
		end
		self.WinIconAnima:SetActive(false)
	else
		--local x = self.parentX + 2*self._cardInterval;
		self.cardsTrans.gameObject:SetActive(true);
		self.cardsTransAniam:Play("TBNNPlayer1");
		  self.cardsTransAniam.enabled = false;  
		self.cardsTransAniam:Update(0);   
		coroutine.wait(0)
		for key,v in ipairs(self.cardsArray) do
			 v.gameObject:SetActive(true);  
			 v.spriteName = "card_green"
		end 
		
		self.cardsTransAniam.enabled = true;  
		if infos and #(infos)>0 then
			coroutine.wait(0.5)
			if self.gameObject==nil then
				return;
			end
			
			for key,v in ipairs(self.cardsArray) do  
				 iTween.ScaleTo(v.gameObject,iTween.Hash ("x", 0.000001,"time",0.12,"easeType", iTween.EaseType.linear));
			end
			
			coroutine.wait(0.17)
			if self.gameObject==nil then
				return;
			end
			  
			for key,v in ipairs(self.cardsArray) do  
				iTween.ScaleTo(v.gameObject,iTween.Hash ("x",1,"time",0.15,"easeType", iTween.EaseType.linear));
				if tonumber(infos[key]) < 52 then
					local cardcount = tonumber(infos[key])+1;
					
					if cardcount==13 then
						cardcount=0;
					elseif cardcount==26 then
						cardcount=13;
					elseif cardcount==39 then
						cardcount=26;
					elseif cardcount==52 then
						cardcount=39;
					end
					v.spriteName = self._cardPre..tostring(cardcount)
				else
					v.spriteName = self._cardPre..infos[key]
				end
			end
			
			
		end
		
		--[[
		for key,v in ipairs(self.cardsArray) do
			EginTools.PlayEffect(self.soundSend);
			self.cardsTrans.localPosition = Vector3.New(x-self._cardInterval/2*key,self.parentY,self.parentZ);
			v.gameObject:SetActive(true);
			
			if infos and #(infos)>0 then
			
				if tonumber(infos[key]) < 52 then
					local cardcount = tonumber(infos[key])+1;
					
					if cardcount==13 then
						cardcount=0;
					elseif cardcount==26 then
						cardcount=13;
					elseif cardcount==39 then
						cardcount=26;
					elseif cardcount==52 then
						cardcount=39;
					end
					v.spriteName = self._cardPre..tostring(cardcount)
				else
					v.spriteName = self._cardPre..infos[key]
				end
			end
			coroutine.wait(0.2)
			if self.gameObject==nil then
				return;
			end
		end
		]]
		 
	end
end

--主玩家的比牌情况
function this:SetCardTypeUser(cardsList, cardType)
        if cardsList==nil then
		--[[
		for i=0,#(self.cardsArray)-1 do
			
			self.cardsArray[4-i+1].transform.localPosition = Vector3.New(-100 +i * self._cardInterval, -20, 0);
		end
		
		self.cardsTrans.localPosition = Vector3.New(self.parentX,self.parentY,self.parentZ);
		
		local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		if cardTypeSprite then
			cardTypeSprite.depth=10;
		end
		]]
		
		self.cardTypeTrans.gameObject:SetActive(false);
	else
		if self.cardTypeTrans.gameObject.activeSelf then
			return;
		end
		for key,v in ipairs(self.cardsArray) do
		
			if tonumber(cardsList[key]) < 52 then
				local cardcount = tonumber(cardsList[key])+1;
				
				if cardcount==13 then
					cardcount=0;
				elseif cardcount==26 then
					cardcount=13;
				elseif cardcount==39 then
					cardcount=26;
				elseif cardcount==52 then
					cardcount=39;
				end
				v.spriteName = self._cardPre..tostring(cardcount)
			else
				v.spriteName = self._cardPre..cardsList[key];
			end
			
		end
		
		self.cardTypeTrans.gameObject:SetActive(true)
		local cardTypeSprite =self.cardTypeSprite;
		local tTypeBG = self.cardTypeSprite.gameObject.transform:FindChild('bg'):GetComponent('UISprite')
		tTypeBG.spriteName = 'bg_type'
--		self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		if 	cardTypeSprite then
			if tonumber(cardType)==0 or tonumber(cardType)==6 then
				cardTypeSprite.spriteName="type_"..tostring(cardType);
				tTypeBG.spriteName = 'bg_type1'
				self.cardsTransAniam:Play("ShowCards");
			elseif tonumber(cardType)> 0 then
				cardTypeSprite.spriteName="type_"..tostring(cardType);
				--[[
				if cardType == 1 then
					self.cardsArray[1].transform.localPosition = Vector3.New(-80,0,0) 
					self.cardsArray[3].transform.localPosition = Vector3.New(100,0,0)
				else
					self.cardsArray[1].transform.localPosition = Vector3.New(-80,0,0) 
					self.cardsArray[3].transform.localPosition = Vector3.New(80,0,0)
				end
				]]
				if cardType==1 then
					self.cardsTransAniam:Play("UserShowCards1");
				else
					self.cardsTransAniam:Play("ShowCards");
				end
				--[[
				self.cardsTransAniam:Play("UserShowCards1");
				elseif cardType == 2 or  cardType == 7 then
				
					 self.cardsTransAniam:Play("UserShowCards3");
				 elseif cardType == 3 then
				
					 self.cardsTransAniam:Play("UserShowCards2");
				 elseif cardType == 4 or  cardType == 5 or cardType == 6 or  cardType == 8 or cardType == 9 then
					
					 self.cardsTransAniam:Play("ShowCards");
				end
				]]
				
			end
		end
	end

	
end
function this:SetCardWinAnimation(score)  
	if  score > 0 then  
		self.WinIconAnima:SetActive(true)
		self.WinIconAnima.transform:FindChild("Sprite").gameObject:GetComponent("UISpriteAnimation"):Play();
		--local winA = self.WinIconAnima
		self.WinIconAnima.transform:FindChild("Sprite").gameObject:GetComponent("UISpriteAnimation"):playWithCallback(Util.packActionLua(function (self)
			 self.WinIconAnima:SetActive(false)
		end,self)) 
		self.AddNumAnima.gameObject:SetActive(true)
		self.AddNumAnima.text = "+"..score
		self.MinusNumAnima.gameObject:SetActive(false)
	else
		self.AddNumAnima.gameObject:SetActive(false)
		self.MinusNumAnima.gameObject:SetActive(true)
		self.MinusNumAnima.text = tostring(score)
	end  
	coroutine.start(self.AfterDoing,self,3,function()
		 
		self.AddNumAnima.gameObject:SetActive(false)
		self.MinusNumAnima.gameObject:SetActive(false)
	end); 
end
--其他玩家的比牌情况
function this:SetCardTypeOther(cardsList, cardType)
        if cardsList==nil then
		--[[
		for key,v in ipairs(self.cardsArray) do
			v.gameObject.transform.localPosition = Vector3.New((key - 2) * self._cardInterval+20, 0, 0);
		end
		self.cardsTrans.localPosition = Vector3.New(self.parentX,self.parentY,self.parentZ);
		
		local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		if 	cardTypeSprite then
			cardTypeSprite.depth = 10;
		end
		]]
		self:UpdateSkinColor();
		
		self.cardTypeTrans.gameObject:SetActive(false);
	else
		--[[if(cardType == 1 or cardType == 2 or cardType == 4 or cardType == 6)then
			cardsList = this:orderCards(cardsList, cardType);
		end]]
		self.cardTypeTrans.gameObject:SetActive(true)
		
		self.cardsTrans.gameObject:SetActive(true)
		for key,v in ipairs(self.cardsArray) do
			v.gameObject:SetActive(true)
			v.spriteName = self._cardPre..cardsList[key];
			--v.spriteName = self._cardPre..cardsList[#(self.cardsArray) + 1 - key];
			if tonumber(cardsList[key]) < 52 then
			--if tonumber(cardsList[#(self.cardsArray)-key+1]) < 52 then
				local cardcount = tonumber(cardsList[key])+1;
					--local cardcount = tonumber(cardsList[#(self.cardsArray)-key+1])+1;
					if cardcount==13 then
						cardcount=0;
					elseif cardcount==26 then
						cardcount=13;
					elseif cardcount==39 then
						cardcount=26;
					elseif cardcount==52 then
						cardcount=39;
					end
					v.spriteName = self._cardPre..tostring(cardcount)
				else
					--v.spriteName = self._cardPre..cardsList[#(self.cardsArray)-key+1];
					v.spriteName = self._cardPre..cardsList[key];
				end
		end
		local cardTypeSprite = self.cardTypeSprite;
		local tTypeBG = self.cardTypeSprite.gameObject.transform:FindChild('bg'):GetComponent('UISprite')
		tTypeBG.spriteName = 'bg_type' 
		--self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		if tonumber(cardType)>=0 then
			--[[
			for key,v in ipairs(self.cardsArray) do
				v.gameObject.transform.localPosition = Vector3.New((key - 2) * self._cardInterval, 0, 0);
			end
			
			if self.parentX > 0 then
				self.cardsTrans.localPosition = Vector3.New(180, -15, 0);
				self.cardTypeTrans.localPosition = Vector3.New(180, -50, 0);
			else
				self.cardsTrans.localPosition = Vector3.New(-220,-15, 0);
				self.cardTypeTrans.localPosition = Vector3.New(-220,-50, 0);
			end
			]]
			cardTypeSprite.spriteName = "type_"..tostring(cardType);
			--cardTypeSprite.depth = 18;
			
			if cardType == 1 then
			--[[
				self.cardsArray[1].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[1].transform.localPosition);
				self.cardsArray[2].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[2].transform.localPosition);
				]]
				self.cardsTransAniam:Play("animaTypePair");
			elseif cardType == 2 or  cardType == 7 then
			--[[
				self.cardsArray[1].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[1].transform.localPosition);
				self.cardsArray[2].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[2].transform.localPosition);
				self.cardsArray[3].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[3].transform.localPosition);
				self.cardsArray[4].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[4].transform.localPosition);
				]]
				self.cardsTransAniam:Play("TBNNPlayerShowCards3");
			elseif cardType == 3 then
			--[[
				self.cardsArray[1].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[1].transform.localPosition);
				self.cardsArray[2].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[2].transform.localPosition);
				self.cardsArray[3].transform.localPosition = Vector3.New(-15, 0, 0):Add(self.cardsArray[3].transform.localPosition);
				]]
				self.cardsTransAniam:Play("TBNNPlayerShowCards2");
			elseif cardType == 4 or  cardType == 5 or   cardType == 8 or cardType == 9 then
				--[[
				self.cardsArray[1].transform.localPosition = Vector3.New(0, 0, 0):Add(self.cardsArray[1].transform.localPosition);
				self.cardsArray[2].transform.localPosition = Vector3.New(0, 0, 0):Add(self.cardsArray[2].transform.localPosition);
				self.cardsArray[3].transform.localPosition = Vector3.New(0, 0, 0):Add(self.cardsArray[3].transform.localPosition);
				self.cardsArray[4].transform.localPosition = Vector3.New(0, 0, 0):Add(self.cardsArray[4].transform.localPosition);
				self.cardsArray[5].transform.localPosition = Vector3.New(0, 0, 0):Add(self.cardsArray[5].transform.localPosition);
				]]
			else
				tTypeBG.spriteName = 'bg_type1' 
			end
			
		end
	end
end

function this:orderCards(cardsList, cardType)
	local result = {};
	if(#cardsList ~= 3)then return;end;
	if(cardType == 1)then --对
		if(tonumber(cardsList[1])%13 ~= tonumber(cardsList[2])%13 and tonumber(cardsList[1])%13 ~= tonumber(cardsList[3])%13)then
			table.insert(result, cardsList[2]);
			table.insert(result, cardsList[3]);
			table.insert(result, cardsList[1]);
		elseif( tonumber(cardsList[2])%13 ~= tonumber(cardsList[1])%13 and tonumber(cardsList[2])%13 ~= tonumber(cardsList[3])%13 )then
			table.insert(result, cardsList[1]);
			table.insert(result, cardsList[3]);
			table.insert(result, cardsList[2]);
		end
	elseif(cardType == 2 or cardType == 4 or cardType == 6)then --顺子
		for i=1,3 do
			for j=i,3 do
				if(tonumber(cardsList[j])>tonumber(cardsList[j+1]) )then
					local temp = cardsList[j];
					cardsList[j] = cardsList[j+1];
					cardsList[j+1] = temp;
				end
			end
		end
		result = cardsList;
	end
	return cardsList;
end

function this:SetUserChip(TheChip)
	self.UserChip = TheChip;
        self:SetScore(-1);
end
function this:SetScore(score)

	--[[
	local sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true));
	if self.cardScoreBg then 
		--self.cardScoreBg.width = 557;
	else
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			destroy(sprite.gameObject);
		end
	end
	
	if sprites.Length > 1 then
		for i=0,sprites.Length-1 do
			if self.cardScoreBg then 
				local sprite = sprites[i];
				if sprite.gameObject ~= self.cardScoreBg.gameObject then
					destroy(sprite.gameObject);
				end
			else
				destroy(sprite.gameObject);
			end
		end
	end
	]]
	if self.cardScoreBg then 
		if tonumber(score) ==-1 then
			--self.cardScoreBg.spriteName =  "tbwz_59"  --"score_board"
			--EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform, tostring(self.UserChip), "plus_", 0.8);
			self.cardScoreNum.gameObject:SetActive(true);
			self.cardScoreNum.text =  tostring(self.UserChip)
			self.cardScoreWin.text = "";
			self.cardScoreLose.text ="";	
		else
			--[[
			if (tonumber(score)>=1000000) or (tonumber(score)<=-1000000) then
				--self.cardScoreBg.width = 300;
			end
			if tonumber(score)>=0 then
				--self.cardScoreBg.spriteName = "tbwz_59"  --"benjia"
				--EginTools.AddNumberSpritesCenter(self.jettonPrefab,self.cardScoreObj.transform,"+"..score,"plus_",0.8);
				self.cardScoreNum.text =  "+"..score
			elseif tonumber(score)<0 then
				--self.cardScoreBg.spriteName =  "tbwz_59"  --"benjia_minus"
				--EginTools.AddNumberSpritesCenter(self.jettonPrefab,self.cardScoreObj.transform,score,"minus_",0.8);
				self.cardScoreNum.text =  tostring(score)
			end
			]]
			self.cardScoreNum.gameObject:SetActive(false);
			if tonumber(score)>=0 then			
				self.cardScoreWin.text = "+"..score;		
			elseif tonumber(score)<0 then
				self.cardScoreLose.text =tostring(score);
			end
		end
	end
	
end

function this:SetBet(jetton)
   
end
function this:SetReady(toShow)
	if not IsNil(self.readyObj)  then
		if toShow then
			self.readyObj:SetActive(true);
			if not IsNil(self.waitObj) then
				self.waitObj:SetActive(false);
			end
		else
			self.readyObj:SetActive(false);
		end
	end
end
function this:SetShow(toShow)
    if not IsNil(self.showObj) then
		if toShow then
			self.showObj:SetActive(true);
		else
			self.showObj:SetActive(false);
		end
	end
end
function this:SetWait(toShow)
    if not IsNil(self.waitObj) then
		if toShow then
			self.waitObj:SetActive(true);
		else
			self.waitObj:SetActive(false);
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

function this:HideWinOrLoseCount()
	self.WinIconAnima:SetActive(false)
    self.AddNumAnima.gameObject:SetActive(false)
	self.MinusNumAnima.gameObject:SetActive(false)
	self.cardTypeTrans.gameObject:SetActive(false)
	self.cardsTrans.gameObject:SetActive(false)
	self.showObj:SetActive(false);
end
