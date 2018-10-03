
local this = LuaObject:New()
TBNNPlayerCtrl = this



	
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
	self.cardscoreParent=nil;
	--self.cardScoreBg =nil
	self.winMoney=nil;
	self.loseMoney=nil;
		
	self.soundSend =nil	
	self.jettonPrefab = nil
	self.xiazhu = nil
	
	self.background = 0;
	self.choumaprefab = nil
	self.target = 0;
	self.movetarget=nil;
	self.movePanel=nil;
	
	self.cardsArray = nil;	
	self.jiangliMoney=nil;
	self.anchorRight=false;
end
function this:Init()
--初始化变量
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	self._cardInterval = 40;
	self._cardPre = "card_";
	self._timeInterval = 1.2;
	self._timeLasted = 0;
	self.chouma = nil;	
	self._alive = false;
	self._cardData = nil;
	self.anchorRight=false;

	self.MyMoney = 0
	
	self.position = GlobalVar.PlayerPosition.Down;
	self.cardTypeTrans = self.transform:FindChild("Output/Cards/CardType")--比牌结果	
	if self.gameObject.name == "User" then
		self.readyObj = self.transform:FindChild("Output/Sprite_ready").gameObject
		
		self.showObj =nil
		self.waitObj = nil
		self.userAvatar = nil
		self.userNickname = nil
		
		self.infoDetail = nil	
		self.kDetailNickname = nil		
		self.kDetailLevel =  nil
		self.kDetailBagmoney =  nil
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		self.jiangliMoney=self.transform:FindChild("Output/Label").gameObject:GetComponent("UILabel");
		

		local info = GameObject.Find("FootInfo");
		self.movetarget=info.transform:FindChild("Foot - Anchor/Info/Money/Sprite").gameObject;
		self.userIntomoney = info.transform:FindChild("Foot - Anchor/Info/Money/Label_Bagmoney").gameObject:GetComponent("UILabel");
		self.movePanel={};
		for i=1,12 do
			table.insert(self.movePanel,info.transform:FindChild("Foot - Anchor/Info/Money/Sprite_1/Sprite_"..i).gameObject);
		end
		--log(self.movetarget.transform.parent.gameObject.name);
		--log(self.movetarget.transform.parent.parent.gameObject.name);

	else
		--提示字“准备”
		self.readyObj = self.transform:FindChild("PlayerInfo/Panel/Sprite_ready").gameObject
		self.showObj =self.transform:FindChild("Output/Cards/Sprite_Over/Sprite_show").gameObject		--提示字"摊牌"
		self.waitObj = self.transform:FindChild("PlayerInfo/Panel/Sprite_waitting").gameObject		--提示字"等待中"
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite")	-- 玩家头像	
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel")	--玩家昵称
		self.userIntomoney =self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");	--玩家带入金额
		self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject;	
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");		
		self.kDetailLevel =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");	
		self.jiangliMoney=nil;
		self.movetarget=self.transform:FindChild("PlayerInfo/Label_bagmoney/bet").gameObject
		self.movePanel={};
		for i=1,12 do
			table.insert(self.movePanel,self.transform:FindChild("PlayerInfo/Label_bagmoney/bet_1/bet_"..i).gameObject);
		end
	end
	
	
		
	self.cardsTrans = self.transform:FindChild("Output/Cards")		--扑克牌的父物体
	self.cardsTransAnima=self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");
	
	self.cardscoreParent=self.transform:FindChild("Output/CardScore").gameObject;
	self.cardScoreObj = self.transform:FindChild("Output/CardScore/CardScore").gameObject;		--玩家得分
	--self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");	
	self.winMoney=self.cardScoreObj.transform:FindChild("win").gameObject:GetComponent("UILabel");
	self.loseMoney=self.cardScoreObj.transform:FindChild("lose").gameObject:GetComponent("UILabel");

		
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");		
	self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab") -- resLoad("Prefabs/JettonPrefab");
	self.xiazhu = ResManager:LoadAsset("gamenn/Sound","xiazhu") --resLoad("Sound/xiazhu");	
	
	self.background = 0;
	--self.choumaprefab = ResManager:LoadAsset("gamenn/chouma","chouma"); --resLoad("Prefabs/chouma");
	self.target = 0;
	
	self.cardsArray = {};		--玩家的扑克牌(排序后)
	for i=1,5 do
		table.insert(self.cardsArray,self.cardsTrans:FindChild("Sprite_"..i).gameObject:GetComponent("UISprite"));
	end
	--[[
	for i=0,self.cardsTrans.childCount-1  do
		local card = self.cardsTrans:GetChild(i).gameObject;
		if card.name == "Sprite" then
			table.insert(self.cardsArray,card:GetComponent("UISprite"));	
		end
	end
	]]
end
function this:Awake()
	
	self:Init();

	
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject
		GameTBNN.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
	end
	------------逻辑代码------------
	self.parentX = self.cardsTrans.localPosition.x
	self.parentY = self.cardsTrans.localPosition.y
	self.parentZ = self.cardsTrans.localPosition.z
	
end

function this:Start()
	
	self:UpdateSkinColor();
	
	if self.cardscoreParent and self.cardTypeTrans and self.showObj and  self.infoDetail  then
		self.cardScoreP = self.cardscoreParent.transform.localPosition;
        self.cardTypeP = self.cardTypeTrans.localPosition;
        self.showP = self.showObj.transform.localPosition;
        self.infoDetailP = self.infoDetail.transform.localPosition;
	end
	
	local anchor = self.gameObject:GetComponent("UIAnchor");

	if anchor.side == UIAnchor.Side.BottomRight then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(-500,0,0);
			self.anchorRight=true;
			--[[
            self.parentX = -270;
            self.cardsTrans.localPosition =  Vector3.New(self.parentX, self.parentY, self.parentZ);
            self.cardscoreParent.transform.localPosition = Vector3.New(-self.cardScoreP.x - 8, self.cardScoreP.y + 19.7, self.cardScoreP.z);
            self.cardTypeTrans.localPosition = Vector3.New(-self.cardTypeP.x + 13, self.cardTypeP.y, self.cardTypeP.z);
            self.showObj.transform.localPosition = Vector3.New(-self.showP.x - 15, self.showP.y, self.showP.z);
            self.infoDetail.transform.localPosition = Vector3.New(-self.infoDetailP.x, self.infoDetailP.y, self.infoDetailP.z);
            self.readyObj.transform.localPosition = Vector3.New(-self.readyObj.transform.localPosition.x, self.readyObj.transform.localPosition.y, 0);
			self.waitObj.transform.localPosition = self.readyObj.transform.localPosition
			]]
	elseif anchor.side == UIAnchor.Side.TopRight then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(-500,0,0);
			self.anchorRight=true;
			--[[
            self.parentX = -270;
            self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
            self.cardscoreParent.transform.localPosition = Vector3.New(-self.cardScoreP.x - 5, self.cardScoreP.y, self.cardScoreP.z);
            self.cardTypeTrans.localPosition = Vector3.New(-self.cardTypeP.x + 13, self.cardTypeP.y, self.cardTypeP.z);
            self.showObj.transform.localPosition = Vector3.New(-self.showP.x - 15, self.showP.y, self.showP.z);
            self.infoDetail.transform.localPosition = Vector3.New(-self.infoDetailP.x, self.infoDetailP.y, self.infoDetailP.z);
            self.readyObj.transform.localPosition = Vector3.New(-self.readyObj.transform.localPosition.x, self.readyObj.transform.localPosition.y, 0);
			
			self.waitObj.transform.localPosition =self.readyObj.transform.localPosition
			]]
    elseif anchor.side == UIAnchor.Side.Top then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(-235,-320,0);
			--[[
            self.cardscoreParent.transform.localPosition = Vector3.New(-self.transform.localPosition.x+140,self.transform.localPosition.y-100, 0);
            self.parentX = 245;
            self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
			]]
    elseif anchor.side == UIAnchor.Side.TopLeft then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(0,0,0);

            --self.parentX = 245;
            --self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
    elseif anchor.side == UIAnchor.Side.BottomLeft then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(0,0,0);
           	--self.parentX = 245;
            --self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
            --self.cardscoreParent.transform.localPosition = Vector3.New(self.cardScoreP.x + 3, self.cardScoreP.y + 19.7, self.cardScoreP.z);
            
	end
	
	self._alive = true;
end




--动态发牌时用
function this:SetLate(cards)
	self._cardData = cards;
	for key,v in ipairs(self.cardsArray) do
		if self._cardData and #(self._cardData) >0 then
			v.spriteName = self._cardPre..self._cardData[key]
		end
	end
	self.cardsTrans.gameObject:SetActive(true);
	self.cardsTransAnima.enabled=true;
	self.cardsTransAnima:Play("setcard_6");

	

end
function this:UpdateSkinColor()
    for key,sprite in ipairs(self.cardsArray) do
		sprite.spriteName = self._cardPre.."yellow";
		
	end
end


function this:SetPlayerInfo(avatar, nickname, intomoney, level)
    if avatar == 0 then
		self.userAvatar.spriteName = "avatar_"..(avatar+2)
	else
		self.userAvatar.spriteName = "avatar_"..avatar
	end
	self.userNickname.text = nickname;

	
	
	if LengthUTF8String(self.userNickname.text)>5 then
		self.userNickname.text = SubUTF8String(self.userNickname.text,15);
	end
	--print('================= add  into money ==' .. intomoney)
	--self.userIntomoney.text = EginTools.NumberAddComma(intomoney)
	self.userIntomoney.text =EginTools.HuanSuanMoney(intomoney);

	self.MyMoney  = tonumber(intomoney)
	self.kDetailNickname.text = nickname;
	if LengthUTF8String(self.kDetailNickname.text) > 5 then
		self.kDetailNickname.text = SubUTF8String(self.kDetailNickname.text,15).."...";
	end
	
	self.kDetailLevel.text = level;
end

function this:OnClickInfoDetail()
	
    if self.infoDetail.activeSelf then
		self.infoDetail:SetActive(false);
		self._timeLasted = 0;
	else
		self.infoDetail:SetActive(true);
		
		self.kDetailBagmoney.text = self.userIntomoney.text;
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
		GameObject.Find("Label_Bagmoney"):GetComponent("UILabel").text = EginTools.HuanSuanMoney(intomoney);
		
	else
		--self.userIntomoney.text = EginTools.NumberAddComma(intomoney);
		self.userIntomoney.text =EginTools.HuanSuanMoney(intomoney);
	end
	
end

--发牌（带动画效果,需要在编辑器里将扑克牌的Active设为false）
function this:SetDeal(toShow, infos)
	self._cardData = infos;
	if not toShow then
		--for key,sprite in ipairs(self.cardsArray) do
			--sprite.gameObject:SetActive(false);
		--end
		self.cardsTransAnima:Play("setcard_5");
	else
		--[[
		local x = self.parentX + 2*self._cardInterval;
		self.cardsTrans.gameObject:SetActive(true);
		for key,v in ipairs(self.cardsArray) do
			EginTools.PlayEffect(self.soundSend);
			self.cardsTrans.localPosition = Vector3.New(x-self._cardInterval/2*key,self.parentY,self.parentZ);
			v.gameObject:SetActive(true);
			v.depth = 12+key;
			if self._cardData and #(self._cardData)>0 then
				v.spriteName = self._cardPre..self._cardData[key];
			end
			coroutine.wait(0.1)
			if self.gameObject==nil then
				return;
			end		
		end
		]]
		local isown=false;
		self.cardsTransAnima.enabled=true;
		for key,v in ipairs(self.cardsArray) do
			--EginTools.PlayEffect(self.soundSend);
			if self._cardData and #(self._cardData)>0 then
				v.spriteName = self._cardPre..self._cardData[key];
				isown=true;
			end
			coroutine.wait(0.1)
			if self.gameObject==nil then
				return;
			end		
		end
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
		for i=1,12 do
			self.movePanel[i].transform.localPosition=Vector3.zero;
		end
	end
end

--主玩家的比牌情况
function this:SetCardTypeUser(cardsList, cardType,isgold)
	self._cardData = cardsList;
    if self._cardData==nil then
		--[[
		for key,v in ipairs(self.cardsArray) do
			v.transform.localPosition = Vector3.New(-80 +key * self._cardInterval, 0, 0);
		end	
		self.cardsTrans.localPosition = Vector3.New(self.parentX,self.parentY,self.parentZ);
		]]
		self.cardTypeTrans.gameObject:SetActive(false);
		local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		cardTypeSprite.gameObject:SetActive(false);
		gold_type:SetActive(false);
	else
		self.cardTypeTrans.gameObject:SetActive(true)
		for key,v in ipairs(self.cardsArray) do
			v.spriteName = self._cardPre..self._cardData[key];
		end
		--local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		if tonumber(cardType)==0 then
			cardTypeSprite.spriteName="type_0";
			cardTypeSprite.gameObject:SetActive(true);
			--gold_type:SetActive(false);
			--cardTypeSprite.width=190;
			self.cardsTransAnima:Play("setcard_3");
		else
			--[[
			if tonumber(cardType)<=12 then
				self.cardsArray[1].transform.localPosition = Vector3.New(-60, 0, 0);
				self.cardsArray[2].transform.localPosition = Vector3.New(-20, 0, 0);
				self.cardsArray[3].transform.localPosition = Vector3.New(20, 0, 0);
				self.cardsArray[4].transform.localPosition = Vector3.New(90, 0, 0);
				self.cardsArray[5].transform.localPosition = Vector3.New(130, 0, 0);
            end
			]]
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
				--gold_type:SetActive(false);
				--if cardType>12 then
					--cardTypeSprite.width=274;
				--else
					--cardTypeSprite.width=190;
				--end	
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

--其他玩家的比牌情况
function this:SetCardTypeOther(cardsList, cardType,isgold)
self._cardData = cardsList;
    if self._cardData==nil then
		--[[
		for key,v in ipairs(self.cardsArray) do
			v.gameObject.transform.localPosition = Vector3.New((key - 2) * self._cardInterval, 0, 0);
		end
		self.cardsTrans.localPosition = Vector3.New(self.parentX,self.parentY,self.parentZ);
		self:UpdateSkinColor();
		]]
		self:UpdateSkinColor();
		self.cardTypeTrans.gameObject:SetActive(false);
		local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		cardTypeSprite.gameObject:SetActive(false);
		gold_type:SetActive(false);
	else
		self.cardTypeTrans.gameObject:SetActive(true)
		for key,v in ipairs(self.cardsArray) do
			--v.spriteName = self._cardPre..self._cardData[#(self.cardsArray) + 1 - key];
			v.spriteName = self._cardPre..self._cardData[key];
		end
		--local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		local cardTypeSprite=self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		local gold_type=self.cardTypeTrans.transform:FindChild("CardType_gold").gameObject;
		if tonumber(cardType)==0 then
			cardTypeSprite.spriteName="type_0";
			cardTypeSprite.gameObject:SetActive(true);
			--gold_type:SetActive(false);
			--cardTypeSprite.width=190;
			self.cardsTransAnima:Play("setcard_3");
		else
			--[[
			if tonumber(cardType)<=12 then
				self.cardsArray[1].transform.localPosition = Vector3.New(80, 0, 0);
				self.cardsArray[1].depth = 15;
				self.cardsArray[2].transform.localPosition = Vector3.New(120, 0, 0);
				self.cardsArray[2].depth = 16;
				self.cardsArray[3].transform.localPosition = Vector3.New(-70, 0, 0);
				self.cardsArray[3].depth = 12;
				self.cardsArray[4].transform.localPosition = Vector3.New(-30, 0, 0);
				self.cardsArray[4].depth = 13;
				self.cardsArray[5].transform.localPosition = Vector3.New(10, 0, 0);
				self.cardsArray[5].depth = 14;
			end
			]]
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
				--gold_type:SetActive(false);
				--if cardType>12 then
					--cardTypeSprite.width=274;
				--else
					--cardTypeSprite.width=190;
				--end	
			end
			self.cardsTransAnima:Play("setcard_4");
		end
	end
end

function this:SetScore(score,money,targetPosition,isown)
	--[[
    local sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true));
	self.cardScoreBg.width = 180;
	if sprites.Length > 1 then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			
			if sprite.gameObject ~= self.cardScoreBg.gameObject then
				destroy(sprite.gameObject);
			end
		end
		
	end
	]]
	if tonumber(score) ==-1 then
		self.cardscoreParent:SetActive(false);
		self.cardScoreObj:SetActive(false);
	else
		self.cardscoreParent:SetActive(true)
		if tonumber(score)>0 then
			self.winMoney.text="+"..tostring(score);
			self.winMoney.gameObject:SetActive(true);
			self.loseMoney.gameObject:SetActive(false);
		else
			self.loseMoney.text= tostring(score);
			self.winMoney.gameObject:SetActive(false);
			self.loseMoney.gameObject:SetActive(true);
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
		
		--if (tonumber(score)>=1000000) or (tonumber(score)<=-1000000) then
			--self.cardScoreBg.width = 220;
		--end	
		if money == nil then
			self.MyMoney =self.MyMoney  + tonumber(score) 
		else
			--log("使用新的==========="..money)
			self.MyMoney =tonumber(money);
		end
		if self.userIntomoney ~= nil then 
			--self.userIntomoney.text =EginTools.NumberAddComma(tostring(self.MyMoney))
			self.userIntomoney.text =EginTools.HuanSuanMoney(self.MyMoney);
		end

		--if tonumber(score)>=0 then
			--EginTools.AddNumberSpritesCenter(self.jettonPrefab,self.cardScoreObj.transform,"+"..score,"plus_",0.8);
			
		--elseif tonumber(score)<0 then
			--EginTools.AddNumberSpritesCenter(self.jettonPrefab,self.cardScoreObj.transform,score,"minus_",0.8);
			
		--end
		

		

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
		for   i = 1, 12 do	
			local temp = v;
			coroutine.start(self.AfterDoing,self,temp,function()
				if isown then
					--log(i.."=============zhi");
				end
				if self.movePanel[i]~=nil then
					self.movePanel[i]:SetActive(true);
					--iTween.MoveTo(self.movePanel[i],GameJQNN.mono:iTweenHashLua("path",pathse,"time", 1.2-temp*0.5,"easeType", iTween.EaseType.easeOutQuart));
					iTween.MoveTo(self.movePanel[i],GameTBNN.mono:iTweenHashLua("path",pathse,"time", 1.2-temp*0.5,"easeType", iTween.EaseType.easeOutCubic));
					iTween.ScaleTo(self.movePanel[i],GameTBNN.mono:iTweenHashLua("scale",Vector3.New(1.2,1.2,1.2),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
					iTween.ScaleTo(self.movePanel[i],GameTBNN.mono:iTweenHashLua("scale",Vector3.New(1,1,1),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
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
	--[[
    local sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true));
	
	if sprites.Length > 1 then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			
			if sprite.gameObject.name ~= "Sprite_bg" then
				destroy(sprite.gameObject);
			end
		end
		
	end
	
	if tonumber(jetton)==0 then
		self.cardScoreObj:SetActive(false);
	else
		self.cardScoreObj:SetActive(true)
		EginTools.AddNumberSpritesCenter(self.jettonPrefab,self.cardScoreObj.transform,jetton,"plus_",0.8);
	end
	]]
end
function this:SetReady(toShow)
	if not IsNil(self.readyObj)  then
		if toShow then
			self.readyObj:SetActive(true);
			self:SetWait(false)
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
function this:ChoumaPosition(sideposition, endTargetPosition)
	self.background = self.transform.parent.parent:FindChild("Panel_background"):FindChild("Sprite5_glow_black"):GetComponent("UITexture").transform;
	self.target = self.background:FindChild("target"):GetComponent("UISprite");
	sideposition = tostring(sideposition)
	local tempPosition = nil;
	if sideposition == "Top" then
		self.chouma = self.background:FindChild("Top").transform;
		tempPosition = self.background:FindChild("Top/Top").transform.localPosition;
		tempPosition = tempPosition:Add(self.chouma.localPosition);
      elseif sideposition == "TopLeft" then
    
        self.chouma = self.background:FindChild("TopLeft").transform;
		tempPosition = self.background:FindChild("TopLeft/TopLeft").transform.localPosition;
		tempPosition = tempPosition:Add(self.chouma.localPosition);
      elseif sideposition == "BottomLeft" then
    
        self.chouma = self.background:FindChild("BottomLeft").transform;
		tempPosition = self.background:FindChild("BottomLeft/BottomLeft").transform.localPosition;
		tempPosition = tempPosition:Add(self.chouma.localPosition);
      elseif sideposition == "BottomRight" then
   
        self.chouma = self.background:FindChild("BottomRight").transform;
		tempPosition = self.background:FindChild("BottomRight/BottomRight").transform.localPosition;
		tempPosition = tempPosition:Add(self.chouma.localPosition);
      elseif sideposition == "TopRight" then
  
        self.chouma = self.background:FindChild("TopRight").transform;
		tempPosition = self.background:FindChild("TopRight/TopRight").transform.localPosition;
		tempPosition = tempPosition:Add(self.chouma.localPosition);
	elseif sideposition == "Center" then
	
		self.chouma = self.background:FindChild("Center").transform;
		tempPosition = self.chouma.localPosition
	else
		self.chouma = self.background:FindChild("Center").transform;
		tempPosition = self.chouma.localPosition
    end

    local x = math.Random(-self.target.width * 0.5, self.target.width * 0.5);
    local y = math.Random(self.target.transform.localPosition.y - self.target.height * 0.5, self.target.transform.localPosition.y + self.target.height * 0.5);
		
    local count = math.Random(1, 5);
    local aa = GameObject.Instantiate(self.choumaprefab);
	local nameStr = "chouma_"..string.format("%.0f", count);
	
    aa.transform:GetComponent("UISprite").spriteName = nameStr;
    aa.transform.parent = self.background;
	
    aa.transform.localPosition = tempPosition;
    aa.transform.localScale = Vector3.New(1,1,1);
	
	local aaTween = aa:GetComponent("TweenPosition");
	aaTween.from = aa.transform.localPosition;
    aaTween.to = Vector3.New(x, y, 0);
    aaTween.duration = 0.3;
	
	local tempRun = function ()
		EginTools.PlayEffect(self.xiazhu);
		
		if not IsNil(aaTween) then
			destroy(aaTween);
		end
	end
	coroutine.start(self.AfterDoing,self,0.3,tempRun);
	
end

function this:AfterDoing(offset, run)
    coroutine.wait(offset);
	if self.gameObject==nil then
		return;
	end
	run();
end


