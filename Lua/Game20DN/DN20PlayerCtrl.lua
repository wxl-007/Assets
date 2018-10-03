require "GameNN/LuaCount"
local this = LuaObject:New()
DN20PlayerCtrl = this

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

function this:init()
	--扑克牌父物体的位置
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0; 
	self._cardPre = "card_";
	self._timeInterval = 3;
	self._timeLasted=0;
	self.cardScoreP=nil;
	self.cardTypeP=nil;
	self.showP=nil;
	self.callBankerP=nil;
	self.infoDetailP=nil;
	self.chouma=nil;
	self.cardsposition = {};
	self.selectPanelPosition_x = 0;
	
	self.secondCardCount=nil;
	self.secondCardType=0;
	self.endScore=0;
	
	self.selectBetPanel = nil 

	self.isBanker = 0;--0为未分配,1为庄,2为闲
	self.isFanPai = true;
    
	self.isMingpai=false;  --是否明牌
	self.isMiaosha=false;  --是否秒杀
	self.isFanBei=false;   --结算是否翻倍
	--/ 扑克牌的父物体
	self.cardsTrans=self.transform:FindChild("Output/Cards");
	self.cardsArray = {}
	for i=0,self.cardsTrans.childCount-1  do
		local card = self.cardsTrans:GetChild(i).gameObject;
		if (card.name == "Sprite") then
			table.insert(self.cardsArray,card:GetComponent("UISprite"));	
		end
	end
	
	
	--self.commitObj  = self.transform:FindChild("Output/Sprite_commit").gameObject;
	self.chooseChipObj=self.transform:FindChild("ChooseChips").gameObject;
	self.chooseChipPrefab=self.transform:FindChild("ChooseChips/ButtonPrefab").gameObject;
	self.chooseOtherPosition=self.transform:FindChild("ChooseChips/ButtonOther").gameObject;
	self.btnEndPosition=self.transform:FindChild("ChooseChips/ButtonPrefabEndPosition").gameObject;
	
	self.label_money_from=self.transform:FindChild("Output/CardScore/Label_bagmoney_from");
	self.label_money_to=self.transform:FindChild("Output/CardScore/Label_bagmoney_to");
	self.baozha_parent=self.transform:FindChild("Output/Cards/baozha_parent");
	self.cardTypeTrans=self.transform:FindChild("Output/CardType");
	self.cardTypeSprite=self.transform:FindChild("Output/CardType/CardType").gameObject:GetComponent("UISprite");
	self.ChipAnimator_1=self.transform:FindChild("ChooseChips/CrashAnima_1").gameObject:GetComponent("Animator");
	self.ChipAnimator_2=self.transform:FindChild("ChooseChips/CrashAnima_2").gameObject:GetComponent("Animator");
	self.ChipAnimator_3=self.transform:FindChild("ChooseChips/CrashAnima_3").gameObject:GetComponent("Animator");
	self.ChipAnimator_4=self.transform:FindChild("ChooseChips/CrashAnima_4").gameObject:GetComponent("Animator");
	self.ChipAnimator_5=self.transform:FindChild("ChooseChips/CrashAnima_5").gameObject:GetComponent("Animator");
	self.ChipAnimator_6=self.transform:FindChild("ChooseChips/CrashAnima_6").gameObject:GetComponent("Animator");
	
	
	self.Betfly=self.transform:FindChild("ChooseChips/Betfly").gameObject:GetComponent("Animator");
	
	self.cardType_baopai=self.transform:FindChild("Output/CardType/baopai_parent").gameObject:GetComponent("Animator");
	self.ChipAnimator_label_1=self.transform:FindChild("ChooseChips/CrashAnima_1/btncrash/label").gameObject:GetComponent("UILabel");
	self.ChipAnimator_label_2=self.transform:FindChild("ChooseChips/CrashAnima_2/btncrash/label").gameObject:GetComponent("UILabel");
	self.ChipAnimator_label_3=self.transform:FindChild("ChooseChips/CrashAnima_3/btncrash/label").gameObject:GetComponent("UILabel");
	self.ChipAnimator_label_4=self.transform:FindChild("ChooseChips/CrashAnima_4/btncrash/label").gameObject:GetComponent("UILabel");
	self.ChipAnimator_label_5=self.transform:FindChild("ChooseChips/CrashAnima_5/btncrash/label").gameObject:GetComponent("UILabel");
	self.ChipAnimator_label_6=self.transform:FindChild("ChooseChips/CrashAnima_6/btncrash/label").gameObject:GetComponent("UILabel");
	
	self.getCardType=self.transform:FindChild("Output/GetCardType").gameObject;
	self.getcardTypePosition=self.transform:FindChild("Output/GetCardTypePosition").gameObject;
	self.getType=self.transform:FindChild("Output/GetCardType/GetType").gameObject:GetComponent("UISprite");
	self.cardScoreObj=self.transform:FindChild("Output/CardScore").gameObject;
	self.cardScoreBg=self.transform:FindChild("Output/CardScore/Sprite_win_bg").gameObject:GetComponent("UISprite");
	
	self.cardsTarget=self.transform:FindChild("cardsTarget");
	self.score_label_1=self.transform:FindChild("Output/CardScore/Label_bagmoney_1").gameObject:GetComponent("UILabel");
	self.score_label_2=self.transform:FindChild("Output/CardScore/Label_bagmoney_2").gameObject:GetComponent("UILabel"); 
	
	
	--新添加的秒杀与明牌的各物体
	--self.double_position=self.transform:FindChild("double_position").gameObject;
	self.double_MPorMS=self.transform:FindChild("double_position/double_MPorMS").gameObject:GetComponent("Animator");
	self.mingpai=self.transform:FindChild("double_position/double_MPorMS/mingpai");
	self.mingpai_up=self.transform:FindChild("double_position/double_MPorMS/mingpai_up").gameObject;
	self.mingpai_sprite_1=self.transform:FindChild("double_position/double_MPorMS/mingpai_up/Sprite_1").gameObject:GetComponent("UISprite");
	self.mingpai_sprite_2=self.transform:FindChild("double_position/double_MPorMS/mingpai_up/Sprite_2").gameObject:GetComponent("UISprite");
	self.target_to=self.transform:FindChild("double_position/double_MPorMS/target_to");
	self.target_from_left=self.transform:FindChild("double_position/double_MPorMS/target_from_left");
	self.target_from_right=self.transform:FindChild("double_position/double_MPorMS/target_from_right");
	self.target_tingzhi=self.transform:FindChild("double_position/target_tingzhi");
	self.target_SartPosition=self.transform:FindChild("double_position/target_SartPosition");
    self.double_MPorMS_1=self.transform:FindChild("double_position/double_MPorMS_1").gameObject;
	self.mingpai_sprite_11=self.transform:FindChild("double_position/double_MPorMS_1/mingpai_up/Sprite_1").gameObject:GetComponent("UISprite");
	self.mingpai_sprite_22=self.transform:FindChild("double_position/double_MPorMS_1/mingpai_up/Sprite_2").gameObject:GetComponent("UISprite");

	self.banker_message=self.transform:FindChild("banker_message").gameObject:GetComponent("UISprite");
	
	
	if(self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) )then 
	
		self.showObj=self.transform:FindChild("Output/Sprite_show").gameObject
		self.callBankerObj=self.transform:FindChild("Output/Sprite_callBanker").gameObject
		self.waitObj=self.transform:FindChild("PlayerInfo/Panel/Sprite_waitting").gameObject
		self.readyObj  = self.transform:FindChild("PlayerInfo/Panel/Sprite_ready").gameObject;
		self.btnChipTargetFrom=self.transform:FindChild("ChooseChips/ChooseChipsTargetFrom").gameObject;
		self.btnChipTargetTo=self.transform:FindChild("ChooseChips/ChooseChipsTargetTo").gameObject;
		 
		self.board_sprite=self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject:GetComponent("Animator");
		--self.board_to=self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_headFrame_to").gameObject;
	 
		self.gameTimeCount=self.transform:FindChild("OtherCount").gameObject; 
		
		
		--self.zhuangjia=self.transform:FindChild("PlayerInfo/zhuangjia").gameObject;
		--self.banker_shanguangtarget=self.transform:FindChild("PlayerInfo/Panel_Head/banker_shanguang_target").gameObject;
	 
		--self.shanguangAnima=self.transform:FindChild("PlayerInfo/Panel_Head/shanguangAnima").gameObject:GetComponent("Animator");
		 
		 --/ 玩家头像
		self.userAvatar=self.transform:FindChild("PlayerInfo/Panel/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
		--/ 玩家昵称
		self.userNickname=self.transform:FindChild("PlayerInfo/Label_nickname").gameObject:GetComponent("UILabel");
		--/ 玩家带入金额
		self.userIntomoney=self.transform:FindChild("PlayerInfo/Label_bagmoney").gameObject:GetComponent("UILabel");
	
		 
		--self.bankerBg=self.transform:FindChild("PlayerInfo/Panel_Head/Sprite_banker").gameObject;
		--self.bankershanguang=self.transform:FindChild("PlayerInfo/Panel_Head/banker_shanguang").gameObject:GetComponent("UISprite");
		 
		 self.infoDetail=self.transform:FindChild("PlayerInfo/Info_detail").gameObject;
		self.kDetailNickname=self.transform:FindChild("PlayerInfo/Info_detail/Label1/Nickname").gameObject:GetComponent("UILabel");
		self.kDetailLevel=self.transform:FindChild("PlayerInfo/Info_detail/Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney=self.transform:FindChild("PlayerInfo/Info_detail/Label3/BagMoney").gameObject:GetComponent("UILabel");
		
		
		self.background=nil;
		self.choumaprefab=nil;
		self.target=nil;
		--self.zhuang_sprite=nil;
	else
		
		
		self.btnChipTargetFrom=self.transform:FindChild("ChooseChips/ButtonFrom").gameObject;
		self.btnChipTargetTo=self.transform:FindChild("ChooseChips/ButtonTo").gameObject;
		
		--self.zhuang_sprite=self.transform.parent:FindChild("banker_sprite").gameObject;
		self.board_sprite=self.transform:FindChild("avatar_board").gameObject:GetComponent("Animator");
		--self.board_to=self.transform:FindChild("avatar_board/Container/avatar_board_to").gameObject;
		 
		self.gameTimeCount=self.transform:FindChild("OwnCount").gameObject;  
		
		--self.zhuangjia=self.transform:FindChild("avatar_board/Container/zhuangjia").gameObject;
		
		--self.banker_shanguangtarget=self.transform:FindChild("avatar_board/Container/banker_shanguangtarget").gameObject;
		
		
		--self.shanguangAnima=self.transform:FindChild("avatar_board/Container/shanguangAnima").gameObject:GetComponent("Animator");

		--self.bankerBg=self.transform:FindChild("avatar_board/Container/banker_board").gameObject;
		--self.bankershanguang=self.transform:FindChild("avatar_board/Container/bankershanguang").gameObject:GetComponent("UISprite");

		
		self.showObj=nil
		self.callBankerObj=nil
		self.waitObj=nil
		self.readyObj  = self.transform:FindChild("Output/Sprite_ready").gameObject;
		self.userAvatar=nil;
		--/ 玩家昵称
		self.userNickname=nil;
		--/ 玩家带入金额
		local info = GameObject.Find("FootInfo");
		self.userIntomoney = info.transform:FindChild("Foot - Anchor/Info/Money/Label_Bagmoney").gameObject:GetComponent("UILabel");
		
		self.infoDetail=nil;
		self.kDetailNickname=nil;
		self.kDetailLevel=nil;
		self.kDetailBagmoney=nil;
		self.background=nil;
		self.choumaprefab=nil;
		self.target=nil;
	end
	
	self.NNCount = LuaCount:New(self.gameTimeCount);
	self.NNCount.m_prefix = "time_"
	self.NNCount:SetSendMeessage(Game20DN,Game20DN.UserShow); 
	self:HideTimedown();
	

	
	
	--self.identity = self.gameTimeCount.transform:FindChild("edge/identity").gameObject:GetComponent("UILabel");
	--self.edge = self.gameTimeCount.transform:FindChild("edge").gameObject;
	
	self.baozha_prefab=ResManager:LoadAsset("game20dn/Prefab","baopai_baozha");
	self.xingprefab=ResManager:LoadAsset("game20dn/Prefab","banker_shanxing");
	self.soundSend=ResManager:LoadAsset("game20dn/Sounds","CARD_SELECTED_SOUND");
	--log(type(self.soundSend));
	self.soundFanPai=ResManager:LoadAsset("game20dn/Sounds","COMMON_FLIP_CARD_SOUND_A");
	self.betsound=ResManager:LoadAsset("game20dn/Sounds","Big_Banker_Bet_On_Desk_Sound");
	self.jinbiSound=ResManager:LoadAsset("game20dn/Sounds","Pool_Win");
	self.baole=ResManager:LoadAsset("game20dn/Sounds","baole");
	self.zhale=ResManager:LoadAsset("game20dn/Sounds","zhale");
	self.xiazhu=ResManager:LoadAsset("gamenn/Sound","xiazhu");
    self.betflymusic=ResManager:LoadAsset("game20dn/Sounds","BetFly");   --吐金币音效
	self.mingpaifly=ResManager:LoadAsset("game20dn/Sounds","mingpai_fly");  --明牌动画音效
	
	self.soundNiuNum = {};
	for i=0,9 do
		table.insert(self.soundNiuNum,i,ResManager:LoadAsset("gamenn/Sound","niu"..i));	
	end
	table.insert(self.soundNiuNum,ResManager:LoadAsset("gamenn/Sound","niuniu"));	
	
	--self.jettonPrefab=ResManager:LoadAsset("game20dn/Prefab","JettonPrefab");
	
	self.InvokeLua = InvokeLua:New(self);
end

function this:clearLuaValue()
	self.gameObject = nil
	self.transform = nil
	
	
	--/ 提示字“准备”
	self.readyObj=nil;
	--/ 提示字“完成”
	--self.commitObj=nil;
	--/  提示字"摊牌"
	self.showObj=nil;
	--/ 提示字"叫庄中"
	self.callBankerObj=nil;
	--/  提示字"等待中"
	self.waitObj=nil;
	--/ 选择下注筹码
	self.chooseChipObj=nil;
	self.btnChipTargetFrom=nil;
	self.btnChipTargetTo=nil;
	self.chooseChipPrefab=nil;
	self.chooseOtherPosition=nil;
	self.btnEndPosition=nil;
	--self.zhuang_sprite=nil;
	self.board_sprite=nil;
	self.board_to=nil;
	self.baozha_prefab=nil;
	self.label_money_from=nil;
	self.label_money_to=nil;
	self.baozha_parent=nil;
	self.gameTimeCount=nil; 
	--self.zhuangjia=nil;
	self.xingprefab=nil;
	--self.banker_shanguangtarget=nil;
	--/ <summary>
	--/ 比牌结果
	--/ </summary>
	self.cardTypeTrans=nil;
	self.cardTypeSprite=nil;
	self.ChipAnimator_1=nil;
	self.ChipAnimator_2=nil;
	self.ChipAnimator_3=nil;
	self.ChipAnimator_4=nil;
	self.ChipAnimator_5=nil;
	self.ChipAnimator_6=nil;
	self.Betfly=nil;
	--self.shanguangAnima=nil;
	self.cardType_baopai=nil;
	self.ChipAnimator_label_1=nil;
	self.ChipAnimator_label_2=nil;
	self.ChipAnimator_label_3=nil;
	self.ChipAnimator_label_4=nil;
	self.ChipAnimator_label_5=nil;
	self.ChipAnimator_label_6=nil;
	--/ 玩家头像
	self.userAvatar=nil;
	--/ 玩家昵称
	self.userNickname=nil;
	--/ 玩家带入金额
	self.userIntomoney=nil;
	--/ 玩家的扑克牌(排序后)
	self.cardsArray=nil;
	--/ 扑克牌的父物体
	self.cardsTrans=nil;
	self.getCardType=nil;
	self.getcardTypePosition=nil;
	self.getType=nil;
	--/ 玩家得分
	self.cardScoreObj=nil;
	self.cardScoreBg=nil;
	--self.bankerBg=nil;
	--self.bankershanguang=nil;
	self.soundSend=nil;
	self.soundFanPai=nil;
	self.betsound=nil;
	self.jinbiSound=nil;
	self.baole=nil;
	self.zhale=nil;
	--self.jettonPrefab=nil;
	self.infoDetail=nil;
	self.kDetailNickname=nil;
	self.kDetailLevel=nil;
	self.kDetailBagmoney=nil;
	self.background=nil;
	self.choumaprefab=nil;
	self.target=nil;
	self.cardsTarget=nil;
	self.xiazhu=nil;
	self.soundNiuNum = {};
	self.selectBetPanel = nil 
    self.betflymusic=nil;
	self.mingpaifly=nil;
	
	--扑克牌父物体的位置
	self.parentX = 0;
	self.parentY = 30;
	self.parentZ = 0; 
	self._cardPre = "card_";
	self._timeInterval = 3;
	self._timeLasted=0;
	self.cardScoreP=nil;
	self.cardTypeP=nil;
	self.showP=nil;
	self.callBankerP=nil;
	self.infoDetailP=nil;
	self.chouma=nil;
	self.cardsposition = {};
	self.selectPanelPosition_x = 0;
	self.score_label_1=nil;
	self.score_label_2=nil; 
	self.secondCardCount=nil;
	self.secondCardType=0;
	self.endScore=0;
	--self.identity = nil;
	--self.edge = nil;
	self.banker_message=nil;
	self.NNCount:clearLuaValue()
	self.NNCount = nil
	

	
	
	self.InvokeLua:clearLuaValue();
	self.InvokeLua = nil; 
	
	self.otheruid=nil;
end

function this:Awake()
	self:init();
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		Game20DN.mono:AddClick(self.userAvatar.gameObject,self.OnClickInfoDetail,self);
	end
	self.parentX = self.cardsTrans.localPosition.x;
	self.parentY = self.cardsTrans.localPosition.y;
	self.parentZ = self.cardsTrans.localPosition.z;
	for i = 1, #(self.cardsArray) do 
		self.cardsposition[i] = self.cardsArray[i].transform.localPosition;
	end 
end
function this:Start()

	self:UpdateSkinColor();
	if self.cardScoreObj ~= nil  and  self.cardTypeTrans ~= nil  and  self.showObj ~= nil  and  self.callBankerObj ~= nil  and  self.infoDetail ~= nil then
	
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

		--self.callBankerObj.transform.localPosition = Vector3.New(-self.callBankerP.x, self.callBankerP.y, self.callBankerP.z);
	elseif anchor.side == UIAnchor.Side.Top then
	
		--self.cardScoreObj.transform.localPosition = Vector3.New(-transform.localPosition.x, -190, 0);
	
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
	elseif anchor.side == UIAnchor.Side.Left then
	
		self.cardsTrans.localPosition = Vector3.New(self.parentX, self.parentY, self.parentZ);
	end
	--self.zhuang_sprite = GameObject.Find("Content").transform:FindChild("banker_sprite"):GetComponent("UISprite").gameObject;
	

end
function this:OnDestroy()
	self:clearLuaValue()
end
--/ 换肤时更新扑克牌
function this:UpdateSkinColor()
	for key,sprite in ipairs(self.cardsArray) do 
		sprite.spriteName = self._cardPre.."yellow"
	end 
end

function this:SetPlayerInfo(avatar,   nickname,   intomoney,   level)

	self.userAvatar.spriteName = "avatar_".. avatar;
	self.userNickname.text = nickname;
	if  LengthUTF8String(self.userNickname.text) > 5 then
			self.userNickname.text =   SubUTF8String(self.userNickname.text,12);
		end
	
	self.userIntomoney.text = EginTools.HuanSuanMoney(intomoney);
    
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
		self._timeLasted = 0;
	end
end

function this:UpdateInLua()
	if self.NNCount~= nil then
		self.NNCount:Update()
	end
		
		
	if self.infoDetail ~= nil  and  self.infoDetail.activeSelf then
	
		self._timeLasted = self._timeLasted + 0.1
		if self._timeLasted >= self._timeInterval then
		
			self.infoDetail:SetActive(false);
			self._timeLasted = 0;
		end
	end
end

function this:UpdateIntoMoney( intomoney)

	if self.userIntomoney == nil then
		GameObject.Find("Label_Bagmoney"):GetComponent("UILabel").text = EginTools.HuanSuanMoney(intomoney);
	else
		self.userIntomoney.text = EginTools.HuanSuanMoney(intomoney);
	end
end

function this:SetBanker(toShow, isown)
	if toShow then
		--self.zhuang_sprite:SetActive(true);
		--self:MoveTargetXY(self.board_to.transform.position.x, self.board_to.transform.position.y, 0.35, isown);
		self.board_sprite.gameObject:SetActive(true);
		self.board_sprite:Play("banker_animation");
	else
		--if self.bankerBg ~= nil then self.bankerBg:SetActive(false); end
		self.board_sprite.gameObject:SetActive(false);
	end
end

function this:MoveTargetXY(x,  y,   timeL,   isown)

	--iTween.MoveTo(self.zhuang_sprite,Game20DN.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeL,"delay", 0.3,"islocal", false,"easeType", iTween.EaseType.easeOutQuart,"oncomplete", self.MoveTarget_1,"oncompleteparams", isown,"oncompletetarget", self));
	           
end
function this:MoveTarget_1(isown)

	self:playAnima(true, false, false, false, -1,false);
	 
	--iTween.MoveTo(self.zhuang_sprite,Game20DN.mono:iTweenHashLua ("position",Vector3.New(self.board_sprite.transform.position.x, self.board_sprite.transform.position.y, 0),"time", 0.2,"islocal", false,"easeType", iTween.EaseType.linear,"oncomplete", self.dengdai,"oncompleteparams", isown,"oncompletetarget", self));
	
	--coroutine.start(self.AfterDoing,self,0.2,self.dengdai,isown); 
end


function this:dengdai(isown)

	local xing = GameObject.Instantiate(self.xingprefab);
	xing.transform.parent = self.banker_shanguangtarget.transform;
	xing.transform.localPosition = Vector3.zero;
	xing.transform.localRotation = Quaternion.Euler(0, 0, 0);
	xing.transform.localScale = Vector3.one; 
	xing:GetComponent("UISpriteAnimation"):playWithCallback(Util.packActionLua(function(self) 
		destroy(xing);
		--self:MoveZheZhao(isown);
		--self.zhuang_sprite:SetActive(false);
		--self.zhuang_sprite.transform.localPosition = Vector3.zero;
	end,self));
end


function this:SetCard(cardindex,  cardsvalue,  cardtype,  cardscount,  isOtherSecond,  isDeal,  iscommit,  isget,  isown, ismiaosha,index,otherFanBei)
    self.isFanBei=otherFanBei;
	self.secondCardCount = cardsvalue;
	self.secondCardType = cardtype;
	self.cardsTrans.gameObject:SetActive(true);   
	self:faPai(self.cardsArray[cardindex+1],  tostring(cardsvalue), self.cardsTarget.transform.localPosition.x, self.cardsTarget.transform.localPosition.y, 0.2, 0.2, cardtype, cardscount, isOtherSecond, isDeal, iscommit, isget, isown,ismiaosha,index);

end


function this:faPai( gObj,  pai,  x,  y,  timeL,  delay,  cardtype,  cardscount,  isOtherSecond,  isDeal,  isCommit,  isget,  isown,ismiaosha,index)
	--local cardfly=nil;
	--if nil ~= self.soundSend then 
		--cardfly=self.souned;
	--end
	--coroutine.start(self.AfterDoing,this,0.2, function()			
	   -- log("播放发牌声音");
	    --EginTools.PlayEffect(cardfly);						  
	--end);
	
	gObj.spriteName = self._cardPre .."yellow";
		
	gObj.alpha = 1.0;
	local leixing = {};
	leixing[0] = timeL + 0.1;
	leixing[1] = delay + 0.1;
	leixing[2] = pai;
	leixing[3] = gObj;
	leixing[4] = cardtype;
	leixing[5] = cardscount;
	leixing[6] = isDeal;
	leixing[7] = isCommit;
	leixing[8] = isget;
	leixing[9] = isown; 
	leixing[10]= isOtherSecond;
	leixing[11]=ismiaosha;
	leixing[12]=index;
	--if not isOtherSecond then	 
		iTween.MoveFrom(gObj.gameObject,Game20DN.mono:iTweenHashLua ("position",Vector3.New(x, y, 0),"time",timeL,"delay", 0.5,"islocal", true,"easeType", iTween.EaseType.linear ,"oncomplete", self.StartScaleChange,"oncompleteparams", leixing,"oncompletetarget", self));		
	--else
	--if self.isMingpai or self.isMiaosha then
		    --self.isFanPai=true;
	--end   
			--log(self.gameObject.name);
		    --iTween.MoveFrom(gObj.gameObject,Game20DN.mono:iTweenHashLua ("position",Vector3.New(x, y, 0),"time",timeL,"delay", 0.5,"islocal", true,"easeType", iTween.EaseType.linear ,"oncomplete", self.ScaleChange,"oncompleteparams", leixing,"oncompletetarget", self));
		--else
			--iTween.MoveFrom(gObj.gameObject,iTween.Hash ("position",Vector3.New(x, y, 0),"time",timeL,"delay", 0.5,"islocal", true,"easeType", iTween.EaseType.linear));
		--end
	--end 
end

function this:StartScaleChange(leixing)
	coroutine.start(self.ScaleChange,self,leixing);
end

function this:ScaleChange(leixing)

   
	if nil ~= self.soundSend then 
		--log("播放发牌声音");
	    EginTools.PlayEffect(self.soundSend);		
	end
			    				 
	local lei = leixing;
	local timeL = (lei[0]);
	local delay = (lei[1]);
	local pokersprite =  (lei[2]);
	local gObj = lei[3];
	local cardtype = (lei[4]);
	local cardscount = (lei[5]);
	local isDeal = (lei[6]);
	local isCommit = (lei[7]);
	local isget = (lei[8]);
	local isown = (lei[9]);
	local isOtherSecond=(lei[10]);
	local ismiaosha=(lei[11]);
	local index=(lei[12]);
	if cardscount > 2 then
			self.getCardType.transform.localPosition=Vector3.New(self.getCardType.transform.localPosition.x-25,self.getCardType.transform.localPosition.y,0);
			for i = 0, (cardscount - 2) do
			
				self:MovePai(self.cardsArray[i+1], i, 0, self.cardsArray[i+1].transform.localPosition.y, 0.2, cardscount);
			end
	end
		
	if not isOtherSecond then	       
		local commit_leixing = {};
		commit_leixing[1] = cardtype;
		commit_leixing[2] = isCommit;
		commit_leixing[3] = isget;
		commit_leixing[4] = isown; 
		commit_leixing[5] = ismiaosha; 
		commit_leixing[6] = index; 
		iTween.ScaleTo(gObj.gameObject,iTween.Hash ("x", 0.000001,"time",timeL,"easeType", iTween.EaseType.linear));
		
		coroutine.start(self.AfterDoing,self,delay, function()
		
			gObj.spriteName = self._cardPre..pokersprite;
			
			if not isDeal then  
				iTween.ScaleTo(gObj.gameObject,Game20DN.mono:iTweenHashLua("x", 1.0,"time",timeL * 0.5,"easeType", iTween.EaseType.linear,"oncomplete", self.showCardType,"oncompleteparams", commit_leixing,"oncompletetarget", self));
			else 
				iTween.ScaleTo(gObj.gameObject,iTween.Hash ("x", 1.0,"time",timeL * 0.5,"easeType", iTween.EaseType.linear));
			end
			 
			coroutine.start(self.AfterDoing,self,timeL * 0.5, function() 
				  if nil ~= self.soundFanPai then EginTools.PlayEffect(self.soundFanPai); end
			  end);
		end);
		--log("翻牌");
	end
	if not isown and isCommit	then
		
		coroutine.wait(0.5);
		--self.commitObj:SetActive(true);
		self.getCardType:SetActive(true);
		self.getType.spriteName="process_ok";
	end
	if not isown and isget then
	    self.getCardType:SetActive(false);
	end
end

function this:showCardType(typelei)
	Game20DN.canTanpai = true;
	local lei = typelei;
	local cardtype = (lei[1]);
	local isCommit = (lei[2]);
	local isget = (lei[3]);
	local isown = (lei[4]);
	local ismiaosha=(lei[5]);
	local index=(lei[6]);
	if not isCommit then 		
		--log("展示牌型");
		--log("是否自己");
		--log(isown);
		--if isown then			
            if cardtype==-1 then
				self.getCardType:SetActive(false);
			else			
				if cardtype >= 10 then		
					self.getType.spriteName = "cardtype_10";
				else			
					self.getType.spriteName = "cardtype_".. cardtype;
				end
				self.getCardType:SetActive(true);
				--log("显示小牌型----4");		
			end
		--end
	else 
	    --if not isown then			
			--self.commitObj:SetActive(true);
		--end
		
		self.getCardType:SetActive(true);
		--self.commitObj:SetActive(true);
		self.getType.spriteName="process_ok";
		
	    --[[
		if cardtype < 0 then 
			self.getCardType:SetActive(false);
			self:CardTypeBaoPai();
		else  
			self.cardTypeTrans.gameObject:SetActive(true);
			self.getCardType:SetActive(false);
			self.cardTypeSprite.gameObject:SetActive(true);
			self.cardType_baopai.gameObject:SetActive(false);
			if cardtype == 0 then
			
				self.cardTypeSprite.spriteName = "niu_0";
				if self.soundNiuNum[cardtype] ~=  nil then 
				    if  ismiaosha and index==2 then
					    coroutine.start(self.AfterDoing,self,0.5, function()	
							EginTools.PlayEffect(self.soundNiuNum[cardtype]); 
						end);
					else
						EginTools.PlayEffect(self.soundNiuNum[cardtype]); 
					end
				end
			else
			
				if cardtype > 0  and  cardtype < 10 then
				
					self.cardTypeSprite.spriteName = "niu_".. cardtype;				
					if self.soundNiuNum[cardtype] ~= nil then
					    if  ismiaosha and index==2 then
					        coroutine.start(self.AfterDoing,self,0.5, function()	
								EginTools.PlayEffect(self.soundNiuNum[cardtype]); 
							end);
					    else
						EginTools.PlayEffect(self.soundNiuNum[cardtype]); 				
						end
					end
				else
				
					self.cardTypeSprite.spriteName = "niu_10";					
					if self.soundNiuNum[10] ~= nil then 
						if  ismiaosha and index==2 then
								coroutine.start(self.AfterDoing,self,0.5, function()	
									EginTools.PlayEffect(self.soundNiuNum[10]); 
								end);
						else
							EginTools.PlayEffect(self.soundNiuNum[10]); 				
						end							
					end
				end
			end
		end
		]]

	end
end

function this:MovePai( gObj,  index,  x,  y,  timeL,  cardscount)

	if cardscount == 3 then
		
		x = -55 + index * 65;
	elseif cardscount == 4 then
		
		x = -85 + index * 55;
	elseif cardscount == 5 then
		
		x = -100 + index * 50;
	end
		
	iTween.MoveTo(gObj.gameObject,iTween.Hash ("position", Vector3.New(x, y, 0),"time",timeL,"islocal", true ,"easeType", iTween.EaseType.linear));
	
end

function this:selectedBet(gObj,  x,  y,  timeL,  delay)

	coroutine.start(self.AfterDoing,self,delay, function()
	
		if nil ~= self.betsound then EginTools.PlayEffect(self.betsound); end
		  
		iTween.MoveTo(gObj.gameObject,iTween.Hash ("position", Vector3.New(x, y, 0),"time",timeL,"islocal", true ,"easeType", iTween.EaseType.linear));
	end);
end


function this:SetDeal(toShow,  infos)

	if not toShow then 
		self.cardsTrans.gameObject:SetActive(false);
		self.getCardType:SetActive(false);
		self.getCardType.transform.localPosition=self.getcardTypePosition.transform.localPosition;
		for i = 1, #(self.cardsArray)  do
		
			if self.cardsArray[i].alpha ~= 0 then 
				self.cardsArray[i].alpha = 0;
			end
			self.cardsArray[i].transform.localPosition = self.cardsposition[i];
			self.cardsArray[i].transform.localRotation = Quaternion.Euler(0, 0, 0);
		end
	else
	
		self.cardsTrans.gameObject:SetActive(true);

		if nil ~= self.soundSend then EginTools.PlayEffect(self.soundSend); end
		if infos ~= nil  and   #(infos) > 0 then 
			for i = 1,  #(infos) do 
				if infos[i] ~= nil then 
					self.cardsArray[i].spriteName = self._cardPre..tostring(infos[i]);
				end
			end
		end
	end
end

--四个下注筹码的显示
function this:SetChip(selectchip,  isown)
	if self.selectBetPanel ~= nil then 
		self.selectBetPanel:SetActive(true);
	end
	local btns = self.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));

	for i = 0,  #(selectchip)-1  do
	
		local btn = btns[i].gameObject;
		btn.transform:FindChild("label"):GetComponent("UILabel").text =  tostring(selectchip[i+1]);

		--给四个下注筹码初始化位置（屏幕之外）
		btn.transform.localPosition = Vector3.New(-360 + 240 * i, self.btnChipTargetFrom.transform.localPosition.y, 0);
		btn.name =  tostring(selectchip[i+1]);
		--如果是主玩家，将四个筹码移动到屏幕的适当位置
		if isown then
		
			self:MoveTargetChip(btn, btn.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0.2, 0, false, false, 0);
		end        
	end
end


function this:SetLateMingpai(otherUid,showtype,isotherFanBei)
	self.otheruid=otherUid;
	self.isFanBei=isotherFanBei;
	if showtype==2 or showtype==3 then
		self.double_MPorMS_1:SetActive(true);
		if showtype==2 then
		    self.isMingpai=true;
			self.mingpai_sprite_11.spriteName="mingpai";
			self.mingpai_sprite_22.spriteName="double2";
			self.isMingpai=true;
		elseif showtype==3 then
		    self.isMiaosha=true;
			self.mingpai_sprite_11.spriteName="miaosha";
			self.mingpai_sprite_22.spriteName="double6";
			self.isMiaosha=true;
		end		
	end
	
end

--选择下注的筹码
function this:SelectedChip(chip,  isOther)  		
	self.ChipAnimator_label_1.text =  tostring(chip);
	local btns = self.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
	for i = 0, 3 do 
		local btn = btns[i].gameObject;
		if btn.name ==  tostring(chip) then
		
			self.selectBetPanel = btn;
			self.selectPanelPosition_x = btn.transform.localPosition.x;
			--如果不是主玩家的话，将选中的筹码移到四个下注筹码的中间位置
			if isOther then 
				btn.transform.localPosition = self.btnChipTargetFrom.transform.localPosition;
			end
			--然后移动到指定位置
			self:selectedBet(btn, self.btnChipTargetFrom.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0.2, 0);
		else 
			self:MoveTargetChip(btn, btn.transform.localPosition.x, self.btnChipTargetFrom.transform.localPosition.y, 0.2, 0, false, false, 0);
		end
	end
end 


 
--/ 主玩家的比牌情况 
function this:SetCardTypeUser(cardsList,  cardType)
    --log("牌型")
	--log(cardType);
	--self.commitObj:SetActive(false);
	self.getCardType:SetActive(false);
	if nil == cardsList then 
		self.cardTypeTrans.gameObject:SetActive(false); 
	else 
		if cardType < 0 then 
			self:CardTypeBaoPai();
		else 
			self.getCardType:SetActive(false); 
			--log("隐藏小牌型----1");
			self.cardTypeTrans.gameObject:SetActive(true);
			self.cardTypeSprite.gameObject:SetActive(true);
			self.cardType_baopai.gameObject:SetActive(false);

			--显示牌型和牛几
			if cardType == 0 then 
				self.cardTypeSprite.spriteName = "type_0";
				if self.isBanker==1 then
				    coroutine.wait(1);
					--log("自己 庄家1");
				end
				if self.soundNiuNum[0] ~= nil then EginTools.PlayEffect(self.soundNiuNum[0]); end
				
			elseif cardType > 0 then
			
				if cardType < 10 then
				
					self.cardTypeSprite.spriteName = "type_".. cardType;
					if self.isBanker==1 then
						coroutine.wait(1);
						--log("自己 庄家2");
					end
					if self.soundNiuNum[cardType] ~= nil then EginTools.PlayEffect(self.soundNiuNum[cardType]); end
					
				else				
					self.cardTypeSprite.spriteName = "type_10";
					if self.isBanker==1 then
						coroutine.wait(1);
						--log("自己 庄家3");
					end
					if self.soundNiuNum[10] ~= nil then EginTools.PlayEffect(self.soundNiuNum[10]); end
					
				end 
			end
		end
	end
end
 
--/ 其他玩家的比牌情况 
function this:SetCardTypeOther(cardsList, cardType)
	--self.commitObj:SetActive(false);
	if cardsList == nil then 
		self:UpdateSkinColor(); 
		self.cardTypeTrans.gameObject:SetActive(false);
	else 
		--显示牌型和牛几
		local showcount=0;	
		for i = 1, #(self.cardsArray) do		
			if self.cardsArray[i].alpha == 1 and self.cardsArray[i].spriteName~="card_yellow" then			
				showcount = showcount +1;				
			end
		end	
		--log("显示的牌数");
        --log(showcount);		
		for i = 1, #(cardsList) do	
		    --log("个数");
		    --log(i);
			--log(tonumber(cardsList[i]));	
			if i<=showcount then
			else
				iTween.ScaleTo(self.cardsArray[i].gameObject,iTween.Hash ("x", 0.000001,"time",0.2,"easeType", iTween.EaseType.linear));		
				coroutine.start(self.AfterDoing,self,0.2, function()
				    --log("手里牌大小");
                    --log(tonumber(cardsList[i]));				
					self.cardsArray[i].spriteName = self._cardPre..tonumber(cardsList[i]);								
					iTween.ScaleTo(self.cardsArray[i].gameObject,iTween.Hash ("x", 1.0,"time",0.1,"easeType", iTween.EaseType.linear));						 
					coroutine.start(self.AfterDoing,self,0.1, function() 
						if nil ~= self.soundFanPai then EginTools.PlayEffect(self.soundFanPai); end
					end);
				end);	
			end				
		end
		
		
		
		
		if cardType < 0  then 
			self:CardTypeBaoPai();
		else 
			self.cardTypeTrans.gameObject:SetActive(true);
			self.getCardType:SetActive(false);
			self.cardTypeSprite.gameObject:SetActive(true);
			self.cardType_baopai.gameObject:SetActive(false);
			if cardType == 0 then 
				self.cardTypeSprite.spriteName = "type_0";
				if self.isBanker==1 then
				    coroutine.wait(1);
					--log("别人 庄家1");
				end
				if self.soundNiuNum[cardType] ~= nil then EginTools.PlayEffect(self.soundNiuNum[cardType]); end
				
			elseif cardType > 0  and  cardType < 10  then
			
				self.cardTypeSprite.spriteName = "type_".. cardType;
				if self.isBanker==1 then
				    coroutine.wait(1);
					--log("别人 庄家2");
				end
				if self.soundNiuNum[cardType] ~= nil then EginTools.PlayEffect(self.soundNiuNum[cardType]); end
				
			else
			
				self.cardTypeSprite.spriteName = "type_10";
				if self.isBanker==1 then
				    coroutine.wait(1);
					--log("别人 庄家3");
				end
				if self.soundNiuNum[10] ~= nil then  EginTools.PlayEffect(self.soundNiuNum[10]); end
				
			end
		end
		
	end
end
function this:CardTypeBaoPai()

	local baozha = GameObject.Instantiate(self.baozha_prefab);
	baozha.transform.parent = self.baozha_parent;
	baozha.transform.localPosition = Vector3.zero;
	baozha.transform.localScale = Vector3.one;
	if nil ~= self.baole then EginTools.PlayEffect(self.baole); end
	baozha:GetComponent("UISpriteAnimation"):playWithCallback(Util.packActionLua(function(self)
		destroy(baozha);
		local showcount = 0;
		for i = 1, #(self.cardsArray) do
		
			if self.cardsArray[i].alpha == 1 then
			
				showcount = showcount +1;
				local cardspritename = self.cardsArray[i].spriteName;
				local cardscount = string.sub(cardspritename,6,string.len(cardspritename));  
				self.cardsArray[i].spriteName = "poker_".. cardscount;
			end
		end
		self:moveBaopaiCard(showcount);
		self.cardTypeTrans.gameObject:SetActive(true);
		self.cardTypeSprite.gameObject:SetActive(false);
		self.cardType_baopai.gameObject:SetActive(true);
		self:playAnima(false, false, false, true, -1,false);
	end,self));
end

function this:moveBaopaiCard(showcount)

	local upGet = math.ceil(tonumber(showcount) / 2);
	for i = 0, showcount-1 do
	
		local jiaodu = 0;
		if (i + 1) <= upGet then 
			jiaodu =  math.Random(5, 15);
		else
		
			jiaodu =  math.Random(-15, -10);
		end
		local position = math.Random(0, 20);
		self.cardsArray[i+1].transform.localRotation = Quaternion.Euler(0, 0, jiaodu);
		self.cardsArray[i+1].transform.localPosition = Vector3.New(self.cardsArray[i+1].transform.localPosition.x, position, 0);
	end

end

function this:SetScore(score) 
	if score == -1 then
	
		self.cardScoreObj:SetActive(false);
		self.score_label_1.text = "";
		self.score_label_2.text = "";
		self.score_label_1.gameObject:SetActive(false); 
		self.score_label_2.gameObject:SetActive(false);

	else 
		self.cardScoreObj:SetActive(true); 
		if score >= 0 then 
			self.score_label_1.gameObject:SetActive(true);
			self.score_label_2.gameObject:SetActive(false);
			self.score_label_1.text = "..".. score;
		elseif score < 0 then
			self.score_label_1.gameObject:SetActive(false);
			self.score_label_2.gameObject:SetActive(true);
			self.score_label_2.text =  tostring(score);
		end
	end
end


function this:setBetandScore(score)
	local score_leixing = {};
	score_leixing[0] = score;
	score_leixing[1] = 0.5;
	score_leixing[2] = 0.5;
	score_leixing[3] = self.label_money_from;
	score_leixing[4] = self.label_money_to;
    if self.gameObject == nil then return; end
	if self.selectBetPanel~=nil then
	    --log("进入");
		self:MoveTarget(self.selectBetPanel, self.selectBetPanel.transform.localPosition.x, self.btnChipTargetFrom.transform.localPosition.y, 0.5, 0.2, false); 
	end
	coroutine.start(self.ScorePositionChange,self,score_leixing);
end

function this:SetBetScore(score,  chipcount,  isNotBanker,  uid)
    self.endScore=score;
    local animatorTime=0;
    
	coroutine.wait(0); 
	---local scorecount_end = math.abs(score);
	--local delay = 1;
	--if scorecount_end == chipcount then
	
		--delay = 1.2;
	--else
	
		--delay = 1.4;
	--end

	
	
	
	
	if isNotBanker then 
	    --需要解开的判断
	    --[[
		if score >= 0 then 
		
			coroutine.wait(2);
			if self.gameObject == nil then return; end
			self:MoveTarget(self.selectBetPanel, self.selectBetPanel.transform.localPosition.x, self.btnChipTargetFrom.transform.localPosition.y, 0.5, 0, false); 
			coroutine.start(self.ScorePositionChange,self,score_leixing);
		else 
		]]
		if score<0 then
			local choumacount = 0;
			local scorecount = math.abs(score) - chipcount;
			if scorecount > 0 then 			
				choumacount = 2;
				self.ChipAnimator_label_3.text =  tostring(chipcount);
				self.ChipAnimator_label_6.text =  tostring(chipcount);
				self.ChipAnimator_label_2.text =  tostring(scorecount);
				self.ChipAnimator_label_5.text =  tostring(scorecount);
				self.chooseChipPrefab.transform.localPosition = self.btnChipTargetFrom.transform.localPosition;
				self.chooseChipPrefab:SetActive(true);
				self.chooseChipPrefab.transform:FindChild("label"):GetComponent("UILabel").text =  tostring(scorecount);
				self:MoveTarget(self.chooseChipPrefab, self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0.7, 0, false);
				self:MoveTarget(self.selectBetPanel, -self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0.7, 0, false); 
				coroutine.wait(1.0); 
				if self.gameObject == nil then return; end
				self.chooseChipPrefab:SetActive(false);
				self.chooseChipPrefab.transform.localPosition = self.btnChipTargetFrom.transform.localPosition;
				self.selectBetPanel:SetActive(false);
				self.selectBetPanel.transform.localPosition = Vector3.New(self.selectPanelPosition_x, self.btnChipTargetFrom.transform.localPosition.y, 0);
				if uid == EginUser.Instance.uid then		
                    if self.isFanBei then
					     --log("闲家  自己 翻倍"); 
                         self:playAnima(false, true, false, false, choumacount,true);
						 animatorTime=4.5;
                    else
					     --log("闲家 自己 不翻倍"); 
					     self:playAnima(false, true, false, false, choumacount,false);
						 animatorTime=3;
                    end					  
					
				else
				
					if self.isFanBei then
					     --log("闲家 翻倍");
                         self:playAnima(false, false, true, false, choumacount,true);
						 animatorTime=4.5;
                    else
						 --log("闲家 不翻倍");
					     self:playAnima(false, false, true, false, choumacount,false);
						 animatorTime=3;
                    end	
				end
				coroutine.wait(animatorTime);
                --[[[
				if  not self.isFanBei then 				
					if self.gameObject == nil then return; end								
					self:MoveTarget(self.ChipAnimator_1.gameObject, self.btnEndPosition.transform.localPosition.x, self.btnEndPosition.transform.localPosition.y, 1, 0.2, true); 
					self:MoveTarget(self.ChipAnimator_2.gameObject, self.btnEndPosition.transform.localPosition.x, self.btnEndPosition.transform.localPosition.y, 1, 0.2, true);
					self:MoveTarget(self.Betfly.gameObject, self.Betfly.transform.localPosition.x, self.btnEndPosition.transform.localPosition.y, 1, 0.2, true);	
                end
				]]
				Game20DN:getPlayerCtrl("NNPlayer_"..self.otheruid):setBetandScore(-self.endScore);			
				--coroutine.start(self.ScorePositionChange,self,score_leixing);
				self:setBetandScore(self.endScore);
				coroutine.wait(1);
		
		        --log("自己准备");
				Game20DN:setOwnReady();
				local num=math.Random(1,3);
				coroutine.wait(num);
				Game20DN:OtherPlayerReady();
				coroutine.wait(0.5);
				if  self.Betfly~=nil and self.Betfly.gameObject.activeSelf then
					self.Betfly.gameObject:SetActive(false);
				end
			else							
				choumacount = 1;
				self.selectBetPanel:SetActive(false);
				self.selectBetPanel.transform.localPosition = Vector3.New(self.selectPanelPosition_x, self.btnChipTargetFrom.transform.localPosition.y, 0);
				--self.ChipAnimator_4.gameObject:SetActive(true);
				self.ChipAnimator_label_4.text =  tostring(math.abs(score)); 
				self.ChipAnimator_label_1.text =  tostring(math.abs(score)); 
				if uid == EginUser.Instance.uid then
				
					self:playAnima(false, true, false, false, choumacount,false);
					animatorTime=3;
				else
				
					self:playAnima(false, false, true, false, choumacount,false);
					animatorTime=3;
				end
				coroutine.wait(animatorTime);
				--self:MoveTarget(self.ChipAnimator_1.gameObject, self.ChipAnimator_1.transform.localPosition.x, self.btnEndPosition.transform.localPosition.y, 1, 0, true);
				
				Game20DN:getPlayerCtrl("NNPlayer_"..self.otheruid):setBetandScore(-self.endScore);			
				--coroutine.start(self.ScorePositionChange,self,score_leixing);
				self:setBetandScore(self.endScore);
				coroutine.wait(1);
				--log("自己准备");
				Game20DN:setOwnReady();
				local num=math.Random(1,3);
				coroutine.wait(num);
				Game20DN:OtherPlayerReady();
			end

		end
	else
	
		if score < 0 then
		    local scorecount = math.abs(score) - chipcount;
			self.chooseChipPrefab.transform.localPosition = self.btnChipTargetFrom.transform.localPosition;
			self.chooseChipPrefab:SetActive(true);
			self.chooseChipPrefab.transform:FindChild("label"):GetComponent("UILabel").text =  tostring(math.abs(score));
			self:MoveTarget(self.chooseChipPrefab, self.chooseChipPrefab.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0.2, 0, false);
			coroutine.wait(0.5);
			if self.gameObject == nil then return; end		
			self.chooseChipPrefab:SetActive(false);
			--self.ChipAnimator_4.gameObject:SetActive(true);
			self.ChipAnimator_label_4.text =  tostring(math.abs(score));
			self.ChipAnimator_label_1.text =  tostring(math.abs(score));
			--[[
			if uid == EginUser.Instance.uid then 	
                if scorecount>0	 then	
					self:playAnima(false, true, false, false, 1,true);
				else
				    self:playAnima(false, true, false, false, 1,false);
				end
				
			else
				if scorecount>0	 then	
					self:playAnima(false, false, true, false, 1,true);
				else
					self:playAnima(false, false, true, false, 1,false);
				end
				
			end
			]]
			if scorecount>0	 then	
				if uid == EginUser.Instance.uid then 	
					if self.isFanBei then
					     --log("庄家  自己 翻倍"); 
                         self:playAnima(false, true, false, false, 1,true);
						 animatorTime=4.5;
                    else
					     --log("庄家 自己 不翻倍"); 
					     self:playAnima(false, true, false, false, 1,false);
						 animatorTime=3;
                    end	
				else
				    if self.isFanBei then
					     --log("庄家 翻倍");
                         self:playAnima(false, false, true, false, 1,true);
						 animatorTime=4.5;
                    else
					     --log("庄家 不翻倍");
					     self:playAnima(false, false, true, false, 1,false);
						 animatorTime=3;
                    end	
				end
				coroutine.wait(animatorTime);
				
				--[[
				if not self.isFanBei then 					
					self:MoveTarget(self.ChipAnimator_1.gameObject, self.ChipAnimator_1.transform.localPosition.x, self.btnEndPosition.transform.localPosition.y, 1, 0.5, true);
					self:MoveTarget(self.Betfly.gameObject, self.Betfly.transform.localPosition.x, self.btnEndPosition.transform.localPosition.y, 1, 0.5, true);
				end
				]]
				if  Game20DN:getPlayerCtrl("NNPlayer_"..self.otheruid)~=nil then
				    --log("庄家输 翻倍");
					Game20DN:getPlayerCtrl("NNPlayer_"..self.otheruid):setBetandScore(-self.endScore);		
                end				
				--coroutine.start(self.ScorePositionChange,self,score_leixing);
				self:setBetandScore(self.endScore);
				coroutine.wait(1);
				--log("自己准备");
				Game20DN:setOwnReady();
				local num=math.Random(1,3);
				coroutine.wait(num);
				Game20DN:OtherPlayerReady();
				coroutine.wait(0.5);
				if  self.Betfly~=nil and self.Betfly.gameObject.activeSelf then
					self.Betfly.gameObject:SetActive(false);
				end
				
			else			
				if uid == EginUser.Instance.uid then 	
					self:playAnima(false, true, false, false, 1,false);
					animatorTime=3;
				else
				    self:playAnima(false, false, true, false, 1,false);
					animatorTime=3;
				end
				
				coroutine.wait(animatorTime);
				--self:MoveTarget(self.ChipAnimator_1.gameObject, self.ChipAnimator_1.transform.localPosition.x, self.btnEndPosition.transform.localPosition.y, 1, 0, true);
				if  Game20DN:getPlayerCtrl("NNPlayer_"..self.otheruid)~=nil then
				--log("庄家输 不翻倍");
					Game20DN:getPlayerCtrl("NNPlayer_"..self.otheruid):setBetandScore(-self.endScore);	
				end
				self:setBetandScore(self.endScore);	
				coroutine.wait(1);
				--log("自己准备");
				Game20DN:setOwnReady();	
				
				local num=math.Random(1,3);
				coroutine.wait(num);
				Game20DN:OtherPlayerReady();				
				--coroutine.start(self.ScorePositionChange,self,score_leixing);
			end		
		end
	end

	
end



function this:SetBet(jetton)

	local sprites = self.cardScoreObj:GetComponentsInChildren(Type.GetType("UISprite",true));
	if sprites.Length > 1 then
	
		for i =0 , sprites.Length-1 do 
			local sprite = sprites[i];  
			if not sprite.gameObject.name == "Sprite_bg" then 
				destroy(sprite.gameObject);
			end
		end
	end
	if jetton > 0  and  not self.cardScoreObj.activeSelf then
		self.cardScoreObj:SetActive(true);
		--log("进入这里");
		--EginTools.AddNumberSpritesCenter(self.jettonPrefab, self.cardScoreObj.transform,  tostring(jetton), "add_", 0.8);
	else 
		self.cardScoreObj:SetActive(false);
	end
end

function this:SetReady(toShow)

	if toShow  and  not self.readyObj.activeSelf then
	
		self.readyObj:SetActive(true);
	else
	
		self.readyObj:SetActive(false);
	end
end

function this:SetShow(toShow)

	if self.showObj ~= nil then
	
		if toShow  and  not self.showObj.activeSelf then
		
			self.showObj:SetActive(true);
		else
		
			self.showObj:SetActive(false);
		end
	end
end

function this:SetCallBanker(toShow)

	if self.callBankerObj ~= nil then
	
		if toShow  and  not self.callBankerObj.activeSelf then
		
			self.callBankerObj:SetActive(true);
		else
		
			self.callBankerObj:SetActive(false);
		end
	end
end

function this:SetWait(toShow)

	if self.waitObj ~= nil then
		if toShow  and  not self.waitObj.activeSelf then
			self.waitObj:SetActive(true);
		else 
			self.waitObj:SetActive(false);
		end
	end
end

function this:ChoumaPosition(player,  ChoumaList)

	self.chouma = player.transform;
	local temp = GameObject.Find("Panel_self.background").transform; 
	self.background = temp:FindChild("Sprite2_color"):GetComponent("UISprite").transform;
	self.target = self.background:FindChild("self.target"):GetComponent("UISprite");

	for i =1, 3 do--每个人出三个筹码
	
		local x = math.Random(-self.target.width * 0.5, self.target.width * 0.5);
		local y = math.Random(self.target.transform.localPosition.y - self.target.height * 0.5, self.target.transform.localPosition.y + self.target.height * 0.5);
	

		local count = math.Random(1, 6);
		local choumaTemp = GameObject.Instantiate(self.choumaprefab);
		 table.insert(ChoumaList,choumaTemp);--添加到一个队列中去
		choumaTemp.transform:GetComponent("UISprite").spriteName = "chouma_".. count;
		choumaTemp.transform.parent = self.background;
		choumaTemp.transform.localPosition = self.chouma.localPosition;
		choumaTemp.transform.localScale = Vector3.one;
		choumaTemp:GetComponent("TweenPosition").from = choumaTemp.transform.localPosition;
		choumaTemp:GetComponent("TweenPosition").to = Vector3.New(x, y, 0);
		choumaTemp:GetComponent("TweenPosition").duration = 0.3;
		coroutine.start(self.AfterDoing,self,0.3, function(self)
		
			EginTools.PlayEffect(self.xiazhu);
			if choumaTemp:GetComponent("TweenPosition") then 
				destroy(choumaTemp:GetComponent("TweenPosition"));
			end
		end) ;
	end
end
function this:setSecondCardType(isown, isCommit)

	if isown then	
		self.getCardType:SetActive(true);
		--log("显示小牌型----1");		
		if self.secondCardType >= 10 then 		   
			self.getType.spriteName = "cardtype_10";	
		else
		    self.getCardType:SetActive(true);
			--log("显示小牌型----2");		
			self.getType.spriteName = "cardtype_".. self.secondCardType;
		end
	else
		if not self.isFanPai then
			--log("====反派")
			self.isFanPai = true
			local leixing = {};
			leixing[0] = 0.2;
			leixing[1] = 0.1;
			leixing[2] =  tostring(self.secondCardCount);
			leixing[3] = self.cardsArray[2];
			leixing[4] = self.secondCardType;
			leixing[5] = 2;
			leixing[6] = false;
			leixing[7] = isCommit;
			leixing[8] = false;
			leixing[9] = false; 
			self:ScaleChange(leixing);
			return true;
		else
		
			--log("=====不翻拍")
		end 
	end
	
	return false;
end

function this:setCommitCardType(isown)
	if isown then	
	    --[[
	    if  self.secondCardType == -1 then
		    self.getCardType:SetActive(false); 
		else	
			self.getCardType:SetActive(true);	
            log("显示小牌型----3");					
			if self.secondCardType >= 10 then 				
				self.getType.spriteName = "cardtype_10";		
			else				
				self.getType.spriteName = "cardtype_".. self.secondCardType;
			end	
		end
		]]
		self.getCardType:SetActive(true); 
		--self.commitObj:SetActive(true);
		self.getType.spriteName="process_ok";
	else
	    self.getCardType:SetActive(true); 
	    --self.commitObj:SetActive(true);
		self.getType.spriteName="process_ok";
	end		
end


function this:MoveTargetChip(gObj,  x,  y,  timeL,  delay,  isLine,  iswin,  score)

	coroutine.start(self.AfterDoing,self,delay, function()
	
		if not isLine then  
			iTween.MoveTo(gObj,iTween.Hash ("position", Vector3.New(x, y, 0),"time",timeL,"islocal", true ,"easeType", iTween.EaseType.easeInExpo));
		else 
			local leixing = {};
			leixing[0] = timeL;
			leixing[1] = delay;
			if iswin then 
				leixing[2] = self.btnChipTargetFrom.transform.localPosition.y;
			else 
				leixing[2] = self.btnEndPosition.transform.localPosition.y;
			end
			leixing[3] = gObj;
			leixing[4] = score;  
			
			iTween.MoveTo(gObj,Game20DN.mono:iTweenHashLua("position", Vector3.New(x, y, 0),"time",timeL,"islocal", true ,"easeType", iTween.EaseType.linear,"oncomplete", self.PositionChange,"oncompleteparams", leixing,"oncompletetarget", self));--coroutine.start(self.AfterDoing,self,timeL,self.PositionChange,leixing)
		end 
	end);
end

function this:PositionChange(leixing)

	local lei = leixing;
	local timeL = tonumber(lei[0]);
	local delay = tonumber(lei[1]);
	local position_y = tonumber(lei[2]);
	local movepanel = tonumber(lei[3]);
	local score = tonumber(lei[4]);

	
	if self.ChipAnimator_1.gameObject.activeSelf then
		iTween.MoveTo(self.ChipAnimator_1.gameObject,iTween.Hash ("position", Vector3.New(self.ChipAnimator_1.transform.localPosition.x, position_y, 0),"time",timeL,"delay", 1.5,"islocal", true ,"easeType", iTween.EaseType.linear)); 
	end  
end


function this:ScorePositionChange(leixing)

	local lei = leixing;
	local score = tonumber(lei[0]);
	local timeL = tonumber(lei[1]);
	local delay = tonumber(lei[2]);
	local scoremovefrom = lei[3];
	local scoremoveto = lei[4];
	coroutine.wait(delay);
	if self.cardScoreObj == nil then return; end
	self.cardScoreObj:SetActive(true);
	if score > 0 then
		self.score_label_1.gameObject:SetActive(true);
		self.score_label_2.gameObject:SetActive(false);
		self.score_label_1.text = "+".. score;
		self.score_label_1.transform.localPosition = scoremovefrom.transform.localPosition;
	else
	
		self.score_label_2.gameObject:SetActive(true);
		self.score_label_1.gameObject:SetActive(false);
		self.score_label_2.text =  tostring(score);
		self.score_label_2.transform.localPosition = scoremovefrom.transform.localPosition;
	end
	
	local table1 = iTween.Hash ("position",Vector3.New(scoremoveto.localPosition.x, scoremoveto.localPosition.y, 0),"time",timeL ,"islocal", true ,"easeType", iTween.EaseType.linear);
 
	if self.score_label_1.gameObject.activeSelf then
		iTween.MoveTo(self.score_label_1.gameObject, table1);		
	elseif self.score_label_2.gameObject.activeSelf then
		iTween.MoveTo(self.score_label_2.gameObject, table1);		
	end
    coroutine.start(self.AfterDoing,self,1, function() 
			self.score_label_1.gameObject:SetActive(false);
			self.score_label_2.gameObject:SetActive(false);
		end);
	--self.double_position:SetActive(false);
	--self.double_MPorMS.transform.localPosition=self.target_SartPosition.transform.localPosition;
	--self.double_MPorMS.transform.localScale=Vector3.one;
	--self.mingpai.transform.localPosition=self.target_from_left.transform.localPosition;
	--self.mingpai_up.transform.localPosition=self.target_from_right.transform.localPosition;	
end


function this:PlayerTimedown(timedown,needSendMessage,isEdge,index) 
	--self.edge:SetActive(isEdge);
	self.banker_message.gameObject:SetActive(isEdge);

	if self.isBanker == 1 then
		--self.identity.text = "庄家"; 
		self.banker_message.spriteName="getcard_banker";
	elseif self.isBanker ==2 then
		--self.identity.text = "闲家"; 
		self.banker_message.spriteName="getcard_xian";
	end
	
	self.NNCount:UpdateHUD(timedown, false, needSendMessage);
	if needSendMessage and index==1 then
	   self.NNCount:SetSendMeessage(Game20DN,Game20DN.MPorMSMoveDown);
	elseif needSendMessage and index==2 then 
	   self.NNCount:SetSendMeessage(Game20DN,Game20DN.UserShow);
	end
end

function this:HideTimedown()

	self.NNCount:DestroyHUD(true); 
	self.banker_message.gameObject:SetActive(false);
end


function this:CheckShowCardsCount()

	local cardsShowCount = 0;
	for i = 1, #(self.cardsArray) do
	
		if self.cardsArray[i].alpha == 1 then 
			cardsShowCount = cardsShowCount +1;
		end
	end
	return cardsShowCount;
end

function this:AnimationCloseOver()

	--self.bankershanguang.gameObject:SetActive(true);
	
	iTween.NGUIFadeTo (self.bankershanguang.gameObject, iTween.Hash ("from",1.0,"to",0.2,"time",0.42,"onupdate","SetToastAlpha", "looptype", "pingPong", "nguitarget",self.bankershanguang));
	
	coroutine.start(self.AfterDoing,self,1.68, function() 
		--self.bankershanguang.gameObject:SetActive(false);
	end);
end


function this:AnimationUpdata(obj)

	local per = tonumber(obj);
	--self.bankershanguang.alpha = per;
end

function this:MoveZheZhao(isown)

	if isown then 
		--coroutine.start(self.UpClipRegion,self,170,self.zhuangjia:GetComponent("UIPanel"));
	else 
		--coroutine.start(self.UpClipRegion,self,-170,self.zhuangjia:GetComponent("UIPanel"));
	end
	
	
	
end
function this.UpClipRegion(self,from,uipanel) 
	while self.gameObject do
		uipanel.baseClipRegion = Vector4.New(0, from, 150, 150);
		if from < 0 then
			from =  from + 17;
		elseif from > 0 then
			from =  from - 17;
		end
		coroutine.wait(0.05);
		if self.gameObject == nil then return; end
		if from < 7 and from > -7 then
			uipanel.baseClipRegion = Vector4.New(0, 0, 150, 150);
			self:AnimationCloseOver();
			return;
		end
	end
end
function this:ClipCenter(obj)

	local per = tonumber(obj);
	--self.zhuangjia:GetComponent("UIPanel").baseClipRegion = Vector4.New(0, per, 150, 150);
end


function this:ClipReset(isown)

	if isown then
		--self.zhuangjia:GetComponent("UIPanel").baseClipRegion = Vector4.New(0, 170, 150, 150);
	else	    
		--self.zhuangjia:GetComponent("UIPanel").baseClipRegion = Vector4.New(0, -170, 150, 150);
	end

end



function this:playAnima(isshanguang,  ischip_1,  ischip_2,  isbaopai,  score,  tujinbi)

	if isshanguang then 
		--self.shanguangAnima.gameObject:SetActive(true);
		--self.shanguangAnima:CrossFade("shanguang", 0);
	elseif ischip_1 then
	    if tujinbi then
		    if score == 1 then
				self.ChipAnimator_1.transform.localPosition = Vector3.zero;
				self.Betfly.transform.localPosition=Vector3.New(-595,-205,0);
				local anima=self.chooseChipObj:GetComponent("Animator");
				anima.enabled=true;
				anima:Play("zapaitujinbi_1");
				self.InvokeLua:InvokeRepeating("PlayBetFlyMusic",self.PlayBetFlyMusic,1.5,0.05); 	
                coroutine.start(self.AfterDoing,self,2.54, function()
						--this.InvokeLua:CancelInvoke("PlayBetFlyMusic");		
						self.InvokeLua:CancelInvoke("PlayBetFlyMusic");						
				end);						
			elseif score==2 then
				self.ChipAnimator_3.transform.localPosition = Vector3.New(-self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0);
				self.ChipAnimator_2.transform.localPosition = Vector3.New(self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0);
				self.Betfly.transform.localPosition=Vector3.New(-595,-205,0);
				local anima=self.chooseChipObj:GetComponent("Animator");
				anima.enabled=true;
				anima:Play("zapaitujinbi");
				self.InvokeLua:InvokeRepeating("PlayBetFlyMusic",self.PlayBetFlyMusic,1.5,0.05); 	
                coroutine.start(self.AfterDoing,self,2.54, function()
						--this.InvokeLua:CancelInvoke("PlayBetFlyMusic");		
						self.InvokeLua:CancelInvoke("PlayBetFlyMusic");						
				end);						
			end		
		else				
			if score == 1 then			
				self.ChipAnimator_4.transform.localPosition = Vector3.zero;
				self.ChipAnimator_4.gameObject:SetActive(true);				
				self.ChipAnimator_4:CrossFade("CrashAnima_own_4", 0);							
			elseif score == 2 then			
				self.ChipAnimator_6.transform.localPosition = Vector3.New(-self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0);
				self.ChipAnimator_5.transform.localPosition = Vector3.New(self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0);
				self.ChipAnimator_6.gameObject:SetActive(true);
				self.ChipAnimator_5.gameObject:SetActive(true);
			    self.ChipAnimator_6:CrossFade("CrashAnima_own_6", 0);
				self.ChipAnimator_5:CrossFade("CrashAnima_own_5", 0);	
					
			end
		end
		--[[
		if tujinbi then
			coroutine.start(self.AfterDoing,self,1, function()
				self.Betfly.transform.localPosition=Vector3.New(-595,-205,0);
		        self.Betfly.gameObject:SetActive(true);
			    self.Betfly:CrossFade("betfly",0);	
                --if nil ~= self.betflymusic then 
				    --log("播放筹码声音");
				    --EginTools.PlayEffect(self.betflymusic); 					
				--end	
				--this:Invoke(0.04, this.PlayBetFlyMusic);
				self.InvokeLua:InvokeRepeating("PlayBetFlyMusic",self.PlayBetFlyMusic,0,0.05); 	
                coroutine.start(self.AfterDoing,self,1.04, function()
						--this.InvokeLua:CancelInvoke("PlayBetFlyMusic");		
						self.InvokeLua:CancelInvoke("PlayBetFlyMusic");						
				end);				
			end);
		end
		]]
	elseif ischip_2 then
	    if tujinbi then
		    if score == 1 then
				self.ChipAnimator_1.transform.localPosition = Vector3.zero;
				self.Betfly.transform.localPosition=Vector3.New(-420,142,0);
			   local anima=self.chooseChipObj:GetComponent("Animator");
			   anima.enabled=true;
			   anima:Play("zapaitujinbi_other_1");			   
			   self.InvokeLua:InvokeRepeating("PlayBetFlyMusic",self.PlayBetFlyMusic,1.5,0.05); 	
               coroutine.start(self.AfterDoing,self,2.54, function()
						--this.InvokeLua:CancelInvoke("PlayBetFlyMusic");		
						self.InvokeLua:CancelInvoke("PlayBetFlyMusic");						
				end);						
			elseif score==2 then
				self.ChipAnimator_3.transform.localPosition = Vector3.New(-self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0);
				self.ChipAnimator_2.transform.localPosition = Vector3.New(self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0);
				self.Betfly.transform.localPosition=Vector3.New(-420,142,0);
				local anima=self.chooseChipObj:GetComponent("Animator");
				anima.enabled=true;
				anima:Play("zapaitujinbi_other");			  
				self.InvokeLua:InvokeRepeating("PlayBetFlyMusic",self.PlayBetFlyMusic,1.5,0.05); 	
                coroutine.start(self.AfterDoing,self,2.54, function()
						--this.InvokeLua:CancelInvoke("PlayBetFlyMusic");		
						self.InvokeLua:CancelInvoke("PlayBetFlyMusic");						
				end);						
			end		
		else						
			if score == 1 then
			
				self.ChipAnimator_4.transform.localPosition = Vector3.zero;
				self.ChipAnimator_4.gameObject:SetActive(true);
				self.ChipAnimator_4:CrossFade("CrashAnima_other_4", 0);
			else
			
				self.ChipAnimator_6.transform.localPosition = Vector3.New(-self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0);
				self.ChipAnimator_5.transform.localPosition = Vector3.New(self.btnChipTargetTo.transform.localPosition.x, self.btnChipTargetTo.transform.localPosition.y, 0);
				self.ChipAnimator_6.gameObject:SetActive(true);
				self.ChipAnimator_5.gameObject:SetActive(true);
				self.ChipAnimator_6:CrossFade("CrashAnima_other_6", 0);
				self.ChipAnimator_5:CrossFade("CrashAnima_other_5", 0);			
			end
		end
		--[[
		if tujinbi then
			coroutine.start(self.AfterDoing,self,1, function()
				self.Betfly.transform.localPosition=Vector3.New(-420,142,0);
		        self.Betfly.gameObject:SetActive(true);
			    self.Betfly:CrossFade("betfly_other",0);	
				--if nil ~= self.betflymusic then 
				    --log("播放筹码声音");
				    --EginTools.PlayEffect(self.betflymusic); 
				--end
				self.InvokeLua:InvokeRepeating("PlayBetFlyMusic",self.PlayBetFlyMusic,0,0.05); 	
                coroutine.start(self.AfterDoing,self,1.04, function()
						--this.InvokeLua:CancelInvoke("PlayBetFlyMusic");		
						self.InvokeLua:CancelInvoke("PlayBetFlyMusic");						
				end);						
			end);
	
		end
		]]
	elseif isbaopai then
	
		if nil ~= self.zhale then EginTools.PlayEffect(self.zhale); end
		self.cardType_baopai.gameObject:SetActive(true);
		self.cardType_baopai:CrossFade("baopai", 0);
			
	end

end


function this:PlayBetFlyMusic() 
   if nil ~= self.betflymusic then 
	    --log("播放筹码声音");
		EginTools.PlayEffect(self.betflymusic); 
	end		
end



function this:MoveTarget(gObj,  x,  y,  timeL,  delay,  isjinbi)

	coroutine.start(self.AfterDoing,self,delay, function()
  
		iTween.MoveTo(gObj,iTween.Hash ("position",  Vector3.New(x, y, 0),"time",timeL,"islocal", true ,"easeType", iTween.EaseType.easeOutExpo)); 	
		if isjinbi then 
			if nil ~= self.jinbiSound then EginTools.PlayEffect(self.jinbiSound); end
		end

	end);
end


function this:SetLateChip( selectchip)
     
        if (self.selectBetPanel) then
            self.selectBetPanel:SetActive(true);
        end
        local btns = self.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true));
 
        btns[0].transform:FindChild("label"):GetComponent("UILabel").text = tostring(selectchip); 
        btns[0].transform.localPosition =  Vector3.New(0, self.btnChipTargetTo.transform.localPosition.y, 0);
        btns[0].name = tostring(selectchip); 
	    self.selectBetPanel = btns[0].gameObject;
        				
end
 
function this:SetLate( cards,  isOwn,  isCommit,  cardType)		
    self.cardsTrans.gameObject:SetActive(true);
	if cards ~= nil then 
		local  cardsLen =  #(cards);
		for i = 1,  cardsLen  do 
		    --[[
			if (cardsLen > 2 or isCommit or (cardsLen == 2 and isCommit)) then 
			
				self.cardsArray[i].spriteName = self._cardPre..tostring(cards[i]) ;

				self.cardsArray[i]:GetComponent("UISprite").alpha = 1;                                 
				if (cardsLen == 3) then
	
					self.cardsArray[i].transform.localPosition =  Vector3.New(-55+65*(i-1),0,0);
	                
				elseif (cardsLen == 4) then
		
					self.cardsArray[i].transform.localPosition =  Vector3.New(-85 + 55 * (i-1), 0, 0);
			
				elseif (cardsLen == 5) then
		
					self.cardsArray[i].transform.localPosition =  Vector3.New(-100 + 50 * (i-1), 0, 0);
				end
			else 
				
				if (i == 2) then 
					self.secondCardType = cardType;
					self.secondCardCount = tonumber(cards[i]); 
					 
					if (isOwn) then 
						self.cardsArray[i].spriteName = self._cardPre..tostring(cards[i]); 
					else 
						self.isFanPai = false;
						self.cardsArray[i].spriteName = self._cardPre .."green"; 
					end    
				else 
					self.cardsArray[i].spriteName = self._cardPre..tostring(cards[i]); 
				end
				self.cardsArray[i]:GetComponent("UISprite").alpha = 1;    
			end
			]]
			
			if isOwn then
			    self.cardsArray[i].spriteName = self._cardPre..tostring(cards[i]) ;
				self.cardsArray[i]:GetComponent("UISprite").alpha = 1;   				
			else
				if self.isMingpai or self.isMiaosha then
				    
					if i<3 then
						self.cardsArray[i].spriteName = self._cardPre..tostring(cards[i]) ;
					else
						self.cardsArray[i].spriteName = self._cardPre .."yellow"; 
					end
					self.cardsArray[i]:GetComponent("UISprite").alpha = 1;   
					if self.isMiaosha or isCommit  then
						 --self.commitObj:SetActive(true);
						 self.getType.spriteName = "process_ok".. cardType;
					     self.getCardType:SetActive(true);	
					elseif self.isMingpai and cardsLen==2 and not isCommit then
					     self.getType.spriteName = "cardtype_".. cardType;
					     self.getCardType:SetActive(true);				    					
					end				
				else
					if i<2 then
						self.cardsArray[i].spriteName = self._cardPre..tostring(cards[i]) ;
					else
						self.cardsArray[i].spriteName = self._cardPre .."yellow"; 
					end
					self.cardsArray[i]:GetComponent("UISprite").alpha = 1;    		
				end								
			end
			
			
			if (cardsLen == 3) then
	
				self.cardsArray[i].transform.localPosition =  Vector3.New(-55+65*(i-1),0,0);
	                
			elseif (cardsLen == 4) then
		
				self.cardsArray[i].transform.localPosition =  Vector3.New(-85 + 55 * (i-1), 0, 0);
			
			elseif (cardsLen == 5) then
		
				self.cardsArray[i].transform.localPosition =  Vector3.New(-100 + 50 * (i-1), 0, 0);
			end
							
		end  
	end	   
end
 
 
 function this:SetMingpaiOrMiaosha(uid,showtype,otherUid)   
		self.otheruid=otherUid;
		self.chooseChipObj:GetComponent("Animator").enabled=false;
		self.ChipAnimator_1.gameObject:SetActive(false);
	    self.ChipAnimator_2.gameObject:SetActive(false);
		self.Betfly.gameObject:SetActive(false);
		if showtype~=1 then
		    --self.isFanBei=true;
			self.isFanPai=true;
			if showtype==2 then
				--log("明牌");	
				self.isMingpai=true;			
				self.mingpai_sprite_1.spriteName="mingpai";
				self.mingpai_sprite_2.spriteName="double2";
			elseif showtype==3 then
				self.isMiaosha=true;
				self.mingpai_sprite_1.spriteName="miaosha";
				self.mingpai_sprite_2.spriteName="double6";
				--log("秒杀");
			end				
			--self.double_position:SetActive(true);
			self.double_MPorMS.gameObject:SetActive(true);
			if nil ~= self.mingpaifly then EginTools.PlayEffect(self.mingpaifly); end
			iTween.MoveTo(self.mingpai.gameObject,iTween.Hash ("position", Vector3.New(0, 0, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeInExpo));
			iTween.MoveTo(self.mingpai_up.gameObject,iTween.Hash ("position", Vector3.New(0, 0, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeInExpo));
			coroutine.start(self.AfterDoing,self,1, function() 
				if uid==EginUser.Instance.uid then
					self.double_MPorMS:GetComponent("Animator").enabled=true;
					self.double_MPorMS:CrossFade("MPorMs", 0);  
				else
					self.double_MPorMS:GetComponent("Animator").enabled=true;
					self.double_MPorMS:CrossFade("MPorMs_other", 0);  
				end
			
			end);	
		else
		    --self.isFanBei=false;
			self.isFanPai=true;
			self.isMingpai=false;
            self.isMiaosha=false;
			
		end
end

function this:SetMingPaiMove(ying) 
    --log(self.isMingpai);
	--log(self.isMiaosha);
	if ying then
		if self.isMingpai or self.isMiaosha  then
			if self.double_MPorMS.gameObject.activeSelf then
				self.double_MPorMS:GetComponent("Animator").enabled=false;
				--log("最后的移动");
				iTween.MoveTo(self.double_MPorMS.gameObject,iTween.Hash ("position", Vector3.New(self.target_tingzhi.localPosition.x, self.target_tingzhi.localPosition.y, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeInExpo));	    
			elseif  self.double_MPorMS_1.activeSelf then
				iTween.MoveTo(self.double_MPorMS_1,iTween.Hash ("position", Vector3.New(self.target_tingzhi.localPosition.x, self.target_tingzhi.localPosition.y, 0),"time",0.5,"islocal", true ,"easeType", iTween.EaseType.easeInExpo));	   
			end			
		end
	else
	    if self.isMingpai or self.isMiaosha  then
		    if  self.double_MPorMS.gameObject.activeSelf then		
				self.double_MPorMS.gameObject:SetActive(false);
				self.double_MPorMS:GetComponent("Animator").enabled=false;
			elseif self.double_MPorMS_1.activeSelf then
				self.double_MPorMS_1:SetActive(false);
			end
		end								
	end
	coroutine.start(self.AfterDoing,self,2.5, function() 	
		if  self.double_MPorMS.gameObject.activeSelf then		
			self.double_MPorMS.gameObject:SetActive(false);
		elseif self.double_MPorMS_1.activeSelf then
			self.double_MPorMS_1:SetActive(false);
		end
		self.double_MPorMS.transform.localPosition=self.target_SartPosition.transform.localPosition;
		self.double_MPorMS.transform.localScale=Vector3.one;
		self.mingpai.transform.localPosition=self.target_from_left.transform.localPosition;
		self.mingpai_up.transform.localPosition=self.target_from_right.transform.localPosition;			
	end);
end
 
function this:AfterDoing(offset,run,parameter)
	coroutine.wait(offset);	
	if self.gameObject then
		run(self,parameter);
	end
end

