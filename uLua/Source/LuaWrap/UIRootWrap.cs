using System;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class UIRootWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("GetPixelSizeAdjustment", GetPixelSizeAdjustment),
			new LuaMethod("UpdateScale", UpdateScale),
			new LuaMethod("Broadcast", Broadcast),
			new LuaMethod("New", _CreateUIRoot),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("list", get_list, set_list),
			new LuaField("scalingStyle", get_scalingStyle, set_scalingStyle),
			new LuaField("manualWidth", get_manualWidth, set_manualWidth),
			new LuaField("manualHeight", get_manualHeight, set_manualHeight),
			new LuaField("minimumHeight", get_minimumHeight, set_minimumHeight),
			new LuaField("maximumHeight", get_maximumHeight, set_maximumHeight),
			new LuaField("fitWidth", get_fitWidth, set_fitWidth),
			new LuaField("fitHeight", get_fitHeight, set_fitHeight),
			new LuaField("adjustByDPI", get_adjustByDPI, set_adjustByDPI),
			new LuaField("shrinkPortraitUI", get_shrinkPortraitUI, set_shrinkPortraitUI),
			new LuaField("constraint", get_constraint, null),
			new LuaField("activeScaling", get_activeScaling, null),
			new LuaField("activeHeight", get_activeHeight, null),
			new LuaField("pixelSizeAdjustment", get_pixelSizeAdjustment, null),
		};

		LuaScriptMgr.RegisterLib(L, "UIRoot", typeof(UIRoot), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUIRoot(IntPtr L)
	{
		LuaDLL.luaL_error(L, "UIRoot class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(UIRoot);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_list(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, UIRoot.list);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_scalingStyle(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name scalingStyle");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index scalingStyle on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.scalingStyle);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_manualWidth(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name manualWidth");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index manualWidth on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.manualWidth);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_manualHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name manualHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index manualHeight on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.manualHeight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_minimumHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name minimumHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index minimumHeight on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.minimumHeight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_maximumHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name maximumHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index maximumHeight on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.maximumHeight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fitWidth(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fitWidth");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fitWidth on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.fitWidth);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fitHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fitHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fitHeight on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.fitHeight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_adjustByDPI(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name adjustByDPI");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index adjustByDPI on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.adjustByDPI);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_shrinkPortraitUI(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name shrinkPortraitUI");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index shrinkPortraitUI on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.shrinkPortraitUI);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_constraint(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name constraint");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index constraint on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.constraint);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_activeScaling(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name activeScaling");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index activeScaling on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.activeScaling);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_activeHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name activeHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index activeHeight on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.activeHeight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_pixelSizeAdjustment(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name pixelSizeAdjustment");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index pixelSizeAdjustment on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.pixelSizeAdjustment);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_list(IntPtr L)
	{
		UIRoot.list = (List<UIRoot>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<UIRoot>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_scalingStyle(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name scalingStyle");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index scalingStyle on a nil value");
			}
		}

		obj.scalingStyle = (UIRoot.Scaling)LuaScriptMgr.GetNetObject(L, 3, typeof(UIRoot.Scaling));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_manualWidth(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name manualWidth");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index manualWidth on a nil value");
			}
		}

		obj.manualWidth = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_manualHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name manualHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index manualHeight on a nil value");
			}
		}

		obj.manualHeight = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_minimumHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name minimumHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index minimumHeight on a nil value");
			}
		}

		obj.minimumHeight = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_maximumHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name maximumHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index maximumHeight on a nil value");
			}
		}

		obj.maximumHeight = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fitWidth(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fitWidth");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fitWidth on a nil value");
			}
		}

		obj.fitWidth = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fitHeight(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fitHeight");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fitHeight on a nil value");
			}
		}

		obj.fitHeight = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_adjustByDPI(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name adjustByDPI");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index adjustByDPI on a nil value");
			}
		}

		obj.adjustByDPI = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_shrinkPortraitUI(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIRoot obj = (UIRoot)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name shrinkPortraitUI");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index shrinkPortraitUI on a nil value");
			}
		}

		obj.shrinkPortraitUI = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetPixelSizeAdjustment(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 1, typeof(GameObject));
			float o = UIRoot.GetPixelSizeAdjustment(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2)
		{
			UIRoot obj = (UIRoot)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIRoot");
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
			float o = obj.GetPixelSizeAdjustment(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UIRoot.GetPixelSizeAdjustment");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateScale(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UIRoot obj = (UIRoot)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIRoot");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.UpdateScale(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Broadcast(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			UIRoot.Broadcast(arg0);
			return 0;
		}
		else if (count == 2)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			UIRoot.Broadcast(arg0,arg1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UIRoot.Broadcast");
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

