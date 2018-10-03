using UnityEngine;
using System.Collections;

public class HUDRotationAnimation : MonoBehaviour {

	public float time = 1f;

	// Use this for initialization
	void Start () {
		iTween.RotateBy(this.gameObject, iTween.Hash("amount", new Vector3(0,0,-1), "time", time, "easetype", iTween.EaseType.linear, "loopType", iTween.LoopType.loop));
	}
}
