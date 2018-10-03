Deck = {}

local self = Deck

self.library = {} 

self.ctype = CharacterType.Library
function Deck.GetLibrary()
	return self.library
end 

function Deck.GetCardsCount()
	return #self.library
end

--创建一副牌
function Deck.CreateDeck()
		Deck.Clear()
		for _key,_value in pairs(Weight) do 
			if _value ~= Weight.None and _value ~= Weight.SJoker and  _value ~= Weight.LJoker then 
				for k,v in pairs(Suits) do 
					if v ~= Suits.None and v ~= Suits.LaiZi then 
						local wegiht = _value
						local suit = v
						local name = k.._key
						local card = Card.New(name,wegiht, suit,self.ctype)
						table.insert(self.library,card)
					end 
				end 
			end 
		end 

		local sJoker = Card.New("SJoker",Weight.SJoker, Suits.None,self.ctype)
		local lJoker = Card.New("LJoker",Weight.LJoker, Suits.None,self.ctype)
		table.insert(self.library,sJoker)
		table.insert(self.library,lJoker)
end 
--创建一副白牌
function Deck.CreateWhiteDeck()
	for i=1,46 do
		local card = Card.New("SJoker",Weight.SJoker,Suits.None,self.ctype);
		table.insert(self.library,card);
	end
end
--发指定的牌
function Deck.DealToPlayer(weight,suits)
	for i = 1, #self.library do 
		if self.library[i].weight == weight and self.library[i].suits == suits then 
			local card = self.library[i]
			table.remove(self.library,i)
			return card
		end 
	end 
end 
--洗牌
function Deck.Shuffle()
	if self.GetCardsCount() == 46 then 
		math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
		local newLi = {}

		for i = 1, #self.library do 
			if #newLi < 1 then 
				table.insert(newLi, self.library[i])
			else  
				local num = math.random(#newLi)
				table.insert(newLi,num,self.library[i])
			end 
		end 
		self.library = newLi;
	end 
end 

--发牌
function Deck.Deal()
	local card = self.library[#self.library]
	table.remove(self.library,#self.library)
	return card
end 
--向牌库中添加牌
function Deck.AddCard(card)
	card.charactortype = self.ctype
	table.insert(self.library,card)
end 
function  Deck.Clear()
	self.library = {}
end