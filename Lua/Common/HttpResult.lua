
local this = LuaObject:New()

HttpResult = this

this.ResultType =
 {
 	['Failed'] = 'Failed',
 	['Sucess'] = 'Sucess',
}
this.ResultUnknowError = ZPLocalization.Instance.Get('HttpConnectFailed')

this.resultType = nil  
this.resultObject = nil 
this.isSwitchHost = false 

function this.HttpResult( )
	this.resultType = this.ResultType.Failed 
	this.resultObject = this.ResultUnknowError
end
