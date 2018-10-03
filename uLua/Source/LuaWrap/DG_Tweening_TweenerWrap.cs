using System;
using LuaInterface;

public class DG_Tweening_TweenerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("ChangeStartValue", ChangeStartValue),
			new LuaMethod("ChangeEndValue", ChangeEndValue),
			new LuaMethod("ChangeValues", ChangeValues),
			new LuaMethod("New", _CreateDG_Tweening_Tweener),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
		};

		LuaScriptMgr.RegisterLib(L, "DG.Tweening.Tweener", typeof(DG.Tweening.Tweener), regs, fields, typeof(DG.Tweening.Tween));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDG_Tweening_Tweener(IntPtr L)
	{
		LuaDLL.luaL_error(L, "DG.Tweening.Tweener class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(DG.Tweening.Tweener);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ChangeStartValue(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		DG.Tweening.Tweener obj = (DG.Tweening.Tweener)LuaScriptMgr.GetNetObjectSelf(L, 1, "DG.Tweening.Tweener");
		object arg0 = LuaScriptMgr.GetVarObject(L, 2);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = obj.ChangeStartValue(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ChangeEndValue(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			DG.Tweening.Tweener obj = (DG.Tweening.Tweener)LuaScriptMgr.GetNetObjectSelf(L, 1, "DG.Tweening.Tweener");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
			DG.Tweening.Tweener o = obj.ChangeEndValue(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4)
		{
			DG.Tweening.Tweener obj = (DG.Tweening.Tweener)LuaScriptMgr.GetNetObjectSelf(L, 1, "DG.Tweening.Tweener");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 3);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
			DG.Tweening.Tweener o = obj.ChangeEndValue(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.Tweener.ChangeEndValue");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ChangeValues(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		DG.Tweening.Tweener obj = (DG.Tweening.Tweener)LuaScriptMgr.GetNetObjectSelf(L, 1, "DG.Tweening.Tweener");
		object arg0 = LuaScriptMgr.GetVarObject(L, 2);
		object arg1 = LuaScriptMgr.GetVarObject(L, 3);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 4);
		DG.Tweening.Tweener o = obj.ChangeValues(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}
}

