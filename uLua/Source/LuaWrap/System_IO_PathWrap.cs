using System;
using LuaInterface;

public class System_IO_PathWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("ChangeExtension", ChangeExtension),
			new LuaMethod("Combine", Combine),
			new LuaMethod("GetDirectoryName", GetDirectoryName),
			new LuaMethod("GetExtension", GetExtension),
			new LuaMethod("GetFileName", GetFileName),
			new LuaMethod("GetFileNameWithoutExtension", GetFileNameWithoutExtension),
			new LuaMethod("GetFullPath", GetFullPath),
			new LuaMethod("GetPathRoot", GetPathRoot),
			new LuaMethod("GetTempFileName", GetTempFileName),
			new LuaMethod("GetTempPath", GetTempPath),
			new LuaMethod("HasExtension", HasExtension),
			new LuaMethod("IsPathRooted", IsPathRooted),
			new LuaMethod("GetInvalidFileNameChars", GetInvalidFileNameChars),
			new LuaMethod("GetInvalidPathChars", GetInvalidPathChars),
			new LuaMethod("GetRandomFileName", GetRandomFileName),
			new LuaMethod("New", _CreateSystem_IO_Path),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("AltDirectorySeparatorChar", get_AltDirectorySeparatorChar, null),
			new LuaField("DirectorySeparatorChar", get_DirectorySeparatorChar, null),
			new LuaField("PathSeparator", get_PathSeparator, null),
			new LuaField("VolumeSeparatorChar", get_VolumeSeparatorChar, null),
		};

		LuaScriptMgr.RegisterLib(L, "System.IO.Path", typeof(System.IO.Path), regs, fields, null);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSystem_IO_Path(IntPtr L)
	{
		LuaDLL.luaL_error(L, "System.IO.Path class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(System.IO.Path);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_AltDirectorySeparatorChar(IntPtr L)
	{
		LuaScriptMgr.Push(L, System.IO.Path.AltDirectorySeparatorChar);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DirectorySeparatorChar(IntPtr L)
	{
		LuaScriptMgr.Push(L, System.IO.Path.DirectorySeparatorChar);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_PathSeparator(IntPtr L)
	{
		LuaScriptMgr.Push(L, System.IO.Path.PathSeparator);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_VolumeSeparatorChar(IntPtr L)
	{
		LuaScriptMgr.Push(L, System.IO.Path.VolumeSeparatorChar);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ChangeExtension(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		string o = System.IO.Path.ChangeExtension(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Combine(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		string o = System.IO.Path.Combine(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDirectoryName(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = System.IO.Path.GetDirectoryName(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetExtension(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = System.IO.Path.GetExtension(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFileName(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = System.IO.Path.GetFileName(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFileNameWithoutExtension(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = System.IO.Path.GetFileNameWithoutExtension(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFullPath(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = System.IO.Path.GetFullPath(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetPathRoot(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = System.IO.Path.GetPathRoot(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTempFileName(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		string o = System.IO.Path.GetTempFileName();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTempPath(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		string o = System.IO.Path.GetTempPath();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int HasExtension(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		bool o = System.IO.Path.HasExtension(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsPathRooted(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		bool o = System.IO.Path.IsPathRooted(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInvalidFileNameChars(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		char[] o = System.IO.Path.GetInvalidFileNameChars();
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInvalidPathChars(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		char[] o = System.IO.Path.GetInvalidPathChars();
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetRandomFileName(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		string o = System.IO.Path.GetRandomFileName();
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

