 

local this = LuaObject:New()
SettingInfo = this

this.Instance = this

this.bgVolume =0
this.effectVolume =0
this.specialEfficacy =false
this.autoNext =false
this.gameVoice =false
this.deposit = false--托管
this.chipmin =false --最小下注
this.keynoteColor = 0
this.keynoteTexture = 0
this.YSZ_autoVS =false

function this:Awake( )
	this:LoadInfo()
end
function this:LoadInfo () 
	this.bgVolume = UnityEngine.PlayerPrefs.GetFloat("SettingBgVolume", 0.6)
	this.effectVolume = UnityEngine.PlayerPrefs.GetFloat("SettingEffectVolume", 0.6)
	this.specialEfficacy = (UnityEngine.PlayerPrefs.GetInt("SettingSpecialEfficacy", 1) == 1)
	this.autoNext = (UnityEngine.PlayerPrefs.GetInt("SettingAutoNext", 1) == 1)
	this.deposit = (UnityEngine.PlayerPrefs.GetInt("SettingDeposit", 0) == 1)
    this.chipmin = (UnityEngine.PlayerPrefs.GetInt("SettingChipmin", 1) == 1)

	this.keynoteColor = UnityEngine.PlayerPrefs.GetInt("SettingKeynoteColor", 0)
	this.keynoteTexture = UnityEngine.PlayerPrefs.GetInt("SettingKeynoteTexture", 0)

	this.YSZ_autoVS = (UnityEngine.PlayerPrefs.GetInt("SettingYSZ_autoVS", 1) == 1)
end
	
function this:SaveInfo () 
	UnityEngine.PlayerPrefs.SetFloat("SettingBgVolume", this.bgVolume)
	UnityEngine.PlayerPrefs.SetFloat("SettingEffectVolume", this.effectVolume)
	local tResult  = 0
	if this.specialEfficacy  then
		tResult =1
	else
		tResult =0
	end
	UnityEngine.PlayerPrefs.SetInt("SettingSpecialEfficacy", tResult)

	if this.autoNext  then
		tResult =1
	else
		tResult=0
	end
	UnityEngine.PlayerPrefs.SetInt("SettingAutoNext", tResult)
	UnityEngine.PlayerPrefs.SetInt("SettingKeynoteColor", this.keynoteColor)
	UnityEngine.PlayerPrefs.SetInt("SettingKeynoteTexture", this.keynoteTexture)

	if this.deposit  then
		tResult =1
	else
		tResult =0
	end
	UnityEngine.PlayerPrefs.SetInt("SettingDeposit", tResult)

	if this.chipmin then
		tResult=1
	else
		tResult=0
	end
    UnityEngine.PlayerPrefs.SetInt("SettingChipmin", tResult)

	if this.YSZ_autoVS then
		tResult=1
	else
		tResult=0
	end
	UnityEngine.PlayerPrefs.SetInt("SettingYSZ_autoVS", tResult)

	UnityEngine.PlayerPrefs.Save();
end