using System;
using LuaInterface;

public class DateTimeWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Add", Add),
			new LuaMethod("AddDays", AddDays),
			new LuaMethod("AddTicks", AddTicks),
			new LuaMethod("AddHours", AddHours),
			new LuaMethod("AddMilliseconds", AddMilliseconds),
			new LuaMethod("AddMinutes", AddMinutes),
			new LuaMethod("AddMonths", AddMonths),
			new LuaMethod("AddSeconds", AddSeconds),
			new LuaMethod("AddYears", AddYears),
			new LuaMethod("Compare", Compare),
			new LuaMethod("CompareTo", CompareTo),
			new LuaMethod("IsDaylightSavingTime", IsDaylightSavingTime),
			new LuaMethod("Equals", Equals),
			new LuaMethod("ToBinary", ToBinary),
			new LuaMethod("FromBinary", FromBinary),
			new LuaMethod("SpecifyKind", SpecifyKind),
			new LuaMethod("DaysInMonth", DaysInMonth),
			new LuaMethod("FromFileTime", FromFileTime),
			new LuaMethod("FromFileTimeUtc", FromFileTimeUtc),
			new LuaMethod("FromOADate", FromOADate),
			new LuaMethod("GetDateTimeFormats", GetDateTimeFormats),
			new LuaMethod("GetHashCode", GetHashCode),
			new LuaMethod("GetTypeCode", GetTypeCode),
			new LuaMethod("IsLeapYear", IsLeapYear),
			new LuaMethod("Parse", Parse),
			new LuaMethod("ParseExact", ParseExact),
			new LuaMethod("TryParse", TryParse),
			new LuaMethod("TryParseExact", TryParseExact),
			new LuaMethod("Subtract", Subtract),
			new LuaMethod("ToFileTime", ToFileTime),
			new LuaMethod("ToFileTimeUtc", ToFileTimeUtc),
			new LuaMethod("ToLongDateString", ToLongDateString),
			new LuaMethod("ToLongTimeString", ToLongTimeString),
			new LuaMethod("ToOADate", ToOADate),
			new LuaMethod("ToShortDateString", ToShortDateString),
			new LuaMethod("ToShortTimeString", ToShortTimeString),
			new LuaMethod("ToString", ToString),
			new LuaMethod("ToLocalTime", ToLocalTime),
			new LuaMethod("ToUniversalTime", ToUniversalTime),
			new LuaMethod("New", _CreateDateTime),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__tostring", Lua_ToString),
			new LuaMethod("__add", Lua_Add),
			new LuaMethod("__sub", Lua_Sub),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("MaxValue", get_MaxValue, null),
			new LuaField("MinValue", get_MinValue, null),
			new LuaField("Date", get_Date, null),
			new LuaField("Month", get_Month, null),
			new LuaField("Day", get_Day, null),
			new LuaField("DayOfWeek", get_DayOfWeek, null),
			new LuaField("DayOfYear", get_DayOfYear, null),
			new LuaField("TimeOfDay", get_TimeOfDay, null),
			new LuaField("Hour", get_Hour, null),
			new LuaField("Minute", get_Minute, null),
			new LuaField("Second", get_Second, null),
			new LuaField("Millisecond", get_Millisecond, null),
			new LuaField("Now", get_Now, null),
			new LuaField("Ticks", get_Ticks, null),
			new LuaField("Today", get_Today, null),
			new LuaField("UtcNow", get_UtcNow, null),
			new LuaField("Year", get_Year, null),
			new LuaField("Kind", get_Kind, null),
		};

		LuaScriptMgr.RegisterLib(L, "System.DateTime", typeof(DateTime), regs, fields, null);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDateTime(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			long arg0 = (long)LuaScriptMgr.GetNumber(L, 1);
			DateTime obj = new DateTime(arg0);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 2)
		{
			long arg0 = (long)LuaScriptMgr.GetNumber(L, 1);
			DateTimeKind arg1 = (DateTimeKind)LuaScriptMgr.GetNetObject(L, 2, typeof(DateTimeKind));
			DateTime obj = new DateTime(arg0,arg1);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 3)
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			DateTime obj = new DateTime(arg0,arg1,arg2);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 4)
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			System.Globalization.Calendar arg3 = (System.Globalization.Calendar)LuaScriptMgr.GetNetObject(L, 4, typeof(System.Globalization.Calendar));
			DateTime obj = new DateTime(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 6)
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
			DateTime obj = new DateTime(arg0,arg1,arg2,arg3,arg4,arg5);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 7 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(DateTimeKind)))
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
			DateTimeKind arg6 = (DateTimeKind)LuaScriptMgr.GetNetObject(L, 7, typeof(DateTimeKind));
			DateTime obj = new DateTime(arg0,arg1,arg2,arg3,arg4,arg5,arg6);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 7 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int)))
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
			int arg6 = (int)LuaScriptMgr.GetNumber(L, 7);
			DateTime obj = new DateTime(arg0,arg1,arg2,arg3,arg4,arg5,arg6);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 7 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(System.Globalization.Calendar)))
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
			System.Globalization.Calendar arg6 = (System.Globalization.Calendar)LuaScriptMgr.GetNetObject(L, 7, typeof(System.Globalization.Calendar));
			DateTime obj = new DateTime(arg0,arg1,arg2,arg3,arg4,arg5,arg6);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 8 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(DateTimeKind)))
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
			int arg6 = (int)LuaScriptMgr.GetNumber(L, 7);
			DateTimeKind arg7 = (DateTimeKind)LuaScriptMgr.GetNetObject(L, 8, typeof(DateTimeKind));
			DateTime obj = new DateTime(arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 8 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(System.Globalization.Calendar)))
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
			int arg6 = (int)LuaScriptMgr.GetNumber(L, 7);
			System.Globalization.Calendar arg7 = (System.Globalization.Calendar)LuaScriptMgr.GetNetObject(L, 8, typeof(System.Globalization.Calendar));
			DateTime obj = new DateTime(arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 9)
		{
			int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
			int arg6 = (int)LuaScriptMgr.GetNumber(L, 7);
			System.Globalization.Calendar arg7 = (System.Globalization.Calendar)LuaScriptMgr.GetNetObject(L, 8, typeof(System.Globalization.Calendar));
			DateTimeKind arg8 = (DateTimeKind)LuaScriptMgr.GetNetObject(L, 9, typeof(DateTimeKind));
			DateTime obj = new DateTime(arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 0)
		{
			DateTime obj = new DateTime();
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.New");
		}

		return 0;
	}

	static Type classType = typeof(DateTime);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MaxValue(IntPtr L)
	{
		LuaScriptMgr.PushValue(L, DateTime.MaxValue);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MinValue(IntPtr L)
	{
		LuaScriptMgr.PushValue(L, DateTime.MinValue);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Date(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Date");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Date on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.PushValue(L, obj.Date);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Month(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Month");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Month on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Month);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Day(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Day");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Day on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Day);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DayOfWeek(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name DayOfWeek");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index DayOfWeek on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.DayOfWeek);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DayOfYear(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name DayOfYear");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index DayOfYear on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.DayOfYear);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_TimeOfDay(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name TimeOfDay");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index TimeOfDay on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.PushValue(L, obj.TimeOfDay);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Hour(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Hour");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Hour on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Hour);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Minute(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Minute");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Minute on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Minute);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Second(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Second");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Second on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Second);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Millisecond(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Millisecond");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Millisecond on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Millisecond);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Now(IntPtr L)
	{
		LuaScriptMgr.PushValue(L, DateTime.Now);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Ticks(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Ticks");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Ticks on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Ticks);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Today(IntPtr L)
	{
		LuaScriptMgr.PushValue(L, DateTime.Today);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UtcNow(IntPtr L)
	{
		LuaScriptMgr.PushValue(L, DateTime.UtcNow);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Year(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Year");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Year on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Year);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Kind(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Kind");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Kind on a nil value");
			}
		}

		DateTime obj = (DateTime)o;
		LuaScriptMgr.Push(L, obj.Kind);
		return 1;
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
			LuaScriptMgr.Push(L, "Table: System.DateTime");
		}

		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Add(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		TimeSpan arg0 = (TimeSpan)LuaScriptMgr.GetNetObject(L, 2, typeof(TimeSpan));
		DateTime o = obj.Add(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddDays(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		double arg0 = (double)LuaScriptMgr.GetNumber(L, 2);
		DateTime o = obj.AddDays(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddTicks(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		long arg0 = (long)LuaScriptMgr.GetNumber(L, 2);
		DateTime o = obj.AddTicks(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddHours(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		double arg0 = (double)LuaScriptMgr.GetNumber(L, 2);
		DateTime o = obj.AddHours(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddMilliseconds(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		double arg0 = (double)LuaScriptMgr.GetNumber(L, 2);
		DateTime o = obj.AddMilliseconds(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddMinutes(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		double arg0 = (double)LuaScriptMgr.GetNumber(L, 2);
		DateTime o = obj.AddMinutes(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddMonths(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		DateTime o = obj.AddMonths(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddSeconds(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		double arg0 = (double)LuaScriptMgr.GetNumber(L, 2);
		DateTime o = obj.AddSeconds(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddYears(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		DateTime o = obj.AddYears(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Compare(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime arg0 = (DateTime)LuaScriptMgr.GetNetObject(L, 1, typeof(DateTime));
		DateTime arg1 = (DateTime)LuaScriptMgr.GetNetObject(L, 2, typeof(DateTime));
		int o = DateTime.Compare(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CompareTo(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(DateTime)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			DateTime arg0 = (DateTime)LuaScriptMgr.GetLuaObject(L, 2);
			int o = obj.CompareTo(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(object)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			int o = obj.CompareTo(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.CompareTo");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsDaylightSavingTime(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		bool o = obj.IsDaylightSavingTime();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Equals(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(DateTime)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetVarObject(L, 1);
			DateTime arg0 = (DateTime)LuaScriptMgr.GetLuaObject(L, 2);
			bool o = obj.Equals(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(object)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetVarObject(L, 1);
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			bool o = obj.Equals(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.Equals");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToBinary(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		long o = obj.ToBinary();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FromBinary(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		long arg0 = (long)LuaScriptMgr.GetNumber(L, 1);
		DateTime o = DateTime.FromBinary(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SpecifyKind(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime arg0 = (DateTime)LuaScriptMgr.GetNetObject(L, 1, typeof(DateTime));
		DateTimeKind arg1 = (DateTimeKind)LuaScriptMgr.GetNetObject(L, 2, typeof(DateTimeKind));
		DateTime o = DateTime.SpecifyKind(arg0,arg1);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DaysInMonth(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		int o = DateTime.DaysInMonth(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FromFileTime(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		long arg0 = (long)LuaScriptMgr.GetNumber(L, 1);
		DateTime o = DateTime.FromFileTime(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FromFileTimeUtc(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		long arg0 = (long)LuaScriptMgr.GetNumber(L, 1);
		DateTime o = DateTime.FromFileTimeUtc(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FromOADate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		double arg0 = (double)LuaScriptMgr.GetNumber(L, 1);
		DateTime o = DateTime.FromOADate(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDateTimeFormats(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			string[] o = obj.GetDateTimeFormats();
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(IFormatProvider)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			IFormatProvider arg0 = (IFormatProvider)LuaScriptMgr.GetLuaObject(L, 2);
			string[] o = obj.GetDateTimeFormats(arg0);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(char)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			char arg0 = (char)LuaDLL.lua_tonumber(L, 2);
			string[] o = obj.GetDateTimeFormats(arg0);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else if (count == 3)
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			char arg0 = (char)LuaScriptMgr.GetNumber(L, 2);
			IFormatProvider arg1 = (IFormatProvider)LuaScriptMgr.GetNetObject(L, 3, typeof(IFormatProvider));
			string[] o = obj.GetDateTimeFormats(arg0,arg1);
			LuaScriptMgr.PushArray(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.GetDateTimeFormats");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetHashCode(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		int o = obj.GetHashCode();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTypeCode(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		TypeCode o = obj.GetTypeCode();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsLeapYear(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		bool o = DateTime.IsLeapYear(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Parse(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			DateTime o = DateTime.Parse(arg0);
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else if (count == 2)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			IFormatProvider arg1 = (IFormatProvider)LuaScriptMgr.GetNetObject(L, 2, typeof(IFormatProvider));
			DateTime o = DateTime.Parse(arg0,arg1);
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else if (count == 3)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			IFormatProvider arg1 = (IFormatProvider)LuaScriptMgr.GetNetObject(L, 2, typeof(IFormatProvider));
			System.Globalization.DateTimeStyles arg2 = (System.Globalization.DateTimeStyles)LuaScriptMgr.GetNetObject(L, 3, typeof(System.Globalization.DateTimeStyles));
			DateTime o = DateTime.Parse(arg0,arg1,arg2);
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.Parse");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ParseExact(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			string arg1 = LuaScriptMgr.GetLuaString(L, 2);
			IFormatProvider arg2 = (IFormatProvider)LuaScriptMgr.GetNetObject(L, 3, typeof(IFormatProvider));
			DateTime o = DateTime.ParseExact(arg0,arg1,arg2);
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string[]), typeof(IFormatProvider), typeof(System.Globalization.DateTimeStyles)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string[] objs1 = LuaScriptMgr.GetArrayString(L, 2);
			IFormatProvider arg2 = (IFormatProvider)LuaScriptMgr.GetLuaObject(L, 3);
			System.Globalization.DateTimeStyles arg3 = (System.Globalization.DateTimeStyles)LuaScriptMgr.GetLuaObject(L, 4);
			DateTime o = DateTime.ParseExact(arg0,objs1,arg2,arg3);
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(IFormatProvider), typeof(System.Globalization.DateTimeStyles)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			IFormatProvider arg2 = (IFormatProvider)LuaScriptMgr.GetLuaObject(L, 3);
			System.Globalization.DateTimeStyles arg3 = (System.Globalization.DateTimeStyles)LuaScriptMgr.GetLuaObject(L, 4);
			DateTime o = DateTime.ParseExact(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.ParseExact");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TryParse(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			DateTime arg1;
			bool o = DateTime.TryParse(arg0,out arg1);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.PushValue(L, arg1);
			return 2;
		}
		else if (count == 4)
		{
			string arg0 = LuaScriptMgr.GetLuaString(L, 1);
			IFormatProvider arg1 = (IFormatProvider)LuaScriptMgr.GetNetObject(L, 2, typeof(IFormatProvider));
			System.Globalization.DateTimeStyles arg2 = (System.Globalization.DateTimeStyles)LuaScriptMgr.GetNetObject(L, 3, typeof(System.Globalization.DateTimeStyles));
			DateTime arg3;
			bool o = DateTime.TryParse(arg0,arg1,arg2,out arg3);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.PushValue(L, arg3);
			return 2;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.TryParse");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TryParseExact(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string[]), typeof(IFormatProvider), typeof(System.Globalization.DateTimeStyles), null))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string[] objs1 = LuaScriptMgr.GetArrayString(L, 2);
			IFormatProvider arg2 = (IFormatProvider)LuaScriptMgr.GetLuaObject(L, 3);
			System.Globalization.DateTimeStyles arg3 = (System.Globalization.DateTimeStyles)LuaScriptMgr.GetLuaObject(L, 4);
			DateTime arg4;
			bool o = DateTime.TryParseExact(arg0,objs1,arg2,arg3,out arg4);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.PushValue(L, arg4);
			return 2;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string), typeof(IFormatProvider), typeof(System.Globalization.DateTimeStyles), null))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			IFormatProvider arg2 = (IFormatProvider)LuaScriptMgr.GetLuaObject(L, 3);
			System.Globalization.DateTimeStyles arg3 = (System.Globalization.DateTimeStyles)LuaScriptMgr.GetLuaObject(L, 4);
			DateTime arg4;
			bool o = DateTime.TryParseExact(arg0,arg1,arg2,arg3,out arg4);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.PushValue(L, arg4);
			return 2;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.TryParseExact");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Subtract(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(TimeSpan)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			TimeSpan arg0 = (TimeSpan)LuaScriptMgr.GetLuaObject(L, 2);
			DateTime o = obj.Subtract(arg0);
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(DateTime)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			DateTime arg0 = (DateTime)LuaScriptMgr.GetLuaObject(L, 2);
			TimeSpan o = obj.Subtract(arg0);
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.Subtract");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToFileTime(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		long o = obj.ToFileTime();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToFileTimeUtc(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		long o = obj.ToFileTimeUtc();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToLongDateString(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		string o = obj.ToLongDateString();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToLongTimeString(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		string o = obj.ToLongTimeString();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToOADate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		double o = obj.ToOADate();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToShortDateString(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		string o = obj.ToShortDateString();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToShortTimeString(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		string o = obj.ToShortTimeString();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToString(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			string o = obj.ToString();
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(string)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			string arg0 = LuaScriptMgr.GetString(L, 2);
			string o = obj.ToString(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(IFormatProvider)))
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			IFormatProvider arg0 = (IFormatProvider)LuaScriptMgr.GetLuaObject(L, 2);
			string o = obj.ToString(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3)
		{
			DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			IFormatProvider arg1 = (IFormatProvider)LuaScriptMgr.GetNetObject(L, 3, typeof(IFormatProvider));
			string o = obj.ToString(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.ToString");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToLocalTime(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		DateTime o = obj.ToLocalTime();
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToUniversalTime(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DateTime obj = (DateTime)LuaScriptMgr.GetNetObjectSelf(L, 1, "DateTime");
		DateTime o = obj.ToUniversalTime();
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_Add(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime arg0 = (DateTime)LuaScriptMgr.GetNetObject(L, 1, typeof(DateTime));
		TimeSpan arg1 = (TimeSpan)LuaScriptMgr.GetNetObject(L, 2, typeof(TimeSpan));
		DateTime o = arg0 + arg1;
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_Eq(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DateTime arg0 = (DateTime)LuaScriptMgr.GetVarObject(L, 1);
		DateTime arg1 = (DateTime)LuaScriptMgr.GetVarObject(L, 2);
		bool o = arg0 == arg1;
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_Sub(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(TimeSpan)))
		{
			DateTime arg0 = (DateTime)LuaScriptMgr.GetLuaObject(L, 1);
			TimeSpan arg1 = (TimeSpan)LuaScriptMgr.GetLuaObject(L, 2);
			DateTime o = arg0 - arg1;
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DateTime), typeof(DateTime)))
		{
			DateTime arg0 = (DateTime)LuaScriptMgr.GetLuaObject(L, 1);
			DateTime arg1 = (DateTime)LuaScriptMgr.GetLuaObject(L, 2);
			TimeSpan o = arg0 - arg1;
			LuaScriptMgr.PushValue(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DateTime.op_Subtraction");
		}

		return 0;
	}
}

