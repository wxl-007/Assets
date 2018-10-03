require "GameLRDDZ.Game.Type"
require "GameLRDDZ.Game.Card.Card"
require "GameLRDDZ.Game.Card.CardRule"
require "GameLRDDZ.Game.Card.CardBottomRule"
require "GameLRDDZ.Game.OrderCtrl"
require "GameLRDDZ.Game.Deck"
require "GameLRDDZ.Game.DeskCardsCache"
require "GameLRDDZ.Game.BottomCard"

GameCtrl = {};
local self = GameCtrl;
self.isChangeDesk = false;
local winTimes = 0 --连胜次数

local jdRaceOverPanel = nil

self.changeCardWeight = Weight.None--天癞子
self.otherChangeCardWeigh = Weight.None--地癞子
--构建函数--
function GameCtrl.New()
	return self;
end

function GameCtrl.Awake()

	self.changeCardWeight = Weight.None
	self.otherChangeCardWeigh = Weight.None
	self.gameOverPanel = nil   --结算面板
	jdRaceOverPanel = nil

	self.InitData()

	self.InitView()
	--打招呼动作
	coroutine.start(self.PlayHi)
	OrderCtrl.bigest = CharacterType.Player
	local number = {1,2,3,4,5,6}
	self.randClothes = selectNumber(3,number)
	winTimes = 0
end
function GameCtrl.WinTimes()
 	return winTimes
end
function selectNumber(count,numbers)
	selected={};
	--math.randomseed(os.time());
	if #numbers<=count then return unpack(numbers) end
	while #selected < count do
		local temp = math.random(1,#numbers);
		table.insert(selected,numbers[temp])
		table.remove(numbers,temp);
	end
	--return unpack(selected);
	return selected
end

function GameCtrl.PlayHi()
	coroutine.wait(0.1)
end

function GameCtrl.InitData()
    self.qiangdizhu_multiple =1;  --抢地主倍数
    self.chuntian_multiple =1;  --春天倍数
    self.dipai_multiple=1; --底牌倍数
    self.zhadan_multiple=1; --炸弹倍数
    self.jiabei_multiple=1;  --加倍倍数

    self.letCardsNum = 0; --让牌数
    self.basePointPerMatch = 100; ---底分
    self.roomMultiple = 2 ^ (MyCommon.SceneId - 1); --房间倍数

    self.isTuoguan = false    --是否托管
    self.foldNum = 0 --让牌数
     --创建牌
	Deck.CreateDeck()
	--用于记牌器
	DeskCardsCache.RemainCards(Deck.GetLibrary()) 
	--创建3D扑克
	self.pokerlist = {}
	self.Create3DPoker()

	
end 
function GameCtrl.FoldNum(num)
	if num == nil then
		return self.foldNum;
	else
		self.foldNum = num;
	end
end
function GameCtrl.delayCountdown()
	local function func()
		self.TimerForOut()
	end	
	CountDownPanel.OpenCountDown(CharacterType.Player,15,func)
end
function GameCtrl.InitView()
	--暂时只用场景1
	--local rand = math.random(1,3);
	--LRDDZ_ResourceManager.Instance:Create3DOjbect('background'..MyCommon.SceneId,'background'..MyCommon.SceneId, 'background'..MyCommon.SceneId, Vector3.New(1,1,1),Vector3.New(0,0,0), false,function(obj,name)
	--end,nil)
	--[[
	LRDDZ_ResourceManager.Instance:Create3DOjbect('background'..rand,'background'..rand, 'background'..rand, Vector3.New(1,1,1),Vector3.New(0,0,0), false,function(obj,name)
				--删除load界面
		local loadingPanel = GameObject.Find("LRDDZ_LoadPanel");
		if loadingPanel~=nil then
			destroy(loadingPanel)
		end
		GameCtrl.OtherResources()
		
	end,nil)
	]]
    --删除load界面
		--coroutine.start(GameCtrl.delayDelectLoadUI)
		LRDDZ_ResourceManager.Instance:CreatePanel('Computer','Computer',true,function(obj)
			print("finished Computer")
			LRDDZ_ResourceManager.Instance:CreatePanel('Player','Player',true,function(obj)
				print("finished Player")
				LRDDZ_ResourceManager.Instance:CreatePanel('OtherComputer','OtherComputer',true,function(obj)
					print("finished OtherComputer")
					LRDDZ_ResourceManager.Instance:CreatePanel('GamePanel','GamePanel',true,function(obj)
						print("finished Player")
						LRDDZ_ResourceManager.Instance:CreatePanel('CountDownPanel','CountDownPanel',true,function(obj)
							print("finished CountDownPanel")
							coroutine.start(LRDDZ_Game.StartGameSocket)
						end);
					end);
				end);
			end);
		end);
		
end
function GameCtrl.delayDelectLoadUI()
	--coroutine.wait(3)
	local loadingPanel = GameObject.Find("LRDDZ_LoadPanel");
	if loadingPanel~=nil then
		destroy(loadingPanel)
	end
end
local loadingPlayerModel = false --是否正在加玩家模型
function GameCtrl.OtherResources()
	--加载人物和其他资源 --
	if CharacterPlayer.GameObject() ~= nil or loadingPlayerModel == true then 
		print("已有人物模型");
		return 
	end
	loadingPlayerModel = true
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Character","CharacterPlayer"..Avatar.getAvatarSex(),"CharacterPlayer", Vector3.New(1,1,1),Vector3.New(0,0,0), true,function(obj,name)
		loadingPlayerModel = false
		local loadingPanel = GameObject.Find("LRDDZ_LoadPanel");
		if loadingPanel~=nil then
			destroy(loadingPanel)
		end
		--随机衣服
		
		if Avatar.getAvatarSex() == 1 then
			--local rand = math.random(1,6)
			obj.transform:FindChild("doudizhunan/Group004/man_01_clothes_model"):GetComponent("SkinnedMeshRenderer").materials[0].mainTexture = LRDDZ_ResourceManager.LoadTexture("man_color","man_0"..self.randClothes[1])
		else
			--local rand = math.random(1,6)
			obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0].mainTexture = LRDDZ_ResourceManager.LoadTexture("woman_color","girl_0"..self.randClothes[1])

			--local tex = LRDDZ_ResourceManager.LoadTexture("woman_color","girl_0"..rand)
			--obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0]:SetTexture("_Diffuse",tex)
			--obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0]:SetTexture("_Mask",tex)
		end
		if LRDDZ_Game.update == false and LRDDZ_Game.gameType == DDZGameType.Two then  
			--LRDDZ_Game:UserReady()
			GamePanel.DealCallBack()
		end
		--GamePanel.ActiveReady(false)
		--计时器
		--self.delayCountdown()
	end,nil)
	
	
end
local loadingComputerModel = false --是否正在加载对家模型
function GameCtrl.CreaterCharacterComputer()
	-- body
	if CharacterComputer.GameObject() ~= nil then 
		destroy(CharacterComputer.GameObject()) 
		CharacterComputer.OnDestroy()
	end
	if CharacterComputer.GameObject() == nil and loadingComputerModel == false then
		loadingComputerModel = true
		LRDDZ_ResourceManager.Instance:Create3DOjbect("Character","CharacterComputer"..Computer.sex, "CharacterComputer",Vector3.New(1,1,1),Vector3.New(0,0,0), true,function(obj,name)
			loadingComputerModel = false
			
			if Computer.sex == 1 then
				local rand = math.random(1,6)
			--随机衣服
				obj.transform:FindChild("doudizhunan/Group004/man_01_clothes_model"):GetComponent("SkinnedMeshRenderer").materials[0].mainTexture = LRDDZ_ResourceManager.LoadTexture("man_color","man_0"..self.randClothes[2])
			else
				local rand = math.random(1,6)
				obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0].mainTexture = LRDDZ_ResourceManager.LoadTexture("woman_color","girl_0"..self.randClothes[2])

				--local tex = LRDDZ_ResourceManager.LoadTexture("woman_color","girl_0"..rand)
				--obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0]:SetTexture("_Diffuse",tex)
				--obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0]:SetTexture("_Mask",tex)
			end
    	end,nil)
	end
end
local loadingOtherComputerModel = false --是否正在加载对家模型
function GameCtrl.CreaterCharacterOtherComputer()
	if CharacterOtherComputer.GameObject() ~= nil then
		destroy(CharacterOtherComputer.GameObject()) 
		CharacterOtherComputer.OnDestroy()
	end
	if CharacterOtherComputer.GameObject() == nil and loadingOtherComputerModel == false then
		loadingOtherComputerModel = true
		LRDDZ_ResourceManager.Instance:Create3DOjbect("Character","CharacterOtherComputer"..OtherComputer.sex, "CharacterOtherComputer",Vector3.New(1,1,1),Vector3.New(0,0,0), true,function(obj,name)
			loadingOtherComputerModel = false
			
			if OtherComputer.sex== 1 then
			--随机衣服
				--local rand = math.random(1,6)
				obj.transform:FindChild("doudizhunan/Group004/man_01_clothes_model"):GetComponent("SkinnedMeshRenderer").materials[0].mainTexture = LRDDZ_ResourceManager.LoadTexture("man_color","man_0"..self.randClothes[3])
			else
				--local rand = math.random(1,6)
				--local tex = LRDDZ_ResourceManager.LoadTexture("woman_color","girl_0"..rand)
				obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0].mainTexture = LRDDZ_ResourceManager.LoadTexture("woman_color","girl_0"..self.randClothes[3])
				--obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0]:SetTexture("_Diffuse",tex)
				--obj.transform:FindChild("doudizhunv/girl_01_clothes"):GetComponent("SkinnedMeshRenderer").materials[0]:SetTexture("_Mask",tex)
			end
    	end,nil)
	end
end
function GameCtrl.GetComputerModelState()
	return loadingComputerModel
end
function GameCtrl.GetOtherComputerModelState()
	return loadingOtherComputerModel
end
--计时器回调函数
function GameCtrl.TimerForOut()
	--LRDDZ_GameManager.LoadSceneAsync(SceneName.Desk)
	if LRDDZ_Game.platform == PlatformType.PlatformMoble then
		LRDDZ_Game:BackHall()
	else
		--直接退出游戏
		Application.Quit()
	end
end
--[[-><color=#00ff00>ReceiveMessage{"body": 
{"rocket_times": 0, "bomb_times": 0, "double": 1, "winner": 123171051, "system_win": 0.0, 
"user_win_money": [{"cards": [0, 13, 15, 41, 3, 29, 42, 30, 44, 35, 51, 52, 53], "winmoney": 10.0, "tax": 0.0, "uid": 98965121}, 
{"cards": [20, 8], "winmoney": -20, "tax": 0, "uid": 889731846}, 
{"cards": [], "winmoney": 10.0, "tax": 0.0, "uid": 123171051}], 
"is_spring": false}, "tag": "gameover", "type": "ddz"}</color>]]



function GameCtrl.OpenGameOverViewByServer(messageObj)
	local body = messageObj["body"];
	local winner = body["winner"]
	local double = body["double"]
	local hidedouble = body["hide_double"]
	local bombtimes = body["bomb_times"]
	local discards = body["discard_cards"]
	local isspring = body["is_spring"]
	local userwinmoney = body["user_win_money"]

	local residueCards = {} --需要显示的剩牌
	local integration = 0; --赚的金币
	local computerWinGold
	local computerdouble
	local otherComputerWinGold
	local otherComputerdouble
	--场均分
	if LRDDZ_Game.matchType == DDZGameMatchType.JDMatch then
		userwinmoney = body["user_info"]
	end
	
	for i=1,#userwinmoney do
		local uid = userwinmoney[i]["uid"]
		local winmoney = userwinmoney[i]["winmoney"]
		local tax = userwinmoney[i]["tax"]
		local cards = userwinmoney[i]["cards"]
		local double = userwinmoney[i]["double"]


		if uid ~= winner then
			residueCards = LRDDZ_Game.ServerToCard(cards)

		end

		if uid == Computer.id then
			if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
				Computer.gold = Computer.gold + winmoney
			else
				Computer.raceScore = Computer.raceScore + winmoney
			end
			computerWinGold = winmoney
			computerdouble = double
			--显示剩余牌
			if #cards > 0 then
				Computer.ResidueCards(LRDDZ_Game.ServerToCard(cards))
			end
		elseif uid == tonumber(EginUser.Instance.uid) then
			integration = winmoney
			if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
				EginUser.Instance.bagMoney = EginUser.Instance.bagMoney + winmoney
    			Avatar.avatarGold = Avatar.avatarGold + winmoney
    		else
    			Player.raceScore = Player.raceScore + winmoney
    		end
    		
		else
			if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
				OtherComputer.gold = OtherComputer.gold + winmoney
			else
				OtherComputer.raceScore = OtherComputer.raceScore + winmoney
			end
			otherComputerWinGold = winmoney
			otherComputerdouble = double
			if #cards > 0 then
				OtherComputer.ResidueCards(LRDDZ_Game.ServerToCard(cards))
			end
		end
	end
	local winnertype = nil
	local sex = 1
	if winner == tonumber(EginUser.Instance.uid) then
		winnertype = CharacterType.Player
		sex = Avatar.getAvatarSex()
	elseif winner == Computer.id then
		winnertype = CharacterType.Computer
		sex = Computer.sex
	else
		winnertype = CharacterType.OtherComputer
		sex = OtherComputer.sex
	end
	Player.EnableTouchCards(false)--玩家不可选牌了
	Computer.HideCardsNum()--电脑的牌数隐藏 
	OtherComputer.HideCardsNum()--另一个玩家的牌数隐藏
	--GamePanel.multiplesNum.transform:GetComponent("UILabel").text = "×"..double;
	if isspring == true and MyCommon.GetGameEffState() == 1 then
		--播放春天音效和特效
		local chuntianName = "chuntian"
		if winnertype == CharacterType.Player and Player.identity == Identity.Farmer then
			chuntianName = "fanchuntian"
		elseif winnertype == CharacterType.Computer and Computer.identity == Identity.Farmer then
			chuntianName = "fanchuntian"
		elseif winnertype == CharacterType.OtherComputer and OtherComputer.identity == Identity.Farmer then
			chuntianName = "fanchuntian"
		end

		LRDDZ_SoundManager.OtherHumanSound(winnertype,"chuntian",sex == 1)
		LRDDZ_SoundManager.PlaySoundEffect("chuntian")
		ParticleManager.ShowParticle("Particle", chuntianName,Vector3.New(1,1,1),Vector3.New(298.96,-23.03155,-12.07858),Vector3.New(-5.0331,0.6028,3.707),3)
		coroutine.wait(3)
	end
	--清空3D的牌
	CharacterPlayer.Clear()
	CharacterComputer.Clear()
	if LRDDZ_Game.gameType == DDZGameType.Three then
		CharacterOtherComputer.Clear()
	end
	Player.popCardCount=0--清空玩家出牌次数
	Computer.popCardCount=0--清空电脑出牌次数
	OtherComputer.popCardCount = 0;local temp = {}
	DeskCardsCache.RemainCards(temp) --清空记牌器
	--刷新记牌器
	Event.Brocast(GameEvent.NoteCard)
	--播放胜利动画
	local time = 0
	if winnertype == CharacterType.Player then
		winTimes = winTimes + 1
		time = 0.3
	else
		time = 0.3
 	end
 	--判断玩家是否胜利
 	if winnertype == CharacterType.Computer then
 		if Computer.identity == Player.identity then
 			winnertype = CharacterType.Player
 			winTimes = winTimes + 1
 		else
 			winTimes = 0
 		end
 	elseif winnertype == CharacterType.OtherComputer then
 		if OtherComputer.identity == Player.identity then
 			winnertype = CharacterType.Player
 			winTimes = winTimes + 1
 		else
 			winTimes = 0
 		end
 	end

 	if LRDDZ_Game.gameType == DDZGameType.Two then

			 	--打开结算界面
		if  self.gameOverPanel == nil then 
			LRDDZ_ResourceManager.Instance:CreatePanel('LR_GameOverPanel','LR_GameOverPanel',true,function(obj)
				 self.gameOverPanel = obj
				 LR_GameOverPanel.SetGameOverInfoByServer(winnertype,discards,double,hidedouble,bombtimes,residueCards,integration) --设置结算面板的数据
			end);
		else 
			self.gameOverPanel:SetActive(true)
			LR_GameOverPanel.SetGameOverInfoByServer(winnertype,discards,double,hidedouble,bombtimes,residueCards,integration)
		end 
	else
		if  self.gameOverPanel == nil then 
			LRDDZ_ResourceManager.Instance:CreatePanel('SR_GameOverPanel','SR_GameOverPanel',true,function(obj)
				 self.gameOverPanel = obj
				 SR_GameOverPanel.SetGameOverInfoByServer(winnertype,discards,double,hidedouble,bombtimes,residueCards,integration,computerWinGold,otherComputerWinGold,computerdouble,otherComputerdouble) --设置结算面板的数据
				 if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
					self.gameOverPanel:SetActive(false)
					local function func(  )
						coroutine.wait(5)
						GamePanel.GameOverAnim(true)
					end
					coroutine.start(func)
				end
			end);
		else 
			self.gameOverPanel:SetActive(true)
			SR_GameOverPanel.SetGameOverInfoByServer(winnertype,discards,double,hidedouble,bombtimes,residueCards,integration,computerWinGold,otherComputerWinGold,computerdouble,otherComputerdouble)
			if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
				self.gameOverPanel:SetActive(false)
				local function func(  )
					coroutine.wait(5)
					GamePanel.GameOverAnim(true)
				end
				coroutine.start(func)
			end
		end 


	end

end
--场均分赛
--{"body": {"user_info": [{"add_score": 60, "uid": 881604, "cards": [23, 49], 
--"double": 6, "win_round": 2, "fail_round": 1, "ave_score": 186, "round": 3,
-- "sum_score": 560, "is_win": false}, {"add_score": 600, "uid": 127510, "cards": [], 
--"double": 6, "win_round": 1, "fail_round": 0, "ave_score": 600, "round": 1, "sum_score": 600, "is_win": true},
-- {"add_score": 600, "uid": 119532, "cards": [19, 45], "double": 6, "win_round": 1, "fail_round": 0, 
--"ave_score": 600, "round": 1, "sum_score": 600, "is_win": true}], "rocket_times": 0, "winner": 127510, 
--"bomb_times": 1, "is_spring": false}, "tag": "gameover", "type": "ddz"}


function GameCtrl.CJFGameOver(messageObj)
	local body = messageObj["body"]
	local user_info = body["user_info"]
	local winner = body["winner"]
	local isspring = body["is_spring"]

	local iswin = false
	local addscore = 0
	local avescore = 0
	local p_round = 0
	for i=1,#user_info do
		local add_score = user_info[i]["add_score"]
		local uid = user_info[i]["uid"]
		local cards = user_info[i]["cards"]
		local double = user_info[i]["double"]
		local ave_score = user_info[i]["ave_score"]
		local round = user_info[i]["round"]
		local sum_score = user_info[i]["sum_score"]
		local is_win = user_info[i]["is_win"]
		local win_round = user_info[i]["win_round"]
		local fail_round = user_info[i]["fail_round"]
		if uid == tonumber(EginUser.Instance.uid) then
			GamePanel.SetSumScore(sum_score)
			GamePanel.SetAveScore(ave_score)
			Player.raceScore = sum_score
			iswin = is_win
			addscore = add_score
			avescore = ave_score
			p_round = round
			GamePanel.SetWin_Lose(win_round,fail_round)
		elseif uid == Computer.id then
			Computer.raceScore = sum_score
			if #cards > 0 then
				Computer.ResidueCards(LRDDZ_Game.ServerToCard(cards))
			end
		elseif uid == OtherComputer.id then
			OtherComputer.raceScore = sum_score
			if #cards > 0 then
				OtherComputer.ResidueCards(LRDDZ_Game.ServerToCard(cards))
			end
		end
	end


	local winnertype = nil
	local sex = 1
	if winner == tonumber(EginUser.Instance.uid) then
		winnertype = CharacterType.Player
		sex = Avatar.getAvatarSex()
	elseif winner == Computer.id then
		winnertype = CharacterType.Computer
		sex = Computer.sex
	else
		winnertype = CharacterType.OtherComputer
		sex = OtherComputer.sex
	end
	Player.EnableTouchCards(false)--玩家不可选牌了
	Computer.HideCardsNum()--电脑的牌数隐藏 
	OtherComputer.HideCardsNum()--另一个玩家的牌数隐藏
	--GamePanel.multiplesNum.transform:GetComponent("UILabel").text = "×"..double;
	if isspring == true and MyCommon.GetGameEffState() == 1 then
		--播放春天音效和特效
		local chuntianName = "chuntian"
		if winnertype == CharacterType.Player and Player.identity == Identity.Farmer then
			chuntianName = "fanchuntian"
		elseif winnertype == CharacterType.Computer and Computer.identity == Identity.Farmer then
			chuntianName = "fanchuntian"
		elseif winnertype == CharacterType.OtherComputer and OtherComputer.identity == Identity.Farmer then
			chuntianName = "fanchuntian"
		end

		LRDDZ_SoundManager.OtherHumanSound(winnertype,"chuntian",sex == 1)
		LRDDZ_SoundManager.PlaySoundEffect("chuntian")
		ParticleManager.ShowParticle("Particle", chuntianName,Vector3.New(1,1,1),Vector3.New(298.96,-23.03155,-12.07858),Vector3.New(-5.0331,0.6028,3.707),3)
		coroutine.wait(3)
	end
	--清空3D的牌
	CharacterPlayer.Clear()
	CharacterComputer.Clear()
	if LRDDZ_Game.gameType == DDZGameType.Three then
		CharacterOtherComputer.Clear()
	end
	Player.popCardCount=0--清空玩家出牌次数
	Computer.popCardCount=0--清空电脑出牌次数
	OtherComputer.popCardCount = 0;local temp = {}
	DeskCardsCache.RemainCards(temp) --清空记牌器
	--刷新记牌器
	Event.Brocast(GameEvent.NoteCard)
	--播放胜利动画
	local time = 0
	if winnertype == CharacterType.Player then
		winTimes = winTimes + 1
		time = 0.3
	else
		time = 0.3
 	end
 	--判断玩家是否胜利
 	if winnertype == CharacterType.Computer then
 		if Computer.identity == Player.identity then
 			winnertype = CharacterType.Player
 			winTimes = winTimes + 1
 		else
 			winTimes = 0
 		end
 	elseif winnertype == CharacterType.OtherComputer then
 		if OtherComputer.identity == Player.identity then
 			winnertype = CharacterType.Player
 			winTimes = winTimes + 1
 		else
 			winTimes = 0
 		end
 	end

 	--显示动画
 	JDRaceOverPanel.SetValue(p_round,iswin,addscore,Player.raceScore,avescore)
 	if jdRaceOverPanel == nil  then
 		LRDDZ_ResourceManager.Instance:CreatePanel('JDRaceOverPanel','JDRaceOverPanel',true,function(obj)
 			jdRaceOverPanel = obj
 		end)
 	else
 		jdRaceOverPanel:SetActive(true)
 	end

end

function GameCtrl.Create3DPoker()
	local cards = Deck.GetLibrary()
	self.pokerlist = {}
	for i = 1, #cards do 
		local name = nil
		if cards[i].suits == Suits.None then 
			name = WeightString[cards[i].weight]
		else 
			name = cards[i].suits..WeightString[cards[i].weight]
		end 
		local cardinfo = {}
		cardinfo.name = name
		cardinfo.Card = cards[i]
		cardinfo.GameObject = nil
		self.pokerlist[i] = cardinfo
		LRDDZ_ResourceManager.Instance:CreatePoker(name, Vector3.New(0.3,0.3,0.3),Vector3.New(8,-10,0.8), false,function(obj,objname)
			obj.transform.localRotation = Quaternion.Euler(-90, 90, 0)
			obj.name = obj.name;
			--[[
			for j = 1, #self.pokerlist do 
				if self.pokerlist[j].name == obj.name then 
					self.pokerlist[j].GameObject = obj
				end  
			end 
			]]
			self.pokerlist[i].GameObject = obj
		end)
	end 
end 
self.dealing = false
function GameCtrl.Show3DPoker(newlibrary)
	--初始化Order
	OrderCtrl.GradInit()
	if #self.pokerlist ~= 54 then
		error("重新创建牌")
		GameCtrl.Create3DPoker()
	end
	--重新按洗牌后的顺序排序
	--[[
	local newPokerList = {}
	for i=1,#newlibrary do 
		for j =1, #self.pokerlist do 
			if self.pokerlist[j].Card.weight == newlibrary[i].weight and self.pokerlist[j].Card.suits == newlibrary[i].suits then 
				table.insert(newPokerList,self.pokerlist[j])
				break
			end 
		end  
	end 
	self.pokerlist = newPokerList
	]]
	------------------------------------弹出牌
	self.dealing = true
	for i =1, #self.pokerlist do
		local path = {}
		--local point1 = Vector3.New(1, i*0.05+18, 11)
	    --self.pokerlist[i].GameObject.transform.localPosition = Vector3.New(1, 16, 9)
	    local point1 = Vector3.New(8, i*0.05+21, 0.8)
	    self.pokerlist[i].GameObject.transform.localPosition = Vector3.New(8, 20, 0.8)
	    self.pokerlist[i].GameObject.transform.localRotation = Quaternion.Euler(-90, 90, 0)
		iTween.MoveTo(self.pokerlist[i].GameObject, iTween.Hash("position",point1 , "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear)); --easeOutBack
		--iTween.ScaleTo(self.pokerlist[i].GameObject, iTween.Hash("scale",Vector3.New(0.3+i*0.01, 0.3+i*0.01, 0.3+i*0.01) , "time", 0.2, "islocal", true, "easetype", iTween.EaseType.linear));
	end 
	coroutine.wait(0.2)
	for i =1, #self.pokerlist do
		local path = {}
		--local point2 = Vector3.New(1, i*0.01+18, 11) 
		local point2 = Vector3.New(8, i*0.01+20, 0.8) 
		iTween.MoveTo(self.pokerlist[i].GameObject, iTween.Hash("position",point2 , "time", 0.05, "islocal", true, "easetype", iTween.EaseType.linear)); --easeOutBack
		--iTween.ScaleTo(self.pokerlist[i].GameObject, iTween.Hash("scale",Vector3.New(0.3, 0.3, 0.3)  , "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));
	end 
	coroutine.wait(0.5)
	----------------------------------------三人发牌
	if LRDDZ_Game.gameType == DDZGameType.Three then
		print("三人发牌")
		math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
	 	local index = 0
	 	for i = #self.pokerlist, #self.pokerlist-17, -1 do 
		 	index = index+1
			local num = math.random(100)
			local x = 0
			local z =  0 
			if index%3 == 0 then 
				x = num/100 + 7
				--z = 13.5
				z = 11;
			elseif index%3 == 1 then
				x =  num/100 + 2
				--z = 9
				z = -3.3
			elseif index%3 == 2 then
				x =  num/100 + 13.5
				--z = 9
				z = -3
			end 
			iTween.MoveTo(self.pokerlist[i].GameObject, iTween.Hash("position", Vector3.New(x, index*0.01+20, z), "time", 0.08, "islocal", true, "easetype", iTween.EaseType.linear));
			local roy = 360*num/100 
			iTween.RotateTo(self.pokerlist[i].GameObject, iTween.Hash("rotation", Vector3.New(-90, roy, 0), "time", 0.08, "islocal", true, "easetype", iTween.EaseType.linear));

			LRDDZ_SoundManager.PlaySoundEffect("deal")
			coroutine.wait(0.08)
		end
	else
		print("二人发牌")
	 	math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
	 	local index = 0
	 	for i = #self.pokerlist, #self.pokerlist-33, -1 do 
		 	index = index+1
			local num = math.random(100)
			local x = 0
			local z =  0 
			if index%2 == 0 then 
				x = num/100 + 14
				--z = 13.5
				z = 6.7;
			else 
				x =  num/100 + 2
				--z = 9
				z = -3.3
			end 
			iTween.MoveTo(self.pokerlist[i].GameObject, iTween.Hash("position", Vector3.New(x, index*0.01+20, z), "time", 0.05, "islocal", true, "easetype", iTween.EaseType.linear));
			local roy = 360*num/100 
			iTween.RotateTo(self.pokerlist[i].GameObject, iTween.Hash("rotation", Vector3.New(-90, roy, 0), "time", 0.05, "islocal", true, "easetype", iTween.EaseType.linear));

			LRDDZ_SoundManager.PlaySoundEffect("deal")
			coroutine.wait(0.03)
		end 
	end
	--[[if LRDDZ_Game.gameType == DDZGameType.Two then
		print("二人发牌")
		 math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
		 local index = 0
		 for i = #self.pokerlist, #self.pokerlist-33, -1 do 
		 	index = index+1
			local num = math.random(100)
			local x = 0
			local z =  0 
			if index%2 == 0 then 
				x = num/100 + 7
				--z = 13.5
				z = 1;
			else 
				x =  num/100 - 2
				--z = 9
				z = -7
			end 
			iTween.MoveTo(self.pokerlist[i].GameObject, iTween.Hash("position", Vector3.New(x, index*0.01+18.2, z), "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));
			local roy = 360*num/100 
			iTween.RotateTo(self.pokerlist[i].GameObject, iTween.Hash("rotation", Vector3.New(-90, roy, 0), "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));

			LRDDZ_SoundManager.PlaySoundEffect("deal")
			coroutine.wait(0.03)
		end 
	else
		--三人
		print("三人发牌")
		math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
	 	local index = 0
	 	for i = #self.pokerlist, #self.pokerlist-50, -1 do 
		 	index = index+1
			local num = math.random(100)
			local x = 0
			local z =  0 
			if index%3 == 0 then 
				x = num/100 + 7
				--z = 13.5
				z = 1;
			elseif index%3 == 1 then
				print("1")
				x =  num/100 - 2
				--z = 9
				z = -7
			elseif index%3 == 2 then
				print("2")
				x =  num/100 - 5
				--z = 9
				z = -10
			end 
			iTween.MoveTo(self.pokerlist[i].GameObject, iTween.Hash("position", Vector3.New(x, index*0.01+18.2, z), "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));
			local roy = 360*num/100 
			iTween.RotateTo(self.pokerlist[i].GameObject, iTween.Hash("rotation", Vector3.New(-90, roy, 0), "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));

			LRDDZ_SoundManager.PlaySoundEffect("deal")
			coroutine.wait(0.03)
		end
	end
--]]
	

	coroutine.wait(0.15)

	local playerPokers = {}
	local playerCards = Player.GetLibrary()
	for i = 1, #playerCards do 
		for j = 1,  #self.pokerlist do 
			if playerCards[i].cardName == self.pokerlist[j].name then 
				table.insert(playerPokers,self.pokerlist[j])
				table.remove(self.pokerlist,j)
				break
			end 
		end 
	end 
	Event.Brocast(GameEvent.ShowPlayerHandCards, playerPokers)

	--第一位电脑
	local computerPokers = {}
	
		--全部一样的牌
		for i=1,17 do
			local cardinfo = {}
			cardinfo.name = self.pokerlist[1].name
			cardinfo.Card = self.pokerlist[1].Card
			cardinfo.GameObject = GameObject.Instantiate(self.pokerlist[1].GameObject,self.pokerlist[1].GameObject.transform.position,self.pokerlist[1].GameObject.transform.rotation)
			table.insert(computerPokers,cardinfo)
		end

	Event.Brocast(GameEvent.ShowComputerHandCards, computerPokers)

	--另一位电脑
	if LRDDZ_Game.gameType == DDZGameType.Three then
		local otherComputerPokers = {}
		
		--全部一样的牌
		for i=1,17 do
			local cardinfo = {}
			cardinfo.name = self.pokerlist[1].name
			cardinfo.Card = self.pokerlist[1].Card
			cardinfo.GameObject = GameObject.Instantiate(self.pokerlist[1].GameObject,self.pokerlist[1].GameObject.transform.position,self.pokerlist[1].GameObject.transform.rotation)
			table.insert(otherComputerPokers,cardinfo)
		end

		Event.Brocast(GameEvent.ShowOtherComputerHandCards, otherComputerPokers)
	end

	for r = 1, #self.pokerlist do 
	 	self.pokerlist[r].GameObject.transform.localPosition = Vector3.New(0, r*0.01+0, 9)
	end 
	--ui牌动画
	self.Dealc()
	--电脑牌数动画
	for i=1,17 do
		coroutine.wait(0.02);
		Computer.SetCardsNum(i,0)
		if LRDDZ_Game.gameType == DDZGameType.Three then
			OtherComputer.SetCardsNum(i,0)
		end
	end
end 
--发牌
function  GameCtrl.DealCards(cards)
	--洗牌
		Deck.Shuffle()
	---整理洗牌后的3D牌
	local library = Deck.GetLibrary()
	local newlibrary = {}
	for i=1,#library do 
		table.insert(newlibrary,library[i])
	end 
	coroutine.start(self.Show3DPoker,newlibrary)
	coroutine.wait(0.5)
	--[[
	--发牌
	for i= 1,34 do 
		local card = Deck.Deal()
		if card ~= nil then 
			if i%2 == 0 then 
				--Player.AddCard(card) --发玩家牌
			else 
				Computer.AddCard(card) --发电脑
				--Computer.ShowCardsNum(true)
				coroutine.wait(0.07)
			end 
		else
			print("Deck card not mare then deal") 
		end 
	end 
	--发底牌
	for i=1, 3 do 
		local card = Deck.Deal()
		if card ~= nil then 
			BottomCard.AddCard(card)
		else
			print("Deck card not mare then deal  to BottomCard") 
		end 
	end 
	]]
end 
function GameCtrl.Dealc()
	---显示UI手牌动画
	Player.PutUICards()
	--Computer.ShowCardsNum(true)	
end

--抢完地主
function GameCtrl.BecomeLandlord(current)
	--更新身份
	
	DeskCardsCache.ClearRecord()
	OrderCtrl.Init(current)
	if current == CharacterType.Player then 
		Player.identity = Identity.Landlord
		Computer.identity = Identity.Farmer
		OtherComputer.identity = Identity.Farmer
	elseif current == CharacterType.Computer then
		Computer.identity = Identity.Landlord
		Player.identity = Identity.Farmer
		OtherComputer.identity = Identity.Farmer
	else
		Computer.identity = Identity.Farmer
		Player.identity = Identity.Farmer
		OtherComputer.identity = Identity.Landlord
	end 
	GamePanel.SetPlayerLandlordIcon(true,true)
	GamePanel.SetComputerLandlordIcon(true,true)
	if LRDDZ_Game.gameType == DDZGameType.Three then
		--OtherComputer.SetLandlordIcon(true,true)
		GamePanel.SetOtherComputerLandlordIcon(true,true)
	end
	--显示底牌
	Event.Brocast(GameEvent.ShowBottomCards,BottomCard.GetLibrary(),current)
	--计算底牌倍数
	--发底牌
	coroutine.start(self.DealOnBottom,current)
	--显示牌张数
	--Computer.ShowCardsNum(true)
	
end 
function GameCtrl.BeginPlayCard(current,timeout)
	--Player.EnableTouchCards(true)
	CountDownPanel.OpenCountDown(current,timeout)
	if current == CharacterType.Player then 
		if GameCtrl.isTuoguan == false then
			Event.Brocast(GameEvent.ShowPlay,true,false)
		end
	end

	DeskCardsCache.AllClear()

	--显示剩余牌文字
	self.ShowGameText(current)
end
--计算底牌倍数
function GameCtrl.CalculationBottomMultiples()
	local cards = BottomCard.GetLibrary()
	----是否有双王
	if CardBottomRule.IsHasDoubleJoker(cards) then 
		--self.set_dipai_multiple(4)
		return "双王×4倍"
	end 
	--是否有单王
    if CardBottomRule.IsHasSingleJoker(cards) then 
    	--self.set_dipai_multiple(2)
    	return "单王×2倍"
    end 
    --是否有对2
    if CardBottomRule.IsHasDouble(cards) then 
    	--self.set_dipai_multiple(2)
    	return "一对×2倍"
    end 
    --是否有顺子
    if CardBottomRule.IsHasDearFriend(cards) then 
    	--self.set_dipai_multiple(3)
    	return "顺子×3倍"
	end

	--是否有同花
	if CardBottomRule.IsHasSameFlowers(cards)  then 
		--self.set_dipai_multiple(3)
		return "同花×3倍"
	end

	--是否有3条
	if CardBottomRule.IsHasThree(cards) then 
		--self.set_dipai_multiple(3)
		return "三条×3倍"
	end 
	return "1倍"
end 
function GameCtrl.DealOnBottom(current)
	self.Deal3DBottom(current)
	if current == CharacterType.Computer then 
		if Computer.isshowCard then
			while BottomCard.GetCardsCount() ~= 0 do 
	        	local card =  BottomCard.Deal()
				Computer.AddCard(card)
			end 
			Computer.UpdateOpenHandCards()
		end
	elseif  current == CharacterType.Player then  
		local recDealCards = {}
		while BottomCard.GetCardsCount() ~= 0 do 
        	local card =  BottomCard.Deal()
		 	Player.AddCard(card)
		 	table.insert(recDealCards,card)
		end
		Player.ShowCards() 
		while true do
			if self.dealing == true then
				coroutine.wait(0.5)
			else
				 --添加动画
				for i=1,#recDealCards do
				 	for j=1,#Player.CardObjectList do
				 		if Player.CardObjectList[j].Card.weight == recDealCards[i].weight and Player.CardObjectList[j].Card.suits == recDealCards[i].suits then
					 		local pos = Player.CardObjectList[j].GameObject.transform.localPosition
					 		Player.CardObjectList[j].GameObject.transform.localPosition = pos + Vector3.New(0,80,0)
					 		iTween.MoveTo(Player.CardObjectList[j].GameObject, iTween.Hash("y",pos.y, "time", 0.5,"islocal",true,"delay",1, "easetype", iTween.EaseType.linear));
				 		end
				 	end
				end
				local function delayfunc()
					--先不能选牌，动画结束后才可选牌
					Player.EnableTouchCards(false)
					coroutine.wait(1.5)
					Player.EnableTouchCards(true)
				end
				coroutine.start(delayfunc)
				break
			end
		end
	else
		if OtherComputer.isshowCard then
			while BottomCard.GetCardsCount() ~= 0 do 
	        	local card =  BottomCard.Deal()
				OtherComputer.AddCard(card)
			end 
			OtherComputer.UpdateOpenHandCards()
		end
	end 
end 

function GameCtrl.Deal3DBottom(current)
	local bottompoker = {}
	local cards = BottomCard.GetLibrary()
	for i = 1, #cards do 
		for j = 1,  #self.pokerlist do 
			if cards[i].cardName == self.pokerlist[j].name then 
				table.insert(bottompoker,self.pokerlist[j])
				table.remove(self.pokerlist,j)
				break
			end 
		end 
	end 
	if current == CharacterType.Player then 
		CharacterPlayer.ShowBottom(bottompoker)
	else  
			--放回到pokerlist中去
			for i=1,#bottompoker do
				table.insert(self.pokerlist,bottompoker[i])
			end
			--清空
			bottompoker = {}
			--创建三张底牌
			for i=1,3 do
				local cardinfo = {}
				cardinfo.name = self.pokerlist[1].name
				cardinfo.Card = self.pokerlist[1].Card
				cardinfo.GameObject = GameObject.Instantiate(self.pokerlist[1].GameObject,self.pokerlist[1].GameObject.transform.position,self.pokerlist[1].GameObject.transform.rotation)
				table.insert(bottompoker,cardinfo)
			end
		if current == CharacterType.Computer then 
			CharacterComputer.ShowBottom(bottompoker)
		else
			CharacterOtherComputer.ShowBottom(bottompoker)
		end

	end 
end 

--检查游戏是否结束
function GameCtrl.CheckGameOver()
	--if Global.server == true then return false end
	local isOver = false
	local winnertype = nil 
	if Computer.identity == Identity.Landlord then 
		if self.letCardsNum >= Player.GetCardsCount() then 
			isOver = true 
			winnertype = CharacterType.Player
		elseif Computer.GetCardsCount() <= 0 then 
			isOver = true 
			winnertype = CharacterType.Computer
		end 
	elseif Player.identity == Identity.Landlord then 
		if self.letCardsNum >= Computer.GetCardsCount() then 
			isOver = true 
			winnertype = CharacterType.Computer
		elseif Player.GetCardsCount() <= 0 then 
			isOver = true 
			winnertype = CharacterType.Player
		end 
	end 

	if isOver == true then   --游戏结束
		OrderCtrl.state = GameState.End
		 --人物动画
		if winnertype == CharacterType.Player then 
			CharacterPlayer.WinAnimator()
			CharacterComputer.LostOutAnimator()
			if LRDDZ_Game.gameType == DDZGameType.Three then
				CharacterOtherComputer.LostOutAnimator()
			end
		else 
			CharacterComputer.WinAnimator()
			CharacterPlayer.LostOutAnimator()
			if LRDDZ_Game.gameType == DDZGameType.Three then
				CharacterOtherComputer.WinAnimator()
			end
		end 
		coroutine.start(self.OpenGameOverView,winnertype) --结算
	end 

	return isOver
end 
--检测是否游戏结束，网络版
function GameCtrl.CheckGameOverByServer(charactortype,holdnum)
	--判断是否结束
	if holdnum <= 0 then
		coroutine.start(GameCtrl.PlayWinAnimator,charactortype)
	elseif holdnum <= 2 and charactortype == CharacterType.Computer then

	elseif holdnum <= 2 and charactortype == CharacterType.OtherComputer then
		OtherComputer.ShowWarning(true)
	end

	if holdnum <= 2 and holdnum > 0 then
		--更换背景音乐
		--[[
		local audioSource = LRDDZ_MusicManager.instance.GetAudioSource
		if audioSource ~= nil and (audioSource.clip.name ~= "bgsound4" and audioSource.clip.name ~= "bgsound5") then
	        local rand = math.random(4,5);
	        LRDDZ_MusicManager.instance:PlayMuisc("bgsound"..rand, true, true, false, 0.5)
	    end
	    ]]
	end

end
function GameCtrl.PlayWinAnimator(charactortype)
	coroutine.wait(1) --等待打牌动作完成后播放动画
	--清空3D的牌
	CharacterPlayer.Clear()
	CharacterComputer.Clear()
	if LRDDZ_Game.gameType == DDZGameType.Three then
		CharacterOtherComputer.Clear()
	end
	local winnerIdentity = nil
	if charactortype == CharacterType.Player then
		winnerIdentity = Player.identity
	elseif charactortype == CharacterType.Computer then
		winnerIdentity = Computer.identity
	else
		winnerIdentity = OtherComputer.identity
	end
	CharacterPlayer.GameOverAnimator(winnerIdentity)
	CharacterComputer.GameOverAnimator(winnerIdentity)
	if LRDDZ_Game.gameType == DDZGameType.Three then
		CharacterOtherComputer.GameOverAnimator(winnerIdentity)
	end
	if winnerIdentity == Player.identity then 
		--CharacterPlayer.WinAnimator()
		--CharacterComputer.LostOutAnimator()

		--创建胜利灯光特效
		local shengliname = "shenglinan"
		if Avatar.getAvatarSex() == 1 then
			shengliname = "shenglinan"
		--else
			--shengliname = "shenglinv"
		end
			ParticleManager.ShowParticle("Particle",shengliname,Vector3.New(1,1,1),Vector3.New(14.5,19.2,42.42),Vector3.New(-80,-161.7163,161.4416),5)
			LRDDZ_SoundManager.PlaySoundEffect("win");
		if Player.identity == Identity.Farmer then
			LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"win1",Avatar.getAvatarSex() == 1)
		else
			LRDDZ_SoundManager.OtherHumanSound(CharacterType.Player,"win",Avatar.getAvatarSex() == 1)
		end
	else 
		--CharacterComputer.WinAnimator()
		--CharacterPlayer.LostOutAnimator()
		LRDDZ_SoundManager.PlaySoundEffect("lose");
	end 
	--隐藏按钮
	--GamePanel.ActivePlay(false)
	
	Event.Brocast(GameEvent.ReSetInfo)
	GamePanel.ActiveReady(false)
	--隐藏倒计时
	CountDownPanel.CancelCountDown(false)
	GamePanel.GameOverAnim(false)
end

function GameCtrl.ShowGameText(current)
	Event.Brocast(GameEvent.ShowGameText, self.foldNum)
end 

--托管
function GameCtrl.TuoGuan()
	--if OrderCtrl.state == GameState.Play then
		Player.EnableTouchCards(false)
		self.isTuoguan = true 
		return true 
	--end 
	--return false
end  

--取消托管
function GameCtrl.CancelTuoGuo()
	if OrderCtrl.currentAuthority == CharacterType.Player then 
		--Player.TuoguanFunc()
	end 
	Player.EnableTouchCards(true)
	self.isTuoguan = false
end 

function GameCtrl.ReSetGame()
	self.Clear()--重置玩家数据

	Computer.Reset()
	OtherComputer.Reset()

	Event.Brocast(GameEvent.ReSetInfo)--重设UI界面信息

	self.InitData()
	--OrderCtrl.bigest = CharacterType.Player
	OrderCtrl.state = GameState.Before --重置状态为等待发牌
	CountDownPanel.CancelCountDown(false) --关闭倒计时


end 
function GameCtrl.Clear()
	Player.Clear()
	Computer.Clear()
	OtherComputer.Clear()
	Deck.Clear()
	BottomCard.Clear()
	DeskCardsCache.AllClear()

	CharacterPlayer.Clear()
	CharacterComputer.Clear()
	if LRDDZ_Game.gameType == DDZGameType.Three then
		CharacterOtherComputer.Clear()
	end
	for i =1, #self.pokerlist do 
		destroy(self.pokerlist[i].GameObject)
	end 
	self.pokerlist = {}
	self.changeCardWeight = Weight.None
	self.otherChangeCardWeigh = Weight.None
end 