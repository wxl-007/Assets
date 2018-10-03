#if UNITY_EDITOR && UNITY_ANDROID

using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

public class AndroidPostProcess
{

    private static string androidPluginRoot = "Assets/Plugins/Android/";

    private string m_XCode_Path;
    //	private PBXProject m_Project;
    private static string m_TargetGuid;

    [PostProcessBuild(10000)]
    public static void OnPostProcessBuild(BuildTarget target, string pathToBuiltProject)
    {
        AndroidPostProcess process = new AndroidPostProcess();
        process.DoPostProcessBuild(target, pathToBuiltProject);
    }

    public void DoPostProcessBuild(BuildTarget target, string pathToBuiltProject)
    {
        if (target != BuildTarget.Android) return;
        Debug.Log(PlayerSettings.bundleIdentifier);
        replaceBundleId(PlayerSettings.bundleIdentifier);
        Debug.Log(PlayerSettings.bundleIdentifier);
    }
    private void replaceBundleId(string pId)
    {
        string tResult = "";
        string tPath = androidPluginRoot + "AndroidManifest.xml";
        string[] libArray = File.ReadAllLines(tPath);
        for (int i = 0; i < libArray.Length; i++)
        {
             tResult += libArray[i] + "\n";
        }
        tResult = Regex.Replace(tResult, "\""+@"baidu.push.permission.WRITE_PUSHINFOPROVIDER.([\s\S]*?)"+"\"", "\""+@"baidu.push.permission.WRITE_PUSHINFOPROVIDER."+pId+"\"");
        tResult = Regex.Replace(tResult, "\""+@"android:authorities="+"\""+@"([\s\S]*?).bdpush"+"\"", "\"android:authorities=\""+pId+".bdpush\"");
        FileStream fs = File.Open(tPath, FileMode.Create);
        byte[] tWriteBytes = Encoding.UTF8.GetBytes(tResult);
        fs.Write(tWriteBytes, 0, tWriteBytes.Length);
        fs.Flush();
        fs.Close();
    }
}
#endif