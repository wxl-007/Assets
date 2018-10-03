require "GameDZPK/DZPKPlayerCtrl"

local this = LuaObject:New()
GameDZPK = this

local m_PanelSetting 
local m_BGSlider
local m_YinXiaoSilder
local m_Male
local m_Female
local m_InputBoardSp
local m_SendBtnSp
local m_InputLab

local m_PlayerPre
local m_PlayerPreList

-- local m_BtnBeginObj
-- local m_BtnCallBankersObj
local m_BtnShowObj
local m_MsgWaitNextObj
local m_MsgWaitBetObj
local m_ChooseChipObj
local m_MsgQuitObj
local m_MsgAccountFailedObj
local m_MsgNotContinueObj

local m_AddBetObj
local m_DiChiBeiShuObj
local m_BBBetObj
local m_AllInSp
local m_OnceSp
local m_TwiceOrTripleSp
local m_OnceOrTwiceSp
local m_DoubleThreeSp
local m_DoubleFourSp
local m_BtnsObj
local m_BtnObjAuto
local m_GenLab
local m_GenBtn
local m_AllInBtn
local m_AddBtn
local m_AutoKanObj
local m_AutoFollowGenObj
local m_AutoQiObj
local m_AutoFollowAllObj
local m_AutoKanSp
local m_AutoFollowGenSp
local m_AutoQiSp
local m_AutoFollowAllSp
local m_UserAvatarSp
local m_UserNickNameLab
local m_UserNickNameLab_1
local m_UserLevelLab
local m_UserBagmoneyLab
local m_UserIndex = 0
local m_OtherUid = '0'
local m_PlayingPlayerObjList = {}
local m_NotQiList = {}
local m_WaitPlayerObjList = {}
local m_ReadyPlayerObjList = {}
local m_nnPlayerName = 'DZPKPlayer_'
local m_BankerPlayerObj
local m_ColorBtns 

local m_IsPlaying = false 
local m_IsLate =false 
local m_IsReEnter =false 
local playerCtrlDc = {}
local m_JuTime = 15
local m_SettingBtnSp
local m_CardPromptSp
local m_MessageTalkSp
local m_GameBtnSp
local m_BiaoQingBtn_Sp
local m_SettingListObj
local m_CardTypePromptObj
local m_TalkObj
local m_SmallGameObj 
local m_BiaoQingBtnSp
local m_RabbitBtnSp
local m_HuLiBtnSp
local m_BiaoQingSp
local m_XiaoXiSp
local m_PingBiSp
local m_PaiXingTipSp
local m_ShangJuHuiGuSp
local m_BiaoQingPanelObj
local m_RabbitPanelObj
local m_HuLiPanelObj
local m_ChangYongYuObj
local m_PingBiXinXiObj
local m_BiaoQing_ParentObj
local m_PaiXingMessageObj
local m_ShangeJuMessageObj
local m_XieDaiDaoJuObj
local m_BiaoQingParentObj
local m_RabbitParentObj
local m_HuLiParentObj
local m_BiaoQingParent1
local m_BiaoQingParent2
local m_BiaoQingParent3
local m_AddBetBtn
local m_AddBetBtn1
local m_AddBetBtn2
local m_AddBetLab1
local m_AddBetNum 
local m_AddBtnLab
local m_BBorsbLab
local m_BetPotLab

local m_FenChiParentObj
local m_FenChiChildList = {}
local m_HeChiPot
local m_GameStep =0 
local m_JieSuanPos 
local m_BagMoneyLab
local m_PresentUid
local m_PlayerContainsMyself=false
local m_MessageError
local m_TuiChu
local m_SelectWuPinPanelObj
local m_SelectMoneyPanelObj
local m_SelectMoneyBtnObj
--内部私有
local m_PlayerIdValue ={}
local m_PoolPlayer ={}
local m_PotBig = 0
local m_MyPot = 0
local m_BetLab
local m_IsAllin = false
local m_AllNeedMoney =0
local m_AllNeedMoney1 =0
local m_PlayerNum = {}
local m_AlreadyHeChi = false 
local m_MaxBetCount =0
-- local m_PlayerUidList = {}
local m_CiShu = 0
local m_FenChiChildCount = {}
local m_FlyBetCount  = 0
local m_OwnQiPai = false
local m_PublicCards = {}
local m_IsPlaying1 = false
local m_IsQi = false 
local m_StartGame = false 
local m_FirstTime  
local m_EndTime = -10 
local m_JianGeTime = 10
local m_HaveSit = false 
local m_HolidayObj 
local m_DecorateObj
local m_GoodLuckObj
local m_FoodObj
local m_HolidayPanelSp 
local m_DecoratePanelSp
local m_GoodLuckPanelSp
local m_FoodPanelSp


local m_PresentIndex 
local m_PresentNum 
local m_PresentOtherId
local m_LanguageIndex 
local m_LanguageFirstTime =0
local m_LanguageEndTime =0
local m_IsGuo = false 
local m_BBMoney =0
local m_SBMoney =0
local m_GiftEndTime = -5
local m_MyMoney = 0

local m_HuiGuParentObj
local m_PublicCardsTopList = {}
local m_OwnCardType 
local m_PublicCardValueList = {}
local m_OwnValueList = {}
local m_AddBetSlider 
local m_PokeValue = { "2","3","4","5","6","7","8","9","10","J","Q","K","A"}
local m_AncherPos = {'Center','BottomLeft','Left','TopLeft','TopRight','Right','BottomRight'}


local m_SuoFang = 1 
local m_IsBottom = false 
local m_BetMachineVolum 
local m_MachineIsEnd = false 
local m_MachineIsRotate = false 
local m_MachineIsQi = false 
local m_MachineIsOver = false 
local m_MachineMoney =0 
local m_MachineIsAuto = false 
local m_UpdateCount = 0
local m_MaxReward =0
local m_MaxJiangLiList = {}
local m_YingQuPos
local m_WuPinIndex ={5,5,5}
local m_SelectIndex = 6
local m_YList = {0,0,0}
local m_SystemY = 0
local m_SystemChildList = {}
local m_IsShift = false 
local m_BetMoneyLab --= m_SmallGameObj.transform:FindChild('userinfo/Label'):GetComponent('UILabel')
local m_SelectTexBtnSp --= m_SmallGameObj.transform:FindChild('userinfo/AutoSelectPicture'):GetComponent('UISprite')
local m_SelectTexParent --= m_SmallGameObj.transform:FindChild('userinfo/SelectPictureParent/SPictureParent').gameObject
local m_SelectMoneySp --= m_SmallGameObj.transform:FindChild('userinfo/select_betmoney'):GetComponent('UISprite')
local m_SelectMoneyParent --= m_SmallGameObj.transform:FindChild('userinfo/SelectBetMonet/SelectBetMonet'):GetComponent('UISprite')
local m_SystemSelectTextureParent --= m_SmallGameObj.transform:FindChild('userinfo/SystemSelectPictureParent/SystemSelectPicture/SystemSelectPicture').gameObject
local m_MaxJiangLiLab  --= m_SmallGameObj.transform:FindChild('userinfo/winlabel_parent/win_label'):GetComponent('UILabel')
local m_WinLabelParentObj --=m_SmallGameObj.transform:FindChild('userinfo/winlabel_parent').gameObject
local m_ShanGuang --= m_SmallGameObj.transform:FindChild('userinfo/shan_2').gameObject
local m_WinMoneyLab --= m_SmallGameObj.transform:FindChild('userinfo/winmoney_label'):GetComponent('UILabel')
local m_LuckyObj --= m_SmallGameObj.transform:FindChild('userinfo/lucky'):GetComponent('UILabel')
local m_SelectBoardSp --= m_SmallGameObj.transform:FindChild('userinfo/Slider/board'):GetComponent('UISprite')

local m_ListParent = {}
local m_ChildList = {}

function this:ClearLuaValue( )
	print('Clear all ')
  	m_UserPlayerObj  = nil 
	m_UserPlayerCtrl = nil
	-- m_BtnBeginObj    = nil 
	-- m_BtnCallBankersObj  = nil 
	m_BtnShowObj     = nil 
	m_MsgWaitNextObj = nil 
	m_MsgWaitBetObj  =nil 
	m_ChooseChipObj  =nil 
	m_MsgQuitObj     =nil 
	m_MsgAccountFailedObj =nil 
	m_WaitPlayerObjList = {}
	m_ReadyPlayerObjList = {}
	m_PlayingPlayerObjList = {}
	m_NotQiList = {}
	m_nnPlayerName = 'DZPKPlayer_'
	m_BankerPlayerObj = nil 
  	m_UserIndex = 0
  	m_IsPlaying = false 
  	m_IsLate    = false 
 	m_IsReEnter = false 
 	m_OwnQiPai = false 
 	m_IsAllin = false 
	for k,v in pairs(playerCtrlDc) do
	    v:OnDestroy()
	end
	playerCtrlDc = {}
	coroutine.Stop()
	LuaGC()
end


function this:bindPlayerCtrl(objName, gameObj)
  playerCtrlDc[objName] = DZPKPlayerCtrl:New(gameObj)
end

function this:getPlayerCtrl(objName)
  return playerCtrlDc[objName]
end

function this:removePlayerCtrl( objName )
  if playerCtrlDc[objName] ~= nil then
    playerCtrlDc[objName]:OnDestroy() 
  end 
  playerCtrlDc[objName] = nil 
end


function this:Awake()
	log("awake of GameDZPKPanel")
    
    local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 800;
        sceneRoot.manualWidth = 1422;
	end
	
	local footInfoPrb = ResManager:LoadAsset("gamedzpk/FootInfo_DZPK","FootInfo_DZPK")


	GameObject.Instantiate(footInfoPrb)
	sceneRoot = footInfoPrb:GetComponent('UIRoot')
	if sceneRoot then 
		sceneRoot.manualHeight = 800;
        sceneRoot.manualWidth = 1422;
	end
	
	this:InitAllPre()
end

function this:Start()
	m_BGSlider.value  = SettingInfo.Instance.bgVolume
	m_YinXiaoSilder.value = SettingInfo.Instance.effectVolume

   local info = GameObject.Find("FootInfo_DZPK(Clone)");
    if info ~= nil then
        m_UserNickNameLab = info.transform:FindChild("Panel_info/Foot - Anchor/Info/Label_Nickname"):GetComponent('UILabel')
        m_UserNickNameLab_1 = info.transform:FindChild("Panel_info/Foot - Anchor/Info/Label_Nickname_1"):GetComponent('UILabel')
        m_UserBagmoneyLab = info.transform:FindChild("Panel_info/Foot - Anchor/Info/Money/Label_Bagmoney"):GetComponent('UILabel')
    end
    _isCallUpdate = true
	this.mono:StartGameSocket()
  	coroutine.start(this.UpdateInLua)
end

function this:InitAllPre()
	-- m_BtnBeginObj = this.transform:FindChild("Content/User/Button_begin").gameObject
	-- this.mono:AddClick(m_BtnBeginObj,this.UserReady)
	local tBackBtn = this.transform:FindChild('Button_back').gameObject
	this.mono:AddClick(tBackBtn,this.OnClickBack)
	m_UserPlayerObj = this.transform:FindChild('Content/User').gameObject
	m_MsgWaitBetObj  = this.transform:FindChild('Content/MsgContainer/MsgWaitBet').gameObject
	m_MsgWaitNextObj = this.transform:FindChild('Content/MsgContainer/MsgWaitNext').gameObject
	-- m_BtnCallBankersObj = this.transform:FindChild('Content/User/BtnCallBanker').gameObject
	-- m_BtnCallBankersObj.transform.localPosition = m_BtnCallBankersObj.transform.localPosition + Vector3.up*45
	m_MsgAccountFailedObj = this.transform:FindChild('Content/MsgContainer/MsgAccountFailed')
	-- local tCallBankerBtn = this.transform:FindChild("Content/User/BtnCallBanker/Button1").gameObject
	
	m_BGSlider = this.transform:FindChild('Panel_Setting/Sprite_popup_container/Label_setting/Label_bgmusic/Slider'):GetComponent('UISlider')
	m_YinXiaoSilder = this.transform:FindChild('Panel_Setting/Sprite_popup_container/Label_setting/Label_bgsound/Slider'):GetComponent('UISlider')
	
	m_Male = this.transform:FindChild('Content/talk/userinfo/changyongyu/UIGrid/Man')
	m_Female = this.transform:FindChild('Content/talk/userinfo/changyongyu/UIGrid/Woman')
	m_InputBoardSp = this.transform:FindChild('Content/talk/userinfo/input_board'):GetComponent('UISprite')
	m_SendBtnSp = this.transform:FindChild('Content/talk/userinfo/send'):GetComponent('UISprite')
	m_InputLab = this.transform:FindChild('Content/talk/userinfo/input_board/panel/input_Label'):GetComponent('UILabel')
	m_BtnsObj = m_UserPlayerObj.transform:FindChild('btns').gameObject
	m_BtnObjAuto = m_UserPlayerObj.transform:FindChild('btns_select').gameObject
	m_GenBtn = m_BtnsObj.transform:FindChild('ButtonGen').gameObject
	m_GenLab = m_GenBtn.transform:FindChild('gen_label'):GetComponent('UILabel')
	m_AllInBtn = m_BtnsObj.transform:FindChild('ButtonGen_1').gameObject
	m_AddBtn = m_BtnsObj.transform:FindChild('ButtonAddBet').gameObject
	m_AutoKanObj = m_BtnObjAuto.transform:FindChild('AutoKan').gameObject
	m_AutoFollowGenObj = m_BtnObjAuto.transform:FindChild('ButtonGen').gameObject
	m_AutoFollowAllObj = m_BtnObjAuto.transform:FindChild('FollowAllBet').gameObject
	m_AutoQiObj = m_BtnObjAuto.transform:FindChild('KanOrQi').gameObject
	m_AutoQiSp = m_AutoQiObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite')
	m_AutoFollowGenSp = m_AutoFollowGenObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite')
	m_AutoFollowAllSp = m_AutoFollowAllObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite')
	m_AutoKanSp = m_AutoKanObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite')
	m_SettingBtnSp = this.transform:FindChild('Content/btns_message/ButtonList_topDown/Sprite_bg').gameObject:GetComponent('UISprite')
	m_CardPromptSp = this.transform:FindChild('Content/btns_message/ButtonCardType/Sprite_bg').gameObject:GetComponent('UISprite')
	m_MessageTalkSp = this.transform:FindChild('Content/btns_message/ButtonMessage/Sprite_bg').gameObject:GetComponent('UISprite')
	m_GameBtnSp = this.transform:FindChild('Content/btns_message/ButtonConsole/Sprite_bg').gameObject:GetComponent('UISprite')
	m_BiaoQingBtn_Sp = this.transform:FindChild('Content/btns_message/ButtonBiaoqing/Sprite_bg').gameObject:GetComponent('UISprite')
	m_SettingListObj = this.transform:FindChild('Content/ButtonSetting').gameObject
	m_CardTypePromptObj = this.transform:FindChild('Content/cardtype_prompt').gameObject
	m_TalkObj = this.transform:FindChild('Content/talk').gameObject
	m_SmallGameObj = this.transform:FindChild('Content/smallgame').gameObject
	m_BiaoQingBtnSp= m_TalkObj.transform:FindChild('userinfo/biaoqing_panel/xiaolian'):GetComponent('UISprite')
	m_RabbitBtnSp = m_TalkObj.transform:FindChild('userinfo/biaoqing_panel/rabbit'):GetComponent('UISprite')
	m_HuLiBtnSp = m_TalkObj.transform:FindChild('userinfo/biaoqing_panel/huli'):GetComponent('UISprite')
	m_BiaoQingSp = m_TalkObj.transform:FindChild('userinfo/biaoqing'):GetComponent('UISprite')
	m_XiaoXiSp = m_TalkObj.transform:FindChild('userinfo/xiaoxi'):GetComponent('UISprite')
	m_PingBiSp = m_TalkObj.transform:FindChild('userinfo/pingbi'):GetComponent('UISprite')
	m_PaiXingTipSp = m_CardTypePromptObj.transform:FindChild('cardtype_tishi'):GetComponent('UISprite')
	m_ShangJuHuiGuSp = m_CardTypePromptObj.transform:FindChild('shangjuhuigu'):GetComponent('UISprite')
	m_BiaoQingParentObj = m_TalkObj.transform:FindChild('userinfo/biaoqing_panel/smile_biaoqing').gameObject
	m_RabbitParentObj = m_TalkObj.transform:FindChild('userinfo/biaoqing_panel/rabbit_biaoqing').gameObject
	m_HuLiParentObj = m_TalkObj.transform:FindChild('userinfo/biaoqing_panel/huli_biaoqing').gameObject
	m_BiaoQingParent1 = m_BiaoQingParentObj.transform:FindChild('smile_biaoqing/UIGrid').gameObject
	m_BiaoQingParent2 = m_RabbitParentObj.transform:FindChild('rabbit_biaoqing/UIGrid').gameObject
	m_BiaoQingParent3 = m_HuLiParentObj.transform:FindChild('huli_biaoqing/UIGrid').gameObject
	m_AddBetBtn = m_BtnsObj.transform:FindChild('ButtonAddBet').gameObject
	m_AddBetBtn1 = m_BtnsObj.transform:FindChild('ButtonAddBet_1').gameObject
	m_AddBetBtn2 = m_BtnsObj.transform:FindChild('ButtonAddBet_2').gameObject
	m_AddBetLab1 = m_AddBetBtn1.transform:FindChild('Sprite_bg/Label'):GetComponent('UILabel')
	m_BBorsbLab = this.transform:FindChild('Panel_background/Sprite5_glow_black/sb_label'):GetComponent('UILabel')
	m_BetPotLab = this.transform:FindChild('Panel_background/Sprite5_glow_black/Sprite_dichi/betpot'):GetComponent('UILabel')
	m_FenChiParentObj = this.transform:FindChild('Panel_background/Sprite5_glow_black/Sprite_bianchi/fenchi').gameObject
	m_FenChiChildList = {}
	for i=1,7 do
	 	local tObj = m_FenChiParentObj.transform:FindChild('fenchi_'..i).gameObject
	 	table.insert(m_FenChiChildList,tObj)
	end

	local tObj = this.transform:FindChild('Panel_background/Sprite5_glow_black/Sprite_bianchi/target_jieshu_7')
	m_JieSuanPos = {}
	table.insert(m_JieSuanPos,tObj)
	for i=1,6 do
		tObj = this.transform:FindChild('Panel_background/Sprite5_glow_black/Sprite_bianchi/target_jieshu_'..i)
		table.insert(m_JieSuanPos,tObj)
	end
	m_BagMoneyLab = this.transform:FindChild('Content/xiedaidaoju/userinfo/daoju/bagmoney_label'):GetComponent('UILabel')
	m_MessageError = this.transform:FindChild('Content/MsgContainer/MsgError').gameObject
	m_TuiChu = this.transform:FindChild('Content/tuichu').gameObject
	
	this:InitPre()
end

function this:InitPre( )
	m_SelectMoneyPanelObj = m_SmallGameObj.transform:FindChild('userinfo/SelectBetMonet/SelectBetMonet').gameObject
	m_SelectMoneyBtnObj = m_SmallGameObj.transform:FindChild('userinfo/select_betmoney').gameObject
	m_HolidayObj = this.transform:FindChild('Content/xiedaidaoju/userinfo/holiday').gameObject
	m_DecorateObj = this.transform:FindChild('Content/xiedaidaoju/userinfo/decorate').gameObject
	m_GoodLuckObj = this.transform:FindChild('Content/xiedaidaoju/userinfo/goodluck').gameObject
	m_FoodObj = this.transform:FindChild('Content/xiedaidaoju/userinfo/food').gameObject
	m_GoodLuckPanelSp = this.transform:FindChild('Content/xiedaidaoju/userinfo/daoju/jixiang'):GetComponent('UISprite')
	m_DecoratePanelSp = this.transform:FindChild('Content/xiedaidaoju/userinfo/daoju/decorate'):GetComponent('UISprite')
	m_HolidayPanelSp = this.transform:FindChild('Content/xiedaidaoju/userinfo/daoju/holidays'):GetComponent('UISprite')
	m_FoodPanelSp = this.transform:FindChild('Content/xiedaidaoju/userinfo/daoju/food'):GetComponent('UISprite')
	m_SelectWuPinPanelObj = m_SmallGameObj.transform:FindChild('userinfo/SelectPictureParent/SPictureParent').gameObject
	m_AddBetObj = this.transform:FindChild('Content/jiazhu').gameObject
	m_XieDaiDaoJuObj = this.transform:FindChild('Content/xiedaidaoju').gameObject
	m_ShangeJuMessageObj = m_CardTypePromptObj.transform:FindChild('cardtype_guize').gameObject
	m_AllInSp = m_AddBetObj.transform:FindChild('userinfo/all_in').gameObject:GetComponent('UISprite')
	m_OnceSp = m_AddBetObj.transform:FindChild('userinfo/onebei').gameObject:GetComponent('UISprite')
	m_TwiceOrTripleSp = m_AddBetObj.transform:FindChild('userinfo/dichibeishu/ersanbei').gameObject:GetComponent('UISprite')
	m_OnceOrTwiceSp = m_AddBetObj.transform:FindChild('userinfo/dichibeishu/yierbei').gameObject:GetComponent('UISprite')
	m_DoubleThreeSp =  m_AddBetObj.transform:FindChild('userinfo/bb_bet/double_3').gameObject:GetComponent('UISprite')
	m_DoubleFourSp =  m_AddBetObj.transform:FindChild('userinfo/bb_bet/double_4').gameObject:GetComponent('UISprite')
	m_AddBetSlider = m_AddBetObj.transform:FindChild('userinfo/Slider'):GetComponent('UISlider')
	m_HuiGuParentObj = m_ShangeJuMessageObj.transform:FindChild('changyongyu/UIGrid').gameObject
	local tParent = m_ShangeJuMessageObj.transform:FindChild('Cards').gameObject
	m_PublicCardsTopList = {}
	for i=1,5 do 
		local tObj = tParent.transform:FindChild('card_'..(i-1)):GetComponent('UISprite')
		table.insert(m_PublicCardsTopList,tObj)
	end
	m_DiChiBeiShuObj = m_AddBetObj.transform:FindChild('userinfo/dichibeishu').gameObject
	m_BBBetObj = m_AddBetObj.transform:FindChild('userinfo/bb_bet').gameObject
	m_BetLab =  m_AddBetObj.transform:FindChild('userinfo/addbet_money').gameObject:GetComponent('UILabel')
	m_PaiXingMessageObj = m_CardTypePromptObj.transform:FindChild('cardtype_shili').gameObject  
	m_BiaoQing_ParentObj = m_TalkObj.transform:FindChild('userinfo/biaoqing_panel').gameObject
	m_RabbitPanelObj = m_BiaoQing_ParentObj.transform:FindChild('rabbit_biaoqing').gameObject
	m_HuLiPanelObj =  m_BiaoQing_ParentObj.transform:FindChild('huli_biaoqing').gameObject
	m_ChangYongYuObj = m_TalkObj.transform:FindChild('userinfo/changyongyu').gameObject
 	m_PingBiXinXiObj = m_TalkObj.transform:FindChild('userinfo/pingbi').gameObject
 	m_BetMachineVolum = m_SmallGameObj.transform:FindChild('userinfo/Slider'):GetComponent('UISlider')
	m_BetMoneyLab = m_SmallGameObj.transform:FindChild('userinfo/Label'):GetComponent('UILabel')
	 m_SelectTexBtnSp = m_SmallGameObj.transform:FindChild('userinfo/AutoSelectPicture'):GetComponent('UISprite')
	 m_SelectTexParent = m_SmallGameObj.transform:FindChild('userinfo/SelectPictureParent/SPictureParent').gameObject
	 m_SelectMoneySp = m_SmallGameObj.transform:FindChild('userinfo/select_betmoney'):GetComponent('UISprite')
	 m_SelectMoneyParent = m_SmallGameObj.transform:FindChild('userinfo/SelectBetMonet/SelectBetMonet'):GetComponent('UISprite')
	 m_SystemSelectTextureParent = m_SmallGameObj.transform:FindChild('userinfo/SystemSelectPictureParent/SystemSelectPicture/SystemSelectPicture').gameObject
	 m_MaxJiangLiLab  = m_SmallGameObj.transform:FindChild('userinfo/winlabel_parent/win_label'):GetComponent('UILabel')
	 m_WinLabelParentObj =m_SmallGameObj.transform:FindChild('userinfo/winlabel_parent').gameObject
	 m_ShanGuang = m_SmallGameObj.transform:FindChild('userinfo/shan_2').gameObject
	 m_WinMoneyLab = m_SmallGameObj.transform:FindChild('userinfo/winmoney_label'):GetComponent('UILabel')
	 m_LuckyObj = m_SmallGameObj.transform:FindChild('userinfo/lucky').gameObject --:GetComponent('UILabel')
	 m_SelectBoardSp = m_SmallGameObj.transform:FindChild('userinfo/Slider/board'):GetComponent('UISprite')
	 m_AutoBetSp = m_SmallGameObj.transform:FindChild('userinfo/checkbox'):GetComponent('UISprite')
	 m_BiaoQingPanelObj = m_BiaoQingParentObj
	 m_SelectTexParentList = m_SelectTexParent.transform:FindChild('listParent/List').gameObject
	
	 m_ListParent = {}
	 m_ChildList = {}
	 for i=1,3 do 
	 	local tObj = m_SmallGameObj.transform:FindChild('userinfo/listparent/List_'..i).gameObject
	 	table.insert(m_ListParent,tObj)
	 	local tChildList = {}
	 	for j =1,4 do 
	 		local tChild = tObj.transform:FindChild('child_'..j).gameObject
	 		table.insert(tChildList,tChild)
	 	end
	 	table.insert(m_ChildList,tChildList)
	 end

	 m_SystemChildList = {}

	 for i=1,2 do 
	 	local tObj = m_SystemSelectTextureParent.transform:FindChild('child_'..i).gameObject
	 	table.insert(m_SystemChildList,tObj)
	 end


	this:InitBtnFunc()
end

function this:InitBtnFunc(  )
	local tBtnMessageGroup = this.transform:FindChild('Content/btns_message').gameObject
	this.mono:AddClick(tBtnMessageGroup.transform:FindChild('ButtonList_topleft/Sprite_bg').gameObject,function()
		m_TuiChu:SetActive(true)
	end)
	this.mono:AddClick(m_TuiChu.transform:FindChild('mark').gameObject,function ()
		this:CloseMarkView()
	end)
	this.mono:AddClick(m_TalkObj.transform:FindChild('mark').gameObject,function ( )
		this:CloseMarkView()
	end)
	this.mono:AddClick(m_CardTypePromptObj.transform:FindChild('mark').gameObject,function ()
		this:CloseMarkView()
	end)
	local tBtn = m_TuiChu.transform:FindChild('userinfo/cancelbtn').gameObject
	this.mono:AddClick(tBtn,function( )
		this:Close(tBtn)
	end)
	this.mono:AddClick(m_TuiChu.transform:FindChild('userinfo/surebtn').gameObject,function (  )
		this:OnClickBack()
	end)
	--左下角1
	this.mono:AddClick(tBtnMessageGroup.transform:FindChild('ButtonCardType/Sprite_bg').gameObject,function ( )
		m_CardTypePromptObj.transform.localScale = Vector3.one
		m_CardTypePromptObj:SetActive(true)
		m_PaiXingMessageObj:SetActive(true)
		if m_StartGame ==false then
			m_ShangJuHuiGuSp:GetComponent('BoxCollider').enabled = false 
		else
			m_ShangJuHuiGuSp:GetComponent('BoxCollider').enabled = true 
		end
		m_ShangeJuMessageObj:SetActive(false)
		m_PaiXingTipSp.spriteName = 'cardtype_prompt_click'
		m_ShangJuHuiGuSp.spriteName = 'forward'
		m_CardPromptSp.spriteName = 'cardtype_click'
	end)
	--2
	this.mono:AddClick(tBtnMessageGroup.transform:FindChild('ButtonMessage/Sprite_bg').gameObject,function ( )
		m_TalkObj:SetActive(true)
		m_BiaoQingParentObj:SetActive(true)
		m_BiaoQing_ParentObj:SetActive(true)
		m_BiaoQingSp.spriteName= 'biaoqing_click'
		m_XiaoXiSp.spriteName = 'chat'
		m_BiaoQingPanelObj:SetActive(true)
		m_RabbitPanelObj:SetActive(false )
		m_HuLiPanelObj:SetActive(false)
		m_ChangYongYuObj:SetActive(false)
		m_MessageTalkSp.spriteName = 'message_click'
		m_InputLab.text = ''
		m_InputBoardSp.gameObject:SetActive(false)
		m_SendBtnSp.gameObject:SetActive(false)
	end)
	
	this.mono:AddClick(m_GameBtnSp.gameObject,function ( )
		m_SmallGameObj.transform.localScale = Vector3.one
		m_SmallGameObj:SetActive(true)
		m_GameBtnSp.spriteName = 'console_click'
	end)
	-- this.mono:AddClick()
	local tPanelSetting = this.transform:FindChild('Panel_Setting/Sprite_popup_container/Label_setting')
	this.mono:AddClick(tPanelSetting:FindChild('Label_special/Button_special').gameObject,function ( )
		 local tSp = tPanelSetting:FindChild('Label_special/Button_special/Background'):GetComponent('UISprite')
		 if tSp.spriteName == "off_2" then
        
            tSp.spriteName = "on_2";
            SettingInfo.Instance.specialEfficacy = true;
        else
            tSp.spriteName = "off_2"
            SettingInfo.Instance.specialEfficacy = false;
        end
	end)
	this.mono:AddClick(tPanelSetting:FindChild('Label_autonext/Button_autonext').gameObject,function ( )
		 local tSp = tPanelSetting:FindChild('Label_autonext/Button_autonext/Background'):GetComponent('UISprite')
		 if tSp.spriteName == "off_2" then
            tSp.spriteName = "on_2";
            SettingInfo.Instance.autoNext = true;
        else
            tSp.spriteName = "off_2"
            SettingInfo.Instance.autoNext = false;
        end
	end)

	this.mono:AddClick(m_GoodLuckPanelSp.gameObject,function (  )
		m_HolidayPanelSp.spriteName = 'holiday'
		m_DecoratePanelSp.spriteName = 'decorate'
		m_GoodLuckPanelSp.spriteName = 'lucky_select'
		m_FoodPanelSp.spriteName = 'food'
		m_HolidayObj:SetActive(false)
		m_DecorateObj:SetActive(false)
		m_GoodLuckObj:SetActive(true)
		m_FoodObj:SetActive(false)
		if m_GoodLuckObj.activeSelf == true then
			for i=1,8 do 
				m_GoodLuckObj.transform:FindChild('goodluck_'..i).gameObject:GetComponent('UISprite').spriteName = 'daojuboard'
			end
		end

	end)
	this.mono:AddClick(m_FoodPanelSp.gameObject,function (  )
		m_HolidayPanelSp.spriteName = 'holiday'
		m_DecoratePanelSp.spriteName = 'decorate'
		m_GoodLuckPanelSp.spriteName = 'lucky'
		m_FoodPanelSp.spriteName = 'food_select'
		m_HolidayObj:SetActive(false)
		m_DecorateObj:SetActive(false)
		m_GoodLuckObj:SetActive(false)
		m_FoodObj:SetActive(true)
		if m_FoodObj.activeSelf == true then
			for i=1,8 do 
				m_FoodObj.transform:FindChild('food_'..i).gameObject:GetComponent('UISprite').spriteName = 'daojuboard'
			end
		end
	end)
	this.mono:AddClick(m_DecoratePanelSp.gameObject,function (  )
		m_HolidayPanelSp.spriteName = 'holiday'
		m_DecoratePanelSp.spriteName = 'decorate_select'
		m_GoodLuckPanelSp.spriteName = 'lucky'
		m_FoodPanelSp.spriteName = 'food'
		m_HolidayObj:SetActive(false)
		m_DecorateObj:SetActive(true)
		m_GoodLuckObj:SetActive(false)
		m_FoodObj:SetActive(false)
		if m_DecorateObj.activeSelf == true then
			for i=1,8 do 
				m_DecorateObj.transform:FindChild('decorate_'..i).gameObject:GetComponent('UISprite').spriteName = 'daojuboard'
			end
		end
	end)
	this.mono:AddClick(m_HolidayPanelSp.gameObject,function (  )
		m_HolidayPanelSp.spriteName = 'holiday_select'
		m_DecoratePanelSp.spriteName = 'decorate'
		m_GoodLuckPanelSp.spriteName = 'lucky'
		m_FoodPanelSp.spriteName = 'food'
		m_HolidayObj:SetActive(true)
		m_DecorateObj:SetActive(false)
		m_GoodLuckObj:SetActive(false)
		m_FoodObj:SetActive(false)
		if m_HolidayObj.activeSelf == true then
			for i=1,8 do 
				m_HolidayObj.transform:FindChild('holiday_'..i).gameObject:GetComponent('UISprite').spriteName = 'daojuboard'
			end
		end
	end)

	this.mono:AddClick(m_BtnsObj.transform:FindChild('ButtonQi').gameObject,function ()
		this:UserQi()
	end)
	this.mono:AddClick(m_BtnsObj.transform:FindChild('ButtonGen').gameObject,function ()
		this:UserGen()
	end)
	this.mono:AddClick(m_BtnsObj.transform:FindChild('ButtonAddBet').gameObject,function ()
		this:UserAdd()
	end)
	this.mono:AddClick(m_AutoQiObj,function ()
		this:AutoSelect(m_AutoQiObj)
	end)
	this.mono:AddClick(m_AutoFollowGenObj,function ()
		this:AutoSelect(m_AutoFollowGenObj)
	end)
	this.mono:AddClick(m_AutoFollowAllObj,function ()
		this:AutoSelect(m_AutoFollowAllObj)
	end)
	this.mono:AddSlider(m_AddBetSlider,function ( )
		this:SetBetBgVolume()
	end)
	this.mono:AddClick(m_AddBetBtn1,function (  )
		this:SendAddMoney(m_AddBetBtn1)
	end)
	this.mono:AddClick(m_PaiXingTipSp.gameObject,function (  )
		m_PaiXingTipSp.spriteName = 'cardtype_prompt_click'
		m_ShangJuHuiGuSp.spriteName = 'forward'
		m_PaiXingMessageObj:SetActive(true)
		m_ShangeJuMessageObj:SetActive(false)
		m_ShangeJuMessageObj.transform.localScale = Vector3.one

	end)
	this.mono:AddClick(m_ShangJuHuiGuSp.gameObject,function ( )
		m_PaiXingTipSp.spriteName = 'cardtype_prompt'
		m_ShangJuHuiGuSp.spriteName = 'forward_click'
		m_PaiXingMessageObj:SetActive(false)
		m_ShangeJuMessageObj:SetActive(true)
		m_ShangeJuMessageObj.transform.localScale = Vector3.one
	end)
	this.mono:AddClick(m_BiaoQingSp.gameObject,function ( )
		m_BiaoQingSp.spriteName = 'biaoqing_click'
		m_XiaoXiSp.spriteName = 'chat'
		m_PingBiSp.spriteName = 'nearest'
		m_BiaoQing_ParentObj:SetActive(true)
		m_ChangYongYuObj:SetActive(false)
		m_PingBiXinXiObj:SetActive(false)
		m_InputBoardSp.gameObject:SetActive(false)
		m_SendBtnSp.gameObject:SetActive(false)
	end)
	this.mono:AddClick(m_PingBiSp.gameObject,function ()
		m_BiaoQingSp.spriteName = 'biaoqing'
		m_XiaoXiSp.spriteName = 'chat'
		m_PingBiSp.spriteName = 'nearest_click'
		m_BiaoQing_ParentObj:SetActive(false)
		m_ChangYongYuObj:SetActive(false)
		m_PingBiXinXiObj:SetActive(true)
	end)
	this.mono:AddClick(m_XiaoXiSp.gameObject,function ( )
		m_BiaoQingSp.spriteName = 'biaoqing'
		m_XiaoXiSp.spriteName = 'chat_click'
		m_PingBiSp.spriteName = 'nearest'
		m_BiaoQing_ParentObj:SetActive(false)
		m_PingBiXinXiObj:SetActive(false)
		m_ChangYongYuObj:SetActive(true)
		m_InputBoardSp.gameObject:SetActive(true)
		m_SendBtnSp.gameObject:SetActive(true)
	end)

	this.mono:AddClick(m_AllInSp.gameObject,function ()
		-- this:DiChiAddBet(m_AllInSp.gameObject)
		this:UserAllIn()
	end)
	this.mono:AddClick(m_TwiceOrTripleSp.gameObject,function ()
		this:DiChiAddBet(m_TwiceOrTripleSp.gameObject)
	end)
	this.mono:AddClick(m_OnceOrTwiceSp.gameObject,function ()
		this:DiChiAddBet(m_OnceOrTwiceSp.gameObject)
	end)
	this.mono:AddClick(m_DoubleFourSp.gameObject,function ()
		this:DiChiAddBet(m_DoubleFourSp.gameObject)
	end)

	for i=1,6 do 
		local tObj = m_HolidayObj.transform:FindChild('holiday_'..i).gameObject 
		this.mono:AddClick(tObj,function ( )
			this:SendGift(tObj)
		end)
	end
	for i=1,7 do 
		local tObj = m_DecorateObj.transform:FindChild('decorate_'..i).gameObject 
		this.mono:AddClick(tObj,function ( )
			this:SendGift(tObj)
		end)
	end
	for i=1,8 do 
		local tObj = m_GoodLuckObj.transform:FindChild('goodluck_'..i).gameObject 
		this.mono:AddClick(tObj,function ( )
			this:SendGift(tObj)
		end)
		local tObj = m_FoodObj.transform:FindChild('food_'..i).gameObject 
		this.mono:AddClick(tObj,function ( )
			this:SendGift(tObj)
		end)
	end
	this.mono:AddClick(m_BiaoQingBtnSp.gameObject,function ( )
		m_BiaoQingPanelObj:SetActive(true)
		m_RabbitPanelObj:SetActive(false)
		m_HuLiPanelObj:SetActive(false)
	end)
	this.mono:AddClick(m_RabbitBtnSp.gameObject,function ( )
		m_BiaoQingPanelObj:SetActive(false)
		m_RabbitPanelObj:SetActive(true)
		m_HuLiPanelObj:SetActive(false)
	end)
	this.mono:AddClick(m_HuLiBtnSp.gameObject,function ( )
		m_BiaoQingPanelObj:SetActive(false)
		m_RabbitPanelObj:SetActive(false)
		m_HuLiPanelObj:SetActive(true)
	end)


	for i=1,27 do 
		local tEmotion = m_BiaoQingParent1.transform:FindChild('biaoqing_'..i).gameObject
		this.mono:AddClick(tEmotion,function ( )
			this:OnSetBiaoQing(tEmotion)
		end)
	end
	for i=1,31 do 
		local tEmotion = m_BiaoQingParent2.transform:FindChild('biaoqing_'..i).gameObject
		this.mono:AddClick(tEmotion,function ( )
			this:OnSetBiaoQing(tEmotion)
		end)
	end

	for i=1,11 do 
		local tEmotion = m_BiaoQingParent3.transform:FindChild('biaoqing_'..i).gameObject
		this.mono:AddClick(tEmotion,function ( )
			this:OnSetBiaoQing(tEmotion)
		end)
	end

	for i=1,15 do
		local tLanguage 
		if i <8 then
			tLanguage = m_Male.transform:FindChild('label_'..i).gameObject
		else
			 tLanguage = m_Female.transform:FindChild('label_'..i).gameObject
		end
		this.mono:AddClick(tLanguage,function ()
			this:OnSendLanguage(tLanguage)
		end)
	end
	this.mono:AddClick(m_SendBtnSp.gameObject,function (  )
		this:OnSendLanguageIndex()
	end)
	this.mono:AddClick(m_SmallGameObj.transform:FindChild('userinfo/close').gameObject,function ( )
		this:CloseLaoHuJi()
	end)

	this.mono:AddClick(m_AutoKanObj,function (  )
		this:AutoSelect(m_AutoKanObj)
	end)
	this.mono:AddClick(m_AddBetBtn2,function (  )
		this:UserAllIn()
	end)
	this.mono:AddClick(m_OnceSp.gameObject,function ( )
		this:DiChiAddBet(m_OnceSp.gameObject)
	end)
	this:InitBetMachine( )
end


function this:UpdateInLua()
	while(this.mono) do
    for k,v in pairs(playerCtrlDc) do
      if(v == nil)then
        print("?????")
      else
        v:UpdateInLua()
      end
    end
    if m_MachineIsAuto == true then 
    	m_UpdateCount = m_UpdateCount +1
    	if m_UpdateCount%3 == 0 then 
    		this:ZiDong()
    	end

    end
    if m_SmallGameObj.activeSelf == true then
    	this:ChangeChildPosition()
    	this:ChangeChildPosition_1()
    end

   

    coroutine.wait(0.02	)
  end
end

local m_MessageList  = {
	['enter'] = function (pM)
		this:ProcessEnter(pM)
	end,
	['ready'] = function (pM)
		this:ProcessReady(pM)
	end,
	['come'] = function (pM)
		this:ProcessCome(pM)
	end,
	['leave'] = function ( pM)
		this:ProcessLeave(pM)
	end,
	['deskover'] = function ( pM )
		this:ProcessDeskOver(pM)
	end,
	['notcontinue'] = function ( pM )
		coroutine.start(this.ProcessNotcontinue)
	end,
	['emotion'] = function (pM )
		this:ProcessGameEmotion(pM)
	end,
	['buy_prop_success'] = function ( pM )
		this:ProcessGameBuySuccess(pM)
	end,
	['buy_prop_error'] = function ( pM)
		this:ProcessGameBuyError(pM)
	end,
	['buy_prop_fail_nomoney'] = function ( pM)
		this:ProcessGameBuyNoMoney(pM)
	end,
	['hurry'] = function ( pM)
		this:ProcessHurry(pM)	
	end,
	['gamble_error'] = function ( pM)
		this:ProcessGamble_ChipError(pM)
	end,
	['gamble'] = function ( pM)
		this:ProcessGameLB(pM)
	end,
}

local m_HoldemMessage = {
	['update'] = function (pM )
		this:ProcessUpdate(pM)
	end,
	['deal'] = function (pM )
		this:ProcessRun(pM)
	end,
	['bet'] = function (pM )
		this:ProcessBetMoney(pM)
	end,
	['newround'] = function (pM )
		this:ProcessNewRound(pM)
	end,
	['gonext'] = function (pM )
		this:ProcessGoNext(pM)
	end,
	['fold'] = function (pM )
		this:ProcessQiPai(pM)
	end,
	['gameover'] = function (pM )
		print(' socket    process game over  ')
		this:ProcessGameOver(pM,nil)
	end,
	['showcards'] = function (pM )
		this:ProcessShowCards(pM)
	end,
	['gamble_error'] = function (pM )
		this:ProcessGamble_Error(pM)
	end,
}

function this:SocketReceiveMessage(pMessage )
	local msgStr = self
  	local cjson = require "cjson"
  	local msgData = cjson.decode(msgStr)
  	if msgStr == nil then 
  		return
  	end

  	local type1 = msgData["type"]
  	if type1 == nil then
  		print('socket receive message  type is nil ' .. type1)
  		return
  	end
  	local tag   = msgData["tag"]
  	
  	

  	if type1 == 'game' then
  		-- print('===========receive message ===================')
  		-- print(cjson.encode(msgData)) 
  		if m_MessageList[tag] ~= nil then
  			m_MessageList[tag](msgData)
  		else
  			print(tag)
  		end
  		
  	elseif type1 == 'account' then
  		if tag == 'update_intomoney' then
  			-- print('update_intomoney')
  		end
  	elseif type1 == 'holdem' then
		-- print(tag) 
		m_HoldemMessage[tag](msgData)
  	elseif type1 == 'seatmatch' then
  		-- print(tag)
  		if tag == 'on_update' then
  			this:ProcessUpdateAllIntomoney(msgData)
  		end
  	end
end



function this:ProcessRun( pMessage)
	-- print('process Run')
	for i=1,7 do 
		for j=1,15 do 
			m_FenChiChildList[i].transform:FindChild('Sprite_'..j):GetComponent('UISprite').alpha = 0 
			m_FenChiChildList[i].transform:FindChild('Sprite_bianchi'):GetComponent('UISprite').alpha = 0 
			m_FenChiChildList[i].transform:FindChild('hechipot'):GetComponent('UILabel').text = '' 
		end
	end
	--change topBureaureview 
	m_PublicCardValueList = {}
	local tBody = pMessage['body']
	local tChip = tBody['chip_moneys']
	local tOwnCards = tBody['mycards']
	local tDmuid = tonumber(tBody['bb'])
	local tXmuid = tonumber(tBody['sb'])
	local tDichi = tonumber(tBody['pot'])
	local tThisOne = tonumber(tBody['thisone'])
	local tBanker = tonumber(tBody['banker'])
	m_BetPotLab.text = '底池：'..tDichi
	m_HeChiPot =  tDichi
	mJu_time = tonumber(tBody['timeout'])
	--change topBureaureview

	this:SetOwnCards(tOwnCards)
	local tBankerPlayer = find(m_nnPlayerName..tostring(tBanker))

	this:getPlayerCtrl(tBankerPlayer.name):SetBanker(true)
	local tDmPlayer = find(m_nnPlayerName..tDmuid)
	this:getPlayerCtrl(tDmPlayer.name):SetBetInfo('大盲注')
	local tXmPlayer = find(m_nnPlayerName..tXmuid)
	this:getPlayerCtrl(tXmPlayer.name):SetBetInfo('小盲注')
	for i =1, #tChip do 
		local tUid = tostring(tChip[i][1])
		local tPlayer = find(m_nnPlayerName..tUid)
		local tCtrl = this:getPlayerCtrl(tPlayer.name)
		if tableContains(m_WaitPlayerObjList,tPlayer) == true then
			
			tableRemove(m_WaitPlayerObjList,tPlayer)	
		end
		if tableContains(m_PlayingPlayerObjList,tPlayer) == false then
			table.insert(m_PlayingPlayerObjList,tPlayer)
		end
		if tableContains(m_NotQiList,tPlayer) == false then
			table.insert(m_NotQiList,tPlayer)
		end
		local tBagMoney = tonumber(tChip[i][2])
		local tMoneyCount = tonumber(tChip[i][3])
		m_PlayerIdValue[tonumber(tUid)] = tMoneyCount
		 -- table.insert(m_PlayerIdValue,tMoneyCount)
		 table.insert(m_PoolPlayer,tUid)
		if tUid ~= tostring(tDmuid) and tUid ~= tostring(tXmuid) then
		 	tCtrl:SetStartInfoName()
		end
		tCtrl:SetStartInfo(tBagMoney)
		if tMoneyCount > tonumber(m_PotBig) then
			m_PotBig = tMoneyCount
		end
		if tUid == tostring(EginUser.Instance.uid) then
			m_MyPot = tMoneyCount
		end
		tCtrl:SetBet(-1,-1,tMoneyCount,tMoneyCount,-1,tBagMoney)
		tCtrl:SetChuShiMoney(tBagMoney,tMoneyCount)
	end

	local tV = 0.5
	local tTime = 0.2
	local tTemp = 0
	local tTempt =0 
	
	for i=1,#tChip do 
		local tNum = i
		tTemp = tV
		coroutine.start(function (  )
			coroutine.wait(tTemp+1)
			local tObj =find(m_nnPlayerName..tostring(tChip[tNum][1]))
			if tObj ~= nil then
				this:getPlayerCtrl(tObj.name):SetOther(1)
			end
		end)
		tV = tV +0.2
	end
	
	coroutine.start(function (  )
		coroutine.wait(tTemp+1)
		coroutine.start(function (  )
			for i=1,#tChip do 
				local tNumb = i
				tTempt = tTime
				-- coroutine.start(function (  )
					coroutine.wait(0.2)
					local tObj = find(m_nnPlayerName..tostring(tChip[tNumb][1]))
					if tObj ~= nil then
						this:getPlayerCtrl(tObj.name):SetOther(2)
					end
				-- end)
				tTime = tTime +0.2
			end
		-- end)
		-- coroutine.start(function (  )
			coroutine.wait(tTempt +0.5)
			local tUser = find(m_nnPlayerName.. EginUser.Instance.uid )
			if tUser ~= nil then
				this:getPlayerCtrl(tUser.name):SetCardAnimation(tOwnCards)
			end
		end)
	end)
	coroutine.start(function (  )
		coroutine.wait(tTempt+tTemp + 1.7)
		local tPlayThisOne = find(m_nnPlayerName..tThisOne)
		this:getPlayerCtrl(tPlayThisOne.name):SetTime()
	end)
	local tPlayingPlayer = find(m_nnPlayerName..EginUser.Instance.uid)
	if tableContains(m_PlayingPlayerObjList,tPlayingPlayer) == true then
		m_PlayerContainsMyself = true
		m_IsPlaying1 = true
		m_BtnObjAuto:SetActive(true)
		if m_MyPot == m_PotBig then
			m_AutoKanObj:SetActive(true)
			m_AutoFollowGenObj:SetActive(false)
		elseif m_MyPot < m_PotBig then
			m_AutoFollowGenObj:SetActive(true)
			m_AutoKanObj:SetActive(false)
			m_AutoFollowGenObj.transform:FindChild('gen_label'):GetComponent('UILabel').text = '跟注'..tostring((m_PotBig- m_MyPot))
		end
	else
		m_IsPlaying1 = false
		m_BtnObjAuto:SetActive(false)
		this:AutoButtonReset()
	end
	if tostring(tThisOne) == tostring(EginUser.Instance.uid) then
		if m_MyPot < m_PotBig then
			local tM = m_PotBig - m_MyPot
			m_GenLab.text = '跟注'.. tM
		elseif m_MyPot == m_PotBig then
			m_BetLab.text = '过牌'
		end
		-- print('in run ')
		m_BtnsObj:SetActive(true)
		m_BtnObjAuto:SetActive(false)
		this:AutoButtonReset()
	else
		m_BtnsObj:SetActive(false)
		m_BtnObjAuto:SetActive(true)
		if m_MyPot == m_PotBig then
			m_AutoKanObj:SetActive(true)
			m_AutoFollowGenObj:SetActive(false)
		elseif m_MyPot < m_PotBig then
			m_AutoKanObj:SetActive(false)
			m_AutoFollowGenObj:SetActive(true)
			m_AutoFollowGenObj.transform:FindChild('gen_label'):GetComponent('UILabel').text = '跟注'..tostring((m_PotBig- m_MyPot))
		end
	end
end

function this:ProcessBetMoney(pMessage  )
	-- print('porcess   bet  mone y ')
	local tBody  = pMessage['body']
	local tRoomMoney = tonumber(tBody['roommoney'])
	local tFollowMoney= tonumber(tBody['followmoney'])
	local tPot = tonumber(tBody['pot'])
	local tThisOne = tonumber(tBody['thisone'])
	local tAddMoney = tonumber(tBody['addmoney'])
	local tRaiser = tonumber(tBody['raiser'])
	local tChipMoney = tonumber(tBody['chipmoney'])
	m_BetPotLab.text = '底池：'..tostring(tPot)
	m_HeChiPot = tPot
	
	if m_PlayerIdValue[tThisOne] == nil then
		m_PlayerIdValue[tThisOne] = tChipMoney
	else
		if tonumber(m_PlayerIdValue[tThisOne]) < tChipMoney then
			m_PlayerIdValue[tThisOne] = tChipMoney
		end
	end


	local tUpPlayer = find(m_nnPlayerName..tostring(tThisOne))
	this:getPlayerCtrl(tUpPlayer.name):SetCancelTime()
	if tFollowMoney > m_PotBig then
		m_PotBig = tFollowMoney
	end
	if tostring(tThisOne) == tostring(EginUser.Instance.uid)  then
		m_MyPot = tChipMoney
		if  m_IsAllin ==true then
			m_BtnObjAuto:SetActive(false)
		else
			if m_BtnObjAuto.activeSelf == false then
				m_BtnObjAuto:SetActive(true)
				m_AutoFollowGenObj:SetActive(false)
				m_AutoKanObj:SetActive(true)
			end
		end
	else
		m_AllNeedMoney = m_PotBig - m_MyPot
		if m_AllNeedMoney > m_AllNeedMoney1 then
			if this:NextIsMyself(tThisOne) == false then
				if m_AutoKanObj.activeSelf  == false then 
					if m_AutoKanObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName == 'automatic_seecard_click' then
					 	m_AutoKanObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName ='automatic_seecard'
					end
					m_AutoFollowGenObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName = 'follow'
					m_AutoKanObj:SetActive(false)
					m_AutoFollowGenObj:SetActive(true)
					m_AutoFollowGenObj.transform:FindChild('gen_label'):GetComponent('UILabel').text = '跟注'..m_AllNeedMoney
				end
			else
				if m_AutoFollowAllObj.activeSelf == true and  m_AutoFollowAllObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName == 'follow_allbet_click' then
					m_BtnObjAuto:SetActive(true)
				elseif m_AutoFollowGenObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName == 'follow_select' then
					 m_AutoFollowGenObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName = 'follow'
					m_BtnObjAuto:SetActive(false)
				else
					m_BtnObjAuto:SetActive(false)
				end
			end
		end
	end
	local tZhuangTai = 0 
	if tostring(tThisOne) == tostring(tRaiser) then
		tZhuangTai = 4 
	else
		tZhuangTai = 3 
	end
	if tRoomMoney ==0 then
		tZhuangTai = 5 
	end
	if tAddMoney == 0 then
		tZhuangTai = 2 
	end

	local tCtrl = this:getPlayerCtrl(m_nnPlayerName..tThisOne)
	local tSex = tCtrl:GetSex() 
	tCtrl:SetBet(tSex,tThisOne,tFollowMoney,tAddMoney,tZhuangTai,tRoomMoney)
end


function this:NextIsMyself(pThisOne)
	-- print('Next is me   ')
	local tBetUid =0
	local tNextIsMe = false 
	for i=1,#m_PlayerNum do 
		if tonumber(m_PlayerNum[i]) == tonumber(pThisOne) then
			tBetUid = i
			break
		end
	end
	local i =0 
	while(i<6)
	do
		i = i +1 
		tBetUid = tBetUid +1 
		if tBetUid == 7 then 
			tBetUid =1 
		end
		if tostring(m_PlayerNum[tBetUid]) == tostring(EginUser.Instance.uid) then
			tNextIsMe = true
			break
		else
			if tonumber(m_PlayerNum[tBetUid]) ~= 0 then
				local tPlayer = find(m_nnPlayerName..tostring(m_PlayerNum[tBetUid]))
				if tableContains(m_NotQiList,tPlayer) == true then
					break
				end
			end
		end
	end
	return tNextIsMe

end

--发公共牌
function this:ProcessNewRound( pMessageObj )
	-- print('In process New Round ')
	local tBody = pMessageObj['body']
	local tStep = tonumber(tBody['step'])
	if tStep == 4 then
		m_AlreadyHeChi= true
	end
	if m_AlreadyHeChi then
		local tBianChiCount = 0
		local tResult = this:formulaPoolList1(m_PlayerIdValue)
		-- printf(m_PlayerIdValue)
		-- print('=================ProcessNewRound============ ')
		-- printf(tResult)
		local tHeChiCount = 0 
		for i=1,#tResult do 
			tHeChiCount = tHeChiCount+1
			local tDic = tResult[i]
			if tDic['pool'][1] >0 then
				tBianChiCount = tBianChiCount+1
				this:HeChi(m_FenChiChildList[i],tDic['pool'][1],nil,nil,tHeChiCount,tBianChiCount)
			end
		end
		if tBianChiCount >1 then
			m_FenChiParentObj.transform.localPosition =  Vector3.New(0-70*(tBianChiCount-1),0,0)
		end
	end
	local tHandType = tonumber(tBody['hand_type'])
	local tHandCards = tBody['hand_cards']
	m_GameStep = tStep
	m_AddBetLab1.text = ''
	m_AddBetNum  =0
	m_AddBetBtn1:SetActive(false)
	m_AllNeedMoney =0 
	m_AllNeedMoney1 =0
	local tNewBoardCards = tBody['newboardcards']
	if #tNewBoardCards > 0 then
		for i=1,#tNewBoardCards do 
			table.insert(m_PublicCards,tNewBoardCards[i])
		end
	end
	local tPlayer = find(m_nnPlayerName..EginUser.Instance.uid)
	this:getPlayerCtrl(tPlayer.name):SetPublicCards(tStep,tNewBoardCards)
	this:SetPublicCards(tNewBoardCards); 
	this:SetLastCardType(tHandType,tHandCards)
end


function this:HeChi(pFenChiChild,pChouMaCount,pMessageObj,pPlayerInfo,pHeChiCount,pResultCount)
	-- print(cjson.encode(pMessageObj))
	if pFenChiChild ~= nil then
		for k,v in pairs(m_PlayingPlayerObjList) do 
			if IsNil(v.gameObject) == false then 
				local tCtrl =  this:getPlayerCtrl(v.name)
				local tMaxCount =tCtrl:GetChouMaCount()
				if tonumber(tMaxCount) > tonumber(m_MaxBetCount) then
					m_MaxBetCount = tMaxCount
				end
				tCtrl:DestroyBetChouma()
			end
		end
		if m_MaxBetCount ~=0 then
			local tHuanChongTime = 0.6+ 0.08*m_MaxBetCount
			-- print(cjson.encode(pMessageObj))
			-- print('chong time == '..tHuanChongTime..'   time ' .. Time.time)
			coroutine.start(function ( )
				coroutine.wait(tHuanChongTime)
				-- print('time == '.. Time.time)
				-- print(cjson.encode(pMessageObj))
				if pChouMaCount > 0 and pChouMaCount<400 then
					for i =1,4 do 
						local tHuaSe=math.random(1,6)
						pFenChiChild.transform:FindChild('Sprite_'..(i)):GetComponent('UISprite').alpha = 1
						pFenChiChild.transform:FindChild('Sprite_'..(i)):GetComponent('UISprite').spriteName = 'chouma_'..tHuaSe
					end
				elseif pChouMaCount >=400 and pChouMaCount<1000 then
					for i =1,6 do 
						local tHuaSe=math.random(1,6)
						pFenChiChild.transform:FindChild('Sprite_'..(i)):GetComponent('UISprite').alpha = 1
						pFenChiChild.transform:FindChild('Sprite_'..(i)):GetComponent('UISprite').spriteName = 'chouma_'..tHuaSe
					end
				elseif pChouMaCount >=1000 then
					for i =1,12 do 
						local tHuaSe=math.random(1,6)
						pFenChiChild.transform:FindChild('Sprite_'..(i)):GetComponent('UISprite').alpha = 1
						pFenChiChild.transform:FindChild('Sprite_'..(i)):GetComponent('UISprite').spriteName = 'chouma_'..tHuaSe
					end
				end
				pFenChiChild.transform:FindChild("hechipot"):GetComponent('UILabel').text = tostring(pChouMaCount)
                pFenChiChild.transform:FindChild("Sprite_bianchi"):GetComponent('UISprite').alpha = 1;
				if m_ISFenChi == true and  pHeChiCount == pResultCount then
					coroutine.start(this.FenChi,pMessageObj,pPlayerInfo)
				end
			end)
		end
	else
		-- print('hehehehehehechichichcihchic -------------  22222 ')
		coroutine.start( this.FenChi,pMessageObj,pPlayerInfo)
	end
end

function this.FenChi(pMessageObj,pPlayerInfo)

	coroutine.wait(0.1)
	local tWinPos = {}
	local tWinCount=0
	if pPlayerInfo == nil then
		local tBody = pMessageObj['body']
		pPlayerInfo = tBody['players_info']
		this:ResetView(pMessageObj)
	end

	if pPlayerInfo ~= nil then
		for i=1,#pPlayerInfo do 
			local  tUid = tonumber(pPlayerInfo[i]['uid'])
			local tWinMoney = tonumber(pPlayerInfo[i]['winmoney'])
			local tHandType = tonumber(pPlayerInfo[i]['hand_type'])
			local tOwnCards = pPlayerInfo[i]['cards']
			local tRoundNum = tonumber(pPlayerInfo[i]['round_num'])
			local tWinNum = tonumber(pPlayerInfo[i]['win_num'])
			local tLoseNum = tonumber(pPlayerInfo[i]['lose_num'])
			local tWinRate = tonumber(pPlayerInfo[i]['win_rate'])
			local tMaxWinMoney = tonumber(pPlayerInfo[i]['max_winmoney'])
			local tMaxCards = pPlayerInfo[i]['max_cards']
			local tMaxCardsType = tonumber(pPlayerInfo[i]['max_cardtype'])

			local tPlayer = find(m_nnPlayerName..tostring(tUid))
			local tCtrl = this:getPlayerCtrl(tPlayer.name)
			tCtrl:SetGameOverNext(tUid,tWinMoney,tHandType,tOwnCards)
			tCtrl:SetAutoUpdateBagMoney(tWinMoney)
			tCtrl:SetPaiJiMessage(tRoundNum,tWinNum,tLoseNum,tWinRate,tMaxWinMoney,tMaxCardsType,tMaxCards)
		end
	end
	local tEndTargetPosition = {}
	coroutine.start(function ()
		coroutine.wait(0.3)
		if pPlayerInfo ~= nil then
			for i = 1,#pPlayerInfo do 
				local  tUid = tonumber(pPlayerInfo[i]['uid'])
				local tWinMoney = tonumber(pPlayerInfo[i]['winmoney'])
				local tWinChip = tonumber(pPlayerInfo[i]['winchip'])
				local tHandType = tonumber(pPlayerInfo[i]['hand_type'])
				local tOwnCards = pPlayerInfo[i]['cards']
				local tHandCards = pPlayerInfo[i]['hand_cards']
				local tPlayer = find(m_nnPlayerName..tUid)
				if tWinChip > 0 then
					local tFangWei = tostring(tPlayer.transform:GetComponent('UIAnchor').side)
					tWinCount = tWinCount+1
					table.insert(tWinPos,tFangWei)
				end
				this:getPlayerCtrl(tPlayer.name):SetGameOver(tUid,tWinChip,tWinMoney,tHandType,tOwnCards,tHandCards)
			end
		end

		local tEndTarget = nil 
		
		for i =1 ,#tWinPos do 

			for j=1,#m_AncherPos do 
				if tWinPos[i] == m_AncherPos[j] then
					tEndTarget = m_JieSuanPos[j]
					-- print('in  pos '..tEndTarget )
				end
			end
			table.insert( tEndTargetPosition,tEndTarget)
		end
	end)	
	coroutine.start(function ()
		coroutine.wait(0.6)
		local tPlayer = find(m_nnPlayerName..EginUser.Instance.uid)
		local tChoumaAlphaCount =0 
		local tShowBet = {}
		for i=1,7 do
			local tChild =0 
			for j =1,15 do 
				local tObj = m_FenChiChildList[i].transform:FindChild('Sprite_'..j).gameObject
				if tObj:GetComponent('UISprite').alpha ==1 then
					table.insert(tShowBet,tObj)
					tChoumaAlphaCount = tChoumaAlphaCount +1
					tChild= tChild+1
				end
			end
			table.insert(m_FenChiChildCount,tChild)
		end
		local tLastTime = 0 
		local tFlyBetCountIndex = 1
		local tXiaoBiaoIndex = 1 
		-- print(#tShowBet)
		if pPlayerInfo ~= nil then
			for i =1 ,#pPlayerInfo do 
				local tWinMoney = tonumber(pPlayerInfo[i]['winmoney'])
				local tWinChip = tonumber(pPlayerInfo[i]['winchip'])
				if tWinChip > 0 then
					local tUid = tonumber(pPlayerInfo[i]['uid'])
					local tHandType = tonumber(pPlayerInfo[i]['hand_type'])
					local tHandCards = pPlayerInfo[i]['hand_cards']
					local tPlayerXiaZhuPlayer = find(m_nnPlayerName..tUid)
					local tXiaoBiao = tXiaoBiaoIndex
					coroutine.start(function ( )
					local tXiaZhuMoney = tonumber(m_PlayerIdValue[tonumber(tUid)])  + tWinChip

						coroutine.wait(tLastTime)
						local tA = this:selectminusMoney(tWinChip )  
						 m_FlyBetCount=tFlyBetCountIndex + tA

						local tV = 0.08 
						for j= 1, m_FlyBetCount,1 do 
							local tTemp =tV
							local tNum =j
							local tChuChiPos = tShowBet[tNum].transform.position
								coroutine.wait(tV)

								iTween.MoveTo(tShowBet[tNum].gameObject,iTween.Hash('position',tEndTargetPosition[tXiaoBiao].transform.position,'time',0.3,'easytype',iTween.EaseType.linear))
								-- print(tEndTargetPosition[tXiaoBiao].transform.position)
								coroutine.start(function (  )
									coroutine.wait(0.3)
									tShowBet[tNum]:GetComponent('UISprite').alpha =  0 
								-- end)
								-- coroutine.start(function (  )
									coroutine.wait(0.1)
									if tShowBet[tNum]:GetComponent('TweenPosition') ~= nil then
										tShowBet[tNum]:GetComponent('TweenPosition').enabled = false 
									end
									tShowBet[tNum].transform.position = tChuChiPos
								end)
								
							-- end)
							-- tV = tV + 0.08
						end
						m_UserPlayerCtrl:SetGameOverTiGao(tWinMoney,tHandType,tHandCards,tChoumaAlphaCount/tWinCount)
						this:getPlayerCtrl(tPlayerXiaZhuPlayer.name):SetGameOverJinQian(tUid,tWinMoney,tChoumaAlphaCount/tWinCount,tWinChip,tXiaZhuMoney)
					end)
					tFlyBetCountIndex = m_FlyBetCount
					tLastTime = tLastTime + 1.5
					tXiaoBiaoIndex = tXiaoBiaoIndex +1
				end
			end
		end
	end)
end

function this:ProcessGoNext( pMessageObj)
	-- print('process Go next')
	if m_OwnQiPai == true then
		if m_AddBetObj.activeSelf  then
			m_AddBetObj:SetActive(false)
		end
	end
	local tBody = pMessageObj['body']
	local tNextOne = tBody['nextone']
	-- m_AddBetLab.text = ''
	m_AllNeedMoney1 = m_PotBig - m_MyPot
	local tPlayer  = find(m_nnPlayerName..tNextOne)
	local tCtrl = this:getPlayerCtrl(tPlayer.name)
	tCtrl:SetTime()
	tCtrl:SetTimeMinus()
	tCtrl:SetNickname()
	if tostring(tNextOne) == tostring(EginUser.Instance.uid) then
		if m_AutoQiObj.activeSelf and  m_AutoQiObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName == 'seeorlose_click' then
			 m_AutoQiObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName = 'seeorlose' 
			m_AutoQiObj:GetComponent('UIButton').normalSprite = 'seeorlose'
			if m_MyPot == m_PotBig then
				local tChipIn = {}
				tChipIn['type'] = 'holdem'
				tChipIn['tag'] = 'bet'
				tChipIn['body'] =0
				this.mono:SendPackage(cjson.encode(tChipIn))
				m_AutoQiObj:SetActive(true)
			elseif m_MyPot < m_PotBig then
				-- print('go next  1')
				local tChipIn = {}
				tChipIn['type'] = 'holdem'
				tChipIn['tag'] = 'fold'
				tChipIn['is_timeout'] =false
				this.mono:SendPackage(cjson.encode(tChipIn))
			end
		elseif  m_AutoKanObj.activeSelf and m_AutoKanObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName == 'automatic_seecard_click' then

			if m_MyPot == m_PotBig then
				m_AutoKanObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName = 'automatic_seecard'
				m_AutoKanObj:GetComponent('UIButton').normalSprite = 'automatic_seecard'
				local tChipIn = {}
				tChipIn['type'] = 'holdem'
				tChipIn['tag'] = 'bet'
				tChipIn['body'] =0
				this.mono:SendPackage(cjson.encode(tChipIn))
				m_AutoKanObj:SetActive(true)
			elseif mypot < pot_big then 
				-- print('go next  2')
				m_BtnsObj:SetActive(true)
				m_BtnObjAuto:SetActive(false)
				this:AutoButtonReset()
				m_AddBetBtn:SetActive(true)
				 local tGenCount = m_PotBig- m_MyPot
				 if tGenCount ==0 then
				 	m_GenLab.text = '过牌'
				 else
				 	m_GenLab.text =  "跟注" .. tGenCount
				 end
			end
		elseif m_AutoFollowGenObj.activeSelf and m_AutoFollowGenObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName == 'follow_select' then
			m_AutoFollowGenObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName = 'follow' 
			m_AutoFollowGenObj:GetComponent('UIButton').normalSprite = 'follow'
			m_AutoFollowGenObj:SetActive(false)
			m_AutoKanObj:SetActive(true)
			local tChipIn = {}
			tChipIn['type'] = 'holdem'
			tChipIn['tag'] = 'bet'
			tChipIn['body'] =0
			this.mono:SendPackage(cjson.encode(tChipIn))
		elseif m_AutoFollowAllObj.activeSelf and m_AutoFollowAllObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName == 'follow_allbet_click' then
			m_AutoFollowAllObj.transform:FindChild('Sprite_bg'):GetComponent('UISprite').spriteName = 'follow_allbet'
			m_AutoFollowAllObj:GetComponent('UIButton').normalSprite = 'follow_allbet'
			m_AutoFollowGenObj:SetActive(false)
			m_AutoKanObj:SetActive(true)
			local tChipIn = {}
			tChipIn['type'] = 'holdem'
			tChipIn['tag'] = 'bet'
			tChipIn['body'] =0
			this.mono:SendPackage(cjson.encode(tChipIn))
		else
			-- print('go next  3')
			m_BtnsObj:SetActive(true)
			m_BtnObjAuto:SetActive(false)
			this:AutoButtonReset()
			m_AddBetBtn:SetActive(true)
			local tGenCount = m_PotBig - m_MyPot
			local tAddMoney = m_PotBig- m_MyPot + 80 
			-- if tGenCount <= tonumber(m_UserBagmoneyLab.text) then
			if tGenCount <= tonumber(m_MyMoney) then
				if tGenCount ==0 then
					m_GenLab.text = '过牌'
				else
					m_GenLab.text = '跟注'..tGenCount
				end
				if tAddMoney > tonumber(m_MyMoney) then
					m_AddBtn:SetActive(false)
					m_AddBetBtn2:SetActive(true)
				end
			else
				m_GenBtn:GetActive(false)
				m_AllInBtn:SetActive(true)
				m_AddBtn.transform:FindChild('Sprite_bg'):GetComponent('UISprite').alpha = 0.4
				m_AddBtn:GetComponent('BoxCollider').enabled = false

			end 
		end
	else
		m_BtnsObj:SetActive(false)
		m_AddBetBtn:SetActive(true)
		m_AddBetBtn1:SetActive(false)
	end
	NNCount.Instance:UpdateHUD(m_JuTime)
	-- print('process Go next  enddddd ')
end



function this:selectminusMoney(tWinChip )  
	-- print('select minus mone y ')
	m_CiShu = m_CiShu +1 
	local tFlyChou =0 
	local tFlyChouAll = 0 
	for i=1,7 do 
		local tIsGo = false 
		if m_CiShu >1 then
			if m_FenChiChildList[i].transform:FindChild('hechipot'):GetComponent('UILabel').text == '' then
				tIsGo = true 
			end
		end
		if tIsGo == false then
			local tShenYuMoney = tonumber(m_FenChiChildList[i].transform:FindChild('hechipot'):GetComponent('UILabel').text)
		
			if tShenYuMoney >= tWinChip then
				tFlyChou = math.ceil(tWinChip) /tShenYuMoney *m_FenChiChildCount[i]
				tFlyChouAll = tFlyChou + tFlyChouAll
				tShenYuMoney  = tShenYuMoney- tWinChip
				tWinChip =0 
				m_FenChiChildCount[i] = m_FenChiChildCount[i]-tFlyChou
				if tShenYuMoney ==0 then
					m_FenChiChildList[i].transform:FindChild('hechipot'):GetComponent('UILabel').text = ''
					m_FenChiChildList[i].transform:FindChild('Sprite_bianchi'):GetComponent('UISprite').alpha = 0
				else
					m_FenChiChildList[i].transform:FindChild('hechipot'):GetComponent('UILabel').text = tShenYuMoney	
				end
			else

				tFlyChou = m_FenChiChildCount[i]
				tFlyChouAll = tFlyChouAll + tFlyChou
				tWinChip = tWinChip- tShenYuMoney
				tShenYuMoney =0 
				m_FenChiChildList[i].transform:FindChild('hechipot'):GetComponent('UILabel').text = ''
				m_FenChiChildList[i].transform:FindChild('Sprite_bianchi'):GetComponent('UISprite').alpha = 0
			end
			if tWinChip <= 0 then
				break
			end
		end
	end
	return tFlyChouAll
end


function this:formulaPoolList1(pDic)
	local tAmountM =0 
	local tDropMoney = 0 
	local tDic = {}
	for k,v in pairs(pDic) do 
		tDic[tonumber(k)] = v 
	end
	local tDropList = {}
	for k,v in pairs(tDic) do 
		local tMoney = v
		if tMoney <= 0 then
			tMoney = math.abs(tMoney)
			tDropMoney = tDropMoney +  tMoney
			table.insert(tDropList,k)
		end
		tAmountM = tAmountM + tMoney
	end
	for i=1,#tDropList do 
		if tDic[tDropList[i]] ~= nil then
			tDic[tDropList[i]] = nil 
			-- tableRemove(tDic,tDropList[i])
		end
	end
	local tPlayerCount = 0
	local tMinId = 0 
	local tMinValue = 2147483647
	for k,v in pairs(tDic) do
		if tonumber(v) < tMinValue then
			tMinValue = tonumber(v)
			tMinId = tonumber(k) 
		end 
	end
	local tResult = {}
	for k,v in pairs(tDic) do 
		 tPlayerCount = tPlayerCount + 1 
	end
	local tLivePlayer = tPlayerCount 
	for i=1,tPlayerCount do 
		local tDead =0 
		local tempDic = {}
		tempDic['pool'] = {}
		tempDic['id'] = {}
		local tPool = tMinValue * tLivePlayer
		if tLivePlayer <= 0 then
			local tLost = 0 
			for k,v in pairs(tDic) do 
				if v > 0 then
					tLost = tLost + v
				end
			end
			tPool = tLost
			table.insert(tempDic['pool'],tPool)
			table.insert(tempDic['id'],-1)
			table.insert(tResult,tempDic)
			break
		else
			table.insert(tempDic['pool'],tPool)
			table.insert(tResult,tempDic)
		end
		local tempId = {}
		local tTempIndex = 0 
		for k,v in pairs(tDic) do 
			tTempIndex = tTempIndex + 1 
			tempId[tTempIndex] = k 
		end
		for j =1,#tempId  do 
			local tId = tempId[j]
			tDic[tId] = tDic[tId] - tMinValue
			if tempDic['id'] == nil then
				tempDic['id'] = {}
			end

			if tDic[tId] >0 then
				table.insert(tempDic['id'],tId)
			elseif tDic[tId]==0 then
				table.insert(tempDic['id'],tId)
				tDead = tDead +1
			end 
		end 
		tLivePlayer = tLivePlayer - tDead 
		tMinValue = 2147483647
		for k,v in pairs(tDic) do
			local tMoney = v
			if tMoney < tMinValue and tMoney >0 then
				tMinValue = tMoney
			end
		end
	end
	if tDropMoney ~= 0 then
		tResult[1]['pool'][1] = tResult[1]['pool'][1] + tDropMoney
	end
	return tResult
end




function this:ProcessQiPai(pMessageObj)
	local tBody = pMessageObj['body']
	local tThisOne = tonumber(tBody['thisone'])
	local tIsTimeOut = tBody['is_timeout']
	if tostring(tThisOne) == tostring(EginUser.Instance.uid) then
		m_IsPlaying1 = false
	end 
	if m_IsPlaying1 ~= false then
		m_BtnObjAuto:SetActive(false)
		this:AutoButtonReset()
	end
	if m_PlayerIdValue[tThisOne] == nil then
		m_PlayerIdValue[tThisOne] =0
	end

	local tCount = -m_PlayerIdValue[tThisOne]
	m_PlayerIdValue[tThisOne] = tCount
	local tPlayer = find(m_nnPlayerName..tThisOne)
	if tostring(tThisOne) == tostring(EginUser.Instance.uid) then 
		m_OwnQiPai = true 
		this:getPlayerCtrl(tPlayer.name):SetQi(false)
		if m_AddBetObj.activeSelf then
			m_AddBetObj:SetActive(false)
		end
	else
		this:getPlayerCtrl(tPlayer.name):SetQi(true)
	end
	if tableContains(m_NotQiList,tPlayer) ==true then
		tableRemove(m_NotQiList,tPlayer) 
	end
	for i=1,#m_PlayerNum do 
		if tonumber(m_PlayerNum[i]) == tonumber(tThisOne) then
			m_PlayerNum[i] = 0
		end
	end
	-- print('process qi pai  end ')
end
function this:ProcessUpdate( pMessageObj)
	-- print('ProcessUpdate ')
	local tShiLiTime = 0
	local tBody = pMessageObj['body']
	local tChip = tBody['chip_moneys']
	local tDmuid = tonumber(tBody['bb'])
	local tXmuid = tonumber(tBody['sb'])
	local tPot = tonumber(tBody['pot'])
	local tThisOne = tonumber(tBody['thisone'])
	local tBanker = tonumber(tBody['banker'])
	local tStep = tonumber(tBody['step'])
	local tFollowMoney = tonumber(tBody['follow_money'])
	local tBetMoney = tonumber(tBody['bet_timeout'])

	local tPlayerStates = tBody['player_states']
	local tOwnCards = tBody['mycards']
	local tBoardCards = tBody['boardcards']
	local tGameOverInfo = tBody['gameover_info']
	if tBoardCards ~= nil  then
		for i=1,#tBoardCards do
			table.insert( m_PublicCards,tBoardCards[i])
		end
		this:SetPublicCards(tBoardCards)
           -- gameObject.GetComponent<TopBureaureview>().setPublicCards(step, boardcards);
	end
	if #tOwnCards>1 then
		this:SetOwnCards(tOwnCards)
	end
	m_JuTime = tonumber(tBody['timeout'])
	m_BetPotLab.text = '池底：'..tPot
	m_HeChiPot = tPot
	if m_UserPlayerCtrl == nil then 
		m_UserPlayerCtrl = find(m_nnPlayerName..EginUser.Instance.uid)
	 end----------sethis:getPlayerCtrl(tUpdatePlayer.name)
	m_UserPlayerCtrl:SetPublicCardsStep(tStep,tBoardCards)

	if #tOwnCards>1 then
		-- this:getPlayerCtrl(tUpdatePlayer.name)
		m_UserPlayerCtrl:SetOwnCardsStep(tOwnCards)
	end
	local tBankerPlayer = find(m_nnPlayerName..tBanker)
	this:getPlayerCtrl(tBankerPlayer.name):SetBanker(true)
	local tDmPlayer = find(m_nnPlayerName..tDmuid)
	this:getPlayerCtrl(tDmPlayer.name):SetBetInfo('大盲注')
	local 
	tXmPlayer = find(m_nnPlayerName..tXmuid)
	this:getPlayerCtrl(tXmPlayer.name):SetBetInfo('小盲注')
	if #tGameOverInfo >1 then
		for i=1,#tPlayerStates do 
			local tUid = tonumber(tPlayerStates[i][1])
			local tPlayer = find(m_nnPlayerName..tostring(tUid))
			this:getPlayerCtrl(tPlayer.name):SetCancelTime()
		end
	end
	for i=1,#tPlayerStates do 
		local tUid = tostring(tPlayerStates[i][1])
		local tDoPlyer = find(m_nnPlayerName..tUid)
		local tCtrl = this:getPlayerCtrl(tDoPlyer.name)
		if tableContains(m_WaitPlayerObjList,tDoPlyer) == true then
			tableRemove(m_WaitPlayerObjList,tDoPlyer) 
		end
		if tableContains(m_PlayingPlayerObjList,tDoPlyer ) == false then
			table.insert(m_PlayingPlayerObjList,tDoPlyer)
		end
		if tableContains(m_NotQiList,tDoPlyer) == false then
			table.insert(m_NotQiList,tDoPlyer)
		end
		local tBagMoney =tonumber(tPlayerStates[i][2])
		local tMoneyCount =tonumber(tPlayerStates[i][3])
		local tBetMoney = tonumber( tPlayerStates[i][4])
		local tQiPai = tPlayerStates[i][5]
		if tQiPai == true then
			tMoneyCount = - tMoneyCount
		end
		m_PlayerIdValue[tonumber(tUid)] = tMoneyCount
		table.insert(m_PoolPlayer,tUid)
		if m_PotBig < tMoneyCount then
			m_PotBig = tMoneyCount
		end
		if tostring(tUid) ~= tostring(tDmuid) and tostring(tUid) ~= tostring(tXmuid) then
			tCtrl:SetStartInfoName()
		end
		tCtrl:SetStartInfo(tBagMoney)
		if tQiPai == true then
			if tostring(tUid) ~= tostring(EginUser.Instance.uid) then
				tCtrl:SetQi(true)
			else
				tCtrl:SetQi(false)
			end
			
		end
		if tostring(tUid) == tostring(EginUser.Instance.uid) then
			if tQipai == true then
				m_IsQi = true 
			end
			if tMoneyCount> m_MyPot then
				m_MyPot = tMoneyCount
			end 

		end

		local tDanGeTime = tCtrl:SetBet(-1,-1,tMoneyCount,tMoneyCount,-1,tBagMoney)
		if tDanGeTime> tShiLiTime then
			tShiLiTime = tDanGeTime
		end
		-- print('wait second    ====  ' ..tShiLiTime )
		tCtrl:SetChuShiMoney(tBagMoney,tMoneyCount)
		if tostring(tUid) ~= tostring(EginUser.Instance.uid) then
			tCtrl:SetCardShow()
		end
	end
	if tableContains(m_PlayingPlayerObjList,tUpdatePlayer) == true then
		m_PlayerContainsMyself = true 
	end
	if tableContains(m_PlayingPlayerObjList,tUpdatePlayer) == true  and m_IsQi == false then
		m_BtnObjAuto:SetActive(true )
		if m_MyPot == m_PotBig then
			m_AutoFollowGenObj:SetActive(false)
			m_AutoKanObj:SetActive(true)
		elseif m_MyPot < m_PotBig then 
			m_AutoFollowGenObj:SetActive(true)
			m_AutoKanObj:SetActive(false)
			local tFollowMoney = m_PotBig - m_MyPot 
			m_AutoFollowGenObj.transform:FindChild('gen_label'):GetComponent('UILabel').text =  "跟注" ..tFollowMoney			
		end
	else
		m_BtnObjAuto:SetActive(false )
		this:AutoButtonReset()
	end
	local tPlayerThisOne = find(m_nnPlayerName..tThisOne)
	this:getPlayerCtrl(tPlayerThisOne.name):SetTime()
	if tostring(tThisOne)== tostring(EginUser.Instance.uid) then
		if m_MyPot< m_PotBig then
			local tMoney = m_PotBig- m_MyPot 
			m_BetLab.text = '跟注'..tMoney
		elseif m_MyPot == m_PotBig then
				m_BetLab.text = '过牌'
		end	
		-- print('process update    ')
		m_BtnsObj:SetActive(true )
	else 
		m_BtnsObj:SetActive(false)
	end
	if #tGameOverInfo >1 then
		coroutine.start(function ()
			coroutine.wait(tShiLiTime +0.1)
			print(' update   process game over  ')
			this:ProcessGameOver(nil,tGameOverInfo)
		end)
	end
end

function this:ProcessShowCards( pMessageObj )
	local tBody = pMessageObj['body']
	for i=1,#tBody do 
		local tUid = tBody[i][1]
		local tPlayer = find(m_nnPlayerName..tUid)
		this:getPlayerCtrl(tPlayer.name):SetCardShowPoke(tUid,tBody[i][2])
	end
end

function this:ProcessGameLB( pMessageObj )
	local tBody = pMessageObj['body']
	local tWuPinList = tBody[3]
	local tWinMoney = tonumber(tBody[1])
	local tRandomCount = tonumber(tBody[2])
	local tBagMoney = tonumber(tBody[4])
	this:ChangePosition(tWinMoney, tRandomCount, tWuPinList, tBagMoney);
end

function this:ProcessGamebleError( pMessageObj )
	-- print(pMessageObj)
end

function this:ProcessGameOver( pMessageObj,pPlayerInfo )
	print(cjson.encode(pMessageObj))
	printf(pPlayerInfo)
	if m_OwnQiPai == true then
		if m_AddBetObj.activeSelf then
			m_AddBetObj:SetActive(false)
		end
	end

	m_ISFenChi = true 
	local tBianChiCount = 0
	local tHeChiCount = 0 
	if tonumber(m_GameStep) ~= 4 then

		local tResult = this:formulaPoolList1(m_PlayerIdValue)
		-- printf(m_PlayerIdValue)
		-- print('=================game over============ ')
		-- printf(tResult)
		for i=1,#tResult do 
			tHeChiCount = tHeChiCount + 1 
			local tDic = tResult[i]
			if tDic['pool'][1] ~=0 then
				tBianChiCount = tBianChiCount +1 
				print(cjson.encode(pMessageObj))
				this:HeChi(m_FenChiChildList[i],tDic['pool'][1],pMessageObj,pPlayerInfo,tHeChiCount,tBianChiCount)
			end
		end
		if tBianChiCount > 1 then
			m_FenChiParentObj.transform.localPosition = Vector3.New(0-70*(tBianChiCount-1),0,0)
		end
	else
		this:HeChi(nil,0,pMessageObj,pPlayerInfo,0,0)
	end

	this:Chongzhi()
	-- print('gameOver end  ')
end

function this:Chongzhi( )
	-- print(' ======================= chong zhi ')
	-- print(Time.time)
	m_PotBig = 0 
	m_MyPot = 0 
	m_GameStep = 0 
	m_AddBetLab1.text = ''
	m_AddBetNum  =0
	m_GenLab.text =''
	m_AddBetBtn:SetActive(true)
	m_AddBetBtn1:SetActive(false)
	m_BtnsObj:SetActive(false)
	m_BtnObjAuto:SetActive(false)
	m_AddBtn:GetComponent('BoxCollider').enabled = true 
	m_AllInBtn:SetActive(false)
	m_GenBtn:SetActive(true)
	this:AutoButtonReset()
	coroutine.start(function ( )
		coroutine.wait(8)
		-- print(' chong zhi 2')
		m_StartGame = true 
		local tPlayer = find(m_nnPlayerName..EginUser.Instance.uid)
		if tableContains(m_PlayingPlayerObjList,tPlayer) == true then
			local tSendMsg = {} 
			tSendMsg['type'] = 'game'
			tSendMsg['tag'] = 'start'
			this.mono:SendPackage(cjson.encode(tSendMsg))
			coroutine.wait(1)
			tSendMsg = {}
			tSendMsg['type'] = 'game'
			tSendMsg['tag'] = 'continue'
			this.mono:SendPackage(cjson.encode(tSendMsg))
		end
	end)
	coroutine.start(function ( )
		coroutine.wait(8)
		m_FenChiParentObj.transform.localPosition = Vector3.zero
		m_ISFenChi = false 
		m_PlayerIdValue = {}
		m_FenChiChildCount = {}
		m_FlyBetCount = 0
		m_OwnQiPai = false 
		m_IsAllin = false 
		m_AlreadyHeChi = false 
		m_PublicCards = {}
		m_PoolPlayer = {}
		for i=1,15 do 
			m_FenChiChildList[1].transform:FindChild('Sprite_'..i):GetComponent('UISprite').alpha = 0
		end
		local tPlayer = find(m_nnPlayerName..EginUser.Instance.uid) 
		m_UserPlayerCtrl = this:getPlayerCtrl(tPlayer.name)

		coroutine.wait(1)

		-- print(' Hide  Card    ============ '..tostring(Time.time))
		m_UserPlayerCtrl:HidePublicCards()
		for k,v in pairs(m_PlayingPlayerObjList) do 
			if v~= nil and IsNil(v.gameObject) == false then 
				local tCtrl = this:getPlayerCtrl(v.name)
				tCtrl:HideOwnPoke()
				tCtrl:SetBanker(false)
				tCtrl:DoClear()
			end
		end
	end)
end


function this:OnSetBiaoQing( tTarget )
	-- print('OnSet biao qing  ')
	m_FirstTime = Time.time
	if m_FirstTime - m_EndTime < m_JianGeTime then
		m_MessageError:SetActive(true)
		m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text = '发送失败'
		coroutine.start(function (  )
			coroutine.wait(1.5)
			m_MessageError:SetActive(false)
		end)
	else
		local tPlayer =  find(m_nnPlayerName .. EginUser.Instance.uid)
		if tableContains(m_PlayingPlayerObjList,tPlayer) == true then
			m_HaveSit = true 
		end
		local tIndex = 0 
		if m_BiaoQingParentObj.activeSelf == true then
			for i=1,27 do 	

				local tSmile = m_BiaoQingParent1.transform:FindChild('biaoqing_'..i)
				if tTarget == tSmile.gameObject then
					tIndex = i
					break
				end
			end
		elseif m_RabbitParentObj.activeSelf == true then
			for i=1,31 do 
				local tSmile = m_BiaoQingParent2.transform:FindChild('biaoqing_'..i)
				if tTarget == tSmile.gameObject then
					tIndex = i + 27
					break
				end
			end
		elseif m_HuLiParentObj.activeSelf == true then
			for i=1,11 do 
				local tSmile = m_BiaoQingParent3.transform:FindChild('biaoqing_'..i)
				if tTarget == tSmile.gameObject then
					tIndex = i + 58
					break
				end
			end
		end
		if m_HaveSit then
			local tSendMsg = {}
			tSendMsg['type'] = 'game'
			tSendMsg['tag'] = 'emotion'
			tSendMsg['body'] = tIndex
			this.mono:SendPackage(cjson.encode(tSendMsg))
		else
			m_MessageError:SetActive(true)
			m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text = '还未开始游戏，无法发送表情'
			coroutine.start(function ( )
				coroutine.wait(1.5)
				m_MessageError:SetActive(false)
			end)
		end
		
	end
	m_TalkObj:SetActive(false)
	if m_TalkObj.activeSelf  == false  then
		m_BiaoQingPanelObj:SetActive(true)
		m_RabbitPanelObj:SetActive(false)
		m_HuLiParentObj:SetActive(false)
		m_MessageTalkSp.spriteName = 'message'
	end
end

function this:ShuShiDaoJu(  )
	-- print('shu shi daoju ')
	m_HolidayObj.spriteName = 'holiday_select'
	m_DecorateObj.spriteName = 'decorate'
	m_GoodLuckObj.spriteName = 'lucky'
	m_FoodObj.spriteName = 'food'
	m_HolidayObj:SetActive(true)
	m_DecorateObj:SetActive(false)
	m_GoodLuckObj:SetActive(false)
	m_FoodObj:SetActive(false)
	if m_HolidayObj.activeSelf == true then
		for i=1,6 do 
			m_HolidayObj.transform:FindChild('holiday_'..i).gameObject:GetComponent('UISprite').spriteName = 'daojuboard'
		end
	end
end

function this:ChangeTuBiao( )
	-- print('change Tu biao ')
	if m_HolidayObj.activeSelf then
		for i=1,6 do 
			m_HolidayObj.transform:FindChild('holiday_'..i):GetComponent('UISprite').spriteName = 'daojuboard'
		end
	elseif m_DecorateObj.activeSelf then
	 	for i=1,7 do 
			m_DecorateObj.transform:FindChild('decorate_'..i):GetComponent('UISprite').spriteName = 'daojuboard'
		end
	elseif m_GoodLuckObj.activeSelf then
		for i=1,8 do 
			m_GoodLuckObj.transform:FindChild('goodluck_'..i):GetComponent('UISprite').spriteName = 'daojuboard'
		end
	elseif m_FoodObj.activeSelf then
		for i=1,8 do
			m_FoodObj.transform:FindChild('food_'..i):GetComponent('UISprite').spriteName = 'daojuboard'
		end
	end
end

function this:SendGift( pTarget)
	-- print('SendGift')
	this:ChangeTuBiao()
	pTarget:GetComponent('UISprite').spriteName = 'daojuboard_select'
	local tIndex = 0 
	local tTextNum = 1 
	local tOtherId = m_PresentUid
	for i=1,6 do 
		if pTarget == m_HolidayObj.transform:FindChild('holiday_'..i).gameObject then
			tIndex = i + 34 
			break
		end
	end
	for i=1,7 do 
		if pTarget == m_HolidayObj.transform:FindChild('decorate_'..i).gameObject then
			tIndex = i + 40 
			break
		end
	end
	for i=1,8 do 
		if pTarget == m_HolidayObj.transform:FindChild('goodluck_'..i).gameObject then
			tIndex = i + 47
			break
		end
		if pTarget == m_HolidayObj.transform:FindChild('food_'..i).gameObject then
			tIndex = i + 55 
			break
		end
	end
	m_PresentIndex = tIndex
	local tTempId = tOtherId
	m_PresentOtherId = tTempId
	m_presentNum = tTextNum

end


function this:SendGiftValue(  )
	if m_PlayerContainsMyself == true then
		local tSendMsg = {}
		tSendMsg['otherid'] = m_PresentOtherId
		tSendMsg['pid'] = m_PresentIndex 
		tSendMsg['num'] = m_presentNum
		local tSendToken = {}
		tSendToken['type'] = 'game'
		tSendToken['tag'] = 'props'
		tSendToken['body'] = tSendMsg
		this.mono:SendPackage(cjson.encode(tSendToken))
	else
		m_MessageError:SetActive(true)
		m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text = 
		coroutine.start(function ( )
			coroutine.wait(1.5)
			m_MessageError:SetActive(false)
		end)
		m_XieDaiDaoJuObj:SetActive(false)
		this:ChuShiDaoJu()
	end
end



function this:OnSendLanguage( pTarget )
	-- print('OnSendLanguage')
	local tOtherId = m_PresentUid
	local tPresentPanel = find('GUI/Camera/GameDZPK/Content').gameObject
	for i=1,7 do 
		if pTarget == m_Male.transform:FindChild('label_'..i).gameObject then
			m_LanguageIndex = i 
			break
		end
	end
	for i=1,8 do 
		if pTarget == m_Female.transform:FindChild('label_'..i+7).gameObject then
			m_LanguageIndex = i + 7 
			break
		end
	end

	m_InputLab.text = pTarget:GetComponent('UILabel').text 
end


function this:OnSendLanguageIndex(  )
	-- print('OnSendLanguageIndex')
	if m_LanguageIndex == -1 then
		m_MessageError:SetActive(true)
		m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text = '请选择语音之后再进行发送'
		coroutine.start(function ( )
			coroutine.wait(1.5)
			m_MessageError:SetActive(false)
		end)
	else
		m_LanguageFirstTime = Time.time
		if m_PlayerContainsMyself then
			if m_LanguageFirstTime - m_LanguageEndTime < m_JianGeTime then
				m_MessageError:SetActive(true)
				m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text = 
				coroutine.start(function ( )
					coroutine.wait(1.5)
					m_MessageError:SetActive(false)
				end)
			else
				local tSendMsg = {}
				tSendMsg['hurry_index'] = m_LanguageIndex
				local tSend = {}
				tSend['type'] = 'game'
				tSend['tag'] = 'hurry'
				tSend['body'] = tSendMsg
				this.mono:SendPackage(cjson.encode(tSend))
			end
		else
			m_MessageError:SetActive(true)
			m_MessageError.transform:FindChild('Label'):GetComponent('UILabel').text = 
			coroutine.start(function ( )
				coroutine.wait(1.5)
				m_MessageError:SetActive(false)
			end)
		end
		m_TalkObj:SetActive(false)
		m_MessageTalkSp.spriteName = 'message'
		m_InputBoardSp.gameObject:SetActive(false)
		m_LanguageIndex = -1
	end
end

function this:UserQi(  )
	-- print('UserQi')
	m_IsGuo = false 
	m_BtnsObj:SetActive(false)
	m_AddBetBtn:SetActive(true)
	m_AddBetBtn1:SetActive(false)
	m_AddBetBtn2:SetActive(false)
	if m_AddBetObj.activeSelf then
		m_AddBetObj:SetActive(false)
	end
	local tSendMsg = {}
	tSendMsg['type'] = 'holdem'
	tSendMsg['tag'] = 'fold'
	tSendMsg['is_timeout'] = false 
	this.mono:SendPackage(cjson.encode(tSendMsg))

end

function this:UserAdd(  )
		-- print('UserAdd')
	m_AddBetBtn:SetActive(false)
	m_AllInSp.alpha = 0.5
	local tNeedMoneyAdd = m_PotBig - m_MyPot +m_BBMoney
	m_AddBetSlider.value = 0
	m_AddBetObj:SetActive(true)
	m_AddBetBtn1:SetActive(true)
	m_AddBetLab1.text = '加注'..tNeedMoneyAdd
	m_AddBetNum  = tNeedMoneyAdd
	this:HideMangZhu()
end

function this:SetBetBgVolume( )
	-- print('SetBetBgVolume')
	local tNeedMoneyAdd = m_PotBig - m_MyPot +m_BBMoney
	local tMyBagMoney = tonumber(m_MyMoney) - tNeedMoneyAdd
	local tVolum = tonumber(math.ceil(m_AddBetSlider.value*tMyBagMoney)/10)*10
	m_AddBetNum =tonumber(tNeedMoneyAdd + tVolum)
	m_AddBetLab1.text = '加注'..tostring(m_AddBetNum)
	m_BetLab.text = tostring(m_AddBetNum)
	local tActualSelect = tonumber(m_BetLab.text )
	if tonumber(m_MyMoney ) - tActualSelect <10 then
		m_BetLab.text = "All-in"
		m_AddBetBtn2:SetActive(true)
		m_AddBetBtn1:SetActive(false)
	else
		m_AddBetBtn2:SetActive(false)
		m_AddBetBtn1:SetActive(true)
	end
end

function this:SendAddMoney(pTarget)
-- print('Send add money    ')
	local tMoney = m_AddBetNum
	local tNeedMoney = m_PotBig - m_MyPot
	tMoney = tMoney - tNeedMoney
	m_AddBetObj:SetActive(false)
	m_AddBetBtn:SetActive(false)
	local tSendMsg = {}
	tSendMsg['type'] = 'holdem'
	tSendMsg['tag'] = 'bet'
	tSendMsg['body'] = tMoney
	this.mono:SendPackage(cjson.encode(tSendMsg))
	m_AddBetSlider.value = 0
	coroutine.start(function ( )
		if m_BtnObjAuto.activeSelf == false then
			m_BtnObjAuto:SetActive(true)
			if m_BtnObjAuto.activeSelf ==true then
				m_AutoKanObj:SetActive(true)
				m_AutoFollowGenObj:SetActive(false)
			end
		end
	end)
end

function this:HideMangZhu()
	-- print('Hide mang zhu  ')
	m_OnceSp.alpha = 1 
	m_OnceSp.gameObject:GetComponent('BoxCollider').enabled = true
	m_DoubleThreeSp.alpha = 1 
	m_DoubleThreeSp.gameObject:GetComponent('BoxCollider').enabled = true 
	m_DoubleFourSp.alpha = 1 
	m_DoubleFourSp.gameObject:GetComponent('BoxCollider').enabled = true 
	m_OnceOrTwiceSp.alpha =1 
	m_OnceOrTwiceSp.gameObject:GetComponent('BoxCollider').enabled = true 
	m_TwiceOrTripleSp.alpha =1 
	m_TwiceOrTripleSp.gameObject:GetComponent('BoxCollider').enabled = true 
	local tDiChiMoney = m_HeChiPot
	if m_GameStep ==0 then
		m_OnceSp.alpha = 0.4
		m_OnceSp.gameObject:GetComponent('BoxCollider').enabled = false
		m_DiChiBeiShuObj:SetActive(false)
		m_BBBetObj:SetActive(true)
		if (m_PotBig - m_MyPot +80) > m_BBMoney*3 and (m_PotBig - m_MyPot +80)< 4*m_BBMoney then
			m_DoubleThreeSp.alpha = 0.4
			m_DoubleThreeSp.gameObject:GetComponent('BoxCollider').enabled = false 
		elseif (m_PotBig - m_MyPot +80) > m_BBMoney *4 then
			m_DoubleThreeSp.alpha =0.4 
			m_DoubleThreeSp.gameObject:GetComponent('BoxCollider').enabled = false
			m_DoubleFourSp.alpha = 0.4 
			m_DoubleFourSp.gameObject:GetComponent('BoxCollider').enabled = false
		end
	else
		m_DiChiBeiShuObj:SetActive(true)
		m_OnceSp.alpha = 1
		m_OnceSp.gameObject:GetComponent('BoxCollider').enabled = true
		m_BBBetObj:SetActive(false)
		if (m_PotBig - m_MyPot +80) >  tDiChiMoney/2 and (m_PotBig - m_MyPot +80)< tDiChiMoney*2/3 then
			m_DoubleThreeSp.alpha = 0.4
			m_DoubleThreeSp.gameObject:GetComponent('BoxCollider').enabled = false 
		elseif (m_PotBig - m_MyPot +80) >  tDiChiMoney*2/3 then
			m_OnceOrTwiceSp.alpha =0.4 
			m_OnceOrTwiceSp.gameObject:GetComponent('BoxCollider').enabled = false
			m_TwiceOrTripleSp.alpha = 0.4 
			m_TwiceOrTripleSp.gameObject:GetComponent('BoxCollider').enabled = false
		elseif (m_PotBig- m_MyPot +80) > tDiChiMoney then
			m_OnceSp.alpha = 0.4 
			m_OnceSp.gameObject:GetComponent('BoxCollider').enabled = false
		end
	end
end

function this:DiChiAddBet( pTarget )
	local tMoney =m_HeChiPot
	local tAddMoney = 0 
	if pTarget == m_OnceSp.gameObject then
		tAddMoney = tMoney
	elseif pTarget == m_TwiceOrTripleSp.gameObject then
		tAddMoney = (tMoney*2/10) /3 *10 
	elseif pTarget == m_OnceOrTwiceSp.gameObject then
		tAddMoney = tMoney /2 
	elseif pTarget == m_DoubleThreeSp.gameObject then
		tAddMoney = m_BBMoney *3 
	elseif pTarget == m_DoubleFourSp.gameObject then
		tAddMoney = m_BBMoney*4 
	end

	local tNeedMoney = m_PotBig - m_MyPot 
	tAddMoney = tAddMoney - tNeedMoney 
	m_AddBetObj:SetActive(false)
	m_AddBetBtn:SetActive(false)
	local tSendMsg = {}
	tSendMsg['type'] = 'holdem'
	tSendMsg['tag'] = 'bet'
	tSendMsg['body'] = tAddMoney
	this.mono:SendPackage(cjson.encode(tSendMsg))
	m_AddBetSlider.value = 0
	coroutine.start(function (  )
		coroutine.wait(0.2)
		if m_BtnObjAuto.activeSelf ==false then
			m_BtnObjAuto:SetActive(true)
			m_AutoKanObj:SetActive(true)
			m_AutoFollowGenObj:SetActive(false)
		end
	end)
end

function this:UserAllIn()
	m_IsAllin = true 
	m_BtnsObj:SetActive(false)
	m_AddBetBtn:SetActive(true)
	m_AddBetBtn1:SetActive(false)
	m_AddBetBtn2:SetActive(false)
	if m_AddBetObj.activeSelf then
		m_AddBetObj:SetActive(false)
	end
	m_BtnObjAuto:SetActive(false)
	this:AutoButtonReset()
	local tSendMsg = {}
	tSendMsg['type'] = 'holdem'
	tSendMsg['tag'] = 'bet'
	tSendMsg['body'] = -1
	m_IsGuo = false 
	this.mono:SendPackage(cjson.encode(tSendMsg))
	if m_AddBetObj.activeSelf then
		m_AddBetObj:SetActive(false)
		coroutine.start(function ()
			coroutine.wait(0.2)
			m_BtnObjAuto:SetActive(true)
			m_AutoKanObj:SetActive(true)
			m_AutoFollowGenObj:SetActive(false)
		end)
	end
end


function this:UserGen( )
	m_BtnsObj:SetActive(false)
	m_AddBetBtn:SetActive(true)
	m_AddBetBtn1:SetActive(false)
	m_AddBetBtn2 :SetActive(false)
	local tSendMsg = {}
	tSendMsg['type'] = 'holdem'
	tSendMsg['tag'] = 'bet'
	tSendMsg['body'] = 0
	this.mono:SendPackage(cjson.encode(tSendMsg))
	if m_AddBetObj.activeSelf then
		m_AddBetObj:SetActive(false)
	end
	coroutine.start(function ( )
		if m_BtnObjAuto.activeSelf  == false  then
			m_BtnObjAuto:SetActive(true)
			m_AutoKanObj:SetActive(true)
			m_AutoFollowGenObj:SetActive(false)
		end
	end)
end

function this:AutoSelect( pTarget )
	if pTarget == m_AutoQiObj then
	    if m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoKanObj.activeSelf and m_AutoKanObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "automatic_seecard" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
	        m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "seeorlose_click";
	        m_AutoQiObj:GetComponent('UIButton').normalSprite = "seeorlose_click";
	    elseif m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose_click" and m_AutoKanObj.activeSelf and m_AutoKanObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "automatic_seecard" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
	        m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "seeorlose";
	        m_AutoQiObj:GetComponent('UIButton').normalSprite = "seeorlose";
	    elseif m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoFollowGenObj.activeSelf and m_AutoFollowGenObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
	        m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "seeorlose_click";
	        m_AutoQiObj:GetComponent('UIButton').normalSprite = "seeorlose_click";
	    elseif m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose_click" and m_AutoFollowGenObj.activeSelf and m_AutoFollowGenObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
	        m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "seeorlose";
	        m_AutoQiObj:GetComponent('UIButton').normalSprite = "seeorlose";
	    end
	end

    if pTarget == m_AutoKanObj then
        if m_AutoKanObj.activeSelf and m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoKanObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "automatic_seecard" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
            m_AutoKanObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "automatic_seecard_click";
            m_AutoKanObj:GetComponent('UIButton').normalSprite = "automatic_seecard_click";
        elseif m_AutoKanObj.activeSelf and m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoKanObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "automatic_seecard_click" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
       
            m_AutoKanObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "automatic_seecard";
            m_AutoKanObj:GetComponent('UIButton').normalSprite = "automatic_seecard";
        end
 	end
    if pTarget == m_AutoFollowGenObj then
        if m_AutoFollowGenObj.activeSelf and m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoFollowGenObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
            m_AutoFollowGenObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "follow_select";
            m_AutoFollowGenObj:GetComponent('UIButton').normalSprite = "follow_select";
        elseif m_AutoFollowGenObj.activeSelf and m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoFollowGenObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_select" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
            m_AutoFollowGenObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "follow";
            m_AutoFollowGenObj:GetComponent('UIButton').normalSprite = "follow";
        end
	end
    if pTarget == m_AutoFollowAllObj then
        if m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoKanObj.activeSelf and m_AutoKanObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "automatic_seecard" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
            m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "follow_allbet_click";
            m_AutoFollowAllObj:GetComponent('UIButton').normalSprite = "follow_allbet_click";
        elseif m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoKanObj.activeSelf and m_AutoKanObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "automatic_seecard" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet_click" then
       
            m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "follow_allbet";
            m_AutoFollowAllObj:GetComponent('UIButton').normalSprite = "follow_allbet";   
        elseif m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoFollowGenObj.activeSelf and m_AutoFollowGenObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet" then
       
            m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "follow_allbet_click";
            m_AutoFollowAllObj:GetComponent('UIButton').normalSprite = "follow_allbet_click";
        elseif m_AutoQiObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "seeorlose" and m_AutoFollowGenObj.activeSelf and m_AutoFollowGenObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow" and m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName == "follow_allbet_click"  then
       
            m_AutoFollowAllObj:GetComponentInChildren(Type.GetType('UISprite',true)).spriteName = "follow_allbet";
            m_AutoFollowAllObj:GetComponent('UIButton').normalSprite = "follow_allbet";
        end
    end

end


function this:AutoButtonReset( )
	 if m_AutoQiSp.spriteName == "seeorlose_click" then
        m_AutoQiSp.spriteName = "seeorlose"
        m_AutoQiObj:GetComponent('UIButton').normalSprite = "seeorlose"
    end

    if  m_AutoKanSp.spriteName == "automatic_seecard_click" then
        m_AutoKanSp.spriteName = "automatic_seecard"
        m_AutoKanObj:GetComponent('UIButton').normalSprite = "automatic_seecard"
    end

    if m_AutoFollowGenSp.spriteName == "follow_select"  then
        m_AutoFollowGenSp.spriteName = "follow"
        m_AutoFollowGenObj:GetComponent('UIButton').normalSprite = "follow"
    end

    if m_AutoFollowAllSp.spriteName == "follow_allbet_click" then
    
        m_AutoFollowAllSp.spriteName = "follow_allbet"
        m_AutoFollowAllObj:GetComponent('UIButton').normalSprite = "follow_allbet"
    end
end

function this:ProcessEnter(pMessageObj )
	print('Process enter ')
	UISoundManager.Instance:PlayBGSound()
	SettingInfo.Instance.deposit = false 
	local tBody = pMessageObj['body']
	local tMemberInfos = tBody['memberinfos']
	local tDeskInfo = tBody['deskinfo']
	m_BBMoney = tonumber(tDeskInfo['bb_money'])

	m_SBMoney = tonumber(tDeskInfo['sb_money'])
	local tGamebleChips = tDeskInfo['gamble_chips']
	local tMaxAwards = tDeskInfo['max_awards']
	this:ChuShi(tGamebleChips,tMaxAwards)
	m_BBorsbLab.text = '盲注：'..tostring(m_SBMoney)..'/' ..tostring(m_BBMoney)
	
	
	for k,v in pairs(tMemberInfos) do 
		if v ~= nil then
			if tostring(v['uid']) == tostring(EginUser.Instance.uid) then
				local mIsWait  = false 
				m_PlayerNum[1] = tonumber(EginUser.Instance.uid)
				m_UserIndex = tonumber(v['position'])
				local tIsWaiting = v['waiting']
				local tBagMoney = tonumber(v['bag_money'])
				local tIntoMoney = tonumber(v['into_money'])
				local tAvatarNo = tonumber(v['avatar_no'])
				m_UserBagmoneyLab.text = tostring(tIntoMoney)
				m_MyMoney = tIntoMoney
				local tRoundNum = tonumber(v['round_num'])
				local tWinNum = tonumber(v['win_num'])
				local tLoseNum = tonumber(v['lose_num'])
				local tWinRate = tonumber(v['win_rate'])
				local tMaxWinMoney = tonumber(v['max_winmoney'])
				local tMaxCards = v['max_cards']
				local tMaxCardType = tonumber(v['max_cardtype'])
				local tNickName  = tostring(v['nickname'])
				local tLevel = tostring(v['level'])
				m_UserPlayerObj.name =  m_nnPlayerName..tostring(v['uid'])
				this:bindPlayerCtrl(m_UserPlayerObj.name,m_UserPlayerObj)
				if tIsWaiting then
					m_UserNickNameLab.text = '等待下一局'
					table.insert(m_WaitPlayerObjList,m_UserPlayerObj)
					mIsWait = true 
				else 
					table.insert(m_PlayingPlayerObjList,m_UserPlayerObj)
					table.insert(m_NotQiList,m_UserPlayerObj)
					m_IsReEnter = true 
				end
				
				m_UserPlayerCtrl =  this:getPlayerCtrl(m_UserPlayerObj.name)
				m_UserPlayerCtrl:SetPaiJiMessage(tRoundNum,tWinNum,tLoseNum,tWinRate,tMaxWinMoney,tMaxCardType,tMaxCards)
				m_UserPlayerCtrl:SetPlayerInfo(tAvatarNo,tNickName,tBagMoney,tLevel,v['uid'],tIntoMoney,mIsWait)
				if tAvatarNo %2 ==0 then
					m_Male.gameObject:SetActive(true)
					m_Female.gameObject:SetActive(false)
				else
					m_Male.gameObject:SetActive(false)
					m_Female.gameObject:SetActive(true)
				end
				break
			end
		end
	end

	for k,v in pairs(tMemberInfos) do 
		if v ~= nil then
			if tostring(v['uid']) ~= tostring(EginUser.Instance.uid) then
				this:AddPlayer(v,m_UserIndex)
			end
		end
	end

	-- print('process enter end ')
end

function this:AddPlayer(pMemberInfo,pUserIndex)
	-- print(' add player ==============')
	local tUid = tostring(pMemberInfo['uid'])
	local tBagMoney = tostring(pMemberInfo['bag_money'])
	local tIntoMoney = tostring(pMemberInfo['into_money'])
	local tNickName  = tostring(pMemberInfo['nickname'])
	local tAvatarNo = tonumber(pMemberInfo['avatar_no'])
	local tPos = tonumber(pMemberInfo['position'])
	local tReady = pMemberInfo['ready']
	local tWaiting = pMemberInfo['waiting']
	local tLevel = tostring(pMemberInfo['level'])
	local tRoundNum = tonumber(pMemberInfo['round_num'])
	local tWinNum = tonumber(pMemberInfo['win_num'])
	local tLoseNum = tonumber(pMemberInfo['lose_num'])
	local tWinRate = tonumber(pMemberInfo['win_rate'])
	local tMaxWinMoney = tonumber(pMemberInfo['max_winmoney'])
	local tMaxCards = pMemberInfo['max_cards']
	local tMaxCardType = tonumber(pMemberInfo['max_cardtype'])
	local tPositionSpan = tPos - pUserIndex
	local contentObj = this.transform:FindChild("Content").gameObject
	local  playerPrb = ResManager:LoadAsset("gamedzpk/dzpkplayer","DZPKPlayer")
	local tPlayer = NGUITools.AddChild(contentObj,playerPrb)
	tPlayer.name  = m_nnPlayerName..tUid
	this:bindPlayerCtrl(tPlayer.name,tPlayer)
	this:SetAnchorPosition(tPlayer,pUserIndex,tPos,tUid)
	local tCtrl = this:getPlayerCtrl(tPlayer.name)
	tCtrl:SetPlayerInfo(tAvatarNo,tNickName,tBagMoney,tLevel,tUid,tIntoMoney,tWaiting)
	tCtrl:SetPaiJiMessage(tRoundNum,tWinNum,tLoseNum,tWinRate,tMaxWinMoney,tMaxCardType,tMaxCards)
	
	if tWaiting then
		tCtrl:SetWait(true)
	else
		table.insert(m_PlayingPlayerObjList,tPlayer)
		table.insert(m_NotQiList,tPlayer)
	end
	return tPlayer
end

function this:SetAnchorPosition( pPlayer,pUserIndex,pPlayerIndex,pUid)
	-- print('set anchor ')
	local tPosSpan =  pPlayerIndex -pUserIndex
	local tAnchor = pPlayer:GetComponent('UIAnchor')
	local tV 
	local tIndex = 0 
	if tPosSpan == 0 then
		tAnchor.side = UIAnchor.Side.Center

	elseif tPosSpan ==1 or tPosSpan == -6 then
		tIndex =2
		
		tAnchor.side = UIAnchor.Side.BottomLeft
		tAnchor.relativeOffset = Vector2.New(0.27,0.255)
		tV = Vector3.New(539,969,0)
	elseif tPosSpan ==2 or tPosSpan == -5 then
		tIndex =3
		tAnchor.side = UIAnchor.Side.Left
		tAnchor.relativeOffset = Vector2.New(0.125,0.024)
		tV = Vector3.New(1052,431,0)
	elseif tPosSpan ==3 or tPosSpan == -4 then
		tIndex =4
		tAnchor.side = UIAnchor.Side.TopLeft
		tAnchor.relativeOffset = Vector2.New(0.27,-0.204)
		tV = Vector3.New(534,-114,0)
	elseif tPosSpan ==4 or tPosSpan == -3 then
		tIndex =5
		tAnchor.side = UIAnchor.Side.TopRight
		tAnchor.relativeOffset = Vector2.New(-0.27,-0.204)
		tV = Vector3.New(-736 ,-113,0)
		-- -736 -113
	elseif tPosSpan ==5 or tPosSpan == -2 then
		tIndex =6
		tAnchor.side = UIAnchor.Side.Right
		tAnchor.relativeOffset = Vector2.New(-0.123,0.024)
		tV = Vector3.New(-1622,430 ,0)
		--  -1258  430 
	elseif tPosSpan ==6 or tPosSpan == -1 then
		tIndex =7
		tAnchor.side = UIAnchor.Side.BottomRight
		tAnchor.relativeOffset = Vector2.New(-0.27,0.255)
		tV = Vector3.New(-736,969 ,0)
	end
	print('index  == '.. tIndex)
	if tPosSpan ~= 0 then 
		m_PlayerNum[tIndex] = pUid
		this:getPlayerCtrl(pPlayer.name):SetCardTarget(tIndex,tV)
	else

	end
end


function this:ProcessReady( pMessageObj )
	-- print('process ready ')
	local tUid = tostring(pMessageObj['body'])
	local tPlayer = find(m_nnPlayerName..tUid)
	if tostring(tUid) == tostring(EginUser.Instance.uid) then
		this:getPlayerCtrl(tPlayer.name):SetDeal(false,nil)
		this:getPlayerCtrl(tPlayer.name):ClearPais()
	end
end

function this:ProcessDeskOver( pMessageObj)
	-- print('Desk over ')
end
function this:ProcessUpdateAllIntomoney(pMessageObj)
	-- print('update all money ')
	local msgStr = cjson.encode(pMessageObj)
  	if string.find(msgStr,tostring(EginUser.Instance.uid))==nil then
	    return
	end

	local tInfos = pMessageObj['body']
	for k,v in pairs(tInfos) do 
		local tUid = v[1] 
		local tIntoMoney = v[2]
		local tPlayer = find(m_nnPlayerName..tUid)
		this:getPlayerCtrl(tPlayer.name):UpdateIntomoney(tIntoMoney)
	end
	-- m_UserPlayerCtrl:UpdateIntomoney
end
function this:ProcessGameEmotion(pMessageObj )
	print('ProcessGameEmotion ')
	m_EndTime = Time.time
	local tBody = pMessageObj['body']
	local tId = tBody[1]
	local tNum = tBody[2]
	local tPlayer = find(m_nnPlayerName..tId)
	this:getPlayerCtrl(tPlayer.name):SetEmotion(tNum)
end


function this:ProcessGameBuySuccess( pMessageObj)
	-- print('GameBuySuccess ')
	m_GiftEndTime = Time.time 
	local tBody = pMessageObj['body']
	local tOwnId = tBody[1]
	local tOtherId= tBody[2]
	local tPid = tBody[3]
	local tLiWuCount = tBody[4]
	local tMoney = tBody[5]
	local tBagMoney = tBody[6]
	local tCostMoney= tBody[7]
	local tOwnPlayer = find(m_nnPlayerName..tOwnId)
	local tOtherPlayer = find(m_nnPlayerName..tOtherId)
	local tStartPos = tostring(tOwnPlayer:GetComponent('UIAnchor').side)
	local tEndPos = tostring(tOtherPlayer:GetComponent('UIAnchor').side)
 -- gameObject.GetComponent<SendGift>().GiftSend(startposition, endposition, pid, otherId);
	this:GiftSend(tStartPos,tEndPos,tPid,tOtherId)
	this:getPlayerCtrl(tOwnPlayer.name):SetBagMoney(tCostMoney)
end

function this:ProcessGameBuyError( pMessageObj )
	-- print('Buy error ')
end
function this:ProcessGameBuyNoMoney( pMessageObj )
	-- print('Buy No ')
end


function ProcessUpdateIntomoney( pMessageObj )
	if pMessageObj ~= nil then
		-- local tInfo = find('Panel_info')
		-- if tInfo ~= nil then
			print(' update the money ')

			m_UserPlayerCtrl:UpdateIntomoney(tostring(pMessageObj['body']))
			-- m_MyMoney = tonumber(pMessageObj['body'])
			-- info.GetComponent<FootInfo_DZPK>().UpdateIntomoney(intoMoney);
		-- end
	end

end

function this:ProcessCome(pMessageObj)
	local tBody = pMessageObj['body']
	local tMemberInfo = tBody['memberinfo']


	local tIsIn = false 
	for k,v in pairs(m_PlayingPlayerObjList) do 
		if IsNil(v.gameObject) ==false then
			local tUid = tostring(tMemberInfo['uid'])
			local tName = m_nnPlayerName..tUid 
			-- print('Uid =============  '..v.name   )
			if v.name == tName then
				tIsIn = true 
			end
		end
	end
	if tIsIn == false then
		local tPlayer = this:AddPlayer(tMemberInfo,m_UserIndex)
	end
end


function this:ProcessHurry( pMessageObj )
	print('ProcessHurry')
	m_LanguageEndTime = Time.time
	local tBody = pMessageObj['body']
	local tSpokeMan = tBody['spokesman']
	local tIndex = tBody['index']
	this:getPlayerCtrl(m_nnPlayerName..tSpokeMan):SetMessage(tIndex)
end

function this:ProcessGamble_ChipError(pMessageObj )
	print('ProcessGamble_ChipError')
end


function this:ProcessLeave( pMessageObj )
	local tUid = pMessageObj['body']
	if tostring(tUid) ~= tostring( EginUser.Instance.uid) then
		local tPlayer = find(m_nnPlayerName..tUid)
		if tableContains(m_PlayingPlayerObjList,tPlayer) == true then
			tableRemove(m_PlayingPlayerObjList,tPlayer)
		end
		destroy(tPlayer)
	else
		this:UserQuit()
	end
end

function this:UserLeave(  )
	print('leave ')
	local tSendMsg = {}
	tSendMsg['type'] = 'game'
	tSendMsg['tag'] = 'leave'
	tSendMsg['body'] = EginUser.Instance.uid
	this.mono:SendPackage(cjson.encode(tSendMsg))
end

function this:UserQuit(  )
	print('user quit  ')
	SocketConnectInfo.Instance.roomFixseat = true
	local tSendMsg = {}
	tSendMsg['type'] = 'game'
	tSendMsg['tag'] = 'quit'
	-- tSendMsg['body'] = EginUser.Instance.uid
	this.mono:SendPackage(cjson.encode(tSendMsg))
	this.mono:OnClickBack()
end

function this:ProcessProps( pMessageObj )
	-- local tBody = pMessageObj['body']
	-- local  tMemberInfos = tBody['memberinfo']
	-- local tPlayer = this:AddPlayer(tMemberInfos,m_UserIndex)
	-- if m_IsPlaying then
	-- 	this:getPlayerCtrl(tPlayer.name):SetWait(true)
	-- 	this:getPlayerCtrl(tPlayer.name):SetReady(false)
	-- end
end

function this:OnClickBack(  )
	SettingInfo.Instance.bgVolume = m_BGSlider.value
	SettingInfo.Instance.effectVolume = m_YinXiaoSilder.value
	SettingInfo.Instance:SaveInfo()
	if m_IsPlaying == false then
		this:UserQuit()
	else
		m_MsgQuitObj:SetActive(true)
	end
end

function this:ProcessNotcontinue(  )
	coroutine.wait(3)
end

function this:ShowPromptHUD(pErrorInfo)
	m_MsgAccountFailedObj:SetActive(true)
	m_MsgAccountFailedObj:GetComponentInChildren('UILabel').text = pErrorInfo
end

function this:OnButtonClick(pTarget)

end

function this:ChangePoKeValue( pHandCards )
	-- print('cahnge poke value ')
	for i=1,pHandCards.Length do
		if tonumber(pHandCards[i])<=52 then 
			local tCardCount = pHandCards[i] +1 
			if tCardCount == 13 then
				tCardCount = 0 
			elseif tCardCount == 26 then
				tCardCount = 13
			elseif tCardCount == 39 then
				tCardCount= 26
			elseif tCardCount == 52 then
				tCardCount = 39		
			end
			pHandCards[i] = tCardCount
		end
	end
end


function this:CloseLaoHuJi( )
	m_SmallGameObj:SetActive(false)
	m_GameBtnSp.spriteName = 'console'
end
function this:Close(pTarget )
	if pTarget == m_XieDaiDaoJuObj.transform:FindChild('userinfo/close').gameObject then
		this:ChuShiDaoJu()
	end
	pTarget.transform.parent.transform.parent.gameObject:SetActive(false)
end

function this:CloseMarkView( )
	m_SettingListObj.gameObject:SetActive(false)
	m_CardTypePromptObj:SetActive(false)
	m_CardPromptSp.spriteName = 'cardtype'
	m_TalkObj.gameObject:SetActive(false)
	m_BiaoQingPanelObj:SetActive(true)
	m_RabbitPanelObj:SetActive(false)
	m_HuLiPanelObj:SetActive(false)
	m_BiaoQingBtn_Sp.spriteName = 'biaoqing'
	m_ChangYongYuObj:SetActive(false)
	m_MessageTalkSp.spriteName= 'message'
	m_SelectWuPinPanelObj:SetActive(false)
	m_SelectMoneyPanelObj:SetActive(false)
	m_SelectMoneyPanelObj:GetComponent('UISprite').spriteName = 'betbutton'
end

function this:OnDestroy()
	log("--------------------ondestroy of  dzpkPanel")
	this:ClearLuaValue()
end


------------------------TopBureaureview   部分  

function this:SetPublicCards(pCards)
	for i=1,#pCards do 

		table.insert(m_PublicCardValueList,tonumber(pCards[i]))
	end
end

function this:SetOwnCards(pCards)
	m_OwnValueList = {}
	-- print('----------set own card s -----------------')
	-- print(pCards[1])
	-- print(pCards[2])
	for i=1,#pCards do 
		table.insert(m_OwnValueList,tonumber(pCards[i]))
	end
end

function this:SetLastCardType(pHandType,pHandCards)
	local tCardType = ''
	local tCardNum = ''
	if pCardType ==-1 then
		tCardType = '未亮牌'
	elseif pCardType == 0 then
		tCardType = '高牌'
		local tCardCount = tonumber(pHandCards[1])%13 +1
		tCardNum = '最大为'..m_PokeValue[tCardCount]
	elseif pCardType == 1 then
		tCardType = '对子'
		local tCardCount = tonumber(pHandCards[1])%13 +1
		tCardNum = '一对为'..m_PokeValue[tCardCount]
	elseif pCardType == 2 then
		tCardType = '两对'
		local tCardCount1 = tonumber(pHandCards[1])%13 +1
		local tCardCount2 = tonumber(pHandCards[2])%13 +1
		tCardNum = '一对为'..m_PokeValue[tCardCount1]..'一对为'..m_PokeValue[tCardCount2]
	elseif pCardType == 3 then
		tCardType = '三条'
		local tCardCount = tonumber(pHandCards[1])%13 +1
		tCardNum = '三条为'..m_PokeValue[tCardCount]
	elseif pCardType == 4 then
		tCardType = '顺子'
		for i=1,5 do 
			local tCardCount = tonumber(pHandCards[i])%13 +1
			tCardNum =tCardNum.. m_PokeValue[tCardCount]
		end

	elseif pCardType == 5 then
		tCardType = '同花'
		for i=1,5 do 
			local tCardCount = tonumber(pHandCards[i])%13 +1
			tCardNum =tCardNum.. m_PokeValue[tCardCount]
		end
	elseif pCardType == 6 then
		tCardType = '葫芦'
		local tCardCount1 = tonumber(pHandCards[1])%13 +1
		local tCardCount2 = tonumber(pHandCards[2])%13 +1
		tCardNum = '三条为'..m_PokeValue[tCardCount1]..'，两个'..m_PokeValue[tCardCount2]
	elseif pCardType == 7 then
		tCardType = '四条'
		local tCardCount = tonumber(pHandCards[1])%13 +1
		tCardNum = '四条为'..m_PokeValue[tCardCount]
	end
	m_OwnCardType = tCardType..':'..tCardNum
end

function this:ResetView(pMessageObj)
	local tChouMa = m_HuiGuParentObj:GetComponentsInChildren(Type.GetType('UIDragScrollView',true))
	-- if #tChouMa > 0 then
		for i =0,tChouMa.Length-1 do 
			destroy(tChouMa[i].gameObject)
		end
	-- end 
	local tBody = pMessageObj['body']
	local tPlayerInfo = tBody['players_info']
	local tNum = 0 
	for i=1,#tPlayerInfo do 
		local tUid = tonumber(tPlayerInfo[i]['uid'])
		if tUid == tonumber(EginUser.Instance.uid) then
			tNum = 1 
			break;
		end
	end
	local tResWin = ResManager:LoadAsset('gamedzpk/ying_player','ying_player')
	
	local tResLose = ResManager:LoadAsset('gamedzpk/shu_player','shu_player')
	for i =1,#tPlayerInfo do 
		local tUid = tonumber(tPlayerInfo[i]['uid'])
		local tWinMoney = tonumber(tPlayerInfo[i]['winmoney'])
		local tHandType = tonumber(tPlayerInfo[i]['hand_type'])
		local tOwnCards = tPlayerInfo[i]['cards']
		local tPublicCards = tPlayerInfo[i]['hand_cards']
		local tPlayer = find(m_nnPlayerName..tUid)
		local tName  = this:getPlayerCtrl(tPlayer.name):GetName() 
		local tHuiGu 
		if tWinMoney > 0 then 
			tHuiGu = GameObject.Instantiate(tResWin)
		else
			tHuiGu = GameObject.Instantiate(tResLose)
		end
		tHuiGu.transform.parent = m_HuiGuParentObj.transform
		if tostring(tUid) == tostring(EginUser.Instance.uid) then
			tHuiGu.transform.localPosition = Vector3.zero
	
			tHuiGu.transform:FindChild('card_1'):GetComponent('UISprite').spriteName = 'card_'..m_OwnValueList[1]
			tHuiGu.transform:FindChild('card_2'):GetComponent('UISprite').spriteName = 'card_'..m_OwnValueList[2]
			tHuiGu.transform:FindChild('scord_1'):GetComponent('UILabel').text = m_OwnCardType
		else
			tHuiGu.transform.localPosition = Vector3.New(0,-97*tNum,0)
			if #tOwnCards >1 then
				tHuiGu.transform:FindChild('card_1'):GetComponent('UISprite').spriteName = 'card_'..tOwnCards[1]
				tHuiGu.transform:FindChild('card_2'):GetComponent('UISprite').spriteName = 'card_'..tOwnCards[2]
			else
				tHuiGu.transform:FindChild('card_1'):GetComponent('UISprite').spriteName = 'card_green'
				tHuiGu.transform:FindChild('card_2'):GetComponent('UISprite').spriteName = 'card_green'
			end
			this:SetLastCardType(tHandType,tPublicCards)
			tHuiGu.transform:FindChild('scord_2'):GetComponent('UILabel').text =  m_OwnCardType
			tNum = tNum +1 
		end
		tHuiGu.transform.localScale  = Vector3.one

		tHuiGu.transform:FindChild('name'):GetComponent('UILabel').text  = tName
		if tWinMoney>0 then
			tHuiGu.transform:FindChild('scord_1'):GetComponent('UILabel').text = '+'..tWinMoney
		else
			tHuiGu.transform:FindChild('scord_1'):GetComponent('UILabel').text = tWinMoney
		end
	end
	for i=1,#m_PublicCardsTopList do 
		m_PublicCardsTopList[i].alpha = 1 
		m_PublicCardsTopList[i].spriteName = 'card_green'
	end
	for i=1,#m_PublicCardValueList do 
		m_PublicCardsTopList[i].spriteName = 'card_'..m_PublicCardValueList[i]
	end
	-- m_OwnValueList = {}
end

function this:ChuShiDaoJu(  )
	m_HolidayPanelSp.spriteName = 'holiday_select'
	m_DecoratePanelSp.spriteName = 'decorate'
	m_GoodLuckPanelSp.spriteName = 'lucky'
	m_FoodPanelSp.spriteName = 'food'
	m_HolidayObj:SetActive(true)
	m_DecorateObj:SetActive(false)
	m_GoodLuckObj:SetActive(false)
	m_FoodObj:SetActive(false)
	if m_HolidayObj.activeSelf then
		for i=1,6 do 
			m_HolidayObj.transform:FindChild('holiday_'..i).gameObject:GetComponent('UISprite')spriteName = 'daojuboard'
		end
	end
end

function this:SetPresentUid(pUid  )
	m_PresentUid = pUid

end


function this:GiftSend( pStartPos,pEndPos,pUid,pOtherId )
	local tPlayer = find(m_nnPlayerName..pOtherId)
	local tParentT= this.transform:FindChild('Panel_background/Sprite5_glow_black')
	local tStartMove  = tParentT:FindChild(pStartPos)
	local tEndMove 
	local tHideTime = 0 
	if tonumber(pUid) < 34 then
		tHideTime = 0.5
		tEndMove =  tParentT:FindChild(pEndPos)

	else
		tHideTime = 1.5 
		tEndMove = tParentT:FindChild(pEndPos)
	end
	-- if tostring(pOtherId) == tostring(EginUser.Instance.uid) then
	-- local tObj = tPlayer.transform:FindChild('Output/Sprite_lipin_1/liwu_9(Clone)').gameObject
	-- if  tObj ~= nil then
	-- 	coroutine.start(function ()
	-- 		coroutine.wait(0.7)
	-- 		if tObj ~= nil then 
	-- 			destroy(tObj)
	-- 		end
	-- 	end)
	-- end
	local tInitPre  
	local tAniPre 
	
	if tonumber(pUid) < 34 then
		local tIndex = pUid -25
		local tRes = ResManager:LoadAsset('gamedzpk/liwu_'..tIndex,'liwu_'..tIndex)
		tInitPre = GameObject.Instantiate(tRes) 
	
		 -- local tSpName = {'dan','playerInfo_props_icon_2','playerInfo_props_icon_3','playerInfo_props_icon_4','playerInfo_props_icon_5','fanqie','playerInfo_props_icon_1001','playerInfo_props_icon_1002'}
		 -- tRes.transform:FindChild('liwu_1').gameObject:GetComponent('UISprite').spriteName = tSpName[tIndex]
		tInitPre.transform.parent = tParentT
	else
		local tRes = ResManager:LoadAsset('gamedzpk/liwu_9','liwu_9')
		tInitPre = GameObject.Instantiate(tRes) 
		tInitPre.transform.parent = tPlayer.transform.FindChild("Output/Sprite_lipin_1")
	end
	tInitPre.transform.position = tStartMove.position
	if tonumber(pUid) > 33 then
		 tInitPre.transform:FindChild("liwu_1"):GetComponent('UISprite').spriteName = "lipin_" ..pUid
	end
	tInitPre.transform.localScale = Vector3.one
	tInitPre:AddComponent(Type.GetType('TweenScale',true)) 
	tInitPre:GetComponent('TweenScale').from = Vector3.zero
	tInitPre:GetComponent('TweenScale').to = Vector3.one
	tInitPre:GetComponent('TweenScale').duration = 0.2
	coroutine.start(function ( )
		coroutine.wait(0.2)
		UISoundManager.Instance:PlaySound('mf_feixing')
		iTween.MoveTo(tInitPre,iTween.Hash('position',tEndMove.transform.position,'easetype',iTween.EaseType.linear,'time',0.5))
		coroutine.start(function ()
			coroutine.wait(0.6)
			if pUid > 33 then
				this:getPlayerCtrl( tPlayer.name):SetPresentObjAct(false)
			end
		end)
		coroutine.start(function ( )
			coroutine.wait(tHideTime)
			if pUid < 34 then
				destroy(tInitPre)
				this:PlayGiftAni(pUid,tEndMove)
			end
		end)
	end)
end


function this:PlayGiftAni( pUid , pEndPos)
	local tIndex = pUid -25
	local tRes = ResManager:LoadAsset('gamedzpk/giftanimation_'..tIndex,'giftanimation_'..tIndex)
	local tObj =  GameObject.Instantiate(tRes)
	local tParentT= this.transform:FindChild('Panel_background/Sprite5_glow_black')
	tObj.transform.parent = tParentT
	tObj.transform.localScale = Vector3.one
	tObj.transform.localPosition = pEndPos.localPosition
	coroutine.start(function ( )
		coroutine.wait(1.2)
		destroy(tObj)
	end)
end




function this:SetBetVolume()
	if m_SuoFang > 0.6 then
		m_SuoFang = m_BetMachineVolum.value 
	else
		if not m_IsBottom then
			m_IsBottom = true 
			this:KaiShi()
		end
		m_BetMachineVolum.value = 1 
	end
end

function this:KaiShi( )
	m_MachineIsOver = false 
	m_MachineIsEnd = false 
	local tSelectSpriteName = m_SelectTexBtnSp.spriteName 
	local tIndex = tonumber(string.sub(tSelectSpriteName,-1))
	local tChipMoney = tonumber(m_BetMoneyLab.text)
	local tSendMsg = {}
	tSendMsg['type'] = 'game'
	tSendMsg['tag'] = 'gamble'
	tSendMsg['body'] = {}
	table.insert(tSendMsg['body'],tChipMoney)
	table.insert(tSendMsg['body'],tIndex)
	this.mono:SendPackage(cjson.encode(tSendMsg))
	m_SelectTexParent:SetActive(false)
	m_SelectMoneyParent.gameObject:SetActive(false)
	m_SelectTexBtnSp.gameObject:GetComponent('BoxCollider').enabled = false 
	m_SelectMoneySp.gameObject:GetComponent('BoxCollider').enabled = false 
	m_SelectBoardSp.gameObject:GetComponent('BoxCollider').enabled = false 

end

function this:InitBetMachine( )
	this.mono:AddClick(m_SelectTexBtnSp.gameObject,function ()
		m_SelectTexParent:SetActive(true)
	end)
	this.mono:AddClick(m_SelectMoneyBtnObj,function ( )
		m_SelectMoneyParent.gameObject:SetActive(true)
		m_BetMoneyLab.text = tostring(m_MachineMoney)
		m_SelectMoneySp.spriteName = 'betbutton_click'
		m_SelectTexParent:SetActive(false)
	end)
	this.mono:AddSlider(m_BetMachineVolum,function (  )
		this:SetBetVolume()
	end)

	this.mono:AddClick(m_AutoBetSp.gameObject,function ( )
		if m_AutoBetSp.spriteName == 'zidongxuankuang' then 
			m_AutoBetSp.spriteName = 'zidongxuankaung_select'
			m_SelectTexBtnSp.gameObject:GetComponent('BoxCollider').enabled =false 
			m_SelectMoneySp.gameObject:GetComponent('BoxCollider').enabled = false 
			m_SelectBoardSp.gameObject:GetComponent('BoxCollider').enabled = false 
			 m_UpdateCount = 0
			m_MachineIsAuto = true 

		else
			m_AutoBetSp.spriteName = 'zidongxuankuang'
			m_MachineIsAuto = false 
			if m_MachineIsOver then
				m_SelectTexBtnSp.gameObject:GetComponent('BoxCollider').enabled =true 
				m_SelectMoneySp.gameObject:GetComponent('BoxCollider').enabled = true 
				m_SelectBoardSp.gameObject:GetComponent('BoxCollider').enabled = true 
			end
		end
	end)

	for i=1,7 do 
		local tSelectObj =  m_SelectTexParentList.transform:FindChild('child_'..i).gameObject
		this.mono:AddClick(tSelectObj,function ( )
			m_SelectTexBtnSp.spriteName =  tSelectObj:GetComponent('UISprite').spriteName
			m_SelectTexParent:SetActive(false)
		end)
	end

	for i=1,3 do

		local tSelectObj =  m_SelectMoneyParent.transform:FindChild('SelectBetMoney_'..(i-1)).gameObject
		this.mono:AddClick(tSelectObj,function ( )
			tSelectObj:GetComponent('UISprite').spriteName = 'xiazhu_select'
			m_MachineMoney = tonumber(tSelectObj.transform:FindChild('Label_'..(i-1) ):GetComponent('UILabel').text)
			m_BetMoneyLab.text = tostring(m_MachineMoney)
			m_MaxJiangLiLab.text  = tostring(m_MaxJiangLiList[i])
			
			m_SelectMoneyParent.gameObject:SetActive(false)
			m_SelectMoneySp.spriteName = 'betbutton'
			m_WinLabelParentObj.transform.localPosition = Vector3.New(m_YingQuPos.x - (i-1)*8,m_YingQuPos.y,0)
			for j=1,3 do 
				if tSelectObj.name ~= 'SelectBetMoney_'..(j-1) then
					m_SelectMoneyParent.transform.FindChild("SelectBetMoney_" .. (j-1)):GetComponent('UISprite').spriteName = "bet"
				end
			end
		end)
	end
end

function this:ZiDong(  )
	if m_MachineIsEnd then
		this:KaiShi()
	end
end

function this:ChuShi(pGambleChips,pMaxReward)
	for i=1,3 do 
		local tLab = m_SelectMoneyParent.transform:FindChild('SelectBetMoney_'..(i-1)..'/Label_'..(i-1)).gameObject:GetComponent('UILabel')
		tLab.text = tostring(pGambleChips[i])
		m_MaxJiangLiList[i] = tonumber(pMaxReward[i])
	end
	m_MachineMoney = pGambleChips[1]
	m_MaxJiangLiLab.text = tostring(pMaxReward[1])

	m_YingQuPos = m_WinLabelParentObj.transform.localPosition
end

function this:ChangePosition(pWinMoney,pRandomCount,pWuPinList,pBagMoney)
	
	m_LuckyObj:SetActive(true)
	m_WinLabelParentObj:SetActive(false)
	m_WinMoneyLab.gameObject:SetActive(false)
	for i=1,3 do 
		this:MoveToTarget(m_ListParent[i],i,m_WuPinIndex[i],pWuPinList[i],true,pWinMoney,pBagMoney)
		m_WuPinIndex[i] =tonumber(pWuPinList[i])
	end
	this:MoveToTarget(m_SystemSelectTextureParent,-1,m_SelectIndex,pRandomCount,false,pWinMoney,pBagMoney)
	m_SelectIndex = pRandomCount
end

function this:MoveToTarget( pTarget,pK,pWuPinIndex,pTargetNum,pThreeList,pWinMoney,pBagMoney )
	local pChildCount = pTarget:GetComponentsInChildren(Type.GetType('UISprite',true))
	if tonumber(pWuPinIndex )<= tonumber(pTargetNum )then
		pWuPinIndex = pWuPinIndex +7 -pTargetNum
	else
		pWuPinIndex = pWuPinIndex - pTargetNum
	end

	local tMovePos = 0
	if pThreeList then
		if pK== 1 or pK==2 then 
			tMovePos = 67*14+67*pWuPinIndex
		else
			tMovePos = 67*21+67*pWuPinIndex
		end
	else
		tMovePos = 67*7+67*pWuPinIndex
	end
	local tEndTargetPosition = Vector3.New(pTarget.transform.localPosition.x,pTarget.transform.localPosition.y- tMovePos,pTarget.transform.localPosition.z )
	local tLeiXing = {}
	tLeiXing[1] = pTarget
	tLeiXing[2] = tMovePos
	tLeiXing[3] = pK
	tLeiXing[4] = pWinMoney
	tLeiXing[5] = pBagMoney
	local tTimeList = {2.5,3,3.5}
	local tTime = tTimeList[pK]
	if pChildCount.Length ~= 4 then
		tTime = 2
	end


	iTween.MoveTo(pTarget,this.mono:iTweenHashLua('position',tEndTargetPosition,'time',tTime,'islocal',true,"easetype", iTween.EaseType.linear,'oncomplete',this.ResetPosition,'oncompleteparams',tLeiXing,'oncompletetarget',this.gameObject))

	if pChildCount.Length == 4 then
		m_YList[pK] = m_ListParent[pK].transform.localPosition.y
	else
		m_SystemY = pTarget.transform.localPosition.y
	end
end


function this:ResetPosition(pLeiXing )
	local tTarget = pLeiXing[1]
	local tBetweenPos = pLeiXing[2]
	local tK = tonumber(pLeiXing[3])
	local tWinMoney = tonumber(pLeiXing[4])
	local tBagMoney = tonumber(pLeiXing[5])
	tTarget.transform.localPosition =Vector3.New(tTarget.transform.localPosition.x,-16,0) 
	tChildCount = tTarget:GetComponentsInChildren(Type.GetType('UISprite',true))
	
	if tChildCount.Length == 4 then
		for i=1,4 do 
			local tChild = m_ChildList[tK][i]
			local tY =  tChild.transform.localPosition.y -tBetweenPos 
			tChild.transform.localPosition = Vector3.New(tChild.transform.localPosition.x,tY,0) 
			if tY == -134 then 
				tChild.transform.localPosition = Vector3.New(tChild.transform.localPosition.x,134,0)
				tY = tChild.transform.localPosition.y
				local tSpName = tChild:GetComponent('UISprite').spriteName
				local tSpIndex= tonumber(string.sub(tSpName,-1))
				if tSpIndex >= 4 then
					tSpIndex = tSpIndex -4 
				else
					tSpIndex = tSpIndex +3 
				end
				tChild:GetComponent('UISprite').spriteName = 'listwupin_'..tSpIndex
			end
			if tY ~= 134 and tY ~= 67 and tY~= 0 and tY ~= -67 then
				for j=1,9999 do
					local tMoveCount = tChild.transform.localPosition.y + 67*4*j
					if tMoveCount == 134 or tMoveCount ==67 or tMoveCount==0 or tMoveCount == -67 then
						tChild.transform.localPosition = Vector3.New(tChild.transform.localPosition.x,tMoveCount,0)
						local tMoveIndex = (4*j)%7
						local tChildSpName = tChild:GetComponent('UISprite').spriteName
						local tChildSpIndex= tonumber(string.sub(tChildSpName,-1))
						if tChildSpIndex - tMoveIndex >=0 then
							tChild:GetComponent('UISprite').spriteName = 'listwupin_'..(tChildSpIndex- tMoveIndex)
						else
							tChild:GetComponent('UISprite').spriteName = 'listwupin_'..(tChildSpIndex- tMoveIndex +7)
						end
						break
					end
				end
			end
		end
	elseif tChildCount.Length == 2 then
		for i=1,2 do 
			local tChild = m_SystemChildList[i]
			local tY =  tChild.transform.localPosition.y -tBetweenPos  
			tChild.transform.localPosition = Vector3.New(tChild.transform.localPosition.x,tY,0)
			if tY == -67 then 
				tChild.transform.localPosition = Vector3.New(tChild.transform.localPosition.x,67,0)
				tY = tChild.transform.localPosition.y
				local tSpName = tChild:GetComponent('UISprite').spriteName
				local tSpIndex= tonumber(string.sub(tSpName,-1))
				if tSpIndex >= 2 then
					tSpIndex = tSpIndex -2 
				else
					tSpIndex = tSpIndex +5 
				end
				tChild:GetComponent('UISprite').spriteName = 'listwupin_'..tSpIndex
			end
			if tY ~= 67 and tY ~= 0 then
				for j=1,9999 do
					local tMoveCount = tChild.transform.localPosition.y + 67*2*j
					if  tMoveCount ==67 or tMoveCount==0 then
						tChild.transform.localPosition = Vector3.New(tChild.transform.localPosition.x,tMoveCount,0)
						local tMoveIndex = (4*j)%7
						local tChildSpName = tChild:GetComponent('UISprite').spriteName
						local tChildSpIndex= tonumber(string.sub(tChildSpName,-1))
						if tChildSpIndex - tMoveIndex >=0 then
							tChild:GetComponent('UISprite').spriteName = 'listwupin_'..(tChildSpIndex- tMoveIndex)
						else
							tChild:GetComponent('UISprite').spriteName = 'listwupin_'..(tChildSpIndex- tMoveIndex +7)
						end
					end
				end
			end
		end
	end	

	if tK == 2 then
		this:SetWinMoney(tWinMoney,tBagMoney)
	end
end

function this:SetWinMoney( pWinMoney,pBagMoney )
	m_LuckyObj:SetActive(false)
	m_WinMoneyLab.text = tostring(pWinMoney)
	m_WinMoneyLab.gameObject:SetActive(true)
	local tPlayer = find('DZPKPlayer_'..EginUser.Instance.uid)
	this:getPlayerCtrl(tPlayer.name):SetBagMone(pBagMoney)
 	
 	coroutine.start(function ( )
 		local tTime = 0
 		while(tTime<2) do 
	    	if m_ShanGuang.activeSelf then
	    		m_ShanGuang:SetActive(false)
	    	else
	    		m_ShanGuang:SetActive(true)
	    	end
	    	tTime = tTime+0.2
	    	coroutine.wait(0.2)
	    end
    end)



	m_IsShift = true 
	coroutine.start(function ( )
		coroutine.wait(2)
		m_WinLabelParentObj:SetActive(true)
		m_LuckyObj:SetActive(false)
		m_WinMoneyLab.gameObject:SetActive(false)
		m_MachineIsEnd = true
		m_MachineIsOver = true
		m_IsBottom = false 
		m_SuoFang = 1 
		m_SelectTexBtnSp:GetComponent('BoxCollider').enabled = true
		m_SelectMoneySp:GetComponent('BoxCollider').enabled = true
		m_SelectBoardSp:GetComponent('BoxCollider').enabled = true
	end)
end


function this:ChangeChildPosition()
	for i=1,3 do 
		if m_YList[i] - m_ListParent[i].transform.localPosition.y >= 67 then
			m_YList[i] = m_YList[i] - 67 
			local tSmallCount = 9999999 
			local tObj 
			for j=1,4 do 
				if m_ChildList[i][j].transform.localPosition.y < tSmallCount then
					tObj = m_ChildList[i][j]
					tSmallCount = m_ChildList[i][j].transform.localPosition.y
				end

			end
			tObj.transform.localPosition = Vector3.New(tObj.transform.localPosition.x,tObj.transform.localPosition.y + 67*4,0)
			local tSp = tObj:GetComponent('UISprite').spriteName
			local tIndex = tonumber(string.sub(tSp,-1))
			if tIndex >=4 then
				tIndex = tIndex - 4
			else
				tIndex = tIndex + 3 
			end

			tObj:GetComponent('UISprite').spriteName = 'listwupin_'..tIndex
		end
	end
end

function this:ChangeChildPosition_1()
	if m_SystemY - m_SystemSelectTextureParent.transform.localPosition.y >= 67 then 
		m_SystemY = m_SystemY - 67 
		local tSmallCount = 9999999 
		local tObj  
		for i=1,2 do 
			if m_SystemChildList[i].transform.localPosition.y < tSmallCount then
				tObj = m_SystemChildList[i]
				tSmallCount  = m_SystemChildList[i].transform.localPosition.y 
			end
		end
		tObj.transform.localPosition = Vector3.New(tObj.transform.localPosition.x,tObj.transform.localPosition.y + 67*2,0)
		local tSp = tObj:GetComponent('UISprite').spriteName
		local tIndex = tonumber(string.sub(tSp,-1))
		if tIndex >=2 then
			tIndex = tIndex -2 
		else
			tIndex = tIndex +5 
		end
		tObj:GetComponent('UISprite').spriteName = 'listwupin_'..tIndex
	end 
end

function this:GetEndTime() 
 	return m_EndTime
 end 

 function this:ReturnMessageError()
 	return m_MessageError
 end

function this:BackIsContain()
	return m_PlayerContainsMyself
end
 