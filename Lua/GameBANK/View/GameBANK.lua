
local this = LuaObject:New()
GameBANK = this

function this:Awake()
--	log("------------------awake of GameMXNNPanel")

	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		--[[
		local manualHeight = 800
		if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
			local strIpad = UnityEngine.iPhone.generation:ToString();
			
			if string.find(strIpad,"iPad") then
				manualHeight = 1000;	
			elseif Screen.width <= 960 then
				manualHeight = 900;
			end
		end
		
		sceneRoot.scalingStyle= UIRoot.Scaling.ConstrainedOnMobiles;
		]]
		--sceneRoot.manualHeight = 800;
        --sceneRoot.manualWidth = 1422;
	end
	
	
--	local footInfoPrb = ResManager:LoadAsset("gamenn/footinfoprb","FootInfoPrb")
--	local settingPrb = ResManager:LoadAsset("gamenn/settingprb","SettingPrb")
--	GameObject.Instantiate(footInfoPrb)
--	GameObject.Instantiate(settingPrb)
end

function this:OnDestroy()
	log("--------------------ondestroy of GameMXNNPanel")
end
