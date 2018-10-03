
local this = LuaObject:New()
TestLogView = this

function this:Awake()
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
