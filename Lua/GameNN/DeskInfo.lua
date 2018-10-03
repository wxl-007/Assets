
local this = LuaObject:New()
DeskInfo = this

--动画使用缩放系数
local Vector3Bet1 = Vector3.New(1.5,1.5,1);
local Vector3Bet2 = Vector3.New(1.1,1.1,1);
--移除屏幕外坐标
local Vector3Bet3 = Vector3.New(99999,99999,1);
--下注飞行时最大筹码数
local BetMaxNum = 10;
--下注飞行速度
local BetV = 0.3;
--最大筹码数
local AllBetMaxNum = 100;	--红米--80
--在座玩家返还金币最大筹码数
local SitBetMaxNum = 7;	--红米--7
--对象池数量
local PoolOBJNum = 200;	--红米--160
this.deskPool = nil;              --实例化出的下注筹码的父物体
this.bgound = nil;                 --黄色的框
this.btextv0 = nil;                 --总的下注金额
this.btextv0BG = nil;              --下注金额背景
this.btextv1 = nil;                 --自己的下注金额
this.btextv1BG = nil;              --下注金额背景
this.allMoney = 0;                   --所有的下注金额数目
this.betMoney = 0;                   --自己的下注金额数目
this.betMoneytrue = 0; 
this.target = nil;
this.endtarget = nil;
this.jettons = {};
this.wuParticle = nil;
this.heguanParticle = nil
this.wuParticle2 = nil;
function this:New(gameobj,name)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.gameObject = gameobj;
	o.transform = gameobj.transform;
	o:Awake(name);
    return o;    --返回自身
end

function this:clearLuaValue()
	
	self.deskPool = nil;              --实例化出的下注筹码的父物体
	self.bgound = nil;                 --黄色的框
	self.btextv0 = nil;                 --总的下注金额
	self.btextv0BG = nil;              --下注金额背景
	self.btextv1 = nil;                 --自己的下注金额
	self.btextv1BG = nil;              --下注金额背景
	self.allMoney = 0;                   --所有的下注金额数目
	self.betMoney = 0;                   --自己的下注金额数目
	self.betMoneytrue = 0; 
	self.target = nil;
	self.endtarget = nil; 
	self.objPool = nil;
	self.sitBetArr = {}
	self.jettons = {};
	self.sec30_chips = {};
	
	if self.objPool ~= nil then 
		self.objPool:clearLuaValue();
		self.objPool = nil;
	end
end

function this:Init(name)
	self.objPool = nil; 
	self.deskPool = self.transform:FindChild("DeskPool");              --实例化出的下注筹码的父物体
	if name == "mxnn" then
	
		self.target = self.transform:FindChild("target");
		self.wuParticle2 = self.target:FindChild("testCoinPtPrb2/testCoinParticles2").gameObject
		local PwuParticle2 =  self.target:FindChild("testCoinPtPrb2")
		local WuParticleSystem2 =  self.wuParticle2:GetComponent("ParticleSystem")
		if GameMXNN.HOrW >0.56 then  
			local BetSNum = 1.514-0.914*GameMXNN.HOrW 
			self.wuParticle2.transform.localScale =   Vector3.New(BetSNum,BetSNum,BetSNum)
			local BetRNum = 22.857*GameMXNN.HOrW -12.857     
			log(PwuParticle2.localRotation.z.."===="..PwuParticle2.localRotation.eulerAngles.z)
			PwuParticle2.localRotation =Quaternion.Euler(0, 0,PwuParticle2.localRotation.eulerAngles.z-BetRNum);
		end 
		if self.gameObject.name == "BetDesk0" then
			self.bgound = self.transform.parent.parent:FindChild("3Layout/Shuyingkuang/Kuang_B0").gameObject:GetComponent("UISprite");                 --黄色的框
			self.x = 10
			self.y = 10
			--BetMaxNum = 20
			BetV = 0.5
			if GameMXNN.HOrW <0.56 then   
				--0==1.1-0.8*this.HOrW  R==-100-21.3333*this.HOrW    
				WuParticleSystem2.startLifetime = 1.1-0.8*GameMXNN.HOrW 
				local BetRNum = -21.3333*GameMXNN.HOrW -100  
				PwuParticle2.localRotation =Quaternion.Euler(0, 0, BetRNum);
			end 
		elseif  self.gameObject.name == "BetDesk1" then
			self.bgound = self.transform.parent.parent:FindChild("3Layout/Shuyingkuang/Kuang_B1").gameObject:GetComponent("UISprite");                 --黄色的框
			self.x = 12
			self.y = 10
			--BetMaxNum = 20
			BetV = 0.45
			if GameMXNN.HOrW <0.56 then  
		  
				--1==1.2-1.0667*this.HOrW  R==-92-48*this.HOrW  
				WuParticleSystem2.startLifetime = 1.2-1.0667*GameMXNN.HOrW 
				local BetRNum = -48*GameMXNN.HOrW -92  
				PwuParticle2.localRotation =Quaternion.Euler(0, 0, BetRNum);
			end 
		elseif  self.gameObject.name == "BetDesk2" then
			self.bgound = self.transform.parent.parent:FindChild("3Layout/Shuyingkuang/Kuang_B2").gameObject:GetComponent("UISprite");                 --黄色的框
			self.x = 30
			self.y = 10
			--BetMaxNum = 20
			BetV = 0.4
			if GameMXNN.HOrW <0.56 then  
		  
				--2==1.1-1.0667*this.HOrW  R==-94-64*this.HOrW 
				WuParticleSystem2.startLifetime = 1.1-1.0667*GameMXNN.HOrW 
				local BetRNum = -64*GameMXNN.HOrW -94  
				PwuParticle2.localRotation =Quaternion.Euler(0, 0, BetRNum);				
			end 
		elseif  self.gameObject.name == "BetDesk3" then
			self.bgound = self.transform.parent.parent:FindChild("3Layout/Shuyingkuang/Kuang_B3").gameObject:GetComponent("UISprite");                 --黄色的框
			self.x = 40
			self.y = 10
			--BetMaxNum = 20
			BetV = 0.35
			if GameMXNN.HOrW <0.56 then   
				--3==1.25-1.333*this.HOrW  R==-104-64*this.HOrW 
				WuParticleSystem2.startLifetime = 1.25-1.333*GameMXNN.HOrW 
				local BetRNum = -64*GameMXNN.HOrW -104  
				PwuParticle2.localRotation =Quaternion.Euler(0, 0, BetRNum);
			end 
		end
		self.xLv = (self.bgound.width-30);
		self.yLv = (self.bgound.height-20);
		self.x = (self.bgound.width * 0.5+5)-self.x
		self.y = (self.bgound.height * 0.5-20)-self.y
		
		self.btextv0 = self.transform:FindChild("DeskLabelTop_1").gameObject:GetComponent("UILabel");                 --总的下注金额
		self.btextv0BG = self.transform:FindChild("DeskBGTop").gameObject:GetComponent("UISprite");              --下注金额背景
		self.btextv1 = self.transform:FindChild("DeskLabelBot_1").gameObject:GetComponent("UILabel");                 --自己的下注金额
		self.btextv1BG = self.transform:FindChild("DeskBGBot").gameObject:GetComponent("UISprite");              --下注金额背景
		
		self.endtarget = self.transform:FindChild("endtarget");
		self.kuangliang =  self.transform:FindChild("Kuang_liang").gameObject:GetComponent("UISprite");
		self.heguanParticle = self.endtarget:FindChild("testCoinPtPrb0/testCoinParticles").gameObject
		self.heguanParticle.transform.localScale =  GameMXNN.HeGuanSNum 
		self.heguanParticle.transform:FindChild("subCoinPt1").localScale =  GameMXNN.HeGuanSNum  
		self.heguanParticle.transform:FindChild("subCoinPt2").localScale =  GameMXNN.HeGuanSNum  
		
		self.isWuParticle2 = false;
		self.isWuParticle2Active = false;
		self.DeskBetPoolArr = {}; 
		self.sitArr={}
		self.sitBetShootArr={}
		self.objPool =  ObjectPool:New();
		coroutine.start(self.Update,self);
		coroutine.start(self.UpdatePool,self);
	elseif name == "brlz" then
		self.bgound = self.transform:FindChild("DeskBG").gameObject:GetComponent("UISprite");
		self.btextv0 = self.transform:FindChild("DeskLabelTop").gameObject:GetComponent("UILabel");                 --总的下注金额
		self.btextv0BG = self.transform:FindChild("DeskBGTop").gameObject:GetComponent("UISprite");              --下注金额背景
		self.btextv1 = self.transform:FindChild("DeskLabelBot").gameObject:GetComponent("UILabel");                 --自己的下注金额
		self.btextv1BG = self.transform:FindChild("DeskBGBot").gameObject:GetComponent("UISprite");              --下注金额背景
	elseif name == "xj" then
		self.target = self.transform:FindChild("target");
		self.bgound = self.transform:FindChild("DeskAva").gameObject:GetComponent("UISprite");
		self.btextv0 = self.transform:FindChild("DeskLabelTop").gameObject:GetComponent("UILabel");                 --总的下注金额
		self.btextv0BG = self.transform:FindChild("DeskBGTop").gameObject:GetComponent("UISprite");              --下注金额背景
		self.btextv1 = self.transform:FindChild("DeskLabelBot").gameObject:GetComponent("UILabel");                 --自己的下注金额
		self.btextv1BG = self.transform:FindChild("DeskBGBot").gameObject:GetComponent("UISprite"); 
		
		self.wuParticle2 = self.target:FindChild("testCoinPtPrb2/testCoinParticles2").gameObject
		
		self.endtarget = self.transform:FindChild("endtarget");
		self.heguanParticle = self.endtarget:FindChild("testCoinPtPrb0/testCoinParticles").gameObject
		--self.heguanParticle.transform.localScale =  GameXJ.HeGuanSNum 
		--self.heguanParticle.transform:FindChild("subCoinPt1").localScale =  GameXJ.HeGuanSNum  
		--self.heguanParticle.transform:FindChild("subCoinPt2").localScale =  GameXJ.HeGuanSNum  
		if self.gameObject.name == "BetDesk0" then
			self.x = 10
			self.y = 10
		elseif self.gameObject.name == "BetDesk1" then
			self.x = 20
			self.y = 10
		elseif self.gameObject.name == "BetDesk2" then
			self.x = 25
			self.y = 10
		end
		self.x = (self.bgound.width * 0.5+5)-self.x
		self.y = (self.bgound.height * 0.5-20)-self.y
		self.xLv = (self.bgound.width-60);
		self.yLv = (self.bgound.height-77);
		self.sitArr={}
		self.DeskBetPoolArr = {}; 		
		self.isWuParticle2 = false;
		self.isWuParticle2Active = false;
		--coroutine.start(self.Update,self);
		self.sitBetShootArr={}
		self.objPool =  ObjectPool:New();
		--log("开始进行操作");
		coroutine.start(self.UpdatePool,self);		
	elseif name == "30m" then
		self.objPool =  ObjectPool:New();
		self.sec30_chips = {};
		self.chipWH = 66;
		self.bgound = self.transform:FindChild("DeskBG").gameObject:GetComponent("UISprite");
		self.btextv0 = self.transform:FindChild("DeskLabelTop").gameObject:GetComponent("UILabel");                 --总的下注金额
		self.btextv0BG = self.transform:FindChild("DeskBGTop").gameObject:GetComponent("UISprite");              --下注金额背景
		self.btextv1 = self.transform:FindChild("DeskLabelBot").gameObject:GetComponent("UILabel");                 --自己的下注金额
		self.btextv1BG = self.transform:FindChild("DeskBGBot").gameObject:GetComponent("UISprite");              --下注金额背景

	end
	

	
	self.allMoney = 0;                   --所有的下注金额数目
	self.betMoney = 0;                   --自己的下注金额数目
	self.betMoneytrue = 0; 
	self.sitBetArr = {}
	self.jettons = {};
	
	self.isPlaying = false;

	self.isBetPoArr1 = true;
	self.BetPoArr1 = {}
	self.BetPoArr2 = {};
	local NumTemp = 1;
	for i=1,4 do
		for j=1,4 do
			local tempBet = {};
			tempBet.x = i;
			tempBet.y = j;
			self.BetPoArr1[NumTemp] = tempBet
			NumTemp =NumTemp+1;
		end 
	end
end
function this:InitObject(jettonPrefab)  
	self.objPool:InitObject(jettonPrefab,PoolOBJNum,true)
	--log("开启对象池=======================sssssssssssssz");
	--log(#(self.objPool.Pool).."=======个数");
	for i=1,PoolOBJNum do 
		local objGameTemp = self.objPool.Pool[i]
		objGameTemp.transform.parent = self.deskPool;
		objGameTemp.transform.localPosition = Vector3Bet3;
		--log(objGameTemp.transform.localPosition);
		objGameTemp.transform.localScale = Vector3.one;	
		objGameTemp.sprite = objGameTemp.gameObj:GetComponent("UISprite");
	end 
end

function this:Sec30_InitObject(chipPrb, poolMaxCount)
	self.objPool:InitObject(chipPrb,poolMaxCount,true)
	log("lua Sec30_InitObject");
	for i=1,poolMaxCount do 
		local objGameTemp = self.objPool.Pool[i]
		objGameTemp.transform.parent = self.deskPool;
		objGameTemp.transform.localPosition = Vector3Bet3;
		--objGameTemp.transform.localScale    = Vector3.New(1,1,1);
		objGameTemp.sprite = objGameTemp.gameObj:GetComponent("UISprite");	 
	end 
end

function this:Sec30_StopChipAnima()
	self.isAddChip =0;
	self.isPlaying = false;
end

function this:Sec30_StartAddChipToDesk()
	if(self.isPlaying)then
		return;
	end
	self.isPlaying = true;
	self.isAddChip =1;
	coroutine.wait(0.1);
	while self.isAddChip==1 do 
		local tpoolObj = self.objPool:GetObject();
		if(tpoolObj ~=nil)then
			local go = tpoolObj.gameObj;
			local x = math.Random(0, 1) * (self.bgound.width- tpoolObj.sprite.width) - self.bgound.width * 0.5  + tpoolObj.sprite.width * 0.5;
			local y = math.Random(0, 1) * (self.bgound.height - tpoolObj.sprite.height) - self.bgound.height * 0.5 + tpoolObj.sprite.height * 0.5;
			go.transform.localPosition = Vector3.New(x, y, 0);
	  		go.transform.localScale = Vector3.New(1.5,1.5, 1.5);
			iTween.ScaleTo(go,iTween.Hash ("scale",Vector3.New(1.1,1.1,1),"time",1.5,  "easeType", iTween.EaseType.linear,  "delay",0.6));
			--table.insert(self.jettons, go);
			table.insert(self.sec30_chips, tpoolObj);
			if(#self.objPool.Pool == 0)then
				self.objPool:SetObject(self.sec30_chips[1]);
				table.remove(self.sec30_chips,1);
			end
		else
			
		end
		coroutine.wait(0.05);
	end
end

function this:Sec30_RandomPos()
	local x = math.Random(0, 1) * (self.bgound.width- self.chipWH) - self.bgound.width * 0.5  + self.chipWH * 0.5;
	local y = math.Random(0, 1) * (self.bgound.height - self.chipWH) - self.bgound.height * 0.5 + self.chipWH * 0.5;
	return Vector3.New(x,y,0);
end

function this:Sec30_ChipsFlyToWinner(winnerPos)
	coroutine.start(function ()
		local len = #self.sec30_chips;
		len = len/5;
		for i,v in ipairs(self.sec30_chips) do
			if(i>0 and i%len == 0)then
				coroutine.wait(0.1);
			end
			v.transform.localPosition = Vector3Bet3;
			self.objPool:SetObject(v);
		end
		self.sec30_chips = {};
	end);

	
end

function this:Sec30_SingleChipFly(startPos, endPos, chipCount, isFlyToDesk, isLocalPos)
	local chipObj = nil;
	local tempPos = Vector3.New(0,0,0);
	for i=1,chipCount do
		if(isFlyToDesk == true)then
			if(#self.objPool.Pool == 0)then
				self.objPool:SetObject(self.sec30_chips[1]);
				table.remove(self.sec30_chips,1);
			end
			chipObj = self.objPool:GetObject();
			table.insert(self.sec30_chips, chipObj);
			chipObj.gameObj.transform.localPosition = self:Sec30_RandomPos();
		else
			local idnex = #self.sec30_chips;
			if(idnex == 0)then
				chipObj = self.objPool:GetObject();
				chipObj.gameObj.transform.localPosition = self:Sec30_RandomPos();
			else
				chipObj = self.sec30_chips[idnex];
				self.objPool:SetObject(chipObj);
				table.remove(self.sec30_chips,idnex);
			end
			tempPos = chipObj.gameObj.transform.position;
			chipObj.transform.position = endPos;
		end
		local go = chipObj.gameObj;
		go.transform.localScale = Vector3.New(1.5,1.5, 1.5);
		if(isFlyToDesk == true)then
			iTween.ScaleTo(go,iTween.Hash ("scale",Vector3.New(1.1,1.1,1),"time",1.2,  "easeType", iTween.EaseType.linear,  "delay",0.3+(i-1)*0.1));
			iTween.MoveFrom(go,iTween.Hash ("position",startPos,"time",0.2, "islocal",isLocalPos, "easeType", iTween.EaseType.linear, "delay", (i-1)*0.1) );
		else
			iTween.MoveFrom(go,iTween.Hash ("position",tempPos,"time",0.2, "islocal",isLocalPos, "easeType", iTween.EaseType.linear, "delay", (i-1)*0.1));
		end
	end
end

function this:Sec30_getObject()
	if(#self.objPool.Pool == 0)then
		self.objPool:SetObject(self.sec30_chips[1]);
		table.remove(self.sec30_chips,1);
	end
	return self.objPool:GetObject();
end
function this:Sec30_ResetDeskInfo()
	NGUITools.SetActive(self.btextv0.gameObject, false);
	NGUITools.SetActive(self.btextv0BG.gameObject, false);
	NGUITools.SetActive(self.btextv1.gameObject, false);
	NGUITools.SetActive(self.btextv1BG.gameObject, false);
	self.allMoney = 0;
	self.betMoney = 0;
	self.betMoneytrue = 0; 
end

function this.Update(self)  
	while self.gameObject do
		if self.kuangliang.alpha>0 then
			self.kuangliang.alpha=self.kuangliang.alpha-0.2;
		end
		coroutine.wait(0.1); 
	end
end
function this.UpdatePool(self)  
	while self.gameObject do 
		if #(self.DeskBetPoolArr) > 0 then
			if self.isWuParticle2 then
				self:BetAnimation2(self.DeskBetPoolArr[1])  
				table.remove(self.DeskBetPoolArr,1) 
			else
				self:BetAnimation(self.DeskBetPoolArr[1],0.7)
				table.remove(self.DeskBetPoolArr,1) 
			end 
		end 
		coroutine.wait(0.15); 
	end
end
function this:Awake(name)
	
	self:Init(name);

	
	
end

function this:SetWuParticle(particleSystem)
	log(particleSystem);
	self.wuParticle = particleSystem
	local scaleto=self.wuParticle.gameObject.transform.localScale;
	scaleto = Vector3.one;--GameXJ.HeGuanSNum
	
	local scale1=self.wuParticle.gameObject.transform:FindChild("subCoinPt1").localScale
	local scale2=self.wuParticle.gameObject.transform:FindChild("subCoinPt2").localScale
	scale1 =  GameXJ.HeGuanSNum  
	scale2 =  GameXJ.HeGuanSNum  
	
	
end
function this:addSitBetArr(nameid)
	 local isNearby = true;
	for k,v in pairs(self.sitBetArr) do
		if nameid == v  then
			isNearby = false;
			break;
		end
	end
	if isNearby then
		table.insert(self.sitBetArr,nameid) 
	end 
end
function this:ReadySitArrBet()
	self.sitBetShootArr={}
	local tempNum = #(self.sitArr)
	local tempNum2 = #(self.jettons)
	if  tempNum > 0 then
	
		local betNum =  (tempNum2-20) /tempNum;
		if betNum > SitBetMaxNum then
			betNum = SitBetMaxNum
		elseif betNum <1 then
			betNum = 1
		end
		for i = 1 ,tempNum do
			local sitPos = self.sitArr[i]
			local tempArr = {} 
			for j = 1 ,betNum do
				if tempNum2 > 0 then
					tempNum2= tempNum2-1;
					local tempObj = self.jettons[tempNum2]
					local goObj = self.objPool:GetObject();
					local go = goObj.gameObj;    
					go.transform.parent = self.deskPool;
					go.transform.localScale = Vector3Bet2;
					goObj.to = tempObj.gameObj.transform.localPosition;   
					goObj.from = sitPos 
					go:GetComponent("UISprite").depth = 299; 
					table.insert(tempArr,goObj); 
				end 
			end 
			table.insert(self.sitBetShootArr,tempArr); 
		end
	end
	
end
function this:ShootSitArrBet() 
	--log("金币飞回玩家手中");
	local tempNum = #(self.sitBetShootArr) 
	--log(tempNum);
	for i = 1 ,tempNum do 
		local tempArr = self.sitBetShootArr[i]
		for j = 1 ,#(tempArr) do 
			local gobjGame = tempArr[j];
			--gobjGame.gameObj:SetActive(true);  
			gobjGame.transform.localPosition = gobjGame.to;			
			coroutine.start(self.AfterDoing,self,j*0.1,function() 
					 --Util.DOMoveLua(gobjGame.gameObj,gobjGame.from,0.6) 
					 iTween.MoveTo(gobjGame.gameObj,iTween.Hash ("position",gobjGame.from,"islocal",true,"time",0.7,"easeType", iTween.EaseType.easeOutCubic));   
					 coroutine.start(self.AfterDoing,self,0.8,function() 
						--gobjGame.gameObj:SetActive(false) 
						gobjGame.transform.localPosition = Vector3Bet3;
						gobjGame.sprite.depth = 0; 
						self.objPool:SetObject(gobjGame);  
					end);
			end);
		end  
	end
	coroutine.start(self.AfterDoing,self,6,function() 
		for i = 1 ,tempNum do 
			local tempArrNum = #(self.sitBetShootArr[i])
			for j = 1 ,tempArrNum do 
				self.sitBetShootArr[i][j].gameObj:GetComponent("UISprite").depth = 300;  
			end  
		end 
		self.sitBetShootArr = {};
		self.sitArr={}
	end);
end
function this:ReadyBetExcursion(_gobjGame,_position) 
	local startposition = _position   
	 
	if startposition.x >0 then
		startposition:Add(Vector3.New(20,0,0))
	else
		startposition:Add(Vector3.New(-20,0,0))
	end
	
	if startposition.y >0 then
		startposition:Add(Vector3.New(0,20,0))
	else
		startposition:Add(Vector3.New(0,-20,0))
	end 
	 _gobjGame.excursion = startposition;
end

function this:ReadyBetExcursionAll() 
	local leng = #(self.jettons);	
	for   i = 1, leng do  
		local gobjGame = self.jettons[i]; 
		self:ReadyBetExcursion(gobjGame,gobjGame.gameObj.transform.localPosition)
	end 
end
--新版明星牛牛每局结束后删除所有实例化出的筹码
--lxtd004 change 2016 6 17 
function this:ResetView_0( beishu)  
	
	local timeC = 3 / #(self.jettons); 
	if  beishu > 0 then 
	
		--[[
		local v = 0; 
		local leng = #(self.jettons);
		local lengNum = leng/10;
		local lengNumTemp = 0;
		local TempNum = 0;  
		for   i = leng, 1,-1 do  
			local gobjGame = self.jettons[i]; 
			local gobj = gobjGame.gameObj;  
			 --Util.DOScaleLua(gobj,Vector3Bet1,0.7) 
			 --Util.iTweenScaleLua(gobj,Vector3Bet1,0.7) 
			--iTween.ScaleTo(gobj,iTween.Hash ("scale",Vector3Bet1,"time",0.7));  
			
			if lengNumTemp < lengNum then  
					if i > 10 then
						coroutine.start(self.AfterDoing,self,TempNum*0.1,function () 
							--iTween.MoveTo(gobj,iTween.Hash ("position",gobjGame.excursion,"islocal",true,"time",0.7,"easeType", iTween.EaseType.linear));  
							Util.DOMoveLua(gobj,gobjGame.excursion,0.7)
						end)  
					end 
				lengNumTemp=lengNumTemp+1;
			else
				lengNumTemp = 0;
				TempNum=TempNum+1;
			end  
			
			coroutine.start(self.AfterDoing,self,v*0.3,function()
				iTween.MoveTo(gobj,iTween.Hash ("position",gobjGame.from,"islocal",true,"time",0.8,"easeType", iTween.EaseType.easeInCubic)); 
				--Util.DOMoveLua(gobj,gobjGame.from,0.6)
				coroutine.start(self.AfterDoing,self,0.9,function()  
					gobjGame.transform.localPosition = Vector3Bet3;
					gobjGame.sprite.depth = 0; 
					self.objPool:SetObject(gobjGame);  
				end);
			end);  
			v = v +timeC;
		end
		
		self.jettons = {}
		]] 
		local leng = #(self.jettons);
		--log(leng.."==========长度");
		if leng > 0 then
			 self.wuParticle.gameObject:SetActive(true);
			 coroutine.start(self.AfterDoing,self,2,function()   
				self.wuParticle.gameObject:SetActive(false);
			end);
			 
			for   i = leng, 1,-1 do  
				local gobjGame = self.jettons[i];
				coroutine.start(self.AfterDoing,self,i%5*0.1,function()   
					gobjGame.transform.localPosition = Vector3Bet3;
					--gobjGame.sprite.depth = 0; 
					self.objPool:SetObject(gobjGame);  
				end);	 
			end
			self.jettons = {}
		end
		
		
		
	else
		--[[  
		local v = 0;
		local leng = #(self.jettons);
		local lengNum = leng/10;
		local lengNumTemp = 0;
		local TempNum = 0;
		local endPos = self.endtarget.localPosition;
		for   i = leng, 1,-1 do
		 
			local gobjGame = self.jettons[i];
			local gobj = gobjGame.gameObj;
			 --iTween.ScaleTo(gobj,iTween.Hash ("scale",Vector3Bet1,"time",0.7));   
			--Util.iTweenScaleLua(gobj,Vector3Bet1,0.7) 
			--Util.DOScaleLua(gobj,Vector3Bet1,0.7)  
			if lengNumTemp < lengNum then 
				coroutine.start(self.AfterDoing,self,TempNum*0.1,function (  )
					iTween.MoveTo(gobj,iTween.Hash ("position",gobjGame.excursion,"islocal",true,"time",0.7,"easeType", iTween.EaseType.linear));
					--Util.DOMoveLua(gobj,gobjGame.excursion,0.7)						
				end)  
				lengNumTemp=lengNumTemp+1;
			else
				lengNumTemp = 0;
				TempNum=TempNum+1;
			end   
			coroutine.start(self.AfterDoing,self,v*0.26,function()
				iTween.MoveTo(gobj,iTween.Hash ("position",endPos,"islocal",true,"time",0.6,"easeType", iTween.EaseType.easeInCubic));   
				--Util.DOMoveLua(gobj,endPos,0.5)
				coroutine.start(self.AfterDoing,self,0.8,function() 
					--gobj:SetActive(false)
					gobjGame.transform.localPosition = Vector3Bet3;
					gobjGame.sprite.depth = 0; 
					self.objPool:SetObject(gobjGame); 
				end);
			end);   
			v = v +timeC; 
		end     
		self.jettons = {}
		]] 
		local leng = #(self.jettons);
		--log(leng.."========------------------=====长度");
		if leng > 0 then
			self.heguanParticle.gameObject:SetActive(true);
			 coroutine.start(self.AfterDoing,self,2,function()   
				self.heguanParticle.gameObject:SetActive(false);
			end);
			local leng = #(self.jettons);
			for   i = leng, 1,-1 do  
				local gobjGame = self.jettons[i];
				coroutine.start(self.AfterDoing,self,i%5*0.1,function()   
					gobjGame.transform.localPosition = Vector3Bet3;
					--gobjGame.sprite.depth = 0; 
					self.objPool:SetObject(gobjGame);  
				end);	 
			end
			self.jettons = {}  
		end
		
	end
	
	NGUITools.SetActive(self.btextv0.gameObject, false);
	NGUITools.SetActive(self.btextv0BG.gameObject, false);
	NGUITools.SetActive(self.btextv1.gameObject, false);
	NGUITools.SetActive(self.btextv1BG.gameObject, false);
	self.allMoney = 0;
	self.betMoney = 0;
	self.betMoneytrue = 0; 
	 
end
--每局结束后删除所有实例化出的筹码
function this:ResetView_1( beishu)

	local timeC = 3 / #(self.jettons);
	if  beishu > 0 then
	
		local v = 0.15;
		local destroy_count = 0;
		
		local leng = #(self.jettons);
		for   i = 1, leng do
		
			local temp = v;
			local gobj = self.jettons[1];
			if  gobj:GetComponent("TweenPosition") then
			
				local startposition = gobj:GetComponent("TweenPosition").to;
				local endposition = gobj:GetComponent("TweenPosition").from;
				destroy(gobj:GetComponent("TweenPosition"));
				coroutine.start(self.AfterDoing,self,temp,function()
					if   not gobj:GetComponent("TweenPosition") then
						gobj:AddComponent(Type.GetType("TweenPosition",true));
						gobj:GetComponent("TweenPosition").from = startposition;
						gobj:GetComponent("TweenPosition").to = endposition; 
						gobj:GetComponent("TweenPosition").duration = 0.15;

						coroutine.start(self.AfterDoing,self,0.15,function()
							destroy(gobj);
							destroy_count = destroy_count +1;
						end);
					end
				end);
			end
			table.remove(self.jettons, 1);
			v = v +timeC;
		end
	else
	
		local v = 0.15;
		local leng = #(self.jettons);
		for   i = 1, leng do
		
			local temp = v;
			local gobj = self.jettons[1];
			
			if  gobj:GetComponent("TweenPosition") then
			
				destroy(gobj:GetComponent("TweenPosition"));
				coroutine.start(self.AfterDoing,self,temp,function()
				
					if not gobj:GetComponent("TweenPosition") then
					
						gobj:AddComponent(Type.GetType("TweenPosition",true));
						gobj:GetComponent("TweenPosition").from = gobj.transform.localPosition;
						gobj:GetComponent("TweenPosition").to = self.endtarget.localPosition;
						gobj:GetComponent("TweenPosition").duration = 0.15;

						coroutine.start(self.AfterDoing,self,0.15,function()
							destroy(gobj);
						end);
					end 
				end);
			end
			table.remove(self.jettons, 1);
			if  i < #(self.jettons) / 2 then v = v +timeC; end
		end    
	end
	NGUITools.SetActive(self.btextv0.gameObject, false);
	NGUITools.SetActive(self.btextv0BG.gameObject, false);
	NGUITools.SetActive(self.btextv1.gameObject, false);
	NGUITools.SetActive(self.btextv1BG.gameObject, false);
	self.allMoney = 0;
	self.betMoney = 0;
	self.betMoneytrue = 0; 
end
--删除筹码带动画
function this:ResetView_3(targetposition)
	local leng = #(self.jettons);
	for   i = 1, leng do
		local gobj = self.jettons[1];
		table.remove(self.jettons, 1);
		local timeC = 0.03*(i-1);
		if i > 60 then
			timeC =0.03*59;
		end
		local tableC = iTween.Hash ("position",targetposition.position,"islocal",false,"time",0.2,"delay", timeC)
		iTween.MoveTo(gobj,tableC);
		Object.Destroy(gobj,(timeC+0.2));
		coroutine.start(self.AfterDoing,self,timeC,function()
			UISoundManager.Instance.PlaySound ("nbet");
		end);
	end
	
	NGUITools.SetActive(self.btextv0.gameObject, false);
	NGUITools.SetActive(self.btextv0BG.gameObject, false);
	NGUITools.SetActive(self.btextv1.gameObject, false);
	NGUITools.SetActive(self.btextv1BG.gameObject, false);
	self.allMoney = 0;
	self.betMoney = 0;
	self.betMoneytrue = 0; 
end
function this:ResetView()

	local leng = #(self.jettons);
	for   i = 1, leng do
		local gobj = self.jettons[1];
		destroy(gobj);
		table.remove(self.jettons, 1);
	end
	NGUITools.SetActive(self.btextv0.gameObject, false);
	NGUITools.SetActive(self.btextv0BG.gameObject, false);
	NGUITools.SetActive(self.btextv1.gameObject, false);
	NGUITools.SetActive(self.btextv1BG.gameObject, false);
	self.allMoney = 0;
	self.betMoney = 0;
	self.betMoneytrue = 0; 
end
--实例化奖池里的筹码
function this:updateDeskPool(sps,  money,countMax)

	local size = {};
	size[6] = math.floor(money / 1000000);
	money = money % 1000000;
	size[5] = math.floor(money / 500000);
	money = money % 500000;
	size[4] = math.floor(money / 100000);
	money = money % 100000;
	size[3] = math.floor(money / 10000);
	money = money % 10000;
	size[2] = math.floor(money / 1000);
	money = money % 1000;
	size[1] = math.floor(money / 100);

	local count = 0;
	for  i = 6,1,-1 do
		for  j = 1,size[i] do
			local go = Object.Instantiate(sps[i].gameObject);
			local localScale = go.transform.localScale;
			go.transform.parent = self.deskPool;
			go.transform.localScale = localScale;
			local x = math.Random(0, 1) * (self.bgound.width - sps[1].width) - self.bgound.width * 0.5 + sps[1].width * 0.5;
			local y = math.Random(0, 1) * (self.bgound.height - sps[1].height) - self.bgound.height * 0.5 + sps[1].height * 0.5;
			go.transform.localPosition = Vector3.New(x, y, 0);
			table.insert(self.jettons, 1, go);
			count=count+1;
			if  count == countMax then
				break;
			end
		end
	end
end
--百人两张和小九带动画飞筹码
function this:updateDeskPool_3(sps,  money,countMax,  targetposition)
	if targetposition==nil then
		targetposition = self.target;
		log("未传入起点坐标对象")
	end
	local size = {};
	size[6] = math.floor(money / 1000000);
	money = money % 1000000;
	size[5] = math.floor(money / 500000);
	money = money % 500000;
	size[4] = math.floor(money / 100000);
	money = money % 100000;
	size[3] = math.floor(money / 10000);
	money = money % 10000;
	size[2] = math.floor(money / 1000);
	money = money % 1000;
	size[1] = math.floor(money / 100);

	local count = 0;
	for  i = 6,1,-1 do
		for  j = 1,size[i] do
			local go = Object.Instantiate(sps[i].gameObject);
			local localScale = go.transform.localScale;
			go.transform.parent = self.deskPool;
			go.transform.localScale = localScale;
			if type(targetposition) == "table" then
				go.transform.position = targetposition[i].position;
			else
				go.transform.position = targetposition.position;
			end
			
			
			
			local x = math.Random(0, 1) * (self.bgound.width - sps[1].width) - self.bgound.width * 0.5 + sps[1].width * 0.5;
			local y = math.Random(0, 1) * (self.bgound.height - sps[1].height) - self.bgound.height * 0.5 + sps[1].height * 0.5;
			--go.transform.localPosition = Vector3.New(x, y, 0);
			
			go:GetComponent("TweenPosition").from = go.transform.localPosition;
			go:GetComponent("TweenPosition").to =  Vector3.New(x, y, 0);
			go:GetComponent("TweenPosition").duration = 0.2;
			
			table.insert(self.jettons, 1, go);
			count=count+1;
			if  count == countMax then
				break;
			end
		end
	end
end

--明星牛牛带动动画飞筹码
function this:updateDeskPool_1(sps, money,  targetposition)

	if targetposition==nil then
		targetposition = self.target;
	end
	local size = {};
	size[5] = math.floor(money / 1000000);
	money = money % 1000000;
	size[4] = math.floor(money / 100000);
	money = money % 100000;
	size[3] = math.floor(money / 10000);
	money = money % 10000;
	size[2] = math.floor(money / 1000);
	money = money % 1000;
	size[1] = math.floor(money / 100);

	local count = 0;
	for i = 5, 1, -1 do
		for  j = 1,size[i] do
		
			local go = Object.Instantiate(sps[i].gameObject);

			local localScale = go.transform.localScale;
			go.transform.parent = self.deskPool;
			go.transform.localScale = localScale;
			go.transform.localPosition = targetposition.localPosition;

			local x = math.Random(0, 1) * (self.bgound.width - sps[1].width) * 0.76 - (self.bgound.width * 0.5 - sps[1].width * 0.5) * 0.76;
			local y = math.Random(0, 1) * (self.bgound.height - sps[1].height) * 0.57 - (self.bgound.height * 0.5 - sps[1].height * 0.5) * 0.57;
			go:GetComponent("TweenPosition").from = go.transform.localPosition;
			go:GetComponent("TweenPosition").to =  Vector3.New(x, y, 0);
			go:GetComponent("TweenPosition").duration = 0.2;
			table.insert(self.jettons, 1, go);
			count=count+1;
			if  count == 50 then
				break;
			end
		end
	end
end

--明星牛牛新版带动动画飞筹码
function this:updateDeskPool_4(sps, money,  targetposition)
	
	local issit = true
	if targetposition==nil then 
		if #(self.DeskBetPoolArr)>BetMaxNum  then
			--触发粒子效果 
			if not self.isWuParticle2Active then
				self.wuParticle2:SetActive(true)
				self.isWuParticle2 = true 
				self.isWuParticle2Active = true
				coroutine.start(self.AfterDoing,self,1,function()   
					self.isWuParticle2 = false 
					for i = #self.DeskBetPoolArr ,1 ,-1 do  
						self:BetAnimation2(self.DeskBetPoolArr[i])
						table.remove(self.DeskBetPoolArr,i) 
					end
				end);
				coroutine.start(self.AfterDoing,self,1.5,function()  
					self.wuParticle2:SetActive(false) 
					self.isWuParticle2Active = false  
					
				end);
			end
			
			return;  
		end
		issit =false
		targetposition = self.target;  
	end
	local TemplocalPosition = targetposition.localPosition
	local sizeNum = 0; 
	if money < 600 then
		sizeNum  = money/300;
	elseif  money < 10000 then
		sizeNum  = 2+money/5000;
	elseif money < 100000 then
		sizeNum  = 4+money/30000;
	else
		sizeNum  = 8;
	end
	sizeNum = math.ceil(sizeNum); 
	
	
	if issit then
		for  j = 1,sizeNum do 
			local goObj = self.objPool:GetObject();
			local go = goObj.gameObj;  
			goObj.transform.localScale = Vector3Bet2;
			--goObj.transform.localPosition = TemplocalPosition;  
			goObj.from = TemplocalPosition;  
			goObj.to = Vector3.New(math.Random(0, 1)*self.xLv-self.x, math.Random(0, 1)*self.yLv-self.y, 0)  
			table.insert(self.jettons,goObj);	  
			goObj.sprite.depth = 300; 
			coroutine.start(self.AfterDoing,self,j*0.06,function()  
				self:BetAnimation(goObj,0.6)
			end);
		end  
	else
		for  j = 1,sizeNum do 
			local goObj = self.objPool:GetObject();
			local go = goObj.gameObj;  
			goObj.transform.localScale = Vector3Bet2;
			--goObj.transform.localPosition = TemplocalPosition;  
			goObj.from = TemplocalPosition;  
			goObj.to = Vector3.New(math.Random(0, 1)*self.xLv-self.x, math.Random(0, 1)*self.yLv-self.y, 0) 
			goObj.sprite.depth = 300; 	
			table.insert(self.jettons,goObj);	 
			table.insert(self.DeskBetPoolArr,goObj);
		end 
	end
	
	
	--[[	 
		local count = 0;
		local delayTime = count*0.1
		 
		coroutine.start(self.AfterDoing,self,delayTime,function()  
				
				local  temptest1 = nil
				if self.isBetPoArr1 then
					local countArr =  #self.BetPoArr1 
					 local temprandom =math.floor( math.Random(1,countArr) ) 
					local tempone = self.BetPoArr1[temprandom]
					if tempone ~= nil then
						temptest1 = tempone;
						table.remove(self.BetPoArr1,temprandom);
						table.insert(self.BetPoArr2,tempone);	
					end 
					if countArr == 1 then
						self.isBetPoArr1 = false;
					end 
				else
					local countArr =  #self.BetPoArr2 
					 local temprandom =math.floor( math.Random(1,countArr) ) 
					local tempone = self.BetPoArr2[temprandom]
					if tempone ~= nil then
						temptest1 = tempone;
						table.remove(self.BetPoArr2,temprandom);
						table.insert(self.BetPoArr1,tempone);	
					end 
					if countArr == 1 then
						self.isBetPoArr1 = true;
					end 
				end
				 local x =40-math.Random(0, 20)  
				local y = 40-math.Random(0, 20)
				  
				x  =  (self.bgound.width)*temptest1.x/4 - (self.bgound.width * 0.5 +30) +x;
				y  =  (self.bgound.height)*temptest1.y/4- (self.bgound.height * 0.5 +30)+y; 
		end); 
		count=count+1; 
		if  count == 50 then
			break;
		end
		]]
	
	
end

--多人小九新版带动动画飞筹码
function this:updateDeskPool_5(sps, money,  targetposition)
	
	local issit = true
	if targetposition==nil then 
		if #(self.DeskBetPoolArr)>BetMaxNum  then
			--触发粒子效果 
			if not self.isWuParticle2Active then
				self.wuParticle2:SetActive(true)
				self.isWuParticle2 = true 
				self.isWuParticle2Active = true
				coroutine.start(self.AfterDoing,self,1,function()   
					self.isWuParticle2 = false 
					for i = #self.DeskBetPoolArr ,1 ,-1 do 
						if i%2==0 then
							self.DeskBetPoolArr[i].sprite.spriteName="betchip_1";
						else 
							self.DeskBetPoolArr[i].sprite.spriteName="betchip_2";
						end
						self:BetAnimation2(self.DeskBetPoolArr[i])
						table.remove(self.DeskBetPoolArr,i) 
					end
				end);
				coroutine.start(self.AfterDoing,self,1.5,function()  
					self.wuParticle2:SetActive(false) 
					self.isWuParticle2Active = false  
					
				end);
			end
			
			return;  
		end
		issit =false
		targetposition = self.target;  
	end
	--log(self.gameObject.name);
	--log("位置");
	local TemplocalPosition = targetposition.localPosition
	local sizeNum = 0; 
	if money < 10000 then
		sizeNum  = money/300;
	elseif money>=10000 and  money < 100000 then
		sizeNum  = 4;
	else
		sizeNum  = 8;
	end
	sizeNum = math.ceil(sizeNum); 
	
	
	if issit then
		for  j = 1,sizeNum do 
			local goObj = self.objPool:GetObject();
			local go = goObj.gameObj;  
			goObj.transform.localScale = Vector3Bet2;
			--goObj.transform.localPosition = TemplocalPosition;  
			goObj.from = TemplocalPosition;  
			goObj.to = Vector3.New(math.Random(0, 1)*self.xLv-self.x, math.Random(0, 1)*self.yLv-self.y, 0)  
			table.insert(self.jettons,goObj);	  
			goObj.sprite.depth = 300; 
			if money>=10000 then
				goObj.sprite.spriteName="betchip_1";
			else 
				goObj.sprite.spriteName="betchip_2";
			end
			coroutine.start(self.AfterDoing,self,j*0.06,function()  
				self:BetAnimation(goObj,0.6)
			end);
		end  
	else
		for  j = 1,sizeNum do 
			local goObj = self.objPool:GetObject();
			local go = goObj.gameObj;  
			goObj.transform.localScale = Vector3Bet2;
			--goObj.transform.localPosition = TemplocalPosition;  
			goObj.from = TemplocalPosition;  
			goObj.to = Vector3.New(math.Random(0, 1)*self.xLv-self.x, math.Random(0, 1)*self.yLv-self.y, 0) 
			goObj.sprite.depth = 300; 	
			if money>=10000 then
				goObj.sprite.spriteName="betchip_1";
			else 
				goObj.sprite.spriteName="betchip_2";
			end
			table.insert(self.jettons,goObj);	 
			table.insert(self.DeskBetPoolArr,goObj);
		end 
	end	
end
--[[
function this:AddLiZiMoney(sizeNum)
	for  j = 1,sizeNum do 
			local goObj = self.objPool:GetObject();
			local go = goObj.gameObj;  
			goObj.transform.localScale = Vector3Bet2;
			--goObj.transform.localPosition = TemplocalPosition;  
			goObj.from = TemplocalPosition;  
			goObj.to = Vector3.New(math.Random(0, 1)*self.xLv-self.x, math.Random(0, 1)*self.yLv-self.y, 0) 
			goObj.sprite.depth = 300; 	
			if i%2==0 then
				goObj.sprite.spriteName="betchip_1";
			else 
				goObj.sprite.spriteName="betchip_2";
			end
			table.insert(self.jettons,goObj);	 
			table.insert(self.DeskBetPoolArr,goObj);
		end 

end
]]

function this:BetAnimation2(goObj)
	 
	local go = goObj.gameObj;  
	goObj.transform.localPosition = Vector3.New(  goObj.to.x/2.5,goObj.to.y, 0);
	goObj.transform.localScale = Vector3Bet1;
	goObj.transform.localScale:Add(Vector3.New(  0.3,0.3, 0)); 
	iTween.ScaleTo(go,iTween.Hash ("scale",Vector3Bet2,"time",1.5,  "easeType", iTween.EaseType.linear,  "delay",0.3)); 
 
	coroutine.start(self.AfterDoing,self,0.8,function()
		self:OnLineControl() 
	end);
end
function this:BetAnimation(goObj,vTime)
	

	local go = goObj.gameObj; 
	--go:SetActive(true); 
	goObj.transform.localPosition = goObj.from;
	 
	--[[
	coroutine.start(self.AfterDoing,self,delayTime,function() 
	Util.DOMoveLua(go,goObj.to,0.2)
	Util.DOScaleLua(go,Vector3.New(1.5,1.5,1),0.2) 
	Util.DOScaleLua(go,Vector3.New(1.1,1.1,1),1,0.2) 
	end);
	]]
	--Util.iTweenMoveLua(go,goObj.to,BetV)
	--Util.iTweenScaleLua(go,Vector3Bet1,BetV) 
	--Util.iTweenScaleLua(go,Vector3Bet2,1,BetV) 
	iTween.MoveTo(go,iTween.Hash ("position",goObj.to,"islocal",true,"time",vTime,"easeType", iTween.EaseType.easeOutCubic));   
	iTween.ScaleTo(go,iTween.Hash ("scale",Vector3Bet1,"time",vTime, "easeType", iTween.EaseType.linear));   
	iTween.ScaleTo(go,iTween.Hash ("scale",Vector3Bet2,"time",1,  "easeType", iTween.EaseType.linear,  "delay",vTime)); 
 
	coroutine.start(self.AfterDoing,self,0.8,function()
		self:OnLineControl() 
	end);
end
function this:OnLineControl()
	local jettonsNum = #(self.jettons); 
	if  jettonsNum > AllBetMaxNum then  
		for i = jettonsNum-AllBetMaxNum, 1,-1 do
			local gobj = self.jettons[i];
			--gobj.gameObj:SetActive(false);
			gobj.transform.localPosition = Vector3Bet3;
			--gobj.sprite.depth = 0; 
			self.objPool:SetObject(gobj);
			table.remove(self.jettons,i);
		end
	end
end
 
function this:OnLineControlM(num)
	  
	local jettonsNum = #(self.jettons); 
	--log(jettonsNum.."实例化的金币数量");
	if  jettonsNum > 50 then   
		for i = jettonsNum-num,1,-1 do
			local gobj = self.jettons[i];
			--gobj.gameObj:SetActive(false);
			gobj.transform.localPosition = Vector3Bet3;
			--gobj.sprite.depth = 0; 
			self.objPool:SetObject(gobj);
			table.remove(self.jettons,i);
		end
	end
	 
end


function this:updateDeskPool_2( sps,  money,  targetposition)
	
	local size = {};
	size[5] = math.floor(money / 1000000);
	money = money % 1000000;
	size[4] = math.floor(money / 100000);
	money = money % 100000;
	size[3] = math.floor(money / 10000);
	money = money % 10000;
	size[2] = math.floor(money / 1000);
	money = money % 1000;
	size[1] = math.floor(money / 100);

	local count = 0;
	for i = 5, 1, -1 do
		for  j = 1,size[i] do
			local go = Object.Instantiate(sps[i].gameObject) ;

			local localScale = go.transform.localScale;
			go.transform.parent = self.deskPool;
			go.transform.localScale = localScale;
			go.transform.localPosition = targetposition.localPosition;

			
			local x = math.Random(0, 1) * (self.bgound.width - sps[1].width) * 0.76 - (self.bgound.width * 0.5 - sps[1].width * 0.5) * 0.76;
			local y = math.Random(0, 1) * (self.bgound.height - sps[1].height) * 0.57 - (self.bgound.height * 0.5 - sps[1].height * 0.5) * 0.57;

			go:GetComponent("TweenPosition").from = go.transform.localPosition;
			go:GetComponent("TweenPosition").to =  Vector3.New(x, y, 0);
			go:GetComponent("TweenPosition").duration = 0.2;
			table.insert(self.jettons, 1, go);
			count=count+1;
			if  count == 50 then
				break;
			end
		end
	end
end



function this:AfterDoing(offset, run)
    coroutine.wait(offset);
	if self.gameObject==nil then
		return;
	end
	run();
end




