#define Unity5_AssetBundle

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

namespace SimpleFramework.Manager {
    public class PanelManager : View {

        #region GameModule 和 level 的映射
        public static Dictionary<string, string> GameModule_LevelGUI_Map = new Dictionary<string, string>() {
        { "Loading",Utils._hallResourcesName},
        { "Login",Utils._hallResourcesName},
        { "IPTest_Login",Utils._hallResourcesName},
		{ "Local_Login",Utils._hallResourcesName},
        { "Hall_SingleGame",Utils._hallResourcesName},
        { "Module_Bank",Utils._hallResourcesName},
        { "Module_Desks",Utils._hallResourcesName},
        { "Module_Feedback",Utils._hallResourcesName},
        { "Module_GameRecord",Utils._hallResourcesName},
        { "Module_Gift",Utils._hallResourcesName},
        { "Module_Mail",Utils._hallResourcesName},
        { "Module_Recharge",Utils._hallResourcesName},
        { "Module_Recharge_iOS",Utils._hallResourcesName},
        { "Module_Rooms",Utils._hallResourcesName},
        { "Module_Setting",Utils._hallResourcesName},
        { "Module_UpdateAvatar",Utils._hallResourcesName},
        { "Register",Utils._hallResourcesName},
        { "Hall",Utils._hallResourcesName},
        { "GuideDialog",Utils._hallResourcesName},
		{ "Module_Leaderboard",Utils._hallResourcesName},
		{ "Module_Task",Utils._hallResourcesName},
        {  "Module_Activity",Utils._hallResourcesName},
       // HappyCity
        { "Loading_510k","HappyCity_510k"},
        { "Login_510k","HappyCity_510k"}, 

        { "Game30M","Game30M"},
        { "GameBBDZ","GameBBDZ"},
        { "GameBRLZ","GameBRLZ"},
        { "GameDDZ","GameDDZ"},
        { "GameDZNN","GameDZNN"},
        { "GameDZPK","GameDZPK"},
        { "GameFTWZ","GameFTWZ"},
        { "GameHPLZ","GameHPLZ"},
        { "GameJQNN","GameJQNN"},
        { "GameKPNN","GameKPNN"},
        { "GameMXNN","GameMXNN"},
        { "GameSRNN","GameSRNN"},
        { "GameSRPS","GameSRPS"},
        { "GameTBBY","GameTBBY"},
        { "GameTBNN","GameTBNN"},
        { "GameTBTW","GameTBTW"},
        { "GameTBWZ","GameTBWZ"},
        { "GameXJ","GameXJ"},
        { "GameYSZ","GameYSZ"},
		{ "GameFARM","GameFARM"},
        { "GameFKBY","GameFKBY"},
		{ "GameTBSZ","GameTBSZ"},
        {"GameLRDDZ","GameLRDDZ" },
    };

        public static Dictionary<string, string> GameModule_Name_Map = new Dictionary<string, string>() {
        { "Game30M".ToLower(),"快乐30秒"},
        { "GameBBDZ".ToLower(),"百倍对战"},
        { "GameBRLZ".ToLower(),"百人两张"},
        { "GameDDZ".ToLower(),"斗地主"},
        { "GameDZNN".ToLower(),"对战牛牛"},
        { "GameDZPK".ToLower(),"德州扑克"},
        { "GameFTWZ".ToLower(),"飞腾五张"},
        { "GameFTWZBS".ToLower(),"飞腾五张比赛"},
        { "GameHPLZ".ToLower(),"火拼两张"},
        { "GameJQNN".ToLower(),"激情牛牛"},
        { "GameKPNN".ToLower(),"看牌牛牛"},
        { "GameMXNN".ToLower(),"明星牛牛"},
        { "GameSRNN".ToLower(),"四人牛牛"},
        { "GameSRPS".ToLower(),"四人拼十"},
        { "GameTBBY".ToLower(),"通比捕鱼"},
        { "GameTBNN".ToLower(),"通比牛牛"},
        { "GameTBTW".ToLower(),"通比骰王"},
        { "GameTBWZ".ToLower(),"通比五张"},
		{ "GameTBSZ".ToLower(),"通比三张"},
        { "GameYSZ".ToLower(),"心跳牛牛"},
    };

        public static void DictionaryAddRange(Dictionary<string,string> map, string json)
        {
            JSONObject jsonObj = new JSONObject(json);
            foreach (var item in jsonObj.keys)
            {
                map[item] = jsonObj[item].str;
            }
        }

        public static void GameModule_LevelGUI_Map_Extend(string json)
        {
            DictionaryAddRange(GameModule_LevelGUI_Map,json);
        }

        public static void GameModule_Name_Map_Extend(string json)
        {
            DictionaryAddRange(GameModule_Name_Map,json);
        }
        #endregion GameModule 和 level 的映射


        private Transform parent;

        public Transform Parent {
            get {
                if (parent == null) {
                    GameObject go = GameObject.FindWithTag("GuiCamera");
                    if (go != null) parent = go.transform;
                    else {
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
            UIRoot uiroot = gui.GetComponent<UIRoot>();
            if(uiroot)
            {
#if UNITY_STANDALONE
                uiroot.scalingStyle = UIRoot.Scaling.Constrained;
#else
                uiroot.scalingStyle = UIRoot.Scaling.ConstrainedOnMobiles;
#endif
            }
        }



        public void CreatePanel(string name,bool isGame, bool isAdditive)
        {
            CreatePanel(name,isGame, isAdditive, null);
        }

        public void CreatePanel(string name, bool isAdditive)
        {
            CreatePanel(name, false, isAdditive);
        }

        public void CreatePanel(string name)
        {
            CreatePanel(name, false, false);
        }

        public void CreateGamePanel(string name, bool isAdditive)
        {
            CreatePanel(name, true, isAdditive);
        }
        //add by 004
        public void CreateNewGamePanel(string name,Vector3 pV,LuaFunction pFunc)
        {

            StartCoroutine(DoCreateNewPanel(name, true, pV, pFunc));
        }

#if !Unity5_AssetBundle
        /// <summary>
        ///  创建面板，请求资源管理器
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string name, bool isGame, LuaFunction func)
        {
            string gameModule = string.Empty;
            if (!GameModule_LevelGUI_Map.TryGetValue(name, out gameModule)) return;
            
            AssetBundle bundle = ResManager.LoadBundle(gameModule + "/" + name);
            StartCoroutine(StartCreatePanel(name, bundle, isGame, func));
            Debug.LogWarning("CreatePanel::>> " + name + " " + bundle);
        }

        /// <summary>
        /// 创建面板
        /// </summary>
        IEnumerator StartCreatePanel(string name, AssetBundle bundle, bool isGame = false, LuaFunction func = null) {
            //name += "Panel";
            yield return new WaitForEndOfFrame();

            GameObject prefab = Util.LoadAsset(bundle, name);
            //Debug.Log("-----------------------------------------1");
            yield return new WaitForEndOfFrame();
            //在这里的 1 和 2 之间的时间点会创建一个 GlobalGenerator,不知道是怎么回事
            //Debug.Log("-----------------------------------------2");
            if (Parent.FindChild(name) != null || prefab == null) {
                yield break;
            }

            GameObject go = Instantiate(prefab) as GameObject;
            go.name = name;
            go.layer = LayerMask.NameToLayer("Default");
            go.transform.parent = Parent;
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;

            if (isGame) go.AddComponent<GameLua>().OnInit(bundle);
            else go.AddComponent<LuaBehaviour>().OnInit(bundle);

            if (func != null) func.Call(go);
            Debug.Log("StartCreatePanel------>>>>" + name);
        }
#else
        /// <summary>
        /// 创建面板，请求资源管理器
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string name, bool isGame, bool isAdditive, LuaFunction func)
        {
            StartCoroutine(DoCreatePanel(name, isGame,isAdditive, func));
        }

        public void CreatePanel(string name, bool isGame, LuaFunction func)
        {
            CreatePanel(name,isGame,false,func);
        }


        /// <summary>
        /// 创建面板，请求资源管理器
        /// </summary>
        /// <param name="type"></param>
        IEnumerator DoCreatePanel(string name, bool isGame,bool isAdditive, LuaFunction func)
        {
            //EginProgressHUD.Instance.ShowWaitHUD("界面加载中...", true);
            if (!isAdditive)
            {
                Application.LoadLevel("nil");
               // TransitionCrossFade.Instance.ShowFadeTransition();
            }

            //yield return new WaitForEndOfFrame();//这样做会导致后面的界面被计算在上一个界面的数据内,跟随上一个界面一起被销毁
            yield return 0;
            if (Parent) { }
            //string name = name + "Panel"; 
            //UnityEngine.Debug.Log("CK : ------------------------------ name = " + name);

            string gameModule = string.Empty;
            if (!GameModule_LevelGUI_Map.TryGetValue(name, out gameModule))
            {
                Debug.LogError("gameModule name : " + name + " is not exist");
                yield break;
            }
//			Debug.LogError("!!!!Clear Bundles!!!");
//			ResManager.ClearBundles();
            //Debug.Log("-------------------------------name = " + gameModule + ", assetname = " + name);
            GameObject prefab = (GameObject)ResManager.LoadAsset(gameModule+"/"+name, name);

			//add by xiaoyong 2016.3.16 visual effect: fade in scene
			//GameObject fadePrb = ResManager.LoadAsset("HappyCity/FadeEftPrb","FadeEftPrb") as GameObject;//上一帧的界面显示会卡在这里(猜测:unity当前帧操作数据,下一帧显示界面)

            //yield return 0;//防止 在加载了新场景的同一帧 被调用,导致界面在 LoadLevel 中被移除// 
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
            if (go.GetComponent<LuaBehaviour>() == null)
            {
                if (isGame) go.AddComponent<GameLua>();
                else go.AddComponent<LuaBehaviour>();
            } 
            if (func != null) func.Call(go);
            Debug.LogWarning("CreatePanel::>> " + name + " : @ prefab " + prefab);

            //yield return 0;
            //EginProgressHUD.Instance.HideHUD();
        }

        //add by lxtd004 2017.4.1 add ani 
        IEnumerator DoCreateNewPanel(string name, bool isGame,Vector3 pBornV, LuaFunction func)
        {
            EginProgressHUD.Instance.ShowWaitHUD("界面加载中...", true);
            yield return 0;
            string gameModule = string.Empty;
            if (!GameModule_LevelGUI_Map.TryGetValue(name, out gameModule))
            {
                Debug.LogError("gameModule name : " + name + " is not exist");
                yield break;
            }
            GameObject prefab = (GameObject)ResManager.LoadAsset(gameModule + "/" + name, name);
            if (Parent.Find(name) != null || prefab == null)
            {
                yield break;
            }
            GameObject go = Instantiate(prefab) as GameObject;
            go.name = name;
            go.transform.SetParent(Parent);
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = pBornV;
            if (go.GetComponent<LuaBehaviour>() == null)
            {
                if (isGame) go.AddComponent<GameLua>();
                else go.AddComponent<LuaBehaviour>();
            }
            if (func != null) func.Call(go);
            Debug.LogWarning("Create 004 Panel::>> " + name + " : @ prefab " + prefab);
        }
		
#endif
    }
}