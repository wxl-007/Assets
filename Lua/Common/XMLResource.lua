--读取配表文件
local Res = require 'Conf.Res'
local this = LuaObject:New()
XMLResource = this


this.Instance = this;

function this:Str(pKey)
	if type(pKey) ~= 'string' and type(pKey) ~= 'number' then
		return nil 
	end  
	
	if Res[pKey] ~= nil then 
		return  Res[pKey]
	else
		print('please check your key !')
		return nil 
	end
end
