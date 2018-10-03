using System;
using LuaInterface;

public class UIRoot_ScalingWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Flexible", GetFlexible),
		new LuaMethod("Constrained", GetConstrained),
		new LuaMethod("ConstrainedOnMobiles", GetConstrainedOnMobiles),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "UIRoot.Scaling", typeof(UIRoot.Scaling), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFlexible(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIRoot.Scaling.Flexible);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetConstrained(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIRoot.Scaling.Constrained);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetConstrainedOnMobiles(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIRoot.Scaling.ConstrainedOnMobiles);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		UIRoot.Scaling o = (UIRoot.Scaling)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

