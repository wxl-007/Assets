
SettingPanel = {}
local self = SettingPanel
function SettingPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform

    self.isOpenMusic = false
	self.isOpenShock = true
	self.isOpenSound = true
	self.isOpenEffects = false	

	self.Init()
end 

function  SettingPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');


	self.BackBtn = self.transform:FindChild("Setting/backBtn").gameObject 



	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 
end


function SettingPanel.Selected(Index)
	
end 


function SettingPanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 

