require "Common/define"
require "GameLRDDZ.Common/MyCommon"

require "GameLRDDZ/Controller/LoginCtrl"
require "GameLRDDZ/Controller/ChoiceCtrl"
require "GameLRDDZ/Controller/MainCtrl"
require "GameLRDDZ/Game/GameCtrl"

LRDDZ_CtrlManager = {};
local self = LRDDZ_CtrlManager;
local ctrlList = {};	--控制器列表--

function LRDDZ_CtrlManager.Init()
	return self;
end

--添加控制器--
function LRDDZ_CtrlManager.AddCtrl(ctrlName, ctrlObj)
	ctrlList[ctrlName] = ctrlObj;
end

--获取控制器--
function LRDDZ_CtrlManager.GetCtrl(ctrlName)
	return ctrlList[ctrlName];
end

--移除控制器--
function LRDDZ_CtrlManager.RemoveCtrl(ctrlName)
	ctrlList[ctrlName] = nil;
end

--关闭控制器--
function LRDDZ_CtrlManager.Close()
end