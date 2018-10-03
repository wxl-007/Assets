			
local this = LuaObject:New()																																																													
Module_UpdateAvatar = this																																																													
local cjson = require "cjson"																																																													
																																																													
local isCloseGold = false;																																																													
																																																													
local AVATAR_GROUP = 11;																																																													
																																				
																																				
function this:Awake() 																								
	error("module_update:awake")																								
	this.mono = Hall.mono																									
	this:autoGetUI()																									
	--this.ui_changeHeadPanel:GetComponent("UIPanel").depth = 16																								
	--this.ui_headsScrollView.depth = 17																																																									
	-- this:Init();																																																													
	-- this:handleBtnsFunc()																																																													
																																																														
	Module_GameRecord.isSocket = true																																																										
	this.isNet = true																																				
	this.isUpdateAvatar = false																																							
	this.module_ConvertRegister = nil;																							
	this.m_MailChangePassword = 0;			
	this.IsInUnBind = false 
	this.IsInBankBind = false 																																					
																																					
end 																																								
function this:Init() 																																																													
	--[[  																																																												
	  																																																												
	  																																																													
	--this.vBoy = this.transform:FindChild("Offset/Avatars/Gride - Boy").gameObject:GetComponent("UIGrid");																																																													
	this.vIconScrollView = this.transform:FindChild("UpdateAvatar/UpdateAvatar/ScrollView").gameObject:GetComponent("UIScrollView");																																																													
	this.ui_headsGrid = this.transform:FindChild("UpdateAvatar/UpdateAvatar/ScrollView/GrideIcon").gameObject:GetComponent("UIGrid");																																																													
	this.gameUpdateAvatar = this.transform:FindChild("UpdateAvatar").gameObject																																																													
	this.gameUpdateAvatarBGAnimator = this.transform:FindChild("UpdateAvatar/UpdateAvatarBG").gameObject:GetComponent("Animator")																																																													
	this.gameUpdateAvatarAnimator = this.transform:FindChild("UpdateAvatar/UpdateAvatar").gameObject:GetComponent("Animator")																																																													
	----Vip界面																																																													
	this.VipText = this.transform:FindChild("Offset/Avatars/vip/top/Text_hint (1)"):GetComponent("UILabel");																																																													
	this.VipIconB = this.transform:FindChild("Offset/Avatars/vip/bottom/vipIcon"):GetComponent("UISprite");																																																													
	this.VipTextHint = this.transform:FindChild("Offset/Avatars/vip/bottom/Text_hint"):GetComponent("UILabel");																																																													
	this.VipVipLevel = this.transform:FindChild("Offset/Avatars/vip/bottom/Text_VipLevel"):GetComponent("UILabel");																																																													
	this.VipProgressBar = this.transform:FindChild("Offset/Avatars/vip/bottom/ProgressBar"):GetComponent("UISlider");																																																													
	this.VipBarLabel = this.transform:FindChild("Offset/Avatars/vip/bottom/ProgressBar/Lab_Num"):GetComponent("UILabel");																																																													
																																																													
																																																													
																																																														
	this.GirlBoyAllArr = {};																																																													
	this.kAvatarPrefab = ResManager:LoadAsset("happycity/updateavatar_avatar","UpdateAvatar_Avatar");																																																													
	this.textID = this.transform:FindChild("Offset/Avatars/info/infoIcon/TextID").gameObject:GetComponent("UILabel");																																																													
	this.textName = this.transform:FindChild("Offset/Avatars/info/infoIcon/TextName").gameObject:GetComponent("UILabel");																																																													
	this.infoIcon = this.transform:FindChild("Offset/Avatars/info/infoIcon/iconBg/icon").gameObject:GetComponent("UISprite");																																																													
																																																														
																																																														
	this.input_name = this.transform:FindChild("Offset/Avatars/info/infoText/Text_name/Input_name/Label").gameObject:GetComponent("UILabel");																																																													
																																																														
	this.genderToggle1 = this.transform:FindChild("Offset/Avatars/info/infoText/Text_gender/SimpleCheckbox1").gameObject:GetComponent("UIToggle");																																																													
	this.genderToggle2 = this.transform:FindChild("Offset/Avatars/info/infoText/Text_gender/SimpleCheckbox2").gameObject:GetComponent("UIToggle");																																																													
	this.genderToggle3 = this.transform:FindChild("Offset/Avatars/info/infoText/Text_gender/SimpleCheckbox3").gameObject:GetComponent("UIToggle");																																																													
																																																														
	this.goldBagMoney = this.transform:FindChild("Offset/Avatars/info/infoText/Text_gold/BagMoney/Lab_BagMoney").gameObject:GetComponent("UILabel");																																																													
																																																														
	this.ingotBagMoney = this.transform:FindChild("Offset/Avatars/info/infoText/Text_ingot/BagMoney/Lab_BagMoney").gameObject:GetComponent("UILabel");																																																													
    this.ybShopBtn = this.transform:FindChild("Offset/Avatars/info/infoText/Text_ingot/dhBtn").gameObject																																																													
     this.ybShopBtn:SetActive(false)																																																													
     if PlatformGameDefine.playform:GetPlatformPrefix()=="131"then																																																													
         this.ybShopBtn:SetActive(true)																																																													
         this.mono:AddClick( this.ybShopBtn,this.OnClickYbShop);																																																													
     end																																																													
																																																													
	this.bankBagMoney = this.transform:FindChild("Offset/Avatars/info/infoText/Text_bank/BagMoney/Lab_BagMoney").gameObject:GetComponent("UILabel");																																																													
																																																														
	this.VictoryV1 = this.transform:FindChild("Offset/Avatars/info/infoText/Text_Victory/Lab_1").gameObject:GetComponent("UILabel");																																																													
																																																														
	this.VictoryV2 = this.transform:FindChild("Offset/Avatars/info/infoText/Text_Victory/Lab_2").gameObject:GetComponent("UILabel");																																																													
																																																														
	this.memberSprite = this.transform:FindChild("Offset/Avatars/info/infoText/Text_member/Texture").gameObject:GetComponent("UISprite");																																																													
																																																														
	this.integralBar = this.transform:FindChild("Offset/Avatars/info/infoText/Text_integral/ProgressBar").gameObject:GetComponent("UISlider");																																																													
																																																														
	this.integralLab = this.transform:FindChild("Offset/Avatars/info/infoText/Text_integral/Lab_1").gameObject:GetComponent("UILabel");																																																													
																																																														
	this.btn_Safety = this.transform:FindChild("Offset/Avatars/info/infoText/btn_Safety").gameObject 																																																													
																																																											
																																																														
	this.infoIconUp = this.transform:FindChild("Offset/Avatars/info/infoIcon/Up").gameObject																																																													
	this.infoIconUp:SetActive(false);																																																													
																																																														
	------------------------安全绑定-------------------																																																													
	this.m_AccountSecurity = this.transform:FindChild("AccountSecurity");																																																													
	this.m_AccountSecurityOffset = this.m_AccountSecurity:FindChild("Offset")																																																													
	this.m_AccountSecurityEmail = this.m_AccountSecurity:FindChild("Email")																																																													
	this.m_AccountSecurityMobilePhone = this.m_AccountSecurity:FindChild("MobilePhone")																																																													
	this.m_AccountSecurityMobileidentity = this.m_AccountSecurity:FindChild("Mobileidentity")																																																													
																																																														
																																																														
	this.m_OffsetName = this.m_AccountSecurityOffset:FindChild("Views/Username/LabelName").gameObject:GetComponent("UILabel");																																																													
																																																														
	this.m_EmailName = this.m_AccountSecurityEmail:FindChild("Views/Username/LabelName").gameObject:GetComponent("UILabel");																																																													
	this.m_Email = this.m_AccountSecurityEmail:FindChild("Views/Email/Input").gameObject:GetComponent("UIInput");																																																													
	this.m_EmailValidation = this.m_AccountSecurityEmail:FindChild("Views/Validation/Input").gameObject:GetComponent("UIInput");																																																													
																																																														
	this.m_MobilePhoneName = this.m_AccountSecurityMobilePhone:FindChild("Views/Username/LabelName").gameObject:GetComponent("UILabel");																																																													
	this.m_MobilePhone = this.m_AccountSecurityMobilePhone:FindChild("Views/MobilePhone/Input").gameObject:GetComponent("UIInput");																																																													
	this.m_MobilePhoneValidation = this.m_AccountSecurityMobilePhone:FindChild("Views/Validation/Input").gameObject:GetComponent("UIInput");																																																													
																																																														
	this.m_MobileidentityName = this.m_AccountSecurityMobileidentity:FindChild("Views/Mobileidentity/Input").gameObject:GetComponent("UIInput");																																																													
	this.m_Mobileidentity = this.m_AccountSecurityMobileidentity:FindChild("Views/Validation/Input").gameObject:GetComponent("UIInput");																																																													
																																																														
	this.m_MobilePhonebtn = this.m_AccountSecurityOffset:FindChild("Views/MobilePhone/btnPhone").gameObject																																																													
	this.m_MobilePhonebtn1 = this.m_AccountSecurityOffset:FindChild("Views/MobilePhone/btnPhone (1)").gameObject																																																													
	this.m_MobilePhonelab = this.m_AccountSecurityOffset:FindChild("Views/MobilePhone/Label (1)").gameObject:GetComponent("UILabel")																																																													
																																																														
	this.m_MobileEmailbtn = this.m_AccountSecurityOffset:FindChild("Views/Email/btnEmail").gameObject																																																													
	this.m_MobileEmailbtn1 = this.m_AccountSecurityOffset:FindChild("Views/Email/btnEmail (1)").gameObject																																																													
	this.m_MobileEmaillab = this.m_AccountSecurityOffset:FindChild("Views/Email/Label (1)").gameObject:GetComponent("UILabel")																																																													
																																																														
	this.m_Mobileidbtn = this.m_AccountSecurityOffset:FindChild("Views/identity/btn").gameObject																																																													
	this.m_Mobileidbtn1 = this.m_AccountSecurityOffset:FindChild("Views/identity/btn (1)").gameObject																																																													
	this.m_Mobileidlab = this.m_AccountSecurityOffset:FindChild("Views/identity/Label (1)").gameObject:GetComponent("UILabel")																																																													
	--解除绑定																																																													
	this.m_unbundlingPhone = this.m_AccountSecurity:FindChild("unbundlingPhone") 																																																													
	this.m_unbundlingTitle = this.m_unbundlingPhone:FindChild("Label").gameObject:GetComponent("UISprite")																																																													
	this.m_unbundlingLabe = this.m_unbundlingPhone:FindChild("Views/MobilePhone/Label").gameObject:GetComponent("UILabel")																																																													
	this.m_unbundlingVLabe = this.m_unbundlingPhone:FindChild("Views/MobilePhone/Label(1)").gameObject:GetComponent("UILabel")																																																													
	this.m_unbundlingVInput = this.m_unbundlingPhone:FindChild("Views/Validation/Input").gameObject:GetComponent("UIInput")																																																													
																																																														
																																																														
	------------------------帐号安全-------------------																																																													
	this.m_safety = this.transform:FindChild("Offset/Avatars/safety");																																																													
	this.m_safetyAS = this.m_safety:FindChild("AccountSecurity");																																																													
																																																														
	this.m_safetyPLab = this.m_safety:FindChild("Rbody/Text_Phone/Lab_BagMoney").gameObject:GetComponent("UILabel");																																																													
	this.m_safetyPBtn = this.m_safety:FindChild("Rbody/Text_Phone/AddMoney").gameObject;																																																													
	this.m_safetyRBtn = this.m_safety:FindChild("Rbody/Text_Phone/relieve").gameObject;																																																													
																																																														
	this.m_safetyWLab = this.m_safety:FindChild("Rbody/Text_password/Lab_BagMoney").gameObject:GetComponent("UILabel");																																																													
	this.m_safetyWBtn = this.m_safety:FindChild("Rbody/Text_password/AddMoney").gameObject;																																																													
																																																														
	this.m_safetyCLab = this.m_safety:FindChild("Rbody/Text_WeChat/Lab_BagMoney").gameObject:GetComponent("UILabel");																																																													
	this.m_safetyCBtn = this.m_safety:FindChild("Rbody/Text_WeChat/AddMoney").gameObject;																																																													
																																																													
	this.m_safetyLwLab = this.m_safety:FindChild("Lbody/Text_WeChat/Input_name").gameObject:GetComponent("UIInput");																																																													
	this.m_safetyLwBtn = this.m_safety:FindChild("Lbody/Text_WeChat/AddMoney").gameObject;																																																													
	this.m_safetyLwV = this.m_safety:FindChild("Lbody/Text_WeChat/Lab_BagMoney").gameObject:GetComponent("UILabel");																																																													
																																																														
	this.m_safetyLtLab = this.m_safety:FindChild("Lbody/Text_ID/Lab_BagMoney").gameObject:GetComponent("UILabel"); 																																																													
																																																														
	this.m_safetyLqLab = this.m_safety:FindChild("Lbody/Text_QQ/Input_name").gameObject:GetComponent("UIInput");																																																													
	this.m_safetyLqBtn = this.m_safety:FindChild("Lbody/Text_QQ/AddMoney").gameObject;																																																													
	this.m_safetyLqV = this.m_safety:FindChild("Lbody/Text_QQ/Lab_BagMoney").gameObject:GetComponent("UILabel");																																																													
																																																														
	--帐号安全中的二级界面																																																													
	--手机绑定																																																													
	this.m_AccountSecurityMobilePhone2 = this.m_safetyAS:FindChild("MobilePhone")																																																													
																																																													
	this.m_MobilePhoneName2 = this.m_AccountSecurityMobilePhone2:FindChild("Views/Username/LabelName").gameObject:GetComponent("UILabel");																																																													
	this.m_MobilePhone2 = this.m_AccountSecurityMobilePhone2:FindChild("Views/MobilePhone/Input").gameObject:GetComponent("UIInput");																																																													
	this.m_MobilePhoneValidation2 = this.m_AccountSecurityMobilePhone2:FindChild("Views/Validation/Input").gameObject:GetComponent("UIInput");																																																													
																																																														
	--手机解绑																																																													
	this.m_unbundlingPhone2 = this.m_safetyAS:FindChild("unbundlingPhone") 																																																													
	this.m_unbundlingTitle2 = this.m_unbundlingPhone2:FindChild("Label").gameObject:GetComponent("UISprite")																																																													
	this.m_unbundlingLabe2 = this.m_unbundlingPhone2:FindChild("Views/MobilePhone/Label").gameObject:GetComponent("UILabel")																																																													
	this.m_unbundlingVLabe2 = this.m_unbundlingPhone2:FindChild("Views/MobilePhone/Label(1)").gameObject:GetComponent("UILabel")																																																													
	this.m_unbundlingVInput2 = this.m_unbundlingPhone2:FindChild("Views/Validation/Input").gameObject:GetComponent("UIInput")																																																													
	--bankphone手机银行绑定																																																													
     this.m_BankPhoneGroup  = this.m_safety:FindChild("Rbody/Text_PhoneBank").gameObject																																																													
     this.m_BankPhoneBindBtn = this.m_safety:FindChild("Rbody/Text_PhoneBank/AddMoney").gameObject																																																													
     this.m_BankPhoneUnBindBtn = this.m_safety:FindChild("Rbody/Text_PhoneBank/relieve").gameObject																																																													
     this.m_BankPhoneNumLabel = this.m_safety:FindChild("Rbody/Text_PhoneBank/Lab_BagMoney").gameObject:GetComponent("UILabel")																																																													
     this.m_BankPhoneBindPanel = this.m_safety:FindChild("AccountSecurity/MobileBankPhone").gameObject																																																													
     this.m_BankPhoneUnBindPanel = this.m_safety:FindChild("AccountSecurity/UnMobileBankPhone").gameObject																																																													
     --锁定本机登录																																																													
     this.m_LockDeviceGroup = this.m_safety:FindChild("Rbody/Text_LockDevice").gameObject																																																													
     this.m_LockDeviceGroupLockLabel =this.m_safety:FindChild("Rbody/Text_LockDevice/Lab_BagMoney").gameObject:GetComponent("UILabel")																																																													
     this.m_LockDeviceGroupLockBtn = this.m_safety:FindChild("Rbody/Text_LockDevice/AddMoney").gameObject																																																													
     this.m_LockDeviceGroupUnLockBtn = this.m_safety:FindChild("Rbody/Text_LockDevice/relieve").gameObject																																																													
     --修改密码																																																													
     this.m_ChangePasswordS1 = this.m_safetyAS:FindChild("ChangePassword")																																																													
	 this.m_ChangePasswordTips2 = this.m_ChangePasswordS1:FindChild("Views/LabelTipsBG").gameObject																																																													
	 this.m_ChangePasswordTipsLabel2 = this.m_ChangePasswordS1:FindChild("Views/LabelTipsBG/LabelTips").gameObject:GetComponent("UILabel");																																																													
	 this.m_ChangePasswordTipsLabel2.text = ""																																																													
	  																																																													
	 this.m_ChangePasswordS2 = this.m_safetyAS:FindChild("ChangePassword2") 																																																													
	 --this.m_ChangePasswordS2.localPosition = Vector3.New(9999,0,0)																																																													
	 																																																													
	 this.m_ChangePasswordName2 = this.m_ChangePasswordS2:FindChild("Views/Username/LabelName").gameObject:GetComponent("UILabel");																																																													
	this.m_ChangePasswordValidation2 = this.m_ChangePasswordS2:FindChild("Views/Validation/Input").gameObject:GetComponent("UIInput");																																																													
	this.m_ChangePasswordNewPassword2 = this.m_ChangePasswordS2:FindChild("Views/NewPassword/Input").gameObject:GetComponent("UIInput");																																																													
	  																																																													
	------------------------帐号修改-------------------																																																													
	 this.m_ChangePassword = this.m_AccountSecurity:FindChild("ChangePassword")																																																													
	 this.m_ChangePasswordTips = this.m_ChangePassword:FindChild("Views/LabelTipsBG").gameObject																																																													
	 this.m_ChangePasswordTipsLabel = this.m_ChangePassword:FindChild("Views/LabelTipsBG/LabelTips").gameObject:GetComponent("UILabel");																																																													
	 this.m_ChangePasswordTipsLabel.text = ""																																																													
	 																																																													
	 this.m_MailChangePassword = 0;																																																													
	 this.m_ChangePassword2 = this.m_AccountSecurity:FindChild("ChangePassword2") 																																																													
	-- this.m_ChangePassword2.localPosition = Vector3.New(9999,0,0)																																																													
	 																																																													
	 this.m_ChangePasswordName = this.m_ChangePassword2:FindChild("Views/Username/LabelName").gameObject:GetComponent("UILabel");																																																													
	this.m_ChangePasswordValidation = this.m_ChangePassword2:FindChild("Views/Validation/Input").gameObject:GetComponent("UIInput");																																																													
	this.m_ChangePasswordNewPassword = this.m_ChangePassword2:FindChild("Views/NewPassword/Input").gameObject:GetComponent("UIInput");																																																													
																																																														
																																																														
	this:GameRecordAwake()																																																													
	this:GameHonorAwake()																																													
	--]]																																																										
end																									
																																									
function this:Start()																									
	error("module_update:start")																																													
	EginTools.setScreen(this.transform,1080,1920)																																									
	if  PlatformGameDefine.playform.IsSocketLobby then this.mono:StartSocket(false); end																																																													
	this:LoadAvatars() 																																																																										
	this.mono:AddClick(this.ui_backBtn, function()																																					
		 --Utils.LoadLevelGUI("Hall");															
		 this.ui_tabInfoBtn:SendMessage("OnClick")																						
		 -- HallUtil:HidePanelAni(this.gameObject)											
		 HallUtil:PopupPanel('Hall',false,this.gameObject,nil)																																			
	end,this)																																						
	--hideitem												
	this.ui_honorItem:SetActive(false)												
	this.ui_recordItem:SetActive(false)															
	--info																															
	this.ui_idLabel.text =   EginUser.Instance.uid																																																											
	this.ui_nickLabel.text = EginUser.Instance.nickname																					
	this.ui_ybLabel.text = EginUser.Instance.goldIngot																							
	this.ui_bankLabel.text = EginUser.Instance.bankMoney																				
	this.ui_goldLabel.text = EginUser.Instance.bagMoney;																																																							
	this.ui_headIcon.spriteName = "avatar_" .. EginUser.Instance.avatarNo																																	
	this.mailBindPanelTitle = this.transform:FindChild("mailPanel/title").gameObject:GetComponent("UISprite")
	this.ui_phone_titleBtn=this.transform:FindChild("phonePanel/title").gameObject:GetComponent("UISprite")	
	this.ui_BankBindPhoneBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/BankLock/lockPhoneBtn").gameObject
	this.ui_BankUnBindPhoneBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/BankLock/unLockPhoneBtn").gameObject												
	--切换账号														
	this.mono:AddClick(this.ui_changeIdBtn,this.OnReplace,this)																
	--修改头像																							
	this.mono:AddClick(this.ui_headIcon.gameObject,function()																									
			HallUtil:ShowPanelAni(this.ui_changeHeadPanel)																							
	end,this)																					
																					
	--改变性别																				
	this.mono:AddClick( this.ui_genderToggle1.gameObject,function ( ) 																																																													
		EginUser.Instance.sex = 1																																																													
		this:Change_Sex()																																																													
	end ) 																																																													
	this.mono:AddClick( this.ui_genderToggle2.gameObject,function ( ) 																																																													
		EginUser.Instance.sex = 2																																																													
		this:Change_Sex()																																																													
	end ) 																																																													
	this.mono:AddClick( this.ui_genderToggle3.gameObject,function ( ) 																																																													
		EginUser.Instance.sex = 3																																																													
		this:Change_Sex()																																																													
	end ) 																					
	this:refreshSex(EginUser.Instance.sex)																	
	--胜率																
	if EginUser.Instance.win_times == 0 and EginUser.Instance.lost_times == 0 then																																																													
		this.ui_rateLabel.text = "100%"																																																													
	else																																																													
		if  EginUser.Instance.win_times ~= nil and EginUser.Instance.lost_times ~= nil then																																																													
			this.ui_rateLabel.text = string.format("%.2f", EginUser.Instance.win_times*100/(EginUser.Instance.win_times+EginUser.Instance.lost_times)).."%"																																																													
		end																																																													
	end																		
	if EginUser.Instance.win_times ~= nil and EginUser.Instance.lost_times ~= nil then																																																													
	    this.ui_rateDetailLabel.text = EginUser.Instance.win_times.."胜/"..EginUser.Instance.lost_times.."负"																																																													
	end																	
   														
	this.mono:AddClick(this.ui_infoStarBtn,function ( ) 																																																											
		 -- this.ui_tabSafeBtn:SendMessage("OnClick")	
		 HallUtil:PopupSecondPanel(this.transform:FindChild('AccountSafty').gameObject)
		 																																																												
	end ) 															
	this.mono:AddClick(this.ui_phone_MailBtn,function ()									
		this.transform:FindChild('AccountSafty').gameObject:SetActive(false)	
		this.mailBindPanelTitle.spriteName = "Title_Mail";						
		-- this.transform:FindChild('mailPanel').gameObject:SetActive(true)
		HallUtil:PopupSecondPanel(this.transform:FindChild('mailPanel').gameObject)									
	end)									
	this.mono:AddClick(this.ui_phone_PhoneBtn,function ()									
		this.transform:FindChild('AccountSafty').gameObject:SetActive(false)									
		-- this.transform:FindChild('phonePanel').gameObject:SetActive(true)	
					HallUtil:PopupSecondPanel(	this.transform:FindChild('phonePanel').gameObject)
		this.IsInUnBind = false 		
		this.ui_phone_numLabel.enabled = true 	
		this.ui_phone_titleBtn.spriteName = 'Title_phone'		
		
	end)									
	this.ui_memberLabel.text = EginUser.Instance.vipLevel							
						
	this.mono:AddClick(this.ui_changePSDBtn,function ()						
		this.transform:FindChild('AccountSafty').gameObject:SetActive(false)									
		-- this.transform:FindChild('ChangePsdPanel').gameObject:SetActive(true)	
		HallUtil:PopupSecondPanel(	this.transform:FindChild('ChangePsdPanel').gameObject	)		
	end)					
				
	--邮箱																																																										
	this.mono:AddClick( this.ui_Mail_CodeBtn,function ( ) 																																																													
		--获取邮箱验证码																																																													
		if this.ui_Mail_AdInput.value ~= "" then 																																																													
			this:send_email_code(1,this.ui_Mail_AdInput.value,function() 																																																													
			end) 	
		else
			 EginProgressHUD.Instance:ShowPromptHUD("邮箱不能为空",0.5)																																																										
		end																																																													
	end ) 																																																													
	this.mono:AddClick( this.ui_Mail_lBtn,function ( ) 																																																													
		--发送绑定邮箱请求																																																													
		if this.ui_Mail_varifyInput.value ~= "" then	
			if this.IsInUnBind ==false then   																																																													
				this:bind_email(1,this.ui_Mail_AdInput.value,this.ui_Mail_varifyInput.value,function() 																																																													
					this.m_AccountSecurityEmail.gameObject:SetActive(false);																																																													
				end)  								
			else	
				if EginUser.Instance.email == this.ui_Mail_AdInput.value then 	
					this:bind_email(0,EginUser.Instance.email,this.ui_Mail_varifyInput.value,function()																																																													
						this.m_AccountSecurityEmail.gameObject:SetActive(false) 																																																													
					end)  	
				else	
					EginProgressHUD.Instance:ShowPromptHUD("邮箱不匹配",0.5)	
				end	
			end																																																						
		 end																																																													
	end)					
		
	 -- this.m_ChangePasswordTips = this.transform:FindChild("ChangePsdPanel/LabelTipsBG").gameObject																																																													
	 -- this.m_ChangePasswordTipsLabel = this.transform:FindChild("ChangePsdPanel/LabelTipsBG/LabelTips").gameObject:GetComponent("UILabel");																																																													
	 -- this.m_ChangePasswordTipsLabel.text = ""																																																													
	  																						
	this.mono:AddClick( this.ui_Pwd_VarifyBtn,function ( ) 																																																													
		--获取邮箱或者手机的验证码																																																													
		 this:ChangePasswordCharcode(this.m_MailChangePassword,function ( )   end)  																																																													
	end ) 																																																													
	this.mono:AddClick( this.ui_Pwd_Btn,function ( ) 																																																													
		--发送修改密码请求																																																													
		if this.ui_Pwd_NewInput.value ~= "" then																																																													
			this:ChangePassword(this.m_MailChangePassword,function ( )  		
				this.ui_pwd_VarifyInput.value = ''																																																													
				this.ui_Pwd_NewInput.value = ''																																																													
			end,this.ui_pwd_VarifyInput.value,this.ui_Pwd_NewInput.value) 																																																													
		end																																																													
		 																																																													
	end )		
		
		
	this.mono:AddClick( this.ui_phone_CBtn,function ( ) 																																																													
		--手机修改密码																																																													
		if  EginUser.Instance.phone ~= "" then 																																																													
			--已经绑定了																																																													
			this.m_MailChangePassword = 0;																																																													
			-- this:AnimatorChangePassword2(this.m_ChangePassword2) 		
			-- this.transform:FindChild('pwdPanel').gameObject:SetActive(true)	
			HallUtil:PopupSecondPanel(this.transform:FindChild('pwdPanel').gameObject)	
			this.transform:FindChild('ChangePsdPanel').gameObject:SetActive(false)		
		else																																																													
			--未绑定																																																													
			-- this:showChangePasswordTips(this.m_ChangePasswordTips,this.m_ChangePasswordTipsLabel,"您没有绑定手机,无法进行该操作.");																																																													
			 EginProgressHUD.Instance:ShowPromptHUD("您没有绑定手机,无法进行该操作.",0.5)																																																										
		end																																																													
	end ) 																																																													
	this.mono:AddClick( this.ui_Mail_CBtn,function ( ) 																																																													
		--邮箱修改密码																																																													
		if   EginUser.Instance.email ~= ""  then 																																																													
			--已经绑定了																																																													
			this.m_MailChangePassword = 1;			
			-- this.transform:FindChild('pwdPanel').gameObject:SetActive(true)		
			HallUtil:PopupSecondPanel(this.transform:FindChild('pwdPanel').gameObject)
			this.transform:FindChild('ChangePsdPanel').gameObject:SetActive(false)		
		
			-- this:AnimatorChangePassword2(this.m_ChangePassword2)																																																													
		else																																																													
			--未绑定																																																													
			-- this:showChangePasswordTips(this.m_ChangePasswordTips,this.m_ChangePasswordTipsLabel,"您没有绑定邮箱,无法进行该操作.");																																																													
			  		 EginProgressHUD.Instance:ShowPromptHUD("您没有绑定邮箱,无法进行该操作.")																																																											
		end																																																													
	end )					
		
	this.mono:AddClick( this.ui_ID_SureBtn,function ( ) 																																																													
		--发送绑定身份证请求																																																													
		 if this.ui_ID_IDNumInput.value ~= "" then 																																																													
			EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
			this.mono:Request_lua_fun("AccountService/safe_cert", cjson.encode( {cert_no=this.ui_ID_IDNumInput.value} ),																																																													
			function(result)																																																													
				 EginProgressHUD.Instance:ShowPromptHUD("认证成功",0.5);																																																													
				 this.transform:FindChild('IDPanel').gameObject:SetActive(false);																																																													
				 this:InitInfo() 																																																													
			end, 																																																													
			function(result) 																																																													
				EginProgressHUD.Instance:ShowPromptHUD("认证失败",0.5);  																																																													
			end); 																																																													
		 end																																																													
		 																																																													
	end)	
	
	
	this.mono:AddClick( this.transform:FindChild("IDPanel/closeBtn").gameObject,function ( ) 																																																													
		this.ui_ID_NameInput.value = ''																																																													
		this.ui_ID_IDNumInput.value = ''																																																													
	end ) 							
			
	this.mono:AddClick( this.ui_phone_submitBtn,function ( )  																																																													
		--发送解绑请求					
		if this.IsInUnBind == false then 																																																										
			if this.ui_phone_numLabel.value ~= "" then 	
				--lxtd003																																																												
				this:bind_phone(1, this.ui_phone_numLabel.value,this.ui_phone_CodeLabel.value,function() 																																																													
					this.transform:FindChild('phonePanel').gameObject:SetActive(false)																																																													
				end)																																																																																																																								
			end			
		else		
			if this.ui_phone_numLabel.value ~= "" then 																																																													
				this:bind_phone(0, EginUser.Instance.phone,this.ui_phone_CodeLabel.value,function() 																																																													
					this.transform:FindChild('phonePanel').gameObject:SetActive(false)																																																													
				end)		
			end		
		
		end																																																												
		 																																																													
	end )					
		
	this.mono:AddClick(this.ui_phone_CodeBtn,function (  )		
		if this.IsInUnBind == true then 		
    		this:sendBankPhoneCode(0,EginUser.phone)		
    	else		
			--lxtd003 modified
    		this:sendBankPhoneCode(1, this.ui_phone_numLabel.value)		
    	end																																																													
	end)						
		
		
		
	this.mono:AddClick( this.transform:FindChild('phonePanel/closeBtn').gameObject ,function ( )  																																																													
		this.ui_phone_numLabel.value = ''		
		this.ui_phone_CodeLabel.value = ''																																																	
	end ) 				
	this.mono:AddClick(this.ui_safeUnBindPhoneBtn,function ( )		
		this.IsInUnBind = true 		
		-- this.transform:FindChild('phonePanel').gameObject:SetActive(true)	
		HallUtil:PopupSecondPanel(this.transform:FindChild('phonePanel').gameObject);	
		this.ui_phone_numLabel.value = EginUser.Instance.phone		
		this.ui_phone_numLabel.enabled = false 		
		this.ui_phone_titleBtn.spriteName = 'Title_UPhone'	
	end)		
	this.mono:AddClick(this.ui_safeBindPhoneBtn,function ( )		
		this.IsInUnBind = false 		
		-- this.transform:FindChild('phonePanel').gameObject:SetActive(true)	
		HallUtil:PopupSecondPanel(	this.transform:FindChild('phonePanel').gameObject)
		this.ui_phone_numLabel.value = ''		
		this.ui_phone_numLabel.enabled = true 		
		this.ui_phone_titleBtn.spriteName = 'Title_phone'	
	end)	
	this.mono:AddClick(this.ui_bind_idBtn,function (  )	
		-- this.transform:FindChild('IDPanel').gameObject:SetActive(true)
			HallUtil:PopupSecondPanel(this.transform:FindChild('IDPanel').gameObject)
		this.transform:FindChild('AccountSafty').gameObject:SetActive(false)	
	end)	
	this.mono:AddClick(this.ui_safeChangePwdBtn,function (  )
			HallUtil:PopupSecondPanel(this.transform:FindChild('ChangePsdPanel').gameObject)
		-- this.transform:FindChild('ChangePsdPanel').gameObject:SetActive(true)	
	end)	
	this.mono:AddClick(this.ui_safeUnLockBtn,function (  )	
		-- this:sendLockRequest(0)		
		this.mailBindPanelTitle.spriteName = "Title_UMail";
		HallUtil:PopupSecondPanel(this.transform:FindChild('mailPanel').gameObject)
		-- this.transform:FindChild('mailPanel').gameObject:SetActive(true)	
		this.IsInUnBind = true 	
	
		  	
	end)	
 	this.mono:AddClick(this.ui_safeLockBtn,function (  )	
		-- this:sendLockRequest(1)	
		this.mailBindPanelTitle.spriteName = "Title_Mail";
		HallUtil:PopupSecondPanel(this.transform:FindChild('mailPanel').gameObject)--:SetActive(true)

		this.IsInUnBind = false	
	
	end)	
	this.mono:AddClick(this.ui_BankBindPhoneBtn,function ()
		HallUtil:PopupSecondPanel(this.transform:FindChild('BankphonePanel').gameObject)
		this.transform:FindChild("BankphonePanel/Grid/nickLabel/bg/input").gameObject:GetComponent("UIInput").value = ''
		this.mono:AddClick(this.transform:FindChild('BankphonePanel/Grid/codeLabel/changeBtn').gameObject,function ()
			this:OnBankPhoneUnBindCode()	
		end)
		this.mono:AddClick(this.transform:FindChild('BankphonePanel/submitBtn').gameObject,function ()
			this:OnPhoneUnBindHandle()
		end)
	end)
	this.mono:AddClick(this.ui_BankUnBindPhoneBtn,function ()
		HallUtil:PopupSecondPanel(this.transform:FindChild('BankphonePanel').gameObject)
		this.transform:FindChild("BankphonePanel/Grid/nickLabel/bg/input").gameObject:GetComponent("UIInput").value = ShowFrontEndThree(EginUser.phone)
		this.mono:AddClick(this.transform:FindChild('BankphonePanel/Grid/codeLabel/changeBtn').gameObject,function ()
			this:OnBankPhoneUnBindCode()	
		end)
		this.mono:AddClick(this.transform:FindChild('BankphonePanel/submitBtn').gameObject,function ()
			this:OnPhoneUnBindHandle()
		end)
	end)
	this.mono:AddClick(this.bindWxBtn,function ( )
		Application.OpenURL(ConnectDefine.HostURL);	
	end)
	--vip																																																											
	--[[																																																										
																																																												
	 this.memberSprite.spriteName = "mvip" .. EginUser.Instance.vipLevel; 																																																													
	if EginUser.Instance.vipLevel == 0 then																																																													
		--this.vipBtn:SetActive(true) 																																																													
	end																																																													
	--]]																																																									
 																
	--等级																																																												
	this.ui_lvProcessLabel.text = EginUser.Instance.levelExp .. "/" .. EginUser.Instance.nextLevelExp; 															
	if(EginUser.Instance.nextLevelExp>0) then																																																											
		this.ui_LvProgress.value = EginUser.Instance.levelExp /EginUser.Instance.nextLevelExp;																																																													
	else																																																													
		this.ui_LvProgress.value = 0;																																																													
	end 																																																																													
																																																														
	local  playerLevelArr = {"实习生","经理","副总裁","总裁","董事长","千王","无敌","财神","首富"}																																																													
	 local money = tonumber(EginUser.Instance.bagMoney)+tonumber(EginUser.Instance.bankMoney)																																																													
	 local integralL = function() 																																																													
		if(money<=200000) then  return playerLevelArr[1];																																																													
		elseif(money<=500000) then  return playerLevelArr[2];																																																													
		elseif(money<=1000000) then  return playerLevelArr[3];																																																													
		elseif(money<=2000000) then  return playerLevelArr[4];																																																													
		elseif(money<=5000000)  then return playerLevelArr[5];																																																													
		elseif(money<=10000000)  then return playerLevelArr[6];																																																													
		elseif(money<=20000000)  then return playerLevelArr[7];																																																													
		elseif(money<=99999999)  then return playerLevelArr[8];																																																													
		else return playerLevelArr[9]; end 																																																													
	end																																																													
	if EginUser.Instance.level >= 8 then																																																													
		--this.integralLab.text = "("..playerLevelArr[9]..")";																																																													
	else																																																													
		--this.integralLab.text = "("..playerLevelArr[EginUser.Instance.level+1]..")";																																																													
	end																																																													
																																																														
	--this.btn_Safety																																																													
																																																														
	--this.VipText 																																																													
	--this.VipIconB.spriteName = "vip" .. EginUser.Instance.vipLevel; 																																																													
	--this.VipTextHint																																																													
	--this.VipVipLevel																																																													
	--this.VipProgressBar																																																													
	--this.VipBarLabel																																																													
																																																														
	this:InitInfo() 																																																													
end																										
function this:refreshSex(pSex)																					
	this.ui_genderToggle1:GetComponent("UIToggle").value = tostring(pSex)=="1" 																																																													
	this.ui_genderToggle2:GetComponent("UIToggle").value =  tostring(pSex)=="2" 																																																													
	this.ui_genderToggle3:GetComponent("UIToggle").value =  tostring(pSex)=="3"																																																													
end																																																																	
																																																				
function this:handleBtnsFunc()																																												
	--[[																																																										
																																																											
	--local button_Submit = this.transform:FindChild("Offset/Button_Submit").gameObject																																																													
	--this.mono:AddClick(button_Submit, this.OnClickUpdateAvatar,this )																																																													
    --bankphone手机银行相关																																																													
    this.safetyTabToggle =  this.transform:FindChild("Options/Option_0").gameObject:GetComponent("UIToggle");																																																													
    --lockdevice																																																													
    this.mono:AddClick(this.m_LockDeviceGroupLockBtn, this.OnClickLockDevice,this)																																																													
    this.mono:AddClick(this.m_LockDeviceGroupUnLockBtn, this.OnClickUnLockDevice,this)																																																													
    --																																																													
    this.mono:AddClick(this.safetyTabToggle.gameObject, this.OnShowSafetyTabToggleView,this)																																																													
																																																													
	this.kGameRecordToggle =  this.transform:FindChild("Options/Option_1").gameObject:GetComponent("UIToggle"); 																																																													
	this.mono:AddClick(this.kGameRecordToggle.gameObject, this.OnShowGameRecordView,this)																																																													
																																																													
																																																													
	this.mono:AddClick(this.transform:FindChild("Options/Option_3").gameObject, this.OnShowGameHonorView,this)																																																													
	this.transform:FindChild("Offset/Avatars/Module_hornor").gameObject:SetActive(false)																																																													
	--131没黄金排行数据																																																													
	if(PlatformGameDefine.playform:GetPlatformPrefix()=="131" or isCloseGold) then																																																													
		this.transform:FindChild("Options/Option_3").gameObject:SetActive(false)																																																													
		this.transform:FindChild("Options/Option_1").gameObject:SetActive(false)																																																													
		local optionsAnchortarget=this.transform:FindChild("Options").gameObject:GetComponent("UIWidget");																																																													
	  	optionsAnchortarget.leftAnchor.absolute = 340;																																																													
																																																													
	end																																																													
	 																																																													
	this.mono:AddClick(this.transform:FindChild("Offset/Avatars/info/infoIcon/iconBg").gameObject, this.OnIconBg,this)																																																													
																																																														
	this.mono:AddClick(this.transform:FindChild("Offset/Avatars/info/infoIcon/Up").gameObject, this.OnInfoIconUp,this) 																																																													
																																																														
																																																														
																																																														
	this.mono:AddClick(this.transform:FindChild("Offset/Avatars/info/infoText/Text_gold/BagMoney/AddMoney").gameObject, this.OnAddMoney,this)																																																													
																																																														
	this.vipBtn = this.transform:FindChild("Offset/Avatars/info/infoText/Text_member/btn_VIP").gameObject																																																													
	this.mono:AddClick(this.vipBtn, this.OnBtn_VIP,this)																																																													
																																																														
	this.mono:AddClick(this.transform:FindChild("Offset/Avatars/info/infoText/btn_Safety").gameObject, this.OnBtn_Safety,this)																																																													
																																																													
																																																													
																																																													
	this.mono:AddClick( this.m_AccountSecurityEmail:FindChild("Views/Validation/btnEmail").gameObject,function ( ) 																																																													
		--获取邮箱验证码																																																													
		if this.m_Email.value ~= "" then 																																																													
			this:send_email_code(1,this.m_Email.value,function() 																																																													
			end) 																																																													
		 end																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_AccountSecurityEmail:FindChild("Views/Button_Submit").gameObject,function ( ) 																																																													
		--发送绑定邮箱请求																																																													
		if this.m_EmailValidation.value ~= "" then  																																																													
			this:bind_email(1,this.m_Email.value,this.m_EmailValidation.value,function() 																																																													
				this.m_AccountSecurityEmail.gameObject:SetActive(false);																																																													
			end)  																																																													
		 end																																																													
	end )																																																													
	this.mono:AddClick( this.m_AccountSecurityEmail:FindChild("btn_back").gameObject,function ( ) 																																																													
		this.m_Email.value = ''																																																													
		this.m_EmailValidation.value = ''																																																													
	end )																																																													
    --bankphone 银行手机绑定																																																													
    this.mono:AddClick( this.m_BankPhoneBindPanel.transform:FindChild("Views/Validation/btnMobilePhone").gameObject,this.OnBankPhoneBindCode)																																																													
    this.mono:AddClick( this.m_BankPhoneBindPanel.transform:FindChild("Views/Button_Submit").gameObject,this.OnPhoneBindHandle)																																																													
    this.mono:AddClick( this.m_BankPhoneUnBindPanel.transform:FindChild("Views/Validation/btnMobilePhone").gameObject,this.OnBankPhoneUnBindCode)																																																													
    this.mono:AddClick( this.m_BankPhoneUnBindPanel.transform:FindChild("Views/Button_Submit").gameObject,this.OnPhoneUnBindHandle)																																																													
    this.mono:AddClick(this.m_BankPhoneUnBindBtn,this.OnShowPhoneUnBind)																																																													
    this.mono:AddClick( this.m_AccountSecurityMobilePhone:FindChild("Views/Validation/btnMobilePhone").gameObject,function ( )																																																													
		--获取手机验证码																																																													
		if this.m_MobilePhone.value ~= "" then 																																																													
			this:send_phone_code(1,this.m_MobilePhone.value,function()  																																																													
				end)   																																																													
		 end																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_AccountSecurityMobilePhone:FindChild("Views/Button_Submit").gameObject,function ( ) 																																																													
		--发送绑定手机请求																																																													
		--获取手机验证码 																																																													
		if this.m_MobilePhoneValidation.value ~= "" then 																																																													
			this:bind_phone(1,this.m_MobilePhone.value,this.m_MobilePhoneValidation.value,function()  																																																													
					this.m_AccountSecurityMobilePhone.gameObject:SetActive(false);																																																													
				end )																																																													
		 end																																																													
	end )																																																													
	this.mono:AddClick( this.m_AccountSecurityMobilePhone:FindChild("btn_back").gameObject,function ( ) 																																																													
		this.m_MobilePhone.value = ''																																																													
		this.m_MobilePhoneValidation.value = ''																																																													
	end ) 																																																													
																																																														
																																																														
	this.mono:AddClick( this.m_AccountSecurityMobileidentity:FindChild("Views/Button_Submit").gameObject,function ( ) 																																																													
		--发送绑定身份证请求																																																													
																																																															
		 if this.m_Mobileidentity.value ~= "" then 																																																													
			EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
			this.mono:Request_lua_fun("AccountService/safe_cert", cjson.encode( {cert_no=this.m_Mobileidentity.value} ),																																																													
			function(result)																																																													
				 EginProgressHUD.Instance:ShowPromptHUD("认证成功");																																																													
				 this.m_AccountSecurityMobileidentity.gameObject:SetActive(false);																																																													
				 this:InitInfo() 																																																													
			end, 																																																													
			function(result) 																																																													
				EginProgressHUD.Instance:ShowPromptHUD("认证失败");  																																																													
			end); 																																																													
		 end																																																													
		 																																																													
	end )																																																													
	this.mono:AddClick( this.m_AccountSecurityMobileidentity:FindChild("btn_back").gameObject,function ( ) 																																																													
		this.m_MobileidentityName.value = ''																																																													
		this.m_Mobileidentity.value = ''																																																													
	end ) 																																																													
																																																														
																																																													
	this.mono:AddClick( this.m_ChangePassword:FindChild("Views/btnPhone").gameObject,function ( ) 																																																													
		--手机修改密码																																																													
		if  EginUser.Instance.phone ~= "" then 																																																													
			--已经绑定了																																																													
			this.m_MailChangePassword = 0;																																																													
			this:AnimatorChangePassword2(this.m_ChangePassword2) 																																																													
		else																																																													
			--未绑定																																																													
			this:showChangePasswordTips(this.m_ChangePasswordTips,this.m_ChangePasswordTipsLabel,"您没有绑定手机,无法进行该操作.");																																																													
			  																																																													
		end																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_ChangePassword:FindChild("Views/btnEmail").gameObject,function ( ) 																																																													
		--邮箱修改密码																																																													
		if   EginUser.Instance.email ~= ""  then 																																																													
			--已经绑定了																																																													
			this.m_MailChangePassword = 1;																																																													
			this:AnimatorChangePassword2(this.m_ChangePassword2)																																																													
		else																																																													
			--未绑定																																																													
			this:showChangePasswordTips(this.m_ChangePasswordTips,this.m_ChangePasswordTipsLabel,"您没有绑定邮箱,无法进行该操作.");																																																													
			  																																																													
		end																																																													
	end )																																																													
	 																																																													
	this.mono:AddClick( this.m_ChangePassword2:FindChild("Views/Validation/btnValidation").gameObject,function ( ) 																																																													
		--获取邮箱或者手机的验证码																																																													
		 this:ChangePasswordCharcode(this.m_MailChangePassword,function ( )   end)  																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_ChangePassword2:FindChild("Views/Button_Submit").gameObject,function ( ) 																																																													
		--发送修改密码请求																																																													
		if this.m_ChangePasswordNewPassword.value ~= "" then																																																													
			this:ChangePassword(this.m_MailChangePassword,function ( )  																																																													
				this.m_ChangePasswordValidation.value = ''																																																													
				this.m_ChangePasswordNewPassword.value = ''																																																													
			end,this.m_ChangePasswordValidation.value,this.m_ChangePasswordNewPassword.value) 																																																													
		end																																																													
		 																																																													
	end )																																																													
	this.mono:AddClick( this.m_ChangePassword2:FindChild("btn_back").gameObject,function ( ) 																																																													
		this.m_ChangePasswordValidation.value = ''																																																													
		this.m_ChangePasswordNewPassword.value = ''																																																													
	end ) 																																																													
																																																														
	 																																																													
	-----------解绑-------------																																																													
	this.mono:AddClick( this.m_MobileEmailbtn1,function ( )  																																																													
		this.m_MailChangePassword = 1;																																																													
		local animation = this.m_unbundlingPhone.gameObject:GetComponent("Animator")																																																													
		this.m_unbundlingPhone.gameObject:SetActive(true)																																																													
		animation.enabled = true;																																																													
		animation:Play("FrameShowAnimation")																																																													
																																																															
		this.m_unbundlingTitle.spriteName = "UNbunding_mail_title";																																																													
		this.m_unbundlingLabe.text = "邮 箱 :" 																																																													
		this.m_unbundlingVLabe.text = EginUser.Instance.email																																																													
	end ) 																																																													
																																																														
	this.mono:AddClick( this.m_MobilePhonebtn1,function ( )  																																																													
		this.m_MailChangePassword = 0; 																																																													
		this.m_unbundlingPhone.gameObject:SetActive(true)																																																													
		local animation = this.m_unbundlingPhone.gameObject:GetComponent("Animator")																																																													
		 this.m_unbundlingPhone.localPosition = Vector3.New(9999,0,0)																																																													
		 coroutine.start(this.AfterDoing,this,0, function() 																																																													
			animation.enabled = true;																																																													
			animation:Play("FrameShowAnimation")																																																													
		end); 																																																													
																																																															
		this.m_unbundlingTitle.spriteName = "UNbunding_phone_title";																																																													
		this.m_unbundlingLabe.text = "手机号 :" 																																																													
		this.m_unbundlingVLabe.text = EginUser.Instance.phone																																																													
	end ) 																																																													
																																																														
	 																																																													
	this.mono:AddClick( this.m_unbundlingPhone:FindChild("Views/Validation/btnMobilePhone").gameObject,function ( )  																																																													
		if this.m_MailChangePassword == 0 then   																																																													
			this:send_phone_code(0, EginUser.Instance.phone,function()   end)     																																																													
		else 																																																													
			this:send_email_code(0,EginUser.Instance.email,function()  end)  																																																													
		end 																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_unbundlingPhone:FindChild("Views/Button_Submit").gameObject,function ( )  																																																													
		--发送解绑请求																																																													
		if this.m_unbundlingVInput.value ~= "" then 																																																													
			if this.m_MailChangePassword == 0 then 																																																													
				this:bind_phone(0, EginUser.Instance.phone,this.m_unbundlingVInput.value,function() 																																																													
					this.m_unbundlingPhone.gameObject:SetActive(false)																																																													
				end)																																																													
			else																																																													
				this:bind_email(0,EginUser.Instance.email,this.m_unbundlingVInput.value,function()																																																													
					this.m_unbundlingPhone.gameObject:SetActive(false) 																																																													
				end)    																																																													
			end 																																																													
		end																																																													
		 																																																													
	end )																																																													
	this.mono:AddClick( this.m_unbundlingPhone:FindChild("btn_back").gameObject,function ( )  																																																													
		this.m_unbundlingVInput.value = ''																																																													
	end ) 																																																													
																																																														
																																																														
																																																														
																																																														
	-------------------------帐号安全中的二级界面------------------ 																																																													
	this.mono:AddClick(this.m_safetyLwBtn,function ( ) 																																																													
		--微信找回																																																													
		if this.m_safetyLwLab.value ~= "" then 																																																													
			EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
			this.mono:Request_lua_fun("AccountService/reg_wechat", cjson.encode( {wechat=this.m_safetyLwLab.value,username=EginUser.Instance.username} ),																																																													
			function(result)																																																													
				 EginProgressHUD.Instance:ShowPromptHUD("发送成功");																																																													
				 this.m_safetyLwLab.value = ""																																																													
				 this:InitInfo() 																																																													
			end, 																																																													
			function(result) 																																																													
																																																																	
			end); 																																																													
		 end																																																													
	end ) 																																																													
	this.mono:AddClick(this.m_safetyLqBtn,function ( ) 																																																													
		--QQ找回																																																													
		if this.m_safetyLqLab.value ~= "" then 																																																													
			EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
			this.mono:Request_lua_fun("AccountService/reg_qq", cjson.encode( {qq=this.m_safetyLqLab.value,username=EginUser.Instance.username} ),																																																													
			function(result)																																																													
				 EginProgressHUD.Instance:ShowPromptHUD("发送成功");																																																													
				 this.m_safetyLqLab.value = ""																																																													
				 this:InitInfo() 																																																													
			end, 																																																													
			function(result)  																																																													
			end); 																																																													
		 end																																																													
	end ) 																																																													
	--绑定																																																													
	this.mono:AddClick( this.m_AccountSecurityMobilePhone2:FindChild("Views/Validation/btnMobilePhone").gameObject,function ( ) 																																																													
		--获取手机验证码																																																													
		if this.m_MobilePhone2.value ~= "" then 																																																													
			this:send_phone_code(1,this.m_MobilePhone2.value,function()  																																																													
				end)   																																																													
		 end																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_AccountSecurityMobilePhone2:FindChild("Views/Button_Submit").gameObject,function ( ) 																																																													
		--发送绑定手机请求																																																													
		--获取手机验证码 																																																													
		if this.m_MobilePhoneValidation2.value ~= "" then 																																																													
			this:bind_phone(1,this.m_MobilePhone2.value,this.m_MobilePhoneValidation2.value,function()  																																																													
					this.m_AccountSecurityMobilePhone2.gameObject:SetActive(false);																																																													
					this.m_safetyAS.gameObject:SetActive(false)																																																													
				end )																																																													
		 end																																																													
	end )																																																													
	this.mono:AddClick( this.m_AccountSecurityMobilePhone2:FindChild("btn_back").gameObject,function ( ) 																																																													
		this.m_MobilePhone2.value = ''																																																													
		this.m_MobilePhoneValidation2.value = ''																																																													
	end ) 																																																													
																																																														
	 --解绑																																																													
	this.mono:AddClick( this.m_unbundlingPhone2:FindChild("Views/Validation/btnMobilePhone").gameObject,function ( )  																																																													
		this.m_MailChangePassword = 0;																																																													
		if this.m_MailChangePassword == 0 then   																																																													
			this:send_phone_code(0, EginUser.Instance.phone,function()   end)     																																																													
		else 																																																													
			this:send_email_code(0,EginUser.Instance.email,function()  end)  																																																													
		end 																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_unbundlingPhone2:FindChild("Views/Button_Submit").gameObject,function ( )  																																																													
		--发送解绑请求																																																													
		if this.m_unbundlingVInput2.value ~= "" then 																																																													
			this.m_MailChangePassword = 0;																																																													
			if this.m_MailChangePassword == 0 then 																																																													
				this:bind_phone(0, EginUser.Instance.phone,this.m_unbundlingVInput2.value,function() 																																																													
					this.m_unbundlingPhone2.gameObject:SetActive(false) 																																																													
					this.m_safetyAS.gameObject:SetActive(false)																																																													
				end)																																																													
			else																																																													
				this:bind_email(0,EginUser.Instance.email,this.m_unbundlingVInput2.value,function()																																																													
					this.m_unbundlingPhone2.gameObject:SetActive(false) 																																																													
					this.m_safetyAS.gameObject:SetActive(false) 																																																													
				end)    																																																													
			end 																																																													
		end																																																													
		 																																																													
	end )																																																													
	this.mono:AddClick( this.m_unbundlingPhone2:FindChild("btn_back").gameObject,function ( )  																																																													
		this.m_unbundlingVInput2.value = ''																																																													
	end ) 																																																													
																																																														
																																																														
	--修改密码																																																													
	this.mono:AddClick( this.m_ChangePasswordS1:FindChild("Views/btnPhone").gameObject,function ( ) 																																																													
		--手机修改密码																																																													
		if  EginUser.Instance.phone ~= "" then 																																																													
			--已经绑定了																																																													
			this.m_MailChangePassword = 0;																																																													
			this:AnimatorChangePassword2(this.m_ChangePasswordS2) 																																																													
		else																																																													
			--未绑定																																																													
			this:showChangePasswordTips(this.m_ChangePasswordTips2,this.m_ChangePasswordTipsLabel2,"您没有绑定手机,无法进行该操作.");																																																													
			  																																																													
		end																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_ChangePasswordS1:FindChild("Views/btnEmail").gameObject,function ( ) 																																																													
		--邮箱修改密码																																																													
		if   EginUser.Instance.email ~= ""  then 																																																													
			--已经绑定了																																																													
			this.m_MailChangePassword = 1;																																																													
			this:AnimatorChangePassword2(this.m_ChangePasswordS2)																																																													
		else																																																													
			--未绑定																																																													
			this:showChangePasswordTips(this.m_ChangePasswordTips2,this.m_ChangePasswordTipsLabel2,"您没有绑定邮箱,无法进行该操作.");																																																													
			  																																																													
		end																																																													
	end )																																																													
	 																																																													
	this.mono:AddClick( this.m_ChangePasswordS2:FindChild("Views/Validation/btnValidation").gameObject,function ( ) 																																																													
		--获取邮箱或者手机的验证码																																																													
		 this:ChangePasswordCharcode(this.m_MailChangePassword,function ( )   end)  																																																													
	end ) 																																																													
	this.mono:AddClick( this.m_ChangePasswordS2:FindChild("Views/Button_Submit").gameObject,function ( ) 																																																													
		--发送修改密码请求																																																													
		if this.m_ChangePasswordNewPassword2.value ~= "" then																																																													
			this:ChangePassword(this.m_MailChangePassword,function ( )  																																																													
				this.m_ChangePasswordValidation2.value = ''																																																													
				this.m_ChangePasswordNewPassword2.value = ''																																																													
			end,this.m_ChangePasswordValidation2.value,this.m_ChangePasswordNewPassword2.value) 																																																													
		end																																																													
		 																																																													
	end )																																																													
	this.mono:AddClick( this.m_ChangePasswordS2:FindChild("btn_back").gameObject,function ( ) 																																																													
		this.m_ChangePasswordValidation2.value = ''																																																													
		this.m_ChangePasswordNewPassword2.value = ''																																																													
	end ) 																																											
	--]]																																																													
end																																																													
function this:OnIconBg() 																																																													
	--更换头按钮																																																													
	this.GirlBoyAllArr[EginUser.Instance.avatarNo].value = true																																																													
	  this.isUpdateAvatar = false																																																													
end																																																													
function this:OnInfoIconUp() 																																																													
	--升级帐号按钮 																																																													
	 if  this.module_ConvertRegister == nil then																																																													
		 local ModulePrefab = ResManager:LoadAsset("happycity/Module_ConvertRegister","Module_ConvertRegister");																																																													
		this.module_ConvertRegister = GameObject.Instantiate(ModulePrefab); 																																																													
		this.module_ConvertRegister.name = "Module_ConvertRegister"																																																													
		this.module_ConvertRegister.transform.parent = this.transform;																																																													
		this.module_ConvertRegister.transform.localScale = Vector3(1,1,1);																																																													
		this.module_ConvertRegister.transform.localPosition = Vector3(0,0,0); 																																																													
	 end																																																													
	-- this.module_ConvertRegister:SetActive(true);	
	HallUtil:PopupSecondPanel(this.module_ConvertRegister)																																																												
end																																																													
function this:OnReplace() 																																																													
	--更换帐号按钮															
	-- HallUtil:HidePanelAni(this.gameObject)																																																													
	Hall:ChangeIDBtns();																																																													
end																																																													
function this:OnAddMoney() 																																																													
	--去充值按钮																																																													
end																																																													
function this:OnBtn_VIP() 																																																													
	--成为vip按钮																																																													
end																																																													
function this:OnBtn_Safety() 																																																													
	--安全按钮																																																													
end 																																																													
																																																													
																																																				
function this:OnEnable() 																																																													
	 																																																													
																																																														
end																																																													
 																																																													
 																																																													
function this:OnDisable() 																																																													
	  																																																													
end																																																													
function this:clearLuaValue()																																																													
	this.mono = nil																																																													
	this.gameObject = nil																																																													
	this.transform  = nil																																																													
	 this.ui_headsGrid = nil																																																													
	--this.vBoy = nil;																																																													
	--this.vGirl = nil																																																													
	this.kAvatarPrefab = nil;																																																													
	this.GirlBoyAllArr = nil;																																																													
	 this.module_ConvertRegister = nil;																																																													
	this:GameRecordClearLuaValue()																																																													
	LuaGC()																																																													
end																																																													
																																																													
function this:OnDestroy()																																																													
	this:clearLuaValue()																																																													
end 																																																													
 function this:Process_account_login(info) 																																																													
end																																																													
function this:OnClickBack ()  																																																													
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);																																																													
        Utils.LoadLevelGUI("Hall");																																																													
end																																																													
function this:OnSelfPanelShow()  																																																													
	local vConfirm = this.gameObject:GetComponent("Animator") 																																																													
	 this.transform:GetComponent("UIPanel").depth = -1; 																																																													
																																																														
	coroutine.start(this.AfterDoing,this,0, function()																																																													
		this.transform:GetComponent("UIPanel").depth = 1;																																																														
		 vConfirm.enabled = true; 																																																													
		vConfirm:Play("LeftShowAnimation")																																																													
		vConfirm:Update(0); 																																																													
	end);																																																													
end																																																													
function this:OnClickUpdateAvatar()																																																													
	if PlatformGameDefine.playform.IsSocketLobby then 																								
		this:SocketUpdateAvatar();																																																													
	else 																										
		coroutine.start(this.DoOnClickUpdateAvatar,this)																																																													
	end																																																													
end																																																													
function this:DoOnClickUpdateAvatar () 																																																													
	local selectedToggle = UIToggle.GetActiveToggle(AVATAR_GROUP);																																																													
	if (selectedToggle ~= nil) then																																																													
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
																																																													
		local aid = selectedToggle.gameObject.name;																																																													
																																																													
		local form = UnityEngine.WWWForm.New();																																																													
		form:AddField("aid", aid);																																																													
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.USERINFO_AVATAR_URL, form);																																																													
		coroutine.www(www);																																																																																										
		local result = HttpConnect.Instance:BaseResult(www);																																																													
		EginProgressHUD.Instance:HideHUD();																																																													
		if(HttpResult.ResultType.Sucess == result.resultType)  then																																																													
			this:UpdateAvatarSucess(aid);																																																													
			EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"),0.5);																																																													
		else 																																																													
			EginProgressHUD.Instance:ShowPromptHUD(result.resultObject,0.5);																																																													
		end																																																													
	end																																																													
end																																																													
--更换头像 																																																													
function this:LoadAvatars () 																																																													
	local userAvatarNo = EginUser.Instance.avatarNo;																																																													
	for i=0,19 do																																																													
		local avatar =  GameObject.Instantiate(this.ui_ChooseHeadTemplate);																																																													
		avatar.name = tostring(i);																																																													
		avatar.transform.parent =  this.ui_headsGrid.transform 																										
		avatar:SetActive(true)																																																																																																
		avatar.transform.localScale = Vector3.one;																																																																																																																																		
		local sprite = avatar.transform:GetComponent("UISprite");																																																													
		sprite.spriteName = "avatar_"..i;																																																																																															
		this.mono:AddClick(avatar, this.OnClickAvatar,this)																																																													
		--this.GirlBoyAllArr[i] = checkbox;																																																													
	end																																																													
	 this.ui_headsGrid:GetComponent("UIGrid").repositionNow = true						 																																																														 																							
end																																																													
function this:OnClickAvatar (avatar)   																																																																																														
	if  not this.isUpdateAvatar  then 																																																													
		 this.isUpdateAvatar = true																																																													
		this:OnClickUpdateAvatar()																																																													
	end 																																																													
end																																																													
function this:UpdateAvatarSucess (aid) 																																																													
	EginUser.Instance:UpdateAvatarNo(tonumber(aid));																																																													
end																																																													
																																																													
function this:SocketUpdateAvatar()																																																													
	local selectedToggle = UIToggle.GetActiveToggle(AVATAR_GROUP);																																																													
	if (selectedToggle ~= nil) then																																																													
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
		local aid = selectedToggle.gameObject.name;																																																													
		this.mono:Request_lua_fun("AccountService/avatar_modify", cjson.encode( {aid=tonumber(aid)} ),																																																													
		function(result)																																																													
			this:UpdateAvatarSucess(aid);																																																													
			EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"),0.5);																																																													
			this.ui_headIcon.spriteName = "avatar_" .. EginUser.Instance.avatarNo;  																							
			-- HallUtil:HidePanelAni(this.ui_changeHeadPanel)																								
			Hall:RefreshUserInfo()																																																																																												
			this.isUpdateAvatar = false																																																													
		end, 																																																													
		function(result)																																																													
			this.isUpdateAvatar = false																																																													
				if (result~= null) then  EginProgressHUD.Instance:ShowPromptHUD(result,0.5); 	 end																																																													
		end); 																																																													
	end																																																													
end 																																																													
																																																													
function this:AnimatorChangePassword2(passwordObj)																																																													
	--[[																																																													
	local animation = passwordObj.gameObject:GetComponent("Animator")																																																													
	passwordObj.gameObject:SetActive(true)																																																													
	animation.enabled = true;																																																													
	animation:Play("FrameShowAnimation")																																																													
	]]																																																													
	 																																																													
	passwordObj.gameObject:SetActive(true)																																																													
	local animation = passwordObj.gameObject:GetComponent("Animator")																																																													
	passwordObj.localPosition = Vector3.New(9999,0,0)																																																													
	 coroutine.start(this.AfterDoing,this,0, function() 																																																													
		animation.enabled = true;																																																													
		animation:Play("FrameShowAnimation")																																																													
	end); 																																																													
																																																														
end 																																																													
function this:showChangePasswordTips(tipsObj,tipsLabel,text)																																																													
	if not  tipsObj.activeSelf then																																																													
		tipsObj:SetActive(true)																																																													
		tipsLabel.text = text																																																													
		coroutine.start(this.AfterDoing,this,2.3, function()																																																													
			tipsObj:SetActive(false) 																																																													
		end); 																																																													
	end																																																													
end 																																																													
 function this:Change_Sex()																																																													
	this.genderSexIncome = true;																																																													
	coroutine.start(this.AfterDoing,this,1, function()  																																																													
		if this.genderSexIncome then																																																													
			this.genderSexIncome = false;																																																													
			this.mono:Request_lua_fun("AccountService/change_sex", cjson.encode( {sex=EginUser.Instance.sex} ),																																																													
			function(result) 																							
				this:refreshSex(EginUser.Instance.sex)																																																										
			end, 																																																													
			function(result)  																																																													
			end); 																																																													
		end 																																																													
	end); 																																																													
 end																																																													
---------------------安全相关请求-------------------																																																														
function this:send_email_code(typeSend,v_email,tempFun)																																																													
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
	this.mono:Request_lua_fun("AccountService/send_email_code", cjson.encode( {email=v_email,type=typeSend} ),																																																													
	function(result)																																																													
		 EginProgressHUD.Instance:ShowPromptHUD("已发送验证码,请注意查收!",0.5); 																																																													
		 tempFun();																																																													
	end, 																																																													
	function(result) 																																																													
		if(result ~= nil)then																																																													
			EginProgressHUD.Instance:ShowPromptHUD(System.Text.RegularExpressions.Regex.Unescape(result)); 																																																													
		else																																																													
			EginProgressHUD.Instance:ShowPromptHUD("获取验证码失败!",0.5);																																																													
		end																																																													
	end); 																																																													
end																																																													
function this:bind_email(typeSend,v_email,v_charcode,tempFun)																																																													
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
	this.mono:Request_lua_fun("AccountService/bind_email", cjson.encode( {charcode=v_charcode,email=v_email,type=typeSend} ),																																																													
	function(result)																																																													
		 if typeSend == 1 then																																																													
			EginProgressHUD.Instance:ShowPromptHUD("绑定成功",0.5); 																																																													
			EginUser.Instance.email= v_email 																																																													
		else																																																													
			EginProgressHUD.Instance:ShowPromptHUD("解绑成功",0.5); 																																																													
			EginUser.Instance.email= "" 																																																													
		end 																																																													
		   																																																													
		 tempFun();																																																													
		 this:InitInfo(true) 																																																													
		this:isTouristInit()																																																													
	end, 																																																													
	function(result) 																																																													
		if(result ~= nil)then																																																													
			EginProgressHUD.Instance:ShowPromptHUD(System.Text.RegularExpressions.Regex.Unescape(result)); 																																																													
		else																																																													
			EginProgressHUD.Instance:ShowPromptHUD("网络连接失败!",0.5);																																																													
		end																																																													
	end); 																																																													
end																																																													
function this:send_phone_code(typeSend,v_phone,tempFun)																																																													
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
	this.mono:Request_lua_fun("AccountService/send_phone_code1", cjson.encode( {mobile=v_phone,type=typeSend} ),																																																													
	function(result)																																																													
		 EginProgressHUD.Instance:ShowPromptHUD("已发送验证码,请注意查收!",0.5); 																																																													
		 tempFun();																																																													
	end, 																																																													
	function(result) 																																																													
		EginProgressHUD.Instance:ShowPromptHUD(result);  																																																													
	end); 																																																													
end																																																													
function this:bind_phone(typeSend,v_phone,v_charcode,tempFun)																																																													
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
	this.mono:Request_lua_fun("AccountService/bind_phone", cjson.encode( {charcode=v_charcode,phone=v_phone,type=typeSend} ),																																																													
	function(result)																																																													
		if typeSend == 1 then																																																													
			EginProgressHUD.Instance:ShowPromptHUD("绑定成功",0.5);																																																													
			EginUser.Instance.phone= v_phone																																																													
            EginUser.bindPhone = 1																																																													
			--渠道处理																																																													
			Module_Channel.Instance:handleBindPhoneGetAccount()																																																													
		else																																																													
			EginProgressHUD.Instance:ShowPromptHUD("解绑成功",0.5);																																																													
			EginUser.Instance.phone= ""																																																													
            EginUser.bindPhone = 0																																																													
		end  																																																													
		 tempFun(); 																																																													
																																																															
		 this:InitInfo(true)																																																													
																																																													
		 this:isTouristInit()																																																													
         this:OnShowSafetyTabToggleView()																																																													
	end, 																																																													
	function(result) 																																																													
		--{'body': '', 'tag': 'bind_phone', 'type': 'AccountService', 'result': '\x8822b\xe6\x9c\xba!'} 																																																													
		if(result ~= nil)then																																																													
			EginProgressHUD.Instance:ShowPromptHUD(System.Text.RegularExpressions.Regex.Unescape(result)); 																																																													
		else																																																													
			EginProgressHUD.Instance:ShowPromptHUD("网络连接失败!",0.5);																																																													
		end																																																													
	end); 																																																													
end																																																													
--------------------------------------------bankphone绑定手机银行---------------------------------------																																																													
function this:OnShowSafetyTabToggleView()																																																													
    --微信绑定ui																																																														
    this.ui_safeBindWxBtn:SetActive(false)										
	this.ui_safeUnBindWxBtn:SetActive(false)	
	this.ui_safeNowWxLabel.gameObject:SetActive(false)			
	--微信绑定银行
    if EginUser.wechat_lock == 0 then
    	this.ui_BankBindPhoneBtn:SetActive(true)
    	this.ui_BankUnBindPhoneBtn:SetActive(false)
    else 
		this.ui_BankBindPhoneBtn:SetActive(false)
    	this.ui_BankUnBindPhoneBtn:SetActive(true)
    end
    --微信绑定账号																																																													
 	if EginUser.Instance.wechat =='' then 
 		this.ui_safeNowWxLabel.text = '未绑定'	
 		this.ui_safeBindWxBtn:SetActive(true)
 		this.ui_safeUnBindWxBtn:SetActive(false)																																																											
    else																																																													
     	this.ui_safeUnBindWxBtn:SetActive(true)	
     	this.ui_safeBindWxBtn:SetActive(false)																																																																
    end		


	if EginUser.Instance.wxNickname == "" then																																																													
		this.ui_safeNowWxLabel.text = "未绑定"												
	else																																																													
		this.ui_safeNowWxLabel.text = EginUser.Instance.wxNickname																																																													
	end																																																														
    --银行绑定ui																																																													
    if(EginUser.bindPhone == 0)then																																																													
       -- this.m_safetyPLab.text = "未绑定"																																																													
        --this.m_BankPhoneGroup:SetActive(false)																																																													
    else																																																													
        --this.m_BankPhoneGroup:SetActive(true)																																																													
        if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE) then																																																													
          --  this.m_BankPhoneBindBtn:SetActive(false)																																																													
           -- this.m_BankPhoneUnBindBtn:SetActive(true)																																																													
           -- this.m_BankPhoneNumLabel.text = ShowFrontEndThree(EginUser.phone)																																																													
        else																																																													
           -- this.m_BankPhoneBindBtn:SetActive(true)																																																													
           -- this.m_BankPhoneUnBindBtn:SetActive(false)																																																													
            --this.m_BankPhoneNumLabel.text = "未绑定"																																																													
        end																																																													
        --this.m_safetyPLab.text = ShowFrontEndThree(EginUser.phone)																																																													
    end																																																													
																																																													
    -- 邮箱		
    if  EginUser.Instance.email  == '' then	
        this.ui_safeLockBtn:SetActive(true)																																																													
    	this.ui_safeUnLockBtn:SetActive(false)																																																													
    else						
        this.ui_safeLockBtn:SetActive(false)																																																													
    	this.ui_safeUnLockBtn:SetActive(true)																																																													
    end																																																													
    local tLockStr = "未锁定"																																																													
    if EginUser.Instance.device_lock == 1 then																																																													
        tLockStr = "已锁定"																																																													
    end																																																													
    this.ui_safeNowLockLabel.text = tLockStr																																																													
end																																																													
--获取绑定验证码																																																													
function this:OnBankPhoneBindCode()																																																													
    this:sendBankPhoneCode(1,EginUser.phone)																																																													
end																																																													
function this:OnPhoneBindHandle()																																																													
    this.m_BankPhoneBindPanel.transform:FindChild("btn_back").gameObject:SendMessage("OnClick")																																																													
    -->{"type":"AccountService","tag":"bank_bind_phone","body":{'action': 操作类型，"adbank"表示绑定手机 'nobank'表示解绑手机银行登录}}																																																													
    --<--{"type":"AccountService","tag":"bank_bind_phone","result":'ok' --成功ok ,失败为说明"body": ''		}																																																													
    local tInputValue =  this.transform:FindChild("BankphonePanel/Grid/nickLabel/bg/input").gameObject:GetComponent("UIInput").value																																																														
    if string.len(tInputValue)>=6 then																																																													
        local messageBody = {action= "adbank"};																																																													
        messageBody["password"] = tInputValue																																																													
        local jsonStr = cjson.encode({type="AccountService",tag="bank_bind_phone",body = messageBody});																																																													
        BaseSceneLua.socketManager:SendPackage(jsonStr);																																																													
    else																																																													
        EginProgressHUD.Instance:ShowPromptHUD("验证码错误!",0.5);																																																													
    end																																																													
    --error("OnPhoneBindHandle");																																																													
end																																																													
--初始化解绑面板																																																													
function this:OnShowPhoneUnBind()																																																													
    this.m_BankPhoneUnBindPanel.transform:FindChild("Views/PhoneNum/LabelPhone").gameObject:GetComponent("UILabel").text = ShowFrontEndThree(EginUser.phone)																																																													
end																																																													
function this:OnPhoneUnBindHandle()																																																													
    local tInputValue =  this.transform:FindChild("BankphonePanel/Grid/nickLabel/bg/input").gameObject:GetComponent("UIInput").value																																																													
    -- this.m_BankPhoneUnBindPanel.transform:FindChild("btn_back").gameObject:SendMessage("OnClick")																																																													
    if string.len(tInputValue)>=6 then																																																													
        local messageBody = {action= "nobank"};																																																													
        messageBody["password"] = tInputValue																																																													
        local jsonStr = cjson.encode({type="AccountService",tag="bank_bind_phone",body = messageBody});																																																													
        BaseSceneLua.socketManager:SendPackage(jsonStr);																																																													
    else																																																													
        EginProgressHUD.Instance:ShowPromptHUD("验证码错误!",0.5);																																																													
    end																																																													
    --error("OnPhoneUnbindHandle");																																																													
end																																																													
--获取解绑验证码																																																													
function this:OnBankPhoneUnBindCode()																																																													
    this:sendBankPhoneCode(0,EginUser.phone)																																																													
end																																																													
																																																													
--银行手机绑定验证码																																																													
function this:sendBankPhoneCode(typeSend,v_phone)																																																													
    -- EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);																																																													
    this.mono:Request_lua_fun("AccountService/send_bank_bind_code", cjson.encode( {mobile=v_phone,type=typeSend} ),																																																													
        function(result)																																																													
            EginProgressHUD.Instance:ShowPromptHUD("已发送验证码,请注意查收!",0.5);																																																													
            --tempFun();																																																													
        end,																																																													
        function(result)																																																													
            EginProgressHUD.Instance:ShowPromptHUD(result,0.5);																																																													
        end);																																																													
end																																																													
-------------------------------------------------------------------------------------------------																																																													
																																																													
																																																													
--锁机功能--------------------------------------------																																																													
function this:OnClickLockDevice()																																																													
    this:sendLockRequest(1)																																																													
end																																																													
function this:OnClickUnLockDevice()																																																													
    this:sendLockRequest(0)																																																													
end																																																													
--发送锁机请求 0 解绑 1绑定																																																													
function this:sendLockRequest(pIsLock)																																																													
    local tDeviceID = "unity_" .. UnityEngine.SystemInfo.deviceUniqueIdentifier																																																													
    local messageBody = { }																																																													
    messageBody["lock"] = pIsLock																																																													
    messageBody["lockid"] = tDeviceID																																																													
    local jsonStr = cjson.encode({type="AccountService",tag="lock_account",body = messageBody});																																																													
    BaseSceneLua.socketManager:SendPackage(jsonStr);																																																													
end																																																													
																																																													
-----------------------------------------------------																																																													
--元宝商城																																																													
function this:OnClickYbShop()																																																													
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);																																																													
    if(EginUser.Instance.isGuest)then																																																													
        Utils.LoadLevelGUI("Register");																																																													
    else																																																													
        Utils.LoadLevelGUI("Module_YBShop");																																																													
    end																																																													
end																																																													
																																																													
--																																																													
function this:ChangePasswordCharcode(typeChange,messageFun) 																																																													
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);																																																													
		this.mono:Request_lua_fun("AccountService/send_pe_code", cjson.encode( {ctype=typeChange} ), 																																																													
			function(message) 																																																													
			EginProgressHUD.Instance:ShowPromptHUD("验证码已发送!",0.5);																																																													
			 messageFun();																																																													
			end, 																																																													
			function(message)																																																													
				EginProgressHUD.Instance:ShowPromptHUD("网络连接失败!",0.5);																																																													
			end)																																																													
																																																													
end																																																													
function this:ChangePassword(typeChange,messageFun,charcodes,newpwd) 																																																													
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);																																																													
		if typeChange == 0 then																																																													
			typeChange = 2;																																																													
		end																																																													
    this.mono:Request_lua_fun("AccountService/changePwd_phoneEmail",cjson.encode( {ctype=typeChange,charcode=charcodes,new_pwd = newpwd} ), 																																																													
        function(message) 																																																													
		 EginProgressHUD.Instance:ShowPromptHUD("修改成功!",0.5);																																																													
		  messageFun();  																																																													
        end, 																																																													
        function(message)																																																													
            EginProgressHUD.Instance:ShowPromptHUD("网络连接失败!",0.5);																																																													
        end)																																																													
  																																																													
end																																																													
function this:InitInfo(isWait) 																																																													
																																																													
	if isWait then 																																																													
		coroutine.start(this.AfterDoing,this,2, function() 																																																													
			this:SendInfo();																																																													
		end); 																																																													
	else																																																													
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);																																																													
		this:SendInfo();																																																													
	end																																																													
  																																																													
end																																																													
function this:SendInfo() 																																																													
 this.mono:Request_lua_fun("AccountService/safe_accountInfo","", 																																																													
        function(message) 																																																													
            EginProgressHUD.Instance:HideHUD();  																																																													
		 local messages = cjson.decode(message)																																																													
		 --{"phone":"","cert_no":"","star":0,"email":""}																																																													
		EginUser.Instance.email= messages["email"] 																																																													
		EginUser.Instance.phone= messages["phone"]  																																																													
		EginUser.Instance.telephone = EginUser.Instance.phone																																																													
		EginUser.Instance.cert_no= messages["cert_no"] 																																																													
		EginUser.Instance.star= messages["star"]   																																																													
		EginUser.Instance.wechat= messages["wechat"] 																																																													
		EginUser.Instance.qq= messages["qq"]  																																																													
		this:isTouristInit()																																																													
        this:OnShowSafetyTabToggleView()							
						
        end, 																																																													
        function(message)																																																													
            EginProgressHUD.Instance:ShowPromptHUD("获取用户信息失败!",0.5);																																																													
        end)																																																													
end																																																													
function this:isTouristInit() 																																																													
--游客账号登陆时显示0星，升级为正式账号后为两星，绑定手机后为四星，绑定邮箱后为五星																																																																																							
	--是否是游客																																																													
	if EginUser.Instance.star == 0 and ProtocolHelper._LoginType == LoginType.Guest then																																																													
		--this.infoIconUp:SetActive(true);																																																													
		this.ui_infoStarBtn:GetComponent("BoxCollider").enabled=false																																																																																									
		this.ui_safeBindPhoneBtn:SetActive(false)																																																													
		this.ui_safeChangePwdBtn:SetActive(false) 																																																													
		this.ui_safeBindWxBtn:SetActive(false) 																																																																																							
		this.ui_safeLockBtn:SetActive(false)																																																													
		--this.m_safetyLwV.gameObject:SetActive(false);																																																													
		--this.m_safetyLwLab.gameObject:SetActive(true);																																																																																							
		--this.m_safetyLqBtn:SetActive(false);																																																													
		--this.m_safetyLqV.gameObject:SetActive(false);																																																													
		--this.m_safetyLqLab.gameObject:SetActive(true);																																																																																						
		this.ui_safeNowPhoneLabel.text = "未绑定"																																																																																								
		this.ui_safeNowWxLabel.text = "未绑定"																																																																																								
		this.ui_safeNowLockLabel.text = "未锁定"																
		-- this.ui_findQQLabel.text = 	"未绑定"																																																																																						
		-- this.ui_findWxLabel.text = 	"未绑定"																																																																																						
		-- this.ui_findIDCardLabel.text = 	"未绑定"																																																																																						
 		this.ui_findQQBtn:SetActive(false)																																																																																					
 																																																																																								
	else																																																													
		--this.infoIconUp:SetActive(false);																																																													
		this.ui_infoStarBtn:GetComponent("BoxCollider").enabled=true						
		this.ui_Lab_Nickname.text = EginUser.Instance.nickname			
		this.ui_Mail_IDLab.text = EginUser.Instance.nickname		
		this.ui_Pwd_NameInput.text = EginUser.Instance.nickname																																																																																							
		--this.m_safetyWBtn:SetActive(true); 																																																													
		--this.m_safetyCBtn:SetActive(true);  																																																																																							
		if EginUser.Instance.phone == "" then																																																													
			this.ui_safeNowPhoneLabel.text = "未绑定"																																																														
			this.ui_safeBindPhoneBtn:SetActive(true)															
			this.ui_safeUnBindPhoneBtn:SetActive(false)						
			this.ui_phone_PhoneBtn:SetActive(true)						
			this.ui_Lab_PhoneNum.gameObject:SetActive(false)																																																											
						
			--this.m_MobilePhonebtn1:SetActive(false);																																																													
			--this.m_MobilePhonelab.gameObject:SetActive(false);																																																																																																								
			--this.m_safetyPBtn:SetActive(true); 																																																													
			--this.m_safetyRBtn:SetActive(false); 																																																													
		else																																																														
			this.ui_safeNowPhoneLabel.gameObject:SetActive(false) --.text =  ShowFrontEndThree(EginUser.Instance.phone)																																																													
			this.ui_safeBindPhoneBtn:SetActive(false)															
			this.ui_safeUnBindPhoneBtn:SetActive(true)								
			this.ui_phone_PhoneBtn:SetActive(false)							
			this.ui_Lab_PhoneNum.gameObject:SetActive(true)																																																											
			this.ui_Lab_PhoneNum.text = ShowFrontEndThree(EginUser.Instance.phone)							
			--this.m_MobilePhonebtn:SetActive(false);																																																													
			--this.m_MobilePhonebtn1:SetActive(true);																																																													
			--this.m_MobilePhonelab.gameObject:SetActive(true);																																																													
			--this.m_safetyRBtn:SetActive(true); 																																																													
			--this.m_safetyPBtn:SetActive(false); 																																																													
			--this.m_MobilePhonelab.text = ShowFrontEndThree(EginUser.Instance.phone)																																																													
			--this.m_safetyPLab.text = ShowFrontEndThree(EginUser.Instance.phone)																																																													
			--this.m_unbundlingVLabe2.text = ShowFrontEndThree(EginUser.Instance.phone)																																																													
        end																																																													
        --print("rrrrrrrrrrrrrrrr;"..EginUser.Instance.wxNickname)																																																													
		if EginUser.Instance.wxNickname == "" then																																																													
			this.ui_safeNowWxLabel.text = "未绑定"												
		else																																																													
			this.ui_safeNowWxLabel.text = EginUser.Instance.wxNickname																																																													
		end																																																													
																																																													
		if EginUser.Instance.email == "" then 							
			this.ui_phone_MailBtn:SetActive(true)						
			this.ui_Lab_Email.gameObject:SetActive(false)						
			--this.m_MobileEmailbtn:SetActive(true);																																																													
			--this.m_MobileEmailbtn1:SetActive(false);																																																													
			--this.m_MobileEmaillab.gameObject:SetActive(false);																																																													
		else						
			this.ui_phone_MailBtn:SetActive(false)						
			this.ui_Lab_Email.gameObject:SetActive(true)						
			this.ui_Lab_Email.text = EginUser.Instance.email							
			--this.m_MobileEmailbtn:SetActive(false);																																																													
			--this.m_MobileEmailbtn1:SetActive(true);																																																													
			--this.m_MobileEmaillab.gameObject:SetActive(true);																																																													
			--this.m_MobileEmaillab.text = EginUser.Instance.email																																																													
		end																																																													
		if EginUser.Instance.cert_no == "" then 
			this.ui_bind_idLabBtn.gameObject:SetActive(false)
			this.ui_bind_idBtn:SetActive(true)																																																
			--this.m_Mobileidbtn:SetActive(true);																																																													
			--this.m_Mobileidbtn1:SetActive(false);																																																													
			--this.m_Mobileidlab.gameObject:SetActive(false);																																																																																																											
			-- this.ui_findIDCardLabel.text = "未绑定"																																																													
		else 			
			this.ui_bind_idLabBtn.gameObject:SetActive(true)
			this.ui_bind_idBtn:SetActive(false)					
			this.ui_bind_idLabBtn.text = ShowFrontEnd(EginUser.Instance.cert_no,4)									
			-- this.ui_findIDCardLabel.text = ShowFrontEnd(EginUser.Instance.cert_no,4)															
			--this.m_Mobileidbtn:SetActive(false); 																																																													
			--this.m_Mobileidlab.gameObject:SetActive(true);																																																													
			--this.m_Mobileidlab.text = ShowFrontEnd(EginUser.Instance.cert_no,4)																																																																																																										
			--this.m_safetyLtLab.text = ShowFrontEnd(EginUser.Instance.cert_no,4)																																																													
		end 																																																													
																																																															
		 --微信找回密码																																																													
		 if EginUser.wechat_lock == 1 then																																																													
			--this.m_safetyLwBtn:SetActive(true);																																																													
			--this.m_safetyLwV.gameObject:SetActive(false);																																																													
			--this.m_safetyLwLab.gameObject:SetActive(true);																																																													
            -- this.ui_findWxLabel.text = EginUser.Instance.wechat	
            this.ui_BankBindPhoneBtn:SetActive(false)
    		this.ui_BankUnBindPhoneBtn:SetActive(true)																																																												
		else										
			this.ui_BankBindPhoneBtn:SetActive(true)
    		this.ui_BankUnBindPhoneBtn:SetActive(false)																																																			
			--this.m_safetyLwBtn:SetActive(false);																																																													
			--this.m_safetyLwV.gameObject:SetActive(true);																																																													
			--this.m_safetyLwLab.gameObject:SetActive(false);																																																													
			-- this.ui_findWxLabel.text = "未绑定"																																																													
		end																																																													
		--锁定设备														
		if EginUser.Instance.device_lock == 0 then																																																													
			this.ui_safeNowLockLabel.text = "未锁定"															
			this.ui_safeLockBtn:SetActive(true)														
			this.ui_safeUnLockBtn:SetActive(false)																																																				
		else																																																													
			this.ui_safeNowLockLabel.text = "已锁定"															
			this.ui_safeLockBtn:SetActive(false)														
			this.ui_safeUnLockBtn:SetActive(true)																																																													
		end																	
		--绑定qq																																																									
		if EginUser.Instance.qq == "" then																																																													
			--this.m_safetyLqBtn:SetActive(true);																																																													
			--this.m_safetyLqV.gameObject:SetActive(false);														
			-- this.ui_findQQLabel.text = "未绑定"																																																										
			-- this.ui_findQQBtn:SetActive(true);																																																																																																									
		else																		
			-- this.ui_findQQBtn:SetActive(false);																
			-- this.ui_findQQLabel.text = 	ShowFrontEnd(EginUser.Instance.qq,3)																																																							
			--this.m_safetyLqBtn:SetActive(false);																																																													
			--this.m_safetyLqV.gameObject:SetActive(true);																																																													
			--this.m_safetyLqLab.gameObject:SetActive(false);																																																																																																									
		end																																																													
		this.ui_infoTsLabel.gameObject:SetActive(EginUser.Instance.star>2) 																																																													
		 --this.m_safetyLwLab.value  = "" 																																																													
		--this.m_safetyLqLab.value  = "" 																																																													
	end																																																													
	 																																																													
	for i=1,5 do 																																		
		local tStarSpriteName = "xing1"																																	
		if i<=EginUser.Instance.star then																																	
			tStarSpriteName = "xing2"																																	
		end																																	
		this["ui_x"..i].spriteName = tStarSpriteName																																																												
	end																	
															
end																																																													
function this:AfterDoing(offset,run)																																																													
	coroutine.wait(offset);																																																														
	if this.mono then																																																													
		run();																																																													
	end																																																													
end																																																													
																																																													
																																																													
																																																													
																																																													
																																																													
																																																													
----------------------游戏记录相关------------------																																																													
																																																													
function this:OnShowGameRecordView() 																																																													
	this.recordPageG = 1;																																																													
	this:GameRecordStart ()																																																													
end																																																													
function this:GameRecordAwake()																																																													
	this.vgameRecord=this.transform:FindChild("Offset/Avatars/Module_GameRecord");																																																													
																																																														
	this.vRecordsGameRecord=this.vgameRecord:FindChild("Offset/Views/Record/Table");																																																													
	this.recordPrefabGameRecord=ResManager:LoadAsset("happycity/GameRecord_Record1","GameRecord_Record1");																																																													
	this.kRecordPageGameRecord=this.vgameRecord:FindChild("Offset/Views/Record/Page/Label_Page").gameObject:GetComponent("UILabel");																																																													
	this.recordPageG = 1;																																																													
	this.maxRecordPageG = 1;																																																													
	this.recordPageSizeG = 5;																																																													
	 																																																													
																																																														
	this.mono:AddClick(this.vgameRecord:FindChild("Offset/Views/Record/Page/Button_Last").gameObject, this.OnClickLastRecord,this)																																																													
																																																														
	this.mono:AddClick(this.vgameRecord:FindChild("Offset/Views/Record/Page/Button_Next").gameObject, this.OnClickNextRecord,this) 																																																													
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
	this.recordPageSizeG = 5; 																																																													
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
			EginProgressHUD.Instance:ShowPromptHUD(result.resultObject,0.5);																																																													
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
		EginProgressHUD.Instance:ShowPromptHUD(message,0.5);																																																													
	end)																																																													
end																																																													
 																																																													
 																																																													
																																																													
function this:OnClickLastRecord () 																																																													
	local page = this.recordPageG - 1;																																																													
	if (PlatformGameDefine.playform.IsSocketLobby) then																																																													
		this:sendGameRecordSocket(page);																																																													
	else																																																													
		coroutine.start(this.OnLoadRecordGame,this,page); 																																																													
	end																																																													
																																																													
end																																																													
function this:OnClickNextRecord () 																																																													
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
		cell.transform.localPosition =  Vector3.New(0, i*-100, 0);																																																													
		cell.transform.localScale = Vector3.one;																																																													
																																																													
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
																																																													
--honor荣誉中心相关																																																													
function this:GameHonorAwake()																																																													
	this.vgameHonor=this.transform:FindChild("Offset/Avatars/Module_hornor");																																																													
	this.vHonorsTable=this.vgameHonor:FindChild("Offset/Views/Record/Table");																																																													
	this.honorCellPrefab=ResManager:LoadAsset("happycity/GameHonor_Cell","GameHonor_Cell");																																																													
	this.kHonorPageLabel=this.vgameHonor:FindChild("Offset/Views/Record/Page/Label_Page").gameObject:GetComponent("UILabel");																																																													
	this.honroPageG = 1;																																																													
	this.maxHonorPageG = 1;																																																													
	this.honorPageSizeG = 5;																																																													
	this.mono:AddClick(this.vgameHonor:FindChild("Offset/Views/Record/Page/Button_Last").gameObject, this.OnClickLastHonor,this)																																																													
	this.mono:AddClick(this.vgameHonor:FindChild("Offset/Views/Record/Page/Button_Next").gameObject, this.OnClickNextHonor,this) 																																																													
end																																																													
 																																																													
function this:OnClickLastHonor () 																																																													
	local page = this.honroPageG - 1;																																																													
	if page >= 1 then																																																													
		this:SendHonorListRequest(page);																																																													
	end																																																													
end																																																													
function this:OnClickNextHonor () 																																																													
	local page = this.honroPageG + 1;																																																													
	if this.maxHonorPageG >= page then																																																													
		this:SendHonorListRequest(page);																																																													
	end																																																													
end																																																													
function this:OnShowGameHonorView()																																																													
	this:SendHonorListRequest(1)																																																													
end																																																													
function this:SendHonorListRequest(pPageIndex)																																																													
	if pPageIndex == nil then																																																													
		pPageIndex = this.honroPageG																																																													
	end																																																													
	this.mono:Request_lua_fun("AccountService/getGoldnn_uinfo",cjson.encode({start_time=tostring(0),pageindex=tostring(pPageIndex),pagesize=tostring(this.honorPageSizeG)}), 																																																													
	function(message) 																																																													
		EginProgressHUD.Instance:HideHUD(); 																																																													
		--local messageObj = cjson.decode(message);  																																																													
		--this:UpdateHonor(messageObj);																																																													
	end, 																																																													
	function(message)  																																																													
		EginProgressHUD.Instance:ShowPromptHUD(message,0.5);																																																													
	end)																																																													
end																																																													
function this:UpdateHonor(pMsg)																																																													
																																																														
	local tResult = pMsg["result"]																																																													
	 																																																													
	if tResult == "ok" then																																																													
		local tBody = pMsg["body"]																																																													
		if tBody ~= nil then																																																													
			local recordInfoList = tBody["data"]																																																													
			local tPage = tBody["page"]																																																													
			this.honroPageG = tPage["pageindex"];																																																													
			this.maxHonorPageG = tPage["pagecount"];																																																													
			this.kHonorPageLabel.text = this.honroPageG.."/"..this.maxHonorPageG;																																																													
			EginTools.ClearChildren(this.vHonorsTable); 																																																													
			for i = 0 ,#(recordInfoList)-1   do																																																													
				local recordInfo = recordInfoList[i+1]																																																													
				if (type(recordInfo)  ~= "table") then break; end																																																													
				local cell = GameObject.Instantiate(this.honorCellPrefab);																																																													
				cell.transform.parent = this.vHonorsTable;																																																													
				cell.transform.localPosition =  Vector3.New(0, i*-100, 0);																																																													
				cell.transform.localScale = Vector3.one;																																																													
				if recordInfo[5]~=nil then 																																																													
					local tTime = System.DateTime.New(EginTools.getJavaTimeToCshaopTime(recordInfo[5])):ToString("yyyy-MM-dd");																																																													
					cell.transform:Find("Label_0"):GetComponent("UILabel").text = tostring(tTime);																																																													
				end																																																													
				if recordInfo[4]~=nil then 																																																													
					cell.transform:Find("Label_1"):GetComponent("UILabel").text = tostring(recordInfo[4]);																																																													
				end																																																													
				if recordInfo[3]~=nil then 																																																													
					cell.transform:Find("Label_2"):GetComponent("UILabel").text = tostring(recordInfo[3]);																																																													
				end 																																																													
			end																																																													
		end																																																													
	else																																																													
		if tResult~=nil then																																																													
			EginProgressHUD.Instance:ShowPromptHUD(tResult,0.5);																																																													
		end																																																													
	end																																																													
end																																																													
																																																													
																																																													
function this.SocketReceiveMessage(pMessage)																																																													
    if  pMessage then																																																													
        --解析json字符串																																																													
        local messageObj = cjson.decode(pMessage);																																																													
        local typeC = messageObj["type"];																																																													
        local tag = messageObj["tag"];																																																													
        if typeC == 'AccountService' then																																																													
            if tag == 'reg_wechat' then																																																													
                if messageObj["result"] ~= "ok" then																																																													
                    EginProgressHUD.Instance:ShowPromptHUD(messageObj["result"],0.5);																																																													
                end																																																													
																																																													
                elseif  tag == 'reg_qq' then																																																													
                if messageObj["result"] ~= "ok" then																																																													
                    EginProgressHUD.Instance:ShowPromptHUD(messageObj["result"],0.5);																																																													
                end																																																													
            elseif(tag == "lock_account") then																																																													
                if(tostring(messageObj["result"]) == "ok") then																																																													
                    if EginUser.Instance.device_lock == 0 then																																																													
                        EginUser.Instance.device_lock = 1																																																													
                    else																																																													
                        EginUser.Instance.device_lock = 0																																																													
                    end																																																													
                    this:OnShowSafetyTabToggleView()																																																													
                end																																																													
            elseif(tag == "bank_bind_phone") then																																																													
                --<--{"type":"AccountService","tag":"bank_bind_phone","result":'ok' --成功ok ,失败为说明"body": ''		}																																																													
                if(tostring(messageObj["result"]) == "ok") then																																																													
                    if EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE  then																																																													
                        EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PASSWORD																																																													
                        EginProgressHUD.Instance:ShowPromptHUD("解绑成功",0.5);																																																													
                        ProtocolHelper.Send_get_account();--获取用户信息																																																													
                        this.m_BankPhoneUnBindPanel.transform:FindChild("btn_back").gameObject:SendMessage("OnClick")																																																													
                        --this.m_BankPhoneUnBindPanel.transform:FindChild("btn_back").gameObject:SendMessage("OnClick")																																																													
                       -- this.phoneUnbindBtn:SetActive(false);																																																													
                    else																																																													
                        --print( this.m_BankPhoneBindPanel.transform:FindChild("btn_back").gameObject)																																																													
                        this.m_BankPhoneBindPanel.transform:FindChild("btn_back").gameObject:SendMessage("OnClick")																																																													
                        EginUser.Instance.bankLoginType = EginUser.eBankLoginType.PHONE_CODE																																																													
                        EginProgressHUD.Instance:ShowPromptHUD("绑定成功",0.5);																																																													
                        --this.m_BankPhoneBindPanel:SetActive(false);																																																													
                    end																																																													
                    this:OnShowSafetyTabToggleView()																																																													
                    --iTween.MoveTo(this.m_AccountSecurity.gameObject,iTween.Hash ("y",0,"islocal",true,"time",0.3,"easeType", iTween.EaseType.linear,"delay",1));																																																													
                    --this.m_AccountSecurity.gameObject:SetActive(false)																																																													
                    --this.m_AccountSecurity:FindChild("AccountSecurityBG").gameObject:SetActive(false)																																																													
                    --this:InitInfo()																																																													
                else																																																													
                    EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["result"]),0.5);																																																													
                end																																																													
			elseif tag =="getGoldnn_uinfo" then																																																													
 				if(tostring(messageObj["result"]) == "ok") then																																																													
				 	 																																																													
				 	this:UpdateHonor(messageObj)																																																													
                else																																																													
                    EginProgressHUD.Instance:ShowPromptHUD(tostring(messageObj["result"]),0.5);																																																													
                end																																																													
            end																																																													
        end																																																													
    end																																																													
end																																																													
 																													
																	
function this:autoGetUI()
	 this.ui_backBtn=this.transform:FindChild("topback/backBtn").gameObject	
	 this.ui_tabInfoBtn=this.transform:FindChild("tabs/infoBtn").gameObject	
	 this.ui_tabSafeBtn=this.transform:FindChild("tabs/safeBtn").gameObject	
	 this.ui_tabRecordBtn=this.transform:FindChild("tabs/recordBtn").gameObject	
	 this.ui_tabHonorBtn=this.transform:FindChild("tabs/honorBtn").gameObject	
	 this.ui_infoStarBtn=this.transform:FindChild("InfoPanel/starGroup/starBtn").gameObject	
	 this.ui_infoGroup=this.transform:FindChild("InfoPanel").gameObject	
	 this.ui_lvProcessLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid1/lvLabel/lvProcessLabel").gameObject:GetComponent("UILabel")	
	 this.ui_headIcon=this.transform:FindChild("InfoPanel/headGroup/headIcon").gameObject:GetComponent("UISprite")	
	 this.ui_changeHeadIconBtn=this.transform:FindChild("InfoPanel/headGroup/headIcon").gameObject	
	 this.ui_nickLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid/nickLabel/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_changeNickBtn=this.transform:FindChild("InfoPanel/headGroup/proGrid/nickLabel/changeBtn").gameObject	
	 this.ui_idLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid/id/label").gameObject:GetComponent("UILabel")	
	 this.ui_changeIdBtn=this.transform:FindChild("InfoPanel/headGroup/proGrid/id/changeBtn").gameObject	
	 this.ui_genderToggle1=this.transform:FindChild("InfoPanel/headGroup/proGrid/sex/sex1").gameObject	
	 this.ui_genderToggle2=this.transform:FindChild("InfoPanel/headGroup/proGrid/sex/sex2").gameObject	
	 this.ui_genderToggle3=this.transform:FindChild("InfoPanel/headGroup/proGrid/sex/sex3").gameObject	
	 this.ui_goldLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid1/goldLabel/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_rechargeBtn=this.transform:FindChild("InfoPanel/headGroup/proGrid1/goldLabel/rechargeBtn").gameObject	
	 this.ui_ybLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid1/yb/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_bankLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid1/bank/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_rateLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid1/rate/input").gameObject:GetComponent("UILabel")	
	 this.ui_rateDetailLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid1/rate/rateDetailLabel").gameObject:GetComponent("UILabel")	
	 this.ui_memberLabel=this.transform:FindChild("InfoPanel/headGroup/proGrid1/member/input").gameObject:GetComponent("UILabel")	
	 this.ui_LvProgress=this.transform:FindChild("InfoPanel/headGroup/proGrid1/lvLabel").gameObject:GetComponent("UISlider")	
	 this.ui_x1=this.transform:FindChild("InfoPanel/starGroup/starBtn/starGrid/x1").gameObject:GetComponent("UISprite")	
	 this.ui_x2=this.transform:FindChild("InfoPanel/starGroup/starBtn/starGrid/x2").gameObject:GetComponent("UISprite")	
	 this.ui_x3=this.transform:FindChild("InfoPanel/starGroup/starBtn/starGrid/x3").gameObject:GetComponent("UISprite")	
	 this.ui_x4=this.transform:FindChild("InfoPanel/starGroup/starBtn/starGrid/x4").gameObject:GetComponent("UISprite")	
	 this.ui_x5=this.transform:FindChild("InfoPanel/starGroup/starBtn/starGrid/x5").gameObject:GetComponent("UISprite")	
	 this.ui_infoTsLabel=this.transform:FindChild("InfoPanel/starGroup/starBtn/safeStarLabel").gameObject:GetComponent("UILabel")	
	 this.ui_safeNowPhoneLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/phone/label").gameObject:GetComponent("UILabel")	
	 this.ui_safeBindPhoneBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/phone/bindPhoneBtn").gameObject	
	 this.ui_safeNowPwdLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/pwd/label").gameObject:GetComponent("UILabel")	
	 this.ui_safeChangePwdBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/pwd/changeBtn").gameObject	
	 this.ui_safeNowWxLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/wx/label").gameObject:GetComponent("UILabel")	
	 this.ui_safeBindWxBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/wx/bindWxBtn").gameObject	
	 this.ui_safeNowLockLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/lock/label").gameObject:GetComponent("UILabel")	
	 this.ui_safeLockBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/lock/lockPhoneBtn").gameObject	
	 this.ui_findWxLabel=this.transform:FindChild("safePanel/findGroup/proGrid1/wx/findWxLabel").gameObject:GetComponent("UILabel")	
	 this.ui_findIDCardLabel=this.transform:FindChild("safePanel/findGroup/proGrid1/id/idCardLabel").gameObject:GetComponent("UILabel")	
	 this.ui_findQQLabel=this.transform:FindChild("safePanel/findGroup/proGrid1/qq/findQQLabel").gameObject:GetComponent("UILabel")	
	 this.ui_findQQBtn=this.transform:FindChild("safePanel/findGroup/proGrid1/qq/findQQBtn").gameObject	
	 this.ui_findQQInput=this.transform:FindChild("safePanel/findGroup/proGrid1/qq/findQQBtn/bg").gameObject:GetComponent("UIInput")	
	 this.ui_safeUnBindPhoneBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/phone/unbindPhoneBtn").gameObject	
	 this.ui_safeUnLockBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/lock/unLockPhoneBtn").gameObject	
	 this.ui_safeUnBindWxBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/wx/unBindWxBtn").gameObject	
	 this.ui_bindPhoneLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/phone/label").gameObject:GetComponent("UILabel")	
	 this.ui_safePwdLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/pwd/label").gameObject:GetComponent("UILabel")	
	 this.ui_bindPhoneBtn=this.transform:FindChild("safePanel/bindSafe/proGrid/pwd/changeBtn").gameObject	
	 this.ui_bindWxLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/wx/label").gameObject:GetComponent("UILabel")	
	 this.ui_lockLabel=this.transform:FindChild("safePanel/bindSafe/proGrid/lock/label").gameObject:GetComponent("UILabel")	
	 this.ui_findTsLabel=this.transform:FindChild("safePanel/findGroup/safeStarLabel").gameObject:GetComponent("UILabel")	
	 this.ui_phone_numLabel=this.transform:FindChild("phonePanel/Grid/nickLabel/bg/input").gameObject:GetComponent("UIInput")	
	 this.ui_phone_CodeLabel=this.transform:FindChild("phonePanel/Grid/codeLabel/bg/input").gameObject:GetComponent("UIInput")	
	 this.ui_phone_CodeBtn=this.transform:FindChild("phonePanel/Grid/codeLabel/changeBtn").gameObject	
	 this.ui_phone_submitBtn=this.transform:FindChild("phonePanel/submitBtn").gameObject	
	 this.ui_tjBtn=this.transform:FindChild("phonePanel/submitBtn").gameObject	
	 this.ui_Pwd_NameInput=this.transform:FindChild("pwdPanel/Grid/oldLabel/input").gameObject:GetComponent("UILabel")	
	 this.ui_Pwd_NewInput=this.transform:FindChild("pwdPanel/Grid/newLabel/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_Pwd_VarifyBtn=this.transform:FindChild("pwdPanel/Grid/newLabel/GetVarifyBtn").gameObject	
	 this.ui_pwd_VarifyInput=this.transform:FindChild("pwdPanel/Grid/againLabel/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_Pwd_Btn=this.transform:FindChild("pwdPanel/submitBtn").gameObject	
	 this.ui_Mail_IDLab=this.transform:FindChild("mailPanel/Grid/idLabel/bg/input").gameObject:GetComponent("UILabel")	
	 this.ui_Mail_AdInput=this.transform:FindChild("mailPanel/Grid/mailLabel/bg/input").gameObject:GetComponent("UIInput")	
	 this.ui_Mail_varifyInput=this.transform:FindChild("mailPanel/Grid/codeLabel/bg/input").gameObject:GetComponent("UIInput")	
	 this.ui_Mail_CodeBtn=this.transform:FindChild("mailPanel/Grid/codeLabel/bg/passcodeBtn").gameObject	
	 this.ui_Mail_lBtn=this.transform:FindChild("mailPanel/submitBtn").gameObject	
	 this.ui_recordItem=this.transform:FindChild("recordGroup/recordItem").gameObject	
	 this.ui_recordPreBtn=this.transform:FindChild("recordGroup/turnpage/prePage").gameObject	
	 this.ui_recordPageLabel=this.transform:FindChild("recordGroup/turnpage/page").gameObject:GetComponent("UILabel")	
	 this.ui_recordNextBtn=this.transform:FindChild("recordGroup/turnpage/nextPage").gameObject	
	 this.ui_honorGroup=this.transform:FindChild("honor").gameObject	
	 this.ui_honorPagePreBtn=this.transform:FindChild("honor/page/preBtn").gameObject	
	 this.ui_honorPageLabel=this.transform:FindChild("honor/page/Label").gameObject:GetComponent("UILabel")	
	 this.ui_honorPageNextBtn=this.transform:FindChild("honor/page/nextBtn").gameObject	
	 this.ui_honorItem=this.transform:FindChild("honor/honorItem").gameObject	
	 this.ui_honorContainer=this.transform:FindChild("honor/honorGrid").gameObject	
	 this.ui_honorGrid=this.transform:FindChild("honor/honorGrid").gameObject:GetComponent("UIGrid")	
	 this.ui_headsGrid=this.transform:FindChild("head/Scroll View/Grid").gameObject	
	 this.ui_ChooseHeadTemplate=this.transform:FindChild("head/headIcon").gameObject	
	 this.ui_headsScrollView=this.transform:FindChild("head/Scroll View").gameObject:GetComponent("UIPanel")	
	 this.ui_changeHeadPanel=this.transform:FindChild("head").gameObject	
	 this.ui_Lab_Nickname=this.transform:FindChild("AccountSafty/Grid/nickLab/bg").gameObject:GetComponent("UILabel")	
	 this.ui_phone_MailBtn=this.transform:FindChild("AccountSafty/Grid/Mail/changeMBtn").gameObject	
	 this.ui_Lab_Email=this.transform:FindChild("AccountSafty/Grid/Mail/Lab").gameObject:GetComponent("UILabel")	
	 this.ui_phone_PhoneBtn=this.transform:FindChild("AccountSafty/Grid/PhoneNum/changePBtn").gameObject	
	 this.ui_Lab_PhoneNum=this.transform:FindChild("AccountSafty/Grid/PhoneNum/Lab").gameObject:GetComponent("UILabel")	
	 this.ui_bind_idBtn=this.transform:FindChild("AccountSafty/Grid/ID/changePBtn").gameObject	
	 this.ui_bind_idLabBtn=this.transform:FindChild("AccountSafty/Grid/ID/Lab").gameObject:GetComponent("UILabel")	
	 this.ui_changePSDBtn=this.transform:FindChild("AccountSafty/ChangePsDBtn").gameObject	
	 this.ui_Mail_CBtn=this.transform:FindChild("ChangePsdPanel/Mail_ChangeBtn").gameObject	
	 this.ui_phone_CBtn=this.transform:FindChild("ChangePsdPanel/Phone_ChangeBtn").gameObject	
	 this.ui_ID_SureBtn=this.transform:FindChild("IDPanel/submitBtn").gameObject	
	 this.ui_ID_NameInput=this.transform:FindChild("IDPanel/Grid/NameLabel/bg/input").gameObject:GetComponent("UIInput")	
	 this.ui_ID_IDNumInput=this.transform:FindChild("IDPanel/Grid/againLabel/bg/input").gameObject:GetComponent("UIInput")	
	 this.m_AccountSecurityEmail = this.transform:FindChild("mailPanel").gameObject	
	 
end 																	
function this:autoClearUI()
	 this.ui_backBtn= nil	
	 this.ui_tabInfoBtn= nil	
	 this.ui_tabSafeBtn= nil	
	 this.ui_tabRecordBtn= nil	
	 this.ui_tabHonorBtn= nil	
	 this.ui_infoStarBtn= nil	
	 this.ui_infoGroup= nil	
	 this.ui_lvProcessLabel=nil	
	 this.ui_headIcon=nil	
	 this.ui_changeHeadIconBtn= nil	
	 this.ui_nickLabel=nil	
	 this.ui_changeNickBtn= nil	
	 this.ui_idLabel=nil	
	 this.ui_changeIdBtn= nil	
	 this.ui_genderToggle1= nil	
	 this.ui_genderToggle2= nil	
	 this.ui_genderToggle3= nil	
	 this.ui_goldLabel=nil	
	 this.ui_rechargeBtn= nil	
	 this.ui_ybLabel=nil	
	 this.ui_bankLabel=nil	
	 this.ui_rateLabel=nil	
	 this.ui_rateDetailLabel=nil	
	 this.ui_memberLabel=nil	
	 this.ui_LvProgress=nil	
	 this.ui_x1=nil	
	 this.ui_x2=nil	
	 this.ui_x3=nil	
	 this.ui_x4=nil	
	 this.ui_x5=nil	
	 this.ui_infoTsLabel=nil	
	 this.ui_safeNowPhoneLabel=nil	
	 this.ui_safeBindPhoneBtn= nil	
	 this.ui_safeNowPwdLabel=nil	
	 this.ui_safeChangePwdBtn= nil	
	 this.ui_safeNowWxLabel=nil	
	 this.ui_safeBindWxBtn= nil	
	 this.ui_safeNowLockLabel=nil	
	 this.ui_safeLockBtn= nil	
	 this.ui_findWxLabel=nil	
	 this.ui_findIDCardLabel=nil	
	 this.ui_findQQLabel=nil	
	 this.ui_findQQBtn= nil	
	 this.ui_findQQInput=nil	
	 this.ui_safeUnBindPhoneBtn= nil	
	 this.ui_safeUnLockBtn= nil	
	 this.ui_safeUnBindWxBtn= nil	
	 this.ui_bindPhoneLabel=nil	
	 this.ui_safePwdLabel=nil	
	 this.ui_bindPhoneBtn= nil	
	 this.ui_bindWxLabel=nil	
	 this.ui_lockLabel=nil	
	 this.ui_findTsLabel=nil	
	 this.ui_phone_titleBtn=nil	
	 this.ui_phone_numLabel=nil	
	 this.ui_phone_CodeLabel=nil	
	 this.ui_phone_CodeBtn= nil	
	 this.ui_phone_submitBtn= nil	
	 this.ui_tjBtn= nil	
	 this.ui_Pwd_NameInput=nil	
	 this.ui_Pwd_NewInput=nil	
	 this.ui_Pwd_VarifyBtn= nil	
	 this.ui_pwd_VarifyInput=nil	
	 this.ui_Pwd_Btn= nil	
	 this.ui_Mail_IDLab=nil	
	 this.ui_Mail_AdInput=nil	
	 this.ui_Mail_varifyInput=nil	
	 this.ui_Mail_CodeBtn= nil	
	 this.ui_Mail_lBtn= nil	
	 this.ui_recordItem= nil	
	 this.ui_recordPreBtn= nil	
	 this.ui_recordPageLabel=nil	
	 this.ui_recordNextBtn= nil	
	 this.ui_honorGroup= nil	
	 this.ui_honorPagePreBtn= nil	
	 this.ui_honorPageLabel=nil	
	 this.ui_honorPageNextBtn= nil	
	 this.ui_honorItem= nil	
	 this.ui_honorContainer= nil	
	 this.ui_honorGrid=nil	
	 this.ui_headsGrid= nil	
	 this.ui_ChooseHeadTemplate= nil	
	 this.ui_headsScrollView=nil	
	 this.ui_changeHeadPanel= nil	
	 this.ui_Lab_Nickname=nil	
	 this.ui_phone_MailBtn= nil	
	 this.ui_Lab_Email=nil	
	 this.ui_phone_PhoneBtn= nil	
	 this.ui_Lab_PhoneNum=nil	
	 this.ui_bind_idBtn= nil	
	 this.ui_bind_idLabBtn=nil	
	 this.ui_changePSDBtn= nil	
	 this.ui_Mail_CBtn= nil	
	 this.ui_phone_CBtn= nil	
	 this.ui_ID_SureBtn= nil	
	 this.ui_ID_NameInput=nil	
	 this.ui_ID_IDNumInput=nil	
	 this.m_AccountSecurityEmail = nil
	 this.mailBindPanelTitle = nil
end 											

function this:ShowTip(pTxt)
	
end																
															
														
													
												
											
										
									
								
							
						
					
				
			
		
	

