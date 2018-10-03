local this = LuaObject:New();
Panel_ConfirmFrame = this;

local label;
local label2;
local label_num;
local saleUI;
local buttonClose;
local buttonConfirm;
local buttonPuls;
local buttonPuls10;
local buttonSub;
local cfType;
local mParameter;
local num;
local maxNum;
local recString;
local isShow = false;
local showAgain = false;
local Enum = require "GameFKBY/Enum";

function this.Awake()
	this.InitPanel();
end

function this.InitPanel()
	-- body
	print("InitPanel");
	label = this.transform:FindChild("Container/LabelMessage"):GetComponent("UILabel");
	label2 = this.transform:FindChild("Container/SaleFish/LabelMessage2"):GetComponent("UILabel");
	label_num = this.transform:FindChild("Container/SaleFish/Label-num"):GetComponent("UILabel");
	saleUI = this.transform:FindChild("Container/SaleFish").gameObject;
	buttonClose = this.transform:FindChild("Container/Button_canel").gameObject;
	buttonConfirm = this.transform:FindChild("Container/Button_OK").gameObject;
	buttonPuls = this.transform:FindChild("Container/SaleFish/Button-puls").gameObject;
	buttonPuls10 = this.transform:FindChild("Container/SaleFish/Button-puls10").gameObject;
	buttonSub = this.transform:FindChild("Container/SaleFish/Button-sub").gameObject;
	this.mono:AddClick(buttonClose, this.OnButtonEvent);
	this.mono:AddClick(buttonConfirm, this.OnButtonEvent);
	this.mono:AddClick(buttonPuls, this.OnButtonPulsAndSub);
	this.mono:AddClick(buttonPuls10, this.OnButtonPulsAndSub);
	this.mono:AddClick(buttonSub, this.OnButtonPulsAndSub);


	this.Init();
end
function this.Start()
	-- body
	num = 1
end
function this.SetInit(str,ctype,parameter)
	-- body
	cfType = ctype;
	mParameter = parameter;
	recString = str;
end
function this.Init()
	-- body
	if(isShow) then
		showAgain = true;
	else
		isShow = true;
		num = 1;
		if(cfType == Enum.ConfirmFrameType.Normal) then
			label.text = recString;
			saleUI:SetActive(false);
			buttonClose:SetActive(false);
			buttonConfirm.transform.localPosition = Vector3.New(0,-117.5,0);
		else
			label.text = "";
			--label2.text = string.format(recString,num);
			label2.text = string.format(recString,num);
			saleUI:SetActive(true);
			label_num.text = tostring(num);
			--出售鱼
			if(cfType == Enum.ConfirmFrameType.SaleFish) then
				maxNum = LuaBagData.GetItemNumByItemId(mParameter.ID);
			--出售鱼碎片
			elseif(cfType == Enum.ConfirmFrameType.SaleFishStone) then
				maxNum = LuaBagData.GetItemNumByItemId(mParameter.ID);
			--兑换鱼
			elseif(cfType == Enum.ConfirmFrameType.Exchange) then
				maxNum = mParameter.num;
			elseif(cfType == Enum.ConfirmFrameType.BuyItem) then
				maxNum = 1000;
			end

		end
		this.gameObject:SetActive(true);
		this.Show();
	end

end
function this.Show()
	-- body
	Lua_UIHelper.UIShow(this.gameObject);
end
function this.OnButtonEvent(go)
	-- body
	print("OnButtonEvent");
	if(go.name == buttonClose.name) then
		this.Hide();
	else
		this.OnOk();
		--[[
		if(UIHelper.GetLoadedName =="GameFarm") then
			if(cfType ~= Enum.ConfirmFrameType.SaleFishStone) then
				this.Hide();
			end
		end
		--]]
		this.Hide();
	end
end
function this.OnOk()
	-- body
	--只提示，没逻辑
	if(cfType == Enum.ConfirmFrameType.Normal) then
		print("提示");
	elseif(cfType == Enum.ConfirmFrameType.SaleFish) then
		--发送卖鱼消息
		print("发送卖鱼消息");
		SocketMessage.SendSaleFish(mParameter.ID,num);
	elseif(cfType == Enum.ConfirmFrameType.BuyItem) then
		print("购买物品");
		local itype = LuaBagData.GetItemTypeByItemId(mParameter.id);
		if itype == Enum.ItemType.Gun then
			--人民币购买
			UIHelper.ShowMessage("暂未开启",2);
		else
			coroutine.start(SocketMessage.WebBuyItem,mParameter.id,num,mParameter.price,this.BuySucceed);
		end
	elseif(cfType == Enum.ConfirmFrameType.SaleFishStone) then
		coroutine.start(SocketMessage.WebSaleItem,mParameter.ID,num,this.SaleSucceed);
	elseif(cfType == Enum.ConfirmFrameType.Exchange) then
		local ityp,ikind = LuaBagData.GetItemTypeByItemId(mParameter.id);
		if(UIHelper.GetLoadedName() == "FKBY_GameFarm") then
			if(ikind == Enum.KindType.FishStone) then
				--判断鱼池是否够容量
				local data = ConfigData.FishData(mParameter.combId);
				local size = ConfigData.FishFarmSizeData(FishingFarmMaster.GetCurrentFarmSizeLevel()).Size - FishingFarmMaster.GetFishSpace();
				if(data.FishSpace * num <= size) then
					SocketMessage.SendExchangeFish(mParameter.id,mParameter.combId,num);
				else
					UIHelper.ShowMessage("鱼场容量不足",2);
				end
			end
		else
			if(ikind == Enum.KindType.GunStone) then
				coroutine.start(SocketMessage.WebExchange,mParameter,num,this.ExchangeSucceed);
			else
				UIHelper.ShowMessage("请到鱼场再兑换",2);
				print("不能兑换");
			end
		end
	end

end
function this.OnButtonPulsAndSub(go)
	-- body
	if(go.name == buttonPuls.name) then
		if(num < maxNum) then
			num = num + 1;
		end
	elseif go.name == buttonPuls10.name then
		if(num < maxNum) then
			num = num + 10;
		end
	elseif go.name == buttonSub.name then
		if(num > 1) then
			num = num - 1;
		end
	end
	label_num.text = tostring(num);
	label2.text = string.format(recString,num)

end

function this.Hide()
	-- body
	isShow = false;
	local waitTime = Lua_UIHelper.UIHide(this.gameObject,false);
	--print(waitTime);
	coroutine.start(this.CloseComplete,this.gameObject,waitTime);

end
function this.CloseComplete(go,time)
	-- body
	coroutine.wait(time);
	if(showAgain == true) then
		this.Show();
		this.Init(recString,this.ctype,mParameter);
		showAgain = false;
	else 
		--go:SetActive(false);
		destroy(go);
	end
end
function this.SaleSucceed()
	-- body
	print("SaleSucceed");
	--this.Hide();
end
function this.ExchangeSucceed(name,num)
	print("ExchangeSucceed");
	Panel_ConfirmFrame.SetInit("成功兑换"..name..num.."条",Enum.ConfirmFrameType.Normal,nil);
	Panel_Follow.ShowConfirmFramePanel();
	--this.Hide();
end	
function this.BuySucceed(name,num)
	-- body
	print("BuySucceed,"..name.."num:"..num);
	Panel_ConfirmFrame.SetInit("成功购买"..name..num.."包",Enum.ConfirmFrameType.Normal,nil);
	Panel_Follow.ShowConfirmFramePanel();
end