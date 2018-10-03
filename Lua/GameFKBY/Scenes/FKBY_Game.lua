
local this = LuaObject:New()
FKBY_Game = this

local button_bag;
local button_explain;
local button_setting;
local button_personal;

require "GameFKBY/View/Panel_Bag";
require "GameFKBY/View/Panel_Explain";
require "GameFKBY/View/Panel_Setting";
function this.Awake()
    log("------------------awake of Game-------------")	
end
function this.Start()
	-- body
	button_bag = GameObject.Find("UI Root/Panel_Game/panel_function/Sprite_frame/Button5");
	button_explain = GameObject.Find("UI Root/Panel_Game/panel_function/Sprite_frame/Button3");
	button_setting = GameObject.Find("UI Root/Panel_Game/panel_function/Sprite_frame/Button4");
	button_personal = GameObject.Find("UI Root/Panel_Game/Panel_Other/uInfos/Avatar/Panel/Sprite_icon");

	this.mono:AddClick(button_bag,this.OnButtonEvent);
	this.mono:AddClick(button_explain,this.OnButtonEvent);
	this.mono:AddClick(button_setting,this.OnButtonEvent);

    if FKBYGameSetting.platform == Global.PlatformType.PlatformIndependent then
		this.mono:AddClick(button_personal,this.OnButtonEvent);
	end
end
function this.OnButtonEvent(go)
	-- body
	print("panel_game.lua");
	if(go.name == button_bag.name) then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Bag","Panel_Bag",true);
		Panel_Follow.ShowBagPanel();
	elseif(go.name == button_explain.name) then
		Panel_Follow.ShowExplainPanel();
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Explain","Panel_Explain",true);
	elseif(go.name == button_setting.name) then
		Panel_Follow.ShowSettingPanel();
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Setting","Panel_Setting",true);
	elseif(go.name == button_personal.name) then
		Panel_Follow.ShowPersonalPanel();
	end
end
function this.OnDestroy()
end
	