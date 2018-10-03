
local this = LuaObject:New()
FKTBDNPlayerCtrl = this



	
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
	self.cardTypeTrans_1 = nil	
	self.cardsTrans = nil
	self.cardsTrans_1 = nil
	self.cardScoreObj =nil
	self.cardScoreObj_1 =nil
	self.cardScoreBg =nil
	self.soundSend =nil	
	self.jettonPrefab = nil
	self.promptMessage = nil
	
	self.cardScoreP = nil;
        self.cardTypeP = nil;
        self.showP = nil;
        self.infoDetailP = nil;
	self.WinIconAnima = nil
	self.WinIconAnima_1=nil;
	self.AddNumAnima = nil
	self.MinusNumAnima = nil
	self.winNum=nil;
	self.loseNum=nil;
	self.winNum_1=nil;
	self.loseNum_1=nil;
	self.jiangliMoney=nil;
	
	self.cardsArray = nil;	
	self.cardsArray_1=nil;
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
	self.UserChip = 0;
	
	self.position = GlobalVar.PlayerPosition.Down;
	
	self.cardTypeTrans = self.transform:FindChild("Output/CardType")--比牌结果	
	self.cardTypeTrans_1 = self.transform:FindChild("Output/CardType_1")	
	self.cardTypeSprite = self.transform:FindChild("Output/CardType/Sprite").gameObject:GetComponent("UISprite");
	self.cardTypeSprite_1 = self.transform:FindChild("Output/CardType_1/Sprite").gameObject:GetComponent("UISprite");
	self.gold_type=self.transform:FindChild("Output/CardType_gold").gameObject;
	self.gold_type_1=self.transform:FindChild("Output/CardType_gold_1").gameObject;
	
	self.cardsTrans = self.transform:FindChild("Output/Cards")		--扑克牌的父物体
	self.cardsTrans_1 = self.transform:FindChild("Output/Cards_1")
	self.cardsTransAniam = self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");	--扑克牌的父物体
	self.cardsTransAniam_1 = self.transform:FindChild("Output/Cards_1").gameObject:GetComponent("Animator");
	self.cardScoreObj = self.transform:FindChild("Output/CardScore").gameObject		--玩家得分
	self.cardScoreObj_1 = self.transform:FindChild("Output/CardScore_1").gameObject
	self.winNum=self.cardScoreObj.transform:FindChild("AddNumAnima").gameObject:GetComponent("UILabel")		
	--log(self.winNum.gameObject.name);
	--log(self.gameObject.name);
	self.loseNum=self.cardScoreObj.transform:FindChild("MinusNumAnima").gameObject:GetComponent("UILabel")	
	self.winNum_1=self.cardScoreObj_1.transform:FindChild("AddNumAnima").gameObject:GetComponent("UILabel")		
	self.loseNum_1=self.cardScoreObj_1.transform:FindChild("MinusNumAnima").gameObject:GetComponent("UILabel")		
	
	
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");		
	self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab") -- resLoad("Prefabs/JettonPrefab");
	

	self.cardsArray = {};		--玩家的扑克牌(排序后)
	self.cardsArray_1={};
	for i=0,self.cardsTrans.childCount-1  do
		local card = self.cardsTrans:GetChild(i).gameObject;
		table.insert(self.cardsArray,card:GetComponent("UISprite"));	
	end
	for i=0,self.cardsTrans_1.childCount-1  do
	--log("11111111111111111"..i);
		local card = self.cardsTrans_1:GetChild(i).gameObject;
		table.insert(self.cardsArray_1,card:GetComponent("UISprite"));	
	end
	--log(#(self.cardsArray_1))
	if self.gameObject.name == "User" then
		self.readyObj = self.transform:FindChild("Output/Sprite_ready").gameObject
		self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
		self.cardScoreNum = self.transform:FindChild("Output/CardScore/Sprite_Num").gameObject:GetComponent("UILabel");
		self.cardScoreWin = self.transform:FindChild("Output/CardScore/Sprite_win").gameObject:GetComponent("UILabel");
		self.cardScoreLose = self.transform:FindChild("Output/CardScore/Sprite_lose").gameObject:GetComponent("UILabel");
		self.WinIconAnima = self.transform:FindChild("Output/WinIconAnima").gameObject 
		self.WinIconAnima_1 = self.transform:FindChild("Output/WinIconAnima_1").gameObject 
		local userInfo = GameObject.Find("FootInfo/Foot - Anchor/Info").transform
		--self.WinIconAnima = userInfo:FindChild("WinIconAnima").gameObject 
		self.AddNumAnima = userInfo:FindChild("NumAnima/AddNumAnima").gameObject:GetComponent("UILabel")	
		self.MinusNumAnima = userInfo:FindChild("NumAnima/MinusNumAnima").gameObject:GetComponent("UILabel")	
		self.jiangliMoney=self.transform:FindChild("Output/Label").gameObject:GetComponent("UILabel");
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
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject:GetComponent("UISprite")	-- 玩家头像	
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel")	--玩家昵称
		self.userIntomoney =self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");	--玩家带入金额
		self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject;	
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");		
		self.kDetailLevel =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");	
		self.cardScoreBg = nil
		self.WinIconAnima = self.transform:FindChild("Output/WinIconAnima").gameObject 
		self.WinIconAnima_1 = self.transform:FindChild("Output/WinIconAnima_1").gameObject 
		self.AddNumAnima = self.transform:FindChild("PlayerInfo/NumAnima/AddNumAnima").gameObject:GetComponent("UILabel")	
		self.MinusNumAnima = self.transform:FindChild("PlayerInfo/NumAnima/MinusNumAnima").gameObject:GetComponent("UILabel")	
		self.jiangliMoney=nil;
	end
	
	
	
end
function this:Awake()
	
	self:Init();

	
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject
		GameFKTBDN.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
	
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
function this:SetLate(cards,cards_1)
	self.cardsTrans.gameObject:SetActive(true);
	self.cardsTrans_1.gameObject:SetActive(true);
	for key,v in ipairs(self.cardsArray) do
		v.gameObject:SetActive(true);
		if cards and #(cards) >0 then			
			v.spriteName = self._cardPre..cards[key]
		end
	end
	for key,v in ipairs(self.cardsArray_1) do
		v.gameObject:SetActive(true);
		if cards_1 and #(cards_1) >0 then			
			v.spriteName = self._cardPre..cards_1[key]
		end
	end
end
function this:UpdateSkinColor()
    for key,sprite in ipairs(self.cardsArray) do
		sprite.spriteName = "card_gray"
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
function this:SetDeal(toShow,count, infos)
	if not toShow then		
		for key,sprite in ipairs(self.cardsArray) do
			sprite.gameObject:SetActive(false);
		end
		--log("隐藏牌");
		--log(#(self.cardsArray_1))
		for key,sprite_1 in ipairs(self.cardsArray_1) do
			sprite_1.gameObject:SetActive(false);
		end
		self.WinIconAnima:SetActive(false)
		if not IsNil(self.showObj) then
			self.showObj:SetActive(false);
		end
		self.WinIconAnima:SetActive(false)
		self.WinIconAnima_1:SetActive(false)
	else
		--local x = self.parentX + 2*self._cardInterval;
		--log("count")
		--log(count);
		--log(type(infos))
		--log(type(toShow))
		if count==1 then
		
		--log("一次发牌")
			self.cardsTrans.gameObject:SetActive(true);
			self.cardsTransAniam:Play("TBNNPlayer1");
			self.cardsTransAniam.enabled = false;  
			self.cardsTransAniam:Update(0);
			for key,v in ipairs(self.cardsArray) do
				 v.gameObject:SetActive(true);  
				 v.spriteName = "card_gray"
			end 
			self.cardsTransAniam.enabled = true;  	
			--for key,v in ipairs(self.cardsArray) do
				 --log(v.gameObject.activeSelf)
			--end 			
		else
		--log("二次发牌")
			self.cardsTrans_1.gameObject:SetActive(true);
			self.cardsTransAniam_1:Play("TBNNPlayer1");
			self.cardsTransAniam_1.enabled = false;  
			self.cardsTransAniam_1:Update(0);   
			coroutine.wait(0)
			for key,v in ipairs(self.cardsArray_1) do
				 v.gameObject:SetActive(true);  
				 v.spriteName = "card_gray"
			end 
			self.cardsTransAniam_1.enabled = true;  
			--for key,v in ipairs(self.cardsArray) do
				 --log(v.gameObject.activeSelf)
			--end 
		end
		
			
		
		if infos and #(infos)>0 then
			coroutine.wait(0.5)
			if self.gameObject==nil then
				return;
			end
			if count==1 then
				for key,v in ipairs(self.cardsArray) do  
					 iTween.ScaleTo(v.gameObject,iTween.Hash ("x", 0.000001,"time",0.12,"easeType", iTween.EaseType.linear));
				end
				
				coroutine.wait(0.17)
				if self.gameObject==nil then
					return;
				end
				  
				for key,v in ipairs(self.cardsArray) do  
					iTween.ScaleTo(v.gameObject,iTween.Hash ("x",1,"time",0.15,"easeType", iTween.EaseType.linear));					
					v.spriteName = self._cardPre..infos[key]

				end
			else
			    for key,v in ipairs(self.cardsArray_1) do  
					 iTween.ScaleTo(v.gameObject,iTween.Hash ("x", 0.000001,"time",0.12,"easeType", iTween.EaseType.linear));
				end
				
				coroutine.wait(0.17)
				if self.gameObject==nil then
					return;
				end
				  
				for key,v in ipairs(self.cardsArray_1) do  
					iTween.ScaleTo(v.gameObject,iTween.Hash ("x",1,"time",0.15,"easeType", iTween.EaseType.linear));					
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

function this:SetCardTypeUserScore(score,score_1,isown)
    --log(tonumber(score));
	--log(tonumber(score_1));
	--log("isown")
	--log(isown);
    if tonumber(score)>0 then
		self.winNum.gameObject:SetActive(true);
		self.loseNum.gameObject:SetActive(false);
		self.winNum.text="+"..tostring(score);	
		
		
		--self.winNum.text=tostring(score);
	else
		self.winNum.gameObject:SetActive(false);
		self.loseNum.gameObject:SetActive(true);
		self.loseNum.text=tostring(score);
		if isown then
			--log("自己1111");
			self.cardTypeTrans.transform:FindChild("TypeBGAnimation"):GetComponent("Animator").enabled=false;
			self.cardTypeTrans.transform:FindChild("TypeBGAnimation"):GetComponent("UISprite").spriteName="paixinggray_07";
		end
		
	end
	if tonumber(score_1)>0 then
		self.winNum_1.gameObject:SetActive(true);
		self.loseNum_1.gameObject:SetActive(false);
		self.winNum_1.text="+"..tostring(score_1);
		
		--self.winNum_1.text=tostring(score_1);
	else
		self.winNum_1.gameObject:SetActive(false);
		self.loseNum_1.gameObject:SetActive(true);
		self.loseNum_1.text=tostring(score_1);
		if isown then
		--log("自己22222");
			self.cardTypeTrans_1.transform:FindChild("TypeBGAnimation"):GetComponent("Animator").enabled=false;
			self.cardTypeTrans_1.transform:FindChild("TypeBGAnimation"):GetComponent("UISprite").spriteName="paixinggray_07";
		end
		
	end
	
	coroutine.wait(1);
	if self.winNum~=nil then
	--log("---------没有---------------");
		self.winNum.gameObject:SetActive(false);
		self.loseNum.gameObject:SetActive(false);
		self.winNum_1.gameObject:SetActive(false);
		self.loseNum_1.gameObject:SetActive(false);
	--log("------------有----------");
	end
end

--主玩家的比牌情况
function this:SetCardTypeUser(cardsList, cardType,cardsList_1,cardType_1,score,score_1,alreadyTanpai,isgold,isgold_1)
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
		self.cardTypeTrans_1.gameObject:SetActive(false);
		self.gold_type:SetActive(false);
		self.gold_type_1:SetActive(false);
		self.cardTypeTrans.gameObject:GetComponent("Animator").enabled=false;
		self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled=false;
		self.cardTypeTrans.transform:FindChild("TypeBGAnimation"):GetComponent("Animator").enabled=true;
		self.cardTypeTrans_1.transform:FindChild("TypeBGAnimation"):GetComponent("Animator").enabled=true;
		self.winNum_1.gameObject:SetActive(false);
		self.loseNum_1.gameObject:SetActive(false);
		self.winNum.gameObject:SetActive(false);
		self.loseNum.gameObject:SetActive(false);
	else
		--if self.cardTypeTrans.gameObject.activeSelf then
			--self:SetCardTypeUserScore(score,score_1,true);
			--return;
		--end
		if not alreadyTanpai then
			coroutine.start(self.SetCardTypeUserScore,self,score,score_1,true);
			return;
		end
		
		
		for key,v in ipairs(self.cardsArray) do				
				v.spriteName = self._cardPre..cardsList[key];
			
		end
		for key,v in ipairs(self.cardsArray_1) do
		    --[[
			if tonumber(cardsList_1[key]) < 52 then
				local cardcount = tonumber(cardsList_1[key])+1;
				
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
				v.spriteName = self._cardPre..cardsList_1[key];
			end
			]]
			v.spriteName = self._cardPre..cardsList_1[key];
		end
		
		
		
		
		if isgold==1 then
			self.gold_type:SetActive(true);
			self.cardTypeTrans.gameObject:SetActive(false)
			self.cardTypeTrans.gameObject:GetComponent("Animator").enabled=false;
		else
			self.gold_type:SetActive(false);
			self.cardTypeTrans.gameObject:SetActive(true)
			self.cardTypeTrans.gameObject:GetComponent("Animator").enabled=true;
		end
		if isgold_1==1 then
			self.gold_type_1:SetActive(true);
			self.cardTypeTrans_1.gameObject:SetActive(false)
			self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled=false;
		else
			self.gold_type_1:SetActive(false);
			self.cardTypeTrans_1.gameObject:SetActive(true)
			self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled=true;
		end
		
		
		if tonumber(score)~=0 then
			if self.cardTypeTrans.gameObject:GetComponent("Animator").enabled then
				if tonumber(score)>0 then	
					--log("最后摊牌赢11111");
					self.cardTypeTrans.gameObject:GetComponent("Animator"):Play("paixingAnim");
				else
				--log("最后摊牌输11111");
					self.cardTypeTrans.gameObject:GetComponent("Animator"):Play("paixingAnim_1");
				end
			end
		end
		
		if tonumber(score_1)~=0 then
			if self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled then
				if tonumber(score_1)>0 then
				--log("最后摊牌赢2222222");
					self.cardTypeTrans_1.gameObject:GetComponent("Animator"):Play("paixingAnim");
				else
				--log("最后摊牌输22222222");
					self.cardTypeTrans_1.gameObject:GetComponent("Animator"):Play("paixingAnim_1");
				end
			end
		end

--		self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
        			
		if 	self.cardTypeSprite then
			--if tonumber(cardType)<10 then
				self.cardTypeSprite.spriteName="type_"..tostring(cardType);
			--else
				--cardTypeSprite.spriteName="type_10";	
			--end
			if cardType == 0  or cardType>12 then
			    --log("1无牛");
				self.cardsTransAniam:Play("ShowCards");
			else	
				--log("1有牛");			
				self.cardsTransAniam:Play("UserShowCards1");			
			end		
				
		end	
		if 	self.cardTypeSprite_1 then
			--if tonumber(cardType_1)<10 then
				self.cardTypeSprite_1.spriteName="type_"..tostring(cardType_1);
			--else
				--cardTypeSprite_1.spriteName="type_10";	
			--end
			if cardType_1 == 0 or cardType_1>12 then
			    --log("2无牛");
				self.cardsTransAniam_1:Play("ShowCards");
			else
				--log("2有牛");					
				self.cardsTransAniam_1:Play("UserShowCards1");			
			end		
				
		end	
		
	end

	
end


function this:SetJiangLi(jiangliMoney,jiangliMoney_1)	
	local money=jiangliMoney+jiangliMoney_1;
	self.jiangliMoney.text="大奖"..money.."游戏币到银行了";
	self.jiangliMoney.gameObject:SetActive(true);
	coroutine.start(self.AfterDoing,self,2,function()
		 self.jiangliMoney.gameObject:SetActive(false);
	end); 
end

function this:SetCardWinAnimation(score,score_1,win_score,isown)  
	--log(score);
	if  score > 0 then  
		self.WinIconAnima:SetActive(true)
		self.WinIconAnima.transform:FindChild("Sprite").gameObject:GetComponent("UISpriteAnimation"):Play();
		--local winA = self.WinIconAnima
		self.WinIconAnima.transform:FindChild("Sprite").gameObject:GetComponent("UISpriteAnimation"):playWithCallback(Util.packActionLua(function (self)
			 self.WinIconAnima:SetActive(false)
		end,self)) 	
	end  
	if  score_1 > 0 then  
		self.WinIconAnima_1:SetActive(true)
		self.WinIconAnima_1.transform:FindChild("Sprite").gameObject:GetComponent("UISpriteAnimation"):Play();
		--local winA = self.WinIconAnima
		self.WinIconAnima_1.transform:FindChild("Sprite").gameObject:GetComponent("UISpriteAnimation"):playWithCallback(Util.packActionLua(function (self)
			 self.WinIconAnima_1:SetActive(false)
		end,self)) 	
	end  
	
	coroutine.wait(1);
	if isown then
		self:SetScore(win_score);
	else
	--log(win_score);
		if self.AddNumAnima~=nil then
			if self.AddNumAnima.gameObject and self.MinusNumAnima.gameObject then
				if  win_score > 0 then  
					--log("赢钱");		
						self.AddNumAnima.gameObject:SetActive(true)
						self.AddNumAnima.text = "+"..win_score		
						self.MinusNumAnima.gameObject:SetActive(false)
				else
					--log("输钱");			
						self.MinusNumAnima.gameObject:SetActive(true)
						self.MinusNumAnima.text = tostring(win_score)
						self.AddNumAnima.gameObject:SetActive(false)		
				end 
				coroutine.start(self.AfterDoing,self,3,function()	 
					self.AddNumAnima.gameObject:SetActive(false)
					self.MinusNumAnima.gameObject:SetActive(false)
				end); 
			end
		end
	end
end
--其他玩家的比牌情况
function this:SetCardTypeOther(cardsList, cardType,cardsList_1,cardType_1,score,score_1,isgold,isgold_1)
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
		self.cardTypeTrans_1.gameObject:SetActive(false);
		self.gold_type:SetActive(false);
		self.gold_type_1:SetActive(false);
		self.cardTypeTrans.gameObject:GetComponent("Animator").enabled=false;
		self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled=false;
		
		self.winNum.gameObject:SetActive(false);
		self.loseNum.gameObject:SetActive(false);
		self.winNum_1.gameObject:SetActive(false);
		self.loseNum_1.gameObject:SetActive(false);
		
	else
	    --log(#(cardsList));
		--log(#(cardsList_1));
		
		self.cardsTrans.gameObject:SetActive(true)	
		self.cardsTrans_1.gameObject:SetActive(true)
		
		if isgold==1 then
			self.gold_type:SetActive(true);
			self.cardTypeTrans.gameObject:SetActive(false)
			self.cardTypeTrans.gameObject:GetComponent("Animator").enabled=false;
		else
			self.gold_type:SetActive(false);
			self.cardTypeTrans.gameObject:SetActive(true)
			self.cardTypeTrans.gameObject:GetComponent("Animator").enabled=true;
		end
		if isgold_1==1 then
			self.gold_type_1:SetActive(true);
			self.cardTypeTrans_1.gameObject:SetActive(false)
			self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled=false;
		else
			self.gold_type_1:SetActive(false);
			self.cardTypeTrans_1.gameObject:SetActive(true)
			self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled=true;
		end
		
		
		--log("一");
		--log(score);
		if self.cardTypeTrans.gameObject:GetComponent("Animator").enabled then
			if tonumber(score)>0 then
				--log("赢");		
				self.cardTypeTrans.gameObject:GetComponent("Animator"):Play("paixingAnim");
			else
				--log("输");
				self.cardTypeTrans.gameObject:GetComponent("Animator"):Play("paixingAnim_1");
			end
		end
		--log("二");
		--log(score_1);
		if self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled then
			if tonumber(score_1)>0 then
				--log("赢");
				self.cardTypeTrans_1.gameObject:GetComponent("Animator"):Play("paixingAnim");
			else
				--log("输");
				self.cardTypeTrans_1.gameObject:GetComponent("Animator"):Play("paixingAnim_1");
			end
		end
		
		for key,v in ipairs(self.cardsArray) do
			v.gameObject:SetActive(true)
			v.spriteName = self._cardPre..cardsList[key];
			--v.spriteName = self._cardPre..cardsList[#(self.cardsArray)-key+1];
		end
		for key,v in ipairs(self.cardsArray_1) do
			v.gameObject:SetActive(true)
			v.spriteName = self._cardPre..cardsList_1[key];
			--v.spriteName = self._cardPre..cardsList_1[#(self.cardsArray_1)-key+1];
		end


		--self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		if tonumber(cardType)>=0 then
		    --if tonumber(cardType)<10 then
				self.cardTypeSprite.spriteName = "type_"..tostring(cardType);	
		    --else
				--cardTypeSprite.spriteName = "type_10";	
			--end
			self.cardsTransAniam.enabled = true;
			if cardType == 0 then
				self.cardsTransAniam:Play("TBNNPlayerShowCards1");
			else							
				self.cardsTransAniam:Play("TBNNPlayerShowCards2");			
			end				
		end			
		
		if tonumber(cardType_1)>=0 then
		    --if tonumber(cardType_1)<10 then			
				self.cardTypeSprite_1.spriteName = "type_"..tostring(cardType_1);
            --else
				--cardTypeSprite_1.spriteName = "type_10";
			--end
			self.cardsTransAniam_1.enabled = true;
			if cardType_1 == 0 then
				self.cardsTransAniam_1:Play("TBNNPlayerShowCards1");
			else			
				self.cardsTransAniam_1:Play("TBNNPlayerShowCards2");			
			end
			
		end
		coroutine.start(self.SetCardTypeUserScore,self,score,score_1,false);
	end
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
	--log("离开");
	self.WinIconAnima:SetActive(false)
	self.WinIconAnima_1:SetActive(false)
    self.AddNumAnima.gameObject:SetActive(false)
	self.MinusNumAnima.gameObject:SetActive(false)
	self.cardTypeTrans.gameObject:SetActive(false)
	self.cardTypeTrans_1.gameObject:SetActive(false)
	--log("离开1111111111111");
	self.cardTypeTrans.gameObject:GetComponent("Animator").enabled=false;
	self.cardTypeTrans_1.gameObject:GetComponent("Animator").enabled=false;
	self.cardsTrans.gameObject:SetActive(false)
	self.cardsTrans_1.gameObject:SetActive(false)
	--log("离开222222222");
	self.winNum.gameObject:SetActive(false)
	self.winNum_1.gameObject:SetActive(false)
	--log("离开3333333333");
	self.loseNum.gameObject:SetActive(false)
	self.loseNum_1.gameObject:SetActive(false)
	self.showObj:SetActive(false);
end
