PanelType = {
    MainPanel = 1,
    FreedomPanel =2,
    ChallengePanel = 3,
    PracticalityPanel =4,
}

local transform
local gameObject

HomePanel = {}
local self = HomePanel

function HomePanel.Awake(obj)
    gameObject = obj
    transform = obj.transform

    self.openPanel = PanelType.MainPanel
end 
function HomePanel.Start()
    self.btnList = {}
    self.isAnimating = false
    self.init()
    coroutine.start(self.show)
    self.ChallengedList = {} 
    self.ParcticalList = {}

    self.InitPractical()
    self.InitChallenge()
end 
function HomePanel.OnDestroy()
end 
function HomePanel.OnEnable()
end 
function HomePanel.OnDisable()
    self.btnList = {}
    self.isAnimating = false
    MainCtrl.Clear()
end 
function HomePanel.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
    --self.effectPanel = transform:FindChild("effectPanel").gameObject 
    --self.effectPanel:SetActive(false)

    self.headBtn = transform:FindChild("TopMenu/TopPanel/headBack").gameObject --个人信息按钮
    self.headicon = self.headBtn.transform:FindChild("head").gameObject --头像图片
    self.namelabel = self.headBtn.transform:FindChild("name").gameObject
    if Avatar.getAvatarSex() == 1 then  --初始化头像
        Avatar.avatarIcon = "nan_1"        
    elseif Avatar.getAvatarSex() == 2 then
        Avatar.avatarIcon = "nv_1"
    end
    self.headicon:GetComponent("UISprite").spriteName = Avatar.getAvatarIcon()
       --名字label
    if Avatar.avatarName ~= "" then
        self.namelabel:GetComponent("UILabel").text = Avatar.getAvatarName()--初始化名字
    end

    self.ischangeScene = false --解决重复点击切换场景黑屏的bug
    self.startbtn = transform:FindChild("BottomMenu/BottomPanel/StartBtn").gameObject;
	--self.startbtn = GameObject.Find("StartBtn");
	--self.bankbtn = GameObject.Find("BankBtn");
    self.bankbtn = transform:FindChild("BottomMenu/BottomPanel/BankBtn").gameObject;
    --self.emailbtn = GameObject.Find("EmailBtn");
    self.emailbtn = transform:FindChild("TopMenu/TopPanel/EmailBtn").gameObject;
    --self.explainbtn = GameObject.Find("ExplainBtn");
    self.explainbtn = transform:FindChild("BottomMenu/BottomPanel/ExplainBtn").gameObject;
    --self.rankbtn = GameObject.Find("RankBtn");
    self.rankbtn = transform:FindChild("BottomMenu/BottomPanel/RankBtn").gameObject;
    --self.taskbtn = GameObject.Find("TaskBtn");
    self.taskbtn = transform:FindChild("BottomMenu/BottomPanel/TaskBtn").gameObject;
    --self.setbtn = GameObject.Find("SetBtn");
    self.setbtn = transform:FindChild("TopMenu/TopPanel/SetBtn").gameObject;
    --self.paybtn = GameObject.Find("PayBtn").gameObject; --底部的充值按钮
    self.paybtn = transform:FindChild("BottomMenu/BottomPanel/PayBtn").gameObject;
    --self.adddiamondbtn = GameObject.Find("adddiamondBtn").gameObject; --上部的充值按钮

    self.shopBtn = transform:FindChild("BottomMenu/BottomPanel/ClothRoomBtn").gameObject;
    self.noticeBtn = transform:FindChild("TopMenu/TopPanel/Notice").gameObject;
    self.recordBtn = transform:FindChild("BottomMenu/BottomPanel/RecordBtn").gameObject
    self.adddiamondbtn = transform:FindChild("TopMenu/TopPanel/adddiamondBtn").gameObject;
    --self.addgoldbtn = GameObject.Find("addgoldBtn").gameObject; --上部的充值按钮
    self.addgoldbtn = transform:FindChild("TopMenu/TopPanel/addgoldBtn").gameObject;

    self.moneyPanel = transform:FindChild("MoneyPanel").gameObject

    table.insert(self.btnList,self.bankbtn)
    table.insert(self.btnList,self.emailbtn)
    table.insert(self.btnList,self.explainbtn)
    table.insert(self.btnList,self.rankbtn)
    table.insert(self.btnList,self.taskbtn)
    table.insert(self.btnList,self.setbtn)

    self.behaviour:AddClick(self.bankbtn,self.BankCallBack)  --银行卡
    self.behaviour:AddClick(self.emailbtn, self.EmailCallBack)  --邮件
    self.behaviour:AddClick(self.explainbtn, self.ExplainCallBack)  --说明
    self.behaviour:AddClick(self.rankbtn, self.RankCallBack)    --排行榜
    self.behaviour:AddClick(self.taskbtn, self.TaskCallBack)    --任务
    self.behaviour:AddClick(self.setbtn, self.SetCallBack)  --设置
    self.behaviour:AddClick(self.headBtn,self.personInfoCallBack)--个人信息
    self.behaviour:AddClick(self.shopBtn,self.ShopCallBack) -- 商场
    self.behaviour:AddClick(self.noticeBtn,self.NoticeCallBack)--公告
    self.behaviour:AddClick(self.recordBtn,self.RecordCallBack)--游戏记录

    

    self.bottomBg = transform:FindChild("BottomMenu/BottomPanel/BottomBg").gameObject

    self.freedPanel = transform:FindChild("Freedom").gameObject 
    self.selectPanel = transform:FindChild("SelectMenu").gameObject
    self.bottomMenu = transform:FindChild("BottomMenu").gameObject;
    --[[
    self.selectPanel.transform.localPosition = Vector3.New(0, -40, 0);
    self.topPanel = transform:FindChild("TopMenu/TopPanel").gameObject
    self.topPanel.transform.localPosition = Vector3.New(0, 120, 0);
    self.bottomPanel = transform:FindChild("BottomMenu/BottomPanel").gameObject
    self.bottomPanel.transform.localPosition = Vector3.New(0, -120, 0);  -- 0,-285,0    
    ]]
    --local paybtn = transform:FindChild("BottomMenu/BottomPanel/PayBtn").gameObject
    self.behaviour:AddClick(self.paybtn, self.PayCallBack)--注册充值按钮监听事件
    self.behaviour:AddClick(self.adddiamondbtn, self.PayCallBack)
    self.behaviour:AddClick(self.addgoldbtn, self.PayCallBack)

    self.confirmPanel =  transform:FindChild("ConfirmPanel").gameObject 
    self.confirmBack = transform:FindChild("ConfirmPanel/Goback").gameObject 
    self.confirmSignUp = transform:FindChild("ConfirmPanel/Normal/SignupBtn").gameObject
    self.ConfirmNormalPanel = transform:FindChild("ConfirmPanel/Normal").gameObject
    self.ConfirmRewardRankPanel = transform:FindChild("ConfirmPanel/RewardRank").gameObject
    self.confirmPanel:SetActive(false)

    self.challenge = transform:FindChild("Challenge").gameObject 
    self.challengeScroll = transform:FindChild("Challenge/background/ScrollView").gameObject 
    self.changengeGrid = transform:FindChild("Challenge/background/ScrollView/Grid"):GetComponent("UIGrid");
    self.challengeBtns = {}
    self.challengeBtns[1] = transform:FindChild("Challenge/background/Menu/Menu1").gameObject 
    self.challengeBtns[2] = transform:FindChild("Challenge/background/Menu/Menu2").gameObject
    self.challengeBtns[3] = transform:FindChild("Challenge/background/Menu/Menu3").gameObject
    self.challengeMenuBg = {}
    self.challengeMenuBg[1] = transform:FindChild("Challenge/background/Menu/menubg1").gameObject 
    self.challengeMenuBg[2] = transform:FindChild("Challenge/background/Menu/menubg2").gameObject
    self.challengeMenuBg[3] = transform:FindChild("Challenge/background/Menu/menubg3").gameObject

    self.practicality = transform:FindChild("Practicality").gameObject 
    self.practicalityScroll = transform:FindChild("Practicality/background/ScrollView").gameObject 
    self.practicalityGrid = transform:FindChild("Practicality/background/ScrollView/Grid"):GetComponent("UIGrid");
    self.practicalityBtns = {}
    self.practicalityBtns[1] = transform:FindChild("Practicality/background/Menu/PraFreeBtn").gameObject
    self.practicalityBtns[2] = transform:FindChild("Practicality/background/Menu/AwardsBtn").gameObject
    self.practicalityBtns[3] = transform:FindChild("Practicality/background/Menu/RegalBtn").gameObject
    self.practicalityMenuBg={}
    self.practicalityMenuBg[1] = transform:FindChild("Practicality/background/Menu/PraFreebg").gameObject
    self.practicalityMenuBg[2] = transform:FindChild("Practicality/background/Menu/Awardsbg").gameObject
    self.practicalityMenuBg[3] = transform:FindChild("Practicality/background/Menu/Regalbg").gameObject

    self.selectList = {}
    self.selectList[1] = transform:FindChild("SelectMenu/Select1bg/Select1").gameObject
    self.selectList[2] = transform:FindChild("SelectMenu/Select2bg/Select2").gameObject
    self.selectList[3] = transform:FindChild("SelectMenu/Select3bg/Select3").gameObject

    self.freedList ={}
    self.freedList[1] = transform:FindChild("Freedom/FreedItem1/joinin1").gameObject 
    self.freedList[2] = transform:FindChild("Freedom/FreedItem2/joinin2").gameObject
    self.freedList[3] = transform:FindChild("Freedom/FreedItem3/joinin3").gameObject
    self.goback = transform:FindChild("TopMenu/TopPanel/GoBack").gameObject

    self.behaviour:AddClick(self.startbtn,self.StartCallBack)  --快速开始



    self.behaviour:AddClick(self.selectList[1],self.PracticalityCallBack)  --实物赛
    self.behaviour:AddClick(self.selectList[2],self.ChallengeCallBack)  --挑战赛
    self.behaviour:AddClick(self.selectList[3],self.FredomCallBack)  --自由赛

    self.behaviour:AddClick(self.freedList[1],self.FreedBeginner)  --初级点击回调
    self.behaviour:AddClick(self.freedList[2],self.FreedIntermediate)  --中级点击回调
    self.behaviour:AddClick(self.freedList[3],self.FreedAdvanced)  --高级点击回调
    self.behaviour:AddHover(self.freedList[1],self.FreedBeginnerHover,self.FreedBeginnerHoverOUT)  --按钮hover回调与hover外回调
    self.behaviour:AddHover(self.freedList[2],self.FreedIntermediateHover,self.FreedIntermediateHoverOUT)  
    self.behaviour:AddHover(self.freedList[3],self.FreedAdvancedHover,self.FreedAdvancedHoverOUT)  


    self.behaviour:AddClick(self.challengeBtns[1],self.ChallengeFree)  
    self.behaviour:AddClick(self.challengeBtns[2],self.ChallengeActivity) 
    self.behaviour:AddClick(self.challengeBtns[3],self.ChallengeTrophy)

    self.behaviour:AddClick(self.practicalityBtns[1],self.PracticalFree)  
    self.behaviour:AddClick(self.practicalityBtns[2],self.PracticalAwards) 
    self.behaviour:AddClick(self.practicalityBtns[3],self.PracticalRegal)

    self.behaviour:AddClick(self.goback, self.GobackCallBack)  --返回

    self.behaviour:AddClick(self.confirmBack, self.ConfirmBackCallBack)  
    self.behaviour:AddClick(self.confirmSignUp, self.ConfirmSignUpCallBack) 

    --创建界面的特效    
    --coroutine.start(self.homeparticle)


    --金币
    self.gold = transform:FindChild("TopMenu/TopPanel/goldBg/gold/Label"):GetComponent("UILabel");
    self.goldPanel = transform:FindChild("MoneyPanel/goldBg/gold/Label"):GetComponent("UILabel");
    self.UpdateGold();

    --显示
    --coroutine.start(self.ShowAnim);
end 
function HomePanel.ShowAnim()
    coroutine.wait(0.5);
    transform:FindChild("SelectMenu/lan_ani").gameObject:SetActive(true);
    transform:FindChild("SelectMenu/cheng_ani").gameObject:SetActive(true);
    transform:FindChild("SelectMenu/hong_ani").gameObject:SetActive(true);
end
function HomePanel.homeparticle()
    coroutine.wait(0.1)
    LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","jiemian1", "jiemian1",Vector3.New(1,1,1),Vector3.New(7.3,0,0), false,function(obj)end,nil)
end
function HomePanel.show()
    coroutine.wait(0.1)
    self.girl = transform:FindChild("StandPlayer").gameObject         --站立的3d人物
    if Avatar.avatarSex == 1 then
        self.girl.transform.localPosition = Vector3.New(-800, -90, 0);  -- -358,-26,0
    elseif Avatar.avatarSex == 2 then
        self.girl.transform.localPosition = Vector3.New(-800, -195, 1000);  -- -358,-26,0
    end
    if Avatar.avatarSex == 1 then
        iTween.MoveTo(self.girl, iTween.Hash("position", Vector3.New(-500, -90, 0), "time", 0.6, "islocal", true, "easetype", iTween.EaseType.easeOutBack));
    elseif Avatar.avatarSex == 2 then
        iTween.MoveTo(self.girl, iTween.Hash("position", Vector3.New(-500, -195, 1000), "time", 0.6, "islocal", true, "easetype", iTween.EaseType.easeOutBack));
    end
    --[[
    coroutine.wait(0.5)
    
    iTween.MoveTo(self.selectPanel, iTween.Hash("position", Vector3.New(0,-40,0), "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
    coroutine.wait(0.5)
    iTween.MoveTo(self.topPanel, iTween.Hash("position", Vector3.New(0,0,0), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.linear));
    iTween.MoveTo(self.bottomPanel, iTween.Hash("position", Vector3.New(0,-26,0), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.linear));
    coroutine.wait(0.5)
    self.effectPanel:SetActive(true)
    LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","shangcheng", "shangcheng",Vector3.New(1,1,1),Vector3.New(7.3,0.4,1), false,function(obj)end,nil)
    ]]
end
function HomePanel.hiden(sceneName)
	--[[
    self.effectPanel:SetActive(false)  

    iTween.MoveTo(self.topPanel, iTween.Hash("position", Vector3.New(0, 120, 0), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.linear));
    iTween.MoveTo(self.bottomPanel, iTween.Hash("position", Vector3.New(0, -120, 0), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.linear));
    coroutine.wait(0.2)
    iTween.MoveTo(self.selectPanel, iTween.Hash("position", Vector3.New(0, -40, 0), "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
    iTween.MoveTo(self.freedPanel, iTween.Hash("position", Vector3.New(0, 670, 0), "time", 0.6, "islocal", true, "easetype", iTween.EaseType.linear));
    iTween.MoveTo(self.challenge, iTween.Hash("position", Vector3.New(0, 670, 0), "time", 0.6, "islocal", true, "easetype", iTween.EaseType.linear));
    iTween.MoveTo(self.practicality, iTween.Hash("position", Vector3.New(0, 670, 0), "time", 0.6, "islocal", true, "easetype", iTween.EaseType.linear));
    coroutine.wait(0.2)
    if Avatar.avatarSex == 1 then
        iTween.MoveTo(self.girl, iTween.Hash("position", Vector3.New(-800, -90, 0), "time", 0.6, "islocal", true, "easetype", iTween.EaseType.easeInBack));
    elseif Avatar.avatarSex == 2 then
        iTween.MoveTo(self.girl, iTween.Hash("position", Vector3.New(-800, -195, 530), "time", 0.6, "islocal", true, "easetype", iTween.EaseType.easeInBack));
    end
    coroutine.wait(0.6)
    ]]  
    LoadSceneAsync.LoadSceneAsync(sceneName) 
end 
function HomePanel.InitChallenge()
    
    self.ChallengeSelectIndex = 1
    self.ChangedChallenge(1)
end 
function HomePanel.InitPractical()
    
    self.PracticalSelectIndex = 1
    self.ChangedPractical(1)
end
function HomePanel.ChangedChallenge(roomtype)
    for i =1, #self.challengeBtns do 
        if i == roomtype then --DBCBF5FF  867FB8FF
            self.challengeBtns[i].transform.localScale = Vector3.New(1.1, 1.1, 1.1)
        else 
             self.challengeBtns[i].transform.localScale = Vector3.New(1, 1, 1)
        end 
    end 

    for i =1, #self.challengeMenuBg  do 
        if i == roomtype then 
            self.challengeMenuBg[i]:SetActive(true)
        else 
            self.challengeMenuBg[i]:SetActive(false)
        end 
    end 
    local challengeData = require "GameLRDDZ.config.Challenge"
    local num = 0
    for i=1, #challengeData do 
        local data = challengeData[i]
        if data.RoomType == roomtype  then 
            num = num +1
            if self.ChallengedList[num] == nil then 
                local obj = LRDDZ_ResourceManager.Instance:LoadAsset("ChallengeItem","ChallengeItem","ChallengeItem"..i,false)
                obj.transform.parent = self.changengeGrid.transform;
                obj.transform.localScale = Vector3.one;
                obj.transform:GetComponent("UIDragScrollView").scrollView = self.challengeScroll:GetComponent("UIScrollView");
                local function selected()
                    self.Selected()
                end 
                self.behaviour:AddClick(obj,selected)  
                local praInfo = {}
                praInfo.GameObject = obj 
                self.ChallengedList[num] = praInfo
            end 

            --self.ChallengedList[num].GameObject.transform.localScale = Vector3.one;
            --self.ChallengedList[num].GameObject.transform.localPosition = Vector3.New(0, 235 -num * 125, 0);

            self.ChallengedList[num].GameObject.transform:FindChild("RoomName"):GetComponent("UILabel").text = data.RoomName;
            if data.LimitNum == nil then data.LimitNum = 0 end 
            self.ChallengedList[num].GameObject.transform:FindChild("LimitNum"):GetComponent("UILabel").text = tostring(data.LimitNum);
            if data.Time == nil then data.Time = 0 end 
            self.ChallengedList[num].GameObject.transform:FindChild("Time"):GetComponent("UILabel").text = tostring(data.Time)
            if data.Total == nil then data.Total = 0 end 
            self.ChallengedList[num].GameObject.transform:FindChild("Total"):GetComponent("UILabel").text = tostring(data.Total).."金币";
        end 
        self.changengeGrid.repositionNow = true;
    end 
end 

function HomePanel.ChallengeFree()
    if self.ChallengeSelectIndex ~= 1 then 
        self.ChangedChallenge(1)
        self.ChallengeSelectIndex = 1
    end 
end 

function HomePanel.ChallengeActivity()
    if self.ChallengeSelectIndex ~= 2 then 
        self.ChangedChallenge(2)
        self.ChallengeSelectIndex = 2
    end 
end
function HomePanel.ChallengeTrophy()
    if self.ChallengeSelectIndex ~= 3 then 
        self.ChangedChallenge(3)
        self.ChallengeSelectIndex = 3
    end 
end

function  HomePanel.ChangedPractical(roomtype)
    local practicalData = require "GameLRDDZ.config.Practicality"
    local num = 0
    for i =1, #practicalData do 
        local data = practicalData[i]
        if data.RoomType == roomtype then 
            num = num +1
            local x = (num - 1) %2
            local y = math.floor((num - 1)/2)
            if self.ParcticalList[num] == nil then 
                local obj = LRDDZ_ResourceManager.Instance:LoadAsset("PracticalityItem","PracticalityItem","PracticalityItem"..i,false)
                obj.transform.parent = self.practicalityGrid.transform;
                obj.transform.localScale = Vector3.one;
                local function selected()
                    self.Selected()
                end 
                self.behaviour:AddClick(obj,selected)  
                local praInfo = {}
                praInfo.GameObject = obj 
                self.ParcticalList[num] = praInfo
            end 
            --self.ParcticalList[num].GameObject.transform.localScale = Vector3.one
            --self.ParcticalList[num].GameObject.transform.localPosition = Vector3.New(192, 235 -num * 125, 0);
            if data.RoomName == nil then data.RoomName = "" end 
            self.ParcticalList[num].GameObject.transform:FindChild("RoomName"):GetComponent("UILabel").text = data.RoomName;
            if data.LimitNum == nil then data.LimitNum = 0 end 
            self.ParcticalList[num].GameObject.transform:FindChild("limitNum"):GetComponent("UILabel").text = tostring(data.LimitNum);
            if data.Cost == nil then data.Cost = 0 end 
            self.ParcticalList[num].GameObject.transform:FindChild("cost"):GetComponent("UILabel").text = data.Cost.."金币";
            if data.Time == nil then data.Time = "" end 
            self.ParcticalList[num].GameObject.transform:FindChild("time"):GetComponent("UILabel").text = tostring(data.Time)
            self.ParcticalList[num].GameObject.transform:FindChild("Tex"):GetComponent("UISprite").spriteName = data.GiftTex            
        end 
    end 
    self.practicalityGrid.repositionNow = true;
end

function HomePanel.PracticalFree()
    if self.PracticalSelectIndex ~= 1 then 
        self.ChangedPractical(1)
        self.PracticalSelectIndex = 1
        self.practicalityMenuBg[1]:SetActive(true)
        self.practicalityMenuBg[2]:SetActive(false)
        self.practicalityMenuBg[3]:SetActive(false)
        self.practicality.transform:FindChild("background/Menu/PraFreeBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_da_hei"
        self.practicality.transform:FindChild("background/Menu/AwardsBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_hui_da"
        self.practicality.transform:FindChild("background/Menu/RegalBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_hui_da"
    end 
end 

function HomePanel.PracticalAwards()
    if self.PracticalSelectIndex ~= 2 then 
        self.ChangedPractical(2)
        self.PracticalSelectIndex = 2
        self.practicalityMenuBg[2]:SetActive(true)
        self.practicalityMenuBg[1]:SetActive(false)
        self.practicalityMenuBg[3]:SetActive(false)
        self.practicality.transform:FindChild("background/Menu/PraFreeBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_hui_da"
        self.practicality.transform:FindChild("background/Menu/AwardsBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_da_hei"
        self.practicality.transform:FindChild("background/Menu/RegalBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_hui_da"
    end 
end
function HomePanel.PracticalRegal()
    if self.PracticalSelectIndex ~= 3 then 
        self.ChangedPractical(3)
        self.PracticalSelectIndex = 3
        self.practicalityMenuBg[3]:SetActive(true)
        self.practicalityMenuBg[1]:SetActive(false)
        self.practicalityMenuBg[2]:SetActive(false)
        self.practicality.transform:FindChild("background/Menu/PraFreeBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_hui_da"
        self.practicality.transform:FindChild("background/Menu/AwardsBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_hui_da"
        self.practicality.transform:FindChild("background/Menu/RegalBtn/sellight"):GetComponent("UISprite").spriteName = "yeqian_da_hei"
    end 
end

function HomePanel.StartCallBack()
 	coroutine.start(self.hiden,SceneName.Game)
  end
function HomePanel.FreedBeginnerHover()
    --transform:FindChild("Freedom/deng/lvdeng"):GetComponent('Animator').speed = 2
end
function HomePanel.FreedBeginnerHoverOUT()
    --transform:FindChild("Freedom/deng/lvdeng"):GetComponent('Animator').speed = 1
end
function HomePanel.FreedIntermediateHover()
    --transform:FindChild("Freedom/deng/hongdeng"):GetComponent('Animator').speed = 2
end
function HomePanel.FreedIntermediateHoverOUT()
    --transform:FindChild("Freedom/deng/hongdeng"):GetComponent('Animator').speed = 1
end
function HomePanel.FreedAdvancedHover()
    --transform:FindChild("Freedom/deng/huangdeng"):GetComponent('Animator').speed = 2
end
function HomePanel.FreedAdvancedHoverOUT()
    --transform:FindChild("Freedom/deng/huangdeng"):GetComponent('Animator').speed = 1
end
function HomePanel.FreedBeginner()
    if self.ischangeScene == true then
        return
    end
    MyCommon.SceneId = 1
    coroutine.start(self.hiden,SceneName.Desk)
    self.ischangeScene = true
end 
function HomePanel.FreedIntermediate()
    if self.ischangeScene == true then
        return
    end
    MyCommon.SceneId = 2
    coroutine.start(self.hiden,SceneName.Desk)
    self.ischangeScene = true
end
function HomePanel.FreedAdvanced()
    if self.ischangeScene == true then
        return
    end
    MyCommon.SceneId = 3
    coroutine.start(self.hiden,SceneName.Desk)
    self.ischangeScene = true
end 
 function  HomePanel.GobackCallBack()
    if self.openPanel == PanelType.FreedomPanel then 
        coroutine.start(self.GoBack,self.freedPanel); 
        self.openPanel = PanelType.MainPanel
        coroutine.start(self.OpenSelectBtnAnimation,false);
    elseif self.openPanel == PanelType.ChallengePanel then 
        coroutine.start(self.GoBack, self.challenge); 
        self.openPanel = PanelType.MainPanel
        coroutine.start(self.OpenSelectBtnAnimation,false);
    elseif self.openPanel == PanelType.PracticalityPanel then 
        coroutine.start(self.GoBack,self.practicality); 
        self.openPanel = PanelType.MainPanel
        coroutine.start(self.OpenSelectBtnAnimation,false);
    else 
        local function okFunc(obj)
            coroutine.start(self.hiden,SceneName.Login)
        end 
        local function cancelFunc(obj)
        end 
        MyCommon.CreatePrompt(GameText.GoLoginPanel,okFunc,cancelFunc)
    end
end 
function  HomePanel.GoBack(panel)
    --self.effectPanel:SetActive(true)
    iTween.MoveTo(panel, iTween.Hash("y", 1024, "time", 0.4, "islocal", true, "easetype", iTween.EaseType.linear));
    coroutine.wait(0.4)
    --[[
    iTween.MoveTo(self.selectPanel, iTween.Hash("x", 0, "time", 0.4, "islocal", true, "easetype", iTween.EaseType.linear));
    iTween.MoveTo(self.bottomPanel, iTween.Hash("position", Vector3.New(0,-23, 0), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.linear));
    ]]
end 
function  HomePanel.FredomCallBack()

	coroutine.start(LoadRoom);


    log("自由赛点击")
    self.openPanel = PanelType.FreedomPanel
    coroutine.start(self.ShowSelected,self.freedPanel);  
    coroutine.start(self.OpenSelectBtnAnimation,true);
end 
function LoadRoom(  )
	local rand = math.random()*100000;
	local  url = ConnectDefine.ROOM_LIST_URL .. PlatformGameDefine.game.GameID .. "/?room_type=" .. PlatformGameDefine.game.GameTypeIDs .. "&minv=20000&maxv=39999&"..rand;
	local www = HttpConnect.Instance:HttpRequest(url, null);
	coroutine.www(www);	
	local result = HttpConnect.Instance:RoomListResult(www);
end
function LoadRoomBySocket()
	
end

--实物赛
function HomePanel.PracticalityCallBack()
    log("食物赛点击")
    self.openPanel = PanelType.PracticalityPanel
    coroutine.start(self.ShowSelected,self.practicality);
    self.InitPractical()
    coroutine.start(self.OpenSelectBtnAnimation,true);
end 

--挑战赛
function HomePanel.ChallengeCallBack()
    log("挑战赛点击")
    self.openPanel = PanelType.ChallengePanel
    coroutine.start(self.ShowSelected,self.challenge);
    self.InitChallenge()
    coroutine.start(self.OpenSelectBtnAnimation,true);
end 
function self.OpenSelectBtnAnimation(isopen)
	if isopen == false then coroutine.wait(0.5); end
	self.selectPanel:SetActive(not isopen);
	self.bottomMenu:SetActive(not isopen);
	self.girl:SetActive(not isopen);
end
function HomePanel.ShowSelected(panel)
    --self.effectPanel:SetActive(false)
    --iTween.MoveTo(self.bottomPanel, iTween.Hash("position", Vector3.New(0, -120, 0), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.linear));
    --iTween.MoveTo(self.selectPanel, iTween.Hash("x", 0, "time", 0.4, "islocal", true, "easetype", iTween.EaseType.linear));
    
    if panel == PanelType.PracticalityPanel then   
        self.challenge.transform.localPosition = Vector3.New(0,670,0)
        self.freedPanel.transform.localPosition = Vector3.New(0,670,0)
        --iTween.MoveTo(self.challenge, iTween.Hash("y", 670, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
        --iTween.MoveTo(self.freedPanel, iTween.Hash("y", 670, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
    elseif panel == PanelType.ChallengePanel then
        self.practicality.transform.localPosition = Vector3.New(0,670,0)
        self.freedPanel.transform.localPosition = Vector3.New(0,670,0)
        --iTween.MoveTo(self.practicality, iTween.Hash("y", 670, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
        --iTween.MoveTo(self.freedPanel, iTween.Hash("y", 670, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
    elseif panel == PanelType.FreedomPanel then
        self.practicality.transform.localPosition = Vector3.New(0,670,0)
        self.challenge.transform.localPosition = Vector3.New(0,670,0)
        --iTween.MoveTo(self.practicality, iTween.Hash("y", 670, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
        --iTween.MoveTo(self.challenge, iTween.Hash("y", 670, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
    end  
    coroutine.wait(0.4)
    iTween.MoveTo(panel, iTween.Hash("y", -50, "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear)); 
end 


function HomePanel.Selected()
    self.confirmPanel:SetActive(true)
    self.confirmPanel.transform.localPosition = Vector3.New(0,0,0)
end 


function HomePanel.ConfirmBackCallBack()
    self.confirmPanel:SetActive(false)
end 

function HomePanel.ConfirmSignUpCallBack()
     if self.ischangeScene == true then
        return
    end
    MyCommon.SceneId = 1
    coroutine.start(self.hiden,SceneName.Game)
    self.confirmPanel:SetActive(false)
    self.ischangeScene = true
end  
 function HomePanel.personInfoCallBack()
    MainCtrl.OpenpersonInfoPanel()
    self.moneyPanel:SetActive(true);

 end
 function HomePanel.ShopCallBack(  )
 	MainCtrl.OpenShopPanel();
 	self.moneyPanel:SetActive(true);
 end
 function HomePanel.NoticeCallBack(  )
 	MainCtrl.OpenNoticePanel();
 	self.moneyPanel:SetActive(true);
 end
 function HomePanel.RecordCallBack()
 	MainCtrl.OpenRecordPanel();
 	self.moneyPanel:SetActive(true);
 end
function HomePanel.PayCallBack()
    --MessageManger.ShowMessage("该功能暂时未开放！")
    MainCtrl.OpenPayPanel()
    self.moneyPanel:SetActive(true);
end 

function HomePanel.BankCallBack()
     MainCtrl.OpenBankPanel()
     self.moneyPanel:SetActive(true);
end 

function HomePanel.EmailCallBack()
    MainCtrl.OpenEmailPanel()
    self.moneyPanel:SetActive(true);
end 

function HomePanel.ExplainCallBack()
   -- MessageManger.ShowMessage("该功能暂时未开放！")
    MainCtrl.OpenExplainPanel()
    self.moneyPanel:SetActive(true);
end 

function HomePanel.RankCallBack()
    MainCtrl.OpenRankPanel()
    self.moneyPanel:SetActive(true);
end 

function HomePanel.TaskCallBack()
    MainCtrl.OpenTaskPanel()
    self.moneyPanel:SetActive(true);
end
function HomePanel.SetCallBack()
    MainCtrl.OpenSettingPanel()
    self.moneyPanel:SetActive(true);
end
function HomePanel.UpdateGold()
    self.gold.text = EginUser.Instance.bagMoney;
    self.goldPanel.text = EginUser.Instance.bagMoney;
end
