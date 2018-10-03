using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class IPTest_LoginWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("OnToggle_game597", OnToggle_game597),
			new LuaMethod("OnToggle_game131", OnToggle_game131),
			new LuaMethod("OnToggle_game7997", OnToggle_game7997),
			new LuaMethod("SwitchPlatform", SwitchPlatform),
			new LuaMethod("OnInput_web", OnInput_web),
			new LuaMethod("OnInput_game", OnInput_game),
			new LuaMethod("OnInput_socketLobby", OnInput_socketLobby),
			new LuaMethod("OnClick_ChangeIP", OnClick_ChangeIP),
			new LuaMethod("New", _CreateIPTest_Login),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("_WebURL_Input", get__WebURL_Input, set__WebURL_Input),
			new LuaField("_GameURL_Input", get__GameURL_Input, set__GameURL_Input),
			new LuaField("_SocketLobbyURL_Input", get__SocketLobbyURL_Input, set__SocketLobbyURL_Input),
			new LuaField("_WebURL", get__WebURL, set__WebURL),
			new LuaField("_GameURL", get__GameURL, set__GameURL),
			new LuaField("_SocketLobbyURL", get__SocketLobbyURL, set__SocketLobbyURL),
			new LuaField("_IsSocketLobby_label", get__IsSocketLobby_label, set__IsSocketLobby_label),
		};

		LuaScriptMgr.RegisterLib(L, "IPTest_Login", typeof(IPTest_Login), regs, fields, typeof(Login));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateIPTest_Login(IntPtr L)
	{
		LuaDLL.luaL_error(L, "IPTest_Login class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(IPTest_Login);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__WebURL_Input(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		IPTest_Login obj = (IPTest_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _WebURL_Input");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _WebURL_Input on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._WebURL_Input);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__GameURL_Input(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		IPTest_Login obj = (IPTest_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _GameURL_Input");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _GameURL_Input on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._GameURL_Input);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__SocketLobbyURL_Input(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		IPTest_Login obj = (IPTest_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _SocketLobbyURL_Input");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _SocketLobbyURL_Input on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._SocketLobbyURL_Input);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__WebURL(IntPtr L)
	{
		LuaScriptMgr.Push(L, IPTest_Login._WebURL);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__GameURL(IntPtr L)
	{
		LuaScriptMgr.Push(L, IPTest_Login._GameURL);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__SocketLobbyURL(IntPtr L)
	{
		LuaScriptMgr.Push(L, IPTest_Login._SocketLobbyURL);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsSocketLobby_label(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		IPTest_Login obj = (IPTest_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsSocketLobby_label");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsSocketLobby_label on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IsSocketLobby_label);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__WebURL_Input(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		IPTest_Login obj = (IPTest_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _WebURL_Input");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _WebURL_Input on a nil value");
			}
		}

		obj._WebURL_Input = (UIInput)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIInput));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__GameURL_Input(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		IPTest_Login obj = (IPTest_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _GameURL_Input");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _GameURL_Input on a nil value");
			}
		}

		obj._GameURL_Input = (UIInput)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIInput));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__SocketLobbyURL_Input(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		IPTest_Login obj = (IPTest_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _SocketLobbyURL_Input");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _SocketLobbyURL_Input on a nil value");
			}
		}

		obj._SocketLobbyURL_Input = (UIInput)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIInput));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__WebURL(IntPtr L)
	{
		IPTest_Login._WebURL = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__GameURL(IntPtr L)
	{
		IPTest_Login._GameURL = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__SocketLobbyURL(IntPtr L)
	{
		IPTest_Login._SocketLobbyURL = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsSocketLobby_label(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		IPTest_Login obj = (IPTest_Login)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsSocketLobby_label");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsSocketLobby_label on a nil value");
			}
		}

		obj._IsSocketLobby_label = (UILabel)LuaScriptMgr.GetUnityObject(L, 3, typeof(UILabel));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnToggle_game597(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		IPTest_Login obj = (IPTest_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "IPTest_Login");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.OnToggle_game597(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnToggle_game131(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		IPTest_Login obj = (IPTest_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "IPTest_Login");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.OnToggle_game131(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnToggle_game7997(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		IPTest_Login obj = (IPTest_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "IPTest_Login");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.OnToggle_game7997(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SwitchPlatform(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		IPTest_Login obj = (IPTest_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "IPTest_Login");
		PlatformEntity arg0 = (PlatformEntity)LuaScriptMgr.GetNetObject(L, 2, typeof(PlatformEntity));
		obj.SwitchPlatform(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnInput_web(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		IPTest_Login obj = (IPTest_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "IPTest_Login");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnInput_web(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnInput_game(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		IPTest_Login obj = (IPTest_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "IPTest_Login");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnInput_game(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnInput_socketLobby(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		IPTest_Login obj = (IPTest_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "IPTest_Login");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.OnInput_socketLobby(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnClick_ChangeIP(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		IPTest_Login obj = (IPTest_Login)LuaScriptMgr.GetUnityObjectSelf(L, 1, "IPTest_Login");
		obj.OnClick_ChangeIP();
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

