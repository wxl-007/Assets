using UnityEngine;
using System.Collections;

public class Happy131Dialogs : MonoBehaviour {


	public GameObject roundStartDialog;
	public GameObject QuitDialog;
	public GameObject resultDialog;
	public GameObject awardDialog;
	public GameObject endDialog;

	public UILabel roundCountLb;
	public UILabel totalScoreLb;
	public UILabel avgScoreLb;
	public GameDDZ mainDoc;

	public int roundCount;
	public int score;
	public int avgScore;

	// Use this for initialization
	void Start () {
	
	}

	public void updateData(int round, int score, int avg)
	{
		this.roundCount = round;
		this.score = score;
		this.avgScore = avg;
	}

	public void showRoundStartDialog()
	{
		showDialog(roundStartDialog);
		roundCountLb.text = (roundCount+1)+"";
		totalScoreLb.text = score+"";
		avgScoreLb.text = avgScore+"";

		Invoke("hideDialog",2.0f);
	}

	private string quitDes = "";
	private string quitDes2 = "";
	public void showQuitDialog()
	{
		showDialog(QuitDialog);
		if(quitDes.Length == 0){
			quitDes = QuitDialog.transform.Find("des").GetComponent<UILabel>().text;
		}
		if(quitDes2.Length == 0){
			quitDes2 = QuitDialog.transform.Find("des2").GetComponent<UILabel>().text;
		}
		QuitDialog.transform.Find("des").GetComponent<UILabel>().text = string.Format( quitDes, roundCount);
		QuitDialog.transform.Find("des2").GetComponent<UILabel>().text = string.Format( quitDes2, score, avgScore);
	}

	public void showEndDialog()
	{
		showDialog(endDialog);
		mainDoc.tipMsg.SetActive(false);
	}

	private string resultDes1 = "";
	private string resultDes2 = "";
	public void showResultDialog(int winScore, bool isWin=true)
	{
		showDialog(resultDialog);
		if(resultDes1.Length == 0){
			resultDes1 = resultDialog.transform.Find("des").GetComponent<UILabel>().text;
		}
		if(resultDes2.Length == 0){
			resultDes2 = resultDialog.transform.Find("des2").GetComponent<UILabel>().text;
		}
		if(!isWin){
			resultDes1 = resultDes1.Replace("[24e154]胜利[-]","[e3371b]失败[-]");
			resultDialog.transform.Find("titleSpt2").gameObject.SetActive(true); 
			resultDialog.transform.Find("titleSpt").gameObject.SetActive(false);
		}else{
			resultDes1 = resultDes1.Replace("[e3371b]失败[-]","[24e154]胜利[-]");
			resultDialog.transform.Find("titleSpt2").gameObject.SetActive(false);
			resultDialog.transform.Find("titleSpt").gameObject.SetActive(true);
		}
		resultDialog.transform.Find("des").GetComponent<UILabel>().text = string.Format(resultDes1, roundCount, winScore);
		resultDialog.transform.Find("des2").GetComponent<UILabel>().text = string.Format( resultDes2, score, avgScore);
	}

	public void showAwardDialog(int rank, int coin, int jdCardID)
	{
		showDialog(awardDialog);
		if(coin != 0){
			awardDialog.transform.Find("titleSpt/coinSpt").gameObject.SetActive(true);
			awardDialog.transform.Find("titleSpt/JDcardSpt").gameObject.SetActive(false);
			string info = awardDialog.transform.Find("titleSpt/coinSpt/des").GetComponent<UILabel>().text;
			awardDialog.transform.Find("titleSpt/coinSpt/des").GetComponent<UILabel>().text = string.Format( info, rank, coin);
		}else{
			awardDialog.transform.Find("titleSpt/coinSpt").gameObject.SetActive(false);
			awardDialog.transform.Find("titleSpt/JDcardSpt").gameObject.SetActive(true);
			//JDCard id : 121 to 125  = rank 1 to 5
			jdCardID -= 120;
			awardDialog.transform.Find("titleSpt/JDcardSpt/jdcardSpt").GetComponent<UISprite>().spriteName = "JDCard"+jdCardID;
		}
	}

	public void showDialog(GameObject content)
	{
		gameObject.SetActive(true);
		roundStartDialog.SetActive(false);
		QuitDialog.SetActive(false);
		resultDialog.SetActive(false);
		awardDialog.SetActive(false);
		endDialog.SetActive(false);
		content.SetActive(true);
	}

	public void quitGame()
	{
		mainDoc.UserQuit();
	}

	public void resumeGame()
	{
		hideDialog();
	}

	public void nextRound()
	{
		JSONObject startJson = new JSONObject();
		startJson.AddField("type", "ddz");
		//Modified by xiaoyong 2016/2/16  change to "ready"
		//        startJson.AddField("tag", "start");
		startJson.AddField("tag", "ready");
		startJson.AddField("body", 1 );
		mainDoc.SendPackageWithJson(startJson);
		hideDialog();
		mainDoc.tipMsg.SetActive(true);
	}

	public void hideDialog()
	{
		gameObject.SetActive(false);
	}

	public void getAward()
	{
		mainDoc.ddz131.ddz131Rgt.gameObject.SetActive(true);
		mainDoc.ddz131.ddz131Rgt.showAwardInGame();
	}

}
