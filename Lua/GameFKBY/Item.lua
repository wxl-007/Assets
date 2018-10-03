Item = {Id = 0,Name = "",Num = 0 ,King = 0,Type = 0,Price = 0,Desc = "",CombId = 0,CombNeedStone = 0};
Item.__index = Item;
function Item:new(id,name,num,king,price,desc,combId,combNeedStone)
	-- body
	local self = {}
	setmetatable(self,Item)
	self.Id = id;
	self.Nmae = name;
	self.Num = num;
	self.Kind = king;
	self.Price = price;
	self.Desc = desc;
	self.CombId = combId;
	self.CombNeedStone = combNeedStone;
end