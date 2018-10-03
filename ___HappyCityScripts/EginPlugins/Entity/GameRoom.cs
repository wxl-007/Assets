using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class GameRoom {
	
	public string roomId;
	public string host;
	public string port;
	public string dbname;
	public bool fixseat = true;
	
	public string tagTitle;
	public string title;
	public string minMoney;
	public string maxMoney;
	public string onlineNum;
	public string maxOnline;

	//add 2016.4.5 
	public int entry_fee=0;

    //add 2016.07.05
    public string roomType;
    //510k
    public string roomname;

    public GameRoom(Dictionary<string, string> dict) {
//		foreach( string key in dict.Keys){
//			Debug.Log(key+"--->"+ dict[key]);
//		}

		roomId = dict["room_id"];
		host = dict["host"];
//		host = "54.254.229.244";
		port = dict["port"];
//		port = "9521";
		dbname = dict["dbname"];

		tagTitle = Regex.Unescape(dict["tag"]);
		int subIndex = tagTitle.IndexOf("#");
		if (subIndex >=0 && tagTitle.Length > subIndex) {
			tagTitle = tagTitle.Substring(tagTitle.IndexOf("#")+1);
		}
		
		title = Regex.Unescape(dict["title"]);
        roomname = Regex.Unescape(dict["game_type"]);
		minMoney = dict["min_money"];
		maxMoney = dict["max_money"];
		if (maxMoney.Equals("-1")) { maxMoney = ZPLocalization.Instance.Get("Room_MaxMoney"); }
		maxOnline = dict["max_online"];
		// shawn.debug onlineNum
		onlineNum = dict["online_num"];
		//int tempMaxOnline = int.Parse(maxOnline);
		////System.Random ro = new System.Random();
		//int tempOnlineNum = (int)(tempMaxOnline * 0.6f + (tempMaxOnline * 0.2f * ro.NextDouble()));
		//onlineNum = tempOnlineNum>0 ? tempOnlineNum.ToString() : dict["online_num"];

		//add 2016.4.5 
		if(dict.ContainsKey("entry_fee")){
			entry_fee = int.Parse( dict["entry_fee"] );
		}

        //add 2016.07.05
        if (dict.ContainsKey("room_type"))
        {
            roomType = dict["room_type"];
        }
    }
}
