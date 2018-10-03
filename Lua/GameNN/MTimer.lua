
local this = LuaObject:New()
MTimer = this

this.TimerItem1 = nil;
this.TimerItem2 = nil
this.m_prefix = ""

this.isStart = false;
this.endTime = 0;
this.m_run = nil
function this:New(gameobj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.gameObject = gameobj;
	o.transform = gameobj.transform;
	o:Awake();
    return o;    --返回自身
end

function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	self.TimerItem1 = nil
	self.TimerItem2 =nil
	self.m_prefix = ""
	self.isStart = false;
	self.endTime = 0;
	self.m_run = nil
end
function this:Init()
--初始化变量
	self.TimerItem1 = self.transform:FindChild("TimeItem0").gameObject:GetComponent("UISprite");
	self.TimerItem2 =self.transform:FindChild("TimeItem1").gameObject:GetComponent("UISprite");
	self.m_prefix = ""
	self.isStart = false;
	self.endTime = 0;
	self.m_run = nil
end
function this:Awake()
	
	self:Init();

	
	----------绑定按钮事件--------
	
	
	------------逻辑代码------------
	--coroutine.start(this.Update);
	self.isStart = true;
end

function this:Update()
	if self.isStart then
		if self.endTime > 0 then
			self.endTime = self.endTime - 0.1;
			if self.endTime <= 0 then
				self.endTime  = 0
			end
			self:ShowCurTimer(self.endTime)
		else
			self.isStart = false;
			self:OnTimeComplete()
		end
	end
end

function this:SetMaxTime( timeC)
	self:SetTime(timeC, "mx_");
end

function this:SetTime( timeC,prefix, run )
	if run==nil then
		run = function() end
	end
	self:ClearTimer ();
	
	self.m_prefix = prefix;
	self.endTime = timeC;
	self.isStart = true;
	self.m_run = run
end
function this:OnTimeComplete()
	if self.m_run ~= nil then
		self.m_run();
	end
end

--清除时间
function this:ClearTimer()
	self:ShowCurTimer (0);
end
--截取字符串分别显示倒计时的时间
function this:ShowCurTimer( _time)
	local timerStr = ""..math.floor(_time) -- SimpleFrameworkUtilstringFormat ("{0:d2}",_time);
	local t1 = 0;
	local t2 = 0;
	if _time >= 10 then
		t1 = tonumber(string.sub(timerStr,1, 1));
		t2 = tonumber(string.sub(timerStr,2, 2));
	else
		t1 = 0;
		t2 = tonumber(timerStr);
	end
	
	self.TimerItem1.spriteName = self.m_prefix..Define.NN_TIMER_NUM[t1+1];
	self.TimerItem2.spriteName = self.m_prefix..Define.NN_TIMER_NUM[t2+1];
end



