RaceRankAnimationPanel = {}
local self = RaceRankAnimationPanel

local transform
local gameObject
local mono

local oldRank = 50
local rank = 1
local all = 1
function RaceRankAnimationPanel.Awake(obj)
	print("Awke RaceRankAnimationPanel");
	obj:SetActive(true)
	gameObject = obj
	transform = obj.transform
	mono = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.init()
end 
function self.init()
	self.up = transform:FindChild("up").gameObject
	self.up_rank = transform:FindChild("up/Label_rank"):GetComponent("UILabel")
	self.down = transform:FindChild("down").gameObject
	self.down_rank = transform:FindChild("down/Label_rank"):GetComponent("UILabel")
	self.allNum = transform:FindChild("Label_all"):GetComponent("UILabel")
	self.title = transform:FindChild("Sprite_title"):GetComponent("UISprite")
	self.point = transform:FindChild("position/Sprite_point").gameObject
	self.position_lb = {}
	self.position_sp = {}
	for i=1,5 do
		table.insert(self.position_lb,transform:FindChild("position/Label_"..i):GetComponent("UILabel"))
		table.insert(self.position_sp,transform:FindChild("position/Label_"..i.."/Sprite"):GetComponent("UISprite"))
	end
end
function self.SetOldRank(num)
	oldRank = num
end
function self.SetRank(num,_all)
	rank = num
	all = _all
end
function self.SetPosition(isover)
	
	local isup = false
	local oldidex
	local newidex
	if oldRank > rank then
		--排位上升
		isup = true
		self.title.spriteName = "rankUp"
		self.up_rank.text = tostring(rank)
		self.up:SetActive(true)
		self.down:SetActive(false)
	elseif oldRank < rank then
		--排位下降
		isup = false
		self.title.spriteName = "rankDown"
		self.down_rank.text = tostring(rank)
		self.up:SetActive(false)
		self.down:SetActive(true)
	else
		self.up_rank.text = tostring(rank)
		return
	end
	if isover then
		self.title.spriteName = "over"
	end
	gameObject:SetActive(true)
	if isup then
		if rank >= 4 then
			oldidex = 1
			newidex = 2
			self.position_lb[1].text = "[860404]"..oldRank
			self.position_lb[2].text = "[860404]"..rank
			self.position_sp[1].spriteName = "huang"
			self.position_sp[2].spriteName = "huang"
			for i=1,3 do
				self.position_lb[i+2].text = "[534343]"..(rank-i)
				self.position_sp[i+2].spriteName = "hui"
			end
		else
			
			newidex = 5 - rank + 1
			for i=1,5 do
				if i >= rank then
					self.position_lb[i].text = "[860404]"..6-i
					self.position_sp[i].spriteName = "huang"
				else
					if oldRank <= 5 then
						self.position_lb[i].text = "[534343]"..6-i
					else
						self.position_lb[i].text = "[534343]"..oldRank
					end
					self.position_sp[i].spriteName = "hui"
				end
			end
			if oldRank >= 5 then
				oldidex = 1 
			else
				oldidex = 6 - oldRank
			end
		end
	else
		if oldRank >= 4 then
			oldidex = 2
			newidex = 1
			self.position_lb[1].text = "[860404]"..rank
			self.position_sp[1].spriteName = "huang"
			self.position_lb[2].text = "[860404]"..oldRank
			self.position_sp[2].spriteName = "hui"
			for i=1,3 do
				self.position_lb[i+2].text = "[534343]"..(oldRank-i)
				self.position_sp[i+2].spriteName = "hui"
			end
		else
			oldidex = 6 - oldRank
			if rank >= 5 then
				newidex = 1 
			else
				newidex = 6 - rank
			end
			for i=1,5 do
				if rank >= 5 then
					if i == 1 then
						self.position_lb[i].text = "[860404]"..rank
						self.position_sp[i].spriteName = "huang"
					else
						self.position_lb[i].text = "[534343]"..6-i
						self.position_sp[i].spriteName = "hui"
					end
				else
					if rank <= 6-i then
						self.position_lb[i].text = "[860404]"..6-i
						self.position_sp[i].spriteName = "huang"
					else
						self.position_lb[i].text = "[534343]"..6-i
						self.position_sp[i].spriteName = "hui"
					end
				end
			end
		end
	end
	--动画
	local pos = self.point.transform.localPosition
	self.point.transform.localPosition = Vector3.New(self.position_lb[oldidex].transform.localPosition.x,pos.y,pos.z)
	iTween.MoveTo(self.point,iTween.Hash("x",self.position_lb[newidex].transform.localPosition.x, "time", 1, "islocal", true,"delay",1, "easetype", iTween.EaseType.easeOutBack))	
	local function func()
		coroutine.wait(4)
		gameObject:SetActive(false)
	end
	coroutine.start(func)
	self.SetOldRank(rank)
	self.allNum.text = "/"..all
end