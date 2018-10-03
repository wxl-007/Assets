Net_GameCtrl = {}
this = Net_GameCtrl
require "GameLRDDZ.Game.Type"
require "GameLRDDZ.Game.Card.Card"
require "GameLRDDZ.Game.Card.CardRule"
require "GameLRDDZ.Game.Card.CardBottomRule"
require "GameLRDDZ.Game.OrderCtrl"
require "GameLRDDZ.Game.Deck"
require "GameLRDDZ.Game.DeskCardsCache"
require "GameLRDDZ.Game.BottomCard"

--显示手牌
function Net_GameCtrl.SetPlayerCards(cards)
	Player.SetLibrary(cards)
end
function Net_GameCtrl.ComputerPutCards(cards)
	
end