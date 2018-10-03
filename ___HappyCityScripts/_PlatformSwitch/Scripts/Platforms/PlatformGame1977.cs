using UnityEngine;
using System.Collections.Generic;

public class PlatformGame1977 : PlatformEntity {
    private Dictionary<string, GameData> m_GameData = new Dictionary<string, GameData>() {
        { "srnn",new GameData { wxAppId = "wx34dd29a7afb1f4f4", wxAppSecret = "178d364d4b38294fc8f6aeacc8358aab"} },
        { "dznn",new GameData { wxAppId = "wxf061fa352de2a275", wxAppSecret = "8bac4a783e76cc80309d3284ee559098"} }, 
        { "tbnn",new GameData { wxAppId = "wx8088e326bc6c2227", wxAppSecret = "32939d1c7eefa31bfce024940a951137"} }, 
        { "fkby",new GameData { wxAppId = "wx69b9a7a4bdd980b0", wxAppSecret = "1458ffd49ed70bafb2697711685c248c"} },
    };

    //	// ------ Platform_Game1977 ------	
    //	public PlatformGame1977 () {
    //		platformName = "1977game";
    //		hostURL = "http://b.1977game.com";
    //		rechargeURL = "";
    //		feedbackContent = "\u5ba2\u670dQQ: 4000168747";	//客服QQ
    //		unityMoney = "\u6b22\u4e50\u8c46";	// 欢乐豆
    //		downloadURL = PlayerPrefs.GetString(KeyOfDownloadURL(), "http://download.hxdgame.com/download/unity/1977game/");
    //		game_HostURL = "http://download.hxdgame.com/api/787go.conf";
    //		web_HostURL = "http://download.hxdgame.com/api/787go-web.conf";
    //	}

    // ------ Platform_Game1977 ------	
    public PlatformGame1977() {

		aliAppId = "2016090701862162";
        wxAppId = "wxcd00aad1c9746cfe";
        wxAppSecret = "dec310f07cfd4b3b6c366eb2dbe322d9";
        wxShareUrl = "http://downnwe.game597.com/app/";
        wxShareDesciption = "游戏描述信息";
		wxPayAppId = "wxbe68985ca99cb404";
		wxPayAppSecret = "2c866a73475b6eb09117fae5b107bd43";

        string singleGameName = Utils.bundleId.Substring(0, Utils.bundleId.IndexOf("."));
        if (m_GameData.ContainsKey(singleGameName))
        {
            wxAppId = m_GameData[singleGameName].wxAppId;
            wxAppSecret = m_GameData[singleGameName].wxAppSecret;
        }

		wxShareAppIds = new string[]{"wx7cc664511aa4f0ab","wxaa4a3aacf47e571f","wx0398c34988a9d08f","wx878dd161efa39963"};
        game_URL_ipv6 = "9009.game597.cn:9009";
        hostURL_ipv6 = "9011.game597.cn:9011";
        isSocketLobby = true;
        instantUpdateUrl = new string[] {
            "http://oss.aliyuncs.com/ggdownload/game597/InstantUpdate/",
            //"http://oss.aliyuncs.com/bak998899/InstantUpdate/"
        };
        platformName = "1977game2";
		hostURL = "http://pay.6666.cn";
        hostURL_socketLobby = "http://pay.6666.cn";
        rechargeURL = "";
		feedbackContent = "\u5ba2\u670dQQ: 4000168747";	//客服QQ
		unityMoney = "\u6b22\u4e50\u8c46";	// 欢乐豆
		downloadURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/1977game/";
		//game_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/787go.conf";
        game_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/mob787goa.conf";
        //web_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/787go-web.conf";
        web_HostURL =  "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/mob787goa-web.conf";

        //wxAppId = "wxcd00aad1c9746cfe";

        #region 已过时弃用
        //#if UNITY_IPHONE
        //#if _IsEnterprise
        //		config_urls = new string[]{
        //			"http://ggdownload.oss-cn-hangzhou.aliyuncs.com/unity/config888.xml",
        //            "http://mmdownload.oss-cn-hangzhou.aliyuncs.com/config888.xml",
        //            "http://bb.game597.cn/unity/config888.xml",
        //            "http://dong888.oss-cn-hangzhou.aliyuncs.com/597game/config888.xml",
        //            "http://bb.597game.net/download/unity/config888.xml",
        //            "http://bb.597game.co/download/unity/597game/config888.xml",
        //		};
        //#else
        //		config_urls = new string[]{
        //			"http://ggdownload.oss-cn-hangzhou.aliyuncs.com/unity/config.xml",
        //            "http://mmdownload.oss-cn-hangzhou.aliyuncs.com/unity/config.xml",
        //            "http://bb.game597.cn/unity/config.xml",
        //            "http://dong888.oss-cn-hangzhou.aliyuncs.com/597game/config.xml",
        //            "http://bb.597game.net/download/unity/config.xml",
        //            "http://bb.597game.co/download/unity/597game/config.xml",
        //		};
        //#endif
        //#else
        //        config_urls = new string[]{
        //            "http://ggdownload.oss-cn-hangzhou.aliyuncs.com/unity/config999.xml",
        //            "http://mmdownload.oss-cn-hangzhou.aliyuncs.com/unity/config999.xml",
        //            "http://bb.game597.cn/unity/config999.xml",
        //            "http://dong888.oss-cn-hangzhou.aliyuncs.com/597game/config999.xml",
        //            "http://bb.597game.net/download/unity/config999.xml",
        //            "http://bb.597game.co/download/unity/597game/config999.xml",
        //        };
        //#endif

        //#if UNITY_IPHONE
        //#if _IsEnterprise
        //		config_urls = new string[]{
        //			//"http://ggdownload.oss-cn-hangzhou.aliyuncs.com/unity/config888.xml",
        //   //         "http://mmdownload.oss-cn-hangzhou.aliyuncs.com/config888.xml",
        //   //         "http://bb.game597.cn/unity/config888.xml",
        //   //         "http://dong888.oss-cn-hangzhou.aliyuncs.com/597game/config888.xml",
        //   //         "http://bb.597game.net/download/unity/config888.xml",
        //   //         "http://bb.597game.co/download/unity/597game/config888.xml",

        //            "http://cheng8102.oss-cn-hangzhou.aliyuncs.com/config888.xml",
        //            "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/1977game/config888.xml",
        //            "http://xxtwv.oss-cn-hangzhou.aliyuncs.com/unity597/config888.xml",
        //            "http://bb.game597.com/597unity/config888.xml",
        //            "http://gxin.oss-cn-hangzhou.aliyuncs.com/597unity/config888.xml",
        //            "http://bb.game597.net/597unity/config888.xml",
        //            "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/597unity/config888.xml",
        //		};
        //#else
        //		config_urls = new string[]{
        //			//"http://ggdownload.oss-cn-hangzhou.aliyuncs.com/unity/config.xml",
        //   //         "http://mmdownload.oss-cn-hangzhou.aliyuncs.com/unity/config.xml",
        //   //         "http://bb.game597.cn/unity/config.xml",
        //   //         "http://dong888.oss-cn-hangzhou.aliyuncs.com/597game/config.xml",
        //   //         "http://bb.597game.net/download/unity/config.xml",
        //   //         "http://bb.597game.co/download/unity/597game/config.xml",

        //            "http://cheng8102.oss-cn-hangzhou.aliyuncs.com/config.xml",
        //            "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/1977game/config.xml",
        //            "http://xxtwv.oss-cn-hangzhou.aliyuncs.com/unity597/config.xml",
        //            "http://bb.game597.com/597unity/config.xml",
        //            "http://gxin.oss-cn-hangzhou.aliyuncs.com/597unity/config.xml",
        //            "http://bb.game597.net/597unity/config.xml",
        //            "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/597unity/config.xml",
        //		};
        //#endif
        //#else
        //        config_urls = new string[]{
        //            //"http://ggdownload.oss-cn-hangzhou.aliyuncs.com/unity/config999.xml",
        //            //"http://mmdownload.oss-cn-hangzhou.aliyuncs.com/unity/config999.xml",
        //            //"http://bb.game597.cn/unity/config999.xml",
        //            //"http://dong888.oss-cn-hangzhou.aliyuncs.com/597game/config999.xml",
        //            //"http://bb.597game.net/download/unity/config999.xml",
        //            //"http://bb.597game.co/download/unity/597game/config999.xml",

        //            "http://cheng8102.oss-cn-hangzhou.aliyuncs.com/config999.xml",
        //            "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/1977game/config999.xml",
        //            "http://xxtwv.oss-cn-hangzhou.aliyuncs.com/unity597/config999.xml",
        //            "http://bb.game597.com/597unity/config999.xml",
        //            "http://gxin.oss-cn-hangzhou.aliyuncs.com/597unity/config999.xml",
        //            "http://bb.game597.net/597unity/config999.xml",
        //            "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/597unity/config999.xml",
        //        };
        //#endif
        #endregion 已过时弃用

		config_urls = new string[]{
            //"http://download.game597.com/597unity/config.xml",
            //--------2016- 12-31 Alien 注释
            /*
            "http://bb.game597.cn/597unity/config.xml",
            "http://bb.game597.net/597unity/config.xml",
            "http://bb.game131.com/597unity/config.xml",
            "http://dow1.game597.net/597unity/config.xml",
            "http://dow2.game597.net/597unity/config.xml",
            "http://dow3.game597.net/597unity/config.xml",
            "http://dow4.game597.net/597unity/config.xml",
            "http://dow5.game597.net/597unity/config.xml",
            "http://dow6.game597.net/597unity/config.xml",
            "http://dow7.game597.net/597unity/config.xml",
            "http://dow8.game597.net/597unity/config.xml",
            "http://dow9.game597.net/597unity/config.xml",
            "http://dow10.game597.net/597unity/config.xml"
			*/

            //---------2016-12-31  Alien 写入 597手机新客户端   
            "http://download.game597.cc/unity/config.xml",
			"http://bb.game597.cn/unity/config.xml",
			"http://bb.game597.net/unity/config.xml",
			"http://bb.game131.com/unity/config.xml",
			"http://bb.6666.cn/unity/config.xml",
			"http://bb.game131.cn/unity/config.xml",
			"http://bb.game510k.com/unity/config.xml",
			"http://dow1.game597.net/unity/config.xml",
			"http://dow2.game597.net/unity/config.xml",
			"http://dow3.game597.net/unity/config.xml",
			"http://dow4.game597.net/unity/config.xml",
			"http://dow5.game597.net/unity/config.xml",
			"http://dow6.game597.net/unity/config.xml",
			"http://oss.aliyuncs.com/keyi518/unity/config.xml",
		};

        FixConfigUrls(config_urls);
    }
}

