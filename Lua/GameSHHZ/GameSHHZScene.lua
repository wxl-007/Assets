require "GameSHHZ/GameSHHZBanker"

local this = LuaObject:New()
GameSHHZScene = this


local sceneCamera;
local deskPsParent;


-------------------------------------------------------------------------------------------------
function this.Start()
	sceneCamera = this.transform:FindChild("SceneCamera"):GetComponent("Camera");
	deskPsParent = this.transform:FindChild("Desk/DeskPs");
	this.HideSelectPs();
	-- coroutine.start(this.doUpdate);
end


-------------------------------------------------------------------------------------------------
-- 开始游戏
function this.StartGame()
	-- 隐藏桌子上区域特效
	this.HideSelectPs();
	-- 做摇色子的动画
	GameSHHZBanker.playDiceAnimation();
end


-------------------------------------------------------------------------------------------------
-- 每帧更新函数
-- function this.doUpdate()
-- 	while true do
-- 	    if Input.GetMouseButtonDown(0) then
-- 	    	log("doupdate");
-- 		    if GameSHHZUI.CurState == GameSHHZUI.GameState.Bet then
-- 			    local touchAreaLayer = bit.lshift(1, LayerMask.NameToLayer("TouchLayer"));
-- 			    if sceneCamera ~= nil then
-- 				    local uIray = sceneCamera:ScreenPointToRay(Input.mousePosition);
-- 				    local isHit, hit = Physics.Raycast(uIray, hit, 600, touchAreaLayer);
-- 				    if isHit then
-- 				    	local objectName = hit.transform.name;
-- 				    	GameSHHZUI.MyBet(objectName);
-- 					end
-- 				end
-- 			end
-- 		end
-- 		coroutine.wait(0.01);
-- 	end
-- end


-------------------------------------------------------------------------------------------------
--显示桌子上区域特效
function this.ShowSelectPs(betType)
	local fx = deskPsParent:FindChild(betType);
	if fx~=nil then
		fx.gameObject:SetActive(true);
	end
 end


-------------------------------------------------------------------------------------------------
--隐藏桌子上区域特效
function this.HideSelectPs()
	--投注数量按钮
	local childCount = deskPsParent.childCount - 1;
	for i = 0, childCount do
		local deskPs = deskPsParent:GetChild(i).gameObject;
		deskPs.gameObject:SetActive(false);
	end
end


-------------------------------------------------------------------------------------------------
--隐藏桌子上区域特效
function this.ShowDeskPs(dice1Num, dice2Num)
	local diceNum = dice1Num + dice2Num;
    if diceNum < 7 then
        this.ShowSelectPs("SmallArea");
    elseif diceNum == 7 then
        this.ShowSelectPs("MediumArea");
    else
        this.ShowSelectPs("BigArea");
    end

    if dice1Num == dice2Num then
        if dice1Num == 1 then
            this.ShowSelectPs("Pair1Area");
        elseif dice1Num == 2 then
            this.ShowSelectPs("Pair2Area");
        elseif dice1Num == 3 then
            this.ShowSelectPs("Pair3Area");
        elseif dice1Num == 4 then
            this.ShowSelectPs("Pair4Area");
        elseif dice1Num == 5 then
            this.ShowSelectPs("Pair5Area");
        elseif dice1Num == 6 then
            this.ShowSelectPs("Pair6Area");
        end
    end
end
