LRDDZ_SettingPanel = {}
local self = LRDDZ_SettingPanel

local transform
local gameObject

local tg_gameEff;
local tg_soundEff;
local tg_soundBg;
local tg_autoReady;
local tg_pth;
local tg_sch;
local tg_none
local btnClose


function LRDDZ_SettingPanel.Awake(obj)
	gameObject = obj
    transform = obj.transform

    self.Init()
end 
function LRDDZ_SettingPanel.Init()
	self.mono = gameObject:GetComponent('LRDDZ_LuaBehaviour')
	btnClose = transform:FindChild("Container/btn_Close").gameObject
	tg_gameEff = transform:FindChild("Container/game_eff"):GetComponent("UIToggle")
	tg_soundEff = transform:FindChild("Container/sound_eff"):GetComponent("UIToggle")
	tg_soundBg = transform:FindChild("Container/sound_bg"):GetComponent("UIToggle")
	tg_autoReady = transform:FindChild("Container/autoReady"):GetComponent("UIToggle")

	tg_pth = transform:FindChild("Container/Sound/PTH"):GetComponent("UIToggle")
	tg_sch = transform:FindChild("Container/Sound/SCH"):GetComponent("UIToggle")
	tg_none = transform:FindChild("Container/Sound/None"):GetComponent("UIToggle")

	self.mono:AddClick(btnClose,self.OnCloseCallBack)

	self.mono:AddToggle(tg_gameEff,self.SetGameEff)
	self.mono:AddToggle(tg_soundEff,self.SetSoundEff)
	self.mono:AddToggle(tg_soundBg,self.SetSoundBg)
	self.mono:AddToggle(tg_autoReady,self.SetAutoReady)
	--播放音效 其他不处理
	self.mono:AddClick(tg_gameEff.gameObject,self.OnSoundLanguageCallBack)
	self.mono:AddClick(tg_soundEff.gameObject,self.OnSoundLanguageCallBack)
	self.mono:AddClick(tg_soundBg.gameObject,self.OnSoundLanguageCallBack)
	self.mono:AddClick(tg_autoReady.gameObject,self.OnSoundLanguageCallBack)
	--

	self.mono:AddClick(tg_pth.gameObject,self.OnSoundLanguageCallBack)
	self.mono:AddClick(tg_sch.gameObject,self.OnSoundLanguageCallBack)
	self.mono:AddClick(tg_none.gameObject,self.OnSoundLanguageCallBack)

	--初始化状态
	tg_soundBg.value = LRDDZ_MusicManager.instance:getMusicState()
	tg_soundEff.value = LRDDZ_MusicManager.instance:getEffectState()
	tg_autoReady.value = MyCommon.GetAutoReady()

	if MyCommon.GetSoundType() == 1 then
		tg_pth.value = true
	elseif MyCommon.GetSoundType() == 2 then
		tg_sch.value = true
	elseif MyCommon.GetSoundType() == 3 then
		tg_none.value = true
	end
	if MyCommon.GetGameEffState() == 1 then
		tg_gameEff.value = true
	else
		tg_gameEff.value = false
	end

	if LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
		tg_autoReady.value = false
		tg_autoReady.transform:FindChild("Sprite"):GetComponent("UISprite").color = Color.New(0.6,0.6,0.6)
		tg_autoReady.transform:GetComponent("BoxCollider").enabled = false
	end

end
--设置游戏特效开关
function LRDDZ_SettingPanel.SetGameEff()
	if tg_gameEff.value == true then
		--开
		MyCommon.SetGameEffState(1)
	else
		--关
		MyCommon.SetGameEffState(2)
	end
end
function LRDDZ_SettingPanel.SetSoundEff()
	LRDDZ_MusicManager.instance:setEffectState(tg_soundEff.value)
end
function LRDDZ_SettingPanel.SetSoundBg()
	LRDDZ_MusicManager.instance:setMusicState(tg_soundBg.value)
end
function LRDDZ_SettingPanel.SetAutoReady()
	MyCommon.SetAutoReady(tg_autoReady.value)
end

function LRDDZ_SettingPanel.OnSoundLanguageCallBack(go)
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	if go.name == tg_pth.name then
		MyCommon.SetSoundType(1)
	elseif go.name == tg_sch.name then
		MyCommon.SetSoundType(2)
	elseif go.name == tg_none.name then
		MyCommon.SetSoundType(3)
	end
end
function LRDDZ_SettingPanel.OnCloseCallBack(go)
	gameObject:SetActive(false)
end