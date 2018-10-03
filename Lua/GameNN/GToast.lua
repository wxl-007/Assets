
local this = LuaObject:New()
GToast = this

this.mToastContext = nil;
this.mToastBackground = nil;

	
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
	self.mToastContext = nil
	self.mToastBackground =nil

	self.ToastNew1 = nil
	self.ToastNew2 =nil
	self.ToastNew3 = nil
	 self.Toast3 = false
		
	self.ToastNew1Text = nil
	self.ToastNew2Text = nil
	self.ToastNew3Text = nil
end
function this:Init()
--初始化变量
	self.mToastContext = self.transform:FindChild("ToastLabel").gameObject:GetComponent("UILabel");
	self.mToastBackground = self.transform:FindChild("ToastBG").gameObject:GetComponent("UISprite");

	self.ToastNew1 = self.transform:FindChild("ToastNew1")
	self.ToastNew2 = self.transform:FindChild("ToastNew2")
	self.ToastNew3 = self.transform:FindChild("ToastNew3")
	if self.ToastNew1 ~= nil then
		self.ToastNew1 = self.ToastNew1.gameObject:GetComponent("Animation");
		self.ToastNew2 = self.ToastNew2.gameObject:GetComponent("Animation");
		 self.Toast3 = false
		
		self.ToastNew1Text = self.ToastNew1.transform:FindChild("text").gameObject:GetComponent("UISprite");
		self.ToastNew2Text = self.ToastNew2.transform:FindChild("text").gameObject:GetComponent("UISprite");
		self.ToastNew3Text = self.ToastNew3.transform:FindChild("text").gameObject:GetComponent("UISprite");
	end
	
end
function this:Awake()
	
	self:Init();

	------------逻辑代码------------
	
end
this.showTimeLocal = 0;
this.alpha = 1;
function this:Show( showTime, ctnStr)
		if self.Toast3 then return; end
		self.mToastContext.text = ctnStr;
		self:SetToastAlpha (1.0);
		
		--临时修改
		--iTween.NGUIFadeTo (self.gameObject, iTween.Hash ("from",1.0,"to",0.0,"time",1.0,"delay",showTime,"onupdate","SetToastAlpha","nguitarget",self.mToastContext));
		--iTween.NGUIFadeTo (self.gameObject, iTween.Hash ("from",1.0,"to",0.0,"time",1.0,"delay",showTime,"onupdate","SetToastAlpha","nguitarget",self.mToastBackground));
		
		self.showTimeLocal = showTime;
		self.alpha = 1;
		coroutine.start(self.Update,self);
end
function this:ShowToastNew1(ctnStr)
		if self.Toast3 then return; end
		self.ToastNew1Text.spriteName = ctnStr
		 self.ToastNew1:Play();  
end
function this:ShowToastNew2(ctnStr)  
		if self.Toast3 then return; end
		self.ToastNew2.gameObject:SetActive(true);
		self.ToastNew2Text.spriteName = ctnStr
		self.ToastNew2:Play();
end
function this:ShowToastNew3(ctnStr)  
		if not self.Toast3 then
			self.Toast3 = true;
			self.ToastNew3.gameObject:SetActive(true);
			self.ToastNew3Text.spriteName = ctnStr
			self.ToastNew3.gameObject:GetComponent("Animation"):Play("ToastAnimation3"); 
		end 
end
function this:EndToastNew3()    
		if self.Toast3 then
			self.Toast3 = false;
			self.ToastNew3.gameObject:SetActive(false);
			--self.ToastNew3.gameObject:GetComponent("Animation"):Play("ToastAnimation4");
		end 
end
function this.Update(self)
	coroutine.wait(self.showTimeLocal);
	while self.mToastContext do
		self.alpha= self.alpha-0.1;
		self:SetToastAlpha (self.alpha);
		coroutine.wait(0.1);
		if self.alpha<=0 then
			self.alpha = 1;
			return;
		end
	end
end
function this:SetToastAlpha( alpha)
		self.mToastContext.alpha = alpha;
		self.mToastBackground.alpha = alpha;
		
end