using System;
using LuaInterface;

public class System_Text_RegularExpressions_RegexWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("CompileToAssembly", CompileToAssembly),
			new LuaMethod("Escape", Escape),
			new LuaMethod("Unescape", Unescape),
			new LuaMethod("IsMatch", IsMatch),
			new LuaMethod("Match", Match),
			new LuaMethod("Matches", Matches),
			new LuaMethod("Replace", Replace),
			new LuaMethod("Split", Split),
			new LuaMethod("GetGroupNames", GetGroupNames),
			new LuaMethod("GetGroupNumbers", GetGroupNumbers),
			new LuaMethod("GroupNameFromNumber", GroupNameFromNumber),
			new LuaMethod("GroupNumberFromName", GroupNumberFromName),
			new LuaMethod("ToString", ToString),
			new LuaMethod("New", _CreateSystem_Text_RegularExpressions_Regex),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__tostring", Lua_ToString),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("CacheSize", get_CacheSize, set_CacheSize),
			new LuaField("Options", get_Options, null),
			new LuaField("RightToLeft", get_RightToLeft, null),
		};

		LuaScriptMgr.RegisterLib(L, "System.Text.RegularExpressions.Regex", typeof(System.Text.RegularExpressions.Regex), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSystem_Text_RegularExpressions_Regex(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			System.Text.RegularExpressions.Regex obj = new System.Text.RegularExpressions.Regex(arg0);
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else if (count == 2)
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			System.Text.RegularExpressions.RegexOptions arg1 = (System.Text.RegularExpressions.RegexOptions)LuaScriptMgr.GetNetObject(L, 2, typeof(System.Text.RegularExpressions.RegexOptions));
			System.Text.RegularExpressions.Regex obj = new System.Text.RegularExpressions.Regex(arg0,arg1);
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: System.Text.RegularExpressions.Regex.New");
		}

		return 0;
	}

	static Type classType = typeof(System.Text.RegularExpressions.Regex);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CacheSize(IntPtr L)
	{
		LuaScriptMgr.Push(L, System.Text.RegularExpressions.Regex.CacheSize);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Options(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Options");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Options on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.Options);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_RightToLeft(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name RightToLeft");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index RightToLeft on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.RightToLeft);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_CacheSize(IntPtr L)
	{
		System.Text.RegularExpressions.Regex.CacheSize = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_ToString(IntPtr L)
	{
		object obj = LuaScriptMgr.GetLuaObject(L, 1);

		if (obj != null)
		{
			LuaScriptMgr.Push(L, obj.ToString());
		}
		else
		{
			LuaScriptMgr.Push(L, "Table: System.Text.RegularExpressions.Regex");
		}

		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CompileToAssembly(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			System.Text.RegularExpressions.RegexCompilationInfo[] objs0 = LuaScriptMgr.GetArrayObject<System.Text.RegularExpressions.RegexCompilationInfo>(L, 1);
			System.Reflection.AssemblyName arg1 = (System.Reflection.AssemblyName)LuaScriptMgr.GetNetObject(L, 2, typeof(System.Reflection.AssemblyName));
			System.Text.RegularExpressions.Regex.CompileToAssembly(objs0,arg1);
			return 0;
		}
		else if (count == 3)
		{
			System.Text.RegularExpressions.RegexCompilationInfo[] objs0 = LuaScriptMgr.GetArrayObject<System.Text.RegularExpressions.RegexCompilationInfo>(L, 1);
			System.Reflection.AssemblyName arg1 = (System.Reflection.AssemblyName)LuaScriptMgr.GetNetObject(L, 2, typeof(System.Reflection.AssemblyName));
			System.Reflection.Emit.CustomAttributeBuilder[] objs2 = LuaScriptMgr.GetArrayObject<System.Reflection.Emit.CustomAttributeBuilder>(L, 3);
			System.Text.RegularExpressions.Regex.CompileToAssembly(objs0,arg1,objs2);
			return 0;
		}
		else if (count == 4)
		{
			System.Text.RegularExpressions.RegexCompilationInfo[] objs0 = LuaScriptMgr.GetArrayObject<System.Text.RegularExpressions.RegexCompilationInfo>(L, 1);
			System.Reflection.AssemblyName arg1 = (System.Reflection.AssemblyName)LuaScriptMgr.GetNetObject(L, 2, typeof(System.Reflection.AssemblyName));
			System.Reflection.Emit.CustomAttributeBuilder[] objs2 = LuaScriptMgr.GetArrayObject<System.Reflection.Emit.CustomAttributeBuilder>(L, 3);
			string arg3 = LuaScriptMgr.GetLuaString(L, 4);
			System.Text.RegularExpressions.Regex.CompileToAssembly(objs0,arg1,objs2,arg3);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: System.Text.RegularExpressions.Regex.CompileToAssembly");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Escape(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = System.Text.RegularExpressions.Regex.Escape(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Unescape(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = System.Text.RegularExpressions.Regex.Unescape(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsMatch(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			bool o = obj.IsMatch(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			bool o = System.Text.RegularExpressions.Regex.IsMatch(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(int)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
			bool o = obj.IsMatch(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(System.Text.RegularExpressions.RegexOptions)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.RegexOptions arg2 = (System.Text.RegularExpressions.RegexOptions)LuaScriptMgr.GetLuaObject(L, 3);
			bool o = System.Text.RegularExpressions.Regex.IsMatch(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: System.Text.RegularExpressions.Regex.IsMatch");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Match(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.Match o = obj.Match(arg0);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.Match o = System.Text.RegularExpressions.Regex.Match(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(int)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
			System.Text.RegularExpressions.Match o = obj.Match(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(System.Text.RegularExpressions.RegexOptions)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.RegexOptions arg2 = (System.Text.RegularExpressions.RegexOptions)LuaScriptMgr.GetLuaObject(L, 3);
			System.Text.RegularExpressions.Match o = System.Text.RegularExpressions.Regex.Match(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4)
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 4);
			System.Text.RegularExpressions.Match o = obj.Match(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: System.Text.RegularExpressions.Regex.Match");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Matches(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.MatchCollection o = obj.Matches(arg0);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.MatchCollection o = System.Text.RegularExpressions.Regex.Matches(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(int)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
			System.Text.RegularExpressions.MatchCollection o = obj.Matches(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(System.Text.RegularExpressions.RegexOptions)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.RegexOptions arg2 = (System.Text.RegularExpressions.RegexOptions)LuaScriptMgr.GetLuaObject(L, 3);
			System.Text.RegularExpressions.MatchCollection o = System.Text.RegularExpressions.Regex.Matches(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: System.Text.RegularExpressions.Regex.Matches");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Replace(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(System.Text.RegularExpressions.MatchEvaluator)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.MatchEvaluator arg1 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (System.Text.RegularExpressions.MatchEvaluator)LuaScriptMgr.GetLuaObject(L, 3);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushObject(L, param0);
					func.PCall(top, 1);
					object[] objs = func.PopValues(top);
					func.EndPCall(top);
					return (string)objs[0];
				};
			}

			string o = obj.Replace(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(string)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			string arg1 = LuaScriptMgr.GetString(L, 3);
			string o = obj.Replace(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			string arg2 = LuaScriptMgr.GetString(L, 3);
			string o = System.Text.RegularExpressions.Regex.Replace(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(System.Text.RegularExpressions.MatchEvaluator)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.MatchEvaluator arg2 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg2 = (System.Text.RegularExpressions.MatchEvaluator)LuaScriptMgr.GetLuaObject(L, 3);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
				arg2 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushObject(L, param0);
					func.PCall(top, 1);
					object[] objs = func.PopValues(top);
					func.EndPCall(top);
					return (string)objs[0];
				};
			}

			string o = System.Text.RegularExpressions.Regex.Replace(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(string), typeof(int)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			string arg1 = LuaScriptMgr.GetString(L, 3);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 4);
			string o = obj.Replace(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(System.Text.RegularExpressions.MatchEvaluator), typeof(int)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.MatchEvaluator arg1 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (System.Text.RegularExpressions.MatchEvaluator)LuaScriptMgr.GetLuaObject(L, 3);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushObject(L, param0);
					func.PCall(top, 1);
					object[] objs = func.PopValues(top);
					func.EndPCall(top);
					return (string)objs[0];
				};
			}

			int arg2 = (int)LuaDLL.lua_tonumber(L, 4);
			string o = obj.Replace(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(string), typeof(System.Text.RegularExpressions.RegexOptions)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			string arg2 = LuaScriptMgr.GetString(L, 3);
			System.Text.RegularExpressions.RegexOptions arg3 = (System.Text.RegularExpressions.RegexOptions)LuaScriptMgr.GetLuaObject(L, 4);
			string o = System.Text.RegularExpressions.Regex.Replace(arg0,arg1,arg2,arg3);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(System.Text.RegularExpressions.MatchEvaluator), typeof(System.Text.RegularExpressions.RegexOptions)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.MatchEvaluator arg2 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg2 = (System.Text.RegularExpressions.MatchEvaluator)LuaScriptMgr.GetLuaObject(L, 3);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
				arg2 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushObject(L, param0);
					func.PCall(top, 1);
					object[] objs = func.PopValues(top);
					func.EndPCall(top);
					return (string)objs[0];
				};
			}

			System.Text.RegularExpressions.RegexOptions arg3 = (System.Text.RegularExpressions.RegexOptions)LuaScriptMgr.GetLuaObject(L, 4);
			string o = System.Text.RegularExpressions.Regex.Replace(arg0,arg1,arg2,arg3);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(string), typeof(int), typeof(int)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			string arg1 = LuaScriptMgr.GetString(L, 3);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 4);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 5);
			string o = obj.Replace(arg0,arg1,arg2,arg3);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(System.Text.RegularExpressions.MatchEvaluator), typeof(int), typeof(int)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.MatchEvaluator arg1 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (System.Text.RegularExpressions.MatchEvaluator)LuaScriptMgr.GetLuaObject(L, 3);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushObject(L, param0);
					func.PCall(top, 1);
					object[] objs = func.PopValues(top);
					func.EndPCall(top);
					return (string)objs[0];
				};
			}

			int arg2 = (int)LuaDLL.lua_tonumber(L, 4);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 5);
			string o = obj.Replace(arg0,arg1,arg2,arg3);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: System.Text.RegularExpressions.Regex.Replace");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Split(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			string[] o = obj.Split(arg0);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			string[] o = System.Text.RegularExpressions.Regex.Split(arg0,arg1);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(System.Text.RegularExpressions.Regex), typeof(string), typeof(int)))
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
			string[] o = obj.Split(arg0,arg1);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(System.Text.RegularExpressions.RegexOptions)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			System.Text.RegularExpressions.RegexOptions arg2 = (System.Text.RegularExpressions.RegexOptions)LuaScriptMgr.GetLuaObject(L, 3);
			string[] o = System.Text.RegularExpressions.Regex.Split(arg0,arg1,arg2);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else if (count == 4)
		{
			System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 4);
			string[] o = obj.Split(arg0,arg1,arg2);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: System.Text.RegularExpressions.Regex.Split");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetGroupNames(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
		string[] o = obj.GetGroupNames();
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetGroupNumbers(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
		int[] o = obj.GetGroupNumbers();
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GroupNameFromNumber(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		string o = obj.GroupNameFromNumber(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GroupNumberFromName(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		int o = obj.GroupNumberFromName(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToString(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		System.Text.RegularExpressions.Regex obj = (System.Text.RegularExpressions.Regex)LuaScriptMgr.GetNetObjectSelf(L, 1, "System.Text.RegularExpressions.Regex");
		string o = obj.ToString();
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

