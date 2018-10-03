using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class UtilsWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("IsVersionUsable", IsVersionUsable),
			new LuaMethod("Request", Request),
			new LuaMethod("LoadLevelGUI", LoadLevelGUI),
			new LuaMethod("LoadLevelAdditiveGUI", LoadLevelAdditiveGUI),
			new LuaMethod("LoadLevelGameGUI", LoadLevelGameGUI),
			new LuaMethod("LoadLevelAdditiveGameGUI", LoadLevelAdditiveGameGUI),
			new LuaMethod("LoadAdditiveGameUIwithFunc", LoadAdditiveGameUIwithFunc),
			new LuaMethod("LoadAdditiveGameUI", LoadAdditiveGameUI),
			new LuaMethod("CheckGameModulesUpdate", CheckGameModulesUpdate),
			new LuaMethod("UpdateGameModules", UpdateGameModules),
			new LuaMethod("GetHallGameModuleName", GetHallGameModuleName),
			new LuaMethod("SetInstantUpdateCallbackNull", SetInstantUpdateCallbackNull),
			new LuaMethod("DownloadCloudAssets", DownloadCloudAssets),
			new LuaMethod("StartInstantDownload", StartInstantDownload),
			new LuaMethod("IsDownloadCloudAssetComplete", IsDownloadCloudAssetComplete),
			new LuaMethod("SetVersionUpdateCallbackNull", SetVersionUpdateCallbackNull),
			new LuaMethod("StartVersionUpdate", StartVersionUpdate),
			new LuaMethod("InitPackConfig", InitPackConfig),
			new LuaMethod("LoadText", LoadText),
			new LuaMethod("SetConfig_urls", SetConfig_urls),
			new LuaMethod("CheckHallGameModuleDownloadProgress", CheckHallGameModuleDownloadProgress),
			new LuaMethod("initSocket", initSocket),
			new LuaMethod("ConnectGameSocket", ConnectGameSocket),
			new LuaMethod("ClearListener", ClearListener),
			new LuaMethod("Disconnect", Disconnect),
			new LuaMethod("ConnectSocket", ConnectSocket),
			new LuaMethod("loadScene", loadScene),
			new LuaMethod("CallDelegate", CallDelegate),
			new LuaMethod("encrypTime", encrypTime),
			new LuaMethod("Log", Log),
			new LuaMethod("aesDecryptToUrlList", aesDecryptToUrlList),
			new LuaMethod("aesDecrypt", aesDecrypt),
			new LuaMethod("CallAction", CallAction),
			new LuaMethod("ActionToLua", ActionToLua),
			new LuaMethod("JSONObjectToString", JSONObjectToString),
			new LuaMethod("ArryListToLuaTable", ArryListToLuaTable),
			new LuaMethod("ArryLength", ArryLength),
			new LuaMethod("SetArry", SetArry),
			new LuaMethod("GetArry", GetArry),
			new LuaMethod("Zhuanhuan", Zhuanhuan),
			new LuaMethod("New", _CreateUtils),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("HallName", get_HallName, set_HallName),
			new LuaField("_hallResourcesName", get__hallResourcesName, set__hallResourcesName),
			new LuaField("PlayformName", get_PlayformName, set_PlayformName),
			new LuaField("_IsFish", get__IsFish, set__IsFish),
			new LuaField("_IsIPTest", get__IsIPTest, set__IsIPTest),
			new LuaField("_IsIPTest2", get__IsIPTest2, set__IsIPTest2),
			new LuaField("_IsTestAgreement", get__IsTestAgreement, set__IsTestAgreement),
			new LuaField("isLocalServer", get_isLocalServer, set_isLocalServer),
			new LuaField("_IsNoInstantUpdate", get__IsNoInstantUpdate, set__IsNoInstantUpdate),
			new LuaField("_IsNoWeChat", get__IsNoWeChat, set__IsNoWeChat),
			new LuaField("_SingleGame", get__SingleGame, set__SingleGame),
			new LuaField("_IsSingleGame", get__IsSingleGame, set__IsSingleGame),
			new LuaField("NullObj", get_NullObj, set_NullObj),
			new LuaField("InstantUpdateCallback", get_InstantUpdateCallback, set_InstantUpdateCallback),
			new LuaField("VersionUpdateCallback", get_VersionUpdateCallback, set_VersionUpdateCallback),
			new LuaField("bundleId", get_bundleId, null),
			new LuaField("version", get_version, null),
			new LuaField("VersionCode", get_VersionCode, null),
			new LuaField("GameName", get_GameName, null),
			new LuaField("Agent_Id", get_Agent_Id, null),
			new LuaField("BUILDPLATFORM", get_BUILDPLATFORM, null),
			new LuaField("Lua_UNITY_EDITOR", get_Lua_UNITY_EDITOR, null),
		};

		LuaScriptMgr.RegisterLib(L, "Utils", typeof(Utils), regs, fields, null);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUtils(IntPtr L)
	{
		LuaDLL.luaL_error(L, "Utils class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(Utils);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_HallName(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.HallName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__hallResourcesName(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._hallResourcesName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_PlayformName(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.PlayformName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsFish(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._IsFish);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsIPTest(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._IsIPTest);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsIPTest2(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._IsIPTest2);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsTestAgreement(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._IsTestAgreement);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isLocalServer(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.isLocalServer);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsNoInstantUpdate(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._IsNoInstantUpdate);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsNoWeChat(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._IsNoWeChat);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__SingleGame(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._SingleGame);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsSingleGame(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils._IsSingleGame);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_NullObj(IntPtr L)
	{
		LuaScriptMgr.PushVarObject(L, Utils.NullObj);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_InstantUpdateCallback(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.InstantUpdateCallback);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_VersionUpdateCallback(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.VersionUpdateCallback);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_bundleId(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.bundleId);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_version(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.version);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_VersionCode(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.VersionCode);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameName(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.GameName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Agent_Id(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.Agent_Id);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_BUILDPLATFORM(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.BUILDPLATFORM);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Lua_UNITY_EDITOR(IntPtr L)
	{
		LuaScriptMgr.Push(L, Utils.Lua_UNITY_EDITOR);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_HallName(IntPtr L)
	{
		Utils.HallName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__hallResourcesName(IntPtr L)
	{
		Utils._hallResourcesName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_PlayformName(IntPtr L)
	{
		Utils.PlayformName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsFish(IntPtr L)
	{
		Utils._IsFish = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsIPTest(IntPtr L)
	{
		Utils._IsIPTest = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsIPTest2(IntPtr L)
	{
		Utils._IsIPTest2 = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsTestAgreement(IntPtr L)
	{
		Utils._IsTestAgreement = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isLocalServer(IntPtr L)
	{
		Utils.isLocalServer = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsNoInstantUpdate(IntPtr L)
	{
		Utils._IsNoInstantUpdate = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsNoWeChat(IntPtr L)
	{
		Utils._IsNoWeChat = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__SingleGame(IntPtr L)
	{
		Utils._SingleGame = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsSingleGame(IntPtr L)
	{
		Utils._IsSingleGame = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_NullObj(IntPtr L)
	{
		Utils.NullObj = LuaScriptMgr.GetVarObject(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_InstantUpdateCallback(IntPtr L)
	{
		Utils.InstantUpdateCallback = LuaScriptMgr.GetLuaTable(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_VersionUpdateCallback(IntPtr L)
	{
		Utils.VersionUpdateCallback = LuaScriptMgr.GetLuaTable(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsVersionUsable(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		bool o = Utils.IsVersionUsable(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Request(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 5)
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
			string arg1 = LuaScriptMgr.GetLuaString(L, 2);
			WWWForm arg2 = (WWWForm)LuaScriptMgr.GetNetObject(L, 3, typeof(WWWForm));
			Action<string> arg3 = null;
			LuaTypes funcType4 = LuaDLL.lua_type(L, 4);

			if (funcType4 != LuaTypes.LUA_TFUNCTION)
			{
				 arg3 = (Action<string>)LuaScriptMgr.GetNetObject(L, 4, typeof(Action<string>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 4);
				arg3 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Action<string> arg4 = null;
			LuaTypes funcType5 = LuaDLL.lua_type(L, 5);

			if (funcType5 != LuaTypes.LUA_TFUNCTION)
			{
				 arg4 = (Action<string>)LuaScriptMgr.GetNetObject(L, 5, typeof(Action<string>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 5);
				arg4 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Utils.Request(arg0,arg1,arg2,arg3,arg4);
			return 0;
		}
		else if (count == 7)
		{
			MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
			string arg1 = LuaScriptMgr.GetLuaString(L, 2);
			WWWForm arg2 = (WWWForm)LuaScriptMgr.GetNetObject(L, 3, typeof(WWWForm));
			Action<string> arg3 = null;
			LuaTypes funcType4 = LuaDLL.lua_type(L, 4);

			if (funcType4 != LuaTypes.LUA_TFUNCTION)
			{
				 arg3 = (Action<string>)LuaScriptMgr.GetNetObject(L, 4, typeof(Action<string>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 4);
				arg3 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Action<string> arg4 = null;
			LuaTypes funcType5 = LuaDLL.lua_type(L, 5);

			if (funcType5 != LuaTypes.LUA_TFUNCTION)
			{
				 arg4 = (Action<string>)LuaScriptMgr.GetNetObject(L, 5, typeof(Action<string>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 5);
				arg4 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			bool arg5 = LuaScriptMgr.GetBoolean(L, 6);
			bool arg6 = LuaScriptMgr.GetBoolean(L, 7);
			Utils.Request(arg0,arg1,arg2,arg3,arg4,arg5,arg6);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Utils.Request");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadLevelGUI(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			Utils.LoadLevelGUI(arg0);
			return 0;
		}
		else if (count == 3)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 3);
			Utils.LoadLevelGUI(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Utils.LoadLevelGUI");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadLevelAdditiveGUI(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Utils.LoadLevelAdditiveGUI(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadLevelGameGUI(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Utils.LoadLevelGameGUI(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadLevelAdditiveGameGUI(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Utils.LoadLevelAdditiveGameGUI(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAdditiveGameUIwithFunc(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		LuaFunction arg2 = LuaScriptMgr.GetLuaFunction(L, 3);
		Utils.LoadAdditiveGameUIwithFunc(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAdditiveGameUI(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		Utils.LoadAdditiveGameUI(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckGameModulesUpdate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 5);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		ArrayList arg1 = (ArrayList)LuaScriptMgr.GetNetObject(L, 2, typeof(ArrayList));
		string arg2 = LuaScriptMgr.GetLuaString(L, 3);
		LuaFunction arg3 = LuaScriptMgr.GetLuaFunction(L, 4);
		LuaFunction arg4 = LuaScriptMgr.GetLuaFunction(L, 5);
		Utils.CheckGameModulesUpdate(arg0,arg1,arg2,arg3,arg4);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateGameModules(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 5);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		List<string> arg1 = (List<string>)LuaScriptMgr.GetNetObject(L, 2, typeof(List<string>));
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

		bool arg3 = LuaScriptMgr.GetBoolean(L, 4);
		string arg4 = LuaScriptMgr.GetLuaString(L, 5);
		Utils.UpdateGameModules(arg0,arg1,arg2,arg3,arg4);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetHallGameModuleName(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = Utils.GetHallGameModuleName(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetInstantUpdateCallbackNull(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		Utils.SetInstantUpdateCallbackNull();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DownloadCloudAssets(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		Action<string,bool> arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (Action<string,bool>)LuaScriptMgr.GetNetObject(L, 2, typeof(Action<string,bool>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}

		Utils.DownloadCloudAssets(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartInstantDownload(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		Utils.StartInstantDownload();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsDownloadCloudAssetComplete(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		bool o = Utils.IsDownloadCloudAssetComplete();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetVersionUpdateCallbackNull(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		Utils.SetVersionUpdateCallbackNull();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartVersionUpdate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		Utils.StartVersionUpdate(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitPackConfig(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		MonoBehaviour arg0 = (MonoBehaviour)LuaScriptMgr.GetUnityObject(L, 1, typeof(MonoBehaviour));
		Utils.InitPackConfig(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadText(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Action<JSONObject,string> arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (Action<JSONObject,string>)LuaScriptMgr.GetNetObject(L, 2, typeof(Action<JSONObject,string>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.PushObject(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}

		IEnumerator o = Utils.LoadText(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetConfig_urls(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Utils.SetConfig_urls(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckHallGameModuleDownloadProgress(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaTable arg0 = LuaScriptMgr.GetLuaTable(L, 1);
		Utils.CheckHallGameModuleDownloadProgress(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int initSocket(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		Utils.initSocket();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ConnectGameSocket(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		Utils.ConnectGameSocket();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearListener(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		Utils.ClearListener();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Disconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Utils.Disconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ConnectSocket(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SocketConnectInfo arg0 = (SocketConnectInfo)LuaScriptMgr.GetNetObject(L, 1, typeof(SocketConnectInfo));
		Utils.ConnectSocket(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int loadScene(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Utils.loadScene(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CallDelegate(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			Delegate arg0 = (Delegate)LuaScriptMgr.GetNetObject(L, 1, typeof(Delegate));
			Utils.CallDelegate(arg0);
			return 0;
		}
		else if (count == 2)
		{
			Delegate arg0 = (Delegate)LuaScriptMgr.GetNetObject(L, 1, typeof(Delegate));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			Utils.CallDelegate(arg0,arg1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Utils.CallDelegate");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int encrypTime(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = Utils.encrypTime(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Log(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		Utils.Log(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int aesDecryptToUrlList(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		ArrayList o = Utils.aesDecryptToUrlList(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int aesDecrypt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = Utils.aesDecrypt(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CallAction(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Action arg0 = null;
		LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

		if (funcType1 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 1, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
			arg0 = () =>
			{
				func.Call();
			};
		}

		Utils.CallAction(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ActionToLua(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		LuaTable arg1 = LuaScriptMgr.GetLuaTable(L, 2);
		Action o = Utils.ActionToLua(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int JSONObjectToString(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		string o = Utils.JSONObjectToString(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ArryListToLuaTable(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		ArrayList arg0 = (ArrayList)LuaScriptMgr.GetNetObject(L, 1, typeof(ArrayList));
		LuaTable arg1 = LuaScriptMgr.GetLuaTable(L, 2);
		Utils.ArryListToLuaTable(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ArryLength(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string[] objs0 = LuaScriptMgr.GetArrayString(L, 1);
		int o = Utils.ArryLength(objs0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetArry(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		string[] objs0 = LuaScriptMgr.GetArrayString(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		string arg2 = LuaScriptMgr.GetLuaString(L, 3);
		Utils.SetArry(objs0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetArry(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string[] objs0 = LuaScriptMgr.GetArrayString(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		string o = Utils.GetArry(objs0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Zhuanhuan(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaTable arg0 = LuaScriptMgr.GetLuaTable(L, 1);
		Vector3[] o = Utils.Zhuanhuan(arg0);
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}
}

