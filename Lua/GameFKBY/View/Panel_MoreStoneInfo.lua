local this = LuaObject:New()
Panel_MoreStoneInfo = this

local lb_name;
local lb_num;
local lb_price;
local lb_get;
local lb_desc;
local sp_icon;
local bt_sale;
local bt_make;
local bt_close;

local fishSData;

local comfirmFrame;
require "GameFKBY/Lua_UIHelper";
local FishStoneData = require "Config/FishStoneData";
require "GameFKBY/LuaBagData";
require "GameFKBY/View/Panel_ConfirmFrame";
local Event = require "events";
local Enum = require "GameFKBY/Enum";
--启动事件--
function this:Awake()
	--this.gameObject = obj;
	--this.transform = obj.transform;

	this.InitPanel();
	--warn("Awake lua--->>"..gameObject.name);
end
function this.OnEnable(  )
	this.Init();
end
local itemId = 0;
--初始化面板--
function this.InitPanel()
	lb_name = this.transform:FindChild("Label-name"):GetComponent("UILabel");
	lb_num = this.transform:FindChild("Label-num"):GetComponent("UILabel");
	lb_price = this.transform:FindChild("Label-price"):GetComponent("UILabel");
	lb_get = this.transform:FindChild("Label-gat"):GetComponent("UILabel");
	lb_desc = this.transform:FindChild("Label-desc"):GetComponent("UILabel");
	sp_icon = this.transform:FindChild("Sprite-icon"):GetComponent("UISprite");
	bt_sale = this.transform:FindChild("Button_sale").gameObject;
	bt_make = this.transform:FindChild("Button_make").gameObject;
	bt_close = this.transform:FindChild("Button_close").gameObject;
	this.mono:AddClick(bt_sale, this.OnSale);
	this.mono:AddClick(bt_make,this.OnMake);
	this.mono:AddClick(bt_close,this.OnHide);
	--this.Init();
	Event.AddListener(Enum.EventType.EventBagItemChange,this.ItemChange)

end
function this.ItemChange(_itemId,itemNum)
	if itemId == _itemId then
		lb_num.text = itemNum;
	end
end	
function this.SetItem(_itemId)
	-- body
	itemId = _itemId;
end
function this.Init()
	-- body
	fishSData = FishStoneData[itemId];
	lb_name.text = "[b]"..fishSData.Name;	
	lb_get.text = fishSData.Gain;
	lb_price.text = fishSData.RecyclePrice;
	sp_icon.spriteName = fishSData.SpriteName;
	if(LuaBagData.fishStoneTable[itemId] ~= nil) then
		lb_num.text = LuaBagData.fishStoneTable[itemId].num;
	elseif(LuaBagData.gunStoneTable[itemId] ~= nil) then
		lb_num.text = LuaBagData.gunStoneTable[itemId].num;
	end
	sp_icon:MakePixelPerfect();
	lb_desc.text = fishSData.Special;
end
function  this.Start()
	-- body
		--this.OnShow();
end

--单击事件--
function this.OnDestroy()
	Event.RemoveListener(Enum.EventType.EventBagItemChange,this.ItemChange);
end
function this.OnSale(go)
	-- body
	--回收
	Panel_ConfirmFrame.SetInit("回收可获得%d×"..fishSData.RecyclePrice.."金币，是否回收？",Enum.ConfirmFrameType.SaleFishStone,fishSData);
	--if(comfirmFrame == nil) then
		--BYResourceManager.Instance:CreateLuaPanel("UICommon","Panel_ConfirmFrame",true,this.ShowComfirmFrame);
		Panel_Follow.ShowConfirmFramePanel();
	--else
	--	comfirmFrame:SetActive(true);
	--	Lua_UIHelper.UIShow(comfirmFrame);
	--end
end
function this.ShowComfirmFrame(go)
	-- body
	comfirmFrame = go;
	Lua_UIHelper.UIShow(go);
end
function this.OnMake(go)
	-- body
	--兑换
	--web端
	Panel_ConfirmFrame.SetInit("当前兑换需要%d×"..fishSData.CombNum.."碎片，是否兑换？",Enum.ConfirmFrameType.Exchange,LuaBagData.GetItemByItemId(itemId));
	--BYResourceManager.Instance:CreateLuaPanel("UICommon","Panel_ConfirmFrame",true,this.ShowComfirmFrame);
	Panel_Follow.ShowConfirmFramePanel()
	--鱼池端
end
function this.OnShow()
	-- body
	--iTween.ScaleFrom(gameObject, iTween.Hash("scale",Vector3.New(0.8,0.8,0.8),"speed",0.4,"easeType", iTween.EaseType.IntToEnum(27)));
	Lua_UIHelper.UIShow(this.gameObject);
end
function this.OnHide()
	-- body
	--Lua_UIHelper.UIHide(this.gameObject,true);
	Panel_Follow.HidePanel(this.gameObject);
end
function this.Destroy()
	-- body
	destroy(this.gameObject);
end