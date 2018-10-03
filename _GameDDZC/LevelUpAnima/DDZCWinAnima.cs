using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZCWinAnima : MonoBehaviour {

	public UISprite res1L;
	public UISprite res1R;
	public UISprite txt;
	public UISprite txtA;
	public TextAnima textAnima;
	public CMPRoadMap roadmap;
	public UILabel  totalRankLb;
	private bool step1Play = false;
	public float step1Spd = 0.08f;
	public Animator animator;
	private float step1v = 0;

	public GameObject awardObj;
	public UILabel gameNameLb;
	public UILabel matchNameLb;
	public UILabel rankLb;
	public UILabel awardInfoLb;
	public GameObject comeonTag;
	public GameObject blackBg;
	public UILabel  nickNameLb;
	public UILabel  awardDesLb;

	public Animator beginAnima;
	public UISprite tipSpt;
	public GameDDZ  mainCls;
	private string  tipSptName;

	private GameObject dailyAwardPrb;

	// Use this for initialization
	void Start () {
		//		setTxt("Lordtxt");
		//		reset();
		//		Invoke("step1",2.0f);
		//		res1L.atlas.spriteMaterial.SetFloat("_Saturation",0.2f);
	}

	// Update is called once per frame
	void Update () {
		if(step1Play){
			step1v += step1Spd;
			res1L.fillAmount = step1v;
			res1R.fillAmount = step1v;
			if(step1v>= 1.0f){
				step1Play = false;
			}
		}
	}

	public void reset()
	{
		step1v = 0;
		step1Play = false;
		res1L.fillAmount = 0;
		res1R.fillAmount = 0;
	}

	public void setTxt(string sptName)
	{
		txt.spriteName = sptName;
		txt.MakePixelPerfect();
		txtA.spriteName = sptName+"A";
		txtA.MakePixelPerfect();
		txtA.width = txtA.width*2;
		txtA.height = txtA.height*2;
	}

	public void beginMatch()
	{
		beginAnima.gameObject.transform.Find("txtL").GetComponent<UISprite>().spriteName = "preVSTxt";
		beginAnima.CrossFade("beginAnima",0);
	}
	public void beginFinalMatch()
	{
		beginAnima.gameObject.transform.Find("txtL").GetComponent<UISprite>().spriteName = "VSTxt";
		beginAnima.CrossFade("beginAnima",0);
	}

	public void step1()
	{
		step1v = 0;
		step1Play = true;
		//		res1L.atlas.spriteMaterial.SetFloat("_Saturation",1.0f);
	}

	public void loseStep1()
	{
		//		res1L.atlas.spriteMaterial.SetFloat("_Saturation",0.2f);
		step1v = 0;
		step1Play = true;
	}

	public void initRank(int rank)
	{
		roadmap.setDefaultRank(rank);
	}

	public void hideAnima()
	{
		animator.CrossFade("WinAnimaHide",0);
		textAnima.gameObject.SetActive(false);
		roadmap.gameObject.SetActive(false);
		blackBg.SetActive(false);
	}

	public void playWin(int rank = 1, int totalRank=1)
	{
		animator.CrossFade("DDZCWinDefault",0);
		textAnima.gameObject.SetActive(true);
		roadmap.gameObject.SetActive(true);
		awardObj.SetActive(false);
		textAnima.play2(roadmap.preRank, rank);
		roadmap.init(rank);
		totalRankLb.text = "/"+totalRank;
		res1L.atlas.spriteMaterial.SetFloat("_Saturation",1);
		blackBg.SetActive(true);
		Invoke("delayHide",3.0f);
	}
	public void playLose(int rank=1, int totalRank=1)
	{
		animator.CrossFade("LoseAnima",0);
		textAnima.gameObject.SetActive(true);
		roadmap.gameObject.SetActive(true);
		awardObj.SetActive(false);
		textAnima.play2(roadmap.preRank, rank);
		roadmap.init(rank);
		totalRankLb.text = "/"+totalRank;
		res1L.atlas.spriteMaterial.SetFloat("_Saturation",0.2f);
		blackBg.SetActive(true);
		Invoke("delayHide",3.0f);
	}

	public void showAward(int rank, string awardInfoStr)
	{
		hideAnima();
		if(IsInvoking("delayShowTips")){
			CancelInvoke("delayShowTips");
		}
		tipSpt.gameObject.SetActive(false);
		blackBg.SetActive(false);
		if(PlatformGameDefine.game.GameTypeIDs == "9" || PlatformGameDefine.game.GameTypeIDs == "8"){
			dailyAwardPrb = SimpleFramework.Util.LoadAsset("GameDDZC/award131","awardPanel131") as GameObject;
			GameObject award131Panel = Instantiate<GameObject>(dailyAwardPrb);
			award131Panel.transform.parent = transform;
			award131Panel.transform.Find("title/myrank").GetComponent<UILabel>().text = "第"+ rank +"名";
			#if UNITY_STANDALONE_WIN
			award131Panel.transform.FindChild("nickName").GetComponent<UILabel>().text = mainCls._userNickname.text+" :";
			#else
			award131Panel.transform.Find("nickName").GetComponent<UILabel>().text = EginUser.Instance.nickname+" :";
			#endif
			UIButton quitBtn3 = award131Panel.transform.Find("quit3").GetComponent<UIButton>();
			UIButton quitBtn2 = award131Panel.transform.Find("quit2").GetComponent<UIButton>();
			UIButton quitBtn1 = award131Panel.transform.Find("quit1").GetComponent<UIButton>();
			if(rank == 1){
				if(PlatformGameDefine.game.GameTypeIDs == "8"){
					quitBtn3.gameObject.SetActive(false);
					quitBtn2.gameObject.SetActive(true);
					quitBtn1.gameObject.SetActive(true);
					quitBtn2.onClick.Add(new EventDelegate( ()=>{ mainCls.UserQuit(); }));
					quitBtn1.onClick.Add(new EventDelegate( ()=>{ mainCls.btnHandleRgt(); }));
					award131Panel.transform.Find("bonus").GetComponent<UILabel>().text = "日赛门票一张";
				}else{
					quitBtn3.onClick.Add(new EventDelegate( ()=>{ mainCls.UserQuit(); }));
					award131Panel.transform.Find("bonus").GetComponent<UILabel>().text = awardInfoStr;
					award131Panel.transform.Find("tips").gameObject.SetActive(false);
				}
			}else{
				if(PlatformGameDefine.game.GameTypeIDs == "8"){
					quitBtn3.gameObject.SetActive(false);
					quitBtn2.gameObject.SetActive(true);
					quitBtn1.gameObject.SetActive(true);
					quitBtn2.onClick.Add(new EventDelegate( ()=>{ mainCls.UserQuit(); }));
					quitBtn1.onClick.Add(new EventDelegate( ()=>{ mainCls.btnHandleRgt(); }));
					award131Panel.GetComponent<UISprite>().spriteName = "131awardFrame1";
					award131Panel.GetComponent<UISprite>().MakePixelPerfect();
					award131Panel.transform.Find("title").localPosition = new Vector3(-159, -6, 0);
					award131Panel.transform.Find("title").GetComponent<UILabel>().text = "恭喜你赢得游戏大咖海选赛                                  再接再厉。";
					award131Panel.transform.Find("bonus").GetComponent<UILabel>().text = "";
					award131Panel.transform.Find("des").gameObject.SetActive(false);
					award131Panel.transform.Find("tips").gameObject.SetActive(false);
				}else{
					quitBtn3.onClick.Add(new EventDelegate( ()=>{ mainCls.UserQuit(); }));
					if(rank >10){
						award131Panel.GetComponent<UISprite>().spriteName = "131awardFrame1";
						award131Panel.GetComponent<UISprite>().MakePixelPerfect();
						award131Panel.transform.Find("title").localPosition = new Vector3(-159, -6, 0);
						award131Panel.transform.Find("bonus").GetComponent<UILabel>().text = "";
						award131Panel.transform.Find("des").gameObject.SetActive(false);
						award131Panel.transform.Find("tips").gameObject.SetActive(false);
						award131Panel.transform.Find("title").GetComponent<UILabel>().text = "恭喜你赢得游戏大咖日赛                                  再接再厉。";
					}else{
						award131Panel.transform.Find("bonus").GetComponent<UILabel>().text = awardInfoStr;
						award131Panel.transform.Find("tips").gameObject.SetActive(false);
					}
				}
			}
			award131Panel.transform.localScale = Vector3.one;
			award131Panel.transform.localPosition = new Vector3(0,-67.89f,0);


			iTween.ScaleFrom(award131Panel, iTween.Hash("scale",new Vector3(0.7f, 0.7f,1.0f), "time", 0.3f,
				"easetype", iTween.EaseType.easeOutBack) );
		}else{
			awardObj.SetActive(true);
			gameNameLb.text = getGameName();
			if(PlatformGameDefine.game.GameTypeIDs == "6"){
				matchNameLb.text = "恭喜你在     斗地主5分钟赛";
			}else if(PlatformGameDefine.game.GameTypeIDs == "4"){
				matchNameLb.text = "恭喜你在     斗地主整点赛";
			}else if(PlatformGameDefine.game.GameTypeIDs == "7"){
				matchNameLb.text = "恭喜你在     斗地主三人赛";
			}else if(PlatformGameDefine.game.GameTypeIDs == "8"){
				matchNameLb.text = "恭喜你在     斗地主六人赛";
			}else if(PlatformGameDefine.game.GameTypeIDs == "9"){
				matchNameLb.text = "恭喜你在     斗地主日赛";
			}
			rankLb.text = rank+"";

			#if UNITY_STANDALONE_WIN
			nickNameLb.text = mainCls._userNickname.text;
			#else
			nickNameLb.text = EginUser.Instance.nickname;
			#endif
			awardInfoLb.text = awardInfoStr;
			//		yield return new WaitForSeconds(0.5f);
			if(awardInfoStr.Length == 0){
				awardDesLb.text = "中获得第          名的成绩。";
				res1L.atlas.spriteMaterial.SetFloat("_Saturation",0.2f);
				comeonTag.SetActive(true);
			}else{
				awardDesLb.text = "中获得第          名的成绩。特为你派发如下奖品——";
				res1L.atlas.spriteMaterial.SetFloat("_Saturation",1);
				comeonTag.SetActive(false);
			}
			awardObj.transform.localScale = Vector3.one;
			iTween.ScaleFrom(awardObj, iTween.Hash("scale",new Vector3(0.7f, 0.7f,1.0f), "time", 0.3f,
				"easetype", iTween.EaseType.easeOutBack) );
		}

	}

	private void delayHide()
	{
		if(!awardObj.activeSelf){
			hideAnima();
		}
	}

	public void waitTip(string sptName, float sec=0, bool everytimeWork = false)
	{
		if(mainCls.isPlaying && !everytimeWork){
			return;
		}
		tipSptName = sptName;
		if(sec == 0){
			tipSpt.gameObject.SetActive(true);
			tipSpt.spriteName = tipSptName;
			tipSpt.MakePixelPerfect();
		}else{
			Invoke("delayShowTips", sec);
		}
	}
	private void delayShowTips()
	{
		if(mainCls.isPlaying){
			return;
		}
		tipSpt.gameObject.SetActive(true);
		tipSpt.spriteName = tipSptName;
		tipSpt.MakePixelPerfect();
	}

	private string getGameName()
	{
		string platformName = PlatformGameDefine.playform.PlatformName;
		if(platformName.IndexOf("597") != -1 || platformName.IndexOf("1977") != -1){
			return "597游戏中心";
		}else if(platformName.IndexOf("7997") != -1){
			return "7997游戏中心";
		}else if(platformName.IndexOf("407") != -1 || platformName.IndexOf("131") != -1 ){
			return "131游戏中心";
		}else if(platformName.IndexOf("510") != -1 || platformName.IndexOf("510k") != -1 ){
			return "510K游戏中心";
		}else{
			return "597游戏中心";
		}
	}
}
