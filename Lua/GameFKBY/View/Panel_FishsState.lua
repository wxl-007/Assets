local this = LuaObject:New()
Panel_FishsState = this;

local sp_common_bg;--普通
local sp_valuble_bg;--珍贵
local sp_rarity_bg;--稀有
local grid_common;
local grid_valuble;
local grid_rarity;

local go_info;
local itemHeight = 40;
local addHeight = 40;

local lb_kind;
local commonList = {}; --[netId] = {obj = gameobject,gFish = Game_Fish,
						--msg = {icon = sp_icon,time = lb_time,name = lb_fishName}}
local valubleList = {};
local rarityList = {};

local height = 0;	
local Enum = require "GameFKBY/Enum";
local Event = require "events";
function this.Awake()
	--this.gameObject = obj;
	--this.transform = obj.transform;
	print("Panel_FishState lua Awake");
	this.InitPanel();
end
function this.Start()
	-- body
	--Lua_UIHelper.UIShow(this.gameObject);
end
--初始化面板--
function this.InitPanel()
	
	sp_common_bg = this.transform:FindChild("Container/All/state/FishScroll View/Sprite-pt"):GetComponent("UISprite");
	sp_valuble_bg = this.transform:FindChild("Container/All/state/FishScroll View/Sprite-xy"):GetComponent("UISprite");
	sp_rarity_bg = this.transform:FindChild("Container/All/state/FishScroll View/Sprite-zg"):GetComponent("UISprite");
	grid_common = sp_common_bg.transform:FindChild("PT-Grid"):GetComponent("UIGrid");
	grid_valuble = sp_valuble_bg.transform:FindChild("XY-Grid"):GetComponent("UIGrid");
	grid_rarity = sp_rarity_bg.transform:FindChild("ZG-Grid"):GetComponent("UIGrid");
	go_info = this.transform:FindChild("Container/All/state/FishScroll View/Grid/FishInfo").gameObject;
	lb_kind = this.transform:FindChild("Container/All/state/Label"):GetComponent("UILabel");
	Event.AddListener(Enum.EventType.EventFarmOnSpawnFish,this.SpawnFish);
	Event.AddListener(Enum.EventType.EventFarmRemoveFish,this.RemoveFish);
	Event.AddListener(Enum.EventType.EventFarmLevelChange,this.OnSetKind);
end
function this.Init(  )
	-- body
	for k,v in pairs(commonList) do
		destroy(commonList[k].obj);
	end
	commonList = {};
	
	for k,v in pairs(valubleList) do
		destroy(valubleList[k].obj);
	end
	valubleList = {};
	for k,v in pairs(rarityList) do
		destroy(rarityList[k].obj);
	end
	rarityList = {};
	--设置背景
	this.SetBg();
	--创建
	for k,v in pairs(FishingFarmMaster.CommonList()) do
		if v ~= nil then 
			height = height + 50;
			
			--[[
			local clone = GameObject.Instantiate(go_info);
			clone.transform.parent = grid_common.transform;
			clone.transform.localScale = Vector3.one;
			clone.transform.localPosition = Vector3.zero;
			clone.name = k;
			clone:SetActive(true);
			
			local _icon = clone.transform:FindChild("iconScal/Sprite-icon"):GetComponent("UISprite");
			local _time = clone.transform:FindChild("Label-time"):GetComponent("UILabel");
			local _name = clone.transform:FindChild("Label-name"):GetComponent("UILabel");
			local data = ConfigData.GetFishDataByFishId(v.fishId);
			_icon.spriteName = data.SpriteName;
			_name.text = data.FishName;
			_icon:MakePixelPerfect();
			commonList[k] = {obj = clone,gFish = v, msg = {sp_icon = _icon,lb_time = _time,lb_fishName = _name} };
			print("CreatInfo"..commonList[k].msg.sp_icon);
			]]
			
			local _obj;
			local _icon;
			local _time;
			local _name; 

			_obj,_icon,_time,_name = this.CreatInfo(grid_common,v);
			local temp = {sp_icon = _icon,lb_time = _time,lb_name = _name};
			commonList[k] = {obj = _obj,gFish = v,msg = temp};
		end
	end
	grid_common.repositionNow = true;
	
	for k,v in pairs(FishingFarmMaster.ValuableList()) do 
		height = height +50;
		local _obj;
		local _icon;
		local _time;
		local _name;
		_obj,_icon,_time,_name = this.CreatInfo(grid_valuble,v);
		local temp = {sp_icon = _icon,lb_time = _time,lb_name = _name};
		valubleList[k] = {obj = _obj,gFish = v,msg = temp};
	end

	grid_valuble.repositionNow = true;
	for k,v in pairs(FishingFarmMaster.RarityList()) do 
		height = height + 50;
		local _obj;
		local _icon;
		local _time;
		local _name;
		_obj,_icon,_time,_name = this.CreatInfo(grid_rarity,v);
		local temp = {sp_icon = _icon,lb_time = _time,lb_name = _name};
		rarityList[k] = {obj = _obj,gFish = v,msg = temp};
	end
	
	grid_rarity.repositionNow = true;
end
function this.CreatInfo(parent, gFsih)
	-- body
	local clone = GameObject.Instantiate(go_info);
	clone.transform.parent = parent.transform;
	clone.transform.localScale = Vector3.one;
	clone.transform.localPosition = Vector3.zero;
	clone.name = gFsih.FishNetId;
	clone:SetActive(true);
	local _icon = clone.transform:FindChild("iconScal/Sprite-icon"):GetComponent("UISprite");
	local _time = clone.transform:FindChild("Label-time"):GetComponent("UILabel");
	local _name = clone.transform:FindChild("Label-name"):GetComponent("UILabel");
	local data = ConfigData.GetFishDataByFishId(gFsih.fishId);
	_icon.spriteName = data.SpriteName;
	_name.text = data.FishName;
	_icon:MakePixelPerfect();
	return clone,_icon,_time,_name;
	
end
function this.SetBg(  )
	-- body
	local commonNum = tableCount(FishingFarmMaster.CommonList());
	if(commonNum>0) then
		if(commonNum>1) then
			sp_common_bg:SetDimensions(sp_common_bg.width, itemHeight * (commonNum - 1) + addHeight);
		else
			sp_common_bg:SetDimensions(sp_common_bg.width, itemHeight + addHeight);
		end
		sp_common_bg.gameObject:SetActive(true);
	else
		sp_common_bg.gameObject:SetActive(false);
	end

	local valuableNum = tableCount(FishingFarmMaster.ValuableList());
	if valuableNum > 0 then
		if(valuableNum > 1) then
			sp_valuble_bg:SetDimensions(sp_valuble_bg.width, itemHeight * (valuableNum - 1) + addHeight);
		else
			sp_valuble_bg:SetDimensions(sp_valuble_bg.width, itemHeight + addHeight);
		end
		sp_valuble_bg.gameObject:SetActive(true);
		
        local y = commonNum * - itemHeight + 160;
        if (commonNum > 0) then y = y - 10; end
        if (commonNum  == 1) then y = y - itemHeight; end
        sp_valuble_bg.transform.localPosition = Vector3.New(427, y, 0);
        
    else
    	sp_valuble_bg.gameObject:SetActive(false);
	end


	local rarityNum = tableCount(FishingFarmMaster.RarityList());
	if rarityNum > 0 then
		if  rarityNum > 1 then
			sp_rarity_bg:SetDimensions(sp_rarity_bg.width, itemHeight * (rarityNum - 1) + addHeight);
		else
			sp_rarity_bg:SetDimensions(sp_rarity_bg.width, itemHeight + addHeight);
		end
		sp_rarity_bg.gameObject:SetActive(true);
		local y = (commonNum + valuableNum) * -itemHeight + 160;
        if (commonNum > 0) then y = y - 10; end
        if (commonNum == 1) then y = y - itemHeight; end
        if (valuableNum  > 0) then y = y - 10; end
        if (valuableNum == 1) then y = y - itemHeight; end
        sp_rarity_bg.transform.localPosition = Vector3.New(427, y, 0);
    else
    	sp_rarity_bg.gameObject:SetActive(false);
	end

end
function this.SpawnFish( gFish )
	-- body
	print("fishsState init");
	this.Init();
end
function this.RemoveFish( gFish )
	-- body
	print("RemoveFish");
	local data = ConfigData.GetFishDataByFishId(gFish.fishId);
	if data.FishType == "普通" then
		local fish = commonList[gFish.FishNetId];
		destroy(fish.obj);
		commonList[gFish.FishNetId] = nil;
	elseif data.FishType == "珍贵" then
		local fish = valubleList[gFish.FishNetId];
		destroy(fish.obj);
		valubleList[gFish.FishNetId] = nil;
	elseif data.FishType == "稀有" then
		local fish = rarityList[gFish.FishNetId];
		destroy(fish.obj);
		rarityList[gFish.FishNetId] = nil;
	end
	this.SetBg();
	grid_common.repositionNow = true;
    grid_valuble.repositionNow = true;
    grid_rarity.repositionNow = true;
end
function this.OnSetKind( lv )
	-- body
	local temp = string.split(ConfigData.FishFarmData(lv).Fishs,".");
	lb_kind.text = string.format("可养各种类：%d种" , #temp);
end
function this.Update()
	-- body
	--刷新时间
	for k,v in pairs(commonList) do 
		if v~=nil then
			if v.gFish ~= nil then
				v.msg.lb_time.text = v.gFish:HealthLeftTime();
			end
		end
	end
	for k,v in pairs(valubleList) do
		if v~=nil then
			if v.gFish ~= nil then
				v.msg.lb_time.text = v.gFish:HealthLeftTime();
			end
		end
	end
	for k,v in pairs(rarityList) do
		if v~=nil then
			if v.gFish ~= nil then
				v.msg.lb_time.text = v.gFish:HealthLeftTime();
			end
		end
	end
end
function this.OnDestroy(  )
	-- body
	print("~destroy panel_fishState");
	commonList = {}; 
	valubleList = {};
	rarityList = {};
	Event.RemoveListener(Enum.EventType.EventFarmRemoveFish,this.RemoveFish);
	Event.RemoveListener(Enum.EventType.EventFarmOnSpawnFish,this.SpawnFish);
	Event.RemoveListener(Enum.EventType.EventFarmLevelChange,this.OnSetKind);
end