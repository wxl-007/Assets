local this = LuaObject:New()
Panel_Setting = this

local button_Music_on_off;
local button_Audio_on_off;
local button_Effect_on_off;
local button_Vibration_on_off;

local btn_tuiSend;
local btn_close;

function this.OnEnable()
    -- body
    --if Global.instance.isMobile == false then
    --    UIHelper.On_UI_Show(this.gameObject);
    --end
end

function this.Start()
    --Lua_UIHelper.UIShow(this.gameObject);
	this.InitPanel();

	this.setButtonState(button_Music_on_off, AudioHelper.getInstance():getMusicState());
    this.setButtonState(button_Audio_on_off, AudioHelper.getInstance():getEffectState());
    this.setButtonState(button_Effect_on_off, Global.Effect);
    this.setButtonState(button_Vibration_on_off, Global.Vibrate);
end

--初始化面板--
function this.InitPanel()
	button_Music_on_off = this.transform:Find("Content 1/setButton/Set_music/Button_music").gameObject;
	button_Audio_on_off = this.transform:Find("Content 1/setButton/Set_audio/Button_audio").gameObject;
	button_Vibration_on_off = this.transform:Find("Content 1/setButton/Set_shake/Button_shake").gameObject;
	button_Effect_on_off = this.transform:Find("Content 1/setButton/Set_effect/Button_effect").gameObject;
	this.mono:AddClick(button_Music_on_off,this.ButtonMusicOnOffHandle);
	this.mono:AddClick(button_Audio_on_off,this.ButtonAudioOnOffHandle);
	this.mono:AddClick(button_Effect_on_off,this.ButtonEffectOnOffHandle);
	this.mono:AddClick(button_Vibration_on_off,this.ButtonVibrationOnOffHandle);

	btn_close = this.transform:FindChild("Button_close").gameObject;
	this.mono:AddClick(btn_close,this.Hide);
end


function this.Hide()
	--if Global.instance.isMobile == false then
    --    Panel_Follow.HidePanel(this.gameObject);
    --else
        this.gameObject:SetActive(false);
    --end
end

function this.setButtonState( go, state )
	-- body
	local _button = go:GetComponent("UIButton");
    local _on = go.transform:Find("on").gameObject;
    local _off = go.transform:Find("off").gameObject;
    local tweenP = go.transform:Find("hua"):GetComponent("TweenPosition");
    if state == true then
        _button.normalSprite = "di_on";
        _on:SetActive(true);
        _off:SetActive(false);
        tweenP:PlayForward();
    else
        _button.normalSprite = "di_off";
        _on:SetActive(false);
        _off:SetActive(true);
        tweenP:PlayReverse();
    end
end

function this.changedButtonState( go )
	-- body
	local _button = go:GetComponent("UIButton");
    local _on = go.transform:Find("on").gameObject;
    local _off = go.transform:Find("off").gameObject;
    local tweenP = go.transform:Find("hua"):GetComponent("TweenPosition");
    if _button.normalSprite == "di_on" then
        _button.normalSprite = "di_off";
        _on:SetActive(false);
        _off:SetActive(true);
        tweenP:PlayReverse();
        return false;
    else
        _button.normalSprite = "di_on";
        _on:SetActive(true);
        _off:SetActive(false);
        tweenP:PlayForward();
        return true;
    end
end

function this.ButtonMusicOnOffHandle( go )
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
    AudioHelper.getInstance():setMusicState(this.changedButtonState(go));
end
function this.ButtonAudioOnOffHandle( go )
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
	AudioHelper.getInstance():setAudioState(this.changedButtonState(go));
end
function this.ButtonEffectOnOffHandle( go )
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
	local state = this.changedButtonState(go);
    Global.Effect = state;
    Global.instance:EffectOnOff(state);
end
function this.ButtonVibrationOnOffHandle( go )
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
    Global.Vibrate = this.changedButtonState(go);
end