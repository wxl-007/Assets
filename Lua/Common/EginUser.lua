
local this = LuaObject:New()
EginUser = this

-- const
this.GFname = 'GFname'
this.WFname = "WFname"
this.GFname1 = "GFname1"
this.WFname1 = "WFname1"
this.GameIP = "GameIP"
this.WebIP = "WebIP"
this.GameIPUsers = "GameIPUsers"
this.WebIPUsers = "WebIPUsers"

this._GFname = function ()
	return this.ObtainFullKey(GFname)
end
this._WFname = function ()
	return this.ObtainFullKey(WFname)
end
this._GFname1 = function ()
	return this.ObtainFullKey(GFname1)
end
this._WFname1 = function ()
	return this.ObtainFullKey(WFname1)
end
this._GameIP = function ()
	return this.ObtainFullKey(GameIP)
end
this._WebIP = function ()
	return this.ObtainFullKey(WebIP)
end

this._WebIPUsers =function ( )
	return this.ObtainPlatformKey(WebIPUsers)
end
this._GameIPUsers =function ( )
    return this.ObtainPlatformKey(GameIPUsers)
end


function this._GameIPForCurUser()
	
	local tUserNameStr = UnityEngine.PlayerPrefs.GetString(this._GameIPUsers)
	 
	local tOtherGameIp = ''
	if  string.find(tUserNameStr,','..this.Instance.username..',') == true  then
		tOtherGameIp = UnityEngine.PlayerPrefs.GetString(this._GameIP)
	else
		local tIndex = 1
		local tUserNames = {}
		for i=1,string.len(tUserNameStr) do 
			if string.sub(tUserNameStr,i,i) == ',' then
				local tStr = string.sub(tUserNameStr,tIndex,i-1)
				table.insert( tUserNames,tStr)
				tIndex = i+1 
			elseif i == string.len(tUserNameStr) then
				local tStr = string.sub(tUserNameStr,tIndex)
				table.insert( tUserNames,tStr)
			end
		end
		if tUserNames == nil or #tUserNameStr <1 then
			return ''
		end
		local tCurUserName = this.Instance.username
		 this.Instance.username = tCurUserName[#tCurUserName]
		tOtherGameIp = UnityEngine.PlayerPrefs.GetString(this._GameIP)
		this.Instance.username = tCurUserName
	end
	return tOtherGameIp
end
-- lua  无引用
function this.AddGameIPUsers( pEncryptedIpStr)
	if pEncryptedIpStr ~= nil then 
		if this.Instance.username == '' or  this.Instance.username == nil then
			return
		end
		UnityEngine.PlayerPrefs.SetString(this._GameIP,pEncryptedIpStr)
		UnityEngine.PlayerPrefs.Save()
		this.AddGameIPUsers(nil)
	else
		local tUserName = this.Instance.username ..','
		local tUserNameStr = UnityEngine.PlayerPrefs.GetString(this._GameIPUsers,'')
		local tComma = 1
		for i =1,string.len(tUserNameStr) do 
			if string.sub(tUserNameStr,i,i) == ',' then
				tComma = i
			end
		end

		if string.sub(tUserNameStr,tComma+1) ==tUserName then
			return 
		end   

		if tUserNameStr == '' or tUserNameStr == nil then
			tUserNameStr = ',' .. tUserName
		else
			tUserNameStr = string.gsub(tUserNameStr,','..tUserName,',')..tUserName
			
		end
		UnityEngine.PlayerPrefs.SetString(this._GameIPUsers,tUserNameStr) 
		UnityEngine.PlayerPrefs.Save()
	end
end

function this._WebIPForCurUser()
	local tUserNameStr = UnityEngine.PlayerPrefs.GetString(this._WebIPUsers)
	 
	local tOtherWebIP = ''
	if string.find(tUserNameStr,','..this.Instance.username..',')~= nil  then
		tOtherWebIP = UnityEngine.PlayerPrefs.GetString(this._WebIP)
	else
		local tIndex = 1
		local tUserNames = {}
		for i=1,string.len(tUserNameStr) do 
			if string.sub(tUserNameStr,i,i) == ',' then
				local tStr = string.sub(tUserNameStr,tIndex,i-1)
				table.insert( tUserNames,tStr)
				tIndex = i+1 
			elseif i == string.len(tUserNameStr) then
				local tStr = string.sub(tUserNameStr,tIndex)
				table.insert( tUserNames,tStr)
			end
		end
		if tUserNames == nil or #tUserNameStr <1 then
			return ''
		end

		local tCurrentUserName = this.Instance.username
		this.Instance.username = tUserNames[#tUserNames]
		local tOtherWebIP = UnityEngine.PlayerPrefs.GetString(this._WebIP)
		this.Instance.username = tCurrentUserName
	end
	return tOtherWebIP
end

function this.AddWebIPUsers(pEncryptedIPStr)
	if pEncryptedIpStr ~= nil then 
		if this.Instance.username == '' or  this.Instance.username == nil then
			return
		end
		UnityEngine.PlayerPrefs.SetString(this._WebIP,pEncryptedIpStr)
		UnityEngine.PlayerPrefs.Save()
		this.AddGameIPUsers(nil)
	else
		local tUserName = this.Instance.username ..','
		local tUserNameStr = UnityEngine.PlayerPrefs.GetString(this._WebIPUsers,'')
		local tComma = 1
		for i =1,string.len(tUserNameStr) do 
			if string.sub(tUserNameStr,i,i) == ',' then
				tComma = i
			end
		end

		if string.sub(tUserNameStr,tComma+1) ==tUserName then
			return 
		end   

		if tUserNameStr == '' or tUserNameStr == nil then
			tUserNameStr = ',' .. tUserName
		else
			tUserNameStr = string.gsub(tUserNameStr,','..tUserName,',')..tUserName
		end
		UnityEngine.PlayerPrefs.SetString(this._WebIPUsers,tUserNameStr) 
		UnityEngine.PlayerPrefs.Save()
	end
end




this.Instance = this 

this.uid = ''
this.nickname = ''
this.level = 0
this.vipLevel = 0
this.levelExp = 0
this.nextLevelExp = 0
this.avatarNo = 0
this.avatarUrl = ''
this.sex = ""  
--Save Info
this.username = ''
this.password = ''
this.session = ''
this.weekPassword =false 
-- Change Info
this.bagMoney = ''
this.bankMoney = ''
this.goldIngot = ''
this.goldCoin = ''
this.happyCard = ''
this.mailCount = 0

this.device_id = UnityEngine.SystemInfo.deviceUniqueIdentifier;

this.agentID = ''
-- Other
this.isGuest= false 
this.win_times= 0 
this.lost_times= 0  
--账号安全相关信息
this.email= "" 
this.phone= "" 
this.cert_no= ""
this.star= 0 
this.wechat=""
this.qq=""

--微信登录需要的数据
this.wxOpenId =''
this.wxNickname = ''
this.wxSex = 0
this.wxUnionId = ""
this.wechat_id = ""
this.telephone = ""
this.eBankLoginType = {['PASSWORD'] = 'PASSWORD', ['PHONE_AUTH']='PHONE_AUTH', ['PHONE_CODE']='PHONE_CODE', ['WECHAT']='WECHAT'}

this.bankLoginType = this.eBankLoginType.PASSWORD
this.bankBindPhone = 0 --银行是否绑定手机
this.wechat_lock = 0 --银行是否绑定微信
this.device_lock = 0 --绑定本设备 0未绑定 1绑定
--手机登录时候 需要的数据 手机号 
this.phoneNum =''

--此账号是否绑定了手机 0=没绑  1=绑定
this.bindPhone = 0;  

local EginUser_CS = luanet.import_type('EginUser')


function this:InitUserWithDict(pDic,pSessionArg)
	
	local pDic = cjson.decode(pDic)
	
    if pDic["id"]==nil then pDic["id"] = pDic["userid"] end
    if pDic["exp"]==nil then pDic["exp"] = pDic["exp_value"] end
    if pDic["next_exp"]==nil then pDic["next_exp"] = pDic["exp_value"] end
    if pDic["avatar_img"]==nil then pDic["avatar_img"] = "" end
    if pDic["agent"]==nil then pDic["agent"] = "" end
    if pDic["weak"]==nil then pDic["weak"] = "0" end
    if pDic["gold_money"]==nil then pDic["gold_money"] = "0" end
	print('===============*********=============Init user with dict ')


	EginUser_CS.Instance:InitUserWithDict_JsonStr(cjson.encode(pDic),pSessionArg)

	
	this.uid = tostring(pDic['id'])   
	this.nickname = System.Text.RegularExpressions.Regex.Unescape( tostring(pDic['nickname']))
	this.level = tonumber(pDic['level'])
	this.vipLevel = tonumber(pDic['vip_level'])
	this.sex = tostring(pDic['sex'])  
	this.levelExp = tonumber(pDic['exp'])
	this.nextLevelExp = tonumber(pDic['next_exp'])
	this.avatarUrl = pDic['avatar_img']
	this:UpdateAvatarNo(tonumber(pDic['avatar_no']))
	if pDic['agent'] ~= nil then
		this.agentID = pDic['agent']
	else
		this.agentID = nil 
	end


	this.username = pDic['username']
	this.password = pDic['password']
	--lxtd004
	if  UnityEngine.PlayerPrefs.GetString("LoginType",'') == 'WeChat' then 
		print('------------------------- save  username ')
		
		UnityEngine.PlayerPrefs.SetString("AutoUsername",this.username)
		UnityEngine.PlayerPrefs.SetString(this.username, this.wxUnionId)
		print(this.username ..' =======  '.. this.wxUnionId)
		UnityEngine.PlayerPrefs.Save()
	end
	

	this.session =pSessionArg
	this.weekPassword = 1== tonumber(pDic['weak'])
	this.bagMoney = tostring(pDic['bag_money']) 
	this.bankMoney = tostring(pDic['bank_money'])
	this.goldIngot = tostring(pDic['dollar_money'])
	this.goldCoin = tostring(pDic['gold_money'])
	this.happyCard = tostring(pDic['happycard'])
	this.wechat_id = tostring(pDic['wechat_id'])
	this.telephone = tostring(pDic['telephone'])
	if pDic['gfname']  ~= nil then
		UnityEngine.PlayerPrefs.GetString(this._GFname,pDic['gfname'])
	end
	if pDic['wfname']  ~= nil then
		UnityEngine.PlayerPrefs.GetString(this._WFname,pDic['wfname'])
	end
	if pDic['gfname1']  ~= nil then
		UnityEngine.PlayerPrefs.GetString(this._GFname1,pDic['gfname1'])
	end
	if pDic['wfname1']  ~= nil then
		UnityEngine.PlayerPrefs.GetString(this._WFname1,pDic['wfname1'])
	end
	this.win_times= tonumber(pDic['win_times'])
	this.lost_times= tonumber(pDic['lost_times'])

    --error("pDic['locked']"..pDic['locked'])
    if pDic['locked'] ~= nil then
        if pDic['locked'] == 1 or pDic['locked']=='1' then
            this.device_lock = 1
        else
            this.device_lock = 0
        end
    end

	--lxtd003 20160912  add --->
    --error("pDic['wechat_lock']"..pDic['wechat_lock'])
    --error("pDic['bank_validate']"..pDic['bank_validate'])
    if pDic['wechat_lock'] ~= nil then
        if pDic['wechat_lock'] == 1 or pDic['wechat_lock']=='1' then
            this.wechat_lock = 1
        else
            this.wechat_lock = 0
        end
    end

	if pDic['bank_validate'] ~= nil then
		if pDic['bank_validate'] == 2 or pDic['bank_validate']=='2' then
			this.bankLoginType = this.eBankLoginType.PHONE_AUTH
            this.bankBindPhone = 0
		elseif pDic['bank_validate'] == 1 or pDic['bank_validate']=='1' then
			this.bankLoginType = this.eBankLoginType.PHONE_CODE
            this.bankBindPhone = 1
        else
            this.bankBindPhone = 0
            --error("pDic['wechat_lock'] ".. pDic['wechat_lock']);
			if pDic['wechat_lock'] ~= nil then
				if pDic['wechat_lock'] == 1 or pDic['wechat_lock']=='1' then
					this.bankLoginType = this.eBankLoginType.WECHAT
				else
					this.bankLoginType = this.eBankLoginType.PASSWORD
				end
			else
				this.bankLoginType =this.eBankLoginType.PASSWORD
			end
		end
	end
	----<-----

	if pDic["validate_mobile"] ~= nil then
		if pDic['validate_mobile'] == 0 or pDic['validate_mobile']=='0' then
			this.bindPhone = 0;
		else
			this.bindPhone = 1;
		end
	end

	UnityEngine.PlayerPrefs.Save()
end


function this:InitGuestWithDict(pDic,pSessionArg)
	pDic['exp'] = '0'
	pDic['next_exp'] = '1000'
	pDic['weak'] = '0'
	pDic['gold_money'] = '0'
	pDic['happycard'] = '0'
	this:InitUserWithDict(pDic,pSessionArg)
end

function this:UpdateAvatarNo( pTempNo )
	print('pTempNo   ===='.. pTempNo)
	EginUser_CS.Instance:UpdateAvatarNo_JsonStr(tostring(pTempNo))
	if tonumber(pTempNo) <=0 or tonumber(pTempNo) >20 then
		pTempNo =2
	end
	this.avatarNo = pTempNo 
	--this.sex = this.avatarNo%2 ==0
end

function this:UpdateUserWithDict( pDic )
	EginUser_CS.Instance:UpdateUserWithDict_JsonStr(cjson.encode(pDic))

	local tHasUid = false 
	if PlatformGameDefine.playform.IsSocketLobby then
		tHasUid = tostring(this.uid) == tostring(pDic['userid'])
	else
		tHasUid = tostring(this.uid) == tostring(pDic['id'])
	end
	-- print('===========in update user ======')
	-- print(tHasUid)
	if tHasUid then
		-- print('************inininininini')
		this.level = tonumber(pDic['level'])
		this.vipLevel = tonumber(pDic['vip_level'])
		this.wechat_id = tostring(pDic['wechat_id'])
		this.telephone = tostring(pDic['telephone'])
		log("========this.telephone======="..this.telephone)
		if PlatformGameDefine.playform.IsSocketLobby then
			this.levelExp = tonumber(pDic['exp_value'])
		else
			this.levelExp = tonumber(pDic['exp'])
		end
		if pDic['next_exp'] ~= nil then 
			this.nextLevelExp = tonumber(pDic['next_exp'])
		else
			this.nextLevelExp = this.levelExp +100
		end
		this.avatarNo = tonumber(pDic['avatar_no'])
		if pDic['avatar_img'] ~= nil then
			this.avatarUrl = pDic['avatar_img']
		end
		--this.sex = this.avatarNo%2 ==0
		this.sex = tostring(pDic['sex'])  
		this.bagMoney = tostring(pDic['bag_money']) 
		this.goldIngot = tostring(pDic['dollar_money'])
        this.bankMoney = tostring(pDic['bank_money'])
		if pDic['gold_money'] ~= nil then
			this.goldCoin = tostring(pDic['gold_money'])
		end
		this.happyCard = tostring(pDic['happycard'])

        --error("pDic['locked']"..pDic['locked'])
        if pDic['locked'] ~= nil then
            if pDic['locked'] == 1 or pDic['locked']=='1' then
                this.device_lock = 1
            else
                this.device_lock = 0
            end
        end

        if pDic['wechat_lock'] ~= nil then
            if pDic['wechat_lock'] == 1 or pDic['wechat_lock']=='1' then
                this.wechat_lock = 1
            else
                this.wechat_lock = 0
            end
        end
		if pDic['bank_validate'] ~= nil then
			if pDic['bank_validate'] == 2 or pDic['bank_validate']=='2' then
				this.bankLoginType = this.eBankLoginType.PHONE_AUTH
                this.bankBindPhone = 0
			elseif pDic['bank_validate'] == 1 or pDic['bank_validate']=='1' then
				this.bankLoginType = this.eBankLoginType.PHONE_CODE
                this.bankBindPhone = 1
            else
                this.bankBindPhone = 0
				if pDic['wechat_lock'] ~= nil then
					if pDic['wechat_lock'] == 1 or pDic['wechat_lock']=='1' then
						this.bankLoginType = this.eBankLoginType.WECHAT
					else
						this.bankLoginType = this.eBankLoginType.PASSWORD
					end
				else
					this.bankLoginType =this.eBankLoginType.PASSWORD
				end
			end

		end

		if pDic["validate_mobile"] ~= nil then
			if pDic['validate_mobile'] == 0 or pDic['validate_mobile']=='0' then
				this.bindPhone = 0;
			else
				this.bindPhone = 1;
			end
		end

		if pDic['gfname']  ~= nil then
			UnityEngine.PlayerPrefs.GetString(this._GFname,pDic['gfname'])
		end
		if pDic['wfname']  ~= nil then
			UnityEngine.PlayerPrefs.GetString(this._WFname,pDic['wfname'])
		end
		if pDic['gfname1']  ~= nil then
			UnityEngine.PlayerPrefs.GetString(this._GFname1,pDic['gfname1'])
		end
		if pDic['wfname1']  ~= nil then
			UnityEngine.PlayerPrefs.GetString(this._WFname1,pDic['wfname1'])
		end
		UnityEngine.PlayerPrefs.Save()
	end
end

function this:Logout(  )
	EginUserUpdate.Instance.UpdateInfoStop()
	this.isGuest = false 
	this.uid = ''
	this.username = ''
	this.password = ''
	this.session  = ''
    this.bankBindPhone = 0 --重置银行是否绑定手机
    this.wechat_lock = 0   --重置银行是否绑定微信
    this.device_lock = 0 --重置设备绑定信息
	Module_Bank:clearCachePwd();
end

function this.ObtainFullKey(pKey)
	local tResult =this.username..pKey..PlatformGameDefine.playform.PlatformName
	return tResult
end
function this.ObtainPlatformKey( pKey )
	local tResult = pKey .. PlatformGameDefine.playform.PlatformName
	return tResult
end
