
local this = LuaObject:New()
DHSZPlayerCtrl = this



	
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

this.Shaizi_language = {
	'你好!',
	'你玩的这么溜，你家里人知道么!',
	'抱歉，这把我赢定了!',
	'呵呵，不作死就不会死!',
	'哎，感觉这把要跪啊!',
	'人生入戏，全靠演技!',
	'别走，有本事再来一把!',
	'小心点，当心顺子豹子',
}


function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	self.userAvatar = nil
	self.userNickname = nil
	self.userIntomoney =nil
	self.infoDetail = nil	
	self.kDetailNickname = nil		
	self.kDetailLevel =  nil
	self.kDetailBagmoney =  nil	
	self.cardsTrans = nil
	self.jiaodianParent=nil;
	self.soundSend =nil;
	self.jettonPrefab = nil;
	self.btn_jiaodian=nil;
	self.win_board=nil;
	self.win_anima=nil;
	self.lose_anima=nil;
	self.readyObj=nil;
	self.waitObj=nil;
	
	self.giftPosition=Vector3.zero;
	self.Uid=0;
	self.position_id=-1;
	self.isStart=false;
	self.isown=false;
	self.isJingCai=false;
	self._num=0;
	self._numMax=0;
	self._currTime=0;
	self.sex=-1;
	self.message_prompt=nil;
	self.cardsArray = nil;	
	self.UserChip = 0;
	self.GuessTrueOrFalse=-1;
	self.jingcai_duihao=nil;
end
function this:Init()
--初始化变量
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0;
	self._cardInterval = 50;
	self._cardPre = "shaizi_";
	self._timeInterval = 3;
	self._timeLasted = 0;

	self.position_id=-1;
	self.isStart=false;
	self.isown=false;
	self.isJingCai=false;
	self._num=0;
	self._numMax=0;
	self._currTime=0;
	self.sex=-1;
	
	self._alive = false;
	self.UserChip = 100;
	
	self.avatar_id=0;
	self.Uid=0;
	self.nickname="";
	self.bagmoney=0;
	self.GuessTrueOrFalse=-1;--竞猜  够 value=1   不够  value=0
	self.localIndex=-1;
	
	self.position = GlobalVar.PlayerPosition.Down;
	
	
	self.cardsTrans = self.transform:FindChild("Output/Cards")		--扑克牌的父物体
	self.cardsTransAniam = self.transform:FindChild("Output/Cards").gameObject:GetComponent("Animator");	--扑克牌的父物体
	self.readyObj=self.transform:FindChild("Output/ready").gameObject;--准备
	self.waitObj=self.transform:FindChild("Output/wait").gameObject;--等待
	
	self.jiaodianParent=self.transform:FindChild("Output/jiaodian").gameObject;--叫点父物体
	self.dianshu=self.jiaodianParent.transform:FindChild("dianshu"):GetComponent("UISprite");--点数
	self.geshu=self.jiaodianParent.transform:FindChild("geshu"):GetComponent("UISprite");--点数
	
	self.soundSend = ResManager:LoadAsset("gamenn/Sound","SEND_CARD") --resLoad("Sound/SEND_CARD");		
	self.jettonPrefab = ResManager:LoadAsset("gamenn/Prefabs","JettonPrefab") -- resLoad("Prefabs/JettonPrefab");
	
	self.open_shaizhong=self.transform:FindChild("Output/Anima_open_panel").gameObject;--开骰盅
	
	self.cardsArray = {};		--玩家的扑克牌(排序后)
	
	self.message_prompt=self.transform:FindChild("Output/message_prompt/message_prompt").gameObject;	
	self.jingcai_duihao=self.transform:FindChild("Output/message_prompt/jingcai_tishi").gameObject;
	--log(self.message_prompt.name);
	if self.gameObject.name == "User" then
		local userInfo = GameObject.Find("FootInfo/Foot - Anchor/Info").transform
		self.userAvatar = self.transform:FindChild("avatar_board/Container/Sprite_Avatar"):GetComponent("UISprite");
		self.giftPosition=self.userAvatar.gameObject.transform.position;
		self.userNickname = nil
		self.userIntomoney =nil
		self.infoDetail = nil	
		self.kDetailNickname = nil		
		self.kDetailLevel =  nil
		self.kDetailBagmoney =  nil
		self.NNCount=self.transform:FindChild("avatar_board/avatar_board"):GetComponent("UISprite");--倒计时
		self.AddNumAnima = userInfo:FindChild("NumAnima/AddNumAnima").gameObject:GetComponent("UILabel")	
		self.MinusNumAnima = userInfo:FindChild("NumAnima/MinusNumAnima").gameObject:GetComponent("UILabel")	
		--[[
		for i=0,self.cardsTrans.childCount-3  do
		local card = self.cardsTrans:GetChild(i).gameObject;
			table.insert(self.cardsArray,card:GetComponent("UISprite"));	
		end
		]]
		for i=1,5 do
			table.insert(self.cardsArray,self.cardsTrans.transform:FindChild("Sprite_"..i):GetComponent("UISprite"));	
		end
		
		
		self.btn_jiaodian=self.transform:FindChild("buttonPanel/Button_jiaodian").gameObject;--叫点按钮
		self.win_board=nil;
		self.win_anima=self.transform:FindChild("buttonPanel/panel_win").gameObject;--胜利动画
		self.lose_anima=self.transform:FindChild("buttonPanel/panel_lose").gameObject;--失败动画
		
		
	else
		self.userAvatar = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject:GetComponent("UISprite")	-- 玩家头像	
		self.giftPosition=self.userAvatar.gameObject.transform.position;
		self.userNickname = self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel")	--玩家昵称
		self.userIntomoney =self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");	--玩家带入金额
		--self.infoDetail = self.transform:FindChild("PlayerInfo/Info_detail").gameObject;	
		self.infoDetail=nil;
		self.kDetailNickname = self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");		
		self.kDetailLevel =  self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney =  self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");	
		
		self.NNCount=self.transform:FindChild("Output/NNCount"):GetComponent("UISprite");--倒计时
		self.AddNumAnima = self.transform:FindChild("PlayerInfo/NumAnima/AddNumAnima").gameObject:GetComponent("UILabel")	
		self.MinusNumAnima = self.transform:FindChild("PlayerInfo/NumAnima/MinusNumAnima").gameObject:GetComponent("UILabel")
		--[[
		for i=0,self.cardsTrans.childCount-2  do
			local card = self.cardsTrans:GetChild(i).gameObject;
			table.insert(self.cardsArray,card:GetComponent("UISprite"));	
		end	
		]]
		for i=1,5 do
			table.insert(self.cardsArray,self.cardsTrans.transform:FindChild("Sprite_"..i):GetComponent("UISprite"));	
		end
		self.btn_jiaodian=nil;	
		self.win_board=self.transform:FindChild("Output/win_board").gameObject;--胜利黄色框
		self.win_anima=nil;
		self.lose_anima=nil;	
	end
end
function this:Awake()
	
	self:Init();

	
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		local btn_Avatar = self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject
		GameDHSZ.mono:AddClick(btn_Avatar,self.OnClickInfoDetail,self);
	
	end
	
	------------逻辑代码------------
	self.parentX = self.cardsTrans.localPosition.x
	self.parentY = self.cardsTrans.localPosition.y
	self.parentZ = self.cardsTrans.localPosition.z
	
end

function this:Start()
	
	--self:UpdateSkinColor();
	
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
function this:SetPlayerInfo(uid,avatar, nickname, intomoney, level,position_index)
	self.Uid=uid;
	self.avatar_id=avatar;
	self.nickname=this:LengNameSub(nickname);
	self.bagmoney=intomoney;
	if avatar%2==0 then
		self.sex=0;
	else
		self.sex=1;
	end
	
	self.userAvatar.spriteName = "avatar_"..avatar
	self.userNickname.text = this:LengNameSub(nickname);
	self.playernickname=nickname;
	self.userIntomoney.text = self:NumberAddWan(intomoney)
	
	self.kDetailNickname.text = nickname;
	self.kDetailBagmoney.text = intomoney
	self.kDetailLevel.text = level;
	self.position_id = position_index;
	
	self.cardsTrans.gameObject:SetActive(false);
end
function this:LengNameSub( text)
	
	if   LengthUTF8String(text) > 6 then
		return SubUTF8String(text,12);
	end
	return text;
end

function this:OnClickInfoDetail()	
	GameDHSZ.info_avatar.spriteName="avatar_"..self.avatar_id;
	GameDHSZ.info_nickname.text=self.nickname;
	GameDHSZ.info_money.text=tostring(self.bagmoney);
	GameDHSZ.info_Uid=self.Uid;
	GameDHSZ.playerInfoPanel:SetActive(true);
	if GameDHSZ.msgError.activeSelf then
		GameDHSZ.msgError:SetActive(false);
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
	self:TimeUpdate();
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
	--[[
	if not toShow then
		
		for key,sprite in ipairs(self.cardsArray) do
			sprite.gameObject:SetActive(false);
		end
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
	en
	]]
end

--主玩家的比牌情况
function this:SetCardTypeUser(cardsList,dianshu,iszhai)
    if cardsList==nil then
		for key,v in ipairs(self.cardsArray) do		
			v.transform:FindChild("Sprite").gameObject:SetActive(false);
		end
		--self.open_shaizhong:SetActive(false);
	else
		
		for key,v in ipairs(self.cardsArray) do		
			v.spriteName = self._cardPre..cardsList[key]
			if iszhai==1 then
				if tonumber(cardsList[key])~=dianshu then
					v.transform:FindChild("Sprite").gameObject:SetActive(true);
				else
					GameDHSZ.zonggeshu=GameDHSZ.zonggeshu+1;
				end
			elseif iszhai==0 then
				if tonumber(cardsList[key])~=dianshu and tonumber(cardsList[key])~=1 then
					v.transform:FindChild("Sprite").gameObject:SetActive(true);
				else
					GameDHSZ.zonggeshu=GameDHSZ.zonggeshu+1;
				end
			end
		end
	end
end
function this:SetCardWinAnimation(score)  
	if  score > 0 then  
		if self.win_board~=nil then
			self.win_board:SetActive(true);
		end
		if self.win_anima~=nil then
			self.win_anima:SetActive(true);
			UISoundManager.Instance.PlaySound("win");
			coroutine.start(self.AfterDoing,self,3,function()
				self.win_anima:SetActive(false);
				self.win_anima:GetComponent("UIWidget").alpha=1;
			end); 
		end
		self.AddNumAnima.gameObject:SetActive(true)
		self.AddNumAnima.text = "+"..score
	else
		if self.lose_anima~=nil then
			self.lose_anima:SetActive(true);
			UISoundManager.Instance.PlaySound("lose");
			coroutine.start(self.AfterDoing,self,3,function()
				self.lose_anima:SetActive(false);
			end); 
		end
		self.MinusNumAnima.gameObject:SetActive(true)
		self.MinusNumAnima.text = tostring(score)
	end  
	coroutine.start(self.AfterDoing,self,3,function()
		self.AddNumAnima.gameObject:SetActive(false)
		self.MinusNumAnima.gameObject:SetActive(false)
	end); 
end
--其他玩家的比牌情况
function this:SetCardTypeOther(cardsList,dianshu,iszhai)
    if cardsList==nil then
		--self:UpdateSkinColor();
		for key,v in ipairs(self.cardsArray) do		
			v.transform:FindChild("Sprite").gameObject:SetActive(false);
		end
		--self.open_shaizhong:SetActive(false);
		self.win_board:SetActive(false);
	else	
		--self.cardsTrans.gameObject:SetActive(true)
			for key,v in ipairs(self.cardsArray) do
				v.spriteName = self._cardPre..cardsList[key];
				if iszhai==1 then
					if tonumber(cardsList[key])~=dianshu then
						v.transform:FindChild("Sprite").gameObject:SetActive(true);
					else
						GameDHSZ.zonggeshu=GameDHSZ.zonggeshu+1;
					end
				elseif iszhai==0 then
					if tonumber(cardsList[key])~=dianshu and tonumber(cardsList[key])~=1 then
						v.transform:FindChild("Sprite").gameObject:SetActive(true);
					else
						GameDHSZ.zonggeshu=GameDHSZ.zonggeshu+1;
					end
				end
			end
		
	end
end
function this:SetUserChip(TheChip)
	self.UserChip = TheChip;
        self:SetScore(-1);
end
function this:SetScore(score)
	
end

function this:SetBet(jetton)
   
end
function this:SetReady(toShow)
	self.readyObj:SetActive(toShow);
end
function this:SetShow(toShow)
    
end
function this:SetWait(toShow)
  self.waitObj:SetActive(toShow);
end

function this:SetShaiZhong()
	self.cardsTrans.gameObject:SetActive(true);
	self.cardsTransAniam.enabled=false;
end


function this:TimeUpdate()
	if self.isStart then
		self._num = self._num -0.1
		if self._num > 0 then 
			if self.isJingCai then
				GameDHSZ.jingcaiTime.text=tostring(math.floor(self._num));
			else
				if self._num <= 5   then
					if self._currTime == 1 then
						if self.isown then
							UISoundManager.Instance.PlaySound("clock"); 
						end
					end
					self._currTime = self._currTime -0.1
					if self._currTime < 0 then
						self._currTime = 1;
					end
				end 
				
				--log(self._num);
				 self.NNCount.fillAmount = (self._num)/self._numMax;
				 if self._num<=1 then
					if self.btn_jiaodian~=nil then
						self.btn_jiaodian:GetComponent("BoxCollider").enabled=false;
						self.btn_jiaodian.transform:FindChild("Background"):GetComponent("UISprite").spriteName="own_jiaodian_3";
					end
				 end
			 end
		else
			if self.isJingCai then
				GameDHSZ.jingcaiTime.text=tostring(6);
				GameDHSZ.jingcaiPanel:SetActive(false);
				self.isJingCai=false;
			else
				self.NNCount.gameObject:SetActive(false)
				self.isStart = false;
			end
		end
	end
end

function this:SetTimeDown( _time,isown,isJingCai)
	_time = _time-1;
	self._currTime = 1;
	self._num =  math.floor(_time); 
	self._numMax = self._num; 
	self.isStart = true;
	self.isown=isown;
	self.isJingCai=isJingCai;
	self.NNCount.gameObject:SetActive(true)
	self.NNCount.fillAmount = 1;  
end


function this:SetChuShiHua()
	self.cardsTrans.gameObject:SetActive(true);
	self.cardsTransAniam.enabled=true;
	self.cardsTransAniam:Play("shzizhong_default");
	if self.win_board~=nil then
		self.win_board:SetActive(false);
	end
	
end

function this:SetStartAima(isown,shaizicount)
	self.cardsTrans.gameObject:SetActive(true);
	self.cardsTransAniam.enabled=true;
	if isown then
		--log(#(self.cardsArray));
		for key,v in ipairs(self.cardsArray) do  
			--log(key.."===========");
			--log(shaizicount[key]);
			--log(#(shaizicount));
			v.spriteName = self._cardPre..shaizicount[key];
		end
		--log("自己要骰钟");
		self.cardsTransAniam:Play("shzizhong");
		
	else
		--log("别人要骰钟");
		self.cardsTransAniam:Play("shzizhong");
	end
	--self:HideJiaoDian();
end

function this:HideJiaoDian()
	self.jiaodianParent:SetActive(false);
	self.jingcai_duihao:SetActive(false);
end


function this:SetJiaoDian(geshu,dianshu,isown)
	self.dianshu.spriteName="shaizidianshu_"..dianshu;
	self.geshu.spriteName="num_"..geshu;
	if geshu~=0 then
		self.jiaodianParent:SetActive(true);
	end
	self.NNCount.gameObject:SetActive(false)
	self.isown=isown;
	self.isStart=false;
	--log(self.position_id);
	--log("叫点人位置");
end


function this:SetEndAnima()
	self.cardsTransAniam.enabled=true;
	self.cardsTransAniam:Play("shzizhong_1");
	self.NNCount.gameObject:SetActive(false)
end

function this:SetOpen()
	self.NNCount.gameObject:SetActive(false);
	self.open_shaizhong:SetActive(true);
	coroutine.start(self.AfterDoing,self,2,function()
			self.open_shaizhong:SetActive(false);
	end);
end

function this:setMessage(index)
	--log(index.."语音index");
	self.message_prompt:SetActive(true);
	--local yuyin=XMLResource.Instance:Str("mahjonglanguage_"..(index-1));
	--local yuyin=XMLResource.Instance:Str("message_error_6");
	--log(yuyin);
	--self.message_prompt.transform:FindChild("Label"):GetComponent("UILabel").text=yuyin;
	self.message_prompt.transform:FindChild("Label"):GetComponent("UILabel").text=this.Shaizi_language[index];
	--log("发语音");
	if self.sex==0 then
		UISoundManager.Instance.PlaySound("m_yuyin_"..index)
	else
		UISoundManager.Instance.PlaySound("w_yuyin_"..index)
	end
	coroutine.start(self.AfterDoing,self,2,function()
		self.message_prompt.transform:FindChild("Label"):GetComponent("UILabel").text="";	
		self.message_prompt:SetActive(false);
	end)
end

function this:HideWinOrLoseCount()
	self.cardsTransAniam.enabled=false;
	if self.win_board~=nil then
		self.win_board:SetActive(false);
	end
    self.AddNumAnima.gameObject:SetActive(false)
	self.MinusNumAnima.gameObject:SetActive(false)
	self.cardsTrans.gameObject:SetActive(false)
	self.jiaodianParent:SetActive(false);
	self.jingcai_duihao:SetActive(false);
end

function this:SetOpenAnimation(jsplayerIndex)
	local position_minus=jsplayerIndex-self.position_id;
	if position_minus<0 then
		position_minus=position_minus+6;
	end
	self.cardsTransAniam.enabled=true;
	self.cardsTransAniam:Play("kaishai_"..position_minus);
end

function this:ShowOrHideShaiZhong(show)
	if show then
		self.cardsTransAniam.gameObject:SetActive(true);
		self.cardsTransAniam.enabled=true;
		self.cardsTransAniam:Play("shzizhong_show");
	else
		self.cardsTransAniam.gameObject:SetActive(false);
		self.cardsTransAniam.enabled=false;
	end
end


function this:AfterDoing(offset, run)
    coroutine.wait(offset);
	if self.gameObject==nil then
		return;
	end
	run();
end
