								
local this = LuaObject:New()								
Module_Task = this								
this.tyeptbon = 0;								
this.isAppstore = false;								
function this:Awake()  								
	this.mono = Hall.mono							
	this.WeChatStatus = {0,0,0,0,0}								
	this:autoGetUI()							
	this.mono:AddClick(this.ui_backBtn,this.OnBack) 								
 	this.m_MobilePhoneValidation = this.transform:FindChild('Offset/MobilePhone/MobilePhone/Views/Validation/Input'):GetComponent('UIInput')
	this.freeCells = {this.transform:FindChild('Offset/taskPanel/Views/free/cell1/btn').gameObject,								
					this.transform:FindChild('Offset/taskPanel/Views/free/cell3/btn').gameObject,								
					this.transform:FindChild('Offset/taskPanel/Views/free/cell4/btn').gameObject,								
					this.transform:FindChild('Offset/taskPanel/Views/free/cell2/btn').gameObject,								
					this.transform:FindChild('Offset/taskPanel/Views/free/cell5/btn').gameObject};								
													
	this.freeCellsLabel = {this.transform:FindChild('Offset/taskPanel/Views/free/cell1/Label2').gameObject:GetComponent("UILabel"),								
				this.transform:FindChild('Offset/taskPanel/Views/free/cell3/Label2').gameObject:GetComponent("UILabel"),								
				this.transform:FindChild('Offset/taskPanel/Views/free/cell4/Label2').gameObject:GetComponent("UILabel"),								
				this.transform:FindChild('Offset/taskPanel/Views/free/cell2/Label2').gameObject:GetComponent("UILabel"),								
				this.transform:FindChild('Offset/taskPanel/Views/free/cell5/Label2').gameObject:GetComponent("UILabel")};								
								
	this.freeCellsNoteLabel = {this.transform:FindChild('Offset/taskPanel/Views/free/cell1/Label2').gameObject:GetComponent("UILabel"),								
				this.transform:FindChild('Offset/taskPanel/Views/free/cell3/Label2').gameObject:GetComponent("UILabel"),								
				this.transform:FindChild('Offset/taskPanel/Views/free/cell4/Label2').gameObject:GetComponent("UILabel"),								
				this.transform:FindChild('Offset/taskPanel/Views/free/cell2/Label2').gameObject:GetComponent("UILabel"),								
				this.transform:FindChild('Offset/taskPanel/Views/free/cell5/Label2').gameObject:GetComponent("UILabel")};	
	this.freeCellsBtnF = {this.freeCells[1].transform:FindChild('Sprite').gameObject:GetComponent("UISprite"),								
				this.freeCells[2].transform:FindChild('Sprite').gameObject:GetComponent("UISprite"),							
				this.freeCells[3].transform:FindChild('Sprite').gameObject:GetComponent("UISprite"),								
				this.freeCells[4].transform:FindChild('Sprite').gameObject:GetComponent("UISprite"),								
				this.freeCells[5].transform:FindChild('Sprite').gameObject:GetComponent("UISprite")};
							
	 								
	this.mono:AddClick(this.freeCells[1],this.OnWeixinBinding) 								
	this.mono:AddClick(this.freeCells[4],this.OnWeixinShare) 								
	this.mono:AddClick(this.freeCells[2],this.OnWeixinInvite) 								
	this.mono:AddClick(this.freeCells[3],this.OnAppStoreGoodReputation) 								
	this.mono:AddClick(this.freeCells[5],this.OnphoneBinding) 								
	for i = 1,5 do								
		this.freeCells[i]:SetActive(false);								
	end 								
									
	if Utils._IsNoWeChat then								
		--隐藏    								
		this.transform:FindChild("Offset/taskPanel/Views/free/cell1").gameObject:SetActive(false);	 								
		this.transform:FindChild("Offset/taskPanel/Views/free/cell2").gameObject:SetActive(false);									
		this.transform:FindChild("Offset/taskPanel/Views/free/cell3").gameObject:SetActive(false);									
	end 								
									
	 if (Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer) then								
		this.transform:FindChild("Offset/taskPanel/Views/free/cell4").gameObject:SetActive(true);								
	else 								
		this.transform:FindChild("Offset/taskPanel/Views/free/cell4").gameObject:SetActive(false);									
	end								
									
									
	-------绑定手机															
	this.ui_bindPhoneUserNameLabel.text = EginUser.Instance.nickname												
	this.mono:AddClick( this.ui_bindPhoneCodeBtn,function ( ) 								
		--获取手机验证码								
		if this.ui_bindPhoneValidationInput.value ~= "" then 								
			this:send_phone_code(1,this.ui_bindPhoneValidationInput.value,function()  								
				end)   								
		 end								
	end ) 								
	this.mono:AddClick( this.ui_bindPhoneCodeBtn,function ( ) 								
		--发送绑定手机请求								
		--获取手机验证码 								
		if this.m_MobilePhoneValidation.value ~= "" then 								
			this:bind_phone(1,this.ui_bindPhoneValidationInput.value,this.m_MobilePhoneValidation.value,function()  								
					this.ui_bindPhonePanel:SetActive(false);								
					this:onWeChatShare();								
				end )								
		 end								
	end )								
	this.mono:AddClick( this.ui_bindPhoneBackBtn,function ( ) 								
		this.ui_bindPhoneValidationInput.value = ''								
		this.m_MobilePhoneValidation.value = ''								
	end ) 								
end								
								
function this:Start()								
 							
end								
 function this:OnEnable() 								
	 this.tyeptbon = 0;								
	 this.isAppstore = false;								
end  								
function this:OnDisable()  								
	 this.tyeptbon = 0;								
	 this.isAppstore = false;								
end								
								
function this:clearLuaValue()								
								
	this.mono = nil								
	this.gameObject = nil								
	this.transform  = nil								
	this:autoClearUI()							
	LuaGC()								
end								
								
function this:OnDestroy()								
	this:clearLuaValue()								
end								
function this.OnApplicationFocus(focusStatus) 								
	if focusStatus then  								
		if this.isAppstore then 								
			this.isAppstore = false;								
			this:onWeChatShare() ;								
		end								
	else								
		log("OnApplicationFocus")								
	end								
end								
function this.OnApplicationPause(pauseStatus) 								
end						
-- "body": [绑定微信,微信首次邀请,appstore好评,微信分享] # 0 默认, 1 绑定或分享, 2 领取 #如 [1,0,0,0]			
function this:FreeInit()  								
								
	for i = 1,5 do								
		if this.WeChatStatus[i] == 1 then 								
			this.freeCells[i]:SetActive(true);								
			this.freeCells[i]:GetComponent("UISprite").spriteName = "activity0";								
			this.freeCells[i]:GetComponent("UIButton").normalSprite = "activity0";								
			this.freeCells[i]:GetComponent("UIButton").PressedSprite = "activity0";
			this.freeCellsBtnF.spriteName = 'Lab_Receive'
			this.freeCellsBtnF:MakePixelPerfect()
			this.freeCellsLabel[i].text = "可获赠3000金币"
											
		 elseif this.WeChatStatus[i] == 2  then 								
			if i==1 or i ==  5 then								
				this.freeCells[i]:SetActive(false);								
			else								
				this:WeChatStatus0(i);	
				this.freeCells[i]:GetComponent("UISprite").spriteName = "BG_Grey";								
				this.freeCells[i]:GetComponent("UIButton").normalSprite = "BG_Grey";								
				this.freeCells[i]:GetComponent("UIButton").PressedSprite = "BG_Grey";
				this.freeCellsBtnF.spriteName = 'Lab_Received'
				this.freeCellsBtnF:MakePixelPerfect()							
			end 								
			this.freeCellsLabel[i].text = "已完成"								
		elseif this.WeChatStatus[i] == 0  then 								
			if i==1 then 								
				if EginUser.Instance.wechat_id ~= nil  and EginUser.Instance.wechat_id ~= ""  and EginUser.Instance.wechat_id ~= "null"  and  EginUser.Instance.wechat_id ~= "userdata: NULL"  and  EginUser.Instance.wechat_id ~= "NULL"  and  EginUser.Instance.wechat_id ~= "Null"then								
					this.tyeptbon = 1; 								
					this:onWeChatShare()  								
					this.freeCells[i]:SetActive(false); 								
				else								
					this.freeCells[i]:SetActive(true); 								
				end 								
			elseif i == 5 then								
												
				if EginUser.Instance.bindPhone ~= 0  then								
					this.tyeptbon = 5; 								
					this:onWeChatShare()  								
				else								
					this:WeChatStatus0(i);								
				end 								
			else								
				this:WeChatStatus0(i);								
			end  								
			this.freeCellsLabel[i].text = "可获赠3000金币"								
		end  								
	end								
								
	--邀请和分享 奖励隐藏								
	if PlatformLua.playform.shareGetCoinCount== 0 then								
		this.freeCellsLabel[2].text = ""								
		this.freeCellsLabel[4].text = ""								
		this.freeCellsLabel[1].text = "";								
		this.freeCellsNoteLabel[2].text=""								
		this.freeCellsNoteLabel[4].text=""								
		this.freeCellsNoteLabel[1].text="";								
	else								
		this.freeCellsLabel[2].text = "可获赠"..PlatformLua.playform.shareGetCoinCount.."金币"								
		this.freeCellsLabel[4].text = "可获赠"..PlatformLua.playform.shareGetCoinCount.."金币"								
		this.freeCellsLabel[1].text = "可获赠"..PlatformLua.playform.shareGetCoinCount.."金币"								
		this.freeCellsNoteLabel[2].text="微信邀请有奖"								
		this.freeCellsNoteLabel[4].text="微信分享有奖"								
		this.freeCellsNoteLabel[1].text="绑定微信有奖"								
	end								
								
end								
 function this:WeChatStatus0(i)								
	this.freeCells[i]:SetActive(true);								
	--[[local btnString = "";								
	if i==1 or i == 5 then								
		btnString = "bunding_btn"								
	elseif i==2 then 								
		btnString = "invite_btn"								
	elseif i==3 then 								
		btnString = "rate_btn"								
	elseif i==4 then 								
		btnString = "share_btn"								
	end 								
	this.freeCells[i]:GetComponent("UISprite").spriteName = btnString;								
	this.freeCells[i]:GetComponent("UIButton").normalSprite = btnString;]]							
end								
 function this:OnBack() 								
	EginProgressHUD.Instance:HideHUD(); 								
	-- HallUtil:HidePanelAni(this.gameObject)	
	HallUtil:PopupPanel('Hall',false,this.gameObject,nil)						
end								
 function this:OnWeixinBinding()								
	--EginProgressHUD.Instance:ShowPromptHUD("即将开放!")								
	--[[]]								
	log("微信绑定")								
	this.tyeptbon = 1;  								
	 if this.WeChatStatus[1] == 1 then								
		this:onWeChatShareAward()								
	elseif this.WeChatStatus[1] == 0 then								
		--this:onWeChatShare()  								
		Application.OpenURL(ConnectDefine.HostURL);								
	end 								
end  								
 function this:OnWeixinShare()								
	log("微信分享")								
	this.tyeptbon = 4; 								
	 								
	 if  this.WeChatStatus[4] == 1 then								
		this:onWeChatShareAward()								
	elseif  this.WeChatStatus[4] == 0 or   this.WeChatStatus[4] == 2 then								
		--this:onWeChatShare() 								
		this:WeChatShare(true,this.gameObject.name)								
	end								
end								
 function this:OnWeixinInvite()								
	log("微信邀请")								
	this.tyeptbon = 2;  								
	 if this.WeChatStatus[2] == 1 then								
		this:onWeChatShareAward()								
	elseif this.WeChatStatus[2] == 0  or  this.WeChatStatus[2] == 2 then								
		--this:onWeChatShare() 								
		this:WeChatShare(false,this.gameObject.name)								
	end								
end								
								
 function this:OnAppStoreGoodReputation() 								
	this.tyeptbon = 3;  								
	 if this.WeChatStatus[3] == 1 then								
		this:onWeChatShareAward()								
	elseif this.WeChatStatus[3] == 0  or  this.WeChatStatus[3] == 2 then								
		--this:onWeChatShare()  								
		this.isAppstore = true;								
		--调用好评								
		  Application.OpenURL("https://itunes.apple.com/cn/app/597qi-pai-you-xi/id1111218224?ls=1&mt=8");								
		  								
	end								
end								
 function this:OnphoneBinding()								
	 								
	log("手机绑定")								
	this.tyeptbon = 5;  								
	 if this.WeChatStatus[5] == 1 then								
		this:onWeChatShareAward()								
	elseif this.WeChatStatus[5] == 0 then								
		--this:onWeChatShare()  								
		this.transform:FindChild('Offset/MobilePhone').gameObject:SetActive(true)								
	end 								
end  								
 function this:onWeChatShare() 								
	 								
	 this.WeChatShareNet(this.tyeptbon)								
end								
 function this:onWeChatShareAward() 								
	 								
	this.GetWeChatShareAward( this.tyeptbon)								
end								
								
								
--------------添加微信分享 领奖 的协议 								
--获取分享有奖的状态								
--[[								
"body": [绑定微信,微信首次邀请,appstore好评,微信分享] # 0 默认, 1 绑定或分享, 2 领取 #如 [1,0,0,0]								
]]								
								
								
function this:WeChatShare(isTimeline,callbackGameObject)								
    print('in  wechat share  '..tostring(isTimeline))								
	local wxshareid =  PlatformLua.playform.WXAppId; 								
	if #(PlatformLua.playform.wxShareAppIds) > 0 then 								
		for i = 1,#(PlatformLua.playform.wxShareAppIds) do								
			if PlatformLua.playform.wxShareAppIds[i]~=nil and PlatformLua.playform.wxShareAppIds[i]~="" then								
				wxshareid = PlatformLua.playform.wxShareAppIds[i]								
				break;								
			end								
		end								
	end								
	local tempjsonMsg = {wxappid = wxshareid,title = PlatformLua.playform.PlatformName,url = PlatformLua.playform.WXShareUrl,description = PlatformLua.playform.WXShareDescription};								
 									
    WXPayUtil.OnWeChatSendWeb(isTimeline,callbackGameObject,Util.packJSONObjectLua(cjson.encode(tempjsonMsg)))								
end								
								
function this.OnWechatSendWebCallback(pMessage)								
    print('pMessage') 								
									
	if tonumber(pMessage) == 0 then								
		EginProgressHUD.Instance:ShowPromptHUD("分享成功")								
		if this.WeChatStatus[this.tyeptbon] ~= 2  then 								
			this:onWeChatShare()  								
		end 								
	end 								
end								
								
function this:WeChatVisitWeb(pUrl)								
    print('wechat visit web  ')								
    WXPayUtil.OnClick_WebActivity(pUrl)								
end								
								
								
								
function this.GetWeChatShareStatus() 								
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);								
	Hall.mono:Request_lua_fun("AccountService/get_share_award_info","",function(message) 								
			local tMsg = cjson.decode(message) 								
				this.WeChatStatus = tMsg								
			this:FreeInit()								
			EginProgressHUD.Instance:HideHUD();								
	end,function (message) 								
		EginProgressHUD.Instance:ShowPromptHUD(message)								
	end) 								
end								
--分享有奖 奖励类型      1绑定微信, 2微信首次邀请, 3appstore好评, 4微信分享								
function this.WeChatShareNet(pType)								
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);								
	local tBody = {}								
	tBody['type'] = pType								
	if pType == 5 then								
		tBody['phone'] = EginUser.Instance.telephone 								
	end 								
	if PlatformLua.playform.shareGetCoinCount==0 and (pType==2 or pType==4 or pType==1) then								
		return								
	end								
	Hall.mono:Request_lua_fun("AccountService/share_award",cjson.encode(tBody),function(message) 								
		local tMsg = cjson.decode(message)								
		this.WeChatStatus = tMsg 								
										
		Module_Task:FreeInit()								
		EginProgressHUD.Instance:HideHUD();								
		--分享成功操作								
	end,function (message)								
		EginProgressHUD.Instance:ShowPromptHUD(message)								
	end) 								
end								
--获取奖励   奖励类型  1绑定微信, 2微信首次邀请, 3appstore好评, 4微信分享								
function this.GetWeChatShareAward(pType)								
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);								
	local tBody = {}								
	tBody['type'] = pType								
								
	if PlatformLua.playform.shareGetCoinCount==0 and (pType==2 or pType==4 or pType==1) then								
		return								
	end								
								
	Hall.mono:Request_lua_fun("AccountService/pick_share_award",cjson.encode(tBody),function(message) 								
		log("================="..message)								
		local tMsg = cjson.decode(message)								
		this.WeChatStatus = tMsg 								
		EginUser.Instance.bankMoney = EginUser.Instance.bankMoney+tMsg[6];								
		  Hall.transform:FindChild("Info/UserInfo/BankMoney/Lab_BankMoney"):GetComponent("UILabel").text = EginUser.Instance.bankMoney;								
		  Module_Task:FreeInit()								
		 EginProgressHUD.Instance:ShowPromptHUD("领取成功!")								
		--获取奖励成功操作								
	end,function (message)								
		EginProgressHUD.Instance:ShowPromptHUD(message)								
	end) 								
end								
								
function this:send_phone_code(typeSend,v_phone,tempFun)								
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);								
	Hall.mono:Request_lua_fun("AccountService/send_phone_code1", cjson.encode( {mobile=v_phone,type=typeSend} ),								
	function(result)								
		 EginProgressHUD.Instance:ShowPromptHUD("已发送验证码,请注意查收!"); 								
		 tempFun();								
	end, 								
	function(result) 								
		EginProgressHUD.Instance:ShowPromptHUD(result);  								
	end); 								
end								
function this:bind_phone(typeSend,v_phone,v_charcode,tempFun)								
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);								
	Hall.mono:Request_lua_fun("AccountService/bind_phone", cjson.encode( {charcode=v_charcode,phone=v_phone,type=typeSend} ),								
	function(result)								
		if typeSend == 1 then								
			EginProgressHUD.Instance:ShowPromptHUD("绑定成功"); 								
			--渠道处理								
			Module_Channel.Instance:handleBindPhoneGetAccount()								
		else								
			EginProgressHUD.Instance:ShowPromptHUD("解绑成功"); 								
		end  								
		EginUser.Instance.phone= v_phone								
		EginUser.Instance.telephone = EginUser.Instance.phone								
		EginUser.Instance.bindPhone = 1;								
		 tempFun(); 								
	end, 								
	function(result) 								
		EginProgressHUD.Instance:ShowPromptHUD("网络连接失败!");  								
	end); 								
end								
							
							
 							
						
						
function this:autoGetUI()
	 this.ui_bindPhoneUserNameLabel=this.transform:FindChild("Offset/MobilePhone/MobilePhone/Views/Username/LabelName").gameObject:GetComponent("UILabel")	
	 this.ui_bindPhoneUserPhoneInput=this.transform:FindChild("Offset/MobilePhone/MobilePhone/Views/MobilePhone/Input").gameObject:GetComponent("UIInput")	
	 this.ui_bindPhoneValidationInput=this.transform:FindChild("Offset/MobilePhone/MobilePhone/Views/Validation/Input").gameObject:GetComponent("UIInput")	
	 this.ui_bindPhoneBackBtn=this.transform:FindChild("Offset/MobilePhone/MobilePhone/btn_back").gameObject	
	 this.ui_bindPhoneSubBtn=this.transform:FindChild("Offset/MobilePhone/MobilePhone/Views/Button_Submit").gameObject	
	 this.ui_bindPhoneCodeBtn=this.transform:FindChild("Offset/MobilePhone/MobilePhone/Views/Validation/btnMobilePhone").gameObject	
	 this.ui_bindPhonePanel=this.transform:FindChild("Offset/MobilePhone").gameObject	
	 this.ui_backBtn=this.transform:FindChild("Offset/Button_Back/ImageButton").gameObject	
	 this.ui_helpBtn=this.transform:FindChild("Offset/Button_Back/Button_help").gameObject	
	 this.ui_tabNoticeBtn=this.transform:FindChild("tabs/tabNoticeBtn").gameObject	
	 this.ui_tabVerBtn=this.transform:FindChild("tabs/tabVerBtn").gameObject	
	 this.ui_tabTaskBtn=this.transform:FindChild("tabs/tabTaskBtn").gameObject	
end 						
function this:autoClearUI()
	 this.ui_bindPhoneUserNameLabel=nil	
	 this.ui_bindPhoneUserPhoneInput=nil	
	 this.ui_bindPhoneValidationInput=nil	
	 this.ui_bindPhoneBackBtn= nil	
	 this.ui_bindPhoneSubBtn= nil	
	 this.ui_bindPhoneCodeBtn= nil	
	 this.ui_bindPhonePanel= nil	
	 this.ui_backBtn= nil	
	 this.ui_helpBtn= nil	
	 this.ui_tabNoticeBtn= nil	
	 this.ui_tabVerBtn= nil	
	 this.ui_tabTaskBtn= nil	
end 						
					
				
			
		
	

