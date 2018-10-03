
local this = LuaObject:New()
HttpConnect = this

this.Instance = this

function this:HttpRequestAli( pUrl )
	EginTools.Log(pUrl)
	local www = UnityEngine.WWW.New(pUrl)
	return www 
end

function this:HttpRequest( pUrl,pForm )
	EginTools.Log(pUrl)
	if pForm == nil then
		pForm = UnityEngine.WWWForm.New();
	end
	if pForm ~= nil then
		local tMs = EginTools.nowMinis()
		local tMms = tMs + EginTools.localBeiJingTime
		local tCcode = EginTools.encrypTime(tostring(tMms))
		pForm:AddField('client_code',tCcode)
	end
	local www = nil 
	if pForm == nil then
		www = UnityEngine.WWW.New(pUrl)
	else
		www = UnityEngine.WWW.New(pUrl,pForm)
	end
	return www
end

function this:HttpRequestWithSession( pUrl,pForm )
	EginTools.Log(pUrl)
	local tCookie =nil 
	if EginUser.Instance.session  ~= nil then
		tCookie = EginUser.Instance.session 
	else
		tCookie = ''
	end

	local tRequestHeaders = {}
	tRequestHeaders['Cookie'] = tCookie

	local tHeaders = {}
	tHeaders['Cookie'] = tCookie

	if pForm ==nil then
		pForm = UnityEngine.WWWForm.New()
		pForm:AddField('Cookie',tCookie)
	end
	if pForm ~= nil then
		local tMs = EginTools.nowMinis()
		local tMms = tMs + EginTools.localBeiJingTime
		local tCcode = EginTools.encrypTime(tostring(tMms))
		pForm:AddField('client_code',tCcode)
	end

	local www = Util.GetWWW(pUrl,pForm,tHeaders)   --UnityEngine.WWW.New(pUrl,pForm.data,tHeaders)

	return www
end

-----------Login  ------------

function this:BaseResult( pWWW,pIsSwitchUrl)
	print('******************************BaseResult   Enter  ')
	if pIsSwitchUrl == nil then
		pIsSwitchUrl = true 
	end

	local tResult = HttpResult:New()
	if pWWW.error ~= nil then
		EginTools.Log('Http Failed ====='..pWWW.error)
		if pIsSwitchUrl then
			PlatformGameDefine.playform:swithWebHostUrl(true,Utils.NullObj)
			tResult.isSwitchHost = true
		end
		tResult.resultObject = ZPLocalization.Instance:Get('HttpConnectError')
	else
		local tTempResultStr = Util.SetTrim(pWWW.text)--pWWW.text:Trim()
		EginTools.Log('base ::: '..tTempResultStr)
		local tResultObj =  cjson.decode(tTempResultStr) 
		-- print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
		-- print(tResultObj)
		-- print(tResultObj['result'])
		-- local tResultObj = JSONObject:New(tTempResultStr) 
		-- if tResultObj.type == JSONObject.Type.NULL then
		-- 	if pIsSwitchUrl then
		-- 		PlatformGameDefine.platform:swithWebHostUrl() 
		-- 		tResult.isSwitchHost = true
		-- 	end
		-- 	tResult.resultObject = ZPLocalization.Instance:Get("HttpConnectError")
		-- else
			local tResultType = nil 
			if tResultObj then 
				if tResultObj['result'] ~= nil then
					tResultType = tResultObj['result']
				end
				if tResultType == 'ok' then
					tResult.resultObject = tResultObj['body']
					tResult.resultType = HttpResult.ResultType.Sucess
				else
					if tResultObj['body'] ~= nil then
						tResult.resultObject = System.Text.RegularExpressions.Regex.Unescape(tResultObj['body'])
					else
						tResult.resultObject = nil
					end
				end
			else
				if pIsSwitchUrl then
					PlatformGameDefine.playform:swithWebHostUrl(true,Utils.NullObj) 
					tResult.isSwitchHost = true
				end
				tResult.resultObject = ZPLocalization.Instance:Get("HttpConnectError")
				print("解析出错了---HttpConnect.lua -- 102")
			end
		-- end
	end
	return tResult
end

--	/* ------ Register ------ */
function this:RegisterResult( pWWW )

	local tResult = HttpResult:New()
	if pWWW.error ~= nil then
		EginTools.Log('Http Failed: '..pWWW.error)
	else
		local tTempResultStr = Util.SetTrim(pWWW.text) --.Trim()
		EginTools.Log(tTempResultStr)
		if tTempResultStr == 'ok' then
			tResult.resultType = HttpResult.ResultType.Sucess
		elseif string.len(tTempResultStr)>0 then
			local tResultObj = cjson.decode(tTempResultStr)
			-- local tResultObj = JSONObject:New(tTempResultStr)
			-- if tResultObj.type == JSONObject.Type.NULL then
			-- print('----------------------------')
			print(tResultObj)
			if tResultObj==nil then
				tResult.resultObject = System.Text.RegularExpressions.Regex.Unescape(tTempResultStr)
			else
				tResult.resultObject = System.Text.RegularExpressions.Regex.Unescape(tResultObj['error'])
			end
		else
			tResult.resultObject = ZPLocalization.Instance:Get('HttpConnectError')
		end
	end
	return tResult
end

function this:UserLoginResult( pWWW )
	local tResult = this:BaseResult(pWWW)
	if HttpResult.ResultType.Sucess == tResult.resultType then
		local tSession = ''
		if pWWW.responseHeaders['SET-COOKIE'] ~= nil  then
			tSession = pWWW.responseHeaders['SET-COOKIE']
		end
		local tResultDict = tResult.resultObject 
		printf(tResultDict)
		-- print('================================fill the dic  ')
		EginUser.Instance:InitUserWithDict(cjson.encode(tResultDict), tSession);
		EginUser.Instance.isGuest = false
	end
	return tResult
end

function this:GuestLoginResult( pWWW )
	local tResult  = this:UserLoginResult(pWWW)
	return tResult
end

function this:UpdateUserinfoResult( pWWW)
	local tResult = this:BaseResult(pWWW)
	-- print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UpdateUserinfoResult')
	-- print(tResult)
	if HttpResult.ResultType.Sucess == tResult.resultType then
		local tResultObj = tResult.resultObject
		EginUser.Instance:UpdateUserWithDict(tResultObj)
	end
	return tResult
end

function this:RoomListResult( pWWW )
	local tResult = this:BaseResult(pWWW)
	if HttpResult.ResultType.Sucess == tResult.resultType then
		local tResultObj = tResult.resultObject
		local tRoomList = {}
		for k,v in tResultObj do
			local tRoom = GameRoom.New(v)
			table.insert(tRoomList ,tRoom)
		end
		tResult.resultObject = tRoomList

	end
	return tResult
end

function this:GiftNicknameResult( pWWW)
	local tResult = this:BaseResult(pWWW)
	if HttpResult.ResultType.Sucess == tResult.resultType then
		tResult.resultObject = System.Text.RegularExpressions.Regex.Unescape(tResult.resultObject)
	end
	return tResult
end

function this:BaseResultSocket(pWWW)
	local tResult = HttpResult:New()
	if pWWW.error ~= nil then
		EginTools.Log('Http Failed ======='..pWWW.error)
		PlatformGameDefine.playform:swithWebHostUrl(true,Utils.NullObj)
	else
		local tTempResultStr = Util.SetTrim(pWWW.text)-- pWWW.text.Trim()
		
		EginTools.Log("base socket::: " ..tTempResultStr)
		-- local tResultObj = JSONObject:New(tTempResultStr)
		 local tResultObj = tTempResultStr
		if tResultObj then
			tResult.resultObject = tResultObj 
			tResult.resultType = HttpResult.ResultType.success
		else
			print("解析出错了---HttpConnect.cs -- 60")
		end
	end
	return tResult
end


function this:BaseResultSocket2(pWWW)
	local tResult = HttpResult:New()
	if pWWW.error ~= nil then
		EginTools.Log('Http Failed : '..pWWW.error)
		PlatformGameDefine.playform:swithWebHostUrl(true,Utils.NullObj)
	else
		local tTempResultStr =Util.SetTrim(pWWW.text)
		EginTools.Log(tTempResultStr)
		if tTempResultStr == 'ok' then	
			tResult.resultType = HttpResult.ResultType.Sucess
		else		
			tResult.resultObject = ZPLocalization.Instance:Get('HttpConnectError')
		end
	end
	return tResult
end
