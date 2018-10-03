local this = LuaObject:New()
GameLRDDZ = this


require "GameLRDDZ/Logic/LRDDZ_GameManager"
require "GameLRDDZ/Game/View/GamePanel"
require "GameLRDDZ/Game/View/Player"
require "GameLRDDZ/Game/View/Computer"
require "GameLRDDZ/Game/View/OtherComputer"
require "GameLRDDZ/Game/View/LR_GameOverPanel"
require "GameLRDDZ/Game/View/SR_GameOverPanel"
require "GameLRDDZ/Game/View/CountDownPanel"
require "GameLRDDZ/Game/View/CharacterComputer"
require "GameLRDDZ/Game/View/CharacterOtherComputer"
require "GameLRDDZ/Game/View/CharacterPlayer"
require "GameLRDDZ/Game/View/StandPlayer"
require "GameLRDDZ/Logic/GameInitial"
require "GameLRDDZ/LRDDZ_Game"
require "GameLRDDZ/View/PromptPanel"
require "GameLRDDZ/Game/LRDDZ_SoundManager"
require "GameLRDDZ/LoadedPanel"
require "GameLRDDZ/Game/Type"
require "GameLRDDZ/View/LRDDZ_SettingPanel"
require "GameLRDDZ/View/LastHandPanel"
require "GameLRDDZ/Game/View/RacePanel"
require "GameLRDDZ/Game/View/ThreeRacePanel"
require "GameLRDDZ/Game/View/RaceOverPanel"
require "GameLRDDZ/Game/View/CJFRacePanel"
require "GameLRDDZ/Game/View/JDRaceOverPanel"
require "GameLRDDZ/Game/View/RaceRankAnimationPanel"
require "GameLRDDZ/Logic/StaticText"
Event = require 'events'
function GameLRDDZ:Awake()

	----------------------------------------
    print("------------------start GameLRDDZ--------------")
    if LRDDZ_Game.platform == PlatformType.PlatformPC then
        Screen.SetResolution(1280, 720, false)
        UnityEngine.QualitySettings.SetQualityLevel(5);
    end
    if LRDDZ_Game.platform == PlatformType.PlatformMoble then
        if PlatformGameDefine.game.GameID == "1070" then --1070为两人 1006为三人
            LRDDZ_Game.matchType = DDZGameMatchType.None
        	LRDDZ_ResourceManager.LoadLevel("LRDDZ_Loading", false, function(obj) end);
        elseif PlatformGameDefine.game.GameID == "1006" then
            LRDDZ_Game.matchType = DDZGameMatchType.None
        	LRDDZ_ResourceManager.LoadLevel("SRDDZ_Loading", false, function(obj) end);
        elseif PlatformGameDefine.game.GameID == "1095" then
            LRDDZ_ResourceManager.LoadLevel("CJFDDZ_Loading", false, function(obj) end);
            LRDDZ_Game.matchType = DDZGameMatchType.JDMatch
        elseif PlatformGameDefine.game.GameID == "1099" then --癞子
            LRDDZ_ResourceManager.LoadLevel("LZDDZ_Loading", false, function(obj) end);
            LRDDZ_Game.matchType = DDZGameMatchType.LZMatch
        end
    else
        if LRDDZ_Game.gameType == DDZGameType.Two then
            LRDDZ_ResourceManager.LoadLevel("LRDDZ_Loading", false, function(obj) end);
        elseif LRDDZ_Game.gameType == DDZGameType.Three then
            LRDDZ_ResourceManager.LoadLevel("SRDDZ_Loading", false, function(obj) end);
        elseif LRDDZ_Game.gameType == DDZGameType.JDThree then
            LRDDZ_ResourceManager.LoadLevel("CJFDDZ_Loading", false, function(obj) end);
        end
    end
    --local prefab = LRDDZ_ResourceManager.LoadAsset("Prefab", "LRDDZ_Loading");
	--local go = GameObject.Instantiate(prefab);
    --go.name = "LRDDZ_Loading";
end	

function GameLRDDZ.LoadGameScene(sceneName)

    local loadName = "";
    if LRDDZ_Game.platform == PlatformType.PlatformMoble then
        if (PlatformGameDefine.game.GameID == "1070") then--1070为两人 1006为三人
            loadName = "LRDDZ_LoadPanel"; 
        elseif PlatformGameDefine.game.GameID == "1006" then
            loadName = "SRDDZ_LoadPanel"; 
        elseif PlatformGameDefine.game.GameID == "1095" then
            loadName = "CJF_LoadPanel"
        elseif PlatformGameDefine.game.GameID == "1099" then
            loadName = "LZ_LoadPanel"; 
        end
    else
        if LRDDZ_Game.gameType == DDZGameType.Two then
            loadName = "LRDDZ_LoadPanel"; 
        elseif LRDDZ_Game.gameType == DDZGameType.Three then
            loadName = "SRDDZ_LoadPanel"; 
        elseif LRDDZ_Game.gameType == DDZGameType.JDThree then
            loadName = "CJF_LoadPanel"
        end
    end
    local prefab = LRDDZ_ResourceManager.LoadAsset("Prefab", loadName);
    local go = GameObject.Instantiate(prefab);
    go.name = "LRDDZ_LoadPanel";
    UnityEngine.Object.DontDestroyOnLoad(go);
    coroutine.wait(0.5)
    LRDDZ_ResourceManager.Instance:LoadNeedAssetAsync()
    coroutine.wait(0.02)
    LRDDZ_ResourceManager.LoadLevel(sceneName, false, function(obj) end);
end