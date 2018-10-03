
local this = LuaObject:New()
Module_Recharge_iOS = this

function this:Awake()
	this.mono:AddClick(this.transform:FindChild("Offset/Background Top/Button_Back - Anchor/ImageButton").gameObject, this.OnClickBack,this)
end
function this:Start ()  
	
	 WXPayUtil.StartIOSStartRecharge(EginUser.Instance.uid);
end
function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	this.GameFunction = nil
	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
end


function this:DoRechargeSucess ()   
	coroutine.start(this.RechargeFinished,this);  
end

function this:DoRechargeCancel ()  
	coroutine.start(this.RechargeFinished,this);  
end

function this:RechargeFinished () 
local url = ConnectDefine.MAIL_DETAIL_URL..mailCell.name.."/";
	local form = UnityEngine.WWWForm.New();
	
	if(HttpResult.ResultType.Sucess == result.resultType)then
		kDetailContent.text = result.resultObject:ToString() ;
		vDetail.name = mailCell.name;
		vDetail:SetActive(true);
	else 
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
	end


	EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWaitUpdateUserinfo"));
	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.UPDATE_USERINFO_URL, nil);
	 
	coroutine.www(www);
	local result = HttpConnect.Instance:UpdateUserinfoResult(www);
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess ~= result.resultType) then
		local promptTime = 2;
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject, promptTime);
		coroutine.wait(promptTime) 
	end
	
	if (PlatformGameDefine.playform.IOSPayFlag)  then
		this.mono:EginLoadLevel("Module_Recharge");
	else
		if this.GameFunction ~= nil then
			this.GameFunction();
		else 
			this.mono:EginLoadLevel("Hall");
		end 
	end
end

function this:OnClickBack ()   
	if this.GameFunction ~= nil then
		this.GameFunction();
	else 
		this.mono:EginLoadLevel("Hall");
	end 
	
end











