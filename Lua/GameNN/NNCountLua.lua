
local this = LuaObject:New()
NNCountLua = this

this.TimerItemL = nil;
this.TimerItemR = nil
this.soundCount = nil
this.m_prefix = ""
this.gameObject = nil;
this.transform = nil;
this.isStart = false;
this._currTime = 0;
this._num = 20;

function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	
	self.TimerItemL = nil
	self.TimerItemR =nil
	self.m_prefix = ""
	self.isStart = false;
	this.soundCount = nil
end
function this:Init()
--初始化变量
	self.TimerItemL = self.transform:FindChild("SpriteL").gameObject:GetComponent("UISprite");
	self.TimerItemR =self.transform:FindChild("SpriteR").gameObject:GetComponent("UISprite");
	self.m_prefix = ""
	self.isStart = false;
	this.soundCount = ResManager:LoadAsset("gamenn/Sound","djs1") 
end
function this:Awake(gameobj)
	self.gameObject = gameobj;
	self.transform = gameobj.transform;
	self:Init();
	
	self.isStart = true
end

function this:Update()
	if self.isStart then
		if (Time.time -self._currTime) >= 1 then
			if self._num > 0 then
				self._num = self._num-1;
				self:UpdateHUD(self._num)
				if self._num <= 5 and self.soundCount ~= nil then
					EginTools.PlayEffect(self.soundCount);
				end
			end
		end
	end
end

function this:UpdateHUD( _time)
	self._currTime = Time.time;
	self._num = _time;
	if self.gameObject.activeSelf then 
		self.gameObject:SetActive(true);
	end
	local timerStr = _time<10 and "0".._time or tostring(_time);
	
	self.TimerItemL.spriteName = self.m_prefix..string.sub(timerStr,1, 1);
	self.TimerItemR.spriteName = self.m_prefix..string.sub(timerStr,2, 2);
end

function this:DestroyHUD()
	if self.gameObject.activeSelf then 
		self.gameObject:SetActive(false);
	end
end


