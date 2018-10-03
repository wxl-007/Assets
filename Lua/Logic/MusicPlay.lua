--声音、音乐管理模块
MusicPlay = {}

MusicPlay.has_load_music_object_dict = { }

--播放机定义
MusicPlay.AudioType_BgSound = "BgSound"     --背景音乐播放机


function MusicPlay.initial()
	MusicManager:InitAudioSource()
end


--播放背景音乐
function MusicPlay.PlayBGMusicPlay(audio)
	-- body
	if audio then
		--MusicManager:BGPlay(MusicPlay.AudioType_BgSound, audio, true, 1)
	end
end

--播放按钮声音
function MusicPlay:PlayOnce2D(audio)
	-- body
	if audio then
		--MusicManager:PlayOnce2D(audio,1)
	end
end

--停止一个播放机
function MusicPlay.StopOneAudio()
	MusicManager:StopOneAudio(MusicPlay.AudioType_BgSound)
end

--调整音量bg
function MusicPlay.AlterVolume(volume)
	--MusicManager.BGsoundVolume=volume;
	--MusicManager:AlterBGSource(volume)
end
function MusicPlay.OnesoundVolume(volume)
	--MusicManager.soundVolume=volume;
end
function MusicPlay.GBsoundVolume()
	--return MusicManager.BGsoundVolume
end
function MusicPlay.OnsoundVolume()
	--return MusicManager.soundVolume
end
--删除全部播放机
function MusicPlay.ClearAllAudio()
	--local Musicobj=GameObject.Find("GameManager")
	--if not IsNil(Musicobj) then
	--	MusicManager:ALLClearBG()
	--end

end


--播放一次音效
--播放一次音效