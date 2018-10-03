--本地化文件
local SimpleCN = require 'Conf.Zh_Hans'  

 local this = LuaObject:New()
 ZPLocalization = this


this.Instance = this;


function this:Get(pKey)
	if type(pKey) ~= 'string' and type(pKey) ~= 'number' then
		return nil 
	end 
	--以后需要读取本地设置，来选择配表  1=EN 2=CN
	local tConf = SimpleCN;
	if tConf[pKey] ~= nil then
		return tConf[pKey]
	else
		print('please check your key !')
		return nil 
	end
end


