EmailPanel = {}
local self = EmailPanel
function EmailPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
end  

function  EmailPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.BackBtn = self.transform:FindChild("Email/backBtn").gameObject 


	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 
end 
function EmailPanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 