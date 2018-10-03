using System;
using LuaInterface;

public class UIWidget_AspectRatioSourceWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Free", GetFree),
		new LuaMethod("BasedOnWidth", GetBasedOnWidth),
		new LuaMethod("BasedOnHeight", GetBasedOnHeight),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "UIWidget.AspectRatioSource", typeof(UIWidget.AspectRatioSource), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFree(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIWidget.AspectRatioSource.Free);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetBasedOnWidth(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIWidget.AspectRatioSource.BasedOnWidth);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetBasedOnHeight(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIWidget.AspectRatioSource.BasedOnHeight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		UIWidget.AspectRatioSource o = (UIWidget.AspectRatioSource)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

