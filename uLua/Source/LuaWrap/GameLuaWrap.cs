using System;
using System.Collections;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class GameLuaWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("StartGameSocket", StartGameSocket),
			new LuaMethod("OnClickBack", OnClickBack),
			new LuaMethod("SendPackage", SendPackage),
			new LuaMethod("SendPackageWithJson", SendPackageWithJson),
			new LuaMethod("SocketReady", SocketReady),
			new LuaMethod("SocketReceiveMessage", SocketReceiveMessage),
			new LuaMethod("SocketDisconnect", SocketDisconnect),
			new LuaMethod("ProcessAccountFailed", ProcessAccountFailed),
			new LuaMethod("ProcessAccountSucess", ProcessAccountSucess),
			new LuaMethod("ProcessUpdateIntomoney", ProcessUpdateIntomoney),
			new LuaMethod("ShowPromptHUD", ShowPromptHUD),
			new LuaMethod("DoFile", DoFile),
			new LuaMethod("GetLuaObj", GetLuaObj),
			new LuaMethod("setLuaObj", setLuaObj),
			new LuaMethod("iTweenHashLua", iTweenHashLua),
			new LuaMethod("iTweenMessage", iTweenMessage),
			new LuaMethod("New", _CreateGameLua),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
		};

		LuaScriptMgr.RegisterLib(L, "GameLua", typeof(GameLua), regs, fields, typeof(Game));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateGameLua(IntPtr L)
	{
		LuaDLL.luaL_error(L, "GameLua class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(GameLua);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartGameSocket(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		obj.StartGameSocket();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnClickBack(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		obj.OnClickBack();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendPackage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SendPackage(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendPackageWithJson(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		obj.SendPackageWithJson(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketReady(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		obj.SocketReady();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketReceiveMessage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SocketReceiveMessage(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketDisconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SocketDisconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessAccountFailed(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.ProcessAccountFailed(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessAccountSucess(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		obj.ProcessAccountSucess(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessUpdateIntomoney(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		obj.ProcessUpdateIntomoney(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShowPromptHUD(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.ShowPromptHUD(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoFile(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		object[] o = obj.DoFile(arg0);
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLuaObj(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		object o = obj.GetLuaObj(arg0);
		LuaScriptMgr.PushVarObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setLuaObj(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		object arg1 = LuaScriptMgr.GetVarObject(L, 3);
		obj.setLuaObj(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int iTweenHashLua(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		object[] objs0 = LuaScriptMgr.GetParamsObject(L, 2, count - 1);
		Hashtable o = obj.iTweenHashLua(objs0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int iTweenMessage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameLua obj = (GameLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "GameLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.iTweenMessage(arg0);
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

