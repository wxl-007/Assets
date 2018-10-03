local this = LuaObject:New()
VSAnima = this 
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
	
	self.bg = nil;
	self.thunderAnima = nil;
	self.winer = nil;
	self.loser = nil;
	self.originalTr = nil;
	self.leftPt = nil;
	self.rightPt = nil;
	self.queue={};
	self.isPlaying = false;
	self.playCompleted = nil;
	self.delayJsonObj = nil;
	self.playClass= nil;
	self.playCompleted2 = nil;
	self.delayJsonObj2 = nil;
	self.playClass2= nil;
	self.playCompletedCallBack = nil;
	self.playFunctionClass = nil;
	self.InvokeLua:clearLuaValue();
	self.InvokeLua = nil;
end
function this:Init()
	--初始化变量
	self.bg = self.transform:FindChild("blackBg").gameObject;
	self.thunderAnima = self.transform:FindChild("bipaiEffects").gameObject:GetComponent("UISpriteAnimation");
	self.winer = nil;
	self.loser = nil;
	self.originalTr = self.transform.parent:FindChild("Content");
	self.leftPt = self.transform:FindChild("LeftPt");
	self.rightPt = self.transform:FindChild("rightPt");
	self.queue={};
	self.isPlaying = false;
	self.playCompleted = nil;
	self.delayJsonObj = nil;
	self.playClass = nil;
	
	self.playCompleted2 = nil;
	self.delayJsonObj2 = nil;
	self.playClass2= nil;
	
	self.playCompletedCallBack = nil;
	self.playFunctionClass = nil;
	
	self.InvokeLua = InvokeLua:New(self);
end
function this:Awake () 
	self:Init()
end

function this:Start () 
	self.bg:SetActive(false);
	self.thunderAnima.gameObject:SetActive(false);
	self.queue = {};
end
function this:setCompletedCallBack( completedCallback,functionClass)
	self.playCompletedCallBack = completedCallback;
	self.playFunctionClass = functionClass;
end


function this:pushToAnimaQueue( winner,  loser)
	local coupleObj = {winner, loser};
	table.insert(self.queue,coupleObj);
	if not self.isPlaying then
		self:playQueueAnima();
	end
end

function this:playQueueAnima()
	if  #(self.queue) > 0 then
		local targetCouple = self.queue[1];
		self:animaStart(targetCouple[1], targetCouple[2]);
		SoundMgr.instance:playEft(SoundMgr.instance.clipVs);
		table.remove(self.queue,1)
	else
		self.isPlaying = false;
		if self.playCompletedCallBack ~= nil then
			self.playCompletedCallBack(self.playFunctionClass);
			self.playCompletedCallBack = nil;
			self.playFunctionClass = nil;
		end
		if self.playCompleted ~= nil  and  self.delayJsonObj ~= nil then
			coroutine.start( self.playCompleted,self.playClass,self.delayJsonObj );
			self.playCompleted = nil;
			self.delayJsonObj  = nil;
			self.playClass = nil;
		end
		if self.playCompleted2 ~= nil  and  self.delayJsonObj2 ~= nil then
			coroutine.start( self.playCompleted2,self.playClass2,self.delayJsonObj2 );
			self.playCompleted2 = nil;
			self.delayJsonObj2  = nil;
			self.playClass2 = nil;
		end
	end
end

function this:animaStart( winer,  loser)
	self.bg:SetActive(true);
	
	self.thunderAnima.gameObject:SetActive(false);
	self.isPlaying = true;
	winer.transform.parent = self.transform;
	loser.transform.parent = self.transform;
	
	self.winer = winer;
	self.loser = loser;
	local winerDoc =  GameYSZ:GetYSZPlayerCtrl(winer.name);
	winerDoc.cardsAnima.enabled=false;
	winerDoc:ResetCardRotation();
	winerDoc:setDepthUp();
	local loserDoc =  GameYSZ:GetYSZPlayerCtrl(loser.name);
	loserDoc.cardsAnima.enabled=false;
	loserDoc:setDepthUp();
	loserDoc:ResetCardRotation();
	if winer.transform.position.x <= 0 then
		winerDoc:cardsMoveTo(self.leftPt);
		loserDoc:cardsMoveTo(self.rightPt);
	else
		winerDoc:cardsMoveTo(self.rightPt);
		loserDoc:cardsMoveTo(self.leftPt);
	end
	self:cancedAnima();
	self.gameObject:GetComponent("UIPanel"):SortWidgets();
	self.InvokeLua:Invoke("step1",self.step1, 1.5);
end

function this:step1()
	log("第一步");
	self.thunderAnima.gameObject:SetActive(true);
	self.thunderAnima:Play();
	coroutine.start(self.step2,self);
end

function this:step2()
	log("第二步");
	self:cancedAnima();
	coroutine.wait(1.5);
	
	self:cancedAnima();
	GameYSZ:GetYSZPlayerCtrl(self.loser.name): cardSkinToBreak();
	GameYSZ:GetYSZPlayerCtrl(self.loser.name): cardShake();
	self.thunderAnima.gameObject:SetActive(false);
	coroutine.wait(0.5);
	
	self:cancedAnima();
	 GameYSZ:GetYSZPlayerCtrl(self.winer.name): cardsReset(true);
	 GameYSZ:GetYSZPlayerCtrl(self.loser.name): cardsReset(false);
	coroutine.wait(1.5);
	
	if self.loser.gameObject.name == "YSZPlayer_"..EginUser.Instance.uid then  
		coroutine.wait(0.8);
	end
	self:animaEnd();
end

function this:animaEnd()
	self:cancedAnima();
	self.winer.transform.parent = self.originalTr;
	self.loser.transform.parent = self.originalTr;
	GameYSZ:GetYSZPlayerCtrl(self.winer.name): resetDepth();
	GameYSZ:GetYSZPlayerCtrl(self.loser.name): resetDepth();
	self.bg:SetActive(false);
	self.thunderAnima.gameObject:SetActive(false);
	self:playQueueAnima();
end

function this:cancedAnima()
	if  self.winer == nil  or  self.loser == nil then
		self.bg:SetActive(false);
		self.thunderAnima.gameObject:SetActive(false);
		self.isPlaying = false;
		self.queue = {};
	end
end
