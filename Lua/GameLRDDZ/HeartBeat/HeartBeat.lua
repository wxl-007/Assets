HeartBeat = {}

HeartBeat.lastReceiveTick = GameTime.GetHeartBeatRealTick()

HeartBeat.MaxPingPongTick = 40

HeartBeat.needCheck = false

function HeartBeat.initial()
	Network.register_server_message_dispatch("S2C_HEARTBEAT_PONG", HeartBeat.S2C_HEARTBEAT_PONG)

	HeartBeat.time = Timer.New(HeartBeat.routine, 20, -1, true)
	HeartBeat.time:Start()
end

function HeartBeat.S2C_HEARTBEAT_PONG()
	HeartBeat.lastReceiveTick = GameTime.GetHeartBeatRealTick()
end

function HeartBeat.routine()
	HeartBeat.checkHeartBeatStatus()
end

function HeartBeat.checkHeartBeatStatus()

	if not HeartBeat.needCheck then
		return
	end

	local now_tick = GameTime.GetHeartBeatRealTick()
	if now_tick > HeartBeat.lastReceiveTick + HeartBeat.MaxPingPongTick then

		Network.DisconnectServer()

		HeartBeat.needCheck = false
		return
	end

	Network.send_server_message("C2S_HEARTBEAT_PING")
    HeartBeat.needCheck = true
end

function HeartBeat.startHeartBeat()
	HeartBeat.lastReceiveTick = GameTime.GetHeartBeatRealTick()
	HeartBeat.needCheck = true
end

function HeartBeat.stopHeartBeat()
	HeartBeat.needCheck = false
end