LastHandPanel = {}
local self = LastHandPanel

local transform
local gameObject

local computerCard = nil
local otherComputerCard = nil
local playerCard = nil
--local lb_player
--local lb_computer
--local lb_othercomputer
local playerPos
local computerPos
local otherComputerPos
local recComputerCard = nil
local recOtherComputerCard = nil
local recPlayerCard = nil

local playerNoPlay
local computerNoPlay
local otherComputerNoPlay
function self.Awake(obj)
	gameObject = obj
    transform = obj.transform
	self.init()
end
local recTime = 0 --每一次加一次
function self.init()
	self.mono = gameObject:GetComponent('LRDDZ_LuaBehaviour')
	self.mono:AddClick(transform:FindChild("btnClose").gameObject,self.OnCloseCallBack)
	playerPos = transform:FindChild("Player/posGrid").gameObject
	computerPos = transform:FindChild("Computer/posGrid").gameObject
	otherComputerPos = transform:FindChild("OtherComputer/posGrid").gameObject
	--lb_player = transform:FindChild("Player/Label_name"):GetComponent("UILabel")
	--lb_othercomputer = transform:FindChild("OtherComputer/Label_name"):GetComponent("UILabel")
	--lb_computer = transform:FindChild("Computer/Label_name"):GetComponent("UILabel")
	playerNoPlay = transform:FindChild("Player/noPlay").gameObject
	computerNoPlay = transform:FindChild("Computer/noPlay").gameObject
	otherComputerNoPlay = transform:FindChild("OtherComputer/noPlay").gameObject
end
local ParticleCamera = nil
function self.OnEnable(  )
	if ParticleCamera == nil then
		ParticleCamera = GameObject.Find("ParticleCamera")
	end
	self.AddPlayerCards()
	self.AddComputerCards()
	self.AddOtherCompterCards()
	ParticleCamera:SetActive(false)
	Event.AddListener(GameEvent.ReSetInfo, self.ReSetInfo)
end
function self.OnDisable(  )
	ParticleCamera:SetActive(true)
	Event.RemoveListener(GameEvent.ReSetInfo, self.ReSetInfo)
end
function self.AddPlayerCards()
	--玩家的牌
	--lb_player.text = EginUser.Instance.nickname
	EginTools.ClearChildren(playerPos.transform)
	if recPlayerCard == nil then 
		playerNoPlay:SetActive(false)
		return
	end
	if #recPlayerCard > 0 then
		playerNoPlay:SetActive(false)
		for i=1,#recPlayerCard do 
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","dealCard",false)
			obj.transform.parent = playerPos.transform;
			obj.transform.localScale = Vector3.New(1,1,1);
			obj.transform.localPosition =Vector3.New(0,0,0) --(i-count/2)*30 
			local sprite = obj:GetComponent("UISprite")
			sprite:MakePixelPerfect()

			--[[
			if recPlayerCard[i].weight >= Weight.SJoker then
				sprite.spriteName = WeightString[recPlayerCard[i].weight]
			else
				sprite.spriteName = recPlayerCard[i].suits
			end
			obj.transform:FindChild("Label"):GetComponent("UILabel").text = SuitsColor[recPlayerCard[i].suits]..WeightText[recPlayerCard[i].weight]
			]]
			MyCommon.Set2DCard(obj,recPlayerCard[i].suits,recPlayerCard[i].weight)
			obj.transform:FindChild("Label"):GetComponent("UILabel").depth = 4+i


			sprite.depth = 3+ i
		end
		playerPos.transform:GetComponent("UIGrid").repositionNow = true
	else
		--不出
		playerNoPlay:SetActive(true)
	end 
end
function self.AddComputerCards()
	--lb_computer.text = Computer.name
	EginTools.ClearChildren(computerPos.transform)
	if recComputerCard == nil then 
		computerNoPlay:SetActive(false)
		return
	end
	if #recComputerCard > 0 then
		computerNoPlay:SetActive(false)
		for i=1,#recComputerCard do
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","dealCard",false)
			obj.transform.parent = computerPos.transform;
			obj.transform.localScale = Vector3.New(1,1,1);
			obj.transform.localPosition =Vector3.New(0,0,0) --(i-count/2)*30 
			local sprite = obj:GetComponent("UISprite")
			sprite:MakePixelPerfect()
			sprite.depth = 3+ i
			--[[
			if recComputerCard[i].weight >= Weight.SJoker then
				sprite.spriteName = WeightString[recComputerCard[i].weight]
			else
				sprite.spriteName = recComputerCard[i].suits
			end
			obj.transform:FindChild("Label"):GetComponent("UILabel").text = SuitsColor[recComputerCard[i].suits]..WeightText[recComputerCard[i].weight]
			]]
			MyCommon.Set2DCard(obj,recComputerCard[i].suits,recComputerCard[i].weight)
			obj.transform:FindChild("Label"):GetComponent("UILabel").depth = 4+i


		end
		computerPos.transform:GetComponent("UIGrid").repositionNow = true
	else
		--不出
		computerNoPlay:SetActive(true)
	end
end
function self.AddOtherCompterCards()

	--lb_othercomputer.text = OtherComputer.name
	EginTools.ClearChildren(otherComputerPos.transform)
	if recOtherComputerCard == nil then 
		otherComputerNoPlay:SetActive(false)
		return
	end
	if #recOtherComputerCard > 0 then
		otherComputerNoPlay:SetActive(false)
		for i=1,#recOtherComputerCard do
			local obj = LRDDZ_ResourceManager.Instance:LoadAsset("smallpoker","smallpoker","dealCard",false)
			obj.transform.parent = otherComputerPos.transform;
			obj.transform.localScale = Vector3.New(1,1,1);
			obj.transform.localPosition =Vector3.New(0,0,0) --(i-count/2)*30 
			local sprite = obj:GetComponent("UISprite")
			sprite:MakePixelPerfect()
			sprite.depth = 3+ i
			--[[
			if recOtherComputerCard[i].weight >= Weight.SJoker then
				sprite.spriteName = WeightString[recOtherComputerCard[i].weight]
			else
				sprite.spriteName = recOtherComputerCard[i].suits
			end
			obj.transform:FindChild("Label"):GetComponent("UILabel").text = SuitsColor[recOtherComputerCard[i].suits]..WeightText[recOtherComputerCard[i].weight]
			]]
			MyCommon.Set2DCard(obj,recOtherComputerCard[i].suits,recOtherComputerCard[i].weight)
			obj.transform:FindChild("Label"):GetComponent("UILabel").depth = 4+i
			
		end
		otherComputerPos.transform:GetComponent("UIGrid").repositionNow = true
	else
		--不出
		otherComputerNoPlay:SetActive(true)
	end
end
function self.AddCards(characterType,cards)
	if characterType == CharacterType.Player then
		recPlayerCard = playerCard
		playerCard = cards or {}
		if gameObject ~= nil and gameObject.activeSelf then
			self.AddPlayerCards()
		end
	elseif characterType == CharacterType.Computer then
		
		recComputerCard = computerCard
		computerCard = cards or {}
		if gameObject ~= nil and gameObject.activeSelf then
			self.AddComputerCards()
		end
	else
		
		recOtherComputerCard = otherComputerCard
		otherComputerCard = cards or {}
		if gameObject ~= nil and gameObject.activeSelf then
			self.AddOtherCompterCards()
		end
	end
end
function self.UpdateCards()
	recPlayerCard = playerCard
	recComputerCard = computerCard
	recOtherComputerCard = otherComputerCard
	if gameObject~= nil and gameObject.activeSelf then
		self.ShowCards()
	end
end
function self.OnCloseCallBack()
	gameObject:SetActive(false)
end
function self.Clear()
	self.ClearData()
	EginTools.ClearChildren(playerPos.transform)
	EginTools.ClearChildren(computerPos.transform)
	EginTools.ClearChildren(otherComputerPos.transform)
end
function self.ClearData()
	playerCard = nil
	computerCard = nil
	otherComputerCard = nil
	recPlayerCard = nil
	recComputerCard = nil
	recOtherComputerCard = nil
end
function self.ReSetInfo()
	self.Clear()
	gameObject:SetActive(false)
end
function self.OnDestroy()
	self.Clear()
	ParticleCamera = nil
	gameObject = nil
	transform = nil
end