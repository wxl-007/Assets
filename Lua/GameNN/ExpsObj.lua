
local this = LuaObject:New()
ExpsObj = this

this.ObjRef = nil;

	
function this:New(gameobj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
    return o;    --返回自身
end
