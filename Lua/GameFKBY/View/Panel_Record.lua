local this = LuaObject:New()
Panel_Record = this;

local button_close;
local vRecords;
local recordPrefab;
local recordPage = 1;
local maxRecordPage = 1;
local recordPageSize = 5;

local cjson = require "cjson"
function this.Awake(  )
	this.InitPanel();
end
function this.InitPanel(  )
	button_close = this.transform:FindChild("Button_close").gameObject;
	vRecords = this.transform:FindChild("Scroll View/Grid");
	--
	recordPrefab = this.transform:FindChild("").gameObject;

	this.mono:AddClick(button_close,this.Hide);
end
function this.OnEnable(  )
	coroutine.start(this.OnLoadRecord,recordPage);
    --if Global.instance.isMobile == false then
    --    UIHelper.On_UI_Show(this.gameObject);
    --end
end
function this.OnLoadRecord(page)
	if page > 0 and page <= maxRecordPage then
		UIHelper.ShowProgressHUD(nil,"");
		local form = UnityEngine.WWWForm.New();
		form:AddField("pageindex",page);
		form:AddField("pagesize", recordPageSize);
		local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.GAME_RECORD_URL,form);
		coroutine.www(www);
		UIHelper.HideProgressHUD();

		print(www.text);
	--解析
		local js = cjson.decode(www.text);
		if js["result"] == "ok" then
			this.UpdateRecord(js["body"]);
		else
			UIHelper.ShowMessage(js["body"],2);
		end
	end
end
function this.OnClickLastRecord(  )
	local _page = recordPage -1;
	coroutine.start(this.OnLoadRecord,_page);
end
function this.OnClickNextRecord(  )
	local _page = recordPage+1;
	coroutine.start(this.OnLoadRecord(_page));
end
function this.UpdateRecord( obj )
	recordPage = obj["page"]["pageindex"];
	maxRecordPage = obj["page"]["pagecount"];
	EginTools.ClearChildren(vRecords);
	local recordInfoList = obj["data"];
	local j = 0;
	for i=1,#recordInfoList do
		if recordInfoList[i] == "" then break; end

		local cell = GameObject.Instantiate(recordPrefab);
		cell.transform.parent = vRecords;
		cell.transform.localPosition = Vector3.New(0,j*-100,0);
		cell.transform.localScale = Vector3.one;

		local actionTime = recordInfoList[i]["end_time"];
		if string.len(actionTime) > 10 then actionTime = string.sub(actionTime,0,10) end
		cell.transform:Find("Label_0"):GetComponent("UILable").text = recordInfoList[i]["game_type"]..recordInfoList[i]["room_type"];
		cell.transform:Find("Label_1"):GetComponent("UILable").text = recordInfoList[i]["win_money"];
		cell.transform:Find("Label_2"):GetComponent("UILable").text = recordInfoList[i]["start_money"];
		cell.transform:Find("Label_3"):GetComponent("UILable").text = recordInfoList[i]["end_money"];
		cell.transform:Find("Label_4"):GetComponent("UILable").text = actionTime;
		if 1%2 ~= 0 then cell.transform:Find("translucence").gameObject:SetActive(false); end
		j = j+1;
	end
end
function this.Hide()
	--if Global.instance.isMobile == false then
    --    Panel_Follow.HidePanel(this.gameObject);
    --else
        this.gameObject:SetActive(false);
    --end
end