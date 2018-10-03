
local this = LuaObject:New()
Module_Task2 = this
this.tyeptbon = 0; 
function this:Awake()  
	this.award = this.transform:FindChild('Offset/Panel').gameObject;
	this.TaskInfo = {0,0,0,0,0}
	this.mono:AddClick(this.transform:FindChild('Offset/Background Top/Button_Back - Anchor/ImageButton').gameObject,this.OnBack) 
	
	this.freeCellsLabel = {this.transform:FindChild('Offset/Views/Scroll View/Table/cell1/Label').gameObject:GetComponent("UILabel"),
					this.transform:FindChild('Offset/Views/Scroll View/Table/cell2/Label').gameObject:GetComponent("UILabel"),
					this.transform:FindChild('Offset/Views/Scroll View/Table/cell3/Label').gameObject:GetComponent("UILabel"),
					this.transform:FindChild('Offset/Views/Scroll View/Table/cell4/Label').gameObject:GetComponent("UILabel"),
					this.transform:FindChild('Offset/Views/Scroll View/Table/cell5/Label').gameObject:GetComponent("UILabel")};
					
	this.freeCells = {this.transform:FindChild('Offset/Views/Scroll View/Table/cell1/btn').gameObject,
					this.transform:FindChild('Offset/Views/Scroll View/Table/cell2/btn').gameObject,
					this.transform:FindChild('Offset/Views/Scroll View/Table/cell3/btn').gameObject,
					this.transform:FindChild('Offset/Views/Scroll View/Table/cell4/btn').gameObject,
					this.transform:FindChild('Offset/Views/Scroll View/Table/cell5/btn').gameObject};
	 
	this.mono:AddClick(this.freeCells[1],this.OnTaskBut1) 
	this.mono:AddClick(this.freeCells[4],this.OnTaskBut4) 
	this.mono:AddClick(this.freeCells[2],this.OnTaskBut2) 
	this.mono:AddClick(this.freeCells[3],this.OnTaskBut3) 
	this.mono:AddClick(this.freeCells[5],this.OnTaskBut5) 
	for i = 1,5 do
		this.freeCells[i]:SetActive(false);
	end  
	 
end

function this:Start()
     local sceneRoot = this.transform.root:GetComponent("UIRoot")
    if sceneRoot then 
        sceneRoot.manualHeight = 1080;
        sceneRoot.manualWidth = 1920;
    end
	if (PlatformGameDefine.playform.IsSocketLobby) then 
		this.mono:StartSocket(false);
		this.GetTaskInfo();
	end
end
 function this:OnEnable() 
	 this.tyeptbon = 0; 
end  
function this:OnDisable()  
	 this.tyeptbon = 0; 
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
function this:FreeInit()  
--任务id1:[任务id，完成数，领取状态(-1—已领取，0—不能领取，1—可领取)],
	local Istr = "";
	for i = 1,5 do
		Istr = tostring(i)
		if this.TaskInfo[Istr][3] == 1 then 
			--1—可领取
			this.freeCells[i]:SetActive(true);
			this.freeCells[i]:GetComponent("UISprite").spriteName = "receive_btn";
			this.freeCells[i]:GetComponent("UIButton").normalSprite = "receive_btn";
		 elseif this.TaskInfo[Istr][3] == -1  then 
			-- -1—已领取
			this.freeCells[i]:SetActive(false);
			this.TaskInfo[Istr][2] = -1;
		elseif this.TaskInfo[Istr][3] == 0  then 
			-- 0—不能领取
			this.freeCells[i]:SetActive(true);
			this.freeCells[i]:GetComponent("UISprite").spriteName = "todothetask_btn";
			this.freeCells[i]:GetComponent("UIButton").normalSprite = "todothetask_btn";
		end  
		local maxNum = 10
		if i==1 or i==2 then
			maxNum = 1;
		end
		 this.freeCellsLabel[i].text = this.TaskInfo[Istr][2].."/"..maxNum
		 if this.TaskInfo[Istr][2] >= maxNum then
			this.freeCellsLabel[i].color = Color.New(0.941,0.83,0.02745,1)
		 elseif this.TaskInfo[Istr][2] == -1 then
			this.freeCellsLabel[i].color = Color.New(0.941,0.83,0.02745,1)
			this.freeCellsLabel[i].text = "已领取"
		else
			this.freeCellsLabel[i].color = Color.New(1,1,1,1)
		 end
		 
	end
end

 function this:OnBack() 
	Hall.Task2Id = 0;
	this.mono:EginLoadLevel("Hall"); 
end
 function this:OnTaskBut1() 
	this.tyeptbon = 1;  
	 if this.TaskInfo["1"][3] == 1 then
		this.GetProcess_task(this.tyeptbon)
	elseif this.TaskInfo["1"][3] == 0 then 
		Hall.Task2Id = this.tyeptbon;
		this.mono:EginLoadLevel("Hall"); 
	end 
end  
 function this:OnTaskBut4() 
	this.tyeptbon = 4;  
	 if  this.TaskInfo["4"][3] == 1 then
		this.GetProcess_task(this.tyeptbon)
	elseif  this.TaskInfo["4"][3] == 0 then 
		this.mono:EginLoadLevel("Hall"); 
		Hall.Task2Id = this.tyeptbon;
	end
end
 function this:OnTaskBut2() 
	this.tyeptbon = 2;  
	 if this.TaskInfo["2"][3] == 1 then
		this.GetProcess_task(this.tyeptbon)
	elseif this.TaskInfo["2"][3] == 0 then 
		Hall.Task2Id = this.tyeptbon;
		this.mono:EginLoadLevel("Hall"); 
	end
end

 function this:OnTaskBut3() 
	this.tyeptbon = 3;  
	 if this.TaskInfo["3"][3] == 1 then 
		this.GetProcess_task(this.tyeptbon)
	elseif this.TaskInfo["3"][3] == 0  then 
		Hall.Task2Id = this.tyeptbon;
		this.mono:EginLoadLevel("Hall"); 
	end
end
 function this:OnTaskBut5() 
	this.tyeptbon = 5;  
	 if this.TaskInfo["5"][3] == 1 then
		this.GetProcess_task(this.tyeptbon)
	elseif this.TaskInfo["5"][3] == 0 then 
		Hall.Task2Id = this.tyeptbon;
		this.mono:EginLoadLevel("Hall"); 
	end 
end  


--任务id1:[任务id，完成数，领取状态(-1—已领取，0—不能领取，1—可领取)],
function this.GetTaskInfo() 
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
	this.mono:Request_lua_fun("AccountService/get_taskInfo","",function(message)
			log("~~~~~~~"..message)
			local tMsg = cjson.decode(message) 
				this.TaskInfo = tMsg 
			this:FreeInit()
			EginProgressHUD.Instance:HideHUD();
	end,function (message) 
		EginProgressHUD.Instance:ShowPromptHUD(message)
	end) 
end 
--获取奖励  
function this.GetProcess_task(pType)
	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("ScreenLoading"),false);
	local tBody = {}
	tBody['id'] = tostring(pType)
	this.mono:Request_lua_fun("AccountService/process_task",cjson.encode(tBody),function(message) 
		log("~~~~~~~领取成功!")
		 this.TaskInfo[tostring(pType)][3] = -1;
		  this:FreeInit()
		EginProgressHUD.Instance:HideHUD()
		this.award:SetActive(true);
		coroutine.start(this.AfterDoing,this,3, function() 
					this.award:SetActive(false); 
				end);
		--获取奖励成功操作
	end,function (message)
		EginProgressHUD.Instance:ShowPromptHUD(message)
	end) 
end 


function this:AfterDoing(offset,run)
	coroutine.wait(offset);	
	if this.mono then
		run();
	end
end 