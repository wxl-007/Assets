
DeskCardsCache = {}

local self = DeskCardsCache

self.library = {} 
self.CardType = CardsType.None
self.CardLength = 0

local remainCards = {} --未打出的牌，包括弃牌和手牌 用于记牌器
function DeskCardsCache.GetLibrary()
	return self.library
end 


function DeskCardsCache.GetCardsCount()
	return #self.library
end

--获取桌面牌权重值
function  DeskCardsCache.GetWeight()
	local weight = CardRule.GetWeight(self.library, self.CardType)
	return weight
end 
--向牌库中添加牌
function DeskCardsCache.AddCard(card)
	table.insert(self.library,card)
end 
--排序
function DeskCardsCache.SortCard()
	self.library = CardRule.SortCardsFunc(self.library)
end 
function DeskCardsCache.AllClear()
	self.library = {} 
	Player.ClearDealCard()
	Player.HidenNotice()
	
	Computer.ClearDealCard()
	Computer.HidenNotice()
	if LRDDZ_Game.gameType == DDZGameType.Three then
		OtherComputer.ClearDealCard()
		OtherComputer.HidenNotice()
	end
	--
	--CharacterPlayer.ClearPokers()
	--CharacterComputer.ClearPokers()
end 
function DeskCardsCache.ClearSomeone(character)
	if character == CharacterType.Player then
		Player.ClearDealCard()
		Player.HidenNotice()
	elseif character == CharacterType.Computer then
		Computer.ClearDealCard()
		Computer.HidenNotice()
	elseif character == CharacterType.OtherComputer then
		OtherComputer.ClearDealCard()
		OtherComputer.HidenNotice()
	end
end
function DeskCardsCache.ClearRecord()
	self.library = {}
	self.CardType = CardsType.None
end
function DeskCardsCache.RemainCards(cards)
	if cards ~= nil then
		remainCards = cards
	else
		return remainCards
	end
end
function DeskCardsCache.RemoveCardsInRemainCards(cards)
	for i=1,#cards do
		for j=1,#remainCards do
			if cards[i].weight == remainCards[j].weight and cards[i].suits == remainCards[j].suits then
				table.remove(remainCards,j);
				break
			end
		end
	end
	Event.Brocast(GameEvent.NoteCard)
end