
local this = LuaObject:New()
Module_Channel = this
this.Instance = this
this.isNewRigister = false


function this:handleReg()
    --蛋蛋赚
    if (Utils.Agent_Id == "3529" or Utils.Agent_Id =="3539") and PlatformGameDefine.playform:GetPlatformPrefix()=="131" then
         print("channel handleReg 1 ")  
        this.isNewRigister = true
        UnityEngine.PlayerPrefs.SetString("newreg","1")
        UnityEngine.PlayerPrefs.Save()
    end
end

--蛋蛋赚渠道调用c注册接口
function this:handleGetAccount()
 
end

--绑定手机后才掉用蛋蛋赚渠道注册接口
function this:handleBindPhoneGetAccount()
    local tIsNewReg = UnityEngine.PlayerPrefs.GetString("newreg")
    if tIsNewReg ~= nil and tIsNewReg == "1" then
        print("channel is handleBindPhoneGetAccount "..Utils.Agent_Id..PlatformGameDefine.playform:GetPlatformPrefix()) 
        if  (Utils.Agent_Id == "3529" or Utils.Agent_Id =="3539") and PlatformGameDefine.playform:GetPlatformPrefix()=="131" then
            coroutine.start(this.doPostReg,this);
        end
    else
        print("channel not is newreg")     
    end
end

function this:doPostReg()
    print("channel is handleBindPhoneGetAccount "..Utils.Agent_Id..PlatformGameDefine.playform:GetPlatformPrefix()..PhoneSdkUtil.getImei()) 
    this.isNewRigister = false
    if UnityEngine.PlayerPrefs.HasKey("newreg") then
        UnityEngine.PlayerPrefs.DeleteKey("newreg");
    end
    local tAdid = "Xmv8Y7GD4eQ="
    local tKey  = "q9w2eb4n2yg6it7yr5"
    local tForm = UnityEngine.WWWForm.New()
    local tImei = PhoneSdkUtil.getImei()
    tForm:AddField("merid", EginUser.Instance.uid)
    tForm:AddField("mername",EginUser.Instance.username)
    tForm:AddField("devid", tImei)
    tForm:AddField("simid", "")
    tForm:AddField("adid",tAdid)
    local tLoginType = "2"
    if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
        tLoginType = "1"
    end
    tForm:AddField("logintype",tLoginType)
    tForm:AddField("key",tKey)
    local tKeyCode = EginUser.Instance.uid..EginUser.Instance.username..tImei..tAdid..tLoginType..tKey
    tKeyCode = EginTools.MD5Coding(tKeyCode);
    tForm:AddField("keycode",tKeyCode)
    local www = HttpConnect.Instance:HttpRequest("http://service.dandanz.com/WebService/mer/AdAppDownloadBack.aspx",tForm)
    coroutine.www(www)
    print("dandanchanle reg backmsg:"..www.text)
end

--蛋蛋赚渠道调用cpl接口 游戏胜利10局
function this:handleCpl()
    print("channel is doPostCpl 0" )  
    if  (Utils.Agent_Id == "3529" or Utils.Agent_Id =="3539") and PlatformGameDefine.playform:GetPlatformPrefix()=="131" then
         print("channel is doPostCpl 1" )  
        coroutine.start(this.doPostCpl,this);
    end
end

function this:doPostCpl()
    print("channel is doPostCpl 2" )  
    this.isNewRigister = false
    local tAdid = "Xmv8Y7GD4eQ="
    local tKey  = "q9w2eb4n2yg6it7yr5"
    local tImei = PhoneSdkUtil.getImei()
    local tForm = UnityEngine.WWWForm.New()
    tForm:AddField("adid",tAdid)
    tForm:AddField("devid", tImei)
    tForm:AddField("merid", EginUser.Instance.uid)
    tForm:AddField("GameLevel", EginUser.Instance.level)
    tForm:AddField("AwardType", 1)
    tForm:AddField("AwardGroup", 1)   
    local tLoginType = "2"
    if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
        tLoginType = "1"
    end
    local tKeyCode = EginUser.Instance.uid..EginUser.Instance.username..tImei..tAdid..tLoginType..tKey
    tKeyCode = EginTools.MD5Coding(tKeyCode);
    tForm:AddField("KeyCode",tKeyCode)
    local www = HttpConnect.Instance:HttpRequest("http://service.dandanz.com/WebService/mer/AdAppAutoAwardBack.aspx",tForm)
    coroutine.www(www)
    print("dandanchanle reg backmsg:"..www.text)
end


function this.getNoticeMsg(pMsg)
    print(">>>>>>>>>lua get msg")
    --[[
        格式如
        {
    "" = "";
    aps =     {
        alert = "317\U901a\U77e516";
        sound = default;
    };
}--]]
    if pMsg~= nil then
        print(">>>>>>>>>get notice msg"..pMsg)
    end
end


