using UnityEngine;
using System.Collections;

public class GameEntityXJ : GameEntity {
	
	// 小九游戏
	public GameEntityXJ () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "XJ";
		gameID = "1053";
		gameTypeIDs = "1";
		gameScene = "GameXJ";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_All;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "多人小九是小九系列游戏的一种，其参与人数应在两人以上。此游戏要用到除去部分牌后的剩余40张牌，每轮要发牌，一次洗牌过后可以发四轮的牌，和其他某些纸牌游戏一样，此游戏按照比较大小的方法来确定庄家，以及决定胜负。";
	}
}
