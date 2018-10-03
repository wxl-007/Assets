using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;

namespace SimpleFramework {
    public class LuaBehaviour : View {
        protected static bool initialize = false;
        protected static List<LuaBehaviour> m_LuaBehaviourList = new List<LuaBehaviour>();//用于在所有的LuaBehaviour 都退出后 停止 关闭 lua

        private string data = null;
        //private AssetBundle bundle = null;
        private List<LuaFunction> buttons = new List<LuaFunction>();
        private List<LuaTable> m_LuaTables = new List<LuaTable>();

		//add 2016.5.12----->
		public List<RefObj> refObjList = new List<RefObj>();
		private Dictionary<string, GameObject> refObjDc = new Dictionary<string, GameObject>();
		public GameObject getRefObj(string objName){
			if( refObjDc.ContainsKey(objName) ){
				return refObjDc[objName];
			}else{
				return null;
			}
		}
		//<-------

        #region 生命周期相关方法
        protected void Awake()
        {
            string instantiateEnding = "(Clone)";
			//2016.4.15
			//修改为使用Substring, 这种写法执行的删除对象是字符数组中出现的任意字符，而不是这些字符连在一起组成的字符串(Hall(Clone) 会变成Ha) 
//          if (name.EndsWith(instantiateEnding)) name = name.TrimEnd(instantiateEnding.ToCharArray());
			if(name.EndsWith(instantiateEnding)){ name = name.Substring(0,name.Length-7); }
            //Debug.Log("luabehaviour : " + this.transform.parent + "/" + this.gameObject);

            if (LuaManager != null && initialize)
            {
                LuaState l = LuaManager.lua;
                l[name + ".transform"] = transform;
                l[name + ".gameObject"] = gameObject;
                l[name + ".mono"] = this;

				//add 2016.5.12----->
				foreach(RefObj robj in refObjList){
					refObjDc[robj.name] = robj.obj;
				}
				//<-------
            }
            CallMethod("Awake");
            m_LuaBehaviourList.Add(this);
        }

        protected void OnEnable()
        {
            CallMethod("OnEnable");
        }

        protected void OnDisable()
        {
            CallMethod("OnDisable");
        }

        protected void Start()
        {
            CallMethod("Start");
        }

        //-----------------------------------------------------------------
        protected void OnDestroy()
        {
            //if (bundle) {
            //    bundle.Unload(true);
            //    bundle = null;  //销毁素材
            //}
            CallMethod("OnDestroy");
            ClearClick();

            Util.ClearMemory();

            m_LuaBehaviourList.Remove(this);

            if (m_LuaBehaviourList.Count <= 0 && LuaManager != null)
                LuaManager.Destroy();

            LuaManager = null;

            Debug.Log("~" + name + " was destroy!");
        }
       
        protected void OnApplicationFocus(bool focusStatus)
        { 
            CallMethod("OnApplicationFocus", focusStatus); 
        }

        protected void OnApplicationPause(bool pauseStatus)
        {
            CallMethod("OnApplicationPause", pauseStatus);  
        }
        #endregion 生命周期相关方法

        protected void OnClick() {
            CallMethod("OnClick");
        }

        protected void OnClickEvent(GameObject go) {
            CallMethod("OnClick", go);
        }

        /// <summary>
        /// 初始化面板
        /// </summary>
        //public void OnInit(AssetBundle bundle, string text = null) {
        //    this.data = text;   //初始化附加参数
        //    this.bundle = bundle; //初始化
        //    Debug.LogWarning("OnInit---->>>" + name + " text:>" + text);
        //}

        #region 资源加载相关
        /// <summary>
        /// 获取与该 LuaBehaviour 名字相同的AssetBundle 的资源,强转成 GameObject
        /// </summary>
        /// <param name="name"></param>
        public GameObject GetGameObject(string assetName)
        {
            return (GameObject)LoadAsset(assetName);
        }

        /// <summary>
        /// 获取与该 LuaBehaviour 名字相同的AssetBundle 的资源
        /// </summary>
        /// <param name="assetName"></param>
        /// <returns></returns>
        public UnityEngine.Object LoadAsset(string assetName)
        {
            string gameModule = string.Empty;
            if (!SimpleFramework.Manager.PanelManager.GameModule_LevelGUI_Map.TryGetValue(name, out gameModule)) return null;
            return ResManager.LoadAsset(gameModule + "/" + name, assetName);
        }

        /// <summary>
        /// 获取与该 LuaBehaviour 名字不同的AssetBundle 的资源, bundleName 要写上 gameModule/assetBundleName
        /// </summary>
        /// <param name="bundleName"></param>
        /// <param name="assetName"></param>
        /// <returns></returns>
        public UnityEngine.Object LoadAsset(string bundleName, string assetName)
        {
            return ResManager.LoadAsset(bundleName, assetName);
        }
        #endregion 资源加载相关
        /// <summary>
        /// 添加Slider事件----dingkun:2015.12.28
        /// </summary>
        public void AddSlider(UISlider uislider, LuaFunction luafunc)
        {
            AddSlider(uislider, luafunc, null);
        }
        public void AddSlider(UISlider uislider, LuaFunction luafunc, LuaTable luaself)
        {
            if (uislider == null) return;
            buttons.Add(luafunc);
            EventDelegate eventDelegate = new EventDelegate(delegate()
            {
                luafunc.Call(luaself);
            });

            uislider.onChange.Add(eventDelegate);
        }
        /// <summary>
        /// 添加UIPopupList事件----dingkun:2016.5.6
        /// </summary>
        public void AddPopupList(UIPopupList uiPopupList, LuaFunction luafunc)
        {
            AddPopupList(uiPopupList, luafunc, null);
        }
        public void AddPopupList(UIPopupList uiPopupList, LuaFunction luafunc, LuaTable luaself)
        {
            if (uiPopupList == null) return;
            buttons.Add(luafunc);
            EventDelegate eventDelegate = new EventDelegate(delegate()
            {
                luafunc.Call(luaself);
            });

            uiPopupList.onChange.Add(eventDelegate);
        }
        /// <summary>
        /// 添加UIInput事件----dingkun:2016.5.10
        /// </summary>
        public void AddInput(UIInput uiInput, LuaFunction luafunc)
        {
            AddInput(uiInput, luafunc, null);
        }
        public void AddInput(UIInput uiInput, LuaFunction luafunc, LuaTable luaself)
        {
            if (uiInput == null) return;
            buttons.Add(luafunc);
            EventDelegate eventDelegate = new EventDelegate(delegate()
            {
                luafunc.Call(luaself);
            });
            uiInput.onChange.Add(eventDelegate);
        }
        /// <summary>
        /// 添加UIToggle事件----dingkun:2016.6.3
        /// </summary>
        public void AddToggle(UIToggle uiToggle, LuaFunction luafunc)
        {
            AddToggle(uiToggle, luafunc, null);
        }
        public void AddToggle(UIToggle uiToggle, LuaFunction luafunc, LuaTable luaself)
        {
            if (uiToggle == null) return;
            buttons.Add(luafunc);
            EventDelegate eventDelegate = new EventDelegate(delegate()
            {
                luafunc.Call(luaself);
            });
            uiToggle.onChange.Add(eventDelegate);
        }
        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc) {
            if (go == null) return;
            buttons.Add(luafunc);
          
            UIEventListener.Get(go).onClick = delegate(GameObject o) {
                luafunc.Call(go);
            };
        }
        /// <summary>
        /// 添加单击事件,带调用对象和传入参数
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc, LuaTable luaself, LuaTable luaParameter)
        {
            if (go == null) return;
			buttons.Add(luafunc);//line 241 <---  2016.12.26 lxtd003
            UIEventListener.Get(go).onClick = delegate(GameObject o)
            {
                luafunc.Call(luaself, go, luaParameter);
//               buttons.Add(luafunc);// move to line 241 --> 2016.12.26 lxtd003
            };
        }
        public void AddClick(GameObject go, LuaFunction luafunc, LuaTable luaself)
        {
            AddClick(go, luafunc, luaself, null);
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            for (int i = 0; i < buttons.Count; i++ ) {
                if (buttons[i] != null) {
                    buttons[i].Dispose();
                    buttons[i] = null;
                }
            }
        }
        
        /// <summary>
        /// 执行Lua方法
        /// </summary>
        protected object[] CallMethod(string func, params object[] args) {
            if (!initialize) return null;
            return Util.CallMethod(name, func, args);
        }
    }

	//add 2016.5.12----->
	[Serializable]
	public class RefObj{
		public string name;
		public GameObject obj;
	}
	//<-------
}