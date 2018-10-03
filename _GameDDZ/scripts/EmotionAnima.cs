using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EmotionAnima : MonoBehaviour {

	public float iTweenTime = 0.5f;
	public float durationTime = 2.5f;
	// Use this for initialization
	void Start () {
		iTween.ScaleFrom(gameObject, iTween.Hash("scale",new Vector3(0.5f,0.5f,0.5f), "time", iTweenTime,
		                                         "easetype", iTween.EaseType.easeOutBounce) );
		Invoke("destroyAnima",durationTime);
	}

	private void destroyAnima()
	{
		iTween.ScaleTo(gameObject, iTween.Hash("scale",Vector3.zero, "time", 0.1f,"oncomplete", "AutoDestroy", "oncompletetarget",gameObject,
		                                         "easetype", iTween.EaseType.linear) );
	}

	private void AutoDestroy(){
		Destroy(gameObject);
	}
}
