using UnityEngine;
using System.Collections;

/// <summary>
/// 100以内的倒计时,适用于左右两个Sprite分别作为该数字的十位数和各位数
/// </summary>
public class NNCount : MonoBehaviour {
	private static NNCount _instance;

	public static NNCount Instance {
		get{
			if(_instance == null) {
				_instance = (NNCount) FindObjectOfType(typeof(NNCount));
			}
			return _instance;
		}
	}

	public UISprite spriteL;
	public UISprite spriteR;
    public UILabel m_TimeLab;

	public AudioClip soundCount;

	private float _currTime = 0;
	private int _num = 20;

	// Update is called once per frame
	void Update () {
		if((Time.time-_currTime)>=1) {
			if(_num>0) {
				_num--;
				UpdateHUD(_num);
				if(isShakeStyle){
					transform.Find("timebackground").gameObject.GetComponent<UISprite>().alpha = 0;
					spriteL.alpha = 0;
					spriteR.alpha = 0;
				}
				if(_num <=5 && soundCount != null){
					EginTools.PlayEffect(soundCount);
					//NGUITools.PlaySound(soundCount);	
					if(isShakeStyle){
						transform.Find("timebackground").gameObject.GetComponent<UISprite>().alpha = 1;
						spriteL.alpha = 1;
						spriteR.alpha = 1;
						iTween.ShakeRotation(transform.Find("timebackground").gameObject, iTween.Hash("time", 0.8f, "z", 30.0f, "easetype",iTween.EaseType.linear));
					}
				}
			}
		}
	}

	public void UpdateHUD(int num) {
		if(!this.gameObject.activeSelf) {
			this.gameObject.SetActive(true);
		}
		_currTime = Time.time;
		_num = num;

		string numStr = num < 10 ? "0" + num : num.ToString ();
		spriteL.spriteName = "count_" + numStr.Substring (0, 1);
		spriteR.spriteName = "count_" + numStr.Substring (1, 1);
        UpdateLabelTime(num);
	}


	//add by xiaoyong 2016.1.16 ..GameYSZ  game designer need this effect
	private bool isShakeStyle = false;
	public void toShakeStyle(){
		isShakeStyle = true;
		transform.Find("timebackground").gameObject.GetComponent<UISprite>().alpha = 0;
		spriteL.alpha = 0;
		spriteR.alpha = 0;

	}
//	public void toNormalStyle(){
//		transform.FindChild("timebackground").gameObject.GetComponent<UISprite>().alpha = 0.5f;
//		spriteL.alpha = 1;
//		spriteR.alpha = 1;
//	}


    public void UpdateLabelTime(int tNum) {
        if (m_TimeLab != null) {
            m_TimeLab.text = tNum.ToString();
        }
    }

	public void DestroyHUD() {
		if(this.gameObject.activeSelf) {
			this.gameObject.SetActive(false);
		}
	}
}
