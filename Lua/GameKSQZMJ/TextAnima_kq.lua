local this = LuaObject:New()
TextAnima_kq = this 
--[[
function this:New(gameobj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.gameObject = gameobj;
	o.transform = gameobj.transform;
	return o;    --返回自身
end
]]
function this:New( gameObj )
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj.gameObject = gameObj
	obj.transform  = gameObj.transform
	obj:Awake()
	return obj;
end


function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	
	self.lb = nil;
	--self.winFont = nil;
	--self.loseFont = nil;
	self.resultNum = "";
	self.isPlaying=false;
	self.duration = 0;
	self.maxSec = 1.0;
	self.useSign = true;
	self.deltaTime = 0;
	self.isNegative = false;
	self.resultNum2 = 0;
	self.plusNum = 0;
end
function this:Init()
	--初始化变量
	self.lb = self.gameObject:GetComponent("UILabel");
	--self.winFont = self.transform:FindChild("winFont").gameObject:GetComponent("UIFont");
	--self.loseFont = self.transform:FindChild("loseFont").gameObject:GetComponent("UIFont");
	
	self.resultNum = "";
	self.isPlaying=false;
	self.duration = 0;
	self.maxSec = 1.0;
	self.useSign = true;
	self.deltaTime = 0;
	self.isNegative = false;
	self.resultNum2 = 0;
	self.plusNum = 0;
end
function this:Awake (maxSec,useSign) 
	self:Init()
	self.maxSec = maxSec;
	self.useSign = useSign;
end

-- Update is called once per frame
function this:Update () 
	--log("分数");
	--log(self.isPlaying);
	if self.isPlaying  then
		--log("积分");
		self.deltaTime = self.deltaTime +Time.deltaTime;
		self.duration = self.duration +Time.deltaTime;
		if self.deltaTime >= 0.05 then
			local randStr="";
			if self.useSign then
				if self.isNegative then
					--randStr = "-";
				else
					randStr = "+";
				end
			end
			local plusValue = self.resultNum2/(self.maxSec/0.05);
			randStr = randStr..tostring(self.plusNum);
			self.plusNum = self.plusNum +math.floor(plusValue);
			--[[
			local lenTemp = string.len(self.resultNum);
			for  i=1, lenTemp do 
				randStr = randStr..tostring(math.floor(math.Random(0,10)));
			end
			]]
			self.deltaTime = 0;
			--if tonumber(randStr)>0 then
				--self.lb.text ="+"..randStr;
			--else
				self.lb.text =randStr;
			--end
		end
		
		if self.duration >= self.maxSec then
			self.isPlaying = false;
			self.duration = 0;
			if self.useSign then
				if self.isNegative then
					self.resultNum = "-".. self.resultNum;
				else
					self.resultNum = "+".. self.resultNum;
				end
			end
			self.lb.text = self.resultNum;
		end
	end
end

function this:play( num)
	--log(num);
	--log("得分");
	if num<0 then
		self.isNegative = true;
		--if self.loseFont ~= nil then
			--self.lb.bitmapFont = self.loseFont;
		--end
	else
		self.isNegative = false;
		--if self.winFont ~= nil then
			--self.lb.bitmapFont = self.winFont;
		--end
	end
	self.resultNum =  tostring(math.abs(num));
	self.isPlaying = true;
	self.duration = 0;
	self.resultNum2 = num;
	self.plusNum = 0;
end

function this:stop( num)
	if num ==nil then num = 0 end
	self.isPlaying = false;
	self.lb.text = tostring(num) ;
end