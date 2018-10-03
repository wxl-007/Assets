using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class LRDDZ_MusicManagerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Awake", Awake),
			new LuaMethod("Init", Init),
			new LuaMethod("getMusicState", getMusicState),
			new LuaMethod("getEffectState", getEffectState),
			new LuaMethod("setMusicState", setMusicState),
			new LuaMethod("setEffectState", setEffectState),
			new LuaMethod("SetAudioVolume", SetAudioVolume),
			new LuaMethod("StopPlayAudio", StopPlayAudio),
			new LuaMethod("PlayMuisc", PlayMuisc),
			new LuaMethod("PlayAudio", PlayAudio),
			new LuaMethod("CheckHasAudioFile", CheckHasAudioFile),
			new LuaMethod("Play", Play),
			new LuaMethod("PlaySoundEffect", PlaySoundEffect),
			new LuaMethod("New", _CreateLRDDZ_MusicManager),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("instance", get_instance, set_instance),
			new LuaField("GetAudioSource", get_GetAudioSource, null),
		};

		LuaScriptMgr.RegisterLib(L, "LRDDZ_MusicManager", typeof(LRDDZ_MusicManager), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateLRDDZ_MusicManager(IntPtr L)
	{
		LuaDLL.luaL_error(L, "LRDDZ_MusicManager class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(LRDDZ_MusicManager);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_instance(IntPtr L)
	{
		LuaScriptMgr.Push(L, LRDDZ_MusicManager.instance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GetAudioSource(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name GetAudioSource");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index GetAudioSource on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.GetAudioSource);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_instance(IntPtr L)
	{
		LRDDZ_MusicManager.instance = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObject(L, 3, typeof(LRDDZ_MusicManager));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Awake(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		obj.Awake();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		obj.Init();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getMusicState(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		bool o = obj.getMusicState();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getEffectState(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		bool o = obj.getEffectState();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setMusicState(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.setMusicState(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setEffectState(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.setEffectState(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAudioVolume(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 2);
		obj.SetAudioVolume(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StopPlayAudio(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		obj.StopPlayAudio();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayMuisc(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 6);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
		bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
		bool arg3 = LuaScriptMgr.GetBoolean(L, 5);
		float arg4 = (float)LuaScriptMgr.GetNumber(L, 6);
		obj.PlayMuisc(arg0,arg1,arg2,arg3,arg4);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayAudio(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 7)
		{
			LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			bool arg2 = LuaScriptMgr.GetBoolean(L, 4);
			bool arg3 = LuaScriptMgr.GetBoolean(L, 5);
			bool arg4 = LuaScriptMgr.GetBoolean(L, 6);
			float arg5 = (float)LuaScriptMgr.GetNumber(L, 7);
			AudioClip o = obj.PlayAudio(arg0,arg1,arg2,arg3,arg4,arg5);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 8)
		{
			LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
			GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			string arg2 = LuaScriptMgr.GetLuaString(L, 4);
			bool arg3 = LuaScriptMgr.GetBoolean(L, 5);
			bool arg4 = LuaScriptMgr.GetBoolean(L, 6);
			bool arg5 = LuaScriptMgr.GetBoolean(L, 7);
			float arg6 = (float)LuaScriptMgr.GetNumber(L, 8);
			AudioClip o = obj.PlayAudio(arg0,arg1,arg2,arg3,arg4,arg5,arg6);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: LRDDZ_MusicManager.PlayAudio");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckHasAudioFile(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		string arg1 = LuaScriptMgr.GetLuaString(L, 3);
		bool o = obj.CheckHasAudioFile(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Play(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
		AudioClip arg0 = (AudioClip)LuaScriptMgr.GetUnityObject(L, 2, typeof(AudioClip));
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 3);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 4);
		obj.Play(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlaySoundEffect(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			obj.PlaySoundEffect(arg0,arg1);
			return 0;
		}
		else if (count == 4)
		{
			LRDDZ_MusicManager obj = (LRDDZ_MusicManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "LRDDZ_MusicManager");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			string arg1 = LuaScriptMgr.GetLuaString(L, 3);
			float arg2 = (float)LuaScriptMgr.GetNumber(L, 4);
			obj.PlaySoundEffect(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: LRDDZ_MusicManager.PlaySoundEffect");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_Eq(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Object arg0 = LuaScriptMgr.GetLuaObject(L, 1) as Object;
		Object arg1 = LuaScriptMgr.GetLuaObject(L, 2) as Object;
		bool o = arg0 == arg1;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

