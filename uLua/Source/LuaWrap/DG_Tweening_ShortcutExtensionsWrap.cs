using System;
using UnityEngine;
using LuaInterface;

public class DG_Tweening_ShortcutExtensionsWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("DOFade", DOFade),
			new LuaMethod("DOPitch", DOPitch),
			new LuaMethod("DOAspect", DOAspect),
			new LuaMethod("DOColor", DOColor),
			new LuaMethod("DOFarClipPlane", DOFarClipPlane),
			new LuaMethod("DOFieldOfView", DOFieldOfView),
			new LuaMethod("DONearClipPlane", DONearClipPlane),
			new LuaMethod("DOOrthoSize", DOOrthoSize),
			new LuaMethod("DOPixelRect", DOPixelRect),
			new LuaMethod("DORect", DORect),
			new LuaMethod("DOShakePosition", DOShakePosition),
			new LuaMethod("DOShakeRotation", DOShakeRotation),
			new LuaMethod("DOIntensity", DOIntensity),
			new LuaMethod("DOShadowStrength", DOShadowStrength),
			new LuaMethod("DOFloat", DOFloat),
			new LuaMethod("DOOffset", DOOffset),
			new LuaMethod("DOTiling", DOTiling),
			new LuaMethod("DOVector", DOVector),
			new LuaMethod("DOMove", DOMove),
			new LuaMethod("DOMoveX", DOMoveX),
			new LuaMethod("DOMoveY", DOMoveY),
			new LuaMethod("DOMoveZ", DOMoveZ),
			new LuaMethod("DORotate", DORotate),
			new LuaMethod("DOLookAt", DOLookAt),
			new LuaMethod("DOJump", DOJump),
			new LuaMethod("DOResize", DOResize),
			new LuaMethod("DOTime", DOTime),
			new LuaMethod("DOLocalMove", DOLocalMove),
			new LuaMethod("DOLocalMoveX", DOLocalMoveX),
			new LuaMethod("DOLocalMoveY", DOLocalMoveY),
			new LuaMethod("DOLocalMoveZ", DOLocalMoveZ),
			new LuaMethod("DORotateQuaternion", DORotateQuaternion),
			new LuaMethod("DOLocalRotate", DOLocalRotate),
			new LuaMethod("DOLocalRotateQuaternion", DOLocalRotateQuaternion),
			new LuaMethod("DOScale", DOScale),
			new LuaMethod("DOScaleX", DOScaleX),
			new LuaMethod("DOScaleY", DOScaleY),
			new LuaMethod("DOScaleZ", DOScaleZ),
			new LuaMethod("DOPunchPosition", DOPunchPosition),
			new LuaMethod("DOPunchScale", DOPunchScale),
			new LuaMethod("DOPunchRotation", DOPunchRotation),
			new LuaMethod("DOShakeScale", DOShakeScale),
			new LuaMethod("DOLocalJump", DOLocalJump),
			new LuaMethod("DOPath", DOPath),
			new LuaMethod("DOLocalPath", DOLocalPath),
			new LuaMethod("DOBlendableColor", DOBlendableColor),
			new LuaMethod("DOBlendableMoveBy", DOBlendableMoveBy),
			new LuaMethod("DOBlendableLocalMoveBy", DOBlendableLocalMoveBy),
			new LuaMethod("DOBlendableRotateBy", DOBlendableRotateBy),
			new LuaMethod("DOBlendableLocalRotateBy", DOBlendableLocalRotateBy),
			new LuaMethod("DOBlendableScaleBy", DOBlendableScaleBy),
			new LuaMethod("DOComplete", DOComplete),
			new LuaMethod("DOKill", DOKill),
			new LuaMethod("DOFlip", DOFlip),
			new LuaMethod("DOGoto", DOGoto),
			new LuaMethod("DOPause", DOPause),
			new LuaMethod("DOPlay", DOPlay),
			new LuaMethod("DOPlayBackwards", DOPlayBackwards),
			new LuaMethod("DOPlayForward", DOPlayForward),
			new LuaMethod("DORestart", DORestart),
			new LuaMethod("DORewind", DORewind),
			new LuaMethod("DOSmoothRewind", DOSmoothRewind),
			new LuaMethod("DOTogglePause", DOTogglePause),
			new LuaMethod("New", _CreateDG_Tweening_ShortcutExtensions),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaScriptMgr.RegisterLib(L, "DG.Tweening.ShortcutExtensions", regs);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDG_Tweening_ShortcutExtensions(IntPtr L)
	{
		LuaDLL.luaL_error(L, "DG.Tweening.ShortcutExtensions class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(DG.Tweening.ShortcutExtensions);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOFade(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(float), typeof(float)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOFade(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(AudioSource), typeof(float), typeof(float)))
		{
			AudioSource arg0 = (AudioSource)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOFade(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4)
		{
			Material arg0 = (Material)LuaScriptMgr.GetUnityObject(L, 1, typeof(Material));
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			string arg2 = LuaScriptMgr.GetLuaString(L, 3);
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOFade(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOFade");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPitch(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		AudioSource arg0 = (AudioSource)LuaScriptMgr.GetUnityObject(L, 1, typeof(AudioSource));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOPitch(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOAspect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Camera arg0 = (Camera)LuaScriptMgr.GetUnityObject(L, 1, typeof(Camera));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOAspect(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOColor(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(LuaTable), typeof(float)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			Color arg1 = LuaScriptMgr.GetColor(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOColor(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Light), typeof(LuaTable), typeof(float)))
		{
			Light arg0 = (Light)LuaScriptMgr.GetLuaObject(L, 1);
			Color arg1 = LuaScriptMgr.GetColor(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOColor(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Camera), typeof(LuaTable), typeof(float)))
		{
			Camera arg0 = (Camera)LuaScriptMgr.GetLuaObject(L, 1);
			Color arg1 = LuaScriptMgr.GetColor(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOColor(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(LuaTable), typeof(string), typeof(float)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			Color arg1 = LuaScriptMgr.GetColor(L, 2);
			string arg2 = LuaScriptMgr.GetString(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOColor(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(LineRenderer), typeof(DG.Tweening.Color2), typeof(DG.Tweening.Color2), typeof(float)))
		{
			LineRenderer arg0 = (LineRenderer)LuaScriptMgr.GetLuaObject(L, 1);
			DG.Tweening.Color2 arg1 = (DG.Tweening.Color2)LuaScriptMgr.GetLuaObject(L, 2);
			DG.Tweening.Color2 arg2 = (DG.Tweening.Color2)LuaScriptMgr.GetLuaObject(L, 3);
			float arg3 = (float)LuaDLL.lua_tonumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOColor(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOColor");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOFarClipPlane(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Camera arg0 = (Camera)LuaScriptMgr.GetUnityObject(L, 1, typeof(Camera));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOFarClipPlane(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOFieldOfView(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Camera arg0 = (Camera)LuaScriptMgr.GetUnityObject(L, 1, typeof(Camera));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOFieldOfView(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DONearClipPlane(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Camera arg0 = (Camera)LuaScriptMgr.GetUnityObject(L, 1, typeof(Camera));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DONearClipPlane(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOOrthoSize(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Camera arg0 = (Camera)LuaScriptMgr.GetUnityObject(L, 1, typeof(Camera));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOOrthoSize(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPixelRect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Camera arg0 = (Camera)LuaScriptMgr.GetUnityObject(L, 1, typeof(Camera));
		Rect arg1 = (Rect)LuaScriptMgr.GetNetObject(L, 2, typeof(Rect));
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOPixelRect(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DORect(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Camera arg0 = (Camera)LuaScriptMgr.GetUnityObject(L, 1, typeof(Camera));
		Rect arg1 = (Rect)LuaScriptMgr.GetNetObject(L, 2, typeof(Rect));
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DORect(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOShakePosition(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Camera), typeof(float), typeof(LuaTable), typeof(int), typeof(float)))
		{
			Camera arg0 = (Camera)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakePosition(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Camera), typeof(float), typeof(float), typeof(int), typeof(float)))
		{
			Camera arg0 = (Camera)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakePosition(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 6 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(LuaTable), typeof(int), typeof(float), typeof(bool)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			bool arg5 = LuaDLL.lua_toboolean(L, 6);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakePosition(arg0,arg1,arg2,arg3,arg4,arg5);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 6 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(float), typeof(int), typeof(float), typeof(bool)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			bool arg5 = LuaDLL.lua_toboolean(L, 6);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakePosition(arg0,arg1,arg2,arg3,arg4,arg5);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOShakePosition");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOShakeRotation(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(float), typeof(int), typeof(float)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakeRotation(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(LuaTable), typeof(int), typeof(float)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakeRotation(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Camera), typeof(float), typeof(float), typeof(int), typeof(float)))
		{
			Camera arg0 = (Camera)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakeRotation(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Camera), typeof(float), typeof(LuaTable), typeof(int), typeof(float)))
		{
			Camera arg0 = (Camera)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakeRotation(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOShakeRotation");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOIntensity(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Light arg0 = (Light)LuaScriptMgr.GetUnityObject(L, 1, typeof(Light));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOIntensity(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOShadowStrength(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Light arg0 = (Light)LuaScriptMgr.GetUnityObject(L, 1, typeof(Light));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShadowStrength(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOFloat(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Material arg0 = (Material)LuaScriptMgr.GetUnityObject(L, 1, typeof(Material));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		string arg2 = LuaScriptMgr.GetLuaString(L, 3);
		float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOFloat(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOOffset(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			Material arg0 = (Material)LuaScriptMgr.GetUnityObject(L, 1, typeof(Material));
			Vector2 arg1 = LuaScriptMgr.GetVector2(L, 2);
			float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOOffset(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4)
		{
			Material arg0 = (Material)LuaScriptMgr.GetUnityObject(L, 1, typeof(Material));
			Vector2 arg1 = LuaScriptMgr.GetVector2(L, 2);
			string arg2 = LuaScriptMgr.GetLuaString(L, 3);
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOOffset(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOOffset");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOTiling(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			Material arg0 = (Material)LuaScriptMgr.GetUnityObject(L, 1, typeof(Material));
			Vector2 arg1 = LuaScriptMgr.GetVector2(L, 2);
			float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOTiling(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4)
		{
			Material arg0 = (Material)LuaScriptMgr.GetUnityObject(L, 1, typeof(Material));
			Vector2 arg1 = LuaScriptMgr.GetVector2(L, 2);
			string arg2 = LuaScriptMgr.GetLuaString(L, 3);
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOTiling(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOTiling");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOVector(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Material arg0 = (Material)LuaScriptMgr.GetUnityObject(L, 1, typeof(Material));
		Vector4 arg1 = LuaScriptMgr.GetVector4(L, 2);
		string arg2 = LuaScriptMgr.GetLuaString(L, 3);
		float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOVector(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOMove(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(LuaTable), typeof(float), typeof(bool)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			bool arg3 = LuaDLL.lua_toboolean(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOMove(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Rigidbody), typeof(LuaTable), typeof(float), typeof(bool)))
		{
			Rigidbody arg0 = (Rigidbody)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			bool arg3 = LuaDLL.lua_toboolean(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOMove(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOMove");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOMoveX(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(float), typeof(bool)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			bool arg3 = LuaDLL.lua_toboolean(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOMoveX(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Rigidbody), typeof(float), typeof(float), typeof(bool)))
		{
			Rigidbody arg0 = (Rigidbody)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			bool arg3 = LuaDLL.lua_toboolean(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOMoveX(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOMoveX");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOMoveY(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(float), typeof(bool)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			bool arg3 = LuaDLL.lua_toboolean(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOMoveY(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Rigidbody), typeof(float), typeof(float), typeof(bool)))
		{
			Rigidbody arg0 = (Rigidbody)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			bool arg3 = LuaDLL.lua_toboolean(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOMoveY(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOMoveY");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOMoveZ(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(float), typeof(bool)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			bool arg3 = LuaDLL.lua_toboolean(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOMoveZ(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Rigidbody), typeof(float), typeof(float), typeof(bool)))
		{
			Rigidbody arg0 = (Rigidbody)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			bool arg3 = LuaDLL.lua_toboolean(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOMoveZ(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOMoveZ");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DORotate(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(LuaTable), typeof(float), typeof(DG.Tweening.RotateMode)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.RotateMode arg3 = (DG.Tweening.RotateMode)LuaScriptMgr.GetLuaObject(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DORotate(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Rigidbody), typeof(LuaTable), typeof(float), typeof(DG.Tweening.RotateMode)))
		{
			Rigidbody arg0 = (Rigidbody)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.RotateMode arg3 = (DG.Tweening.RotateMode)LuaScriptMgr.GetLuaObject(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DORotate(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DORotate");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLookAt(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(LuaTable), typeof(float), typeof(DG.Tweening.AxisConstraint), typeof(Nullable<Vector3>)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.AxisConstraint arg3 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 4);
			Nullable<Vector3> arg4 = (Nullable<Vector3>)LuaScriptMgr.GetLuaObject(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOLookAt(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Rigidbody), typeof(LuaTable), typeof(float), typeof(DG.Tweening.AxisConstraint), typeof(Nullable<Vector3>)))
		{
			Rigidbody arg0 = (Rigidbody)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.AxisConstraint arg3 = (DG.Tweening.AxisConstraint)LuaScriptMgr.GetLuaObject(L, 4);
			Nullable<Vector3> arg4 = (Nullable<Vector3>)LuaScriptMgr.GetLuaObject(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOLookAt(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOLookAt");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOJump(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 6 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(LuaTable), typeof(float), typeof(int), typeof(float), typeof(bool)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			bool arg5 = LuaDLL.lua_toboolean(L, 6);
			DG.Tweening.Sequence o = DG.Tweening.ShortcutExtensions.DOJump(arg0,arg1,arg2,arg3,arg4,arg5);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 6 && LuaScriptMgr.CheckTypes(L, 1, typeof(Rigidbody), typeof(LuaTable), typeof(float), typeof(int), typeof(float), typeof(bool)))
		{
			Rigidbody arg0 = (Rigidbody)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			bool arg5 = LuaDLL.lua_toboolean(L, 6);
			DG.Tweening.Sequence o = DG.Tweening.ShortcutExtensions.DOJump(arg0,arg1,arg2,arg3,arg4,arg5);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOJump");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOResize(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		TrailRenderer arg0 = (TrailRenderer)LuaScriptMgr.GetUnityObject(L, 1, typeof(TrailRenderer));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOResize(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOTime(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		TrailRenderer arg0 = (TrailRenderer)LuaScriptMgr.GetUnityObject(L, 1, typeof(TrailRenderer));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOTime(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLocalMove(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		bool arg3 = LuaScriptMgr.GetBoolean(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOLocalMove(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLocalMoveX(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		bool arg3 = LuaScriptMgr.GetBoolean(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOLocalMoveX(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLocalMoveY(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		bool arg3 = LuaScriptMgr.GetBoolean(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOLocalMoveY(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLocalMoveZ(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		bool arg3 = LuaScriptMgr.GetBoolean(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOLocalMoveZ(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DORotateQuaternion(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Quaternion arg1 = LuaScriptMgr.GetQuaternion(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DORotateQuaternion(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLocalRotate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.RotateMode arg3 = (DG.Tweening.RotateMode)LuaScriptMgr.GetNetObject(L, 4, typeof(DG.Tweening.RotateMode));
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOLocalRotate(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLocalRotateQuaternion(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Quaternion arg1 = LuaScriptMgr.GetQuaternion(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOLocalRotateQuaternion(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOScale(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(float)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOScale(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(LuaTable), typeof(float)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOScale(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOScale");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOScaleX(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOScaleX(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOScaleY(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOScaleY(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOScaleZ(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOScaleZ(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPunchPosition(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 6);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
		float arg4 = (float)LuaScriptMgr.GetNumber(L, 5);
		bool arg5 = LuaScriptMgr.GetBoolean(L, 6);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOPunchPosition(arg0,arg1,arg2,arg3,arg4,arg5);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPunchScale(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 5);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
		float arg4 = (float)LuaScriptMgr.GetNumber(L, 5);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOPunchScale(arg0,arg1,arg2,arg3,arg4);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPunchRotation(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 5);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
		float arg4 = (float)LuaScriptMgr.GetNumber(L, 5);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOPunchRotation(arg0,arg1,arg2,arg3,arg4);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOShakeScale(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(LuaTable), typeof(int), typeof(float)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakeScale(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Transform), typeof(float), typeof(float), typeof(int), typeof(float)))
		{
			Transform arg0 = (Transform)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			float arg4 = (float)LuaDLL.lua_tonumber(L, 5);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOShakeScale(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOShakeScale");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLocalJump(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 6);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
		float arg4 = (float)LuaScriptMgr.GetNumber(L, 5);
		bool arg5 = LuaScriptMgr.GetBoolean(L, 6);
		DG.Tweening.Sequence o = DG.Tweening.ShortcutExtensions.DOLocalJump(arg0,arg1,arg2,arg3,arg4,arg5);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPath(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 7);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3[] objs1 = LuaScriptMgr.GetArrayObject<Vector3>(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.PathType arg3 = (DG.Tweening.PathType)LuaScriptMgr.GetNetObject(L, 4, typeof(DG.Tweening.PathType));
		DG.Tweening.PathMode arg4 = (DG.Tweening.PathMode)LuaScriptMgr.GetNetObject(L, 5, typeof(DG.Tweening.PathMode));
		int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
		Nullable<Color> arg6 = (Nullable<Color>)LuaScriptMgr.GetNetObject(L, 7, typeof(Nullable<Color>));
		DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> o = DG.Tweening.ShortcutExtensions.DOPath(arg0,objs1,arg2,arg3,arg4,arg5,arg6);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOLocalPath(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 7);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3[] objs1 = LuaScriptMgr.GetArrayObject<Vector3>(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.PathType arg3 = (DG.Tweening.PathType)LuaScriptMgr.GetNetObject(L, 4, typeof(DG.Tweening.PathType));
		DG.Tweening.PathMode arg4 = (DG.Tweening.PathMode)LuaScriptMgr.GetNetObject(L, 5, typeof(DG.Tweening.PathMode));
		int arg5 = (int)LuaScriptMgr.GetNumber(L, 6);
		Nullable<Color> arg6 = (Nullable<Color>)LuaScriptMgr.GetNetObject(L, 7, typeof(Nullable<Color>));
		DG.Tweening.Core.TweenerCore<Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> o = DG.Tweening.ShortcutExtensions.DOLocalPath(arg0,objs1,arg2,arg3,arg4,arg5,arg6);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOBlendableColor(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(LuaTable), typeof(float)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			Color arg1 = LuaScriptMgr.GetColor(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOBlendableColor(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Light), typeof(LuaTable), typeof(float)))
		{
			Light arg0 = (Light)LuaScriptMgr.GetLuaObject(L, 1);
			Color arg1 = LuaScriptMgr.GetColor(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOBlendableColor(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4)
		{
			Material arg0 = (Material)LuaScriptMgr.GetUnityObject(L, 1, typeof(Material));
			Color arg1 = LuaScriptMgr.GetColor(L, 2);
			string arg2 = LuaScriptMgr.GetLuaString(L, 3);
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOBlendableColor(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOBlendableColor");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOBlendableMoveBy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		bool arg3 = LuaScriptMgr.GetBoolean(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOBlendableMoveBy(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOBlendableLocalMoveBy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		bool arg3 = LuaScriptMgr.GetBoolean(L, 4);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOBlendableLocalMoveBy(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOBlendableRotateBy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.RotateMode arg3 = (DG.Tweening.RotateMode)LuaScriptMgr.GetNetObject(L, 4, typeof(DG.Tweening.RotateMode));
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOBlendableRotateBy(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOBlendableLocalRotateBy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.RotateMode arg3 = (DG.Tweening.RotateMode)LuaScriptMgr.GetNetObject(L, 4, typeof(DG.Tweening.RotateMode));
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOBlendableLocalRotateBy(arg0,arg1,arg2,arg3);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOBlendableScaleBy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Transform arg0 = (Transform)LuaScriptMgr.GetUnityObject(L, 1, typeof(Transform));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		DG.Tweening.Tweener o = DG.Tweening.ShortcutExtensions.DOBlendableScaleBy(arg0,arg1,arg2);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOComplete(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(bool)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			int o = DG.Tweening.ShortcutExtensions.DOComplete(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component), typeof(bool)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			int o = DG.Tweening.ShortcutExtensions.DOComplete(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOComplete");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOKill(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(bool)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			int o = DG.Tweening.ShortcutExtensions.DOKill(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component), typeof(bool)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			int o = DG.Tweening.ShortcutExtensions.DOKill(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOKill");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOFlip(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOFlip(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOFlip(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOFlip");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOGoto(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(float), typeof(bool)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			bool arg2 = LuaDLL.lua_toboolean(L, 3);
			int o = DG.Tweening.ShortcutExtensions.DOGoto(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component), typeof(float), typeof(bool)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			bool arg2 = LuaDLL.lua_toboolean(L, 3);
			int o = DG.Tweening.ShortcutExtensions.DOGoto(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOGoto");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPause(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOPause(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOPause(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOPause");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPlay(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOPlay(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOPlay(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOPlay");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPlayBackwards(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOPlayBackwards(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOPlayBackwards(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOPlayBackwards");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPlayForward(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOPlayForward(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOPlayForward(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOPlayForward");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DORestart(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(bool)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			int o = DG.Tweening.ShortcutExtensions.DORestart(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component), typeof(bool)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			int o = DG.Tweening.ShortcutExtensions.DORestart(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DORestart");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DORewind(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material), typeof(bool)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			int o = DG.Tweening.ShortcutExtensions.DORewind(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component), typeof(bool)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			int o = DG.Tweening.ShortcutExtensions.DORewind(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DORewind");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOSmoothRewind(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOSmoothRewind(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOSmoothRewind(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOSmoothRewind");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOTogglePause(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Material)))
		{
			Material arg0 = (Material)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOTogglePause(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(Component)))
		{
			Component arg0 = (Component)LuaScriptMgr.GetLuaObject(L, 1);
			int o = DG.Tweening.ShortcutExtensions.DOTogglePause(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DG.Tweening.ShortcutExtensions.DOTogglePause");
		}

		return 0;
	}
}

