require "GameNN/UISoundManager"
require "GameSHHZ/GameSHHZSetting"
require "GameSHHZ/GameSHHZSettlement"
require "GameSHHZ/GameSHHZForBanker"
require "GameSHHZ/GameSHHZRecord"
require "GameSHHZ/GameSHHZPlayer"

local this = LuaObject:New()
GameSHHZUI = this
-- 无座玩家
local panelFriend;
-- 上庄
local panelBanker;
-- 设置
local panelSetting;
-- 主界面
local panelMain;
-- 结算
local panelSettlement;
local jsonSettlement;	-- 结算用的参数
-- 确定退出
local panelExit;
-- 倒计时
local panelRemainTime;
local labelRemainTime;
-- 加注的UI
local betParent;
local myBetCount = {};
-- local myServerCount = {};
local allBetCount = {};
-- 各区域是否已经达到最大押注限制
local lockAreaDc = {};
local curPlayerBetCount;
-- 开始下注，停止下注
local betTips;
-- 等待下一局的提示
local mytips;
local errortips;
-- 
local panelIngot;
local ingotTable = {};
local betTypeIngot = {};	-- 押注类型
local ingotTableUseCount;
local ingotPrefab;
-- 记录
this.pathData = {};
local recordTable = {};
local recordTableUseCount;
local recordPrefab;
local panelRecord;
-- 8个座位玩家
local seatPlayers;
-- 服务器发来的所有玩家
local players = {};
local playerCount = 0;
-- 等待上庄的玩家
local waitBankerPlayer = {};
-- 下注队列
local betMsgQueue = {};
-- 庄家赢了多少钱
local bankerWin = 0;
-- 庄家赢了多少钱
local btnBanker;
-- 上庄需要的金额数
this.minBankerMoney = 0;
-- 时间倒数
local countDownTime = -1;
local totalDownTime = 1;
local playHurryup = true;

-- 角色对话框
local charDialogueFrame;
local charDialogue;

-- 下注按钮的面析
local chipPanel;

-- 
local mBankerID = 0;

local receiveMessageTime = 0;

-- 游戏状态
this.GameState = { Begin = 1, Play = 2, Bet = 3, Open = 4, PayReward = 5, End = 6 };
this.CurState = this.GameState.Begin;

this.SpriteTipsType = { WiatNextBet = "waitnext", ChangeBanker = "changebanker", MakeBankerfail = "makebankerfail", MakeBankerSuccess = "makebankersuccess", BetMax="betmax" };

local BGMusic;


-------------------------------------------------------------------------------------------------
-- 下注类型
local BetType = { "SmallArea", "MediumArea", "BigArea", "Pair1Area", "Pair2Area", "Pair3Area", "Pair4Area", "Pair5Area", "Pair6Area" };

local windowsProcess = nil
function this.linePCPlatform()
	if SHHZGameSetting.isPCPlatform == true then
		windowsProcess = this.gameObject:AddComponent(LuaHelper.GetType("WindowsProcess"));
		windowsProcess:AddListener(this.MySocketReceiveMessage);
		windowsProcess:init();

		SettingInfo.bgVolume = 1.0;
		SettingInfo.effectVolume = 1.0;
	else
		-- 向服务器开始游戏的发送消息
		this.mono:StartGameSocket();
		windowsProcess = nil;

		SettingInfo.bgVolume = 1.0;
		SettingInfo.effectVolume = 1.0;
	end

    UnityEngine.QualitySettings.SetQualityLevel(2);
    UnityEngine.QualitySettings.vSyncCount = 0;
end

-------------------------------------------------------------------------------------------------
function this.Awake()
	this.linePCPlatform();
	
	-- 初始化数组
	myBetCount = {};
	allBetCount = {};
	this.pathData = {};
	recordTable = {};
	players = {};
	waitBankerPlayer = {};
	betMsgQueue = {};
	lockAreaDc = {};

	-- 时间倒数
	countDownTime = -1;
	totalDownTime = 1;
	playHurryup = true;

	-- 初始化声音
	UISoundManager.Init(this.gameObject);
	-- 随机种子
	math.randomseed(os.time());
	local randomMusic = math.random(1, 3);
	BGMusic = "Music"..randomMusic;
	UISoundManager.AddAudioSource("gameshhz/sounds",BGMusic, true);
	UISoundManager.AddAudioSource("gameshhz/sounds","Button", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","Dice", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","StartBet", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","Shansuo", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","Laugh", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","Laugh1", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","poppanel", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","Trip", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","hurryup", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","Xiazhu", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","Open", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","recordmove", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","Stop", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","dialogue1", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","dialogue2", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","dialogue3", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","dialogue4", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","charOpen1", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","charOpen2", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","charLost1", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","charLost2", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","charLost3", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","thefat1lost", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","thefat2lost", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","thefat1win", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","thefat2win", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","bankerwin1", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","bankerwin2", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","bankerwin3", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","bankerlost1", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","bankerlost2", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","bankerlost3", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","charBet", false);
	UISoundManager.AddAudioSource("gameshhz/sounds","du", false);

	--主界面
	panelMain = this.transform:FindChild("MainPanel").gameObject;
	betParent = panelMain.transform:FindChild("betPanel");

	--开始下注，停止下注
	betTips = panelMain.transform:FindChild("betTips"):GetComponent("UISpriteAnimation");
	betTips.gameObject:SetActive(false);
	mytips = this.transform:FindChild("TipsPanel/tips"):GetComponent("UISprite");
	mytips.gameObject:SetActive(false);
	errortips = this.transform:FindChild("TipsPanel/tipstxt"):GetComponent("UILabel");
	errortips.gameObject:SetActive(false);

	--投注数量按钮
	chipPanel = panelMain.transform:FindChild("button/ChipPanel");
	local childCount = chipPanel.childCount - 1;
	for i = 0, childCount do
		local btnChip = chipPanel:GetChild(i):FindChild("chipBtn").gameObject;
		this.mono:AddClick(btnChip, this.OnChipBtnClick);
	end

	--投注倒计时
	panelRemainTime = panelMain.transform:FindChild("Panelbg/timecounterbg").gameObject;
	panelRemainTime:SetActive(false);
	labelRemainTime = panelMain.transform:FindChild("Panelbg/timecounterbg/Label"):GetComponent("UILabel");
	local tsRemainTime = labelRemainTime.gameObject:GetComponent("TweenScale");
	tsRemainTime.enabled = false;

	--元宝预制体
	panelIngot = panelMain.transform:FindChild("ingotPanel");
	ingotPrefab = panelIngot:FindChild("ingot/ingotIcon").gameObject;
	ingotPrefab:SetActive(false);
	ingotTableUseCount = 0;
	betTypeIngot = {};
	ingotTable = {};
	table.insert(ingotTable, ingotPrefab);
	for i=1, 9 do
		local betTypeGameObject = panelIngot:FindChild(BetType[i]).gameObject;
		this.mono:AddClick(betTypeGameObject, this.OnClickBet);
	end

	-- 记录预制体
	recordPrefab = panelMain.transform:FindChild("Panelbg/result/resultBrand").gameObject;
	recordPrefab:SetActive(false);
	table.insert(recordTable, recordPrefab);
	recordTableUseCount = 0;

	--记录按钮
	local btnRecord = panelMain.transform:FindChild("Panelbg/ResultBtn").gameObject;
	this.mono:AddClick(btnRecord, this.OnChipBtnRecord);
	panelRecord = this.transform:FindChild("GameSHHZRecord").gameObject;
	panelRecord:SetActive(false);

	--上庄按钮
	btnBanker = panelMain.transform:FindChild("Panelbg/bankerInfo/banker"):GetComponent("UISprite");
	this.mono:AddClick(btnBanker.gameObject, this.OnClickBanker);
	panelBanker = this.transform:FindChild("GameSHHZForBanker").gameObject;
	panelBanker:SetActive(false);

	-- 设置界面
	local btnSetting = panelMain.transform:FindChild("button/SettingBtn").gameObject;
	this.mono:AddClick(btnSetting, this.OnClickSetting);
	panelSetting = this.transform:FindChild("GameSHHZSetting").gameObject;
	panelSetting:SetActive(false);

	--无座玩家
	local btnFriend = panelMain.transform:FindChild("button/friend").gameObject;
	this.mono:AddClick(btnFriend, this.OnChipBtnFriend);
	panelFriend = this.transform:FindChild("GameSHHZPlayer").gameObject;
	panelFriend:SetActive(false);

	--结算
	panelSettlement = this.transform:FindChild("GameSHHZSettlement").gameObject;
	panelSettlement:SetActive(false);

	--确定退出面板
	local btnBack = panelMain.transform:FindChild("Panelbg/BackBtn").gameObject;
	this.mono:AddClick(btnBack, this.OnClickBack);
	panelExit = this.transform:FindChild("GameSHHExit").gameObject;
	local btnExit = panelExit.transform:FindChild("panelbg/ContinueBtn").gameObject;
	local btnCanel = panelExit.transform:FindChild("panelbg/CancelBtn").gameObject;
	this.mono:AddClick(btnExit, this.OnClickExit);
	this.mono:AddClick(btnCanel, this.HideExitPanel);
	btnCanel = panelExit.transform:FindChild("panelbg/black").gameObject;
	this.mono:AddClick(btnCanel, this.HideExitPanel);
	panelExit:SetActive(false);

	--角色对话框
	charDialogueFrame = panelMain.transform:FindChild("dialogueframe"):GetComponent("UISprite");
	charDialogue = charDialogueFrame.transform:FindChild("dialogue"):GetComponent("UISprite");
	charDialogueFrame.gameObject:SetActive(false);

	-- 8个座位玩家
	seatPlayers = {};
	local seatLeft = panelMain.transform:FindChild("seatLeft");
	local seatCount = seatLeft.childCount - 1;
	for i = 0, seatCount do
		local seat = seatLeft:GetChild(i).gameObject;
		-- 显示noseat结点
		local noseat = seat.transform:FindChild("noseat").gameObject;
		noseat:SetActive(true);
		-- 隐藏hasseat结点
		local hasseat = seat.transform:FindChild("hasseat").gameObject;
		hasseat:SetActive(false);

		local num = seat.transform:FindChild("noseat/num"):GetComponent("UISprite");
		num.spriteName = string.format("seatnumber%d", i+1);
		local crown = seat.transform:FindChild("hasseat/crown"):GetComponent("UISprite");
		if i<3 then
			crown.spriteName = string.format("crown%d", i+1);
			crown.gameObject:SetActive(true);
		else
			crown.gameObject:SetActive(false);
		end
		table.insert(seatPlayers, seat);
	end
	local seaRight = panelMain.transform:FindChild("seaRight");
	seatCount = seaRight.childCount - 1;
	for i = 0, seatCount do
		local seat = seaRight:GetChild(i).gameObject;
		-- 显示noseat结点
		local noseat = seat.transform:FindChild("noseat").gameObject;
		noseat:SetActive(true);
		-- 隐藏hasseat结点
		local hasseat = seat.transform:FindChild("hasseat").gameObject;
		hasseat:SetActive(false);

		local num = seat.transform:FindChild("noseat/num"):GetComponent("UISprite");
		num.spriteName = string.format("seatnumber%d", i+5);
		local crown = seat.transform:FindChild("hasseat/crown"):GetComponent("UISprite");
		crown.gameObject:SetActive(false);
		table.insert(seatPlayers, seat);
	end

	--玩家各个类型的投注
	curPlayerBetCount = 100;
	this.hiddenBetMoney();

	--播放背景音乐
	UISoundManager.Start();
	GameSHHZSetting.PlayBGSound(BGMusic);

	coroutine.start(this.updateTime);
end


-------------------------------------------------------------------------------------------------
-- 更新时间
function this.updateTime()
	local defaultTime = 30; -- 30秒没有收到消息就提示
	receiveMessageTime = Time.realtimeSinceStartup;
	while true do
		if mytips.gameObject.activeInHierarchy == false and receiveMessageTime+defaultTime<Time.realtimeSinceStartup then
			this.ShowSpriteTips(this.SpriteTipsType.WiatNextBet, 0);
		end
		coroutine.wait(1.0);
	end
end

-------------------------------------------------------------------------------------------------
-- 点击记录的按钮
function this.OnChipBtnRecord()
	panelRecord:SetActive(true);
	GameSHHZRecord.ShowPanel(this.pathData);
end

-------------------------------------------------------------------------------------------------
-- 点击记录的按钮
function this.OnChipBtnFriend()
	panelFriend:SetActive(true);
end

-------------------------------------------------------------------------------------------------
-- 点击上庄列表
function this.OnClickBanker()
	panelBanker:SetActive(true);
	GameSHHZForBanker.ShowPanel(waitBankerPlayer);
end

-------------------------------------------------------------------------------------------------
-- 点击记录的按钮
function this.OnClickSetting()
	panelSetting:SetActive(true);
end

-------------------------------------------------------------------------------------------------
-- 点击返回按钮
function this.OnClickBack()
	panelExit:SetActive(true);
	local windowTweenPosition = panelExit:GetComponent("TweenPosition");
    windowTweenPosition:PlayForward();
end

-------------------------------------------------------------------------------------------------
-- 点击返回按钮
function this.OnClickExit()
	-- 退出所有协程
	coroutine.Stop();
	if windowsProcess~=nil then
		Application.Quit();
	else
		this.mono:OnClickBack();
	end
end


-------------------------------------------------------------------------------------------------
-- 点击返回按钮
local preBetTime = nil;
function this.OnClickBet(go)
	if this.CurState == this.GameState.Bet then
		if preBetTime==nil or preBetTime+0.2<Time.realtimeSinceStartup then
			preBetTime = Time.realtimeSinceStartup;
			this.MyBet(go.name);
		end
	end
end


-------------------------------------------------------------------------------------------------
-- 隐藏确定退出界面
function this.HideExitPanel()
	local windowTweenPosition = panelExit:GetComponent("TweenPosition");
    windowTweenPosition:PlayReverse();
    coroutine.start(this.hiddenExitPanel);
end


-------------------------------------------------------------------------------------------------
-- 隐藏确定退出界面
function this.hiddenExitPanel()
    coroutine.wait(0.6);
    panelExit:SetActive(false);
end


-------------------------------------------------------------------------------------------------
-- 点击加注的按钮
function this.OnChipBtnClick(go)

    local objectName = go.transform.parent.name;
    if objectName=="100" then
    	curPlayerBetCount = 100;
    elseif objectName=="1000" then
    	curPlayerBetCount = 1000;
    elseif objectName=="10000" then
    	curPlayerBetCount = 10000;
    elseif objectName=="100000" then
    	curPlayerBetCount = 100000;
    elseif objectName=="1000000" then
    	curPlayerBetCount = 1000000;
    end
    GameSHHZSetting.PlaySound("Button");
end

-------------------------------------------------------------------------------------------------
-- 更新下注的按钮图标
function this.UpdateBetButton()

	local btnMoney = 1000000;
	local myuid = tonumber(EginUser.Instance.uid);

	updateButton = function(btnType, enable)
		--local btn = chipPanel:FindChild(btnType.."/chipBtn");
		if mBankerID==myuid then
			enable = false;
		end
		local disableBtn = chipPanel:FindChild(btnType.."/disable");
		if enable==true then
			--btn.gameObject:SetActive(true);
			disableBtn.gameObject:SetActive(false);
		else
			--btn.gameObject:SetActive(false);
			disableBtn.gameObject:SetActive(true);
			btnMoney = btnType;
		end
	end

	local player = this.getPlayer(myuid);

	if player.money>100000 then updateButton(100000, true);
	else updateButton(100000, false); end
	
	if player.money>10000 then updateButton(10000, true);
	else updateButton(10000, false); end

	if player.money>1000 then updateButton(1000, true);
	else updateButton(1000, false); end

	if player.money>100 then updateButton(100, true);
	else updateButton(100, false); end

	btnMoney = math.floor(btnMoney/10);
	if curPlayerBetCount<btnMoney then
		if btnMoney>=100 and curPlayerBetCount<=100 then
			btnMoney = 100;
		else
			btnMoney = curPlayerBetCount;
		end
	end

	if curPlayerBetCount~=btnMoney then

		-- if curPlayerBetCount>=100 then
		-- 	local toggle = chipPanel:FindChild(curPlayerBetCount.."/chipBtn"):GetComponent("UIToggle");
		-- 	toggle.value = false;
		-- end
		
		if btnMoney>=100 then
			local toggle = chipPanel:FindChild(btnMoney.."/chipBtn"):GetComponent("UIToggle");
			toggle.value = true;
			
		end
		
		curPlayerBetCount = btnMoney;

	end
end


-------------------------------------------------------------------------------------------------
-- 游戏开始
function this.OnGameStart()
    -- 游戏状态
	this.CurState = this.GameState.Play;
	GameSHHZScene.StartGame();
	this.ResetFx();

	-- 隐藏倒计时界面
	this.HiddenTimeCountDown();

	-- 清空下注的消息队列
	betMsgQueue = {};
end


function this.ResetFx()
	this.hiddenBetMoney();
	this.HiddenSpriteTips();

	if panelSettlement.activeInHierarchy==true then
		GameSHHZSettlement.OnContinueBtnClick();
	end
end


function this.SetGameState(gameState)
	this.CurState = gameState;
end


-------------------------------------------------------------------------------------------------
-- 本人下注
function this.MyBetMoney(betType, betMoney)
    local allMoney = myBetCount[betType];
    if allMoney==nil then
    	allMoney = 0;
    end
    allMoney = allMoney + betMoney;
    this.UpdateMyBetMoney(betType, allMoney);

    -- 更新所有钱
    allMoney = allBetCount[betType];
    if allMoney==nil then
    	allMoney = 0;
    end
    allMoney = allMoney + betMoney;

	this.BetMoney(betType, betMoney, 0, allMoney);
end
function this.UpdateMyBetMoney(betType, allMoney)
	if allMoney ~= myBetCount[betType] then
	    -- 数量累加
	    myBetCount[betType] = allMoney;

		-- 各区域投注数量UI
	    local betUI = betParent:FindChild(betType);
	    -- 显示当前投注区域的UI
	    betUI.gameObject:SetActive(true);
		local label = betUI:FindChild("Label"):GetComponent("UILabel");
		label.text = allMoney;
	end
end


-------------------------------------------------------------------------------------------------
-- 加注
-- betType:下注类型
-- betMoney:下注金额
-- better:-2表示庄家吐钱，-1表示玩座玩家押的元宝，0表示玩家本人押的元宝，1-8表示无座玩家家押的元宝
function this.BetMoney(betType, betMoney, better, allMoney)

	this.UpdateAllBetMoney(betType, allMoney);

    --下注声音
    GameSHHZSetting.PlaySound("Xiazhu");
    --动画
    this.AddIngotTips(betType, betMoney, better, 0.0);

end
function this.UpdateAllBetMoney(betType, allMoney)
	if allMoney ~= allBetCount[betType] then
		allBetCount[betType] = allMoney;

	    -- 各区域投注数量UI
	    local betUI = betParent:FindChild(betType.."All");
	    -- 显示当前投注区域的UI
	    betUI.gameObject:SetActive(true);
	    local label = betUI:FindChild("Label"):GetComponent("UILabel");
		label.text = allMoney;
	end
end

-------------------------------------------------------------------------------------------------
-- 元宝对象池操作
function this.GetIngotTips()
	local count = #ingotTable;
	local ingot;
	if ingotTableUseCount >= count then
		ingot = GameObject.Instantiate(ingotPrefab);
		table.insert(ingotTable, ingot);
	else
		ingot = ingotTable[ingotTableUseCount+1];
	end
	ingot:SetActive(true);
    ingot.transform.parent = ingotPrefab.transform.parent;
    ingot.transform.localScale = Vector3.one;
    ingotTableUseCount = ingotTableUseCount + 1;
	return ingot;
end
function this.HiddenIngotTips()
	for i = 1, ingotTableUseCount do
		ingotTable[i]:SetActive(false);
	 end
	 ingotTableUseCount = 0;
end

-------------------------------------------------------------------------------------------------
-- 玩家点击桌面加注区域后，UI会显示玩家投注的元宝动画
-- better:-2表示庄家吐钱，-1表示玩座玩家押的元宝，0表示玩家本人押的元宝，1-8表示无座玩家家押的元宝
-- delay:动画延时时间
function this.AddIngotTips(type, count, better, delay)
	--log("tips5Count="..tips5Count..", tips4Count="..tips4Count..", tips3Count="..tips3Count..", tips2Count="..tips2Count..", tips1Count="..tips1Count);
	-- 计算元宝落入的位置
	local startPos;
	-- 庄家押
	if better==-2 then
		startPos = panelIngot:FindChild("bankerPos").localPosition;
	-- 无座玩家
	elseif better==-1 then
		startPos = panelIngot:FindChild("playerPos").localPosition;
	-- 玩家本人押
	elseif better==0 then
		startPos = panelIngot:FindChild("startPos").localPosition;
	-- 其他玩家押
	elseif better<=8 then
		startPos = seatPlayers[better].transform.position;
		startPos = panelIngot:InverseTransformPoint(startPos);
	else
		error("better="..better);
		return;
	end
	local pos = panelIngot:FindChild(type).localPosition;


	-- 大中小三个区域范围为80
	local size = 0;
	if type == "SmallArea" or type == "MediumArea" or type == "BigArea" then
        size = 100;
    else
        size = 50;
    end
    -- 元宝数量
	local go = this.GetIngotTips();
	if betTypeIngot[type] == nil then
		betTypeIngot[type] = {};
	end
	table.insert(betTypeIngot[type], go);
	--go.name = count;
	go.name = better;
	local fixPos = Vector3.New(pos.x+math.random(-size-20, size+20), pos.y+math.random(-size, size), pos.z);
	-- log("startPos.x="..startPos.x.."startPos.y="..startPos.y.."startPos.z="..startPos.z.."fixPos.x="..fixPos.y.."fixPos.y="..fixPos.y.."fixPos.z="..fixPos.z);
	local sp = go:GetComponent("UISprite");
    local tweenPosition = go:GetComponent("TweenPosition");
    tweenPosition.from = startPos;
    tweenPosition.to = fixPos;
    tweenPosition.delay = delay;
    tweenPosition:ResetToBeginning();
    tweenPosition:PlayForward();

    go.transform.localScale = Vector3.one * 1.5;
    local tweenScale = go:GetComponent("TweenScale");
    tweenScale.from = go.transform.localScale;
    tweenScale.to = Vector3.one;
    tweenScale.delay = delay + 0.3;
    tweenScale:ResetToBeginning();
    tweenScale:PlayForward();

    return go;
end


-------------------------------------------------------------------------------------------------
-- 隐藏桌面上玩家的投注数量
function this.hiddenBetMoney()
	local childCount = betParent.childCount - 1;
	for i = 0, childCount do
		local betUI = betParent:GetChild(i).gameObject;
		betUI:SetActive(false);
	end

	-- 玩家押注区域对应的数量
	for k, v in pairs(myBetCount) do
		myBetCount[k] = 0;
	end
	
	-- 玩家押注区域对应的数量
	for k, v in pairs(lockAreaDc) do
		lockAreaDc[k] = false;
	end

	-- 玩家押注区域对应的数量
	for k, v in pairs(allBetCount) do
		allBetCount[k] = 0;
	end

	-- 押注区域对应的元宝
	for k, v in pairs(betTypeIngot) do
		betTypeIngot[k] = {};
	end

	this.HiddenIngotTips();
end


-------------------------------------------------------------------------------------------------
-- 文字提示
-- showTime:显示时间,少于0表示一直显示
local showTipsTime = 0;
local isHiddeningSpriteTips = true;
function this.ShowSpriteTips(spriteTipsType, showTime)
	mytips.gameObject:SetActive(true);

	mytips.spriteName = spriteTipsType;
	mytips:MakePixelPerfect();

	local tweenPosition = mytips:GetComponent("TweenPosition");
	tweenPosition:ResetToBeginning();
	--mytips.transform.localPosition = tweenPosition.from;
	tweenPosition.enabled = false;

	isHiddeningSpriteTips = false;
	if showTime>0 then
		showTipsTime = showTime;
		this.HiddenSpriteTips();
	end
end

function this.HiddenSpriteTips()
	if isHiddeningSpriteTips == false then
		isHiddeningSpriteTips = true;
		coroutine.start(this.hiddenSpriteTips);
	end
end
function this.hiddenSpriteTips()
	if showTipsTime>0 then
		coroutine.wait(showTipsTime);
	end

	local tweenPosition = mytips:GetComponent("TweenPosition");
	tweenPosition.enabled = true;
	tweenPosition:PlayForward();

	coroutine.wait(0.5);
	mytips.gameObject:SetActive(false);

	isHiddeningSpriteTips = true;
end


-------------------------------------------------------------------------------------------------
-- 倒计时动画
function this.ShowTimePanel()
	panelRemainTime:SetActive(true);
end
function this.ShowTimeCountDown(timeCount, isPlayHurryup)
	playHurryup = isPlayHurryup;
	-- 显示倒计时界面
	panelRemainTime:SetActive(true);

	totalDownTime = timeCount;
	if countDownTime < 0 then
		countDownTime = Time.realtimeSinceStartup + timeCount;
		coroutine.start(this.TimeCountDownLoop);
	else
		countDownTime = Time.realtimeSinceStartup + timeCount;
	end
end
function this.TimeCountDownLoop()

	-- 倒计时数字显示
	local timecounter = panelMain.transform:FindChild("Panelbg/timecounterbg/timecounter"):GetComponent("UISprite");
	timecounter.fillAmount = 1.0;
	local tweenScale = labelRemainTime.gameObject:GetComponent("TweenScale");
	tweenScale.enabled = true;

	local lastLefttime = 0;
	local isLoop = true;
    while isLoop do

    	coroutine.wait(0.1);

		local lefttime = countDownTime - Time.realtimeSinceStartup;
		local intLefttime = math.floor(lefttime);
	    if lefttime<0 then
	        isLoop = false;
	    else
	    	--播放时间快到的声音
	    	if playHurryup==true and lefttime < 4 and lastLefttime ~= intLefttime then
				lastLefttime = intLefttime;
				tweenScale.enabled = true;
				tweenScale:ResetToBeginning();
				tweenScale:PlayForward();
				GameSHHZSetting.PlaySound("hurryup");
	    	end
	    	labelRemainTime.text = intLefttime;
        	timecounter.fillAmount = lefttime/totalDownTime;
	    end

	end

	countDownTime = -1;
end
function this.HiddenTimeCountDown()
	-- 隐藏倒计时界面
	panelRemainTime:SetActive(false);
	playHurryup = false;
end

-------------------------------------------------------------------------------------------------
-- 开始下注、停止下注动画
function this.BeginBetUIAnimation()
	-- 开始下注动画
	this.ShowBetTips(1);
end


function this.BeginBet(timeCount)
	if this.CurState == this.GameState.Bet then
		return;
	end

	GameSHHZSetting.PlaySound("charBet");
	
	-- 显示角色对话框
	dialogueType = math.random(1,4);
	coroutine.start(this.showCharDialogue, dialogueType);
	coroutine.start(this.PlayLookAnimation);

	this.BetLoop(timeCount);
end

function this.BetLoop(timeCount)
	-- 游戏状态
	this.CurState = this.GameState.Bet;
	coroutine.start(this.betLoop, timeCount);
end

-------------------------------------------------------------------------------------------------
-- 玩家下注时间
function this.betLoop(timeCount)

	if panelBanker.activeInHierarchy==true then
		GameSHHZForBanker.ResetBtnEnable();
	end

	-- 倒计时动画
	this.ShowTimeCountDown(timeCount, true);
	-- 下注
	local animationTime = Time.realtimeSinceStartup + timeCount;
    while animationTime>=Time.realtimeSinceStartup do
    	for i=1, 2 do
			local betCount = #betMsgQueue;
			if betCount>0 then
				local bet = betMsgQueue[1];
				local betType= bet[1];
				local betMoney= bet[2];
				local allMoney= bet[3];
				local better= bet[4];
				if better==0 then
					this.MyBetMoney(betType, betMoney);
				else
					this.BetMoney(betType, betMoney, better, allMoney);
				end
				table.remove(betMsgQueue, 1);
			end
		end
		coroutine.wait(0.05);
    end

    -- 把队列剩余的金币都做下注动画
	local betCount = #betMsgQueue;
	for i=1, betCount do
		local bet = betMsgQueue[i];
		local betType= bet[1];
		local betMoney= bet[2];
		local allMoney= bet[3];
		local better= bet[4];
		if better==0 then
			this.MyBetMoney(betType, betMoney);
		else
			this.BetMoney(betType, betMoney, better, allMoney);
		end
	end

	-- 玩家押注区域对应的数量
	-- for k, v in pairs(myServerCount) do
	-- 	this.UpdateMyBetMoney(k, v);
	-- end

	this.CurState = this.GameState.Play;
	if panelBanker.activeInHierarchy==true then
		GameSHHZForBanker.ResetBtnEnable();
	end

	betMsgQueue = {};
end

-------------------------------------------------------------------------------------------------
-- 隐藏文字信息
function this.HiddenErrorTips()
	errortips:SetActive(true);
	coroutine.wait(2.0);
	errortips:SetActive(false);
end

-------------------------------------------------------------------------------------------------
-- 显示文字信息
function this.ShowErrorTips(tipsMessage)
	errortips.text = tipsMessage;
	coroutine.start(this.HiddenErrorTips);
end

-------------------------------------------------------------------------------------------------
-- 开始下注、停止下注动画
-- tipsType=1，开始下注
-- tipsType=2，停止下注动画
function this.ShowBetTips(tipsType)
	-- 播放声音
    GameSHHZSetting.PlaySound("StartBet");
    if tipsType==1 then
		betTips.namePrefix = "ksxz_";
	else
		betTips.namePrefix = "tzxz_";
	end
    betTips.gameObject:SetActive(true);
    betTips:ResetToBeginning();
    betTips:Play();
    coroutine.start(this.HideTips, betTips.gameObject);
end
-------------------------------------------------------------------------------------------------
-- 隐藏开始下注、停止下注动画
function this.HideTips(go)
 	coroutine.wait(0.5);
 	go:SetActive(false);
 end


-------------------------------------------------------------------------------------------------
-- 结算界面
function this.ShowSettlement(dice1Num, dice2Num)
	local betType;
	local count = dice1Num + dice2Num;
	if count<7 then
		betType = "SmallArea";
	elseif count>7 then
		betType = "BigArea";
	else
		betType = "MediumArea";
	end

	local pair = nil;
	-- 对子
	if dice1Num==dice2Num then
		pair = string.format('Pair%dArea', dice1Num);
	end
	
	--元宝动画
	coroutine.start(this.PlayIngotAnimation, betType, pair);

	-- 添加记录
	this.AddRecord(dice1Num, dice2Num);
end

-------------------------------------------------------------------------------------------------
-- 每一个宝飞向庄家、玩家的动画
function this.ingotAni(go, delay, targetPos)
	coroutine.wait(delay);
	--放大动画
	local tweenScale = go:GetComponent("TweenScale");
    tweenScale.from =  Vector3.one;
    tweenScale.to = Vector3.one * 1.5;
    tweenScale.delay = 0.0;
    tweenScale:ResetToBeginning();
    tweenScale:PlayForward();

    --移动动画
	coroutine.wait(0.2);
	local tweenPosition = go:GetComponent("TweenPosition");
    tweenPosition.from = go.transform.localPosition;
    tweenPosition.to = targetPos;
    tweenPosition.delay = 0.0;
    tweenPosition:ResetToBeginning();
    tweenPosition:PlayForward();

    -- 缩小动画
    coroutine.wait(0.3);
    tweenScale.from = go.transform.localScale;
    tweenScale.to = Vector3.zero;
    tweenScale.delay = 0.0;
    tweenScale:ResetToBeginning();
    tweenScale:PlayForward();
end


-------------------------------------------------------------------------------------------------
-- 元宝飞向有座玩家的动画
function this.playSeatEffect(effect, delay)
	coroutine.wait(0.4 + delay);
	if effect.gameObject.activeInHierarchy==false then
		effect.gameObject:SetActive(true);
		effect:Play();
		coroutine.wait(2.5);
		effect.gameObject:SetActive(false);
	end
end


-------------------------------------------------------------------------------------------------
-- 所有元宝飞向庄家、玩家的动画
function this.PlayIngotAnimation(betType, pair)
	local maxFlyTime = 1.5;
	local stopTime = 0;
	-- 元宝飞向庄家的的动画
	local hiddenList = {};
	local bankerPos = panelIngot:FindChild("bankerPos").localPosition;
	for key, listIngot in pairs(betTypeIngot) do
		if key~=betType and key ~= pair then
		 	local ingotCount = #listIngot;
		 	if stopTime<ingotCount then
		 		stopTime = ingotCount;
		 	end
		 	local delay = 0.01;
		 	if ingotCount>100 then
		 		delay = maxFlyTime/ingotCount;
		 	end
		 	for j = 1, ingotCount do
		 		local go = listIngot[j];
		 		table.insert(hiddenList, go);
		 		coroutine.start(this.ingotAni, go, delay * j, bankerPos);
		 	end
		end
	end
	--计算时间
	stopTime = stopTime * 0.02;
	if stopTime>maxFlyTime then
		stopTime = maxFlyTime;
	end
	-- 动画时间会一直播放声音
	local t = Time.realtimeSinceStartup + stopTime;
	while Time.realtimeSinceStartup<t do
		GameSHHZSetting.PlaySound("Xiazhu");
		coroutine.wait(0.05);
	end
	coroutine.wait(0.7);
	-- 隐藏飞元宝
	for i = 1, #hiddenList do
		hiddenList[i]:SetActive(false);
	end

	-- 庄家说话
	if bankerWin>0 then
		local wintype = math.random(1,3);
		GameSHHZSetting.PlaySound("bankerwin"..wintype);
	else
		local losttype = math.random(1,3);
		GameSHHZSetting.PlaySound("bankerlost"..losttype);
	end
	GameSHHZBanker.playSpeakAnimation();
	-- 庄家赔钱
	-- 赔大小
	local bankerBet = betTypeIngot[betType];
	if bankerBet~=nil then
		local ingotCount = #bankerBet;
		stopTime = ingotCount;
	 	local delay = 0.02;
	 	if ingotCount>100 then
	 		delay = maxFlyTime/ingotCount;
	 	end
	 	for j = 1, ingotCount do
	 		local go = this.AddIngotTips(betType, 0, -2, delay * j);
	 		go.name = bankerBet[j].name;
	 	end
	end
	-- 赔对子
	if pair~=nil then
		local bankerBet = betTypeIngot[pair];
		if bankerBet~=nil then
			local ingotCount = #bankerBet;
		 	if stopTime<ingotCount*5 then
		 		stopTime = ingotCount*5;
		 	end
		 	local delay = 0.02;
		 	if ingotCount>20 then
		 		delay = maxFlyTime/ingotCount/5.0;
		 	end
		 	for j = 1, ingotCount do
		 		local ingotName = bankerBet[j].name;
		 		for k = 1, 5 do
		 			local go = this.AddIngotTips(pair, 0, -2, delay * j * k);
		 			go.name = ingotName;
				end
		 	end
		end
	end
	--计算时间
	stopTime = stopTime * 0.02;
	if stopTime>maxFlyTime then
		stopTime = maxFlyTime;
	end
	-- 动画时间会一直播放声音
	local t = Time.realtimeSinceStartup + stopTime;
	while Time.realtimeSinceStartup<t do
		GameSHHZSetting.PlaySound("Xiazhu");
		coroutine.wait(0.05);
	end

	coroutine.wait(0.7);
	-- 玩家赚钱
	stopTime = 0;
	hiddenList = {};
	local listIngot = betTypeIngot[betType];
	local playerPos = panelIngot:FindChild("playerPos").localPosition;
	local startPos = panelIngot:FindChild("startPos").localPosition;
	if listIngot ~= nil then

	 	local ingotCount = #listIngot;
	 	if stopTime<ingotCount then
			stopTime = ingotCount;
		end
		local delay = 0.02;
		if ingotCount>100 then
			delay = maxFlyTime/ingotCount;
		end
	 	for j = 1, ingotCount do
	 		local go = listIngot[j];
	 		table.insert(hiddenList, go);
	 		local targetPosition;
	 		local better = tonumber(go.name);
	 		-- 飞向玩家自己的金币
	 		if better==0 then
	 			targetPosition = startPos;
	 		-- 飞向有座玩家的金币
	 		elseif better>0 then
 				local go = seatPlayers[better];
 				targetPosition = panelIngot:InverseTransformPoint(go.transform.position);
 				local effect = go.transform:FindChild("hasseat/touxiang"):GetComponent("ParticleSystem");
 				coroutine.start(this.playSeatEffect, effect, delay * j);
	 		-- 飞向无座玩家的金币
	 		else
	 			targetPosition = playerPos;
	 		end
	 		coroutine.start(this.ingotAni, go, delay * j, targetPosition);
	 	end
	end
	if pair~=nil then
		local listIngot = betTypeIngot[pair];
		if listIngot ~= nil then
		 	local ingotCount = #listIngot;
		 	if stopTime<ingotCount then
				stopTime = ingotCount;
			end
			local delay = 0.01;
			if ingotCount>100 then
				delay = maxFlyTime/ingotCount;
			end
		 	for j = 1, ingotCount do
		 		local go = listIngot[j];
		 		table.insert(hiddenList, go);
				local targetPosition;
				local better = tonumber(go.name);
		 		-- 飞向玩家自己的金币
		 		if better==0 then
		 			targetPosition = startPos;
		 		-- 飞向有座玩家的金币
		 		elseif better>0 then
	 				local go = seatPlayers[better];
	 				targetPosition = panelIngot:InverseTransformPoint(go.transform.position);
	 				local effect = go.transform:FindChild("hasseat/touxiang"):GetComponent("ParticleSystem");
	 				coroutine.start(this.playSeatEffect, effect, delay * j);
		 		-- 飞向无座玩家的金币
		 		else
					targetPosition = playerPos;
		 		end
		 		coroutine.start(this.ingotAni, go, delay * j, targetPosition);
		 	end
		end
	end

	stopTime = stopTime * 0.02;
	if stopTime>maxFlyTime then
		stopTime = maxFlyTime;
	end
	-- 动画时间会一直播放声音
	t = Time.realtimeSinceStartup + stopTime;
	while Time.realtimeSinceStartup<t do
		GameSHHZSetting.PlaySound("Xiazhu");
		coroutine.wait(0.1);
	end
	coroutine.wait(0.7);
	-- 隐藏元宝
	for i = 1, #hiddenList do
		hiddenList[i]:SetActive(false);
	end
	

	local mybetmoney = 0
	-- 玩家押注区域对应的数量
	for k, v in pairs(myBetCount) do
		if v~= nil then
			mybetmoney = mybetmoney + v;
		end
	end

	-- 弹出结算界面
	panelSettlement:SetActive(true);
	GameSHHZSettlement.ShowPanel(5.0, mybetmoney, jsonSettlement);

	-- 隐藏押注钱数
	this.hiddenBetMoney();

	-- 更新自己的钱数
	local uid = tonumber(EginUser.Instance.uid);
	local player = this.getPlayer(uid);
	this.updateMyMoney(player.money);
	-- 更新庄家钱数
	this.updatePlayer(-1, mBankerID);

	-- 更新下注图标
	this.UpdateBetButton();

	-- 显示倒计时
	this.ShowTimePanel();
end


-------------------------------------------------------------------------------------------------
-- 记录对象
function this.GetRecordObject()
	local count = #recordTable;
	local record;
	if recordTableUseCount >= count then
		record = GameObject.Instantiate(recordPrefab);
		table.insert(recordTable, record);
	else
		record = recordTable[recordTableUseCount+1];
	end
	record:SetActive(true);
    record.transform.parent = recordPrefab.transform.parent;
    record.transform.localScale = Vector3.one;
    recordTableUseCount = recordTableUseCount + 1;
    --log("recordTableUseCount="..recordTableUseCount..", count"..count);
	return record;
end
function this.HiddenRecordObject()
	for i = 1, recordTableUseCount do
		recordTable[i]:SetActive(false);
	 end
	 recordTableUseCount = 0;
end
function this.PopRecod()
	local go = recordTable[1];
	table.remove(recordTable, 1);
	table.insert(recordTable, go);
	go:SetActive(false);
	recordTableUseCount = recordTableUseCount-1;
end
function this.AddRecord(dice1Num, dice2Num)
	local diceCount = dice1Num + dice2Num;
	local record;
	if diceCount < 7 then
        record = 0;
    elseif diceCount == 7 then
        record = 1;
    elseif diceCount > 7 then
        record = 2;
    end

	-- 插入元素
	table.insert(this.pathData, 1, record);
	-- 删除第一个元素
	recordCount = #this.pathData;
	if recordCount > 30 then
		table.remove(this.pathData, 31);
	end

	-- 更新记录面板
	if panelRecord.activeInHierarchy==true then
		GameSHHZRecord.init(this.pathData);
	end

	-- 移动声音
	GameSHHZSetting.PlaySound("recordmove");

	-- 顶部的UI偏移
	local index = 1;
	if recordTableUseCount>=6 then
		index = 2;
		local go = recordTable[1];
		local tweenPosition = go:GetComponent("TweenPosition");
		local pos = go.transform.localPosition;
	    tweenPosition.from = pos;
	    pos.x = 2560;
	    tweenPosition.to = pos;
	    tweenPosition:ResetToBeginning();
	    tweenPosition:PlayForward();
	end
	for i=index, recordTableUseCount do
		local go = recordTable[i];
		local tweenPosition = go:GetComponent("TweenPosition");
		local pos = go.transform.localPosition;
	    tweenPosition.from = pos;
	    pos.x = pos.x + 68;
	    tweenPosition.to = pos;
	    tweenPosition:ResetToBeginning();
	    tweenPosition:PlayForward();
	end

    resultName = "medium";
    if diceCount < 7 then
        resultName = "small";
    elseif diceCount == 7 then
        resultName = "draw";
    elseif diceCount > 7 then
        resultName = "big";
    end

    local go = this.GetRecordObject();
    local sp = go:GetComponent("UISprite");
    sp.spriteName = resultName;

    local tweenPosition = go:GetComponent("TweenPosition");
    tweenPosition.from = Vector3.New(-220, -15, 0);
    tweenPosition.to = Vector3.New(101, -15, 0);
    tweenPosition:ResetToBeginning();
    tweenPosition:PlayForward();
    if recordTableUseCount>=7 then
    	coroutine.wait(1.0);
		this.PopRecod();
	end
end


-------------------------------------------------------------------------------------------------
-- 显示角色的对话框
function this.showCharDialogue(type)
	local t = math.random(3, 5);
	coroutine.wait(t);
	GameSHHZBanker.playSpeakAnimation();
	GameSHHZBanker.playTheFatSpecial();
	charDialogueFrame.gameObject:SetActive(true);
	local dialogueName = "dialogue"..type;
	charDialogue.spriteName = dialogueName;

	charDialogue:MakePixelPerfect();
    charDialogueFrame.width = charDialogue.width + 50;
    GameSHHZSetting.PlaySound(dialogueName);

    coroutine.wait(3.0);
    charDialogueFrame.gameObject:SetActive(false);
end


-------------------------------------------------------------------------------------------------
-- 庄家左右看动画
function this.PlayLookAnimation()
	coroutine.wait(10);
    GameSHHZBanker.playLookAnimation();
end


-------------------------------------------------------------------------------------------------
-- 初始化玩家数据
function this.initPlayers(members)
	local player;
	players = {};
	playerCount = 0;
	for  i = 1,  #(members) do
		player = GPlayer:New(members[i]);
		players[player.uid] = player;
		playerCount = playerCount + 1;
	end
	this.UpdateMemberCount(playerCount);
end


-------------------------------------------------------------------------------------------------
-- 更新玩家头像钱等数据
function this.updatePlayer(index, uid)
	
	local player = this.getPlayer(uid);
	if player == nil then
		error(string.format("updatePlayer(%d, %d)", index, uid));
		return;
	end

	local t;
	-- 庄家
	if index == -1 then
		t = panelMain.transform:FindChild("Panelbg/bankerInfo/headIcon");
	-- 自己
	elseif index == 0 then
		t = panelMain.transform:FindChild("button/headIcon");
	-- 有座玩家
	else
		t = seatPlayers[index].transform:FindChild("hasseat")
	end

	GameSHHZ.updatePlayer(player, t);

end


-------------------------------------------------------------------------------------------------
-- 更新我的钱
function this.updateMyMoney(money)

	local playerMoney = panelMain.transform:FindChild("button/headIcon/ingot/count"):GetComponent("UILabel");
	playerMoney.text = GameSHHZ.getMoneyString(money);

end

-------------------------------------------------------------------------------------------------
-- 初始化玩家数据
function this.initSeatPlayers(index, uid)
	if uid==nil then

		local noseat = seatPlayers[index].transform:FindChild("noseat");
		noseat.gameObject:SetActive(true);
		local num = noseat:FindChild("num"):GetComponent("UILabel");
		num.text = index;
		seatPlayers[index].transform:FindChild("hasseat").gameObject:SetActive(false);

	else

		seatPlayers[index].name = uid;
		seatPlayers[index].transform:FindChild("noseat").gameObject:SetActive(false);
		this.updatePlayer(index, uid);

		local hasseat = seatPlayers[index].transform:FindChild("hasseat")
		hasseat.gameObject:SetActive(true);
		this.updatePlayer(index, uid);
	end
end


-------------------------------------------------------------------------------------------------
-- 根据玩家id获得玩家对象
function this.getPlayer(uid)
	return players[uid];
end


-------------------------------------------------------------------------------------------------
-- 根据玩家id获得玩家对象
function this.getPlayerTable()
	return players;
end


-------------------------------------------------------------------------------------------------
-- 初始化玩家数据
function this.initBet(jsonMyBetMoneys, jsonAllBetMoney)

	local PushBetQueue = function(betMoney, betType, allMoney, isMyBet)
		local better = 0;
		-- 计算次数
		if isMyBet==true then
			count = 3;
			better = 0;
		else
			count = 10;
			better = -1;
		end

		local betCount = 100;
		local i = 0;
		while i<count and betMoney>0 do
			i = i + 1;
			if i==count then
				betCount = betMoney;
			elseif betMoney>betCount then
				betMoney = betMoney - betCount;
			else
				betCount = betMoney;
				betMoney = 0;
			end
			local bet={betType, betCount, allMoney, better};
			table.insert(betMsgQueue, bet);
		end
	end

	for  i=1,9 do
		local betType = BetType[i];
		local myMoney=tonumber(jsonMyBetMoneys[i]);
		local allMoney=tonumber(jsonAllBetMoney[i]);

		local otherMoney=allMoney-myMoney;
		PushBetQueue(otherMoney, betType, allMoney, false);
		PushBetQueue(myMoney, betType, allMoney, true);
	end
end

-------------------------------------------------------------------------------------------------
-- 更新人数
function this.UpdateMemberCount(count)
	local memberCount = panelMain.transform:FindChild("button/friend/Label"):GetComponent("UILabel");
	memberCount.text = count;
end



-------------------------------------------------------------------------------------------------
-- 以下是消息发送函数
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 玩家点击下注发消息到服务器
function this.MyBet(betType)
	-- 当前押注不能少于100
	if curPlayerBetCount<100 then
		log("not enouph money");
		return;
	end

	-- 预先处理动画，等服务器返回消息再同步下注金额
	--this.MyBetMoney(betType, curPlayerBetCount);

	-- 当前区域达到最大
	local isLock = lockAreaDc[betType];
	if isLock==true then
		this.ShowSpriteTips(this.SpriteTipsType.BetMax, 2);
		return;
	end

	-- 发送消息
	local index = 0;
	for i=1, 9 do
		if BetType[i]==betType then
			index = i-1;
			break;
		end
	end
	local bet = { type="shhz", tag="bet", body={index, curPlayerBetCount} };
	local jsonStr = cjson.encode(bet);
	this.SendMessage(jsonStr);
end

function this.SendMessage(jsonStr)
	if windowsProcess==nil then
		this.mono:SendPackage(jsonStr);
	else
		windowsProcess:SendPackage(jsonStr);
	end
end

-------------------------------------------------------------------------------------------------
-- 以下是消息接收处理
-------------------------------------------------------------------------------------------------

function this:SocketReceiveMessage(message)
	local Message = self;
	this.MySocketReceiveMessage(Message);
end

-------------------------------------------------------------------------------------------------
--请求接收
function this.MySocketReceiveMessage(Message)

	receiveMessageTime = Time.realtimeSinceStartup;

	if  Message then
		--解析json字符串
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];
		--log(Message)
		-- if(tag ~= "bet")then
		-- 	log(Time.realtimeSinceStartup .. "<color=#00ff00>".. Message .. "</color>");
		-- else
		-- 	log(Time.realtimeSinceStartup .. "<color=#00cccc>".. Message .. "</color>");
		-- end
		if "shhz" == typeC then
			if "enter" == tag then
				this.gameEnter(messageObj);
			elseif "come" == tag then
				this.gameCome(messageObj);
			elseif "leave" == tag then
				this.gameLeave(messageObj);
			elseif "waitupdealer" == tag then
				this.gameWaitBankup(messageObj);
			elseif "updealer_fail_nomoney" == tag then
				this.gameBankUpFail(messageObj);
			elseif "updealer" == tag then
				this.gameBankUp(messageObj);
			elseif "downdealer" == tag then
				this.gameBankDown(messageObj);
			elseif "update_dealers" == tag then
				this.gameBankUpdate(messageObj);
			elseif "waitplayerbet" == tag then
				this.gameWaitBet(messageObj);
			elseif "badbet" == tag then
				this.gameBadBet(messageObj);
			elseif "mybet" == tag then
			 	this.gameMyBet(messageObj);
			elseif "bet" == tag then
				this.gameBet(messageObj);
			elseif "gameover" == tag then
				this.gameOver(messageObj);
			elseif "freetime" == tag then
				this.gameFreeTime(messageObj);
			elseif "seatinfo" == tag then
				this.updatePlayerSlots(messageObj);
			elseif "fullzone" == tag then
				this.areaFullTip(messageObj);
			end
		end
	end
end


-------------------------------------------------------------------------------------------------
--开始游戏的消息
function this.gameEnter(json)

	if windowsProcess~=nil then
		EginUser.Instance.uid = windowsProcess.uid;
		log("uid="..EginUser.Instance.uid);
	end

	-- 历史记录数据
	local path = json["body"]["path"];
	local pathCount = #path;
	for i = 1, 30 do 
		if i>pathCount then
			break;
		else
			table.insert(this.pathData, path[i][1]);
		end
	end

	-- 玩家数据
	local playersJson = json["body"]["members"];
	this.initPlayers(playersJson);

	-- 庄家id
	mBankerID = tonumber(json["body"]["dealer"]);
	this.updatePlayer(-1, mBankerID);

	-- 更新自己的头像
	local uid = tonumber(EginUser.Instance.uid);
	this.updatePlayer(0, uid);
	this.UpdateBetButton();

	-- 等待上庄列表
	local isInWaitingList = false;
	local binfos = json["body"]["dealers"];
	waitBankerPlayer = {};
	for i = 1, #(binfos) do
		local playerUID = tonumber(binfos[i][1]);
		local player = this.getPlayer(playerUID);
		if player~=nil then
			table.insert(waitBankerPlayer, player);
			if playerUID == uid then
				isInWaitingList = true;
			end
		end
	end

	-- 更新无座玩家
	this.updatePlayerSlots(json);

	-- 自己是否在等待上庄列表
	if isInWaitingList then
		btnBanker.spriteName = "downBanker";
		btnBanker:GetComponent("UIButton").normalSprite = "downBanker";
	else
		btnBanker.spriteName = "appliedforBanker";
		btnBanker:GetComponent("UIButton").normalSprite = "appliedforBanker";
	end

	this.minBankerMoney = tonumber(json["body"]["min_dealermoney"]);

	-- 倒计时
	local timeout = tonumber(json["body"]["timeout"]);

	local step = tonumber(json["body"]["step"]);
	--error("step="..step);
	if step == 1 then
		--Init desk pool chips and you could bet your chips.
		local mybetMoneys=json["body"]["mybetmoneys"];
		local allbetMoneys=json["body"]["betmoneys"];
		this.initBet(mybetMoneys, allbetMoneys);
		this.BetLoop(timeout);
	elseif step==2 then
		--wait for next round start.
		this.ShowSpriteTips(this.SpriteTipsType.WiatNextBet, 0);
		this.SetGameState(this.GameState.Play);
		this.ShowTimeCountDown(timeout, false);
	elseif step==3 then
		--Wait for players ready.
		this.BetLoop(timeout);
	elseif step == 0 then
		this.OnGameStart();
	end
end


-------------------------------------------------------------------------------------------------
-- 有玩家进来
function this.gameCome(json)
	local body = json["body"];
	local player = GPlayer:New(body);
	players[player.uid] = player;
	playerCount = playerCount + 1;
	this.UpdateMemberCount(playerCount);
end


-------------------------------------------------------------------------------------------------
-- 玩家离开
function this.gameLeave(json)
	local leaverID = tonumber (json ["body"]);
	local nickname = players[leaverID].nickname;
	players[leaverID] = nil;
	playerCount = playerCount - 1;
	this.UpdateMemberCount(playerCount);

	-- error("player leave , "..leaverID..", nickname="..nickname);
	-- -- 更新等待上庄玩家的队列
	-- local waitCount = #waitBankerPlayer;
	-- for i=1, waitCount do
	-- 	local player =  waitBankerPlayer[i];
	-- 	if player.uid==leaverID then
	-- 		error("banker leave , "..leaverID);
	-- 		table.remove(waitBankerPlayer, i);
	-- 		if panelBanker.activeInHierarchy ==true then
	-- 			GameSHHZForBanker.UpdatWaitBanker(waitBankerPlayer);
	-- 		end
	-- 		break;
	-- 	end
	-- end
end


-------------------------------------------------------------------------------------------------
-- 其他玩家消息
function this.gameBet(json)

	local body = json["body"];
	local index = tonumber(body [1]) + 1;
	local allMoney = tonumber(body[2]);
	local betMoney = tonumber(body[3]);
	local uid = string.format("%d", body[4]);

	local betType = BetType[index];
	local better = -1;

	-- 是否有座玩家
	for i=1, 8 do
		local player = seatPlayers[i];
		if player.name == uid then
			better = i;
		end
	end

	local bet={betType, betMoney, allMoney, better};
	table.insert(betMsgQueue, bet);

end


-------------------------------------------------------------------------------------------------
-- 我的下注消息
function this.gameMyBet(json)

	local body = json["body"];
	local betMoney=tonumber(body[1]);
	-- local allMoney=tonumber(body[3]);
	local index = tonumber (body [2]) + 1;
	local betType = BetType[index];

    -- local allMoney = myServerCount[betType];
    -- if allMoney==nil then
    -- 	allMoney = 0;
    -- end
    -- myServerCount[betType] = allMoney + betMoney;

	this.MyBetMoney(betType, betMoney);

	local uid = tonumber(EginUser.Instance.uid);
	local player = this.getPlayer(uid);
	player.money = player.money - betMoney;
	-- 更新自己的钱
	this.updateMyMoney(player.money);
	-- 更新按钮图标
	this.UpdateBetButton();

	--this.UpdateMyBetMoney(betType, myServerCount[betType]);

end


-------------------------------------------------------------------------------------------------
-- 有座玩家
function this.updatePlayerSlots(json)
	local seats = json["body"]["seats"];
	for i,v in ipairs(seats) do
		if(i > 1) then -- The first person is Banker.
			local uid = tonumber(v[1]);
			this.initSeatPlayers(i-1, uid);
		end
	end
end


-------------------------------------------------------------------------------------------------
-- 一局结束中间休息时间
function this.gameFreeTime(json)
	
	local timeout = tonumber(json["body"]);
	this.ShowTimeCountDown(timeout, false);
	this.OnGameStart();
end


-------------------------------------------------------------------------------------------------
-- 结算
function this.gameOver(json)
	local body = json ["body"];
	jsonSettlement = body;

	local timeout = tonumber(body["timeout"]);

	-- 庄家赢了多少钱
	bankerWin = tonumber(jsonSettlement["dealer_win"]);

	-- 色子的数字
	local hands = body["win_hands"];
	local dice1Num = tonumber(hands[1][1])+1;
	local dice2Num = tonumber(hands[1][2])+1;

	-- 更新自己的钱
	local mymoney = tonumber(body["into_money"]);
	local uid = tonumber(EginUser.Instance.uid);
	local player = this.getPlayer(uid);
	if player~=nil then
		player.money = mymoney;
	end

	-- 更新各玩家的钱
	local moneys = body["moneys"];
	for key,value in ipairs(moneys) do
		local members=value;
		local player=this.getPlayer(tonumber(members[1]));
		if player ~= nil then
			local curMoney = tonumber(members[2]);
			player.money = curMoney;
		end
	end

	-- 倒计时
	this.ShowTimeCountDown(timeout, false);
	this.HiddenTimeCountDown();

	-- UI停止下注动画
	this.ShowBetTips(2);
	this.CurState = this.GameState.Open;
	GameSHHZBanker.playOpenAnimation(dice1Num, dice2Num, bankerWin);
end


-------------------------------------------------------------------------------------------------
-- 下注失败
function this.gameBadBet(json)
	error("gameBadBet");
end


-------------------------------------------------------------------------------------------------
-- 等待玩家下注
function this.gameWaitBet(json)
	local timeout = tonumber(json["body"]["timeout"]);

	-- 下注时间
	this.BeginBet(timeout);
end


-------------------------------------------------------------------------------------------------
-- 庄家变换
function this.gameBankUpdate(json)
	local bodyJson = json["body"];
	local bankerID = tonumber(bodyJson[1][1]);

	this.updatePlayer(-1, bankerID);
	this.ShowSpriteTips(this.SpriteTipsType.ChangeBanker, 2.0);

	this.removeWaitingBanker(mBankerID);
	mBankerID = bankerID;
	-- local player = this.getPlayer(mBankerID);
	-- local nickname = "";
	-- if player~=nil then
	-- 	nickname = player.nickname;
	-- end
	-- error("change banker, "..mBankerID..", nickname"..nickname);
	this.UpdateBetButton();

end


-------------------------------------------------------------------------------------------------
-- 有玩家进入等待上庄的队列
function this.gameBankUp(json)
	local uid = tonumber(json["body"][1]);
	local player = this.getPlayer(uid);
	if player==nil then
		error(string.format("gameBankUp(), %d", uid));
		return;
	end

	local myuid = tonumber(EginUser.Instance.uid);
	if uid==myuid then
		this.ShowSpriteTips(this.SpriteTipsType.MakeBankerSuccess, 2.0);
		btnBanker.spriteName = "downBanker";
		btnBanker:GetComponent("UIButton").normalSprite = "downBanker";
	end

	table.insert(waitBankerPlayer, this.getPlayer(uid));
	if panelBanker.activeInHierarchy==true then
		GameSHHZForBanker.UpdatWaitBanker(waitBankerPlayer);
	end
end


-------------------------------------------------------------------------------------------------
-- 有玩家离开等待上庄的队列
function this.gameBankDown(json)
	local uid = tonumber(json["body"][1]);
	this.removeWaitingBanker(uid);
end

function this.removeWaitingBanker(uid)
	local waitCount = #waitBankerPlayer;
	for i=1, waitCount do
		local player =  waitBankerPlayer[i];
		if player.uid==uid then
			table.remove(waitBankerPlayer, i);
			--error("removeWaitingBanker banker leave , "..uid..", nickname="..player.nickname);
			break;
		end
	end

	local myuid = tonumber(EginUser.Instance.uid);
	if uid==myuid then
		if mBankerID~=myuid then
			this.ShowSpriteTips(this.SpriteTipsType.MakeBankerfail, 2.0);
		end
		btnBanker.spriteName = "appliedforBanker";
		btnBanker:GetComponent("UIButton").normalSprite = "appliedforBanker";
	end

	if panelBanker.activeInHierarchy ==true then
		GameSHHZForBanker.UpdatWaitBanker(waitBankerPlayer);
	end
end


function this.gameWaitBankup(json)
	local str = XMLResource.Instance:Str ("mx_wait_bankup");
	this.ShowErrorTips(str);
end


function this.gameBankUpFail(json)
	local str = SimpleFrameworkUtilstringFormat(XMLResource.Instance:Str ("mx_updealer_fail_nomoney"),tonumber(json["body"]));
	this.ShowErrorTips(str);
end


-------------------------------------------------------------------------------------------------
-- 当前区域已达到最大押注
function this.areaFullTip(json)

	local body = json["body"];
	local index = tonumber(body) + 1;
	local betType = BetType[index];
	lockAreaDc[betType] = true;

	this.ShowSpriteTips(this.SpriteTipsType.BetMax, 2);

end
