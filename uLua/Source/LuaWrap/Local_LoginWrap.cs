using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class Local_LoginWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("inputChanged", inputChanged),
			new LuaMethod("New", _CreateLocal_Login),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("localServerIP_IP", get_localServerIP_IP, set_localServerIP_IP),
			new LuaField("serverIP", get_serverIP, set_serverIP),
		};

		LuaScriptMgr.RegisterLib(L, "Local_Login", typeof(Local_Login), regs, fields, typeof(Login));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateLocal_Login(IntPtr L)
	{
		LuaDLL.luaL_error(L, "Local_Login class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(Local_Login);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_localServerIP_IP(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Local_Login obj = (Local_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name localServerIP_IP");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index localServerIP_IP on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.localServerIP_IP);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_serverIP(IntPtr L)
	{
		LuaScriptMgr.Push(L, Local_Login.serverIP);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_localServerIP_IP(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Local_Login obj = (Local_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name localServerIP_IP");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index localServerIP_IP on a nil value");
			}
		}

		obj.localServerIP_IP = (UIInput)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIInput));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_serverIP(IntPtr L)
	{
		Local_Login.serverIP = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int inputChanged(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Local_Login obj = (Local_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Local_Login");
		obj.inputChanged();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_Eq(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Object arg0 = LuaScriptMgr.GetLuaObject(L, 1) as Object;
		Object arg1 = LuaScriptMgr.GetLuaObject(L, 2) as Object;
		bool o = arg0 == arg1;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

