using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class GameSettingManagerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("SetBgVolume", SetBgVolume),
			new LuaMethod("SetEffectVolume", SetEffectVolume),
			new LuaMethod("SetSpecial", SetSpecial),
			new LuaMethod("SetAutoNext", SetAutoNext),
			new LuaMethod("SetDeposit", SetDeposit),
			new LuaMethod("setDepositVisible", setDepositVisible),
			new LuaMethod("New", _CreateGameSettingManager),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("sliderBgVolume", get_sliderBgVolume, set_sliderBgVolume),
			new LuaField("sliderEffectVolume", get_sliderEffectVolume, set_sliderEffectVolume),
			new LuaField("spriteSpecial", get_spriteSpecial, set_spriteSpecial),
			new LuaField("kAutoNext", get_kAutoNext, set_kAutoNext),
			new LuaField("kDeposit", get_kDeposit, set_kDeposit),
			new LuaField("kAllDeposit", get_kAllDeposit, set_kAllDeposit),
			new LuaField("bagContainerPrafab", get_bagContainerPrafab, set_bagContainerPrafab),
		};

		LuaScriptMgr.RegisterLib(L, "GameSettingManager", typeof(GameSettingManager), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateGameSettingManager(IntPtr L)
	{
		LuaDLL.luaL_error(L, "GameSettingManager class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(GameSettingManager);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_sliderBgVolume(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name sliderBgVolume");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index sliderBgVolume on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.sliderBgVolume);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_sliderEffectVolume(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name sliderEffectVolume");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index sliderEffectVolume on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.sliderEffectVolume);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_spriteSpecial(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name spriteSpecial");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index spriteSpecial on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.spriteSpecial);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_kAutoNext(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name kAutoNext");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index kAutoNext on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.kAutoNext);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_kDeposit(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name kDeposit");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index kDeposit on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.kDeposit);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_kAllDeposit(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name kAllDeposit");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index kAllDeposit on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.kAllDeposit);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_bagContainerPrafab(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name bagContainerPrafab");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index bagContainerPrafab on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.bagContainerPrafab);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_sliderBgVolume(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name sliderBgVolume");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index sliderBgVolume on a nil value");
			}
		}

		obj.sliderBgVolume = (UISlider)LuaScriptMgr.GetUnityObject(L, 3, typeof(UISlider));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_sliderEffectVolume(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name sliderEffectVolume");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index sliderEffectVolume on a nil value");
			}
		}

		obj.sliderEffectVolume = (UISlider)LuaScriptMgr.GetUnityObject(L, 3, typeof(UISlider));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_spriteSpecial(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name spriteSpecial");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index spriteSpecial on a nil value");
			}
		}

		obj.spriteSpecial = (UIButton)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIButton));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_kAutoNext(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name kAutoNext");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index kAutoNext on a nil value");
			}
		}

		obj.kAutoNext = (UIButton)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIButton));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_kDeposit(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name kDeposit");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index kDeposit on a nil value");
			}
		}

		obj.kDeposit = (UIButton)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIButton));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_kAllDeposit(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name kAllDeposit");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index kAllDeposit on a nil value");
			}
		}

		obj.kAllDeposit = (UILabel)LuaScriptMgr.GetUnityObject(L, 3, typeof(UILabel));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_bagContainerPrafab(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameSettingManager obj = (GameSettingManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name bagContainerPrafab");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index bagContainerPrafab on a nil value");
			}
		}

		obj.bagContainerPrafab = (GameObject)LuaScriptMgr.GetUnityObject(L, 3, typeof(GameObject));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetBgVolume(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameSettingManager obj = (GameSettingManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameSettingManager");
		obj.SetBgVolume();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetEffectVolume(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameSettingManager obj = (GameSettingManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameSettingManager");
		obj.SetEffectVolume();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetSpecial(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameSettingManager obj = (GameSettingManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameSettingManager");
		obj.SetSpecial();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAutoNext(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameSettingManager obj = (GameSettingManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameSettingManager");
		obj.SetAutoNext();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetDeposit(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameSettingManager obj = (GameSettingManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameSettingManager");
		obj.SetDeposit();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setDepositVisible(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameSettingManager obj = (GameSettingManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameSettingManager");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.setDepositVisible(arg0);
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

