
local this = LuaObject:New()
GPlayer = this



	
function this:New(json)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o:Awake(json);
    return o;    --返回自身
end

function this:clearLuaValue()
	self.uid = 0;
	self.level = 0
	self.vip = 0
	self.avatar =0
	self.money = 0
	self.yuanbao = 0
	self.nickname = ""
	self.ip = ""

end
function this:Init()
	self.uid = 0;
	self.level = 0
	self.vip = 0
	self.avatar =0
	self.money = 0
	self.yuanbao = 0
	self.nickname = ""
	self.ip = ""
	
	
end
function this:Awake(json)
	
	self:Init();
	
	self.uid = tonumber(json[1]);
	self.nickname=json[2];
       self.avatar = tonumber(json[3]);
	self.level=tonumber(json[4]);
	self.vip=tonumber(json[5]);
       self.money = tonumber(json[6]);
	   if self.money == nil then 
		log("服务器发来的数据错误=====");
		self.money = 0;
	elseif type(self.money) ~= "number" then
		self.money = 0;
	   end 
	if  json[7] ~= nil then
		self.ip = json[7]; 
	end
	if  json[8] ~= nil then
		self.yuanbao = json[8];  
	end
	
	
end