using System;
using LuaInterface;

public class DG_Tweening_UpdateTypeWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Normal", GetNormal),
		new LuaMethod("Late", GetLate),
		new LuaMethod("Fixed", GetFixed),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "DG.Tweening.UpdateType", typeof(DG.Tweening.UpdateType), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetNormal(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.UpdateType.Normal);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLate(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.UpdateType.Late);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFixed(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.UpdateType.Fixed);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		DG.Tweening.UpdateType o = (DG.Tweening.UpdateType)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

