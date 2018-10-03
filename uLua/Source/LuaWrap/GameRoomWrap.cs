using System;
using System.Collections.Generic;
using LuaInterface;

public class GameRoomWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreateGameRoom),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("roomId", get_roomId, set_roomId),
			new LuaField("host", get_host, set_host),
			new LuaField("port", get_port, set_port),
			new LuaField("dbname", get_dbname, set_dbname),
			new LuaField("fixseat", get_fixseat, set_fixseat),
			new LuaField("tagTitle", get_tagTitle, set_tagTitle),
			new LuaField("title", get_title, set_title),
			new LuaField("minMoney", get_minMoney, set_minMoney),
			new LuaField("maxMoney", get_maxMoney, set_maxMoney),
			new LuaField("onlineNum", get_onlineNum, set_onlineNum),
			new LuaField("maxOnline", get_maxOnline, set_maxOnline),
			new LuaField("entry_fee", get_entry_fee, set_entry_fee),
			new LuaField("roomType", get_roomType, set_roomType),
			new LuaField("roomname", get_roomname, set_roomname),
		};

		LuaScriptMgr.RegisterLib(L, "GameRoom", typeof(GameRoom), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateGameRoom(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			Dictionary<string,string> arg0 = (Dictionary<string,string>)LuaScriptMgr.GetNetObject(L, 1, typeof(Dictionary<string,string>));
			GameRoom obj = new GameRoom(arg0);
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: GameRoom.New");
		}

		return 0;
	}

	static Type classType = typeof(GameRoom);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_roomId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

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
	static int get_host(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name host");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index host on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.host);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_port(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name port");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index port on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.port);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_dbname(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name dbname");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index dbname on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.dbname);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fixseat(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fixseat");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fixseat on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.fixseat);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_tagTitle(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name tagTitle");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index tagTitle on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.tagTitle);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_title(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name title");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index title on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.title);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_minMoney(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name minMoney");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index minMoney on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.minMoney);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_maxMoney(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name maxMoney");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index maxMoney on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.maxMoney);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onlineNum(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name onlineNum");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index onlineNum on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.onlineNum);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_maxOnline(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name maxOnline");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index maxOnline on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.maxOnline);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_entry_fee(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

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
		GameRoom obj = (GameRoom)o;

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
	static int get_roomname(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomname");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomname on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.roomname);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_roomId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

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
	static int set_host(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name host");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index host on a nil value");
			}
		}

		obj.host = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_port(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name port");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index port on a nil value");
			}
		}

		obj.port = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_dbname(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name dbname");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index dbname on a nil value");
			}
		}

		obj.dbname = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fixseat(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fixseat");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fixseat on a nil value");
			}
		}

		obj.fixseat = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_tagTitle(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name tagTitle");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index tagTitle on a nil value");
			}
		}

		obj.tagTitle = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_title(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name title");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index title on a nil value");
			}
		}

		obj.title = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_minMoney(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name minMoney");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index minMoney on a nil value");
			}
		}

		obj.minMoney = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_maxMoney(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name maxMoney");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index maxMoney on a nil value");
			}
		}

		obj.maxMoney = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onlineNum(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name onlineNum");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index onlineNum on a nil value");
			}
		}

		obj.onlineNum = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_maxOnline(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name maxOnline");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index maxOnline on a nil value");
			}
		}

		obj.maxOnline = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_entry_fee(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

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
		GameRoom obj = (GameRoom)o;

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
	static int set_roomname(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameRoom obj = (GameRoom)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name roomname");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index roomname on a nil value");
			}
		}

		obj.roomname = LuaScriptMgr.GetString(L, 3);
		return 0;
	}
}

