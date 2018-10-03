using System;
using UnityEngine;
using System.Collections.Generic;
using LuaInterface;
using Object = UnityEngine.Object;

public class UIPopupListWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Clear", Clear),
			new LuaMethod("AddItem", AddItem),
			new LuaMethod("RemoveItem", RemoveItem),
			new LuaMethod("RemoveItemByData", RemoveItemByData),
			new LuaMethod("Close", Close),
			new LuaMethod("Show", Show),
			new LuaMethod("New", _CreateUIPopupList),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("current", get_current, set_current),
			new LuaField("atlas", get_atlas, set_atlas),
			new LuaField("bitmapFont", get_bitmapFont, set_bitmapFont),
			new LuaField("trueTypeFont", get_trueTypeFont, set_trueTypeFont),
			new LuaField("fontSize", get_fontSize, set_fontSize),
			new LuaField("fontStyle", get_fontStyle, set_fontStyle),
			new LuaField("backgroundSprite", get_backgroundSprite, set_backgroundSprite),
			new LuaField("highlightSprite", get_highlightSprite, set_highlightSprite),
			new LuaField("position", get_position, set_position),
			new LuaField("alignment", get_alignment, set_alignment),
			new LuaField("items", get_items, set_items),
			new LuaField("itemData", get_itemData, set_itemData),
			new LuaField("padding", get_padding, set_padding),
			new LuaField("textColor", get_textColor, set_textColor),
			new LuaField("textHighlightColor", get_textHighlightColor, set_textHighlightColor),
			new LuaField("backgroundColor", get_backgroundColor, set_backgroundColor),
			new LuaField("highlightColor", get_highlightColor, set_highlightColor),
			new LuaField("isAnimated", get_isAnimated, set_isAnimated),
			new LuaField("isLocalized", get_isLocalized, set_isLocalized),
			new LuaField("openOn", get_openOn, set_openOn),
			new LuaField("onChange", get_onChange, set_onChange),
			new LuaField("ambigiousFont", get_ambigiousFont, set_ambigiousFont),
			new LuaField("isOpen", get_isOpen, null),
			new LuaField("value", get_value, set_value),
			new LuaField("data", get_data, null),
		};

		LuaScriptMgr.RegisterLib(L, "UIPopupList", typeof(UIPopupList), regs, fields, typeof(UIWidgetContainer));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUIPopupList(IntPtr L)
	{
		LuaDLL.luaL_error(L, "UIPopupList class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(UIPopupList);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_current(IntPtr L)
	{
		LuaScriptMgr.Push(L, UIPopupList.current);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_atlas(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name atlas");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index atlas on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.atlas);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_bitmapFont(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name bitmapFont");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index bitmapFont on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.bitmapFont);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_trueTypeFont(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name trueTypeFont");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index trueTypeFont on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.trueTypeFont);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fontSize(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fontSize");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fontSize on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.fontSize);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fontStyle(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fontStyle");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fontStyle on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.fontStyle);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_backgroundSprite(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name backgroundSprite");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index backgroundSprite on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.backgroundSprite);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_highlightSprite(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name highlightSprite");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index highlightSprite on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.highlightSprite);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_position(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name position");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index position on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.position);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_alignment(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name alignment");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index alignment on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.alignment);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_items(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name items");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index items on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.items);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_itemData(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name itemData");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index itemData on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.itemData);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_padding(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name padding");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index padding on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.padding);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_textColor(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name textColor");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index textColor on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.textColor);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_textHighlightColor(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name textHighlightColor");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index textHighlightColor on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.textHighlightColor);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_backgroundColor(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name backgroundColor");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index backgroundColor on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.backgroundColor);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_highlightColor(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name highlightColor");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index highlightColor on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.highlightColor);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isAnimated(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isAnimated");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isAnimated on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isAnimated);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isLocalized(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isLocalized");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isLocalized on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isLocalized);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_openOn(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name openOn");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index openOn on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.openOn);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onChange(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name onChange");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index onChange on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.onChange);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ambigiousFont(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name ambigiousFont");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index ambigiousFont on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.ambigiousFont);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isOpen(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isOpen");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isOpen on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isOpen);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_value(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name value");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index value on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.value);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_data(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name data");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index data on a nil value");
			}
		}

		LuaScriptMgr.PushVarObject(L, obj.data);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_current(IntPtr L)
	{
		UIPopupList.current = (UIPopupList)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIPopupList));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_atlas(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name atlas");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index atlas on a nil value");
			}
		}

		obj.atlas = (UIAtlas)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIAtlas));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_bitmapFont(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name bitmapFont");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index bitmapFont on a nil value");
			}
		}

		obj.bitmapFont = (UIFont)LuaScriptMgr.GetUnityObject(L, 3, typeof(UIFont));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_trueTypeFont(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name trueTypeFont");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index trueTypeFont on a nil value");
			}
		}

		obj.trueTypeFont = (Font)LuaScriptMgr.GetUnityObject(L, 3, typeof(Font));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fontSize(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fontSize");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fontSize on a nil value");
			}
		}

		obj.fontSize = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fontStyle(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name fontStyle");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index fontStyle on a nil value");
			}
		}

		obj.fontStyle = (FontStyle)LuaScriptMgr.GetNetObject(L, 3, typeof(FontStyle));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_backgroundSprite(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name backgroundSprite");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index backgroundSprite on a nil value");
			}
		}

		obj.backgroundSprite = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_highlightSprite(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name highlightSprite");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index highlightSprite on a nil value");
			}
		}

		obj.highlightSprite = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_position(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name position");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index position on a nil value");
			}
		}

		obj.position = (UIPopupList.Position)LuaScriptMgr.GetNetObject(L, 3, typeof(UIPopupList.Position));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_alignment(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name alignment");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index alignment on a nil value");
			}
		}

		obj.alignment = (NGUIText.Alignment)LuaScriptMgr.GetNetObject(L, 3, typeof(NGUIText.Alignment));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_items(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name items");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index items on a nil value");
			}
		}

		obj.items = (List<string>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<string>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_itemData(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name itemData");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index itemData on a nil value");
			}
		}

		obj.itemData = (List<object>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<object>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_padding(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name padding");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index padding on a nil value");
			}
		}

		obj.padding = LuaScriptMgr.GetVector2(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_textColor(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name textColor");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index textColor on a nil value");
			}
		}

		obj.textColor = LuaScriptMgr.GetColor(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_textHighlightColor(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name textHighlightColor");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index textHighlightColor on a nil value");
			}
		}

		obj.textHighlightColor = LuaScriptMgr.GetColor(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_backgroundColor(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name backgroundColor");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index backgroundColor on a nil value");
			}
		}

		obj.backgroundColor = LuaScriptMgr.GetColor(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_highlightColor(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name highlightColor");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index highlightColor on a nil value");
			}
		}

		obj.highlightColor = LuaScriptMgr.GetColor(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isAnimated(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isAnimated");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isAnimated on a nil value");
			}
		}

		obj.isAnimated = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isLocalized(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isLocalized");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isLocalized on a nil value");
			}
		}

		obj.isLocalized = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_openOn(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name openOn");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index openOn on a nil value");
			}
		}

		obj.openOn = (UIPopupList.OpenOn)LuaScriptMgr.GetNetObject(L, 3, typeof(UIPopupList.OpenOn));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onChange(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name onChange");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index onChange on a nil value");
			}
		}

		obj.onChange = (List<EventDelegate>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<EventDelegate>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ambigiousFont(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name ambigiousFont");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index ambigiousFont on a nil value");
			}
		}

		obj.ambigiousFont = (Object)LuaScriptMgr.GetUnityObject(L, 3, typeof(Object));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_value(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIPopupList obj = (UIPopupList)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name value");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index value on a nil value");
			}
		}

		obj.value = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clear(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UIPopupList obj = (UIPopupList)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIPopupList");
		obj.Clear();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddItem(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			UIPopupList obj = (UIPopupList)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIPopupList");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			obj.AddItem(arg0);
			return 0;
		}
		else if (count == 3)
		{
			UIPopupList obj = (UIPopupList)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIPopupList");
			string arg0 = LuaScriptMgr.GetLuaString(L, 2);
			object arg1 = LuaScriptMgr.GetVarObject(L, 3);
			obj.AddItem(arg0,arg1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UIPopupList.AddItem");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveItem(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UIPopupList obj = (UIPopupList)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIPopupList");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.RemoveItem(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveItemByData(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UIPopupList obj = (UIPopupList)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIPopupList");
		object arg0 = LuaScriptMgr.GetVarObject(L, 2);
		obj.RemoveItemByData(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Close(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UIPopupList obj = (UIPopupList)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIPopupList");
		obj.Close();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Show(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UIPopupList obj = (UIPopupList)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIPopupList");
		obj.Show();
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

