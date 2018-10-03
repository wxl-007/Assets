local this = LuaObject:New()
GameSHHZSettlement = this

local windowTweenPosition;

local btnContinue;
local labelRemainTime;
local stopTimeCount;
local myBet;
local myWin;
local totalBet;
local bankerWin;
local effect;

-------------------------------------------------------------------------------------------------
function this.Awake()
	this.initPanel();
end


-------------------------------------------------------------------------------------------------
-- 初始化面板
function this.initPanel()

	-- UI动画控件
	windowTweenPosition = this.gameObject:GetComponent("TweenPosition");

	--继续游戏
	local btnContinue = this.transform:FindChild("settlementPanel/ContinueBtn").gameObject;
	this.mono:AddClick(btnContinue, this.OnContinueBtnClick);
	--剩余时间
	labelRemainTime = this.transform:FindChild("settlementPanel/ContinueBtn/Label"):GetComponent("UILabel");

    myBet = this.transform:FindChild("settlementPanel/betCount/Sprite/Label"):GetComponent("UILabel");
    myWin = this.transform:FindChild("settlementPanel/MyWin"):GetComponent("UILabel");
    totalBet = this.transform:FindChild("settlementPanel/totalBetCount/Sprite/Label"):GetComponent("UILabel");
    bankerWin = this.transform:FindChild("settlementPanel/bankerWin/Sprite/Label"):GetComponent("UILabel");

    --关闭按钮
    local btnClose = this.transform:FindChild("panelbg/black").gameObject;
    this.mono:AddClick(btnClose, this.OnContinueBtnClick);

end


-------------------------------------------------------------------------------------------------
-- 倒计时
function this.TimeCount(showTime)
    stopTimeCount = true;
    local startTime = Time.realtimeSinceStartup;
    local remainTime = showTime;
    while stopTimeCount do
        labelRemainTime.text = math.ceil(remainTime);
        remainTime = startTime - Time.realtimeSinceStartup + showTime;

        if remainTime > 0 then
            coroutine.wait(0.05);
        else
            this.OnContinueBtnClick();
        end
    end
end


-------------------------------------------------------------------------------------------------
-- 结算后继续游戏
function this.OnContinueBtnClick()
    -- 隐藏结算面板
    this.HideSettlementPanel();
    stopTimeCount = false;
end


-------------------------------------------------------------------------------------------------
-- 显示界面
function this.ShowPanel(showTime, nMybet, jsonSettlement)

    --显示界面
    this.gameObject:SetActive(true);
    windowTweenPosition:PlayForward();
    GameSHHZSetting.PlaySound("poppanel");
    coroutine.start(this.TimeCount, showTime);

    -- 自己赢了多少钱
    local nMyWin = tonumber(jsonSettlement["mywin"]);
    -- 庄家赢了多少钱
    local nBankerWin = tonumber(jsonSettlement["dealer_win"]);
    -- 桌上有多少钱，总下注
    local nTotalBet = tonumber(jsonSettlement["pot"]);
    -- 赢钱最多的4个玩家
    local top4Info = jsonSettlement["top4_wins"];

    -- 色子的数字
    local hands = jsonSettlement["win_hands"];
    local dice1Num = tonumber(hands[1][1])+1;
    local dice2Num = tonumber(hands[1][2])+1;
    local dice1 = this.transform:FindChild("settlementPanel/result/Sprite/dice1"):GetComponent("UISprite");
    local dice2 = this.transform:FindChild("settlementPanel/result/Sprite/dice2"):GetComponent("UISprite");
    local record = this.transform:FindChild("settlementPanel/result/Sprite/record"):GetComponent("UISprite");
    dice1.spriteName = "dice"..dice1Num;
    dice2.spriteName = "dice"..dice2Num;
    local count = dice1Num + dice2Num;
    if count<7 then
        record.spriteName = "recordsmall";
    elseif count>7 then
        record.spriteName = "recordbig";
    else
        record.spriteName = "recorddraw";
    end

    local sprTitle = this.transform:FindChild("panelbg/title"):GetComponent("UISprite");
    local ribbon1 = this.transform:FindChild("panelbg/ribbon1"):GetComponent("UISprite");
    local ribbon2 = this.transform:FindChild("panelbg/ribbon2"):GetComponent("UISprite");
    local ribbon3 = this.transform:FindChild("panelbg/ribbon3"):GetComponent("UISprite");
    local effect = this.transform:FindChild("panelbg/effect"):GetComponent("UISprite");
    -- 自己的输赢
    if nMyWin == 0 then
        sprTitle.spriteName = "pingju";
        ribbon1.spriteName = "ribbon1";
        ribbon2.spriteName = "ribbon3";
        ribbon3.spriteName = "ribbon3";
        effect.spriteName = "effect1";
        local fontPrefab = ResManager:LoadAsset("gameshhz/font", "settlementWin");
        myWin.bitmapFont = fontPrefab:GetComponent("UIFont");
        myWin.text = nMyWin;
    elseif nMyWin < 0 then
        sprTitle.spriteName = "lost";
        ribbon1.spriteName = "ribbon1blue";
        ribbon2.spriteName = "ribbon3blue";
        ribbon3.spriteName = "ribbon3blue";
        effect.spriteName = "effect2"
        local fontPrefab = ResManager:LoadAsset("gameshhz/font", "settlementFail");
        myWin.bitmapFont = fontPrefab:GetComponent("UIFont");
        myWin.text = string.format("%d", nMyWin);
    else
        sprTitle.spriteName = "win";
        ribbon1.spriteName = "ribbon1";
        ribbon2.spriteName = "ribbon3";
        ribbon3.spriteName = "ribbon3";
        effect.spriteName = "effect1"
        local fontPrefab = ResManager:LoadAsset("gameshhz/font", "settlementWin");
        myWin.bitmapFont = fontPrefab:GetComponent("UIFont");
        myWin.text = string.format("+%d", nMyWin);
    end
    
    sprTitle:MakePixelPerfect();
    myBet.text = nMybet;

    -- 赢钱最多的4个玩家
    -- for i=1, 4 do
    --     local range = this.transform:FindChild("settlementPanel/range/Num"..i);
    --     local Name = range:FindChild("Name"):GetComponent("UILabel");
    --     local Num = range:FindChild("Num"):GetComponent("UILabel");
    --     local uid = top4Info[i][1];
    --     local money = top4Info[i][2];
    --     local player = GameSHHZUI.getPlayer(uid);
    --     Name.text = player.nickname;
    --     Num.text = money;
    -- end

    -- 庄家输赢
    if nBankerWin == 0 then
        --bankerWin.color = Color.New(21.0/255.0, 241.0/255.0, 41.0/255.0, 1.0); -- 绿色
        bankerWin.text = nBankerWin;
    elseif nBankerWin < 0 then
        --bankerWin.color = Color.New(255.0/255.0, 88.0/255.0, 88.0/255.0, 1.0); -- 红色
        bankerWin.text = string.format("%d", nBankerWin);
    else
        --bankerWin.color = Color.New(21.0/255.0, 241.0/255.0, 41.0/255.0, 1.0); -- 绿色
        bankerWin.text = string.format("+%d", nBankerWin);
    end
    totalBet.text = nTotalBet;
end


-------------------------------------------------------------------------------------------------
-- 隐藏界面
function this.HideSettlementPanel()
    windowTweenPosition:PlayReverse();
    coroutine.start(this.hidden);
end


-------------------------------------------------------------------------------------------------
-- 隐藏界面
function this.hidden()
    coroutine.wait(0.6);
    this.gameObject:SetActive(false);
end