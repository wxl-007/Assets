local this = LuaObject:New()
UserActionBtns = this 
function this:New(gameobj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.gameObject = gameobj;
	o.transform = gameobj.transform;
	o:Awake();
	return o;    --返回自身
end



function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	
	self.rightEdge = nil;
	self.leftEdge = nil;
	self.btnAry ={};
	self.autoFollowBtn = nil;
	self.seeCardBtn = nil;
	self.vsBtn = nil;
	self.giveupBtn = nil;
	self.width = nil;
	self.chipMoney={};
	self.numPrb = nil;
	self.followSpt = nil;
	self.yszMain = nil;
	self.isMyTurn = false;
end
function this:Init()
	--初始化变量
	self.rightEdge = self.transform:FindChild("Btnkanpai");
	self.leftEdge = self.transform:FindChild("0");
	self.btnAry ={
	self.transform:FindChild("0").gameObject,
	self.transform:FindChild("1").gameObject,
	self.transform:FindChild("2").gameObject,
	self.transform:FindChild("3").gameObject,
	};
	self.autoFollowBtn = self.transform:FindChild("alwaysFollow").gameObject;
	
	self.seeCardBtn = self.transform:FindChild("Btnkanpai").gameObject;
	self.vsBtn = self.transform:FindChild("Btnbipai").gameObject;
	self.giveupBtn = self.transform:FindChild("Btnqipai").gameObject;
	self.width = 210;
	self.chipMoney={100,22,8,4219};
	self.numPrb = ResManager:LoadAsset("gameysz/Prefabs","btnNum");
	self.followSpt = self.transform:FindChild("alwaysFollow/Sprite_alway_gen").gameObject:GetComponent("UISprite");
	self.yszMain = nil;
	self.isMyTurn = false;
	self.btn_bg=self.transform:FindChild("Sprite_bg").gameObject:GetComponent("UISprite");
	self.btn_bg.width=655;
end
function this:Awake () 
	self:Init()
end

function this:AddClick (mono) 
	mono:AddClick(self.autoFollowBtn, self.autoAlwaysFollow,self);
	self.autoFollowBtn:GetComponent("UIEventListener").enabled = false;
end


function this:initChip( moneyAry)
	for  i=0, #(self.btnAry)-1  do 
		local tempBtn = self.btnAry[i+1];
		if i<  #(moneyAry)  then
			tempBtn:SetActive(true);
			local offsetX = self.rightEdge.localPosition.x - self.width*( #(moneyAry)  - i);
			local vc3 = tempBtn.transform.localPosition;
			vc3.x = offsetX;
			tempBtn.transform.localPosition = vc3;
			--self:clearBtnNums(tempBtn);
			--self:addNumToBtn(tempBtn, moneyAry[i+1]);
			tempBtn.transform:FindChild("Sprite_show_label").gameObject:GetComponent("UILabel").text=tostring(moneyAry[i+1]);
		else
			tempBtn:SetActive(false);
		end
	end
	self.autoFollowBtn.transform.localPosition =  Vector3.New(-210,0,0):Add(self.leftEdge.localPosition);
	if  #(moneyAry)==1 then
		self.btn_bg.width=1075;
	elseif #(moneyAry)==2 then
		self.btn_bg.width=1285;
	elseif #(moneyAry)==3 then
		self.btn_bg.width=1495;
	elseif #(moneyAry)==4 then
		self.btn_bg.width=1705;
	end
end
function this:showGroup(moneyAry )
	self.isMyTurn = true;
	self:enableBtn(self.seeCardBtn);
	self:enableBtn(self.vsBtn);
	self:enableBtn(self.giveupBtn);
	for  i=1,  #(self.btnAry)  do 
		self.btnAry[i]:SetActive(true);
		self:enableBtn(self.btnAry[i]);
	end
	if moneyAry ~= nil then
		self:initChip(moneyAry);
	end
	self.autoFollowBtn:SetActive(true);
	self:enableBtn(self.autoFollowBtn);
end
function this:hideGroup()
	self.isMyTurn = false;
	self:disableBtn(self.seeCardBtn);
	self:disableBtn(self.vsBtn);
	self:disableBtn(self.giveupBtn);
	for  i=1,  #(self.btnAry)  do 
		self:disableBtn(self.btnAry[i]);
	end
end

function this:toggleVS( pk)
	local bipaiBtn = self.vsBtn;
	if pk == 1 then
		bipaiBtn:GetComponent("UIEventListener").enabled = true;
		bipaiBtn:GetComponent("UIButton").enabled = true;
		bipaiBtn:GetComponent("UIPlaySound").enabled = true;
		--bipaiBtn.transform:GetChild(0):GetComponent("UISprite").color = Color.New(1,1,1);
		bipaiBtn.transform:GetChild(0):GetComponent("UISprite").alpha=0;
	else
		bipaiBtn:GetComponent("UIEventListener").enabled = false;
		bipaiBtn:GetComponent("UIButton").enabled = false;
		bipaiBtn:GetComponent("UIPlaySound").enabled = false;
		--bipaiBtn.transform:GetChild(0):GetComponent("UISprite").color = Color.New(0.3,0.3,0.3);
		bipaiBtn.transform:GetChild(0):GetComponent("UISprite").alpha=0.5;
	end
end

function this:toggleSeeCard( isSaw)
	if not isSaw then
		self.seeCardBtn:GetComponent("UIEventListener").enabled = true;
		self.seeCardBtn:GetComponent("UIButton").enabled = true;
		self.seeCardBtn:GetComponent("UIPlaySound").enabled = true;
		--self.seeCardBtn.transform:GetChild(0):GetComponent("UISprite").color = Color.New(1,1,1);
		self.seeCardBtn.transform:GetChild(0):GetComponent("UISprite").alpha=0;
	else
		self.seeCardBtn:GetComponent("UIEventListener").enabled = false;
		self.seeCardBtn:GetComponent("UIButton").enabled = false;
		self.seeCardBtn:GetComponent("UIPlaySound").enabled = false;
		--self.seeCardBtn.transform:GetChild(0):GetComponent("UISprite").color = Color.New(0.3,0.3,0.3);
		self.seeCardBtn.transform:GetChild(0):GetComponent("UISprite").alpha=0.5;
	end
end

function this:disableFollowBtn()
	self:disableBtn(self.autoFollowBtn);
end

function this:disableBtn( btn)
	btn:GetComponent("UIEventListener").enabled = false;
	if btn:GetComponent("UIButton") ~= nil then
		btn:GetComponent("UIButton").enabled = false;
	end
	btn:GetComponent("UIPlaySound").enabled = false;
	--btn.transform:GetChild(0):GetComponent("UISprite").color = Color.New(0.3,0.3,0.3);
	btn.transform:GetChild(0):GetComponent("UISprite").alpha=0.5;


	local numPosTr = btn.transform:FindChild("numTr");
	if numPosTr ~= nil then
		local lenTemp = numPosTr.childCount;
		for  i=0, lenTemp-1 do 
			numPosTr:GetChild(i).gameObject:GetComponent("UISprite").color = Color.New(0.3,0.3,0.3);
		end
	end
end
function this:enableBtn( btn)
	btn:GetComponent("UIEventListener").enabled = true;
	if btn:GetComponent("UIButton") ~= nil then
		btn:GetComponent("UIButton").enabled = true;
	end
	btn:GetComponent("UIPlaySound").enabled = true;
	--btn.transform:GetChild(0):GetComponent("UISprite").color = Color.New(1,1,1);
	btn.transform:GetChild(0):GetComponent("UISprite").alpha=0;


	local numPosTr = btn.transform:FindChild("numTr");
	if numPosTr ~= nil then
		local lenTemp = numPosTr.childCount;
		for  i=0, lenTemp-1 do 
			numPosTr:GetChild(i).gameObject:GetComponent("UISprite").color = Color.New(1,1,1);
		end
	end

end

function this:addNumToBtn( btn,  money)

	local numPos = btn.transform:FindChild("numTr").gameObject;
	numPos.transform:FindChild("Sprite_show_label").gameObject:GetComponent("UILabel").text=tostring(money);
	--EginTools.AddNumberSpritesCenterAdjust(self.numPrb, numPos.transform, tostring(money), "jetton", 0.8);
end

function this:clearBtnNums( btn)
	local numPos = btn.transform:FindChild("numTr").gameObject;
	local lenTemp = numPos.transform.childCount;
	for  i=0, lenTemp-1 do 
		destroy( numPos.transform:GetChild(i).gameObject );
	end
end

function this:autoAlwaysFollow(btn)
	if not btn:GetComponent("UIEventListener").enabled then return; end

	if self.followSpt.spriteName == "bet_notselect" then
		SettingInfo.Instance.chipmin = true;
		SettingInfo.Instance.YSZ_autoVS = true;
		self.followSpt.spriteName = "bet_select";
		if self.isMyTurn then
			if self.yszMain ~= nil then
				self.yszMain:UserChip();
			end
		end
	else
		SettingInfo.Instance.chipmin = false;
		SettingInfo.Instance.YSZ_autoVS = false;
		self.followSpt.spriteName = "bet_notselect";
	end
end

function this:cancelAutoFollow()
	if self.followSpt.spriteName == "bet_select" then
		SettingInfo.Instance.chipmin = false;
		SettingInfo.Instance.YSZ_autoVS = false;
		self.followSpt.spriteName = "bet_notselect";
	end
end
