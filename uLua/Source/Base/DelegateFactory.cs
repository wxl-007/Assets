using System;
using UnityEngine;
using System.Collections.Generic;
using LuaInterface;
using Object = UnityEngine.Object;

public static class DelegateFactory
{
	delegate Delegate DelegateValue(LuaFunction func);
	static Dictionary<Type, DelegateValue> dict = new Dictionary<Type, DelegateValue>();

	[NoToLuaAttribute]
	public static void Register(IntPtr L)
	{
		dict.Add(typeof(Action<GameObject>), new DelegateValue(Action_GameObject));
		dict.Add(typeof(Action), new DelegateValue(Action));
		dict.Add(typeof(UnityEngine.Events.UnityAction), new DelegateValue(UnityEngine_Events_UnityAction));
		dict.Add(typeof(System.Reflection.MemberFilter), new DelegateValue(System_Reflection_MemberFilter));
		dict.Add(typeof(System.Reflection.TypeFilter), new DelegateValue(System_Reflection_TypeFilter));
		dict.Add(typeof(System.Text.RegularExpressions.MatchEvaluator), new DelegateValue(System_Text_RegularExpressions_MatchEvaluator));
		dict.Add(typeof(UIEventListener.VoidDelegate), new DelegateValue(UIEventListener_VoidDelegate));
		dict.Add(typeof(UIEventListener.BoolDelegate), new DelegateValue(UIEventListener_BoolDelegate));
		dict.Add(typeof(UIEventListener.FloatDelegate), new DelegateValue(UIEventListener_FloatDelegate));
		dict.Add(typeof(UIEventListener.VectorDelegate), new DelegateValue(UIEventListener_VectorDelegate));
		dict.Add(typeof(UIEventListener.ObjectDelegate), new DelegateValue(UIEventListener_ObjectDelegate));
		dict.Add(typeof(UIEventListener.KeyCodeDelegate), new DelegateValue(UIEventListener_KeyCodeDelegate));
		dict.Add(typeof(UIPanel.OnGeometryUpdated), new DelegateValue(UIPanel_OnGeometryUpdated));
		dict.Add(typeof(UIPanel.OnClippingMoved), new DelegateValue(UIPanel_OnClippingMoved));
		dict.Add(typeof(UIWidget.OnDimensionsChanged), new DelegateValue(UIWidget_OnDimensionsChanged));
		dict.Add(typeof(UIWidget.OnPostFillCallback), new DelegateValue(UIWidget_OnPostFillCallback));
		dict.Add(typeof(UIDrawCall.OnRenderCallback), new DelegateValue(UIDrawCall_OnRenderCallback));
		dict.Add(typeof(UIWidget.HitCheck), new DelegateValue(UIWidget_HitCheck));
		dict.Add(typeof(UIGrid.OnReposition), new DelegateValue(UIGrid_OnReposition));
		dict.Add(typeof(Comparison<Transform>), new DelegateValue(Comparison_Transform));
		dict.Add(typeof(TestLuaDelegate.VoidDelegate), new DelegateValue(TestLuaDelegate_VoidDelegate));
		dict.Add(typeof(EventDelegate.Callback), new DelegateValue(EventDelegate_Callback));
		dict.Add(typeof(Camera.CameraCallback), new DelegateValue(Camera_CameraCallback));
		dict.Add(typeof(AudioClip.PCMReaderCallback), new DelegateValue(AudioClip_PCMReaderCallback));
		dict.Add(typeof(AudioClip.PCMSetPositionCallback), new DelegateValue(AudioClip_PCMSetPositionCallback));
		dict.Add(typeof(Application.LogCallback), new DelegateValue(Application_LogCallback));
		dict.Add(typeof(Application.AdvertisingIdentifierCallback), new DelegateValue(Application_AdvertisingIdentifierCallback));
		dict.Add(typeof(Action<string>), new DelegateValue(Action_string));
		dict.Add(typeof(Action<string,bool>), new DelegateValue(Action_string_bool));
		dict.Add(typeof(Action<JSONObject,string>), new DelegateValue(Action_JSONObject_string));
		dict.Add(typeof(Func<bool,string,bool,bool>), new DelegateValue(Func_bool_string_bool_bool));
		dict.Add(typeof(Action<int,List<string>>), new DelegateValue(Action_int_List_string));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<float>), new DelegateValue(DOGetter_float));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<float>), new DelegateValue(DOSetter_float));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<double>), new DelegateValue(DOGetter_double));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<double>), new DelegateValue(DOSetter_double));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<int>), new DelegateValue(DOGetter_int));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<int>), new DelegateValue(DOSetter_int));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<uint>), new DelegateValue(DOGetter_uint));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<uint>), new DelegateValue(DOSetter_uint));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<long>), new DelegateValue(DOGetter_long));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<long>), new DelegateValue(DOSetter_long));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<ulong>), new DelegateValue(DOGetter_ulong));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<ulong>), new DelegateValue(DOSetter_ulong));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<string>), new DelegateValue(DOGetter_string));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<string>), new DelegateValue(DOSetter_string));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<Vector2>), new DelegateValue(DOGetter_Vector2));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<Vector2>), new DelegateValue(DOSetter_Vector2));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<Vector3>), new DelegateValue(DOGetter_Vector3));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<Vector3>), new DelegateValue(DOSetter_Vector3));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<Vector4>), new DelegateValue(DOGetter_Vector4));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<Vector4>), new DelegateValue(DOSetter_Vector4));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<Quaternion>), new DelegateValue(DOGetter_Quaternion));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<Quaternion>), new DelegateValue(DOSetter_Quaternion));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<Color>), new DelegateValue(DOGetter_Color));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<Color>), new DelegateValue(DOSetter_Color));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<Rect>), new DelegateValue(DOGetter_Rect));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<Rect>), new DelegateValue(DOSetter_Rect));
		dict.Add(typeof(DG.Tweening.Core.DOGetter<RectOffset>), new DelegateValue(DOGetter_RectOffset));
		dict.Add(typeof(DG.Tweening.Core.DOSetter<RectOffset>), new DelegateValue(DOSetter_RectOffset));
		dict.Add(typeof(DG.Tweening.TweenCallback), new DelegateValue(DG_Tweening_TweenCallback));
		dict.Add(typeof(UIScrollView.OnDragNotification), new DelegateValue(UIScrollView_OnDragNotification));
		dict.Add(typeof(UIInput.OnValidate), new DelegateValue(UIInput_OnValidate));
		dict.Add(typeof(UIPopupList.LegacyEvent), new DelegateValue(UIPopupList_LegacyEvent));
		dict.Add(typeof(UIToggle.Validate), new DelegateValue(UIToggle_Validate));
		dict.Add(typeof(Action<Object>), new DelegateValue(Action_Object));
		dict.Add(typeof(UICamera.GetKeyStateFunc), new DelegateValue(UICamera_GetKeyStateFunc));
		dict.Add(typeof(UICamera.GetAxisFunc), new DelegateValue(UICamera_GetAxisFunc));
		dict.Add(typeof(UICamera.OnScreenResize), new DelegateValue(UICamera_OnScreenResize));
		dict.Add(typeof(UICamera.OnCustomInput), new DelegateValue(UICamera_OnCustomInput));
		dict.Add(typeof(UICamera.VoidDelegate), new DelegateValue(UICamera_VoidDelegate));
		dict.Add(typeof(UICamera.BoolDelegate), new DelegateValue(UICamera_BoolDelegate));
		dict.Add(typeof(UICamera.FloatDelegate), new DelegateValue(UICamera_FloatDelegate));
		dict.Add(typeof(UICamera.VectorDelegate), new DelegateValue(UICamera_VectorDelegate));
		dict.Add(typeof(UICamera.ObjectDelegate), new DelegateValue(UICamera_ObjectDelegate));
		dict.Add(typeof(UICamera.KeyCodeDelegate), new DelegateValue(UICamera_KeyCodeDelegate));
		dict.Add(typeof(UICamera.MoveDelegate), new DelegateValue(UICamera_MoveDelegate));
		dict.Add(typeof(UICamera.GetTouchCountCallback), new DelegateValue(UICamera_GetTouchCountCallback));
		dict.Add(typeof(UICamera.GetTouchCallback), new DelegateValue(UICamera_GetTouchCallback));
		dict.Add(typeof(SpringPanel.OnFinished), new DelegateValue(SpringPanel_OnFinished));
		dict.Add(typeof(UICenterOnChild.OnCenterCallback), new DelegateValue(UICenterOnChild_OnCenterCallback));
		dict.Add(typeof(Action<JSONObject,JSONObject,string>), new DelegateValue(Action_JSONObject_JSONObject_string));
		dict.Add(typeof(Action<string,long,long>), new DelegateValue(Action_string_long_long));
		dict.Add(typeof(Action<string,JSONObject>), new DelegateValue(Action_string_JSONObject));
		dict.Add(typeof(Action<int>), new DelegateValue(Action_int));
		dict.Add(typeof(Action<JSONObject>), new DelegateValue(Action_JSONObject));
	}

	[NoToLuaAttribute]
	public static Delegate CreateDelegate(Type t, LuaFunction func)
	{
		DelegateValue create = null;

		if (!dict.TryGetValue(t, out create))
		{
			Debugger.LogError("Delegate {0} not register", t.FullName);
			return null;
		}
		return create(func);
	}

	public static Delegate Action_GameObject(LuaFunction func)
	{
		Action<GameObject> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action(LuaFunction func)
	{
		Action d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate UnityEngine_Events_UnityAction(LuaFunction func)
	{
		UnityEngine.Events.UnityAction d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate System_Reflection_MemberFilter(LuaFunction func)
	{
		System.Reflection.MemberFilter d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.PushObject(L, param0);
			LuaScriptMgr.PushVarObject(L, param1);
			func.PCall(top, 2);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (bool)objs[0];
		};
		return d;
	}

	public static Delegate System_Reflection_TypeFilter(LuaFunction func)
	{
		System.Reflection.TypeFilter d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.PushVarObject(L, param1);
			func.PCall(top, 2);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (bool)objs[0];
		};
		return d;
	}

	public static Delegate System_Text_RegularExpressions_MatchEvaluator(LuaFunction func)
	{
		System.Text.RegularExpressions.MatchEvaluator d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.PushObject(L, param0);
			func.PCall(top, 1);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (string)objs[0];
		};
		return d;
	}

	public static Delegate UIEventListener_VoidDelegate(LuaFunction func)
	{
		UIEventListener.VoidDelegate d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIEventListener_BoolDelegate(LuaFunction func)
	{
		UIEventListener.BoolDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIEventListener_FloatDelegate(LuaFunction func)
	{
		UIEventListener.FloatDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIEventListener_VectorDelegate(LuaFunction func)
	{
		UIEventListener.VectorDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIEventListener_ObjectDelegate(LuaFunction func)
	{
		UIEventListener.ObjectDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIEventListener_KeyCodeDelegate(LuaFunction func)
	{
		UIEventListener.KeyCodeDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIPanel_OnGeometryUpdated(LuaFunction func)
	{
		UIPanel.OnGeometryUpdated d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate UIPanel_OnClippingMoved(LuaFunction func)
	{
		UIPanel.OnClippingMoved d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIWidget_OnDimensionsChanged(LuaFunction func)
	{
		UIWidget.OnDimensionsChanged d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate UIWidget_OnPostFillCallback(LuaFunction func)
	{
		UIWidget.OnPostFillCallback d = (param0, param1, param2, param3, param4) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			LuaScriptMgr.PushObject(L, param2);
			LuaScriptMgr.PushObject(L, param3);
			LuaScriptMgr.PushObject(L, param4);
			func.PCall(top, 5);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIDrawCall_OnRenderCallback(LuaFunction func)
	{
		UIDrawCall.OnRenderCallback d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIWidget_HitCheck(LuaFunction func)
	{
		UIWidget.HitCheck d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (bool)objs[0];
		};
		return d;
	}

	public static Delegate UIGrid_OnReposition(LuaFunction func)
	{
		UIGrid.OnReposition d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate Comparison_Transform(LuaFunction func)
	{
		Comparison<Transform> d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (int)objs[0];
		};
		return d;
	}

	public static Delegate TestLuaDelegate_VoidDelegate(LuaFunction func)
	{
		TestLuaDelegate.VoidDelegate d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate EventDelegate_Callback(LuaFunction func)
	{
		EventDelegate.Callback d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate Camera_CameraCallback(LuaFunction func)
	{
		Camera.CameraCallback d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate AudioClip_PCMReaderCallback(LuaFunction func)
	{
		AudioClip.PCMReaderCallback d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.PushArray(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate AudioClip_PCMSetPositionCallback(LuaFunction func)
	{
		AudioClip.PCMSetPositionCallback d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Application_LogCallback(LuaFunction func)
	{
		Application.LogCallback d = (param0, param1, param2) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			LuaScriptMgr.Push(L, param2);
			func.PCall(top, 3);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Application_AdvertisingIdentifierCallback(LuaFunction func)
	{
		Application.AdvertisingIdentifierCallback d = (param0, param1, param2) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			LuaScriptMgr.Push(L, param2);
			func.PCall(top, 3);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action_string(LuaFunction func)
	{
		Action<string> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action_string_bool(LuaFunction func)
	{
		Action<string,bool> d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action_JSONObject_string(LuaFunction func)
	{
		Action<JSONObject,string> d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.PushObject(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Func_bool_string_bool_bool(LuaFunction func)
	{
		Func<bool,string,bool,bool> d = (param0, param1, param2) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			LuaScriptMgr.Push(L, param2);
			func.PCall(top, 3);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (bool)objs[0];
		};
		return d;
	}

	public static Delegate Action_int_List_string(LuaFunction func)
	{
		Action<int,List<string>> d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.PushObject(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_float(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<float> d = () =>
		{
			object[] objs = func.Call();
			return (float)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_float(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<float> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_double(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<double> d = () =>
		{
			object[] objs = func.Call();
			return (double)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_double(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<double> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_int(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<int> d = () =>
		{
			object[] objs = func.Call();
			return (int)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_int(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<int> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_uint(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<uint> d = () =>
		{
			object[] objs = func.Call();
			return (uint)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_uint(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<uint> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_long(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<long> d = () =>
		{
			object[] objs = func.Call();
			return (long)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_long(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<long> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_ulong(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<ulong> d = () =>
		{
			object[] objs = func.Call();
			return (ulong)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_ulong(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<ulong> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_string(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<string> d = () =>
		{
			object[] objs = func.Call();
			return (string)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_string(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<string> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_Vector2(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<Vector2> d = () =>
		{
			object[] objs = func.Call();
			return (Vector2)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_Vector2(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<Vector2> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_Vector3(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<Vector3> d = () =>
		{
			object[] objs = func.Call();
			return (Vector3)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_Vector3(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<Vector3> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_Vector4(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<Vector4> d = () =>
		{
			object[] objs = func.Call();
			return (Vector4)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_Vector4(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<Vector4> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_Quaternion(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<Quaternion> d = () =>
		{
			object[] objs = func.Call();
			return (Quaternion)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_Quaternion(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<Quaternion> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_Color(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<Color> d = () =>
		{
			object[] objs = func.Call();
			return (Color)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_Color(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<Color> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_Rect(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<Rect> d = () =>
		{
			object[] objs = func.Call();
			return (Rect)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_Rect(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<Rect> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.PushValue(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DOGetter_RectOffset(LuaFunction func)
	{
		DG.Tweening.Core.DOGetter<RectOffset> d = () =>
		{
			object[] objs = func.Call();
			return (RectOffset)objs[0];
		};
		return d;
	}

	public static Delegate DOSetter_RectOffset(LuaFunction func)
	{
		DG.Tweening.Core.DOSetter<RectOffset> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.PushObject(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate DG_Tweening_TweenCallback(LuaFunction func)
	{
		DG.Tweening.TweenCallback d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate UIScrollView_OnDragNotification(LuaFunction func)
	{
		UIScrollView.OnDragNotification d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate UIInput_OnValidate(LuaFunction func)
	{
		UIInput.OnValidate d = (param0, param1, param2) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			LuaScriptMgr.Push(L, param2);
			func.PCall(top, 3);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (char)objs[0];
		};
		return d;
	}

	public static Delegate UIPopupList_LegacyEvent(LuaFunction func)
	{
		UIPopupList.LegacyEvent d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UIToggle_Validate(LuaFunction func)
	{
		UIToggle.Validate d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (bool)objs[0];
		};
		return d;
	}

	public static Delegate Action_Object(LuaFunction func)
	{
		Action<Object> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UICamera_GetKeyStateFunc(LuaFunction func)
	{
		UICamera.GetKeyStateFunc d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (bool)objs[0];
		};
		return d;
	}

	public static Delegate UICamera_GetAxisFunc(LuaFunction func)
	{
		UICamera.GetAxisFunc d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (float)objs[0];
		};
		return d;
	}

	public static Delegate UICamera_OnScreenResize(LuaFunction func)
	{
		UICamera.OnScreenResize d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate UICamera_OnCustomInput(LuaFunction func)
	{
		UICamera.OnCustomInput d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate UICamera_VoidDelegate(LuaFunction func)
	{
		UICamera.VoidDelegate d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UICamera_BoolDelegate(LuaFunction func)
	{
		UICamera.BoolDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UICamera_FloatDelegate(LuaFunction func)
	{
		UICamera.FloatDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UICamera_VectorDelegate(LuaFunction func)
	{
		UICamera.VectorDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UICamera_ObjectDelegate(LuaFunction func)
	{
		UICamera.ObjectDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UICamera_KeyCodeDelegate(LuaFunction func)
	{
		UICamera.KeyCodeDelegate d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UICamera_MoveDelegate(LuaFunction func)
	{
		UICamera.MoveDelegate d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate UICamera_GetTouchCountCallback(LuaFunction func)
	{
		UICamera.GetTouchCountCallback d = () =>
		{
			object[] objs = func.Call();
			return (int)objs[0];
		};
		return d;
	}

	public static Delegate UICamera_GetTouchCallback(LuaFunction func)
	{
		UICamera.GetTouchCallback d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			object[] objs = func.PopValues(top);
			func.EndPCall(top);
			return (UICamera.Touch)objs[0];
		};
		return d;
	}

	public static Delegate SpringPanel_OnFinished(LuaFunction func)
	{
		SpringPanel.OnFinished d = () =>
		{
			func.Call();
		};
		return d;
	}

	public static Delegate UICenterOnChild_OnCenterCallback(LuaFunction func)
	{
		UICenterOnChild.OnCenterCallback d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action_JSONObject_JSONObject_string(LuaFunction func)
	{
		Action<JSONObject,JSONObject,string> d = (param0, param1, param2) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.PushObject(L, param0);
			LuaScriptMgr.PushObject(L, param1);
			LuaScriptMgr.Push(L, param2);
			func.PCall(top, 3);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action_string_long_long(LuaFunction func)
	{
		Action<string,long,long> d = (param0, param1, param2) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.Push(L, param1);
			LuaScriptMgr.Push(L, param2);
			func.PCall(top, 3);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action_string_JSONObject(LuaFunction func)
	{
		Action<string,JSONObject> d = (param0, param1) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			LuaScriptMgr.PushObject(L, param1);
			func.PCall(top, 2);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action_int(LuaFunction func)
	{
		Action<int> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.Push(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static Delegate Action_JSONObject(LuaFunction func)
	{
		Action<JSONObject> d = (param0) =>
		{
			int top = func.BeginPCall();
			IntPtr L = func.GetLuaState();
			LuaScriptMgr.PushObject(L, param0);
			func.PCall(top, 1);
			func.EndPCall(top);
		};
		return d;
	}

	public static void Clear()
	{
		dict.Clear();
	}

}
