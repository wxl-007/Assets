local this = LuaObject:New()
SoundMgr = this 
SoundMgr.instance = SoundMgr;



function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	
	
	self.bgmSlider = nil;
	self.bgsSlider = nil;
	self.bgm = nil;
	self.player = nil;
	self.clipDeal = nil;
	self.clipBet = nil;
	self.clipWin = nil;
	self.clipLose = nil;
	self.clipVs = nil;
	self.randomGroup = {};
	self.clipAry1 = {};
	self.clipAry2 = {};
	self.clipAry3 = {};
	self.players = {};
	self.playerNum = 1;
end
function this:Init()
	--初始化变量
	self.bgmSlider = nil;
	self.bgsSlider = nil;
	self.bgm = nil;
	self.player = nil;
	self.clipDeal = nil;
	self.clipBet = nil;
	self.clipWin = nil;
	self.clipLose = nil;
	self.clipVs = nil;
	self.randomGroup = {};
	self.clipAry1 = {};
	self.clipAry2 = {};
	self.clipAry3 = {};
	self.players = {};
	self.playerNum = 1;
end
function this:AddClipAry1(clop)
	table.insert(self.clipAry1,clop);
end
--播放组件,背景音乐,音量滑块
function this:Awake(audio,bg,musicSlider,soundSlider,mono)
	self:Init();
	
	self.bgm = bg;
	self.gameObject = audio;
	self.transform = audio.transform;
	self.player = self.gameObject:GetComponent("AudioSource");
	
	for  i=0, 3 do 
		 table.insert(self.players,self.transform:FindChild("players"..i).gameObject:GetComponent("AudioSource"));
	end
	self.bgmSlider = musicSlider;
	self.bgsSlider = soundSlider;
	mono:AddSlider(self.bgmSlider, self.OnbgmSliderBarChanged);
	mono:AddSlider(self.bgsSlider, self.OnbgsSliderBarChanged);
	self.bgsSlider.value = SettingInfo.Instance.effectVolume;
	self.bgmSlider.value = SettingInfo.Instance.bgVolume;
end
function this:Start () 

	self:playBgm();
end

function this:OnDestroy()
	self:clearLuaValue()
end
function this:OnbgmSliderBarChanged()
	this:sliderChanged();
end
function this:OnbgsSliderBarChanged()
	SettingInfo.Instance.effectVolume = this.bgsSlider.value;
end

function this:playBgm()
	
	self.player.clip = self.bgm;
	self.player.loop = true;
	self.player.volume = SettingInfo.Instance.bgVolume;
	self.player:Play();
end

function this:sliderChanged()
	SettingInfo.Instance.bgVolume = self.bgmSlider.value;
	if self.player ~= nil then
		self.player.volume = SettingInfo.Instance.bgVolume;
	end
end

function this:playRandEft()
	local lenTemp =  #(self.randomGroup) ;
	local randValue = math.Random(0, lenTemp);
	local clip = self.randomGroup[randValue];
	self:playEft(clip);
end

function this:playEft( clip, delay)
	if clip== nil then return; end
	if delay == nil then delay =0; end
	local eftPlayer = self:getFreeAudioS();
	eftPlayer.clip = clip;
	eftPlayer.loop = false;
	eftPlayer.volume = SettingInfo.Instance.effectVolume;
	if delay > 0 then
		eftPlayer:PlayDelayed(delay);
	else
		eftPlayer:Play();
	end
end
function this:playEftStr(clipPath)
	local clip = Resources.Load(clipPath);
	self:playEft(clip);
end

function this:playRes1( index)
	self:playEft( self.clipAry1[index+1] );
end

function this:talkAddJetton( isFemale)
	if isFemale == nil then isFemale =0; end
	if isFemale == 0 then
		self:playEft( self.clipAry1[1]);
	else
		self:playEft( self.clipAry1[2]);
	end
end
function this:talkFollowJetton( isFemale)
	if isFemale == nil then isFemale =0; end
	if isFemale == 0 then
		self:playEft( self.clipAry1[3]);
	else
		self:playEft( self.clipAry1[4]);
	end
end
function this:talkGiveup( isFemale)
	if isFemale == nil then isFemale =0; end
	if isFemale == 0 then
		self:playEft( self.clipAry1[5]);
	else
		self:playEft( self.clipAry1[6]);
	end
end
function this:talkSeeCard( isFemale)
	if isFemale == nil then isFemale =0; end
	if isFemale == 0 then
		self:playEft( self.clipAry1[7]);
	else
		self:playEft( self.clipAry1[8]);
	end
end
function this:talkVS( isFemale)
	if isFemale == nil then isFemale =0; end
	if isFemale == 0 then
		self:playEft( self.clipAry1[9]);
	else
		self:playEft( self.clipAry1[10]);
	end
end
function this:gameWin()
	self:playEft(self.clipWin);
end
function this:gameLose()
	self:playEft(self.clipLose);
end
function this:getFreeAudioS()
	local audioPlayer = nil;
	local playersLeng = #self.players;
	for  i=1,  playersLeng do 
		if not self.players[i].isPlaying  then
			audioPlayer = self.players[i];
			self.playerNum = i;
			break;
		end
		
	end
	if audioPlayer == nil then
		local tempNum = self.playerNum+1;
		if tempNum >playersLeng then
			tempNum = 1;
		end
		audioPlayer = self.players[tempNum];
		self.playerNum = tempNum;
	end
	return audioPlayer;
end
