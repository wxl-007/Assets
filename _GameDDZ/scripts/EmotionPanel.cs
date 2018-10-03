using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EmotionPanel : MonoBehaviour {

	public GameObject[] otherPanel;
	public delegate void SendEmotID(int id);

	public GameObject testObj;
	public Transform gridTr;
	public GameObject[] emoAnimaPrbs;
	public SendEmotID sendEmotID;
	public GameObject forbiddenTipObj;
	private Dictionary<string, int> motionDc;
	protected float preSendTime = -11;
	void Awake()
	{
		initData();
		init();
	}
	// Use this for initialization
	void Start () {

	}

	protected virtual void initData()
	{
//		motionDc = new Dictionary<string, int>();

		for(int i=0; i< gridTr.childCount; i++){
			GameObject childObj = gridTr.GetChild(i).gameObject;
			string originName = childObj.GetComponent<UISprite>().spriteName;
			string KeyName = originName.Substring(originName.Length-2,2);
			childObj.name = (int.Parse(KeyName)-1).ToString();

//			motionDc[childObj.name] = expression.button.Cute_01;
		}
	}

	public void playEmotAt(int emotID, GameObject targetObj , float duration = 1.25f)
	{
		GameObject prb = emoAnimaPrbs[emotID];
		GameObject emotObj = NGUITools.AddChild(targetObj.transform.parent.parent.gameObject,prb);
		emotObj.transform.position = targetObj.transform.position;
		EmotionAnima emotAnima = emotObj.AddComponent<EmotionAnima>();
		emotAnima.durationTime = duration;
		emotAnima.iTweenTime = 0.5f;
	}

	public void init()
	{
		gameObject.transform.localScale = Vector3.zero;
	}

	public void show(){
		gameObject.SetActive(true);
		gameObject.transform.localScale = Vector3.one;
		for(int i=0; i< otherPanel.Length; i++){
			otherPanel[i].transform.localScale = Vector3.zero;
		}
		iTween.ScaleFrom(gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
		                                         "easetype", iTween.EaseType.easeOutBack) );
	}

	public virtual void close(){
		gameObject.transform.localScale = Vector3.zero;
	}

	public virtual void tapIconHanlde(GameObject btnObj)
	{
		Debug.Log("Send emotion ID: "+btnObj.name);
		if(Time.time - preSendTime> 10.0f){
			if(sendEmotID != null){
				preSendTime = Time.time;
				sendEmotID( int.Parse(btnObj.name));
			}
		}else{
			if(forbiddenTipObj != null){
				forbiddenTipObj.SetActive(true);
				Invoke("hideForbiddenObj",2.0f);
			}
		}
//		playEmotAt(int.Parse(btnObj.name), testObj);
		gameObject.transform.localScale = Vector3.zero;
	}

	protected void hideForbiddenObj()
	{
		forbiddenTipObj.SetActive(false);
	}
}
