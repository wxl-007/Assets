local cjson = require "cjson"
local this = LuaObject:New()
Module_Mail = this
 
local vInbox;
local mailPrefab;
local kInboxPage;
local inboxPage = 1;
local maxInboxPage = 1;
local inboxPageSize = 7;

local vDetail;
local kDetailContent;

local kSendNickname;
local kSendTitle;
local kSendContent;
local curMailCellName;

local kMailList
function this:Awake()
	this:Init();
	
end

function this:Start()
	inboxPage = 1;
	if(PlatformGameDefine.playform.IsSocketLobby) then
		this.mono:StartSocket(false); 
		if PlatformGameDefine.playform.IOSPayFlag then
			this:getMailList(inboxPage)
		end 
	else
		coroutine.start(this.OnLoadRecord,this,inboxPage ); 
	end
        
end

function this:Init()
	this._MailInfo={};
	inboxPage = 1;
	maxInboxPage = 1;
	inboxPageSize = 7;
	
	vInbox = this.transform:FindChild("Offset/Views/Inbox/Mails");
	mailPrefab = ResManager:LoadAsset("HappyCity/Mail_Cell","Mail_Cell");
	kInboxPage = this.transform:FindChild("Offset/Views/Page/Label_Page"):GetComponent("UILabel");
	vDetail = this.transform:FindChild("Offset/Views/Panel (Detail)").gameObject;
	kDetailContent = this.transform:FindChild("Offset/Views/Panel (Detail)/Info/Label"):GetComponent("UILabel");
	kSendNickname  = this.transform:FindChild("Offset/Views/WritePanel/TextInput_Sender/Input/Label"):GetComponent("UILabel");
	kSendTitle  = this.transform:FindChild("Offset/Views/WritePanel/TextInput_Title/Input/Label"):GetComponent("UILabel");
	kSendContent  = this.transform:FindChild("Offset/Views/WritePanel/TextInput_Content/Input/Label"):GetComponent("UILabel");
	kPage = this.transform:FindChild('Offset/Views/Page').gameObject
	mailTitle = this.transform:FindChild('Offset/Views/Panel (Detail)/Info/Title'):GetComponent('UILabel')
	mailDate = this.transform:FindChild('Offset/Views/Panel (Detail)/Info/date'):GetComponent('UILabel')
	
	this.mono:AddClick(this.transform:FindChild("Offset/Background Top/Button_Back - Anchor/ImageButton").gameObject, this.OnClickBack,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Panel (Detail)/Info/Button_Close").gameObject, this.OnClickMailClose,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Panel (Detail)/Info/Button_Delete").gameObject, this.OnClickMailDelete,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Page/Button_Last").gameObject, this.OnClickLastRecord,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Page/Button_Next").gameObject, this.OnClickNextRecord,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/WritePanel/Button_Send").gameObject, this.OnClickSend,this)

	this.mono:AddClick(this.transform:FindChild('Offset/Options/Option_0').gameObject,function ( )
		-- if this.transform:FindChild('Offset/Views/Inbox/Empty').gameObject.activeSelf == true then 
			kPage:SetActive(false)
		-- end
	end)

end

function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	
	this._MailInfo=nil;
	vInbox = nil;
	mailPrefab = nil;
	kInboxPage = nil;
	inboxPage = 1;
	maxInboxPage = 1;
	inboxPageSize = 7;

	vDetail = nil;
	kDetailContent = nil;

	kSendNickname = nil;
	kSendTitle = nil;
	kSendContent = nil;
	curMailCellName = nil;
	
	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
end

function this:OnClickBack ()   
	-- this.mono:EginLoadLevel("Hall");
	this:ShowPanel('Hide')
end


--http functions
function this:OnLoadRecord(page)

	if(page>0 and page<=maxInboxPage)then
		 EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
		 local form = UnityEngine.WWWForm.New();
		 form:AddField("pageindex", page);
		 form:AddField("pagesize", inboxPageSize);
		 local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.MAIL_LIST_URL, form);
		 coroutine.www(www);
		 local result = HttpConnect.Instance:BaseResult(www);
		 EginProgressHUD.Instance:HideHUD();
		 
		 if(HttpResult.ResultType.Sucess == result.resultType)then
		 	kMailList = cjson.decode(result.resultObject:ToString())
		 	this:UpdateInbox(kMailList);
		 else
		 	EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
		 end
	end
end

 --http functions
function this:DoClickSend()
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

	local form = UnityEngine.WWWForm.New();
	form:AddField("to_nickname", kSendNickname.text);
	form:AddField("mail_title", kSendTitle.text);
	form:AddField("mail_content", kSendContent.text);
	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.MAIL_SEND_URL, form);
	coroutine.www(www);
	local result = HttpConnect.Instance:BaseResult(www);
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)then
		EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"));
		kSendNickname.text = "";
		kSendTitle.text = "";
		kSendContent.text = "";
	else
		EginProgressHUD.Instance:ShowPromptHUD(Util.ObjToString(result.resultObject));
	end
end
function this:SocketDisconnect( disconnectInfo )
	Utils.ClearListener();
end

function this.SocketReceiveMessage( message)
	 
	local messageObj = cjson.decode(message);
	local type =  tostring(messageObj["type"]);
	local tag =  tostring(messageObj["tag"]);
	if(type == "AccountService") then
		EginProgressHUD.Instance:HideHUD();
		if(tag == "mail_list") then
			if( tostring(messageObj["result"]) == "ok") then
				this:UpdateInbox(messageObj["body"]);
			else
				EginProgressHUD.Instance:ShowPromptHUD( tostring(messageObj["result"]));
			end 
		elseif(tag == "mail_write") then
			--"type":AccountService,"tag": mail_write,"body":'成功'  "result":'ok' --成功ok ,失败为说明end
			if( tostring(messageObj["result"]) == "ok") then
				--EginUserUpdate.Instance.UpdateInfo()
				EginProgressHUD.Instance:ShowPromptHUD(ZPLocalization.Instance:Get("HttpConnectSucess"));
				kSendNickname.text = "";
				kSendTitle.text = "";
				kSendContent.text = "";
			else
				EginProgressHUD.Instance:ShowPromptHUD( tostring(messageObj["body"]));
			end
		 elseif(tag == "mail_read") then
			--"type":AccountService,"tag": mail_read, "body":邮件内容 "result":'ok' --成功ok ,失败为说明 end
			if( tostring(messageObj["result"]) == "ok") then
				kDetailContent.text = tostring( messageObj["body"]) ;
				vDetail.name = curMailCellName;
				vDetail:SetActive(true);
			else
				EginProgressHUD.Instance:ShowPromptHUD( tostring(messageObj["result"]));
			end 
		 elseif(tag == "mail_delete") then
			--"type":AccountService,"tag": mail_delete,"body":'成功' "result":'ok' --成功ok ,失败为说明end
			if( tostring(messageObj["result"]) == "ok") then
				vDetail:SetActive(false);
				this:getMailList(inboxPage);
			else
				EginProgressHUD.Instance:ShowPromptHUD( tostring(messageObj["result"]));
			end
		end
	end
end

function this:getMailList( page)

	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false); 
	local nowDate = System.DateTime.Now:ToString("yyyy-MM-dd");
	local pastDate = System.DateTime.Now:AddMonths(-1):ToString("yyyy-MM-dd");
	 
	local messageBody = {box="in",pageindex= page,pagesize=inboxPageSize,type= -1,status= -1}
	this.mono:Request_lua_fun("AccountService/mail_list",cjson.encode(messageBody),
	function(message) 
	end, 
	function(message)  
		EginProgressHUD.Instance:ShowPromptHUD(message);
	end);
 
end
function this:deleteMail( mid)

	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
 
	local messageBody = {mid=mid }
	this.mono:Request_lua_fun("AccountService/mail_delete",cjson.encode(messageBody),function(message) 
		vInbox.gameObject:SetActive(true)
		kPage:SetActive(true)
	end, 
	function(message)  
		EginProgressHUD.Instance:ShowPromptHUD(message);
	end);
end
function this:getMailDetail( mid)

	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
  	
	local messageBody = {mid=tonumber(mid) }
	local tMInfo = this:GetMailInfo(mid)
	this.mono:Request_lua_fun("AccountService/mail_read",cjson.encode(messageBody),function(message) 
		vInbox.gameObject:SetActive(false)
		kPage:SetActive(false)
		mailDate.text = tMInfo.sendTime
		mailTitle.text = tMInfo.title
	end, 
	function(message)  
	EginProgressHUD.Instance:ShowPromptHUD(message);
	end);
end


function this:OnClickLastRecord () 
	local page = inboxPage - 1;
	if(page>0 and page<=maxInboxPage)then
		 if (PlatformGameDefine.playform.IsSocketLobby) then
			this:getMailList(page);
		else 
			coroutine.start(this.OnLoadRecord,this,page); 
		end
	end
	
end
function this:OnClickNextRecord () 
	local page = inboxPage + 1;
	if(page>0 and page<=maxInboxPage)then
		 if (PlatformGameDefine.playform.IsSocketLobby) then
			this:getMailList(page);
		else 
			coroutine.start(this.OnLoadRecord,this,page); 
		end
	end
	
end

function this:OnClickSend () 
	local errorInfo = "";
	if (string.len(kSendNickname.text) == 0)  then
		errorInfo = ZPLocalization.Instance:Get("MailSendNickname");
	elseif (string.len(kSendTitle.text) == 0) then
		errorInfo = ZPLocalization.Instance:Get("MailSendTitle");
	elseif (string.len(kSendContent.text) == 0) then
		errorInfo = ZPLocalization.Instance:Get("MailSendContent");
	end

	if (string.len(errorInfo) > 0)  then
		EginProgressHUD.Instance:ShowPromptHUD(errorInfo);
	else 
		if (PlatformGameDefine.playform.IsSocketLobby) then
			this:sendMail();
		else
			coroutine.start(this.DoClickSend,this);  
		end
	end
end

function this:sendMail()
 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
	 
	local messageBody = {to_nickname=kSendNickname.text, mail_title=kSendTitle.text,mail_content=kSendContent.text}
	this.mono:Request_lua_fun("AccountService/mail_write",cjson.encode(messageBody),function(message) 
	end, 
	function(message)   
		EginProgressHUD.Instance:ShowPromptHUD(message);
	end);
end


function this:OnClickMailDetial ( mailCell) 
	if (PlatformGameDefine.playform.IsSocketLobby) then
		curMailCellName = mailCell.name;
		this:getMailDetail(mailCell.name);
		
	else
		coroutine.start(this.ClickMailDetial,this,mailCell); 
		
	end
end
function this:ClickMailDetial ( mailCell) 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

	local url = ConnectDefine.MAIL_DETAIL_URL..mailCell.name.."/";
	local form = UnityEngine.WWWForm.New();
	local www = HttpConnect.Instance:HttpRequestWithSession(url, nil);
	 
	coroutine.www(www);
	local result = HttpConnect.Instance:BaseResult(www);
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)then
		kDetailContent.text = result.resultObject:ToString() ;
		vDetail.name = mailCell.name;
		vDetail:SetActive(true);
	else 
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
	end
		 
end

function this:OnClickMailClose () 
	vDetail:SetActive(false);
	vInbox.gameObject:SetActive(true)
	-- kPage:SetActive(true)
end

function this:OnClickMailDelete () 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
	if (PlatformGameDefine.playform.IsSocketLobby) then
		this:deleteMail(vDetail.name); 
	else
		coroutine.start(this.ClickMailDelete,this); 
	end 
end
 function this:ClickMailDelete () 
	local url = ConnectDefine.MAIL_DELETE_URL .. vDetail.name .. "/";
	local form = UnityEngine.WWWForm.New();
	local www = HttpConnect.Instance:HttpRequestWithSession(url, form);
	coroutine.www(www);
	local result = HttpConnect.Instance:BaseResult(www);
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType)then 
		vDetail:SetActive(false);
		vInbox.gameObject:SetActive(true)
		coroutine.start(this.OnLoadRecord,this,inboxPage);   
	else 
		EginProgressHUD.Instance:ShowPromptHUD(result.resultObject); 
	end
end
function this:UpdateInbox ( obj) 
 
	inboxPage = tonumber(obj["page"]["pageindex"]);
	maxInboxPage = tonumber(obj["page"]["pagecount"]);
	if(maxInboxPage == 0)then
		kInboxPage.text = inboxPage.."/1";
	else
		kInboxPage.text = inboxPage.."/"..maxInboxPage;
	end
	

	EginTools.ClearChildren(vInbox);
	-- print('---------------')
	-- printf(obj['data'])
	local mailList = obj["data"];
	-- printf(mailList)
	if #(mailList) == 0 then 
		this.transform:FindChild('Offset/Views/Inbox/Empty').gameObject:SetActive(true)
		 kPage:SetActive(false)
	else
		this.transform:FindChild('Offset/Views/Inbox/Empty').gameObject:SetActive(false)
		kPage:SetActive(true)
	end 
	for i = 0 ,#(mailList)-1   do
		local mailObj = mailList[i+1] 
		if (type(mailObj)  ~= "table") then 
			break; 
		end
 		
		local cell = GameObject.Instantiate(mailPrefab);
		cell.transform.parent = vInbox;
		cell.transform.localPosition =  Vector3.New(0, i*-220, 0);
		cell.transform.localScale = Vector3.one;
		
		cell.name = tostring(mailObj["id"]) 
		local mailInfo =  this:GetMailInfo(cell.name) 
		mailInfo:InitWithJson(mailObj);
		
		cell.transform:FindChild("Label_Sender"):GetComponent("UILabel").text = (mailInfo.sender);
		cell.transform:FindChild("Label_Title"):GetComponent("UILabel").text = (mailInfo.title);
		cell.transform:FindChild("Label_Time"):GetComponent("UILabel").text = (mailInfo.sendTime);
		cell.transform:FindChild('Sprite_State'):GetComponent('UISprite').spriteName ='lobby01'
		cell.transform:FindChild('Sprite_Split'):GetComponent('UISprite').spriteName = 'pay22'
			cell.transform:FindChild("Label_Title"):GetComponent("UILabel").color = Color.New(180/255,0,0,1)
			cell.transform:FindChild("Label_Sender"):GetComponent("UILabel").color = Color.New(100/255,51/255,0,1)
		if mailInfo.isRead == true then 
			cell.transform:FindChild('Sprite_State'):GetComponent('UISprite').spriteName ='lobby02'
			cell.transform:FindChild('Sprite_Split'):GetComponent('UISprite').spriteName = 'pay21'
			cell.transform:FindChild("Label_Title"):GetComponent("UILabel").color = Color.New(100/255,51/255,0,1)
			cell.transform:FindChild("Label_Sender"):GetComponent("UILabel").color = Color.New(177/255,102/255,36/255,1)
		end 
		--添加事件 
		this.mono:AddClick(cell, this.OnClickMailDetial,this)
	end
end 

function this:GetMailInfo(tbName)
	
	local temp = this._MailInfo[tbName]
	if temp == nil then
		this._MailInfo[tbName] = MailInfo:New(tbObj);
		temp = this._MailInfo[tbName]
	end
	return temp
end
function this:ReplaceNameMailInfo(oldName,newName) 
	if oldName ~= newName then
		local temp = this._MailInfo[oldName]
		if temp ~= nil then
			this._MailInfo[newName] = temp
			this._MailInfo[oldName] = nil
		end
	end
end
function this:RemoveMailInfo(tbName) 
	this._MailInfo[tbName] = nil;
end 

--------------MailInfo对象------------
MailInfo = LuaObject:New() 
MailInfo.mailId = nil;
MailInfo.sender = "";
MailInfo.title = "";
MailInfo.sendTime = "";
MailInfo.isSystemMail = nil;
MailInfo.isRead = nil;
function MailInfo:New()
	local o ={};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self 
	return o;    --返回自身
end
 
function MailInfo:InitWithJson ( obj)
	self.mailId = tostring(obj["id"]) 
	self.title = tostring(obj["title"]) 
	self.isSystemMail = (tonumber(obj["mail_type"])  == 0); 
	self.isRead = (tonumber(obj["read"]) == 1); 
	self.sender = self.isSystemMail and ZPLocalization.Instance:Get("MailSystem") or tostring(obj["nickname"]) ; 
	self.sendTime = tostring(obj["send_time"]);
	if (string.len(self.sendTime) > 10) then  self.sendTime = string.sub(self.sendTime,1,10); end
	
end

function this:ShowPanel(pShowType)
	if pShowType == 'Show' then 
		-- ShowHallPanel(this.gameObject,true,nil,function ( )
		-- 	this.transform:FindChild('Black_Background').gameObject:SetActive(true)
		-- end)
	elseif pShowType =='Hide' then 
		HallUtil:PopupPanel('Hide',false,this.gameObject,nil)

		-- ShowHallPanel(this.gameObject,false,function ()
		-- 	EginProgressHUD.Instance:HideHUD()
		-- end,function (  )
		-- 	this.transform:FindChild('Black_Background').gameObject:SetActive(false)
		-- end)
	end
end