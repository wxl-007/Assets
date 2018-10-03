using System;
using LuaInterface;

public class DeskTypeWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("DeskType_2", GetDeskType_2),
		new LuaMethod("DeskType_3", GetDeskType_3),
		new LuaMethod("DeskType_4", GetDeskType_4),
		new LuaMethod("DeskType_5", GetDeskType_5),
		new LuaMethod("DeskType_6", GetDeskType_6),
		new LuaMethod("DeskType_7", GetDeskType_7),
		new LuaMethod("DeskType_16", GetDeskType_16),
		new LuaMethod("DeskType_All", GetDeskType_All),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "DeskType", typeof(DeskType), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeskType_2(IntPtr L)
	{
		LuaScriptMgr.Push(L, DeskType.DeskType_2);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeskType_3(IntPtr L)
	{
		LuaScriptMgr.Push(L, DeskType.DeskType_3);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeskType_4(IntPtr L)
	{
		LuaScriptMgr.Push(L, DeskType.DeskType_4);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeskType_5(IntPtr L)
	{
		LuaScriptMgr.Push(L, DeskType.DeskType_5);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeskType_6(IntPtr L)
	{
		LuaScriptMgr.Push(L, DeskType.DeskType_6);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeskType_7(IntPtr L)
	{
		LuaScriptMgr.Push(L, DeskType.DeskType_7);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeskType_16(IntPtr L)
	{
		LuaScriptMgr.Push(L, DeskType.DeskType_16);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeskType_All(IntPtr L)
	{
		LuaScriptMgr.Push(L, DeskType.DeskType_All);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		DeskType o = (DeskType)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

