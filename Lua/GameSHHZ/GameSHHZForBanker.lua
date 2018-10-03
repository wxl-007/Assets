local this = LuaObject:New()
GameSHHZForBanker = this

local windowTweenPosition;

local bankerTable = {};
local bankerTableUseCount;
local bankerPrefab;
local isInList = false;

local bankerParent;
local panelList;

local waitingTips;
local minBankerMoney;

local btnBanker;

-------------------------------------------------------------------------------------------------
function this.Awake()
	this.initPanel();
end

-------------------------------------------------------------------------------------------------
-- 初始化面板
function this.initPanel()
    
    windowTweenPosition = this.gameObject:GetComponent("TweenPosition");

    -- 面板
    panelList = this.transform:FindChild("bankerlist");

    --关闭按钮
    local btnClose = this.transform:FindChild("panelbg/CloseBtn").gameObject;
    this.mono:AddClick(btnClose, this.OnCloseBtnClick);
    --关闭按钮
    btnClose = this.transform:FindChild("panelbg/black").gameObject;
    this.mono:AddClick(btnClose, this.HidePanel);

    --上庄/下庄按钮
    btnBanker = panelList:FindChild("btn").gameObject;
    this.mono:AddClick(btnBanker, this.OnClickBanker);

    --预制体
    bankerTable = {};
    bankerParent = panelList:FindChild("Scroll View/Grid"):GetComponent("UIGrid");
    bankerPrefab = panelList:FindChild("item").gameObject;
    bankerPrefab:SetActive(false);
    bankerTableUseCount = 0;
    table.insert(bankerTable, bankerPrefab);

    -- 最小上庄金币
    minBankerMoney = panelList:FindChild("shuoming"):GetComponent("UILabel");

    -- 按了上庄/下庄按钮，有文字提示
    waitingTips = panelList:FindChild("waiting").gameObject;
    waitingTips:SetActive(false);
end


-------------------------------------------------------------------------------------------------
-- 上庄/下庄按钮
function this.ResetBtnEnable()
    local sptTxt = btnBanker.transform:FindChild("sptTxt"):GetComponent("UISprite");
    local btn = btnBanker:GetComponent("UIButton");
    local bg = btnBanker:GetComponent("UISprite");
    local enable = false;
    if isInList==true then
        if GameSHHZUI.GameState.Bet~=GameSHHZUI.CurState then
            enable = true;
        end
    else
        local player = GameSHHZUI.getPlayer(tonumber(EginUser.Instance.uid));
        if GameSHHZUI.minBankerMoney<player.money and GameSHHZUI.GameState.Bet~=GameSHHZUI.CurState then
            enable = true;
        end
    end
    btn.enabled = enable;

    local strTxt;
    if isInList==false then
        strTxt = "btnUpBanker";
    else
        strTxt = "btnDownBanker";
    end

    if enable==true then
        strTxt = strTxt.."1";
        bg.spriteName = "btnbg1"
    else
        strTxt = strTxt.."2";
        bg.spriteName = "btnbg2"
    end

    sptTxt.spriteName = strTxt;
end


-------------------------------------------------------------------------------------------------
-- 上庄/下庄按钮
function this.OnClickBanker()

    local btn = btnBanker:GetComponent("UIButton");
    if btn.enabled == false then
        return ;
    end

    local sdat;
    -- 我是否在队列上庄队列里里面
    if isInList==true then
        sdat = {type="shhz",tag="downdealer"};
        waitingTips:SetActive(false);
    else
        sdat = {type="shhz",tag="updealer"};
        waitingTips:SetActive(true);
    end

    local jsonStr = cjson.encode(sdat);
    GameSHHZUI.SendMessage(jsonStr);
end


-------------------------------------------------------------------------------------------------
-- 关闭按钮回调
function this.IsInWaitingList()
    return isInList;
end


-------------------------------------------------------------------------------------------------
-- 关闭按钮回调
function this.OnCloseBtnClick()
    this.HidePanel();
    GameSHHZSetting.PlaySound("Button");
end


-------------------------------------------------------------------------------------------------
-- 获取等待上庄的玩家列表对象
function this.getItem()
    local count = #bankerTable;
    local go;
    if bankerTableUseCount >= count then
        go = GameObject.Instantiate(bankerPrefab);
        table.insert(bankerTable, go);
    else
        go = bankerTable[bankerTableUseCount+1];
    end
    go:SetActive(true);
    go.transform.parent = bankerParent.transform;
    go.transform.localScale = Vector3.one;
    bankerTableUseCount = bankerTableUseCount + 1;
    return go;
end


-------------------------------------------------------------------------------------------------
-- 隐藏所有等待上庄玩家列表项
function this.HiddenAllBanker()
    for i = 1, bankerTableUseCount do
        bankerTable[i]:SetActive(false);
        bankerTable[i].transform.parent = panelList;
    end
    bankerTableUseCount = 0;
end


-------------------------------------------------------------------------------------------------
-- 显示界面
function this.UpdatWaitBanker(waitBankerPlayer)
    
    if this.gameObject.activeInHierarchy==false then
        return;
    end

    this.HiddenAllBanker();

    isInList = false;
    local playerCount = #waitBankerPlayer;
    for i=1, playerCount do
        local player = waitBankerPlayer[i];
        if player~=nil then

            if player.uid == tonumber(EginUser.Instance.uid) then 
                isInList = true;
            end

            local go = this.getItem();
            local linebg = go.transform:FindChild("linebg");
            if i%2==0 then
                linebg.gameObject:SetActive(false);
            else
                linebg.gameObject:SetActive(true);
            end
            -- 昵称
            local nameText = go.transform:FindChild("name"):GetComponent("UILabel");
            nameText.text = player.nickname;
            if player.uid == tonumber(EginUser.Instance.uid) then 
                nameText.color = Color.New(255.0/255.0, 219.0/255.0, 17.0/255.0, 1.0); -- 黄色
                isInList = true;
            else
                nameText.color = Color.New(255.0/255.0, 255.0/255.0, 255.0/255.0, 1.0); -- 白色
            end
            
            -- 金钱
            local nameText = go.transform:FindChild("count"):GetComponent("UILabel");
            nameText.text = GameSHHZ.getMoneyString(player.money);
        end
    end
    bankerParent:Reposition();

    if isInList==true then
        waitingTips:SetActive(true);
    else
        waitingTips:SetActive(false);
    end

    -- 显示下庄按钮
    this.ResetBtnEnable();

    -- 列表
    bankerParent:Reposition();

    local scrollView = this.transform:FindChild("bankerlist/Scroll View"):GetComponent("UIScrollView");
    scrollView:ResetPosition();
    scrollView.gameObject:SetActive(false);
    scrollView.gameObject:SetActive(true);
end


-------------------------------------------------------------------------------------------------
-- 显示界面
function this.ShowPanel(waitBankerPlayer)
    this.UpdatWaitBanker(waitBankerPlayer);
    if GameSHHZUI.minBankerMoney>10000 then
        minBankerMoney.text = string.format("上庄要求%d万以上游戏币", GameSHHZUI.minBankerMoney/10000);
    else
        minBankerMoney.text = string.format("上庄要求%d以上游戏币", GameSHHZUI.minBankerMoney);
    end

    windowTweenPosition:PlayForward();
end


-------------------------------------------------------------------------------------------------
-- 隐藏界面
function this.HidePanel()
    windowTweenPosition:PlayReverse();
    coroutine.start(this.hidden);
end


-------------------------------------------------------------------------------------------------
-- 隐藏界面
function this.hidden()
    coroutine.wait(0.6);
    this.gameObject:SetActive(false);
end
