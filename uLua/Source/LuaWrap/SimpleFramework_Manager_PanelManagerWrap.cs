using System;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class SimpleFramework_Manager_PanelManagerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("DictionaryAddRange", DictionaryAddRange),
			new LuaMethod("GameModule_LevelGUI_Map_Extend", GameModule_LevelGUI_Map_Extend),
			new LuaMethod("GameModule_Name_Map_Extend", GameModule_Name_Map_Extend),
			new LuaMethod("InitGui", InitGui),
			new LuaMethod("CreatePanel", CreatePanel),
			new LuaMethod("CreateGamePanel", CreateGamePanel),
			new LuaMethod("CreateNewGamePanel", CreateNewGamePanel),
			new LuaMethod("New", _CreateSimpleFramework_Manager_PanelManager),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("GameModule_LevelGUI_Map", get_GameModule_LevelGUI_Map, set_GameModule_LevelGUI_Map),
			new LuaField("GameModule_Name_Map", get_GameModule_Name_Map, set_GameModule_Name_Map),
			new LuaField("Parent", get_Parent, null),
		};

		LuaScriptMgr.RegisterLib(L, "SimpleFramework.Manager.PanelManager", typeof(SimpleFramework.Manager.PanelManager), regs, fields, typeof(View));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSimpleFramework_Manager_PanelManager(IntPtr L)
	{
		LuaDLL.luaL_error(L, "SimpleFramework.Manager.PanelManager class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(SimpleFramework.Manager.PanelManager);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameModule_LevelGUI_Map(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, SimpleFramework.Manager.PanelManager.GameModule_LevelGUI_Map);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameModule_Name_Map(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, SimpleFramework.Manager.PanelManager.GameModule_Name_Map);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Parent(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Parent");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Parent on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.Parent);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameModule_LevelGUI_Map(IntPtr L)
	{
		SimpleFramework.Manager.PanelManager.GameModule_LevelGUI_Map = (Dictionary<string,string>)LuaScriptMgr.GetNetObject(L, 3, typeof(Dictionary<string,string>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameModule_Name_Map(IntPtr L)
	{
		SimpleFramework.Manager.PanelManager.GameModule_Name_Map = (Dictionary<string,string>)LuaScriptMgr.GetNetObject(L, 3, typeof(Dictionary<string,string>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DictionaryAddRange(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Dictionary<string,string> arg0 = (Dictionary<string,string>)LuaScriptMgr.GetNetObject(L, 1, typeof(Dictionary<string,string>));
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		SimpleFramework.Manager.PanelManager.DictionaryAddRange(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GameModule_LevelGUI_Map_Extend(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		SimpleFramework.Manager.PanelManager.GameModule_LevelGUI_Map_Extend(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GameModule_Name_Map_Extend(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		SimpleFramework.Manager.PanelManager.GameModule_Name_Map_Extend(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitGui(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.PanelManager");
		obj.InitGui();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreatePanel(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.PanelManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			obj.CreatePanel(arg0);
			return 0;
		}
		else if (count == 3)
		{
			SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.PanelManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
			obj.CreatePanel(arg0,arg1);
			return 0;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(SimpleFramework.Manager.PanelManager), typeof(string), typeof(bool), typeof(LuaInterface.LuaFunction)))
		{
			SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.PanelManager");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			bool arg1 = LuaDLL.lua_toboolean(L, 3);
			LuaFunction arg2 = LuaScriptMgr.ToLuaFunction(L, 4);
			obj.CreatePanel(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(SimpleFramework.Manager.PanelManager), typeof(string), typeof(bool), typeof(bool)))
		{
			SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.PanelManager");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			bool arg1 = LuaDLL.lua_toboolean(L, 3);
			bool arg2 = LuaDLL.lua_toboolean(L, 4);
			obj.CreatePanel(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 5)
		{
			SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.PanelManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
			LuaFunction arg3 = LuaScriptMgr.GetLuaFunction(L, 5);
			obj.CreatePanel(arg0,arg1,arg2,arg3);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.Manager.PanelManager.CreatePanel");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreateGamePanel(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.PanelManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
		obj.CreateGamePanel(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreateNewGamePanel(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		SimpleFramework.Manager.PanelManager obj = (SimpleFramework.Manager.PanelManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.PanelManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 3);
		LuaFunction arg2 = LuaScriptMgr.GetLuaFunction(L, 4);
		obj.CreateNewGamePanel(arg0,arg1,arg2);
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

