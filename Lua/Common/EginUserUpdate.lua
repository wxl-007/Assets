local this = LuaObject:New()
EginUserUpdate = this


this.Instance = this 

this.updateInterval = 420
this.updateLoopInterval =10
this.updateLoop = false
this.updateLoopHasStart = function (  )
	return this.updateLoop
end
this.lastUpdateInterval =0

function this:Init() 
	this.gameObject = GameObject.Find('EginUserUpdateContainer')
	if this.gameObject == nil then
	this.gameObject = GameObject.Find('EginUserUpdateContainer(Clone)')
	end
	if this.gameObject == nil then 
		this.gameObject = GameObject.New("EginUserUpdateContainer")
		this.gameObject:AddComponent(Type.GetType("EginUserUpdate",true))
	end


	this.transform=this.gameObject.transform
	this.InvokeLua = InvokeLua:New(this);
end
function this.UpdateInfoStart()
	if this.InvokeLua == nil then 
		this:Init() 
	end
	if not this.InvokeLua:IsInvoking("invokeUpdateInfo") then
		this.updateLoop = true
		this.InvokeLua:InvokeRepeating("invokeUpdateInfo",this.invokeUpdateInfo, 0.1, 420);
	end
end


function this.invokeUpdateInfo( )
	if PlatformGameDefine.playform.IsSocketLobby then
		local tMsg = {}
		tMsg['type'] = 'AccountService'
		tMsg['tag'] = 'get_account'
		tMsg['body'] = ''
		if Util.isEditor then
			print("<color=#00cc00>"..tostring(tMsg).."</color>")
		end
		--大厅用Request_lua_fun，其他Util.SendPackage
		if Hall.mono~= nil  then
			Hall.mono:Request_lua_fun("AccountService/get_account",cjson.encode(tMsg),function(message)
			end,
			function(message)
				EginProgressHUD.Instance:ShowPromptHUD("加载中...")
			end);
		else
			Util.SendPackage(cjson.encode(tMsg))
		end
	else
		print('invokeUpdateInfo>>>>>>>>>>>>>>>>')
		coroutine.start(this.UpdateInfo)
	end
end

function this.UpdateInfoStop(  )
	this.updateLoop = false 
	this.lastUpdateInterval =0 
	this.InvokeLua:CancelInvoke('invokeUpdateInfo')
end

function this.UpdateInfoNow(  )
	this.lastUpdateInterval = 0 
	this.invokeUpdateInfo()
end

function this.UpdateInfo(  )
	print('UpdateInfo>>>>>>>>>>>>>>>')
	this.lastUpdateInterval =0 
	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.UPDATE_USERINFO_URL,nil)
	coroutine.www(www)
	print('>>>>>>>>>>>>>>>>  '.. www.text)
	HttpConnect.Instance:UpdateUserinfoResult(www);
end