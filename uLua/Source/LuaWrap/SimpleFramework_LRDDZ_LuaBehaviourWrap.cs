using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class SimpleFramework_LRDDZ_LuaBehaviourWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("OnInit", OnInit),
			new LuaMethod("LoadAsset", LoadAsset),
			new LuaMethod("AddHover", AddHover),
			new LuaMethod("AddSubmit", AddSubmit),
			new LuaMethod("AddInput", AddInput),
			new LuaMethod("AddClick", AddClick),
			new LuaMethod("AddToggle", AddToggle),
			new LuaMethod("RemoveClick", RemoveClick),
			new LuaMethod("ClearClick", ClearClick),
			new LuaMethod("MyDestroy", MyDestroy),
			new LuaMethod("Event1", Event1),
			new LuaMethod("Event2", Event2),
			new LuaMethod("Event3", Event3),
			new LuaMethod("Event4", Event4),
			new LuaMethod("Event5", Event5),
			new LuaMethod("Event6", Event6),
			new LuaMethod("Event7", Event7),
			new LuaMethod("Event8", Event8),
			new LuaMethod("Event9", Event9),
			new LuaMethod("Event10", Event10),
			new LuaMethod("New", _CreateSimpleFramework_LRDDZ_LuaBehaviour),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("IsExtractCompleted", get_IsExtractCompleted, null),
		};

		LuaScriptMgr.RegisterLib(L, "SimpleFramework.LRDDZ_LuaBehaviour", typeof(SimpleFramework.LRDDZ_LuaBehaviour), regs, fields, typeof(View));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSimpleFramework_LRDDZ_LuaBehaviour(IntPtr L)
	{
		LuaDLL.luaL_error(L, "SimpleFramework.LRDDZ_LuaBehaviour class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(SimpleFramework.LRDDZ_LuaBehaviour);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsExtractCompleted(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsExtractCompleted");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsExtractCompleted on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsExtractCompleted);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnInit(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		AssetBundle arg0 = (AssetBundle)LuaScriptMgr.GetUnityObject(L, 2, typeof(AssetBundle));
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		obj.OnInit(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAsset(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		GameObject o = obj.LoadAsset(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddHover(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			obj.AddHover(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaFunction arg2 = LuaScriptMgr.GetLuaFunction(L, 4);
			obj.AddHover(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LRDDZ_LuaBehaviour.AddHover");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddSubmit(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
		LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
		obj.AddSubmit(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddInput(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			obj.AddInput(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
			UIInput arg0 = (UIInput)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIInput));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaTable arg2 = LuaScriptMgr.GetLuaTable(L, 4);
			obj.AddInput(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LRDDZ_LuaBehaviour.AddInput");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddClick(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
		LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
		obj.AddClick(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddToggle(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
			UIToggle arg0 = (UIToggle)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIToggle));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			obj.AddToggle(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
			UIToggle arg0 = (UIToggle)LuaScriptMgr.GetUnityObject(L, 2, typeof(UIToggle));
			LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
			LuaTable arg2 = LuaScriptMgr.GetLuaTable(L, 4);
			obj.AddToggle(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.LRDDZ_LuaBehaviour.AddToggle");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveClick(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
		obj.RemoveClick(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearClick(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.ClearClick();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MyDestroy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
		obj.MyDestroy(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event1(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event1();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event2(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event2();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event3(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event3();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event4(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event4();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event5(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event5();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event6(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event6();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event7(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event7();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event8(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event8();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event9(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event9();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Event10(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.LRDDZ_LuaBehaviour obj = (SimpleFramework.LRDDZ_LuaBehaviour)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.LRDDZ_LuaBehaviour");
		obj.Event10();
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

