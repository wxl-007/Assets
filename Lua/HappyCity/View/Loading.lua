
local this = LuaObject:New()
Loading = this
local WWW = UnityEngine.WWW;
local LoadingStage = {['CheckVersion']=1,['LoadInfo']=2,['DoLogin']=3,['Download']=4,['GoLogin']=5,['GoHall'] = 6}


function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	this.m_KLabel = nil 
	this.m_Version = nil 
	this.m_VersionContentLab = nil 
	this.m_VersionCancelObj = nil 
	this.m_VersionCode = 0
	this.m_NewVersionCode = 0
	this.m_VersionUpdateUrl = ''
	this.m_CurTimeOutCount = 0
	this.m_OnDestroyAction = nil 
	this.m_InstantUpdateAction = nil 
	this.m_InstantUpdateCompleted = nil 
	this.m_IsGoLogin = false 
	this.m_WaitUrl = nil
	this.m_UserName =''
	this.m_PassWord = ''
	this.m_RunAni = false 
	coroutine.Stop()
	LuaGC()
end



function this:Awake()
	this:Init()
end

function this:Init(  )
	--初始化第一次进入大厅
	Hall.FirstEnter = true;	
	
	this.m_TimeUrl = { "http://time.tianqi.com/beijing/","http://www.timedate.cn/worldclock/ti.asp"  };
	this.m_KLabel = this.transform:FindChild('Body/Label'):GetComponent('UILabel')
	this.m_Version = this.transform:FindChild('Body/VersionUpdate').gameObject
	this.m_VersionContentLab =this.m_Version.transform:FindChild('Label'):GetComponent('UILabel')
	this.m_VersionCancelObj = this.m_Version.transform:FindChild('Button_Cancel').gameObject
	this.m_VersionCode = 0
	this.m_NewVersionCode = 0
	this.m_VersionUpdateUrl = ''
	this.m_CurTimeOutCount = 0
	this.m_IsGoLogin = false 
	this.m_UserName =''
	this.m_PassWord = ''
	this.mono:AddClick(this.m_Version.transform:FindChild("Button_Update").gameObject, this.OnClickVersionUpdate,this);
	this.mono:AddClick(this.m_Version.transform:FindChild("Button_Cancel").gameObject, this.OnClickVersionCancel,this);
	this.m_RunAni = false 
end

function this:Start( )
	coroutine.start(this.StartLoading)
	local lmrPrb = ResManager:LoadAsset("HappyCity/LobbyMsgReceiver","LobbyMsgReceiver");
	local lmrObj = GameObject.Instantiate(lmrPrb);
 
	if(PlatformGameDefine.playform:GetPlatformPrefix()=="597") then 
 
			if PlatformLua.playform.baiduYuntui ~= "" then
				log("初始化推送")
				--百度云推送 1为生产环境，0为开发环境
				PhoneSdkUtil.initBaiduYuntui(PlatformLua.playform.baiduYuntui,"LobbyMsgReceiver",1)
			end
 
	end
	 this:LoadSimpleHUD( )
end

function this.StartLoading( )
	if PlatformGameDefine.playform.IsSocketLobby == false then 
		coroutine.start(this.DoCheckBaiduTime)
	else
		EginTools.localBeiJingTime = 0 
	end
	this.m_RunAni = true 
	this:LoadingAni()
	local iscoroutine = DoneCoroutine.New();
	this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadLocalConfig(),iscoroutine);
	coroutine.branchC(iscoroutine); 
	PlatformGameDefine.playform:Start_LoadAndSaveConfigData(Utils.NullObj)
	if PlatformGameDefine.playform.IsSocketLobby == false then
		local tGFName = UnityEngine.PlayerPrefs.GetString('GFname'..PlatformGameDefine.playform.PlatformName)
		local tWFName = UnityEngine.PlayerPrefs.GetString('WFname'..PlatformGameDefine.playform.PlatformName)
		PlatformGameDefine.playform:UpdateGFnameURL(tGFName)
		PlatformGameDefine.playform:UpdateWFnameURL(tWFName)
		local tIsCoroutine = DoneCoroutine.New();
		this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadConfig_game_hostArr(Utils.NullObj,false),tIsCoroutine)
		this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadConfig_web_hostArr(Utils.NullObj,false),tIsCoroutine)
		coroutine.branchC(tIsCoroutine); 
	end
	coroutine.start(this.DoChekcVersion)

	Utils.StartInstantDownload()
end

function this.DoCheckBaiduTime( )
	if this.m_CurTimeOutCount >= #this.m_TimeUrl *2 then
		EginTools.localBeiJingTime = 0
	else
		local tIsTimeOut  = false 
		local tI = this.m_CurTimeOutCount/2 +1
		local tW = HttpConnect.Instance:HttpRequestAli(this.m_TimeUrl[tI])
		
		this.mono:CheckTimeOut(tW,function ( )
			tIsTimeOut = true 
		end,20)


		if tIsTimeOut then
			this.m_CurTimeOutCount = this.m_CurTimeOutCount  + 1
			coroutine.start(this.DoCheckBaiduTime)
			return
		end
		coroutine.www(tW)
		if tW.error ~= nil then
			EginTools.localBeiJingTime = 0
		else
			local tResultStr = tW.text 
			local tTime = 0 
			if this.m_CurTimeOutCount /2 ==0 or this.m_CurTimeOutCount /2 ==1 then
				
				local tTryCatchFunc = function (  )
					local tFirstIndex = string.find(tResultStr,'t0=new')--"Date().getTime();")
					local tSecondIndex = string.find(tResultStr,'s=document.URL')
					local tChildStr = string.sub(tResultStr,tFirstIndex,tSecondIndex)
					tFirstIndex = string.find(tChildStr,';');
					tChildStr = string.sub(tChildStr,tFirstIndex+1)
				
					local tFirstTimeIndex = 0
					local tSecondTimeIndex =0 

					tFirstTimeIndex = string.find(tChildStr,'=')
					tSecondTimeIndex = string.find(tChildStr,';')
					local tYear = tonumber(string.sub(tChildStr,tFirstTimeIndex+1,tSecondTimeIndex-1))

					tFirstTimeIndex = string.find(tChildStr,'nmonth=')
					tSecondTimeIndex = string.find(tChildStr,';',tSecondTimeIndex+1)
					local tMonth = tonumber(string.sub(tChildStr,tFirstTimeIndex+7, tSecondTimeIndex-1))

					tFirstTimeIndex = string.find(tChildStr,'nday=')
					tSecondTimeIndex = string.find(tChildStr,';',tSecondTimeIndex+1)
					local tDay = tonumber(string.sub(tChildStr,tFirstTimeIndex+5, tSecondTimeIndex-1))
					tSecondTimeIndex = string.find(tChildStr,';',tSecondTimeIndex+1)

					tFirstTimeIndex = string.find(tChildStr,'nhrs=')
					tSecondTimeIndex = string.find(tChildStr,';',tSecondTimeIndex+1)
					local tHours = tonumber(string.sub(tChildStr,tFirstTimeIndex+5, tSecondTimeIndex-1))
					
					tFirstTimeIndex = string.find(tChildStr,'nmin=')
					tSecondTimeIndex = string.find(tChildStr,';',tSecondTimeIndex+1)
					local tMin = tonumber(string.sub(tChildStr,tFirstTimeIndex+5, tSecondTimeIndex-1))
					
					tFirstTimeIndex = string.find(tChildStr,'nsec=')
					tSecondTimeIndex = string.find(tChildStr,';',tSecondTimeIndex+1)
					local tSec = tonumber(string.sub(tChildStr,tFirstTimeIndex+5, tSecondTimeIndex-1))
					local tTab = {year=tYear, month=tMonth, day=tDay, hour=tHours,min=tMin,sec=tSec,isdst=false}
					tTime = os.time(tTab) 
				end


				if not pcall(tTryCatchFunc) then
					this.m_CurTimeOutCount = this.m_CurTimeOutCount+1 
					coroutine.start(this.DoCheckBaiduTime)
					return
				end
			end
			EginTools.localBeiJingTime = tTime*1000 - EginTools.nowMinis()
		end
	end
end

function this.CheckTimeOut(pW,pFunc )
	local tCurTime = 0
	while(not pW.isDone) do 
		tCurTime = tCurTime + Time.deltaTime
		if tCurTime > 20 then
			
			if pFunc ~= nil and type(pFunc) == 'function' then 
				pFunc()
			end
			break
		end
		return 0 
	end
end

function this.DoChekcVersion( )
	this:UpdateSlider(LoadingStage.CheckVersion)
	this.m_VersionCode = math.max(UnityEngine.PlayerPrefs.GetInt('VersionCode',PlatformGameDefine.game.VersionCode),PlatformGameDefine.game.VersionCode)
	if PlatformGameDefine.playform.VersionCode >0 and this.m_VersionCode >= PlatformGameDefine.playform.VersionCode then
		coroutine.start(this.DoLoading,true)
		return
	end
	
	local tUrl = GameManager.ChekcVersionURL()
	local iscoroutine = WaitCoroutine.New();
	-- lxtd004
	this.m_UserName = UnityEngine.PlayerPrefs.GetString('AutoUsername','') --UnityEngine.PlayerPrefs.GetString('EginUsername','')
	this.m_PassWord = UnityEngine.PlayerPrefs.GetString(this.m_UserName,'')--UnityEngine.PlayerPrefs.GetString(this.m_UserName,'')
	this.mono:WWWReconnectCall( tUrl,this.m_UserName,iscoroutine);
	coroutine.branchC(iscoroutine); 
	
	if iscoroutine.isDoneCoroutine == false or iscoroutine.DownWWW == nil  then
		coroutine.start(this.DoLoading,true)
		return
	end


	local tW1 = iscoroutine.DownWWW
	local tResult  = HttpConnect.Instance:BaseResult(tW1)
	if HttpResult.ResultType.Sucess == tResult.resultType then
		local tJson = require "cjson"
		local tVersionObj =tResult.resultObject
		
		local tCode =tVersionObj.version_code
		this.m_NewVersionCode = 0
		if tVersionObj ~= nil then  
			if tVersionObj.version_code ~= nil then
				this.m_NewVersionCode = tonumber(tCode)
				print(this.m_NewVersionCode)
			else
				this.m_NewVersionCode = 0
			end
		end
		
		if this.m_NewVersionCode > this.m_VersionCode then
			GameManager.tVersionObj = tVersionObj;
			if(Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer)then
				coroutine.start(this.DoLoading,true)
			else
				this:ShowUpdateView(tVersionObj)
			end
		else
			coroutine.start(this.DoLoading,true)
		end
	else
		coroutine.start(this.DoLoading,true)
	end

end


function this.ReconnectUrlCallBack( )
	local pResultUrl = this.m_WaitUrl
	local tW1 = WWW.New(pResultUrl)
	local tResult  = HttpConnect.Instance:BaseResult(tW1)
	if HttpRequest.ResultType.Sucess == tResult.resultType then
		local tVersionObj = tResult.resultObject
		this.m_NewVersionCode = 0
		if tVersionObj ~= nil then  
			if tVersionObj['version_code'] ~= nil then
				this.m_NewVersionCode = tonumber(tVersionObj['version_code'])
			else
				this.m_NewVersionCode = 0
			end
		end
		if this.m_NewVersionCode > this.m_VersionCode then
			
			if(Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer)then 
				coroutine.start(this.DoLoading,true)
			else
				this:ShowUpdateView(tVersionObj)
			end
		else
			coroutine.start(this.DoLoading,true )
		end
	end
end

function this:OnClickVersionCancel( )
	this.m_Version:SetActive(false)
	coroutine.start(this.DoLoading,true)
end

function this:OnClickVersionUpdate()
	Application.OpenURL(this.m_VersionUpdateUrl)
end


function this.DoLoading(pIsLoad)
	if this.m_InstantUpdateAction ~= nil then
		this.m_InstantUpdateAction()
	end
	if this.m_InstantUpdateCompleted ~= nil then
		while (this.m_InstantUpdateCompleted() == false) do 
			coroutine.wait(0.02)
		end 
	end

	this:UpdateSlider(LoadingStage.LoadInfo)
	local tIsRememberPre = true --UnityEngine.PlayerPrefs.GetInt('RemberPS',0) == 1
	local tIsAutoLogin =   true--UnityEngine.PlayerPrefs.GetInt('AutoLogin2',0) ==1 
	if tIsRememberPre and tIsAutoLogin then
		-- lxtd004
		this.m_UserName = UnityEngine.PlayerPrefs.GetString('EginUsername','')
		this.m_PassWord = UnityEngine.PlayerPrefs.GetString(this.m_UserName,'')
		
		if UnityEngine.PlayerPrefs.GetString('LoginType') == 'WeChat' then 

			ProtocolHelper._LoginType = LoginType.WeChat
			EginUser.Instance.wxOpenId =  UnityEngine.PlayerPrefs.GetString('openid','')
			EginUser.Instance.wxNickname = UnityEngine.PlayerPrefs.GetString('nickname','')
			EginUser.Instance.wxUnionId = UnityEngine.PlayerPrefs.GetString('WeChatUnionId','')
			
			UnityEngine.PlayerPrefs.SetString('LoginType','WeChat') 
			UnityEngine.PlayerPrefs.Save()
			ProtocolHelper.Send_wechat_login()
			this.mono:StartSocket(true);
			coroutine.start(this.ForceLoadLogin)
		else

			if string.len(this.m_UserName)>0 and string.len(this.m_PassWord) >0 then
				this:UpdateSlider(LoadingStage.DoLogin)
				if PlatformGameDefine.playform.IsSocketLobby then
						ProtocolHelper._LoginType = LoginType.Username;
						if pIsLoad == true then
							local iscoroutine = DoneCoroutine.New();
							this.mono:StartCoroutineLuaToC(PlatformGameDefine.playform:LoadConfByUser(this.m_UserName),iscoroutine);
							coroutine.branchC(iscoroutine);
						end 

						SocketConnectInfo.Instance.lobbyUserName = this.m_UserName
						SocketConnectInfo.Instance.lobbyPassword = this.m_PassWord
						Util.SetSocketInfo(SocketConnectInfo.Instance.lobbyUserName,SocketConnectInfo.Instance.lobbyPassword)
						
						this.mono:StartSocket(true);
						coroutine.start(this.ForceLoadLogin)

				
				else
					local form = UnityEngine.WWWForm.New();
					local tW 
					if pIsLoad == true then 
						form:AddField("username", this.m_UserName);
						form:AddField("password", this.m_PassWord);
						form:AddField("device_id", "unity_"..SystemInfo.deviceUniqueIdentifier);--
						if  Application.platform == UnityEngine.RuntimePlatform.Android then 
							local mVersionCode = math.max(UnityEngine.PlayerPrefs.GetInt ("VersionCode", PlatformGameDefine.game.VersionCode), PlatformGameDefine.game.VersionCode); 
							form:AddField("version", this.m_VersionCode);
							form:AddField("platform", "Android");
						else
							form:AddField("platform", "iOS");
						end

						tW = HttpConnect.Instance:HttpRequest(ConnectDefine.LOGIN_URL,form)
						coroutine.www(tW)
					end
					local tRe = HttpConnect.Instance:UserLoginResult(tW)
				
					if HttpResult.ResultType.Sucess == tRe.resultType then
						this:UpdateSlider(LoadingStage.GoHall)
					else
						this:UpdateSlider(LoadingStage.GoLogin)
					end
				end
			else
				this:UpdateSlider(LoadingStage.GoLogin)
			end
		end
	else
		this:UpdateSlider(LoadingStage.GoLogin)
	end

end

function this:UpdateSlider(pStage )
	if pStage == LoadingStage.CheckVersion then
		this.m_KLabel.text = 'V'..Utils.version .. ' '..ZPLocalization.Instance:Get('LoadingCheckVersion') 
	elseif pStage == LoadingStage.LoadInfo then
		this.m_KLabel.text = ZPLocalization.Instance:Get("LoadingLoadInfo")
	elseif pStage == LoadingStage.DoLogin then
		this.m_KLabel.text  =ZPLocalization.Instance:Get("LoadingDoLogin")
	elseif pStage == LoadingStage.GoLogin then
		this.m_KLabel.text = ''
		if this.m_IsGoLogin == false then

			this.m_IsGoLogin = true
			-- this.mono:EginLoadLevel('Hall')
			-- Utils.LoadAdditiveGameUI('Login',Vector3.zero)
			this.mono:EginLoadLevel("Login")
		end
	elseif pStage == LoadingStage.GoHall then
		this.m_KLabel.text = ''
		this.mono:EginLoadLevel('Hall')
	end
end

function this:ShowUpdateView(pVersionObj )
	this.m_VersionUpdateUrl = pVersionObj['url']
	this.m_VersionContentLab.text  = pVersionObj['update']
	local tDeprecateCode = tonumber(pVersionObj['deprecated_code'])
	local tCancel = this.m_VersionCode > tDeprecateCode
	this.m_VersionCancelObj:SetActive(tCancel)
	
	if(Application.platform == UnityEngine.RuntimePlatform.Android) then
		local Path = luanet.import_type('System.IO.Path');
		local mVersionUpdateUrl = this.m_VersionUpdateUrl;
		local fileName = Path.GetFileName(mVersionUpdateUrl);
		local fileNameWithOutExtention = Path.GetFileNameWithoutExtension(mVersionUpdateUrl);
		fileName = string.gsub(fileName,fileNameWithOutExtention,this.m_NewVersionCode .. "");
		Utils.StartVersionUpdate(mVersionUpdateUrl,fileName);
		coroutine.start(this.DoLoading,true) 
	else 
		this.m_Version:SetActive(true)
	end
end

function this:SocketDisconnect(pDisConnectInfo )
	this:UpdateSlider(LoadingStage.GoLogin)
end
function this:OnSocketDisconnect(pDisConnectInfo)
	this:UpdateSlider(LoadingStage.GoLogin)
end

function this.Process_account_login_Failed(pErrorInfo,pBody)
	this:UpdateSlider(LoadingStage.GoLogin)
end


function this.Process_account_login( pInfo )
	ProtocolHelper.Send_get_account();--获取用户信息
	-- print('in  accont  login   ')
	this.mono:Request_lua_fun(ProtocolHelper.get_account,nil,function(message) 
		ProtocolHelper.Receive_get_ccount(message)
		-- ProtocolHelper.Receive_get_ccount(Util.packJSONObjectLua(message));
		--lua EginUser 赋值
		this:SetUserInfo(message)
		this:UpdateSlider(LoadingStage.GoHall)
	end, 
	function(message) 
	  this:UpdateSlider(LoadingStage.GoLogin)
	end); 

end

function this.ForceLoadLogin( )
	coroutine.wait(15)
	if this.mono ~= nil then
		this.mono:EndSocket(true)
		this:UpdateSlider(LoadingStage.GoLogin)
	end 
end

function this.ReconnectUrl(pUrl,pFunc,pErrorFunc)
	local tCurReconnect = 0 
	local tW =nil 
	while (tCurReconnect <= 1) do
		tCurReconnect = tCurReconnect +1 
		tW = WWW.New(HttpConnect.Instance:HttpRequestAli(pUrl))
		coroutine.start(this.TimeOutFunc,tW,nil,tW)
		-- coroutine.www(tW)
		if tW.error== nil then
			break
		end
	end
	if type(pFunc) == 'function' and type(pErrorFunc) == 'function' then
		if tW.error ~= nil then
			pErrorFunc()
			
		else
			this.m_WaitUrl = tW.text 
			coroutine.start(this.ReconnectUrlCallBack)

		end
	end
end


function this.TimeOutFunc(pWWW,pFunc,pWResult)
	if pWResult~= nil then 
		pWResult.error = nil 
	end
	local tCurTime =0 
	local tIsDispose = false 
	if pWWW== nil then 
		return
	end
	local tErr = function(pErrorText  )
		if pErrorText == nil or pErrorText=='' then
			return
		end
		if pWResult ~= nil then
			pWResult.error = pErrorText
		end

		if tIsDispose ==false then 
			pWWW.DisposeAsync()
		end

	end
	local tDownFunc = function ( )
		if not pcall(function() return pWWW.isDone end) then
			tIsDispose = true 
			return false 
		end
	end


	while (tDownFunc() == false and tIsDispose == false) do 
		tCurTime = tCurTime + Time.deltaTime
		if tCurTime> 20 then
		 	if type(pFunc)=='function' then
		 		if pFunc ~= nil then
		 			pFunc()
		 		end
		 		
		 	end
		 	return
		end
		return 0 
	end  
	if tIsDispose ==false then
		tErr(pWWW.error)
	end

end

function this:OnDestroy()
	this.clearLuaValue()
end
--lxtd004 2016 0817
function this:SetUserInfo(pMsg)
	EginUser.Instance:InitUserWithDict(pMsg,'')
end
function this:LoadingAni()
	local tFul = 64
	local i = 0
	local tDelta = 12
	-- print('==========================111')
	coroutine.start(function ()
		while(this.m_RunAni) do
			i= i +1
			local tNum = this.transform:FindChild('Body/Animation/SpriteAnimation_'..i).gameObject
			local tSpObj = tNum.transform:FindChild('Sp').gameObject
			local tSp = tSpObj:GetComponent('UISprite')
			for j=0,tFul do
				local tN = tSp.width
				if tN +tDelta >= tFul then
					tSp.width = 64
					break
				end 
				tSp.width =tSp.width +tDelta 
				coroutine.wait(0.01)
			end
			if i == 6 then
				i=0
				for j =1,6 do 
					local tUSp= this.transform:FindChild('Body/Animation/SpriteAnimation_'..j):FindChild('Sp').gameObject:GetComponent('UISprite')
					tUSp.width = 0 
				end
			end
		end
	end)
end

function this:LoadSimpleHUD(  )
	local tPreObj = ResManager:LoadAsset('HappyCity/SimpleHUD','SimpleHUD')
	local tHUDObj = GameObject.Instantiate(tPreObj);
	tHUDObj:SetActive(false)
	SimpleHUD:Init(tHUDObj)
	-- tHUDObj.transform.parent = find('GUI')
	-- tHUDObj.transform.localPosition = Vector3.zero
	-- tHUDObj.transform.localScale =Vector3.one  
	UnityEngine.Object.DontDestroyOnLoad(tHUDObj)
end