using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public class DeskCardCtrl : MonoBehaviour {
	public delegate void DelayCallback();

	public DelayCallback delayCallback;
	public enum eDeskCardType{left, bottom, right}
	public eDeskCardType deskCardType;
    public GameObject deskcardpfb;
	public GameObject clearDeckTagPrb;
    public List<GameObject> Cards = new List<GameObject>();

	public List<JSONObject> cardsData;
	public List<JSONObject> preCardData;
	public int cardType = -1;
   	
	public string testStr;
	void Start(){
//		drawCards(new JSONObject(testStr).list);
	}

//	public List<GameObject> preCards = new List<GameObject>();
	public void drawCards(List<JSONObject> Cardlist, bool isObserver=false, int p_cardType = -1, bool isShowDeck = false, int cardCount=-1)
	{
		cardType = p_cardType;
		preCardData = cardsData;
		cardsData = Cardlist;
		foreach(GameObject cardObj in Cards){
			Destroy(cardObj);
		}
		Cards.Clear();
		if(Cardlist == null){
			return;
		}

		float leftEdge  = 0;
		if(deskCardType == eDeskCardType.bottom){
			int len = Cardlist.Count;
			if(len == 1){
				leftEdge = 0;
			}else{
				if(len%2 == 0){
					leftEdge = -40*(Cardlist.Count/2) + 20;
				}else{
					leftEdge = -40*(Cardlist.Count/2);
				}
			}

		}else if(deskCardType == eDeskCardType.left){
			leftEdge = 0;
		}else if(deskCardType == eDeskCardType.right){
			leftEdge = 0;
//			leftEdge = -40*Cardlist.Count + 40;

//			int offset = Cardlist.Count>9?9:Cardlist.Count; 
//			leftEdge = -40*offset + 40;
		}
		for(int i = 0; i < Cardlist.Count; i++)
		{
			GameObject cardObj = NGUITools.AddChild(this.gameObject, deskcardpfb);
			if(deskCardType == eDeskCardType.bottom){
				cardObj.GetComponent<Transform>().localPosition = new Vector3(leftEdge + i*40,0,0);
			}else if(deskCardType == eDeskCardType.left){
				cardObj.GetComponent<Transform>().localPosition = new Vector3(leftEdge + (i%9)*40, -55.0f*Mathf.Floor(i/9.0f), 0);
			}else if(deskCardType == eDeskCardType.right){
				cardObj.GetComponent<Transform>().localPosition = new Vector3(leftEdge -(i%9)*40, -55.0f*Mathf.Floor(i/9.0f), 0);
				cardObj.GetComponent<UISprite>().depth -=  (i - (int)Mathf.Floor(i/9.0f)*9);
			}
			Cards.Add(cardObj);
			Cards[i].GetComponent<UISprite>().spriteName = "card_" + Cardlist[i].ToString();
			if(isShowDeck){
				if(deskCardType == eDeskCardType.right){
					if(Mathf.Floor(Cardlist.Count/9.0f) == 0 || Mathf.Floor(Cardlist.Count/9.0f) == 1){
						if(i == 0){
							GameObject clearDeckObj = NGUITools.AddChild(cardObj, clearDeckTagPrb);
							clearDeckObj.transform.localPosition = new Vector3(20,42,0);
							clearDeckObj.transform.localScale = new Vector3(0.8f,0.8f,1);
						}
					}else{
						if(i == 9){
							GameObject clearDeckObj = NGUITools.AddChild(cardObj, clearDeckTagPrb);
							clearDeckObj.transform.localPosition = new Vector3(20,42,0);
							clearDeckObj.transform.localScale = new Vector3(0.8f,0.8f,1);
						}
					}

				}else{
					if(i == Cardlist.Count-1){
						GameObject clearDeckObj = NGUITools.AddChild(cardObj, clearDeckTagPrb);
						clearDeckObj.transform.localPosition = new Vector3(20,42,0);
						clearDeckObj.transform.localScale = new Vector3(0.8f,0.8f,1);
					}
				}
			}
		}
		if(cardType != -1){
			cardAnima(cardCount, isObserver);
		}
	}

	//ob= true call this function.
	public void offsetPos()
	{
		if(deskCardType == eDeskCardType.bottom){
			gameObject.transform.localPosition = new Vector3(0,177.0f,0);
		}else if(deskCardType == eDeskCardType.left){
			gameObject.transform.localPosition = new Vector3(397.0f,0,0);
		}else if(deskCardType == eDeskCardType.right){
			gameObject.transform.localPosition = new Vector3(-397.0f,0,0);
		}
	}

	public void drawCards2(List<JSONObject> Cardlist, bool isShowDeck){
		foreach(GameObject cardObj in Cards){
			Destroy(cardObj);
		}
		Cards.Clear();
		if(Cardlist == null){
			return;
		}
		float leftEdge  = 0;
		if(deskCardType == eDeskCardType.bottom){
			int len = Cardlist.Count;
			if(len == 1){
				leftEdge = 0;
			}else{
				if(len%2 == 0){
					leftEdge = -40*(Cardlist.Count/2) + 20;
				}else{
					leftEdge = -40*(Cardlist.Count/2);
				}
			}
			
		}else if(deskCardType == eDeskCardType.left){
			leftEdge = 0;
		}else if(deskCardType == eDeskCardType.right){
			leftEdge = 0;
//			int offset = Cardlist.Count>9?9:Cardlist.Count; 
//			leftEdge = -40*offset + 40;
		}
		for(int i = 0; i < Cardlist.Count; i++)
		{
			GameObject cardObj = NGUITools.AddChild(this.gameObject, deskcardpfb);
			if(deskCardType == eDeskCardType.bottom){
				cardObj.GetComponent<Transform>().localPosition = new Vector3(leftEdge + i*40,0,0);
				cardObj.GetComponent<UISprite>().depth = 35+i;
			}else if(deskCardType == eDeskCardType.left){
				cardObj.GetComponent<Transform>().localPosition = new Vector3(leftEdge + (i%9)*40, -55.0f*Mathf.Floor(i/9.0f), 0);
				cardObj.GetComponent<UISprite>().depth = 35+i;
			}else if(deskCardType == eDeskCardType.right){
				cardObj.GetComponent<Transform>().localPosition = new Vector3(leftEdge -(i%9)*40, -55.0f*Mathf.Floor(i/9.0f), 0);
				cardObj.GetComponent<UISprite>().depth = 35;
				cardObj.GetComponent<UISprite>().depth -=  (i - (int)Mathf.Floor(i/9.0f)*9);
			}
			Cards.Add(cardObj);
			cardObj.GetComponent<UISprite>().spriteName = "card_" + Cardlist[i].ToString();
			if(isShowDeck){
				if(deskCardType == eDeskCardType.right){
					if(Mathf.Floor(Cardlist.Count/9.0f) == 0 || Mathf.Floor(Cardlist.Count/9.0f) == 1){
						if(i == 0){
							GameObject clearDeckObj = NGUITools.AddChild(cardObj, clearDeckTagPrb);
							clearDeckObj.transform.localPosition = new Vector3(20,42,0);
							clearDeckObj.transform.localScale = new Vector3(0.8f,0.8f,1);
						}
					}else{
						if(i == 9){
							GameObject clearDeckObj = NGUITools.AddChild(cardObj, clearDeckTagPrb);
							clearDeckObj.transform.localPosition = new Vector3(20,42,0);
							clearDeckObj.transform.localScale = new Vector3(0.8f,0.8f,1);
						}
					}
					
				}else{
					if(i == Cardlist.Count-1){
						GameObject clearDeckObj = NGUITools.AddChild(cardObj, clearDeckTagPrb);
						clearDeckObj.transform.localPosition = new Vector3(20,42,0);
						clearDeckObj.transform.localScale = new Vector3(0.8f,0.8f,1);
					}
				}
			}
		}
	}

	public void pass()
	{
		preCardData = cardsData;
		cardsData = null;
		hideCurCards();
	}

	public void roundEnd()
	{
		preCardData = cardsData;
//		yield return new WaitForSeconds(1.5f);
		foreach(GameObject cardObj in Cards){
			Destroy(cardObj);
		}
		Cards.Clear();
	}

	public void hideCurCards()
	{
		foreach(GameObject cardObj in Cards){
			cardObj.SetActive(false);
		}
	}

	public bool hasPreCards{
		get{
			return preCardData != null;
		}
	}

//	public void showPreCards( DelayCallback delayCb )
//	{
//		foreach(GameObject cardObj in preCards){
//			cardObj.SetActive(true);
//		}
//		hideCurCards();
//		if(IsInvoking("hidePreCards")){
//			hidePreCards();
//			CancelInvoke("hidePreCards");
//		}else{
//			Invoke("hidePreCards", 3.0f);
//			delayCallback = delayCb;
//		}
//
//	}
//	public void hidePreCards()
//	{
//		foreach(GameObject cardObj in preCards){
//			cardObj.SetActive(false);
//		}
//		foreach(GameObject cardObj in Cards){
//			cardObj.SetActive(true);
//		}
//		if(delayCallback != null){
//			delayCallback();
//		}
//		delayCallback = null;
//	}

	public void clearCards()
	{
		List<GameObject> tempList = new List<GameObject>();
		for(int i=0; i< transform.childCount; i++){
			tempList.Add( transform.GetChild(i).gameObject);
		}
		for(int i=0; i< tempList.Count; i++){
			Destroy(tempList[i]);
		}
		tempList.Clear();
		preCardData = null;
//		preCards.Clear();
		Cards.Clear();
	}

	private void cardAnima(int cardCount, bool isObserver){
		if(isObserver){
			gameObject.transform.localScale = new Vector3(0.62f,0.62f,0.62f);
		}else{
			gameObject.transform.localScale = Vector3.one;
		}

		if(deskCardType == eDeskCardType.bottom){
			if(isObserver){
				gameObject.transform.localPosition = new Vector3(0,177.0f,0);
			}else{
				gameObject.transform.localPosition = new Vector3(0,245.0f,0);
			}
			iTween.MoveFrom(gameObject, iTween.Hash("y",gameObject.transform.localPosition.y-45, "time", 0.5f,"islocal", true));
			iTween.ScaleFrom(gameObject,iTween.Hash("scale",new Vector3(0.8f,1.2f,1),"time",0.6f ));
		}else if(deskCardType == eDeskCardType.left){
			if(isObserver){
				gameObject.transform.localPosition = new Vector3(397.0f,0,0);
			}else{
				if(cardCount<=2 && cardCount >0){
					gameObject.transform.localPosition = new Vector3(192.0f,0,0);
				}else{
					gameObject.transform.localPosition = new Vector3(135.0f,0,0);
				}
			}
			iTween.MoveFrom(gameObject, iTween.Hash("x",gameObject.transform.localPosition.x-45, "time", 0.5f,"islocal", true));
			iTween.ScaleFrom(gameObject,iTween.Hash("scale",new Vector3(1.2f,0.8f,1),"time",0.6f ));
		}else if(deskCardType == eDeskCardType.right){
			if(isObserver){
				gameObject.transform.localPosition = new Vector3(-397.0f,0,0);
			}else{
				if(cardCount<=2 && cardCount >0){
					gameObject.transform.localPosition = new Vector3(-191.0f,0,0);
				}else{
					gameObject.transform.localPosition = new Vector3(-134.0f,0,0);
				}
			}
			iTween.MoveFrom(gameObject, iTween.Hash("x",gameObject.transform.localPosition.x+45, "time", 0.5f,"islocal", true));
			iTween.ScaleFrom(gameObject,iTween.Hash("scale",new Vector3(1.2f,0.8f,1),"time",0.6f ));
		}

	}

}
