using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class EginUser {
    #region 保存用户对应的ip和配置文件相关内容区域
    private const string GFname = "GFname";
    private const string WFname = "WFname";
    private const string GFname1 = "GFname1";
    private const string WFname1 = "WFname1";
    private const string GameIP = "GameIP";
    private const string WebIP = "WebIP";
    private const string GameIPUsers = "GameIPUsers";
    private const string WebIPUsers = "WebIPUsers";

    public static string _GFname { get { return ObtainFullKey(GFname); } }
    public static string _WFname { get { return ObtainFullKey(WFname); } }
    public static string _GFname1 { get { return ObtainFullKey(GFname1); } }
    public static string _WFname1 { get { return ObtainFullKey(WFname1); } }
    public static string _GameIP { get { return ObtainFullKey(GameIP); } }
    public static string _WebIP { get { return ObtainFullKey(WebIP); } }

    private static string _WebIPUsers { get { return ObtainPlatformKey(WebIPUsers); } }
    private static string _GameIPUsers { get { return ObtainPlatformKey(GameIPUsers); } }

    public static string _GameIPForCurUser
    {
        get
        {
            string usernamesStr = PlayerPrefs.GetString(_GameIPUsers);
            string otherGameIP = string.Empty;
            if (usernamesStr.Contains("," + EginUser.Instance.username + ","))
            {
                otherGameIP = PlayerPrefs.GetString(_GameIP);//取自己的
            }
            else
            {
                string[] usernames = usernamesStr.Split(new string[] { "," }, System.StringSplitOptions.RemoveEmptyEntries);
                if (usernames == null || usernames.Length < 1) return "";

                string currentUsername = EginUser.Instance.username;
                EginUser.Instance.username = usernames[usernames.Length - 1];
                otherGameIP = PlayerPrefs.GetString(_GameIP);
                EginUser.Instance.username = currentUsername;
            }

            return otherGameIP;
        }
    }

    public static void AddGameIPUsers(string encryptedIpStr)
    {
        if (!string.IsNullOrEmpty(EginUser.Instance.username))
        {//保存用户的ip
            PlayerPrefs.SetString(EginUser._GameIP, encryptedIpStr);
            PlayerPrefs.Save();
            EginUser.AddGameIPUsers();
        }
    }
    public static void AddGameIPUsers()
    {
        string username = EginUser.Instance.username + ",";
        string usernamesStr = PlayerPrefs.GetString(_GameIPUsers,string.Empty);
        if (usernamesStr.EndsWith("," + username)) return;

        if (string.IsNullOrEmpty(usernamesStr)) usernamesStr = "," + username;
        else usernamesStr = usernamesStr.Replace("," + username, ",") + username;
        PlayerPrefs.SetString(_GameIPUsers, usernamesStr);
        PlayerPrefs.Save();
    }

    public static string _WebIPForCurUser
    {
        get
        {
            string usernamesStr = PlayerPrefs.GetString(_WebIPUsers);
            string otherWebIP = string.Empty;
            if (usernamesStr.Contains("," + EginUser.Instance.username + ","))
            {
                otherWebIP = PlayerPrefs.GetString(_WebIP);//取自己的
            }
            else
            {
                string[] usernames = usernamesStr.Split(new string[] { "," }, System.StringSplitOptions.RemoveEmptyEntries);
                if (usernames == null || usernames.Length < 1) return "";

                string currentUsername = EginUser.Instance.username;
                EginUser.Instance.username = usernames[usernames.Length - 1];
                otherWebIP = PlayerPrefs.GetString(_WebIP);
                EginUser.Instance.username = currentUsername;
            }

            return otherWebIP;
        }
    }

    public static void AddWebIPUsers(string encryptedIPStr)
    {
        if (!string.IsNullOrEmpty(EginUser.Instance.username))
        {//保存У膇p
            PlayerPrefs.SetString(EginUser._WebIP, encryptedIPStr);
            PlayerPrefs.Save();
            EginUser.AddWebIPUsers();
        }
    }

    public static void AddWebIPUsers()
    {
        string username = EginUser.Instance.username + ",";
        string usernamesStr = PlayerPrefs.GetString(_WebIPUsers,string.Empty);
        if (usernamesStr.EndsWith("," + username)) return;

        if (string.IsNullOrEmpty(usernamesStr)) usernamesStr = "," + username;
        else usernamesStr = usernamesStr.Replace("," + username, ",") + username;
        PlayerPrefs.SetString(_WebIPUsers, usernamesStr);
        PlayerPrefs.Save();
    }
    #endregion 保存用户对应的ip和配置文件相关内容区域

    private static EginUser _instance;
	public static EginUser Instance {
		get {
			if(_instance == null) {
				_instance = new EginUser();
			}
			return _instance;
		}
	}
	
	// Basic Info
	public string uid;
	public string nickname;
	public int level;
	public int vipLevel;
	public int levelExp;
	public int nextLevelExp;
	public int avatarNo;
	public string avatarUrl;
	public bool sex;
	// Save Info
	public string username;
	public string password;
	public string session;
	public bool weekPassword;
	// Change Info
	public string bagMoney;
	public string bankMoney;
	public string goldIngot;
	public string goldCoin;
	public string happyCard;
	public int mailCount;

    public string device_id;

	public string agentID;
	// Other
	public bool isGuest;

    //微信登录需要的数据
    public string wxOpenId;
    public string wxNickname;
    public int wxSex;
    public string wxUnionId;

	public enum eBankLoginType{PASSWORD, PHONE_AUTH, PHONE_CODE, WECHAT}
	public eBankLoginType bankLoginType = eBankLoginType.PASSWORD;
 

    //背景音乐开关510k
    public bool musicon;
 
 	public void InitUserWithDict(Dictionary<string, string> dict, string sessionArg) {
        //Dictionary<string, string> dict = result.ToDictionary();
        if (!dict.ContainsKey("id") && dict.ContainsKey("userid")) dict["id"] = dict["userid"];
        if (!dict.ContainsKey("exp") && dict.ContainsKey("exp_value")) dict["exp"] = dict["exp_value"];
        if (!dict.ContainsKey("next_exp") && dict.ContainsKey("exp_value")) dict["next_exp"] = dict["exp_value"];
        if (!dict.ContainsKey("avatar_img")) dict["avatar_img"] = "";
        if (!dict.ContainsKey("agent")) dict["agent"] = "";
        if (!dict.ContainsKey("weak")) dict["weak"] = "0";
        if (!dict.ContainsKey("gold_money")) dict["gold_money"] = "0";
 
		uid = dict["id"];
		nickname = Regex.Unescape(dict["nickname"]);
		level = int.Parse(dict["level"]);
		vipLevel = int.Parse(dict["vip_level"]);
		levelExp = int.Parse(dict["exp"]);
		nextLevelExp = int.Parse(dict["next_exp"]);
		avatarUrl = dict["avatar_img"];
		UpdateAvatarNo(int.Parse(dict["avatar_no"]));

		if (dict.ContainsKey ("agent")) {
				agentID = dict ["agent"];
		} else {
			agentID=null;
		}

		
		username = dict["username"];
		password = dict["password"];
		session = sessionArg;
		weekPassword = (1 == int.Parse(dict["weak"]));
		
		bagMoney = dict["bag_money"].ToString();
		bankMoney = dict["bank_money"].ToString();
		goldIngot = dict["dollar_money"].ToString();
		goldCoin = dict["gold_money"].ToString();
        happyCard = dict["happycard"].ToString();
        if (dict.ContainsKey("gfname"))
        {
			PlayerPrefs.SetString(_GFname, dict["gfname"]);
        }
        if (dict.ContainsKey("wfname"))
        {
			PlayerPrefs.SetString(_WFname, dict["wfname"]);
		}

        if (dict.ContainsKey("gfname1"))
        {
            PlayerPrefs.SetString(_GFname1, dict["gfname1"]);
        }
        if (dict.ContainsKey("wfname1"))
        {
            PlayerPrefs.SetString(_WFname1, dict["wfname1"]);
        }
        PlayerPrefs.Save();
    }
	
	public void InitGuestWithDict(Dictionary<string, string> dict, string sessionArg) {
		// shawn.debug : Service GuestLogin miss: levelExp, nextLevelExp, weekPassword, goldCoin, happyCard
		dict.Add("exp", "0");
		dict.Add("next_exp", "1000");
		dict.Add("weak", "0");
		dict.Add("gold_money", "0");
		dict.Add("happycard", "0");
		
		InitUserWithDict(dict, sessionArg);
	}
	
	public void UpdateAvatarNo (int tempNo) {
		if (tempNo <= 0 || tempNo > 20) { tempNo = 2; }
		
		avatarNo = tempNo;
		sex = (avatarNo%2 == 0);
	}
	
	public void UpdateUserWithDict(Dictionary<string, string> dict) {
		//Egin: 11 Socket: Receive: {"body": {"username": "bj1234567", 
		//"bank_validate": 0, 
		//"realname": "", 
		//"inviter_id": null, 
		//"validate_video": 0, 
		//"validate_email": 0, 
		//"cert_type": 1, 
		//"telephone": "", 
		//"sex": 2, "validate_mobile": 0, "bank_money": 3430498002, 
		//"avatar_no": 7, "birthday": null, "agent_user_id": 0, "gift_check": [true, null], "locked": 0, 
		//"password": "pbkdf2_sha256$10000$0P4zI7RL9sme$Fzgfk9h+xGnk/IBK4lw1/WtlR7KI0IqfFpp50uXC+LQ=", 
		//"nickname": "bj1234567", "award_value": 0, "qq": null, "pay_money": 0, "cert_no": "", "validate_qq": 0, 
		//"validate_cert": 0, "level": 4, "online_time": 2707984, "dollar_money": 0, "userid": 866627728, 
		//"win_dollar_sum": 0, "bag_money": 143721, "happycard": 98939, "exp_value": 10335, "validate_realname": 0, 
		//"vip_level": 0, "chick_task": 0, "email": "", "promo_dollar": 0}, 
		//"tag": "get_account", "type": "AccountService", "result": "ok"}
		//new add 'wechat_id':wechat_id,'wechat_lock':0   . 1 means bind wechat
//		if(string.Equals(uid, dict["id"])) {
		bool hasUid = false;
		if (PlatformGameDefine.playform.IsSocketLobby){
			hasUid = string.Equals(uid, dict["userid"]);
		}else{
			hasUid = string.Equals(uid, dict["id"]);
		}
		if(hasUid) {
			level = int.Parse(dict["level"]);
			vipLevel = int.Parse(dict["vip_level"]);
			if (PlatformGameDefine.playform.IsSocketLobby){
				levelExp = int.Parse(dict["exp_value"]);
			}else{
				levelExp = int.Parse(dict["exp"]);
			}
			if(dict.ContainsKey("next_exp")){
				nextLevelExp = int.Parse(dict["next_exp"]);
			}else{
				nextLevelExp = levelExp + 100;
			}
			avatarNo = int.Parse(dict["avatar_no"]);
			if(dict.ContainsKey("avatar_img")){
				avatarUrl = dict["avatar_img"];
			}
			sex = (avatarNo%2 == 0);
			
			bagMoney = dict["bag_money"].ToString();
			bankMoney = dict["bank_money"].ToString();
			goldIngot = dict["dollar_money"].ToString();
			if(dict.ContainsKey("gold_money")){
				goldCoin = dict["gold_money"].ToString();
			}
			happyCard = dict["happycard"].ToString();
            
			//判断优先级顺序是：手机令牌，手机验证，微信验证
			if(dict.ContainsKey("bank_validate")){
				if(dict["bank_validate"] == "2"){//bank_validate=2为手机令牌
					bankLoginType = eBankLoginType.PHONE_AUTH;
				}else if(dict["bank_validate"] == "1"){//bank_validate=1为手机验证
					bankLoginType = eBankLoginType.PHONE_CODE;
				}else{
					if(dict.ContainsKey("wechat_lock")){
						//Debug.LogError("Wechat--->"+ dict["wechat_lock"] +" == "+isBindWechat);
//						isBindWechat = (dict["wechat_lock"] == "1");
						if(dict["wechat_lock"] == "1"){//wechat_lock=1 wechat_id不为空则为微信验证。
							bankLoginType = eBankLoginType.WECHAT;
						}else{
							bankLoginType = eBankLoginType.PASSWORD;
						}
					}else{
//						isBindWechat = false;
						bankLoginType = eBankLoginType.PASSWORD;
					}
				}
			}

			if (dict.ContainsKey("gfname"))
            {
                PlayerPrefs.SetString(_GFname, dict["gfname"]);
            }
            if (dict.ContainsKey("wfname"))
            {
                PlayerPrefs.SetString(_WFname, dict["wfname"]);
            }

            if (dict.ContainsKey("gfname1"))
            {
                PlayerPrefs.SetString(_GFname1, dict["gfname1"]);
            }
            if (dict.ContainsKey("wfname1"))
            {
                PlayerPrefs.SetString(_WFname1, dict["wfname1"]);
            }
            PlayerPrefs.Save();

        }
	}
	
	public void Logout () {
		EginUserUpdate.Instance.UpdateInfoStop();
		isGuest = false;
		uid = "";
		username = "";
		password = "";
		session = "";
		HallBank.clearCachePwd();
	}
    /// <summary>
    /// lua 赋值回 c#
    /// </summary>
    /// <param name="key"></param>
    /// <returns></returns>

    public void InitUserWithDict_JsonStr(string jsonStr, string sessionArg) {
        JSONObject json = new JSONObject(jsonStr);
        //Debug.Log("json  === " + json.ToString());
        InitUserWithDict(json.ToDictionary(), sessionArg);
    }
    public void UpdateUserWithDict_JsonStr(string jsonStr) {
        JSONObject json = new JSONObject(jsonStr);
        //Debug.Log("json  === " + json.ToString());

        UpdateUserWithDict(json.ToDictionary());
    }
    public void UpdateAvatarNo_JsonStr(string tempNo)
    {
        int tNum = int.Parse(tempNo);
        UpdateAvatarNo(tNum);
    }
	

    public static string ObtainFullKey(string key)
    {
        return EginUser.Instance.username + key + PlatformGameDefine.playform.PlatformName;
    }

    public static string ObtainPlatformKey(string key)
    {
        return key + PlatformGameDefine.playform.PlatformName;
    }
}

/// <summary>
/// Egin user update.
/// </summary>
public class EginUserUpdate : MonoBehaviour {	
	private static EginUserUpdate _instance;
	public static EginUserUpdate Instance {
		get {
			if(!_instance) {
				_instance = GameObject.FindObjectOfType(typeof(EginUserUpdate)) as EginUserUpdate;
				if(!_instance) {
					GameObject container = new GameObject("EginUserUpdateContainer");
					_instance = (EginUserUpdate)container.AddComponent(typeof(EginUserUpdate));
					DontDestroyOnLoad(_instance);
				}
			}
			return _instance;
		}
	}

	private readonly float updateInterval = 420f;	// 7 mins
	private readonly float updateLoopInterval = 10f;
	private bool updateLoop = false;
	public bool  updateLoopHasStart{get{return updateLoop;}}
	private float lastUpdateInterval;
	
	public void UpdateInfoStart () {
//		if (!updateLoop) {
//			updateLoop = true;
//			lastUpdateInterval = 0;
//			StartCoroutine(UpdateInfoLoop());
//		}

		if(!IsInvoking("invokeUpdateInfo")){
			updateLoop = true;
			InvokeRepeating("invokeUpdateInfo",0.1f,420.0f);
		}
	}

	private void invokeUpdateInfo()
	{
		if (PlatformGameDefine.playform.IsSocketLobby){
			//{"type":"AccountService","tag":"get_account","body":null}
			JSONObject messageObj = new JSONObject();
			messageObj.AddField("type", "AccountService");
			messageObj.AddField("tag", "get_account");
			messageObj.AddField("body", "");
			if(Constants.isEditor) Debug.Log("<color=#00cc00>"+messageObj.ToString()+"</color>");
			BaseSceneLua.SocketSendMessage(messageObj);
		}else{
			StartCoroutine(UpdateInfo());
		}
	}
	
	public void UpdateInfoStop() {
		updateLoop = false;
		lastUpdateInterval = 0;
		CancelInvoke("invokeUpdateInfo");
	}
	
//	private IEnumerator UpdateInfoLoop() {
//		while (updateLoop) {
//			if (lastUpdateInterval < updateInterval) {
//				lastUpdateInterval += updateLoopInterval;
//				yield return new WaitForSeconds(updateLoopInterval);
//			}else {
//				UpdateInfoNow();
//			}
//		}
//	}

	public void UpdateInfoNow() {
		lastUpdateInterval = 0;
		invokeUpdateInfo();
//		StartCoroutine(UpdateInfo());
	}
	
	public IEnumerator UpdateInfo() {
//		yield return new WaitForSeconds(1.0f);
		lastUpdateInterval = 0;
		WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.UPDATE_USERINFO_URL, null);
		yield return www;
		HttpConnect.Instance.UpdateUserinfoResult(www);
	}
}
