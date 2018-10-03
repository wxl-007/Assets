
local this = LuaObject:New()
FKBY_GameFarm = this

local button_bag;
local button_shop;
local button_myFish;
local button_feed; -- 一键喂鱼
local button_tool; -- 工具箱
local button_collect; --一键收宝
local button_upgradeFarmSize; --扩建鱼场所
local button_Recharge; --充值金币
local button_PlusDiamond; --购买钻石
local button_rank; --排行榜
local button_setting;--设置
local button_help;--帮助

local panel_black;
local panel_myFish;
local panel_saleFishRank;
local panel_extend;
local panel_help;
local panel_moreInfo;


local foods = {};
local panel_tool;

local sp_mouseSight;--鼠标图标

local fishBarItem; -- 鱼状态图标
local lb_level; --等级
local lb_exp;--经验
local progress_farmSize;--容量条
local progress_farmExp;--经验条
local lb_farmSize;--容量


local lb_diamond;
local lb_gold;

local panel_lvUp;
local lb_lvUp;
local sprite_icon;
require "GameFKBY/View/Panel_Bag";
require "GameFKBY/View/Panel_Shop";
require "GameFKBY/View/Panel_FarmMyFish";
require "GameFKBY/FishingFarmMaster";
require "GameFKBY/View/Panel_FarmExtend";
require "GameFKBY/View/Panel_FishsState";
local Enum = require "GameFKBY/Enum";
local Event = require "events";

function this.Awake()
	print("------------------awake of GameFarm-------------")
end

function this.Start( )
	-- body
	print("------------------start of GameFarm-------------")
	--GameObject.Find("UI Root/Panel_FishsState"):AddComponent("SimpleFramework.LuaBehaviour");
	button_bag = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_bag");
	button_shop = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_marketing");
	button_myFish = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_fish");
	button_feed = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_arrow1/Button_feed");
	button_tool = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_tool");
	button_collect = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_arrow1/Button_collect");
	button_upgradeFarmSize = GameObject.Find("UI Root/Panel_Game/Panel_Top/FarmSize/Button_UpgradeFarmSize");
	button_Recharge = GameObject.Find("UI Root/Panel_Game/Panel_Top/GoldBar/Button_plusGold");
	button_PlusDiamond = GameObject.Find("UI Root/Panel_Game/Panel_Top/DiamondBar/Button_plusDiamond");
	button_rank = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_ranking");
	button_setting = GameObject.Find("UI Root/Panel_Game/Panel_Left/Button_setting");
	button_help = GameObject.Find("UI Root/Panel_Game/Panel_Left/Button_help");

	panel_lvUp = GameObject.Find("UI Root/Panel_Game/LevelUp");
	lb_lvUp = panel_lvUp.transform:FindChild("Label-lv"):GetComponent("UILabel");


	sp_mouseSight = GameObject.Find("UI Root/Panel_Game/MouseTexture"):GetComponent("UISprite");
	--喂食
	local foodParen = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_tool/Panel_Slliao");
	for i = 1,4,1 do
		_button = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_tool/Panel_Slliao/"..i);
		sprite = _button:GetComponent("UISprite");
		label = _button.transform:FindChild("LabelQty"):GetComponent("UILabel");
		foods[i] = {button = _button,sp_icon = sprite,lb_num = label};
		this.mono:AddClick(_button,this.OnFoods);
	end
	panel_tool = GameObject.Find("UI Root/Panel_Game/Panel_Bottom/Button_tool/Panel_Slliao");

	fishBarItem = GameObject.Find("UI Root/Panel_Game/Panel_FIshUI/FishUI/FishBarItem");

	--添加按钮事件
	this.mono:AddClick(button_bag,this.OnButtonEvent);
	this.mono:AddClick(button_shop,this.OnButtonEvent);
	this.mono:AddClick(button_myFish,this.OnButtonEvent);
	this.mono:AddClick(button_feed,this.OnButtonEvent);
	this.mono:AddClick(button_tool,this.OnButtonEvent);
	this.mono:AddClick(button_collect,this.OnButtonEvent);
	this.mono:AddClick(button_upgradeFarmSize,this.OnButtonEvent);
	this.mono:AddClick(button_Recharge,this.OnButtonEvent);
	this.mono:AddClick(button_PlusDiamond,this.OnButtonEvent);
	this.mono:AddClick(button_rank,this.OnButtonEvent);
	--暂时注释掉
	this.mono:AddClick(button_setting,this.OnButtonEvent);
	--this.mono:AddClick(button_help,this.OnButtonEvent);
	this.mono:AddClick(button_add,this.OnButtonEvent);
	this.mono:AddClick(sprite_icon,this.OnButtonEvent);

	this.mono:AddHover(button_feed,this.OnHoverEvent);
	this.mono:AddHover(button_collect,this.OnHoverEvent);

	this.mono:AddHover(button_bag,this.OnHoverEvent);
	this.mono:AddHover(button_shop,this.OnHoverEvent);
	this.mono:AddHover(button_myFish,this.OnHoverEvent);
	this.mono:AddHover(button_tool,this.OnHoverEvent);
	this.mono:AddHover(button_rank,this.OnHoverEvent);

	lb_level = GameObject.Find("UI Root/Panel_Game/Panel_Top/Level/LabelText"):GetComponent("UILabel");
	lb_exp = GameObject.Find("UI Root/Panel_Game/Panel_Top/Level/Sprite/Label-exp"):GetComponent("UILabel");
	progress_farmExp = GameObject.Find("UI Root/Panel_Game/Panel_Top/Level/Progress Bar (1)"):GetComponent("UISlider");
	progress_farmSize = GameObject.Find("UI Root/Panel_Game/Panel_Top/FarmSize/Progress Bar"):GetComponent("UISlider");
	lb_farmSize = GameObject.Find("UI Root/Panel_Game/Panel_Top/FarmSize/LabelSize"):GetComponent("UILabel");
	
	lb_diamond = GameObject.Find("UI Root/Panel_Game/Panel_Top/DiamondBar/Icon/LabelText"):GetComponent("UILabel");
	lb_gold = GameObject.Find("UI Root/Panel_Game/Panel_Top/GoldBar/LabelText "):GetComponent("UILabel");
	coroutine.start(LuaBagData.LoadData,Enum.ItemType.Diamond,this.SetDiamond);
	--this.SetDiamond(LuaBagData.GetDiamond());
	this.SetGold(LuaBagData.GetGold());


	--事件监听
	Event.AddListener(Enum.EventType.EventDiamondChange,this.SetDiamond);
	Event.AddListener(Enum.EventType.EventGoldChange,this.SetGold);
	Event.AddListener(Enum.EventType.EventFarmExpChange,this.OnFarmExpChanged);
	Event.AddListener(Enum.EventType.EventFarmLevelChange,this.OnFarmLevelChanged);
	Event.AddListener(Enum.EventType.EventFarmSizeChange,this.OnFarmSizeChanged);
	Event.AddListener(Enum.EventType.EventFarmSizeLvChange,this.OnFarmSizeLvChanged);
	Event.AddListener(Enum.EventType.EventBagItemChange,this.OnItemChanged);

	local prefab = BYResourceManager.LoadNeedAsset("Map", "Map/map04.prefab");
    local scene = GameObject.Instantiate(prefab);
end
function this.OnEnable( ... )
	-- body
	sprite_icon = GameObject.Find("UI Root/Panel_Game/uInfos/Avatar/Panel/Sprite_icon");
	local label_lv = GameObject.Find("UI Root/Panel_Game/uInfos/Avatar/Sprite_lv/Lv"):GetComponent("UILabel");
	local user = EginUser.Instance;
	if user.avatarNo < 1 then user.avatarNo = 1;end
	sprite_icon:GetComponent("UISprite").spriteName = "avatar_"..user.avatarNo;
	label_lv.text = tostring(user.level);
end
function this.GetFishBarItem()
	-- body
		return fishBarItem;
end
function this.Update()
	if(UICamera.isOverUI == true) then
		UnityEngine.Cursor.visible = true;
		if(sp_mouseSight.gameObject.activeSelf == true) then
			sp_mouseSight.gameObject:SetActive(false);
		end
	else
		if(FishingFarmMaster.MouseState() ~= Enum.FarmMouseState.Normal) then
			UnityEngine.Cursor.visible = false;
			if(sp_mouseSight.gameObject.activeSelf == false) then
				sp_mouseSight.gameObject:SetActive(true);
			end
			local ms = UICamera.mainCamera:ScreenToWorldPoint(Input.mousePosition);
			sp_mouseSight.transform.position = ms;
		else
			UnityEngine.Cursor.visible = true;
			if(sp_mouseSight.gameObject.activeSelf == true) then
				sp_mouseSight.gameObject:SetActive(false);
			end
		end
	end
	FishingFarmMaster.TouchListener();
end
local last_effect = nil;
function this.OnHoverEvent( go,state)
	local effect = nil;
	if go.name == button_collect.name or go.name == button_feed.name then
		effect = go.transform:FindChild("UIUI");
	else
		effect = go.transform:FindChild("di");
	end
	if state == true then
		if effect ~= nil then
			if last_effect ~= nil then
				if last_effect ~= effect then
					effect.gameObject:SetActive(true);
					last_effect.gameObject:SetActive(false);
				end
			else
				effect.gameObject:SetActive(true);
			end
			last_effect = effect;
		end
	else
		if last_effect ~= nil then 
			last_effect.gameObject:SetActive(false);
			last_effect = nil;
		end
	end
	
end
function this.OnButtonEvent(button)
	-- body
	print("panel_GameFarm.lua");
	if(button.name == button_bag.name) then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Bag","Panel_Bag",true);
		--Panel_Follow.ShowBagPanel();
		Panel_Follow.ShowBagPanel();
	elseif(button.name == button_shop.name) then
		Panel_Follow.ShowShopPanel();
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Shop","Panel_Shop",true);
	elseif(button.name == button_myFish.name) then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_FarmMyFish","Panel_FarmMyFish",true);
		this.ShowMyFishPanel();
	elseif(button.name == button_feed.name) then
		print("feed");
		--发送一键喂鱼消息
		SocketMessage.SendFeedAllFishMessage();
	elseif(button.name == button_tool.name) then
		print("tool");
		if (panel_tool.activeSelf == true) then
            panel_tool:SetActive(false);
        else
            panel_tool:SetActive(true);
            --发送消息获取鱼食数据
            coroutine.start(LuaBagData.LoadData,Enum.ItemType.FishFood,this.BindLabelsSiliao);
            --StartCoroutine(BagData.LoadItemData(ItemType.FishFood, () => BindLabelsSiliao()));
        end
	elseif(button.name == button_collect.name) then
		print("collect");
		--发送一键收宝消息
		SocketMessage.SendGetAllOutPutMessage();
	elseif(button.name == button_upgradeFarmSize.name) then
		print("upgradeFarmSize");
		--BYResourceManager.Instance:CreateLuaPanel("Panel_FarmExtend","Panel_FarmExtend",true);
		this.ShowExtendPanel();
	elseif(button.name == button_Recharge.name) then
		print("recharge");
		Panel_Follow.ShowShopPanel();
	elseif(button.name == button_PlusDiamond.name) then
		print("plusDiamond");
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Shop","Panel_Shop",true);
		Panel_Follow.ShowShopPanel();
	elseif(button.name == button_rank.name) then
		print("rank");
		--BYResourceManager.Instance:CreateLuaPanel("Panel_FarmRank","Panel_FarmRank",true);
		this.ShowRankPanel();
	elseif(button.name == button_setting.name) then
		print("setting");
		Panel_Follow.ShowSettingPanel();
	elseif(button.name == button_help.name) then
		print("help");
	elseif button.name == sprite_icon.name then
		Panel_Follow.ShowPersonalPanel();
	end
end
function this.OnFoods( go )
	-- body
	if(go.name == foods[1].button.name) then
		if(FishingFarmMaster.MouseState() ~= Enum.FarmMouseState.FeedCommon) then
			FishingFarmMaster.ChangeMouseState(Enum.FarmMouseState.FeedCommon);
			sp_mouseSight.spriteName = "yu_siliao3";
			this.SetSiliaoSprite(1);
		else
			FishingFarmMaster.ChangeMouseState(Enum.FarmMouseState.Normal);
			this.SetSiliaoSprite(0);
		end
	elseif(go.name == foods[2].button.name) then
		if(FishingFarmMaster.MouseState() ~= Enum.FarmMouseState.FeedValuable) then
			FishingFarmMaster.ChangeMouseState(Enum.FarmMouseState.FeedValuable);
			sp_mouseSight.spriteName = "yu_siliao1";
			this.SetSiliaoSprite(2);
		else
			FishingFarmMaster.ChangeMouseState(Enum.FarmMouseState.Normal);
			this.SetSiliaoSprite(0);
		end
	elseif(go.name == foods[3].button.name) then
		if(FishingFarmMaster.MouseState() ~= Enum.FarmMouseState.FeedRarely) then
			FishingFarmMaster.ChangeMouseState(Enum.FarmMouseState.FeedRarely);
			sp_mouseSight.spriteName = "yu_siliao7";
			this.SetSiliaoSprite(3);
		else
			FishingFarmMaster.ChangeMouseState(Enum.FarmMouseState.Normal);
			this.SetSiliaoSprite(0);
		end
	elseif(go.name == foods[4].button.name) then
		if(FishingFarmMaster.MouseState() ~= Enum.FarmMouseState.FeedHighest) then
			FishingFarmMaster.ChangeMouseState(Enum.FarmMouseState.FeedHighest);
			sp_mouseSight.spriteName = "yu_siliao5";
			this.SetSiliaoSprite(4);
		else
			FishingFarmMaster.ChangeMouseState(Enum.FarmMouseState.Normal);
			this.SetSiliaoSprite(0);
		end
	end
end
function this.BindLabelsSiliao()
	-- body
	local id = 2077;
	for i = 1,4,1 do 
		local num = LuaBagData.GetItemNumByItemId(id);
		id = id + 1;
		foods[i].lb_num.text = num;
	end
end
function this.SetSiliaoSprite(num)
	-- body
	if(num == 0) then
		foods[1].sp_icon.spriteName = "yu_siliao4";
		foods[2].sp_icon.spriteName = "yu_siliao2";
		foods[3].sp_icon.spriteName = "yu_siliao8";
		foods[4].sp_icon.spriteName = "yu_siliao6";
	elseif(num == 1) then
		foods[1].sp_icon.spriteName = "si_l_k";
		foods[2].sp_icon.spriteName = "yu_siliao2";
		foods[3].sp_icon.spriteName = "yu_siliao8";
		foods[4].sp_icon.spriteName = "yu_siliao6";
	elseif(num == 2) then
		foods[1].sp_icon.spriteName = "yu_siliao4";
		foods[2].sp_icon.spriteName = "si_l_k1";
		foods[3].sp_icon.spriteName = "yu_siliao8";
		foods[4].sp_icon.spriteName = "yu_siliao6";
	elseif(num == 3) then
		foods[1].sp_icon.spriteName = "yu_siliao4";
		foods[2].sp_icon.spriteName = "yu_siliao2";
		foods[3].sp_icon.spriteName = "si_l_k2";
		foods[4].sp_icon.spriteName = "yu_siliao6";
	elseif(num == 4) then
		foods[1].sp_icon.spriteName = "yu_siliao4";
		foods[2].sp_icon.spriteName = "yu_siliao2";
		foods[3].sp_icon.spriteName = "yu_siliao8";
		foods[4].sp_icon.spriteName = "si_l_k3";
	end
end
function this.SetDiamond(num)
	-- body
	if num ~= nil then
		lb_diamond.text = UIHelper.SetCoinStandard(num);
	else
		lb_diamond.text = LuaBagData.GetDiamond();
	end
end
function this.SetGold(num)
	lb_gold.text = UIHelper.SetCoinStandard(num);
end
function this.OnItemChanged(itemId , itemNum)
	-- body
	local itype = LuaBagData.GetItemTypeByItemId(itemId);
	print("GameFarm:"..itype);
	if itype == Enum.ItemType.FishFood then
		this.BindLabelsSiliao();
	elseif itype == Enum.ItemType.Fish then
		print("刷新我的鱼儿")
	end
end
function this.OnFarmLevelChanged(level)
    lb_level.text = "[b]" .. level;
end
function this.OnFarmExpChanged( exp )
	-- body
	print("SetExp");
	local lv = FishingFarmMaster.GetCurrentFarmLevel();
	if ConfigData.FishFarmData()[lv + 1] ~= nil then
		lv = lv + 1;
	end
	local needExp = ConfigData.FishFarmData(lv).NeedExp;
	print(needExp);
	progress_farmExp.value = exp/needExp;
	lb_exp.text = exp.."/"..needExp;
end
function this.OnFarmSizeChanged(total)
	print("SetSize");
	progress_farmSize.value = FishingFarmMaster.GetFishSpace()/ConfigData.FishFarmSizeData(FishingFarmMaster.GetCurrentFarmSizeLevel()).Size;
	lb_farmSize.text = FishingFarmMaster.GetFishSpace().."/"..ConfigData.FishFarmSizeData(FishingFarmMaster.GetCurrentFarmSizeLevel()).Size;
end
function this.OnFarmSizeLvChanged(lv)
	-- body
	print("SetSizeLv");
	progress_farmSize.value = FishingFarmMaster.GetFishSpace() / ConfigData.FishFarmSizeData(lv).Size;
	lb_farmSize.text = FishingFarmMaster.GetFishSpace().."/"..ConfigData.FishFarmSizeData(lv).Size;
end
function this.OnShowLvUp( lv )
	-- body
	lb_lvUp.text = lv;
	panel_lvUp:SetActive(true);

end
-------------------panel-----------------------

--我的鱼儿
function this.ShowMyFishPanel()
	if IsNil(panel_myFish) == false then
		Panel_Follow.ShowPanel(panel_myFish);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_FarmMyFish","Panel_FarmMyFish",true,this.SetMyFishPanel);
	end
end
function this.SetMyFishPanel( go )
	panel_myFish = go;
	Panel_Follow.ShowPanel(panel_myFish);
end

--出售排行榜
function this.ShowRankPanel(  )
	if IsNil(panel_saleFishRank) == false then
		Panel_Follow.ShowPanel(panel_saleFishRank);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_FarmRank","Panel_FarmRank",true,this.SetRankPanle);
	end
end
function this.SetRankPanle( go )
	panel_saleFishRank = go;
	Panel_Follow.ShowPanel(panel_saleFishRank);
end
--扩建鱼池
function this.ShowExtendPanel( )
	if IsNil(panel_extend) == false then
		Panel_Follow.ShowPanel(panel_extend);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_FarmExtend","Panel_FarmExtend",true,this.SetExtendPanel);
	end
end
function this.SetExtendPanel( go )
	panel_extend = go;
	Panel_Follow.ShowPanel(panel_extend);
end

--鱼的详细信息
function this.ShowMoreFishInfoPanel(  )
	if IsNil(panel_moreInfo) == false then
		Panel_Follow.ShowPanel(panel_moreInfo);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_MoreInfo","Panel_MoreInfo",true,this.SetMoreInfoPanel);
	end
end
function this.SetMoreInfoPanel( go )
	panel_moreInfo = go;
	Panel_Follow.ShowPanel(panel_moreInfo);
end



-----------------------------------------------


function this.OnDestroy()
	Event.RemoveListener(Enum.EventType.EventDiamondChange,this.SetDiamond);
	Event.RemoveListener(Enum.EventType.EventGoldChange,this.SetGold);
	Event.RemoveListener(Enum.EventType.EventFarmExpChange,this.OnFarmExpChanged);
	Event.RemoveListener(Enum.EventType.EventFarmLevelChange,this.OnFarmLevelChanged);
	Event.RemoveListener(Enum.EventType.EventFarmSizeChange,this.OnFarmSizeChanged);
	Event.RemoveListener(Enum.EventType.EventFarmSizeLvChange,this.OnFarmSizeLvChanged);
	Event.RemoveListener(Enum.EventType.EventBagItemChange,this.OnItemChanged);
	FishingFarmMaster.OnDestroy();
	--[[
	if IsNil(panel_myFish) == false then
		destroy(panel_myFish);
	end
	if IsNil(panel_saleFishRank) == false then
		destroy(panel_saleFishRank);
	end
	if IsNil(panel_extend) == false then
		destroy(panel_extend);
	end
	if IsNil(panel_help) == false then
		destroy(panel_help);
	end
	]]
end
