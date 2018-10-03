ShopPanel = {}
local self = ShopPanel
function ShopPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
end 
--初始化
function ShopPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');
	

	self.BackBtn = self.transform:FindChild("Shop/backBtn").gameObject 

	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 

end
function ShopPanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 
