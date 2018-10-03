using System;
using LuaInterface;

public class DG_Tweening_TweenWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreateDG_Tweening_Tween),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("timeScale", get_timeScale, set_timeScale),
			new LuaField("isBackwards", get_isBackwards, set_isBackwards),
			new LuaField("id", get_id, set_id),
			new LuaField("target", get_target, set_target),
			new LuaField("easeOvershootOrAmplitude", get_easeOvershootOrAmplitude, set_easeOvershootOrAmplitude),
			new LuaField("easePeriod", get_easePeriod, set_easePeriod),
			new LuaField("fullPosition", get_fullPosition, set_fullPosition),
		};

		LuaScriptMgr.RegisterLib(L, "DG.Tweening.Tween", typeof(DG.Tweening.Tween), regs, fields, typeof(DG.Tweening.Core.ABSSequentiable));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDG_Tweening_Tween(IntPtr L)
	{
		LuaDLL.luaL_error(L, "DG.Tweening.Tween class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(DG.Tweening.Tween);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_timeScale(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name timeScale");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index timeScale on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.timeScale);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isBackwards(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isBackwards");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isBackwards on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isBackwards);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_id(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name id");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index id on a nil value");
			}
		}

		LuaScriptMgr.PushVarObject(L, obj.id);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_target(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name target");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index target on a nil value");
			}
		}

		LuaScriptMgr.PushVarObject(L, obj.target);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_easeOvershootOrAmplitude(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name easeOvershootOrAmplitude");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index easeOvershootOrAmplitude on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.easeOvershootOrAmplitude);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_easePeriod(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name easePeriod");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index easePeriod on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.easePeriod);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fullPosition(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fullPosition");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fullPosition on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.fullPosition);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_timeScale(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name timeScale");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index timeScale on a nil value");
			}
		}

		obj.timeScale = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isBackwards(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isBackwards");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isBackwards on a nil value");
			}
		}

		obj.isBackwards = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_id(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name id");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index id on a nil value");
			}
		}

		obj.id = LuaScriptMgr.GetVarObject(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_target(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name target");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index target on a nil value");
			}
		}

		obj.target = LuaScriptMgr.GetVarObject(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_easeOvershootOrAmplitude(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name easeOvershootOrAmplitude");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index easeOvershootOrAmplitude on a nil value");
			}
		}

		obj.easeOvershootOrAmplitude = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_easePeriod(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name easePeriod");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index easePeriod on a nil value");
			}
		}

		obj.easePeriod = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fullPosition(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		DG.Tweening.Tween obj = (DG.Tweening.Tween)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fullPosition");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fullPosition on a nil value");
			}
		}

		obj.fullPosition = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}
}

