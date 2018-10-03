using System;
using LuaInterface;

public class UIAnchor_SideWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("BottomLeft", GetBottomLeft),
		new LuaMethod("Left", GetLeft),
		new LuaMethod("TopLeft", GetTopLeft),
		new LuaMethod("Top", GetTop),
		new LuaMethod("TopRight", GetTopRight),
		new LuaMethod("Right", GetRight),
		new LuaMethod("BottomRight", GetBottomRight),
		new LuaMethod("Bottom", GetBottom),
		new LuaMethod("Center", GetCenter),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "UIAnchor.Side", typeof(UIAnchor.Side), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetBottomLeft(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.BottomLeft);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLeft(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.Left);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTopLeft(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.TopLeft);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTop(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.Top);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTopRight(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.TopRight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetRight(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.Right);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetBottomRight(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.BottomRight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetBottom(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.Bottom);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetCenter(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIAnchor.Side.Center);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		UIAnchor.Side o = (UIAnchor.Side)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

