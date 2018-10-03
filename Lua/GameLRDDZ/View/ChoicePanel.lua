ChoicePanel = {}
local self = ChoicePanel

local transform
local gameObject

function ChoicePanel.Awake(obj)
	gameObject = obj
    transform = obj.transform

    self.Init()
    
    Avatar.avatarSex = 1

end 

--初始化
function ChoicePanel.Init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	--btn
	self.RandomBtn = transform:FindChild("Choice/ChoiceBg/RandomBtn").gameObject 
	self.OkBtn =  transform:FindChild("Choice/ChoiceBg/OkBtn").gameObject 
	self.selectMenBtn = transform:FindChild("Choice/ChoiceBg/selectMen").gameObject 
	self.selectMenTag = transform:FindChild("Choice/ChoiceBg/selectMen/selectTag").gameObject 
	self.selectWomenBtn = transform:FindChild("Choice/ChoiceBg/selectWomen").gameObject 
	self.selectWomenTag = transform:FindChild("Choice/ChoiceBg/selectWomen/selectTag").gameObject 
	self.selectWomenTag:SetActive(false)

	self.men = transform:FindChild("Choice/men").gameObject 
	--self.menGuang = transform:FindChild("Choice/men/guang").gameObject
	self.women = transform:FindChild("Choice/women").gameObject 
	--self.womenGuang = transform:FindChild("Choice/women/guang").gameObject
	--self.womenGuang:SetActive(false)

	self.nameLabel = transform:FindChild("Choice/ChoiceBg/namebg/nameLabel").gameObject
	--初始化名字
	if Avatar.avatarName ~= "" then
		self.nameLabel:GetComponent("UILabel").text = Avatar.avatarName
	end

	self.behaviour:AddClick(self.OkBtn,self.OkCallBack)  --登录
	self.behaviour:AddClick(self.selectMenBtn,self.SelectMenCallBack)  
	self.behaviour:AddClick(self.selectWomenBtn,self.SelectWomenCallBack)  
	self.behaviour:AddClick(self.RandomBtn,self.RandomNameCallBack)  

end 

function ChoicePanel.SelectMenCallBack()
	self.selectMenTag:SetActive(true)
	self.selectWomenTag:SetActive(false)
	--self.menGuang:SetActive(true)
	--self.womenGuang:SetActive(false)
	self.men.transform.localScale = Vector3.New(1,1,1)
	self.women.transform.localScale = Vector3.New(0.8,0.8,0.8)
	self.men:GetComponent("UISprite").color = Color.New(1,1,1,1)
	self.men:GetComponent("UISprite").depth = 12
	iTween.MoveTo(self.men,iTween.Hash("position",Vector3.New(-79,-21,0),"time",0.5,"islocal",true,"easetype",iTween.EaseType.easeOutBack))
	self.women:GetComponent("UISprite").color = Color.New(124/255,124/255,124/255,1)
	self.women:GetComponent("UISprite").depth = 11
	iTween.MoveTo(self.women,iTween.Hash("position",Vector3.New(-372,-85,0),"time",0.5,"islocal",true,"easetype",iTween.EaseType.easeOutBack))
	Avatar.avatarSex = 1
end 
function ChoicePanel.SelectWomenCallBack()
	self.selectMenTag:SetActive(false)
	self.selectWomenTag:SetActive(true)
	--self.menGuang:SetActive(false)
	--self.womenGuang:SetActive(true)
	self.men.transform.localScale = Vector3.New(0.8,0.8,0.8)
	self.women.transform.localScale = Vector3.New(1,1,1)
	self.men:GetComponent("UISprite").color = Color.New(124/255,124/255,124/255,1)
	self.men:GetComponent("UISprite").depth = 11
	iTween.MoveTo(self.men,iTween.Hash("position",Vector3.New(-372,-85,0),"time",0.5,"islocal",true,"easetype",iTween.EaseType.easeOutBack))
	self.women:GetComponent("UISprite").color = Color.New(1,1,1,1)
	self.women:GetComponent("UISprite").depth = 12
	iTween.MoveTo(self.women,iTween.Hash("position",Vector3.New(-79,-21,0),"time",0.5,"islocal",true,"easetype",iTween.EaseType.easeOutBack))
	--iTween.ScaleTo(self.NoteCardPanel,iTween.Hash("scale", Vector3.New(1,1,1), "time", 0.3, "islocal", true, "easetype", iTween.EaseType.easeOutBack))
	--iTween.ScaleTo(self.NoteCardPanel,iTween.Hash("scale", Vector3.New(1,1,1), "time", 0.3, "islocal", true, "easetype", iTween.EaseType.easeOutBack))
	Avatar.avatarSex = 2
end
function ChoicePanel.OkCallBack()
	LoadSceneAsync.LoadSceneAsync(SceneName.Main)
end 

function  ChoicePanel.RandomNameCallBack()
	self.rotate = 360*3
	if self.time ~= nil then 
		self.time:Stop()
	end 
	self.time = Timer.New(self.SetRotation, 0.02, -1, true)
	self.time:Start()

end
function ChoicePanel.SetRotation()
	local nameData = require "config.Name" 
	if self.rotate > 0 then 
		self.rotate = self.rotate - 60
		self.RandomBtn.transform.localRotation = Quaternion.Euler(0, 0, self.rotate)
		local tempname = nameData[math.random(1,#nameData)]
		self.nameLabel:GetComponent("UILabel").text = tempname.name1 .. tempname.name2
		Avatar.avatarName = tempname.name1 .. tempname.name2
	else 
		self.rotate = 0
		self.RandomBtn.transform.localRotation = Quaternion.Euler(0, 0, 0)
		self.time:Stop()
		self.time = nil 
	end 
end 
