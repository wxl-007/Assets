using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZBSRulesPanel : MonoBehaviour {

	public UILabel[] awardLbAry;
	public GameObject rulesObj;
	public GameObject rules2Obj;
	public GameObject rules3Obj;
	public DDZRegtPanel.eMatchType matchType;
	public UIScrollView scrollView;

	public Transform lineTr;
	public Transform upTxtTr;
	public Transform downTxtTr;
	public UISprite  bg;

	// Use this for initialization
	void Start () {
		if(matchType == DDZRegtPanel.eMatchType.hour){
			rulesObj.SetActive(false);
			rules3Obj.SetActive(false);
			rules2Obj.SetActive(true);

			if(PlatformGameDefine.game.GameTypeIDs == "9"){
				rules2Obj.transform.Find("title").GetComponent<UILabel>().text = "斗地主日赛赛制及奖励方案";
				rules2Obj.transform.Find("des 2").gameObject.SetActive(false);
				rules2Obj.transform.Find("des 3").localPosition = new Vector3(-305, 53, 0);
			}
		}else if(matchType == DDZRegtPanel.eMatchType.min5){
			rulesObj.SetActive(true);
			rules2Obj.SetActive(false);
			rules3Obj.SetActive(false);
		}else if(matchType == DDZRegtPanel.eMatchType.person3){
			rulesObj.SetActive(false);
			rules2Obj.SetActive(false);
			rules3Obj.SetActive(true);

			if(bg.height != 450){
				lineTr.localPosition = new Vector3(0,-87,0);
				upTxtTr.localPosition = new Vector3(-400,126,0);
				downTxtTr.localPosition = new Vector3(-405,-118,0);
				scrollView.transform.localPosition = new Vector3(0,-222,0);
				bg.height = 450;
			}
			if(PlatformGameDefine.game.GameTypeIDs == "8"){
				rules3Obj.transform.Find("title").GetComponent<UILabel>().text = "斗地主6人赛赛制及奖励方案";
			}
		}
	}

	public void initAward(List<JSONObject> list, DDZRegtPanel.eMatchType matchType)
	{
		for(int i=0; i< awardLbAry.Length; i++){
			if(i< list.Count){
				if(matchType == DDZRegtPanel.eMatchType.person3){
					if(i == 0){
//						string infoStr = list[i].str;
//						string[] infoAry = infoStr.Split(':');
//						awardLbAry[i].text = "第"+infoAry[0]+"名";
//						awardLbAry[i].transform.FindChild("des").GetComponent<UILabel>().text = infoAry[1];
						awardLbAry[i].text = list[i].list[0].str;
						awardLbAry[i].transform.Find("des").GetComponent<UILabel>().text = list[i].list[1].str;
					}
				}else{
					if(PlatformGameDefine.game.GameTypeIDs == "9"){//日赛
						if( i== 7){
							awardLbAry[i].text = "第8－10名";
						}else{
							awardLbAry[i].text = list[i].list[0].str;
						}
					}else{
						awardLbAry[i].text = list[i].list[0].str;
					}
					awardLbAry[i].transform.Find("des").GetComponent<UILabel>().text = list[i].list[1].str;
				}
			}
		}
		if(list.Count <= 6){
			scrollView.enabled = false;
		}
	}

	public void hidePanel()
	{
		gameObject.SetActive(false);
	}
}
