using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameSettingManager : MonoBehaviour {
	public UISlider sliderBgVolume;
	public UISlider sliderEffectVolume;

    public UIButton spriteSpecial;
    public UIButton kAutoNext;
    public UIButton kDeposit;

	public UILabel kAllDeposit;

	public GameObject bagContainerPrafab;

	// Use this for initialization
	void Start () {
		SettingInfo.Instance.LoadInfo ();
		sliderBgVolume.value = SettingInfo.Instance.bgVolume;
		sliderEffectVolume.value = SettingInfo.Instance.effectVolume;
        spriteSpecial.normalSprite = SettingInfo.Instance.specialEfficacy == true ? "special_on" : "special_off";
        kAutoNext.normalSprite = SettingInfo.Instance.autoNext == true ? "special_on" : "special_off";
        kDeposit.normalSprite = SettingInfo.Instance.deposit == true ? "special_on" : "special_off";
	}

	public void SetBgVolume() {
		SettingInfo.Instance.bgVolume = sliderBgVolume.value;
	}

	public void SetEffectVolume() {
		SettingInfo.Instance.effectVolume = sliderEffectVolume.value;
	}

	public void SetSpecial() {
        if (spriteSpecial.normalSprite.Equals("special_off"))
        {
            spriteSpecial.normalSprite = "special_on";
			SettingInfo.Instance.specialEfficacy = true;
		}else {
            spriteSpecial.normalSprite = "special_off";
			SettingInfo.Instance.specialEfficacy = false;
		}
	}

	public void SetAutoNext() {
        if (kAutoNext.normalSprite.Equals("special_off"))
        {
            kAutoNext.normalSprite = "special_on";

			SettingInfo.Instance.autoNext = true;
		}else {
            kAutoNext.normalSprite = "special_off";

			SettingInfo.Instance.autoNext = false;
		}
	}
	//
	public void SetDeposit(){
        if (kDeposit.normalSprite.Equals("special_off"))
        {
            kDeposit.normalSprite = "special_on";
			SettingInfo.Instance.deposit = true;
		}else {
            kDeposit.normalSprite = "special_off";
			SettingInfo.Instance.deposit = false;
		}
	}

	public void setDepositVisible(bool bl){
		kAllDeposit.gameObject.SetActive (bl);
	}

	//自动下局:

	void OnDestroy() {
		SettingInfo.Instance.SaveInfo ();
	}
	//
	
//	public IEnumerator GetBackpackList() {
//		WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.BACKPACK_LIST_URL, null);
//		yield return www;
//		
////		UITexture[] texs = bagContainerPrafab.GetComponentsInChildren<UITexture>();
////		for(int i=0; i<7; i++) {
////			string url = "http://localhost:8080/test/setting_popup.png";
////			WWW data = HttpConnect.Instance.HttpRequestWithSession(url, null);
////			yield return data;
////			texs[i].mainTexture = (Texture)data.texture;
////		}
//
//		HttpResult result = HttpConnect.Instance.BackpackListResult(www);
//		if(HttpResult.ResultType.Sucess == result.resultType) {
//			JSONObject jo = result.resultObject as JSONObject;
//
//			List<JSONObject> listAll = jo.list;
//			//一个container代表一页
//			List<Object> listContainer = new List<Object>();
//			//一页中的info，不超过8个
//			List<JSONObject> list1 = new List<JSONObject>();
//			List<JSONObject> list2 = new List<JSONObject>();
//			List<JSONObject> list3 = new List<JSONObject>();
//			List<JSONObject> list4 = new List<JSONObject>();
//			for(int i=0; i<listAll.Count; i++) {
//				JSONObject info = listAll[i];
//				if(i < 8) {
//					list1.Add(info);
//				}else if(i < 16) {
//					list2.Add(info);
//				}else if(i < 24) {
//					list3.Add(info);
//				}else if(i < 32) {
//					list4.Add(info);
//				}
//			}
//			listContainer.Add(list1);
//			listContainer.Add(list2);
//			listContainer.Add(list3);
//			listContainer.Add(list4);
//
//			for(int j=0; j<listContainer.Count; j++) {
//				List list = listContainer[j];
//			}
////			UITexture[] texs = bagContainerPrafab.GetComponentsInChildren<UITexture>();
////			for(int i=0; i<list.Count; i++) {
////				JSONObject info = list[i];
////				int count = (int)info["count"].n;
////				string url = info["url"].ToString();
////				string id = info["id"].ToString();
////				WWW data = HttpConnect.Instance.HttpRequestWithSession(url, null);
////				yield return data;
////				texs[i].mainTexture = (Texture)data.texture;
////			}
////			
////			int pages = (int)Mathf.Ceil(list.Count/8);
////			for(int i=0; i<pages; i++) {
////			}
//
//
////			List<JSONObject> list = jo.list;
////			UITexture[] texs = bagContainerPrafab.GetComponentsInChildren<UITexture>();
////			for(int i=0; i<list.Count; i++) {
////				JSONObject info = list[i];
////				int count = (int)info["count"].n;
////				string url = info["url"].ToString();
////				string id = info["id"].ToString();
////				WWW data = HttpConnect.Instance.HttpRequestWithSession(url, null);
////				yield return data;
////				texs[i].mainTexture = (Texture)data.texture;
////			}
////
////			int pages = (int)Mathf.Ceil(list.Count/8);
////			for(int i=0; i<pages; i++) {
////			}
//		}
//	}
}
