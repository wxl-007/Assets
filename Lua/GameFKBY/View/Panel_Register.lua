local this = LuaObject:New()
Panel_Register = this;

local kUsername;
local kNickname;
local kPassword;
local kPasswordVerify;

local kPhoneNumber;
local kPhoneNickname;

local kTuiID;--推荐人ID
local vTuiId;

local button_register;
local button_phoneRegister;
local button_close;

local guestReg = false;

function this.Start( ... )
	-- body
	this.Init();
end

function this.Init( ... )
	-- body
	kUsername = this.transform:FindChild("Register/inputs/Input_Account"):GetComponent("UIInput");
	kNickname = this.transform:FindChild("Register/inputs/Input_NickName"):GetComponent("UIInput");
	kPassword = this.transform:FindChild("Register/inputs/Input_PassWord"):GetComponent("UIInput");
	kPasswordVerify = this.transform:FindChild("Register/inputs/Input_PassWord2"):GetComponent("UIInput");
	kPhoneNumber = this.transform:FindChild("phoneRegister/Input_phone"):GetComponent("UIInput");
	kPhoneNickname = this.transform:FindChild("phoneRegister/Input_NickName"):GetComponent("UIInput");
	kTuiID = this.transform:FindChild("Register/inputs/Input_Referrer"):GetComponent("UIInput");
	vTuiId = kTuiID.gameObject;
	button_register = this.transform:FindChild("Register/Button_registerOK").gameObject;
	button_phoneRegister = this.transform:FindChild("phoneRegister/Button_phoneRegisterOK").gameObject;
	button_close = this.transform:FindChild("Button_close").gameObject;

	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		if PlatformGameDefine.playform.IOSPayFlag == true then
			vTuiId:SetActive(true);
		end
	else
		vTuiId:SetActive(true);
	end

	this.mono:AddClick(button_register,this.OnClickRegister);
	this.mono:AddClick(button_phoneRegister,this.OnClickPhoneRegister);
	this.mono:AddClick(button_close,this.ButtonRegisterCloseHandle);
end

function this.OnClickRegister( go )
	-- body
	local errorInfo = "";
	if string.len(kUsername.value) == 0 then
		errorInfo = GameConfig.get("RegisterUsername");
	elseif string.len(kNickname.value) == 0 then
		errorInfo = GameConfig.get("RegisterNickname");
	elseif string.len(kPassword.value) == 0 then
		errorInfo = GameConfig.get("RegisterPassword");
	elseif kPassword.value ~= kPasswordVerify.value then
		errorInfo = GameConfig.get("RegisterPasswordVerify");
	end
	if string.len(errorInfo) > 0 then
		UIHelper.ShowMessage(errorInfo,1);
	else
		coroutine.start(this.DoClickRegister);
	end
end

function this.DoClickRegister()
	-- body
	UIHelper.ShowMessage(GameConfig.get("HttpConnectWait"),1);
    UIHelper.ShowProgressHUD(nil,"");
    local url = ConnectDefine.REGISTER_MOBILE_URL;
    local form = UnityEngine.WWWForm.New();
    local guestid = UnityEngine.PlayerPrefs.GetString("GuestUserId", "");
    if string.len(guestid) > 0 and guestReg == true then
    	url = ConnectDefine.GUEST_RESGISTER_URL;
        local sign = guestid .. kUsername.value .. kNickname.value .. kPassword.value .. "ntt,{k45a,hjop:vxb$;+rtb0bjh?luz";
        sign = EginTools.MD5Coding(sign);
        form:AddField("uid", guestid);
        form:AddField("sign", sign);
    end
    form:AddField("username", kUsername.value);
    form:AddField("password", kPassword.value);
    form:AddField("nickname", kNickname.value);
    form:AddField("agent_id", kTuiID.value);

    local www = HttpConnect.Instance:HttpRequest(url, form);
    coroutine.www(www);
    local result;
    if string.len(guestid) > 0 and guestReg == true then
    	result = HttpConnect.Instance:GuestRegisterResult(www);
    else
    	result = HttpConnect.Instance:RegisterResult(www);
    end
    UIHelper.HideProgressHUD();
    if HttpResult.ResultType.Sucess == result.resultType then
    	coroutine.start(this.DoLogin);
    	if guestReg == true then
    		UnityEngine.PlayerPrefs.SetString("GuestUserId", "");
        end

        UnityEngine.PlayerPrefs.SetString("EginUsername", kUsername.value);
        UnityEngine.PlayerPrefs.SetString(kUsername.value, kPassword.value);
        local _allUsername = "";
        local allUsername = string.split(UnityEngine.PlayerPrefs.GetString("AllUser", ""),":");
        for k,v in pairs(allUsername) do
        	local name = v;
        	if name == guestid and guestReg == true then
        		name = kUsername.value;
        	end
        	if k == 1 then
        		_allUsername = _allUsername .. name;
        	else
        		_allUsername = _allUsername .. ":" .. name;
        	end
        end
        UnityEngine.PlayerPrefs.SetString("AllUser", _allUsername);
        UnityEngine.PlayerPrefs.Save();
    else
    	UIHelper.ShowMessage(tostring(result.resultObject));
    end
end

function this.OnClickPhoneRegister( go )
	-- body
	local errorInfo = "";
	if string.len(kPhoneNumber.value) == 0 then
        errorInfo = GameConfig.get("RegisterPhoneNumber");
    elseif string.len(kPhoneNickname.value) == 0 then
        errorInfo = GameConfig.get("RegisterPhoneNickname");
    end

    if string.len(errorInfo) > 0 then
        UIHelper.ShowMessage(errorInfo);
    else
        coroutine.start(this.DoClickPhoneRegister);
    end
end

function this.ButtonRegisterCloseHandle( go )
	-- body
	--local active = Global.uiFollow.activeSelf;
	--if active == false then
	--	Login.HidePanel(gameObject);
	--else
	--	Panel_Follow.HidePanel(gameObject);
	--end
	Panel_Follow.HidePanel(this.gameObject);
end

function this.SetGuestReg( value )
	-- body
	guestReg = value;
end

function this.DoLogin( ... )
	-- body
	UIHelper.ShowMessage(GameConfig.get("HttpConnectLogin"),1);
	UIHelper.ShowProgressHUD(nil,"");

	UnityEngine.PlayerPrefs.SetString("EginUsername", kUsername.value);
	UnityEngine.PlayerPrefs.SetString(kUsername.value,kPassword.value);
    UnityEngine.PlayerPrefs.Save();

    local form = UnityEngine.WWWForm.New();
    form:AddField("username", kUsername.value);
    form:AddField("password", kPassword.value);
    local www = HttpConnect.Instance:HttpRequest(ConnectDefine.LOGIN_URL, form);
    coroutine.www(www);

    local result = HttpConnect.Instance:UserLoginResult(www);
    UIHelper.HideProgressHUD();
    if HttpResult.ResultType.Sucess == result.resultType then
    	if UnityEngine.PlayerPrefs.HasKey("GuestUserId") and guestReg then
    		UnityEngine.PlayerPrefs.DeleteKey("GuestUserId");
    		Login.HidePanel(gameObject);
    	end
    	Utils.LoadLevel("Select",false);
    else
    	UIHelper.ShowMessage(tostring(result.resultObject));
    end
end

function this.DoClickPhoneRegister( ... )
	-- body
	UIHelper.ShowMessage(GameConfig.get("HttpConnectWait"),1);
    UIHelper.ShowProgressHUD(nil,"");

    local url = ConnectDefine.REGISTER_MOBILE_PHONE_URL;
    local form = UnityEngine.WWWForm.New();
    local guestid = UnityEngine.PlayerPrefs.GetString("GuestUserId", "");
    if string.len(guestid) > 0 and guestReg == true then
    	url = ConnectDefine.GUEST_PHONE_REGIST_URL;
        local sign = guestid .. kPhoneNumber.value .. kPhoneNickname.value .. "ntt,{k45a,hjop:vxb$;+rtb0bjh?luz";
        sign = EginTools.MD5Coding(sign);
        form:AddField("uid", guestid);
        form:AddField("sign", sign);
    end
    form:AddField("phone", kPhoneNumber.value);
    form:AddField("nickname", kPhoneNickname.value);
    local www = HttpConnect.Instance:HttpRequest(url, form);
    coroutine.www(www);
    local result;
    if string.len(guestid) > 0 and guestReg == true then
    	result = HttpConnect.Instance:GuestRegisterResult(www);
    else
    	result = HttpConnect.Instance:RegisterResult(www);
    end
    UIHelper.HideProgressHUD();
    if HttpResult.ResultType.Sucess == result.resultType then
    	local promptTime = 5;
        UIHelper.ShowMessage(GameConfig.get("RegisterPhoneSucess"),1);
        UIHelper.ShowProgressHUD(nil,"");

        coroutine.wait(promptTime);
        Utils.LoadLevel("Login");
    else
    	UIHelper.ShowMessage(tostring(result.resultObject));
    end
end