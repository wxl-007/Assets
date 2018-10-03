using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PoolInfo : MonoBehaviour
{

	public UILabel _myFenTxt;
	public UILabel _poolFenTxt;
	public GameObject uInfoList;//奖池列表信息
	public GameObject firstView;//奖池列表信息
	 

	// Use this for initialization
		void Start ()
		{
		//uInfoList.SetActive (false);myLPool
		uInfoList.SetActive (false);
		firstView.SetActive (false);

		UILabel myLPool =uInfoList.transform.Find("myLPool").GetComponent<UILabel>();
		myLPool.text = "";
		_poolFenTxt.text = "";
		_myFenTxt.text = "";
			for(int i=0;i<8;i++){
				UILabel indexT = uInfoList.transform.Find("peo"+i).transform.Find("mcTxt").GetComponent<UILabel>();
	 			UILabel nickT = uInfoList.transform.Find("peo"+i).transform.Find("nickTxt").GetComponent<UILabel>();
				UILabel fenT = uInfoList.transform.Find("peo"+i).transform.Find("fenTxt").GetComponent<UILabel>();
				indexT.text = "";
				nickT.text = "";
				fenT.text = "";
			}
		}
	
		// Update is called once per frame
		void Update ()
		{
	
		}

	public void OnClickList () {
		if (uInfoList.activeSelf) {
			uInfoList.SetActive (false);
		} else {
			uInfoList.SetActive (true);
		}
	}

	public void setMyPool(string chiFen){
		if(!firstView.activeSelf){
 			firstView.SetActive (true);
		}


		_myFenTxt.text = chiFen;

		UILabel myLPool =uInfoList.transform.Find("myLPool").GetComponent<UILabel>();
		myLPool.text = chiFen;
	}

	public void showTiShi(string info){
		EginProgressHUD.Instance.HideHUD();
		EginProgressHUD.Instance.ShowPromptHUD(info);
	}

	/// <summary>
	/// show pool score list 
	/// add by xiaoyong 2015.12.24
	/// for call in Lua
	/// </summary>
	/// <param name="poolScore">Pool score.</param>
	/// <param name="infosStr"> json string.</param>
	public void showByStr(string poolScore,  string infosStr){
		JSONObject infosJson = new JSONObject(infosStr);
		show(poolScore, infosJson.list);
	}

	public void show(string chiFen,List<JSONObject> infos){
		if(!firstView.activeSelf){
			firstView.SetActive (true);
		}


		_poolFenTxt.text = chiFen;


		int xNum = infos.Count;
		if(xNum>8){
			xNum=8;
		}

		for(int i=0;i<xNum;i++){
			JSONObject info = infos[i];
			string uNick = info[0].str;
			string uFen = info[1].ToString();

			UILabel indexT = uInfoList.transform.Find("peo"+i).transform.Find("mcTxt").GetComponent<UILabel>();
			UILabel nickT = uInfoList.transform.Find("peo"+i).transform.Find("nickTxt").GetComponent<UILabel>();
			UILabel fenT = uInfoList.transform.Find("peo"+i).transform.Find("fenTxt").GetComponent<UILabel>();
 
			indexT.text = (i+1).ToString();
			nickT.text = uNick;
			fenT.text = uFen;
 		}

 	}




}

