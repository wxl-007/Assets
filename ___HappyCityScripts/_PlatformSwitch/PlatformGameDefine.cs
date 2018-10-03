using UnityEngine;
using System.Collections;

public class PlatformGameDefine {
    /* ==================== Platform ==================== */
    //	public static PlatformEntity playform = new PlatformTest();			// CS



#if Platform_597wangwei
    public static PlatformEntity playform = new PlatformGame597();		// Game1977   747   597
#elif Platform_131
    public static PlatformEntity playform = new PlatformGame407();      // game1517 407 131
#elif Platform_510k
    public static PlatformEntity playform = new PlatformGame510k();		// game510k
#elif Platform_7997
    public static PlatformEntity playform = new PlatformGame7997();     // Game7997
#else //Platform_597
    public static PlatformEntity playform = new PlatformGame1977();		// Game1977   747   597
#endif

    //public static ParamsEntity paramsEntity = new ParamsEntity();

    //	public static PlatformEntity playform = new PlatformGame1977Backup(); // Game1977   7997


    /* ==================== Game ==================== */

    //牛牛类
    //	public static GameEntity game = new GameEntityNNSR();		// 四人牛牛

    //	public static GameEntity game = new GameEntityNNJQ();		// 激情牛牛

    //	public static GameEntity game = new GameEntityNNDZ();		// 对战牛牛

    //	public static GameEntity game = new GameEntityBBDZ();		// 百倍对战牛牛

    //	public static GameEntity game = new GameEntityNNKP();		// 看牌牛牛

    //	public static GameEntity game = new GameEntityNNTB();		// 通比牛牛
    // public static GameEntity game = new GameEntitySRPS();      //四人拼十

    //百人类
    //public static GameEntity game = new GameEntityNNBR();		// 百人牛牛 / 明星牛牛

    //	public static GameEntity game = new GameEntity30M();		// 30秒

    //	public static GameEntity game = new GameEntityBRLZ();		// 百人两张

    //	public static GameEntity game = new GameEntityXJ();		// 多人小九


    //	public static GameEntity game = new GameEntityFTWZ();		// 飞腾五张

    //	public static GameEntity game = new GameEntityFTWZBS();		// 飞腾五张比赛

    //	public static GameEntity game = new GameEntityBYDS();		// 大圣捕鱼

    //	public static GameEntity game = new GameEntityHPLZ();		// 火拼两张

    //public static GameEntity game = new GameEntityTBWZ();		// 通比五张

    //public static GameEntity game = new GameEntityTBTW();		//通比骰王

    //public static GameEntity game = new GameEntityDDZ();        // ddz

    private static GameEntity m_game;
    public static GameEntity game {
        get {
            if(m_game == null)
            {
                if(Utils._IsSingleGame)
                {
                    m_game = new GameEntityDDZ();        // ddz
                }else
                    m_game = new GameEntityAll();        // android 大包
            }
            return m_game;
        }
        set
        {
            m_game = value;
        }
    } 

    //   public static GameEntity game = new GameEntityTBBY();        //通比捕鱼

    /* ==================== Other ==================== */
    public static string CLIENT_VERSION = "V4.7";				// 平台包含多款游戏时，显示版本号
}
