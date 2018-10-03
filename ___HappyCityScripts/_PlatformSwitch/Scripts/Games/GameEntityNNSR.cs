using UnityEngine;
using System.Collections;

public class GameEntityNNSR : GameEntity {
	
	// NN_SRNN
	public GameEntityNNSR () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "SRNN";
		gameID = "1042";
		gameTypeIDs = "1";
		gameScene = "GameSRNN";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_4;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "    《四人斗牛》又名斗牛、顶牛，原本是流行于我国浙南一带的牌类游戏玩法，由四人共同参与游戏，玩家将根据5张牌进行排列组合，并且闲家一一和庄家进行大小比较确定胜负。 ";
		
	}
}
