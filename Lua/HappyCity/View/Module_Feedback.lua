
local this = LuaObject:New()
Module_Feedback = this
local isCallPone = false;
function this:Awake()
	EginProgressHUD.Instance:HideHUD();
	if  PlatformGameDefine.playform.IsSocketLobby then this.mono:StartSocket(false); end
	
end

function this:Start()
	local kContent = this.transform:FindChild("Offset/Module_FieldText/Input/Label"):GetComponent("UILabel");
	kContent.text = PlatformGameDefine.playform.FeedbackContent;


	this.kwxLabel = this.transform:FindChild("Offset/Module_FieldText/Input/Grid/wx/num/Label"):GetComponent("UILabel");

	local backBtn = this.transform:FindChild("Offset/Background Top/Button_Back - Anchor/ImageButton").gameObject;
	this.mono:AddClick(backBtn, this.OnClickBack);

	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
		            

	this.mono:Request_lua_fun("AccountService/getKefuInfo","",
		function(result)    
		EginProgressHUD.Instance:HideHUD();
			--QQ
			this.kefuInfo = cjson.decode(result)
			this.qq = this.transform:FindChild("Offset/Module_FieldText/Input/Grid/qq").gameObject;
			this.mono:AddClick(this.qq, this.OnQQ);
			--wx
			this.wx = this.transform:FindChild("Offset/Module_FieldText/Input/Grid/wx").gameObject;
			this.mono:AddClick(this.wx, this.OnWX);
			this.kwxLabel.text = tostring(this.kefuInfo["wechat"])  
			--电话
			this.phone = this.transform:FindChild("Offset/Panel/bg/determine").gameObject;
			this.mono:AddClick(this.phone, this.OnPhone);
			local phoneNum = this.transform:FindChild("Offset/Panel/bg/Label"):GetComponent("UILabel");
			phoneNum.text = "您即将拨打电话: "..this:PhoneNumDispose(this.kefuInfo["tel"])  
			isCallPone = true;
		end, 
		function(result)  

            EginProgressHUD.Instance:ShowPromptHUD(result);
		end);
end

function this:OnClickBack()
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
    Utils.LoadLevelGUI("Hall");
end

function this:OnQQ() 
	log(this.kefuInfo["qq"]);
	--this.kefuInfo["qq"] = "1020081842"
	if(Application.platform == UnityEngine.RuntimePlatform.Android) then 
		--local errstr = PhoneSdkUtil.androidToActivity("ACTION_VIEW","mqqwpa://im/chat?chat_type=wpa&uin="..this.kefuInfo["qq"].."&version=1&src_type=web");
		local errstr = PhoneSdkUtil.androidToActivity("ACTION_VIEW","mqqwpa://im/chat?chat_type=crm&uin="..this.kefuInfo["qq"].."&version=1&src_type=web&web_src=\"http://wpa.b.qq.com\"");
 
		if errstr ~= "" then
			--个人账号网址
			--Application.OpenURL("http://wpa.qq.com/msgrd?v=3&uin="..this.kefuInfo["qq"].."&site=qq&menu=yes");
			--企业账号网址
			Application.OpenURL("http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin="..this.kefuInfo["qq"]);
		end
	else   
	--NSString *url = @"mqqwpa://im/chat?chat_type=crm&uin=800095555&version=1&src_type=web&web_src=http://wpa.b.qq.com"; 
		if PhoneSdkUtil.IsIOSApp("mqq://") then

			PhoneSdkUtil.OpenIosAppURL("mqq://im/chat?chat_type=wpa&uin="..this.kefuInfo["qq"].."&version=1&src_type=web");  
			--PhoneSdkUtil.OpenIosAppURL("mqq://im/chat?chat_type=crm&uin="..this.kefuInfo["qq"].."&version=1&src_type=web&web_src=http://wpa.b.qq.com"); 
		else
			Application.OpenURL("http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin="..this.kefuInfo["qq"]);
		end
		--WXPayUtil.OpenIOSApp("mqq://im/chat?chat_type=wpa&uin="..this.kefuInfo["qq"].."&version=1&src_type=web","");
	end 
end
function this:OnWX()  
	log(this.kefuInfo["wechat"]);

	if(Application.platform == UnityEngine.RuntimePlatform.Android) then 
		-- local errstr = PhoneSdkUtil.androidToActivity("ACTION_MAIN","weixinwpa://");
 		 WXPayUtil.OpenAndroidApp("com.tencent.mm","");
	else   
	 	if PhoneSdkUtil.IsIOSApp("wechat://") then 
			PhoneSdkUtil.OpenIosAppURL("wechat://");   
		end 
	end 
end
function this:OnPhone() 
	log(this.kefuInfo["tel"]);
	if isCallPone then
	isCallPone = false
	coroutine.start(this.AfterDoing,this,2, function() 
					isCallPone = true
				end);
	PhoneSdkUtil.callPhone(this.kefuInfo["tel"]);
	end
	
end
function this:PhoneNumDispose(pnum)  
	local tempNum = string.sub(pnum,1,3).."-"..string.sub(pnum,4,6).."-"..string.sub(pnum,7)
	return tempNum;
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
function this:AfterDoing(offset,run)
	coroutine.wait(offset);	
	if this.mono then
		run();
	end
end 