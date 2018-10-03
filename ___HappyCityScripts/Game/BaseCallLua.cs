using UnityEngine;
using System.Collections;
using LuaInterface;
using SimpleFramework;
using SimpleFramework.Manager;


public static class BaseCallLua  {

    public static string GetMessage(string pString,int pDefaultIndex = 1) {
        LuaScriptMgr luaMgr = AppFacade.Instance.GetManager<LuaScriptMgr>(ManagerName.Lua);
        if (luaMgr == null) return null;

        LuaState tLS = luaMgr.lua;
        tLS.LoadFile("/Common/functions.lua");
        
        LuaFunction tMsg = tLS.GetFunction("GetMessage");
        object[] r = tMsg.Call(pString);
        bool tIsTable = r[0] is LuaTable;
        if (tIsTable)
        {
            LuaTable tList = r[0] as LuaTable;
            if (tList[pDefaultIndex] != null)
            {
                return tList[pDefaultIndex].ToString();
            }
            else return null;
        }
        else {
            return r[0].ToString();
        }
    }
  
    public static string[] GetMessageList(string pKey) {
        LuaScriptMgr luaMgr = AppFacade.Instance.GetManager<LuaScriptMgr>(ManagerName.Lua);
        if (luaMgr == null) return null;

        LuaState tLS = luaMgr.lua;
        tLS.LoadFile("/Common/functions.lua");

        LuaFunction tMsg = tLS.GetFunction("GetMessage");
        object[] r = tMsg.Call(pKey);
        bool tIsTable = r[0] is LuaTable;
        if (tIsTable) {
            LuaTable tTable =r[0] as LuaTable;
            string[] tResult= tTable.ToArray<string>();
            return tResult;
        }
       
        return null;
    }

    public static string GetLoacalizationMsg(string pKey,int pType)
    {
        LuaScriptMgr luaMgr = AppFacade.Instance.GetManager<LuaScriptMgr>(ManagerName.Lua);
        if (luaMgr == null) return null;

        LuaState tLS = luaMgr.lua;
        tLS.LoadFile("/Common/functions.lua");
        LuaFunction tMsg = tLS.GetFunction("GetLocalization");
        object[] r = tMsg.Call(pKey, pType);
        string tResult = r[0].ToString();
        return tResult;
    }








}
