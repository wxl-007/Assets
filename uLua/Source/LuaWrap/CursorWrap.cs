using System;
using UnityEngine;
using LuaInterface;

public class CursorWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("SetCursor", SetCursor),
			new LuaMethod("New", _CreateCursor),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("visible", get_visible, set_visible),
			new LuaField("lockState", get_lockState, set_lockState),
		};

		LuaScriptMgr.RegisterLib(L, "UnityEngine.Cursor", typeof(Cursor), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateCursor(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			Cursor obj = new Cursor();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Cursor.New");
		}

		return 0;
	}

	static Type classType = typeof(Cursor);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_visible(IntPtr L)
	{
		LuaScriptMgr.Push(L, Cursor.visible);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_lockState(IntPtr L)
	{
		LuaScriptMgr.Push(L, Cursor.lockState);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_visible(IntPtr L)
	{
		Cursor.visible = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_lockState(IntPtr L)
	{
		Cursor.lockState = (CursorLockMode)LuaScriptMgr.GetNetObject(L, 3, typeof(CursorLockMode));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetCursor(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Texture2D arg0 = (Texture2D)LuaScriptMgr.GetUnityObject(L, 1, typeof(Texture2D));
		Vector2 arg1 = LuaScriptMgr.GetVector2(L, 2);
		CursorMode arg2 = (CursorMode)LuaScriptMgr.GetNetObject(L, 3, typeof(CursorMode));
		Cursor.SetCursor(arg0,arg1,arg2);
		return 0;
	}
}

