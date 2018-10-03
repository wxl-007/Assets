ChoiceCtrl = {};
local self = ChoiceCtrl;
--构建函数--
function ChoiceCtrl.New()
	return self;
end

function ChoiceCtrl.Awake()
	LRDDZ_ResourceManager.Instance:CreatePanel('ChoicePanel','ChoicePanel', true,self.OnCreate);
end 
function ChoiceCtrl.OnCreate()
end 
