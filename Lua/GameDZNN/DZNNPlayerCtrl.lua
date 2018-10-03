local this = LuaObject:New()
DZNNPlayerCtrl = this

function this:New( gameObj )
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj.gameObject = gameObj
	obj.transform  = gameObj.transform
	obj:Awake()
	obj:Start()
	return obj;
end
--const
this._cardInterval = 40
this._cardPre  = "card_"
this._timeInterval = 3
this.Const_T_Side_Offset = 84 -- -15

function this:init()
	print("DZNN game ctrl init")
	self._timeLasted = 0
	self.cardsTrans = self.transform:FindChild("Output/Cards")
		self.cardsTransAnima=self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");
	self.cardTypeTrans = self.transform:FindChild("Output/Cards/CardType")
	self.cardscoreParent=self.transform:FindChild("Output/CardScore").gameObject;
	self.cardScoreObj = self.transform:FindChild("Output/CardScore/CardScore").gameObject
	self.plusLabel = self.transform:FindChild("Output/CardScore/CardScore/win").gameObject:GetComponent("UILabel");
	self.minusLabel = self.transform:FindChild("Output/CardScore/CardScore/lose").gameObject:GetComponent("UILabel");
	

	if(self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) )then
		self.showObj = self.transform:FindChild("Output/Cards/Sprite_Over/Sprite_show").gameObject
		self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject
		self.readyObj  = self.transform:FindChild("PlayerInfo/Panel/Sprite_ready").gameObject
		self.waitObj   = self.transform:FindChild("PlayerInfo/Panel/Sprite_waitting").gameObject
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel");
		self.userIntomoney = self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");		
		self.kDetailLevel =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");

		self.bankerSprite = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject
		self.callBankerObj = self.transform:FindChild("PlayerInfo/Sprite_callBanker").gameObject
		self.jiangliMoney=nil;
		self.movePanel={};
		for i=1,8 do
			table.insert(self.movePanel,self.transform:FindChild("PlayerInfo/Label_bagmoney/bet_1/bet_"..i).gameObject);
		end
		self.chipParent=self.transform:FindChild("Output/chipBet").gameObject;
		self.movetarget=self.transform:FindChild("PlayerInfo/Label_bagmoney/bet").gameObject
	else
		self.readyObj  = self.transform:FindChild("Output/Sprite_ready").gameObject
		self.bankerSprite = self.transform:FindChild("Output/Sprite_banker").gameObject
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		self.jiangliMoney=self.transform:FindChild("Output/Label").gameObject:GetComponent("UILabel");
		local info = GameObject.Find("FootInfo");
		self.movePanel={};
		for i=1,8 do
			table.insert(self.movePanel,info.transform:FindChild("Foot - Anchor/Info/Money/Sprite_1/Sprite_"..i).gameObject);
		end
		self.chipParent= self.transform:FindChild("Output/chipBet").gameObject
		self.movetarget=info.transform:FindChild("Foot - Anchor/Info/Money/Sprite").gameObject;
	end
	
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");

	self.jettonPrefab = ResManager:LoadAsset("gamenn/prefabs","JettonPrefab") 

	if(self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) )then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject
		GameDZNN.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self)
	end
	
	self.cardsArray = {}
	for i=1,5 do
		table.insert(self.cardsArray,self.cardsTrans:FindChild("Sprite_"..i).gameObject:GetComponent("UISprite"));
	end
	
end

function this:clearLuaValue()
	self.gameObject = nil
	self.transform = nil
	
	self.cardsTrans = nil
	self.cardTypeTrans = nil
	self.cardScoreObj = nil
	self.cardsTransAnima=nil;
	self.movePanel=nil;
	self.chipParent=nil;
	self.movetarget=nil;

	self.plusLabel = nil
	self.minusLabel = nil

	self.showObj = nil
	self.bankerSprite = nil
	self.callBankerObj = nil
	self.infoDetail = nil
	self.readyObj  = nil
	self.waitObj   = nil
	self.userAvatar = nil
	self.userNickname = nil
	self.userIntomoney = nil
	self.kDetailNickname = nil	
	self.kDetailLevel =  nil
	self.kDetailBagmoney =  nil

	self.soundSend = nil
	self.xiazhu = nil
	self.jettonPrefab = nil
	--=======>
	self.chouma =nil
	self.choumaprefab = nil
	self.target = nil
	--<===========

	self.cardsArray = {}
	self.jiangliMoney=nil;
end

function this:Awake()
	print("DZNNPlayerCtrl -> Awake")
	self:init()

	self.parentX = self.cardsTrans.localPosition.x;
	self.parentY = self.cardsTrans.localPosition.y;
	self.parentZ = self.cardsTrans.localPosition.z;
end

function this:Start( )
	print("DZNNPlayerCtrl -> Start")
	self:UpdateSkinColor();
	if(self.cardScoreObj and self.cardTypeTrans and self.showObj and self.callBankerObj and self.infoDetail)then
		self.cardScoreP      = self.cardScoreObj.transform.localPosition;
		self.cardTypeP       = self.cardTypeTrans.localPosition;
		self.showP           = self.showObj.transform.localPosition;
		self.callBankerP     = self.callBankerObj.transform.localPosition;
		self.infoDetailP     = self.infoDetail.transform.localPosition;
	end

	local anchor = self.gameObject:GetComponent("UIAnchor");
	if(anchor.side == UIAnchor.Side.Right)then
		

	elseif( anchor.side == UIAnchor.Side.Top )then
		local outputAnchor=self.transform:FindChild("Output");
		outputAnchor.transform.localPosition=Vector3.New(-235,-320,0);
		--self.chipParent.transform.localPosition=Vector3.New(0,-500,0);
	elseif( anchor.side == UIAnchor.Side.Left )then
		
	end
end

--[[function this:Update()
	-- body
end--]]

function this:OnDestroy()
	self:clearLuaValue()
end

function this:UpdateSkinColor()
	for key,sprite in ipairs(self.cardsArray) do
		--local tempG = GlobalVar.SKIN_COLOR;
		sprite.spriteName = self._cardPre.."meihong";
	end
end

function this:SetPlayerInfo( avatar, nickname, intomoney, level )

	self.userAvatar.spriteName = "avatar_" .. avatar

	self.userNickname.text = nickname
	if(LengthUTF8String(self.userNickname.text)>5)then
		self.userNickname.text = SubUTF8String(self.userNickname.text,15) .. "..."
	end

	self.userIntomoney.text = EginTools.HuanSuanMoney(intomoney)
	self.kDetailNickname.text = nickname
	if(LengthUTF8String(self.userNickname.text)>5)then
		self.kDetailNickname.text = SubUTF8String(self.kDetailNickname.text,15) .. "..."
	end
	self.kDetailLevel.text = level
	--not need this, cause not show up at this time
	--self.kDetailBagmoney.text = intomoney ..""
end

function this:OnClickInfoDetail()
	print("OnClickInfoDetail")
	if(self.infoDetail.activeSelf)then
		self.infoDetail:SetActive(false)
		self._timeLasted = 0
	else
		self.infoDetail:SetActive(true)
		self.kDetailBagmoney.text = self.userIntomoney.text
	end
end

function this:UpdateInLua()
	if(self.infoDetail ~= nil and self.infoDetail.activeSelf)then
		--self._timeLasted = self._timeLasted + Time.deltaTime
		self._timeLasted = self._timeLasted + 0.5
		if(self._timeLasted >= this._timeInterval)then
			self.infoDetail:SetActive(false)
			self._timeLasted = 0
		end
	end
end

function this:UpdateIntoMoney( intomoney )
	if(self.userIntomoney == nil)then
		find("Label_Bagmoney"):GetComponent("UILabel").text = EginTools.HuanSuanMoney(intomoney)
	else
		self.userIntomoney.text = EginTools.HuanSuanMoney(intomoney)
	end
end

function this:SetBanker( toShow )
	if(toShow)then
		self.bankerSprite:SetActive(true)	
	else
		self.bankerSprite:SetActive(false)
	end
end

function this:SetDeal(toShow, infos)
	if(not toShow)then
		self.cardsTransAnima:Play("setcard_5");
	else
		local isown=false;
		for index,value in ipairs(self.cardsArray) do
			if(self.soundSend ~= nil)then
				--EginTools.PlayEffect(self.soundSend)
			end
			if(infos ~= nil and #(infos)> 0)then
				value.spriteName = this._cardPre .. infos[index]
				isown=true;
			end
			coroutine.wait(0.1)
			if self.gameObject==nil then
				return;
			end	
		end
		if self.chipParent.activeSelf or self.bankerSprite.activeSelf then
			self.cardsTransAnima.enabled=true;
			 if isown then
				self.cardsTransAnima:Play("setcard_1");
			else
					local count = math.random(8,11);
					self.cardsTransAnima:Play("setcard_"..count);
			end
		end
		for i=1,8 do
			self.movePanel[i].transform.localPosition=Vector3.zero;
		end
	end

end

function this:SetLate( cards )
	for index,value in ipairs(self.cardsArray) do
		value.gameObject:SetActive(true)
		if( cards ~= nil and #(cards)>0 )then
			value.spriteName = this._cardPre .. cards[index]
		end
	end
	self.cardsTrans.gameObject:SetActive(true);
	self.cardsTransAnima.enabled=true;
	self.cardsTransAnima:Play("setcard_6");
end

function this:SetCardTypeUser( cardsList, cardType,isgold )

	if(cardsList == nil)then
		--后两张牌移回原位并且显示牌背面
		self.cardTypeTrans.gameObject:SetActive(false)
		local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		cardTypeSprite.gameObject:SetActive(false);
		gold_type:SetActive(false);
	else
		self.cardTypeTrans.gameObject:SetActive(true)
		for index,value in ipairs(self.cardsArray) do
			value.spriteName = this._cardPre .. cardsList[index]
		end


		local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		local cardTypeNum = tonumber(cardType)
		if cardTypeNum == 0 then
			cardTypeSprite.spriteName="type_0";
			cardTypeSprite.gameObject:SetActive(true);
			self.cardsTransAnima:Play("setcard_3");
		else
			if isgold==1 then
				gold_type:SetActive(true);
				cardTypeSprite.gameObject:SetActive(false);
				local huangjin=gold_type.transform:FindChild("Sprite_1"):GetComponent("UISprite");
				local niuniu=gold_type.transform:FindChild("Sprite_2"):GetComponent("UISprite");
				huangjin.spriteName="type_15";
				niuniu.spriteName="type_10";
			else
				cardTypeSprite.spriteName = "type_"..cardType;
				cardTypeSprite.gameObject:SetActive(true);
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



function this:SetCardTypeOther( cardsList, cardType,isgold )
	if(cardsList == nil)then
		--后两张牌移回原位并且显示牌背面
		self:UpdateSkinColor()
		self.cardTypeTrans.gameObject:SetActive(false)
		local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		cardTypeSprite.gameObject:SetActive(false);
		gold_type:SetActive(false);
	else
		self.cardTypeTrans.gameObject:SetActive(true)
		for index,value in ipairs(self.cardsArray) do
			value.spriteName = this._cardPre .. cardsList[index]
		end
		local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		local cardTypeNum = tonumber(cardType)
		--显示牌型和牛几
		if(cardTypeNum == 0)then
			cardTypeSprite.spriteName="type_0";
			cardTypeSprite.gameObject:SetActive(true);
			self.cardsTransAnima:Play("setcard_3");
		else
			if isgold==1 then
				cardTypeSprite.gameObject:SetActive(false);
				gold_type:SetActive(true);
				local huangjin=gold_type.transform:FindChild("Sprite_1"):GetComponent("UISprite");
				local niuniu=gold_type.transform:FindChild("Sprite_2"):GetComponent("UISprite");
				huangjin.spriteName="type_15";
				niuniu.spriteName="type_10";
			else
				cardTypeSprite.spriteName = "type_"..cardType;
				cardTypeSprite.gameObject:SetActive(true);	
			end
			self.cardsTransAnima:Play("setcard_4");
		end
	end

end

function this:SetScore( score,targetPosition,isown )
	if(tonumber(score) == -1)then
		self.cardScoreObj:SetActive(false)
		self.cardscoreParent:SetActive(false);
	else
		if self.cardScoreObj~=nil then
			self.cardScoreObj:SetActive(true)
			self.cardscoreParent:SetActive(true);
			if(tonumber(score) >= 0)then
				self.plusLabel.gameObject:SetActive(true)
				self.minusLabel.gameObject:SetActive(false)
				self.plusLabel.text ="+"  .. score
			elseif(tonumber(score)<0)then
				self.plusLabel.gameObject:SetActive(false)
				self.minusLabel.gameObject:SetActive(true)
				self.minusLabel.text = score
				self:MoveBet(targetPosition,isown);
				local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
				cardTypeSprite.spriteName="gray"..cardTypeSprite.spriteName;
				--[[
				local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
				local huangjin=gold_type.transform:FindChild("Sprite_1"):GetComponent("UISprite");
				local niuniu=gold_type.transform:FindChild("Sprite_2"):GetComponent("UISprite");
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
					iTween.MoveTo(self.movePanel[i],GameDZNN.mono:iTweenHashLua("path",pathse,"time", 1.2-temp*0.5,"easeType", iTween.EaseType.easeOutCubic));
					iTween.ScaleTo(self.movePanel[i],GameDZNN.mono:iTweenHashLua("scale",Vector3.New(1.2,1.2,1.2),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
					iTween.ScaleTo(self.movePanel[i],GameDZNN.mono:iTweenHashLua("scale",Vector3.New(1,1,1),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
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
function this:SetBet(jetton)
	if( (tonumber(jetton) > 0) and (not self.cardScoreObj.activeSelf) )then
		self.chipParent:SetActive(true);
		self.chipParent.transform:FindChild("BetLabel"):GetComponent("UILabel").text=tostring(jetton);
		self.readyObj.gameObject:SetActive(false);
		if self.waitObj~=nil then
			self.waitObj.gameObject:SetActive(false);
		end
	else
		self.chipParent:SetActive(false);
	end
end

function this:SetStartChip(parent, jetton)
	local sprites = parent:GetComponentsInChildren(Type.GetType("UISprite",true))
	if(sprites.Length > 1)then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i]
			if ( sprite.gameObject.name ~= "Sprite_bg" ) then
				destroy(sprite.gameObject);
			end
		end
	end

	if(tonumber(jetton) > 0)then
		EginTools.AddNumberSpritesCenter(self.jettonPrefab, parent.transform, tostring(jetton),"plus_", 0.8)
	else
		EginTools.AddNumberSpritesCenter(self.jettonPrefab, parent.transform, tostring(0),"plus_", 0.8)
		--self.cardScoreObj.gameObject:SetActive(false)
	end
end

function this:SetReady(toShow)

	if(toShow and (not self.readyObj.activeSelf) )then
		self.readyObj:SetActive(true)
	else
		self.readyObj:SetActive(false)
	end

end

function this:SetShow(toShow)
	if(self.showObj ~= nil)then
		if(toShow and (not self.showObj.activeSelf))then
			self.showObj:SetActive(true)
		else
			self.showObj:SetActive(false)
		end
	end

end

function this:SetCallBanker(toShow)
	if(self.callBankerObj ~= nil)then
		if(toShow and (not self.callBankerObj.activeSelf ) )then
			self.callBankerObj:SetActive(true)
		else
			self.callBankerObj:SetActive(false)
		end
	end
end

function this:SetWait( toShow)
	if(self.waitObj ~= nil)then
		if(toShow and (not self.waitObj.activeSelf))then
			self.waitObj:SetActive(true)
		else
			self.waitObj:SetActive(false)
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
