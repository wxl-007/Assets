using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZSoundMgr : SoundMgr {

	public static bool personSound = true;
	public static bool sfxSound = true;
	private static bool _bgmSound = true;
	public static bool bgmSound{
		set{
			_bgmSound = value;
			if(_bgmSound){
				SoundMgr.instance.player.volume = 1;
			}else{
				SoundMgr.instance.player.volume = 0;
			}
		}
		get{
			return _bgmSound;
		}
	}
	protected Dictionary<string , string[]> randDc = new Dictionary<string, string[]>();
	protected Dictionary<int, string> resDc = new Dictionary<int, string>();
	protected Dictionary<string, AudioClip> clipDc = new Dictionary<string, AudioClip>();

	protected override void init ()
	{
		base.init ();
		/*P3 = 3,P4 = 4, P5 = 5, P6 = 6,P7 = 7, P8 = 8, P9 = 9,P10 = 10, J = 11, Q = 12,K = 13, A = 14, P2 = 15, 小王 = 16,大王 = 17,*/
		resDc[3] = "card_3";
		resDc[4] = "card_4";
		resDc[5] = "card_5";
		resDc[6] = "card_6";
		resDc[7] = "card_7";
		resDc[8] = "card_8";
		resDc[9] = "card_9";
		resDc[10] = "card_10";
		resDc[11] = "card_j";
		resDc[12] = "card_q";
		resDc[13] = "card_k";
		resDc[14] = "card_0-A";
		resDc[15] = "card_2";
		resDc[16] = "xiaowang";
		resDc[17] = "dawang";

		//double 1000
		resDc[1003] = "dui_3";
		resDc[1004] = "dui_4";
		resDc[1005] = "dui_5";
		resDc[1006] = "dui_6";
		resDc[1007] = "dui_7";
		resDc[1008] = "dui_8";
		resDc[1009] = "dui_9";
		resDc[1010] = "dui_10";
		resDc[1011] = "dui_j";
		resDc[1012] = "dui_q";
		resDc[1013] = "dui_k";
		resDc[1014] = "dui_1-A";
		resDc[1015] = "dui_2";

		//cardtype =2  means  2002
		resDc[2002] = "sange";
		resDc[2003] = "sandaiyi";
		resDc[2004] = "sandaiyidui";
		resDc[2005] = "shunzi";
		resDc[2006] = "liandui";
		resDc[2010] = "sidaier";
		resDc[2013] = "huojian";

		//chatinfo = 3 means 3003
		resDc[3000] = "chat_0";
		resDc[3001] = "chat_1";
		resDc[3002] = "chat_2";
		resDc[3003] = "chat_3";
		resDc[3004] = "chat_4";
		resDc[3005] = "chat_5";
		resDc[3006] = "chat_6";
		resDc[3007] = "chat_7";
		resDc[3008] = "chat_8";
		resDc[3009] = "chat_9";
		resDc[3010] = "chat_10";
		resDc[3011] = "chat_11";
		resDc[3012] = "chat_0 (2)";
		resDc[3013] = "chat_1 (2)";
		resDc[3014] = "chat_2 (2)";
		resDc[3015] = "chat_3 (2)";
		resDc[3016] = "chat_4 (2)";
		resDc[3017] = "chat_5 (2)";
		resDc[3018] = "chat_6 (2)";
		resDc[3019] = "chat_7 (2)";
		resDc[3020] = "chat_8 (2)";
		resDc[3021] = "chat_9 (2)";
		resDc[3022] = "chat_10 (2)";
		resDc[3023] = "chat_11 (2)";

		randDc["airplane"]   = new string[]{"feiji","kan_huiji"};
		randDc["last2Cards"] = new string[]{"zuihouerzhang1","zuihouerzhang2"};
		randDc["last1Card"]  = new string[]{"zuihouyizhang1","zuihouyizhang2"};
		randDc["handleYou"]  = new string[]{"dani","yasi", "guanshang"};
		randDc["pass"]       = new string[]{"pass_buyao","pass_guo","pass_pass","pass_yaobuqi"};
		randDc["jiaodizhu"]  = new string[]{"jiaodizhu"};
		randDc["qiangdizhu"] = new string[]{"qiangdizhu1","qiangdizhu2","qiangdizhu3"};
		randDc["bujiao"]  = new string[]{"bujiao"};
		randDc["buqiang"] = new string[]{"buqiang"};
		randDc["bujiabei"]= new string[]{"bujiabei"};
		randDc["jiabei"]= new string[]{"jiabei"};
		randDc["lordWin"]   = new string[]{"lord_win"};
		randDc["farmerWin"] = new string[]{"farmer_win"};
		randDc["openCard"]  = new string[]{"opencard"};
		randDc["score1"]  = new string[]{"yifen"};
		randDc["score2"]  = new string[]{"erfen"};
		randDc["score3"]  = new string[]{"sanfen"};

		//not use
		randDc["woshidizhu"]= new string[]{"woshidizhu"};

	}

	//单张0，对子1，三张2，三带单3，三带对4，单顺5，双顺6，飞机7，飞机带单8，飞机带双9，四带两单10，炸弹12，火箭13
	public override void drawCard(int cardType , bool isFemale, int pokerNum )
	{
		if(!personSound)return;
		if(cardType == 0){
			string ResName = "sound/"+resDc[ pokerNum ];
			if(!isFemale){
				ResName += " (2)";
			}
			playEft(ResName);
		}else if(cardType == 1){
			string ResName = "sound/"+resDc[ pokerNum+1000 ];
			if(!isFemale){
				ResName += " (2)";
			}
			playEft(ResName);
		}else if(cardType == 12){
			int len = randomGroup.Length;
			int randValue;
			if(isFemale){
				randValue = Random.Range(3, 6);
			}else{
				randValue = Random.Range(0, 3);
			}
			AudioClip clip = randomGroup[randValue];
			playEft(clip);
		}else if(cardType == 13){
			string ResName = "sound/"+resDc[ 2000+cardType ];
			if(!isFemale){
				ResName += " (2)";
			}
			playEft(ResName);
		}else if(cardType == 2 || cardType == 3 || cardType == 4 || cardType == 5 || cardType == 6
		         || cardType == 10){
			string ResName = "sound/"+resDc[ 2000+cardType ];
			if(!isFemale){
				ResName += " (2)";
			}
			playEft(ResName);
		}else if(cardType == 7 || cardType == 8 || cardType == 9){
			string[] ary = randDc["airplane"];
			string ResName = "sound/";
			int randValue = Random.Range(0,ary.Length);
			ResName += ary[randValue];
			if(!isFemale){
				ResName += " (2)";
			}
			playEft(ResName);
		}

	}

	public override void playEft (string clipPath)
	{
		AudioClip clip = Resources.Load<AudioClip>(clipPath);
		if(clip == null){
			string[] cutStr = clipPath.Split('/');
			string fixedPath = "GameDDZ";
			if(cutStr.Length > 1){
				for(int i=0; i< cutStr.Length-1; i++){
					fixedPath += ("/"+ cutStr[i]);
				}
			}
			clip = SimpleFramework.Util.LoadAsset(fixedPath,cutStr[cutStr.Length-1]) as AudioClip;
		}
		playEft(clip);
	}

	public override void chat(int id){
		if(!personSound)return;
		string ResName = "sound/"+resDc[ 3000 + id ];
		playEft(ResName);
	}

	public override void playRandEftDc (string key, bool isFemale)
	{
		if(!personSound)return;
		string[] ary = randDc[key];
		string resName = "sound/";
		int randValue = Random.Range(0,ary.Length);
		resName += ary[randValue];
		if(!isFemale){
			resName += " (2)";
		}
		playEft(resName);
	}

	public override void changeBGM (bool is131)
	{
		if(is131){
			AudioClip clip = SimpleFramework.Util.LoadAsset("GameDDZ/sound","BGM_ddz_131") as AudioClip;
			bgm = clip;
		}
		base.playBgm();
	}

	public override void playBgm ()
	{
		
	}

}
