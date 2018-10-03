using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class MailInfoWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("InitWithJson", InitWithJson),
			new LuaMethod("New", _CreateMailInfo),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("mailId", get_mailId, set_mailId),
			new LuaField("sender", get_sender, set_sender),
			new LuaField("title", get_title, set_title),
			new LuaField("sendTime", get_sendTime, set_sendTime),
			new LuaField("isSystemMail", get_isSystemMail, set_isSystemMail),
			new LuaField("isRead", get_isRead, set_isRead),
		};

		LuaScriptMgr.RegisterLib(L, "MailInfo", typeof(MailInfo), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateMailInfo(IntPtr L)
	{
		LuaDLL.luaL_error(L, "MailInfo class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(MailInfo);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_mailId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name mailId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index mailId on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.mailId);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_sender(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name sender");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index sender on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.sender);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_title(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name title");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index title on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.title);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_sendTime(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name sendTime");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index sendTime on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.sendTime);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isSystemMail(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isSystemMail");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isSystemMail on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isSystemMail);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isRead(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isRead");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isRead on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isRead);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_mailId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name mailId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index mailId on a nil value");
			}
		}

		obj.mailId = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_sender(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name sender");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index sender on a nil value");
			}
		}

		obj.sender = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_title(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name title");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index title on a nil value");
			}
		}

		obj.title = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_sendTime(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name sendTime");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index sendTime on a nil value");
			}
		}

		obj.sendTime = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isSystemMail(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isSystemMail");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isSystemMail on a nil value");
			}
		}

		obj.isSystemMail = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isRead(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		MailInfo obj = (MailInfo)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isRead");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isRead on a nil value");
			}
		}

		obj.isRead = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitWithJson(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		MailInfo obj = (MailInfo)LuaScriptMgr.GetUnityObjectSelf(L, 1, "MailInfo");
		JSONObject arg0 = (JSONObject)LuaScriptMgr.GetNetObject(L, 2, typeof(JSONObject));
		obj.InitWithJson(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_Eq(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Object arg0 = LuaScriptMgr.GetLuaObject(L, 1) as Object;
		Object arg1 = LuaScriptMgr.GetLuaObject(L, 2) as Object;
		bool o = arg0 == arg1;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

