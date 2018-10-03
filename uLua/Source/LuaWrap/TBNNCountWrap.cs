using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class TBNNCountWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("UpdateHUD", UpdateHUD),
			new LuaMethod("DestroyHUD", DestroyHUD),
			new LuaMethod("New", _CreateTBNNCount),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("spriteL", get_spriteL, set_spriteL),
			new LuaField("spriteR", get_spriteR, set_spriteR),
			new LuaField("soundCount", get_soundCount, set_soundCount),
			new LuaField("Instance", get_Instance, null),
		};

		LuaScriptMgr.RegisterLib(L, "TBNNCount", typeof(TBNNCount), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateTBNNCount(IntPtr L)
	{
		LuaDLL.luaL_error(L, "TBNNCount class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(TBNNCount);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_spriteL(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		TBNNCount obj = (TBNNCount)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name spriteL");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index spriteL on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.spriteL);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_spriteR(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		TBNNCount obj = (TBNNCount)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name spriteR");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index spriteR on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.spriteR);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_soundCount(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		TBNNCount obj = (TBNNCount)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name soundCount");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index soundCount on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.soundCount);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Instance(IntPtr L)
	{
		LuaScriptMgr.Push(L, TBNNCount.Instance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_spriteL(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		TBNNCount obj = (TBNNCount)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name spriteL");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index spriteL on a nil value");
			}
		}

		obj.spriteL = (UISprite)LuaScriptMgr.GetUnityObject(L, 3, typeof(UISprite));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_spriteR(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		TBNNCount obj = (TBNNCount)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name spriteR");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index spriteR on a nil value");
			}
		}

		obj.spriteR = (UISprite)LuaScriptMgr.GetUnityObject(L, 3, typeof(UISprite));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_soundCount(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		TBNNCount obj = (TBNNCount)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name soundCount");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index soundCount on a nil value");
			}
		}

		obj.soundCount = (AudioClip)LuaScriptMgr.GetUnityObject(L, 3, typeof(AudioClip));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateHUD(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		TBNNCount obj = (TBNNCount)LuaScriptMgr.GetUnityObjectSelf(L, 1, "TBNNCount");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		obj.UpdateHUD(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DestroyHUD(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		TBNNCount obj = (TBNNCount)LuaScriptMgr.GetUnityObjectSelf(L, 1, "TBNNCount");
		obj.DestroyHUD();
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

