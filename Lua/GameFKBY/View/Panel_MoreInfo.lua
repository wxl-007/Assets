local this = LuaObject:New()
Panel_MoreInfo = this;

local lb_name;
local lb_type;
local lb_price;
local lb_cycle;
local lb_production;
local lb_compoundFish;
local lb_desc;
local lb_num;
local sp_icon;
local button_sale;
local button_close;

local fishData;

require "GameFKBY/View/Panel_ConfirmFrame";
local Enum = require "GameFKBY/Enum";
local Event = require "events";

function this.Awake()
	this.InitPanel();
end
function this.Start()
	-- body
	--Lua_UIHelper.UIShow(this.gameObject);
end
function this.SetValue(data)
	-- body
	fishData = data;
end
function this.OnEnable()
	this.Init();
end
--初始化面板--
function this.InitPanel()
	lb_name = this.transform:FindChild("Label-name"):GetComponent("UILabel");
	lb_type = this.transform:FindChild("Label-type"):GetComponent("UILabel");
	lb_price = this.transform:FindChild("Label-price"):GetComponent("UILabel");
	lb_cycle = this.transform:FindChild("Label-cycle"):GetComponent("UILabel");
	lb_production = this.transform:FindChild("Label-production"):GetComponent("UILabel");
	lb_compoundFish = this.transform:FindChild("Label-compoundFish"):GetComponent("UILabel");
	lb_desc = this.transform:FindChild("Label-desc"):GetComponent("UILabel");
	lb_num = this.transform:FindChild("Label-num"):GetComponent("UILabel");
	sp_icon = this.transform:FindChild("Sprite-icon"):GetComponent("UISprite");
	button_sale = this.transform:FindChild("Button_sale").gameObject;
	button_close = this.transform:FindChild("Button_close").gameObject;
	this.mono:AddClick(button_sale,this.OnSale);
	this.mono:AddClick(button_close,this.Hide);

	Event.AddListener(Enum.EventType.EventBagItemChange,this.SetNum)
	--this.Init();

end
function this.Init()
	-- body
	local item = LuaBagData.fishTable[fishData.ID];
	lb_name.text = fishData.FishName;
	lb_type.text ="[b]"..fishData.FishType;
	lb_price.text = "[b]"..fishData.Price;
	lb_cycle.text = "[b]"..fishData.GrowCyle;
	lb_production.text = "[b]".."金币，碎片";
	lb_compoundFish.text = "[b]".."鱼，鱼";
	lb_desc.text = "[b]".."这是一条鱼！！";
	this.SetNum(item.id,item.num);
	sp_icon.spriteName = fishData.SpriteName;
	sp_icon:MakePixelPerfect();
end
function this.OnSale( )
	-- body
	Panel_ConfirmFrame.SetInit("回收可获得%d×"..fishData.Price.."金币，是否回收？",Enum.ConfirmFrameType.SaleFish,fishData);
	--if(comfirmFrame == nil) then
	--BYResourceManager.Instance:CreateLuaPanel("UICommon","Panel_ConfirmFrame",true);
	Panel_Follow.ShowConfirmFramePanel();

end
function this.Hide( )
	-- body
	--Lua_UIHelper.UIHide(this.gameObject,true);
	Panel_Follow.HidePanel(this.gameObject);
end
function this.SetNum(itemId,itemNum)
	-- body
	lb_num.text = itemNum;
end
function this.OnDestroy()
	-- body
	this.mono:ClearClick();
	Event.RemoveListener(Enum.EventType.EventBagItemChange,this.SetNum);
end