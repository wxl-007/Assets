local cjson=require "cjson"
local this = LuaObject:New()
shuxing = this 
--[[
function this:New(gameobj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.gameObject = gameobj;
	o.transform = gameobj.transform;
	return o;    --返回自身
end
]]
function this:New(gameobj,isown)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.isown=isown;
	o.gameObject = gameobj;
	o.transform = gameobj.transform;
	o:Awake();
    return o;    --返回自身
end

function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	self.paiid = 0;
    self.paixuid = 0;
	self.paixuindex = 0;
    self.fenzu = 0;
    self.position_y=0;
    self.fanshu=nil;
	self.jiantou=nil;
    self.isMingGang=false;
	self.isAnGang=false;
    self.huapai=nil;
	self.huapaitishi=nil;
	self.canOut = false;
	self._nnPlayerName = "NNPlayer_";
	--self.tingpai=nil;
	self.isown=false;
end
function this:Init()
	--初始化变量
	self.paiid = 0;
    self.paixuid = 0;
	self.paixuindex = 0;
    self.fenzu = 0;--用来分辨是不是同一副牌
    self.position_y=0;
    self.fanshu=ResManager:LoadAsset("gameksqzmj/prefab","fanshu")
	--log("self.isown");
	--log(self.isown);
	if self.isown then
		--log("jinru");
		--local tingpaiFanshu=self.transform:FindChild("bottom_bg/tingpai").gameObject;
		--self.tingpai=tingpaicaozuo:New(tingpaiFanshu);
		self.jiantou=self.transform:FindChild("bottom_bg/tingpai/jiantou").gameObject;
		self.huapai=self.transform:FindChild("huapai"):GetComponent("UISprite");
		self.huapaitishi=self.transform:FindChild("hupai_panel/huapai_bg"):GetComponent("UISprite");
	end
	
    self.isMingGang=false;
	self.isAnGang=false; 
	self.canOut = false;
	self._nnPlayerName = "NNPlayer_";
end
function this:Awake () 
	self:Init()
	GameKSQZMJ.mono:AddClick(self.gameObject,self.tisheng,self);
end

function this:tisheng()
	if self.canOut then
		self.canOut=false;
		return;
	end
	--得到主玩家是否可以出牌的提示
	local canChuPai=GameKSQZMJ.isOwnChuPai;
	--log("是否可以出牌");
	--log(canChuPai);
	local cantingpai=GameKSQZMJ.CanTingpai;
	local chupaicount=GameKSQZMJ.chupaiOwnCount;
	--如果自己手中提出的牌不为空
	if not IsNil(GameKSQZMJ.standupCardObj) then
		local tichuindex=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):getMahjong(GameKSQZMJ.standupCardObj.name).paixuindex;
		--log("提出牌的index");
		--log(tichuindex);
		if GameKSQZMJ.standupCardObj~=self.gameObject then
			GameKSQZMJ.standupCardObj=self.gameObject;--将提出的牌设定为点击的这一张牌
			GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):setOwnPaiMove(self.paixuindex,false);--主玩家手里牌的移动
			if self.paixuindex<tichuindex then
				self.transform.localPosition=Vector3.New(self.transform.localPosition.x+16.5,50,0);
			else
				self.transform.localPosition=Vector3.New(self.transform.localPosition.x-13,50,0);
			end
			self.transform.localScale=Vector3.New(1.3,1.3,1.3);
			self:ShowOrHideTiShi();
			UISoundManager.Instance.PlaySound("xuanpai");
			--if cantingpai then
				--GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):qiehuanTingpaiMessage(self.gameObject.name);
			--end
		else--如果提出的牌跟点击的牌相同，则给服务器发送出牌的消息
			--log("点击两次牌相同");
			if cantingpai then
				local sendData={type="mj7",tag="t",body=2};
				GameKSQZMJ.mono:SendPackage(cjson.encode(sendData));
				GameKSQZMJ.buttonShowParent={};
				GameKSQZMJ.btnCancelButton:SetActive(false);
			end
			if canChuPai and self.transform.localPosition.y~=self.position_y then
				local sendData={type="mj7",tag="o",body=self.paiid};
				GameKSQZMJ.mono:SendPackage(cjson.encode(sendData));
				if self.huapaitishi.alpha==1 then
					self.huapaitishi.alpha=0;
				end
				--log("自己打牌");
				GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):NotTuoGuanChuPai(chupaicount+1,self.paiid,cantingpai);
			end
		end
	else--如果手中没有提出的牌
		--将此时点击的牌设定为提出的牌
		GameKSQZMJ.standupCardObj=self.gameObject;
		--并将此牌的位置提高
		self.transform.localPosition=Vector3.New(self.transform.localPosition.x-13,50,0);
		self.transform.localScale=Vector3.New(1.3,1.3,1.3);
		self:ShowOrHideTiShi();
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):setOwnPaiMove(self.paixuindex,true);--主玩家手里牌的移动
		UISoundManager.Instance.PlaySound("xuanpai");
		--if cantingpai then
			--GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):qiehuanTingpaiMessage(self.gameObject.name);
		--end
	end
end

function this:huanyuan()
	self.transform.localPosition=Vector3.New(self.transform.localPosition.x,self.position_y,0);
	self.transform.localScale=Vector3.one;
	if self.huapaitishi.alpha==1 then
		self.huapaitishi.alpha=0;
	end
end

function this:setTingpaiList(tingpaiList)
	self.transform:FindChild("bottom_bg/Sprite_logo"):GetComponent("UISprite").alpha=1;
	local outpailist=GameKSQZMJ.outAllPai;
	
	local fanshuParent=nil;
	local fanshuParent_jiaoben=nil;
	--找到每张可以听的牌对应的要用来实例化番数的父物体
	local ownpai=GameKSQZMJ.userPlayerCtrl.OwnSidePais[4];
	--log(#(ownpai).."听牌父物体个数");
	for i=1,#(ownpai) do
		if ownpai[i].name==self.gameObject.name then
			fanshuParent=ownpai[i];
			fanshuParent_jiaoben=tingpaicaozuo:New(fanshuParent,false);
			break;
		end
	end
	--log(fanshuParent.name.."可胡牌");
	for i=1,#(tingpaiList) do
		local hupaiId=tonumber(tingpaiList[i][1]);
		local fanshucount=tonumber(tingpaiList[i][2]);
		local hupai=GameObject.Instantiate(self.fanshu);
		--log(hupai.name.."实例出的番数");
		fanshuParent:GetComponent("UISprite").width=257+(#(tingpaiList)-1)*130;
		self.jiantou.transform.localPosition=Vector3.New(-238-(i-1)*130,0,0);
		
		if not IsNil(fanshuParent) then
			hupai.transform.parent=fanshuParent.transform;
			--log("进入-----------");
			table.insert(fanshuParent_jiaoben.fanshu,hupai);
			fanshuParent_jiaoben.parentWidth=fanshuParent:GetComponent("UISprite").width;
			fanshuParent_jiaoben.jiantouPosX=self.jiantou.transform.localPosition.x;
			hupai.transform.localEulerAngles=fanshuParent.transform.localEulerAngles;
			hupai.transform.localPosition=Vector3.New(-120-(i-1)*130,0,0);
			
			hupai.transform.localScale=Vector3.one;
			hupai.transform:FindChild("hupaitishi"):GetComponent("UISprite").spriteName="Mahjong_"..hupaiId;
			hupai.transform:FindChild("fanshu_label"):GetComponent("UILabel").text=tostring(fanshucount);
			local geshu=0;
			for j=1,#(outpailist) do
				if outpailist[j]==hupaiId then
					geshu=geshu+1;
				end
			end
			hupai.transform:FindChild("zhangshu_label"):GetComponent("UILabel").text=tostring(4-geshu);
		end
	end
end

function this:ShowOrHideTiShi()
	if self.huapai.alpha==1 then
		self.huapaitishi.alpha=1;
	end
end

function this:huadongSelect()
	local cantingpai=GameKSQZMJ.CanTingpai;
	--如果自己手中提出的牌不为空
	if not IsNil(GameKSQZMJ.standupCardObj) then
		local tichuindex=GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):getMahjong(GameKSQZMJ.standupCardObj.name).paixuindex;
		if GameKSQZMJ.standupCardObj~=self.gameObject then
			GameKSQZMJ.standupCardObj=self.gameObject;--将提出的牌设定为点击的这一张牌
			GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):setOwnPaiMove(self.paixuindex,false);--主玩家手里牌的移动
			if self.paixuindex<tichuindex then
				self.transform.localPosition=Vector3.New(self.transform.localPosition.x+16.5,50,0);
			else
				self.transform.localPosition=Vector3.New(self.transform.localPosition.x-13,50,0);
			end
			self.transform.localScale=Vector3.New(1.3,1.3,1.3);
			self:ShowOrHideTiShi();
			UISoundManager.Instance.PlaySound("xuanpai");
			if cantingpai then
				GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):qiehuanTingpaiMessage(self.gameObject.name);
			end
			self.canOut=true;	
		end
	else--如果手中没有提出的牌
		--将此时点击的牌设定为提出的牌
		GameKSQZMJ.standupCardObj=self.gameObject;
		--并将此牌的位置提高
		self.transform.localPosition=Vector3.New(self.transform.localPosition.x-13,50,0);
		self.transform.localScale=Vector3.New(1.3,1.3,1.3);
		self:ShowOrHideTiShi();
		GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):setOwnPaiMove(self.paixuindex,true);--主玩家手里牌的移动
		UISoundManager.Instance.PlaySound("xuanpai");
		if cantingpai then
			GameKSQZMJ:getPlayerCtrl(self._nnPlayerName..EginUser.Instance.uid):qiehuanTingpaiMessage(self.gameObject.name);
		end
		self.canOut=true;	
	end
end

















