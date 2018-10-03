using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Happy131Regt : MonoBehaviour {

	public GameObject rootDialog;
	public GameObject leaderboardObj;
	public GameObject rulesObj;
	public GameObject awardObj;
	public GameObject getAwardObj;

	public UILabel avgScoreLb;
	public UILabel rankLb;
	public UILabel roundCountLb;
	public UILabel bonusLb;
	public UIInput mobileIp;
	public UIInput codeIp;

	public GameDDZ mainDoc;
	public GameObject regBtn;
	public GameObject continueBtn;
	public GameObject regTitle;
	public UILabel cdTimeLb;
	public GameObject collectFlagObj;
	private int cdTime;
	private int curTime=-1;
	private string session="";
	private JSONObject awardInfo;
	private bool isInRquest = false;
//	private string serverURL  = "http://139.196.107.158/";
	private string serverURL  = "http://114.215.156.145/";// test server
	// Use this for initialization
	void Start () {
		StartCoroutine(httpLogin("rank"));
	}

	private IEnumerator httpLogin(string nextStep="", string mobile="", string code ="")
	{
		isInRquest = true;
		EginProgressHUD.Instance.ShowWaitHUD("请求服务器中...",false);
		if(session.Length == 0){
			string username = PlayerPrefs.GetString("EginUsername", "");
			string password = PlayerPrefs.GetString(username, "");
			if (username.Length > 0 && password.Length > 0) {
				WWWForm form = new WWWForm();
				form.AddField("username", username);
				form.AddField("password", password);
				form.AddField("device_id", "unity_" + SystemInfo.deviceUniqueIdentifier);
				#if UNITY_ANDROID
				int mVersionCode = Mathf.Max (PlayerPrefs.GetInt ("VersionCode", PlatformGameDefine.game.VersionCode), PlatformGameDefine.game.VersionCode);
				form.AddField("platform", "Android");
				form.AddField("version", mVersionCode);
				#else
				form.AddField("platform", "iOS");
				#endif
				WWW www = HttpConnect.Instance.HttpRequest(serverURL+"client_unity/login/", form); //UnityEngine.Debug.Log("CK : ------------------------------ ConnectDefine.LOGIN_URL = " + ConnectDefine.LOGIN_URL);
				yield return www;
				isInRquest = false;
				if(www.error == null){
					Debug.LogError(www.text);
					EginProgressHUD.Instance.HideHUD();
					if(www.responseHeaders.ContainsKey("SET-COOKIE")) {
						session = www.responseHeaders["SET-COOKIE"];
					}
					if(nextStep == "rank"){
						StartCoroutine(requestRankInfo());
					}else if(nextStep == "getcode"){
						StartCoroutine(requestPhoneCode(mobile));
					}else if(nextStep == "getaward"){
						StartCoroutine(requestAward(mobile,code));
					}
				}else{
					EginProgressHUD.Instance.HideHUD();
					EginProgressHUD.Instance.ShowPromptHUD(www.error);
					Debug.LogError(www.error);
				}
			}else{
				EginProgressHUD.Instance.HideHUD();
				yield return 0;
			}
		}else{
			EginProgressHUD.Instance.HideHUD();
			if(nextStep == "rank"){
				StartCoroutine(requestRankInfo());
			}else if(nextStep == "getcode"){
				StartCoroutine(requestPhoneCode(mobile));
			}else if(nextStep == "getaward"){
				StartCoroutine(requestAward(mobile,code));
			}
		}
	}

	private IEnumerator requestRankInfo(bool isPopup=false)
	{
		Dictionary<string, string> headers = new Dictionary<string, string>();
		headers.Add("Cookie", session);

		WWWForm form2 = new WWWForm();
		form2.AddField("Cookie", session);
		long ms2=EginTools.nowMinis() ;
		long mms2 = ms2 + EginTools.localBeiJingTime;
		string ccode2 = EginTools.encrypTime (mms2.ToString());

		form2.AddField("client_code", ccode2); 
		form2.AddField("roomid","1095");

		WWW w2 = new WWW(serverURL+"unity/htddz/user_rank_info/", form2.data, headers);
		yield return w2;
		if(w2.error == null){
			Debug.LogError(w2.text);
			JSONObject json1 = new JSONObject(w2.text);
			JSONObject json = json1["body"];
			/*{
			"result": "ok",
			"body": {
				"rank": 1, # 排名
				"uid": 1, # 玩家uid
				"name": "test", # 玩家名字
				"ave_score": 8000, # 场积分
				"update_time": "2016-12-13 14:10:00", # 获得时间
				"round": 25, # 当前第几局
				"win_round": 25, # 胜几场
				"fail_round": 0, # 负几场
				"add_coin": 0, # 获得金币
				"item_id": 121, # 获得京东卡item_id
				"is_reward": 1, # 是否领奖 0否 1是
			}*/
//			Debug.LogError( System.Text.RegularExpressions.Regex.Unescape(json["body"].str) );
			//JDCard id : 121 to 125  = rank 1 to 5
			if(json1["result"].str == "ok"){
				awardInfo = json1["body"];
				//{"result":"ok","body":{"update_time": "2016-12-21 15:00:49", "uid": 299023, "ave_score": 345, "rank": 1, 
				//"fail_round": 2, "item_id": 121, "name": "sygame13", "is_reward": 0, "win_round": 2, "add_coin": 0, "round": 4}}
				if(json["is_reward"].n == 1){
					if(json["add_coin"].n > 0){
						bonusLb.text = json["add_coin"].n +"元宝";
					}
					if(json["item_id"].n >= 121 && json["item_id"].n <= 125){
						string bonusStr = bonusLb.text;
						if(json["item_id"].n == 121){
							bonusStr += "\n 300元京东卡";
						}else if(json["item_id"].n == 122){
							bonusStr += "\n 200元京东卡";
						}else if(json["item_id"].n == 123){
							bonusStr += "\n 100元京东卡";
						}else if(json["item_id"].n == 124){
							bonusStr += "\n 50元京东卡";
						}else if(json["item_id"].n == 125){
							bonusStr += "\n 30元京东卡";
						}
						bonusLb.text = bonusStr;
						collectFlagObj.SetActive(true);
					}
					toggleAwardBtn(false);
				}else{
					if(json["rank"].n <= 50){
						toggleAwardBtn(true);
					}else{
						toggleAwardBtn(false);
					}
					if(isPopup){
						showAward();
					}
				}
			}else{
				toggleAwardBtn(false);
				Debug.LogError(System.Text.RegularExpressions.Regex.Unescape(json1["body"].str));
//				EginProgressHUD.Instance.ShowPromptHUD(System.Text.RegularExpressions.Regex.Unescape(json["body"].str));
			}
		}else{
			EginProgressHUD.Instance.ShowPromptHUD(w2.error);
		}
	}

	private IEnumerator requestPhoneCode(string mobile)
	{
		Dictionary<string, string> headers = new Dictionary<string, string>();
		headers.Add("Cookie", session);

		WWWForm form2 = new WWWForm();
		form2.AddField("Cookie", session);
		form2.AddField("type", "1");
		form2.AddField("mobile", mobile);
		long ms2=EginTools.nowMinis() ;
		long mms2 = ms2 + EginTools.localBeiJingTime;
		string ccode2 = EginTools.encrypTime (mms2.ToString());

		form2.AddField("client_code", ccode2);

		WWW w2 = new WWW(serverURL+"unity/htddz/send_phone_code/", form2.data, headers);
		yield return w2;
		if(w2.error == null){
			Debug.LogError(w2.text);
			JSONObject json = new JSONObject(w2.text);
			//Debug.LogError( System.Text.RegularExpressions.Regex.Unescape(json["body"].str) );
			EginProgressHUD.Instance.ShowPromptHUD(System.Text.RegularExpressions.Regex.Unescape(json["body"].str));
		}else{
			EginProgressHUD.Instance.ShowPromptHUD(w2.error);
		}
	}
	private IEnumerator requestAward(string mobile, string code)
	{
		Dictionary<string, string> headers = new Dictionary<string, string>();
		headers.Add("Cookie", session);

		WWWForm form2 = new WWWForm();
		form2.AddField("Cookie", session);
		form2.AddField("type", "1");
		form2.AddField("mobile", mobile);
		form2.AddField("phonecode", code);
		long ms2=EginTools.nowMinis() ;
		long mms2 = ms2 + EginTools.localBeiJingTime;
		string ccode2 = EginTools.encrypTime (mms2.ToString());

		form2.AddField("client_code", ccode2);
		form2.AddField("roomid","1095");

		WWW w2 = new WWW(serverURL+"unity/htddz/reward_jd_card/", form2.data, headers);
		yield return w2;
		if(w2.error == null){
			Debug.LogError(w2.text);
			JSONObject json = new JSONObject(w2.text);
			if(json["result"].str == "ok"){
				if(awardInfo == null){
					EginProgressHUD.Instance.ShowPromptHUD("没有排名信息");
					yield return 0;
				}
				if(awardInfo["add_coin"].n > 0){
					bonusLb.text = awardInfo["add_coin"].n +"元宝";
				}
				string awardCard = "";
				if(awardInfo["item_id"].n >= 121 && awardInfo["item_id"].n <= 125){
					string bonusStr = bonusLb.text;

					if(awardInfo["item_id"].n == 121){
						awardCard = "300元京东卡";
					}else if(awardInfo["item_id"].n == 122){
						awardCard = "200元京东卡";
					}else if(awardInfo["item_id"].n == 123){
						awardCard = "100元京东卡";
					}else if(awardInfo["item_id"].n == 124){
						awardCard = "50元京东卡";
					}else if(awardInfo["item_id"].n == 125){
						awardCard = "30元京东卡";
					}
					bonusStr += ("\n"+ awardCard);
					bonusLb.text = bonusStr;
					collectFlagObj.SetActive(true);
				}
				if(awardInfo["rank"].n <= 20){
					EginProgressHUD.Instance.ShowPromptHUD("你获得第"+ awardInfo["rank"].n +"名,赢得"+awardCard+"！ 卡密已发送到手机,请查收");
				}
				toggleAwardBtn(false);
			}else{
				EginProgressHUD.Instance.ShowPromptHUD(System.Text.RegularExpressions.Regex.Unescape(json["body"].str));
			}
		}else{
			EginProgressHUD.Instance.ShowPromptHUD(w2.error);
		}
	}

	public void initData(int roundCount, int avgScore, int rank, List<JSONObject> rankList, int cdTime)
	{
		avgScoreLb.text = avgScore+"";
		rankLb.text = rank+"";
		roundCountLb.text = roundCount+"";
		if(rankList == null || rankList.Count == 0)return;
		initLeaderboard(rankList);
		this.cdTime = cdTime;
		curTime = cdTime;
		if(cdTime == -1){
			cdTimeLb.text = "比赛开始时间: 10:00";
		}else if(cdTime == -2){
			cdTimeLb.text = "比赛结束时间: 22:00";
			toggleAwardBtn(false);
		}else{
			cdTimeLb.text = "比赛开始倒计时: [e3371b]"+EginTools.miao2TimeStr(curTime,true, true)+"[-]";
			if(IsInvoking("cdInvoke")){
				CancelInvoke("cdInvoke");
			}
			InvokeRepeating("cdInvoke", 0.1f,1.0f);
		}
	}

	private void cdInvoke()
	{
		if(curTime <= 0){
			curTime = 0;
			CancelInvoke("cdInvoke");
		}
		cdTimeLb.text = "比赛开始倒计时: [e3371b]"+EginTools.miao2TimeStr(curTime,true, true)+"[-]";
		curTime -= 1;
	}

	private void initLeaderboard(List<JSONObject> rankList)
	{
		if(rankList[0].IsNull)return;
		Transform rankListTr = leaderboardObj.transform.Find("ScrollView/rankList");
		int count = rankListTr.childCount;
		for(int i=0; i< count; i++){
			if(i >=rankList.Count)return;
			//[600, 1, 116481, "爱你一生v", 1, 0, 0, 0]
			JSONObject rankData = rankList[i];
			Transform contentTr = rankListTr.GetChild(i);
			contentTr.GetComponent<UILabel>().text = (i+1)+"";
			contentTr.Find("nickName").GetComponent<UILabel>().text = rankData[3].str;
			contentTr.Find("times").GetComponent<UILabel>().text = rankData[1].n+"";
			contentTr.Find("winTimes").GetComponent<UILabel>().text = rankData[4].n+"";
			contentTr.Find("loseTimes").GetComponent<UILabel>().text = rankData[5].n+"";
			contentTr.Find("score").GetComponent<UILabel>().text = rankData[0].n+"";
		}
	}

	public void enterGame()
	{
		if(curTime == 0 || curTime == -2){
			JSONObject startJson = new JSONObject();
			startJson.AddField("type", "ddz");
			//Modified by xiaoyong 2016/2/16  change to "ready"
			//        startJson.AddField("tag", "start");
			startJson.AddField("tag", "ready");
			startJson.AddField("body", 1 );
			mainDoc.SendPackageWithJson(startJson);
			gameObject.SetActive(false);
		}else{
			regTitle.SetActive(true);
			if(IsInvoking("hideTips")){
				CancelInvoke("hideTips");
			}
			Invoke("hideTips",3.0f);
		}
	}

	private void hideTips()
	{
		regTitle.SetActive(false);
	}

	public void showLeaderboard()
	{
		showDialog(leaderboardObj);
	}

	public void showRules()
	{
		showDialog(rulesObj);
	}

	public void showAward()
	{
		awardObj.transform.Find("submit").gameObject.SetActive(true);
		awardObj.transform.Find("result").gameObject.SetActive(false);
		showDialog(awardObj);
		if(awardInfo != null){
			if(awardInfo["rank"].n > 20 && awardInfo["rank"].n <= 50){
				awardObj.transform.Find("submit").gameObject.SetActive(false);
				awardObj.transform.Find("result").gameObject.SetActive(true);
				awardObj.transform.Find("result/rank").GetComponent<UILabel>().text = awardInfo["rank"].n+"";
				awardObj.transform.Find("result/money").GetComponent<UILabel>().text = awardInfo["add_coin"].n+"";
			}
		}
	}

	public void showAwardInGame()
	{
		StartCoroutine(requestRankInfo(true));
	}

	private void showDialog(GameObject content)
	{
		rootDialog.SetActive(true);
		leaderboardObj.SetActive(false);
		rulesObj.SetActive(false);
		awardObj.SetActive(false);
		content.SetActive(true);
	}

	public void quitGame()
	{
		mainDoc.UserQuit();
	}

	public void getConfirmCode()
	{
		StartCoroutine( httpLogin("getcode", mobileIp.value,"") );
	}
	public void clickSubmitPhone()
	{
		StartCoroutine( httpLogin("getaward", mobileIp.value, codeIp.value) );
//		if(awardInfo != null){
//			Debug.LogError("clickSubmitPhone2");
//			StartCoroutine( httpLogin("getaward", mobileIp.value, codeIp.value) );
//		}else{
//			if(!isInRquest){
//				StartCoroutine(httpLogin("rank"));
//			}
//		}
	}

	public void hideObj(GameObject obj)
	{
		obj.SetActive(false);
	}

	private void toggleAwardBtn(bool isShow)
	{
		getAwardObj.GetComponent<BoxCollider>().enabled = isShow;
		getAwardObj.GetComponent<UIButton>().enabled = false;
		getAwardObj.GetComponent<UIButton>().enabled = true; 
	}

}
