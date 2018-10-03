local this = LuaObject:New()
GameSHHZRecord = this

local windowTweenPosition;

-------------------------------------------------------------------------------------------------
function this.Awake()
	this.initPanel();
end

-------------------------------------------------------------------------------------------------
-- 初始化面板
function this.initPanel()
	-- UI动画控件
	windowTweenPosition = this.gameObject:GetComponent("TweenPosition");

	--关闭按钮
	local btnClose = this.transform:FindChild("panelbg/CloseBtn").gameObject;
	this.mono:AddClick(btnClose, this.HidePanel);

    --关闭按钮
    btnClose = this.transform:FindChild("panelbg/black").gameObject;
    this.mono:AddClick(btnClose, this.HidePanel);
end


-------------------------------------------------------------------------------------------------
-- 初始化面板
function this.init(tableRecord)
    local count = #tableRecord;

    --关闭按钮
    for i = 1, 30 do
        local itemName = string.format('list/item%02d', i);
        local item = this.transform:FindChild(itemName);
        local record = item:FindChild("record").gameObject;
        local pair = item:FindChild("pair").gameObject;

        if i<=count then
            record:SetActive(true);
            local sp = record:GetComponent("UISprite");
            local record = tableRecord[i];
            if record == 0 then
                sp.spriteName = "recordsmall";
            elseif record == 1 then
                sp.spriteName = "recorddraw";
            else
                sp.spriteName = "recordbig";
            end

            sp:MakePixelPerfect();

            pair:SetActive(false);
        else
            record:SetActive(false);
            pair:SetActive(false);
        end
    end
end


-------------------------------------------------------------------------------------------------
-- 关闭按钮回调
function this.OnCloseBtnClick()
    this.HideSettlementPanel();
    GameSHHZSetting.PlaySound("Button");
end

-------------------------------------------------------------------------------------------------
-- 显示界面
function this.ShowPanel(tableRecord)
    windowTweenPosition:PlayForward();
    this.init(tableRecord);
end


-------------------------------------------------------------------------------------------------
-- 隐藏界面
function this.HidePanel()
    windowTweenPosition:PlayReverse();
    coroutine.start(this.hidden);
end


-------------------------------------------------------------------------------------------------
-- 隐藏界面
function this.hidden()
    coroutine.wait(0.6);
    this.gameObject:SetActive(false);
end

