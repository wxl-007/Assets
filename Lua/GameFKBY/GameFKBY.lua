require "GameFKBY/Scenes/FKBY_Game"
require "GameFKBY/Scenes/FKBY_Login"
require "GameFKBY/Scenes/FKBY_Select"
require "GameFKBY/Scenes/FKBY_Desks"
require "GameFKBY/Scenes/FKBY_GameFarm"
require "GameFKBY/View/SafeValidate";
require "GameFKBY/View/Panel_Bank";
require "GameFKBY/ConfigData"
require "GameFKBY/Lua_UIHelper"
require "GameFKBY/SocketMessage"
require "GameFKBY/LuaBagData"
require "GameFKBY/Panel_Follow"
require "GameFKBY/View/Panel_Personal"
require "GameFKBY/View/Panel_Recharge";
require "GameFKBY/FKBYGameSetting";

local this = LuaObject:New()
GameFKBY = this

function GameFKBY.Start()
	-- 设置平台
	Global.useLua = true;
	Global.platform = FKBYGameSetting.platform;
	Global.SetSpecialGunId(PlatformGameDefine.game.GameTypeIDs);
	-- 加载场景
    BYResourceManager.LoadLevel("FKBY_Loading");
end

function tableCount(table)
	local num = 0;
	for k,v in pairs(table) do
		if v ~= nil then
			num = num +1;
		end
	end
	return num;
end