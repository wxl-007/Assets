local Enum = {};
local  this = Enum;

this.ItemType = {
	Gold = 1,
	TelCharge = 2,
	Gun = 3,
	TreasureMap = 4,
	Fish = 5,
	Diamond = 6,
	Other = 7,
	ExchangeCard = 8,
	Stone = 9,
	FishFood = 10,
};
this.KindType = {
	defind0 = 0,
    defind1 = 1,
    defind2 = 2,
    GunStone = 3,
    TelChargeStone = 4,
    FishStone = 5,	
};
this.ConfirmFrameType = {

    Normal = 1,
    SaleFish = 2,
    BuyItem = 3,
    SaleFishStone = 4,
    Exchange = 5,

}
this.FarmMouseState = {
    Normal = 1,--正常
    FeedCommon = 2,--喂食普通
    FeedValuable = 3,--喂食珍贵
    FeedRarely = 4,--喂食稀有
    FeedHighest = 5,--喂食精品
}
--事件
this.EventType = {
	EventBagItemChange = "EventBagItemChange";
	EventGoldChange = "EventGoldChange";
	EventDiamondChange = "EventDiamondChange";
    EventFarmExpChange = "EventFarmExpChange";
    EventFarmLevelChange = "EventFarmLevelChange";
    EventFarmSizeChange = "EventFarmSizeChange";
    EventFarmSizeLvChange = "EventFarmSizeLvChange";
    EventFarmRemoveFish = "EventFarmRemoveFish";
    EventFarmOnSpawnFish = "EventFarmOnSpawnFish";
}
return Enum;