using UnityEngine;
using System.Collections;
using System.IO;
using SimpleFramework.Manager;
using LuaInterface;
using SimpleFramework;
using System.Collections.Generic;
using Junfine.Debuger;
using UnityEngine.SceneManagement;


public class LRDDZ_ResourceManager : MonoBehaviour
    {
    public bool IsExtractCompleted { get { return SimpleFramework.Manager.GameManager._IsExtractCompleted; } }
    private string password = "shengyou";
    const string szAssetPrefix = "Assets/_GameLRDDZ/Build/";
    private static Dictionary<string, Object> m_mapObject;

    private static float m_progress = 1.0f;
    /// <summary>
    /// 鱼和路径要预先加载，才能让鱼时不会卡
    /// </summary>
    //private static string[] routePath = { "gamelrddz/characterplayer1", "gamelrddz/characterplayer2", "gamelrddz/charactercomputer1", "gamelrddz/charactercomputer2", "gamelrddz/particle.assetbundle", };
    //private static string[] routePath = {  "gamelrddz/particle.assetbundle", "gamelrddz/character", };
    private static string[] routePath = { "gamelrddz/particle.assetbundle", };
    //private static string[] routePath = { };
    //private enum AssetBundleType {  Particle = 0, Character, None }
    private enum AssetBundleType { Particle = 0, None }
    private static float[] resourceWeight = { 1 };

    private static LRDDZ_ResourceManager _instance;
    public static LRDDZ_ResourceManager Instance
    {
        get
        {
            if (!_instance)
            {
                _instance = GameObject.FindObjectOfType(typeof(LRDDZ_ResourceManager)) as LRDDZ_ResourceManager;
                if (!_instance)
                {
                    GameObject container = new GameObject();
                    container.name = "LRDDZ_ResourceManager";
                    _instance = container.AddComponent(typeof(LRDDZ_ResourceManager)) as LRDDZ_ResourceManager;
                    DontDestroyOnLoad(container);
                }
            }
            return _instance;
        }
    }
    public static float getProgress() { return m_progress; }

    public static string getAppPath(string szLocalPath)
    {
        string path = "";
#if UNITY_EDITOR
        path = Application.dataPath + "/" + szLocalPath;
#elif UNITY_STANDALONE_WIN
        path = Application.dataPath + "/StreamingAssets/" + szLocalPath;
#elif UNITY_IPHONE
        path = Application.dataPath + "/Raw/" + szLocalPath;
#elif UNITY_ANDROID
        path = "jar:file://" + Application.dataPath + "!/assets/" + szLocalPath;
#endif
        return path;
    }

    private int getAssetBundleType(string resourceName)
    {
        for (int i = 0; i < routePath.Length; i++)
        {
            if (routePath[i] == resourceName)
                return i;
        }
        return -1;
    }

    public static Object LoadNeedAsset(string szAssetBundle, string szAssetName)
    {
#if UNITY_EDITOR
        if (string.IsNullOrEmpty(szAssetName) == false)
        {
            if (szAssetBundle.ToLower() != szAssetName.ToLower())
            {
                szAssetBundle += "/";
                szAssetName = szAssetPrefix + szAssetBundle + szAssetName + ".prefab";
            }
            else
                szAssetName = szAssetPrefix + szAssetBundle + ".prefab";
        }
        return UnityEditor.AssetDatabase.LoadAssetAtPath<Object>(szAssetName);
         
#endif
        Object obj = null;
        szAssetName = szAssetName.ToLower().Replace('\\', '/');
        if (m_mapObject == null)
        {
            Debug.LogError("m_mapObject is null, have not load resource?");
            return null;
        }
        string tempname = szAssetName + ".prefab";
        if (szAssetName.ToLower() != szAssetBundle.ToLower()) tempname = szAssetBundle.ToLower() + "/" + tempname;
        if (m_mapObject.TryGetValue(tempname, out obj) == false)
        {
            obj = LoadAsset(szAssetBundle, szAssetName);
            if (obj != null && m_mapObject.ContainsKey(szAssetName) == false)
            {
                m_mapObject.Add(szAssetName, obj);
            }
            else
            {
                Debug.Log("找到");
            }
        }
        return obj;
    }
    /// <summary>
    /// 加载图片
    /// </summary>
    /// <param name="szAssetBundle"></param>
    /// <param name="textureNmae"></param>
    /// <returns></returns>
    public static Texture LoadTexture( string szAssetBundle,string textureNmae)
    {
        Texture obj = null;
#if UNITY_EDITOR
        if (string.IsNullOrEmpty(textureNmae) == false)
        {
            if (szAssetBundle.ToLower() != textureNmae.ToLower())
            {
                szAssetBundle += "/";
                textureNmae = szAssetPrefix + szAssetBundle + textureNmae + ".png";
            }
            else
                textureNmae = szAssetPrefix + szAssetBundle + ".png";
        }
        obj = UnityEditor.AssetDatabase.LoadAssetAtPath<Texture>(textureNmae);
        return obj;
#endif
        szAssetBundle = "gamelrddz/" + szAssetBundle + ".assetbundle";

        //szAssetBundle = szAssetBundle.ToLower();
        //AssetBundle bundle = LoadAssetBundle(szAssetBundle);
        //string assetname = Path.GetFileName(szAssetName);
        //return bundle.LoadAsset(assetname);

        obj = SimpleFramework.LuaHelper.GetResManager().LoadAsset(szAssetBundle, Path.GetFileName(textureNmae)) as Texture;
        return obj;
    }
    public static Object LoadAsset(string szAssetBundle, string szAssetName)
    {
        Object obj = null;
#if UNITY_EDITOR
        if (string.IsNullOrEmpty(szAssetName) == false)
        {
            if (szAssetBundle.ToLower() != szAssetName.ToLower())
            {
                szAssetBundle += "/";
                szAssetName = szAssetPrefix + szAssetBundle + szAssetName + ".prefab";
            }
            else
                szAssetName = szAssetPrefix + szAssetBundle + ".prefab";
        }
        obj = UnityEditor.AssetDatabase.LoadAssetAtPath<Object>(szAssetName);
        return obj;
#endif
        szAssetBundle = "gamelrddz/" + szAssetBundle + ".assetbundle";

            //szAssetBundle = szAssetBundle.ToLower();
            //AssetBundle bundle = LoadAssetBundle(szAssetBundle);
            //string assetname = Path.GetFileName(szAssetName);
            //return bundle.LoadAsset(assetname);

            obj = SimpleFramework.LuaHelper.GetResManager().LoadAsset(szAssetBundle, Path.GetFileName(szAssetName));
        
        return obj;
    }

    public static Object loadAsset(string szPrefab)
    {
        string abName = "";
        string assetName = "";
        int abIndex = szPrefab.IndexOf('/');
        if (abIndex != -1)
        {
            abName = szPrefab.Substring(0, abIndex);
            assetName = szPrefab.Substring(abIndex + 1, szPrefab.Length - abIndex - 1);
        }
        return LoadAsset(abName, assetName);
    }

    public static void UnLoadAssetBundle(string szAssetBundle, bool unloadAllLoadedObjects)
    {
        
            szAssetBundle = szAssetBundle.ToLower();
            szAssetBundle = "gamelrddz/" + szAssetBundle + ".assetbundle";
            SimpleFramework.Manager.ResourceManager resManager = SimpleFramework.LuaHelper.GetResManager();
            AssetBundle assetBundle = null;
            resManager.bundles.TryGetValue(szAssetBundle, out assetBundle);
            if (assetBundle != null)
            {
                assetBundle.Unload(unloadAllLoadedObjects);
                resManager.bundles.Remove(szAssetBundle);
                Debug.Log("unload assetBundle:" + szAssetBundle);
            }
            else
            {
                Debug.LogError("can not find assetBundle:" + szAssetBundle);
            }
        
    }

    public void LoadNeedAssetAsync()
    {
        StartCoroutine(LoadAllNeedAsset());
    }

    private IEnumerator LoadAllNeedAsset()
    {
        /// 新建资源库
        if (m_mapObject == null) m_mapObject = new Dictionary<string, Object>();
        else yield break;
        m_progress = 0f;
        int nAssetBundlesCount = routePath.Length;
        for (int i = 0; i < nAssetBundlesCount; i++)
        {
            int nAssetBundleType = getAssetBundleType(routePath[i]);
            AssetBundle assetBundle = SimpleFramework.LuaHelper.GetResManager().LoadAssetBundle(routePath[i]);
            if (/*nAssetBundleType == (int)AssetBundleType.Shoal || */nAssetBundleType == (int)AssetBundleType.None)
            {
                m_progress += resourceWeight[nAssetBundleType];
                //Debuger.Log(string.Format("Asset Name = {0}, nAssetBundlesCount = {1}", abs[i], nAssetBundleType));
                yield return null;
                continue;
            }
            else
            {
                m_progress += resourceWeight[nAssetBundleType] * 0.1f;
            }

            string[] szAssetNames = assetBundle.GetAllAssetNames();
            int nAssetCount = szAssetNames.Length;
            for (int j = 0; j < nAssetCount; j++)
            {
                string szAssetName = szAssetNames[j];
                //Debuger.Log(string.Format("Loading Asset Name = {0}", szAssetName));
                string key;
                string assetprefix = szAssetPrefix.ToLower();
                if (szAssetName.StartsWith(assetprefix)) key = szAssetName.Substring(assetprefix.Length);
                else key = szAssetName;
                if (m_mapObject.ContainsKey(key))
                {
                    Debug.LogError(string.Format("{0} has already exists in ResourceManager", key));
                    continue;
                }
                m_progress += ((float)1 / nAssetCount) * resourceWeight[nAssetBundleType] * 0.9f;

                AssetBundleRequest request = assetBundle.LoadAssetAsync(szAssetName);
                yield return request;
                Object o = request.asset;
                m_mapObject.Add(key, o);
            }
            assetBundle.Unload(false);
        }

        m_progress = 1.0f;
    }

    /// <summary>
    /// 资源解密
    /// </summary>
    /// <param name="data"></param>
    /// <returns></returns>
    byte[] Decryption(byte[] data)
    {
        byte[] tmp = new byte[data.Length];
        for (int i = 0; i < data.Length; i++)
        {
            tmp[i] = data[i];
        }

        packXor(ref tmp, tmp.Length, password);
        return tmp;
    }
    /// <summary>
    /// 解密异或算法，可以修改自己想要的算法
    /// </summary>
    /// <param name="_data">数据字节</param>
    /// <param name="_len">字节的长度</param>
    /// <param name="_pstr">密码</param>
    static void packXor(ref byte[] _data, int _len, string _pstr)
    {
        int length = _len;
        int strCount = 0;


        for (int i = 0; i < length; ++i)
        {
            if (strCount >= _pstr.Length)
                strCount = 0;
            _data[i] ^= (byte)_pstr[strCount++];


        }
    }

    public void LoadBYAssetAsync(string szAssetBundle, string szAssetName, System.Action<Object> getObject)
    {
            StartCoroutine(LoadAssetAsync(szAssetBundle, szAssetName, getObject));
    }

    IEnumerator LoadAssetAsync(string szAssetBundle, string szAssetName, System.Action<Object> getObject)
    {
        szAssetBundle = "gamelrddz/" + szAssetBundle;
        szAssetBundle = szAssetBundle.ToLower();

        AssetBundle asbundle = SimpleFramework.LuaHelper.GetResManager().LoadAssetBundle(szAssetBundle);
        szAssetName = szAssetName.Replace("\\", "/");
        AssetBundleRequest abr = asbundle.LoadAssetAsync(System.IO.Path.GetFileName(szAssetName));
        yield return abr;
        Object go = abr.asset;
        if (getObject != null) getObject(go);
        yield return go;
    }
    void LoadResources(string path, System.Action<Object> getObject)
    {
#if UNITY_EDITOR
        path = path.Replace("\\", "/");
        Object obj = UnityEditor.AssetDatabase.LoadAssetAtPath<Object>("Assets/_GameLRDDZ/Build/" + path);
        if (obj == null)
        {
            Debuger.LogError("the resources of \"" + path + "\" was null");
            return;
        }
        if (getObject != null)
            getObject(obj);
#endif
    }

    public void CreatePanel(string abname, string name, bool isAddLua, LuaFunction func)
    {
        StartCoroutine(DoCreateLuaPanel(abname, name, isAddLua, func));
    }
    public void CreatePanel(string abname, string name, bool isAddLua)
    {
        StartCoroutine(DoCreateLuaPanel(abname, name, isAddLua, null));
    }
    IEnumerator DoCreateLuaPanel(string abname, string name, bool isAddLua, LuaFunction func)
    {

#if !UNITY_EDITOR
        GameObject prefab = (GameObject)LuaHelper.GetResManager().LoadAsset("gamelrddz/" + abname, name);
#else
        string url = "Assets/_GameLRDDZ/Build/";
        if (abname != name) url += abname + "/";
        GameObject prefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(url + name + ".prefab");
#endif
        yield return 0;     //防止 在加载了新场景的同一帧 被调用,导致界面在 LoadLevel 中被移除//

        if (Parent.Find(name) != null || prefab == null)
        {
            yield break;
        }

        GameObject go = Instantiate(prefab) as GameObject;
        go.name = name;
        //go.layer = LayerMask.NameToLayer("Default");
        go.transform.SetParent(Parent);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.zero;
        if (isAddLua) go.AddComponent<LRDDZ_LuaBehaviour>();
        if (func != null) func.Call(go);
        Debug.LogWarning("CreatePanel::>> " + name + " : @ prefab " + prefab);
    }

    /// <summary>
    /// 创建面板
    /// </summary>
    /// <param name="name"></param>
    /// <param name="luaName"></param>
    /// <param name="needLuaFile"></param>
    /// <returns></returns>
    public GameObject LoadAsset(string abname, string name, string luaName, bool needLuaFile = false)
    {
        return DoLoadAsset(abname, name, luaName, needLuaFile);
    }
    GameObject DoLoadAsset(string abname, string name, string luaName, bool needLuaFile = false)
    {
#if !UNITY_EDITOR
        GameObject prefab = (GameObject)LuaHelper.GetResManager().LoadAsset("gamelrddz/" + abname, name);
#else
        string url = "Assets/_GameLRDDZ/Build/";
        if (abname != name) url += abname + "/";
        GameObject prefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(url + name + ".prefab");
#endif
        //yield return 0;     //防止 在加载了新场景的同一帧 被调用,导致界面在 LoadLevel 中被移除//
        GameObject go = Instantiate(prefab) as GameObject;
        go.name = luaName;
        go.layer = LayerMask.NameToLayer("Default");
        go.transform.localScale = Vector3.one;
        if (needLuaFile == true)
        {
            go.AddComponent<LRDDZ_LuaBehaviour>();
        }
        return go;
    }


    /// 创建3D卡牌
    public void CreatePoker(string name, Vector3 scale, Vector3 position, bool needLuaFile = false, LuaFunction func = null)
    {
        StartCoroutine(StartCreatePoker(name, scale, position, needLuaFile, func));
    }
    IEnumerator StartCreatePoker(string name, Vector3 scale, Vector3 position, bool needLuaFile = false, LuaFunction func = null)
    {
        //3d卡牌 可以推迟几帧创建
        ///////////////////////////////
        yield return new WaitForEndOfFrame();
        yield return new WaitForEndOfFrame();
        yield return new WaitForEndOfFrame();
        yield return new WaitForEndOfFrame();
        /////////
        GameObject prefab = LoadAsset("Poker3D", name) as GameObject;
        GameObject go = Instantiate(prefab) as GameObject;
        go.name = name;
        go.layer = LayerMask.NameToLayer("Default");
        go.transform.parent = gameObject.transform.parent;
        go.transform.localScale = scale; // Vector3.one;
        go.transform.localPosition = position;// Vector3.zero;

        if (needLuaFile == true)
        {
            go.AddComponent<LRDDZ_LuaBehaviour>();
        }
        if (func != null) func.Call(go, name);
    }

    /// <summary>
    /// 创建3D模型，请求资源管理器
    /// </summary>
    /// <param name="parentname">表示AssetBundle名字</param>
    /// <param name="name"></param>
    /// <param name="luaname">lua文件对应的名字</param>
    /// <param name="scale"></param>
    /// <param name="position"></param>
    /// <param name="needLuaFile">表示是否需要对应Lua文件</param>
    /// <param name="func">创建完成回调函数</param>
    public void Create3DOjbect(string parentname, string name, string luaname, Vector3 scale, Vector3 position, bool needLuaFile = false, LuaFunction func = null, GameObject parent = null)
    {

        StartCoroutine(StartCreate3DObject(name, luaname, parentname, scale, position, needLuaFile, func, parent));
        Debug.Log("Create3DOjbect::>> " + name + " " + parentname);
    }

    /// <summary>
    /// 创建3d模型
    /// </summary>
    IEnumerator StartCreate3DObject( string name, string luaname, string bundleName, Vector3 scale, Vector3 position, bool needLuafile = false, LuaFunction func = null, GameObject parent = null)
    {
#if !UNITY_EDITOR
        //GameObject prefab = (GameObject)LuaHelper.GetResManager().LoadAsset("gamelrddz/" + bundleName, name);
        GameObject prefab = (GameObject)LoadNeedAsset(bundleName, name);
#else
        string url = "Assets/_GameLRDDZ/Build/";
        if (bundleName != name) url += bundleName + "/";
        GameObject prefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(url + name + ".prefab");
#endif
        yield return 0;     //防止 在加载了新场景的同一帧 被调用,导致界面在 LoadLevel 中被移除//
        GameObject go = Instantiate(prefab) as GameObject;
        go.name = luaname;
        go.layer = LayerMask.NameToLayer("Default");
        if (parent != null)
            go.transform.parent = parent.transform;
        else
            go.transform.parent = gameObject.transform.parent;
        go.transform.localScale = scale; // Vector3.one;
        go.transform.localPosition = position;// Vector3.zero;
        if (needLuafile == true)
        {
            go.AddComponent<LRDDZ_LuaBehaviour>();
        }
        if (func != null) func.Call(go, name);
        Debug.Log("StartCreate3DObject------>>>>" + name);
    }


    private Transform parent;
    public Transform Parent
    {
        get
        {
            if (parent == null)
            {
                GameObject go = GameObject.FindWithTag("GuiCamera");
                if (go != null) parent = go.transform;
                else
                {
                    InitGui();
                    go = GameObject.FindWithTag("GuiCamera");
                    if (go != null) parent = go.transform;
                }
            }
            return parent;
        }
    }

    public void InitGui()
    {
        string name = "GUI";
        GameObject gui = GameObject.Find(name);
        if (gui != null) return;

        GameObject prefab = Util.LoadPrefab(name);
        gui = Instantiate(prefab) as GameObject;
        gui.name = name;
        //DontDestroyOnLoad(gui);
    }

    public static void StartGame()
    {
        //BYResourceManager.LoadLevel(PlatformGameDefine.game.GameScene);
        LoadLevel("FKBY_Game");
    }

    /// <summary>
    /// 捕鱼用添加新的界面(切换场景)
    /// </summary>
    /// <param name="name">场景名称(主界面)名称</param>
    /// <param name="isGame">true: 使用GameLua, false: 使用LuaBehaviour</param>
    /// <param name="isAdditive">true: 使用在当前场景添加新的界面, false: 切换新场景</param>
    public static void LoadLevel(string name, bool isAdditive, LuaFunction func)
    {
        UnityEngine.Debug.Log("CK : ------------------------------ LoadLevel = " + name);

            Instance.StartCoroutine(DoLoadLevel(name, isAdditive, func));
     
    }

    public static void LoadLevel(string name)
    {
        LoadLevel(name, false, null);
    }

    /// <summary>
    /// 创建面板，请求资源管理器
    /// </summary>
    /// <param name="type"></param>
    static IEnumerator DoLoadLevel(string name, bool isAdditive, LuaFunction func)
    {
        /*
        if (name == "LRDDZ_Game_01" || name == "LRDDZ_Game_02"||name == "LRDDZ_Game_03")
        {
            
            CreateLoadingPanel();
            yield return new WaitForSeconds(0.5f);
            //预加载资源
            LRDDZ_ResourceManager.Instance.LoadNeedAssetAsync();
            yield return null;

        }
        */
        string assetbundleName = "gamelrddz/" + name;
        assetbundleName = assetbundleName.ToLower();
        AssetBundle ab = SimpleFramework.LuaHelper.GetResManager().LoadAssetBundle(assetbundleName);
        yield return ab;
        if (!isAdditive)
        {
#if UNITY_5_3
            UnityEngine.SceneManagement.SceneManager.LoadScene(name);
#else
            Application.LoadLevel(name);
#endif
        }
        yield return ab;
        /// 当场景加载完后，可以把assetbundle删了，减小内存占用
        UnLoadAssetBundle(name, false);
        System.GC.Collect();
    }
    static void CreateLoadingPanel()
    {
        string loadName = "";
        if (PlatformGameDefine.game.GameID == "1070") //1070为两人 1006为三人
            loadName = "LRDDZ_LoadPanel"; 
        else
            loadName = "SRDDZ_LoadPanel"; 
         GameObject prefab = (GameObject)LoadAsset("Prefab", loadName);
        GameObject go = Instantiate(prefab);
        go.name = "LRDDZ_LoadPanel";
        DontDestroyOnLoad(go);
    }

}