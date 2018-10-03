local this = LuaObject:New()
YSZPlayerCtrl = this 
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
	self:OnDestroy()
	self.gameObject = nil;
	self.transform = nil
	
	self.readyObj = nil;--/ 提示字“准备”
	self.showObj = nil;--/  提示字 看牌,下注,跟注,加注,比牌,弃牌huan spriteName
	self.callBankerObj = nil;--/ 提示字"叫庄中"
	self.waitObj = nil;--/  提示字"等待中"
	self.cardTypeTrans = nil;--/ 比牌结果
	self.cardsAnima=nil;
	--/ 玩家头像
	self.userAvatar = nil;
	--/ 玩家昵称
	self.userNickname = nil;
	--/ 玩家带入金额
	self.userIntomoney = nil;
	--/ 玩家押注金额
	self.userYazhuMoney = nil;
	--筹码初始位置
	self.bet_target = nil;
	--筹码预设
	self.chip = nil;
	--/ 玩家倒计时
	self.countDown = nil;
	--/ 玩家的扑克牌(排序后)
	self.cardsArray = {};
	self.cardOriginPos ={};
	--/ 扑克牌的父物体
	self.cardsTrans = nil;
	--/ 玩家得分
	self.cardScoreObj = nil;
	self.cardScoreBg = nil;
	--/ 庄
	self.bankerSprite = nil;
	self.soundSend = nil
	self.jettonPrefab = nil;
	
	self.isWinner = false;
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
	self._timeLasted = 0;
	self.winAnima = nil;
	self.resultAnima = nil;
	self.vsHand = nil;
	self.userID = nil;
	self.cardScoreP = nil;
	self.cardTypeP = nil;
	self.showP = nil;
	self.callBankerP = nil;
	self.infoDetailP = nil;
	self._winMoney=0;
	self.isVSLose=false;
	self.pokercount = 0;
	self.cardResetCount = 0;
	self.selfScore1 = nil;
	self.otherScore1 = nil;
	self.otherScore1 = nil;
	self.otherScore1Ver = nil;
	self.recordPosAry = {};
	self.hasRotateCard = false;
	self.isGiveUp = false;
	self.isSeeCard = nil;
	self.showpaiType=nil;
	self.showpaiTypeSprite=nil;
	self.path = {};
	self.path2 = {};
	self.InvokeLua:clearLuaValue();
	self.InvokeLua = nil;
	self.cardvalue=nil;
	self.bankerShow=false;
	--self.pokers = {};
end
function this:Init()
	--初始化变量
	--扑克牌父物体的位置
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	--/ 牌间距
	self._cardInterval = 40;
	self._cardPre = "card_";
	self._timeInterval = 3;
	
	self.cardScoreP = nil;
	self.cardTypeP = nil;
	self.showP = nil;
	self.callBankerP = nil;
	self.infoDetailP = nil;
	self._winMoney=0;
	self.isVSLose=false;
	self.pokercount = 0;
	self.cardResetCount = 0;
	self.selfScore1 = nil;
	self.otherScore1 = nil;
	self.otherScore1 = nil;
	self.otherScore1Ver = nil;
	self.hasRotateCard = false;
	self.isGiveUp = false;
	self.isSeeCard = nil;
	self.cardOriginPos ={};
	self.path = {};
	self.path2 = {};
	self.recordPosAry = {};
	
	self.cardTypeTrans = self.transform:FindChild("Output/Cards/CardType");--/ 比牌结果
	self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
	self.cardsTrans = self.transform:FindChild("Output/Cards")--/ 扑克牌的父物体
	self.cardsAnima=self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");
	self.cardParentScale=self.cardsAnima.transform.localScale;
	--/ 玩家的扑克牌(排序后)
	self.cardsArray = {};
	self.cardvalue=nil;
	--self.pokers = {};
	--玩家的扑克牌(排序后)
	--[[
	for i=0,self.cardsTrans.childCount-1  do
		local card = self.cardsTrans:GetChild(i).gameObject;
		--self.pokers[card.name] = GPoker:New(card);
		table.insert(self.cardsArray,card:GetComponent("UISprite"));	
	end
	]]
	for i=1,5 do
		table.insert(self.cardsArray,self.cardsTrans:FindChild("Sprite_"..i).gameObject:GetComponent("UISprite"));
	end
	
	if self.gameObject.name == "User" then
		self.readyObj = self.transform:FindChild("Output/Sprite_ready").gameObject;--/ 提示字“准备”
		
		--筹码初始位置
		self.bet_target = self.transform:FindChild("Output/chip_target").gameObject;
		self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
		
		local resultAnimaObj = self.transform:FindChild("Output/resultTxt").gameObject;
		self.resultAnima = TextAnima:New(resultAnimaObj);
		
		
		self.showObj = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/TalkDialogPanel/Sprite_Status").gameObject;--/  提示字 看牌,下注,跟注,加注,比牌,弃牌huan spriteName
		self.waitObj = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/Sprite_waitting").gameObject;--/  提示字"等待中"
		--/ 玩家头像
		self.userAvatar = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/Panel/Sprite_Avatar").gameObject:GetComponent("UISprite");
		--/ 玩家昵称
		self.userNickname = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/Label_Nickname").gameObject:GetComponent("UILabel");
		--/ 玩家带入金额
		self.userIntomoney = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/Money/Label_Bagmoney").gameObject:GetComponent("UILabel");
		--/ 玩家押注金额
		self.userYazhuMoney = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/Label_yazhumoney").gameObject:GetComponent("UILabel");
		--/ 玩家倒计时
		self.countDown = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/daojishi").gameObject;
		--/ 玩家得分
		self.cardScoreObj = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/TalkDialogPanel/CardScore").gameObject;
		--/ 庄
		self.bankerSprite =  self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/Sprite_banker").gameObject;
		self.winAnima = self.transform.parent:FindChild("FootInfo/Foot - Anchor/Info/TalkDialogPanel/winAnimation").gameObject:GetComponent("UISpriteAnimation");
		
		
		self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD");
		self.jettonPrefab = ResManager:LoadAsset("gameysz/Prefabs","yszchipnum");
		
		self.callBankerObj = nil;--/ 提示字"叫庄中"
		
		self.vsHand = nil;
		self.infoDetail = nil;
		self.kDetailNickname = nil;
		self.kDetailLevel = nil;
		self.kDetailBagmoney = nil;
		self.showpaiType=self.transform:FindChild("Output/ShowpaiType").gameObject;
		self.showpaiTypeSprite=self.showpaiType.transform:FindChild("CardType").gameObject:GetComponent("UISprite");
	
	else
		self.readyObj = self.transform:FindChild("Output/Sprite_show").gameObject;--/ 提示字“准备”
		
		--筹码初始位置
		self.bet_target = self.transform:FindChild("Output/OtherChiptransform").gameObject;
		local resultAnimaObj = self.transform:FindChild("Output/TalkDialogPanel/resultTxt").gameObject;
		self.resultAnima = TextAnima:New(resultAnimaObj);
		self.showObj = self.transform:FindChild("Output/TalkDialogPanel/Sprite_Status").gameObject;--/  提示字 看牌,下注,跟注,加注,比牌,弃牌huan spriteName
		self.waitObj = self.transform:FindChild("PlayerInfo/Panel/Sprite_waitting").gameObject;--/  提示字"等待中"
		--/ 玩家头像
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
		--/ 玩家昵称
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel");
		--/ 玩家带入金额
		self.userIntomoney = self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");
		--/ 玩家押注金额
		self.userYazhuMoney = self.transform:FindChild("Output/Label_yazhumoney").gameObject:GetComponent("UILabel");
		--/ 玩家倒计时
		self.countDown = self.transform:FindChild("PlayerInfo/daojishi/daojishi").gameObject;
		--/ 玩家得分
		self.cardScoreObj = self.transform:FindChild("Output/CardScore").gameObject;
		--/ 庄
		self.bankerSprite =  self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject;
		self.winAnima = self.transform:FindChild("Output/TalkDialogPanel/winAnimation").gameObject:GetComponent("UISpriteAnimation");
		self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab");
		self.callBankerObj = self.transform:FindChild("Output/Sprite_callBanker").gameObject;--/ 提示字"叫庄中"
		self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject;
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");
		self.kDetailLevel = self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney = self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");
		self.vsHand = self.transform:FindChild("Output/hand").gameObject;
		self.showpaiType=nil;
		self.showpaiTypeSprite=nil;
	
	end
	--筹码预设
	self.chip = ResManager:LoadAsset("gameysz/Prefabs","Chip");
	
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD");
	
	self.resultAnima:Awake(1,true);
	
	
	self.bankerShow=false;
	self.isWinner = false;
	self._timeLasted = 0;
	self.userID = nil;
	self.InvokeLua = InvokeLua:New(self);
end

function this:Awake()
	self:Init();
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject
		GameYSZ.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
		
		GameYSZ.mono:AddClick(self.cardsTrans.gameObject,GameYSZ.UserVs,GameYSZ);
		local btn = self.cardsTrans:GetComponent("Animator");
		if btn ~= nil then
			self:refVSstate(true);
		end
	else
		--log("------------------GameYSZ.mono:AddClick(sprite0,self.firstCardMOver,self);")
		--local sprite0 = self.transform:FindChild("Output/Cards/Sprite0").gameObject
		--GameYSZ.mono:AddClick(sprite0,self.firstCardMOver,self);
		--log("绑定按钮事件-----------")
	end
	
	------------逻辑代码------------
	--self.parentX = self.cardsTrans.localPosition.x;
	--self.parentY = self.cardsTrans.localPosition.y;
	--self.parentZ = self.cardsTrans.localPosition.z;

	self.cardOriginPos = {};
	for  i=1,  #(self.cardsArray)  do 
		self.cardOriginPos[i] = self.cardsArray[i].transform.localPosition;
	end
	self.winAnima.gameObject:SetActive(false);
	self.resultAnima.gameObject:SetActive(false);
	
end
function this:Start()
	if self.cardScoreObj ~= nil  and  self.cardTypeTrans ~= nil  and  self.showObj ~= nil  and  self.callBankerObj ~= nil  and  self.infoDetail ~= nil then
		self.cardScoreP = self.cardScoreObj.transform.localPosition;
		self.cardTypeP = self.cardTypeTrans.localPosition;
		self.showP = self.showObj.transform.localPosition;
		self.callBankerP = self.callBankerObj.transform.localPosition;
		self.infoDetailP = self.infoDetail.transform.localPosition;
	end
end

function this:Update()

       if not IsNil(self.infoDetail) and  self.infoDetail.activeSelf then
		self._timeLasted = self._timeLasted + Time.deltaTime;
		if self._timeLasted >= self._timeInterval then
			self.infoDetail:SetActive(false)
			self._timeLasted = 0;
		end
	end
	if self.resultAnima~=nil then
		self.resultAnima:Update();
	end
	
end
function this:OnDestroy()
	if self.isWinner then
		if  #(GameYSZ.jettonObjList)  > 0 then
			for  key, obj in ipairs(GameYSZ.jettonObjList) do
				if obj ~= nil then
					destroy(obj);
				end
			end
		end
		GameYSZ.jettonObjList = {};
	end
end
--/ 换肤时更新扑克牌
function this:UpdateSkinColor()
	for  key, sprite in ipairs(self.cardsArray) do
		sprite.spriteName = "card_green";
	end
end
function this:winMoney( money)
	self._winMoney = self._winMoney +money;
	if self._winMoney < 0 then
		self._winMoney = 0;
	end
end
function this:SetPlayerInfo( avatar,  nickname,  intomoney,  level,  UserId)
	self.userAvatar.spriteName = "avatar_".. avatar;
	self.userNickname.text = nickname;
	--self.userIntomoney.text = intomoney;--不该出现
	self.userIntomoney.text=EginTools.HuanSuanMoney(intomoney);
	log(self.gameObject.name);
	log(self.userIntomoney.text);
	self.kDetailNickname.text = nickname;
	self.kDetailLevel.text = level;
	self.kDetailBagmoney.text = intomoney;
	self.userID   = UserId;
end

function this:OnClickInfoDetail()
	if self.infoDetail.activeSelf then
		self._timeLasted = 0;
		self.infoDetail:SetActive(false);
	else
		self.infoDetail:SetActive(true);
	end
end


function this:UpdateIntoMoney( intomoney)

        if  self.userIntomoney == nil then
			--GameObject.Find("Label_Bagmoney"):GetComponent("UILabel").text =intomoney;
			GameObject.Find("Label_Bagmoney"):GetComponent("UILabel").text =EginTools.HuanSuanMoney(intomoney);
        else
			--self.userIntomoney.text = intomoney;
			self.userIntomoney.text = EginTools.HuanSuanMoney(intomoney);
        end
end
--[[
function this:tiShi(tiS)
	self.showObj:SetActive(false);
	if tiS == "xia"  or  tiS == "jia"  or  tiS == "gen" then
		local uisp = self.showObj:GetComponent("UISprite");
		self.showObj:SetActive(true);
		uisp.spriteName = "ti_".. tiS;
	end

end
]]--
--庄
function this:SetBanker( toShow)
	if toShow then
		self.bankerSprite:SetActive(true);
		self.bankerShow=true;
	else
		self.bankerSprite:SetActive(false);
		self.bankerShow=false;
	end
end
--[[
--玩家倒计时
function this:SetCountdown( toshow)
	if toshow then
		self.countDown:SetActive(true);
	else
		self.countDown:SetActive(false);
	end
end
]]
function this:SetTime()
	if self.countDown:GetComponent("UISprite").fillAmount ~= 1 then
		self.countDown:GetComponent("UISprite").fillAmount = 1;
	end
	self.countDown:GetComponent("UISprite").alpha = 1.0;
	self.InvokeLua:InvokeRepeating("TimeMinus",self.TimeMinus,0, 1);
end
function this:SetCancelTime()
	if self.countDown:GetComponent("UISprite").fillAmount ~= 1 then
		self.InvokeLua:CancelInvoke("TimeMinus");
	end
	self.countDown:GetComponent("UISprite").alpha = 0;
end

function this:TimeMinus()
	self.countDown:GetComponent("UISprite").fillAmount = self.countDown:GetComponent("UISprite").fillAmount -1.0/15.0;
end
--[[
function this:setQi()
	self.userNickname.text = "弃牌";
	if self.countDown:GetComponent("UISprite").fillAmount ~= 1 then
		CancelInvoke("TimeMinus");
		self.countDown:GetComponent("UISprite").fillAmount = 1;
		self.countDown:GetComponent("UISprite").alpha = 0;
	end
end

function this:setCardShow()
	self.cardsArray[1].spriteName = "card_blue";
	self.cardsArray[2].spriteName = "card_blue";
	self.cardsArray[1].alpha = 1;
	self.cardsArray[2].alpha = 1;
end

--所有人的发牌
function this:SetPai_1( self.pokercount,  delay)

end
]]

function this:cardFlyToDeck( originalCard)
	self.cardsTrans.gameObject:SetActive(true);
	--self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);

	if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end

	SoundMgr:playEft(SoundMgr.clipDeal);
	local cardSpt = self.cardsArray[self.pokercount%5+1];
	self.pokercount = self.pokercount+1;
	cardSpt.alpha = 1;
	cardSpt.gameObject:SetActive(true);
	cardSpt.spriteName = self._cardPre.."green";
	local absCardPos = originalCard.transform:GetChild(0);
	iTween.MoveFrom(cardSpt.gameObject,  iTween.Hash ("position",absCardPos.position,"time",0.5,"easetype", iTween.EaseType.easeOutCirc));
	local scaleSize = 0.8;
	if self.gameObject.name == "YSZPlayer_"..EginUser.Instance.uid then
		scaleSize = 0.6;
	end
	
	iTween.ScaleFrom(cardSpt.gameObject, iTween.Hash("time",0.48, "scale", Vector3.New(scaleSize,scaleSize,0), "easetype", iTween.EaseType.easeOutCirc) );
	iTween.RotateFrom(cardSpt.gameObject, iTween.Hash("time", 0.48, "z", originalCard.transform.eulerAngles.z, "easetype", iTween.EaseType.easeOutCirc) );
end

function this:clearPais()
	self.cardsArray[1].spriteName = self._cardPre;
	self.cardsArray[2].spriteName = self._cardPre;
	self.cardsArray[3].spriteName = self._cardPre;
	self.cardsArray[4].spriteName = self._cardPre;
	self.cardsArray[5].spriteName = self._cardPre;
	self.cardTypeTrans.gameObject:SetActive(false);
end
--[[
--/ <summary>
--/ 主玩家的比牌情况
--/ </summary>
--/ <param name="cardsList">Cards list.</param>
--/ <param name="cardType">Card type.</param>
--/ <param name="tryMoveRight">If set to <c>true</c> try move right.</param>
function this:SetCardTypeUser(  cardsList,  cardType)

	if nil == cardsList then
		--后两张牌移回原位并且显示牌背面
		for  i = 0,  #(self.cardsArray)-1  do 
			self.cardsArray[i+1].transform.localPosition = Vector3.New(-80 + i * self._cardInterval, 0, 0);
		end
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
		if self.cardTypeTrans.gameObject.activeSelf == true then
			self.cardTypeTrans.gameObject:SetActive(false);
		end
	else
		if self.cardTypeTrans.gameObject.activeSelf == false then
			self.cardTypeTrans.gameObject:SetActive(true);
		end
		for  i = 1,  #(cardsList) do 
			if cardsList[i] ~= nil  and   tostring(cardsList[i]) ~= "null" then
				self.cardsArray[i].spriteName = self._cardPre..tostring(cardsList[i]);
			end
		end
		local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		--显示牌型和牛几
		if cardType == 0 then
			cardTypeSprite.spriteName = "niu_0";
		elseif cardType > 0  and  cardType <= 10 then
			cardTypeSprite.spriteName = "niu_".. cardType;
		end
	end
end

function this:SetCardTypeYing()
	self.cardTypeTrans.gameObject:SetActive(false);
end
]]
function this:resetDeckPos()
	for  i=1, 5 do 
		self.cardsArray[i].transform.localPosition = self.cardOriginPos[i];
		self.cardsArray[i].gameObject.transform.rotation = Quaternion.New(0,0,0,0);
		self.cardsArray[i].alpha = 0;
	end
	self.recordPosAry = nil;

	self:UpdateSkinColor();
	if self.cardTypeTrans.gameObject.activeSelf==true then
		self.cardTypeTrans.gameObject:SetActive(false);
	end
	self.hasRotateCard = false;
	self.isSeeCard = false;
	self.isGiveUp  = false;
	self.isVSLose  = false;
	self.cardsAnima.enabled=false;
	self.cardvalue=nil;
	self.bankerShow=false;
	self.resultAnima.gameObject:SetActive(false);
end
--[[
function this:OnDrawGizmos()
	if self.path ~= nil then
		if  #(self.path)  > 0 then
			iTween.DrawPath(self.path);
		end
	end
	if self.path2 ~= nil then
		if  #(self.path2)  > 0 then
			iTween.DrawPath(self.path2);
		end
	end
end

function this:tweenSelfPai()
	iTween.Stop(self.cardsArray[1].gameObject);
	self.path = {};
	self.path[1] = Vector3.New(self.cardOriginPos[1].x - 30, self.cardOriginPos[1].y - 30, 0);
	self.path[2] = Vector3.New(self.cardOriginPos[1].x, self.cardOriginPos[1].y, 0);

	local ver1 = Vector3.New(self.cardOriginPos[1].x - 30, self.cardOriginPos[1].y - 30, 0);
	local ver2 = Vector3.New(self.cardOriginPos[1].x, self.cardOriginPos[1].y, 0);

	iTween.MoveTo(self.cardsArray[1].gameObject, iTween.Hash("position", ver1, "time", 1, "islocal", true));
	coroutine.start(AssistDo(1, function()
		iTween.MoveTo(self.cardsArray[0].gameObject, iTween.Hash("position", ver2, "time", 1, "islocal", true));
	end));

	iTween.MoveTo(gameObject, iTween.Hash("time", 2, "oncomplete", "firstCardMOut"));
end
]]
--/ <summary>
--/ 其他玩家的over情况
--/ </summary>
--/ <param name="cardsList">Cards list.</param>
--/ <param name="cardType">Card type.</param>
function this:SetCardTypeOther(  cardsList,  cardType,score)
	--log("显示玩家的牌");
	if cardsList == nil then
		for  i = 0,  #(self.cardsArray)-1  do 
			self.cardsArray[i+1].transform.localPosition = Vector3.New((i - 2) * self._cardInterval, 0, 0);
		end
		--self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);

		self:UpdateSkinColor();
		if self.cardTypeTrans.gameObject.activeSelf==true then
			self.cardTypeTrans.gameObject:SetActive(false);
		end
	else
		for  i = 1,  #(cardsList) do 
			if cardsList[i]~=nil  and   tostring(cardsList[i]) ~= "null" then
				self.cardsArray[i].spriteName = self._cardPre..tostring(cardsList[i]);
				--log("显示其余玩家牌值");
				--log(tostring(cardsList[i]));
			end
		end
		--local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		local cardTypeSprite = self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		
		--显示牌型和牛几
		self.cardsAnima.enabled=false;
		coroutine.wait(0.5);
		cardTypeSprite.gameObject:SetActive(true);
		self.cardsAnima.enabled=true;
		--if self.cardTypeTrans.gameObject.activeSelf == false then
			--self.cardTypeTrans.gameObject:SetActive(true);
		--end
		if cardType == 0 then
			cardTypeSprite.spriteName = "type_0";
			self.cardsAnima:Play("setcard_show_1");
		elseif cardType > 0  and  cardType <= 10 then
			--self.cardsArray[1].transform.localPosition = Vector3.New(-80, 0, 0);
			--self.cardsArray[2].transform.localPosition = Vector3.New(-50, 0, 0);
			--self.cardsArray[3].transform.localPosition = Vector3.New(-10, 0, 0);
			--self.cardsArray[4].transform.localPosition = Vector3.New(50, 0, 0);
			--self.cardsArray[5].transform.localPosition = Vector3.New(80, 0, 0);
			if score>0 then
				cardTypeSprite.spriteName = "type_".. cardType;
			else
				cardTypeSprite.spriteName = "graytype_".. cardType;
			end
			self.cardsAnima:Play("setcard_show_2");
		end
		--log("显示结束");
	end
end

function this:SetScore( score)
	self.bankerSprite:SetActive(false);
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
	
	if score == -1 then
		self.cardScoreObj:SetActive(false);
		self.resultAnima.gameObject:SetActive(false);
	else
		if score >= 1000000  or  score <= -1000000 then
			self.cardScoreBg.width = 220;
		end
		if score >= 0 then
			EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform, "+".. score, "plus_", 0.8);
		else
			EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform,  tostring(score), "minus_", 0.8);
		end
	end
end

function this:SetStartChip( parent,  jetton)
	local sprites = parent:GetComponentsInChildren(Type.GetType("UISprite",true));
	if sprites.Length > 1 then
		for i=0,sprites.Length-1 do
			local sprite = sprites[i];
			
			if not (sprite.gameObject.name == "Sprite_bg") then
				destroy(sprite.gameObject);
			end
		end
	end
	
	if jetton > 0 then
		--Adjust doule digits position to center 
		local jettonStr =  tostring(jetton);
		log("not SetStartChip================")
		EginTools.AddNumberSpritesCenterAdjust(self.jettonPrefab, parent.transform, jettonStr, "chipnum_", 0.8);
	else
		self.cardScoreObj.gameObject:SetActive(false);
	end
end
--[[
function this:SetStartChipOther2( parent,  jetton,  parent1)
	self:SetStartChip(parent, jetton);
	self.otherScore1 = parent1;
	self.otherScore1Ver = parent1.transform.localPosition;
	local vexs = parent.transform.localPosition;
	
	iTween.MoveTo(parent1,iTween.Hash ("position",Vector3.New(vexs.x, vexs.y, 0),"time", 0.5,"islocal", true));
end

function this:SetStartChipSelf2( parent,  jetton,  parent1)
	self:SetStartChip(parent, jetton);
	self.selfScore1 = parent1;
	self.otherScore1 = parent1.transform.localPosition;
	local vexs = parent.transform.localPosition;
	iTween.MoveTo(parent1, iTween.Hash ("position",Vector3.New(vexs.x, vexs.y, 0),"time", 0.5,"islocal", true));
	iTween.MoveTo(gameObject, iTween.Hash("time", 0.5, "oncomplete", "self:yinCangBtn2"));
end

function this:yinCangBtn2()
	self.otherScore1:SetActive(false);
	self.selfScore1:SetActive(false);
	self.otherScore1.transform.localPosition = self.otherScore1Ver;
	self.selfScore1.transform.localPosition = self.otherScore1;
end

function this:SetStartChipOther( parent,  jetton)
	self:SetStartChip(parent, jetton);
	local vexs = parent.transform.localPosition;
	iTween.MoveFrom(parent, iTween.Hash ("position",Vector3.New(vexs.x, vexs.y + 100, 0),"time", 0.5,"islocal", true));
end

function this:SetStartChipSelf( parent,  jetton)
	self:SetStartChip(parent, jetton);
	local vexs = parent.transform.localPosition;
	iTween.MoveFrom(parent, iTween.Hash ("position",Vector3.New(vexs.x, vexs.y - 100, 0),"time", 0.5,"islocal", true));
end
]]
function this:SetReady( toShow)
	if toShow  and  not self.readyObj.activeSelf then
		self.readyObj:SetActive(true);
	else
		self.readyObj:SetActive(false);
	end
end

function this:SetShow( toShow,  spritename)
	if self.showObj ~= nil  then
		if toShow  and  not self.showObj.activeSelf then
			self.showObj:SetActive(true);
			local UserOperation = self.showObj.transform:GetComponent("UISprite");
			UserOperation.spriteName = spritename;
			self.InvokeLua:Invoke("HideSprite",self.HideSprite, 1.5);
		else
			self.showObj:SetActive(false);
		end
	end
end

function this:HideSprite()
	self.showObj:SetActive(false);
end
--[[
function this:SetCallBanker( toShow)
	if self.callBankerObj ~= nil then
		if toShow  and  not self.callBankerObj.activeSelf then
			self.callBankerObj:SetActive(true);
		else
			self.callBankerObj:SetActive(false);
		end
	end
end
]]
function this:SetWait( toShow)
	if self.waitObj ~= nil then
		if toShow  and  not self.waitObj.activeSelf then
			self.waitObj:SetActive(true);
		else
			self.waitObj:SetActive(false);
		end
	end
end

function this:SetBet( jetton,  zhuangtai,  bagmoney)
	if bagmoney~=-1 then
		--self.userIntomoney.text = tostring(bagmoney + self._winMoney);
		self.userIntomoney.text = EginTools.HuanSuanMoney(bagmoney + self._winMoney);
		SoundMgr:playEft(SoundMgr.clipBet);
	end
	self.cardScoreObj:SetActive(true);
	--self.userNickname.alpha = 0;
	if self.countDown:GetComponent("UISprite").fillAmount ~= 1 then
		self.InvokeLua:CancelInvoke("TimeMinus");
		self.countDown:GetComponent("UISprite").fillAmount = 1;
		self.countDown:GetComponent("UISprite").alpha = 0;
	end
	if jetton>0 then
		self.userYazhuMoney.text =  tostring(jetton);
	end
	local choumacount = 0;
	if jetton <= 200 then
		choumacount = 2;
	elseif jetton > 100  and  jetton <= 300 then
		choumacount = 3;
	elseif jetton > 300 then
		choumacount = 4;
	else 
		choumacount = 1;
	end
	local depth = 10;
	for  i = 0, choumacount do 
		local count = math.Random(1, 6);
		local prefab_chouma = GameObject.Instantiate(self.chip);
		prefab_chouma.name = self.gameObject.name.."C";
		--add by xiaoyong 2016.1.14 for jetton fly to winner position.
		 table.insert(GameYSZ.jettonObjList,prefab_chouma);
		
		if self.transform.parent.gameObject.name == "VS_AnimaLayer" then
			prefab_chouma.transform.parent = GameObject.Find("Content").transform:FindChild("chipParent").transform;
		else
			--prefab_chouma.transform.parent = self.transform.parent;
			prefab_chouma.transform.parent = GameObject.Find("Content").transform:FindChild("chipParent").transform;
		end
		prefab_chouma.transform.position = self.bet_target.transform.position;
		prefab_chouma.transform.rotation = Quaternion.New(0,0,0,0);
		--prefab_chouma:GetComponent("UISprite").spriteName = "Chip"..math.floor(count);
		prefab_chouma.transform.localScale = Vector3.one;
		local targetPosition = GameObject.Find("Content").transform:FindChild("chipParent").transform.localPosition;

		--local x1 = 0.1 - 0.2*math.random();
		--local y1 = 0.2 - 0.2*math.random();
		local x1 = 150 - 300*math.random();
		local y1 = 100 - 200*math.random();

		iTween.MoveTo(prefab_chouma, iTween.Hash("x", x1, "y", y1, "time", 0.5,"islocal",true,"easetype", iTween.EaseType.easeOutCubic));
	end
	
end

function this:jettonFlyTo(vc3)
	self.isWinner = true;
	--log("筹码集中飞回");
	for  key,  jettonObj in ipairs(GameYSZ.jettonObjList) do
		if jettonObj ~= nil  then
			iTween.MoveTo(jettonObj, iTween.Hash("position", vc3, "time", 0.5, "easetype", iTween.EaseType.easeOutCubic));
			--Lua代替动画oncomplete回调函数
			coroutine.start(self.AfterDoing,self,0.5,self.jettonFlyCompleted,jettonObj);
		end
	end
end

function this:jettonFlyCompleted( obj)
	tableRemove(GameYSZ.jettonObjList,obj);
	destroy( obj );
end

function this:playWinAnima()
	self.winAnima.gameObject:SetActive(true);
	self.winAnima:playWithCallback(Util.packActionLua(function(self) self.winAnima.gameObject:SetActive(false); end,self));
end
--[[
function this:faPai( gObj,  pai,  x,  y,  rz,  timeC,  delay)

	if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end
	gObj.alpha = 0;
	gObj.spriteName = self._cardPre..pai;

	iTween.MoveFrom(gObj.gameObject, iTween.Hash("position", Vector3.New(x, y, 0), "rotation", Vector3.New(0,0,rz), "time", timeC, "islocal", false, "delay", delay, "onstart", "cardAlphaTo1", "onstarttarget", gameObject, "onstartparams", gObj, "easetype", iTween.EaseType.easeOutCirc));
end

function this:cardAlphaTo1( poker)
	poker.alpha = 1.0;
end
]]
function this:SetDeal( toShow,   infos,state)
	log("2222222222222");
	if toShow == nil then
		self:SetDealNil();
		return;
	end
	
	if not toShow then
		self.cardsTrans.gameObject:SetActive(false);
	else
		self.cardsTrans.gameObject:SetActive(true);
		if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end
		for key,  poker in ipairs(self.cardsArray) do
			if state==0 then
				poker.spriteName = self._cardPre.."green";
			elseif state==1 then
				poker.spriteName = self._cardPre.."green";
			elseif state==2 then
				poker.spriteName = "giveup";
			end	
			poker.alpha = 1.0;
			poker.gameObject:SetActive(true);
		end
	end
end
--弃牌
function this:SetDealNil()
	log("444444444");
	if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end
	for key,  poker in ipairs(self.cardsArray) do
		poker.alpha = 1.0;
		if poker.spriteName ~= "bipailose" then
			poker.spriteName ="giveup";
		end
	end
end
--[[
function this:SetzhanPai(  infos,  timeC,  delay)
	self.cardsTrans.gameObject:SetActive(true);
	if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend) end
	if infos ~= nil  and   #(infos)  > 0 then
		for  i = 0,  #(infos)-1 do 
			if infos[i+1] ~= nil then
				local poker = self.pokers["Sprite".. i];
				local v = 0;
				poker:ScaleChange(0.4, v, self._cardPre..tostring(infos[i+1]));
				v = v +0.01;
			end
		end
	end
end
]]
--[[add by xiaoyong for VS animation------>
--vars----
Vector3[] self.recordPosAry;
local self.hasRotateCard = false;
---methods---
function this:setDepthUp()
function this:resetDepth()
function this:cardsMoveTo(local tr)
function this:cardsReset()
function this:cardSkinToBreak()
function this:otherUserSeeCardAnima()
self:resetCardRotate()
self:giveUpCardAnima()
function this:recordOriginalPos()
function this:moveBack(object obj)
]]--
function this:setDepthUp()
	local tr = self.transform:FindChild("PlayerInfo/Sprite_headFrame");
	--if tr equal nil that means class is FootInfo extends this
	if tr == nil then
		local footInfo = GameObject.Find("FootInfo");
		footInfo:GetComponent("UIPanel").depth = footInfo:GetComponent("UIPanel").depth +8;
		local avatar = footInfo.transform:FindChild("Foot - Anchor/Info/Panel");
		avatar:GetComponent("UIPanel").depth = avatar:GetComponent("UIPanel").depth +10;
		local avatar_bg = footInfo.transform:FindChild("Foot - Anchor/Info/avatar_panel");
		avatar_bg:GetComponent("UIPanel").depth = avatar_bg:GetComponent("UIPanel").depth +10;
	else
		local avatar = self.transform:FindChild("PlayerInfo/Panel");
		local bankerSp=self.transform:FindChild("PlayerInfo/Panel_Head");
		tr:GetComponent("UISprite").depth = tr:GetComponent("UISprite").depth +1;
		avatar:GetComponent("UIPanel").depth = avatar:GetComponent("UIPanel").depth +8;
		bankerSp:GetComponent("UIPanel").depth = bankerSp:GetComponent("UIPanel").depth +8;
		self.userNickname.depth = self.userNickname.depth +1;
		self.userIntomoney.depth = self.userIntomoney.depth +1;
	end
	self.userYazhuMoney.alpha = 0;
	--self.cardsTrans:GetComponent("UIPanel").depth = self.cardsTrans:GetComponent("UIPanel").depth +20;
	--[[
	for key, spt in ipairs(self.cardsArray) do
		spt.depth = spt.depth +100;
	end
	]]
end

function this:resetDepth()
	local tr = self.transform:FindChild("PlayerInfo/Sprite_headFrame");
	--if tr equal nil that means class is FootInfo extends this
	if tr == nil then
		local footInfo = GameObject.Find("FootInfo");
		footInfo:GetComponent("UIPanel").depth = footInfo:GetComponent("UIPanel").depth -8;
		local avatar = footInfo.transform:FindChild("Foot - Anchor/Info/Panel");
		avatar:GetComponent("UIPanel").depth = avatar:GetComponent("UIPanel").depth -10;
		local avatar_bg = footInfo.transform:FindChild("Foot - Anchor/Info/avatar_panel");
		avatar_bg:GetComponent("UIPanel").depth = avatar_bg:GetComponent("UIPanel").depth -10;
	else
		local avatar = self.transform:FindChild("PlayerInfo/Panel");
		local bankerSp=self.transform:FindChild("PlayerInfo/Panel_Head");
		tr:GetComponent("UISprite").depth = tr:GetComponent("UISprite").depth -1;
		avatar:GetComponent("UIPanel").depth = avatar:GetComponent("UIPanel").depth -8;
		bankerSp:GetComponent("UIPanel").depth = bankerSp:GetComponent("UIPanel").depth -8;
		self.userNickname.depth = self.userNickname.depth -1;
		self.userIntomoney.depth = self.userIntomoney.depth -1;
	end
	self.userYazhuMoney.alpha = 1.0;
	coroutine.start(self.HideCard,self);
	--self.cardsTrans:GetComponent("UIPanel").depth = self.cardsTrans:GetComponent("UIPanel").depth -20;
	--[[
	for key,   spt in ipairs(self.cardsArray) do
		spt.depth = spt.depth -100;
	end
	]]
end
function this:cardsMoveTo( tr)
	if self.hasRotateCard then
		self:resetCardRotate();
	end
	self:recordOriginalPos();
	coroutine.start(self.HideCard,self);
	local clothThisPos;
	--log("比牌玩家位置")
	--log(self.transform.position.x);
	if self.transform.position.x< 0 then
		--clothThisPos = self.cardsArray[5].transform.position;
		clothThisPos = self.cardsArray[5].transform.position;
		--log("位置1111111");
		--log(clothThisPos);
	else
		--clothThisPos = self.cardsArray[1].transform.position;
		clothThisPos = self.cardsArray[1].transform.position;
		--log("位置222222");
		--log(clothThisPos);
	end
	for  i = 1, 5 do 
		self.cardsArray[i].spriteName = "card_green"; 
		--if tr equal nil that means class is FootInfo extends this
		--if self.transform:FindChild("PlayerInfo/Sprite_headFrame") == nil then 
			--self.cardsArray[i].transform.localScale = Vector3.New(0.75,0.75,1);
			self.cardsAnima.transform.localScale = Vector3.New(0.75,0.75,1);
		--end
		iTween.MoveTo(self.cardsArray[i].gameObject, iTween.Hash("position", clothThisPos,"time", 0.5));
		iTween.MoveTo(self.cardsArray[i].gameObject, iTween.Hash("position", tr.position, "time", 0.5, "delay", 0.5));
	end
end

function this:HideCard()
	self.cardsTrans.gameObject:SetActive(false);
	self.cardsAnima.enabled=false;
	coroutine.wait(0.01);
	self.cardsTrans.gameObject:SetActive(true);
end

function this:HideBankerSprite()
	if self.bankerShow then
		self.bankerSprite:SetActive(false);
	end
	coroutine.wait(0.01);
	if self.bankerShow then
		self.bankerSprite:SetActive(true);
		self.bankerSprite:GetComponent("Animator"):Play("banker_animation_default");
	end
end

function this:cardsReset(iswin)
	if self.recordPosAry == nil or #self.recordPosAry ==0 then return; end
	self.cardResetCount = 0;
	for  i =1, 5 do  
		--if tr equal nil that means class is FootInfo extends this
		--if self.transform:FindChild("PlayerInfo/Sprite_headFrame") == nil then
			--self.cardsArray[i].transform.localScale = Vector3.New(1,1,1);
			self.cardsArray[i].gameObject.transform.rotation = Quaternion.New(0,0,0,0);
			self.cardsAnima.transform.localScale = self.cardParentScale;
		if self.hasRotateCard and iswin then
			if self.cardvalue~=nil and #(self.cardvalue)>0 then
				self.cardsArray[i].spriteName=self._cardPre..self.cardvalue[i];
			end
		end
		--end
		iTween.MoveTo(self.cardsArray[i].gameObject, iTween.Hash("position", self.recordPosAry[1], "time", 0.6));
		--Lua代替动画oncomplete回调函数
		coroutine.start(self.AfterDoing,self,0.6,self.cardsRestCompleted);
	end
end

function this:cardsRestCompleted()
	if self.recordPosAry == nil or #self.recordPosAry ==0 then return; end
	
	self.cardResetCount =self.cardResetCount +1;
	if self.cardResetCount == 5 then
		if self.hasRotateCard then
			self.cardsAnima.enabled=true;
			if self:isSelf() then
				if self.showpaiTypeSprite.spriteName == "n_0" then
					log("自己展牌动画2");
					self.cardsAnima:Play("setshowcard_2");
				else
					log("自己展牌动画3");
					self.cardsAnima:Play("setshowcard_3");
				end				
			else
				log("别人展牌动画3");
				self.cardsAnima:Play("setshowcard_3");
			end
			--other player will enter this logic
			--[[
			if self.cardsArray[5].spriteName == "bipailose" then			
				for  i = 1, 5 do 
					iTween.MoveTo(self.cardsArray[i].gameObject, iTween.Hash("position", self.recordPosAry[i], "time", 0.6));
				end	
			else
				self:otherUserSeeCardAnima();
			end
			]]
		else
			for  i = 1, 5 do 
				iTween.MoveTo(self.cardsArray[i].gameObject, iTween.Hash("position", self.recordPosAry[i], "time", 0.6));
			end
			--This sprite means VS lose.
			if self.cardsArray[5].spriteName == "bipailose" then
				--if tr equal nil that means class is FootInfo extends this
				if self.transform:FindChild("PlayerInfo/Sprite_headFrame") == nil then
					self.InvokeLua:Invoke("giveUpCardAnima",self.giveUpCardAnima, 0.6);
				end
			end
		end
	end
end
function this:cardSkinToBreak()
	--log("显示灰色牌");
	for  i = 1, 5 do 
		self.cardsArray[i].spriteName ="giveup";
	end
	self.cardsArray[5].spriteName = "bipailose";
end
function this:cardShake()

end
function this:otherUserSeeCardAnima()
	if self.hasRotateCard then
		self:resetCardRotate();
	end
	self.hasRotateCard = true;
	self:recordOriginalPos();
	self.isSeeCard = true;
	self.cardsAnima.enabled=true;
	self.cardsAnima:Play("setshowcard_0");
	--[[
	if self.transform.position.x< 0 then
		for  i = 4, 0,-1 do
			self.cardsArray[i+1].transform.localPosition = Vector3.New(-10*i, 0,0):Add(self.cardsArray[i+1].transform.localPosition);
			iTween.RotateTo(self.cardsArray[i+1].gameObject, iTween.Hash("z", -60.0+(4-i)*15, "time", 0.8));
		end
	else
		for  i = 0, 4 do 
			self.cardsArray[i+1].transform.localPosition = Vector3.New(10*(4-i), 0,0):Add(self.cardsArray[i+1].transform.localPosition);
			iTween.RotateTo(self.cardsArray[i+1].gameObject, iTween.Hash("z", 60.0 - i*15, "time", 0.8));
		end
	end
	]]
end

function this:resetCardRotate( isNeedStopTween)
	if isNeedStopTween == nil then isNeedStopTween = true; end
	--if self.recordPosAry == nil or #self.recordPosAry ==0 then return; end
	for  i = 1, 5 do 
		if isNeedStopTween then iTween.Stop(self.cardsArray[i].gameObject); end
		self.cardsArray[i].gameObject.transform.rotation = Quaternion.New(0,0,0,0);
		--self.cardsArray[i].transform.position = self.recordPosAry[i];
		if self:isSelf() then
			self.cardsArray[i].transform.localPosition = Vector3.New(-90+45*(i-1),0,0);
		else
			self.cardsArray[i].transform.localPosition = Vector3.New(-80+40*(i-1),0,0);
		end
		
	end
end

function this:giveUpCardAnima()
	if self.hasRotateCard then
		--self:resetCardRotate();
	else
		self.cardsAnima.enabled=false;
		for  i = 1, 5 do 	
			local pos=0;
			if self:isSelf() then
				pos = 35*(i-3);
			else
				pos = 30*(i-3);
			end
			iTween.MoveTo(self.cardsArray[i].gameObject, iTween.Hash("position", Vector3.New(pos,0,0),"islocal",true, "time", 0.8));
			self.cardsArray[i].gameObject.transform.rotation = Quaternion.New(0,0,0,0);
		end
	end
	self:recordOriginalPos();
	--local clothThisPos;
	--local padding = 0.025;
	--local   startIndex = 5;
	--if tr equal nil that means class is FootInfo extends this
	
	if self.transform:FindChild("PlayerInfo/Sprite_headFrame") == nil then
		--[[
		clothThisPos = self.cardsArray[5].transform.position.x;
		padding = 0.05;
		iTween.MoveTo(self.cardsArray[1].gameObject, iTween.Hash("x", -0.1, "time", 0.8));
		iTween.MoveTo(self.cardsArray[2].gameObject, iTween.Hash("x", -0.05, "time", 0.8));
		iTween.MoveTo(self.cardsArray[3].gameObject, iTween.Hash("x", 0, "time", 0.8));
		iTween.MoveTo(self.cardsArray[4].gameObject, iTween.Hash("x", 0.05, "time", 0.8));
		iTween.MoveTo(self.cardsArray[5].gameObject, iTween.Hash("x", 0.1, "time", 0.8));
		]]
		--Lua代替动画oncomplete回调函数
		coroutine.start(self.AfterDoing,self,0.8,self.grayCard);
	else
		--[[
		if self.transform.position.x< 0 then
			clothThisPos = self.cardsArray[1].transform.position.x;
			startIndex = 0;
		else
			clothThisPos = self.cardsArray[5].transform.position.x;
		end
		for  i = 0, 4 do 
			local pos = clothThisPos-(startIndex-i)*padding;
			iTween.MoveTo(self.cardsArray[i+1].gameObject, iTween.Hash("x", pos, "time", 0.8));
			
		end
		]]
		--Lua代替动画oncomplete回调函数
		coroutine.start(self.AfterDoing,self,0.8,self.grayCard);
	end
end
function this:recordOriginalPos()
	if self.recordPosAry == nil  or #(self.recordPosAry)==0 then
		self.recordPosAry = {};
		for  i = 1, 5 do 
			self.recordPosAry[i] = self.cardsArray[i].gameObject.transform.position;
		end
	end
end

function this:grayCard()
	log("333333333333");
	self:SetDeal();
end

function this:showSelfCard(  infos,  cardType ,  hasSeeCard,  isEnd,score)
	if infos ~= nil  and   #(infos)  > 0 then
		self.cardvalue=infos;
		for  i = 1,  #(infos) do 
			if infos[i] ~= nil  and   tostring(infos[i]) ~= "null" then
				self.cardsArray[i].spriteName = self._cardPre..tostring(infos[i]);
			end
		end
	end
	if isEnd then	
		--coroutine.start(self.HideCard,self);
		self.showpaiType:SetActive(false);
		--local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		local cardTypeSprite = self.cardTypeTrans.transform:FindChild("Sprite"):GetComponent("UISprite");
		--显示牌型和牛几
		self.cardsAnima.enabled=false;
		coroutine.wait(0.5);
		cardTypeSprite.gameObject:SetActive(true);
		self.cardsAnima.enabled=true;
		--self.cardTypeTrans.gameObject:SetActive(true);
		if cardType == 0 then
			cardTypeSprite.spriteName = "type_0";
			self.cardsAnima:Play("setcard_3");
		elseif cardType > 0  and  cardType <= 10 then
			if score>0 then
				cardTypeSprite.spriteName = "type_".. cardType;
			else
				cardTypeSprite.spriteName = "graytype_".. cardType;
			end
			self.cardsAnima:Play("setcard_4");
		end	
	else
		if not hasSeeCard then
			self.hasRotateCard=true;
			self.cardsAnima.enabled=true;
			if cardType == 0 then
				self.showpaiTypeSprite.spriteName = "n_0";
				self.cardsAnima:Play("setshowcard_0");
			elseif cardType > 0  and  cardType <= 10 then
				self.showpaiTypeSprite.spriteName = "n_".. cardType;
				self.cardsAnima:Play("setshowcard_1");
			end	
			coroutine.start(self.AfterDoing,self,0.8,function()
				self.showpaiType:SetActive(true);
			end);
		end
	end
	
	

	--[[
	if not hasSeeCard  or  self.cardsArray[5].spriteName == "bipailose" then
		self.cardsTrans.gameObject:SetActive(true);
		if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end
		for  i = 0, 4 do 
			local interval = 129;
			if cardType ~= 0 then
				interval = 122;
				if i== 3 then
					interval = 130;
				elseif i == 4 then
					interval = 128;
				end
			end
			iTween.MoveTo(self.cardsArray[i+1].gameObject, iTween.Hash("x", -260 + i*interval, "time", 0.5, "islocal", true));
		end
		coroutine.wait(0.6);
	end
	if self.cardsArray[2].spriteName == "card_green"  or  self.cardsArray[2].spriteName == "giveup" then
		--step 2
		for  i = 1, 5 do 
			iTween.ScaleTo(self.cardsArray[i].gameObject, iTween.Hash("x", 0, "time", 0.5));
		end
		coroutine.wait(0.4);
		for  i = 1, 5 do 
			iTween.ScaleTo(self.cardsArray[i].gameObject, iTween.Hash("x", 1, "time", 0.5));
		end
	end
	--step 3
	if infos ~= nil  and   #(infos)  > 0 then
		for  i = 1,  #(infos) do 
			if infos[i] ~= nil  and   tostring(infos[i]) ~= "null" then
				self.cardsArray[i].spriteName = self._cardPre..tostring(infos[i]);
			end
		end

	else
		--Just for unit test---->
		for  i = 1, 5 do 
			self.cardsArray[i].spriteName = self._cardPre.."3";
		end
		--<---------
	end
	if isEnd then
		self.cardTypeTrans.gameObject:SetActive(true);
		local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
		--显示牌型和牛几
		if cardType == 0 then
			cardTypeSprite.spriteName = "niu_0";
		elseif cardType > 0  and  cardType <= 10 then
			cardTypeSprite.spriteName = "niu_".. cardType;
		end
	end
	]]
end

function this:showUpNickName()
	self.userNickname.alpha = 1.0;
	self.userYazhuMoney.text = "";
end

function this:showUpWinLoseMoney( money)
	self.userNickname.alpha = 1.0;
	self.userYazhuMoney.text = "";
	self.resultAnima.gameObject:SetActive(true);
	self.resultAnima:play(tonumber(money));
end

function this:isSelf()
	--return (self.transform:FindChild("PlayerInfo/Sprite_headFrame") == nil);	
	return (self.gameObject.name=="YSZPlayer_"..EginUser.Instance.uid);
end


function this:isFemale()

	local sptIndex = string.split(self.userAvatar.spriteName,'_');

	if tonumber(sptIndex[2])%2 == 0 then
		return 0;
	else
		return 1;
	end
end

function this:getlightPos() 
	return self.cardsTrans.position;
end

function this:refVSstate( forceHide )
	if forceHide ==nil then forceHide = false; end
	--log("出现指示标志");
	--log(self.isVSLose);
	--log(self.isGiveUp);
	--log(forceHide);
	if  self.isVSLose  or  self.isGiveUp  or  forceHide then
		--self.cardsTrans:GetComponent("BoxCollider").enabled = false;
		--log("隐藏手指");
		if self.vsHand then
			self.vsHand:SetActive(false);
			self.cardsTrans.gameObject:GetComponent("BoxCollider").enabled=false;
		end
		--self.cardsTrans:GetComponent("UIPanel").depth = 2;
	else
		--log("显示手指");
		--self.cardsTrans:GetComponent("BoxCollider").enabled = true;
		if self.vsHand then
			self.vsHand:SetActive(true);
			self.cardsTrans.gameObject:GetComponent("BoxCollider").enabled=true;
		end
		--self.cardsTrans:GetComponent("UIPanel").depth = 11;
	end
end

function this:AfterDoing( offset,  run,params)
	coroutine.wait(offset);
	if self.gameObject then
		run(self,params);
	end
end

function this:ResetCardRotation()
	for i=1,5 do
		self.cardsArray[i].gameObject.transform.rotation = Quaternion.New(0,0,0,0);
	end
end