local this = LuaObject:New()
GameSHHZBanker = this

-- 色子
local dice1;
local dice2;

-- 色子特效
local dicePs;
local openPs;

-- 角色动画
local avatarAnimator;

-- 只能看到色子的摄像机
local diceCamera;

local theFat1Ani;
local theFat2Ani;

local EulerAngles = {
    Vector3.New(-8,-90,41),
    Vector3.New(27,0,57),
    Vector3.New(-40,64,-175),
    Vector3.New(-13,175,33),
    Vector3.New(72,177,60),
    Vector3.New(-10,-94,-141)
}; 
-- local EulerAngles = {
--     Vector3.New(-7,-176,68),
--     Vector3.New(0,-90,57),
--     Vector3.New(-46,0,148),
--     Vector3.New(14,85,30),
--     Vector3.New(81,-84,-111),
--     Vector3.New(-7,172,-114)
-- };


this.AvatarAnimationType = {
    Open = "Open",
    Look = "Look",
    Dice = "Dice",
    Tell = "Tell",
};


-------------------------------------------------------------------------------------------------
-- 设置色子数字
function this.Start()
    -- 
    dice1 = this.transform:FindChild("hezi02/dice1").gameObject;
    dice2 = this.transform:FindChild("hezi02/dice2").gameObject;

    dicePs = this.transform:FindChild("dicePs"):GetComponent("ParticleSystem");
    dicePs.gameObject:SetActive(false);
    openPs = this.transform:FindChild("openPs").gameObject;
    openPs:SetActive(false);

    diceCamera = this.transform.parent:FindChild("ResultCamera").gameObject;
    diceCamera:SetActive(false);

    theFat1Ani = this.transform.parent:FindChild("pangzi1"):GetComponent("Animator");
    theFat2Ani = this.transform.parent:FindChild("pangzi2"):GetComponent("Animator");

    avatarAnimator = this.gameObject:GetComponent("Animator");
end


-------------------------------------------------------------------------------------------------
-- 设置色子数字
function this.SetDiceNum(num1, num2)
    this.RefreshCurPoint(dice1, num1);
    this.RefreshCurPoint(dice2, num2);
end


-------------------------------------------------------------------------------------------------
-- 设置色子数字
function this.RefreshCurPoint(dice, type)
    dice.transform.localEulerAngles = EulerAngles[type];
end

-------------------------------------------------------------------------------------------------
-- 庄家在说话
function this.playSpeakAnimation()
    avatarAnimator:SetTrigger("Speak");
end


-------------------------------------------------------------------------------------------------
-- 庄家左右看
function this.playLookAnimation()
    avatarAnimator:SetTrigger("Look");
end


-------------------------------------------------------------------------------------------------
-- 胖子特殊动作
function this.playTheFatSpecial()
    theFat1Ani:SetTrigger("Special");
    theFat2Ani:SetTrigger("Special");
    local theFatAni = math.random(0, 1);
    theFat1Ani:SetInteger("SpecialType", theFatAni);
    theFatAni = math.random(0, 1);
    theFat2Ani:SetInteger("SpecialType", theFatAni);
end


-------------------------------------------------------------------------------------------------
-- 摇色子动画
function this.playDiceAnimation()
    coroutine.start(this.DicAnimationCoroutine);
    avatarAnimator:SetTrigger("Dice");
    dice1:SetActive(false);
    dice2:SetActive(false);
end
-------------------------------------------------------------------------------------------------
-- 摇色子动画过程中要执行的操作
function this.DicAnimationCoroutine()
    --播放声音
    GameSHHZSetting.PlaySound("Dice");
    coroutine.wait(2.8);
    --播放特效
    dicePs.gameObject:SetActive(true);
    dicePs:Play();
    coroutine.wait(1.0);
    GameSHHZUI.BeginBetUIAnimation();
end


-------------------------------------------------------------------------------------------------
-- 角色开盅动画
function this.playOpenAnimation(dice1Num, dice2Num, nBankerWin)
    --log("dice1Num="..dice1Num..", dice2Num="..dice2Num);
    GameSHHZSetting.PlaySound("Stop")
    avatarAnimator:SetTrigger("Open");
    dice1:SetActive(true);
    dice2:SetActive(true);
    this.SetDiceNum(dice1Num, dice2Num);
    coroutine.start(this.PlayDiceCamera, dice1Num, dice2Num, nBankerWin);
end


-------------------------------------------------------------------------------------------------
-- 角色开盅动画
function this.PlayDiceCamera(dice1Num, dice2Num, nBankerWin)
    -- 庄家播放胜利、失败动画
    local bankerWiLostType;
    if nBankerWin<0 then
        bankerWiLostType = math.random(0, 1);
    else
        bankerWiLostType = math.random(2, 3);
    end
    avatarAnimator:SetInteger("Type", bankerWiLostType);

    coroutine.wait(1.0);
    coroutine.start(this.PlayResultDice, dice1Num, dice2Num);
end

function this.PlayResultDice(dice1Num, dice2Num)
    -- 开盅音效
    GameSHHZSetting.PlaySound("Open");
    openPs:SetActive(true);
    --角色开盅对白
    GameSHHZSetting.PlaySound("charOpen1");
    diceCamera:SetActive(true);
    local animationName = "diceCameraAnimation1";
    local count = dice1Num + dice2Num;
    if count < 7 then
        animationName = "diceCameraAnimation3";
    elseif count == 7 then
        animationName = "diceCameraAnimation2";
    end

    diceCamera:GetComponent("Animator"):Play(animationName);
    local bankerWiLostType = avatarAnimator:GetInteger("Type");
    local theFatAni = 0;
    --lost倒地
    if bankerWiLostType == 0 then
        coroutine.wait(1.0);
        GameSHHZSetting.PlaySound("Trip");
        GameSHHZSetting.PlaySound("charLost1");
        theFatAni = 0;
    --lost捶桌
    elseif bankerWiLostType == 1 then
        coroutine.wait(1.0);
        local soundType = math.random(2, 3);
        GameSHHZSetting.PlaySound("charLost"..soundType);
        theFatAni = 0;
    --win1盅掉在庄家头上
    elseif bankerWiLostType == 2 then
        coroutine.wait(1.0);
        GameSHHZSetting.PlaySound("Laugh1");
        coroutine.wait(1.6);
        GameSHHZSetting.PlaySound("du");
        theFatAni = 1;
    --win2大笑
    elseif bankerWiLostType == 3 then
        coroutine.wait(1.0);
        GameSHHZSetting.PlaySound("Laugh");
        theFatAni = 1;
    end

    -- 胖子动作设置
    theFat1Ani:SetInteger("ResultType", theFatAni);
    theFat2Ani:SetInteger("ResultType", theFatAni);
    -- 胖子播放动画
    theFat1Ani:SetTrigger("PlayResultType");
    theFat2Ani:SetTrigger("PlayResultType");
    -- 胖子声音
    if theFatAni == 0 then
        GameSHHZSetting.PlaySound("thefat1lost");
        GameSHHZSetting.PlaySound("thefat2lost");
    else
        GameSHHZSetting.PlaySound("thefat1win");
        GameSHHZSetting.PlaySound("thefat2win");
    end


    coroutine.wait(1.0);
    --隐藏开盅特效
    openPs:SetActive(false);
    --显示桌子特效
    GameSHHZScene.ShowDeskPs(dice1Num, dice2Num);
    GameSHHZSetting.PlaySound("Shansuo");

    coroutine.wait(1.5);
    diceCamera:SetActive(false);
    -- 结算界面
    GameSHHZUI.ShowSettlement(dice1Num, dice2Num);

    coroutine.wait(2.0);
    GameSHHZScene.HideSelectPs();
end
