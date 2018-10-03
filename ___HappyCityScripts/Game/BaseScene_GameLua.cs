using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BaseScene_GameLua : BaseSceneLua {

    public override void SocketReceiveMessage(string message)
    {
        CallMethod("SocketReceiveMessage", message);
    }

    public override void OnSocketDisconnect(string disconnectInfo)
    {
        CallMethod("OnSocketDisconnect", disconnectInfo);
    }

    public override void SocketDisconnect(string disconnectInfo)
    {
        CallMethod("SocketDisconnect", disconnectInfo);
    }

    public override void Process_account_login(string info)
    {
        CallMethod("Process_account_login", info);
    }

    public override void Process_account_login_Failed(string errorInfo, string body)
    {
        CallMethod("Process_account_login_Failed", errorInfo);
    }
}
