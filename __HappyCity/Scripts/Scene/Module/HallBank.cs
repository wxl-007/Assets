using UnityEngine;
using System.Collections;
using System.Text.RegularExpressions;

public class HallBank : BankSocket {

	private static string hallBankPwd = "";
	public static void clearCachePwd(){
		hallBankPwd = "";
		bankPwd = "";
	}
	// Use this for initialization
	void Start () {
		if (PlatformGameDefine.playform.IsSocketLobby){
			EginProgressHUD.Instance.HideHUD();
			tempBankMoney = long.Parse( EginUser.Instance.bankMoney);
			tempBagMoney  = long.Parse( EginUser.Instance.bagMoney );

			StartCoroutine(startSocket());
		}
		UpdateUserinfo();
	}

	private IEnumerator startSocket(){
		SocketManager socketManager = SocketManager.LobbyInstance;
		yield return socketManager;
		socketManager.socketListener = this;
		Debug.Log("startSocket");
		if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.PASSWORD){
			if(hallBankPwd.Length > 0){
				loginPanel.SetActive(false);
				loginBank(hallBankPwd);
			}
		}
	}

	public override void SocketDisconnect (string disconnectInfo) {
		SocketManager.LobbyInstance.socketListener = null;
		Debug.LogError("Bank SocketDisconnect");
	}

	protected override void socketReceiveHandle(string message)
	{
		Debug.Log(Time.time +"-><color=#00ff00>"+message+"</color>");
		JSONObject messageObj = new JSONObject(message);
		string type = messageObj["type"].str;
		string tag = messageObj["tag"].str;
		if(type == "AccountService"){
			if(tag == "bank_login"){
				EginProgressHUD.Instance.HideHUD();
				if(messageObj["result"].str == "ok"){
					if(loginInput.value.Length > 0){
						hallBankPwd = loginInput.value;
					}
					isLogin = true;
					loginPanel.SetActive(false);
					if(EginUser.Instance.bankLoginType == EginUser.eBankLoginType.WECHAT){
						PlayerPrefs.SetString("bankSessionTerm", System.DateTime.Now.AddMinutes(24.5).Ticks+"");
						PlayerPrefs.Save();
					}
				}else{
					EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
				}
			}else if(tag == "bag2bank"){
//				{"type":AccountService,"tag": bag2bank,"result":'ok',--成功：ok 失败：如果失败 相应的文字描述 "body":'ok' }
				if(messageObj["result"].str == "ok"){
					saveLoadMoneySuccess( -long.Parse(kSaveMoney.value));
				}else{
					EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
				}
			}else if(tag == "bank2bag"){
				//{"type":AccountService,"tag": bank2bag,"result":'ok',--成功：ok 失败：如果失败 相应的文字描述 "body":'ok' 	}
				if(messageObj["result"].str == "ok"){
					saveLoadMoneySuccess( long.Parse(kGetMoney.value));
				}else{
					EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
				}
			}else if(tag == "deliver_money"){
				//{"type":AccountService,"tag": deliver_money,"result":'ok',--成功：ok 失败：如果失败 相应的文字描述 "body":'ok' }
				if(messageObj["result"].str == "ok"){
					string nowDate = System.DateTime.Now.ToString("yyyy-MM-dd hh:mm");
					saveLoadMoneySuccess(long.Parse(kGiftMoney.value));
					GiftSucess(nowDate);
				}else{
					EginProgressHUD.Instance.ShowPromptHUD( Regex.Unescape(messageObj["body"].str) );
				}
			}else if(tag == "nickname_by_uid"){
				//{"type":AccountService, "tag": nickname_by_uid, "body":玩家昵称 "result":'ok' --成功ok ,失败为说明 }
				EginProgressHUD.Instance.HideHUD();
				if( messageObj["result"].str == "ok"){
					nickName =  Regex.Unescape(messageObj["body"].str);
				}else{
					nickName = "";
				}
				nickNameLb.text =nickName;
			}else if(tag == "change_bank_password"){
				EginProgressHUD.Instance.HideHUD();
				//{"type":AccountService,"tag": change_bank_password,"result":'ok',--成功：ok 失败：如果失败 相应的文字描述 "body":'ok' ,-成功：ok 失败：error  }
				if(messageObj["result"].str == "ok"){
					oldPsd.value = "";
					newPsd.value = "";
					confirmPsd.value = "";
					clearCachePwd();
					EginProgressHUD.Instance.ShowPromptHUD("修改密码成功!");
				}else{
					EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
				}
			}else if(tag == "bank_record_json"){
				EginProgressHUD.Instance.HideHUD();
				if(messageObj["result"].str == "ok"){
					UpdateBankRecord(messageObj["body"]);
				}else{
					EginProgressHUD.Instance.ShowPromptHUD(messageObj["body"].str);
				}
			}
		}
	}

	protected override void sendSaveToBank ()
	{
		/*
{"type":"AccountService",  "tag":"bag2bank","body":{'amount':1000 --存款金额}}
*/
		JSONObject sendJson = new JSONObject();
		sendJson.AddField("type", "AccountService");
		sendJson.AddField("tag", "bag2bank");
		sendJson.AddField("body", new JSONObject("{\"amount\":"+kSaveMoney.value+"}"));
//		base.SendPackageWithJson(sendJson);
		BaseScene.SocketSendMessage(sendJson);
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
	}

	protected override void sendGetFromBank ()
	{
		//"type":"AccountService",  "tag":"bank2bag","body":{'amount':1000 --取款金额}
		JSONObject sendJson = new JSONObject();
		sendJson.AddField("type", "AccountService");
		sendJson.AddField("tag", "bank2bag");
		sendJson.AddField("body", new JSONObject("{\"amount\":"+kGetMoney.value+"}"));
//		base.SendPackageWithJson(sendJson);
		BaseScene.SocketSendMessage(sendJson);
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("ScreenLoading"));
	}

	public override void OnClickGiftConfirm () {
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));

		//<-游戏内转账
		//{"type":"AccountService",  "tag":"deliver_money","body":{'uid':目标玩家的UID'money':1000 --转账金额}}
		JSONObject sendJson = new JSONObject();
		sendJson.AddField("type", "AccountService");
		sendJson.AddField("tag", "deliver_money");
		sendJson.AddField("body", new JSONObject("{\"uid\":"+kGiftID.value+",\"money\":"+kGiftMoney.value+"}"));
//		base.SendPackageWithJson(sendJson);
		BaseScene.SocketSendMessage(sendJson);
	}

	public override void OnInputIDChange()
	{
		if( kGiftID.value.Length > 4){
			//<-根据用户id获得昵称，向服务器发送
			//{'type':'AccountService', 'tag':'nickname_by_uid', 'body':{'uid':玩家UID}}
			JSONObject sendJson = new JSONObject();
			sendJson.AddField("type", "AccountService");
			sendJson.AddField("tag", "nickname_by_uid");
			sendJson.AddField("body", new JSONObject("{\"uid\":"+kGiftID.value+"}"));
//			base.SendPackageWithJson(sendJson);
			BaseScene.SocketSendMessage(sendJson);
		}
	}

	protected override void sendChangePwd ()
	{
		/*上行：
		{
			"type":"AccountService",  
			"tag":"change_bank_password",
			"body":
			{	"old_pwd":$password,	--旧密码
				"password":$password,	--新密码
				'validate_type':$validate_type,	--0,密码验证。1，密保验证。2，E-mail验证。3，手机验证
				'answer':$answer,	--密保答案
				'emailcode':$emailcode,	--E-mail验证码
				'phonecode':$phonecode,	--手机验证码
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
		messageObj.AddField("type", "AccountService");
		messageObj.AddField("tag", "change_bank_password");
		messageObj.AddField("body", messageBody);
//		base.SendPackageWithJson(messageObj);
		BaseScene.SocketSendMessage(messageObj);
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
	}

	protected override void OnLoadRecord (int page)
	{
		if (page > 0 && page <= maxRecordPage) { 
			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
			//<-银行记录
			//{'type':'AccountService', 'tag':'bank_record_json',
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
			messageObj.AddField("type", "AccountService");
			messageObj.AddField("tag", "bank_record_json");
			messageObj.AddField("body", messageBody);
//			base.SendPackageWithJson(messageObj);
			BaseScene.SocketSendMessage(messageObj);
		}
	}

	protected override void loginBank(string pwd="")
	{
		/*
		上行：
		{"type":"AccountService",  "tag":"bank_login","body":
			{	"password":$password,	--密码
				"pwdcard_r1":$pwdcard_r1,	--密保卡口令
				'pwdcard_r2':$pwdcard_r2,	--密保卡口令
			}
		}
		下行：
		{
			"type":AccountService,
			"tag": bank_login,
			"result":'ok',--成功：ok 失败：如果失败 相应的文字描述
			"body":'ok' 	
		}
		*/
		//{'type':'money', 'tag':'loginbank', 'body':{'password':密码或者验证码,'pwdcard_r1':密保卡1,'pwdcard_r2':密保卡2}}
		JSONObject messageBody = new JSONObject();
		if(pwd.Length>0){
			messageBody.AddField("password", pwd);
		}else{
			messageBody.AddField("password", loginInput.value);
		}
		messageBody.AddField("pwdcard_r1", "");
		messageBody.AddField("pwdcard_r2", "");
		JSONObject messageObj = new JSONObject();
		messageObj.AddField("type", "AccountService");
		messageObj.AddField("tag", "bank_login");
		messageObj.AddField("body", messageBody);
//		base.SendPackageWithJson(messageObj);
		BaseScene.SocketSendMessage(messageObj);
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
	}

	public override void OnClickBack () {
		Utils.LoadLevelGUI("Hall");
	}

}
