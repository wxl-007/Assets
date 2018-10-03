local this = LuaObject:New()
Panel_Activity = this;

local btn_close;

function this.Start()
	this.InitPanel();

end

function this.OnEnable()
    -- body
    if Global.instance.isMobile == false then
        UIHelper.On_UI_Show(this.gameObject);
    end
end

--初始化面板--
function this.InitPanel()
	btn_close = this.transform:FindChild("Button_close").gameObject;
    this.mono:AddClick(btn_close,this.Hide);
end

function this.Hide()
	if Global.instance.isMobile == false then
        Panel_Follow.HidePanel(this.gameObject);
    else
        this.gameObject:SetActive(false);
    end
end