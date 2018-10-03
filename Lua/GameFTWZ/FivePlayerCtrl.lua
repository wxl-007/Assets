
local this = LuaObject:New()
FivePlayerCtrl = this


	
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
	self.readyObj = nil;
	self.showObj = nil;
	self.allObj = nil;
	self.guoObj = nil;
	self.qibj = nil
	self.shouObj = nil;
	self.callBankerObj = nil;
	self.waitObj = nil;
	self.cardTypeTrans = nil;
	self.userAvatar = nil;
	self.userNickname = nil;
	self.userIntomoney = nil;
	self.cardsArray = nil;
	self.cardsTrans = nil;
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

 
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	self._cardInterval = 40;
	self._cardPre = "card_";
	self._timeInterval = 3;
	self._timeLasted = 0;
	self.cardScoreP = nil;
	self.cardTypeP = nil;
	self.showP = nil;
	self.callBankerP = nil;
	self.infoDetailP = nil;
	self.firstCardPosition = nil;
	self.firstcNum = 0;
	self.cNum = 0;	
	self.path = nil;
	self.path2 = nil;
	self.selfScore1= nil;
	self.otherScore1= nil;

	self.selfScore1Ver= nil;
	self.otherScore1Ver= nil;
	self.emotionParent = nil;
	
end
function this:Init()
--初始化变量
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	self._cardInterval = 40;
	self._cardPre = "card_";
	self._timeInterval = 3;
	self._timeLasted = 0;
	self.cardScoreP = nil;
	self.cardTypeP = nil;
	self.showP = nil;
	self.callBankerP = nil;
	self.infoDetailP = nil;
	self.firstCardPosition = nil;
	self.firstcNum = 0;
	self.cNum = 0;
	self.path = nil;
	self.path2 = nil;
	self.selfScore1= nil;
	self.otherScore1= nil;

	self.selfScore1Ver= nil;
	self.otherScore1Ver= nil;
	self.emotionPrefab={};
	for i=1,27 do 
		--table.insert(self.emotionPrefab,i,ResManager:LoadAsset("gamenn/gamebr","biaoqing_"..i));
		table.insert(self.emotionPrefab,i,ResManager:LoadAsset("expressionpackage/biaoqing_"..i,"biaoqing_"..i));
	end
	self.position = GlobalVar.PlayerPosition.Down;
	if self.gameObject.name == "User" then
		self.readyObj = self.transform:FindChild("Output/Sprite_ready").gameObject;
		self.showObj = self.transform:FindChild("Output/Sprite_show").gameObject;
		self.allObj = self.transform:FindChild("Output/Sprite_all").gameObject;
		self.guoObj = self.transform:FindChild("Output/Sprite_guo").gameObject;
		self.qibj = self.transform:FindChild("Output/Sprite_qi").gameObject;
		self.shouObj = self.transform:FindChild("Output/Cards/Sprite/Sprite").gameObject;
		self.callBankerObj = nil;
		self.waitObj = nil;
		self.cardTypeTrans = self.transform:FindChild("Output/CardType");
		self.userAvatar = nil;
		self.userNickname = nil;
		self.userIntomoney = nil;
	
		self.cardsTrans = self.transform:FindChild("Output/Cards");
		self.cardScoreObj = self.transform:FindChild("Output/CardScore").gameObject;
		self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
		self.bankerSprite = self.transform:FindChild("Output/Sprite_banker").gameObject;
		self.bankerBg = nil;
		self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD");
		self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab");
		self.infoDetail = nil;
		self.kDetailNickname = nil;
		self.kDetailLevel = nil;
		self.kDetailBagmoney = nil;
		local tFootInfo = GameObject.Find("Foot - Anchor")
		self.emotionParent= tFootInfo.transform:FindChild("Info/emotionParent");
		self.message_prompt=tFootInfo.transform:FindChild("Info/message_prompt").gameObject;
	else
	
		self.readyObj = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_ready").gameObject;
		self.showObj = self.transform:FindChild("Output/Sprite_show").gameObject;
		self.allObj = self.transform:FindChild("Output/Sprite_all").gameObject;
		self.guoObj = self.transform:FindChild("Output/Sprite_guo").gameObject;
		self.qibj = self.transform:FindChild("Output/Sprite_qi").gameObject;
		self.shouObj = nil;
		self.callBankerObj = self.transform:FindChild("Output/Sprite_callBanker").gameObject;
		self.waitObj = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_waitting").gameObject;
		self.cardTypeTrans = self.transform:FindChild("Output/CardType");
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel");
		self.userIntomoney = self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");
		
		self.cardsTrans = self.transform:FindChild("Output/Cards");
		self.cardScoreObj = self.transform:FindChild("Output/CardScore").gameObject;
		self.cardScoreBg = self.transform:FindChild("Output/CardScore/Sprite_bg").gameObject:GetComponent("UISprite");
		self.bankerSprite = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject;
		self.bankerBg = self.transform:FindChild("PlayerInfo/Sprite_headframe_banker").gameObject;
		self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD");
		self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab");
		self.infoDetail =  self.transform:FindChild("PlayerInfo/Info_detail").gameObject;
		self.kDetailNickname = self.infoDetail.transform:FindChild("Label1/Nickname").gameObject:GetComponent("UILabel");
		self.kDetailLevel = self.infoDetail.transform:FindChild("Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney = self.infoDetail.transform:FindChild("Label3/BagMoney").gameObject:GetComponent("UILabel");
		self.emotionParent=self.transform:FindChild("PlayerInfo/Panel_Head/emotionParent");
		self.message_prompt=self.transform:FindChild("Output/message_prompt").gameObject
	end
	
	self.cardsArray ={};
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
		--其他玩家头像按钮
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject
		GameFTWZ.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
	else
		--看底牌按钮
		local card = self.cardsArray[1].gameObject;
		GameFTWZ.mono:AddClick(card, self.firstCardMOver,self);
	end
	
	-----游戏逻辑----
	self.parentX = self.cardsTrans.localPosition.x ;
	self.parentY = self.cardsTrans.localPosition.y;
	self.parentZ = self.cardsTrans.localPosition.z;

	self.firstCardPosition = self.cardsArray [1].transform.localPosition;

end

function this:Start()
	if self.cardScoreObj ~= nil and self.cardTypeTrans ~= nil and self.showObj ~= nil and self.callBankerObj ~= nil and self.infoDetail ~= nil then
		self.cardScoreP = self.cardScoreObj.transform.localPosition;
		self.cardTypeP = self.cardTypeTrans.localPosition;
		self.showP = self.showObj.transform.localPosition;
		self.callBankerP = self.callBankerObj.transform.localPosition;
		self.infoDetailP = self.infoDetail.transform.localPosition;
	end
	local anchor = self.gameObject:GetComponent("UIAnchor");
	if anchor.side == UIAnchor.Side.Right then
		self.parentX = -170;
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
		self.cardScoreObj.transform.localPosition = Vector3.New(-self.cardScoreP.x, self.cardScoreP.y, self.cardScoreP.z);
		self.cardTypeTrans.localPosition = Vector3.New(-self.cardTypeP.x, self.cardTypeP.y, self.cardTypeP.z);
		self.showObj.transform.localPosition = Vector3.New(-self.showP.x, self.showP.y, self.showP.z);
		self.infoDetail.transform.localPosition = Vector3.New(-self.infoDetailP.x, self.infoDetailP.y, self.infoDetailP.z);
		self.callBankerObj.transform.localPosition = Vector3.New(-self.callBankerP.x, self.callBankerP.y, self.callBankerP.z);
	elseif anchor.side ==UIAnchor.Side.Top then
		self.cardScoreObj.transform.localPosition = Vector3.New(-self.transform.localPosition.x, -190, 0);
		self.parentX = 188;
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
	elseif anchor.side == UIAnchor.Side.Left then
		self.parentX = 170;
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
	end
	self._alive = true;
end



---/ 换肤时更新扑克牌
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

function this:setPlayMoney( intomoney)
	if  self.userIntomoney == nil then
		local gamekk = GameObject.Find ("Label_Bagmoney");

		if gamekk~=nil then
			gamekk:GetComponent("UILabel").text = 
				EginTools.NumberAddComma (intomoney);
		end
	else
		self.userIntomoney.text = EginTools.NumberAddComma(intomoney);
	end
end

function this:OnClickInfoDetail()
	if self.infoDetail.activeSelf then
		self.infoDetail:SetActive(false);
		self._timeLasted = 0;
	else
		self.infoDetail:SetActive(true);
	end
end



function this:UpdateIntoMoney( intomoney)
	if  self.userIntomoney == nil then
		GameObject.Find ("Label_Bagmoney"):GetComponent("UILabel").text = 
		EginTools.NumberAddComma (intomoney);
	else
		self.userIntomoney.text = "¥ "..EginTools.NumberAddComma(intomoney);
	end
end


function this:tiShi( tiS)
	self.allObj:SetActive (false);
	self.showObj:SetActive (false);
	self.guoObj:SetActive (false);

	if tiS == "all" then
		self.allObj:SetActive(true);
	elseif tiS == "guo" then
		self.guoObj:SetActive(true);
	elseif tiS == "xia" or tiS == "jia" or tiS == "gen" then
		local uisp = self.showObj:GetComponent("UISprite");
		self.showObj:SetActive(true);
		uisp.spriteName = "ti_"..tiS;
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
	else
		self.cardsTrans.gameObject:SetActive(true);
		if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end
		if infos ~= nil and #(infos) > 0 then
			for  i,info in ipairs(infos) do
				self.cardsArray[i].spriteName = self._cardPre..self:transformCardInfo(info) ;
			end
		end
	end
end

function this:transformCardInfo(cardInfo)
 	return cardInfo;
end

function this:SetSelfH1_2(  firstCardNum, secCardNum)
	self.cardsTrans.gameObject:SetActive(true);
	if self.shouObj ~= nil then self.shouObj:SetActive (false); end
	self.cardsArray [1].transform.localPosition = self.firstCardPosition;
	self.cardsTrans.localPosition = Vector3.New(self.parentX+40, self.parentY, self.parentZ);
	self.cNum = 2;
	self:faPai(self.cardsArray[1],"green",self.firstCardPosition.x,self.parentY+200,0.5,0); 
	self:faPai(self.cardsArray[2],tostring(secCardNum) ,self.cardsArray [2].transform.localPosition.x,self.parentY+200,0.5,1);
	
	self.firstcNum = firstCardNum;
end

function this:SetSelfH3_4_5( ind, secCardNum,delay)
	self.cardsTrans.localPosition = Vector3.New(self.parentX+10*(5-ind), self.parentY, self.parentZ);
	if ind==4 then
		self.cardsTrans.localPosition = self.cardsTrans.localPosition +  Vector3.New(-10, 0, 0)
	end
	if ind==5 then
		self.cardsTrans.localPosition = self.cardsTrans.localPosition +  Vector3.New(-20, 0, 0)
	end
	self.cNum = ind;
	local tDelayTime = 1
	if delay ~= nil then
		tDelayTime = delay
		--error("SetSelfH3_4_5 delay:"..delay)
	end
	self:faPai(self.cardsArray[ind], tostring(secCardNum),self.cardsArray [ind].transform.localPosition.x,self.parentY+200,0.5,tDelayTime);

end

function this:SetOtherH1_2( secCardNum)
	
	self.cardsTrans.gameObject:SetActive(true);
	self.cardsTrans.localPosition = Vector3.New(self.parentX+45, self.parentY, self.parentZ);
	self.cardsArray [1].transform.localPosition = self.firstCardPosition;
	
	self:faPai(self.cardsArray[1],"green",self.firstCardPosition.x,self.parentY-200,0.5,0.5); 
	self:faPai(self.cardsArray[2], tostring(secCardNum),self.cardsArray [2].transform.localPosition.x,self.parentY-200,0.5,1.5);
end
function this:SetOtherH3_4_5( ind, secCardNum,delay)
	self.cardsTrans.localPosition = Vector3.New(self.parentX+15*(5-ind), self.parentY, self.parentZ);
	local tDelayTime = 1
	if delay ~= nil then
		tDelayTime = delay
	end
	self:faPai(self.cardsArray[ind], tostring(secCardNum),self.cardsArray [ind].transform.localPosition.x,self.parentY-200,0.5,tDelayTime);
end

function this:firstCardMOver()
	if self.firstcNum>=0 then
		if self.shouObj ~= nil then self.shouObj:SetActive (true); end
		self.cardsArray [1].spriteName = self._cardPre..self:transformCardInfo(self.firstcNum) ;
		self:tweenSelfPai();
	end
end

function this:firstCardMOut()
	if  self.firstcNum >= 0 then
		if self.shouObj ~= nil then self.shouObj:SetActive (false); end
		self.cardsArray [1].spriteName = self._cardPre.."green";
	end
end


function this:clearPais()
	
	self.cardsArray[1].spriteName = self._cardPre;
	self.cardsArray[2].spriteName = self._cardPre;
	self.cardsArray[3].spriteName = self._cardPre;
	self.cardsArray[4].spriteName = self._cardPre;
	self.cardsArray[5].spriteName = self._cardPre;
	
	self.firstcNum = -1;
	if self.shouObj ~= nil then self.shouObj:SetActive (false); end
	self.cardTypeTrans.gameObject:SetActive (false);
	self.qibj:SetActive(false)
end


function this:SetLate(cards)
	self.cardsTrans.gameObject:SetActive (true);
	for i,card in ipairs(self.cardsArray)  do
		card.gameObject:SetActive(true);
		if cards ~= nil and #(cards) > 0 then
			card.spriteName = self._cardPre..self:transformCardInfo(cards[i]) ;
		end
	end
end


---主玩家的比牌情况
function this:SetCardTypeUser( cardType)
	self.cardsArray [1].spriteName = self._cardPre..self:transformCardInfo(self.firstcNum) ;
	self.firstcNum = -1;
	self.cardTypeTrans.gameObject:SetActive (true);
	local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
	if cardType==-1 then
		cardTypeSprite.spriteName = "five_ct_9";
		self.qibj:SetActive(true)
		self.cardTypeTrans.gameObject:SetActive (false)
	else
		cardTypeSprite.spriteName = "five_ct_"..cardType;
	end
	self.allObj:SetActive (false);
	self.showObj:SetActive (false);
	self.guoObj:SetActive (false);
end

--弃牌
function this:QiPai()
	self.cardTypeTrans.gameObject:SetActive (false);
	local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
	cardTypeSprite.spriteName = "five_ct_9";
	self.allObj:SetActive (false);
	self.showObj:SetActive (false);
	self.guoObj:SetActive (false);
	self.qibj:SetActive(true)
end

function this:SetCardTypeYing()
	self.cardTypeTrans.gameObject:SetActive (false);
end


function this:tweenOtherPai()
	iTween.Stop (self.cardsArray [1].gameObject);
	
	self.path2 = {};
	self.path2[1]=Vector3.New(self.firstCardPosition.x-30,self.firstCardPosition.y+30,0);
	self.path2[2]=Vector3.New(self.firstCardPosition.x,self.firstCardPosition.y,0);

	local ver1 = Vector3.New(self.firstCardPosition.x - 30, self.firstCardPosition.y + 30, 0);
	local ver2 = Vector3.New(self.firstCardPosition.x,self.firstCardPosition.y,0);

	iTween.MoveTo (self.cardsArray [1].gameObject,iTween.Hash("position",ver1,"time",1,"islocal", true));
	
	local tempRun = function ()
		iTween.MoveTo (self.cardsArray [1].gameObject,iTween.Hash("position",ver2,"time",1,"islocal", true));
	end
	coroutine.start(self.AfterDoing,self,1,tempRun);
	
end



function this:OnDrawGizmos()
	if self.path ~= nil then
		if  #(self.path)>0 then
			--有问题
			iTween.Drawself.path(self.path);
		end
	end

	if self.path2 ~= nil then
		if #(self.path2)>0 then
			--有问题
			iTween.Drawself.path(self.path2);
		end
	end
end

function this:tweenSelfPai()
	
	iTween.Stop (self.cardsArray [1].gameObject);
	

	self.path = {};
	self.path[1]=Vector3.New(self.firstCardPosition.x-30,self.firstCardPosition.y-30,0);
	self.path [2] = Vector3.New(self.firstCardPosition.x, self.firstCardPosition.y, 0);

	local ver1 = Vector3.New(self.firstCardPosition.x-30,self.firstCardPosition.y-30,0);
	local ver2 = Vector3.New(self.firstCardPosition.x, self.firstCardPosition.y, 0);

	iTween.MoveTo (self.cardsArray [1].gameObject,iTween.Hash("position",ver1,"time",1,"islocal", true));
	
	
	local tempRun = function ()
		iTween.MoveTo (self.cardsArray [1].gameObject,iTween.Hash("position",ver2,"time",1,"islocal", true));
		
		local tempRun2 = function ()
			self:firstCardMOut();
		end
		coroutine.start(self.AfterDoing,self,1,tempRun2);
	end
	coroutine.start(self.AfterDoing,self,1,tempRun);
	
	
end

  

---/ 其他玩家的比牌情况

function this:SetCardTypeOther( firCardNum, cardType)
	 
	if  firCardNum ~= -1 then
		self.cardsArray [1].spriteName = self._cardPre..self:transformCardInfo(firCardNum) ;
	end 
	
	self.cardTypeTrans.gameObject:SetActive (true);
	local cardTypeSprite = self.cardTypeTrans:GetComponentInChildren(Type.GetType("UISprite",true));
	if cardType==-1 then
		self.qibj:SetActive(true)
		self.cardTypeTrans.gameObject:SetActive(false)
		cardTypeSprite.spriteName = "five_ct_9";
	else
		cardTypeSprite.spriteName = "five_ct_"..cardType;
	end
	self.allObj:SetActive (false);
	self.showObj:SetActive (false);
	self.guoObj:SetActive (false);
end

function this:SetScore( score)
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
	else
		if score >= 1000000 or score <= -1000000 then
			self.cardScoreBg.width = 220;
		end
		if score >= 0 then
			EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform, "+"..score, "plus_", 0.8);
		elseif score < 0 then
			EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform, tostring(score), "minus_", 0.8);
		end
	end
end

function this:SetBet( jetton)
	local sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true));
	if sprites.Length > 1 then
		for i=0,sprites.Length-1 do 
			local sprite = sprites[i];
			if sprite.gameObject.name ~= "Sprite_bg" then
				destroy(sprite.gameObject);
			end
		end
	end

	if jetton>0 and not self.cardScoreObj.activeSelf then
		EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform,  tostring(jetton), "plus_",0.8);
	else
		self.cardScoreObj:SetActive(false);
	end
end

function this:SetStartChip( parent, jetton)
	local tLabelObj = parent.transform:FindChild("numLabel")
	if tLabelObj ~= nil then
		tLabel = tLabelObj:GetComponent("UILabel")
		tLabel.text = tostring(jetton)
		return nil
	end
	local sprites = parent:GetComponentsInChildren(Type.GetType("UISprite",true));
	
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

function this:setMessage(index,yuyin)
	--error(index.."语音index");
	self.message_prompt:SetActive(true);
	--local yuyin=XMLResource.Instance:Str("mahjonglanguage_"..(index-1));
	--local yuyin=XMLResource.Instance:Str("message_error_6");
	--error(yuyin);
	self.message_prompt.transform:FindChild("message_prompt/Label"):GetComponent("UILabel").text=yuyin;
	--self.message_prompt.transform:FindChild("Label"):GetComponent("UILabel").text=this.mahjongList[index];
	if self.sex==0 then
		--error("srwzmchat_"..(index-1));
		--UISoundManager.Instance.PlaySound("srwzmchat_"..(index-1))
		self:PlaySound("wzmchat_"..(index-1))
	else
		--error("srwzwchat_"..(index-1));
		--UISoundManager.Instance.PlaySound("srwzwchat_"..(index-1))
		self:PlaySound("wzwchat_"..(index-1))
	end
	coroutine.start(self.AfterDoing,self,2,function()
		self.message_prompt.transform:FindChild("message_prompt/Label"):GetComponent("UILabel").text="";	
		self.message_prompt:SetActive(false);
	end)
end

function this:SetStartChipOther2( parent,  jetton, parent1)
	self:SetStartChip (parent,jetton);
	self.otherScore1 = parent1;
	self.otherScore1Ver = parent1.transform.localPosition;
	parent.transform.localPosition = Vector3.New(201,80,0)
	local vexs = parent.transform.localPosition;
	

	local table1 = iTween.Hash("position",Vector3.New(vexs.x, vexs.y, 0),"time", 0.5,"islocal", true);
	iTween.MoveTo (parent1, table1);
end

function this:SetStartChipSelf2( parent, jetton, parent1)
	self:SetStartChip (parent,jetton);
	self.selfScore1 = parent1;
	self.selfScore1Ver = parent1.transform.localPosition;
	parent.transform.localPosition = Vector3.New(201,25,0)
	local vexs = parent.transform.localPosition;
	
	local table1 = iTween.Hash("position",Vector3.New(vexs.x, vexs.y, 0),"time", 0.5,"islocal", true);
	iTween.MoveTo (parent1, table1);

	local table2 = iTween.Hash("time",0.5)
	iTween.MoveTo (self.gameObject,table2);
	
	local tempRun = function ()
		self:yinCangBtn2();
	end
	coroutine.start(self.AfterDoing,self,0.5,tempRun);
end

function this:yinCangBtn2()
	self.otherScore1:SetActive (false);
	self.selfScore1:SetActive (false);
	self.otherScore1.transform.localPosition = self.otherScore1Ver;
	self.selfScore1.transform.localPosition = self.selfScore1Ver;
end


function this:SetStartChipOther( parent,  jetton)
	self:SetStartChip (parent,jetton);
	parent.transform.localPosition = Vector3.New(77.9,130,0)
	local vexs = parent.transform.localPosition;
	
	local table1 = iTween.Hash("position",Vector3.New(vexs.x, vexs.y+100, 0),"time", 0.5,"islocal", true);
	iTween.MoveFrom (parent, table1);
end

function this:SetStartChipSelf( parent, jetton)
	self:SetStartChip (parent,jetton);
	parent.transform.localPosition = Vector3.New(78,-40,0)
	local vexs = parent.transform.localPosition;

	local table1 = iTween.Hash("position",Vector3.New(vexs.x, vexs.y-100, 0),"time", 0.5,"islocal", true);
	iTween.MoveFrom (parent, table1);
end

function this:SetReady( toShow)
	if toShow and not self.readyObj.activeSelf then
		self.readyObj:SetActive(true);
	else
		self.readyObj:SetActive(false);
	end
end

function this:SetShow( toShow)
	if self.showObj ~= nil then
		if toShow and not self.showObj.activeSelf then
			self.showObj:SetActive(true);
		else
			self.showObj:SetActive(false);
		end
	end
end

function this:SetCallBanker( toShow)
	if self.callBankerObj ~= nil  then
		if toShow and not self.callBankerObj.activeSelf then
			self.callBankerObj:SetActive(true);
		else
			self.callBankerObj:SetActive(false);
		end
	end
end

function this:SetWait( toShow)
	if self.waitObj ~= nil then
		if toShow and not self.waitObj.activeSelf then
			self.waitObj:SetActive(true);
		else
			self.waitObj:SetActive(false);
		end
	end
end


function this:faPai( gObj, pai, x, y, _time, delay)
	local tempRun = function ()
		if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end
		gObj.spriteName = self._cardPre..self:transformCardInfo(pai) ;
		local table1 = iTween.Hash("position",Vector3.New(x, y, 0),"time", _time,"islocal", true);
		local tGameObj = GameObject.Find("GameFTWZ")
		if tGameObj then
			local tFBObj = tGameObj.transform:FindChild("Panel_background/Anchor")
			if tFBObj then
				table1 = iTween.Hash("position",Vector3.New(tFBObj.transform.position.x, tFBObj.transform.position.y, 0),"time", _time,"islocal", false);
			end
		end
		iTween.MoveFrom (gObj.gameObject, table1);
	end
	coroutine.start(self.AfterDoing,self,delay,tempRun);
	
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

function this:setEmotion(number)
	--log(number.."实例化的表情下标");
	local aa=GameObject.Instantiate(self.emotionPrefab[number]);
	--log("是实例化");
	aa.transform.parent=self.emotionParent.transform;
	aa.transform.localScale=Vector3.one;
	aa.transform.localPosition=Vector3.zero;
	if number==1 then
		aa.transform.localPosition=Vector3.New(-3,1,0);
	elseif number==2 then
		aa.transform.localPosition=Vector3.New(-8,3,0);
	elseif number==3 then
		aa.transform.localPosition=Vector3.New(-7,4,0);
	elseif number==4 then
		aa.transform.localPosition=Vector3.New(-1,16,0);
	elseif number==5 then
		aa.transform.localPosition=Vector3.New(-4,9,0);
	elseif number==6 then
		aa.transform.localPosition=Vector3.New(1,15,0);
	elseif number==7 then
		aa.transform.localPosition=Vector3.New(-8,4,0);
	elseif number==8 then
		aa.transform.localPosition=Vector3.New(14,17,0);
	elseif number==9 then
		aa.transform.localPosition=Vector3.New(-6,26,0);
	elseif number==10 then
		aa.transform.localPosition=Vector3.New(-1,20,0);
	elseif number==11 then
		aa.transform.localPosition=Vector3.New(-4,0,0);
	elseif number==12 then
		aa.transform.localPosition=Vector3.New(-35,4,0);
	elseif number==13 then
		aa.transform.localPosition=Vector3.New(-4,-30,0);
	elseif number==14 then
		aa.transform.localPosition=Vector3.New(0,0,0);
	elseif number==15 then
		aa.transform.localPosition=Vector3.New(-11,6,0);
	elseif number==16 then
		aa.transform.localPosition=Vector3.New(-1,17,0);
	elseif number==17 then
		aa.transform.localPosition=Vector3.New(-3,-3,0);
	elseif number==18 then
		aa.transform.localPosition=Vector3.New(-1,-27,0);
	elseif number==19 then
		aa.transform.localPosition=Vector3.New(-1,0,0);
	elseif number==20 then
		aa.transform.localPosition=Vector3.New(-2,17,0);
	elseif number==21 then
		aa.transform.localPosition=Vector3.New(-4,0,0);
	elseif number==22 then
		aa.transform.localPosition=Vector3.New(0,9,0);
	elseif number==23 then
		aa.transform.localPosition=Vector3.New(-4,6,0);
	elseif number==24 then
		aa.transform.localPosition=Vector3.New(13,18,0);
	elseif number==25 then
		aa.transform.localPosition=Vector3.New(-2,-5,0);
	elseif number==26 then
		aa.transform.localPosition=Vector3.New(23,7,0);
	elseif number==27 then
		aa.transform.localPosition=Vector3.New(-16,23,0);
	end
	coroutine.start(self.AfterDoing,self,1.25,function()
		destroy(aa);
	end)
end

function this:PlaySound( clipName)
	local aSource=UISoundManager.Instance.soundMap[clipName];
	if aSource~=nil then
		--error("PLaySound "..clipName)
		NGUITools.PlaySound(aSource,0.5);
	else
		error("PLaySound "..clipName.."notexsit")
	end
end