using UnityEngine;
using System.Collections;

public class GameEntityBYDS : GameEntity {
	
	// Game_SDBY
	public GameEntityBYDS () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "DSBY";
		gameID = "1039";
		gameTypeIDs = "1";
		gameScene = "GameDSBYLoad";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_6;
		gameGuideScene = "GameDSBYGuide";
		gameGuideContent = "";
	}
	
	public override void ShowGameGuide () {
		//Application.LoadLevel(GameGuideScene);
		Utils.LoadLevelGUI(GameGuideScene);
    }
}
