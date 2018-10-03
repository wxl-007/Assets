CardBottomRule = {}

--是否有双王
function CardBottomRule.IsHasDoubleJoker(cards)
	local count = 0
	for i =1, #cards do 
		if cards[i].weight ==  Weight.LJoker or cards[i].weight == Weight.SJoker then 
			count = count +1
		end 
	end
	if count == 2 then
		return true
	else
		return false
	end 
end 

--是否有单王
function CardBottomRule.IsHasSingleJoker(cards)
	local count = 0
	for i =1, #cards do 
		if cards[i].weight ==  Weight.LJoker or cards[i].weight == Weight.SJoker then 
			count = count +1
		end 
	end 
	if count == 1 then
		return true
	else
		return false
	end
end 
--是否有对2
function CardBottomRule.IsHasDoubleTwo(cards)
	local count = 0 
	for i=1,#cards do
		if cards[i].weight == Weight.Two then
			count = count + 1
		end
	end
	if count == 2 then
		return true
	else
		return false
	end
end 
function CardBottomRule.IsHasDouble(cards)
	local count = 0 
	for i=1,#cards-1 do
		if cards[i].weight == cards[i+1] then
			count = count +1
		end
	end
	if cards[1].weight == cards[3].weight then
		count = count + 1
	end
	if count == 1 then
		return true
	else
		return false
	end
end
--是否有顺子
function CardBottomRule.IsHasDearFriend(cards)
	local newcards = CardRule.SortCardsFunc(cards)
	if #newcards == 3 then 
		if newcards[1].weight+1 == newcards[2].weight and newcards[2].weight+1 == newcards[3].weight then 
			return true 
		end 
	end 
	return false 
end 
--是否有同花
function CardBottomRule.IsHasSameFlowers(cards)
	if #cards == 3 then 
		if cards[1].suits == cards[2].suits and cards[2].suits == cards[3].suits then 
			return true 
		end 
	end 
	return false 
end 
--是否有3条
function CardBottomRule.IsHasThree(cards)
	if #cards == 3 then 
		if cards[1].weight == cards[2].weight and cards[2].weight == cards[3].weight then 
			return true 
		end 
	end 
	return false 
end 
function CardBottomRule.IsHasSingleTwo(cards)
	local count = 0 
	for i=1,#cards do
		if cards[i].weight == Weight.Two then
			count = count + 1
		end
	end
	if count == 1 then
		return true
	else
		return false
	end
end

function CardBottomRule.CalculationBottomMultiples(cards,hidedouble)
	----是否有双王
	if hidedouble == 1 then return "1倍" end
	if CardBottomRule.IsHasDoubleJoker(cards) then 
		--self.set_dipai_multiple(4)
		return "双王×"..hidedouble.."倍"
	end 
	--是否有单王
    if CardBottomRule.IsHasSingleJoker(cards) then 
    	--self.set_dipai_multiple(2)
    	return "单王×"..hidedouble.."倍"
    end 
    --是否有对2
    if CardBottomRule.IsHasDoubleTwo(cards) then 
    	--self.set_dipai_multiple(2)
    	return "对2×"..hidedouble.."倍"
    end
    --是否有顺子
    if CardBottomRule.IsHasDearFriend(cards) then 
    	--self.set_dipai_multiple(3)
    	return "顺子×"..hidedouble.."倍"
	end

	--是否有同花
	if CardBottomRule.IsHasSameFlowers(cards)  then 
		--self.set_dipai_multiple(3)
		return "同花×"..hidedouble.."倍"
	end

	--是否有3条
	if CardBottomRule.IsHasThree(cards) then 
		--self.set_dipai_multiple(3)
		return "三条×"..hidedouble.."倍"
	end 
	if CardBottomRule.IsHasDouble(cards) then
		return "一对×"..hidedouble.."倍"
	end
	--[[
	if CardBottomRule.IsHasSingleTwo(cards) then
		return "单2×2倍"
	end
	]]
	return hidedouble.."倍"
end 
