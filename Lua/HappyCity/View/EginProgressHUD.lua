
local this = LuaObject:New()
EginProgressHUD = this
this.Instance = this 

-- this.m_Background 
-- this.m_GameBackground
-- this.m_PromptHUD
-- this.m_PromtMessageLabel
-- this.m_PromptHudDuration 
-- this.m_WaitHUD
-- this.m_Waitmessagelabel
-- this.m_SrpsGameTiShi
-- this.m_SrpsGameLabel

-- this.m_SrpsGameTiShi2
-- this.m_SrpsGameLabel2

-- this.m_SrpsWaitHUD
-- this.m_SrpsMessageLabel

-- this.m_TiShi

-- this.m_SrpsTiShi
-- this.m_SrpsTiShiLabel


-- function this:Awake()
-- 	this.transform = find('ProgressHUD(Clone)')
-- 	this.gameObject =find('ProgressHUD(Clone)').gameObject
-- 	this:Init()
-- end

function this:Start( )
	
end

function this:OnEnable(  )
	--this:Init()
end

function this:Init()
	this.gameObject = GameObject.Find('ProgressHUD(Clone)').gameObject
	this.transform=this.gameObject.transform

	this.m_Background = this.transform:FindChild('Background').gameObject
	this.m_GameBackground = this.transform:FindChild('SrpsGameTishi/backgroundtishi').gameObject
	this.m_PromptHUD = this.transform:FindChild('PromptHUD').gameObject
	this.m_PromtMessageLabel = this.transform:FindChild('PromptHUD/Label').gameObject:GetComponent('UILabel')
	this.m_PromptHudDuration =2
	this.m_WaitHUD = this.transform:FindChild('WaitHUD').gameObject
	this.m_Waitmessagelabel = this.transform:FindChild('WaitHUD/Label').gameObject:GetComponent('UILabel')
	this.m_SrpsGameTiShi = this.transform:FindChild('SrpsGameTishi').gameObject
	this.m_SrpsGameLabel = this.m_SrpsGameTiShi.transform:FindChild('Label').gameObject:GetComponent('UILabel')

	this.m_SrpsGameTiShi2 = this.transform:FindChild('SrpsTishi2').gameObject
	this.SrpsGametishi2 = this.m_SrpsGameTiShi2
	this.m_SrpsGameLabel2 = this.m_SrpsGameTiShi2.transform:FindChild('Label').gameObject:GetComponent('UILabel')
	this.SrpsGameLabel2 = this.m_SrpsGameLabel2

	
	this.m_SrpsWaitHUD = this.transform:FindChild('SrpsWaitHUD').gameObject
	this.m_SrpsMessageLabel = this.m_SrpsWaitHUD.transform:FindChild('Label').gameObject:GetComponent('UILabel')

	this.m_TiShi = this.transform:FindChild('SrpsPurchase').gameObject

	this.m_SrpsTiShi = this.transform:FindChild('SrpsTishi').gameObject
	this.m_SrpsTiShiLabel = this.m_SrpsTiShi.transform:FindChild('Label').gameObject:GetComponent('UILabel')
	this.CurControl = ''
end


function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil
	this.m_Background  = nil 
	this.m_GameBackground = nil 
	this.m_PromptHUD  = nil 
	this.m_PromtMessageLabel  = nil 
	this.m_PromptHudDuration  = nil 
	this.m_WaitHUD = nil 
	this.m_Waitmessagelabel = nil 
	this.m_SrpsGameTiShi = nil 
	this.m_SrpsGameLabel = nil 

	this.m_SrpsGameTiShi2 = nil 
	this.SrpsGametishi2 = nil 
	this.m_SrpsGameLabel2 = nil 
	this.SrpsGameLabel2 = nil

	this.m_SrpsWaitHUD = nil 
	this.m_SrpsMessageLabel = nil 

	this.m_TiShi = nil 

	this.m_SrpsTiShi = nil 
	this.m_SrpsTiShiLabel = nil 
	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
end

function this:ShowPromptHUD(pMessage,...)
	this.CurControl = 'Prompt'
	local arg = {...}
	this.m_SrpsGameTiShi:SetActive(false)
	this.m_PromtMessageLabel.text = pMessage
	this:ShowHUD( this.m_PromptHUD )
	this:PopupEffect( this.m_PromptHUD  )
	if type(arg[1]) == 'number' then
		
		if type(arg[2]) == 'function' then
			this:HideHUDAfter(arg[1],arg[2])
		else
			this:HideHUDAfter(arg[1],nil)
		end

	elseif type(arg[1]) =='function' then
		this:HideHUDAfter( this.m_PromptHudDuration,arg[1])
	else
		this:HideHUDAfter( this.m_PromptHudDuration,nil)
	end

end

function this:ShowHUD( pObj )
	this.m_PromptHUD:SetActive(false)
	this.m_WaitHUD:SetActive(false)
	this.m_SrpsWaitHUD:SetActive(false)
	this.m_TiShi:SetActive(false)
	this.m_SrpsTiShi:SetActive(false)
	pObj:SetActive(true)
	this.gameObject:SetActive(true)
end
	

function this:PopupEffect( pObj )
	pObj.transform.localScale = Vector3.one
	iTween.ScaleFrom(pObj, iTween.Hash ("scale",Vector3.one*0.5,"time",0.5,"easetype",iTween.EaseType.easeOutElastic))
end

function this:HideHUDAfter( pTime,pFunc )
	coroutine.start(function ()
		coroutine.wait(pTime)
		this.gameObject:SetActive(false)
		if pFunc ~= nil then 
			if type(pFunc) == 'function' then
				pFunc()
			end
		end
	end)
end

function this:SrpsShowWaitHUD( pMessage,pTime)
	this.m_SrpsGameTiShi:SetActive(false)
	this.m_SrpsMessageLabel.text = pMessage
	this:ShowHUD( this.m_SrpsWaitHUD )
	local tTime = this.m_PromptHudDuration
	if pTime ~= nil and type(pTime)=='number' then
		tTime = tTime
	end
	this:HideHUDAfter( tTime,nil)
end

function this:SrpsShowWaitHUD1( pMessage,pTime)
	this.m_GameBackground:SetActive(false)
	this.m_Background:SetActive(false)
	local tTime = this.m_PromptHudDuration
	if pTime ~= nil and type(pTime)=='number' then
		tTime = tTime
	end
	this.m_SrpsMessageLabel.text = pMessage
	iTween.Stop(this.m_SrpsGameLabel.gameObject)
	this.m_SrpsGameLabel2.gameObject.transform.localPosition = Vector3.New(0,0,-0.1)
	this.m_SrpsGameLabel2.alpha = 1
	iTween.MoveAdd(this.SrpsGameLabel2.gameObject,iTween.Hash('y',0.6,'delay',1.0,'time',tTime,'easetype',iTween.EaseType.linear))
	coroutine.start(function ( )
		for i=1,10 do
			coroutine.wait(tTime/10)
			this.m_SrpsGameLabel.alpha = 1-0.1*i
			if this.m_SrpsGameLabel.alpha <=0 then
				break
			end
		end
		this.m_SrpsGameLabel.alpha = 0
		this.gameObject:SetActive(false)
	end)
end



function this:SrpsShowWaitHUD2(pMessage )
	this.m_GameBackground:SetActive(false)
	this.m_Background:SetActive(false)
	this.m_SrpsGameLabel2.text = pMessage
	this:ShowHUD(this.m_SrpsGameTiShi2)
	iTween.Stop(this.m_SrpsGameLabel2.gameObject)
	coroutine.start(function ( )
		coroutine.wait(6)
		this.m_SrpsGameLabel2.gameObject.transform.localPosition = Vector3.New(0,0,-0.1)
		this.m_SrpsGameLabel2.alpha = 1
		iTween.MoveAdd(this.SrpsGameLabel2.gameObject,iTween.Hash('y',0.6,'time',tTime,'easetype',iTween.EaseType.linear))
		--iTween.ValueTo(this.SrpsGameLabel2.gameObject,iTween.Hash())
		coroutine.wait(5)
		for i=1,10 do
			coroutine.wait(0.1)
			this.m_SrpsGameLabel2.alpha = 1-0.1*i
			if this.m_SrpsGameLabel2.alpha <=0 then
				break
			end
		end
		this.m_SrpsGameLabel2.alpha = 0
		this.gameObject:SetActive(false)
	end)
end

function this:HideHUD( )
	if this.gameObject == nil or this.transform == nil  then
		this:Init()
	else
		if this.CurControl == 'Wait' then 
			this.gameObject:SetActive(false)
			
		end
	end 
end


function this:SrpsTishi( pMessage,pTime )
	this.m_SrpsTiShiLabel.text = pMessage
	this:ShowHUD(this.m_SrpsTiShi)
	local tTime = this.m_PromptHudDuration
	if pTime ~= nil and type(pTime)=='number' then
		tTime = tTime
	end
	this:HideHUDAfter(tTime,nil)
end

function this:SrpsShowTishi( pTime )
	local tTime = this.m_PromptHudDuration
	if pTime ~= nil and type(pTime)=='number' then
		tTime = tTime
	end
	this:ShowHUD(this.m_TiShi)
	this.m_Background:SetActive(false)
	this:HideHUDAfter(tTime,nil)
end

function this:ShowWaitHUD(pMessage,pIsShowLab)
	this.CurControl = 'Wait'
	if this.gameObject == nil or this.transform == nil  then
		this:Init()
	end
	if pIsShowLab == nil then
		pIsShowLab = false 
	end

	this.m_SrpsGameTiShi:SetActive(false)
	this.m_Waitmessagelabel.text = pMessage
	this:ShowHUD(this.m_WaitHUD)
end

function this:ResetUIRoot()
	if this.gameObject == nil or this.transform == nil  then
		this:Init()
	end
	local tRoot = this.transform.gameObject:GetComponent("UIRoot")
	 if tRoot then 
        tRoot.fitWidth = true 
        tRoot.fitHeight = false 
    end
end