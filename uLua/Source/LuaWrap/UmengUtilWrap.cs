using System;
using LuaInterface;

public class UmengUtilWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("initUmeng", initUmeng),
			new LuaMethod("New", _CreateUmengUtil),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
		};

		LuaScriptMgr.RegisterLib(L, "UmengUtil", typeof(UmengUtil), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUmengUtil(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			UmengUtil obj = new UmengUtil();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UmengUtil.New");
		}

		return 0;
	}

	static Type classType = typeof(UmengUtil);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int initUmeng(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		bool arg2 = LuaScriptMgr.GetBoolean(L, 3);
		UmengUtil.initUmeng(arg0,arg1,arg2);
		return 0;
	}
}

