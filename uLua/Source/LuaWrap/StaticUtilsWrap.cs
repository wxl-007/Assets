using System;
using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using LuaInterface;

public class StaticUtilsWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("CompareConfig", CompareConfig),
			new LuaMethod("UpdateFiles", UpdateFiles),
			new LuaMethod("UpdateConfig", UpdateConfig),
			new LuaMethod("UpdateGameModules", UpdateGameModules),
			new LuaMethod("UpdateInstantUpdateConfig", UpdateInstantUpdateConfig),
			new LuaMethod("DownloadCloudAssets", DownloadCloudAssets),
			new LuaMethod("ExtractGame", ExtractGame),
			new LuaMethod("GetVersionUpdateControl", GetVersionUpdateControl),
			new LuaMethod("InsertUpdateUrlWithVersionCode", InsertUpdateUrlWithVersionCode),
			new LuaMethod("GetLocalConfigJson", GetLocalConfigJson),
			new LuaMethod("GetLocalVersionControlCode", GetLocalVersionControlCode),
			new LuaMethod("GetLocalModuleList", GetLocalModuleList),
			new LuaMethod("CheckGameModulesExist", CheckGameModulesExist),
			new LuaMethod("CheckRelativeUrl", CheckRelativeUrl),
			new LuaMethod("Copy", Copy),
			new LuaMethod("Cut", Cut),
			new LuaMethod("Move", Move),
			new LuaMethod("Crypt", Crypt),
			new LuaMethod("md5", md5),
			new LuaMethod("SetDownloadCloudAssetsComplete", SetDownloadCloudAssetsComplete),
			new LuaMethod("GetDownloadCloudAssetComplete", GetDownloadCloudAssetComplete),
			new LuaMethod("DisposeAsync", DisposeAsync),
			new LuaMethod("CheckTimeOut", CheckTimeOut),
			new LuaMethod("WWWReConnect", WWWReConnect),
			new LuaMethod("CheckHttpStatusCode", CheckHttpStatusCode),
			new LuaMethod("Start_Coroutine", Start_Coroutine),
			new LuaMethod("Delay", Delay),
			new LuaMethod("ObtainPingFromUrl", ObtainPingFromUrl),
			new LuaMethod("IsAvailable", IsAvailable),
			new LuaMethod("GetGameManager", GetGameManager),
			new LuaMethod("StartCoroutineLuaToC", StartCoroutineLuaToC),
			new LuaMethod("New", _CreateStaticUtils),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaScriptMgr.RegisterLib(L, "StaticUtils", regs);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateStaticUtils(IntPtr L)
	{
		LuaDLL.luaL_error(L, "StaticUtils class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(StaticUtils);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CompareConfig(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 5)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			string arg1 = LuaScriptMgr.GetLuaString(L, 2);
			List<string> arg2 = (List<string>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<string>));
			bool arg3 = LuaScriptMgr.GetBoolean(L, 4);
			Action<JSONObject,JSONObject,string> arg4 = null;
			LuaTypes funcType5 = LuaDLL.lua_type(L, 5);

			if (funcType5 != LuaTypes.LUA_TFUNCTION)
			{
				 arg4 = (Action<JSONObject,JSONObject,string>)LuaScriptMgr.GetNetObject(L, 5, typeof(Action<JSONObject,JSONObject,string>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 5);
				arg4 = (param0, param1, param2) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushObject(L, param0);
					LuaScriptMgr.PushObject(L, param1);
					LuaScriptMgr.Push(L, param2);
					func.PCall(top, 3);
					func.EndPCall(top);
				};
			}

			IEnumerator o = StaticUtils.CompareConfig(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 6)
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
			string arg1 = LuaScriptMgr.GetLuaString(L, 2);
			string arg2 = LuaScriptMgr.GetLuaString(L, 3);
			List<string> arg3 = (List<string>)LuaScriptMgr.GetNetObject(L, 4, typeof(List<string>));
			bool arg4 = LuaScriptMgr.GetBoolean(L, 5);
			Action<JSONObject,JSONObject,string> arg5 = null;
			LuaTypes funcType6 = LuaDLL.lua_type(L, 6);

			if (funcType6 != LuaTypes.LUA_TFUNCTION)
			{
				 arg5 = (Action<JSONObject,JSONObject,string>)LuaScriptMgr.GetNetObject(L, 6, typeof(Action<JSONObject,JSONObject,string>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 6);
				arg5 = (param0, param1, param2) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushObject(L, param0);
					LuaScriptMgr.PushObject(L, param1);
					LuaScriptMgr.Push(L, param2);
					func.PCall(top, 3);
					func.EndPCall(top);
				};
			}

			Coroutine o = StaticUtils.CompareConfig(arg0,arg1,arg2,arg3,arg4,arg5);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: StaticUtils.CompareConfig");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateFiles(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 8);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		string arg2 = LuaScriptMgr.GetLuaString(L, 3);
		JSONObject arg3 = (JSONObject)LuaScriptMgr.GetNetObject(L, 4, typeof(JSONObject));
		JSONObject arg4 = (JSONObject)LuaScriptMgr.GetNetObject(L, 5, typeof(JSONObject));
		bool arg5 = LuaScriptMgr.GetBoolean(L, 6);
		Action<string,long,long> arg6 = null;
		LuaTypes funcType7 = LuaDLL.lua_type(L, 7);

		if (funcType7 != LuaTypes.LUA_TFUNCTION)
		{
			 arg6 = (Action<string,long,long>)LuaScriptMgr.GetNetObject(L, 7, typeof(Action<string,long,long>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 7);
			arg6 = (param0, param1, param2) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				LuaScriptMgr.Push(L, param2);
				func.PCall(top, 3);
				func.EndPCall(top);
			};
		}

		Action<string,JSONObject> arg7 = null;
		LuaTypes funcType8 = LuaDLL.lua_type(L, 8);

		if (funcType8 != LuaTypes.LUA_TFUNCTION)
		{
			 arg7 = (Action<string,JSONObject>)LuaScriptMgr.GetNetObject(L, 8, typeof(Action<string,JSONObject>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 8);
			arg7 = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.PushObject(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}

		StaticUtils.UpdateFiles(arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateConfig(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		JSONObject arg1 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		JSONObject arg2 = (JSONObject)LuaScriptMgr.GetNetObject(L, 3, typeof(JSONObject));
		StaticUtils.UpdateConfig(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateGameModules(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 5)
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
			List<string> arg1 = (List<string>)LuaScriptMgr.GetNetObject(L, 2, typeof(List<string>));
			bool arg2 = LuaScriptMgr.GetBoolean(L, 3);
			Action<string,long,long> arg3 = null;
			LuaTypes funcType4 = LuaDLL.lua_type(L, 4);

			if (funcType4 != LuaTypes.LUA_TFUNCTION)
			{
				 arg3 = (Action<string,long,long>)LuaScriptMgr.GetNetObject(L, 4, typeof(Action<string,long,long>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 4);
				arg3 = (param0, param1, param2) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					LuaScriptMgr.Push(L, param1);
					LuaScriptMgr.Push(L, param2);
					func.PCall(top, 3);
					func.EndPCall(top);
				};
			}

			Action<string,JSONObject> arg4 = null;
			LuaTypes funcType5 = LuaDLL.lua_type(L, 5);

			if (funcType5 != LuaTypes.LUA_TFUNCTION)
			{
				 arg4 = (Action<string,JSONObject>)LuaScriptMgr.GetNetObject(L, 5, typeof(Action<string,JSONObject>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 5);
				arg4 = (param0, param1) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					LuaScriptMgr.PushObject(L, param1);
					func.PCall(top, 2);
					func.EndPCall(top);
				};
			}

			StaticUtils.UpdateGameModules(arg0,arg1,arg2,arg3,arg4);
			return 0;
		}
		else if (count == 7)
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
			string arg1 = LuaScriptMgr.GetLuaString(L, 2);
			string arg2 = LuaScriptMgr.GetLuaString(L, 3);
			List<string> arg3 = (List<string>)LuaScriptMgr.GetNetObject(L, 4, typeof(List<string>));
			bool arg4 = LuaScriptMgr.GetBoolean(L, 5);
			Action<string,long,long> arg5 = null;
			LuaTypes funcType6 = LuaDLL.lua_type(L, 6);

			if (funcType6 != LuaTypes.LUA_TFUNCTION)
			{
				 arg5 = (Action<string,long,long>)LuaScriptMgr.GetNetObject(L, 6, typeof(Action<string,long,long>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 6);
				arg5 = (param0, param1, param2) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					LuaScriptMgr.Push(L, param1);
					LuaScriptMgr.Push(L, param2);
					func.PCall(top, 3);
					func.EndPCall(top);
				};
			}

			Action<string,JSONObject> arg6 = null;
			LuaTypes funcType7 = LuaDLL.lua_type(L, 7);

			if (funcType7 != LuaTypes.LUA_TFUNCTION)
			{
				 arg6 = (Action<string,JSONObject>)LuaScriptMgr.GetNetObject(L, 7, typeof(Action<string,JSONObject>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 7);
				arg6 = (param0, param1) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					LuaScriptMgr.PushObject(L, param1);
					func.PCall(top, 2);
					func.EndPCall(top);
				};
			}

			StaticUtils.UpdateGameModules(arg0,arg1,arg2,arg3,arg4,arg5,arg6);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: StaticUtils.UpdateGameModules");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateInstantUpdateConfig(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		List<string> arg1 = (List<string>)LuaScriptMgr.GetNetObject(L, 2, typeof(List<string>));
		Action<string,JSONObject> arg2 = null;
		LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

		if (funcType3 != LuaTypes.LUA_TFUNCTION)
		{
			 arg2 = (Action<string,JSONObject>)LuaScriptMgr.GetNetObject(L, 3, typeof(Action<string,JSONObject>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
			arg2 = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.PushObject(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}

		StaticUtils.UpdateInstantUpdateConfig(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DownloadCloudAssets(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		Action<string,long,long> arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (Action<string,long,long>)LuaScriptMgr.GetNetObject(L, 2, typeof(Action<string,long,long>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = (param0, param1, param2) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				LuaScriptMgr.Push(L, param2);
				func.PCall(top, 3);
				func.EndPCall(top);
			};
		}

		Action<string,bool> arg2 = null;
		LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

		if (funcType3 != LuaTypes.LUA_TFUNCTION)
		{
			 arg2 = (Action<string,bool>)LuaScriptMgr.GetNetObject(L, 3, typeof(Action<string,bool>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
			arg2 = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}

		StaticUtils.DownloadCloudAssets(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ExtractGame(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		Action<string,JSONObject> arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (Action<string,JSONObject>)LuaScriptMgr.GetNetObject(L, 2, typeof(Action<string,JSONObject>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.PushObject(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}

		List<string> arg2 = (List<string>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<string>));
		StaticUtils.ExtractGame(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetVersionUpdateControl(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Action<int> arg0 = null;
		LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

		if (funcType1 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action<int>)LuaScriptMgr.GetNetObject(L, 1, typeof(Action<int>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
			arg0 = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}

		StaticUtils.GetVersionUpdateControl(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InsertUpdateUrlWithVersionCode(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		string o = StaticUtils.InsertUpdateUrlWithVersionCode(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLocalConfigJson(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		JSONObject o = StaticUtils.GetLocalConfigJson(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLocalVersionControlCode(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = StaticUtils.GetLocalVersionControlCode();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLocalModuleList(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		List<string> o = StaticUtils.GetLocalModuleList();
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckGameModulesExist(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		List<string> arg0 = (List<string>)LuaScriptMgr.GetNetObject(L, 1, typeof(List<string>));
		List<string> o = StaticUtils.CheckGameModulesExist(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckRelativeUrl(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		string o = StaticUtils.CheckRelativeUrl(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Copy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		StaticUtils.Copy(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Cut(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		StaticUtils.Cut(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Move(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		StaticUtils.Move(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Crypt(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(byte[])))
		{
			byte[] objs0 = LuaScriptMgr.GetArrayNumber<byte>(L, 1);
			byte[] o = StaticUtils.Crypt(objs0);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			StaticUtils.Crypt(arg0);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: StaticUtils.Crypt");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int md5(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(byte[])))
		{
			byte[] objs0 = LuaScriptMgr.GetArrayNumber<byte>(L, 1);
			string o = StaticUtils.md5(objs0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string o = StaticUtils.md5(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: StaticUtils.md5");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetDownloadCloudAssetsComplete(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		bool arg0 = LuaScriptMgr.GetBoolean(L, 1);
		StaticUtils.SetDownloadCloudAssetsComplete(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDownloadCloudAssetComplete(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		bool o = StaticUtils.GetDownloadCloudAssetComplete();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DisposeAsync(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		WWW arg0 = (WWW)LuaScriptMgr.GetNetObject(L, 1, typeof(WWW));
		StaticUtils.DisposeAsync(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckTimeOut(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		WWW arg0 = (WWW)LuaScriptMgr.GetNetObject(L, 1, typeof(WWW));
		Action arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = () =>
			{
				func.Call();
			};
		}

		CoroutineResult arg2 = (CoroutineResult)LuaScriptMgr.GetNetObject(L, 3, typeof(CoroutineResult));
		float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
		IEnumerator o = StaticUtils.CheckTimeOut(arg0,arg1,arg2,arg3);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WWWReConnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 5);
		CoroutineResult arg0 = (CoroutineResult)LuaScriptMgr.GetNetObject(L, 1, typeof(CoroutineResult));
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		Action arg2 = null;
		LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

		if (funcType3 != LuaTypes.LUA_TFUNCTION)
		{
			 arg2 = (Action)LuaScriptMgr.GetNetObject(L, 3, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
			arg2 = () =>
			{
				func.Call();
			};
		}

		float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
		int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
		IEnumerator o = StaticUtils.WWWReConnect(arg0,arg1,arg2,arg3,arg4);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckHttpStatusCode(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		int o = StaticUtils.CheckHttpStatusCode(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Start_Coroutine(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(MonoBehaviour), typeof(Coroutine), typeof(Action)))
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetLuaObject(L, 1);
			Coroutine arg1 = (Coroutine)LuaScriptMgr.GetLuaObject(L, 2);
			Action arg2 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg2 = (Action)LuaScriptMgr.GetLuaObject(L, 3);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
				arg2 = () =>
				{
					func.Call();
				};
			}

			Coroutine o = StaticUtils.Start_Coroutine(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(MonoBehaviour), typeof(IEnumerator), typeof(Action)))
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetLuaObject(L, 1);
			IEnumerator arg1 = (IEnumerator)LuaScriptMgr.GetLuaObject(L, 2);
			Action arg2 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg2 = (Action)LuaScriptMgr.GetLuaObject(L, 3);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
				arg2 = () =>
				{
					func.Call();
				};
			}

			Coroutine o = StaticUtils.Start_Coroutine(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckTypes(L, 1, typeof(MonoBehaviour), typeof(Action)) && LuaScriptMgr.CheckParamsType(L, typeof(Coroutine), 3, count - 2))
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetLuaObject(L, 1);
			Action arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (Action)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = () =>
				{
					func.Call();
				};
			}

			Coroutine[] objs2 = LuaScriptMgr.GetParamsObject<Coroutine>(L, 3, count - 2);
			Coroutine o = StaticUtils.Start_Coroutine(arg0,arg1,objs2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckTypes(L, 1, typeof(MonoBehaviour), typeof(Action)) && LuaScriptMgr.CheckParamsType(L, typeof(IEnumerator), 3, count - 2))
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetLuaObject(L, 1);
			Action arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (Action)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = () =>
				{
					func.Call();
				};
			}

			IEnumerator[] objs2 = LuaScriptMgr.GetParamsObject<IEnumerator>(L, 3, count - 2);
			Coroutine o = StaticUtils.Start_Coroutine(arg0,arg1,objs2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: StaticUtils.Start_Coroutine");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Delay(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		Action arg2 = null;
		LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

		if (funcType3 != LuaTypes.LUA_TFUNCTION)
		{
			 arg2 = (Action)LuaScriptMgr.GetNetObject(L, 3, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
			arg2 = () =>
			{
				func.Call();
			};
		}

		Coroutine o = StaticUtils.Delay(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ObtainPingFromUrl(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Ping o = StaticUtils.ObtainPingFromUrl(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsAvailable(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 1, typeof(JSONObject));
		bool o = StaticUtils.IsAvailable(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetGameManager(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		SimpleFramework.Manager.GameManager o = StaticUtils.GetGameManager();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartCoroutineLuaToC(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			IEnumerator arg0 = (IEnumerator)LuaScriptMgr.GetNetObject(L, 1, typeof(IEnumerator));
			StaticUtils.StartCoroutineLuaToC(arg0);
			return 0;
		}
		else if (count == 2)
		{
			IEnumerator arg0 = (IEnumerator)LuaScriptMgr.GetNetObject(L, 1, typeof(IEnumerator));
			DoneCoroutine arg1 = (DoneCoroutine)LuaScriptMgr.GetNetObject(L, 2, typeof(DoneCoroutine));
			StaticUtils.StartCoroutineLuaToC(arg0,arg1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: StaticUtils.StartCoroutineLuaToC");
		}

		return 0;
	}
}

