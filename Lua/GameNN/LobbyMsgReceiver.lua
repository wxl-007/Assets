local cjson = require "cjson"
local this = LuaObject:New()
LobbyMsgReceiver = this 
local isMsgReceiver = true;
this.messageBody = nil;
function this.Awake()
    
end


function this.Start ()
    --按钮事件监听
    --this.mono:AddClick(this.transform:FindChild("Offset/Views/Get/SafeValidate/Input_PhoneCode/Button_Send").gameObject, this.OnClickSendPhoneCode,this)
  
    -----游戏逻辑
    GameObject.DontDestroyOnLoad(this.gameObject);
    if (PlatformGameDefine.playform.IsSocketLobby) then
        --this.mono:StartSocket(false);
    end
    this.tipPanel = this.transform:FindChild("messagePanel").gameObject;
    this.tipLb    = this.tipPanel.transform:FindChild("bg/msg"):GetComponent("UILabel");
    this.tipPanel:SetActive(false);
end

function this:StartReadMsg()
   this:StopReadMsg();
    this.refCoroutine = coroutine.start(this.readLobbyMsg);
end
function this:StopReadMsg()
    if(this.refCoroutine ~= nil)then
        coroutine.Stop(this.refCoroutine);
        this.refCoroutine = nil;
    end 
end
function this.readLobbyMsg()
	if PlatformLua.playform.isMsgReceiver then
        --{'tag': ‘post_message’, 'type': 'AccountService', 'body': {‘content’: 消息内容}}
        --local json1 = {type="AccountService",tag="post_message",body={content="这是一条测试消息3."}};
        --this.mono:SocketSendMessage(cjson.encode(json1))
        while(this.mono) do
            --local json1 = {type="AccountService",tag="post_message",body={content="这是一条测试消息123456."}};
            --if(this.mono) then this.mono:SocketSendMessage(cjson.encode(json1)); end
            local json = {type="AccountService",tag="read_messages",body={}};
            if(this.mono) then this.mono:SocketSendMessage(cjson.encode(json),1) end
            coroutine.wait(7);
        end
    end
    
end

function this:clearLuaValue()
    this.mono = nil;
    this.gameObject = nil;
    this.transform  = nil;
    LobbyMsgReceiver = nil;
    LuaGC()
    
end

function this:startSocket()
    this.mono:StartSocket(false);
    this:StartReadMsg()
end

function this.OnDisable()

end
function this:OnDestroy()
    this:clearLuaValue()
end


function this.SocketDisconnect ( disconnectInfo)
    -- SocketManager.LobbyInstance.socketListener = nil;
end

function this.SocketReceiveMessage( message)
    local messageObj = cjson.decode(message);
    local type = tostring(messageObj["type"]);
    local tag = tostring(messageObj["tag"]);
    
    if(type == "AccountService") then
        if(tag == "read_messages") then
           -- {"body": [{"status": 1, "content": "这是一条测试消息.", "user_id": 889657154, "msg_type": 0, 
    --"left_time": 1482395165.04, "timeout": 1800, "send_time": 1482393365.04, "position": 0}], 
    --"tag": "read_messages", "type": "AccountService", "result": "ok"}

            if( this.addmessageBody(messageObj["body"]))then
                coroutine.start(this.showTip);
                
            end
        end
    end
end

function this.showTip(tipStr)
    tipStr = this.messageBody[#this.messageBody]["content"];
    UnityEngine.PlayerPrefs.SetString("lobbyMsg", tipStr);
	UnityEngine.PlayerPrefs.Save();

    this.tipPanel:SetActive(true);
    this.tipLb.text = tipStr;
    coroutine.wait(5);
    this.tipPanel:SetActive(false);
end

function this.addmessageBody(body) 
    if(#body == 0)then
        return false;
    end
   if this.messageBody == nil then --本地没有存消息时会走到这来
        this.messageBody = body;
        UnityEngine.PlayerPrefs.SetString("lobbyMsgList", cjson.encode(this.messageBody) );
        UnityEngine.PlayerPrefs.Save();
        return true;
   else
        local hasChanged = false;
        for i=1,#body do
            if tonumber(body[i]["create_time"]) > tonumber(this.messageBody[#this.messageBody]["create_time"]) then
                table.insert( this.messageBody, body[i] );
                hasChanged = true;
            end
            if(#this.messageBody > 5)then
                table.remove( this.messageBody,1 );
            end
        end
        if(hasChanged)then
            UnityEngine.PlayerPrefs.SetString("lobbyMsgList", cjson.encode(this.messageBody) );
            UnityEngine.PlayerPrefs.Save();
        end
        return hasChanged;
        --[[if tonumber(this.messageBody[1]["create_time"]) < tonumber(body[1]["create_time"]) then
             this.messageBody = body;
            return true;
        else
            return false;
        end]]
   end
end
