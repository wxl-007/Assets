using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameDDZOb{

	public GameDDZ mainCls;

	public GameDDZOb(GameDDZ gameDDZ)
	{
		mainCls = gameDDZ;
		mainCls.btnGroup.gameObject.SetActive(false);
		mainCls.transform.parent.parent.Find("infoBtnLayer/footInfoAnchor/btns/btnAuto").gameObject.SetActive(false);
		mainCls.transform.parent.parent.Find("infoBtnLayer/footInfoAnchor/btns/btnPrecard").gameObject.SetActive(false);
		mainCls.transform.parent.parent.Find("infoBtnLayer/footInfoAnchor/btns/btnEmot").gameObject.SetActive(false);
		mainCls.transform.parent.parent.Find("infoBtnLayer/footInfoAnchor/btns/btnChat").gameObject.SetActive(false);
	}

	public void ProcessDeal(JSONObject messageObj)
	{
		/*
=> 发牌
{"body": {"player_infos": [{"win_times": 142, "active_point": 0, "uid": 312503, "mobile_type": -1, "level": 0, "bag_money": 1148854, 
"into_money": 1148834, "winning": 28, "avatar_img": "", "avatar_no": 12, "is_staff": false, "exp": 16, 
"vip_level": 0, "cards": [0, 1, 14, 2, 41, 16, 17, 5, 18, 6, 46, 9, 35, 10, 38, 51, 52], "position": 0, "nickname": "wyg123456", "lose_times": 357, "client_address": "北京市"}, 
{"win_times": 1200, "active_point": 0, "uid": 299017, "mobile_type": -1, "level": 0, "bag_money": 42137, "into_money": 42117, "winning": 62, "avatar_img": "", "avatar_no": 1, "is_staff": false, "exp": 0, "vip_level": 0, "cards": [26, 40, 42, 30, 31, 45, 20, 8, 21, 47, 22, 23, 24, 37, 50, 12, 53], "position": 1, "nickname": "sygame08", "lose_times": 709, "client_address": "北京市"}, 

{"win_times": 4, "active_point": 0, "uid": 337666, "mobile_type": -1, "level": 0, "bag_money": 928, "into_money": 968, "winning": 28, "avatar_img": "", "avatar_no": 2, "is_staff": false, "exp": 0.0, "vip_level": 0, "cards": [13, 39, 27, 15, 29, 4, 43, 44, 19, 32, 7, 33, 34, 48, 36, 11, 25], "position": 2, "nickname": "forker", "lose_times": 10, "client_address": "北京市"}], 

"visible_card": 47, "visible_index": 9, "deskinfo": {"unit_money": 5, "room_type": 20, "top_money": 500}, "banker": 299017, "timeout": 12, "hide_cards": [3, 49, 28]}, "tag": "deal", "type": "ddz"}
         */

		JSONObject body = messageObj["body"];

//		List<JSONObject> cards = body["mycards"].list;
		int timeout = (int)body["timeout"].n;
		DDZCount.Instance.DestroyHUD();
		foreach (GameObject player in mainCls._playingPlayerList)
		{
			if (player != null)
			{
				DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
				bool tempShowDeck = false;
				if(ctrl.isShowDeck){
					tempShowDeck = true;
				}
				ctrl.resetState();
				if(tempShowDeck){
					ctrl.isShowDeck = true;
				}
				ctrl.Clearcards();
			}
		}
		foreach(JSONObject playerInfo in body["player_infos"].list){
			List<JSONObject> cards = playerInfo["cards"].list;
			if(playerInfo["uid"].n == mainCls.obID){
				mainCls.userPlayerCtrl.SetDeal(cards);
			}else{
				DDZPlayerCtrl playCtrl = mainCls.getPlayerWithID((int)playerInfo["uid"].n);
				if(playCtrl != null){
					bool needReset = true;
					if(playCtrl.isShowDeck){
						needReset = false;
					}
					mainCls.StartCoroutine( playCtrl.showDeck(cards) );
					if(needReset){
						playCtrl.isShowDeck = false;
					}
				}
			}
		}
		foreach (GameObject player in mainCls._playingPlayerList)
		{
			if (player != null)
			{
				DDZPlayerCtrl ctrl = player.GetComponent<DDZPlayerCtrl>();
				ctrl.updateCardCount(17,true);
			}
		}

	}

	/*中途进入观战:
{"body": {"banker_cards": [], "double": 1, "lastone": 299022, 

"current_state": [{"hold_num": 10, "task_award": [5, 240, 0], "managed": false, "uid": 299022, "task_id": 1, "double": 1, "lastput_type": 1, "callpt": 1, "cards": [5, 7, 20, 46, 21, 34, 11, 25, 51, 53], "raised": -1, "lastput": [17, 43]}, {"hold_num": 17, "task_award": [5, 240, 0], "managed": true, "uid": 312503, "task_id": 1, "double": 1, "lastput_type": 0, "callpt": 0, "cards": [39, 1, 29, 4, 30, 18, 6, 32, 8, 22, 10, 23, 36, 24, 37, 50, 52], "raised": 0, "lastput": []}, {"hold_num": 17, "task_award": [5, 240, 0], "managed": true, "uid": 299019, "task_id": 1, "double": 1, "lastput_type": 0, "callpt": 0, "cards": [26, 14, 40, 2, 16, 31, 44, 19, 45, 33, 47, 9, 35, 48, 49, 12, 38], 
"raised": 0, "lastput": []}], 

"thisone": 299019, "step": 2, "banker": 299022, "timeout": 13.3604319096, 

"show_card_info": [{"cards": [5, 7, 20, 46, 21, 34, 11, 25, 51, 53], "is_show": false, "uid": 299022, "show_double": 1}, {"cards": [39, 1, 29, 4, 30, 18, 6, 32, 8, 22, 10, 23, 36, 24, 37, 50, 52], "is_show": false, "uid": 312503, "show_double": 1}, {"cards": [26, 14, 40, 2, 16, 31, 44, 19, 45, 33, 47, 9, 35, 48, 49, 12, 38], "is_show": false, "uid": 299019, "show_double": 1}], 

"showed_cards": [0, 3, 13, 15, 17, 27, 28, 41, 42, 43], "hide_cards": [34, 13, 17], "call_times": 1}, "tag": "update", "type": "ddz"}
*/

}
