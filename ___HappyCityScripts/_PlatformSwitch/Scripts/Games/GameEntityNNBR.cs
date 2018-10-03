using UnityEngine;
using System.Collections;

public class GameEntityNNBR : GameEntity {
	
	// NN_BRNN
	public GameEntityNNBR () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "BRNN";
		gameID = "1031";
		gameTypeIDs = "1";
		gameScene = "GameMXNN";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_All;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "又称斗牛游戏取材流行于浙江一带的牛牛扑克牌游戏，要求取一副牌，庄位和每个闲位分别发5张牌，然后每个闲位的牌跟庄位的牌进行比较，最后判断双方之间的大小，牌大者胜";
	}
}
