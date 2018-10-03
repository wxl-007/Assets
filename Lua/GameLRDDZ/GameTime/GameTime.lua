--游戏时间，客户端时间都取这个
GameTime = {} 
GameTime.changeTimeStamp = 0

function GameTime.initial()
	Network.register_server_message_dispatch("S2C_SYNCH_SERVER_TIMESTAMP")
end 
function GameTime.S2C_SYNCH_SERVER_TIMESTAMP(param_dict)
	GameTime.SynchServerTimeStamp(param_dict.timestamp)

	log(string.format("server time change, now timestamp is:%s, datetime is:%s", GameTime.GetTimeStamp(), UnixStamp_To_DateTime(GameTime.GetTimeStamp())))
end

function GameTime.GetLocalTimeStamp()
	return Util.GetTimeStamp()
end

function GameTime.GetLocalTimeMilliStamp()
	return Util.GetTime()
end

function GameTime.SynchServerTimeStamp(serverTimeStamp)
	GameTime.changeTimeStamp = serverTimeStamp - GameTime.GetLocalTimeStamp()
end

function GameTime.GetHeartBeatRealTick()
	return GameTime.GetLocalTimeStamp()
end

--游戏时间戳(秒)
function GameTime.GetTimeStamp()
	return GameTime.GetLocalTimeStamp() + GameTime.changeTimeStamp
end

--游戏时间(毫秒)
function GameTime.GetTimeMilliStamp()
	return GameTime.GetLocalTimeMilliStamp() + GameTime.changeTimeStamp * 1000
end