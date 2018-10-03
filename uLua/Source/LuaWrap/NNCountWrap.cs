using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class NNCountWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("UpdateHUD", UpdateHUD),
			new LuaMethod("toShakeStyle", toShakeStyle),
			new LuaMethod("UpdateLabelTime", UpdateLabelTime),
			new LuaMethod("DestroyHUD", DestroyHUD),
			new LuaMethod("New", _CreateNNCount),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("spriteL", get_spriteL, set_spriteL),
			new LuaField("spriteR", get_spriteR, set_spriteR),
			new LuaField("m_TimeLab", get_m_TimeLab, set_m_TimeLab),
			new LuaField("soundCount", get_soundCount, set_soundCount),
			new LuaField("Instance", get_Instance, null),
		};

		LuaScriptMgr.RegisterLib(L, "NNCount", typeof(NNCount), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateNNCount(IntPtr L)
	{
		LuaDLL.luaL_error(L, "NNCount class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(NNCount);

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
		NNCount obj = (NNCount)o;

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
		NNCount obj = (NNCount)o;

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
	static int get_m_TimeLab(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		NNCount obj = (NNCount)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_TimeLab");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_TimeLab on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.m_TimeLab);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_soundCount(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		NNCount obj = (NNCount)o;

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
		LuaScriptMgr.Push(L, NNCount.Instance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_spriteL(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		NNCount obj = (NNCount)o;

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
		NNCount obj = (NNCount)o;

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
	static int set_m_TimeLab(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		NNCount obj = (NNCount)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_TimeLab");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_TimeLab on a nil value");
			}
		}

		obj.m_TimeLab = (UILabel)LuaScriptMgr.GetUnityObject(L, 3, typeof(UILabel));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_soundCount(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		NNCount obj = (NNCount)o;

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
		NNCount obj = (NNCount)LuaScriptMgr.GetUnityObjectSelf(L, 1, "NNCount");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		obj.UpdateHUD(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int toShakeStyle(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		NNCount obj = (NNCount)LuaScriptMgr.GetUnityObjectSelf(L, 1, "NNCount");
		obj.toShakeStyle();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateLabelTime(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		NNCount obj = (NNCount)LuaScriptMgr.GetUnityObjectSelf(L, 1, "NNCount");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		obj.UpdateLabelTime(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DestroyHUD(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		NNCount obj = (NNCount)LuaScriptMgr.GetUnityObjectSelf(L, 1, "NNCount");
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

