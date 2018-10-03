using UnityEngine;
using System.Collections;
using LuaInterface;
using SimpleFramework;

public class GameLua : Game
{
    public void StartGameSocket()
    {
        base.StartGameSocket();
    }
    /* ------ Button Click ------ */
    public override void OnClickBack()
    {
        base.OnClickBack();
    }
    /* ------ Socket Sender ------ */
    public void SendPackage(string message)
    {
        Debug.Log(">>>>>>>>>>>>>>>>>>>>>" + message);
        base.SendPackage(message);
    }
    public void SendPackageWithJson(JSONObject userQuit)
    {
        base.SendPackageWithJson(userQuit);
    }

    /* ------ Socket Listener ------ */
    public override void SocketReady()
    {
        base.SocketReady();
        CallMethod("SocketReady");
    }
    public override void SocketReceiveMessage(string message)
    {
        base.SocketReceiveMessage(message);
        CallMethod("SocketReceiveMessage", message);
    }
    public override void SocketDisconnect(string disconnectInfo)
    {
        base.SocketDisconnect(disconnectInfo);
        CallMethod("SocketDisconnect", disconnectInfo);
    }

    /* ------ Socket Process ------ */
    public override void ProcessAccountFailed(string errorInfo)
    {
        base.ProcessAccountFailed(errorInfo);
        CallMethod("ProcessAccountFailed", errorInfo);
    }

    public override void ProcessAccountSucess(JSONObject messageObj)
    {
        base.ProcessAccountSucess(messageObj);
        CallMethod("ProcessAccountSucess", messageObj);
    }

    public override void ProcessUpdateIntomoney(JSONObject messageObj)
    {
        base.ProcessUpdateIntomoney(messageObj);
        //Debug.Log(messageObj.ToString());
        CallMethod("ProcessUpdateIntomoney", messageObj.ToString());
    }

    /* ------ Other ------ */
    public override void ShowPromptHUD(string errorInfo)
    {
        base.ShowPromptHUD(errorInfo);
        CallMethod("ShowPromptHUD", errorInfo);
    }


	

    /// <summary>
    /// 加载Lua文件
    /// </summary>
    public object[] DoFile(string fileName)
    {
        if (LuaManager != null)
        {
            return LuaManager.DoFile(fileName);
        }
        return null;
        
    }
    /// <summary>
    /// 获取Lua变量
    /// </summary>
    public object GetLuaObj(string variable)
    {
        if (LuaManager != null)
        {
            LuaState l = LuaManager.lua;
            string variableName = name + "." + variable;
            return l[variableName];
        }
        return null;
    }
    /// <summary>
    /// 给Lua变量赋值
    /// </summary>
    public void setLuaObj(string variable, object obj)
    {
        if (LuaManager != null)
        {
            LuaState l = LuaManager.lua;
            string variableName = name + "." + variable;
            l[variableName] = obj;
        }
    }

    //dingkun:2016.4.29
    private Hashtable m_luaFunction = new Hashtable();
    private Hashtable m_luaObj = new Hashtable();
    private Hashtable m_luaTables = new Hashtable();
    /// <summary>
    /// 包装Lua中使用iTween的Hashtable回调数据
    /// </summary>
    /// onstart Lua函数
    /// onstarttarget Lua函数所在的对象
    /// onstartparams 回调的数据
    /// oncomplete Lua函数
    /// oncompletetarget Lua函数所在的对象
    /// oncompleteparams 回调的数据
    /// <param name="_hash">Lua传来数据</param>
    /// <returns>包装好的数据</returns>
    public Hashtable iTweenHashLua(params object[] args)
    {
        Hashtable _hash = iTween.Hash(args);
        if(_hash["onstart"] != null)
        {
            string tempStr = uniquenessStr();
            m_luaFunction[tempStr] = _hash["onstart"];
            _hash["onstart"] = "iTweenMessage";

            if (_hash["onstarttarget"] != null)
            {
                m_luaObj[tempStr] = _hash["onstarttarget"];
                _hash["onstarttarget"] = this.gameObject;
            }
            if (_hash["onstartparams"] != null)
            {
                m_luaTables[tempStr] = _hash["onstartparams"];
                _hash["onstartparams"] = tempStr;
            }
        } 
        
         
        if(_hash["oncomplete"] != null)
        {
            string tempStr = uniquenessStr();
            m_luaFunction[tempStr] = _hash["oncomplete"];
            _hash["oncomplete"] = "iTweenMessage";

            if (_hash["oncompletetarget"] != null)
            {
                m_luaObj[tempStr] = _hash["oncompletetarget"];
                _hash["oncompletetarget"] = this.gameObject;
            }
            if (_hash["oncompleteparams"] != null)
            {
                m_luaTables[tempStr] = _hash["oncompleteparams"];
                _hash["oncompleteparams"] = tempStr;
            }
        }
        
        
        return _hash;
    }
    int m_recordNum = 0;
    string uniquenessStr()
    {
        m_recordNum++;
        if (m_recordNum > 9999999)
        {
            m_recordNum = 0;
        }
        return m_recordNum.ToString();
    }
    /// <summary>
    /// iTween回调的函数
    /// </summary>
    /// <param name="_str">消息标识</param>
    public void iTweenMessage(string _str)
    {
        if (m_luaFunction[_str] != null)
        {
            LuaFunction tempFunction = m_luaFunction[_str] as LuaFunction;

            if (m_luaTables[_str] != null)
            {
                tempFunction.Call(m_luaObj[_str], m_luaTables[_str]);
                m_luaTables.Remove(_str);
            }
            else
            {
                tempFunction.Call(m_luaObj[_str]);
            }
             
            m_luaFunction.Remove(_str);
            m_luaObj.Remove(_str);
           
        }
    }
}
