using System;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class SimpleFramework_Manager_ResourceManagerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("UnLoadGameAssetBundles", UnLoadGameAssetBundles),
			new LuaMethod("LoadAsset", LoadAsset),
			new LuaMethod("ClearBundles", ClearBundles),
			new LuaMethod("LoadAssetBundle", LoadAssetBundle),
			new LuaMethod("PreLoad", PreLoad),
			new LuaMethod("Debug_Resources_Load", Debug_Resources_Load),
			new LuaMethod("Debug_Search_Path", Debug_Search_Path),
			new LuaMethod("New", _CreateSimpleFramework_Manager_ResourceManager),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("bundles", get_bundles, set_bundles),
		};

		LuaScriptMgr.RegisterLib(L, "SimpleFramework.Manager.ResourceManager", typeof(SimpleFramework.Manager.ResourceManager), regs, fields, typeof(View));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSimpleFramework_Manager_ResourceManager(IntPtr L)
	{
		LuaDLL.luaL_error(L, "SimpleFramework.Manager.ResourceManager class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(SimpleFramework.Manager.ResourceManager);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_bundles(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name bundles");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index bundles on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.bundles);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_bundles(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name bundles");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index bundles on a nil value");
			}
		}

		obj.bundles = (Dictionary<string,AssetBundle>)LuaScriptMgr.GetNetObject(L, 3, typeof(Dictionary<string,AssetBundle>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UnLoadGameAssetBundles(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		obj.UnLoadGameAssetBundles();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAsset(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			Object o = obj.LoadAsset(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4)
		{
			SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			LuaFunction arg2 = LuaScriptMgr.GetLuaFunction(L, 4);
			obj.LoadAsset(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.Manager.ResourceManager.LoadAsset");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearBundles(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		obj.ClearBundles();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAssetBundle(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		AssetBundle o = obj.LoadAssetBundle(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PreLoad(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(SimpleFramework.Manager.ResourceManager), typeof(string[])))
		{
			SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
			string[] objs0 = LuaScriptMgr.GetArrayString(L, 2);
			obj.PreLoad(objs0);
			return 0;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(SimpleFramework.Manager.ResourceManager), typeof(string)))
		{
			SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			obj.PreLoad(arg0);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.Manager.ResourceManager.PreLoad");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Debug_Resources_Load(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		Object o = obj.Debug_Resources_Load(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Debug_Search_Path(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		string o = obj.Debug_Search_Path(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
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

