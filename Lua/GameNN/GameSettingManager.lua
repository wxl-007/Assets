
local this = LuaObject:New()
GameSettingManager = this


this.depositFunc = nil;
this.depositFunc_1=nil;


function this:clearLuaValue()
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	this.bgAudio = nil;
	this.sliderBgVolume = nil;
	this.sliderEffectVolume  = nil;
	
	this.spriteSpecial = nil;
	this.kAutoNext  = nil;
	this.kDeposit = nil;
	
	this.kAllDeposit  = nil;
	LuaGC();
end
function this:Init()
	this.sliderBgVolume = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_bgmusic/Slider").gameObject:GetComponent("UISlider")
	this.sliderEffectVolume = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_bgsound/Slider").gameObject:GetComponent("UISlider")
	
	this.spriteSpecial = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_special/Button_special").gameObject:GetComponent("UIButton")
	this.kAutoNext = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_autonext/Button_autonext").gameObject:GetComponent("UIButton")
	this.kDeposit = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_deposit/Button_deposit").gameObject:GetComponent("UIButton")
	
	this.kAllDeposit = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_deposit").gameObject
	
	this.bgAudio = this.gameObject:GetComponent("AudioSource")
	
end
function this:Awake()
	this:Init();
	
	this.mono:AddClick(this.spriteSpecial.gameObject, this.SetSpecial);
	this.mono:AddClick(this.kAutoNext.gameObject, this.SetAutoNext);
	this.mono:AddClick(this.kDeposit.gameObject, this.SetDeposit);
	
	this.mono:AddSlider(this.sliderBgVolume, this.SetBgVolume);
	this.mono:AddSlider(this.sliderEffectVolume, this.SetEffectVolume);
end

function this:Start()
	
	SettingInfo.Instance:LoadInfo();
	this.sliderBgVolume.value = SettingInfo.Instance.bgVolume;
	this.sliderEffectVolume.value = SettingInfo.Instance.effectVolume;
	this.spriteSpecial.normalSprite = SettingInfo.Instance.specialEfficacy == true and "special_on" or "special_off";
       this.kAutoNext.normalSprite = SettingInfo.Instance.autoNext == true and "special_on" or "special_off";
       this.kDeposit.normalSprite = SettingInfo.Instance.deposit == true and "special_on" or "special_off";
	   
	if this.bgAudio ~= nil then
		this.bgAudio.volume = SettingInfo.Instance.bgVolume 
	end
end

function this:OnDisable()
	this:clearLuaValue()
	
end


function this:SetBgVolume()
	SettingInfo.Instance.bgVolume = this.sliderBgVolume.value;
	if this.bgAudio ~= nil then
		this.bgAudio.volume = SettingInfo.Instance.bgVolume 
	end
end
function this:SetEffectVolume()
	SettingInfo.Instance.effectVolume = this.sliderEffectVolume.value;
end
function this:SetSpecial()
       if this.spriteSpecial.normalSprite=="special_off" then
		this.spriteSpecial.normalSprite = "special_on";
		SettingInfo.Instance.specialEfficacy = true;
	else
		this.spriteSpecial.normalSprite = "special_off";
		SettingInfo.Instance.specialEfficacy = false;
	end
end
function this:SetAutoNext()

        if this.kAutoNext.normalSprite=="special_off"  then
		this.kAutoNext.normalSprite = "special_on";
		SettingInfo.Instance.autoNext = true;
	else
		this.kAutoNext.normalSprite = "special_off";
		SettingInfo.Instance.autoNext = false;
	end
end

function this:SetDeposit()
    if this.kDeposit.normalSprite=="special_off" then
		this.kDeposit.normalSprite = "special_on";
		SettingInfo.Instance.deposit = true;
		if(this.depositFunc ~= nil)then
			this.depositFunc(SettingInfo.Instance.deposit);
		end
	else 
    	this.kDeposit.normalSprite = "special_off";
		SettingInfo.Instance.deposit = false;
		if(this.depositFunc_1 ~= nil)then
			this.depositFunc_1(SettingInfo.Instance.deposit);
		end
	end

	
end
function this:setDepositVisible(bl)
		this.kAllDeposit.gameObject:SetActive(bl);
end
function this:OnDestroy()
		SettingInfo.Instance:SaveInfo();
end







