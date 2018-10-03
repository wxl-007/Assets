using System;
using LuaInterface;

public class WXPayUtilWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("OnWeChatPay", OnWeChatPay),
			new LuaMethod("OnWeChatSendAuth", OnWeChatSendAuth),
			new LuaMethod("OnWeChatSendWeb", OnWeChatSendWeb),
			new LuaMethod("OnClick_WebActivity", OnClick_WebActivity),
			new LuaMethod("StartIOSStartRecharge", StartIOSStartRecharge),
			new LuaMethod("OpenAndroidApp", OpenAndroidApp),
			new LuaMethod("OpenIOSApp", OpenIOSApp),
			new LuaMethod("New", _CreateWXPayUtil),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("out_trade_no", get_out_trade_no, set_out_trade_no),
		};

		LuaScriptMgr.RegisterLib(L, "WXPayUtil", typeof(WXPayUtil), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateWXPayUtil(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			WXPayUtil obj = new WXPayUtil();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: WXPayUtil.New");
		}

		return 0;
	}

	static Type classType = typeof(WXPayUtil);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_out_trade_no(IntPtr L)
	{
		LuaScriptMgr.Push(L, WXPayUtil.out_trade_no);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_out_trade_no(IntPtr L)
	{
		WXPayUtil.out_trade_no = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnWeChatPay(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 1, typeof(JSONObject));
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		WXPayUtil.OnWeChatPay(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnWeChatSendAuth(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		WXPayUtil.OnWeChatSendAuth(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnWeChatSendWeb(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			WXPayUtil.OnWeChatSendWeb(arg0);
			return 0;
		}
		else if (count == 3)
		{
			bool arg0 = LuaScriptMgr.GetBoolean(L, 1);
			string arg1 = LuaScriptMgr.GetLuaString(L, 2);
			JSONObject arg2 = (JSONObject)LuaScriptMgr.GetNetObject(L, 3, typeof(JSONObject));
			WXPayUtil.OnWeChatSendWeb(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: WXPayUtil.OnWeChatSendWeb");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnClick_WebActivity(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		WXPayUtil.OnClick_WebActivity(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartIOSStartRecharge(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		WXPayUtil.StartIOSStartRecharge(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OpenAndroidApp(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		WXPayUtil.OpenAndroidApp(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OpenIOSApp(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		WXPayUtil.OpenIOSApp(arg0,arg1);
		return 0;
	}
}

