--出牌顺序权限管理
OrderCtrl = {}

local self = OrderCtrl

self.bigest = nil  --最大出牌者

self.currentAuthority = nil  --当前出牌着

self.state = GameState.Before

self.GradLordTime = 0 --抢地主最多次数

self.cureentTime = 0
--
function OrderCtrl.GradInit()
	self.currentAuthority = CharacterType.Player  --当前出牌着
	self.GradLordTime = 4 --抢地主最多次数
	self.state = GameState.GradLord
end 
--抢地主
--[[
function OrderCtrl.GradLordTrun(giveupGardLord)
	Player.HidenNotice()
	Computer.HidenNotice()
	OtherComputer.HidenNotice()
	
		--网络模式
		if giveupGardLord == true then  
			--结束抢地主
		else
			--
		end
end 
]]
--初始化
function OrderCtrl.Init(current)
	self.state = GameState.Play
	self.currentAuthority = current

	self.bigest = current
	--[[
	if self.currentAuthority  == CharacterType.Computer then 
		--电脑出牌
		
	elseif  self.currentAuthority  == CharacterType.Player then  
		 --玩家出牌
		if GameCtrl.isTuoguan == false then
			Event.Brocast(GameEvent.ShowPlay,true,false)
		end
	else
		--另一个电脑
	end 
	]]
end 
--轮流出牌
function OrderCtrl.TurnPlay()
	if self.state ~= GameState.GradLord and self.state ~= GameState.Play then
		return
	end
	self.currentAuthority = self.currentAuthority -1 
	if self.currentAuthority  <= 0 then 
		self.currentAuthority = CharacterType.Computer
	end
	if self.currentAuthority  == CharacterType.Computer then 
		--电脑出牌
		
	elseif  self.currentAuthority  == CharacterType.Player then  
		if GameCtrl.isTuoguan == true then 
			--托管
			Player.TuoguanFunc()
		else 
			 --玩家出牌
			 --判断如果玩家手上的牌没有大过桌上的牌，则显示要不起，不显示出牌，提示，不出
			local canplay = Player.CheckCanPlay()
			if canplay == true then
				Event.Brocast(GameEvent.ShowPlay,true,self.bigest ~= self.currentAuthority)--第三个参数：如果桌上的牌不是自己打的，则显示提示和不出，如果是自己打的，不显示提示和不出
			else
				Event.Brocast(GameEvent.ShowYaobuqi,true)
			end
		end 
	end 
end 
function OrderCtrl.PlayerPlay()
	if GameCtrl.isTuoguan == true then return end 
	local canplay = Player.CheckCanPlay()
	if canplay == true then
		Event.Brocast(GameEvent.ShowPlay,true,self.bigest ~= CharacterType.Player)--第三个参数：如果桌上的牌不是自己打的，则显示提示和不出，如果是自己打的，不显示提示和不出
		Event.Brocast(GameEvent.ShowYaobuqi,false)
	else
		Event.Brocast(GameEvent.ShowYaobuqi,true)
		Event.Brocast(GameEvent.ShowPlay,false,self.bigest ~= CharacterType.Player)
	end
end