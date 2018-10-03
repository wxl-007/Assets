require "3rd/pblua/login_pb"
require "3rd/pbc/protobuf"

local lpeg = require "lpeg"

local json = require "cjson"
local util = require "3rd/cjson.util"

local sproto = require "3rd/sproto/sproto"
local core = require "sproto.core"
local print_r = require "3rd/sproto/print_r"

require "GameLRDDZ.Logic.GameInitial"

--管理器--
LRDDZ_GameManager = {};
local self = LRDDZ_GameManager;
self.SceneName = nil    

local game; 
local transform;
local gameObject;
local WWW = UnityEngine.WWW;



function LRDDZ_GameManager.LuaScriptPanel()
   local  SpriteLuaTbale = { 
        --loading界面
        "GameLRDDZ/View/LoadedPanel",
        --登录界面
        "GameLRDDZ/View/LoginPanel",
        --选择界面
        "GameLRDDZ/View/ChoicePanel",
        --主界面
        "GameLRDDZ/View/HomePanel",
        "GameLRDDZ/View/BankPanel",
        "GameLRDDZ/View/RankPanel",
        "GameLRDDZ/View/EmailPanel",
        "GameLRDDZ/View/SettingPanel",
        "GameLRDDZ/View/TaskPanel",
        "GameLRDDZ/View/ExplainPanel",
        "GameLRDDZ/View/PayPanel",
        "GameLRDDZ/View/headInfoPanel",
        "GameLRDDZ/View/personInfoPanel",
        "GameLRDDZ/View/ShopPanel",
        "GameLRDDZ/View/NoticePanel",
        "GameLRDDZ/View/RecordPanel",

        "GameLRDDZ/View/PromptPanel",
        --游戏中的界面
        "GameLRDDZ/Game/View/GamePanel",
        "GameLRDDZ/Game/View/Player",
        "GameLRDDZ/Game/View/Computer",
        "GameLRDDZ/Game/View/GameOverPanel",
        "GameLRDDZ/Game/View/CountDownPanel",
        "GameLRDDZ/Game/View/CharacterComputer",
        "GameLRDDZ/Game/View/CharacterPlayer",
        "GameLRDDZ/Game/View/StandPlayer"
    }
	return  unpack(SpriteLuaTbale)  
end

function LRDDZ_GameManager.Awake()
    --warn('Awake--->>>');
end

--启动事件--
function LRDDZ_GameManager.Start()
	--warn('Start--->>>');
end

--初始化完成，发送链接服务器信息--
function LRDDZ_GameManager.OnInitOK()
    logWarn('SimpleFramework InitOK--->>>');

    LRDDZ_CtrlManager.Init();
    ParticleManager.Init()
    MessageManger.Init()

    --Avatar.Init()
  

    coroutine.start(self.EnterGame)
end
--进入游戏
function LRDDZ_GameManager.EnterGame()

    coroutine.wait(1)
    self.LoadSceneAsync(SceneName.Login)
end 
function LRDDZ_GameManager.LoadSceneAsync(sceneName)
    self.Clear()
    local function func()
    end 
    LRDDZ_ResourceManager.LoadLevel(sceneName, false, func)
   -- SceneManager.LoadSceneAsync(sceneName)
end 
function  LRDDZ_GameManager.Clear()
    ParticleManager.Clear()
    MessageManger.Clear()
end
-- 打开scene
function LRDDZ_GameManager.OnSceneEnable(sceneName)
    logWarn("OnSceneEnable:"..sceneName)
    if self.SceneName == sceneName    then return end 
    self.SceneName = sceneName
    if sceneName == SceneName.Loading then  --加载场景
    elseif sceneName == SceneName.Login then --登录场景
        LoginCtrl.Awake()
    elseif  sceneName == SceneName.ChoiceRole then --选择角色场景
        ChoiceCtrl.Awake()
    elseif sceneName == SceneName.Main then --主场景
        logWarn('sceneName == SceneName.Main');
        MainCtrl.Awake()
    elseif sceneName == SceneName.Game then --游戏场景
        GameCtrl.Awake()
    end 

end 
--关闭scene
function LRDDZ_GameManager.OnSceneDisable(sceneName)
    log("OnSceneDisable:"..sceneName)
    if sceneName == SceneName.Loading then  --加载场景
        
    elseif sceneName == SceneName.Login then --登录场景

    elseif  sceneName == SceneName.ChoiceRole then --选择角色场景

    elseif sceneName == SceneName.Main then --主场景

    elseif sceneName == SceneName.Game then --游戏场景

    end 
end 

--销毁--
function LRDDZ_GameManager.OnDestroy()
	--logWarn('OnDestroy--->>>');
end
