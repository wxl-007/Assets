local this = LuaObject:New()
GameSRDDZ = this


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
require "GameLRDDZ/Game/View/RaceRankAnimationPanel"
Event = require 'events'
function GameSRDDZ:Awake()

	----------------------------------------
    print("------------------start GameSRDDZ--------------")
    --LRDDZ_ResourceManager.LoadLevel("LRDDZ_Game", false, function(obj) end);
    UnityEngine.QualitySettings.SetQualityLevel(5);
    LRDDZ_ResourceManager.LoadLevel("SRDDZ_Loading", false, function(obj) end);
    --local prefab = LRDDZ_ResourceManager.LoadAsset("Prefab", "LRDDZ_Loading");
	--local go = GameObject.Instantiate(prefab);
    --go.name = "LRDDZ_Loading";
end	