using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZTip {


//	public static List<JSONObject> _preCards;
	//Server side post this
	//单张0，对子1，三张2，三带单3，三带对4，单顺5，双顺6，飞机7，飞机带单8，飞机带双9，四带两单10，四带1对11, 炸弹12，火箭13
	public static List<GameObject> tip(List<GameObject> deck1, List<JSONObject> preCards = null, int cardType = -1, bool isCheck=false)
	{
		Debug.LogError("tip--------->");
		List<GameObject> deck = new List<GameObject>();
		for(int i=deck1.Count-1; i>=0; i--){
			deck.Add(deck1[i]);
		}
		//The sort was Min to Max if isCheck was true
		if(!isCheck){
//			if(_preCards != null){
//				preCards = _preCards;
//			}else{
//				if(preCards != null){
					List<JSONObject> sortHtoL = new List<JSONObject>();
					for(int i=preCards.Count-1; i>=0; i--){
						sortHtoL.Add(preCards[i]);
					}
					preCards = sortHtoL;
//				}
//			}
		}


//		List<GameObject> boomResult = new List<GameObject>();
//		if(cardType == 12){
//			boomResult = getAAAA(deck, preCards);
//		}else{
//			boomResult = getAAAA(deck, null);
//		}
//		for(int i=0; i< boomResult.Count; i++){
//			deck.Remove(boomResult[i]);
//		}
		List<GameObject> result = new List<GameObject>();
		if(cardType == 0){
			result = getSingle(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 1){
			result = getDouble(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 2){
			result = get3(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 3){
			result = get3with1(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 4){
			result = get3with2(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 5){
			result = getABCEF(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 6){
			result = getAABBCC(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 7){
			result = getAAABBB(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 8){
			result = getAAABBB_12(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 9){
			result = getAAABBB_NN(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 10){
			result = getAAAA_12(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 11){
			result = getAAAA_NN(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 12){
			result = getAAAA(deck, preCards);
//			_preCards = resultToJson(result);
		}else if(cardType == 13){
			result = get2King(deck);
//			_preCards = null;
		}else{
			Debug.LogError("???"+cardType);
			Debug.LogError("?????????");
			result = getSingle(deck, preCards);
		}

		if(cardType != 12 && cardType != 13){
			if(result.Count == 0){
				result = getAAAA(deck, null);
//				_preCards = null;
			}
		}

		if(cardType != 13){
			if(result.Count == 0){
				result = get2King(deck);
//				_preCards = null;
			}
		}

		if(isCheck){
//			_preCards = null;
		}
		return result;
//		if(result == null){
//			return boomResult;
//		}else{
//			return result;
//		}
	}

	public static List<GameObject> tip2(List<GameObject> deck1){
		List<GameObject> deck = new List<GameObject>();
		for(int i=deck1.Count-1; i>=0; i--){
			deck.Add(deck1[i]);
		}
		List<GameObject> result = new List<GameObject>();

		result = getAAABBB_NN(deck, null);
		if(result.Count == 0){
			result = getAAABBB_12(deck, null);
		}
		if(result.Count == 0){
			result = getAAABBB(deck, null);
		}
		if(result.Count == 0){
			result = getAABBCC(deck, null);
		}
		if(result.Count == 0){
			result = getABCEF(deck, null);
		}
		if(result.Count == 0){
			result = get3with2(deck, null);
		}
		if(result.Count == 0){
			result = get3with1(deck, null);
		}
		if(result.Count == 0){
			result = getAAAA(deck, null);
		}
		if(result.Count == 0){
			result = get3(deck, null);
		}
		if(result.Count == 0){
			result = getDouble(deck, null);
		}
//		if(result.Count == 0){
//			result = get2King(deck);
//		}
		if(result.Count == 0){
			result = getSingle(deck, null);
		}
		return result;
	}

	public static List<JSONObject> resultToJson(List<GameObject> result){
		List<JSONObject> jsonList = new List<JSONObject>();
		Debug.LogError("resultToJson-->");
		for(int i=0; i<result.Count; i++){
			Debug.LogError(result[i].GetComponent<DDZPlayercard>().pokerD.ToString());
			jsonList.Add(new JSONObject(result[i].GetComponent<DDZPlayercard>().pokerD.cardID));
		}
		if(jsonList.Count == 0){
			return null;
		}else{
			return jsonList;
		}
	}

	//单张0，对子1，三张2，三带单3，三带对4，单顺5，双顺6，飞机7，飞机带单8，飞机带双9，四带两单10，炸弹12，火箭13
	public static int isAllowType(List<GameObject> deck1){
		List<GameObject> deck = new List<GameObject>();
		for(int i=deck1.Count-1; i>=0; i--){
			deck.Add(deck1[i]);
		}
		if(isSingle(deck)){
			return 0;
		}else if( isDouble(deck)){
			return 1;
		}else if( is3(deck)){
			return 2;
		}else if( is4(deck) ){
			return 12;
		}else if(is3with1(deck)){
			return 3;
		}else if(is3with2(deck)){
			return 4;
		}else if(isABCDE(deck)){
			return 5;
		}else if(isAABBCC(deck)){
			return 6;
		}else if(isAAABBB(deck)){
			return 7;
		}else if(isAAABBB_12(deck)){
			return 8;
		}else if(isAAABBB_NN(deck)){
			return 9;
		}else if(isAAAA_12(deck)){
			return 10;
		}else if(isAAAA_NN(deck)){
			return 11;
		}else if(isRocket(deck)){
			return 13;
		}
		return -1;
	}

	public static List<JSONObject> sortCards(List<JSONObject> cards, int cardType)
	{
		List<DDZPokerData> data = new List<DDZPokerData>();
		List<JSONObject> result = new List<JSONObject>();
		for(int i=0; i<cards.Count; i++){
			data.Add(new DDZPokerData((int)cards[i].n));
		}
		int samePokeNum = -1;
		Dictionary<int , int> dc = new Dictionary<int, int>();
		int len = data.Count;
		if(cardType == 3 || cardType == 4){
			for(int i=0; i<len; i++){
				DDZPokerData pd = data[i];
				int key = (int)pd.pokerNum;
				if(!dc.ContainsKey(key)){
					dc[key] = 1;
				}else{
					int tempCount = dc[key];
					tempCount++;
					dc[key] = tempCount;
				}
			}
			foreach(int key in dc.Keys){
				if(dc[key] == 3){
					samePokeNum = key;
				}
			}
			for(int i=0; i< data.Count; i++){
				if((int)data[i].pokerNum == samePokeNum){
					result.Add(new JSONObject(data[i].cardID));
				}
			}
			return result;
		}else if(cardType == 10 || cardType == 11){
			for(int i=0; i<len; i++){
				DDZPokerData pd = data[i];
				int key = (int)pd.pokerNum;
				if(!dc.ContainsKey(key)){
					dc[key] = 1;
				}else{
					int tempCount = dc[key];
					tempCount++;
					dc[key] = tempCount;
				}
			}
			foreach(int key in dc.Keys){
				if(dc[key] == 4){
					samePokeNum = key;
				}
			}
			for(int i=0; i< data.Count; i++){
				if((int)data[i].pokerNum == samePokeNum){
					result.Add(new JSONObject(data[i].cardID));
				}
			}
			return result;
		}else if(cardType == 8 || cardType == 9){
			List<DDZPokerData> clonePD = new List<DDZPokerData>(data);
			for(int i=0; i<len; i++){
				DDZPokerData pd = data[i];
				int key = (int)pd.pokerNum;
				if(!dc.ContainsKey(key)){
					dc[key] = 1;
				}else{
					int tempCount = dc[key];
					tempCount++;
					dc[key] = tempCount;
				}
			}
			List<GameObject> singleList = new List<GameObject>();
			for(int i=0; i< len; i++){
				DDZPokerData pd = data[i];
				if(dc[(int)pd.pokerNum] != 3){
					clonePD.Remove(data[i]);
				}
			}
			result.Add(new JSONObject(clonePD[0].cardID));
			return result;
		}
		return cards;
	}

	public static List<JSONObject> sortCards(List<GameObject> cards, int cardType)
	{
		//单张0，对子1，三张2，三带单3，三带对4，单顺5，双顺6，飞机7，飞机带单8，飞机带双9，四带两单10，炸弹12，火箭13
		List<GameObject> result = new List<GameObject>();
		if(cardType == 10 || cardType == 11){
			result = getAAAA(cards);
		}else if(cardType == 8 || cardType == 9){
			result = getAAABBB(cards);
		}else if(cardType == 3 || cardType == 4){
			result = get3(cards);
		}
		for(int i=0; i< cards.Count; i++){
			if(!result.Contains(cards[i])){
				result.Add(cards[i]);
			}
		}
		List<JSONObject> resultJson = new List<JSONObject>();
		for(int i=0; i< result.Count; i++){
			resultJson.Add(new JSONObject(result[i].GetComponent<DDZPlayercard>().pokerD.cardID) );
		}
		return resultJson;
	}

	public static bool greaterThan(DDZPokerData card1, DDZPokerData card2, int cardType1, int cardType2){
		if( card2 == null){
			return true;
		}
		if(cardType2 == -1){
			return true;
		}
		if(cardType1 == 13){
			return true;
		}
		if(cardType2 == 13){
			return false;
		}
		if(cardType2 == 12 ){
			if(cardType1 == 12){
				return card1.pokerNum> card2.pokerNum;
			}else{
				return false;
			}
		}else{
			if(cardType1 == 12){
				return true;
			}else{
				if(cardType1 == cardType2){
					return card1.pokerNum> card2.pokerNum;
				}else{
					return false;
				}
			}
		}

	}

	public static List<GameObject> getSingle(List<GameObject> deck, List<JSONObject> preCards = null)
	{
		List<GameObject> result = new List<GameObject>();
		int minPokerNum = -1;
//		bool hasBoom = false;
//		bool has3    = false;
//		bool has2    = false;
		if(preCards != null){
			DDZPokerData pd = new DDZPokerData((int)preCards[0].n);
			printPreCards(preCards);
			minPokerNum = (int)pd.pokerNum;
		}
		int len = deck.Count;
		for(int i=0; i<len; i++){
			GameObject card = deck[i];
			if((int)card.GetComponent<DDZPlayercard>().pokerD.pokerNum > minPokerNum){
				DDZPokerData curPD = deck[i].GetComponent<DDZPlayercard>().pokerD;
				if(i + 3 < len){
					DDZPokerData temp1 = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
					DDZPokerData temp2 = deck[i+2].GetComponent<DDZPlayercard>().pokerD;
					DDZPokerData temp3 = deck[i+3].GetComponent<DDZPlayercard>().pokerD;
					if( curPD.pokerNum == temp1.pokerNum && curPD.pokerNum == temp2.pokerNum  && curPD.pokerNum == temp3.pokerNum){
						i += 3;
//						hasBoom = true;
						continue;
					}
				}
				if(i + 2 < len){
					DDZPokerData temp1 = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
					DDZPokerData temp2 = deck[i+2].GetComponent<DDZPlayercard>().pokerD;
					if( curPD.pokerNum == temp1.pokerNum && curPD.pokerNum == temp2.pokerNum){
						i += 2;
//						has3 = true;
						continue;
					}
				}
				if(i + 1< len){
					if( curPD.pokerNum == deck[i+1].GetComponent<DDZPlayercard>().pokerD.pokerNum){
						i++;
//						has2 = true;
						continue;
					}
				}
				result.Add(card);
				break;
			}
		}
		if(result.Count == 0){
//			if(hasBoom && !has3 && !has2){
//				return result;
//			}
			for(int i=0; i<len; i++){
				GameObject card = deck[i];
				if((int)card.GetComponent<DDZPlayercard>().pokerD.pokerNum > minPokerNum){
					DDZPokerData curPD = deck[i].GetComponent<DDZPlayercard>().pokerD;
					result.Add(card);
					break;
				}
			}
		}
		return result;
	}
	
	public static List<GameObject> getDouble(List<GameObject> deck, List<JSONObject> preCards = null)
	{
		List<GameObject> result = new List<GameObject>();
		int minPokerNum = -1;
		if(deck.Count< 2){
			return result;
		}
		if(preCards != null){
			DDZPokerData pd = new DDZPokerData((int)preCards[0].n);
			printPreCards(preCards);
			minPokerNum = (int)pd.pokerNum;
		}

		int len = deck.Count;
		for(int i=0; i<len; i++){
			DDZPokerData pokerD = deck[i].GetComponent<DDZPlayercard>().pokerD;
			if((int)pokerD.pokerNum <= minPokerNum){
				continue;
			}else{
				int backIndex = i + 1;
				if(backIndex < len){
					DDZPokerData backPokerD = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
					if( pokerD.pokerNum == backPokerD.pokerNum){
						result.Add(deck[i]);
						result.Add(deck[i+1]);
						break;
					}
				}
			}
		}
		return result;
	}

	public static List<GameObject> get3(List<GameObject> deck, List<JSONObject> preCards = null)
	{
		List<GameObject> result = new List<GameObject>();
		if(deck.Count< 3){
			return result;
		}
		int minPokerNum = -1;
		if(preCards != null){
			DDZPokerData pd = new DDZPokerData((int)preCards[0].n);
			printPreCards(preCards);
			minPokerNum = (int)pd.pokerNum;
		}
		
		int len = deck.Count;
		for(int i=0; i<len; i++){
			DDZPokerData pokerD = deck[i].GetComponent<DDZPlayercard>().pokerD;
			if((int)pokerD.pokerNum <= minPokerNum){
				continue;
			}else{
				int backIndex1 = i + 1;
				int backIndex2 = i + 2;
				if(backIndex2 < len){
					DDZPokerData backPokerD1 = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
					DDZPokerData backPokerD2 = deck[i+2].GetComponent<DDZPlayercard>().pokerD;
					if( pokerD.pokerNum == backPokerD1.pokerNum && pokerD.pokerNum == backPokerD2.pokerNum){
						result.Add(deck[i]);
						result.Add(deck[i+1]);
						result.Add(deck[i+2]);
						break;
					}
				}
			}
		}
		return result;
	}

	public static List<GameObject> get3with1(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		int minPokerNum = -1;
		if(deck.Count< 4){
			return result;
		}
		if(preCards != null){
			int sameCardID = -1;
			//get same card id
			for(int i=0; i< preCards.Count; i++){
				if(i+1< preCards.Count){
					if(preCards[i].n%13 == preCards[i+1].n%13){
						sameCardID = (int)preCards[i].n;
						break;
					}
				}
			}

			DDZPokerData pd = new DDZPokerData(sameCardID);
			printPreCards(preCards);
			minPokerNum = (int)pd.pokerNum;
		}
		
		int len = deck.Count;
		for(int i=0; i<len; i++){
			DDZPokerData pokerD = deck[i].GetComponent<DDZPlayercard>().pokerD;

			if((int)pokerD.pokerNum <= minPokerNum){
				continue;
			}else{
				int backIndex1 = i + 1;
				int backIndex2 = i + 2;
				if(backIndex2 < len){
					DDZPokerData backPokerD1 = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
					DDZPokerData backPokerD2 = deck[i+2].GetComponent<DDZPlayercard>().pokerD;
					if( pokerD.pokerNum == backPokerD1.pokerNum && pokerD.pokerNum == backPokerD2.pokerNum){
						result.Add(deck[i]);
						result.Add(deck[i+1]);
						result.Add(deck[i+2]);
						break;
					}
				}
			}
		}
		//3with1 choose the single 1
		if(result.Count == 3){
			//first choose a single 1 without pokerNum = 15,16,17(means 2, blackKing, RedKing)
			for(int i=0; i<len; i++){
				if(!result.Contains(deck[i])){
					//Dont choose a 2same, 3same or 4same.
					DDZPokerData curPD = deck[i].GetComponent<DDZPlayercard>().pokerD;
					if(i + 3 < len){
						DDZPokerData temp1 = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
						DDZPokerData temp2 = deck[i+2].GetComponent<DDZPlayercard>().pokerD;
						DDZPokerData temp3 = deck[i+3].GetComponent<DDZPlayercard>().pokerD;
						if( curPD.pokerNum == temp1.pokerNum && curPD.pokerNum == temp2.pokerNum  && curPD.pokerNum == temp3.pokerNum){
							i += 3;
							continue;
						}
					}
					if(i + 2 < len){
						DDZPokerData temp1 = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
						DDZPokerData temp2 = deck[i+2].GetComponent<DDZPlayercard>().pokerD;
						if( curPD.pokerNum == temp1.pokerNum && curPD.pokerNum == temp2.pokerNum){
							i += 2;
							continue;
						}
					}
					if(i + 1< len){
						if( curPD.pokerNum == deck[i+1].GetComponent<DDZPlayercard>().pokerD.pokerNum){
							i++;
							continue;
						}
					}
					if(curPD.pokerNum == DDZC.PokerNum.P2 || curPD.pokerNum == DDZC.PokerNum.小王  || curPD.pokerNum == DDZC.PokerNum.大王){
						continue;
					}
					result.Add(deck[i]);
					break;
				}
			}
			if(result.Count != 4){
				for(int i=0; i<len; i++){
					if(!result.Contains(deck[i])){
						result.Add(deck[i]);
						break;
					}
				}
			}

		}
		if(result.Count != 4){
			result.Clear();
		}
		return result;
	}

	public static List<GameObject> get3with2(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		if(deck.Count< 5){
			return result;
		}
		List<GameObject> cloneDeck = new List<GameObject>(deck);
		if(preCards != null){
			List<JSONObject> count1 = new List<JSONObject>();
			List<JSONObject> count2 = new List<JSONObject>();

			for(int i=0; i< preCards.Count; i++){
				if(count1.Count == 0){
					count1.Add(preCards[i]);
				}else{
					if(count1[0].n%13 == preCards[i].n%13){
						count1.Add(preCards[i]);
					}else{
						count2.Add(preCards[i]);
					}
				}
			}

			if(count1.Count == 3){
				result.AddRange(get3(deck, count1));
			}else if(count1.Count == 2){
				result.AddRange(getDouble(deck, null));
			}
			foreach(GameObject obj in result){
				cloneDeck.Remove(obj);
			}
			if(count2.Count == 3){
				result.AddRange(get3(cloneDeck, count2));
			}else if(count2.Count == 2){
				result.AddRange(getDouble(cloneDeck, null));
			}
		}else{
			result.AddRange(get3(deck, null));
			foreach(GameObject obj in result){
				cloneDeck.Remove(obj);
			}
			result.AddRange(getDouble(cloneDeck, null));
		}
		if(result.Count != 5){
			result.Clear();
		}
		return result;
	}

	public static List<GameObject> getABCEF(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		int cardLen = -1;
		int len = deck.Count;
		int minPokerNum = -1;
		if(preCards != null){
			if(deck.Count< preCards.Count){
				return result;
			}
			 DDZPokerData pd = new DDZPokerData((int)preCards[0].n);
			printPreCards(preCards);
			minPokerNum = (int)pd.pokerNum;
			cardLen = preCards.Count;
		}
		for(int i=0; i<len; i++){
			GameObject startCard = deck[i];
			if((int)startCard.GetComponent<DDZPlayercard>().pokerD.pokerNum > minPokerNum){
				DDZPokerData preCardD = startCard.GetComponent<DDZPlayercard>().pokerD;
				result.Add(startCard);
				for(int j=i; j<len; j++){
					DDZPokerData curCardD = deck[j].GetComponent<DDZPlayercard>().pokerD;
					if(curCardD.pokerNum == DDZC.PokerNum.P2 || curCardD.pokerNum == DDZC.PokerNum.大王 || curCardD.pokerNum == DDZC.PokerNum.小王){
						break;
					}
					if((int)curCardD.pokerNum - (int)preCardD.pokerNum == 1){
						result.Add(deck[j]);
						if(cardLen != -1){
							if(result.Count == cardLen){
								break;
							}
						}
					}else if((int)curCardD.pokerNum - (int)preCardD.pokerNum > 1){
						break;
					}
					preCardD = curCardD;
				}
				if(cardLen == -1){
					if(result.Count< 5){
						result.Clear();
					}else{
						break;
					}
				}else{
					if(result.Count < cardLen){
						result.Clear();
					}else{
						break;
					}
				}
			}
		}

		if(cardLen == -1){
			if(result.Count< 5){
				result.Clear();
			}
		}else{
			if(result.Count < cardLen){
				result.Clear();
			}
		}

		return result;
	}

	public static List<GameObject> getAABBCC(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		int cardLen = -1;
		int len = deck.Count;
		int minPokerNum = -1;
		if(preCards != null){
			if(deck.Count< preCards.Count){
				return result;
			}
			DDZPokerData pd = new DDZPokerData((int)preCards[0].n);
			printPreCards(preCards);
			minPokerNum = (int)pd.pokerNum;
			cardLen = preCards.Count;
		}
		for(int i=0; i<len; i++){
			GameObject startCard = deck[i];
			if((int)startCard.GetComponent<DDZPlayercard>().pokerD.pokerNum > minPokerNum){
				int tempMinPokerNum = (int)startCard.GetComponent<DDZPlayercard>().pokerD.pokerNum;
				for(int j=i; j<len; j++){
					if(j+1 <len){
						DDZPokerData curCardD = deck[j].GetComponent<DDZPlayercard>().pokerD;
						DDZPokerData nextCardD = deck[j+1].GetComponent<DDZPlayercard>().pokerD;
						if(tempMinPokerNum == (int)curCardD.pokerNum){
							if(curCardD.pokerNum == nextCardD.pokerNum && curCardD.pokerNum != DDZC.PokerNum.P2){
								result.Add(deck[j]);
								result.Add(deck[j+1]);
								if(cardLen != -1){
									if(result.Count == cardLen){
										break;
									}
								}
								j+=1;
								tempMinPokerNum++;
							}else{
								break;
							}
						}else{
							continue;
						}
					}
				}

				if(cardLen == -1){
					if(result.Count< 6){
						result.Clear();
					}else{
						break;
					}
				}else{
					if(result.Count < cardLen){
						result.Clear();
					}else{
						break;
					}
				}
			}
		}
		return result;
	}


	public static List<GameObject> getAAABBB(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		int cardLen = -1;
		int len = deck.Count;
		int minPokerNum = -1;
		if(preCards != null){
			if(deck.Count< preCards.Count){
				return result;
			}
			DDZPokerData pd = new DDZPokerData((int)preCards[0].n);
			printPreCards(preCards);
			minPokerNum = (int)pd.pokerNum;
			cardLen = preCards.Count;
		}
		for(int i=0; i<len; i++){
			GameObject startCard = deck[i];
			if((int)startCard.GetComponent<DDZPlayercard>().pokerD.pokerNum > minPokerNum){
				int tempMinPokerNum = (int)startCard.GetComponent<DDZPlayercard>().pokerD.pokerNum;
				for(int j=i; j<len; j++){
					if(j+2 <len){
						DDZPokerData curCardD = deck[j].GetComponent<DDZPlayercard>().pokerD;
						DDZPokerData nextCardD = deck[j+1].GetComponent<DDZPlayercard>().pokerD;
						DDZPokerData lastCardD = deck[j+2].GetComponent<DDZPlayercard>().pokerD;
						if(tempMinPokerNum == (int)curCardD.pokerNum){
							if(curCardD.pokerNum == nextCardD.pokerNum && curCardD.pokerNum == lastCardD.pokerNum && curCardD.pokerNum != DDZC.PokerNum.P2){
								result.Add(deck[j]);
								result.Add(deck[j+1]);
								result.Add(deck[j+2]);
								if(cardLen != -1){
									if(result.Count == cardLen){
										break;
									}
								}
								j+=2;
								tempMinPokerNum++;
							}else{
								break;
							}
						}else{
							break;
						}
					}
				}
				if(cardLen == -1){
					if(result.Count< 6){
						result.Clear();
					}else{
						break;
					}
				}else{
					if(result.Count < cardLen){
						result.Clear();
					}else{
						break;
					}
				}

			}
		}
		return result;
	}

	public static List<GameObject> getAAABBB_12(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		List<GameObject> cloneDeck = new List<GameObject>(deck);
		if(preCards != null){
			if(deck.Count< preCards.Count){
				return result;
			}
			List<JSONObject> cards3 = new List<JSONObject>();
			Dictionary<int, ArrayList> dc = new Dictionary<int, ArrayList>();
			for(int i=0; i< preCards.Count; i++){
				int key = (int)preCards[i].n%13;
				if( !dc.ContainsKey(key)){
					dc[key] = new ArrayList(){preCards[i], 0};
				}
				int count = (int)dc[key][1];
				count++;
				dc[key][1] = count;
				if(count == 3){
					cards3.Add(new JSONObject((int)preCards[i].n));
					cards3.Add(new JSONObject((int)preCards[i].n));
					cards3.Add(new JSONObject((int)preCards[i].n));
				}
			}

			result.AddRange( getAAABBB(deck, cards3) );
			foreach(GameObject obj in result){
				cloneDeck.Remove(obj);
			}

			foreach(int key in dc.Keys){
				Debug.LogError(dc[key][1]);
				if((int)dc[key][1] == 1){
					List<GameObject> tempSingle = getSingle(cloneDeck, null);
					result.AddRange(tempSingle);
					foreach(GameObject obj in tempSingle){
						cloneDeck.Remove(obj);
					}
				}
			}
			if(result.Count != preCards.Count){
				result.Clear();
			}
		}else{
			int singleCount = 0;
			result.AddRange( getAAABBB(deck, null) );
			singleCount = result.Count/3;
			foreach(GameObject obj in result){
				cloneDeck.Remove(obj);
			}
			for(int i=0; i< singleCount; i++){
				List<GameObject> tempSingle = getSingle(cloneDeck, null);
				result.AddRange(tempSingle);
				foreach(GameObject obj in tempSingle){
					cloneDeck.Remove(obj);
				}
			}
			if(result.Count != singleCount*3 + singleCount){
				result.Clear();
			}
		}
		return result;
	}

	public static List<GameObject> getAAABBB_NN(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		List<GameObject> cloneDeck = new List<GameObject>(deck);
		if(preCards != null){
			if(deck.Count< preCards.Count){
				return result;
			}
			List<JSONObject> cards3 = new List<JSONObject>();
			Dictionary<int, ArrayList> dc = new Dictionary<int, ArrayList>();
			for(int i=0; i< preCards.Count; i++){
				int key = (int)preCards[i].n%13;
				if( !dc.ContainsKey(key)){
					dc[key] = new ArrayList(){preCards[i], 0};
				}
				int count = (int)dc[key][1];
				count++;
				dc[key][1] = count;
				if(count == 3){
					cards3.Add(new JSONObject((int)preCards[i].n));
					cards3.Add(new JSONObject((int)preCards[i].n));
					cards3.Add(new JSONObject((int)preCards[i].n));
				}
			}
			
			result.AddRange( getAAABBB(deck, cards3) );
			foreach(GameObject obj in result){
				cloneDeck.Remove(obj);
			}
			
			foreach(int key in dc.Keys){
				Debug.LogError(dc[key][1]);
				if((int)dc[key][1] == 2){
					List<GameObject> tempSingle = getDouble(cloneDeck, null);
					result.AddRange(tempSingle);
					foreach(GameObject obj in tempSingle){
						cloneDeck.Remove(obj);
					}
				}
			}
			if(result.Count != preCards.Count){
				result.Clear();
			}
		}else{
			int singleCount = 0;
			result.AddRange( getAAABBB(deck, null) );
			singleCount = result.Count/3;
			foreach(GameObject obj in result){
				cloneDeck.Remove(obj);
			}
			for(int i=0; i< singleCount; i++){
				List<GameObject> tempSingle = getDouble(cloneDeck, null);
				result.AddRange(tempSingle);
				foreach(GameObject obj in tempSingle){
					cloneDeck.Remove(obj);
				}
			}
			if(result.Count != singleCount*3 + singleCount*2){
				result.Clear();
			}
		}
		return result;
	}

	public static List<GameObject> getAAAA_12(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		if(deck.Count < 6){
			return result;
		}
		List<GameObject> cloneDeck = new List<GameObject>(deck);

		if(preCards != null){
			List<JSONObject> cards4 = new List<JSONObject>();
			Dictionary<int, ArrayList> dc = new Dictionary<int, ArrayList>();
			for(int i=0; i< preCards.Count; i++){
				int key = (int)preCards[i].n%13;
				if( !dc.ContainsKey(key)){
					dc[key] = new ArrayList(){preCards[i], 0};
				}
				int count = (int)dc[key][1];
				count++;
				dc[key][1] = count;
				if(count == 4){
					cards4.Add(new JSONObject((int)preCards[i].n));
					cards4.Add(new JSONObject((int)preCards[i].n));
					cards4.Add(new JSONObject((int)preCards[i].n));
					cards4.Add(new JSONObject((int)preCards[i].n));
				}
			}
			result.AddRange( getAAAA(deck, cards4) );
		}else{
			result.AddRange(getAAAA(deck, null));
		}

		foreach(GameObject obj in result){
			cloneDeck.Remove(obj);
		}
		List<GameObject> single1 = getSingle(cloneDeck, null);
		if(single1.Count> 0){
			result.Add(single1[0]);
			cloneDeck.Remove(single1[0]);
		}
		List<GameObject> single2 = getSingle(cloneDeck, null);
		if(single2.Count> 0){
			if(single1[0].GetComponent<DDZPlayercard>().pokerD.pokerNum != single2[0].GetComponent<DDZPlayercard>().pokerD.pokerNum){
				result.Add(single2[0]);
				cloneDeck.Remove(single2[0]);
			}
		}

		if(result.Count != 6){
			result.Clear();
		}
		return result;
	}

	public static List<GameObject> getAAAA_NN(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		if(deck.Count < 6){
			return result;
		}
		List<GameObject> cloneDeck = new List<GameObject>(deck);
		
		if(preCards != null){
			List<JSONObject> cards4 = new List<JSONObject>();
			Dictionary<int, ArrayList> dc = new Dictionary<int, ArrayList>();
			for(int i=0; i< preCards.Count; i++){
				int key = (int)preCards[i].n%13;
				if( !dc.ContainsKey(key)){
					dc[key] = new ArrayList(){preCards[i], 0};
				}
				int count = (int)dc[key][1];
				count++;
				dc[key][1] = count;
				if(count == 4){
					cards4.Add(new JSONObject((int)preCards[i].n));
					cards4.Add(new JSONObject((int)preCards[i].n));
					cards4.Add(new JSONObject((int)preCards[i].n));
					cards4.Add(new JSONObject((int)preCards[i].n));
				}
			}
			result.AddRange( getAAAA(deck, cards4) );
		}else{
			result.AddRange(getAAAA(deck, null));
		}
		
		foreach(GameObject obj in result){
			cloneDeck.Remove(obj);
		}
		List<GameObject> doubleList = getDouble(cloneDeck, null);
		result.AddRange(doubleList);
		
		if(result.Count != 6){
			result.Clear();
		}
		return result;
	}


	public static List<GameObject> getAAAA(List<GameObject> deck, List<JSONObject> preCards = null){
		List<GameObject> result = new List<GameObject>();
		int minPokerNum = -1;
		if(deck.Count< 4){
			return result;
		}
		if(preCards != null){
			DDZPokerData pd = new DDZPokerData((int)preCards[0].n);
			printPreCards(preCards);
			minPokerNum = (int)pd.pokerNum;
		}
		
		int len = deck.Count;
		for(int i=0; i<len; i++){
			DDZPokerData pokerD = deck[i].GetComponent<DDZPlayercard>().pokerD;
			if((int)pokerD.pokerNum <= minPokerNum){
				continue;
			}else{
				int lastIndex = i + 3;
				if(lastIndex < len){
					DDZPokerData PokerD2 = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
					DDZPokerData PokerD3 = deck[i+2].GetComponent<DDZPlayercard>().pokerD;
					DDZPokerData PokerD4 = deck[i+3].GetComponent<DDZPlayercard>().pokerD;
					if( pokerD.pokerNum == PokerD2.pokerNum && pokerD.pokerNum == PokerD3.pokerNum && pokerD.pokerNum == PokerD4.pokerNum){
						result.Add(deck[i]);
						result.Add(deck[i+1]);
						result.Add(deck[i+2]);
						result.Add(deck[i+3]);
						break;
					}
				}
			}
		}
		return result;
	}

	public static List<GameObject> get2King(List<GameObject> deck)
	{
		List<GameObject> result = new List<GameObject>();
		int len = deck.Count;
		for(int i=0; i<len; i++){
			if(deck[i].GetComponent<DDZPlayercard>().pokerD.cardID == 53 || deck[i].GetComponent<DDZPlayercard>().pokerD.cardID == 52){
				result.Add(deck[i]);
			}
		}
		if(result.Count == 2){
			return result;
		}else{
			result.Clear();
			return result;
		}

	}

	public static bool isSingle(List<GameObject> deck)
	{
		return deck.Count == 1;
	}
	public static bool isDouble(List<GameObject> deck)
	{
		if(deck.Count != 2){
			return false;
		}
		if(deck[0].GetComponent<DDZPlayercard>().pokerD.pokerNum == deck[1].GetComponent<DDZPlayercard>().pokerD.pokerNum){
			return true;
		}else{
			return false;
		}
	}
	public static bool is3(List<GameObject> deck)
	{
		if(deck.Count != 3){
			return false;
		}
		DDZPokerData c1 = deck[0].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c2 = deck[1].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c3 = deck[2].GetComponent<DDZPlayercard>().pokerD;
		if(c1.pokerNum == c2.pokerNum && c2.pokerNum == c3.pokerNum){
			return true;
		}else{
			return false;
		}
	}
	public static bool is4(List<GameObject> deck)
	{
		if(deck.Count != 4){
			return false;
		}
		DDZPokerData c1 = deck[0].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c2 = deck[1].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c3 = deck[2].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c4 = deck[3].GetComponent<DDZPlayercard>().pokerD;
		if(c1.pokerNum == c2.pokerNum && c2.pokerNum == c3.pokerNum && c3.pokerNum == c4.pokerNum){
			return true;
		}else{
			return false;
		}
	}
	public static bool is3with1(List<GameObject> deck)
	{
		if(deck.Count != 4){
			return false;
		}
		DDZPokerData c1 = deck[0].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c2 = deck[1].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c3 = deck[2].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c4 = deck[3].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData[] pds = new DDZPokerData[]{c1,c2,c3,c4};
		Dictionary<int, int> dc = new Dictionary<int, int>();
		for(int i=0; i<pds.Length; i++){
			if(!dc.ContainsKey((int)pds[i].pokerNum)){
				dc[(int)pds[i].pokerNum] = 1;
			}else{
				int tempValue = dc[(int)pds[i].pokerNum];
				tempValue++;
				dc[(int)pds[i].pokerNum] = tempValue;
			}
		}
		foreach(int v1 in dc.Keys){
			if(dc[v1] == 3){
				return true;
			}
		}
		return false;
	}
	public static bool is3with2(List<GameObject> deck)
	{
		if(deck.Count != 5){
			return false;
		}
		DDZPokerData c1 = deck[0].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c2 = deck[1].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c3 = deck[2].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c4 = deck[3].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData c5 = deck[4].GetComponent<DDZPlayercard>().pokerD;
		DDZPokerData[] pds = new DDZPokerData[]{c1,c2,c3,c4,c5};
		Dictionary<int, int> dc = new Dictionary<int, int>();
		for(int i=0; i<pds.Length; i++){
			if(!dc.ContainsKey((int)pds[i].pokerNum)){
				dc[(int)pds[i].pokerNum] = 1;
			}else{
				int tempValue = dc[(int)pds[i].pokerNum];
				tempValue++;
				dc[(int)pds[i].pokerNum] = tempValue;
			}
		}
		int matchCount = 0;
		foreach(int v1 in dc.Keys){
			if(dc[v1] == 3){
				matchCount++;
			}
			if(dc[v1] == 2){
				matchCount++;
			}
		}
		if(matchCount == 2){
			return true;
		}else{
			return false;
		}
	}

	//单顺5，双顺6，飞机7，
	public static bool isABCDE(List<GameObject> deck)
	{
		if(deck.Count< 5){
			return false;
		}
		int len = deck.Count;
		for(int i=0; i<len; i++){
			if(i+1 < len){
				DDZPokerData curPd = deck[i].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData nextPd= deck[i+1].GetComponent<DDZPlayercard>().pokerD;
				if( (int)nextPd.pokerNum - (int)curPd.pokerNum != 1 ){
					return false;
				}
			}
		}
		return true;
	}
	public static bool isAABBCC(List<GameObject> deck)
	{
		if(deck.Count< 6){
			return false;
		}
		//2016.3.7
		if(deck.Count%2 != 0){
			return false;
		}
		int len = deck.Count;
		for(int i=0; i<len; i++){
			if(i+3 < len){
				DDZPokerData pd1 = deck[i].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData pd2= deck[i+1].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData pd3= deck[i+2].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData pd4= deck[i+3].GetComponent<DDZPlayercard>().pokerD;
				if(pd1.pokerNum == pd2.pokerNum && pd3.pokerNum == pd4.pokerNum){
					if( (int)pd3.pokerNum - (int)pd1.pokerNum != 1 ){
						return false;
					}
				}else{
					return false;
				}
				i++;
			}
		}
		return true;
	}
	public static bool isAAABBB(List<GameObject> deck)
	{
		if(deck.Count< 6){
			return false;
		}
		if(deck.Count%3 != 0)return false;
		int len = deck.Count;
		for(int i=0; i<len; i++){
			if(i+5 < len){
				DDZPokerData pd1 = deck[i].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData pd2 = deck[i+1].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData pd3 = deck[i+2].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData pd4 = deck[i+3].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData pd5 = deck[i+4].GetComponent<DDZPlayercard>().pokerD;
				DDZPokerData pd6 = deck[i+5].GetComponent<DDZPlayercard>().pokerD;
				if(pd1.pokerNum == pd2.pokerNum && pd1.pokerNum == pd3.pokerNum &&
				   pd4.pokerNum == pd5.pokerNum && pd4.pokerNum == pd6.pokerNum){
					if( (int)pd4.pokerNum - (int)pd1.pokerNum != 1 ){
						return false;
					}
				}else{
					return false;
				}
				i += 2;
			}
		}
		return true;
	}
	//飞机带单8，
	public static bool isAAABBB_12(List<GameObject> deck)
	{
		if(deck.Count< 8){
			return false;
		}
		List<GameObject> cloneDeck = new List<GameObject>(deck);
		Dictionary<int, int> dc = new Dictionary<int, int>();

		int len = deck.Count;
		for(int i=0; i<len; i++){
			DDZPokerData pd = deck[i].GetComponent<DDZPlayercard>().pokerD;
			int key = (int)pd.pokerNum;
			if(!dc.ContainsKey(key)){
				dc[key] = 1;
			}else{
				int tempCount = dc[key];
				tempCount++;
				dc[key] = tempCount;
			}
		}
		List<GameObject> singleList = new List<GameObject>();
		for(int i=0; i< len; i++){
			DDZPokerData pd = deck[i].GetComponent<DDZPlayercard>().pokerD;
			if(dc[(int)pd.pokerNum] != 3){
				cloneDeck.Remove(deck[i]);
				singleList.Add(deck[i]);
			}
		}
		bool isPlane = isAAABBB(cloneDeck);
		if(isPlane){
			if(singleList.Count == (int)(cloneDeck.Count/3)){
				for(int i=0; i< singleList.Count; i++){
					if(i+1< singleList.Count){
						if(singleList[i].GetComponent<DDZPlayercard>().pokerD.pokerNum == singleList[i+1].GetComponent<DDZPlayercard>().pokerD.pokerNum){
							return false;
						}
					}
				}
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	//飞机带双9，
	public static bool isAAABBB_NN(List<GameObject> deck)
	{
		if(deck.Count< 10){
			return false;
		}
		List<GameObject> cloneDeck = new List<GameObject>(deck);
		Dictionary<int, int> dc = new Dictionary<int, int>();
		
		int len = deck.Count;
		for(int i=0; i<len; i++){
			DDZPokerData pd = deck[i].GetComponent<DDZPlayercard>().pokerD;
			int key = (int)pd.pokerNum;
			if(!dc.ContainsKey(key)){
				dc[key] = 1;
			}else{
				int tempCount = dc[key];
				tempCount++;
				dc[key] = tempCount;
			}
		}
		List<GameObject> doubleList = new List<GameObject>();
		for(int i=0; i< len; i++){
			DDZPokerData pd = deck[i].GetComponent<DDZPlayercard>().pokerD;
			if(dc[(int)pd.pokerNum] != 3){
				cloneDeck.Remove(deck[i]);
				doubleList.Add(deck[i]);
			}
		}
		bool isPlane = isAAABBB(cloneDeck);
		if(isPlane){
			if(doubleList.Count == (int)(cloneDeck.Count/3)*2){
				for(int i=0; i< doubleList.Count; i++){
					if(i+1< doubleList.Count){
						if(doubleList[i].GetComponent<DDZPlayercard>().pokerD.pokerNum != doubleList[i+1].GetComponent<DDZPlayercard>().pokerD.pokerNum){
							return false;
						}
						i++;
					}
				}
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	//四带两单10
	public static bool isAAAA_12(List<GameObject> deck){
		if(deck.Count != 6){
			return false;
		}
		List<GameObject> cloneDeck = new List<GameObject>(deck);
		Dictionary<int, int> dc = new Dictionary<int, int>();
		
		int len = deck.Count;
		for(int i=0; i<len; i++){
			DDZPokerData pd = deck[i].GetComponent<DDZPlayercard>().pokerD;
			int key = (int)pd.pokerNum;
			if(!dc.ContainsKey(key)){
				dc[key] = 1;
			}else{
				int tempCount = dc[key];
				tempCount++;
				dc[key] = tempCount;
			}
		}
		List<GameObject> singleList = new List<GameObject>();
		for(int i=0; i< len; i++){
			DDZPokerData pd = deck[i].GetComponent<DDZPlayercard>().pokerD;
			if(dc[(int)pd.pokerNum] != 4){
				cloneDeck.Remove(deck[i]);
				singleList.Add(deck[i]);
			}
		}
		bool isBoom = is4(cloneDeck);
		if(isBoom){
			if(singleList.Count == 2){
				if( singleList[0].GetComponent<DDZPlayercard>().pokerD.pokerNum == singleList[1].GetComponent<DDZPlayercard>().pokerD.pokerNum){
					return false;
				}
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}

	//4 with double
	public static bool isAAAA_NN(List<GameObject> deck){
		if(deck.Count != 6){
			return false;
		}
		List<GameObject> cloneDeck = new List<GameObject>(deck);
		Dictionary<int, int> dc = new Dictionary<int, int>();
		
		int len = deck.Count;
		for(int i=0; i<len; i++){
			DDZPokerData pd = deck[i].GetComponent<DDZPlayercard>().pokerD;
			int key = (int)pd.pokerNum;
			if(!dc.ContainsKey(key)){
				dc[key] = 1;
			}else{
				int tempCount = dc[key];
				tempCount++;
				dc[key] = tempCount;
			}
		}
		List<GameObject> singleList = new List<GameObject>();
		for(int i=0; i< len; i++){
			DDZPokerData pd = deck[i].GetComponent<DDZPlayercard>().pokerD;
			if(dc[(int)pd.pokerNum] != 4){
				cloneDeck.Remove(deck[i]);
				singleList.Add(deck[i]);
			}
		}
		bool isBoom = is4(cloneDeck);
		if(isBoom){
			if(singleList.Count == 2){
				if( singleList[0].GetComponent<DDZPlayercard>().pokerD.pokerNum == singleList[1].GetComponent<DDZPlayercard>().pokerD.pokerNum){
					return true;
				}
				return false;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}

	//火箭13
	public static bool isRocket(List<GameObject> deck){
		if(deck.Count != 2){
			return false;
		}
		if(deck[0].GetComponent<DDZPlayercard>().pokerD.pokerNum == DDZC.PokerNum.小王 && deck[1].GetComponent<DDZPlayercard>().pokerD.pokerNum == DDZC.PokerNum.大王){
			return true;
		}else{
			return false;
		}
	}

	public static void printPreCards(List<JSONObject> preCards = null)
	{
		if(preCards != null){
			for(int i=0; i< preCards.Count; i++){
				DDZPokerData pd = new DDZPokerData((int)preCards[i].n);
				Debug.LogError(pd.ToString());
			}
		}
	}

}
