using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZLeaderboard : MonoBehaviour {

//	private int myrank;
//	private int myScore;
	public GameObject[] itemAry;
	public UILabel myRankLb;
	public UILabel myScoreLb;
	public UILabel titleLb;

	public Transform listObjTr;
	public Transform upTxtTr;
	public Transform lineTr;
	public Transform downTxtTr;
	public Transform scoreTxtTr;
	public UISprite  bg;

	// Use this for initialization
	void Start () {
	
	}

	public void initLeaderboard(List<JSONObject> list, DDZRegtPanel.eMatchType matchtype)
	{
		if(matchtype == DDZRegtPanel.eMatchType.person3){
			if(bg.height != 350){
				if(PlatformGameDefine.game.GameTypeIDs == "8"){
					listObjTr.localPosition = new Vector3(-280.0f, 119.0f, 0);
					upTxtTr.localPosition   = new Vector3(-398.0f, 119.0f, 0);
					titleLb.transform.localPosition = new Vector3(0,183.0f,0);
					lineTr.localPosition = new Vector3(0, -92.0f, 0);
					downTxtTr.localPosition = new Vector3(-375.0f, -138.0f, 0);
					scoreTxtTr.localPosition = new Vector3(76.0f, -138.0f, 0);
					myRankLb.transform.localPosition = new Vector3(-126.0f, -138.0f, 0);
					myScoreLb.transform.localPosition = new Vector3(172, -142.0f, 0);
					bg.height = 450;
				}else{
					listObjTr.localPosition = new Vector3(-280.0f, 76.0f, 0);
					upTxtTr.localPosition   = new Vector3(-398.0f, 76.0f, 0);
					titleLb.transform.localPosition = new Vector3(0,135.0f,0);

					lineTr.localPosition = new Vector3(0, -29.0f, 0);

					downTxtTr.localPosition = new Vector3(-375.0f, -78.0f, 0);
					scoreTxtTr.localPosition = new Vector3(76.0f, -78.0f, 0);
					myRankLb.transform.localPosition = new Vector3(-126.0f, -78.0f, 0);
					myScoreLb.transform.localPosition = new Vector3(172, -82.0f, 0);
					bg.height = 350;
				}
			}
		}

		//[1000, 866627772, "bj123456789"], [1000, 111052, "李少"], ...] 
		for(int i=0; i< itemAry.Length; i++){
			UILabel rankLb = itemAry[i].transform.Find("rank").GetComponent<UILabel>();
			UILabel nameLb = itemAry[i].transform.Find("name").GetComponent<UILabel>();
			UILabel scoreLb= itemAry[i].transform.Find("score").GetComponent<UILabel>();
			if(i< list.Count){
				if(matchtype == DDZRegtPanel.eMatchType.person3){
					//[{"score": 0, "uid": 866627772, "rank": 0, "name": "bj123456789"}, 
					//{"score": 0, "uid": 115299, "rank": 1, "name": "小李肥刀"}, {"score": 0, "uid": 118784, "rank": 2, "name": "晨露夕梅"}]
					//3人赛的结构
					rankLb.text = "第"+(i+1)+"名";
					nameLb.text = list[i]["name"].str;
					scoreLb.text = list[i]["score"].n + "积分";
				}else{
					rankLb.text = "第"+(i+1)+"名";
					nameLb.text = list[i].list[2].str;
					scoreLb.text = list[i].list[0].n + "积分";
				}
			}else{
				rankLb.text = "";
				nameLb.text = "";
				scoreLb.text = "";
			}
		}
	}
	public void updateSelfInfo(int rank, int score)
	{
		myRankLb.text = "第"+rank+"名";
		myScoreLb.text = score+"";
	}

	public void hidePanel()
	{
		gameObject.SetActive(false);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
