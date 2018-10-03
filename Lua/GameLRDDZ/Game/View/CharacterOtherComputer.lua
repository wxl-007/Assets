CharacterOtherComputer = {}
local self = CharacterOtherComputer
local transform
local gameObject

self.pokers = {}--要打的模型牌
self.objList = {} --手上的模型牌
function CharacterOtherComputer.Awake(obj)
	gameObject = obj
	transform = obj.transform
	self.init()
	self.pokers = {}
end 
function CharacterOtherComputer.GameObject(  )
	return gameObject
end
function CharacterOtherComputer.OnEnable()
	Event.AddListener(GameEvent.ShowOtherComputerHandCards, self.PickUpCards)
end  

function CharacterOtherComputer.OnDisable()
	Event.RemoveListener(GameEvent.ShowOtherComputerHandCards, self.PickUpCards)
	self.Clear()
end 
function CharacterOtherComputer.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');

	local leftPath = ""
	local rightPath = ""
	if OtherComputer.sex == 1 then 
		leftPath = "doudizhunan/Dummy001/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bip001 L Hand/Bip001 L Finger1/CardPoint"
		rightPath = "doudizhunan/Dummy001/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bip001 R Hand/Bip001 R Finger1/CardPoint"
	elseif OtherComputer.sex ==2 then 
		leftPath = "doudizhunv/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bip001 L Hand/Bip001 L Finger1/CardPoint"
		rightPath = "doudizhunv/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bip001 R Hand/Bip001 R Finger1/CardPoint"
	end

	self.LeftHandpoint = transform:FindChild(leftPath).gameObject
	self.RightHandpoint = transform:FindChild(rightPath).gameObject
	self.Animator = gameObject:GetComponent('Animator');
	CharacterOtherComputer.HiAnimator()
end 
function CharacterOtherComputer.PickUpCards(objList)
	self.objList = objList or {}
	EginTools.ClearChildren(self.LeftHandpoint.transform)
	self.pickupAnimator()
end 
--从桌面拿牌
function CharacterOtherComputer.Event3()
	self.ShowHandCards()
end 
function CharacterOtherComputer.ShowHandCards()
	if #self.objList < OtherComputer.allNum then
		for i=1,OtherComputer.allNum - #self.objList do
			local cardinfo = {}
			cardinfo.name = GameCtrl.pokerlist[1].name
			cardinfo.Card = GameCtrl.pokerlist[1].Card
			cardinfo.GameObject = GameObject.Instantiate(GameCtrl.pokerlist[1].GameObject,GameCtrl.pokerlist[1].GameObject.transform.position,GameCtrl.pokerlist[1].GameObject.transform.rotation)
			table.insert(self.objList,cardinfo)
		end
	elseif #self.objList > OtherComputer.allNum then
		for i=1,#self.objList - OtherComputer.allNum do
			destroy(self.objList[#self.objList].GameObject)
			table.remove(self.objList,#self.objList)
		end
	end

	for i =1, #self.objList do 
		self.objList[i].GameObject.transform.parent = self.LeftHandpoint.transform
		if OtherComputer.sex == 1 then 
			self.objList[i].GameObject.transform.localScale = Vector3.New(0.001,0.001,0.001)
			self.objList[i].GameObject.transform.localPosition = Vector3.New(-0.00491,0.00171-i*0.00002,-0.00169-(i-#self.objList/2)*0.0002)
			self.objList[i].GameObject.transform.localRotation = Quaternion.Euler(90, -157.50-(i-#self.objList/2)*8, 0)
		elseif OtherComputer.sex == 2 then 
			self.objList[i].GameObject.transform.localScale = Vector3.New(0.01,0.01,0.01)
			self.objList[i].GameObject.transform.localPosition = Vector3.New(-0.0645,0.0207-i*0.0002,-0.0150-(i-#self.objList/2)*0.002)
			self.objList[i].GameObject.transform.localRotation = Quaternion.Euler(90, -157.50-(i-#self.objList/2)*8, 0)
		end 
	end 
end 
function CharacterOtherComputer.ShowBottom(objList)
	for i=1,#objList do 
		table.insert(self.objList,objList[i])
	end 
	self.SortByCards()
	self.ShowHandCards()
end 
function CharacterOtherComputer.SortByCards()
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
function CharacterOtherComputer.Deal(cards,cardsType,func)
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
function CharacterOtherComputer.Event1()
	self.SelectPoker()
end 
function CharacterOtherComputer.SelectPoker()
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
		if OtherComputer.sex == 1 then 
			self.pokers[i].GameObject.transform.localScale = Vector3.New(0.001,0.001,0.001)
			self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(84, 20, 120 - (i-#self.pokers/2)*6)
			self.pokers[i].GameObject.transform.localPosition = Vector3.New(-0.00349,0.00208+0.00001*i,0.00108)
		elseif OtherComputer.sex == 2 then 
			self.pokers[i].GameObject.transform.localScale = Vector3.New(0.005,0.005,0.005)
			self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(90, 20, 180 - (i-8)*6)
			self.pokers[i].GameObject.transform.localPosition = Vector3.New(-0.0844,0.0385+0.001*i,-0.0127)
		end 
	end 
end 
--牌从右手打到桌面上
function CharacterOtherComputer.Event2()
	self.DealToDesk()
end 
function CharacterOtherComputer.DealToDesk()
	for i =1, #self.pokers do 
		self.pokers[i].GameObject.transform.parent = transform.parent
		self.pokers[i].GameObject.transform.localScale = Vector3.New(0.3,0.3,0.3)
		self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(90, 90, 0)
		self.pokers[i].GameObject.transform.localPosition = Vector3.New(12, (i+#GameCtrl.pokerlist)*0.01+20, -3+i)
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
function  CharacterOtherComputer.PokerMove()
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
function CharacterOtherComputer.ResDealCards()
	CharacterOtherComputer.Clear()
	self.Animator:SetBool("pickup",false)
	self.Animator:SetTrigger("exit")
	OtherComputer.Clear()
end
function CharacterOtherComputer.ClearPokers()
	for i =1, #self.pokers do 
		destroy(self.pokers[i].GameObject)
	end 
	self.pokers = {}
end 
function CharacterOtherComputer.Clear()
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
function CharacterOtherComputer.Event4()
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
function  CharacterOtherComputer.HiAnimator()
	self.Animator:SetTrigger("Hi")
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.OtherComputer,"talk1",OtherComputer.sex == 1);
end 
--拿牌 --
function  CharacterOtherComputer.pickupAnimator()
	self.Animator:SetBool("pickup",true)
	self.Animator:SetBool("Win",false)
	self.Animator:SetBool("LostOut",false)
end 
--出牌 --
function  CharacterOtherComputer.DealAnimator()
	self.Animator:SetTrigger("Deal")
end 
--不出/不抢
function CharacterOtherComputer.NoDealAnimator()
	self.Animator:SetTrigger("NoDeal")
end 
--不出/不抢1
function CharacterOtherComputer.NoDealAnimator1()
	self.Animator:SetTrigger("NoDeal1")
end
--吃惊
function CharacterOtherComputer.AmazedAnimator()
	coroutine.start(self.Amazed)
end 
--炸弹
function  CharacterOtherComputer.BombAnimator()
	self.Animator:SetTrigger("Bomb")
	local startPoint = self.RightHandpoint.transform.localPosition
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","shou", "shou",Vector3.New(1,1,1),startPoint, false,function(obj,name)
		coroutine.start(CharacterOtherComputer.destroyself,obj)
	end,nil)
end 
--顺子
function CharacterOtherComputer.DealMoreAnimator()
	self.Animator:SetTrigger("DealMore")
end 
--飞机
function CharacterOtherComputer.PlaneAnimator()
	self.Animator:SetTrigger("Plane")
end
--抢地主
function  CharacterOtherComputer.RobLandLordAnimator()
	self.Animator:SetTrigger("RobLandLord1")
end 
--抢地主1
function  CharacterOtherComputer.RobLandLordAnimator1()
	self.Animator:SetTrigger("RobLandLord1")
end 
--抢地主2
function  CharacterOtherComputer.RobLandLordAnimator2()
	self.Animator:SetTrigger("RobLandLord2")
end 
function CharacterOtherComputer.Amazed()
	self.Animator:SetTrigger("Amazed")
end 
--大小王
function CharacterOtherComputer.JackAnimator()
	self.Animator:SetTrigger("Jack")
end
--王炸
function CharacterOtherComputer.JackBoomAnimator()
	self.Animator:SetTrigger("JackBoom")
	local startPoint = self.RightHandpoint.transform.localPosition
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","shou", "shou",Vector3.New(1,1,1),startPoint, false,function(obj,name)
		coroutine.start(CharacterOtherComputer.destroyself,obj)
	end,nil)
end
--等待发牌1
function  CharacterOtherComputer.WaitLicenseAnimator()
	self.Animator:SetTrigger("WaitLicense")
end 
--等待发牌2
function  CharacterOtherComputer.WaitLicenseAnimator2()
	self.Animator:SetTrigger("WaitLicense2")
end
--等待发牌3
function  CharacterOtherComputer.WaitLicenseAnimator3()
	self.Animator:SetTrigger("WaitLicense3")
end
--等待出牌1
function CharacterOtherComputer.WaitDeal1Animator()
	self.Animator:SetTrigger("WaitDeal1")
end 
--等待出牌2
function CharacterOtherComputer.WaitDeal2Animator()
	self.Animator:SetTrigger("WaitDeal2")
end
--等待出牌3
function CharacterOtherComputer.WaitDeal3Animator()
	self.Animator:SetTrigger("WaitDeal3")
end
--我剩1张牌了
function CharacterOtherComputer.WarnOneAnimator()
	self.Animator:SetTrigger("WarnOne")
end
--我剩2两牌了
function CharacterOtherComputer.WarnTwoAnimator()
	self.Animator:SetTrigger("WarnTwo")
end
--赢了
function CharacterOtherComputer.WinAnimator()
	self.Animator:SetBool("Win",true)
	self.Animator:SetBool("pickup",false)
end
--输了
function CharacterOtherComputer.LostOutAnimator()
	self.Animator:SetBool("LostOut",true)
	self.Animator:SetBool("pickup",false)
end
function CharacterOtherComputer.Talk(index)
	if self.Animator:GetBool("pickup") == false then
		--self.Animator:SetTrigger("Talk"..index)
		self.Animator:SetFloat("NoCardTalkBlend",index)
		self.Animator:SetTrigger("NoCardTalk")
	else
		self.Animator:SetFloat("TalkBlend",index)
		self.Animator:SetTrigger("Talk")
	end
end
function CharacterOtherComputer.destroyself(obj)
	obj.transform.parent = self.RightHandpoint.transform.parent
	obj.transform.localPosition = Vector3.New(0,0,0)
	obj.transform.localScale = Vector3.New(1,1,1)
	coroutine.wait(1)
	destroy(obj)
end
function CharacterOtherComputer.OnDestroy()
	gameObject = nil
	transform = nil
	self.behaviour = nil
	CharacterOtherComputer.Clear()
	self.LeftHandpoint = nil
	self.RightHandpoint = nil
	self.Animator = nil
end
function CharacterOtherComputer.GameOverAnimator(winnerIdentity)
	if winnerIdentity == OtherComputer.identity then
		CharacterOtherComputer.WinAnimator()
	else
		CharacterOtherComputer.LostOutAnimator()
	end
end
function CharacterOtherComputer.Leave(  )
	destroy(gameObject)
	gameObject = nil
	self.LeftHandpoint = nil
	self.RightHandpoint = nil
	self.Animator = nil
end