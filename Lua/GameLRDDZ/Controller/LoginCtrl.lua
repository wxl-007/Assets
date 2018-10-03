
LoginCtrl = {};
local self = LoginCtrl;
--构建函数--
function LoginCtrl.New()
	return self;
end

function LoginCtrl.Awake()
	LRDDZ_ResourceManager.Instance:CreatePanel('LoginPanel','LoginPanel', true,self.OnCreate);
end 
function LoginCtrl.OnCreate()
end 