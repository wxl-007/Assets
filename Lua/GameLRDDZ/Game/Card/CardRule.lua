require "GameLRDDZ.Game.Card.Card"
require "GameLRDDZ.Game.Type"
CardRule = {}

--卡牌数组排序
--descending == true  降序
function  CardRule.SortCardsFunc(cardList,descending)
	local function sortFunc(card1,card2)
		if card1.weight == card2.weight then
			return card1.suits >  card2.suits
		else 
			if descending == true then 
				return card1.weight > card2.weight
			else 
				return card1.weight < card2.weight
			end 
		end 
	end 
	table.sort( cardList, sortFunc)
	return cardList
end 
function CardRule.SortCardsWithChangeFunc(cardList,descending)
	local function sortFunc(card1,card2)
		if card1.weight == card2.weight then
			return card1.suits >  card2.suits
		elseif card1.weight == GameCtrl.changeCardWeight then
			return true
		elseif card2.weight == GameCtrl.changeCardWeight then
			return false
		else		
			if descending == true then 
				return card1.weight > card2.weight
			else 
				return card1.weight < card2.weight
			end 
		end 
	end 
	table.sort( cardList, sortFunc)
	return cardList
end

--卡牌数组拆分牌型
function CardRule.SplitCardsFunc(cardList)
	cardList = CardRule.SortCardsFunc(cardList)

	local SplitCardList = {}
	for i = 1, #cardList do 
		if i == 1 then
			local splitcard = SplitCards.New()
			splitcard.weight = cardList[i].weight
			splitcard.count = 1
			table.insert(splitcard.cards, cardList[i])

			table.insert(SplitCardList,splitcard)
		else
			local isAdd = false
			for j = 1 , #SplitCardList do 

				if SplitCardList[j].weight == cardList[i].weight then 
					SplitCardList[j].count = SplitCardList[j].count + 1
					table.insert(SplitCardList[j].cards, cardList[i])
					isAdd = true
					break
				end 
			end 
			if isAdd == false then 
				local splitcard = SplitCards.New()
				splitcard.weight = cardList[i].weight
				splitcard.count = 1
				table.insert(splitcard.cards, cardList[i])

				table.insert(SplitCardList,splitcard)
			end 
		end 

	end 
	return SplitCardList
end 
-----------------------------------------------------------------------------------------------------------------------------------------
---判断牌型

--是否是炸弹
function CardRule.IsBoom(cards)
	if type(cards) ~= "table" or  #cards ~= 4 then 
		return false 
	end 
	local splits = CardRule.SplitCardsFunc(cards)
	if #splits == 1 and splits[1].count == 4 then 
		return true
	end 
	return false
end 
--是否是王炸
function CardRule.IsJokerBoom(cards)
	if type(cards) ~= "table" or  #cards ~= 2 then 
		return false 
	end 
	if  cards[1].weight == Weight.SJoker and cards[2].weight == Weight.LJoker then 
        return true
    elseif cards[1].weight == Weight.LJoker and cards[2].weight ==  Weight.SJoker then 
    	return true
    end 
    return false
end 

--是否是单
function CardRule.IsSingle(cards)
	if type(cards) == "table" and #cards == 1 then 
		return true
	end 
	return false
end 
--是否是对子
function CardRule.IsDouble(cards)
	if type(cards) == "table" and #cards == 2 then 
		if cards[1].weight == cards[2].weight then 
			return true
		end 
	end 
	return false
end 
--是否是顺子
function CardRule.IsStraight(cards)
	if type(cards) ~= "table" or #cards < 5 then 
		return false
	end 
	local splits = CardRule.SplitCardsFunc(cards)
	for i=1,#splits do 
		if (splits[i].count ~= 1) or splits[i].weight >=Weight.Two then			
			return false
		end 
		if i < #splits then
			if (splits[i].weight +1 ~= splits[i+1].weight) then 
				return false
			end
		end
	end 
	return true
end 

--是否是双顺子
function CardRule.IsDoubleStraight(cards)
	if type(cards) ~= "table" or #cards < 6 or #cards % 2 ~= 0 then 
		return false
	end
	local splits = CardRule.SplitCardsFunc(cards)
	for i=1,#splits do
		if splits[i].count ~= 2 then
			return false
		end
	end
	for i=1,#splits-1 do 
		if(splits[i].weight +1 ~= splits[i+1].weight)  or (splits[i+1].weight >= Weight.Two) then 
			return false
		end 
	end 
	return true
end 

--是否是三不带
function CardRule.IsOnlyThree(cards)
	if type(cards) ~= "table" or #cards  ~= 3 then 
		return false
	end 
	local splits = CardRule.SplitCardsFunc(cards)
	if #splits == 1 and splits[1].count == 3 and splits[1].weight <= Weight.Two then 
		return true
	end 
	return false
end 
--是否是三带一
function CardRule.IsThreeAndOne(cards)
	if type(cards) ~= "table" or #cards  ~= 4 then 
		return false
	end
	local splits = CardRule.SplitCardsFunc(cards)
	local threeNum = 0
	local singleNum = 0
	for i= 1, #splits do 
		if splits[i].count == 3 then 
			if splits[i].weight <= Weight.Two then
				threeNum = threeNum + 1
			end 
		elseif splits[i].count == 1 then 
			singleNum = singleNum + 1
		end
	end 
	if threeNum == singleNum and singleNum == 1 then 
		return true 
	end 
	return false 
end 

--是否是三带二
function CardRule.IsThreeAndDouble(cards)
	if type(cards) ~= "table" or #cards  ~= 5 then 
		return false
	end
	local splits = CardRule.SplitCardsFunc(cards)
	local threeNum = 0
	local doubleNum = 0
	for i= 1, #splits do 
		if splits[i].count == 3 then 
			if splits[i].weight <= Weight.Two then
				threeNum = threeNum + 1
			end 
		elseif splits[i].count == 2 then 
			doubleNum = doubleNum + 1
		end
	end 
	if threeNum == doubleNum and doubleNum == 1 then 
		return true 
	end 
	return false 
end 


--是否是飞机不带
function CardRule.IsTripleStraight(cards)
	if type(cards) ~= "table" or #cards < 6 or #cards % 3 ~= 0 then 
		return false
	end 
	local splits = CardRule.SplitCardsFunc(cards)
	for i=1,#splits-1 do 
		if (splits[i].count ~= 3) or (splits[i].weight +1 ~= splits[i+1].weight)  or (splits[i+1].weight >= Weight.Two) then 
			return false
		end 
	end 
	return true
end 

--是否是 飞机带双 
function CardRule.IsTripleStraightAndDouble(cards)
	if type(cards) ~= "table" or #cards < 10 or #cards % 5 ~= 0 then 
		return false 
	end 
	local splits = CardRule.SplitCardsFunc(cards)
	local onlyThreeList = {}
	local threeNum = 0 
	local doubleNum = 0
	for i=1, #splits do 
		if splits[i].count == 3 then 
			threeNum = threeNum + 1
			local newcards = splits[i].cards 
			for j = 1, #newcards do 
				table.insert(onlyThreeList,newcards[j])
			end 
		else 
			if splits[i].count == 2 then 
				doubleNum = doubleNum + 1
			end 
			if  splits[i].count == 4 then 
				doubleNum = doubleNum + 2
			end 
		end 
	end 
	if doubleNum ==  threeNum and threeNum == #cards /5 then 
		if CardRule.IsTripleStraight(onlyThreeList) then 
			return true
		end 
	end 
	return false
end 

--是否是 飞机带单 
function CardRule.IsTripleStraightAndSingle(cards)
	if type(cards) ~= "table" or #cards < 8 or #cards % 4 ~= 0 then 
		return false 
	end 

	--[[
	local splits = CardRule.SplitCardsFunc(cards)
	local onlyThreeList = {}
	local threeNum = 0 
	local singleNum = 0
	for i=1, #splits do 
		if splits[i].count == 3 then 
			threeNum = threeNum + 1
			local newcards = splits[i].cards 
			for j = 1, #newcards do 
				table.insert(onlyThreeList,newcards[j])
			end 
			--只能是单张
		--elseif splits[i].count == 1 then
			--singleNum = singleNum + 1
			--
		end 
	end 

	--修改，不管单张是什么都可以带
	singleNum = #cards - 3*threeNum
	if threeNum == singleNum and threeNum == #cards /4 then 
		if CardRule.IsTripleStraight(onlyThreeList) then 
			return true
		end 
	end 
	return false
	]]
	local splits = CardRule.SplitCardsFunc(cards)
	local three = {}
	for i=1, #splits do 
		if splits[i].count == 3 then 
			table.insert(three,splits[i])
		end
	end
	local num = #cards/4
	if #three < num then
		return false
	end
	local tempnum = 1
	for i=1,num do
		if num >= i+1 then
			if three[i].weight+1 == three[i+1].weight then
				tempnum = tempnum + 1
				if tempnum == num then
					return true
				end
			else
				tempnum = 1
			end
		end
	end
	
	for i=#three-num+1,#three do
		if num >= i+1 then
			if three[i].weight+1 == three[i+1].weight then
				tempnum = tempnum + 1
				if tempnum == num then
					return true
				end
			else
				tempnum = 1
			end
		end
	end
	return false
end 

--是否是四带2张对子
function CardRule.IsFoureAndDouble(cards)
	if type(cards) ~= "table" or #cards ~= 8 then 
		return false 
	end 
	local splits = CardRule.SplitCardsFunc(cards)
	local foureNum = 0
	local doubleNum = 0
	for i= 1, #splits do 
		if splits[i].count == 4 then 
			foureNum = foureNum + 1 
		elseif splits[i].count == 2 then 
			doubleNum = doubleNum + 1
		end
	end 
	if foureNum *2 == doubleNum and doubleNum == 2 then 
		return true 
	end 
	return false 
end

--是否是四带2张单(可以是一对)
function CardRule.IsFoureAndSingle(cards)
	if type(cards) ~= "table" or #cards ~= 6 then 
		return false 
	end 
	local splits = CardRule.SplitCardsFunc(cards)
	local foureNum = 0
	local singleNum = 0
	for i= 1, #splits do 
		if splits[i].count == 4 then 
			foureNum = foureNum + 1 
		elseif splits[i].count == 1 then 
			singleNum = singleNum + 1
		elseif splits[i].count == 2 then
			singleNum = 2
		end
	end 
	if foureNum *2 == singleNum and singleNum == 2 then 
		return true 
	end 
	return false 
end 
--判断是否符合出牌规则
function  CardRule.PopEnable(cards)
	local type1 = CardsType.None
	local cardlength = 0
	local isRule = false

	if #cards == 1 then 
		isRule = true
		cardlength= 1
		type1 = CardsType.Single
	elseif #cards == 2 then 
		if CardRule.IsDouble(cards) then 
			isRule = true
			cardlength= 1
			type1 = CardsType.Double
		elseif  CardRule.IsJokerBoom(cards) then 
			isRule = true
			cardlength= 1
			type1 = CardsType.JokerBoom
		end 
	elseif #cards == 3 then 
		if CardRule.IsOnlyThree(cards) then 
			isRule = true
			cardlength= 1
			type1 = CardsType.OnlyThree
		end 
 	elseif #cards == 4 then 
 		if CardRule.IsThreeAndOne(cards) then 
			isRule = true
			cardlength= 1
			type1 = CardsType.ThreeAndOne
		elseif  CardRule.IsBoom(cards) then 
			isRule = true
			cardlength= 1
			type1 = CardsType.Boom
		end 
	elseif #cards == 5 then 
		if CardRule.IsStraight(cards) then 
			isRule = true
			cardlength= 5
			type1 = CardsType.Straight
		elseif  CardRule.IsThreeAndDouble(cards) then 
			isRule = true
			cardlength= 1
			type1 = CardsType.ThreeAndTwo
		end 
	elseif #cards == 6 then 
		if CardRule.IsStraight(cards) then 
			isRule = true
			cardlength= 6
			type1 = CardsType.Straight
		elseif  CardRule.IsDoubleStraight(cards) then 
			isRule = true
			cardlength= 3
			type1 = CardsType.DoubleStraight
		elseif  CardRule.IsTripleStraight(cards) then 
			isRule = true
			cardlength= 2
			type1 = CardsType.TripleStraight
		elseif  CardRule.IsFoureAndSingle(cards) then 
			isRule = true
			cardlength= 1
			type1 = CardsType.FourAndSingle
		end 
	elseif #cards == 7 then 
		if CardRule.IsStraight(cards) then 
			isRule = true
			cardlength= 7
			type1 = CardsType.Straight
		end 
	elseif #cards == 8 then 
		if CardRule.IsStraight(cards) then 
			isRule = true
			cardlength= 8
			type1 = CardsType.Straight
		elseif  CardRule.IsDoubleStraight(cards) then 
			isRule = true
			cardlength= 4
			type1 = CardsType.DoubleStraight
		elseif  CardRule.IsTripleStraightAndSingle(cards) then 
			isRule = true
			cardlength= 2
			type1 = CardsType.TripleStraightAndSingle
		elseif  CardRule.IsFoureAndDouble(cards) then 
			isRule = true
			cardlength= 1
			type1 = CardsType.FourAndDouble
		end 
	elseif #cards == 9 then 
		if CardRule.IsStraight(cards) then 
			isRule = true
			cardlength= 9
			type1 = CardsType.Straight
		elseif  CardRule.IsTripleStraight(cards) then 
			isRule = true
			cardlength= 3
			type1 = CardsType.TripleStraight
		end 
	elseif #cards == 10 then 
		if CardRule.IsStraight(cards) then 
			isRule = true
			cardlength= 10
			type1 = CardsType.Straight
		elseif  CardRule.IsDoubleStraight(cards) then 
			isRule = true
			cardlength= 5
			type1 = CardsType.DoubleStraight
		elseif  CardRule.IsTripleStraightAndDouble(cards) then 
			isRule = true
			cardlength= 2
			type1 = CardsType.TripleStraightAndDouble
		end 
	elseif #cards == 11 then 
		if CardRule.IsStraight(cards) then 
			isRule = true
			cardlength= 11
			type1 = CardsType.Straight
		end
	elseif #cards == 12 then 
		if CardRule.IsStraight(cards) then 
			isRule = true
			cardlength= 12
			type1 = CardsType.Straight
		elseif  CardRule.IsDoubleStraight(cards) then 
			isRule = true
			cardlength= 6
			type1 = CardsType.DoubleStraight
		elseif  CardRule.IsTripleStraightAndSingle(cards) then 
			isRule = true
			cardlength= 3
			type1 = CardsType.TripleStraightAndSingle
		elseif  CardRule.IsTripleStraight(cards) then 
			isRule = true
			cardlength= 4
			type1 = CardsType.TripleStraight
		end 
	elseif #cards == 13 then 
	elseif #cards == 14 then 
		if  CardRule.IsDoubleStraight(cards) then 
			isRule = true
			cardlength= 7
			type1 = CardsType.DoubleStraight
		end 
	elseif #cards == 15 then 
		if  CardRule.IsTripleStraightAndDouble(cards) then 
			isRule = true
			cardlength= 3
			type1 = CardsType.TripleStraightAndDouble
		elseif  CardRule.IsTripleStraight(cards) then 
			isRule = true
			cardlength= 5
			type1 = CardsType.TripleStraight
		end 
	elseif #cards == 16 then
		if  CardRule.IsDoubleStraight(cards) then 
			isRule = true
			cardlength= 8
			type1 = CardsType.DoubleStraight
		elseif  CardRule.IsTripleStraightAndSingle(cards) then 
			isRule = true
			cardlength= 4
			type1 = CardsType.TripleStraightAndSingle
		end  
	elseif #cards == 17 then 
	elseif #cards == 18 then 
		if  CardRule.IsDoubleStraight(cards) then 
			isRule = true
			cardlength= 9
			type1 = CardsType.DoubleStraight
		elseif  CardRule.IsTripleStraight(cards) then 
			isRule = true
			cardlength= 6
			type1 = CardsType.TripleStraight
		end 
	elseif #cards == 19 then 
	elseif #cards == 20 then
		if  CardRule.IsDoubleStraight(cards) then 
			isRule = true
			cardlength= 10
			type1 = CardsType.DoubleStraight
		elseif  CardRule.IsTripleStraightAndSingle(cards) then 
			isRule = true
			cardlength= 5
			type1 = CardsType.TripleStraightAndSingle
		elseif  CardRule.IsTripleStraightAndDouble(cards) then 
			isRule = true
			cardlength= 4
			type1 = CardsType.TripleStraightAndDouble
		end 
	else
		error("出牌类型找不到啊！！！")
	end 
	return isRule ,type1,cardlength
end 

-------------------------------------------------------------------------------------------------------------------------------------------
---找出打的起的牌型

--找到手牌中符合要求的炸弹
function CardRule.FindBoomsFunc(allCards,weight)
	local boomlist = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	for i = 1, #splits do
		if splits[i].count == 4 and splits[i].weight > weight  then 
			local boom = clone(splits[i].cards)
			table.insert(boomlist,boom)
		end 
	end 
	--判断是否有王炸
	local jokerBoom = {} 
	for i = 1, #allCards do 
		if allCards[i].weight == Weight.SJoker or allCards[i].weight == Weight.LJoker then 
			table.insert(jokerBoom,allCards[i])
		end 
	end 
	if #jokerBoom == 2 then 
		table.insert(boomlist,jokerBoom)
	end 
	return boomlist
end 
function CardRule.FindBoomsFuncWithChange(allCards,weight)
	local boomsList = {}
	local changeNum = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}
	local nochange = {}
	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		else
			table.insert(nochange,splits[i])
		end
	end
	--不用癞子
	for i =1, #nochange do  
		if nochange[i].count == 4 and  nochange[i].weight > weight then 
			local double = clone(nochange[i].cards)
			table.insert(boomsList,double)
			table.insert(changeNum,0)
		end
	end
	--启用癞子
	if #change>0 then
		if change[1].count >= 1 then
			for i=1,#nochange do
				if nochange[i].count == 3 then
					local boom = clone(nochange[i].cards)
					table.insert(boom,change[1].cards[1])
					table.insert(changeNum,1)
					table.insert(boomsList,boom)
				end
			end
		end
		if change[1].count >= 2 then
			for i=1,#nochange do
				if nochange[i].count == 2 then
					local boom = clone(nochange[i].cards)
					table.insert(boom,change[1].cards[1])
					table.insert(boom,change[1].cards[2])
					table.insert(changeNum,2)
					table.insert(boomsList,boom)
				end
			end	
		end
		if change[1].count >= 3 then
			for i=1,#nochange do
				if nochange[i].count == 1 then
					local boom = clone(nochange[i].cards)
					table.insert(boom,change[1].cards[1])
					table.insert(boom,change[1].cards[2])
					table.insert(boom,change[1].cards[3])
					table.insert(changeNum,3)
					table.insert(boomsList,boom)
				end
			end	
		end
		if change[1].count >= 4 then
			local boom = clone(change[1].cards)
			table.insert(changeNum,4)
			table.insert(boomsList,boom)
		end
	end
	return boomsList
end
--找到手牌中为weight的炸弹
function CardRule.FindBoomsByWeight(allCards,weight)
	local boom = nil;
	local splits = CardRule.SplitCardsFunc(allCards)
	for i = 1, #splits do
		if splits[i].count == 4 and splits[i].weight == weight  then 
			local boom = clone(splits[i].cards)
			break;
		end 
	end 
	return boom;
end
--找到手牌中和点击选的牌一样
--isOnlyDouble = true  表示只有2对（如：55），不包括 3对 4对（如：555、5555）
function  CardRule.FindDoubleEqualFunc(allCards,weight,isOnlyDouble)
	local doubleList = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	for i =1, #splits do 
		if isOnlyDouble == true then 
			if splits[i].count == 2 and  splits[i].weight == weight then 
				local double = clone(splits[i].cards)
				table.insert(doubleList,double)
			end 
		else 
			if splits[i].count >= 2 and  splits[i].weight == weight then 
				local double = {}
				table.insert(double,splits[i].cards[1])
				table.insert(double,splits[i].cards[2])
				table.insert(doubleList,double)
			end 
		end 
	end 
	return doubleList
end 

--找到手牌中符合要求的对子
--isOnlyDouble = true  表示只有2对（如：55），不包括 3对 4对（如：555、5555）
function  CardRule.FindDoubleFunc(allCards,weight,isOnlyDouble)
	local doubleList = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	for i =1, #splits do 
		if isOnlyDouble == true then 
			if splits[i].count == 2 and  splits[i].weight > weight then 
				local double = clone(splits[i].cards)
				table.insert(doubleList,double)
			end 
		else 
			if splits[i].count >= 2 and  splits[i].weight > weight then 
				local double = {}
				table.insert(double,splits[i].cards[1])
				table.insert(double,splits[i].cards[2])
				table.insert(doubleList,double)
			end 
		end 
	end 
	return doubleList
end 
function CardRule.FindDoubleFuncWithChange(allCards,weight,isOnlyDouble)
	local doubleList = {}
	local changeNum = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}
	local nochange = {}
	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		else
			table.insert(nochange,splits[i])
		end
	end
	--不用癞子
	for i =1, #nochange do 
		if isOnlyDouble == true then 
			if nochange[i].count == 2 and  nochange[i].weight > weight then 
				local double = clone(nochange[i].cards)
				table.insert(doubleList,double)
				table.insert(changeNum,0)
			end 
		else 
			if nochange[i].count >= 2 and  nochange[i].weight > weight then 
				local double = {}
				table.insert(double,nochange[i].cards[1])
				table.insert(double,nochange[i].cards[2])
				table.insert(doubleList,double)
				table.insert(changeNum,0)
			end 
		end 
	end
	--启用癞子
	for i =1, #nochange do 
		if nochange[i].count == 1 and nochange[i].weight > weight and nochange[i].weight <= Weight.Two and #change>= 1 then
			local double = {}
			table.insert(double,change[1].cards[1])
			table.insert(double,nochange[i].cards[1])
			table.insert(doubleList,double)
			table.insert(changeNum,1)
		end
	end
	return doubleList
end

--找到手牌中符合要求的单牌
--isOnlySingle = true  表示只有单牌（如：5），不包括 2对 3对 4对（如：55、555、5555）
function  CardRule.FindSingleFunc(allCards,weight,isOnlySingle,maxWeight)
	local singleList = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	for i =1, #splits do 
		if isOnlySingle == true then 
			if splits[i].count == 1 and  splits[i].weight > weight then 
				--if maxWeight == nil then
					local single = clone(splits[i].cards)
					table.insert(singleList,single)
				--else
				--	if splits[i].weight <= maxWeight then
				--		local single = clone(splits[i].cards)
				--		table.insert(singleList,single)
				--	end
				--end
			end 
		else 
			if splits[i].count >= 1 and  splits[i].weight > weight then 
				local single = {}
				if maxWeight == nil then
					table.insert(single,splits[i].cards[1])
					table.insert(singleList,single)
				else
					if splits[i].weight <= maxWeight then
						table.insert(single,splits[i].cards[1])
						table.insert(singleList,single)
					end
				end
			end 
		end 
	end 
	return singleList
end 


--找到手牌中符合要求的双顺子
function CardRule.FindDoubleStraightFunc(allCards,minWeight,length)
	--[[
	local doubleStraightList = {} 
	local doubleList = CardRule.FindDoubleFunc(allCards,minWeight,false)
	if #doubleList >= length then 
		for i = 1, #doubleList - length do 
			local straight = {}
			table.insert(straight,doubleList[i][1])
			table.insert(straight,doubleList[i][2])
			for j = i+1, i+length do 
				if doubleList[i][1].weight + j - i == doubleList[j][1].weight and doubleList[j][1].weight < Weight.Two then 
					table.insert(straight,doubleList[j][1])
					table.insert(straight,doubleList[j][2])
				end 
			end 
			if #straight == length *2 then 
				table.insert(doubleStraightList,straight)
			end 
		end 
	end 
	return doubleStraightList
	]]
	return CardRule.FindAllFindDoubleStraightFunc(allCards,length,minWeight+1)
end 

--找到手牌中指定长度的所有双顺子
function CardRule.FindAllFindDoubleStraightFunc(allCards,length,minweight)
	local doubleStraightList = {} 


	if minweight == nil then 
		minweight = Weight.None
	elseif minweight ~= Weight.None then
		minweight = minweight - 1;
	end

	local doubleList = CardRule.FindDoubleFunc(allCards,minweight,false)
	if #doubleList >= length then 
		for i = 1, #doubleList - length +1 do 
			local straight = {}
			table.insert(straight,doubleList[i][1])
			table.insert(straight,doubleList[i][2])
			for j = i, i+length-2 do 
				if doubleList[j][1].weight + 1 == doubleList[j+1][1].weight and doubleList[j+1][1].weight < Weight.Two then 
					table.insert(straight,doubleList[j+1][1])
					table.insert(straight,doubleList[j+1][2])
				end 
			end 
			if #straight == length *2 then 
				table.insert(doubleStraightList,straight)
			end 
		end 
	end 
	return doubleStraightList
end
function CardRule.FindDoubleStraightFuncWithChange(allCards,length,minweight)
	local doubleStraightList = {} 

	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}
	local nochange = {}

	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		elseif splits[i].weight>minweight and splits[i].weight < Weight.Two then
			table.insert(nochange,splits[i])
		end
	end
	if #nochange + change[1].count >= length*2 then
		for i= minweight+1,Weight.Two - length do
			local changeNum = 0
			local doubleStraight = {}
			for j=i,i+length-1 do
				if CardRule.WeightContainsWithCards(allCards,j) == false or j == GameCtrl.changeCardWeight then
					if changeNum+2 <= change[1].count then
						table.insert(doubleStraight,change[1].cards[changeNum+1]);
						table.insert(doubleStraight,change[1].cards[changeNum+2]);
						changeNum= changeNum + 2
					else
						break
					end
				else
					for k=1,#nochange do
						if nochange[k].weight == j then
							if nochange[k].count >= 2 then
								table.insert(doubleStraight,nochange[k].cards[1]);
								table.insert(doubleStraight,nochange[k].cards[2]);
							elseif changeNum+1 <= change[1].count then
								table.insert(doubleStraight,nochange[k].cards[1]);
								table.insert(doubleStraight,change[1].cards[changeNum+1])
								changeNum = changeNum + 1
							else
								break
							end
						end
					end
				end
			end
			if #doubleStraight == length*2 then
				table.insert(doubleStraightList,doubleStraight)
			end
		end
	end
	return doubleStraightList;
end
--找到手牌中和点击选的牌一样的顺子
function CardRule.FindStraightEqualFunc(allCards,minWeight,length,maxWeight)
	local straightList = {} 
	local singleList = CardRule.FindSingleFunc(allCards,minWeight,false,maxWeight)
	if #singleList >= length then 
		for i = 1, #singleList - length +1 do 
			local straight = {}
			table.insert(straight,singleList[i][1])
			for j = i+1, i+length-1 do 
				if singleList[i][1].weight + j - i == singleList[j][1].weight and singleList[j][1].weight < Weight.Two then 
					table.insert(straight,singleList[j][1])
				end 
			end 
			if #straight == length then 
				table.insert(straightList,straight)
			end 
		end 
	end 
	return straightList
end 

--找到手牌中符合要求的顺子
function CardRule.FindStraightFunc(allCards,minWeight,length,maxWeight)
	--[[
	local straightList = {} 
	local singleList = CardRule.FindSingleFunc(allCards,minWeight,false,maxWeight)
	if #singleList >= length then 
		for i = 1, #singleList - length do 
			local straight = {}
			table.insert(straight,singleList[i][1])
			for j = i+1, i+length do 
				if singleList[i][1].weight + j - i == singleList[j][1].weight and singleList[j][1].weight < Weight.Two then 
					table.insert(straight,singleList[j][1])
				end 
			end 
			if #straight == length then 
				table.insert(straightList,straight)
			end 
		end 
	end 
	return straightList
	]]
	return CardRule.FindStraightByLengthFunc(allCards,length,minWeight + 1)
end 
--找到手牌中指定数量的所有顺子
function CardRule.FindStraightByLengthFunc( allCards,length,minweight)
	local straightList = {} 
	if minweight == nil then 
		minweight = Weight.None
	elseif minweight ~= Weight.None then
		minweight = minweight - 1;
	end
	local singleList = CardRule.FindSingleFunc(allCards,minweight,false);
	if #singleList >= length then
		for i=1,#singleList-length+1 do
			local straight = {}
			table.insert(straight,singleList[i][1]);
			for j=i,i+length-2 do
				if singleList[j][1].weight+1 == singleList[j+1][1].weight and singleList[j+1][1].weight < Weight.Two then
					table.insert(straight,singleList[j+1][1])
				else
					break;
				end
			end
			if #straight == length then 
				table.insert(straightList,straight)
			end
		end
	end
	return straightList;
end
function CardRule.FindStraightFuncWithChange( allCards,length,minweight)
	local straightList = {}
	if minweight == nil then 
		minweight = Weight.None
	end

	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}
	local nochange = {}

	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		elseif splits[i].weight>minweight and splits[i].weight < Weight.Two then
			table.insert(nochange,splits[i])
		end
	end
	if #nochange + change[1].count >= length then
		for i= minweight+1,Weight.Two - length do
			local changeNum = 1
			local straight = {}
			for j=i,i+length-1 do
				if CardRule.WeightContainsWithCards(allCards,j) == false or j == GameCtrl.changeCardWeight then
					if changeNum <= change[1].count then
						table.insert(straight,change[1].cards[changeNum]);
						changeNum = changeNum + 1
					else
						break
					end
				else
					for k=1,#nochange do
						if nochange[k].weight == j then
							table.insert(straight,nochange[k].cards[1]);
							break
						end
					end
				end
			end
			if #straight == length then
				table.insert(straightList,straight)
			end
		end
	end
	return straightList;
end
--找到手牌中和点击选的牌一样的三张牌
function CardRule.FindOnlyThreeEqualFunc(allCards,weight)
	local onlyThreelist = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	for i = 1, #splits do
		if splits[i].count == 3 and splits[i].weight == weight  then 
			local onlyThree = clone(splits[i].cards)
			table.insert(onlyThreelist,onlyThree)
		end 
	end 
	return onlyThreelist
end

--找到手牌中符合要求的3张
function CardRule.FindOnlyThreeFunc(allCards,weight)
	local onlyThreelist = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	for i = 1, #splits do
		if splits[i].count == 3 and splits[i].weight > weight  then 
			local onlyThree = clone(splits[i].cards)
			table.insert(onlyThreelist,onlyThree)
		end 
	end 
	return onlyThreelist
end 

function CardRule.FindOnlyThreeFuncWithChange(allCards,weight)

	local onlyThreelist = {}
	local changeNum = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}
	local nochange = {}

	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		else
			table.insert(nochange,splits[i])
		end
	end
	--不用癞子
	for i = 1, #nochange do
		if nochange[i].count == 3 and nochange[i].weight > weight  then 
			local onlyThree = clone(nochange[i].cards)
			table.insert(onlyThreelist,onlyThree)
			table.insert(changeNum,0)
		end 
	end 

	local changeCard = CardRule.FindChangeCardInCards(allCards)
	for i=1,#nochange do
		if nochange[i].weight > weight and nochange[i].count < 3 and nochange[i].weight <= Weight.Two then
			if #changeCard >= 3 - nochange[i].count then
				local onlyThree = {}
				
				for j=1,3-nochange[i].count do
					table.insert(onlyThree,changeCard[j])
				end
				for j=1,nochange[i].count do
					table.insert(onlyThree,nochange[i].cards[j])
				end
				table.insert(onlyThreelist,onlyThree)
				table.insert(changeNum,3-nochange[i].count)
			end
		end
	end

	--用癞子
	--[[
	if #change > 0 then
		--一个癞子
		if change[1].count >= 1 then
			--找一对
			for i=1,#nochange do
				if nochange[i].count == 2 then
					local onlyThree = {}
					table.insert(onlyThree,nochange[i].cards[1])
					table.insert(onlyThree,nochange[i].cards[2])
					table.insert(onlyThree,change[1].cards[1])
					table.insert(onlyThreelist,onlyThree)
					table.insert(changeNum,1)
				end
			end
		end
		--二个癞子
		if change[1].count >= 2 then
			--找单
			for i=1,#nochange do
				if nochange[i].count == 1 and nochange[i].weight <= Weight.Two then
					local onlyThree = {}
					table.insert(onlyThree,nochange[i].cards[1])
					table.insert(onlyThree,change[1].cards[1])
					table.insert(onlyThree,change[1].cards[2])
					table.insert(onlyThreelist,onlyThree)
					table.insert(changeNum,2)
				end
			end
		end
		--三个癞子
		if change[1].count >= 3 and change[1].weight > weight then
			local onlyThree = clone(change[1].cards)
			table.insert(onlyThreelist,onlyThree)
			table.insert(changeNum,3)
		end
	end
	]]

	return onlyThreelist,changeNum
end

-- 找到手牌中符合要求的三代二
function CardRule.FindThreeAndTwoFunc(allCards,  weight)
	local threeandtwolist = {} 
    local threelist = CardRule.FindOnlyThreeFunc(allCards, weight)
    if  #threelist > 0 then 
        local  doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, true)
        if #doubleList  == 0 then 
            doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, false)
        end 
        if #doubleList  > 0 then 
	        for  i = 1, #threelist do 
	            for j = 1, #doubleList do 
	                if threelist[i][1].weight ~= doubleList[j][1].weight then 
	       				local threeandtwo = {}
	       				local three = threelist[i]
	       				local double = doubleList[j]
	       				for r = 1, #three do
	       					table.insert(threeandtwo,three[r])
	       				end  
	       				for r = 1, #double do
	       					table.insert(threeandtwo,double[r])
	       				end  
	                    table.insert(threeandtwolist,threeandtwo)
	                    break
	                end
	            end 
	        end 
	    end
  	end 
    return threeandtwolist;
end 
function CardRule.FindThreeAndTwoFuncWithChange(allCards,weight)
	local threeandtwolist = {} 

	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}
	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		end
	end

    local threelist,changeNum = CardRule.FindOnlyThreeFuncWithChange(allCards, weight)
    if  #threelist > 0 then 
    	--找一对
    	local  doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, true)
    	if #doubleList  == 0 then 
            doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, false)
        end

        if #doubleList  > 0 then 
	        for  i = 1, #threelist do 
	            for j = 1, #doubleList do 
	            	if CardRule.CardWeightContains(threelist[i],doubleList[j][1]) == false then
	                --if threelist[i][1].weight ~= doubleList[j][1].weight then 
	       				local threeandtwo = {}
	       				local three = threelist[i]
	       				local double = doubleList[j]
	       				for r = 1, #three do
	       					table.insert(threeandtwo,three[r])
	       				end 
	       				for r = 1, #double do
	       					table.insert(threeandtwo,double[r])
	       				end  
	                    table.insert(threeandtwolist,threeandtwo)
	                    break
	                end
	            end 
	        end 
	    else
	    	local doubleChangeNum = {}
	    	doubleList,doubleChangeNum = CardRule.FindDoubleFuncWithChange(allCards,weight,true)
	    	if #doubleList  > 0 then 
	    		for  i = 1, #threelist do 
		            for j = 1, #doubleList do 
		            	if CardRule.CardWeightContains(threelist[i],doubleList[j][1]) == false and changeNum[i] + doubleChangeNum[j]<= change[1].count then
		                --if threelist[i][1].weight ~= doubleList[j][1].weight then 
		       				local threeandtwo = {}
		       				local three = threelist[i]
		       				local double = doubleList[j]
		       				for r = 1, #three do
		       					table.insert(threeandtwo,three[r])
		       				end  
		       				for r = 1, #double do
		       					table.insert(threeandtwo,double[r])
		       				end  
		                    table.insert(threeandtwolist,threeandtwo)
		                    break
		                end
		            end 
		        end 
	    	end
	    end


    end
    return threeandtwolist
end

-- 找到手牌中符合要求的三代一
function CardRule.FindThreeAndOneFunc(allCards,  weight)
	local threeandonelist = {} 
    local threelist = CardRule.FindOnlyThreeFunc(allCards, weight)
    if  #threelist > 0 then 
        local  singleList = CardRule.FindSingleFunc(allCards, Weight.None, true)
        if #singleList  == 0 then 
            singleList = CardRule.FindSingleFunc(allCards, Weight.None, false)
        end 
        if #singleList > 0 then 
	        for  i = 1, #threelist do 
	            for j = 1, #singleList do 
	                if threelist[i][1].weight ~= singleList[j][1].weight then 
	       				local threeandone = {}
	       				local three = threelist[i]
	       				local single = singleList[j]
	       				for r = 1, #three do
	       					table.insert(threeandone,three[r])
	       				end  
	       				for r = 1, #single do
	       					table.insert(threeandone,single[r])
	       				end  
	                    table.insert(threeandonelist,threeandone)
	                    break
	                end
	            end 
	        end 
	    end 
  	end 
    return threeandonelist
end 
function CardRule.FindThreeAndOneFuncWithChange(allCards,weight)
	local threeandonelist = {} 
	local threelist = CardRule.FindOnlyThreeFuncWithChange(allCards, weight)
	if  #threelist > 0 then 
        local  singleList = CardRule.FindSingleFunc(allCards, Weight.None, true)
        if #singleList  == 0 then 
            singleList = CardRule.FindSingleFunc(allCards, Weight.None, false)
        end 
        if #singleList > 0 then 
	        for  i = 1, #threelist do 
	            for j = 1, #singleList do 
	            	if CardRule.CardWeightContains(threelist[i],singleList[j][1]) == false then
	                --if threelist[i][1].weight ~= singleList[j][1].weight  then 
	       				local threeandone = {}
	       				local three = threelist[i]
	       				local single = singleList[j]
	       				for r = 1, #three do
	       					table.insert(threeandone,three[r])
	       				end  
	       				for r = 1, #single do
	       					table.insert(threeandone,single[r])
	       				end  
	                    table.insert(threeandonelist,threeandone)
	                    break
	                end
	            end 
	        end 
	    end 
  	end 
  	return threeandonelist
end
--找到手牌中符合要求的 飞机不带
function CardRule.FindTripleStraightFunc(allCards, minweight,length)

	local tripleStraightList = {}
	local threeList = CardRule.FindOnlyThreeFunc(allCards,minweight)
	if #threeList >= length then 
		for i = 1, #threeList-length+1 do 
			local tripleStraight = {}
			table.insert(tripleStraight,threeList[i][1]);
			table.insert(tripleStraight,threeList[i][2]);
			table.insert(tripleStraight,threeList[i][3]);
			local count = 1
			for j = i, i+length-2 do 
				if threeList[j][1].weight + 1 ~= threeList[j+1][1].weight or threeList[j+1][1].weight >= Weight.Two  then
					break			
     			else 
     				count = count + 1
     				table.insert(tripleStraight,threeList[j+1][1])
     				table.insert(tripleStraight,threeList[j+1][2])
     				table.insert(tripleStraight,threeList[j+1][3])
				end 
			end 
			if count == length then 
				table.insert(tripleStraightList,tripleStraight)
			end 
		end 
	end  
	return tripleStraightList
end 
function CardRule.FindTripleStraightFuncWithChange(allCards, minweight,length)
	--[[
	local tripleStraightList = {}
	local changeNum = {}

	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}

	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		end
	end

	local threeList,threeNum = CardRule.FindOnlyThreeFuncWithChange(allCards,minweight)
	if #threeList >= length then 
		for i = 1, #threeList-length+1 do 
			local allchangenum = threeNum[i]
			local tripleStraight = {}
			table.insert(tripleStraight,threeList[i][1]);
			table.insert(tripleStraight,threeList[i][2]);
			table.insert(tripleStraight,threeList[i][3]);
			local count = 1
			for j = i, i+length-2 do 
				if threeList[j][1].weight + 1 ~= threeList[j+1][1].weight or threeList[j+1][1].weight >= Weight.Two  then
					break			
     			else 
     				count = count + 1
     				table.insert(tripleStraight,threeList[j+1][1])
     				table.insert(tripleStraight,threeList[j+1][2])
     				table.insert(tripleStraight,threeList[j+1][3])
     				allchangenum = threeNum[j+1]
				end 
			end 
			if count == length and allchangenum <= change[1].count then 
				table.insert(tripleStraightList,tripleStraight)
				table.insert(changeNum,allchangenum)
			end 
		end 
	end
	return tripleStraightList,changeNum
	]]



	local tripleStraightList = {} 
	local changeNumList = {}

	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}
	local nochange = {}

	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		elseif splits[i].weight>minweight and splits[i].weight < Weight.Two then
			table.insert(nochange,splits[i])
		end
	end
	if #nochange + change[1].count >= length*3 then
		for i= minweight+1,Weight.Two - length do
			local changeNum = 0
			local tripleStraight = {}
			for j=i,i+length-1 do
				if CardRule.WeightContainsWithCards(allCards,j) == false or j == GameCtrl.changeCardWeight then
					if changeNum+3 <= change[1].count then
						table.insert(tripleStraight,change[1].cards[changeNum+1]);
						table.insert(tripleStraight,change[1].cards[changeNum+2]);
						table.insert(tripleStraight,change[1].cards[changeNum+3]);
						changeNum = changeNum + 3
					else
						break
					end
				else
					for k=1,#nochange do
						if nochange[k].weight == j then
							if nochange[k].count >= 3 then
								table.insert(tripleStraight,nochange[k].cards[1]);
								table.insert(tripleStraight,nochange[k].cards[2]);
								table.insert(tripleStraight,nochange[k].cards[3]);
							elseif changeNum + 3-nochange[k].count <= change[1].count then
								for z=1,nochange[k].count do
									table.insert(tripleStraight,nochange[k].cards[z]);
								end
								for z=1,3-nochange[k].count do
									table.insert(tripleStraight,change[1].cards[changeNum+z])
								end
								changeNum = changeNum + 3-nochange[k].count
							else
								break
							end
						end
					end
				end
			end
			if #tripleStraight == length*3 then
				table.insert(tripleStraightList,tripleStraight)
				table.insert(changeNumList,changeNum)
			end
		end
	end
	return tripleStraightList,changeNumList;
end

--找到手牌中符合要求的 飞机带双
function CardRule.FindTripleStraightAndDoubleFunc(allCards, minweight,length)
	--[[ 旧代码 ，有问题
	local sfAndDoubleList = {}
	local onlyTripleSraight = CardRule.FindTripleStraightFunc(allCards, minweight,length)
	if #onlyTripleSraight > 0 then 
       local doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, false)
        if #doubleList  >= length then 
        	local newdoubleList = {}
        	for i = 1, #onlyTripleSraight do 
        		for j= 1, #doubleList do 
        			for r = 1, length do 
        				local index = (r-1)*3+1
        				if doubleList[j][1].weight ~= onlyTripleSraight[i][index].weight  then 
        					table.insert(newdoubleList,doubleList[j])
        				end 
        			end 
        		end 
        	end 
        	if #newdoubleList >= length then 
	        	for i = 1, #onlyTripleSraight do 
	        		local sfAndDouble = {} 
        			local doublethree =  onlyTripleSraight[i]
        			for x = 1, #doublethree do 
    			 		table.insert(sfAndDouble,doublethree[x])
    				end 
        			for r = 1 , length do 
        				local double = newdoubleList[r]
        				for x = 1, #double do 
        					table.insert(sfAndDouble,double[x])
        				end
        			end 
	        		table.insert(sfAndDoubleList,sfAndDouble)
	        	end 
	        end 
        end 
	end 
	return sfAndDoubleList
	]]
	local sfAndSingleList = {}
	local onlyTripleSraight = CardRule.FindTripleStraightFunc(allCards, minweight,length)
	if #onlyTripleSraight > 0 then 
		for r=1,#onlyTripleSraight do
			local sfAndsingle = {}
			for i=1,#onlyTripleSraight[r] do
				table.insert(sfAndsingle,onlyTripleSraight[r][i])
			end
			local doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, true)
			if #doubleList  < length then 
				for i=1,#doubleList do
					table.insert(sfAndsingle,doubleList[i][1])
					table.insert(sfAndsingle,doubleList[i][2])
				end
				doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, false)
				for i=1,#doubleList do
					if #sfAndsingle >= length*5 then break end
					if CardRule.CardWeightContains(sfAndsingle,doubleList[i][1]) == false then
						table.insert(sfAndsingle,doubleList[i][1])
						table.insert(sfAndsingle,doubleList[i][2])
					end
				end
			else
				for i=1,length do
					table.insert(sfAndsingle,doubleList[i][1])
					table.insert(sfAndsingle,doubleList[i][2])
				end
			end
			if #sfAndsingle == length * 5 then
				table.insert(sfAndSingleList,sfAndsingle)
			end
		end
			
	end
	return sfAndSingleList


end 
function CardRule.FindTripleStraightAndDoubleFuncWithChange(allCards, minweight,length)
	local sfAndSingleList = {}

	local splits = CardRule.SplitCardsFunc(allCards)
	local change = {}

	for i =1, #splits do 
		if GameCtrl.changeCardWeight == splits[i].weight then
			table.insert(change,splits[i])
		end
	end
	
	local onlyTripleSraight,tripchangenum = CardRule.FindTripleStraightFuncWithChange(allCards, minweight,length)
	if #onlyTripleSraight > 0 then 
		for r=1,#onlyTripleSraight do
			local allchangenum = tripchangenum[r]
			local sfAndsingle = {}
			for i=1,#onlyTripleSraight[r] do
				table.insert(sfAndsingle,onlyTripleSraight[r][i])
			end
			local doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, true)
			local doubleNum = 0
			for i=1,#doubleList do
				if CardRule.WeightContainsWithCards(sfAndsingle,doubleList[i][1].weight) == false then
					table.insert(sfAndsingle,doubleList[i][1])
					table.insert(sfAndsingle,doubleList[i][2])
					doubleNum = doubleNum + 1
				end
				if doubleNum == length then
					break
				end
			end
			if doubleNum < length then
				doubleList = CardRule.FindDoubleFunc(allCards, Weight.None, false)
				for i=1,#doubleList do
					if CardRule.WeightContainsWithCards(sfAndsingle,doubleList[i][1].weight) == false then
						table.insert(sfAndsingle,doubleList[i][1])
						table.insert(sfAndsingle,doubleList[i][2])
						doubleNum = doubleNum + 1
					end
					if doubleNum == length then
						break
					end
				end
			end

			if doubleNum < length then
				--加癞子
				local single = CardRule.FindSingleFunc(allCards, Weight.None, true)
				for i=1,#single do
					if CardRule.WeightContainsWithCards(sfAndsingle,single[i][1]) == false then
						table.insert(sfAndsingle,single[i][1])
						if allchangenum + 1 <= change[1].count then
							table.insert(sfAndsingle,change[1][allchangenum + 1])
							doubleNum = doubleNum + 1
							allchangenum = allchangenum + 1
						else
							break
						end
						if doubleNum == length then
							break
						end
					end
				end
			end
			if #sfAndsingle == length * 5 and allchangenum<= change[1].count then
				table.insert(sfAndSingleList,sfAndsingle)
			end
		end
	end
	return sfAndSingleList
end

--找到手牌中符合要求的 飞机带单
function CardRule.FindTripleStraightAndSingleFunc(allCards, minweight,length)
	--[[旧代码
	local sfAndSingleList = {}
	local onlyTripleSraight = CardRule.FindTripleStraightFunc(allCards, minweight,length)
	if #onlyTripleSraight > 0 then 
       local singleList = CardRule.FindSingleFunc(allCards, Weight.None, false)
        if #singleList  >= length then 
        	local newsingleList = {}
        	for i = 1, #onlyTripleSraight do 
        		for j= 1, #singleList do 
        			for r = 1, length do 
        				local index = (r-1)*3+1
        				if singleList[j][1].weight ~= onlyTripleSraight[i][index].weight  then 
        					table.insert(newsingleList,singleList[j])
        				end 
        			end 
        		end 
        	end 
        	if #newsingleList >= length then 
	        	for i = 1, #onlyTripleSraight do 
	        		local sfAndsingle = {} 
        			local doublethree =  onlyTripleSraight[i]
        			for x = 1, #doublethree do 
    			 		table.insert(sfAndsingle,doublethree[x])
    				end 
        			for r = 1 , length do 
        				local single = newsingleList[r]
        				table.insert(sfAndsingle,single[1])
        			end 
	        		table.insert(sfAndSingleList,sfAndsingle)
	        	end 
	        end 
        end 
	end 
	return sfAndSingleList
	]]
	local sfAndSingleList = {}
	local onlyTripleSraight = CardRule.FindTripleStraightFunc(allCards, minweight,length)
	if #onlyTripleSraight > 0 then 
		for r=1,#onlyTripleSraight do
			local sfAndsingle = {}
			for i=1,#onlyTripleSraight[r] do
				table.insert(sfAndsingle,onlyTripleSraight[r][i])
			end
			local singleList = CardRule.FindSingleFunc(allCards, Weight.None, true)
			if #singleList  < length then 
				for i=1,#singleList do
					table.insert(sfAndsingle,singleList[i][1])
				end
				singleList = CardRule.FindSingleFunc(allCards, Weight.None, false)
				for i=1,#singleList do
					if #sfAndsingle >= length*4 then break end
					if CardRule.CardWeightContains(sfAndsingle,singleList[i][1]) == false then
						--判断是否有两只鬼
						if singleList[i][1].weight ~= Weight.LJoker then
							table.insert(sfAndsingle,singleList[i][1])
						else
							local hasJoker = false
							for j=1,#singleList do
								if singleList[j].weight == Weight.SJoker then
									hasJoker = true 
									break
								end
							end
							if hasJoker == false then
								table.insert(sfAndsingle,singleList[i][1])
							end
						end
					end
				end
			else
				for i=1,length do
					table.insert(sfAndsingle,singleList[i][1])
				end
			end
			if #sfAndsingle == length * 4 then
				table.insert(sfAndSingleList,sfAndsingle)
			end
		end
			
	end
	return sfAndSingleList
end 
function CardRule.FindTripleStraightAndSingleFuncWithChange(allCards, minweight,length)
	local sfAndSingleList = {}

	local onlyTripleSraight = CardRule.FindTripleStraightFuncWithChange(allCards, minweight,length)
	if #onlyTripleSraight > 0 then 
		for r=1,#onlyTripleSraight do
			local sfAndsingle = {}
			local singleNum = 0
			for i=1,#onlyTripleSraight[r] do
				table.insert(sfAndsingle,onlyTripleSraight[r][i])
			end
			local singleList = CardRule.FindSingleFunc(allCards, Weight.None, true)
			for i=1,#singleList do
				if CardRule.WeightContainsWithCards(onlyTripleSraight[r],singleList[i][1].weight) == false then
					table.insert(sfAndsingle,singleList[i][1])
					singleNum = singleNum + 1
				end
				if singleNum == length then
					break
				end
			end
			if singleNum < length then
				singleList = CardRule.FindSingleFunc(allCards, Weight.None, false)
				for i=1,#singleList do
					if CardRule.WeightContainsWithCards(onlyTripleSraight[r],singleList[i][1].weight) == false then
						table.insert(sfAndsingle,singleList[i][1])
						singleNum = singleNum + 1
					end
					if singleNum == length then
						break
					end
				end
			end
			if #sfAndsingle == length * 4 then
				table.insert(sfAndSingleList,sfAndsingle)
			end
		end
			
	end
	return sfAndSingleList
end
--获取牌权重值
function  CardRule.GetWeight(cards, _cardType)
	cards = CardRule.SortCardsFunc(cards)
	local weight = 0
	if _cardType == CardsType.ThreeAndOne or _cardType == CardsType.ThreeAndTwo or
	 _cardType == CardsType.TripleStraightAndSingle or _cardType == CardsType.TripleStraightAndDouble then 
		local splits = CardRule.SplitCardsFunc(cards)
		for k,v in pairs(splits) do
			if v.count == 3 then 
				if weight == 0 then 
					weight = v.weight
				else 
					if weight > v.weight then 
						weight = v.weight
					end 
				end 
			end 
		end
	elseif _cardType == CardsType.FourAndSingle or  _cardType == CardsType.FourAndDouble then 
		local splits = CardRule.SplitCardsFunc(cards)
		for k,v in pairs(splits) do
			if v.count == 4 then 
				if weight == 0 then 
					weight = v.weight
				else 
					if weight > v.weight then 
						weight = v.weight
					end 
				end 
			end 
		end
	else
		if #cards > 0 then 
			weight = cards[1].weight
		end 
	end 
	return weight
end 

--一手牌
function CardRule.FirstCard(allCards)
	--飞机带双
	local cardlist = CardRule.FindTripleStraightAndDoubleFunc(allCards, Weight.None, 2)
	if cardlist~= nil and  #cardlist > 0 then
		return cardlist
	end  
	--飞机带单
	cardlist = CardRule.FindTripleStraightAndSingleFunc(allCards, Weight.None, 2)
	if cardlist~= nil and  #cardlist > 0 then
		return cardlist
	end 
	--飞机双连子
	for i = 10,3,-1 do 
		cardlist = CardRule.FindDoubleStraightFunc(allCards, Weight.None, i)
		if cardlist~= nil and  #cardlist > 0 then
			return cardlist
		end 
	end 

	--三带双
	cardlist = CardRule.FindThreeAndTwoFunc(allCards, Weight.None)
	if cardlist~= nil and  #cardlist > 0 then
		return cardlist
	end 
	--三带一
	cardlist = CardRule.FindThreeAndOneFunc(allCards, Weight.None)
	if cardlist~= nil and  #cardlist > 0 then
		return cardlist
	end 
	--顺子
	for i = 10,5,-1 do 
		cardlist = CardRule.FindStraightFunc(allCards, Weight.None, i)
		if cardlist~= nil and  #cardlist > 0 then
			return cardlist
		end 
	end 
	--3不带
	cardlist = CardRule.FindOnlyThreeFunc(allCards, Weight.None)
	if cardlist~= nil and  #cardlist > 0 then
		return cardlist
	end 
	--对子
	cardlist = CardRule.FindDoubleFunc(allCards, Weight.None, true)
	if cardlist~= nil and  #cardlist > 0 then
		return cardlist
	end 
	--单
	cardlist = CardRule.FindSingleFunc(allCards, Weight.None, true)
	if cardlist~= nil and  #cardlist > 0 and not (#cardlist ==2 and cardlist[1].weight == Weight.SJoker) then
		return cardlist
	end 
	--炸弹
	cardlist = CardRule.FindBoomsFunc(allCards, Weight.None)
	if cardlist~= nil and  #cardlist > 0 then
		return cardlist
	end 
end 

--判断是否包含
function CardRule.CardWeightContains(allCards,card)
	local isContains = false;
	for k,v in pairs(allCards) do
		if v.weight == card.weight then
			isContains = true;
			break
		end
	end
	return isContains;
end
function CardRule.WeightContainsWithCards(allCards,weight)
	local isContains = false;
	for k,v in pairs(allCards) do
		if v.weight == weight then
			isContains = true;
			break
		end
	end
	return isContains;
end
function CardRule.FindChangeCardInCards(allCards)
	local changeCards = {}
	local splits = CardRule.SplitCardsFunc(allCards)
	for i=1,#splits do

		if splits[i].weight == GameCtrl.changeCardWeight or splits[i].weight == GameCtrl.otherChangeCardWeigh then
			for j=1,#splits[i].cards do
				table.insert(changeCards,splits[i].cards[j])
			end
		end
	end
	return changeCards
end
---出牌优化
--找出包含所有选中牌的顺子
function CardRule.FindStraightInSelectCard(allCards,selects)
	local singleList = CardRule.FindSingleFunc(selects,Weight.None,true,10);
	--判断所选的牌是否都只有一张,是否包含鬼，和2
	if #singleList ~= #selects then return {} end; 
	--找出selects里面最小的牌
	local minSelectCard = selects[1];
	for i=1,#selects-1 do
		if selects[i].weight <= selects[i+1].weight then
			minSelectCard = selects[i];
		else
			minSelectCard = selects[i+1];
		end
	end
	--找出所有的顺子
	local straight = {};
	for i=10,5,-1 do
		local temp = CardRule.FindStraightByLengthFunc(allCards, i,minSelectCard.weight);
		for i=1,#temp do
			table.insert(straight,temp[i]);
		end
	end
	local recDelect = {}
	for i=1,#straight do
		for j=1,#selects do
			if CardRule.CardWeightContains(straight[i],selects[j]) == false then 
				table.insert(recDelect,i);
				break;
			end
		end
	end
	--删除不符合要求的顺子
	for i = #recDelect,1,-1 do
		table.remove(straight,recDelect[i]);
	end
	straight = CardRule.FindTheBestStraight(allCards,straight,selects)
	return straight;
end
--连对
function CardRule.FindDoubleStraightInSelectCard(allCards,selects)
	local doubleStraight = {}
	--找出selects里面最小的牌
	local minSelectCard = selects[1];
	for i=1,#selects-1 do
		if selects[i].weight <= selects[i+1].weight then
			minSelectCard = selects[i];
		else
			minSelectCard = selects[i+1];
		end
	end
	for i = 10,3,-1 do 
		local temp = CardRule.FindAllFindDoubleStraightFunc(allCards, i,minSelectCard.weight)
		for i=1,#temp do
			table.insert(doubleStraight,temp[i]);
		end
	end
	local recDelect = {}
	for i=1,#doubleStraight do
		print(doubleStraight[i][1].weight);
		for j=1,#selects do
			if CardRule.CardWeightContains(doubleStraight[i],selects[j]) == false then 
				table.insert(recDelect,i);
				break;
			end
		end
	end
	--删除不符合要求的连对
	for i=#recDelect,1,-1 do
		table.remove(doubleStraight,recDelect[i]); 
	end
	--测试打印所有连对
	for k,v in pairs(doubleStraight) do
		for i=1,#(doubleStraight[1]) do
		end
	end
	doubleStraight = CardRule.FindTheBestDoubleStraight(allCards,doubleStraight,selects);
	return doubleStraight;
end
function CardRule.FindThreeInSelectCard( allCards,selects )
	local onlyThreelist = {}
	local splits = CardRule.SplitCardsFunc(selects)
	for i=1,#splits do
		local temp = CardRule.FindOnlyThreeEqualFunc(allCards,splits[i].weight);
		if #temp~= 0 then
			table.insert(onlyThreelist,temp);
		end
	end
	return onlyThreelist;
end

function CardRule.FindTheBestStraight(allCards,straightList,selects)
	if straightList == nil or #straightList == 0 then return {} end;

	--找选中牌中最大的
	local maxSelectCard = selects[1];
	local minSelectCard = selects[1];
	for i=1,#selects-1 do
		if selects[i].weight >= selects[i+1].weight then
			maxSelectCard = clone(selects[i]);
			minSelectCard = clone(selects[i+1]);
		else
			maxSelectCard = clone(selects[i+1]);
			minSelectCard = clone(selects[i]);
		end
	end
	if maxSelectCard.weight - minSelectCard.weight < 5 then
		maxSelectCard.weight = minSelectCard.weight + 4 ;
	end
	--找出所有不是单张的牌
	local singleList = CardRule.SplitCardsFunc(allCards);
	for i=#singleList, 1,-1 do
		if singleList[i].count == 1 then 
			table.remove(singleList,i);
		end
	end
	--去掉小于等于选中牌中最大的 
	for i=#singleList,1,-1 do
		if singleList[i].weight <= maxSelectCard.weight then
			table.remove(singleList,i);
		end
	end
	local recDelect = {}; --记录要删除的顺子
	--筛选顺子
	for i=1,#straightList-1 do
			for j=1,#(straightList[i]) do
				local hasBreak = false;
				for k=1,#singleList do
					if straightList[i][j].weight == singleList[k].weight then
						table.insert(recDelect,i);
						hasBreak = true;
						break;
					end
				end
				if hasBreak == true then
					break;
				end
			end
	end
	--删除顺子
	for i=#recDelect,1,-1 do
		table.remove(straightList,recDelect[i]);
	end
	return straightList;
end
function CardRule.FindTheBestDoubleStraight(allCards,doubleStraightList,selects)
	if doubleStraightList == nil or #doubleStraightList == 0 then return {} end;

	--找选中牌中最大的
	local maxSelectCard = selects[1];
	local minSelectCard = selects[1];
	for i=1,#selects-1 do
		if selects[i].weight >= selects[i+1].weight then
			maxSelectCard = clone(selects[i]);
			minSelectCard = clone(selects[i+1]);
		else
			maxSelectCard = clone(selects[i+1]);
			minSelectCard = clone(selects[i]);
		end
	end
	if maxSelectCard.weight - minSelectCard.weight < 5 then
		maxSelectCard.weight = minSelectCard.weight + 4 ;
	end


	local split = CardRule.SplitCardsFunc(allCards);
	--剩下只有3条和4条的
	for i=#split, 1,-1 do
		if split[i].count <= 2 then 
			table.remove(split,i);
		end
	end
	--去掉小于等于选中牌中最大的
	for i=#split,1,-1 do
		if split[i].weight <= maxSelectCard.weight then
			table.remove(split,i);
		end
	end

	local recDelect = {}; --记录要删除的顺子
	--筛选顺子
	for i=1,#doubleStraightList-1 do
		for j=1,#(doubleStraightList[i]) do
			local hasBreak = false;
			for k=1,#split do
				if doubleStraightList[i][j].weight == split[k].weight then
					table.insert(recDelect,i);
					hasBreak = true;
					break;
				end
			end
			if hasBreak == true then
				break;
			end
		end
	end

	--删除顺子
	for i=#recDelect,1,-1 do
		table.remove(doubleStraightList,recDelect[i]);
	end
	return doubleStraightList;


end


--癞子

function CardRule.SetChangeCards(cards)
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	if #cards == 2 then

	elseif #cards == 3 then
		
	elseif #cards == 4 then
		
	elseif #cards == 5 then 
		
	end
end

function CardRule.TwoCards( cards )
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	local tempchange = clone(changeCard)
	if #tempchange == 1 then
		local temp = {}
		if nochange[1].weight<=Weight.Two then
			tempchange[1].oldweight = tempchange[1].weight
			tempchange[1].weight = nochange[1].weight
			table.insert(temp,nochange[1])
			table.insert(temp,tempchange[1])
			table.insert(allcase,temp)
		else
			return allcase
		end
		
	else
		if tempchange[1].weight == tempchange[2].weight then
			table.insert(allcase,tempchange)
		else
			local temp = {}
			tempchange[1].oldweight = tempchange[1].weight
			tempchange[1].weight = tempchange[2].weight 
			table.insert(temp,tempchange[1])
			table.insert(temp,tempchange[2])
			table.insert(allcase,temp)
		end
	end
	return allcase
end
function CardRule.ThreeCards(cards)
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	local tempchange = clone(changeCard)
	local temp = {}
	if #nochange>= 1 then
		for i=1,#tempchange do
			tempchange[i].oldweight = tempchange[i].weight
			tempchange[i].weight = nochange[1].weight
			table.insert(temp,tempchange[i])
		end
		for i=1,#nochange do
			table.insert(temp,nochange[i])
		end
		if CardRule.IsOnlyThree(temp) then
			table.insert(allcase,temp)
		end
		
	else
		--3个都是癞子
		local splits = CardRule.SplitCardsFunc(cards)
		if #splits == 1 then
			table.insert(allcase,tempchange)
		else

		end
	end
	return allcase
end
function CardRule.FourCards( cards )
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	--炸弹或3带一
	local tempchange = clone(changeCard)
	--炸弹
	if #nochange >= 1 then
		local can = true
		local temp = {}
		for i=1,#nochange do
			if i+1<=#nochange then
				if nochange[i].weight ~= nochange[i+1].weight then
					can = false
					break
				end
			end
			table.insert(temp,nochange[i])
		end
		if can == true then
			for i=1,#tempchange do
				tempchange[i].oldweight = tempchange[i].weight
				tempchange[i].weight = nochange[1].weight
				table.insert(temp,tempchange[i])
			end
			table.insert(allcase,temp)
		end
	else
		--4个都是癞子
		table.insert(allcase,tempchange)
	end
	tempchange = clone(changeCard)
	
	--3带一
	if #nochange ==1 then
		temp = {}
		for i=1,2 do
			tempchange[i].oldweight = tempchange[i].weight
			tempchange[i].weight = nochange[1].weight
			table.insert(temp,tempchange[i])
		end
		table.insert(temp,tempchange[3])
		table.insert(temp,nochange[1])
		if CardRule.IsThreeAndOne(temp) then
			table.insert(allcase,temp)
		end
	elseif #nochange == 2 then
		if nochange[1].weight == nochange[2].weight then
			temp = {}
			table.insert(temp,nochange[1])
			table.insert(temp,nochange[2])
			tempchange[1].oldweight = tempchange[1].weight
			tempchange[1].weight = nochange[1].weight
			table.insert(temp,tempchange[1])
			table.insert(temp,tempchange[2])
			if CardRule.IsThreeAndOne(temp) then
				table.insert(allcase,temp)
			end
		else
			--两个不相同，其中一个作为单
			temp = {}
			table.insert(temp,nochange[1])
			table.insert(temp,nochange[2])
			tempchange[1].oldweight = tempchange[1].weight
			tempchange[1].weight = nochange[1].weight
			tempchange[2].oldweight = tempchange[2].weight
			tempchange[2].weight = nochange[1].weight
			table.insert(temp,tempchange[1])
			table.insert(temp,tempchange[2])
			table.insert(allcase,temp)

			tempchange = clone(changeCard)
			temp = {}
			table.insert(temp,nochange[1])
			table.insert(temp,nochange[2])
			tempchange[1].oldweight = tempchange[1].weight
			tempchange[1].weight = nochange[2].weight
			tempchange[2].oldweight = tempchange[2].weight
			tempchange[2].weight = nochange[2].weight
			table.insert(temp,tempchange[1])
			table.insert(temp,tempchange[2])
			if CardRule.IsThreeAndOne(temp) then
				table.insert(allcase,temp)
			end
		end
	elseif #nochange == 3 then
		if nochange[1].weight == nochange[2].weight and nochange[1].weight == nochange[3].weight then
			tempchange = clone(changeCard)
			temp = {}
			table.insert(temp,nochange[1])
			table.insert(temp,nochange[2])
			table.insert(temp,nochange[3])
			table.insert(temp,tempchange[1])
			if CardRule.IsThreeAndOne(temp) then
				table.insert(allcase,temp)
			end
		elseif nochange[1].weight == nochange[2].weight or nochange[1].weight == nochange[3].weight then
			tempchange = clone(changeCard)
			temp = {}
			table.insert(temp,nochange[1])
			table.insert(temp,nochange[2])
			table.insert(temp,nochange[3])
			tempchange[1].oldweight = tempchange[1].weight
			tempchange[1].weight = nochange[1].weight
			table.insert(temp,tempchange[1])
			table.insert(allcase,temp)
		elseif nochange[2].weight == nochange[3].weight then
			tempchange = clone(changeCard)
			temp = {}
			table.insert(temp,nochange[1])
			table.insert(temp,nochange[2])
			table.insert(temp,nochange[3])
			tempchange[1].oldweight = tempchange[1].weight
			tempchange[1].weight = nochange[2].weight
			table.insert(temp,tempchange[1])
			if CardRule.IsThreeAndOne(temp) then
				table.insert(allcase,temp)
			end
		end
	end
	return allcase
end
function CardRule.FiveCards(cards)
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	--顺子，或3带2
	local tempchange = clone(changeCard)
	
	if #nochange == 1 then
		local temp = {}
		--3带2
		table.insert(temp,nochange[1])
		for i=1,2 do
			tempchange[i].oldweight = tempchange[i].weight
			tempchange[i].weight = nochange[1].weight
			table.insert(temp,tempchange[i])
		end
		table.insert(temp,tempchange[3])
		table.insert(temp,tempchange[4])
		if CardRule.IsThreeAndDouble(temp) then
			table.insert(allcase,temp)
		end

		tempchange = clone(changeCard)
		temp = {}
		for i=1,3 do
			table.insert(temp,tempchange[i])
		end
		tempchange[4].oldweight = tempchange.weight 
		tempchange[4].weight = nochange[1].weight
		table.insert(temp,tempchange[4])
		table.insert(temp,nochange[1])
		if CardRule.IsThreeAndDouble(temp) then
			table.insert(allcase,temp)
		end

		--顺子
		--[[
		if nochange[1].weight >= Weight.Seven and nochange[1].weight <= Weight.Ten then
			tempchange = clone(changeCard)
			temp = {}
			table.insert(temp,nochange[1])
			for i=1,5 do
				tempchange = clone(changeCard)
				temp = {}
				for j=1,#tempchange do
					tempchange[j].oldweight = tempchange[j].weight
					tempchange[j].weight = nochange[1].weight+j-i
					if tempchange[j].weight >= nochange[1].weight then
						tempchange[j].weight = tempchange[j].weight + 1
					end
					table.insert(temp,tempchange[j])
				end
				table.insert(temp,nochange[1])
				table.insert(allcase,temp)
			end
		elseif nochange[1].weight < Weight.Seven then
			for i=1,nochange[1].weight do
				tempchange = clone(changeCard)
				temp = {}
				for j=1,#tempchange do
					tempchange[j].oldweight = tempchange[j].weight
					tempchange[j].weight = nochange[1].weight + j - i
					if tempchange[j].weight >= nochange[1].weight then
						tempchange[j].weight = tempchange[j].weight + 1
					end
					table.insert(temp,tempchange[j])
				end
				table.insert(temp,nochange[1])
				table.insert(allcase,temp)
			end
		elseif nochange[1].weight > Weight.Ten then
			for i=1,Weight.One - nochange[i].weight + 1 do
				tempchange = clone(changeCard)
				temp = {}
				for j=1,#tempchange do
					tempchange[j].oldweight = tempchange.weight
					tempchange[j].weight = nochange[1].weight - 4 + j - i
					if tempchange[j].weight >= nochange[1].weight then
						tempchange[j].weight = tempchange[j].weight + 1
					end
					table.insert(temp,tempchange[j])
				end
				table.insert(temp,nochange[1])
				table.insert(allcase,temp)
			end
		end
		]]
	elseif #nochange == 2 then
		--3带2
		if nochange[1].weight == nochange[2].weight then
			--nochage作为一对
			tempchange = clone(changeCard)
			temp = {}
			for i=1,#nochange do
				table.insert(temp,nochange[i])
			end
			for i=1,#tempchange do
				table.insert(temp,tempchange[i])
			end
			table.insert(allcase,temp)

			--nocahge作为三条
			tempchange = clone(changeCard)
			temp = {}
			for i=1,#nochange do
				table.insert(temp,nochange[i])
			end
			for i=1,#tempchange-1 do
				table.insert(temp,tempchange[i])
			end
			tempchange[3].oldweight = tempchange[3].weight
			tempchange[3].weight = nochange[1].weight
			table.insert(temp,tempchange[3])
			if CardRule.IsThreeAndDouble(temp) then
				table.insert(allcase,temp)
			end
		else
			tempchange = clone(changeCard)
			temp = {}

			--3带2
			--nochange[1]作为3条
			for i=1,2 do
				tempchange[i].oldweight = tempchange[i].weight
				tempchange[i].weight = nochange[1].weight
				table.insert(temp,tempchange[i])
			end
			tempchange[3].oldweight = tempchange[3].weight 
			tempchange[3].weight = nochange[2].weight
			table.insert(temp,tempchange[3])
			table.insert(temp,nochange[1])
			table.insert(temp,nochange[2])
			if CardRule.IsThreeAndDouble(temp) then
				table.insert(allcase,temp)
			end

			--nochange[2]作为3条
			tempchange = clone(changeCard)
			temp = {}
			for i=1,2 do
				tempchange[i].oldweight = tempchange[i].weight
				tempchange[i].weight = nochange[2].weight
				table.insert(temp,tempchange[i])
			end
			tempchange[3].oldweight = tempchange[3].weight 
			tempchange[3].weight = nochange[1].weight
			table.insert(temp,tempchange[3])
			table.insert(temp,nochange[1])
			table.insert(temp,nochange[2])
			if CardRule.IsThreeAndDouble(temp) then
				table.insert(allcase,temp)
			end

			--顺子
			--[[
			if math.abs(nochange[2].weight - nochange[1].weight) <= 4 then
				local max,min
				if nochange[2].weight > nochange[1].weight then
					max = 2 
					min = 1
				else
					miax = 1
					min = 2
				end
				for i=1,4-nochange[max].weight + nochange[min].weight do
					tempchange = clone(changeCard)
					temp = {}
					for j=1,#tempchange do
						tempchange[j].oldweight = tempchange[j].weight
						tempchange[j].weight = nochange[min].weight + j -i
						--判断是否大于最小值
						if tempchange[j].weight > Weight.None then
							if tempchange.weight >= nochange[min].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							if tempchange[j].weight >= nochange[max].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							table.insert(temp,tempchange[j])
							
						end
					end
					--判断是否小于最大值 
					if tempchange[3].weight <= Weight.One then
						table.insert(temp,nochange[1])
						table.insert(temp,nochange[2])
						table.insert(allcase,temp)
					end
				end
			end
			]]
		end
	elseif #nochange == 3 then

		if nochange[1].weight == nochange[2].weight and nochange[2].weight == nochange[3].weight then
			tempchange = clone(changeCard)
			temp = {}
			for i=1,#nochange do
				table.insert(temp,nochange[i])
			end
			tempchange[1].oldweight = tempchange[1].weight
			tempchange[1].weight = tempchange[2].weight
			for i=1,#tempchange do
				table.insert(temp,tempchange[i])
			end
			if CardRule.IsThreeAndDouble(temp) then
				table.insert(allcase,temp)
			end
		elseif nochange[1].weight ~= nochange[2].weight and nochange[1].weight ~= nochange[3].weight and nochange[2].weight ~= nochange[3].weight then
			--三个都不相同，只能顺子
			--[[
			local maxWeight = math.max(nochange[1].weight,nochange[2].weight,nochange[3].weight)
			local minWeight = math.min(nochange[1].weight,nochange[2].weight,nochange[3].weight)

			if maxWeight - minWeight<= 4 then
				for i=1,5 - maxWeight + minWeight do
					tempchange = clone(changeCard)
					temp = {}
					for j=1,#tempchange do
						tempchange[j].oldweight = tempchange[j].weight
						tempchange[j].weight = minWeight + j -i
						--判断是否大于最小值
						if tempchange[j].weight > Weight.None then
							if tempchange[j].weight >= nochange[1].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							if tempchange[j].weight >= nochange[2].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							if tempchange[j].weight >= nochange[3].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							table.insert(temp,tempchange[j])
						end
					end
					--判断是否小于最大值 
					if tempchange[2].weight <= Weight.One then
						table.insert(temp,nochange[1])
						table.insert(temp,nochange[2])
						table.insert(temp,nochange[3])
						table.insert(allcase,temp)
					end
				end
			end
			]]
		else
			--两个相同
			local same1,same2,other
			if nochange[1].weight == nochange[2].weight then
				same1 = 1
				same2 = 2
				other = 3
			elseif nochange[1].weight == nochange[3].weight then
				same1 = 1 
				same2 = 3
				other = 2
			elseif nochange[2].weight == nochange[3].weight then 
				same1 = 2
				same2 = 3 
				other = 1
			end
			tempchange = clone(changeCard)
			temp = {}
			for i=1,#nochange do
				table.insert(temp,nochange[i])
			end
			tempchange[1].oldweight=tempchange[1].weight
			tempchange[1].weight = nochange[same1].weight
			tempchange[2].oldweight = tempchange[2].weight
			tempchange[2].weight = nochange[other].weight
			for i=1,#tempchange do
				table.insert(temp,tempchange[i])
			end
			table.insert(allcase,temp)

		end
	elseif #nochange == 4 then
		local splits = CardRule.SplitCardsFunc(nochange)
		--三带3
		if #splits == 2 then
			if splits[1].count == 3 or splits[2].count == 3 then
				tempchange = clone(changeCard)
				temp = {}
				for i=1,#nochange do
					table.insert(temp,nochange[i])
				end
				local singlecard 
				if splits[1].count == 1 then
					singlecard = splits[1].cards[1]
				else
					singlecard = splits[2].cards[1]
				end
				tempchange[1].oldweight = tempchange[1].weight
				tempchange[1].weight = singlecard.weight
				table.insert(temp,tempchange[1])
				if CardRule.IsThreeAndDouble(temp) then
					table.insert(allcase,temp)
				end
			elseif splits[1].count == 2 and splits[2].count == 2 then
				--第一个为三张
				tempchange = clone(changeCard)
				temp = {}
				for i=1,#nochange do
					table.insert(temp,nochange[i])
				end

				tempchange[1].oldweight = tempchange[1].weight
				tempchange[1].weight = splits[1].weight
				table.insert(temp,tempchange[1])
				if CardRule.IsThreeAndDouble(temp) then
					table.insert(allcase,temp)
				end

				--第二个为三张
				tempchange = clone(changeCard)
				temp = {}
				for i=1,#nochange do
					table.insert(temp,nochange[i])
				end

				tempchange[1].oldweight = tempchange[1].weight
				tempchange[1].weight = splits[2].weight
				table.insert(temp,tempchange[1])
				if CardRule.IsThreeAndDouble(temp) then
					table.insert(allcase,temp)
				end
			end

		elseif #splits == 4 then
			--顺子 
			--[[
			local maxWeight = math.max(nochange[1].weight,nochange[2].weight,nochange[3].weight,nochange[4].weight)
			local minWeight = math.min(nochange[1].weight,nochange[2].weight,nochange[3].weight,nochange[4].weight)
			if maxWeight - minWeight <= 4 then
				for i=1,5 - maxWeight + minWeight do
					tempchange = clone(changeCard)
					temp = {}
					for j=1,#tempchange do
						tempchange[j].oldweight = tempchange[j].weight
						tempchange[j].weight = minWeight + j -i
						--判断是否大于最小值
						if tempchange[j].weight > Weight.None then
							if tempchange[j].weight >= nochange[1].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							if tempchange[j].weight >= nochange[2].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							if tempchange[j].weight >= nochange[3].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							if tempchange[j].weight >= nochange[4].weight then
								tempchange[j].weight = tempchange[j].weight + 1
							end
							table.insert(temp,tempchange[j])
						end
					end
					--判断是否小于最大值 
					if tempchange[1].weight <= Weight.One then
						for i=1,#nochange do
							table.insert(temp,nochange[i])
						end
						table.insert(allcase,temp)
					end
				end
			end
			]]
		end
	end
	local straightlist = CardRule.SetChangeCardsToStraight(cards)
	for i=1,#straightlist do
		table.insert(allcase,straightlist[i])
	end

	return allcase
end
function CardRule.SixCards( cards )
	--[[
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	--飞机不带，连对，顺子,4带2
	local tempchange = {}
	local temp ={}
	if #changeCard == 1 then
		local splits = CardRule.SplitCardsFunc(nochange)
		if #splits == 2 then
			--可作为飞机不带
			if splits[1].count == 3 or splits[2].count == 3 then
				if splits[1].cards[1].weight + 1 == splits[2].cards[1].weight and splits[2].cards[1].weight > Weight.Two then
					tempchange = clone(changeCard)
					for i=1,#nochange do
						table.insert(temp,nochange[i])
					end
					if splits[1].count == 2 then
						tempchange[1].oldweight = tempchange[1].weight 
						tempchange[1].weight = splits[1].cards[1].weight
					else
						tempchange[1].oldweight = tempchange[1].weight 
						tempchange[1].weight = splits[2].cards[1].weight
					end
					table.insert(temp,tempchange[1])
				end
				table.insert(allcase,temp)
			end
		elseif #splits == 3 then
			--连对
			if splits[1].cards[1].weight + 1 == splits[2].cards[1].weight and splits[2].cards[1].weight + 1 == splits[3].cards[1].weight
	 		  and splits[3].cards[1].weight < Weight.Two and splits[1].count<= 2 and splits[2].count<= 2 and splits[3].count<= 2 then
			 	tempchange = clone(changeCard)
			 	temp ={}
			 	local single
			 	if splits[1].count == 1 then
			 		single = splits[1].cards[1]
		 		elseif splits[2].count == 1 then
		 			single = splits[2].cards[1]
		 		else
		 			single = splits[3].cards[1]
		 		end
		 		tempchange[1].oldweight = tempchange[1].weight
		 		tempchange[1].weight = single.weight
		 		table.insert(temp,tempchange[1])
		 		for i=1,#nochange do
					table.insert(temp,nochange[i])
				end
				table.insert(allcase,temp)
			elseif splits[1].count == 3 or splits[2].count == 3 or splits[3].count == 3 then
				--4带2
				tempchange = clone(changeCard)
			 	temp ={}
			 	for i=1,#nochange do
					table.insert(temp,nochange[i])
				end
				local three
				if splits[1].count == 3 then
					three = splits[1].cards[1]
				elseif splits[2].count == 3 then
					three = splits[2].cards[1]
				else
					three = splits[3].cards[1]
				end
				tempchange[1].oldweight = tempchange[1].weight
				tempchange[1].weight = three.weight 
				table.insert(temp,tempchange[1])
				table.insert(allcase,temp)
			elseif splits[1].count == 4 or splits[2].count == 4 or splits[3].count == 4 then
				--4带2
				tempchange = clone(changeCard)
			 	temp ={}
			 	for i=1,#nochange do
					table.insert(temp,nochange[i])
				end
				table.insert(temp,tempchange[1])
				table.insert(allcase,temp)

			end
		elseif #splits == 5 then
			--顺子
			local straightlist = CardRule.SetChangeCardsToStraight(cards)
			for i=1,#straightlist do
				table.insert(allcase,straightlist[i])
			end
		end
	end
	return allcase
	]]
	local allcase = {}
	--连对
	local doubleStraightList = CardRule.SetChangeCardsToDoubleStraight(cards)
	for i=1,#doubleStraightList do
		table.insert(allcase,doubleStraightList[i])
	end
	--顺子
	local straightlist = CardRule.SetChangeCardsToStraight(cards)
	for i=1,#straightlist do
		table.insert(allcase,straightlist[i])
	end
	--飞机带两单
	return allcase
end
function CardRule.SevenCards(cards)
	return CardRule.SetChangeCardsToStraight(cards)
end
function CardRule.EightCards(cards)
	--飞机带两单，连对，顺子
	--连对
	local allcase = {}
	--连对
	local doubleStraightList = CardRule.SetChangeCardsToDoubleStraight(cards)
	for i=1,#doubleStraightList do
		table.insert(allcase,doubleStraightList[i])
	end
	--顺子
	local straightlist = CardRule.SetChangeCardsToStraight(cards)
	for i=1,#straightlist do
		table.insert(allcase,straightlist[i])
	end
	--飞机带两单
	return allcase
end
function CardRule.ChangeFunc( cards )
	local allcase = {}

	if #cards>5 then
		--顺子
		local tempcards = clone(cards) 
		local straightlist = CardRule.SetChangeCardsToStraight(tempcards)
		for i=1,#straightlist do
			table.insert(allcase,straightlist[i])
		end
	end

	if #cards>=6 and #cards%2 == 0 then
		--连对
		local tempcards = clone(cards) 
		local doubleStraightList = CardRule.SetChangeCardsToDoubleStraight(tempcards)
		for i=1,#doubleStraightList do
			table.insert(allcase,doubleStraightList[i])
		end
	end
	if #cards == 4 then
		local tempcards = clone(cards) 
		local boomlist = CardRule.SetChangeToBoom(tempcards)
		table.insert(allcase,boomlist)
	end

	if #cards >= 6 and #cards%3 == 0 then
		local tempcards = clone(cards) 
		local tripleStraight = CardRule.SetChangeToTripleStraight(tempcards)
		for i=1,#tripleStraight do
			table.insert(allcase,tripleStraight[i])
		end
		
	end
	if #cards == 6 then
		local tempcards = clone(cards) 
		local fourandsingle = CardRule.SetChangeToBoomWithOne(tempcards)
		for i=1,#fourandsingle do
			table.insert(allcase,fourandsingle[i])
		end
	end
	if #cards == 8 then
		local tempcards = clone(cards) 
		local fouranddouble = CardRule.SetChangeToBoomWithDouble(tempcards)
		for i=1,#fouranddouble do
			table.insert(allcase,fouranddouble[i])
		end
	end
	if #cards >= 8 and #cards%4 == 0 then
		local tempcards = clone(cards) 
		local tripleStraight = CardRule.SetChangeToTripleStraightWithOne(tempcards)
		for i=1,#tripleStraight do
			table.insert(allcase,tripleStraight[i])
		end
	end
	if #cards >= 10 and #cards%5 == 0 then
		local tempcards = clone(cards) 
		local tripleStraight = CardRule.SetChangeToTripleStraightWithDouble(tempcards)
		for i=1,#tripleStraight do
			table.insert(allcase,tripleStraight[i])
		end
	end
	return allcase
end

function CardRule.FindMaxWeight(cards)
	local max = cards[1].weight
	for i=2,#cards do
		if cards[i].weight > max then
			max = cards[i].weight
		end
	end
	return max
end
function CardRule.FindMinWeight(cards)
	local min = cards[1].weight
	for i=2,#cards do
		if cards[i].weight < min then
			min = cards[i].weight
		end
	end
	return min
end
--顺子
function CardRule.SetChangeCardsToStraight(cards)

	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	if #nochange == 0 then return allcase end 
	local maxWeight = CardRule.FindMaxWeight(nochange)
	local minWeight = CardRule.FindMinWeight(nochange)
	local tempchange = {}
	local temp = {}
	local splits = CardRule.SplitCardsFunc(nochange)
	if #splits ~= #nochange then return allcase end
	if maxWeight - minWeight <= #cards-1 then
		for i=1,#cards - maxWeight + minWeight do
			tempchange = clone(changeCard)
			temp = {}
			for j=1,#tempchange do
				tempchange[j].oldweight = tempchange[j].weight
				tempchange[j].weight = minWeight + j -i
				--判断是否大于最小值
				if tempchange[j].weight > Weight.None then
					for k=1,#nochange do
						if tempchange[j].weight >= nochange[k].weight then
							tempchange[j].weight = tempchange[j].weight + 1
						end
					end
					table.insert(temp,tempchange[j])
				end
			end
			--判断是否小于最大值 
			if tempchange[#tempchange].weight <= Weight.One then
				for i=1,#nochange do
					table.insert(temp,nochange[i])
				end
				if #temp == #cards then
					table.insert(allcase,temp)
				end
			end
		end
	end
	return allcase
end
--双顺
function CardRule.SetChangeCardsToDoubleStraight(cards)
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	local splits = CardRule.SplitCardsFunc(nochange)
	local length = #cards/2
	if #splits > length then return allcase end
	local tempweight = {}
	local changeNum = 1
	for i=1,#splits do
		if splits[i].count ~= 2 then
			if splits[i].count == 1 and #changeCard >= changeNum then
				changeCard[changeNum].oldweight = changeCard[changeNum].weight
				changeCard[changeNum].weight = splits[i].cards[1].weight

				table.insert(nochange,changeCard[changeNum])
				changeNum = changeNum+1
			else
				return allcase
			end
		else
			--error("没毛病")
		end
	end
	for i=changeNum-1,1,-1 do
		table.remove(changeCard,i)
	end
	if #changeCard == 0 then
		if CardRule.IsDoubleStraight(nochange) then
			table.insert(allcase,nochange)
			return allcase
		else
			return {}
		end
	end
	local maxWeight = CardRule.FindMaxWeight(nochange)
	local minWeight = CardRule.FindMinWeight(nochange)

	local tempchange = clone(changeCard)
	if #tempchange%2 ~= 0 then return allcase end
	local temp = {}
	if maxWeight - minWeight <= length-1 then
		for i=1,length - maxWeight + minWeight do
			tempchange = clone(changeCard)
			temp = {}
			for j=1,#tempchange/2 do
				tempchange[j*2-1].oldweight = tempchange[j*2-1].weight
				tempchange[j*2-1].weight = minWeight + j -i
				--判断是否大于最小值
				if tempchange[j*2-1].weight > Weight.None then
					for k=1,#nochange do
						if tempchange[j*2-1].weight == nochange[k].weight then
							tempchange[j*2-1].weight = tempchange[j*2-1].weight + 1
						end
					end

					table.insert(temp,tempchange[j*2-1])
				end
				tempchange[j*2].oldweight = tempchange[j*2].weight
				tempchange[j*2].weight = tempchange[j*2-1].weight
				
				table.insert(temp,tempchange[j*2])
			end
			--判断是否小于最大值 
			if #tempchange == 0 or tempchange[#tempchange].weight <= Weight.One then
				for i=1,#nochange do
					table.insert(temp,nochange[i])
				end
				if #temp == #cards then
					table.insert(allcase,temp)
				end
			end
		end
	end
	return allcase
end
--三顺
function CardRule.SetChangeToTripleStraight(cards)
	local allcase = {}
	if #cards%3 ~= 0 then return allcase end
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	local splits = CardRule.SplitCardsFunc(nochange)
	local length = #cards/3
	local changeNum = 0
	local tempchange = clone(changeCard)
	--先补全3张
	for i=1,#splits do
		if splits[i].count == 1 then
			if #tempchange >= changeNum+2 then
				tempchange[changeNum+1].oldweight = tempchange[changeNum+1].weight
				tempchange[changeNum+1].weight = splits[i].weight
				tempchange[changeNum+2].oldweight = tempchange[changeNum+2].weight
				tempchange[changeNum+2].weight = splits[i].weight
				changeNum = changeNum + 2
			else
				return allcase
			end
		elseif splits[i].count == 2 then
			if #tempchange >= changeNum+1 then
				tempchange[changeNum+1].oldweight = tempchange[changeNum+1].weight
				tempchange[changeNum+1].weight = splits[i].weight
				changeNum = changeNum + 1
			else
				return allcase
			end
		end
	end
	for i=changeNum,1,-1 do
		table.remove(changeCard,i)
	end
	if #changeCard == 0 then
		local temp = {}
		for i=1,#tempchange do
			table.insert(temp,tempchange[i])
		end
		for i=1,#nochange do
			table.insert(temp,nochange[i])
		end
		
		if CardRule.IsTripleStraight(temp) then
			table.insert(allcase,temp)
			return allcase
		else
			return {}
		end
	end

	local maxWeight = CardRule.FindMaxWeight(nochange)
	local minWeight = CardRule.FindMinWeight(nochange)

	local tempchange = clone(changeCard)
	if #tempchange%3 ~= 0 then return allcase end
	local temp = {}
	if maxWeight - minWeight <= length-1 then
		for i=1,length - maxWeight + minWeight do
			tempchange = clone(changeCard)
			temp = {}
			for j=1,#tempchange/3 do

				tempchange[j*3-2].oldweight = tempchange[j*3-2].weight
				tempchange[j*3-2].weight = minWeight + j -i
				--判断是否大于最小值
				if tempchange[j*3-2].weight > Weight.None then
					for k=1,#nochange do
						if tempchange[j*3-2].weight == nochange[k].weight then
							tempchange[j*3-2].weight = tempchange[j*3-2].weight + 1
						end
					end

					table.insert(temp,tempchange[j*3-2])
				end

				tempchange[j*3-1].oldweight = tempchange[j*3-1].weight
				tempchange[j*3-1].weight = minWeight + j -i
				--判断是否大于最小值
				if tempchange[j*3-1].weight > Weight.None then
					for k=1,#nochange do
						if tempchange[j*3-1].weight >= nochange[k].weight then
							tempchange[j*3-1].weight = tempchange[j*3-1].weight + 1
						end
					end

					table.insert(temp,tempchange[j*3-1])
				end
				tempchange[j*3].oldweight = tempchange[j*3].weight
				tempchange[j*3].weight = minWeight + j -i
				for k=1,#nochange do
					if tempchange[j*3].weight >= nochange[k].weight then
						tempchange[j*3].weight = tempchange[j*3].weight + 1
					end
				end
				table.insert(temp,tempchange[j*3])
			end
			--判断是否小于最大值 
			if #tempchange == 0 or tempchange[#tempchange].weight <= Weight.One then
				for i=1,#nochange do
					table.insert(temp,nochange[i])
				end
				if #temp == #cards and CardRule.IsTripleStraight(temp) then
					table.insert(allcase,temp)
				end
			end
		end
	end

	return allcase
end
--飞机带单
function CardRule.SetChangeToTripleStraightWithOne(cards)

	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	if #cards%4~= 0 then return allcase end
	local length = #cards/4 

	--先找出顺子，然后再补全三只

	local maxWeight = CardRule.FindMaxWeight(nochange)
	local minWeight = CardRule.FindMinWeight(nochange)
	local temp = {}
	local splits = CardRule.SplitCardsFunc(nochange)
	local allsplits = CardRule.SplitCardsFunc(cards)

	if #allsplits > length *2 + 1 then
		return allcase
	end
	local straightList = {}
	for z = 1 ,#allsplits do
		minWeight = allsplits[z].weight
		for i=1,length do
			temp = {}
			for j=1,length do
				if minWeight + j - i > Weight.None and minWeight + j - i <= Weight.One then
					table.insert(temp,j-i+minWeight)
				else
					break
				end
			end
			if #temp == length then
				--去掉重复的组合
				local hasinlist = false
				for j=1,#straightList do
					local has = true
					for k=1,#temp do
						if tableContains(straightList[j],temp[k]) == false then
							has = false
							break
						end 
					end
					if has == true then
						hasinlist = true
						break
					end
				end
				if hasinlist == false then
					table.insert(straightList,temp)
				end
			end
		end
	end
	for i=1,#straightList do
		--补全3个
		local tempchange = clone(changeCard)
		local changeNum = 0
		local temptriple = {}
		local cannot = false
		for j=1,#straightList[i] do
			local has = false
			for k=1,#splits do
				if straightList[i][j] == splits[k].weight then
					has = true
					if #tempchange >= changeNum + 3 - splits[k].count then
						for z=1,3 - splits[k].count do
							tempchange[changeNum+z].oldweight = tempchange[changeNum+z].weight
							tempchange[changeNum+z].weight = straightList[i][j]
						end
						changeNum = changeNum+3-splits[k].count
					else
						cannot = true
						break
					end
				end
			end
			if has == false then
				if #tempchange >= changeNum + 3 then
					for k=1,3 do
						tempchange[changeNum+k].oldweight = tempchange[changeNum+k].weight
						tempchange[changeNum+k].weight = straightList[i][j]
					end
					changeNum = changeNum + 3
				else
					cannot = true
				end
			end
			
		end
		if cannot == false then
			for k=1,#nochange do
				table.insert(temptriple,nochange[k])
			end
			for k=1,#tempchange do
				table.insert(temptriple,tempchange[k])
			end
			if CardRule.IsTripleStraightAndSingle(temptriple) then
				table.insert(allcase,temptriple)
			end
		end
	end
	return allcase

end



--飞机带双
function CardRule.SetChangeToTripleStraightWithDouble(cards)

	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	if #cards%5~= 0 then return allcase end
	local length = #cards/5 

	--先找出顺子，然后再补全三只

	local maxWeight = CardRule.FindMaxWeight(nochange)
	local minWeight = CardRule.FindMinWeight(nochange)
	local temp = {}
	local splits = CardRule.SplitCardsFunc(nochange)
	local allsplits = CardRule.SplitCardsFunc(cards)
	local straightList = {}
	if #allsplits > length *2 + 1 then
		return allcase
	end
	for z = 1 ,#allsplits do
		minWeight = allsplits[z].weight
		for i=1,length do
			temp = {}
			for j=1,length do
				if minWeight + j - i > Weight.None and minWeight + j - i <= Weight.One then
					table.insert(temp,j-i+minWeight)
				else
					break
				end
			end
			if #temp == length then
				local hasinlist = false
				for j=1,#straightList do
					local has = true
					for k=1,#temp do
						if tableContains(straightList[j],temp[k]) == false then
							has = false
							break
						end 
					end
					if has == true then
						hasinlist = true
						break
					end
				end
				if hasinlist == false then
					table.insert(straightList,temp)
				end
			end
		end
	end

	
	for i=1,#straightList do
		--补全3个
		local tempchange = clone(changeCard)
		local changeNum = 0
		local temptriple = {}
		local cannot = false

		for j=1,#straightList[i] do
			local has = false
			for k=1,#splits do
				if straightList[i][j] == splits[k].weight then
					has = true
					if #tempchange >= changeNum + 3 - splits[k].count then
						for z=1,3 - splits[k].count do
							tempchange[changeNum+z].oldweight = tempchange[changeNum+z].weight
							tempchange[changeNum+z].weight = straightList[i][j]
						end
						changeNum = changeNum+3-splits[k].count
					else
						cannot = true
						break
					end
				end
			end
			if has == false then
				if #tempchange >= changeNum + 3 then
					for k=1,3 do
						tempchange[changeNum+k].oldweight = tempchange[changeNum+k].weight
						tempchange[changeNum+k].weight = straightList[i][j]
					end
					changeNum = changeNum + 3
				else
					cannot = true
				end
			end
		end
		for k=1,#splits do
			if tableContains(straightList[i],splits[k].weight) == false then
				if splits[k].count == 1 then 
					if #tempchange >= changeNum + 1 then
						changeNum = changeNum+1
						tempchange[changeNum].oldweight = tempchange[changeNum].weight
						tempchange[changeNum].weight = splits[k].weight
					else
						cannot = true
						break
					end
				end 
			end
		end	
		if cannot == false then
			for k=1,#nochange do
				table.insert(temptriple,nochange[k])
			end
			for k=1,#tempchange do
				table.insert(temptriple,tempchange[k])
			end
			if CardRule.IsTripleStraightAndDouble(temptriple) then
				table.insert(allcase,temptriple)
			end
		end
	end
	
	return allcase
end
--炸弹
function CardRule.SetChangeToBoom(cards)
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	--炸弹或3带一
	local tempchange = clone(changeCard)
	--炸弹
	if #nochange >= 1 then
		local can = true
		local temp = {}
		for i=1,#nochange do
			if i+1<=#nochange then
				if nochange[i].weight ~= nochange[i+1].weight then
					can = false
					break
				end
			end
			table.insert(temp,nochange[i])
		end
		if can == true then
			for i=1,#tempchange do
				tempchange[i].oldweight = tempchange[i].weight
				tempchange[i].weight = nochange[1].weight
				table.insert(temp,tempchange[i])
			end
			table.insert(allcase,temp)
		end
	else
		--4个都是癞子
		table.insert(allcase,tempchange)
	end
	return allCards
end

function CardRule.SetChangeToBoomWithOne(cards)
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	local splits = CardRule.SplitCardsFunc(nochange)
	if CardRule.IsFoureAndSingle(cards) then
		table.insert(allcase,cards)
	end
	for i=1,#splits do
		if #changeCard >= 4-splits[i].count then
			local tempchange = clone(changeCard)
			for j=1,4-splits[i].count do
				tempchange[j].oldweight = tempchange[j].weight
				tempchange[j].weight = splits[i].weight
			end
			local temp = {}
			for j=1,#tempchange do
				table.insert(temp,tempchange[j])
			end
			for j=1,#nochange do
				table.insert(temp,nochange[j])
			end
			if CardRule.IsFoureAndSingle(temp) then
				table.insert(allcase,temp)
			end
		end
	end
	return allcase
end
function CardRule.SetChangeToBoomWithDouble(cards)
	local allcase = {}
	local changeCard = CardRule.FindChangeCardInCards(cards)
	local nochange = {}
	for i=1,#cards do
		if CardRule.CardWeightContains(changeCard,cards[i]) == false then
			table.insert(nochange,cards[i])
		end
	end
	local splits = CardRule.SplitCardsFunc(nochange)
	if CardRule.IsFoureAndDouble(cards) then
		table.insert(allcase,cards)
	end
	for i=1,#splits do
		local changeNum = 0 
		if #changeCard >= 4-splits[i].count then
			changeNum = changeNum + 4-splits[i].count
			local tempchange = clone(changeCard)
			for j=1,4-splits[i].count do
				tempchange[j].oldweight = tempchange[j].weight
				tempchange[j].weight = splits[i].weight
			end
			for j=1,#splits do
				if i ~= j then
					if splits[j].count == 1 and #changeCard>=changeNum+1 then
						tempchange[changeNum+1].oldweight = tempchange[changeNum+1].weight
						tempchange[changeNum+1].weight = splits[j].weight
						changeNum = changeNum + 1
					end
				end
			end


			local temp = {}
			for j=1,#tempchange do
				table.insert(temp,tempchange[j])
			end
			for j=1,#nochange do
				table.insert(temp,nochange[j])
			end
			if CardRule.IsFoureAndDouble(temp) then
				table.insert(allcase,temp)
			end

		end
	end
	return allcase
end

