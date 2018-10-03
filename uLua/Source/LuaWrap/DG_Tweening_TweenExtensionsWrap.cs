using System;
using UnityEngine;
using LuaInterface;

public class DG_Tweening_TweenExtensionsWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Complete", Complete),
			new LuaMethod("Flip", Flip),
			new LuaMethod("ForceInit", ForceInit),
			new LuaMethod("Goto", Goto),
			new LuaMethod("Kill", Kill),
			new LuaMethod("PlayBackwards", PlayBackwards),
			new LuaMethod("PlayForward", PlayForward),
			new LuaMethod("Restart", Restart),
			new LuaMethod("Rewind", Rewind),
			new LuaMethod("SmoothRewind", SmoothRewind),
			new LuaMethod("TogglePause", TogglePause),
			new LuaMethod("GotoWaypoint", GotoWaypoint),
			new LuaMethod("WaitForCompletion", WaitForCompletion),
			new LuaMethod("WaitForRewind", WaitForRewind),
			new LuaMethod("WaitForKill", WaitForKill),
			new LuaMethod("WaitForElapsedLoops", WaitForElapsedLoops),
			new LuaMethod("WaitForPosition", WaitForPosition),
			new LuaMethod("WaitForStart", WaitForStart),
			new LuaMethod("CompletedLoops", CompletedLoops),
			new LuaMethod("Delay", Delay),
			new LuaMethod("Duration", Duration),
			new LuaMethod("Elapsed", Elapsed),
			new LuaMethod("ElapsedPercentage", ElapsedPercentage),
			new LuaMethod("ElapsedDirectionalPercentage", ElapsedDirectionalPercentage),
			new LuaMethod("IsActive", IsActive),
			new LuaMethod("IsBackwards", IsBackwards),
			new LuaMethod("IsComplete", IsComplete),
			new LuaMethod("IsInitialized", IsInitialized),
			new LuaMethod("IsPlaying", IsPlaying),
			new LuaMethod("Loops", Loops),
			new LuaMethod("PathGetPoint", PathGetPoint),
			new LuaMethod("PathGetDrawPoints", PathGetDrawPoints),
			new LuaMethod("PathLength", PathLength),
			new LuaMethod("New", _CreateDG_Tweening_TweenExtensions),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaScriptMgr.RegisterLib(L, "DG.Tweening.TweenExtensions", regs);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDG_Tweening_TweenExtensions(IntPtr L)
	{
		LuaDLL.luaL_error(L, "DG.Tweening.TweenExtensions class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(DG.Tweening.TweenExtensions);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Complete(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
			DG.Tweening.TweenExtensions.Complete(arg0);
			return 0;
		}
		else if (count == 2)
		{
			DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
			bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
			DG.Tweening.TweenExtensions.Complete(arg0,arg1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.TweenExtensions.Complete");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Flip(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		DG.Tweening.TweenExtensions.Flip(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ForceInit(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		DG.Tweening.TweenExtensions.ForceInit(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Goto(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		bool arg2 = LuaScriptMgr.GetBoolean(L, 3);
		DG.Tweening.TweenExtensions.Goto(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Kill(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		DG.Tweening.TweenExtensions.Kill(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayBackwards(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		DG.Tweening.TweenExtensions.PlayBackwards(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayForward(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		DG.Tweening.TweenExtensions.PlayForward(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Restart(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		DG.Tweening.TweenExtensions.Restart(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Rewind(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		DG.Tweening.TweenExtensions.Rewind(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SmoothRewind(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		DG.Tweening.TweenExtensions.SmoothRewind(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TogglePause(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		DG.Tweening.TweenExtensions.TogglePause(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GotoWaypoint(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		bool arg2 = LuaScriptMgr.GetBoolean(L, 3);
		DG.Tweening.TweenExtensions.GotoWaypoint(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WaitForCompletion(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		YieldInstruction o = DG.Tweening.TweenExtensions.WaitForCompletion(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WaitForRewind(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		YieldInstruction o = DG.Tweening.TweenExtensions.WaitForRewind(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WaitForKill(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		YieldInstruction o = DG.Tweening.TweenExtensions.WaitForKill(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WaitForElapsedLoops(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		YieldInstruction o = DG.Tweening.TweenExtensions.WaitForElapsedLoops(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WaitForPosition(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		YieldInstruction o = DG.Tweening.TweenExtensions.WaitForPosition(arg0,arg1);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WaitForStart(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		Coroutine o = DG.Tweening.TweenExtensions.WaitForStart(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CompletedLoops(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		int o = DG.Tweening.TweenExtensions.CompletedLoops(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Delay(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		float o = DG.Tweening.TweenExtensions.Delay(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Duration(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		float o = DG.Tweening.TweenExtensions.Duration(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Elapsed(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		float o = DG.Tweening.TweenExtensions.Elapsed(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ElapsedPercentage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool arg1 = LuaScriptMgr.GetBoolean(L, 2);
		float o = DG.Tweening.TweenExtensions.ElapsedPercentage(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ElapsedDirectionalPercentage(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		float o = DG.Tweening.TweenExtensions.ElapsedDirectionalPercentage(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsActive(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool o = DG.Tweening.TweenExtensions.IsActive(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsBackwards(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool o = DG.Tweening.TweenExtensions.IsBackwards(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsComplete(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool o = DG.Tweening.TweenExtensions.IsComplete(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsInitialized(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool o = DG.Tweening.TweenExtensions.IsInitialized(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsPlaying(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		bool o = DG.Tweening.TweenExtensions.IsPlaying(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Loops(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		int o = DG.Tweening.TweenExtensions.Loops(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PathGetPoint(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		Vector3 o = DG.Tweening.TweenExtensions.PathGetPoint(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PathGetDrawPoints(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		Vector3[] o = DG.Tweening.TweenExtensions.PathGetDrawPoints(arg0,arg1);
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PathLength(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DG.Tweening.Tween arg0 = (DG.Tweening.Tween)LuaScriptMgr.GetNetObject(L, 1, typeof(DG.Tweening.Tween));
		float o = DG.Tweening.TweenExtensions.PathLength(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

