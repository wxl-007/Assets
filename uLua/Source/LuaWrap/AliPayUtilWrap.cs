using System;
using LuaInterface;

public class AliPayUtilWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("OnAliPay", OnAliPay),
			new LuaMethod("New", _CreateAliPayUtil),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("out_trade_noAli", get_out_trade_noAli, set_out_trade_noAli),
		};

		LuaScriptMgr.RegisterLib(L, "AliPayUtil", typeof(AliPayUtil), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateAliPayUtil(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			AliPayUtil obj = new AliPayUtil();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: AliPayUtil.New");
		}

		return 0;
	}

	static Type classType = typeof(AliPayUtil);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_out_trade_noAli(IntPtr L)
	{
		LuaScriptMgr.Push(L, AliPayUtil.out_trade_noAli);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_out_trade_noAli(IntPtr L)
	{
		AliPayUtil.out_trade_noAli = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnAliPay(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		AliPayUtil.OnAliPay(arg0);
		return 0;
	}
}

