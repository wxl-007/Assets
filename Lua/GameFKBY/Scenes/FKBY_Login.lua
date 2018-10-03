
local this = LuaObject:New()
FKBY_Login = this;

--账号密码
local kUsername;
local kPassword;

local button_login;
local button_register;
local button_forget;

--手机验证
local verifyView;
local verifyCode;
local button_verifyOk;

--验证码
local yanView;
local kYanZheng;
local kYanImg;

--退出选择
local button_quitOK;
local button_quitCanel;

--面板
--local panel_black;
local panel_register;
local panel_quit;
local panel_guestReg;

local mVersionCode;
local mNewVersionCode;
local mVersionUpdateUrl;

local popupList;
local allUsername = {};

local isClick = false;
local captcha_hiddentext = "";
local errNum;
local activePanel = {};

local quickType = 0;

require "GameFKBY/View/Panel_Register";

function this:Awake()
	print("------------------awake of login-------------");	
	if Global.backLogin == true then 
		Global.instance:StartMuisc("bg02",0.8);
	end
end

function this.Start()
	-- body
	this.Init();
end

function this.Init()
	-- body
	kUsername = GameObject.Find("UI Root/Panel_Login/backboard/account"):GetComponent("UIInput");
	kPassword = GameObject.Find("UI Root/Panel_Login/backboard/password"):GetComponent("UIInput");

	button_login = GameObject.Find("UI Root/Panel_Login/Button_login");
	button_register = GameObject.Find("UI Root/Panel_Login/backboard/register");
	button_forget = GameObject.Find("UI Root/Panel_Login/backboard/http_forget");

	verifyView = GameObject.Find("UI Root/Panel_Login/backboard/verify");
	verifyCode = verifyView.transform:FindChild("Input"):GetComponent("UIInput");
	button_verifyOk = verifyView.transform:FindChild("Button_ok").gameObject;

	yanView = GameObject.Find("UI Root/Panel_Login/backboard/yanzheng");
	kYanZheng = GameObject.Find("UI Root/Panel_Login/backboard/yanzheng"):GetComponent("UIInput");
	kYanImg = GameObject.Find("UI Root/Panel_Login/backboard/yanzheng/Texture");

	button_quitOK = GameObject.Find("UI Root").transform:FindChild("Panel_quit/Button_OK").gameObject;
	button_quitCanel = GameObject.Find("UI Root").transform:FindChild("Panel_quit/Button_canel").gameObject;

	panel_register = GameObject.Find("UI Root/Panel_register");
	panel_quit = GameObject.Find("UI Root").transform:FindChild("Panel_quit").gameObject;
	panel_guestReg = GameObject.Find("UI Root/Panel_guestreg");
	--panel_black = GameObject.Find("UI Root").transform:FindChild("Panel_black").gameObject;

	popupList = GameObject.Find("UI Root/Panel_Login/backboard/account/btn"):GetComponent("UIPopupList");
	allUsername = string.split(UnityEngine.PlayerPrefs.GetString("AllUser", ""),":");
	local guestid = UnityEngine.PlayerPrefs.GetString("GuestUserId", "");
	local hasGuest = false;
	for k,v in pairs(allUsername) do
		if string.len(v) > 0 then
			popupList:AddItem(v);
			if v == guestid then
				hasGuest = true;
			end
		end
	end
	if string.len(guestid) > 0 and hasGuest == false then
		popupList:AddItem(guestid);
	end
	local username = UnityEngine.PlayerPrefs.GetString("EginUsername", "");
	kUsername.value = username;
    popupList.value = username;
    if string.len(kUsername.value) > 0 then
    	kPassword.value = UnityEngine.PlayerPrefs.GetString(kUsername.value, "");
	end

	this.mono:AddClick(kYanImg,this.RefreshYanZhengHandle);

	this.mono:AddClick(button_login,this.Button_LoginHandle);
	this.mono:AddClick(button_register,this.Button_LoginHandle);
	this.mono:AddClick(button_forget,this.Button_LoginHandle);
	this.mono:AddClick(button_verifyOk,this.ClickVerifyHandle);
	this.mono:AddClick(button_quitOK,this.ButtonQuitPanelHandle);
	this.mono:AddClick(button_quitCanel,this.ButtonQuitPanelHandle);

	this.loadConf();
end

function this:OnDestroy()

end

function this.loadConf( ... )
	-- body
	if PlatformGameDefine.playform.IsYan == true then
		yanView:SetActive(true);
		coroutine.start(this.refreshYanImg);
		isClick = true;
	else
		yanView:SetActive(false);
		this.CheckAutoLogin();
	end
end

function this.refreshYanImg( ... )
	-- body
	local www = HttpConnect.Instance:HttpRequest(ConnectDefine.YAN_ZHENG_URL,nil);
	coroutine.www(www);
	--print(www.text);
	local js = cjson.decode(www.text);
	local yanUr;
	if js["result"] == "ok" then
		local info = js["body"];
		yanUrl = ConnectDefine.HostURL .. info["imageurl"];
		captcha_hiddentext = info["hiddentext"];
		local www1 = UnityEngine.WWW.New(yanUrl);
		coroutine.www(www1);

		local uiT = kYanImg:GetComponent("UITexture");
		uiT.mainTexture = www1.texture;

		errNum = 0;
		isClick = true;
	else
		errNum = errNum + 1;
		if errNum < 4 then
			coroutine.start(this.refreshYanImg);
		else
			isClick = true;
		end
	end
end

function this.CheckAutoLogin( ... )
	-- body
	if string.len(kUsername.value) > 0 and Global.backLogin == false then
        if kUsername.value == UnityEngine.PlayerPrefs.GetString("GuestUserId", "") then
            coroutine.start(this.OnClickGuest);
        elseif string.len(kPassword.value) > 0 then
            coroutine.start(this.DoClickLogin);
        end
    end
end

function this.RefreshYanZhengHandle( go )
	-- body
	this.OnClickRefreshYanZheng();
end

function this.OnClickRefreshYanZheng( ... )
	-- body
	if isClick == true then
		errNum = 0;
		coroutine.start(this.refreshYanImg);
	end
end

function this.ClickVerifyHandle( go )
	-- body
	this.OnClickVerify();
end
function this.OnClickVerify( ... )
	-- body
	verifyView:SetActive(false);
	coroutine.start(this.DoVerify);
end
function this.DoVerify( ... )
	-- body
	UIHelper.ShowProgressHUD(nil,"");
	UIHelper.ShowMessage(GameConfig.get("HttpConnectLogin"));
	local username = kUsername.value;
	local form = UnityEngine.WWWForm.New();
	form:AddField("username", username);
    form:AddField("verify_code", verifyCode.value);
    form:AddField("device_id", "unity_" .. UnityEngine.SystemInfo.deviceUniqueIdentifier);

    local www = HttpConnect.Instance:HttpRequest(ConnectDefine.VERIFY_CODE_URL, form);
    coroutine.www(www);
    UIHelper.HideProgressHUD();
    local js = cjson.decode(www.text);
	local info = js["body"];
	if js["result"] == "ok" then
		Utils.LoadLevel("Select");
	else
		UIHelper.ShowMessage(info,1);
	end
end

function this.OnClickGuest( ... )
	-- body
	UIHelper.ShowProgressHUD(nil,"");
    UIHelper.ShowMessage(GameConfig.get("HttpConnectLogin"));

    local guestid = UnityEngine.PlayerPrefs.GetString("GuestUserId","");
    local form = nil;
    if string.len(guestid) > 0 then
    	form = UnityEngine.WWWForm.New();
		form:AddField("uid",guestid);
	end
	local www = HttpConnect.Instance:HttpRequest(ConnectDefine.GUEST_LOGIN_URL,form);
	coroutine.www(www);

	local js = cjson.decode(www.text);
	local info = js["body"];
	if js["result"] == "ok" then
		UnityEngine.PlayerPrefs.SetString("GuestUserId",EginUser.Instance.uid);
		Global.RegisterPrompt = true;
		this.SaveLoginInfo();

		--测试用
		if Global.gameTest then
			this.QuickEnter();
		else
			Utils.LoadLevel("Select");
		end
		if Global.backLogin == false then
			Global.backLogin = true;
		end
	else
		UIHelper.ShowMessage(info,1);
	end
end

function  this.OnClickLogin( ... )
	-- body
	local errorInfo = "";
	if string.len(kUsername.value) == 0 then
		errorInfo = "请输入用户名";
	elseif string.len(kPassword.value) == 0 then
		if kUsername.value == UnityEngine.PlayerPrefs.GetString("GuestUserId","") then
			coroutine.start(this.OnClickGuest);
			return;
		end
		errorInfo = "请输入密码";
	end
	if string.len(errorInfo) > 0 then
		UIHelper.ShowMessage(errorInfo,2);
	else
		coroutine.start(this.DoClickLogin);
	end
end

function this.DoClickLogin( ... )
	-- body
	UIHelper.ShowProgressHUD(nil,"");

	local form = UnityEngine.WWWForm.New();
	form:AddField("username",kUsername.value);
	form:AddField("password",kPassword.value);
	form:AddField("device_id", "unity_" .. UnityEngine.SystemInfo.deviceUniqueIdentifier);

	if PlatformGameDefine.playform.IsYan == true then
		form:AddField("captcha_text", kYanZheng.value);
        form:AddField("captcha_hiddentext", captcha_hiddentext);
    end

    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
    	local mVersionCode = math.max(UnityEngine.PlayerPrefs.GetInt("VersionCode", PlatformGameDefine.game.VersionCode), PlatformGameDefine.game.VersionCode);
    	form:AddField("version", mVersionCode);
        form:AddField("platform", "Android");
    else
    	form:AddField("platform","iOS");
    end

    local www = HttpConnect.Instance:HttpRequest(ConnectDefine.LOGIN_URL, form);
    coroutine.www(www);
    HttpConnect.Instance:UserLoginResult(www);
    UIHelper.HideProgressHUD();
    local js = cjson.decode(www.text);
	local info = js["body"];
    if js["result"] == "ok" then
    	this.SaveLoginInfo();
    	--测试用
    	if quickType ~= 0 then
    		this.QuickEnter(quickType);
		else
    		BYResourceManager.LoadLevel("FKBY_Select");
		end
    	if Global.backLogin	== false then
    		Global.backLogin = true;
		end
	elseif	info ~= nil then
		if tostring(info) == "device_verify" then
			UIHelper.On_UI_Show(verifyView);
			verifyView:SetActive(true);
		else
			UIHelper.ShowMessage(info,2.5);
			this.OnClickRefreshYanZheng();
		end
	end
end

function this.SaveLoginInfo( ... )
	-- body
	UnityEngine.PlayerPrefs.SetString("EginUsername",kUsername.value);
	UnityEngine.PlayerPrefs.SetString(kUsername.value,kPassword.value);
	local _allUsername = "";
	if #allUsername > 1 then
		local hasUser = false;
		for k,v in pairs(allUsername) do
			--print(k,v)
			local username = v;
			if username == kUsername.value then
				hasUser = true;
			end
			if k == 1 then
				_allUsername = _allUsername .. username;
			else
				_allUsername = _allUsername .. ":" .. username;
			end
		end
		if hasUser == false then
			_allUsername = _allUsername .. ":" .. kUsername.value;
		end
	elseif #allUsername > 0 then
		if string.len(allUsername[1]) > 0 then
			_allUsername = allUsername[1] .. ":" .. kUsername.value;
		else
			_allUsername = kUsername.value;
		end
	else
		_allUsername = kUsername.value;
	end
	UnityEngine.PlayerPrefs.SetString("AllUser",_allUsername);
	UnityEngine.PlayerPrefs.Save();
end

function this.QuickEnter( quickType )
	-- body
	coroutine.start(this.OnClickQuick,quickType);
end

function this.OnClickQuick( quickType )
	-- body
	UIHelper.ShowProgressHUD(nil,"");
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local ro = math.random();
	local url = ConnectDefine.ROOM_LIST_URL .. PlatformGameDefine.game.GameID .. "/?room_type=" .. quickType .. "&minv=20000&maxv=39999&" .. ro;

	local www = HttpConnect.Instance:HttpRequest(url,nil);
	coroutine.www(www);
	local result = HttpConnect.Instance:RoomListResult(www);
	local js = cjson.decode(www.text);
	local info = js["body"];
	if js["result"] == "ok" then
		local userMoney = tonumber(EginUser.Instance.bagMoney);
		local roomlist = result.resultObject;
		local selectedRoom = nil;
		for i=0, roomlist.Count - 1 do
			if userMoney >= tonumber(roomlist[i].minMoney) then
				selectedRoom = roomlist[i];
				break;
			end
		end
		if selectedRoom ~= nil then
			--Global.SetSpecialGunId(tonumber(selectedRoom.roomType));
			selectedRoom.fixseat = false;
			SocketConnectInfo.Instance:Init(EginUser.Instance, selectedRoom);
			local socketManager = SocketManager.Instance;
			coroutine.wait(0.1);
			socketManager:Connect(SocketConnectInfo.Instance,nil,true);
			UIHelper.HideProgressHUD();
			BYResourceManager.StartGame();
		else
			UIHelper.ShowMessage(GameConfig.get("HallQuickPlayError"),1);
		end
	else
		UIHelper.ShowMessage(info,1);
	end
end

function this.Button_LoginHandle( go )
	-- body
	if button_login.name == go.name then
		if Global.IsClient == false then
			this.OnClickLogin();
		else
			EginUser.Instance:InitUserWithDict(BYWebServer.getUserInfo().ToDictionary(), "1");
			Utils.LoadLevel("Select");
		end
	elseif button_register.name == go.name then
		if IsNil(panel_register) == false then
			this.ShowPanel(panel_register);
		else
			BYResourceManager.Instance:CreateLuaPanel("Panel_Register","Panel_Register",true,this.SetRegisterPanel);
		end
	elseif button_forget.name == go.name then
		UnityEngine.Application.OpenURL(ConnectDefine.FORGET_PASSWORD_URL);
	end
end

function this.SetRegisterPanel( go )
	-- body
	panel_register = go;
	this.ShowPanel(panel_register);
	if string.len(UnityEngine.PlayerPrefs.GetString("GuestUserId", "")) > 0 then
		panel_guestReg = panel_register.transform:FindChild("Panel_guestreg").gameObject;
        this.ShowPanel(panel_guestReg);
        this.mono:AddClick(panel_guestReg.transform:FindChild("Button_OK").gameObject,this.GuestRegHandle);
        this.mono:AddClick(panel_guestReg.transform:FindChild("Button_canel").gameObject,this.GuestRegHandle);
    end
end

function this.ShowPanel( _panel )
	-- body
	--activePanel[#activePanel+1] = _panel;
	_panel:SetActive(true);
    --panel_black:GetComponent("UIPanel").depth = _panel:GetComponent("UIPanel").depth - 1;
    --panel_black:SetActive(true);
    UIHelper.On_UI_Show(_panel);
end

function this.GuestRegHandle( go )
	-- body
	if go.name == "Button_OK" then
		Panel_Register.SetGuestReg(true);
	elseif go.name == "Button_canel" then
		Panel_Register.SetGuestReg(false);
	end
	this.HidePanel(panel_guestReg);
end

function this.HidePanel( _panel )
	-- body
	UIHelper.On_UI_Hiden(_panel);
	--table.remove(activePanel,#activePanel);
	coroutine.start(this.CloseComplete,_panel);
end
function  this.CloseComplete(go)
	-- body
	coroutine.wait(0.35);
	go:SetActive(false);
end

function this.ButtonQuitPanelHandle( go )
	-- body
	if button_quitOK.name == go.name then
		UnityEngine.Application.Quit();
	elseif button_quitCanel.name == go.name then
		this.HidePanel(panel_quit);
	end
end

function this.Update()
	-- body
	if Input.GetKeyDown(KeyCode.Escape) == true then
		this.ShowPanel(panel_quit);
	end
end