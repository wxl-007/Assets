--每日签到界面
local this = LuaObject:New()
Module_Sign = this

function this:Awake() 
	this.vConfirmPG = this.transform:FindChild("Offset").gameObject:GetComponent("Animator")
	local cellsObj = this.transform:FindChild("Offset/Views/cells") 
	this.cells = {};
	this.CurrentNum = -1
	for i = 1,8 do
		this.cells[i] = {}
		this.cells[i].yet = cellsObj:FindChild("cell"..i.."/yet").gameObject;
		this.cells[i].NumLabel = cellsObj:FindChild("cell"..i.."/NumLabel").gameObject:GetComponent("UILabel");
		this.cells[i].bg = cellsObj:FindChild('cell'..i).gameObject:GetComponent('UISprite')
		this.cells[i].Lab = cellsObj:FindChild("cell"..i.."/Lab_Num").gameObject:GetComponent("UILabel");
		this.cells[i].Sp = cellsObj:FindChild("cell"..i.."/Icon").gameObject:GetComponent("UISprite");
		this.mono:AddClick(cellsObj:FindChild('cell'..i).gameObject, function ()
			this:OnClickSignObj(i)
		end );
	end
	-- local signObj = this.transform:FindChild("Offset/Views/Sign").gameObject 
	--  this.mono:AddClick(signObj, this.OnClickSignObj);
	this.mono:AddClick(this.transform:FindChild("Offset/ImageButton").gameObject , this.OnClickBack);
	this.transform:FindChild('Background').gameObject:SetActive(true)
end

function this:Start()
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
    if sceneRoot then 
        sceneRoot.manualHeight = 1920;
        sceneRoot.manualWidth = 1080;
    end


end
function this:OnEnable() 
	this:OnConfirmPanelShow(); 
	if Hall.SignInfo ~= nil then
		this:InitData(Hall.SignInfo)
	else
		if(PlatformGameDefine.playform.IsSocketLobby) then 
			EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
			this.monoSocket:Request_lua_fun("AccountService/get_sign_award_info","",
			function(result)
				EginProgressHUD.Instance:HideHUD(); 
				 Hall.SignInfo = cjson.decode(result)
				 this:InitData(Hall.SignInfo)
			end, 
			function(result)
				 EginProgressHUD.Instance:ShowPromptHUD(result);
			end);  
		end  
	end 
end
 
 
function this:OnDisable() 
	
	if (PlatformGameDefine.playform.IsSocketLobby) then   
		EginProgressHUD.Instance:HideHUD();
		this.monoSocket = nil;
	end 
	
end

function this:PassivityStart(gameObject) 
	this.gameObject = gameObject
	this.transform  = this.gameObject.transform;
	this:Start()
end
function this:SetEndSocket(monoSocket) 
	this.monoSocket = monoSocket;
end
 
function this:OnClickBack() 
	Hall:SignClose();
end

function this:clearLuaValue()

	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	cellsObj = nil
	this.cells = nil  
	 signObj = nil
	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
end 

function this:InitData(signInfo)
 --"body": [是否已签到,签到次数,[7天签到奖励值]] 是否已签到：1-已签、0-未签; 签到次数：0-6; [7天签到奖励值]：['2000',........]]
				--=[0,0,["2000","2000","2000","2000","2000","2000","3000"]]
	if signInfo[1] ~= 0 then
	 
	end
	
	local numYet = signInfo[2]--+ signInfo[1]
	CurrentNum = numYet +1
	 local numLabels = signInfo[3] 
	for i = 1,7  do 
		if numYet < i then
			if signInfo[1] == 0 then 
				this.cells[i].yet:SetActive(false);
				-- this.cells[i].NumLabel.color = Color.New(1,1,1,1)
				this.cells[i].Lab.color = Color.New(156/255,100/255,18/255,1)
				this.cells[i].Sp.spriteName =  'daily_r'..(i) --.color = Color.white
				if i - numYet ==1 then 
					this.cells[i].bg.spriteName = 'daily3'
					
				else
					this.cells[i].bg.spriteName = 'daily4'

				end
			end
		else
			this.cells[i].yet:SetActive(true);
			this.cells[i].bg.spriteName = 'daily2'
			--shader   grey   r and g  <0.01 就是灰
			-- this.cells[i].NumLabel.color = Color.New(0.5, 0.5, 0.5, 1)	
			this.cells[i].Lab.color =  Color.New(0.25, 0.25, 0.25, 1)	
			this.cells[i].Sp.spriteName = 'daily_r'..(i)..'_1' --.color =  Color.New(0, 0, 0, 1)	
		end 
		this.cells[i].Lab.text = numLabels[i]..'豆'
	end
	if numYet == 0 and signInfo[1] == 1 then
		for i = 1,7  do 
			this.cells[i].yet:SetActive(true);
		end
	end
end
function this:OnClickSignObj(pPressNum) 
	if pPressNum == CurrentNum then 
		if(PlatformGameDefine.playform.IsSocketLobby) then  
			if Hall.SignInfo[1] == 1 then 
				EginProgressHUD.Instance:ShowPromptHUD("已签到!");
			else
				-- EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
				this.monoSocket:Request_lua_fun("AccountService/user_sign","",
				function(result) 
					-- EginProgressHUD.Instance:ShowPromptHUD("签到成功!");
					SimpleHUD:ShowPromptHUD('签到成功')
					 log("Win============="..result)
					 
					 Hall.SignInfo[1] = 1;
					 Hall.SignInfo[2] = Hall.SignInfo[2]+1;
					 EginUser.Instance.bagMoney = EginUser.Instance.bagMoney+Hall.SignInfo[3][Hall.SignInfo[2]]
					  
					  Hall.bagMoney.text = EginUser.Instance.bagMoney;
					  if Hall.SignInfo[2] == 7 then
						Hall.SignInfo[2] = 0;
					  end
					 this:InitData(Hall.SignInfo)
				end, 
				function(result)
					-- this:ShowTips(result)
					coroutine.start(function ( )
						coroutine.wait(0.2)
						-- EginProgressHUD.Instance:ShowPromptHUD(result,1)
						SimpleHUD:ShowPromptHUD(result)
					end)
					
					-- print('验证码已发送')
					-- Hall:ShowTipForSign(result)
				end);  
			end
				
		end  
	end
end 
 function this:OnConfirmPanelShow()  
	
	this.vConfirmPG.transform.localScale = Vector3(0.001,0.001,0.001);
	coroutine.start(this.AfterDoing,this,0, function()
		this.vConfirmPG.transform.localScale = Vector3(1,1,1); 
		this.vConfirmPG.enabled = true; 
		this.vConfirmPG:Play("FrameShowAnimation")
		this.vConfirmPG:Update(0); 		
	end);
end
function this:AfterDoing(offset,run)
	coroutine.wait(offset);	
	if this.gameObject then
		run();
	end
end

function this:ShowTips(pTxt)
	local tObj = this.transform:FindChild('LabelTipsBG').gameObject
	local tTips = this.transform:FindChild('LabelTipsBG/LabelTips').gameObject:GetComponent('UILabel')
	tTips.text = pTxt

	if not tObj.activeSelf then 
		tObj:SetActive(true)
		coroutine.start(this.AfterDoing,this,2.3, function()																																																													
			tObj:SetActive(false) 																																																													
		end); 	
	end 
	
end