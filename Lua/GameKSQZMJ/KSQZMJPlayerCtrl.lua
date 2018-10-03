require "GameKSQZMJ/shuxing"

local this = LuaObject:New()
KSQZMJPlayerCtrl = this

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


this.mahjongList = {
	'快点啦！时间很宝贵的！',
	'一路屁胡，走向胜利！',
	'上碰下自摸，大家要小心喽！',
	'好汉不胡头三把',
	'先胡不算胡，后胡满金桌',
	'呀！打错了怎么办？',
	'卡！卡！卡！卡的人火大啊！',
	'很高兴能和大家一起打牌',
}

this.mahjongTypeList={
	'天胡','地胡','人胡','小四喜','大四喜','大三元','大车轮','四暗刻','四连刻','四杠子','四万石','字一色',
	'清老头','绿一色','红孔雀','九莲宝灯','国土无双','东北新干线','门清','门清报听','天听','平胡','断幺','门清自摸',
	'花牌','一杯口','两杯口','七对','龙七对','碰碰胡','三色同顺','三暗刻','三连刻','三同刻','混带全幺','纯带全幺',
	'混老头','混一色','清一色','小三元','一条龙','杠上开花','海底捞鱼','河底捞月','海底捞月','推到胡',
};
function this:init()
	self.isTouch = false;
	self.CGPMoveJuLi=0;
	self.CGPPaiXuIndex=-1;
	self._cardPre = "Mahjong_";
	self._timeInterval = 3;
	self._timeLasted=0;
	self.huapaiIndex={};
	self.isBanker=false;
	self.canTiPai=false;
	self.tapX=0;
	self.cishu=0;
	self.movelastone=false;
	self.isChi=false;
	self.banker_last = nil;--庄家的最后一张牌
    self.createOwnCardCount = 0;
	self.createOtherCardCount=0;
    self.owncard = "owncard_";
	self.othercard="othercard_";
	self.ownLastNum=nil;
    self.PositionHaveChild = false;
    --复位————手里的牌
    self.CanHuiDiao=false;
	self.paiName="";
	self.paixuId=0;
	self.otherPlayerUid = "0";
    self.ownAlreadyTing = false;
	self.JinZhiBox=false;
	self._nnPlayerName = "NNPlayer_";
	self.fanshuList ={};
    self.jiesuanPrefabList = {};
	self.hupaiId = 0;
	self.owncardcount = 0;
	self.othercardcount = 0;
	self.lateCGPList={};
	
	
	
	self.isCPTing=false;
	self.dachuting=false;

	self.MopaiIndex=0;
	self.HasCGP=false;
	
	
	
	self.sex=-1;
	--self.zimotarget=self.transform:FindChild("Output/Cards/zimotarget");
	self.cardScoreObj=self.transform:FindChild("Output/CardScore").gameObject;
	self.readyObj=self.cardScoreObj.transform:FindChild("Sprite_ready").gameObject;
	self.ChiGangPengParent=self.transform:FindChild("Output/ChiGangPengParent").gameObject;
	
	
	--self.fanshu_prefab=ResManager:LoadAsset("gameksqzmj/prefab","jiesuanfanshu_prefab")
	self.emotionPrefab={};
	for i=1,27 do 
		table.insert(self.emotionPrefab,i,ResManager:LoadAsset("expressionpackage/biaoqing_"..i,"biaoqing_"..i));
	end
	
	
	if(self.gameObject.name ~= "User" and self.gameObject.name ~= ("NNPlayer_"..tostring(EginUser.Instance.uid)) )then 
		self.bankerSprite=self.transform:FindChild("PlayerInfo/Panel_Head/banker_sprite").gameObject;
		self.tingpai=self.transform:FindChild("PlayerInfo/Panel_Head/tingpai_sprite").gameObject:GetComponent("UISprite");
		self.tingpaiParent=nil;
		self.cgp_headParent=self.transform:FindChild("PlayerInfo/cgp_headParent").gameObject:GetComponent("Animator");
		self.cgp_head_sprite=self.cgp_headParent.transform:FindChild("cgp_head").gameObject:GetComponent("UISprite");
		 --/ 玩家头像
		self.userAvatar=self.transform:FindChild("PlayerInfo/Panel_Head/Sprite (avatar_6)").gameObject:GetComponent("UISprite");
		self.zidongmodapai=nil;
		--/ 玩家昵称
		self.userNickname=self.transform:FindChild("PlayerInfo/Panel_Head/Label_nickname"):GetComponent("UILabel");
		--/ 玩家带入金额
		self.userIntomoney=self.transform:FindChild("PlayerInfo/Panel_Head/Label_bagmoney").gameObject:GetComponent("UILabel");
		self.jiesuanmessage=nil;
		self.biaoji=self.transform:FindChild("Output/Cards_outothercards/sprite_biaojiparent").gameObject;
		self.win_parent=nil;
		self.lose_parent=nil;
		--self.zongjicount_win=nil;
		--self.zongjicount_lose=nil;
		self.win_fanshu=nil;
		self.lose_fanshu=nil;
		self.infoDetail=self.transform:FindChild("PlayerInfo/xinxiPanel/Info_detail").gameObject;
		self.kDetailNickname=self.infoDetail.transform:FindChild("Label1/Nickname").gameObject:GetComponent("UILabel");
		self.kDetailLevel=self.infoDetail.transform:FindChild("Label2/Level").gameObject:GetComponent("UILabel");
		self.kDetailBagmoney=self.infoDetail.transform:FindChild("Label3/BagMoney").gameObject:GetComponent("UILabel");	
		--self.dishu=nil;
		self.jiangli_1=nil;
		self.jiangli_2=nil;
		self.chiLinShiTarget=self.transform:FindChild("Output/chilinshi_own").gameObject;
		self.chilinshipai=self.chiLinShiTarget.transform:FindChild("shouliCard").gameObject:GetComponent("UISprite");
		self.jiangliPanel=nil;
		self.huapaiTiShi=nil;
		self.ting=self.transform:FindChild("Output/tingParent").gameObject:GetComponent("Animator");
		self.thisHandPaiContainer=nil;
		self.ownoutCardsParent=nil;
		self.thatHandPaiContainer=self.transform:FindChild("Output/Cards").gameObject;
		self.otheroutCardsParent=self.transform:FindChild("Output/Cards_outothercards").gameObject;
		self.fapai_targetPosition=self.thatHandPaiContainer.transform:FindChild("fapai_targetPosition");
		self.fanshuPrefabParent=nil;
		self.ScrollView=nil;
		self.jiesuanFanshuList=nil;
		self.message_prompt=self.transform:FindChild("Output/message_prompt/message_prompt").gameObject:GetComponent("UISprite");
		self.emotionParent=self.transform:FindChild("PlayerInfo/Panel_Head/emotionParent");
		
		self.hupai_prefab=ResManager:LoadAsset("gameksqzmj/prefab","otherpai_zhapai");
		self.thatpaiSpritePrefab=ResManager:LoadAsset("gameksqzmj/prefab","thatPrefabParent");
		self.thispaiSpritePrefab=nil;
		--对方的牌【手里的牌，杠过的牌，出过的牌】
		self.OtherSidePais={{},{},{}};
		--自己的牌【手里的牌，杠过的牌，出过的牌，最后一张】
		self.OwnSidePais={{},{},{},{}};
		self.sceneCamera = nil;
	else
		self.sceneCamera = self.transform.parent.parent.parent.gameObject:GetComponent("Camera");
		self.bankerSprite=self.transform:FindChild("avatar_board/banker_sprite").gameObject;
		self.tingpai=self.transform:FindChild("avatar_board/tingpai_sprite").gameObject:GetComponent("UISprite");
		self.tingpaiParent=self.transform.parent:FindChild("tishiPanel/hupaitishiPanel").gameObject;
		self.cgp_headParent=self.transform:FindChild("avatar_board/cgp_headParent").gameObject:GetComponent("Animator");
		self.cgp_head_sprite=self.cgp_headParent.transform:FindChild("cgp_head").gameObject:GetComponent("UISprite");
		self.userAvatar=nil;
		self.zidongmodapai=self.transform:FindChild("avatar_board/zidongmodapai").gameObject:GetComponent("UISprite");
		--/ 玩家昵称
		self.userNickname=nil;
		--/ 玩家带入金额
		self.userIntomoney= nil;
		self.jiesuanmessage=self.transform:FindChild("Output/jiesuan").gameObject;
		self.biaoji=self.transform:FindChild("Output/Cards_outowncards/ownbiaojiparent").gameObject;
		self.win_parent=self.jiesuanmessage.transform:FindChild("win_parent").gameObject;
		self.lose_parent=self.jiesuanmessage.transform:FindChild("lose_parent").gameObject;
		--local win_zongji=self.win_parent.transform:FindChild("zongji_count").gameObject;
		--self.zongjicount_win=TextAnima_kq:New(win_zongji);
		--local lose_zongji=self.lose_parent.transform:FindChild("zongji_count").gameObject;
		--self.zongjicount_lose=TextAnima_kq:New(lose_zongji);	
		--self.win_fanshu=self.win_parent.transform:FindChild("zongji_fanshu").gameObject:GetComponent("UILabel");	
		--self.lose_fanshu=self.lose_parent.transform:FindChild("zongji_fanshu").gameObject:GetComponent("UILabel");
		self.win_fanshu=self.win_parent.transform:FindChild("jiesuan").gameObject:GetComponent("UILabel");	
		self.lose_fanshu=self.lose_parent.transform:FindChild("jiesuan").gameObject:GetComponent("UILabel");


		self.infoDetail=nil;
		self.kDetailNickname=nil;
		self.kDetailLevel=nil;
		self.kDetailBagmoney=nil;
		--self.dishu=self.jiesuanmessage.transform:FindChild("dishu").gameObject:GetComponent("UILabel");
		self.jiangli_1=self.jiesuanmessage.transform:FindChild("jiangli_1").gameObject:GetComponent("UILabel");
		self.jiangli_2=self.jiesuanmessage.transform:FindChild("jiangli_2").gameObject:GetComponent("UILabel");
		self.chilinshipai=nil;
		self.chiLinShiTarget=self.transform:FindChild("Output/chilinshi_other").gameObject;
		self.jiangliPanel=self.transform.parent:FindChild("tishiPanel/jiangliPanel").gameObject;
		local caozuoJiaoben=tingpaicaozuo:New(self.jiangliPanel,true);
		
		self.huapaiTiShi=self.jiangliPanel.transform:FindChild("fanshu/huapaitishi").gameObject:GetComponent("UISprite");
		self.ting=self.transform.parent:FindChild("CGPeffect/tingParent").gameObject:GetComponent("Animator");
		self.thisHandPaiContainer=self.transform:FindChild("Output/Cards").gameObject;
		self.ownoutCardsParent=self.transform:FindChild("Output/Cards_outowncards").gameObject;
		self.thatHandPaiContainer=nil;
		self.otheroutCardsParent=nil;
		self.fapai_targetPosition=self.thisHandPaiContainer.transform:FindChild("fapai_targetPosition");
		self.fanshuPrefabParent=self.jiesuanmessage.transform:FindChild("fanshuPrefab_1/UIGrid").gameObject:GetComponent("UIGrid");
		self.ScrollView=self.jiesuanmessage.transform:FindChild("fanshuPrefab_1").gameObject:GetComponent("UIScrollView")
		--self.fanshuPrefabParent={};
		--for i=1,3 do
			--table.insert(self.fanshuPrefabParent,self.jiesuanmessage.transform:FindChild("fanshuPrefab_"..i).gameObject);																			
		--end
		self.jiesuanFanshuList={};
		for i=1,10 do
			table.insert(self.jiesuanFanshuList,self.fanshuPrefabParent.transform:FindChild("jiesuanfanshu_"..i).gameObject);
		end

		self.message_prompt=self.transform:FindChild("avatar_board/message_prompt").gameObject:GetComponent("UISprite");												 
		self.emotionParent=self.transform:FindChild("avatar_board/emotionParent");
		
		self.hupai_prefab=ResManager:LoadAsset("gameksqzmj/prefab","ownpai_zhapai");
		self.thatpaiSpritePrefab=nil;
		local ownMahjongPai=ResManager:LoadAsset("gameksqzmj/prefab","thisPrefabParent");
		self.thispaiSpritePrefab=ownMahjongPai;
		--shuxing:New(ownMahjongPai);
		--对方的牌【手里的牌，杠过的牌，出过的牌】
		self.OtherSidePais={{},{},{}};
		--自己的牌【手里的牌，杠过的牌，出过的牌，最后一张】
		self.OwnSidePais={{},{},{},{}};
		
		--self.zongjicount_win:Awake(1,true);
		--self.zongjicount_lose:Awake(1,true);
		
	end
	
	self.trueTianting=false;
	self.trueTianhu=false;
	
	self.shiliMahjong={};
	self.InvokeLua = InvokeLua:New(self);
end
function this:clearLuaValue()
	self.gameObject = nil
	self.transform = nil
	
	self.sceneCamera=nil;
	
	self.CGPMoveJuLi=0;
	self.CGPPaiXuIndex=-1;
	self._cardPre = "Mahjong_";
	self._timeInterval = 3;
	self._timeLasted=0;
	self.huapaiIndex={};
	self.isBanker=false;
	self.canTiPai=false;
	self.tapX=0;
	self.cishu=0;
	self.movelastone=false;
	self.isChi=false;
	self.banker_last = nil;--庄家的最后一张牌
    self.createOwnCardCount = 0;
	self.createOtherCardCount=0;
    self.owncard = "owncard_";
	self.othercard="othercard_";
	self.ownLastNum=nil;
    self.PositionHaveChild = false;
    --复位————手里的牌
    self.CanHuiDiao=false;
	self.paiName="";
	self.paixuId=0;
	self.otherPlayerUid = "0";
    self.ownAlreadyTing = false;
	self.JinZhiBox=false;
	self._nnPlayerName = "NNPlayer_";
	self.fanshuList ={};
    self.jiesuanPrefabList = {};
	self.hupaiId = 0;
	self.owncardcount = 0;
	self.othercardcount = 0;
	self.lateCGPList={};
	
	
	
	self.isCPTing=false;
	self.dachuting=false;

	self.MopaiIndex=0;
	self.HasCGP=false;
	
	
	self.sex=-1;
	--self.zimotarget=nil;
	self.cardScoreObj=nil;
	self.readyObj=nil;
	self.ChiGangPengParent=nil;
	
	
	--self.fanshu_prefab=nil;
	self.emotionPrefab={};
	
	
	
	self.bankerSprite=nil;
	self.tingpai=nil;
	self.tingpaiParent=nil;
	self.cgp_headParent=nil;
	self.cgp_head_sprite=nil;
	 --/ 玩家头像
	self.userAvatar=nil;
	self.zidongmodapai=nil;
	--/ 玩家昵称
	self.userNickname=nil;
	--/ 玩家带入金额
	self.userIntomoney=nil;
	self.jiesuanmessage=nil;
	self.biaoji=nil;
	self.win_parent=nil;
	self.lose_parent=nil;
	--self.zongjicount_win=nil;
	--self.zongjicount_lose=nil;
	self.win_fanshu=nil;
	self.lose_fanshu=nil;
	self.infoDetail=nil;
	self.kDetailNickname=nil;
	self.kDetailLevel=nil;
	self.kDetailBagmoney=nil;
	--self.dishu=nil;
	self.jiangli_1=nil;
	self.jiangli_2=nil;
	self.chiLinShiTarget=nil;
	self.chilinshipai=nil;
	self.jiangliPanel=nil;
	self.huapaiTiShi=nil;
	self.ting=nil;
	self.thisHandPaiContainer=nil;
	self.ownoutCardsParent=nil;
	self.thatHandPaiContainer=nil;
	self.otheroutCardsParent=nil;
	self.fapai_targetPosition=nil;
	--self.fanshuPrefabParent={};
	self.fanshuPrefabParent=nil;
	self.jiesuanFanshuList=nil;
	self.message_prompt=nil;
	self.emotionParent=nil;
	self.hupai_prefab=nil;
	self.thatpaiSpritePrefab=nil;
	self.thispaiSpritePrefab=nil;
	--对方的牌【手里的牌，杠过的牌，出过的牌】
	self.OtherSidePais={{},{},{}};
	--自己的牌【手里的牌，杠过的牌，出过的牌，最后一张】
	self.OwnSidePais={{},{},{},{}};

	self.InvokeLua = InvokeLua:New(self);
	
	self.InvokeLua:clearLuaValue();
	self.InvokeLua = nil; 
	
	self.otheruid=nil;
	self.shiliMahjong={};
	for k,v in pairs(self.shiliMahjong) do
		v.OnDestroy();
	end

	self.trueTianting=false;
	self.trueTianhu=false;
	self.shiliMahjong={};
end
function this:bindMahjong(objName,gameObj,isown)
	self.shiliMahjong[objName]=shuxing:New(gameObj,isown);
end
function this:getMahjong(objName)
	return self.shiliMahjong[objName];
end
function this:removePlayerCtrl(objName)
	if self.shiliMahjong[objName]~=nil then
		self.shiliMahjong[objName]:OnDestroy();
	end
	self.shiliMahjong[objName]=nil;
end
function this:ReplaceNamePlayerCtrl(oldName,newName)
	if oldName~=newName then
		local ksqzTemp=self.shiliMahjong[oldName];
		if ksqzTemp~=nil then
			self.shiliMahjong[newName]=ksqzTemp;
			self.shiliMahjong[oldName]=nil;
		end
	end
end
function this:Awake()
	self:init();
	----------绑定按钮事件--------
	if self.gameObject.name ~= "User" then
		GameKSQZMJ.mono:AddClick(self.userAvatar.gameObject,self.OnClickInfoDetail,self);
	end
	--log(Screen.width.."宽度");
	--log(Screen.height.."高度");
end
function this:Start()
	self:UpdateInLua();
	--UISoundManager.Instance._EFVolume=1;
	--UISoundManager.Instance._BGVolume=1;
	--UISoundManager.Start(true);
end

function this:UpdateInLua()
	if self.infoDetail ~= nil  and  self.infoDetail.activeSelf then
	
		self._timeLasted = self._timeLasted + 0.1
		if self._timeLasted >= self._timeInterval then
		
			self.infoDetail:SetActive(false);
			self._timeLasted = 0;
		end
	end
	
	--if self.zongjicount_lose~=nil then
		--self.zongjicount_lose:Update();
	--end
	--if self.zongjicount_win~=nil then
		--self.zongjicount_win:Update();
	--end

	--[[
	if Input.GetMouseButton(0) then
		if self.sceneCamera~=nil then
			local vc3=self.sceneCamera:ScreenToWorldPoint(Input.mousePosition);			
			log(vc3);
			log("--------------");
			local hit=nil;
			log(Physics.Raycast(vc3,Vector3.forward,600));
			if Physics.Raycast(vc3,Vector3.forward,600) then
				log("++++++++++++");
				if self.canTiPai then
					log("/////////////");
					if RaycastHit.collider.gameObject.transform.parent==self.thisHandPaiContainer.transform then
						log(RaycastHit.collider.gameObject.name.."============碰到的物体名称");
						self.getMahjong(RaycastHit.collider.gameObject.name):huadongSelect();
					end
				end
			end
		
			
			
			local uIray = self.sceneCamera:ScreenPointToRay(Input.mousePosition);
 			local isHit, hit = Physics.Raycast(uIray, hit, 600, LayerMask.NameToLayer("mahjong"));
			if isHit then
 				local objectName = hit.transform.name;
 				log(objectName);
 			end
			
		end
	end
	]]
	

	--if Input.GetMouseButton(0) then
		--if self.sceneCamera~=nil then
			--log("dianji");
			--local uIray=self.sceneCamera:ScreenPointToRay(Input.mousePosition);
			--local isHit,hit=Physics.Raycast(uIray,Vector3.forward,hit);
			--if isHit then
				--local objName=hit.transform.name;
				--self.getMahjong(objName):huadongSelect();
			--end
		--end
	--end

	
	
	--[[
	if #(self.OwnSidePais[1])>0 then
		if Input.GetMouseButton(0) then
			local pos_x = Input.mousePosition.x;		
			local pos_y=Input.mousePosition.y;
			log(pos_x);
			if pos_y>12 and pos_y<95 then 
				for i=1,#(self.OwnSidePais[1]) do 
					--log(pos_x);
					if pos_x>((self.OwnSidePais[1][i].transform.localPosition.x+220)*(Screen.width/800))  and pos_x<((self.OwnSidePais[1][i].transform.localPosition.x+300)*(Screen.width/800)) then
						log(((self.OwnSidePais[1][i].transform.localPosition.x+220)*(Screen.width/800)).."-------"..self.OwnSidePais[1][i].name);
						self:getMahjong(self.OwnSidePais[1][i].name):huadongSelect();
					--else
						--log((self.OwnSidePais[1][i].transform.localPosition.x).."++++++++"..self.OwnSidePais[1][i].name);
					end
				end
			end
		end
	end	
	]]
end



function this:OnDestroy()
	self:clearLuaValue()
end


function this:SetPlayerInfo(avatar,   nickname,   intomoney,   level)

	self.userAvatar.spriteName = "avatar_".. avatar;
	self.userNickname.text = nickname;
	if  LengthUTF8String(self.userNickname.text) > 5 then
			self.userNickname.text =   SubUTF8String(self.userNickname.text,12);
	end
	
	self.userIntomoney.text = "¥ ".. EginTools.NumberAddComma(intomoney);
    
	self.kDetailNickname.text = nickname;
	if  LengthUTF8String(self.kDetailNickname.text) > 5 then
			self.kDetailNickname.text =   SubUTF8String(self.kDetailNickname.text,12);
	end
	
	self.kDetailLevel.text = level;
	self.kDetailBagmoney.text = intomoney;
	local leixing={};
	leixing[0]=nil;
	leixing[1]=false;
	self:HuiDiaoFunction(leixing);
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

function this:UpdateIntoMoney( intomoney)

	if self.userIntomoney == nil then
	
		GameObject.Find("Label_Bagmoney"):GetComponent("UILabel").text =EginTools.NumberAddComma(intomoney);
	else
		self.userIntomoney.text = "¥ ".. EginTools.NumberAddComma(intomoney);
	end
end

function this:FaPaiMove(obj,x,y,timeC,islocal,position_y,canMove,isOwnMoPai)
	local leixing={};
	leixing[0]=x;
	leixing[1]=y+position_y;
	leixing[2]=obj;
	leixing[3]=canMove;
	leixing[4]=isOwnMoPai;
	
	iTween.MoveTo(obj.gameObject,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal", islocal,"easeType", iTween.EaseType.linear,"oncomplete", self.FaPaiMove_1,"oncompleteparams", leixing,"oncompletetarget", self));
end

function this:FaPaiMove_1(leixing)
	local lei=leixing;
	local x=lei[0];
	local y=lei[1];
	local obj=lei[2];
	local canMove=lei[3];
	local isownMoPai=lei[4];
	
	local canshu={};
	canshu[0]=obj;
	canshu[1]=isownMoPai;
	
	if canMove then
		iTween.MoveTo(obj.gameObject,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", 0.2,"islocal", true,"easeType", iTween.EaseType.linear,"oncomplete", self.HuiDiaoFunction,"oncompleteparams", canshu,"oncompletetarget", self));
	else
		iTween.MoveTo(obj.gameObject,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", 0.2,"islocal", true,"easeType", iTween.EaseType.linear));
	end
end

function this:HuiDiaoFunction(leixing)
	local lei=leixing;
	local obj=lei[0];
	local isownMoPai=lei[1];
	if isownMoPai then
		GameKSQZMJ.isOwnChuPai=true;
	end
	self.cishu=self.cishu+1;
	if not IsNil(obj) and  obj:GetComponent("BoxCollider") then
		if self.JinZhiBox then
			obj:GetComponent("BoxCollider").enabled=false;
		else
			obj:GetComponent("BoxCollider").enabled=true;
		end
	end
	coroutine.start(self.HuiDiaoFunction_1,self,cishu);
end

function this:HuiDiaoFunction_1(cishu)
	coroutine.wait(0.5);
	self.PositionHaveChild=false;
	GameKSQZMJ.AnimatorPlayEnd=true;
	coroutine.start(GameKSQZMJ.ChiXuJieXiaoXi);
end

function this:OwnPaiChange(leixing)
	coroutine.start(self.OwnPaiChange_1,self,leixing);
end

function this:OwnPaiChange_1(leixing)
	--log("牌变形");
	local lei=leixing;
	local obj=lei[0];
	local x=lei[1];
	local y=lei[2];
	local timeC=lei[3];
	local chupaicount=lei[4];
	local dengdaiUid=lei[5];
	coroutine.wait(0.1);
	obj.transform.parent=self.ownoutCardsParent.transform;
	obj.transform.localPosition=Vector3.New(x,y,0);
	obj.transform.localScale=Vector3.one;
	local bottom_bg=obj.transform:FindChild("bottom_bg"):GetComponent("UISprite");
	local bottom_sprite=obj.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
	bottom_bg.spriteName="chupai_big";
	bottom_bg.width=58;
	bottom_bg.height=86;
	bottom_sprite.width=78;
	bottom_sprite.height=90;
	bottom_sprite.transform.localScale=Vector3.New(0.64,0.64,0.64);
	bottom_sprite.transform.localPosition=Vector3.New(0,11.5,0);
	if chupaicount<15 then
		obj:GetComponent("UIPanel").depth=15;
	else
		obj:GetComponent("UIPanel").depth=16;
	end
	local mubiaoTarget=self.ownoutCardsParent.transform:FindChild("Sprite_"..chupaicount).gameObject;
	self.biaoji.transform.localPosition=Vector3.New(mubiaoTarget.transform.localPosition.x,mubiaoTarget.transform.localPosition.y+25,0);
	self.biaoji:SetActive(true);
	if GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..dengdaiUid).chiLinShiTarget.activeSelf then
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..dengdaiUid).chiLinShiTarget:SetActive(false);
	end
	UISoundManager.Instance.PlaySound("chupai");
	if GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..dengdaiUid) then
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..dengdaiUid):HideBiaoji();
	end
	coroutine.wait(0.3);
	coroutine.start(self.fuWeiShouLiPai,self,false,0,true);
end

function this:TargetToHupai(obj,x,y,timeC,moveJuLi)
	local leixing={};
	leixing[0]=x+moveJuLi;
	leixing[1]=y;
	leixing[2]=obj;
	
	iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal", true,"easeType", iTween.EaseType.linear,"oncomplete", self.HengYi,"oncompleteparams", leixing,"oncompletetarget", self));
end

function this:HengYi(leixing)
	local lei=leixing;
	local x=lei[0];
	local y=lei[1];
	local obj=lei[2];
	
	iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", 0.3,"islocal", true,"easeType", iTween.EaseType.linear));
end


function this:HengYi(obj,x,y)

	iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", 0.3,"islocal", true,"easeType", iTween.EaseType.linear));
end

function this:MoveToTarget(obj,x,y,timeC,islocal)
	if movelastone then
		if islocal then
			iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal",islocal,"easeType", iTween.EaseType.linear,"oncomplete", self.MoveToDownAgain,"oncompleteparams", true,"oncompletetarget", self));
		else
			iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal",islocal,"easeType", iTween.EaseType.easeOutCubic,"oncomplete", self.MoveToDownAgain,"oncompleteparams", true,"oncompletetarget", self));
		end
	else
		if islocal then
			iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal",islocal,"easeType", iTween.EaseType.linear));
		else
			iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal",islocal,"easeType", iTween.EaseType.easeOutCubic));
		end
	end
end

--如果摸的牌是排在最后一位时
function this:LastFuWei(obj,x,y,timeC,islast)
	self.ownLastNum=nil;
	if islast then
		iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal",true,"easeType", iTween.EaseType.linear,"oncomplete", self.QiYongBox,"oncompleteparams", true,"oncompletetarget", self));
	else
		iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal",true,"easeType", iTween.EaseType.linear));
	end
end

function this:QiYongBox(isown)
	GameKSQZMJ.standupCardObj=nil;
	if not self.isCPTing then
		self:JinZhiShouLiPai(true);
	end
	if self.CanHuiDiao then
		self.cishu=self.cishu+1;
		coroutine.start(self.HuiDiaoFunction_1,self,cishu);
	end

end

function this:MoveNotDelay(obj,x,y,timeC)
	iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal",true,"easeType", iTween.EaseType.linear,"oncomplete", self.MoveTarget_left,"oncompleteparams", true,"oncompletetarget", self));
end

function this:MoveDown(obj,x,y,timeC)
	iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"islocal",true,"easeType", iTween.EaseType.linear,"oncomplete", self.MoveToDown,"oncompleteparams", true,"oncompletetarget", self));
end

function this:MoveDelay(obj,x,y,timeC,delay)
	if self.PositionHaveChild then
		iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"delay",delay,"islocal",true,"easeType", iTween.EaseType.easeOutCubic,"oncomplete", self.MoveToHuanYuan,"oncompleteparams", true,"oncompletetarget", self));
	else
		iTween.MoveTo(obj,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(x, y, 0),"time", timeC,"delay",delay,"islocal",true,"easeType", iTween.EaseType.easeOutCubic,"oncomplete", self.MoveToDown,"oncompleteparams", true,"oncompletetarget", self));
	end
end

--手里最后一张牌向预定位置横向移动
function this:MoveTarget_left(isown)
	if not IsNil(self.ownLastNum) then
		self.ownLastNum.transform:FindChild("bottom_bg").transform.eulerAngles=Vector3.New(0,0,20);
		self:MoveDelay(self.ownLastNum,101*(self:getMahjong(self.ownLastNum.name).paixuindex-1)+self.CGPMoveJuLi,self.ownLastNum.transform.localPosition.y,0.3,0.1);
	end
end

--手里除了最后一张牌的所有牌的横向移动
function this:MoveToHuanYuan(isown)
	local handCount=0;
	for i=1,#(self.OwnSidePais[1]) do
		--log(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex.."------==========--------"..self.OwnSidePais[1][i].name);
	end
	for i=1,#(self.OwnSidePais[1]) do
		if self.OwnSidePais[1][i]~=self.ownLastNum then
			handCount=handCount+1;
			if handCount==(#(self.OwnSidePais[1])-1) then
				--log(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex.."======="..self.OwnSidePais[1][i].name.."======"..self.CGPMoveJuLi);
				--log(101*(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex)+self.CGPMoveJuLi);
				local moveposition_index=self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1;
				self:MoveDown(self.OwnSidePais[1][i],101*moveposition_index+self.CGPMoveJuLi,0,0.1);
			else
				--log(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex.."-------"..self.OwnSidePais[1][i].name.."-------"..self.CGPMoveJuLi);
				--log(101*(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex)+self.CGPMoveJuLi);
				local moveposition_index=self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1;
				self:MoveToTarget(self.OwnSidePais[1][i],101*moveposition_index+self.CGPMoveJuLi,0,0.1,true);
			end
		end
	end
end

--最后一张牌纵向移动
function this:MoveToDown(isown)
	self.ownLastNum.transform:FindChild("bottom_bg").eulerAngles=Vector3.zero;
	self:LastFuWei(self.ownLastNum,101*(self:getMahjong(self.ownLastNum.name).paixuindex-1)+self.CGPMoveJuLi,0,0.1,true);
end

function this:MoveToDownAgain(isown)

end

function this:SetReady(toShow)
	if toShow and not self.readyObj.activeSelf then
		self.readyObj:SetActive(true);
		UISoundManager.Instance.PlaySound("ready");
	else
		self.readyObj:SetActive(false);
	end
end

function this:SetCallBanker(toShow)
	if toShow then
		self.bankerSprite:SetActive(true);
	else
		self.bankerSprite:SetActive(false);
	end
end

function this:AfterDoing(offset,run,parameter)
	coroutine.wait(offset);	
	if self.gameObject then
		run(self,parameter);
	end
end



function this:chuangJianThatPais(paiNum,cishu,isbanker)
	self.CGPPaiXuIndex=-1;
	self.isBanker=isbanker;
	self.otherPlayerUid=EginUser.Instance.uid;
	for i=1,paiNum do 
		self.createOtherCardCount=self.createOtherCardCount+1;
		local endPosition=Vector3.zero;
		local out0=GameObject.Instantiate(self.thatpaiSpritePrefab);
		out0.name=self.othercard..self.createOtherCardCount;
		local shilipai=self:bindMahjong(out0.name,out0.gameObject,false);
		
		out0.transform.parent=self.thatHandPaiContainer.transform;
		out0.transform.localPosition=self.fapai_targetPosition.localPosition;
		out0.transform.localScale=Vector3.one;
		
		local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
		out_1.spriteName="otherCGP_1";
		
		
		if cishu==3 then
			table.insert(self.OtherSidePais[1],out0.gameObject);
			endPosition=Vector3.New(-20,0,0);
		else
			table.insert(self.OtherSidePais[1],out0.gameObject);
			endPosition=Vector3.New(#(self.OtherSidePais[1])*60,0,0);
		end
		self:FaPaiMove(out0,endPosition.x,endPosition.y-20,0.3,true,20,false,false);
	end
	coroutine.wait(0.6);
	if cishu==3 then
		self:OtherCardMove();
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..self.otherPlayerUid):OwnCardMove();
	end
end

function this:SelectMahjong(obj)
	for i=1,#(self.OwnSidePais[1]) do
		if obj==self.OwnSidePais[1][i] then
			--log(self.OwnSidePais[1][i].name.."==麻将name");
			self:getMahjong(self.OwnSidePais[1][i].name):huadongSelect();
			break;
		end
	end
end

function this:chuangJianThisPais(infos,cishu,isbanker)
	self.CGPPaiXuIndex=-1;
	self.isBanker=isbanker;
	self.canTiPai=true;
	self.otherPlayerUid=GameKSQZMJ.otherUid;
	for i=1,#(infos) do
		local endPosition=Vector3.zero;
		self.createOwnCardCount=self.createOwnCardCount+1;
		local out0=GameObject.Instantiate(self.thispaiSpritePrefab);
		out0.name=self.owncard..self.createOwnCardCount;
		local shilipai=self:bindMahjong(out0.name,out0.gameObject,true);
		out0.transform.parent=self.thisHandPaiContainer.transform;
		out0.transform.localPosition=self.fapai_targetPosition.localPosition;
		out0.transform.localScale=Vector3.one;
		out0:GetComponent("BoxCollider").enabled=false;
		

		
		local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
		out_1.spriteName="stand_forward";
		out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..infos[i];
		--log("huapaishuliang");
		--log(#(self.huapaiIndex));
		for j=1,#(self.huapaiIndex) do
			if infos[i]==self.huapaiIndex[j] then
				out0.transform:FindChild("huapai"):GetComponent("UISprite").alpha=1;
			end
		end
		--将要听牌的麻将牌的番数父物体放在tingpaiParent中
		local out_2=out_1.transform:FindChild("tingpai").gameObject;
		out_2.name=out0.name;
		out_2.transform.parent=self.tingpaiParent.transform;
		out_2.transform.localPosition=Vector3.zero;
		out_2.transform.localScale=Vector3.one;
		table.insert(self.OwnSidePais[4],out_2);
		
		
		
		if cishu==3 then
			endPosition=Vector3.New(7*101+30,0,0);
			self.banker_last=out0;
			self:getMahjong(out0.name).paixuindex=8;
			self.ownLastNum=out0.gameObject;
			out0:GetComponent("UIPanel").depth=27;
		else
			table.insert(self.OwnSidePais[1],out0.gameObject);
			endPosition=Vector3.New((#(self.OwnSidePais[1])-1)*101,0,0);
			self:getMahjong(out0.name).paixuindex=#(self.OwnSidePais[1]);
			out0:GetComponent("UIPanel").depth=#(self.OwnSidePais[1]);
		end
		self:getMahjong(out0.name).paiid=tonumber(infos[i]);
		self:getMahjong(out0.name).paixuid=self:paiXuID(tonumber(infos[i]));
		--log("麻将牌");
		--log(self:getMahjong(out0.name).paiid);
		--log(self:getMahjong(out0.name).paixuid);
		--log(self:getMahjong(out0.name).paixuindex);
		self:FaPaiMove(out0,endPosition.x,endPosition.y+20,0.3,true,-20,false,false);
		UISoundManager.Instance.PlaySound("fanpai");
	end
	
	if self.isBanker and cishu==3 then
		coroutine.wait(0.5);
		self:OwnCardMove();
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..self.otherPlayerUid):OtherCardMove();
	end
end

function this:OwnCardMove()
	iTween.MoveTo(self.thisHandPaiContainer,GameKSQZMJ.mono:iTweenHashLua ("position",Vector3.New(self.thisHandPaiContainer.transform.localPosition.x, self.thisHandPaiContainer.transform.localPosition.y-12, 0),"time", 0.45,"delay",0.2,"islocal", true,"easeType", iTween.EaseType.linear,"oncomplete", self.OwnCardMove_1,"oncompleteparams", true,"oncompletetarget", self));
end

function this:OwnCardMove_1(isown)
	for i=1,#(self.OwnSidePais[1]) do
		self.OwnSidePais[1][i].transform:FindChild("bottom_bg"):GetComponent("UISprite").spriteName="koupai_own";
		self.OwnSidePais[1][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").alpha=0;
		self.OwnSidePais[1][i].transform:FindChild("huapai"):GetComponent("UISprite").depth=10;
	end
	if self.isBanker then
		self.banker_last.transform:FindChild("bottom_bg"):GetComponent("UISprite").spriteName="koupai_own";
		self.banker_last.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").alpha=0;
		self.banker_last.transform:FindChild("huapai"):GetComponent("UISprite").depth=10;
	end
	coroutine.start(self.fuWeiShouLiPai,self,true,0,true);
	iTween.MoveTo(self.thisHandPaiContainer,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(self.thisHandPaiContainer.transform.localPosition.x, self.thisHandPaiContainer.transform.localPosition.y+12, 0),"time", 0.45,"islocal",true,"easeType", iTween.EaseType.linear,"oncomplete", self.OwnCardMove_2,"oncompleteparams", true,"oncompletetarget", self));
end

function this:OwnCardMove_2(isown)
	for i=1,#(self.OwnSidePais[1]) do
		self.OwnSidePais[1][i].transform:FindChild("bottom_bg"):GetComponent("UISprite").spriteName="stand_forward";
		self.OwnSidePais[1][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").alpha=1;
		self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=true;
		self.OwnSidePais[1][i].transform:FindChild("huapai"):GetComponent("UISprite").depth=12;
	end
	if self.isBanker then
		self.banker_last.transform:FindChild("bottom_bg"):GetComponent("UISprite").spriteName="stand_forward";
		self.banker_last.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").alpha=1;
		self.banker_last:GetComponent("BoxCollider").enabled=true;
		self.banker_last.transform:FindChild("huapai"):GetComponent("UISprite").depth=12;
		table.insert(self.OwnSidePais[1],self.banker_last);
	end
	
	local leixing={};
	leixing[0]=nil;
	leixing[1]=false;
	self:HuiDiaoFunction(leixing);
end

function this:OtherCardMove()
	iTween.MoveTo(self.thatHandPaiContainer,GameKSQZMJ.mono:iTweenHashLua ("position",Vector3.New(self.thatHandPaiContainer.transform.localPosition.x, self.thatHandPaiContainer.transform.localPosition.y+12, 0),"time", 0.45,"delay",0.2,"islocal", true,"easeType", iTween.EaseType.linear,"oncomplete", self.OtherCardMove_1,"oncompleteparams", true,"oncompletetarget", self));
end

function this:OtherCardMove_1(isother)
	iTween.MoveTo(self.thatHandPaiContainer,GameKSQZMJ.mono:iTweenHashLua("position",Vector3.New(self.thatHandPaiContainer.transform.localPosition.x, self.thatHandPaiContainer.transform.localPosition.y-12, 0),"time", 0.45,"islocal",true,"easeType", iTween.EaseType.linear,"oncomplete", self.OtherCardMove_2,"oncompleteparams", true,"oncompletetarget", self));
end

function this:OtherCardMove_2(isother)
	for i=1,#(self.OtherSidePais[1]) do
		self.OtherSidePais[1][i].transform:FindChild("bottom_bg"):GetComponent("UISprite").spriteName="stand_back";
	end
end



--排序
--arr 牌数组 
--按照万1--9，条1--9，筒1--9，东，西，南，北，中，发，白排序
function this:partition(list,low,high)
	local low=self:getMahjong(list[low].name).paixuid;
	local high=self:getMahjong(list[high].name).paixuid;
	local pivotKey=low;
	
	while low<high do
		while low<high and high>=pivotKey do
			high=high-1;
		end
		swap(list,low,high);
		while low<high and low<=pivotKey do 
			low=low+1;
		end
		swap(list,low,high);
	end
	return low;
end

function this:paixu_1(list,low,high)
	--log("开始排序")
	--log(list[low].name);
	--log(list[high].name)
	--log(self:getMahjong(list[low].name).paixuid);
	--log(self:getMahjong(list[high].name).paixuid);
	if self:getMahjong(list[low].name).paixuid<self:getMahjong(list[high].name).paixuid then
		local pivotKeyIndex=self:partition(list,low,high);
		self:paixu(list,low,pivotKeyIndex-1);
		self:paixu(list,pivotKeyIndex+1,high);
	end
end

function this:paixu(list)
	for i=1,#(list)-1 do
		local temp=nil;
		for j=1,#(list)-1 do 
			if self:getMahjong(list[j].name).paixuid>self:getMahjong(list[j+1].name).paixuid then
				temp=list[j];
				list[j]=list[j+1];
				list[j+1]=temp;
			end
		end
	end
	for i=1,#(list) do
		--log(list[i].name);
	end
end







--复位————手里的牌
function this:fuWeiShouLiPai(isStart,timeC,canhuidiao)
	self.CanHuiDiao=canhuidiao;
	coroutine.wait(timeC);
	for i=1,#(self.OwnSidePais[1]) do
		if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
			self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
		end
	end
	
	if #(self.OwnSidePais[1])>0 then
		self:paixu(self.OwnSidePais[1]);
		--for i=1,#(self.OwnSidePais[1]) do
			--log("排序开始");
			--log(self.OwnSidePais[1][i].name);
			--log(self:getMahjong(self.OwnSidePais[1][i].name).paiid);
			--log(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex);
		--end
		
		--self:paixu(self.OwnSidePais[1],self:getMahjong(self.OwnSidePais[1][1].name).paixuid,self:getMahjong(self.OwnSidePais[1][#(self.OwnSidePais[1])].name).paixuid);
		
		
		for i=1,#(self.OwnSidePais[1]) do
			self.OwnSidePais[1][i]:GetComponent("UIPanel").depth=i+20;
		end
		if isStart then
			self.CGPMoveJuLi=0;
			for i=1,#(self.OwnSidePais[1]) do
				self.OwnSidePais[1][i].transform.localPosition=Vector3.New((i-1)*101+self.CGPMoveJuLi,0,0);
				self:getMahjong(self.OwnSidePais[1][i].name).paixuindex=i;
				self.OwnSidePais[1][i]:GetComponent("UIPanel").depth=i+20;
			end
		else
			if not IsNil(self.ownLastNum) then
				--log("self.ownLastNum==========="..self.ownLastNum.name);
				for i=1,#(self.OwnSidePais[1]) do
					self:getMahjong(self.OwnSidePais[1][i].name):huanyuan();
					self:getMahjong(self.OwnSidePais[1][i].name).paixuindex=i;
					--log("排序手里牌");
					--log(self.OwnSidePais[1][i].name);
					--log(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex);
				end
				if self:getMahjong(self.ownLastNum.name).paixuindex==#(self.OwnSidePais[1]) then
					--log("最后一位");
					for i=1,#(self.OwnSidePais[1]) do
						if i==#(self.OwnSidePais[1]) then
							self:LastFuWei(self.OwnSidePais[1][i],101*(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1)+self.CGPMoveJuLi,0,0.1,true);
						else
							self:LastFuWei(self.OwnSidePais[1][i],101*(self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1)+self.CGPMoveJuLi,0,0.1,false);
						end
					end
				else
					--log("不是最后一位");
					self.PositionHaveChild=true;
					self:MoveNotDelay(self.ownLastNum,self.ownLastNum.transform.localPosition.x+self.CGPMoveJuLi,self.ownLastNum.transform.localPosition.y+160,0.1);
				end
			else
				--log("self.ownLastNum=nil");
				for i=1,#(self.OwnSidePais[1]) do
					self:getMahjong(self.OwnSidePais[1][i].name):huanyuan();
					self:getMahjong(self.OwnSidePais[1][i].name).paixuindex=i;
					if i==#(self.OwnSidePais[1]) then
						self:LastFuWei(self.OwnSidePais[1][i],101*(i-1)+self.CGPMoveJuLi,0,0.1,true);
					else
						self:LastFuWei(self.OwnSidePais[1][i],101*(i-1)+self.CGPMoveJuLi,0,0.1,false);
					end
				end
			end		
		end	
	end
end

--按照万1--9，条1--9，筒1--9，东，南，西，北，中，发，白排序
function this:paiXuID(paiId)
	if paiId>30 then
		self.paixuId=paiId-30;
	end
	if paiId>20 and paiId<30 then
		self.paixuId=paiId-10;
	end
	if paiId>10 and paiId<20 then
		self.paixuId=paiId+10;
	end
	if paiId>0 and paiId<10 then
		self.paixuId=paiId+30;
	end
	return self.paixuId;
end

--[[
function this:partition_CGP(list,low,high)
	local low=low;
	local high=high;
	local pivotKey=self:getMahjong(list[low].name).paixuindex;
	
	while low<high do
		while low<high and self:getMahjong(list[high].name).paixuindex>=pivotKey do
			high=high-1;
		end
		swap(list,low,high);
		while low<high and self:getMahjong(list[low].name).paixuindex<=pivotKey do 
			low=low+1;
		end
		swap(list,low,high);
	end
	return low;
end

function this:paixu_CGP(list,low,high)
	if low<high then
		local pivotKeyIndex=this:partition_CGP(list,low,high);
		self:paixu_CGP(list,low,pivotKeyIndex-1);
		self:paixu_CGP(list,pivotKeyIndex+1,high);
	end
end
]]
function this:paixu_CGP(list)
	for i=1,#(list)-1 do
		local temp=nil;
		for j=1,#(list)-1 do 
			if self:getMahjong(list[j].name).paixuindex>self:getMahjong(list[j+1].name).paixuindex then
				temp=list[j];
				list[j]=list[j+1];
				list[j+1]=temp;
			end
		end
	end
	--for i=1,#(list) do
		--log(list[i].name);
	--end	
end


function this:JinZhiShouLiPai(isJinZhi)
	for i=1,#(self.OwnSidePais[1]) do
		if not ownAlreadyTing then
			if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
				self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=isJinZhi;
			end
		end
		self.OwnSidePais[1][i].transform:FindChild("bottom_bg").transform.eulerAngles=Vector3.zero;
	end
end

function this:NotTuoGuanChuPai(chupaicount,card,isTingpai)
	--log("我自己出牌");
	--log(chupaicount);
	--log(card);
	--log(isTingpai);
	GameKSQZMJ:HideTanKuang();
	local ischupai=false;
	self.ownAlreadyTing=isTingpai;
	GameKSQZMJ.AnimatorPlayEnd=false;
	for i=1,#(self.OwnSidePais[1]) do
		if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
			self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
		end
	end
	GameKSQZMJ.standupCardObj=nil;
	GameKSQZMJ.isOwnChuPai=false;
	if isTingpai then
		self.dachuting=true;
		for i=1,#(self.OwnSidePais[4]) do
			if self.OwnSidePais[4][i]:GetComponent("UISprite").alpha==0 then
				self.OwnSidePais[4][i]:SetActive(false);
			end
		end
		for i=1,#(self.OwnSidePais[1]) do
			if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
				destroy(self.OwnSidePais[1][i]:GetComponent("BoxCollider"));		
			end
		end
		self.zidongmodapai.gameObject:SetActive(true);
		GameKSQZMJ.btnTuoguan:GetComponent("BoxCollider").enabled=false;
	end
	
	--log("自己手牌个数");
	--log(#(self.OwnSidePais[1]));
	local shouzhongpaigeshu=#(self.OwnSidePais[1]);--手中牌的个数，用来判断如果下面remove之后，如果i等于最大个数的时候，自动返回
	--for k,value in pairs(self.OwnSidePais[1]) do
		--log(value.name);
		--log(k);
	--end
	for i=#(self.OwnSidePais[1]),1,-1 do		
		if i==shouzhongpaigeshu then
			if ischupai then
				return;
			end
		end 
		--log("xunhuan");
		--log(#(self.OwnSidePais[1]).."=========="..i);
		--log(self.OwnSidePais[1][i].name);
		--log(self.OwnSidePais[1][i].transform.localPosition.y);
		--log(self:getMahjong(self.OwnSidePais[1][i].name).paiid);
		if self.OwnSidePais[1][i].transform.localPosition.y~=0 and self:getMahjong(self.OwnSidePais[1][i].name).paiid==card then
			ischupai=true;
			if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
				self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
			end
			local chupai=self.OwnSidePais[1][i];
			table.insert(self.OwnSidePais[3],chupai);--主玩家出的所有牌
			iTableRemove(self.OwnSidePais[1],chupai);
			coroutine.start(self.DaChupai,self,chupai,chupaicount,true,self.otherPlayerUid,card,isTingpai,false);
			i=i-1;
			--for k,value in pairs(self.OwnSidePais[1]) do
				--log("------------------");
				--log(value.name);
				--log(k);
			--end
		else
		    if isTingpai then
				self.OwnSidePais[1][i].transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0.2;
				if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
				end
				--[[
				if self.isBanker and self.banker_last~=nil then
					self.banker_last.transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0.2;
					self.banker_last:GetComponent("BoxCollider").enabled=false;
				end
				]]
			end
		end
	end
end

function this:SetOwnChupai(card,chupaicount,dengdaiUid,isTingpai,zhuangtai,istuoguan)
	if istuoguan then
		--log("托管出牌");
	end
	--log("打出听牌");
	--log(self.dachuting);
	if self.dachuting then
		--log("1111111111");
		self.dachuting=false;
	else
		if istuoguan then
			--log("jinru");
			if #(self.OwnSidePais[1])%3==2 then
				GameKSQZMJ.isOwnChuPai=false;
				GameKSQZMJ.standupCardObj=nil;
				for i=#(self.OwnSidePais[1]),1,-1 do
					--log(self.OwnSidePais[1][i].name.."----------------"..self:getMahjong(self.OwnSidePais[1][i].name).paiid);
					if self:getMahjong(self.OwnSidePais[1][i].name).paiid==card then
						if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
							self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
						end
						local chupai=self.OwnSidePais[1][i];
						table.insert(self.OwnSidePais[3],chupai);--主玩家出的所有牌
						iTableRemove(self.OwnSidePais[1],chupai);
						coroutine.start(self.DaChupai,self,chupai,chupaicount,true,dengdaiUid,card,isTingpai,istuoguan);
						break;
					end	
				end
				for i=1,#(self.OwnSidePais[1]) do
					self.OwnSidePais[1][i].transform:FindChild("bottom_bg/Sprite_logo"):GetComponent("UISprite").alpha=0;
				end
			elseif #(self.OwnSidePais[1])%3==1 then
				if self:getMahjong(self.OwnSidePais[3][#(self.OwnSidePais[3])].name).paiid~=card then
					GameKSQZMJ.isOwnChuPai=false;
					GameKSQZMJ.standupCardObj=nil;
					--log(#(self.OwnSidePais[3]).."打出牌的数量");
					local outIndexName=self.OwnSidePais[3][#(self.OwnSidePais[3])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName;
					local outIndexId=self:getMahjong(self.OwnSidePais[3][#(self.OwnSidePais[3])].name).paiid;
					self.OwnSidePais[3][#(self.OwnSidePais[3])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=self._cardPre..card;
					for i=#(self.OwnSidePais[1]),1,-1 do
						if self:getMahjong(self.OwnSidePais[1][i].name).paiid==card then
							self.OwnSidePais[1][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=outIndexName;
							self:getMahjong(self.OwnSidePais[1][i].name).paiid=outIndexId;
							self:getMahjong(self.OwnSidePais[1][i].name).paixuid=self:paiXuID(outIndexId);
							break;
						end
					end
					coroutine.start(self.fuWeiShouLiPai,self,true,0,true);
				end
			end
		else
			for i=1,#(self.OwnSidePais[1]) do
				if self.OwnSidePais[1][i].transform.localPosition.y~=0 and self:getMahjong(self.OwnSidePais[1][i].name).paiid==card then
					if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
						self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
					end
					local chupai=self.OwnSidePais[1][i];
					table.insert(self.OwnSidePais[3],chupai);--主玩家出的所有牌
					iTableRemove(self.OwnSidePais[1],chupai);
					coroutine.start(self.DaChupai,self,chupai,chupaicount,true,dengdaiUid,card,isTingpai,istuoguan);
					break;
				end
			end
		end
	end
end

function this:DaChupai(target,chupaicount,isown,dengdaiUid,card,istingpai,istuoguan)
	if istuoguan then
		--log("托管打出牌");
	end
	if self.sex==0 then
		UISoundManager.Instance.PlaySound("man_"..card);
	else
		UISoundManager.Instance.PlaySound("woman_"..card);
	end
	local player=GameObject.Find(self._nnPlayerName..dengdaiUid);
	if isown then
		--log("如果是自己");
		if istuoguan then
			--log("托管打牌提牌");
			if target.transform.localPosition.y==0 then
				target.transform.localPosition=Vector3.New(target.transform.localPosition.x,30,0);
			end
			coroutine.wait(0.2);
		end
		target.transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0;
		if target==self.ownLastNum then
			self.ownLastNum=nil;
		end
		target.transform:FindChild("huapai").gameObject:SetActive(false);
		if target.transform:FindChild("hupai_panel/huapai_bg"):GetComponent("UISprite").alpha==1 then
			target.transform:FindChild("hupai_panel/huapai_bg"):GetComponent("UISprite").alpha=0;
		end
		local mubiaoTarget=self.ownoutCardsParent.transform:FindChild("Sprite_"..chupaicount).gameObject;
		
		local leixing={};
		leixing[0]=target;
		leixing[1]=mubiaoTarget.transform.localPosition.x;
		leixing[2]=mubiaoTarget.transform.localPosition.y;
		leixing[3]=0.1;
		leixing[4]=chupaicount;
		leixing[5]=dengdaiUid;
		--log("路径");
		local paths={};
		paths[1]=target.transform.position;
		paths[2]=Vector3.New(target.transform.position.x,mubiaoTarget.transform.position.y+0.16,0);
		paths[3]=Vector3.New(((mubiaoTarget.transform.position.x+0.08)+target.transform.position.x)/2,mubiaoTarget.transform.position.y+0.2,0);
		paths[4]=Vector3.New(mubiaoTarget.transform.position.x+0.12,mubiaoTarget.transform.position.y+0.16,0);
		--[[
		iTween.MoveTo(target,GameKSQZMJ.mono:iTweenHashLua("position",paths[1],"time", 0.04,"islocal", false,"easeType", iTween.EaseType.linear));
		iTween.MoveTo(target,GameKSQZMJ.mono:iTweenHashLua("position",paths[2],"time", 0.04,"delay",0.04,"islocal", false,"easeType", iTween.EaseType.linear));
		iTween.MoveTo(target,GameKSQZMJ.mono:iTweenHashLua("position",paths[3],"time", 0.04,"delay",0.08,"islocal", false,"easeType", iTween.EaseType.linear));
		iTween.MoveTo(target,GameKSQZMJ.mono:iTweenHashLua("position",paths[4],"time", 0.04,"delay",0.12,"islocal", false,"easeType", iTween.EaseType.linear,"oncomplete", self.OwnPaiChange,"oncompleteparams",leixing,"oncompletetarget", self));
		]]
		
		--log("开始移动");
		--[[]]
		local pathse=Utils.Zhuanhuan(paths);
		iTween.MoveTo(target,GameKSQZMJ.mono:iTweenHashLua("path",pathse,"time", 0.15,"easeType", iTween.EaseType.linear,"oncomplete", self.OwnPaiChange,"oncompleteparams",leixing,"oncompletetarget", self));
		
		--log("是否停牌");
		--log(istingpai);
		if istingpai then
			self:tingPaiShow();
		end
	else
		local bottom_bg=target.transform:FindChild("bottom_bg"):GetComponent("UISprite");
		bottom_bg.spriteName="chupai_big";
		bottom_bg.width=58;
		bottom_bg.height=86;
		local bottom_Sprite=target.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
		bottom_Sprite.alpha=1;
		bottom_Sprite.transform.localScale=Vector3.New(0.64,0.64,0.64);
		bottom_Sprite.transform.localPosition=Vector3.New(0,11.5,0);
		local mubiaoTarget=self.otheroutCardsParent.transform:FindChild("Sprite_"..chupaicount).gameObject;
		target.transform.parent=self.otheroutCardsParent.transform;
		target.transform.localScale=Vector3.one;
		target.transform.localPosition=mubiaoTarget.transform.localPosition;
		
		if istingpai then
			self:tingPaiShow();
		end
		UISoundManager.Instance.PlaySound("chupai");
		self.biaoji.transform.localPosition=Vector3.New(mubiaoTarget.transform.localPosition.x,mubiaoTarget.transform.localPosition.y+25,0);
		self.biaoji:SetActive(true);
		if not IsNil(player) then
			GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..dengdaiUid):HideBiaoji();
		end
		
		local leixing={};
		leixing[0]=target;
		leixing[1]=false;
		self:HuiDiaoFunction(leixing);
	end
end

function this:HideBiaoji()
	self.biaoji:SetActive(false);
end

function this:ScaleChange(obj,timeC,x,y)
	iTween.ScaleTo(obj,GameKSQZMJ.mono:iTweenHashLua("x", x,"y",y,"time",timeC ,"easeType", iTween.EaseType.linear));
end

function this:SetOtherChupai(card,chupaiOtherCount,dengdaiUid,istingpai,zhuangtai,isCGP)
	if #(self.OtherSidePais[1])>0 then
		local chupai=self.OtherSidePais[1][#(self.OtherSidePais[1])];
		chupai.transform.localPosition=Vector3.New(chupai.transform.localPosition.x,chupai.transform.localPosition.y+30,0);
		self:getMahjong(chupai.name).paiid=card;
		self:getMahjong(chupai.name).paixuid=self:paiXuID(card);
		self:getMahjong(chupai.name).paixuindex=chupaiOtherCount;
		local child_1=chupai.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
		child_1.spriteName=self._cardPre..card;
		coroutine.wait(0.2);
		
		table.insert(self.OtherSidePais[3],chupai);
		iTableRemove(self.OtherSidePais[1],chupai);
		
		self.chilinshipai.spriteName=self._cardPre..card;
		self.chiLinShiTarget.gameObject:SetActive(true);
		coroutine.start(self.DaChupai,self,chupai,chupaiOtherCount,false,dengdaiUid,card,istingpai,false);
	end
end

function this:setMoPai(card,isown,ownmopaicount,istuoguan)
	self.MopaiIndex=self.MopaiIndex+1;
	self:HideBiaoji();
	local endPosition=Vector3.zero;
	if isown then
		if card~=0 then
			local out0=GameObject.Instantiate(self.thispaiSpritePrefab);
			out0:GetComponent("BoxCollider").enabled=false;
			out0.name=self.owncard..(ownmopaicount+self.createOwnCardCount);
			local shilipai=self:bindMahjong(out0.name,out0.gameObject,true);
			out0.transform.parent=self.thisHandPaiContainer.transform;
			out0.transform.localScale=Vector3.one;
			out0.transform.localPosition=self.fapai_targetPosition.localPosition;
			table.insert(self.OwnSidePais[1],out0.gameObject);
			local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
			
			--将要听牌的麻将牌的番数父物体放在tingpaiParent中
			local out_2=out_1.transform:FindChild("tingpai").gameObject;
			out_2.name=out0.name;
			out_2.transform.parent=self.tingpaiParent.transform;
			out_2.transform.localPosition=Vector3.zero;
			out_2.transform.localScale=Vector3.one;
			table.insert(self.OwnSidePais[4],out_2);
			
			out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..card;
			for i=0,#(self.huapaiIndex) do
				if card==self.huapaiIndex[i] then
					out0.transform:FindChild("huapai"):GetComponent("UISprite").alpha=1;
				end
			end
			
			if istuoguan then
				out_1.transform:FindChild("Sprite_1"):GetComponent("UISprite").alpha=0.2;
			end
			
			endPosition=Vector3.New((#(self.OwnSidePais[1])-1)*101+30+self.CGPMoveJuLi,0,0);
			
			self:getMahjong(out0.name).paiid=card;
			self:getMahjong(out0.name).paixuid=self:paiXuID(card);
			self:getMahjong(out0.name).paixuindex=#(self.OwnSidePais[1]);
			out0:GetComponent("UIPanel").depth=20+#(self.OwnSidePais[1]);
			self.ownLastNum=out0.gameObject;
			
			out0:GetComponent("BoxCollider").enabled=false;
			if self.isCPTing or self.ownAlreadyTing then
				self.JinZhiBox=true;
			else
				self.JinZhiBox=false;
			end
			
			self:FaPaiMove(out0,endPosition.x,endPosition.y,0.3,true,0,true,true);			
		end
	else
		self.createOtherCardCount=self.createOtherCardCount+1;
		local out0=GameObject.Instantiate(self.thatpaiSpritePrefab);
		out0.name=self.othercard..self.createOtherCardCount;
		local shilipai=self:bindMahjong(out0.name,out0.gameObject,false);
		
		out0.transform.parent=self.thatHandPaiContainer.transform;
		out0.transform.localScale=Vector3.one;
		out0.transform.localPosition=self.fapai_targetPosition.localPosition;
		
		
		local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
		
		
		endPosition=Vector3.New(-20,0,0);
		table.insert(self.OtherSidePais[1],out0.gameObject);
		self:FaPaiMove(out0,endPosition.x,endPosition.y,0,true,0,true,false);
	end
end

function this:setChiPai(chipaicards,otherUid,isown,fenzu,tingpai)
	self.HasCGP=true;
	local chipailist={};
	for i=1,#(chipaicards) do
		table.insert(chipailist,tonumber(chipaicards[i]));
	end
	self:paixu_shuzi(chipailist);
	
	if isown then--主玩家吃牌
		self.CGPMoveJuLi=220*fenzu;
		local player=GameObject.Find(self._nnPlayerName..otherUid);
		if not IsNil(player) then
			GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).chiLinShiTarget:SetActive(false);
		end
		--log("自己吃牌");
		for i=1,#(chipailist) do
			if chipailist[i]~=tonumber(chipaicards[3]) then
				for j=1,#(self.OwnSidePais[1]) do
					if self:getMahjong(self.OwnSidePais[1][j].name).paiid==chipailist[i] then
						self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
						table.insert(self.OwnSidePais[2],self.OwnSidePais[1][j]);
						self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
						self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).fenzu=fenzu;
						if self.OwnSidePais[2][#(self.OwnSidePais[2])]:GetComponent("BoxCollider") then
							self.OwnSidePais[2][#(self.OwnSidePais[2])]:GetComponent("BoxCollider").enabled=false;
						end
						self.OwnSidePais[2][#(self.OwnSidePais[2])].transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0;
						self:OwnCGPPaiChange(self.OwnSidePais[2][#(self.OwnSidePais[2])],true,false);
						iTableRemove(self.OwnSidePais[1],self.OwnSidePais[1][j]);
						break;
					end
				end
			else
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
				local wanjiadachupai=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).OtherSidePais[3];
				table.insert(self.OwnSidePais[2],wanjiadachupai[#(wanjiadachupai)]);
				iTableRemove(wanjiadachupai,wanjiadachupai[#(wanjiadachupai)]);
				--log("========自己吃牌========="..self.OwnSidePais[2][#(self.OwnSidePais[2])].name);
				local jiaoben=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name);
				--log(jiaoben.gameObject.name);
				self.shiliMahjong[self.OwnSidePais[2][#(self.OwnSidePais[2])].name]=jiaoben;
				
				self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
				self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).fenzu=fenzu;
				self:OwnCGPPaiChange(self.OwnSidePais[2][#(self.OwnSidePais[2])],false,false);
			end
		end
		--[[
		if tingpai==1 then
			self.isCPTing=true;
			for i=1,#(self.OwnSidePais[1]) do
				if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
				end
			end
		else
			self.isCPTing=false;
			for i=1,#(self.OwnSidePais[1]) do
				if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=true;
				end
			end
		end
		]]
		self.isCPTing=false;
		GameKSQZMJ.standupCardObj=nil;
		self:paixu_CGP(self.OwnSidePais[2]);
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):HideBiaoji();
		coroutine.start(self.OwnCGPMovePosition,self,false,0,0,1);
	else--其他玩家吃牌
		local player=GameObject.Find(self._nnPlayerName..otherUid);
		for i=#(chipailist),1,-1 do
			if chipailist[i]~=tonumber(chipaicards[3]) then
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
				self:getMahjong(self.OtherSidePais[1][#(self.OtherSidePais[1])].name).paiid=chipailist[i];
				self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=self._cardPre..chipailist[i];
				table.insert(self.OtherSidePais[2],self.OtherSidePais[1][#(self.OtherSidePais[1])]);
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).fenzu=fenzu;
				self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],true,false);
				iTableRemove(self.OtherSidePais[1],self.OtherSidePais[1][#(self.OtherSidePais[1])]);
			else
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
				local wanjiadachupai=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).OwnSidePais[3];
				table.insert(self.OtherSidePais[2],wanjiadachupai[#(wanjiadachupai)]);
				iTableRemove(wanjiadachupai,wanjiadachupai[#(wanjiadachupai)]);
				local jiaoben=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name);				
				self.shiliMahjong[self.OtherSidePais[2][#(self.OtherSidePais[2])].name]=jiaoben;
				--log(jiaoben.gameObject.name);
				--log("========别人吃牌========="..self.OtherSidePais[2][#(self.OtherSidePais[2])].name);
				
				if self.OtherSidePais[2][#(self.OtherSidePais[2])]:GetComponent("BoxCollider") then
					self.OtherSidePais[2][#(self.OtherSidePais[2])]:GetComponent("BoxCollider").enabled=false;
				end
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).fenzu=fenzu;
				self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],false,false);
			end
		end
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):HideBiaoji();
		self:OtherCGPMoveJuLi();
		self:paixu_CGP(self.OtherSidePais[2]);
		coroutine.start(self.OtherCGPMovePosition,self,false,1);
	end
end

function this:OtherCGPMoveJuLi()
	for i=1,#(self.OtherSidePais[1]) do
		self.OtherSidePais[1][i].transform.localPosition=Vector3.New(self.OtherSidePais[1][i].transform.localPosition.x,self.OtherSidePais[1][i].transform.localPosition.y,0);
	end
end

function this:OwnCGPMovePosition(isgangpai,bushoulipai,mopaicount,caozuocount)
	local chushifenzu=0;
	local chushiPosition=0;
	local addJuLi=0;
	for i=1,#(self.OwnSidePais[2]) do
		--log(self:getMahjong(self.OwnSidePais[2][i].name).paixuindex.."排序index");
		if i==1 then
			chushifenzu=self:getMahjong(self.OwnSidePais[2][i].name).fenzu;
			chushiPosition=self:getMahjong(self.OwnSidePais[2][i].name).paixuindex*70;
		else
			if self:getMahjong(self.OwnSidePais[2][i].name).fenzu~=chushifenzu then
				addJuLi=addJuLi+27;
				chushifenzu=self:getMahjong(self.OwnSidePais[2][i].name).fenzu;
			end
			chushiPosition=self:getMahjong(self.OwnSidePais[2][i].name).paixuindex*70+addJuLi;
		end
		
		self.OwnSidePais[2][i].transform.parent=self.ChiGangPengParent.transform;
		coroutine.start(self.ShowAndHide,self,self.OwnSidePais[2][i]);
		self.OwnSidePais[2][i].transform.localScale=Vector3.one;
		self.OwnSidePais[2][i].transform:FindChild("bottom_bg"):GetComponent("UISprite").depth=15+i;
		self.OwnSidePais[2][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").depth=16+i;
		if self.OwnSidePais[2][i].transform.localPosition.x~=chushiPosition then
			if self:getMahjong(self.OwnSidePais[2][i].name).isMingGang or self:getMahjong(self.OwnSidePais[2][i].name).isAnGang then
				self.OwnSidePais[2][i].transform.localPosition=Vector3.New(chushiPosition,27,0);
			else
				self.OwnSidePais[2][i].transform.localPosition=Vector3.New(chushiPosition,0,0);
			end			
		end
	end
	if isgangpai then
		coroutine.start(self.fuWeiShouLiPai,self,false,0.2,false);
		coroutine.wait(0.3);
		local istuoguan=GameKSQZMJ.istuoguan;
		local chupaicount=GameKSQZMJ.paicount;
		chupaicount=chupaicount-1;
		GameKSQZMJ.shengyucount.text=tostring(chupaicount);
		self:setMoPai(bushoulipai,true,mopaicount,istuoguan);
	else
		coroutine.start(self.fuWeiShouLiPai,self,false,0.2,true);
	end
end

function this:OtherCGPMovePosition(isgangpai,caozuocount)
	local chushifenzu=0;
	local chushiPosition=0;
	local addJuLi=0;
	for i=1,#(self.OtherSidePais[2]) do
		--log(self:getMahjong(self.OtherSidePais[2][i].name).paixuindex.."排序index");
		if i==1 then
			chushifenzu=self:getMahjong(self.OtherSidePais[2][i].name).fenzu;
			chushiPosition=60*self:getMahjong(self.OtherSidePais[2][i].name).paixuindex;
		else
			if self:getMahjong(self.OtherSidePais[2][i].name).fenzu~=chushifenzu then
				addJuLi=addJuLi+18;
				chushifenzu=self:getMahjong(self.OtherSidePais[2][i].name).fenzu;
			end
			chushiPosition=-60*self:getMahjong(self.OtherSidePais[2][i].name).paixuindex-addJuLi;
		end
		self.OtherSidePais[2][i].transform.parent=self.ChiGangPengParent.transform;
		coroutine.start(self.ShowAndHide,self,self.OtherSidePais[2][i]);
		self.OtherSidePais[2][i].transform.localScale=Vector3.one;
		self.OtherSidePais[2][i].transform:FindChild("bottom_bg"):GetComponent("UISprite").depth=15+i;
		self.OtherSidePais[2][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").depth=16+i;
		if self.OtherSidePais[2][i].transform.localPosition~=chushiPosition then
			if self:getMahjong(self.OtherSidePais[2][i].name).isAnGang or self:getMahjong(self.OtherSidePais[2][i].name).isMingGang then
				self.OtherSidePais[2][i].transform.localPosition=Vector3.New(chushiPosition,20,0);
			else
				self.OtherSidePais[2][i].transform.localPosition=Vector3.New(chushiPosition,0,0);
			end
		end
	end
	
	UISoundManager.Instance.PlaySound("huapai");
	if isgangpai then
		coroutine.wait(0.3);
		local chupaicount=GameKSQZMJ.paicount;
		chupaicount=chupaicount-1;
		GameKSQZMJ.shengyucount.text=tostring(chupaicount);
		self:setMoPai(0,false,0,false);
	else
		local leixing={};
		leixing[0]=nil;
		leixing[1]=false;
		self:HuiDiaoFunction(leixing);
	end
end

function this:ShowAndHide(target)
	target:SetActive(false);
	coroutine.wait(0.1);
	target:SetActive(true);
end

function this:OwnCGPPaiChange(target,isown,isAnGang)
	local child=target.transform:FindChild("bottom_bg"):GetComponent("UISprite");
	local child_1=target.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
	child.width=78;
	child.height=114;
	if isAnGang then
		child.spriteName="ownCGP_1";
		child_1.alpha=0;
	else
		child.spriteName="ownCGP_2";
		child_1.width=78;
		child_1.height=90;
		child_1.transform.localScale=Vector3.New(0.86,0.86,0.86);
		child_1.transform.localPosition=Vector3.New(-1,14.5,0);
	end
end

function this:OtherCGPPaiChange(target,isother,isAnGang)
	local child=target.transform:FindChild("bottom_bg"):GetComponent("UISprite");
	local child_1=target.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
	child.width=68;
	child.height=98;
	if isAnGang then
		child.spriteName="otherCGP_1";
		child_1.alpha=0;
	else
		child.spriteName="otherCGP_2";
		child_1.alpha=1;
		child_1.transform.localScale=Vector3.New(0.78,0.78,0.78);
		child_1.transform.localPosition=Vector3.New(-1.5,14.5,0);
	end
end


function this:Pengpai(pengpaiId,isown,otherUid,fenzu,tingpai)
	self.HasCGP=true;
	if isown then--如果是主玩家
		self.CGPMoveJuLi=220*fenzu;
		local pengcount=0;
		--先获得其他玩家打出的牌，添加到吃碰杠列表，给其大小进行重新赋值，然后再获得手中要碰的两张牌（只能获得两张），也加到吃碰杠列表，复位手里牌的同时，给这三张牌摆放位置
		local player=GameObject.Find(self._nnPlayerName..otherUid);
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).chiLinShiTarget:SetActive(false);
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):HideBiaoji();
		self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
		local wanjiadachupai=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).OtherSidePais[3];
		--log("碰牌名称");
		--log(wanjiadachupai[#(wanjiadachupai)].name);
		table.insert(self.OwnSidePais[2],wanjiadachupai[#(wanjiadachupai)]);
		iTableRemove(wanjiadachupai,wanjiadachupai[#(wanjiadachupai)]);
		--log(self.OwnSidePais[2][#(self.OwnSidePais[2])].name);

		local jiaoben=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name);	
		--log(jiaoben.gameObject.name);
		self.shiliMahjong[self.OwnSidePais[2][#(self.OwnSidePais[2])].name]=jiaoben;
		
		--log("========自己碰牌========="..self.OwnSidePais[2][#(self.OwnSidePais[2])].name);
		
		self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
		self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).fenzu=fenzu;
		self:OwnCGPPaiChange(self.OwnSidePais[2][#(self.OwnSidePais[2])],false,false);
		
		for i=#(self.OwnSidePais[1]),1,-1 do
			if self:getMahjong(self.OwnSidePais[1][i].name).paiid==pengpaiId then
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
				table.insert(self.OwnSidePais[2],self.OwnSidePais[1][i]);
				self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
				self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).fenzu=fenzu;
				self.OwnSidePais[2][#(self.OwnSidePais[2])].transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0;
				self:OwnCGPPaiChange(self.OwnSidePais[2][#(self.OwnSidePais[2])],true,false);
				
				if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
				end
				iTableRemove(self.OwnSidePais[1],self.OwnSidePais[1][i]);
				pengcount=pengcount+1;
				if pengcount==2 then
					break;
				end
			end
		end
		--[[
		if tingpai==1 then
			self.isCPTing=true;
			--for i=1,#(self.OwnSidePais[1]) do
				--if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					--self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
				--end
			--end
		else
			self.isCPTing=false;
			
		end
		]]
		self.isCPTing=false;
		for i=1,#(self.OwnSidePais[1]) do
				if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=true;
				end
			end
		GameKSQZMJ.standupCardObj=nil;
		self:paixu_CGP(self.OwnSidePais[2]);
		coroutine.start(self.OwnCGPMovePosition,self,false,0,0,2);
	else
		local player=GameObject.Find(self._nnPlayerName..otherUid);
		self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
		local wanjiadachupai=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).OwnSidePais[3];
		table.insert(self.OtherSidePais[2],wanjiadachupai[#(wanjiadachupai)]);
		local jiaoben=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name);
		iTableRemove(wanjiadachupai,wanjiadachupai[#(wanjiadachupai)]);
		self.shiliMahjong[self.OtherSidePais[2][#(self.OtherSidePais[2])].name]=jiaoben;
		--log(jiaoben.gameObject.name);
		--log("========别人碰牌========="..self.OtherSidePais[2][#(self.OtherSidePais[2])].name);
		
		self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
		self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).fenzu=fenzu;
		self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],false,false);
		
		local pengcount=0;
		--log(#(self.OtherSidePais[1]).."别人手里牌数量");
		for i=#(self.OtherSidePais[1]),1,-1 do
			self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
			self:getMahjong(self.OtherSidePais[1][i].name).paiid=pengpaiId;
			self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=self._cardPre..pengpaiId;
			table.insert(self.OtherSidePais[2],self.OtherSidePais[1][i]);
			self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
			self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).fenzu=fenzu;
			self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],true,false);
			iTableRemove(self.OtherSidePais[1],self.OtherSidePais[1][i]);
			pengcount=pengcount+1;
			if pengcount==2 then
				break;
			end
		end
		self:paixu_CGP(self.OtherSidePais[2]);
		self:OtherCGPMoveJuLi();
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):HideBiaoji();
		coroutine.start(self.OtherCGPMovePosition,self,false,2);
	end
end

function this:Gangpai(gangpaiId,gangpaiType,isown,otherUid,fenzu,bushoulipai,mopaicount,isHT)
	self.HasCGP=true;
	local gangpaiSoundIndex=0;
	if gangpaiType==2 then--如果是暗杠
		gangpaiSoundIndex=5;
	elseif gangpaiType==1 or gangpaiType==3 then--碰后杠  明杠
		gangpaiSoundIndex=3;
	end
	
	if isown then
		if gangpaiType==2 or gangpaiType==3 then
			self.CGPMoveJuLi=220*fenzu;
		end
		local player=GameObject.Find(self._nnPlayerName..otherUid);
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).chiLinShiTarget:SetActive(false);
		--如果是杠别人的牌，先获得其他玩家打出的牌，然后将其加入到吃碰杠的列表，给其大小进行重新赋值
		if gangpaiType==3 then
			GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):HideBiaoji();
			self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
			local wanjiadachupai=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).OtherSidePais[3];
			table.insert(self.OwnSidePais[2],wanjiadachupai[#(wanjiadachupai)]);
			iTableRemove(wanjiadachupai,wanjiadachupai[#(wanjiadachupai)]);
			local jiaoben=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name);	
			self.shiliMahjong[self.OwnSidePais[2][#(self.OwnSidePais[2])].name]=jiaoben;
			--log(jiaoben.gameObject.name);
			--log("========自己杠牌========="..self.OwnSidePais[2][#(self.OwnSidePais[2])].name);
			
			self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
			self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).fenzu=fenzu;
			self:OwnCGPPaiChange(self.OwnSidePais[2][#(self.OwnSidePais[2])],false,false);
		end
		--先获得手里要杠的牌，一张，三张或者四张
		local angangpai=0;
		for i=#(self.OwnSidePais[1]),1,-1 do
			if self:getMahjong(self.OwnSidePais[1][i].name).paiid==gangpaiId then
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
				if self.OwnSidePais[1][i]==self.ownLastNum then
					self.ownLastNum=nil;
				end
				angangpai=angangpai+1;
				
				table.insert(self.OwnSidePais[2],self.OwnSidePais[1][i]);
				self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
				self.OwnSidePais[2][#(self.OwnSidePais[2])].transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0;
				if gangpaiType==2 or gangpaiType==3 then
					self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).fenzu=fenzu;
				end
				if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
				end
				iTableRemove(self.OwnSidePais[1],self.OwnSidePais[1][i]);
				
				if gangpaiType==2 then
					if angangpai==1 or angangpai==2 or angangpai==3 then
						self:OwnCGPPaiChange(self.OwnSidePais[2][#(self.OwnSidePais[2])],true,true);
					else
						self:OwnCGPPaiChange(self.OwnSidePais[2][#(self.OwnSidePais[2])],true,false);
					end
				else
					self:OwnCGPPaiChange(self.OwnSidePais[2][#(self.OwnSidePais[2])],true,false);
				end
			end
		end
		
		local index=10;
		--找到碰过的牌里面此时需要杠的牌的最小排序index
		for i=1,#(self.OwnSidePais[2]) do
			if self:getMahjong(self.OwnSidePais[2][i].name).paiid==gangpaiId then
				if self:getMahjong(self.OwnSidePais[2][i].name).paixuindex<index then
					index=self:getMahjong(self.OwnSidePais[2][i].name).paixuindex;
				end
				self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).fenzu=self:getMahjong(self.OwnSidePais[2][i].name).fenzu;
			end
		end
		self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).paixuindex=index+1;
		self.OwnSidePais[2][#(self.OwnSidePais[2])]:GetComponent("UIPanel").depth=27;
		self.CGPPaiXuIndex=self.CGPPaiXuIndex-1;
		if gangpaiType==2 then
			self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).isAnGang=true;
		else
			self:getMahjong(self.OwnSidePais[2][#(self.OwnSidePais[2])].name).isMingGang=true;
		end
	
		GameKSQZMJ.standupCardObj=nil;
		if isHT then
			self.isCPTing=true;
			for i=1,#(self.OwnSidePais[1]) do 
				if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
				end
			end
		else
			self.isCPTing=false;
			for i=1,#(self.OwnSidePais[1]) do 
				if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
					self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=true;
				end
			end
		end
		self:paixu_CGP(self.OwnSidePais[2]);
		coroutine.start(self.OwnCGPMovePosition,self,true,bushoulipai,mopaicount,gangpaiSoundIndex);
	else
		if gangpaiType==2 or gangpaiType==3 then
		
		end
		
		local player=GameObject.Find(self._nnPlayerName..otherUid);
		if gangpaiType==3 then--如果是杠别人的牌，先获得其他玩家打出的牌，然后将其加入到吃碰杠的列表，给其大小进行重新赋值
			GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):HideBiaoji();
			self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
			local wanjiadachupai=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid).OwnSidePais[3];
			table.insert(self.OtherSidePais[2],wanjiadachupai[#(wanjiadachupai)]);
			iTableRemove(wanjiadachupai,wanjiadachupai[#(wanjiadachupai)]);
			local jiaoben=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..otherUid):getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name);	
			self.shiliMahjong[self.OtherSidePais[2][#(self.OtherSidePais[2])].name]=jiaoben;
			--log(jiaoben.gameObject.name);
			--log("========别人杠牌========="..self.OtherSidePais[2][#(self.OtherSidePais[2])].name);
			
			self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
			self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).fenzu=fenzu;
			self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],false,false);
			local gangpaicount=0;
			for i=#(self.OtherSidePais[1]),1,-1 do
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
				gangpaicount=gangpaicount+1;
				table.insert(self.OtherSidePais[2],self.OtherSidePais[1][i]);
				self:getMahjong(self.OtherSidePais[1][i].name).paiid=gangpaiId;
				self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=self._cardPre..gangpaiId;
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).fenzu=fenzu;
				self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],true,false);
				iTableRemove(self.OtherSidePais[1],self.OtherSidePais[1][i]);
				if gangpaicount==3 then
					break;
				end
			end
		end
		if gangpaiType==2 then--如果是暗杠，先获得手中的四张杠牌，前三张明，最后一张暗牌，各自规定位置
			local angangpai=0;
			for i=#(self.OtherSidePais[1]),1,-1 do
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;				
				table.insert(self.OtherSidePais[2],self.OtherSidePais[1][i]);
				self:getMahjong(self.OtherSidePais[1][i].name).paiid=gangpaiId;
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex=self.CGPPaiXuIndex;
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).fenzu=fenzu;
				angangpai=angangpai+1;
				if angangpai==1 or angangpai==2 or angangpai==3 then
					self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],true,true);
				else
					self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=self._cardPre..gangpaiId;
					self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],true,false);
				end
				iTableRemove(self.OtherSidePais[1],self.OtherSidePais[1][i]);			
				if angangpai==4 then
					break;
				end
			end
		end
		if gangpaiType==1 then--如果是碰后杠
			self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;	
			table.insert(self.OtherSidePais[2],self.OtherSidePais[1][#(self.OtherSidePais[1])]);
			self:getMahjong(self.OtherSidePais[1][#(self.OtherSidePais[1])].name).paiid=gangpaiId;
			self:getMahjong(self.OtherSidePais[1][#(self.OtherSidePais[1])].name).paixuindex=self.CGPPaiXuIndex;
			self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=self._cardPre..gangpaiId;
			self:OtherCGPPaiChange(self.OtherSidePais[2][#(self.OtherSidePais[2])],true,false);
			iTableRemove(self.OtherSidePais[1],self.OtherSidePais[1][#(self.OtherSidePais[1])]);		
		end
		local index=10;
		for i=1,#(self.OtherSidePais[2]) do
			if self:getMahjong(self.OtherSidePais[2][i].name).paiid==gangpaiId then
				if self:getMahjong(self.OtherSidePais[2][i].name).paixuindex<index then
					index=self:getMahjong(self.OtherSidePais[2][i].name).paixuindex;
				end
				self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).fenzu=self:getMahjong(self.OtherSidePais[2][i].name).fenzu;
			end
		end
		
		--log(index.."=======index");
		--log(#(self.OtherSidePais[2]));
		--log(self.OtherSidePais[2][#(self.OtherSidePais[2])].name);
		--log(self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex);
		self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).paixuindex=index+1;
		self.OtherSidePais[2][#(self.OtherSidePais[2])]:GetComponent("UIPanel").depth=27;
		self.CGPPaiXuIndex=self.CGPPaiXuIndex-1;
		if gangpaiType==2 then
			self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).isAnGang=true;
		else
			self:getMahjong(self.OtherSidePais[2][#(self.OtherSidePais[2])].name).isMingGang=true;
		end
		
		self:paixu_CGP(self.OtherSidePais[2]);
		self:OtherCGPMoveJuLi();
		coroutine.start(self.OtherCGPMovePosition,self,true,gangpaiSoundIndex);
	end
end

function this:setTingPai(tingpaiList)
	--log("听牌消息");
	--printf(tingpaiList);
	--log(#(tingpaiList));
	for i=1,#(self.OwnSidePais[1]) do
		local isBlack=false;
		for j=1,#(tingpaiList) do
			local tingpaiId=tonumber(tingpaiList[j][1]);
			local tingpaicards=tingpaiList[j][2];
			if self:getMahjong(self.OwnSidePais[1][i].name).paiid==tingpaiId then
				isBlack=false;
				self:getMahjong(self.OwnSidePais[1][i].name):setTingpaiList(tingpaicards);
				self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=true;
				break;
			else
				isBlack=true;
			end
		end
		if isBlack then
			self:TingPaiChangeColor(self.OwnSidePais[1][i],true);
		end
	end
end

function this:HuanYuanTingpaiMessage()
	for i=1,#(self.OwnSidePais[1]) do
		self.OwnSidePais[1][i].transform:FindChild("bottom_bg/Sprite_logo"):GetComponent("UISprite").alpha=0;
		
		if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
			if self.isCPTing then
				self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=false;
			else
				self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=true;
			end
		end
		
		local index=self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1;
		if #(self.OwnSidePais[1])%3==2 then
			if i<#(self.OwnSidePais[1]) then
				self.OwnSidePais[1][i].transform.localPosition=Vector3.New(index*101+self.CGPMoveJuLi,0,0);
			else
				self.OwnSidePais[1][i].transform.localPosition=Vector3.New(index*101+30+self.CGPMoveJuLi,0,0);
			end
		elseif #(self.OwnSidePais[1])%3==1 then
			self.OwnSidePais[1][i].transform.localPosition=Vector3.New(index*101+self.CGPMoveJuLi,0,0);
		end
		self.OwnSidePais[1][i].transform.localScale=Vector3.one;
		self.OwnSidePais[1][i].transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0;
	end
	GameKSQZMJ.standupCardObj=nil;
	
	for i=1,#(self.OwnSidePais[4]) do
		self.OwnSidePais[4][i]:GetComponent("UISprite").alpha=0;
	end
end

function this:ClearFanshu(isOver)
	local spriteChild = self.tingpaiParent:GetComponentsInChildren(Type.GetType("UISprite",true));
	if isOver then
		for i=0,spriteChild.Length-1 do
			destroy(spriteChild[i].gameObject);
		end
	else
		for i=0,spriteChild.Length-1 do
			if spriteChild[i].name=="fanshu(Clone)" then
				destroy(spriteChild[i].gameObject);
			else
				spriteChild[i]:GetComponent("UISprite").alpha=0;
			end
		end
	end
end

function this:tuoGuanChangeColor(istuoguan)
	if istuoguan then
		for i=1,#(self.OwnSidePais[1]) do
			self:TingPaiChangeColor(self.OwnSidePais[1][i],true);
		end
	else
		for i=1,#(self.OwnSidePais[1]) do
			self:TingPaiChangeColor(self.OwnSidePais[1][i],false);
		end
	end
end

function this:TingPaiChangeColor(obj,istuoguan)
	if istuoguan then
		obj.transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0.2;
		if obj:GetComponent("BoxCollider") then
			obj:GetComponent("BoxCollider").enabled=false;
		end
		obj.transform:FindChild("bottom_bg/Sprite_logo"):GetComponent("UISprite").alpha=0;
	else
		obj.transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite").alpha=0;
		if obj:GetComponent("BoxCollider") then
			obj:GetComponent("BoxCollider").enabled=true;
		end
	end
end

function this:ChongZhiTingPaiChild()
	coroutine.wait(0.2);
	for i=1,#(self.OwnSidePais[1]) do
		local tingpai=self.OwnSidePais[1][i].transform:FindChild("bottom_bg/"..OwnSidePais[1][i].name);
		tingpai.parent=self.tingpaiParent.transform;
		tingpai.transform.localPosition=Vector3.zero;
		tingpai.transform.localScale=Vector3.one;
		table.insert(self.OwnSidePais[4],tingpai.gameObject);
	end
end

function this:qiehuanTingpaiMessage(name)
	for i=1,#(self.OwnSidePais[4]) do
		if self.OwnSidePais[4][i].name==name then
			self.OwnSidePais[4][i]:GetComponent("UISprite").alpha=1;
			self.OwnSidePais[4][i].transform:FindChild("jiantou"):GetComponent("UISprite").alpha=1;
			self.OwnSidePais[4][i].transform:FindChild("biaoqian"):GetComponent("UISprite").alpha=1;
			self.OwnSidePais[4][i].transform:FindChild("biaoqian/hupaitishi"):GetComponent("UISprite").alpha=1;
		else
			self.OwnSidePais[4][i]:GetComponent("UISprite").alpha=0;
		end
	end
end


function this:tingPaiShow()
	--log(self.MopaiIndex);
	--log(self.HasCGP);
	--log(self.trueTianting);
	if self.MopaiIndex==1 and not self.HasCGP then
		--log("进入天听状态");
		self.trueTianting=true;
	end
	--log("是否天听");
	--log(self.trueTianting);
	if self.trueTianting then
		self.tingpai.spriteName="tingpai_1";
		GameKSQZMJ.tiantingAnima.enabled=true;
		GameKSQZMJ.tiantingAnima:CrossFade("tianting",0);
	else
		self.tingpai.spriteName="tingpai";
		self.ting.enabled=true;
		self.ting:CrossFade("ting_effect",0);	
	end
	UISoundManager.Instance.PlaySound("tileclick");
	self.tingpai.gameObject:SetActive(true);
	coroutine.start(self.PlayAnima,self,false,0,true,false,false);
	self:HideLogo();
end

function this:ShiliHuaZaPai(canshu)

end


		

function this.UpClipRegion(self,from,uipanel,addCount) 
	local positionY=from;
	local movePosition=-46*addCount+positionY;
	while self.gameObject do
		uipanel.baseClipRegion = Vector4.New(-62, from, 468, 132);
		from =  from - 9;
		if self.gameObject == nil then return; end
		if from < movePosition then
			uipanel.baseClipRegion = Vector4.New(-62, movePosition, 468, 132);
			return;
		end
		coroutine.wait(0.05);
	end
end
function this:ClipCenter(obj)

	local per = tonumber(obj);
	self.ScrollView.gameObject:GetComponent("UIPanel").baseClipRegion = Vector4.New(-62, per, 468, 132);
end

function this:setJiesuan(message,score,isown,cards,isZimo,isBanker)
	local isown=isown;
	--log("结算==========");
	--log(isown);
	if isown then
		local haveHuaPai=false;
		self.zidongmodapai.gameObject:SetActive(false);
		local zongfanshu=tonumber(message[3]);
		self.jiesuanmessage:SetActive(true);
		for i=1,10 do
			self.jiesuanFanshuList[i]:SetActive(true);
			self.jiesuanFanshuList[i].transform.localPosition=Vector3.New(-500,-46*(i-1),0);
		end
		self.jiesuanmessage.transform:FindChild("difen_1"):GetComponent("UILabel").text=GameKSQZMJ.jishu_endnum.text;
		--log(score.."==============");
		if score>0 then
			--log(score.."++++++++++++++");
			--self.win_fanshu.text=tostring(zongfanshu);
			self.win_fanshu.text="+"..tostring(score);
			self.win_parent:SetActive(true);
			self.lose_parent:SetActive(false);
			--self.zongjicount_win:play(tonumber(score));
		else
			--log(score.."---------------");
			--self.lose_fanshu.text=tostring(zongfanshu);
			self.lose_fanshu.text=tostring(score);
			self.win_parent:SetActive(false);
			self.lose_parent:SetActive(true);
			--self.zongjicount_lose:play(tonumber(score));
		end
		self.hupaiId=tonumber(message[2]);
		coroutine.wait(0.1);
		self.fanshuPrefabParent.enabled=false;
		local fanshuZongJi=message[5];
		local fanshucount=0;
		for i=1,#(fanshuZongJi) do		
			local mahjongtype=tonumber(fanshuZongJi[i][1]);
			local fanshu=tonumber(fanshuZongJi[i][2]);
			if mahjongtype~=25 then
				fanshucount=fanshucount+1;
				--log(fanshucount.."========总共几个翻数");
				--self.jiesuanFanshuList[fanshucount]:SetActive(true);
				self.jiesuanFanshuList[fanshucount]:GetComponent("BoxCollider").enabled=false;
				self.jiesuanFanshuList[fanshucount].transform:FindChild("mahjongtype"):GetComponent("UILabel").text=this.mahjongTypeList[mahjongtype];
				self.jiesuanFanshuList[fanshucount].transform:FindChild("fanshu"):GetComponent("UILabel").text=tostring(fanshu).."a";
				self.jiesuanFanshuList[fanshucount].transform:FindChild("fanshu_2"):GetComponent("UILabel").text=GameKSQZMJ.jishu_endnum.text;
				iTween.MoveTo(self.jiesuanFanshuList[fanshucount],iTween.Hash("x",0,"islocal",true, "time",0.5,"delay", (fanshucount-1)*0.5));
				if fanshucount>3 then		
					coroutine.start(self.AfterDoing,self,(fanshucount-1)*0.5,function()
						self.ScrollView.gameObject.transform.localPosition=Vector3.New(self.ScrollView.gameObject.transform.localPosition.x,self.ScrollView.gameObject.transform.localPosition.y+46,0);
						self.ScrollView.gameObject:GetComponent("UIPanel").baseClipRegion = Vector4.New(-62, -34-46*(fanshucount-3), 468, 132);
					end)
				end
				--[[
				if fanshucount>3 then
					iTween.MoveTo(self.ScrollView.gameObject,iTween.Hash("y",self.ScrollView.gameObject.transform.localPosition.y+(fanshucount-3)*46,"islocal",true, "time",0.5,"delay", (fanshucount-1)*0.5));	
					local uipanel=self.ScrollView.gameObject:GetComponent("UIPanel");
					--coroutine.wait((fanshucount-1)*0.5);
					coroutine.start(self.AfterDoing,self,(fanshucount-1)*0.5,function()
						coroutine.start(self.UpClipRegion,self,uipanel.baseClipRegion.y,uipanel,fanshucount-3);
					end)		
				end
				]]


				--[[
				local fanshuprefab=GameObject.Instantiate(self.fanshu_prefab);
				table.insert(self.fanshuList,fanshuprefab);
				--log(#(self.fanshuPrefabParent));
				--log(math.floor((i-1)/2).."=============i/2");
				--log((i-1)%2);
				fanshuprefab.transform.parent=self.fanshuPrefabParent[math.floor((i-1)/2)+1].transform;
				fanshuprefab.transform.localScale=Vector3.one;
				if (i-1)%2==0 then
					fanshuprefab.transform.localPosition=Vector3.New(-140,0,0);
				else
					fanshuprefab.transform.localPosition=Vector3.New(140,0,0);
				end
				fanshuprefab.transform:FindChild("mahjongtype"):GetComponent("UISprite").spriteName="mahjongtype_"..mahjongtype;
				fanshuprefab.transform:FindChild("fanshu"):GetComponent("UILabel").text=tostring(fanshu).."a";
				]]
			else
				haveHuaPai=true;
				--self.jiesuanFanshuList[#(fanshuZongJi)]:SetActive(true);
				self.jiesuanFanshuList[#(fanshuZongJi)]:GetComponent("BoxCollider").enabled=false;
				self.jiesuanFanshuList[#(fanshuZongJi)].transform:FindChild("mahjongtype"):GetComponent("UILabel").text="奖励+"..fanshu.."番";
				self.jiesuanFanshuList[#(fanshuZongJi)].transform:FindChild("fanshu"):GetComponent("UILabel").text=tostring(fanshu).."a";
				self.jiesuanFanshuList[#(fanshuZongJi)].transform:FindChild("fanshu_2"):GetComponent("UILabel").text=GameKSQZMJ.jishu_endnum.text;
				iTween.MoveTo(self.jiesuanFanshuList[#(fanshuZongJi)],iTween.Hash("x",0,"islocal",true, "time",0.5,"delay", (#(fanshuZongJi)-1)*0.5));
				if #(fanshuZongJi)>3 then		
					coroutine.start(self.AfterDoing,self,(#(fanshuZongJi)-1)*0.5,function()
						self.ScrollView.gameObject.transform.localPosition=Vector3.New(self.ScrollView.gameObject.transform.localPosition.x,self.ScrollView.gameObject.transform.localPosition.y+46,0);
						self.ScrollView.gameObject:GetComponent("UIPanel").baseClipRegion = Vector4.New(-62, -34-46*(#(fanshuZongJi)-3), 468, 132);
					end)
				end
				--[[
				if #(fanshuZongJi)>3 then
					iTween.MoveTo(self.ScrollView.gameObject,iTween.Hash("y",self.ScrollView.gameObject.transform.localPosition.y+46,"islocal",true, "time",0.5,"delay", (#(fanshuZongJi)-1)*0.5));	
					local uipanel=self.ScrollView.gameObject:GetComponent("UIPanel");
					--coroutine.wait((#(fanshuZongJi)-3)*0.5);
					coroutine.start(self.AfterDoing,self,(#(fanshuZongJi)-1)*0.5,function()
						coroutine.start(self.UpClipRegion,self,uipanel.baseClipRegion.y,uipanel,#(fanshuZongJi)-3);
					end)	
				end
				]]
				--local fanshu=tonumber(fanshuZongJi[i][2]);
				--self.jiangli_1.text="奖励+"..fanshu.."番";
			end
		end
		--[[
		if #(fanshuZongJi)>3 then
			
			local uipanel=self.ScrollView.gameObject:GetComponent("UIPanel");
			--coroutine.wait((fanshucount-1)*0.5);
			coroutine.start(self.AfterDoing,self,(#(fanshuZongJi)-1)*0.5,function()
				iTween.MoveTo(self.ScrollView.gameObject,iTween.Hash("y",self.ScrollView.gameObject.transform.localPosition.y+(#(fanshuZongJi)-3)*46,"islocal",true, "time",(#(fanshuZongJi)-3)*0.5));	
				coroutine.start(self.UpClipRegion,self,uipanel.baseClipRegion.y,uipanel,#(fanshuZongJi)-3);
			end)		
		end
		]]
		if haveHuaPai then
			--self.jiangli_1.gameObject:SetActive(true);
			--self.jiangli_2.gameObject:SetActive(false);
		else
			--self.jiangli_1.gameObject:SetActive(false);
			--self.jiangli_2.gameObject:SetActive(true);
		end	
		coroutine.start(self.AfterDoing,self,#(fanshuZongJi)*0.5,function()
				for i=1,#(fanshuZongJi) do
					self.jiesuanFanshuList[i]:GetComponent("BoxCollider").enabled=true;
				end	
		end)
		
		for i=(#(fanshuZongJi)+1),#(self.jiesuanFanshuList) do	
			--self.jiesuanFanshuList[i].transform.localPosition.x=-500;
			self.jiesuanFanshuList[i]:SetActive(false);
		end
		--self.fanshuPrefabParent.enabled=true;
		--self.ScrollView:ResetPosition();
	else
		self.hupaiId=tonumber(message[2]);
		local otherCardCount=#(self.OtherSidePais[1]);
		--log(otherCardCount.."=======otherCardCount");
		if isZimo then
			otherCardCount=otherCardCount-1;
			for i=1,#(cards) do
				if self.hupaiId==tonumber(cards) then
					iTableRemove(cards,cards[i]);
					break;
				end
			end
			self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=self._cardPre..self.hupaiId;	
		end
		for i=1,otherCardCount do
			self.OtherSidePais[1][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").spriteName=self._cardPre..tonumber(cards[i]);
		end
		for i=1,#(self.OtherSidePais[1]) do
			local bottom_sprite=self.OtherSidePais[1][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
			bottom_sprite.alpha=1;
			self.OtherSidePais[1][i].transform:FindChild("bottom_bg"):GetComponent("UISprite").spriteName="otherCGP_2";
			bottom_sprite.transform.localPosition=Vector3.New(-1.5,14.5,0);
			bottom_sprite.transform.localScale=Vector3.New(0.78,0.78,0.78);
		end
	end
end

function this:chongzhi()
	if #(self.fanshuList)>0 then
		for i=1,#(self.fanshuList) do
			destroy(self.fanshuList[i]);
		end
		self.fanshuList={};
	end
end


--对方打出的牌，自己可以吃碰杠的时候，把对方打出的牌放在主玩家的跟前，便于操作
function this:SetOwnChiPai(card,chupaiOtherCount,dengdaiUid)
	--隐藏上一家的圆锥图标
	local player=GameObject.Find(self._nnPlayerName..dengdaiUid);
	GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..dengdaiUid):HideBiaoji();
	--其他玩家打出牌的位置变化
	self.OtherSidePais[1][#(self.OtherSidePais[1])].transform.position=self.chiLinShiTarget.transform.position;
	self.chiLinShiTarget:SetActive(true);
	self.OtherSidePais[1][#(self.OtherSidePais[1])]:GetComponent("UIPanel").depth=28;
	self:getMahjong(self.OtherSidePais[1][#(self.OtherSidePais[1])].name).paiid=card;
	self:getMahjong(self.OtherSidePais[1][#(self.OtherSidePais[1])].name).paixuid=self:paiXuID(card);
	self:getMahjong(self.OtherSidePais[1][#(self.OtherSidePais[1])].name).paixuindex=chupaiOtherCount;
	local child=self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg"):GetComponent("UISprite");
	local child_1=self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
	child_1.spriteName=self._cardPre..card;
	child.spriteName="hupai";
	child.width=100;
	child.height=130;
	child_1.transform.eulerAngles=Vector3.zero;
	child_1.transform.localPosition=Vector3.zero;
	child_1.width=72;
	child_1.height=94;
	child_1.alpha=1;
end

--点击过牌的按钮之后，将对方的牌还回对方的牌池里面
function this:huanyuanPaiPosition(chupaiOtherCount)
	local child=self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg"):GetComponent("UISprite");
	local child_1=self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
	child.spriteName="chupai_big";
	child_1.transform.eulerAngles=Vector3.New(0,0,180);
	child_1.transform.localPosition=Vector3.New(-2,24,0);
	child_1.width=76;
	child_1.height=72;
	local mubiaoTarget=self.otheroutCardsParent.transform:FindChild("Sprite_"+chupaiOtherCount).gameObject;
	coroutine.wait(0.2);
	self:ScaleChange(self.OtherSidePais[1][#(self.OtherSidePais[1])],0.3,0.44,0.4308);
	self:ScaleChange(self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite").gameObject,0.3,1.2,1.1606);
	self:MoveToTarget(self.OtherSidePais[1][#(self.OtherSidePais[1])],mubiaoTarget.transform.position.x,mubiaoTarget.transform.position.y,0.3,false);
	table.insert(self.OtherSidePais[3],self.OtherSidePais[1][#(self.OtherSidePais[1])]);--其他玩家出的所有牌
	iTableRemove(self.OtherSidePais[1],self.OtherSidePais[1][#(self.OtherSidePais[1])]);
end

function this:DestroyTingpai()
	for i=1,#(self.OwnSidePais[1]) do
		local sprites=self.OwnSidePais[1][i].transform:FindChild("bottom_bg/"..self.OwnSidePais[1][i].name):GetComponentsInChildren(Type.GetType("UISprite",true));
		if #(sprites)>0 then
			for i=1,#(sprites) do
				if sprites[i].name=="fanshu(Clone)" then
					destroy(sprites[i].gameObject);
				end
			end
		end
	end
end

function this:ClearAllPrefab(isown)
	self:chongzhi();
	self.isCPTing=false;
	self.JinZhiBox=false;
	if isown then
		--log("清除自己");
		self.huapaiIndex={};
		for i=1,#(self.OwnSidePais[1]) do
			destroy(self.OwnSidePais[1][i]);
		end
		for i=1,#(self.OwnSidePais[2]) do
			destroy(self.OwnSidePais[2][i]);
		end
		for i=1,#(self.OwnSidePais[3]) do
			destroy(self.OwnSidePais[3][i]);
		end
		for i=1,#(self.OwnSidePais[4]) do
			destroy(self.OwnSidePais[4][i]);
		end
		self.ScrollView.gameObject:GetComponent("UIPanel").baseClipRegion = Vector4.New(-62, -34, 468, 140);
		self.ScrollView.gameObject.transform.localPosition=Vector3.New(62,62,0);
		self.ScrollView.gameObject:GetComponent("UIPanel").clipOffset=Vector2.New(0,0);
		if self.jiesuanmessage.activeSelf then
			self.jiesuanmessage:SetActive(false);
		end
		for i=1,#(self.jiesuanPrefabList) do
			destroy(self.jiesuanPrefabList[i]);
		end


		self.ownAlreadyTing=false;
		self.jiesuanPrefabList={};
		self.OwnSidePais[1]={};
		self.OwnSidePais[2]={};
		self.OwnSidePais[3]={};
		self.OwnSidePais[4]={};
		self.createOwnCardCount=0;
		--self.zimotarget.transform:FindChild("Sprite"):GetComponent("UISprite").alpha=0;
		self.jiangliPanel:SetActive(false);
		self.zidongmodapai.gameObject:SetActive(false);
		self:ClearFanshu(true);
	else
		--log("清除别人");
		for i=1,#(self.OtherSidePais[1]) do
			destroy(self.OtherSidePais[1][i]);
		end
		for i=1,#(self.OtherSidePais[2]) do
			destroy(self.OtherSidePais[2][i]);
		end
		for i=1,#(self.OtherSidePais[3]) do
			destroy(self.OtherSidePais[3][i]);
		end
		self.createOtherCardCount=0;
		self.OtherSidePais[1]={};
		self.OtherSidePais[2]={};
		self.OtherSidePais[3]={};
	end
	if self.biaoji.activeSelf then
		self.biaoji:SetActive(false);
	end
	if self.tingpai.gameObject.activeSelf then
		self.tingpai.gameObject:SetActive(false);
	end
	if self.bankerSprite.activeSelf then
		self.bankerSprite:SetActive(false);
	end
end

function this:HideLogo()
	for i=1,#(self.OwnSidePais[1]) do
		self.OwnSidePais[1][i].transform:FindChild("bottom_bg/Sprite_logo"):GetComponent("UISprite").alpha=0;
	end
	for i=1,#(self.OwnSidePais[3]) do
		self.OwnSidePais[3][i].transform:FindChild("bottom_bg/Sprite_logo"):GetComponent("UISprite").alpha=0;
	end
end

--手中牌不可点击
function this:HideBoxcollider(isHide)
	for i=1,#(self.OwnSidePais[1]) do
		if self.OwnSidePais[1][i]:GetComponent("BoxCollider") then
			self.OwnSidePais[1][i]:GetComponent("BoxCollider").enabled=isHide;
		end
	end
end

function this:PlayAnima(isCGPH,caozuocount,isTing,fangpao,zimo)
	local player=GameObject.Find(self._nnPlayerName..self.otherPlayerUid);
	--log("结算是否天胡");
	--log(self.trueTianhu);
	if self.trueTianhu then
		--UISoundManager.Instance.PlaySound("tianhuend");
		if self.sex==0 then
			UISoundManager.Instance.PlaySound("m_tianhu")
		else
			UISoundManager.Instance.PlaySound("w_tianhu")
		end
	else
		if isCGPH then
			if caozuocount==1 then
				self.cgp_head_sprite.spriteName="chi_head";
				self.cgp_headParent.enabled=true;
				self.cgp_headParent:CrossFade("cgp_head",0);
				local index=math.random(2);
				if self.sex==0 then
					UISoundManager.Instance.PlaySound("m_chi_"..index)
				else
					UISoundManager.Instance.PlaySound("w_chi_"..index)
				end
				coroutine.wait(1);
				GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..self.otherPlayerUid):SetPlayyinxiao(0);
			elseif caozuocount==2 then
				self.cgp_head_sprite.spriteName="peng_head";
				self.cgp_headParent.enabled=true;
				self.cgp_headParent:CrossFade("cgp_head",0);
				if self.sex==0 then
					UISoundManager.Instance.PlaySound("m_peng_0")
				else
					UISoundManager.Instance.PlaySound("w_peng_0")
				end
				coroutine.wait(1);
				GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..self.otherPlayerUid):SetPlayyinxiao(2);
			elseif caozuocount==3 or caozuocount==5 then
				self.cgp_head_sprite.spriteName="gang_head";
				self.cgp_headParent.enabled=true;
				self.cgp_headParent:CrossFade("cgp_head",0);
				local index=math.random(1);
				if self.sex==0 then
					UISoundManager.Instance.PlaySound("m_gang_"..index)
				else
					UISoundManager.Instance.PlaySound("w_gang_"..index)
				end
				coroutine.wait(1);
				GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..self.otherPlayerUid):SetPlayyinxiao(1);
			elseif caozuocount==4 then
				self.cgp_head_sprite.spriteName="hu_head";
				local index=math.random(1);
				if self.sex==0 then
					UISoundManager.Instance.PlaySound("m_fangpao_other_"..index)
				else
					UISoundManager.Instance.PlaySound("w_fangpao_other_"..index)
				end
				coroutine.wait(1);
				GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..self.otherPlayerUid):SetPlayyinxiao(3);
			end
		end
		if isTing then
			self.cgp_head_sprite.spriteName="ting_head";
			if self.trueTianting then
				if self.sex==0 then
					UISoundManager.Instance.PlaySound("m_tianting")
				else
					UISoundManager.Instance.PlaySound("w_tianting")
				end
				UISoundManager.Instance.PlaySound("tianting2")

				if self.gameObject.name==(self._nnPlayerName..EginUser.Instance.uid) then
					coroutine.wait(3);
					GameKSQZMJ.music.clip=GameKSQZMJ.bg_tingmusic;
					GameKSQZMJ.music:Play();
				end
			else
				if self.sex==0 then
					UISoundManager.Instance.PlaySound("m_ting")
				else
					UISoundManager.Instance.PlaySound("w_ting")
				end
				if self.gameObject.name==(self._nnPlayerName..EginUser.Instance.uid) then
					coroutine.wait(1.5);
					GameKSQZMJ.music.clip=GameKSQZMJ.bg_tingmusic;
					GameKSQZMJ.music:Play();
				end
			end
		end
		if fangpao then
		
		end
		if zimo then
			local index=math.random(1);
			if self.sex==0 then
				UISoundManager.Instance.PlaySound("m_zimo_"..index)
			else
				UISoundManager.Instance.PlaySound("w_zimo_"..index)
			end		
		end
	end
	
end

function this:SetTingpaiAnima(isOwn,chupaicount)
	if isOwn then
		self.OwnSidePais[3][#(self.OwnSidePais[3])].transform:FindChild("bottom_bg"):GetComponent("Animator").enabled=true;
		--local luolei=self.OwnSidePais[3][#(self.OwnSidePais[3])].transform:FindChild("luolei_parent").gameObject;
		--luolei:GetComponent("Animator").enabled=true;
		--luolei:GetComponent("Animator"):CrossFade("luolei",0);
	else
		self.OtherSidePais[3][#(self.OtherSidePais[3])].transform:FindChild("bottom_bg"):GetComponent("Animator").enabled=true;
		--local luolei=self.OtherSidePais[3][#(self.OtherSidePais[3])].transform:FindChild("luolei_parent").gameObject;
		--luolei:GetComponent("Animator").enabled=true;
		--luolei:GetComponent("Animator"):CrossFade("luolei",0);
	end
	UISoundManager.Instance.PlaySound("shandian")
end

function this:RemoveChild()
	iTableRemove(self.OtherSidePais[1],self.OtherSidePais[1][#(self.OtherSidePais[1])]);
end

function this:setMessage(index)
	--log(index.."语音index");
	self.message_prompt.gameObject:SetActive(true);
	local yuyin=XMLResource.Instance:Str("mahjonglanguage_"..(index-1));
	--local yuyin=XMLResource.Instance:Str("message_error_6");
	--log(yuyin);
	self.message_prompt.transform:FindChild("Label"):GetComponent("UILabel").text=yuyin;
	--self.message_prompt.transform:FindChild("Label"):GetComponent("UILabel").text=this.mahjongList[index];
	if self.sex==0 then
		
		UISoundManager.Instance.PlaySound("mchat_"..(index-1))
	else
		UISoundManager.Instance.PlaySound("wchat_"..(index-1))
	end
	coroutine.start(self.AfterDoing,self,2,function()
		self.message_prompt.transform:FindChild("Label"):GetComponent("UILabel").text="";	
		self.message_prompt.gameObject:SetActive(false);
	end)
end

function this:setEmotion(number)
	--log(number.."实例化的表情下标");
	local aa=GameObject.Instantiate(self.emotionPrefab[number]);
	--log("是实例化");
	aa.transform.parent=self.emotionParent.transform;
	aa.transform.localScale=Vector3.one;
	aa.transform.localPosition=Vector3.zero;
	if number==1 then
		aa.transform.localPosition=Vector3.New(-2,0,0);
	elseif number==2 then
		aa.transform.localPosition=Vector3.New(-7,0,0);
	elseif number==3 then
		aa.transform.localPosition=Vector3.New(-6,7,0);
	elseif number==4 then
		aa.transform.localPosition=Vector3.New(0,17,0);
	elseif number==5 then
		aa.transform.localPosition=Vector3.New(-4,10,0);
	elseif number==6 then
		aa.transform.localPosition=Vector3.New(0,15,0);
	elseif number==7 then
		aa.transform.localPosition=Vector3.New(-10,6,0);
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
		aa.transform.localPosition=Vector3.New(-10,3,0);
	elseif number==16 then
		aa.transform.localPosition=Vector3.New(0,18,0);
	elseif number==17 then
		aa.transform.localPosition=Vector3.New(-3,-3,0);
	elseif number==18 then
		aa.transform.localPosition=Vector3.New(-1,-27,0);
	elseif number==19 then
		aa.transform.localPosition=Vector3.New(0,0,0);
	elseif number==20 then
		aa.transform.localPosition=Vector3.New(0,17,0);
	elseif number==21 then
		aa.transform.localPosition=Vector3.New(-2,0,0);
	elseif number==22 then
		aa.transform.localPosition=Vector3.New(0,12,0);
	elseif number==23 then
		aa.transform.localPosition=Vector3.New(-4,6,0);
	elseif number==24 then
		aa.transform.localPosition=Vector3.New(11,19,0);
	elseif number==25 then
		aa.transform.localPosition=Vector3.New(-2,-4,0);
	elseif number==26 then
		aa.transform.localPosition=Vector3.New(21,7,0);
	elseif number==27 then
		aa.transform.localPosition=Vector3.New(-10,23,0);
	end
	coroutine.start(self.AfterDoing,self,1.25,function()
		destroy(aa);
	end)
end

function this:SetLateDaChuPai(outpai,uid)
	if tostring(uid)==EginUser.Instance.uid then
		for i=1,#(outpai) do
			local out0=GameObject.Instantiate(self.thispaiSpritePrefab);
			local shilipai=self:bindMahjong(out0.name,out0.gameObject,true);
			out0.transform.parent=self.thisHandPaiContainer.transform;
			local mubiaotarget=self.ownoutCardsParent.transform:FindChild("Sprite_"..i).gameObject;
			out0.transform.position=Vector3.New(mubiaotarget.transform.position.x,mubiaotarget.transform.position.y,0);
			out0.transform.localScale=Vector3.one;
			local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
			local out_2=out0.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
		
			out_1.spriteName="chupai_big";
			out_1.width=58;
			out_1.height=86;
			out_2.alpha=1;
			out_2.width=78;
			out_2.height=90;
			--log("自己打出牌");
			--log(out_2.width.."============"..out_2.height);
			out_2.transform.localScale=Vector3.New(0.64,0.64,0.64);
			out_2.transform.localPosition=Vector3.New(0,11.5,0);
			out_2.spriteName=self._cardPre..tonumber(outpai[i]);
			
					
			self:getMahjong(out0.name).paiid=tonumber(outpai[i]);
			self:getMahjong(out0.name).paixuid=self:paiXuID(tonumber(outpai[i]));
			out0:GetComponent("BoxCollider").enabled=false;
			
			if i<9 then
				out0:GetComponent("UIPanel").depth=15;
			elseif i>=9 and i<18 then
				out0:GetComponent("UIPanel").depth=16;
			else
				out0:GetComponent("UIPanel").depth=17;
			end
			table.insert(self.OwnSidePais[3],out0.gameObject);
		end
	else
		for i=1,#(outpai) do
			local out0=GameObject.Instantiate(self.thatpaiSpritePrefab);
			local shilipai=self:bindMahjong(out0.name,out0.gameObject,false);
			out0.transform.parent=self.thatHandPaiContainer.transform;
			local mubiaotarget=self.otheroutCardsParent.transform:FindChild("Sprite_"..i).gameObject;
			out0.transform.position=Vector3.New(mubiaotarget.transform.position.x,mubiaotarget.transform.position.y,0);
			out0.transform.localScale=Vector3.one;
			local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
			local out_2=out0.transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
			
			out_1.spriteName="chupai_big";
			out_1.width=58;
			out_1.height=86;
			out_2.alpha=1;
			out_2.transform.localScale=Vector3.New(0.64,0.64,0.64);
			out_2.transform.localPosition=Vector3.New(0,11.5,0);
			out_2.spriteName=self._cardPre..tonumber(outpai[i]);
			
			if i<9 then
				out0:GetComponent("UIPanel").depth=20;
			elseif i>=9 and i<18 then
				out0:GetComponent("UIPanel").depth=19;
			else
				out0:GetComponent("UIPanel").depth=18;
			end
			table.insert(self.OtherSidePais[3],out0.gameObject);
		end
	end
end

function this:SetLateShoulipai(shoulipai,istuoguan,tingpai,fenzuOwn,uid)
	self.canTiPai=true;
	self.otherPlayerUid=uid;
	self.CGPMoveJuLi=220*fenzuOwn;
	self.otherPlayerUid=GameKSQZMJ.otherUid;
	for i=1,#(shoulipai) do
		shoulipai[i]=self:paiXuID(shoulipai[i]);
		self.createOwnCardCount=self.createOwnCardCount+1;
		local out0=GameObject.Instantiate(self.thispaiSpritePrefab);
		out0.name=self.owncard..self.createOwnCardCount;
		local shilipai=self:bindMahjong(out0.name,out0.gameObject,true);
		out0.transform.parent=self.thisHandPaiContainer.transform;
		out0.transform.localScale=Vector3.one;

		if #(shoulipai)%3==1 then
			out0.transform.localPosition=Vector3.New((i-1)*101+self.CGPMoveJuLi,0,0);
		else
			if i<#(shoulipai) then
				out0.transform.localPosition=Vector3.New((i-1)*101+self.CGPMoveJuLi,0,0);
			else
				out0.transform.localPosition=Vector3.New((i-1)*101+30+self.CGPMoveJuLi,0,0);
			end
		end
		local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
		out_1.spriteName="stand_forward";
		
		--将要听牌的麻将牌的番数父物体放在tingpaiParent中
		local out_2=out_1.transform:FindChild("tingpai").gameObject;
		out_2.name=out0.name;
		out_2.transform.parent=self.tingpaiParent.transform;
		out_2.transform.localPosition=Vector3.zero;
		out_2.transform.localScale=Vector3.one;
		table.insert(self.OwnSidePais[4],out_2);
		
		out_1.transform:FindChild("Sprite"):GetComponent("UISprite").alpha=1;
		if istuoguan or tingpai then
			out_1.transform:FindChild("Sprite_1"):GetComponent("UISprite").alpha=0.2;
			out0:GetComponent("BoxCollider").enabled=false;
		end
		out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..shoulipai[i];
		
		out0:GetComponent("UIPanel").depth=20+i;
		table.insert(self.OwnSidePais[1],out0.gameObject);
		
		self:getMahjong(out0.name).paixuindex=i;
		self:getMahjong(out0.name).paiid=shoulipai[i];
		self:getMahjong(out0.name).paixuid=self:paiXuID(shoulipai[i]);
	end
end

function this:SetLateOtherShoulipai(count,otherUid)
	self.otherPlayerUid=otherUid;
	for i=1,count do
		self.createOtherCardCount=self.createOtherCardCount+1;
		local out0=GameObject.Instantiate(self.thatpaiSpritePrefab);
		out0.name=self.othercard..self.createOtherCardCount;
		local shilipai=self:bindMahjong(out0.name,out0.gameObject,false);
		out0.transform.parent=self.thatHandPaiContainer.transform;
		out0.transform.localScale=Vector3.one;
		out0.transform.localPosition=Vector3.New(i*60,0,0);
		local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
		out0:GetComponent("UIPanel").depth=20+i;	
		self:getMahjong(out0.name).paixuindex=i;
		table.insert(self.OtherSidePais[1],out0.gameObject);
	end
end

function this:SetLateCGPpai(isOwn,cgppai)
	local islast=false;
	for i=1,#(cgppai) do
		local cgpcard=cgppai[i][1];
		if i==#(cgppai) then
			islast=true;
		end
		self:ShilihuaSetLateCard(cgpcard,isOwn,islast,i);
	end
end

function this:ShilihuaSetLateCard(lateCard,isown,isLast,fenzu)
	local isLike=false;--三张牌是否相同     
	if #(lateCard)<4 then
		if tonumber(lateCard[1])==tonumber(lateCard[2]) then
			isLike=true;
		else
			isLike=false;
		end
		if isLike then--如果是碰的牌
			local cardvalue=tonumber(lateCard[1]);--牌的值
			if isown then--实例化麻将，并且将牌给合适的父物体，改变牌的大小以及Rotation,给其所悬挂脚本的分组和排序赋值
				for i=1,#(lateCard) do
					self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
					self.createOwnCardCount=self.createOwnCardCount+1;
					local out0=GameObject.Instantiate(self.thispaiSpritePrefab);
					out0.name=self.owncard..self.createOwnCardCount;
					local shilipai=self:bindMahjong(out0.name,out0.gameObject,true);
					out0.transform.parent=self.ChiGangPengParent.transform;
					out0.transform.localScale=Vector3.one;
					local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
					out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..cardvalue;
					
					self:OwnCGPPaiChange(out0,true,false);
					table.insert(self.OwnSidePais[2],out0);
					
					self:getMahjong(out0.name).paixuindex=self.CGPPaiXuIndex;
					self:getMahjong(out0.name).paiid=cardvalue;
					self:getMahjong(out0.name).fenzu=fenzu;
					out0:GetComponent("BoxCollider").enabled=false;					
				end
				self:LateOwnCGPMovePosition();
			else
				for i=1,#(lateCard) do
					self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
					self.createOtherCardCount=self.createOtherCardCount+1;
					local out0=GameObject.Instantiate(self.thatpaiSpritePrefab);
					out0.name=self.othercard..self.createOtherCardCount;
					local shilipai=self:bindMahjong(out0.name,out0.gameObject,false);
					out0.transform.parent=self.ChiGangPengParent.transform;
					out0.transform.localScale=Vector3.one;
					local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
					out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..cardvalue;
					out_1.transform:FindChild("Sprite"):GetComponent("UISprite").alpha=1;
					
					self:OtherCGPPaiChange(out0,true,false);
					table.insert(self.OtherSidePais[2],out0);
					self:getMahjong(out0.name).paixuindex=self.CGPPaiXuIndex;
					self:getMahjong(out0.name).paiid=cardvalue;
					self:getMahjong(out0.name).fenzu=fenzu;					
				end
				self:LateOtherCGPMovePosition();
			end
		else
			local chipailist={};
			for i=1,#(lateCard) do
				table.insert(chipailist,tonumber(lateCard[i]));
			end
			self:paixu_shuzi(chipailist);
			if isown then
				for i=1,#(chipailist) do
					self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
					self.createOwnCardCount=self.createOwnCardCount+1;
					local out0=GameObject.Instantiate(self.thispaiSpritePrefab);
					out0.name=self.owncard..self.createOwnCardCount;
					local shilipai=self:bindMahjong(out0.name,out0.gameObject,true);
					out0.transform.parent=self.ChiGangPengParent.transform;
					out0.transform.localScale=Vector3.one;
					local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
					out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..chipailist[i];
					
					self:OwnCGPPaiChange(out0,true,false);
					table.insert(self.OwnSidePais[2],out0);
					self:getMahjong(out0.name).paixuindex=self.CGPPaiXuIndex;
					self:getMahjong(out0.name).paiid=chipailist[i];
					self:getMahjong(out0.name).fenzu=fenzu;
					out0:GetComponent("BoxCollider").enabled=false;					
				end	
				self:LateOwnCGPMovePosition();	
			else
				for i=#(chipailist),1,-1 do
					self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
					self.createOtherCardCount=self.createOtherCardCount+1;
					local out0=GameObject.Instantiate(self.thatpaiSpritePrefab);
					out0.name=self.othercard..self.createOtherCardCount;
					local shilipai=self:bindMahjong(out0.name,out0.gameObject,false);
					out0.transform.parent=self.ChiGangPengParent.transform;
					out0.transform.localScale=Vector3.one;
					local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
					out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..chipailist[i];
					out_1.transform:FindChild("Sprite"):GetComponent("UISprite").alpha=1;
					
					self:OtherCGPPaiChange(out0,true,false);
					table.insert(self.OtherSidePais[2],out0);
					self:getMahjong(out0.name).paixuindex=self.CGPPaiXuIndex;
					self:getMahjong(out0.name).paiid=chipailist[i];
					self:getMahjong(out0.name).fenzu=fenzu;					
				end
				self:LateOtherCGPMovePosition();
			end
		end
	else
		local cardvalue=tonumber(lateCard[1]);
		if isown then
			for i=1,#(lateCard) do
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
				self.createOwnCardCount=self.createOwnCardCount+1;
				local out0=GameObject.Instantiate(self.thispaiSpritePrefab);
				out0.name=self.owncard..self.createOwnCardCount;
				local shilipai=self:bindMahjong(out0.name,out0.gameObject,true);
				out0.transform.parent=self.ChiGangPengParent.transform;
				out0.transform.localScale=Vector3.one;
				local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
				out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..cardvalue;
				
				self:OwnCGPPaiChange(out0,true,false);
				table.insert(self.OwnSidePais[2],out0);
				if i==#(lateCard) then
					self:getMahjong(out0.name).paixuindex=self.CGPPaiXuIndex-2;
					self:getMahjong(out0.name).isMingGang=true;
					self.OwnSidePais[2][#(self.OwnSidePais[2])]:GetComponent("UIPanel").depth=26;
					self.CGPPaiXuIndex=self.CGPPaiXuIndex-1;
				else
					self:getMahjong(out0.name).paixuindex=self.CGPPaiXuIndex;
				end	
				self:getMahjong(out0.name).paiid=cardvalue;
				self:getMahjong(out0.name).fenzu=fenzu;
				self:getMahjong(out0.name).enabled=false;			
			end
			self:LateOwnCGPMovePosition();
		else
			for i=1,#(lateCard) do
				self.CGPPaiXuIndex=self.CGPPaiXuIndex+1;
				self.createOtherCardCount=self.createOtherCardCount+1;
				local out0=GameObject.Instantiate(self.thatpaiSpritePrefab);
				out0.name=self.othercard..self.createOtherCardCount;
				local shilipai=self:bindMahjong(out0.name,out0.gameObject,false);
				out0.transform.parent=self.ChiGangPengParent.transform;
				out0.transform.localScale=Vector3.one;
				local out_1=out0.transform:FindChild("bottom_bg"):GetComponent("UISprite");
				out_1.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName=self._cardPre..cardvalue;
				out_1.transform:FindChild("Sprite"):GetComponent("UISprite").alpha=1;
					
				self:OtherCGPPaiChange(out0,true,false);
				table.insert(self.OtherSidePais[2],out0);
				if i==#(lateCard) then
					self:getMahjong(out0.name).paixuindex=self.CGPPaiXuIndex-2;
					self:getMahjong(out0.name).isMingGang=true;
					self.OtherSidePais[2][#(self.OtherSidePais[2])]:GetComponent("UIPanel").depth=11;
					self.CGPPaiXuIndex=self.CGPPaiXuIndex-1;
				else
					self:getMahjong(out0.name).paixuindex=self.CGPPaiXuIndex;
				end
				self:getMahjong(out0.name).paiid=cardvalue;
				self:getMahjong(out0.name).fenzu=fenzu;				
			end
			self:LateOtherCGPMovePosition();
		end
	end
end

function this:LateOwnCGPMovePosition()
	local chushifenzu=0;
	local chushiPosition=0;
	for i=1,#(self.OwnSidePais[2]) do
		if i==1 then
			chushifenzu=self:getMahjong(self.OwnSidePais[2][i].name).fenzu;
			chushiPosition=self:getMahjong(self.OwnSidePais[2][i].name).paixuindex*70;
		else
			if self:getMahjong(self.OwnSidePais[2][i].name).fenzu~=chushifenzu then
				chushifenzu=self:getMahjong(self.OwnSidePais[2][i].name).fenzu;
			end
			chushiPosition=self:getMahjong(self.OwnSidePais[2][i].name).paixuindex*70+(chushifenzu-1)*27;
		end
		self.OwnSidePais[2][i].transform.parent=self.ChiGangPengParent.transform;
		coroutine.start(self.ShowAndHide,self,self.OwnSidePais[2][i]);
		self.OwnSidePais[2][i].transform.localScale=Vector3.one;
		self.OwnSidePais[2][i].transform:FindChild("bottom_bg"):GetComponent("UISprite").depth=15+i;
		self.OwnSidePais[2][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").depth=16+i;
		if self.OwnSidePais[2][i].transform.localPosition.x~=chushiPosition then
			if self:getMahjong(self.OwnSidePais[2][i].name).isMingGang then
				self.OwnSidePais[2][i].transform.localPosition=Vector3.New(chushiPosition,27,0);
			else
				self.OwnSidePais[2][i].transform.localPosition=Vector3.New(chushiPosition,0,0);
			end
		end
	end	
end

function this:LateOtherCGPMovePosition()
	--log("11111111111111");
	local chushifenzu=0;
	local chushiPosition=0;
	for i=1,#(self.OtherSidePais[2]) do
		--log(self:getMahjong(self.OtherSidePais[2][i].name).paixuindex.."=========中途进入排序");
		if i==1 then
			chushifenzu=self:getMahjong(self.OtherSidePais[2][i].name).fenzu;
			chushiPosition=self:getMahjong(self.OtherSidePais[2][i].name).paixuindex*60;
		else
			if self:getMahjong(self.OtherSidePais[2][i].name).fenzu~=chushifenzu then
				chushifenzu=self:getMahjong(self.OtherSidePais[2][i].name).fenzu;
			end
			chushiPosition=-60*self:getMahjong(self.OtherSidePais[2][i].name).paixuindex-(chushifenzu-1)*18;
		end
		self.OtherSidePais[2][i].transform.parent=self.ChiGangPengParent.transform;
		coroutine.start(self.ShowAndHide,self,self.OtherSidePais[2][i]);
		self.OtherSidePais[2][i].transform.localScale=Vector3.one;
		self.OtherSidePais[2][i].transform:FindChild("bottom_bg"):GetComponent("UISprite").depth=15+i;
		self.OtherSidePais[2][i].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite").depth=16+i;
		if self.OtherSidePais[2][i].transform.localPosition.x~=chushiPosition then				
			if self:getMahjong(self.OtherSidePais[2][i].name).isMingGang then
				self.OtherSidePais[2][i].transform.localPosition=Vector3.New(chushiPosition,20,0);
			else
				self.OtherSidePais[2][i].transform.localPosition=Vector3.New(chushiPosition,0,0);
			end
		end
	end	
end

function this:HideLateShoulipai(isown)
	if isown then
		for i=1,27 do
			self.ownoutCardsParent.transform:FindChild("Sprite_"..i):GetComponent("UISprite").alpha=0;
		end
	else
		for i=1,27 do
			self.otheroutCardsParent.transform:FindChild("Sprite_"..i):GetComponent("UISprite").alpha=0;
		end
	end
end

function this:zimoOwnMove()
	local child=self.OwnSidePais[1][#(self.OwnSidePais[1])].transform:FindChild("bottom_bg"):GetComponent("UISprite");
	local child_1=self.OwnSidePais[1][#(self.OwnSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
	local child_2=self.OwnSidePais[1][#(self.OwnSidePais[1])].transform:FindChild("bottom_bg/Sprite_1"):GetComponent("UISprite");
	child.spriteName="chupai_big";
	
	child_1.transform.localPosition=Vector3.New(0,22,0);
	child_2.alpha=0;
	self:ScaleChange(self.OwnSidePais[1][#(self.OwnSidePais[1])],0.3,0.5116,0.597);
	self:ScaleChange(child_1.gameObject,0.3,1.2578,0.71);
	--self:MoveToTarget(self.OwnSidePais[1][#(self.OwnSidePais[1])],self.zimotarget.transform.position.x,self.zimotarget.transform.position.y,0.3,false);
	coroutine.wait(0.3);
	--self.zimotarget.transform:FindChild("Sprite"):GetComponent("UISprite").alpha=1;
	self.OwnSidePais[1][#(self.OwnSidePais[1])].transform:FindChild("zimotexiao"):GetComponent("Animator").enabled=true;
	self.OwnSidePais[1][#(self.OwnSidePais[1])].transform:FindChild("zimotexiao"):GetComponent("Animator"):CrossFade("zimotexiao",0);
end

function this:zimoOtherMove(card)
	local child=self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg"):GetComponent("UISprite");
	local child_1=self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("bottom_bg/Sprite"):GetComponent("UISprite");
	child_1.spriteName=self._cardPre..card;
	coroutine.wait(0.1);
	child.spriteName="chupai_big";
	child_1.alpha=1;
	self:ScaleChange(self.OtherSidePais[1][#(self.OtherSidePais[1])],0.3,1.158,1.185);
	self:ScaleChange(child_1.gameObject,0.3,0.82,0.8);
	--self:MoveToTarget(self.OtherSidePais[1][#(self.OtherSidePais[1])],self.zimotarget.transform.position.x,self.zimotarget.transform.position.y,0.3,false);
	coroutine.wait(0.3);
	--self.zimotarget.transform:FindChild("Sprite"):GetComponent("UISprite").alpha=1;
	self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("zimotexiao"):GetComponent("Animator").enabled=true;
	self.OtherSidePais[1][#(self.OtherSidePais[1])].transform:FindChild("zimotexiao"):GetComponent("Animator"):CrossFade("zimotexiao",0);
end

function this:setOwnPaiMove(index,isNil)
	if isNil then
		for i=1,#(self.OwnSidePais[1]) do
			if self:getMahjong(self.OwnSidePais[1][i].name).paixuindex<index then
				self.OwnSidePais[1][i].transform.localPosition=Vector3.New(self.OwnSidePais[1][i].transform.localPosition.x-30,0,0);
			end
			if self:getMahjong(self.OwnSidePais[1][i].name).paixuindex~=index then
				self:getMahjong(self.OwnSidePais[1][i].name).huapaitishi.alpha=0;
			end
		end
	else
		for i=1,#(self.OwnSidePais[1]) do
			if #(self.OwnSidePais[1])%3==1 then
				if self:getMahjong(self.OwnSidePais[1][i].name).paixuindex>index then
					self.OwnSidePais[1][i].transform.localPosition=Vector3.New((self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1)*101+self.CGPMoveJuLi,0,0);
					self.OwnSidePais[1][i].transform.localScale=Vector3.one;
				elseif self:getMahjong(self.OwnSidePais[1][i].name).paixuindex<index then
					self.OwnSidePais[1][i].transform.localPosition=Vector3.New((self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1)*101-30+self.CGPMoveJuLi,0,0);
					self.OwnSidePais[1][i].transform.localScale=Vector3.one;
				end
				if self:getMahjong(self.OwnSidePais[1][i].name).paixuindex~=index then
					self:getMahjong(self.OwnSidePais[1][i].name).huapaitishi.alpha=0;
				end
			else
				if i<#(self.OwnSidePais[1]) then
					if self:getMahjong(self.OwnSidePais[1][i].name).paixuindex>index then
						self.OwnSidePais[1][i].transform.localPosition=Vector3.New((self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1)*101+self.CGPMoveJuLi,0,0);
						self.OwnSidePais[1][i].transform.localScale=Vector3.one;
					elseif self:getMahjong(self.OwnSidePais[1][i].name).paixuindex<index then
						self.OwnSidePais[1][i].transform.localPosition=Vector3.New((self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1)*101-30+self.CGPMoveJuLi,0,0);
						self.OwnSidePais[1][i].transform.localScale=Vector3.one;
					end
				else
					self.OwnSidePais[1][i].transform.localPosition=Vector3.New((self:getMahjong(self.OwnSidePais[1][i].name).paixuindex-1)*101+30+self.CGPMoveJuLi,0,0);
					self.OwnSidePais[1][i].transform.localScale=Vector3.one;
				end
				if self:getMahjong(self.OwnSidePais[1][i].name).paixuindex~=index then
					self:getMahjong(self.OwnSidePais[1][i].name).huapaitishi.alpha=0;
				end
			end
		end
	end
end

--[[
function this:partition_shuzi(list,low,high)
	local low=low;
	local high=high;
	local pivotKey=list[low];
	
	while low<high do
		while low<high and list[high]>=pivotKey do
			high=high-1;
		end
		swap(list,low,high);
		while low<high and list[low]<=pivotKey do 
			low=low+1;
		end
		swap(list,low,high);
	end
	return low;
end

function this:paixu_shuzi(list,low,high)
	if low<high then
		local pivotKeyIndex=this:partition(list,low,high);
		self:paixu_shuzi(list,low,pivotKeyIndex-1);
		self:paixu_shuzi(list,pivotKeyIndex+1,high);
	end
end
]]
function this:paixu_shuzi(list)
	for i=1,#(list)-1 do
		local temp=0;
		for j=1,#(list)-1 do 
			if list[j]>list[j+1] then
				temp=list[j];
				list[j]=list[j+1];
				list[j+1]=temp;
			end
		end
	end
	--for i=1,#(list) do
		--log(list[i]);
	--end
end

function this:SetHuaPai(huapaiId,tihuan)
	--log("huapaiId");
	--log(huapaiId);
	--log("gggggggggggggggg");
	table.insert(self.huapaiIndex,huapaiId);
	self.jiangliPanel:SetActive(true);
	self.huapaiTiShi.spriteName=self._cardPre..huapaiId;
	--log("结束");
	--log(#(self.OwnSidePais[1]))
	--log("zuihou");
	if #(self.OwnSidePais[1])>0 and tihuan then
		for i=1,#(self.OwnSidePais[1]) do
			for j=1,#(self.huapaiIndex) do
				if self:getMahjong(self.OwnSidePais[1][i].name).paiid==self.huapaiIndex[j] then
					self:getMahjong(self.OwnSidePais[1][i].name).huapai.alpha=1;
					if self.OwnSidePais[1][i].transform.localPosition.y~=0 then
						self:getMahjong(self.OwnSidePais[1][i].name).huapaitishi.alpha=1;
					end
				end
			end
		end
	end
end

function this:SetPlayyinxiao(index)
	if self.sex==0 then
		if index==0 then
			UISoundManager.Instance.PlaySound("m_chi_other");
		elseif index==1 then
			UISoundManager.Instance.PlaySound("m_gang_other");
		elseif index==3 then--主玩家吃牌
			local cishu=math.random(1);
			UISoundManager.Instance.PlaySound("m_lose_other_"..cishu);
		elseif index==2 then
			UISoundManager.Instance.PlaySound("m_peng_other");
		end
	else
		if index==0 then
			UISoundManager.Instance.PlaySound("w_chi_other");
		elseif index==1 then
			UISoundManager.Instance.PlaySound("w_gang_other");
		elseif index==3 then--主玩家吃牌
			local cishu=math.random(1);
			UISoundManager.Instance.PlaySound("w_lose_other_"..cishu);
		elseif index==2 then
			local cishu=math.random(1,2);
			UISoundManager.Instance.PlaySound("w_peng_other");
		end
	end
end

function this:ChongZhiState()
	self.MopaiIndex=0;
	self.HasCGP=false;
	self.trueTianting=false;
	self.trueTianhu=false;
end











