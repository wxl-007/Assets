using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TextAnima : MonoBehaviour {

	public UILabel lb;
	public UIFont  winFont;
	public UIFont  loseFont;
	public string resultNum;
	private int   resultNum2;
	private int   preNum=0;
	private int   plusNum = 1;
	private bool isPlaying=false;
	private float duration = 0;
	public float maxSec = 1.0f;
	// Use this for initialization

	public bool useSign = true;
	private float deltaTime;
	private bool isNegative = false;
	void Start () {
//		play(4219);
	}
	
	// Update is called once per frame
	void Update () {
		if(isPlaying){
			deltaTime += Time.deltaTime;
			duration += Time.deltaTime;
			if(deltaTime >= 0.05f){
				int len = resultNum.Length;
				string randStr="";
				if(useSign){
					if(isNegative){
						randStr = "-";
					}else{
						randStr = "+";
					}
				}
				float plusValue = (float)(resultNum2-preNum)/((float)maxSec/0.05f);
				randStr = (plusNum+preNum)+"";
				plusNum += (int)plusValue;
//				for(int i=0; i< len; i++){
//					randStr += Random.Range(0,10).ToString();
//				}
				deltaTime = 0;
				lb.text = randStr;
			}
			if(duration >= maxSec){
				isPlaying = false;
				duration = 0;
				if(useSign){
					if(isNegative){
						resultNum = "-" + resultNum;
					}else{
						resultNum = "+" + resultNum;
					}
				}
				lb.text = resultNum;
			}
		}
	}

	public void play(int num){
		preNum = 0;
		if(num<0){
			isNegative = true;
			if(loseFont != null){
				lb.bitmapFont = loseFont;
			}
		}else{
			isNegative = false;
			if(winFont != null){
				lb.bitmapFont = winFont;
			}
		}
		resultNum = Mathf.Abs(num).ToString();
		resultNum2 = num;
		isPlaying = true;
		duration = 0;
		plusNum = 0;
	}

	public void play2(int preNum, int curNum){
		play(curNum);
		if(preNum != curNum){
			this.preNum = preNum;
		}
	}

	public void stop(int num=0){
		isPlaying = false;
		lb.text = num + "";
	}
}
