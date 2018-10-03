
local this = LuaObject:New()
UISoundManager = this
UISoundManager.Instance = UISoundManager;

this.isReady=false;
this._BGVolume = 0;
this._EFVolume = 0;
this.BGSource=nil;
this.soundMap={};
this.audioClipBG = nil;
this.gameObj = nil;

function this.clearLuaValue()
	this.isReady=false;
	this._BGVolume = 0;
	this._EFVolume = 0;
	this.BGSource=nil;
	this.soundMap={};
	this.audioClipBG = nil;

end
function this.Init(_gameobj)
	this.isReady=false;
	this._BGVolume = 0;
	this._EFVolume = 0;
	this.BGSource=nil;
	this.soundMap={};
	this.audioClipBG = nil;
	print(_gameobj.name)
	this.gameObj = _gameobj;
end
--开启音乐模块 isBG是否开启背景音乐
function this.Start (isBG) 
	this._BGVolume=SettingInfo.Instance.bgVolume;
	this._EFVolume=SettingInfo.Instance.effectVolume;
	


	-- print('=======start  ==========='..this.gameObj.name) 
	this.BGSource = this.gameObj:GetComponent("AudioSource")

	this.BGSource.loop = true;
       this.BGSource.clip = this.audioClipBG;
       this.BGSource.volume = this._BGVolume;
	if isBG then
		this.PlayBGSound();
	end
end
function this.finish () 
	this:clearLuaValue();
end

function this.AddAudioSource(audio, name,isBg)
	if isBg then
		this.audioClipBG = ResManager:LoadAsset(audio,name);
	else
		this.soundMap[name] = ResManager:LoadAsset(audio,name);
	end
end


function this.BGVolumeSet(value)
	this._BGVolume=value;
	this.updateBGVolume();
end

function this.updateBGVolume() 
	if this.isReady  then
		if this.audioClipBG ~= nil then
			if this.BGSource~=nil  then
				this.BGSource.volume=this._BGVolume;
				if this._BGVolume==0 then
					--this.BGSource:Pause();
				elseif not this.BGSource.isPlaying then
					this.BGSource:Play();
				end
			else
				
			end
		end
	else
		if this.BGSource~=nil  then
			this.BGSource:Pause();
		end
	end
end

function this.PlaySound( clipName)
	local aSource=this.soundMap[clipName];
	if aSource~=nil then
		if this._EFVolume~=0 then
			NGUITools.PlaySound(aSource, this._EFVolume);
		end
	end
end
function this.PlayBGSound()
	this.isReady = true;
	this.updateBGVolume ();
end
function this.PauseBGSound()
	this.isReady = false;
	this.updateBGVolume ();
end