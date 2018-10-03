RankPanel = {}
local self = RankPanel
function RankPanel.Awake(obj)
	self.gameObject = obj
    self.transform = obj.transform
	self.Init()
	self.Selected(1)
end 

function  RankPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.MenuBtn = {}
	self.MenuBtn[1] = self.transform:FindChild("Rank/Menu/Menu1").gameObject 
	self.MenuBtn[2] = self.transform:FindChild("Rank/Menu/Menu2").gameObject 
	self.MenuBtn[3] = self.transform:FindChild("Rank/Menu/Menu3").gameObject 



	self.menuBg = {}
	self.menuBg[1] = self.transform:FindChild("Rank/Menu/menuBg1").gameObject 
	self.menuBg[2] = self.transform:FindChild("Rank/Menu/menuBg2").gameObject 
	self.menuBg[3] = self.transform:FindChild("Rank/Menu/menuBg3").gameObject 

	self.Panel = {}
	self.Panel[1] = self.transform:FindChild("Rank/FreeRace").gameObject 
	self.Panel[2] = self.transform:FindChild("Rank/PointRace").gameObject 
	self.Panel[3] = self.transform:FindChild("Rank/ChallengeRace").gameObject 


	self.BackBtn = self.transform:FindChild("Rank/backBtn").gameObject 


	self.behaviour:AddClick(self.MenuBtn[1],self.SelectMenuOne)  
	self.behaviour:AddClick(self.MenuBtn[2],self.SelectMenuTwo)
	self.behaviour:AddClick(self.MenuBtn[3],self.SelectMenuThree)

	self.behaviour:AddClick(self.BackBtn,self.GoBackCallFunc) 
end 

function  RankPanel.SelectMenuOne()
	self.Selected(1)
end 
function RankPanel.SelectMenuTwo()
	self.Selected(2)
end
function RankPanel.SelectMenuThree()
	self.Selected(3)
end 

function RankPanel.Selected(Index)
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


function RankPanel.GoBackCallFunc() 
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end 