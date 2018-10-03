
local this = LuaObject:New()
SimpleHUD = this



function this:Init(pObj)
	this.gameObject = pObj
	this.transform=this.gameObject.transform
	this.m_PromptHUD = this.transform:FindChild('PromptHUD').gameObject
	this.m_ProLab = this.transform:FindChild('PromptHUD/Label').gameObject:GetComponent('UILabel')

	this.m_WaitHUD = this.transform:FindChild('WaitHUD').gameObject
	this.m_Waitlab = this.transform:FindChild('WaitHUD/Label').gameObject:GetComponent('UILabel')
	this.CurAct = nil 
	this.m_ProLength = 2
	this.m_PromptHUD:SetActive(false)
	this.m_WaitHUD:SetActive(false)
end


function this:ShowPromptHUD( pTxt,...)
	local arg = {...}
	this.m_ProLab.text = pTxt
	if this.CurAct ~= nil then 
		this.CurAct:SetActive(false)
	end
	this.CurAct = this.m_PromptHUD
	this.CurAct:SetActive(true)
	this.gameObject:SetActive(true)
	
	this.CurAct.transform.localScale = Vector3.one
	iTween.ScaleFrom(this.m_PromptHUD, iTween.Hash ("scale",Vector3.one*0.5,"time",0.5,"easetype",iTween.EaseType.easeOutElastic,"oncomplete", this.HideHUD))
	this.CurAct = this.m_PromptHUD

	if type(arg[1]) == 'number' then
		if type(arg[2]) == 'function' then
			this:HideHUDAfter(arg[1],arg[2])
		else
			this:HideHUDAfter(arg[1],nil)
		end

	elseif type(arg[1]) =='function' then
		this:HideHUDAfter( this.m_ProLength,arg[1])
	else
		-- this:HideHUDAfter( this.m_ProLength,nil)
	end
end

function this.HideHUD()
	this.gameObject:SetActive(false)
	if this.CurAct ~= nil then 
		this.CurAct:SetActive(false)
		this.CurAct = nil 
	end
end

function this:WaitHUD(pTxt)
	this.m_Waitlab.text = pTxt or ''
	if this.CurAct ~= nil then 
		this.CurAct:SetActive(false)
	end
	this.CurAct = this.m_WaitHUD
	this.CurAct:SetActive(true)
	iTween.ScaleFrom(this.CurAct,iTween.Hash ("scale",Vector3.one*0.5,"time",0.5,"easetype",iTween.EaseType.easeOutElastic))
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