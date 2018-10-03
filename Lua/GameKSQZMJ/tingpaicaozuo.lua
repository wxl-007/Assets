local this = LuaObject:New()
tingpaicaozuo = this 
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
function this:New( gameObj,isown )
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj.gameObject = gameObj
	obj.transform  = gameObj.transform;
	obj.isown=isown;
	obj:Awake()
	return obj;
end

function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	
	self.jiantou=nil;
	self.parentObj=nil;
	self.fanshu={};
	self.parentWidth=0;
	self.jiantouPosX=0;
	self.isown=false;
	self.huapai=nil;
end
function this:Init()
	--初始化变量
	self.jiantou=self.transform:FindChild("jiantou"):GetComponent("UISprite");
	self.fanshu={};
	self.parentWidth=0;
	self.jiantouPosX=0;
	if self.isown then
		self.huapai=self.transform:FindChild("fanshu").gameObject;
		self.parentObj=self.transform:FindChild("bottom_bg"):GetComponent("UISprite");
	else
		self.huapai=nil;
		self.parentObj=self.gameObject:GetComponent("UISprite");
	end
end
function this:Awake () 
	self:Init()
	if self.isown then
		GameKSQZMJ.mono:AddClick(self.jiantou.gameObject,self.CloseHuapaiTiShi,self);
	else
		GameKSQZMJ.mono:AddClick(self.jiantou.gameObject,self.CloseTiShi,self);
	end
end

function this:CloseTiShi(target)
	if target.transform.localEulerAngles.y==0 then
		self.parentObj.width=115;
		target.transform.localEulerAngles=Vector3.New(0,180,0);
		target.transform.localPosition=Vector3.New(-97,0,0);
		for i=1,#(self.fanshu) do
			self.fanshu[i]:SetActive(false);
		end
	else
		self.parentObj.width=self.parentWidth;
		target.transform.localEulerAngles=Vector3.New(0,0,0);
		target.transform.localPosition=Vector3.New(self.jiantouPosX,0,0);
		for i=1,#(self.fanshu) do
			self.fanshu[i]:SetActive(true);
		end
	
	end
end

function this:CloseHuapaiTiShi(target)
	if target.transform.localEulerAngles.y==0 then
		self.parentObj.width=86;
		target.transform.localEulerAngles=Vector3.New(0,180,0);
		target.transform.localPosition=Vector3.New(-17,0,0);
		self.huapai:SetActive(false);
	else
		self.parentObj.width=228;
		target.transform.localEulerAngles=Vector3.New(0,0,0);
		target.transform.localPosition=Vector3.New(-159,0,0);
		self.huapai:SetActive(true);
	end
end


























