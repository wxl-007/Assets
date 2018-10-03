require "Logic/LuaObject"
local cjson = require "cjson"

HallConsts = ConstTable{
	GameModule_Hall = "HappyCity",
    GameModule_30M = "Game30M",
    GameModule_BBDZ = "GameBBDZ",
    GameModule_BRLZ = "GameBRLZ",
    GameModule_DDZ = "GameDDZ",
    GameModule_DZNN = "GameDZNN",
    GameModule_DZPK = "GameDZPK",
    GameModule_FTWZ = "GameFTWZ",
    GameModule_FTWZBS = "GameFTWZBS",
    GameModule_SRFTWZ = "GameSRFTWZ",
    GameModule_HPLZ = "GameHPLZ",
    GameModule_JQNN = "GameJQNN",
    GameModule_KPNN = "GameKPNN",
    GameModule_MXNN = "GameMXNN",
    GameModule_SRNN = "GameSRNN",
    GameModule_SRPS = "GameSRPS",
    GameModule_TBBY = "GameTBBY",
    GameModule_TBNN = "GameTBNN",
    GameModule_TBTW = "GameTBTW",
    GameModule_TBWZ = "GameTBWZ",
    GameModule_DDZC = "GameDDZC",
    GameModule_XJ = "GameXJ",
    GameModule_YSZ = "GameYSZ";
    GameModule_TBNN_New = "GameTBNN_New",
    GameModule_BANK = "GameBANK",
    GameModule_20DN = "Game20DN",
    GameModule_FARM = "GameFARM",
	GameModule_FKBY = "GameFKBY",
    GameModule_TBSZ = "GameTBSZ",
	GameModule_TBDSZ = "GameTBDSZ",
	GameModule_FKTBDN = "GameFKTBDN",
	GameModule_PPC = "GamePPC",
    GameModule_HPSK = "GameHPSK",
    GameModule_QBSK = "GameQBSK",
    GameModule_SHHZ = "GameSHHZ",
    GameModule_KSQZMJ = "GameKSQZMJ",
    GameModule_CHESS = 'GameCHESS',
    -- GameModule_ChessDesks = 'Module_ChessDesks',

    GameModule_DHSZ = "GameDHSZ",

	ExpressionPackage = "ExpressionPackage"
}

--------------------------游戏模块和场景(主预制件)的对应关系,变种模块不用添加--------------------------------------
local GameModule_LevelGUI_Map = {}
GameModule_LevelGUI_Map["GameYSZ"]="GameYSZ"---------key:模块中的主预制件(一个模块可以有多个场景(即主预制件),与对应的GameEntityxxx中的场景名称一致),value:模块
GameModule_LevelGUI_Map["GameTBNN_New"]="GameTBNN_New"---------key:模块,value:模块中的主预制件
GameModule_LevelGUI_Map["GameBANK"] = "GameBANK"
GameModule_LevelGUI_Map["Module_YBShop"] = Utils._hallResourcesName
GameModule_LevelGUI_Map["Module_Leaderboard"] = Utils._hallResourcesName
GameModule_LevelGUI_Map["Game20DN"] = "Game20DN"

GameModule_LevelGUI_Map["GameTBDSZ"] = "GameTBDSZ"
GameModule_LevelGUI_Map["GameFKTBDN"] = "GameFKTBDN"
GameModule_LevelGUI_Map["GamePPC"] = "GamePPC"
GameModule_LevelGUI_Map["GameHPSK"] = "GameHPSK"
GameModule_LevelGUI_Map["GameQBSK"] = "GameQBSK"
GameModule_LevelGUI_Map["GameKSQZMJ"] = "GameKSQZMJ"
GameModule_LevelGUI_Map["GameDHSZ"] = "GameDHSZ"
GameModule_LevelGUI_Map["GameLRDDZ"] = "GameLRDDZ"
GameModule_LevelGUI_Map["GameDDZ131CJF"] = "GameLRDDZ"
GameModule_LevelGUI_Map["Module_Task2"] = Utils._hallResourcesName
GameModule_LevelGUI_Map["GameSRFTWZ"] = "GameSRFTWZ"
GameModule_LevelGUI_Map["GameCHESS"]="GameCHESS"

PanelManager.GameModule_LevelGUI_Map_Extend(cjson.encode(GameModule_LevelGUI_Map))



----------------游戏模块和游戏名称的对应关系,变种游戏模块也需要添加的部分-------------------------
local GameModule_Name_Map = {}
GameModule_Name_Map[string.lower("GameYSZ")]="心跳牛牛"----------------key:模块,value:游戏名称
GameModule_Name_Map[string.lower("GameTBNN_New")]="测试游戏牛牛"----------------key:模块,value:游戏名称
 
PanelManager.GameModule_Name_Map_Extend(cjson.encode(GameModule_Name_Map))

