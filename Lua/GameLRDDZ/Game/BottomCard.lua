BottomCard = {}
local self = BottomCard

self.library = {}

self.ctype = CharacterType.Bottom
function BottomCard.GetLibrary()
	return self.library
end 
function BottomCard.SetLibrary(cards)
	self.library = cards;
	BottomCard.SortCard()
end
--获取手牌张数
function BottomCard.GetCardsCount()
	return #self.library
end

function BottomCard.GetCardFromIndex(index)
	return self.library[index]
end 
--出牌
function BottomCard.PopCard(card)
	table.remove(self.library,card)
end 
--发牌
function BottomCard.Deal()
	local card = self.library[#self.library]
	table.remove(self.library,#self.library)
	return card
end 
--向牌库中添加牌
function BottomCard.AddCard(card)
	card.charactortype = self.ctype
	table.insert(self.library,card)
end 
--排序
function BottomCard.SortCard()
	self.library = CardRule.SortCardsFunc(self.library)
end 
function BottomCard.Clear()
	self.library = {}
end 