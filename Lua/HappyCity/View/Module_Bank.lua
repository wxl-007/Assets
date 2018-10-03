local cjson = require "cjson"							
require "HappyCity/View/BankSocket"							
local this = BankSocket:New()							
Module_Bank = this							
this.hallBankPwd  = "";							
this.eBankLoginType = {['PASSWORD'] = 0, ['PHONE_CODE']=1, ['WECHAT']=2}							
this.loginType = this.eBankLoginType.PASSWORD	


function this:Module_BankInit()							
    						
					-- print(' =========='..this.gameObject.name)
    self.kBagMoney = this.transform:FindChild("Offset/Views/Save/Text_BagMoney/Input/Label").gameObject:GetComponent("UILabel");							
    self.kSaveMoney = this.transform:FindChild("Offset/Views/Save/Save/Input_Money/Input").gameObject:GetComponent("UIInput");							
							
    self.kSaveBankMoney = this.transform:FindChild("Offset/Views/Save/Save/Text_BankMoney/Input/Label").gameObject:GetComponent("UILabel");							
    -- self.kGetToggle = this.transform:FindChild("Offset/Options/Option_out").gameObject:GetComponent("UIToggle");							
    self.kBankMoney = this.transform:FindChild("Offset/Views/Save/Get/Text_BankMoney/Input/Label").gameObject:GetComponent("UILabel");							
    self.kGetMoney =  this.transform:FindChild("Offset/Views/Save/Get/Input_Money/Input").gameObject:GetComponent("UIInput");							
    self.vBankPassword = this.transform:FindChild("Offset/Views/Save/Get/SafeValidate/Input_BankPassword").gameObject							
    self.kBankPassword =  this.transform:FindChild("Offset/Views/Save/Get/SafeValidate/Input_BankPassword/Input").gameObject:GetComponent("UIInput");							
    self.vPhoneCode = this.transform:FindChild("Offset/Views/Save/Get/SafeValidate/Input_PhoneCode").gameObject							
    self.kPhoneCode = this.transform:FindChild("Offset/Views/Save/Get/SafeValidate/Input_PhoneCode/Input").gameObject:GetComponent("UIInput");							
    self.kRecordToggle =  this.transform:FindChild("Offset/Views/Record/BankTab").gameObject:GetComponent("UIToggle");							
    self.vRecords = this.transform:FindChild("Offset/Views/Record/BankRecord/Table")							
    self.recordPrefab = ResManager:LoadAsset("happycity/Bank_Record","Bank_Record")							
    self.kRecordPage = this.transform:FindChild("Offset/Views/Record/BankRecord/Page/Label_Page").gameObject:GetComponent("UILabel");							
							
    self.kGiftID = this.transform:FindChild("Offset/Views/Gift/Input_ID/Input").gameObject:GetComponent("UIInput");							
    self.kGiftMoney =  this.transform:FindChild("Offset/Views/Gift/Input_Money/Input").gameObject:GetComponent("UIInput");							
    self.vConfirm = this.transform:FindChild("Offset/Views/ConfirmAlert - Panel").gameObject							
    self.kConfirmID = this.transform:FindChild("Offset/Views/ConfirmAlert - Panel/Confirm_ID").gameObject:GetComponent("UILabel");							
    self.kConfirmNickname = this.transform:FindChild("Offset/Views/ConfirmAlert - Panel/Confirm_Nickname").gameObject:GetComponent("UILabel");							
    self.kConfirmMoney = this.transform:FindChild("Offset/Views/ConfirmAlert - Panel/Confirm_Money").gameObject:GetComponent("UILabel");							
    self.kConfirmMoneyZh = this.transform:FindChild("Offset/Views/ConfirmAlert - Panel/Confirm_Money_Zh").gameObject:GetComponent("UILabel");							
    self.vSucess = this.transform:FindChild("Offset/Views/SucessAlert - Panel").gameObject							
    self.kSucessMoney = this.transform:FindChild("Offset/Views/SucessAlert - Panel/Confirm_Money").gameObject:GetComponent("UILabel");							
    self.kSucessID = this.transform:FindChild("Offset/Views/SucessAlert - Panel/Confirm_ID").gameObject:GetComponent("UILabel");							
    self.timeStampLb = this.transform:FindChild("Offset/Views/SucessAlert - Panel/timeStamp").gameObject:GetComponent("UILabel");							
    self.nickNameLb = this.transform:FindChild("Offset/Views/Gift/Input_ID/nickName").gameObject:GetComponent("UILabel");							
    self.nickName = ""							
    self.oldPsd =  this.transform:FindChild("Offset/Views/ChangePassword/Input_oldPassword/Input").gameObject:GetComponent("UIInput");							
    self.newPsd =  this.transform:FindChild("Offset/Views/ChangePassword/Input_newPassword/Input").gameObject:GetComponent("UIInput");							
    self.confirmPsd =  this.transform:FindChild("Offset/Views/ChangePassword/Input_confirmPassword/Input").gameObject:GetComponent("UIInput");							
    --banklogin							
    self.loginPanel =  this.transform:FindChild("loginPanel").gameObject							
    self.bindLoginGroup =  this.transform:FindChild("loginPanel/BindGroup").gameObject							
    -- self.bindLoginGroupOtherBtn = this.transform:FindChild("loginPanel/BindGroup/Button_other").gameObject --转到微信登陆按钮							
    self.unBindLoginGroup =  this.transform:FindChild("loginPanel/UnBindGroup").gameObject							
    self.wechatGroup =  this.transform:FindChild("loginPanel/WechatGroup").gameObject							
    -- self.wechatGroupOtherBtn = this.transform:FindChild("loginPanel/WechatGroup/Button_other").gameObject --转到手机登陆按钮							
    self.loginInput =  this.transform:FindChild("loginPanel/UnBindGroup/Input_confirmPassword/Input").gameObject:GetComponent("UIInput");							
    self.loginPhoneCodeInput =  this.transform:FindChild("loginPanel/BindGroup/Validation/Input").gameObject:GetComponent("UIInput");							
    self.loginPhoneWxInput =  this.transform:FindChild("loginPanel/WechatGroup/Validation/Input").gameObject:GetComponent("UIInput");							
							
    --							
    self.button_Submit = this.transform:FindChild("Offset/Views/Gift/Button_Submit").gameObject:GetComponent("UIButton");							
    self.saveMoneyBtn = this.transform:FindChild("Offset/Options/Option_save").gameObject;							
    self.outMoneyBtn = this.transform:FindChild("Offset/Options/Option_out").gameObject;							
    self.bankRecordBtn = this.transform:FindChild("Offset/Views/Record/BankTab").gameObject;							
    self.sendGiftToggleBtn = this.transform:FindChild("Offset/Options/Option_give").gameObject;							
    self.changePwdToggleBtn = this.transform:FindChild("Offset/Options/Option_changePwd").gameObject;							
							
    -- self.bankNavBgSplit0 = this.transform:FindChild("Offset/Options/bg2/Sprite_0").gameObject;							
    -- self.bankNavBgSplit1 = this.transform:FindChild("Offset/Options/bg2/Sprite_1").gameObject;							
    -- self.bankNavBgSplit2 = this.transform:FindChild("Offset/Options/bg2/Sprite_2").gameObject;							
    -- self.bankNavBgSplit3 = this.transform:FindChild("Offset/Options/bg2/Sprite_3").gameObject;							
    -- self.bankNavBgSplit4 = this.transform:FindChild("Offset/Options/bg2/Sprite_4").gameObject;							
    -- self.bankNavBgSplit5 = this.transform:FindChild("Offset/Options/bg2/Sprite_5").gameObject;							
							
    self.InvokeLua = InvokeLua:New(self);							
    self.InvokeLua:InvokeRepeating("Nickname_by_uid",self.Nickname_by_uid, 0,1);							
    self.Nickname_by_uidNum = 3;							
							
    ----游戏记录相关初始化---							
    self.gameRecordBtn = this.transform:FindChild("Offset/Views/Record/GameTab").gameObject							
    self.kGameRecordToggle =  this.transform:FindChild("Offset/Views/Record/GameTab").gameObject:GetComponent("UIToggle");	
					
    this:GameRecordAwake();							
							
    ----卡密充值---							
    self.gameCardPwdBtn = this.transform:FindChild("Offset/Options/Option_cardPwd").gameObject;							
    self.kGameCardPwdBtnToggle =  this.transform:FindChild("Offset/Options/Option_cardPwd").gameObject:GetComponent("UIToggle");							
    self.CardPwdInputGroup = this.transform:FindChild("Offset/Views/CardPwd/CardPwdInput").gameObject;							
    self.CardPwdInputNum = this.transform:FindChild("Offset/Views/CardPwd/CardPwdInput/Text_CardNum/Input").gameObject:GetComponent("UIInput");							
    self.CardPwdInputPwd = this.transform:FindChild("Offset/Views/CardPwd/CardPwdInput/Input_Pwd/Input").gameObject:GetComponent("UIInput");							
    self.CardPwdTipGroup = this.transform:FindChild("Offset/Views/CardPwd/CardPwdTip").gameObject;							
    self.cardPwdTipLabel  = this.transform:FindChild("Offset/Views/CardPwd/CardPwdTip/Label").gameObject:GetComponent("UILabel");							
    self.cardPwdTipText   = self.cardPwdTipLabel.text;							
    self.cardPwdValue	 = "0"							
	self.bankRecordTog = self.bankRecordBtn:GetComponent('UIToggle')

    --绑定解绑手机							
    self.loginPanel:SetActive(false)							
    this:checkBindBtnState()					
end							
							
function this:Awake()
    error('is  awake ')								
    this.mono = Hall.mono						
end							
							
function this.Start()						
    -- this:autoGetUI()					
    this.mono:AddClick(this.ui_backBtn,function() 						
        HallUtil:HidePanelAni(this.gameObject)						
    end)						
    this:InitBankSocket()						
    this:Module_BankInit()							
    --调用父类的Awake函数							
    this:AwakeBankSocket();						
					
    --存取款		
    EginProgressHUD.Instance:HideHUD();							
    this.tempBankMoney = tonumber( EginUser.Instance.bankMoney);							
    this.tempBagMoney  = tonumber( EginUser.Instance.bagMoney );							
			
    this:startSocket()					
    -- this.ui_goldBagGoldLabel.text = EginUser.Instance.bagMoney					
    -- this.ui_goldBankGoldLabel.text = EginUser.Instance.bankMoney					
    -- this.ui_goldChangeLabel.value = ""		
    -- this.ui_goldDoGetBtn:SetActive(false)				
    -- this.ui_goldDoSaveBTn:SetActive(true)		
    -- this.mono:AddClick(this.ui_goldTabGetBtn,function() 						
        -- this.ui_goldDoGetBtn:SetActive(true)				
        -- this.ui_goldDoSaveBTn:SetActive(false)	
    -- end) 	
    -- this.mono:AddClick(this.ui_goldTabSaveBtn,function() 						
        -- this.ui_goldDoGetBtn:SetActive(false)				
        -- this.ui_goldDoSaveBTn:SetActive(true)						
    -- end)	
     		
    --按钮事件监听							
    							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Save/Get/SafeValidate/Input_PhoneCode/Button_Send").gameObject, this.OnClickSendPhoneCode,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Save/Get/Button_Submit").gameObject, this.OnClickGet,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Record/BankRecord/Page/Button_Last").gameObject, this.OnClickLastRecord,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Record/BankRecord/Page/Button_Next").gameObject, this.OnClickNextRecord,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Save/Save/Button_Submit").gameObject, this.OnClickSave,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Gift/Button_Submit").gameObject, this.OnClickGift,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Gift/SafeValidate/Input_PhoneCode/Button_Send").gameObject, this.OnClickSendPhoneCode,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/SucessAlert - Panel/Button_Cancel").gameObject, this.OnClickGiftSucessHide,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/ConfirmAlert - Panel/Button_Gift").gameObject, this.OnClickGiftConfirm,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/ConfirmAlert - Panel/Button_Cancel").gameObject, this.OnClickGiftCancel,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/ChangePassword/Button_Submit").gameObject, this.OnChangePassword,this)							
    this.mono:AddClick(this.transform:FindChild("Offset/Background Top/Button_Back - Anchor/ImageButton").gameObject,function ( )
        HallUtil:PopupPanel('Hall',false,this.gameObject,nil)   
    end)							
    --banklogin							
    this.mono:AddClick(this.transform:FindChild("loginPanel/UnBindGroup/Button_Submit").gameObject, this.OnLogin,this)							
    this.mono:AddClick(this.transform:FindChild("loginPanel/BindGroup/Button_Submit").gameObject, this.OnLoginCode,this)							
    -- this.mono:AddClick(this.transform:FindChild("loginPanel/BindGroup/Button_other").gameObject, this.OnChooseLoginWx,this)							
    --print(this.transform:FindChild("loginPanel/BindGroup/Validation/btnMobilePhone").gameObject.name)							
    --print(this.getPhoneCodeLoginCode)							
    this.mono:AddClick(this.transform:FindChild("loginPanel/BindGroup/Validation/btnMobilePhone").gameObject,this.getPhoneCodeLoginCode,this)							
    this.mono:AddClick(this.transform:FindChild("loginPanel/WechatGroup/Button_Submit").gameObject, this.OnLoginWx,this)							
    -- this.mono:AddClick(this.transform:FindChild("loginPanel/WechatGroup/Button_other").gameObject, this.OnChooseLoginPhone,this)							
							
    this.mono:AddInput(this.transform:FindChild("Offset/Views/Gift/Input_ID/Input").gameObject:GetComponent("UIInput"), this.OnInputIDChange)							
	this.mono:AddInput(this.kGiftMoney,function ( )
        this.transform:FindChild('Offset/Views/Gift/Input_Money/Lab_Captil').gameObject:GetComponent('UILabel').text=EginTools.numToCnNum(this.kGiftMoney.value)
         if( string.len(this.kGiftMoney.value) > 4) then
           this.kGiftMoney.gameObject.transform:FindChild('Label').gameObject:GetComponent('UILabel').text =  EginTools.NumberAddComma(this.kGiftMoney.value)
         end
    end)
    --卡密充值按钮							
    this.mono:AddClick(this.transform:FindChild("Offset/Options/Option_cardPwd").gameObject, this.OnClickCardPwd,this)
    this.mono:AddClick(this.transform:FindChild("Offset/Options/Option_give").gameObject,function ()
        this.transform:FindChild("Offset/Views/Gift/Input_ID/Input").gameObject:GetComponent("UIInput").value =''
        this.transform:FindChild("Offset/Views/Gift/Input_Money/Input").gameObject:GetComponent("UIInput").value =''
    end)	
    this.mono:AddClick(this.transform:FindChild("Offset/Options/Option_give").gameObject,function ()
        self.kSaveMoney.value =''
        self.kGetMoney.value =''
    end)				
    this.mono:AddClick(this.transform:FindChild('Offset/Options/Option_changePwd').gameObject,function ( )
        this.oldPsd.value = ''                     
        this.newPsd.value =   ''               
        this.confirmPsd.value=''
    end)

    this.mono:AddClick(this.transform:FindChild("Offset/Views/CardPwd/CardPwdInput/Button_Submit").gameObject, this.OnClickCardPwdRechargeCheck,this)							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/CardPwd/CardPwdTip/Button_yes").gameObject, this.OnClickCardPwdRechargeYes,this)							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/CardPwd/CardPwdTip/Button_no").gameObject, this.OnClickCardPwdRechargeNo,this)							
							
    -- this.mono:AddClick(this.kGetToggle.gameObject, this.OnShowGetView)	
    this.mono:AddClick(this.transform:FindChild("Offset/Options/Option_bankRecord").gameObject, this.OnShowRecordView)
    this.mono:AddClick(this.kRecordToggle.gameObject, this.OnShowRecordView)					
    this.mono:AddClick(this.gameRecordBtn.gameObject, this.OnShowGameRecordView)
    this.mono:AddClick(this.transform:FindChild('loginPanel/Btn_Back').gameObject,function ( )
        HallUtil:PopupPanel('Hall',false,this.gameObject,nil)  
    end)
    this.mono:AddClick(this.loginInput.gameObject,function (  )
        this.loginInput.inputType = UIInput.InputType.Password;
    end)


    -- this.mono:AddInput(this.transform:FindChild('Offset/Views/Input_Money/Input').gameObject:GetComponent('UIInput'),function ( )
        
    -- end)
    -- this.kRecordToggle.gameObject:SendMessage("OnClick")   
    -- if( PlatformGameDefine.playform.PlatformName == "game407" or PlatformGameDefine.playform.PlatformName == "game131")then							
    --     this.gameRecordBtn:SetActive(false);							
    -- else							
    --     this.gameRecordBtn:SetActive(true);							
    -- end														
    -----游戏逻辑							
 					
    --[[							
    if Utils.PlayformName=="PlatformGame7997" then 							
        self.gameRecordBtn:SetActive(false);							
    else							
        self.gameRecordBtn:SetActive(true);							
    end							
    ]]							
							
							
    this:UpdateUserinfo();							
end							
function this:AwakeBankSocket()	
	if (PlatformGameDefine.playform.IsSocketLobby) then	
		SettingInfo.Instance.autoNext = false;	
		SettingInfo.Instance.deposit = false; 	
	else	
		self.loginPanel:SetActive(false);	
		EginProgressHUD.Instance:HideHUD();	
		self.sendGiftToggleBtn:SetActive(false);	
		self.changePwdToggleBtn:SetActive(false);	
		self.gameCardPwdBtn:SetActive(false);	
		-- self.bankNavBgSplit3:SetActive(false);	
		-- self.bankNavBgSplit4:SetActive(false);	
		-- self.bankNavBgSplit5:SetActive(false);	
	end 	
		
	if( not PlatformGameDefine.playform.IOSPayFlag) then	
		self.sendGiftToggleBtn:GetComponent("BoxCollider").enabled = false;	
		self.sendGiftToggleBtn.transform:FindChild("UILabel"):GetComponent("UILabel").alpha = 0;	
		self.gameCardPwdBtn:GetComponent("BoxCollider").enabled = false;	
		self.gameCardPwdBtn.transform:FindChild("UILabel"):GetComponent("UILabel").alpha = 0;	
		self.outMoneyBtn.transform.localPosition = Vector3.New(-411, 0,0);	
		self.changePwdToggleBtn.transform.localPosition = Vector3.New(370, 0,0);	
		self.bankRecordBtn.transform.localPosition = Vector3.New(-12, 0,0);	
		self.gameRecordBtn.transform.localPosition = Vector3.New(730, 0,0);	
	
		-- self.bankNavBgSplit0.transform.localPosition = Vector3.New(-591, 0,0);	
		-- self.bankNavBgSplit1.transform.localPosition = Vector3.New(-209, 0,0);	
		-- self.bankNavBgSplit2.transform.localPosition = Vector3.New(184, 0,0);	
		-- self.bankNavBgSplit3.transform.localPosition = Vector3.New(571, 0,0);	
		-- self.bankNavBgSplit4:SetActive(false)	
		-- self.bankNavBgSplit5:SetActive(false)	
		self.gameRecordBtn.transform:FindChild("UISprite - Checked"):GetComponent("UISprite").spriteName = "SelectBtn";	
	elseif false then	
	--开启131赠送功能	
	--elseif(PlatformGameDefine.playform.PlatformName == "game407" or PlatformGameDefine.playform.PlatformName == "game131") then	
		self.sendGiftToggleBtn:GetComponent("BoxCollider").enabled = false;	
		self.sendGiftToggleBtn.transform:FindChild("UILabel"):GetComponent("UILabel").alpha = 0;	
		self.gameCardPwdBtn.transform.localPosition = Vector3.New(70, 0,0);	
	
		self.outMoneyBtn.transform.localPosition = Vector3.New(-460, 0,0);	
		self.changePwdToggleBtn.transform.localPosition = Vector3.New(370, 0,0);	
		self.bankRecordBtn.transform.localPosition = Vector3.New(-200, 0,0);	
		self.gameRecordBtn.transform.localPosition = Vector3.New(730, 0,0);	
	
		-- self.bankNavBgSplit0.transform.localPosition = Vector3.New(-591, 0,0);	
		-- self.bankNavBgSplit1.transform.localPosition = Vector3.New(-336, 0,0);	
		-- self.bankNavBgSplit2.transform.localPosition = Vector3.New(184, 0,0);	
		-- self.bankNavBgSplit3.transform.localPosition = Vector3.New(571, 0,0);	
		-- self.bankNavBgSplit4.transform.localPosition = Vector3.New(-66, 0,0);	
		-- self.bankNavBgSplit5:SetActive(false)	
		self.gameRecordBtn.transform:FindChild("UISprite - Checked"):GetComponent("UISprite").spriteName = "SelectBtn";	
	end	
    --self.bindLoginGroup:SetActive(false)	
    --self.unBindLoginGroup:SetActive(false)	
    --self.wechatGroup:SetActive(false)	
     -- self.loginPanel:SetActive(false);    

     if EginUser.bindPhone == 1 or EginUser.wechat_lock == 1  then
        
        self.loginPanel.transform:FindChild('pwdTab'):GetComponent('UIToggle').startsActive = false 
        self.loginPanel.transform:FindChild('pwdTab'):GetComponent('BoxCollider').enabled = false 
        if EginUser.wechat_lock == 1 then 
            self.loginPanel.transform:FindChild('wxTab'):GetComponent('UIToggle').startsActive = true 
            if EginUser.bindPhone == 0 then
                 self.loginPanel.transform:FindChild('phoneTab'):GetComponent('BoxCollider').enabled = false 
            end
        else
            self.loginPanel.transform:FindChild('phoneTab'):GetComponent('UIToggle').startsActive = true
            self.loginPanel.transform:FindChild('wxTab'):GetComponent('BoxCollider').enabled = false 
        end
    else
        self.loginPanel.transform:FindChild('pwdTab'):GetComponent('UIToggle').startsActive = true
        self.loginPanel.transform:FindChild('pwdTab'):GetComponent('BoxCollider').enabled = true
        self.loginPanel.transform:FindChild('phoneTab'):GetComponent('BoxCollider').enabled = false 
        self.loginPanel.transform:FindChild('wxTab'):GetComponent('BoxCollider').enabled = false 
    end


    if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT) then	
--				如果是绑定微信的账号:	
        -- self.wechatGroup:SetActive(true)
        self.loginPanel:SetActive(true) 
        local termTicks = tonumber( this.bankSessionTerm );	
        if(System.DateTime.Now.Ticks< termTicks) then	
            --self.loginPanel:SetActive(false);	
            self.loginPanel.transform:FindChild('wxTab'):GetComponent('UIToggle').startsActive = true 

            self.isLogin = true;	
        end	
    elseif(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_AUTH) then	
        --self.loginPanel.transform:FindChild("Label"):GetComponent("UILabel").text = "手机令牌:";
        self.loginPanel.transform:FindChild('phoneTab'):GetComponent('UIToggle').startsActive = true 
         self.loginPanel:SetActive(true) 	
    elseif(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE) then
        self.loginPanel:SetActive(true) 	
        self.loginPanel.transform:FindChild('phoneTab'):GetComponent('UIToggle').startsActive = true 
        --self.bindLoginGroup:SetActive(true)	
    elseif(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PASSWORD) then	
        --self.unBindLoginGroup:SetActive(true)	
        self.loginPanel.transform:FindChild('pwdTab'):GetComponent('UIToggle').startsActive = true 
         self.loginPanel:SetActive(true) 
    end	
end				
function this:StartBankSocket ()	
	EginProgressHUD.Instance:HideHUD();	
	self.tempBankMoney = tonumber(EginUser.Instance.bankMoney);	
	self.tempBagMoney  = tonumber( EginUser.Instance.bagMoney );	
	self:UpdateUserinfo();	
	
    --self.mono:StartGameSocket();	
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);	
	
	if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PASSWORD) then	
		if( string.len(self.bankPwd) > 0) then	
			self.loginPanel:SetActive(false);	
			 this.InvokeLua:Invoke("this:loginBank",this.loginBank,1);	
		end	
	end	
end		
function this:UpdateUserinfo () 	
	local user = EginUser.Instance;	
	self.kBagMoney.text = EginTools.NumberAddComma(user.bagMoney);	
	self.kSaveBankMoney.text = EginTools.NumberAddComma(user.bankMoney);	
	self.kBankMoney.text = EginTools.NumberAddComma(user.bankMoney);	
	
	self.kSaveMoney.value = "";	
	self.kGetMoney.value = "";	
end	
function this:startSocket()							
 						
 						
    local tLastPwd = UnityEngine.PlayerPrefs.GetString(EginUser.uid..EginUser.Instance.bankLoginType.."bankpwd")							
    --测试用							
    --tLastPwd = nil							
    if tLastPwd ~= nil then							
        this.hallBankPwd = tLastPwd							
        --print("ttttttttttttttttttttttttttttt tLastPwd::"..EginUser.uid..EginUser.Instance.bankLoginType.."bankpwd:"..tLastPwd)							
    end							
    --print("ttttttttttttttttttttttttttttt: this.hallBankPwd:"..this.hallBankPwd)							
    if(string.len(this.hallBankPwd )  == 0) then							
        this.loginPanel:SetActive(true);							
       -- this:checkBindBtnState()							
    else							
        if EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PASSWORD or EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE or EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT then							
            if(string.len(this.hallBankPwd )  > 0) then							
               this.loginPanel:SetActive(false);							
                this:loginBank(this.hallBankPwd );							
            end							
        else							
            this:checkBindBtnState()							
        end							
    end							
end							
							
function this.OnDisable()							
							
end							
function this:OnDestroy()							
    this:clearLuaValue()							
    this:GameRecordClearLuaValue();							
    if this.InvokeLua ~= nil then							
        this.InvokeLua:clearLuaValue();							
        this.InvokeLua = nil;							
    end							
end							
							
							
function this.SocketDisconnect ( disconnectInfo)							
    -- SocketManager.LobbyInstance.socketListener = nil;							
end							
							
function this.SocketReceiveMessage( message)							
    local messageObj = cjson.decode(message);							
    local type = tostring(messageObj["type"]);							
    local tag = tostring(messageObj["tag"]);							
    -- error(message);							
    if(type == "AccountService") then							
        if(tag == "bank_login") then							
            EginProgressHUD.Instance:HideHUD();							
            if(tostring(messageObj["result"]) == "ok") then							
                -- error("---------------------------------login_______________ok")							
                this.isLogin = true;							
                this.loginPanel:SetActive(false);							
                if(string.len(this.loginInput.value) > 0) then							
                    this.hallBankPwd  = this.loginInput.value							
                end							
                if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE) then							
                    if(string.len(this.loginPhoneCodeInput.value) > 0) then							
                        this.hallBankPwd  = this.loginPhoneCodeInput.value							
                    end							
                end							
                if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT) then							
                    --UnityEngine.PlayerPrefs.SetString("bankSessionTerm", System.DateTime.Now:AddMinutes(24.5).Ticks.."");							
                    --UnityEngine.PlayerPrefs.Save();							
                    if(string.len(this.loginPhoneWxInput.value) > 0) then							
                        this.hallBankPwd  = this.loginPhoneWxInput.value							
                    end							
                    BankSocket.bankSessionTerm = System.DateTime.Now:AddMinutes(24.5).Ticks.."";							
                end							
                UnityEngine.PlayerPrefs.SetString(EginUser.uid..EginUser.Instance.bankLoginType.."bankpwd",this.hallBankPwd)							
                UnityEngine.PlayerPrefs.Save()							
            else							
                if(UnityEngine.PlayerPrefs.HasKey(EginUser.uid..EginUser.Instance.bankLoginType.."bankpwd")) then							
                    UnityEngine.PlayerPrefs.DeleteKey(EginUser.uid..EginUser.Instance.bankLoginType.."bankpwd");							
                end							
                this.loginPanel:SetActive(true);							
                this:checkBindBtnState();							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));							
                this:ShowLoginPanel( tostring(messageObj["body"]) );							
            end							
        elseif(tag == "bag2bank") then		
            if(tostring(messageObj["result"]) == "ok") then		

                this:saveLoadMoneySuccess( -tonumber(this.kSaveMoney.value));							
            else							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));							
                this:ShowLoginPanel( tostring(messageObj["body"]) );							
            end							
        elseif(tag == "bank2bag") then -----------							
            if(tostring(messageObj["result"]) == "ok") then							
                this:saveLoadMoneySuccess( tonumber(this.kGetMoney.value));							
            else							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));							
                this:ShowLoginPanel( tostring(messageObj["body"]) );							
            end							
        elseif(tag == "deliver_money") then -----------							
            if(tostring(messageObj["result"]) == "ok") then							
                local nowDate = System.DateTime.Now:ToString("yyyy-MM-dd hh:mm");							
                this:saveLoadMoneySuccess(tonumber(this.kGiftMoney.value));							
                this:GiftSucess(nowDate);							
            else							
                EginProgressHUD.Instance:ShowPromptHUD( System.Text.RegularExpressions.Regex.Unescape(tostring(messageObj["body"])) );							
                this:ShowLoginPanel( System.Text.RegularExpressions.Regex.Unescape(tostring(messageObj["body"])) );							
            end							
        elseif(tag == "nickname_by_uid") then							
            EginProgressHUD.Instance:HideHUD();							
							
            if( tostring(messageObj["result"]) == "ok") then							
                this.nickName =  System.Text.RegularExpressions.Regex.Unescape(tostring(messageObj["body"]));							
                --this.button_Submit.isEnabled = true;							
            else							
                this.nickName = "";							
            end							
            if this.button_Submitan then							
                this.button_Submitan = false;							
                if this.nickName == "" then							
                    EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));							
                else							
                    this:OnClickGift()							
                end							
            end							
            this.nickNameLb.text = this:formatPhoneNickName(this.nickName)							
        elseif(tag == "change_bank_password") then-------							
            EginProgressHUD.Instance:HideHUD();							
            if(tostring(messageObj["result"]) == "ok") then							
                this.oldPsd.value = "";							
                this.newPsd.value = "";							
                this.confirmPsd.value = "";							
                this:clearCachePwd();							
                EginProgressHUD.Instance:ShowPromptHUD("修改密码成功!");							
            else							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));							
                this:ShowLoginPanel( tostring(messageObj["body"]) );							
            end							
        elseif(tag == "check_cardpay") then							
            --print("tag check_cardpay")							
            EginProgressHUD.Instance:HideHUD();							
            if(tostring(messageObj["result"]) == "ok") then							
                this.cardPwdValue = tostring(messageObj["body"])--卡内余额							
                this:showCardPwdInputTip()							
            else							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["result"]));							
                --this:showCardPwdInputTip()							
                this:showCardPwdInutGroup()							
            end							
        elseif(tag == "cardpay") then							
            --print("tag cardpay")							
            EginProgressHUD.Instance:HideHUD();							
            if(tostring(messageObj["result"]) == "ok") then							
                --messageObj["body"]							
                this.tempBankMoney = this.tempBankMoney + this.cardPwdValue							
                EginProgressHUD.Instance:ShowPromptHUD("充值成功!");							
                --this:UpdateUserinfo();							
                --刷新存款							
                this.kSaveBankMoney.text = EginTools.NumberAddComma(this.tempBankMoney);							
                this.kBankMoney.text  = EginTools.NumberAddComma(this.tempBankMoney);							
                this:ResetCardPwd();							
            else							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["result"]));							
                --this:showCardPwdInutGroup()							
            end							
        elseif(tag == "bank_record_json") then ----------							
            EginProgressHUD.Instance:HideHUD();							
            if(tostring(messageObj["result"]) == "ok") then							
                this:UpdateBankRecord(messageObj["body"]);							
            else							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["body"]));							
                this:ShowLoginPanel( tostring(messageObj["body"]) );							
            end							
        elseif(tag == "get_account" and EginUserUpdate.Instance.updateLoopHasStart) then							
            local dict = messageObj["body"];							
            if( tostring(EginUser.Instance.uid) == tostring(dict["userid"]) )then							
                if(dict["bank_validate"]) then							
                    if(dict["bank_validate"] == "2" or dict["bank_validate"] == 2) then							
                        EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PHONE_AUTH;							
                    elseif(dict["bank_validate"] == "1" or dict["bank_validate"] == 1)  then							
                        EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PHONE_CODE;							
                    else							
                        if(dict["wechat_lock"]) then							
                            if(dict["wechat_lock"] == "1" or dict["wechat_lock"] == 1) then							
                                EginUser.Instance.bankLoginType = EginUser.eBankLoginType.WECHAT;							
                            else							
                                EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PASSWORD;							
                            end							
                        else							
                            EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PASSWORD;							
                        end							
                    end							
                end							
            end							
            --add by lxtd003 2016.11.07 解绑手机验证后需要判断用哪种方式登录							
            if(EginUser.Instance.bankLoginType ~= EginUser.eBankLoginType.PASSWORD) then							
                --this.loginPanel.transform:FindChild("defaultPwd").gameObject:SetActive(false);							
                -- this.loginInput.inputType = UIInput.InputType.Standard;							
                if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT) then							
                    --this.loginPanel.transform:FindChild("Label"):GetComponent("UILabel").text = "微信认证码:";							
                elseif(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_AUTH) then							
                    --this.loginPanel.transform:FindChild("Label"):GetComponent("UILabel").text = "手机令牌:";							
                elseif(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE) then							
                    --self.loginPanel.transform:FindChild("Label"):GetComponent("UILabel").text = "手机验证码:";							
                end							
            else							
                EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PASSWORD;							
                --this.loginPanel.transform:FindChild("Label"):GetComponent("UILabel").text = "银行密码:";							
                --this.loginPanel.transform:FindChild("defaultPwd").gameObject:SetActive(true);							
                -- this.loginInput.inputType = UIInput.InputType.Password;							
            end							
        elseif(tag == "bank_bind_phone") then							
            --<--{"type":"AccountService","tag":"bank_bind_phone","result":'ok' --成功ok ,失败为说明"body": ''		}							
            if(tostring(messageObj["result"]) == "ok") then							
                if EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE or this.phoneUnbindBtn.activeSelf == true then							
                    EginProgressHUD.Instance:ShowPromptHUD("解绑成功");							
                    ProtocolHelper.Send_get_account();--获取用户信息							
                    this.phoneBindBtn:SetActive(true);							
                    this.phoneUnbindBtn:SetActive(false);							
                else							
                    EginProgressHUD.Instance:ShowPromptHUD("绑定成功");							
                    this.doBindPhonePanel:SetActive(false)							
                    --this.loginPanel.transform:FindChild("Label"):GetComponent("UILabel").text = "手机验证码:";							
                    this.phoneBindBtn:SetActive(false);							
                    this.phoneUnbindBtn:SetActive(true);							
                    local jsonStr = cjson.encode({type="AccountService",tag="bank_refresh",body =0});							
                    BaseSceneLua.socketManager:SendPackage(jsonStr);							
                end							
            else							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["result"]));							
            end							
        elseif(tag == "bank_refresh") then							
            if(tostring(messageObj["result"]) ~= "ok") then							
                EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["result"]));							
            else							
                EginProgressHUD.Instance:ShowPromptHUD("验证码已发送!");							
            end							
        end							
    end							
end							
							
function this:sendSaveToBank ()							
    local jsonStr = cjson.encode({type="AccountService",tag="bag2bank",body = {amount=this.kSaveMoney.value}});							
    BaseSceneLua.socketManager:SendPackage(jsonStr);							
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);							
end							
							
function this:sendGetFromBank ()							
    local jsonStr = cjson.encode({type="AccountService",tag="bank2bag",body = {amount=this.kGetMoney.value}});							
    BaseSceneLua.socketManager:SendPackage(jsonStr);							
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);							
end							
							
function this:OnClickGiftConfirm ()							
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);							
    --<-游戏内转账							
    local jsonStr = cjson.encode({type="AccountService",tag="deliver_money",body = {uid=this.kGiftID.value,money=this.kGiftMoney.value}});							
    BaseSceneLua.socketManager:SendPackage(jsonStr);							
end							
							
function this:OnInputIDChange()							
    this.nickName = "";							
    this.nickNameLb.text =this:formatPhoneNickName(this.nickName)							
    --this.button_Submit.isEnabled = false							
    if( string.len(this.kGiftID.value) > 4) then							
        --<-根据用户id获得昵称，向服务器发送							
        this.Nickname_by_uidNum = 0							
    end							
end							
							
function this:formatPhoneNickName(pString)							
    if string.find(pString,"_mob") ~= nil then							
        tStart,tEnd=string.find(pString,"_mob")							
        if tStart<12 then							
            return pString							
        end							
        local tPhoneStr = string.sub(pString,0,tStart)							
        local tStr0 = string.sub(tPhoneStr,0,3)							
        local tStr1 = "***"							
        local tStr2 = string.sub(tPhoneStr,string.len(tPhoneStr)-3)							
        tStr2 = tStr2..tPhoneStr.sub(pString,tStart+1)							
        return tStr0..tStr1..tStr2							
    end							
    return pString							
end							
function this:showFrontEndThree(pString)							
    if string.len(pString) <= 3 then							
        return pString							
    end							
    local tStr0 = string.sub(pString,0,3)							
    local tStr1 = "***"							
    local tStr2 = string.sub(pString,string.len(pString)-2)							
    return tStr0..tStr1..tStr2							
end							
							
function this:Nickname_by_uid()							
    this.Nickname_by_uidNum = this.Nickname_by_uidNum +1;							
    if this.Nickname_by_uidNum  == 2 then							
        log("根据用户id获得昵称，向服务器发送 ");							
        local jsonStr = cjson.encode({type="AccountService",tag="nickname_by_uid",body = {uid=this.kGiftID.value}});							
        BaseSceneLua.socketManager:SendPackage(jsonStr);							
    end							
							
end							
function this.OnInputGetMoneyChange()							
    this:InputGetMoneyChange()							
end							
function this.OnInputSaveMoneyChange()							
    this:InputSaveMoneyChange()							
end							
function this.OnInputGiftMoneyChange()							
    this:InputGiftMoneyChange()							
end							
function this:sendChangePwd ()							
    local messageBody = {old_pwd= this.oldPsd.value,password=this.newPsd.value,validate_type= 0,answer= "",emailcode= "",phonecode= ""}							
							
    local jsonStr = cjson.encode({type="AccountService",tag="change_bank_password",body = messageBody});							
    BaseSceneLua.socketManager:SendPackage(jsonStr);							
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);							
end							
							
function this:OnLoadRecord ( page)							
    if (page > 0  and  page <= this.maxRecordPage)   then							
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);							
							
        local nowDate = System.DateTime.Now:ToString("yyyy-MM-dd");							
        local pastDate = System.DateTime.Now:AddMonths(-1):ToString("yyyy-MM-dd");							
							
        local messageBody ={pageindex=page,pagesize=this.recordPageSize,start_date=pastDate,end_date=nowDate};							
							
        local jsonStr = cjson.encode({type="AccountService",tag="bank_record_json",body = messageBody});							
        BaseSceneLua.socketManager:SendPackage(jsonStr);							
    end							
end							
							
function this:loginBank( pwd)							
    if(pwd == nil) then pwd=""; end							
    --'type':'money', 'tag':'loginbank', 'body':'password':密码或者验证码,'pwdcard_r1':密保卡1,'pwdcard_r2':密保卡2endend							
    local messageBody = {};							
    if(string.len(pwd) >0) then							
        messageBody.password = pwd;							
    else							
        messageBody.password = this.loginInput.value							
    end							
    messageBody.login_type = this.loginType							
    messageBody.pwdcard_r1 = ""							
    messageBody.pwdcard_r2 = ""							
    messageBody.device_id = UnityEngine.SystemInfo.deviceUniqueIdentifier;							
							
    this.mono:Request_lua_fun("AccountService/bank_login",cjson.encode(messageBody),							
      function(message)							
            error("----------------message")
            this.loginPanel:SetActive(false)
      end,							
      function(message)							
            error("网络中断,重连中")							
          EginProgressHUD.Instance:ShowPromptHUD("网络中断,重连中");							
      end)							
							
    --local jsonStr = cjson.encode({type="AccountService",tag="bank_login",body =messageBody});							
    --BaseSceneLua.socketManager:SendPackage(jsonStr);							
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);							
end							
							
 						
							
function this:ShowLoginPanel(errorStr)							
	error("=============银行登录错误信息====="..errorStr)							
    if(errorStr == "请先登录银行" or errorStr == "bank is not logon" or errorStr == "请输入交易密码")then							
        this.loginPanel:SetActive(true);							
        this:checkBindBtnState();							
        if(UnityEngine.PlayerPrefs.HasKey("bankSessionTerm")) then							
            UnityEngine.PlayerPrefs.DeleteKey("bankSessionTerm");							
        end							
    end							
end							
							
function this.Process_account_login(str)							
    EginProgressHUD.Instance:HideHUD();							
    if(hallBankPwd == nil) then hallBankPwd = ""; end							
    if(string.len(hallBankPwd) > 0) then							
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);							
        this:loginBank(hallBankPwd );							
    end							
end							
							
							
							
							
							
----------------------游戏记录相关------------------							
							
function this:OnShowGameRecordView()							
    if (UIToggle.GetActiveToggle(this.kGameRecordToggle.group) == this.kGameRecordToggle) then							
        this.recordPageG = 1;							
        this:GameRecordStart ()							
    end							
end							
function this:GameRecordAwake()							
    this.vRecordsGameRecord=this.transform:FindChild("Offset/Views/Record/GameRecord/Table");							
    this.recordPrefabGameRecord=ResManager:LoadAsset("happycity/GameRecord_Record","GameRecord_Record");							
    this.kRecordPageGameRecord=this.transform:FindChild("Offset/Views/Record/GameRecord/Page/Label_Page").gameObject:GetComponent("UILabel");							
    this.recordPageG = 1;							
    this.maxRecordPageG = 1;							
    this.recordPageSizeG = 9;							
							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Record/GameRecord/Page/Button_Last").gameObject, this.OnClickLastRecordG,this)							
							
    this.mono:AddClick(this.transform:FindChild("Offset/Views/Record/GameRecord/Page/Button_Next").gameObject, this.OnClickNextRecordG,this)							
end							
							
function this:GameRecordStart ()							
    if (PlatformGameDefine.playform.IsSocketLobby) then							
        this:sendGameRecordSocket(this.recordPageG);							
    else							
        coroutine.start(this.OnLoadRecord,this,this.recordPageG);							
    end							
end							
function this:GameRecordClearLuaValue()							
							
    this.vRecordsGameRecord=nil;							
    this.recordPrefab=nil;							
    this.recordPrefabGameRecord=nil;							
    this.kRecordPageGameRecord=nil;							
    this.recordPageG = 1;							
    this.maxRecordPageG = 1;							
    this.recordPageSizeG = 9;							
end							
							
							
function this:OnLoadRecordGame ( page)							
    if (page > 0 and page <= this.maxRecordPageG)  then							
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);							
							
        local form = UnityEngine.WWWForm.New();							
        form:AddField("pageindex", page);							
        form:AddField("pagesize", this.recordPageSizeG);							
        local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.GAME_RECORD_URL, form);							
        coroutine.www(www);							
							
        local result = HttpConnect.Instance:BaseResult(www);							
        EginProgressHUD.Instance:HideHUD();							
        if(HttpResult.ResultType.Sucess == result.resultType)  then							
            this:UpdateRecord(cjson.decode(result.resultObject:ToString()));							
        else							
            EginProgressHUD.Instance.ShowPromptHUD(result.resultObject);							
        end							
    end							
end							
function this:sendGameRecordSocket( page)							
							
    --		38:查询游戏记录："type":AccountService,"tag": game_record,"body":'start_date': 开始日期,'end_date':结束日期,'pageindex': 起始页数,'pagesize': 每页数量,'game_type':游戏类型,endend							
    local nowDate = System.DateTime.Now:ToString("yyyy-MM-dd");							
    local pastDate = System.DateTime.Now:AddMonths(-1):ToString("yyyy-MM-dd");--20151117							
							
    --支付配置数据							
    this.mono:Request_lua_fun("AccountService/game_record",cjson.encode({start_date=pastDate,end_date= nowDate,pageindex= page,pagesize=this.recordPageSizeG,game_type= 0}),							
        function(message)							
            EginProgressHUD.Instance:HideHUD();							
            local messageObj = cjson.decode(message);							
            this:UpdateRecord(messageObj);							
        end,							
        function(message)							
            EginProgressHUD.Instance:ShowPromptHUD(message);							
        end)							
end							
							
							
							
function this:OnClickLastRecordG ()							
    local page = this.recordPageG - 1;							
    if (PlatformGameDefine.playform.IsSocketLobby) then							
        this:sendGameRecordSocket(page);							
    else							
        coroutine.start(this.OnLoadRecordGame,this,page);							
    end							
							
end							
function this:OnClickNextRecordG ()							
    local page = this.recordPageG + 1;							
    if this.maxRecordPageG >= page then							
        if (PlatformGameDefine.playform.IsSocketLobby) then							
            this:sendGameRecordSocket(page);							
        else							
            coroutine.start(this.OnLoadRecordGame,this,page);							
        end							
    end							
							
end							
							
function this:UpdateRecord ( obj)							
							
    this.recordPageG = tonumber(obj["page"]["pageindex"]);							
    this.maxRecordPageG = tonumber(obj["page"]["pagecount"]);							
    this.kRecordPageGameRecord.text = this.recordPageG.."/"..this.maxRecordPageG;							
							
    EginTools.ClearChildren(this.vRecordsGameRecord);							
    local recordInfoList = obj["data"];							
							
    for i = 0 ,#(recordInfoList)-1   do							
        local recordInfo = recordInfoList[i+1]							
        if (type(recordInfo)  ~= "table") then break; end							
							
        local cell = GameObject.Instantiate(this.recordPrefabGameRecord);							
        cell.transform.parent = this.vRecordsGameRecord;							
        cell.transform.localPosition =  Vector3.New(0, i*-115, 0);							
        cell.transform.localScale = Vector3.one;							
		 local tColor = Color.New(129/255,100/255,55/255,1)
        cell.transform:Find("Label_0"):GetComponent("UILabel").color=tColor
        cell.transform:Find("Label_1"):GetComponent("UILabel").color=tColor                          
        cell.transform:Find("Label_2"):GetComponent("UILabel").color=tColor                        
        cell.transform:Find("Label_3"):GetComponent("UILabel").color=tColor
        cell.transform:Find("Label_4"):GetComponent('UILabel').color = tColor
        local actionTime = tostring(recordInfo["end_time"]);							
        if ( string.len(actionTime) > 10) then  actionTime = string.sub(actionTime,1,10);   end							
        if (PlatformGameDefine.playform.IsSocketLobby) then							
            cell.transform:Find("Label_0"):GetComponent("UILabel").text = System.Text.RegularExpressions.Regex.Unescape( recordInfo["game_type"]..recordInfo["room_type"]);							
            cell.transform:Find("Label_1"):GetComponent("UILabel").text = tostring(recordInfo["win_money"]) ;							
            cell.transform:Find("Label_2"):GetComponent("UILabel").text = tostring(recordInfo["start_money"]) ;							
            cell.transform:Find("Label_3"):GetComponent("UILabel").text = tostring(recordInfo["end_money"]) ;							
        else							
            cell.transform:Find("Label_0"):GetComponent("UILabel").text = recordInfo["game_type"]..recordInfo["room_type"];							
            cell.transform:Find("Label_1"):GetComponent("UILabel").text = tostring(recordInfo["win_money"]) ;							
            cell.transform:Find("Label_2"):GetComponent("UILabel").text = tostring(recordInfo["start_money"]) ;							
            cell.transform:Find("Label_3"):GetComponent("UILabel").text = tostring(recordInfo["end_money"]) ;							
        end							
        cell.transform:Find("Label_4"):GetComponent("UILabel").text = actionTime;							
							
    end							
end							
							
							
---------------------------------------卡密充值相关----------------------------							
function this:OnClickCardPwd( pObj )							
    --print( tostring(EginUser.Instance.uid))							
    this:ResetCardPwd()							
							
end							
function this:ResetCardPwd()							
    this.CardPwdInputNum.value = "";							
    this.CardPwdInputPwd.value = "";							
    this.cardPwdValue ="0";							
    this:showCardPwdInutGroup()							
end							
----卡密信息查询							
function this:OnClickCardPwdRechargeCheck( pObj )							
    --print("OnClickCardPwdRechargeCheck")							
    --check							
    local tErrorTip = ''							
    if string.len(this.CardPwdInputNum.value) < 1 or string.len(this.CardPwdInputPwd.value) < 1 then							
        tErrorTip = "请输入卡号和密码"							
    end							
    if string.len(this.CardPwdInputNum.value) ~=10 or string.len(this.CardPwdInputPwd.value) ~=12 then							
        tErrorTip = "请检查卡号或密码，卡号10位，密码12位"							
    end							
    if tErrorTip ~= '' then							
        EginProgressHUD.Instance:ShowPromptHUD(tErrorTip);							
        return							
    end							
    --sendmsg							
    local tBody 		 = {}							
    tBody['uid'] 		 = tostring(EginUser.Instance.uid)							
    tBody['card_num'] 	 = this.CardPwdInputNum.value							
    tBody['serial_num'] = this.CardPwdInputPwd.value							
    this.mono:Request_lua_fun("AccountService/check_cardpay",cjson.encode(tBody),function(message)							
        --print("check_cardpay back message")							
    end,							
        function(message)							
            --print("check_cardpay back message err")							
            EginProgressHUD.Instance:ShowPromptHUD(message);							
        end);							
end							
----确认卡密充值							
function this:OnClickCardPwdRechargeYes( pObj )							
    --print("OnClickCardPwdRechargeYes")							
    --sendmsg							
    local tBody 		 = {}							
    tBody['uid'] 		 = tostring(EginUser.Instance.uid)							
    tBody['card_num'] 	 = this.CardPwdInputNum.value							
    tBody['serial_num']  = this.CardPwdInputPwd.value							
    this.mono:Request_lua_fun("AccountService/cardpay",cjson.encode(tBody),function(message)							
        --print("cardpay back message")							
    end,							
        function(message)							
            --print("cardpay back message err")							
            EginProgressHUD.Instance:ShowPromptHUD(message);							
        end);							
end							
----取消卡密充值							
function this:OnClickCardPwdRechargeNo( pObj )							
    --print("OnClickCardPwdRechargeNo")							
    this:showCardPwdInutGroup()							
end							
----显示卡密充值							
function this:showCardPwdInutGroup()							
    --print("showCardPwdInutGroup")							
    this.CardPwdTipGroup:SetActive(false)							
    this.CardPwdInputGroup:SetActive(true)							
end							
----显示卡密充值提示							
function this:showCardPwdInputTip()							
    --print("showCardPwdInputTip")							
    this.CardPwdTipGroup:SetActive(true)							
    this.CardPwdInputGroup:SetActive(false)							
    this.cardPwdTipLabel.text = string.format(this.cardPwdTipText,this.CardPwdInputNum.value,this.cardPwdValue)							
end							
							
-----------------------------------------banklogin-------------------------------------------							
function this:clearCachePwd()							
    this.hallBankPwd  = "";							
    this.bankPwd = "";							
    BankSocket.bankSessionTerm = "0";							
end							
--显示手机登陆方式							
function this:checkBindBtnState()							
    print("EginUser.Instance.bankLoginType:"..EginUser.Instance.bankLoginType)							
    print("EginUser.wechat_lock"..EginUser.wechat_lock)							
    print("EginUser.wechat_lock"..EginUser.wechat_lock)							
    -- this.bindLoginGroupOtherBtn:SetActive( )--EginUser.wechat_id ~= nil and EginUser.wechat_id ~="" and EginUser.wechat_lock == 1)							
    -- this.wechatGroupOtherBtn:SetActive( EginUser.bankBindPhone == 1)							
    if EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT then							
        this.wechatGroup:SetActive(true)							
        this.unBindLoginGroup:SetActive(false)							
        this.bindLoginGroup:SetActive(false)							
    else							
        this.wechatGroup:SetActive(false)							
        if EginUser.bindPhone == 0 or EginUser.Instance.bankLoginType ~= EginUser.eBankLoginType.PHONE_CODE then							
            this.unBindLoginGroup:SetActive(true)							
            this.bindLoginGroup:SetActive(false)							
        else							
            this.unBindLoginGroup:SetActive(false)							
            this.bindLoginGroup:SetActive(true)							
        end							
    end							
end							
							
--获取登陆验证码							
function this:getPhoneCodeLoginCode()							
    if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE) then							
        local jsonStr = cjson.encode({type="AccountService",tag="bank_refresh",body =0});							
        BaseSceneLua.socketManager:SendPackage(jsonStr);							
    end							
end							
							
--选择微信登录							
function this:OnChooseLoginWx()							
    this.wechatGroup:SetActive(true)							
    this.unBindLoginGroup:SetActive(false)							
    this.bindLoginGroup:SetActive(false)							
end							
							
--选择手机登录							
function this:OnChooseLoginPhone()							
    this.wechatGroup:SetActive(false)							
    this.unBindLoginGroup:SetActive(false)							
    this.bindLoginGroup:SetActive(true)							
end							
							
--手机验证码登录							
function this:OnLoginCode()							
    this.loginType = this.eBankLoginType.PHONE_CODE							
    this:loginBank(this.loginPhoneCodeInput.value)							
end							
							
--手机验证码登录							
function this:OnLoginWx()							
    this.loginType = this.eBankLoginType.WECHAT							
    this:loginBank(this.loginPhoneWxInput.value)							
end							
							
function this:saveLoadMoneySuccess( offsetvalue)
    if offsetvalue ==nil then offsetvalue = 0; end
    EginProgressHUD.Instance:HideHUD();
    EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"));
    this.tempBankMoney = this.tempBankMoney -offsetvalue;
    this.tempBagMoney  =this.tempBagMoney  + offsetvalue;
    this.kBagMoney.text = EginTools.NumberAddComma(this.tempBagMoney) .."";
    this.kSaveBankMoney.text = EginTools.NumberAddComma(this.tempBankMoney) .."";
    this.kBankMoney.text = EginTools.NumberAddComma(this.tempBankMoney) .."";
    -- print('----in  change money ')
    this.kSaveMoney.value = "";
    this.kGetMoney.value = "";
end
--[[
	
	
function this:autoGetUI()
	 -- this.ui_backBtn=this.transform:FindChild("topback/backBtn").gameObject	
	 this.ui_goldPanel=this.transform:FindChild("goldPanel").gameObject	
	 this.ui_goldDoGetBtn=this.transform:FindChild("goldPanel/doGetBtn").gameObject	
	 this.ui_goldDoSaveBTn=this.transform:FindChild("goldPanel/doSaveBtn").gameObject	
	 this.ui_goldTabSaveBtn=this.transform:FindChild("goldPanel/savebtn").gameObject	
	 this.ui_goldTabGetBtn=this.transform:FindChild("goldPanel/getbtn").gameObject	
	 this.ui_goldBagGoldLabel=this.transform:FindChild("goldPanel/grid/baggold/input").gameObject:GetComponent("UILabel")	
	 this.ui_goldBankGoldLabel=this.transform:FindChild("goldPanel/grid/bankGold/input").gameObject:GetComponent("UILabel")	
	 this.ui_goldChangeLabel=this.transform:FindChild("goldPanel/grid/change/inputbg/input").gameObject:GetComponent("UIInput")	
	 this.ui_bindPhoneLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/phone/label").gameObject:GetComponent("UILabel")	
	 this.ui_bindPhoneBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/phone/changeBtn").gameObject	
	 this.ui_safePwdLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/pwd/label").gameObject:GetComponent("UILabel")	
	 this.ui_changPwdBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/pwd/changeBtn").gameObject	
	 this.ui_bindWxLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/wx/label").gameObject:GetComponent("UILabel")	
	 this.ui_bindWxBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/wx/changeBtn").gameObject	
	 this.ui_lockLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/lock/label").gameObject:GetComponent("UILabel")	
	 this.ui_bindLockBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/lock/changeBtn").gameObject	
	 this.ui_findTsLabel=this.transform:FindChild("safePanel/findGroup/safeStarLabel").gameObject:GetComponent("UILabel")	
	 this.ui_findWxLabel=this.transform:FindChild("safePanel/findGroup/proGrid1/wx/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_findIdLabel=this.transform:FindChild("safePanel/findGroup/proGrid1/id/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_findQQLabel=this.transform:FindChild("safePanel/findGroup/proGrid1/qq/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_phone_numLabel=this.transform:FindChild("phonePanel/Grid/nickLabel/bg/input").gameObject:GetComponent("UIInput")	
	 this.ui_phone_CodeLabel=this.transform:FindChild("phonePanel/Grid/codeLabel/bg/input").gameObject:GetComponent("UIInput")	
	 this.ui_phone_CodeBtn=this.transform:FindChild("phonePanel/Grid/codeLabel/changeBtn").gameObject	
	 this.ui_phone_submitBtn=this.transform:FindChild("phonePanel/submitBtn").gameObject	
	 this.ui_tjBtn=this.transform:FindChild("phonePanel/submitBtn").gameObject	
	 this.ui_ChooseHeadTemplate=this.transform:FindChild("head/headIcon").gameObject	
end 	
function this:autoClearUI()
	 this.ui_backBtn= nil	
	 this.ui_goldPanel= nil	
	 this.ui_goldDoGetBtn= nil	
	 this.ui_goldDoSaveBTn= nil	
	 this.ui_goldTabSaveBtn= nil	
	 this.ui_goldTabGetBtn= nil	
	 this.ui_goldBagGoldLabel=nil	
	 this.ui_goldBankGoldLabel=nil	
	 this.ui_goldChangeLabel=nil	
	 this.ui_bindPhoneLabel=nil	
	 this.ui_bindPhoneBtn= nil	
	 this.ui_safePwdLabel=nil	
	 this.ui_changPwdBtn= nil	
	 this.ui_bindWxLabel=nil	
	 this.ui_bindWxBtn= nil	
	 this.ui_lockLabel=nil	
	 this.ui_bindLockBtn= nil	
	 this.ui_findTsLabel=nil	
	 this.ui_findWxLabel=nil	
	 this.ui_findIdLabel=nil	
	 this.ui_findQQLabel=nil	
	 this.ui_phone_numLabel=nil	
	 this.ui_phone_CodeLabel=nil	
	 this.ui_phone_CodeBtn= nil	
	 this.ui_phone_submitBtn= nil	
	 this.ui_tjBtn= nil	
	 this.ui_ChooseHeadTemplate= nil	
end 	

]]