BankPanel = {}
local self = BankPanel
function BankPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
end 
function  BankPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');
	

	self.BackBtn = self.transform:FindChild("Bank/backBtn").gameObject 


	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 
end

function BankPanel.GoBackCallFunc()
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 