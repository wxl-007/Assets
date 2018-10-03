using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;

public class RechargeiOS : BaseSceneLua
{
	
	// This tells unity to look up the function FooPluginFunction
	// inside the static binary
	[DllImport ("__Internal")]
	private static extern float iOSStartRecharge (string uid, string host);

	// Use this for initialization

	void Start () {
        if (Utils._hallResourcesName == "happycity")
        {
            StartIOSStartRecharge();
        } 
	}
    public void StartIOSStartRecharge()
    {
        iOSStartRecharge(EginUser.Instance.uid, ConnectDefine.HostURL);
    }
	public void DoRechargeSucess () {
        CallMethod("DoRechargeSucess"); 
	}

	public void DoRechargeCancel () {
        CallMethod("DoRechargeCancel"); 
	}
 
}
