HPSKCardRule = {}

--卡牌数组排序
--descending == true  降序
function HPSKCardRule.SortCardsFunc(cardList,descending)
	local function sortFunc(card1,card2)
		if card1.weight == card2.weight then
			return card1.Card >  card2.Card;
		else 
			if descending == true then --如果降序排列
				return card1.weight > card2.weight
			else 
				return card1.weight < card2.weight;
			end 
		end 
	end 
	table.sort( cardList, sortFunc)
	return cardList
end 
