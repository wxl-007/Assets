using System.Collections.Generic;
using System.Text;
using UnityEngine;

public class TestLogView : MonoBehaviour
{
    public UILabel lblSocketIp;
    public UILabel lblSocketCount;
    public UILabel lblLog;
    public int maxlogCount = 20;

    public GameObject btnDetail;
    public GameObject goDetailParent;

    private List<string> listLog = new List<string>();
    private string ip = string.Empty;

    public void Awake()
    {
        DontDestroyOnLoad(this.gameObject);
       // Application.logMessageReceived += Application_logMessageReceived;
        Application.logMessageReceivedThreaded += Application_logMessageReceived;

        UIEventListener.Get(btnDetail).onClick = delegate(GameObject o)
        {
            goDetailParent.SetActive(!goDetailParent.activeSelf);
            lblSocketIp.text = ip;
        };
    }

    public void Destroy()
    {
        Application.logMessageReceivedThreaded -= Application_logMessageReceived;
    }

    private void Application_logMessageReceived(string condition, string stackTrace, LogType type)
    {
        //Util.CallMethod("TestLogView", "OnLogMessageReceived", condition, stackTrace, type);
        LogHandler(condition);
    }

    private void LogHandler(string condition)
    {
        if (condition.IndexOf("[Socket]") != -1)
        {
            if (listLog.Count == maxlogCount)
            {
                listLog.RemoveAt(0);
            }
            listLog.Add(condition);

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < listLog.Count; i++)
            {
                sb.Append("\n_____________________________\n");
                sb.Append(listLog[i].Replace("</color>", "[-]").Replace("<color=red>", "[ff0000]"));
            }
            lblLog.text = sb.ToString();


            ////TODO
            //if (SocketManager.Instance.CurSocketIp != string.Empty)
            //{
            //    ip=SocketManager.Instance.CurSocketIp;
            //    lblSocketIp.text = SocketManager.Instance.CurSocketIp;
            //}
            //lblSocketCount.text = SocketManager.Instance.CurSocketConnectCount.ToString();
        }
    }


}
