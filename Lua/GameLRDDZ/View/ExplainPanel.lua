ExplainPanel = {}
local self = ExplainPanel
function ExplainPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
	self.Selected(1)
end 
function  ExplainPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.MenuBtn = {}
	self.MenuBtn[1] = self.transform:FindChild("Explain/Menu/Menu1").gameObject 
	self.MenuBtn[2] = self.transform:FindChild("Explain/Menu/Menu2").gameObject 
	self.MenuBtn[3] = self.transform:FindChild("Explain/Menu/Menu3").gameObject 
	self.MenuBtn[4] = self.transform:FindChild("Explain/Menu/Menu4").gameObject 

	self.menuBg = {}
	self.menuBg[1] = self.transform:FindChild("Explain/Menu/menuBg1").gameObject 
	self.menuBg[2] = self.transform:FindChild("Explain/Menu/menuBg2").gameObject 
	self.menuBg[3] = self.transform:FindChild("Explain/Menu/menuBg3").gameObject 
	self.menuBg[4] = self.transform:FindChild("Explain/Menu/menuBg4").gameObject 

	self.Panel = {}
	self.Panel[1] = self.transform:FindChild("Explain/RuleDescription").gameObject 
	self.Panel[2] = self.transform:FindChild("Explain/TournamentDescription").gameObject 
	self.Panel[3] = self.transform:FindChild("Explain/QualifyingDescription").gameObject 
	self.Panel[4] = self.transform:FindChild("Explain/ChallengeDescription").gameObject 
	
	self.BackBtn = self.transform:FindChild("Explain/backBtn").gameObject 

	self.behaviour:AddClick(self.MenuBtn[1],self.SelectMenuOne)  
	self.behaviour:AddClick(self.MenuBtn[2],self.SelectMenuTwo)
	self.behaviour:AddClick(self.MenuBtn[3],self.SelectMenuThree)
	self.behaviour:AddClick(self.MenuBtn[4],self.SelectMenuFour)

	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 
end
function  ExplainPanel.SelectMenuOne()
	self.Selected(1)
end 
function ExplainPanel.SelectMenuTwo()
	self.Selected(2)
end
function ExplainPanel.SelectMenuThree()
	self.Selected(3)
end 
function ExplainPanel.SelectMenuFour()
	self.Selected(4)
end
function ExplainPanel.Selected(Index)
	for i =1, #self.MenuBtn  do 
		if i == Index then --DBCBF5FF  867FB8FF
			self.MenuBtn[i]:GetComponent('UILabel').gradientTop = Color.New(219/255, 203/255, 191/255, 1)
			self.MenuBtn[i]:GetComponent('UILabel').gradientBottom  = Color.New(219/255, 203/255, 191/255, 1)
		else 
			self.MenuBtn[i]:GetComponent('UILabel').gradientTop = Color.New(134/255, 127/255, 184/255, 1)
			self.MenuBtn[i]:GetComponent('UILabel').gradientBottom  = Color.New(134/255, 127/255, 184/255, 1)
		end 
	end 

	for i =1, #self.menuBg  do 
		if i == Index then 
			self.menuBg[i]:SetActive(true)
		else 
			self.menuBg[i]:SetActive(false)
		end 
	end 
	for i =1, #self.Panel  do 
		if i == Index then 
			self.Panel[i]:SetActive(true)
		else 
			self.Panel[i]:SetActive(false)
		end 
	end 
end 


function ExplainPanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 