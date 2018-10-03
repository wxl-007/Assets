using System;
using LuaInterface;

public class LoginTypeWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Username", GetUsername),
		new LuaMethod("WeChat", GetWeChat),
		new LuaMethod("Guest", GetGuest),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "LoginType", typeof(LoginType), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetUsername(IntPtr L)
	{
		LuaScriptMgr.Push(L, LoginType.Username);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetWeChat(IntPtr L)
	{
		LuaScriptMgr.Push(L, LoginType.WeChat);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetGuest(IntPtr L)
	{
		LuaScriptMgr.Push(L, LoginType.Guest);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		LoginType o = (LoginType)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

