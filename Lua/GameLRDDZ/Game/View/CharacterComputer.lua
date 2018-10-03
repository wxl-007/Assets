CharacterComputer = {}
local self = CharacterComputer
local transform
local gameObject

self.pokers = {}--要打的模型牌
self.objList = {} --手上的模型牌
function CharacterComputer.Awake(obj)
	gameObject = obj
	transform = obj.transform
	self.init()
	self.pokers = {}
	Computer.SetComputerState(2)
end 
function CharacterComputer.GameObject(  )
	return gameObject
end
function CharacterComputer.OnEnable()
	Event.AddListener(GameEvent.ShowComputerHandCards, self.PickUpCards)
end  

function CharacterComputer.OnDisable()
	Event.RemoveListener(GameEvent.ShowComputerHandCards, self.PickUpCards)
	self.Clear()
end 
function CharacterComputer.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');

	local leftPath = ""
	local rightPath = ""
	if Computer.sex == 1 then 
		leftPath = "doudizhunan/Dummy001/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bip001 L Hand/Bip001 L Finger1/CardPoint"
		rightPath = "doudizhunan/Dummy001/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bip001 R Hand/Bip001 R Finger1/CardPoint"
	elseif Computer.sex ==2 then 
		leftPath = "doudizhunv/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bip001 L Hand/Bip001 L Finger1/CardPoint"
		rightPath = "doudizhunv/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bip001 R Hand/Bip001 R Finger1/CardPoint"
	end

	self.LeftHandpoint = transform:FindChild(leftPath).gameObject
	self.RightHandpoint = transform:FindChild(rightPath).gameObject
	self.Animator = gameObject:GetComponent('Animator');
	CharacterComputer.HiAnimator()
end 
function CharacterComputer.PickUpCards(objList)
	self.objList = objList or {}
	EginTools.ClearChildren(self.LeftHandpoint.transform)
	self.pickupAnimator()
end 
--从桌面拿牌
function CharacterComputer.Event3()
	self.ShowHandCards()
end 
function CharacterComputer.ShowHandCards()

	if #self.objList < Computer.allNum then
		for i=1,Computer.allNum - #self.objList do
			local cardinfo = {}
			cardinfo.name = GameCtrl.pokerlist[1].name
			cardinfo.Card = GameCtrl.pokerlist[1].Card
			cardinfo.GameObject = GameObject.Instantiate(GameCtrl.pokerlist[1].GameObject,GameCtrl.pokerlist[1].GameObject.transform.position,GameCtrl.pokerlist[1].GameObject.transform.rotation)
			table.insert(self.objList,cardinfo)
		end
	elseif #self.objList > Computer.allNum then
		for i=1,#self.objList - Computer.allNum do
			if self.objList[#self.objList].GameObject ~= nil then
				destroy(self.objList[#self.objList].GameObject)
			end
			table.remove(self.objList,#self.objList)
		end
	end
	for i =1, #self.objList do 
		self.objList[i].GameObject.transform.parent = self.LeftHandpoint.transform
		if Computer.sex == 1 then 
			self.objList[i].GameObject.transform.localScale = Vector3.New(0.001,0.001,0.001)
			self.objList[i].GameObject.transform.localPosition = Vector3.New(-0.00491,0.00171-i*0.00002,-0.00169-(i-#self.objList/2)*0.0002)
			self.objList[i].GameObject.transform.localRotation = Quaternion.Euler(90, -157.50-(i-#self.objList/2)*8, 0)
		elseif Computer.sex == 2 then 
			self.objList[i].GameObject.transform.localScale = Vector3.New(0.01,0.01,0.01)
			self.objList[i].GameObject.transform.localPosition = Vector3.New(-0.0645,0.0207-i*0.0002,-0.0150-(i-#self.objList/2)*0.002)
			self.objList[i].GameObject.transform.localRotation = Quaternion.Euler(90, -157.50-(i-#self.objList/2)*8, 0)
		end 
	end 
end 
function CharacterComputer.ShowBottom(objList)
	for i=1,#objList do 
		table.insert(self.objList,objList[i])
	end 
	self.SortByCards()
	self.ShowHandCards()
end 
function CharacterComputer.SortByCards()
	local function sortFunc(obj1,obj2)
		if obj1.Card.weight == obj2.Card.weight then
			return obj1.Card.suits >  obj2.Card.suits
		else 
			return obj1.Card.weight < obj2.Card.weight
		end 
	end 
	table.sort(self.objList, sortFunc)
end 
--出牌
function CharacterComputer.Deal(cards,cardsType,func)
	self.Dealcards = cards
	self.func = func 
	if cardsType == CardsType.Boom then --炸弹
		self.BombAnimator() 
		CharacterPlayer.AmazedAnimator()--对方吃惊
	elseif cardsType == CardsType.JokerBoom then --王炸
		self.JackBoomAnimator()
		CharacterPlayer.AmazedAnimator()--对方吃惊
	elseif cardsType == CardsType.TripleStraightAndSingle or cardsType == CardsType.TripleStraightAndDouble then
		self.PlaneAnimator()
	elseif cardsType == CardsType.Single and #cards > 0 then
		if cards[1].weight == Weight.SJoker or cards[1].weight == Weight.LJoker then
			self.JackAnimator()
		else
			self.DealAnimator()
		end
	else 
		if #cards < 4 then     		 
			self.DealAnimator()
		else 
			self.DealMoreAnimator()
		end 
	end 
end 
--右手从左手拿牌
function CharacterComputer.Event1()
	self.SelectPoker()
end 
function CharacterComputer.SelectPoker()
	self.pokers = {}
		--网络打牌 从GameCtrl.pokerlist中选取 删除手中的牌
		for i = 1 , #self.Dealcards do
			for j =1, #GameCtrl.pokerlist do 
				if self.Dealcards[i].cardName == GameCtrl.pokerlist[j].name then
					table.insert(self.pokers,GameCtrl.pokerlist[j])
					table.remove(GameCtrl.pokerlist,j)
					break
				end
			end
			if(#self.objList~=0) then
				destroy(self.objList[#self.objList].GameObject)
				table.remove(self.objList,#self.objList)
			end
		end
	self.ShowHandCards() --整理左手牌
	--整理右手牌
	for i =1, #self.pokers do 
		self.pokers[i].GameObject.transform.parent = self.RightHandpoint.transform
		if Computer.sex == 1 then 
			
			self.pokers[i].GameObject.transform.localScale = Vector3.New(0.001,0.001,0.001)
			self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(84, 20, 120 - (i-#self.pokers/2)*6)
			self.pokers[i].GameObject.transform.localPosition = Vector3.New(-0.00349,0.00208+0.00001*i,0.00108)
		elseif Computer.sex == 2 then 
			self.pokers[i].GameObject.transform.localScale = Vector3.New(0.005,0.005,0.005)
			self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(90, 20, 180 - (i-8)*6)
			self.pokers[i].GameObject.transform.localPosition = Vector3.New(-0.0844,0.0385+0.001*i,-0.0127)
		end 
	end 
end 
--牌从右手打到桌面上
function CharacterComputer.Event2()
	LRDDZ_SoundManager.PlaySoundEffect("play")
	self.DealToDesk()
end 
function CharacterComputer.DealToDesk()
	for i =1, #self.pokers do 
		self.pokers[i].GameObject.transform.parent = transform.parent
		self.pokers[i].GameObject.transform.localScale = Vector3.New(0.3,0.3,0.3)
		self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(90, 90, 0)
		self.pokers[i].GameObject.transform.localPosition = Vector3.New(-5, (i+#GameCtrl.pokerlist)*0.01+20, -6+i)
	end 

	self.PokerMove()

	if self.func ~= nil then 
		self.func()
	end 
	
	--每次出牌后判断是否要出等待打牌的动作,只有在等待发牌触发
	if OrderCtrl.state == GameState.Before then
		if math.random(1,4) == 1 then
			coroutine.start(self.WaitDeal2Animator)
		end
	end
end 
--丢牌 牌出去的动画
function  CharacterComputer.PokerMove()
	 math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
	 for i = #self.pokers, 1, -1 do 
		local num = math.random(100)
		--local x = num/50+1.5
		--local z =  3/num + 10
		local x = num / 50 + 6;
		local z = 3/num + 4;
		table.insert(GameCtrl.pokerlist,self.pokers[i])
		iTween.MoveTo(self.pokers[i].GameObject, iTween.Hash("position", Vector3.New(x, #GameCtrl.pokerlist*0.01+20, z), "time", 0.4, "islocal", true, "easetype",  iTween.EaseType.easeOutQuad));
		local roy = 360*num/100 
		iTween.RotateTo(self.pokers[i].GameObject, iTween.Hash("rotation", Vector3.New(90, roy, 0), "time", 0.4, "islocal", true, "easetype",  iTween.EaseType.easeOutQuad));
		
	end 
end
function CharacterComputer.ResDealCards()
	CharacterComputer.Clear()
	self.Animator:SetBool("pickup",false)
	self.Animator:SetTrigger("exit")
	Computer.Clear()

end
function CharacterComputer.ClearPokers()
	for i =1, #self.pokers do 
		destroy(self.pokers[i].GameObject)
	end 
	self.pokers = {}
end 
function CharacterComputer.Clear()
	
	for i =1, #self.objList do 
		destroy(self.objList[i].GameObject)
	end 
	self.objList = {}
	if self.LeftHandpoint ~= nil then
		EginTools.ClearChildren(self.LeftHandpoint.transform)
	end
	self.ClearPokers()
end 
--等待发牌时等待发牌动作随机触发另一个等待发牌动作
function CharacterComputer.Event4()
	local rand = math.random(1,15) 
	if rand == 1 then
		self.WaitLicenseAnimator()
	elseif rand == 2 then
		self.WaitLicenseAnimator2()
	elseif rand == 3 then
		self.WaitLicenseAnimator3()
	end
end
-----动画状态机
function  CharacterComputer.HiAnimator()
	self.Animator:SetTrigger("Hi")
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Computer,"talk1",Computer.sex == 1);
end 
--拿牌 --
function  CharacterComputer.pickupAnimator()
	self.Animator:SetBool("pickup",true)
	self.Animator:SetBool("Win",false)
	self.Animator:SetBool("LostOut",false)
end 
--出牌 --
function  CharacterComputer.DealAnimator()
	self.Animator:SetTrigger("Deal")
end 
--不出/不抢
function CharacterComputer.NoDealAnimator()
	self.Animator:SetTrigger("NoDeal")
end 
--不出/不抢1
function CharacterComputer.NoDealAnimator1()
	self.Animator:SetTrigger("NoDeal1")
end 
--吃惊
function CharacterComputer.AmazedAnimator()
	coroutine.start(self.Amazed)
end 
--炸弹
function  CharacterComputer.BombAnimator()
	self.Animator:SetTrigger("Bomb")
	local startPoint = self.RightHandpoint.transform.localPosition
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","shou", "shou",Vector3.New(1,1,1),startPoint, false,function(obj,name)
		coroutine.start(CharacterComputer.destroyself,obj)
	end,nil)
end 
--顺子
function CharacterComputer.DealMoreAnimator()
	self.Animator:SetTrigger("DealMore")
end 
--飞机
function CharacterComputer.PlaneAnimator()
	self.Animator:SetTrigger("Plane")
end
--抢地主
function  CharacterComputer.RobLandLordAnimator()
	self.Animator:SetTrigger("RobLandLord")
end 
--抢地主1
function  CharacterComputer.RobLandLordAnimator1()
	self.Animator:SetTrigger("RobLandLord1")
end 
function CharacterComputer.Amazed()
	self.Animator:SetTrigger("Amazed")
end 
--大小王
function CharacterComputer.JackAnimator()
	self.Animator:SetTrigger("Jack")
end
--王炸
function CharacterComputer.JackBoomAnimator()
	self.Animator:SetTrigger("JackBoom")
	local startPoint = self.RightHandpoint.transform.localPosition
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","shou", "shou",Vector3.New(1,1,1),startPoint, false,function(obj,name)
		coroutine.start(CharacterComputer.destroyself,obj)
	end,nil)
end
--等待发牌1
function  CharacterComputer.WaitLicenseAnimator()
	self.Animator:SetTrigger("WaitLicense")
end 
--等待发牌2
function  CharacterComputer.WaitLicenseAnimator2()
	self.Animator:SetTrigger("WaitLicense1")
end
--等待发牌3
function  CharacterComputer.WaitLicenseAnimator3()
	self.Animator:SetTrigger("WaitLicense2")
end
--等待出牌1
function CharacterComputer.WaitDeal1Animator()
	self.Animator:SetTrigger("WaitDeal1")
end 
--等待出牌2
function CharacterComputer.WaitDeal2Animator()
	self.Animator:SetTrigger("WaitDeal2")
end
--等待出牌3
function CharacterComputer.WaitDeal3Animator()
	self.Animator:SetTrigger("WaitDeal3")
end
--我剩1张牌了
function CharacterComputer.WarnOneAnimator()
	self.Animator:SetTrigger("WarnOne")
end
--我剩2两牌了
function CharacterComputer.WarnTwoAnimator()
	self.Animator:SetTrigger("WarnTwo")
end
--赢了
function CharacterComputer.WinAnimator()
	self.Animator:SetBool("Win",true)
	self.Animator:SetBool("pickup",false)
end
--输了
function CharacterComputer.LostOutAnimator()
	self.Animator:SetBool("LostOut",true)
	self.Animator:SetBool("pickup",false)
end
function CharacterComputer.Talk(index)
	if self.Animator:GetBool("pickup") == false then
		--self.Animator:SetTrigger("Talk"..index)
		self.Animator:SetFloat("NoCardTalkBlend",index)
		self.Animator:SetTrigger("NoCardTalk")
	else
		self.Animator:SetFloat("TalkBlend",index)
		self.Animator:SetTrigger("Talk")
	end
end
function CharacterComputer.destroyself(obj)
	obj.transform.parent = self.RightHandpoint.transform.parent
	obj.transform.localPosition = Vector3.New(0,0,0)
	obj.transform.localScale = Vector3.New(1,1,1)
	coroutine.wait(1)
	destroy(obj)
end
function CharacterComputer.OnDestroy()
	gameObject = nil
	transform = nil
	self.behaviour = nil
	CharacterComputer.Clear()
	self.LeftHandpoint = nil
	self.RightHandpoint = nil
	self.Animator = nil
end
function CharacterComputer.GameOverAnimator(winnerIdentity)
	if winnerIdentity == Computer.identity then
		CharacterComputer.WinAnimator()
	else
		CharacterComputer.LostOutAnimator()
	end
end
function CharacterComputer.Leave(  )
	Computer.SetComputerState(1)
	destroy(gameObject)
	gameObject = nil
	self.LeftHandpoint = nil
	self.RightHandpoint = nil
	self.Animator = nil
end