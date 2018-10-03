using UnityEngine;
using System.Collections;

public class GameEntityFTWZ : GameEntity {
	
	// 五张
	public GameEntityFTWZ () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "FTWZ";
		gameID = "1043";//1043
		gameTypeIDs = "1";
		gameScene = "GameFTWZ";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_2;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "    飞腾五张是一款地方性、游戏速度极快、刺激的棋牌游戏。游戏可以由2人到6人同时进行，系统发给玩家每人5张牌，用户将根据5张牌进行排列组合，牌型大的一方获胜。游戏公平公正，游戏节奏快，深得广大玩家的喜爱。";
	}
}
