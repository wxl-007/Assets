local cjson = require "cjson"
local this = LuaObject:New()
Module_GameRecord = this


function this:Awake()
	this.vRecords=this.transform:FindChild("Offset/Views/Record/Table");
	this.recordPrefab=ResManager:LoadAsset("happycity/GameRecord_Record","GameRecord_Record");
	this.kRecordPage=this.transform:FindChild("Offset/Views/Record/Page/Label_Page").gameObject:GetComponent("UILabel");
	this.recordPage = 1;
	this.maxRecordPage = 1;
	this.recordPageSize = 5;
	
	
	this.mono:AddClick(this.transform:FindChild("Offset/Background Top/Button_Back - Anchor/ImageButton").gameObject, this.OnClickBack,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Record/Page/Button_Last").gameObject, this.OnClickLastRecord,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Record/Page/Button_Next").gameObject, this.OnClickNextRecord,this)
end

function this:Start ()  
	if (PlatformGameDefine.playform.IsSocketLobby) then 
		this.mono:StartSocket(false);
		this:sendGameRecordSocket(this.recordPage);
	else
		coroutine.start(this.OnLoadRecord,this,this.recordPage);
	end
end
function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	
	this.vRecords=nil;
	this.recordPrefab=nil;
	this.kRecordPage=nil;
	this.recordPage = 1;
	this.maxRecordPage = 1;
	this.recordPageSize = 5;
	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
end
function this:OnClickBack ()   
	this.mono:EginLoadLevel("Hall");
end
  
function this:OnLoadRecord ( page) 
	if (page > 0 and page <= this.maxRecordPage)  then
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

		local form = UnityEngine.WWWForm.New();
		form:AddField("pageindex", page);
		form:AddField("pagesize", this.recordPageSize);
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
	this.mono:Request_lua_fun("AccountService/game_record",cjson.encode({start_date=pastDate,end_date= nowDate,pageindex= page,pagesize=this.recordPageSize,game_type= 0}), 
	function(message)
		EginProgressHUD.Instance:HideHUD(); 
		local messageObj = cjson.decode(message);  
		this:UpdateRecord(messageObj);
	end, 
	function(message)  
		EginProgressHUD.Instance:ShowPromptHUD(message);
	end)
end

function this:SocketDisconnect ( disconnectInfo) 
	--SocketManager.LobbyInstance.socketListener = nil;
end
 

function this:OnClickLastRecord () 
	local page = this.recordPage - 1;
	if (PlatformGameDefine.playform.IsSocketLobby) then
		this:sendGameRecordSocket(page);
	else
		coroutine.start(this.OnLoadRecord,this,page); 
	end

end
function this:OnClickNextRecord () 
	local page = this.recordPage + 1;
	if (PlatformGameDefine.playform.IsSocketLobby) then
		this:sendGameRecordSocket(page);
	else
		coroutine.start(this.OnLoadRecord,this,page); 
	end
end
 
function this:UpdateRecord ( obj) 
 
	this.recordPage = tonumber(obj["page"]["pageindex"]);
	this.maxRecordPage = tonumber(obj["page"]["pagecount"]);
	this.kRecordPage.text = this.recordPage.."/"..this.maxRecordPage;

	EginTools.ClearChildren(this.vRecords);
	local recordInfoList = obj["data"];
 
	for i = 0 ,#(recordInfoList)-1   do
		local recordInfo = recordInfoList[i+1]
		if (type(recordInfo)  ~= "table") then break; end

		local cell = GameObject.Instantiate(this.recordPrefab);
		cell.transform.parent = this.vRecords;
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

function this:Process_account_login(info)
    this:sendGameRecordSocket(this.recordPage);
end