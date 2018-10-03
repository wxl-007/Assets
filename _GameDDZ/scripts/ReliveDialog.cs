using UnityEngine;
using System.Collections;

public class ReliveDialog : MonoBehaviour {

	public UILabel countLb;
	public UILabel moneyLb;
	public UILabel cdTimeLb;
	public GameObject content;
	public UIButton yesBtn;
	public UIButton noBtn;

	private int cd;
	// Use this for initialization
	void Start () {
		iTween.ScaleFrom(content, iTween.Hash("scale",new Vector3(0.5f, 0.2f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );

//		initData(10,2000,150);
	}

	public void initData(int count, int coinNum, int cdTime)
	{
		countLb.text = count+"";
		moneyLb.text = coinNum + "";
		cd = cdTime;
		InvokeRepeating("repeatingCD",0.1f,1.0f);
	}

//	public void reliveOk()
//	{
//
//	}
//
//	public void reliveCancel()
//	{
//
//	}

	private void repeatingCD()
	{
		if(cd <=0){
			CancelInvoke("repeatingCD");
			timeout();
		}
		cdTimeLb.text = EginTools.miao2TimeStr(cd,true, true).Substring(3);
		cd--;
	}

	private void timeout()
	{
		gameObject.SetActive(false);
	}
}
