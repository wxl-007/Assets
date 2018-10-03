using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameFarm : MonoBehaviour {

	public FarmCow[] cowAry;
	public GameObject btnGroup;
	public GameObject panelFood;
	public GameObject panelInv;
	public GameObject panelStore;
	public GameObject panelSetting;
	public GameObject panelTickets;
	public GameObject dialogBuy;
	public GameObject bonusTicketIcon;

	public UILabel nickNameLb;
	public UILabel cowCountLb;
	public UILabel moneyLb;
	public UILabel ticketsLb;
	public UIProgressBar cowCountPb;
	public UISprite avatarIcon;
	public ParticleSystem ticketPt;
	public Dictionary<string, int> invetoryDc = new Dictionary<string, int>();
	public Dictionary<string, int> foodExpDc = new Dictionary<string, int>();
	public Dictionary<string, int> foodPriceDc = new Dictionary<string, int>();
	public int lv=1;
	private int cowCount;
	private bool isMute = false;
	private bool isVibrate = true;

	private FarmCow selectedCow;

	// Use this for initialization
	void Start () {
//		base.StartGameSocket();
		initInv();
		EginProgressHUD.Instance.HideHUD();
	}

	private void initInv()
	{
		invetoryDc["food1"]=10;
		invetoryDc["food2"]=500;
		invetoryDc["food3"]=121;
		invetoryDc["food5"]=50;
		invetoryDc["milk"] = 100;
		invetoryDc["ticket"] = 3991;

		foodExpDc["food1"] = 100000;
		foodExpDc["food2"] = 300000;
		foodExpDc["food3"] = 400000;
		foodExpDc["food4"] = 600000;
		foodExpDc["food5"] = 1000000;

		foodPriceDc["food1"] = 10;
		foodPriceDc["food2"] = 20;
		foodPriceDc["food3"] = 30;
		foodPriceDc["food4"] = 40;
		foodPriceDc["food5"] = 50;

//		cowCount = lv*2;
		cowCount = 2;
		if(cowCount>10){
			cowCount = 10;
		}

		for(int i=0; i< cowAry.Length; i++){
			if(i< cowCount){
				cowAry[i].gameObject.SetActive(true);
				cowAry[i].init(i+1);
			}else{
//				cowAry[i].gameObject.SetActive(false);
			}
		}

		initPlayerInfo("10", "Sick Bear123", 10000, cowCount);
	}

	public void initPlayerInfo(string avatarID, string nkName, int money, int cowNum)
	{
		nickNameLb.text = nkName;
		avatarIcon.spriteName = "avatar_"+avatarID;
		moneyLb.text = money+"";
		cowCountLb.text = cowNum +"/10";
		cowCountPb.value = (float)cowNum/(float)10;
		consumeTickets(0);
	}

	public bool consumeTickets(int count)
	{
		if(invetoryDc.ContainsKey("ticket") && invetoryDc["ticket"] > 0){
			if(invetoryDc["ticket"] -  count >=0){
				invetoryDc["ticket"] -= count;
				ticketsLb.text = invetoryDc["ticket"]+"";
				if(invetoryDc["ticket"] == 0){
					invetoryDc.Remove("ticket");
				}
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}

	public void btnToggleBtnG()
	{
		if(btnGroup.transform.localPosition.x == -66){
			iTween.MoveTo(btnGroup, iTween.Hash("x",236.0f, "islocal", true, "time",0.5f, "easetype", iTween.EaseType.easeInBack));
		}else if(btnGroup.transform.localPosition.x == 236){
			iTween.MoveTo(btnGroup, iTween.Hash("x",-66, "islocal", true, "time",0.5f, "easetype", iTween.EaseType.easeOutBack));
		}
	}

	#region 喂食面板相关
	public void popupPanelFood(FarmCow cow)
	{
		panelFood.SetActive(true);
		panelFood.transform.localScale = Vector3.one;
		iTween.ScaleFrom(panelFood, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		int count = panelFood.transform.childCount;
		for(int i=0; i< count; i++){
			Transform tr = panelFood.transform.GetChild(i);
			if(tr.name.IndexOf("food") != -1){
				UILabel countLb = tr.Find("count").GetComponent<UILabel>();
				if(invetoryDc.ContainsKey(tr.name)){
					countLb.text = invetoryDc[tr.name]+"";
					tr.GetComponent<BoxCollider>().enabled = true;
				}else{
					countLb.text = "0";
					tr.GetComponent<BoxCollider>().enabled = false;
				}
			}
		}
		selectedCow = cow;
	}

	public void closePanelFood(){ panelFood.SetActive(false);}

	public void selectFood(string foodKey)
	{
		invetoryDc[foodKey] -= 1;
		if(invetoryDc[foodKey] == 0){
			invetoryDc.Remove(foodKey);
		}
		selectedCow.eatFood( foodExpDc[foodKey]);
		closePanelFood();
	}
	#endregion

	#region 仓库面板相关
	public void popupPanelInv()
	{
		panelInv.SetActive(true);
		panelInv.transform.Find("content").transform.localScale = Vector3.one;
		iTween.ScaleFrom(panelInv.transform.Find("content").gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		Transform listContent = panelInv.transform.Find("content/list");
		int count = listContent.childCount;
		for(int i=0; i< count; i++){
			Transform item = listContent.GetChild(i);
			if(invetoryDc.ContainsKey(item.name)){
				item.Find("countLb").GetComponent<UILabel>().text = "x"+invetoryDc[item.name];
			}else{
				item.Find("countLb").GetComponent<UILabel>().text = "0";
				if(item.name == "milk"){
					Transform milkBtn = item.transform.Find("btn");
					milkBtn.gameObject.SetActive(false);
				}
			}
		}
	}
	public void closePanelInv(){panelInv.SetActive(false);}
	public void sellMilk()
	{
		if(invetoryDc.ContainsKey("milk") && invetoryDc["milk"] > 0){
			invetoryDc["milk"] -= 1;
			moneyLb.text = (long.Parse(moneyLb.text)+10000) + "";
			Transform milkTr = panelInv.transform.Find("content/list/milk/countLb");
			if(invetoryDc["milk"] == 0){
				invetoryDc.Remove("milk");
				milkTr.GetComponent<UILabel>().text = "0";
				Transform milkBtn = panelInv.transform.Find("content/list/milk/btn");
				milkBtn.gameObject.SetActive(false);
			}else{
				milkTr.GetComponent<UILabel>().text = "x"+invetoryDc["milk"];
			}
		}
	}
	#endregion

	#region 商店面板
	private int buyCount=1;
	private string curItemKey = "";
	public void popupPanelStore()
	{
		panelStore.SetActive(true);
		panelStore.transform.Find("content").transform.localScale = Vector3.one;
		iTween.ScaleFrom(panelStore.transform.Find("content").gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		Transform listContent = panelStore.transform.Find("content/list");
		int count = listContent.childCount;
		for(int i=0; i< count; i++){
			Transform item = listContent.GetChild(i);
			Debug.Log(item.name);
			if(item.name != "milk"){
				item.Find("btn/price").GetComponent<UILabel>().text = foodPriceDc[item.name]+"";
			}else{
				if(cowCount == lv*2){
					item.Find("btn").gameObject.SetActive(false);
				}
			}
		}
		buyCount = 1;
	}
	public void recevieCow()
	{
		if(cowCount< lv*2){
			cowCount = lv*2;
			if(cowCount>10){
				cowCount = 10;
			}
			for(int i=0; i< cowAry.Length; i++){
				if(i< cowCount){
					if(!cowAry[i].gameObject.activeSelf){
						cowAry[i].gameObject.SetActive(true);
						cowAry[i].init(i+1);
					}
				}
			}
			panelStore.transform.Find("content/list/milk/btn").gameObject.SetActive(false);
			cowCountLb.text = cowCount +"/10";
			cowCountPb.value = (float)cowCount/(float)10;
		}
	}
	public void buyItem(string itemID)
	{
		curItemKey = itemID;
		buyCount = 1;
		popupDialogBuy();
	}
	public void popupDialogBuy()
	{
		dialogBuy.SetActive(true);
		dialogBuy.transform.Find("content").transform.localScale = Vector3.one;
		iTween.ScaleFrom(dialogBuy.transform.Find("content").gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		Transform invCountTr = dialogBuy.transform.Find("content/des1/num");
		Transform priceTr    = dialogBuy.transform.Find("content/des1/num2");
		Transform itemIconTr = dialogBuy.transform.Find("content/food/icon");
		Transform itemNameTr = dialogBuy.transform.Find("content/titleBaner/titleSpt");
		Transform buyNumTr   = dialogBuy.transform.Find("content/selectNum/num");
		invCountTr.GetComponent<UILabel>().text = invetoryDc.ContainsKey(curItemKey)? (invetoryDc[curItemKey]+""): "0";
		priceTr.GetComponent<UILabel>().text = foodPriceDc[curItemKey]+"";
		itemIconTr.GetComponent<UISprite>().spriteName = "mucao"+ curItemKey.Substring(curItemKey.Length-1);
		itemNameTr.GetComponent<UISprite>().spriteName = "txt"+curItemKey;
		buyNumTr.GetComponent<UILabel>().text = buyCount+"";
	}
	public void plus1Handle()
	{
		buyCount++;
		dialogBuy.transform.Find("content/des1/num2").GetComponent<UILabel>().text = ""+(foodPriceDc[curItemKey] * buyCount);
		dialogBuy.transform.Find("content/selectNum/num").GetComponent<UILabel>().text = buyCount+"";
	}
	public void plus10Handle()
	{
		buyCount += 10;
		dialogBuy.transform.Find("content/des1/num2").GetComponent<UILabel>().text = ""+(foodPriceDc[curItemKey] * buyCount);
		dialogBuy.transform.Find("content/selectNum/num").GetComponent<UILabel>().text = buyCount+"";
	}
	public void de1Handle(){
		buyCount--;
		if(buyCount<1){
			buyCount = 1;
		}
		dialogBuy.transform.Find("content/des1/num2").GetComponent<UILabel>().text = ""+(foodPriceDc[curItemKey] * buyCount);
		dialogBuy.transform.Find("content/selectNum/num").GetComponent<UILabel>().text = buyCount+"";
	}
	public void de10Handle(){ 
		buyCount -= 10;
		if(buyCount<1){
			buyCount = 1;
		}
		dialogBuy.transform.Find("content/des1/num2").GetComponent<UILabel>().text = ""+(foodPriceDc[curItemKey] * buyCount);
		dialogBuy.transform.Find("content/selectNum/num").GetComponent<UILabel>().text = buyCount+"";
	}

	public void buyHandle()
	{
		int price = foodPriceDc[curItemKey] * buyCount;
		if(price > invetoryDc["ticket"]){
			dialogBuy.transform.Find("content/tipSpt").gameObject.SetActive(true);
			Invoke("delayHideTip",2.0f);
			if(isVibrate){
#if UNITY_IPHONE || UNITY_ANDROID
        //  Handheld.Vibrate();
#endif
            }
        }
        else{
			consumeTickets(price);
			if(invetoryDc.ContainsKey(curItemKey)){
				invetoryDc[curItemKey] += buyCount;
			}else{
				invetoryDc[curItemKey] = buyCount;
			}
			dialogBuy.SetActive(false);
		}
	}
	private void delayHideTip()
	{
		dialogBuy.transform.Find("content/tipSpt").gameObject.SetActive(false);
	}
	#endregion

	#region 设置面板
	public void popupPanelSetting()
	{
		panelSetting.SetActive(true);
		panelSetting.transform.Find("content").transform.localScale = Vector3.one;
		iTween.ScaleFrom(panelSetting.transform.Find("content").gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		UILabel soundLb = panelSetting.transform.Find("content/soundToggle/stateLb").GetComponent<UILabel>();
		if(isMute){
			soundLb.text = "关闭";
		}else{
			soundLb.text = "开启";
		}
		UILabel vibrateLb = panelSetting.transform.Find("content/vibrateToggle/stateLb").GetComponent<UILabel>();
		if(isVibrate){
			vibrateLb.text = "开启";
		}else{
			vibrateLb.text = "关闭";
		}
	}
	public void toggleHandle(string name){
		if(name == "vibrateToggle"){
			isVibrate = !isVibrate;
			UILabel vibrateLb = panelSetting.transform.Find("content/vibrateToggle/stateLb").GetComponent<UILabel>();
			if(isVibrate){
				vibrateLb.text = "开启";
			}else{
				vibrateLb.text = "关闭";
			}
		}else{
			isMute = !isMute;
			UILabel soundLb = panelSetting.transform.Find("content/soundToggle/stateLb").GetComponent<UILabel>();
			if(isMute){
				soundLb.text = "关闭";
			}else{
				soundLb.text = "开启";
			}
		}
	}
	public void btnBackToHall()
	{
		Debug.Log("goto to hall");
	}
	public void btnShowHelp()
	{
		GameObject helpObj = panelSetting.transform.Find("helpDialog").gameObject;
		helpObj.SetActive(true);
		helpObj.transform.Find("content").transform.localScale = Vector3.one;
		iTween.ScaleFrom(helpObj.transform.Find("content").gameObject, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
	}
	#endregion

	#region 领取点券面板
	public void popupTicketRecieve()
	{
		int ticketCount = 300;
		panelTickets.SetActive(true);
		panelTickets.transform.localScale = Vector3.one;
		iTween.ScaleFrom(panelTickets, iTween.Hash("scale",new Vector3(0.5f, 0.1f,1.0f), "time", 0.3f,
			"easetype", iTween.EaseType.easeOutBack) );
		panelTickets.transform.Find("frame/count").GetComponent<UILabel>().text = ticketCount +"";
		
	}
	public void recieveTickets()
	{
		int ticketCount = int.Parse( panelTickets.transform.Find("frame/count").GetComponent<UILabel>().text);
		consumeTickets( -ticketCount);
		panelTickets.SetActive(false);
		bonusTicketIcon.SetActive(false);
		ticketPt.gameObject.SetActive(true);
		ticketPt.Play();
	}
	#endregion

	public void closePanel(GameObject obj){obj.SetActive(false);}
	public void collectAllCow()
	{
		for(int i=0; i< cowAry.Length; i++){
			if(cowAry[i].gameObject.activeSelf){
				if(cowAry[i].cowState == FarmCow.eCowState.full){
					cowAry[i].tapHandle();
				}
			}
		}
	}

	public void collectMike(int milkNum)
	{
		if(invetoryDc.ContainsKey("milk")){
			invetoryDc["milk"] += milkNum;
		}else{
			invetoryDc["milk"] = milkNum;
		}
	}

}
