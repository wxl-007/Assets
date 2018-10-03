local this = LuaObject:New();
Panel_FarmMyFish = this;

local go_fishItem;
local grid_fishItem;
--local go_compFishItem;
--local grid_compFish;
local button_close;
local lb_diamond;

--合成
local sp_needIcon;
local lb_needNum;
local lb_name;
local button_next;
local button_back;
local button_comp

local sp_target1;
local lb_prob_target1;

local sp_target2;
local lb_prob_target2;

local sp_target3;
local lb_prob_target3;

local allId = {};
local curId;
local minId = 0;
local maxId = 0;

--合成成功
local compoundSucceedPoup;
local sp_compoundFish;
local button_closeSucced;
--合成失败
local compoundFail;
local  button_closeFail;



local myFishs = {};

local Enum = require "GameFKBY/Enum";
require "System/Coroutine";
require "GameFKBY/View/Panel_MoreInfo";
require "GameFKBY/View/Panel_MakeFish";
local Event = require "events";

local FishData = ConfigData.FishData();
local FishMakeData = ConfigData.FishMakeData();
function this.Awake()
	--this.gameObject = obj;
	--this.transform = obj.transform;
	print("panel_Shop lua Awake");
	this.InitPanel();
end
function this.Start()
	-- body
	--Lua_UIHelper.UIShow(this.gameObject);
end
function this.OnEnable(  )
	coroutine.start(LuaBagData.LoadData,Enum.ItemType.Fish,this.Create);
end
--初始化面板--
function this.InitPanel()
	go_fishItem = this.transform:FindChild("Content 1/Container/Panel/Grid/MyFishItem").gameObject;
	grid_fishItem = go_fishItem.transform.parent.gameObject;
	--go_compFishItem = this.transform:FindChild("Content 2/Container/Panel/Grid/Item_fishmake").gameObject;
	--grid_compFish = go_compFishItem.transform.parent.gameObject;
	button_close = this.transform:FindChild("Button_close").gameObject;
	this.mono:AddClick(button_close,this.Hide);
	lb_diamond = this.transform:FindChild("Content 2/box4/COIN"):GetComponent("UILabel");
	this.SetDiamond(LuaBagData.GetDiamond());
	Event.AddListener(Enum.EventType.EventDiamondChange,this.SetDiamond);
	Event.AddListener(Enum.EventType.EventBagItemChange,this.SetItemNum);

	sp_needIcon = this.transform:FindChild("Content 2/Sprite-needFishIcon"):GetComponent("UISprite");
	lb_needNum = this.transform:FindChild("Content 2/Label-needNum"):GetComponent("UILabel");
	lb_name = this.transform:FindChild("Content 2/Label-name"):GetComponent("UILabel");
	button_next	= this.transform:FindChild("Content 2/bt-next").gameObject;
	button_back = this.transform:FindChild("Content 2/bt-back").gameObject;

	sp_target1 = this.transform:FindChild("Content 2/Sprite-icon1"):GetComponent("UISprite");
	sp_target2 = this.transform:FindChild("Content 2/Sprite-icon2"):GetComponent("UISprite");
	sp_target3 = this.transform:FindChild("Content 2/Sprite-icon3"):GetComponent("UISprite");

	lb_prob_target1 = this.transform:FindChild("Content 2/Sprite-icon1/Label-prob"):GetComponent("UILabel");
	lb_prob_target2 = this.transform:FindChild("Content 2/Sprite-icon2/Label-prob"):GetComponent("UILabel");
	lb_prob_target3 = this.transform:FindChild("Content 2/Sprite-icon3/Label-prob"):GetComponent("UILabel");

	button_comp = this.transform:FindChild("Content 2/Button_Comp").gameObject;

	compoundSucceedPoup = this.transform:FindChild("Content 2/CompoundSucceedPoup").gameObject;
	sp_compoundFish = this.transform:FindChild("Content 2/CompoundSucceedPoup/Sprite-icon"):GetComponent("UISprite");
	button_closeSucced = this.transform:FindChild("Content 2/CompoundSucceedPoup/succeedCollider").gameObject;
	compoundFail = this.transform:FindChild("Content 2/CompoundFail").gameObject;
	button_closeFail = this.transform:FindChild("Content 2/CompoundFail/failCollider").gameObject;

	this.mono:AddClick(button_next,this.OnNext);
	this.mono:AddClick(button_back,this.OnNext);
	this.mono:AddClick(button_comp,this.OnComp);

	this.mono:AddClick(button_closeFail,this.OnClosePoup);
	this.mono:AddClick(button_closeSucced,this.OnClosePoup);
	--设置表最大和最小id
	allId = {};
	for k,v in Lua_UIHelper.pairsByKeys(ConfigData.FishMakeData()) do 
		allId[#allId+1] = v;
	end
	minId = 1;
	maxId = #allId;
	--初始化合成界面
	curId = minId;


end
function this.Create()
	--初始化鱼的合成界面
	this.SetCompInfo(curId);
	--我收获的鱼儿
	if tableCount(LuaBagData.fishTable) ~= tableCount(myFishs) then
		for k, v in Lua_UIHelper.pairsByKeys(LuaBagData.fishTable) do
			local go = GameObject.Instantiate(go_fishItem);
			go.transform.parent = grid_fishItem.transform;
			go.transform.localScale =Vector3.one;
			go.transform.localPosition = Vector3.zero;
			go.name = k;
			go:SetActive(true);
			this.mono:AddClick(go,this.MoreInfo);
			
			local lb_name = go.transform:FindChild("LabelName"):GetComponent("UILabel");
			local lb_num = go.transform:FindChild("Contents/LabelNumber"):GetComponent("UILabel");
			local lb_type = go.transform:FindChild("Contents/LabelType"):GetComponent("UILabel");
			local lb_price = go.transform:FindChild("Contents/LabelPrice"):GetComponent("UILabel");
			local sp_icon = go.transform:FindChild("FishIcon"):GetComponent("UISprite");

			myFishs[k] = {name = lb_name , num = lb_num,ftype = lb_type,price = lb_price,icon = sp_icon,gameObject = go};

			lb_name.text = FishData[k].FishName;
			lb_num.text = v.num;
			lb_type.text = FishData[k].FishType;
			lb_price.text = FishData[k].Price;
			sp_icon.spriteName = FishData[k].SpriteName;
			Lua_UIHelper.MakePixelPerfect(sp_icon,FishData[k].SpriteScale * 0.8);
			--sp_icon:MakePixelPerfect();
		end
		grid_fishItem:GetComponent('UIGrid').repositionNow = true;
	else
		--刷新数据
		for k, v in Lua_UIHelper.pairsByKeys(LuaBagData.fishTable) do
			if myFishs[k] ~= nil then
				myFishs[k].name.text = FishData[k].FishName;
				myFishs[k].num.text = v.num;
				myFishs[k].ftype.text = FishData[k].FishType;
				myFishs[k].price.text = FishData[k].Price;
				myFishs[k].icon.spriteName = FishData[k].SpriteName;
				Lua_UIHelper.MakePixelPerfect(myFishs[k].icon,FishData[k].SpriteScale * 0.8);
			end
		end
	end

	--可合成的鱼
	--[[
	for k,v in Lua_UIHelper.pairsByKeys(FishMakeData) do
		local go = GameObject.Instantiate(go_compFishItem);
		go.transform.parent = grid_compFish.transform;
		go.transform.localScale =Vector3.one;
		go.transform.localPosition = Vector3.zero;
		go.name = k;
		go:SetActive(true);
		this.mono:AddClick(go,this.MakeFish);

		local lb_name = go.transform:FindChild("LabelName"):GetComponent("UILabel");
		local sp_icon = go.transform:FindChild("FishIcon"):GetComponent("UISprite");
		local lb_needDiamond = go.transform:FindChild("Contents/Label1"):GetComponent("UILabel");
		local lb_needFish = go.transform:FindChild("Contents/Label2"):GetComponent("UILabel");


		lb_name.text = v.MakeFishName;
		lb_needDiamond.text = "晶石×"..v.NeedDiamondNum;
		lb_needFish.text = v.NeedFishName.."×".. v.NeedFishNum;
		sp_icon.spriteName = FishData[k].SpriteName;
		Lua_UIHelper.MakePixelPerfect(sp_icon,FishData[k].SpriteScale * 0.8);
		--sp_icon:MakePixelPerfect();
	end
	grid_compFish:GetComponent('UIGrid').repositionNow = true;
	]]
end
function this.SetCompInfo( id )
	-- body
	local data = allId[id]
	sp_needIcon.spriteName = data.Name;
	sp_needIcon:MakePixelPerfect();
	lb_needNum.text	= data.Num.."/"..LuaBagData.GetItemNumByItemId(data.Id);
	lb_name.text = data.Name;

	local target1 = ConfigData.FishData(data.Target1);
	sp_target1.spriteName = target1.SpriteName;
	Lua_UIHelper.MakePixelPerfect(sp_target1,0.5);
	lb_prob_target1.text = data.Prob1.."%";

	local target2 = ConfigData.FishData(data.Target2);
	sp_target2.spriteName = target2.SpriteName;
	Lua_UIHelper.MakePixelPerfect(sp_target2,0.5);
	lb_prob_target2.text = data.Prob2.."%";

	local target3 = ConfigData.FishData(data.Target3);
	sp_target3.spriteName = target3.SpriteName;
	Lua_UIHelper.MakePixelPerfect(sp_target3,0.5);
	lb_prob_target3.text = data.Prob3.."%";

end
--合成
function this.OnComp()
	--发送合成消息
	if LuaBagData.GetItemNumByItemId(allId[curId].Id) >= allId[curId].Num then
		SocketMessage.SendCompFishMessage(allId[curId].Id);
	else
		UIHelper.ShowMessage("道具不足",2);
	end
end
function this.OnClosePoup(go)
	-- body
	if go.name == button_closeFail.name then
		Lua_UIHelper.UIHide(compoundFail,false);
	elseif go.name == button_closeSucced.name then
		Lua_UIHelper.UIHide(compoundSucceedPoup,false);
	end
end
function this.SetDiamond(num)
	-- body
	lb_diamond.text = num;
end
function this.SetItemNum( id,num )
	if allId[curId]~=nil and id == allId[curId].Id then
		lb_needNum.text = allId[curId].Num.."/"..LuaBagData.GetItemNumByItemId(allId[curId].Id);
	end
end
function this.MoreInfo(go)
	-- body
	Panel_MoreInfo.SetValue(FishData[tonumber(go.name)]);
	FKBY_GameFarm.ShowMoreFishInfoPanel();
	Panel_Follow.AddRecPanel(this.gameObject);
end
function this.MakeFish(go)
	-- body
	print(FishMakeData[tonumber(go.name)].MakeFishName);
	Panel_MakeFish.SetValue(FishMakeData[tonumber(go.name)]);
	BYResourceManager.Instance:CreateLuaPanel("Panel_MakeFish","Panel_MakeFish",true);
	destroy(this.gameObject);
end
function this.OnNext( go )
	-- body
	if go.name == button_next.name then
		--下一个
		if curId < maxId then
			curId = curId +1;
		else
			curId = minId;
		end
		print(curId);
		this.SetCompInfo(curId);
	else
		--上一个
		if curId > minId then
			curId = curId -1;
		else
			curId = maxId;
		end
		print(curId);
		this.SetCompInfo(curId);
	end
end
function this.CompoundSucceed(fishItemId)
	-- body
	compoundSucceedPoup:SetActive(true);
	Lua_UIHelper.UIShow(compoundSucceedPoup);
	sp_compoundFish.spriteName = ConfigData.FishData(fishItemId).SpriteName;
	sp_compoundFish:MakePixelPerfect();
	coroutine.start(this.OnHidePoup,true);

end
function this.CompoundFail( )
	compoundFail:SetActive(true);
	Lua_UIHelper.UIShow(compoundFail);
	coroutine.start(this.OnHidePoup,false);
end
function this.OnHidePoup(succeed)
	-- body
	coroutine.wait(3);
	if succeed == false then
		Lua_UIHelper.UIHide(compoundFail,false);
	else
		Lua_UIHelper.UIHide(compoundSucceedPoup,false);
	end
end
function this.Hide()
	--if Global.instance.isMobile == false then
    --    Panel_Follow.HidePanel(this.gameObject);
    --else
        this.gameObject:SetActive(false);
    --end
end
function this.OnDestroy(  )
	-- body
	Event.RemoveListener(Enum.EventType.EventDiamondChange,this.SetDiamond)
	Event.RemoveListener(Enum.EventType.EventBagItemChange,this.SetItemNum);
end