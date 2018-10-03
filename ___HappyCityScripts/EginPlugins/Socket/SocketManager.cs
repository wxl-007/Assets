using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Threading;
using System.Text;
using System.Net;
using System.Net.Sockets;

public class SocketManager : MonoBehaviour {
	private readonly string UNITY_CLIENT_SOCKET_DISSCONNECT = "UNITY_CLIENT_SOCKET_DISSCONNECT";
	private const string UNITY_CLIENT_SOCKET_ONDISSCONNECT = "UNITY_CLIENT_SOCKET_ONDISSCONNECT";
    public const string UNITY_HOST_EXCEPTION = "@Exception:SWITCHHOST";

    private static int SOCKETMANAGER_TIMEOUT = 30;//socketManager超时
    private static int m_SocketConnect_capacity = 3;//socket连接数
    private static int Max_ReconnectCount = 1; //Socket重连次数
    private static int heartInterval = 7000; //socket心跳间隔(毫秒)
    private static int socketTimeout = 8;//socket连接超时
    private static int m_TokenTimeout = 5;//获取token超时

	 
	//是否使用队列发送Socket消息
	public bool _IsListSendSocket = true;
	public int m_SameSendTimeInterval = 1;//相同请求发送间隔
	//发送对象
	public class SocketSend {
		public SocketSend(string data,int level,float time) 
		{
			sendData = data;
			priority = level;
			removeTime = removeTime;
		}
		public int priority = 5;		//优先级0级为最优先级最低默认5级,如果8级以上(不包括8)的将在切换界面的时候不会从发送队列中消除
		public string sendData = "";	//数据
		public bool isSend = false;		//是否已经发送
		public float removeTime = 0;	//发送后移除列表时间
	}
	public List<SocketSend> m_SendList = new List<SocketSend>();//发送队列 
	public int m_SendTimeInterval = 1;//发送间隔
	public float m_SendTimeRecord = 0;//发送间隔记录


    //private const string UNITY_CLIENT_SOCKET_ONDISSCONNECT = "!!! ";

    private static bool applicationIsQuitting = false;
    private static SocketManager _instance;
    private static SocketManager _lobbyInstance;
    private string m_ContainerName;//mono.name 不能在子线程中使用

    private const string gameSocketManager = "SocketManagerContainer";
    private const string lobbySocketManager = "lobby_SocketManagerContainer";
    public static SocketManager Instance {
		get
        {
			if (!_instance) {
				_instance = FindSocketManager(gameSocketManager);
				_instance._IsListSendSocket = false;
			}
            return _instance;
        }
    }

    public static void UpdateConfigStr(string configStr)
    {
        if (string.IsNullOrEmpty(configStr)) return;

        string[] split = configStr.Split(new string[] { ","},StringSplitOptions.RemoveEmptyEntries);
        //["socketManager超时","socket连接数","Socket重连次数","socket心跳间隔","socket连接超时","获取token超时"]
        //30,3,1,7000,8,5

        ParseConfig(split,0, ref SOCKETMANAGER_TIMEOUT);
        ParseConfig(split,1, ref m_SocketConnect_capacity);
        ParseConfig(split,2, ref Max_ReconnectCount);
        ParseConfig(split,3, ref heartInterval);
        ParseConfig(split,4, ref socketTimeout);
        ParseConfig(split,5, ref m_TokenTimeout);
    }

    private static int ParseConfig(string[] split, int index, ref int srcVal)
    {
        int resultInt = 0;
        if (split != null && split.Length > index)
            int.TryParse(split[index], out resultInt);

        resultInt = Math.Max(0,resultInt);

        if (resultInt > 0) srcVal = resultInt;
        return resultInt;
    }

    public static SocketManager LobbyInstance
    {
        get
        {
            if(!_lobbyInstance) _lobbyInstance = FindSocketManager(lobbySocketManager);
            return _lobbyInstance;
        }
    }

    private static SocketManager FindSocketManager(string name)
    {
        string curName = name ?? gameSocketManager;
        SocketManager instance = curName == gameSocketManager ? _instance : _lobbyInstance;

        if (applicationIsQuitting) return null;

        if (!instance)
        {
            UnityEngine.Object obj_instance = new List<UnityEngine.Object>(GameObject.FindObjectsOfType(typeof(SocketManager))).Find(a => curName.CompareTo(a.name) == 0);
            instance = obj_instance == null ? null : obj_instance as SocketManager;
            //_instance = GameObject.FindObjectOfType(typeof(SocketManager)) as SocketManager;
            if (!instance)
            {
                //UnityEngine.Debug.Log("CK : ------------------------------ applicationIsQuitting = " + applicationIsQuitting);

                GameObject container = new GameObject();
                DontDestroyOnLoad(container);
                container.name = curName;
                instance = container.AddComponent(typeof(SocketManager)) as SocketManager;
                instance.m_ContainerName = curName;
            }
        }
        return instance;
    }

    private bool m_IsGame
    {
        get
        {
            return m_ContainerName == gameSocketManager;
        }
    }

    //public class MonoAction
    //{
    //    public long _DelayedTime;
    //    public System.Action _Action;
    //    public bool _IsCanceled = false;
    //    //public bool _IsActNow = false;//是否立即执行
    //}

    public SocketListener _socketListener;
	public SocketListener socketListener
	{
		get
		{
			return _socketListener;
		} 
		set 
		{  
			_socketListener = value;  
		} 
	}
	private SocketConnect socketConnect;
	private List<string> messageList = new List<string>();
    private string m_LastDisconnectInfo = string.Empty;
    private SocketConnect[] m_SocketConnect_array = new SocketConnect[m_SocketConnect_capacity];
    private SocketConnectInfo m_Info;//切换ip 重连使用

    private MonoThread m_MonoThread;
    //private List<System.Action> m_CurActionList = new List<Action>();
    //private List<MonoAction> m_MonoAction_list = new List<MonoAction>();
    //List<MonoAction> m_MonoAction_list_temp;

    private MonoAction m_CheckConnection_MonoAction;
    private MonoAction m_CheckTimeOut_MonoAction;
    //private MonoAction m_MonoAction_temp;

    /// <summary>
    /// 当时连接IP
    /// </summary>
    public string CurSocketIp
    {
        get
        {
            if (socketConnect == null)
            {
                return string.Empty;
            }
            return socketConnect.IpStr;
        }
    }

    /// <summary>
    /// 连接数量
    /// </summary>
    public int CurSocketConnectCount
    {
        get
        {
            SocketConnect[] array = Array.FindAll(m_SocketConnect_array, (a) => a._Stage == Stage.Connected);
            return array != null ? array.Length : 0;
        }
    }


    void Awake()
    {
        m_MonoThread = new MonoThread(this);
        m_MonoThread.Start();

        //m_SocketConnect_array = new SocketConnect[m_SocketConnect_capacity];

        for (int i = 0; i < m_SocketConnect_array.Length; i++)
        {
            m_SocketConnect_array[i] = new SocketConnect(this.name);
            m_SocketConnect_array[i].onSocketDisconnectAction = OnSocetDisconnectHandler;
            m_SocketConnect_array[i].SetReceiveMessageDelegate(new SocketConnect.DelegateReceiveMessage(SocketReceiveMessage));
            m_SocketConnect_array[i].SetDelegateDisconnect(new SocketConnect.DelegateDisconnect(SocketDisconnect));
        }

        m_CheckConnection_MonoAction = new MonoAction { _DelayedTime = 2, _Action = CheckConnectionState };
        m_CheckTimeOut_MonoAction = new MonoAction { _DelayedTime = SOCKETMANAGER_TIMEOUT, _Action = OnSocketManagerTimeOutHandler };
    }

    // Use this for initialization
    void Start () {
        applicationIsQuitting = false;



  //      socketConnect = new SocketConnect(this.name);
  //      //socketConnect = SocketConnect.Instance;
  //      socketConnect.SetReceiveMessageDelegate(new SocketConnect.DelegateReceiveMessage(SocketReceiveMessage));
  //socketConnect.SetDelegateDisconnect(new SocketConnect.DelegateDisconnect(SocketDisconnect));
  ////socketConnect.onSocketDisconnectAction = OnSocetDisconnectHandler;
    }
	
	
	// shawn.debug
	// UI operations must be placed in the main thread, so by the Update method to switch to the main thread.
	// TODO: Looking for a better way to achieve this function.
	// PS: "disconnectDelegate" is on a background thread.
	void Update () {	
		if(_IsListSendSocket)
		{
			SendUpdate();	//调用发送队列
		}


		while (socketListener != null && messageList.Count > 0) {
			string message = messageList[0];
			messageList.RemoveAt(0);

			if(message != null){
				if (message.Contains(UNITY_CLIENT_SOCKET_DISSCONNECT)) {
                    SocketListener sl = socketListener;
                    m_LastDisconnectInfo = message.Substring(UNITY_CLIENT_SOCKET_DISSCONNECT.Length);
                    //if (info.StartsWith(UNITY_CLIENT_SOCKET_ONDISSCONNECT))
                    //{
                    //    info = info.Substring(UNITY_CLIENT_SOCKET_ONDISSCONNECT.Length);
                    //    sl.OnSocketDisconnect(info);
                    //}
                    //sl.SocketDisconnect(m_LastDisconnectInfo);
				}
                else if (UNITY_CLIENT_SOCKET_ONDISSCONNECT.Equals(message))
                {
                    //socketConnect.CheckOnSocketDisconnect();//不再使用这种方法
                }
                else {
					socketListener.SocketReceiveMessage(message);
              
				}
			}

		}

        #region 使用MonoThread 代替
        //for (int i = 0; i < m_CurActionList.Count; i++)
        //{
        //    m_CurActionList[i]();
        //}
        //m_CurActionList.Clear();

        //调用 延迟时间已经到了的 MonoAction 并删除
        //for (int i = m_MonoAction_list.Count - 1; i >= 0; i--)
        //{
        //    if(m_MonoAction_list[i]._DelayedTime < System.DateTime.Now.Ticks )//|| m_MonoAction_list[i]._IsActNow)
        //    {
        //        if(!m_MonoAction_list[i]._IsCanceled)//如果action 被设置为取消,就不再执行
        //            m_MonoAction_list[i]._Action();

        //        m_MonoAction_list.RemoveAt(i);
        //    }
        //}

        //m_MonoAction_list_temp = new List<MonoAction>(m_MonoAction_list);
        //for (int i = 0; i < m_MonoAction_list_temp.Count;)
        //{
        //    m_MonoAction_temp = m_MonoAction_list_temp[i];
        //    //额外添加的功能,避免多线程删除操作,在删除的时候,把对应的角标置为null
        //    if (m_MonoAction_temp == null)
        //    {
        //        m_MonoAction_list.RemoveAt(i);
        //        m_MonoAction_list_temp.RemoveAt(i);
        //        continue;
        //    }

        //    if (m_MonoAction_list_temp[i]._DelayedTime < System.DateTime.Now.Ticks)//|| m_MonoAction_list[i]._IsActNow)
        //    {
        //        m_MonoAction_list.RemoveAt(i);
        //        m_MonoAction_list_temp.RemoveAt(i);

        //        if (!m_MonoAction_temp._IsCanceled)//如果action 被设置为取消,就不再执行
        //            m_MonoAction_temp._Action();

        //        continue;
        //    }

        //    m_MonoAction_temp = null;
        //    i++;
        //}
        #endregion 使用MonoThread 代替

    }

    void OnDestroy()
    {
        socketListener = null;
        Disconnect(this.name + " OnDestroy");//false
    }

    void OnApplicationQuit()
    {
        socketListener = null;
        applicationIsQuitting = true;
        Disconnect("Application quit");//false
    }

    /* ------ Socket Methods ------ */
    public void Connect(SocketConnectInfo info, string ipStr = null ,bool force = true) {
        if (!force) return;
        //UnityEngine.Debug.Log("ck debug : -------------------------------- Connect() = " + m_ContainerName);

        m_Info = info;
        messageList.Clear();
        //m_CurActionList.Clear();
        //m_MonoAction_list.Clear();
        //m_MonoAction_list.RemoveAll((a)=>a!=m_CheckTimeOut_MonoAction);
        m_MonoThread.ClearActionList();
        m_MonoThread.RemoveAll((a) => a != m_CheckTimeOut_MonoAction);
        for (int i = 0; i < m_SocketConnect_array.Length; i++)
        {
            if (m_SocketConnect_array[i] == null) continue;
            m_SocketConnect_array[i].ReSet();
            m_SocketConnect_array[i].Connect(info, ipStr, force);//同时启动多个socketconnect
        }
        socketConnect = m_SocketConnect_array[0];

        m_MonoThread.Add( m_CheckTimeOut_MonoAction, Get_SOCKETMANAGER_TIMEOUT());
        //AddMonoAction(Get_SOCKETMANAGER_TIMEOUT(), m_CheckTimeOut_MonoAction);
        //socketConnect.Connect(info, ipStr,force);
    }

    public void Disconnect(string info) {
        //UnityEngine.Debug.LogError("ck debug : -------------------------------- Disconnect() = " + m_ContainerName);

        socketConnect = null;
        m_Info = null;
		if(messageList != null) messageList.Clear();
        if(m_MonoThread != null) m_MonoThread.Clear();
		//if(socketConnect != null) { socketConnect.Disconnect(info); }//false

        for (int i = 0; i < m_SocketConnect_array.Length; i++)
        {
            if (m_SocketConnect_array[i] == null) continue;
            m_SocketConnect_array[i].ReSet();
            m_SocketConnect_array[i].Disconnect(info);
        }
    }
	public void SendPackageWithJson(JSONObject messageObj) {
		SendPackage(messageObj.ToString());
	}
	//发送内容,发送优先级和相同请求的间隔时间
	public void SendPackage(string str,int level,float time)
	{ 
		if(_IsListSendSocket)
		{  
			AddSendPackage(str,level,time);
		}
		else
		{
			StartSendPackage (str);
		}
	}
	//发送内容和发送优先级
	public void SendPackage(string str,int level)
	{

		if(_IsListSendSocket)
		{ 
			AddSendPackage(str,level,m_SameSendTimeInterval);
		}
		else
		{
			StartSendPackage (str);
		}
	}
	public void SendPackage(string str)
	{ 
		if(_IsListSendSocket)
		{  
			AddSendPackage(str,5,m_SameSendTimeInterval);
		}
		else
		{
			StartSendPackage (str);
		}
	}

	public void SendUpdate()
	{
		
		m_SendTimeRecord -= Time.deltaTime;

		if(m_SendList.Count > 0){  
			if(m_SendTimeRecord <= 0)
			{
				SocketSend tempSendObj = null;
				int tempLevel = 0;
				//移除时间到的对象,获取要发送的对象
				for (int i = m_SendList.Count-1; i >= 0; i--)
				{
					SocketSend item = m_SendList [i];
					if (item.isSend) {
						item.removeTime -= Time.deltaTime;
						if(item.removeTime <= 0)
						{ 
							m_SendList.RemoveAt (i);
						}
					} else {
						if (item.priority >= tempLevel)
						{
							tempLevel = item.priority;
							tempSendObj = item;
						}
					}
				} 
				if(m_SendTimeRecord <= 0 && tempSendObj != null)
				{
					m_SendTimeRecord = m_SendTimeInterval; 
					StartSendPackage (tempSendObj.sendData);
					tempSendObj.isSend = true;
				}
			}
			else
			{
				//移除时间到的对象
				for (int i = m_SendList.Count-1; i >= 0; i--)
				{
					SocketSend item = m_SendList [i];
					if (item.isSend) {
						item.removeTime -= Time.deltaTime;
						if(item.removeTime <= 0)
						{ 
							m_SendList.RemoveAt (i);
						}
					}  
				} 
			}
		}

		if(m_SendTimeRecord < -heartInterval/1000)
		{ 
			if (socketConnect != null && socketConnect._Stage == Stage.Connected)
			{ 
				//如果当前连接很长时间没有发送过消息就发送一个心跳
				m_SendTimeRecord = (float)m_SendTimeInterval-0.5f; 
				StartSendPackage ("{}");
			}
			else
			{
				m_SendTimeRecord = 0; 
			} 
		}
	}
	public void AddSendPackage(string str,int level,float time)
	{
		if (socketConnect != null) {
			if (m_SendList.Find (a => a.sendData == str) == null) {
				SocketSend tempSendObj = new SocketSend (str, level, time); 
				m_SendList.Add (tempSendObj); 
			} 
			Debug.Log ("jun======m_SendList.Count~~~~~"+m_SendList.Count);
		} 
	}
	//切换监听场景时按照规则移除对象
	public void RemoveSendList()
	{ 
		for (int i = m_SendList.Count-1; i >= 0; i--)
		{
			SocketSend item = m_SendList [i];
			if (item.isSend || item.priority <= 8) {
				m_SendList.RemoveAt (i);
			}  
		} 
	}

	public void StartSendPackage(string str)
	{ 
		if(socketConnect != null) socketConnect.SendPackage(str);
	}

	
	/* ------ Socket Delegate ------ */
	private void SocketReceiveMessage (string message) {
		messageList.Add(message);
	}
	
	private void SocketDisconnect (string disconnectInfo) {
		messageList.Add(UNITY_CLIENT_SOCKET_DISSCONNECT+disconnectInfo);
	}
	
	// shawn.debug
	public void SocketMessageRollback (string message) {
		messageList.Insert(0, message);
	}

    private void OnSocetDisconnectHandler()
    {
        if (socketListener != null) socketListener.OnSocketDisconnect(m_LastDisconnectInfo);
    }

    private void OnSocketManagerTimeOutHandler()
    {
        Disconnect(m_ContainerName + " : TimeOut");
        if (socketListener != null) socketListener.OnSocketManagerTimeOut(m_LastDisconnectInfo);
    }

    /// <summary>
    /// 从 m_MonoAction_list 中 移除 CheckTimeOut_MonoAction 
    /// </summary>
    private void Remove_CheckTimeOut_MonoAction()
    {
        //RemoveMonoAction(m_CheckTimeOut_MonoAction);
        m_MonoThread.Remove(m_CheckTimeOut_MonoAction);
    }

    #region 使用MonoThread替代
    /// <summary>
    /// 添加一个MotionAction
    /// </summary>
    /// <param name="delay"></param>
    /// <param name="action"></param>
    /// <returns></returns>
    //private MonoAction AddMonoAction(float delay, System.Action action)
    //{
    //    MonoAction monoAction = new MonoAction { _DelayedTime = System.DateTime.Now.AddSeconds(delay).Ticks, _Action = action };
    //    m_MonoAction_list.Add(monoAction);
    //    return monoAction;
    //}

    /// <summary>
    /// 覆盖原来的,或使用原来的 MotionAction
    /// </summary>
    /// <param name="delay"></param>
    /// <param name="monoAction"></param>
    /// <param name="isOverride"></param>
    /// <returns></returns>
    //private MonoAction AddMonoAction(float delay, MonoAction  monoAction, bool isOverride = false)
    //{
    //    if (monoAction == null) return null;
    //    if (m_MonoAction_list.Contains(monoAction))
    //    {
    //        if (isOverride || monoAction._IsCanceled) RemoveMonoAction(monoAction);
    //        else return monoAction;
    //    }

    //    monoAction._DelayedTime = System.DateTime.Now.AddSeconds(delay).Ticks;
    //    m_MonoAction_list.Add(monoAction);

    //    if (monoAction._IsCanceled) monoAction._IsCanceled = false;
    //    return monoAction;
    //}

    //private void RemoveMonoAction(MonoAction monoAction)
    //{
    //    int index = m_MonoAction_list.IndexOf(monoAction);
    //    if(index >= 0)
    //    {
    //        m_MonoAction_list[index] = null;
    //    }
    //}
    #endregion 使用MonoThread替代

    /// <summary>
    /// 判断 SocketConnect 是否是 当前连接的 那个
    /// </summary>
    /// <param name="conn"></param>
    /// <returns></returns>
    private bool IsSocketConnectSelected(SocketConnect conn)
    {
        return this.socketConnect == conn;
    }

    /// <summary>
    ///  socketconnect 断开连接时回调
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="stage"></param>
    private void OnSocetDisconnectHandler(SocketConnect conn, Stage stage)
    {
        if (IsSocketConnectSelected(conn))
        {
            if (socketListener != null) socketListener.OnSocketDisconnect(m_LastDisconnectInfo);//当前连接的 socketConnect 断开了 的消息
            m_MonoThread.Add( m_CheckTimeOut_MonoAction, Get_SOCKETMANAGER_TIMEOUT());//断开后立即开启 socketmanager超时 判断
                                                                                 
            //CheckConnectionState();
            m_MonoThread.Add( m_CheckConnection_MonoAction,0.5f);//放到主线程进行
        }
    }

    /// <summary>
    /// 检测当前 socketconnect array 的 总状态(组合的)
    /// </summary>
    private void CheckConnectionState()
    {
        SocketConnect temp = System.Array.Find(m_SocketConnect_array, (a) => a._Stage == Stage.Connected);//连接状态 是 Connected 的 SocketConnect
        if (temp != null)
        {//存在连接正常的 socketconnect
            this.socketConnect = temp;//切换到下一个 有效的 socketconnect
            this.socketConnect.OnStateConnected();
            //AddMonoAction(1, this.socketConnect.OnStateConnected);//中间间隔1秒
            SocketConnect[] allNotConnected = System.Array.FindAll(m_SocketConnect_array, (a) => a._Stage == Stage.NotConnected);
            foreach (var item in allNotConnected)
            {
                item.Reconnect();//所有不能正常连接的, 都重连
            }
        }
        else
        {
            temp = System.Array.Find(m_SocketConnect_array, (a) => a._Stage != Stage.NotConnected);//连接状态 不是 NotConnected 的 SocketConnect 
            if (temp != null)
            {//存在 还未 连接失败的 连接 (不是 全断开)
                //等待2秒 重新检测
                m_MonoThread.Add(m_CheckConnection_MonoAction,2f);
            }
            else
            {//所有 状态 都为 NotConnected (全断开)
                //切换ip
                //if (socketListener != null)
                //    socketListener.OnSocketManagerDisconnect(m_LastDisconnectInfo);
                if (m_Info == null) return;
                this.socketConnect = null;
                if (m_IsGame)
                {
                    PlatformGameDefine.playform.swithGameHostUrl(() =>
                    {
                        if (m_Info == null) return;
                        Connect(m_Info, PlatformGameDefine.playform.gameUrl, true);
                    });
                }
                else
                {
                    PlatformGameDefine.playform.swithSocketLobbyHostUrl(() =>
                    {
                        if (m_Info == null) return;
                        Connect(m_Info, PlatformGameDefine.playform.SocketLobbyUrl,true);
                    });
                }

            }
        }
    }

    private int Get_SOCKETMANAGER_TIMEOUT()
    {
        if (m_IsGame) return SOCKETMANAGER_TIMEOUT;
        else return 8 + SOCKETMANAGER_TIMEOUT;//大厅的TimeOut时间要比游戏的长8秒
    }

    public enum OverrideEnum
    {
        Override,
        Cancel,
        KeepBoth,
    }

    public enum Stage
    {
        NotConnected,   //未连接
        Connecting,     //正在连接
        Verifying,       //握手 验证 token
        Connected,      //连接成功,握手 并 验证 token 成功
        ReConnecting,   //正在重连
    }

    /* ------------------------------------------------------------------------------------------------ */
    /* ----------- SocketConnect Class ----------- */
    /* ------------------------------------------------------------------------------------------------ */
    private class SocketConnect {

        public SocketConnect(string name)
        {
            this.name = name;

            m_TokenTimeout_MonoAction._Action = () => Disconnect("获取token超时");
        }

        private SocketManager socketManager
        {
            get
            {
                return FindSocketManager(name);
            }
        }

        private bool m_IsSelected
        {
            get
            {
                return socketManager.IsSocketConnectSelected(this);
            }
        }

        private string name;

        private object lockObj = new object();
		public delegate void DelegateReceiveMessage(string message);
		public delegate void DelegateDisconnect(string disconnectInfo);
        public Stage _Stage;
		
		private Socket clientSocket;
		private Thread receiveThread;	// Receive message thread
		private Thread heartThread;		// Socket keep live thread
		private bool m_IsReceiveThreadRun;
		private bool m_IsheartThreadRun;

		private byte[] buffer = null;
		private int token = 0;

		private Queue packageQueue = Queue.Synchronized(new Queue());
		private DelegateReceiveMessage receiveMessageDelegate;
		private DelegateDisconnect disconnectDelegate; //重连不放在disconnectDelegate的原因是Disconnect方法在多处都会被调用,导致重连会发生多次调用的bug
        public System.Action<SocketConnect,Stage> onSocketDisconnectAction;//用于重连
        private Queue<string> m_SendPackgeQueue = new Queue<string>();

        private static Socket m_SampleSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

        private int m_ReconnectCount;

        private SocketConnectInfo m_Info;
        private string m_IpStr;
        public string IpStr
        {
            get { return m_IpStr; }
        }

        private MonoAction m_TokenTimeout_MonoAction = new MonoAction ();

        //消息发送、收取时间
        private DateTime m_TimeSend;
        private DateTime m_TimeReceive;

        class SimpleAsyncState
        {
            public bool _IsTimeOut;
        }

        //		private bool m_IsConnectSuccess;//BeginConnect 连接标识

        public void ReSet()
        {
            _Stage = Stage.NotConnected;
            DoDisconnect();

            if(socketManager && socketManager.m_MonoThread!= null)
                socketManager.m_MonoThread.Remove(m_OnDisconnect_MonoAction);

            m_ReconnectCount = 0;
        }

        #region 连接与重连
        public void Connect(SocketConnectInfo info, string ipStr = null, bool force = true)
        {//force: true 强制重连,会把已连接的断开, false 不强制,已连接是不重现连接
            _Stage = Stage.Connecting;
            m_Info = info;
            m_IpStr = ipStr;

            //EginTools.Log
            EginTools.Log("1 Socket: Create new connect: id: " + info.roomId + " host:" + info.roomHost + " port: " + info.roomPort + " db: " + info.roomDBName);
            //UnityEngine.Debug.Log("CK : ------------------------------ ipStr = " + ipStr + ", platform gameUrl = " + PlatformGameDefine.playform.gameUrl);

            if (!force && clientSocket != null && clientSocket.Connected) return;

            DoDisconnect();//false

            lock (lockObj)
            {
                clientSocket = m_SampleSocket;// new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

                // shawn.update
                try
                {
                    string[] ipArr = new string[2];
                    //ipArr[0] = info.roomHost;
                    //ipArr[1] = info.roomPort;

                    //if (Utils._IsIPTest)
                    //    if (!string.IsNullOrEmpty(ipArr[0])) ipArr[0] = null;//测试ip的不使用 房间信息的ip

                    if (!string.IsNullOrEmpty(ipStr) || string.IsNullOrEmpty(ipArr[0]))
                    {
                        char[] splS = ":".ToCharArray();
                        //ipArr = string.IsNullOrEmpty(ipStr) ? PlatformGameDefine.playform.gameUrl.Split(splS) : ipStr.Split(splS);
                        ipStr = string.IsNullOrEmpty(ipStr) ? PlatformGameDefine.playform.gameUrl : ipStr;
                        if (Constants.isEditor) UnityEngine.Debug.Log("ck debug : --------------------------------<color=orange>" + name + " connecting ipStr = " + ipStr+"</color>");

                        if (ipStr.StartsWith("http://")) ipStr = ipStr.Substring(7);//把这个去掉,避免dns解析卡顿
                        ipArr = ipStr.Split(splS);

                        //info.roomHost = ipArr[0];
                        //info.roomPort = ipArr[1];
                        EginTools.Log("2 Socket: Real connect: host:" + ipArr[0] + " port: " + ipArr[1]);
                    }

                    //UnityEngine.Debug.Log("CK : ------------------------------ roomHost = " + info.roomHost + ", roomPort = " + info.roomPort + ", url = " + PlatformGameDefine.playform.gameUrl);
                    IPAddress ipAddress = null;// IPAddress.Parse(info.roomHost);
                    if (IPAddress.TryParse(ipArr[0], out ipAddress)) { }
                    else ipAddress = Dns.GetHostEntry(ipArr[0]).AddressList[0];

                    IPEndPoint ipEndpoint = new IPEndPoint(ipAddress, int.Parse(ipArr[1]));
                    //			m_IsConnectSuccess = false;

                    //if(clientSocket.AddressFamily != ipAddress.AddressFamily)
                    clientSocket = new Socket(ipAddress.AddressFamily, SocketType.Stream, ProtocolType.Tcp);

                    //if (Utils._IsIPTest)
                    //    UnityEngine.Debug.Log("CK : ------------------------------<color=green> clientSocket = " + clientSocket + ", ipEndpoint = " + ipEndpoint + ", info.roomHost = " + info.roomHost + ", ipStr = " + ipStr + "</color>");//测试ip的时候打印当前ip

                    IAsyncResult result = clientSocket.BeginConnect(ipEndpoint, new AsyncCallback(ConnectCallback), new SimpleAsyncState());
                    socketManager.StartCoroutine(DoConnectTimeOut(result));

                    //			bool success = result.AsyncWaitHandle.WaitOne(socketTimeout, true);
                    //			if (!success) {
                    //				Disconnect("Connect time out");
                    //			} else {
                    //				receiveThread = new Thread(new ThreadStart(ReceiveData));
                    //				receiveThread.IsBackground = true;
                    //				receiveThread.Start();
                    //			}
                }
                catch (Exception e)
                {
                    if (Constants.isEditor) UnityEngine.Debug.Log("CK : -----------------------------Connect exception : message = " + e.Message);
                    Disconnect(UNITY_HOST_EXCEPTION + " : " + e.Message);
                }
            }
        }
        private void ConnectCallback(IAsyncResult asyncConnect)
        {
            SimpleAsyncState state = (SimpleAsyncState)asyncConnect.AsyncState;
            if (state._IsTimeOut) return;

            if (asyncConnect.IsCompleted && clientSocket != null && clientSocket.Connected)
            {
                _Stage = Stage.Verifying;
                m_IsReceiveThreadRun = true;
                receiveThread = new Thread(new ThreadStart(ReceiveData));
                receiveThread.IsBackground = true;
                receiveThread.Start();
            }
            else
            {
                Disconnect(name +" : " + ZPLocalization.Instance.Get("HttpConnectFailed"));//"asyncConnect is not completed");//true
            }

            EginTools.Log("4 Socket: Connect success");
        }
        IEnumerator DoConnectTimeOut(IAsyncResult result, string message = null)
        {
            float timeOut = socketTimeout;
            while ((timeOut -= Time.deltaTime) > 0)
            {
                //if (Constants.isEditor) UnityEngine.Debug.Log("CK : ------------------------------ timeout = " + timeOut);

                if (result.IsCompleted) yield break;
                yield return 0;
            }

            if (message == null) message = "Connect time out";
            UnityEngine.Debug.Log("CK : ------------------------------ " + name + " : time out = " + message);
            SimpleAsyncState state = (SimpleAsyncState)result.AsyncState;
            state._IsTimeOut = true;
            Disconnect(message);//true
        }

        public void Disconnect(string info)
        {
            UnityEngine.Debug.Log("ck debug : -------------------------------- " + name +" Disconnect = " + info);

            //PlatformGameDefine.playform.swithGameHostUrl();//切换游戏的IP
            if (clientSocket != null) info = UNITY_CLIENT_SOCKET_ONDISSCONNECT + info;
            DoDisconnect();

            //不再使用 SocketDisconnect
            if (disconnectDelegate != null)
            {
                if (Constants.isEditor) info = "name = " + name + " :\r\n " + info;
                disconnectDelegate(info);
            }
            //EginTools.Log("3 Socket: Disconnect reason: " + info);
        }
        private void Disconnect()
        {
            Disconnect("Unknow");//false
        }
        private void DoDisconnect()
        {
            lock (lockObj)
            {
                if (clientSocket != null)
                {
                    //    if (clientSocket.Connected) {
                    ////					clientSocket.Shutdown(SocketShutdown.Both); // shawn.debug Maybe Error
                    ////					clientSocket.Close();
                    //	    clientSocket.Disconnect(false);
                    //    }
                    //    clientSocket = null;

                    try
                    {
                        if (clientSocket.Connected) clientSocket.Shutdown(SocketShutdown.Both);
                        clientSocket.Close();
                    }
                    catch (System.Exception) { }
                    clientSocket = null;

                    //if (receiveMessageDelegate != null) receiveMessageDelegate(UNITY_CLIENT_SOCKET_ONDISSCONNECT);//这里发送消息是因为StartCoroutine(等协程相关方法) 需要在主线程中进行

                    if(_Stage != Stage.NotConnected && m_ReconnectCount < Max_ReconnectCount)
                    {
                        _Stage = Stage.ReConnecting;
                        Reconnect();//取代上面的调用方式
                    }
                    else
                    {
                        _Stage = Stage.NotConnected;
                    }

                    if (onSocketDisconnectAction != null && socketManager != null)
                        socketManager.m_MonoThread.Add(()=> onSocketDisconnectAction(this, _Stage));
                }
            }
            if (receiveThread != null && receiveThread.IsAlive)
            {
                if (applicationIsQuitting) receiveThread.Abort();
                m_IsReceiveThreadRun = false;
            }
            if (heartThread != null && heartThread.IsAlive)
            {
                if (applicationIsQuitting) heartThread.Abort();
                m_IsheartThreadRun = false;
            }
            packageQueue.Clear();
            this.buffer = null;
            this.token = 0;
        }

        #region 重连相关
        #region 换成MonoAction 调用方式
        //private Coroutine m_OnDisconnect_Coroutine;
        //IEnumerator DoCheckOnSocketDisconnect()
        //{
        //    float m_curDisConnectTime = 0;
        //    while (m_curDisConnectTime < 1)//采用这种方法的原因是为了解决异步线程导致的clientSocket == null 不可控问题. //同时可以解决连不上的时候高频率的重连问题
        //    {
        //        m_curDisConnectTime += Time.deltaTime;
        //        yield return 0;
        //        if (clientSocket != null && clientSocket.Connected) yield break;//在m_curDisConnectTime达到最大值前已经连上,就不用重连
        //    }

        //    if (onSocketDisconnectAction != null) onSocketDisconnectAction();
        //    m_OnDisconnect_Coroutine = null;
        //}

        //public void CheckOnSocketDisconnect()
        //{
        //    if (m_OnDisconnect_Coroutine != null) socketManager.StopCoroutine(m_OnDisconnect_Coroutine);//防止发生多次调用
        //    m_OnDisconnect_Coroutine = socketManager.StartCoroutine(DoCheckOnSocketDisconnect());
        //}
        #endregion 换成MonoAction 调用方式

        private MonoAction m_OnDisconnect_MonoAction;
        public void Reconnect()
        {
            UnityEngine.Debug.Log("ck debug : -------------------------------- "+ name +" do Reconnect() " + m_ReconnectCount);

            //if (m_OnDisconnect_MonoAction != null)
            //    m_OnDisconnect_MonoAction._IsCanceled = true;//防止发生多次调用


            //m_OnDisconnect_MonoAction = socketManager.AddMonoAction(2 + m_ReconnectCount, ()=> {
            //    if (clientSocket != null && clientSocket.Connected) return;//在m_curDisConnectTime达到最大值前已经连上,就不用重连

            //    //if (onSocketDisconnectAction != null) onSocketDisconnectAction();
            //    m_ReconnectCount++;
            //    Connect(m_Info,m_IpStr);
            //});

            if (m_OnDisconnect_MonoAction == null)
            {
                m_OnDisconnect_MonoAction = new MonoAction { _Action = ()=> 
                {
                    if (clientSocket != null && clientSocket.Connected) return;//在m_curDisConnectTime达到最大值前已经连上,就不用重连
                    
                    m_ReconnectCount++;
                    Connect(m_Info,m_IpStr);
                } };
            }

            socketManager.m_MonoThread.Add(m_OnDisconnect_MonoAction, 2 + m_ReconnectCount, AddEnum.Override);
        }
        #endregion 重连相关
        #endregion 连接与重连


        /* ------ Socket Methods ------ */
        #region 封装并发送数据
        public void SendPackageWithJson(JSONObject messageObj)
        {
            SendPackage(messageObj.ToString());
        }

		 
        public void SendPackage(string str)
		{
			//string str = m_SendPackgeQueue.Dequeue();
			EginTools.Log("5 Socket: Send: " + str);

			if (clientSocket == null || !clientSocket.Connected)
			{
				Disconnect("Connection Lost");
				return;
			}

			byte[] msg = Encoding.UTF8.GetBytes(str);
			if (this.token > 0)
			{
				int length = msg.Length;
				for (int i = 0; i < length; i++)
				{
					msg[i] = (byte)(msg[i] ^ this.token);
				}
				byte[] head;
				if (length < 255)
				{
					head = new byte[1];
					head[0] = (byte)(length ^ token);
				}
				else
				{
					head = new byte[5];
					head[0] = (byte)(0xff ^ token);
					//head[4] = (byte)(((length >> 24) & 0xff) ^ token);
					//head[3] = (byte)(((length >> 16) & 0xff) ^ token);
					//head[2] = (byte)(((length >> 8) & 0xff) ^ token);
					//head[1] = (byte)((length & 0xff) ^ token);

					head[1] = (byte)(((length >> 24) & 0xff) ^ token);
					head[2] = (byte)(((length >> 16) & 0xff) ^ token);
					head[3] = (byte)(((length >> 8) & 0xff) ^ token);
					head[4] = (byte)((length & 0xff) ^ token);
				}
				byte[] data = new byte[head.Length + length];
				head.CopyTo(data, 0);
				msg.CopyTo(data, head.Length);
				msg = data;
			}

			try
			{
				IAsyncResult asyncSend = clientSocket.BeginSend(msg, 0, msg.Length, SocketFlags.None, new AsyncCallback(SendCallback), new SimpleAsyncState());
				socketManager.m_MonoThread.Add(() => socketManager.StartCoroutine(DoConnectTimeOut(asyncSend, "asyncSend connect time out")));//添加超时判断

				//				SocketManager.Instance.StartCoroutine(DoConnectTimeOut(asyncSend));
				//				bool result = asyncSend.AsyncWaitHandle.WaitOne(socketTimeout, true);
				//				if (!result) {
				//					EginTools.Log("8 Send Failed: " + result);
				//				}

                if ((Utils._IsTestAgreement) && !str.Equals("{}"))
                {
                    m_TimeSend = DateTime.Now;
                    SocketConnect[] conns = Array.FindAll(socketManager.m_SocketConnect_array, (a) => a._Stage == Stage.Connected);
                    UnityEngine.Debug.Log("[Socket]<color=red>Send</color>  IP:" + IpStr + " Count:" + conns.Length + " ------------------------------name = " + name + ", Package = " + str);
                }
			}
			catch (Exception e)
			{
				EginTools.Log("7 Send Error: " + e);
				//UnityEngine.Debug.Log("CK : ------------------------------ exception 7 = " + e.Message );

				Disconnect("SendPackage : " + ZPLocalization.Instance.Get("Socket_UnexpectedDisconnect"));
			}
		}
        private void SendCallback(IAsyncResult asyncSend)
        {
            //EginDefine.Log("Socket: Send success");
        }


        /* ------ Other Methods ------ */
        private void ShakeHands(byte[] data)
        {
            try
            {
                string tokenStr = Encoding.UTF8.GetString(data);
                EginTools.Log("9 Socket: Receive: " + tokenStr);

                JSONObject tokeDict = new JSONObject(tokenStr);
                int sample = (int)tokeDict["body"]["sample"].n;
                int pk = (int)tokeDict["body"]["pubkey"][0].n;
                int n = (int)tokeDict["body"]["pubkey"][1].n;
                System.Random rand = new System.Random();
                int token = rand.Next(1, 255);
                int crypt_sample = sample ^ token;
                int crypt_token = RsaEncrypt(token, pk, n);
                // Send Shake Hands
                JSONObject sendTokenBody = new JSONObject();
                sendTokenBody.AddField("crypt_sample", crypt_sample);
                sendTokenBody.AddField("crypt_token", crypt_token);
                JSONObject sendToken = new JSONObject();
                sendToken.AddField("type", "socket");
                sendToken.AddField("tag", "token");
                sendToken.AddField("body", sendTokenBody);
                SendPackageWithJson(sendToken);
                // Send Login
                this.token = token;

                OnStateConnected();

                


                // Heart Thread
                m_IsheartThreadRun = true;
                heartThread = new Thread(new ThreadStart(SendHeartPackage));
                heartThread.IsBackground = true;
                heartThread.Start();
            }
            catch (Exception e)
            {
                EginTools.Log("10 Socket: ShakeHands Error: " + e);
            }
        }

        /// <summary>
        /// //连接成功, 握手成功, 获取token 成功
        /// </summary>
        public void OnStateConnected()
        {
            UnityEngine.Debug.Log("ck debug : -------------------------------- "+name +", OnStateConnected()  ");

            _Stage = Stage.Connected;//连接成功, 握手成功, 获取token 成功
            socketManager.Remove_CheckTimeOut_MonoAction();//从延迟执行列表中立刻执行(移除) CheckTimeOut_MonoAction
            m_ReconnectCount = 0;

            if (socketManager.IsSocketConnectSelected(this))
                socketManager.m_MonoThread.Add(() => ProtocolHelper.Send_login(socketManager.m_IsGame));
        }

        private int RsaEncrypt(int a, int e, int n)
        {
            int odd = 1;
            while (e > 1)
            {
                if ((e & 1) != 0)
                {
                    odd = odd * a % n;
                }
                a = a * a % n;
                e /= 2;
            }
            return a * odd % n;
        }


        private void SendHeartPackage()
        {
            while (m_IsheartThreadRun)
            {
                Thread.Sleep(heartInterval);
                if (clientSocket != null && clientSocket.Connected && m_IsheartThreadRun)
				{ 
					if(socketManager.IsSocketConnectSelected(this) && socketManager._IsListSendSocket)
					{
						
					}
					else 
					{
						SendPackage("{}");
					}

				}
                    

                if (Constants.isEditor)
                {
                    SocketConnect[] conns = Array.FindAll(socketManager.m_SocketConnect_array, (a) => a._Stage == Stage.Connected);
                    UnityEngine.Debug.Log("ck debug : -------------------------------- name = "+ name +", conns connected count = " + conns.Length);
                }
            }
        }

        private JSONObject LoginMessage()
        {
            SocketConnectInfo connectInfo = SocketConnectInfo.Instance;

            JSONObject messageBody = new JSONObject();
            messageBody.AddField("userid", connectInfo.userId);
            messageBody.AddField("password", connectInfo.userPassword);
            messageBody.AddField("dbname", connectInfo.roomDBName);
            messageBody.AddField("version", "0");                   ///0
			messageBody.AddField("client_type", "0");
            messageBody.AddField("client_info", "WIN");          // 0928  UNITY  解决排行榜 不显示的问题  更改  此处 .
            messageBody.AddField("roomid", connectInfo.roomId);
            messageBody.AddField("fixseat", true);
            //messageBody.AddField("first_money", "");
            JSONObject messageObj = new JSONObject();
            messageObj.AddField("type", "account");
            messageObj.AddField("tag", "login");
            messageObj.AddField("body", messageBody);
            return messageObj;
        }

        #endregion 封装并发送数据


        #region 接收并处理数据
        private void ReceiveData()
        {
            while (m_IsReceiveThreadRun)
            {
                if (!clientSocket.Connected)
                {
                    Disconnect("Connection Lost");
                    break;
                }
                try
                {
                    if (this.token <= 0)
                    {
                        byte[] tokenbytes = new byte[1024];

                        socketManager.m_MonoThread.Add(m_TokenTimeout_MonoAction,m_TokenTimeout);// 添加超时
                        int len = clientSocket.Receive(tokenbytes);
                        socketManager.m_MonoThread.Remove(m_TokenTimeout_MonoAction);
                        if (len <= 0)
                        {
                            Disconnect("Read Failed!");
                            break;
                        }
                        else
                        {
                            byte[] tokendata = new byte[len];
                            Array.Copy(tokenbytes, tokendata, len);
                            ShakeHands(tokendata);
                        }
                    }
                    else
                    {
                        byte[] data = new byte[4096];
                        int len = clientSocket.Receive(data);
                        if (len <= 0)
                        {
                            Disconnect("Read Failed!");
                            break;
                        }
                        else
                        {
                            if (buffer == null || buffer.Length == 0)
                            {
                                buffer = new byte[len];
                                Array.Copy(data, buffer, len);
                            }
                            else
                            {
                                byte[] mbytes = new byte[buffer.Length + len];
                                Array.Copy(buffer, mbytes, buffer.Length);
                                Array.Copy(data, 0, mbytes, buffer.Length, len);
                                buffer = mbytes;
                            }
                            ProcessPackage();
                        }
                    }
                }
                catch (Exception e)
                {
                    //UnityEngine.Debug.Log("CK : ------------------------------ exception 6 = " + e.Message );

                    EginTools.Log("6 Read Error: " + e);
                    Disconnect("ReceiveData : " + ZPLocalization.Instance.Get("Socket_UnexpectedDisconnect"));
                    break;
                }
            }
        }


        private void ProcessPackage()
        {
            while (buffer != null && buffer.Length > 0)
            {
                try
                {
                    int index = 0;
                    int length = buffer[index++] ^ this.token;
                    if (length == 255)
                    {
                        if (buffer.Length <= 5)
                        {
                            break;
                        }
                        length = 0;
                        length += (buffer[index++] ^ this.token) << 24;
                        length += (buffer[index++] ^ this.token) << 16;
                        length += (buffer[index++] ^ this.token) << 8;
                        length += (buffer[index++] ^ this.token);
                    }
                    if (buffer.Length < length + index)
                    {
                        break;
                    }
                    byte[] data = new byte[length];
                    for (int i = 0; i < length; i++)
                    {
                        data[i] = (byte)(buffer[i + index] ^ this.token);
                    }
                    if (buffer.Length == length + index)
                    {
                        buffer = null;
                    }
                    else
                    {
                        byte[] mbytes = new byte[buffer.Length - length - index];
                        Array.Copy(buffer, length + index, mbytes, 0, mbytes.Length);
                        buffer = mbytes;
                    }
                    string message = Encoding.UTF8.GetString(data);

                    if (receiveMessageDelegate != null && packageQueue.Count == 0)
                    {
                        receiveMessageDelegate(message);
                    }
                    else
                    {
                        packageQueue.Enqueue(message);
                    }

                    if (Utils._IsTestAgreement)
                    {
                        m_TimeReceive = DateTime.Now;
                        Double dif = 0f;
                        if (m_TimeSend != null)
                        {
                            TimeSpan ts = m_TimeReceive.Subtract(m_TimeSend);
                            dif = ts.TotalMilliseconds;
                        }

                        UnityEngine.Debug.Log("[Socket]<color=red>Receive</color> CostTime：" + dif + " ------------------------------name = " + name + ", Package = " + message);
                    }

                    EginTools.Log("11 Socket: Receive: " + message);
                }
                catch (Exception e)
                {
                    EginTools.Log("Socket: ProcessPackage Error: " + e);
                    break;
                }
            }
        }

        #endregion 接收并处理数据
        
        
        /* ------ Socket Delegate ------ */
        public void SetReceiveMessageDelegate (DelegateReceiveMessage arg) {
			receiveMessageDelegate = arg;
			sendQueueMessage();
		}
		
		public void SetDelegateDisconnect (DelegateDisconnect arg) {
			disconnectDelegate = arg;
		}
		
		private void sendQueueMessage () {
			while (receiveMessageDelegate != null && packageQueue.Count > 0) {
				receiveMessageDelegate((string)packageQueue.Dequeue());
			}
		}
	}
}
