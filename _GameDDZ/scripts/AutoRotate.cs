using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class AutoRotate : MonoBehaviour {

	public Vector3 angle;
	public int frameRate;

	private float dtime;
	private float interval;
	// Use this for initialization
	void Start () {
		interval = 1/(float)frameRate;
	}
	
	// Update is called once per frame
	void Update () {
		if(dtime> interval){
			dtime = 0;
			this.transform.Rotate(angle);
		}
		dtime += Time.deltaTime;

	}
}
