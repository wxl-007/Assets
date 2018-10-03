
local this = LuaObject:New()
Module_Activity = this 

function this:Awake()    
	
	-- this.ActivityTime = this.transform:FindChild("Offset/panel/ActivityTime"):GetComponent("UILabel");	
	--  this.MyInfo = this.transform:FindChild("Offset/panel/Info")
	--  this.redNum = this.MyInfo:FindChild("redNum"):GetComponent("UILabel");
	--   this.glodNum = this.MyInfo:FindChild("glodNum"):GetComponent("UILabel");
	--    this.levelNum = this.MyInfo:FindChild("levelNum"):GetComponent("UILabel");
	
	-- this.ViewsView = this.transform:FindChild("Offset/Views"):GetComponent("UIScrollView");
	--    this.freeGrid = this.transform:FindChild("Offset/Views/free"):GetComponent("UIGrid");
	 
	--  this.cell = ResManager:LoadAsset("HappyCity/Module_Activity","ActivityCell");
	 
	-- this.mono:AddClick( this.transform:FindChild("Offset/Button").gameObject,function ( ) 
	-- 	--发送抽奖请求请求
	-- 	 EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
		 
	-- 	this.socketObj.mono:Request_lua_fun("AccountService/lottery", cjson.encode( {action="luck",spath="midautumn",lottall=1,flag="0"} ),
	-- 	function(result)
	-- 		log("===valentine_default===="..result)
	-- 		--{"body": {"prop_num": [0, 0], "getinfo": [[-2, 0, 6], [-1, 100, 1], [-1, 200, 0], [-1, 300, 0], [-2, 0, 0]], 
	-- 		--"usenum": 7, "getjifen": 70, "award_num": 100}, "tag": "lottery", "type": "AccountService", "result": "ok"}
	-- 		local jsonData = cjson.decode(result);
	-- 		 EginProgressHUD.Instance:ShowPromptHUD("抽奖成功! 抢夺了".. jsonData["usenum"] .. "个红包,获得".. jsonData["award_num"] .. "游戏币."); 
	-- 		 this:InitData(this.socketObj);
	-- 	end, 
	-- 	function(result) 
	-- 		EginProgressHUD.Instance:ShowPromptHUD(result);  
	-- 	end); 
	-- end ) 
	this.mono:AddClick(this.transform:FindChild('topback/Button_Back').gameObject,function (  )
		HallUtil:PopupPanel('Hall',false,this.gameObject,nil)
	end)
	this.mono:AddClick(this.transform:FindChild('Item_1/Btn_Get').gameObject,function (  )
		HallUtil:PopupPanel('Module_Sign',true,nil,nil)
	end)
end

function this:Start()
     local sceneRoot = this.transform.root:GetComponent("UIRoot")
    if sceneRoot then 
        sceneRoot.manualHeight = 1920;
        sceneRoot.manualWidth = 1080;
    end
end
 function this:OnEnable()  
end  
function this:OnDisable()   
	-- EginTools.ClearChildren(this.freeGrid.transform); 
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
function this:InitData(socketObj) 
	this.socketObj = socketObj;
	--发送初始信息请求
	 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
	this.socketObj.mono:Request_lua_fun("AccountService/valentine_default", cjson.encode( {spath="midautumn"} ),
	function(result)
		EginProgressHUD.Instance:HideHUD(); 
		this:InitUI(result);
	end, 
	function(result) 
		EginProgressHUD.Instance:HideHUD(); 
		EginProgressHUD.Instance:ShowPromptHUD(result);  
	end); 
	  
end

function this:InitUI(result) 
	local count = this.freeGrid.transform.childCount;
   	if(count>0)then
	   	while(count>0) do
	   		GameObject.Destroy( this.freeGrid.transform:GetChild(count-1).gameObject );
	   		count = count-1;
	   	end
   	end
	 log("===valentine_default===="..result)
	 --{"body": {"rankdata": [{"is_award": 0, "usr_urid": 866627883, "usr_name": "f*r", "usr_mark": 0, "usr_rank": "1"}], 
	 --"cur_user": {"cusr_ncjq": 0, "cusr_numb": 0, "cusr_rank": {"count(*)": 1}}, 
	 --"end_date": "2017-02-04 11:00", "theme_path": "midautumn", "cur_activity_name": "\u5c81\u672b\u72c2\u6b22\u5b63", "start_date": "2017-01-11 00:30"}, "tag": "valentine_default", "type": "AccountService", "result": "ok"}
	 resultData = cjson.decode(result)
	 
	 this.redNum.text = resultData["cur_user"]["cusr_numb"]
	  this.glodNum.text = resultData["cur_user"]["cusr_ncjq"]
	   this.levelNum.text = resultData["cur_user"]["cusr_rank"]["count(*)"]
	   

	 for i, v in pairs(resultData["rankdata"]) do
		 local cell = GameObject.Instantiate(this.cell);
		cell.transform.parent = this.freeGrid.transform;
		cell.transform.localPosition =  Vector3.New(0,0, 0);
		cell.transform.localScale = Vector3.one;
		cell.transform:Find("level"):GetComponent("UILabel").text = tostring(v["usr_rank"]) ;
		cell.transform:Find("name"):GetComponent("UILabel").text =v["usr_name"];
		cell.transform:Find("num"):GetComponent("UILabel").text = v["usr_mark"];  
	end
	
	 this.freeGrid:Reposition()
	 this.ViewsView:ResetPosition(); 

	 if(resultData["start_date"] ~= nil)then
	 	local startTime = string.sub(resultData["start_date"], 1, -7);
	 	local endTime = string.sub(resultData["end_date"], 1, -7);
	 	this.ActivityTime.text = startTime .. " " .. endTime;
	 end
end