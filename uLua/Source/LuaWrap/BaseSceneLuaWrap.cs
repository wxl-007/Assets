using System;
using System.Collections;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class BaseSceneLuaWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Awake", Awake),
			new LuaMethod("EginLoadLevel", EginLoadLevel),
			new LuaMethod("OnWechatSendWebCallback", OnWechatSendWebCallback),
			new LuaMethod("StartSocket", StartSocket),
			new LuaMethod("EndSocket", EndSocket),
			new LuaMethod("SocketSendMessage", SocketSendMessage),
			new LuaMethod("SocketReceiveMessage", SocketReceiveMessage),
			new LuaMethod("SocketDisconnect", SocketDisconnect),
			new LuaMethod("OnSocketDisconnect", OnSocketDisconnect),
			new LuaMethod("OnSocketManagerDisconnect", OnSocketManagerDisconnect),
			new LuaMethod("OnSocketManagerTimeOut", OnSocketManagerTimeOut),
			new LuaMethod("OnTimeOut", OnTimeOut),
			new LuaMethod("Process_account_login_Failed", Process_account_login_Failed),
			new LuaMethod("Process_account_login", Process_account_login),
			new LuaMethod("Receive_lua_fun", Receive_lua_fun),
			new LuaMethod("Request_lua_fun", Request_lua_fun),
			new LuaMethod("StartCoroutineLuaToC", StartCoroutineLuaToC),
			new LuaMethod("WeChatLogin", WeChatLogin),
			new LuaMethod("OnWechatSendAuthCallback", OnWechatSendAuthCallback),
			new LuaMethod("WWWReconnectCall", WWWReconnectCall),
			new LuaMethod("WWWReconnect", WWWReconnect),
			new LuaMethod("CheckTimeOut", CheckTimeOut),
			new LuaMethod("ResetScreenResize", ResetScreenResize),
			new LuaMethod("DoRechargeSucess", DoRechargeSucess),
			new LuaMethod("DoRechargeCancel", DoRechargeCancel),
			new LuaMethod("DoReceiveNotice", DoReceiveNotice),
			new LuaMethod("New", _CreateBaseSceneLua),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("_IsOverride_SocketReceiveMessage", get__IsOverride_SocketReceiveMessage, set__IsOverride_SocketReceiveMessage),
			new LuaField("_IsOverride_OnSocketDisconnect", get__IsOverride_OnSocketDisconnect, set__IsOverride_OnSocketDisconnect),
			new LuaField("_IsOverride_Process_account_login", get__IsOverride_Process_account_login, set__IsOverride_Process_account_login),
			new LuaField("_IsOverride_Process_account_login_Failed", get__IsOverride_Process_account_login_Failed, set__IsOverride_Process_account_login_Failed),
			new LuaField("_IsOverride_OnSocketManagerTimeOut", get__IsOverride_OnSocketManagerTimeOut, set__IsOverride_OnSocketManagerTimeOut),
			new LuaField("_IsLoginScene", get__IsLoginScene, set__IsLoginScene),
			new LuaField("socketManager", get_socketManager, null),
		};

		LuaScriptMgr.RegisterLib(L, "BaseSceneLua", typeof(BaseSceneLua), regs, fields, typeof(SimpleFramework.LuaBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateBaseSceneLua(IntPtr L)
	{
		LuaDLL.luaL_error(L, "BaseSceneLua class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(BaseSceneLua);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsOverride_SocketReceiveMessage(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_SocketReceiveMessage");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_SocketReceiveMessage on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IsOverride_SocketReceiveMessage);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsOverride_OnSocketDisconnect(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_OnSocketDisconnect");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_OnSocketDisconnect on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IsOverride_OnSocketDisconnect);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsOverride_Process_account_login(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_Process_account_login");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_Process_account_login on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IsOverride_Process_account_login);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsOverride_Process_account_login_Failed(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_Process_account_login_Failed");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_Process_account_login_Failed on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IsOverride_Process_account_login_Failed);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsOverride_OnSocketManagerTimeOut(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_OnSocketManagerTimeOut");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_OnSocketManagerTimeOut on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IsOverride_OnSocketManagerTimeOut);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsLoginScene(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsLoginScene");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsLoginScene on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IsLoginScene);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_socketManager(IntPtr L)
	{
		LuaScriptMgr.Push(L, BaseSceneLua.socketManager);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsOverride_SocketReceiveMessage(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_SocketReceiveMessage");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_SocketReceiveMessage on a nil value");
			}
		}

		obj._IsOverride_SocketReceiveMessage = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsOverride_OnSocketDisconnect(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_OnSocketDisconnect");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_OnSocketDisconnect on a nil value");
			}
		}

		obj._IsOverride_OnSocketDisconnect = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsOverride_Process_account_login(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_Process_account_login");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_Process_account_login on a nil value");
			}
		}

		obj._IsOverride_Process_account_login = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsOverride_Process_account_login_Failed(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_Process_account_login_Failed");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_Process_account_login_Failed on a nil value");
			}
		}

		obj._IsOverride_Process_account_login_Failed = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsOverride_OnSocketManagerTimeOut(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsOverride_OnSocketManagerTimeOut");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsOverride_OnSocketManagerTimeOut on a nil value");
			}
		}

		obj._IsOverride_OnSocketManagerTimeOut = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsLoginScene(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BaseSceneLua obj = (BaseSceneLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsLoginScene");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsLoginScene on a nil value");
			}
		}

		obj._IsLoginScene = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Awake(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		obj.Awake();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EginLoadLevel(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.EginLoadLevel(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnWechatSendWebCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnWechatSendWebCallback(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartSocket(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.StartSocket(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EndSocket(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.EndSocket(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketSendMessage(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 1, typeof(JSONObject));
			BaseSceneLua.SocketSendMessage(arg0);
			return 0;
		}
		else if (count == 2)
		{
			BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			obj.SocketSendMessage(arg0);
			return 0;
		}
		else if (count == 3)
		{
			BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 3);
			obj.SocketSendMessage(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 3);
			float arg2 = (float)LuaScriptMgr.GetNumber(L, 4);
			obj.SocketSendMessage(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: BaseSceneLua.SocketSendMessage");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketReceiveMessage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SocketReceiveMessage(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketDisconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SocketDisconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnSocketDisconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnSocketDisconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnSocketManagerDisconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnSocketManagerDisconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnSocketManagerTimeOut(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnSocketManagerTimeOut(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnTimeOut(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		obj.OnTimeOut();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Process_account_login_Failed(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		obj.Process_account_login_Failed(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Process_account_login(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.Process_account_login(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Receive_lua_fun(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		LuaFunction arg1 = LuaScriptMgr.GetLuaFunction(L, 3);
		LuaFunction arg2 = LuaScriptMgr.GetLuaFunction(L, 4);
		obj.Receive_lua_fun(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Request_lua_fun(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 5);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		LuaFunction arg2 = LuaScriptMgr.GetLuaFunction(L, 4);
		LuaFunction arg3 = LuaScriptMgr.GetLuaFunction(L, 5);
		obj.Request_lua_fun(arg0,arg1,arg2,arg3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartCoroutineLuaToC(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
			IEnumerator arg0 = (IEnumerator)LuaScriptMgr.GetNetObject(L, 2, typeof(IEnumerator));
			obj.StartCoroutineLuaToC(arg0);
			return 0;
		}
		else if (count == 3)
		{
			BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
			IEnumerator arg0 = (IEnumerator)LuaScriptMgr.GetNetObject(L, 2, typeof(IEnumerator));
			DoneCoroutine arg1 = (DoneCoroutine)LuaScriptMgr.GetNetObject(L, 3, typeof(DoneCoroutine));
			obj.StartCoroutineLuaToC(arg0,arg1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: BaseSceneLua.StartCoroutineLuaToC");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WeChatLogin(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.WeChatLogin(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnWechatSendAuthCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnWechatSendAuthCallback(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WWWReconnectCall(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		WaitCoroutine arg2 = (WaitCoroutine)LuaScriptMgr.GetNetObject(L, 4, typeof(WaitCoroutine));
		obj.WWWReconnectCall(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WWWReconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		WaitCoroutine arg2 = (WaitCoroutine)LuaScriptMgr.GetNetObject(L, 4, typeof(WaitCoroutine));
		IEnumerator o = obj.WWWReconnect(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckTimeOut(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		WWW arg0 = (WWW)LuaScriptMgr.GetNetObject(L, 2, typeof(WWW));
		Action arg1 = null;
		LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

		if (funcType3 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (Action)LuaScriptMgr.GetNetObject(L, 3, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
			arg1 = () =>
			{
				func.Call();
			};
		}

		float arg2 = (float)LuaScriptMgr.GetNumber(L, 4);
		IEnumerator o = obj.CheckTimeOut(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ResetScreenResize(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		obj.ResetScreenResize();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoRechargeSucess(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		obj.DoRechargeSucess();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoRechargeCancel(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		obj.DoRechargeCancel();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoReceiveNotice(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		BaseSceneLua obj = (BaseSceneLua)LuaScriptMgr.GetUnityObjectSelf(L, 1, "BaseSceneLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.DoReceiveNotice(arg0);
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

