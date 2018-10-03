using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CMPRoadMap : MonoBehaviour {

	public Animator animatorPt;
	public int preRank;
	public int curRank= 999;
	public GameObject[] mileStones;
	private bool isMoveToR;
	// Use this for initialization
	void Start () {
//		init(100);
//		playMoveAnima(0,1);
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public void setDefaultRank(int rank)
	{
		curRank = rank;
	}

	public void init(int myRank){
		preRank = curRank;
		curRank = myRank;

		int startIndex = 0;
		int endIndex = -1;
		if(preRank >= 5){
			startIndex = 0;
		}else{
			startIndex = 5 - preRank;
		}

		int sub = curRank-preRank;

		if(curRank - preRank > 0)
		{
			startIndex = 4;
			endIndex   = 3;
			//move to left
			UILabel lb = mileStones[4].transform.Find("rankTxt").GetComponent<UILabel>();
			lb.text = preRank+"";
			lb = mileStones[3].transform.Find("rankTxt").GetComponent<UILabel>();
			lb.text = curRank+"";
			int plusV = 10;

			for(int i=2; i>=0; i--){
				UILabel lb1 = mileStones[i].transform.Find("rankTxt").GetComponent<UILabel>();
				lb1.text = (curRank + (3-i)*plusV) + "";
			}
		}else if(curRank - preRank < 0){
			//move to right
			UILabel lb = mileStones[0].transform.Find("rankTxt").GetComponent<UILabel>();
			lb.text = preRank+"";
			if(curRank <=4){
				for(int i=1; i< mileStones.Length; i++){
					UILabel lb1 = mileStones[i].transform.Find("rankTxt").GetComponent<UILabel>();
					lb1.text = (5-i) +"";
				}
			}else{
				lb = mileStones[1].transform.Find("rankTxt").GetComponent<UILabel>();
				lb.text = curRank+"";
				int plusV = curRank/3;
				for(int i=2; i< mileStones.Length; i++){
					UILabel lb1 = mileStones[i].transform.Find("rankTxt").GetComponent<UILabel>();
					lb1.text =(curRank - (i-1)*plusV)+"";
					if(lb1.text == "0"){
						lb1.text = "1";
					}
				}
			}


			if(curRank<= 4){
				endIndex = 5 - curRank;
			}else{
				endIndex = 1;
			}
		}else{
			//curRank == preRank
			endIndex = startIndex;
			if(curRank <= 5){
				for(int i=0; i< mileStones.Length; i++){
					UILabel lb1 = mileStones[i].transform.Find("rankTxt").GetComponent<UILabel>();
					lb1.text = (5-i) +"";
				}
			}else{
				UILabel lb = mileStones[0].transform.Find("rankTxt").GetComponent<UILabel>();
				lb.text = curRank+"";
				int plusV = curRank/4;
				for(int i=1; i< mileStones.Length; i++){
					UILabel lb1 = mileStones[i].transform.Find("rankTxt").GetComponent<UILabel>();
					lb1.text =(curRank - i*plusV)+"";
					if(lb1.text == "0"){
						lb1.text = "1";
					}
				}
			}
		}
		playMoveAnima(startIndex, endIndex);
	}

	private void playMoveAnima(int start, int end)
	{
		isMoveToR = (start - end < 0)?true:false;
		Vector3 vc3 = mileStones[start].transform.localPosition;
		Vector3 vc3End = mileStones[end].transform.localPosition;
		Vector3 ptVc3 = animatorPt.gameObject.transform.localPosition;
		ptVc3.x = vc3.x;
		animatorPt.gameObject.transform.localPosition = ptVc3;
		iTween.MoveTo(animatorPt.gameObject, iTween.Hash("x",vc3End.x, "time",0.3f,"islocal",true, "delay", 0.1f, "onstart","moveStart","onstarttarget",gameObject,
		                                                 "easetype",iTween.EaseType.linear,"oncomplete","moveCom","oncompletetarget",gameObject));
	}

	private void moveStart(){
		animatorPt.CrossFade(isMoveToR?"DDZCPtMove":"DDZCPtMoveL",0);
	}

	private void moveCom(){
		animatorPt.CrossFade("DDZCPtMoveStop",0);
	}

}
