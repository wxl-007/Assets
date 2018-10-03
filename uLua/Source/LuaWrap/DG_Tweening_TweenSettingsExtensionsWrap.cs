using System;
using UnityEngine;
using LuaInterface;

public class DG_Tweening_TweenSettingsExtensionsWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Append", Append),
			new LuaMethod("Prepend", Prepend),
			new LuaMethod("Join", Join),
			new LuaMethod("Insert", Insert),
			new LuaMethod("AppendInterval", AppendInterval),
			new LuaMethod("PrependInterval", PrependInterval),
			new LuaMethod("AppendCallback", AppendCallback),
			new LuaMethod("PrependCallback", PrependCallback),
			new LuaMethod("InsertCallback", InsertCallback),
			new LuaMethod("SetOptions", SetOptions),
			new LuaMethod("SetLookAt", SetLookAt),
			new LuaMethod("New", _CreateDG_Tweening_TweenSettingsExtensions),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaScriptMgr.RegisterLib(L, "DG.Tweening.TweenSettingsExtensions", regs);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDG_Tweening_TweenSettingsExtensions(IntPtr L)
	{
		LuaDLL.luaL_error(L, "DG.Tweening.TweenSettingsExtensions class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(DG.Tweening.TweenSettingsExtensions);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Append(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		DG.Tweening.Tween arg1 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Tween));
		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.Append(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Prepend(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		DG.Tweening.Tween arg1 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Tween));
		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.Prepend(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Join(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		DG.Tweening.Tween arg1 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Tween));
		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.Join(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Insert(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		DG.Tweening.Tween arg2 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 3, typeof(DG.Tweening.Tween));
		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.Insert(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AppendInterval(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.AppendInterval(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PrependInterval(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.PrependInterval(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AppendCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		DG.Tweening.TweenCallback arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (DG.Tweening.TweenCallback)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.TweenCallback));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = () =>
			{
				func.Call();
			};
		}

		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.AppendCallback(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PrependCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		DG.Tweening.TweenCallback arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (DG.Tweening.TweenCallback)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.TweenCallback));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = () =>
			{
				func.Call();
			};
		}

		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.PrependCallback(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InsertCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		DG.Tweening.Sequence arg0 = (DG.Tweening.Sequence)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Sequence));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		DG.Tweening.TweenCallback arg2 = null;
		LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

		if (funcType3 != LuaTypes.LUA_TFUNCTION)
		{
			 arg2 = (DG.Tweening.TweenCallback)LuaScriptMgr.GetNetObject(L, 3, typeof(DG.Tweening.TweenCallback));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 3);
			arg2 = () =>
			{
				func.Call();
			};
		}

		DG.Tweening.Sequence o = DG.Tweening.TweenSettingsExtensions.InsertCallback(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetOptions(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Quaternion,Vector3,DG.Tweening.Plugins.Options.QuaternionOptions>), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Quaternion,Vector3,DG.Tweening.Plugins.Options.QuaternionOptions> arg0 = (DG.Tweening.Core.TweenerCore<Quaternion,Vector3,DG.Tweening.Plugins.Options.QuaternionOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector4,Vector4,DG.Tweening.Plugins.Options.VectorOptions>), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Vector4,Vector4,DG.Tweening.Plugins.Options.VectorOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector4,Vector4,DG.Tweening.Plugins.Options.VectorOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Color,Color,DG.Tweening.Plugins.Options.ColorOptions>), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Color,Color,DG.Tweening.Plugins.Options.ColorOptions> arg0 = (DG.Tweening.Core.TweenerCore<Color,Color,DG.Tweening.Plugins.Options.ColorOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions>), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Rect,Rect,DG.Tweening.Plugins.Options.RectOptions>), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Rect,Rect,DG.Tweening.Plugins.Options.RectOptions> arg0 = (DG.Tweening.Core.TweenerCore<Rect,Rect,DG.Tweening.Plugins.Options.RectOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector2,Vector2,DG.Tweening.Plugins.Options.VectorOptions>), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Vector2,Vector2,DG.Tweening.Plugins.Options.VectorOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector2,Vector2,DG.Tweening.Plugins.Options.VectorOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<float,float,DG.Tweening.Plugins.Options.FloatOptions>), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<float,float,DG.Tweening.Plugins.Options.FloatOptions> arg0 = (DG.Tweening.Core.TweenerCore<float,float,DG.Tweening.Plugins.Options.FloatOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,Vector3,DG.Tweening.Plugins.Options.VectorOptions>), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,Vector3,DG.Tweening.Plugins.Options.VectorOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,Vector3,DG.Tweening.Plugins.Options.VectorOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,Vector3,DG.Tweening.Plugins.Options.VectorOptions>), typeof(DG.Tweening.AxisConstraint), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,Vector3,DG.Tweening.Plugins.Options.VectorOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,Vector3,DG.Tweening.Plugins.Options.VectorOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			DG.Tweening.AxisConstraint arg1 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 2);
			bool arg2 = LuaDLL.lua_toboolean(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions>), typeof(DG.Tweening.AxisConstraint), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			DG.Tweening.AxisConstraint arg1 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 2);
			bool arg2 = LuaDLL.lua_toboolean(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>), typeof(DG.Tweening.AxisConstraint), typeof(DG.Tweening.AxisConstraint)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			DG.Tweening.AxisConstraint arg1 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 2);
			DG.Tweening.AxisConstraint arg2 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 3);
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector2,Vector2,DG.Tweening.Plugins.Options.VectorOptions>), typeof(DG.Tweening.AxisConstraint), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Vector2,Vector2,DG.Tweening.Plugins.Options.VectorOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector2,Vector2,DG.Tweening.Plugins.Options.VectorOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			DG.Tweening.AxisConstraint arg1 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 2);
			bool arg2 = LuaDLL.lua_toboolean(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector4,Vector4,DG.Tweening.Plugins.Options.VectorOptions>), typeof(DG.Tweening.AxisConstraint), typeof(bool)))
		{
			DG.Tweening.Core.TweenerCore<Vector4,Vector4,DG.Tweening.Plugins.Options.VectorOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector4,Vector4,DG.Tweening.Plugins.Options.VectorOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			DG.Tweening.AxisConstraint arg1 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 2);
			bool arg2 = LuaDLL.lua_toboolean(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>), typeof(bool), typeof(DG.Tweening.AxisConstraint), typeof(DG.Tweening.AxisConstraint)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.AxisConstraint arg2 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 3);
			DG.Tweening.AxisConstraint arg3 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 4);
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<string,string,DG.Tweening.Plugins.Options.StringOptions>), typeof(bool), typeof(DG.Tweening.ScrambleMode), typeof(string)))
		{
			DG.Tweening.Core.TweenerCore<string,string,DG.Tweening.Plugins.Options.StringOptions> arg0 = (DG.Tweening.Core.TweenerCore<string,string,DG.Tweening.Plugins.Options.StringOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			DG.Tweening.ScrambleMode arg2 = (DG.Tweening.ScrambleMode)LuaScriptMgr.GetLuaObject(L, 3);
			string arg3 = LuaScriptMgr.GetString(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.TweenSettingsExtensions.SetOptions(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.TweenSettingsExtensions.SetOptions");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLookAt(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>), typeof(float), typeof(Nullable<Vector3>), typeof(Nullable<Vector3>)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			Nullable<Vector3> arg2 = (Nullable<Vector3>)LuaScriptMgr.GetLuaObject(L, 3);
			Nullable<Vector3> arg3 = (Nullable<Vector3>)LuaScriptMgr.GetLuaObject(L, 4);
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> o = DG.Tweening.TweenSettingsExtensions.SetLookAt(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>), typeof(Transform), typeof(Nullable<Vector3>), typeof(Nullable<Vector3>)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			Transform arg1 = (Transform)LuaScriptMgr.GetLuaObject(L, 2);
			Nullable<Vector3> arg2 = (Nullable<Vector3>)LuaScriptMgr.GetLuaObject(L, 3);
			Nullable<Vector3> arg3 = (Nullable<Vector3>)LuaScriptMgr.GetLuaObject(L, 4);
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> o = DG.Tweening.TweenSettingsExtensions.SetLookAt(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>), typeof(LuaTable), typeof(Nullable<Vector3>), typeof(Nullable<Vector3>)))
		{
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> arg0 = (DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions>)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			Nullable<Vector3> arg2 = (Nullable<Vector3>)LuaScriptMgr.GetLuaObject(L, 3);
			Nullable<Vector3> arg3 = (Nullable<Vector3>)LuaScriptMgr.GetLuaObject(L, 4);
			DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> o = DG.Tweening.TweenSettingsExtensions.SetLookAt(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.TweenSettingsExtensions.SetLookAt");
		}

		return 0;
	}
}

