local this = LuaObject:New()
SRNNPlayerCtrl = this

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
this._timeInterval = 1.5

function this:init()
	--log(self.gameObject)
	--log(self.transform)
	self._timeLasted = 0
	self.cardsTrans = self.transform:FindChild("Output/Cards")
	self.cardsTransAnima=self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");
	self.cardTypeTrans = self.transform:FindChild("Output/Cards/CardType")

	self.cardscoreParent=self.transform:FindChild("Output/CardScore").gameObject;
	self.cardScoreObj = self.transform:FindChild("Output/CardScore/CardScore").gameObject
	--self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
	self.plusLabel = self.transform:FindChild("Output/CardScore/CardScore/win").gameObject:GetComponent("UILabel");
	self.minusLabel = self.transform:FindChild("Output/CardScore/CardScore/lose").gameObject:GetComponent("UILabel");
	self.anchorRight=false;
	if(self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) )then
		self.showObj = self.transform:FindChild("Output/Cards/Sprite_Over/Sprite_show").gameObject
		self.bankerSprite = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject
		self.callBankerObj = self.transform:FindChild("PlayerInfo/Sprite_callBanker").gameObject
		self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject
		self.readyObj  = self.transform:FindChild("PlayerInfo/Panel/Sprite_ready").gameObject
		self.waitObj   = self.transform:FindChild("PlayerInfo/Panel/Sprite_waitting").gameObject
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel");
		self.userIntomoney = self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");		
		self.kDetailLevel =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");
		self.jiangliMoney=nil;
		self.movePanel={};
		for i=1,24 do
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
		for i=1,24 do
			table.insert(self.movePanel,info.transform:FindChild("Foot - Anchor/Info/Money/Sprite_1/Sprite_"..i).gameObject);
		end
		self.chipParent= self.transform:FindChild("Output/chipBet").gameObject
		self.movetarget=info.transform:FindChild("Foot - Anchor/Info/Money/Sprite").gameObject;
	end

	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");
	self.xiazhu = ResManager:LoadAsset("gamenn/Sound","xiazhu") --resLoad("Sound/xiazhu");
	self.jettonPrefab = ResManager:LoadAsset("gamenn/prefabs","JettonPrefab") 

	--about chip ref value  ChoumaPosition(sidepositionm choumacount time)
	--=======>
	self.chouma =nil
	--self.choumaprefab = ResManager:LoadAsset("gamenn/chouma","chouma")
	self.target = nil
	--<===========

	if(self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) )then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject
		GameSRNN.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self)
	end

	self.cardsArray = {}
	for i=1,5 do
		table.insert(self.cardsArray,self.cardsTrans:FindChild("Sprite_"..i).gameObject:GetComponent("UISprite"));
	end
	self.tempCardList = {};
	self.jiesuanMoney=0;
end

function this:clearLuaValue()
	self.gameObject = nil
	self.transform = nil
	
	self.cardsTrans = nil
	self.cardsTransAnima=nil;
	self.cardTypeTrans = nil
	self.cardScoreObj = nil


	--self.cardScoreBg = nil

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
	self.movetarget=nil;
	self.anchorRight=false;
	--<===========

	self.cardsArray = {}
	self.jiangliMoney=nil;
	self.movePanel=nil;
	self.jiesuanMoney=0;
end

function this:Awake()
	--print("SRNNPlayerCtrl -> Awake")
	self:init()

	self.parentX = self.cardsTrans.localPosition.x;
	self.parentY = self.cardsTrans.localPosition.y;
	self.parentZ = self.cardsTrans.localPosition.z;
end

function this:Start( )
	--print("SRNNPlayerCtrl -> Start")
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
		self.anchorRight=true;
		local outputAnchor=self.transform:FindChild("Output");
		outputAnchor.transform.localPosition=Vector3.New(-500,18,0);
		--local betchipParent=self.transform:FindChild("PlayerInfo/chipBet");
		--self.chipParent.transform.localPosition=Vector3.New(-100,-250,0);
		self.callBankerObj.transform.localPosition=Vector3.New(-40,-260,0);
		--self.bankerSprite.transform.localPosition =Vector3.New(0,94,0);
	elseif( anchor.side == UIAnchor.Side.Top )then
		local outputAnchor=self.transform:FindChild("Output");
		outputAnchor.transform.localPosition=Vector3.New(-235,-320,0);
		--local betchipParent=self.transform:FindChild("PlayerInfo/chipBet");
		--self.chipParent.transform.localPosition=Vector3.New(0,-500,0);
	elseif( anchor.side == UIAnchor.Side.Left )then
		local outputAnchor=self.transform:FindChild("Output");
		outputAnchor.transform.localPosition=Vector3.New(0,18,0);
		--local betchipParent=self.transform:FindChild("PlayerInfo/chipBet");
		--self.chipParent.transform.localPosition=Vector3.New(100,-250,0);
		self.callBankerObj.transform.localPosition=Vector3.New(40,-260,0);
		--self.bankerSprite.transform.localPosition =Vector3.New(0,94,0);
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
		sprite.spriteName = self._cardPre.."green";
	end
end

function this:SetPlayerInfo( avatar, nickname, intomoney, level )
	if(tonumber(avatar) == 0)then
		self.userAvatar.spriteName = "avatar_" .. (avatar + 2);
	else
		self.userAvatar.spriteName = "avatar_" .. avatar
	end
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
end

function this:OnClickInfoDetail()
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
	if(self.gameObject == nil)then
		error("stop coroutine in start SetDeal")
		return
	end
	if(not toShow)then
		--for key,value in pairs(self.cardsArray) do
			--value.gameObject:SetActive(false)
		--end
		self.cardsTransAnima:Play("setcard_5");
	else
		--[[
		local x = self.parentX + 2*this._cardInterval
		self.cardsTrans.gameObject:SetActive(true)
		
		for index,value in ipairs(self.cardsArray) do
			--must be stop coroutine when this player quit 
			if(self.gameObject == nil)then
				error("stop coroutine in SetDeal")
				return
			end
			if(self.soundSend ~= nil)then
				EginTools.PlayEffect(self.soundSend)
				self.cardsTrans.localPosition = Vector3.New(x - this._cardInterval/2*(index-1), self.parentY, self.parentZ)
				value.gameObject:SetActive(true)
				value.depth = 12 + (index - 1)
				if(infos ~= nil and #(infos)> 0)then
					value.spriteName = this._cardPre .. self.tempCardList[index]
				end
			end
			coroutine.wait(0.1)
		end
		]]
		self.tempCardList = infos;
		local isown=false;
		for key,v in ipairs(self.cardsArray) do
			if infos ~= nil and #(infos)> 0 then
				v.spriteName = self._cardPre..self.tempCardList[key];
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
				if self.anchorRight then
					local count = math.random(12,13);
					self.cardsTransAnima:Play("setcard_"..count);
				else
					local count = math.random(8,11);
					self.cardsTransAnima:Play("setcard_"..count);
				end
			end
		end
		for i=1,24 do
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
		self.tempCardList = cardsList;
		self.cardTypeTrans.gameObject:SetActive(true)
		for index,value in ipairs(self.cardsArray) do
			value.spriteName = this._cardPre .. self.tempCardList[index]
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

function this:SetScore( score )
	--[[
	local sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite", true))
	self.cardScoreBg.width = 180
	if(sprites.Length > 1)then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			if ( sprite.gameObject ~= self.cardScoreBg.gameObject ) then
				destroy(sprite.gameObject);
			end
		end
	end
	]]
	self.jiesuanMoney=tonumber(score);
	if(tonumber(score) == -1)then
		self.cardScoreObj:SetActive(false)
		self.cardscoreParent:SetActive(false);
	else
		if self.cardScoreObj~=nil then
			--self.cardScoreObj:SetActive(true)
			self.cardscoreParent:SetActive(true);
			--if(tonumber(score) >= 1000000 or tonumber(score) <= -1000000)then
				--self.cardScoreBg.width = 220
			--end
			if(tonumber(score) >= 0)then
				--EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform, "+"..score, "plus_", 0.8)
				self.plusLabel.gameObject:SetActive(true)
				self.minusLabel.gameObject:SetActive(false)
				self.plusLabel.text ="+"  .. score
			elseif(tonumber(score)<0)then
				--EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform, tostring(score), "minus_", 0.8)
				self.plusLabel.gameObject:SetActive(false)
				self.minusLabel.gameObject:SetActive(true)
				self.minusLabel.text = score
			end
		end
	end

end

function this:ChoumaPosition( sideposition, choumacount, time )
	--print(" start ChoumaPosition")
	--must be stop coroutine when this player quit 
	if(self.gameObject == nil)then
		--error("stop coroutine in start ChoumaPosition")
		return
	end
	local background = self.transform.parent.parent:FindChild("Panel_background"):FindChild("Sprite5_glow_black"):GetComponent("UITexture").transform;
	self.target = background:FindChild("target"):GetComponent("UISprite")
	if(sideposition == "Top")then
		self.chouma = background:FindChild("Top").transform
	elseif(sideposition == "Left")then
		self.chouma = background:FindChild("Left").transform
	elseif(sideposition == "Right")then
		self.chouma = background:FindChild("Right").transform
	elseif(sideposition == "Center")then
		self.chouma = background:FindChild("Center").transform
	end
	--print(" progress ChoumaPosition")
	for i=0, tonumber(choumacount)-1 do
		local x = math.Random(-self.target.width*0.5, self.target.width*0.5)
		local y = math.Random(self.target.transform.localPosition.y - self.target.height*0.5, self.target.transform.localPosition.y + self.target.height*0.5)
		local count = math.Random(1,6)
		local chipObj = GameObject.Instantiate(self.choumaprefab)
		--string.format("%.0f", count);
		chipObj.transform:GetComponent("UISprite").spriteName = "chouma_" .. string.format("%.0f", count)
		chipObj.transform.parent = background
		chipObj.transform.localPosition = self.chouma.localPosition
		chipObj.transform.localScale = Vector3.New(1,1,1)
		local tween = chipObj:GetComponent("TweenPosition")
		tween.from = chipObj.transform.localPosition
		tween.to   = Vector3.New(x, y, 0)
		tween.duration = 0.3

		coroutine.wait(time)
		--must be stop coroutine when this player quit 
		if(self.gameObject == nil)then
			--error("stop coroutine in ChoumaPosition")
			return
		end
	end
	--print("end  ChoumaPosition")
end

function this:playsound()
	coroutine.wait(0.3)
	--must be stop coroutine when this player quit 
	if(self.gameObject == nil)then
		--error("stop coroutine in playsound")
		return
	end
	EginTools.PlayEffect(self.xiazhu)
end

function this:SetBet(jetton)
	--[[
	local sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true))
	if(sprites.Length > 1)then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i]
			
			if ( sprite.gameObject.name ~= "Sprite_bg" ) then
				destroy(sprite.gameObject);
			end
		end
	end
	]]
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

function this:SetFlyBetAnimation(positionList,uid)
	local isown=false;
	if uid==EginUser.Instance.uid then
		isown=true;
	end
	for i=1,#(positionList) do
		self:MoveBet(positionList[i],isown,i-1);
	end
	if self.jiesuanMoney<0 then
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



function this:MoveBet(targetPosition,isown,index)
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
		--[[
		for i=1,8 do
			if self.movePanel[i]~=nil then
				self.movePanel[i]:SetActive(true);
				iTween.MoveTo(self.movePanel[i],GameJQNN.mono:iTweenHashLua("path",pathse,"time", 1-0.01*i,"easeType", iTween.EaseType.easeInOutCubic));
				coroutine.start(self.AfterDoing,self,1,function()
					if self.movePanel[i]~=nil then
						self.movePanel[i]:SetActive(false);		
					end
				end); 
				coroutine.wait(0.01);
			end
		end
		]]
		local v = 0;	
		for   i=1+(8*index),8+(8*index) do	
			local temp = v;
			coroutine.start(self.AfterDoing,self,temp,function()
				if isown then
					--log(i.."=============zhi");
				end
				if self.movePanel[i]~=nil then
					self.movePanel[i]:SetActive(true);
					--iTween.MoveTo(self.movePanel[i],GameJQNN.mono:iTweenHashLua("path",pathse,"time", 1.2-temp*0.5,"easeType", iTween.EaseType.easeOutQuart));
					iTween.MoveTo(self.movePanel[i],GameSRNN.mono:iTweenHashLua("path",pathse,"time", 1.2-temp*0.5,"easeType", iTween.EaseType.easeOutCubic));
					iTween.ScaleTo(self.movePanel[i],GameSRNN.mono:iTweenHashLua("scale",Vector3.New(1.2,1.2,1.2),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
					iTween.ScaleTo(self.movePanel[i],GameSRNN.mono:iTweenHashLua("scale",Vector3.New(1,1,1),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
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
		self.cardScoreObj.gameObject:SetActive(false)
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
	coroutine.wait(offset)
	--must be stop coroutine when this player quit 
	if(self.gameObject == nil)then
		error("stop coroutine in AfterDoing")
		return
	end
	run()
end

