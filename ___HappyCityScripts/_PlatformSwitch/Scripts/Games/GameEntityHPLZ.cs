using UnityEngine;
using System.Collections;

public class GameEntityHPLZ : GameEntity {
	
	// Game_SDBY
	public GameEntityHPLZ () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "HPLZ";
		gameID = "1038";
		gameTypeIDs = "1";
		gameScene = "GameHPLZ";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_2;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "火拼两张游戏中常见的术语有至尊王、黑桃、红桃、梅花、方块。点数牌：任何不属于对子牌、特殊牌型的,取2张牌之和的个位数为最后点数,大小依次排列9点>8点>7点>6点>5点>4点>3点>2点>1点>0点";
	}
	
	public override void ShowGameGuide () {
		//Application.LoadLevel(GameGuideScene);
		Utils.LoadLevelGUI(GameGuideScene);
    }
}
