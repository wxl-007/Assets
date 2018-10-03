local this = LuaObject:New()
LuaCount = this

function this:New( gameObj ,sound,soundTime,hideTime,prefix)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj.gameObject = gameObj
	obj.transform  = gameObj.transform
	obj:Awake(sound,soundTime,hideTime,prefix)

	return obj;
end


function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	
	self.TimerItemL = nil
	self.TimerItemR =nil
	self.TimerLabel=nil;
	self.TimerParent=nil;
	self.m_prefix = ""
	self.isStart = false;
	this.soundCount = nil
end

function this:Awake(sound,soundTime,hideTime,prefix) 
	
	if soundTime == nil then soundTime = 5; end
	if hideTime == nil then hideTime = 5; end
	if prefix == nil then prefix = ""; end
	
	--self.TimerItemL = self.transform:FindChild("SpriteL").gameObject:GetComponent("UISprite");
	--self.TimerItemR =self.transform:FindChild("SpriteR").gameObject:GetComponent("UISprite");
	self.TimerLabel=self.transform:FindChild("NNCount/Sprite").gameObject:GetComponent("UILabel")
	self.TimerParent=self.transform:FindChild("NNCount").gameObject:GetComponent("Animator")
	self.soundCount = sound; 
	
	self.m_prefix = prefix 
	self._currTime = 0;
	self._num = 0;
	self.soundTime = soundTime;
	self.hideTime = hideTime;
	self.ishide = false;
	self.needSendMes = false;
	self.obj = nil;
	self.objFunction = nil;
	self.isStart = false
end

function this:Update()
	if self.isStart then
	
		if (os.time() -self._currTime) >= 1 then
			if self._num > 0 then
				self._num = self._num-1;
				self:UpdateHUD(self._num,self.ishide,self.needSendMes)
				if self._num <= self.soundTime and self.soundCount ~= nil and not self.ishide then
					EginTools.PlayEffect(self.soundCount);					
				end
			end
		end
	end
end
function this:SetSendMeessage( obj,objFunction)
	self.obj = obj;
	self.objFunction = objFunction;
end
function this:UpdateHUD( num, hide, needSendMessage)
	self.ishide = hide;
	self.needSendMes = needSendMessage;
	self._currTime =os.time();
	self._num = num;
	self.isStart = true
	
	if num<=self.hideTime and not self.ishide then
		self.transform.localScale = Vector3.one;
		
		local timerStr = num<10 and "0"..num or tostring(num);
	
		--self.TimerItemL.spriteName = self.m_prefix..string.sub(timerStr,1, 1);
		--self.TimerItemR.spriteName = self.m_prefix..string.sub(timerStr,2, 2);
		self.TimerLabel.text=timerStr;
		self.TimerParent:Play("time_anima");
	end
	
	if num == 0 then
		self.TimerParent:Play("time_anima_default");
		if needSendMessage then 
			self.objFunction(self.obj);
		end 
		self:DestroyHUD(true);
	end
end

function this:DestroyHUD(hide)
	self.ishide = hide;
	self.transform.localScale = Vector3.New(0.001,0.001,0.001);
end


