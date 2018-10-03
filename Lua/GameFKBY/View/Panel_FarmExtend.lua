local this = LuaObject:New()
Panel_FarmExtend = this;

local lb_curLv;
local lb_lv_bf;
local lb_lv_af;
local bt_extend;
local lb_needGold;
local curLv;
local bt_close;
local Enum = require "GameFKBY/Enum";
local Event = require "events";
function this.Awake()
	this.InitPanel();
end
function this.Start()
	-- body
	--Lua_UIHelper.UIShow(this.gameObject);
end
--初始化面板--
function this.InitPanel()
	lb_curLv = this.transform:FindChild("Label-Lv_cur"):GetComponent("UILabel");
	lb_lv_bf = this.transform:FindChild("Label-Lv_bf"):GetComponent("UILabel");
	lb_lv_af = this.transform:FindChild("Label-Lv_af"):GetComponent("UILabel");
	bt_extend = this.transform:FindChild("Button_extend").gameObject;
	lb_needGold = this.transform:FindChild("Label-nextGold"):GetComponent("UILabel");
	bt_close = this.transform:FindChild("Button_close").gameObject;

	this.mono:AddClick(bt_extend,this.OnExtend);
	this.mono:AddClick(bt_close,this.Hide);
	Event.AddListener(Enum.EventType.EventFarmSizeLvChange,this.Init);
	this.Init();
end
function this.Init()
	-- body
	curLv = FishingFarmMaster.GetCurrentFarmSizeLevel();
	lb_curLv.text = "Lv"..curLv;
	lb_lv_bf.text = "Lv"..curLv;
	local lv = curLv;
	if(lv<10) then
		lv = lv + 1;
	else lv = 10;
	end
	lb_lv_af.text = "Lv" .. lv;
	lb_needGold.text = ConfigData.FishFarmSizeData(lv).Money;
end
function this.Hide( ... )
	-- body
	--Lua_UIHelper.UIHide(this.gameObject,true);
	Panel_Follow.HidePanel(this.gameObject);
end
function this.OnExtend( ... )
	if FishingFarmMaster.CanUpgradeFarmCapacity() == true then
		--发送消息
		SocketMessage.SendExpandPoolMessage();
	end
end
function this.OnDestroy(  )
	-- body
	Event.RemoveListener(Enum.EventType.EventFarmSizeLvChange,this.Init);
end