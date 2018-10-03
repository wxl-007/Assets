using System;
using LuaInterface;

public class DG_Tweening_LoopTypeWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Restart", GetRestart),
		new LuaMethod("Yoyo", GetYoyo),
		new LuaMethod("Incremental", GetIncremental),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "DG.Tweening.LoopType", typeof(DG.Tweening.LoopType), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetRestart(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.LoopType.Restart);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetYoyo(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.LoopType.Yoyo);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetIncremental(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.LoopType.Incremental);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		DG.Tweening.LoopType o = (DG.Tweening.LoopType)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

