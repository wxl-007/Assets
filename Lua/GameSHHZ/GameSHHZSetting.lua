require "GameNN/UISoundManager"

local this = LuaObject:New()
GameSHHZSetting = this

local windowTweenPosition;

local btnSwitch1On;
local btnSwitch1Off;
local btnSwitch2On;
local btnSwitch2Off;

local isPlayBG = true;
local isPlayEffectMusic = true;

-------------------------------------------------------------------------------------------------
function this.Awake()
	this.initPanel();
end

-------------------------------------------------------------------------------------------------
-- 倒计时
function this.OnEnable()
    this.ShowPanel();
end

-------------------------------------------------------------------------------------------------
-- 初始化面板
function this.initPanel()
	-- UI动画控件
	windowTweenPosition = this.gameObject:GetComponent("TweenPosition");

	--关闭按钮
	local btnClose = this.transform:FindChild("panelbg/CloseBtn").gameObject;
	this.mono:AddClick(btnClose, this.OnCloseBtnClick);
    --关闭按钮
    btnClose = this.transform:FindChild("panelbg/black").gameObject;
    this.mono:AddClick(btnClose, this.OnCloseBtnClick);

	--确定
	local btnConfirm = this.transform:FindChild("settlementPanel/ConfirmBtn").gameObject;
	this.mono:AddClick(btnConfirm, this.OnCloseBtnClick);
	--音乐开关
	btnSwitch1On = this.transform:FindChild("settlementPanel/switch1/SwitchOn").gameObject;
	this.mono:AddClick(btnSwitch1On, this.OnSwitch1OnClick);
	btnSwitch1Off = this.transform:FindChild("settlementPanel/switch1/SwitchOff").gameObject;
	this.mono:AddClick(btnSwitch1Off, this.OnSwitch1OffClick);
	--音效开关
	btnSwitch2On = this.transform:FindChild("settlementPanel/switch2/SwitchOn").gameObject;
	this.mono:AddClick(btnSwitch2On, this.OnSwitch2OnClick);
	btnSwitch2Off = this.transform:FindChild("settlementPanel/switch2/SwitchOff").gameObject;
	this.mono:AddClick(btnSwitch2Off, this.OnSwitch2OffClick);

    -- NotificationCenter.DefaultCenter().AddObserver(this, "OnSettingBtnClick");
    -- local switch1 = PlayerManager.GetInstance().GetPlayer().MusicSwitch == 1;
    -- local switch2 = PlayerManager.GetInstance().GetPlayer().EffectSwitch == 1;
    -- btnSwitch1On.SetActive(!switch1);
    -- btnSwitch1Off.SetActive(switch1);
    -- btnSwitch2On.SetActive(!switch2);
    -- btnSwitch2Off.SetActive(switch2);
end


-------------------------------------------------------------------------------------------------
-- 关闭按钮回调
function this.OnCloseBtnClick()
    this.HidePanel();
    this.PlaySound("Button");
end


-------------------------------------------------------------------------------------------------
--音乐开
function this.OnSwitch1OnClick()
    btnSwitch1On:SetActive(false);
    btnSwitch1Off:SetActive(true);
    isPlayBG = true;
     -- 播放背景音乐
    UISoundManager.PlayBGSound(GameSHHZUI.BGMusic);
    this.PlaySound("Button");
end
-------------------------------------------------------------------------------------------------
--音乐关
function this.OnSwitch1OffClick()
    btnSwitch1On:SetActive(true);
    btnSwitch1Off:SetActive(false);
    isPlayBG = false;
     -- 停止播放背景音乐
    UISoundManager.PauseBGSound();
    this.PlaySound("Button");
end

-------------------------------------------------------------------------------------------------
--音效开
function this.OnSwitch2OnClick()
    btnSwitch2On:SetActive(false);
    btnSwitch2Off:SetActive(true);
    isPlayEffectMusic = true;
    this.PlaySound("Button");
end
-------------------------------------------------------------------------------------------------
--音效关
function this.OnSwitch2OffClick()
    btnSwitch2On:SetActive(true);
    btnSwitch2Off:SetActive(false);
    isPlayEffectMusic = false;
    this.PlaySound("Button");
end


-------------------------------------------------------------------------------------------------
-- 显示界面
function this.OnSettingBtnClick()
    this.ShowSettlementPanel();
end


-------------------------------------------------------------------------------------------------
-- 显示界面
function this.ShowPanel()
    windowTweenPosition:PlayForward();
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


-------------------------------------------------------------------------------------------------
-- 播放声音
function this.PlaySound(scource)
    if isPlayEffectMusic == true then
        UISoundManager.PlaySound(scource);
    end
end

function this.PlayBGSound(source)
    if isPlayBG==true then
        UISoundManager.PlayBGSound(source);
    end
end