
local this = LuaObject:New();
Panel_Follow = this;

local nickName;
local avatar;
local label_holdCoin ;
local label_lv;
local label_id;
local button_add;

local button_personal;
local panel_black;
local panel_bank;
local panel_recharge;
local panel_mail;
local panel_record;
local panel_explain;
local panel_setting;
local panel_personal;
--local panel_ranking;
local panel_match;
local panel_matchInfo;
local panel_activity;
local panel_task;
local panel_vip;
local panel_bag;
local panel_sales;
local panel_stoneInfo;
local panel_handselRank;

local panel_confirmFrame;

local panel_registerPrompt;
local panel_register;

local coinPos;
local box1;
local box2;
local Piles;
local black; 

local sceneRoot;

local recPanel = {};--记录打开没关闭的界面
local activePanel = {};

function this.Awake()
	-- body
	this.InitPanel();
	if sceneRoot == nil or sceneRoot.enabled == false then
		return;
	end
	local aspectRatio = Screen.width / Screen.height;
	if aspectRatio < 16/10.7 then
		sceneRoot.manualHeight = 800;
	end
end
function this.InitPanel()
	-- body
	sceneRoot = this.transform:GetComponentInParent(LuaHelper.GetType("UIRoot"));
	--panel_match = this.transform:FindChild("Panel_match").gameObject;
	--panel_matchInfo= this.transform:FindChild("Panel_matchInfo").gameObject;
end

function this.Start()
	-- body
end

function this.AddRecPanel(go)
	-- body
	recPanel[#recPanel+1] = go;
	go:SetActive(false);
end
function this.ButtonPersonalHandle( go )
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
	this.ShowPersonalPanel();
end
function this.ButtonAddHandle(go)
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
    this.ShowRechargePanel();
end

function  this.CloseComplete(go)
	-- body
	coroutine.wait(0.35);
	go:SetActive(false);
	--print(#activePanel)
	--if tableCount(activePanel) < 1 then
	--	panel_black:SetActive(false);
	--else
	--	panel_black:GetComponent("UIPanel").depth = activePanel[#activePanel]:GetComponent("UIPanel").depth - 1;
	--end
	--if panel_personal.activeSelf == false and panel_match.activeSelf == false and (IsNil(panel_recharge) == true or panel_recharge.activeSelf == false) and (IsNil(panel_mail) == true or panel_mail.activeSelf == false) then
	--	panel_black:SetActive(false);
	--end
	--black.depth = go:GetComponent("UIPanel").depth - 3;
end
function this.HidePanel(_panel)
	-- body
	if #recPanel == 0 then 
		UIHelper.On_UI_Hiden(_panel);
		--table.remove(activePanel,#activePanel);
		coroutine.start(this.CloseComplete,_panel);
	else
		_panel:SetActive(false);
		this.ShowPanel(recPanel[#recPanel]);
		table.remove(recPanel,#recPanel);
		--table.remove(activePanel,#activePanel);
	end
end

-----ShowPanel----
function this.ShowPersonalPanel()
	-- body
	if IsNil(panel_personal) == false then
		this.ShowPanel(panel_personal);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Personal","Panel_Personal",true,this.SetPersonalPanel);
	end
end
function this.SetPersonalPanel( go )
	-- body
	panel_personal = go;
	this.ShowPanel(panel_personal);
end
function this.ShowBankPanel( )
	--this.ShowPanel(panel_bank);
	if IsNil(panel_bank) == false then
		this.ShowPanel(panel_bank);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Bank","Panel_Bank",true,this.SetBankPanel);
	end
end
function this.SetBankPanel( go )
	panel_bank = go;
	this.ShowPanel(panel_bank);
end
function this.ShowRechargePanel()
	if IsNil(panel_recharge) == false then
		this.ShowPanel(panel_recharge);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Recharge","Panel_Recharge",true,this.SetRechargePanel);
	end
end
function this.SetRechargePanel(go)
	panel_recharge = go;
	this.ShowPanel(panel_recharge);
end
function this.ShowMailPanel( )
	--this.ShowPanel(panel_mail);
	if IsNil(panel_mail) == false then
		this.ShowPanel(panel_mail);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Mail","Panel_Mail",true,this.SetMailPanel);
	end
end
function this.SetMailPanel( go )
	panel_mail = go;
	this.ShowPanel(panel_mail);
end
function this.ShowRecordPanel(  )
	if IsNil(panel_record) == false then
		this.ShowPanel(panel_record);
	else
		BYResourceManager.Instance:CreateLuaPanel("","Panel_Record",true,this.SetRecordPanel);
	end
end
function this.SetRecordPanel( go )
	-- body
	panel_record = go;
	this.ShowPanel(panel_record);
end
function this.ShowExplainPanel(  )
	if IsNil(panel_explain) == false then
		this.ShowPanel(panel_explain);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Explain","Panel_Explain",true,this.SetExplainPanel);
	end
end
function this.SetExplainPanel( go )
	panel_explain = go;
	this.ShowPanel(panel_explain);
end
function this.ShowSettingPanel()
	if IsNil(panel_setting) == false then
		this.ShowPanel(panel_setting);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Setting","Panel_Setting",true,this.SetSettingPanel);
	end
	
end
function this.SetSettingPanel( go )
	panel_setting = go;
	this.ShowPanel(panel_setting);
end
function this.ShowRankPanel()
	-- body
	if IsNil(panel_handselRank) == false then

		this.ShowPanel(panel_handselRank);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Rank","Panel_Rank",true,this.SetRankPanel);
	end
end
function this.SetRankPanel( go )
	panel_handselRank = go;
	this.ShowPanel(panel_handselRank);
end
function this.ShowMatchPanel()
	-- body
	this.ShowPanel(panel_match);
end
function this.ShowMatchInfoPanel()
	-- body
	this.ShowPanel(panel_matchInfo);
end
function this.ShowActivityPanel(  )
	-- body
	if IsNil(panel_activity) == false then
		this.ShowPanel(panel_activity);
	else
		BYResourceManager.Instance:CreateLuaPanel("","Panel_Activity",true,this.SetRankPanel);
	end
end
function this.SetActivityPanel(go)
	-- body
	panel_activity = go;
	this.ShowPanel(panel_activity);
end
function this.ShowTaskPanel( )
	if IsNil(panel_task) == false then
		this.ShowPanel(panel_task);
	else
		BYResourceManager.Instance:CreateLuaPanel("","Panel_Task",true,this.SetTaskPanel);
	end
end
function this.SetTaskPanel( go )
	-- body
	panel_task = go;
	this.ShowPanel(panel_task);
end
--vip
function this.ShowVipPanel()
	if IsNil(panel_vip) == false then
		this.ShowPanel(panel_vip);
	else
		--创建
		BYResourceManager.Instance:CreateLuaPanel("Panel_Vip","Panel_Vip",true,this.SetVipPanel);
	end
end
function this.SetVipPanel(go)
	-- body
	panel_vip = go;
	this.ShowPanel(panel_vip);
end
--背包
function this.ShowBagPanel(  )
	if IsNil(panel_bag) == false then
		this.ShowPanel(panel_bag);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Bag","Panel_Bag",true,this.SetBagPanel);
	end
end
function this.SetBagPanel(go)
	panel_bag = go;
	this.ShowPanel(panel_bag);
end
--碎片详细信息
function this.ShowStoneInfo(  )
	if IsNil(panel_stoneInfo) == false then 
		this.ShowPanel(panel_stoneInfo);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_MoreStoneInfo","Panel_MoreStoneInfo",true,this.SetStoneInfoPanel);
	end
end
function this.SetStoneInfoPanel( go )
	panel_stoneInfo = go;
	this.ShowPanel(panel_stoneInfo);
end
--商城
function this.ShowShopPanel(  )
	if IsNil(panel_sales) == false then
		this.ShowPanel(panel_sales);
	else
		BYResourceManager.Instance:CreateLuaPanel("Panel_Shop","Panel_Shop",true,this.SetShopPanel);
	end
end

function this.SetShopPanel( go )
	panel_sales = go;
	this.ShowPanel(panel_sales);
end
--确认框
function this.ShowConfirmFramePanel()
	if IsNil(panel_confirmFrame) == false then	
		panel_confirmFrame:SetActive(true);
	else
		BYResourceManager.Instance:CreateLuaPanel("UICommon","Panel_ConfirmFrame",true,this.SetConfirmFrame);
	end
end
function this.SetConfirmFrame( go )
	panel_confirmFrame = go;
	panel_confirmFrame:SetActive(true);
end
function this.ShowRegisterPromptPanel(  )
	if IsNil(panel_confirmFrame) == false then
		panel_registerPrompt:SetActive(true);
	else
		BYResourceManager.Instance:CreateLuaPanel("RegisterPrompt","RegisterPrompt",false,this.SetShopPanel);
	end
	coroutine.stop(registerPromptCountDown);
	coroutine.start(registerPromptCountDown);
end
function this.SetRegisterPromptPanel( go )
	-- body
	panel_registerPrompt = go;
end
function this.ShowRegisterPanel(  )
	ShowPanel(panel_register);
	panel_register.GetComponent("Register").panel_black = panel_black;
end
function this.ShowPanel( _panel )
	if tableContains == false then
		activePanel[#activePanel+1] = _panel;
	end
	_panel:SetActive(true);
	--panel_black:GetComponent("UIPanel").depth = _panel:GetComponent("UIPanel").depth - 1;
	--panel_black:SetActive(true);
	--if Global.Effect == false then
		--local tex = panel_black.GetComponentInChildren(LuaHelper.GetType("UITexture"));
		--tex.shader = Shader.Find("Unlit/Transparent Colored");
	--end
	--UIHelper.On_UI_Show(_panel);
end
function this.SetPilesActive( _state )
	Piles:SetActive(_state);
	box2:SetActive(not _state)
end
function this.registerPromptHandle( go )
	if go.name == "Button_OK" then
		this.ShowRegisterPanel();
		panel_registerPrompt:SetActive(false);
	elseif go.name == "BUtton_canel" then
		this.HidePanel(panel_registerPrompt,go);
	end
end
function this.registerPromptCountDown( )
	local countDown = panel_registerPrompt.transform:FindChild("countDown"):GetComponent("UILabel");
	local time = 5;
	countDown.text = string.format("%ds",time);
	for i=1,5 do 
		coroutine.wait(1);
		countDown.text = string.format("%ds",time - 1 - 1);
	end
	this.HidePanel(panel_registerPrompt,panel_registerPrompt);
end