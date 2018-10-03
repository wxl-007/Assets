
local this = LuaObject:New()
Module_ConvertRegister = this

function this:Awake() 
	this.vConfirmPG = this.transform:FindChild("Offset").gameObject:GetComponent("Animator")
	 ----------------增加游客注册窗口
	this.m_GuestConvertObj = this.transform;
	this.m_RealNameRegister = this.m_GuestConvertObj:FindChild("Offset/Views/Register").gameObject
	--this.m_PhoneRegister = this.m_GuestConvertObj:FindChild("Offset/Views/PhoneRegister").gameObject


	this.m_Username = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_Username/Input").gameObject:GetComponent("UIInput");
	this.m_Nickname = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_Nickname/Input").gameObject:GetComponent("UIInput");
	this.m_Password = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_Password/Input").gameObject:GetComponent("UIInput");
	this.m_PasswordVerify = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_Ps/Input").gameObject:GetComponent("UIInput");
	this.m_Email = this.m_GuestConvertObj:FindChild('Offset/Views/Register/Input_Email/Input').gameObject:GetComponent('UIInput')
	--this.m_PhoneNumber = this.m_GuestConvertObj:FindChild("Offset/Views/PhoneRegister/Input_PhoneNumber/Input").gameObject:GetComponent("UIInput");
	--this.m_PhoneNickname = this.m_GuestConvertObj:FindChild("Offset/Views/PhoneRegister/Input_Nickname/Input").gameObject:GetComponent("UIInput");

	this.m_TuiID = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_tuiJian/Input").gameObject:GetComponent("UIInput");--推荐人ID
	this.m_TuiId = this.m_GuestConvertObj:FindChild("Offset/Views/Register/Input_tuiJian").gameObject ;
	this.m_TuiId.gameObject:SetActive(false)
	this.m_BtnSure = this.m_GuestConvertObj:FindChild('Offset/Views/Register/Button_Submit').gameObject
	this.m_BtnBG = this.m_GuestConvertObj:FindChild('Offset/btn_back').gameObject
	Module_UpdateAvatar.mono:AddClick(this.m_BtnSure,function ( )
		this:GuestConvertReal(1)
	end )
	--this.m_BtnPhoneSure = this.m_GuestConvertObj:FindChild('Offset/Views/PhoneRegister/Button_Submit').gameObject
	 --Module_UpdateAvatar.mono:AddClick(this.m_BtnPhoneSure,function ( )
	--    this:GuestConvertReal(2)
	--end )

	Module_UpdateAvatar.mono:AddClick(this.m_BtnBG,function (  )
		--this:GuestRegisterPanelCtrl(false)
		this.m_Username.value = ''
		this.m_Password.value =''
		this.m_PasswordVerify.value = ''
		this.m_Nickname.value =''
		this.m_Email.value = '' 
	end)
end

function this:Start()
 
end
 function this:OnEnable() 
	this:OnConfirmPanelShow()    
end
 
 
function this:OnDisable() 
	
	 
end
function this:clearLuaValue()

	this.mono = nil
	this.gameObject = nil
	this.transform  = nil

	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
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
	if ProtocolHelper._LoginType ~= LoginType.Guest then	
		tErrorTip = "您已不是游客,无需升级帐号!"
	end
	if EginUser.Instance.star ~= 0 then
             tErrorTip = "您已不是游客,无需升级帐号!"
        end 
	
		--[[
        if this.m_Password.value ~= this.m_PasswordVerify.value then
            tErrorTip= ZPLocalization.Instance:Get("RegisterPasswordVerify");
        end
        if this.m_Nickname.value == nil  or string.len(this.m_Nickname.value)==0 then
           tErrorTip = ZPLocalization.Instance:Get("RegisterNickname");
        end
		]]
        if  string.len(tErrorTip) > 0  then
            EginProgressHUD.Instance:ShowPromptHUD(tErrorTip,2.0);
            return
        end 

        tBody['uid'] = EginUser.Instance.uid
        tBody['username'] = this.m_Username.value
        tBody['password'] = this.m_Password.value 
        tBody['email'] = this.m_Email.value
        tBody['nickname'] = EginUser.Instance.nickname.."_new"

        local tM = EginUser.Instance.uid..this.m_Username.value..this.m_Password.value..this.m_Email.value..'9dfo2*jdm89g-9w!7=(=*xk6-1bch5^d20m8bu25df2(xn-c'
        tBody['sign'] =  Util.md5(tM)
        Module_UpdateAvatar.mono:Request_lua_fun("AccountService/guest_register",cjson.encode(tBody),function(message) 
             --this:GuestRegisterPanelCtrl(false,1)
             EginProgressHUD.Instance:ShowPromptHUD('注册成功');
            --其他操作
            --渠道处理
             Module_Channel.Instance:handleReg()
		EginUser.Instance.isTourist = false;
		Module_UpdateAvatar:InitInfo();
		this.gameObject:SetActive(false);
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
        Module_UpdateAvatar.mono:Request_lua_fun("AccountService/guest_phone_reg",cjson.encode(tBody),function(message) 
            -- this:GuestRegisterPanelCtrl(false,2)
             EginProgressHUD.Instance:ShowPromptHUD('注册成功');
            --其他操作
            --渠道处理
             Module_Channel.Instance:handleReg()
        end, 
        function(message)   
            EginProgressHUD.Instance:ShowPromptHUD(message);
        end);   

    end
end
 function this:OnConfirmPanelShow()  
  
	this.vConfirmPG.transform.localScale = Vector3(0.001,0.001,0.001);
	coroutine.start(this.AfterDoing,this,0, function()
		this.vConfirmPG.transform.localScale = Vector3(1,1,1); 
		this.vConfirmPG.enabled = true; 
		this.vConfirmPG:Play("FrameShowAnimation")
		this.vConfirmPG:Update(0); 		
	end);
end
	 
function this:AfterDoing(offset,run)
	coroutine.wait(offset);	
	if this.gameObject then
		run();
	end
end