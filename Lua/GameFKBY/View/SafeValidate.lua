local this = LuaObject:New()
SafeValidate = this;

this.ValidateType = {BankPassword = 0, PhoneCode = 1}

local mCheckState = false;
local mLoginState = false;
local mValidateType;

local cjson = require "cjson"

function this.DoCheckValidateType(  )
	if mCheckState == false then
		UIHelper.ShowProgressHUD(nil,"");
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.SAFE_VALIDATE_TYPE_URL, nil);
		coroutine.www(www);
		print(www.text);
		UIHelper.HideProgressHUD();
		local js = cjson.decode(www.text);
		if js["result"] == "ok" then
			mCheckState = true;
			mValidateType = js["body"]["bank_validate"];
			local temp = js["body"]["is_login"];
			local isLogin;
			if temp == 1 then
				isLogin = true;
			else
				isLogin = false;
			end
			this.UpdateLoginState(isLogin);
		else
			this.UpdateLoginState(false);
			UIHelper.ShowMessage(js["body"],2);
		end
	end
end
function this.OnClickSendPhoneCode(  )
	UIHelper.ShowProgressHUD();
	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.SAFE_SEND_PHONECODE_URL, nil);
	coroutine.www(www);
	print(www.text);
	UIHelper.HideProgressHUD();
	local js = cjson.decode(www.text);
	if js["result"] == "ok" then 
		UIHelper.ShowMessage("HttpConnectSucess",2);
	else
		UIHelper.ShowMessage(js["body"],2);
	end
end
function this.OnClickValidate( password , func)
	if mLoginState == false then
		UIHelper.ShowProgressHUD(nil,"");
		local form = UnityEngine.WWWForm.New();
		form:AddField("password",password);
		local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.SAFE_VALIDATE_LOGIN_URL,form);
		coroutine.www(www);
		print(www.text);
		UIHelper.HideProgressHUD();
		local js = cjson.decode(www.text);
		if js["result"] == "ok" then
			this.UpdateLoginState(true);
		else
			this.UpdateLoginState(false);
			UIHelper.ShowMessage(js["body"],2);
		end
	end
	if func ~= nil then func() end;
end
function this.UpdateLoginState(loginState)
	mLoginState = loginState;
	if loginState == true then
		this.HideValidateInput();
	else
		this.ShowValidateInput(mValidateType);
	end

end
function this.LoginState()
	return mLoginState;
end
function this.GetValidateType( )
	return mValidateType;
end

function this.ShowValidateInput( validateType )
	-- body
end
function this.HideValidateInput(  )
	
end