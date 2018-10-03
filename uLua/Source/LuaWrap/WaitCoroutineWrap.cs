using System;
using UnityEngine;
using LuaInterface;

public class WaitCoroutineWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreateWaitCoroutine),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("isDoneCoroutine", get_isDoneCoroutine, set_isDoneCoroutine),
			new LuaField("DownWWW", get_DownWWW, set_DownWWW),
		};

		LuaScriptMgr.RegisterLib(L, "WaitCoroutine", typeof(WaitCoroutine), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateWaitCoroutine(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			WaitCoroutine obj = new WaitCoroutine();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: WaitCoroutine.New");
		}

		return 0;
	}

	static Type classType = typeof(WaitCoroutine);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isDoneCoroutine(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		WaitCoroutine obj = (WaitCoroutine)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isDoneCoroutine");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isDoneCoroutine on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isDoneCoroutine);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DownWWW(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		WaitCoroutine obj = (WaitCoroutine)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name DownWWW");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index DownWWW on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.DownWWW);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isDoneCoroutine(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		WaitCoroutine obj = (WaitCoroutine)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isDoneCoroutine");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isDoneCoroutine on a nil value");
			}
		}

		obj.isDoneCoroutine = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_DownWWW(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		WaitCoroutine obj = (WaitCoroutine)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name DownWWW");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index DownWWW on a nil value");
			}
		}

		obj.DownWWW = (WWW)LuaScriptMgr.GetNetObject(L, 3, typeof(WWW));
		return 0;
	}
}

