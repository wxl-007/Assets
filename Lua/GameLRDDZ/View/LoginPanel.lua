
LoginPanel = {}
local self = LoginPanel

local transform
local gameObject

function LoginPanel.Awake(obj)
	log("LoginPanel.Awake--->>");
	gameObject = obj
    transform = obj.transform
    self.IsRememberPWD =true
	self.IsAutoLogin = true
    self.Init()
end 
--初始化
function LoginPanel.Init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');

	--输入
	self.kUsername = transform:FindChild("Login/zhanghaoBg"):GetComponent("UIInput");
	self.kPassword = transform:FindChild("Login/mimaBg"):GetComponent("UIInput");
	--btn
	self.loginBtn =  transform:FindChild("Login/LoginBtn").gameObject 
	self.youkeBtn =  transform:FindChild("Login/youkeBtn").gameObject 
	self.registerBtn =  transform:FindChild("Login/RegisterBtn").gameObject 
	self.jizhuBtn = transform:FindChild("Login/jizhubox").gameObject
	self.zidongBtn = transform:FindChild("Login/zidongbox").gameObject

	self.behaviour:AddClick(self.loginBtn,self.Test)  --登录
	self.behaviour:AddClick(self.youkeBtn,self.YouKeCallBack)  --游客登录
	self.behaviour:AddClick(self.registerBtn,self.RegisterCallBack)  --注册
	self.behaviour:AddClick(self.jizhuBtn,self.RememberPWD) --记住密码
	self.behaviour:AddClick(self.zidongBtn,self.AutoLogin)	--自动登陆

	LRDDZ_MusicManager.instance:setMusicState(true)
	LRDDZ_MusicManager.instance:setEffectState(true)
	LRDDZ_MusicManager.instance:Init() --初始化音乐管理器


end 
function LoginPanel.Test()
	coroutine.start(self.LoginCallBack);
end
function LoginPanel.LoginCallBack()
	--LoadSceneAsync.LoadSceneAsync(SceneName.ChoiceRole)
	local form = UnityEngine.WWWForm.New();
	form:AddField("username",self.kUsername.value);
	form:AddField("password",self.kPassword.value);
	form:AddField("device_id", "unity_" .. UnityEngine.SystemInfo.deviceUniqueIdentifier);
	 local www = HttpConnect.Instance:HttpRequest(ConnectDefine.LOGIN_URL, form);
    coroutine.www(www);
    local result = HttpConnect.Instance:UserLoginResult(www);
    if result.resultType == HttpResult.ResultType.Sucess then
    	--进入游戏
    	Avatar.Init();
    	LoadSceneAsync.LoadSceneAsync(SceneName.Main);

    end
    
end 
function LoginPanel.YouKeCallBack()
	LoadSceneAsync.LoadSceneAsync(SceneName.ChoiceRole)
end 
function LoginPanel.RegisterCallBack()

end 
function LoginPanel.RememberPWD()
	local tg_remPWD = transform:FindChild("Login/jizhubox"):GetComponent("UIToggle");
	self.IsRememberPWD = tg_remPWD.value;
end
function LoginPanel.AutoLogin()
	local tg_autoLogin = transform:FindChild("Login/zidongbox"):GetComponent("UIToggle");
	self.IsAutoLogin = tg_autoLogin.value;
end
