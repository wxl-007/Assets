RacePanel = {}
local self = RacePanel

local transform
local gameObject
local mono

local requirements
local champion_award
local awards
local matchtime
local restseconds
local mincn
local maxcn
local cn
local initscore
local unit_money
local step2_line
local join_rank
local step2_initscore
local step1time
local step2time

local recPlayerNum = 0
function RacePanel.Awake(obj)
	print("Awke RacePanel");
	obj:SetActive(true)
	gameObject = obj
	transform = obj.transform
	mono = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.init()
end 
function self.init()
	self.playernum = transform:FindChild("Label_playernum"):GetComponent("UILabel")
	self.min = transform:FindChild("Label_min"):GetComponent("UILabel")
	self.sce1 = transform:FindChild("Label_sce1"):GetComponent("UILabel")
	self.sce2 = transform:FindChild("Label_sce2"):GetComponent("UILabel")
	self.maxnum = transform:FindChild("Label_maxNum"):GetComponent("UILabel")
	self.matchtime = transform:FindChild("Label_matchtime"):GetComponent("UILabel")
	self.rank = transform:FindChild("award/Label_rank"):GetComponent("UILabel")
	self.lb_award = transform:FindChild("award/Label_award"):GetComponent("UILabel")
	self.award = transform:FindChild("award").gameObject
	self.award:SetActive(false)

	self.btnAward = transform:FindChild("btnaward").gameObject
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
		mono:AddHover(self.btnAward,RacePanel.OnAwardCallBack)
	else
		mono:AddClick(self.btnAward,RacePanel.OnAwardCallBack)
	end

	self.rule = transform:FindChild("rule").gameObject
	self.rule:SetActive(false)
	self.btnrule = transform:FindChild("btnRule").gameObject
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
		mono:AddHover(self.btnrule,RacePanel.OnRuleCallBack)
	else
		mono:AddClick(self.btnrule,RacePanel.OnRuleCallBack)
	end

	self.btnclose = transform:FindChild("btnExit").gameObject
	mono:AddClick(self.btnclose,RacePanel.OnCloseCallBack)

	RacePanel.SetMaxNum(mincn,maxcn)
	RacePanel.SetMatchTime(matchtime)
	RacePanel.SetPlayerNum(recPlayerNum)
	RacePanel.Award()
	
end
function RacePanel.OnAwardCallBack(state)
	--self.rule:SetActive(false)
	--self.award:SetActive(not self.award.activeSelf)
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then

		self.award:SetActive(state)
	else
		self.award:SetActive(not self.award.activeSelf)
		if self.award.activeSelf == true then
			self.rule:SetActive(false)
		end
	end
end
function RacePanel.OnRuleCallBack(state)
	--self.award:SetActive(false)
	--self.rule:SetActive(not self.rule.activeSelf)
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then

		self.rule:SetActive(state)
	else
		self.rule:SetActive(not self.rule.activeSelf)
		if self.rule.activeSelf == true then
			self.award:SetActive(false)
		end
	end
end
function RacePanel.OnCloseCallBack()
	if LRDDZ_Game.platform == PlatformType.PlatformMoble then
    	LRDDZ_Game:BackHall()
    else
    	--直接退出游戏
		Application.Quit()
	end
end
function RacePanel.OnDestroy()
	gameObject = nil
	transform = nil
	mono = nil
	self.min = nil
	self.sce1 = nil
	self.sec2 = nil
	self.playernum = nil
	self.timer:Stop()
	self.timer = nil
end

function RacePanel.SetPlayerNum(num)
	recPlayerNum = num
	if self.playernum == nil then return end
	self.playernum.text = num.."人"
end
local cTime = 0
function RacePanel.SetTime(time)
	cTime = time
	if self.timer~=nil then
		self.timer:Stop()	
	end
	self.timer = Timer.New(RacePanel.CountDown,1,-1,true)
	self.timer:Start()
end
function RacePanel.SetMatchTime(str)
	--self.matchtime.text = str
	self.matchtime.text = "每5分钟一场"
end
function RacePanel.SetMaxNum(min,max)
	self.maxnum.text = min.."-"..max
end
function RacePanel.CountDown()
	if cTime > 0 then
		local m = math.floor(cTime/60)
		local s = cTime%60
		local m_str = ""
		if m < 10 then
			m_str = "0"..m
		else
			m_str = tostring(m)
		end
		local s_str = ""
		if s < 10 then
			s_str = "0"..s 
		else
			s_str = tostring(s)
		end
		if self.min ~= nil and self.sce1 ~= nil and self.sce2 ~= nil then
			self.min.text = m_str
			s_num = tonumber(s_str)
			self.sce1.text = tostring(math.floor(s_num/10))
			self.sce2.text = tostring(s_num%10)
		end
		cTime = cTime - 1
	else
		if self.min ~= nil and self.sce1 ~= nil and self.sce2 ~= nil then
			self.min.text = ""
			self.sce1.text = ""
			self.sce2.text = ""
		end
		self.timer:Stop()
	end
end
-- [["第1名", "50000欢乐豆+1张门票"], ["第2名", "30000欢乐豆+1张门票"], ["第3名", "20000欢乐豆+1张门票"], ["第4名", "1张门票"], ["第5名", "1张门票"], ["第6~9名", "1张门票"]]
function RacePanel.Award()
	local rankstr = ""
	local awardstr = "" 
	for i=1,#awards do
		rankstr = rankstr..awards[i][1].."\n"
		awardstr = awardstr..awards[i][2].."\n"
	end
	self.rank.text = rankstr
	self.lb_award.text = awardstr
end
function RacePanel.GetAwards(_awards)
	if _awards ~= nil then
		awards = _awards
	else
		return awards
	end
end
function RacePanel.SetPanel(messageObj)
	local body = messageObj["body"]
	requirements = body["requirements"] --报名条件
	champion_award = body["champion_award"]--冠军奖励
	awards = body["awards"] --报名奖励说明
	matchtime = body["matchtime"]--开赛时间
	restseconds = body["restseconds"]--剩余重置时间
	mincn = body["mincn"]--最小人数限制
	maxcn = body["maxcn"]--最大人数限制
	cn = body["cn"]--当前人数
	initscore = body["initscore"]--初始积分
	unit_money = body["unit_money"]--基数
	step2_line = body["step2_line"]--决出前9名
	join_rank = body["join_rank"]--排名前3名可参加决赛
	step2_initscore = body["step2_initscore"]--第2阶段带入积分
	step1time = body["step1time"]--预赛时长
	step2time = body["step2time"]--决赛时长
	RacePanel.SetTime(restseconds)
	RacePanel.SetPlayerNum(cn)
end
