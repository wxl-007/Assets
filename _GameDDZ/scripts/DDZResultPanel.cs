using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZResultPanel : MonoBehaviour {
	
	public GameObject winBgObj;
	public GameObject loseBgObj;
	public UILabel bombtime;
	public UILabel rockettime;
	public UILabel isspring;
	public UILabel winmoney;
	public UISprite Himg;
	public GameDDZ  ddzMainContent;

	// Use this for initialization
	void Start () {
//		gameObject.transform.localScale = Vector3.zero;
//		Invoke("popupAnima", 3.0f);
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public void popupAnima()
	{
		gameObject.SetActive(true);
		gameObject.transform.localScale = Vector3.one;
		iTween.ScaleFrom(gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.5f,1.0f), "time", 0.3f,
		                                         "easetype", iTween.EaseType.easeOutBack) );
	}

	public void setState(int zhadanshu, int huojianshu, bool shifouchuntian, int money, bool iswiner, bool isbanker)
	{
		bombtime.text = zhadanshu + "";
		rockettime.text = huojianshu + "";
		if (shifouchuntian)
		{
			isspring.text = "是";
		}
		else {
			isspring.text = "否";
		}
		if (money > 0)
		{
			winmoney.text = "[FFFF00]" + money;
			if (isbanker)
			{
				Himg.spriteName = "banker_1";
			}
			else
			{
				Himg.spriteName = "poor_1";
			}
			winBgObj.gameObject.SetActive(true);
			loseBgObj.gameObject.SetActive(false);
		}
		else {
			winmoney.text = "[FF0000]" + money;
			if (isbanker)
			{
				Himg.spriteName = "banker_3";
			}
			else
			{
				Himg.spriteName = "poor_2";
			}
			winBgObj.gameObject.SetActive(false);
			loseBgObj.gameObject.SetActive(true);
		}

		Invoke("popupAnima", 2.5f);
	}

	public void continueHandle()
	{
		gameObject.SetActive(false);
		ddzMainContent.UserReady();
	}
	public void changeDeskHandle()
	{
		gameObject.SetActive(false);
		ddzMainContent.UserChangedesk();
	}

}
