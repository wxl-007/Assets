
local this = LuaObject:New()
QBSKPlayerCtrl = this



	
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
	
	self.waitObj = nil
	self.userAvatar = nil
	self.userNickname = nil
	self.userIntomoney =nil
	self.infoDetail = nil	
	self.kDetailNickname = nil		
	self.kDetailLevel =  nil
	self.kDetailBagmoney =  nil
	
	self.emotionParent=nil;
	self.message_prompt=nil;
	
	self.cardsTrans = nil;
	self.cardOutParent=nil;
	self.time_fangwei=nil;

	self.soundSend =nil;
	
	self._cardData=nil;
	self.cardsArray = nil;	
	self.CardObjectList=nil;
	self.CardCount=nil;
	
	self.sex=-1;
	
end
function this:Init()
--初始化变量
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	self._cardInterval=0;
	self._cardPre = "card_";
	self._timeInterval = 3;
	self._timeLasted = 0;

	self.sex=-1;
	
	self._cardData=nil;
	self._alive = false;
	
	self.position = GlobalVar.PlayerPosition.Down;
	
	
	
	self.cardsTrans = self.transform:FindChild("Output/Cards")		--扑克牌的父物体
	
	
	
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");		
	self.ownCard_prb=ResManager:LoadAsset("gameqbsk/prefab","ownCard");--实例化自己的牌的预制件
	self.otherCard_prb=ResManager:LoadAsset("gameqbsk/prefab","otherCard");--实例化别人的牌的预制件
	
	self.CardObjectList={};
	self.cardsArray = {};		--玩家的扑克牌(排序后)
	--[[
	for i=1,27  do
		table.insert(self.cardsArray,self.cardsTrans.transform:FindChild("Sprite_"..i):GetComponent("UISprite"));
		table.insert(self.CardObjectList,self.cardsTrans.transform:FindChild("Sprite_"..i));
	end
	]]
	self.message_prompt=self.transform:FindChild("Output/talk").gameObject;
	self.buchuState=self.transform:FindChild("Output/buchuState").gameObject;--不出提示
	if self.gameObject.name == "User" then
		self.readyObj = self.transform:FindChild("Output/Sprite_ready").gameObject
				
		local userInfo = GameObject.Find("FootInfo/Foot - Anchor/Info").transform

		self.waitObj = nil
		self.userAvatar = nil
		self.userNickname = nil
		self.userIntomoney =nil
		self.infoDetail = nil	
		self.kDetailNickname = nil		
		self.kDetailLevel =  nil
		self.kDetailBagmoney =  nil
		self.CardCount=nil;
		self.CardCount_label=nil;
		self.cardOutParent=nil;
		self.emotionParent=userInfo:FindChild("Panel/emotionParent");
		
	else
		--提示字“准备”
		self.readyObj = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_ready").gameObject
		
		self.waitObj = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_waitting").gameObject		--提示字"等待中"
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel_Head/Panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite")	-- 玩家头像	
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel")	--玩家昵称
		self.userIntomoney =self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");	--玩家带入金额
		self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject;	
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");		
		self.kDetailLevel =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");	
		self.CardCount=self.transform:FindChild("Output/CardCount").gameObject;
		self.CardCount_label=self.CardCount.transform:FindChild("Label"):GetComponent("UILabel");
		self.cardOutParent=self.transform:FindChild("Output/outCardParent/outCardParent");--出牌父物体
		self.emotionParent=self.transform:FindChild("PlayerInfo/Panel_Head/Panel/emotionParent");
	
	end
	
	self.time_fangwei=self.transform:FindChild("Output/time_fangwei").gameObject;
	
	self.emotionPrefab={};
	for i=1,27 do 
		table.insert(self.emotionPrefab,i,ResManager:LoadAsset("expressionpackage/biaoqing_"..i,"biaoqing_"..i));
	end
end
function this:Awake()
	
	self:Init();

	
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel_Head/Panel/Sprite (avatar_6)").gameObject
		GameQBSK.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
	
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
	
	self._alive = true;
end



function this:UpdateSelect()
	
end




--动态发牌时用
function this:SetLate(cards)
	self.cardsTrans.gameObject:SetActive(true);
	for key,v in ipairs(self.cardsArray) do
		v.gameObject:SetActive(true);
		if cards and #(cards) >0 then
			v.spriteName = self._cardPre..cards[key]
		end
	end
end
function this:UpdateSkinColor()
    for key,sprite in ipairs(self.cardsArray) do
		sprite.spriteName = "card_red"
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
	

	self.cardsTrans.gameObject:SetActive(false);
	self:ClearPrefab();
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
function this:SetDeal(toShow , count, isBanker, infos)
	--测试比对方出牌大的数组个数
	--[[
	local aa={{1},{2},{3},{4},{5},{6},{},{8},{9},{10}};
	local autoArray={};
	local count=1;
	local lianShu=2;

	local lishiArray={};
	local i=1;
	while (i<=10) do
		--log(#(aa[i]).."==========sssssssssssssss");
		if #(aa[i])<count then
			if #(lishiArray)==(lianShu+1) then
				table.insert(autoArray,lishiArray);
			end
			lishiArray={};
		else	
			--log(i.."-----------------")
			table.insert(lishiArray,aa[i][1]);
			if #(lishiArray)==(lianShu+1)*count then
				table.insert(autoArray,lishiArray);
				i=lishiArray[count+1]-1;
				--log(i.."++++++++++++++");
				lishiArray={};
			end	
		end
		i=i+1;
	end
	log(#(autoArray).."======选择个数");

	printf(autoArray);
	]]
	

	self._cardData = infos;
	self._alive = true;
	if not toShow then	
		--for key,sprite in ipairs(self.cardsArray) do
			--sprite.gameObject:SetActive(false);
		--end
	else
		self.cardsTrans.gameObject:SetActive(true);
		if self._cardData~=nil and #(self._cardData)>0 then--自己的发牌动画
			--log("自己发牌");
			if self.sex==0 then
				UISoundManager.Instance.PlaySound("man_begin");
			else
				UISoundManager.Instance.PlaySound("woman_begin");
			end
			QBSKPlayer.PutUICards(count,self._cardData,isBanker);
			--[[
			for i=1,count do
				local handcard=GameObject.Instantiate(self.ownCard_prb);
				handcard.name=tostring(i);
				handcard.transform.parent = self.cardsTrans.transform;
				handcard.transform.localScale = Vector3.New(1,1,1);
				handcard.transform.localPosition=Vector3.New(64*(i-1),0,-10*i);
				handcard:GetComponent("UISprite").depth=15+i;
				handcard:GetComponent("UISprite").spriteName=self._cardPre..self._cardData[i];
				self.cardsTrans.transform.localPosition=Vector3.New(-32*(i-1),0,0);
				table.insert(self.cardsArray,handcard);
				local CardInfo = {}
				CardInfo.GameObject = handcard; 
				table.insert(self.CardObjectList,CardInfo)
				self.CardObjectList[i].Selected = false;
				self.CardObjectList[i].isTouching = false;
				self.CardObjectList[i].Card = tonumber(self._cardData[i]);
				if tonumber(self._cardData[i])<52 then
					self.CardObjectList[i].CardValue=(tonumber(self._cardData[i]))%13;
				else
					self.CardObjectList[i].CardValue=tonumber(self._cardData[i]);
				end
				coroutine.wait(0.1);
				if i==count then
					--开始手里牌排序
					self.CardObjectList=self:SortCardsFunc(self.CardObjectList,true);
					for i=1,#(self.CardObjectList) do
						self.cardsArray[i]:GetComponent("UISprite").spriteName=self._cardPre..self.CardObjectList[i].Card;
					end
				end
			end
			]]
		else
			--log("别人发牌");
			self.cardsArray={};
			self.CardCount:SetActive(true);		
			for i=1,tonumber(count) do--别人的发牌动画
				local handcard=GameObject.Instantiate(self.otherCard_prb);
				handcard.name="othercard_"..i;
				handcard.transform.parent = self.cardsTrans.transform;
				handcard.transform.localScale = Vector3.New(1,1,1);
				handcard.transform.localPosition=Vector3.New(31*(i-1),0,0);
				handcard.transform:GetComponent("UISprite").depth=41-i;
				handcard.transform.localEulerAngles=self.cardsTrans.transform.localEulerAngles;
				self.cardsTrans.transform.localPosition=Vector3.New(-8.5*(i-1),0,0);
				self.CardCount_label.text=tostring(i);
				table.insert(self.cardsArray,handcard);				
				coroutine.wait(0.2);
				if i==count  then
					GameQBSK.ButtonTuoguan:GetComponent("BoxCollider").enabled=true;
					if isBanker then
						coroutine.wait(0.2);
						self:HideOrShowTime(true);
					end
				end
			end
		end
	end
end




--descending为true 降序，为false 升序
function this:SortCardsFunc(cardList,descending)
	local function sortFunc(card1,card2)
		if card1.CardValue == card2.CardValue then
			return card1.Card >  card2.Card;
		else 
			if descending == true then --如果降序排列
				return card1.CardValue > card2.CardValue
			else 
				return card1.CardValue < card2.CardValue;
			end 
		end 
	end 
	table.sort( cardList, sortFunc)
	return cardList
end 

function this:SetOtherOutPai(Cards,cardType,num)
	local outcards={};
	local count=0;
	for i=#(self.cardsArray),1,-1 do
		count=count+1;
		table.insert(outcards,self.cardsArray[i]);
		iTableRemove(self.cardsArray,self.cardsArray[i]);
		if count==#(Cards) then
			break;
		end
	end
	for i=1,#(outcards) do
		outcards[i]:GetComponent("UISprite").spriteName=self._cardPre..tonumber(Cards[#(outcards)-i+1]);
		outcards[i].transform.parent=self.cardOutParent;
		outcards[i].transform.localScale=Vector3.one;
		local position_y=0;
		if i<10 then
			position_y=0;
			outcards[i].transform.localPosition=Vector3.New(40*(i-1),position_y,0);
		elseif i>=10 and i<19 then
			position_y=-80;
			outcards[i].transform.localPosition=Vector3.New(40*(i-10),position_y,0);
		else
			position_y=-160;
			outcards[i].transform.localPosition=Vector3.New(40*(i-19),position_y,0);
		end
		
		outcards[i].transform.localEulerAngles=Vector3.zero;
		outcards[i]:GetComponent("UISprite").width=142;
		outcards[i]:GetComponent("UISprite").height=194;
		outcards[i]:GetComponent("UISprite").depth=15+i;
		
	end
	if #(outcards)<10 then
		self.cardOutParent.transform.localPosition=Vector3.New(-20*(#(outcards)-1),self.cardOutParent.transform.localPosition.y,0);
	else
		self.cardOutParent.transform.localPosition=Vector3.New(-200,self.cardOutParent.transform.localPosition.y,0);
	end
	
	for i=1,#(self.cardsArray) do
		self.cardsArray[i].transform.localPosition=Vector3.New(31*(i-1),0,0);
	end
	--log(#(self.cardsArray).."===对方的牌数量");
	self.cardsTrans.transform.localPosition=Vector3.New(-8.5*(#(self.cardsArray)-1),0,0);
	self.CardCount_label.text=tostring(num);
	if cardType>10 then
		GameQBSK:PlayCardSound(cardType,self.sex);
	end
end

function this:SetLate(count)
	self.cardsArray={};
	self.cardsTrans.gameObject:SetActive(true);
	self.CardCount:SetActive(true);	
	self.CardCount_label.text=tostring(count);	
	for i=1,tonumber(count) do--别人的发牌动画
		local handcard=GameObject.Instantiate(self.otherCard_prb);
		handcard.name="othercard_"..i;
		handcard.transform.parent = self.cardsTrans.transform;
		handcard.transform.localScale = Vector3.New(1,1,1);
		handcard.transform.localPosition=Vector3.New(31*(i-1),0,0);
		handcard.transform:GetComponent("UISprite").depth=41-i;
		handcard.transform.localEulerAngles=self.cardsTrans.transform.localEulerAngles;		
		self.cardsTrans.transform.localPosition=Vector3.New(-8.5*(i-1),0,0);	
		table.insert(self.cardsArray,handcard);			
	end
end

function this:SetLatePutOut(cardtype,cards)
	local outcards={};
	local count=0;
	for i=1,#(cards) do
		local handcard=GameObject.Instantiate(self.otherCard_prb);
		handcard:GetComponent("UISprite").spriteName=self._cardPre..tonumber(cards[#(cards)-i+1]);
		handcard.transform.parent=self.cardOutParent;
		handcard.transform.localScale=Vector3.one;
		handcard.transform.localPosition=Vector3.New(40*(i-1),0,0);
		handcard.transform.localEulerAngles=Vector3.zero;
		handcard:GetComponent("UISprite").depth=15+i;
		handcard:GetComponent("UISprite").width=142;
		handcard:GetComponent("UISprite").height=194;
		table.insert(outcards,handcard);
	end
	self.cardOutParent.transform.localPosition=Vector3.New(-20*(#(outcards)-1),self.cardOutParent.transform.localPosition.y,0);	
end

function this:DestroyCards()
	local sprites = self.cardOutParent:GetComponentsInChildren(Type.GetType("UISprite",true));
	if sprites.Length>0 then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			destroy(sprite.gameObject);
		end
	end
end

function this:HideOrShowTime(show)
	self.time_fangwei:SetActive(show);	
end

function this:HideOrShowBuChuState(show)
	--log("隐藏不出状态");
	self.buchuState:SetActive(show);
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
	]]
end

function this:SetReady(toShow)
	if not IsNil(self.readyObj)  then
		if toShow then
			self.readyObj:SetActive(true);
		else
		--log("隐藏准备字样");
			self.readyObj:SetActive(false);
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

local startGameObj;--刚开始选中的物体
local lastGameObj;--最后选中的物体
local nowGameObj;--当前选中的物体
local selectCardList={};--选中的所有牌的列表
local startSelect=false;--开始选牌;
local selectCount=0;--选中的牌个数

function this:SelectMahjong(obj)
	if startSelect then
		for i=1,#(self.cardsArray) do
			if obj.gameObject==self.cardsArray[i] then 
				if self.cardsArray[i]~=nowGameObj then
					lastGameObj=nowGameObj;
					nowGameObj=self.cardsArray[i];
					if not tableContains(selectCardList,nowGameObj) then
						--log(nowGameObj.name);
						nowGameObj:GetComponent("UISprite").color =  Color.New(124/255, 124/255, 124/255, 1)	
						table.insert(selectCardList,nowGameObj);
					else
						--log(lastGameObj.name);
						lastGameObj:GetComponent("UISprite").color =  Color.New(1, 1, 1, 1)	
						iTableRemove(selectCardList,lastGameObj);	
					end
				else
					nowGameObj:GetComponent("UISprite").color =  Color.New(124/255, 124/255, 124/255, 1)	
				end					
				--log("选中的牌的个数===="..#(selectCardList));
				--self:ChangeSelectCardColor(selectCardList);
			end
		end
	else
		for i=1,#(self.cardsArray) do
			if obj.gameObject==self.cardsArray[i] then
				startGameObj=self.cardsArray[i];
				nowGameObj=self.cardsArray[i];
				table.insert(selectCardList,startGameObj);
				selectCount=#(selectCardList);
				startSelect=true;
				break;
			end
		end
	end
end

function this:PlayWinSound(wintype)
	if self.sex==0 then
		if wintype==1 then
			UISoundManager.Instance.PlaySound("man_twokou")
		elseif wintype==2 then
			UISoundManager.Instance.PlaySound("man_onekou")
		elseif wintype==3 then
			UISoundManager.Instance.PlaySound("man_pingkou")
		end
	else
		if wintype==1 then
			UISoundManager.Instance.PlaySound("woman_twokou")
		elseif wintype==2 then
			UISoundManager.Instance.PlaySound("woman_onekou")
		elseif wintype==3 then
			UISoundManager.Instance.PlaySound("woman_pingkou")
		end
	end
end


function this:ClearPrefab()
	--log("销毁物体");
	self:DestroyCards();
	local sprites = self.cardsTrans:GetComponentsInChildren(Type.GetType("UISprite",true));
	for i=0,sprites.Length-1 do
		local sprite = sprites[i];
		destroy(sprite.gameObject);
	end
	self:HideOrShowTime(false);
end

function this:ShowOutPai()
	--log("鼠标抬起");
end



function this:setEmotion(number)
	--log(number.."实例化的表情下标");
	local aa=GameObject.Instantiate(self.emotionPrefab[number]);
	--log("是实例化");
	aa.transform.parent=self.emotionParent.transform;
	aa.transform.localScale=Vector3.one;
	aa.transform.localPosition=Vector3.zero;
	if number==1 then
		aa.transform.localPosition=Vector3.New(0,0,0);
	elseif number==2 then
		aa.transform.localPosition=Vector3.New(-5,7,0);
	elseif number==3 then
		aa.transform.localPosition=Vector3.New(-5,8,0);
	elseif number==4 then
		aa.transform.localPosition=Vector3.New(0,15,0);
	elseif number==5 then
		aa.transform.localPosition=Vector3.New(-3,12,0);
	elseif number==6 then
		aa.transform.localPosition=Vector3.New(0,13,0);
	elseif number==7 then
		aa.transform.localPosition=Vector3.New(-6,5,0);
	elseif number==8 then
		aa.transform.localPosition=Vector3.New(15,15,0);
	elseif number==9 then
		aa.transform.localPosition=Vector3.New(-5,25,0);
	elseif number==10 then
		aa.transform.localPosition=Vector3.New(0,20,0);
	elseif number==11 then
		aa.transform.localPosition=Vector3.New(0,0,0);
	elseif number==12 then
		aa.transform.localPosition=Vector3.New(-30,0,0);
	elseif number==13 then
		aa.transform.localPosition=Vector3.New(0,-30,0);
	elseif number==14 then
		aa.transform.localPosition=Vector3.New(0,0,0);
	elseif number==15 then
		aa.transform.localPosition=Vector3.New(-5,5,0);
	elseif number==16 then
		aa.transform.localPosition=Vector3.New(0,15,0);
	elseif number==17 then
		aa.transform.localPosition=Vector3.New(0,0,0);
	elseif number==18 then
		aa.transform.localPosition=Vector3.New(0,-30,0);
	elseif number==20 then
		aa.transform.localPosition=Vector3.New(0,15,0);
	elseif number==22 then
		aa.transform.localPosition=Vector3.New(0,0,0);
	elseif number==23 then
		aa.transform.localPosition=Vector3.New(0,5,0);
	elseif number==24 then
		aa.transform.localPosition=Vector3.New(15,15,0);
	elseif number==25 then
		aa.transform.localPosition=Vector3.New(0,-5,0);
	elseif number==26 then
		aa.transform.localPosition=Vector3.New(25,0,0);
	elseif number==27 then
		aa.transform.localPosition=Vector3.New(-15,20,0);
	end
	coroutine.start(self.AfterDoing,self,1.25,function()
		destroy(aa);
	end)
end

function this:setMessage(index)
	--log(index.."语音index");
	self.message_prompt.gameObject:SetActive(true);
	local yuyin="";
	if self.sex==0 then
		yuyin=XMLResource.Instance:Str("hpsk_man_language_"..(index-1));
	else
		yuyin=XMLResource.Instance:Str("hpsk_woman_language_"..(index-1));
	end
	--local yuyin=XMLResource.Instance:Str("message_error_6");
	--log(yuyin);
	self.message_prompt.transform:FindChild("Label_desc"):GetComponent("UILabel").text=yuyin;
	--self.message_prompt.transform:FindChild("Label"):GetComponent("UILabel").text=this.mahjongList[index];
	if self.sex==0 then
		UISoundManager.Instance.PlaySound("man_"..index)
	else
		UISoundManager.Instance.PlaySound("woman_"..index)
	end
	coroutine.start(self.AfterDoing,self,2,function()
		self.message_prompt.transform:FindChild("Label_desc"):GetComponent("UILabel").text="";	
		self.message_prompt.gameObject:SetActive(false);
	end)
end

function this:ChangeSelectCardColor(list)
	for i=1,#(list) do
		for j=1,#(self.cardsArray) do
			if list[i]==self.cardsArray[j] then
				
			end
		end
	end
end
--[[
local mousePosition = nil
function this:ScreenToUI(pos)
	if mousePosition == nil then
		mousePosition = self.transform:FindChild("mousePosition")
	end
	--测试是否为空
	local function trymousePosition()
		local x = mousePosition.position
	end
	if pcall(trymousePosition) then
		mousePosition.position = UICamera.currentCamera:ScreenToWorldPoint(pos)
		return mousePosition.localPosition
	else
		mousePosition = self.transform:FindChild("mousePosition")
		mousePosition.transform.position = UICamera.currentCamera:ScreenToWorldPoint(pos)
		return mousePosition.transform.localPosition
	end
end 
]]