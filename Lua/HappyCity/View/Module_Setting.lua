
local this = LuaObject:New()
Module_Setting = this

local kTuiID;

function this:Awake()
	EginProgressHUD.Instance:HideHUD();
	kTuiID = this.transform:FindChild("Offset/Input_tuiJian/Input"):GetComponent("UIInput");
	local subBtn = this.transform:FindChild("Offset/Button_Submit").gameObject;
	this.mono:AddClick(subBtn, this.OnClickTui);
	local backBtn = this.transform:FindChild("Offset/Background Top/Button_Back - Anchor/ImageButton").gameObject;
	this.mono:AddClick(backBtn, this.OnClickBack);
end

function this:Start()
	if(EginUser.Instance.agentID ~= "-1" and EginUser.Instance.agentID ~= "" and EginUser.Instance.agentID ~= nil) then
		kTuiID.value = EginUser.Instance.agentID;
		kTuiID.enabled = false;
	end
end

function this:OnClickTui()
	if(kTuiID.enabled == true) then
		if PlatformGameDefine.playform.IsSocketLobby then
			this.mono:StartSocket(false)
			coroutine.start(this.DoClickTuiSocket)
		else
			coroutine.start(this.DoClickTui)
		end
		
	else
		EginProgressHUD.Instance:ShowPromptHUD("不允许改变推荐人");
	end
end

function this:OnClickBack()
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
    Utils.LoadLevelGUI("Hall");
end

function this.DoClickTui()
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"), false);
	local form = UnityEngine.WWWForm.New();
	form:AddField("uid", kTuiID.value);

	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.CHANGE_AGENT_URL, form);
	coroutine.www(www);
	if(this.mono == nil)then
		return;
	end
	local result = HttpConnect.Instance:RegisterResult(www);

	EginProgressHUD.Instance:HideHUD();
	if( HttpResult.ResultType.Sucess == result.resultType)then
		EginProgressHUD.Instance:ShowPromptHUD("推荐人设置成功");
	else
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
	end
end

function this:clearLuaValue()
	kTuiID = nil;

	this.mono = nil
	this.gameObject = nil
	this.transform  = nil

	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
end
------------socket connect    lxtd004 change 2016 6 13 
--[["type":AccountService,
	"tag": change_agent,
	"body":{
		'uid':推荐人ID
	}
--]]


function this.DoClickTuiSocket()
	local tSendMsg = {}
	tSendMsg['uid'] =  kTuiID.value
	this.mono:Request_lua_fun("AccountService/change_agent",cjson.encode(tSendMsg), 
        function(message)
            -- local tMsg = cjson.decode(message)
            -- if tMsg ~= nil then
            -- 	if tostring(tMsg['result']) == 'ok' then
            -- 		 EginProgressHUD.Instance:ShowPromptHUD("推荐人设置成功");
            -- 	else
            -- 		 EginProgressHUD.Instance:ShowPromptHUD(tostring(tMsg['result']))
            -- 	end
            -- end
        end, 
        function(message)
        	
        end)
	
end


function this:SocketReceiveMessage( pMessageObj )
	local msgStr = self
  	local msgData = cjson.decode(msgStr)
  	if msgStr == nil then 
  		return
  	end

  	local tType = msgData['type']
  	if tType == nil then
  		print('socket receive message  type is nil ' .. type1)
  		return
  	end

  	local tTag = msgData['tag']
  	if tType == 'AccountService' then
  		if tTag == 'change_agent' then
	  		-- local tMsg = cjson.decode(message)
	        if msgData ~= nil then
	        	if tostring(msgData['result']) == 'ok' then
	        		 EginProgressHUD.Instance:ShowPromptHUD("推荐人设置成功");
	        	else
	        		 EginProgressHUD.Instance:ShowPromptHUD(msgData['result'])
	        	end
	        end
	    end
  	end

end