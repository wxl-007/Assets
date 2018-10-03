using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class BankSocket : Game {

	public UILabel kBagMoney;
	public UIInput kSaveMoney;
	public UILabel kSaveBankMoney;

	public UIToggle kGetToggle;
	public UILabel kBankMoney;
	public UIInput kGetMoney;
	public GameObject vBankPassword;
	public UIInput kBankPassword;
	public GameObject vPhoneCode;
	public UIInput kPhoneCode;

	public UIToggle kRecordToggle;
	public Transform vRecords;
	public GameObject recordPrefab;
	public UILabel kRecordPage;
	protected int recordPage = 1;
	protected int maxRecordPage = 1;
	protected readonly int recordPageSize = 5;
	protected bool isLogin = false;
	protected static string bankPwd = "";

	

	#region 礼物相关参数
	//--> not use
//	public GameObject vBankPassword_G;
//	public UIInput kBankPassword_G;
//	public GameObject vPhoneCode_G;
//	public UIInput kPhoneCode_G;
	//<---

	public UIInput kGiftID;
	public UIInput kGiftMoney;

	public GameObject vConfirm;
	public UILabel kConfirmID;
	public UILabel kConfirmNickname;
	public UILabel kConfirmMoney;
	public UILabel kConfirmMoneyZh;

	public GameObject vSucess;
	public UILabel kSucessMoney;
	public UILabel kSucessID;
	public UILabel timeStampLb;
	public UILabel nickNameLb;
	public string nickName;
	#endregion

	public UIInput oldPsd;
	public UIInput newPsd;
	public UIInput confirmPsd;
	public UIInput loginInput;
	public GameObject loginPanel;

	public GameObject sendGiftToggleBtn;
	public GameObject changePwdToggleBtn;

	protected long tempBankMoney = 1;
	protected long tempBagMoney  = 1;

	public void Awake()
	{
		if (PlatformGameDefine.playform.IsSocketLobby){
			SettingInfo.Instance.autoNext = false;
			SettingInfo.Instance.deposit = false;
			UIRoot sceneRoot = transform.root.GetComponent<UIRoot>();
			if (sceneRoot != null)
			{
				int manualHeight = 800;		// Android

				//            sceneRoot.scalingStyle = UIRoot.Scaling.FixedSize;
				//            sceneRoot.manualHeight = manualHeight;
			}
		}else{
			loginPanel.SetActive(false);
			EginProgressHUD.Instance.HideHUD();
			sendGiftToggleBtn.SetActive(false);
			changePwdToggleBtn.SetActive(false);

		}
		#if UNITY_IOS
		if(!PlatformGameDefine.playform.IOSPayFlag){
			sendGiftToggleBtn.GetComponent<BoxCollider>().enabled = false;
			sendGiftToggleBtn.transform.FindChild("UILabel").GetComponent<UILabel>().alpha = 0;
			changePwdToggleBtn.transform.localPosition = new Vector3(1058, 0,0);
			changePwdToggleBtn.transform.FindChild("UISprite - Checked").GetComponent<UISprite>().spriteName = "segmented_p_middle";
		}
		#endif
		if(EginUser.Instance.bankLoginType != EginUser.eBankLoginType.PASSWORD){
			loginPanel.transform.Find("defaultPwd").gameObject.SetActive(false);
			loginInput.inputType = UIInput.InputType.Standard;
			if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT){
//				如果是绑定微信的账号:
				loginPanel.transform.Find("Label").GetComponent<UILabel>().text = "微信认证码:";
				if(PlayerPrefs.HasKey("bankSessionTerm")){
					long termTicks = long.Parse( PlayerPrefs.GetString("bankSessionTerm") );
					if(System.DateTime.Now.Ticks< termTicks){
						loginPanel.SetActive(false);
						isLogin = true;
					}
				}
			}else if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_AUTH){
				loginPanel.transform.Find("Label").GetComponent<UILabel>().text = "手机令牌:";
			}else if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PHONE_CODE){
				loginPanel.transform.Find("Label").GetComponent<UILabel>().text = "手机验证码:";
			}
		}
	}
	// Use this for initialization
	void Start () {
		EginProgressHUD.Instance.HideHUD();
		tempBankMoney = long.Parse( EginUser.Instance.bankMoney);
		tempBagMoney  = long.Parse( EginUser.Instance.bagMoney );
		UpdateUserinfo();
		base.StartGameSocket();
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("ScreenLoading"));

		if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PASSWORD){
			if(bankPwd.Length > 0){
				loginPanel.SetActive(false);
				Invoke("loginBank",1.0f);
			}
		}

//		Invoke("test1", 5.0f);
//		Invoke("test2", 10.0f);
	}
	
	protected void OnEnable()
	{
	}

	protected void OnDisable()
	{
	}

	public override void OnClickBack () {
		SocketConnectInfo.Instance.roomFixseat = true;	// For auto add desk.
		SocketManager.Instance.socketListener = null;
		SocketManager.Instance.Disconnect("Exit from the game.");
//		EginUserUpdate.Instance.UpdateInfoNow();	// Update userinfo.
		//Application.LoadLevel("Module_Rooms");
		Utils.LoadLevelGUI("Hall");
	}

	public override void SocketDisconnect (string disconnectInfo) {
		SocketManager.Instance.socketListener = null;
		Debug.LogError("Bank SocketDisconnect");
	}

	public override void SocketReceiveMessage(string message)
	{
		base.SocketReceiveMessage(message);
		socketReceiveHandle(message);
	}

	protected virtual void socketReceiveHandle(string message)
	{
		Debug.Log(Time.time +"-><color=#00ff00>"+message+"</color>");
		JSONObject messageObj = new JSONObject(message);
		string type = messageObj["type"].str;
		string tag = messageObj["tag"].str;
		if(type == "account"){
			if(tag == "storemoney_fail"){
				//save money fail
				EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
			}else if(tag == "storemoney"){
				//save money completed
				saveLoadMoneySuccess((long)-messageObj["body"].n);
			}else if(tag == "loadmoney_fail"){
				EginProgressHUD.Instance.HideHUD();
				//取钱失败 body = 0表示系统错误, -1钱不够 -2未登录
				string errorStr = "";
				if(messageObj["body"].n == 0){
					errorStr = "系统错误。";
				}else if(messageObj["body"].n == -1){
					errorStr = "钱不足。";
				}else if(messageObj["body"].n == -2){
					errorStr = "请先登录。";
				}else{
					errorStr = "系统错误";
				}
				EginProgressHUD.Instance.ShowPromptHUD(errorStr);
			}else if(tag == "loadmoney"){
				//取钱成功
				saveLoadMoneySuccess((long)messageObj["body"].n);
			}else if(tag == "bankrecord_fail"){
				EginProgressHUD.Instance.HideHUD();
				EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
			}else if(tag == "bankrecord"){
				EginProgressHUD.Instance.HideHUD();
				UpdateBankRecord(messageObj["body"]);
			}
			else if(tag == "delivermoney_fail"){
				//=> 游戏内转账失败
				//{'type':'account', 'tag':'delivermoney_fail'. 'body':各种失败原因}
				EginProgressHUD.Instance.HideHUD();
				EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
			}
			else if(tag == "delivermoney"){
				//=> 游戏内转账成功
				//{'type':'account', 'tag':'delivermoney', 'body':[to_uid,钱数,时间]}
				GiftSucess(messageObj["body"].list[2].str);
				saveLoadMoneySuccess((long)messageObj["body"].list[1].n);
			}
		}else if(type == "money"){
			if(tag == "loginbank"){
				EginProgressHUD.Instance.HideHUD();
				if(messageObj["body"].str == "success"){
					isLogin = true;
					if(loginInput.value.Length>0){
						bankPwd = loginInput.value;
					}
					loginPanel.SetActive(false);
					if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT){
						PlayerPrefs.SetString("bankSessionTerm", System.DateTime.Now.AddMinutes(24.5).Ticks+"");
						PlayerPrefs.Save();
					}
				}else{
					EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
				}
			}else if(tag == "come"){
				EginProgressHUD.Instance.HideHUD();
			}
			else if(tag == "nickname_by_uid"){
				//{'type':'money', 'tag':'nickname_by_uid', 'body':info}  info是昵称
				//如果出错info可能是：访问超时或者用户ID不存在，用户id必须是数字，否则参数错误
				EginProgressHUD.Instance.HideHUD();
				if( messageObj["body"].str == "用户ID不存在" || messageObj["body"].str == "访问超时"|| messageObj["body"].str == "用户id必须是数字"
					|| messageObj["body"].str =="参数错误"){
					nickName = "";
					//					EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
				}else{
					nickName = Regex.Unescape(messageObj["body"].str);
				}
				nickNameLb.text = nickName;
			}else if(tag == "change_bank_password"){
				if(messageObj["result"].str == "ok"){
					oldPsd.value = "";
					newPsd.value = "";
					confirmPsd.value = "";
					EginProgressHUD.Instance.ShowPromptHUD("修改密码成功!");
				}else{
					EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
				}
			}

		}
	}

	public void saveLoadMoneySuccess(long offsetvalue=0)
	{
		EginProgressHUD.Instance.HideHUD();
		EginProgressHUD.Instance.ShowPromptHUD(ZPLocalization.Instance.Get("HttpConnectSucess"));
		tempBankMoney -= offsetvalue;
		tempBagMoney  += offsetvalue;
		kBagMoney.text = tempBagMoney + "";
		kSaveBankMoney.text = tempBankMoney +"";
		kBankMoney.text = tempBankMoney +"";

		kSaveMoney.value = "";
		kGetMoney.value = "";

//		yield return StartCoroutine(EginUserUpdate.Instance.UpdateInfo());
//		yield return new WaitForSeconds(1.0f);
//		UpdateUserinfo();
	}

	//Save to bank
	public void OnClickSave()
	{
		string errorInfo = "";
		if (kSaveMoney.value.Length == 0) {
			errorInfo = ZPLocalization.Instance.Get("BankAmount");
		}else if (long.Parse(kSaveMoney.value) > long.Parse(kBagMoney.text)) {
			errorInfo = ZPLocalization.Instance.Get("BankErrorAmount");
		}

		if (errorInfo.Length > 0) {
			EginProgressHUD.Instance.ShowPromptHUD(errorInfo);
		}else {
			if (PlatformGameDefine.playform.IsSocketLobby){
				sendSaveToBank();
			}else{
				StartCoroutine(DoClickSave());
			}
		} 
	}

	protected virtual void sendSaveToBank()
	{
		//{type:account, tag:storemoney, body:钱数}
		JSONObject sendJson = new JSONObject();
		sendJson.AddField("type", "account");
		sendJson.AddField("tag", "storemoney");
		sendJson.AddField("body", kSaveMoney.value);
		base.SendPackageWithJson(sendJson);
	}

	protected void OnClickGet () {
		string errorInfo = "";
		if (kGetMoney.value.Length == 0) {
			errorInfo = ZPLocalization.Instance.Get("BankAmount");
		} else if (long.Parse(kGetMoney.value) > long.Parse(kBankMoney.text)) {
			errorInfo = ZPLocalization.Instance.Get("BankErrorAmount");
		} else if (!isLogin && kBankPassword.value.Length == 0 && kPhoneCode.value.Length == 0) {
			if(EginUser.Instance.bankLoginType != EginUser.eBankLoginType.WECHAT){
				errorInfo = ZPLocalization.Instance.Get("BankPassword");
			}
		}

		if (errorInfo.Length > 0) {
			EginProgressHUD.Instance.ShowPromptHUD(errorInfo);
		}else {
			if (PlatformGameDefine.playform.IsSocketLobby){
				sendGetFromBank();
			}else{
				StartCoroutine(DoClickGet());
			}
		}
	}

	protected virtual void sendGetFromBank()
	{
		//<- 游戏中从银行中取钱(阻塞操作, 需要2秒的进度条)
		//{type:account, tag:loadmoney, body:钱数}
		JSONObject sendJson = new JSONObject();
		sendJson.AddField("type", "account");
		sendJson.AddField("tag", "loadmoney");
		sendJson.AddField("body", long.Parse(kGetMoney.value));
		base.SendPackageWithJson(sendJson);
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("ScreenLoading"));
	}

	#region 礼物相关处理函数
	void OnClickGift () {
		string errorInfo = "";
		if (kGiftID.value.Length == 0) {
			errorInfo = ZPLocalization.Instance.Get("GiftID");
		} else if (kGiftMoney.value.Length == 0) {
			errorInfo = ZPLocalization.Instance.Get("GiftMoney");
		} else if (!isLogin && kBankPassword.value.Length == 0 && kPhoneCode.value.Length == 0) {
			errorInfo = ZPLocalization.Instance.Get("GiftPassword");
		}

		if (errorInfo.Length > 0) {
			EginProgressHUD.Instance.ShowPromptHUD(errorInfo);
		}else {
//			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
			if(nickName.Length == 0){
				EginProgressHUD.Instance.ShowPromptHUD("用户ID不存在");
			}else{
				string moneyStr = kGiftMoney.value;
				string moneyZhStr = EginTools.numToCnNum(moneyStr);
//				if (moneyStr.Length > 8) {
//					moneyZhStr = moneyStr.Substring(0, moneyStr.Length - 8);
//					moneyZhStr += ZPLocalization.Instance.Get("GiftNumberZH_1");
//					moneyZhStr += moneyStr.Substring(moneyStr.Length - 8, 4);
//					moneyZhStr += ZPLocalization.Instance.Get("GiftNumberZH_0");
//					moneyZhStr += moneyStr.Substring(moneyStr.Length - 4, 4);
//				}else if (moneyStr.Length > 4) {
//					moneyZhStr = moneyStr.Substring(0, moneyStr.Length - 4);
//					moneyZhStr += ZPLocalization.Instance.Get("GiftNumberZH_0");
//					moneyZhStr += moneyStr.Substring(moneyStr.Length - 4, 4);
//				}else {
//					moneyZhStr = moneyStr;
//				}
				kConfirmID.text = kGiftID.value;
				kConfirmMoney.text = kGiftMoney.value;
				kConfirmMoneyZh.text = moneyZhStr;
				kConfirmNickname.text = nickName;
				vConfirm.SetActive(true);
			}
		}
	}

	public virtual void OnClickGiftConfirm () {
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));

		//<-游戏内转账
		//{type:account, tag:delivermoney, body:[to_uid,钱数]}
		JSONObject sendJson = new JSONObject();
		sendJson.AddField("type", "account");
		sendJson.AddField("tag", "delivermoney");
		sendJson.AddField("body", new JSONObject("["+kGiftID.value+","+kGiftMoney.value+"]"));
		base.SendPackageWithJson(sendJson);
	}

	protected void GiftSucess (string timeStamp) {
		EginProgressHUD.Instance.HideHUD();
		string tempMoney = kGiftMoney.value;
		if (tempMoney.Length > 8) {
			tempMoney = tempMoney.Substring(0, tempMoney.Length - 8) + "," 
				+ tempMoney.Substring(tempMoney.Length - 8, 4) + ","
				+ tempMoney.Substring(tempMoney.Length - 4, 4);
		}else if (tempMoney.Length > 4) {
			tempMoney = tempMoney.Substring(0, tempMoney.Length - 4) + "," 
				+ tempMoney.Substring(tempMoney.Length - 4, 4);
		}

		kSucessID.text = nickName;
		kSucessMoney.text = tempMoney;
		timeStampLb.text = timeStamp;
		vSucess.SetActive(true);

		kGiftID.value = "";
		kGiftMoney.value = "";
		nickName = "";
		nickNameLb.text = nickName;
		vConfirm.SetActive(false);
	}

	public virtual void OnInputIDChange()
	{
		if( kGiftID.value.Length > 4){
			//<-根据用户id获得昵称，向服务器发送
			//{'type':'money', 'tag':'nickname_by_uid', 'body':用户id}
			JSONObject sendJson = new JSONObject();
			sendJson.AddField("type", "money");
			sendJson.AddField("tag", "nickname_by_uid");
			sendJson.AddField("body", kGiftID.value);
			base.SendPackageWithJson(sendJson);
		}
	}

	private string prekSaveMoneyStr="";
	public void OnInputSaveMoneyChange()
	{
		//kSaveMoney.value
		if(!Regex.IsMatch(kSaveMoney.value, @"^[0-9]*$")){
			kSaveMoney.value = prekSaveMoneyStr;
		}else{
			prekSaveMoneyStr = kSaveMoney.value;
		}
	}
	private string preGetMoneyStr = "";
	public void OnInputGetMoneyChange()
	{
		//kSaveMoney.value
		if(!Regex.IsMatch(kGetMoney.value, @"^[0-9]*$")){
			kGetMoney.value = preGetMoneyStr;
		}else{
			preGetMoneyStr = kGetMoney.value;
		}
	}
	private string preGiftMoneyStr = "";
	public void OnInputGiftMoneyChange()
	{
		//kSaveMoney.value
		if(!Regex.IsMatch(kGiftMoney.value, @"^[0-9]*$")){
			kGiftMoney.value = preGiftMoneyStr;
		}else{
			preGiftMoneyStr = kGiftMoney.value;
		}
	}

	void OnClickGiftCancel () {
		vConfirm.SetActive(false);
	}
	void OnClickGiftSucessHide () {
		vSucess.SetActive(false);
	}
	#endregion


	protected virtual void loginBank(string pwd="")
	{
		//{'type':'money', 'tag':'loginbank', 'body':{'password':密码或者验证码,'pwdcard_r1':密保卡1,'pwdcard_r2':密保卡2}}
		JSONObject messageBody = new JSONObject();
		if(pwd.Length > 0){
			messageBody.AddField("password", pwd);
		}else{
			messageBody.AddField("password", loginInput.value);
		}
		messageBody.AddField("pwdcard_r1", "");
		messageBody.AddField("pwdcard_r2", "");
		JSONObject messageObj = new JSONObject();
		messageObj.AddField("type", "money");
		messageObj.AddField("tag", "loginbank");
		messageObj.AddField("body", messageBody);
		base.SendPackageWithJson(messageObj);
	}

	public void OnShowGetView () {
		if (UIToggle.GetActiveToggle(kGetToggle.group) == kGetToggle) {
			if (PlatformGameDefine.playform.IsSocketLobby){
				if(!isLogin){
					loginPanel.SetActive(true);
				}
			}else{
				StartCoroutine(DoCheckValidateType());
			}
		}
	}

	public void OnShowRecordView () {
		if (UIToggle.GetActiveToggle(kRecordToggle.group) == kRecordToggle) {
			recordPage = 1;
			if (PlatformGameDefine.playform.IsSocketLobby){
				OnLoadRecord(recordPage);
			}else{
				StartCoroutine(OnLoadRecordHttp(recordPage));
			}
		}
	}
	protected virtual void OnLoadRecord (int page) {
		if (page > 0 && page <= maxRecordPage) { 
			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
			//<-银行记录
			//{'type':'account', 'tag':'bankrecord',
			//	'body':{'pageindex':第几页, 'pagesize':每页几条, 'start_date':起始日期, 'end_date':结束日期}
			//}
			JSONObject messageBody = new JSONObject();
			messageBody.AddField("pageindex", page);
			messageBody.AddField("pagesize", recordPageSize);
			string nowDate = System.DateTime.Now.ToString("yyyy-MM-dd");
			string pastDate = System.DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd");
			messageBody.AddField("start_date", pastDate);
			messageBody.AddField("end_date", nowDate);
			JSONObject messageObj = new JSONObject();
			messageObj.AddField("type", "account");
			messageObj.AddField("tag", "bankrecord");
			messageObj.AddField("body", messageBody);
			base.SendPackageWithJson(messageObj);
		}
	}

	protected void UpdateBankRecord (JSONObject obj) {
		/*
		 * {"page":{"total":总记录数,"pagecount":总页数,"pageindex":第几页,"pagesize":每页条数}
		,"data":[{"action_time":操作时间,"action_type":交易类别,"action_money":交易额
		,"start_money":起始钱数,"end_money":结束钱数,"remark":备注
		,"user_id":通常是自己的id,"to_user_id":对方id,"to_user_nickname":对方昵称},...]}
		 */
		//{"body": {"data": [
		//{"action_time": "2016-04-10 20:06:29", "start_money": 801105, "action_money": 1000, "user_id": 889198535, "to_user_nickname": "", "remark": "游戏内存款", "end_money": 802105, "action_type": "存款", "to_user_id": ""}, 
		//{"action_time": "2016-04-10 19:46:39", "start_money": 800105, "action_money": 1000, "user_id": 889198535, "to_user_nickname": "", "remark": "游戏内存款", "end_money": 801105, "action_type": "存款", "to_user_id": ""}, 
		//{"action_time": "2016-04-10 19:46:34", "start_money": 800104, "action_money": 1, "user_id": 889198535, "to_user_nickname": "", "remark": "游戏内存款", "end_money": 800105, "action_type": "存款", "to_user_id": ""}, 
		//{"action_time": "2016-04-10 19:45:45", "start_money": 799993, "action_money": 111, "user_id": 889198535, "to_user_nickname": "", "remark": "游戏内存款", "end_money": 800104, "action_type": "存款", "to_user_id": ""}, 
		//{"action_time": "2016-04-10 17:15:03", "start_money": 799992, "action_money": 1, "user_id": 889198535, "to_user_nickname": "", "remark": "游戏内存款", "end_money": 799993, "action_type": "存款", "to_user_id": ""}
		//], "page": {"pageindex": 1, "total": 45, "pagesize": 5, "pagecount": 9}}, "tag": "bankrecord", "type": "account"}
		recordPage = (int)obj["page"]["pageindex"].n;
		maxRecordPage = (int)obj["page"]["pagecount"].n;
		kRecordPage.text = recordPage + "/" + maxRecordPage;

		EginTools.ClearChildren(vRecords);
		List<JSONObject> recordInfoList = obj["data"].list;
		int i = 0;
		foreach (JSONObject recordInfo in recordInfoList) {
			if (recordInfo.type == JSONObject.Type.NULL) { break; }

			GameObject cell = (GameObject)Instantiate(recordPrefab);
			cell.transform.parent = vRecords;
			cell.transform.localPosition = new Vector3(0, i*-100, 0);
			cell.transform.localScale = Vector3.one;

			string actionTime = recordInfo["action_time"].str;
			if (actionTime.Length > 10) { actionTime = actionTime.Substring(0, 10); }
			((UILabel)cell.transform.Find("Label_Time").GetComponent(typeof(UILabel))).text = actionTime;
			if (PlatformGameDefine.playform.IsSocketLobby){
				((UILabel)cell.transform.Find("Label_Type").GetComponent(typeof(UILabel))).text = Regex.Unescape( recordInfo["action_type"].str );
				((UILabel)cell.transform.Find("Label_Money").GetComponent(typeof(UILabel))).text = recordInfo["action_money"].n +"";
				((UILabel)cell.transform.Find("Label_Start").GetComponent(typeof(UILabel))).text = recordInfo["start_money"].n + "";
				((UILabel)cell.transform.Find("Label_End").GetComponent(typeof(UILabel))).text = recordInfo["end_money"].n + "";
			}else{
				((UILabel)cell.transform.Find("Label_Type").GetComponent(typeof(UILabel))).text = recordInfo["action_type"].str;
				((UILabel)cell.transform.Find("Label_Money").GetComponent(typeof(UILabel))).text = recordInfo["action_money"].str;
				((UILabel)cell.transform.Find("Label_Start").GetComponent(typeof(UILabel))).text = recordInfo["start_money"].str;
				((UILabel)cell.transform.Find("Label_End").GetComponent(typeof(UILabel))).text = recordInfo["end_money"].str;
			}
			i++;
		}
	}

	protected void OnClickLastRecord () {
		int page = recordPage - 1;
		if (PlatformGameDefine.playform.IsSocketLobby){
			OnLoadRecord(page);
		}else{
			StartCoroutine(OnLoadRecordHttp(page));
		}
	}
	protected void OnClickNextRecord () {
		int page = recordPage + 1;
		if (PlatformGameDefine.playform.IsSocketLobby){
			OnLoadRecord(page);
		}else{
			StartCoroutine(OnLoadRecordHttp(page));
		}
	}

	protected void UpdateUserinfo () {
		EginUser user = EginUser.Instance;
		kBagMoney.text = user.bagMoney;
		kSaveBankMoney.text = user.bankMoney;
		kBankMoney.text = user.bankMoney;

		kSaveMoney.value = "";
		kGetMoney.value = "";
	}

	public void OnLogin()
	{
		loginBank();
	}

	public void OnChangePassword(){
		if( newPsd.value != confirmPsd.value){
			EginProgressHUD.Instance.ShowPromptHUD( "新密码和确认密码不一致" );
		}else if( oldPsd.value.Length == 0 ){
			EginProgressHUD.Instance.ShowPromptHUD( "请输入旧密码" );
		}else if( newPsd.value.Length == 0 ){
			EginProgressHUD.Instance.ShowPromptHUD( "请输入新密码" );
		}else{
			sendChangePwd();
		}
	}

	protected virtual void sendChangePwd()
	{
		/*
		 * {
		 "type":"money",  
		 "tag":"change_bank_password",
		 "body":
		 { "old_pwd":$password, --旧密码
		  "password":$password, --新密码
		  'validate_type':$validate_type, --0,密码验证。1，密保验证。2，E-mail验证。3，手机验证
		  'answer':$answer, --密保答案
		  'emailcode':$emailcode, --E-mail验证码
		  'phonecode':$phonecode, --手机验证码
		}
		*/
		JSONObject messageBody = new JSONObject();
		messageBody.AddField("old_pwd", oldPsd.value);
		messageBody.AddField("password", newPsd.value);
		messageBody.AddField("validate_type", 0);
		messageBody.AddField("answer", "");
		messageBody.AddField("emailcode", "");
		messageBody.AddField("phonecode", "");
		JSONObject messageObj = new JSONObject();
		messageObj.AddField("type", "money");
		messageObj.AddField("tag", "change_bank_password");
		messageObj.AddField("body", messageBody);
		base.SendPackageWithJson(messageObj);
	}

	#region http 相关
	protected bool mCheckState = false;
	protected bool mLoginState = false;
	protected SafeValidate.ValidateType mValidateType;

	/* ------ Button Click ------ */
	public IEnumerator DoCheckValidateType () {
		if (!mCheckState) {
			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));

			WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.SAFE_VALIDATE_TYPE_URL, null);
			yield return www;

			HttpResult result = HttpConnect.Instance.BaseResult(www);		
			EginProgressHUD.Instance.HideHUD();
			if(HttpResult.ResultType.Sucess == result.resultType) {
				mCheckState = true;
				JSONObject resultObj = (JSONObject)result.resultObject;
				mValidateType = (SafeValidate.ValidateType)resultObj["bank_validate"].n;
				bool isLogin = (resultObj["is_login"].n == 1);
				UpdateLoginState(isLogin);
			}else {
				UpdateLoginState(false);
				EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
			}
		}
	}

	public IEnumerator OnClickSendPhoneCode () {
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));

		WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.SAFE_SEND_PHONECODE_URL, null);
		yield return www;

		HttpResult result = HttpConnect.Instance.BaseResult(www);	
		EginProgressHUD.Instance.HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType) {
			EginProgressHUD.Instance.ShowPromptHUD(ZPLocalization.Instance.Get("HttpConnectSucess"));
		}else {
			EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
		}
	}

	public IEnumerator OnClickValidate (string password) {
		if (!mLoginState) {
			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
			WWWForm form = new WWWForm();
			form.AddField("password", password);
			WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.SAFE_VALIDATE_LOGIN_URL, form);
			yield return www;

			HttpResult result = HttpConnect.Instance.BaseResult(www);	
			EginProgressHUD.Instance.HideHUD();
			if(HttpResult.ResultType.Sucess == result.resultType) {
				UpdateLoginState(true);
			}else {
				UpdateLoginState(false);
				EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
			}
		}
	}

	/* ------ Other ------ */
	protected void UpdateLoginState (bool loginState) {		
		mLoginState = loginState;
		if (loginState) {
			HideValidateInput();
		}else {
			ShowValidateInput(mValidateType);
		}
	}

	public bool LoginState {
		get {
			return mLoginState;
		}
	}

	public SafeValidate.ValidateType GetValidateType {
		get {
			return mValidateType;
		}
	}

	public void ShowValidateInput (SafeValidate.ValidateType validateType) {
		HideValidateInput();

		switch (validateType) {
		case SafeValidate.ValidateType.BankPassword:
			vBankPassword.SetActive(true);
			break;
		case SafeValidate.ValidateType.PhoneCode:
			vPhoneCode.SetActive(true);
			break;
		}
	}

	public void HideValidateInput () {
		vBankPassword.SetActive(false);
		vPhoneCode.SetActive(false);
	}

	public IEnumerator DoClickSave () {
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));

		WWWForm form = new WWWForm();
		form.AddField("amount", kSaveMoney.value);
		WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.BANK_SAVE_URL, form);
		yield return www;

		HttpResult result = HttpConnect.Instance.BaseResult(www);
		if(HttpResult.ResultType.Sucess == result.resultType) {
			yield return StartCoroutine(EginUserUpdate.Instance.UpdateInfo());
		}

		EginProgressHUD.Instance.HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType) {
			EginProgressHUD.Instance.ShowPromptHUD(ZPLocalization.Instance.Get("HttpConnectSucess"));
			UpdateUserinfo();
		}else {
			//			EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
			StartCoroutine(loginFailHandle());
		}
	}

	protected IEnumerator loginFailHandle()
	{
		PlatformGameDefine.playform.swithWebHostUrl();
		EginProgressHUD.Instance.ShowPromptHUD("连接失败，请重新登录。", 2.0f);
		yield return new WaitForSeconds(2.1f);
		EginUser.Instance.Logout();
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("ScreenLoading"));
		Utils.LoadLevelGUI("Login");
	}
	public IEnumerator DoClickGet () {
		string password = "";
		switch (this.GetValidateType) {
		case SafeValidate.ValidateType.BankPassword:
			password = kBankPassword.value; 
			break;
		case SafeValidate.ValidateType.PhoneCode:
			password = kPhoneCode.value; 
			break;
		}
		yield return StartCoroutine(OnClickValidate(password));

		if (this.LoginState) {	
			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));	

			WWWForm form = new WWWForm();
			form.AddField("amount", kGetMoney.value);
			WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.BANK_GET_URL, form);
			yield return www;

			HttpResult result = HttpConnect.Instance.BaseResult(www);
			if(HttpResult.ResultType.Sucess == result.resultType) {
				yield return StartCoroutine(EginUserUpdate.Instance.UpdateInfo());
			}

			EginProgressHUD.Instance.HideHUD();
			if(HttpResult.ResultType.Sucess == result.resultType) {
				EginProgressHUD.Instance.ShowPromptHUD(ZPLocalization.Instance.Get("HttpConnectSucess"));
				UpdateUserinfo();
			}else {
				//				EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
				StartCoroutine(loginFailHandle());
			}
		}
	}
	public IEnumerator OnLoadRecordHttp (int page) {
		if (page > 0 && page <= maxRecordPage) { 
			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));

			WWWForm form = new WWWForm();
			form.AddField("pageindex", page);
			form.AddField("pagesize", recordPageSize);
			WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.BANK_RECORD_URL, form);		
			yield return www;

			HttpResult result = HttpConnect.Instance.BaseResult(www);
			EginProgressHUD.Instance.HideHUD();
			if(HttpResult.ResultType.Sucess == result.resultType) {
				UpdateBankRecord((JSONObject)result.resultObject);
			}else {
				StartCoroutine(loginFailHandle());
			}
		}
	}
	#endregion

}
