--养鱼池消息处理
SocketMessage = {};
this = SocketMessage;


local cjson = require "cjson"
require "GameFKBY/View/Panel_MakeFish";
require "GameFKBY/View/Panel_FarmRank";
local Enum = require "GameFKBY/Enum";
--接收消息
function SocketReceiveMessage(text)
 	-- body
 	local js = cjson.decode(text);
 	local _type = js["type"];
 	local tag = js["tag"];
 	print(text);
 	--养鱼池
 	if(_type == "yyc") then
 		if(this.RecErrorTips(js) == true) then return end;
 		if(tag == "fish_frag_exchange") then
 			print("兑换鱼");
 			this.RecExchangeSucceed(js);
 		elseif(tag == "sell_fish") then
 			this.RecSaleFish(js);
 		elseif(tag == "get_fish") then
 			print("get_fish");
 			this.RecInitFish(js);
 		elseif tag == "feed_all_fish" then
 			print("一键喂鱼");
 			this.RecFeedAllFish(js);
 		elseif tag == "feed_fish" then
 			print("喂鱼");
 			this.RecFeedOneFish(js);
 		elseif tag == "fish_output" then
 			print("一键收宝物")
 		 	this.RecGetOutPut(js);
 		elseif tag == "out_put_state" then
 			print("收宝状态");
 			this.RecFishState(js);
		elseif tag == "get_fish_pool" then
			print("获取鱼池数据");
			this.RecFishFarmPool(js);
 		elseif tag == "pool_lv_up" then
 			print("鱼场升级");
 			this.RecFarmLvUp(js);
 		elseif tag == "get_fish_output" then
 			print("指定收宝");
 			this.RecGetOneFishPutOut(js);
 		
 		elseif tag == "expand_fish_pool" then
 			print("扩建鱼池");
 			this.RecExpand_fish_pool(js);
 		
 		elseif tag == "catch_fish" then
 			print("收获鱼");
 			this.RecCatchFish(js);
		elseif tag == "fish_aged_state" then
			print("鱼成熟了");
			this.RecFishMature(js);
		elseif tag == "fish_died_state" then
			print("鱼死亡通知") ;
			this.RecFishDeadNotice(js);
		elseif tag == "get_rank_lst" then
			print("售鱼排行榜")
			this.RecSaleFishRank(js);
		elseif tag == "fish_random_exchange" then
			print("鱼合成")
			this.RecMakeFish(js);
		end
 	end
end



 --发送消息
function this.WebSaleItem(itemId,num,onComplete)
 	UIHelper.ShowProgressHUD(nil,"");
  	local form = UnityEngine.WWWForm.New();
	form:AddField("action", "recover");
    form:AddField("props_id", itemId);
    form:AddField("props_num", num);
	local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BAG_ITEM_ACTION_URL,form);
	coroutine.www(www);
	print(www.text);
		--解析
	local js = cjson.decode(www.text);

	if(js["result"] == "ok") then
			--出售成功
		local itId = js["body"]["props_id"];
		local itNum = js["body"]["props_num"];
		local addGold = js["body"]["gold_money"];
		local itNum = LuaBagData.GetItemNumByItemId(itId) - itNum;
			--减少道具
		LuaBagData.SetItemNum(itId,itNum);
		--增加金币
		LuaBagData.AddGold(addGold);

		UIHelper.HideProgressHUD();
  		if(onComplete ~= nil) then
  			onComplete();
  		end
  	else
  		print(js["body"]);	
	end
end
--web端兑换炮
function this.WebExchange(item,num,onComplete)
	UIHelper.ShowProgressHUD(nil,"");
  	local form = UnityEngine.WWWForm.New();
	form:AddField("action", "combine");
    form:AddField("props_id", item.combId);
    form:AddField("props_num", num);
	local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BAG_ITEM_ACTION_URL,form);
	coroutine.www(www);
	print(www.text);
		--解析
	local js = cjson.decode(www.text);

	if(js["result"] == "ok") then
		--合成 or 兑换成功
		local itId = js["body"]["props_id"];
		local itNum = js["body"]["combine_num"];
		local itNum = LuaBagData.GetItemNumByItemId(itId) + itNum;

		--增加道具
		LuaBagData.SetItemNum(itId,itNum);
		--减少碎片
		local stoneNum = LuaBagData.GetItemNumByItemId(item.id) - num*item.combNum;
		LuaBagData.SetItemNum(item.id,stoneNum);

		UIHelper.HideProgressHUD();
  		if(onComplete ~= nil) then
  			onComplete();
  		end
  	else
  		print(js["body"]);	
	end
end
--web端购买道具
function this.WebBuyItem(itemId,num,price,onComplete)
	-- body
	UIHelper.ShowProgressHUD(nil,"");
	local form = UnityEngine.WWWForm.New();
	form:AddField("action", "buy");
    form:AddField("props_id", itemId);
    form:AddField("props_num", num);
	local  www = HttpConnect.Instance:HttpRequestWithSession(FKBYConnectDefine.BAG_ITEM_ACTION_URL,form);
	coroutine.www(www);
	print(www.text);
	--解析
	local js = cjson.decode(www.text);
	if(js["result"] == "ok") then
		UIHelper.HideProgressHUD();
		--添加道具
		local id = js["body"]["props_id"];
		local iNum = js["body"]["buy_num"];
		if(id == 2081 or id == 2082) then id = 2070 end --一小袋晶石和一大袋晶石
		iNum = LuaBagData.GetItemNumByItemId(id) + iNum;
		LuaBagData.SetItemNum(id,iNum);
		print(LuaBagData.GetItemTypeByItemId(id));
		--减少金币
		LuaBagData.AddGold(-price*num);

		if(onComplete ~= nil) then
			onComplete(ConfigData.ShopData(id).Name,num);
		end
	else
		print(js["body"]);	
	end
end

--发送鱼池里面兑换鱼消息
function this.SendExchangeFish(stoneId,fishId,num)
	-- body
	print("fishId："..fishId .."stoneId:"..stoneId.."num:"..num);
	local msg =  "{\"type\":\"yyc\", \"tag\":\"fish_frag_exchange\", \"body\":[".. fishId .. ",".. num .. "," .. stoneId .. "]}";
	this.SendPackage(msg);
end
--发送鱼合成鱼消息
function this.SendCompFishMessage( fishId )
	-- body
	local msg = "{\"type\":\"yyc\", \"tag\":\"fish_random_exchange\",\"body\":[" .. fishId .. "]}"; 
	this.SendPackage(msg);
end
--发送卖鱼消息
function this.SendSaleFish( fishId,num )
	-- body
	local msg = "{\"type\":\"yyc\", \"tag\":\"sell_fish\",\"body\":[" .. fishId .. ",".. num .. "]}";
    this.SendPackage(msg);
end
--一键收宝
function this.SendGetAllOutPutMessage()
	-- body
	local msg = "{\"type\":\"yyc\", \"tag\":\"fish_output\"}";
    this.SendPackage(msg);
end
--指定鱼收宝
function this.SendGetOneOutPutMessage(fishNetId)
	local msg = "{\"type\":\"yyc\", \"tag\":\"get_fish_output\",\"body\":[" .. fishNetId .."]}";
    this.SendPackage(msg);
end
--扩建鱼场
function this.SendExpandPoolMessage()
	-- body
	local msg = "{\"type\":\"yyc\", \"tag\":\"expand_fish_pool\"}";
    this.SendPackage(msg);
end
--一键回喂鱼
function this.SendFeedAllFishMessage()
	-- body
	local msg = "{\"type\":\"yyc\", \"tag\":\"feed_all_fish\"}";
    this.SendPackage(msg);
end
--喂食指定鱼
function this.SendFeedOneFishMessage(netId,feedId,feedNum)
	-- body
	local msg = "{\"type\":\"yyc\", \"tag\":\"feed_fish\",\"body\":[".. netId .. ",".. feedId .. ",".. feedNum .. "]}";
    this.SendPackage(msg);
end
function this.SendGetOneOutPutByMessage( fishNetId )
 	-- body
 	local msg = "{\"type\":\"yyc\", \"tag\":\"catch_fish\",\"body\":["..fishNetId .. "]}";
    this.SendPackage(msg);
 end 
 function this.SendGetFarmRankDataMessage()
 	-- body
 	local msg = "{\"type\":\"yyc\", \"tag\":\"get_rank_lst\"}";
    this.SendPackage(msg);
 end
--发送消息
function this.SendPackage(msg)
	-- body
	local socketManager = SocketManager.Instance;
	socketManager:SendPackage(msg);
end
function this.RecErrorTips( msg )
	-- body
	--[[    1001,#道具数量不足
             1002,#类型错误
            1003,#合成错误
            [2016/4/13 17:50:03] sweety: 1001,数量不足

            [9:40:03] sweety: 'LevelLimitError': 1004,#等级限制错误
                'VolumeError': 1005,#容量已满
                'FishFeedError': 1006,#喂鱼喂鱼
                'NoHungryFish': 1007,#没有饥饿的鱼]]
    local body = msg["body"];
    if(body == 1001) then
    	UIHelper.ShowMessage("道具数量不足",2);
    	return true;
    elseif body == 1002 then
    	UIHelper.ShowMessage("类型错误",2);
    	return true;
	elseif body == 1003 then
		UIHelper.ShowMessage("合成错误",2);
		return true;
	elseif body == 1004 then
		UIHelper.ShowMessage("等级限制错误",2);
		return true;
	elseif body == 1005 then
		UIHelper.ShowMessage("容量已满",2);
		return true;
	elseif body == 1006 then
		UIHelper.ShowMessage("喂鱼错误",2);
		return true;
	elseif body == 1007 then 
		UIHelper.ShowMessage("没有饥饿的鱼",2);
		return true;
	elseif body == 1008 then
		return true;
	elseif body == 1009 then
		if(msg["tag"] == "out_put_state") then
			print("没有宝物产出")
		else
			UIHelper.ShowMessage("没有宝物产出",2)
		end
		return true;
    end
    return false;
end
function this.RecExchangeSucceed(msg)
	-- body
	local _fishId = msg["body"]["target_fish"][1];
	local fishNum = msg["body"]["target_fish"][2];
	local _netId = msg["body"]["fish_id_lst"];
	

	for k,v in pairs(msg["body"]["need_item"]) do 

		local needFishId = v[1];
		local needFishNum = v[2];
		LuaBagData.SetItemNum(needFishId,needFishNum);
	end
	coroutine.start(this.DelayExchangeFish,_netId,_fishId,0.5);
	--Panel_ConfirmFrame.ExchangeSucceed(ConfigData.FishStoneData(_fishId).CombName,fishNum)
	--[[
	for i=1,#_netId do
		--投放鱼入鱼池
		FishingFarmMaster.SpawnFish(ConfigData.FishData(_fishId).FishId,_netId[i],ConfigData.FishData(_fishId).Power,false);
	end
	]]
end
--鱼合成鱼
function this.RecMakeFish(msg)
	-- body
	--{'type':'yyc','tag':'fish_random_exchange','body':
	--('fish_id':鱼的唯一id,target_fish:(要兑换的鱼ID，当前剩余要兑换的鱼ID的数量N条),
	--need_item:[(所需鱼ID)，当前所需鱼剩余的数量N条),(所需晶石ID，当前晶石数量)])}
	local _netId = msg["body"]["fish_id"];
	local _fishId = msg["body"]["target_fish"][1];
	local fishNum = msg["body"]["target_fish"][2];

	for k,v in pairs(msg["body"]["need_item"]) do 
		local needFishId = v[1];
		local needFishNum = v[2];
		LuaBagData.SetItemNum(needFishId,needFishNum);
	end
	--Panel_MakeFish.PlayAmin();
	FishingFarmMaster.SpawnFish(ConfigData.FishData(_fishId).FishId,_netId,ConfigData.FishData(_fishId).Power,false);
	Panel_FarmMyFish.CompoundSucceed(_fishId);
end
function this.DelayExchangeFish(_netId,_fishId,delay)
	-- body
	for i = 1,#_netId do
		--投放鱼入鱼池
		FishingFarmMaster.SpawnFish(ConfigData.FishData(_fishId).FishId,_netId[i],ConfigData.FishData(_fishId).Power,false);
		coroutine.wait(delay);
	end
end
function this.RecSaleFish( msg )
	-- body
	local itemId = msg["body"]["need_item"][1];
	local num = msg["body"]["need_item"][2];
	--设置道具数量
	LuaBagData.SetItemNum(itemId,num);
	--设置金币
	local money = msg["body"]["money"];
	LuaBagData.SetGold(money);
	--刷新养鱼池等级和经验
	local exp = msg["body"]["exp"];
	local lv = msg["body"]["lv"];
	print(exp..":"..lv);
	FishingFarmMaster.TriggerFarmLevelChanged(lv);
	FishingFarmMaster.TriggerFarmExpChanged(exp);
end

function this.RecInitFish(msg)
	local list = msg["body"]["fish_result"];
	coroutine.start(this.DelayAddFish,list,0.5);
	--[[
	for i=1,#list do
		local netId = list[i]["id"];
		local power = list[i]["stamina"];
		local itemId = list[i]["item_id"];
		local state = list[i]["state"];
		print("fishId"..itemId);
		if(state == 0 or state == 5) then --#0:正常；1：成熟未被捕获的： 3：成熟后被捕获  5：停止生长
			FishingFarmMaster.SpawnFish(ConfigData.FishData(itemId).FishId,netId,power,false);
		elseif(state == 1) then
			FishingFarmMaster.SpawnFish(ConfigData.FishData(itemId).FishId, netId, power,true);
		end
	end
	]]
end
function  this.DelayAddFish(list,delay)
	-- body
	
	for i=1,#list do
		local netId = list[i]["id"];
		local power = list[i]["stamina"];
		local itemId = list[i]["item_id"];
		local state = list[i]["state"];
		print("fishId"..itemId);
		if(state == 0 or state == 5) then --#0:正常；1：成熟未被捕获的： 3：成熟后被捕获  5：停止生长
			FishingFarmMaster.SpawnFish(ConfigData.FishData(itemId).FishId,netId,power,false);
			coroutine.wait(delay)
		elseif(state == 1) then
			FishingFarmMaster.SpawnFish(ConfigData.FishData(itemId).FishId, netId, power,true);
			coroutine.wait(delay)
		end
	end
end
--一键喂食
function this.RecFeedAllFish( msg )
	-- body
	local list = msg["body"]["hungry_lst"];
	for i=1,#list do
		local fishNetId = list[i]["id"];
		local power = list[i]["stamina"];
		local state = list[i]["state"];
		FishingFarmMaster.SetFishPower(fishNetId,power);
	end
	--消耗
	local consume = msg["body"]["cost_lst"]; 
	for i=1,#consume do
		local foodId = consume[i]["item_id"];
		local foodNum = consume[i]["num"];
		LuaBagData.SetItemNum(foodId,foodNum);
	end
end
--单独喂食
function this.RecFeedOneFish( msg )
	-- body
	local netId = msg["body"]["fish"]["id"];
	local  power = msg["body"]["fish"]["stamina"];
	FishingFarmMaster.SetFishPower(netId,power);
	--消耗
	local foodId = msg["body"]["need_item"][1];
	local foodNum = msg["body"]["need_item"][2];
	LuaBagData.SetItemNum(foodId,foodNum);
end

--一键收宝物
function this.RecGetOutPut( msg )
	-- body
	local ob = msg["body"]["output"];
	for k,v in pairs(ob) do
		local netId = tonumber(k);
		local exp = false;
		local food = false;
		local stone = false;
		local diamond = false;
		for i=1,#v do
			local itemId = v[i]["item_id"];
			local itemNum = v[i]["num"];
			----掉落
			if itemId == -1 then
				exp = true;
			else
				local itemType = LuaBagData.GetItemTypeByItemId(itemId);
				if(itemType == Enum.ItemType.Diamond) then
					diamond = true;
				elseif itemType == Enum.ItemType.Stone then
					stone = true;
				elseif itemType == Enum.ItemType.FishFood then
					food = true;
				end

			end
			
		end
		if FishingFarmMaster.AllFishList()[netId] ~= nil then
			local gf = FishingFarmMaster.AllFishList()[netId];
			gf:MakeProduce(gf,exp,food,stone,diamond);
		end
		--[[
		local gf = FishingFarmMaster.AllFishList()[netId];
		if gf ~= nil then
			gf:MakeProduce(gf,..)
		end
		]]
	end
	--添加物品到背包
	local itemList = msg["body"]["item_lst"];
	local itId = 0 ;
	local itNum = 1;
	for i=1,#itemList do
		if(i%2 == 0) then
			itNum = itemList[i];
			LuaBagData.SetItemNum(itId,itNum);
		else
			itId = itemList[i];
		end
	end
	--刷新鱼池经验和等级
	local exp = msg["body"]["fish_pool"]["exp"];
	local lv = msg["body"]["fish_pool"]["exp_lv"];
	FishingFarmMaster.TriggerFarmLevelChanged(lv);
	FishingFarmMaster.TriggerFarmExpChanged(exp);
end
--鱼产宝通知
function this.RecFishState( msg )
	-- body
	local list = msg["body"];
	for i=1,#list do
		local netId = list[i]["id"];
		local state = list[i]["output_state"];
		if(FishingFarmMaster.AllFishList()[netId] ~= nil) then
			FishingFarmMaster.AllFishList()[netId]:UpdateCondition(EnumFishState.Coin);
		end
	end
end
function this.RecFishFarmPool( msg )
	-- body
	local exp = msg["body"]["exp"];
	local lv = msg["body"]["exp_lv"];
	local poolLv = msg["body"]["pond_lv"];
	FishingFarmMaster.TriggerFarmLevelChanged(lv);
	FishingFarmMaster.TriggerFarmExpChanged(exp);
    FishingFarmMaster.TriggerFarmSizeLevelChanged(poolLv); 
    FishingFarmMaster.TriggerFarmFishChanged(); 
end
function this.RecFarmLvUp( msg )
	-- body
	local exp = msg["body"]["exp"];
	local lv = msg["body"]["exp_lv"];
	FishingFarmMaster.TriggerFarmExpChanged(exp);
    FishingFarmMaster.TriggerFarmLevelChanged(lv);
    GameFarm.OnShowLvUp(lv);
end
--扩建鱼池
function this.RecExpand_fish_pool( msg )
	-- body
	local level = msg["body"]["pond_lv"];
	FishingFarmMaster.TriggerFarmSizeLevelChanged(level);
	--消耗的金币
	local money = msg["body"]["money"];
	LuaBagData.SetGold(money);
end
--指定收宝
function this.RecGetOneFishPutOut( msg )
	-- body
	local netId = msg["body"]["fish_id"];
	---掉落 
	local exp = false;
	local food = false;
	local stone = false;
	local diamond = false;
	local itemType = msg["body"]["type_lst"]; 
	for i=1,#itemType do
		if itemType[i] == 0 then	
			exp = true;
		elseif itemType[i] == 1 then
			food = true;
		elseif itemType[i] == 2 then
			stone = true;
		elseif itemType[i] == 3 then
			diamond = true;
		end
	end
	if FishingFarmMaster.AllFishList()[netId] ~= nil then
		local gf = FishingFarmMaster.AllFishList()[netId];
		gf:MakeProduce(gf,exp,food,stone,diamond);
	end


	--添加道具
	local itemList = msg["body"]["item_lst"];
	local itId = 0;
	local itNum = 1;
	for i=1,#itemList do
		if i% 2 == 0 then
			itNum = itemList[i];
			LuaBagData.SetItemNum(itId,itNum);
		else
			itId = itemList[i];
		end
	end
	--刷新鱼池经验和等级
	local exp = msg["body"]["fish_pool"]["exp"];
	local lv = msg["body"]["fish_pool"]["exp_lv"];
	FishingFarmMaster.TriggerFarmLevelChanged(lv);
	FishingFarmMaster.TriggerFarmExpChanged(exp);
end
--鱼成熟通知
function this.RecFishMature( msg )
	local ob = msg["body"];
	for i=1,#ob do
		local netId = ob[i]["id"];
		if FishingFarmMaster.AllFishList()[netId] ~= nil then
			local gf = FishingFarmMaster.AllFishList()[netId];
			gf:SetFishMature();
		end
	end
end
--鱼死亡通知
function this.RecFishDeadNotice( msg )
	-- body
	local ob = msg["body"];
	for i=1,#ob do
		local netId = ob[i]["id"];
		if FishingFarmMaster.AllFishList()[netId] ~= nil then
			local gf = FishingFarmMaster.AllFishList()[netId];
			--设置鱼死亡
			gf:UpdateCondition(EnumFishState.Dead);
		end
	end
end
--收获鱼
function  this.RecCatchFish( msg )
	-- body
	local netId = msg["body"]["fish"]["id"];
	local gf = FishingFarmMaster.AllFishList()[netId];
	--删除
	FishingFarmMaster.TriggerRemoveFish(gf);
	--广播通知
	--FishingFarmMaster.TriggerFarmExpChanged(exp);
	--获得物品
	local fishId = msg["body"]["add_item"][1];
	local fishNum = msg["body"]["add_item"][2];
	LuaBagData.SetItemNum(fishId,fishNum);
end
--售鱼排行榜数据
function this.RecSaleFishRank( msg )
	-- body
	local body = msg["body"];
	local dataTable = {};--[rank] = {rank,nickName,avatarNo,sellNum}
	for i=1,#body do
		local _rank = body[i]["rank"];
		local _nickName = body[i]["nickname"];
		local _avatarNo = body[i]["avatar_no"];
		local _sellNum = body[i]["sell_num"];
		print(_rank..":".._nickName..":".._sellNum);
		dataTable[_rank] = {rank = _rank,avatarNo = _avatarNo,nickName = _nickName,sellNum = _sellNum};
	end
	Panel_FarmRank.CreateCell(dataTable);
end
