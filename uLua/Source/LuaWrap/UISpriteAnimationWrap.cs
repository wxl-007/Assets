using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class UISpriteAnimationWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("RebuildSpriteList", RebuildSpriteList),
			new LuaMethod("Play", Play),
			new LuaMethod("Pause", Pause),
			new LuaMethod("ResetToBeginning", ResetToBeginning),
			new LuaMethod("invertPlay", invertPlay),
			new LuaMethod("playWithCallback", playWithCallback),
			new LuaMethod("New", _CreateUISpriteAnimation),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("isInvert", get_isInvert, set_isInvert),
			new LuaField("frames", get_frames, null),
			new LuaField("framesPerSecond", get_framesPerSecond, set_framesPerSecond),
			new LuaField("namePrefix", get_namePrefix, set_namePrefix),
			new LuaField("loop", get_loop, set_loop),
			new LuaField("isPlaying", get_isPlaying, null),
		};

		LuaScriptMgr.RegisterLib(L, "UISpriteAnimation", typeof(UISpriteAnimation), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUISpriteAnimation(IntPtr L)
	{
		LuaDLL.luaL_error(L, "UISpriteAnimation class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(UISpriteAnimation);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isInvert(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isInvert");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isInvert on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isInvert);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_frames(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name frames");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index frames on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.frames);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_framesPerSecond(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name framesPerSecond");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index framesPerSecond on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.framesPerSecond);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_namePrefix(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name namePrefix");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index namePrefix on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.namePrefix);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_loop(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name loop");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index loop on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.loop);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isPlaying(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isPlaying");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isPlaying on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isPlaying);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isInvert(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isInvert");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isInvert on a nil value");
			}
		}

		obj.isInvert = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_framesPerSecond(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name framesPerSecond");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index framesPerSecond on a nil value");
			}
		}

		obj.framesPerSecond = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_namePrefix(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name namePrefix");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index namePrefix on a nil value");
			}
		}

		obj.namePrefix = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_loop(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name loop");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index loop on a nil value");
			}
		}

		obj.loop = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RebuildSpriteList(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UISpriteAnimation");
		obj.RebuildSpriteList();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Play(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UISpriteAnimation");
		obj.Play();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Pause(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UISpriteAnimation");
		obj.Pause();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ResetToBeginning(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UISpriteAnimation obj = (UISpriteAnimation)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UISpriteAnimation");
		obj.ResetToBeginning();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int invertPlay(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UISpriteAnimation obj = (UISpriteAnimation)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UISpriteAnimation");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		obj.invertPlay(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int playWithCallback(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			UISpriteAnimation obj = (UISpriteAnimation)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UISpriteAnimation");
			Action arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg0 = () =>
				{
					func.Call();
				};
			}

			obj.playWithCallback(arg0);
			return 0;
		}
		else if (count == 3)
		{
			UISpriteAnimation obj = (UISpriteAnimation)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UISpriteAnimation");
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
			Action arg1 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (Action)LuaScriptMgr.GetNetObject(L, 3, typeof(Action));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
				arg1 = () =>
				{
					func.Call();
				};
			}

			obj.playWithCallback(arg0,arg1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UISpriteAnimation.playWithCallback");
		}

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

