using System;
using LuaInterface;

public class DG_Tweening_AutoPlayWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("None", GetNone),
		new LuaMethod("AutoPlaySequences", GetAutoPlaySequences),
		new LuaMethod("AutoPlayTweeners", GetAutoPlayTweeners),
		new LuaMethod("All", GetAll),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "DG.Tweening.AutoPlay", typeof(DG.Tweening.AutoPlay), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetNone(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.AutoPlay.None);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAutoPlaySequences(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.AutoPlay.AutoPlaySequences);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAutoPlayTweeners(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.AutoPlay.AutoPlayTweeners);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAll(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.AutoPlay.All);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		DG.Tweening.AutoPlay o = (DG.Tweening.AutoPlay)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

