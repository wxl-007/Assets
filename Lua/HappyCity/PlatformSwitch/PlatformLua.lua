require "HappyCity/PlatformSwitch/PlatformEntity"
require "HappyCity/PlatformSwitch/Platforms/PlatformGame7997"
require "HappyCity/PlatformSwitch/Platforms/PlatformGame1977"
require "HappyCity/PlatformSwitch/Platforms/PlatformGame407"
require "HappyCity/PlatformSwitch/Platforms/PlatformGame510k"
require "HappyCity/PlatformSwitch/Platforms/PlatformGame597"
PlatformLua = LuaObject:New();
--记录C#对象
PlatformGameDefinePlayformC = PlatformGameDefine.playform;
--创建Lua和C#的媒介类
PlatformGameDefine.playform = PlatformEntityLua.New();
 
--根据不同平台初始化不同数据
if Utils.PlayformName == "PlatformGame597" then
    PlatformLua.playform = PlatformGame597; 
elseif  Utils.PlayformName == "PlatformGame407" then
    PlatformLua.playform = PlatformGame407; 
elseif  Utils.PlayformName == "PlatformGame510k" then
    PlatformLua.playform = PlatformGame510k; 
elseif  Utils.PlayformName == "PlatformGame7997" then
    PlatformLua.playform = PlatformGame7997; 
elseif  Utils.PlayformName == "PlatformGame1977" then
    PlatformLua.playform = PlatformGame1977; 
end   
--初始化数据 
PlatformLua.playform:Init(); 
--装载C#媒介类的Lua对象
PlatformGameDefine.playform.LuaSelf = PlatformLua.playform; 