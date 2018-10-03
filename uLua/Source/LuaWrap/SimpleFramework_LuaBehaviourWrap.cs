using System;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class SimpleFramework_LuaBehaviourWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("getRefObj", getRefObj),
			new LuaMethod("GetGameObject", GetGameObject),
			new LuaMethod("LoadAsset", LoadAsset),
			new LuaMethod("AddSlider", AddSlider),
			new LuaMethod("AddPopupList", AddPopupList),
			new LuaMethod("AddInput", AddInput),
			new LuaMethod("AddToggle", AddToggle),
			new LuaMethod("AddClick", AddClick),
			new LuaMethod("ClearClick", ClearClick),
			new LuaMethod("New", _CreateSimpleFramework_LuaBehaviour),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("refObjList", get_refObjList, set_refObjList),
		};

		LuaScriptMgr.RegisterLib(L, "SimpleFramework.LuaBehaviour", typeof(SimpleFramework.LuaBehaviour), regs, fields, typeof(View));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSimpleFramework_LuaBehaviour(IntPtr L)
	{
		LuaDLL.luaL_error(L, "SimpleFramework.LuaBehaviour class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(SimpleFramework.LuaBehaviour);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_refObjList(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name refObjList");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index refObjList on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.refObjList);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_refObjList(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name refObjList");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index refObjList on a nil value");
			}
		}

		obj.refObjList = (List<SimpleFramework.RefObj>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<SimpleFramework.RefObj>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getRefObj(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		GameObject o = obj.getRefObj(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetGameObject(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		GameObject o = obj.GetGameObject(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAsset(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			Object o = obj.LoadAsset(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			Object o = obj.LoadAsset(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LuaBehaviour.LoadAsset");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddSlider(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			UISlider arg0 = (UISlider)LuaScriptMgr.GetUnityObject(L, 2, typeof(UISlider));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			obj.AddSlider(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			UISlider arg0 = (UISlider)LuaScriptMgr.GetUnityObject(L, 2, typeof(UISlider));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaTable arg2 = LuaScriptMgr.GetLuaTable(L, 4);
			obj.AddSlider(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LuaBehaviour.AddSlider");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddPopupList(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			UIPopupList arg0 = (UIPopupList)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIPopupList));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			obj.AddPopupList(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			UIPopupList arg0 = (UIPopupList)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIPopupList));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaTable arg2 = LuaScriptMgr.GetLuaTable(L, 4);
			obj.AddPopupList(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LuaBehaviour.AddPopupList");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddInput(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			UIInput arg0 = (UIInput)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIInput));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			obj.AddInput(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			UIInput arg0 = (UIInput)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIInput));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaTable arg2 = LuaScriptMgr.GetLuaTable(L, 4);
			obj.AddInput(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LuaBehaviour.AddInput");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddToggle(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			UIToggle arg0 = (UIToggle)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIToggle));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			obj.AddToggle(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			UIToggle arg0 = (UIToggle)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIToggle));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaTable arg2 = LuaScriptMgr.GetLuaTable(L, 4);
			obj.AddToggle(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LuaBehaviour.AddToggle");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddClick(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			obj.AddClick(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaTable arg2 = LuaScriptMgr.GetLuaTable(L, 4);
			obj.AddClick(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 5)
		{
			SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaTable arg2 = LuaScriptMgr.GetLuaTable(L, 4);
			LuaTable arg3 = LuaScriptMgr.GetLuaTable(L, 5);
			obj.AddClick(arg0,arg1,arg2,arg3);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LuaBehaviour.AddClick");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearClick(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LuaBehaviour obj = (SimpleFramework.LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LuaBehaviour");
		obj.ClearClick();
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

