using UnityEngine;
using System.Collections;

public class GameEntityDDZ : GameEntity {
	
	// 斗地主游戏
    public GameEntityDDZ()
    {
        versionCode = 45;
        versionName = "V3.5.0";
        gameName = "DDZ";
        gameID = "1006";
        gameTypeIDs = "1";
        gameScene = "GameDDZ";
        gameIconType = GameType.Poker;
        gameDeskType = DeskType.DeskType_3;
        gameGuideScene = "GuideDialog";
        gameGuideContent = "斗地主，其参与人数应在两人以上。此游戏要用到除去部分牌后的剩余40张牌，每轮要发牌，一次洗牌过后可以发四轮的牌，和其他某些纸牌游戏一样，此游戏按照比较大小的方法来确定庄家，以及决定胜负。";
    }
}
