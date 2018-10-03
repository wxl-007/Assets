local this = LuaObject:New()
GameSHHZPlayer = this

local playerlist;
local playerTable;
local playerTableUseCount;
local playerPrefab;
local playerParent;

local pointList;
local pointTable;
local pointTableUseCount;
local pointPrefab;

local curPage = 0;
local pageItemCount = 10;   -- 每页有10项

local players;

local windowTweenPosition;

-------------------------------------------------------------------------------------------------
function this.Awake()
	this.initPanel();
end

-------------------------------------------------------------------------------------------------
-- 倒计时
function this.OnEnable()
    this.ShowPanel();
end

-------------------------------------------------------------------------------------------------
-- 初始化面板
function this.initPanel()
	-- UI动画控件
	windowTweenPosition = this.gameObject:GetComponent("TweenPosition");

	--关闭按钮
	local btnClose = this.transform:FindChild("panelbg/CloseBtn").gameObject;
	this.mono:AddClick(btnClose, this.HidePanel);
    --关闭按钮
    btnClose = this.transform:FindChild("panelbg/black").gameObject;
    this.mono:AddClick(btnClose, this.HidePanel);

    -- 
    playerlist = this.transform:FindChild("playerlist");

    -- 上一页
    local btnPre = playerlist:FindChild("pre").gameObject;
    this.mono:AddClick(btnPre, this.OnClickPre);
    -- 下一页
    local btnNext = playerlist:FindChild("next").gameObject;
    this.mono:AddClick(btnNext, this.OnClickNext);

    -- 玩家
    playerTable = {};
    local panelList = playerlist:FindChild("Scroll View");
    playerParent = panelList:FindChild("Grid"):GetComponent("UIGrid");
    playerPrefab = panelList:FindChild("Grid/item").gameObject;
    playerPrefab:SetActive(false);
    playerTableUseCount = 0;
    table.insert(playerTable, playerPrefab);

    -- 点的预制体
    pointTable = {};
    pointList = playerlist:FindChild("pointList"):GetComponent("UIGrid");
    pointPrefab = playerlist:FindChild("point").gameObject;
    pointPrefab:SetActive(false);
    pointTableUseCount = 0;
    table.insert(pointTable, pointPrefab);
end


-------------------------------------------------------------------------------------------------
-- 关闭按钮回调
function this.OnCloseBtnClick()
    this.HideSettlementPanel();
    GameSHHZSetting.PlaySound("Button");
end

-------------------------------------------------------------------------------------------------
-- 显示界面
function this.ShowPanel()
    -- 面板出现动画
    windowTweenPosition:PlayForward();

    this.initPlayer();

    this.updatePlayer();
end


function this.initPlayer()
    curPage = 0;
    players = {};

    local allPlayers = GameSHHZUI.getPlayerTable();
    -- 所有玩家
    for k, v in pairs(allPlayers) do
        if v~=nil then
            table.insert(players, v);
        end
    end

    this.HiddenAllPoint();
    local playerCount = #players;
    local ponitCount = math.ceil(playerCount/10);
    --error("player count "..playerCount.."point count "..ponitCount);
    for i=1, ponitCount do
        local point = this.getPoint();
        local sprite = point:GetComponent("UISprite");
        if i==curPage+1 then
            sprite.spriteName = "point2";
        else
            sprite.spriteName = "point1";
        end
    end
    pointList:Reposition();
end


-------------------------------------------------------------------------------------------------
-- 隐藏界面
function this.updatePlayer()
    this.HiddenAllPlayer();
    local playerCount = #players;

    -- 
    local index = curPage * pageItemCount;
    if playerCount-index>pageItemCount then
        playerCount = index + pageItemCount;
    end
    --error("index="..index.."playerCount="..playerCount);
    for i=index+1, playerCount do
        local player = players[i];
        local go = this.getItem();
        GameSHHZ.updatePlayer(player, go.transform);
    end

    playerParent:Reposition();
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


function this.OnClickPre()
    if curPage <= 0 then
        curPage = 0;
    else
        this.updatePage(curPage, curPage - 1);
        curPage = curPage - 1;
        this.updatePlayer();
    end
end


function this.OnClickNext()
    local playerCount = #players;
    local ponitCount = math.ceil(playerCount/10) - 1;
    if curPage >= ponitCount then
        curPage = ponitCount;
    else
        this.updatePage(curPage, curPage + 1);
        curPage = curPage + 1;
        this.updatePlayer();
    end
end

function this.updatePage(page, prePage)
    local sprite = pointTable[prePage+1]:GetComponent("UISprite");
    sprite.spriteName = "point2";

    sprite = pointTable[page+1]:GetComponent("UISprite");
    sprite.spriteName = "point1";
end


-------------------------------------------------------------------------------------------------
-- 获取玩家列表对象
function this.getItem()
    local count = #playerTable;
    local go;
    if playerTableUseCount >= count then
        go = GameObject.Instantiate(playerPrefab);
        table.insert(playerTable, go);
    else
        go = playerTable[playerTableUseCount+1];
    end
    go:SetActive(true);
    go.transform.parent = playerParent.transform;
    go.transform.localScale = Vector3.one;
    playerTableUseCount = playerTableUseCount + 1;
    return go;
end


-------------------------------------------------------------------------------------------------
-- 隐藏所有等待玩家列表项
function this.HiddenAllPlayer()
    for i = 1, playerTableUseCount do
        playerTable[i]:SetActive(false);
        playerTable[i].transform.parent = playerlist;
    end
    playerTableUseCount = 0;
end


-------------------------------------------------------------------------------------------------
-- 获取点对象
function this.getPoint()
    local count = #pointTable;
    local go;
    if pointTableUseCount >= count then
        go = GameObject.Instantiate(pointPrefab);
        table.insert(pointTable, go);
    else
        go = pointTable[pointTableUseCount+1];
    end
    go:SetActive(true);
    go.transform.parent = pointList.transform;
    go.transform.localScale = Vector3.one;
    pointTableUseCount = pointTableUseCount + 1;
    return go;
end


-------------------------------------------------------------------------------------------------
-- 隐藏点对象
function this.HiddenAllPoint()
    for i = 1, pointTableUseCount do
        pointTable[i]:SetActive(false);
        pointTable[i].transform.parent = playerlist;
    end
    pointTableUseCount = 0;
end
