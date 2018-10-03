using System;
using LuaInterface;

public class PhoneSdkUtilWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("SendAndroidNotice", SendAndroidNotice),
			new LuaMethod("CancelAndroidNotice", CancelAndroidNotice),
			new LuaMethod("readedIosNoticeNumber", readedIosNoticeNumber),
			new LuaMethod("SendIosNotice", SendIosNotice),
			new LuaMethod("initBaiduYuntui", initBaiduYuntui),
			new LuaMethod("initLxYuntui", initLxYuntui),
			new LuaMethod("addFriendFromSms", addFriendFromSms),
			new LuaMethod("getImei", getImei),
			new LuaMethod("callPhone", callPhone),
			new LuaMethod("IsIOSApp", IsIOSApp),
			new LuaMethod("OpenIosAppURL", OpenIosAppURL),
			new LuaMethod("androidToActivity", androidToActivity),
			new LuaMethod("New", _CreatePhoneSdkUtil),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
		};

		LuaScriptMgr.RegisterLib(L, "PhoneSdkUtil", typeof(PhoneSdkUtil), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreatePhoneSdkUtil(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			PhoneSdkUtil obj = new PhoneSdkUtil();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: PhoneSdkUtil.New");
		}

		return 0;
	}

	static Type classType = typeof(PhoneSdkUtil);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendAndroidNotice(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		string arg2 = LuaScriptMgr.GetLuaString(L, 3);
		string arg3 = LuaScriptMgr.GetLuaString(L, 4);
		PhoneSdkUtil.SendAndroidNotice(arg0,arg1,arg2,arg3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CancelAndroidNotice(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		PhoneSdkUtil.CancelAndroidNotice(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int readedIosNoticeNumber(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		PhoneSdkUtil.readedIosNoticeNumber(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendIosNotice(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
		PhoneSdkUtil.SendIosNotice(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int initBaiduYuntui(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
		PhoneSdkUtil.initBaiduYuntui(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int initLxYuntui(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		PhoneSdkUtil.initLxYuntui(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int addFriendFromSms(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		PhoneSdkUtil.addFriendFromSms(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getImei(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		string o = PhoneSdkUtil.getImei();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int callPhone(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		PhoneSdkUtil.callPhone(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsIOSApp(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		bool o = PhoneSdkUtil.IsIOSApp(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OpenIosAppURL(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		PhoneSdkUtil.OpenIosAppURL(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int androidToActivity(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		string o = PhoneSdkUtil.androidToActivity(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

