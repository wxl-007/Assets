using System;
using LuaInterface;

public class SocketConnectInfoWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Init", Init),
			new LuaMethod("ValidInfo", ValidInfo),
			new LuaMethod("New", _CreateSocketConnectInfo),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("userId", get_userId, set_userId),
			new LuaField("userPassword", get_userPassword, set_userPassword),
			new LuaField("roomId", get_roomId, set_roomId),
			new LuaField("roomHost", get_roomHost, set_roomHost),
			new LuaField("roomPort", get_roomPort, set_roomPort),
			new LuaField("roomDBName", get_roomDBName, set_roomDBName),
			new LuaField("roomFixseat", get_roomFixseat, set_roomFixseat),
			new LuaField("roomTitle", get_roomTitle, set_roomTitle),
			new LuaField("roomMinMoney", get_roomMinMoney, set_roomMinMoney),
			new LuaField("entry_fee", get_entry_fee, set_entry_fee),
			new LuaField("roomType", get_roomType, set_roomType),
			new LuaField("lobbyUserName", get_lobbyUserName, set_lobbyUserName),
			new LuaField("lobbyPassword", get_lobbyPassword, set_lobbyPassword),
			new LuaField("Instance", get_Instance, null),
		};

		LuaScriptMgr.RegisterLib(L, "SocketConnectInfo", typeof(SocketConnectInfo), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSocketConnectInfo(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			SocketConnectInfo obj = new SocketConnectInfo();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SocketConnectInfo.New");
		}

		return 0;
	}

	static Type classType = typeof(SocketConnectInfo);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_userId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name userId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index userId on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.userId);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_userPassword(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name userPassword");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index userPassword on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.userPassword);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomId on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomId);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomHost(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomHost");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomHost on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomHost);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomPort(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomPort");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomPort on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomPort);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomDBName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomDBName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomDBName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomDBName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomFixseat(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomFixseat");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomFixseat on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomFixseat);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomTitle(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomTitle");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomTitle on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomTitle);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomMinMoney(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomMinMoney");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomMinMoney on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomMinMoney);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_entry_fee(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name entry_fee");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index entry_fee on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.entry_fee);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomType(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomType");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomType on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_lobbyUserName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name lobbyUserName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index lobbyUserName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.lobbyUserName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_lobbyPassword(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name lobbyPassword");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index lobbyPassword on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.lobbyPassword);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Instance(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, SocketConnectInfo.Instance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_userId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name userId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index userId on a nil value");
			}
		}

		obj.userId = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_userPassword(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name userPassword");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index userPassword on a nil value");
			}
		}

		obj.userPassword = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomId on a nil value");
			}
		}

		obj.roomId = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomHost(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomHost");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomHost on a nil value");
			}
		}

		obj.roomHost = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomPort(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomPort");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomPort on a nil value");
			}
		}

		obj.roomPort = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomDBName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomDBName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomDBName on a nil value");
			}
		}

		obj.roomDBName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomFixseat(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomFixseat");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomFixseat on a nil value");
			}
		}

		obj.roomFixseat = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomTitle(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomTitle");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomTitle on a nil value");
			}
		}

		obj.roomTitle = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomMinMoney(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomMinMoney");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomMinMoney on a nil value");
			}
		}

		obj.roomMinMoney = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_entry_fee(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name entry_fee");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index entry_fee on a nil value");
			}
		}

		obj.entry_fee = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomType(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomType");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomType on a nil value");
			}
		}

		obj.roomType = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_lobbyUserName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name lobbyUserName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index lobbyUserName on a nil value");
			}
		}

		obj.lobbyUserName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_lobbyPassword(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name lobbyPassword");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index lobbyPassword on a nil value");
			}
		}

		obj.lobbyPassword = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		SocketConnectInfo obj = (SocketConnectInfo)LuaScriptMgr.GetNetObjectSelf(L, 1, "SocketConnectInfo");
		EginUser arg0 = (EginUser)LuaScriptMgr.GetNetObject(L, 2, typeof(EginUser));
		GameRoom arg1 = (GameRoom)LuaScriptMgr.GetNetObject(L, 3, typeof(GameRoom));
		obj.Init(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ValidInfo(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SocketConnectInfo obj = (SocketConnectInfo)LuaScriptMgr.GetNetObjectSelf(L, 1, "SocketConnectInfo");
		bool o = obj.ValidInfo();
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

