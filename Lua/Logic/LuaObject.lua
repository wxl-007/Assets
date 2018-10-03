

local this = {}
LuaObject = this


local function Init(o)
	o.base = o:GetBase()
end

function this:New(o)
	o = o or {}	
	setmetatable(o,self)
	self.__index = self
	Init(o)
	return o
end

function this:GetBase()
	return getmetatable(self)
end


-----------------------测试---------------------------
--[[local m = LuaObject:New()
local m1 = m:New()

print(m.base==LuaObject,m.base)
print(m1.base==m,m1.base)--]]

function ConstTable(o)		--生成常量表功能
	o = o or {}
	o.__index = o
	--[[function (t,k)
		print(tostring(t) .."do not have key : " .. tostring(k))
	end--]]
	o.__newindex = function (t,k,v)
		print("*can't update " .. tostring(o) .."[" .. tostring(k) .."] = " .. tostring(v))
	end
	
	local t = {}
	setmetatable(t, o)
	return t
end
--[[-----------------ConstTable 使用测试----------------
c = ConstTable
{
	a = 1,
	b=2
}
print(c.a)
d = c.d
c.a = 3
c.d = 5
--]]
