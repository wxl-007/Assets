#define Unity5_AssetBundle

using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using SimpleFramework;

public class Packager {

    /// <summary>
    /// 数据目录
    /// </summary>
    static string AppDataPath
    {
        get { return Application.dataPath.ToLower(); }
    }

    private static readonly string assetBundlePath = Path.GetDirectoryName(AppDataPath) + "/extract/AssetBundle" + Constants.DirName;
    private static readonly string assetBundleFileTxtPath = assetBundlePath + Constants.Config_File;

    //private static readonly string dirName = "/StreamingAssets/";
    private static readonly string assetPath = AppDataPath + Constants.DirName;
    private static readonly string extractPath = Path.GetDirectoryName(AppDataPath) + "/extract"+Constants.UpdateDirName;//把StreamingAssets 路径下的资源提取到extracPath中
    //private static readonly string saveAssetBundlePath = Path.GetDirectoryName(AppDataPath) + "/extract/savePath"+Constants.UpdateDirName;
    //private static readonly string assetFileTxtPath = assetPath + Constants.Config_File;
    private static readonly string extractFileTxtPath = extractPath + Constants.Config_File;//把所有files.txt中的数据存储到该文件中,这样客户端只需要访问一次就能把所有的模块需要的更新数据都拿到

    //private const string GameModules_DefaultValues = "lua,HappyCity,gamenn,gamemxnn,gamekpnn,gameftwz,gamexj,gamebbdz,gamebrlz,game30m";//游戏默认模块,随包发布的游戏模块资源
    //private static string _GameModules_DefaultValues { get { return GameModules_DefaultValues.ToLower(); } }//游戏默认模块
#if Platform_510k
    private static List<string> DefaultGameModuleList = new List<string> (){ ":happycity" };
#else
    private static List<string> DefaultGameModuleList = new List<string>(){ "", "lua", "baselobby", "happycity", "gamenn", "gametbnn","gamesrnn","gamejqnn","gametbwz" };//null;
#endif
    //private static List<string> DefaultGameModuleList = new List<string>() { "", "lua", "baselobby", "happycity", "gamenn", "gamedznn", };// "gamefkby", "game30m", "gametbnn", "gamejqnn", "gamebrlz", "gamebbdz" };//, "gamemxnn" }; //"game30m","gamebbdz","gamebrlz","gamekpnn","gamemxnn","gametbwz","gamexj","gameysz","gamedzpk","gamesrps","gameftwz"};//这里的模块必须小写(与打出AssetBundle的路径(编辑器中StreamingAssets目录下的文件夹)相同)//如果这个值为空,那么所有的模块都会随包发布
    //private static List<string> DefaultGameModuleList = new List<string>() { ":gamefkby", ":happycity_597new", ":happycity_597gd", ":happycity_510k", "", "lua", "baselobby", "happycity", "gamedznn" };// "gamefkby", "game30m", "gametbnn", "gamejqnn", "gamebrlz", "gamebbdz" };//, "gamemxnn" }; //"game30m","gamebbdz","gamebrlz","gamekpnn","gamemxnn","gametbwz","gamexj","gameysz","gamedzpk","gamesrps","gameftwz"};//这里的模块必须小写(与打出AssetBundle的路径(编辑器中StreamingAssets目录下的文件夹)相同)//如果这个值为空,那么所有的模块都会随包发布

    private static JSONObject m_ConfigJson = new JSONObject();//用于存储到file.txt文件中的配置数据
    private static JSONObject m_ConfigJson_ali = new JSONObject();//用于存储到file.txt文件中的配置数据, 阿里云上的最新版本(在 VersionControl 中配置的版本)
    private static int m_UpdateVersionControlCode = 0;
    private static int m_FixedVersionControlCode = 0;//(默认0)手动设置的 版本号, 如果该值大于0, 那么 m_UpdateVersionControlCode 就等于该值;//用于跳过阿里云上某些有问题的版本号
    private static int m_FixedVersionControlCode_ali = -1;//(默认-1)手动设置的 参考用的版本号(原本应该是阿里云上正在用的版本号, 但是有些情况下该值也需要手动设置), 如果该值大于-1, 就不用阿里云上的VersionControl的值, 而是使用该值
    private static bool m_IsServerUrl = true;//(默认true)是否使用服务端地址更新 配置文件. false 则使用本地配置文件//作用与GameManager中的该值相同, 区别是作用时机不同, Packager的该值是用于打包时(非运行时)获取配置文件, 而GameManager 中的值是用于运行时热更新

    public static string platform = string.Empty;
    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();

    private const string StreamingAssets_lua = "Assets/StreamingAssets/lua/";
    private const string Pack_Config_EditorPath = "Assets/__BaseLobby/Editor/Pack_Config.txt";

#region 各个平台资源打包
    private static BuildTarget getBuildTarget()
    {
#if UNITY_ANDROID
        return BuildTarget.Android;
#elif UNITY_IOS
        return BuildTarget.iOS;
#elif UNITY_IPHONE
        return BuildTarget.iPhone;
#elif UNITY_STANDALONE_OSX
        return BuildTarget.StandaloneOSXUniversal;
#else
        return BuildTarget.StandaloneWindows;
#endif
    }

#region 注掉了,使用编译平台作为BuildTarget
    //    [MenuItem("Game/Build iPhone Resource", false, 11)]
    //    public static void BuildiPhoneResource()
    //    {
    //        BuildTarget target;
    //#if UNITY_5
    //        target = BuildTarget.iOS;
    //#else
    //        target = BuildTarget.iPhone;
    //#endif
    //        BuildAssetResource(target, false);
    //    }

    //    [MenuItem("Game/Build Android Resource", false, 12)]
    //    public static void BuildAndroidResource()
    //    {
    //        BuildAssetResource(BuildTarget.Android, true);
    //    }

    //    [MenuItem("Game/Build Windows Resource", false, 13)]
    //    public static void BuildWindowsResource()
    //    {
    //        BuildAssetResource(BuildTarget.StandaloneWindows, true);
    //    }
#endregion 注掉了,使用编译平台作为BuildTarget

    /// <summary>
    /// 生成绑定素材, 打AssetBundle包,以及对Lua文件的处理(编译或者直接复制)
    /// </summary>
    [MenuItem("Game/Build Resources", false, 11)]
    public static void BuildAssetResource()
    {
        BuildTarget target = getBuildTarget();
#if UNITY_EDITOR_WIN
        bool isWin = true;
#else
        bool isWin = false;
#endif


        string assetPath = assetBundlePath;
        string assetFileTxtPath = assetBundleFileTxtPath;

        m_ConfigJson.Clear();
        if (File.Exists(assetFileTxtPath)) File.Delete(assetFileTxtPath);//如果不删除这个文件,这个文件会被记录到config中

#if !Unity5_AssetBundle
        HandleGameModules(assetPath, target);
#else
        HandleGameModules_Unity5_AssetBundle(assetPath, target);
#endif
        HandleLuaFile(Path.GetDirectoryName(assetPath), isWin);

        GenerateMD5(Path.GetDirectoryName(assetPath), false);//-----------------AssetBundleManifest-----------------
        foreach (var item in Directory.GetFileSystemEntries(assetPath))
        {
            //UnityEngine.Debug.Log("item = " + item);
            if (Directory.Exists(item)) GenerateMD5(item);
        }

        FixUpdateVersion(()=> {
            m_ConfigJson.SetField(Constants.InstantUpdate_VersionTime, EginTools.nowMinis());
            m_ConfigJson.SetField(Constants.InstantUpdate_VersionCode, m_UpdateVersionControlCode);
            File.WriteAllText(assetFileTxtPath, m_ConfigJson.ToString());//生成配置文件
            //保存到Resources下
		string configFile_resources = "Assets/__BaseLobby/Resources/" + Constants.ClickDownload_Config_resource;
            string clickDownload_Config_dir = Path.GetDirectoryName(configFile_resources);
            if (!Directory.Exists(clickDownload_Config_dir)) Directory.CreateDirectory(clickDownload_Config_dir);
            File.WriteAllText(configFile_resources, m_ConfigJson.ToString());//生成配置文件


            //if (SimpleFramework.Manager.GameManager.m_SaveAssetBundle && Directory.Exists(assetPath))
            //{
            //    StaticUtils.Copy(assetPath, Path.GetDirectoryName(saveAssetBundlePath));
            //}

            //GenerateReleaseBundles();

            ExtractStreamingAssets();
            ExtractReleaseAssets();

            Handle_Lua_StreamingAssets_AssetBundle(target);//把StreamingAssets中的lua文件打包成一个assetbundle文件

            AssetDatabase.Refresh();
        });
    }

    private static void Handle_Lua_StreamingAssets_AssetBundle(BuildTarget target)
    {
        string tempPath = "Assets/temp";
        string lua_assetbundle_path = StreamingAssets_lua + "lua.assetbundle";
        StaticUtils.Cut(Path.GetDirectoryName(StreamingAssets_lua), tempPath);
        AssetDatabase.Refresh();

        Build_Lua_StreamingAssets_AssetBundle(tempPath, target);
        AssetDatabase.Refresh();

        string filename = Path.GetFileName(tempPath);
        if (!Directory.Exists(StreamingAssets_lua)) Directory.CreateDirectory(StreamingAssets_lua);
        File.Move(tempPath + "/" + filename + ".assetbundle", lua_assetbundle_path);
        StaticUtils.Crypt(lua_assetbundle_path);
        Directory.Delete(tempPath, true);
    }

    /// <summary>
    /// 提取需要上传到 云 的资源
    /// </summary>
    static void ExtractReleaseAssets()
    {
        if (typeof(SimpleFramework.Manager.GameManager).GetField("_IsDevelop") != null) return;
        GameObject gobj = new GameObject();
        MonoBehaviour mono = gobj.AddComponent<MonoBehaviour>();

        string extractPath = StaticUtils.InsertUpdateUrlWithVersionCode( Packager.extractPath, m_UpdateVersionControlCode+"");//新版本解析位置发生了变化, 需要把热更新版本号插入进去

        if (Directory.Exists(extractPath)) Directory.Delete(extractPath, true);
        Directory.CreateDirectory(extractPath);//重新创建
        string extractFileTxtPath = extractPath + Constants.Config_File;
        File.WriteAllText(extractFileTxtPath, m_ConfigJson_ali.ToString());//保存从阿里云下载的 配置文件

        //通过阿里云的配置文件, 把 AssetBundle目录下新生成的资源 移动到该热更新版本号的目录下
        StaticUtils.UpdateGameModules(mono, assetBundlePath, extractPath, null, false, null, (error,config) =>
        {
            GameObject.DestroyImmediate(mono.gameObject);
            File.WriteAllText(extractFileTxtPath, m_ConfigJson.ToString());//生成配置文件
            UnityEngine.Debug.Log("正式版本资源生成完成, 大版本号: " + new GameEntityAll().VersionName + ", 热更新版本号: " + m_UpdateVersionControlCode);
        });
    }

    /// <summary>
    /// 把随包资源提取到StreamingAssets 目录下
    /// </summary>
    static void ExtractStreamingAssets()
    {
        List<string> gameModuleList = null; 
        if (typeof(SimpleFramework.Manager.GameManager).GetField("_IsDevelop") == null)//发布环境
        {
            gameModuleList = DefaultGameModuleList;
        }

        GameObject gobj = new GameObject();
        MonoBehaviour mono = gobj.AddComponent<MonoBehaviour>();

        if (Directory.Exists(assetPath)) Directory.Delete(assetPath, true);
        
        StaticUtils.UpdateGameModules(mono, assetBundlePath, assetPath, gameModuleList, false, null, (error2,config) => {
            GameObject.DestroyImmediate(mono.gameObject);
            AssetDatabase.Refresh();
        });
    }

#region 注掉不用了
    /// <summary>
    /// 
    /// </summary>
    //static void GenerateReleaseBundles()
    //{
    //    if (typeof(SimpleFramework.Manager.GameManager).GetField("_IsDevelop") != null) return;

    //    //m_ConfigJson.AddField("version", Application.version);//版本信息//不使用版本信息

    //    //_IsDevelop为空,说明_IsDevelop没有预定义. 则需要生成正式发布的AssetBundle包. 在extractPath目录下生成发布用的AssetBundle包
    //    GameObject gobj = new GameObject();
    //    MonoBehaviour mono = gobj.AddComponent<MonoBehaviour>();
    //    if (Directory.Exists(extractPath)) Directory.Delete(extractPath, true);

    //    StaticUtils.UpdateGameModules(mono, assetPath, extractPath, null,false,null,(error)=>{
    //        File.WriteAllText(extractFileTxtPath, m_ConfigJson.ToString());//生成配置文件

    //        if (SimpleFramework.Manager.GameManager.m_IsStreamingAssetExtract)
    //        {
    //            if (Directory.Exists(assetPath)) Directory.Delete(assetPath, true);
    //        }
    //        else if (File.Exists(assetFileTxtPath)) File.Delete(assetFileTxtPath);//如果不删除这个文件,这个文件会被记录到config中

    //        StaticUtils.UpdateGameModules(mono, extractPath,assetPath,DefaultGameModuleList,false,null,(error2)=> {
    //            GameObject.DestroyImmediate(mono.gameObject);
    //            AssetDatabase.Refresh();
    //            UnityEngine.Debug.Log("正式版本资源生成完成");
    //        });
    //    });

    //    //在StaticUtils 中定义ExtractFiles 方法,在这里调用

    //    //把StreamingAssets 下不需要随包(完整安装包)发布的模块全部删除掉(也使用ExtractFiles方法即可)
    //}
#endregion 注掉不用了
#endregion 各个平台资源打包

#region Unity5 AssetBundle打包
    /// <summary>
    /// unity5 AssetBundle打包
    /// </summary>
    /// <param name="assetPath"></param>
    /// <param name="target"></param>
    static void HandleGameModules_Unity5_AssetBundle(string assetPath, BuildTarget target)
    {
        SetAllAssetBundleName();
        //string resPath = AppDataPath + "/" + AppConst.AssetDirname + "/";
        if (!Directory.Exists(assetPath)) Directory.CreateDirectory(assetPath);

        BuildPipeline.BuildAssetBundles(assetPath, BuildAssetBundleOptions.None, target);
    }


    //[MenuItem("Game/SetAssetNameToAssetBundle &s", false, 23)]
    //public static void SetAssetBundleName()
    //{
    //    foreach (var item in Selection.objects)
    //    {
    //        string path = AssetDatabase.GetAssetPath(item);
    //        string gameModuleName = string.Empty;
    //        int buildIndex = path.IndexOf("/Build/");
    //        if (buildIndex >= 0)
    //        {
    //            gameModuleName = path.Substring(0, buildIndex);
    //            gameModuleName = Path.GetFileName(gameModuleName);
    //            gameModuleName = gameModuleName.Trim('_');
    //            gameModuleName += "/";
    //        }
    //        AssetImporter assetImporter = AssetImporter.GetAtPath(path);
    //        assetImporter.assetBundleName = gameModuleName + item.name + ".assetbundle";
    //    }
    //}

    /// <summary>
    /// 使用Unity5打包方式,对所有要打包的资源设置AssetBundle 标签
    /// </summary>
    //[MenuItem("Game/SetAllAssetNameToAssetBundle")]
    public static void SetAllAssetBundleName()
    {
        string name = string.Empty;
        foreach (var item in AssetDatabase.GetAllAssetPaths())
        {
            string path_lower = item.ToLower();
            if (path_lower.EndsWith(".cs") || path_lower.EndsWith(".js")) continue;
            string path = item;
            string gameModuleName = string.Empty;
            string assetBundleName = string.Empty;
            int buildIndex = path.IndexOf("/Build/");
            if (buildIndex >= 0)
            {
                gameModuleName = path.Substring(0, buildIndex);
                gameModuleName = Path.GetFileName(gameModuleName);
                gameModuleName = gameModuleName.Trim('_');//以下划线开头的目录不会打包到Android的StreamingAssets目录下
                gameModuleName += "/";
                if (gameModuleName == "Assets/") gameModuleName = string.Empty;//如果Build 文件夹直接在Assets/ 下, 那么就没有模块

                assetBundleName = path.Substring(buildIndex + "/Build/".Length);
                if (assetBundleName.Contains("/"))//该资源所需要打的AssetBundle包含多个资源,因此该资源在Build文件夹下的xxx 文件夹(Build/xxx/ ... asset.asset)下
                {
                    assetBundleName = assetBundleName.Substring(0, assetBundleName.IndexOf("/"));
                }
                else
                {//该资源所需要打的AssetBundle 就只有该文件一个资源
                    assetBundleName = Path.GetFileNameWithoutExtension(path);
                }

                name = gameModuleName + assetBundleName + ".assetbundle";
            }
            else name = null;
            
            AssetImporter assetImporter = AssetImporter.GetAtPath(path);
            assetImporter.assetBundleName = name;
        }
    }

    //[MenuItem("Game/BuildLua_StreamingAssets &S")]
    public static void Build_Lua_StreamingAssets_AssetBundle(string dirPath, BuildTarget target)
    {
        //string dirPath = AssetDatabase.GetAssetPath(Selection.activeObject);//"Assets/StreamingAssets/lua"; //
        //BuildTarget target = BuildTarget.Android;

        string newPathName = string.Empty;
        string path_lower = string.Empty;
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = Path.GetFileName(dirPath)+".assetbundle";
        List<string> assetNameList = new List<string>();
        foreach (var item in AssetDatabase.GetAllAssetPaths())
        {
            path_lower = item.ToLower();

            if (!item.StartsWith(dirPath) || !File.Exists(item)) continue;
            if (path_lower.EndsWith(".cs") || path_lower.EndsWith(".js")) continue;
            if (!path_lower.EndsWith(".lua") && !path_lower.EndsWith(".bytes")) continue;

            newPathName = item;
            if (path_lower.EndsWith(".lua"))
            {
                StaticUtils.Crypt(item);//文件移动到StreamingAssets目录下会被加密,这里是解密
                newPathName += ".bytes";
                if (File.Exists(newPathName)) File.Delete(newPathName);
                File.Move(item, newPathName);
            }

            assetNameList.Add(newPathName);
        }
        AssetDatabase.Refresh();

        build.assetNames = assetNameList.ToArray();
        AssetBundleBuild[] buildMap = new AssetBundleBuild[1];
        buildMap[0] = build;
        
        BuildPipeline.BuildAssetBundles(dirPath, buildMap, BuildAssetBundleOptions.None, target);
        AssetDatabase.Refresh();
    }
#endregion Unity5 AssetBundle打包

#region 处理(编译或复制) lua 文件
    /// <summary>
    /// 处理Lua文件
    /// </summary>
    static void HandleLuaFile(string assetPath, bool isWin)
    {
        string luaPath = assetPath + "/lua/";

        if (Directory.Exists(luaPath)) Directory.Delete(luaPath,true);

        //----------复制Lua文件----------------
        if (!Directory.Exists(luaPath))
        {
            Directory.CreateDirectory(luaPath);
        }
        paths.Clear(); files.Clear();
        string luaDataPath = AppDataPath + "/lua/".ToLower();
        Recursive(luaDataPath);
        int n = 0;
		int filesCount = files.Count;
        foreach (string f in files)
        {
            if (f.EndsWith(".meta")) continue;
            string newfile = f.Replace(luaDataPath, "");
            string newpath = luaPath + newfile;
            newpath = newpath.ToLower();
            string path = Path.GetDirectoryName(newpath);
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);

            if (File.Exists(newpath))
            {
                File.Delete(newpath);
            }
            if (SimpleFramework.Manager.GameManager.LuaEncode)
            {
				UpdateProgress(n++, filesCount, newpath);
                EncodeLuaFile(f, newpath, isWin);
            }
            else
            {
                File.Copy(f, newpath, true);
            }
        }


        EditorUtility.ClearProgressBar(); 

		paths.Clear(); files.Clear(); 
		Recursive(luaPath);
		UnityEngine.Debug.LogError("Lua文件原始数量: " +filesCount+"=====编译后的文件数量:"+ files.Count+"");
        //GenerateMD5(luaPath);

        //AssetDatabase.Refresh();
    }


    static void EncodeLuaFile(string srcFile, string outFile, bool isWin)
    {
        if (!srcFile.ToLower().EndsWith(".lua"))
        {
            File.Copy(srcFile, outFile, true);
            return;
        }
        string luaexe = string.Empty;
        string args = string.Empty;
        string exedir = string.Empty;
        string currDir = Directory.GetCurrentDirectory();
        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            luaexe = "luajit.exe";
            args = "-b " + srcFile + " " + outFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit/";
        }
        else if (Application.platform == RuntimePlatform.OSXEditor)
        {
            //luaexe = "./luac";
            //args = "-o " + outFile + " " + srcFile;
            //exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luavm/";

            luaexe = "sh";//这样做的原因是,unity5.3.3f1 版本中出现无法在unity中直接用luavm编译lua脚本的情况,通过shell去调用luavm 就可以编译了
            args = Directory.GetCurrentDirectory() + "/LuaEncoder/luavm/handlelua.sh " + "-o " + outFile + " " + srcFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luavm/";
        }

       	 try
         {
            Directory.SetCurrentDirectory(exedir);
            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = luaexe;
            info.Arguments = args;
            info.WindowStyle = ProcessWindowStyle.Hidden;
            info.UseShellExecute = isWin;
            info.ErrorDialog = true;
            Util.Log(info.FileName + " " + info.Arguments);

            Process pro = Process.Start(info);
            pro.WaitForExit();
            Directory.SetCurrentDirectory(currDir);
         }
         catch (System.Exception ex)
         {
            UnityEngine.Debug.LogError("EncodeLuaFile Error : " + ex);
            Directory.SetCurrentDirectory(currDir);
			EncodeLuaFile (srcFile, outFile, isWin);
         }
        // finally
        // {
            // Directory.SetCurrentDirectory(currDir);
        // }
    }

    //[MenuItem("Lua/Debug Lua only")]
    //public static void Debug_Lua_only()
    //{
    //    string src = Application.dataPath + "/lua";
    //    string des = Constants.DataPath+"";
    //    if (!Directory.Exists(des)) Directory.CreateDirectory(des);
    //    StaticUtils.Copy(src,des);
    //}
#endregion 处理(编译或复制) lua 文件

#region 给目录下的所有文件生成MD5
    /// <summary>
    /// 给目录下的所有文件生成MD5
    /// </summary>
    /// <param name="resPath"></param>
    /// <param name="isRecersive">是否要包含子目录</param>
    private static void GenerateMD5(string resPath, bool isRecersive = true)
    {
        JSONObject json = new JSONObject();
        if (isRecersive) m_ConfigJson[Path.GetFileName(resPath)] = json;//游戏模块
        else m_ConfigJson[""] = json;//最外层 StreamingAssets 文件夹,只需要该文件夹下的StreamingAssets (AssetBundleManifest)文件

        resPath += "/";

        paths.Clear(); files.Clear();
        Recursive(resPath, isRecersive);

        ///----------------------创建文件列表-----------------------
        //string newFilePath = resPath + "files.txt";
        //if (File.Exists(newFilePath)) File.Delete(newFilePath);
        //FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        //StreamWriter sw = new StreamWriter(fs);

        //string line = string.Empty;
        //string outFile = string.Empty;
        for (int i = 0; i < files.Count; i++)
        {
            string file = files[i];
            string ext = Path.GetExtension(file);

            if (file.EndsWith(".meta") || file.Contains(".DS_Store") || file.EndsWith(".manifest")) continue;

            //StaticUtils.Crypt(file);//加密,主要为了是Assetbundle不会被WWW识别
            //string md5 = Util.md5file(file);
            string md5 = StaticUtils.md5(file);
            string value = file.Replace(resPath, string.Empty);
            long fileSize = new FileInfo(file).Length;
            json[value] = new JSONObject() {type = JSONObject.Type.STRING,str = md5 + "|" + fileSize };

            //line = value + "|" + md5 + "|" + fileSize;
            //json.Add(new JSONObject("\"" + line + "\""));
            //sw.WriteLine(line);
        }
        //sw.Close(); fs.Close();
    }
    #endregion 给目录下的所有文件生成MD5

    #region 热更新功能升级, 添加热更新 版本号功能
    /// <summary>
    /// 获取阿里云上的 最新 版本号 和 最新 file.txt
    /// </summary>
    //[MenuItem("Game/GetVersionNum")]
    private static void FixUpdateVersion(System.Action onComplete)
    {
        StaticUtils.GetVersionUpdateControl((num) =>
        {
            if (m_FixedVersionControlCode_ali > -1) num = m_FixedVersionControlCode_ali;
            m_UpdateVersionControlCode = num + 1;//对ali云上的版本号递增;
            if (m_FixedVersionControlCode > 0)
                m_UpdateVersionControlCode = m_FixedVersionControlCode;

            string rawUrl = Constants._InstantUpdateUrl;
            if (!Packager.m_IsServerUrl)
                rawUrl = "file:///" + Path.GetDirectoryName(Application.dataPath.ToLower()) + "/extract" + Constants.UpdateDirName;//AssetBundle 更新地址,服务端url,可以通过url配置. 本地测试地址

            string url = StaticUtils.InsertUpdateUrlWithVersionCode(rawUrl, num + "");
            //UnityEngine.Debug.Log("ck debug : -------------------------------- ali云热更新最新版本号为 : " + num );
            if (num == 0)
            {
                UnityEngine.Debug.LogError("ck debug : -------------------------------- 阿里云上(或者当前设置的参考版本) 最新版本号为 0!!!(如果该大版本还没有上传过热更新资源则是正常的, 否则请确认ali云上的资源后重新打资源) ");
                UnityEngine.Debug.Log("ck debug : -------------------------------- name = " + url); 
            }

            string config_file_url = url + Constants.Config_File;

            CoroutineResult result = new CoroutineResult();
            IEnumerator enumerator = result.WWWReConnect(config_file_url, () =>
            {
                //JSONObject m_ConfigJson_ali = new JSONObject();
                m_ConfigJson_ali.Clear();
                if (result._wwwResult != null && result._wwwResult.error == null)
                {
                    m_ConfigJson_ali = new JSONObject(result._wwwResult.text);
                }

                FixUpdateVersion(m_UpdateVersionControlCode);

                if (onComplete != null) onComplete();
            });

            while (enumerator.MoveNext()) ;
        });
    }

    /// <summary>
    /// 修正本地 file.txt 中的配置的 md5|size|versionCode 中的 versionCode值
    /// 如何一个文件的 md5|size 在本地config中 与 阿里云上的相同, 则保留使用阿里云上的 md5|size|versionCode
    /// </summary>
    /// <param name="configJson_ali"></param>
    /// <param name="versionCode"></param>
    private static void FixUpdateVersion(int versionCode)
    {
        JSONObject configJson_local = m_ConfigJson;
        JSONObject configJson_ali = m_ConfigJson_ali;

        JSONObject localJsonItem = null;
        JSONObject aliJsonItem = null;
        List<string> localKeys = new List<string>(configJson_local.keys);
        foreach (var item in localKeys)
        {
            localJsonItem = configJson_local[item];
            aliJsonItem = configJson_ali[item];

            if (localJsonItem.keys == null) continue;
            List<string> localItemkeys = new List<string>(localJsonItem.keys);
            foreach (var key in localItemkeys)
            {
                if (aliJsonItem.IsAvailable() && aliJsonItem[key].IsAvailable() && aliJsonItem[key].str.Contains(localJsonItem[key].str) && !string.IsNullOrEmpty(item))//阿里云上的 md5 与 本地 md5 相同, 则使用 阿里云上的版本号//item = ""; 是 StreamingAssets 文件, 必须使用 当前的版本号
                {
                    localJsonItem[key].str = aliJsonItem[key].str;
                }
                else
                {
                    localJsonItem[key].str = localJsonItem[key].str + "|" + versionCode;
                }
            }
        }
    }
    #endregion 热更新功能升级, 添加热更新 版本号功能



    #region 工具方法区
    /// <summary>
    /// 遍历目录及其子目录
    /// </summary>
    static void Recursive(string path, bool isRecursive = true)
    {
        string[] names = Directory.GetFiles(path);
        foreach (string filename in names)
        {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".meta")) continue;
            files.Add(filename.Replace('\\', '/'));
        }

        if (isRecursive)
        {
            string[] dirs = Directory.GetDirectories(path);
            foreach (string dir in dirs)
            {
                paths.Add(dir.Replace('\\', '/'));
                Recursive(dir, isRecursive);
            }
        }
    }

    static void UpdateProgress(int progress, int progressMax, string desc)
    {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }
#endregion 工具方法区

    [MenuItem("Game/TransferChangedFilesBetweenVersions")]
    public static void TransferBetweenVersions()
    {
        UnityEngine.Debug.Log("CK : ------------------------------ TransferBetweenVersions start" );

        //string srcBaseDir = "";
        //string desBaseDir = "../../HappyCity/";
        string relativePathsFile = "Assets/Test/RelativePaths.txt";

        string[] paths = File.ReadAllLines(relativePathsFile);
        if (paths.Length < 2) return;
        string srcBaseDir = paths[0];
        string desBaseDir = paths[1];

        string srcPath = string.Empty;
        string desPath = string.Empty;
        string desDir = string.Empty;
        int copyCout = 0;
        foreach (var item in paths)
        {
            srcPath = srcBaseDir + item;
            if (!File.Exists(srcPath)) continue;

            desPath = desBaseDir + item;
            desDir = Path.GetDirectoryName(desPath);
            if (!Directory.Exists(desDir)) Directory.CreateDirectory(desDir);

            if (File.Exists(desPath)) File.Delete(desPath);
            File.Copy(srcPath,desPath,true);
            copyCout++;
        }

        UnityEngine.Debug.Log("CK : ------------------------------ TransferBetweenVersions completed, copyed file couts = " + copyCout);
        AssetDatabase.Refresh();
    }
	
	
    [MenuItem("Game/Reset Platform Prefers")]
    public static void ResetPlatformPrefers()
    {
        PlayerPrefs.DeleteAll();
		string config_cache_dir = "Assets/__BaseLobby/Resources/Texts";
        if (Directory.Exists(config_cache_dir))
        {
            string[] files = Directory.GetFiles(config_cache_dir);
            foreach (var item in files)
            {
                if (File.Exists(item)) File.Delete(item);
            }
        }

        AssetDatabase.Refresh();
    }

#region 修改所有UILabel的字体
    //[MenuItem("Game/ChangeUILabelFont")]
    public static void ChangeUILabelFont()
    {
        //Object obj = Selection.activeObject;
        foreach (var obj in Selection.objects)
        {
            if (obj is GameObject)
            {
                Object fontObj = AssetDatabase.LoadMainAssetAtPath("Assets/__BaseLobby/Build/BaseGame/HeiTi.ttf");
                Font font = fontObj as Font;
                //UnityEngine.Debug.Log("CK : ------------------------------ font = " + font  + ", fontobj = " + fontObj);

                GameObject gobj = (GameObject)obj;
                UILabel[] uilabels = gobj.GetComponentsInChildren<UILabel>(true);

                foreach (var item in uilabels)
                {
                    if (item.bitmapFont == null)
                        item.trueTypeFont = font;
                }

                EditorUtility.SetDirty(obj);
            }
        }

        UnityEngine.Debug.Log("CK : ------------------------------ change uilabel font done ");

    }

    //[MenuItem("Game/ChangeAllUILabelFont")]
    public static void ChangeAllUILabelFont()
    {
        //Object obj = Selection.activeObject;
        foreach (var path in AssetDatabase.GetAllAssetPaths())
        {
            Object obj = AssetDatabase.LoadMainAssetAtPath(path);
            if (obj is GameObject)
            {
                Object fontObj = AssetDatabase.LoadMainAssetAtPath("Assets/__BaseLobby/Build/BaseGame/HeiTi.ttf");
                Font font = fontObj as Font;
                //UnityEngine.Debug.Log("CK : ------------------------------ font = " + font + ", fontobj = " + fontObj);

                GameObject gobj = (GameObject)obj;
                UILabel[] uilabels = gobj.GetComponentsInChildren<UILabel>(true);

                foreach (var item in uilabels)
                {
                    if (item.bitmapFont == null)
                        item.trueTypeFont = font;
                }

                EditorUtility.SetDirty(obj);
            }
        }

        UnityEngine.Debug.Log("CK : ------------------------------ change all uifont heiti done ");
    }
#endregion 修改字体

#region 打包工具
    [MenuItem("Game/BuildPackage-Android Batch(Agent)")]
    public static void BuildAndroidPacks()
    {
        //string[] agentIds = File.ReadAllLines(Application.dataPath + "/__HappyCity/Editor/Agent_Id_config.txt");
        //string utils_path = Application.dataPath + "/__HappyCity/Scripts/Utils/Utils.cs";
        //string utils_txt = File.ReadAllText(utils_path);
        //string replace_src_txt = "private static string agent_Id =";
        //int index_agentId_start = utils_txt.IndexOf(replace_src_txt);
        //int index_agentId_end = utils_txt.IndexOf(";",index_agentId_start);

        //string utils_txt_before = utils_txt.Substring(0,index_agentId_start);
        //string utils_txt_after = utils_txt.Substring(index_agentId_end);

        //string result = string.Empty;
        //for (int i = 0; i < agentIds.Length; i++)
        //{
        //    result = utils_txt_before + replace_src_txt + "\"" + agentIds[i] + "\"" + utils_txt_after;
        //    File.WriteAllText(utils_path,result);
        //    AssetDatabase.Refresh();

        //    BulidTarget(agentIds[i], "Android");
        //}

        //result = utils_txt_before + replace_src_txt + "\"\"" + utils_txt_after;
        //File.WriteAllText(utils_path, result);
        //AssetDatabase.Refresh();

        JSONObject json = GetPackConfigJson();
        string[] agentIds = File.ReadAllLines(Application.dataPath + "/__BaseLobby/Editor/Agent_Id_config.txt");

        for (int i = 0; i < agentIds.Length; i++)
        {
            json["AgentId"] = new JSONObject { str = agentIds[i], type = JSONObject.Type.STRING };
            File.WriteAllText(Constants.Pack_Config_Path, json.ToString());
            AssetDatabase.Refresh();

            BulidTarget(agentIds[i], "Android");
        }

        json.RemoveField("AgentId");//非渠道包不能有这个
        File.WriteAllText(Constants.Pack_Config_Path, json.ToString());
        AssetDatabase.Refresh();
    }

    [MenuItem("Game/BuildPackage-IOS Batch(Agent)")]
    public static void BuildIOSPacks()
    {
        string xcode_build_path = EditorPrefs.GetString("xcode_build_path");
        string[] agentIds = File.ReadAllLines(Application.dataPath + "/__BaseLobby/Editor/Agent_Id_config.txt");

        //获取 xcode 下的 pack_config.txt 文件
        string pack_config_path = xcode_build_path + "/Data/Raw/Pack_Config.txt";
        JSONObject json = null;
        if (File.Exists(pack_config_path)) json = new JSONObject(File.ReadAllText(pack_config_path));
        else json = new JSONObject();
        
        for (int i = 0; i < agentIds.Length; i++)
        {
            EditorUtility.DisplayProgressBar("BuildPackage-IOS Batch(Agent)", "", (i + 0f) / agentIds.Length);
            //修改 Pack_Config.txt 文件
            json["AgentId"] = new JSONObject { str = agentIds[i], type = JSONObject.Type.STRING };
            File.WriteAllText(pack_config_path, json.ToString());

            string target_name = "game" + PlatformGameDefine.playform.GetPlatformPrefix() + "_" + Utils.version + (string.IsNullOrEmpty(agentIds[i]) ? string.Empty : "_" + agentIds[i])+".ipa";

            string target_dir = "BuildPackage" + "/IOS";
            string target_file = target_dir + "/" + target_name;
            if (Directory.Exists(target_dir))
            {
                if (File.Exists(target_file))
                {
                    File.Delete(target_file);
                }
            }
            else
            {
                Directory.CreateDirectory(target_dir);
            }

			string[] tempstrs = PlayerSettings.bundleIdentifier.Split ('.'); 
			string appName = tempstrs [tempstrs.Length-1]; 
			UnityEngine.Debug.Log("jun : ------------------------------ appName =="+appName);

			//打ios 包
			string luaexe = "sh";
			string args = "Assets/__BaseLobby/Editor/xcode_pack.sh " + xcode_build_path + " "+ Path.GetFullPath(target_file)+" "+appName;
			ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = luaexe;
            info.Arguments = args;
            info.WindowStyle = ProcessWindowStyle.Hidden;
            info.UseShellExecute = false;
            info.ErrorDialog = true;
            Util.Log(info.FileName + " " + info.Arguments);

            Process pro = Process.Start(info);
            pro.WaitForExit();
        }

        json.RemoveField("AgentId");//非渠道包不能有这个
        File.WriteAllText(pack_config_path, json.ToString());
        EditorUtility.ClearProgressBar();
    }

    //得到工程中所有场景名称
    static string[] SCENES = FindEnabledEditorScenes();

    //这里封装了一个简单的通用方法。
    static void BulidTarget(string name, string target)
    {
        string app_name = name;
        string target_dir = Application.dataPath + "/TargetAndroid";
        string target_name = app_name + ".apk";
        BuildTargetGroup targetGroup = BuildTargetGroup.Android;
        BuildTarget buildTarget = BuildTarget.Android;
        //string applicationPath = Application.dataPath.Replace("/Assets", "");

        if (target == "Android")
        {
            target_dir = "BuildPackage" + "/Android";
            target_name = "game"+ PlatformGameDefine.playform.GetPlatformPrefix() + "_" + Utils.version+ (string.IsNullOrEmpty(name) ? string.Empty : "_" + name)+".apk";//pp_name + ".apk";
            targetGroup = BuildTargetGroup.Android;
        }
        string target_file = target_dir + "/" + target_name;
        //每次build删除之前的残留
        if (Directory.Exists(target_dir))
        {
            if (File.Exists(target_file))
            {
                File.Delete(target_file);
            }
        }
        else
        {
            Directory.CreateDirectory(target_dir);
        }

        //==================这里是比较重要的东西=======================
        //switch (name)
        //{
        //    case "QQ":
        //        PlayerSettings.bundleIdentifier = "com.game.qq";
        //        PlayerSettings.bundleVersion = "v0.0.1";
        //        PlayerSettings.SetScriptingDefineSymbolsForGroup(targetGroup, "QQ");
        //        break;
        //    case "UC":
        //        PlayerSettings.bundleIdentifier = "com.game.uc";
        //        PlayerSettings.bundleVersion = "v0.0.1";
        //        PlayerSettings.SetScriptingDefineSymbolsForGroup(targetGroup, "UC");
        //        break;
        //    case "CMCC":
        //        PlayerSettings.bundleIdentifier = "com.game.cmcc";
        //        PlayerSettings.bundleVersion = "v0.0.1";
        //        PlayerSettings.SetScriptingDefineSymbolsForGroup(targetGroup, "CMCC");
        //        break;
        //}

        //==================这里是比较重要的东西=======================

        //开始Build场景，等待吧～
        GenericBuild(SCENES, target_file, buildTarget, BuildOptions.None);

    }

    private static string[] FindEnabledEditorScenes()
    {
        List<string> EditorScenes = new List<string>();
        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (!scene.enabled) continue;
            EditorScenes.Add(scene.path);
        }
        return EditorScenes.ToArray();
    }

    static void GenericBuild(string[] scenes, string target_dir, BuildTarget build_target, BuildOptions build_options)
    {
        EditorUserBuildSettings.SwitchActiveBuildTarget(build_target);
        string res = BuildPipeline.BuildPlayer(scenes, target_dir, build_target, build_options);

        if (res.Length > 0)
        {
            throw new System.Exception("BuildPlayer failure: " + res);
        }
    }


    private static JSONObject GetPackConfigJson()
    {
        JSONObject result = null;
        if (File.Exists(Constants.Pack_Config_Path)) result = new JSONObject(File.ReadAllText(Constants.Pack_Config_Path));
        else if (File.Exists(Pack_Config_EditorPath)) result = new JSONObject(Pack_Config_EditorPath);
        else result = new JSONObject();
        return result;
    }

    #endregion 打包工具

	#region 切换版本
	[MenuItem("Game/VersionSwitch/5.1")]
	public static void PlatformSwitch_5_1()
	{
		VersionSwitch("5.1",61);
	}
	[MenuItem("Game/VersionSwitch/5.2")]
	public static void PlatformSwitch_5_2()
	{
		VersionSwitch("5.2",62);
	}
	//切换版本 
	private static void VersionSwitch(string versionName,int versionCode)
	{  
		// version, versioncode 
		string plistPath = Path.Combine ("Assets/___HappyCityScripts/_PlatformSwitch/Scripts/Games/", "GameEntityAll.cs");
		string plistText = File.ReadAllText (plistPath);

		int tem1 = plistText.IndexOf ("versionCode =");

		int tem2 = plistText.IndexOf (";",tem1);
		plistText = plistText.Substring(0, tem1+13) + versionCode + plistText.Substring(tem2);

		tem1 = plistText.IndexOf ("versionName =");
		tem2 = plistText.IndexOf (";",tem1);
		plistText = plistText.Substring(0, tem1+13) +"\""+ versionName + "\""+plistText.Substring(tem2);
		 
		File.WriteAllText (plistPath,plistText);

		PlayerSettings.bundleVersion = versionName;
		PlayerSettings.Android.bundleVersionCode = versionCode;

		AssetDatabase.Refresh();
		UnityEngine.Debug.Log("ck debug : -------------------------------- 版本"+versionName+" 切换完成");
	}

	#endregion 切换版本
    #region 平台切换工具
    [MenuItem("Game/PlatformSwitch/597")]
    public static void PlatformSwitch_597()
    {
        PlatformSwitch("597");
    }

    [MenuItem("Game/PlatformSwitch/597wangwei")]
    public static void PlatformSwitch_597wangwei()
    {
        PlatformSwitch("597wangwei");
    }

    [MenuItem("Game/PlatformSwitch/131")]
    public static void PlatformSwitch_131()
    {
        PlatformSwitch("131");
    }

    [MenuItem("Game/PlatformSwitch/510k")]
    public static void PlatformSwitch_510k()
    {
        PlatformSwitch("510k");
    }

    [MenuItem("Game/PlatformSwitch/7997")]
    public static void PlatformSwitch_7997()
    {
        PlatformSwitch("7997");
    }

    //平台记录
    //#if Platform_597wangwei
    //#elif Platform_131
    //#elif Platform_510k
    //#elif Platform_7997
    //#else //Platform_597
    //#endif
    private static void PlatformSwitch(string platformName)
    {
        ResetPlatformPrefers();//重置平台数据
        string[] defineNames = new string[] {
            "Platform_597",
            "Platform_597wangwei",
            "Platform_131",
            "Platform_510k",
            "Platform_7997",
        };

        SetEnabled(defineNames,false);
        SetEnabled(new string[] { "Platform_"+platformName },true);

        if (platformName == "7997") return;//7997 不需要发布正式包

        //修改项目名称
        string projectName = platformName;
        if (projectName.Contains("597"))
        {
#if UNITY_IOS
            if (projectName == "597wangwei") projectName = "597棋牌游戏大厅";
            else projectName = "597棋牌游戏大厅老版本";
#else
            projectName = "597游戏";
#endif
        }
        else projectName += "游戏";
        PlayerSettings.productName = projectName;

        //修改平台图片
        string platformName_temp = platformName;
        if (platformName_temp == "597wangwei") platformName_temp = "597";
        StaticUtils.Copy("PlatformSwitch/Icons/" + platformName_temp + "/", "Assets/__BaseLobby/_PlatformSwitch/Images");//修改平台图片

        //设置bundleid, version, versioncode
        GameEntity entity = new GameEntityAll();
        PlayerSettings.bundleIdentifier = entity.BundleId;
        PlayerSettings.bundleVersion = entity.VersionName;
        PlayerSettings.Android.bundleVersionCode = entity.VersionCode;

        AssetDatabase.Refresh();
        UnityEngine.Debug.Log("ck debug : -------------------------------- 平台 "+platformName+" 切换完成");
    }

    private static void SetEnabled(string[] defineNames, bool enable)
    {
        BuildTargetGroup[] mobileBuildTargetGroups = new BuildTargetGroup[]
            {
                BuildTargetGroup.Standalone,
                BuildTargetGroup.Android,
                BuildTargetGroup.iOS,
                //BuildTargetGroup.WP8,
                //BuildTargetGroup.BlackBerry,
                //BuildTargetGroup.PSM,
                //BuildTargetGroup.Tizen,
                //BuildTargetGroup.WSA
            };

        //Debuger.Log("setting "+defineName+" to "+enable);
        foreach (var group in mobileBuildTargetGroups)
        {
            var defines = GetDefinesList(group);
            foreach (var defineName in defineNames)
            {
                if (enable)
                {
                    if (defines.Contains(defineName))
                    {
                        continue;
                    }
                    defines.Add(defineName);
                }
                else
                {
                    if (!defines.Contains(defineName))
                    {
                        continue;
                    }
                    while (defines.Contains(defineName))
                    {
                        defines.Remove(defineName);
                    }
                }
            }
            string definesString = string.Join(";", defines.ToArray());
            PlayerSettings.SetScriptingDefineSymbolsForGroup(group, definesString);
        }
    }


    private static List<string> GetDefinesList(BuildTargetGroup group)
    {
        return new List<string>(PlayerSettings.GetScriptingDefineSymbolsForGroup(group).Split(';'));
    }
#endregion 平台切换工具



#region 弃用或用不到的定义

#region 用于把所有View目录下的xxxPanel 添加到GameManager.lua中
    ////[MenuItem("Game/testPaths")]
    //private static void HandleGameManager_Lua() {
    //    string resPath = AppDataPath + "/StreamingAssets/";
    //    string luaPath = resPath + "/lua";
    //    List<string> resultList = new List<string>();
    //    CollectFiles(luaPath,"View", resultList);

    //    string resultStr = "";
    //    foreach (var item in resultList)
    //    {
    //        resultStr += "require \""+item.Substring(luaPath.Length+1).Replace("\\","/")+"\"\r\n";
    //    }

    //    string gameManagerPath = luaPath + "/Logic/GameManager.lua";

    //    resultStr += File.ReadAllText(gameManagerPath);
    //    File.WriteAllText(gameManagerPath, resultStr); 
    //}

    //private static void CollectFiles(string path,string patten,List<string> resultList) {
    //    if (Directory.Exists(path))
    //    {
    //        foreach (var item in Directory.GetFileSystemEntries(path))
    //        {
    //            CollectFiles(item,patten,resultList);
    //        }
    //    }
    //    else if (File.Exists(path))
    //    {
    //        if (path.Contains(patten) && !path.EndsWith(".meta"))
    //            resultList.Add(path);
    //    }
    //}
#endregion

#region 使用非Unity5 打AssetBundle 的方式,已弃用
    //static void HandleGameModules(string assetPath, BuildTarget target)
    //{
    //    Object mainAsset = null;        //主素材名，单个
    //    Object[] addis = null;     //附加素材名，多个
    //    string gameModele = string.Empty;
    //    string assetfile = string.Empty;  //素材文件名

    //    BuildAssetBundleOptions options = BuildAssetBundleOptions.UncompressedAssetBundle |
    //                                      BuildAssetBundleOptions.CollectDependencies |
    //                                      BuildAssetBundleOptions.DeterministicAssetBundle;
    //    string dataPath = Util.DataPath;
    //    if (Directory.Exists(dataPath))
    //    {
    //        Directory.Delete(dataPath, true);
    //    }
    //    
    //    if (Directory.Exists(assetPath))
    //    {
    //        Directory.Delete(assetPath, true);
    //    }
    //    MakeDirectory(assetPath);

    //    ///-----------------------------生成共享的关联性素材绑定-------------------------------------
    //    //BuildPipeline.PushAssetDependencies();

    //    //assetfile = assetPath + "shared.assetbundle";
    //    //mainAsset = LoadAsset("Shared/Atlas/Dialog.prefab");
    //    //BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);

    //    /////------------------------------生成PromptPanel素材绑定-----------------------------------
    //    //BuildPipeline.PushAssetDependencies();
    //    //mainAsset = LoadAsset("Prompt/Prefabs/PromptPanel.prefab");
    //    //addis = new Object[1];
    //    //addis[0] = LoadAsset("Prompt/Prefabs/PromptItem.prefab");
    //    //assetfile = assetPath + "promptpanel.assetbundle";
    //    //BuildPipeline.BuildAssetBundle(mainAsset, addis, assetfile, options, target);
    //    //BuildPipeline.PopAssetDependencies();

    //    /////------------------------------生成MessagePanel素材绑定-----------------------------------
    //    //BuildPipeline.PushAssetDependencies();
    //    //mainAsset = LoadAsset("Message/Prefabs/MessagePanel.prefab");
    //    //assetfile = assetPath + "messagepanel.assetbundle";
    //    //BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
    //    //BuildPipeline.PopAssetDependencies();

    //    /////-------------------------------刷新---------------------------------------
    //    //BuildPipeline.PopAssetDependencies();

    //    //--------------------BaseGame-------------------
    //    //HeiTi, Unlit-PreMultiplied Colored,Unlit-Transparent Colored, Platform_money, Tap, //Avatar
    //    BuildPipeline.PushAssetDependencies();
    //    {
    //        gameModele = "BaseGame";
    //        addis = new Object[4];
    //        mainAsset = AssetDatabase.LoadMainAssetAtPath("Assets/__HappyCity/Build/BaseGame/HeiTi.ttf");//HeiTi.ttf
    //        addis[0] = AssetDatabase.LoadMainAssetAtPath("Assets/__HappyCity/Build/BaseGame/Unlit - Premultiplied Colored.shader"); ;//Unlit-PreMultiplied Colored
    //        addis[1] = AssetDatabase.LoadMainAssetAtPath("Assets/__HappyCity/Build/BaseGame/Unlit - Transparent Colored.shader"); ;//Unlit-Transparent Colored
    //        addis[2] = AssetDatabase.LoadMainAssetAtPath("Assets/__HappyCity/_PlatformSwitch/Images/platform_money.png"); ;//Platform_money
    //        addis[3] = AssetDatabase.LoadMainAssetAtPath("Assets/__HappyCity/Build/BaseGame/Tap.wav"); ;//Tap
    //        //addis[4] = AssetDatabase.LoadMainAssetAtPath("Assets/_GameController/Build/HallPanel.prefab"); ;//Avatar
    //        assetfile = assetPath + gameModele + "/BaseGame.assetbundle";
    //        MakeDirectory(assetPath + gameModele);
    //        BuildPipeline.BuildAssetBundle(mainAsset, addis, assetfile, options, target);


    //        //--------------------HappyCity-------------------
    //        //atlas Avatar
    //        gameModele = "HappyCity";
    //        addis = new Object[4];
    //        mainAsset = AssetDatabase.LoadMainAssetAtPath("Assets/__HappyCity/Build/Atlas/avatar.prefab");//Avatar
    //        //assetfile = assetPath + gameModele + "/BaseGame.assetbundle";
    //        assetfile = assetPath + gameModele + "/" + mainAsset.name + ".assetbundle";
    //        MakeDirectory(assetPath + gameModele);
    //        BuildPipeline.BuildAssetBundle(mainAsset, addis, assetfile, options, target);

    //        //atlas modules
    //        gameModele = "HappyCity";
    //        addis = new Object[4];
    //        mainAsset = AssetDatabase.LoadMainAssetAtPath("Assets/__HappyCity/Build/Atlas/modules.prefab");//modules
    //        assetfile = assetPath + gameModele + "/" + mainAsset.name + ".assetbundle";
    //        MakeDirectory(assetPath + gameModele);
    //        BuildPipeline.BuildAssetBundle(mainAsset, addis, assetfile, options, target);

    //        //atlas login
    //        gameModele = "HappyCity";
    //        addis = new Object[4];
    //        mainAsset = AssetDatabase.LoadMainAssetAtPath("Assets/__HappyCity/Build/Atlas/Atlas_Login.prefab");//Atlas_Login
    //        assetfile = assetPath + gameModele + "/" + mainAsset.name + ".assetbundle";
    //        MakeDirectory(assetPath + gameModele);
    //        BuildPipeline.BuildAssetBundle(mainAsset, addis, assetfile, options, target);

    //        string[] allPaths = AssetDatabase.GetAllAssetPaths();
    //        foreach (var item in allPaths)
    //        {
    //            if (!item.Contains("Assets/__HappyCity/Build/") || !File.Exists(item) || !Path.GetDirectoryName(item).EndsWith("Build")) continue;
    //            BuildPipeline.PushAssetDependencies();
    //            gameModele = "HappyCity";
    //            mainAsset = AssetDatabase.LoadMainAssetAtPath(item);
    //            assetfile = assetPath + gameModele + "/" + mainAsset.name + ".assetbundle";
    //            MakeDirectory(assetPath + gameModele);
    //            BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
    //            BuildPipeline.PopAssetDependencies();
    //        }

    //        //HallPanel
    //        //BuildPipeline.PushAssetDependencies();
    //        //{
    //        //    //gameModele = "HappyCity";
    //        //    mainAsset = AssetDatabase.LoadMainAssetAtPath("Assets/_GameController/Build/HallPanel.prefab");
    //        //    assetfile = assetPath + gameModele + "/HallPanel.assetbundle";
    //        //    MakeDirectory(assetPath + gameModele);
    //        //    BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
    //        //}
    //        //BuildPipeline.PopAssetDependencies();


    //        //--------------------GameMXNN-------------------
    //        BuildPipeline.PushAssetDependencies();
    //        {
    //            gameModele = "GameMXNN";
    //            mainAsset = AssetDatabase.LoadMainAssetAtPath("Assets/_GameMXNN/Build/GameMXNNPanel.prefab");//LoadAsset("Prompt/Prefabs/PromptPanel.prefab");
    //            assetfile = assetPath + gameModele + "/" + mainAsset.name + ".assetbundle";
    //            MakeDirectory(assetPath + gameModele);
    //            BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
    //        }
    //        BuildPipeline.PopAssetDependencies();

    //        //--------------------BameTBNN-------------------
    //        BuildPipeline.PushAssetDependencies();
    //        {
    //            gameModele = "GameTBNN";
    //            mainAsset = AssetDatabase.LoadMainAssetAtPath("Assets/_GameTBNN/Build/GameTBNNPanel.prefab");//LoadAsset("Prompt/Prefabs/PromptPanel.prefab");
    //            assetfile = assetPath + gameModele + "/" + mainAsset.name + ".assetbundle";
    //            MakeDirectory(assetPath + gameModele);
    //            BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
    //        }
    //        BuildPipeline.PopAssetDependencies();

    //        //--------------------GameSRNN-------------------
    //        BuildPipeline.PushAssetDependencies();
    //        {
    //            gameModele = "GameSRNN";
    //            mainAsset = AssetDatabase.LoadMainAssetAtPath("Assets/_GameSRNN/Build/GameSRNNPanel.prefab");//LoadAsset("Prompt/Prefabs/PromptPanel.prefab");
    //            assetfile = assetPath + gameModele + "/" + mainAsset.name + ".assetbundle";
    //            MakeDirectory(assetPath + gameModele);
    //            BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
    //        }
    //        BuildPipeline.PopAssetDependencies();
    //    }
    //    BuildPipeline.PopAssetDependencies();
    //}
#endregion 使用非Unity5 打AssetBundle 的方式,已弃用

#region ulua自带方法和字段,没有用到
    ///-----------------------------------------------------------
    static string[] exts = { ".txt", ".xml", ".lua", ".assetbundle", ".json" };
    static bool CanCopy(string ext)
    {   //能不能复制
        foreach (string e in exts)
        {
            if (ext.Equals(e)) return true;
        }
        return false;
    }

    /// <summary>
    /// 载入素材
    /// </summary>
    static UnityEngine.Object LoadAsset(string file)
    {
        if (file.EndsWith(".lua")) file += ".txt";
        return AssetDatabase.LoadMainAssetAtPath("Assets/Examples/Builds/" + file);
    }
#endregion ulua自带方法,没有用到

#region 当前项目不需要
    //[MenuItem("Game/Build Protobuf-lua-gen File")]
    //public static void BuildProtobufFile() {
    //    if (!AppConst.ExampleMode) {
    //        Debugger.LogError("若使用编码Protobuf-lua-gen功能，需要自己配置外部环境！！");
    //        return;
    //    }
    //    string dir = AppDataPath + "/Lua/3rd/pblua";
    //    paths.Clear(); files.Clear(); Recursive(dir);

    //    string protoc = "d:/protobuf-2.4.1/src/protoc.exe";
    //    string protoc_gen_dir = "\"d:/protoc-gen-lua/plugin/protoc-gen-lua.bat\"";

    //    foreach (string f in files) {
    //        string name = Path.GetFileName(f);
    //        string ext = Path.GetExtension(f);
    //        if (!ext.Equals(".proto")) continue;

    //        ProcessStartInfo info = new ProcessStartInfo();
    //        info.FileName = protoc;
    //        info.Arguments = " --lua_out=./ --plugin=protoc-gen-lua=" + protoc_gen_dir + " " + name;
    //        info.WindowStyle = ProcessWindowStyle.Hidden;
    //        info.UseShellExecute = true;
    //        info.WorkingDirectory = dir;
    //        info.ErrorDialog = true;
    //        Util.Log(info.FileName + " " + info.Arguments);

    //        Process pro = Process.Start(info);
    //        pro.WaitForExit();
    //    }
    //    AssetDatabase.Refresh();
    //}
#endregion 当前项目不需要

#endregion 弃用或用不到的定义
}
