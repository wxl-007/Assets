using System;
using LuaInterface;

public class ConstantsWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreateConstants),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("DirName", get_DirName, null),
			new LuaField("Config_File", get_Config_File, null),
			new LuaField("InstantUpdate_VersionTime", get_InstantUpdate_VersionTime, null),
			new LuaField("InstantUpdate_VersionCode", get_InstantUpdate_VersionCode, null),
			new LuaField("ClickDownload_Config_res", get_ClickDownload_Config_res, null),
			new LuaField("ClickDownload_Config_resource", get_ClickDownload_Config_resource, null),
			new LuaField("isEditor", get_isEditor, null),
			new LuaField("UpdateDirName", get_UpdateDirName, null),
			new LuaField("UpdateVersionControl", get_UpdateVersionControl, null),
			new LuaField("DataPath", get_DataPath, null),
			new LuaField("StreamingAssetsDataPath", get_StreamingAssetsDataPath, null),
			new LuaField("DownloadPath", get_DownloadPath, null),
			new LuaField("VersionUpdatePath", get_VersionUpdatePath, null),
			new LuaField("Pack_Config_Path", get_Pack_Config_Path, null),
			new LuaField("ClickDownload_Config_download", get_ClickDownload_Config_download, null),
			new LuaField("ClickDownload_Config_data", get_ClickDownload_Config_data, null),
			new LuaField("InstantUpdateUrl", get_InstantUpdateUrl, null),
			new LuaField("_InstantUpdateUrl", get__InstantUpdateUrl, null),
			new LuaField("UpdateUrl", get_UpdateUrl, null),
			new LuaField("UpdateVersionControlUrl", get_UpdateVersionControlUrl, null),
		};

		LuaScriptMgr.RegisterLib(L, "Constants", typeof(Constants), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateConstants(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			Constants obj = new Constants();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Constants.New");
		}

		return 0;
	}

	static Type classType = typeof(Constants);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DirName(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.DirName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Config_File(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.Config_File);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_InstantUpdate_VersionTime(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.InstantUpdate_VersionTime);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_InstantUpdate_VersionCode(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.InstantUpdate_VersionCode);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ClickDownload_Config_res(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.ClickDownload_Config_res);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ClickDownload_Config_resource(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.ClickDownload_Config_resource);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isEditor(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.isEditor);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateDirName(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.UpdateDirName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateVersionControl(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.UpdateVersionControl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DataPath(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.DataPath);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_StreamingAssetsDataPath(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.StreamingAssetsDataPath);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DownloadPath(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.DownloadPath);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_VersionUpdatePath(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.VersionUpdatePath);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Pack_Config_Path(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.Pack_Config_Path);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ClickDownload_Config_download(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.ClickDownload_Config_download);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ClickDownload_Config_data(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.ClickDownload_Config_data);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_InstantUpdateUrl(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.InstantUpdateUrl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get__InstantUpdateUrl(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants._InstantUpdateUrl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateUrl(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.UpdateUrl);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateVersionControlUrl(IntPtr L)
	{
		LuaScriptMgr.Push(L, Constants.UpdateVersionControlUrl);
		return 1;
	}
}

