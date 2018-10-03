using UnityEngine;
using System.Collections;

public class GameEntityTBBY : GameEntity{

	// NN_TBBY
	public GameEntityTBBY () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "TBBY";
		gameID = "1064";
		gameTypeIDs = "1";
		gameScene = "GameTBBY";
		gameIconType = GameType.dice;
		gameDeskType = DeskType.DeskType_6;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "通比捕鱼是一款地方性、游戏速度极快、刺激的棋牌游戏。游戏可以由2人到6人同时进行，共16条鱼，不分庄闲，系统根据玩家所摇到的鱼的种类给予分值，分值最高的一方获胜。通比捕鱼使用固定注（即大家押注金额相同），没有下注，公平公正，游戏节奏快，深得广大玩家的喜爱。";
	}
}
