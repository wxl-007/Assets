RecordPanel = {}
local self = RecordPanel
function RecordPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
end 
--初始化
function RecordPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');
	

	self.BackBtn = self.transform:FindChild("Record/backBtn").gameObject 

	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 

end
function RecordPanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 
