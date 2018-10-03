using System;
using LuaInterface;

public class GameEntityWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("ChekcVersionURL", ChekcVersionURL),
			new LuaMethod("StartGame", StartGame),
			new LuaMethod("ShowGameGuide", ShowGameGuide),
			new LuaMethod("GameEntityForID", GameEntityForID),
			new LuaMethod("New", _CreateGameEntity),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("VersionCode", get_VersionCode, set_VersionCode),
			new LuaField("VersionName", get_VersionName, set_VersionName),
			new LuaField("GameID", get_GameID, set_GameID),
			new LuaField("GameTypeIDs", get_GameTypeIDs, set_GameTypeIDs),
			new LuaField("GameScene", get_GameScene, set_GameScene),
			new LuaField("GameIconType", get_GameIconType, set_GameIconType),
			new LuaField("GameDeskType", get_GameDeskType, set_GameDeskType),
			new LuaField("GameGuideScene", get_GameGuideScene, set_GameGuideScene),
			new LuaField("GameGuideContent", get_GameGuideContent, set_GameGuideContent),
			new LuaField("IsGameGuideAdditive", get_IsGameGuideAdditive, set_IsGameGuideAdditive),
			new LuaField("GameName", get_GameName, set_GameName),
			new LuaField("BundleId", get_BundleId, null),
		};

		LuaScriptMgr.RegisterLib(L, "GameEntity", typeof(GameEntity), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateGameEntity(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			GameEntity obj = new GameEntity();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: GameEntity.New");
		}

		return 0;
	}

	static Type classType = typeof(GameEntity);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_VersionCode(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name VersionCode");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index VersionCode on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.VersionCode);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_VersionName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name VersionName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index VersionName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.VersionName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameID(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameID");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameID on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GameID);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameTypeIDs(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameTypeIDs");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameTypeIDs on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GameTypeIDs);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameScene(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameScene");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameScene on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GameScene);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameIconType(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameIconType");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameIconType on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GameIconType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameDeskType(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameDeskType");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameDeskType on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GameDeskType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameGuideScene(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameGuideScene");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameGuideScene on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GameGuideScene);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameGuideContent(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameGuideContent");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameGuideContent on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GameGuideContent);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsGameGuideAdditive(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsGameGuideAdditive");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsGameGuideAdditive on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsGameGuideAdditive);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GameName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GameName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_BundleId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name BundleId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index BundleId on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.BundleId);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_VersionCode(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name VersionCode");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index VersionCode on a nil value");
			}
		}

		obj.VersionCode = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_VersionName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name VersionName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index VersionName on a nil value");
			}
		}

		obj.VersionName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameID(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameID");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameID on a nil value");
			}
		}

		obj.GameID = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameTypeIDs(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameTypeIDs");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameTypeIDs on a nil value");
			}
		}

		obj.GameTypeIDs = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameScene(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameScene");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameScene on a nil value");
			}
		}

		obj.GameScene = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameIconType(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameIconType");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameIconType on a nil value");
			}
		}

		obj.GameIconType = (GameType)LuaScriptMgr.GetNetObject(L, 3, typeof(GameType));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameDeskType(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameDeskType");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameDeskType on a nil value");
			}
		}

		obj.GameDeskType = (DeskType)LuaScriptMgr.GetNetObject(L, 3, typeof(DeskType));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameGuideScene(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameGuideScene");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameGuideScene on a nil value");
			}
		}

		obj.GameGuideScene = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameGuideContent(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameGuideContent");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameGuideContent on a nil value");
			}
		}

		obj.GameGuideContent = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_IsGameGuideAdditive(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsGameGuideAdditive");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsGameGuideAdditive on a nil value");
			}
		}

		obj.IsGameGuideAdditive = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GameName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		GameEntity obj = (GameEntity)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GameName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GameName on a nil value");
			}
		}

		obj.GameName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ChekcVersionURL(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameEntity obj = (GameEntity)LuaScriptMgr.GetNetObjectSelf(L, 1, "GameEntity");
		string o = obj.ChekcVersionURL();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartGame(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameEntity obj = (GameEntity)LuaScriptMgr.GetNetObjectSelf(L, 1, "GameEntity");
		obj.StartGame();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShowGameGuide(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameEntity obj = (GameEntity)LuaScriptMgr.GetNetObjectSelf(L, 1, "GameEntity");
		obj.ShowGameGuide();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GameEntityForID(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		GameEntity o = GameEntity.GameEntityForID(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}
}

