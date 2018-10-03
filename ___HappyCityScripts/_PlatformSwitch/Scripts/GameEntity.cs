using UnityEngine;
using System.Collections;

public class GameEntity {

	protected int versionCode;			// 游戏版本号
	protected string versionName;		// 游戏版本
	protected string gameID;			// 游戏ID【服务端】
	protected string gameTypeIDs;		// 游戏类型【服务端】
	protected string gameScene;			// 游戏场景名称
	protected GameType gameIconType;	// 游戏类型【牌桌列表】
	protected DeskType gameDeskType;	// 游戏玩家数【牌桌列表】
	protected string gameGuideScene;	// 游戏帮助场景名称
	protected string gameGuideContent;	// 游戏帮助内容
    protected string bundleId;
    protected bool isGameGuideAdditive = true;


    protected string gameName;			// 游戏名字
	

	public int VersionCode { get { return versionCode; } set { versionCode = value; } }
	public string VersionName { get { return versionName; } set { versionName = value; } }
	public string GameID { get { return gameID; } set{ gameID = value; } }
	public string GameTypeIDs { get { return gameTypeIDs; } set{ gameTypeIDs = value; } }
	public string GameScene { get { return gameScene; } set{ gameScene = value; } }
	public GameType GameIconType { get { return gameIconType; } set{ gameIconType = value; } }
	public DeskType GameDeskType { get { return gameDeskType; } set { gameDeskType = value; } }
    public string GameGuideScene { get { return gameGuideScene; } set { gameGuideScene = value; } }
    public string GameGuideContent { get { return gameGuideContent; } set { gameGuideContent = value; } }
    public bool IsGameGuideAdditive { get { return isGameGuideAdditive; } set { isGameGuideAdditive = value; } }

    public string GameName { get { return gameName; } set { gameName = value; } }
    public string BundleId { get { return bundleId; } }


    public string ChekcVersionURL() {
        string gameName = Utils.GameName;
#if UNITY_IPHONE && _IsEnterprise
		string versionUrl = PlatformGameDefine.playform.DownloadURL + "version_" + gameName + "_IOS.txt";
#elif UNITY_IPHONE && _IsAppStore
		string versionUrl = PlatformGameDefine.playform.DownloadURL + "version_" + gameName + "_AppStore.txt";
#elif UNITY_STANDALONE_OSX
        string versionUrl = PlatformGameDefine.playform.DownloadURL + "version_" + gameName + "_OSX.txt";
#else
        string versionUrl = PlatformGameDefine.playform.DownloadURL + "version_" + gameName + "_Android.txt";
#endif
        return versionUrl;
	}

	// 开始游戏，进入游戏界面
	public virtual void StartGame () {
        //if ("GameMXNN" == GameScene || "GameTBNN" == GameScene || "GameSRNN" == GameScene) {
        //    Utils.LoadLevelGameGUI(GameScene, GameScene+"Panel");// HallConsts.GameModule_mxnn, "GameMXNNPanel");
        //}
        //else
        //{
        //Application.LoadLevel(GameScene);

        Utils.LoadLevelGameGUI(GameScene);
        //}
	}

	// 显示帮助界面
	public virtual void ShowGameGuide () {
        //Application.LoadLevelAdditive(GameGuideScene);
        //Utils.LoadLevelAdditiveGUI(GameGuideScene);
        Utils.LoadLevelGUI(GameGuideScene,false, IsGameGuideAdditive);
	}

    // 通过游戏id获得游戏实例信息510k
    public static GameEntity GameEntityForID(int gid)
    {
        switch (gid)
        {
            case 1029: return new GameEntity30M();// 30秒
            case 1056: return new GameEntityBBDZ();// 百倍对战牛牛
            case 1027: return new GameEntityBRLZ();// 百人两张
            case 1039: return new GameEntityBYDS();// 大圣捕鱼
            case 1043: return new GameEntityFTWZ();// 飞腾五张
            case 1060: return new GameEntityFTWZBS();// 飞腾五张比赛
            case 1038: return new GameEntityHPLZ();// 火拼两张
            case 1031: return new GameEntityNNBR();// 百人牛牛 / 明星牛牛
            case 1034: return new GameEntityNNDZ();// 对战牛牛
            case 1037: return new GameEntityNNJQ();// 激情牛牛
            case 1055: return new GameEntityNNKP();// 看牌牛牛
            case 1042: return new GameEntityNNSR();// 四人牛牛
            case 1036: return new GameEntityNNTB();// 通比牛牛
            case 1062: return new GameEntityTBWZ();// 通比五张
            case 1053: return new GameEntityXJ();// 多人小九
#if Platform_510k
            case 1046: return new GameEntityLKPY();//李逵劈鱼
            case 1033: return new GameEntityJCBY();//金蟾捕鱼
            case 1049: return new GameEntityNZNH();//哪吒脑海
#endif
            default: return null;
        }
    }
}

/// <summary>
/// 与GameEntity 的区别是 这里的数据与游戏所在平台相关,不同平台 数据不同
/// </summary>
public class GameData
{
    public string wxAppId;
    public string wxAppSecret;
}