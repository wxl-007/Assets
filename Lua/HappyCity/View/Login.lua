require "HappyCity/View/Hall"

local this = LuaObject:New()
Login = this
local WWW = UnityEngine.WWW;
local PlayerPrefs = UnityEngine.PlayerPrefs;

function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
 
 
	this.kUsername  = nil;
	this.kPassword  = nil;
	this.kRemberPs  = nil;
	this.kAutoLogin  = nil; 
	this.verifyTitle  = nil;
	this.verifyView  = nil;
	this.verifyCode  = nil; 
	this.yanView  = nil;
	this.kYanZheng  = nil; 
	this.kYanImg  = nil;
	this._Reload_Config_gobj  = nil; 
	this.captcha_hiddentext  = nil;
	this.curReconnectCount  = 0;
	this.errNum=0; 
	this.isClick = false;
	this.m_account_login_error_str = nil;
	
	this.m_OpenId =nil 
	this.m_AccessToken =nil 
	this.m_RefreshToken = nil 
	this.m_UnionId = nil 
	this.m_NickName=nil 
	this.m_Sex = -1
	this.m_IsGuestLogin = false 
	
	if IsPlatformLua and PlatformLua.playform ~= nil then
		PlatformLua.playform.webConfIndexAlter = nil;	--线路修改回调
		PlatformLua.playform.webConfListInit = nil;
	end 
	
	coroutine.Stop()
	LuaGC()
end
function this:Init() 
	--初始化第一次进入大厅
	Hall.FirstEnter = true;	
	
	this.kUsername  = this.transform:FindChild("Username/Input").gameObject:GetComponent("UIInput");
	this.kPassword  = this.transform:FindChild("Password/Input").gameObject:GetComponent("UIInput");
	-- this.kRemberPs  = this.transform:FindChild("Checkbox_RemberPs").gameObject:GetComponent("UIToggle");
	-- this.kAutoLogin  = this.transform:FindChild("Checkbox_AutoLogin").gameObject:GetComponent("UIToggle");
	-- this.verifyTitle  =  this.transform:FindChild("verify/tiptxt").gameObject:GetComponent("UILabel");
	-- this.verifyView  = this.transform:FindChild("verify").gameObject;
	-- this.verifyCode  = this.transform:FindChild("verify/Input").gameObject:GetComponent("UIInput"); 
	-- this.yanView  = this.transform:FindChild("yanzheng").gameObject;
	-- this.kYanZheng  = this.transform:FindChild("yanzheng/Input").gameObject:GetComponent("UIInput"); 
	-- this.kYanImg  = this.transform:FindChild("yanzheng/Texture").gameObject;
	this._Reload_Config_gobj  = this.transform:FindChild("Button_Reload_Config").gameObject; 
	-- this.IplineList = this.transform:FindChild("SelectLineBtn"):GetComponent("UIPopupList"); 

	-- if IsPlatformLua then
	-- 	PlatformLua.playform.webConfListInit = this.InitIplineList;
	-- end
	
	this.captcha_hiddentext  = nil;
	this.curReconnectCount  = 0;
	this.errNum=0; 
	this.isClick = false;
	this.m_account_login_error_str = nil;

	this.GuestUID = -1

	this.m_IsGuestLogin = false
	this.m_OpenId =nil 
	this.m_AccessToken =nil 
	this.m_RefreshToken = nil 
	this.m_UnionId = nil 
	this.m_NickName=nil 
	this.m_Sex = -1
	---手机登录  相关
	-- this.PhoneLoginPanel = this.transform:FindChild('PhoneRegister').gameObject
	-- this.PhoneNumber = this.PhoneLoginPanel.transform:FindChild("Offset/Views/PhoneRegister/Input_PhoneNumber/Input").gameObject:GetComponent("UIInput");
	-- this.PhoneNumberTitle = this.PhoneNumber.gameObject.transform:FindChild('Label').gameObject:GetComponent('UILabel')
	-- this.PhoneNickname = this.PhoneLoginPanel.transform:FindChild("Offset/Views/PhoneRegister/Input_Nickname/Input").gameObject:GetComponent("UIInput");
	-- this.PhoneIdentityCode = this.PhoneLoginPanel.transform:FindChild('Offset/Views/PhoneRegister/Input_IdentityCode/Input').gameObject:GetComponent('UIInput')
	-- this.PhoneLoginTitle = this.PhoneLoginPanel.transform:FindChild('Offset/BackgroundTitle/Title - Anchor/Title').gameObject:GetComponent('UILabel')
	-- this.PhoneSummit = this.PhoneLoginPanel.transform:FindChild("Offset/Views/PhoneRegister/Button_Submit").gameObject 
	-- this.PhoneSummitLab = this.PhoneLoginPanel.transform:FindChild("Offset/Views/PhoneRegister/Button_Submit/Label").gameObject:GetComponent('UILabel')


	-- this.BtnBack = this.PhoneLoginPanel.transform:FindChild("Offset/Background/Background").gameObject
	-- this.PhoneLoginPanel.gameObject:SetActive(false)
	-- this.PhoneNickname.gameObject:SetActive(false)
	this.NeedIdentityCode = false 
	-- this.BtnCode = this.PhoneLoginPanel.transform:FindChild("Offset/Views/PhoneRegister/Input_IdentityCode/Button_IdentityCode").gameObject
	-- this.BtnCodeSp = this.BtnCode.transform:FindChild('Sprite').gameObject:GetComponent('UISprite')
	-- this.BtnCodeLab = this.BtnCode.transform:FindChild('one').gameObject:GetComponent('UISprite')
	-- this.BtnCodeLabTen = this.BtnCodeLab.gameObject.transform:FindChild('ten').gameObject:GetComponent('UISprite')
	-- this.WeChatBtnPanel = this.transform:FindChild('WeChatChange').gameObject
	-- this.WeChatShiftBtn = this.WeChatBtnPanel.transform:FindChild('WeChatS').gameObject
	-- this.WeChatContinueBtn = this.WeChatBtnPanel.transform:FindChild('WeChatC').gameObject
	-- this.InvokeLua = InvokeLua:New(this);
	this.IsCount = false 
	--友盟插件
	if  PlatformGameDefine.playform.PlatformName == "game131" then
	 	if  Application.platform == UnityEngine.RuntimePlatform.Android then 
		 	UmengUtil.initUmeng("58c7a1a445297d5d8500122f","android"..Utils.Agent_Id,true)
			 print("initUmeng android")
	    elseif  Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
			UmengUtil.initUmeng("58d38bda5312dd1b93000d56","App Store",true)
			print("initUmeng App Store")
		end
	end 

end
function this:Awake()
	this.mono._IsLoginScene = true;
	-- ShowHallPanel(this.gameObject,true,nil,function ( )
	-- 	this.transform:FindChild('Black_Background').gameObject:SetActive(true)
	-- end)

	this:Init();
	--按钮事件监听
	this.mono:AddClick(this.transform:FindChild("Button_Forget").gameObject, this.OnClickForget,this) 
	this.mono:AddClick(this.transform:FindChild("Button_Login").gameObject, this.OnClickLogin,this)
	this.mono:AddClick(this.transform:FindChild("Button_Register").gameObject, this.OnClickRegister,this) 
	
	-- this.mono:AddClick(this.transform:FindChild("verify/Button_Update").gameObject, this.OnClickVerify,this) 
	
	-- this.mono:AddClick(this.transform:FindChild("yanzheng/Texture").gameObject, this.OnClickRefreshYanZheng,this) 
	
	this.mono:AddClick(this.transform:FindChild("Button_Reload_Config").gameObject, this.OnClick_Reload_Config,this)   
	local tBtnGuest = this.transform:FindChild('Button_GuestLogin').gameObject
	this.mono:AddClick(this.WeChatContinueBtn,function ( )
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),true);
	 	this.curReconnectCount = 0
	 	this.m_account_login_error_str = nil 
	 	ProtocolHelper._LoginType = LoginType.WeChat;
		EginUser.Instance.wxOpenId =  UnityEngine.PlayerPrefs.GetString('openid','')
		EginUser.Instance.wxNickname = UnityEngine.PlayerPrefs.GetString('nickname','')
		EginUser.Instance.wxUnionId = UnityEngine.PlayerPrefs.GetString('WeChatUnionId','')
		coroutine.start(this.StartSocketLogin,this)
		UnityEngine.PlayerPrefs.SetString('LoginType','WeChat') 
		UnityEngine.PlayerPrefs.Save()

	end)
	this.mono:AddClick(this.WeChatShiftBtn,function ( )
		this.OnClickWeChatLogin()
	end)
	-- this.mono:AddClick(this.transform:FindChild('WeChatChange/BtnBG').gameObject,function ()
	-- 	this.WeChatBtnPanel:SetActive(false)
	-- end)

	this.mono:AddClick(this.transform:FindChild('Button_WeChatLogin').gameObject,function ( )
		if UnityEngine.PlayerPrefs.GetString('WeChatUnionId','-1') == '-1' then
			this.OnClickWeChatLogin()
		else 
			--弹框
			this.WeChatBtnPanel:SetActive(true)
		end
	end )
	this.mono:AddClick(tBtnGuest,this.OnClickGuest,this)

	-- tBtnGuest.gameObject:GetComponent('UIButton').isEnabled = false 
	-- this.mono:AddToggle(this.transform:FindChild("Checkbox_AutoLogin").gameObject:GetComponent("UIToggle"), this.OnChangeAutoLogin)  
	-- this.mono:AddToggle(this.transform:FindChild("Checkbox_RemberPs").gameObject:GetComponent("UIToggle"), this.OnChangeRemberPs)  
	-- if PlatformGameDefine.playform.IOSPayFlag == false or  Utils._IsNoWeChat then
		-- this.transform:FindChild('Body/Button_WeChatLogin').gameObject:SetActive(false)
		-- local tPhoneLoginSp =  this.transform:FindChild('Body/Button_PhoneLogin').gameObject:GetComponent('UISprite')
		-- tPhoneLoginSp.spriteName = 'phone_Long'
		-- tPhoneLoginSp:MakePixelPerfect()
		-- tPhoneLoginSp.width = 627--,118);
		-- -- this.transform:FindChild('Body/Button_Login').gameObject.transform.localPosition = Vector3.New(-344,-25,0)
		-- -- this.transform:FindChild('Body/Button_GuestLogin').gameObject.transform.localPosition = Vector3.New(-344,-210,0)
	-- end
	----test
	-- this.transform:FindChild('Body/Button_WeChatLogin').gameObject:SetActive(true)
	if PlatformGameDefine.playform.IOSPayFlag == false or  Utils._IsNoWeChat then
		this.transform:FindChild('Button_WeChatLogin').gameObject:SetActive(false)
		-- local tPhoneLoginSp =  
		this.transform:FindChild('Button_PhoneLogin').gameObject:SetActive(false)
		this.transform:FindChild("Button_Forget").gameObject:SetActive(false)
		-- tPhoneLoginSp.spriteName = 'phone_Long'
		-- tPhoneLoginSp:MakePixelPerfect()
		-- tPhoneLoginSp.width = 627--,118);
		this.transform:FindChild('Button_Login').gameObject.transform.localPosition = Vector3.New(-344,-25,0)
		this.transform:FindChild('Button_GuestLogin').gameObject.transform.localPosition = Vector3.New(-344,-210,0)
	end
	
	--add phone login 
	this.mono:AddClick(this.transform:FindChild('Button_PhoneLogin').gameObject,this.OnClickPhoneLogin,this)
	-- this.mono:AddClick(this.PhoneSummit, this.OnClickPhoneRegister,this) 
	-- this.mono:AddClick(this.BtnBack,function ( )
	-- 	this.PhoneLoginPanel:SetActive(false)
	-- 	this.PhoneNumber.value = ''
	-- 	-- this.PhoneNickname.value = ''
	-- 	this.PhoneIdentityCode.value = ''
	-- 	this.NeedIdentityCode = false 
	-- 	this.PhoneSummit:SetActive(true)
	-- 	this.IsCount = false 
	-- 	this.PhoneNumber.gameObject.transform.parent.gameObject:SetActive(true)
	-- 	this.PhoneIdentityCode.gameObject.transform.parent.gameObject:SetActive(false)
	-- 	-- this.BtnCode:GetComponent('Collider').enabled = true
	-- 	-- this.PhoneSummit:GetComponent('Collider').enabled = true
	
	-- end)
	-- this.mono:AddClick(this.BtnCode,this.IdentityCode,this)
	-- this.mono:AddInput(this.PhoneIdentityCode,this.CodeLenChange)
	

	
end
function this:Start () 
	if(PlatformGameDefine.playform.IsSocketLobby) then
		this.mono:EndSocket(true); 
	end
	if Utils.isLocalServer then
		this.mono:EginLoadLevel("Local_Login");
		return;
	end

	if Utils._IsIPTest then
		-- if (this.mono:GetType().Name == "Login") then 
			this.mono:EginLoadLevel("IPTest_Login");
			return;
		-- end
	end
	--如果是测试ip就初始化相关功能
	this:InitTestIp2();
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 1920;
		sceneRoot.manualWidth = 1080;
	end
	-- this.kRemberPs.value = (UnityEngine.PlayerPrefs.GetInt("RemberPS", 1) == 1);
	-- this.kAutoLogin.value = this.kRemberPs.value and (UnityEngine.PlayerPrefs.GetInt("AutoLogin2", 1) == 1) or false;	-- 因 AutoLogin 被占用，所以此处使用 AutoLogin2 作为Key
	this.kUsername.value = UnityEngine.PlayerPrefs.GetString("EginUsername", "");
	-- if(this.kRemberPs.value  and   string.len(this.kUsername.value) > 0)  then
	if string.len(this.kUsername.value)>0 then
		this.kPassword.value = UnityEngine.PlayerPrefs.GetString(this.kUsername.value, "");
	end
	this.GuestUID = UnityEngine.PlayerPrefs.GetString('GuestUID','0')

	-- coroutine.start(this.loadConf,this);

	-- if ( not PlatformGameDefine.playform.IsSocketLobby  and  PlatformGameDefine.playform.IsYan) then --socket 连接不需要验证码
	-- 	this.yanView:SetActive (true);
	-- else 
	-- 	this.yanView:SetActive(false);
	-- end
 	-- coroutine.start(this.LoadNotices);
	EginUser.Instance.device_id = UnityEngine.SystemInfo.deviceUniqueIdentifier;
	ConnectDefine:updateConfig()
	if (this._Reload_Config_gobj) then
	
		this._Reload_Config_gobj:SetActive(false);
		coroutine.start(this.Delay,this,20,function() 
			this._Reload_Config_gobj:SetActive(true);
		end) 
	end

	-- this:LoadPlatformLogo()
	--初始化选择ip线路列表
	-- this:InitIplineList();
end

function this:Delay(_time,run)
	coroutine.wait(_time)
	if this.mono ~= nil then
		run(this);
	end
end
 
function this:OnDestroy()
	this:clearLuaValue() 
end
function this:InitTestIp2()
	if Utils._IsIPTest2 then
		--显示输入ip框
		this.IPTest2 = this.transform:FindChild("IPTest2").gameObject 
		this.IPTest2:SetActive(true);
		this.IPTest2Web = this.IPTest2.transform:FindChild('Input_web').gameObject:GetComponent('UIInput')
		this.IPTest2Game = this.IPTest2.transform:FindChild('Input_game').gameObject:GetComponent('UIInput')
		this.IPTest2Socket = this.IPTest2.transform:FindChild('Input_socketLobby').gameObject:GetComponent('UIInput')
		this:SetInputValue(this.IPTest2Web,IPTest2_WebURL)
		this:SetInputValue(this.IPTest2Game,IPTest2_GameURL)
		this:SetInputValue(this.IPTest2Socket,IPTest2_SocketURL)
		this.checkbox_game597  = this.IPTest2.transform:FindChild("Checkbox_game597").gameObject:GetComponent("UIToggle");
		this.checkbox_game131  = this.IPTest2.transform:FindChild("Checkbox_game131").gameObject:GetComponent("UIToggle");
		this.checkbox_game7997  = this.IPTest2.transform:FindChild("Checkbox_game7997").gameObject:GetComponent("UIToggle");
		this.checkbox_game597.value = (PlatformLua.playform == PlatformGame1977)
		this.checkbox_game131.value = (PlatformLua.playform == PlatformGame407)
		this.checkbox_game7997.value = (PlatformLua.playform == PlatformGame7997)

		this.isSocketLobby  =  this.IPTest2.transform:FindChild("IsSocketLobby").gameObject:GetComponent("UILabel");
		if(this.isSocketLobby) then this.isSocketLobby.text = tostring(PlatformGameDefine.playform.IsSocketLobby); end

		this.mono:AddClick(this.IPTest2.transform:FindChild("Button_Login (1)").gameObject,function()
				IPTest2_WebURL = this:DefaultInputValueCheck(this.IPTest2Web.value)	
				IPTest2_GameURL = this:DefaultInputValueCheck(this.IPTest2Game.value)	
				IPTest2_SocketURL = this:DefaultInputValueCheck(this.IPTest2Socket.value)	
				 
				ConnectDefine.updateConfig();
				
				EginProgressHUD.Instance:ShowPromptHUD("切换ip完成",0.5);	
		end,this)   

		this.mono:AddToggle(this.checkbox_game597,function ()
			
			if (this.checkbox_game597.value and PlatformLua.playform ~= PlatformGame1977)  then
				this:SwitchPlatform(PlatformGame1977,"PlatformGame1977")
			end
		end) 
		this.mono:AddToggle(this.checkbox_game131,function ()
			if (this.checkbox_game131.value and PlatformLua.playform ~= PlatformGame407)  then
				this:SwitchPlatform(PlatformGame407,"PlatformGame407")
			end
		end) 
		this.mono:AddToggle(this.checkbox_game7997,function ()
			if (this.checkbox_game7997.value and PlatformLua.playform ~= PlatformGame7997)  then
				this:SwitchPlatform(PlatformGame7997,"PlatformGame7997")
			end
		end) 

	end
end
function this:SetInputValue(input,text)
        if (input and text~=nil and text ~="") then input.value = text; end
end
function this:SwitchPlatform(platformTemp,strName)
	    PlatformLua.playform = platformTemp; 
		PlatformLua.playform:Init(); 
		PlatformGameDefine.playform.LuaSelf = PlatformLua.playform; 
		Utils.PlayformName=strName;
		coroutine.start(this.DoSwitchPlatform) 
end
function this.DoSwitchPlatform() 
        EginProgressHUD.Instance:ShowWaitHUD("正在切换平台");
        log("CK : ------------------------------ loading = 0"..PlatformGameDefine.playform.PlatformName);

		local iscoroutine = DoneCoroutine.New();
		this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadConfig(),iscoroutine);
		coroutine.branchC(iscoroutine);  

        log("CK : ------------------------------ loading = 1");
        local gfname = PlayerPrefs.GetString("GFname"..PlatformGameDefine.playform.PlatformName);
        local wfname = PlayerPrefs.GetString("WFname"..PlatformGameDefine.playform.PlatformName);
        PlatformGameDefine.playform:UpdateGFnameURL(gfname);
        PlatformGameDefine.playform:UpdateWFnameURL(wfname);

		log("CK : ------------------------------ loading = 2");
		local tIsCoroutine2 = DoneCoroutine.New();
		this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadConfig_game_hostArr(Utils.NullObj,false),tIsCoroutine2)
		this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadConfig_web_hostArr(Utils.NullObj,false),tIsCoroutine2)
		coroutine.branchC(tIsCoroutine2); 
		-- this.InitIplineList();
		log("CK : ------------------------------ loading = 3");
        EginProgressHUD.Instance:HideHUD();
end
 function this:InitIplineList()
	 if not IsPlatformLua then return; end
	this.IplineList:Clear();
	for  k=1,#(PlatformLua.playform.web_IP_list) do
		local oneStr = PlatformLua.playform.web_IP_list[k][1]
		this.IplineList:AddItem(oneStr,k-1);
	end   
	if PlatformLua.playform.m_cur_web_conf_index > #(PlatformLua.playform.web_IP_list) then 
		PlatformLua.playform.webConfIndexAlter = nil;	--线路修改回调 
	else
		this.IplineList.value = PlatformLua.playform.web_IP_list[PlatformLua.playform.m_cur_web_conf_index][1]
		PlatformLua.playform.webConfIndexAlter = this.onwebConfIndexAlter;	--线路修改回调
		this.mono:AddPopupList(this.IplineList,this.onFirstChange);  
	end 
end
function this:onFirstChange()
	 if not IsPlatformLua then return; end
	local idex = UIPopupList.current.data+1;
	PlatformLua.playform.m_cur_web_conf_index = idex; 
end
function this:onwebConfIndexAlter()
	if not IsPlatformLua then return; end
	if PlatformLua.playform.m_cur_web_conf_index <= #(PlatformLua.playform.web_IP_list) then 
		this.IplineList.value = PlatformLua.playform.web_IP_list[PlatformLua.playform.m_cur_web_conf_index][1]
	end
	  
end
function this:DefaultInputValueCheck(url)
	print(url) 
	local tempnum = string.find(url,"%.")
	if url ~= nil and tempnum~=nil and tempnum>0 then
		return url;
	end
	 return ""; 
end
-- Use this for initialization 
function this:OnClick_Reload_Config()

	EginProgressHUD.Instance:ShowWaitHUD("正在加载配置文件...",true);
	if (this._Reload_Config_gobj) then this._Reload_Config_gobj:SetActive(false); end
	 
	 
	this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadAndSaveConfigData(Util.packActionLua(function()
	
		if (this._Reload_Config_gobj) then this._Reload_Config_gobj:SetActive(true); end

		EginProgressHUD.Instance:HideHUD();
		if ( not PlatformGameDefine.playform.IsSocketLobby  and  PlatformGameDefine.playform.IsYan) then
		
			this.yanView:SetActive(true);
			coroutine.start(this.refreshYanImg,this);
			this.isClick = false; 
		else 
			this.yanView:SetActive(false);
		end
	end ,this), 0));
	 
end

function this:loadConf()
	
	if( PlatformGameDefine.playform.IOSPayFlag) then 
			coroutine.start(this.LoadNotices);
		end 
	 
	coroutine.branch(coroutine.start(function() PlatformGameDefine.playform:LoadConfig();  end));
	if ( not PlatformGameDefine.playform.IsSocketLobby  and  PlatformGameDefine.playform.IsYan) then 
		this.yanView:SetActive (true);
		coroutine.start(this.refreshYanImg,this);
		this.isClick = false;
	else 
		this.yanView:SetActive(false);
	end


end
 

function this.AndroidKeyCodeEscape () 
	Application.Quit();
end
 

---- Button Click 点击获取验证码------ 
function this:OnClickRefreshYanZheng () 
	if(this.isClick) then
		this.errNum = 0;
		coroutine.start(this.refreshYanImg,this);
	end
end

function this:refreshYanImg()
	local www2 = HttpConnect.Instance:HttpRequest(ConnectDefine.YAN_ZHENG_URL,nil);
	coroutine.www(www2); 
	local result2 = HttpConnect.Instance:BaseResult(www2);
	local yanUrl;
	if(HttpResult.ResultType.Sucess == result2.resultType)  then 
		-- log("-------------=======-----------"..www2.text)
		-- local resultObj2 = cjson.decode(result2.resultObject:ToString());
		local resultObj2 = result2.resultObject;
		
		yanUrl = ConnectDefine.HostURL..tostring(resultObj2["imageurl"]);
		print(yanUrl)
		this.captcha_hiddentext =tostring(resultObj2["hiddentext"]);  
		local www = UnityEngine.WWW.New(yanUrl);
		coroutine.www(www); 
		local uiT = this.kYanImg:GetComponent("UITexture");
		uiT.mainTexture = www.texture; 
		this.errNum = 0;
		this.isClick = true;
	else 
		this.errNum=this.errNum+1;
		if ( not result2.isSwitchHost) then 
			PlatformGameDefine.playform:swithWebHostUrl(true,Utils.NullObj);
		end
		if (this.errNum<4) then
			coroutine.start(this.refreshYanImg,this);
		else
			this.isClick = true;
		end
	end
end
 
function this:OnClickLogin () 
	--[[PhoneSdkUtil.initBaiduYuntui("i3u6v7noo4HV5XW6bd1aju0t","LobbyMsgReceiver")
	--]]
	ProtocolHelper._LoginType = LoginType.Username;
	UnityEngine.PlayerPrefs.SetString("LoginType",'Username');
	UnityEngine.PlayerPrefs.Save();
	local errorInfo = "";
	if ( string.len(this.kUsername.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("LoginUsername");
	elseif ( string.len(this.kPassword.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("LoginPassword");
	end
	
	if ( string.len(errorInfo) > 0)  then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else 
		if (PlatformGameDefine.playform.IsSocketLobby) then
			coroutine.start(this.DoClick_SocketLogin,this);    
		else 
			coroutine.start(this.DoClickLogin,this);
		end
	end
end


function this:DoClickLogin () 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),false);
 
	local form = UnityEngine.WWWForm.New();
	form:AddField("username", this.kUsername.value);
	form:AddField("password", this.kPassword.value);
	form:AddField("device_id", "unity_"..SystemInfo.deviceUniqueIdentifier);--
	if (PlatformGameDefine.playform.IsYan) then
		form:AddField("captcha_text", this.kYanZheng.value and this.kYanZheng.value or "");
		form:AddField("captcha_hiddentext", this.captcha_hiddentext and this.captcha_hiddentext or  "");
		 
	end
	if  Application.platform == UnityEngine.RuntimePlatform.Android then 
		local mVersionCode = math.max(UnityEngine.PlayerPrefs.GetInt ("VersionCode", PlatformGameDefine.game.VersionCode), PlatformGameDefine.game.VersionCode); 
		form:AddField("version", mVersionCode);
		form:AddField("platform", "Android");
	else
		form:AddField("platform", "iOS");
	end
	
	-- print(form:ToString())

	local www = HttpConnect.Instance:HttpRequest(ConnectDefine.LOGIN_URL, form);  
	coroutine.www(www);
	local result = HttpConnect.Instance:UserLoginResult(www); 
	 
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)  then
		this:SaveLoginInfo(); 
		this.mono:EginLoadLevel("Hall");
		Module_Bank:clearCachePwd();
	else 
		if(Util.ObjToString(result.resultObject)  == "device_verify") then 
			this.verifyView:SetActive(true);
		else
			local tempBool = false;
			if _IPTest then
				tempBool =  ((IPTest_Login._WebURL==nil or IPTest_Login._WebURL=="")  and  result.isSwitchHost  and  this.curReconnectCount < 2)
			else
				tempBool =  (result.isSwitchHost  and  this.curReconnectCount < 2)
			end
			if tempBool then
				this.curReconnectCount=this.curReconnectCount+1; 
				coroutine.start(this.DoClickLogin,this);--如果连接失败,则切换ip后重新登入 
			else 
				-- print(result.resultObject)
				this.curReconnectCount = 0; 
				EginProgressHUD.Instance:ShowPromptHUD(result.resultObject); 
				this:OnClickRefreshYanZheng();
			end
		end
	end
end

function this:OnClickVerify () 
	this.verifyView:SetActive(false);
	if (PlatformGameDefine.playform.IsSocketLobby) then 
		this:SocketDevice_Verify(); 
	else
		coroutine.start(this.DoVerify,this);
	end
end

function this:DoVerify () 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),false);

	local username = this.kUsername.value;-- UnityEngine.PlayerPrefs:GetString("EginUsername", "");
	local form = UnityEngine.WWWForm.New();
	form:AddField("username", username);
	form:AddField("verify_code", this.verifyCode.value);
	form:AddField("device_id", "unity_"..SystemInfo.deviceUniqueIdentifier);



	local www = HttpConnect.Instance:HttpRequest(ConnectDefine.VERIFY_CODE_URL, form);
	coroutine.www(www);


	local result = HttpConnect.Instance:BaseResult(www);
	
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType) then
		this.mono:EginLoadLevel("Hall");
	else 
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
	end
end


function this:OnClickGuest () 
	--[[PhoneSdkUtil.readedIosNoticeNumber(1)--]]
	ProtocolHelper._LoginType = LoginType.Guest;
	if PlatformGameDefine.playform.IsSocketLobby then
		-- this.mono:StartSocket(false)
		-- ProtocolHelper.OnSocketConnectTriggerAction = Util.packActionLua(this.OnSocket_GuestLogin,this);
		this:OnSocket_GuestLogin()
	else
		print('in click guest http  ')
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),false);
		local www = HttpConnect.Instance:HttpRequest(ConnectDefine.GUEST_LOGIN_URL, nil);
		coroutine.www(www);
		
		local result = HttpConnect.Instance:GuestLoginResult(www);	
		EginProgressHUD.Instance:HideHUD ();
		if(HttpResult.ResultType.Sucess == result.resultType)  then
			this.mono:EginLoadLevel("Hall");
		else 
			EginProgressHUD.Instance:ShowPromptHUD(result.resultObject, 2.0);
		end
	end
end



function this:OnClickRegister () 
	--[[PhoneSdkUtil.SendIosNotice("ios本地通知！！！",1,1)
	--]]
	if(System.String.IsNullOrEmpty(PlatformGameDefine.playform.Register_url)) then
		-- this.mono:EginLoadLevel("Register");
		-- ShowHallPanel(this.gameObject,false,function ()
		-- 		EginProgressHUD.Instance:HideHUD()
		-- 		Utils.LoadAdditiveGameUI('Register',Vector3.New(0,2000,0))
		-- 	end,function (  )
		-- 		this.transform:FindChild('Black_Background').gameObject:SetActive(false)
		-- 	end)
			HallUtil:PopupPanel('Hall',false,this.gameObject,function ()
				HallUtil:PopupPanel('Register',true,nil,nil)
			end)
		

	else 
		WXPayUtil.OnClick_WebActivity(PlatformGameDefine.playform.Register_url);
	end
end

function this:OnClickForget () 
	Application.OpenURL(ConnectDefine.FORGET_PASSWORD_URL);
end

function this:OnChangeRemberPs () 
	if ( not this.kRemberPs.value) then
		this.kAutoLogin.value = false;
	end
end

function this:OnChangeAutoLogin () 
	
	if (this.kAutoLogin.value)  then
		this.kRemberPs.value = true;
	end
end
 
function this:SaveLoginInfo () 
	UnityEngine.PlayerPrefs.SetString("EginUsername", this.kUsername.value);
	-- if (this.kRemberPs.value)  then
		UnityEngine.PlayerPrefs.SetString(this.kUsername.value, this.kPassword.value);
	-- end
	-- UnityEngine.PlayerPrefs.SetInt("RemberPS", this.kRemberPs.value and 1 or 0);
	-- UnityEngine.PlayerPrefs.SetInt("AutoLogin2", this.kAutoLogin.value and 1 or 0);
	UnityEngine.PlayerPrefs.SetInt("RemberPS",  1 );
	UnityEngine.PlayerPrefs.SetInt("AutoLogin2",  1 );
	UnityEngine.PlayerPrefs.Save();
end

-- socket相关
-----------Username 登录方式
function this:DoClick_SocketLogin()

	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),true);
	 

	SocketConnectInfo.Instance.lobbyUserName = this.kUsername.value;--设置登录用的用户名和密码
	SocketConnectInfo.Instance.lobbyPassword = this.kPassword.value;
	Util.SetSocketInfo(SocketConnectInfo.Instance.lobbyUserName,SocketConnectInfo.Instance.lobbyPassword)
	
	this.curReconnectCount = 0;
	this.m_account_login_error_str = nil; 
	coroutine.start(this.StartSocketLogin,this)
end

------------------SocketLogin启动方式,Username,WeChat,Guest 三种登录方式通用 -------------------------
function this:StartSocketLogin(delay)
	if(delay ~= nil and type(delay) == "number" and delay > 0) then 
		coroutine.wait(delay);
	end
	local iscoroutine = DoneCoroutine.New();
	this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadConfByUser(this.kUsername.value),iscoroutine);
	coroutine.branchC(iscoroutine);
 
	this.mono:StartSocket(true);
end

function this.OnSocketDisconnect( disconnectInfo)
 
	-- if (this.m_account_login_error_str ~= nil) then return; end

	-- if(this.curReconnectCount < 2) then 
		-- --this.mono.OnSocketDisconnect(disconnectInfo); 
	-- elseif(this.curReconnectCount == 2) then 
		-- EginProgressHUD.Instance:ShowPromptHUD(disconnectInfo); 
	-- end
	 -- this.curReconnectCount = this.curReconnectCount+1;
end


function this.Process_account_login_Failed( errorInfo,  body)
--登入错误,不是连接错误,这里已经连接上了,不用重连
	-- this.m_account_login_error_str = errorInfo; 
	local m_AccountNotFoundCount = 0;
	EginProgressHUD.Instance:HideHUD();
	if errorInfo ~= nil  and  "device_verify"==errorInfo  then
	
		local verifyTitleMap ={secret="请输入手机令牌码",cert="请输入身份验证码",wechat="请输入微信验证码",phone="请输入手机验证码"}  
		body = string.gsub(body,'"',"");
		
		if (this.verifyTitle  and  verifyTitleMap[body]~=nil) then
		 this.verifyTitle.text = verifyTitleMap[body];
		  end
		this.verifyView:SetActive(true); 
	elseif (string.match(errorInfo,"账号不存在") and m_AccountNotFoundCount < 2) then	
		m_AccountNotFoundCount = m_AccountNotFoundCount + 1;
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"), true);
		coroutine.start(this.StartSocketLogin,this,10);
	else 
		m_AccountNotFoundCount = 0;
		local verifyTitleMap = {  failed="用户名或密码错误",  inactive="未激活" ,  locked="锁定" }

		local tempstr = string.gsub(errorInfo,'"',"");
		if (verifyTitleMap[tempstr] ~= nil) then errorInfo = verifyTitleMap[tempstr]; end
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	end
end 

function this.Process_account_login( info)
--登入成功,也代表重连成功, 因为重连后就会进行登入操作
	this:GetUserInfo_socket()
end

function this:GetUserInfo_socket()
	EginProgressHUD.Instance:ShowWaitHUD("正在获取用户数据...", true);

	ProtocolHelper.Send_get_account();--获取用户信息

	this.mono:Request_lua_fun(ProtocolHelper.get_account,nil,function(message)
			EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PASSWORD;
			-- ProtocolHelper.Receive_get_ccount(Util.packJSONObjectLua(message));
			--变更为lua 脚本
			ProtocolHelper.Receive_get_ccount(message)

			local tMsg = cjson.decode(message)
			--lua EginUser 赋值
			this:SetUserInfo(message,'')
			if ProtocolHelper._LoginType == LoginType.Guest and tMsg['userid'] ~= nil then
				if UnityEngine.PlayerPrefs.GetString("GuestUID", "0") =="0"  then 
					local num = tonumber(tMsg['userid']) or 0;
					UnityEngine.PlayerPrefs.SetString("GuestUID",  num .. "")
					UnityEngine.PlayerPrefs.Save()
				end
			end
		 	this:SaveLoginInfo();
			Module_Bank:clearCachePwd();
			if(tMsg['wechat_lock'] and (tMsg['wechat_lock'] == 1 or tMsg['wechat_lock'] == "1" )) then
				EginUser.Instance.bankLoginType = EginUser.eBankLoginType.WECHAT;
			end

			this.mono:EginLoadLevel("Hall");
			ShowHallPanel(this.gameObject,false,function ()
				EginProgressHUD.Instance:HideHUD()
			end,function (  )
				this.transform:FindChild('Black_Background').gameObject:SetActive(false)
			end)
			
		end, 
		function(message)   
		end); 
end

function this:SocketDevice_Verify()

	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),false);

	local body = {username=EginUser.Instance.username,verify_code=this.verifyCode.value,device_id= "unity_".. EginUser.Instance.device_id}; 
 

	this.m_account_login_error_str = nil;
	this.curReconnectCount = 0;
	
	local tempFunction = function()
		if this.mono ~= nil then
			this.mono:Request_lua_fun("AccountService/device_verify",cjson.encode(body),function(message) 
				EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),false);
				this.mono:StartSocket(true);
			end, 
			function(message)   
				EginProgressHUD.Instance:ShowPromptHUD(message);
			end);	
		end
	end 
	ProtocolHelper.OnSocketConnectTriggerAction = tempFunction 
	this.mono:StartSocket(true);
end
 

 --游客登录 
 function this:OnSocket_GuestLogin()
 	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),false);
    ProtocolHelper._LoginType = LoginType.Guest;
	coroutine.start(this.StartSocketLogin,this)
	UnityEngine.PlayerPrefs.SetString("LoginType",'Guest');
	UnityEngine.PlayerPrefs.Save();
 end

---------------------微信登录---------------------------
function this:OnClickWeChatLogin( )
	ProtocolHelper._LoginType = LoginType.WeChat;
	
	EginProgressHUD.Instance:ShowWaitHUD("正在调用微信授权",true);

	this.mono:WeChatLogin('Login')
	

end

------------------微信登录回调----------------
function this.OnWechatSendAuthCallback( pMessageObj)
	print(' wechat call back message  ========lua==== '.. pMessageObj)

	if string.sub(pMessageObj,1,1) =='0'  then 
		local tSplit = string.split(pMessageObj,',')
		local tCode = nil
		if #tSplit >1 then
			tCode = tSplit[2]			
		end
		if tCode ~= nil then
			coroutine.start(this.DoRequireToken,this,tCode)
		else
			EginProgressHUD.Instance:ShowPromptHUD("数据有误", 2.0);
		end
	else 
		EginProgressHUD.Instance:ShowPromptHUD("授权失败", 2.0);
	end
end

----------------获取wechat token----------------
function this:DoRequireToken(pCode)
	local tWAppid = PlatformGameDefine.playform.WXAppId
	local tWAppSecret = PlatformGameDefine.playform.WxAppSecret
	local tGetTokenUrl = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid='..tWAppid..'&secret='..tWAppSecret..'&code='..pCode..'&grant_type=authorization_code'
	
	local tW = WWW.New(tGetTokenUrl)
	coroutine.www(tW)
	if tW.error == nil then 
		local tMsg = cjson.decode(tW.text )
		if tMsg['errcode'] == nil or tonumber(tMsg['errcode']) ==0 then
			this.m_AccessToken = tostring(tMsg['access_token'])
			this.m_RefreshToken = tostring(tMsg['refresh_token'])
			this.m_OpenId = tostring(tMsg['openid'])
			this.m_UnionId = tostring(tMsg['unionid'])

			print('Access toke == '..this.m_AccessToken..'// refreshtoken == '..this.m_RefreshToken..' // openid  == '.. this.m_OpenId..' // unionid == '..this.m_UnionId)
			coroutine.start(this.DoRequireUserInfo,this)
		end	
	else
		EginProgressHUD.Instance:ShowPromptHUD(tW.error, 2.0);

		print(tW.error)
	end

end

-------------获取wechat用户信息-----------------
function this:DoRequireUserInfo()
	local tUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=" .. this.m_AccessToken.. "&openid=" ..this.m_OpenId 
	local tW = WWW.New(tUrl)
	coroutine.www(tW) 
	if tW.error == nil then 
		local tMsg = cjson.decode(tW.text)
		this.m_UnionId  = tostring(tMsg['unionid'])
		this.m_NickName = tostring(tMsg['nickname'])
		this.m_Sex = tonumber(tMsg['sex'])
		print("unionid = " .. this.m_UnionId.. ", openid = " .. this.m_OpenId .. "nickname = " .. this.m_NickName)
		if PlatformGameDefine.playform.IsSocketLobby then
			coroutine.start(this.OnSocket_WeChatLogin,this)
		else
			coroutine.start(this.OnHttp_WeChatLogin,this)
		end
	else 
		EginProgressHUD.Instance:ShowPromptHUD(tW.error, 2.0);
		print(tW.error) 
	end 
	
end

-- http 微信登录
function this:OnHttp_WeChatLogin()
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),true);
	local form = UnityEngine.WWWForm.New();
	form:AddField("openid",this.m_OpenId )
	form:AddField("nickname", this.m_NickName)
	form:AddField("sex",this.m_Sex)
	form:AddField("unionid",this.m_UnionId)
	form:AddField('is_unity',1)
	
	UnityEngine.PlayerPrefs.SetString("LoginType",'WeChat');
	UnityEngine.PlayerPrefs.Save()
	local tUrl = ConnectDefine.REGISTER_WEIXIN_URL..'?openid='..this.m_OpenId..'&nickname='.. WWW.EscapeURL(this.m_NickName).."&sex=" ..this.m_Sex.. "&is_unity=1".."&unionid=" ..this.m_UnionId
	 
	local www = HttpConnect.Instance:HttpRequest(tUrl, nil);
	coroutine.www(www);
	
	EginUser.Instance.wxOpenId = this.m_OpenId;
	EginUser.Instance.wxNickname = this.m_NickName;
	EginUser.Instance.wxSex = this.m_Sex;
	EginUser.Instance.wxUnionId = this.m_UnionId;
	
	local result = HttpConnect.Instance:GuestLoginResult(www);
	EginProgressHUD.Instance:HideHUD ();
	if(HttpResult.ResultType.Sucess == result.resultType)  then
		--渠道处理
		Module_Channel.Instance:handleReg()
		this:SaveLoginInfo()
		this.mono:EginLoadLevel("Hall");
	else  
		if tostring(result.resultObject) == 'device_verify' then 
			this.verifyView:SetActive(true)
		else
			EginProgressHUD.Instance:ShowPromptHUD(tostring(result.resultObject), 2.0);
		end 
	end
end


--微信 socket登录
 function this:OnSocket_WeChatLogin()
 	print(' socket -------------  we chat login   ')
 	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectLogin"),true);
 	this.curReconnectCount = 0
 	this.m_account_login_error_str = nil 
	
	EginUser.Instance.wxOpenId = this.m_OpenId;
	EginUser.Instance.wxNickname = this.m_NickName;
	EginUser.Instance.wxSex = this.m_Sex;
	EginUser.Instance.wxUnionId = this.m_UnionId;
	UnityEngine.PlayerPrefs.SetString("LoginType",'WeChat');
	UnityEngine.PlayerPrefs.Save()
	coroutine.start(this.StartSocketLogin,this)
 end

 function this:SocketReceiveMessage( pMessageObj )

end

--lxtd004 2016 0817
function this:SetUserInfo(pMsg)
	EginUser.Instance:InitUserWithDict(pMsg,'')
	
end


---  手机登录 
function this.OnClickPhoneLogin( )
	this.PhoneLoginPanel:SetActive(true)
	if this.NeedIdentityCode == false then  
		this.PhoneIdentityCode.gameObject.transform.parent.gameObject:SetActive(false)
		this.PhoneNumber.gameObject.transform.parent.gameObject:SetActive(true)
		-- this.PhoneLoginTitle.text = '手机登录'
		this.PhoneSummit:SetActive(true)
		this.BtnCode:SetActive(false)
		-- this.PhoneNumberTitle.text = '输入手机号'
		-- this.PhoneSummitLab.text = '确认提交'
		this.mono:AddClick(this.PhoneSummit,this.OnClickPhoneRegister,this)
	else 
		this.PhoneIdentityCode.gameObject.transform.parent.gameObject:SetActive(true)
		this.PhoneNumber.gameObject.transform.parent.gameObject:SetActive(false)
		-- this.PhoneLoginTitle.text = '手机验证'
		-- this.PhoneSummitLab.text = '确认提交'
		-- this.PhoneNumberTitle.text = '短信验证码'
		this.PhoneSummit:SetActive(false)
		this.BtnCode:SetActive(true)
		this.BtnCodeSp.spriteName = 'BtnSMS'
		this.BtnCodeLab.gameObject:SetActive(false)
		this.mono:AddClick(this.PhoneSummit,this.OnClickPhoneRegister,this)
		this.mono:AddClick(this.BtnCode,this.IdentityCode,this)
		-- this.BtnCodeLab.text = '获取手机短信'
	end

end 

function this:OnClickPhoneRegister () 

	local errorInfo = "";
	if ( string.len(this.PhoneNumber.value) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("RegisterPhoneNumber");
	end
	
	if ( string.len(errorInfo) > 0)  then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else 
		this.mono:EndSocket(true); 
		EginProgressHUD.Instance:ShowWaitHUD('请等待',true)
		if EginUser.Instance.device_id  == nil or EginUser.Instance.device_id==''  then
			EginUser.Instance.device_id = UnityEngine.SystemInfo.deviceUniqueIdentifier
		end
		EginUser.Instance.phoneNum = this.PhoneNumber.value
		EginUser.Instance.phonecode = this.PhoneIdentityCode.value
		print('********************************* OnClick Register ')
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
				-- print('success   ==== '..message)
				local tMsg = cjson.decode(message)
				--lua EginUser 赋值
				this:SetUserInfo(message,'')
				EginProgressHUD.Instance:ShowWaitHUD( false)
				this.mono:EginLoadLevel("Hall");
				--渠道处理
				Module_Channel.Instance:handleReg()
			end,
			function(message)   
				if message =='phonecode' then
					this.NeedIdentityCode = true 
					EginProgressHUD.Instance:ShowWaitHUD( false)
					EginProgressHUD.Instance:ShowPromptHUD('需要手机验证码', 2);
					this.PhoneSummit:SetActive(false) 

					this.OnClickPhoneLogin()
				else
					EginProgressHUD.Instance:ShowWaitHUD( false)
					EginProgressHUD.Instance:ShowPromptHUD(message,1.5);
					this.mono:EndSocket(true); 
				end
			end);
		this.mono:StartSocket(true);
	end
	
end

function  this.IdentityCode( )
	local tBody = {}
	tBody['phone'] = EginUser.Instance.phoneNum
	this.mono:Request_lua_fun("AccountService/send_mobile_sms",cjson.encode(tBody),function(message) 
			-- print('success   ==== '..message)
			this.BtnCode:GetComponent('Collider').enabled = false 
			this.IsCount = true 

			coroutine.start(function ( )
				local tTime = 50 
				this.BtnCodeLab.gameObject:SetActive(true)
				this.BtnCodeSp.spriteName = 'BtnCount'
				-- this.BtnCodeLab.text = tTime
				this:SetNum(tTime)
				for i=1,50 do 
					coroutine.wait(1)
					if this.IsCount == false then
						break
					end 
					this:SetNum(tTime)
					-- this.BtnCodeLab.text = tTime
					tTime = tTime -1 
				end
				tTime = 50
				if this.IsCount == true then
					this.BtnCodeSp.spriteName = 'BtnSMS'
				else
					this.BtnCodeSp.spriteName = 'BtnCount'
					this.PhoneSummit:SetActive(true)
					-- this.mono:AddClick(this.BtnCode,this.OnClickPhoneRegister)
				end
				this.BtnCodeLab.gameObject:SetActive(false)
				this.BtnCode:GetComponent('Collider').enabled = true 
			end)
		end, 
		function(message)   
			print('fail  =====  '..message)
		end);
end

function this.CodeLenChange( )
	local tString = this.PhoneIdentityCode.value 

	if this.IsCount == true then 
		if string.len(tString)==6 then
			this.IsCount = false 
			this.BtnCode:SetActive(false)
			this.PhoneSummit:SetActive(true)
			this.BtnCodeLab.gameObject:SetActive(false)
		end 
	else
		if string.len(tString) ~= 6 then
			this.BtnCode:SetActive(true)
			this.PhoneSummit:SetActive(false)
			this.BtnCodeSp.spriteName = 'BtnSMS'
			this.BtnCode:GetComponent('Collider').enabled = true 
			this.BtnCodeLab.gameObject:SetActive(false)
		else
			this.BtnCode:SetActive(false)
			this.PhoneSummit:SetActive(true)
			this.BtnCodeLab.gameObject:SetActive(false)
		end
	end

end

function this:SetNum(pNum)
	local tOne = pNum%10
	this.BtnCodeLab.spriteName = tostring(tOne)
	if pNum <10 then
		this.BtnCodeLabTen.gameObject:SetActive(false)
	else
		this.BtnCodeLabTen.gameObject:SetActive(true)
		this.BtnCodeLabTen.spriteName = tostring(math.floor(pNum/10))
	end
end

function this.LoadNotices()
		
	
	    local notices;
	    local kNoticePrefab = ResManager:LoadAsset("HappyCity/Hall","Hall_Notice");
	    local www = HttpConnect.Instance:HttpRequestAli(PlatformGameDefine.playform:GameNoticeURL());
	    coroutine.www(www);
	    if(this.gameObject == nil)then
	        return;
	    end
	    local result = HttpConnect.Instance:BaseResult(www);
 
	      --notices = result.resultObject.list;
	        --log(www.text)
	        --[[{
	            "result": "ok",
	            "body":
	            [{"title": "牛牛体验房上线公告！", "time": "2016-01-22", "url": "http://www.game597.com/"},
	            {"title": "关于邮箱及手机验证码接收异常的公告！", "time": "2015-11-27", "url": "http://www.game597.com/"},
	            {"title": "手机绑定银行，财产安全保障！", "time": "2015-10-22", "url": "http://www.game597.com/"},
	            {"title": "关于游戏不能登录问题的解决方案！", "time": "2015-10-21", "url": "http://www.game597.com/"}]
	            }
	        ]]
	    if HttpResult.ResultType.Sucess == result.resultType  then
	      
	        local resultData = cjson.decode(www.text);
	        notices = resultData["body"];
	        if(#(notices) == 0)then
	            this:SetNoticeObj(kNoticePrefab, Vector3.New(0,0,0), ZPLocalization.Instance:Get("HallNotice"), ConnectDefine.HOME_URL);
	        else
	            for i=1, #(notices) do
	                this:SetNoticeObj(kNoticePrefab, Vector3.New(0,(i-1)*-45,0), notices[i]["title"], notices[i]["url"]);
	                if (i >= 3)then
	                    break;
	                end
	            end
	        end
	    else
	        this:SetNoticeObj(kNoticePrefab, Vector3.New(0,0,0), ZPLocalization.Instance:Get("HallNotice"), ConnectDefine.HOME_URL);
	    end
end

function this:SetNoticeObj(prb, vc3, title, url)
    local notice = GameObject.Instantiate(prb);
    local vNotices = this.transform:FindChild("Notice/Con");
    notice.transform.parent = vNotices;
    notice.transform.localScale = Vector3.New(1,1,1);
    if(PlatformGameDefine.playform.PlatformName == "1977game2" or  PlatformGameDefine.playform.PlatformName == "game597")then
        notice.transform.localScale = Vector3.New(0.8,0.8,0.8);
    end
    notice.transform.localPosition = vc3;
    notice:GetComponent("UIPanel").depth = notice:GetComponent("UIPanel").depth + 1;
    notice.transform:Find("Label_Title"):GetComponent("UILabel").text = title;
    notice.transform:Find("Label_Time"):GetComponent("UILabel").text = "";
    notice.transform:Find("Label_URL"):GetComponent("UILabel").text = url;
    
    this.mono:AddClick(notice.transform:Find("Label_Title").gameObject, this.OnClickNotice, this, {notice})
    if (Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer) then
        notice:GetComponent("BoxCollider").enabled = false;
    end
end
function this:OnClickNotice(hall, tb)
    local notice = tb[1];
    local url = notice.transform:Find("Label_URL"):GetComponent("UILabel").text;
    Application.OpenURL(url);
end

function this:LoadPlatformLogo( )
	if(PlatformGameDefine.playform.IOSPayFlag == false) then return end;

	local tPrb = ResManager:LoadAsset("HappyCity/Platform_Logo","Platform_Logo");
    local tLogoObj = GameObject.Instantiate(tPrb);
    local tParent= this.transform:FindChild("Platform_Logo");
    tLogoObj.transform.parent = tParent;
    tLogoObj.transform.localScale = Vector3.one;
    tLogoObj.transform.localPosition =Vector3.New(0,-50,0)
    tLogoObj:GetComponent('UITexture').depth = 1
     tLogoObj:GetComponent('UITexture').width = 655
    tLogoObj:GetComponent('UITexture').height = 254

end

