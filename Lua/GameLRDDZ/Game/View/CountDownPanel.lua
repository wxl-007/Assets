
CountDownPanel = {}
local self = CountDownPanel
require "System/Timer"

local transform
local gameObject

self.time = nil	
self.num = 0
self.maxNum = 1
self.type = nil
self.func = nil 
function CountDownPanel.Awake(obj)
	print("Awke CountDownPanel");
	gameObject = obj
	transform = obj.transform
	self.init()
end  
function CountDownPanel.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.numLabel = transform:FindChild("Num"):GetComponent("UILabel") --数字
	self.numSprite = transform:GetComponent("UISprite")

	self.time = Timer.New(self.RepeatSetNum, 1, -1, true)
	gameObject:SetActive(false)
end 
function CountDownPanel.RepeatSetNum()
	if self.num > 0 then 
		if self.num <=5 then
			--播放音效
			LRDDZ_SoundManager.PlaySoundEffect("time",gameObject)
		end
		self.num = self.num -1
		--self.numSprite.fillAmount = self.num / self.maxNum
		self.numLabel.text = tostring(self.num)
	else 
		self.CancelCountDown(true)
	end 
end 
local start = false
local fillAmountNum = 0
function  CountDownPanel.OpenCountDown(type1,num,func,pos)
	self.time:Stop()
	gameObject:SetActive(true)
	self.func  = func 
	self.type = type1
	self.num = num
	self.maxNum = num
	fillAmountNum = num
	self.numLabel.text = tostring(num)
	self.numSprite.fillAmount = 1

	if self.type == CharacterType.Player then 
		DeskCardsCache.ClearSomeone(CharacterType.Player)
        transform.localPosition = Vector3.New(0,-100,0);
    elseif self.type == CharacterType.Computer then 
    	DeskCardsCache.ClearSomeone(CharacterType.Computer)
        transform.localPosition = Vector3.New(400, 60, 0);
    elseif self.type == CharacterType.OtherComputer then
    	DeskCardsCache.ClearSomeone(CharacterType.OtherComputer)
        transform.localPosition = Vector3.New(-400,60,0);
    end 
    if pos ~= nil then
    	transform.localPosition = pos;
    end
    self.time = Timer.New(self.RepeatSetNum, 1, -1, true)
	self.time:Start()
	start = true
end
function CountDownPanel.CancelCountDown(dofunc)
	self.time:Stop()
	start = false
	--如果不是等待发牌状态则执行且参数要执行
	if dofunc ==  true then
		if self.func ~= nil then 
			self.func()
		end 
	end
	self.func = nil	
	gameObject:SetActive(false)
end 
function CountDownPanel.Update()
	if start == true then
		self.numSprite.fillAmount = fillAmountNum / self.maxNum 
		fillAmountNum = fillAmountNum - UnityEngine.Time.deltaTime
	else

	end
end
function CountDownPanel.OnDisable()
	CountDownPanel.CancelCountDown(false)
end
function CountDownPanel.OnDestroy(  )

	self.time:Stop()
	self.time = nil	
	self.num = 0
	self.maxNum = 1
	self.type = nil
	self.func = nil 
	transform = nil
 	gameObject = nil
end
