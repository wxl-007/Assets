using UnityEngine;
using System.Collections;

public class GameEntityLKPY : GameEntity
{

    // Game_LKPY
    public GameEntityLKPY()
    {
        versionCode = 31;
        versionName = "V2.1.1";
        gameName = "LKPY";
        gameID = "1046";
        gameTypeIDs = "1";
        gameScene = "GamelLKPYLoad";
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
