--local this = LuaObject:New();
LuaBagData = {};
local  this = LuaBagData;

this.gold = 0;
this.diamond = 0;

local hasNewStone = true;
local hasNewFish = true;
local hasNewGun = true;
local hasNewExcCard = true;
local hasNewOtherItem = true;
local hasNewFishFood = true;
require "GameFKBY/ConfigData"

--加载表数据
local FishStoneData = ConfigData.FishStoneData();
local GunData = ConfigData.GunData();
local CardData = ConfigData.CardData();
local OtherItemData = ConfigData.OtherItemData();
local FishData = ConfigData.FishData();
local ShopData = ConfigData.ShopData();

local Event = require "events";
local cjson = require "cjson"
local Enum = require "GameFKBY/Enum"
require "System/Coroutine";

function LuaBagData.HasNewItem(ty) 
	--body
	if (ty == Enum.ItemType.Fish) then
		return hasNewFish;
	elseif (ty == Enum.ItemType.ExchangeCard) then
		return hasNewExcCard;
	elseif (ty == Enum.ItemType.FishFood) then
		return hasNewFishFood;
	elseif(ty == Enum.ItemType.Gun) then
		return hasNewGun;
	elseif(ty == Enum.ItemType.Other) then
		return hasNewOtherItem;
	elseif(ty == Enum.ItemType.Stone) then
		return true;
	elseif(ty == Enum.ItemType.TelCharge) then
		return false;
	elseif(ty == Enum.ItemType.TreasureMap) then
		return false;
	elseif(ty == Enum.ItemType.Diamond) then
		return true;
	else
		return false;
	end
end

function  LuaBagData.SetNewState(ty,state)
	-- body
	if (ty == Enum.ItemType.Fish) then
		hasNewFish = state;
	elseif (ty == Enum.ItemType.ExchangeCard) then
		hasNewExcCard = state;
	elseif (ty == Enum.ItemType.FishFood) then
		hasNewFishFood = state;
	elseif(ty == Enum.ItemType.Gun) then
		hasNewGun = state;
	elseif(ty == Enum.ItemType.Other) then
		hasNewOtherItem = state;
	elseif(ty == Enum.ItemType.Stone) then
		hasNewStone = state;

	--elseif(ty == Enum.ItemType.TelCharge)
	--elseif(ty == Enum.ItemType.TreasureMap)
	end
end
 
 function LuaBagData.InitItem(item)
	-- body
	
 end
--道具数据
this.gunStoneTable = {};
this.fishTable = {};
this.gunTable = {};
this.foodTable = {};
this.fishStoneTable = {};
this.exchangeCardTable = {};
this.otherItemTable = {};
this.crystalTable = {};


function LuaBagData.SetItemNum(itemId,number)
	-- body
	local itype,kind = this.GetItemTypeByItemId(itemId);
	
	if(itype == Enum.ItemType.Gun) then	
		if this.gunTable[itemId] ~= nil then
			this.gunTable[itemId].num = number;
		else
			this.SetNewState(itype,true);
		end
		
	elseif(itype == Enum.ItemType.Fish) then
		if(this.fishTable[itemId] ~= nil) then
			this.fishTable[itemId].num = number;
		else
			this.SetNewState(itype,true);
		end
		
	elseif (itype == Enum.ItemType.Stone) then
		if(kind == Enum.KindType.FishStone) then
			if(this.fishStoneTable[itemId] ~= nil) then
				this.fishStoneTable[itemId].num = number;
				else
					this.SetNewState(itype,true);

			end
		elseif(kind == Enum.KindType.GunStone) then
			if(this.gunStoneTable[itemId] ~= nil) then
				this.gunStoneTable[itemId].num = number;
			else this.SetNewState(itype,true);
			end

		end
	elseif(itype == Enum.ItemType.FishFood) then
		if(this.foodTable[itemId] ~= nil) then
			this.foodTable[itemId].num = number;
		else
			this.SetNewState(itype,true);
		end
	elseif(itype == Enum.ItemType.ExchangeCard) then
		if(this.exchangeCardTable[itemId] ~= nil) then
			this.exchangeCardTable[itemId].num = number;
		else 
			this.SetNewState(itype,true);
		end
	elseif(itype == Enum.ItemType.Other) then
		if(this.otherItemTable[itemId] ~= nil) then
			this.otherItemTable[itemId].num = number;
		else
			this.SetNewState(itype,true);
		end
		
	elseif(itype == Enum.ItemType.Diamond) then
			if(itemId == 2072) then
				this.SetDiamond(number);
			else
				if(this.crystalTable[itemId] ~= nil) then
					this.crystalTable[itemId].num = number;
				else
					this.SetNewState(itype,true);
				end
			end
			return;
	end
	--广播通知
	Event.Brocast(Enum.EventType.EventBagItemChange,itemId,number);
	
end
function LuaBagData.SetGold(num)
	-- body
	this.gold = num;
	Event.Brocast(Enum.EventType.EventGoldChange,num);
end
function  LuaBagData.AddGold(num)
	-- body
	this.SetGold(this.GetGold() + num);
end
function LuaBagData.GetGold()
	-- body
	print(EginUser.Instance.bagMoney);
	if(this.gold ~= 0) then
		return this.gold;
	else
		return tonumber(EginUser.Instance.bagMoney);
		--return 10;
	end
end
function LuaBagData.GetDiamond()
	return this.diamond;
end
function LuaBagData.SetDiamond(num)
	this.diamond = num;
	--广播通知
	Event.Brocast(Enum.EventType.EventDiamondChange,num);
end
function LuaBagData.SetCrystal( itemId,number,_combId,_combNum)
	-- body
	this.crystalTable[itemId] = {id = itemId,num = number,combId = _combId,combNum = _combNum};
end
function LuaBagData.SetGunStone(itemId,number,_combId,_combNum)
	-- body
	--this.gunStoneTable[stoneName] = num;
	this.gunStoneTable[itemId] = {id = itemId,num = number,combId = _combId,combNum = _combNum};
end
function LuaBagData.SetFishStone(itemId,number,_combId,_combNum)
	-- body
	--this.fishStoneTable[stoneName] = num;
	this.fishStoneTable[itemId] = {id = itemId,num = number,combId = _combId,combNum = _combNum};
end
function LuaBagData.SetFish(itemId,number,_combId,_combNum)
	-- body
	--this.fishTable[fishName] = num;
	this.fishTable[itemId] = {id = itemId,num = number,combId = _combId,combNum = _combNum};
end
function LuaBagData.SetGun(itemId,number,_combId,_combNum)
	-- body
	--this.gunTable[gunName] = num;
	this.gunTable[itemId] = {id = itemId,num = number,combId = _combId,combNum = _combNum};
end
function LuaBagData.SetFood(itemId,number,_combId,_combNum)
	-- body
	--this.foodTable[foodName] = num;
	this.foodTable[itemId] = {id = itemId,num = number,combId = _combId,combNum = _combNum};
end
function LuaBagData.SetCard(itemId,number,_combId,_combNum)
	-- body
	--this.foodTable[foodName] = num;
	this.exchangeCardTable[itemId] = {id = itemId,num = number,combId = _combId,combNum = _combNum};
end
function LuaBagData.SetOtherItem(itemId,number,_combId,_combNum)
	-- body
	this.otherItemTable[itemId] = {id = itemId,num = number,combId = _combId,combNum = _combNum};
end

function LuaBagData.LoadData(type,onComplete)
	-- body
	if(this.HasNewItem(type)) then
		UIHelper.ShowProgressHUD(nil,"");
		local form = UnityEngine.WWWForm.New();
		form:AddField("type",type);
		local  www = HttpConnect.Instance:HttpRequestWithSession(FKBYConnectDefine.BAG_URL,form);
		coroutine.www(www);
		
		print(www.text);
	--解析
		local js = cjson.decode(www.text);
		if(pcall(this.CheckJSonError,js)) then
			if(js["result"] == "ok") then
				this.SetNewState(type,false);
				local info = js["body"];
				for k ,v in pairs(info) do
					local _id = v["id"];
					local _num = v["amount"];
					local  _combId,_combNum;
					local _kind = v["kind"];
					local _type = v["type"];
					if(pcall(this.SetItemFromJson,v)) then
						_combId = v["combine"]["id"];
						_combNum = v["combine"]["need_prop"][1][2];
					 else 
						_combId = 0;
						_combNum = 0;
					end
					if(_type == Enum.ItemType.Stone) then
						if(_kind == Enum.KindType.GunStone) then
							this.SetGunStone(_id,_num,_combId,_combNum);
						elseif(_kind == Enum.KindType.FishStone) then
							this.SetFishStone(_id,_num,_combId,_combNum);
						end
					elseif(_type == Enum.ItemType.Gun) then
						this.SetGun(_id,_num,_combId,_combNum);
					elseif(_type == Enum.ItemType.FishFood) then
						this.SetFood(_id,_num,_combId,_combNum);
					elseif (_type == Enum.ItemType.ExchangeCard) then
						this.SetCard(_id,_num,_combId,_combNum);
					elseif (_type == Enum.ItemType.Other) then
						this.SetOtherItem(_id,_num,_combId,_combNum);
					elseif(_type == Enum.ItemType.Fish) then
						this.SetFish(_id,_num,_combId,_combNum);
					elseif(_type == Enum.ItemType.Diamond) then
						if _id == 2070 then
							this.SetDiamond(_num);
						else
							this.SetCrystal(_id,_num,_combId,_combNum);
						end
					end
				end
			end
		end
		UIHelper.HideProgressHUD();
	end
	if(onComplete ~= nil) then
		onComplete();
	end
end
function this.SetItemFromJson(v)
	local  _combId = v["combine"]["id"];
	local _combNum = v["combine"]["need_prop"][1][2];
end
function this.CheckJSonError(js)
	local result = js["result"];
end
--获取道具数量
function this.GetItemNumByItemId(itemId)
	-- body
	if(this.gunStoneTable[itemId] ~= nil) then
		return this.gunStoneTable[itemId].num;
	elseif (this.fishTable[itemId] ~= nil) then
		return this.fishTable[itemId].num;
	elseif(this.gunTable[itemId] ~= nil) then
		return this.gunTable[itemId].num;
	elseif (this.foodTable[itemId] ~= nil) then
		return this.foodTable[itemId].num;
	elseif(this.fishStoneTable[itemId] ~= nil) then
		return this.fishStoneTable[itemId].num;
	elseif(this.exchangeCardTable[itemId]~=nil)then
		return this.exchangeCardTable[itemId].num;
	elseif(this.otherItemTable[itemId]~=nil)then
		return this.otherItemTable[itemId].num;
	elseif(itemId == 2070) then
		return this.GetDiamond();
	end
	return 0;
end
--获取道具类型
function this.GetItemTypeByItemId(itemId)
	--碎片
	if(FishStoneData[itemId]~=nil) then
		if(FishStoneData[itemId].Type == 1) then
			return Enum.ItemType.Stone,Enum.KindType.FishStone;
		elseif(FishStoneData[itemId].Type == 2) then
			return Enum.ItemType.Stone,Enum.KindType.GunStone;
		elseif(FishStoneData[itemId].Type == 3) then
			return Enum.ItemType.Stone,Enum.KindType.defind0;
		end
	elseif(GunData[itemId] ~= nil) then
		return Enum.ItemType.Gun,Enum.KindType.defind0;
	elseif(CardData[itemId] ~= nil) then
		return Enum.ItemType.ExchangeCard,Enum.KindType.defind0;
	elseif(OtherItemData[itemId] ~= nil) then
		return Enum.ItemType.Other,Enum.KindType.defind0;
	elseif(FishData[itemId] ~= nil) then
		return Enum.ItemType.Fish,Enum.KindType.defind0;
	elseif(ShopData[itemId] ~= nil) then
		if itemId == 2070 then return Enum.ItemType.Diamond,Enum.KindType.defind0; end
		return Enum.ItemType.FishFood,Enum.KindType.defind0;
	end
end
--获取道具
function this.GetItemByItemId(itemId)
	-- body
	local itype,kind = this.GetItemTypeByItemId(itemId);
	if(itype == Enum.ItemType.Stone) then
		if(kind == Enum.KindType.FishStone) then
			return this.fishStoneTable[itemId];
		elseif (kind == Enum.KindType.GunStone) then
			return this.gunStoneTable[itemId];
		end
	elseif (itype == Enum.ItemType.FishFood) then
		return this.foodTable[itemId];
	elseif (itype == Enum.ItemType.Gun) then
		return this.gunTable[itemId];
	elseif (itype == Enum.ItemType.Fish) then
		return this.fishTable[itemId];
	elseif (itype == Enum.ItemType.ExchangeCard) then
		return this.exchangeCardTable[itemId];
	elseif (itype == Enum.ItemType.Other) then 
		return this.otherItemTable[itemId];
	elseif(itype == Enum.ItemType.Diamond) then
		return diamond;
	end
	return nil;
end
