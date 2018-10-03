SR_GameOverPanel = {} 
local self = SR_GameOverPanel

local transform
local gameObject
local titleEff = nil
local winIntegration = 0 --赢的金币
local label_winCoin
function SR_GameOverPanel.Awake(obj)
	gameObject = obj
	transform = obj.transform
	self.init()
	self.giveupCardList = {}
	self.remainCardList = {}


end 
--初始化
function SR_GameOverPanel.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.okbtn = transform:FindChild("Button").gameObject --开始游戏
	self.changeTable = transform:FindChild("ChangeTableBtn").gameObject --换桌
	
	self.behaviour:AddClick(self.okbtn,self.OkCallBack)  
	self.behaviour:AddClick(self.changeTable,self.changeTableCallBack)
	--label_winCoin = transform:FindChild("player/Label_winCoin"):GetComponent("UILabel");

    if LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
        self.changeTable:SetActive(false)
        self.okbtn.transform.localPosition = Vector3.New(380,-378.8,0)
    end

end

function SR_GameOverPanel.OnEnable()
	--用于时间过长不操作隐藏掉
    local delay = 10
    if MyCommon.GetAutoReady() == true or LRDDZ_Game.matchType ~= DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
        delay = 5
    end
	self.time = Timer.New(self.TimerOut,delay,-1,true)
	CountDownPanel.CancelCountDown(false) --关闭倒计时
	self.time:Start()
	GamePanel.isOpenNoteCard = false
	--iTween.MoveTo(GamePanel.NoteCardPanel,iTween.Hash("y",-700, "time", 0.1, "islocal", true, "easetype", iTween.EaseType.easeOutBack))
    if GamePanel.isOpenNoteCard then
        GamePanel.NoteCardCallBack()
    end
	--label_winCoin.gameObject:SetActive(false)


end  

function SR_GameOverPanel.OnDisable()
	self.time:Stop()
	--label_winCoin.gameObject:SetActive(false)
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
end 
function SR_GameOverPanel.ClearCalCardList()--清除结算界面显示的牌
	for k,obj in pairs (self.giveupCardList) do
		self.behaviour:MyDestroy(obj)
	end
	self.giveupCardList ={}
	for k,obj in pairs (self.remainCardList) do
		self.behaviour:MyDestroy(obj)
	end
	self.remainCardList ={}
end
function SR_GameOverPanel.OkCallBack()
	print("OkCallBack")
	--重置
	
	--GameCtrl.ReSetGame()
	self.ClearCalCardList()
    if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
	   GamePanel.DealCallBack()
    end
	GamePanel.GameOverAnim(true)
	if titleEff ~= nil then
		destroy(titleEff)
	end
	CountDownPanel.CancelCountDown(false)
	gameObject:SetActive(false)
end 
function SR_GameOverPanel.changeTableCallBack()
	--换一个角色
    --[[
	print("changeTableCallBack")
	GameCtrl.ReSetGame()
	self.ClearCalCardList()
	
	GamePanel.GameOverAnim(true)
	if titleEff ~= nil then
		destroy(titleEff)
	end
	gameObject:SetActive(false)
    if LRDDZ_Game.platform == PlatformType.PlatformMoble then
        LRDDZ_Game:SendChangedesk()
    else
        coroutine.Stop()
        Application.Quit()
    end
    ]]
    --三人明牌开始
    self.ClearCalCardList()
    GamePanel.ShowCardCallBack()

    GamePanel.GameOverAnim(true)
    if titleEff ~= nil then
        destroy(titleEff)
    end
    CountDownPanel.CancelCountDown(false)
    gameObject:SetActive(false)
end
function SR_GameOverPanel.TimerOut()
	if titleEff ~= nil then
		destroy(titleEff)
	end
	print("TimerOut")
	--GameCtrl.ReSetGame()
	self.ClearCalCardList()
	GamePanel.GameOverAnim(true)
	gameObject:SetActive(false)
    if MyCommon.GetAutoReady() == true then
        GamePanel.DealCallBack()    
    elseif LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
        GamePanel.ActiveReady()
    end
	
end	

function SR_GameOverPanel.SetGameOverInfoByServer(winnertype,discards,double,hidedouble,bombtimes,residueCards,integration,computerWinGold,otherComputerWinGold,computerdouble,otherComputerdouble)

    GameCtrl.ReSetGame()
	--震动
	--UnityEngine.Handheld.Vibrate()

    --显示失败一方的界面
    if LRDDZ_Game.matchType ~= DDZGameMatchType.FiveMinute then
    	if winnertype == CharacterType.Player  then 
            --显示胜利的特效
            LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","ShengLi", "ShengLi",Vector3.New(1,1,1),Vector3.New(300.212,35.878,42), false,function(obj,name)
            	titleEff = obj
            	obj.transform.localRotation = Quaternion.Euler(-29.44299,0.3622,0.5799)
                local ls_lb = obj.transform:FindChild("2/UIRoot/Label"):GetComponent("UILabel")
                if GameCtrl.WinTimes() >= 2 then
                    ls_lb.text = GameCtrl.WinTimes().."连胜"
                    obj.transform:FindChild("2"):GetComponent("MeshRenderer").enabled = false
                else
                    ls_lb.text = ""
                    obj.transform:FindChild("2"):GetComponent("MeshRenderer").enabled = true
                end
    		end,nil)
        else
            --显示失败特效
            LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","ShengLi-2", "ShengLi-2",Vector3.New(1,1,1),Vector3.New(300.212,35.878,42), false,function(obj,name)
            	titleEff = obj
            	obj.transform.localRotation = Quaternion.Euler(-29.44299,0.3622,0.5799)
    		end,nil)
        end
    end

    --地主图标
    local p_dizhuicon = transform:FindChild("player/Sprite_dizhu").gameObject
    local c_dizhuicon = transform:FindChild("computer/Sprite_dizhu").gameObject
    local o_dizhuicon = transform:FindChild("otherComputer/Sprite_dizhu").gameObject
    p_dizhuicon:SetActive(false)
    c_dizhuicon:SetActive(false)
    o_dizhuicon:SetActive(false)
    if Player.identity == Identity.Landlord then
    	p_dizhuicon:SetActive(true)
	elseif Computer.identity == Identity.Landlord then
		c_dizhuicon:SetActive(true)
    elseif OtherComputer.identity == Identity.Landlord then
    	o_dizhuicon:SetActive(true)
    end		

    --赋值
    transform:FindChild("player/Label_name"):GetComponent("UILabel").text = EginUser.Instance.nickname
    transform:FindChild("player/Label_double"):GetComponent("UILabel").text = string.format("×%d", double)
    transform:FindChild("player/Label_initscore"):GetComponent("UILabel").text = tostring(MyCommon.InitScore())
    if integration > 0 then
        transform:FindChild("player/Label_gold"):GetComponent("UILabel").text = "+"..tostring(integration)
    else
        transform:FindChild("player/Label_gold"):GetComponent("UILabel").text = tostring(integration)
    end

    if computerdouble == nil then
        computerdouble = double
    end
    transform:FindChild("computer/Label_name"):GetComponent("UILabel").text = Computer.name
    transform:FindChild("computer/Label_double"):GetComponent("UILabel").text = string.format("×%d", computerdouble)
    transform:FindChild("computer/Label_initscore"):GetComponent("UILabel").text = tostring(MyCommon.InitScore())
    if computerWinGold > 0 then
        transform:FindChild("computer/Label_gold"):GetComponent("UILabel").text = "+".. tostring(computerWinGold)
    else
        transform:FindChild("computer/Label_gold"):GetComponent("UILabel").text = tostring(computerWinGold)
    end

    if otherComputerdouble == nil then
        otherComputerdouble = double
    end
    transform:FindChild("otherComputer/Label_name"):GetComponent("UILabel").text = OtherComputer.name
    transform:FindChild("otherComputer/Label_double"):GetComponent("UILabel").text = string.format("×%d", otherComputerdouble)
    transform:FindChild("otherComputer/Label_initscore"):GetComponent("UILabel").text = tostring(MyCommon.InitScore())
    if otherComputerWinGold > 0 then
        transform:FindChild("otherComputer/Label_gold"):GetComponent("UILabel").text = "+"..tostring(otherComputerWinGold)
    else
        transform:FindChild("otherComputer/Label_gold"):GetComponent("UILabel").text = tostring(otherComputerWinGold)
    end

    if LRDDZ_Game.matchType == DDZGameMatchType.None or LRDDZ_Game.matchType == DDZGameMatchType.LZMatch then
    	GamePanel.PlayerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Avatar.avatarGold)
        --在GameCtrl计算了 在这里显示就可以了
    	GamePanel.ComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Computer.gold)
        GamePanel.OtherComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(OtherComputer.gold)
    else
        GamePanel.PlayerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Player.raceScore)
        --在GameCtrl计算了 在这里显示就可以了
        GamePanel.ComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Computer.raceScore)
        GamePanel.OtherComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(OtherComputer.raceScore)
    end


    --动画
    local playerinfo = transform:FindChild("player").gameObject
    local computerinfo = transform:FindChild("computer").gameObject
    local othercomputerinfo = transform:FindChild("otherComputer").gameObject  
   	local playerpos = playerinfo.transform.localPosition
   	local computerpos = computerinfo.transform.localPosition
    local othercomputerepos = othercomputerinfo.transform.localPosition
   	playerinfo:SetActive(false)
   	computerinfo:SetActive(false)
    othercomputerinfo:SetActive(false)
   	self.okbtn:SetActive(false)
   	self.changeTable:SetActive(false)
   	local okbtnPos = self.okbtn.transform.localPosition;
   	local changeTablePos = self.changeTable.transform.localPosition;

   	--title动画播放
    local function anim()
        
            
        
        --显示getCoin
        playerinfo.transform.localPosition = playerpos + Vector3.New(1000,0,0)
        playerinfo:SetActive(true)
        iTween.MoveTo(playerinfo,iTween.Hash("x",playerpos.x, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack))

        coroutine.wait(0.5)

        --金币飞动画
        if winnertype == CharacterType.Player  then 
            coroutine.start(SR_GameOverPanel.CoinAnim)
        end

        computerinfo.transform.localPosition = computerpos + Vector3.New(1000,0,0)
        computerinfo:SetActive(true)
        iTween.MoveTo(computerinfo,iTween.Hash("x",computerpos.x, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack))

        coroutine.wait(0.5)



        othercomputerinfo.transform.localPosition = othercomputerepos + Vector3.New(1000,0,0)
        othercomputerinfo:SetActive(true)
        iTween.MoveTo(othercomputerinfo,iTween.Hash("x",othercomputerepos.x, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack))
        
        coroutine.wait(0.5)




        self.okbtn.transform.localPosition = okbtnPos + Vector3.New(0,-500,0);
        self.changeTable.transform.localPosition = changeTablePos + Vector3.New(0,-500,0);
        self.okbtn:SetActive(true)
        if LRDDZ_Game.matchType ~= DDZGameMatchType.ThreeMatch then
            self.changeTable:SetActive(true)
            iTween.MoveTo(self.changeTable,iTween.Hash("y",changeTablePos.y, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack))
        end
        iTween.MoveTo(self.okbtn,iTween.Hash("y",okbtnPos.y, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack,"delay",0.3))
    end
    coroutine.start(anim)
end
function SR_GameOverPanel.CoinAnim()
    --创建10金币
  	local anim_coin = transform:FindChild("player/anim_coin").gameObject;
	local coins = {}
    for i=1,10 do
    	local obj = NGUITools.AddChild(anim_coin.transform.parent.gameObject,anim_coin);
    	obj.transform.localPosition = anim_coin.transform.localPosition
    	table.insert(coins,obj)
    end
    local target = GamePanel.PlayerInteration.transform:FindChild("Sprite-icon").position
    for i=1,#coins do
    	coins[i]:SetActive(true)
    	iTween.MoveTo(coins[i],iTween.Hash("position",target, "time", 0.4, "islocal", false, "easetype", iTween.EaseType.linear))
    	--添加音效
    	LRDDZ_SoundManager.PlaySoundEffect("coinFly",coins[i])
    	coroutine.wait(0.04)
    end
        --显示金币条
    --label_winCoin.text = "+"..winIntegration;
    --label_winCoin.gameObject:SetActive(true)
    coroutine.wait(2)
    --label_winCoin.gameObject:SetActive(false)
    coroutine.wait(0.1)
    for i=1,#coins do
    	--LRDDZ_SoundManager.PlaySoundEffect("playerinfo",coins[i])
    	destroy(coins[i])
    	coroutine.wait(0.04)
    end

end

function SR_GameOverPanel.CJFGameOver()
end
