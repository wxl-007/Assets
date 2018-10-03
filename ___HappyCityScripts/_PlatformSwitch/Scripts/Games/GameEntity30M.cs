using UnityEngine;
using System.Collections;

public class GameEntity30M : GameEntity {
	
	// 30秒
	public GameEntity30M () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "30M";
		gameID = "1029";
		gameTypeIDs = "1";
		gameScene = "Game30M";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_All;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "快乐30秒，又称将相和或龙虎斗。是一种倍受青睐的扑克游戏。中世纪它起源于意大利,又在意大利语中的意思是“零”，因为人像和10 – 字样的牌是许多游戏中的大牌点，但在将相和中都算作0点。";
	}
}
	