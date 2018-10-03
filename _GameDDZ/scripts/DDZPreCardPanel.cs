using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZPreCardPanel : MonoBehaviour {

	public GameObject[] otherPanel;

	public GameObject passB;
	public DeskCardCtrl deskB;

	public GameObject passL;
	public DeskCardCtrl deskL;

	public GameObject passR;
	public DeskCardCtrl deskR;

	private Dictionary<DeskCardCtrl.eDeskCardType, Hashtable> dc = new Dictionary<DeskCardCtrl.eDeskCardType, Hashtable>();
	// Use this for initialization
	void Start () {

	}
	
	public void init()
	{
		Hashtable hashBottom = new Hashtable();
		hashBottom["txt"] = passB;
		hashBottom["deskCtrl"] = deskB;
		dc[DeskCardCtrl.eDeskCardType.bottom] = hashBottom;

		Hashtable hashLeft = new Hashtable();
		hashLeft["txt"] = passL;
		hashLeft["deskCtrl"] = deskL;
		dc[DeskCardCtrl.eDeskCardType.left] = hashLeft;

		Hashtable hashRight = new Hashtable();
		hashRight["txt"] = passR;
		hashRight["deskCtrl"] = deskR;
		dc[DeskCardCtrl.eDeskCardType.right] = hashRight;

//		gameObject.SetActive(false);
		gameObject.transform.localScale = Vector3.zero;

//		deskL.drawCards2(new JSONObject("[0,1,2,3,4,5,6,7,8,9,10,11]").list, true);
//		deskR.drawCards2(new JSONObject("[0,1,2,3,4]").list,true);
//		deskB.drawCards2(new JSONObject("[0,1,2,3,4,5,6,7,8,9,10,11]").list,true);
	}

	public void showPreCard(List<GameObject> playList = null)
	{
		gameObject.SetActive(true);
		gameObject.transform.localScale = Vector3.one;
		iTween.ScaleFrom(gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
		                                         "easetype", iTween.EaseType.easeOutBack) );
		for(int i=0; i< otherPanel.Length; i++){
			otherPanel[i].transform.localScale = Vector3.zero;
		}
		if(playList.Count != 3){
			return;
		}
		for(int i=0; i< playList.Count; i++){
			DeskCardCtrl deskC = playList[i].GetComponent<DDZPlayerCtrl>().deskcardCtrl;
			Hashtable hash = dc[deskC.deskCardType];
			GameObject passObj = hash["txt"] as GameObject;
			DeskCardCtrl cardCtrl = hash["deskCtrl"] as DeskCardCtrl;
			if(deskC.preCardData == null){
				passObj.SetActive(true);
			}else{
				passObj.SetActive(false);
			}
			cardCtrl.drawCards2(deskC.preCardData, playList[i].GetComponent<DDZPlayerCtrl>().isShowDeck);
		}

	}

	private void close()
	{
		gameObject.transform.localScale = Vector3.zero;
	}
}
