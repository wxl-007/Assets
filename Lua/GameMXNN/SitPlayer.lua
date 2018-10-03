
local this = LuaObject:New()
SitPlayer = this

this.uid = 0;
this.nickname="";

	
function this:SitPlayer(json)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	
	
	o.uid = tonumber(json[1]) ;
	o.nickname=tostring(json[2]);
    return o;    --返回自身
end

