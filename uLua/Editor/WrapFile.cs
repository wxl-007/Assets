using UnityEngine;
using System;
using System.Collections;
using SimpleFramework;
using SimpleFramework.Manager;
using DG.Tweening;
public static class WrapFile {

    public static BindType[] binds = new BindType[]
    {
        _GT(typeof(object)),
        _GT(typeof(System.String)),
        _GT(typeof(System.Enum)),
        _GT(typeof(IEnumerator)),
        _GT(typeof(System.Delegate)),
        _GT(typeof(Type)).SetBaseName("System.Object"),
        _GT(typeof(UnityEngine.Object)),
        _GT(typeof(System.Text.RegularExpressions.Regex)),
        //测试模板
        ////_GT(typeof(Dictionary<int,string>)).SetWrapName("DictInt2Str").SetLibName("DictInt2Str"),
        
        //custom    
		_GT(typeof(WWW)),
        _GT(typeof(Util)),
        _GT(typeof(AppConst)),
        _GT(typeof(ByteBuffer)),
        _GT(typeof(NetworkManager)),
        _GT(typeof(ResourceManager)),
        _GT(typeof(PanelManager)),
        _GT(typeof(UIEventListener)),
        _GT(typeof(TimerManager)),
        _GT(typeof(LuaHelper)),
        _GT(typeof(LuaBehaviour)),
        _GT(typeof(UIPanel)),
        _GT(typeof(UILabel)),
        _GT(typeof(UIGrid)),
        _GT(typeof(WrapGrid)),
        _GT(typeof(LuaEnumType)),
        _GT(typeof(UIWidgetContainer)),
        _GT(typeof(UIWidget)),
        _GT(typeof(UIRect)),
        _GT(typeof(Debugger)),
        _GT(typeof(TweenAlpha.Style)),
        _GT(typeof(MusicManager)),
        _GT(typeof(DelegateFactory)),
        _GT(typeof(TestLuaDelegate)),
        _GT(typeof(TestDelegateListener)),
        _GT(typeof(TestEventListener)),
        _GT(typeof(EventDelegate)),
        _GT(typeof(UIButton)),
        _GT(typeof(UIWidget.Pivot)),
        //unity                        
        _GT(typeof(Component)),
        _GT(typeof(Behaviour)),
        _GT(typeof(MonoBehaviour)),
        _GT(typeof(GameObject)),
        _GT(typeof(Transform)),
        _GT(typeof(Space)),

        _GT(typeof(Camera)),
        _GT(typeof(CameraClearFlags)),
        _GT(typeof(Material)),
        _GT(typeof(Renderer)),
        _GT(typeof(MeshRenderer)),
        _GT(typeof(SkinnedMeshRenderer)),
        _GT(typeof(Light)),
        _GT(typeof(LightType)),
        _GT(typeof(ParticleEmitter)),
        _GT(typeof(ParticleRenderer)),
        _GT(typeof(ParticleAnimator)),

        _GT(typeof(Physics)),
        _GT(typeof(Collider)),
        _GT(typeof(BoxCollider)),
        _GT(typeof(MeshCollider)),
        _GT(typeof(SphereCollider)),

        _GT(typeof(CharacterController)),

        _GT(typeof(Animation)),
        _GT(typeof(AnimationClip)).SetBaseName("UnityEngine.Object"),
        _GT(typeof(TrackedReference)),
        _GT(typeof(AnimationState)),
        _GT(typeof(QueueMode)),
        _GT(typeof(PlayMode)),

        _GT(typeof(AudioClip)),
        _GT(typeof(AudioSource)),
        
        _GT(typeof(RuntimePlatform)),
        _GT(typeof(Application)),
        _GT(typeof(Input)),
        _GT(typeof(TouchPhase)),
        _GT(typeof(KeyCode)),
        _GT(typeof(Screen)),
        _GT(typeof(Time)),
        _GT(typeof(RenderSettings)),
        _GT(typeof(SleepTimeout)),

        _GT(typeof(AsyncOperation)).SetBaseName("System.Object"),
        _GT(typeof(AssetBundle)),
        _GT(typeof(BlendWeights)),
        _GT(typeof(QualitySettings)),
        _GT(typeof(AnimationBlendMode)),
        _GT(typeof(Texture)),
        _GT(typeof(RenderTexture)),
        _GT(typeof(ParticleSystem)),
        _GT(typeof(Utils)),
        _GT(typeof(Game)),
        _GT(typeof(GameLua)),
        _GT(typeof(PlatformGameDefine)),
        _GT(typeof(GameEntity)),
        _GT(typeof(GameType)),
        _GT(typeof(DeskType)),
        _GT(typeof(ArrayList)),
        _GT(typeof(PlayerPrefs)),
       _GT(typeof(LoginType)),
        
        
        //MyAdd
        _GT(typeof(RuntimePlatform)),
		_GT(typeof(Resources)),
        _GT(typeof(UIRoot)),
        _GT(typeof(UIRoot.Scaling)),
        
        _GT(typeof(DoneCoroutine)), 
        _GT(typeof(GameSettingManager)),
        _GT(typeof(TBNNCount)),
        _GT(typeof(NNCount)),
        _GT(typeof(PoolInfo)),
        _GT(typeof(PlatformEntityLua)),
        
	
        _GT(typeof(NGUITools)),
        _GT(typeof(UIAnchor)),
        _GT(typeof(UIAnchor.Side)),
		_GT(typeof(SocketConnectInfo)),
       
        _GT(typeof(UISprite)),
        _GT(typeof(UIBasicSprite)), 
		_GT(typeof(TweenPosition)),
		_GT(typeof(UIButtonColor)),
        _GT(typeof(UITweener)),
        _GT(typeof(iTween)),
       
        _GT(typeof(System.DateTime)),
        _GT(typeof(DOTween)),
        _GT(typeof(Tweener)),
        _GT(typeof(Tween)), 
        _GT(typeof(TweenSettingsExtensions)), 
        
        _GT(typeof(LoopType)), 
        _GT(typeof(Ease)),
        _GT(typeof(AutoPlay)),
        _GT(typeof(UpdateType)),
       
        _GT(typeof(SystemInfo)),  
		
		_GT (typeof(iTween.EaseType)),
		_GT(typeof(UIScrollView)),
		_GT(typeof(UIInput)),
        _GT(typeof(UIInput.InputType)),
		_GT(typeof(WWWForm)),
        _GT(typeof(WXPayUtil)),
		_GT(typeof(AliPayUtil)),
        _GT(typeof(UmengUtil)),
        _GT(typeof(PhoneSdkUtil)),
        _GT (typeof(HttpResult.ResultType)),
		_GT (typeof(BaseSceneLua)),
        _GT (typeof(UISpriteAnimation)), 
        _GT (typeof(SocketManager)),
        _GT (typeof(UIPopupList)),
       
        _GT (typeof(System.Text.RegularExpressions.Regex)),
        _GT(typeof(UIToggle)),
        _GT(typeof(WaitCoroutine)),

        //
        _GT(typeof(System.IO.Path)), 
		_GT(typeof(RaycastHit)),
        _GT(typeof(Physics)), 
        //_GT(typeof(System.IO.Directory)),
        //_GT(typeof(System.IO.File)),
        _GT(typeof(Constants)), 

        //捕鱼项目添加
         //_GT(typeof(UIHelper)),
        //_GT(typeof(BYResourceManager)),
        //_GT(typeof(Game_Fish)),
       // _GT(typeof(FishPathManager)),
       // _GT(typeof(AudioHelper)),
        //_GT(typeof(Global)),
        //_GT(typeof(Global.PlatformType)),
        _GT(typeof(MailInfo)),
       // _GT(typeof(GameConfig)),
       // _GT(typeof(PoolDefine)),
        _GT(typeof(GameRoom)),
        //_GT(typeof(BYWebServer)),
       // _GT(typeof(FKBYConnectDefine)),
        _GT(typeof(Cursor)),
        _GT(typeof(LayerMask)),

        //添加Animator
        _GT(typeof(UnityEngine.Animator)),
        _GT(typeof(UnityEngine.Experimental.Director.DirectorPlayer)),
        _GT(typeof(UnityEngine.Behaviour)),

        //dotween
        _GT(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(DG.Tweening.TweenExtensions)),

        _GT(typeof(UIWidget.AspectRatioSource)),

        //两人斗地主添加
        _GT(typeof(LRDDZ_LuaBehaviour)),
        _GT(typeof(LRDDZ_ResourceManager)),
        //_GT(typeof(Animator)),
        _GT(typeof(LRDDZ_MusicManager)),
        _GT(typeof(UICamera)),
        #if UNITY_STANDALONE_WIN
           // _GT(typeof(WindowsProcess)),
        #endif
        _GT(typeof(UICenterOnChild)),
        _GT(typeof(StaticUtils)),
        _GT(typeof(CoroutineResult)),
         _GT(typeof(PlayerPrefs)),
          _GT(typeof(Local_Login)),
          _GT(typeof(IPTest_Login)),
         
        //ngui
        /*_GT(typeof(UICamera)),
        _GT(typeof(Localization)),
        _GT(typeof(NGUITools)),

         * 
        _GT(typeof(UIRect)),
        _GT(typeof(UIWidget)),        
        _GT(typeof(UIWidgetContainer)),     
        _GT(typeof(UILabel)),        
        
        _GT(typeof(UIBasicSprite)),        
        _GT(typeof(UITexture)),
        _GT(typeof(UISprite)),           
        _GT(typeof(UIProgressBar)),
        _GT(typeof(UISlider)),
        _GT(typeof(UIGrid)),

        
        _GT(typeof(UITweener)),
        _GT(typeof(TweenWidth)),
        _GT(typeof(TweenRotation)),
        _GT(typeof(TweenPosition)),
        _GT(typeof(TweenScale)),
        _GT(typeof(UICenterOnChild)),    
        _GT(typeof(UIAtlas)),
        
          
         -- lxtd004 change 
         _GT(typeof(XMLResource)),
         _GT (typeof(ZPLocalization)),
         _GT (typeof(GameRoom)),
         _GT (typeof(ConnectDefine)),
         _GT(typeof(EginProgressHUD)),
         _GT (typeof(BuildPlatform)),
         _GT(typeof(GlobalVar)),
         _GT(typeof(GlobalVar.PlayerPosition)),
         _GT(typeof(SettingInfo)),
         //_GT(typeof(EginTools)),
        //_GT(typeof(EginUser)),
        //_GT(typeof(EginUser.eBankLoginType)),
        //_GT (typeof(EginUserUpdate)),
         * 	//_GT (typeof(HttpConnect)),
		//_GT (typeof(HttpResult)),
         *   //_GT(typeof(ProtocolHelper)), 
         */   
        
    };

    public static BindType _GT(Type t) {
        return new BindType(t);
    }

}
