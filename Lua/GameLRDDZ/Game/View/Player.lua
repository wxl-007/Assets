
Player = {}
local self = Player

self.library = {}

self.ctype = CharacterType.Player

self.identity = Identity.Farmer --身份 初始化为 农民
self.isshowCard = false
self.holdNum = 0; --减去让牌数后的
self.raceScore = 0 --比赛积分
local curSelectCard = nil
function Player.GetLibrary()
	self.SortCard()
	return self.library
end 
function Player.SetLibrary(cards)
	self.library = cards;
	self.SortCard()
	self.ShowCards()
end
--获取手牌张数
function Player.GetCardsCount()
	return #self.library
end

function Player.GetCardFromIndex(index)
	return self.library[index]
end 
--出牌
function Player.PopCard(card)
	for i =1 , #self.library do 
		if self.library[i] == card then 
			table.remove(self.library,i)
			return	
		end 
	end 

end 

--向牌库中添加牌
function Player.AddCard(card)
	card.charactortype = self.ctype
	table.insert(self.library,card)
end 
--排序
function Player.SortCard()
	self.library = CardRule.SortCardsFunc(self.library)
end 

function Player.Clear()
	self.library = {}
	self.promptCards = {}
	self.promptNum = 1
	self.promptObject = {}
	Player.IsShowCard(false)
	--清空手上的牌
	for k,obj in pairs(self.CardObjectList) do 
		self.behaviour:MyDestroy(obj.GameObject)
	end 
	self.CardObjectList = {}
	recLastCard = nil

end 
function Player.ClearDealCard()
	EginTools.ClearChildren(self.PlacePoint.transform)
	self.DealCardObjList = {}
end 
---------------------------------------------------------------------------

local transform
local gameObject


self.isCanSelected = false --是否可点击

function Player.Awake(obj)
	gameObject = obj
	transform = obj.transform

	self.CardObjectList = {} --拥有的牌

	self.DealCardObjList = {} --出的牌

	self.promptCards = {}
	self.promptNum = 1
	self.promptObject = {}

	self.init()
end 

--注销
function Player.OnDestroy()
	self.library = {}
	self.CardObjectList = {}
 	mousePosition = nil
end 
--初始化
function  Player.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.cardsPoint =  transform:FindChild("CardsStartPoint").gameObject 
	--self.PlacePoint =  transform:FindChild("PlacePoint").gameObject
	self.PlacePoint =  transform:FindChild("PlacePoint"):GetComponent("UIGrid");
	self.Notice = transform:FindChild("Notice").gameObject 
	self.cardtypename = transform:FindChild("CardTypeName").gameObject --连对，飞机，炸弹显示的UI字
	self.minCardtypename = transform:FindChild("minCardTypeName").gameObject --连对，飞机，炸弹显示的UI字
	self.cardtypename:SetActive(false)
	self.minCardtypename:SetActive(false)
	self.Notice:SetActive(false)
	--self.time =  Timer.New(self.RepeatCheckTouch, 0.01, -1, true)
	self.popCardCount=0--出牌的次数，用于检测是否农民打出春天
    self.noRules = transform:FindChild("NoRules").gameObject
    self.noRules:SetActive(false)
    self.showcardicon = transform:FindChild("showCard").gameObject --明牌图标
    self.showcardicon:SetActive(false)
    self.talk = transform:FindChild("talk").gameObject
    self.talk_desc = transform:FindChild("talk/Label_desc"):GetComponent("UILabel")
    self.talk:SetActive(false)
end 
--提示你的牌不符合规则
function Player.ShowNoRules()
	self.noRules:SetActive(true)
	--GamePanel.HidenGameObjText()
	coroutine.start(Player.delayHideNoRulse)
end
function Player.delayHideNoRulse()
	coroutine.wait(2)
	self.noRules:SetActive(false)
	--GamePanel.ShowGameObjText()
end
function Player.OnEnable()
	if self.time ~= nil then 
		self.time:Start()
	end 
end  

function Player.OnDisable()
	if self.time ~= nil then 
		self.time:Stop()
	end 
	self.Clear()
	self.ClearDealCard()
end 
function Player.IsShowCard( isshow )
	self.isshowCard = isshow
	self.showcardicon:SetActive(isshow)
end
local recLastCard = nil --明牌时记录最后一张牌，用于显示明牌标志
--显示发牌UI动画
function Player.PutUICards()
	--local vector = self.cardsPoint.transform.localPosition
	local vector = Vector3.New(0,0,0)
	local count = #self.library
	self.library = CardRule.SortCardsFunc(self.library,true)

	for i = 1, #self.library do 
		if self.CardObjectList[i]== nil then  --创建底部的牌
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("poker","poker","LuaPoker",false)
			--obj.transform.parent = transform;
			obj.transform.parent = self.cardsPoint.transform
			obj.transform.localScale = Vector3.New(1,1,1);
			local CardInfo = {}
			CardInfo.GameObject = obj 
			table.insert(self.CardObjectList,CardInfo)
		end 
		self.CardObjectList[i].GameObject.transform.localPosition = Vector3.New(vector.x+640,vector.y ,vector.z)
		--[[
		if self.library[i].weight >= Weight.SJoker then
			self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").spriteName = WeightString[self.library[i].weight]
		else
			self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").spriteName = self.library[i].suits
		end
		
		self.CardObjectList[i].GameObject.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor[self.library[i].suits]..WeightText[self.library[i].weight]
		]]
		MyCommon.Set2DCard(self.CardObjectList[i].GameObject,self.library[i].suits,self.library[i].weight)
		self.CardObjectList[i].GameObject.transform:FindChild("Label"):GetComponent("UILabel").depth =  41+i
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite"):MakePixelPerfect()
		self.CardObjectList[i].GameObject.transform.localScale = Vector3.New(1.5,1.5,1.5);
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").depth = 40+ i
		self.CardObjectList[i].Card = self.library[i]
		self.CardObjectList[i].Selected = false
		self.CardObjectList[i].isTouching = false
		--iTween.MoveTo(self.CardObjectList[i].GameObject, iTween.Hash("position", Vector3.New(vector.x+(i-count/2)*46 - 26,vector.y ,vector.z), "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));
		iTween.MoveTo(self.CardObjectList[i].GameObject, iTween.Hash("position", Vector3.New(vector.x+(i-count/2)*70-25,vector.y ,vector.z), "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));
		coroutine.wait(0.1)
		LRDDZ_SoundManager.PlaySoundEffect("deal")
        --给最后一张牌扩大点击范围
		if i == #self.library then 
			self.CardObjectList[i].offset = 60
		else 
			self.CardObjectList[i].offset = 0
		end 

		if i == #self.library and self.isshowCard then
			recLastCard = self.CardObjectList[i].GameObject.transform:FindChild("showCard").gameObject
			recLastCard:SetActive(true)
			recLastCard:GetComponent("UISprite").depth = 41+i
		end
	end 
	--发完牌
	GameCtrl.dealing = false
end
--显示手牌
function Player.ShowCards()
	--local vector = self.cardsPoint.transform.localPosition
	local vector = Vector3.New(0,0,0)
	local count = #self.library
	--self.library = CardRule.SortCardsFunc(self.library,true)
	self.library = CardRule.SortCardsWithChangeFunc(self.library,true)

	--删除多出的牌
	if #self.CardObjectList > #self.library then
		local destroyNum = #self.CardObjectList - #self.library ;
		for i=1,destroyNum do
			destroy(self.CardObjectList[1].GameObject);
			table.remove(self.CardObjectList,1)
		end
	end
	for i = 1, #self.library do 
		if self.CardObjectList[i]== nil then  --创建底部的牌
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("poker","poker","LuaPoker",false)
			--obj.transform.parent = transform;
			obj.transform.parent = self.cardsPoint.transform;
			obj.transform.localScale = Vector3.New(1,1,1);
			local CardInfo = {}
			CardInfo.GameObject = obj 
			table.insert(self.CardObjectList,CardInfo)
		end 
		
		self.CardObjectList[i].GameObject.transform.localPosition =Vector3.New(vector.x+(i-count/2)*70-25,vector.y ,vector.z)
		--[[
		if self.library[i].weight >= Weight.SJoker then
			self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").spriteName = WeightString[self.library[i].weight]
		else
			self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").spriteName = self.library[i].suits
		end
		self.CardObjectList[i].GameObject.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor[self.library[i].suits]..WeightText[self.library[i].weight]
		]]
		MyCommon.Set2DCard(self.CardObjectList[i].GameObject,self.library[i].suits,self.library[i].weight)

		self.CardObjectList[i].GameObject.transform:FindChild("Label"):GetComponent("UILabel").depth =  41+i
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite"):MakePixelPerfect()
		self.CardObjectList[i].GameObject.transform.localScale = Vector3.New(1.5,1.5,1.5);
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").depth = 40+ i
		self.CardObjectList[i].Card = self.library[i]
		self.CardObjectList[i].Selected = false
		self.CardObjectList[i].isTouching = false
		-------------------------------
        --给最后一张牌扩大点击范围
		if i == #self.library then 
			self.CardObjectList[i].offset = 60
		else 
			self.CardObjectList[i].offset = 0
		end 
		if i == #self.library and self.isshowCard then
			if recLastCard ~= nil then
				local function tryCatchFunc()
					recLastCard:SetActive(false)
				end
				if not pcall(tryCatchFunc) then
					recLastCard = nil
				end
			end
			recLastCard = self.CardObjectList[i].GameObject.transform:FindChild("showCard").gameObject
			recLastCard:SetActive(true)
			recLastCard:GetComponent("UISprite").depth = 41+i
		end
	end 
end 
self.isTouch = false 
local recTouchCards = {} --记录划过的牌
local isTouchOver = false; --是否划牌结束
local recStartPos = nil
local touchCard = false
function Player.Update()
	if self.isCanSelected == false then return end 
	
	if Input.GetMouseButtonDown(0) or (Input.touchCount>0 and Input.GetTouch(0).phase == TouchPhase.Began) then
		--按开，开始记录
		recTouchCards = {};
		isTouchOver = false;
		recStartPos = self.ScreenToUI(Input.mousePosition);
		
		for k,value in pairs(self.CardObjectList) do 
            	
	        if (recStartPos.x > value.GameObject.transform.localPosition.x - 80 and recStartPos.x < value.GameObject.transform.localPosition.x - 15 + value.offset  and
	        	recStartPos.y > value.GameObject.transform.localPosition.y - 120 and recStartPos.y < value.GameObject.transform.localPosition.y + 120) then 
	        	touchCard = true
	        	break;
	    	end
	    end
	end
	
 	if  Input.GetMouseButton(0) or (Input.touchCount>0 and Input.GetTouch(0).phase == TouchPhase.Moved) then 

 		if touchCard == false then
	    	return
	    end

	 	self.isTouch = true
	 	local pos = self.ScreenToUI(Input.mousePosition); --结束的点 开始的点 recStartPos
	 	
	 	local maxpos,minpos
	 	if pos.x - recStartPos.x >= 0 then
	 		maxpos = pos;
	 		minpos = recStartPos;
	 	else
	 		maxpos = recStartPos;
	 		minpos = pos;
	 	end
 		for k,value in pairs(self.CardObjectList) do 
            if value.isTouching == false then
	            if (maxpos.x > value.GameObject.transform.localPosition.x - 80 and minpos.x < value.GameObject.transform.localPosition.x - 15 + value.offset ) then 

	            --if (pos.x > value.GameObject.transform.localPosition.x - 80 and pos.x < value.GameObject.transform.localPosition.x - 20 + value.offset  and
	               -- pos.y > value.GameObject.transform.localPosition.y - 120 and pos.y < value.GameObject.transform.localPosition.y + 120) then 

	                value.isTouching = true;
	                self.CardObjectList[k].GameObject.transform:GetComponent("UISprite").color =  Color.New(124/255, 124/255, 124/255, 1)	 
	                  
	                --if CardRule.CardWeightContains(recTouchCards,value.Card) == false then
	                if tableContains(recTouchCards,value.Card) == false then
	         			table.insert(recTouchCards,self.CardObjectList[k].Card);--记录划过的牌
	        		end      
	        		Player.Selected(k)
	            end 

	        end 
	        
	        
        end 
	end     
    if Input.GetMouseButtonUp(0) or (Input.touchCount>0 and Input.GetTouch(0).phase == TouchPhase.Ended) then
    	isTouchOver = true;
    	touchCard = false
    	--[[
    	if #recTouchCards >= 2 then
	   		--划过智能选牌
	   			print("划牌");
	   			self.SelectedMoreCards(recTouchCards);
	   end
	   ]]
	   if #recTouchCards == 1 and curSelectCard.Selected == false then
	   		--print("不匹配")
	   else
	   		Player.AutoSelectCard()
	   end 
    	if self.isTouch == true then
    		self.isTouch = false  
    		
    		--local selectedcard = {}  		
			for k,value in pairs(self.CardObjectList) do 
				--if value.isTouching == true then	  
	            	--table.insert(selectedcard,value.Card)          	
	            --end
	            value.isTouching = false 
	            self.CardObjectList[k].GameObject.transform:GetComponent("UISprite").color =  Color.New(255/255, 255/255, 255/255, 1)	                              	            
	        end 
	    	
	    end 
	    Player.LastOneHand()
    end 
    --[[
    if not Input.GetMouseButton(0) then 
    	if self.isTouch == true then 
    		self.isTouch = false
	        for k,value in pairs(self.CardObjectList) do 
	            value.isTouching = false 
	            self.CardObjectList[k].GameObject.transform:GetComponent("UISprite").color =  Color.New(255/255, 255/255, 255/255, 1)
	        end
	    end 
    end 
    ]]
    --鼠标右键出牌
    if Input.GetMouseButtonDown(1) then
    	--当前是玩家出牌
    	if GamePanel.play.gameObject.activeSelf == true then
    	 	GamePanel.PlayCallBack()
    	end
    end
end 
function Player.getOneOFRepeat(weight)--取重复的一个
	local isRepeat = false
	local count=0
	local index =0
	for i=1,#self.CardObjectList do
		if self.CardObjectList[i].Card.weight == weight then
			count = count +1
			index = i
		end
	end
	if count >1 then
		return true,index
	else
		return false
	end
end
--选中牌和取消选中牌
function Player.Selected(index)
   self.CardObjectList[index].Selected = not  self.CardObjectList[index].Selected --每次赋值为反
   curSelectCard = self.CardObjectList[index]
   local vector = self.CardObjectList[index].GameObject.transform.localPosition
   if self.CardObjectList[index].Selected == true then 
	   self.CardObjectList[index].GameObject.transform.localPosition =Vector3.New(vector.x,0 + 20 , vector.z)
	   
	else
	   self.CardObjectList[index].GameObject.transform.localPosition = Vector3.New(vector.x,0, vector.z)
	end 
end 
function Player.AutoSelectCard()
	--智能选牌功能
	   --遍历所有手牌是否有选中2个或者3个,2个则判断是否有顺子和三带一，3个则判断顺子三带一都有的下一步操作
	   local selectedCards = {}
	   for i=1,#self.CardObjectList do
	   	   --if self.CardObjectList[i].Selected == true and self.CardObjectList[i].isTouching == false then
	   	   if self.CardObjectList[i].Selected == true then
	   	   	--储存那两张牌
	   	   	table.insert(selectedCards,self.CardObjectList[i].Card);
	   	   end
	   end
	   if OrderCtrl.bigest == self.ctype then
		   if #recTouchCards >= 2 then
		   		--划过智能选牌
		   		if isTouchOver == true then
		   			self.SelectedMoreCards(recTouchCards);
		   		end
		   else
		   			--点击智能选牌
				   if #selectedCards == 2 then
				   	  	self.SelectTwoCard(selectedCards);
				   elseif #selectedCards == 3 then
				   	  	self.SelectThreeCard(selectedCards);
				   elseif #selectedCards == 4 then
				  	    self.SelectFourCard(selectedCards);
				  	elseif #selectedCards>= 5 then
						self.SelectFiveCard(selectedCards);
				   end
			end
		else
			--指定选牌
			if #recTouchCards >= 2 then
				--划牌
				if isTouchOver == true then
		   			Player.SelectedMoreCardsByLast(recTouchCards)
		   		end
			else
				if #selectedCards == 1 then
					Player.SelectedCardsByLast(selectedCards[1])
				end
			end
		end
end
--鼠标与屏幕坐标转换
local mousePosition = nil
function  Player.ScreenToUI(pos)
	if mousePosition == nil then
		mousePosition = transform:FindChild("CardsStartPoint/mousePosition")
	end
	--测试是否为空
	local function trymousePosition()
		local x = mousePosition.position
	end
	if pcall(trymousePosition) then
		mousePosition.position = UICamera.currentCamera:ScreenToWorldPoint(pos)
		return mousePosition.localPosition
	else
		mousePosition = transform:FindChild("CardsStartPoint/mousePosition")
		mousePosition.position = UICamera.currentCamera:ScreenToWorldPoint(pos)
		return mousePosition.localPosition
	end
	
	
	--[[
	if Application.isEditor == true then
	    pos.x = pos.x * 1920 / Screen.width;
	    pos.y = pos.y * 1080 / Screen.height;
	    pos.y = pos.y - 1080/2 
	    pos.x = pos.x - 1920/2 + 1920*(Screen.currentResolution.height/1080 - 1)/2
	    return pos
	else
	    pos.y = pos.y -  Screen.currentResolution.height/2;
	    pos.x = pos.x - Screen.currentResolution.width/2
	    return pos
	end

	return pos
	]]
end 

--选中提示出牌的所有牌
function Player.SelectCardList(cards)
	local selectObjectList = {}
	for i = 1, #cards do 
		for j = 1, #self.CardObjectList do 
			if cards[i].weight == self.CardObjectList[j].Card.weight and cards[i].suits == self.CardObjectList[j].Card.suits then 
				if self.CardObjectList[j].Selected == false then 
					self.CardObjectList[j].Selected = true
					local vector = self.CardObjectList[j].GameObject. transform.localPosition
					self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(vector.x,0+ 20 , vector.z)
					self.CardObjectList[j].GameObject.transform:GetComponent("UISprite").color =  Color.New(255/255, 255/255, 255/255, 1)
				end 
				table.insert(selectObjectList,self.CardObjectList[j])
			end 
		end 
	end
	return selectObjectList
end 
--取消选择 
function Player.CancelSelcted()
	for i =1, #self.CardObjectList do 
		if  self.CardObjectList[i].Selected == true then 
			self.CardObjectList[i].Selected = false
			local vector = self.CardObjectList[i].GameObject.transform.localPosition
			self.CardObjectList[i].GameObject. transform.localPosition =Vector3.New(vector.x,0 , vector.z)
			self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(255/255, 255/255, 255/255, 1)
		end 
	end 
end 

function Player.ClearPrompt()
	self.promptCards = {}
	self.promptNum = 1
end 
--提示出牌
function Player.PromptPlayCards()
	--self.CancelSelcted() --取消选择
	local isCan,promptCards = self.CheckCanPlay()
	if isCan == true then 
		self.SetColorForCard(false,true)
	 	self.promptCards = promptCards
	 	if #self.promptCards > 0 then --如果提示牌种数大于0，显示提示牌
			if self.promptNum > #self.promptCards then  --如果提示牌的index大于提示牌种数，index=1
				self.promptNum = 1
			end  
			self.promptObject = self.SelectCardList(self.promptCards[self.promptNum])
			self.promptNum = self.promptNum+1 --提示牌的index+1，切换提示牌
		end
	 	Event.Brocast(GameEvent.NotBigCard, false)
	else 
	 	self.SetColorForCard(true,false)
	 	Event.Brocast(GameEvent.NotBigCard, true)
	end 		
	return  isCan
end 
function Player.CheckWarn(holdNum)--检测是否播放报警提示
	local audio_name = ""
	if holdNum == 2 then
		audio_name = "onlyTwo"
		CharacterPlayer.WarnTwoAnimator()
	elseif holdNum == 1 then
		audio_name = "onlyOne"
		CharacterPlayer.WarnOneAnimator()
	end
	if audio_name ~= "" then
		LRDDZ_SoundManager.OtherHumanSound(self.ctype,audio_name,Avatar.getAvatarSex() == 1)
	end
end
--是否有大的牌
function  Player.CheckCanPlay(library)
	local weight =  DeskCardsCache.GetWeight()
	local cardType = DeskCardsCache.CardType
	local length = DeskCardsCache.CardLength
	local card = DeskCardsCache.GetLibrary()
	--测试用
	-- local weight =  Weight.Three
	-- local cardType = CardsType.TripleStraightAndDouble
	-- local length = 2
	if library == nil then
		library = self.library
		self.SortCard()
	else
		library = CardRule.SortCardsFunc(library)
	end
	local promptCards = {}

	if  OrderCtrl.bigest == CharacterType.Player  then 
		cardType = CardsType.None
	end 

	if cardType == CardsType.None then 
		--一手牌
		local cardlist = CardRule.FirstCard(library)
		promptCards = cardlist
	elseif  cardType ==CardsType.Double then 
		local cardlist =  CardRule.FindDoubleFunc(library,weight,true)
		if #cardlist > 0   then 
			promptCards = cardlist
		else 
			cardlist =  CardRule.FindDoubleFunc(library,weight,false)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		end 
	elseif cardType ==CardsType.Single then 
		local cardlist =  CardRule.FindSingleFunc(library,weight,true)
		if #cardlist > 0   then 
			promptCards = cardlist
		else 
			cardlist =  CardRule.FindSingleFunc(library,weight,false)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		end 
	elseif cardType ==CardsType.OnlyThree then 
		local cardlist =  CardRule.FindOnlyThreeFunc(library,weight)
		if #cardlist > 0   then 
			promptCards = cardlist
		else
			 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end 
	elseif cardType ==CardsType.ThreeAndOne then 
		local cardlist =  CardRule.FindThreeAndOneFunc(library,weight)
		if #cardlist > 0   then 
			promptCards = cardlist
		else
			 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end 
	elseif cardType ==CardsType.ThreeAndTwo then 
		local cardlist =  CardRule.FindThreeAndTwoFunc(library,weight)
		if #cardlist > 0   then 
			promptCards = cardlist
		else
			 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end 
	elseif cardType ==CardsType.Straight then 
		local cardlist =  CardRule.FindStraightFunc(library,weight,length)
		if #cardlist > 0   then 
			promptCards = cardlist
		else
			 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end 
	elseif cardType ==CardsType.DoubleStraight then 
		local cardlist =  CardRule.FindDoubleStraightFunc(library,weight,length)
		if #cardlist > 0   then 
			promptCards = cardlist
		else
			 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end 
	elseif cardType ==CardsType.TripleStraight then 
		local cardlist =  CardRule.FindTripleStraightFunc(library,weight,length)
		if #cardlist > 0   then 
			promptCards = cardlist
		else
			 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end 
	elseif cardType ==CardsType.TripleStraightAndSingle then 
		local cardlist =  CardRule.FindTripleStraightAndSingleFunc(library,weight,length)
		if #cardlist > 0   then 
			promptCards = cardlist
		else
			 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end 
	elseif cardType ==CardsType.TripleStraightAndDouble then 
		local cardlist =  CardRule.FindTripleStraightAndDoubleFunc(library,weight,length)
		if #cardlist > 0   then 
			promptCards = cardlist
		else
			 cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end
	elseif cardType ==CardsType.FourAndSingle then 
		local cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
		if #cardlist > 0 then 
			promptCards = cardlist
		end 
	elseif cardType ==CardsType.FourAndDouble then 
		local cardlist =  CardRule.FindBoomsFunc(library,Weight.None)
		if #cardlist > 0 then 
			promptCards = cardlist
		end 
	elseif cardType == CardsType.JokerBoom then  --王炸
		
	elseif cardType ==CardsType.Boom then 
		local real = true
		for i=1,#card do
			if card[i].oldweight ~= nil and card[i].oldweight ~= Weight.None then
				real = false
				break
			end
		end
		local w = Weight.None
		if real == true then
			w = weight
		end
		local cardlist =  CardRule.FindBoomsFunc(library,w)
		if #cardlist > 0 then 
			promptCards = cardlist
		end 
	end 
	if #promptCards <= 0 and #CardRule.FindChangeCardInCards(library)>0 then
		if  cardType ==CardsType.Double then 
			local cardlist =  CardRule.FindDoubleFuncWithChange(library,weight,true)
			if #cardlist > 0   then 
				promptCards = cardlist
			else 
				cardlist =  CardRule.FindDoubleFuncWithChange(library,weight,false)
				if #cardlist > 0   then 
					promptCards = cardlist
				else
					 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
					if #cardlist > 0 then 
						promptCards = cardlist
					end 
				end 
			end 
		elseif cardType ==CardsType.OnlyThree then 
			local cardlist =  CardRule.FindOnlyThreeFuncWithChange(library,weight)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		elseif cardType ==CardsType.ThreeAndOne then 
			local cardlist =  CardRule.FindThreeAndOneFuncWithChange(library,weight)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		elseif cardType ==CardsType.ThreeAndTwo then 
			local cardlist =  CardRule.FindThreeAndTwoFuncWithChange(library,weight)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		elseif cardType ==CardsType.Straight then 
			local cardlist =  CardRule.FindStraightFuncWithChange(library,length,weight)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		elseif cardType ==CardsType.DoubleStraight then 
			local cardlist =  CardRule.FindDoubleStraightFuncWithChange(library,length,weight)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		elseif cardType ==CardsType.TripleStraight then 
			local cardlist =  CardRule.FindTripleStraightFuncWithChange(library,weight,length)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		elseif cardType ==CardsType.TripleStraightAndSingle then 
			local cardlist =  CardRule.FindTripleStraightAndSingleFuncWithChange(library,weight,length)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end 
		elseif cardType ==CardsType.TripleStraightAndDouble then 
			local cardlist =  CardRule.FindTripleStraightAndDoubleFuncWithChange(library,weight,length)
			if #cardlist > 0   then 
				promptCards = cardlist
			else
				 cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
				if #cardlist > 0 then 
					promptCards = cardlist
				end 
			end
		elseif cardType ==CardsType.FourAndSingle then 
			local cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		elseif cardType ==CardsType.FourAndDouble then 
			local cardlist =  CardRule.FindBoomsFuncWithChange(library,Weight.None)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		elseif cardType == CardsType.JokerBoom then  --王炸
			
		elseif cardType ==CardsType.Boom then 
			--判断炸弹是不是软炸弹
			local real = true
			for i=1,#card do
				if card[i].oldweight ~= nil and card[i].oldweight ~= Weight.None then
					real = false
					break
				end
			end
			if real == false then
				local cardlist =  CardRule.FindBoomsFuncWithChange(library,weight)
				if #cardlist > 0 then 
					promptCards = cardlist
				end
			end
		elseif cardType == CardsType.Single then
			local cardlist =  CardRule.FindBoomsFuncWithChange(library,weight)
			if #cardlist > 0 then 
				promptCards = cardlist
			end 
		end 
	end
	if promptCards~=nil and #promptCards > 0 then 
	 	return true, promptCards
	else 
	 	return false
	end 
	
end 


--检测选中的牌 
function Player.CheckSelectCards()
	self.ClearPrompt() --清除提示

	local selectCards = {} 
	local cards = {}
	for k,cardInfo in pairs(self.CardObjectList) do 
		if cardInfo.Selected == true then 
			table.insert(selectCards,cardInfo)
			table.insert(cards, cardInfo.Card)
		end 
	end 
	--判断是否有癞子
	local changeCard = CardRule.FindChangeCardInCards(cards)
	if #changeCard ~= 0 and #cards>1 then
		--有癞子
		--return self.CheckPlayCards(selectCards,cards)
		return self.CheckPlayCardsWithChange(selectCards,cards)
	else
		--没有癞子
		return self.CheckPlayCards(selectCards,cards)
	end
	
end 

function Player.GetSelectCardsbyCards(cards)
	local returnCards = {}
	for i=1,#cards do
		for k,v in pairs(self.CardObjectList) do
			if v.Card.weight == cards[i].weight and v.Card.suits == cards[i].suits then
				table.insert(returnCards, v)
				break
			end 
		end
	end
	return returnCards
end
--检测选中的牌是否能打并且计算倍数
function Player.CheckPlayCards(cardinfoList,cards)
	local isRule, cardsType, cardLength = CardRule.PopEnable(cards)
	if isRule == true then 
		--if OrderCtrl.bigest == OrderCtrl.currentAuthority then 
		if OrderCtrl.bigest == self.ctype then 
			coroutine.start(self.PlayerCards,cardinfoList,cards, cardsType,cardLength)
			return true
		elseif  DeskCardsCache.CardType == CardsType.None then
			coroutine.start(self.PlayerCards,cardinfoList,cards, cardsType,cardLength)
			return true 
		elseif cardsType == CardsType.JokerBoom then 
			coroutine.start(self.PlayerCards,cardinfoList,cards, cardsType,cardLength)
			return true
		elseif cardsType  == CardsType.Boom and DeskCardsCache.CardType ~= CardsType.Boom and DeskCardsCache.CardType ~= CardsType.JokerBoom then 
			coroutine.start(self.PlayerCards,cardinfoList,cards, cardsType,cardLength)
			return true
		elseif cardsType == DeskCardsCache.CardType and  CardRule.GetWeight(cards, cardsType) > DeskCardsCache.GetWeight()  then 
			if #cards == #DeskCardsCache.GetLibrary() then
				coroutine.start(self.PlayerCards,cardinfoList,cards, cardsType,cardLength)
				return true
			end
		elseif cardType == DeskCardsCache.CardType and DeskCardsCache.CardType == CardsType.Boom then 
			local card = DeskCardsCache.GetLibrary()
			local real = true
			for i=1,#card do
				if card[i].oldweight ~= nil and card[i].oldweight ~= Weight.None then
					real = false
					break
				end
			end
			if real == false then
				coroutine.start(self.PlayerCards,cardinfoList,cards, cardsType,cardLength)
				return true
			end
		end 
	end 
	return false
end 
function Player.CheckPlayCardsWithChange(cardinfoList,cards)
	local allcards = {}
	local rightcards = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	if #changeCard > 0 then
		if #cards == 2 then
			allcards = CardRule.TwoCards(cards)
		elseif #cards == 3 then
			allcards = CardRule.ThreeCards(cards)
		elseif #cards == 4 then
			allcards = CardRule.FourCards(cards)
		elseif #cards == 5 then
			allcards = CardRule.FiveCards(cards)
		elseif #cards >= 6 then
			allcards = CardRule.ChangeFunc(cards)
		end
	end
	if OrderCtrl.bigest == self.ctype or DeskCardsCache.CardType == CardsType.None then
		if #allcards == 1 then
			local isRule, cardsType, cardLength = CardRule.PopEnable(allcards[1])
			coroutine.start(self.PlayerCards,cardinfoList,allcards[1], cardsType,cardLength)
			return true
		elseif #allcards > 1 then
			GamePanel.LZSelect(allcards,cardinfoList)
			return false
		else
			--error("出不了")
		end
	elseif DeskCardsCache.CardType ~= CardsType.Boom then
		for i=1,#allcards do
			local isRule, cardsType, cardLength = CardRule.PopEnable(allcards[i])
			if cardsType == DeskCardsCache.CardType and  CardRule.GetWeight(allcards[i], cardsType) > DeskCardsCache.GetWeight() then
				table.insert(rightcards,clone(allcards[i]))
			elseif cardsType == CardsType.Boom then
				table.insert(rightcards,clone(allcards[i]))
			end
		end
		if #rightcards>0 then
			if #rightcards == 1 then
				local isRule, cardsType, cardLength = CardRule.PopEnable(rightcards[1])
				coroutine.start(self.PlayerCards,cardinfoList,rightcards[1], cardsType,cardLength)
				return true
			else
				GamePanel.LZSelect(rightcards,cardinfoList)
				return false
			end
		else
			--error("没有合适的")
			return false
		end
	elseif DeskCardsCache.CardType == CardType.Boom then
		for i=1,#allcards do
			local isRule, cardsType, cardLength = CardRule.PopEnable(allcards[i])
			if cardsType == CardsType.Boom and  CardRule.GetWeight(allcards[i], cardsType) > DeskCardsCache.GetWeight() then
				local card = DeskCardsCache.GetLibrary()
				local real = true
				for i=1,#card do
					if card[i].oldweight ~= nil and card[i].oldweight ~= Weight.None then
						real = false
						break
					end
				end
				--判断是否是软炸弹
				if real == false then
					table.insert(rightcards,clone(allcards[i]))
				end
			end
		end
	end
	return false

end
--出牌
function Player.PlayerCards(cardinfoList,cards,cardtype,cardLength)
	--播放出牌的音效
	--判断是否要播放大你的音效
	local clip = nil
	local normal = true
	if cardtype==CardsType.OnlyThree or cardtype==CardsType.ThreeAndOne or cardtype==CardsType.ThreeAndTwo or cardtype==CardsType.Straight or cardtype==CardsType.DoubleStraight or cardtype==CardsType.TripleStraight or cardtype==CardsType.TripleStraightAndSingle or cardtype==CardsType.TripleStraightAndDouble or cardtype==CardsType.FourAndSingle or cardtype==CardsType.FourAndDouble then
		if OrderCtrl.bigest ~= CharacterType.Player then --判断大你的牌是否是对方出的
			clip = LRDDZ_SoundManager.OtherHumanSound(self.ctype,"bigger",Avatar.getAvatarSex() == 1); --播放大你音效
			normal = false
		end
	end
	if OrderCtrl.bigest == self.ctype or OrderCtrl.bigest == nil then
		if cardtype == CardsType.Single and cards[1].weight <= Weight.Six then
			normal = false
			clip = LRDDZ_SoundManager.OtherHumanSound(self.ctype,"singlexiao",Avatar.getAvatarSex() == 1); --播放小牌音效
		end
		if cardtype == CardsType.Double and cards[1].weight <= Weight.Six then
			clip = LRDDZ_SoundManager.OtherHumanSound(self.ctype,"doublexiao",Avatar.getAvatarSex() == 1); --播放一对小牌音效
			normal = false
		end
	end
	--播放正常的音效
	if normal == true then
		clip = LRDDZ_SoundManager.PlayHumanSound(self.ctype,cards,cardtype,Avatar.getAvatarSex() == 1)
	end
	local function CheckWarn(_clip)
		local holdNum = self.holdNum
		if _clip ~= nil then
			coroutine.wait(_clip.length + 0.2)
		end
		if GameCtrl.isTuoguan == false then
			Player.CheckWarn(holdNum- #cards)
		else
			Player.CheckWarn(holdNum)
		end
	end
	coroutine.start(CheckWarn,clip)
	OrderCtrl.bigest = self.ctype
	--DeskCardsCache.AllClear() --删除当前桌面UI上对方打的牌
	DeskCardsCache.ClearRecord()
	DeskCardsCache.CardType = cardtype
	DeskCardsCache.CardLength = cardLength
	for i = 1,#cardinfoList do 
		self.PopCard(cardinfoList[i].Card)
		DeskCardsCache.AddCard(cardinfoList[i].Card)
		for j=1,#self.CardObjectList do 
			if self.CardObjectList[j].Card == cardinfoList[i].Card then 
				self.behaviour:MyDestroy(self.CardObjectList[j].GameObject)
				table.remove(self.CardObjectList,j)
				break
			end 
		end 
	end 
	--播放特效
	if cardtype == CardsType.Straight or cardtype == CardsType.DoubleStraight or cardtype == CardsType.DoubleStraight or cardtype == CardsType.TripleStraight
		or cardtype == CardsType.TripleStraightAndSingle or cardtype == CardsType.TripleStraightAndDouble or cardtype == CardsType.Boom then
		ParticleManager.PopCard(self.ctype)
	end
	self.ShowCards() --调整手牌
	GameCtrl.ShowGameText(CharacterType.Player) --显示文字
	
	self.ShowDealCard(cards) --显示出的牌
	--记牌器显示出牌
	
	local function func()
	end 
	-- 出牌动画
	CharacterPlayer.Deal(cards,cardtype,func)
	if GameCtrl.isTuoguan == false then
		--发送打牌消息
		if LRDDZ_Game.matchType ~= DDZGameMatchType.LZMatch then
			LRDDZ_Game:SendPlay(cards);
		else
			local _cards = {}
			local _lz_card = {}
			for i=1,#cards do
				if cards[i].oldweight~=Weight.None then
					local tempcard = clone(cards[i])
					tempcard.weight = tempcard.oldweight
					table.insert(_lz_card,tempcard)
				else
					table.insert(_cards,cards[i])
				end
			end
			LRDDZ_Game:SendLZPlay(_cards,_lz_card,cards)

		end
	end
	--特效
	if cardtype == CardsType.Straight then 		--顺子特效
		coroutine.start(self.PlayCardTypeName,cardtype) --显示UI字
		coroutine.wait(0.5)
		--[[
		if Avatar.avatarSex == 1 then --如果角色是男
			ParticleManager.ShowParticle("Particle", "shunzinan",Vector3.New(1,1,1),Vector3.New(15.5,19,10.1),Vector3.New(-90,169.0966,0),3)
		else --如果角色是女
			ParticleManager.ShowParticle("Particle", "shunzinv",Vector3.New(1,1,1),Vector3.New(15.5,19,10.1),Vector3.New(-90,169.0966,0),3)
		end		
		]]														
		LRDDZ_SoundManager.PlaySoundEffect("straight")											
		coroutine.wait(0.5)
	elseif cardtype == CardsType.DoubleStraight then 	--连对特效	
		coroutine.start(self.PlayCardTypeName,cardtype) --显示UI字
		coroutine.wait(0.5)
		--[[
		if Avatar.avatarSex == 1 then --如果角色是男
			ParticleManager.ShowParticle("Particle", "lianduinan",Vector3.New(1,1,1),Vector3.New(15.5,19,10.1),Vector3.New(-90,169.0966,0),3)
		else --如果角色是女
			ParticleManager.ShowParticle("Particle", "lianduinv",Vector3.New(1,1,1),Vector3.New(15.5,19,10.1),Vector3.New(-90,169.0966,0),3)
		end	
		]]			
		LRDDZ_SoundManager.PlaySoundEffect("straight")
		coroutine.wait(0.5)
	elseif  cardtype == CardsType.Single then 
		if cards[1].weight ==  Weight.SJoker then 																--小王特效
			coroutine.wait(0.4)--手部动作等待时间
			LRDDZ_SoundManager.PlaySoundEffect("getCoin")
			ParticleManager.ShowParticle("Particle", "xiaogui",Vector3.New(1,1,1),Vector3.New(5.5,24.4,13.5),Vector3.New(0,0,0),2)
			coroutine.wait(0.8)--等待特效播放完再判断输赢
		elseif cards[1].weight ==  Weight.LJoker then 															--大王特效
			coroutine.wait(0.4)--手部动作等待时间
			LRDDZ_SoundManager.PlaySoundEffect("getCoin")
			ParticleManager.ShowParticle("Particle", "dagui",Vector3.New(1,1,1),Vector3.New(5.5,24.4,13.5),Vector3.New(0,0,0),2)
			coroutine.wait(0.8)--等待特效播放完再判断输赢
		end
	elseif cardtype == CardsType.TripleStraightAndSingle or cardtype == CardsType.TripleStraightAndDouble then--飞机特效
		ParticleManager.PlaneFly(CharacterType.Player)
		coroutine.start(self.PlayCardTypeName,cardtype) --显示UI字
		coroutine.wait(1.2)--等待特效播放完再判断输赢
	elseif cardtype == CardsType.Boom then 																		--炸弹特效
		ParticleManager.Boom(CharacterType.Player)
		coroutine.start(self.PlayCardTypeName,cardtype) --显示UI字
		coroutine.wait(1.1)--等待炸弹特效完成后显示字时间
		if MyCommon.GetGameEffState() == 1 then
			coroutine.wait(1.2)--等待特效播放完再判断输赢
		end
	elseif cardtype == CardsType.JokerBoom then 																--王炸特效
		--coroutine.wait(1.2)--手部动作等待时间
		ParticleManager.JokerBoom(CharacterType.Player)
		if MyCommon.GetGameEffState() == 1 then
			coroutine.wait(1.2)--等待特效播放完再判断输赢
		end
	end 
	coroutine.wait(0.8)--打完牌的延迟时间
	
	
end 

function Player.TuoguanFunc()
	coroutine.start(self.Tuoguan)
end 
--托管
function Player.Tuoguan()
	if self.PromptPlayCards() then 
		coroutine.wait(1)
		if  self.CheckSelectCards() then 
			--OrderCtrl.TurnPlay() --下一个出牌
		else
			self.DisPlayCard()
		end 
	else 
		self.ShowNotice(GameText.DisPlay)
		coroutine.wait(1)
		self.DisPlayCard()
	end 
end 
 --不出牌
function  Player.DisPlayCard()
    
    --GamePanel.DiscardCallBack()--调用不出按钮回调
    self.CancelSelcted()
	self.ShowNotice(GameText.DisPlay)
	self.ClearPrompt() --清空提示
end 


function Player.ShowDealCard(cards)
	EginTools.ClearChildren(self.PlacePoint.transform)
	cards = CardRule.SortCardsFunc(cards,true) --降序排序
	local count = #cards
	for i = 1, #cards do 
		if self.DealCardObjList[i]== nil then 
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","dealCard",false)
			obj.transform.parent = self.PlacePoint.transform;
			obj:GetComponent("UISprite"):MakePixelPerfect()
			obj.transform.localScale = Vector3.New(1,1,1);
			--obj.transform.localPosition =Vector3.New((i-1)*30 ,0,0) --(i-count/2)*30 
			obj.transform.localPosition =Vector3.New(0,0,0) --(i-count/2)*30 

			table.insert(self.DealCardObjList,obj)
		end 
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


--
function Player.ShowNotice(str)
	self.Notice:SetActive(true)
	self.Notice.transform:GetComponent("UISprite").spriteName = str
	if str ~= "" then
		self.Notice:GetComponent("UISprite"):MakePixelPerfect()
	end
end 

function Player.HidenNotice()
	self.Notice:SetActive(false)

end
--是否可点击
function Player.EnableTouchCards(isTouch)
	self.isCanSelected = isTouch
end 

function Player.SetColorForCard(setcolor,cantouchCard)
	for i=1, #self.CardObjectList do
		if   setcolor == true then 
			self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(124/255, 124/255, 124/255, 1)
		else 
			self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(1, 1, 1, 1)
		end 
	end 
	self.EnableTouchCards(cantouchCard)
end 
function Player.PlayCardTypeName(cardstype)
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
	self.minCardtypename.transform.localPosition = Vector3.New(-100,-230,0);
	self.minCardtypename.transform.localScale = Vector3.one
	iTween.MoveTo(self.minCardtypename, iTween.Hash("x",150, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.linear));
	coroutine.wait(0.5)
	iTween.ScaleTo(self.minCardtypename,iTween.Hash("scale", Vector3.New(1.5,1.5,1.5), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeInOutBack))

	coroutine.wait(0.3)
	self.cardtypename:SetActive(true)
	

	coroutine.wait(0.3)
	self.cardtypename:SetActive(false)
	coroutine.wait(0.7)
	self.minCardtypename:SetActive(false)
end
function Player.SelectTwoCard(selectedCards)
	--是否两张不同的牌
	if selectedCards[1].weight == selectedCards[2].weight then return end
	local straight = CardRule.FindStraightInSelectCard(self.library,selectedCards); --顺子
	local doubleStraight = CardRule.FindDoubleStraightInSelectCard(self.library,selectedCards); --连对
	local threelist = CardRule.FindThreeInSelectCard( self.library,selectedCards);	--选中牌中，三条的数量
	local autoSelect = {};
	--是否有三带一（对）
	if #threelist > 0 then --有三条
		--是否有顺子,连对,飞机
		if #straight > 0 or #doubleStraight > 0 or #threelist >= 2 then 
			--不匹配
			--3带有顺子和连对不匹配
		else
			print("匹配3带1或带双");
			for i=1,#(threelist[1][1])do
				table.insert(autoSelect,threelist[1][1][i]);
			end
		end
	else
		--没3条,判断是否有顺子
		if #straight > 0 then 
			--有顺子
			if #doubleStraight > 0 or #threelist >= 2 or # doubleStraight > 0 then--判断是否有连对、飞机
				--有，不匹配
				--顺子有连对、飞机，不匹配
			else
				--匹配顺子
				for i=1,#(straight[1]) do
					print(straight[1][i].weight)
					if CardRule.CardWeightContains(selectedCards,straight[1][i]) == false then
						table.insert(autoSelect,straight[1][i]);
					end
				end
			end
		else
			--没有顺子，判断是否有飞机
			if #threelist >= 2 then
				--有飞机，判断是否有连对
				if #doubleStraight > 0 then
					--有连对，不匹配
					--飞机有连对，不匹配
				else
					--没连对，匹配飞机
					for i=1,#threelist do
						for j=1,#threelist[i] do
							table.insert(autoSelect,threelist[i][j]);
						end
					end
				end
			else
				--没有飞机，判断有没连对
				if #doubleStraight > 0 then
					--有连对，匹配
					--全部添加
					for i=1,#(doubleStraight[1]) do
						table.insert(autoSelect,doubleStraight[1][i]);
					end
					--过滤
				else
					--没有。不匹配
				end

			end
		end
	end
	--弹出自动选择的牌
	for i=1,#autoSelect do
		for j=1,#self.CardObjectList do
			if autoSelect[i].weight == self.CardObjectList[j].Card.weight and autoSelect[i].suits == self.CardObjectList[j].Card.suits then
				if self.CardObjectList[j].Selected  == false then
					self.CardObjectList[j].Selected = true;
					self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(self.CardObjectList[j].GameObject.transform.localPosition.x,0 + 20 , self.CardObjectList[j].GameObject.transform.localPosition.z)
				end
				break;
			end
		end
	end

end
--三张牌的智能选牌
function Player.SelectThreeCard(selectedCards)
	if #selectedCards ~= 3 then return end;
	local autoSelect = {};--智能选出的牌

	local straight = CardRule.FindStraightInSelectCard(self.library,selectedCards); --顺子
	local doubleStraight = CardRule.FindDoubleStraightInSelectCard(self.library,selectedCards); --连对
	local threelist = CardRule.FindThreeInSelectCard( self.library,selectedCards);	--选中牌中，三条的数量

	--判断三张牌是否相同
	if selectedCards[1].weight == selectedCards[2].weight and selectedCards[1].weight == selectedCards[3].weight then
		--3张相同，判断是否有四条
		if CardRule.FindBoomsByWeight(self.library,selectedCards[1].weight) ~= nil then
			--有炸弹 匹配炸弹
			autoSelect = CardRule.FindBoomsByWeight(self.library,selectedCards[1].weight);
		else
			--没炸弹，不匹配
		end
	else
		--三张牌不相同 判断是否有两张相同
		if selectedCards[1].weight == selectedCards[2].weight or selectedCards[1].weight == selectedCards[3].weight or selectedCards[2].weight == selectedCards[3].weight then
			--三张牌两张相同 判断是有三带一
			if #threelist > 0 then
				--有三条 ，判断是否有飞机 连对
				if #threelist >= 2 or #doubleStraight > 0 then
					--三条 有飞机、连对 不匹配
				else
					--匹配三带一
					for i=1,#(threelist[1][1])do
					table.insert(autoSelect,threelist[1][1][i]);
					end
				end
			else
				--没三条,判断是否有连对
				if #doubleStraight > 0 then
					--有连对 匹配连对
					--全部添加
					for i=1,#(doubleStraight[1]) do
						table.insert(autoSelect,doubleStraight[1][i]);
					end
					--过滤
				end
			end
		else
			--三张牌完全不一样 判断是否有顺子
			if #straight > 0 then
				--有顺子，判断是否有连对，飞机
				if #doubleStraight > 0 or #threelist >= 2 then
					--有飞机或连对 不匹配
				else
					--没有连对 飞机，匹配顺子
					for i=1,#(straight[1]) do
						print(straight[1][i].weight)
						if CardRule.CardWeightContains(selectedCards,straight[1][i]) == false then
							table.insert(autoSelect,straight[1][i]);
						end
					end
				end
			else
				--没有顺子 判断是否有飞机
				if #threelist >= 2 then
					--有飞机，判断是否有连对
					if #doubleStraight > 0 then
						--有连对，不匹配
					else
						--匹配飞机
						for i=1,#threelist do
							for j=1,#threelist[i] do
								table.insert(autoSelect,threelist[i][j]);
							end
						end
					end
				else
					--没飞机，判断是否有连对
					if #doubleStraight > 0 then
						--匹配连对
						--全部添加
						for i=1,#(doubleStraight[1]) do
							table.insert(autoSelect,doubleStraight[1][i]);
						end
						--过滤
					end
				end
			end
		end
	end
	--弹出自动选择的牌
	for i=1,#autoSelect do
		for j=1,#self.CardObjectList do
			if autoSelect[i].weight == self.CardObjectList[j].Card.weight and autoSelect[i].suits == self.CardObjectList[j].Card.suits then
				if self.CardObjectList[j].Selected  == false then
					self.CardObjectList[j].Selected = true;
					self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(self.CardObjectList[j].GameObject.transform.localPosition.x,0+ 20 , self.CardObjectList[j].GameObject.transform.localPosition.z)
				end
				break;
			end
		end
	end
end
--四张牌智能选牌
function Player.SelectFourCard(selectedCards)
	if #selectedCards ~= 4 then return end;
	local autoSelect = {};--智能选出的牌
	local straight = CardRule.FindStraightInSelectCard(self.library,selectedCards); --顺子
	local doubleStraight = CardRule.FindDoubleStraightInSelectCard(self.library,selectedCards); --连对
	local threelist = CardRule.FindThreeInSelectCard( self.library,selectedCards);	--选中牌中，三条的数量


	if CardRule.IsBoom(selectedCards) == true then
		--炸弹 不匹配
	else
		--判断是否有三张相同 也就是是否三带一
		if CardRule.IsThreeAndOne(selectedCards) == true then
			--三带一，不匹配
		else
			--不是三带一 判断是否有两张相同
			local splits = CardRule.SplitCardsFunc(selectedCards);
			local hasDouble = false;
			for i=1,#splits do
				if splits[1].count == 2 then
					hasDouble = true;
					break;
				end
			end
			if hasDouble == true then
				--四张牌有两张相同 判断是否有连对且有飞机
				if #doubleStraight>0 and #threelist >=2 then
					--有连对且有飞机，不匹配
				else
					--判断是否有连对
					if #doubleStraight>0 then
						--有连对，直接匹配连对
						--全部添加
						for i=1,#(doubleStraight[1]) do
							table.insert(autoSelect,doubleStraight[1][i]);
						end
						--过滤
					else
						--没连对，判断是否有飞机
						if #threelist >= 2 then
							--有飞机
							for i=1,#threelist do
								for j=1,#threelist[i] do
									table.insert(autoSelect,threelist[i][j]);
								end
							end
						end
					end
				end
			else
				--四张牌，没有两张相同的 判断是否有顺子	
				if #straight > 0 then
					--有顺子 判断是否有飞机或连对
					if #doubleStraight > 0 or #threelist >= 2 then
						--有连对或有飞机，不匹配
					else
						--匹配顺子
						for i=1,#(straight[1]) do
							print(straight[1][i].weight)
							if CardRule.CardWeightContains(selectedCards,straight[1][i]) == false then
								table.insert(autoSelect,straight[1][i]);
							end
						end
					end
				else
					--没有顺子 判断是否只有连对
					if #doubleStraight > 0 and #threelist < 2 then
						--有连对 匹配连对
						--全部添加
						for i=1,#(doubleStraight[1]) do
							table.insert(autoSelect,doubleStraight[1][i]);
						end
						--过滤
					else
						--判断是否只有飞机
						if #threelist >= 2 and #doubleStraight == 0 then
							for i=1,#threelist do
								for j=1,#threelist[i] do
									table.insert(autoSelect,threelist[i][j]);
								end
							end
						else
							--连对飞机没有或都有
						end
					end
				end
			end
		end
	end
	--弹出自动选择的牌
	for i=1,#autoSelect do
		for j=1,#self.CardObjectList do
			if autoSelect[i].weight == self.CardObjectList[j].Card.weight and autoSelect[i].suits == self.CardObjectList[j].Card.suits then
				if self.CardObjectList[j].Selected  == false then
					self.CardObjectList[j].Selected = true;
					self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(self.CardObjectList[j].GameObject.transform.localPosition.x,0+ 20 , self.CardObjectList[j].GameObject.transform.localPosition.z)
				end
				break;
			end
		end
	end
end
--5张牌以上的智能选牌
function Player.SelectFiveCard(selectedCards)
	if #selectedCards < 5 then return end;
	local autoSelect = {};--智能选出的牌
	local straight = CardRule.FindStraightInSelectCard(self.library,selectedCards); --顺子
	local doubleStraight = CardRule.FindDoubleStraightInSelectCard(self.library,selectedCards); --连对
	local threelist = CardRule.FindThreeInSelectCard( self.library,selectedCards);	--选中牌中，三条的数量
	--判断是否有两张相同的牌
	local splits = CardRule.SplitCardsFunc(selectedCards);
	local hasDouble = false;
	for i=1,#splits do
		if splits[1].count >= 2 then
			hasDouble = true;
			break;
		end
	end
	if hasDouble == false then
		--5张牌都不一样 判断是否有顺子
		if #straight > 0 then
			--有顺子 判断是否有飞机或连对
			if #doubleStraight > 0 or #threelist >=2 then
				--有连对或飞机，顺子不匹配
			else
				--匹配顺子
				for i=1,#(straight[1]) do
					if CardRule.CardWeightContains(selectedCards,straight[1][i]) == false then
						table.insert(autoSelect,straight[1][i]);
					end
				end
			end
		else
			--没有顺子 判断是否有只有连对
			if #doubleStraight > 0 and #threelist < 2 then
				--匹配连对
				--全部添加
				for i=1,#(doubleStraight[1]) do
					table.insert(autoSelect,doubleStraight[1][i]);
				end
				--过滤
			else
				--判断是否只有飞机
				if #doubleStraight == 0 and #threelist >= 2 then
					for i=1,#threelist do
						for j=1,#threelist[i] do
							table.insert(autoSelect,threelist[i][j]);
						end
					end
				else
					print("不匹配")
				end
			end
		end
	else
		--有相同的牌 判断是否只有连对
		if #doubleStraight > 0 and #threelist < 2 then
				--匹配连对
				--全部添加
				for i=1,#(doubleStraight[1]) do
					table.insert(autoSelect,doubleStraight[1][i]);
				end
				--过滤
		else
			--判断是否只有飞机
			if #doubleStraight == 0 and #threelist >= 2 then
				--匹配飞机
				for i=1,#threelist do
					for j=1,#threelist[i] do
						table.insert(autoSelect,threelist[i][j]);
					end
				end
			else
				print("不匹配")
			end
		end
	end
	for i=1,#autoSelect do
		for j=1,#self.CardObjectList do
			if autoSelect[i].weight == self.CardObjectList[j].Card.weight and autoSelect[i].suits == self.CardObjectList[j].Card.suits then
				if self.CardObjectList[j].Selected  == false then
					self.CardObjectList[j].Selected = true;
					self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(self.CardObjectList[j].GameObject.transform.localPosition.x,0+20 , self.CardObjectList[j].GameObject.transform.localPosition.z)
				end
				break;
			end
		end
	end
end

--弹出自动选择的牌
function Player.SelectedMoreCards(selectedCards)
	
	if CardRule.IsDoubleStraight(selectedCards) == true then return end --所选的牌是连对
	if #selectedCards >= 5 then
		local autoSelect = {}
		--判断是否有顺子
		local straight = {};
		for i = 10,5,-1 do 
			straight = CardRule.FindStraightByLengthFunc(selectedCards,i)
			if straight~= nil and  #straight > 0 then
				autoSelect = straight[1];
				break;
			end 
		end 
		--
		--取消自动选牌以外的牌
		if(#autoSelect > 0) then
			for j=1,#self.CardObjectList do 
				if tableContains(autoSelect,self.CardObjectList[j].Card) == false and self.CardObjectList[j].Selected  == true then
					self.CardObjectList[j].Selected  = false;
					local pos = self.CardObjectList[j].GameObject.transform.localPosition;
						self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(pos.x,pos.y - 20 , pos.z)
				end
			end
		end
	end
end
--根据对家打的牌自动匹配 --划牌
function Player.SelectedMoreCardsByLast(selectedCards)
	print("SelectedMoreCardsByLast")
	if #DeskCardsCache.library == 0 then return end
	local cardtype = DeskCardsCache.CardType
	--单张 或一对不自动匹配
	if cardtype == CardsType.Double or cardtype == CardsType.Single then
		return
	end
	local isCan,promptCards = self.CheckCanPlay(selectedCards)
	if isCan == true then 
		local autoSelect = {}
		self.SetColorForCard(false,true)
	 	if #promptCards > 0 then --如果提示牌种数大于0，显示提示牌
	 		autoSelect = promptCards[1]
		end
		print("autoSelect"..#autoSelect)
		--[[
		if #autoSelect > 0 then
		--取消自动选牌以外的牌
			for j=1,#self.CardObjectList do 
				if tableContains(autoSelect,self.CardObjectList[j].Card) == false and self.CardObjectList[j].Selected  == true then
					self.CardObjectList[j].Selected  = false;
					local pos = self.CardObjectList[j].GameObject.transform.localPosition;
						self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(pos.x,pos.y - 20 , pos.z)
				end
			end
		end
		]]
		for j=1,#self.CardObjectList do
			local has = false
			for i=1,#autoSelect do
				if autoSelect[i].weight == self.CardObjectList[j].Card.weight and autoSelect[i].suits == self.CardObjectList[j].Card.suits then
					has = true
					break
				end
			end
			if has == false and self.CardObjectList[j].Selected == true then
				self.CardObjectList[j].Selected  = false;
				local pos = self.CardObjectList[j].GameObject.transform.localPosition;
				self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(pos.x,0 , pos.z)
			end
		end
	end
end
--根据对家打的牌自动匹配
function Player.SelectedCardsByLast(card)
	print("根据对家打的牌自动匹配")
	if #DeskCardsCache.library == 0 then return end
	local weight =  DeskCardsCache.GetWeight()
	local cardType = DeskCardsCache.CardType
	local length = DeskCardsCache.CardLength

	self.SortCard()
	local autoSelect = {}
	if  cardType ==CardsType.Double then 
		if card.weight <= weight then return end
		local temp = CardRule.FindDoubleEqualFunc(self.library,card.weight,false)
		if #temp == 0 then return end
		table.insert(autoSelect,card)
		for i=1,#temp[1] do
			if temp[1][i].suits ~= card.suits then
				table.insert(autoSelect,temp[1][i])
				break
			end
		end
	elseif cardType ==CardsType.OnlyThree then
		if card.weight <= weight then return end
		local temp = CardRule.FindOnlyThreeEqualFunc(self.library,card.weight)
		if #temp == 0 then return end
		table.insert(autoSelect,card)
		for i=1,#temp[1] do
			if temp[1][i].suits ~= card.suits then
				table.insert(autoSelect,temp[1][i])
				if #autoSelect == 3 then break end
			end
		end
	elseif cardType == CardsType.ThreeAndOne then
		local temp = CardRule.FindOnlyThreeEqualFunc(self.library,card.weight)
		if card.weight <= weight or #temp == 0 then 
			--所选的牌为单张
			table.insert(autoSelect,card)
			temp = CardRule.FindOnlyThreeFunc(self.library,weight)
			if #temp > 0 then
				for i=1,#temp[1] do
					table.insert(autoSelect,temp[1][i])
				end
			else
				return
			end 
		else
			--所选的牌有三张且比weight大
			table.insert(autoSelect,card)
			for i=1,#temp[1] do
				if temp[1][i].suits ~= card.suits then
					table.insert(autoSelect,temp[1][i])
					if #autoSelect == 3 then break end
				end
			end
			--再选出一张单张的
			local temp =  CardRule.FindSingleFunc(self.library,Weight.None,true)
			if #temp > 0   then 
				table.insert(autoSelect,temp[1][1])
			else 
				temp =  CardRule.FindSingleFunc(self.library,Weight.None,false)
				if #temp > 0   then 
					table.insert(autoSelect,temp[1][1])
				else
					return
				end 
			end 
		end
	elseif cardType ==CardsType.ThreeAndTwo then --3带1对
		local temp = CardRule.FindOnlyThreeEqualFunc(self.library,card.weight)
		--判断选中的牌是否符合要求的3张
		if card.weight <= weight or #temp == 0 then 
			--判断是否有两张

			temp = CardRule.FindDoubleEqualFunc(self.library,card.weight,false)
			if #temp > 0 then
				table.insert(autoSelect,card)
				--添加两张牌到autoSelect
				for i=1,#temp[1] do
					if temp[1][i].suits ~= card.weight then
						table.insert(autoSelect,temp[1][i])
						break
					end
				end
				--找三条
				temp = CardRule.FindOnlyThreeFunc(self.library,card.weight)
				if #temp > 0 then
					--添加三条进去
					table.insert(autoSelect,temp[1][1]);
					table.insert(autoSelect,temp[1][2]);
					table.insert(autoSelect,temp[1][3]);
				else
					return
				end
			else
				return
			end
		else
			--所选牌作为三条
			table.insert(autoSelect,card)
			for i=1,#temp[1] do
				if temp[1][i].suits ~= card.suits then
					table.insert(autoSelect,temp[1][i])
					if #autoSelect == 3 then break end
				end
			end
			--找一对
			temp = CardRule.FindDoubleFunc(self.library, Weight.None, true)
			if #temp == 0 then
				temp = CardRule.FindDoubleFunc(self.library, Weight.None, false)
				for i=1,#temp do
					if temp[i][1].weight ~= card.weight then
						table.insert(autoSelect,temp[i][1])
						table.insert(autoSelect,temp[i][2])
						break
					end
				end
			else
				table.insert(autoSelect,temp[1][1])
				table.insert(autoSelect,temp[1][2])
			end
			if #autoSelect ~= 5 then return end
		end
	elseif cardType ==CardsType.Straight then --顺子
		local temp =  CardRule.FindStraightByLengthFunc(self.library,length,weight+1)
		for i=1,#temp do
			for j=1,#temp[i] do
			end
			if CardRule.CardWeightContains(temp[i],card) == true then
				table.insert(autoSelect,card)
				for j=1,#temp[i] do
					if card.weight ~= temp[i][j].weight then
						table.insert(autoSelect,temp[i][j])
					end
				end
				break;
			end
		end
		if #autoSelect == 0 then return end
	elseif cardType ==CardsType.DoubleStraight then 
		local temp =  CardRule.FindDoubleStraightFunc(self.library,weight,length)
		for i=1,#temp do
			if CardRule.CardWeightContains(temp[i],card) == true then
				table.insert(autoSelect,card)
				local hasSameWeight = false
				for j=1,#temp[i] do
					if card.weight == temp[i][j].weight then
						if card.suits ~= temp[i][j].suits and hasSameWeight == false then
							table.insert(autoSelect,temp[i][j])
							hasSameWeight = true
						end
					else
						table.insert(autoSelect,temp[i][j])
					end

				end
				break
			end
		end
		if #autoSelect == 0 then return end
	elseif cardType ==CardsType.TripleStraight then
		local temp = CardRule.FindTripleStraightFunc(self.library,weight,length)
		for i=1,#temp do
			if CardRule.CardWeightContains(temp[i],card) == true then
				table.insert(autoSelect,card)
				local sameWeight = 0
				for j=1,#temp[i] do
					if card.weight == temp[i][j].weight then
						if card.suits ~= temp[i][j].suits and sameWeight < 2 then
							table.insert(autoSelect,temp[i][j])
							sameWeight = sameWeight + 1
						end
					else
						table.insert(autoSelect,temp[i][j])
					end
				end
				break
			end
		end
		if #autoSelect == 0 then return end
	elseif cardType ==CardsType.TripleStraightAndSingle then
		local temp = CardRule.FindTripleStraightFunc(self.library,weight,length)
		local hasCard = false
		if #temp == 0 then return end
		for i=1,#temp do
			if CardRule.CardWeightContains(temp[i],card) == true then
				hasCard = true
				--加进autoSelect
				table.insert(autoSelect,card)
				local sameWeight = 0
				for j=1,#temp[i] do
					if card.weight == temp[i][j].weight then
						if card.suits ~= temp[i][j].suits and sameWeight < 2 then
							table.insert(autoSelect,temp[i][j])
							sameWeight = sameWeight + 1
						end
					else
						table.insert(autoSelect,temp[i][j])
					end
				end
				break
			end
		end
		if hasCard == true then
			--找length张单张
			temp = CardRule.FindSingleFunc(self.library, Weight.None, true)
			local singleNum = 0;
			for i=1,#temp do
				singleNum = i
				table.insert(autoSelect,temp[i][1])
				if i == length then
					break
				end
			end
			if singleNum < length then
				temp = CardRule.FindSingleFunc(self.library, Weight.None, false)
				--排除
				if #temp < length then return end
				for i=1,length-singleNum do
					for j=1,#autoSelect do
						if autoSelect[j].weight ~= temp[i][1] then
							table.insert(autoSelect,temp[i][1])
							singleNum = singleNum + 1
							break
						end
					end
				end
				if singleNum ~= length then return end
			end 
		else
			--所选择的card作为单张,再找不为card的(length-1)张单张
			table.insert(autoSelect,card)
			local singleNum = 1;
			temp = CardRule.FindSingleFunc(self.library, Weight.None, true)
			for i=1,#temp do
				if temp[i][1].weight ~= card.weight then
					singleNum = singleNum + 1
					table.insert(autoSelect,temp[i][1])
				end
				if singleNum == length then
					break
				end
			end
			if singleNum < length then
				temp = CardRule.FindSingleFunc(self.library, Weight.None, false)
				for i=1,#temp do
					if CardRule.CardWeightContains(autoSelect,temp[i][1]) == false then
						table.insert(autoSelect,temp[i][1])
						singleNum = singleNum + 1 
						if singleNum == length then break end
					end
				end
			end
			if singleNum < length then return end
		end
	elseif cardType ==CardsType.TripleStraightAndDouble then 
		local temp = CardRule.FindTripleStraightFunc(self.library,weight,length)
		if #temp == 0 then return end 
		local hasCard = false
		for i=1,#temp do
			if CardRule.CardWeightContains(temp[i],card) == true then
				hasCard = true
				--加进autoSelect
				table.insert(autoSelect,card)
				local sameWeight = 0
				for j=1,#temp[i] do
					if card.weight == temp[i][j].weight then
						if card.suits ~= temp[i][j].suits and sameWeight < 2 then
							table.insert(autoSelect,temp[i][j])
							sameWeight = sameWeight + 1
						end
					else
						table.insert(autoSelect,temp[i][j])
					end
				end
				break
			end
		end

		if hasCard == true then
			--找length对
			temp = CardRule.FindDoubleFunc(self.library, Weight.None, true)
			local singleNum = 0;
			for i=1,#temp do
				singleNum = i
				table.insert(autoSelect,temp[i][1])
				if i == length then
					break
				end
			end
			if singleNum < length then
				temp = CardRule.FindDoubleFunc(self.library, Weight.None, false)
				--排除
				if #temp < length then return end
				for i=1,length-singleNum do
					for j=1,#autoSelect do
						if autoSelect[j].weight ~= temp[i][1] then
							table.insert(autoSelect,temp[i][1])
							singleNum = singleNum + 1
							break
						end
					end
				end
				if singleNum ~= length then return end
			end 
		else
			--所选择的card作为一对,再找不为card的(length-1)对
			temp = CardRule.FindDoubleEqualFunc(self.library, card.weight, false)
			if temp == 0 then return end
			for i=1,#temp do
				if temp[i][1].suits ~= card.suits then
					table.insert(autoSelect,temp[i][1])
					break
				end
			end
			table.insert(autoSelect,card)

			local singleNum = 1;
			temp = CardRule.FindDoubleFunc(self.library, Weight.None, true)
			for i=1,#temp do
				if temp[i][1].weight ~= card.weight then
					singleNum = singleNum + 1
					table.insert(autoSelect,temp[i][1])
					table.insert(autoSelect,temp[i][2])
				end
				if singleNum == length then
					break
				end
			end
			if singleNum < length then
				temp = CardRule.FindDoubleFunc(self.library, Weight.None, false)
				for i=1,#temp do
					if CardRule.CardWeightContains(autoSelect,temp[i][1]) == false then
						table.insert(autoSelect,temp[i][1])
						table.insert(autoSelect,temp[i][2])
						singleNum = singleNum + 1 
						if singleNum == length then break end
					end
				end
			end
			if singleNum < length then return end
		end
	elseif cardType ==CardsType.FourAndSingle then --四带两张单
	elseif cardType ==CardsType.FourAndDouble then --四带两对
	--elseif cardType == CardsType.JokerBoom then  --王炸
	elseif cardType ==CardsType.Boom  then 
		local temp =  CardRule.FindBoomsFunc(self.library,weight)
		local hasCard = false
		for i=1,#temp do
			if CardRule.CardWeightContains(temp[i],card) == true then
				hasCard = true
				for j=1,#temp[i] do
					table.insert(autoSelect,temp[i][j])
				end
				break
			end
		end
		if hasCard == false then return end
	end 
	for i=1,#autoSelect do
		for j=1,#self.CardObjectList do
			if autoSelect[i].weight == self.CardObjectList[j].Card.weight and autoSelect[i].suits == self.CardObjectList[j].Card.suits then
				if self.CardObjectList[j].Selected  == false then
					self.CardObjectList[j].Selected = true;
					self.CardObjectList[j].GameObject.transform.localPosition =Vector3.New(self.CardObjectList[j].GameObject.transform.localPosition.x,0+ 20 , self.CardObjectList[j].GameObject.transform.localPosition.z)
				end
				break;
			end
		end
	end
end
--判断是否最后一手牌，能不能自动打出
function Player.LastOneHand()
	local allselected = true
	local cards = {}
	local cardinfoList = {}
	for i=1,#self.CardObjectList do
		if self.CardObjectList[i].Selected == false then
			allselected = false
			break
		else
			table.insert(cardinfoList,self.CardObjectList[i])
			table.insert(cards, self.CardObjectList[i].Card)
		end
	end
	if allselected == false then return end
	if GamePanel.play.gameObject.activeSelf == true then


		local changeCard = CardRule.FindChangeCardInCards(cards)
		if #changeCard ~= 0 and #cards>1 then
			
		else
			--没有癞子
			if Player.CheckPlayCards(cardinfoList,cards) then
				GamePanel.ActivePlay(false)
			end
		end

		--[[
		if Player.CheckPlayCards(cardinfoList,cards) then
	 		GamePanel.ActivePlay(false)
		end
		]]
	end
end
local talkCne = nil
local talkcontent = require "GameLRDDZ.config.TalkContent"
function Player.Talk(talkid)
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


