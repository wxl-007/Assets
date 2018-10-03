#define Unity5_AssetBundle
//add at 2016.7.7 开发模式下如果把Build文件夹改为Resources就可以直接运行看到预制件和资源的修改效果,提交前要改回Build
//#define _IsDevelop          
#if !Unity5_AssetBundle
using UnityEngine;
using System.Collections;
using System.IO;
using System;

namespace SimpleFramework.Manager {
    public class ResourceManager : View {
        private AssetBundle shared;

        /// <summary>
        /// 初始化
        /// </summary>
        public void initialize(Action func) {
//            if (AppConst.ExampleMode)
//            {
//                byte[] stream;
//                string uri = string.Empty;
//                //------------------------------------Shared--------------------------------------
//                uri = Util.DataPath + "shared.assetbundle";
//                if (File.Exists(uri))
//                {
//                    Debug.LogWarning("LoadFile::>> " + uri);

//                    stream = File.ReadAllBytes(uri);
//                    shared = AssetBundle.CreateFromMemoryImmediate(stream);
//#if UNITY_5
//                    shared.LoadAsset("Dialog", typeof(GameObject));
//#else
//                            shared.Load("Dialog", typeof(GameObject));
//#endif
//                }
//            }
            if (func != null) func();    //资源初始化完成，回调游戏管理器，执行后续操作 
        }

        /// <summary>
        /// 载入素材
        /// </summary>
        public AssetBundle LoadBundle(string name) {
            byte[] stream = null;
            AssetBundle bundle = null;
            string uri = Util.DataPath + name + ".assetbundle";//name.ToLower() + ".assetbundle";
            stream = File.ReadAllBytes(uri);
            bundle = AssetBundle.CreateFromMemoryImmediate(stream); //关联数据的素材绑定
            return bundle;
        }

        /// <summary>
        /// 销毁资源
        /// </summary>
        void OnDestroy() {
            if (shared != null) shared.Unload(true);
            Debug.Log("~ResourceManager was destroy!");
        }
    }
}

#else

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using SimpleFramework;
using LuaInterface; 

namespace SimpleFramework.Manager
{
    public class ResourceManager : View
    {
        private string[] m_Variants = { };
        private AssetBundleManifest m_manifest;
        private AssetBundleManifest manifest
        {
            get
            {
                if (m_manifest == null) Initialize();
                return m_manifest;
            }
            set
            {
                m_manifest = value;
            }
        }

        //private AssetBundle shared, assetbundle;
        public Dictionary<string, AssetBundle> bundles;

        void Awake()
        {
            //Initialize();
        }

        /// <summary>
        /// 初始化
        /// </summary>
        void Initialize()
        {
            byte[] stream = null;
            string uri = string.Empty;
            bundles = new Dictionary<string, AssetBundle>();
            uri = Util.DataPath + AppConst.AssetDirname;
            if (!File.Exists(uri)) return;
            stream = File.ReadAllBytes(uri);
            AssetBundle assetbundle = AssetBundle.LoadFromMemory(stream);
            m_manifest = assetbundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
            assetbundle.Unload(false);//----------------------重新整合资源打包(图片资源放到与原来不同的assetbundle中)会出现图片缺失现象,为确认是否与AssetBundleManifest没有清理有关-----------------
        }

        public void UnLoadGameAssetBundles()
        {
            foreach (var item in new Dictionary<string,AssetBundle>( bundles))
            {//happycity
                if (!item.Key.StartsWith(Utils._hallResourcesName) && !item.Key.StartsWith("gamenn"))
                {
                    item.Value.Unload(true);
                    bundles.Remove(item.Key);
                }
            }
        }

        /// <summary>
        /// 载入素材
        /// </summary>
        public Object LoadAsset(string abname, string assetname)
        {
            #if UNITY_EDITOR && _IsDevelop
                // add at 2016.7.7
                  Object tempObj = Debug_Resources_Load(abname, assetname);
                if (tempObj != null)
                {
                    return Debug_Resources_Load(abname, assetname);
                }
                else
                {
                    abname = abname.ToLower();
                    AssetBundle bundle = LoadAssetBundle(abname);
                    return bundle.LoadAsset(assetname);
                }
#else

             
            abname = abname.ToLower(); 
            AssetBundle bundle = LoadAssetBundle(abname);

            //Object[] objs = bundle.LoadAllAssets();

            //UnityEngine.Debug.Log("CK : ------------------------------ abname = " + abname + ", assetname = " + assetname + ", bundle = " + bundle + ", bundleName = " + bundle.name);
            //foreach (var item in objs)
            //{
            //    UnityEngine.Debug.Log("CK : ------------------------------ name = " + item);

            //}
            return bundle.LoadAsset(assetname);
#endif
        } 
        /// <summary>
        /// 载入素材
        /// </summary>
        public void LoadAsset(string abname, string assetname, LuaFunction func)
        {
            abname = abname.ToLower();
            StartCoroutine(OnLoadAsset(abname, assetname, func));
        }

		//for Optimization memory
		public void ClearBundles()
		{
			Debug.Log("Clear all bundles in Dc.");
			if(bundles != null){
				foreach(string key in bundles.Keys){
					bundles[key].Unload(false);
				}
				bundles.Clear();
			}
		}

        IEnumerator OnLoadAsset(string abname, string assetName, LuaFunction func)
        {
            yield return new WaitForEndOfFrame();
            GameObject go = (GameObject)LoadAsset(abname, assetName);
            if (func != null) func.Call(go);
        }

        /// <summary>
        /// 载入AssetBundle
        /// </summary>
        /// <param name="abname"></param>
        /// <returns></returns>
        public AssetBundle LoadAssetBundle(string abname)
        {
            if (manifest == null)
            {
                Debug.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
                return null;
            } 
            if (!abname.EndsWith(AppConst.ExtName))
            {
                abname += AppConst.ExtName;
            } 
            AssetBundle bundle = null;
            if (!bundles.ContainsKey(abname))
            { 
                byte[] stream = null;
                string uri = Util.DataPath + abname;
                //Debug.LogWarning("LoadFile::>> " + uri);
                LoadDependencies(abname);

                stream = File.ReadAllBytes(uri);
                bundle = AssetBundle.LoadFromMemory(stream); //关联数据的素材绑定
                bundles.Add(abname, bundle);
            }
            else
            { 
                bundles.TryGetValue(abname, out bundle);
            }
            return bundle;
        }

        /// <summary>
        /// 载入依赖
        /// </summary>
        /// <param name="name"></param>
        void LoadDependencies(string name)
        {
            if (manifest == null)
            {
                Debug.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
                return;
            }
            // Get dependecies from the AssetBundleManifest object..
            string[] dependencies = manifest.GetAllDependencies(name);
            if (dependencies.Length == 0) return;

            for (int i = 0; i < dependencies.Length; i++)
            {
                dependencies[i] = RemapVariantName(dependencies[i]);
            }
            // Record and load all dependencies.
            for (int i = 0; i < dependencies.Length; i++)
            {
                LoadAssetBundle(dependencies[i]);
            }
        }

        // Remaps the asset bundle name to the best fitting asset bundle variant.
        string RemapVariantName(string assetBundleName)
        {
            string[] bundlesWithVariant = manifest.GetAllAssetBundlesWithVariant();

            // If the asset bundle doesn't have variant, simply return.
            if (System.Array.IndexOf(bundlesWithVariant, assetBundleName) < 0)
                return assetBundleName;

            string[] split = assetBundleName.Split('.');

            int bestFit = int.MaxValue;
            int bestFitIndex = -1;
            // Loop all the assetBundles with variant to find the best fit variant assetBundle.
            for (int i = 0; i < bundlesWithVariant.Length; i++)
            {
                string[] curSplit = bundlesWithVariant[i].Split('.');
                if (curSplit[0] != split[0])
                    continue;

                int found = System.Array.IndexOf(m_Variants, curSplit[1]);
                if (found != -1 && found < bestFit)
                {
                    bestFit = found;
                    bestFitIndex = i;
                }
            }
            if (bestFitIndex != -1)
                return bundlesWithVariant[bestFitIndex];
            else
                return assetBundleName;
        }

        /// <summary>
        /// 销毁资源
        /// </summary>
        void OnDestroy()
        {
            //if (shared != null) shared.Unload(true);
            if (manifest != null) manifest = null;
            Debug.Log("~ResourceManager was destroy!");
        }


        #region 异步加载AssetBundle
        public void PreLoad(string abname)
        {
            StartCoroutine(DoPreLoad(new string[] { abname }));
        }
        public void PreLoad(string[] abnameList)
        {
            try
            {
                StartCoroutine(DoPreLoad(abnameList));
            }
            catch (System.Exception)
            {
            }
        }

        IEnumerator DoPreLoad(params string[] abnameList)
        {
            if (abnameList == null) yield break;
            for (int i = 0; i < abnameList.Length; i++)
            {
                UnityEngine.Debug.Log("CK : -----------------------------PreLoad- name = " + abnameList[i]);

                yield return StartCoroutine(LoadAssetAsync(abnameList[i]));
            }
        }

        IEnumerator LoadAssetAsync(string abname)
        {
            CoroutineResult result = null;
            if (result == null) result = new CoroutineResult();
            abname = abname.ToLower();
            yield return LoadAssetBundleAsync(abname, result);
        }

        //public IEnumerator LoadAssetAsync(string abname, string assetname)
        //{
        //    CoroutineResult result = null;
        //    if (result == null) result = new CoroutineResult();
        //    abname = abname.ToLower();
        //    yield return LoadAssetBundleAsync(abname, result);

        //    AssetBundleRequest abRequest = result._AssetBundleResult.LoadAssetAsync(assetname);
        //    yield return abRequest;
        //    result._ObjectResult = abRequest.asset;
        //    result._AssetBundleResult = null;
        //    yield return 0;
        //}

        /// <summary>
        /// 载入AssetBundle
        /// </summary>
        /// <param name="abname"></param>
        /// <returns></returns>
        IEnumerator LoadAssetBundleAsync(string abname, CoroutineResult result = null)
        {
            if (manifest == null)
            {
                Debug.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
                yield break;
            }

            if (!abname.EndsWith(AppConst.ExtName))
            {
                abname += AppConst.ExtName;
            }
            AssetBundle bundle = null;
            if (!bundles.ContainsKey(abname))
            {
                byte[] stream = null;
                string uri = Util.DataPath + abname;
                //Debug.LogWarning("LoadFile::>> " + uri);
                yield return LoadDependenciesAsync(abname);

                stream = File.ReadAllBytes(uri);
                //bundle = AssetBundle.LoadFromMemory(stream); //关联数据的素材绑定
                AssetBundleCreateRequest abRequest = AssetBundle.LoadFromMemoryAsync(stream);
                yield return abRequest;

                bundles.Add(abname, abRequest.assetBundle);
                bundle = abRequest.assetBundle;
            }
            else
            {
                bundles.TryGetValue(abname, out bundle);
            }

            if (result) result._AssetBundleResult = bundle;
        }

        IEnumerator LoadDependenciesAsync(string name)
        {
            if (manifest == null)
            {
                Debug.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
                yield break;
            }
            // Get dependecies from the AssetBundleManifest object..
            string[] dependencies = manifest.GetAllDependencies(name);
            if (dependencies.Length == 0) yield break;

            for (int i = 0; i < dependencies.Length; i++)
            {
                dependencies[i] = RemapVariantName(dependencies[i]);
            }
            // Record and load all dependencies.
            for (int i = 0; i < dependencies.Length; i++)
            {
                yield return LoadAssetBundleAsync(dependencies[i]);
            }
        }
        #endregion 异步加载AssetBundle

        #region 辅助方法
        public Object Debug_Resources_Load(string abname, string assetname)
        {
            abname = abname.ToLower();
            assetname = assetname.ToLower();
            int lastIndex = abname.LastIndexOf("/");
            string aName = abname.Substring(0, lastIndex);
            abname = abname.Substring(lastIndex + 1, abname.Length - 1 - lastIndex);
            //UnityEngine.Debug.Log(aName + "===----------------------------- abname = " + abname + ", assetname = " + assetname);
            string src = Application.dataPath;
            string nameP = "";
            foreach (string item in Directory.GetDirectories(src))
            {
                nameP = item.Substring(item.LastIndexOf("\\") + 1, item.Length - 1 - item.LastIndexOf("\\")).ToLower();
                nameP = nameP.Replace("_", "");
                if (nameP == aName)
                {
                    nameP = item + "/Resources";
                    nameP = nameP.Replace("\\", "/"); 
                    break;
                }
            }
            if (!Directory.Exists(nameP)) return null;

            string dataPath = "";
            foreach (string item in Directory.GetDirectories(nameP))
            {
                dataPath = item.Substring(item.LastIndexOf("\\") + 1, item.Length - 1 - item.LastIndexOf("\\")).ToLower();
                if (dataPath == abname)
                {
                    dataPath = item;
                    dataPath = dataPath.Replace("\\", "/");
                    break;
                }
                else
                {
                    dataPath = "";
                } 
            }
            
            if (dataPath == "")
            {
                int tempNum = 0;
                //资源在Build目录下
                foreach (string item in Directory.GetFiles(nameP))
                {
                    if (item.LastIndexOf(".meta") < 0)
                    {
                        tempNum = item.LastIndexOf("\\");
                        dataPath = item.Substring(tempNum + 1, item.LastIndexOf(".") - tempNum - 1).ToLower();
                        if (dataPath == assetname)
                        {
                            dataPath = item;
                            dataPath = dataPath.Replace("\\", "/"); 
                            break;
                        }
                        else
                        {
                            dataPath = "";
                        }
                    }
                }
            }
            else
            {
                //资源在更深层中
                dataPath = Debug_Search_Path(dataPath, assetname);  
            }

            if (dataPath.LastIndexOf(".") > 0)
            {
                int tempRNum = dataPath.LastIndexOf("/Resources/") + 11;
                dataPath = dataPath.Substring(tempRNum, dataPath.LastIndexOf(".") - tempRNum);
            } 
            //UnityEngine.Debug.Log("-----------------------------" + dataPath);
            return Resources.Load(dataPath, typeof(Object)) as Object; 
           // return UnityEditor.AssetDatabase.LoadAssetAtPath<Object>(dataPath);
        }

        public string Debug_Search_Path(string dataPath, string assetname)
        {
            int tempNum = 0;
            foreach (string item in Directory.GetFileSystemEntries(dataPath))
            {
                if (item.LastIndexOf(".meta") < 0)
                {  
                    if (item.LastIndexOf(".") < 0)
                    {
                        dataPath = Debug_Search_Path(item, assetname);
                    }
                    else
                    {
                        tempNum = item.LastIndexOf("\\");
                        dataPath = item.Substring(tempNum + 1, item.LastIndexOf(".") - tempNum - 1).ToLower();
                        if (dataPath == assetname)
                        {
                            dataPath = item;
                            dataPath = dataPath.Replace("\\", "/");
                            break;
                        }
                        else
                        {
                            dataPath = "";
                        }
                    }
                }
            }
            return dataPath;
        }
        #endregion 辅助方法
    }
      
}
#endif