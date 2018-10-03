local cjson = require "cjson"									
local this = LuaObject:New()									
Module_Leaderboard = this									
									
local isCloseGold = false;									
function this:Awake()
	EginProgressHUD.Instance:HideHUD()
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),true);
	this.mono = Hall.mono									
	this:autoGetUI()									
	this.recordPage = 1;									
	this.maxRecordPage = 1;									
	this.recordPageSize = 30;									
	this.isBag = true									
	this.requestId ="get_userranks"									
	this.get_userranksData = nil									
	this.get_getGoldnn_weekListData = nil									
	this.getGoldnn_dayListData = nil														
	if(PlatformGameDefine.playform:GetPlatformPrefix()=="131" or isCloseGold) then									
 		this.ui_Nav:SetActive(false)			
		HallUtil:AddMenu(Module_Leaderboard)							
	end											
	this.mono:AddClick(this.ui_backBtn,this.OnClickBack,this)					
	this.mono:AddClick(this.ui_weekNav,this.OnClickTabWeek,this)									
	this.mono:AddClick(this.ui_dayNav, this.OnClickTabDay,this)									
	this.mono:AddClick(this.ui_moneyNav, this.OnClickTabBag,this)				
	--[[									
	this.vRecords=this.transform:FindChild("Offset/Views/Record/Table");									
	this.lbPrefab=ResManager:LoadAsset("happycity/LeadboardItem","LeadboardItem");									
	this.kRecordPage=this.transform:FindChild("Offset/Views/Record/Page/Label_Page").gameObject:GetComponent("UILabel");									
 									
								
	this.mono:AddClick(this.transform:FindChild("Offset/Background Top/Button_Back - Anchor/ImageButton").gameObject, this.OnClickBack,this)									
										
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Record/Page/Button_Last").gameObject, this.OnClickPrePage,this)									
										
	this.mono:AddClick(this.transform:FindChild("Offset/Views/Record/Page/Button_Next").gameObject, this.OnClickNextPage,this)									
	]]									
end									
									
function this:Start ()  	
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),true);
	-- EginProgressHUD.Instance:ShowForceWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"));		
	this.ui_scrollPanel.depth = this.ui_leaderboardPanel.depth + 1							
	-- EginTools.setScreen(this.transform,1080,1920)										
	if (PlatformGameDefine.playform.IsSocketLobby) then 									
		--this.mono:StartSocket(false);									
		this:getLeaderboard("get_userranks");									
	end									
end									
function this:clearLuaValue()									
	this.mono = nil									
	this.gameObject = nil									
	this.transform  = nil									
										
	this.vRecords=nil;									
	this.lbPrefab=nil;									
	this.kRecordPage=nil;									
	this.recordPage = 1;									
	this.maxRecordPage = 1;									
	this.recordPageSize = 30;									
	this.isBag = nil									
	this.get_userranksData = nil									
	this.get_getGoldnn_weekListData = nil									
	this.getGoldnn_dayListData = nil							
	this:autoClearUI()							
	LuaGC()									
end									
									
function this:OnDestroy()									
	this:clearLuaValue()									
end									
function this:OnClickBack ()   									
	--this.mono:EginLoadLevel("Hall");	
	-- HallUtil:HidePanelAni(this.gameObject)		
	HallUtil:PopupPanel('Hall',false,this.gameObject,nil)							
end									
									
function this:getLeaderboard(pTag)									
	if(PlatformGameDefine.playform:GetPlatformPrefix()=="131" or isCloseGold) then									
		pTag ="get_userranks"									
	end									
	local jsonStr = cjson.encode({type="AccountService",tag=pTag});									
    this.mono:SocketSendMessage(jsonStr)						
end									
function this:OnClickTabWeek()									
	this.recordPage = 1;									
	this.maxRecordPage = 1;									
	this.isBag = false									
	this.requestId ="getGoldnn_weekList"									
	if this.getGoldnn_weekListData ~=nil then									
		-- EginProgressHUD.Instance:HideHUD();									
		this.lbData = this.getGoldnn_weekListData;									
		this.maxRecordPage = math.ceil( #(this.lbData["body"])/this.recordPageSize );									
		this:updateLeaderboard();									
	else									
	 this:getLeaderboard("getGoldnn_weekList");									
	end									
end									
function this:OnClickTabDay()									
	this.recordPage = 1;									
	this.maxRecordPage = 1;									
	this.isBag = false									
	this.requestId ="getGoldnn_dayList"									
	if this.getGoldnn_dayListData ~=nil then									
		-- EginProgressHUD.Instance:HideHUD();									
		this.lbData = this.getGoldnn_dayListData;									
		this.maxRecordPage = math.ceil( #(this.lbData["body"])/this.recordPageSize );									
		this:updateLeaderboard();									
	else									
		this:getLeaderboard("getGoldnn_dayList");									
	end									
end									
function this:OnClickTabBag()									
	this.recordPage = 1;									
	this.maxRecordPage = 1;									
	this.isBag = true									
	this.requestId ="get_userranks"									
	if this.get_userranksData ~=nil then									
		-- EginProgressHUD.Instance:HideHUD();									
		this.lbData = this.get_userranksData;									
		this.maxRecordPage = math.ceil( #(this.lbData["body"])/this.recordPageSize );									
		this:updateLeaderboard();									
	else									
		this:getLeaderboard("get_userranks");									
	end									
end									
function this:SocketDisconnect ( disconnectInfo) 									
	--SocketManager.LobbyInstance.socketListener = nil;									
end									
 									
									
function this:OnClickPrePage () 									
	if(this.recordPage > 1)then									
		this.recordPage = this.recordPage - 1;									
		if (PlatformGameDefine.playform.IsSocketLobby) then									
			this:updateLeaderboard();									
		else									
												
		end									
	end									
end									
function this:OnClickNextPage () 									
	if(this.recordPage < this.maxRecordPage)then									
		this.recordPage = this.recordPage + 1;									
		if (PlatformGameDefine.playform.IsSocketLobby) then									
			this:updateLeaderboard();									
		else									
												
		end									
	end									
end									
 									
function this.SocketReceiveMessage(message)									
	local messageObj = cjson.decode(message);									
	local type = tostring(messageObj["type"]);									
	local tag = tostring(messageObj["tag"]);									
	if(type == "AccountService") then									
		if tag == "getGoldnn_weekList" or tag == "getGoldnn_dayList" or tag == "get_userranks" then	
		EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),true);
											
			if tag == "getGoldnn_weekList" then									
				this.getGoldnn_weekListData = messageObj									
			elseif tag == "getGoldnn_dayList" then									
				this.getGoldnn_dayListData = messageObj									
			else									
				this.get_userranksData = messageObj									
			end										
			if tag==this.requestId  then									
				EginProgressHUD.Instance:HideHUD();									
				--{'type': 'AccountService', 'tag': 'get_userranks','result': 'ok' ,'body': 									
					--[{'username': 'username','nickname': 'nickname','bag_money': 1111111,'user_id': 1111111,}, ...]}									
				this.lbData = messageObj;									
				this.maxRecordPage = math.ceil( #(messageObj["body"])/this.recordPageSize );									
				this:updateLeaderboard();									
			end									
		end									
	end									
end									
function this:Process_account_login(info)									
    this:getLeaderboard("getGoldnn_weekList");									
end									
									
function this:updateLeaderboard () 													
	if this.lbData == nil then									
		return;									
	end	
	this.ui_scrollView:ResetPosition()								
	--this.kRecordPage.text = this.recordPage.."/"..this.maxRecordPage;									
	local maxIndex = (this.recordPage-1)*this.recordPageSize;									
	--EginTools.ClearChildren(this.vRecords);									
	local recordInfoList = this.lbData["body"];									
 	-- printf(recordInfoList)
 	local count = 0;						
	this.ui_scrollPanel.gameObject:SetActive(true)
	-- EginProgressHUD.Instance:HideHUD();
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),true);
		
	for i = maxIndex ,30   do									
		if(count == this.recordPageSize)then break; end									
									
		local recordInfo = recordInfoList[i+1]									
		if (type(recordInfo)  ~= "table") then 	
			this.ui_scrollPanel.gameObject:SetActive(false)	
			break;	
		end									
				
		local cell = this.ui_itemGrid.transform:FindChild("randTemplate1 ("..i..")")						
		if i > #(recordInfoList)-1 then		
			cell.gameObject:SetActive(false)		
		else		
			cell.gameObject:SetActive(true)		
			if (PlatformGameDefine.playform.IsSocketLobby) then									
				if PlatformGameDefine.playform:GetPlatformPrefix()=="131" or this.isBag or isCloseGold then									
					cell.transform:FindChild("Label (1)"):GetComponent("UILabel").text = System.Text.RegularExpressions.Regex.Unescape( recordInfo["nickname"]);									
					cell.transform:FindChild("Label_ID"):GetComponent("UILabel").text = 'ID : '..tostring(recordInfo["user_id"]) ;									
					cell.transform:FindChild("Coin/Label"):GetComponent("UILabel").text = tostring(recordInfo["bag_money"]) ;									
					--this.transform:FindChildChild("Offset/Views/Record/Title/Label_3").gameObject:GetComponent("UILabel").text = "背包资产"									
				else									
					cell.transform:FindChild("Label (1)"):GetComponent("UILabel").text = System.Text.RegularExpressions.Regex.Unescape( recordInfo[2]);									
					cell.transform:FindChild("Label_ID"):GetComponent("UILabel").text = tostring(recordInfo[1]) ;									
					cell.transform:FindChild("Coin/Label"):GetComponent("UILabel").text = tostring(recordInfo[3]) ;									
					--this.transform:FindChildChild("Offset/Views/Record/Title/Label_3").gameObject:GetComponent("UILabel").text = "黄金牛牛奖励"									
				end		
				cell.transform:FindChild("pm").gameObject:SetActive(true);								
				if(i < 3)then									
													
					cell.transform:FindChild("pm"):GetComponent("UISprite").spriteName = "pm" .. (i+1);
					cell.transform:FindChild("pm"):GetComponent("UISprite"):MakePixelPerfect()
					cell.transform:FindChild("pm").localPosition = Vector3(-425,20,0)	
					-- if i == 0 then 
					-- 	cell.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName = 'pay22'
					-- else
						cell.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName = 'pay21'
					-- end								
				else 
					cell.transform:FindChild("Sprite"):GetComponent("UISprite").spriteName = 'pay21'

					if i>=3 and i<9 then
						cell.transform:FindChild("pm"):GetComponent("UISprite").spriteName = tostring(i+1)
						cell.transform:FindChild("pm").localPosition = Vector3(-425,20,0)
					else
						cell.transform:FindChild("pm").localPosition = Vector3(-440,20,0)
						cell.transform:FindChild("pm/pm").gameObject:SetActive(true)
						cell.transform:FindChild("pm"):GetComponent("UISprite").spriteName = tostring(math.floor((i+1)/10))
						cell.transform:FindChild("pm/pm"):GetComponent("UISprite").spriteName = tostring((i+1)%10)
					end
					cell.transform:FindChild("pm"):GetComponent("UISprite"):MakePixelPerfect()							
					--cell.transform:Find("pm"):GetComponent("UILabel").text = tostring(i+1) ;									
				end									
			else									
					--									
			end			
			count = count+1;			
		end								
	end	
	EginProgressHUD.Instance:HideHUD();							
end 									
								
								
function this:autoGetUI()
	 this.ui_leaderboardPanel=this.gameObject:GetComponent("UIPanel")	
	 this.ui_backBtn=this.transform:FindChild("offset/topback/backBtn").gameObject	
	 this.ui_scrollPanel=this.transform:FindChild("offset/view").gameObject:GetComponent("UIPanel")	
	 this.ui_itemGrid=this.transform:FindChild("offset/view/Grid").gameObject	
	 this.ui_scrollView=this.transform:FindChild("offset/view").gameObject:GetComponent("UIScrollView")	
	 this.ui_moneyNav=this.transform:FindChild("bt/moneyNav").gameObject	
	 this.ui_dayNav=this.transform:FindChild("bt/dayNav").gameObject	
	 this.ui_weekNav=this.transform:FindChild("bt/weekNav").gameObject	
	 this.ui_Nav=this.transform:FindChild("bt").gameObject	
end								
function this:autoClearUI()
	 this.ui_leaderboardPanel=nil	
	 this.ui_backBtn= nil	
	 this.ui_scrollPanel=nil	
	 this.ui_itemGrid= nil	
	 this.ui_scrollView=nil	
	 this.ui_moneyNav= nil	
	 this.ui_dayNav= nil	
	 this.ui_weekNav= nil	
	 this.ui_Nav= nil	
end								
							
						
					
				
			
		
	

