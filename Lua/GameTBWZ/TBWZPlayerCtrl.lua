
local this = LuaObject:New()
TBWZPlayerCtrl = this



	
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
	self.huangjiatonghua_gold=nil
	self.cardsTrans = nil
	self.cardScoreObj =nil
	self.soundSend =nil	
	self.jettonPrefab = nil
	self.promptMessage = nil
	
	self.cardScoreP = nil;
    self.cardTypeP = nil;
    self.showP = nil;
    self.infoDetailP = nil;
	self.anchorRight=false;
	self.jiangliMoney=nil;
	self.MyMoney = 0
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
	self.anchorRight=false;	
	self._alive = false;
	self.UserChip = 0;
	self.MyMoney = 0
	self.position = GlobalVar.PlayerPosition.Down;
	
	self.cardTypeTrans = self.transform:FindChild("Output/Cards/CardType")--比牌结果		
	self.cardTypeSprite = self.transform:FindChild("Output/Cards/CardType/Sprite").gameObject:GetComponent("UISprite");
	self.cardsTrans = self.transform:FindChild("Output/Cards")		--扑克牌的父物体
	self.cardsTransAnima = self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");	--扑克牌的父物体
	self.cardscoreParent=self.transform:FindChild("Output/CardScore").gameObject;
	self.cardScoreObj = self.transform:FindChild("Output/CardScore/CardScore").gameObject;		--玩家得分	
	self.winMoney=self.cardScoreObj.transform:FindChild("win").gameObject:GetComponent("UILabel");
	self.loseMoney=self.cardScoreObj.transform:FindChild("lose").gameObject:GetComponent("UILabel");

	self.huangjiatonghua_gold=self.transform:FindChild("Output/Cards/CardType/CardType_gold").gameObject
	
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");		
	self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab") -- resLoad("Prefabs/JettonPrefab");
	

	self.cardsArray = {};		--玩家的扑克牌(排序后)
	for i=1,5 do
		table.insert(self.cardsArray,self.cardsTrans:FindChild("Sprite_"..i).gameObject:GetComponent("UISprite"));
	end
	
	if self.gameObject.name == "User" then
		self.readyObj = self.transform:FindChild("Output/Sprite_ready").gameObject
		local userInfo = GameObject.Find("FootInfo/Foot - Anchor/Info").transform	
		self.jiangliMoney=self.transform:FindChild("Output/Label").gameObject:GetComponent("UILabel");
		
		self.showObj =nil
		self.waitObj = nil
		self.userAvatar = nil
		self.userNickname = nil
		self.infoDetail = nil	
		self.kDetailNickname = nil		
		self.kDetailLevel =  nil
		self.kDetailBagmoney =  nil
		local info = GameObject.Find("FootInfo");
		self.movetarget=info.transform:FindChild("Foot - Anchor/Info/Money/Sprite").gameObject;
		self.userIntomoney = info.transform:FindChild("Foot - Anchor/Info/Money/Label_Bagmoney").gameObject:GetComponent("UILabel");
		self.movePanel={};
		for i=1,12 do
			table.insert(self.movePanel,info.transform:FindChild("Foot - Anchor/Info/Money/Sprite_1/Sprite_"..i).gameObject);
		end
		self.cardScoreNumParent=self.transform:FindChild("Output/CardScore/difenParent").gameObject;
		self.cardScoreNum=self.cardScoreNumParent.transform:FindChild("difen_count").gameObject:GetComponent("UILabel");
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
		self.cardScoreNumParent=nil;
		self.cardScoreNum=nil;
	end
	
	
	
end
function this:Awake()
	
	self:Init();

	
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject
		GameTBWZ.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
	
	end
	
	------------逻辑代码------------
	self.parentX = self.cardsTrans.localPosition.x
	self.parentY = self.cardsTrans.localPosition.y
	self.parentZ = self.cardsTrans.localPosition.z
	
end

function this:Start()
	
	self:UpdateSkinColor();
	local anchor = self.gameObject:GetComponent("UIAnchor");

	if anchor.side == UIAnchor.Side.BottomRight then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(-500,0,0);
			self.anchorRight=true;
	elseif anchor.side == UIAnchor.Side.TopRight then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(-500,0,0);
			self.anchorRight=true;
    elseif anchor.side == UIAnchor.Side.Top then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(-235,-320,0);
    elseif anchor.side == UIAnchor.Side.TopLeft then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(0,0,0);
    elseif anchor.side == UIAnchor.Side.BottomLeft then
			local outputAnchor=self.transform:FindChild("Output");
			outputAnchor.transform.localPosition=Vector3.New(0,0,0);      
	end
	self._alive = true;
end




--动态发牌时用
function this:SetLate(cards)
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
	self.cardsTrans.gameObject:SetActive(true);
	self.cardsTransAnima.enabled=true;
	self.cardsTransAnima:Play("setcard_6");
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
	--self.userIntomoney.text = self:NumberAddWan(intomoney)
	self.userIntomoney.text=EginTools.HuanSuanMoney(intomoney);
	self.kDetailNickname.text = nickname;
	self.kDetailBagmoney.text = intomoney
	self.kDetailLevel.text = level;
	self.MyMoney  = tonumber(intomoney)

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
		self.userIntomoney.text =  EginTools.HuanSuanMoney(intomoney);
	end
	
end

--发牌（带动画效果,需要在编辑器里将扑克牌的Active设为false）
function this:SetDeal(toShow, infos)
	if not toShow then	
		self.cardsTransAnima:Play("setcard_1");	
	else
		local isown=false;
		self.cardsTransAnima.enabled=true;
		for key,v in ipairs(self.cardsArray) do
			if infos and #(infos)>0 then
				isown=true;
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
					v.spriteName = self._cardPre..infos[key];
				end	
			end
			coroutine.wait(0.1)
			if self.gameObject==nil then
				return;
			end		
		end
		if isown then
			self.cardsTransAnima:Play("setcard_6");
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
function this:SetCardTypeUser(cardsList, cardType)
    if cardsList==nil then
		self.cardTypeTrans.gameObject:SetActive(false);
		self.huangjiatonghua_gold:SetActive(false);
	else
		if self.cardTypeTrans.gameObject.activeSelf then
			return;
		end
		for key,v in ipairs(self.cardsArray) do
			if tonumber(cardsList[#(self.cardsArray) + 1 - key]) < 52 then
				local cardcount = tonumber(cardsList[#(self.cardsArray) + 1 - key])+1;
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
				v.spriteName = self._cardPre..cardsList[#(self.cardsArray) + 1 - key];
			end	
		end
		
		if tonumber(cardType)>9 then
			self.huangjiatonghua_gold:SetActive(true);
			self.cardTypeTrans.gameObject:SetActive(false)
		else
			self.cardTypeTrans.gameObject:SetActive(true);
			local cardTypeSprite =self.cardTypeSprite;
			if 	cardTypeSprite then
				if tonumber(cardType)==9 then
					self.huangjiatonghua_gold:SetActive(true);
					cardTypeSprite.gameObject:SetActive(false);
					local gold_nn=self.huangjiatonghua_gold:GetComponent("UISprite");
					gold_nn.spriteName="cardtype_9";		
					--self.cardsTransAnima:Play("ShowCards");
				else
					cardTypeSprite.spriteName="cardtype_"..tostring(cardType);
					if tonumber(cardType)==0 then
						self.cardsTransAnima:Play("setcard_5");
					else
						if tonumber(cardType) == 1 then
							log("对子");
							--self.cardsTransAnima:Play("UserShowCards1");
							self.cardsTransAnima:Play("setcard_2");
						elseif tonumber(cardType) == 2 or  tonumber(cardType) == 7 then
							--self.cardsTransAnima:Play("UserShowCards2");
							log("两对或四梅");
							self.cardsTransAnima:Play("setcard_4");
						elseif tonumber(cardType) == 3 then
							log("三条");
							--self.cardsTransAnima:Play("UserShowCards3");
							self.cardsTransAnima:Play("setcard_3");
						elseif tonumber(cardType) == 4 or  tonumber(cardType) == 5 or tonumber(cardType) == 6 or  tonumber(cardType) == 8  then
							self.cardsTransAnima:Play("setcard_5");
							log("其他牌型");
							--self.cardsTransAnima:Play("ShowCards");
						end
						
					end
					self.huangjiatonghua_gold:SetActive(false);
					cardTypeSprite.gameObject:SetActive(true);
				end
			end
			
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
function this:SetCardTypeOther(cardsList, cardType)
    if cardsList==nil then	
		self:UpdateSkinColor();
		self.cardTypeTrans.gameObject:SetActive(false);
		self.huangjiatonghua_gold:SetActive(false);
	else	
		self.cardsTrans.gameObject:SetActive(true)
		for key,v in ipairs(self.cardsArray) do
			v.gameObject:SetActive(true)
			v.spriteName = self._cardPre..cardsList[#(self.cardsArray) + 1 - key];
			if tonumber(cardsList[#(self.cardsArray)-key+1]) < 52 then
					local cardcount = tonumber(cardsList[#(self.cardsArray)-key+1])+1;
					
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
					v.spriteName = self._cardPre..cardsList[#(self.cardsArray)-key+1];
				end
		end
		local cardTypeSprite = self.cardTypeSprite; 
		self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		log(tonumber(cardType));
		log("牌型大小");
		if tonumber(cardType)>9 then
			self.huangjiatonghua_gold:SetActive(true);
			self.cardTypeTrans.gameObject:SetActive(false)
		else
			self.cardTypeTrans.gameObject:SetActive(true)
			if tonumber(cardType)==9 then
				self.huangjiatonghua_gold:SetActive(true);
				local gold_nn=self.huangjiatonghua_gold:GetComponent("UISprite");
				gold_nn.spriteName="cardtype_9";
				cardTypeSprite.gameObject:SetActive(false);			
			else
				cardTypeSprite.spriteName = "cardtype_"..tostring(cardType);
				--cardTypeSprite:MakePixelPerfect()
				if tonumber(cardType)==0 then
					self.cardsTransAnima:Play("setcard_5");
				else 
					if tonumber(cardType) == 1 then
					--self.cardsTransAnima:Play("TBNNPlayerShowCards1");
						self.cardsTransAnima:Play("setcard_2");
					elseif tonumber(cardType) == 2 or  tonumber(cardType) == 7 then
						--self.cardsTransAnima:Play("TBNNPlayerShowCards3");
						self.cardsTransAnima:Play("setcard_4");
					elseif tonumber(cardType) == 3 then
						self.cardsTransAnima:Play("setcard_3");
						--self.cardsTransAnima:Play("TBNNPlayerShowCards2");
					elseif tonumber(cardType) == 4 or  tonumber(cardType) == 5 or tonumber(cardType) == 6 or  tonumber(cardType) == 8  then
						self.cardsTransAnima:Play("setcard_5");
					end	
						
				end	
				self.huangjiatonghua_gold:SetActive(false);
				cardTypeSprite.gameObject:SetActive(true);	
			end
		end
		
	end
end
function this:SetUserChip(TheChip)
	self.UserChip = TheChip;
    self:SetScore(-1);
end
function this:SetScore(score,money,targetPosition,isown) 
		if tonumber(score) ==-1 then
			log(self.gameObject.name);
			log("zhunbei");
			self.cardscoreParent:SetActive(true);
			self.cardscoreParent:GetComponent("Animator").enabled=false;
			self.cardScoreObj:SetActive(false);
			if self.cardScoreNumParent then
				self.cardScoreNumParent:SetActive(true);
				self.cardScoreNum.text =  tostring(self.UserChip)
			end
		else
			self.cardscoreParent:SetActive(true)
			
			if isown then
				self.cardScoreNumParent:SetActive(false);
				self.cardscoreParent:GetComponent("Animator").enabled=false;
			else
				self.cardscoreParent:GetComponent("Animator").enabled=true;
			end
			self.cardScoreObj:SetActive(true);
			if tonumber(score)>0 then
				self.winMoney.text="+"..tostring(score);
				self.winMoney.gameObject:SetActive(true);
				self.loseMoney.gameObject:SetActive(false);
			else
				self.loseMoney.text= tostring(score);
				self.winMoney.gameObject:SetActive(false);
				self.loseMoney.gameObject:SetActive(true);
				self:MoveBet(targetPosition,isown);
				self.cardTypeSprite.spriteName="gray"..self.cardTypeSprite.spriteName;
				--local gold_nn=self.huangjiatonghua_gold:GetComponent("UISprite");
				--gold_nn.spriteName="gray"..gold_nn.spriteName;
			end
			if money == nil then
				self.MyMoney =self.MyMoney  + tonumber(score) 
			else
				log("使用新的==========="..money)
				self.MyMoney =tonumber(money);
			end
			if self.userIntomoney ~= nil then 
				self.userIntomoney.text =EginTools.HuanSuanMoney(self.MyMoney);
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
					iTween.MoveTo(self.movePanel[i],GameTBWZ.mono:iTweenHashLua("path",pathse,"time", 1.2-temp*0.5,"easeType", iTween.EaseType.easeOutCubic));
					iTween.ScaleTo(self.movePanel[i],GameTBWZ.mono:iTweenHashLua("scale",Vector3.New(1.2,1.2,1.2),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
					iTween.ScaleTo(self.movePanel[i],GameTBWZ.mono:iTweenHashLua("scale",Vector3.New(1,1,1),"time",0.2,"easeType", iTween.EaseType.linear,"delay",1.2-temp*0.5));
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

function this:SetChongzhi()
	self.cardsTransAnima.enabled=false;
	for key,v in ipairs(self.cardsArray) do
		v.gameObject:SetActive(false);
	end
	self.cardTypeTrans.gameObject:SetActive(false);
	self.cardscoreParent:SetActive(false)
end


function this:AfterDoing(offset, run)
    coroutine.wait(offset);
	if self.gameObject==nil then
		return;
	end
	run();
end
