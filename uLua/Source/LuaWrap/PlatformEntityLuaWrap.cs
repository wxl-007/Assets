using System;
using System.Collections;
using LuaInterface;

public class PlatformEntityLuaWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("LuaCoroutine", LuaCoroutine),
			new LuaMethod("LuaFunctionToAction", LuaFunctionToAction),
			new LuaMethod("testCall", testCall),
			new LuaMethod("testCoroutine", testCoroutine),
			new LuaMethod("testOnComplete", testOnComplete),
			new LuaMethod("IsTester", IsTester),
			new LuaMethod("ConfigURL", ConfigURL),
			new LuaMethod("GameNoticeURL", GameNoticeURL),
			new LuaMethod("LoadURL", LoadURL),
			new LuaMethod("LoadLocalConfig", LoadLocalConfig),
			new LuaMethod("LoadConfig", LoadConfig),
			new LuaMethod("swithGameHostUrl", swithGameHostUrl),
			new LuaMethod("swithWebHostUrl", swithWebHostUrl),
			new LuaMethod("swithSocketLobbyHostUrl", swithSocketLobbyHostUrl),
			new LuaMethod("LoadConfByUser", LoadConfByUser),
			new LuaMethod("Start_LoadAndSaveConfigData", Start_LoadAndSaveConfigData),
			new LuaMethod("LoadAndSaveConfigData", LoadAndSaveConfigData),
			new LuaMethod("LoadConfig_game_hostArr", LoadConfig_game_hostArr),
			new LuaMethod("LoadConf_game_hostArr", LoadConf_game_hostArr),
			new LuaMethod("LoadGameIPs", LoadGameIPs),
			new LuaMethod("UpdateGFnameURL", UpdateGFnameURL),
			new LuaMethod("LoadConfig_web_hostArr", LoadConfig_web_hostArr),
			new LuaMethod("LoadConf_web_hostArr", LoadConf_web_hostArr),
			new LuaMethod("LoadWebIPs", LoadWebIPs),
			new LuaMethod("UpdateWFnameURL", UpdateWFnameURL),
			new LuaMethod("GetPlatformPrefix", GetPlatformPrefix),
			new LuaMethod("New", _CreatePlatformEntityLua),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("LuaSelf", get_LuaSelf, set_LuaSelf),
			new LuaField("testName", get_testName, set_testName),
			new LuaField("PlatformName", get_PlatformName, null),
			new LuaField("HostURL", get_HostURL, null),
			new LuaField("DownloadURL", get_DownloadURL, null),
			new LuaField("RechargeURL", get_RechargeURL, null),
			new LuaField("FeedbackContent", get_FeedbackContent, null),
			new LuaField("UnityMoney", get_UnityMoney, null),
			new LuaField("IOSPayFlag", get_IOSPayFlag, null),
			new LuaField("IsPool", get_IsPool, null),
			new LuaField("IsYan", get_IsYan, null),
			new LuaField("VersionCode", get_VersionCode, null),
			new LuaField("Register_url", get_Register_url, null),
			new LuaField("gameUrl", get_gameUrl, null),
			new LuaField("webUrl", get_webUrl, null),
			new LuaField("SocketLobbyUrl", get_SocketLobbyUrl, null),
			new LuaField("IsSocketLobby", get_IsSocketLobby, null),
			new LuaField("AliAppId", get_AliAppId, null),
			new LuaField("WXAppId", get_WXAppId, null),
			new LuaField("WxAppSecret", get_WxAppSecret, null),
			new LuaField("WXPayAppId", get_WXPayAppId, null),
			new LuaField("WXPayAppSecret", get_WXPayAppSecret, null),
			new LuaField("WXShareUrl", get_WXShareUrl, null),
			new LuaField("WXShareDescription", get_WXShareDescription, null),
			new LuaField("HallHomeInfos", get_HallHomeInfos, null),
			new LuaField("IsInstantUpdate", get_IsInstantUpdate, null),
			new LuaField("InstantUpdateUrl", get_InstantUpdateUrl, null),
			new LuaField("IsCache_UserIp", get_IsCache_UserIp, null),
			new LuaField("IsCache_config", get_IsCache_config, null),
			new LuaField("SocketManager_config_str", get_SocketManager_config_str, null),
		};

		LuaScriptMgr.RegisterLib(L, "PlatformEntityLua", typeof(PlatformEntityLua), regs, fields, typeof(PlatformEntity));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreatePlatformEntityLua(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			PlatformEntityLua obj = new PlatformEntityLua();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: PlatformEntityLua.New");
		}

		return 0;
	}

	static Type classType = typeof(PlatformEntityLua);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_LuaSelf(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name LuaSelf");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index LuaSelf on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.LuaSelf);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_testName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name testName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index testName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.testName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_PlatformName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name PlatformName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index PlatformName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.PlatformName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_HostURL(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name HostURL");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index HostURL on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.HostURL);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DownloadURL(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name DownloadURL");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index DownloadURL on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.DownloadURL);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_RechargeURL(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name RechargeURL");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index RechargeURL on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.RechargeURL);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_FeedbackContent(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name FeedbackContent");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index FeedbackContent on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.FeedbackContent);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UnityMoney(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name UnityMoney");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index UnityMoney on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.UnityMoney);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IOSPayFlag(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IOSPayFlag");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IOSPayFlag on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IOSPayFlag);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsPool(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsPool");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsPool on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsPool);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsYan(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsYan");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsYan on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsYan);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_VersionCode(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name VersionCode");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index VersionCode on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.VersionCode);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Register_url(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Register_url");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Register_url on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.Register_url);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_gameUrl(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name gameUrl");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index gameUrl on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.gameUrl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_webUrl(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name webUrl");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index webUrl on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.webUrl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_SocketLobbyUrl(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name SocketLobbyUrl");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index SocketLobbyUrl on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.SocketLobbyUrl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsSocketLobby(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsSocketLobby");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsSocketLobby on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsSocketLobby);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_AliAppId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name AliAppId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index AliAppId on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.AliAppId);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_WXAppId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name WXAppId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index WXAppId on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.WXAppId);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_WxAppSecret(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name WxAppSecret");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index WxAppSecret on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.WxAppSecret);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_WXPayAppId(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name WXPayAppId");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index WXPayAppId on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.WXPayAppId);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_WXPayAppSecret(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name WXPayAppSecret");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index WXPayAppSecret on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.WXPayAppSecret);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_WXShareUrl(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name WXShareUrl");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index WXShareUrl on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.WXShareUrl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_WXShareDescription(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name WXShareDescription");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index WXShareDescription on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.WXShareDescription);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_HallHomeInfos(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name HallHomeInfos");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index HallHomeInfos on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.HallHomeInfos);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsInstantUpdate(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsInstantUpdate");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsInstantUpdate on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsInstantUpdate);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_InstantUpdateUrl(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name InstantUpdateUrl");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index InstantUpdateUrl on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.InstantUpdateUrl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsCache_UserIp(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsCache_UserIp");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsCache_UserIp on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsCache_UserIp);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsCache_config(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsCache_config");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsCache_config on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsCache_config);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_SocketManager_config_str(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name SocketManager_config_str");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index SocketManager_config_str on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.SocketManager_config_str);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_LuaSelf(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name LuaSelf");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index LuaSelf on a nil value");
			}
		}

		obj.LuaSelf = LuaScriptMgr.GetLuaTable(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_testName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name testName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index testName on a nil value");
			}
		}

		obj.testName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LuaCoroutine(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		object[] objs1 = LuaScriptMgr.GetParamsObject(L, 3, count - 2);
		IEnumerator o = obj.LuaCoroutine(arg0,objs1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LuaFunctionToAction(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		LuaInterface.LuaFunction o = obj.LuaFunctionToAction(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int testCall(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string o = obj.testCall(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int testCoroutine(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		IEnumerator o = obj.testCoroutine();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int testOnComplete(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		obj.testOnComplete(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsTester(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		bool o = obj.IsTester();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ConfigURL(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string o = obj.ConfigURL();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GameNoticeURL(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string o = obj.GameNoticeURL();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadURL(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		obj.LoadURL(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadLocalConfig(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		IEnumerator o = obj.LoadLocalConfig();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadConfig(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		IEnumerator o = obj.LoadConfig();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int swithGameHostUrl(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		obj.swithGameHostUrl(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int swithWebHostUrl(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		Action arg1 = null;
		LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

		if (funcType3 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (Action)LuaScriptMgr.GetNetObject(L, 3, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
			arg1 = () =>
			{
				func.Call();
			};
		}

		obj.swithWebHostUrl(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int swithSocketLobbyHostUrl(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		obj.swithSocketLobbyHostUrl(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadConfByUser(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		IEnumerator o = obj.LoadConfByUser(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Start_LoadAndSaveConfigData(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		obj.Start_LoadAndSaveConfigData(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAndSaveConfigData(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		float arg1 = (float)LuaScriptMgr.GetNumber(L, 3);
		IEnumerator o = obj.LoadAndSaveConfigData(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadConfig_game_hostArr(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
		IEnumerator o = obj.LoadConfig_game_hostArr(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadConf_game_hostArr(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		IEnumerator o = obj.LoadConf_game_hostArr(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadGameIPs(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
			bool o = obj.LoadGameIPs(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4)
		{
			PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
			bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
			bool o = obj.LoadGameIPs(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: PlatformEntityLua.LoadGameIPs");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateGFnameURL(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string o = obj.UpdateGFnameURL(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadConfig_web_hostArr(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
		IEnumerator o = obj.LoadConfig_web_hostArr(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadConf_web_hostArr(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		IEnumerator o = obj.LoadConf_web_hostArr(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadWebIPs(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
			bool o = obj.LoadWebIPs(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4)
		{
			PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
			bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
			bool o = obj.LoadWebIPs(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: PlatformEntityLua.LoadWebIPs");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateWFnameURL(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string o = obj.UpdateWFnameURL(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetPlatformPrefix(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		PlatformEntityLua obj = (PlatformEntityLua)LuaScriptMgr.GetNetObjectSelf(L, 1, "PlatformEntityLua");
		string o = obj.GetPlatformPrefix();
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

