require "Logic/LuaObject"

require "Common/ZPLocalization"
require "Common/XMLResource"
require "Common/functions"
require "Common/define"
require "Logic/LuaBaseClass"
-- require 'Common/SocketConnectInfo'
require "Logic/LuaUtils"
require "Common/BuildPlatform" 
require "HappyCity/HallConsts"

--是否导入PlatformEntity的Lua逻辑,如果不导入者使用C#的PlatformEntity逻辑
IsPlatformLua = true
if IsPlatformLua then
	require "HappyCity/PlatformSwitch/PlatformLua"  
end



require "Common/ConnectDefine"
require 'Common/HttpResult'
require 'Common/HttpConnect'
require 'Common/EginUser'
require "common/SettingInfo"

require "Common/GlobalVar"

require 'Common/EginTools'
require 'Common/ProtocolHelper'
require 'Common/EginUserUpdate'


--------------------------HappyCity--------------------


--大厅版本  
 if Utils.HallName == "__HappyCity_597New" then
require "HappyCity/View/EginProgressHUD"
require "HappyCity_597New/View/Hall"
require "HappyCity_597New/View/Loading"
require "HappyCity_597New/View/Login"  
require "HappyCity_597New/View/BankSocket"
require "HappyCity_597New/View/Module_Bank"

require "HappyCity_597New/View/Module_Desks" 
require "HappyCity_597New/View/Module_GameRecord" 
require "HappyCity_597New/View/Module_Mail"
require "HappyCity_597New/View/Module_Recharge"
require "HappyCity_597New/View/Module_Recharge_iOS"
require "HappyCity_597New/View/Module_Rooms"
require "HappyCity_597New/View/Module_Setting"
require "HappyCity_597New/View/Module_UpdateAvatar"
require "HappyCity_597New/View/Register"
require "HappyCity_597New/View/Module_Leaderboard"
require "HappyCity_597New/View/Module_Hint"
require "HappyCity_597New/View/Module_ConvertRegister"
require "HappyCity_597New/View/Module_Task"
require "HappyCity_597New/View/Module_Welfare"
require "HappyCity_597New/View/Module_Activity"
require "HappyCity_597New/View/Module_Sign"
require "HappyCity_597New/View/Module_OneST"
require "HappyCity_597New/View/Module_Announcement" 
require "HappyCity_597New/View/HallTouchPanel"

elseif Utils.HallName == "__HappyCity" then
require "HappyCity/View/Hall_SingleGame"
require "HappyCity/View/IPTest_Login"
require "HappyCity/View/Local_Login"

require "HappyCity/View/EginProgressHUD"
require "HappyCity/View/Hall"
require "HappyCity/View/HallUtil"
require "HappyCity/View/Loading"
require "HappyCity/View/Login" 
require "HappyCity/View/BankSocket"
require "HappyCity/View/Module_Bank"
require "HappyCity/View/Module_YBShop"
require "HappyCity/View/Module_Desks"
require "HappyCity/View/Module_Feedback"
require "HappyCity/View/Module_GameRecord"
require "HappyCity/View/Module_Gift"
require "HappyCity/View/Module_Mail"
require "HappyCity/View/Module_Recharge"
require "HappyCity/View/Module_Recharge_iOS"
require "HappyCity/View/Module_Rooms"
require "HappyCity/View/Module_Setting"
require "HappyCity/View/Module_UpdateAvatar"
require "HappyCity/View/Register" 
require "HappyCity/View/Module_Task" 
require "HappyCity/View/Module_Task2" 
require "HappyCity/View/Module_Leaderboard"
require "HappyCity/View/Module_ConvertRegister"
require "HappyCity/View/Module_Sign"
require "HappyCity/View/Module_Channel"
require "HappyCity/View/Module_Activity"
require "GameNN/LobbyMsgReceiver"
require 'HappyCity/View/SimpleHUD'


elseif Utils.HallName == "__HappyCity_510k" then
require "HappyCity_510k/View/EginProgressHUD"
require "HappyCity_510k/View/Hall"
require "HappyCity_510k/View/Loading"
require "HappyCity_510k/View/Login" 
require "HappyCity_510k/View/BankSocket"
require "HappyCity_510k/View/Module_Bank"
require "HappyCity_510k/View/Module_Desks"
require "HappyCity_510k/View/Module_Feedback"
require "HappyCity_510k/View/Module_GameRecord"
require "HappyCity_510k/View/Module_Gift"
require "HappyCity_510k/View/Module_Mail"
require "HappyCity_510k/View/Module_Recharge"
require "HappyCity_510k/View/Module_Recharge_iOS"
require "HappyCity_510k/View/Module_Rooms"
require "HappyCity_510k/View/Module_Setting"
require "HappyCity_510k/View/Module_UpdateAvatar"
require "HappyCity_510k/View/Register" 
require "HappyCity_510k/View/Module_Task" 
require "HappyCity_510k/View/Module_Leaderboard"
require "HappyCity_510k/View/Module_VIP"
require "HappyCity_510k/View/Module_Sign"
require "HappyCity_510k/View/Module_ConvertRegister"
end

--捕鱼相关脚本
if Utils._IsFish then
require "GameFKBY/GameFKBY"
end

 
require "GameMXNN/View/GameMXNN"
require "GameTBNN/View/GameTBNN"
require "GameFTWZ/View/GameFTWZ"
require "GameSRFTWZ/View/GameSRFTWZ"
require "GameSRNN/View/GameSRNN"
require "GameJQNN/View/GameJQNN"
require "GameDZNN/View/GameDZNN"
require "GameHPLZ/View/GameHPLZ"
require "Game30M/View/Game30M"
require "GameBRLZ/View/GameBRLZ"
require "GameHPLZ/View/GameHPLZ"
require "GameKPNN/View/GameKPNN"
require "GameTBWZ/View/GameTBWZ"
require "GameXJ/View/GameXJ"
require "GameBBDZ/View/GameBBDZ"
require "GameSRPS/View/GameSRPS"
require "GameDZPK/View/GameDZPK"
require "GameYSZ/View/GameYSZ"
require "GameDDZ/View/GameDDZ"
require "GameBANK/View/GameBANK"
require "Game20DN/View/Game20DN"
require "GameKSQZMJ/View/GameKSQZMJ"
require "GameFARM/View/GameFARM"
-- require "GameFKBY/GameFKBY"
require "GameTBSZ/View/GameTBSZ"
require "GameTBDSZ/View/GameTBDSZ"
require "GameFKTBDN/View/GameFKTBDN"
require "GamePPC/View/GamePPC"
require "GameHPSK/View/GameHPSK"
require "GameQBSK/View/GameQBSK"
require "GameDHSZ/View/GameDHSZ"

require "GameNN/GameSettingManager"
require "GameNN/PoolInfo"
require "GameNN/FootInfo"
require "GameNN/InvokeLua"
require "GameNN/ObjectPool"

--两人斗地主
require "GameLRDDZ/GameLRDDZ"

require "GameCHESS/View/GameCHESS"

require "GameNN/Activity"
import 'JSONObject'
cjson = require "cjson"
--临时
--XMLResource = luanet.import_type('XMLResource');
--System.DateTime = luanet.import_type('System.DateTime');
RaycastHit = luanet.import_type('UnityEngine.RaycastHit');
Physics = luanet.import_type('UnityEngine.Physics');
Directory = luanet.import_type('System.IO.Directory');
File = luanet.import_type('System.IO.File');
Constants = luanet.import_type('Constants'); 

--管理器--
GameManager = LuaObject:New();
local this = GameManager;
local PanelManager = PanelManager
local game; 
local transform;
local gameObject;
local WWW = UnityEngine.WWW;

function GameManager.Awake() 
end

--启动事件--
function GameManager.Start() 
end

--初始化完成，发送链接服务器信息--
function GameManager.OnInitOK()
  
	
	if(Utils.HallName == "__HappyCity_510k") then
		--Utils.LoadLevelAdditiveGUI("Loading_510k");
	elseif(Utils.HallName == "__HappyCity_597New") then
		--Utils.LoadLevelAdditiveGUI("Loading_597New");
	elseif(Utils.HallName == "__HappyCity_597GD") then
		--Utils.LoadLevelAdditiveGUI("Loading_597GD");
		require "HappyCity_597GD/View/GlobalClass"
	elseif(Utils.HallName == "__HappyCity") then
		--Utils.LoadLevelAdditiveGUI("Loading");
	end
	
	Utils.LoadLevelAdditiveGUI("Loading");
	--UnityEngine.Application.LoadLevelAsync("GameTBNN");   
	 
end
GameManager.tVersionObj = nil;
--获取版本信息URL--
function GameManager.ChekcVersionURL()
  
	local gameName = Utils.GameName;
	local versionUrl = "";
	if(tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_Enterprise) then 
		versionUrl = PlatformLua.playform.DownloadURL.."version_"..gameName.."_IOS.txt";
	elseif(tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_AppStore) then 
		versionUrl = PlatformLua.playform.DownloadURL.."version_"..gameName.."_AppStore.txt"; 
	elseif(tostring(Utils.BUILDPLATFORM) == BuildPlatform.OSX) then  
		versionUrl = PlatformLua.playform.DownloadURL.."version_"..gameName.."_OSX.txt"; 
	else 
		versionUrl = PlatformLua.playform.DownloadURL.."version_"..gameName.."_Android.txt"; 
	end   
	log("~~jun====>"..versionUrl)
    return versionUrl;
end
--销毁--
function GameManager.OnDestroy()  
	if IsPlatformLua then
		PlatformGameDefine.playform = PlatformGameDefinePlayformC; 
	end
end

