using UnityEngine;
using System.Collections;

public class MailInfo : MonoBehaviour {
	
	public string mailId;
	public string sender;
	public string title;
	public string sendTime;
	public bool isSystemMail;
	public bool isRead;
	
	public void InitWithJson (JSONObject obj) {
		mailId = obj["id"].n + "";
		title = obj["title"].str;
//		isSystemMail = obj["mail_type"].str.Equals("0");
		isSystemMail = (obj["mail_type"].n == 0);
//		isRead = obj["read"].str.Equals("1");
		isRead = (obj["read"].n == 1);
		
		sender = isSystemMail? ZPLocalization.Instance.Get("MailSystem"):obj["nickname"].str;
		
		sendTime = obj["send_time"].str;
		if (sendTime.Length > 10) { sendTime = sendTime.Substring(0, 10); }
	}
}
