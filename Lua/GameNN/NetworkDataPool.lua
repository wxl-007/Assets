--网络数据接收池
local this = LuaObject:New()
NetworkDataPool = this

 
function this:New()
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o:Init()
	return o;    --返回自身
end

function this:clearLuaValue() 
	self.Pool = nil
	self.poolCount = 0;
end

function this:Init()
	self.Pool = {}; 
	self.poolCount = 0;
end 
function this:SetObject(messageObj,nextTime) 
	self.poolCount = self.poolCount+1;
	table.insert(self.Pool,NetDataObj:New(messageObj,nextTime));	
end
function this:GetObject()   
	return self.Pool[1] 
end 
function this:GetRemoveObject()   
	table.remove(self.Pool,1);
	self.poolCount = self.poolCount-1; 
end 
function this:RemoveObject(num)   
	table.remove(self.Pool,num);
	self.poolCount = self.poolCount-1; 
end 
 --游戏池对象
NetDataObj = LuaObject:New() 
 
function NetDataObj:New(messageObj,nextTime)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o:Init(messageObj,nextTime)
	return o;    --返回自身
end 
function NetDataObj:clearLuaValue()
	 self.gameObj = nil; 
end 
function NetDataObj:Init(messageObj,nextTime)
	self.messageObj = messageObj;
	self.nextTime = nextTime;  
end