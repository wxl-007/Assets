using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class GameWrap
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
			new LuaMethod("OnSocketDisconnect", OnSocketDisconnect),
			new LuaMethod("OnSocketManagerDisconnect", OnSocketManagerDisconnect),
			new LuaMethod("OnSocketManagerTimeOut", OnSocketManagerTimeOut),
			new LuaMethod("ProcessAccountFailed", ProcessAccountFailed),
			new LuaMethod("ProcessAccountSucess", ProcessAccountSucess),
			new LuaMethod("ProcessUpdateIntomoney", ProcessUpdateIntomoney),
			new LuaMethod("ShowPromptHUD", ShowPromptHUD),
			new LuaMethod("New", _CreateGame),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("socketManager", get_socketManager, null),
		};

		LuaScriptMgr.RegisterLib(L, "Game", typeof(Game), regs, fields, typeof(SimpleFramework.LuaBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateGame(IntPtr L)
	{
		LuaDLL.luaL_error(L, "Game class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(Game);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_socketManager(IntPtr L)
	{
		LuaScriptMgr.Push(L, Game.socketManager);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartGameSocket(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		obj.StartGameSocket();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnClickBack(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		obj.OnClickBack();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendPackage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SendPackage(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendPackageWithJson(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		obj.SendPackageWithJson(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketReady(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		obj.SocketReady();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketReceiveMessage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SocketReceiveMessage(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketDisconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SocketDisconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnSocketDisconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnSocketDisconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnSocketManagerDisconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnSocketManagerDisconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnSocketManagerTimeOut(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnSocketManagerTimeOut(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessAccountFailed(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.ProcessAccountFailed(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessAccountSucess(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		obj.ProcessAccountSucess(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessUpdateIntomoney(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		obj.ProcessUpdateIntomoney(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShowPromptHUD(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Game obj = (Game)LuaScriptMgr.GetUnityObjectSelf(L, 1, "Game");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.ShowPromptHUD(arg0);
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

