using UnityEngine;
using System.Collections;

public class GameEntityNZNH : GameEntity
{

    // Game_SDBY
    public GameEntityNZNH()
    {
        versionCode = 31;
        versionName = "V2.1.1";
        gameName = "JCBY";
        gameID = "1049";
        gameTypeIDs = "1";
        gameScene = "GameNZNHLoad";
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
