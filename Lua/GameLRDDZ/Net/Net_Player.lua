Net_Player = {}
self = Net_Player


local net_uid;
local net_nick;
local net_avatar;

self.library = {}

self.ctype = CharacterType.Player

function Net_Player.GetLibrary( )
	self.SortCard()
	return self.library
end

function Player.GetCardsCount()
	return #self.library
end