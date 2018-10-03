local this = SafeValidate:New()
Panel_Bank = this;


local cjson = require "cjson"

local kDealMeoney;
local kBagMoney;
local kBankMoney;
local kSaveBankMoney;
local kGiveToggle;
local kUserID;
local kGiveMoney;
local vBankPassword;
local kBankPassword;
local vPhoneCode;
local kPhoneCode;
local vRecords;
local recordPrefab;
local recordPrefab1;

local recordPage = 1;
local maxRecordPage = 1;
local recordPageSize = 30;
local button_refresh;
local button_take;
local button_save;
local button_sendPhoneCode;

local button_bankRecord;--银行记录
local button_giftRecord;--赠送记录

local button_close;

--赠送相关
local gift_vBankPassword;
local gfit_kBankPassword;
local gift_vPhoneCode;
local gift_kPhoneCode;
local gift_kGiftID;
local gift_kGIftMoney;
local gift_vConfirm;
local gift_kConfirmID;
local gift_kConfirmNickname;
local gift_kConfirmMoney;
local gift_kConfirmMoneyZh;
local gift_vSucess;
local gift_kSucessMoney;
local gift_kSucessID;
local gift_vRecords;
local gift_recordPrefab;
local gift_recordPrefab1;
local gift_recordPage = 1;
local gift_maxRecordPage = 1;
local gift_recordPageSize = 30;
local gift_buttonGive;
local gift_buttonSendPhoneCode;
local gift_buttonConfirm;
local gfit_buttonCannel;
local gift_buttonOK;

local holdCoin;

function this.Awake( ... )
	-- body
	this.InitPanel();
	this.InitGiftPanel();
end

function this.Start()

end
function this.InitPanel()

	kDealMeoney = this.transform:FindChild("Content 01/Content 1/Deal/Control - Simple Input Field"):GetComponent("UIInput");
	kSaveBankMoney = this.transform:FindChild("Content 01/Content 1/Deposit/count/bankSave"):GetComponent("UILabel");
	kUserID = this.transform:FindChild("Content 01/Content 2/UserID/Control - Simple Input Field"):GetComponent("UIInput");
	kGiveMoney = this.transform:FindChild("Content 01/Content 2/Give/Control - Simple Input Field"):GetComponent("UIInput");
	vBankPassword = this.transform:FindChild("Content 01/Content 1/PassWord").gameObject;
	kBankPassword = this.transform:FindChild("Content 01/Content 1/PassWord/Control - Simple Input Field"):GetComponent("UIInput");
	vPhoneCode = this.transform:FindChild("Content 01/Content 1/PhoneCode").gameObject;
	kPhoneCode = this.transform:FindChild("Content 01/Content 1/PhoneCode/Control - Simple Input Field"):GetComponent("UIInput");
	kSGToggle = this.transform:FindChild("Content 01/tabs/Tab 1"):GetComponent("UIToggle");
	--kGiftToggle = this.transform:FindChild("Content 01/tabs/Tab 3"):GetComponent("UIToggle");
	--kRecordToggle = this.transform:FindChild("Content 01/tabs/Tab 2"):GetComponent("UIToggle");
	--Gift = this.transform:FindChild("Gift").gameObject;
	vRecords = this.transform:FindChild("Content 01/Content 3/Scroll View/Grid");
	recordPrefab = this.transform:FindChild("Content 01/Content 3/Scroll View/Bank_Record").gameObject;
	recordPrefab1 = this.transform:FindChild("Content 01/Content 3/Scroll View/Bank_Record (1)").gameObject;
	--button_refresh = this.transform:FindChild("Content 01/Content 1/Button_refresh").gameObject;
	button_take = this.transform:FindChild("Content 01/Content 1/Button_take").gameObject;
	button_save = this.transform:FindChild("Content 01/Content 1/Button_save").gameObject;
	button_sendPhoneCode = this.transform:FindChild("Content 01/Content 1/PhoneCode/Button_send").gameObject;

	button_bankRecord = this.transform:FindChild("left/Tabs/Tab 2").gameObject;

	button_close = this.transform:FindChild("Button_close").gameObject;

	holdCoin = this.transform:FindChild("left/Coin/Label"):GetComponent("UILabel");

	--this.mono:AddClick(button_refresh,this.ButtonBankHandle);
	this.mono:AddClick(button_take,this.ButtonBankHandle);
	this.mono:AddClick(button_save,this.ButtonBankHandle);
	this.mono:AddClick(button_close,this.OnClose);

	this.mono:AddClick(button_bankRecord,this.ButtonBankHandle);
end
function this.InitGiftPanel( ... )
	-- body
	gift_vBankPassword = this.transform:FindChild("Content 01/Content 2/PassWord").gameObject;
	gfit_kBankPassword = this.transform:FindChild("Content 01/Content 2/PassWord/Control - Simple Input Field"):GetComponent("UIInput");
	gift_vPhoneCode = this.transform:FindChild("Content 01/Content 2/PhoneCode").gameObject;
	gift_kPhoneCode = this.transform:FindChild("Content 01/Content 2/PhoneCode/Control - Simple Input Field"):GetComponent("UIInput");
	gift_kGiftID = this.transform:FindChild("Content 01/Content 2/UserID/Control - Simple Input Field"):GetComponent("UIInput");
	gift_kGIftMoney = this.transform:FindChild("Content 01/Content 2/Give/Control - Simple Input Field"):GetComponent("UIInput");
	gift_vConfirm = this.transform:FindChild("Content 01/Content 2/Panel_confirmAlert").gameObject;
	gift_kConfirmID = this.transform:FindChild("Content 01/Content 2/Panel_confirmAlert/Label_id/id"):GetComponent("UILabel");
	gift_kConfirmNickname = this.transform:FindChild("Content 01/Content 2/Panel_confirmAlert/Label_id/nickname"):GetComponent("UILabel");
	gift_kConfirmMoney = this.transform:FindChild("Content 01/Content 2/Panel_confirmAlert/Label_money/money"):GetComponent("UILabel");
	gift_kConfirmMoneyZh = this.transform:FindChild("Content 01/Content 2/Panel_confirmAlert/Label_money/Money_Zh"):GetComponent("UILabel");
	gift_vSucess = this.transform:FindChild("Content 01/Content 2/Panel_sucessAlert").gameObject;
	gift_kSucessMoney = this.transform:FindChild("Content 01/Content 2/Panel_sucessAlert/Label_id/money"):GetComponent("UILabel");
	gift_kSucessID = this.transform:FindChild("Content 01/Content 2/Panel_sucessAlert/Label_id/id"):GetComponent("UILabel");
	gift_vRecords = this.transform:FindChild("Content 01/Content 4/Scroll View/Grid");
	gift_recordPrefab = this.transform:FindChild("Content 01/Content 4/Scroll View/Gift_Record").gameObject;
	gift_recordPrefab1 = this.transform:FindChild("Content 01/Content 4/Scroll View/Gift_Record (1)").gameObject;

	gift_buttonGive = this.transform:FindChild("Content 01/Content 2/Button_give").gameObject;
	gift_buttonSendPhoneCode = this.transform:FindChild("Content 01/Content 2/PhoneCode/Button_send").gameObject;
	gift_buttonConfirm = this.transform:FindChild("Content 01/Content 2/Panel_confirmAlert/Button_gift").gameObject;
	gfit_buttonCannel = this.transform:FindChild("Content 01/Content 2/Panel_confirmAlert/Button_cannel").gameObject;
	gift_buttonOK = this.transform:FindChild("Content 01/Content 2/Panel_sucessAlert/Button_confirm").gameObject;

	button_giftRecord = this.transform:FindChild("left/Tabs/Tab 4").gameObject;

	this.mono:AddClick(button_giftRecord,this.ButtonGiftHandle);
	this.mono:AddClick(gift_buttonGive,this.ButtonGiftHandle);
	this.mono:AddClick(gift_buttonOK,this.ButtonGiftHandle);
	this.mono:AddClick(gfit_buttonCannel,this.ButtonGiftHandle);
	this.mono:AddClick(gift_buttonConfirm,this.ButtonGiftHandle);
end
function this.OnClose( go )
	--if Global.instance.isMobile == false then
    --    Panel_Follow.HidePanel(this.gameObject);
    --else
        this.gameObject:SetActive(false);
    --end
end
function this.OnEnable(  )
	this.UpdateUserinfo();
	coroutine.start(SafeValidate.DoCheckValidateType);

    --if Global.instance.isMobile == false then
    --    UIHelper.On_UI_Show(this.gameObject);
    --end
end
function this.ShowValidateInput(validateType)
	this.HideValidateInput();
	print("ShowValidateInput");
	if validateType == SafeValidata.ValidateType.BankPassword then
		vBankPassword:SetActive(true);
	elseif validateType == SafeValidata.validateType.PhoneCode then
		vPhoneCode:SetActive(true);
		this.mono:AddClick(button_sendPhoneCode,this.ButtonPhoneCodeHandle);
	end
end
function this.HideValidateInput(  )
	print("HideValidateInput");
	vBankPassword:SetActive(false);
	vPhoneCode:SetActive(false);
end
function this.OnClickSave( )
	local errorInfo = "";
	if string.len(kDealMeoney.value) == 0 then
		errorInfo = "BankAmount";
	elseif tonumber(kDealMeoney.value) > tonumber(kBagMoney) then
		errorInfo = "BankErrorAmount";
	end
	if string.len(errorInfo) > 0 then
		UIHelper.ShowMessage(GameConfig.get(errorInfo),1);
	else
		coroutine.start(this.DoClickSave);
	end
end
function this.DoClickSave(  )
	UIHelper.ShowProgressHUD(nil,"");
    UIHelper.ShowMessage(GameConfig.get("HttpConnectWait"),2);
	local form = UnityEngine.WWWForm.New();
	form:AddField("amount",kDealMeoney.value);
	local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BANK_SAVE_URL,form);
	coroutine.www(www);
	print(www.text);
	UIHelper.HideProgressHUD();
	local js = cjson.decode(www.text);
	if js["result"] == "ok" then
		--刷新玩家个人数据
		--coroutine.start(EginUserUpdate.Instance.UpdateInfo);
		UIHelper.ShowProgressHUD(nil,"");
		EginUserUpdate.Instance:UpdateInfoNow();
		this.UpdateUserinfo();
	else
		UIHelper.ShowMessage(js["body"],1);
	end
	--UIHelper.HideProgressHUD();
end
function this.OnClickGet(  )
	local errorInfo = "";
	if string.len(kDealMeoney.value) == 0 then
		errorInfo = "BankAmount" 
	elseif tonumber(kDealMeoney.value) > tonumber(kBankMoney) then
		errorInfo = "BankErrorAmount" 
	elseif this.LoginState() == true and string.len(kBankPassword.value) == 0 and string.len(kPhoneCode.value) == 0 then
		errorInfo = "BankPassword";
	end
	if string.len(errorInfo) > 0 then
		UIHelper.ShowMessage(GameConfig.get(errorInfo),1);
	else
		this.DoClickGet();
	end
end
function this.DoClickGet( )
	local password = "";
	local validataType = this.GetValidateType();
	print("type"..validataType);
	if validataType == this.ValidateType.BankPassword then
		password = kBankPassword.value;
		print("BankPassword");
	elseif validataType == this.ValidateType.PhoneCode then
		password = kPhoneCode.value;	
		print("PhoneCode");
	end
	print("password::"..password);
	coroutine.start(this.OnClickValidate,password,this.DoGet);
end
function this.DoGet(  )
	print("DoGet")
	if this.LoginState() == true then
		UIHelper.ShowProgressHUD(nil,"");
		local form = UnityEngine.WWWForm.New();
		form:AddField("amount",kDealMeoney.value);
		local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BANK_GET_URL,form);
		coroutine.www(www);
		print(www.text);
		UIHelper.HideProgressHUD();
		local js = cjson.decode(www.text);
		if js["result"] == "ok" then
			--刷新
			UIHelper.ShowProgressHUD(nil,"");
			--coroutine.start(EginUserUpdate.Instance:UpdateInfo);
			EginUserUpdate.Instance:UpdateInfo(this.UpdateUserinfo)
		else
			UIHelper.ShowMessage(js["body"]);
			
		end
	end
end
--银行记录
function this.OnShowRecordView(  )
	--if UIToggle.GetActiveToggle(kRecordToggle.group == kRecordToggle) then
	recordPage = 1;
	coroutine.start(this.OnLoadRecord,recordPage);
	--end
end
function this.OnLoadRecord( page )
	if page > 0 and page <= maxRecordPage then
		UIHelper.ShowProgressHUD(nil,"");
		UIHelper.ShowMessage(GameConfig.get("HttpConnectWait"),2);
		local form = UnityEngine.WWWForm.New();
		form:AddField("pageindex",page);
		form:AddField("pagesize",recordPageSize);
		local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BANK_RECORD_URL,form);
		coroutine.www(www);
		print(www.text);
		UIHelper.HideProgressHUD();
		local js = cjson.decode(www.text);
		if js["result"] == "ok" then
			this.UpdateBankRecord(js["body"]);
		else
			UIHelper.ShowMessage(js["body"],2);
		end
	end
end
function this.OnClickLastRecord()
	local page = recordPage + 1;
	coroutine.start(this.OnLoadRecord,page);
end
function this.UpdateBankRecord( obj )
	recordPage = obj["page"]["pageindex"];
	maxRecordPage = obj["page"]["pagecount"]
	EginTools.ClearChildren(vRecords);
	local recordInfoList = obj["data"];
	local i = 0;
	for j=1,#recordInfoList do
		--if recordInfoList[j].type == JSONObject.Type.NULL) then break end
		local cell = nil;
		if i % 2 ~= 0 then
			cell = GameObject.Instantiate(recordPrefab1);
		else
			cell = GameObject.Instantiate(recordPrefab);
		end
		cell.transform.parent = vRecords;
		cell.transform.localPosition = Vector3.zero;
		cell.transform.localScale = Vector3.one;
		cell:SetActive(true);
		local actionTime = recordInfoList[j]["action_time"];
		if string.len(actionTime) > 10 then actionTime = string.sub(actionTime,0,10) end
		cell.transform:Find("Label_Time"):GetComponent("UILabel").text = actionTime;
		cell.transform:Find("Label_Type"):GetComponent("UILabel").text = recordInfoList[j]["action_type"];
		cell.transform:Find("Label_Money"):GetComponent("UILabel").text = recordInfoList[j]["action_money"];
		cell.transform:Find("Label_Start"):GetComponent("UILabel").text = recordInfoList[j]["start_money"];
		cell.transform:Find("Label_End"):GetComponent("UILabel").text = recordInfoList[j]["end_money"];
		--if i % 2 ~= 0 then
		--	cell.transform:Find("translucence").gameObject:SetActive(false);
		--end
		i = i + 1;
	end
	vRecords:GetComponent("UIGrid").enabled = true;
end
function this.ButtonBankHandle( go )
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
	if button_take.name == go.name then
		this.OnClickGet();
	elseif button_save.name == go.name then
		this.OnClickSave();
	--elseif button_refresh.name == go.name then
	--	this.UpdateUserinfo();	
	elseif button_bankRecord.name == go.name then
		this.OnShowRecordView();
	end
end
function this.ButtonPhoneCodeHandle( go )
	coroutine.start(this.OnClickSendPhoneCode);
end
function this.UpdateUserinfo(  )
	UIHelper.HideProgressHUD();
	local user = EginUser.Instance;
	kBagMoney = user.bagMoney;
	kBankMoney = user.bankMoney;
	kSaveBankMoney.text = user.bankMoney;

	kDealMeoney.value = "";
	kUserID.value = "";
	kGiveMoney.value = "";

	holdCoin.text = UIHelper.SetCoinStandard(kBagMoney);
	--Panel_Follow.UpdateInfo();
end

--赠送相关
function this.ButtonGiftHandle( go )
	-- body
	if gift_buttonGive.name == go.name then
		this.OnClickGift();
	elseif gift_buttonOK.name == go.name then
		this.OnClickGiftSucessHide();
	elseif gfit_buttonCannel.name == go.name then
		this.OnClickGiftCannel();
	elseif gift_buttonConfirm.name == go.name then
		coroutine.start(this.OnClickGiftConfirm);
	elseif button_giftRecord.name == go.name then
		coroutine.start(this.GiftOnLoadRecord,gift_recordPage);
	end
end

function this.OnClickGift( ... )
	-- body
	local errorInfo = "";
	if string.len(gift_kGiftID.value) == 0 then
		errorInfo = "GiftID";
	elseif string.len(gift_kGIftMoney.value) == 0 then
		errorInfo = "GiftMoney";
	elseif string.len(gfit_kBankPassword.value) == 0 then
		errorInfo = "GiftPassword";
	end
	if string.len(errorInfo) > 0 then
		UIHelper.ShowMessage(GameConfig.get(errorInfo),2);
	else
		coroutine.start(this.DoClickGift);
	end
end

function this.DoClickGift( ... )
	-- body
	coroutine.start(this.ShowConfirmView);
end

function this.OnClickGiftConfirm( ... )
	-- body
	UIHelper.ShowProgressHUD(nil,"");
	local form = UnityEngine.WWWForm.New();
	form:AddField("uid",gift_kGiftID.value);
	form:AddField("money",gift_kGIftMoney.value);
	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.GIFT_DELIVER_URL, form);
	coroutine.www(www);
	local result = HttpConnect.Instance:BaseResult(www);
	UIHelper.HideProgressHUD();
	if HttpResult.ResultType.Sucess == result.resultType then
		this.GiftSucess();
	else
		UIHelper.ShowMessage(tostring(result.resultObject),1);
	end
end

function this.OnClickGiftCannel( ... )
	-- body
	gift_vConfirm:SetActive(false);
end

function this.ShowConfirmView( ... )
	-- body
	UIHelper.ShowProgressHUD(nil,"");

	local moneyZhstr = "";
	local moneyStr = gift_kGIftMoney.value;
	local strLen = string.len(moneyStr);
	if strLen > 8 then
		moneyZhstr =  string.sub(moneyStr,1,strLen-8) ..GameConfig.get("GiftNumberZH_1")..string.sub(moneyStr,strLen-7,strLen-4)  ..GameConfig.get("GiftNumberZH_0")..string.sub(moneyStr,strLen-3,strLen);
	elseif strLen > 4 then
		moneyZhstr =  string.sub(moneyStr,1,strLen-4) ..GameConfig.get("GiftNumberZH_0")..string.sub(moneyStr,strLen-3,strLen);
	else
		moneyZhstr = moneyStr;
	end

	gift_kConfirmID.text = gift_kGiftID.value;
	gift_kConfirmMoney.text = gift_kGIftMoney.value;
	gift_kConfirmMoneyZh.text = moneyZhstr;

	local form = UnityEngine.WWWForm.New();
	form:AddField("uid",gift_kConfirmID.text);
	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.GIFT_NICKNAME_URL, form);
	coroutine.www(www);
	local result = HttpConnect.Instance:GiftNicknameResult(www);
	if HttpResult.ResultType.Sucess == result.resultType then
		gift_kConfirmNickname.text = tostring(result.resultObject);
	end
	gift_vConfirm:SetActive(true);
	UIHelper.HideProgressHUD();
end

function this.GiftSucess( ... )
	-- body
	local tempMoney = gift_kGIftMoney.value;
	local tempStrLen = string.len(tempMoney)
	if ( tempStrLen > 8)  then
		tempMoney =  string.sub(tempMoney,1,tempStrLen-8) ..","..string.sub(tempMoney,tempStrLen-7,tempStrLen-4)  ..","..string.sub(tempMoney,tempStrLen-3,tempStrLen);
	elseif (tempStrLen > 4) then
		tempMoney =  string.sub(tempMoney,1,tempStrLen-4) ..","..string.sub(tempMoney,tempStrLen-3,tempStrLen);
	end
	gift_kSucessID.text = gift_kGiftID.value;
	gift_kSucessMoney.text = tempMoney;
	gift_vSucess:SetActive(true);

	gift_kGiftID.value = "";
	gift_kGIftMoney.value = "";
	gift_vConfirm:SetActive(false);
end

function this.OnClickGiftSucessHide( ... )
	-- body
	gift_vSucess:SetActive(false);
end

function this.GiftOnLoadRecord( page )
	-- body
	if page > 0 and page <= gift_maxRecordPage then
		UIHelper.ShowProgressHUD(nil,"");
		local form = UnityEngine.WWWForm.New();
		form:AddField("pageindex",page);
		form:AddField("pagesize",gift_recordPageSize);
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.GIFT_RECORD_URL, form);
		coroutine.www(www);
		local result = HttpConnect.Instance:BaseResult(www);
		UIHelper.HideProgressHUD();
		if HttpResult.ResultType.Sucess == result.resultType then
			local js = cjson.decode(www.text);
			this.UpdateGiftRecord(js["body"]);
		else
			UIHelper.ShowMessage(tostring(result.resultObject));
		end
	end
end

function this.UpdateGiftRecord( obj )
	-- body
	gift_recordPage = obj["page"]["pageindex"];
	gift_maxRecordPage = obj["page"]["pagecount"];
	EginTools.ClearChildren(gift_vRecords);
	local recordInfoList = obj["data"];
	local i = 0;
	for j=1,#recordInfoList do
		--if recordInfoList[j].type == JSONObject.Type.NULL) then break end
		local cell = nil;
		if i % 2 ~= 0 then
			cell = GameObject.Instantiate(gift_recordPrefab1);
		else
			cell = GameObject.Instantiate(gift_recordPrefab);
		end
		cell.transform.parent = gift_vRecords;
		cell.transform.localPosition = Vector3.zero;
		cell.transform.localScale = Vector3.one;
		cell:SetActive(true);
		local actionTime = recordInfoList[j]["action_time"];
		if string.len(actionTime) > 10 then actionTime = string.sub(actionTime,0,10) end
		cell.transform:Find("Label_Time"):GetComponent("UILabel").text = recordInfoList[j]["to_user_id"];
		cell.transform:Find("Label_Type"):GetComponent("UILabel").text = recordInfoList[j]["action_money"];
		cell.transform:Find("Label_Money"):GetComponent("UILabel").text = recordInfoList[j]["start_money"];
		cell.transform:Find("Label_Start"):GetComponent("UILabel").text = recordInfoList[j]["end_money"];
		cell.transform:Find("Label_End"):GetComponent("UILabel").text = actionTime;
		--if i % 2 ~= 0 then
		--	cell.transform:Find("translucence").gameObject:SetActive(false);
		--end
		i = i + 1;
	end
	gift_vRecords:GetComponent("UIGrid").enabled = true;
end