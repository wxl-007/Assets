StandPlayer = {}
local self = StandPlayer

function StandPlayer.Awake(obj)
	self.gameObject = obj
	self.transform = obj.transform
	self.init()
end 

function StandPlayer.init()
	self.Animator = self.gameObject:GetComponent('Animator');
end

--主界面待机
function StandPlayer.Event5()
	local rand = math.random(1,2) 
	if rand == 1 then
		self.StandbyAnimator1()
	elseif rand == 2 then
		self.StandbyAnimator2()
	end
end

--站立1
function StandPlayer.StandbyAnimator1()
	self.Animator:SetTrigger("Standby1")
end
--站立2
function StandPlayer.StandbyAnimator2()
	self.Animator:SetTrigger("Standby2")
end