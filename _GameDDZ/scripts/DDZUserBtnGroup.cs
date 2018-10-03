using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZUserBtnGroup : MonoBehaviour {

	public GameDDZ mainCls;
	public GameObject gameStartGroup;
	public GameObject clearDeckCD;
	public GameObject callMasterGroup;
	public GameObject callMasterGroup2;
	public GameObject gamePlayCardGroup;
	public GameObject increaseMulGroup;

	public GameObject[] playCardBtnAry;
	public GameObject   cantHandleObj;
	public UISprite     sptCall;
	public UISprite     sptCallNot;

	private GameObject targetCallMasterG;

	public bool isManaged = false;

	private UISprite countDownSpt;
	private int count;
	private const int MAX_COUNT = 4;

	void Awake(){
		countDownSpt = clearDeckCD.transform.GetChild(0).GetComponent<UISprite>();
		targetCallMasterG = callMasterGroup2;
	}

	// Use this for initialization
	void Start () {
//		clearCountDown(true);
	}

	public void hideAll()
	{
		setVisible(false, false);
	}

	public void gameStart(bool isShow)
	{
//		gameStartGroup.SetActive(isShow);
//		clearDeckCD.SetActive(false);

		if(!mainCls.isMatch){
			setVisible(isShow, false);
//			gameStartGroup.transform.FindChild("btnClearDeckStart").gameObject.SetActive(false);
		}else{
			setVisible(false, false);
		}
	}
	public void callMaster(bool isShow, bool isVS, bool isLoot)
	{
		if(isVS){
			targetCallMasterG = callMasterGroup;
		}else{
			targetCallMasterG = callMasterGroup2;
			if(isLoot){
				sptCall.spriteName = "btnLoot";
				sptCallNot.spriteName = "btnLootNot";
			}else{
				sptCall.spriteName = "btnCallMaster";
				sptCallNot.spriteName = "btnNotCall";
			}
		}
		setVisible(false, false, true);
	}
	public void playCard(bool isShow, bool canHandle = true)
	{
		if(isManaged){
			setVisible(false,false,false,false);
			return;
		}
		setVisible(false,false,false,isShow);
		if(canHandle){
			for(int i=0; i< playCardBtnAry.Length; i++){
				playCardBtnAry[i].SetActive(true);
			}
			cantHandleObj.SetActive(false);
		}else{
			for(int i=0; i< playCardBtnAry.Length; i++){
				playCardBtnAry[i].SetActive(false);
			}
			cantHandleObj.SetActive(true);
		}
	}

	public void enablePassBtn(bool isEnable){
		//pass
		UIButtonMessage passBtn = playCardBtnAry[0].GetComponent<UIButtonMessage>();
		passBtn.enabled = isEnable;
		if(isEnable){
			playCardBtnAry[0].GetComponent<UISprite>().spriteName = "btnPass";
		}else{
			playCardBtnAry[0].GetComponent<UISprite>().spriteName = "btnPassGray";
		}
	}

	public void enableTip(bool tip)
	{
		//tip
		UIButtonMessage tipBtn = playCardBtnAry[1].GetComponent<UIButtonMessage>();
		tipBtn.enabled = tip;
		if(tip){
			playCardBtnAry[1].GetComponent<UISprite>().spriteName = "btnTip";
		}else{
			playCardBtnAry[1].GetComponent<UISprite>().spriteName = "btnTipGray";
		}

	}

	public void enableDrawBtn(bool isEnable)
	{
		//draw
		UIButtonMessage playBtn = playCardBtnAry[2].GetComponent<UIButtonMessage>();
		playBtn.enabled = isEnable;
		if(isEnable){
			playCardBtnAry[2].GetComponent<UISprite>().spriteName = "btnDrawCard";
		}else{
			playCardBtnAry[2].GetComponent<UISprite>().spriteName = "btnDrawGray";
		}
	}

	public bool drawBtnHighlight{
		get{
			if(playCardBtnAry[2].activeInHierarchy){
				return playCardBtnAry[2].GetComponent<UISprite>().spriteName == "btnDrawCard";
			}
			return false;
		}
	}

	public IEnumerator clearCountDown()
	{
		count = MAX_COUNT;
		yield return new WaitForSeconds(1.0f);
		setVisible(false, true);
		calcTest = Time.time;
		startCountDown();
	}

	public void stopCountDown()
	{
		if(IsInvoking("invokeCD")){
			CancelInvoke("invokeCD");
		}
		setVisible(false, false);
	}
	public void increaseMultiple(bool isShow)
	{
		setVisible(false,false,false,false,isShow);
	}
//	public void showDeck(bool isShow)
//	{
//		setVisible(false,false,false,false,false, isShow);
//	}

	//bet multiple
	public int getCurCount(){
		return count;
	}

	private void setVisible(bool gStart, bool clearCD, bool callMaster = false, bool playCard = false, bool increaseMul = false)
	{
		gameStartGroup.SetActive(gStart);
		clearDeckCD.SetActive(clearCD);
		targetCallMasterG.SetActive(callMaster);
		gamePlayCardGroup.SetActive(playCard);
		increaseMulGroup.SetActive(increaseMul);
	}

	private float calcTest = 0;
	private void startCountDown(){
		count = MAX_COUNT;
		countDownSpt.spriteName = "clearDeckNum4";
		if(IsInvoking("invokeCD")){
			CancelInvoke("invokeCD");
		}
		InvokeRepeating("invokeCD", 1.0f, 1.0f);
	}

	private void invokeCD()
	{
		count--;
		if(count == 1){
			CancelInvoke("invokeCD");
			Debug.LogError("end--->"+(Time.time - calcTest));
			hideAll();
		}else{
			countDownSpt.spriteName = "clearDeckNum"+count;
		}
	}

}
