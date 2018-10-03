using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DragToSelCards : MonoBehaviour {

	public GameDDZ ddzMain;
	public DDZPlayerCtrl playCtrl;
	private List<GameObject> deck;
	private List<GameObject> selCards;
	private int len;
	private bool isDown=false;
	private bool isMove = false;
	private float tapX = 0;
	// Use this for initialization

	void Start () {
//		Invoke("init",2.0f);
	}

	// Update is called once per frame
	void Update () {
		if(ddzMain.isObserver)return;
		if(ddzMain.btnGroup.isManaged)return;
		if(Input.GetMouseButtonDown(0)){
			tapX = Input.mousePosition.x;
			Vector3 vc3 = Camera.main.ScreenToWorldPoint(Input.mousePosition);
			RaycastHit hit;
			if( Physics.Raycast(vc3,Vector3.forward,out hit)){
//				Debug.LogError("---->"+hit.collider.gameObject.name);
				if(hit.collider.gameObject.transform.parent == this.transform){
					Debug.LogError(hit.collider.gameObject.name);
					startX = hit.collider.bounds.min.x;
					startCard = hit.collider.gameObject;
//					Debug.LogError("===>"+startX);
					hit.collider.gameObject.GetComponent<DDZPlayercard>().preSelectCard();
					isDown = true;
				}
			}
		}else if(Input.GetMouseButtonUp(0)){
			isDown = false;
			if(isMove){
				Debug.Log("isDown = false");
				selCards = new List<GameObject>();
				List<DDZPokerData> pdList = new List<DDZPokerData>();
				for(int i=0; i< len; i++){
					if(deck[i] !=  null){
						DDZPlayercard tempCard = deck[i].GetComponent<DDZPlayercard>();
						if(tempCard._preSel){
							selCards.Add(deck[i]);
							pdList.Add( new DDZPokerData(tempCard.pokerD.cardID));

							tempCard.clearPreSelectCard();
						}
					}
				}

				List<DDZPokerData> result  = DDZTip2.autoCheckPai( pdList );
				for(int i=0; i< result.Count; i++){
					DDZPokerData pd = result[i];
					for(int m=0; m< selCards.Count; m++){
						if(selCards[m].GetComponent<DDZPlayercard>().pokerD.cardID == pd.cardID){
							selCards[m].GetComponent<DDZPlayercard>().toggleWithoutCheck();
							break;
						}
					}
				}
				if(result.Count>0){
					playCtrl.selCardHandle();
				}

				if(ddzMain.isLiveRoom){
					playCtrl.sendSelectCardToServer();
				}

//				if( DDZTip.tip(selCards, null, 5).Count != 0){
//					DDZTip._preCards = null;
//					ddzMain.dragToSelTip(selCards);
//				}else if(DDZTip.tip(selCards, null, 6).Count != 0){
//					DDZTip._preCards = null;
//					ddzMain.dragToSelTip(selCards);
//				}else{
//					for(int i=0; i< selCards.Count; i++){
//						selCards[i].GetComponent<DDZPlayercard>().toggleWithoutCheck();
//					}
//					playCtrl.selCardHandle();
//				}


//				if(ddzMain.beginplay && !ddzMain.isMyRoot){
//					for(int i=0; i< len; i++){
//						if(deck[i] !=  null){
//							DDZPlayercard tempCard = deck[i].GetComponent<DDZPlayercard>();
//							if(tempCard._preSel || tempCard.isSelected){
//								selCards.Add(deck[i]);
//								tempCard.clearPreSelectCard();
//							}
//						}
//					}
//					if(selCards.Count> 0){
//						ddzMain.dragToSelTip(selCards);
//					}
//				}else{
//					for(int i=0; i< len; i++){
//						if(deck[i] !=  null){
//							DDZPlayercard tempCard = deck[i].GetComponent<DDZPlayercard>();
//							if(tempCard._preSel){
//								selCards.Add(deck[i]);
//								tempCard.clearPreSelectCard();
//							}
//						}
//					}
//					if(ddzMain.isInBattle){
//						for(int i=0; i< selCards.Count; i++){
//							selCards[i].GetComponent<DDZPlayercard>().Buttonc();
//						}
//					}
//				}

			}
			isMove = false;
		}
		if(isDown){
			if(!isMove){
				if(Mathf.Abs(Input.mousePosition.x - tapX)> 10){
					isMove = true;
				}
			}
			if(isMove){
				Vector3 vc3 = Camera.main.ScreenToWorldPoint(Input.mousePosition);
				rangeSelect(vc3.x);
//				RaycastHit hit;
//				if( Physics.Raycast(vc3,Vector3.forward,out hit)){
//					if(hit.collider.gameObject.transform.parent == this.transform){
//						hit.collider.gameObject.GetComponent<DDZPlayercard>().preSelectCard();
//					}
//				}
			}

		}
	}

	private float startX;
	private GameObject startCard;
	private void rangeSelect(float nowX)
	{
		bool isR = (nowX - startX > 0);
		if(!isR){
			//0.41666   pading 60    0.48611 pading 70
			if(playCtrl.isBanker){
				nowX = nowX - startCard.GetComponent<BoxCollider>().bounds.size.x* 0.41666f;
			}else{
				nowX = nowX - startCard.GetComponent<BoxCollider>().bounds.size.x* 0.48611f;
			}
		}
		for(int i=0; i< len; i++){
			if(deck[i] !=  null && deck[i] != startCard){
				float posX = deck[i].GetComponent<BoxCollider>().bounds.min.x;
				if(isR){
					if(posX> startX && posX< nowX){
						deck[i].GetComponent<DDZPlayercard>().preSelectCard();
					}else{
						deck[i].GetComponent<DDZPlayercard>().clearPreSelectCard();
					}
				}else{
					if(posX> nowX && posX< startX){
						deck[i].GetComponent<DDZPlayercard>().preSelectCard();
					}else{
						deck[i].GetComponent<DDZPlayercard>().clearPreSelectCard();
					}
				}
			}
		}
	}

	public void init()
	{
		deck = new List<GameObject>();
		selCards = new List<GameObject>();
		for(int i=0; i< transform.childCount; i++){
			deck.Add(transform.GetChild(i).gameObject);
		}
		len = deck.Count;
	}
	public void insertBankerCards(GameObject obj, int index)
	{
		deck.Insert(index,obj);
		len = deck.Count;
	}
}
