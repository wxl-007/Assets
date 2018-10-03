require "HappyCity/Games/GameEntityNNTB"	
require "HappyCity/Games/GameEntityNNSR"	
require "HappyCity/Games/GameEntityNNBR"	
require "HappyCity/Games/GameEntityNNDZ"	
require "HappyCity/Games/GameEntityFTWZ"	
require "HappyCity/Games/GameEntityFTWZBS"	
require "HappyCity/Games/GameEntitySRFTWZ"	
require "HappyCity/Games/GameEntityHPLZ"	
require "HappyCity/Games/GameEntityBBDZ"	
require "HappyCity/Games/GameEntityBRLZ"	
require "HappyCity/Games/GameEntityTBWZ"	
require "HappyCity/Games/GameEntityNNKP"	
require "HappyCity/Games/GameEntityXJ"	
require "HappyCity/Games/GameEntityNNJQ"	
require "HappyCity/Games/GameEntity30M"	
require "HappyCity/Games/GameEntitySRPS"	
require "HappyCity/Games/GameEntityYSZ"	
require "HappyCity/Games/GameEntityDZPK"	
require "HappyCity/Games/GameEntityDDZ"	
require "HappyCity/Games/GameEntityDDZBS"	
require "HappyCity/Games/GameEntityDDZBS2"	
require "HappyCity/Games/GameEntityDDZBS3"	
require "HappyCity/Games/GameEntityBANK"	
require "HappyCity/Games/GameEntity20DN"	
require "HappyCity/Games/GameEntityKSQZMJ"	
require "HappyCity/Games/GameEntityFARM"	
require "HappyCity/Games/GameEntityDDZ131BS"	
require "HappyCity/Games/GameEntityDDZ131BS2"	
require "HappyCity/Games/GameEntityDDZLive"	
require "HappyCity/Games/GameEntityCJFKBY"	
require "HappyCity/Games/GameEntityTBSZ"	
require "HappyCity/Games/GameEntityTBDSZ"	
require "HappyCity/Games/GameEntityPPC"	
require "HappyCity/Games/GameEntityHPSK"	
require "HappyCity/Games/GameEntityQBSK"	
require "HappyCity/Games/GameEntitySHHZ"	
require "HappyCity/Games/GameEntityFKTBDN"	
require "HappyCity/Games/GameEntityKSQZMJ"	
require "HappyCity/Games/GameEntityDHSZ"	
require "HappyCity/Games/GameEntityLRDDZ"	
require "HappyCity/Games/GameEntityDDZ131HPY"	
require "HappyCity/Games/GameEntityCHESS"	
require "HappyCity/Games/GameEntityDDZ131CJF"	
	
local this = LuaObject:New()	
Hall = this	
--捕鱼打包 icon列表	
local fish_package_icon_list = {"Button_Game_FKBY","Button_Game_TBNN","Button_Game_SRNN","Button_Game_JQNN","Button_Game_30M","Button_Game_BRLZ","Button_Game_BBDZ"};	
--单个包打包 icon 列表	
local singleGame_package_icon_list = {"Button_Game_DZNN"};	
--隐藏某些 icon	
local inactive_package_icon_list = {"Button_Game_SHHZ"};	
 	
--131平台的游戏设置:键值为unity编辑器中的icon名字 false为隐藏,true为显示	
local package131_icon_list = {["Button_Game_SRPS"] = false,	
                                ["Button_Game_SRFTWZ"] = false,	
                                ["Button_Game_DDZ131BS"] = false,	
                                ["Button_Game_DDZ131BS2"] = false,	
                                ["Button_Game_DDZ131HPY"] = false,	
                                ["Button_Game_FKBY"] = false,	
                                ["Button_Game_FTWZ"] = false,	
                                ["Button_Game_FTWZBS"] = false, 	
                                ["Button_Game_DDZBS"] = false};	
--597平台的游戏设置 :键值为unity编辑器中的icon名字 false为隐藏,true为显示	
local package597_icon_list = {["Button_Game_DDZ131BS"] = false,	
                                ["Button_Game_DDZ131BS2"] = false,	
                                ["Button_Game_DDZ131HPY"] = false,	
                                ["Button_Game_DDZ131CJF"] = false,	
                                ["Button_Game_DDZBS"] = true};	
	
local PlatformGameDefine = PlatformGameDefine	
	
local nickname;	
local vGames;	
local _GameModuleDownloadParentTransMap = {};	
local enableLiveRoom = 0; --开启/关闭 现场版斗地主入口。 0=关闭,other=开启	
local hasPopupUpdate = 0;	
local dailyBonusCallBack = 0;	
local waitSeconds = 0;	
local hasPopup131AD = 0;	
local preItemTemp = nil;	
local msgObjY = 0;	
local ShowSign = 0;
this.isInMainScreen = true;
this.BGMusic = true
Hall.FirstEnter = true;	
	
--使用点击的按钮的名字作为游戏需要下载模块列表的索引	
local GameModuleReference_list = {	
	Button_Game_20DN = {HallConsts.GameModule_20DN,},	
	Button_Game_30M = {HallConsts.GameModule_30M,},	
	Button_Game_BBDZ = {HallConsts.GameModule_BBDZ,},	
	Button_Game_BRLZ = {HallConsts.GameModule_BRLZ,},	
	Button_Game_DDZ = {HallConsts.GameModule_DDZ,HallConsts.ExpressionPackage,},	
	Button_Game_DZNN = {HallConsts.GameModule_DZNN,},	
	Button_Game_DZPK = {HallConsts.GameModule_DZPK,HallConsts.ExpressionPackage,},	
	Button_Game_FKTBDN = {HallConsts.GameModule_FKTBDN,},	
	Button_Game_FTWZ = {HallConsts.GameModule_FTWZ,HallConsts.ExpressionPackage,},	
	Button_Game_FTWZBS = {HallConsts.GameModule_FTWZ,HallConsts.GameModule_FTWZBS},	
    Button_Game_SRFTWZ = {HallConsts.GameModule_SRFTWZ,HallConsts.ExpressionPackage,},	
	Button_Game_HPLZ = {HallConsts.GameModule_HPLZ,},	
	Button_Game_JQNN = {HallConsts.GameModule_JQNN,}, 	
	Button_Game_KPNN = {HallConsts.GameModule_KPNN,}, 	
	Button_Game_KSQZMJ = {HallConsts.GameModule_KSQZMJ,HallConsts.ExpressionPackage,}, 	
	Button_Game_LRDDZ = {HallConsts.GameModule_LRDDZ,}, 	
	Button_Game_MXNN = {HallConsts.GameModule_MXNN,HallConsts.ExpressionPackage,}, 	
	Button_Game_SRNN = {HallConsts.GameModule_SRNN,},	
	Button_Game_SRPS = {HallConsts.GameModule_SRPS,HallConsts.ExpressionPackage,}, 	
	Button_Game_TBDSZ = {HallConsts.GameModule_TBDSZ,}, 	
	Button_Game_TBNN = {HallConsts.GameModule_TBNN,},	
	Button_Game_TBSZ = {HallConsts.GameModule_TBSZ,}, 	
	Button_Game_TBWZ = {HallConsts.GameModule_TBWZ,}, 	
	Button_Game_XJ = {HallConsts.GameModule_XJ,},	
	Button_Game_YSZ = {HallConsts.GameModule_YSZ,},	
	 	
	 	
	Button_Game_DDZBS = {HallConsts.GameModule_DDZ,HallConsts.ExpressionPackage,HallConsts.GameModule_DDZC,},	
	Button_Game_DDZBS2 = {HallConsts.GameModule_DDZ,HallConsts.ExpressionPackage,HallConsts.GameModule_DDZC,},	
	Button_Game_DDZBS3 = {HallConsts.GameModule_DDZ,HallConsts.ExpressionPackage,HallConsts.GameModule_DDZC,}, 	
	Button_Game_DDZLive = {HallConsts.GameModule_DDZ,HallConsts.ExpressionPackage,HallConsts.GameModule_DDZC,},	
		
	Button_Game_HPSK = {HallConsts.GameModule_HPSK,HallConsts.ExpressionPackage,},	
    Button_Game_QBSK = {HallConsts.GameModule_QBSK,HallConsts.ExpressionPackage,},	
	Button_Game_FKBY = {HallConsts.GameModule_FKBY,}, 	
	Button_Game_DHSZ = {HallConsts.GameModule_DHSZ,},	
	Button_Game_PPC = {HallConsts.GameModule_PPC,},	
	Button_Game_SHHZ = {HallConsts.GameModule_SHHZ,},	
	Button_Game_CHESS = {HallConsts.GameModule_CHESS},	
    Button_Game_DDZ131CJF = {HallConsts.GameModule_LRDDZ}	
}	
--local socket = require "socket"	
--local timeMs = 0;	
function this:Awake()  	
 --timeMs = socket.gettime();------------------------	
    this:init(); 	
	--print("~~~~~used time1: "..(socket.gettime()-timeMs).."ms")	
	--timeMs = socket.gettime();	

    this:FindButton("Button_Game_TBNN")	
    this:FindButton("Button_Game_SRNN")	
    this:FindButton("Button_Game_MXNN")	
    this:FindButton("Button_Game_DZNN")	
    this:FindButton("Button_Game_JQNN")	
	this:FindButton("Button_Game_FTWZ")	
	this:FindButton("Button_Game_FTWZBS")	
    this:FindButton("Button_Game_SRFTWZ")	
	this:FindButton("Button_Game_HPLZ")	
	this:FindButton("Button_Game_30M")	
	this:FindButton("Button_Game_BRLZ")	
	this:FindButton("Button_Game_XJ")	
	this:FindButton("Button_Game_KPNN")	
	this:FindButton("Button_Game_BBDZ")	
	this:FindButton("Button_Game_TBWZ")		
	this:FindButton("Button_Game_YSZ")	
	this:FindButton("Button_Game_SRPS")	
	this:FindButton("Button_Game_DZPK")	
    this:FindButton("Button_Game_DDZ")	
    this:FindButton("Button_Game_DDZBS")	
    this:FindButton("Button_Game_DDZBS2")	
    this:FindButton("Button_Game_DDZBS3")	
	this:FindButton("Button_Game_20DN")	
    this:FindButton("Button_Game_DDZ131BS")	
    this:FindButton("Button_Game_DDZ131BS2")	
    this:FindButton("Button_Game_DDZLive")	
	this:FindButton("Button_Game_FKBY")	
    this:FindButton("Button_Game_TBSZ")	
	this:FindButton("Button_Game_TBDSZ")	
	this:FindButton("Button_Game_PPC")	
    this:FindButton("Button_Game_HPSK")	
    this:FindButton("Button_Game_QBSK")	
    this:FindButton("Button_Game_SHHZ")	
	this:FindButton("Button_Game_FKTBDN")	
	this:FindButton("Button_Game_KSQZMJ")	
	this:FindButton("Button_Game_DHSZ")	
    this:FindButton("Button_Game_LRDDZ") 	
    this:FindButton("Button_Game_DDZ131HPY")	
    this:FindButton("Button_Game_CHESS")	
    this:FindButton("Button_Game_DDZ131CJF")	
end	
 	
function this:Start() 	
    this.isInMainScreen = true;
	if(Utils._IsSingleGame) then	
			Utils.LoadLevelGUI("Hall_SingleGame") 	
			return;	
	end;	
	
	local sceneRoot = this.transform.root:GetComponent("UIRoot")	
	if sceneRoot then 	
		sceneRoot.manualHeight = 1920;	
		sceneRoot.manualWidth = 1080;	
	end	
	 	
	if(PlatformGameDefine.playform.IsSocketLobby) then	
	   this.mono:StartSocket(false);	
	   EginUserUpdate.Instance:UpdateInfoNow();	
	   Utils.initSocket();	
	end 	
		
	this:RefreshUserInfo()	


	--[[ lxtd004 20170328 V	
		local kVipIconPrefab = ResManager:LoadAsset("HappyCity/Hall","Hall_VipIcon");	
		local kVipIconContent = this.transform:FindChild("Info/LevelInfo/VipLevel");	
		for i=0,EginUser.Instance.vipLevel-1 do	
			local vipIcon = GameObject.Instantiate(kVipIconPrefab);	
			vipIcon.transform.parent = kVipIconContent;	
			vipIcon.transform.localPosition = Vector3(400+i*70,0,0);	
			vipIcon.transform.localScale = Vector3(1,1,1);	
		end	
	]] 	
	--[[	
	local menuObjs = this.transform:FindChild("Menu-5").gameObject;	
	local iosMenuObjs = this.transform:FindChild("Menu").gameObject;	
	if (Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer) then	
		if(PlatformGameDefine.playform.IOSPayFlag) then 	
			iosMenuObjs:SetActive(true);	
		else	
			iosMenuObjs:SetActive(true);	
		end	
	else 	
		iosMenuObjs:SetActive(true);	
	end	
	]]	
	if( PlatformGameDefine.playform.IOSPayFlag) then	
		--coroutine.start(this.LoadNotices);	
	end  	
	--Start updateinfo loop.	
	EginUserUpdate.Instance:UpdateInfoStart();	
	--Update client version	
	PlatformGameDefine.game.VersionName = PlatformGameDefine.CLIENT_VERSION;	
		
	vGames = this.transform:FindChild("Play/UIPanel (Clipped View)/UIGrid");	
    -- if(vGames.childCount > 12)then	
    --     vGames.localPosition. =  Vector3(-410,280,0) --Vector3(-410,500,0);	
    --     iTween.MoveTo(vGames.gameObject ,	
    --         iTween.Hash("islocal", true,'y',110, "easetype",iTween.EaseType.easeOutBounce, "time",1.5,"loopType", "none") );	
    --             --"position",Vector3(-410, 110, 0)	
    --     coroutine.start( this.AfterTime);	
    -- end	
	this:CheckDownloadParentTrans();	
	 	
		
	this.Download_Progress_Bar:SetActive(false);	
	this.InstantUpdate_Label:SetActive(Utils.IsDownloadCloudAssetComplete());	
	Utils.InstantUpdateCallback = this;	
	Utils.VersionUpdateCallback = this;	
	ConnectDefine:updateConfig() 	
		
	coroutine.start(this.Send_display_mail_count);
	if ShowSign ==0 then 
		coroutine.start(this.LoadSign); 	
	end
	--[[ lxtd004 20170328 V	
	if( PlatformGameDefine.playform.PlatformName == "game407" or PlatformGameDefine.playform.PlatformName == "game131") then	
		coroutine.start(this.GoToTask); 	
	end 	
    kNoticePrefab = ResManager:LoadAsset("HappyCity/Hall","Hall_Notice"); 	
    --UnityEngine.PlayerPrefs.DeleteKey("lobbyMsgList");	
    if(UnityEngine.PlayerPrefs.HasKey("lobbyMsgList"))then 	
		local localMsg = UnityEngine.PlayerPrefs.GetString("lobbyMsgList");	
        LobbyMsgReceiver.messageBody = cjson.decode(localMsg);	
        preItemTemp = nil;	
        for i=1,#LobbyMsgReceiver.messageBody do	
           this:SetLobbyMsgObj(kNoticePrefab, i-1, LobbyMsgReceiver.messageBody[i]["content"], "");	
        end	
	
        if(msgObjY>300)then	
            local uipanel = this.transform:FindChild("Info/Notice/Notices"):GetComponent("UIScrollView");	
            uipanel:ResetPosition();	
            uipanel:MoveRelative(Vector3.New(0,msgObjY+120-322,0));	
        end	
	end	
	
	LobbyMsgReceiver:StartReadMsg();	
		this:Popup131AD();	
	]]	
	
    --友盟统计插件	
    --this:Umeng();	
    this:autoGetUI()
	this.mono:AddClick(this.ui_AvatarBtn, function()
		 -- Utils.LoadLevelGUI("Module_UpdateAvatar");	
		 this:OpenMenu('Module_UpdateAvatar')
         -- local tModuleObj = this:GetHall_Modules("Module_UpdateAvatar")
         -- HallUtil:ShowPanelAni(tModuleObj)
	end,this)	
end	
	
function this:OnDestroy()	
    log("--------------------ondestroy of HallPanel")	
    if LobbyMsgReceiver ~= nil then 	
     LobbyMsgReceiver:StopReadMsg();	
    end	
    -- this.InvokeLua:CancelInvoke('ActivityAni')
    this:clearLuaValue();	
    Utils.SetInstantUpdateCallbackNull();	
	Utils.SetVersionUpdateCallbackNull()	
end	
	
function this:init()	
	this.module_task = nil;	
	Hall_Modules = {};	
	this.SignInfo = nil	
	-- this.InvokeLua = InvokeLua:New(this);
	nickname = this.transform:FindChild("Info/UserInfo/Name/Lab_Nickname"):GetComponent("UILabel");	
	-- this:UpdateAni()
	EginProgressHUD.Instance:HideHUD()
	--[[	lxtd004 20170328 V	
		
	local addFriendBtn = this.transform:FindChild("Info/UserInfo/Button_addFriend").gameObject;	
	this.mono:AddClick(addFriendBtn, this.OnClickAddFriend);	
    addFriendBtn:SetActive(false);	
	if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then	
		if (not PlatformGameDefine.playform.IOSPayFlag)  then	
			addFriendBtn:SetActive(false);	
		end	
	end	
	local avatarSettingBtn = this.transform:FindChild("Info/UserInfo/Avatar").gameObject;	
	this.mono:AddClick(avatarSettingBtn, this.OnClickMenuUpdateAvatar);	
	local feedbackBtn = this.transform:FindChild("Help/Feedback").gameObject;	
	this.mono:AddClick(feedbackBtn, this.OnClickFeedback);	
	]]	
	local settingBtn = this.transform:FindChild("Info/Help/Setting").gameObject;	
	this.SettingBtns = this.transform:FindChild("Info/Help/SettingBtns").gameObject; 	
	this.mono:AddClick(settingBtn, this.OnClickSetting);
	this.mono:AddClick(this.SettingBtns.transform:FindChild('CloseBtn').gameObject,function ()
		this.SettingBtns:SetActive(false)
	end)	

	for i=1,3 do 
		this.mono:AddClick(this.transform:FindChild('Play/Sprite'..i).gameObject,function ()
			vGames.gameObject:GetComponent('UICenterOnChild'):CenterOn(vGames:FindChild('Page_'..i))
			this.transform:FindChild('Play/Sprite'..i).gameObject:GetComponent('UISprite').spriteName= 'fengedianji'
			for j=1,3 do
				if i ~= j then 
					this.transform:FindChild('Play/Sprite'..j).gameObject:GetComponent('UISprite').spriteName= 'fenge'
				end
			end
		end)
	end
	local tCenter = this.transform:FindChild('Play/UIPanel (Clipped View)/UIGrid'):GetComponent('UICenterOnChild')
	-- tCenter.OnCenterCallback = this:SetPoint()

	local logoutBtn = this.transform:FindChild("Info/Help/SettingBtns/BtnLogout").gameObject;	
	this.mono:AddClick(logoutBtn,function ( )
		this:ChangeIDBtns()
	end);	
	local mailBtn1 = this.transform:FindChild("Mail").gameObject;	
	this.mono:AddClick(mailBtn1, this.OnClickMenuMail);	
	
	local rechargeBtn1 = this.transform:FindChild("Menu/Recharge").gameObject;	
	local rechargeBtn2 = this.transform:FindChild("Info/Recharge").gameObject;	
	this.mono:AddClick(rechargeBtn1, this.OnClickMenuRecharge);	
	this.mono:AddClick(rechargeBtn2, this.OnClickMenuRecharge);	
	
	local msgBtn1 = this.transform:FindChild("Menu/GameRecord").gameObject;	
	this.mono:AddClick(msgBtn1, this.OnClickMenuGameRecord);	
	local bankBtn1 = this.transform:FindChild("Menu/Bank").gameObject;	
	this.mono:AddClick(bankBtn1, this.OnClickMenuBank);	
	local activityBtn1 = this.transform:FindChild("Activity").gameObject; 	
	this.mono:AddClick(activityBtn1, this.OnClickMenuActivity);	
	--local mailBtn2 = this.transform:FindChild("Menu-5/Mail").gameObject;	
	--this.mono:AddClick(mailBtn2, this.OnClickMenuMail);	
	--local msgBtn2 = this.transform:FindChild("Menu-5/GameRecord").gameObject;	
	--this.mono:AddClick(msgBtn2, this.OnClickMenuGameRecord);	
	
	--local bankBtn2 = this.transform:FindChild("Menu-5/Bank").gameObject;	
	--this.mono:AddClick(bankBtn2, this.OnClickMenuBank);	
	
	--local giftBtn = this.transform:FindChild("Menu-5/Gift").gameObject;	
	--this.mono:AddClick(giftBtn, this.OnClickMenuGift);	
	--giftBtn:SetActive(false);	
	 	
		
		
		
	local rankBtn = this.transform:FindChild("Menu/leaderboard").gameObject;	
	this.mono:AddClick(rankBtn, this.EnterLeaderboard);	
	this.Download_Progress_Bar = this.transform:FindChild("Info/UserInfo/Avatar/Download_Progress_Bar").gameObject;	
	this.Download_Progress_Slider = this.Download_Progress_Bar:GetComponent("UISlider");	
	this.InstantUpdate_Label = this.transform:FindChild("Info/UserInfo/Avatar/InstantUpdate_Label").gameObject;	
	
	this.Version_Update_slider = this.transform:FindChild("Info/UserInfo/Avatar/Version_Update_progress"):GetComponent("UISlider");	
	this.Version_Update_slider.gameObject:SetActive(false);	
	
	this.mono:AddClick(this.transform:FindChild('Info/Help/SettingBtns/BtnSound').gameObject,function (  )
		-- EginProgressHUD.Instance:ShowPromptHUD('暂未开发 敬请期待')
	end)
	this.Label_mailcount = this.transform:FindChild("Mail/Label_mailcount"):GetComponent("UILabel");	

    local ybShopBtn = this.transform:FindChild("Menu/Exchange").gameObject	
    this.mono:AddClick(ybShopBtn,this.OnClickMenuYbShop);	


    local tTipObj = this.transform:FindChild('Tips').gameObject
    this.mono:AddClick(tTipObj.transform:FindChild('SureButton').gameObject,function (  )
    	this.OnClickLogout()
    end)
    this.mono:AddClick(tTipObj.transform:FindChild('CancelButton').gameObject,function (  )
    	tTipObj:SetActive(false)
    end)
     this.mono:AddClick(tTipObj.transform:FindChild('BGBtn').gameObject,function (  )
    	tTipObj:SetActive(false)
    end)

 	print('======================================   ')
	UISoundManager.Init(this.gameObject);
	this:SwitchBGMusic(this.BGMusic)


    this.mono:AddClick(this.transform:FindChild('Info/Help/SettingBtns/BtnSound').gameObject,function ( )
     	if this.BGMusic == true then 
     		this:SwitchBGMusic(false)
     	else
     		this:SwitchBGMusic(true)
     	end

     end)

    
	--[[ lxtd004 20170328 V	
		local TaskBtn1 = this.transform:FindChild("Menu/Task").gameObject; 	
	this.mono:AddClick(TaskBtn1, this.OnClickMenuTask); 	
		this.Label_taskcount = TaskBtn1.transform:FindChild("Label_taskcount"):GetComponent("UILabel"); 	
		 this.Label_taskcount.gameObject:SetActive(false);	
		local farmBtn = this.transform:FindChild("Info/UserInfo/farm");	
		if(farmBtn ~= nil)then	
			if(enableLiveRoom ~=0)then	
				farmBtn.gameObject:SetActive(false);	
			else	
				this.mono:AddClick(farmBtn.gameObject, this.EnterFarmGame);	
			end	
		end	
	    local ybShopBtn = this.transform:FindChild("Menu/Grid/YbShop").gameObject	
	    local tMenuBg = this.transform:FindChild("Menu/bg").gameObject	
	    tMenuBg:SetActive(false)	
	    ybShopBtn:SetActive(false)	
	    local tMenuGrid = this.transform:FindChild("Menu/Grid").gameObject:GetComponent("UIGrid")	
	    if Application.platform == UnityEngine.RuntimePlatform.Android or PlatformGameDefine.playform.IOSPayFlag == true then	
	        tMenuBg:SetActive(false)	
	        TaskBtn1:SetActive(false)	
	        ybShopBtn:SetActive(true)	
	        tMenuGrid.cellWidth = 178--160	
	        this.mono:AddClick(ybShopBtn,this.OnClickMenuYbShop);	
	    end	
	    tMenuGrid:Reposition()	
	
		--测试红包活动	
		if PlatformGameDefine.playform:GetPlatformPrefix()~="131" then	
			activityBtn1:SetActive(true);	
			tMenuGrid.cellWidth = tMenuGrid.cellWidth-30;	
		end	
		 -- 元宝商城临时只开通131平台,导航部分做处理	
    --报名通道属性	
	this.registerPanel = this.transform:FindChild("regWayPanel").gameObject;	
	--this.nickNameIp = this.transform:FindChild("regWayPanel/bg/nickname/input"):GetComponent("UIInput");	
	this.realNameIp = this.transform:FindChild("regWayPanel/bg/realname/input"):GetComponent("UIInput");	
	--this.sexIp = this.transform:FindChild("regWayPanel/bg/sex/input"):GetComponent("UIInput");	
	--this.ageIp = this.transform:FindChild("regWayPanel/bg/age/input"):GetComponent("UIInput");	
	this.personIDIp = this.transform:FindChild("regWayPanel/bg/personID/input"):GetComponent("UIInput");	
	this.phoneNumIp = this.transform:FindChild("regWayPanel/bg/phoneNum/input"):GetComponent("UIInput");	
	--this.addressIp = this.transform:FindChild("regWayPanel/bg/address/input"):GetComponent("UIInput");	
	local regYesBtn = this.transform:FindChild("regWayPanel/bg/Button_yes").gameObject;	
	this.mono:AddClick(regYesBtn, this.regConfirm);	
	local regNoBtn = this.transform:FindChild("regWayPanel/bg/Button_cancel").gameObject;	
	this.mono:AddClick(regNoBtn, this.regCancel);	
	this.is131Daily = 0;	
    this.iconGrid = this.transform:FindChild("Play/UIPanel (Clipped View)/UIGrid");	
	if( PlatformGameDefine.playform.PlatformName == "game407" or PlatformGameDefine.playform.PlatformName == "game131") then	
	
		-- mailBtn1.transform.localPosition =  Vector3(-146,-420,0);	
		-- rechargeBtn1.transform.localPosition =  Vector3(456,-420,0); 	
		-- msgBtn1.transform.localPosition =  Vector3(67,-420,0);  	
		-- bankBtn1.transform.localPosition =  Vector3(272,-420,0); 	
		-- rankBtn.transform.localPosition =  Vector3(665,-420,0); 	
		-- TaskBtn1.transform.localPosition =  Vector3(843,-420,0);  	
		-- TaskBtn1:SetActive(true);	
         for i, v in pairs(package131_icon_list) do 	
            this:findBtnSetActive(i,v);	
		end	
	  	
	elseif(PlatformGameDefine.playform.PlatformName == "1977game2" or  PlatformGameDefine.playform.PlatformName == "game597")then	
		for i, v in pairs(package597_icon_list) do 	
            this:findBtnSetActive(i,v);	
		end	
	else	
        this:findBtnSetActive("Button_Game_FKBY",false)	
        this:findBtnSetActive("Button_Game_DDZ131BS",false)	
        this:findBtnSetActive("Button_Game_DDZ131BS2",false)	
        this:findBtnSetActive("Button_Game_DDZ131HPY",false)	
        this:findBtnSetActive("Button_Game_DDZBS",true)	
	end	
	local ddzliveBtn = this.transform:FindChild("Play/UIPanel (Clipped View)/UIGrid/Button_Game_DDZLive").gameObject;	
    if ddzliveBtn ~= nil then	
       if(enableLiveRoom == 0)then	
		    ddzliveBtn:SetActive(false);	
    	else	
            if( PlatformGameDefine.playform.PlatformName == "game407" or PlatformGameDefine.playform.PlatformName == "game131") then	
                ddzliveBtn:SetActive(true);	
            else	
                ddzliveBtn:SetActive(false);	
            end 	
	    end 	
    end	
	
    this.mono:AddClick(this.transform:FindChild("Info/UserInfo/Lab_ID").gameObject,function ( )	
		-- this:GuestRegisterPanelCtrl(true)	
		this.TestBtn()	
	end)	
	
	if(GameManager.tVersionObj ~= nil)then	
	    if(tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_AppStore) then	
			this.updateTip = this.transform:FindChild("appStoreUpdateTip").gameObject;	
			this.updateConfirmBtn = this.updateTip.transform:FindChild("bg/Button_yes").gameObject;	
			this.updateCancelBtn = this.updateTip.transform:FindChild("bg/Button_cancel").gameObject;	
			coroutine.start(this.CheckVersion);	
		end	
	end	
	]]	
	
   	
		
		----------------增加游客注册窗口	
	--[[	
	this.m_GuestConvertObj = this.transform:FindChild('ConvertRegister')	
	this.m_RealNameRegister = this.m_GuestConvertObj:FindChild("Offset/Views/Register").gameObject	
	this.m_PhoneRegister = this.m_GuestConvertObj:FindChild("Offset/Views/PhoneRegister").gameObject	
 	
	this.m_Username = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_Username/Input").gameObject:GetComponent("UIInput");	
	this.m_Nickname = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_Nickname/Input").gameObject:GetComponent("UIInput");	
	this.m_Password = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_Password/Input").gameObject:GetComponent("UIInput");	
	this.m_PasswordVerify = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_Ps/Input").gameObject:GetComponent("UIInput");	
	this.m_Email = this.m_GuestConvertObj:FindChild('Offset/Views/Register/Input_Email/Input').gameObject:GetComponent('UIInput')	
	this.m_PhoneNumber = this.m_GuestConvertObj:FindChild("Offset/Views/PhoneRegister/Input_PhoneNumber/Input").gameObject:GetComponent("UIInput");	
	this.m_PhoneNickname = this.m_GuestConvertObj:FindChild("Offset/Views/PhoneRegister/Input_Nickname/Input").gameObject:GetComponent("UIInput");	
	
	this.m_TuiID = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_tuiJian/Input").gameObject:GetComponent("UIInput");--推荐人ID	
	this.m_TuiId = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_tuiJian").gameObject ;	
	this.m_TuiId.gameObject:SetActive(false)	
	this.m_BtnSure = this.m_GuestConvertObj:FindChild('Offset/Views/Register/Button_Submit').gameObject	
	this.m_BtnBG = this.m_GuestConvertObj:FindChild('Offset/Background/BGBtn').gameObject	
	this.mono:AddClick(this.m_BtnSure,function ( )	
		this:GuestConvertReal(1)	
	end )	
	this.m_BtnPhoneSure = this.m_GuestConvertObj:FindChild('Offset/Views/PhoneRegister/Button_Submit').gameObject	
	 this.mono:AddClick(this.m_BtnPhoneSure,function ( )	
		this:GuestConvertReal(2)	
	end )	
	
	this.mono:AddClick(this.m_BtnBG,function (  )	
		this:GuestRegisterPanelCtrl(false)	
	end)	
	]]	
		
end	
function this:findBtnSetActive(btnName,isactive)	
   local temp = this.iconGrid:FindChild(btnName)	
		if  temp ~= nil then	
			temp.gameObject:SetActive(isactive);	
		end  	
end	
	
function this:clearLuaValue()	
    this.mono = nil	
    this.gameObject = nil	
    this.transform  = nil	
	Hall_Modules = nil;	
    _GameModuleDownloadParentTransMap = nil	
	this.Download_Progress_Bar = nil;	
    this.InstantUpdate_Label = nil;	
    this.Download_Progress_Slider = nil;	
	this.Version_Update_slider = nil	
	this.module_activity = nil;	
    preItemTemp = nil;	
    waitSeconds = 0;	
    LuaGC()	
    	
end	
	
function this.LoadNotices()	
	coroutine.wait(1)	
	if(this.mono==nil) then return; end	
    local notices;	
    local kNoticePrefab = ResManager:LoadAsset("HappyCity/Hall","Hall_Notice");	
    local www = HttpConnect.Instance:HttpRequestAli(PlatformGameDefine.playform:GameNoticeURL());	
    coroutine.www(www);	
    if(this.gameObject == nil)then	
        return;	
    end	
    local result = HttpConnect.Instance:BaseResult(www);	
    if(HttpResult.ResultType.Sucess == result.resultType) then	
        --notices = result.resultObject.list;	
        --log(www.text)	
        --[[{	
            "result": "ok",	
            "body":	
            [{"title": "牛牛体验房上线公告！", "time": "2016-01-22", "url": "http://www.game597.com/"},	
            {"title": "关于邮箱及手机验证码接收异常的公告！", "time": "2015-11-27", "url": "http://www.game597.com/"},	
            {"title": "手机绑定银行，财产安全保障！", "time": "2015-10-22", "url": "http://www.game597.com/"},	
            {"title": "关于游戏不能登录问题的解决方案！", "time": "2015-10-21", "url": "http://www.game597.com/"}]	
            }	
        ]]	
        local resultData = cjson.decode(www.text);	
        notices = resultData["body"];	
        if(#(notices) == 0)then	
            this:SetNoticeObj(kNoticePrefab, Vector3(0,0,0), ZPLocalization.Instance:Get("HallNotice"), ConnectDefine.HOME_URL);	
        else	
            for i=1, #(notices) do	
                this:SetNoticeObj(kNoticePrefab, Vector3(0,(i-1)*-45,0), notices[i]["title"], notices[i]["url"]);	
                if (i >= 3)then	
                    break;	
                end	
            end	
        end	
    else	
        this:SetNoticeObj(kNoticePrefab, Vector3(0,0,0), ZPLocalization.Instance:Get("HallNotice"), ConnectDefine.HOME_URL);	
    end	
    	
end	
	
--local  ss = 9;	
function this:showLobbyMsgList( content)	
    --测试用消息	
    --content = {body ={ {content="第"..ss .."条信息.", create_time=ss..""},{content="第7条信息12第7条信息第7条信息第7条信息第7条信息第7条信息第7条信息", create_time="7"} }};	
    --ss = ss+1;	
    if( LobbyMsgReceiver.addmessageBody(content["body"]))then	
        local vNotices = this.transform:FindChild("Info/Notice/Notices");	
        local dataList = LobbyMsgReceiver.messageBody;	
     	
        local count = vNotices.transform.childCount;	
        for i=1,count do	
            local needDelTr = vNotices.transform:GetChild(i-1);	
            if(needDelTr ~= nil)then	
                GameObject.Destroy( needDelTr.gameObject );	
            end	
        end	
        preItemTemp = nil;	
        for i=1,#(dataList) do	
            this:SetLobbyMsgObj(kNoticePrefab, i-1, dataList[i]["content"], "");	
        end	
        local uipanel = vNotices:GetComponent("UIScrollView");	
        uipanel:ResetPosition();	
        uipanel:MoveRelative(Vector3.New(0,msgObjY+120-322,0));	
    end 	
    --[[	
    if(#dataList == 0)then	
		local count = vNotices.transform.childCount;	
	   	if(count == 0)then	
	   		if(UnityEngine.PlayerPrefs.HasKey("lobbyMsg"))then	
	    		--error("取本地消息");	
				local localMsg = UnityEngine.PlayerPrefs.GetString("lobbyMsg");	
				this:SetLobbyMsgObj(kNoticePrefab, 0, localMsg, "");	
	    	end	
	   	end	
    -- {"body": [{"status": 1, "content": "这是一条测试消息.", "user_id": 889657154, "msg_type": 0, 	
    --"left_time": 1482395165.04, "timeout": 1800, "send_time": 1482393365.04, "position": 0}], 	
    --"tag": "read_messages", "type": "AccountService", "result": "ok"}	
    else	
    	local count = vNotices.transform.childCount;	
    	for i=1,count do	
   			local needDelTr = vNotices.transform:GetChild(i-1);	
   			if(needDelTr ~= nil)then	
   				GameObject.Destroy( needDelTr.gameObject );	
   			end	
   		end	
	
    	for i=1,#(dataList) do	
	        this:SetLobbyMsgObj(kNoticePrefab, i-1, dataList[i]["content"], "");	
	        if(i == 1)then	
	        	UnityEngine.PlayerPrefs.SetString("lobbyMsg", dataList[i]["content"]);	
	        	UnityEngine.PlayerPrefs.Save();	
	        end	
	    end	
    end	
    ]]	
end	
	
function this:SetNoticeObj(prb, vc3, title, url)	
    local notice = GameObject.Instantiate(prb);	
    local vNotices = this.transform:FindChild("Info/Notice/Notices");	
    notice.transform.parent = vNotices;	
    notice.transform.localScale = Vector3(1,1,1);	
    notice.transform.localPosition = vc3;	
    notice:GetComponent("UIPanel").depth = notice:GetComponent("UIPanel").depth + 1;	
    notice.transform:Find("Label_Title"):GetComponent("UILabel").text = title;	
    notice.transform:Find("Label_Time"):GetComponent("UILabel").text = "";	
    notice.transform:Find("Label_URL"):GetComponent("UILabel").text = url;	
    	
end	
	
function this:SetLobbyMsgObj(prb, index, des)	
    local notice = GameObject.Instantiate(prb);	
    local vNotices = this.transform:FindChild("Info/Notice/Notices");	
    notice.transform.parent = vNotices;	
    notice.transform.localScale = Vector3(1,1,1);	
    notice:GetComponent("UIPanel").depth = notice:GetComponent("UIPanel").depth + 1;	
    notice.transform:Find("Label_Title"):GetComponent("UILabel").text = des;	
    --notice.transform:Find("Label_Title").gameObject:AddComponent("UIDragScrollView");	
    if(preItemTemp == nil)then	
        notice.transform.localPosition = Vector3(0,index* (notice.transform:Find("Label_Title"):GetComponent("UILabel").height+20)*-1,0);	
        msgObjY = 0;	
    else	
        local preHeight = preItemTemp.transform:FindChild("Label_Title"):GetComponent("UILabel").height;	
        local curHeight = notice.transform:FindChild("Label_Title"):GetComponent("UILabel").height;	
        msgObjY = msgObjY + preHeight + 20;	
	
        notice.transform.localPosition = Vector3(0, -msgObjY ,0);	
    end	
    preItemTemp = notice;	
end	
	
	
function this:OnClickNotice(hall, tb)	
    local notice = tb[1];	
    local url = notice.transform:Find("Label_URL"):GetComponent("UILabel").text;	
    Application.OpenURL(url);	
end	
	
function this.AfterTime()	
    coroutine.wait(1.5);	
    if(this.gameObject == nil)then	
        return;	
    end	
    vGames.parent:GetComponent("UIScrollView"):ResetPosition();	
end	
function this:CheckDownloadParentTrans()	
    _GameModuleDownloadParentTransMap = {};	
    for i=0,vGames.childCount-1 do	
        local btnTrans = vGames:GetChild(i);	
        local gameModuleName = "game" .. string.lower( string.gsub(btnTrans.name, "Button_Game_", "") );	
        --log("Lua gameModuleName:" .. gameModuleName)	
        _GameModuleDownloadParentTransMap[gameModuleName] = btnTrans:GetChild(0);	
    end	
    Utils.CheckHallGameModuleDownloadProgress(_GameModuleDownloadParentTransMap);--检测需要显示正在下载的进度条	
end	
	
function this:OnClickLogout()	
    EginUser.Instance:Logout();	
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
    -- Utils.LoadLevelGUI("Login");	
    this.SettingBtns:SetActive(false)
    ShowSign = 0
    this:OpenMenu('Login')
end	
function this:OnClickAddFriend()	
	if(PlatformGameDefine.playform:GetPlatformPrefix()=="597") then	
		PhoneSdkUtil.addFriendFromSms("最新火爆的棋牌游戏,天天有大奖等你来拿！597游戏 www.6666.cn")	
	elseif(PlatformGameDefine.playform:GetPlatformPrefix()=="131") then	
		PhoneSdkUtil.addFriendFromSms("最新火爆的棋牌游戏,天天有大奖等你来拿！131游戏 www.game131.com")	
	elseif(PlatformGameDefine.playform:GetPlatformPrefix()=="510k") then	
		PhoneSdkUtil.addFriendFromSms("最新火爆的棋牌游戏,天天有大奖等你来拿！510k游戏 www.game510k.com")	
	else	
		PhoneSdkUtil.addFriendFromSms("最新火爆的棋牌游戏,天天有大奖等你来拿！www.6666.cn")	
	end	
end	
function this:EnterLeaderboard()	
    --EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
    --Utils.LoadLevelGUI("Module_Leaderboard");	
    -- local tModuleObj = this:GetHall_Modules("Module_Leaderboard")
    -- HallUtil:ShowPanelAni(tModuleObj)
    this:OpenMenu('Module_Leaderboard')
end	
	
function this:regConfirm()	
    log("aaaaaa regconfirm");	
    coroutine.start(this.requestRegToMatch);	
end	
	
--131比赛报名通道检测,如没报名弹出报名界面	
function this:requestCheckReg()	
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);	
    local rand = math.random()*100000;	
    local escapeURL = PlatformGameDefine.playform.HostURL .."/unity/tvapply_exist/?user_id=".. EginUser.Instance.uid .. "&rand=".. rand;	
    if(this.is131Daily == 2)then	
        escapeURL = "http://114.215.156.145/unity/account_exist/?user_id=".. EginUser.Instance.uid .."&game_id=1095".. "&rand=".. rand;	
    end	
    local www = HttpConnect.Instance:HttpRequestAli(escapeURL);	
    error(www.url);	
    coroutine.www(www);	
    EginProgressHUD.Instance:HideHUD();	
    error(www.text);	
    if( www.error == nil)then	
        local resultJson = cjson.decode(www.text);	
        if(resultJson["result"] == "error")then	
            this.registerPanel:SetActive(true);	
        else	
            if(this.is131Daily == 1)then	
                this:OnClick_Game(GameEntityDDZ131BS2,HallConsts.GameModule_DDZ);	
            elseif(this.is131Daily == 0)then	
                this:OnClick_Game(GameEntityDDZ131BS,HallConsts.GameModule_DDZ);	
            elseif(this.is131Daily == 2)then	
                this:OnClick_Game(GameEntityDDZ131HPY,HallConsts.GameModule_DDZ);	
            end	
        end	
    else	
        EginProgressHUD.Instance:ShowPromptHUD(www.error);	
    end	
end	
	
--131比赛报名通道,提交报名资料	
function this:requestRegToMatch()	
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);	
    	
     --user_id=866627607&realname=朱雅韶&sex=1&age=30&cert_no=511702198606266283&telephone=13612345123&address=北京市东花市北里20号楼6单元501室	
    local uid = "user_id=".. EginUser.Instance.uid;	
    local rname = "realname=" .. UnityEngine.WWW.EscapeURL(this.realNameIp.value);	
    --[[local fixSex = 1;	
    if(this.sexIp.value ~= "男" or this.sexIp.value ~= "male")then	
        fixSex = 0;	
    end]]	
    --local sex = "sex=" .. fixSex;	
    --local age = "age=" .. this.ageIp.value;	
    local sex = "sex=1";	
    local age = "age=28";	
    local cert_no = "cert_no=" .. UnityEngine.WWW.EscapeURL(this.personIDIp.value);	
    local phone = "telephone=" .. this.phoneNumIp.value;	
    --local addres = "address=" .. UnityEngine.WWW.EscapeURL(this.addressIp.value);	
    local addres = "address=123";	
    local rand = math.random()*100000;	
    local fixedUrlValue = uid .. "&" .. rname .. "&" .. sex .. "&" .. age .. "&" .. cert_no .. "&" .. phone .. "&" .. addres .. "&rand=" .. rand;	
    --fixedUrlValue = UnityEngine.WWW.EscapeURL(fixedUrlValue);	
    local fixUrl = PlatformGameDefine.playform.HostURL .."/unity/tvapply_reg/?".. fixedUrlValue;	
    	
    if(this.is131Daily == 2)then	
        --[[user_id -- 用户id game_id -- 游戏id  realname -- 真实姓名  cert_no -- 身份证号 telephone -- 手机号码]]	
        fixedUrlValue = uid .. "&" .. rname .. "&" .. cert_no .. "&" .. phone .. "&game_id=1095&rand=" .. rand;	
        --PlatformGameDefine.playform.HostURL ..	
        fixUrl = "http://114.215.156.145/unity/account_apply/?".. fixedUrlValue;	
    end	
    local www = HttpConnect.Instance:HttpRequestAli(fixUrl);	
    error(www.url);	
    coroutine.www(www);	
    EginProgressHUD.Instance:HideHUD();	
    error(www.text);	
    --{"body": "\u8eab\u4efd\u8bc1\u9519\u8bef", "result": "error"}	
    if( www.error == nil)then	
        local resultJson = cjson.decode(www.text);	
        	
        if(resultJson["body"] == "ok")then	
            log("close panel and enter the game");	
            if(this.is131Daily == 1)then	
                this:OnClick_Game(GameEntityDDZ131BS2,HallConsts.GameModule_DDZ);	
            elseif(this.is131Daily == 0)then	
                this:OnClick_Game(GameEntityDDZ131BS,HallConsts.GameModule_DDZ);	
            elseif(this.is131Daily == 2)then	
                this:OnClick_Game(GameEntityDDZ131HPY,HallConsts.GameModule_DDZ);	
            end	
        else 	
            EginProgressHUD.Instance:ShowPromptHUD( System.Text.RegularExpressions.Regex.Unescape(resultJson["body"]) );	
        end	
    else	
        EginProgressHUD.Instance:ShowPromptHUD(www.error);	
    end	
end	
	
function this:regCancel()	
    this.registerPanel:SetActive(false);	
end	
	
--dont use this function	
function this:OnClickRooms()	
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
    -- Utils.LoadLevelGUI("Module_Rooms");	
    this:OpenMenu('Module_Rooms')
end	
function this:OnClickMenu( menuTag )	
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
    if(EginUser.Instance.isGuest)then	
        Utils.LoadLevelGUI("Register"); 	
    else	
        Utils.LoadLevelGUI(menuTag);	
    end	
end	
function this:OnClickMenuUpdateAvatar() 	
this:OnClickMenu("Module_UpdateAvatar")	
--[[	
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
    this.mono:Request_lua_fun("AccountService/safe_accountInfo","", 	
        function(message) 	
            EginProgressHUD.Instance:HideHUD(); 	
			
		 local messages = cjson.decode(message)	
		 --{"phone":"","cert_no":"","star":0,"email":""}	
		 EginUser.Instance.email= messages["email"] 	
		EginUser.Instance.phone= messages["phone"]  	
		EginUser.Instance.cert_no= messages["cert_no"] 	
		EginUser.Instance.star= messages["star"]  	
		EginUser.Instance.wechat= messages["wechat"] 	
		EginUser.Instance.qq= messages["qq"]  	
              this:OnClickMenu("Module_UpdateAvatar")	
        end, 	
        function(message)	
            EginProgressHUD.Instance:ShowPromptHUD("网络连接失败!");	
        end)	
  ]]	
end	
function this:OnClickMenuMail()	
    -- this:OnClickMenu("Module_Mail")	
    this:OpenMenu('Module_Mail')
end	
function this:OnClickMenuGameRecord() 	
    -- local tModuleObj = this:GetHall_Modules("Module_Task")
    -- HallUtil:ShowPanelAni(tModuleObj)
    this:OpenMenu('Module_Task')
	--发送状态请求	
	Module_Task.GetWeChatShareStatus() 	
end	
function this:OnClickMenuActivity() 	
	--EginProgressHUD.Instance:ShowPromptHUD("即将开放!")	
	--[[]]	
	this:OpenMenu('Module_Activity')
	--  if  this.module_activity == nil then	
	-- 	local ModulePrefab = ResManager:LoadAsset("HappyCity/Module_Activity","Module_Activity");	
	-- 	local moduleTemp = GameObject.Instantiate(ModulePrefab); 	
	-- 	moduleTemp.name = "Module_Activity"	
	-- 	moduleTemp.transform.parent = this.transform;	
	-- 	moduleTemp.transform.localScale = Vector3(1,1,1);	
	-- 	moduleTemp.transform.localPosition = Vector3(0,0,0);	
	-- 	moduleTemp:SetActive(false); 	
	-- 	this.module_activity = moduleTemp;	
	-- end 	
		
	-- this.module_activity:SetActive(true);	
		
	-- --发送状态请求	
	-- Module_Activity:InitData(this) 	
end	
function this:OnClickMenuBank()	
    --this:OnClickMenu("Module_Bank")	
    --this:OnClick_Game(GameEntityBANK,HallConsts.GameModule_BANK)	
    -- local tModuleObj = this:GetHall_Modules("Module_Bank")
    -- HallUtil:ShowPanelAni(tModuleObj)
    this:OpenMenu('Module_Bank')
end	
function this:OnClickMenuYbShop()	
	this:OpenMenu('Module_YBShop')
    -- local tModuleObj = this:GetHall_Modules("Module_YBShop")
    -- HallUtil:ShowPanelAni(tModuleObj)
end	
function this:OnClickMenuTask()	
    this:OnClickMenu("Module_Task2") 	
end	
	
function this.DoLoadRooms1()	
    PlatformGameDefine.game = GameEntityBANK;	
    if(PlatformGameDefine.playform.IsSocketLobby) then	
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);	
        coroutine.start(this.Send_get_rooms1, HallConsts.GameModule_BANK)	
    else	
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
        local rand = math.random()*100000;	
        local  url = ConnectDefine.ROOM_LIST_URL .. PlatformGameDefine.game.GameID .. "/?room_type=" .. PlatformGameDefine.game.GameTypeIDs .. "&minv=20000&maxv=39999&"..rand;	
        local www = HttpConnect.Instance:HttpRequest(url, nil);	
        coroutine.www(www); 	
        local result = HttpConnect.Instance:RoomListResult(www);	
        if(HttpResult.ResultType.Sucess == result.resultType) then	
            log("Min bank room ok");	
            this.mono:EndSocket(true);	
            mRooms = result.resultObject;	
            SocketConnectInfo.Instance:Init(EginUser.Instance, result.resultObject[0]);	
            Utils.ConnectGameSocket();	
            EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
            Utils.LoadLevelGameGUI(HallConsts.GameModule_BANK);	
        else	
            log("Min bank fail");	
        end 	
    end	
end	
	
---------------------------------#region Socket相关---------------------------------------	
-----------------请求房间列表---------------	
function this.Send_get_rooms1(p_gameModuleName)	
    local gameId = PlatformGameDefine.game.GameID	
    local gameTypeIds = PlatformGameDefine.game.GameTypeIDs	
--    local json = {type="AccountService",tag="get_rooms",body={agentid=-1,gt=gameId,maxv=39999,minv=20000,rt=gameTypeIds}};	
    local json = {agentid=-1,gt=gameId,maxv=39999,minv=20000,rt=gameTypeIds};	
    local socketManager = SocketManager.Instance;	
    coroutine.wait(0.1);	
--    this:SocketSendMessage(json) 	
	
    this.mono:Request_lua_fun("AccountService/get_rooms",cjson.encode(json), --this.Receive_get_rooms,this.Receive_get_rooms_Error)	
        function(message)	
            mRooms = cjson.decode(message)	
            --EginProgressHUD.Instance:HideHUD();	
            --this.mono:EndSocket(true);	
            this:InitConnectInfo(mRooms[1]);	
            this:Get_Room_Info1(mRooms[1], p_gameModuleName);	
        end, 	
        function(message)	
            coroutine.start(this.Send_get_rooms)	
            EginProgressHUD.Instance.ShowPromptHUD("网络中断，重连中...");	
        end)	
end	
	
----------------------获取房间信息---------------------	
function this:Get_Room_Info1(roomTable, p_gameModuleName)	
    local json = {agentid=0,game_type=roomTable.game_type,room_level=roomTable.room_level,room_type=roomTable.room_type,usefront=1};	
    SocketConnectInfo.Instance.roomHost = "";	
    this.mono:Request_lua_fun("AccountService/ds_get_room",cjson.encode(json),--用于获取游戏ip和端口	
        function(message)	
            local mRoom = cjson.decode(message)	
            EginProgressHUD.Instance:HideHUD();	
            this.mono:EndSocket(true);	
	
            if(mRoom.host ~= nil) then SocketConnectInfo.Instance.roomHost = mRoom.host end--获取到ip和端口,就设置使用房间的ip和端口	
            SocketConnectInfo.Instance.roomPort = mRoom.port	
	
           local connectInfo = SocketConnectInfo.Instance;	
            if (connectInfo:ValidInfo())  then	
                SocketManager.Instance:Connect(connectInfo,nil,true);	
            else 	
                EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("Socket_Valid"));	
            end	
	
            EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
            Utils.LoadLevelGameGUI(p_gameModuleName);	
        end, 	
        function(message)	
            EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("Socket_Valid"));	
        end)	
    	
end	
	
function this:InitConnectInfo(roomTable)	
        SocketConnectInfo.Instance.userId = EginUser.Instance.uid	
        SocketConnectInfo.Instance.userPassword = EginUser.Instance.password	
	
        SocketConnectInfo.Instance.roomId = roomTable.room_id	
        SocketConnectInfo.Instance.roomHost = roomTable.host	
        SocketConnectInfo.Instance.roomPort = roomTable.port	
        SocketConnectInfo.Instance.roomDBName = roomTable.dbname	
        SocketConnectInfo.Instance.roomFixseat = true;	
	
        SocketConnectInfo.Instance.roomTitle = roomTable.title	
        SocketConnectInfo.Instance.roomMinMoney = roomTable.min_money	
end	
	
function this:OnClickMenuRecharge() 	
	
    if (Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer ) then	
        if(PlatformGameDefine.playform.IOSPayFlag)then	
            -- this:OnClickMenu("Module_Recharge");	
             this:OpenMenu('Module_Recharge')	
        else	
            this:OnClickMenu("Module_Recharge_iOS");	
        end	
    else	
        -- this:OnClickMenu("Module_Recharge");
        this:OpenMenu('Module_Recharge')	
    end	
end	
function this:OnClickMenuGift()	
    if(PlatformGameDefine.playform.IsSocketLobby) then	
        coroutine.start( this.DoLoadRooms1);	
    else 	
        this:OnClickMenu("Module_Gift")	
    end	
end	
function this:OnClickSetting()	
	--[[ lxtd004 20170330 v 	
    if (Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer) then	
        if(PlatformGameDefine.playform.IOSPayFlag)then	
            EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
            Utils.LoadLevelGUI("Module_Setting");	
        else	
            EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
--            Utils.LoadLevelGUI("Module_Setting");	
            this:OnClickMenuUpdateAvatar();	
        end	
    else	
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
        Utils.LoadLevelGUI("Module_Setting");	
    end	
    ]]	
    if this.SettingBtns.activeSelf == false then 
   		this.SettingBtns:SetActive(true)
    else
    	this.SettingBtns:SetActive(false)
    end
    	
end	
function this:OnClickFeedback()	
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
    Utils.LoadLevelGUI("Module_Feedback");	
end	
function this:OnClickGuide()	
    PlatformGameDefine.game:ShowGameGuide();	
end	
	
	
	
function this:FindButton(btn)	
    this[btn] = find(btn)	
		
	if(tableContains(inactive_package_icon_list, btn)) then	
		if(this[btn]) then this[btn]:SetActive(false); end	
		return	
	end	
		
	if(Utils._IsFish) then 	
		if(not tableContains(fish_package_icon_list, btn)) then	
			if(this[btn]) then this[btn]:SetActive(false); end	
			return	
		end	
	end	
		
	if(Utils._SingleGame) then 	
		if(not tableContains(singleGame_package_icon_list, btn)) then	
			if(this[btn]) then this[btn]:SetActive(false); end	
			return	
		end	
	end	
		
    this.mono:AddClick(this[btn],this["OnClick" .. string.gsub(btn, "Button_Game", "", 1)])	
		--2017 5 31 lxtd004 
 --    if IsPlatformLua then 	
 --        if not PlatformLua.playform:IshandselGame(btn) then	
 --             if(this[btn]) then 	
 --                local tempGold = this[btn].transform:FindChild("Sprite/icon");	
 --                if tempGold ~= nil then	
 --                    tempGold.gameObject:SetActive(true);	
 --                end	
 --            end 	
 --        end 	
 --    else	
 --        if( PlatformGameDefine.playform.PlatformName == "game131") then	
 --            --如果是131平台没有彩金	
 --            if(this[btn]) then 	
 --                local tempGold = this[btn].transform:FindChild("Sprite/icon");	
 --                if tempGold ~= nil then	
 --                    tempGold.gameObject:SetActive(false);	
 --                end	
 --            end 	
	--     end 	
	-- end	
		
end	
	
function this:OnClick_Game(gameEntity, btnName)	
    log("------------------------------- onclick_game = " .. gameEntity.GameName)	
    PlatformGameDefine.game = gameEntity	
	if this.SettingBtns.activeSelf==true then 
		this.SettingBtns:SetActive(false)
	end

	local gameModulesList = ArrayList()	
	gameModulesList:Add("gamenn")--gamenn 是游戏的基础项目	
		
	local module_list = GameModuleReference_list[btnName]	
	if module_list then	
		for i, v in pairs(module_list) do	
			log("------------------------------- module_list = " .. v)	
			gameModulesList:Add(v)	
		end	
	end	
        	
	Utils.CheckGameModulesUpdate(this.mono,gameModulesList,btnName,function()    	
        end,function (tObj)
        	if tObj ~= nil then 
                --lxtd003 -->
                this.isInMainScreen = false;
                --<---
		 		ShowHallPanel(tObj,true,nil,function ( )
					this:ShowOrHideBlackBG(true)
				end)
			end
        end);	
end	
	
function this:EnterFarmGame()	
    --this:OnClick_Game(GameEntityFARM,HallConsts.GameModule_FARM)	
    PlatformGameDefine.game = GameEntityFARM;	
    if(PlatformGameDefine.playform.IsSocketLobby) then	
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);	
        coroutine.start(this.Send_get_rooms1,HallConsts.GameModule_FARM)	
    else	
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
        local rand = math.random()*100000;	
        local  url = ConnectDefine.ROOM_LIST_URL .. PlatformGameDefine.game.GameID .. "/?room_type=" .. PlatformGameDefine.game.GameTypeIDs .. "&minv=20000&maxv=39999&"..rand;	
        local www = HttpConnect.Instance:HttpRequest(url, null);	
        coroutine.www(www); 	
        local result = HttpConnect.Instance:RoomListResult(www);	
        if(HttpResult.ResultType.Sucess == result.resultType) then	
            this.mono:EndSocket(true);	
            mRooms = result.resultObject;	
            SocketConnectInfo.Instance:Init(EginUser.Instance, result.resultObject[0]);	
            Utils.ConnectGameSocket();	
            EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
            Utils.LoadLevelGameGUI(HallConsts.GameModule_FARM);	
        else	
            log("Enter farm game fail");	
        end 	
    end	
    	
end	
	
function this:OnClick_TBNN()	
        this:OnClick_Game(GameEntityNNTB,self.name)	--修改为使用点击的按钮的名字作为游戏需要下载模块列表的索引	
end	
	
function this:OnClick_SRNN()	
        this:OnClick_Game(GameEntityNNSR,self.name)	
end	
	
function this:OnClick_MXNN()	
        this:OnClick_Game(GameEntityNNBR,self.name)	
end	
	
function this:OnClick_DZNN()	
        this:OnClick_Game(GameEntityNNDZ,self.name)	
end	
	
function this:OnClick_JQNN()	
        this:OnClick_Game(GameEntityNNJQ,self.name)	
end	
	
function this:OnClick_FTWZ()	
        this:OnClick_Game(GameEntityFTWZ,self.name)	
end	
	
function this:OnClick_FTWZBS()	
        this:OnClick_Game(GameEntityFTWZBS,self.name )	
end	
	
function this:OnClick_SRFTWZ()	
    this:OnClick_Game(GameEntitySRFTWZ,self.name)	
end	
	
function this:OnClick_HPLZ()	
        this:OnClick_Game(GameEntityHPLZ,self.name  )	
end	
	
function this:OnClick_JQNN()	
        this:OnClick_Game(GameEntityNNJQ,self.name  )	
end	
	
function this:OnClick_30M()	
        this:OnClick_Game(GameEntity30M,self.name  )	
end	
	
function this:OnClick_BRLZ()	
        this:OnClick_Game(GameEntityBRLZ,self.name  )	
end	
	
function this:OnClick_XJ()	
        this:OnClick_Game(GameEntityXJ,self.name  )	
end	
	
function this:OnClick_KPNN()	
        this:OnClick_Game(GameEntityNNKP,self.name  )	
end	
	
function this:OnClick_BBDZ()	
        this:OnClick_Game(GameEntityBBDZ,self.name  )	
end	
	
function this:OnClick_TBWZ()	
        this:OnClick_Game(GameEntityTBWZ,self.name  )	
end	
	
function this:OnClick_DZPK()	
        this:OnClick_Game(GameEntityDZPK,self.name  )	
end	
	
function this:OnClick_YSZ()	
        this:OnClick_Game(GameEntityYSZ,self.name  )	
end	
	
function this:OnClick_SRPS()	
        this:OnClick_Game(GameEntitySRPS,self.name  )	
--	EginProgressHUD.Instance:ShowPromptHUD ("游戏即将上线,敬请期待!!!");	
end	
	
function this:OnClick_DDZ()	
        this:OnClick_Game(GameEntityDDZ,self.name  )	
end	
function this:OnClick_DDZBS()	
        this:OnClick_Game(GameEntityDDZBS,self.name  )	
end	
function this:OnClick_DDZBS2()	
        this:OnClick_Game(GameEntityDDZBS2,self.name  )	
end	
function this:OnClick_DDZBS3()	
        this:OnClick_Game(GameEntityDDZBS3,self.name  )	
end	
function this:OnClick_20DN()	
        this:OnClick_Game(GameEntity20DN,self.name  )	
		--this:OnClick_Game(GameEntityPPC,self.name  GameModule_20DN)	
	--	EginProgressHUD.Instance:ShowPromptHUD ("游戏即将上线,敬请期待!!!");	
	--this:OnClick_Game(GameEntityKSQZMJ,self.name  GameModule_KSQZMJ)	
end	
	
function this:OnClick_DDZ131BS()	
    this.is131Daily = 0;	
    coroutine.start(this.requestCheckReg);	
    --this:OnClick_Game(GameEntityDDZ131BS,self.name  GameModule_DDZ)	
end	
function this:OnClick_DDZ131BS2()	
    this.is131Daily = 1;	
    coroutine.start(this.requestCheckReg);	
    --this:OnClick_Game(GameEntityDDZ131BS2,self.name  GameModule_DDZ)	
end	
function this:OnClick_DDZLive()	
        this:OnClick_Game(GameEntityDDZLive,self.name  )	
end	
	
function this:OnClick_FKBY()	
	if(Application.platform == UnityEngine.RuntimePlatform.Android) then 	
		WXPayUtil.OpenAndroidApp("fkby.u.lobby597lua","http://download.game597.net/ddwonload/game597_4.23_fkby.apk");	
	else  	
		WXPayUtil.OpenIOSApp("fkby.u.game597://","https://itunes.apple.com/us/app/597qi-pai-you-xi/id1144059724?l=zh&ls=1&mt=8");	
	end 	
		--this:OnClick_Game(GameEntityCJFKBY,self.name  )	
end	
	
function this:OnClick_TBSZ()	
        this:OnClick_Game(GameEntityTBSZ,self.name  )	
end	
	
function this:OnClick_TBDSZ()	
        this:OnClick_Game(GameEntityTBDSZ,self.name  )	
end	
function this:OnClick_FKTBDN()	
        this:OnClick_Game(GameEntityFKTBDN,self.name  )	
end	
	
function this:OnClick_KSQZMJ()	
        this:OnClick_Game(GameEntityKSQZMJ,self.name)	
end	
	
function this:OnClick_PPC()	
        this:OnClick_Game(GameEntityPPC,self.name  )	
end	
	
function this:OnClick_HPSK()	
        this:OnClick_Game(GameEntityHPSK,self.name  )	
end	
	
function this:OnClick_QBSK()	
        this:OnClick_Game(GameEntityQBSK,self.name  )	
end	
	
function this:OnClick_DHSZ()	
        this:OnClick_Game(GameEntityDHSZ,self.name  )	
end	
	
function this:OnClick_SHHZ()	
        this:OnClick_Game(GameEntitySHHZ,self.name  )	
end	
function this:OnClick_LRDDZ()	
    this:OnClick_Game(GameEntityLRDDZ,self.name  )	
end	
function this:OnClick_DDZ131HPY()	
    this.is131Daily = 2;	
    this:OnClick_Game(GameEntityDDZ131HPY,self.name);	
    --coroutine.start(this.requestCheckReg);	
end	
function this:OnClick_DDZ131CJF()	
    this:OnClick_Game(GameEntityDDZ131CJF,self.name  )	
end	
	
function this:OnClick_CHESS()	
	-- this:OnClick_Game(GameEntityCHESS,self.name);	
    PlatformGameDefine.game = GameEntityCHESS;	
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);	
    local json = {agentid=-1,gt=1020,maxv=39999,minv=20000,rt=1};	
	
    this.mono:Request_lua_fun("AccountService/get_rooms",cjson.encode(json),	
        function(message)	
            mRooms = cjson.decode(message)	
            this:InitConnectInfo(mRooms[1]);	
            EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
            Utils.LoadLevelGUI("Module_Desks");	
            EginProgressHUD.Instance:HideHUD();	
        end, 	
        function(message)	
            EginProgressHUD.Instance.ShowPromptHUD("连接失败..");	
        end)	
    	
	
end	
	
	
function this:GoToTask() 	
		
	if Hall.Task2Id == 1 then 	
		this:OnClick_DDZ131BS()	
	elseif  Hall.Task2Id == 2 then	
		this:OnClick_DDZ131BS2()	
	elseif  Hall.Task2Id == 3 then	
		this:OnClick_SRNN()	
	elseif  Hall.Task2Id == 4 then	
		this:OnClick_MXNN()	
	elseif  Hall.Task2Id == 5 then	
		this:OnClick_TBWZ()	
	else 	
		coroutine.wait(2);	
		if(this.mono==nil) then return; end	
		this.mono:Request_lua_fun("AccountService/get_taskInfo","",function(message) 	
				local tMsg = cjson.decode(message)    	
				local finishTaskNum = 0;	
				for i = 1,5 do 	
					if tMsg[tostring(i)][3] == 1 then 	
						--1—可领取  	
						finishTaskNum = finishTaskNum+1;	
					end  	
				end	
				if finishTaskNum > 0 then	
					this.Label_taskcount.text = tostring(finishTaskNum);	
					this.Label_taskcount.gameObject:SetActive(true);	
				end	
		end,function (message)  	
		end) 	
	end	
	Hall.Task2Id = 0;	
end	
---------------------添加静默热更新的显示------------------------------	
function this.OnProcess(path, downloadSize, size)	
--log("onprocess callback to lua = ," .. path .. ", " .. downloadSize .. ", " .. size);	
    this.Download_Progress_Bar:SetActive(true);	
    this.InstantUpdate_Label:SetActive(false);	
    this.Download_Progress_Slider.value = (downloadSize + 0.0)/size;	
end	
	
function this.OnFinish(errorStr, isDownloaded)	
--log("onfinish callback to lua = ," .. tostring(errorStr) .. ", " .. tostring(isDownloaded));	
    if((errorStr == nil or errorStr == "") and isDownloaded) then	
        log("finished");	
        this.Download_Progress_Bar:SetActive(false);	
        this.InstantUpdate_Label:SetActive(true);	
        Utils.SetInstantUpdateCallbackNull(); 	
    end	
end 	
	
--------------增加游客转实名注册代码--------弹窗-------------	
	
function this:GuestRegisterPanelCtrl(pShow,pType)	
    if pType ~= nil then 	
        if pType == 1 then	
            --实名 	
            this.m_RealNameRegister:SetActive(true)	
            this.m_PhoneRegister:SetActive(false)	
        else	
            this.m_RealNameRegister:SetActive(false)	
            this.m_PhoneRegister:SetActive(true)	
        end	
    end	
    this.m_GuestConvertObj.gameObject:SetActive(pShow)	
    if pShow == false then	
        this.m_Username.value = ''	
        this.m_Password.value =''	
        this.m_PasswordVerify.value = ''	
        this.m_Nickname.value =''	
        this.m_Email.value = ''	
        this.m_PhoneNickname.value = ''	
        this.m_PhoneNumber.value = ''	
    end	
	
end	
	
	
function this:GuestConvertReal(pType)	
    local tBody = {}	
    local tErrorTip =''	
    if pType == 1 then	
        if this.m_Username.value == nil  or   string.len(this.m_Username.value) == 0  then 	
           tErrorTip = ZPLocalization.Instance:Get("RegisterUsername");	
        end 	
         if this.m_Password.value == nil  or   string.len(this.m_Password.value ) == 0  then 	
             tErrorTip = ZPLocalization.Instance:Get("RegisterPassword");	
        end 	
        if this.m_Password.value ~= this.m_PasswordVerify.value then	
            tErrorTip= ZPLocalization.Instance:Get("RegisterPasswordVerify");	
        end	
        if this.m_Nickname.value == nil  or string.len(this.m_Nickname.value)==0 then	
           tErrorTip = ZPLocalization.Instance:Get("RegisterNickname");	
        end	
        if  string.len(tErrorTip) > 0  then	
            EginProgressHUD.Instance:ShowPromptHUD(tErrorTip,2.0);	
            return	
        end 	
	
        tBody['uid'] = EginUser.Instance.uid	
        tBody['username'] = this.m_Username.value	
        tBody['password'] = this.m_Password.value 	
        tBody['email'] = this.m_Email.value	
        tBody['nickname'] = this.m_Nickname.value	
	
        local tM = EginUser.Instance.uid..this.m_Username.value..'9dfo2*jdm89g-9w!7=(=*xk6-1bch5^d20m8bu25df2(xn-c'	
        tBody['sign'] =  Util.md5(tM)	
        this.mono:Request_lua_fun("AccountService/guest_register",cjson.encode(tBody),function(message) 	
             this:GuestRegisterPanelCtrl(false,1)	
             EginProgressHUD.Instance:ShowPromptHUD('注册成功');	
            --其他操作	
            --渠道处理	
             Module_Channel.Instance:handleReg()	
        end, 	
        function(message)   	
            EginProgressHUD.Instance:ShowPromptHUD(message);	
        end);   	
    else	
        if this.m_PhoneNumber.value == nil or string.len(this.m_PhoneNumber.value) == 0 then	
            tErrorTip = ZPLocalization.Instance:Get("RegisterPhoneNumber")	
        end	
        if this.m_PhoneNickname.value ==nil or string.len(this.m_PhoneNickname.value) == 0 then	
            tErrorTip = ZPLocalization.Instance:Get('RegisterPhoneNickname')	
        end	
        if  string.len(tErrorTip) > 0  then	
            EginProgressHUD.Instance:ShowPromptHUD(tErrorTip,2.0);	
            return	
        end 	
	
         tBody['uid'] = EginUser.Instance.uid	
         tBody['phone'] = this.m_PhoneNumber.value	
         tBody['nickname'] = this.m_PhoneNickname.value	
	
         local tM = EginUser.Instance.uid..EginUser.Instance.nickname..'9dfo2*jdm89g-9w!7=(=*xk6-1bch5^d20m8bu25df2(xn-c'	
        tBody['sign'] =  Util.md5(tM)	
        this.mono:Request_lua_fun("AccountService/guest_phone_reg",cjson.encode(tBody),function(message) 	
             this:GuestRegisterPanelCtrl(false,2)	
             EginProgressHUD.Instance:ShowPromptHUD('注册成功');	
            --其他操作	
        end, 	
        function(message)   	
            EginProgressHUD.Instance:ShowPromptHUD(message);	
        end);   	
	
    end	
end	
	
-----------------------添加大版本更新进度条显示----------------------------	
function this.OnVersionUpdateProcess(progress,downloadSize, size)	
        this.Version_Update_slider.gameObject:SetActive(true);	
		this.Version_Update_slider.value = progress /100;	
end	
	
function this.OnVersionUpdateFinish(err)	
	this.Version_Update_slider.gameObject:SetActive(false);	
	Utils.SetVersionUpdateCallbackNull()	
end	
	
	
	
function this:RefreshUserInfo(  )	
    nickname.text = EginUser.Instance.nickname;	
    this.bagMoney = this.transform:FindChild("Info/UserInfo/BagMoney/Lab_BagMoney"):GetComponent("UILabel");	
    this.bagMoney.text = EginUser.Instance.bagMoney;	
     local avatar = this.transform:FindChild("Info/UserInfo/Avatar/HeadImage"):GetComponent("UISprite");	
    avatar.spriteName = "avatar_" .. EginUser.Instance.avatarNo;	
    local kLevel = this.transform:FindChild("Info/Lab_Level"):GetComponent("UILabel");	
    kLevel.text = "Lv." .. EginUser.Instance.level;	
    --[[lxtd004 20170328 V	
    local bankMoney = this.transform:FindChild("Info/UserInfo/BankMoney/Lab_BankMoney"):GetComponent("UILabel");	
    bankMoney.text = EginUser.Instance.bankMoney;	
    local uid = this.transform:FindChild("Info/UserInfo/Lab_ID"):GetComponent("UILabel");	
    uid.text = "ID:".. EginUser.Instance.uid;	
   	
    local kLevelExp = this.transform:FindChild("Info/LevelInfo/Level/Lab_Exp"):GetComponent("UILabel");	
    kLevelExp.text = EginUser.Instance.levelExp .. "/" .. EginUser.Instance.nextLevelExp;	
    local kLevelSlider = this.transform:FindChild("Info/LevelInfo/Level/Slider - Horizontal"):GetComponent("UISlider");	
    if(EginUser.Instance.nextLevelExp>0) then	
        kLevelSlider.value = EginUser.Instance.levelExp /EginUser.Instance.nextLevelExp;	
    else	
        kLevelSlider.value = 0;	
    end	
    local kVipLevel = this.transform:FindChild("Info/LevelInfo/VipLevel/Lab_VipLevel"):GetComponent("UILabel");	
    kVipLevel.text = "VIP." .. EginUser.Instance.vipLevel;	
	]]	
end	
	
function this.SocketReceiveMessage(pMessage)	
    if  pMessage then	
        --解析json字符串	
        local messageObj = cjson.decode(pMessage);	
        local typeC = messageObj["type"];	
        local tag = messageObj["tag"];	
        if typeC == 'AccountService' then	
            if tag == 'get_account' then	
                EginUser.Instance:UpdateUserWithDict(messageObj["body"])	
                this:RefreshUserInfo(  )	
                --渠道处理	
                Module_Channel.Instance:handleGetAccount();	
			elseif (tag == 'display_mail_count') then--未读邮件数显示--	
				log("mailcount = " .. messageObj["body"])	
				this.Label_mailcount.text = tostring(messageObj["body"]);	
				this.Label_mailcount.gameObject:SetActive(messageObj["body"] > 0);	
            elseif( tag == "read_messages" )then	
                this:showLobbyMsgList(messageObj);	
            elseif  tag == "getGoldnn_weekList" or tag == "getGoldnn_dayList" or tag == "get_userranks" then	
                 Module_Leaderboard.SocketReceiveMessage(pMessage)
            end	
            Module_YBShop.SocketReceiveMessage(pMessage)
            Module_Bank.SocketReceiveMessage(pMessage)
        end	
    end	
end	
	
function this.TestBtn( )	
    -- ProtocolHelper.Send_Phone_login()	
    local bodyJson = {}	
    bodyJson['phone'] = EginUser.Instance.phoneNum	
    bodyJson['device_id'] = EginUser.Instance.device_id	
    bodyJson['phonecode'] = EginUser.Instance.phonecode 	
    print('IN test  btn  ')	
    this.mono:Request_lua_fun("AccountService/mobile_oauth",cjson.encode(bodyJson),function(message) 	
            print(message)	
        end, 	
        function(message)   	
            print(message)	
        end);       	
	
end	

function this:GetHall_Modules(moduleName)	
	if Hall_Modules[moduleName] == nil then	
        error("GetHall_Modules:"..moduleName)
		local ModulePrefab = ResManager:LoadAsset("happycity/"..moduleName,moduleName)
		local moduleTemp = GameObject.Instantiate(ModulePrefab); 	
		moduleTemp.name = moduleName	
		moduleTemp.transform.parent = this.transform;	
		moduleTemp.transform.localScale = Vector3(1,1,1);	
		moduleTemp.transform.localPosition = Vector3(0,0,0);	
		moduleTemp:SetActive(false);	
		Hall_Modules[moduleName] = moduleTemp; 	
	end	
	return Hall_Modules[moduleName];	
end	
	
-------------------未读邮件数显示---------------------	
-- 32.#未读邮件数量	
-- 上行：	
-- {	
	-- "type":AccountService,	
	-- "tag": display_mail_count,	
	-- "body":{}	
-- }	
	
-- 下行：	
	
-- {	
	-- "type":AccountService,	
	-- "tag": display_mail_count,	
	-- "result":'ok', --成功ok body有值,失败body为0	
	-- "body": n, --数量	
-- }	
function this.Send_display_mail_count()	
	local json = {type="AccountService",tag="display_mail_count",body={}};	
	this.Label_mailcount.gameObject:SetActive(false);	
	while(this.Label_mailcount) do	
		coroutine.wait(5);	
		if(this.mono) then this.mono:SocketSendMessage(cjson.encode(json)) end	
		coroutine.wait(295);	
	end	
end	
	
	
-------------签到界面---------	
function this:LoadSign()
    if( not this.isInMainScreen) then
        return;
    end
	coroutine.wait(1);
	if(this.mono==nil) then return; end	
	this:Request_lua_fun("AccountService/get_sign_award_info","",	
		function(result)   

             dailyBonusCallBack = 1;
             if( not this.isInMainScreen) then
                return;
             end	
			 this.SignInfo = cjson.decode(result)	
			 if this.SignInfo[1] == 0 then	
				  coroutine.start(this.AfterDoing,this,0.5, function() 	
                    if(  not this.isInMainScreen) then
                        return;
                    end
					local module_Sign = this:GetHall_Modules("Module_Sign")	
					module_Sign:SetActive(true);	
					ShowSign = 1;
					Module_Sign:SetEndSocket(this.mono)	
					isShowOneST = true;	
				end);	
			 end 	
		end, 	
		function(result) 	
            dailyBonusCallBack = 1;	
		end);	
end	
function this:Request_lua_fun(url,body,funwin,funfail)   	
	this.mono:Request_lua_fun(url, body,function(result) 	
			  funwin(result)	
		end, 	
		function(result) 	
			funfail(result)	
		end);  	
end	
	
-----AppStore提示更新-------	
function this:CheckVersion() 	
    if(this.mono == nil)then	
        return;	
    end	
    --local updateUrlConfig = "http://oss.aliyuncs.com/bak998899/test/version_All_AppStore.txt";	
    --local updateUrlConfig = GameManager.ChekcVersionURL();	
    --local rand = math.random()*100000;	
    --local escapeURL = updateUrlConfig .. "?rand=".. rand;	
    --local www = HttpConnect.Instance:HttpRequestAli(escapeURL);	
    --log(www.url);	
   -- coroutine.www(www);	
    --if(this.mono == nil)then	
    --    return;	
    --end	
    local resultJson = GameManager.tVersionObj	
    printf(resultJson)	
    if( true)then	
        --local str = www.text;	
        --local resultJson = cjson.decode(str);	
         --[[	
            {"result": "ok",	
            "body":{"version_code":"51",	
            "deprecated_code":"47",	
            "url":"itms-apps://itunes.apple.com/app/id1111218224",	
            "update":"点击更新会自动跳转到App Store下载…"}}	
        ]]	
        local serverSideVer = resultJson["version_code"];	
        local updateURL = resultJson["url"];	
        local updateTxt = resultJson["update"]; 	
	    local tDeprecateCode = tonumber(resultJson['deprecated_code'])	
	    local tCancel = tonumber(PlatformGameDefine.game.VersionCode) > tDeprecateCode	
	    this.updateCancelBtn:SetActive(tCancel)	
	 	
        if(tonumber(serverSideVer) > tonumber(PlatformGameDefine.game.VersionCode))then	
            this.updateTip:SetActive(true); 	
            this.updateTip.transform:FindChild("bg/nickname"):GetComponent("UILabel").text = updateTxt;	
            this.mono:AddClick(this.updateConfirmBtn, function()	
                --error("lua--->".. updateURL);	
                Application.OpenURL(updateURL)	
            end);	
            this.mono:AddClick(this.updateCancelBtn, function ()	
                this.updateTip:SetActive(false);	
            end);	
        end	
    else	
        --EginProgressHUD.Instance:ShowPromptHUD(www.error);	
    end	
end	
	
function this.InvokeCheckPopup()	
    while this.mono do	
        coroutine.wait(1);	
        waitSeconds = waitSeconds+1;	
        if(waitSeconds == 8)then	
            if(hasPopupUpdate ~= 1)then	
                this.updateTip:SetActive(true);	
                hasPopupUpdate = 1;	
                return;	
            else	
                return;	
            end	
        end	
        if(dailyBonusCallBack == 1)then	
            if(hasPopupUpdate ~= 1)then	
                this.updateTip:SetActive(true);	
                hasPopupUpdate = 1;	
                return;	
            else	
                return;	
            end	
        end	
    end	
end	
	
--友盟统计插件	
function this:Umeng()	
	if  PlatformGameDefine.playform.PlatformName == "game131" then	
	 	if  Application.platform == UnityEngine.RuntimePlatform.Android then 	
		 	UmengUtil.initUmeng("58c7a1a445297d5d8500122f","android"..Utils.Agent_Id,true)	
			 print("initUmeng android")	
	    elseif  Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then	
			UmengUtil.initUmeng("58d38bda5312dd1b93000d56","App Store",true)	
			print("initUmeng App Store")	
		end	
	end 	
end	
	
function this:Popup131AD()	
    if( PlatformGameDefine.playform.PlatformName == "game407" or PlatformGameDefine.playform.PlatformName == "game131")then	
        if(hasPopup131AD == 1)then	
            return;	
        end	
        hasPopup131AD = 1;	
        	
        this:Request_lua_fun("AccountService/get_time","",	
		function(result)   	
			local time1 = result;	
			local date = "%d%d:%d%d:%d%d";--"2017/01/12 09:55:27 GMT+0800"	
            local fixTime = string.sub(time1,string.find(time1,date));--09:55:27	
            local hour = string.sub(fixTime, 1, -7);	
            --早上10点 到 晚上10 点	
            if(tonumber(hour) >=10 and tonumber(hour) <22)then	
            	local prb = ResManager:LoadAsset("happycity/131AD","ADPanel131");	
		        local ADObj = GameObject.Instantiate(prb); 	
		        ADObj.name = "ADPanel131";	
		        ADObj.transform.parent = this.transform;	
		        ADObj.transform.localScale = Vector3(1,1,1);	
		        ADObj.transform.localPosition = Vector3(0,0,0);	
		        local closeBtn = ADObj.transform:FindChild("closeBtn").gameObject;	
		        local adBtn = ADObj.transform:FindChild("ad").gameObject;	
		        this.mono:AddClick(closeBtn, function()	
		            ADObj:SetActive(false);	
		        end)	
		        this.mono:AddClick(adBtn, function ()	
                    --[[	
		            PlatformGameDefine.game = GameEntityDDZ131HPY;	
		            EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);	
		            local json = {agentid=-1,gt=1095,maxv=39999,minv=20000,rt=6};	
	
		            this.mono:Request_lua_fun("AccountService/get_rooms",cjson.encode(json), --this.Receive_get_rooms,this.Receive_get_rooms_Error)	
		                function(message)	
		                    mRooms = cjson.decode(message)	
		                    this:InitConnectInfo(mRooms[1]);	
		                    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
		                    Utils.LoadLevelGUI("Module_Desks");	
		                    EginProgressHUD.Instance:HideHUD();	
		                end, 	
		                function(message)	
		                    EginProgressHUD.Instance.ShowPromptHUD("连接失败..");	
		                end)	
                        ]]	
                        this:OnClick_DDZ131CJF()	
		            end)	
            end	
	
		end, 	
		function(result) 	
           error(result);	
		end);	
    end	
end	
	
function this:SignClose()   	
	--[[	
	if isShowOneST then	
		isShowOneST = false;	
		 local  module_oneST = this:GetHall_Modules("Module_OneST")	
		module_oneST:SetActive(true);	
	end		
	]]	
end	
	
	
function this:AfterDoing(offset,run)	
	coroutine.wait(offset);		
	if this.mono then	
		run();	
	end	
end 	


function this:autoGetUI()
	 this.ui_AvatarBtn=this.transform:FindChild("Info/UserInfo/Avatar").gameObject	
end
function this:autoClearUI()
	 this.ui_AvatarBtn= nil	
end

--弹出面板lxtd004
function this:OpenMenu(pName)
    this.isInMainScreen = false;
    this.SettingBtns:SetActive(false)
	if pName == 'Login' then
		this.mono:EginLoadLevel("Login")
	else
	 	HallUtil:PopupPanel(pName,true,nil,nil)
	end
end

-- function this:UpdateAni()
-- 	print('=====================  in  update anid ')
-- 	if not this.InvokeLua:IsInvoking("ActivityAni") then
-- 		print('--------------  in  ')
-- 		this.InvokeLua:InvokeRepeating("ActivityAni",this.ActivityAni, 0.1, 5);
-- 	end
-- end
-- function this.ActivityAni()
-- 	tAni:Play('Activity');
-- 	print('------------bounce ')
-- 	-- coroutine.start(function (  )
-- 	-- 	local tAni = this.transform:FindChild('Activity/Sprite').gameObject:GetComponent('Animator')
-- 	-- 	tAni.enabled=true
-- 	-- 	tAni:Play('Activity');
-- 	-- 	coroutine.wait(0.3)
-- 	-- 	tAni.enabled=false
-- 	--  	tAni.gameObject.transform.localScale =Vector3.one
-- 	-- end)
-- end

function this:SetPoint()
	local tCentreObj =  this.transform:FindChild('Play/UIPanel (Clipped View)/UIGrid'):GetComponent('UICenterOnChild').centeredObject
	if tCentreObj ~= nil then
		local tN = string.sub(tCentreObj.name,6,6)
		print(tN)
		this.transform:FindChild('Play/Sprite'..tN).gameObject:GetComponent('UISprite').spriteName= 'fengedianji'
		for j=1,3 do
			if tonumber(tN) ~= j then 
				this.transform:FindChild('Play/Sprite'..j).gameObject:GetComponent('UISprite').spriteName= 'fenge'
			end
		end
	end
end

--isshow =true 展示  
function this:ShowOrHideBlackBG(pIsShow)
	this.transform:FindChild('BlackPanel').gameObject:SetActive(pIsShow)
	local tTitle =this.transform:FindChild('Info').gameObject
	tTitle:GetComponent('UIAnchor').enabled =false	
	if pIsShow then
	 	iTween.MoveTo(tTitle,iTween.Hash("islocal", true,'y',400, "easetype",iTween.EaseType.easeOutBounce, "time",0.5));
	else
	 	iTween.MoveTo(tTitle,iTween.Hash("islocal", true,'y',154, "easetype",iTween.EaseType.easeOutBounce, "time",0.5));
 		coroutine.start(function ()
			coroutine.wait(0.5)
			tTitle:GetComponent('UIAnchor').enabled =true 
		end)
	end
end

--bgm开关
function this:SwitchBGMusic(pIsOn)
	this:PlayBGM(pIsOn)
	this.BGMusic = pIsOn
	this.transform:FindChild('Info/Help/SettingBtns/BtnSound/Sprite/Close').gameObject:SetActive(not pIsOn)
	find('Camera').gameObject:GetComponent('AudioListener').enabled = pIsOn
end


function this:PlayBGM(pIsPlay )
	if pIsPlay == true then 
		UISoundManager.AddAudioSource("HappyCity/AudioClip","BGMusic",true);
		UISoundManager.Instance.PlaySound('BGMusic')
		UISoundManager.Start(true)
		UISoundManager.BGVolumeSet(1)
		UISoundManager.PlayBGSound()
	else
		UISoundManager.PauseBGSound()
	end

end

function this:ChangeIDBtns(  )
	this.SettingBtns:SetActive(false)
	this.transform:FindChild('Tips').gameObject:SetActive(true)
end