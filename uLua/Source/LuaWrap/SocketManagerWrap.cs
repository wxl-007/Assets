using System;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class SocketManagerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("UpdateConfigStr", UpdateConfigStr),
			new LuaMethod("Connect", Connect),
			new LuaMethod("Disconnect", Disconnect),
			new LuaMethod("SendPackageWithJson", SendPackageWithJson),
			new LuaMethod("SendPackage", SendPackage),
			new LuaMethod("SendUpdate", SendUpdate),
			new LuaMethod("AddSendPackage", AddSendPackage),
			new LuaMethod("RemoveSendList", RemoveSendList),
			new LuaMethod("StartSendPackage", StartSendPackage),
			new LuaMethod("SocketMessageRollback", SocketMessageRollback),
			new LuaMethod("New", _CreateSocketManager),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("UNITY_HOST_EXCEPTION", get_UNITY_HOST_EXCEPTION, null),
			new LuaField("_IsListSendSocket", get__IsListSendSocket, set__IsListSendSocket),
			new LuaField("m_SameSendTimeInterval", get_m_SameSendTimeInterval, set_m_SameSendTimeInterval),
			new LuaField("m_SendList", get_m_SendList, set_m_SendList),
			new LuaField("m_SendTimeInterval", get_m_SendTimeInterval, set_m_SendTimeInterval),
			new LuaField("m_SendTimeRecord", get_m_SendTimeRecord, set_m_SendTimeRecord),
			new LuaField("_socketListener", get__socketListener, set__socketListener),
			new LuaField("Instance", get_Instance, null),
			new LuaField("LobbyInstance", get_LobbyInstance, null),
			new LuaField("socketListener", get_socketListener, set_socketListener),
			new LuaField("CurSocketIp", get_CurSocketIp, null),
			new LuaField("CurSocketConnectCount", get_CurSocketConnectCount, null),
		};

		LuaScriptMgr.RegisterLib(L, "SocketManager", typeof(SocketManager), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSocketManager(IntPtr L)
	{
		LuaDLL.luaL_error(L, "SocketManager class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(SocketManager);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UNITY_HOST_EXCEPTION(IntPtr L)
	{
		LuaScriptMgr.Push(L, SocketManager.UNITY_HOST_EXCEPTION);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__IsListSendSocket(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsListSendSocket");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsListSendSocket on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj._IsListSendSocket);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_SameSendTimeInterval(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_SameSendTimeInterval");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_SameSendTimeInterval on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.m_SameSendTimeInterval);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_SendList(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_SendList");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_SendList on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.m_SendList);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_SendTimeInterval(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_SendTimeInterval");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_SendTimeInterval on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.m_SendTimeInterval);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_SendTimeRecord(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_SendTimeRecord");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_SendTimeRecord on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.m_SendTimeRecord);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__socketListener(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _socketListener");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _socketListener on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj._socketListener);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Instance(IntPtr L)
	{
		LuaScriptMgr.Push(L, SocketManager.Instance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_LobbyInstance(IntPtr L)
	{
		LuaScriptMgr.Push(L, SocketManager.LobbyInstance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_socketListener(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name socketListener");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index socketListener on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.socketListener);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CurSocketIp(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name CurSocketIp");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index CurSocketIp on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.CurSocketIp);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CurSocketConnectCount(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name CurSocketConnectCount");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index CurSocketConnectCount on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.CurSocketConnectCount);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__IsListSendSocket(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _IsListSendSocket");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _IsListSendSocket on a nil value");
			}
		}

		obj._IsListSendSocket = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_SameSendTimeInterval(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_SameSendTimeInterval");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_SameSendTimeInterval on a nil value");
			}
		}

		obj.m_SameSendTimeInterval = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_SendList(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_SendList");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_SendList on a nil value");
			}
		}

		obj.m_SendList = (List<SocketManager.SocketSend>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<SocketManager.SocketSend>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_SendTimeInterval(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_SendTimeInterval");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_SendTimeInterval on a nil value");
			}
		}

		obj.m_SendTimeInterval = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_SendTimeRecord(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name m_SendTimeRecord");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index m_SendTimeRecord on a nil value");
			}
		}

		obj.m_SendTimeRecord = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__socketListener(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name _socketListener");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index _socketListener on a nil value");
			}
		}

		obj._socketListener = (SocketListener)LuaScriptMgr.GetNetObject(L, 3, typeof(SocketListener));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_socketListener(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketManager obj = (SocketManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name socketListener");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index socketListener on a nil value");
			}
		}

		obj.socketListener = (SocketListener)LuaScriptMgr.GetNetObject(L, 3, typeof(SocketListener));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateConfigStr(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		SocketManager.UpdateConfigStr(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Connect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
		SocketConnectInfo arg0 = (SocketConnectInfo)LuaScriptMgr.GetNetObject(L, 2, typeof(SocketConnectInfo));
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
		obj.Connect(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Disconnect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.Disconnect(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendPackageWithJson(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		obj.SendPackageWithJson(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendPackage(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			obj.SendPackage(arg0);
			return 0;
		}
		else if (count == 3)
		{
			SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 3);
			obj.SendPackage(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 3);
			float arg2 = (float)LuaScriptMgr.GetNumber(L, 4);
			obj.SendPackage(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SocketManager.SendPackage");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendUpdate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
		obj.SendUpdate();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddSendPackage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 3);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 4);
		obj.AddSendPackage(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveSendList(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
		obj.RemoveSendList();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartSendPackage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.StartSendPackage(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SocketMessageRollback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SocketManager obj = (SocketManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SocketManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.SocketMessageRollback(arg0);
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

