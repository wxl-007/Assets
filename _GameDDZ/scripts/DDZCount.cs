using UnityEngine;
using System.Collections;


/// <summary>
/// 100以内的倒计时,适用于左右两个Sprite分别作为该数字的十位数和各位数
/// </summary>
public class DDZCount : MonoBehaviour
{
	private static DDZCount _instance;


	public static DDZCount Instance {
		get{
			if(_instance == null) {
				_instance = (DDZCount) FindObjectOfType(typeof(DDZCount));
			}
			return _instance;
		}
	}

	public delegate void TimeUpHanlde();

	public TimeUpHanlde timeUpCallback;

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
                UpdateHUD(_num, 11);

                if(_num <=5 && soundCount != null){
					gameObject.GetComponent<UISprite>().spriteName = "timerBgRed";
					EginTools.PlayEffect(soundCount);
					if(_num == 0 && timeUpCallback != null){
						timeUpCallback();
					}
				}else{
					gameObject.GetComponent<UISprite>().spriteName = "timerBgGreen";
				}
            }
        }
    }
	void OnDestroy(){
		timeUpCallback = null;
	}

	public void moveTo(DDZPlayerCtrl playCtrl, bool isOb=false)
	{
		if(playCtrl.isMyself){
			if(isOb){
				transform.localPosition = new Vector3(0,-80.0f,0);
			}else{
				transform.localPosition = new Vector3(0,100.0f,0);
			}
		}else{
			if(isOb){
				transform.position = playCtrl.deskcardCtrl.transform.position + new Vector3(0,-0.3f,0);
			}else{
				transform.position = playCtrl.deskcardCtrl.transform.position;
			}
		}
		playCtrl.forceHideAllBubble();
	}

    public void UpdateHUD(int num, int aa) {
        if(!this.gameObject.activeSelf) {
            this.gameObject.SetActive(true);
        }
        _currTime = Time.time;
        _num = num;
		if(_num <=5){
			gameObject.GetComponent<UISprite>().spriteName = "timerBgRed";
		}else{
			gameObject.GetComponent<UISprite>().spriteName = "timerBgGreen";
		}

        string numStr = num < 10 ? "0" + num : num.ToString ();
        spriteL.spriteName = "t" + numStr.Substring(0, 1);
        spriteR.spriteName = "t" + numStr.Substring(1, 1);
    }

    public void DestroyHUD() {
        if(this.gameObject.activeSelf) {
            this.gameObject.SetActive(false);
        }
    }
}
