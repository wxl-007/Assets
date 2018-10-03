
local this = LuaObject:New()
IPTest_Login = this

function this:Awake()
	Module_Bank:clearCachePwd()
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
