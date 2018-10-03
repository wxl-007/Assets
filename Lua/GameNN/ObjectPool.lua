--对象池
local this = LuaObject:New()
ObjectPool = this

 
function this:New()
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o:Init()
	return o;    --返回自身
end

function this:clearLuaValue()
	 
	self.Pool = nil
end

function this:Init()
	self.Pool = {}; 
end
 --初始化池中对象,参数一对象实例,参数二对象数量,参数三是否为池对象GamePoolObj
 function this:InitObject(gameObj,num,isGamePoolObj)
	 --log(gameObj);
	 --log(num);
	if isGamePoolObj==nil or not isGamePoolObj then
		for i = 1,num do
			local go = Object.Instantiate(gameObj); 
			--go:SetActive(false); 
			table.insert(self.Pool,go);	
		end  
	else
		for i = 1,num do
			local go = Object.Instantiate(gameObj); 
			--go:SetActive(false); 
			table.insert(self.Pool,GamePoolObj:New(go));	
		end 
	end
	--log(#(self.Pool).."=========长度");
end
function this:SetObject(gameObj) 
	--log("aaaaaaaaaaaaaaaaa");
	table.insert(self.Pool,gameObj);	
end
function this:GetObject() 
	--log(#(self.Pool).."========取出时的长度");
	local objTemp = self.Pool[1]
	table.remove(self.Pool,1);
	return objTemp
end 
 
 
 
 
 --游戏池对象
GamePoolObj = LuaObject:New() 
 
function GamePoolObj:New(gameObj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o:Init(gameObj)
	return o;    --返回自身
end

function GamePoolObj:clearLuaValue()
	 self.gameObj = nil;

end

function GamePoolObj:Init(gameObj)
	self.gameObj = gameObj;
	self.transform = gameObj.transform; 
	self.id = 0;  
end