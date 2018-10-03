using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChatPanel : EmotionPanel {

	void Start(){
//		initDataWithSex(true);
		init();
	}
	public UILabel sendTxt;
	private GameObject curSelObj;
	protected override void initData ()
	{

	}

	public void initDataWithSex(bool isFemale)
	{
		int plusValue = 0;
		if(isFemale){
			plusValue = 12;
		}
		for(int i=0; i< 12; i++){
			int tempIndex = i+ plusValue;
			string talkInfo = XMLResource.Instance.Str("msg_ddz_" + i );
			if(i == 7){
				if(isFemale){
					talkInfo = talkInfo.Replace("#","姐");
				}else{
					talkInfo = talkInfo.Replace("#","哥");
				}
			}
			gridTr.GetChild(i).GetComponent<UILabel>().text = talkInfo;
			gridTr.GetChild(i).name = tempIndex.ToString();
		}
	}

	public override void tapIconHanlde (GameObject btnObj)
	{
		curSelObj = btnObj;
		string selTxt = btnObj.GetComponent<UILabel>().text;
		sendTxt.text = selTxt;
	}

	public void sendChatInfo()
	{
		sendTxt.text = "";
		gameObject.transform.localScale = Vector3.zero;
		if(Time.time - preSendTime> 10.0f){
			if(curSelObj != null){
				if(sendEmotID != null){
					preSendTime = Time.time;
					sendEmotID(int.Parse( curSelObj.name ));
				}
			}
		}else{
			if(forbiddenTipObj != null){
				forbiddenTipObj.SetActive(true);
				Invoke("hideForbiddenObj",2.0f);
			}
		}

	}
}
