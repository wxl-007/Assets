using System;
using LuaInterface;

public class PlatformGameDefineWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreatePlatformGameDefine),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("playform", get_playform, set_playform),
			new LuaField("CLIENT_VERSION", get_CLIENT_VERSION, set_CLIENT_VERSION),
			new LuaField("game", get_game, set_game),
		};

		LuaScriptMgr.RegisterLib(L, "PlatformGameDefine", typeof(PlatformGameDefine), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreatePlatformGameDefine(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			PlatformGameDefine obj = new PlatformGameDefine();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: PlatformGameDefine.New");
		}

		return 0;
	}

	static Type classType = typeof(PlatformGameDefine);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_playform(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, PlatformGameDefine.playform);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CLIENT_VERSION(IntPtr L)
	{
		LuaScriptMgr.Push(L, PlatformGameDefine.CLIENT_VERSION);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_game(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, PlatformGameDefine.game);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_playform(IntPtr L)
	{
		PlatformGameDefine.playform = (PlatformEntity)LuaScriptMgr.GetNetObject(L, 3, typeof(PlatformEntity));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_CLIENT_VERSION(IntPtr L)
	{
		PlatformGameDefine.CLIENT_VERSION = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_game(IntPtr L)
	{
		PlatformGameDefine.game = (GameEntity)LuaScriptMgr.GetNetObject(L, 3, typeof(GameEntity));
		return 0;
	}
}

