using UnityEngine;
using System.Collections;

public class GameEntityBRLZ : GameEntity {
	
	// 百人两张
	public GameEntityBRLZ () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "BRLZ";
		gameID = "1027";
		gameTypeIDs = "1";
		gameScene = "GameBRLZ";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_All;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "二张起源于中国，在民间流传较广，属于娱乐消遣游戏。又称[牌九]。每个玩家与庄家的牌比较大小，按照“比较规则”决定胜负。是一种既比 胆略又比智慧的游戏，现实中不同的心理因素之间的较量成为了该游戏的一大特色。";
	}
}
