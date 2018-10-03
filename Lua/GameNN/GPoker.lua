require "GameNN/Define"
local this = LuaObject:New()
GPoker = this


this.Value =0;
this.Depth  = 0;
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
	self.Value =0;
	self.Depth  = 0;
	self.Pokersprite = nil;
end
function this:Init()
--初始化变量
	self.Value =0;
	self.Depth  = 0;
	self.Pokersprite = nil;
end
function this:Awake()
	
	self:Init();
	----------绑定按钮事件--------
	------------逻辑代码------------
end
function this:SetValue(value)
	if value < 52 then
		self.Value = value +1;
	else
		self.Value = value;
	end
end
function this:MoveFrom( x, y, w, h, timeC, delay)
	local localSelf = self;
	local tempRun = function ()   
		local sp=localSelf.gameObject:GetComponent("UISprite");
		sp.alpha=1.0;
	
		local scaleVec3 =Vector3.New(  math.abs(w / sp.width),  math.abs(h / sp.height), 0);
	
		iTween.ScaleFrom (localSelf.gameObject, iTween.Hash ("scale",scaleVec3,"time",timeC));
	
		iTween.MoveFrom (localSelf.gameObject, iTween.Hash ("position",Vector3.New(x, y, 0),"time",timeC,"islocal", true));
	end
	coroutine.start(self.AssistDo,self,delay,tempRun);
end
function this:MoveFromNew( x, y, w, h, timeC, delay)
	local localSelf = self;
	 
	local tempRun = function ()   
		local sp=localSelf.gameObject:GetComponent("UISprite");
		sp.alpha=1.0;
		localSelf.gameObject.transform.localRotation = Quaternion.Euler(0,0,180)
		local scaleVec3 =Vector3.New(  math.abs(w / sp.width),  math.abs(h / sp.height), 0);
		
		iTween.ScaleFrom (localSelf.gameObject, iTween.Hash ("scale",scaleVec3,"time",timeC));
		iTween.RotateTo (localSelf.gameObject, iTween.Hash ("z",0,"time",timeC));
		iTween.MoveFrom (localSelf.gameObject, iTween.Hash ("position",Vector3.New(x, y, 0),"time",timeC,"islocal", true,"easeType", iTween.EaseType.linear));
	end
	coroutine.start(self.AssistDo,self,delay,tempRun);
	
	return  delay+timeC;
end
function this:MoveFrom30M( x, y, w, h, timeC, delay)
	local localSelf = self;
	local tempRun = function ()   
		local sp=localSelf.gameObject:GetComponent("UISprite");
		
		sp.spriteName=Define.NN_POKER_TYP[localSelf.Value+1];
		sp.alpha=1.0;

		iTween.MoveFrom (localSelf.gameObject, iTween.Hash ("position",Vector3.New(x, y, 0),"time",timeC,"islocal", true));
	end
	coroutine.start(self.AssistDo,self,delay,tempRun);
end
function this:MoveFrom_1( x,  y,  w,  h,  timeC,  delay,  target)
	local localSelf = self;
	local tempRun = function ()   
		local sp = localSelf.gameObject:GetComponent("UISprite");
		sp.alpha = 1.0;
		local scaleVec3 = Vector3.New(  math.abs(w / sp.width),  math.abs(h / sp.height), 0);
		iTween.ScaleFrom (localSelf.gameObject, iTween.Hash ("scale",scaleVec3,"time",timeC));
		iTween.MoveFrom (localSelf.gameObject, iTween.Hash ("position",Vector3.New(target.localPosition.x, target.localPosition.y, 0),"time",timeC,"islocal", true));
	end
	coroutine.start(self.AssistDo,self,delay,tempRun);
	
end
function this:ScaleChange( timeC, delay, pokersprite)

	self.Pokersprite = pokersprite;

	iTween.ScaleTo (self.gameObject, iTween.Hash ("x",0.00001,"time",timeC*0.5,"delay",delay));
	
	local localSelf = self;
	coroutine.start(self.AssistDo,self,delay + timeC * 0.5,this.runUISprite,timeC);
end
function this.runUISprite(localSelf,timeC)
	if not IsNil(localSelf.gameObject)  then
		if localSelf.Pokersprite == nil then
			localSelf.gameObject:GetComponent("UISprite").spriteName = Define.NN_POKER_TYP[localSelf.Value+1];
		else
			localSelf.gameObject:GetComponent("UISprite").spriteName = localSelf.Pokersprite;
			localSelf.Pokersprite = nil;
		end
		
		iTween.ScaleTo (localSelf.gameObject, iTween.Hash ("x",1.0,"time",timeC*0.5));
	end 
	
end
function this.AssistDo(self, offset,run,timeC)
	
	coroutine.wait(offset);	
	if not IsNil(self.gameObject) then
		run(self,timeC);
	end
end

