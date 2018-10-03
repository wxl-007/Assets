local this = LuaObject:New()
InvokeLua = this 
--invokeobj->>实现本类的类对象
function this:New(invokeobj)
	local o = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(o, self);  --将self的元表设定为Class
	self.__index = self
	o.invokeObj = invokeobj;
	o:Init()
	return o;    --返回自身
end


function this:clearLuaValue()
	self.invokeObj = nil
	self.functionNames = nil
end
function this:Init()

	self.functionNames ={}
end
--调用一次
--functionName-->>调用函数的key具有唯一性,类型string
--run-->>要调用的函数,类型function
function this:Invoke(functionName,run, delay)
	if self.functionNames[functionName] ~= nil then return; end
	self.functionNames[functionName] = run;
	coroutine.start(self.AfterDoing,self,delay, function(self,functionName)
						if self.functionNames and self.functionNames[functionName] ~= nil then
							self.functionNames[functionName](self.invokeObj);
							self.functionNames[functionName] = nil;
						end
					end,functionName);
end
--重复调用 
function this:InvokeRepeating(functionName,run, delay,interval)
	if self.functionNames[functionName] ~= nil then return; end
	self.functionNames[functionName] = run;
	coroutine.start(self.AfterDoing,self,delay, function(self,functionName,interval)
						while  self.functionNames and self.functionNames[functionName] do	
							self.functionNames[functionName](self.invokeObj);
							coroutine.wait(interval);
						end
					end,functionName,interval);
end

--结束方法,如果没有传入函数名则结束本类所有函数
 function this:CancelInvoke(functionName)
	if functionName == nil then
		self.functionNames = {};
	else
		self.functionNames[functionName] = nil;
	end
 end

--指定函数是否在调用 如果没有传入函数名则是否在有在调用的函数
 function this:IsInvoking(functionName)
	local isinvoking = false;
	if functionName == nil then
		for key,v in pairs(self.functionNames) do
			if v ~= nil then
				isinvoking = true;
				break;
			end
		end
	else
		if self.functionNames[functionName] ~= nil then
			isinvoking = true;
		end
	end
	return isinvoking;
 end
 function this:AfterDoing(offset,run,functionName,interval)
	coroutine.wait(offset);	
	if self.invokeObj then
		run(self,functionName,interval);
	end
end
