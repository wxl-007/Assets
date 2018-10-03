TaskPanel = {}
local self = TaskPanel
function TaskPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
end 
--初始化
function TaskPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');
	

	self.BackBtn = self.transform:FindChild("Task/backBtn").gameObject 

	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 

end
function TaskPanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 
