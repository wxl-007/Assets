RaceOverPanel = {}
local self = RaceOverPanel

local transform
local gameObject
local mono

local rank = 0
local awardstr
local datestr
function RaceOverPanel.Awake(obj)
	print("Awke RaceOverPanel");
	obj:SetActive(true)
	gameObject = obj
	transform = obj.transform
	mono = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.init()
end 
function self.init()
	local btnOK = transform:FindChild("btnok").gameObject
	local btnApply = transform:FindChild("btnapply").gameObject
	local lbName = transform:FindChild("win/Label_name"):GetComponent("UILabel")
	self.lbAward = transform:FindChild("win/Label_award"):GetComponent("UILabel")
	self.lbDesc = transform:FindChild("win/Label_desc"):GetComponent("UILabel")
	self.lbDate = transform:FindChild("win/Label_date"):GetComponent("UILabel")
	mono:AddClick(btnOK,RaceOverPanel.OnOkCallBack)
	mono:AddClick(btnApply,RaceOverPanel.OnApplyCallBack)

	lbName.text = EginUser.Instance.nickname

	RaceOverPanel.SetDest(rank,awardstr,datestr)
end
function RaceOverPanel.SetDest(num,award,date)
	rank = num
	local descstr = ""
	if LRDDZ_Game.matchType == DDZGameMatchType.FiveMinute then
		if tonumber(num) <= 10 then
			descstr = "    [6B5B51]恭喜您在斗地主5分钟赛中获得 [d12e2e]第"..num.."名[-] 的成绩。\n特为您派发如下奖品——"
		else
			descstr = "    [6B5B51]恭喜您在斗地主5分钟赛中获得 [d12e2e]第"..num.."名[-] 的成绩。"
		end
	elseif LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
		if tonumber(num) == 1 then
			descstr = "    [6B5B51]恭喜您在斗地主三人赛中获得 [d12e2e]第"..num.."名[-] 的好成绩。\n特为您派发如下奖品——"
		else
			descstr = "    [6B5B51]恭喜您在斗地主三人赛中获得 [d12e2e]第"..num.."名[-] 的成绩。"
		end
	end
	awardstr = award
	datestr = date
	if self.lbDesc ~= nil then
		self.lbDesc.text = descstr
	end
	if self.lbAward ~= nil and awardstr ~= nil then
		self.lbAward.text = awardstr
	end
	if self.lbDate~= nil and datestr ~= nil then
		self.lbDate.text = datestr
	end
end
function RaceOverPanel.OnOkCallBack()
	destroy(gameObject)

	if LRDDZ_Game.platform == PlatformType.PlatformMoble then
    	LRDDZ_Game:BackHall()
    else
    	--直接退出游戏
		Application.Quit()
	end
end
function RaceOverPanel.OnApplyCallBack()
	destroy(gameObject)
	if LRDDZ_Game.platform == PlatformType.PlatformMoble then
		--
		LRDDZ_ResourceManager.LoadLevel("SRDDZ_Loading", false, function(obj) end);
		error("准备断开")
		SocketManager.Instance:Connect(SocketConnectInfo.Instance,nil,true)
		error("已断开")
	else
		LRDDZ_ResourceManager.Instance:LoadAsset("Prefab","SRDDZ_LoadPanel","LRDDZ_LoadPanel",false)
		if LRDDZ_Game.matchType == DDZGameMatchType.ThreeMatch then
			Player.raceScore = 0
			Computer.raceScore = 0
			OtherComputer.raceScore = 0
		end
        LRDDZ_Game:SendReapply()
	end
end

function RaceOverPanel.OnDestroy()
	transform = nil 
	gameObject = nil
	mono = nil
	self.lbDesc = nil 
	self.lbAward = nil
	self.lbDate = nil
end