GamePanel = {}
local self = GamePanel

local transform
local gameObject

local playanim = true --是否播放打招呼动作

--记录动画坐标
local hideCardPos
--local playerHeadPos
local multiplesNumPos
local menuPos
local computerHeadPos
local otherComputerHeadPos
local gobackbtnPos
local initScoerPos

local recHideCardsAnimPos

local raceRound = 0
function GamePanel.Awake(obj)
	print("Awke GamePanel");
	obj:SetActive(true)
	gameObject = obj
	transform = obj.transform
	playanim = true
	--transform.parent:GetComponent("Camera").orthographicSize = 0.57;

	--是否打开聊天面板
	self.isOpenTalkBoard = false
	--底牌列表
	self.BottomCardList = {}
	--玩家出牌列表
	self.playerPlayedList = {}
	self.playerPlayedObjList = {}
	--电脑出牌列表
	self.computerPlayedList = {}
	self.computerPlayedObjList = {}
	self.init()
	
end 
function GamePanel.Start()
	---	动画坐标
    hideCardPos = self.hideCard.transform.localPosition
	--playerHeadPos = self.PlayerHead.transform.localPosition
	multiplesNumPos = self.multiplesNum.transform.localPosition
	menuPos = self.Menu.transform.localPosition
	computerHeadPos = self.ComputerHead.transform.localPosition
	otherComputerHeadPos = self.OtherComputerHead.transform.localPosition
	gobackbtnPos = self.gobackbtn.transform.localPosition
	initScoerPos = self.initScore.transform.localPosition
	recHideCardsAnimPos = self.hideCardsAnim.transform.localPosition
	GamePanel.GameOverAnim(true)
	GamePanel.ShowComputerHead(false)
	GamePanel.ShowOtherComputerHead(false)
end

function GamePanel.OnEnable()
	Event.AddListener(GameEvent.ShowCallBtn, self.ActiveCallBtn)
	Event.AddListener(GameEvent.ShowLetNum, self.ShowLetCardNum)
	Event.AddListener(GameEvent.ShowGardLord, self.ActiveGrabLandlord)
	Event.AddListener(GameEvent.ShowPlay, self.ActivePlay)
	Event.AddListener(GameEvent.ShowBottomCards, self.ShowBottomCards)
	Event.AddListener(GameEvent.ReSetInfo, self.ReSetInfo)
	Event.AddListener(GameEvent.ShowGameText, self.ShowGameObjText)
	Event.AddListener(GameEvent.NoteCard, self.ShowNoteCard)
	Event.AddListener(GameEvent.NotBigCard, self.ActiveNotBigCard)
	Event.AddListener(GameEvent.ShowYaobuqi,self.ActiveYaobuqi)
end  

function GamePanel.OnDisable()
	Event.RemoveListener(GameEvent.ShowCallBtn, self.ActiveCallBtn)
	Event.RemoveListener(GameEvent.ShowLetNum, self.ShowLetCardNum)
	Event.RemoveListener(GameEvent.ShowGardLord, self.ActiveGrabLandlord)
	Event.RemoveListener(GameEvent.ShowPlay, self.ActivePlay)
	Event.RemoveListener(GameEvent.ShowBottomCards, self.ShowBottomCards)
	Event.RemoveListener(GameEvent.ReSetInfo, self.ReSetInfo)
	Event.RemoveListener(GameEvent.ShowGameText, self.ShowGameObjText)
	Event.RemoveListener(GameEvent.NoteCard, self.ShowNoteCard)
	Event.RemoveListener(GameEvent.NotBigCard, self.ActiveNotBigCard)
	Event.RemoveListener(GameEvent.ShowYaobuqi,self.ActiveYaobuqi)
	self.ClearBottomCard()
	GameCtrl.Clear()
end 
function  GamePanel.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.Menu = transform:FindChild("Menu").gameObject
	self.gobackbtn = transform:FindChild("GoBackBtn").gameObject --返回
	self.tuoguanBtn = transform:FindChild("Menu/TuoGuanBtn").gameObject --托管
	self.tuoguananim = self.tuoguanBtn.transform:FindChild("anim").gameObject --托管动画
	self.noteCardBtn = transform:FindChild("Menu/JifenPaiBtn").gameObject --记牌
	self.talkBtn = transform:FindChild("Menu/TalkBtn").gameObject --聊天

	self.closeTaklBtn = transform:FindChild("Talkboard/collider").gameObject
	self.talkboard = transform:FindChild("Talkboard").gameObject --聊天面板
	self.zhankai = transform:FindChild("zhankaiBtn").gameObject --展开按钮
	self.setting = transform:FindChild("Menu/setting").gameObject
	self.lastHand = transform:FindChild("Menu/LastHand").gameObject --上一手
	self.initScore = transform:FindChild("Integral/InitScore").gameObject --底分

	self.task = transform:FindChild("Task").gameObject

	self.taskdesc = transform:FindChild("Task/Top/Label_desc"):GetComponent("UILabel")
	self.taskAminLabel = transform:FindChild("Task/Label_anim"):GetComponent("UILabel")
	self.taskrewardNum = transform:FindChild("Task/Top/Label_num"):GetComponent("UILabel")
	self.taskawardtype = transform:FindChild("Task/Top/Label_num/Label_type"):GetComponent("UILabel")
	self.taskfinish = transform:FindChild("TaskFinish").gameObject
	self.taskfinishaward = transform:FindChild("TaskFinish/Label_award"):GetComponent("UILabel")

	--底牌
	self.hideCard = transform:FindChild("HideCards").gameObject 
	self.hideDouble = self.hideCard.transform:FindChild("Label_hidedouble"):GetComponent("UILabel");
	self.hideCardSprites = {} --三张底牌
	for i=1,3 do
		self.hideCardSprites[i] = self.hideCard.transform:FindChild("card"..i):GetComponent("UISprite")
	end
	--癞子牌显示
	self.lzCardSprite = self.hideCard.transform:FindChild("card4"):GetComponent("UISprite")
	self.lzCardAnim = transform:FindChild("LZCardsAnim").gameObject
	self.lzCardAnim:SetActive(false)
	self.lzcardEff = transform:FindChild("LZCardsAnim/LaiZi").gameObject

	self.hideCard:SetActive(false);
	self.hideCardsAnim = transform:FindChild("HideCardsAnim").gameObject
	
	self.hideCardsAnim:SetActive(false);

	self.foldAnim = transform:FindChild("Fold").gameObject
	self.foldNum = transform:FindChild("Fold/Label_foldNum"):GetComponent("UILabel")
	self.foldAnim:SetActive(false)

	--聊天面板的所有句子
	self.talkbar = {}
	local talkcontent = require "GameLRDDZ.config.TalkContent"
	for i=1,#talkcontent do
		self.talkbar[i] = transform:FindChild("Talkboard/"..i).gameObject
		self.talkbar[i]:GetComponent('UILabel').text = talkcontent[i].content	--读取配表的台词
		self.behaviour:AddClick(self.talkbar[i],self.TalkbarCallBack)
	end
	--[[
	self.behaviour:AddClick(self.talkbar[1],self.Talkbar1CallBack)
	self.behaviour:AddClick(self.talkbar[2],self.Talkbar2CallBack)
	self.behaviour:AddClick(self.talkbar[3],self.Talkbar3CallBack)
	self.behaviour:AddClick(self.talkbar[4],self.Talkbar4CallBack)
	self.behaviour:AddClick(self.talkbar[5],self.Talkbar5CallBack)
	self.behaviour:AddClick(self.talkbar[6],self.Talkbar6CallBack)
	self.behaviour:AddClick(self.talkbar[7],self.Talkbar7CallBack)
	self.behaviour:AddClick(self.talkbar[8],self.Talkbar8CallBack)
	self.behaviour:AddClick(self.talkbar[9],self.Talkbar9CallBack)
	self.behaviour:AddClick(self.talkbar[10],self.Talkbar10CallBack)
	self.behaviour:AddClick(self.talkbar[11],self.Talkbar11CallBack)
	self.behaviour:AddClick(self.talkbar[12],self.Talkbar12CallBack)
	]]
	--记牌面板
	self.NoteCardPanel = transform:FindChild("NoteCard").gameObject
	self.Note_LJcount = transform:FindChild("NoteCard/NoteCardBg/LJ"):GetComponent("UILabel") --记牌面板的label
	self.Note_SJcount = transform:FindChild("NoteCard/NoteCardBg/SJ"):GetComponent("UILabel")
	self.Note_2count = transform:FindChild("NoteCard/NoteCardBg/2"):GetComponent("UILabel")
	self.Note_Acount = transform:FindChild("NoteCard/NoteCardBg/A"):GetComponent("UILabel")
	self.Note_Kcount = transform:FindChild("NoteCard/NoteCardBg/K"):GetComponent("UILabel")
	self.Note_Qcount = transform:FindChild("NoteCard/NoteCardBg/Q"):GetComponent("UILabel")
	self.Note_Jcount = transform:FindChild("NoteCard/NoteCardBg/J"):GetComponent("UILabel")
	self.Note_10count = transform:FindChild("NoteCard/NoteCardBg/10"):GetComponent("UILabel")
	self.Note_9count = transform:FindChild("NoteCard/NoteCardBg/9"):GetComponent("UILabel")
	self.Note_8count = transform:FindChild("NoteCard/NoteCardBg/8"):GetComponent("UILabel")
	self.Note_7count = transform:FindChild("NoteCard/NoteCardBg/7"):GetComponent("UILabel")
	self.Note_6count = transform:FindChild("NoteCard/NoteCardBg/6"):GetComponent("UILabel")
	self.Note_5count = transform:FindChild("NoteCard/NoteCardBg/5"):GetComponent("UILabel")
	self.Note_4count = transform:FindChild("NoteCard/NoteCardBg/4"):GetComponent("UILabel")
	self.Note_3count = transform:FindChild("NoteCard/NoteCardBg/3"):GetComponent("UILabel")

	self.Interaction = transform:FindChild("Interaction")
	self.deal =  transform:FindChild("Interaction/DealBtn").gameObject  --发牌
	self.showcardAtReady = transform:FindChild("Interaction/ShowCardBtn").gameObject
	self.play =  transform:FindChild("Interaction/PlayBtn").gameObject   --出牌
	self.discard =  transform:FindChild("Interaction/DiscardBtn").gameObject --不出
	self.grab =  transform:FindChild("Interaction/GrabBtn").gameObject  --抢地主
	self.disgrab =  transform:FindChild("Interaction/DisgrabBtn").gameObject --不抢
	self.prompt =  transform:FindChild("Interaction/PromptBtn").gameObject --提示

	self.doublebtn =  transform:FindChild("Interaction/DoubleBtn").gameObject --加倍
	self.disdoublebtn =  transform:FindChild("Interaction/DisDoubleBtn").gameObject --不加倍
	self.callbtn =  transform:FindChild("Interaction/CallBtn").gameObject --叫地主
	self.discallbtn =  transform:FindChild("Interaction/DisCallBtn").gameObject --不叫
	self.cancelHostingbtn = transform:FindChild("Interaction/CancelHostingBtn").gameObject --取消托管
	self.yaobuqibtn = transform:FindChild("Interaction/YaobuqiBtn").gameObject	--要不起按钮
	self.openHandbtn = transform:FindChild("Interaction/OpenHandBtn").gameObject -- 明牌按钮

	self.call1btn = transform:FindChild("Interaction/Call1Btn").gameObject --1分
	self.call2btn = transform:FindChild("Interaction/Call2Btn").gameObject --2分
	self.call3btn = transform:FindChild("Interaction/Call3Btn").gameObject --3分

	-- self.texiao = transform:FindChild("texiao").gameObject--测试特效用的按钮
	-- self.behaviour:AddClick(self.texiao,self.texiaoCall)

	self.behaviour:AddClick(self.tuoguanBtn,self.TuoguanCallBack)  --托管按钮回调
	self.behaviour:AddClick(self.noteCardBtn,self.NoteCardCallBack)  --记分牌按钮回调
	self.behaviour:AddClick(self.talkBtn,self.TalkCallBack) --聊天按钮回调
	self.behaviour:AddClick(self.closeTaklBtn,self.TalkCallBack) --聊天关闭按钮
	self.behaviour:AddClick(self.zhankai,self.ZhankaiCallBack)	--展开按钮回调
	self.behaviour:AddClick(self.setting,self.SettingCallBack)--设置
	self.behaviour:AddClick(self.lastHand,self.LastHandCallBack) --上一手牌

	self.behaviour:AddClick(self.gobackbtn,self.GoBackCallBack)  --返回
	self.behaviour:AddClick(self.deal,self.DealCallBack)  --发牌
	self.behaviour:AddClick(self.showcardAtReady,self.ShowCardCallBack) --开始明牌
	self.behaviour:AddClick(self.play,self.PlayCallBack)  --出牌
	self.behaviour:AddClick(self.discard,self.DiscardCallBack)  --不出
	self.behaviour:AddClick(self.grab,self.GrabLordCallBack)  --抢地主
	self.behaviour:AddClick(self.disgrab,self.DisgrabLordCallBack)  --不抢
	self.behaviour:AddClick(self.prompt,self.PromptLordCallBack)  --提示

	self.behaviour:AddClick(self.doublebtn,self.DoubleCallBack)  --加倍
	self.behaviour:AddClick(self.disdoublebtn,self.DisDoubleCallBack)  --不加倍
	self.behaviour:AddClick(self.callbtn,self.CallLordCallBack)  --叫地主
	self.behaviour:AddClick(self.discallbtn,self.DisCallLordCallBack)  --不叫
	self.behaviour:AddClick(self.cancelHostingbtn,self.CancelHostingCallBack) --取消托管  
	self.behaviour:AddClick(self.yaobuqibtn,self.YaobuqiCallBack)	--要不起按钮回调
	self.behaviour:AddClick(self.openHandbtn,self.OpenHandCallBack) --明牌
	self.behaviour:AddClick(self.call1btn,self.CallScoreCallBack) --叫分
	self.behaviour:AddClick(self.call2btn,self.CallScoreCallBack) --叫分
	self.behaviour:AddClick(self.call3btn,self.CallScoreCallBack) --叫分


	self.outtimelabel = transform:FindChild("Integral/OutTimeLabel").gameObject--倒计时踢出房label
	self.outtimelabel:SetActive(false)

	self.play:SetActive(false);
    self.discard:SetActive(false);
    self.grab:SetActive(false);
    self.disgrab:SetActive(false);
    self.prompt:SetActive(false);

    self.call1btn:SetActive(false);
	self.call2btn:SetActive(false);
	self.call3btn:SetActive(false);

    self.doublebtn:SetActive(false);
    self.disdoublebtn:SetActive(false);
    self.callbtn:SetActive(false);
    self.discallbtn:SetActive(false);
    self.cancelHostingbtn:SetActive(false);
    self.yaobuqibtn:SetActive(false)
    self.openHandbtn:SetActive(false);
    self.taskfinish:SetActive(false);

    self.bottomParent = transform:FindChild("Bottom").gameObject --底牌Parent
    self.bottomCardPoint =  transform:FindChild("Bottom/CardsStartPoint").gameObject --底牌位置
    self.bottomBg = transform:FindChild("Bottom/BottomBg").gameObject --底牌Bg
    self.TempBottomCard = {}

    self.multiplesNum = transform:FindChild("Integral/MultiplesNum").gameObject --倍数label
    self.multiplesEff = self.multiplesNum.transform:FindChild("huo").gameObject
    self.letCardNum = transform:FindChild("Integral/LetCardNum").gameObject	--让牌数label
    self.BigMultiplesNum = transform:FindChild("Integral/BigMultiplesNum").gameObject--放大移动的大倍数label
    self.BigMultiplesNum:SetActive(false)
    self.test = transform:FindChild("Integral/Label-test"):GetComponent("UILabel"); --测试用。让牌数

    self.PlayerHead = transform:FindChild("Integral/PlayerHead").gameObject--玩家区域的边框
    self.PlayerIdentity = transform:FindChild("Integral/PlayerHead/landlordIcon").gameObject--玩家是农夫还是地主的标签图
    self.PlayerInteration  = transform:FindChild("Integral/PlayerHead/IntegrationLabel").gameObject--玩家的钱label
    self.PlayerHeadIcon = transform:FindChild("Integral/PlayerHead/headbg/playerheadicon").gameObject--玩家的头像图
    self.PlayerName = transform:FindChild("Integral/PlayerHead/playername").gameObject--玩家的名字label

    


    self.ComputerHead = transform:FindChild("Integral/ComputerHead").gameObject--电脑区域的边框
    self.ComputerIdentity = transform:FindChild("Integral/ComputerHead/landlordIcon").gameObject--电脑是农夫还是地主的标签图
    self.ComputerInteration  = transform:FindChild("Integral/ComputerHead/IntegrationLabel").gameObject--电脑的钱label
    self.ComputerHeadIcon = transform:FindChild("Integral/ComputerHead/headbg/computerheadicon").gameObject--电脑的头像图
    self.ComputerName = transform:FindChild("Integral/ComputerHead/computername").gameObject--电脑的名字label
    self.ComputerManageIcon = transform:FindChild("Integral/ComputerHead/manageIcon").gameObject   --托管标志
    GamePanel.SetComputerManage(false)

    --另一个电脑玩家
    self.OtherComputerHead = transform:FindChild("Integral/OtherComputerHead").gameObject--电脑区域的边框
    self.OtherComputerIdentity = transform:FindChild("Integral/OtherComputerHead/landlordIcon").gameObject--电脑是农夫还是地主的标签图
    self.OtherComputerInteration  = transform:FindChild("Integral/OtherComputerHead/IntegrationLabel").gameObject--电脑的钱label
    self.OtherComputerHeadIcon = transform:FindChild("Integral/OtherComputerHead/headbg/computerheadicon").gameObject--电脑的头像图
    self.OtherComputerName = transform:FindChild("Integral/OtherComputerHead/computername").gameObject--电脑的名字label
    self.OtherComputerManageIcon = transform:FindChild("Integral/OtherComputerHead/manageIcon").gameObject   --托管标志
    GamePanel.SetOtherManage(false)

	GamePanel.SetComputerLandlordIcon(false,false)
	GamePanel.SetPlayerLandlordIcon(false,false)
	GamePanel.SetOtherComputerLandlordIcon(false,false)
	
    --初始化电脑的名字和头像
    self.ComputerName:GetComponent("UILabel").text = "玩家2"
    self.ComputerHeadIcon:GetComponent("UISprite").spriteName = "touxiangnv_1"
    --初始化金钱
    self.ComputerGold = 1000000
    self.ComputerInteration:GetComponent("UILabel").text =MyCommon.SetNumFormat(self.ComputerGold)

    self.GameTextBg = transform:FindChild("Interaction/GameTextBg").gameObject
    self.GameTextBg:SetActive(false)
    self.GamePromptText = transform:FindChild("Interaction/GameTextBg/GamePromptText").gameObject
    
    self.NotBigCardPrompt = transform:FindChild("Interaction/NotBigCardPrompt").gameObject--底部没牌的提醒
    self.NotBigCardPrompt:SetActive(false)

    self.Interaction.localPosition = Vector3.New(0,0,0)--按钮面板放到游戏界面中
    
    GamePanel.SetTask(0);
    
    self.tuoguanBtn.transform:GetComponent("UIButton").isEnabled = false
    self.lastHand.transform:GetComponent("UIButton").isEnabled = false

    --比赛ui
    self.fiveMinRace = transform:FindChild("FiveMinRace").gameObject
    self.fiveMinRace:SetActive(false)
    self.fRaceInitScore = transform:FindChild("FiveMinRace/Title/Label_initscore"):GetComponent("UILabel")
    self.fRaceMultiplesNum = transform:FindChild("FiveMinRace/Title/Label_double"):GetComponent("UILabel")
    self.fRaceRanklb = transform:FindChild("FiveMinRace/Title/Label_rank"):GetComponent("UILabel")
    self.fRaceAllRank = transform:FindChild("FiveMinRace/Title/Label_allRank"):GetComponent("UILabel")
    self.fRaceTimelb = transform:FindChild("FiveMinRace/Title/Label_time"):GetComponent("UILabel")
    self.fRaceCountDownTimelb = transform:FindChild("FiveMinRace/Title/Label_othertime"):GetComponent("UILabel")

    --场均分赛
    self.jRaceSumScore = transform:FindChild("FiveMinRace/Title/Label_sumScore"):GetComponent("UILabel")
    self.jRaceAveScore = transform:FindChild("FiveMinRace/Title/Label_aveScore"):GetComponent("UILabel")
    self.jwin_lose = transform:FindChild("FiveMinRace/Title/Label_Win-Los"):GetComponent("UILabel")

    self.jdRaceAward = transform:FindChild("FiveMinRace/jdAward").gameObject
    self.jdRaceRule = transform:FindChild("FiveMinRace/jdRule").gameObject
    self.jdRaceRank = transform:FindChild("FiveMinRace/jdRank").gameObject

    self.jdRaceRank_name = transform:FindChild("FiveMinRace/jdRank/Label_name"):GetComponent("UILabel")
    self.jdRaceRank_scorce = transform:FindChild("FiveMinRace/jdRank/Label_scores"):GetComponent("UILabel")
    self.jdRaceRank_round =	transform:FindChild("FiveMinRace/jdRank/Label_round"):GetComponent("UILabel")
    self.jdRaceRank_win = transform:FindChild("FiveMinRace/jdRank/Label_win"):GetComponent("UILabel")
    self.jdRaceRank_lose = transform:FindChild("FiveMinRace/jdRank/Label_lose"):GetComponent("UILabel")
    self.jdRaceRank_rank = transform:FindChild("FiveMinRace/jdRank/Label_rank"):GetComponent("UILabel")

    self.jdPopAward = transform:FindChild("FiveMinRace/jdPopAwardPanel").gameObject
    self.jdPopAward_desc = transform:FindChild("FiveMinRace/jdPopAwardPanel/Label_Desc"):GetComponent("UILabel")
    self.jdPopAward:SetActive(false)


    --三人赛
    self.tRaceAward = transform:FindChild("FiveMinRace/tAward").gameObject
    self.tRaceAward_rank = transform:FindChild("FiveMinRace/tAward/Label_rank"):GetComponent("UILabel")
    self.tRaceAward_award = transform:FindChild("FiveMinRace/tAward/Label_award"):GetComponent("UILabel")
    self.tRaceRule = transform:FindChild("FiveMinRace/tRule").gameObject

    self.tRaceRank = transform:FindChild("FiveMinRace/tRank").gameObject
    --self.tRaceRank_rank = transform:FindChild("FiveMinRace/tRank/Label_rank"):GetComponent("UILabel")
    self.tRaceRank_name = transform:FindChild("FiveMinRace/tRank/Label_name"):GetComponent("UILabel")
    self.tRaceRank_scorce = transform:FindChild("FiveMinRace/tRank/Label_scores"):GetComponent("UILabel")

    --比赛相关按钮
    
    self.fRaceRank = transform:FindChild("FiveMinRace/Rank").gameObject
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
    	self.behaviour:AddHover(transform:FindChild("FiveMinRace/Menu/btnRank").gameObject,GamePanel.OnRankCallBack)
    else
    	self.behaviour:AddClick(transform:FindChild("FiveMinRace/Menu/btnRank").gameObject,GamePanel.OnRankCallBack)
    	--self.behaviour:AddClick(self.fRaceRank:FindChild("Sprite_bg").gameObject,GamePanel.OnCloseRank)
    	--self.behaviour:AddClick(self.tRaceRank:FindChild("Sprite_bg").gameObject,GamePanel.OnCloseRank)
    end
    
    --self.behaviour:AddHover(transform:FindChild("FiveMinRace/Menu/btnRank").gameObject,GamePanel.OnRankCallBack)

    self.fRaceRank_rank = transform:FindChild("FiveMinRace/Rank/Label_rank"):GetComponent("UILabel")
    self.fRaceRank_name = transform:FindChild("FiveMinRace/Rank/Label_name"):GetComponent("UILabel")
    self.fRaceRank_scorce = transform:FindChild("FiveMinRace/Rank/Label_scores"):GetComponent("UILabel")

    
    self.fRaceAward = transform:FindChild("FiveMinRace/Award").gameObject
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
    	self.behaviour:AddHover(transform:FindChild("FiveMinRace/Menu/btnAward").gameObject,GamePanel.OnAwardCallBack)
    else
    	self.behaviour:AddClick(transform:FindChild("FiveMinRace/Menu/btnAward").gameObject,GamePanel.OnAwardCallBack)
    	--self.behaviour:AddClick(self.tRaceAward:FindChild("Sprite_bg").gameObject,GamePanel.OnCloseAward)
    	--self.behaviour:AddClick(self.fRaceAward:FindChild("Sprite_bg").gameObject,GamePanel.OnCloseAward)

    end
    
	--self.behaviour:AddHover(transform:FindChild("FiveMinRace/Menu/btnAward").gameObject,GamePanel.OnAwardCallBack)



    self.fRaceAward_rank = transform:FindChild("FiveMinRace/Award/Label_rank"):GetComponent("UILabel")
    self.fRaceAward_award = transform:FindChild("FiveMinRace/Award/Label_award"):GetComponent("UILabel")
    
    self.fRaceRule = transform:FindChild("FiveMinRace/Rule").gameObject
    
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
    	self.behaviour:AddHover(transform:FindChild("FiveMinRace/Menu/btnRule").gameObject,GamePanel.OnRuleCallBack)
    else
    	self.behaviour:AddClick(transform:FindChild("FiveMinRace/Menu/btnRule").gameObject,GamePanel.OnRuleCallBack)
    	--self.behaviour:AddClick(self.fRaceRule:FindChild("FiveMinRace/Menu/btnRule/Sprite_bg").gameObject,GamePanel.OnCloseRule)
		--self.behaviour:AddClick(self.tRaceRule:FindChild("FiveMinRace/Menu/btnRule/Sprite_bg").gameObject,GamePanel.OnCloseRule)
    end
    
	--self.behaviour:AddHover(transform:FindChild("FiveMinRace/Menu/btnRule").gameObject,GamePanel.OnRuleCallBack)



    self.fRacetalkBtn = transform:FindChild("FiveMinRace/Menu/btnTalk").gameObject --聊天
    self.behaviour:AddClick(self.fRacetalkBtn,self.TalkCallBack)

    self.fRaceStatelb = transform:FindChild("FiveMinRace/State/Label_state"):GetComponent("UILabel")
    self.fRaceStatelb.text = ""
    self.raceTitle = transform:FindChild("FiveMinRace/Title/Sprite_title"):GetComponent("UISprite")

    self.fRaceDoubleTimer = Timer.New(GamePanel.RaceDoubleCountDown, 1, -1, true)
    self.fRaceTimer = Timer.New(GamePanel.RaceCountDown, 1, -1, true)

    self.jdmatchwaitting = transform:FindChild("Waitting").gameObject
    self.lb_jdwaitting = transform:FindChild("Waitting/Label_desc"):GetComponent("UILabel")
    self.jdwaittingtimer = Timer.New(self.CountWaittingTime,1,-1,true)
    GamePanel.SetaJDMacthWaitting(false)


    --癞子
    self.lzCard = transform:FindChild("LZPanel/cards").gameObject
    self.lzCardGrid  = transform:FindChild("LZPanel/LZView/Grid"):GetComponent("UIGrid")
   	self.behaviour:AddClick(transform:FindChild("LZPanel/LZcollider").gameObject,GamePanel.CloseLZSelect)
   	self.lzbgSize = transform:FindChild("LZPanel/bgSize"):GetComponent("UISprite")



end
function GamePanel.JDMatchEnd(str)
	transform:FindChild("JDMatchEnd").gameObject:SetActive(true)
	transform:FindChild("JDMatchEnd/Label_title"):GetComponent("UILabel").text = str
	self.behaviour:AddClick(transform:FindChild("JDMatchEnd/btnEnd").gameObject,function()
			if LRDDZ_Game.platform == PlatformType.PlatformMoble then
	        	LRDDZ_Game:BackHall()
	        else
	        	--直接退出游戏
				Application.Quit()
			end
		end)
end
function GamePanel.PopJdAward(isshow,_rank,_gold)
	self.jdPopAward:SetActive(isshow)
	if isshow == true then
		self.jdPopAward_desc.text = "恭喜您在斗地主比赛中获得第".._rank.."名\n并获得".._gold.."元宝已存入背包"
	end
end
local waittime = 0
function GamePanel.SetaJDMacthWaitting(isshow)
	--self.jdmatchwaitting:SetActive(isshow)
	if self.jdwaittingtimer ~= nil then
		self.jdwaittingtimer:Stop()
	end
	if isshow == true then
		waittime = 15
		self.CountWaittingTime()
		self.jdwaittingtimer:Start()
	end
	self.jdmatchwaitting:SetActive(isshow)
end
function self.CountWaittingTime( )
	if waittime > 0 then
		self.lb_jdwaitting.text = "正在匹配中...... 等待"..waittime.."秒"
		waittime = waittime - 1
	else
		self.lb_jdwaitting.text = "正在匹配中..."
		self.jdwaittingtimer:Stop()
	end
end
function GamePanel.SetRaceTitle(raceTitleName)
	self.raceTitle.spriteName = raceTitleName
	self.raceTitle:MakePixelPerfect()
end
function GamePanel.SetRaceState(str)
	self.fRaceStatelb.text = str
end
local rTime = 0
function GamePanel.SetRaceTime(_time)
	rTime = _time
	rTime = math.floor(rTime)
	self.fRaceTimer:Stop()
	self.fRaceTimer:Start()
end
function GamePanel.RaceCountDown()
	local min = 0
	local sce = 0
	local str = ""
	if rTime >= 0 then
		min = math.floor(rTime/60)
		sce = rTime%60
		if min <= 0 then
			str = "00:"
		elseif min < 10 then
			str = "0"..min..":"
		else
			str = min..":"
		end

		if sce <= 0 then
			str = str.."00"
		elseif sce < 10 then
			str = str.."0"..sce..""
		else
			str = str..sce
		end
		self.fRaceTimelb.text = str
		rTime = rTime - 1
	else
		self.fRaceTimelb.text = ""
		self.fRaceTimer:Stop()
	end
end
function GamePanel.SetPlayedTimes(times)
	self.fRaceTimelb.text = "第"..times.."局"
	raceRound = times
end
local dTime = 0
function GamePanel.SetDoubleTime(_time)
	dTime = _time
	
	self.fRaceDoubleTimer:Stop()
	self.fRaceDoubleTimer:Start()
end
function GamePanel.RaceDoubleCountDown()
	local str = ""
	local min = 0
	local sce = 0
	if dTime >= 0 then
		min = math.floor(dTime/60)
		sce = dTime%60

		if min <= 0 then
			str = "00:"
		elseif min < 10 then
			str = "0"..min..":"
		else
			str = min..":"
		end

		if sce <= 0 then
			str = str.."00"
		elseif sce < 10 then
			str = str.."0"..sce..""
		else
			str = str..sce
		end
		dTime = dTime - 1
		self.fRaceCountDownTimelb.text = "翻倍倒计："..str
	else
		self.fRaceDoubleTimer:Stop()
		self.fRaceCountDownTimelb.text = "翻倍倒计：00:00"
	end
	
	
end
function GamePanel.OnRankCallBack(state)
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
		if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
			self.fRaceRank:SetActive(state)
			self.fRaceAward:SetActive(false)
			self.fRaceRule:SetActive(false)
		elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
			self.tRaceRank:SetActive(state)
			self.tRaceAward:SetActive(false)
			self.tRaceRule:SetActive(false)
		elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
			self.jdRaceRank:SetActive(state)
			self.jdRaceAward:SetActive(false)
			self.jdRaceRule:SetActive(false)
		end
	else
		if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
			self.fRaceRank:SetActive(not self.fRaceRank.activeSelf)
			if self.fRaceRank.activeSelf then
				self.fRaceAward:SetActive(false)
				self.fRaceRule:SetActive(false)
			end
		elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
			self.tRaceRank:SetActive(not self.tRaceRank.activeSelf)
			if self.tRaceRank.activeSelf then
				self.tRaceAward:SetActive(false)
				self.tRaceRule:SetActive(false)
			end
		elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
			self.jdRaceRank:SetActive(not self.jdRaceRank.activeSelf)
			if self.jdRaceRank.activeSelf then
				self.jdRaceAward:SetActive(false)
				self.jdRaceRule:SetActive(false)
			end
		end
	end
end
function GamePanel.OnCloseRank( )
	self.tRaceRank:SetActive(false)
end
function GamePanel.OnAwardCallBack( state )
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then

		if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
			self.fRaceAward:SetActive(state)
			if state then
				GamePanel.SetFiveRaceAward()
				self.fRaceRank:SetActive(false)
				self.fRaceRule:SetActive(false)
			end
		elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
			self.tRaceAward:SetActive(state)
			if state then
				GamePanel.SetThreeRaceAward()
				self.tRaceRank:SetActive(false)
				self.tRaceRule:SetActive(false)
			end
		elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
			self.jdRaceAward:SetActive(state)
			self.jdRaceRank:SetActive(false)
			self.jdRaceRule:SetActive(false)
		end
	else
		if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
			self.fRaceAward:SetActive(not self.fRaceAward.activeSelf)
			if self.fRaceAward.activeSelf then
				GamePanel.SetFiveRaceAward()
			end
			if self.fRaceAward.activeSelf then
				self.fRaceRank:SetActive(false)
				self.fRaceRule:SetActive(false)
			end
		elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
			self.tRaceAward:SetActive(not self.tRaceAward.activeSelf)
			if self.tRaceAward.activeSelf then
				GamePanel.SetThreeRaceAward()
			end
			if self.tRaceAward.activeSelf then
				self.tRaceRank:SetActive(false)
				self.tRaceRule:SetActive(false)
			end
		elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
			self.jdRaceAward:SetActive(not self.jdRaceAward.activeSelf)
			if self.jdRaceAward.activeSelf then
				self.jdRaceRank:SetActive(false)
				self.jdRaceRule:SetActive(false)
			end
		end
	end
end
function GamePanel.OnCloseAward( )
	if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
			self.fRaceAward:SetActive(false)
		elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
			self.tRaceAward:SetActive(false)
		elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
			self.jdRaceAward:SetActive(false)
		end
end
function GamePanel.OnRuleCallBack( state )
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
		if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then 
			self.fRaceRule:SetActive(state)
			self.fRaceRank:SetActive(false)
			self.fRaceAward:SetActive(false)
		elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
			self.tRaceRule:SetActive(state)
			self.tRaceRank:SetActive(false)
			self.tRaceAward:SetActive(false)
		elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
			self.jdRaceRule:SetActive(state)
			self.jdRaceRank:SetActive(false)
			self.jdRaceAward:SetActive(false)
		end
	else
		if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then 
			self.fRaceRule:SetActive(not self.fRaceRule.activeSelf)
			if self.fRaceRule.activeSelf then
				self.fRaceRank:SetActive(false)
				self.fRaceAward:SetActive(false)
			end
		elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
			self.tRaceRule:SetActive(not self.tRaceRule.activeSelf)
			if self.tRaceRule.activeSelf then
				self.tRaceRank:SetActive(false)
				self.tRaceAward:SetActive(false)
			end
		elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
			self.jdRaceRule:SetActive(not self.jdRaceRule.activeSelf)
			if self.jdRaceRule.activeSelf then
				self.jdRaceRank:SetActive(false)
				self.jdRaceAward:SetActive(false)
			end
		end
	end
end
function GamePanel.OnCloseRule(  )
	if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then 
		self.fRaceRule:SetActive(false)
	elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
		self.tRaceRule:SetActive(false)
	elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
		self.jdRaceRule:SetActive(false)
	end
end
function GamePanel.SetAvatar(  )
	--初始化玩家的名字和头像
    if Avatar.avatarName ~= "" then
    	self.PlayerName:GetComponent("UILabel").text = MyCommon.SetName(Avatar.avatarName,4)
    end
    self.PlayerHeadIcon:GetComponent("UISprite").spriteName = Avatar.avatarIcon
    --初始化金钱
    if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
    	self.PlayerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Avatar.avatarGold)
    else
    	self.PlayerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Player.raceScore)
    end
end
function GamePanel.SetComputerInfo(isshow)
	if isshow == nil or isshow == true then
	    self.ComputerName:GetComponent("UILabel").text = MyCommon.SetName(Computer.name,4);
	    self.ComputerHeadIcon:GetComponent("UISprite").spriteName = "touxiangnv_1"
	    --初始化金钱
	    if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
	    	self.ComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Computer.gold)
	    else
	    	self.ComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Computer.raceScore)
	    end
	    self.ComputerName:SetActive(true)
	    --暂时
	    self.multiplesNum:SetActive(true);
	    GamePanel.ShowComputerHead(true)
	else
		self.ComputerName:GetComponent("UILabel").text = "";
		self.ComputerHeadIcon:GetComponent("UISprite").spriteName = ""
		self.ComputerInteration:GetComponent("UILabel").text = ""
		self.ComputerName:SetActive(false)
		--暂时
	    self.multiplesNum:SetActive(false);
	    GamePanel.ShowComputerHead(false)
	end
end
function GamePanel.SetOtherComputerInfo(isshow)
	if isshow == nil or isshow == true then
	    self.OtherComputerName:GetComponent("UILabel").text = MyCommon.SetName(OtherComputer.name,4);
	    self.OtherComputerHeadIcon:GetComponent("UISprite").spriteName = "touxiangnv_1"
	    --初始化金钱
	    if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
	    	self.OtherComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(OtherComputer.gold)
	    else
	    	self.OtherComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(OtherComputer.raceScore)
	    end
	    self.OtherComputerName:SetActive(true)
	    --暂时
	    self.multiplesNum:SetActive(true);
	    GamePanel.ShowOtherComputerHead(true)
	else
		self.OtherComputerName:GetComponent("UILabel").text = "";
		self.OtherComputerHeadIcon:GetComponent("UISprite").spriteName = ""
		self.OtherComputerInteration:GetComponent("UILabel").text = ""
		self.OtherComputerName:SetActive(false)
		--暂时
	    --self.multiplesNum:SetActive(false);
	    GamePanel.ShowOtherComputerHead(false)
	end 
end
function GamePanel.ShowHideCards(cards,hidedouble,isanim)
	if #cards ~= 3 then return end
	for i=1,3 do


		--[[
		if cards[i].weight >= Weight.SJoker then
			self.hideCardSprites[i].spriteName = WeightString[cards[i].weight]
		else
			self.hideCardSprites[i].spriteName = cards[i].suits
		end
		self.hideCardSprites[i].transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor[cards[i].suits]..WeightText[cards[i].weight]
		]]
		MyCommon.Set2DCard(self.hideCardSprites[i],cards[i].suits,cards[i].weight)
		--[[
		if cards[i].weight ~= Weight.SJoker and cards[i].weight ~= Weight.LJoker then
			self.hideCardSprites[i].spriteName = cards[i].suits..WeightString[cards[i].weight]
		else
			self.hideCardSprites[i].spriteName = WeightString[cards[i].weight]
		end
		]]
	end
	self.hideDouble.text = hidedouble.."倍"
	if LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
		self.hideDouble.gameObject:SetActive(false)
	else
		self.hideDouble.gameObject:SetActive(true)
	end

	coroutine.start(GamePanel.HideCardsAnim,isanim,cards,hidedouble)
end
--显示底牌动画
function GamePanel.HideCardsAnim(isanim,cards,hidedouble)
	if isanim == true then
		local Label_num = transform:FindChild("HideCardsAnim/Label-num"):GetComponent("UILabel")
		local tempCard = {}
		for i=1,3 do
			local sp = transform:FindChild("HideCardsAnim/card"..i):GetComponent("UISprite")
			local lb = sp.transform:FindChild("Label"):GetComponent("UILabel")
			local ob = {sprite = sp,label = lb}
			table.insert(tempCard,ob);
			--设置为牌背
			sp.spriteName = "SmallCardBack1"
			lb.text = ""
			sp.transform.localRotation = Quaternion.Euler(0,180,0)
		end
		--显示HideCardsAnim
		Label_num.gameObject:SetActive(false)
		self.hideCardsAnim.transform.localPosition = recHideCardsAnimPos
		--暂时去掉
		self.hideCardsAnim:SetActive(true)
		coroutine.wait(0.5)
		--翻牌
		for i=1,3 do
			iTween.RotateTo(tempCard[i].sprite.gameObject, iTween.Hash("y", 0, "time", 0.2, "islocal", true, "easetype",  iTween.EaseType.linear));
			coroutine.wait(0.05)
		end
		for i=1,3 do
			tempCard[i].sprite.spriteName = self.hideCardSprites[i].spriteName
			tempCard[i].label.text = self.hideCardSprites[i].transform:FindChild("Label"):GetComponent("UILabel").text
			coroutine.wait(0.05)
		end
		--显示特效
		ParticleManager.ShowParticle("Particle", "kuang",Vector3.one,Vector3.zero,Vector3.one,2)
		if LRDDZ_Game.matchType ~= DDZGameMatchType.JDMatch then
			Label_num.text = CardBottomRule.CalculationBottomMultiples(cards,hidedouble)--类型和倍数
			Label_num.transform.localScale = Vector3.New(5,5,5)
			Label_num.gameObject:SetActive(true)
			iTween.ScaleTo(Label_num.gameObject,iTween.Hash("scale", Vector3.New(1,1,1), "time", 0.2, "islocal", true, "easetype", iTween.EaseType.easeOutQuad))
		end
		coroutine.wait(2)
		--飞向hideCard
		iTween.MoveTo(self.hideCardsAnim,iTween.Hash("position",self.hideCard.transform.position, "time", 0.5, "islocal", false, "easetype", iTween.EaseType.linear))
		coroutine.wait(0.55)
		self.hideCardsAnim:SetActive(false)
		self.hideCardsAnim.transform.localPosition = recHideCardsAnimPos
		self.hideCard:SetActive(true)
	else
		self.hideCard:SetActive(true)
	end
end
-- function GamePanel.texiaoCall()
-- 	local rand = math.random(1,4)
-- 	if rand == 1 then
-- 		ParticleManager.PlaneFly(CharacterType.Player)
-- 	elseif rand == 2 then
-- 		ParticleManager.Boom(CharacterType.Player)
-- 	elseif rand == 3 then
-- 		ParticleManager.JokerBoom(CharacterType.Player)
-- 	elseif rand == 4 then
-- 		ParticleManager.ShowParticle("Particle", "chuntian",Vector3.New(1,1,1),Vector3.New(0,0,0),Vector3.New(0,0,0),3)
-- 	end
-- end

function GamePanel.ShowLZCards(weight,isanim)
	self.lzCardSprite.gameObject:SetActive(false)
	MyCommon.Set2DCard(self.lzCardSprite,nil,weight)
	--self.lzCardSprite.gameObject:SetActive(true)
	coroutine.start(GamePanel.ShowLZAnim,isanim)
end
function GamePanel.ShowLZAnim(isanim)
	if isanim == true then
		coroutine.wait(3)
		self.lzCardAnim:SetActive(true)
		self.lzCardAnim.transform:FindChild("Sprite_bg").gameObject:SetActive(true)
		local sp = self.lzCardAnim.transform:FindChild("lzcard"):GetComponent("UISprite")
		local lb = self.lzCardAnim.transform:FindChild("lzcard/Label"):GetComponent("UILabel")

		sp.spriteName = "SmallCardBack1"
		lb.text = ""
		local tww = sp.transform:GetComponent("iTween")
		if tww then
			destroy(tww)
		end
		sp.gameObject:SetActive(true)
		sp.transform.localRotation = Quaternion.Euler(0,180,0)
		sp.transform.localPosition = Vector3.New(0,220,0)
		sp.transform.localScale = Vector3.New(1.3,1.3,1.3)
		local rand = {}
		while #rand < 6 do
			local tempnum = math.random(1,13)
			if tableContains(rand,tempnum) == false and rand ~= GameCtrl.changeCardWeight then
				table.insert(rand,tempnum)
			end
		end
		LRDDZ_SoundManager.PlaySoundEffect("lz_turn")
		for i=1,6 do
			iTween.RotateTo(sp.gameObject, iTween.Hash("y", 0, "time", 0.1, "islocal", true, "easetype",  iTween.EaseType.linear));
			coroutine.wait(0.05)
			
			MyCommon.Set2DCard(sp.gameObject,Suits.LaiZi,rand[i])
			coroutine.wait(0.05)
			iTween.RotateTo(sp.gameObject, iTween.Hash("y", 180, "time", 0.1, "islocal", true, "easetype",  iTween.EaseType.linear));
			coroutine.wait(0.05)
			sp.spriteName = "SmallCardBack1"
			lb.text = ""
			coroutine.wait(0.05)
		end
		iTween.RotateTo(sp.gameObject, iTween.Hash("y", 0, "time", 0.2, "islocal", true, "easetype",  iTween.EaseType.linear));
		LRDDZ_SoundManager.PlaySoundEffect("lz")
		coroutine.wait(0.1)
		MyCommon.Set2DCard(sp.gameObject,nil,GameCtrl.changeCardWeight)
		coroutine.wait(0.1)
		sp.transform.localRotation = Quaternion.Euler(0,0,0)

		
		Player.SetLibrary(Player.library)
		self.lzcardEff:SetActive(true)
		coroutine.wait(1)
		self.lzCardAnim.transform:FindChild("Sprite_bg").gameObject:SetActive(false)
		iTween.MoveTo(sp.gameObject,iTween.Hash("position",self.lzCardSprite.transform.position, "time", 0.5, "islocal", false, "easetype", iTween.EaseType.linear))
		iTween.ScaleTo(sp.gameObject,iTween.Hash("scale", Vector3.New(0.6,0.6,0.6),"time", 0.5, "easetype", iTween.EaseType.linear))
		coroutine.wait(0.5)
		self.lzcardEff:SetActive(false)
		
		local tw = sp.transform:GetComponent("iTween")
		if tw then
			destroy(tw)
		end
	end
	self.lzCardSprite.gameObject:SetActive(true)
	self.lzCardAnim:SetActive(false)
	
end
function GamePanel.ShowGameObjText(foldNum)
	if LRDDZ_Game.gameType == DDZGameType.Three then
		self.GameTextBg:SetActive(false)
		return
	end
	self.GameTextBg:SetActive(true)
	if foldNum ~= nil then
		local str = nil
		if Computer.identity ~= Identity.Landlord then
			str = GameText.PlayText2
			if Computer.holdNum < 0 then Computer.holdNum = 0 end
			str = string.format(str,foldNum,Computer.holdNum)
		else
			str = GameText.PlayText1
			if Player.holdNum < 0 then Player.holdNum = 0 end
			str = string.format(str,foldNum,Player.holdNum)
		end
		self.GamePromptText:GetComponent("UILabel").text = str;
	end
	--coroutine.start(self.HidenGameObjText)
end
function GamePanel.HidenGameObjText()
	--coroutine.wait(3)
	self.GameTextBg:SetActive(false)
end 

self.isShowMultiple = false
self.MuTab = {}
function GamePanel.ShowLetCardNum(multiple,isAnimation)
	--self.letCardNum.transform:GetComponent("UILabel").text = tostring(letnum)
	
	--抢地主倍数
	if isAnimation == true then 
		if self.isShowMultiple == true then 
			table.insert(self.MuTab,multiple)
		else
			self.isShowMultiple = true
			coroutine.start(self.ShowMultiple,multiple)
		end 
		
	else 
		--火特效
		if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
			if multiple >= 24 then 
				self.multiplesEff:SetActive(true)
			else
				self.multiplesEff:SetActive(false)
			end
		end
		self.multiplesNum.transform:GetComponent("UILabel").text = tostring(multiple).."倍"

		self.fRaceMultiplesNum.text = tostring(multiple)
	end 
end 

function  GamePanel.ShowMultiple(multiple)
	-- body
	--self.BigMultiplesNum:SetActive(true)
	local clone =  NGUITools.AddChild(self.BigMultiplesNum.transform.parent.gameObject,self.BigMultiplesNum)
	clone.transform.localPosition = Vector3.New(0,-155,0)
	clone.transform.localScale = Vector3.New(2,2,2)
	clone.transform:GetComponent("UILabel").text = "× "..tostring(multiple).."倍"
	clone:SetActive(true)
	iTween.ScaleTo(clone,iTween.Hash("scale", Vector3.New(1,1,1), "time", 0.2, "islocal", true, "easetype", iTween.EaseType.linear))
	coroutine.wait(0.4)
	iTween.ScaleTo(clone,iTween.Hash("scale", Vector3.New(0.35,0.35,0.35), "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear))
	
	iTween.MoveTo(clone,iTween.Hash("position",self.multiplesNum.transform.position, "time", 0.3, "islocal", false, "easetype", iTween.EaseType.linear))

	coroutine.wait(0.5)
	self.multiplesNum.transform:GetComponent("UILabel").text = tostring(multiple).."倍"

	self.fRaceMultiplesNum.text = tostring(multiple)
	--火特效
	if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
		if multiple >= 24 then 
			self.multiplesEff:SetActive(true)
		else
			self.multiplesEff:SetActive(false)
		end
	end

	--self.BigMultiplesNum:SetActive(false)
	destroy(clone)

	self.isShowMultiple = false

	for i =1, #self.MuTab do 
		if self.MuTab[i] == multiple then
			table.remove(self.MuTab,i)
			break
		end 
	end 
	if #self.MuTab > 0 then 
		self.isShowMultiple = true
		coroutine.start(self.ShowMultiple,self.MuTab[1])
	end 
end

function GamePanel.GoBackCallBack()
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	
	local function okFunc(obj)
		if LRDDZ_Game.platform == PlatformType.PlatformMoble then
        	LRDDZ_Game:BackHall()
        else
        	--直接退出游戏
			Application.Quit()
		end
    end 
    local function cancelFunc(obj)

    end 
    if LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
    	local str = "您当前正在进行第"..raceRound.."局比赛"
    	--[[
    	if OrderCtrl.state == GameState.End then
    		str = "您当前已完成"..raceRound.."局比赛"
    	else
    		str = "您当前正在第"..raceRound.."局比赛"
    	end
    	]]
    	GamePanel.JDMatchExitTips(str,"tips:现在离开会获得较低名次，是否离开?",okFunc)
    else
    	MyCommon.CreatePrompt(GameText.ExitGame,okFunc,cancelFunc)
	end
    

end 
function GamePanel.JDMatchExitTips(titlestr,descstr,okFunc)
	local obj = transform:FindChild("JDMatchExitTips").gameObject
	self.behaviour:AddClick(transform:FindChild("JDMatchExitTips/btn_no").gameObject,function ()
		obj:SetActive(false)
		self.behaviour:RemoveClick(transform:FindChild("JDMatchExitTips/btn_no").gameObject)
		self.behaviour:RemoveClick(transform:FindChild("JDMatchExitTips/btn_yes").gameObject)
	end)
	self.behaviour:AddClick(transform:FindChild("JDMatchExitTips/btn_yes").gameObject,okFunc)
	transform:FindChild("JDMatchExitTips/Label_title"):GetComponent("UILabel").text = titlestr
	transform:FindChild("JDMatchExitTips/Label_desc"):GetComponent("UILabel").text = descstr
	obj:SetActive(true)
end

--记牌器按钮
function GamePanel.NoteCardCallBack()
	if self.NoteCardPanel.transform.localPosition.y == 450 then 
		iTween.MoveTo(self.NoteCardPanel,iTween.Hash("y",600, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.easeOutBack))		
		self.ShowNoteCard()
	else 
		iTween.MoveTo(self.NoteCardPanel,iTween.Hash("y",450, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.easeOutBack))
	end 
end 

--显示剩余的牌
function GamePanel.ShowNoteCard()
	local remaincards = DeskCardsCache.RemainCards()
	local lj=0; local sj=0; local two=0; local one=0; local k=0; local q=0; local j=0; local ten=0; 
	local nine=0; local eight=0; local seven=0; local six=0; local five=0; local four = 0 ;local three = 0 ;
	--逐一增加记牌数
	for i=1,#remaincards do
		if remaincards[i].weight == Weight.LJoker then
			lj = lj+1			
		elseif remaincards[i].weight == Weight.SJoker then
			sj = sj+1			
		elseif remaincards[i].weight == Weight.Two then
			two = two+1			
		elseif remaincards[i].weight == Weight.One then
			one = one+1			
		elseif remaincards[i].weight == Weight.King then
			k = k+1			
		elseif remaincards[i].weight == Weight.Queen then
			q = q+1			
		elseif remaincards[i].weight == Weight.Jack then
			j = j+1			
		elseif remaincards[i].weight == Weight.Ten then
			ten = ten+1			
		elseif remaincards[i].weight == Weight.Nine then
			nine = nine+1			
		elseif remaincards[i].weight == Weight.Eight then
			eight = eight+1			
		elseif remaincards[i].weight == Weight.Seven then
			seven = seven+1			
		elseif remaincards[i].weight == Weight.Six then
			six = six+1			
		elseif remaincards[i].weight == Weight.Five then
			five = five+1
		elseif remaincards[i].weight == Weight.Four then	
			four = four +1
		elseif remaincards[i].weight == Weight.Three then	
			three = three +1
		end
	end
	if LRDDZ_Game.gameType == DDZGameType.Two then
		four = 0
		three = 0
	end
	self.Note_LJcount.text = tostring(lj)
	self.Note_SJcount.text = tostring(sj)
	self.Note_2count.text = tostring(two)
	self.Note_Acount.text = tostring(one)
	self.Note_Kcount.text = tostring(k)
	self.Note_Qcount.text = tostring(q)
	self.Note_Jcount.text = tostring(j)
	self.Note_10count.text = tostring(ten)
	self.Note_9count.text = tostring(nine)
	self.Note_8count.text = tostring(eight)
	self.Note_7count.text = tostring(seven)
	self.Note_6count.text = tostring(six)
	self.Note_5count.text = tostring(five)
	self.Note_4count.text = tostring(four)
	self.Note_3count.text = tostring(three) 
end 
function GamePanel.ActiveReady(isshow)
	if isshow == false then
		self.deal:SetActive(false)
		self.showcardAtReady:SetActive(false)
	else
		if LRDDZ_Game.gameType == DDZGameType.Three then
			self.deal.transform.localPosition = Vector3.New(200,-240,0)
			self.showcardAtReady.transform.localPosition = Vector3.New(-200,-240,0)
			self.showcardAtReady:SetActive(true	)
		else
			self.deal.transform.localPosition = Vector3.New(0,-240,0)
			self.deal:SetActive(true)
			self.showcardAtReady:SetActive(false)
		end
		self.deal:SetActive(true)
	end
	
end
--发送消息
function GamePanel.DealCallBack()
	
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	CountDownPanel.CancelCountDown(false)
	
	LRDDZ_Game:UserReady();
	self.ActiveReady(false)
	Player.ShowNotice(GameText.Ready)
	

	--播放say hi 动作
	if  playanim == true then
		--判断是否有人，有人才打招呼
		if CharacterComputer.GameObject() ~= nil then
			CharacterPlayer.HiAnimator()
			LRDDZ_SoundManager.PlaySoundEffect("begin");
		end
		playanim = false
	end
end
function GamePanel.ShowCardCallBack()
	LRDDZ_Game:SendShowCardAtReady()
	GamePanel.ActiveReady(false)
	Player.ShowNotice(GameText.Ready)
	--播放say hi 动作
	if  playanim == true then
		--判断是否有人，有人才打招呼
		if CharacterComputer.GameObject() ~= nil then
			CharacterPlayer.HiAnimator()
			LRDDZ_SoundManager.PlaySoundEffect("begin");
		end
		playanim = false
	end
end
--发牌
function GamePanel.DealCards(cards)
	-- body
	print(GameCtrl.pokerlist[1].GameObject.name)
	if GameCtrl.pokerlist[1].GameObject == nil then	--还没创建好牌就按开始的bug
		return
	end
	coroutine.start(GameCtrl.DealCards,cards)
	Computer.ShowNotice("")--电脑的已准备字去
	Player.ShowNotice("")
	if LRDDZ_Game.gameType == DDZGameType.Three then
		OtherComputer.ShowNotice("")
	end

end
--出牌
function GamePanel.PlayCallBack()
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	if Player.CheckSelectCards() then 
		CountDownPanel.CancelCountDown(false)--删除玩家的倒计时功能
		self.ActivePlay(false)
	else
		--提示出牌规则不对
		Player.ShowNoRules()
	end 
end
--不出
function GamePanel.DiscardCallBack()

	--GamePanel.DoDiscard()
	--发送不出牌消息
	--if GameCtrl.isTuoguan == false then
    	LRDDZ_Game:SendPass();
    --end
    self.ActivePlay(false)
	self.yaobuqibtn:SetActive(false)

end
function GamePanel.DoDiscard()
	CountDownPanel.CancelCountDown(false)
	local rand = math.random(1,2)
	if  rand == 1 then
		CharacterPlayer.NoDealAnimator()
	else
		CharacterPlayer.NoDealAnimator1()
	end
	self.ActivePlay(false)
	self.yaobuqibtn:SetActive(false)
	Player.DisPlayCard()
	--播放音效
	local str_sex = true
	if Avatar.getAvatarSex() == 1 then
		str_sex = true
	elseif Avatar.getAvatarSex() == 2 then
		str_sex = false
	end
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"pass",Avatar.getAvatarSex() == 1)
end
--提示
function GamePanel.PromptLordCallBack()
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	Player.CancelSelcted()
	if not Player.PromptPlayCards() then 
		self.DiscardCallBack()
	end 
end
--加倍
function GamePanel.DoubleCallBack()
	--播放音效
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	CountDownPanel.CancelCountDown(false)
	GamePanel.SetRaiseButton(false);
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"double",Avatar.getAvatarSex() == 1)
	if GameCtrl.isTuoguan == false then
		LRDDZ_Game:SendRaise(1);
	end
	--播放动作
	CharacterPlayer.RobLandLordAnimator1()
	Player.ShowNotice(GameText.Double)
	
end
--不加倍
function GamePanel.DisDoubleCallBack()
	--播放音效
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	CountDownPanel.CancelCountDown(false)
	GamePanel.SetRaiseButton(false);
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"noDouble",Avatar.getAvatarSex() == 1)
	if GameCtrl.isTuoguan == false then
		LRDDZ_Game:SendRaise(0);
	end
	--播放动作
	CharacterPlayer.NoDealAnimator1()
	Player.ShowNotice(GameText.DisDouble)
end
function GamePanel.CallScoreCallBack(go)
	local callscore = 1
	if go.name == self.call1btn.name then
		callscore = 1
	elseif go.name == self.call2btn.name then
		callscore = 2
	elseif go.name == self.call3btn.name then
		callscore = 3
	end

	CountDownPanel.CancelCountDown(false)
	--播放音效
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"callscore"..callscore,Avatar.getAvatarSex() == 1)
	
	if GameCtrl.isTuoguan == false then
		LRDDZ_Game:SendCall(callscore);
	end
	self.ActiveCallBtn(false)
	--Player.ShowNotice(GameText.CallLord)
	--人物动画
	local rand = math.random(1,2)
	if  rand == 1 then
		CharacterPlayer.RobLandLordAnimator()
	else
		CharacterPlayer.RobLandLordAnimator1()
	end
end
--叫地主
function GamePanel.CallLordCallBack()
	LRDDZ_Game.isFirstCall = false
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	CountDownPanel.CancelCountDown(false)
	--播放音效
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"call",Avatar.getAvatarSex() == 1)
	
	if GameCtrl.isTuoguan == false then
		LRDDZ_Game:SendCall(1);
	end
	self.ActiveCallBtn(false)
	--OrderCtrl.GradLordTrun(false)
	Player.ShowNotice(GameText.CallLord)
	--人物动画
	local rand = math.random(1,2)
	if  rand == 1 then
		CharacterPlayer.RobLandLordAnimator()
	else
		CharacterPlayer.RobLandLordAnimator1()
	end
end

--不叫
function GamePanel.DisCallLordCallBack()
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	CountDownPanel.CancelCountDown(false)
		--播放音效
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"noCall",Avatar.getAvatarSex() == 1)

	if  GameCtrl.isTuoguan == false then
		LRDDZ_Game:SendCall(0);
	end
	--人物动画
	local rand = math.random(1,2)
	if  rand == 1 then
		CharacterPlayer.NoDealAnimator()
	else
		CharacterPlayer.NoDealAnimator1()
	end
	self.ActiveCallBtn(false)
	self.ActiveGrabLandlord(false)
	--OrderCtrl.GradLordTrun(true)
	Player.ShowNotice(GameText.DisCallLord)
end
--抢地主
function GamePanel.GrabLordCallBack(calltimes)
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	CountDownPanel.CancelCountDown(false)
	--播放音效
	local temp = 1
	if calltimes == 1 then
		temp = 1 
	elseif calltimes == 2 or calltimes == 3 then 
		temp = 2
	elseif calltimes == 4 then
		temp = 3
	end
	
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"grab"..temp,Avatar.getAvatarSex() == 1)

	if GameCtrl.isTuoguan == false then
		LRDDZ_Game:SendCall(1);
	end
	--人物动画
	if OrderCtrl.cureentTime == 4 then
		CharacterPlayer.RobLandLordAnimator()
	else
		local rand = math.random(1,2)
		if  rand == 1 then
			CharacterPlayer.RobLandLordAnimator()
		else
			CharacterPlayer.RobLandLordAnimator1()
		end
	end
	self.ActiveGrabLandlord(false)
	--OrderCtrl.GradLordTrun(false)
	Player.ShowNotice(GameText.GradLord)
end
--不抢
function GamePanel.DisgrabLordCallBack()
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	CountDownPanel.CancelCountDown(false)
		--播放音效
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"noGrab",Avatar.getAvatarSex() == 1)

	if GameCtrl.isTuoguan == false then
		LRDDZ_Game:SendCall(0);
	end
			--人物动画
	local rand = math.random(1,2)
	if  rand == 1 then
		CharacterPlayer.NoDealAnimator()
	else
		CharacterPlayer.NoDealAnimator1()
	end
	self.ActiveCallBtn(false)
	self.ActiveGrabLandlord(false)
	--OrderCtrl.GradLordTrun(true)
	Player.ShowNotice(GameText.DisGradLord)
end
--聊天
function GamePanel.TalkCallBack(go)
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	if go~=nil and (go.name == self.talkBtn.name or go.name == self.fRacetalkBtn.name) then
		self.isOpenTalkBoard = not self.isOpenTalkBoard
		if self.isOpenTalkBoard == true then
			self.talkboard:SetActive(true)
		else
			self.talkboard:SetActive(false)
		end	
		if go.name == self.fRacetalkBtn.name then
			self.fRaceAward:SetActive(false)
			self.fRaceRank:SetActive(false)
			self.fRaceRule:SetActive(false)
			self.tRaceRule:SetActive(false)
			self.tRaceRank:SetActive(false)
			self.tRaceAward:SetActive(false)
			self.jdRaceAward:SetActive(false)
			self.jdRaceRank:SetActive(false)
			self.jdRaceRule:SetActive(false)
		end
	else
		self.isOpenTalkBoard = false
		self.talkboard:SetActive(false)
	end
end
function GamePanel.TalkbarCallBack(go)
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	local id = tonumber(go.name)
	LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"talk"..id,Avatar.getAvatarSex() == 1)
	LRDDZ_Game:SendHurry(id)
	GamePanel.TalkCallBack()
	--if CharacterPlayer.Animator:GetBool("pickup") == false then
		CharacterPlayer.Talk(id)
		Player.Talk(id)
	--end
end

--展开
function GamePanel.ZhankaiCallBack()
	if self.Menu.transform.localScale.y == 1 then
		self.Menu.transform.localScale = Vector3.one
		iTween.ScaleTo(self.Menu,iTween.Hash("y",0,"time",0.3,"islocal", true,"easetype",iTween.EaseType.linear))		
		--iTween.(self.zhankai, iTween.Hash("rotation", Vector3.New(0,0,180), "time", 0.4, "islocal", true, "easetype",  iTween.EaseType.linear));
		self.zhankai.transfoRotateTorm.localRotation = Quaternion.Euler(0,0,0)
	elseif self.Menu.transform.localScale.y == 0 then
		self.Menu.transform.localScale = Vector3.New(1,0,1)
		iTween.ScaleTo(self.Menu,iTween.Hash("y",1,"time",0.3,"islocal", true,"easetype",iTween.EaseType.linear))
		--iTween.RotateTo(self.zhankai, iTween.Hash("rotation", Vector3.New(0,0,0), "time", 0.4, "islocal", true, "easetype",  iTween.EaseType.linear));
		self.zhankai.transform.localRotation = Quaternion.Euler(0,0,180)
	end
	self.isOpenTalkBoard = false
	self.talkboard:SetActive(false)
end
function GamePanel.SettingCallBack()
	--显示设置
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	local settingpane = transform.parent:FindChild("LRDDZ_SettingPanel")
	if settingpane == nil then
		LRDDZ_ResourceManager.Instance:CreatePanel('LRDDZ_SettingPanel','LRDDZ_SettingPanel',true,function(obj)
			obj:SetActive(true)
			end)
	else
		settingpane.gameObject:SetActive(true)
	end
end
function GamePanel.YaobuqiCallBack()	--要不起按钮回调
	--LRDDZ_SoundManager.PlaySoundEffect("button")
	self.DiscardCallBack()
	self.yaobuqibtn:SetActive(false)
end
local opencountdtime = 4
function GamePanel.OpenHandCallBack() --明牌
	self.openHandbtn:SetActive(false)
	--发送明牌消息
	LRDDZ_Game:SendShowCardAtDeal(opencountdtime+1)
end
--取消托管
function GamePanel.CancelHostingCallBack()
	--LRDDZ_SoundManager.PlaySoundEffect("button")
		--发送消息托管消息
		LRDDZ_Game:SendManage(false)
	self.cancelHostingbtn:SetActive(false)
end
function GamePanel.CancelHostingSucceed( )
	self.cancelHostingbtn:SetActive(false)
	--self.tuoguanBtn.transform:GetComponent("UIButton").isEnabled = true
	self.tuoguananim:SetActive(false)
	--self.tuoguanBtn.transform:GetComponent("UISprite").spriteName = "tuoguan"
	GameCtrl.CancelTuoGuo()
end
--托管
function GamePanel.TuoguanCallBack()
	if OrderCtrl.state == GameState.Before then return end


		if self.tuoguananim.activeSelf == false then
			CountDownPanel.CancelCountDown(false)
			--发送托管消息

				LRDDZ_Game:SendManage(true)
			
			--LRDDZ_SoundManager.PlaySoundEffect("button")
		else
			GamePanel.CancelHostingCallBack()
		end
	--end
end 
function GamePanel.TuoguanSucceed()
	if GameCtrl.TuoGuan() then 
		if LRDDZ_Game.gameType == DDZGameType.Three then
    		self.cancelHostingbtn.transform.localPosition = Vector3.New(0,-530,0)
	    else
	    	self.cancelHostingbtn.transform.localPosition = Vector3.New(0,-475,0)
	    end
		self.cancelHostingbtn:SetActive(true)
		--self.tuoguanBtn.transform:GetComponent("UISprite").spriteName = "tuoguanxianshi"
		--self.tuoguanBtn.transform:GetComponent("UIButton").isEnabled = false
		self.tuoguananim:SetActive(true)
		self.ActivePlay(false)
		self.yaobuqibtn:SetActive(false)
		self.SetRaiseButton(false)
		self.ActiveCallBtn(false)
	end 
end
function GamePanel.LastHandCallBack()
	--显示上一手牌
	local settingpane = transform.parent:FindChild("LastHandPanel")
	if settingpane == nil then
		LRDDZ_ResourceManager.Instance:CreatePanel('LastHandPanel','LastHandPanel',true,function(obj)
			obj:SetActive(true)
			end)
	else
		settingpane.gameObject:SetActive(true)
	end
end
--激活叫地主按钮
function GamePanel.ActiveCallBtn(isopen)
	if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
		self.callbtn:SetActive(isopen);
		self.discallbtn:SetActive(isopen)
	else
		self.call1btn:SetActive(isopen)
		self.call2btn:SetActive(isopen)
		self.call3btn:SetActive(isopen)
		self.discallbtn:SetActive(isopen)
		local pos = self.discallbtn.transform.localPosition
		self.discallbtn.transform.localPosition = Vector3.New(500,pos.y,pos.z)
	end
	
end 
--激活要不起按钮
function GamePanel.ActiveYaobuqi(isopen)
	self.yaobuqibtn:SetActive(isopen)
	--打开倒计时
	if isopen == true then
		local function func()
			self.YaobuqiCallBack()
			GamePanel.TuoguanCallBack()
		end
		
	end
end

function GamePanel.ActiveOpenHand( isopen )
	if isopen == true then
		opencountdtime = 4
		local lb = self.openHandbtn.transform:FindChild("Label"):GetComponent("UILabel")
		local function countdown()
			for i=1,3 do
				lb.text = "明牌"..opencountdtime
				opencountdtime = opencountdtime - 1
				coroutine.wait(1)
				if opencountdtime == 1 then
					self.openHandbtn:SetActive(false)
					break
				end
			end
		end
		coroutine.start(countdown)
	end
	self.openHandbtn:SetActive(isopen)
end
--激活抢地主按钮 
function GamePanel.ActiveGrabLandlord(isopen)
	if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
		self.grab:SetActive(isopen);
	else
		self.call1btn:SetActive(isopen)
		self.call2btn:SetActive(isopen)
		self.call3btn:SetActive(isopen)
		local pos = self.disgrab.transform.localPosition
		self.disgrab.transform.localPosition = Vector3.New(500,pos.y,pos.z)
	end
	self.disgrab:SetActive(isopen);
    if isopen == true then 
	    local function func()
	    	self.DisgrabLordCallBack()
	    end
	    
	end 
end 
--激活出牌按钮
function GamePanel.ActivePlay(isopen,canReject)
	
	self.play:SetActive(isopen);
	self.discard:SetActive(isopen);
	self.prompt:SetActive(isopen);
	if isopen == true then 
		self.discard:SetActive(canReject);
		self.prompt:SetActive(canReject);
		local sprite = self.play.transform:FindChild("Background").gameObject
		sprite:GetComponent("UISprite").color = Color.New(1, 1, 1, 1)
		self.play.transform:GetComponent("UIButton").isEnabled = true 
		if canReject == true then 
			self.play.gameObject.transform.localPosition =  Vector3.New(333,-240,0);
			--没有更大的牌
			if not Player.CheckCanPlay() then 
				self.play.transform:GetComponent("UIButton").isEnabled = false
				sprite:GetComponent("UISprite").color = Color.New(124/255, 124/255, 124/255, 1)
				self.ActiveNotBigCard(true)

				Player.SetColorForCard(true,false)
			else 
				self.ActiveNotBigCard(false)
				Player.SetColorForCard(false,true)
			end 
		else
			self.play.gameObject.transform.localPosition =  Vector3.New(0, -240, 0);
		end 

		local function func()
			coroutine.wait(0.12)
			self.play.transform.localScale = Vector3.one
			self.discard.transform.localScale = Vector3.one
			self.prompt.transform.localScale = Vector3.one
		end
		coroutine.start(func)
	end 

end 
--激活没有更大的牌提示字
function GamePanel.ActiveNotBigCard(value)
	self.NotBigCardPrompt:SetActive(value)
	if value == true then 
		coroutine.start(self.HidenNotBigCard)
	end 
end 
function GamePanel.HidenNotBigCard()
	coroutine.wait(1.5)
	self.ActiveNotBigCard(false)
	Player.SetColorForCard(false,true)
end 

function GamePanel.ShowBottomCards(cards,current)
	self.bottomcards = clone(cards)
	self.bottomcards =  CardRule.SortCardsFunc(self.bottomcards,true) --排序
	self.bottomcurrent = clone(current)
	coroutine.start(self.ShowBottom); 
end 
--显示底牌
function GamePanel.ShowBottom()
	local cards = self.bottomcards
	local current = self.bottomcurrent
	local vector = self.bottomCardPoint.transform.localPosition
	local count = #cards
	for i = 1, #cards do 
		if self.BottomCardList[i]== nil then 
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","CardSprite",false)
			log(obj)
			obj.transform.parent = self.bottomParent.transform;
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition =Vector3.New(vector.x +(i-2)*20,vector.y,vector.z)

			table.insert(self.BottomCardList,obj)
		end 
		--self.BottomCardList[i].transform:GetComponent("UISprite").spriteName = cards[i].cardName
		self.BottomCardList[i].transform:GetComponent("UISprite").depth = 8+ i

		--[[
		if cards[i].weight >= Weight.SJoker then
			self.BottomCardList[i].transform:GetComponent("UISprite").spriteName = WeightString[cards[i].weight]
		else
			self.BottomCardList[i].transform:GetComponent("UISprite").spriteName = cards[i].suits
		end
		self.BottomCardList[i].transform:FindChild("Label"):GetComponent("UILabel").text = SuitsColor[cards[i].suits]..WeightText[cards[i].weight]
		]]
		MyCommon.Set2DCard(self.BottomCardList[i],cards[i].suits,cards[i].weight)
		self.BottomCardList[i].transform:FindChild("Label"):GetComponent("UILabel").depth = 9+i


		self.BottomCardList[i]:SetActive(false)
	end 

	--底牌显示动画
	self.bottomBg:SetActive(true)
	self.bottomBg.transform.localScale = Vector3.New(1,1,1)
	self.bottomBg.transform.localPosition = Vector3.New(-98,-180,0)
	
	for i = 1, #cards do 
		if self.TempBottomCard[i]== nil then 
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("poker","poker","CardSprite",false)
			obj.transform.parent = self.bottomBg.transform;
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition =Vector3.New(-100 + i*50,0,0)
			table.insert(self.TempBottomCard,obj)
		end 
		self.TempBottomCard[i].transform:GetComponent("UISprite").spriteName = cards[i].cardName
		self.TempBottomCard[i].transform:GetComponent("UISprite").depth = 17+ i
	end 

	coroutine.wait(1)

	iTween.ScaleTo(self.bottomBg, Vector3.New(0.3,0.2,0.2), 0.4)
	iTween.MoveTo(self.bottomBg,iTween.Hash("position", Vector3.New(-168,12,0), "time", 0.4, "islocal", true, "easetype", iTween.EaseType.linear))

	coroutine.wait(0.5)
	for i =1, #self.TempBottomCard do 
		self.behaviour:MyDestroy(self.TempBottomCard[i])
	end 
	self.TempBottomCard = {}
	self.bottomBg:SetActive(false)
	for i =1, #self.BottomCardList do 
		self.BottomCardList[i]:SetActive(true)
	end 
	--Player.ShowCards()
end 
function GamePanel.ReSetInfo()
	--清空底牌
	self.ClearBottomCard()


	--重设按钮
	--self.ActiveReady(true)
	self.ActiveCallBtn(false)
	self.ActiveGrabLandlord(false)
	self.ActivePlay(false)
	self.ActiveYaobuqi(false)

	GamePanel.HidenGameObjText() --隐藏让牌文字

	self.SetComputerManage(false)
	self.SetOtherManage(false)

	--重设托管
	self.cancelHostingbtn:SetActive(false)
	self.tuoguanBtn.transform:GetComponent("UIButton").isEnabled = false
	self.tuoguananim:SetActive(false)
	--重设上一手牌
	self.lastHand.transform:GetComponent("UIButton").isEnabled = false
	--self.tuoguanBtn.transform:GetComponent("UISprite").spriteName = "tuoguan"
	--
	self.GameTextBg:SetActive(false)
	self.ActiveNotBigCard(false)

	--清空任务
	self.SetTask(0)
	--清空上一手牌
	LastHandPanel.ClearData()

	--设置倍数为1
	local function resetMultiples()
		coroutine.wait(0.5)
		GamePanel.ShowLetCardNum(1,1,false)
	end
	coroutine.start(resetMultiples)
	--self.multiplesNum.transform:GetComponent("UILabel").text = "× 1";--重置倍数

	GamePanel.SetPlayerLandlordIcon(false,false)
	GamePanel.SetComputerLandlordIcon(false,false)
	if LRDDZ_Game.gameType == DDZGameType.Three then
		GamePanel.SetOtherComputerLandlordIcon(false,false)
	end

	--隐藏对话
	if self.isOpenTalkBoard == true then
		GamePanel.TalkCallBack()
	end
end 
--清空底牌
function GamePanel.ClearBottomCard()
	for k,obj in pairs(self.BottomCardList) do 
		self.behaviour:MyDestroy(obj)
	end 
	self.BottomCardList = {}

	--玩家出牌列表
	for k,obj in pairs(self.playerPlayedObjList) do 
		self.behaviour:MyDestroy(obj)
	end 
	self.playerPlayedObjList = {}
	self.playerPlayedList = {}
	--电脑出牌列表
	for k,obj in pairs(self.computerPlayedObjList) do 
		self.behaviour:MyDestroy(obj)
	end 
	self.computerPlayedObjList = {}
	self.computerPlayedList = {}
	self.hideCard:SetActive(false);
	self.hideCardsAnim:SetActive(false);
end 
function GamePanel.SetRaiseButton(show)
	if GameCtrl.isTuoguan == true then
		self.doublebtn:SetActive(false);
		self.disdoublebtn:SetActive(false);
		return;
	end
	self.doublebtn:SetActive(show);
	self.disdoublebtn:SetActive(show);
end

function GamePanel.UpdateFiveMinRaceRank(messageObj)
	local body = messageObj["body"]
	local ranks = body["ranks"]
	local cn = body["cn"]
	local top10 = body["top10"]

	local rankstr = ""
	local namestr = ""
	local scorcestr = ""
	for i=1,#ranks do
		if ranks[i][1] == EginUser.Instance.nickname then
			self.fRaceRanklb.text = tostring(ranks[i][2])
			rankstr = "[FFF21C]"..tostring(ranks[i][2]).."[-]\n"
			namestr = "[FFF21C]"..MyCommon.SetName(ranks[i][1],4).."[-]\n"
			scorcestr = "[FFF21C]"..ranks[i][3].."[-]\n"
			break
		end
	end
	for i=1,#top10 do
		if i > 10 then break end
		rankstr = rankstr..i.."\n"
		namestr = namestr..MyCommon.SetName(top10[i][3],4).."\n"
		scorcestr = scorcestr..top10[i][1].."\n"
	end
	self.fRaceAllRank.text = "/"..cn
	self.fRaceRank_rank.text = rankstr
	self.fRaceRank_name.text = namestr
	self.fRaceRank_scorce.text = scorcestr
end
function GamePanel.UpdateThreeRaceRank(ranks)
	--local rankstr = "\n"
	local namestr = ""
	local scorcestr = ""
	for i=1,#ranks do
		if i > 3 then break end
		if ranks[i]["uid"] == tonumber(EginUser.Instance.uid) then
			self.fRaceRanklb.text = tostring(ranks[i]["rank"]+1)
			Player.raceScore = ranks[i]["score"]
		elseif ranks[i]["uid"] == Computer.id then
			Computer.raceScore = ranks[i]["score"]
		else
			OtherComputer.raceScore = ranks[i]["score"]
		end
		--rankstr = rankstr..(ranks[i]["rank"]+1).."\n"
		namestr = namestr..MyCommon.SetName(ranks[i]["name"],4).."\n"
		scorcestr = scorcestr..ranks[i]["score"].."\n"
	end
	
	self.fRaceAllRank.text = "/"..3
	--self.tRaceRank_rank.text = rankstr
	self.tRaceRank_name.text = namestr
	self.tRaceRank_scorce.text = scorcestr
	
	GamePanel.PlayerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Player.raceScore)
        --在GameCtrl计算了 在这里显示就可以了
    GamePanel.ComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Computer.raceScore)
    GamePanel.OtherComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(OtherComputer.raceScore)
end
function GamePanel.UpdateJDRaceRank(ranks,score,round,win,lose,rank)
	local namestr = "[FFF21C]"..MyCommon.SetName(EginUser.Instance.nickname,5).."[-]\n"
	local scorestr = "[FFF21C]"..score.."[-]\n"
	local roundstr = "[FFF21C]"..(round-1).."[-]\n"
	local winstr = "[FFF21C]"..win.."[-]\n"
	local losestr = "[FFF21C]"..lose.."[-]\n"
	local rankstr = "[FFF21C]"..rank.."[-]\n"

	for i=1,#ranks do
		scorestr = scorestr..ranks[i][1].."\n"
		namestr = namestr..MyCommon.SetName(ranks[i][4],5).."\n"
		roundstr = roundstr..ranks[i][2].."\n"
		winstr = winstr..ranks[i][5].."\n"
		losestr = losestr..ranks[i][6].."\n"
		rankstr = rankstr..i.."\n"
		if i >= 10 then
			break
		end
	end
	self.jdRaceRank_scorce.text = scorestr
	self.jdRaceRank_name.text = namestr
	self.jdRaceRank_round.text = roundstr
	self.jdRaceRank_win.text = winstr
	self.jdRaceRank_lose.text = losestr
	self.jdRaceRank_rank.text = rankstr
	for i=1,3 do
		self.jdRaceRank.transform:FindChild("Sprite_bg/Sprite_"..i).gameObject:SetActive(#ranks>=i)
	end
	

end
function GamePanel.SetFiveRaceAward()
	local awards = RacePanel.GetAwards()
	local rankstr = ""
	local awardstr = "" 
	for i=1,#awards do
		rankstr = rankstr..awards[i][1].."\n"
		awardstr = awardstr..awards[i][2].."\n"
	end
	self.fRaceAward_rank.text = rankstr
	self.fRaceAward_award.text = awardstr
end
function GamePanel.SetThreeRaceAward()
	local awards = RacePanel.GetAwards()
	local rankstr = ""
	local awardstr = "" 
	for i=1,1 do
		rankstr = rankstr..awards[i][1].."\n"
		awardstr = awardstr..awards[i][2].."\n"
	end
	self.tRaceAward_rank.text = rankstr
	self.tRaceAward_award.text = awardstr
end

function GamePanel.GameOverAnim(isshow)

	if isshow == true then
		--self.PlayerHead.transform.localPosition = playerHeadPos + Vector3.New(0,-200,0)
		self.multiplesNum.transform.localPosition = multiplesNumPos + Vector3.New(300,0,0)
		self.Menu.transform.localPosition = menuPos + Vector3.New(0,200,0)
		self.ComputerHead.transform.localPosition = computerHeadPos + Vector3.New(400,0,0)
		self.OtherComputerHead.transform.localPosition = otherComputerHeadPos + Vector3.New(-400,0,0)
		self.gobackbtn.transform.localPosition = gobackbtnPos + Vector3.New(0,200,0)
		self.initScore.transform.localPosition = initScoerPos + Vector3.New(0,-200,0)
		--播放动画
		if self.hideCard.activeSelf == true then
			self.hideCard.transform.localPosition = hideCardPos + Vector3.New(0,200,0)
			iTween.MoveTo(self.hideCard,iTween.Hash("position",hideCardPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		end
		--iTween.MoveTo(self.PlayerHead,iTween.Hash("position",playerHeadPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.multiplesNum,iTween.Hash("position",multiplesNumPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.Menu,iTween.Hash("position",menuPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.ComputerHead,iTween.Hash("position",computerHeadPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.OtherComputerHead,iTween.Hash("position",otherComputerHeadPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.gobackbtn,iTween.Hash("position",gobackbtnPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.initScore,iTween.Hash("position",initScoerPos,"time",1, "islocal", true, "easetype", iTween.EaseType.linear))
	else
		if self.hideCard.activeSelf == true then
			iTween.MoveTo(self.hideCard,iTween.Hash("position",hideCardPos + Vector3.New(0,200,0), "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		end
		--iTween.MoveTo(self.PlayerHead,iTween.Hash("position",playerHeadPos + Vector3.New(0,-200,0), "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.multiplesNum,iTween.Hash("position",multiplesNumPos + Vector3.New(300,0,0), "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.Menu,iTween.Hash("position",menuPos + Vector3.New(0,200,0), "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.ComputerHead,iTween.Hash("position",computerHeadPos + Vector3.New(400,0,0), "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.OtherComputerHead,iTween.Hash("position",otherComputerHeadPos + Vector3.New(-400,0,0), "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.gobackbtn,iTween.Hash("position",gobackbtnPos + Vector3.New(300,0,0), "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))
		iTween.MoveTo(self.initScore,iTween.Hash("position",initScoerPos + Vector3.New(0,-200,0), "time", 1, "islocal", true, "easetype", iTween.EaseType.linear))

	end
end

function GamePanel.SetInitScore(score)
	self.initScore:GetComponent("UILabel").text = score
	self.fRaceInitScore.text = tostring(score)
	MyCommon.InitScore(score)
end
function GamePanel.SetSumScore(score)
	self.jRaceSumScore.text = tostring(score)
end
function GamePanel.SetAveScore( score )
	self.jRaceAveScore.text = tostring(score)
end
function GamePanel.SetWin_Lose(_win,_lose)
	self.jwin_lose.text = _win.."/".._lose
end
function GamePanel.ShowOtherComputerHead( isshow )
	self.OtherComputerHead:SetActive(isshow)
end
function GamePanel.ShowComputerHead(isshow)
	self.ComputerHead:SetActive(isshow)
end
function GamePanel.SetTask(id,isanim,reward)
	if id == nil or id == 0 then
		self.task:SetActive(false)
		return
	else
		self.task:SetActive(true);
	end
	self.taskdesc.text = TaskText[id]
	self.taskAminLabel.text = TaskText[id]
	self.taskrewardNum.text = tostring(reward[1])
	local retype = ""
	if reward[2] == 0 then
		retype = "金币"
	elseif reward[2] == 1 then
		retype = "元宝"
	elseif reward[2] == 4 then
		retype = "张快乐卡"
	elseif reward[2] == 1051 then
		retype = "元话费"
	end
	self.taskawardtype.text = retype
	if isanim then
		self.taskAminLabel.gameObject:SetActive(true)
		local function func()
			self.taskAminLabel.transform.localScale = Vector3.New(2,2,2)
			iTween.ScaleTo(self.taskAminLabel.gameObject,iTween.Hash("scale", Vector3.New(1,1,1), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutQuad))
			coroutine.wait(2)
			self.taskAminLabel.gameObject:SetActive(false)
		end
		coroutine.start(func)
	else
		self.taskAminLabel.gameObject:SetActive(false)
	end
end
function GamePanel.FinishTask(str)
	local function func()
		self.taskfinish.transform.localScale = Vector3.New(2,2,2)
		self.taskfinishaward.text = "获得"..str
		self.taskfinish:SetActive(true)
		iTween.ScaleTo(self.taskfinish,iTween.Hash("scale", Vector3.New(1,1,1), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutQuad))
		coroutine.wait(3)
		self.taskfinish:SetActive(false)

	end
	coroutine.start(func)
end
function GamePanel.SetFoldAmin(isshow,fold)
	if isshow then
		self.foldNum.text = "抢地主"..fold.."次，让牌"..fold.."张"
		self.foldAnim:SetActive(true)
		self.foldAnim.transform.localScale = Vector3.New(2,2,2)
		iTween.ScaleTo(self.foldAnim,iTween.Hash("scale", Vector3.New(1,1,1), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutQuad))
	else
		self.foldAnim:SetActive(false)
	end
end
function GamePanel.OnDestroy( )
	Event.RemoveListener(GameEvent.ShowCallBtn, self.ActiveCallBtn)
	Event.RemoveListener(GameEvent.ShowLetNum, self.ShowLetCardNum)
	Event.RemoveListener(GameEvent.ShowGardLord, self.ActiveGrabLandlord)
	Event.RemoveListener(GameEvent.ShowPlay, self.ActivePlay)
	Event.RemoveListener(GameEvent.ShowBottomCards, self.ShowBottomCards)
	Event.RemoveListener(GameEvent.ReSetInfo, self.ReSetInfo)
	Event.RemoveListener(GameEvent.ShowGameText, self.ShowGameObjText)
	Event.RemoveListener(GameEvent.NoteCard, self.ShowNoteCard)
	Event.RemoveListener(GameEvent.NotBigCard, self.ActiveNotBigCard)
	Event.RemoveListener(GameEvent.ShowYaobuqi,self.ActiveYaobuqi)
	gameObject = nil
	transform = nil
	self.fRaceDoubleTimer:Stop()
    self.fRaceTimer:Stop()
    self.jdwaittingtimer:Stop()
end

function GamePanel.SetPlayerLandlordIcon(show,isAnim)
	if Player.identity == Identity.Landlord then
		GamePanel.PlayerIdentity:GetComponent("UISprite").spriteName = "dizhuicon";
	else
		GamePanel.PlayerIdentity:GetComponent("UISprite").spriteName = "nongmenicon";
	end
	if isAnim == true and show == true then
		local recPos = GamePanel.PlayerIdentity.transform.localPosition;
		GamePanel.PlayerIdentity.transform.localPosition = Vector3.New(910,491,0)
		GamePanel.PlayerIdentity:SetActive(show);
		--移到
		iTween.MoveTo(GamePanel.PlayerIdentity, iTween.Hash("position",recPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear));
	else
		GamePanel.PlayerIdentity:SetActive(show);
	end
end

function GamePanel.SetComputerLandlordIcon(show,isAnim)
	if Computer.identity == Identity.Landlord then
		GamePanel.ComputerIdentity:GetComponent("UISprite").spriteName = "dizhuicon";
	else
		GamePanel.ComputerIdentity:GetComponent("UISprite").spriteName = "nongmenicon";
	end
	if isAnim == true and show == true then
		local recPos = GamePanel.ComputerIdentity.transform.localPosition;
		GamePanel.ComputerIdentity.transform.localPosition = Vector3.New(-824,-205,0)
		GamePanel.ComputerIdentity:SetActive(show);
		--移到
		iTween.MoveTo(GamePanel.ComputerIdentity, iTween.Hash("position",recPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear));
	else
		GamePanel.ComputerIdentity:SetActive(show);
	end
end

function GamePanel.SetOtherComputerLandlordIcon(show,isAnim)
	if OtherComputer.identity == Identity.Landlord then
		GamePanel.OtherComputerIdentity:GetComponent("UISprite").spriteName = "dizhuicon";
	else
		GamePanel.OtherComputerIdentity:GetComponent("UISprite").spriteName = "nongmenicon";
	end
	if isAnim == true and show == true then
		local recPos = GamePanel.OtherComputerIdentity.transform.localPosition;
		GamePanel.OtherComputerIdentity.transform.localPosition = Vector3.New(806,-117,0)
		GamePanel.OtherComputerIdentity:SetActive(show);
		--移到
		iTween.MoveTo(GamePanel.OtherComputerIdentity, iTween.Hash("position",recPos, "time", 1, "islocal", true, "easetype", iTween.EaseType.linear));
	else
		GamePanel.OtherComputerIdentity:SetActive(show);
	end
	
end
function GamePanel.SetComputerManage(isshow)
	self.ComputerManageIcon:SetActive(isshow)
end
function GamePanel.SetOtherManage(isshow)
	self.OtherComputerManageIcon:SetActive(isshow)
end
local lzSelectObj = {}
local lzCards = {}
local lzCardInfo = {}
function GamePanel.LZSelect(allCards,cardinfoList)
	EginTools.ClearChildren(self.lzCardGrid.transform)
	lzSelectObj = {}
	lzCardInfo = cardinfoList
	lzCards = allCards
	self.lzCard.transform.parent.gameObject:SetActive(true)
	for i=1,#allCards do
		local clone = NGUITools.AddChild(self.lzCardGrid.gameObject,self.lzCard)
		clone.name = "lz"..tostring(i)
		clone.transform.localScale = Vector3.New(1,1,1)
		clone:SetActive(true)
		table.insert(lzSelectObj,clone)
		self.behaviour:AddClick(clone,GamePanel.LZSelectOnClick)
		local c_parent = clone.transform:FindChild("Grid")
		--创建牌
		for j=1,#allCards[i] do
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","dealCard",false)
			obj.transform.parent = c_parent;
			--obj:GetComponent("UISprite"):MakePixelPerfect()
			obj.transform.localScale = Vector3.New(0.5,0.5,0.5);
			obj.transform.localPosition =Vector3.New(0,0,0) --(i-count/2)*30

			MyCommon.Set2DCard(obj,allCards[i][j].suits,allCards[i][j].weight)
			obj.transform:FindChild("Label"):GetComponent("UILabel").depth = 4+i
			obj.transform:GetComponent("UISprite").depth = 3+ i
		end
		c_parent:GetComponent("UIGrid").repositionNow = true
		clone.transform:GetComponent("BoxCollider").size = Vector3.New(#allCards[i]*55,82,0)--Collider
	end
	self.lzbgSize.width = #allCards[1]*55+40
	self.lzbgSize.height = #allCards*86 + 40
	self.lzCardGrid.repositionNow = true
end
function GamePanel.LZSelectOnClick(go)
	error("点击"..go.name)
	local index = tonumber(string.sub(go.name, 3))
	self.lzCard.transform.parent.gameObject:SetActive(false)

	local isRule, cardsType, cardLength = CardRule.PopEnable(lzCards[index])
	coroutine.start(Player.PlayerCards,lzCardInfo,lzCards[index], cardsType,cardLength)

	CountDownPanel.CancelCountDown(false)--删除玩家的倒计时功能
	self.ActivePlay(false)


	for i=1,#lzSelectObj do
		self.behaviour:RemoveClick(lzSelectObj[i])
	end
	lzSelectObj = {}
end
function GamePanel.CloseLZSelect(  )
	self.lzCard.transform.parent.gameObject:SetActive(false)
	for i=1,#lzSelectObj do
		self.behaviour:RemoveClick(lzSelectObj[i])
	end
	lzSelectObj = {}
end