using UnityEngine;
using System.Collections;

public class GameEntityBBDZ : GameEntity {
	
	// Game_SDBY
	public GameEntityBBDZ () {
		versionCode = 41;
		versionName = "V3.1.1";
		gameName = "BBDZ";
		gameID = "1056";
		gameTypeIDs = "1";
		gameScene = "GameBBDZ";
		gameIconType = GameType.Poker;
		gameDeskType = DeskType.DeskType_2;
		gameGuideScene = "GuideDialog";
		gameGuideContent = "百倍对战牛牛是流行于浙南一带的游戏，游戏有庄闲两个玩家参与游戏。玩家要是可以将手中的五张牌，以三张一卡、两张一卡的形势排列成10的倍数，此种牌就被称为“牛牛”，属最大牌型。采用轮流上庄的模式，公平公正，游戏节奏快，深得广大玩家的喜爱。";
	}

    public override void ShowGameGuide()
    {
        //Application.LoadLevel(GameGuideScene);
        Utils.LoadLevelGUI(GameGuideScene);
    }
}
