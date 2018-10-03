using System;
using LuaInterface;

public class iTween_EaseTypeWrap
{
	static LuaMethod[] enums = new LuaMethod[]
	{
		new LuaMethod("easeInQuad", GeteaseInQuad),
		new LuaMethod("easeOutQuad", GeteaseOutQuad),
		new LuaMethod("easeInOutQuad", GeteaseInOutQuad),
		new LuaMethod("easeInCubic", GeteaseInCubic),
		new LuaMethod("easeOutCubic", GeteaseOutCubic),
		new LuaMethod("easeInOutCubic", GeteaseInOutCubic),
		new LuaMethod("easeInQuart", GeteaseInQuart),
		new LuaMethod("easeOutQuart", GeteaseOutQuart),
		new LuaMethod("easeInOutQuart", GeteaseInOutQuart),
		new LuaMethod("easeInQuint", GeteaseInQuint),
		new LuaMethod("easeOutQuint", GeteaseOutQuint),
		new LuaMethod("easeInOutQuint", GeteaseInOutQuint),
		new LuaMethod("easeInSine", GeteaseInSine),
		new LuaMethod("easeOutSine", GeteaseOutSine),
		new LuaMethod("easeInOutSine", GeteaseInOutSine),
		new LuaMethod("easeInExpo", GeteaseInExpo),
		new LuaMethod("easeOutExpo", GeteaseOutExpo),
		new LuaMethod("easeInOutExpo", GeteaseInOutExpo),
		new LuaMethod("easeInCirc", GeteaseInCirc),
		new LuaMethod("easeOutCirc", GeteaseOutCirc),
		new LuaMethod("easeInOutCirc", GeteaseInOutCirc),
		new LuaMethod("linear", Getlinear),
		new LuaMethod("spring", Getspring),
		new LuaMethod("easeInBounce", GeteaseInBounce),
		new LuaMethod("easeOutBounce", GeteaseOutBounce),
		new LuaMethod("easeInOutBounce", GeteaseInOutBounce),
		new LuaMethod("easeInBack", GeteaseInBack),
		new LuaMethod("easeOutBack", GeteaseOutBack),
		new LuaMethod("easeInOutBack", GeteaseInOutBack),
		new LuaMethod("easeInElastic", GeteaseInElastic),
		new LuaMethod("easeOutElastic", GeteaseOutElastic),
		new LuaMethod("easeInOutElastic", GeteaseInOutElastic),
		new LuaMethod("punch", Getpunch),
		new LuaMethod("IntToEnum", IntToEnum),
	};

	public static void Register(IntPtr L)
	{
		LuaScriptMgr.RegisterLib(L, "iTween.EaseType", typeof(iTween.EaseType), enums);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInQuad(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInQuad);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutQuad(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutQuad);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutQuad(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutQuad);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInCubic(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInCubic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutCubic(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutCubic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutCubic(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutCubic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInQuart(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInQuart);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutQuart(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutQuart);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutQuart(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutQuart);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInQuint(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInQuint);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutQuint(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutQuint);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutQuint(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutQuint);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInSine(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInSine);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutSine(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutSine);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutSine(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutSine);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInExpo(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInExpo);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutExpo(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutExpo);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutExpo(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutExpo);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInCirc(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInCirc);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutCirc(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutCirc);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutCirc(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutCirc);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Getlinear(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.linear);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Getspring(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.spring);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInBounce(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInBounce);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutBounce(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutBounce);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutBounce(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutBounce);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInBack(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInBack);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutBack(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutBack);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutBack(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutBack);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInElastic(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInElastic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseOutElastic(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeOutElastic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GeteaseInOutElastic(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.easeInOutElastic);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Getpunch(IntPtr L)
	{
		LuaScriptMgr.Push(L, iTween.EaseType.punch);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		iTween.EaseType o = (iTween.EaseType)arg0;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

