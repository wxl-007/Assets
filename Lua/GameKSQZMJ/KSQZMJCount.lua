local cjson=require "cjson"

local this = LuaObject:New()
KSQZMJCount = this

this.TimerItemL = nil;
this.TimerItemR = nil
this.soundCount = nil
this.m_prefix = "time_"
this.gameObject = nils
this.transform = nil;
this.isStart = false;
this._currTime = 0;
this._num = 20;
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
	
	self.TimerItemL = nil
	self.TimerItemR =nil
	self.m_prefix = "time_"
	self.isStart = false;
	this.soundCount = nil
end
function this:Init()
--初始化变量
	self.TimerItemL = self.transform:FindChild("SpriteL").gameObject:GetComponent("UISprite");
	self.TimerItemR =self.transform:FindChild("SpriteR").gameObject:GetComponent("UISprite");
	self.m_prefix = "time_"
	self.isStart = false;
	this.soundCount = ResManager:LoadAsset("gamenn/Sound","djs1") 
end
function this:Awake(gameobj)
	self:Init();
	self.isStart = true;
end

function this:Update()
	--log(self.isStart);
	--log("是否开始倒计时");
	if self.isStart then
		--log("开始倒计时");
		if (Time.time -self._currTime) >= 1 then
			if self._num > 0 then
				self._num = self._num-1;
				self:UpdateHUD(self._num)
				if self._num <= 5 and self.soundCount ~= nil then
					EginTools.PlayEffect(self.soundCount);
					if self._num==2 then
						if GameKSQZMJ.isOwnCanHuPai and GameKSQZMJ.AlreadyTing and GameKSQZMJ.playingIsOwn then
							local liebiao={};
							local liebiaonei={"[]"};
							table.insert(liebiao,0);
							table.insert(liebiao,liebiaonei);
							local sendData={type="mj7",tag="f",body=liebiao};
							GameKSQZMJ.mono:SendPackage(cjson.encode(sendData));
							GameKSQZMJ:HideTanKuang();
						end
					elseif self._num==1 then
						if GameKSQZMJ.isOwnCanHuPai and GameKSQZMJ.AlreadyTing then
						
						else
							GameKSQZMJ.isOwnChuPai=false;
						end
					elseif self._num==0 then
						if GameKSQZMJ.isOwnCaoZuo then
							--GameKSQZMJ:TuoGuanState(tonumber(EginUser.Instance.uid),1,false,false);
							GameKSQZMJ:HideTanKuang();
						end
					end
				end
			end
		end
	end
end

function this:UpdateHUD( _time)
	--log(_time.."时间");
	if not self.gameObject.activeSelf then
		--self.gameObject:SetActive(true);
	end
	self._currTime = Time.time;
	self._num = _time;
	local timerStr = _time<10 and "0".._time or tostring(_time);
	self.TimerItemL.spriteName = self.m_prefix..string.sub(timerStr,1, 1);
	self.TimerItemR.spriteName = self.m_prefix..string.sub(timerStr,2, 2);
	if self._num==0 then
		self:DestroyHUD();
	end
end

function this:DestroyHUD()
	if self.gameObject.activeSelf then 
		self.gameObject:SetActive(false);
	end
end


