LR_GameOverPanel = {} 
local self = LR_GameOverPanel

local transform
local gameObject
local titleEff = nil
local winIntegration = 0 --赢的金币
local label_winCoin
function LR_GameOverPanel.Awake(obj)
	gameObject = obj
	transform = obj.transform
	self.init()
	self.giveupCardList = {}
	self.remainCardList = {}


end 
--初始化
function LR_GameOverPanel.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.okbtn = transform:FindChild("Button").gameObject --开始游戏
	self.changeTable = transform:FindChild("ChangeTableBtn").gameObject --换桌
	
	self.behaviour:AddClick(self.okbtn,self.OkCallBack)  
	self.behaviour:AddClick(self.changeTable,self.changeTableCallBack)
	label_winCoin = transform:FindChild("winIntegration/Label_winCoin"):GetComponent("UILabel");


end

function LR_GameOverPanel.OnEnable()
	--用于时间过长不操作隐藏掉
    local delay = 10
    if MyCommon.GetAutoReady() == true then
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
	label_winCoin.gameObject:SetActive(false)




end  

function LR_GameOverPanel.OnDisable()
	self.time:Stop()
	label_winCoin.gameObject:SetActive(false)
    Computer.DelectResidueCards()
    --[[
    local audioSource = LRDDZ_MusicManager.instance.GetAudioSource
    if audioSource ~= nil and (audioSource.clip.name == "bgsound4" or audioSource.clip.name == "bgsound5") then
        local rand = math.random(1,3);
        LRDDZ_MusicManager.instance:PlayMuisc("bgsound"..rand, true, true, false, 0.5)
    end
    ]]
end 
function LR_GameOverPanel.ClearCalCardList()--清除结算界面显示的牌
	for k,obj in pairs (self.giveupCardList) do
		self.behaviour:MyDestroy(obj)
	end
	self.giveupCardList ={}
	for k,obj in pairs (self.remainCardList) do
		self.behaviour:MyDestroy(obj)
	end
	self.remainCardList ={}
end
function LR_GameOverPanel.OkCallBack()
	print("OkCallBack")
	--重置
	
	--GameCtrl.ReSetGame()
	self.ClearCalCardList()
	GamePanel.DealCallBack()

	GamePanel.GameOverAnim(true)
	if titleEff ~= nil then
		destroy(titleEff)
	end
	CountDownPanel.CancelCountDown(false)
	gameObject:SetActive(false)
end 
function LR_GameOverPanel.changeTableCallBack()
	--换一个角色
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
end
function LR_GameOverPanel.TimerOut()
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
    else
        GamePanel.ActiveReady()
    end
	
end	

function LR_GameOverPanel.SetGameOverInfoByServer(winnertype,discards,double,hidedouble,bombtimes,residueCards,integration)

    GameCtrl.ReSetGame()
	--震动
	--UnityEngine.Handheld.Vibrate()
	local giveuppoint = transform:FindChild("giveupCard/giveupPoint").gameObject --获取弃牌的父级
    local remainpoint =transform:FindChild("remainPoint").gameObject --获取剩下牌的父级
    --显示弃牌
    local giveuplibrary = LRDDZ_Game.ServerToCard(discards)
    for i=1, #giveuplibrary do 
    	local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","LuaPoker",false)
		obj.transform.parent = giveuppoint.transform;
		obj.transform.localScale = Vector3.New(0.55,0.55,0.55);
		obj.gameObject.transform.localPosition =Vector3.New((i-1)*30,0,0)
		--obj.gameObject.transform:GetComponent("UISprite").spriteName = giveuplibrary[i].cardName
		obj.gameObject.transform:GetComponent("UISprite").depth = i+10

        --[[
        if giveuplibrary[i].weight >= Weight.SJoker then
            obj.transform:GetComponent("UISprite").spriteName = WeightString[giveuplibrary[i].weight]
        else
            obj.transform:GetComponent("UISprite").spriteName = giveuplibrary[i].suits
        end
        obj.transform:FindChild("Label"):GetComponent("UILabel").text = SuitsColor[giveuplibrary[i].suits]..WeightText[giveuplibrary[i].weight]
        ]]
        MyCommon.Set2DCard(obj,giveuplibrary[i].suits,giveuplibrary[i].weight)
        obj.transform:FindChild("Label"):GetComponent("UILabel").depth = 11+i


		self.giveupCardList[i] = obj
    end
    giveuppoint:GetComponent("UIGrid").repositionNow = true
    --显示失败一方的界面

	if winnertype == CharacterType.Player  then 												--玩家胜利
       	transform:FindChild("winIntegration").gameObject:SetActive(true)	--赢得的钱Label

        --显示胜利的特效
        LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","ShengLi", "ShengLi",Vector3.New(1,1,1),Vector3.New(299.36,35.41,40.32), false,function(obj,name)
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
        transform:FindChild("winIntegration").gameObject:SetActive(true)
        --显示失败特效
        LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","ShengLi-2", "ShengLi-2",Vector3.New(1,1,1),Vector3.New(299.36,35.41,40.32), false,function(obj,name)
        	titleEff = obj
        	obj.transform.localRotation = Quaternion.Euler(-29.44299,0.3622,0.5799)
		end,nil)
    end
    if integration > 0 then
        transform:FindChild("winIntegration").gameObject:GetComponent('UILabel').text = "+"..MyCommon.SetNumFormat(integration)
    else
        transform:FindChild("winIntegration").gameObject:GetComponent('UILabel').text = MyCommon.SetNumFormat(integration)
    end
    
    ---计算金币
    --print(integration)
    --EginUser.Instance.bagMoney = EginUser.Instance.bagMoney + integration
    --Avatar.avatarGold = Avatar.avatarGold + integration
	GamePanel.PlayerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Avatar.avatarGold)
    --在GameCtrl计算了 在这里显示就可以了
	GamePanel.ComputerInteration:GetComponent("UILabel").text = MyCommon.SetNumFormat(Computer.gold)



	
        ----------------------------------失败一方的剩牌---------------------------------------
    --删除remainpoint下面的所有牌
    if residueCards ~= nil then
        for i=1, #residueCards do
        	local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","LuaPoker",false)
    		obj.transform.parent = remainpoint.transform;
    		obj.transform.localScale = Vector3.New(0.6,0.6,0.6);
    		obj.gameObject.transform.localPosition =Vector3.New((i-1)*30,0,0)
    		obj.gameObject.transform:GetComponent("UISprite").spriteName = residueCards[i].cardName
    		obj.gameObject.transform:GetComponent("UISprite").depth = i+10
    		LR_GameOverPanel.remainCardList[i] = obj
        end
        remainpoint:GetComponent("UIGrid").repositionNow = true
    end

    --[[
    -><color=#00ff00>ReceiveMessage{"body": {"rocket_times": 0, "bomb_times": 0, "double": 400, "winner": 889980371, "system_win": 5.0, 
    "user_win_money": [{"cards": [], "winmoney": 498.0, "tax": 2.0, "uid": 889980371}, 
    {"cards": [33, 34, 9, 10, 11, 37, 50, 53], "winmoney": 498.0, "tax": 2.0, "uid": 889728284}, 
    {"cards": [7, 20, 12, 38], "winmoney": -1000, "tax": 0, "uid": 889731846}], "is_spring": false}, "tag": "gameover", "type": "ddz"}</color>
    ]]


    --结算界面显示所有的倍数
   	transform:FindChild("AllMultiples"):GetComponent('UILabel').text = string.format("×%d", double);
   	transform:FindChild("BottomMultiples"):GetComponent('UILabel').text = string.format("×%d", 1);


    --transform:FindChild("SpringMultiples"):GetComponent('UILabel').text = string.format("×%d", springtime);
   	--transform:FindChild("GardLordMultiples"):GetComponent('UILabel').text = string.format("×%d", calltimes);
    --加倍
    --transform:FindChild("DoubleMultiples"):GetComponent('UILabel').text = string.format("×%d", hidedouble);
    transform:FindChild("BoomMultiples"):GetComponent('UILabel').text = string.format("×%d", bombtimes);

    --动画
    local getCoin = transform:FindChild("winIntegration").gameObject
    local multiples = transform:FindChild("AllMultiples").gameObject
    local giveupCard = transform:FindChild("giveupCard").gameObject
   	local coinpos = getCoin.transform.localPosition
   	local multiplespos = multiples.transform.localPosition
   	local giveupcardpos = giveupCard.transform.localPosition
   	getCoin:SetActive(false)
   	multiples:SetActive(false)
   	giveupCard:SetActive(false)
   	self.okbtn:SetActive(false)
   	self.changeTable:SetActive(false)
   	local okbtnPos = self.okbtn.transform.localPosition;
   	local changeTablePos = self.changeTable.transform.localPosition;

   	--title动画播放
    local function anim()
        
        giveupCard.transform.localPosition = giveupcardpos + Vector3.New(1000,0,0)
        giveupCard:SetActive(true)
        iTween.MoveTo(giveupCard,iTween.Hash("x",giveupcardpos.x, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack))

        coroutine.wait(0.5)
        multiples.transform.localPosition = multiplespos + Vector3.New(1000,0,0)
        multiples:SetActive(true)
        iTween.MoveTo(multiples,iTween.Hash("x",multiplespos.x, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack))

        coroutine.wait(0.5)
        --显示getCoin
        getCoin.transform.localPosition = coinpos + Vector3.New(1000,0,0)
        getCoin:SetActive(true)
        iTween.MoveTo(getCoin,iTween.Hash("x",coinpos.x, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack))

        coroutine.wait(0.5)

        --金币飞动画
        if winnertype == CharacterType.Player  then 
            coroutine.start(LR_GameOverPanel.CoinAnim)
        end

        self.okbtn.transform.localPosition = okbtnPos + Vector3.New(0,-500,0);
        self.changeTable.transform.localPosition = changeTablePos + Vector3.New(0,-500,0);
        self.okbtn:SetActive(true)
        self.changeTable:SetActive(true)
        iTween.MoveTo(self.okbtn,iTween.Hash("y",okbtnPos.y, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack,"delay",0.3))
        iTween.MoveTo(self.changeTable,iTween.Hash("y",changeTablePos.y, "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutBack))
    end
    coroutine.start(anim)
end
function LR_GameOverPanel.CoinAnim()
    --创建10金币
  	local anim_coin = transform:FindChild("winIntegration/anim_coin").gameObject;
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
    label_winCoin.text = "+"..winIntegration;
    label_winCoin.gameObject:SetActive(true)
    coroutine.wait(2)
    label_winCoin.gameObject:SetActive(false)
    coroutine.wait(0.1)
    for i=1,#coins do
    	--LRDDZ_SoundManager.PlaySoundEffect("getCoin",coins[i])
    	destroy(coins[i])
    	coroutine.wait(0.04)
    end

end
