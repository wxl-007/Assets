using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VfxAnimaGroup : MonoBehaviour {

	public UISpriteAnimation[] shunAry;
	public Transform shun;

	public UISpriteAnimation springObj;
	public UISpriteAnimation antonymSpringObj;
	public UISpriteAnimation bombObj;
	public UISpriteAnimation rocketSmoke;

	public GameObject rocketObj;
	public GameObject airPlaneObj;



	// Use this for initialization
	void Start () {
//		Invoke("rocket", 2.0f);
//		StartCoroutine( ABCDEF(null) );
	}

	public void resultAnima(bool isSpring)
	{
		if(isSpring){
			spring();
		}else{
			antonymSpring();
		}
	}

	public void cardTypeAnima(int cardType, DDZPlayerCtrl playerCtrl=null)
	{
		//单张0，对子1，三张2，三带单3，三带对4，单顺5，双顺6，飞机7，飞机带单8，飞机带双9，四带两单10，炸弹12，火箭13
		if(cardType == 5 || cardType == 6){
			StartCoroutine( ABCDEF(playerCtrl) );
		}else if(cardType == 7 || cardType == 8 || cardType == 9){
			airplane();
		}else if(cardType == 12){
			bomb();
		}else if(cardType == 13){
			rocket();
		}
	}
	
	public void spring(){
		if(springObj == null){
			GameObject springPrb = SimpleFramework.Util.LoadAsset("GameDDZ/pfb","AnimaSpring") as GameObject;
			springObj = NGUITools.AddChild(gameObject, springPrb).GetComponent<UISpriteAnimation>();
		}
		springObj.gameObject.SetActive(true);
		springObj.playWithCallback(()=>{springObj.gameObject.SetActive(false);});
	}

	public void antonymSpring(){
		if(antonymSpringObj == null){
			GameObject tspringPrb = SimpleFramework.Util.LoadAsset("GameDDZ/pfb","AnimaTspring") as GameObject;
			antonymSpringObj = NGUITools.AddChild(gameObject, tspringPrb).GetComponent<UISpriteAnimation>();
		}
		antonymSpringObj.gameObject.SetActive(true);
		antonymSpringObj.playWithCallback(()=>{antonymSpringObj.gameObject.SetActive(false);});
	}

	public IEnumerator ABCDEF(DDZPlayerCtrl playerCtrl){
		if(DDZSoundMgr.sfxSound){
			DDZSoundMgr.instance.playEft("sound/sound_shunzi");
		}
		shun.gameObject.SetActive(true);
		if(playerCtrl != null){
			shun.gameObject.transform.position = playerCtrl.deskcardCtrl.transform.position;
		}
		shunAry[0].gameObject.SetActive(true);
		shunAry[0].playWithCallback(()=>{shunAry[0].gameObject.SetActive(false);});
		yield return new WaitForSeconds(0.2f);
		shunAry[1].gameObject.SetActive(true);
		shunAry[1].playWithCallback(()=>{shunAry[1].gameObject.SetActive(false);});
		yield return new WaitForSeconds(0.2f);
		shunAry[2].gameObject.SetActive(true);
		shunAry[2].playWithCallback(()=>{shunAry[2].gameObject.SetActive(false);});

//		shun.transform.position = vc3;
//		Invoke("hideShun", 3.0f);
	}
	public void AABBCC(DDZPlayerCtrl playerCtrl){
//		DDZSoundMgr.instance.playEft("sound/sound_shunzi");
//		shun2.transform.position = vc3;
//		Invoke("hideShun2", 3.0f);
//		shun2.gameObject.SetActive(true);
//		if(playerCtrl != null){
//			shun2.gameObject.transform.position = playerCtrl.deskcardCtrl.transform.position;
//		}
//		shun2.playWithCallback(()=>{shun2.gameObject.SetActive(false);});
	}

	public void airplane(){
		if(airPlaneObj == null){
			GameObject airPrb = SimpleFramework.Util.LoadAsset("GameDDZ/pfb","AnimaAir") as GameObject;
			airPlaneObj = NGUITools.AddChild(gameObject, airPrb);
		}
		airPlaneObj.transform.localPosition = new Vector3(-1000.0f,167.5f,0);
		if(DDZSoundMgr.sfxSound){
			DDZSoundMgr.instance.playEft("sound/sound_feiji");
		}
		airPlaneObj.SetActive(true);
		iTween.MoveFrom(airPlaneObj, iTween.Hash("x", 1000.0f, "time", 1.5f,"easetype", iTween.EaseType.linear,"islocal", true,
		                                         "oncomplete","airplaneMoveCom","oncompletetarget",gameObject));
	}

	public void bomb(){
		if(bombObj == null){
			GameObject bombPrb = SimpleFramework.Util.LoadAsset("GameDDZ/pfb","AnimaBomb") as GameObject;
			bombObj = NGUITools.AddChild(gameObject, bombPrb).GetComponent<UISpriteAnimation>();
			bombObj.transform.localPosition = new Vector3(0,86.0f,0);
		}
		if(DDZSoundMgr.sfxSound){
			DDZSoundMgr.instance.playEft("sound/sound_zhadan");
		}
		bombObj.gameObject.SetActive(true);
		bombObj.playWithCallback(()=>{bombObj.gameObject.SetActive(false);});
	}

	public void rocket(){
		rocketSmoke.gameObject.SetActive(true);
		rocketSmoke.playWithCallback(()=>{rocketSmoke.gameObject.SetActive(false);});
		rocketObj.gameObject.transform.localPosition = Vector3.zero;
		rocketObj.SetActive(true);
		iTween.ScaleTo(rocketObj,iTween.Hash("x", 1.1f, "looptype", iTween.LoopType.pingPong, "time", 0.01f));
		iTween.MoveTo(rocketObj, iTween.Hash("y", 1000.0f, "time", 2.0f,"islocal", true, "easetype", iTween.EaseType.easeInCirc,
		                                     "oncomplete", "rocketCom","oncompletetarget", gameObject));
		DDZSoundMgr.instance.playEft("sound/sound_huojian");
	}

	private void rocketCom()
	{
		rocketObj.SetActive(false);
	}

	private void airplaneMoveCom()
	{
		airPlaneObj.SetActive(false);
	}

//	private void hideShun(){
//		shun.SetActive(false);
//	}
//	private void hideShun2(){
//		shun2.SetActive(false);
//	}
}
