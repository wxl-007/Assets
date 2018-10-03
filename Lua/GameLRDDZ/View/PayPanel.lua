PayPanel = {} 
local self = PayPanel
function PayPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
end 
function  PayPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');

	self.BackBtn = self.transform:FindChild("Pay/backBtn").gameObject 

	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 
end

function PayPanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 

