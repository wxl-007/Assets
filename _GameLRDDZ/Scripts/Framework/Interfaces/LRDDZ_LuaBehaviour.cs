using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;

namespace SimpleFramework {
    public class LRDDZ_LuaBehaviour : View {
        protected static bool initialize = true;

        private string data = null;
        private AssetBundle bundle = null;
        private Dictionary<string, LuaFunction> buttons = new Dictionary<string, LuaFunction>();

        protected void Awake() {
            CallMethod("Awake", gameObject);
            //  gameObject.GetComponent<Animator>().SetTrigger()
        }
        //GameManager中的资源是否解压完成
        public bool IsExtractCompleted { get { return SimpleFramework.Manager.GameManager._IsExtractCompleted; } }
        protected void Start() {
            CallMethod("Start");
        }
        protected void Update()
        {
            CallMethod("Update");
        }
        protected void OnEnable(){
            CallMethod("OnEnable");
        }

        protected void OnDisable(){
            CallMethod("OnDisable");
        }
        protected void OnClick() {
            CallMethod("OnClick");
        }

        protected void OnClickEvent(GameObject go) {
            CallMethod("OnClick", go);
        }

        /// <summary>
        /// 初始化面板
        /// </summary>
        public void OnInit(AssetBundle bundle, string text = null) {
            this.data = text;   //初始化附加参数
            this.bundle = bundle; //初始化
            Debug.LogWarning("OnInit---->>>" + name + " text:>" + text);
        }

        /// <summary>
        /// 获取一个GameObject资源
        /// </summary>
        /// <param name="name"></param>
        public GameObject LoadAsset(string name) {
            if (bundle == null) return null;
            return Util.LoadAsset(bundle, name);
        }

        /// <summary>
        /// 添加hole住事件
        /// </summary>
        public void AddHover(GameObject go, LuaFunction luafunc,LuaFunction luafunc2)
        {
            if (go == null || luafunc == null) return;
            if(!buttons.ContainsKey(go.name))
            buttons.Add(go.name, luafunc);
            UIEventListener.Get(go).onHover = delegate(GameObject o,bool state)
            {
                if (state)
                    luafunc.Call(go);
                else
                    luafunc2.Call(go);
            };
        }
        public void AddHover(GameObject go, LuaFunction luafunc)
        {
            if (go == null || luafunc == null) return;
            if (!buttons.ContainsKey(go.name))
                buttons.Add(go.name, luafunc);
            UIEventListener.Get(go).onHover = delegate (GameObject o, bool state)
            {
                luafunc.Call(state);
            };
        }
        /// <summary>
        /// 添加提交事件
        /// </summary>
        public void AddSubmit(GameObject go, LuaFunction luafunc)
        {
            if (go == null || luafunc == null) return;
            buttons.Add(go.name, luafunc);
            UIEventListener.Get(go).onSubmit = delegate (GameObject o)
            {
                luafunc.Call(go);
            };
        }
        /// <summary>
        /// 添加输入事件
        /// </summary>
        public void AddInput(GameObject go,LuaFunction luafunc)
        {
            UIInput uiInput = go.GetComponent<UIInput>();
            AddInput(uiInput, luafunc, null);
        }
        public void AddInput(UIInput uiInput, LuaFunction luafunc, LuaTable luaself)
        {
            if (uiInput == null) return;
            buttons.Add(uiInput.gameObject.name,luafunc);
            EventDelegate eventDelegate = new EventDelegate(delegate ()
            {
                luafunc.Call(luaself);
            });
            uiInput.onChange.Add(eventDelegate);
        }

        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc) {
            if (go == null || luafunc == null) return;
            buttons.Add(go.name, luafunc);
            if (!buttons.ContainsKey(go.name))
                buttons.Add(go.name, luafunc);
            UIEventListener.Get(go).onClick = delegate(GameObject o) {
                LRDDZ_MusicManager.instance.PlaySoundEffect("Sounds", "dianji");
                luafunc.Call(go);
            };
        
            UIEventListener.Get(go).onPress = delegate(GameObject o, bool state)
            {
                if (state)
                {
                    iTween.ScaleTo(go, iTween.Hash("scale", new Vector3(1.1f, 1.1f, 1.1f), "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));

                }
                else
                {
                    iTween.ScaleTo(go, iTween.Hash("scale", new Vector3(1f, 1f, 1f), "time", 0.1, "islocal", true, "easetype", iTween.EaseType.linear));
                }
            };
        }
        public void AddToggle(UIToggle uiToggle, LuaFunction luafunc)
        {
            AddToggle(uiToggle, luafunc, null);
        }
        /// <summary>
        /// 添加UIToggle事件
        /// </summary>
        public void AddToggle(UIToggle uiToggle, LuaFunction luafunc, LuaTable luaself)
        {
            if (uiToggle == null) return;
            EventDelegate eventDelegate = new EventDelegate(delegate ()
            {
                //LRDDZ_MusicManager.instance.PlaySoundEffect("Sounds", "dianji");
                luafunc.Call(luaself);
            });
            uiToggle.onChange.Add(eventDelegate);
        }
        /// <summary>
        /// 删除单击事件
        /// </summary>
        /// <param name="go"></param>
        public void RemoveClick(GameObject go) {
            if (go == null) return;
            LuaFunction luafunc = null;
            if (buttons.TryGetValue(go.name, out luafunc)) {
                buttons.Remove(go.name);
                luafunc.Dispose();
                luafunc = null;
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            foreach (var de in buttons) {
                if (de.Value != null) {
                    de.Value.Dispose();
                }
            }
            buttons.Clear();
        }
        
        /// <summary>
        /// 执行Lua方法
        /// </summary>
        protected object[] CallMethod(string func, params object[] args) {
            if (!initialize) return null;
            return Util.CallMethod(name, func, args);
        }

        //-----------------------------------------------------------------
        protected void OnDestroy() {
            CallMethod("OnDestroy");
            // if (bundle) {
            //     bundle.Unload(true);
            //     bundle = null;  //销毁素材
            // }
            // ClearClick();
            //// Util.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
            
        }

        public void MyDestroy(GameObject obj)
        {
            Destroy(obj);

           // ParticleSystem p = new ParticleSystem();
           // p.
        }


       //event

        public void Event1()
        {
            Debug.Log("Event1()");
            CallMethod("Event1");
        }
        public void Event2()
        {
            Debug.Log("Event2()");
            CallMethod("Event2");
        }
        public void Event3()
        {
            CallMethod("Event3");
        }
        public void Event4()
        {
            CallMethod("Event4");
        }
        public void Event5()
        {
            CallMethod("Event5");
        }
        public void Event6()
        {
            CallMethod("Event6");
        }
        public void Event7()
        {
            CallMethod("Event7");
        }
        public void Event8()
        {
            CallMethod("Event8");
        }
        public void Event9()
        {
            CallMethod("Event9");
        }
        public void Event10()
        {
            CallMethod("Event10");
        }
    }
}