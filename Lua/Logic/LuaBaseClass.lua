--使用LuaBaseClass创建的类可以使用Get,Set函数
local type = type
local rawset = rawset
local setmetatable = setmetatable

local traceCount = 0
local tracebacks = setmetatable({}, {__mode = "k"})

function LuaBaseClass(classname, super)
    local cls = {}
	
    cls.classname = classname
    cls.class = cls
    cls.Get = {}
    cls.Set = {}
    
    local Get = cls.Get
    local Set = cls.Set

    if super then
        -- copy super method 
        for key, value in pairs(super) do
            if type(value) == "function" and key ~= "ctor" then
                cls[key] = value
            end
        end

        -- copy super getter
        for key, value in pairs(super.Get) do
            Get[key] = value
        end
        
        -- copy super setter
        for key, value in pairs(super.Set) do
            Set[key] = value
        end
        
        cls.super = super
    end

    function cls.__index(self, key)
        local func = cls[key]
        if func then
           return func
        end

        local getter = Get[key]
        if getter then
            return getter(self)
        end

        return nil
    end

    function cls.__newindex(self, key, value)
        local setter = Set[key]
        if setter then
            setter(self, value or false)
            return
        end

        if Get[key] then
            assert(false, "readonly property")
        end
        
        rawset(self, key, value)
    end

    function cls.new(...)
        local self = setmetatable({}, cls)
        local function create(cls, ...)
            if cls.super then
                create(cls.super, ...)
            end
            if cls.ctor then
                cls.ctor(self, ...)
            end
        end
        create(cls, ...)
        
        -- debug
        traceCount = traceCount + 1
        tracebacks[self] = traceCount

        return self
    end

    return cls
end
 --使用例子
--[[]]
 local test = LuaBaseClass("test") 
function test:ctor(x, y)
    self.test = x
    self.y = y 
end 
function test.Get:Test() 
	return self.test
end
function test.Set:Test(value)  
	self.test = value 
end 
function test.Get:y()  
	return self._y 
end
function test.Set:y(value)  
	self._y = value 
end

local p = test.new(10, 20)
log(p.Test.."===="..p.y) 
p.Test= 5
p.y = 6 
log(p.Test.."===="..p.y) 
