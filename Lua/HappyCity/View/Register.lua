 require "HappyCity/View/Hall"

 local this = LuaObject:New()
Register = this


function this:Init()
	 
	this.kUsername = this.transform:FindChild("Offset/Views/Register/Input_Username/Input").gameObject:GetComponent("UIInput");
	this.kNickname = this.transform:FindChild("Offset/Views/Register/Input_Nickname/Input").gameObject:GetComponent("UIInput");
	this.kPassword = this.transform:FindChild("Offset/Views/Register/Input_Password/Input").gameObject:GetComponent("UIInput");
	this.kPasswordVerify = this.transform:FindChild("Offset/Views/Register/Input_Ps/Input").gameObject:GetComponent("UIInput");

	this.kPhoneNumber = this.transform:FindChild("Offset/Views/PhoneRegister/Input_PhoneNumber/Input").gameObject:GetComponent("UIInput");
	this.kPhoneNickname = this.transform:FindChild("Offset/Views/PhoneRegister/Input_VerifyCode/Input").gameObject:GetComponent("UIInput");

	this.kTuiID = this.transform:FindChild("Offset/Views/Register/Input_tuiJian/Input").gameObject:GetComponent("UIInput");--推荐人ID
	this.vTuiId = this.transform:FindChild("Offset/Views/Register/Input_tuiJian").gameObject ;
 	

 	
	-- this.m_IsSocket = true;
end
function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
 
	this.kUsername  = nil
	this.kNickname  = nil
	this.kPassword  = nil
	this.kPasswordVerify  = nil

	this.kPhoneNumber  = nil
	this.kPhoneNickname  = nil

	this.kTuiID  = nil
	this.vTuiId  = nil
	this.m_IsSocket = nil

	coroutine.Stop()
	LuaGC()
end

function this:Awake()
	this.mono._IsOverride_OnSocketDisconnect = true;
    this.mono._IsOverride_Process_account_login = true;
	this.mono._IsOverride_Process_account_login_Failed = true;
	
	this:Init()
	
	this.mono:AddClick(this.transform:FindChild("Offset/BackgroundTitle/Button_Back - Anchor/ImageButton").gameObject, this.OnClickClose,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Register/Button_Submit").gameObject, this.OnClickRegister,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/PhoneRegister/Button_Submit").gameObject, this.OnClickPhoneRegister,this) 
	this.mono:AddClick(this.transform:FindChild('Offset/Views/PhoneRegister/Button_GetCode').gameObject,this.OnGetIdentifyCode,this)
	-- this.transform:FindChild('Offset/Views/PhoneRegister/Button_GetCode').gameObject:GetComponent('UIButton').isEnabled= false


	-- ShowHallPanel(this.gameObject,true,nil,function ( )
	-- 	this.transform:FindChild('Offset/Black_Background').gameObject:SetActive(true)
	-- end)

end
function this:Start ()  

	--添加对渠道代理id的判断
	if(not System.String.IsNullOrEmpty(Utils.Agent_Id)) then 
		this.kTuiID.value = Utils.Agent_Id;
		this.kTuiID:GetComponent("BoxCollider").enabled = false;
	end
	
	if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
			 
		if (PlatformGameDefine.playform.IOSPayFlag)  then
			this.vTuiId:SetActive(true);
		end
	else
		this.vTuiId:SetActive(true);
	end
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
    if sceneRoot then 
        sceneRoot.manualHeight = 1920;
        sceneRoot.manualWidth = 1080;
    end


	this.m_IsSocket = true; --PlatformGameDefine.playform.IsSocketLobby
	if (this.m_IsSocket) then this.mono:EndSocket(true); end
	
	coroutine.start(this.LoadWebIp);

end

function this.LoadWebIp()
	coroutine.wait(0.1)
	local tIsCoroutine = DoneCoroutine.New();
	this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadConfig_web_hostArr(Utils.NullObj,false),tIsCoroutine)
	coroutine.branchC(tIsCoroutine);
end


function this:OnDestroy()
	this:clearLuaValue() 
end
 
 
function this:OnClickClose () 
	-- this.mono:EginLoadLevel("Login");
	this:ToPanel('Login')
end

function this:OnClickRegister ()
	local errorInfo = "";
	if ( string.len(this.kUsername.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("RegisterUsername");
	elseif ( string.len(this.kNickname.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("RegisterNickname");
	elseif ( string.len(this.kPassword.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("RegisterPassword");
	elseif ( this.kPassword.value ~=this.kPasswordVerify.value) then
		errorInfo = ZPLocalization.Instance:Get("RegisterPasswordVerify");
	end
	
	if ( string.len(errorInfo) > 0)  then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else 
		if (this.m_IsSocket) then
			this:SocketRegister();
		else 
			coroutine.start(this.DoClickRegister,this);
		end
	end
end
function this:DoClickRegister () 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
	
	local form = UnityEngine.WWWForm.New();
	form:AddField("username", this.kUsername.value);
	form:AddField("password", this.kPassword.value);
	form:AddField("nickname", this.kNickname.value);
	form:AddField("agent_id", this.kTuiID.value);


	local www = HttpConnect.Instance:HttpRequest(ConnectDefine.REGISTER_MOBILE_URL, form);
	coroutine.www(www);
	
	local result = HttpConnect.Instance:RegisterResult(www);		
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)  then
		coroutine.start(this.DoLogin,this);
	else 
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
	end
end
function this:DoLogin ()  
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),false);
	
	UnityEngine.PlayerPrefs.SetString("EginUsername", this.kUsername.value);
	UnityEngine.PlayerPrefs.Save();
	
	local form = UnityEngine.WWWForm.New();
	form:AddField("username", this.kUsername.value);
	form:AddField("password", this.kPassword.value);
	local www = HttpConnect.Instance:HttpRequest(ConnectDefine.LOGIN_URL, form);
	coroutine.www(www);
	
	local result = HttpConnect.Instance:UserLoginResult(www);
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)  then
		-- this.mono:EginLoadLevel("Hall");
		this:ToPanel('Hall')
	else  
		-- this.mono:EginLoadLevel("Login");
		this:ToPanel('Login')
	end
end

function this:OnClickPhoneRegister() 
	local errorInfo = "";
	if ( string.len(this.kPhoneNumber.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("RegisterPhoneNumber");
	-- elseif ( string.len(this.kPhoneNickname.value) == 0)  then
	-- 	errorInfo = ZPLocalization.Instance:Get("RegisterPhoneNickname");
	end
	
	if ( string.len(errorInfo) > 0)  then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else 
		if (this.m_IsSocket) then
			this:SocketPhoneRegister( )
		else 
			coroutine.start(this.DoClickPhoneRegister,this);
		end
		
	end
end
function this:DoClickPhoneRegister () 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
	
	local form = UnityEngine.WWWForm.New();
	form:AddField("phone", this.kPhoneNumber.value);
	form:AddField("nickname", this.kPhoneNickname.value);
	local www = HttpConnect.Instance:HttpRequest(ConnectDefine.REGISTER_MOBILE_PHONE_URL, form);
	coroutine.www(www);
	
	local result = HttpConnect.Instance:RegisterResult(www);		
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)  then
		local promptTime = 5;
		EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("RegisterPhoneSucess"), promptTime); 
		coroutine.wait(promptTime) 
		-- this.mono:EginLoadLevel("Login");
		this:ToPanel('Login')
	else 
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
	end
end

function this:SocketPhoneRegister( )
	EginProgressHUD.Instance:ShowWaitHUD('请等待',true)
	if EginUser.Instance.device_id  == nil or EginUser.Instance.device_id==''  then
		EginUser.Instance.device_id = UnityEngine.SystemInfo.deviceUniqueIdentifier
	end
	EginUser.Instance.phoneNum = this.kPhoneNumber.value
	EginUser.Instance.phonecode = this.kPhoneNickname.value

	ProtocolHelper._LoginType =  LoginType.Phone 
	local bodyJson = {}
	bodyJson['phone'] = EginUser.Instance.phoneNum
	bodyJson['device_id'] = EginUser.Instance.device_id
	bodyJson['phonecode'] = EginUser.Instance.phonecode 
	bodyJson['agent_id'] = Utils.Agent_Id;
	UnityEngine.PlayerPrefs.SetString("LoginType",'Phone');
	UnityEngine.PlayerPrefs.Save();
	local loginJson = {}
	loginJson['type'] = 'AccountService'
	loginJson['tag'] = 'mobile_oauth'
	loginJson['body'] = bodyJson
	
	this.mono:Request_lua_fun("AccountService/mobile_oauth",cjson.encode(bodyJson),function(message) 
			local tMsg = cjson.decode(message)
			--lua EginUser 赋值
			this:SetUserInfo(message,'')
			EginProgressHUD.Instance:ShowWaitHUD( false)
			-- this.mono:EginLoadLevel("Hall");
			this:ToPanel('Hall')
			--渠道处理
			Module_Channel.Instance:handleReg()
		end,
		function(message)   
			if message =='phonecode' then
				this.NeedIdentityCode = true 
				EginProgressHUD.Instance:ShowWaitHUD( false)
				EginProgressHUD.Instance:ShowPromptHUD('需要手机验证码', 2);
				-- this.PhoneSummit:SetActive(false) 
				-- this.OnClickPhoneLogin()
			else
				EginProgressHUD.Instance:ShowWaitHUD( false)
				EginProgressHUD.Instance:ShowPromptHUD(message,1.5);
				this.mono:EndSocket(true); 
			end
		end);
	this.mono:StartSocket(true);
end

--获取验证码
function this:OnGetIdentifyCode(  )
	local errorInfo = "";
	if ( string.len(this.kPhoneNumber.value) ==0)  then
		errorInfo = ZPLocalization.Instance:Get("RegisterPhoneNumber");
	end
	
	if ( string.len(errorInfo) > 0)  then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else 
		local tBody = {}
		tBody['phone'] = this.kPhoneNumber.value
		this.mono:Request_lua_fun("AccountService/send_mobile_sms",cjson.encode(tBody),function(message) 
			this.transform:FindChild('Offset/Views/PhoneRegister/Button_Submit').gameObject:GetComponent('UIButton').isEnabled= true
		end, 
		function(message)   
			EginProgressHUD.Instance:ShowPromptHUD(message);
		end);
	end
end
	

-- socket相关
function this.OnSocketDisconnect( disconnectInfo) 
	-- EginProgressHUD.Instance:ShowPromptHUD(disconnectInfo);
end

function this:SocketRegister()

	this.mono:EndSocket(true);
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

	local form = {username=this.kUsername.value,password=this.kPassword.value,nickname=this.kNickname.value,agent_id=this.kTuiID.value}
	 
	local tempFunction = function()
		if this.mono ~= nil then
			this.mono:Request_lua_fun("AccountService/account_register",cjson.encode(form),function(message) 
				SocketConnectInfo.Instance.lobbyUserName = this.kUsername.value;--设置登录用的用户名和密码
				SocketConnectInfo.Instance.lobbyPassword = this.kPassword.value;
				Util.SetSocketInfo(SocketConnectInfo.Instance.lobbyUserName,SocketConnectInfo.Instance.lobbyPassword)

				ProtocolHelper._LoginType = LoginType.Username;--用户名登录
				ProtocolHelper.Send_login();
				--渠道处理
				Module_Channel.Instance:handleReg()
			end,
			function(message)   
				EginProgressHUD.Instance:ShowPromptHUD(message);
				this.mono:EndSocket(true);
			end);	
		end
	end 
	-- ProtocolHelper.OnSocketConnectTriggerAction = Util.packActionLua(tempFunction,this);
	ProtocolHelper.OnSocketConnectTriggerAction = tempFunction
	
  
	this.mono:StartSocket(true);

end

function this.Process_account_login_Failed( errorInfo) 
	this.mono:EndSocket(true);
	EginProgressHUD.Instance:ShowPromptHUD("注册成功，登录请稍等2分钟",Util.packActionLua(function(message)   
			-- this.mono:EginLoadLevel("Login");
		this:ToPanel('Login')

		end,this));
	--渠道处理
	Module_Channel.Instance:handleReg()
end

function this.Process_account_login( info)
	--登入成功,也代表重连成功, 因为重连后就会进行登入操作 
	EginProgressHUD.Instance:ShowPromptHUD("注册成功"); 
	--渠道处理
	Module_Channel.Instance:handleReg()
	coroutine.start(this.SendLogin,this);
	 
end
function this:SendLogin()  
	coroutine.wait(0.8);
	ProtocolHelper.Send_get_account();--获取用户信息 
	this.mono:Request_lua_fun(ProtocolHelper.get_account,nil,function(message) 
		--ProtocolHelper.Receive_get_ccount(Util.packJSONObjectLua(message));
		ProtocolHelper.Receive_get_ccount(message)	
			 --print('================Register   ========== init user ========')
			----lua EginUser 赋值
			this:SetUserInfo(message)
			this:SaveLoginInfo();
			-- this.mono:EginLoadLevel("Hall");
			--渠道处理
			Module_Channel.Instance:handleGetAccount();
			this:ToPanel('Hall')
		end, 
		function(message)   
		end);
end
function this:SaveLoginInfo()

	UnityEngine.PlayerPrefs.SetString("EginUsername", this.kUsername.value);
	UnityEngine.PlayerPrefs.Save();
end

--lxtd004 2016 0817
function this:SetUserInfo(pMsg)
	EginUser.Instance:InitUserWithDict(pMsg,'')
end

function this:ToPanel(pTag )
	if pTag == 'Hall' then 
		HallUtil:PopupPanel('Hall',false,this.gameObject,nil)
		-- ShowHallPanel(this.gameObject,false,function ()
		-- 		EginProgressHUD.Instance:HideHUD()
		-- 		Hall:Start() 
		-- 	end,function (  )
		-- 		this.transform:FindChild('Offset/Black_Background').gameObject:SetActive(false)
		-- 	end)
	elseif pTag == 'Login' then 
		HallUtil:PopupPanel('Register',false,this.gameObject,function ()
			HallUtil:PopupPanel('Login',true,nil,nil)
		end)
		-- ShowHallPanel(this.gameObject,false,function ()
		-- 	EginProgressHUD.Instance:HideHUD()
		-- 	Utils.LoadAdditiveGameUI('Login',Vector3.New(0,2000,0))
		-- 	end,function (  )
		-- 		-- this.transform:FindChild('Offset/Black_Background').gameObject:SetActive(false)
		-- end)
	end

end


