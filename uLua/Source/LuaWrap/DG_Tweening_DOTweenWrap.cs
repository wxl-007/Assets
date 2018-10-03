using System;
using UnityEngine;
using System.Collections.Generic;
using LuaInterface;

public class DG_Tweening_DOTweenWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Init", Init),
			new LuaMethod("SetTweensCapacity", SetTweensCapacity),
			new LuaMethod("Clear", Clear),
			new LuaMethod("ClearCachedTweens", ClearCachedTweens),
			new LuaMethod("Validate", Validate),
			new LuaMethod("To", To),
			new LuaMethod("ToAxis", ToAxis),
			new LuaMethod("ToAlpha", ToAlpha),
			new LuaMethod("Punch", Punch),
			new LuaMethod("Shake", Shake),
			new LuaMethod("ToArray", ToArray),
			new LuaMethod("Sequence", Sequence),
			new LuaMethod("CompleteAll", CompleteAll),
			new LuaMethod("Complete", Complete),
			new LuaMethod("FlipAll", FlipAll),
			new LuaMethod("Flip", Flip),
			new LuaMethod("GotoAll", GotoAll),
			new LuaMethod("Goto", Goto),
			new LuaMethod("KillAll", KillAll),
			new LuaMethod("Kill", Kill),
			new LuaMethod("PauseAll", PauseAll),
			new LuaMethod("Pause", Pause),
			new LuaMethod("PlayAll", PlayAll),
			new LuaMethod("Play", Play),
			new LuaMethod("PlayBackwardsAll", PlayBackwardsAll),
			new LuaMethod("PlayBackwards", PlayBackwards),
			new LuaMethod("PlayForwardAll", PlayForwardAll),
			new LuaMethod("PlayForward", PlayForward),
			new LuaMethod("RestartAll", RestartAll),
			new LuaMethod("Restart", Restart),
			new LuaMethod("RewindAll", RewindAll),
			new LuaMethod("Rewind", Rewind),
			new LuaMethod("SmoothRewindAll", SmoothRewindAll),
			new LuaMethod("SmoothRewind", SmoothRewind),
			new LuaMethod("TogglePauseAll", TogglePauseAll),
			new LuaMethod("TogglePause", TogglePause),
			new LuaMethod("IsTweening", IsTweening),
			new LuaMethod("TotalPlayingTweens", TotalPlayingTweens),
			new LuaMethod("PlayingTweens", PlayingTweens),
			new LuaMethod("PausedTweens", PausedTweens),
			new LuaMethod("TweensById", TweensById),
			new LuaMethod("TweensByTarget", TweensByTarget),
			new LuaMethod("New", _CreateDG_Tweening_DOTween),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("Version", get_Version, null),
			new LuaField("useSafeMode", get_useSafeMode, set_useSafeMode),
			new LuaField("showUnityEditorReport", get_showUnityEditorReport, set_showUnityEditorReport),
			new LuaField("timeScale", get_timeScale, set_timeScale),
			new LuaField("useSmoothDeltaTime", get_useSmoothDeltaTime, set_useSmoothDeltaTime),
			new LuaField("drawGizmos", get_drawGizmos, set_drawGizmos),
			new LuaField("defaultUpdateType", get_defaultUpdateType, set_defaultUpdateType),
			new LuaField("defaultTimeScaleIndependent", get_defaultTimeScaleIndependent, set_defaultTimeScaleIndependent),
			new LuaField("defaultAutoPlay", get_defaultAutoPlay, set_defaultAutoPlay),
			new LuaField("defaultAutoKill", get_defaultAutoKill, set_defaultAutoKill),
			new LuaField("defaultLoopType", get_defaultLoopType, set_defaultLoopType),
			new LuaField("defaultRecyclable", get_defaultRecyclable, set_defaultRecyclable),
			new LuaField("defaultEaseType", get_defaultEaseType, set_defaultEaseType),
			new LuaField("defaultEaseOvershootOrAmplitude", get_defaultEaseOvershootOrAmplitude, set_defaultEaseOvershootOrAmplitude),
			new LuaField("defaultEasePeriod", get_defaultEasePeriod, set_defaultEasePeriod),
			new LuaField("logBehaviour", get_logBehaviour, set_logBehaviour),
		};

		LuaScriptMgr.RegisterLib(L, "DG.Tweening.DOTween", typeof(DG.Tweening.DOTween), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDG_Tweening_DOTween(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			DG.Tweening.DOTween obj = new DG.Tweening.DOTween();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.DOTween.New");
		}

		return 0;
	}

	static Type classType = typeof(DG.Tweening.DOTween);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Version(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.Version);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_useSafeMode(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.useSafeMode);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_showUnityEditorReport(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.showUnityEditorReport);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_timeScale(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.timeScale);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_useSmoothDeltaTime(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.useSmoothDeltaTime);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_drawGizmos(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.drawGizmos);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultUpdateType(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultUpdateType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultTimeScaleIndependent(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultTimeScaleIndependent);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultAutoPlay(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultAutoPlay);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultAutoKill(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultAutoKill);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultLoopType(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultLoopType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultRecyclable(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultRecyclable);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultEaseType(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultEaseType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultEaseOvershootOrAmplitude(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultEaseOvershootOrAmplitude);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_defaultEasePeriod(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.defaultEasePeriod);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_logBehaviour(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.DOTween.logBehaviour);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_useSafeMode(IntPtr L)
	{
		DG.Tweening.DOTween.useSafeMode = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_showUnityEditorReport(IntPtr L)
	{
		DG.Tweening.DOTween.showUnityEditorReport = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_timeScale(IntPtr L)
	{
		DG.Tweening.DOTween.timeScale = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_useSmoothDeltaTime(IntPtr L)
	{
		DG.Tweening.DOTween.useSmoothDeltaTime = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_drawGizmos(IntPtr L)
	{
		DG.Tweening.DOTween.drawGizmos = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultUpdateType(IntPtr L)
	{
		DG.Tweening.DOTween.defaultUpdateType = (DG.Tweening.UpdateType)LuaScriptMgr.GetNetObject(L, 3, typeof(DG.Tweening.UpdateType));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultTimeScaleIndependent(IntPtr L)
	{
		DG.Tweening.DOTween.defaultTimeScaleIndependent = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultAutoPlay(IntPtr L)
	{
		DG.Tweening.DOTween.defaultAutoPlay = (DG.Tweening.AutoPlay)LuaScriptMgr.GetNetObject(L, 3, typeof(DG.Tweening.AutoPlay));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultAutoKill(IntPtr L)
	{
		DG.Tweening.DOTween.defaultAutoKill = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultLoopType(IntPtr L)
	{
		DG.Tweening.DOTween.defaultLoopType = (DG.Tweening.LoopType)LuaScriptMgr.GetNetObject(L, 3, typeof(DG.Tweening.LoopType));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultRecyclable(IntPtr L)
	{
		DG.Tweening.DOTween.defaultRecyclable = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultEaseType(IntPtr L)
	{
		DG.Tweening.DOTween.defaultEaseType = (DG.Tweening.Ease)LuaScriptMgr.GetNetObject(L, 3, typeof(DG.Tweening.Ease));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultEaseOvershootOrAmplitude(IntPtr L)
	{
		DG.Tweening.DOTween.defaultEaseOvershootOrAmplitude = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_defaultEasePeriod(IntPtr L)
	{
		DG.Tweening.DOTween.defaultEasePeriod = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_logBehaviour(IntPtr L)
	{
		DG.Tweening.DOTween.logBehaviour = (DG.Tweening.LogBehaviour)LuaScriptMgr.GetNetObject(L, 3, typeof(DG.Tweening.LogBehaviour));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Nullable<bool> arg0 = (Nullable<bool>)LuaScriptMgr.GetNetObject(L, 1, typeof(Nullable<bool>));
		Nullable<bool> arg1 = (Nullable<bool>)LuaScriptMgr.GetNetObject(L, 2, typeof(Nullable<bool>));
		Nullable<DG.Tweening.LogBehaviour> arg2 = (Nullable<DG.Tweening.LogBehaviour>)LuaScriptMgr.GetNetObject(L, 3, typeof(Nullable<DG.Tweening.LogBehaviour>));
		DG.Tweening.IDOTweenInit o = DG.Tweening.DOTween.Init(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTweensCapacity(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		DG.Tweening.DOTween.SetTweensCapacity(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clear(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		bool arg0 = LuaScriptMgr.GetBoolean(L, 1);
		DG.Tweening.DOTween.Clear(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearCachedTweens(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		DG.Tweening.DOTween.ClearCachedTweens();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Validate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.Validate();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int To(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<Quaternion>), typeof(DG.Tweening.Core.DOSetter<Quaternion>), typeof(LuaTable), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<Quaternion> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<Quaternion>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (Quaternion)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<Quaternion> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<Quaternion>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<Quaternion,Vector3,DG.Tweening.Plugins.Options.QuaternionOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<Vector4>), typeof(DG.Tweening.Core.DOSetter<Vector4>), typeof(LuaTable), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<Vector4> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<Vector4>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (Vector4)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<Vector4> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<Vector4>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Vector4 arg2 = LuaScriptMgr.GetVector4(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<Vector4,Vector4,DG.Tweening.Plugins.Options.VectorOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<Vector3>), typeof(DG.Tweening.Core.DOSetter<Vector3>), typeof(LuaTable), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<Vector3> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<Vector3>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (Vector3)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<Vector3> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<Vector3>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<Vector3,Vector3,DG.Tweening.Plugins.Options.VectorOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<Color>), typeof(DG.Tweening.Core.DOSetter<Color>), typeof(LuaTable), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<Color> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<Color>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (Color)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<Color> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<Color>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Color arg2 = LuaScriptMgr.GetColor(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<Color,Color,DG.Tweening.Plugins.Options.ColorOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOSetter<float>), typeof(float), typeof(float), typeof(float)))
		{
			DG.Tweening.Core.DOSetter<float> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOSetter<float>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<RectOffset>), typeof(DG.Tweening.Core.DOSetter<RectOffset>), typeof(RectOffset), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<RectOffset> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<RectOffset>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (RectOffset)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<RectOffset> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<RectOffset>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushObject(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			RectOffset arg2 = (RectOffset)LuaScriptMgr.GetLuaObject(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<Rect>), typeof(DG.Tweening.Core.DOSetter<Rect>), typeof(Rect), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<Rect> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<Rect>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (Rect)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<Rect> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<Rect>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.PushValue(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Rect arg2 = (Rect)LuaScriptMgr.GetLuaObject(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<Rect,Rect,DG.Tweening.Plugins.Options.RectOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<Vector2>), typeof(DG.Tweening.Core.DOSetter<Vector2>), typeof(LuaTable), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<Vector2> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<Vector2>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (Vector2)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<Vector2> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<Vector2>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			Vector2 arg2 = LuaScriptMgr.GetVector2(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<Vector2,Vector2,DG.Tweening.Plugins.Options.VectorOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<int>), typeof(DG.Tweening.Core.DOSetter<int>), typeof(int), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<int> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<int>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (int)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<int> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<int>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			int arg2 = (int)LuaDLL.lua_tonumber(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<double>), typeof(DG.Tweening.Core.DOSetter<double>), typeof(double), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<double> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<double>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (double)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<double> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<double>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			double arg2 = (double)LuaDLL.lua_tonumber(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<double,double,DG.Tweening.Plugins.Options.NoOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<float>), typeof(DG.Tweening.Core.DOSetter<float>), typeof(float), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<float> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<float>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (float)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<float> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<float>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<float,float,DG.Tweening.Plugins.Options.FloatOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<uint>), typeof(DG.Tweening.Core.DOSetter<uint>), typeof(uint), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<uint> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<uint>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (uint)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<uint> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<uint>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			uint arg2 = (uint)LuaDLL.lua_tonumber(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<string>), typeof(DG.Tweening.Core.DOSetter<string>), typeof(string), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<string> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<string>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (string)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<string> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<string>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			string arg2 = LuaScriptMgr.GetString(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Core.TweenerCore<string,string,DG.Tweening.Plugins.Options.StringOptions> o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<ulong>), typeof(DG.Tweening.Core.DOSetter<ulong>), typeof(ulong), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<ulong> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<ulong>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (ulong)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<ulong> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<ulong>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			ulong arg2 = (ulong)LuaDLL.lua_tonumber(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(DG.Tweening.Core.DOGetter<long>), typeof(DG.Tweening.Core.DOSetter<long>), typeof(long), typeof(float)))
		{
			DG.Tweening.Core.DOGetter<long> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<long>)LuaScriptMgr.GetLuaObject(L, 1);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (long)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<long> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<long>)LuaScriptMgr.GetLuaObject(L, 2);
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			long arg2 = (long)LuaDLL.lua_tonumber(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.DOTween.To(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.DOTween.To");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToAxis(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 5);
		DG.Tweening.Core.DOGetter<Vector3> arg0 = null;
		LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

		if (funcType1 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (DG.Tweening.Core.DOGetter<Vector3>)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Core.DOGetter<Vector3>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
			arg0 = () =>
			{
				object[] objs = func.Call();
				return (Vector3)objs[0];
			};
		}

		DG.Tweening.Core.DOSetter<Vector3> arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (DG.Tweening.Core.DOSetter<Vector3>)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Core.DOSetter<Vector3>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}

		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
		DG.Tweening.AxisConstraint arg4 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetNetObject(L, 5, typeof(DG.Tweening.AxisConstraint));
		DG.Tweening.Core.TweenerCore<Vector3,Vector3,DG.Tweening.Plugins.Options.VectorOptions> o = DG.Tweening.DOTween.ToAxis(arg0,arg1,arg2,arg3,arg4);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToAlpha(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		DG.Tweening.Core.DOGetter<Color> arg0 = null;
		LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

		if (funcType1 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (DG.Tweening.Core.DOGetter<Color>)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Core.DOGetter<Color>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
			arg0 = () =>
			{
				object[] objs = func.Call();
				return (Color)objs[0];
			};
		}

		DG.Tweening.Core.DOSetter<Color> arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (DG.Tweening.Core.DOSetter<Color>)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Core.DOSetter<Color>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}

		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.DOTween.ToAlpha(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Punch(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 6);
		DG.Tweening.Core.DOGetter<Vector3> arg0 = null;
		LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

		if (funcType1 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (DG.Tweening.Core.DOGetter<Vector3>)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Core.DOGetter<Vector3>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
			arg0 = () =>
			{
				object[] objs = func.Call();
				return (Vector3)objs[0];
			};
		}

		DG.Tweening.Core.DOSetter<Vector3> arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (DG.Tweening.Core.DOSetter<Vector3>)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Core.DOSetter<Vector3>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}

		Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
		float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
		int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
		float arg5 = (float)LuaScriptMgr.GetNumber(L, 6);
		DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions> o = DG.Tweening.DOTween.Punch(arg0,arg1,arg2,arg3,arg4,arg5);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Shake(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 6)
		{
			DG.Tweening.Core.DOGetter<Vector3> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<Vector3>)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Core.DOGetter<Vector3>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (Vector3)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<Vector3> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<Vector3>)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Core.DOSetter<Vector3>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
			Vector3 arg3 = LuaScriptMgr.GetVector3(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			float arg5 = (float)LuaScriptMgr.GetNumber(L, 6);
			DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions> o = DG.Tweening.DOTween.Shake(arg0,arg1,arg2,arg3,arg4,arg5);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 7)
		{
			DG.Tweening.Core.DOGetter<Vector3> arg0 = null;
			LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

			if (funcType1 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.Core.DOGetter<Vector3>)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Core.DOGetter<Vector3>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
				arg0 = () =>
				{
					object[] objs = func.Call();
					return (Vector3)objs[0];
				};
			}

			DG.Tweening.Core.DOSetter<Vector3> arg1 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (DG.Tweening.Core.DOSetter<Vector3>)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Core.DOSetter<Vector3>));
			}
			else
			{
				LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
				arg1 = (param0) =>
				{
					int top = func.BeginPCall();
					LuaScriptMgr.Push(L, param0);
					func.PCall(top, 1);
					func.EndPCall(top);
				};
			}

			float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
			float arg5 = (float)LuaScriptMgr.GetNumber(L, 6);
			bool arg6 = LuaScriptMgr.GetBoolean(L, 7);
			DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions> o = DG.Tweening.DOTween.Shake(arg0,arg1,arg2,arg3,arg4,arg5,arg6);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.DOTween.Shake");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToArray(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		DG.Tweening.Core.DOGetter<Vector3> arg0 = null;
		LuaTypes funcType1 = LuaDLL.lua_type(L, 1);

		if (funcType1 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (DG.Tweening.Core.DOGetter<Vector3>)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Core.DOGetter<Vector3>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 1);
			arg0 = () =>
			{
				object[] objs = func.Call();
				return (Vector3)objs[0];
			};
		}

		DG.Tweening.Core.DOSetter<Vector3> arg1 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg1 = (DG.Tweening.Core.DOSetter<Vector3>)LuaScriptMgr.GetNetObject(L, 2, typeof(DG.Tweening.Core.DOSetter<Vector3>));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg1 = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}

		Vector3[] objs2 = LuaScriptMgr.GetArrayObject<Vector3>(L, 3);
		float[] objs3 = LuaScriptMgr.GetArrayNumber<float>(L, 4);
		DG.Tweening.Core.TweenerCore<Vector3,Vector3[],DG.Tweening.Plugins.Options.Vector3ArrayOptions> o = DG.Tweening.DOTween.ToArray(arg0,arg1,objs2,objs3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Sequence(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		DG.Tweening.Sequence o = DG.Tweening.DOTween.Sequence();
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CompleteAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		bool arg0 = LuaScriptMgr.GetBoolean(L, 1);
		int o = DG.Tweening.DOTween.CompleteAll(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Complete(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		int o = DG.Tweening.DOTween.Complete(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FlipAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.FlipAll();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Flip(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		int o = DG.Tweening.DOTween.Flip(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GotoAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		int o = DG.Tweening.DOTween.GotoAll(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Goto(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		bool arg2 = LuaScriptMgr.GetBoolean(L, 3);
		int o = DG.Tweening.DOTween.Goto(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int KillAll(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			bool arg0 = LuaScriptMgr.GetBoolean(L, 1);
			int o = DG.Tweening.DOTween.KillAll(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckTypes(L, 1, typeof(bool)) && LuaScriptMgr.CheckParamsType(L, typeof(object), 2, count - 1))
		{
			bool arg0 = LuaDLL.lua_toboolean(L, 1);
			object[] objs1 = LuaScriptMgr.GetParamsObject(L, 2, count - 1);
			int o = DG.Tweening.DOTween.KillAll(arg0,objs1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.DOTween.KillAll");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Kill(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		int o = DG.Tweening.DOTween.Kill(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PauseAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.PauseAll();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Pause(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		int o = DG.Tweening.DOTween.Pause(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.PlayAll();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Play(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			object arg0 = LuaScriptMgr.GetVarObject(L, 1);
			int o = DG.Tweening.DOTween.Play(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2)
		{
			object arg0 = LuaScriptMgr.GetVarObject(L, 1);
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			int o = DG.Tweening.DOTween.Play(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.DOTween.Play");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayBackwardsAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.PlayBackwardsAll();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayBackwards(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		int o = DG.Tweening.DOTween.PlayBackwards(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayForwardAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.PlayForwardAll();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayForward(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		int o = DG.Tweening.DOTween.PlayForward(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RestartAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		bool arg0 = LuaScriptMgr.GetBoolean(L, 1);
		int o = DG.Tweening.DOTween.RestartAll(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Restart(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			object arg0 = LuaScriptMgr.GetVarObject(L, 1);
			bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
			int o = DG.Tweening.DOTween.Restart(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3)
		{
			object arg0 = LuaScriptMgr.GetVarObject(L, 1);
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 3);
			int o = DG.Tweening.DOTween.Restart(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.DOTween.Restart");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RewindAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		bool arg0 = LuaScriptMgr.GetBoolean(L, 1);
		int o = DG.Tweening.DOTween.RewindAll(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Rewind(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		int o = DG.Tweening.DOTween.Rewind(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SmoothRewindAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.SmoothRewindAll();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SmoothRewind(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		int o = DG.Tweening.DOTween.SmoothRewind(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TogglePauseAll(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.TogglePauseAll();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TogglePause(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		int o = DG.Tweening.DOTween.TogglePause(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsTweening(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		bool o = DG.Tweening.DOTween.IsTweening(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TotalPlayingTweens(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = DG.Tweening.DOTween.TotalPlayingTweens();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayingTweens(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		List<DG.Tweening.Tween> o = DG.Tweening.DOTween.PlayingTweens();
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PausedTweens(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		List<DG.Tweening.Tween> o = DG.Tweening.DOTween.PausedTweens();
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TweensById(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		List<DG.Tweening.Tween> o = DG.Tweening.DOTween.TweensById(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TweensByTarget(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		object arg0 = LuaScriptMgr.GetVarObject(L, 1);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		List<DG.Tweening.Tween> o = DG.Tweening.DOTween.TweensByTarget(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}
}

