using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// card tip logic flash version.
/// </summary>
public class DDZTip2{

	public static List<List<GameObject>> tishiWrap(List<GameObject> cardlist, List<JSONObject> preCardData)
	{
		List<List<GameObject>> result = new List<List<GameObject>>();
		List<DDZPokerData> pdList = new List<DDZPokerData>();
		for(int i=0; i< cardlist.Count; i++){
			pdList.Add(new DDZPokerData(cardlist[i].GetComponent<DDZPlayercard>().pokerD.cardID));
		}
		List<DDZPokerData> preList = new List<DDZPokerData>();
		for(int i=0; i< preCardData.Count; i++){
			preList.Add(new DDZPokerData((int)preCardData[i].n));
		}
		List<int> typeArray = typePai(preList);
		List<List<DDZPokerData>> tipList = tishi(pdList, typeArray);
		if(tipList.Count == 0){
			return result;
		}
		//pick up gameObject
		for(int i=0; i< tipList.Count; i++){
			result.Add(new List<GameObject>());
			for(int j=0; j< tipList[i].Count; j++){
				DDZPokerData pd = tipList[i][j];
				for(int m=0; m< cardlist.Count; m++){
					if(cardlist[m].GetComponent<DDZPlayercard>().pokerD.cardID == pd.cardID){
						result[i].Add(cardlist[m]);
						break;
					}
				}
			}
		}
		return result;
	}

	public static List<List<DDZPokerData>> tishi(List<DDZPokerData> array, List<int> typeArray)
	{
		List<List<DDZPokerData>> turnArray = new List<List<DDZPokerData>>();
		List<List<DDZPokerData>> lArray    = new List<List<DDZPokerData>>();
		if(typeArray.Count >= 2){
			switch(typeArray[0]){
				case 0://单张
					lArray=lengthArray(array);
					turnArray.AddRange(checkValue(array,1,typeArray[1]));
					turnArray.AddRange(checkZhadan(array));
					if(turnArray.Count==0){
						turnArray.AddRange(checkLenValue(lArray,1,typeArray[1]));
					}
					break;
				case 1://对子
					lArray=lengthArray(array);
					turnArray.AddRange(checkValue(array,2,typeArray[1]));
					turnArray.AddRange(checkZhadan(array));
					if(turnArray.Count==0){
						turnArray.AddRange(checkLenValue(lArray,2,typeArray[1]));
					}
					break;
				case 2://三条
					lArray=lengthArray(array);
					turnArray.AddRange(checkValue(array,3,typeArray[1]));
					turnArray.AddRange(checkZhadan(array));
					break;
				case 3://三带一
					lArray=lengthArray(array);
					List<List<List<DDZPokerData>>> linArray = new List<List<List<DDZPokerData>>>();
					linArray.Add(new List<List<DDZPokerData>>());
					linArray.Add(new List<List<DDZPokerData>>());
					linArray[0]=checkValue(array,3,typeArray[1]);
					linArray[1]=checkValue(array,1,-1,false);
					if(linArray[0].Count>0 && linArray[1].Count>0){
						for(int i=0;i<linArray[0].Count;i++){
							//								var arrrr:Array=linArray[0].concat(linArray[1]);
							//								var tt:Array=typePai(arrrr);
							//								if(tt.length>=2 && tt[0]==typeArray[0] && tt[1]>typeArray[1]){
							linArray[0][i].AddRange(linArray[1][0]);
							turnArray.Add(linArray[0][i]);
							//								}
						}
					}
					turnArray.AddRange(checkZhadan(array));
					linArray[0].AddRange(checkLenValue(lArray,3,typeArray[1]));
					linArray[1].AddRange(checkLenValue(lArray,1,-1));
					if(linArray[0].Count>0 && linArray[1].Count>0){
						for(int i=0;i<linArray[0].Count;i++){
							if(linArray[1][0][0].flashValue != linArray[0][i][0].flashValue){
								linArray[0][i].AddRange(linArray[1][0]);
								turnArray.Add(linArray[0][i]);
							}else if(linArray[1].Count>=2){
								linArray[0][i].AddRange(linArray[1][1]);
								turnArray.Add(linArray[0][i]);
							}
						}
					}
					break;
				case 4://三带二
					lArray=lengthArray(array);
					linArray = new List<List<List<DDZPokerData>>>();
					linArray.Add(new List<List<DDZPokerData>>());
					linArray.Add(new List<List<DDZPokerData>>());
					linArray[0]=checkValue(array,3,typeArray[1]);
					linArray[1]=checkValue(array,2,-1);
					if(linArray[0].Count>0 && linArray[1].Count>0){
						for(int i=0;i<linArray[0].Count;i++){
							linArray[0][i].AddRange(linArray[1][0]);
							turnArray.Add(linArray[0][i]);
						}
					}
					turnArray.AddRange(checkZhadan(array));
					linArray[0].AddRange(checkLenValue(lArray,3,typeArray[1]));
					linArray[1].AddRange(checkLenValue(lArray,2,-1));
					if(linArray[0].Count>0 && linArray[1].Count>0){
						for(int i=0;i<linArray[0].Count;i++){
							if( linArray[1][0][0].flashValue!= linArray[0][i][0].flashValue ){
								linArray[0][i].AddRange(linArray[1][0]);
								turnArray.Add(linArray[0][i]);
							}else if(linArray[1].Count>=2){
								linArray[0][i].AddRange(linArray[1][1]);
								turnArray.Add(linArray[0][i]);
							}
						}
					}
					break;
				case 5://单顺
					turnArray=checkLinePai(array,typeArray,1);
					turnArray.AddRange(checkZhadan(array));
					break;
				case 6://双顺
					turnArray=checkLinePai(array,typeArray,2);
					turnArray.AddRange(checkZhadan(array));
					break;
				case 7://飞机
					turnArray=checkLinePai(array,typeArray,3);
					turnArray.AddRange(checkZhadan(array));
					break;
				case 8://飞机带单
					turnArray=checkLinePai(array,typeArray,3,1);
					turnArray.AddRange(checkZhadan(array));
					break;
				case 9://飞机带双
					turnArray=checkLinePai(array,typeArray,3,2);
					turnArray.AddRange(checkZhadan(array));
					break;
				case 10://四带二dan
					turnArray=checkLinePai(array,typeArray,4,1);
					turnArray.AddRange(checkZhadan(array));
					break;
				case 11://四带1对
//					turnArray=checkLinePai(array,typeArray,4,2);
//				 	turnArray.AddRange(checkZhadan(array));
					lArray=lengthArray(array);
					linArray = new List<List<List<DDZPokerData>>>();
					linArray.Add(new List<List<DDZPokerData>>());
					linArray.Add(new List<List<DDZPokerData>>());
					linArray[0]=checkValue(array,4,typeArray[1]);
					linArray[1]=checkValue(array,2,-1);
					if(linArray[0].Count>0 && linArray[1].Count>0){
						for(int i=0;i<linArray[0].Count;i++){
							linArray[0][i].AddRange(linArray[1][0]);
							turnArray.Add(linArray[0][i]);
						}
					}
					turnArray.AddRange(checkZhadan(array));
					linArray[0].AddRange(checkLenValue(lArray,4,typeArray[1]));
					linArray[1].AddRange(checkLenValue(lArray,2,-1));
					if(linArray[0].Count>0 && linArray[1].Count>0){
						for(int i=0;i<linArray[0].Count;i++){
							if( linArray[1][0][0].flashValue!= linArray[0][i][0].flashValue ){
								linArray[0][i].AddRange(linArray[1][0]);
								turnArray.Add(linArray[0][i]);
							}else if(linArray[1].Count>=2){
								linArray[0][i].AddRange(linArray[1][1]);
								turnArray.Add(linArray[0][i]);
							}
						}
					}
					break;
				case 12://炸弹
					turnArray=checkZhadan(array,typeArray[1]);
					break;
				case 13://火箭
					break;
				case 14://四带二对
					turnArray=checkLinePai(array,typeArray,4,2);
					turnArray.AddRange(checkZhadan(array));
					break;
			}
		}
		return turnArray;
	}
	
	private static List<List<DDZPokerData>> checkValue(List<DDZPokerData> array, int len, int _value, bool isRock = true){
		List<List<DDZPokerData>> lArray =addLineArray(array);
		List<List<DDZPokerData>> turnArray = new List<List<DDZPokerData>>();
		for(int i=0;i<lArray.Count;i++){
			if(lArray[i].Count>0 && (i+1)<lArray.Count && lArray[i+1].Count>0){//this will be fix array index out of range.
				if(len==1 && !isRock && lArray[i][0].flashValue==13 && lArray.Count==i+2 && lArray[i+1][0].flashValue==14){
					return turnArray;
				}
			}
			if(lArray[i].Count==len && lArray[i][0].flashValue>_value){
				turnArray.Add(lArray[i]);
			}
		}
		return turnArray;
	}

	/**
		 * 检查顺子及要带的牌
		 * @param lArray 原对位数组
		 */		
	private static List<List<DDZPokerData>> checkLinePai(List<DDZPokerData> array ,List<int> typeArray ,int leng ,int two=0)
	{
		List<List<DDZPokerData>> turnArray = new List<List<DDZPokerData>>();
		List<List<DDZPokerData>> lArray = addLineArray(array);
		int qi= typeArray[1];
		int len =0;
		
		if(leng==4){
			for(int s = typeArray[1]+1;s<13;s++){
				if(lArray[s].Count >= leng){
					turnArray.Add(lArray[s]);
				}
			}
		}else{
			for(int i =typeArray[1]+1;i<11;i++){
				if(i==qi+1){
					if(lArray[i].Count >= leng){
						len=1;
					}else{
						qi=i;
						len=0;
					}
				}
				//add && lArray[i].Count>0  flash not has this.
				if( lArray[i+1].Count >= leng && lArray[i].Count>0 && lArray[i][0].flashValue+1==lArray[i+1][0].flashValue ){
					len++;
					if(len==typeArray[2]){
						List<DDZPokerData> lll = new List<DDZPokerData>();
						for(int c=1;c<=len;c++){
							lll.AddRange( lArray[c+qi].GetRange(0,leng) );
						}
						turnArray.Add(lll);
						qi++;
						len--;
					}
				}else{
					qi=i;	
					len=0;
				}
			}
		}

		if(leng>=3 && two>0 && turnArray.Count>0){
			List<List<DDZPokerData>> newTurnArray = new List<List<DDZPokerData>>();
			List<List<DDZPokerData>> ll = new List<List<DDZPokerData>>();
			for(int f=0;f<15;f++){
				if(lArray[f].Count==two){
					ll.Add(lArray[f]);
				}
			}
			for(int t=0;t<13;t++){
				if(lArray[t].Count>two){
					ll.Add(lArray[t].GetRange(0,two));
				}
			}
			int le =typeArray[2];
			for(int h=0;h<turnArray.Count;h++){
				List<DDZPokerData> dan = new List<DDZPokerData>();
				for(int a=0;a<ll.Count;a++){
					int p=-1;
					for(int m=0;m<turnArray[h].Count;m++){
						if(ll[a][0].flashValue ==turnArray[h][m].flashValue){
							break;
						}
						if(m==turnArray[h].Count-1){
							p=ll[a][0].cardID;
						}
					}
					if(p!=-1){
						if(turnArray[h][0].flashValue!= flashValue(p)){
							dan.AddRange(ll[a]);
						}
						if(dan.Count==le*two){
							turnArray[h].AddRange(dan);
							newTurnArray.Add(turnArray[h]);
							break;
						}
					}
				}
			}
			return newTurnArray;
		}
		return turnArray;
	}

	private static List<List<DDZPokerData>> checkZhadan(List<DDZPokerData> array, int val=-1){
		List<List<DDZPokerData>> lArray = addLineArray(array);
		List<List<DDZPokerData>> turnArray = new List<List<DDZPokerData>>();
		for(int i=val+1;i<lArray.Count;i++){
			if(lArray[i].Count==4){
				turnArray.Add(lArray[i]);
			}
		}
		if(lArray[lArray.Count-2].Count > 0 && lArray[lArray.Count-1].Count > 0){
			if(lArray.Count>=2 && lArray[lArray.Count-2][0].flashValue==13 && lArray[lArray.Count-1][0].flashValue==14){
				List<DDZPokerData> resultList = new List<DDZPokerData>();
				resultList.Add(lArray[lArray.Count-2][0]);
				resultList.Add(lArray[lArray.Count-1][0]);
				turnArray.Add( resultList );
			}
		}
		return turnArray;
	}

	/// <summary>
	/// 检查大于len和大于_value的牌
	/// </summary>
	/// <returns>The length value.</returns>
	/// <param name="lArray">L array.</param>
	/// <param name="len">Length.</param>
	/// <param name="_value">_value.</param>
	private static List<List<DDZPokerData>> checkLenValue(List<List<DDZPokerData>> lArray, int len, int _value){
		List<List<DDZPokerData>> turnArray = new List<List<DDZPokerData>>();
		int lev = len;
		while(lev<4){
			for(int i=0;i<lArray.Count;i++){
				if(lArray[i].Count==(lev+1) && lArray[i][0].flashValue > _value){
					turnArray.Add( lArray[i].GetRange(0,len));
				}
			}
			lev++;
		}
		return turnArray;
	}

	//old = origin cards,  onew sub cards
	public static ArrayList delMingPai(ArrayList old, ArrayList onew){
		ArrayList arr = old;
		if(old.Count>0 && onew.Count>0){
			arr = new ArrayList();
			for(int i=0; i<old.Count; i++){
				if(onew.IndexOf(old[i]) == -1){
					arr.Add(old[i]);
				}
			}
		}
		return arr;
	}

	public static List<DDZPokerData> autoCheckPai(List<DDZPokerData> xuanArray){
		List<DDZPokerData> turnArray = new List<DDZPokerData>();
		List<List<DDZPokerData>> lArray = clearArrayNull(addLineArray(xuanArray));
		if(lArray.Count>1){
			int len = 4;
			for(int i=0; i<lArray.Count-1; i++){
				if(lArray[i].Count<len){
					len=lArray[i].Count;
				}
				if(lArray[i][0].flashValue+1!=lArray[i+1][0].flashValue || (lArray[i].Count==3 && lArray[i+1].Count==3) ){
					return xuanArray;
				}
			}

			if(lArray[lArray.Count-1].Count<len){
				len=lArray[lArray.Count-1].Count;//in flash version this was lArray[i] but in C# i is a local value in loop for.
			}
			Debug.LogError("len:"+len);
			if((len==1 && lArray.Count>=5) ||(len==2 && lArray.Count>=3) ||(len==3 && lArray.Count>=2)){
				for(int b=0; b<lArray.Count; b++){
					lArray[b].RemoveRange(0, lArray[b].Count - len);
//					lArray[b].RemoveRange(0, len);//I think the right way was (lArray[b].Count - len)
					turnArray.AddRange(lArray[b]);
				}
			}else{
				return xuanArray;
			}

		}else{
			return xuanArray;
		}

		for(int d =0; d< turnArray.Count; d++){
			if(turnArray[d] is List<DDZPokerData>){
				//No reason into this line in C#
				Debug.LogError("No reason into this line in C#");
//				turnArray[d] = turnArray[d][0];
			}
		}
		return turnArray;
	}

	public static List<DDZPokerData> paiXunArray(List<DDZPokerData> pArray, bool isSize=true){
		List<List<DDZPokerData>> array = new List<List<DDZPokerData>>();
		if(isSize){
			pArray.Sort(sortOnSize);
		}else{
			array= addLineArray(pArray);
			pArray= new List<DDZPokerData>();
			if(array[13].Count==1 && array[14].Count==1){
				pArray.AddRange(array[14]);
				pArray.AddRange(array[13]);
				array.RemoveRange(13, array.Count-13);
			}
			array.Sort(sortOnLengthMax);
			for(int i=0; i<array.Count; i++){
				if(array[i].Count>0){
					array[i].Sort(sortOnSize);//in flash version this was  sort(16|2)  means NUMERIC|DESCENDING
					pArray.AddRange(array[i]);
				}
			}
		}
		return pArray;
	}

	//looks like not used in flash version
	public static ArrayList autoTishi(List<DDZPokerData> xuanArray){
		ArrayList turnArray = new ArrayList();
		return turnArray;
	}

	/// <summary>
	/// check card type
	/// </summary>
	/// <returns>[cardtype, flashValue, count]</returns>
	/// <param name="array">List<DDZPokerData></param>
	public static List<int> typePai(List<DDZPokerData> array)
	{
		List<int> turnArray = new List<int>();
		List<List<DDZPokerData>> lArray = new List<List<DDZPokerData>>();
		if(array.Count>0){
			switch(array.Count){
			case 1:
				turnArray = new List<int>(){0, array[0].flashValue, 1};//单张
				break;
			case 2:
				if(array[0].flashValue ==array[1].flashValue){
					turnArray = new List<int>(){1, array[0].flashValue, 1};//对子
				}else if(array[0].flashValue>12 && array[1].flashValue>12){
					turnArray = new List<int>(){13, array[0].flashValue, 1};//火箭
				}
				break;
			case 3:
				if( array[0].flashValue ==array[1].flashValue && array[1].flashValue ==array[2].flashValue ){
					turnArray = new List<int>(){2, array[0].flashValue, 1};//三条
				}
				break;
			case 4:
				if(array[0].flashValue == array[1].flashValue && array[1].flashValue == array[2].flashValue && array[2].flashValue== array[3].flashValue){
					turnArray = new List<int>(){12, array[0].flashValue, 1};//炸弹
				}else{
					lArray=lengthArray(array);
					if(lArray[0].Count == 3){
						turnArray = new List<int>(){3, lArray[0][0].flashValue, 1};//三带一
					}
				}
				break;
			case 5:
				lArray=lengthArray(array);
				if(lArray[0].Count==3 && lArray[1].Count == 2){
					turnArray = new List<int>(){4, lArray[0][0].flashValue, 1};//三带二
				}else if(lArray[0].Count==1 && checkLine(lArray)){
					turnArray = new List<int>(){5, lArray[0][0].flashValue, 5};//单顺
				}
				break;
			case 6:
				lArray=lengthArray(array);
				if(lArray[0].Count==4 && lArray[1].Count==2 ){
					turnArray = new List<int>(){11, lArray[0][0].flashValue, 1};//四带1对
				}else if(lArray[0].Count==4 && lArray[1].Count==1 && lArray[2].Count==1){
					turnArray = new List<int>(){10, lArray[0][0].flashValue, 2};//四带二
				}else if(lArray[0].Count==3 && lArray[1].Count==3 && checkLine(lArray)){
					turnArray = new List<int>(){7, lArray[0][0].flashValue, 2};//飞机
				}else if(lArray[0].Count==2 && lArray[2].Count==2 && checkLine(lArray)){
					turnArray = new List<int>(){6, lArray[0][0].flashValue, 3};//双顺
				}else if(lArray[0].Count==1 && checkLine(lArray)){
					turnArray = new List<int>(){5, lArray[0][0].flashValue, 6};//单顺
				}
				break;
			case 7:
				lArray=lengthArray(array);
				if(lArray[0].Count==1 && checkLine(lArray)){
					turnArray = new List<int>(){5, lArray[0][0].flashValue, 7};//单顺
				}
				break;
			case 8:
				lArray=lengthArray(array);
				if(lArray[0].Count==4 && lArray[1].Count==2 && lArray[2].Count==2){
					turnArray = new List<int>(){14, lArray[0][0].flashValue, 2};//四带二对
				}else if(lArray[0].Count==3 && lArray[1].Count==3 && lArray[2].Count==1 && checkLine(lArray.GetRange(0,2))){
					turnArray = new List<int>(){8, lArray[0][0].flashValue, 2};//飞机带单
				}else if(lArray[0].Count==2 && lArray[3].Count==2 && checkLine(lArray)){
					turnArray = new List<int>(){6, lArray[0][0].flashValue, 4};//双顺
				}else if(lArray[0].Count==1 && checkLine(lArray)){
					turnArray = new List<int>(){5, lArray[0][0].flashValue, 8};//单顺
				}
				break;
			case 9:
				lArray=lengthArray(array);
				if(lArray[0].Count==3 && lArray[1].Count==3 && lArray[2].Count==3 && checkLine(lArray)){
					turnArray = new List<int>(){7, lArray[0][0].flashValue, 3};//三飞机
				}else if(lArray[0].Count==1 && checkLine(lArray)){
					turnArray = new List<int>(){5, lArray[0][0].flashValue, 9};//单顺
				}
				break;
			case 10:
				lArray=lengthArray(array);
				if(lArray[0].Count==3 && lArray[1].Count==3 && lArray[2].Count==2 && lArray[3].Count==2 && checkLine(lArray.GetRange(0,2))){
					turnArray = new List<int>(){9, lArray[0][0].flashValue, 2};//飞机带双
				}else if(lArray[0].Count==2 && lArray[4].Count==2 && checkLine(lArray)){
					turnArray = new List<int>(){6, lArray[0][0].flashValue, 5};//双顺
				}else if(lArray[0].Count==1 && checkLine(lArray)){
					turnArray = new List<int>(){5, lArray[0][0].flashValue, 10};//单顺
				}
				break;
			case 11:
				lArray=lengthArray(array);
				if(lArray[0].Count==1 && checkLine(lArray)){
					turnArray = new List<int>(){5, lArray[0][0].flashValue, 11};//单顺
				}
				break;
			case 12:
				lArray=lengthArray(array);
				if(lArray[0].Count==3 && lArray[1].Count==3 && lArray[2].Count==3){ 
					if(lArray[3].Count==3 && checkLine(lArray)){
						turnArray = new List<int>(){7, lArray[0][0].flashValue, 4};//四飞机
					}else if(lArray[3].Count==1 && lArray[4].Count==1 && checkLine(lArray.GetRange(0,3))){
						turnArray = new List<int>(){8, lArray[0][0].flashValue, 3};//三飞机带单
					}
				}else if(lArray[0].Count==2 && lArray[5].Count==2 && checkLine(lArray)){
					turnArray = new List<int>(){6, lArray[0][0].flashValue, 6};//双顺
				}else if(lArray[0].Count==1 && checkLine(lArray)){
					turnArray = new List<int>(){5, lArray[0][0].flashValue, 12};//单顺
				}
				break;
			case 14:
				lArray=lengthArray(array);
				if(lArray[0].Count==2 && lArray[6].Count==2 && checkLine(lArray)){
					turnArray = new List<int>(){6, lArray[0][0].flashValue, 7};//双顺
				}
				break;
			case 15:
				lArray=lengthArray(array);
				if(lArray[0].Count==3 && lArray[2].Count==3){ 
					if(lArray[4].Count==3 && checkLine(lArray)){
						turnArray = new List<int>(){7, lArray[0][0].flashValue, 5};//五飞机
					}else if(lArray[3].Count==2 && lArray[5].Count==2 && checkLine(lArray.GetRange(0,3))){
						turnArray = new List<int>(){9, lArray[0][0].flashValue, 3};//三飞机带双
					}
				}
				break;
			case 16:
				lArray=lengthArray(array);
				if(lArray[0].Count==3 && lArray[3].Count==3 && lArray[4].Count==1 && checkLine(lArray.GetRange(0,4))){ 
					turnArray = new List<int>(){8, lArray[0][0].flashValue, 4};//四飞机带单
				}else if(lArray[0].Count==2 && lArray[7].Count==2 && checkLine(lArray)){
					turnArray = new List<int>(){6, lArray[0][0].flashValue, 8};//双顺
				}
				break;
			case 18:
				lArray=lengthArray(array);
				if(lArray[0].Count==3 && lArray[5].Count==3 && checkLine(lArray)){ 
					turnArray = new List<int>(){7, lArray[0][0].flashValue, 6};//六飞机
				}else if(lArray[0].Count==2 && lArray[8].Count==2 && checkLine(lArray)){
					turnArray = new List<int>(){6, lArray[0][0].flashValue, 9};//双顺
				}
				break;
			case 20:
				lArray=lengthArray(array);
				if(lArray[0].Count==3 && lArray[3].Count==3){
					if(lArray[4].Count==3 && lArray[5].Count==1 && checkLine(lArray.GetRange(0,5))){
						turnArray = new List<int>(){8, lArray[0][0].flashValue, 5};//五飞机带单
					}else if(lArray[4].Count==2 && lArray[7].Count==2 && checkLine(lArray.GetRange(0,4))){
						turnArray = new List<int>(){9, lArray[0][0].flashValue, 4};//四飞机带双
					}
				}else if(lArray[0].Count==2 && lArray[9].Count==2 && checkLine(lArray)){
					turnArray = new List<int>(){6, lArray[0][0].flashValue, 10};//双顺
				}
				break;
			}
		}
		return turnArray;
	}

	public static bool isCheckChu(List<int> myArray, List<int> preArray = null){
		//myArray = [cardtype, flashValue, count] ((if shun count = shun pai list.Count.
		if(myArray != null && myArray.Count >=2){
			if(preArray != null && preArray.Count >=2){
				if(myArray[0]<12 && myArray[0]==preArray[0] && myArray[1]>preArray[1]){
					if(myArray[0] >=5 && myArray[0]<=9){
						if(myArray[2] == preArray[2]){
							return true;
						}else{
							return false;
						}
					}else{
						return true;
					}
				}else if(myArray[0] >=12 && preArray[0] < 12){
					return true;
				}else if(myArray[0]>=12 && preArray[0] >= 12){
					if(myArray[0] == 13){
						return true;
					}else if(myArray[0] == preArray[0] && myArray[1] > preArray[1]){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}
		}else{
			return false;
		}
		return false;
	}

	//list1 equal list2 ????
	public static bool isDeng(List<DDZPokerData> list1, List<DDZPokerData> list2){
		if(list1.Count>0 && list2.Count>0 && list1.Count == list2.Count){
			for(int i=0; i<list1.Count; i++){
				if(list2.IndexOf(list1[i]) == -1){
					return false;
				}
			}
			for(int i=0; i<list2.Count; i++){
				if(list1.IndexOf(list2[i]) == -1){
					return false;
				}
			}
		}else{
			return false;
		}
		return true;
	}

	//check is shun
	public static bool checkLine(List<List<DDZPokerData>> array){
		for(int i=0; i< array.Count-1; i++){
			if(array[i][0].flashValue + 1 != array[i+1][0].flashValue){
				return false;
			}
		}
		if(array[array.Count-1][0].flashValue == 12){
			return false;
		}
		return true;
	}

	public static int flashValue(int num){
		if(num<54){
			if(num == 52){
				return 13;
			}else if(num == 53){
				return 14;
			}else if(num < 52){
				return num%13;
			}
		}
		return -1;
	}

	//max to min
	public static int sortOnLengthMax(List<DDZPokerData> listA, List<DDZPokerData> listB){
		if(listA.Count> listB.Count){
			return -1;
		}else if(listA.Count< listB.Count){
			return 1;
		}else{
			if(listA[0].flashValue > listB[0].flashValue){
				return -1;
			}else if(listA[0].flashValue < listB[0].flashValue){
				return 1;
			}
			return 0;
		}
	}

	//min to max
	public static int sortOnLengthMin(List<DDZPokerData> listA, List<DDZPokerData> listB){
		if(listA.Count> listB.Count){
			return -1;
		}else if(listA.Count< listB.Count){
			return 1;
		}else{
			if(listA[0].flashValue > listB[0].flashValue){
				return 1;
			}else if(listA[0].flashValue < listB[0].flashValue){
				return -1;
			}
			return 0;
		}
	}

	//max to min
	public static int sortOnSize(DDZPokerData pdA, DDZPokerData pdB){
		if(pdA.flashValue > pdB.flashValue){
			return -1;
		}else if(pdA.flashValue < pdB.flashValue){
			return 1;
		}else{
			if(pdA.flashValue > pdB.flashValue){
				return -1;
			}else if(pdA.flashValue < pdB.flashValue){
				return 1;
			}
			return 0;
		}
	}

	public static List<List<DDZPokerData>> lengthArray(List<DDZPokerData> array){
		List<List<DDZPokerData>> result = clearArrayNull(addLineArray(array));
		result.Sort(sortOnLengthMin);
		return result;
	}

	public static List<List<DDZPokerData>> clearArrayNull(List<List<DDZPokerData>> array){
		if(array.Count> 0){
			for( int i=array.Count-1; i>=0; i--){
				if(array[i] == null || array[i].Count == 0){
					array.RemoveAt(i);
				}
			}
		}
		return array;
	}

	public static List<List<DDZPokerData>> addLineArray(List<DDZPokerData> array){
		List<List<DDZPokerData>> lineArray = new List<List<DDZPokerData>>();
		for( int i=0; i<15; i++){
			lineArray.Add( new List<DDZPokerData>());
		}
		for(int i=0; i< array.Count; i++){
			lineArray[ array[i].flashValue ] .Add(array[i]);
		}
		return lineArray;
	}
}
