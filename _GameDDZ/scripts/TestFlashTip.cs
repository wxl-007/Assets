using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TestFlashTip : MonoBehaviour {

	public string[] testStr;
	public int useIndex;

	private List<DDZPokerData> originList = new List<DDZPokerData>();

	// Use this for initialization
	void Start () {
		JSONObject jsonObj = new JSONObject("["+testStr[useIndex]+"]");
		for(int i=0; i<jsonObj.Count; i++){
			DDZPokerData pd = new DDZPokerData((int)jsonObj.list[i].n);
			originList.Add(pd);
		}
		List<List<DDZPokerData>> result = DDZTip2.addLineArray(originList);
		printList(result);
		result = DDZTip2.clearArrayNull(result);
		printList(result);
		result = DDZTip2.lengthArray(originList);
		printList(result);

		List<DDZPokerData> list3 = DDZTip2.autoCheckPai(originList);
		printList(list3);

		result = DDZTip2.tishi(originList, new List<int>(){11, 0, 1});
		printList(result);

//		List<int> ss = new List<int>(){1,2,3,4};
//		List<int> ss2 = new List<int>(){1,2,3,4};
//		ss.RemoveRange(0,4);
//		Debug.Log(ss.Count);
//		ss2.AddRange(ss);
//		Debug.Log(ss2.Count);
//		Debug.Log( DDZTip2.isCheckChu(new List<int>(){1,8,1},new List<int>(){1,7,1}) );
//		List<DDZPokerData> list3 = originList.GetRange(0,5);
//		printList(list3);
//		List<int> sss1 = DDZTip2.typePai(originList.GetRange(0,5));
//		Debug.Log(sss1[0] + "  "+ sss1[1] +"  "+ sss1[2]);
	}
	
	private void printList(List<List<DDZPokerData>> list)
	{
		string str = "";
		for(int i=0; i< list.Count; i++){
			str += ("["+i +"]=");
			for(int m=0; m< list[i].Count; m++){
				str += list[i][m].ToString() +", ";
			}
			str += "\n";
		}
		Debug.Log(str);
	}

	private void printList(List<DDZPokerData> list){
		string str = "";
		for(int m=0; m< list.Count; m++){
			str += list[m].ToString() +", ";
		}
		str += "\n";
		Debug.Log(str);
	}
}
