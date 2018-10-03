local this = LuaObject:New()
Module_Rooms = this

local mRooms;
local vRooms;
local kRoomCellPrefab;
local backBtn;
local alreadyInitRooms;

local scrollViewObj;

function this:Awake()
	this:init();
	EginProgressHUD.Instance:HideHUD();
end

function this:Start()
    if(PlatformGameDefine.playform.IsSocketLobby) then
        this.mono:StartSocket(false)
        EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
        alreadyInitRooms = false;
        coroutine.start(this.Send_get_rooms)
    else
        coroutine.start( this.DoLoadRooms);
    end
        
end

function this:clearLuaValue()
	mRooms = nil
	kRoomCellPrefab = nil
	vRooms = nil

	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	alreadyInitRooms = false;
	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
end

function this:init()
	-- this:ToPanel('Show')
	ProtocolHelper.entryRoom_password = "";
	kRoomCellPrefab = ResManager:LoadAsset("HappyCity/Room_Cell","Room_Cell");
	vRooms = this.transform:FindChild("Rooms/UIPanel (Clipped View)/UIGrid");
	scrollViewObj = this.transform:FindChild("Rooms/UIPanel (Clipped View)"):GetComponent("UIScrollView");
	backBtn = this.transform:FindChild("Background Top/Button_Back - Anchor/ImageButton").gameObject;
	this.mono:AddClick(backBtn, function ()
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
        -- Utils.LoadLevelGUI("Hall");
        this:ToPanel('Hall')
	end)

	--131
	this.panelConfirmPwd = this.transform:FindChild("PanelInputPwd").gameObject;
	this.inputLb = this.panelConfirmPwd.transform:FindChild("input"):GetComponent("UIInput");
	this.submitBtn = this.panelConfirmPwd.transform:FindChild("confirmBtn").gameObject;
	this.mono:AddClick(this.submitBtn, this.OnSubmitPwd);
	this.passwordRoomID = 30262;
end
function this.DoLoadRooms()
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);

	local rand = math.random()*100000;
	local  url = ConnectDefine.ROOM_LIST_URL .. PlatformGameDefine.game.GameID .. "/?room_type=" .. PlatformGameDefine.game.GameTypeIDs .. "&minv=20000&maxv=39999&"..rand;
	log("rooms-->" .. url);
	local www = HttpConnect.Instance:HttpRequest(url, null);
	coroutine.www(www);	
	local result = HttpConnect.Instance:RoomListResult(www);
	EginProgressHUD.Instance:HideHUD();
	if(HttpResult.ResultType.Sucess == result.resultType) then
		mRooms = result.resultObject;
		coroutine.start( this.LoadRooms );
	else
		this:Invoke(3.5, this.retry);
	end
end

function this:retry()
	coroutine.start(this.retryLoadRooms);
	EginProgressHUD.Instance:ShowWaitHUD("网络中断，重连中...", true);
end

function this:retryLoadRooms()
	PlatformGameDefine.playform:swithWebHostUrl(true,Utils.NullObj);
	local rand = math.random()*100000;
	local  url = ConnectDefine.ROOM_LIST_URL .. PlatformGameDefine.game.GameID .. "/?room_type=" .. PlatformGameDefine.game.GameTypeIDs .. "&minv=20000&maxv=39999&"..rand;
	local www = HttpConnect.Instance:HttpRequest(url, null);
	coroutine.www(www);	
	local result = HttpConnect.Instance:RoomListResult(www);
	if(HttpResult.ResultType.Sucess == result.resultType) then
		mRooms = result.resultObject;
		EginProgressHUD.Instance:HideHUD();
		coroutine.start( this.LoadRooms );
	else
		this:Invoke(3.5, this.retry);
	end
end

function this:Invoke( second, func )
	coroutine.wait(second);
	if(this.gameObject == nil)then
		error("##stop coroutine in Invoke")
		return;
	end
	func();
end

function this:OnSubmitPwd()
	ProtocolHelper.entryRoom_password = this.inputLb.value;
	if(mRooms[roomIndex] ~= nil)then
		SocketConnectInfo.Instance:Init(EginUser.Instance, mRooms[roomIndex]);
	end
    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
    Utils.LoadLevelGUI("Module_Desks");
end

function this.LoadRooms()
	local i = 0;
	local items = {};
	for i=0, mRooms.Count-1 do

		local room = mRooms[i];
		local roomCell = GameObject.Instantiate(kRoomCellPrefab).transform;
		table.insert(items, roomCell.gameObject);
		roomCell.name = "RoomCell_" .. i;
		roomCell.parent = vRooms;
		roomCell.localScale = Vector3(1,1,1);

		local roomOnlineNum = tonumber(room.onlineNum);
		local roomStatusInfo =  roomCell:FindChild('Sprite_Status'):GetComponent('UISprite')  --"(流畅)";
		-- local roomStatusColor = Color.New(140.0/255.0, 191.0/255.0, 85.0/255.0);
		local tRoomS = roomCell:FindChild('Button_Entry'):GetComponent('UISprite')
		if(roomOnlineNum<=10)then
			-- roomStatusInfo = "(空闲)";
			roomStatusInfo.spriteName = 'Image_L2'
			tRoomS.spriteName = 'Bg_leisure'
		elseif(roomOnlineNum <= 30)then
			-- roomStatusInfo = "(正常)";
			-- roomStatusColor = Color.New(253.0/255.0, 145.0/255.0, 3.0/255.0);
			roomStatusInfo.spriteName = 'Image_N1'
			tRoomS.spriteName = 'Bg_normal'
		elseif(roomOnlineNum > 80)then
			-- roomStatusInfo = "(拥挤)";
			roomStatusInfo.spriteName = 'Image_C1'
			-- roomStatusColor = Color.New(210.0/255.0, 94.0/255.0, 94.0/255.0);
			tRoomS.spriteName = 'Bg_Busy'
		end

		local roomStatus = roomCell:Find("Label_Count"):GetComponent("UILabel");
		-- roomStatus.text = roomStatusInfo;
		-- roomStatus.color = roomStatusColor;
		roomCell:Find("Label_Title"):GetComponent("UILabel").text = room.title;
		roomCell:Find("Label_Limit"):GetComponent("UILabel").text = room.minMoney .. "-" .. room.maxMoney;

		local roomEntry = roomCell:Find("Button_Entry");
		roomEntry.name = i.."";
		this.mono:AddClick(roomEntry.gameObject, this.OnClickRoomEntry, this, {roomEntry})
	end
	vRooms:GetComponent("UIGrid").repositionNow = true;
	vRooms.transform.localScale = Vector3(0.001,0.001,0.001);
	coroutine.wait(0.1);
	if(this.gameObject == nil)then
		error("##stop coroutine in LoadRooms")
		return;
	end
	vRooms.transform.localScale = Vector3(1,1,1);
	for m=1,#(items) do
		local vc3 = items[m].transform.localPosition;
		vc3.x = -2081;
		items[m].transform.localPosition = vc3;
		iTween.MoveTo(items[m],iTween.Hash("x",0,"islocal",true, "time",0.5,"delay", m*0.1));
	end
end

function this:OnClickRoomEntry(roomEntry, tb)
	local roomIndex = tonumber(tb[1].name);
        
        if(PlatformGameDefine.playform.IsSocketLobby) then----------socket方法--------
            if (roomIndex >0 and roomIndex <= #(mRooms)) then
                    this:InitConnectInfo(mRooms[roomIndex]);
--                    SocketConnectInfo.Instance:Init(EginUser.Instance, mRooms[roomIndex]);
                    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
                    
                    this:Get_Room_Info(mRooms[roomIndex])
            end
        else-------http 方法--------
            if (roomIndex >=0 and roomIndex < mRooms.Count) then
            	--131斗地主现场版房间
            	if(PlatformGameDefine.game.GameID == "1006" and PlatformGameDefine.game.GameTypeIDs == "20")then
            		this.panelConfirmPwd:SetActive(true);
            		this.passwordRoomID = mRooms[roomIndex];
            	else
            		SocketConnectInfo.Instance:Init(EginUser.Instance, mRooms[roomIndex]);
                    EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
                    Utils.LoadLevelGUI("Module_Desks");
            	end
            end
        end
end

----------------------获取房间信息---------------------
function this:Get_Room_Info(roomTable)
	--不再使用房间列表中的ip和host
    -- local json = {agentid=0,game_type=roomTable.game_type,room_level=roomTable.room_level,room_type=roomTable.room_type,usefront=1};
    -- SocketConnectInfo.Instance.roomHost = "";
    -- this.mono:Request_lua_fun("AccountService/ds_get_room",cjson.encode(json),--用于获取游戏ip和端口
        -- function(message)
            -- local mRoom = cjson.decode(message)
            -- EginProgressHUD.Instance:HideHUD();

            -- if(mRoom.host ~= nil) then SocketConnectInfo.Instance.roomHost = mRoom.host end--获取到ip和端口,就设置使用房间的ip和端口
            -- if(mRoom.port ~= nil) then SocketConnectInfo.Instance.roomPort = mRoom.port end
            if(PlatformGameDefine.game.GameID == "1006" and PlatformGameDefine.game.GameTypeIDs == "20")then
            	EginProgressHUD.Instance:HideHUD();
        		this.panelConfirmPwd:SetActive(true);
        	else
        		Utils.LoadLevelGUI("Module_Desks");
        	end
        -- end, 
        -- function(message)
            -- Utils.LoadLevelGUI("Module_Desks");--没有获取到就使用 conf 中获取的ip和端口
-- --            coroutine.start(this.Send_get_rooms)
-- --            EginProgressHUD.Instance.ShowPromptHUD(message);
-- --            Utils.LoadLevelGUI("Hall");
        -- end)
    
end


---------------------------------#region Socket相关---------------------------------------
-----------------请求房间列表---------------
function this.Send_get_rooms()
    local gameId = PlatformGameDefine.game.GameID
    local gameTypeIds = PlatformGameDefine.game.GameTypeIDs
--    local json = {type="AccountService",tag="get_rooms",body={agentid=-1,gt=gameId,maxv=39999,minv=20000,rt=gameTypeIds}};
    local json = {agentid=-1,gt=gameId,maxv=39999,minv=20000,rt=gameTypeIds};

    coroutine.wait(0.1);
--    this:SocketSendMessage(json) 

    this.mono:Request_lua_fun("AccountService/get_rooms",cjson.encode(json), --this.Receive_get_rooms,this.Receive_get_rooms_Error)
        function(message)
            mRooms = cjson.decode(message)
            EginProgressHUD.Instance:HideHUD();

            coroutine.start( this.LoadRooms_socket );
        end, 
        function(message)
            coroutine.start(this.Send_get_rooms)
            EginProgressHUD.Instance.ShowPromptHUD("网络中断，重连中...");
        end)
end

------------------获取房间信息成功---------------
--function this.Receive_get_rooms(message)
--    log("************************Receive_get_rooms get room message = " .. tostring(message))
--    mRooms = cjson.decode(message)
--    EginProgressHUD.Instance:HideHUD();
--
--    coroutine.start( this.LoadRooms_socket );
--end
--
---------------获取房间信息错误-------------
--function this.Receive_get_rooms_Error(message)
--    log("Receive_get_rooms_Error get room message = " .. tostring(message))
--    coroutine.start(this.Send_get_rooms)
--    EginProgressHUD.Instance.ShowPromptHUD("网络中断，重连中...");
--end


function this:InitConnectInfo(roomTable)
        SocketConnectInfo.Instance.userId = EginUser.Instance.uid
        SocketConnectInfo.Instance.userPassword = EginUser.Instance.password

        SocketConnectInfo.Instance.roomId = roomTable.room_id
        SocketConnectInfo.Instance.roomHost = roomTable.host
        SocketConnectInfo.Instance.roomPort = roomTable.port
        SocketConnectInfo.Instance.roomDBName = roomTable.dbname
        SocketConnectInfo.Instance.roomFixseat = true;

        SocketConnectInfo.Instance.roomTitle = roomTable.title
        SocketConnectInfo.Instance.roomMinMoney = roomTable.min_money
        -- local pUserInfo = {}
        -- pUserInfo['uid'] = EginUser.Instance.uid
        -- pUserInfo['password'] = EginUser.Instance.password

        -- roomTable['fixseat'] = "true"
        -- Util.SetSocketInfoList(pUserInfo,roomTable)
end

function this:CheckRoom(room)
    if(room.max_money == -1) then 
        room.max_money = ZPLocalization.Instance:Get("Room_MaxMoney")
    end
end

--------------http 中 方法的备份,只是修改了部分不同的字段---------------
function this.LoadRooms_socket()
	if(alreadyInitRooms)then
		return;
	end
	alreadyInitRooms = true;
	local i = 0;
	local items = {};
	for i,v in ipairs(mRooms) do
		local room = mRooms[i];--log(tostring(room))
        if(room.is_active == true)then
            this:CheckRoom(room)
			local roomCell = GameObject.Instantiate(kRoomCellPrefab).transform;
			table.insert(items, roomCell.gameObject);
			roomCell.name = "RoomCell_" .. i;
			roomCell.parent = vRooms;
			roomCell.localScale = Vector3(1,1,1);

			local roomOnlineNum = tonumber(room.online_num);
			local roomStatusInfo = "(流畅)";
			local roomStatusColor = Color.New(237.0/255.0, 205.0/255.0, 135.0/255.0);
			if(roomOnlineNum<=10)then
				roomStatusInfo = "(空闲)";
			elseif(roomOnlineNum <= 30)then
				roomStatusInfo = "(正常)";
			elseif(roomOnlineNum > 80)then
				roomStatusInfo = "(拥挤)";
				roomStatusColor = Color.New(210.0/255.0, 94.0/255.0, 94.0/255.0);
			end
			local roomStatus = roomCell:Find("Label_Count"):GetComponent("UILabel");
			roomStatus.text = roomStatusInfo;
			roomStatus.color = roomStatusColor;
			roomCell:Find("Label_Title"):GetComponent("UILabel").text = room.title;
			roomCell:Find("Label_Limit"):GetComponent("UILabel").text = room.min_money .. "-" .. room.max_money;

			local roomEntry = roomCell:Find("Button_Entry");
			roomEntry.name = i.."";
			
			this.mono:AddClick(roomEntry.gameObject, this.OnClickRoomEntry, this, {roomEntry})

        end
	end
	vRooms:GetComponent("UIGrid").repositionNow = true;
	vRooms.transform.localScale = Vector3(0.001,0.001,0.001);
	coroutine.wait(0.1);
	if(this.gameObject == nil)then
		error("##stop coroutine in LoadRooms")
		return;
	end
	vRooms.transform.localScale = Vector3(1,1,1);
	for m=1,#(items) do
		local vc3 = items[m].transform.localPosition;
		vc3.x = -2081;
		items[m].transform.localPosition = vc3;
		iTween.MoveTo(items[m],iTween.Hash("x",0,"islocal",true, "time",0.5,"delay", m*0.1));
		--local bgSpt = items[m].transform:FindChild("Background");
		--bgSpt:GetComponent("UIRect"):SetAnchor(anchorObj.gameObject, 103, 860, -106, -300);
		--[[bgSpt:GetComponent("UIRect").updateAnchors = UIRect.AnchorUpdate.OnStart;
		bgSpt:GetComponent("UIRect").leftAnchor:Set(anchorObj,0,103);
		bgSpt:GetComponent("UIRect").rightAnchor:Set(anchorObj,1,-105);
		bgSpt:GetComponent("UIRect").bottomAnchor:Set(anchorObj,0.5,220);
		bgSpt:GetComponent("UIRect").topAnchor:Set(anchorObj,1,-300);]]
	end
	scrollViewObj:UpdateScrollbars();
end

function this:ToPanel(pType)
	if pType == 'Show' then 
		ShowHallPanel(this.gameObject,true,nil,function ( )
			this.transform:FindChild('Black_Background').gameObject:SetActive(true)
		end)
	elseif pType=='Hide' or pType =='Hall' then 
		HallUtil:PopupPanel(pTag,false,this.gameObject,nil)
	end

end

---------------封装socket发消息方法,直接发送lua表--------------------
--function this:SocketSendMessage(obj)
--	local jsonStr = cjson.encode(obj);
--	this.mono:SocketSendMessage(jsonStr);
--end
---------------------------------#endregion Socket相关------------------------------------
--上行：
--{
--	"type":"AccountService",
--	"tag":"get_rooms",
--	"body":
--	{agentid: -1 gt: 0 maxv: 39999 minv: 0 rt: -1 }
--}
--下行：
--{
--	"type":"AccountService",
--	"tag":"get_rooms",
--	"result":"ok",
--	"body":
--	{[object Object],[object Object],[object Object],[object Object]}
--}

