using UnityEngine;
using System.Collections;

public class FarmCow : MonoBehaviour {

	public float maxExp = 5000000;
	public int   id;
	public float curExp;
	public UIProgressBar expBar;
	public UISprite handIcon;
	public GameObject milkObj;

	public UISpriteAnimation sptAnima;
	public Transform animaCont;
	public enum eCowState{hungry, acting, full};
	public ParticleSystem milkPrtl;

	public eCowState cowState;
	private BoxCollider[] bcAry;
	private Vector3 originSize;
	// Use this for initialization
	void Start () {
		init();

		Transform bgTr = transform.parent.parent.Find("bgLayer/bg");
		bcAry = new BoxCollider[bgTr.childCount+8];
		for(int i=0; i< bgTr.childCount; i++){
			bcAry[i] = bgTr.GetChild(i).GetComponent<BoxCollider>();
		}
		bcAry[bgTr.childCount] = bgTr.GetChild(0).GetComponent<BoxCollider>();
		bcAry[bgTr.childCount+1] = bgTr.GetChild(0).GetComponent<BoxCollider>();
		bcAry[bgTr.childCount+2] = bgTr.GetChild(0).GetComponent<BoxCollider>();
		bcAry[bgTr.childCount+3] = bgTr.GetChild(0).GetComponent<BoxCollider>();
		bcAry[bgTr.childCount+4] = bgTr.GetChild(0).GetComponent<BoxCollider>();
		bcAry[bgTr.childCount+5] = bgTr.GetChild(0).GetComponent<BoxCollider>();
		bcAry[bgTr.childCount+6] = bgTr.GetChild(0).GetComponent<BoxCollider>();
		bcAry[bgTr.childCount+7] = bgTr.GetChild(0).GetComponent<BoxCollider>();
		updateDepth();
		InvokeRepeating("cowAct",0.0f, Random.Range(8.0f, 12.0f));
//		transform.position = getRandVc3();

//		Invoke("actMove", 2.0f);
		originSize = this.GetComponent<BoxCollider>().size;
	}

	public void init(int cowID=0, int exp=0)
	{
		curExp = exp;
		id = cowID;
		if(curExp == maxExp){
			stateFull();
		}else{
			stateHungry();
		}
	}

	public void updateDepth()
	{
		sptAnima.GetComponent<UISprite>().depth = 20 - (int)Mathf.Round( transform.localPosition.y);
		handIcon.depth = sptAnima.GetComponent<UISprite>().depth + 1000;
		expBar.backgroundWidget.depth = sptAnima.GetComponent<UISprite>().depth + 1000;
		expBar.foregroundWidget.depth = sptAnima.GetComponent<UISprite>().depth + 1001;
	}

	public Vector3 getRandVc3()
	{
		int rand = Random.Range(0, bcAry.Length);
		BoxCollider bc = bcAry[rand];
		float x;
		if(Random.value>0.5f){
			float minValue = transform.position.x+ bc.bounds.size.x/8;
			if(minValue> bc.bounds.max.x){
				minValue = bc.bounds.max.x;
			}
			x = Random.Range( minValue, bc.bounds.max.x);
		}else{
			float minValue = transform.position.x- bc.bounds.size.x/8;
			if(minValue< bc.bounds.min.x){
				minValue = bc.bounds.min.x;
			}
			x = Random.Range( bc.bounds.min.x , minValue);
		}
		float y = Random.Range( bc.bounds.min.y, bc.bounds.max.y);
		return new Vector3(x, y, 0);
	}

	//[{"act":"idle", "weight":10},{"act":"move", "weight":10},{"act":"sit", "weight":10}]
	void cowAct()
	{
		int rand = Random.Range(1,4);
		if(rand == 1){
			iTween.Stop(gameObject);
			if(sptAnima.namePrefix == "sit"){
				sptAnima.loop = false;
				sptAnima.namePrefix = "cohension";
				sptAnima.framesPerSecond = 10;
				sptAnima.invertPlay(()=>{
					sptAnima.loop = true;
					sptAnima.namePrefix = "stand";
					sptAnima.framesPerSecond = 3;
					sptAnima.Play();
				});
			}else{
				sptAnima.namePrefix = "stand";
				sptAnima.framesPerSecond = 3;
			}
		}else if(rand == 2){
			iTween.Stop(gameObject);
			if(sptAnima.namePrefix == "sit"){

			}else{
				sptAnima.loop = false;
				sptAnima.namePrefix = "cohension";
				sptAnima.framesPerSecond = 10;
				sptAnima.playWithCallback(()=>{ 
					sptAnima.loop = true;
					sptAnima.namePrefix = "sit";
					sptAnima.framesPerSecond = 3;
					sptAnima.Play();});
			}
		}else{
			if(sptAnima.namePrefix == "sit"){
				sptAnima.loop = false;
				sptAnima.namePrefix = "cohension";
				sptAnima.framesPerSecond = 10;
				sptAnima.invertPlay(()=>{
					actMove();
				});
			}else{
				actMove();
			}
		}
	}

	private void actMove()
	{
		Vector3 vc3 = getRandVc3();
		Vector3 originalPt = gameObject.transform.position;
		float angle = Mathf.Atan2(vc3.y - originalPt.y, vc3.x - originalPt.x);
		float rd = angle*180/Mathf.PI;
		if(rd < 0){
			rd = 360 + rd;
		}
		if(rd>0 && rd<=90){
			animaCont.localScale = new Vector3(-1,1,1);
//			Debug.Log("go to right up");
			sptAnima.namePrefix = "walk";
		}else if(rd>90 && rd<=180){
			animaCont.localScale = new Vector3(1,1,1);
//			Debug.Log("go to left up");
			sptAnima.namePrefix = "walk";
		}else if(rd>180 && rd <= 270){
			animaCont.localScale = new Vector3(1,1,1);
//			Debug.Log("go to left bottom");
			sptAnima.namePrefix = "w2";
		}else{
			animaCont.localScale = new Vector3(-1,1,1);
//			Debug.Log("go to right bottom");
			sptAnima.namePrefix = "w2";
		}
		sptAnima.loop = true;
		sptAnima.framesPerSecond = 10;
		sptAnima.Play();
//		Debug.Log(rd);
		iTween.MoveTo(gameObject, iTween.Hash("position",vc3, "speed", Random.Range(0.1f,0.2f), "islocal", false,"easetype",iTween.EaseType.linear,
			"oncomplete","movecom","oncompletetarget",gameObject, "onupdate", "moveupdate", "onupdatetarget",gameObject));

		Invoke("delayScaleBc",0.5f);
	}

	private void delayScaleBc(){
		this.GetComponent<BoxCollider>().size = originSize;
	}

	private void movecom()
	{
		cowAct();
	}
	private void moveupdate()
	{
		updateDepth();
	}

	public void tapHandle(){
		if(cowState == eCowState.hungry){
			//pop up dialog
			iTween.Stop(gameObject);
//			eatFood(100000);
			sptAnima.namePrefix = "stand";
			sptAnima.framesPerSecond = 3;
			GameFarm farmMain = transform.parent.parent.GetComponent<GameFarm>();
			farmMain.popupPanelFood(this);
		}else if(cowState == eCowState.full){
			iTween.Stop(gameObject);
			collectMilk();
			CancelInvoke("cowAct");
			stateActing();
			sptAnima.loop = false;
			sptAnima.namePrefix = "tbm";
			sptAnima.framesPerSecond = 7;
			sptAnima.playWithCallback(()=>{
				sptAnima.loop = false;
				sptAnima.namePrefix = "milked";
				sptAnima.framesPerSecond = 8;
				sptAnima.playWithCallback( ()=>{ stateHungry(); } );
				InvokeRepeating("cowAct",8.0f, Random.Range(8.0f, 12.0f));
			});
		}

	}

	private void collectMilk()
	{
		int milkNum = Random.Range(10,16);
		milkPrtl.gameObject.SetActive(true);
		milkPrtl.Play();
		milkObj.transform.Find("lb").GetComponent<UILabel>().text = "+"+milkNum;
		milkObj.SetActive(true);
		milkObj.transform.localScale = new Vector3(0.01f,0.01f,0.01f);
		iTween.MoveFrom(milkObj,iTween.Hash("y",115.0f,"islocal", true, "time",1.1f, "delay", 1.3f, "oncomplete","collectMilkCom", "oncompletetarget",gameObject,
			"onstart","collectMilkStart","onstarttarget", gameObject));
	}

	private void collectMilkCom()
	{
		milkObj.SetActive(false);
	}
	private void collectMilkStart()
	{
		milkObj.transform.localScale = Vector3.one;
	}

	public void eatFood(int exp){
		curExp += exp;
		if(curExp >= maxExp){
			curExp = maxExp;
			cowState = eCowState.full;
			handIcon.gameObject.SetActive(true);
			expBar.gameObject.SetActive(false);
		}
		expBar.value = curExp/maxExp;
	}

	public void stateHungry()
	{
		cowState = eCowState.hungry;
		handIcon.gameObject.SetActive(false);
		expBar.gameObject.SetActive(true);
		expBar.value = curExp/maxExp;
	}

	public void stateFull()
	{
		cowState = eCowState.full;
		handIcon.gameObject.SetActive(true);
		expBar.gameObject.SetActive(false);
	}
	public void stateActing()
	{
		curExp = 0;
		cowState = eCowState.acting;
		handIcon.gameObject.SetActive(false);
		expBar.gameObject.SetActive(false);
	}

//	void OnCollisionEnter(Collision collision) {
//		foreach (ContactPoint contact in collision.contacts) {
//			Debug.Log("aaaaaaa");
//		}
//
//	}

	void OnTriggerEnter(Collider other) {
//		Debug.Log(gameObject.name + "====" + other.name);
		if(IsInvoking("delayScaleBc")){
			CancelInvoke("delayScaleBc");
		}
		this.GetComponent<BoxCollider>().size = new Vector3(originSize.x*0.7f,originSize.y*0.7f,originSize.z);
		iTween.Stop(gameObject);
		if(sptAnima.namePrefix == "sit"){
			sptAnima.loop = false;
			sptAnima.namePrefix = "cohension";
			sptAnima.framesPerSecond = 10;
			sptAnima.invertPlay(()=>{
				sptAnima.loop = true;
				sptAnima.namePrefix = "stand";
				sptAnima.framesPerSecond = 3;
				sptAnima.Play();
			});
		}else{
			sptAnima.namePrefix = "stand";
			sptAnima.framesPerSecond = 3;
		}
//		Destroy(other.gameObject);
	}
}
