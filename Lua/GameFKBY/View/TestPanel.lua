local transform;
local gameObject;
TestPanel = {};
local this = TestPanel;

--启动事件--
function TestPanel.Awake(obj)
	--gameObject = obj;
	--transform = obj.transform;

	this.InitPanel();
	warn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function TestPanel.InitPanel()
	--this.btnClose = transform:FindChild("Button").gameObject;
end

--单击事件--
function TestPanel.OnDestroy()
	warn("OnDestroy---->>>");
end