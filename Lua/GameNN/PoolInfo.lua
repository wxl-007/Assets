
local this = LuaObject:New()
PoolInfo = this


local _myFenTxt = nil
local _poolFenTxt = nil
local uInfoList = nil
local firstView = nil
local movePanel=nil;
local xiala_btn=nil;
local rule=nil;
function this:clearLuaValue()
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	_myFenTxt = nil
	_poolFenTxt = nil
	uInfoList = nil
	firstView = nil
	movePanel=nil;
	xiala_btn=nil;
	rule=nil;
	
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
	movePanel=uInfoList.transform:FindChild("panel/movePanel").gameObject;
	rule=movePanel.transform:FindChild("rule").gameObject;
	ScrollView=rule:GetComponent("UIScrollView");--滑动组件
	--local scoreBtn = this.transform:FindChild("firstView/fenBtn").gameObject
	--this.mono:AddClick(scoreBtn, this.OnClickList)
	this.mono:AddClick(firstView, this.OnClickList)
	
	xiala_btn=this.transform:FindChild("secondView/xiala_btn"):GetComponent("UISprite");												   
	this.mono:AddClick(xiala_btn.gameObject,this.OnClickButton);
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
		--local indexT = uInfoList.transform:FindChild("panel/movePanel/rank/peo"..i).transform:FindChild("mcTxt"):GetComponent("UILabel");
		local nickT = uInfoList.transform:FindChild("panel/movePanel/rank/peo"..i).transform:FindChild("nickTxt"):GetComponent("UILabel");
		local fenT = uInfoList.transform:FindChild("panel/movePanel/rank/peo"..i).transform:FindChild("fenTxt"):GetComponent("UILabel");
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

function this:OnClickButton()
	--log("移动开始");
	--log(movePanel.transform.localPosition.y);
	if movePanel.transform.localPosition.y==0 then
		--log("上移");
		xiala_btn.transform.localEulerAngles=Vector3.New(0,0,0);
		
		
		--iTween.MoveTo(movePanel,iTween.Hash ("position", Vector3.New(0, 550, 0),"time",0.3,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));
		movePanel.transform.localPosition=Vector3.New(0, 820, 0);
		coroutine.start(this.showRule,this);
	else
		--log("下移");
		xiala_btn.transform.localEulerAngles=Vector3.New(0,0,180);
		iTween.MoveTo(movePanel,iTween.Hash ("position", Vector3.New(0, 0, 0),"time",0.3,"islocal", true ,"easeType", iTween.EaseType.easeOutQuart));
	end
end

function this:showRule()
	log("显示");
	rule:SetActive(false);
	coroutine.wait(0);
	rule:SetActive(true);
	ScrollView:ResetPosition();
end

function this:setMyPool(chiFen)
	if(not firstView.activeSelf)then
		firstView:SetActive(true)
	end

	_myFenTxt.text = chiFen .. ""
	local myPool = uInfoList.transform:FindChild("myLPool_1"):GetComponent("UILabel")
	myPool.text = _myFenTxt.text;
	--local myLPool = uInfoList.transform:FindChild("panel/movePanel/rank/myLPool"):GetComponent("UILabel")
	--myLPool.text = chiFen .. ""
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
	local allPool = uInfoList.transform:FindChild("myLPool"):GetComponent("UILabel")
	allPool.text = _poolFenTxt.text;
	--local myPool = uInfoList.transform:FindChild("panel/movePanel/rank/myLPool_1"):GetComponent("UILabel")
	--myPool.text = _myFenTxt.text;
	
	local  xNum = #(infos)
	if(xNum > 8)then
		xNum = 8
	end

	for i=1,xNum do
		local info = infos[i]
		--printf(info);
		local uNick = info[1]
		local uFen = info[2]

		--local indexT = uInfoList.transform:FindChild("panel/movePanel/rank/peo" .. (i-1)).transform:FindChild("mcTxt"):GetComponent("UILabel")
		local nickT = uInfoList.transform:FindChild("panel/movePanel/rank/peo" .. (i-1)).transform:FindChild("nickTxt"):GetComponent("UILabel")
		local fenT = uInfoList.transform:FindChild("panel/movePanel/rank/peo" .. (i-1)).transform:FindChild("fenTxt"):GetComponent("UILabel")
		
		local color1="B15104FF";
		local color2="1A7540FF";
		--indexT.text =  i .. ""
		if tostring(uNick)==EginUser.Instance.nickname then
			nickT.text = System.String.Format ("[{0}]{1}[-]",color2,this:LengNameSub(uNick));                
			fenT.text = System.String.Format ("[{0}]{1}[-]",color2,uFen); 
		else
			nickT.text = System.String.Format ("[{0}]{1}[-]",color1,this:LengNameSub(uNick));
			fenT.text = System.String.Format ("[{0}]{1}[-]",color1,uFen); 
		end
	end

end
function this:LengNameSub( text)
	
	if   LengthUTF8String(text) > 4 then
		return SubUTF8String(text,12);
	end
	return text;
end
