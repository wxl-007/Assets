using System;
using LuaInterface;

public class UIInput_InputTypeWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Standard", GetStandard),
		new LuaMethod("AutoCorrect", GetAutoCorrect),
		new LuaMethod("Password", GetPassword),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "UIInput.InputType", typeof(UIInput.InputType), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetStandard(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIInput.InputType.Standard);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAutoCorrect(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIInput.InputType.AutoCorrect);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetPassword(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIInput.InputType.Password);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		UIInput.InputType o = (UIInput.InputType)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

