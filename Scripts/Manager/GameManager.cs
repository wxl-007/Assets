#define _IsDevelop

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Reflection;
using System.IO;
//using Junfine.Debuger;

namespace SimpleFramework.Manager
{

    /// <summary>
    /// 热更新 分成 资源更新和资源下载2部分 更新部分目前必须在启动游戏前完成, 下载部分目前放在游戏开始后进行
    /// 资源更新部分仅仅把下载好的资源移动到DataPath目录下
    /// 资源下载把云端的资源下载到DownloadPath目录下
    /// 把热更新分成2部分,分开处理的原因是避免在游戏开始前下载资源,把用户挡在游戏外面
    /// </summary>
    public class GameManager : LuaBehaviour
    {//不要把GameManager 写进 Wrapfile 里
         
#if UNITY_EDITOR
        //public static bool m_IsStreamingAssetExtract = false;//true : 把StreamingAssets 目录抽取成打包时需要的目录结构(删除不用随包发布的资源(DefaultGameModuleList中没有的游戏模块)), false : 不抽取
        //public static bool m_SaveAssetBundle = false;//true: 保存并使用AssetBundle 打包的配置文件信息(把打包生成的assetpath 复制一份保存) false: 不保存 | 该功能可以加速正式包发布测试时,打包的速度
        public static bool m_IsServerUrl = false;//(默认false)是否使用服务端地址更新 assetbundle, false 则使用本地资源
        public static int _VersionControl_ali = 0;//(默认0)用于设置本地测试用的 VersionControl 的版本号 该值大于0 才有效, 否则使用 阿里云上的VersionControl的值

#if _IsDevelop
        public const bool LuaEncode = false;
#else
        public const bool LuaEncode = true;                        //使用LUA编码//开发是不用编码,资源包的时候可以加快速度
#endif
#endif
#if _IsDevelop
        public const bool _IsDevelop = true;
#endif

        
        

        private List<string> downloadFiles = new List<string>();
        //private System.Action m_Init;//游戏没有接入lua前 原来的入口函数//

        public static bool _IsExtractCompleted = false;
        public static bool _IsUpdateCompleted = false;

        #region 生命周期函数
        /// <summary>
        /// 初始化游戏管理器
        /// </summary>
        void Awake()
        {
            //if (AddTest()) return;//用于ios 发布后才会出现的错误的检测
            Init();
            base.Awake();//这里会调用lua相关的内容,而lua需要在上面的init里面启动
        }


        void OnUpdateFailed(string file)
        {
            string message = "更新失败!>" + file;
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
        }

        void Update()
        {
            if (LuaManager != null && initialize)
            {
                LuaManager.Update();
            }
        }

        void LateUpdate()
        {
            if (LuaManager != null && initialize)
            {
                LuaManager.LateUpate();
            }
        }

        void FixedUpdate()
        {
            if (LuaManager != null && initialize)
            {
                LuaManager.FixedUpdate();
            }
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        void OnDestroy()
        {
            //if (NetManager != null) {
            //    NetManager.Unload();
            //}

            //if (LuaManager != null)
            //{
            //    LuaManager.Destroy();
            //}
            base.OnDestroy();
            DownloadHelper.CloseAll();
            Debug.Log("~GameManager was destroyed");
        }
        #endregion 生命周期函数

        #region 初始化, 包含了 loading界面初始化,解压资源和更新资源
        /// <summary>
        /// 初始化
        /// </summary>
        void Init()
        {
            string str = Constants.Pack_Config_Path;//初始化 Constants//实际上这里的 str 并没有起作用
            Utils.InitPackConfig(this);
            DontDestroyOnLoad(gameObject);  //防止销毁自己
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Application.targetFrameRate = AppConst.GameFrameRate;

            //初始化loading界面
            //InitLoading(() =>
            //{
                UnityEngine.Debug.Log("CK : ------------------------------ extract = " + 0);
#if !_IsDevelop
                if (Utils.version == PlayerPrefs.GetString("instantUpdateVersion", "") && File.Exists(Constants.DataPath + Constants.Config_File))
                {//解压过了,不用再解压
                    _IsExtractCompleted = true;
                    StartCoroutine(DoInstantUpdate());
                }
                else
#endif
            Extract_lua_FromAssetBundle(()=> {//首先解压luaassetbundle
                if (Directory.Exists(Constants.DownloadPath))
                {//需要解压,也就是大版本更新,大版本更新就把 热更新的目录下的资源全部删除,避免大版本更新后进行小版本热更新 导致资源错误
                    Directory.Delete(Constants.DownloadPath, true);
                    StaticUtils.SetDownloadCloudAssetsComplete(false);
                }
                //解压点击热更新配置(版本的完整配置)
                TextAsset textAsset = Resources.Load<TextAsset>(Constants.ClickDownload_Config_res);
                string clickDownload_Config_dir = Path.GetDirectoryName(Constants.ClickDownload_Config_data);
                if (!Directory.Exists(clickDownload_Config_dir)) Directory.CreateDirectory(clickDownload_Config_dir);
                if(textAsset!=null)File.WriteAllText(Constants.ClickDownload_Config_data,textAsset.text);

                this.ExtractGame((error1,config1)=> //解压大厅部分(该部分必须在游戏开始前完成)
                {
                    if (error1 != null)
                    {
                        Debug.LogWarning("解包出错了 : " + error1);
                        //EginProgressHUD.Instance.ShowPromptHUD("解包出错了 : " + error, 3f);
                    }
                    else
                    {
                        PlayerPrefs.SetString("instantUpdateVersion", "");//游戏异步解压,会导致为解压完就出现下载热更新资源的bug//这样设置即可保证在解压完成后才进行资源热更新的下载
                        PlayerPrefs.Save();
                        StartCoroutine(DoInstantUpdate());
                        //解压所有资源
                        this.ExtractGame((error, config) =>//解压游戏部分(该部分可以在大厅内完成)
                                {

                                    UnityEngine.Debug.Log("CK : ------------------------------ extract = " + 1);
                                    if (error != null)
                                    {
                                        Debug.LogWarning("解包出错了 : " + error);
                                        //EginProgressHUD.Instance.ShowPromptHUD("解包出错了 : " + error, 3f);
                                    }
                                    else
                                    {
                                        PlayerPrefs.SetString("instantUpdateVersion", Utils.version);
                                        PlayerPrefs.Save();
                                        _IsExtractCompleted = true;
                                        //StartCoroutine(DoInstantUpdate());
                                    }
                                }, new List<string>() { ":lua"});
                    }
                }, new List<string>() { "baselobby", Utils._hallResourcesName, ":lua", "" });//以冒号开头代表忽略 //"happycity"
            });

            //});//初始化 loading 界面
        }


        public void Extract_lua_FromAssetBundle(System.Action onComplete)
        {
#if UNITY_EDITOR && _IsDevelop
            Debug_Lua_only();
            if(onComplete != null) onComplete();
            return;
#else

            string src = Constants.StreamingAssetsDataPath + "lua/lua.assetbundle";
            string des = Constants.DataPath;
            string lua_path = des + "lua";
            if (Directory.Exists(lua_path)) Directory.Delete(lua_path, true);

            StartCoroutine(DoLoadAssetBundle(src,ab=>{

                string[] abNames = ab.GetAllAssetNames();
                string savePath = string.Empty;
                string dir = string.Empty ;

                for (int i = 0; i < abNames.Length; i++)
                {
                    savePath = abNames[i];
                    if (savePath.EndsWith(".bytes")) savePath = savePath.Replace(".bytes","");
                    savePath = des + savePath.Substring(savePath.IndexOf("/lua/") + 1);

                    dir = Path.GetDirectoryName(savePath);
                    if (!Directory.Exists(dir)) Directory.CreateDirectory(dir); 

                    File.WriteAllBytes(savePath, ab.LoadAsset<TextAsset>(abNames[i]).bytes);
                }

                if (onComplete != null) onComplete();

                ab.Unload(true);
            }));
#endif
        }

        IEnumerator DoInstantUpdate()
        {
            UnityEngine.Debug.Log("CK : ------------------------------ update = " + 0);
            //while (!_IsExtractCompleted) yield return new WaitForEndOfFrame();
            yield return 0;

            UnityEngine.Debug.Log("CK : ------------------------------ update = " + 1);
#if _IsDevelop
            OnResourceInited();
#else
            //热更新,资源更新
            if (File.Exists(Constants.DownloadPath + Constants.Config_File) && StaticUtils.GetDownloadCloudAssetComplete())
            {
                this.UpdateInstantUpdateConfig(null,(error,json)=> {//更新热更新下来的配置文件, 热更新升级以后 如果直接覆盖会导致点击下载下来的模块(在原来的配置文件上有, 热更新地址下的配置文件还不存在) 被覆盖掉, 变成没有. 所有需要先更新热更新下来的配置文件到原地址的配置文件上
                    if (error != null)
                    {//出错了
                        //if (Constants.isEditor)
                            UnityEngine.Debug.LogError("ck debug : ----------------DoInstantUpdate---------------- 热更新配置文件更新出错, error = " + error);

                        //EginProgressHUD.Instance.ShowPromptHUD("热更新配置文件更新出错, error = " + error);//lua 还没有启动
                    }
                    else
                    {
                        StaticUtils.Move(Constants.DataPath + Constants.Config_File, Constants.DownloadPath);//覆盖掉DownloadPath的配置文件

                        StaticUtils.Move(Constants.DownloadPath, Constants.DataPath);

                        UnityEngine.Debug.LogError("ck debug : ----------------DoInstantUpdate---------------- 更新完成 ");
                    }

                    OnResourceInited();
                });
            }
            else
            {
                OnResourceInited();
            }
#endif
        }
        #endregion 初始化, 包含了 loading界面初始化,解压资源和更新资源

        #region 加载 Loading 界面,该界面需要在检测更新前就被加载
        void InitLoading(System.Action onComplete = null)
        {
            StartCoroutine(DoLoadLoadingAssetBundleMap((loadingBundleMap) =>
            {
                GameObject progressGobj = GameObject.Instantiate(loadingBundleMap["progresshud"].LoadAsset<GameObject>("progresshud")); //添加 ProgressHUD, loading 界面销毁后,这个物体也销毁
                GameObject prefab = loadingBundleMap["loading"].LoadAsset<GameObject>("loading");//获取loading预制
                GameObject loadingPanel = NGUITools.AddChild(facade.GetManager<PanelManager>(ManagerName.Panel).Parent.gameObject, prefab);//添加loading界面

                foreach (var item in loadingBundleMap)
                {
                    item.Value.Unload(false);//释放AssetBundle资源
                }

                Loading loading = GameObject.FindObjectOfType<Loading>();
                if (loading != null)
                {
                    //m_Init = loading.Init;//赋值, 原先的入口函数
                    loading._InstantUpdateAction = () => StartCoroutine(DoInstantUpdate());

                    loading._IsInstantUpdateCompleted = () => _IsUpdateCompleted;

                    loading._OnDestroyAction = () =>//在该loading界面销毁后,销毁资源
                    {
                        Destroy(progressGobj);
                        progressGobj = null;

                        Destroy(loadingPanel);
                        loadingPanel = null;
                        prefab = null;
                        //foreach (var item in loadingBundleMap)
                        //{
                        //    item.Value.Unload(true);//释放AssetBundle及AssetBundle中加载出来的所有资源
                        //}
                        Resources.UnloadUnusedAssets();
                        loadingBundleMap.Clear();
                    };
                }
                loading = null;
                if (onComplete != null) onComplete();
            }));
        }

        IEnumerator DoLoadLoadingAssetBundleMap(System.Action<Dictionary<string, AssetBundle>> onComplete)
        {
            List<string> loadingBundleNameList = new List<string>() {//先添加依赖,再添加loading界面
                "progresshud",
                "basegame",
                "atlas_login",
                "loading",
            };

            Dictionary<string, AssetBundle> loadingBundleMap = new Dictionary<string, AssetBundle>();
            foreach (var item in loadingBundleNameList)
            {//happycity
                yield return StartCoroutine(DoLoadAssetBundle(Util.AppContentPath() + Utils._hallResourcesName + "/" + item + ".assetbundle", (bundle) =>
                {
                    loadingBundleMap[item] = bundle;
                }));
            }

            yield return 0;

            if (onComplete != null) onComplete(loadingBundleMap);
        }

        /// <summary>
        /// 加载StreamingAssets 目录下的assetbundle
        /// </summary>
        /// <param name="uri"></param>
        /// <param name="onComplete"></param>
        /// <returns></returns>
        IEnumerator DoLoadAssetBundle(string uri, System.Action<AssetBundle> onComplete)
        {
            AssetBundle resultBundle = null;

            if (Application.platform == RuntimePlatform.Android)
            {
                WWW www = new WWW(uri);
                yield return www;
                if (www.error != null)
                {
                    yield break;
                }
                else
                {
                    if (www.isDone)
                    {
                        //resultBundle = www.assetBundle;
                        resultBundle = AssetBundle.LoadFromMemory(StaticUtils.Crypt(www.bytes));
                    }
                }
            }
            else
            {
                byte[] stream = File.ReadAllBytes(uri);
                resultBundle = AssetBundle.LoadFromMemory(StaticUtils.Crypt(stream));
            }

            if (onComplete != null) onComplete(resultBundle);
        }
        #endregion 加载 Loading 界面,该界面需要在检测更新前就被加载

        #region 启动 lua
        /// <summary>
        /// 资源初始化结束
        /// </summary>
        public void OnResourceInited()
        {
            //InitGui();

            LuaManager.Start();
            //LuaManager.DoFile("Logic/Network");       //加载网络
            LuaManager.DoFile("Logic/GameManager");    //加载游戏

            _IsUpdateCompleted = true;
            initialize = true;                     //初始化完 

            CallMethod("OnInitOK");   //初始化完成

            //if (m_Init != null) m_Init();
        }
        #endregion 启动 lua

        #region hall 中单个游戏模块下载,进度条显示
        private GameObject m_Download_Progress_Bar_Prefab;
        private GameObject _Download_Progress_Bar_Prefab
        {
            get
            {//HappyCity
                if (m_Download_Progress_Bar_Prefab == null) m_Download_Progress_Bar_Prefab = ResManager.LoadAsset(Utils._hallResourcesName + "/Hall", "Download_Progress_Bar") as GameObject;
                return m_Download_Progress_Bar_Prefab;
            }
        }
        private Dictionary<string, float> m_Download_ProgressMap = new Dictionary<string, float>();
        private Dictionary<string, float> m_Download_Btn_ProgressMap = new Dictionary<string, float>();
        private Dictionary<string, UISlider> m_Download_SliderMap = new Dictionary<string, UISlider>();
        private Dictionary<string, Transform> m_Download_ParentTransMap = new Dictionary<string, Transform>();

        //add 2016.03.22 for lua
        public void CheckHallGameModuleDownloadProgress(LuaTable luaTb, bool fromLua)
        {
            Dictionary<string, Transform> moduleDc = new Dictionary<string, Transform>();
            foreach (string key in luaTb.Keys)
            {
                moduleDc[key] = luaTb[key] as Transform;
            }
            CheckHallGameModuleDownloadProgress(moduleDc);
        }

        public void CheckHallGameModuleDownloadProgress(Dictionary<string, Transform> gameModuleDownloadParentTransMap)
        {
            m_Download_ParentTransMap = gameModuleDownloadParentTransMap;
            foreach (var item in m_Download_ParentTransMap)
            {
                string btnGameModule = item.Key;
                if (m_Download_Btn_ProgressMap.ContainsKey(btnGameModule))
                {//游戏正在下载,添加游戏下载进度条
                    AddDownloadProgressBar(item.Key, item.Value.gameObject);
                }
            }
        }

        public void UpdateHallGameModuleDownloadProgress(string btnGameModule, string gameModule, float progress)
        {
            m_Download_ProgressMap[gameModule] = progress;
            m_Download_Btn_ProgressMap[btnGameModule] = progress;

            if (progress >= 1 || progress < 0)
            {//下载完成或下载失败,删除progressbar
                //UnityEngine.Debug.Log("CK : ------------------------------ progress = " + progress);

                if (m_Download_ProgressMap.ContainsKey(gameModule)) m_Download_ProgressMap.Remove(gameModule);
                if (m_Download_Btn_ProgressMap.ContainsKey(btnGameModule)) m_Download_Btn_ProgressMap.Remove(btnGameModule);
                if (m_Download_SliderMap.ContainsKey(btnGameModule))
                {
                    if (m_Download_SliderMap[btnGameModule]) Destroy(m_Download_SliderMap[btnGameModule].gameObject);
                    m_Download_SliderMap.Remove(btnGameModule);
                }

                return;
            }

            if (m_Download_ParentTransMap.ContainsKey(btnGameModule) && m_Download_ParentTransMap[btnGameModule])
            {
                if (m_Download_SliderMap.ContainsKey(btnGameModule) && m_Download_SliderMap[btnGameModule] != null) m_Download_SliderMap[btnGameModule].value = progress;
                else if (m_Download_ParentTransMap.ContainsKey(btnGameModule)) AddDownloadProgressBar(btnGameModule, m_Download_ParentTransMap[btnGameModule].gameObject);
            }
        }

        public string GetGameModuleName(string gameModule)
        {
            return PanelManager.GameModule_Name_Map.ContainsKey(gameModule) ? PanelManager.GameModule_Name_Map[gameModule] : "";
        }

        public bool IsGameModuleDownloading(string gameModule)
        {
            return m_Download_ProgressMap.ContainsKey(gameModule);
        }

        void AddDownloadProgressBar(string btnGameModule, GameObject parent)
        {
            m_Download_SliderMap[btnGameModule] = NGUITools.AddChild(parent, _Download_Progress_Bar_Prefab).GetComponent<UISlider>();
            m_Download_SliderMap[btnGameModule].transform.localPosition = _Download_Progress_Bar_Prefab.transform.localPosition;
            m_Download_SliderMap[btnGameModule].value = m_Download_Btn_ProgressMap[btnGameModule];
        }
        #endregion hall 中单个游戏模块下载,进度条显示

        #region 注掉不用了
        //static bool AddTest()
        //{
        //    if (File.Exists(Constants.DataPath + "error.txt"))
        //    {
        //        string error = File.ReadAllText(Constants.DataPath + "error.txt");
        //        GameObject prefab = Resources.Load("TestError") as GameObject;
        //        GameObject.Instantiate(prefab);
        //        FindObjectOfType<UILabel>().text = error;
        //        return true;
        //    }
        //    Application.logMessageReceived += (condition, stackTrace, type) => {
        //        if (type == LogType.Error || type == LogType.Exception)
        //        {
        //            string log = " : condition = " + condition + "\r\n : StackTrace = " + stackTrace + "\r\n : type = " + type+ "--------------------------------------\r\n";
        //            Debug.Log("------------------------------------------- error log = " + log);
        //            File.AppendAllText(Constants.DataPath + "error.txt", log);
        //        }
        //    };

        //    return false;
        //}
        #endregion 注掉不用了


        #region 辅助方法
        public static void Debug_Lua_only()
        {
            string src = Application.dataPath + "/lua";
            string des = Constants.DataPath + "";
            if (!Directory.Exists(des)) Directory.CreateDirectory(des);
            StaticUtils.Copy(src, des);
        }
        #endregion 辅助方法
    }
}