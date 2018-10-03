using System;
using UnityEngine;
using System.Collections.Generic;
using LuaInterface;
using Object = UnityEngine.Object;

public class PoolInfoWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("OnClickList", OnClickList),
			new LuaMethod("setMyPool", setMyPool),
			new LuaMethod("showTiShi", showTiShi),
			new LuaMethod("showByStr", showByStr),
			new LuaMethod("show", show),
			new LuaMethod("New", _CreatePoolInfo),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("_myFenTxt", get__myFenTxt, set__myFenTxt),
			new LuaField("_poolFenTxt", get__poolFenTxt, set__poolFenTxt),
			new LuaField("uInfoList", get_uInfoList, set_uInfoList),
			new LuaField("firstView", get_firstView, set_firstView),
		};

		LuaScriptMgr.RegisterLib(L, "PoolInfo", typeof(PoolInfo), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreatePoolInfo(IntPtr L)
	{
		LuaDLL.luaL_error(L, "PoolInfo class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(PoolInfo);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__myFenTxt(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PoolInfo obj = (PoolInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _myFenTxt");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _myFenTxt on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._myFenTxt);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__poolFenTxt(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PoolInfo obj = (PoolInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _poolFenTxt");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _poolFenTxt on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._poolFenTxt);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_uInfoList(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PoolInfo obj = (PoolInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name uInfoList");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index uInfoList on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.uInfoList);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_firstView(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PoolInfo obj = (PoolInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name firstView");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index firstView on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.firstView);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__myFenTxt(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PoolInfo obj = (PoolInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _myFenTxt");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _myFenTxt on a nil value");
			}
		}

		obj._myFenTxt = (UILabel)LuaScriptMgr.GetUnityObject(L, 3, typeof(UILabel));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__poolFenTxt(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PoolInfo obj = (PoolInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _poolFenTxt");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _poolFenTxt on a nil value");
			}
		}

		obj._poolFenTxt = (UILabel)LuaScriptMgr.GetUnityObject(L, 3, typeof(UILabel));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_uInfoList(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PoolInfo obj = (PoolInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name uInfoList");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index uInfoList on a nil value");
			}
		}

		obj.uInfoList = (GameObject)LuaScriptMgr.GetUnityObject(L, 3, typeof(GameObject));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_firstView(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PoolInfo obj = (PoolInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name firstView");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index firstView on a nil value");
			}
		}

		obj.firstView = (GameObject)LuaScriptMgr.GetUnityObject(L, 3, typeof(GameObject));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnClickList(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		PoolInfo obj = (PoolInfo)LuaScriptMgr.GetUnityObjectSelf(L, 1, "PoolInfo");
		obj.OnClickList();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setMyPool(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PoolInfo obj = (PoolInfo)LuaScriptMgr.GetUnityObjectSelf(L, 1, "PoolInfo");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.setMyPool(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int showTiShi(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PoolInfo obj = (PoolInfo)LuaScriptMgr.GetUnityObjectSelf(L, 1, "PoolInfo");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.showTiShi(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int showByStr(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		PoolInfo obj = (PoolInfo)LuaScriptMgr.GetUnityObjectSelf(L, 1, "PoolInfo");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		obj.showByStr(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int show(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		PoolInfo obj = (PoolInfo)LuaScriptMgr.GetUnityObjectSelf(L, 1, "PoolInfo");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		List<JSONObject> arg1 = (List<JSONObject>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<JSONObject>));
		obj.show(arg0,arg1);
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

