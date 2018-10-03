NoticePanel = {}
local self = NoticePanel
function NoticePanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
end 
--初始化
function NoticePanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');
	

	self.BackBtn = self.transform:FindChild("Notice/backBtn").gameObject 

	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 

end
function NoticePanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 
