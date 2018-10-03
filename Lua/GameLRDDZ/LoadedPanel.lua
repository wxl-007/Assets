LoadedPanel = {};
local self = LoadedPanel;

local gameObject;
local transform;
local slider;

local displayProgress = 0;
local toProgress = 0;
local loadLevel = false
local IsExtractCompleted = false;
function LoadedPanel.Awake(obj)
	--平台设置分辨率
    gameObject = obj
    transform = obj.transform
    self.mono = gameObject:GetComponent('LRDDZ_LuaBehaviour');
end 
function LoadedPanel.Update()
	
	if IsExtractCompleted == false then
		slider = transform:FindChild("slider"):GetComponent("UISlider");
	    displayProgress = 0;
	    toProgress = 0;
	    loadLevel = false
	    coroutine.start(LoadedPanel.DelayLoad)
	    IsExtractCompleted = true;
	end
	
	
	if slider ~= nil and loadLevel == true then
		toProgress = LRDDZ_ResourceManager.getProgress() * 100;
		if displayProgress < toProgress then
			displayProgress = displayProgress + 10;
			slider.value = displayProgress * 0.01;
		else
			if displayProgress>=100 then
				--加载场景
				math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
			    MyCommon.SceneId = math.random(1,3);
			    --暂时固定
			    --MyCommon.SceneId = 3;
    			--LRDDZ_ResourceManager.LoadLevel("LRDDZ_Game_0"..MyCommon.SceneId, false, function(obj) end);
    			coroutine.start(GameLRDDZ.LoadGameScene,"LRDDZ_Game_0"..MyCommon.SceneId)
    			loadLevel = false
    			destroy(gameObject)
			end
		end
	end
end
function LoadedPanel.DelayLoad(  )
	coroutine.wait(0.4)
	loadLevel = true
	LRDDZ_ResourceManager.Instance:LoadNeedAssetAsync();
	
end
function LoadedPanel.OnDestroy()
	IsExtractCompleted = false
end