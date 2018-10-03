using System;
using LuaInterface;

public class HttpResult_ResultTypeWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Failed", GetFailed),
		new LuaMethod("Sucess", GetSucess),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "HttpResult.ResultType", typeof(HttpResult.ResultType), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFailed(IntPtr L)
	{
		LuaScriptMgr.Push(L, HttpResult.ResultType.Failed);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetSucess(IntPtr L)
	{
		LuaScriptMgr.Push(L, HttpResult.ResultType.Sucess);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		HttpResult.ResultType o = (HttpResult.ResultType)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

