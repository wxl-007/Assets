local this = LuaObject:New()
Panel_Recharge = this;

local button_close;
local button_YHrecharge = {};
local button_ZFBrecharge = {};
local button_YHrechargeOther;
local button_ZFBrechargeOther;

local button_RechargeOtherCanel;
local panel_rechargeOther;
local ZFB_cells;
local YH_cells;
local kalei;
local applePay;
local messagesPay;
local kaPay;
local oppTypes;
local oppJinEs;
local yhBL = 15000;
local zfbBL = 15000;

local arrMon = {};
local kaData;

local first_idex = 1;
local second_idex = 1;

local cjson = require "cjson"


function this.Awake()
end
function this.Start()
	this.InitPanel();
	applePay:SetActive(false);

	coroutine.start(this.loadBiLi);
	this.mono:AddClick(button_YHrechargeOther,this.ButtonRechargeHandle);
	this.mono:AddClick(button_ZFBrechargeOther,this.ButtonRechargeHandle);
	this.mono:AddClick(messagesPay,this.ButtonRechargeHandle);
	this.mono:AddClick(kaPay,this.ButtonRechargeHandle);
	this.mono:AddClick(button_RechargeOtherCanel,this.ButtonRechargeOtherHandle);
	this.mono:AddClick(button_close,this.OnClose);

	print("YH"..#button_YHrecharge);
	print("ZFB"..#button_ZFBrecharge);
	for i=1,#button_YHrecharge do
		this.mono:AddClick(button_YHrecharge[i],this.OnClickYhBuy);
	end

	for i=1,#button_ZFBrecharge do
		this.mono:AddClick(button_ZFBrecharge[i],this.OnClickZFBBuy);
	end
end

function this.InitPanel()
	for i=1,5 do
		button_YHrecharge[i] = this.transform:FindChild("Content 1/cell/cell"..i-1).gameObject;
		button_ZFBrecharge[i] = this.transform:FindChild("Content 3/cell/cell"..i-1).gameObject;
	end
	button_YHrecharge[6] = this.transform:FindChild("Panel_rechargeOther/Button_okYH").gameObject;
	button_ZFBrecharge[6] = this.transform:FindChild("Panel_rechargeOther/Button_okZFB").gameObject;
	button_YHrechargeOther = this.transform:FindChild("Content 1/Button_YHother").gameObject;
	button_ZFBrechargeOther = this.transform:FindChild("Content 3/Button_ZFBOther").gameObject;
	button_RechargeOtherCanel = this.transform:FindChild("Panel_rechargeOther/Button_canel").gameObject;
	button_close = this.transform:FindChild("Button_close").gameObject;
	panel_rechargeOther = this.transform:FindChild("Panel_rechargeOther").gameObject;
	ZFB_cells = this.transform:FindChild("Content 3/cell").gameObject;
	YH_cells = this.transform:FindChild("Content 1/cell").gameObject;
	kalei = this.transform:FindChild("kalei").gameObject;
	applePay = this.transform:FindChild("Button_applePay").gameObject;
	messagesPay = this.transform:FindChild("tabs/Tab 4").gameObject;
	kaPay = this.transform:FindChild("kalei/Button_kaOK").gameObject;
	arrMon[1] = 10;
	arrMon[2] = 20;
	arrMon[3] = 30;
	arrMon[4] = 50;
	arrMon[5] = 100;


end
function this.OnClose( go )
	Panel_Follow.HidePanel(this.gameObject);
end
function this.ButtonRechargeHandle(go)
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
	if button_YHrechargeOther.name == go.name then
		Panel_Follow.ShowPanel(panel_rechargeOther);
		button_YHrecharge[6]:SetActive(true);
		button_ZFBrecharge[6]:SetActive(false);
	elseif button_ZFBrechargeOther.name == go.name then
		Panel_Follow.ShowPanel(panel_rechargeOther);
		button_YHrecharge[6]:SetActive(false);
		button_ZFBrecharge[6]:SetActive(true);
	elseif messagesPay.name == go.name then
		this.OnClickTXF();
	elseif kaPay.name == go.name then
		this.OnClickKa();	
	end
end
function this.ButtonRechargeOtherHandle(go)
	AudioHelper.getInstance():PlayOnClickAudio("OnClick");
	Panel_Follow.HidePanel(panel_rechargeOther);
end
function this.loadBiLi( )
	UIHelper.ShowProgressHUD(nil,"");

	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BANK_BILI_URL, nil);
	coroutine.www(www);
	print(www.text);
	local js = cjson.decode(www.text);
	if(js["result"] == "ok") then
		yhBL = tonumber(js["body"]);
	else
		UIHelper.ShowMessage(js["body"],2);
	end


	local www_zfb = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.ZFB_BILI_URL, nil);
	coroutine.www(www_zfb);
	print(www_zfb.text);
	local zfbjs = cjson.decode(www_zfb.text);
	if zfbjs["result"] == "ok" then
		zfbBL = tonumber(zfbjs["body"]);
	else
		UIHelper.ShowMessage(zfbjs["body"],2);
	end
	UIHelper.HideProgressHUD();

	local www_card = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.CARD_BILI_URL,nil);
	coroutine.www(www_card);
	print(www_card.text);
	local cardjs = cjson.decode(www_card.text);
	if cardjs["result"] == "ok" then
		kaData = cardjs["body"];
		oppTypes = {};
		oppJinEs = {};
		for i=1,#kaData do
			oppTypes[i] = kaData[i]["name"];
			oppJinEs[i] = kaData[i]["suit"];
		end
	else
		UIHelper.ShowMessage(zfbjs["body"],2);
	end
	UIHelper.HideProgressHUD();
	
	if oppTypes ~= nil and #oppTypes > 0 then
		local first_list = kalei.transform:FindChild("first_list"):GetComponent("UIPopupList");
		--first_list.items = oppTypes;
		first_list:Clear();
		for i=1,#oppTypes do
			first_list:AddItem(oppTypes[i]);
		end
		first_list.value = oppTypes[1];
		
		this.mono:AddPopupChange(first_list,this.onFirstChange);
		
		local second_list = kalei.transform:FindChild("second_list"):GetComponent("UIPopupList");
		local secondData = {};
		local lidata = oppJinEs[1];
		for i=1,#lidata do
			local onedata = lidata[i];
			local oneStr = onedata[2].."元="..onedata[3] .. PlatformGameDefine.playform.UnityMoney;
		end
		for i=1, 5 do
			local ul = YH_cells.transform:FindChild("cell"..i-1):FindChild("money"):GetComponentInChildren(LuaHelper.GetType("UILabel"));
			ul.text = arrMon[i]*yhBL..PlatformGameDefine.playform.UnityMoney;
		end
		for i=1,5 do
			local ul = ZFB_cells.transform:FindChild("cell"..i-1):FindChild("money"):GetComponentInChildren(LuaHelper.GetType("UILabel"));
			ul.text = arrMon[i]*zfbBL..PlatformGameDefine.playform.UnityMoney;
		end
		
	end
	
end
local secondData = {};
function this.onFirstChange(  )
	local second_list = kalei.transform:FindChild("second_list"):GetComponent("UIPopupList");
	--local idex = UIPopupList.current.items.IndexOf(UIPopupList.current.value);
	local idex = 1;
	for i=1,#oppTypes do
		if oppTypes[i] == UIPopupList.current.value then 
			idex = i;
			first_idex = i;
			break;
		end
	end
	secondData = {};
	local lidata = oppJinEs[idex];
	for i=1,#lidata do
		local onedata = lidata[i];
		local oneStr = onedata[2].."元"..onedata[3]..PlatformGameDefine.playform.UnityMoney;
		secondData[i] = oneStr;
	end
	second_list:Clear();
	for i=1,#secondData do
		second_list:AddItem(secondData[i]);
	end
	--second_list.items = secondData;
	second_list.value = secondData[1];
end

----------手机卡  点卡 充值--------
function this.OnClickKa()
	-- body
	local second_list = kalei.transform:FindChild("second_list"):GetComponent("UIPopupList");
	--local first_list = kalei.transform:FindChild("first_list"):GetComponent("UIPopupList");
	--local first_idex = first_list.items.IndexOf(first_list.value);
	--local second_idex =second_list.items.IndexOf(second_list.value);
	for i=1,#secondData do
		if secondData[i] == second_list.value then
			second_idex = i;
			break;
		end
	end
	local lidata = oppJinEs[first_idex];
	local onedata = lidata[second_idex];
	local urlpa = ConnectDefine.BANK_RECHARGE_URL .. "?username=" .. EginUser.Instance.username .. "&money_amount=" .. onedata[2] .. "&bank_type_code=" .. kaData[first_idex]["code"];
	Application.OpenURL(urlpa);
end
function this.OnClickTXF( )
	Application.OpenURL(ConnectDefine.TXF_RECHARGE_URL);
end
function this.OnClickApplePay()
	print("苹果充值");
	--EginLoadLevel("Module_Recharge_iOS");
end
function this.OnClickYhBuy( roomEntry )
	print(roomEntry.name);
	AudioHelper.getInstance():PlayOnClickAudio("OnClick");
	local money = 0;
	if roomEntry.transform.parent.name == "Panel_rechargeOther" then
		local ul = roomEntry.transform.parent:FindChild("Input_money/Label"):GetComponent("UILabel");
		local isnum = this.isDigitStr(ul.text);
		if isnum == true then
			Panel_Follow.HidePanel(panel_rechargeOther);
			money = tonumber(ul.text);
		end
	else
		if roomEntry.name == "cell0" then
			money = 10;
		elseif roomEntry.name == "cell1" then
			money = 20;
		elseif roomEntry.name == "cell2" then
			money = 30;
		elseif roomEntry.name == "cell3" then
			money = 50;
		elseif roomEntry.name == "cell4" then
			money = 100;
		end
	end 
	print("money"..money);
	if money > 0 and EginUser.Instance.username ~= nil and EginUser.Instance.username ~= "" then 
		local urlpa = ConnectDefine.BANK_RECHARGE_URL .. "?username=" ..EginUser.Instance.username .. "&money_amount=" .. money .. "&bank_type_code=YEEPAY1KEY";
		Application.OpenURL(urlpa);	
	end
end

function this.OnClickZFBBuy( roomEntry )
 	-- body
 	AudioHelper.getInstance():PlayOnClickAudio("OnClick");
 	local money = 0;
 	if roomEntry.transform.parent.name == "Panel_rechargeOther" then
 		local ul = roomEntry.transform.parent:FindChild("Input_money"):GetComponentInChildren(LuaHelper.GetType("UILabel"));
 		local isnum = this.isDigitStr(ul.text);
 		if isnum == true then
 			Panel_Follow.HidePanel(panel_rechargeOther);
 			money = tonumber(ul.text);
 		end
	else
		if roomEntry.name == "cell0" then
			money = 10;
		elseif roomEntry.name == "cell1" then
			money = 20;
		elseif roomEntry.name == "cell2" then
			money = 30;
		elseif roomEntry.name == "cell3" then
			money = 50;
		elseif roomEntry.name == "cell4" then
			money = 100;
		end
 	end
 	if money > 0 and EginUser.Instance.username ~= nil and EginUser.Instance.username ~= "" then
 		local urlpa = ConnectDefine.BANK_RECHARGE_URL .. "?username=" .. EginUser.Instance.username .. "&money_amount=" .. money .. "&bank_type_code=ALIPAY";
 		Application.OpenURL(urlpa);
 	end
end 

function this.OnUpdate(  )
	if button_YHrecharge[6].activeSelf == true then
		local ul = panel_rechargeOther.transform:FindChild("Input_money"):GetComponentInChildren(LuaHelper.GetType("UILabel"));
		if ul ~= nil then
			local isnum = this.isDigitStr(ul.text);
			if isnum == true then
				local lebi = panel_rechargeOther.transform:FindChild("lebi"):GetComponentInChildren(LuaHelper.GetType("UILabel"));
				if lebi ~= nil then
					lebi.text = tonumber(ul.text) * yhBL .. PlatformGameDefine.playform.UnityMoney;
				end
			end

		end
	elseif button_ZFBrecharge[6].activeSelf == true then
		local ul = panel_rechargeOther.transform:FindChild("Input_money").GetComponentInChildren(LuaHelper.GetType("UILabel"));
		if ul ~= nil then
			local isnum = this.isDigitStr(ul.text);
			if isnum == true then
				local lebi = panel_rechargeOther.transform:FindChild("lebi"):GetComponentInChildren(LuaHelper.GetType("UILabel"));
				if lebi ~= nil then
					lebi.text = tonumber(ul.text)*zfbBL..PlatformGameDefine.playform.UnityMoney;
				end
			end
		end
	end

end
function this.isDigitStr( cstr )
	return true;
end