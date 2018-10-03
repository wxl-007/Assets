using System;
using LuaInterface;

public class DG_Tweening_EaseWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("Unset", GetUnset),
		new LuaMethod("Linear", GetLinear),
		new LuaMethod("InSine", GetInSine),
		new LuaMethod("OutSine", GetOutSine),
		new LuaMethod("InOutSine", GetInOutSine),
		new LuaMethod("InQuad", GetInQuad),
		new LuaMethod("OutQuad", GetOutQuad),
		new LuaMethod("InOutQuad", GetInOutQuad),
		new LuaMethod("InCubic", GetInCubic),
		new LuaMethod("OutCubic", GetOutCubic),
		new LuaMethod("InOutCubic", GetInOutCubic),
		new LuaMethod("InQuart", GetInQuart),
		new LuaMethod("OutQuart", GetOutQuart),
		new LuaMethod("InOutQuart", GetInOutQuart),
		new LuaMethod("InQuint", GetInQuint),
		new LuaMethod("OutQuint", GetOutQuint),
		new LuaMethod("InOutQuint", GetInOutQuint),
		new LuaMethod("InExpo", GetInExpo),
		new LuaMethod("OutExpo", GetOutExpo),
		new LuaMethod("InOutExpo", GetInOutExpo),
		new LuaMethod("InCirc", GetInCirc),
		new LuaMethod("OutCirc", GetOutCirc),
		new LuaMethod("InOutCirc", GetInOutCirc),
		new LuaMethod("InElastic", GetInElastic),
		new LuaMethod("OutElastic", GetOutElastic),
		new LuaMethod("InOutElastic", GetInOutElastic),
		new LuaMethod("InBack", GetInBack),
		new LuaMethod("OutBack", GetOutBack),
		new LuaMethod("InOutBack", GetInOutBack),
		new LuaMethod("InBounce", GetInBounce),
		new LuaMethod("OutBounce", GetOutBounce),
		new LuaMethod("InOutBounce", GetInOutBounce),
		new LuaMethod("Flash", GetFlash),
		new LuaMethod("InFlash", GetInFlash),
		new LuaMethod("OutFlash", GetOutFlash),
		new LuaMethod("InOutFlash", GetInOutFlash),
		new LuaMethod("INTERNAL_Zero", GetINTERNAL_Zero),
		new LuaMethod("INTERNAL_Custom", GetINTERNAL_Custom),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "DG.Tweening.Ease", typeof(DG.Tweening.Ease), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetUnset(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.Unset);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLinear(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.Linear);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInSine(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InSine);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutSine(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutSine);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutSine(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutSine);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInQuad(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InQuad);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutQuad(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutQuad);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutQuad(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutQuad);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInCubic(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InCubic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutCubic(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutCubic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutCubic(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutCubic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInQuart(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InQuart);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutQuart(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutQuart);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutQuart(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutQuart);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInQuint(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InQuint);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutQuint(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutQuint);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutQuint(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutQuint);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInExpo(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InExpo);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutExpo(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutExpo);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutExpo(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutExpo);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInCirc(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InCirc);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutCirc(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutCirc);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutCirc(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutCirc);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInElastic(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InElastic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutElastic(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutElastic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutElastic(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutElastic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInBack(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InBack);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutBack(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutBack);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutBack(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutBack);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInBounce(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InBounce);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutBounce(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutBounce);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutBounce(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutBounce);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFlash(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.Flash);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInFlash(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InFlash);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutFlash(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.OutFlash);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInOutFlash(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.InOutFlash);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetINTERNAL_Zero(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.INTERNAL_Zero);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetINTERNAL_Custom(IntPtr L)
	{
		LuaScriptMgr.Push(L, DG.Tweening.Ease.INTERNAL_Custom);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		DG.Tweening.Ease o = (DG.Tweening.Ease)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

