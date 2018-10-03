using UnityEngine;
using System.Collections;

/// <summary>
/// 100以内的倒计时,适用于左右两个Sprite分别作为该数字的十位数和各位数
/// </summary>
public class TBNNCount : MonoBehaviour {
	private static TBNNCount _instance;

	public static TBNNCount Instance {
		get{
			if(_instance == null) {
				_instance = (TBNNCount) FindObjectOfType(typeof(TBNNCount));
			}
			return _instance;
		}
	}

	public UISprite spriteL;
	public UISprite spriteR;

	public AudioClip soundCount;

	private float _currTime = 0;
	private int _num = 20;

	// Update is called once per frame
	void Update () {
		if((Time.time-_currTime)>=1) {
			if(_num>0) {
				_num--;
				UpdateHUD(_num);

				if(_num <=5 && soundCount != null) 
//					NGUITools.PlaySound(soundCount);
					EginTools.PlayEffect(soundCount);
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
		spriteL.spriteName = "time_" + numStr.Substring (0, 1);
		spriteR.spriteName = "time_" + numStr.Substring (1, 1);
	}

	public void DestroyHUD() {
		if(this.gameObject.activeSelf) {
			this.gameObject.SetActive(false);
		}
	}
}
