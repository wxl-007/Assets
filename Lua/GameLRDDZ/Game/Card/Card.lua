--牌的基础数据
Card = {}
function Card.New(name,weight, suits,charactortype)
	local card = {}
	card.cardName = name
	card.weight = weight
	card.suits = suits
	card.charactortype = charactortype
	card.oldweight = Weight.None--癞子，原来的weight
	return card
end 

--拆分牌的基础数据
SplitCards = {}
function SplitCards.New()
	local split = {}
	split.weight = 0
	split.count = 0
	split.cards = {}
	return split
end 

