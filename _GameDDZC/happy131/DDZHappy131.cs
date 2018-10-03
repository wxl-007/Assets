using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZHappy131{

	public GameDDZ mainCls;
	public Happy131Dialogs dialog;
	public Happy131Regt ddz131Rgt;
	private GameObject leaderboardObj;
	private List<JSONObject> rankList;
	private GameObject rulesObj;
	private List<JSONObject> awardList;

	public DDZHappy131(GameDDZ gameDDZ, Happy131Regt rgt)
	{
		mainCls = gameDDZ;
		ddz131Rgt = rgt;
//		mainCls.rulesBtn.SetActive(false);
//		mainCls.leaderboardBtn.SetActive(false);
	}

	public void ProcessApply(JSONObject messageObj)
	{
		//{"body": {"end": "22:00", "range": "10:00-22:00", "awards": [["第1名", "300元京东E卡"], ["第2名", "200元京东E卡"], ["第3名", "100元京东E卡"], 
		//["第4-10名", "50元京东E卡"], ["第11-20名", "30元京东E卡"], ["第21~30名", "100W金币"], ["第31~50名", "50W金币"]], 
		//"restseconds": -1, "close": false, "sum_score": 0, "ave_score": 0, "round": 0, "rank": 0, "top50": []}, "tag": "apply", "type": "ddz7"}
		JSONObject body = messageObj["body"];
		ddz131Rgt.initData((int)body["round"].n, (int)body["ave_score"].n, (int)body["rank"].n, body["top50"].list, (int)body["restseconds"].n);
		dialog.updateData((int)body["round"].n, (int)body["sum_score"].n,(int)body["ave_score"].n);
		ddz131Rgt.continueBtn.SetActive(false);
		ddz131Rgt.regBtn.SetActive(true);
//		ddz131Rgt.regTitle.SetActive(true);
		mainCls.resultAnima.hideAnima();
		mainCls.tipMsg.SetActive(true);
		ddz131Rgt.gameObject.SetActive(true);
		rankList = body["top50"].list;
		awardList = body["awards"].list;
	}

	public void ProcessReChecking(JSONObject messageObj)
	{
		//{"body": {"awards": [["第1名", "300元京东E卡"], ["第2名", "200元京东E卡"], ["第3名", "100元京东E卡"], ["第4-10名", "50元京东E卡"], ["第11-20名", "30元京东E卡"], 
		//["第21~30名", "100W金币"], ["第31~50名", "50W金币"]], "round": 1, "top50": []}, "tag": "recheckin", "type": "ddz7"}
		JSONObject body = messageObj["body"];
		ddz131Rgt.initData((int)body["round"].n, (int)body["ave_score"].n, (int)body["rank"].n, body["top50"].list, (int)body["restseconds"].n);
		dialog.updateData((int)body["round"].n, (int)body["sum_score"].n,(int)body["ave_score"].n);
		ddz131Rgt.continueBtn.SetActive(true);
		ddz131Rgt.regBtn.SetActive(false);
//		ddz131Rgt.regTitle.SetActive(false);
//		ddz131Rgt.gameObject.SetActive(false);
		mainCls.resultAnima.hideAnima();
		mainCls.tipMsg.SetActive(true);
		ddz131Rgt.gameObject.SetActive(true);
		rankList = body["top50"].list;
		awardList = body["awards"].list;
	}

	public void initEnterData(int rank, int totalRank,int score, List<JSONObject> top50)
	{
		mainCls.userPlayerCtrl.cmpInfoInit(rank, totalRank, -1);
		rankList = top50;
		//mainCls.leaderboard.initLeaderboard(top30, DDZRegtPanel.eMatchType.min5);
		mainCls.leaderboard.updateSelfInfo( rank, score );
		mainCls._userIntoMoney.text =  score + "";
	}

	public void ProcessShowAward(JSONObject messageObj)
	{
		//{'type':'ddz7', 'tag':'sendaward', 'body': 
		//{'rank': rank,自己当前排名  'top50': top50,前50名  'award': self.get_rankaward_str(rank),获取奖励信息 'add_gold':num,奖励的元宝数
		//'add_item_id':item_id,奖励的京东卡item_id}} 
		JSONObject body = messageObj["body"];
		dialog.showAwardDialog((int)body["rank"].n, (int)body["add_gold"].n, (int)body["add_item_id"].n);

	}

	public void hideObj(GameObject obj)
	{
		obj.SetActive(false);
	}

	public void showLeaderboard()
	{
		if(leaderboardObj == null){
			GameObject leaderboardPrb = SimpleFramework.Util.LoadAsset("GameDDZ/leadboard131","leadboard131") as GameObject;
			leaderboardObj = NGUITools.AddChild(mainCls.transform.parent.parent.Find("infoBtnLayer").gameObject, leaderboardPrb);
			UIButton closeBtn = leaderboardObj.transform.Find("bg").GetComponent<UIButton>();
			closeBtn.onClick.Add(new EventDelegate(()=>{ leaderboardObj.SetActive(false);}) );
		}
		leaderboardObj.SetActive(true);
		leaderboardObj.transform.localScale = Vector3.one;
		iTween.ScaleFrom(leaderboardObj.gameObject, iTween.Hash("scale",new Vector3(0.7f, 0.7f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		if(rankList == null || rankList[0].IsNull)return;
		Transform listTr = leaderboardObj.transform.Find("Scroll View/list");
		int count = listTr.childCount;
		for(int i=0; i< count; i++){
			if(i >=rankList.Count)return;
			//[600, 1, 116481, "爱你一生v", 1, 0, 0, 0]
			JSONObject rankData = rankList[i];
			Transform contentTr = listTr.GetChild(i);
			contentTr.Find("rank").GetComponent<UILabel>().text = (i+1)+"";
			contentTr.Find("name").GetComponent<UILabel>().text = rankData[3].str;
			contentTr.Find("round").GetComponent<UILabel>().text = rankData[1].n+"";
			contentTr.Find("win").GetComponent<UILabel>().text = rankData[4].n+"";
			contentTr.Find("lose").GetComponent<UILabel>().text = rankData[5].n+"";
			contentTr.Find("score").GetComponent<UILabel>().text = rankData[0].n+"";
		}
	}

	public void showRulesPanel()
	{
		if(rulesObj == null){
			GameObject rulesPrb = SimpleFramework.Util.LoadAsset("GameDDZ/RulesPanel131","RulesPanel131") as GameObject;
			rulesObj = NGUITools.AddChild(mainCls.transform.parent.parent.Find("infoBtnLayer").gameObject, rulesPrb);
			UIButton closeBtn = rulesObj.transform.Find("bg").GetComponent<UIButton>();
			closeBtn.onClick.Add(new EventDelegate(()=>{ rulesObj.SetActive(false);}) );
		}
		rulesObj.SetActive(true);
		rulesObj.transform.localScale = Vector3.one;
		iTween.ScaleFrom(rulesObj, iTween.Hash("scale",new Vector3(0.7f, 0.7f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		if(awardList == null || awardList[0].IsNull)return;
		Transform listTr = rulesObj.transform.Find("awardScrollList");
		int count = listTr.childCount;
		for(int i=0; i< count; i++){
			if(i >=awardList.Count)return;
			//["第1名", "300元京东E卡"]
			JSONObject awardData = awardList[i];
			Transform contentTr = listTr.GetChild(i);
			contentTr.GetComponent<UILabel>().text = awardData[0].str;
			contentTr.Find("des").GetComponent<UILabel>().text = awardData[1].str;
		}
	}

	public void ProcessReadyFail()
	{
		dialog.showEndDialog();
	}

	public void gameover(JSONObject messageObj)
	{
		//{"body": {"user_info": [{"add_score": 300, "uid": 89062723, "cards": [], "double": 3, "win_round": 1, "fail_round": 0, "ave_score": 300, "round": 1, "sum_score": 300, "is_win": true}, 
		//{"add_score": 30, "uid": 116355, "cards": [0, 28, 42, 43, 5, 31, 32, 20, 46, 9, 22, 35, 48, 36, 49, 51], "double": 3, "win_round": 0, "fail_round": 1, "ave_score": 30, "round": 1,
		//"sum_score": 30, "is_win": false}, {"add_score": 30, "uid": 118152, "cards": [41, 47, 50, 12, 25], "double": 3, "win_round": 0, "fail_round": 1, "ave_score": 30, "round": 1, 
		//"sum_score": 30, "is_win": false}], "rocket_times": 0, "winner": 89062723, "bomb_times": 0, "is_spring": false}, "tag": "gameover", "type": "ddz"}
		for(int i=0; i<  messageObj["body"]["user_info"].list.Count; i++){
			if(mainCls.getPlayerWithID((int)messageObj["body"]["winner"].n).isBanker){
				if(messageObj["body"]["user_info"].list[i]["uid"].n == messageObj["body"]["winner"].n){
					messageObj["body"]["user_info"].list[i]["winmoney"] = messageObj["body"]["user_info"].list[i]["add_score"];
				}else{
					messageObj["body"]["user_info"].list[i]["winmoney"] = new JSONObject((-messageObj["body"]["user_info"].list[i]["add_score"].n).ToString());
				}
			}else{
				if(!mainCls.getPlayerWithID((int)messageObj["body"]["user_info"].list[i]["uid"].n).isBanker){
					messageObj["body"]["user_info"].list[i]["winmoney"] = messageObj["body"]["user_info"].list[i]["add_score"];
				}else{
					messageObj["body"]["user_info"].list[i]["winmoney"] = new JSONObject((-messageObj["body"]["user_info"].list[i]["add_score"].n).ToString());
				}
			}
		}
		messageObj["body"]["double"] = messageObj["body"]["user_info"].list[0]["double"];
		messageObj["body"]["user_win_money"] = messageObj["body"]["user_info"];
//		Debug.LogError( messageObj.ToString() );
	}

}
