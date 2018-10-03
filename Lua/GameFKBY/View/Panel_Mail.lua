local this = LuaObject:New()
Panel_Mail = this

local vInbox;
local mailPrefab;
local inboxPage = 1;
local maxInboxPage = 1;
local inboxPageSize = 100;

local vDetail;
local kDetailContent;

local kSendNickname;
local kSendTitle;
local kSendContent;

local button_send;
local button_close2;
local button_delete;

local btn_close;
local mailState;

local cjson = require "cjson"
require "System/Coroutine";

function this.Start()
	--Lua_UIHelper.UIShow(this.gameObject);
	this.InitPanel();

end

function this.OnEnable( ... )
	-- body
	coroutine.start(this.OnLoadRecord,inboxPage);
	mailState = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_mail/Sprite");
    --if Global.instance.isMobile == false then
    --    UIHelper.On_UI_Show(this.gameObject);
    --end
end

--初始化面板--
function this.InitPanel()
	vInbox = this.transform:Find("Content 1/Mails/Grid"):GetComponent("UIGrid");
	mailPrefab = this.transform:Find("Content 1/Mails/Mail_Cell").gameObject;
	button_send = this.transform:Find("Content 2/Button_send").gameObject;
	button_close2 = this.transform:Find("Content 1/Views/Button_close2").gameObject;
	button_delete = this.transform:Find("Content 1/Views/Button_delete").gameObject;

	kSendNickname = this.transform:Find("Content 2/addressee/Label"):GetComponent("UILabel");
	kSendTitle = this.transform:Find("Content 2/title/Label"):GetComponent("UILabel");
	kSendContent = this.transform:Find("Content 2/content/Label"):GetComponent("UILabel");

	vDetail = this.transform:Find("Content 1/Views").gameObject;
	kDetailContent = this.transform:Find("Content 1/Views/vLabel/Scroll View/Label"):GetComponent("UILabel");

	btn_close = this.transform:FindChild("Button_close").gameObject;
    this.mono:AddClick(btn_close,this.Hide);
    this.mono:AddClick(button_send,this.ButtonMailHandle);

    
end

function this.Hide()
	--if Global.instance.isMobile == false then
    --    Panel_Follow.HidePanel(this.gameObject);
    --else
        this.gameObject:SetActive(false);
    --end
end

function this.OnLoadRecord( page )
	-- body
	if page > 0 and page <= maxInboxPage then
		UIHelper.ShowProgressHUD(nil,"");

		local form = UnityEngine.WWWForm.New();
		form:AddField("pageindex",page);
		form:AddField("pagesize",inboxPageSize);
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.MAIL_LIST_URL,form);
		coroutine.www(www);
		UIHelper.HideProgressHUD();

		local js = cjson.decode(www.text);
		local info = js["body"];
		if js["result"] == "ok" then
			this.UpdateInbox(info);
		else
			UIHelper.ShowMessage(info,1);
		end
	end
end

function this.UpdateInbox( obj )
	-- body
	EginTools.ClearChildren(vInbox.transform);
	local  mailList = obj["data"];
	for k,v in pairs(mailList) do
		local mailObj = v;
		if mailObj == cjson.null then break end

		local cell = GameObject.Instantiate(mailPrefab);
		cell.transform.parent = vInbox.transform;
        cell.transform.localScale = Vector3.one;
        cell.transform.localPosition = Vector3.zero;

        local mailInfo = cell:AddComponent(Type.GetType("MailInfo",true));
        local sp_mailState = cell.transform:Find("state"):GetComponent("UISprite");
		sp_mailState.spriteName = "e_mail 1";
        if mailObj["read"] == "1"then
        	mailInfo.isRead = true;
        	sp_mailState.spriteName = "e_mail 2";
        end
		sp_mailState:MakePixelPerfect();
        --mailInfo:InitWithJson(mailObj);
        cell.name = mailObj["id"];
        cell.transform:Find("Label_Sender"):GetComponent("UILabel").text = mailObj["nickname"];
        cell.transform:Find("Label_Title"):GetComponent("UILabel").text = mailObj["title"];
        cell.transform:Find("Label_Time"):GetComponent("UILabel").text = mailObj["send_time"];

        cell:SetActive(true);
        this.mono:AddClick(cell,this.MailDetail);
	end
	vInbox.repositionNow = true;
end

function this.MailDetail(go)
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
    coroutine.start(this.OnClickMailDetial,go);
end

function this.OnClickMailDetial( mailCell )
	-- body
	UIHelper.ShowProgressHUD(nil,"");
	local url = ConnectDefine.MAIL_DETAIL_URL .. mailCell.name .. "/";
	local www = HttpConnect.Instance:HttpRequestWithSession(url, nil);
	coroutine.www(www);
	UIHelper.HideProgressHUD();
	local js = cjson.decode(www.text);
	local info = js["body"];
	if js["result"] == "ok" then
		kDetailContent.text = info;
		local mailInfo = mailCell:GetComponent("MailInfo");
		if mailInfo.isRead == false then
			mailInfo.isRead = true;
			local sp_mailState = mailCell.transform:Find("state"):GetComponent("UISprite");
			sp_mailState.spriteName = "e_mail 2";
			sp_mailState:MakePixelPerfect();
			mailState:SetActive(false);
			this.UpdateNewMailState();
		end
		vDetail.name = mailCell.name;
		Panel_Follow.ShowPanel(vDetail);
		UIHelper.On_UI_Show(vDetail);
		this.mono:AddClick(button_delete,this.ButtonMailDetailHandle);
		this.mono:AddClick(button_close2,this.ButtonMailDetailHandle);
	else
		UIHelper.ShowMessage(info,1);
	end
end

function this.UpdateNewMailState()
	-- body
	local num = vInbox.transform.childCount - 1;
	for i=0,num do
		local mailInfo = vInbox.transform:GetChild(i):GetComponent("MailInfo");
		if mailInfo.isRead == false then
			mailState:SetActive(true);
			break;
		end
	end
end

function this.ButtonMailDetailHandle( go )
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
	if go.name == button_delete.name then
		coroutine.start(this.OnClickMailDelete);
	elseif go.name == button_close2.name then
		Panel_Follow.HidePanel(vDetail);
	end
end

function this.OnClickMailDelete()
	-- body
	UIHelper.ShowProgressHUD(nil,"");

    local url = ConnectDefine.MAIL_DELETE_URL .. vDetail.name .. "/";
    local www = HttpConnect.Instance:HttpRequestWithSession(url, nil);
    coroutine.www(www);

    UIHelper.HideProgressHUD();
    local js = cjson.decode(www.text);
	local info = js["body"];
    if js["result"] == "ok" then
        Panel_Follow.HidePanel(vDetail);
        coroutine.start(this.OnLoadRecord,inboxPage);
    else
        UIHelper.ShowMessage(info,1);
    end
end

function this.ButtonMailHandle( go )
	-- body
	AudioHelper.getInstance():PlayOnClickAudio("onClick");
	this.OnClickSend();
end

function this.OnClickSend( ... )
	-- body
	local errorinfo = "";
	if string.len(kSendNickname.text) == 0 then
		errorinfo = "MailSendNickname";
	elseif string.len(kSendTitle.text) == 0 then
		errorinfo = "MailSendTitle";
	elseif string.len(kSendContent.text) == 0 then
		errorinfo = "MailSendContent";
	end
	if string.len(errorinfo) > 0 then
		UIHelper.ShowMessage(errorinfo,1);
	else
		coroutine.start(this.DoClickSend);
	end
end

function this.DoClickSend( ... )
	-- body
	UIHelper.ShowProgressHUD(nil,"");
	local form = UnityEngine.WWWForm.New();
	form:AddField("to_nickname",kSendNickname.text);
	form:AddField("mail_title",kSendTitle.text);
	form:AddField("mail_content",kSendContent.text);
	local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.MAIL_SEND_URL,form);
	coroutine.www(www);
	UIHelper.HideProgressHUD();
	local js = cjson.decode(www.text);
	local info = js["body"];
    if js["result"] == "ok" then
        UIHelper.ShowMessage("HttpConnectSucess",1);
        kSendNickname.text = "";
        kSendTitle.text = "";
        kSendContent.text = "";
    else
        UIHelper.ShowMessage(info,1);
    end
end