using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;

public class OutLog : MonoBehaviour {

    List<string> mWriteTxt = new List<string>();
    private string outpath;

    /// <summary>
    /// 不同平台路径
    /// </summary>
    void Path()
    {
        string path = "";
#if UNITY_EDITOR
        path = Application.dataPath + "/StreamingAssets" + "/OutLog.txt";
#elif UNITY_IPHONE
        path = Application.dataPath + "/Raw" + "/OutLog.txt";
#elif UNITY_ANDROID
        path = Application.persistentDataPath + "/OutLog.txt";
#endif

        outpath = path;
    }

	// Use this for initialization
	void Awake () {
        DontDestroyOnLoad(gameObject);
        Path();       
        //log的监听
        Application.logMessageReceived += HandleLog;

        //切换场景时保留这个对象
        //DontDestroyOnLoad(gameObject);

        //Debuger.Log("OutLog Start");
	}
	
	// Update is called once per frame
	void Update () {
	    if(mWriteTxt.Count > 0)
        {
            string[] temp = mWriteTxt.ToArray();
            foreach(string t in temp)
            {
                using(StreamWriter sw = new StreamWriter(outpath,true,Encoding.UTF8))
                {
                    sw.WriteLine(t);
                    sw.Close();
                }
                mWriteTxt.Remove(t);
            }
        }
	}

    /// <summary>
    /// 句柄记录
    /// </summary>
    /// <param name="logString">输出内容</param>
    /// <param name="stackTrace">堆栈跟踪</param>
    /// <param name="type">标记</param>
    void HandleLog(string logString, string stackTrace, LogType type)
    {
        string mDate = System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        /// 关闭Log
        //if(Debuger.EnableLog)
            mWriteTxt.Add(mDate +" "+ type +" "+ logString +" "+ stackTrace);
    }
}
