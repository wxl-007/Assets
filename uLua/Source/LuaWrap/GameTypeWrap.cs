using System;
using LuaInterface;

public class GameTypeWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Poker", GetPoker),
		new LuaMethod("Mahjong", GetMahjong),
		new LuaMethod("dice", Getdice),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "GameType", typeof(GameType), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetPoker(IntPtr L)
	{
		LuaScriptMgr.Push(L, GameType.Poker);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetMahjong(IntPtr L)
	{
		LuaScriptMgr.Push(L, GameType.Mahjong);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Getdice(IntPtr L)
	{
		LuaScriptMgr.Push(L, GameType.dice);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		GameType o = (GameType)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

