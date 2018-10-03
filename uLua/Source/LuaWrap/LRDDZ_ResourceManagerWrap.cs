using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class LRDDZ_ResourceManagerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("getProgress", getProgress),
			new LuaMethod("getAppPath", getAppPath),
			new LuaMethod("LoadNeedAsset", LoadNeedAsset),
			new LuaMethod("LoadTexture", LoadTexture),
			new LuaMethod("LoadAsset", LoadAsset),
			new LuaMethod("loadAsset", loadAsset),
			new LuaMethod("UnLoadAssetBundle", UnLoadAssetBundle),
			new LuaMethod("LoadNeedAssetAsync", LoadNeedAssetAsync),
			new LuaMethod("LoadBYAssetAsync", LoadBYAssetAsync),
			new LuaMethod("CreatePanel", CreatePanel),
			new LuaMethod("CreatePoker", CreatePoker),
			new LuaMethod("Create3DOjbect", Create3DOjbect),
			new LuaMethod("InitGui", InitGui),
			new LuaMethod("StartGame", StartGame),
			new LuaMethod("LoadLevel", LoadLevel),
			new LuaMethod("New", _CreateLRDDZ_ResourceManager),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("IsExtractCompleted", get_IsExtractCompleted, null),
			new LuaField("Instance", get_Instance, null),
			new LuaField("Parent", get_Parent, null),
		};

		LuaScriptMgr.RegisterLib(L, "LRDDZ_ResourceManager", typeof(LRDDZ_ResourceManager), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateLRDDZ_ResourceManager(IntPtr L)
	{
		LuaDLL.luaL_error(L, "LRDDZ_ResourceManager class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(LRDDZ_ResourceManager);

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
		LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)o;

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
	static int get_Instance(IntPtr L)
	{
		LuaScriptMgr.Push(L, LRDDZ_ResourceManager.Instance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Parent(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)o;

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
	static int getProgress(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		float o = LRDDZ_ResourceManager.getProgress();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getAppPath(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = LRDDZ_ResourceManager.getAppPath(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadNeedAsset(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		Object o = LRDDZ_ResourceManager.LoadNeedAsset(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadTexture(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		Texture o = LRDDZ_ResourceManager.LoadTexture(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAsset(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			string arg1 = LuaScriptMgr.GetLuaString(L, 2);
			Object o = LRDDZ_ResourceManager.LoadAsset(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 5)
		{
			LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_ResourceManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			string arg2 = LuaScriptMgr.GetLuaString(L, 4);
			bool arg3 = LuaScriptMgr.GetBoolean(L, 5);
			GameObject o = obj.LoadAsset(arg0,arg1,arg2,arg3);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: LRDDZ_ResourceManager.LoadAsset");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int loadAsset(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Object o = LRDDZ_ResourceManager.loadAsset(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UnLoadAssetBundle(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		LRDDZ_ResourceManager.UnLoadAssetBundle(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadNeedAssetAsync(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_ResourceManager");
		obj.LoadNeedAssetAsync();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadBYAssetAsync(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_ResourceManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		Action<Object> arg2 = null;
		LuaTypes funcType4 = LuaDLL.lua_type(L, 4);

		if (funcType4 != LuaTypes.LUA_TFUNCTION)
		{
			 arg2 = (Action<Object>)LuaScriptMgr.GetNetObject(L, 4, typeof(Action<Object>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 4);
			arg2 = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}

		obj.LoadBYAssetAsync(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreatePanel(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4)
		{
			LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_ResourceManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
			obj.CreatePanel(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 5)
		{
			LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_ResourceManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
			LuaFunction arg3 = LuaScriptMgr.GetLuaFunction(L, 5);
			obj.CreatePanel(arg0,arg1,arg2,arg3);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: LRDDZ_ResourceManager.CreatePanel");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreatePoker(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 6);
		LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_ResourceManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 3);
		Vector3 arg2 = LuaScriptMgr.GetVector3(L, 4);
		bool arg3 = LuaScriptMgr.GetBoolean(L, 5);
		LuaFunction arg4 = LuaScriptMgr.GetLuaFunction(L, 6);
		obj.CreatePoker(arg0,arg1,arg2,arg3,arg4);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Create3DOjbect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 9);
		LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_ResourceManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		string arg2 = LuaScriptMgr.GetLuaString(L, 4);
		Vector3 arg3 = LuaScriptMgr.GetVector3(L, 5);
		Vector3 arg4 = LuaScriptMgr.GetVector3(L, 6);
		bool arg5 = LuaScriptMgr.GetBoolean(L, 7);
		LuaFunction arg6 = LuaScriptMgr.GetLuaFunction(L, 8);
		GameObject arg7 = (GameObject)LuaScriptMgr.GetUnityObject(L, 9, typeof(GameObject));
		obj.Create3DOjbect(arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitGui(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LRDDZ_ResourceManager obj = (LRDDZ_ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_ResourceManager");
		obj.InitGui();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartGame(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		LRDDZ_ResourceManager.StartGame();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadLevel(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			LRDDZ_ResourceManager.LoadLevel(arg0);
			return 0;
		}
		else if (count == 3)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
			LuaFunction arg2 = LuaScriptMgr.GetLuaFunction(L, 3);
			LRDDZ_ResourceManager.LoadLevel(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: LRDDZ_ResourceManager.LoadLevel");
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

