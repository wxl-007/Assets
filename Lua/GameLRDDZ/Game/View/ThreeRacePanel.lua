ThreeRacePanel = {}
local self = ThreeRacePanel

local transform
local gameObject

local fee
local awards
local playern

local recPlayerNum = 0
function ThreeRacePanel.Awake(obj)
	print("Awke ThreeRacePanel");
	obj:SetActive(true)
	gameObject = obj
	transform = obj.transform
	mono = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.init()
end 
function self.init()

	self.rule = transform:FindChild("rule").gameObject
	self.rule:SetActive(false)
	self.btnrule = transform:FindChild("btnRule").gameObject
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
		mono:AddHover(self.btnrule,ThreeRacePanel.OnRuleCallBack)
	else
		mono:AddClick(self.btnrule,ThreeRacePanel.OnRuleCallBack)
	end

	self.lbFree = transform:FindChild("Label_free"):GetComponent("UILabel")
	self.playernum = transform:FindChild("Label_playernum"):GetComponent("UILabel")

	self.lbFree.text = fee.."欢乐豆"
	ThreeRacePanel.SetPlayerNum(recPlayerNum)

	self.btnclose = transform:FindChild("btnExit").gameObject
	mono:AddClick(self.btnclose,ThreeRacePanel.OnCloseCallBack)

	self.rank = transform:FindChild("award/Label_rank"):GetComponent("UILabel")
	self.lb_award = transform:FindChild("award/Label_award"):GetComponent("UILabel")
	self.award = transform:FindChild("award").gameObject
	self.award:SetActive(false)
	self.btnAward = transform:FindChild("btnaward").gameObject
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
		mono:AddHover(self.btnAward,ThreeRacePanel.OnAwardCallBack)
	else
		mono:AddClick(self.btnAward,ThreeRacePanel.OnAwardCallBack)
	end
	ThreeRacePanel.Award()
end

function ThreeRacePanel.OnAwardCallBack(state)
	
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
		self.award:SetActive(state)
	else
		self.award:SetActive(not self.award.activeSelf)
		if self.award.activeSelf then
			self.rule:SetActive(false)
		end
	end
end
function ThreeRacePanel.OnRuleCallBack(state)
	--self.award:SetActive(false)
	--self.rule:SetActive(not self.rule.activeSelf)
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
		self.rule:SetActive(state)
	else
		self.rule:SetActive(not self.rule.activeSelf)
		if self.rule.activeSelf then
			self.award:SetActive(false)
		end
	end
end
function ThreeRacePanel.SetPlayerNum(num)
	recPlayerNum = num
	if self.playernum == nil then return end
	self.playernum.text = num.."人"
end
function ThreeRacePanel.OnCloseCallBack()
	if LRDDZ_Game.platform == PlatformType.PlatformMoble then
    	LRDDZ_Game:BackHall()
    else
    	--直接退出游戏
		Application.Quit()
	end
end

function ThreeRacePanel.Award()
	local rankstr = ""
	local awardstr = "" 
	for i=1,1 do
		rankstr = rankstr..awards[i][1].."\n"
		awardstr = awardstr..awards[i][2].."\n"
	end
	self.rank.text = rankstr
	self.lb_award.text = awardstr
end

--[[
1.报名协议：
==>>{'type': 'ddz9', 'tag': 'apply',
               'body': {'playern': self.matchcn,人数
                        'fee': self.room.entry_fee,入场费
                        'awards': self.awardstr,报名奖励说明
                        'deckn': self.deckn,一轮打几副牌
                        'close': is_close,比赛是否关闭}}

]]
function ThreeRacePanel.SetPanel(messageObj)
	local body = messageObj["body"]
	fee = body["fee"] --报名条件
	awards = body["awards"] --报名奖励说明
	playern = body["playern"] --人数
	ThreeRacePanel.SetPlayerNum(playern)
	RacePanel.GetAwards(awards)
end
function ThreeRacePanel.OnDestroy(  )
	gameObject = nil
	transform = nil
	mono = nil
	self.playernum = nil
end