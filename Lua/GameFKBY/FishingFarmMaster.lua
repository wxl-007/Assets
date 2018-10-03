local this = LuaObject:New()
FishingFarmMaster = this;

local sceneSolo = "FarmSolo";
local sceneArray = "Array";
local scene;
local poolExperience;
local poolCapacity;
local commonList = {};--普通鱼
local valuableList = {};--珍贵鱼
local rarityList = {};--稀有
local allFishList = {};--所有的鱼

local fishBarItem;

local FishData = require "Config/FishData";
local Enum = require "GameFKBY/Enum";
local Event = require "events";
local fishID = 1;
local currentFarmLevel = 0;

local currentFarmSizeLevel = 0;

function this.GetCurrentFarmLevel(  )
	-- body
	return currentFarmLevel;
end
function  this.GetCurrentFarmSizeLevel(  )
	-- body
	return currentFarmSizeLevel;
end
function this.CommonList(  )
	-- body
	return commonList;
end
function this.ValuableList( )
	-- body
	return valuableList;
end
function this.RarityList()
	-- body
	return rarityList;
end
function this.AllFishList( )
	-- body
	return allFishList;
end

function this.GetGame_FishByNetId(fishNetId)
	-- body
	if(allFishList ~= nil) then
		return allFishList[fishNetId];
	end
end

function this.GetFishSpace()
	-- body
	local total = 0;
	for k,v in pairs(allFishList) do
		total = total + v.FishSpace;
	end
	return total;
end

function this.SpawnFish(fishId,netId,power,canCatch)
	-- body
	fishID = fishId;
	local fishPathId = 0;
	local prefabPath = FishPathManager.getRandomPath("FarmSolo",fishID,fishPathId,"FarmSolo");
	if(prefabPath == nil) then
		return;
	end
	local _fishPath = GameObject.Instantiate(prefabPath);
	local fish = FishPathManager.AddSingleFishToPath(_fishPath,fishID);
	if(fish ~= nil) then
		fish:Activate(fishId,netId,power, canCatch);
		fish.isLoop = true;
		fish.BarItem = NGUITools.AddChild(FKBY_GameFarm.GetFishBarItem().transform.parent.gameObject, FKBY_GameFarm.GetFishBarItem());
		this.SpawnList(fish);
	else
		error("Fish is null");
	end
	FishPathManager.addSkinnedMesh(_fishPath);
	--广播鱼池容量改变
    this.TriggerFarmFishChanged();
end
function this.SpawnList( fish )
	-- body
	local fishData = ConfigData.GetFishDataByFishId(fish.fishId);
	allFishList[fish.FishNetId] = fish;
	if(fishData.FishType == "普通") then
		commonList[fish.FishNetId] = fish;
	elseif(fishData.FishType == "珍贵") then
		valuableList[fish.FishNetId] = fish;
	elseif(fishData.FishType == "稀有") then
		rarityList[fish.FishNetId] = fish;
	end
	--广播通知添加鱼入鱼池
	this.TriggerSpawnFish(fish)
end

function this.SetFishPower( fishNetId,power )
	-- body
	local gFish = nil;
	gFish = allFishList[fishNetId];
	if gFish == nil	 then 
		return;
	end
	gFish.CurrentPower = power;
	gFish:ChangeNormalState();
	local data = ConfigData.GetFishDataByFishId(gFish.fishId);
	if(data.FishType == "普通") then
		commonList[gFish.FishNetId].CurrentPower = power;
	elseif(data.FishType == "珍贵") then
		valuableList[gFish.FishNetId].CurrentPower = power;
	elseif(data.FishType == "稀有") then
		rarityList[gFish.FishNetId].CurrentPower = power;
	end

end
function this.CanUpgradeFarmCapacity( )
	if(currentFarmSizeLevel >= 10) then
		UIHelper.ShowMessage("已升到最高容量啦",2);
		return false;
	end
	if currentFarmSizeLevel < currentFarmLevel then
		local data = ConfigData.FishFarmSizeData(currentFarmSizeLevel + 1);
		if(LuaBagData.GetGold() >= data.Money) then
			return true;
		else
			UIHelper.ShowMessage("金币不足",2);
			return false;
		end
	else 
		UIHelper.ShowMessage("鱼场等级不足,请先升级鱼场",2);

	end
end
function this.PoolExperience()
	-- body
	return poolExperience;
end
function this.TriggerFarmFishChanged()
	--广播
	local total = this.GetFishSpace();
	Event.Brocast(Enum.EventType.EventFarmSizeChange,total);
end
function this.TriggerFarmSizeLevelChanged(level)
	-- body
	currentFarmSizeLevel = level;
    --广播
    Event.Brocast(Enum.EventType.EventFarmSizeLvChange,level);
end
function this.TriggerFarmExpChanged( exp )
	-- body
	Event.Brocast(Enum.EventType.EventFarmExpChange,exp);
end
function this.TriggerFarmLevelChanged( level )
	-- body
	 currentFarmLevel = level;
	 --广播
	 Event.Brocast(Enum.EventType.EventFarmLevelChange,level);
end
function this.TriggerSpawnFish( gFish)
	-- body
	Event.Brocast(Enum.EventType.EventFarmOnSpawnFish,gFish);
end
function this.TriggerRemoveFish( gfish )
	-- body
	this.RemoveFish(gfish)
	Event.Brocast(Enum.EventType.EventFarmRemoveFish,gfish);
end
local mouseIcon = Enum.FarmMouseState.Normal;
function this.MouseState()
	return mouseIcon
end
function this.ChangeMouseState( state )
	-- body
	if(mouseIcon ~= state) then
		mouseIcon = state;
	end
end
function this.TouchListener()
	-- body
	if((Input.touchCount > 0 and Input.touches[0].phase == UnityEngine.TouchPhase.Began) or Input.GetMouseButtonDown(0)) then
		local selectedFish = nil;
		selectedFish = this.FishWithNearTouch();
		if selectedFish == nil then return end
		if(mouseIcon == Enum.FarmMouseState.Normal) then
			if(selectedFish.State == EnumFishState.Mature) then--收获鱼
				--发送收鱼消息
				print("收获鱼");
				SocketMessage.SendGetOneOutPutByMessage(selectedFish.FishNetId);
			elseif(selectedFish.State == EnumFishState.Coin) then-- 收宝
				--发送收宝消息 
				print("收宝");
				SocketMessage.SendGetOneOutPutMessage(selectedFish.FishNetId);
			end
		else
			--喂食
			if(mouseIcon == Enum.FarmMouseState.FeedCommon) then
				print("喂食1")
				this.FeedOneFish(selectedFish,1);
			elseif(mouseIcon == Enum.FarmMouseState.FeedHighest) then
				print("2");
				this.FeedOneFish(selectedFish,2);
			elseif(mouseIcon == Enum.FarmMouseState.FeedRarely) then
				print("3");
				this.FeedOneFish(selectedFish,3);
			elseif(mouseIcon == Enum.FarmMouseState.FeedValuable) then
				print("4");
				this.FeedOneFish(selectedFish,4);
			end
		end
	end
end
function this.FishWithNearTouch()
	-- body
	if UICamera.isOverUI == true then 
		return nil;
	end
	local touchPos = Input.mousePosition;
	touchPos.z = -Camera.main.transform.position.z;
    touchPos = Camera.main:ScreenToWorldPoint(touchPos);
    for k,v in pairs(allFishList) do
    	local fish = v;
    	if fish == nil then
    		error("fish is null");
    		allFishList[k] = nil;
    	else
    		local fishPos = Camera.main:WorldToScreenPoint(fish:GetFishPos());
    		fishPos.z = - Camera.main.transform.position.z;
    		fishPos = Camera.main:ScreenToWorldPoint(fishPos);

    		local distance = touchPos - fishPos;
    		if distance.sqrMagnitude < 1 then
    			return fish;
    		end
    	end
    end

    return nil;
end
function this.FeedOneFish( fish,foodLevel)
	-- body
	if(fish.State == EnumFishState.Hungry) then
		local needPower = fish.MaxPower - fish.CurrentPower;


		local foodId = 0;
		if(foodLevel == 1) then foodId = 2077;
		elseif foodLevel == 2 then foodId = 2078;
		elseif foodLevel == 3 then foodId = 2079;
		elseif foodLevel == 4 then foodId = 2080;
		end
		local itemData = ConfigData.ShopData(foodId);
		local offerPower = itemData.Energy;
		local needFood = math.ceil(needPower / offerPower);
		local hasNum = LuaBagData.GetItemNumByItemId(foodId);
		print(hasNum..":"..needFood);
		if(hasNum >= needFood) then
			print("喂食");
			SocketMessage.SendFeedOneFishMessage(fish.FishNetId,foodId,needFood);
		else
			UIHelper.ShowMessage("您的饲料不够，请去商城购买", 2);
		end
	end
end
function this.RemoveFish( gFish )
	-- body
	local data = ConfigData.GetFishDataByFishId(gFish.fishId);
	if data.FishType == "普通" then
		commonList[gFish.FishNetId] = nil;
	elseif data.FishType == "珍贵" then
		valuableList[gFish.FishNetId] = nil;
	elseif data.FishType == "稀有" then
		rarityList[gFish.FishNetId] = nil;
	end
	allFishList[gFish.FishNetId] = nil;
	print(gFish.name);
	gFish:Delete();
	this.TriggerFarmFishChanged();
end

function this.OnDestroy()
 	commonList = {};--普通鱼
	valuableList = {};--珍贵鱼
	rarityList = {};--稀有
	allFishList = {};--所有的鱼
end
