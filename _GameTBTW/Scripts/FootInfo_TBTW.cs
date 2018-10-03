using UnityEngine;
using System.Collections;

public class FootInfo_TBTW : MonoBehaviour
{
	public UISprite spriteAvatar;

	public UILabel labelNickname;

	public UILabel labelBagmoney;

	public UILabel labelLv;

	private static UILabel _labelBagmoney_TBTW;

	public void Awake () {
		UIRoot sceneRoot = transform.root.GetComponent<UIRoot>();
		if (sceneRoot != null) {
			int manualHeight = 800;		// Android
			
			#if UNITY_IPHONE
			if((UnityEngine.iOS.Device.generation.ToString()).IndexOf("iPad") > -1){	// iPad
				manualHeight = 1000;	
			}else if (Screen.width <= 960) {	// <= iPhone4s
				manualHeight = 900;
			}
			#endif
			
			sceneRoot.scalingStyle = UIRoot.Scaling.ConstrainedOnMobiles;
			sceneRoot.manualHeight = manualHeight;
		}
	}

	// Use this for initialization
	void Start () {
		spriteAvatar.spriteName = "avatar_" + EginUser.Instance.avatarNo;

		labelNickname.text = EginUser.Instance.nickname;

		UpdateIntomoney( EginUser.Instance.bagMoney);

		labelLv.text = EginUser.Instance.level.ToString();
	}
	
	public void UpdateIntomoney(string intoMoney) {
		if(!string.IsNullOrEmpty(intoMoney)) {
			labelBagmoney.text = ""+EginTools.NumberAddComma (intoMoney);
		}
	}
}
