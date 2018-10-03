using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Local_Login : Login
{
    public UIInput localServerIP_IP;
    public static string serverIP;

    //// Use this for initialization
    void Start()
    {
        base.Start();
        
    }

	public void inputChanged()
	{
		serverIP = localServerIP_IP.text;
		Debug.Log(serverIP);
	}

}
