
local this = LuaObject:New()
GameDDZ = this

function this:Awake()
--	log("------------------awake of GameMXNNPanel")

	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		--local manualHeight = 800
		--sceneRoot.scalingStyle= UIRoot.Scaling.Constrained;
		--[[if(true or Application.platform ~= UnityEngine.RuntimePlatform.IPhonePlayer and Application.platform ~= UnityEngine.RuntimePlatform.Android
			and Application.platform ~= UnityEngine.RuntimePlatform.OSXEditor and Application.platform ~= UnityEngine.RuntimePlatform.WindowsEditor)then
			sceneRoot.scalingStyle= UIRoot.Scaling.Flexible;
			sceneRoot.minimumHeight = 768;
			sceneRoot.manualHeight = 800;
			sceneRoot.manualWidth = 1422;
		else
			sceneRoot.minimumHeight = 768;
			sceneRoot.manualHeight = 800;
			sceneRoot.manualWidth = 1422;
		end]]
		sceneRoot.minimumHeight = 768;
		sceneRoot.manualHeight = 800;
		sceneRoot.manualWidth = 1422;
		
		--sceneRoot.manualHeight = 738;
        --sceneRoot.manualWidth = 1280;
	end
	
	
--	local footInfoPrb = ResManager:LoadAsset("gamenn/footinfoprb","FootInfoPrb")
--	local settingPrb = ResManager:LoadAsset("gamenn/settingprb","SettingPrb")
--	GameObject.Instantiate(footInfoPrb)
--	GameObject.Instantiate(settingPrb)
end

function this:OnDestroy()
	log("--------------------ondestroy of GameMXNNPanel")
end
