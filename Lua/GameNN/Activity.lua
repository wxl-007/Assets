
local this = LuaObject:New()
Activity = this
--全局变量控制红包活动是否开启
this.is_award = false;
function this:clearLuaValue()
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	
	this.AddBg = nil
	this.AddBgLabel =nil
	
	this.CountBg = nil
	this.CountBgLabel = nil
	 
	LuaGC();
end
function this:Init()

	this.res = ResManager:LoadAsset("gamenn/GameActivity","GameActivity")
	this.player = NGUITools.AddChild(this.gameObject,this.res);

	this.player.name = "GameActivity";


	this.AddBg = this.player.transform:FindChild("AddBg").gameObject 
	this.AddBgLabel = this.player.transform:FindChild("AddBg/Label").gameObject:GetComponent("UILabel")
	this.CountBgPoint = this.transform:FindChild("CountBg")
	this.CountBg = this.player.transform:FindChild("CountBg").gameObject
	this.Countbtn = this.player.transform:FindChild("CountBg/bg").gameObject 
	this.CountBgLabel = this.player.transform:FindChild("CountBg/Label").gameObject:GetComponent("UILabel")
	 this.CountBg.transform.parent = this.CountBgPoint
	 this.CountBg.transform.localPosition = Vector3.New(0,0,0);

	 local countbtnPoint = this.CountBgPoint:FindChild("bg").gameObject 
	 if countbtnPoint then
	 	countbtnPoint:SetActive(false)
	 end
end
function this:Awake()
	if this:CheckActivityGobj() then
		this:Init();
		this.mono:AddClick(this.Countbtn, this.OnCountBg);
		this.gameObject:SetActive(true);
	else
		this.gameObject:SetActive(false);			
	end 

end


function this:Start()
	 
end
--手动关闭
function this:ManualLock()
	 this.is_award = false
	 this.gameObject:SetActive(false)
end
--检测 Activity (活动) 是否需要显示
function this:CheckActivityGobj() 
	if true then
		--return true
	end
	if( not this.is_award) then 
		return false;
	end 
	if( not PlatformGameDefine.playform.IOSPayFlag) then
		return false;
	end 
	 
	if(PlatformGameDefine.playform:GetPlatformPrefix()=="510k") then
		return false;
	end
	
	if(PlatformGameDefine.playform:GetPlatformPrefix()~="597") then 
		return false;
	end
	return true;
end
 
function this:OnDisable()
	
	
end

function this.OnDestroy()
	this:clearLuaValue()
end



function this:SetScale(num) 
	if( not this:CheckActivityGobj()) then return; end
	if num == nil or this.AddBg == nil then return; end
	
	this.AddBg.transform.localScale = Vector3.New(num,num,1); 
	this.CountBg.transform.localScale = Vector3.New(num,num,1); 
end

function this:SetCountBgLabel(num) 
	if( not this:CheckActivityGobj()) then return; end
	if num == nil or this.AddBg == nil then return; end
	
	this.CountBgLabel.text = tostring(num)
end
function this:SetAddBg(num) 
	if( not this:CheckActivityGobj()) then return; end
	if num == nil or this.AddBg == nil then return; end
	
	this.AddBgLabel.text = tostring(num-tonumber(this.CountBgLabel.text))
	this.CountBgLabel.text =  tostring(num)
	
	coroutine.start(this.AddBgActivity)
end

function this:AddBgActivity() 
	 this.AddBg:SetActive(true)
	 coroutine.wait(2)
	 if this.mono ~= nil then 
		this.AddBg:SetActive(false)
	 end
end

function this:OnCountBg() 
	--去网站http://pay.game597.cn/activity/seventh/
	Application.OpenURL("http://pay.game597.cn/activity/midautumn/");
end

