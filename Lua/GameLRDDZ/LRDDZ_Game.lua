local cjson = require "cjson"
require "System/Timer"
local this = LuaObject:New()
LRDDZ_Game = this
local windowsProcess;
this.update = false
local resDealCards = false
this.gameType = DDZGameType.Three
this.platform = PlatformType.PlatformMoble

this.nextone = 0 --用于托管取消时当前
--this.matchType = DDZGameMatchType.None

local firstApplay = true
function this:clearLuaValue()
end
function this:Awake()
	UnityEngine.Camera.main.fieldOfView = 24*16/9*Screen.height/Screen.width
	GameObject.Find("ParticleCamera"):GetComponent("Camera").fieldOfView = 24*16/9*Screen.height/Screen.width
	--this.matchType = DDZGameMatchType.None
end
function this:Start()
	print("------------------awake of LRDDZ_Game-------------")
	firstApplay = true
	this:Init();

end
function this:Init( )
		this.update = false
		--this.gameType = DDZGameType.Two--三人斗地主
		--this.gameType = DDZGameType.Three--三人斗地主
		--this.platform = PlatformType.PlatformPC;
		--this.platform = PlatformType.PlatformMoble;
		
		LRDDZ_CtrlManager.Init();
		GameCtrl.Awake()
		
end
function this:StartGameSocket( )
	--等待加载
	coroutine.wait(0.1)

	--等待时间 10秒没进入
	this.time = Timer.New(this.GoBackCallBack, 10, 0, true)
	this.time:Start()


	if this.platform == PlatformType.PlatformMoble then
		--普通手机包
		this.mono:StartGameSocket();
	else
		--平台包
		print("StartWindowsProcess")
		windowsProcess = this.gameObject:AddComponent(LuaHelper.GetType("WindowsProcess"));
		windowsProcess:AddListener(this.WindowsReceiveMessage);
		windowsProcess:init();
		--local startJson = {type="game",tag="ready",body=889297713}
		--local startJson = {type="game",tag="ready"}
		--LRDDZ_Game:SendPackage(startJson)
	end
end
function this:GoBackCallBack()
	local loadingPanel = GameObject.Find("LRDDZ_LoadPanel");
	if loadingPanel~=nil then
		destroy(loadingPanel)
	end
	local function okFunc(obj)
		if LRDDZ_Game.platform == PlatformType.PlatformMoble then
        	LRDDZ_Game:BackHall()
        else
        	--直接退出游戏
			Application.Quit()
		end
    end 
    MyCommon.CreatePrompt("网络连接失败,5秒后自动退出！",okFunc)
    coroutine.start(function() 
    	coroutine.wait(5)
    	Application.Quit()
    	end)
end 
function this:BackHall()
	coroutine.Stop()
	this.mono:OnClickBack()
end
function this.WindowsReceiveMessage( Message )
	this:SocketReceiveMessage(Message)
end
function this:SocketReceiveMessage(Message)
	
	if this.platform == PlatformType.PlatformMoble then
		Message = self;
	end
	if  Message then
		this.MessageQueue(Message)
	end
end
function this.MessageQueue(Message)
	--log("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>")
		--解析json字符串
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];
		if( typeC == "game") then
			if(tag == "enter") then
				print("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>");
				print("--------------enter-------------")
				this:ProcessEnter(messageObj)
			elseif(tag == "ready") then
				print("--------------ready-------------")
				this:ProcessReady(messageObj)
			elseif(tag == "come") then
				print("--------------come-------------")
				print("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>");
				this:ProcessCome(messageObj);
			elseif(tag == "leave") then
				print("--------------leave-------------")
				this:ProcessLeave(messageObj)
			elseif(tag == "actfinish") then
				print("--------------actfinish-------------")
			elseif(tag == "deskover") then
				print("--------------deskover-------------")
			elseif(tag == "notcontinue")then
				print("--------------notcontinue-------------")
			elseif(tag == "manage") then
				print("--------------manage-------------")
				print("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>");
				this:ProcessManage(messageObj)
			elseif(tag == "changedesk") then
				print("--------------changedesk-------------")
				print("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>");
			elseif(tag == "emotion") then
				print("--------------emotion-------------")
				print("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>");
			elseif(tag == "hurry") then
				print("--------------hurry-------------")
				print("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>");
				this:ProcessHurry(messageObj)
			elseif(tag == "taskfinish") then
				print("--------------taskfinish-------------")
				this:ProcessTaskFinish(messageObj)
			end
			--两人斗地主
		elseif typeC=="erddz" or typeC == "ddz" then
			print("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>");
			--if CharacterComputer.GameObject() == nil and tag ~= "update" and tag ~= "gameover" and tag ~= "showcard" then 
			if CharacterComputer.GameObject() == nil and tag ~= "update" and tag ~= "showcard" then 
				--error("!!!!!!!!!!!!!!!!!reture"..Message)
				local function func( Message )
					coroutine.wait(0.1)
					this.MessageQueue(Message)
				end
					coroutine.start(func,Message)
				return 
			end


			if tag=="call" then
				print("-------------call------------");
				this:ProcessCall(messageObj)
			elseif tag=="time" then	
				print("-------------time------------");
			elseif tag=="late" then	
				print("-------------late------------");
			elseif tag=="startraise" then
				print("-------------startraise------------");
				this:ProcessStartraise(messageObj)
			elseif tag == "startplay" then
				print("-------------startplay------------");
				this:ProcessStartPlay(messageObj)
			elseif tag=="raise" then
				print("-------------raise------------");
				this:ProcessRaise(messageObj)
			elseif tag=="show" then
				print("-------------show------------");
			elseif tag == "deal" then --发牌
				print("-------------deal------------");
				this:ProcessDeal(messageObj);
			elseif tag == "play" then
				print("-------------play------------");
				this:ProcessPlay(messageObj)
			elseif tag == "pass" then
				print("-------------pass------------");
				this:ProcessPass(messageObj)
			elseif tag == "gameover" then
				print("-------------gameover------------");
				this:ProcessGameover(messageObj)	
			elseif tag == "update" then
				print("-------------update------------");
				coroutine.start(this.ProcessUpdate,this,messageObj)
			elseif tag == "showcard" then
				print("-------------showcard------------");
				this:ProcessShowDeck(messageObj)
			elseif tag == "showcard_2" then
				print("-------------showcard_2------------");
				this:ProcessShowDeckAtDeal(messageObj)
			elseif tag == "allcards" then
				print("-------------allcards------------");
				--this:ProcessAllCards(messageObj)
			end
		elseif typeC=="ddz7" then
			print("-><color=#00ff00>".."ReceiveMessage"..Message.."</color>");
			if tag == "apply" then
				print("-------------apply------------");
				this:ProcessApply(messageObj)
			elseif tag == "newcn" then
				this:ProcessNewcn(messageObj)
			elseif tag == "kick" then
				print("-------------kick------------");
				this:ProcessKick(messageObj)
			elseif tag == "waitstart" then
				print("-------------waitstart------------");
				this:ProcessWaitstart(messageObj)
			elseif tag == "unitgrowtip" then
				print("-------------unitgrowtip------------");
				this:ProcessUnitgrowtip(messageObj)
			elseif tag == "step1start" then
				print("-------------step1start------------");
				this:ProcessStep1start(messageObj)
			elseif tag == "deskover" then
				print("-------------deskover------------");	
				this:ProcessDeskover(messageObj)
			elseif tag == "unitgrow_start" then 
				this:ProcessUnitgrowStart(messageObj)
			elseif tag == "newranks" then
				print("-------------newranks------------");	
				this:ProcessNewRanks(messageObj)
			elseif tag == "sendaward" then
				print("-------------sendaward------------");
				this:ProcessSendAward(messageObj)
			elseif tag == "waitingstep2" then
				print("-------------waitingstep2------------");
				this:ProcessWaitingstep2(messageObj)
			elseif tag == "wait_step2" then
				print("-------------wait_step2------------");
				this:ProcessWaitStep2(messageObj)
			elseif tag == "wait_over" then
				print("-------------wait_over------------");
				this:ProcessWaitOver(messageObj)
			elseif tag == "recheckin" then
				print("-------------recheckin------------");
				this:ProcessRecheckin(messageObj)
			elseif tag == "start" then
				print("-------------start-------------")
				this:ProcessStart(messageObj)
			elseif tag == "ready_ok" then
				this:ProcessReady_Ok(messageObj)
			elseif tag == "ready_fail" then
				this:ProcessReady_Fail(messageObj)
			elseif tag == "ready_max" then
				this:ProcessReadyMax(messageObj)
			end
		elseif typeC=="ddz9" then
			print("-><color=#00ff00>".."ReceiveMessageddz9"..Message.."</color>");
			if tag == "apply" then
				print("-------------apply------------");
				this:ProcessThreeApply(messageObj)
			elseif tag == "recheckin" then
				print("-------------recheckin------------");
				this:ProcessRecheckin(messageObj)
			elseif tag == "newcn" then
				print("-------------newcn------------");
				this:ProcessNewcn_Three(messageObj)
			elseif tag == "newranks" then
				print("-------------newranks------------");
				--this:ProcessNewRanks_Three(messageObj)
				this:ProcessNewRanks_Three(messageObj)
			elseif tag == "groupover" then
				print("-------------groupover------------");
				this:ProcessGroupover(messageObj)
			elseif tag == "roundover" then
				print("-------------roundover------------");
				this:ProcessRoundover(messageObj)
			end
		end
end
--本地卡牌转服务器点数
function this.CardToServer(cards)
	if cards == nil then return nil end
	local returnCards = {};
	for i=1,#cards do
		local mul = 0;
		if cards[i].suits == Suits.Diamond then
			mul = 0;
		elseif cards[i].suits == Suits.Club then
			mul = 1;
		elseif cards[i].suits == Suits.Heart then
			mul = 2;
		elseif cards[i].suits == Suits.Spade then
			mul = 3;
		else
			--两个鬼
			mul = 3;
		end
		table.insert(returnCards,mul*13+cards[i].weight-1);
	end
	return returnCards;
end
--服务器卡牌点数转成本地卡牌点数
function this.ServerToCard(cards,charactortype)
	if cards == nil then return nil end 
	local returnCards = {};
	for i=1,#cards do
		--判断是否是大小鬼 
		if cards[i] == 52 or cards[i] == 53 then
			if cards[i] == 52 then
				table.insert(returnCards,Card.New("SJoker",Weight.SJoker, Suits.None,charactortype))
			else
				table.insert(returnCards,Card.New("LJoker",Weight.LJoker, Suits.None,charactortype))
			end
		else
			local weight = math.mod(cards[i],13) + 1 ;
			local suitsNum = math.floor(cards[i]/13);
			local suits;
			if suitsNum == 0 then
				suits = Suits.Diamond;
			elseif suitsNum == 1 then
				suits = Suits.Club;
			elseif suitsNum == 2 then
				suits = Suits.Heart;
			elseif suitsNum == 3 then
				suits = Suits.Spade;	
			end
			local card = Card.New(suits..WeightString[weight],weight,suits,charactortype)

			table.insert(returnCards,card);
		end
		
	end
	return returnCards;
end



-------向服务器发送消息---------
--准备
function LRDDZ_Game:UserReady()
	--组装好数据调用C#发送函数
	local startJson = nil
	if this.matchType ~= DDZGameMatchType.JDMatch then
		if this.gameType == DDZGameType.Three then
			--  { 'tag': 'continue', 'type': 'game'}
			startJson = {type="game",tag="continue"};    --最终产生json的表
		else
			startJson = {type="game",tag="ready",body =tonumber(EginUser.Instance.uid)};    --最终产生json的表
		end
	else
		startJson = {type="ddz",tag="ready",body =1};
	end
	--将表数据编码成json字符串
	LRDDZ_Game:SendPackage(startJson)
end
--叫地主{'type':'erddz', 'tag':'call', 'body': 0或1}
function LRDDZ_Game:SendCall(call)
	local gametype = "erddz"
	if this.gameType == DDZGameType.Three then
		gametype = "ddz"
	end
	local startJson = {type=gametype,tag="call",body=call}
	LRDDZ_Game:SendPackage(startJson)
	this.nextone = 0
end
-- 过{'type':'erddz', 'tag':'pass'} 
function LRDDZ_Game:SendPass(  )
	local gametype = "erddz"
	if this.gameType == DDZGameType.Three then
		gametype = "ddz"
	end
	local startJson = {type=gametype,tag="pass"}
	LRDDZ_Game:SendPackage(startJson)
	this.nextone = 0
end
--出牌
function LRDDZ_Game:SendPlay(cards)
	local gametype = "erddz"
	if this.gameType == DDZGameType.Three then
		gametype = "ddz"
	end
	local startJson = {type=gametype,tag="play",body=this.CardToServer(cards)}
	LRDDZ_Game:SendPackage(startJson)
	this.nextone = 0
end
function LRDDZ_Game:SendLZPlay(_cards,_lz_card,_tar_card)
	local gametype = "erddz"
	if this.gameType == DDZGameType.Three then
		gametype = "ddz"
	end
	m_tar_card = this.CardToServer(_tar_card)
	local check = true
	while check do
		local docheck = false
		for i=1,#m_tar_card do
			for j=1,#m_tar_card do
				if i ~= j and m_tar_card[i] ==  m_tar_card[j] then
					if m_tar_card[i] <= 38 then 
						m_tar_card[i] = m_tar_card[i] + 13
					else
						m_tar_card[i] = m_tar_card[i] - 39
					end
					docheck = true
				end
			end
		end
		check = docheck
	end
	local startJson = {type=gametype,tag="play",body={card=this.CardToServer(_cards),lz_card=this.CardToServer(_lz_card),tar_card=m_tar_card}}
	LRDDZ_Game:SendPackage(startJson)
	this.nextone = 0
end
function LRDDZ_Game:SendRaise(raise)
	local gametype = "erddz"
	if this.gameType == DDZGameType.Three then
		gametype = "ddz"
	end
	local startJson = {type=gametype,tag="raise",body=raise}
	LRDDZ_Game:SendPackage(startJson)
	this.nextone = 0
end
function LRDDZ_Game:SendManage(ismanage)
	--不能再出牌
	--Event.Brocast(GameEvent.ShowPlay,false,false)
	GamePanel.ActivePlay(false)
	local startJson = {type="game",tag="manage",body=ismanage}
	LRDDZ_Game:SendPackage(startJson)
end
--{type:game, tag:changedesk}换桌
function LRDDZ_Game:SendChangedesk()
	GameCtrl.isChangeDesk = true
	local startJson = {type="game",tag="changedesk"}
	LRDDZ_Game:SendPackage(startJson)
end
function LRDDZ_Game:SendEmotion(id)
	local startJson = {type="game",tag="emotion",body=id}
	LRDDZ_Game:SendPackage(startJson)
end
function LRDDZ_Game:SendHurry(id)
	--{"type":"game","tag":"hurry","body":{"hurry_index":6}}
	local startJson = {type="game",tag="hurry",body={hurry_index=id}}
	LRDDZ_Game:SendPackage(startJson)
end
--准备时明牌
function LRDDZ_Game:SendShowCardAtReady()
	local gametype = "erddz"
	if this.gameType == DDZGameType.Three then
		gametype = "ddz"
	end
	local startJson = {type=gametype,tag="showcard_1",body={tonumber(EginUser.Instance.uid),true}}
	LRDDZ_Game:SendPackage(startJson)
end
--明牌
function LRDDZ_Game:SendShowCardAtDeal(num)
	local gametype = "erddz"
	if this.gameType == DDZGameType.Three then
		gametype = "ddz"
	end
	local startJson = {type=gametype,tag="showcard_2",body=num}
	LRDDZ_Game:SendPackage(startJson)
end
function LRDDZ_Game:SendReapply()
	
	local startJson = {type="game",tag="reapply",body=""}
	LRDDZ_Game:SendPackage(startJson)
end
function LRDDZ_Game:SendPackage(startJson)
	local jsonStr = cjson.encode(startJson);
	if this.platform == PlatformType.PlatformMoble then
		this.mono:SendPackage(jsonStr)
	else
		windowsProcess:SendPackage(jsonStr);
	end
end


local racePanel = nil --比赛报名界面
--场景中第一位其他玩家的position
local firstComputerPos = 1;
----JSON解析后分发函数----
--{"body": {"memberinfos": [{"uid": 118405, "stream": "", "bag_money": 986021, "into_money": 986021, "is_staff": 0, "ready": true, 
--"client_address": "山西省太原市", "wzcardnum": 0, "winning": 64, "waiting": true, "vip_level": 0, "avatar_img": "", 
--"lose_times": 58, "win_times": 107, "mobile_type": 0, "avatar_no": 18, "keynum": 0, "nickname": "苏格拉底的沉默", "active_point": 0, "level": 0, 
--"exp": 6147, "position": 0}, {}}, "tag": "enter", "type": "game"}
function this:ProcessEnter(messageObj)
	--停止倒计时
	this.time:Stop();
	local body = messageObj["body"];
	local memberinfos = body["memberinfos"];
	--播放背景音乐
	local audioSource = LRDDZ_MusicManager.instance.GetAudioSource
	if audioSource == nil or audioSource.clip.name == "bgsound4" or audioSource.clip.name == "bgsound5" then
		local rand = math.random(1,3);
		LRDDZ_MusicManager.instance:PlayMuisc("bgsound"..rand, true, true, false, 0.5)
	end
	if this.platform == PlatformType.PlatformPC then
		EginUser.Instance.uid = windowsProcess.uid
	end
	local maxPlayerNum = body["deskinfo"]["max_player_num"]
	if maxPlayerNum == nil then
		maxPlayerNum = 3
	end
	--判断是两人还是三人斗地主
	if maxPlayerNum == 2 then 
		this.gameType = DDZGameType.Two
	else
		this.gameType = DDZGameType.Three
	end
	this:SwitchGameType(this.gameType)
	--设置位置

	for i=1,#memberinfos do
		if memberinfos[i]["uid"] == tonumber(EginUser.Instance.uid) then
			local playerPos = memberinfos[i]["position"]

			firstComputerPos = playerPos + 1
			if firstComputerPos >= maxPlayerNum then
				firstComputerPos = 0
			end
		end
	end
	for i=1,#memberinfos do
		
		if memberinfos[i]["uid"] == tonumber(EginUser.Instance.uid) then
			--玩家信息
			local playerInfos = memberinfos[i];
			EginUser.Instance.bagMoney = playerInfos["bag_money"];
			EginUser.Instance.avatarNo = playerInfos["avatar_no"];
			EginUser.Instance.nickname = playerInfos["nickname"];
			EginUser.Instance.level = playerInfos["level"];
			Avatar.Init()
			if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
				Player.raceScore = playerInfos["score"] or 0
				--一开始的排名
				RaceRankAnimationPanel.SetOldRank(playerInfos["rank"])
			elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
				Player.raceScore = playerInfos["sum_score"] or 0

				--显示排名
				GamePanel.UpdateJDRaceRank(body["top50"],playerInfos["ave_score"],playerInfos["round"],playerInfos["win_round"],playerInfos["fail_round"],playerInfos["rank"])
				GamePanel.SetWin_Lose(playerInfos["win_round"],playerInfos["fail_round"])
				GamePanel.SetAveScore(playerInfos["ave_score"])
				GamePanel.SetPlayedTimes(playerInfos["round"])
				GamePanel.SetSumScore(playerInfos["sum_score"])
			end
			GamePanel.SetAvatar()
		elseif(memberinfos[i]["position"] == firstComputerPos) then
			--对家或电脑信息
			Computer.id = memberinfos[i]["uid"];
			Computer.name = memberinfos[i]["nickname"]
			Computer.sex = memberinfos[i]["avatar_no"]
			Computer.level =  memberinfos[i]["level"]
			Computer.gold = memberinfos[i]["into_money"]
			if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
				Computer.raceScore = memberinfos[i]["score"] or 0
			elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
				Computer.raceScore = memberinfos[i]["sum_score"] or 0
			end
			local ready = memberinfos[i]["ready"]
			if ready == true then
				Computer.ShowNotice(GameText.Ready);
			end
			--[[
			if ready == true then
				Computer.ShowNotice(GameText.Ready);
				
				Computer.SetComputerState(0)
			else
				Computer.ShowNotice("");
				Computer.SetComputerState(2)
			end
			]]
			--性别
			if memberinfos[i]["avatar_no"]%2 == 0 then 
				Computer.sex = 1;
			else
				Computer.sex = 2;
			end
			--创建模型
			GameCtrl.CreaterCharacterComputer()
			GamePanel.SetComputerInfo()
		else
			OtherComputer.id = memberinfos[i]["uid"];
			OtherComputer.name = memberinfos[i]["nickname"]
			OtherComputer.sex = memberinfos[i]["avatar_no"]
			OtherComputer.level =  memberinfos[i]["level"]
			OtherComputer.gold = memberinfos[i]["into_money"]
			if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
				OtherComputer.raceScore = memberinfos[i]["score"] or 0
			elseif LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
				OtherComputer.raceScore = memberinfos[i]["sum_score"] or 0
			end
			local ready = memberinfos[i]["ready"]
			if ready == true then
				OtherComputer.ShowNotice(GameText.Ready);
			end
			if memberinfos[i]["avatar_no"]%2 == 0 then 
				OtherComputer.sex = 1;
			else
				OtherComputer.sex = 2;
			end
			--创建模型
			GameCtrl.CreaterCharacterOtherComputer()
			GamePanel.SetOtherComputerInfo()
		end
	end
	--设置显示底分
	GamePanel.SetInitScore(body["deskinfo"]["unit_money"])
	--加载人物等资源
	GameCtrl.OtherResources()
	ParticleManager.Init()
	if this.matchType == DDZGameMatchType.FiveMinute then
    	GamePanel.SetRaceTime(body["deskinfo"]["matchtime"])
	elseif this.matchType == DDZGameMatchType.ThreeMatch then
		--显示第几局
		GamePanel.SetPlayedTimes(body["deskinfo"]["playedtimes"]+1)
		--GamePanel.UpdateThreeRaceRank(messageObj["deskinfo"]["ranks"])
		if racePanel ~= nil then
			destroy(racePanel)
			racePanel = nil
		end
	elseif this.matchType == DDZGameMatchType.JDMatch then
		--
		GamePanel.SetaJDMacthWaitting(false)

		if racePanel ~= nil then
			destroy(racePanel)
			racePanel = nil
		end
    end
    --癞子界面设置
    if this.matchType == DDZGameMatchType.LZMatch then 
		this:ShowLZRaceUI()
	end
end
local waitCreatModel = false
local waitCreatOtherModel = false

--{"body": {"memberinfo": {"uid": 121307, "stream": "", "bag_money": 968123, "into_money": 968123, "is_staff": 0, 
--"ready": false, "client_address": "安徽省宿州市", "wzcardnum": 0, "winning": 33, "waiting": true, "vip_level": 0, 
--"avatar_img": "", "lose_times": 107, "win_times": 55, "mobile_type": 0, "avatar_no": 13, "keynum": 0, 
--"nickname": "超级兔子王", "active_point": 0, "level": 0, "exp": 7, "position": 0}}, "tag": "come", "type": "game"}
function this:ProcessCome(messageObj)
	--对家或电脑信息
	local memberinfo = messageObj["body"]["memberinfo"];
	if memberinfo["position"] == firstComputerPos then
		Computer.id = memberinfo["uid"];
		Computer.name = memberinfo["nickname"]
		Computer.sex = memberinfo["avatar_no"]
		Computer.level =  memberinfo["level"]
		Computer.gold = memberinfo["into_money"]
		--性别
		if memberinfo["avatar_no"]%2 == 0 then 
			Computer.sex = 1;
		else
			Computer.sex = 2;
		end


		--如果还有模型在先删除，再创建 
		if CharacterComputer.GameObject() ~= nil then
			--destroy(CharacterComputer.gameObject)
			CharacterComputer.Leave()
			GamePanel.SetComputerInfo(false);
			Computer.ShowNotice("");
		end
		if GameCtrl.GetComputerModelState() == false then
			print("直接创建")
			--创建模型
			GameCtrl.CreaterCharacterComputer()
			GamePanel.SetComputerInfo()
		else
			--上个模型创建完，再删除后再创建
			print("上个模型创建完，再删除后再创建")
			waitCreatModel = true
		end

	else
		--第二位其他玩家
		OtherComputer.id = memberinfo["uid"];
		OtherComputer.name = memberinfo["nickname"]
		OtherComputer.sex = memberinfo["avatar_no"]
		OtherComputer.level =  memberinfo["level"]
		OtherComputer.gold = memberinfo["into_money"]
		--性别
		if memberinfo["avatar_no"]%2 == 0 then 
			OtherComputer.sex = 1;
		else
			OtherComputer.sex = 2;
		end

		
		--如果还有模型在先删除，再创建 
		if CharacterOtherComputer.GameObject() ~= nil then
			--destroy(CharacterComputer.gameObject)
			CharacterOtherComputer.Leave()
			GamePanel.SetOtherComputerInfo(false);
			OtherComputer.ShowNotice("");
		end
		if GameCtrl.GetOtherComputerModelState() == false then
			print("直接创建")
			--Computer.SetComputerState(2)
			--创建模型
			GameCtrl.CreaterCharacterOtherComputer()
			GamePanel.SetOtherComputerInfo()
		else
			--上个模型创建完，再删除后再创建
			print("上个模型创建完，再删除后再创建")
			waitCreatOtherModel = true
		end
	end
end
function this:ProcessLeave(messageObj)

	local uid = messageObj["body"];
	if this.platform == PlatformType.PlatformMoble and GameCtrl.isChangeDesk == true and uid == tonumber(EginUser.Instance.uid) then --换桌
		GameCtrl.isChangeDesk = false;
		--返回到选桌界面
		this:ChangeDesk()
        return
	end
	
	if uid == tonumber(EginUser.Instance.uid) then
		--退出游戏

		--this:GoBackCallBack();

		local loadingPanel = GameObject.Find("LRDDZ_LoadPanel");
		if loadingPanel~=nil then
			destroy(loadingPanel)
		end
		local function okFunc(obj)
			if LRDDZ_Game.platform == PlatformType.PlatformMoble then
	        	LRDDZ_Game:BackHall()
	        else
	        	--直接退出游戏
				Application.Quit()
			end
	    end 
	    MyCommon.CreatePrompt("长时间未继续，已退出牌桌，5秒后自动关闭！",okFunc)
	    coroutine.start(function() 
    	coroutine.wait(5)
    	if LRDDZ_Game.platform == PlatformType.PlatformMoble then
    		LRDDZ_Game:BackHall()
    	else
    		Application.Quit()
    	end
    	end)
	end
	if uid == Computer.id then
		coroutine.start(this.DelectCharterComputer)
	elseif uid == OtherComputer.id then
		coroutine.start(this.DelectOtherCharterComputer)
	end
end
function LRDDZ_Game:ChangeDesk()
	--返回到选桌界面
	coroutine.Stop()
	SocketConnectInfo.Instance.roomFixseat = true;
    SocketConnectInfo.Instance.roomHost = "";
    Game.socketManager.socketListener = null;
    Game.socketManager:Disconnect("Exit from the game.");
    Utils.LoadLevelGUI("Module_Desks");
    --local messageObj = {type="seatmatch",tag= "sit",body= {"0",-1}} 
	--SocketManager.Instance:SendPackage(cjson.encode(messageObj));

    
end

function this:DelectCharterComputer()
	if CharacterComputer.GameObject() ~= nil then
		print("直接删除")
		CharacterComputer.Leave()
		Computer.ShowNotice("");
		GamePanel.SetComputerInfo(false);
		coroutine.wait(0.01)
	else
		print("等待删除..")
		while true do
			if CharacterComputer.GameObject() ~= nil then
				CharacterComputer.Leave()
				Computer.ShowNotice("");
				GamePanel.SetComputerInfo(false);
				coroutine.wait(0.01)
				break
			else
				coroutine.wait(0.5)
			end
		end
	end
	--删除模型后，判断删除其期是否有新模型要创建
	if waitCreatModel == true then
		print("等待删除再创建")
		waitCreatModel = false
		--创建模型
		GameCtrl.CreaterCharacterComputer()
		GamePanel.SetComputerInfo()
	end
end
function this:DelectOtherCharterComputer()
	if CharacterOtherComputer.GameObject() ~= nil then
		print("直接删除")
		CharacterOtherComputer.Leave()
		OtherComputer.ShowNotice("");
		GamePanel.SetOtherComputerInfo(false);
		coroutine.wait(0.01)
	else
		print("等待删除..")
		while true do
			if CharacterOtherComputer.GameObject() ~= nil then
				CharacterOtherComputer.Leave()
				OtherComputer.ShowNotice("");
				GamePanel.SetOtherComputerInfo(false);
				coroutine.wait(0.01)
				break
			else
				coroutine.wait(0.5)
			end
		end
	end
	--删除模型后，判断删除其期是否有新模型要创建
	if waitCreatOtherModel == true then
		print("等待删除再创建")
		waitCreatOtherModel = false
		--创建模型
		GameCtrl.CreaterCharacterOtherComputer()
		GamePanel.SetOtherComputerInfo()
	end
end
local recLZCard = nil
function this:ProcessDeal(messageObj)
	--我的17张牌
	local mycards = messageObj["body"]["mycards"];
	--测试用
	--mycards = {52,51,11+13,10+13,10,9,9+13,8,8+13,8+26,7,6,5,5+13,3,2,2+13}
	local cards = this.ServerToCard(mycards,charactortype)
	local timeout = messageObj["body"]["timeout"]
	local banker = messageObj["body"]["banker"]
	local taskid = messageObj["body"]["task_id"]
	local taskreward = messageObj["body"]["task_reward"]

	local lz_rank = messageObj["body"]["lz_rank"] --癞子值
	if lz_rank ~= nil then
		recLZCard = this.ServerToCard({lz_rank})[1].weight
		error("癞子"..lz_rank)
	end
	if taskid == nil then
		taskid = 0
	end
	OrderCtrl.state = GameState.GradLord
	GamePanel.SetRaceState("")
	
	local function dealySetTask()
		coroutine.wait(2)
		GamePanel.SetTask(taskid,true,taskreward)
	end
	coroutine.start(dealySetTask)
	--倒计时
	--[[
	if banker ==tonumber(EginUser.Instance.uid) then
		CountDownPanel.OpenCountDown(CharacterType.Player,timeout,this.Tuoguan)
		--显示叫地主
		GamePanel.ActiveCallBtn(true)
	else
		CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
		--等待叫地主
	end
	]]


	--三人斗地主有个重新开牌 回收玩家和电脑手中的牌，重新发牌
	--模型牌
	if resDealCards == true then
		CharacterPlayer.ResDealCards()
		CharacterComputer.ResDealCards()
		CharacterOtherComputer.ResDealCards()
		Deck.CreateDeck()
		DeskCardsCache.RemainCards(Deck.GetLibrary())
		GamePanel.CancelHostingSucceed()
		Computer.Reset()
		OtherComputer.Reset()
		GamePanel.ActiveOpenHand(false)
		GamePanel.ActiveCallBtn(false)
		GamePanel.ActiveGrabLandlord(false)
	end
	Computer.ShowNotice("")
	Player.ShowNotice("")
	coroutine.start(this.DelayShowCallBtn,this,timeout,banker)
	for i=1,#cards do
		Player.AddCard(cards[i]);
	end
	--发牌
	 GamePanel.DealCards(cards);
	 this.isFirstCall = true
	 --刷新记牌器
	 Event.Brocast(GameEvent.NoteCard)
	local function func()
		coroutine.wait(4)
		DeskCardsCache.RemoveCardsInRemainCards(this.ServerToCard(mycards))
		Event.Brocast(GameEvent.NoteCard)
	end
	coroutine.start(func) --减掉玩家手中的牌

	if racePanel ~= nil then
		destroy(racePanel)
		racePanel = nil
	end
end
function this:DelayShowCallBtn(timeout,banker)
	coroutine.wait(2) 
	Computer.SetComputerState(0)
	coroutine.wait(3) 

	--隐藏明牌按钮
	GamePanel.ActiveOpenHand(false)
	if banker == tonumber(EginUser.Instance.uid) then
		CountDownPanel.OpenCountDown(CharacterType.Player,timeout,this.Tuoguan)
		--显示叫地主
		if GameCtrl.isTuoguan == false then
			GamePanel.ActiveCallBtn(true)
		end
	elseif banker == Computer.id then
		CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
	else
		CountDownPanel.OpenCountDown(CharacterType.OtherComputer,timeout)
	end
	--自动下局
	if MyCommon.GetAutoReady() == true then
	 	--托管
	 	--LRDDZ_Game:SendManage(true)
	end
	 --设置可点击
	Player.EnableTouchCards(true)
	 --设置托管按钮可点击
	GamePanel.tuoguanBtn.transform:GetComponent("UIButton").isEnabled = true
	GamePanel.lastHand.transform:GetComponent("UIButton").isEnabled = true
end
this.isFirstCall = true --是否第一次叫地主
--叫地主
function this:ProcessCall(messageObj)
	local body = messageObj["body"];
	local thisone = body["thisone"];
	local callpt = body["callpt"];
	local nextone = body["nextone"];
	local timeout = body["timeout"]
	local calltimes = body["call_times"]
	local double = body["double"]
	local foldnum = body["fold_num"]
	if foldnum == nil then foldnum = 0 end;
	
	this.nextone = nextone
	resDealCards = true
	if CharacterComputer.GameObject() == nil then
		GameCtrl.CreaterCharacterComputer()
		GamePanel.SetComputerInfo()
	end
	if this.gameType == DDZGameType.Three then
		if CharacterOtherComputer.GameObject() == nil then
			GameCtrl.CreaterCharacterOtherComputer()
			GamePanel.SetOtherComputerInfo()
		end
	end
	if callpt >= 1 then
		if foldnum > 0 then
			GamePanel.SetFoldAmin(true,foldnum)
		end
	end
	GamePanel.test.text = foldnum;
	GameCtrl.FoldNum(foldnum)
	if thisone == tonumber(EginUser.Instance.uid) then
		--玩家抢地主
		if calltimes > 1 then
			Event.Brocast(GameEvent.ShowLetNum,double,true)
		end
		if GameCtrl.isTuoguan == true then
			if callpt == 0 then 
				if this.isFirstCall == true then
					--不叫地主
					GamePanel.DisCallLordCallBack()
				else
					--不抢地主
					GamePanel.DisgrabLordCallBack()
				end
			else
				
				if this.isFirstCall then 
					this.isFirstCall = false
					--叫
					GamePanel.CallLordCallBack()
				else
					--抢
					GamePanel.GrabLordCallBack(calltimes);
				end
				
			end
		end
	elseif thisone == Computer.id then
		--电脑抢地主
		CountDownPanel.CancelCountDown(false)
		if callpt == 0 then
			--电脑不抢地主
			if this.isFirstCall then --不叫
				Computer.DisCallLord()
			else--不抢
				Computer.DisGradLandLord()
			end
		else
			if callpt > 1 or this.isFirstCall == false then
				Event.Brocast(GameEvent.ShowLetNum,double,true)
			end
			--电脑抢地主
			if this.matchType == DDZGameMatchType.None or this.matchType == DDZGameMatchType.LZMatch then
				if this.isFirstCall then
					this.isFirstCall = false
					Computer.CallLord()
				else
					Computer.GradLandLord(calltimes)
				end
			else
				Computer.CallScore(callpt)
			end
			
		end
	else --另外一个电脑
		CountDownPanel.CancelCountDown(false)
		if callpt == 0 then
			if this.isFirstCall then
				OtherComputer.DisCallLord()
			else
				OtherComputer.DisGradLandLord()
			end
		else
			if callpt > 1 or this.isFirstCall == false then
				Event.Brocast(GameEvent.ShowLetNum,double,true)
			end
			if this.matchType == DDZGameMatchType.None or this.matchType == DDZGameMatchType.LZMatch then
				if this.isFirstCall then
					this.isFirstCall = false
					OtherComputer.CallLord()
				else
					OtherComputer.GradLandLord(calltimes)
				end
			else
				OtherComputer.CallScore(callpt)
			end
		end

	end
	if nextone == thisone then
		--抢地主结束
		GamePanel.ActiveGrabLandlord(false)
		this.nextone = 0

	else
		if nextone ==  tonumber(EginUser.Instance.uid) then
			--到玩家抢地主
			--显示抢地主按钮
			if GameCtrl.isTuoguan == false then
				CountDownPanel.OpenCountDown(CharacterType.Player,timeout,this.Tuoguan)
				if this.isFirstCall then
					GamePanel.ActiveCallBtn(true)
				else
					GamePanel.ActiveGrabLandlord(true)
				end
			end
		elseif nextone == Computer.id then
			CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
		else
			CountDownPanel.OpenCountDown(CharacterType.OtherComputer,timeout)
		end
	end
end
function this:ProcessStartPlay(messageObj)
	--{"body": {"hide_cards": [17, 4, 27], "banker": 889802486, "timeout": 20}, "tag": "startplay", "type": "ddz"}
	local body = messageObj["body"]
	local hidecards = body["hide_cards"] 
	local banker = body["banker"]
	local timeout = body["timeout"]
	local hidedouble = 1
	GamePanel.ActiveGrabLandlord(false)
	--设置底牌
	BottomCard.SetLibrary(this.ServerToCard(hidecards,CharacterType.Bottom));
	GamePanel.ShowHideCards(this.ServerToCard(hidecards,CharacterType.Bottom),hidedouble,true)
	OrderCtrl.state = GameState.Play
	--设置地主 发底牌
	if banker ==tonumber(EginUser.Instance.uid) then
		--玩家是地主
		GameCtrl.BecomeLandlord(CharacterType.Player);
		Computer.SetCardsNum(17,0)
		if this.gameType == DDZGameType.Three then
			OtherComputer.SetCardsNum(17,0)
		end
		Player.holdNum = 20
		Computer.holdNum = 17
		OtherComputer.holdnum = 17
		--减掉地主牌，记牌器
		DeskCardsCache.RemoveCardsInRemainCards(this.ServerToCard(hidecards))
		Event.Brocast(GameEvent.NoteCard)
	elseif Computer.id == banker then
		--对家是地主
		GameCtrl.BecomeLandlord(CharacterType.Computer);
		Computer.SetCardsNum(20,0)
		if this.gameType == DDZGameType.Three then
			OtherComputer.SetCardsNum(17,0)
		end
		Player.holdNum = 17
		OtherComputer.holdNum = 17
		Computer.holdNum = 20 
	else
		GameCtrl.BecomeLandlord(CharacterType.OtherComputer);
		OtherComputer.SetCardsNum(20,0)
		Computer.SetCardsNum(17,0)
		Player.holdNum = 17
		Computer.holdNum = 17
		OtherComputer.holdNum = 20
	end
	if Player.identity == Identity.Landlord then  
			GameCtrl.BeginPlayCard(CharacterType.Player,timeout)
	elseif Computer.identity == Identity.Landlord then
		CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
		GameCtrl.BeginPlayCard(CharacterType.Computer,timeout)
	else
		CountDownPanel.OpenCountDown(CharacterType.OtherComputer,timeout)
		GameCtrl.BeginPlayCard(CharacterType.OtherComputer,timeout)
	end
end
function this:ProcessStartraise( messageObj )
	local body = messageObj["body"];--给地主三张补牌
	local hidecards = body["hide_cards"]
	local hidecardtype = body["hidecard_type"]
	local hidedouble = body["hide_double"]
	local double = body["double"]
	local banker = body["banker"]
	local thisone = body["thisone"]
	local foldnum = body["fold_num"]
	local timeout = body["timeout"]
	if foldnum == nil then foldnum = 0 end;
	if hidedouble == nil then hidedouble = 1 end
 	resDealCards = false
	--隐藏抢地主按钮
	GamePanel.ActiveGrabLandlord(false)
	OrderCtrl.state = GameState.Double
	GamePanel.test.text = foldnum;
	GameCtrl.FoldNum(foldnum)
	--设置底牌
	BottomCard.SetLibrary(this.ServerToCard(hidecards,CharacterType.Bottom));
	GamePanel.ShowHideCards(this.ServerToCard(hidecards,CharacterType.Bottom),hidedouble,true)
	Computer.SetComputerState(3)
	if hidedouble >= 2 then
		--[[
		local function func( _double )
			coroutine.wait(2)
			Event.Brocast(GameEvent.ShowLetNum,_double,true)
		end
		coroutine.start(func,double)
		]]
		Event.Brocast(GameEvent.ShowLetNum,double,true)
	end
	--设置地主 发底牌
	if banker ==tonumber(EginUser.Instance.uid) then
		--玩家是地主
		GameCtrl.BecomeLandlord(CharacterType.Player);
		Computer.SetCardsNum(17,0)
		if this.gameType == DDZGameType.Three then
			OtherComputer.SetCardsNum(17,0)
		end
		Player.holdNum = 20
		Computer.holdNum = 17 - foldnum
		OtherComputer.holdnum = 17 - foldnum
		--减掉地主牌，记牌器
		DeskCardsCache.RemoveCardsInRemainCards(this.ServerToCard(hidecards))
		Event.Brocast(GameEvent.NoteCard)
	elseif Computer.id == banker then
		--对家是地主
		GameCtrl.BecomeLandlord(CharacterType.Computer);
		Computer.SetCardsNum(20,0)
		if this.gameType == DDZGameType.Three then
			OtherComputer.SetCardsNum(17,0)
		end
		Player.holdNum = 17 - foldnum
		OtherComputer.holdNum = 17 - foldnum
		Computer.holdNum = 20 
	else
		GameCtrl.BecomeLandlord(CharacterType.OtherComputer);
		OtherComputer.SetCardsNum(20,0)
		Computer.SetCardsNum(17,0)
		Player.holdNum = 17 - foldnum
		Computer.holdNum = 17 - foldnum
		OtherComputer.holdNum = 20
	end
	Event.Brocast(GameEvent.ShowGameText,foldnum)

	if thisone == tonumber(EginUser.Instance.uid) then
		if GameCtrl.isTuoguan == false then
			GamePanel.SetRaiseButton(true);
			CountDownPanel.OpenCountDown(CharacterType.Player,timeout-2,this.Tuoguan)
		end
	else
		CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
		
	end
	--设置底牌倍数

	--隐藏显示让牌数量
	local function func_fold()
		coroutine.wait(2)
		GamePanel.SetFoldAmin(false)
	end
	coroutine.start(func_fold)

	if this.matchType == DDZGameMatchType.LZMatch then
		GameCtrl.changeCardWeight = recLZCard
		GamePanel.ShowLZCards(GameCtrl.changeCardWeight,true)
	end

end
function this:ProcessRaise( messageObj )
	local body = messageObj["body"]
	local israise = body["israise"]
	local double = body["double"]
	local nextone = body["nextone"]
	local thisone = body["thisone"]
	local timeout = body["timeout"]
	this.nextone = nextone
	if thisone == Computer.id then 
		
		if israise == 1 then
			Computer.Double()
			Event.Brocast(GameEvent.ShowLetNum,double,true)
		else
			Computer.NoDouble()
		end
	elseif thisone == OtherComputer.id then
		if israise == 1 then
			OtherComputer.Double()
			Event.Brocast(GameEvent.ShowLetNum,double,true)
		else
			OtherComputer.NoDouble()
		end

	else
		if israise == 1 then
			Event.Brocast(GameEvent.ShowLetNum,double,true)
		end

		if GameCtrl.isTuoguan == true then
			if israise == 1 then
				GamePanel.DoubleCallBack()
			else
				GamePanel.DisDoubleCallBack()
			end
		end
	end
	if thisone == nextone then
		GamePanel.SetRaiseButton(false);
		--开始打牌
		Computer.SetComputerState(0)
		this.nextone = 0
		if Player.identity == Identity.Landlord then  
			GameCtrl.BeginPlayCard(CharacterType.Player,timeout)
			this.nextone = tonumber(EginUser.Instance.uid)
		elseif Computer.identity == Identity.Landlord then
			this.nextone = Computer.id
			CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
			GameCtrl.BeginPlayCard(CharacterType.Computer,timeout)
		else
			this.nextone = OtherComputer.id
			CountDownPanel.OpenCountDown(CharacterType.OtherComputer,timeout)
			GameCtrl.BeginPlayCard(CharacterType.OtherComputer,timeout)
		end
		OrderCtrl.state = GameState.Play
	elseif nextone == tonumber(EginUser.Instance.uid) then 
		GamePanel.SetRaiseButton(true);
		CountDownPanel.OpenCountDown(CharacterType.Player,timeout,this.Tuoguan)
		--Event.Brocast(GameEvent.ShowLetNum,double,true)
	elseif nextone == Computer.id then
		CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
	else
		CountDownPanel.OpenCountDown(CharacterType.OtherComputer,timeout)
	end
end
--过
function this:ProcessPass(messageObj)
	local mycards = messageObj["body"]["mycards"];
	local thisone = messageObj["body"]["thisone"]
	local nextone = messageObj["body"]["nextone"]
	local timeout = messageObj["body"]["timeout"]
	this.nextone = nextone
	if thisone ==tonumber(EginUser.Instance.uid) then
		--玩家pass
		--Player.DisPlayCard()
		this:ShowPlayerCards(mycards)
		--是否托管 托管
		--if GameCtrl.isTuoguan == true then
			GamePanel.DoDiscard()
		--end
		LastHandPanel.AddCards(CharacterType.Player)
	elseif thisone == Computer.id then
		--电脑pass
		Computer.DisPlayCard()
		LastHandPanel.AddCards(CharacterType.Computer)
	else
		--另一个电脑pass
		OtherComputer.DisPlayCard()
		LastHandPanel.AddCards(CharacterType.OtherComputer)
	end
	if nextone == tonumber(EginUser.Instance.uid) then
		OrderCtrl.PlayerPlay()
		CountDownPanel.OpenCountDown(CharacterType.Player,timeout,this.Tuoguan)
	elseif nextone == Computer.id then
		CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
	else
		CountDownPanel.OpenCountDown(CharacterType.OtherComputer,timeout)
	end

end
function this:ProcessPlay( messageObj )
	local body = messageObj["body"];
	local putcard = body["put_cards"]
	local puttype = body["put_type"]
	local holdnum = body["hold_num"]
	local foldnum = body["fold_num"]
	local cardnum = body["card_num"]
	local mycards = body["mycards"]
	local double = body["double"]
	local nextone = body["nextone"]
	local thisone = body["thisone"]
	local timeout = body["timeout"]

	local tar_card = body["tar_card"]
	local lz_card = body["lz_card"]

	




	if foldnum == nil then foldnum = 0 end;
	this.nextone = nextone
	GamePanel.test.text = foldnum;
	GameCtrl.FoldNum(foldnum)
	Event.Brocast(GameEvent.ShowLetNum,double,false)
	local charactortype
	if thisone == tonumber(EginUser.Instance.uid) then

		Player.holdNum = holdnum
		--玩家打牌
		if OrderCtrl.state ~= GameState.End then

			local cards = {}
			if #mycards ~= Player.GetCardsCount() then
				if this.matchType == DDZGameMatchType.LZMatch and lz_card ~= nil and #lz_card ~= 0 then

					cards = this.ServerToCardWithChange(putcard,tar_card,lz_card)
				else
					cards = this.ServerToCard(putcard)
				end
				coroutine.start(Player.PlayerCards,Player.GetSelectCardsbyCards(cards),cards,puttype,#putcard)
				this:ShowPlayerCards(mycards)
			end
		end
		--[[
		if GameCtrl.isTuoguan == true then
			coroutine.start(Player.PlayerCards,Player.GetSelectCardsbyCards(cards),cards,puttype,#putcard)
			this:ShowPlayerCards(mycards)
		else
			if #mycards ~= Player.GetCardsCount() then
				this:ShowPlayerCards(mycards)
			end
		end
		]]
		charactortype = CharacterType.Player
		--检测玩家是否只剩下两张或一张牌
		--Player.CheckWarn(holdnum)


	elseif Computer.id == thisone then
		--对家打牌
		Computer.holdNum = holdnum

		local cards = {}
		if this.matchType == DDZGameMatchType.LZMatch and lz_card ~= nil and #lz_card ~= 0 then
			cards = this.ServerToCardWithChange(putcard,tar_card,lz_card)
		else
			cards = this.ServerToCard(putcard)
		end

		coroutine.start(Computer.PlayCardByServer,cards,holdnum)
		Computer.SetCardsNum(holdnum,foldnum)
		charactortype = CharacterType.Computer
		--[[
		if(CharacterComputer.Animator:GetBool("pickup") == false) then
			if CharacterComputer.GameObject() ~= nil then
				Computer.CreatCardsOnRigntHand(holdnum)
			end
		end
		]]
		if Computer.isshowCard == true then --是否明牌
			local c_cards = this.ServerToCard(putcard)
			for i=#c_cards,1,-1 do
				Computer.PopCard(c_cards[i])
			end
			Computer.UpdateOpenHandCards()
		end
	else 
		--另一个对家
		OtherComputer.holdNum = holdnum

		local cards = {}
		if this.matchType == DDZGameMatchType.LZMatch and lz_card ~= nil and #lz_card ~= 0 then
			cards = this.ServerToCardWithChange(putcard,tar_card,lz_card)
		else
			cards = this.ServerToCard(putcard)
		end

		coroutine.start(OtherComputer.PlayCardByServer,cards,holdnum)
		OtherComputer.SetCardsNum(holdnum,foldnum)
		charactortype = CharacterType.OtherComputer
		--[[
		if(CharacterOtherComputer.Animator:GetBool("pickup") == false) then
			if CharacterOtherComputer.GameObject() ~= nil then
			--CharacterOtherComputer.pickupAnimator()
				OtherComputer.CreatCardsOnRigntHand(holdnum)
			end
		end
		]]
		if OtherComputer.isshowCard == true then --是否明牌
			local c_cards = this.ServerToCard(putcard)
			for i=#c_cards, 1 , -1 do
				OtherComputer.PopCard(c_cards[i])
			end
			OtherComputer.UpdateOpenHandCards()
		end
	end
	Event.Brocast(GameEvent.ShowGameText,foldnum)
	if holdnum > 0 then
		if nextone == tonumber(EginUser.Instance.uid) then
			--if #putcard == 2 and (putcard[1] == 52 or putcard[2] == 52) then
				--print("王炸")
			--else
				OrderCtrl.PlayerPlay()
				CountDownPanel.OpenCountDown(CharacterType.Player,timeout,this.Tuoguan)
			--end
		elseif nextone == Computer.id then 
			CountDownPanel.OpenCountDown(CharacterType.Computer,timeout)
		else
			CountDownPanel.OpenCountDown(CharacterType.OtherComputer,timeout)
		end
	end
	--用于记牌器
	if thisone ~= tonumber(EginUser.Instance.uid) then
		DeskCardsCache.RemoveCardsInRemainCards(this.ServerToCard(putcard))
	end
	--检测是否游戏结束
	GameCtrl.CheckGameOverByServer(charactortype,holdnum)
	LastHandPanel.AddCards(charactortype,this.ServerToCard(putcard))


end
function this.ServerToCardWithChange(putcard,tarcard,lzcard)
	local cards = {}
	--除去癞子牌原来的值
	local tempog = {}
	for i=#putcard,1,-1 do
		if #lzcard == 0 then
			break
		end
		if tableContains(lzcard,putcard[i]) == true then
			table.insert(tempog,putcard[i])
			table.remove(putcard,i)
		end
	end

	--癞子变成的牌
	local tempchange = {}
	for i=1,#tarcard do
		if #lzcard == 0 then
			break
		end
		if tableContains(putcard,tarcard[i]) == false then
			table.insert(tempchange,tarcard[i])
		end
	end
	cards = this.ServerToCard(putcard)
	local ogCard = this.ServerToCard(tempog)
	local changeCard = this.ServerToCard(tempchange)
	if #changeCard ~= 0 then
		for i=1,#changeCard do
			changeCard[i].oldweight = ogCard[i].weight
		end
	end 
	for i=1,#changeCard do
		table.insert(cards,changeCard[i])
	end
	return cards


end
function this:ProcessGameover(messageObj)

	resDealCards = false

	if this.matchType == DDZGameMatchType.JDMatch then
		coroutine.start(GameCtrl.CJFGameOver,messageObj)
	else
		coroutine.start(GameCtrl.OpenGameOverViewByServer,messageObj)
	end
end
--重进后刷新牌桌
function this:ProcessUpdate(messageObj)
	--不用准备
	this.update = true
	CountDownPanel.CancelCountDown(false)
	GamePanel.ActiveReady(false)
	coroutine.wait(0.1);

	--托管
	LRDDZ_Game:SendManage(true)
	local body = messageObj["body"]
	local step = body["step"] --0叫1加2出
	local calltimes = body["call_times"]
	local double = body["double"]
	local mycards = body["mycards"]
	local currentstate = body["current_state"] --当前所有人的状态
	local thisone = body["thisone"]
	local lastone = body["lastone"]
	local showedcards = body["showed_cards"] --已出过的牌
	local hidecards = body["hide_cards"]--补牌
	local banker = body["banker"]--地主
	local bankercards = body["banker_cards"]
	local timeout = body["timeout"]--倒计时剩余秒数
	local taskid = body["task_id"]
	local taskreward = body["task_reward"]
	local showcardinfo = body["show_card_info"]

	local lz_rank = nil
	
	if taskid == nil then 
		taskid = 0
	end
	if racePanel ~= nil then
		destroy(racePanel)
		racePanel = nil
	end
	GamePanel.SetTask(taskid,false,taskreward)
	--设置玩家的手牌
	this:ShowPlayerCards(mycards)
	local cards = this.ServerToCard(mycards);
	CharacterPlayer.SetHand3DCards(cards)
	Event.Brocast(GameEvent.ShowLetNum,double,false)
	if step == 0 then
		--叫地主
		OrderCtrl.state = GameState.GradLord
	elseif step == 1 then
		OrderCtrl.state = GameState.Double
		--倍数没发过来。。。待改
		GamePanel.ShowHideCards(this.ServerToCard(hidecards,CharacterType.Bottom),1)
		--加倍
		--补的牌
		for i=1,#hidecards do
		end
	elseif step == 2 then	
		--打牌
		OrderCtrl.state = GameState.Play
		--倍数没发过来。。。待改
		GamePanel.ShowHideCards(this.ServerToCard(hidecards,CharacterType.Bottom),1)
		--开始打牌


		if banker == tonumber(EginUser.Instance.uid) then  
			GameCtrl.BecomeLandlord(CharacterType.Player);
			--GameCtrl.BeginPlayCard(CharacterType.Player)
		elseif banker == tonumber(Computer.id) then
			GameCtrl.BecomeLandlord(CharacterType.Computer);
			--GameCtrl.BeginPlayCard(CharacterType.Computer)
		else 
			--另外一个玩家
			GameCtrl.BecomeLandlord(CharacterType.OtherComputer);
			--GameCtrl.BeginPlayCard(CharacterType.OtherComputer)
		end
		GamePanel.SetPlayerLandlordIcon(true,false)
		GamePanel.SetComputerLandlordIcon(true,false)
		if self.gameType == DDZGameType.Three then
			GamePanel.SetOtherComputerLandlordIcon(true,false)
		end
		--已出的牌	
		--用于记牌器
		DeskCardsCache.RemoveCardsInRemainCards(this.ServerToCard(showedcards))
		--减去玩家的牌
		DeskCardsCache.RemoveCardsInRemainCards(this.ServerToCard(mycards))
		for i=1,#showedcards do
		end
		for i=1,#hidecards do
		end
	end
	for i=1,#currentstate do
		local uid = currentstate[i]["uid"]
		local managed = currentstate[i]["managed"]
		local holdnum = currentstate[i]["hold_num"]
		local lastput = currentstate[i]["lastput"] --上一手出的牌
		local lasttype = currentstate[i]["lastput_type"]--上一手出的牌的牌型
		local callpt = currentstate[i]["callpt"]--#-1:还未叫;0:不叫; 1:叫
		local raised = currentstate[i]["raised"]--#-1:还未加倍, 0:不加倍, 1:加倍
		if lz_rank == nil then
			lz_rank = currentstate[i]["lz_rank"]
			if lz_rank ~= nil then
				recLZCard = this.ServerToCard({lz_rank})[1].weight
				GameCtrl.changeCardWeight = recLZCard
				GamePanel.ShowLZCards(GameCtrl.changeCardWeight,false)
			end
		end
		if holdnum == nil then holdnum = 0 end;

		local num = holdnum --对家的牌数
		if uid == tonumber(EginUser.Instance.uid) then
			--玩家
			if managed == true then
				--托管
				GamePanel.TuoguanSucceed();
			end

		elseif Computer.id == uid then
			--对家或电脑

			local foldnum = calltimes-1
			if calltimes == 0 or this.gameType == DDZGameType.Three then
				foldnum = 0
			end
			
			Computer.SetCardsNum(holdnum,foldnum);
			local function computerfunc (num)
				while true do
					if CharacterComputer.GameObject() ~= nil then
						--CharacterComputer.pickupAnimator()
						Computer.CreatCardsOnRigntHand(num)
						return
					else
						coroutine.wait(0.1)
					end
				end
			end

			--if step ~= 0 then
				if banker == tonumber(EginUser.Instance.uid) then
					num = holdnum + foldnum
				end
				Computer.HidenNotice()
				coroutine.start(computerfunc,holdnum)
				
			--end
		else
			OtherComputer.SetCardsNum(holdnum,0);
			--另外一个其他玩家
			local function othercomputerfunc(num)
				while true do
					if CharacterOtherComputer.GameObject() ~= nil then
						--CharacterComputer.pickupAnimator()
						OtherComputer.CreatCardsOnRigntHand(num)
						return
					else
						coroutine.wait(0.1)
					end
				end
			end	
			--if step ~= 0 then
				
				OtherComputer.HidenNotice()
				if this.gameType == DDZGameType.Three then
					coroutine.start(othercomputerfunc,num)
				end
			--end
		end
	end
	--{"cards": [13, 26, 1, 28, 41, 16, 5, 31, 6, 32, 7, 20, 46, 21, 35, 36, 11, 51, 53],"is_show": false, "uid": 889904377, "show_double": 1}
	if showcardinfo ~= nil then
		for i=1,#showcardinfo do
			local uid = showcardinfo[i]["uid"]
			local cards = showcardinfo[i]["cards"]
			local isshow = showcardinfo[i]["is_show"]
			local showdouble = showcardinfo[i]["show_double"]
			if isshow then
				if uid == tonumber(EginUser.Instance.uid) then
					Player.IsShowCard(true)
				elseif uid == Computer.id then
					Computer.ShowOpenHandCards(this.ServerToCard(cards))
				elseif uid == OtherComputer.id then
					OtherComputer.ShowOpenHandCards(this.ServerToCard(cards))
				end
			end
		end
	end
	--播放玩家拿牌动作
	CharacterPlayer.pickupAnimator()
	 --设置托管按钮可点击
	GamePanel.tuoguanBtn.transform:GetComponent("UIButton").isEnabled = true
	GamePanel.lastHand.transform:GetComponent("UIButton").isEnabled = true
	Computer.SetComputerState(0)
end

--准备
function this:ProcessReady(messageObj)
	local uid = messageObj["body"]
	if uid == Computer.id then
		Computer.ShowNotice(GameText.Ready);
	elseif uid == OtherComputer.id then
		--另一个其他玩家
		OtherComputer.ShowNotice(GameText.Ready);
	else
	end
end
function this:ProcessReady_Ok(messageObj)
	GamePanel.ActiveReady(false)

	GamePanel.SetaJDMacthWaitting(true)
	if CJFRacePanel.waitting~=nil then
		CJFRacePanel.Waitting(true)
	end
	if CharacterComputer.GameObject() ~= nil then
		coroutine.start(LRDDZ_Game.DelectCharterComputer)
		coroutine.start(LRDDZ_Game.DelectOtherCharterComputer)
	end
	
end
function this:ProcessReady_Fail(messageObj)
	local body = messageObj["body"]
	if body == 1 then --比赛结束或未开放
		if CJFRacePanel.tipobj~=nil then
			--未开放
			CJFRacePanel.ShowTipsMsg("比赛时间已结束")
		else
			GamePanel.JDMatchEnd("比赛时间已结束")
		end
	elseif body == 2 then --玩家不在报名列表
		if CJFRacePanel.tipobj~=nil then
 			CJFRacePanel.ShowTipsMsg("不在报名列表，请重新进入游戏")
 		end
	elseif body == 3 then --已经准备过了
		if CJFRacePanel.tipobj~=nil then
 			CJFRacePanel.ShowTipsMsg("已经准备过了")
 		end
	elseif body == 4 then --还在游戏中
		if CJFRacePanel.tipobj~=nil then
 			CJFRacePanel.ShowTipsMsg("还在游戏中")
 		end
	elseif body == 5 then --已经最大局数
		if CJFRacePanel.tipobj~=nil then
 			CJFRacePanel.ShowTipsMsg("已达到最大局数了，请等待最后的结果！")
 		else
 			GamePanel.JDMatchEnd("已达到最高比赛局数")
 		end
	end
	
end
function this:ProcessReadyMax(messageObj)
	
 end 
--托管
function this:ProcessManage( messageObj )
	local body = messageObj["body"]
	local uid = body["uid"]
	local managed = body["managed"]
	if uid == tonumber(EginUser.Instance.uid) then
		--玩家托管
		if managed == true then
			GamePanel.TuoguanSucceed();
		else
			GamePanel.CancelHostingSucceed()
			-- 服务端修改托管问题后开放
			local function dealy(  )
				coroutine.wait(0)
				if this.nextone == tonumber(EginUser.Instance.uid) then
					if OrderCtrl.state == GameState.Play then
						OrderCtrl.PlayerPlay()
					elseif OrderCtrl.state == GameState.GradLord then
						if this.isFirstCall then
							GamePanel.ActiveCallBtn(true)
						else
							GamePanel.ActiveGrabLandlord(true)
						end
					elseif OrderCtrl.state == GameState.Double then
						GamePanel.SetRaiseButton(true);
					end
				end
			end
			coroutine.start(dealy)
			
		end
	--电脑托
	elseif uid == Computer.id then
		GamePanel.SetComputerManage(managed)
	elseif uid == OtherComputer.id then
		GamePanel.SetOtherManage(managed)
	end
end
--聊天
function this:ProcessHurry( messageObj )
	--聊天
	--{"body": {"spokesman": 89062723, "index": 3}, "tag": "hurry", "type": "game"}</color>
	local body = messageObj["body"]
	local spokes = body["spokesman"]
	local index = body["index"]
	if spokes ~= tonumber(EginUser.Instance.uid) then
		if spokes == Computer.id then
			LRDDZ_SoundManager.OtherHumanSound(CharacterType.Computer,"talk"..index,Computer.sex == 1)
			CharacterComputer.Talk(index)
			Computer.Talk(index)
		else
			LRDDZ_SoundManager.OtherHumanSound(CharacterType.OtherComputer,"talk"..index,OtherComputer.sex == 1)
			CharacterOtherComputer.Talk(index)
			OtherComputer.Talk(index)
		end
	else
		--玩家说话
		print("玩家说话")
	end
end
--任务完成
--{"type":"game", "tag":"taskfinish", "body":(数量, 道具id)}
function this:ProcessTaskFinish(messageObj)
	local rewardnum = messageObj["body"][1]
	local rewardid = messageObj["body"][2]
	local str = ""
	if rewardid == 0 then
		--添加金币
		EginUser.Instance.bagMoney = EginUser.Instance.bagMoney + rewardnum
		Avatar.avatarGold = Avatar.avatarGold + rewardnum
		str = "金币"
	elseif rewardid == 1 then
		str = "元宝"
	elseif rewardid == 4 then
		str ="张快乐卡"
	elseif rewardid == 1051 then
		str ="元话费"
	end
	
	GamePanel.FinishTask(rewardnum..str)
end
--明牌
function this:ProcessShowDeck(messageObj)
	--{"body": [5, 889904377, 5, []], "tag": "showcard", "type": "ddz"}
	--{"body":[4,866627727,[13,2,15,28,16,29,42,4,31,44,6,20,34,22,35,11,51]],"tag":"showcard","type":"ddz"}
	--showcard的body属性：(当前总公共倍数，UID，该玩家明牌的倍数，牌值)
	local multipleNum = messageObj["body"][1]
	local id = messageObj["body"][2]
	local cards
	if #messageObj["body"] == 3 then
		cards = messageObj["body"][3]
	else
		cards = messageObj["body"][4]
	end
	Event.Brocast(GameEvent.ShowLetNum,messageObj["body"][1],false)
	if cards == nil or #cards == 0 then return end 
	LRDDZ_SoundManager.PlaySoundEffect("showCard")
	if id == tonumber(EginUser.Instance.uid) then
		Player.IsShowCard(true)
		LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"mingpai",Avatar.getAvatarSex() == 1)
		GamePanel.ActiveOpenHand(false)
	elseif id == Computer.id then
		Computer.ShowOpenHandCards(this.ServerToCard(cards),true)
		LRDDZ_SoundManager.OtherHumanSound(CharacterType.Computer,"mingpai",Computer.sex == 1)
	else
		OtherComputer.ShowOpenHandCards(this.ServerToCard(cards),true)
		LRDDZ_SoundManager.OtherHumanSound(CharacterType.OtherComputer,"mingpai",OtherComputer.sex == 1)
	end
	
end
--发牌时明牌
function this:ProcessShowDeckAtDeal(messageObj)
	--{"body": [200, 889733357, [26, 1, 27, 28, 29, 17, 32, 45, 7, 20, 21, 47, 9, 11, 12, 51, 53]], "tag": "showcard", "type": "ddz"}
	--{"body": [true, 4, [[889904377, false, []], [890042066, true, [0, 26, 27, 40, 42, 17, 44, 19, 33, 9, 22, 35, 10, 36, 37, 12, 25]], [66740121, false, []]]], "tag": "showcard_2", "type": "ddz"}
	local body = messageObj["body"]
	local list = body[3]
	local double = body[2]
	for i=1,#list do
		if list[i][2] == true then
			if list[i][1] == tonumber(EginUser.Instance.uid) then
				Player.IsShowCard(true)
				LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"mingpai",Avatar.getAvatarSex() == 1)
			elseif list[i][1] == Computer.id then
				print("右边电脑明牌")
				local function dealyshowcard()
					coroutine.wait(2.5)
					Computer.ShowOpenHandCards(this.ServerToCard(list[i][3]),true)
				end
				coroutine.start(dealyshowcard)
				LRDDZ_SoundManager.OtherHumanSound(CharacterType.Computer,"mingpai",Computer.sex == 1)
			else
				print("左边电脑明牌")
				local function dealyshowcard()
					coroutine.wait(2.5)
					OtherComputer.ShowOpenHandCards(this.ServerToCard(list[i][3]),true)
				end
				coroutine.start(dealyshowcard)
				LRDDZ_SoundManager.OtherHumanSound(CharacterType.OtherComputer,"mingpai",OtherComputer.sex == 1)
			end
		else
			if list[i][1] == tonumber(EginUser.Instance.uid) then
				local function func()
					coroutine.wait(2.5)
					if body[1] and not Player.isshowCard and this.gameType == DDZGameType.Three then 
						--显示明牌
						GamePanel.ActiveOpenHand(true)
					end
				end
				coroutine.start(func)
				Player.IsShowCard(false)
			elseif list[i][1] == Computer.id then
				Computer.isshowCard = false
			else
				OtherComputer.isshowCard = false
			end
		end

	end

end
function this:ProcessAllCards( messageObj )
	 
end


--5分钟赛相关协议
function this:ProcessApply(messageObj)
	
	local body = messageObj["body"]
	--[[
	if body["full"] then 
		error("人数已满,不能参加比赛。")
		return
	end
	if body["late"] then
		error("比赛已经开始")
		return
	end
	if body["strange"] then
		error("现在不允许参加比赛。")
		return
	end
	
	if body["close"] then
		error("比赛已关闭")
		return
	end
	]]
	this.time:Stop()
	if body["sum_score"] == nil then
		this.matchType = DDZGameMatchType.FiveMinute
		--显示比赛ui
		this:ShowFiveMinRaceUI()
		local requirements = body["requirements"] --报名条件
		local champion_award = body["champion_award"]--冠军奖励
		local awards = body["awards"] --报名奖励说明
		local matchtime = body["matchtime"]--开赛时间
		local restseconds = body["restseconds"]--剩余重置时间
		local mincn = body["mincn"]--最小人数限制
		local maxcn = body["maxcn"]--最大人数限制
		local cn = body["cn"]--当前人数
		local initscore = body["initscore"]--初始积分
		local unit_money = body["unit_money"]--基数
		local step2_line = body["step2_line"]--决出前9名
		local join_rank = body["join_rank"]--排名前3名可参加决赛
		local step2_initscore = body["step2_initscore"]--第2阶段带入积分
		local step1time = body["step1time"]--预赛时长
		local step2time = body["step2time"]--决赛时长
		RacePanel.SetPanel(messageObj)

		--显示报名界面
		LRDDZ_ResourceManager.Instance:CreatePanel('Match','RacePanel',true,function(obj) 
			local loadpanel = GameObject.Find("LRDDZ_LoadPanel")
			if loadpanel ~= nil then
				destroy(loadpanel,0.5)
			end
			racePanel = obj
		end)
		GamePanel.SetRaceTitle(RaceTitleName.FiveMinStep1)
	else
		this:ShowJDRaceUI()
		this.matchType = DDZGameMatchType.JDMatch
		--{"body": {"last_rank50": [], "sum_score": 0, "ave_score": 0, "rank": 0, "restseconds": -2, 
		--"awards": [["第1名", "300元京东E卡"], ["第2名", "200元京东E卡"], ["第3名", "100元京东E卡"], 
		--["第4-10名", "50元京东E卡"], ["第11-20名", "30元京东E卡"], ["第21~30名", "100W金币"], 
		--["第31~50名", "50W金币"]], "close": false, "top50": [[215, 30, 299829, "srw3fUaiVhjBMLV", 23, 7, 0, 0]], 
		--"end": "22:00", "range": "10:00-22:00", "round": 0}, "tag": "apply", "type": "ddz7"}
		local ranks = body["last_rank50"]
		local sum_score = body["sum_score"]
		local ave_score = body["ave_score"]
		local rank = body["rank"]
		local restseconds = body["restseconds"]
		local awards = body["restseconds"]
		local top50 = body["top50"]
		local gameEnd = body["end"]
		local range = body["range"]
		local round = body["round"]
		if this.platform == PlatformType.PlatformMoble then
			CJFRacePanel.SetPanel(messageObj)
			LRDDZ_ResourceManager.Instance:CreatePanel('Match','CJFRacePanel',true,function(obj) 
				local loadpanel = GameObject.Find("LRDDZ_LoadPanel")
				if loadpanel ~= nil then
					destroy(loadpanel,0.5)
				end
				racePanel = obj
			end)
		else
			if firstApplay == true then
				LRDDZ_Game:UserReady()
				firstApplay = false
			end
		end
		GamePanel.SetRaceTitle(RaceTitleName.JDMatch)
	end
end
--刷新人数
function this:ProcessNewcn(messageObj)
	--{'type': 'ddz7', 'tag': 'newcn', 'body': {'playern': self.matchcn}
	local cn = messageObj["body"]["playern"]
	RacePanel.SetPlayerNum(cn)
end
--淘汰
function this:ProcessKick(messageObj)
	--{'type':'ddz7', 'tag':'kick','body':{'kick_uid':uid,'kick_name':user.nickname}}
	local uid = messageObj["body"]["uid"]
	local nic = messageObj["body"]["kick_name"]
	--MyCommon.ShowTips(nic.."淘汰")
end
function this:ProcessWaitstart(messageObj)
	--{'type':'ddz7', 'tag':'waitstart', 'body': {'top10': self.get_top10(),前十}}
	--MyCommon.ShowTips("等待其他玩家结束")
end
function this:ProcessWaitingstep2(messageObj)
	--MyCommon.ShowTips("准备进入决赛")
	GamePanel.SetRaceState("准备进入决赛")
	GamePanel.SetRaceTitle(RaceTitleName.FiveMinStep2)
	GamePanel.SetRaceTime(0)
	GamePanel.SetDoubleTime(0)
end

function this:ProcessWaitStep2(messageObj)
	--MyCommon.ShowTips("等待进入决赛排名")
	GamePanel.SetRaceState("等待进入决赛排名")
end
--等待决赛排名
function this:ProcessWaitOver(messageObj)
	--GamePanel.SetRaceState("等待决赛排名")
	GamePanel.SetRaceState("等待决赛排名")
end
--x秒后单注加倍
function this:ProcessUnitgrowtip( messageObj )
	-- {'type':'ddz7', 'tag':'unitgrowtip', 'body':READY_UNITGROW_TIME}
	local time = messageObj["body"]
	MyCommon.ShowTips(time.."秒后底牌基数翻倍，比赛将更加激烈，\n加油！加油")
	GamePanel.SetDoubleTime(time)
	local function countdown()
		coroutine.wait(time)
		GamePanel.SetInitScore(MyCommon.InitScore()*2)
	end
	coroutine.start(countdown)
end
--开始加注
function this:ProcessUnitgrowStart(messageObj)
	--{'type':'ddz7', 'tag':'unitgrow_start', 'body':self.unitgrow_dt}
	--MyCommon.ShowTips("开始加注")
	--加注倒计时
	GamePanel.SetDoubleTime(messageObj["body"])
	--GamePanel.SetInitScore(MyCommon.InitScore()*2)
	
end
function this:ProcessNewRanks(messageObj)
	local function func( )
		while true do
			if EginUser.Instance.nickname ~= "" then
				GamePanel.UpdateFiveMinRaceRank(messageObj)
				local ranks = messageObj["body"]["ranks"]
				for i=1,#ranks do
					if ranks[i][1] == EginUser.Instance.nickname then
						RaceRankAnimationPanel.SetRank(ranks[i][2],messageObj["body"]["cn"])
						break
					end
				end
				break
			else
				coroutine.wait(0.1)
			end
		end
	end
	coroutine.start(func)
end
 
function this:ProcessSendAward(messageObj)
--[[
	local function okFunc(obj)
		if LRDDZ_Game.platform == PlatformType.PlatformMoble then
        	LRDDZ_Game:BackHall()
        else
        	--直接退出游戏
			Application.Quit()
		end
    end 
 	MyCommon.CreatePrompt("比赛结束!",okFunc)
	]]
	GamePanel.SetRaceState("")
	if this.matchType ~= DDZGameMatchType.JDMatch then
		LRDDZ_ResourceManager.Instance:CreatePanel('RaceOverPanel','RaceOverPanel',true,function(obj) 
			RaceOverPanel.SetDest(messageObj["body"]["rank"],messageObj["body"]["award"],messageObj["body"]["datetime"])
		end)
	else
		if messageObj["body"]["add_gold"]~=nil and messageObj["body"]["add_gold"] ~= 0 then
			--京东赛只加金币
			--EginUser.Instance.bagMoney = EginUser.Instance.bagMoney + messageObj["body"]["add_gold"]
			GamePanel.PopJdAward(true,messageObj["body"]["rank"],messageObj["body"]["add_gold"])
		end
		if messageObj["body"]["add_item_id"]~= nil and messageObj["body"]["add_item_id"] > 0 then
			if CJFRacePanel.hasawardPanel ~= nil then
				local function func()
					coroutine.wait(2)
					coroutine.start(CJFRacePanel.LoadInof)
				end
				coroutine.start(func)
			end
		end
	end
end
--第一局开始
function this:ProcessStep1start(messageObj)
	--{"body": 2400, "tag": "step1start", "type": "ddz7"} --body 第一局时长
	if racePanel ~= nil then
		destroy(racePanel)
		racePanel = nil
	end
	--隐藏准备按钮
	GamePanel.ActiveReady(false)
	OrderCtrl.state = GameState.GradLord
	--GamePanel.SetRaceTime(messageObj["body"])
end
local rankAnimPanel = nil
function this:ProcessDeskover(messageObj)
	--{"body": false, "tag": "deskover", "type": "ddz7"}
	if messageObj["body"] == false then
		GamePanel.SetRaceState("请等待重新匹配...")
	end
	if rankAnimPanel == nil then
		LRDDZ_ResourceManager.Instance:CreatePanel('RaceRankAnimationPanel','RaceRankAnimationPanel',true,function(obj) 
			rankAnimPanel = obj
			local function func()
				coroutine.wait(0.1)
				RaceRankAnimationPanel.SetPosition(messageObj["body"])
			end
			coroutine.start(func)
		end)
	else
		RaceRankAnimationPanel.SetPosition(messageObj["body"])
	end
	
end
--三人赛协议
function this:ProcessThreeApply(messageObj)
	this.time:Stop()
	this.matchType = DDZGameMatchType.ThreeMatch
	local go = GameObject.Find("GUI/Camera/RaceOverPanel")
	if go ~= nil then
		destroy(go)
	end
	--显示比赛ui
	this:ShowThreeRaceUI()
	ThreeRacePanel.SetPanel(messageObj)
	LRDDZ_ResourceManager.Instance:CreatePanel('Match','ThreeRacePanel',true,function(obj) 
		local loadpanel = GameObject.Find("LRDDZ_LoadPanel")
		if loadpanel ~= nil then
			destroy(loadpanel,0.5)
		end
		racePanel = obj
		if messageObj["body"]["playern"] == 3 then
			destroy(racePanel,0.5)
			racePanel = nil
		end
	end)
	GamePanel.SetRaceTitle(RaceTitleName.ThreeMatch)
end
function this:ProcessRecheckin(messageObj)
 --,"playing": true}, "tag": "recheckin", "type": "ddz9"}
	this.time:Stop()
	if messageObj["type"] == "ddz9" then
		this.matchType = DDZGameMatchType.ThreeMatch
		this:ShowThreeRaceUI()
		GamePanel.UpdateThreeRaceRank(messageObj["body"]["ranks"])
		GamePanel.SetPlayedTimes(messageObj["body"]["playedtimes"]+1)
		GamePanel.SetRaceTitle(RaceTitleName.ThreeMatch)
		RacePanel.GetAwards(messageObj["body"]["awards"])
	elseif messageObj["type"] == "ddz7" then
		if messageObj["body"]["sum_score"]==nil then
			this.matchType = DDZGameMatchType.FiveMinute
			this:ShowFiveMinRaceUI()
			RacePanel.GetAwards(messageObj["body"]["awards"])
			if messageObj["body"]["step"] == 1 then
				GamePanel.SetRaceTitle(RaceTitleName.FiveMinStep1)
			else
				--GamePanel.SetRaceTitle(RaceTitleName.FiveMinStep2)
				this:ProcessWaitingstep2()
			end
			GamePanel.SetDoubleTime(math.floor(messageObj["body"]["grow_lefttime"]))
		else
			--京东赛
			--{"range": "10:00-22:00", "awards": [["第1名", "300元京东E卡"], ["第2名", "200元京东E卡"], 
			--["第3名", "100元京东E卡"], ["第4-10名", "50元京东E卡"], ["第11-20名", "30元京东E卡"], 
			--["第21~30名", "100W金币"], ["第31~50名", "50W金币"]], "restseconds": -2, 
			--"end": "22:00", "sum_score": 0, "ave_score": 0, "round": 0, "rank": 0, 
			--"top50": [[215, 30, 299829, "srw3fUaiVhjBMLV", 23, 7, 0, 0], [91, 16, 295586, "小新小心", 11, 5, 0, 0]]}, 
			--"tag": "recheckin", "type": "ddz7"}
			this.matchType = DDZGameMatchType.JDMatch
			this:ShowJDRaceUI()
			if this.platform == PlatformType.PlatformMoble then
				CJFRacePanel.SetPanel(messageObj)
				LRDDZ_ResourceManager.Instance:CreatePanel('Match','CJFRacePanel',true,function(obj) 
					local loadpanel = GameObject.Find("LRDDZ_LoadPanel")
					if loadpanel ~= nil then
						destroy(loadpanel,0.5)
					end
					racePanel = obj
				end)
			else
				LRDDZ_Game:UserReady()
			end
			GamePanel.SetRaceTitle(RaceTitleName.JDMatch)
		end
	end
	GamePanel.SetRaceState("")
end
function this:ProcessNewcn_Three(messageObj)
	-- {"body": {"playern": 2}, "tag": "newcn", "type": "ddz9"}
	local cn = messageObj["body"]["playern"]
	ThreeRacePanel.SetPlayerNum(cn)
	if cn == 3 then
		if racePanel ~= nil then
			destroy(racePanel)
			racePanel = nil
		end
		GamePanel.ActiveReady(false)
		OrderCtrl.state = GameState.GradLord
		--扣200入场费
		if this.platform == PlatformType.PlatformMoble then
			EginUser.Instance.bagMoney = EginUser.Instance.bagMoney - 200
		end
		--GamePanel.SetRaceTime(-1)
	end
end
function this:ProcessNewRanks_Three(messageObj)
	--{"body": {"ranks": [{"score": 0, "uid": 889904377, "rank": 0, "name": "jingbao123"},
	-- {"score": 0, "uid": 98961604, "rank": 1, "name": "半夜心焦焦"}, 
	--{"score": 0, "uid": 68892131, "rank": 2, "name": "ka迪科维奇"}]}, "tag": "newranks", "type": "ddz9"}

	local function func( )
		while true do
			if EginUser.Instance.nickname ~= "" then
				GamePanel.UpdateThreeRaceRank(messageObj["body"]["ranks"])
				break
			else
				coroutine.wait(0.1)
			end
		end
	end
	coroutine.start(func)
	if racePanel ~= nil then
		destroy(racePanel)
		racePanel = nil
	end
end
function this:ProcessGroupover(messageObj)
	local ranks = messageObj["body"]["ranks"]
	GamePanel.UpdateThreeRaceRank(ranks)
end
function this:ProcessRoundover(messageObj)
	local body = messageObj["body"]
	local round = body["round"]
	local ranks = body["ranks"]
	local outmen = body["outmen"] --出局者
	local datetime = body["datetime"]
	GamePanel.UpdateThreeRaceRank(ranks)
	local awardstr = nil

	-- "outmen": [{"money": 0, "hpcard": 1, "uid": 889657154, "unit": 0, "item": 0}, [],[]
	for i=1,#outmen do
		if outmen[i]["uid"] == tonumber(EginUser.Instance.uid) then
			if outmen[i]["money"] ~= nil and outmen[i]["money"] ~= 0 then
				--添加金币
				awardstr = outmen[i]["money"] .."金币"
				EginUser.Instance.bagMoney = EginUser.Instance.bagMoney + outmen[i]["money"]
			end
			if outmen[i]["hpcard"] ~= nil and outmen[i]["hpcard"] ~= 0 then
				--快乐卡
				awardstr = "\n"..awardstr..outmen[i]["hpcard"] .."张快乐卡"
			end
		end
	end
	local rank = 3
	for i=1,#ranks do
		if ranks[i]["uid"] == tonumber(EginUser.Instance.uid) then
			rank = ranks[i]["rank"]+1 
			break
		end
	end
	--游戏结束
	RaceOverPanel.SetDest(rank,awardstr,datetime)
	GamePanel.SetRaceState("")
	LRDDZ_ResourceManager.Instance:CreatePanel('RaceOverPanel','RaceOverPanel',true,function(obj) 
		
	end)
end
function this:ProcessStart(messageObj)
	--{"body": {"sum_score": 0, "ave_score": 0, "round": 1}, "tag": "start", "type": "ddz7"}
	local body = messageObj["body"]
	if racePanel ~= nil then
		destroy(racePanel)
		racePanel = nil
	end
	--隐藏准备按钮
	GamePanel.ActiveReady(false)
	OrderCtrl.state = GameState.GradLord
	GamePanel.SetSumScore(body["sum_score"])
	GamePanel.SetAveScore(body["ave_score"])
	--GamePanel.SetRound(body["round"])
	GamePanel.SetPlayedTimes(body["round"])
end

--设置我的卡牌
function this:ShowPlayerCards(mycards)
	Player.SetLibrary(this.ServerToCard(mycards,CharacterType.Player))
end
function this:clearLuaValue()
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	rankAnimPanel = nil
	LuaGC();
end
function this:Tuoguan()
	GamePanel.TuoguanCallBack()
end
function this:OnDestroy()
	this:clearLuaValue()
	resDealCards = false

end
--两人斗地主和三人判断
function this:SwitchGameType(type)
	if type==DDZGameType.Two then
		--两人
		--隐藏一个座位
		GameObject.Find("scene/seat"):SetActive(false)
		--Player.PlacePoint.transform.localScale = Vector3.New(0.8,0.8,0.8)
		--Computer.PlacePoint.transform.localScale = Vector3.New(0.8,0.8,0.8)
		GamePanel.Menu.transform:FindChild("background"):GetComponent("UISprite").width = 448
		GamePanel.lastHand:SetActive(false)
		Computer.PlacePoint.maxPerLine = 20
		Player.talk_desc.fontSize = 40
		Computer.talk_desc.fontSize = 40
	else
		--三人
		if this.matchType == DDZGameMatchType.None or this.matchType == DDZGameMatchType.LZMatch then
			GamePanel.Menu.transform:FindChild("background"):GetComponent("UISprite").width = 530
		else
			GamePanel.Menu.transform:FindChild("background"):GetComponent("UISprite").width = 448
		end

	end
end
function this:ShowFiveMinRaceUI()
	GamePanel.fiveMinRace:SetActive(true)
	GamePanel.initScore:SetActive(false)
	GamePanel.multiplesNum:GetComponent("UILabel").enabled = false
	GamePanel.NoteCardPanel.transform:FindChild("NoteCardBg").localPosition = Vector3.New(154,-88,0)
	GamePanel.talkBtn:SetActive(false)
	local lPos = GamePanel.lastHand.transform.localPosition
	GamePanel.lastHand.transform.localPosition = Vector3.New(-343,lPos.y,lPos.z)
	GamePanel.talkboard.transform.localPosition = Vector3.New(766.8979,414.2,0)
	GamePanel.fRaceInitScore.gameObject:SetActive(true)
	GamePanel.fRaceMultiplesNum.gameObject:SetActive(true)
	GamePanel.fRaceRanklb.gameObject:SetActive(true)
	GamePanel.fRaceAllRank.gameObject:SetActive(true)
	GamePanel.fRaceTimelb.gameObject:SetActive(true)
	GamePanel.jRaceSumScore.gameObject:SetActive(false)
	GamePanel.jRaceAveScore.gameObject:SetActive(false)
	GamePanel.jwin_lose.gameObject:SetActive(false)
	

end
function this:ShowThreeRaceUI()
	GamePanel.fiveMinRace:SetActive(true)
	GamePanel.initScore:SetActive(false)
	GamePanel.multiplesNum:GetComponent("UILabel").enabled = false
	GamePanel.NoteCardPanel.transform:FindChild("NoteCardBg").localPosition = Vector3.New(154,-88,0)
	GamePanel.talkBtn:SetActive(false)
	local lPos = GamePanel.lastHand.transform.localPosition
	GamePanel.lastHand.transform.localPosition = Vector3.New(-343,lPos.y,lPos.z)
	GamePanel.talkboard.transform.localPosition = Vector3.New(766.8979,414.2,0)
	GamePanel.fRaceInitScore.gameObject:SetActive(true)
	GamePanel.fRaceMultiplesNum.gameObject:SetActive(true)
	GamePanel.fRaceRanklb.gameObject:SetActive(true)
	GamePanel.fRaceAllRank.gameObject:SetActive(true)
	GamePanel.fRaceTimelb.gameObject:SetActive(true)
	GamePanel.jRaceSumScore.gameObject:SetActive(false)
	GamePanel.jRaceAveScore.gameObject:SetActive(false)
	GamePanel.jwin_lose.gameObject:SetActive(false)

end
function this:ShowJDRaceUI()
	GamePanel.fiveMinRace:SetActive(true)
	local fmenu = GamePanel.fiveMinRace.transform:FindChild("Menu")
	fmenu.localPosition = Vector3.New(902,-794+150,0)
	--GamePanel.initScore:SetActive(false)
	--GamePanel.multiplesNum:GetComponent("UILabel").enabled = false
	GamePanel.NoteCardPanel.transform:FindChild("NoteCardBg").localPosition = Vector3.New(154,-88,0)
	GamePanel.talkBtn:SetActive(false)
	local lPos = GamePanel.lastHand.transform.localPosition
	GamePanel.lastHand.transform.localPosition = Vector3.New(-343,lPos.y,lPos.z)
	GamePanel.talkboard.transform.localPosition = Vector3.New(766.8979,414.2,0)
	GamePanel.fRaceInitScore.gameObject:SetActive(false)
	GamePanel.fRaceMultiplesNum.gameObject:SetActive(false)
	GamePanel.fRaceRanklb.gameObject:SetActive(false)
	GamePanel.fRaceAllRank.gameObject:SetActive(false)
	GamePanel.fRaceTimelb.gameObject:SetActive(true)
	GamePanel.jRaceSumScore.gameObject:SetActive(true)
	GamePanel.jRaceAveScore.gameObject:SetActive(true)
	GamePanel.jwin_lose.gameObject:SetActive(true)
end
function this:ShowLZRaceUI()
	GamePanel.NoteCardPanel.transform:FindChild("NoteCardBg").localPosition = Vector3.New(204,19,0)
	GamePanel.task.transform:FindChild("Top").localPosition = Vector3.New(90,0,0)
	GamePanel.hideCard.transform:FindChild("Sprite"):GetComponent("UISprite").width = 262
end
function this:ProcessAccountFailed(info)
	info = self
	SocketManager.Instance.socketListener = nil;
 	error(info)
 	local function okFunc(obj)
		if LRDDZ_Game.platform == PlatformType.PlatformMoble then
        	LRDDZ_Game:BackHall()
        else
        	--直接退出游戏
			Application.Quit()
		end
    end 
 	MyCommon.CreatePrompt(info,okFunc)
	
end