using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class OpenCardAnima : MonoBehaviour {

	public UISprite spt;
	public string closeSptname = "card_blue";
	public float  durationTime;
	public float delayTime;
	[Range(0,1.0f)]
	public float zommInPer;
	public Vector3 originScale;
	public bool needMove = false;
	public Vector3 targetVc3;
	private string targetSptName;
	// Use this for initialization
	void Start () {
//		play("card_1");
//		originScale = transform.localScale;
	}

	public void play(string sptName, float time, float delay = 0)
	{

		targetSptName = sptName;
		iTween.ScaleTo(gameObject, iTween.Hash("time",time, "scale", new Vector3(0,originScale.y+ originScale.y*zommInPer,1), "delay", delay, "easetype",iTween.EaseType.linear,
		                                       "oncomplete","openCard", "oncompletetarget", gameObject, "oncompleteparams", time));
	}

	public void play(string sptName)
	{
		play(sptName, durationTime, delayTime);
	}

	public void skipAnima(string sptName, float scaleSize= 0.45f)
	{
		transform.localScale    = new Vector3(scaleSize,scaleSize,1);
		targetSptName = sptName;
		spt.spriteName = targetSptName;
		transform.localPosition = targetVc3;
	}

	public void close(){
		iTween.Stop(gameObject);
		transform.localScale = originScale;
		spt.spriteName = closeSptname;
	}
	               

	private void openCard(float time)
	{
		spt.spriteName = targetSptName;
		if(needMove){
			iTween.ScaleTo(gameObject, iTween.Hash("time",time, "scale", originScale, "oncomplete", "moveToTarget", "oncompletetarget", gameObject));
		}else{
			iTween.ScaleTo(gameObject, iTween.Hash("time",time, "scale", originScale));
		}
		                                  
	}

	protected virtual void moveToTarget()
	{
		iTween.MoveTo(gameObject, iTween.Hash("time", 0.5f, "position",targetVc3, "islocal", true,"delay",0.5f));
		iTween.ScaleTo(gameObject, iTween.Hash("scale", new Vector3(0.45f,0.45f,1), "time", 0.5f ,"delay",0.5f));
	}

}
