
local this = LuaObject:New()
PoolInfo = this


local _myFenTxt = nil
local _poolFenTxt = nil
local uInfoList = nil
local firstView = nil

function this:clearLuaValue()
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	_myFenTxt = nil
	_poolFenTxt = nil
	uInfoList = nil
	firstView = nil
		
	LuaGC();
end

function this:Init()
	print("PoolInfo Init")
	--this.sliderBgVolume = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_bgmusic/Slider").gameObject:GetComponent("UISlider")
	--this.sliderEffectVolume = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_bgsound/Slider").gameObject:GetComponent("UISlider")
	_myFenTxt = this.transform:FindChild("firstView/myFenText").gameObject:GetComponent("UILabel")
	_poolFenTxt = this.transform:FindChild("firstView/jcText").gameObject:GetComponent("UILabel")
	uInfoList = this.transform:FindChild("secondView").gameObject
	firstView = this.transform:FindChild("firstView").gameObject
	
	local scoreBtn = this.transform:FindChild("firstView/fenBtn").gameObject
	this.mono:AddClick(scoreBtn, this.OnClickList)
	
end
function this:Awake()
	this:Init()
	
end

function this:Start()
	uInfoList:SetActive(false)
	firstView:SetActive(false)

	local myLPool = uInfoList.transform:FindChild("myLPool"):GetComponent("UILabel");
	myLPool.text = "";
	_poolFenTxt.text = "";
	_myFenTxt.text = "";
	for i=0,7 do
		local indexT = uInfoList.transform:FindChild("peo"..i).transform:FindChild("mcTxt"):GetComponent("UILabel");
		local nickT = uInfoList.transform:FindChild("peo"..i).transform:FindChild("nickTxt"):GetComponent("UILabel");
		local fenT = uInfoList.transform:FindChild("peo"..i).transform:FindChild("fenTxt"):GetComponent("UILabel");
	end

end

function this:OnDestroy()
	this:clearLuaValue()
end

function this:OnClickList()
	if(uInfoList.activeSelf)then
		uInfoList:SetActive(false)
	else
		uInfoList:SetActive(true)
	end

end

function this:setMyPool(chiFen)
	if(not firstView.activeSelf)then
		firstView:SetActive(true)
	end

	_myFenTxt.text = chiFen .. ""

	local myLPool = uInfoList.transform:FindChild("myLPool"):GetComponent("UILabel")
	myLPool.text = chiFen .. ""
end

function this:showTip(info)
	EginProgressHUD.Instance:HideHUD()
	EginProgressHUD.Instance:ShowPromptHUD(info)
end

function this:show(poolScore, infos)
	if(not firstView.activeSelf)then
		firstView:SetActive(true)
	end

	_poolFenTxt.text = poolScore

	local  xNum = #(infos)
	if(xNum > 8)then
		xNum = 8
	end

	for i=1,xNum do
		local info = infos[i]
		local uNick = info[1]
		local uFen = info[2]

		local indexT = uInfoList.transform:FindChild("peo" .. (i-1)).transform:FindChild("mcTxt"):GetComponent("UILabel")
		local nickT = uInfoList.transform:FindChild("peo" .. (i-1)).transform:FindChild("nickTxt"):GetComponent("UILabel")
		local fenT = uInfoList.transform:FindChild("peo" .. (i-1)).transform:FindChild("fenTxt"):GetComponent("UILabel")

		indexT.text =  i .. ""
		nickT.text = this:LengNameSub(uNick)
		fenT.text = uFen
	end

end
function this:LengNameSub( text)
	
	if   LengthUTF8String(text) > 4 then
		return SubUTF8String(text,12);
	end
	return text;
end
