require "GameNN/GPlayer"
require "GameSHHZ/SHHZGameSetting"
require "GameSHHZ/GameSHHZUI"
require "GameSHHZ/GameSHHZScene"

local this = LuaObject:New()
GameSHHZ = this

-- 加载界面
local panelLoading;

-------------------------------------------------------------------------------------------------
-- 将数字钱转换成字符串
function this.getMoneyString(money)
	local strMoney;
	if money > 999999999999 then
		money = money/100000000;
		strMoney = string.format("%d亿", money);
	elseif money > 99999999 then
		money = money/10000;
		strMoney = string.format("%d万", money);
	else
		strMoney = string.format("%d", money);
	end
	return strMoney;
end


-------------------------------------------------------------------------------------------------
-- 将数字钱转换成字符串
function this.updatePlayer(player, t)

	--设置头像，钱，昵称
	local playerName = t:FindChild("name"):GetComponent("UILabel");
	local playerMoney = t:FindChild("ingot/count"):GetComponent("UILabel");
	local head = t:FindChild("frame/head"):GetComponent("UISprite");
	playerName.text = player.nickname;
	playerMoney.text = GameSHHZ.getMoneyString(player.money);
	head.spriteName = "avatar_"..player.avatar;

end


function this.initPanel()
	-- 设置分辨率
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
	end

	-- 加载界面
	panelLoading = this.transform:FindChild("LoadingPanel").gameObject;
	panelLoading:SetActive(true);
end


-------------------------------------------------------------------------------------------------
function this.Awake()
	this.initPanel();

	-- QualitySettings.SetQualityLevel(2);
 --    QualitySettings.vSyncCount = 0;

	--加载资源
	coroutine.start(this.ProcessLoadingBar);
end

function this.ProcessLoadingBar()
	if SHHZGameSetting.isPCPlatform==false then
		EginProgressHUD.HideHUD();
	end
	
	local uiSlider = panelLoading:GetComponent("UISlider");
	local value = 0.0;
	while value < 1.0 do
		value = value + 0.4;
		uiSlider.value = value;
		coroutine.wait(0.1);
	end

	-- 隐藏Loading界面
	-- local UiTweenPosition = panelLoading:GetComponent("TweenPosition");
	-- panelLoading:SetActive(false);
 --    UiTweenPosition.enabled = true;
 --    UiTweenPosition:ResetToBeginning();
 --    UiTweenPosition:PlayForward();

	-- gameshhz/atla_common.assetbundle
 --    gameshhz/atla_loading.assetbundle
 --    gameshhz/font.assetbundle
 --    gameshhz/atla_startbet.assetbundle
 --    baselobby/atlas_avatar.assetbundle

	--SceneUtils.LoadLevel("GameSHHZ/GameSHHZScene", "GameSHHZScene");
	this.LoadLevel("GameSHHZ/GameSHHZScene", "GameSHHZScene");
end


 -- <summary>
 -- 加载场景
 -- </summary>
 -- <param name="name">场景名称(主界面)名称</param>
 -- <param name="isGame">true: 使用GameLua, false: 使用LuaBehaviour</param>
function this.LoadLevel(assetbundle, name)
	local SceneManager = luanet.import_type('UnityEngine.SceneManagement.SceneManager');
    if Application.isEditor==false then
		local ab = ResManager:LoadAsset(assetbundle, name);
	    SceneManager.LoadScene(name);
    else
        SceneManager.LoadScene(name);
    end
end

