using System;
using UnityEngine;
using LuaInterface;

public class CoroutineResultWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreateCoroutineResult),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("error", get_error, set_error),
			new LuaField("_BoolResult", get__BoolResult, set__BoolResult),
			new LuaField("_StringResult", get__StringResult, set__StringResult),
			new LuaField("_IntResult", get__IntResult, set__IntResult),
			new LuaField("_wwwResult", get__wwwResult, set__wwwResult),
			new LuaField("_AssetBundleResult", get__AssetBundleResult, set__AssetBundleResult),
			new LuaField("_objectResult", get__objectResult, set__objectResult),
		};

		LuaScriptMgr.RegisterLib(L, "CoroutineResult", typeof(CoroutineResult), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateCoroutineResult(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			CoroutineResult obj = new CoroutineResult();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: CoroutineResult.New");
		}

		return 0;
	}

	static Type classType = typeof(CoroutineResult);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_error(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name error");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index error on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.error);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__BoolResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _BoolResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _BoolResult on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._BoolResult);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__StringResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _StringResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _StringResult on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._StringResult);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IntResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IntResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IntResult on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IntResult);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__wwwResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _wwwResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _wwwResult on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj._wwwResult);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__AssetBundleResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _AssetBundleResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _AssetBundleResult on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._AssetBundleResult);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__objectResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _objectResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _objectResult on a nil value");
			}
		}

		LuaScriptMgr.PushVarObject(L, obj._objectResult);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_error(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name error");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index error on a nil value");
			}
		}

		obj.error = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__BoolResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _BoolResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _BoolResult on a nil value");
			}
		}

		obj._BoolResult = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__StringResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _StringResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _StringResult on a nil value");
			}
		}

		obj._StringResult = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IntResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IntResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IntResult on a nil value");
			}
		}

		obj._IntResult = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__wwwResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _wwwResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _wwwResult on a nil value");
			}
		}

		obj._wwwResult = (WWW)LuaScriptMgr.GetNetObject(L, 3, typeof(WWW));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__AssetBundleResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _AssetBundleResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _AssetBundleResult on a nil value");
			}
		}

		obj._AssetBundleResult = (AssetBundle)LuaScriptMgr.GetUnityObject(L, 3, typeof(AssetBundle));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__objectResult(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		CoroutineResult obj = (CoroutineResult)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _objectResult");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _objectResult on a nil value");
			}
		}

		obj._objectResult = LuaScriptMgr.GetVarObject(L, 3);
		return 0;
	}
}

