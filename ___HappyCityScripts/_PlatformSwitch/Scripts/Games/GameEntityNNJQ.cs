using UnityEngine;
using System.Collections;

public class GameEntityNNJQ : GameEntity {
	
	// NN_JQNN
	public GameEntityNNJQ () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "JQNN";
		gameID = "1037";
		gameTypeIDs = "1";
		gameScene = "GameJQNN";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_4;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "    激情牛牛是流行于浙南一带的游戏，玩家要是可以将手中的五张牌，以三张一卡、两张一卡的形势排列成10的倍数，此种牌就被称为“牛牛”，属最大牌型。采用随机无庄模式，固定注，公平公正，游戏节奏快，深得广大玩家的喜爱。";
	}
}
