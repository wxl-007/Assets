using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZCBeginAnima : MonoBehaviour {

	// Use this for initialization
	void Start () {
		Color c = changeSaturation(new Color(1.0f,0,0), 0.5f);
		Debug.Log(c.ToString());
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	private const float pr = 0.299f;
	private const float pg = 0.587f;
	private const float pb = 0.114f;
	Color changeSaturation(Color color, float change){
		float p = Mathf.Sqrt(color.r*color.r*pr + color.g*color.g*pg + color.b*color.b*pb);

		color.r = p+ (color.r - p)*change;
		color.g = p+ (color.g - p)*change;
		color.b = p+ (color.b - p)*change;
		return color;
	}
}
