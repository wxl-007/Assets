
--实用工具类--
LuaUtils = LuaObject:New(); 
LuaUtils.version = Utils.version;
LuaUtils.version_num = tonumber(LuaUtils.version);
--当前版本是否可用控制判断--
function LuaUtils.IsVersionUsable(_version)  
    if(tonumber(_version) <= LuaUtils.version_num) then
     
        return true;
    end
	return false;
end