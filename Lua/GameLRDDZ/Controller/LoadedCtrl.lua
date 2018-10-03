LoadedCtrl = {};
local self = LoadedCtrl;
--构建函数--
function LoadedCtrl.New()
	return self;
end

function LoadedCtrl.Awake()
	LRDDZ_ResourceManager.Instance:CreatePanel('LoadedCtrl','LoadedCtrl', true,self.OnCreate);
end 
function LoadedCtrl.OnCreate()
end 