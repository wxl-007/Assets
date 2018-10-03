using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZRegtPanel : MonoBehaviour {

	public enum eMatchType{min5, hour, person3};
	public UILabel rgtPriceLb;
	public UILabel startTimeLb;
	public UILabel personLb;
	public UILabel personLimitLb;
	public UILabel countDownLb;
	public UIButton quitBtn;

	public GameObject awardPanel;
	public GameObject rulesPanel;
	public GameObject rules2Panel;
	public GameObject rules3Panel;
	public GameObject tipObj;
	public UILabel[] awardLbAry;
	public UILabel[] awardDesLbAry;
	public UITexture bg;
	private bool _isHoursMatch = false;
	public bool isHoursMatch{set{_isHoursMatch = value;}get{return _isHoursMatch;}}
	public eMatchType matchType = eMatchType.min5;

	public GameObject awardBtn;
	public GameObject rulesBtn;
	public GameObject contentDailyMatch;
	public GameObject contentOtherMatch;
	public GameObject contentCommon;
	public GameObject content131Match;
	public UILabel dailyStartTime;
	public UILabel dailyPerson;
	public UILabel dailyPersonLimit;
	public UILabel dailyTickets;
	public GameObject dailyQuitBtn;
	public GameObject dailyAwardBtn;
	public GameObject dailyRulesBtn;
	public GameObject dailyRankBtn;
	public UILabel[]  dailyCountDownLbs;
	public GameObject dailypanelAward;
	public GameObject dailypanelRank;
	public GameObject dailypanelRules;

	public UILabel n131Person;
	public UILabel n131RgtPrice;
	public UILabel n131require;
	public UILabel n131NeedPerson;
	public GameObject n131PanelRuls;

	private int cd;

	// Use this for initialization
	void Start () {
		SettingInfo.Instance.effectVolume = 0;

		if(PlatformGameDefine.game.GameTypeIDs == "9"){//日赛
			contentDailyMatch.SetActive(true);
			contentCommon.SetActive(true);
			contentOtherMatch.SetActive(false);
			content131Match.SetActive(false);
			rules2Panel.transform.Find("desLb3").gameObject.SetActive(false);
			rules2Panel.transform.Find("desLb4").localPosition = new Vector3(79, -269, 0);
			quitBtn.gameObject.SetActive(false);
			awardBtn.SetActive(false);
			rulesBtn.SetActive(false);
		}else if(PlatformGameDefine.game.GameTypeIDs == "8"){//131海选赛 
			contentDailyMatch.SetActive(false);
			contentCommon.SetActive(true);
			contentOtherMatch.SetActive(false);
			content131Match.SetActive(true);
			quitBtn.gameObject.SetActive(false);
			awardBtn.SetActive(false);
			rulesBtn.SetActive(false);
		}else{
			contentDailyMatch.SetActive(false);
			contentOtherMatch.SetActive(true);
			quitBtn.gameObject.SetActive(true);
		}
	}

	void OnDisable(){
		SettingInfo.Instance.effectVolume = 1;
	}

	public void startCD(int cdTime){
		cd = cdTime;
		InvokeRepeating("invokeCD", 0.1f, 1.0f);
	}

	public void initRankList(List<JSONObject> list){
		//'top_rank10': [{'update_time': '2016-10-30 18:34:51', 'score': 2500, 'uid': 127576, 'rank': 1, 'name': u'\u6587\u7269\u6cd5'}, 
		Transform orderTr = dailypanelRank.transform.Find("grid");
		Transform desTr = dailypanelRank.transform.Find("gridDes");
		int len = orderTr.childCount;
		for(int i=0; i<len; i++){
			orderTr.GetChild(i).GetComponent<UILabel>().text = "第"+list[i]["rank"].n+"名";
			//正式服上是\\u6587\\u7269, 测试服是\u6587\u7269   所有搜索\\\\ 替换成 \\
			desTr.GetChild(i).GetComponent<UILabel>().text = System.Text.RegularExpressions.Regex.Unescape( list[i]["name"].str.Replace("\\\\","\\") );
		}
	}

	public void initAward(List<JSONObject> list, DDZRegtPanel.eMatchType matchType)
	{
		if(PlatformGameDefine.game.GameTypeIDs == "9" || PlatformGameDefine.game.GameTypeIDs == "8"){//日赛
			Transform orderTr = dailypanelAward.transform.Find("grid");
			Transform desTr = dailypanelAward.transform.Find("gridDes");
			int len = orderTr.childCount;
			if(PlatformGameDefine.game.GameTypeIDs == "8"){
				orderTr.GetChild(0).GetComponent<UILabel>().text = list[0].list[0].str;
				desTr.GetChild(0).GetComponent<UILabel>().text = list[0].list[1].str;
			}else{
				for(int i=0; i<len; i++){
					if(i == 5){
						orderTr.GetChild(i).GetComponent<UILabel>().text = "第6－10名";
					}else{
						orderTr.GetChild(i).GetComponent<UILabel>().text = list[i].list[0].str;
					}
					desTr.GetChild(i).GetComponent<UILabel>().text = list[i].list[1].str;
				}
			}
		}else{
			for(int i=0; i< awardLbAry.Length; i++){
				if(i< list.Count){
					if(matchType == eMatchType.person3){
						if(i == 0){
							//[["第1名", "1快乐卡"], ["第2名", ""], ["第3名", ""]]
							//						string infoStr = list[i].str;
							//						string[] infoAry = infoStr.Split(':');
							//						awardLbAry[i].text = "第"+infoAry[0]+"名";
							//						awardDesLbAry[i].text = infoAry[1];
							awardLbAry[i].text = list[i].list[0].str;
							awardDesLbAry[i].text = list[i].list[1].str;
						}
					}else{
						if(PlatformGameDefine.game.GameTypeIDs == "9"){//日赛
							if(i == 7){
								awardLbAry[i].text ="第8－10名";
							}else{
								awardLbAry[i].text = list[i].list[0].str;
							}
						}else{
							awardLbAry[i].text = list[i].list[0].str;
						}
						awardDesLbAry[i].text = list[i].list[1].str;
					}
				}
			}
			if(matchType == eMatchType.person3){
				awardPanel.GetComponent<UISprite>().height = 147;
				Vector3 vc3 = awardPanel.transform.localPosition;
				vc3.y = -20;
				awardPanel.transform.localPosition = vc3;
				personLimitLb.transform.parent.gameObject.SetActive(false);
				countDownLb.transform.parent.gameObject.SetActive(false);
			}else{
				if(list.Count > 6){
					awardPanel.GetComponent<UISprite>().height = 400;
				}
			}
		}
	}

	private void invokeCD()
	{
		if(cd == 0){
			CancelInvoke("invokeCD");
			if(PlatformGameDefine.game.GameTypeIDs == "9"){//日赛
				for(int i=0; i<6; i++){
					dailyCountDownLbs[i].text = "0";
				}
			}else{
				countDownLb.text = "0";
			}
		}else{
			if(PlatformGameDefine.game.GameTypeIDs == "9"){//日赛
				string fixTime = EginTools.miao2TimeStr(cd,true,true).Replace(":","");
				char[] charAry =  fixTime.ToCharArray();
				for(int i=0; i<6; i++){
					dailyCountDownLbs[i].text = charAry[i].ToString();
				}
			}else{
				countDownLb.text = EginTools.miao2TimeStr(cd);
			}
			cd--;
		}
	}

	public void closeAllWidget()
	{
		if(PlatformGameDefine.game.GameTypeIDs == "9" || PlatformGameDefine.game.GameTypeIDs == "8"){
			dailypanelAward.SetActive(false);
			dailypanelRank.SetActive(false);
			dailypanelRules.SetActive(false);
			n131PanelRuls.SetActive(false);
		}else{
			rules2Panel.SetActive(false);
			rulesPanel.SetActive(false);
			rules3Panel.SetActive(false);
			awardPanel.SetActive(false);
		}
	}

	public void toggleAwardPanel()
	{
		if(PlatformGameDefine.game.GameTypeIDs == "9" || PlatformGameDefine.game.GameTypeIDs == "8"){
			closeAllWidget();
			dailypanelAward.SetActive(true);
			dailypanelAward.transform.localScale = Vector3.one;
			iTween.ScaleFrom(dailypanelAward, iTween.Hash("scale",new Vector3(0.1f, 0.5f,1.0f), "time", 0.3f,
				"easetype", iTween.EaseType.easeOutBack) );
		}else{
			if(matchType == eMatchType.hour){
				rules2Panel.SetActive(false);
			}else if(matchType == eMatchType.min5){
				rulesPanel.SetActive(false);
			}else if(matchType == eMatchType.person3){
				rules3Panel.SetActive(false);
			}
			awardPanel.SetActive(true);
			awardPanel.transform.localScale = Vector3.one;
			iTween.ScaleFrom(awardPanel, iTween.Hash("scale",new Vector3(0.1f, 0.5f,1.0f), "time", 0.3f,
				"easetype", iTween.EaseType.easeOutBack) );
		}
	}
	public void toggleRulesPanel()
	{
		if(PlatformGameDefine.game.GameTypeIDs == "9" || PlatformGameDefine.game.GameTypeIDs == "8"){
			closeAllWidget();
			GameObject targetObj = dailypanelRules;
			if(PlatformGameDefine.game.GameTypeIDs == "8"){
				targetObj = n131PanelRuls;
			}
			targetObj.SetActive(true);
			targetObj.transform.localScale = Vector3.one;
			iTween.ScaleFrom(targetObj, iTween.Hash("scale",new Vector3(0.1f, 0.5f,1.0f), "time", 0.3f,
				"easetype", iTween.EaseType.easeOutBack) );
		}else{
			if(matchType == eMatchType.hour){
				rules2Panel.SetActive(true);
				rules2Panel.transform.localScale = Vector3.one;
				iTween.ScaleFrom(rules2Panel, iTween.Hash("scale",new Vector3(0.1f, 0.5f,1.0f), "time", 0.3f,
					"easetype", iTween.EaseType.easeOutBack) );
			}else if(matchType == eMatchType.min5){
				rulesPanel.SetActive(true);
				rulesPanel.transform.localScale = Vector3.one;
				iTween.ScaleFrom(rulesPanel, iTween.Hash("scale",new Vector3(0.1f, 0.5f,1.0f), "time", 0.3f,
					"easetype", iTween.EaseType.easeOutBack) );
			}else if(matchType == eMatchType.person3){
				rules3Panel.SetActive(true);
				rules3Panel.transform.localScale = Vector3.one;
				iTween.ScaleFrom(rules3Panel, iTween.Hash("scale",new Vector3(0.1f, 0.5f,1.0f), "time", 0.3f,
					"easetype", iTween.EaseType.easeOutBack) );
			}
			awardPanel.SetActive(false);
		}
	}

	public void showRankPanel()
	{
		if(PlatformGameDefine.game.GameTypeIDs == "9"){
			closeAllWidget();
			dailypanelRank.SetActive(true);
			dailypanelRank.transform.localScale = Vector3.one;
			iTween.ScaleFrom(dailypanelRank, iTween.Hash("scale",new Vector3(0.1f, 0.5f,1.0f), "time", 0.3f,
				"easetype", iTween.EaseType.easeOutBack) );
		}
	}

	public void showTip(string tipStr, System.Action act)
	{
		tipObj.SetActive(true);
		GameObject ct = tipObj.transform.Find("bg").gameObject;
		iTween.ScaleFrom(ct, iTween.Hash("scale",new Vector3(0.5f, 0.5f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		UILabel desLb = ct.transform.Find("des").GetComponent<UILabel>();
		desLb.text = tipStr;
		if(act == null){
			act = ()=>{tipObj.SetActive(false);};
		}
		StartCoroutine(delayAct(act));
	}

	public void useBg2()
	{
		bg.mainTexture = SimpleFramework.Util.LoadAsset("GameDDZC/DDZrgtBg2","DDZrgtBg2") as Texture2D;
	}

	public void useBg1()
	{
		//DDZBSregtBg
		bg.mainTexture = SimpleFramework.Util.LoadAsset("GameDDZC/DDZBSregtBg","DDZBSregtBg") as Texture2D;
	}

	public void useBg3()
	{
		bg.mainTexture = SimpleFramework.Util.LoadAsset("GameDDZC/DDZCrgtbg3","DDZCrgtbg3") as Texture2D;
	}

	public void useDailyBg()
	{
		bg.mainTexture = SimpleFramework.Util.LoadAsset("GameDDZC/DDZbgDaily","DDZbgDaily") as Texture2D;
	}
	public void use6personBg()
	{
		bg.mainTexture = SimpleFramework.Util.LoadAsset("GameDDZC/DDZbg6person","DDZbg6person") as Texture2D;
	}

	private IEnumerator delayAct(System.Action act)
	{
		yield return new WaitForSeconds(2.3f);
		act();
	}

}
