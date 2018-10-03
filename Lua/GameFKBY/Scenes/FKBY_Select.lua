
local this = LuaObject:New()
FKBY_Select = this;

local button_bag;
local button_shop;
local button_explain;
local button_setting;
local button_rank;
local button_vip;
local button_mail;
local button_bank;
local button_recharge;
local button_personal;
local button_record;
local button_task;
local button_activity;
local button_add;

local time;

require "GameFKBY/View/SafeValidate";
require "GameFKBY/View/Panel_Bank";
require "GameFKBY/View/Panel_Bag";
require "GameFKBY/View/Panel_Shop";
require "GameFKBY/View/Panel_Explain";
require "GameFKBY/View/Panel_Setting";
require "GameFKBY/View/Panel_Rank";
require "GameFKBY/LuaBagData";
require "GameFKBY/View/Panel_Vip";
require "GameFKBY/View/Panel_Mail";
require "GameFKBY/View/Panel_Record";
require "GameFKBY/View/Panel_Activity";
require "GameFKBY/View/Panel_Task";

function this.Awake()     
    print("------------------awake of Select-------------")	
end
function this.Start( )
	-- body
	Global.waterObj:SetActive(false);
    Global.instance:StartMuisc("dating",1);

	button_bag = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_bag");
	button_shop = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_mall");
	button_explain = GameObject.Find("UI Root/Panel_Select/Options_bottom/Popup/container/Button_explain");
	button_setting = GameObject.Find("UI Root/Panel_Select/Options_bottom/Popup/container/Button_setting");
	button_rank = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_ranking");
	button_vip = GameObject.Find("UI Root/Panel_Select/Options_top/Butto_vip");
	button_mail = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_mail");
	button_bank = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_bank");
	button_recharge = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_recharge");
	button_personal = GameObject.Find("UI Root/Panel_Select/uInfos/Avatar/Panel/Sprite_icon");
	button_record = GameObject.Find("UI Root/Panel_Select/Options_bottom/Popup/container/Button_record");
	button_task = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_task");
	button_activity = GameObject.Find("UI Root/Panel_Select/Options_top/Butto_activity");
	button_add = GameObject.Find("UI Root/Panel_Select/uInfos/box/coin/Button_add");

	this.mono:AddClick(button_bag,this.OnButtonEvent);
	this.mono:AddClick(button_shop,this.OnButtonEvent);
	this.mono:AddClick(button_explain,this.OnButtonEvent);
	this.mono:AddClick(button_setting,this.OnButtonEvent);
	this.mono:AddClick(button_rank,this.OnButtonEvent);
	this.mono:AddClick(button_vip,this.OnButtonEvent);
	this.mono:AddClick(button_mail,this.OnButtonEvent);
	this.mono:AddClick(button_bank,this.OnButtonEvent);
	this.mono:AddClick(button_recharge,this.OnButtonEvent);
	this.mono:AddClick(button_personal,this.OnButtonEvent);
	this.mono:AddClick(button_record,this.OnButtonEvent);
	this.mono:AddClick(button_task,this.OnButtonEvent);
	this.mono:AddClick(button_activity,this.OnButtonEvent);
	this.mono:AddClick(button_add,this.OnButtonEvent);

	this.mono:AddHover(button_bag,this.ButtonHoverHandle);
	this.mono:AddHover(button_shop,this.ButtonHoverHandle);
	this.mono:AddHover(button_explain,this.ButtonHoverHandle);
	this.mono:AddHover(button_setting,this.ButtonHoverHandle);
	this.mono:AddHover(button_rank,this.ButtonHoverHandle);
	this.mono:AddHover(button_mail,this.ButtonHoverHandle);
	this.mono:AddHover(button_bank,this.ButtonHoverHandle);
	this.mono:AddHover(button_recharge,this.ButtonHoverHandle);
	this.mono:AddHover(button_record,this.ButtonHoverHandle);
	this.mono:AddHover(button_task,this.ButtonHoverHandle);

	if EginUser.Instance.isGuest == true then
		if UnityEngine.PlayerPrefs.GetInt("RegisterPrompt",0) == 1 and Global.RegisterPrompt then
			Panel_Follow.ShowRegisterPromptPanel();
			Global.RegisterPrompt = false;
		else
			UnityEngine.PlayerPrefs.SetInt("RegisterPrompt",1);
		end
	end
end
function this.OnButtonEvent(button)
	-- body
	log(button);
	if(button.name == button_bag.name) then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Bag","Panel_Bag",true);
		Panel_Follow.ShowBagPanel();
	elseif(button.name == button_shop.name) then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Shop","Panel_Shop",true);
		Panel_Follow.ShowShopPanel();
	elseif(button.name == button_explain.name) then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Explain","Panel_Explain",true);
		Panel_Follow.ShowExplainPanel();
	elseif(button.name == button_setting.name) then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Setting","Panel_Setting",true);
		Panel_Follow.ShowSettingPanel();
	elseif(button.name == button_rank.name) then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Rank","Panel_Rank",true);
		Panel_Follow.ShowRankPanel();
	elseif button.name == button_vip.name then
		--BYResourceManager.Instance:CreateLuaPanel("Panel_Vip","Panel_Vip",true);	
		Panel_Follow.ShowVipPanel();
	elseif button.name == button_mail.name then
		Panel_Follow.ShowMailPanel();
	elseif button.name == button_bank.name then
		Panel_Follow.ShowBankPanel();
	elseif button.name == button_recharge.name then
		Panel_Follow.ShowRechargePanel();
	elseif button.name == button_personal.name then
		Panel_Follow.ShowPersonalPanel();
	elseif button.name == button_record.name then
		Panel_Follow.ShowRecordPanel();
	elseif button.name == button_task.name then
		Panel_Follow.ShowTaskPanel();
	elseif button.name == button_activity.name then
		Panel_Follow.ShowActivityPanel();
	elseif button.name ==button_add.name then
		Panel_Follow.ShowShopPanel();
	end
end
function this.OnDestroy()
	this.mono:ClearClick();
end

local last_uieffect;
function this.ButtonHoverHandle(go,isHover)
	-- body
	local uieffect = go.transform:FindChild("UIUI");
	if isHover == true then
		if uieffect ~= nil then
			if last_uieffect ~= nil then
				if last_uieffect ~= uieffect then
					uieffect.gameObject:SetActive(true);
					last_uieffect.gameObject:SetActive(false);
				end
			else
				uieffect.gameObject:SetActive(true);
			end
			last_uieffect = uieffect;
		end
	else
		if last_uieffect ~= nil then
			last_uieffect.gameObject:SetActive(false);
			last_uieffect = nil;
		end
	end
end
