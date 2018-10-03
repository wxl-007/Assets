--Panel_Bag = {};
--local this = Panel_Bag;
local this = LuaObject:New()
Panel_Bag = this
--local gameObject;
--local transform;
local bag;
local stone_fish;
local grid_stoneFish;

local stone_gun;
local grid_stoneGun;

local go_gun;
local grid_gun;

local go_card;
local grid_card;

local go_otherItem;
local grid_otherItem;

local item_food;
local grid_food;

local btnClose;
local toggle_gun;
local toggle_gunStone;

local tabObj;
local stoneObj;

local fishStoneTable = {};
local gunStoneTable = {};
local gunTable = {};

local FishStoneData = require "Config/FishStoneData";
local GunData = require "Config/FishBatteryData";
local CardData = require "Config/FishTicketData";
local OtherItemData = require "Config/FishPropData";
local ShopData = require "Config/FishShopData";
require "System/Coroutine";
local Enum = require "GameFKBY/Enum";
require "GameFKBY/View/Panel_MoreStoneInfo";

--启动事件--
function this.Awake()
	--this.gameObject = obj;
	--this.transform = obj.transform;
	this.InitPanel();	--warn("Awake lua--->>"..gameObject.name);

end
function this.OnEnable()
	--if(UIHelper.GetLoadedName() == "GameFarm") then


	--	toggle_gun.gameObject:SetActive(false);
	--	toggle_gunStone.gameObject:SetActive(false);
	--else
	--	toggle_gun.gameObject:SetActive(true);
	--	toggle_gunStone.gameObject:SetActive(false);
	--end
	if UIHelper.GetLoadedName() == "FKBY_GameFarm" then
		stoneObj:SetActive(true);
		this.transform:FindChild("Content 2").gameObject:SetActive(false);
		this.transform:FindChild("left/Tabs/Tab 1").gameObject:SetActive(false);
		this.transform:FindChild("left/Tabs/Tab 2").gameObject:SetActive(false);
		this.transform:FindChild("left/Tabs/Tab 3").localPosition = Vector3.New(0,0,0);
	else
		stoneObj:SetActive(false);
		this.transform:FindChild("left/Tabs/Tab 1").gameObject:SetActive(true);
		this.transform:FindChild("left/Tabs/Tab 2").gameObject:SetActive(true);
		this.transform:FindChild("left/Tabs/Tab 3").localPosition = Vector3.New(0,-160,0);
	end

	coroutine.start(LuaBagData.LoadData,Enum.ItemType.Stone,this.LoadCrystalData); --碎片
	--coroutine.start(LuaBagData.LoadData,Enum.ItemType.Diamond); --晶体
end
--初始化面板--
function this.InitPanel()
	btnClose = this.transform:FindChild("Button_close").gameObject;
	this.mono:AddClick(btnClose, this.OnHide);

	stone_fish = this.transform:FindChild("Content 1/Container/Panel1/fishStone/Grid/Item_fishstone").gameObject;
	grid_stoneFish = stone_fish.transform.parent.gameObject;

	stone_gun = this.transform:FindChild("Content 1/Container/Panel/gunStone/Grid/Item_GunStone").gameObject;
	grid_stoneGun = stone_gun.transform.parent.gameObject;

	go_gun = this.transform:FindChild("Content 2/Container/Panel/Grid/Item_bag").gameObject;
	grid_gun = go_gun.transform.parent.gameObject;

	go_card = this.transform:FindChild("Content 3/Container/Panel/Grid/Item_bag").gameObject;
	grid_card = go_card.transform.parent.gameObject;

	go_otherItem = this.transform:FindChild("Content 4/Container/Panel/Item_bag").gameObject;
	grid_otherItem = this.transform:FindChild("Content 4/Container/Panel/Grid").gameObject;

	--toggle_gun = this.transform:FindChild("Tab 2"):GetComponent("UIToggle");
	--toggle_gunStone = this.transform:FindChild("Content 1/Container/tg-gun"):GetComponent("UIToggle");

	stoneObj = this.transform:FindChild("Content 1").gameObject;
end
function this.LoadGunData() --枪
	--coroutine.start(LuaBagData.LoadData,Enum.ItemType.Gun,this.LoadCardData);
	coroutine.start(LuaBagData.LoadData,Enum.ItemType.Gun,this.CreatItem);
	print("gunData");
end
function this.LoadCardData() --卡
	coroutine.start(LuaBagData.LoadData,Enum.ItemType.ExchangeCard,this.LoadOtherItemData);
	print("cardData");
end
function this.LoadOtherItemData() --其他道具
	coroutine.start(LuaBagData.LoadData,Enum.ItemType.Other,this.CreatItem);
	print("otherItem");
end
function this.LoadCrystalData() --其他道具
	coroutine.start(LuaBagData.LoadData,Enum.ItemType.Diamond,this.LoadGunData);
	print("otherItem");
end
function this.LoadRankInfo()
	-- body
	local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.HANDSEL_RANK_URL,nil);
	coroutine.www(www);
end
function  this.Start()
	-- body
	--this.OnShow();
end
--单击事件--
function this.OnDestroy()
	warn("OnDestroy---->>>");
end
function this.OnClose(go)
	-- body
	destroy(this.gameObject);
	warn("lua OnClose");
end
function this.CreatItem()
	-- body
	if(tableCount(fishStoneTable)~=tableCount(LuaBagData.fishStoneTable)) then
	----------创建鱼碎片----------
		for k,v in pairs(fishStoneTable) do 
			destroy(v.gameObject);
		end
		fishStoneTable ={};
		for k, v in pairs(LuaBagData.fishStoneTable) do
			local go = GameObject.Instantiate(stone_fish);
			go.transform.parent = grid_stoneFish.transform;
			go.transform.localScale =Vector3.one;
			go.transform.localPosition = Vector3.zero;
			go.name = k;
			go:SetActive(true);
			local sp_icon = go.transform:FindChild("Sprite_Fish"):GetComponent("UISprite");
			local lb_name = go.transform:FindChild("Label_name"):GetComponent("UILabel");
			local lb_num = go.transform:FindChild("Progress Bar/LabelNumber"):GetComponent("UILabel");
			local bar = go.transform:FindChild("Progress Bar"):GetComponent("UISlider");
			this.mono:AddClick(go, this.OnItemClick);
			local stoneTable = {icon = sp_icon,name = lb_name, num = lb_num,progress = bar,gameObject = go};
			sp_icon.spriteName = FishStoneData[k].SpriteName;
			Lua_UIHelper.MakePixelPerfect(sp_icon,0.8);
			lb_num.text = v.num .."/"..FishStoneData[k].CombNum;
			lb_name.text = FishStoneData[k].Name;
			bar.value =v.num/FishStoneData[k].CombNum;
			fishStoneTable[k] = stoneTable;
		end
		grid_stoneFish:GetComponent('UIGrid').repositionNow = true;
	else
		--刷新鱼碎片
		for k, v in pairs(LuaBagData.fishStoneTable) do
			if fishStoneTable[k] ~= nil then
				fishStoneTable[k].num.text = v.num .."/"..FishStoneData[k].CombNum;
				fishStoneTable[k].progress.value = v.num/FishStoneData[k].CombNum;
				fishStoneTable[k].icon.spriteName = FishStoneData[k].SpriteName;
				Lua_UIHelper.MakePixelPerfect(fishStoneTable[k].icon,0.8);
				fishStoneTable[k].name.text = FishStoneData[k].Name;
			end
		end

	end
	if(tableCount(LuaBagData.gunStoneTable)~=tableCount(gunStoneTable)) then
	-----创建枪碎片
		--清除
		for k,v in pairs(gunStoneTable) do 
			destroy(v.gameObject);
		end
		gunStoneTable = {};
		for k,v in pairs(LuaBagData.gunStoneTable) do
			local go = NGUITools.AddChild(grid_stoneGun,stone_gun);
			go.name = k;
			go:SetActive(true);

			local sp_icon = go.transform:FindChild("Sprite_Fish"):GetComponent("UISprite");
			local lb_name = go.transform:FindChild("Label_name"):GetComponent("UILabel");
			local lb_num = go.transform:FindChild("Progress Bar/LabelNumber"):GetComponent("UILabel");
			local bar = go.transform:FindChild("Progress Bar"):GetComponent("UISlider");
			this.mono:AddClick(go, this.OnItemClick);
			local stoneTable = {icon = sp_icon,name = lb_name, num = lb_num , progress = bar, gameObject = go};
			sp_icon.spriteName = FishStoneData[k].SpriteName;
			Lua_UIHelper.MakePixelPerfect(sp_icon,1.5);
			lb_num.text = v.num .."/"..FishStoneData[k].CombNum;
			lb_name.text = FishStoneData[k].Name;
			bar.value =v.num/FishStoneData[k].CombNum;
			gunStoneTable[k] = stoneTable;
		end
		grid_stoneGun:GetComponent("UIGrid").repositionNow = true;
	else
		--刷新枪碎片
		for k,v in pairs(LuaBagData.gunStoneTable) do
			if gunStoneTable[k] ~= nil then
				gunStoneTable[k].num.text = v.num .."/"..FishStoneData[k].CombNum;
				gunStoneTable[k].progress.value = v.num/FishStoneData[k].CombNum;
				gunStoneTable[k].icon.spriteName = FishStoneData[k].SpriteName;
				Lua_UIHelper.MakePixelPerfect(gunStoneTable[k].icon,1.5);
				gunStoneTable[k].name.text = FishStoneData[k].Name;
			end
		end
	end
	-----创建武器
	if tableCount(LuaBagData.gunTable) ~= tableCount(gunTable) then
		for k,v in pairs(gunTable) do 
			destroy(v.gameObject);
		end
		gunTable = {};
		for k,v in pairs(LuaBagData.gunTable) do
			local go = NGUITools.AddChild(grid_gun,go_gun);
			go.name = k;
			go:SetActive(true);

			local sp_icon = go.transform:FindChild("Sprite_gun"):GetComponent("UISprite");
			local lb_name = go.transform:FindChild("Label_name"):GetComponent("UILabel");
			local lb_num = go.transform:FindChild("LabelNumber"):GetComponent("UILabel");
			local _gunTable = {icon = sp_icon,name = lb_name,num = lb_num,gameObject = go};

			sp_icon.spriteName = GunData[k].SpriteName;
			Lua_UIHelper.MakePixelPerfect(sp_icon,1.2);
			--lb_num.text = v.num;
			if v.num > 0 then
				lb_num.text = 1;
			else
				lb_num.text = 0;
			end
			lb_name.text = GunData[k].Name;

			gunTable[k] = _gunTable
		end
		grid_gun:GetComponent("UIGrid").repositionNow = true;
	else
		--设置武器
		for k,v in pairs(LuaBagData.gunTable) do
			if gunTable[k] ~= nil then
				gunTable[k].icon.spriteName = GunData[k].SpriteName;
				Lua_UIHelper.MakePixelPerfect(gunTable[k].icon,1.2);
				gunTable[k].name.text = GunData[k].Name;
				if v.num > 0 then
					gunTable[k].num.text = 1;
				else
					gunTable[k].num.text = 0;
				end
			end
		end
	end
	--[[
	-----创建券卡
	for k,v in pairs(LuaBagData.exchangeCardTable) do
		local go = GameObject.Instantiate(go_card);
		go.transform.parent = grid_card.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3.zero;
		go.name = k;
		go:SetActive(true);

		local sp_icon = go.transform:FindChild("FishIcon"):GetComponent("UISprite");
		local lb_name = go.transform:FindChild("Label_name"):GetComponent("UILabel");
		local lb_num = go.transform:FindChild("LabelNumber"):GetComponent("UILabel");

		local gunTable = {icon = sp_icon,name = lb_name,num = lb_name};
		sp_icon.spriteName = CardData[k].SpriteName;
		lb_num.text = v.num;
		lb_name.text = CardData[k].Name;
	end
	grid_card:GetComponent("UIGrid").repositionNow = true;
	]]

	-----创建其他道具
	EginTools.ClearChildren(grid_otherItem.transform);
	for k,v in pairs(LuaBagData.crystalTable) do 
		
		local go = GameObject.Instantiate(go_otherItem);
		go.transform.parent = grid_otherItem.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3.zero;
		go.name = k;
		go:SetActive(true);

		local sp_icon = go.transform:FindChild("FishIcon"):GetComponent("UISprite");
		local lb_name = go.transform:FindChild("Label_name"):GetComponent("UILabel");
		local lb_num = go.transform:FindChild("LabelNumber"):GetComponent("UILabel");

		local gunTable = {icon = sp_icon,name = lb_name,num = lb_name};
		sp_icon.spriteName = ShopData[k].bag_spriteName;
		lb_num.text = v.num;
		lb_name.text = ShopData[k].bag_name;
		
	end
	
	grid_otherItem:GetComponent("UIGrid").repositionNow = true;
end
function this.SetValue()
	
	
end
function this.OnShow()
	-- body
	Lua_UIHelper.UIShow(this.gameObject);
end
function this.OnHide()
	-- body
	--if Global.instance.isMobile == false then
	--	Panel_Follow.HidePanel(this.gameObject);
	--else
		this.gameObject:SetActive(false);
	--end
end
function this.OnItemClick(go)
	-- body
	Panel_MoreStoneInfo.SetItem(tonumber(go.name));
	Panel_Follow.ShowStoneInfo();
	Panel_Follow.AddRecPanel(this.gameObject);
	--this.gameObject:SetActive(false);
	--弹出更多碎片信息
	--BYResourceManager.Instance:CreateLuaPanel("Panel_MoreStoneInfo","Panel_MoreStoneInfo",true,this.OnInit);
	--destroy(this.gameObject);
	--Panel_Follow.HidePanel(this.gameObject);
	
end
function this.OnInit()
	-- body

end