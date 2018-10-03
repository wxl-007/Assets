using UnityEngine;
using System.Collections;

public class GameEntityJCBY : GameEntity
{

    // Game_SDBY
    public GameEntityJCBY()
    {
        versionCode = 31;
        versionName = "V2.1.1";
        gameName = "JCBY";
        gameID = "1033";
        gameTypeIDs = "1";
        gameScene = "GameJCBYLoad";
        gameIconType = GameType.dice;
        gameDeskType = DeskType.DeskType_6;
        gameGuideScene = "GameDSBYGuide";
        gameGuideContent = "";
    }

    public override void ShowGameGuide()
    {
        Application.LoadLevel(GameGuideScene);
    }
}
