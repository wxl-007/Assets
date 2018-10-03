CharacterPlayer = {}
local self = CharacterPlayer
local transform
local gameObject

self.pokers = {}
self.objList = {}
function CharacterPlayer.Awake(obj)
	gameObject = obj
	transform = obj.transform
	self.init()
	self.pokers = {}
end 

function CharacterPlayer.TimeUpdate()

end
function CharacterPlayer.GameObject()
	return gameObject
end

function CharacterPlayer.OnEnable()
	Event.AddListener(GameEvent.ShowPlayerHandCards, self.PickUpCards)
end  
function CharacterPlayer.OnDisable()
	Event.RemoveListener(GameEvent.ShowPlayerHandCards, self.PickUpCards)
	self.Clear()
end 
function CharacterPlayer.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');

	local leftPath = ""
	local rightPath = ""
	if Avatar.getAvatarSex() == 1 then 
		leftPath = "doudizhunan/Dummy001/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bip001 L Hand/Bip001 L Finger1/CardPoint"
		rightPath = "doudizhunan/Dummy001/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bip001 R Hand/Bip001 R Finger1/CardPoint"
	elseif Avatar.getAvatarSex() ==2 then 
		leftPath = "doudizhunv/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bip001 L Hand/Bip001 L Finger1/CardPoint"
		rightPath = "doudizhunv/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bip001 R Hand/Bip001 R Finger1/CardPoint"
	end
	
	self.LeftHandpoint = transform:FindChild(leftPath).gameObject
	self.RightHandpoint = transform:FindChild(rightPath).gameObject
	self.Animator = gameObject:GetComponent('Animator');
end
-- 
function CharacterPlayer.PickUpCards(objList)
	self.objList = objList
	self.pickupAnimator()
	-- local time = Timer.New(self.ShowHandCards, 0.8,1, true)
	-- time:Start()
end 

function CharacterPlayer.SetHand3DCards(cards)
	local playerPokers = {}

	for i = 1, #cards do 
		for j = 1,  #GameCtrl.pokerlist do 
			if cards[i].cardName == GameCtrl.pokerlist[j].name then 
				table.insert(playerPokers,GameCtrl.pokerlist[j])
				table.remove(GameCtrl.pokerlist,j)
				break
			end 
		end 
	end 
	self.objList = playerPokers
	CharacterPlayer.ShowHandCards()
end
function CharacterPlayer.ResDealCards()
	for i =1, #self.objList do
		self.objList[i].GameObject.transform.parent = nil 
		self.objList[i].GameObject.transform.localPosition = Vector3.New(8.5,-10,9)
		self.objList[i].GameObject.transform.localScale = Vector3.New(0.3,0.3,0.3)
		table.insert(GameCtrl.pokerlist,self.objList[i])
	end
	self.objList = {}
	self.Animator:SetBool("pickup",false)
	self.Animator:SetTrigger("exit")
	Player.Clear()
end
--从桌面拿牌
function CharacterPlayer.Event3()
	self.ShowHandCards()
end 
function CharacterPlayer.ShowHandCards()
	for i =1, #self.objList do 
		self.objList[i].GameObject.transform.parent = self.LeftHandpoint.transform
		if Avatar.getAvatarSex() == 1 then 
			self.objList[i].GameObject.transform.localScale = Vector3.New(0.001,0.001,0.001)
			self.objList[i].GameObject.transform.localPosition = Vector3.New(-0.00491,0.00171-i*0.00002,-0.00169-(i-#self.objList/2)*0.0002)
			self.objList[i].GameObject.transform.localRotation = Quaternion.Euler(90, -157.50-(i-#self.objList/2)*8, 0)
		elseif Avatar.getAvatarSex() == 2 then 
			self.objList[i].GameObject.transform.localScale = Vector3.New(0.01,0.01,0.01)
			self.objList[i].GameObject.transform.localPosition = Vector3.New(-0.0645,0.0207-i*0.0002,-0.0150-(i-#self.objList/2)*0.002)
			self.objList[i].GameObject.transform.localRotation = Quaternion.Euler(90, -157.50-(i-#self.objList/2)*8, 0)

		end 
	end 
end 
function CharacterPlayer.ShowBottom(objList)
	for i=1,#objList do 
		table.insert(self.objList,objList[i])
	end 
	self.SortByCards()
	self.ShowHandCards()
end 
function CharacterPlayer.SortByCards()
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
function CharacterPlayer.Deal(cards,cardsType,func)
	self.Dealcards = cards
	self.func = func 
	if cardsType == CardsType.Boom then --炸弹
		CharacterPlayer.BombAnimator() 
		CharacterComputer.AmazedAnimator()--对方吃惊
	elseif cardsType == CardsType.JokerBoom then --王炸
		CharacterPlayer.JackBoomAnimator()
		CharacterComputer.AmazedAnimator()--对方吃惊
	elseif cardsType == CardsType.TripleStraightAndSingle or cardsType == CardsType.TripleStraightAndDouble then
		CharacterPlayer.PlaneAnimator()
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
function CharacterPlayer.Event1()
	self.SelectPoker()
end 
function CharacterPlayer.SelectPoker()
	self.pokers = {}
	for i = 1, #self.Dealcards do 
		for j =1, #self.objList do 
			if self.Dealcards[i].cardName == self.objList[j].name then 
				table.insert(self.pokers,self.objList[j])
				table.remove(self.objList,j)
				break
			end 
		end 
	end 
	self.ShowHandCards() --整理左手牌

	--整理右手牌
	for i =1, #self.pokers do 
		self.pokers[i].GameObject.transform.parent = self.RightHandpoint.transform
		if Avatar.getAvatarSex() == 1 then 
			self.pokers[i].GameObject.transform.localScale = Vector3.New(0.001,0.001,0.001)
			self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(90, 20, 120 - (i-#self.pokers/2)*6)
			self.pokers[i].GameObject.transform.localPosition = Vector3.New(-0.00349,0.00208+0.00001*i,0.00108)
		elseif Avatar.getAvatarSex() == 2 then 
			self.pokers[i].GameObject.transform.localScale = Vector3.New(0.005,0.005,0.005)
			self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(90, 20, 180 - (i-8)*6)
			self.pokers[i].GameObject.transform.localPosition = Vector3.New(-0.0844,0.0385+0.001*i,-0.0127)
		end 
	end 
	
	--local time = Timer.New(self.DealToDesk, 0.7,1)
	--time:Start()
end 
--牌从右手打到桌面上
function CharacterPlayer.Event2()
	LRDDZ_SoundManager.PlaySoundEffect("play")
	self.DealToDesk()
end 
function CharacterPlayer.DealToDesk()
	for i =1, #self.pokers do 
		self.pokers[i].GameObject.transform.parent = transform.parent
		self.pokers[i].GameObject.transform.localScale = Vector3.New(0.3,0.3,0.3)
		self.pokers[i].GameObject.transform.localRotation = Quaternion.Euler(90, 90, 0)
		self.pokers[i].GameObject.transform.localPosition = Vector3.New(5, (i+#GameCtrl.pokerlist)*0.01+20, 11+i)
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
function  CharacterPlayer.PokerMove()
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

function CharacterPlayer.ClearPokers()
	for i =1, #self.pokers do 
		destroy(self.pokers[i].GameObject)
	end 
	self.pokers = {}
end 
function CharacterPlayer.Clear()
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
function CharacterPlayer.Event4()
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
function  CharacterPlayer.HiAnimator()
	self.Animator:SetTrigger("Hi")
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"talk1",Avatar.getAvatarSex() == 1);
end 
--拿牌 --
function  CharacterPlayer.pickupAnimator()
	self.Animator:SetBool("pickup",true)
	self.Animator:SetBool("Win",false)
	self.Animator:SetBool("LostOut",false)
end 
--出牌 --
function  CharacterPlayer.DealAnimator()
	self.Animator:SetTrigger("Deal")
end 
--不出/不抢
function CharacterPlayer.NoDealAnimator()
	self.Animator:SetTrigger("NoDeal")
end 
--不出/不抢1
function CharacterPlayer.NoDealAnimator1()
	self.Animator:SetTrigger("NoDeal1")
end 
--吃惊
function CharacterPlayer.AmazedAnimator()
	coroutine.start(self.Amazed)
end 
--炸弹
function  CharacterPlayer.BombAnimator()
	self.Animator:SetTrigger("Bomb")
	local startPoint = self.RightHandpoint.transform.localPosition
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","shou", "shou",Vector3.New(1,1,1),startPoint, false,function(obj,name)
		coroutine.start(CharacterComputer.destroyself,obj)
	end,nil)
end 
--顺子
function CharacterPlayer.DealMoreAnimator()
	self.Animator:SetTrigger("DealMore")
end 
--飞机
function CharacterPlayer.PlaneAnimator()
	self.Animator:SetTrigger("Plane")
end
--抢地主
function  CharacterPlayer.RobLandLordAnimator()
	self.Animator:SetTrigger("RobLandLord")
end 
--抢地主1
function  CharacterPlayer.RobLandLordAnimator1()
	self.Animator:SetTrigger("RobLandLord1")
end 
function CharacterPlayer.Amazed()
	self.Animator:SetTrigger("Amazed")
end 
--大小王
function CharacterPlayer.JackAnimator()
	self.Animator:SetTrigger("Jack")
end
--王炸
function CharacterPlayer.JackBoomAnimator()
	self.Animator:SetTrigger("JackBoom")
	local startPoint = self.RightHandpoint.transform.localPosition
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","shou", "shou",Vector3.New(1,1,1),startPoint, false,function(obj,name)
		coroutine.start(CharacterComputer.destroyself,obj)
	end,nil)
end
--等待发牌1
function  CharacterPlayer.WaitLicenseAnimator()
	self.Animator:SetTrigger("WaitLicense")
end 
--等待发牌2
function  CharacterPlayer.WaitLicenseAnimator2()
	self.Animator:SetTrigger("WaitLicense2")
end
--等待发牌3
function  CharacterPlayer.WaitLicenseAnimator3()
	self.Animator:SetTrigger("WaitLicense3")
end
--等待出牌1
function CharacterPlayer.WaitDeal1Animator()
	self.Animator:SetTrigger("WaitDeal1")
end 
--等待出牌2
function CharacterPlayer.WaitDeal2Animator()
	self.Animator:SetTrigger("WaitDeal2")
end
--等待出牌3
function CharacterPlayer.WaitDeal3Animator()
	self.Animator:SetTrigger("WaitDeal3")
end
--我剩1张牌了
function CharacterPlayer.WarnOneAnimator()
	self.Animator:SetTrigger("WarnOne")
end
--我剩2两牌了
function CharacterPlayer.WarnTwoAnimator()
	self.Animator:SetTrigger("WarnTwo")
end
--赢了
function CharacterPlayer.WinAnimator()
	self.Animator:SetBool("Win",true)
	self.Animator:SetBool("pickup",false)
end
--输了
function CharacterPlayer.LostOutAnimator()
	self.Animator:SetBool("LostOut",true)
	self.Animator:SetBool("pickup",false)
end
function CharacterPlayer.Talk(index)
	--[[
	if index == 6 then
		index = 2 
	elseif index == 5 and Avatar.getAvatarSex() ~= 1 then
		index = 4
	end
	]]
	if CharacterPlayer.Animator:GetBool("pickup") == false then
		--self.Animator:SetTrigger("Talk"..index)
		self.Animator:SetFloat("NoCardTalkBlend",index)
		self.Animator:SetTrigger("NoCardTalk")
	else
		self.Animator:SetFloat("TalkBlend",index)
		self.Animator:SetTrigger("Talk")
	end
end
function CharacterPlayer.destroyself(obj)
	obj.transform.parent = self.RightHandpoint.transform.parent
	obj.transform.localPosition = Vector3.New(0,0,0)
	obj.transform.localScale = Vector3.New(1,1,1)
	coroutine.wait(1)
	destroy(obj)
end
function CharacterPlayer.GameOverAnimator(winnerIdentity)
	if winnerIdentity == Player.identity then
		CharacterPlayer.WinAnimator()
	else
		CharacterPlayer.LostOutAnimator()
	end
end
function CharacterPlayer.OnDestroy()
	transform = nil
	gameObject = nil
	self.pokers = {}
	self.objList = {}
	CharacterPlayer.OnDisable()
	self.LeftHandpoint = nil
	self.RightHandpoint = nil
	self.Animator = nil
end
