JDRaceOverPanel = {}
local self = JDRaceOverPanel

local transform
local gameObject
local mono


local round
local iswin
local addscore
local sumscore
local avescore

function self.Awake(obj)
	gameObject = obj
	transform = obj.transform
	mono = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	mono:AddClick(transform:FindChild("btngoon").gameObject,self.OnGoOnCallBack)
	mono:AddClick(transform:FindChild("btnclose").gameObject,self.OnCloseCallBack)
end
function self.OnEnable()
	self.ShowOver()
	local function func( ... )
		coroutine.wait(5)
		self.OnGoOnCallBack()
	end
	--测试用
	--coroutine.start(func)
end
function self.SetValue( _round,_iswin,_addscore,_sumscore,_avescore )
	round = _round
	iswin = _iswin
	addscore = _addscore
	sumscore = _sumscore
	avescore = _avescore
end
function self.ShowOver()
	GameCtrl.ReSetGame()
	if self.lb_add == nil then
		self.lb_add = transform:FindChild("Label_add"):GetComponent("UILabel")
	end
	if self.lb_curScore == nil then
		self.lb_curScore = transform:FindChild("Label_curscore"):GetComponent("UILabel") 
	end
	if self.winobj == nil then
		self.winobj = transform:FindChild("win").gameObject
	end
	if self.loseobj == nil then
		self.loseobj = transform:FindChild("lose").gameObject
	end

	self.winobj:SetActive(iswin)
	self.loseobj:SetActive(not iswin)

	local addstr = "第"..round.."局对局"
	if iswin then
		addstr = addstr.."[00FF36]胜利[-],获得[00FF36]"..addscore.."[-]积分"
	else
		addstr = addstr .."[FF0000]失败[-],获得[00FF36]"..addscore.."[-]积分"
	end
	self.lb_add.text = addstr

	self.lb_curScore.text = "[FFE28A]您当前总积分为[FFBF00]"..sumscore.."[-]，场均分为[FFBF00]"..avescore

	--在GameCtrl计算了 在这里显示就可以了
	GamePanel.PlayerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Player.raceScore)
    GamePanel.ComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Computer.raceScore)
    GamePanel.OtherComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(OtherComputer.raceScore)
end
function self.OnDestroy()
	self.lb_add = nil
	self.lb_curScore = nil
	self.winobj = nil
	self.loseobj = nil
end

function self.OnCloseCallBack( )
	if LRDDZ_Game.platform == PlatformType.PlatformMoble then
    	LRDDZ_Game:BackHall()
    else
    	--直接退出游戏
		Application.Quit()
	end
end
function self.OnGoOnCallBack()

	Computer.DelectResidueCards()
    if LRDDZ_Game.gameType == DDZGameType.Three then
        OtherComputer.DelectResidueCards()
    end

    --[[
    local audioSource = LRDDZ_MusicManager.instance.GetAudioSource
    if audioSource ~= nil and (audioSource.clip.name == "bgsound4" or audioSource.clip.name == "bgsound5") then
        local rand = math.random(1,3);
        LRDDZ_MusicManager.instance:PlayMuisc("bgsound"..rand, true, true, false, 0.5)
    end
	]]
    self.ClearCalCardList()

	LRDDZ_Game:UserReady()
	gameObject:SetActive(false)


	
end

function self.ClearCalCardList()--清除结算界面显示的牌
	if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
	   GamePanel.DealCallBack()
    end
	GamePanel.GameOverAnim(true)
	CountDownPanel.CancelCountDown(false)
end