using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;
using System.IO;

public class CrossLinkTool : MonoBehaviour
{
    [MenuItem("Tools/Find cross link",false,50)]
    public static void findSelectCross()
    {
        findCrossImport(Selection.activeObject.name);
    }
    public static void findCrossImport(string pValue)
    {
        List<string> tNeedCheck = new List<string> { "_Game20DN", "_Game30M", "_GameBANK", "_GameBBDZ", "_GameBRLZ", "_GameController","_GameDDZ","_GameDDZC","_GameDZNN","_GameDZPK","_GameFKBY", "_GameFKTBDN", "_GameFTWZ", "_GameSRFTWZ", "_GameGuide", "_GameHPLZ", "_GameJQNN", "_GameKPNN", "_GameKSQZMJ" };
        tNeedCheck.Add("_GameMXNN");
        //tNeedCheck.Add("_GameNN");
        tNeedCheck.Add("_GameSHHZ");
        tNeedCheck.Add("_GameSRNN");
        tNeedCheck.Add("_GameSRPS");
        tNeedCheck.Add("_GameTBDSZ");
        tNeedCheck.Add("_GameTBNN");
        tNeedCheck.Add("_GameTBSZ");
        tNeedCheck.Add("_GameTBTW");
        tNeedCheck.Add("_GameTBWZ");
        tNeedCheck.Add("_GameXJ");
        tNeedCheck.Add("_GameYSZ");
        tNeedCheck.Add("__HappyCity"); 
        tNeedCheck.Add("__HappyCity_510k");
        tNeedCheck.Add("__HappyCity_597GD");
        tNeedCheck.Add("__HappyCity_597New");
        tNeedCheck.Remove(pValue);
        Object[] objs = Selection.GetFiltered(typeof(Object), SelectionMode.Assets);
        if (null == objs || objs.Length < 1)
            return;

        List<string> listFiles = new List<string>();
        foreach (Object obj in objs)
        {
            string szPath = AssetDatabase.GetAssetPath(obj);

            System.IO.FileAttributes file_attr = System.IO.File.GetAttributes(szPath);
            if ((file_attr & System.IO.FileAttributes.Directory) == System.IO.FileAttributes.Directory)
            {
                string[] fileEntries = Directory.GetFiles(szPath, "*.*", SearchOption.AllDirectories);
                if (null != fileEntries && fileEntries.Length > 0)
                {
                    foreach (string szStr in fileEntries)
                    {
                        if (!listFiles.Contains(szStr))
                            listFiles.Add(szStr);
                    }
                }
            }
            else
            {
                if (!listFiles.Contains(szPath))
                    listFiles.Add(szPath);
            }
        }

        string[] allEntries = listFiles.ToArray();
        float tNum = 0;
        for(int i=0,tLen=allEntries.Length;i<tLen;i++)
        {
            string tSearchStr = allEntries[i];
            tNum += 1;
            if (EditorUtility.DisplayCancelableProgressBar(pValue+": " + tSearchStr, tNum + "/" + allEntries.Length, tNum / allEntries.Length))
                break;
            if (tSearchStr.Contains(".meta") || tSearchStr.Contains(".svn") || tSearchStr.Contains(".cs"))
            {
                continue;
            }
            if (tSearchStr.Contains(".mat"))
            {
                // Object obj = AssetDatabase.LoadAssetAtPath(tSearchStr, typeof(Object));
                // Material tMaterial = obj as Material;
            }
            else if (tSearchStr.Contains(".prefab"))
            {
                Object obj = AssetDatabase.LoadAssetAtPath(tSearchStr, typeof(Object));
                GameObject ObjInst = obj as GameObject;
                Object[] tDependObjs = EditorUtility.CollectDependencies(new Object[] { ObjInst });
                for (int j = 0, tJLen= tDependObjs.Length; j < tJLen; j++)
                {
                    Object tDepndObj = tDependObjs[j];
                    string tObjPath = AssetDatabase.GetAssetPath(tDepndObj);
                    for(int tK=0,tKlen=tNeedCheck.Count;tK<tKlen;tK++)
                    {
                        if (tObjPath.Contains(tNeedCheck[tK]+"/")&&tObjPath.Contains(".cs")==false)
                        {
                            Debug.Log(tSearchStr + " 交叉引用 :" + tObjPath);
                            break;
                        }
                    }
                }
            }
            

        }
        EditorUtility.ClearProgressBar();
        Debug.Log("check cross finish");
    }
    [MenuItem("Tools/Create Asign AssetBundle", false, 51)]
    public static void CreateSubAssetBundle()
    {
        AssetDatabase.SaveAssets();
        Object tSelectObject = Selection.activeObject;
        Dictionary<string, List<string>> tAssetbundleNameMap = new Dictionary<string, List<string>>();
        setAssetBundles(AssetDatabase.GetAssetPath(tSelectObject), tAssetbundleNameMap);
        List<AssetBundleBuild> tAssetBundleBuilds = new List<AssetBundleBuild>();
        foreach ( string tAssetBundleName in tAssetbundleNameMap.Keys){
            int tAssetBundleNamesLen = tAssetbundleNameMap[tAssetBundleName].Count;
            AssetBundleBuild tAssetBundleBuild = new AssetBundleBuild();
            tAssetBundleBuild.assetBundleName = tAssetBundleName;
            tAssetBundleBuild.assetNames = tAssetbundleNameMap[tAssetBundleName].ToArray();
            tAssetBundleBuilds.Add(tAssetBundleBuild);
          //  Debug.Log(tAssetBundleName+" "+ tAssetbundleNameMap[tAssetBundleName].ToString());
        }
        string tAssetPath = Application.dataPath.ToLower();
        string tAssetBundlePath = tAssetPath.Substring(0,tAssetPath.IndexOf(@"/assets")) + "/extract/AsignAssetBundle/";
        tAssetBundlePath = tAssetBundlePath.ToLower();
        //Debug.Log(tAssetBundlePath);
        if (Directory.Exists(tAssetBundlePath) == false)
        {
            Debug.Log("create new " + tAssetBundlePath);
            Directory.CreateDirectory(tAssetBundlePath);
        }
        //Debug.Log(tAssetBundleBuilds[0].assetBundleName);
        BuildPipeline.BuildAssetBundles(tAssetBundlePath, tAssetBundleBuilds.ToArray(), BuildAssetBundleOptions.UncompressedAssetBundle|BuildAssetBundleOptions.DeterministicAssetBundle, BuildTarget.StandaloneWindows);

        foreach (string tAssetBundleName in tAssetbundleNameMap.Keys)
        {
 
            if (tAssetBundleName != "")
            {
                FileInfo tNewFile = new FileInfo(tAssetBundlePath + tAssetBundleName);
                FileInfo tOldFile = new FileInfo(Constants.DataPath + tAssetBundleName);
                if(tOldFile==null||tNewFile.LastWriteTime != tOldFile.LastWriteTime)
                {
                    File.Copy(tAssetBundlePath + tAssetBundleName, Constants.DataPath + tAssetBundleName, true);
                    Debug.Log("copy:" + tAssetBundlePath + tAssetBundleName);
                } 
            }
        }
        EditorUtility.DisplayDialog(tSelectObject.name, tSelectObject.name + " CreateSubAssetBundle finish", "ok");
    }
    public static void setAssetBundles(string pPath,Dictionary<string, List<string>> pAssetBundleNameMap)
    {
        DirectoryInfo folder = new DirectoryInfo(pPath);
        FileSystemInfo[] files = folder.GetFileSystemInfos();
        int length = files.Length;
        for (int i = 0; i < length; i++)
        {
            if (files[i] is DirectoryInfo)
            {
                setAssetBundles(files[i].FullName,pAssetBundleNameMap);
            }
            else
            {
                if (files[i].Name.EndsWith(".meta") == false)
                {
                    string tPath = files[i].FullName;
                    if (Application.platform == RuntimePlatform.WindowsEditor)
                    {
                        tPath = tPath.Substring(tPath.IndexOf(@"Assets\"));
                    }
                    AssetImporter assetImporter = AssetImporter.GetAtPath(tPath);
                    if (assetImporter!=null&&assetImporter.assetBundleName!="")
                    {
                        string pAssetBundleName = assetImporter.assetBundleName;
                        if (pAssetBundleNameMap.ContainsKey(pAssetBundleName) ==false)
                        {
                            pAssetBundleNameMap.Add(pAssetBundleName, new List<string>());
                        }
                        while(tPath.IndexOf(@"\")!=-1)
                        {
                            tPath = tPath.Replace(@"\", @"/");
                        }
                        //int tStartStrIndex = 7;
                        //Debug.Log(tStartStrIndex);
                        //tPath = tPath.Substring(tStartStrIndex);
                        //Debug.Log(assetImporter.assetBundleName + ":" + tPath);
                        pAssetBundleNameMap[pAssetBundleName].Add(tPath);
                    }
                    else
                    {
                        Debug.Log(files[i].FullName + " is null");
                    }

                }
            }
        }
    }

    [MenuItem("Tools/Find UITexture",false, 51)]
    public static void findCrossUITexture()
    {
        Object[] objs = Selection.GetFiltered(typeof(Object), SelectionMode.Assets);
        if (null == objs || objs.Length < 1)
            return;

        List<string> listFiles = new List<string>();
        foreach (Object obj in objs)
        {
            string szPath = AssetDatabase.GetAssetPath(obj);

            System.IO.FileAttributes file_attr = System.IO.File.GetAttributes(szPath);
            if ((file_attr & System.IO.FileAttributes.Directory) == System.IO.FileAttributes.Directory)
            {
                string[] fileEntries = Directory.GetFiles(szPath, "*.*", SearchOption.AllDirectories);
                if (null != fileEntries && fileEntries.Length > 0)
                {
                    foreach (string szStr in fileEntries)
                    {
                        if (!listFiles.Contains(szStr))
                            listFiles.Add(szStr);
                    }
                }
            }
            else
            {
                if (!listFiles.Contains(szPath))
                    listFiles.Add(szPath);
            }
        }

        string[] allEntries = listFiles.ToArray();
 
        foreach (string tSearchStr in allEntries)
        {
             if (tSearchStr.Contains(".meta") || tSearchStr.Contains(".svn"))
            {
                continue;
            }
            if (tSearchStr.Contains(".mat"))
            {
                // Object obj = AssetDatabase.LoadAssetAtPath(tSearchStr, typeof(Object));
                // Material tMaterial = obj as Material;
            }
            else if (tSearchStr.Contains(".prefab"))
            {
                Object obj = AssetDatabase.LoadAssetAtPath(tSearchStr, typeof(Object));
                GameObject ObjInst = obj as GameObject;
                UITexture[] tDependObjs = ObjInst.GetComponentsInChildren<UITexture>();
                foreach (UITexture tDepndObj in tDependObjs)
                {
                    Debug.Log(tDepndObj.gameObject.name);
                }
            }
            
        }
    }
}