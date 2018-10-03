using UnityEngine;
using System.Collections;
using System.Xml;
using SimpleFramework;
using LuaInterface;
public class ZPLocalization {
	
	public enum ZPLanguage {En = 1, Zh_Hans};
	
	private static ZPLocalization _instance;
	public static ZPLocalization Instance {
		get {
			if(_instance == null) {
				_instance = new ZPLocalization();
			}
			return _instance;
		}
	}
	
	private ZPLanguage language;
	private XmlDocument localizableDocument = null;
	
	private ZPLocalization () {
		localizableDocument = new XmlDocument();
		this.Language = GetSystemLanguage();
	}
	
	private ZPLanguage GetSystemLanguage () {
		// shawn.debug Get system localizable
		return ZPLanguage.Zh_Hans;
	}
	
	public ZPLanguage Language {
		get {
			return language;
		}
		set {
			if (value == language) { return; }
		
			language = value;
			string filePath = "";
			switch (language) {
			case ZPLanguage.Zh_Hans:
				filePath = "Zh_Hans";
				break;
			default:
				filePath = "En";
				break;
			}
			
	    	TextAsset XMLFile = (TextAsset)Resources.Load(filePath);
	    	localizableDocument.LoadXml(XMLFile.text);
		}
	}

	public string Get (string key) {
        string nodeValue = "";
		XmlNode node = localizableDocument.SelectSingleNode("Root").SelectSingleNode(key);
		if (node != null) {
			nodeValue = node.InnerText;
		}
		return nodeValue;

      //  return BaseCallLua.GetLoacalizationMsg(key, (int)language);
     //    LuaScriptMgr luaMgr = AppFacade.Instance.GetManager<LuaScriptMgr>(ManagerName.Lua);
      //  if (luaMgr == null) return null;

      //  LuaState tLS = luaMgr.lua;
       // tLS.LoadFile("/Common/ZPLocalization.lua");
       // object[] tObjList = Util.CallMethod("ZPLocalization", "GetC", key,(int)Language);
       // Debug.Log(tObjList[0].ToString());

        //return tObjList[0].ToString();
       
	}
}
