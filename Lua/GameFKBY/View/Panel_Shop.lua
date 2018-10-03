local this = LuaObject:New();
Panel_Shop = this;

local go_item;
local grid_item;
local go_gun;
local grid_gun;
local go_card;
local grid_card;
local hasLoadItem = false;
local button_close;
--local button_bag;
--local button_recharge;
local toggle_gun;
local toggle_gunStone;

local grid_crystal;	--晶体父对象


local tg_gun;
local tg_item;
local tg_card;

local itemData = {};
local gunData = {}
local cardData = {};
local allShopItem = {};

local lb_coin;--金币

local cjson = require "cjson"
--表数据
local FishStoneData = require "Config/FishStoneData";
local GunData = require "Config/FishBatteryData";
local CardData = require "Config/FishTicketData";
local OtherItemData = require "Config/FishPropData";
local ShopData = require "Config/FishShopData";
local Event = require "events";

require "System/Coroutine";
require "GameFKBY/LuaBagData";
require "GameFKBY/View/Panel_ConfirmFrame";
require "GameFKBY/Lua_UIHelper";
local Enum = require "GameFKBY/Enum";
function this.Awake()
	--this.gameObject = obj;
	--this.transform = obj.transform;
	print("panel_Shop lua Awake");
	this.InitPanel();
end
function this.OnEnable()
    -- body
    --if Global.instance.isMobile == false then
    --    UIHelper.On_UI_Show(this.gameObject);
    --end
end

function this.Start()
	-- body
	--Lua_UIHelper.UIShow(this.gameObject);
end
function this.OnEnable(  )
	--设置要显示的类别
	tg_item.value = true;
	--if(UIHelper.GetLoadedName() ~= "FKBY_GameFarm") then
		--tg_gun.enabled = true;
		--tg_card.enabled = true;
		--tg_gun.gameObject:SetActive(true);
		--tg_card.gameObject:SetActive(true);
	--else
		--tg_gun.enabled = false;
		--tg_card.enabled = false;
		--tg_gun.gameObject:SetActive(false);
		--tg_card.gameObject:SetActive(false);
	--end
end
--初始化面板--
function this.InitPanel()
	button_close = this.transform:FindChild("Button_close").gameObject;
	this.mono:AddClick(button_close,this.Hide);

	--button_bag = this.transform:FindChild("background/button_have").gameObject;
	--this.mono:AddClick(button_bag,this.OnBag);

	--button_recharge = this.transform:FindChild("background/box4/Button_addGold").gameObject;
	--this.mono:AddClick(button_recharge,this.OnRecharge);

	go_item = this.transform:FindChild("Content 2/Container/Panel/Grid/ShopItem").gameObject;
	grid_item = go_item.transform.parent.gameObject;

	go_gun	= this.transform:FindChild("Content 1/Container/Panel/Grid/ShopItem").gameObject;
	grid_gun = go_gun.transform.parent.gameObject;

	go_card = this.transform:FindChild("Content 3/Container/Panel/Grid/ShopItem").gameObject;
	grid_card = go_card.transform.parent.gameObject;

	tg_gun = this.transform:FindChild("left/Tabs/Tab 2"):GetComponent("UIToggle");
	tg_card = this.transform:FindChild("left/Tabs/Tab 4"):GetComponent("UIToggle");
	tg_item = this.transform:FindChild("left/Tabs/Tab 3"):GetComponent("UIToggle");

	lb_coin = this.transform:FindChild("left/Coin/Label"):GetComponent("UILabel");
	--lb_coin.text = UIHelper.SetCoinStandard(LuaBagData.GetGold());
	this.SetGold();
	--发送消息
	coroutine.start(this.LoadShopData);

	Event.AddListener(Enum.EventType.EventGoldChange,this.SetGold);

	grid_crystal = this.transform:FindChild("Content 5/Container/Panel/Grid");

end
function this.CreatItem()
	-- body
	
	
	allShopItem = {};
	--道具 鱼食
	for k,v in Lua_UIHelper.pairsByKeys(ShopData) do --鱼食和晶石
		if(itemData[k] ~= nil and v.Type ==2) then
			local clone = GameObject.Instantiate(go_item);
			clone.transform.parent = grid_item.transform;
			clone.transform.localScale =Vector3.one;
			clone.transform.localPosition = Vector3.zero;
			clone.name = k;
			clone:SetActive(true);
			--赋值
			local sp_icon = clone.transform:FindChild("FishIcon"):GetComponent("UISprite");
			local lb_price = clone.transform:FindChild("LabelPrice"):GetComponent("UILabel");
			local lb_name = clone.transform:FindChild("LabelName"):GetComponent("UILabel");
			local lb_desc = clone.transform:FindChild("Label-desc"):GetComponent("UILabel");
			local button = clone.transform:FindChild("Button_buy").gameObject;

			sp_icon.spriteName = ShopData[k].SpriteName;
			lb_name.text = ShopData[k].Name;
			lb_desc.text = ShopData[k].Desc;
			lb_price.text = itemData[k].price;
			this.mono:AddClick(button, this.Buy);
			Lua_UIHelper.MakePixelPerfect(sp_icon,v.SpriteScale);

			allShopItem[k] = {id = k,name = v.Name,price = itemData[k].price};
		end
	end
	--道具 晶石
	for k,v in Lua_UIHelper.pairsByKeys(ShopData) do --鱼食和晶石
		if(itemData[k] ~= nil and v.Type == 4) then
			local clone;
			if v.Id > 2082 and v.Id < 2088 then
				clone = grid_crystal:GetChild(v.Id - 2083).gameObject;
			else
				clone = GameObject.Instantiate(go_item);
				clone.transform.parent = grid_item.transform;
				clone.transform.localScale =Vector3.one;
				clone.transform.localPosition = Vector3.zero;
			end
			clone.name = k;
			clone:SetActive(true);
			--赋值
			local sp_icon = clone.transform:FindChild("FishIcon"):GetComponent("UISprite");
			local lb_price = clone.transform:FindChild("LabelPrice"):GetComponent("UILabel");
			local lb_name = clone.transform:FindChild("LabelName"):GetComponent("UILabel");
			local lb_desc = clone.transform:FindChild("Label-desc"):GetComponent("UILabel");
			local button = clone.transform:FindChild("Button_buy").gameObject;

			sp_icon.spriteName = ShopData[k].SpriteName;
			lb_name.text = ShopData[k].Name;
			lb_desc.text = ShopData[k].Desc;
			lb_price.text = itemData[k].price;
			this.mono:AddClick(button, this.Buy);
			Lua_UIHelper.MakePixelPerfect(sp_icon,v.SpriteScale);

			allShopItem[k] = {id = k,name = v.Name,price = itemData[k].price};
		end
	end
	--其他道具先不显示
	--[[
	for k,v in Lua_UIHelper.pairsByKeys(OtherItemData) do --其他道具
		if(itemData[k] ~= nil) then
			local clone = GameObject.Instantiate(go_item);
			clone.transform.parent = grid_item.transform;
			clone.transform.localScale =Vector3.one;
			clone.transform.localPosition = Vector3.zero;
			clone.name = k;
			clone:SetActive(true);
			--赋值
			local sp_icon = clone.transform:FindChild("FishIcon"):GetComponent("UISprite");
			local lb_price = clone.transform:FindChild("LabelPrice"):GetComponent("UILabel");
			local lb_name = clone.transform:FindChild("LabelName"):GetComponent("UILabel");
			local lb_desc = clone.transform:FindChild("Label-desc"):GetComponent("UILabel");
			local button = clone.transform:FindChild("Button_buy").gameObject;

			sp_icon.spriteName = OtherItemData[k].SpriteName;
			lb_name.text = OtherItemData[k].Name;
			lb_desc.text = "";
			lb_price.text = itemData[k].price;
			this.mono:AddClick(button, this.Buy);

			allShopItem[k] = {id = k,name = v.Name,price = itemData[k].price};
		end
	end
	]]
	grid_item:GetComponent('UIGrid').repositionNow = true;
	--grid_crystal:GetComponent('UIGrid').repositionNow = true;
	
	--武器
	for k,v in Lua_UIHelper.pairsByKeys(GunData) do
		if(gunData[k] ~= nil) then 
			-- 过滤vip开启的5个炮 还有一个天罗地网
			if k ~= 2050 and k ~= 2051 and k ~= 2052 and k ~= 2053  then
				local clone = GameObject.Instantiate(go_gun);
				clone.transform.parent = grid_gun.transform;
				clone.transform.localScale =Vector3.one;
				clone.transform.localPosition = Vector3.zero;
				clone.name = k;
				clone:SetActive(true);
				--赋值
				local sp_icon = clone.transform:FindChild("FishIcon"):GetComponent("UISprite");
				local lb_price = clone.transform:FindChild("LabelPrice"):GetComponent("UILabel");
				local lb_name = clone.transform:FindChild("LabelName"):GetComponent("UILabel");
				local lb_desc = clone.transform:FindChild("Label-desc"):GetComponent("UILabel");
				local button = clone.transform:FindChild("Button_buy").gameObject;
				sp_icon.spriteName = v.SpriteName;
				lb_name.text = v.Name;
				lb_price.text = gunData[k].price;
				this.mono:AddClick(button, this.Buy);
				lb_desc.text = v.Time;
				Lua_UIHelper.MakePixelPerfect(sp_icon,1);
				allShopItem[k] = {id = k,name = v.Name,price = gunData[k].price};
			end
		end
	end
	grid_gun:GetComponent('UIGrid').repositionNow = true;


	--券卡 先不显示
	--[[
	for k,v in Lua_UIHelper.pairsByKeys(CardData) do
		if(cardData[k] ~= nil) then
			local clone = GameObject.Instantiate(go_card);
			clone.transform.parent = grid_card.transform;
			clone.transform.localScale =Vector3.one;
			clone.transform.localPosition = Vector3.zero;
			clone.name = k;
			clone:SetActive(true);
			--赋值
			local sp_icon = clone.transform:FindChild("FishIcon"):GetComponent("UISprite");
			local lb_price = clone.transform:FindChild("LabelPrice"):GetComponent("UILabel");
			local lb_name = clone.transform:FindChild("LabelName"):GetComponent("UILabel");
			local lb_desc = clone.transform:FindChild("Label-desc"):GetComponent("UILabel");
			local button = clone.transform:FindChild("Button_buy").gameObject;

			sp_icon.spriteName = v.SpriteName;
			lb_name.text = v.Name;
			lb_price.text = cardData[k].price;
			this.mono:AddClick(button, this.Buy);
			lb_desc.text = "";
			allShopItem[k] = {id = k,name = v.Name,price = cardData[k].price};
		end
	end
	grid_card:GetComponent('UIGrid').repositionNow = true;
	]]
end
function this.SetGold()
	-- body
	lb_coin.text = UIHelper.SetCoinStandard(LuaBagData.GetGold());
end
function this.Buy(go)
	-- body
	local item = allShopItem[tonumber(go.transform.parent.gameObject.name)];
	print(item.name);
	Panel_ConfirmFrame.SetInit("是否花费%d×"..item.price.."金币购买"..item.name, Enum.ConfirmFrameType.BuyItem,item);
	--Panel_ConfirmFrame.SetInit("当前兑换需要%d×"..this.fishSData.CombNum.."碎片，是否兑换？",Enum.ConfirmFrameType.Exchange,LuaBagData.GetItemByItemId(this.itemId));
	--BYResourceManager.Instance:CreateLuaPanel("UICommon","Panel_ConfirmFrame",true,this.ShowComfirmFrame);
	Panel_Follow.ShowConfirmFramePanel();

end
function this.OnBag( go )
	-- body
	print("Bag");
	--BYResourceManager.Instance:CreateLuaPanel("Panel_Bag","Panel_Bag",true);
	Panel_Follow.ShowBagPanel();
	Panel_Follow.AddRecPanel(this.gameObject);
	--destroy(this.gameObject);
end
function this.OnRecharge(  )
	Panel_Follow.ShowRechargePanel();
	Panel_Follow.AddRecPanel(this.gameObject);
end
function this.ShowComfirmFrame( ... )
	-- body
end
function this.Hide(  )
	-- body
	--Lua_UIHelper.UIHide(this.gameObject,true);
	--if Global.instance.isMobile == false then
	--	Panel_Follow.HidePanel(this.gameObject);
	--else
		this.gameObject:SetActive(false);
	--end
end
function this.LoadShopData()
	if(hasLoadItem == false) then
		
		UIHelper.ShowProgressHUD(nil,"");
		--武器
		local form = UnityEngine.WWWForm.New();
		form:AddField("kind",6);
		local  www = HttpConnect.Instance:HttpRequestWithSession(FKBYConnectDefine.SHOP_LIST_URL,form);
		coroutine.www(www);
		print("ShopData"..www.text);
		local js = cjson.decode(www.text);
		if(js["result"] == "ok") then
			hasLoadItem = true;
			local info = js["body"];
			for k,v in pairs(info) do
				local _id = v["id"];
				local _name = v["name"];
				local _price = v["price"];
				gunData[_id] = {id=_id,name = _name,price = _price};
			end
		end
		--道具
		form = UnityEngine.WWWForm.New();
		form:AddField("kind",7);
		www = HttpConnect.Instance:HttpRequestWithSession(FKBYConnectDefine.SHOP_LIST_URL,form);
		coroutine.www(www);
		print(www.text);
		local js = cjson.decode(www.text);
		if(js["result"] == "ok") then
			local info = js["body"];
			for k,v in pairs(info) do
				local _id = v["id"];
				local _name = v["name"];
				local _price = v["price"];
				itemData[_id] = {id=_id,name = _name,price = _price};
			end
		end
		--券卡
		form = UnityEngine.WWWForm.New();
		form:AddField("kind",8);
		www = HttpConnect.Instance:HttpRequestWithSession(FKBYConnectDefine.SHOP_LIST_URL,form);
		coroutine.www(www);
		print(www.text);
		local js = cjson.decode(www.text);
		if(js["result"] == "ok") then
			local info = js["body"];
			for k,v in pairs(info) do
				local _id = v["id"];
				local _name = v["name"];
				local _price = v["price"];
				cardData[_id] = {id=_id,name = _name,price = _price};
			end
		end
		UIHelper.HideProgressHUD();
	end
		this.CreatItem();
end
function this.OnDestroy(  )
	-- body
	Event.RemoveListener(Enum.EventType.EventGoldChange,this.SetGold);
end