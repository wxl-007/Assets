local cjson = require "cjson" 
eBankLoginType = {PASSWORD=0, PHONE_AUTH=1, PHONE_CODE=2, WECHAT=3}
 
local this = LuaObject:New()
BankSocket = this
 
SafeValidate= {ValidateType = {BankPassword = 0, PhoneCode = 1}}
this.bankSessionTerm = "0"; --微信登录记录25分钟超时用

function this:clearLuaValue()
	self.mono = nil
	self.gameObject = nil
	self.transform = nil
	
	self.kBagMoney = nil;
	self.kSaveMoney = nil
	self.kSaveBankMoney = nil

	self.kGetToggle = nil
	self.kBankMoney = nil
	self.kGetMoney = nil
	self.vBankPassword = nil
	self.kBankPassword = nil
	self.vPhoneCode = nil
	self.kPhoneCode = nil

	self.kRecordToggle = nil
	self.vRecords = nil
	self.recordPrefab = nil
	self.kRecordPage = nil
	self.recordPage = 1;
	self.maxRecordPage = 1;
	self.recordPageSize = 9;
	self.isLogin = false;
	self.bankPwd = "";
	 
	self.kGiftID = nil
	self.kGiftMoney = nil

	self.vConfirm = nil
	self.kConfirmID = nil
	self.kConfirmNickname = nil
	self.kConfirmMoney = nil
	self.kConfirmMoneyZh = nil

	self.vSucess = nil
	self.kSucessMoney = nil
	self.kSucessID = nil
	self.timeStampLb = nil
	self.nickNameLb = nil
	self.nickName = nil 

	self.oldPsd = nil
	self.newPsd = nil
	self.confirmPsd = nil
	self.loginInput = nil
	self.loginPanel = nil
	self.button_Submit = nil
	self.button_Submitan = false;
	self.sendGiftToggleBtn = nil
	self.changePwdToggleBtn = nil
	self.mCheckState = false;
	self.mLoginState = false;
	self.mValidateType = 0;
	self.tempBankMoney = 1;
	self.tempBagMoney  = 1;
	self.preGiftMoneyStr = "";
	self.prekSaveMoneyStr="";
	self.preGetMoneyStr = "";
	self.bankLoginType = 0;
	self.InvokeLua:clearLuaValue();
	self.InvokeLua = nil; 
	
	coroutine.Stop() 
	LuaGC();
end
function this:InitBankSocket()
	self.kBagMoney = nil;
	self.kSaveMoney = nil
	self.kSaveBankMoney = nil

	self.kGetToggle = nil
	self.kBankMoney = nil
	self.kGetMoney = nil
	self.vBankPassword = nil
	self.kBankPassword = nil
	self.vPhoneCode = nil
	self.kPhoneCode = nil

	self.kRecordToggle = nil
	self.vRecords = nil
	self.recordPrefab = nil
	self.kRecordPage = nil
	self.recordPage = 1;
	self.maxRecordPage = 1;
	self.recordPageSize = 9;
	self.isLogin = false;
	self.bankPwd = "";
	 self.button_Submit = nil
	 self.button_Submitan = false;
	self.kGiftID = nil
	self.kGiftMoney = nil

	self.vConfirm = nil
	self.kConfirmID = nil
	self.kConfirmNickname = nil
	self.kConfirmMoney = nil
	self.kConfirmMoneyZh = nil

	self.vSucess = nil
	self.kSucessMoney = nil
	self.kSucessID = nil
	self.timeStampLb = nil
	self.nickNameLb = nil
	self.nickName = nil 

	self.oldPsd = nil
	self.newPsd = nil
	self.confirmPsd = nil
	self.loginInput = nil
	self.loginPanel = nil
	self.mCheckState = false;
	self.mLoginState = false;
	self.mValidateType = 0;
	self.bankLoginType = 0;
	self.sendGiftToggleBtn = nil
	self.changePwdToggleBtn = nil
	self.preGiftMoneyStr = "";
	self.tempBankMoney = 1;
	self.tempBagMoney  = 1;
	self.InvokeLua = InvokeLua:New(self);
	self.prekSaveMoneyStr="";
	self.preGetMoneyStr = "";
end
 
 

 

function this.Start()
	this:StartBankSocket();
end


function this.OnDisable()
	this:OnDisableBankSocket();
end
function this:OnDisableBankSocket()
	self:clearLuaValue()
end



function this.SocketDisconnect ( disconnectInfo) 
	-- SocketManager.Instance.socketListener = nil; 
end

function this.SocketReceiveMessage( message)
 
	this:socketReceiveHandle(message);
end

function this:SocketReceiveMessage( message)
	
	local messageObj = cjson.decode(message);
	local type = tostring(messageObj["type"]);
	local tag = tostring(messageObj["tag"]);
	if(type == "account") then
	
		if(tag == "storemoney_fail") then 
			EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));
		elseif(tag == "storemoney")  then
			self:saveLoadMoneySuccess( - tonumber(messageObj["body"]));
		elseif(tag == "loadmoney_fail") then
			EginProgressHUD.Instance:HideHUD();
			--取钱失败 body = 0表示系统错误, -1钱不够 -2未登录
			local errorStr = "";
			if( tonumber(messageObj["body"]) == 0) then
				errorStr = "系统错误。";
			elseif( tonumber(messageObj["body"]) == -1) then
				errorStr = "钱不足。";
			elseif( tonumber(messageObj["body"]) == -2) then
				errorStr = "请先登录。";
			else
				errorStr = "系统错误";
			end
			EginProgressHUD.Instance:ShowPromptHUD(errorStr);
		elseif(tag == "loadmoney") then
			--取钱成功
			self:saveLoadMoneySuccess( tonumber(messageObj["body"]));
		elseif(tag == "bankrecord_fail") then
			EginProgressHUD.Instance:HideHUD();
			EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));
		elseif(tag == "bankrecord") then
			EginProgressHUD.Instance:HideHUD();
			self:UpdateBankRecord(messageObj["body"]);
		 	error('in bank record ')
		elseif(tag == "delivermoney_fail") then
			--=> 游戏内转账失败
			--'type':'account', 'tag':'delivermoney_fail'. 'body':各种失败原因end
			EginProgressHUD.Instance:HideHUD();
			EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));
		elseif(tag == "delivermoney") then
			--=> 游戏内转账成功
			--'type':'account', 'tag':'delivermoney', 'body':[to_uid,钱数,时间]end
			self:GiftSucess(tostring(messageObj["body"][3]));
			self:saveLoadMoneySuccess( tonumber(messageObj["body"][2]));
		end
	elseif(type == "money")  then
		
		if(tag == "loginbank") then
			EginProgressHUD.Instance:HideHUD();
			if(tostring(messageObj["body"]) == "success") then
				self.isLogin = true;
				error("-----------------------banklogined")
				if(string.len(self.loginInput.value)  >0) then
					self.bankPwd = self.loginInput.value;
				end
				self.loginPanel:SetActive(false);
				if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT) then
					--UnityEngine.PlayerPrefs.SetString("bankSessionTerm", System.DateTime.Now:AddMinutes(24.5).Ticks.."");
					--UnityEngine.PlayerPrefs.Save();
					this.bankSessionTerm = System.DateTime.Now:AddMinutes(24.5).Ticks.."";
				end
			else
				EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));
			end
		elseif(tag == "come") then
			EginProgressHUD.Instance:HideHUD();
		 
		elseif(tag == "nickname_by_uid") then
			--'type':'money', 'tag':'nickname_by_uid', 'body':infoend  info是昵称
			--如果出错info可能是：访问超时或者用户ID不存在，用户id必须是数字，否则参数错误
			
			EginProgressHUD.Instance:HideHUD();
			if( tostring(messageObj["body"]) == "用户ID不存在"  or  tostring(messageObj["body"]) == "访问超时" or tostring( messageObj["body"]) == "用户id必须是数字"  or  tostring(messageObj["body"]) =="参数错误") then
				self.nickName = ""; 
			else
				self.nickName = System.Text.RegularExpressions.Regex.Unescape(tostring(messageObj["body"]));
			end
			self.nickNameLb.text = self:formatPhoneNickName(self.nickName);
		elseif(tag == "change_bank_password") then
			if(tostring(messageObj["result"]) == "ok") then
				self.oldPsd.value = "";
				self.newPsd.value = "";
				self.confirmPsd.value = "";
				EginProgressHUD.Instance:ShowPromptHUD("修改密码成功!");
			else
				EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));
			end
		end 
	end
end

function this:OnClickBack () 
	SocketConnectInfo.Instance.roomFixseat = true;	-- For auto add desk.
	SocketManager.Instance.socketListener = nil;
	SocketManager.Instance:Disconnect("Exit from the game.");
 
	Utils.LoadLevelGUI("Hall");
end
-- function this:saveLoadMoneySuccess( offsetvalue)
-- 	if offsetvalue ==nil then offsetvalue = 0; end
	
-- 	EginProgressHUD.Instance:HideHUD();
-- 	EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"));
-- 	self.tempBankMoney = self.tempBankMoney -offsetvalue;
-- 	self.tempBagMoney  =self.tempBagMoney  + offsetvalue;
-- 	self.kBagMoney.text = self.tempBagMoney .."";
-- 	self.kSaveBankMoney.text = self.tempBankMoney .."";
-- 	self.kBankMoney.text = self.tempBankMoney .."";

-- 	self.kSaveMoney.value = "";
-- 	self.kGetMoney.value = "";
 
-- end

--Save to bank
function this:OnClickSave()

	local errorInfo = "";
	if ( string.len(self.kSaveMoney.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("BankAmount");
	elseif (tonumber(self.kSaveMoney.value) > tonumber(self.kBagMoney.text))  then
		errorInfo = ZPLocalization.Instance:Get("BankErrorAmount");
	end

	if ( string.len(errorInfo) > 0)  then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else 
		if (PlatformGameDefine.playform.IsSocketLobby) then
			self:sendSaveToBank();
		else
			coroutine.start(self.DoClickSave,self);
		end
	end 
end

function this:sendSaveToBank()

	--type:account, tag:storemoney, body:钱数end
	 
	local jsonStr = cjson.encode({type="account",tag="storemoney",body = self.kSaveMoney.value});
	self.mono:SendPackage(jsonStr); 
end

function this:OnClickGet () 
	local errorInfo = "";
 	if (string.len(self.kGetMoney.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("BankAmount");
	elseif (tonumber(self.kGetMoney.value) > tonumber(self.kBankMoney.text))  then
		errorInfo = ZPLocalization.Instance:Get("BankErrorAmount");
	--[[elseif (   string.len(self.kBankPassword.value) == 0  and  string.len(self.kPhoneCode.value) == 0)  then
		if(EginUser.Instance.bankLoginType ~= EginUser.eBankLoginType.WECHAT) then
			errorInfo = ZPLocalization.Instance:Get("BankPassword");
		end]]--登录成功后不需要密码
	end

	if (string.len(errorInfo) > 0) then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else 
		if (PlatformGameDefine.playform.IsSocketLobby) then
			self:sendGetFromBank();
		else
			coroutine.start(self.DoClickGet,self);
		end
	end
end

function this:sendGetFromBank()

	--<- 游戏中从银行中取钱(阻塞操作, 需要2秒的进度条) 
	local jsonStr = cjson.encode({type="account",tag="loadmoney",body = tonumber(self.kGetMoney.value)});
	self.mono:SendPackage(jsonStr); 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
end
 
function this:OnClickGift () 
	local errorInfo = "";
	if (string.len(self.kGiftID.value ) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("GiftID");
	elseif ( string.len(self.kGiftMoney.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("GiftMoney");
	--[[elseif ( not self.isLogin  and   string.len(self.kBankPassword.value) == 0  and   string.len(self.kPhoneCode.value) == 0) then
		errorInfo = ZPLocalization.Instance:Get("GiftPassword");--]]--登录以后不需要密码
	end 
	
	if ( string.len(errorInfo) > 0)  then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else  
		if( string.len(self.nickName) == 0) then
			--EginProgressHUD.Instance:ShowPromptHUD("用户不存在");
			self.button_Submitan = true;
			local jsonStr = cjson.encode({type="AccountService",tag="nickname_by_uid",body = {uid=self.kGiftID.value}});
			BaseSceneLua.socketManager:SendPackage(jsonStr); 
			EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
		else
			local moneyStr = self.kGiftMoney.value;
			local moneyZhStr = EginTools.numToCnNum(moneyStr);
 
			self.kConfirmID.text = self.kGiftID.value;
			self.kConfirmMoney.text = self.kGiftMoney.value;
			self.kConfirmMoneyZh.text = moneyZhStr;
			self.kConfirmNickname.text = self:formatPhoneNickName(self.nickName);
			self.vConfirm:SetActive(true);
		end
	end
end

function this:OnClickGiftConfirm () 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

	--<-游戏内转账  
	local jsonStr = cjson.encode({type="account",tag="delivermoney",body = {self.kGiftID.value,self.kGiftMoney.value}});
	self.mono:SendPackage(jsonStr); 
end

function this:GiftSucess ( timeStamp) 
	EginProgressHUD.Instance:HideHUD();
	local tempMoney = self.kGiftMoney.value;
	local tempStrLen = string.len(tempMoney)
	if ( tempStrLen > 8)  then
		tempMoney =  string.sub(tempMoney,1,tempStrLen-8) ..","..string.sub(tempMoney,tempStrLen-7,tempStrLen-4)  ..","..string.sub(tempMoney,tempStrLen-3,tempStrLen);
	elseif (tempStrLen > 4) then
		tempMoney =  string.sub(tempMoney,1,tempStrLen-4) ..","..string.sub(tempMoney,tempStrLen-3,tempStrLen);
	end

	self.kSucessID.text = self.nickName;
	self.kSucessMoney.text = tempMoney;
	self.timeStampLb.text = timeStamp;
	self.vSucess:SetActive(true);

	self.kGiftID.value = "";
	self.kGiftMoney.value = "";
	self.nickName = "";
	self.nickNameLb.text = self:formatPhoneNickName(self.nickName);
	self.vConfirm:SetActive(false);
end

function this:OnInputIDChange()
	
	if(  string.len(self.kGiftID.value) > 4) then
		--<-根据用户id获得昵称，向服务器发送
		--'type':'money', 'tag':'nickname_by_uid', 'body':用户idend
		 
		local jsonStr = cjson.encode({type="money",tag="nickname_by_uid",body = self.kGiftID.value});
		self.mono:SendPackage(jsonStr); 
	end
end
function this.OnInputGetMoneyChange()
	this:InputGetMoneyChange()
end
function this.OnInputSaveMoneyChange()
	this:InputSaveMoneyChange()
end
function this.OnInputGiftMoneyChange()
	this:InputGiftMoneyChange()
end
function this:InputSaveMoneyChange()

	--self.kSaveMoney.value
	if( not System.Text.RegularExpressions.Regex.IsMatch(self.kSaveMoney.value, "^[0-9]*$")) then
		self.kSaveMoney.value = self.prekSaveMoneyStr;
	else
		self.prekSaveMoneyStr = self.kSaveMoney.value;
	end
end

function this:InputGetMoneyChange()

	--self.kSaveMoney.value
	if( not System.Text.RegularExpressions.Regex.IsMatch(self.kGetMoney.value, "^[0-9]*$")) then
		self.kGetMoney.value = self.preGetMoneyStr;
	else
		self.preGetMoneyStr = self.kGetMoney.value;
	end
end

function this:InputGiftMoneyChange()

	if( not System.Text.RegularExpressions.Regex.IsMatch(self.kGiftMoney.value, "^[0-9]*$")) then
		self.kGiftMoney.value = self.preGiftMoneyStr;
	else
		self.preGiftMoneyStr = self.kGiftMoney.value;
	end
end

function this:OnClickGiftCancel () 
	self.vConfirm:SetActive(false);
end
function this:OnClickGiftSucessHide () 
	self.vSucess:SetActive(false);
end 


function this:loginBank( pwd)
	if pwd == nil then pwd = "" end
	--'type':'money', 'tag':'loginbank', 'body':'password':密码或者验证码,'pwdcard_r1':密保卡1,'pwdcard_r2':密保卡2endend
	local messageBody = {};
	if( string.len(pwd) > 0) then
		messageBody.password =  pwd;
	else
		messageBody.password =  self.loginInput.value;
	end
	messageBody.pwdcard_r1= "";
	messageBody.pwdcard_r2= "";
	 
	local jsonStr = cjson.encode({type="money",tag="loginbank",body = messageBody});
	self.mono:SendPackage(jsonStr); 
end

function this:OnShowGetView () 
	self = Module_Bank;
	if (UIToggle.GetActiveToggle(self.kGetToggle.group) == self.kGetToggle) then 
		if (PlatformGameDefine.playform.IsSocketLobby) then

			if( not self.isLogin) then
				--self.loginPanel:SetActive(true);
			end
		else
			coroutine.start(self.DoCheckValidateType,self);
		end
	end
end

function this:OnShowRecordView () 
	self = Module_Bank;
	--if (UIToggle.GetActiveToggle(self.kRecordToggle.group) == self.kRecordToggle) then
		self.recordPage = 1;
		if (PlatformGameDefine.playform.IsSocketLobby) then
			
			self:OnLoadRecord(self.recordPage);
		else
			
			coroutine.start(self.OnLoadRecordHttp,self,self.recordPage);
		end
	--end
end
function this:OnLoadRecord ( page) 
	if (page > 0  and  page <= self.maxRecordPage)  then 
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
		--<-银行记录
		--'type':'account', 'tag':'bankrecord',
		--	'body':'pageindex':第几页, 'pagesize':每页几条, 'start_date':起始日期, 'end_date':结束日期end
		--end
		local nowDate = System.DateTime.Now:ToString("yyyy-MM-dd");
		local pastDate = System.DateTime.Now:AddMonths(-1):ToString("yyyy-MM-dd");
		local messageBody ={pageindex=page,pagesize=self.recordPageSize,start_date=pastDate,end_date=nowDate};
	 
		 
		local jsonStr = cjson.encode({type="account",tag="bankrecord",body = messageBody});
		self.mono:SendPackage(jsonStr); 
	end
end

function this:UpdateBankRecord ( obj) 
	 
	self.recordPage = tonumber(obj["page"]["pageindex"]) ;
	self.maxRecordPage = tonumber(obj["page"]["pagecount"]) ;
	self.kRecordPage.text = self.recordPage .."/".. self.maxRecordPage;

	EginTools.ClearChildren(self.vRecords);
	local recordInfoList = obj["data"];
	 
	for key,recordInfo in ipairs(recordInfoList) do
		if (type(recordInfo) == "nil") then  break; end

		local cell = GameObject.Instantiate(self.recordPrefab);
		cell.transform.parent = self.vRecords;
		cell.transform.localPosition = Vector3.New(0, (key-1)*-115, 0);
		cell.transform.localScale = Vector3.one;

		local actionTime = tostring(recordInfo["action_time"]);
		if ( string.len(actionTime) > 10) then  actionTime = string.sub(actionTime,6,string.len(actionTime)); end
		(cell.transform:Find("Label_Time"):GetComponent("UILabel")).text = actionTime;
        local tTypeTxt = System.Text.RegularExpressions.Regex.Unescape(tostring(recordInfo["action_type"]) )
        local tColor = Color.New(129/255,100/255,55/255,1)
        --local tNum = tonumber(recordInfo["action_money"])
        if tTypeTxt == "赠入"then
            tColor = Color.New(204/255,0,0)
        end
        cell.transform:Find("Label_Type"):GetComponent("UILabel").color = tColor
        cell.transform:Find("Label_Money"):GetComponent("UILabel").color = tColor
        cell.transform:Find("Label_Start"):GetComponent("UILabel").color = tColor
        cell.transform:Find("Label_End"):GetComponent("UILabel").color = tColor
        cell.transform:Find("Label_Time"):GetComponent("UILabel").color = tColor
		if (PlatformGameDefine.playform.IsSocketLobby) then
			cell.transform:Find("Label_Type"):GetComponent("UILabel").text = tTypeTxt;
			cell.transform:Find("Label_Money"):GetComponent("UILabel").text = tostring( recordInfo["action_money"]) 
			cell.transform:Find("Label_Start"):GetComponent("UILabel").text =  tostring(recordInfo["start_money"]) 
			cell.transform:Find("Label_End"):GetComponent("UILabel").text =  tostring(recordInfo["end_money"])
        else
			cell.transform:Find("Label_Type"):GetComponent("UILabel").text = tostring(recordInfo["action_type"]);
			cell.transform:Find("Label_Money"):GetComponent("UILabel").text = tostring(recordInfo["action_money"]);
			cell.transform:Find("Label_Start"):GetComponent("UILabel").text = tostring(recordInfo["start_money"]);
			cell.transform:Find("Label_End"):GetComponent("UILabel").text = tostring(recordInfo["end_money"]);
        end

        cell.transform:Find("Label_remark"):GetComponent("UILabel").text =  tostring(recordInfo["remark"])
	end
end

function this:OnClickLastRecord () 
	local page = self.recordPage - 1;
	if (PlatformGameDefine.playform.IsSocketLobby) then
		self:OnLoadRecord(page);
	else
		coroutine.start(self.OnLoadRecordHttp,self,(page));
	end
end
function this:OnClickNextRecord () 
	local page = self.recordPage + 1;
	if (PlatformGameDefine.playform.IsSocketLobby) then
		self:OnLoadRecord(page);
	else
		coroutine.start(self.OnLoadRecordHttp,self,page);
	end
end



function this:OnLogin()
    self.loginType = self.eBankLoginType.PASSWORD
	self:loginBank();
end

function this:OnChangePassword()
	if( self.newPsd.value ~= self.confirmPsd.value) then
		EginProgressHUD.Instance:ShowPromptHUD( "新密码和确认密码不一致" );
	elseif(  string.len(self.oldPsd.value) == 0 ) then
		EginProgressHUD.Instance:ShowPromptHUD( "请输入旧密码" );
	elseif(  string.len(self.newPsd.value) == 0 ) then
		EginProgressHUD.Instance:ShowPromptHUD( "请输入新密码" );
	else
		self:sendChangePwd();
	end
end

function this:sendChangePwd()
 
	local messageBody ={}
	messageBody.old_pwd= self.oldPsd.value;
	messageBody.password= self.newPsd.value;
	messageBody.validate_type= 0;
	messageBody.answer= "";
	messageBody.emailcode= "";
	messageBody.phonecode= "";

	
	local jsonStr = cjson.encode({type="money",tag="change_bank_password",body =messageBody});
	self.mono:SendPackage(jsonStr); 
end
 

 
function this:DoCheckValidateType () 
	if ( not self.mCheckState)  then
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.SAFE_VALIDATE_TYPE_URL, nil);
 
		coroutine.www(www);

		local result = HttpConnect.Instance:BaseResult(www);		
		EginProgressHUD.Instance:HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType)  then
			self.mCheckState = true;
			local resultObj = cjson.decode(result.resultObject:ToString());
			self.mValidateType =   tonumber(resultObj["bank_validate"]);
			local isLogin = ( tonumber(resultObj["is_login"]) == 1);
			self:UpdateLoginState(isLogin);
		else 
			self:UpdateLoginState(false);
			EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
		end
	end
end

function this:OnClickSendPhoneCode () 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.SAFE_SEND_PHONECODE_URL, nil);
	coroutine.www(www);

	local result = HttpConnect.Instance:BaseResult(www);	
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)  then
		EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"));
	else 
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
	end
end

function this:OnClickValidate ( password) 
	if ( not self.mLoginState)  then
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
		local form = UnityEngine.WWWForm.New();
		form:AddField("password", password);
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.SAFE_VALIDATE_LOGIN_URL, form);
		coroutine.www(www);

		local result = HttpConnect.Instance:BaseResult(www);	
		EginProgressHUD.Instance:HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType)  then
			self:UpdateLoginState(true);
		else 
			self:UpdateLoginState(false);
			EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
		end
	end
end
 
function this:UpdateLoginState ( loginState) 		
	self.mLoginState = loginState;
	if (loginState) then
		self:HideValidateInput();
	else 
		self:ShowValidateInput(self.mValidateType);
	end
end

function this:LoginState ()
	return self.mLoginState;
end

function this:GetValidateType ()
	return self.mValidateType;
end

function this:ShowValidateInput (validateType) 
	self:HideValidateInput();

	if validateType == SafeValidate.ValidateType.BankPassword then
		self.vBankPassword:SetActive(true); 
	elseif  validateType == SafeValidate.ValidateType.PhoneCode then
		self.vPhoneCode:SetActive(true);  
	end
end

function this:HideValidateInput () 
	self.vBankPassword:SetActive(false);
	self.vPhoneCode:SetActive(false);
end

function this:DoClickSave () 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

	local form = UnityEngine.WWWForm.New();
	form:AddField("amount", self.kSaveMoney.value);
	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BANK_SAVE_URL, form);
	coroutine.www(www);
	
	local result = HttpConnect.Instance:BaseResult(www);
	if(HttpResult.ResultType.Sucess == result.resultType)  then 
		local wwwUser = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.UPDATE_USERINFO_URL, nil);
		coroutine.www(wwwUser);
		local resultUser= HttpConnect.Instance:BaseResult(wwwUser);
		if(HttpResult.ResultType.Sucess == resultUser.resultType) then
 
			self:UpdateUserWithDict(cjson.decode(resultUser.resultObject:ToString()));
		end
	end
	
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)  then
		EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"));
		self:UpdateUserinfo();
	else  
		coroutine.start(self.loginFailHandle,self);
	end 
end

function this:loginFailHandle()

	PlatformGameDefine.playform:swithWebHostUrl(true,Utils.NullObj);
	EginProgressHUD.Instance:ShowPromptHUD("连接失败，请重新登录。"); 
	coroutine.wait(2.1)
	EginProgressHUD.Instance:HideHUD();
	EginUser.Instance:Logout();
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
	Utils.LoadLevelGUI("Login");
end
function this:DoClickGet () 
	local password = "";
	if self:GetValidateType() == SafeValidate.ValidateType.BankPassword then
		password = self.kBankPassword.value; 
	elseif self:GetValidateType() == SafeValidate.ValidateType.PhoneCode then 
		password = self.kPhoneCode.value; 
	end
	
	coroutine.branch(coroutine.start(self.OnClickValidate,self,(password))) 

	if (self:LoginState()) then
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);	

		local form = UnityEngine.WWWForm.New();
		form:AddField("amount", self.kGetMoney.value);
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BANK_GET_URL, form);
		coroutine.www(www);

		local result = HttpConnect.Instance:BaseResult(www);
		if(HttpResult.ResultType.Sucess == result.resultType)  then
			coroutine.branch(coroutine.start(function() EginUserUpdate.Instance:UpdateInfo(); end));
		end

		EginProgressHUD.Instance:HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType)  then
			EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"));
			self:UpdateUserinfo();
		else  
			coroutine.start(self.loginFailHandle,self);
		end
	end
end
function this:UpdateUserWithDict ( dict) 
	local hasUid = false;
	if (PlatformGameDefine.playform.IsSocketLobby) then
		hasUid = (tostring(EginUser.Instance.uid) == tostring(dict["userid"]));
	else
		hasUid = (tostring(EginUser.Instance.uid) == tostring(dict["id"]));
	end

	if(hasUid) then 
		if(dict["bank_validate"]) then
			if(dict["bank_validate"] == "2") then 
				EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PHONE_AUTH;
			elseif(dict["bank_validate"] == "1")  then
				EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PHONE_CODE;
			else 
				if(dict["wechat_lock"]) then
					if(dict["wechat_lock"] == "1") then
						EginUser.Instance.bankLoginType = EginUser.eBankLoginType.WECHAT;
					else 
						EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PASSWORD;
					end
				else
					EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PASSWORD;
				end
			end
		end
	end
end

function this:OnLoadRecordHttp ( page) 
	if (page > 0  and  page <= self.maxRecordPage)   then
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

		local form = UnityEngine.WWWForm.New();
		form:AddField("pageindex", page);
		form:AddField("pagesize", self.recordPageSize);
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BANK_RECORD_URL, form);		
		coroutine.www(www);

		local result = HttpConnect.Instance:BaseResult(www);
		EginProgressHUD.Instance:HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType)  then
			self:UpdateBankRecord(cjson.decode(result.resultObject:ToString()));
		else 
			coroutine.start(self.loginFailHandle,self);
		end
	end
end

