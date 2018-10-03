using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CMPInfoPanel : MonoBehaviour {

	public UILabel scoreLb;
	public UILabel myMulLb;
	public UILabel myRankLb;
	public UILabel totalRank;
	public UILabel countDownMul;
	public UILabel countDownFinal;
	public UISprite titleSpt;
	public UILabel matchDesLb;
	public UILabel mulTipLb;
	public UILabel lvupTipLb;

	public UILabel totalScoreLb;
	public UILabel avgScoreLb;
	public UILabel roundLb;

	private int finalTimeStart;
	private int scorePlusTime;
	public bool isFinalVS =false;
	// Use this for initialization
	void Start () {
		//Debug.LogError( EginTools.miao2TimeStr(256.0f,true) );
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public void toHappy131Mode()
	{
		totalScoreLb.gameObject.SetActive(true);
		avgScoreLb.gameObject.SetActive(true);
		roundLb.gameObject.SetActive(true);
		countDownMul.transform.parent.gameObject.SetActive(false);
		countDownFinal.gameObject.SetActive(false);
		lvupTipLb.gameObject.SetActive(false);
		titleSpt.gameObject.SetActive(false);
		transform.Find("panel2").gameObject.SetActive(false);
		totalRank.gameObject.SetActive(false);
		myRankLb.transform.parent.gameObject.SetActive(false);
	}

	public void resetState()
	{
		isFinalVS = false;
		mulTipLb.gameObject.SetActive(true);
		lvupTipLb.gameObject.SetActive(true);
		titleSpt.spriteName = "txtNormalVS";
	}

	public void stopAllInvoke()
	{
		if(IsInvoking("invokeScorePlus")){
			CancelInvoke("invokeScorePlus");
		}
		if(IsInvoking("finalCDInvoke")){
			CancelInvoke("finalCDInvoke");
		}
	}

	public void startFinalCD(int startTime)
	{
		if(isFinalVS){
			titleSpt.spriteName = "txtFinalVS";
			if(IsInvoking("invokeScorePlus")){
				CancelInvoke("invokeScorePlus");
			}
			countDownMul.text = "";
			mulTipLb.gameObject.SetActive(false);
			lvupTipLb.gameObject.SetActive(false);
		}else{
			titleSpt.spriteName = "txtNormalVS";
		}
		finalTimeStart = startTime;
		if(IsInvoking("finalCDInvoke")){
			CancelInvoke("finalCDInvoke");
		}
		InvokeRepeating("finalCDInvoke", 0.1f,1.0f);
	}
	public void startScorePlusCD(int scoreTime, bool ignore=false)
	{
		if(isFinalVS)return;
		scorePlusTime = scoreTime;

			if(IsInvoking("invokeScorePlus")){
				if(!ignore){
					int nowScore = int.Parse(scoreLb.text);
					scoreLb.text = nowScore*2+"";
				}
				CancelInvoke("invokeScorePlus");
			}
		InvokeRepeating("invokeScorePlus", 0.1f,1.0f);
	}

	private void finalCDInvoke()
	{
		if(finalTimeStart <= 0){
			finalTimeStart = 0;
			CancelInvoke("finalCDInvoke");
			isFinalVS = true;
		}
		countDownFinal.text = EginTools.miao2TimeStr(finalTimeStart,true, true);
		finalTimeStart -= 1;
	}

	private void invokeScorePlus()
	{
		if(scorePlusTime <= 0){
			scorePlusTime = 0;
			CancelInvoke("invokeScorePlus");
			int nowScore = int.Parse(scoreLb.text);
			scoreLb.text = nowScore*2+"";
		}
		countDownMul.text = EginTools.miao2TimeStr(scorePlusTime,true, true);
		scorePlusTime -= 1;
	}
}
