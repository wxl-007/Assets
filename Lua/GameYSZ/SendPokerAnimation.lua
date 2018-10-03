local this = LuaObject:New()
SendPokerAnimation = this
	
function this:New(gameobj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.gameObject = gameobj;
	o.transform = gameobj.transform;
	o:Awake();
	o:Start();
    return o;    --返回自身
end


function this:clearLuaValue()
	self.gameObject = nil;
	self.transform = nil
	
	self.Parent = nil;
	self.Poker = nil;
	self.angel = nil;
	self.aspd = nil;
	self.interval = nil;
	self.AMOUNT = 30;
	self.obj = nil;
	self.preObj = nil;
	self.depthCount = 0;
	self.curIndex =0;
	self.pokerList = nil;
	self.players = {};
	self.pointer = 0;
	self.sendCardAmount = 0;
	
	self.InvokeLua:clearLuaValue();
	self.InvokeLua = nil;
end
function this:InitVariate()

	--初始化变量
	self.AMOUNT = 30;
	self.obj = nil;
	self.preObj = nil;
	self.depthCount = 0;
	self.curIndex =0;
	self.pokerList = nil;
	self.players = {};
	self.pointer = 0;
	self.sendCardAmount = 0;
	
	
	
	self.Parent = self.gameObject;
	self.Poker = ResManager:LoadAsset("gameysz/Prefabs","Poker_parent");
	self.angel = -128;
	self.aspd = -2.5;
	self.interval = 0.04;
	self.InvokeLua = InvokeLua:New(self);
end

function this:Awake()
	self:InitVariate();
end
function this:Start()
	self.Parent.transform.localEulerAngles=Vector3.zero;
	self.pokerList = {};
	self.players   = {};
	local depth = 1;
	for  i = 0, self.AMOUNT-1  do 
		self.obj = GameObject.Instantiate(self.Poker);
		self.obj.transform.localEulerAngles = Vector3.New(0, 0, self.angel);
		self.obj.transform.position = self.Parent.transform.position;
		self.obj.transform.parent = self.Parent.transform;
		self.obj.transform.localScale = Vector3.one;
		self.obj.name = "poker".. i;
		table.insert(self.pokerList,self.obj);
		self.depthCount = i;
		self.depthCount = self.depthCount +depth;

		self.obj.transform:FindChild("Poker"):GetComponent("UISprite").depth = self.AMOUNT - i+5;
		
		self.angel =self.angel - self.aspd;
		local vc = Vector3.New(math.cos(self.angel * math.pi / 180) * self.interval, math.sin(self.angel * math.pi / 180) * self.interval,0);
	   
		if self.preObj ~= nil then
			self.obj.transform.position = vc:Add(self.preObj.transform.position);
		end
		self.preObj = self.obj;
	end
	self:Init();
end
function this:Init()
	for k, pokerObj in ipairs(self.pokerList) do
		pokerObj:SetActive(false);
	end
end
function this:setupPlayer( playerCtrl)
	 table.insert(self.players,playerCtrl);
	self.sendCardAmount = self.sendCardAmount + 5;
end
function this:pokerShow()
	if not self.InvokeLua:IsInvoking("pokeAnimation") then
		self.curIndex = self.AMOUNT -1;
		self.InvokeLua:InvokeRepeating("pokeAnimation",self.pokeAnimation, 0.2, 0.01);
	end
	return self.sendCardAmount*0.1 + 0.5;
end

function this:pokeAnimation()
	if self.curIndex<= #(self.pokerList)  and self.curIndex>=0 then
		self.pokerList[self.curIndex+1]:SetActive(true);
		self.curIndex=self.curIndex-1;
	end
	if self.curIndex == -1 then
		self.InvokeLua:CancelInvoke("pokeAnimation");
		self:sendPokerAnima();
	end
end

function this:sendPokerAnima() 
	if not self.InvokeLua:IsInvoking("pokerAnimtionHide") then
		self.curIndex = 0;
		self.InvokeLua:InvokeRepeating("pokerAnimtionHide",self.pokerAnimtionHide, 0.1, 0.1);
	end
end
function this:pokerAnimtionHide() 
	if self.curIndex < self.sendCardAmount and self.curIndex>=0 then
		self.pokerList[self.curIndex+1]:SetActive(false);
		self:flyToPlayer(self.curIndex);
		self.curIndex = self.curIndex+1;
	end
	if self.curIndex == self.sendCardAmount then
		self.InvokeLua:CancelInvoke("pokerAnimtionHide");
		self.players = {};
		self.sendCardAmount = 0;
		self:Init();
	end
end
function this:flyToPlayer( index)
	local player = self.players[(self.pointer % #(self.players))+1 ];
	self.pointer = self.pointer+1;
	local pokerObj = self.pokerList[index+1];
	player:cardFlyToDeck(pokerObj);
end
