local this = LuaObject:New()

ProtocolHelper = this

LoginType = {
	['Username'] = 'Username',
	['WeChat'] = 'WeChat',
	['Guest'] = 'Guest',
	['Phone'] = 'Phone',
}
this.account_login = "AccountService/account_login"
this.get_account = "AccountService/get_account"
--endregion 协议接口路径
this.OnSocketConnectTriggerAction = nil
this._LoginType = LoginType.Username;
-- this.NewLobbyLogin_lua = ''
-- this.NewGameLogin_lua = ''
this.entryRoom_password = ''

function this.Send_account_login()
	print('>>>>>>>>>>>>>>>>>>    send account_login')
	this._LoginType = LoginType.Username 
	local connectInfo = SocketConnectInfo.Instance;
	local bodyJson = {}
	bodyJson['username'] = connectInfo.lobbyUserName 
	bodyJson['password'] = connectInfo.lobbyPassword
	bodyJson['machineCode'] = "unity_" .. EginUser.Instance.device_id
	--bodyJson['device_id']  =  UnityEngine.SystemInfo.deviceUniqueIdentifier
	bodyJson['device_id']  =  "unity_" .. EginUser.Instance.device_id
	bodyJson['client_type'] = '0' 
	local loginJson = {}
	loginJson['type'] = 'AccountService'
	loginJson['tag'] = 'account_login'
	loginJson['body'] = bodyJson
	Util.SendPackage(cjson.encode(loginJson))
end

function this.Send_wechat_login()
	print('>>>>>>>>>>>>>>>>>>    send Send_wechat_login')
	if EginUser.Instance.wxOpenId == nil or EginUser.Instance.wxOpenId == "" then
		EginProgressHUD.Instance:ShowPromptHUD("登录数据有误,请稍后重新登录", 5.0);
		return;
	end
	if EginUser.Instance.wxUnionId == nil or EginUser.Instance.wxUnionId == "" then
		EginProgressHUD.Instance:ShowPromptHUD("登录数据有误,请稍后重新登录", 5.0);
		return;
	end
	this._LoginType = LoginType.WeChat 
	local bodyJson = {}
	bodyJson['openid'] = EginUser.Instance.wxOpenId
	bodyJson['unionid'] = EginUser.Instance.wxUnionId
	bodyJson['nickname'] = EginUser.Instance.wxNickname
	bodyJson['sex'] = EginUser.Instance.wxSex
	bodyJson['device_id']  =  "unity_" .. EginUser.Instance.device_id
	bodyJson['is_unity'] = 1
	bodyJson['agent_id'] = Utils.Agent_Id;
	local loginJson = {}
	loginJson['type'] = 'AccountService'
	loginJson['tag'] = 'wechat_oauth'
	loginJson['body'] = bodyJson

	UnityEngine.PlayerPrefs.SetString('WeChatUnionId',EginUser.Instance.wxUnionId)
	UnityEngine.PlayerPrefs.SetString('openid',EginUser.Instance.wxUnionId)
	UnityEngine.PlayerPrefs.SetString('nickname',EginUser.Instance.wxNickname)
	UnityEngine.PlayerPrefs.SetString('device_id',"unity_" .. EginUser.Instance.device_id)
	
	UnityEngine.PlayerPrefs.Save()
	Util.SendPackage(cjson.encode(loginJson))
end
function this.Send_wechat_login_New()
	print('>>>>>>>>>>>>>>>>>> NewNNNNNNNNN Send_wechat_login')
	this._LoginType = LoginType.WeChat 
	local bodyJson = {}
	bodyJson['code'] = ''
	bodyJson['state'] = ''
	bodyJson['device_id']  =  "unity_" .. EginUser.Instance.device_id
	-- bodyJson['openid'] = EginUser.Instance.wxOpenId
	-- bodyJson['nickname'] = EginUser.Instance.wxNickname
	-- bodyJson['sex'] = EginUser.Instance.wxSex
	-- bodyJson['is_unity'] = 1
	local loginJson = {}
	loginJson['type'] = 'AccountService'
	loginJson['tag'] = 'wechat_oauth1'
	loginJson['body'] = bodyJson
	Util.SendPackage(cjson.encode(loginJson))
end

function this.Send_guest_login(  )
	print('>>>>>>>>>>>>>>>>>>     Send_guest_login')
	this._LoginType = LoginType.Guest 
	local bodyJson = {}
	local uid_long =0 
	local GuestUID = UnityEngine.PlayerPrefs.GetString("GuestUID",tostring(uid_long));
	if GuestUID =='0' then
		bodyJson['uid'] = uid_long
	else
		bodyJson['uid'] = GuestUID
	end
	bodyJson['device_id']  =  "unity_" .. EginUser.Instance.device_id
	bodyJson['agent_id'] = Utils.Agent_Id;
	local loginJson = {}
	loginJson['type'] = 'AccountService'
	loginJson['tag'] = 'guest_login'
	loginJson['body'] = bodyJson

	Util.SendPackage(cjson.encode(loginJson))

end

function this.Send_get_account(  )
	--error('>>>>>>>>>>>>>>>>>>   Send_get_account')

	local loginJson = {}
	loginJson['type'] = 'AccountService'
	loginJson['tag'] = 'get_account'
	loginJson['body'] = ''
	Util.SendPackage(cjson.encode(loginJson))
end

function this.Receive_get_ccount(result )
	print('>>>>>>>>>>>>>>>>>>   Receive_get_ccount')
 	local  session = "";
    --对socket协议中 字段 的不同进行修正
    -- local resultDict = cjson.decode(tostring(result))--cjson.decode(result)
    -- print(result)
    -- print(resultDict['userid'])
    -- print(resultDict['avatar_no'])
    
    -- if resultDict["id"] ~= nil then resultDict["id"] = resultDict["userid"] end
    -- if resultDict["exp"] ~= nil then resultDict["exp"] = resultDict["exp_value"] end
    -- if resultDict["next_exp"] ~= nil then resultDict["next_exp"] = resultDict["exp_value"] end
    -- if resultDict["avatar_img"] ~= nil then resultDict["avatar_img"] = "" end
    -- if resultDict["agent"] ~= nil then resultDict["agent"] = "" end
    -- if resultDict["weak"] ~= nil then resultDict["weak"] = "0" end
    -- if resultDict["gold_money"] ~= nil then resultDict["gold_money"] = "0" end
    --处理登录返回信息
    EginUser.Instance:InitUserWithDict(result, session);
    EginUser.Instance.isGuest = false
end

function this.Send_game_login(  )
	print('>>>>>>>>>>>>>>>>>>   Send_game_login')

	local tConnectInfo = SocketConnectInfo.Instance
	local tMessageBody = {}
	tMessageBody['userid'] = tConnectInfo.userId
	tMessageBody['password'] = tConnectInfo.userPassword
	tMessageBody['dbname'] = tConnectInfo.roomDBName
	tMessageBody['version'] = '0'
	tMessageBody['client_type'] = '0'
	tMessageBody['roomid'] = tConnectInfo.roomId
	tMessageBody['fixseat'] = true
	if(PlatformGameDefine.game.GameID == "1006" and PlatformGameDefine.game.GameTypeIDs == "20")then
		if string.len(this.entryRoom_password) >0 then
			tMessageBody['entry_pwd'] = this.entryRoom_password
		else
			tMessageBody['client_info'] = 'WIN'
		end
	else
		tMessageBody['client_info'] = 'WIN';
	end
	
	local tMessageObj  = {}
	tMessageObj['type'] = 'account'
	tMessageObj['tag'] = 'login'
	tMessageObj['body'] = tMessageBody 
	local tMsg =cjson.encode(tMessageObj)
	Util.SendPackageSpecial(tMsg,tConnectInfo.userPassword);
	--this.entryRoom_password = ""
end


function this.Send_Socketlobby_login()
	print('>>>>>>>>>>>>>>>>>>   Send_Socketlobby_login')
	if this.OnSocketConnectTriggerAction ~= nil then
		this.OnSocketConnectTriggerAction()
		this.OnSocketConnectTriggerAction = nil 
		return
	end 
	if this._LoginType  == LoginType.WeChat then
		this.Send_wechat_login()
	elseif this._LoginType  ==LoginType.Guest then
		this.Send_guest_login()
	elseif this._LoginType == LoginType.Username then
		this.Send_account_login()
	elseif this._LoginType == LoginType.Phone then

		this.Send_Phone_login()

	end
end

function this.Send_login(pIsGame)
	-- print(">>>>>>>>>>>>>>>  send Login ")
	-- print(  pIsGame  )
	if pIsGame == nil then
		pIsGame = false 
	end
	if pIsGame then
		this.Send_game_login()
	else
		this.Send_Socketlobby_login()
	end

end

function this.Send( pPath,pBodyJson )
	local tSendJson = {}
	local tStr =string.split(pPath,"/");
	if tStr == nil or #tStr ~=2  then
		error("the format of path \"" .. pPath .. "\" is wrong")
	end
	tSendJson['type'] = tStr[1]
	tSendJson['tag'] = tStr[2]
	tSendJson['body'] = pBodyJson
	Util.SendPackage(tSendJson)
end

----添加手机登录 --  
function this.Send_Phone_login()
	print('>>>>>>>>>>>>>>>>>>   Send_Phone_login')

 	this._LoginType =  LoginType.Phone 
	local bodyJson = {}
	bodyJson['phone'] = EginUser.Instance.phoneNum
	bodyJson['device_id']  =  "unity_" .. EginUser.Instance.device_id
	bodyJson['phonecode'] = EginUser.Instance.phonecode 
	bodyJson['agent_id'] = Utils.Agent_Id;

	local loginJson = {}
	loginJson['type'] = 'AccountService'
	loginJson['tag'] = 'mobile_oauth'
	loginJson['body'] = bodyJson
	Util.SendPackage(cjson.encode(loginJson))
 end


--获取手机验证码
function this.Send_Phone_IdentifyCode()
	print('>>>>>>>>>>>>>>>>>>   Send_Phone_IdentifyCode')
	local tBody = {}
	tBody['phone'] = EginUser.Instance.phoneNum
	local loginJson = {}
	loginJson['type'] = 'AccountService'
	loginJson['tag'] = 'send_mobile_sms'
	loginJson['body'] = tBody
	Util.SendPackage(cjson.encode(loginJson))
end