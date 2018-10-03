using UnityEngine;
using System.Collections;

public class GameEntityCJFKBY : GameEntity {

    // Game_SDBY
    public GameEntityCJFKBY() {
		versionCode = 45;
		versionName = "V3.1.1";
		gameName = "CJFKBY";
        gameID = "1067";//1067
        //farmID = "1073";
        gameTypeIDs = "13,14,15,16,17,18,19";
        gameScene = "GameFKBY";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_4;
		gameGuideScene = "GameDSBYGuide";
		gameGuideContent = "";
    }
	
	public override void ShowGameGuide () {
        //Application.LoadLevel(GameGuideScene);
        Utils.LoadLevelGameGUI(GameGuideScene);
    }

    public static string farmID = "1073";
}
