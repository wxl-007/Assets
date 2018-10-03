
local this = LuaObject:New()
HPLZPlayerCtrl = this


	
function this:New(gameobj)
	local o ={};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
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
	
	
	self.position = nil;
	--/ 提示字“准备”
	self.readyObj = nil
	--/  提示字"摊牌"
	self.showObj = nil;
	--/ 提示字"叫庄中"
	self.callBankerObj = nil;
	--/  提示字"等待中"
	self.waitObj = nil;
	--/ 比牌结果
	self.cardTypeTrans = nil;
	--/ 玩家头像
	self.userAvatar = nil;
	--/ 玩家昵称
	self.userNickname = nil;
	--/ 玩家带入金额
	self.userIntomoney = nil;
	--/ 玩家的扑克牌(排序后)
	self.cardsArray = nil;
	--/ 扑克牌的父物体
	self.cardsTrans = nil;
	--/ 玩家得分
	self.cardScoreObj = nil;
	self.cardScoreBg = nil;
	self.bankerSprite = nil;
	self.bankerBg = nil;
	self.soundSend = nil;
	self.jettonPrefab = nil;
	self.infoDetail = nil;
	self.kDetailNickname = nil;
	self.kDetailLevel = nil;
	self.kDetailBagmoney = nil;
	
	
	
	--扑克牌父物体的位置
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	--/ 牌间距
	self._cardInterval = 40;
	self._cardPre = "card_";
	self._timeInterval = 3;
	self._timeLasted=0;
	self.cardScoreP = nil;
	self.cardTypeP = nil;
	self.showP = nil;
	self.callBankerP = nil;
	self.infoDetailP = nil;
	
end
function this:Init()
--初始化变量
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	self._cardInterval = 40;
	self._cardPre = "card_";
	self._timeInterval = 3;
	self._timeLasted=0;
	self.cardScoreP = nil;
	self.cardTypeP = nil;
	self.showP = nil;
	self.callBankerP = nil;
	self.infoDetailP = nil;
	
	
	self.position = GlobalVar.PlayerPosition.Down;
	if self.gameObject.name == "User" then
		self.readyObj = self.transform:FindChild("Output/Sprite_ready").gameObject
		self.bankerSprite = self.transform:FindChild("Output/Sprite_banker").gameObject;	
		
		self.showObj = nil;
		self.callBankerObj = nil;
		self.waitObj = nil;
		self.userAvatar = nil;
		self.userNickname = nil;
		self.userIntomoney = nil;
		self.bankerBg = nil;
		self.infoDetail = nil;
		self.kDetailNickname = nil;
		self.kDetailLevel = nil;
		self.kDetailBagmoney = nil;
	else
		self.readyObj = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_ready").gameObject
		self.showObj = self.transform:FindChild("Output/Sprite_show").gameObject;
		self.callBankerObj = self.transform:FindChild("Output/Sprite_callBanker").gameObject;
		self.waitObj = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_waitting").gameObject;
		
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel_Head/panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel");
		self.userIntomoney = self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");
		
		self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject;
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");
		self.kDetailLevel = self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney = self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");
		self.bankerBg = self.transform:FindChild("PlayerInfo/Sprite_headframe_banker").gameObject;
		self.bankerSprite = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject;	
	end
	
	self.cardTypeTrans = self.transform:FindChild("Output/CardType");
	self.cardsTrans = self.transform:FindChild("Output/Cards");
	self.cardScoreObj = self.transform:FindChild("Output/CardScore").gameObject;
	self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
	
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD");
	self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab");
	

	self.cardsArray = {};		--玩家的扑克牌(排序后)
	for i=0,self.cardsTrans.childCount-1  do
		local card = self.cardsTrans:GetChild(i).gameObject;
		if card.name == "Sprite" then
			table.insert(self.cardsArray,card:GetComponent("UISprite"));	
		end
	end
end
function this:Awake()
	
	self:Init();

	
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel_Head/panel/Sprite (avatar_6)").gameObject
		GameHPLZ.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
	else
		self.bankerSprite.transform.position = GameObject.Find("FootInfo2Prb(Clone)/FootInfo/Foot - Anchor/Info/Sprite_Avatar").gameObject.transform.position;
		self.bankerSprite.transform.localPosition = Vector3.New(self.bankerSprite.transform.localPosition.x+165,self.bankerSprite.transform.localPosition.y,self.bankerSprite.transform.localPosition.z);
	end
	------------逻辑代码------------
	self.parentX = self.cardsTrans.localPosition.x ;
	self.parentY = self.cardsTrans.localPosition.y;
	self.parentZ = self.cardsTrans.localPosition.z;	
end

function this:Start()
	self:UpdateSkinColor();
	if self.cardScoreObj and self.cardTypeTrans and self.showObj and  self.infoDetail and self.callBankerObj ~= nil   then
		self.cardScoreP = self.cardScoreObj.transform.localPosition;
		self.cardTypeP = self.cardTypeTrans.localPosition;
		self.showP = self.showObj.transform.localPosition;
		self.callBankerP = self.callBankerObj.transform.localPosition;
		self.infoDetailP = self.infoDetail.transform.localPosition;
	end
	local anchor = self.gameObject:GetComponent("UIAnchor");
	if anchor.side == UIAnchor.Side.Top then
		self.cardScoreObj.transform.localPosition = Vector3.New(76, -190, 0);
		self.parentX = 210;
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
       
	end
	self._alive = true;
end


--/ 换肤时更新扑克牌
function this:UpdateSkinColor()
	for key,sprite in ipairs(self.cardsArray) do
		sprite.spriteName = self._cardPre..GlobalVar.SKIN_COLOR;
	end
end

function this:SetPlayerInfo( avatar,  nickname,  intomoney,  level)
		self.userAvatar.spriteName = "avatar_"..avatar;
		self.userNickname.text = nickname;
		self.userIntomoney.text = "¥ "..EginTools.NumberAddComma(intomoney);
		self.kDetailNickname.text = nickname;
		self.kDetailLevel.text = level;
		self.kDetailBagmoney.text = intomoney;
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

function this:UpdateIntoMoney( intomoney)
      if self.userIntomoney==nil then
		GameObject.Find("Label_Bagmoney"):GetComponent("UILabel").text = EginTools.NumberAddComma(intomoney);
		
	else
		self.userIntomoney.text = "¥ "..EginTools.NumberAddComma(intomoney);
	end
end

function this:SetBanker( toShow)
	if toShow then
		self.bankerSprite:SetActive(true);
		if self.bankerBg ~= nil then self.bankerBg:SetActive(true); end
	else
		self.bankerSprite:SetActive(false);
		if self.bankerBg ~= nil then self.bankerBg:SetActive(false); end
	end
end

function this:SetDeal( toShow,  infos)
	if not toShow then
		self.cardsTrans.gameObject:SetActive(false);
		for key,sprite in ipairs(self.cardsArray) do
			sprite.gameObject:SetActive(false);
		end
	else
		self.cardsTrans.gameObject:SetActive(true);
		local x = self.parentX +self._cardInterval/2;

		if infos ~= nil and #(infos) > 0 then
			for key,v in ipairs(infos) do
				if v ~= nil then
					local cid = tonumber(v);
					if cid<52 then
						cid = cid+1;
					end
					
					if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end

					self.cardsTrans.localPosition = Vector3.New(x - self._cardInterval/2*(key-1), self.parentY, self.parentZ);
					self.cardsArray[key].gameObject:SetActive(true);
					self.cardsArray[key].spriteName = self._cardPre..tostring(cid);
				end

				coroutine.wait(0.2)
			end
		else 
			self:UpdateSkinColor ();
			local K=0;

			for key,sprite in ipairs(self.cardsArray) do
				if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end
				self.cardsTrans.localPosition = Vector3.New(x - self._cardInterval/2*K, self.parentY, self.parentZ);
				sprite.gameObject:SetActive(true);
				K=K+1;
				coroutine.wait(0.2)
			end
		end
	end
end

function this:SetLate( cards)
	self.cardsTrans.gameObject:SetActive (true);
	for key,v in ipairs(self.cardsArray) do
		v.gameObject:SetActive(true);
		if cards and #(cards) >0 then
			local cid = tonumber(cards[key]) ;
			if cid<52 then
				cid = cid+1;
			end
			v.spriteName = self._cardPre..tostring(cid);
		end
	end
end

--/ 主玩家的比牌情况
function this:SetCardTypeUser( cardsList, cardType)
	if cardsList==nil then
		--后两张牌移回原位并且显示牌背面
		for key,v in ipairs(self.cardsArray) do
			v.transform.localPosition = Vector3.New(-20 + (key-1) * self._cardInterval, 0, 0);
		end
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
		self.cardTypeTrans.gameObject:SetActive (false);
	else
		self.cardTypeTrans.gameObject:SetActive (true);

		for key,v in ipairs(self.cardsArray) do
			cid =  tonumber(cardsList[key]);
			if cid<52 then
				cid = cid+1;
			end
			v.spriteName = self._cardPre..tostring(cid);
		end
		local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
	
		--显示牌型和牛几
		for i=0,#(self.cardsArray)-1 do 
			self.cardsArray[#(self.cardsArray) - i].transform.localPosition = 
				Vector3.New(25 - (self._cardInterval+10) * i, 0, 0);
		end
		cardTypeSprite.spriteName = "lz"..cardType;
	end
end

--/ 其他玩家的比牌情况
function this:SetCardTypeOther( cardsList, cardType)
	if cardsList == nil then
		--后两张牌移回原位并且显示牌背面
		for key,v in ipairs(self.cardsArray) do
			v.gameObject.transform.localPosition = Vector3.New((key-3) * self._cardInterval, 0, 0);
		end
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
		self:UpdateSkinColor();
		self.cardTypeTrans.gameObject:SetActive (false);
	else
		self.cardTypeTrans.gameObject:SetActive (true);

		for i=0,#(self.cardsArray)-1 do
			cid = tonumber(cardsList[#(self.cardsArray) - i]) ;
			if cid<52 then
				cid = cid+1;
			end
			self.cardsArray[i+1].spriteName = self._cardPre..tostring(cid);

			self.cardsArray[i+1].transform.localPosition = Vector3.New((i-1) * (self._cardInterval+10)-30, 0, 0);
		end
		local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		--显示牌型和牛几
		self.cardTypeTrans.localPosition = Vector3.New(180, -60, 0);
		cardTypeSprite.spriteName = "lz"..cardType;	
	end
end

function this:SetScore(score)
	local  sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true));
	self.cardScoreBg.width = 180;
	if sprites.Length > 1 then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			
			if sprite.gameObject ~= self.cardScoreBg.gameObject then
				destroy(sprite.gameObject);
			end
		end	
	end
	
	if tonumber(score) ==-1 then
		self.cardScoreObj:SetActive(false);
	else
		self.cardScoreObj:SetActive(true);
		if (tonumber(score)>=1000000) or (tonumber(score)<=-1000000) then
			self.cardScoreBg.width = 220;
		end
		
		if tonumber(score)>=0 then
			EginTools.AddNumberSpritesCenter(self.jettonPrefab,self.cardScoreObj.transform,"+"..score,"plus_",0.8);
		elseif tonumber(score)<0 then
			EginTools.AddNumberSpritesCenter(self.jettonPrefab,self.cardScoreObj.transform,score,"minus_",0.8);
		end
	end
end

function this:SetBet(jetton)
	local  sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true));
	if sprites.Length > 1 then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			
			if sprite.gameObject.name ~= "Sprite_bg" then
				destroy(sprite.gameObject);
			end
		end
		
	end
	
	if tonumber(jetton)>0 and not self.cardScoreObj.activeSelf then
		self.cardScoreObj:SetActive(true);
		EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform,  tostring(jetton), "plus_",0.8);
	else
		self.cardScoreObj:SetActive(false);
	end
end

function this:SetStartChip( parent, jetton)
	local  sprites = parent:GetComponentsInChildren(Type.GetType("UISprite",true));
	if sprites.Length > 1 then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			
			if sprite.gameObject.name ~= "Sprite_bg" then
				destroy(sprite.gameObject);
			end
		end
		
	end
	
	if jetton>0 then
		EginTools.AddNumberSpritesCenter(self.jettonPrefab, parent.transform,  tostring(jetton), "plus_", 0.8);
	else
		self.cardScoreObj.gameObject:SetActive(false);
	end
end

function this:SetReady( toShow)
	if not IsNil(self.readyObj)  then
		if toShow and not self.readyObj.activeSelf then
			self.readyObj:SetActive(true);
		else
			self.readyObj:SetActive(false);
		end
	end
	
end

function this:SetShow( toShow)
    if not IsNil(self.showObj) then
		if toShow and not self.showObj.activeSelf then
			self.showObj:SetActive(true);
		else
			self.showObj:SetActive(false);
		end
	end
end

function this:SetCallBanker( toShow)
    if not IsNil(self.callBankerObj) then
		if toShow and not self.callBankerObj.activeSelf then
			self.callBankerObj:SetActive(true);
		else
			self.callBankerObj:SetActive(false);
		end
	end
end

function this:SetWait( toShow)
    if not IsNil(self.waitObj) then
		if toShow and not self.waitObj.activeSelf then
			self.waitObj:SetActive(true);
		else
			self.waitObj:SetActive(false);
		end
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

function this:AfterDoing(offset, run)
    coroutine.wait(offset);
	if self.gameObject==nil then
		return;
	end
	run();
end




