ConfigData = {}
this = ConfigData;
local fishStoneData = require "Config/FishStoneData";
local gunData = require "Config/FishBatteryData";
local cardData = require "Config/FishTicketData";
local otherItemData = require "Config/FishPropData";
local fishData = require "Config/FishData";
local fishMakeData = require "Config/FishMakeData";
local shopData = require "Config/FishShopData"
local fishFarmData = require "Config/FishFarmData";
local fishFarmSizeData = require "Config/FishFarmSizeData";
local fishTextureData = require "Config/FishTexture";
local weaponTextureData = require "Config/WeaponTexture";
local vipData = require "Config/VipData";

function this.FishStoneData(itemId)
	-- body
	if(itemId ~= nil) then
		return fishStoneData[itemId];
	else
		return fishStoneData;
	end
end
function this.GunData(itemId)
	-- body
	if(itemId ~= nil) then
		return gunData[itemId];
	else
		return gunData;
	end
end
function this.CardData(itemId)
	if(itemId ~= nil) then
		return cardData[itemId];
	else 
		return cardData;
	end
end
function this.OtherItemData(itemId)
	if(itemId ~= nil) then
		return otherItemData
	else 
		return otherItemData;
	end
end
function this.FishData(itemId)
	if(itemId ~= nil) then
		return fishData[itemId];
	else
		return fishData;
	end
end
function this.FishMakeData(itemId)
	-- body
	if(itemId ~= nil) then
		return fishMakeData[itemId];
	else
		return fishMakeData;
	end
end
function this.ShopData( itemId )
	-- body
	if(itemId ~= nil) then
		return shopData[itemId];
	else
		return shopData;
	end
end
function this.FishFarmData( lv )
	-- body
	if lv ~= nil then
		return fishFarmData[lv];
	else
		return fishFarmData;
	end
end
function this.FishFarmSizeData( lv )
	-- body
	if lv~= nil then
		return fishFarmSizeData[lv]
	else 
		return fishFarmSizeData;
	end
end
function this.VipData( lv )
	-- body
	if lv ~= nil then
		return vipData[lv]
	else
		return vipData;
	end
end
function this.GetFishDataByFishId(fishId)
	-- body
	for k,v in pairs(fishData) do
		if(v.FishId == fishId) then
			return v;
		end
	end
end
function this.GetFishTextureData(itemId)
	-- body
	if(itemId ~= nil) then
		return fishTextureData[itemId];
	else
		return fishTextureData;
	end
end
function this.GetWeaponTextureData( itemId )
	-- body
	if(itemId ~= nil) then
		return weaponTextureData[itemId];
	else
		return weaponTextureData;
	end
end