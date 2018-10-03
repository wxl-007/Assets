
OtherComputer = {}
local self = OtherComputer
self.library = {}

self.ctype = CharacterType.OtherComputer
self.sex = 2
self.id = 000002
self.name = "玩家2"
self.level = 1
self.gold = 1000000
self.icon = ""
self.identity = Identity.Farmer --身份 初始化为 农民
self.uid = 0;
self.holdNum = 0 --减去让牌数后的值
self.allNum = 0 --手上数量
self.isshowCard = false -- 是否明牌
self.raceScore = 0 --比赛积分
function OtherComputer.GetLibrary()
	return self.library
end 
--获取手牌张数
function OtherComputer.GetCardsCount()
	return #self.library
end

function OtherComputer.GetCardFromIndex(index)
	return self.library[index]
end 
--出牌
function OtherComputer.PopCard(card)
	for i =#self.library , 1,-1 do 
		if self.library[i].weight  == card.weight and  self.library[i].suits  == card.suits then 
			table.remove(self.library,i)
			return	
		end 
	end 
end 

--向牌库中添加牌
function OtherComputer.AddCard(card)
	card.charactortype = self.ctype
	table.insert(self.library,card)
	self.SortCard()
end 
--排序
function OtherComputer.SortCard()
	self.library = CardRule.SortCardsFunc(self.library)
end 

function OtherComputer.Clear()
	self.library = {}
	recLastCard = nil
	self.isshowCard = false
end 

function OtherComputer.ClearDealCard()
	EginTools.ClearChildren(self.PlacePoint.transform)
	self.DealCardObjList = {}
end 
--------------------------------------------------------------------------------

local transform
local gameObject

self.DealCardObjList = {}

function OtherComputer.Awake(obj)
	gameObject = obj
	transform = obj.transform
	self.init()
end 
function OtherComputer.OnDisable()
	self.Clear()
	self.ClearDealCard()
end 
--注销
function OtherComputer.OnDestroy()
	self.Clear()
	self.ClearDealCard()
end 

function  OtherComputer.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.PlacePoint =  transform:FindChild("PlacePoint"):GetComponent("UIGrid") 
	self.cardNum = transform:FindChild("CardsNum").gameObject
	self.cardNum:SetActive(false) 
	self.Notice = transform:FindChild("Notice").gameObject 
	self.cardtypename = transform:FindChild("CardTypeName").gameObject --连对，飞机，炸弹显示的UI字
	self.minCardtypename = transform:FindChild("minCardTypeName").gameObject
	self.showCardPos = transform:FindChild("ShowCards").gameObject -- 明牌显示牌的位置
	self.residueCardsPos = transform:FindChild("residue/residueCards").gameObject --剩余牌位置

	self.cardtypename:SetActive(false)
	self.minCardtypename:SetActive(false)
	--self.ShowNotice(GameText.YiZhunBei)
	self.ShowNotice("")
	self.Warning = transform:FindChild("Warning").gameObject
    self.Warning:SetActive(false)

    self.coPlayCard =nil
    self.popCardCount=0--出牌的次数，用于检测是否农民打出春天
    self.state = transform:FindChild("Label_State"):GetComponent("UILabel")
    self.SetComputerState(0)
    self.residueCardsPos.transform.parent.gameObject:SetActive(false)
    self.allNum = 17
    self.talk = transform:FindChild("talk").gameObject
    self.talk_desc = transform:FindChild("talk/Label_desc"):GetComponent("UILabel")
    self.talk:SetActive(false)
end
--0全部不显示
--1等待小伙伴
--2等待开局
--3等待加倍
function OtherComputer.SetComputerState(state)
	local wait = self.state.transform:FindChild("wait").gameObject;
	local waitStart = self.state.transform:FindChild("waitforstart").gameObject;
	local waitDouble = self.state.transform:FindChild("waitfordouble").gameObject;
	if state == 0 then
		wait:SetActive(false);
		waitStart:SetActive(false);
		waitDouble:SetActive(false);
	elseif state == 1 then
		wait:SetActive(true)
		waitStart:SetActive(false);
		waitDouble:SetActive(false);
	elseif state == 2 then
		wait:SetActive(false)
		waitStart:SetActive(true);
		waitDouble:SetActive(false);
	elseif state == 3 then
		wait:SetActive(false);
		waitStart:SetActive(false);
		waitDouble:SetActive(true);
	end
end
function OtherComputer.ShowWarning(isopen)
	self.Warning:SetActive(isopen)
end 
function OtherComputer.DelayPlayAudio(holdNum)--播放报警音效
	coroutine.wait(0.3)
	local audio_name = ""
	if holdNum == 2 then
		audio_name = "onlyTwo"
		CharacterOtherComputer.WarnTwoAnimator()
	elseif holdNum == 1 then
		audio_name = "onlyOne"
		CharacterOtherComputer.WarnOneAnimator()
	end
	if audio_name ~= "" then
		LRDDZ_SoundManager.OtherHumanSound(self.ctype,audio_name,self.sex == 1)
		LRDDZ_SoundManager.PlaySoundEffect("warning")
	end
end
function OtherComputer.CreatCardsOnRigntHand(num)
	--全部一样的牌
	local computerPokers = {}
	for i=1,num do
		local cardinfo = {}
		cardinfo.name = GameCtrl.pokerlist[1].name
		cardinfo.Card = GameCtrl.pokerlist[1].Card
		cardinfo.GameObject = GameObject.Instantiate(GameCtrl.pokerlist[1].GameObject,GameCtrl.pokerlist[1].GameObject.transform.position,GameCtrl.pokerlist[1].GameObject.transform.rotation)
		table.insert(computerPokers,cardinfo)
	end
	Event.Brocast(GameEvent.ShowOtherComputerHandCards, computerPokers)
end
function OtherComputer.CallScore(score)
	LRDDZ_SoundManager.OtherHumanSound(self.ctype,"callscore"..score,self.sex == 1)
	local rand = math.random(1,2)
	if  rand == 1 then
		CharacterOtherComputer.RobLandLordAnimator()
	else
		CharacterOtherComputer.RobLandLordAnimator1()
	end
	CountDownPanel.CancelCountDown(false)
end
function OtherComputer.CallLord()
	LRDDZ_SoundManager.OtherHumanSound(self.ctype,"call",self.sex == 1)
    coroutine.start(self.GradLord,0)
end
--抢地主
function OtherComputer.GradLandLord(calltimes)
	--显示倒计时
	local temp = 1
	if calltimes == 1 then
		temp = 1 
	elseif calltimes == 2 or calltimes == 3 then 
		temp = 2
	elseif calltimes == 4 then
		temp = 3
	end
	--播放音效
	if calltimes ~= 1 then
		LRDDZ_SoundManager.OtherHumanSound(self.ctype,"grab"..temp,self.sex == 1)
	else
		LRDDZ_SoundManager.OtherHumanSound(self.ctype,"call",self.sex == 1)
	end

	
    coroutine.start(self.GradLord,calltimes)
end 
function  OtherComputer.GradLord(calltimes)
    --抢地主动画
   	--抢地主动画
   	local rand = math.random(1,2)
	if  rand == 1 then
		CharacterOtherComputer.RobLandLordAnimator()
	else
		CharacterOtherComputer.RobLandLordAnimator1()
	end
	CountDownPanel.CancelCountDown(false)
   	--OrderCtrl.GradLordTrun(false)	--参数是是否放弃抢地主
   	if calltimes ~= 0 then
   		OtherComputer.ShowNotice(GameText.GradLord)	--显示字
   	else
   		OtherComputer.ShowNotice(GameText.CallLord)
   	end
end 
--不叫地主
function OtherComputer.DisCallLord()
	local rand = math.random(1,2)
	if  rand == 1 then
		CharacterOtherComputer.NoDealAnimator()
	else
		CharacterOtherComputer.NoDealAnimator1()
	end
	--OrderCtrl.GradLordTrun(true)
	OtherComputer.ShowNotice(GameText.DisCallLord)
	--播放音效
	LRDDZ_SoundManager.OtherHumanSound(self.ctype,"noCall",self.sex == 1)
end
--不抢地主
function OtherComputer.DisGradLandLord()
	local rand = math.random(1,3)
	if  rand == 1 then
		CharacterOtherComputer.NoDealAnimator()
	else
		CharacterOtherComputer.NoDealAnimator1()
	end
	--OrderCtrl.GradLordTrun(true)
	OtherComputer.ShowNotice(GameText.DisGradLord)
	--播放音效
	LRDDZ_SoundManager.OtherHumanSound(self.ctype,"noGrab",self.sex == 1)
end
--加倍
function OtherComputer.Double()
	LRDDZ_SoundManager.OtherHumanSound(self.ctype,"double",self.sex == 1)
	CharacterOtherComputer.RobLandLordAnimator1()
	OtherComputer.ShowNotice(GameText.Double)
end
function OtherComputer.NoDouble()
	LRDDZ_SoundManager.OtherHumanSound(self.ctype,"noDouble",self.sex == 1)
	CharacterOtherComputer.NoDealAnimator1()
	OtherComputer.ShowNotice(GameText.DisDouble)
end

function OtherComputer.DisPlayCard(  )
	local rand = math.random(1,3)
		if  rand == 1 then
			CharacterOtherComputer.NoDealAnimator()
		else
			CharacterOtherComputer.NoDealAnimator1()
		end
		CountDownPanel.CancelCountDown(false)
		OtherComputer.ShowNotice(GameText.DisPlay)
		
		
		--OrderCtrl.bigest = CharacterType.Player
		--播放音效
		LRDDZ_SoundManager.OtherHumanSound(self.ctype,"pass",self.sex == 1)
end
function OtherComputer.PlayCardByServer(cards,holdNum)
	CountDownPanel.CancelCountDown(false)
	
	local isRule, cardsType, cardLength = CardRule.PopEnable(cards)
	--播放音效

	--判断是否要播放大你的音效
	local normal = true
	if cardsType==CardsType.OnlyThree or cardsType==CardsType.ThreeAndOne or cardsType==CardsType.ThreeAndTwo or cardsType==CardsType.Straight or cardsType==CardsType.DoubleStraight or cardsType==CardsType.TripleStraight or cardsType==CardsType.TripleStraightAndSingle or cardsType==CardsType.TripleStraightAndDouble or cardsType==CardsType.FourAndSingle or cardsType==CardsType.FourAndDouble then
		if OrderCtrl.bigest ~= CharacterType.OtherComputer then --判断大你的牌是否是对方出的
			LRDDZ_SoundManager.OtherHumanSound(self.ctype,"bigger",self.sex == 1); --播放大你音效
			normal = false
		end
	end
	if OrderCtrl.bigest == self.ctype or OrderCtrl.bigest == nil then
		if cardsType == CardsType.Single and cards[1].weight <= Weight.Six then
			normal = false
			clip = LRDDZ_SoundManager.OtherHumanSound(self.ctype,"singlexiao",self.sex == 1); --播放小牌音效
		end
		if cardsType == CardsType.Double and cards[1].weight <= Weight.Six then
			clip = LRDDZ_SoundManager.OtherHumanSound(self.ctype,"doublexiao",self.sex == 1); --播放一对小牌音效
			normal = false
		end
	end
	--播放正常的音效
	if normal == true then
		clip = LRDDZ_SoundManager.PlayHumanSound(self.ctype,cards,cardsType,self.sex == 1)
	end

	local function CheckWarn(_clip)
		if _clip ~= nil then
			coroutine.wait(_clip.length)
		end
		self.DelayPlayAudio(holdNum)
	end
	coroutine.start(CheckWarn,clip)

	OrderCtrl.bigest = self.ctype
	--DeskCardsCache.AllClear()--删除当前桌面UI上对方打的牌
	DeskCardsCache.ClearRecord()
	DeskCardsCache.CardType = cardsType
	DeskCardsCache.CardLength = cardLength
	for i = 1,#cards do 
		--self.PopCard(cards[i])
		DeskCardsCache.AddCard(cards[i])
	end 
	--播放特效
	if cardsType == CardsType.Straight or cardsType == CardsType.DoubleStraight or cardsType == CardsType.DoubleStraight or cardsType == CardsType.TripleStraight
		or cardsType == CardsType.TripleStraightAndSingle or cardsType == CardsType.TripleStraightAndDouble or cardsType == CardsType.Boom then
		ParticleManager.PopCard(self.ctype)
	end
	self.ShowDealCard(cards)

	CharacterOtherComputer.Deal(cards,cardsType,func)   --播放出牌动作

		--特效
		if cardsType == CardsType.Straight then 																	--顺子特效
			coroutine.start(self.PlayCardTypeName,cardsType) --显示UI字
			coroutine.wait(0.5)		
			local shunziName = "shunzinv";
			if self.sex == 1 then 
				shunziName = "shunzinan"
			else
				shunziName = "shunzinv"
			end																			--男坐标 -13,18,4.7
			--ParticleManager.ShowParticle("Particle", shunziName,Vector3.New(1,1,1),Vector3.New(-6.9,20.5,10.6),Vector3.New(-90,12.4922,0),3)
			LRDDZ_SoundManager.PlaySoundEffect("straight")	
			coroutine.wait(0.2)
		elseif cardsType == CardsType.DoubleStraight then 															--连对特效 --男坐标 -12,18,8  -90,-60,0
			coroutine.start(self.PlayCardTypeName,cardsType) --显示UI字
			coroutine.wait(0.5)
			local lianduiName = "lianduinv";
			if self.sex == 1 then 
				lianduiName = "lianduinan" 
			else
				lianduiName = "lianduinv";
			end
			--ParticleManager.ShowParticle("Particle", lianduiName,Vector3.New(1,1,1),Vector3.New(-6.9,20.5,10.6),Vector3.New(-90,12.4922,0),3)
			LRDDZ_SoundManager.PlaySoundEffect("straight")
			coroutine.wait(0.2)
		elseif  cardsType == CardsType.Single then 
			if cards[1].weight ==  Weight.SJoker then 	
				coroutine.wait(0.4)--手部动作等待时间	
				LRDDZ_SoundManager.PlaySoundEffect("getCoin")														--小王特效
				ParticleManager.ShowParticle("Particle", "xiaogui",Vector3.New(1,1,1),Vector3.New(12,24.49,-1.5),Vector3.New(0,0,0),3)
			elseif cards[1].weight ==  Weight.LJoker then 	
				coroutine.wait(0.4)--手部动作等待时间		
				LRDDZ_SoundManager.PlaySoundEffect("getCoin")												--大王特效
				ParticleManager.ShowParticle("Particle", "dagui",Vector3.New(1,1,1),Vector3.New(12,24.49,-1.5),Vector3.New(0,0,0),3)
			end
			coroutine.wait(0.5)
		elseif cardsType == CardsType.TripleStraightAndSingle or cardsType == CardsType.TripleStraightAndDouble then--飞机特效 
			coroutine.start(self.PlayCardTypeName,cardsType) --显示UI字
			ParticleManager.PlaneFly(CharacterType.OtherComputer)
			coroutine.wait(0.5)
		elseif cardsType == CardsType.Boom then 		
		coroutine.start(self.PlayCardTypeName,cardsType) --显示UI字															--炸弹特效
			ParticleManager.Boom(CharacterType.OtherComputer)
			coroutine.wait(0.5)
			--coroutine.wait(1.1)--等待炸弹特效完成后显示字时间
		elseif cardsType == CardsType.JokerBoom then 																--王炸特效
			ParticleManager.JokerBoom(CharacterType.OtherComputer)
			coroutine.wait(0.5)
		end 
		
		--coroutine.wait(0.2)

		
		--显示牌的张数
		coroutine.wait(0.5)	--等待动作和特效完成显示出的牌
		--记牌器显示出牌
		
		GameCtrl.ShowGameText(CharacterType.OtherComputer) --显示文字		
		--判断游戏是否结束
		coroutine.wait(0.8)--等待特效播放完再判断输赢
end
function OtherComputer.ShowDealCard(cards)
	EginTools.ClearChildren(self.PlacePoint.transform)
	cards = CardRule.SortCardsFunc(cards,true) --降序排序
	local count = #cards
	for i = 1, #cards do 
		if self.DealCardObjList[i]== nil then 
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","dealCard",false)
			obj.transform.parent = self.PlacePoint.transform;
			obj:GetComponent("UISprite"):MakePixelPerfect()
			obj.transform.localScale = Vector3.New(1,1,1);
			--obj.transform.localPosition =Vector3.New((i-count)*30,0,0) --(i-count/2)*30
			obj.transform.localPosition =Vector3.New(0,0,0) --(i-count/2)*30

			table.insert(self.DealCardObjList,obj)
		end 
		--self.DealCardObjList[i].transform:GetComponent("UISprite").spriteName = cards[i].cardName
		--[[
		if cards[i].weight >= Weight.SJoker then
			self.DealCardObjList[i].transform:GetComponent("UISprite").spriteName = WeightString[cards[i].weight]
		else
			self.DealCardObjList[i].transform:GetComponent("UISprite").spriteName = cards[i].suits
		end
		self.DealCardObjList[i].transform:FindChild("Label"):GetComponent("UILabel").text = SuitsColor[cards[i].suits]..WeightText[cards[i].weight]
		]]

		if cards[i].oldweight~=Weight.None then
			MyCommon.SetPut2DCard(self.DealCardObjList[i],cards[i].suits,cards[i].weight,true)
		else
			MyCommon.Set2DCard(self.DealCardObjList[i],cards[i].suits,cards[i].weight)
		end

		self.DealCardObjList[i].transform:FindChild("Label"):GetComponent("UILabel").depth = 4+i
		
		self.DealCardObjList[i].transform:GetComponent("UISprite").depth = 3+ i
		if i == #cards and self.isshowCard then
			local endObj = self.DealCardObjList[i].transform:FindChild("showCard").gameObject
			endObj:SetActive(true)
			endObj:GetComponent("UISprite").depth = 4+i
		end


		
	end 
	self.PlacePoint.repositionNow = true
end


function OtherComputer.ShowNotice(str)
	self.Notice:SetActive(true)
	self.Notice.transform:GetComponent("UISprite").spriteName = str
	if str ~= "" then
		self.Notice:GetComponent("UISprite"):MakePixelPerfect()
	end
end 
function OtherComputer.ShowCardsNum(isactive)
	print(isactive);
	self.cardNum:SetActive(isactive) 
	
end 
function OtherComputer.HideCardsNum()
	self.cardNum.transform:GetComponent("UILabel").text = "0"
	self.cardNum:SetActive(false) 
end
function OtherComputer.HidenNotice()
	self.Notice:SetActive(false)
	self.ShowWarning(false)
end 
function OtherComputer.SetCardsNum(num,foldnum)
	if self.cardNum.activeSelf == false then
		self.cardNum:SetActive(true)
	end
	if self.identity == Identity.Farmer then
		num = num + foldnum
	end
	self.allNum = num
	self.cardNum.transform:GetComponent("UILabel").text = num
end
function OtherComputer.Reset()
	self.HidenNotice()
	OtherComputer.isshowCard = false
	for i = 1, #self.showCards do
		destroy(self.showCards[i])
	end
	self.showCards = {}
	recLastCard = nil
	self.allNum = 17
end 
local recLastCard = nil --明牌时记录最后一张牌，用于显示明牌标志
self.showCards = {}
--显示明牌的牌
function OtherComputer.ShowOpenHandCards(cards,isanim)
	self.isshowCard = true
	self.library = cards
	local temp = {}
	for i=#cards,1,-1 do
		table.insert(temp,cards[i])
	end
	cards = temp
	for i = 1, #cards do 
		if self.showCards[i]== nil then 
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","openHand",false)
			obj.transform.parent = self.showCardPos.transform;
			obj:GetComponent("UISprite"):MakePixelPerfect()
			obj.transform.localScale = Vector3.New(1,1,1);

			table.insert(self.showCards,obj)
			if isanim~= nil and isanim then
				obj:SetActive(false)
			end
		end 
		--self.showCards[i].transform:GetComponent("UISprite").spriteName = cards[i].cardName
		self.showCards[i].transform:GetComponent("UISprite").depth = 3+ i

		--[[
		if cards[i].weight >= Weight.SJoker then
			self.showCards[i].transform:GetComponent("UISprite").spriteName = WeightString[cards[i].weight]
		else
			self.showCards[i].transform:GetComponent("UISprite").spriteName = cards[i].suits
		end
		self.showCards[i].transform:FindChild("Label"):GetComponent("UILabel").text = SuitsColor[cards[i].suits]..WeightText[cards[i].weight]
		]]
		MyCommon.Set2DCard(self.showCards[i],cards[i].suits,cards[i].weight)
		self.showCards[i].transform:FindChild("Label"):GetComponent("UILabel").depth = 4+i

		if i == #cards then
			if recLastCard ~= nil then
				local function tryCatchFunc()
					recLastCard:SetActive(false)
				end
				if not pcall(tryCatchFunc) then
					recLastCard = nil
				end
			end
			recLastCard = self.showCards[i].transform:FindChild("showCard").gameObject
			recLastCard:SetActive(true)
			recLastCard:GetComponent("UISprite").depth = 4+i
		end
	end 

	for i=#self.showCards,#cards+1, -1 do
		destroy(self.showCards[i])
		table.remove(self.showCards,i)
	end
	self.showCardPos:GetComponent("UIGrid").repositionNow = true
	if isanim ~= nil or isanim == true then
	--播放动画
		for i=1,#cards do
			local function dealyPlayerAnim(ob)
				coroutine.wait(i*0.1)
				local pos = Vector3.New(500,0,0)
				if i > 10 then
					pos = pos + Vector3.New(0,-137,0)
				end
				ob:SetActive(true)
				iTween.MoveFrom(ob,iTween.Hash("position", pos,"islocal",true,"time",0.5))
			end
			coroutine.start(dealyPlayerAnim,self.showCards[i])
		end
	end
end
function OtherComputer.UpdateOpenHandCards()
	OtherComputer.ShowOpenHandCards(self.library)
end
function OtherComputer.PlayCardTypeName(cardstype)
	local cardtypeSprite = self.cardtypename:GetComponent('UISprite')
	if cardstype == CardsType.Straight then --顺子字
			cardtypeSprite.spriteName = "shunzi"
	elseif cardstype == CardsType.DoubleStraight then --连对字
			cardtypeSprite.spriteName = "liandui"
	elseif cardstype == CardsType.TripleStraightAndSingle or cardstype == CardsType.TripleStraightAndDouble then --飞机
			cardtypeSprite.spriteName = "feiji"
	elseif cardstype == CardsType.Boom then --炸弹字
			--self.cardtypename.transform.localPosition = Vector3.New(23,56,0)
			cardtypeSprite.spriteName = "zhadan"
	end
	self.cardtypename:GetComponent('UISprite'):MakePixelPerfect()
	self.minCardtypename:GetComponent("UISprite").spriteName = cardtypeSprite.spriteName
	self.minCardtypename:SetActive(true)

	--min动画
	self.minCardtypename.transform.localPosition = Vector3.New(-525,-30,0);
	self.minCardtypename.transform.localScale = Vector3.one
	iTween.MoveTo(self.minCardtypename, iTween.Hash("x",-250, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.linear));
	coroutine.wait(0.5)
	iTween.ScaleTo(self.minCardtypename,iTween.Hash("scale", Vector3.New(1.5,1.5,1.5), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeInOutBack))


	coroutine.wait(0.3)
	self.cardtypename:SetActive(true)
	coroutine.wait(0.3)
	self.cardtypename:SetActive(false)
	coroutine.wait(0.7)
	self.minCardtypename:SetActive(false);
end
--剩余牌
function OtherComputer.ResidueCards(cards)
	for i = 1, #cards do 
		local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","openHand",false)
		obj.transform.parent = self.residueCardsPos.transform;
		obj:GetComponent("UISprite"):MakePixelPerfect()
		obj.transform.localScale = Vector3.New(1,1,1);

		--obj.transform:GetComponent("UISprite").spriteName = cards[i].cardName
		obj.transform:GetComponent("UISprite").depth = 3+ i

		--[[
		if cards[i].weight >= Weight.SJoker then
			obj.transform:GetComponent("UISprite").spriteName = WeightString[cards[i].weight]
		else
			obj.transform:GetComponent("UISprite").spriteName = cards[i].suits
		end
		obj.transform:FindChild("Label"):GetComponent("UILabel").text = SuitsColor[cards[i].suits]..WeightText[cards[i].weight]
		]]
		MyCommon.Set2DCard(obj,cards[i].suits,cards[i].weight)
		obj.transform:FindChild("Label"):GetComponent("UILabel").depth = 4+i
		
	end
	self.residueCardsPos:GetComponent("UIGrid").repositionNow = true
	self.residueCardsPos.transform.parent.gameObject:SetActive(true)
end
function OtherComputer.DelectResidueCards( )
	EginTools.ClearChildren(self.residueCardsPos.transform)
	self.residueCardsPos.transform.parent.gameObject:SetActive(false)
end
local talkCne = nil
local talkcontent = require "GameLRDDZ.config.TalkContent"
function OtherComputer.Talk(talkid)
	if talkCne ~= nil then
		coroutine.Stop(talkCne)
	end
	self.talk:SetActive(true)
	self.talk_desc.text = talkcontent[talkid].content
	local function func()
		coroutine.wait(3)
		self.talk:SetActive(false)
	end
	talkCne = coroutine.start(func)
end
