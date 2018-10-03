using UnityEngine;
using System.Collections;

public class PlatformGame407 : PlatformEntity {

    // ------ Platform_Game1977 ------	game1517 407 131
    public PlatformGame407 () {
		aliAppId = "2016090701862162";
        wxAppId = "wxd4d1e30671770ff4";
        wxAppSecret = "b9456c1ed9b2e595194b3ba9db42675e";
        wxShareUrl = "https://www.game131.com/download/";
        wxShareDesciption = "游戏描述信息";
		wxShareAppIds = new string[]{};
        game_URL_ipv6 = "9013.game597.cn:9013";
        hostURL_ipv6 = "9012.game597.cn:9012";
        isSocketLobby = true;
        instantUpdateUrl = new string[] {
            //"http://ggdownload.oss-cn-hangzhou.aliyuncs.com/game597/InstantUpdate/",
            "http://oss.aliyuncs.com/ggdownload/game131/InstantUpdate/",
        };
		platformName = "game407";
        hostURL = "http://b.game407.com";
        hostURL_socketLobby = "http://pay.game131.com";
        rechargeURL = "";
		feedbackContent = "\u5ba2\u670dQQ: 1819407407";	//客服QQ
		unityMoney = "\u6b22\u4e50\u8c46";	// 欢乐豆
		downloadURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game407/";
		game_HostURL = "http://oss.aliyuncs.com/woyou919/api/mgylc.conf";
		web_HostURL = "http://oss.aliyuncs.com/woyou919/api/131socket.conf";


        #region 已弃用
        //#if UNITY_IPHONE
        //#if _IsEnterprise
        //		config_urls = new string[]{
        //            "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/config888.xml",
        //            "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game407/config888.xml",
        //            "http://b.game131.com/unity/config888.xml",
        //            "http://b.game131.cc/unity/config888.xml",
        //            "http://b.game131.net/unity/config888.xml"
        //		};
        //#else
        //        config_urls = new string[]{
        //            "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/config.xml",
        //            "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game407/config.xml",
        //            "http://b.game131.com/unity/config.xml",
        //            "http://b.game131.cc/unity/config.xml",
        //            "http://b.game131.net/unity/config.xml"
        //        };
        //#endif
        //#else
        //        config_urls = new string[]{
        //            "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/config999.xml",
        //            "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game407/config999.xml",
        //            "http://b.game131.com/unity/config999.xml",
        //            "http://b.game131.cc/unity/config999.xml",
        //            "http://b.game131.net/unity/config999.xml"
        //        };
        //#endif
        #endregion 已弃用

        config_urls = new string[]{
            //"http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/config.xml",
            //"http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game407/config.xml",
            //"http://b.game131.com/unity/config.xml",
            //"http://b.game131.cc/unity/config.xml",
            //"http://b.game131.net/unity/config.xml"

            //"http://131.game597.com/131newunity/config.xml",
            "http://bb.game131.com/131newunity/config.xml",
            "http://bb.game131.cn/131newunity/config.xml",
            "http://131.game597.net/131newunity/config.xml",
            "http://131.game597.cn/131newunity/config.xml",
            "http://131.597game.net/131newunity/config.xml",
            "http://dow1.game131.com/131newunity/config.xml",
            "http://dow2.game131.com/131newunity/config.xml",
            "http://dow3.game131.com/131newunity/config.xml",
            "http://dow4.game131.com/131newunity/config.xml",
            "http://dow5.game131.com/131newunity/config.xml",
            "http://dow6.game131.com/131newunity/config.xml",
            "http://dow7.game131.com/131newunity/config.xml",
            "http://dow8.game131.com/131newunity/config.xml",
            "http://dow9.game131.com/131newunity/config.xml",
            "http://dow10.game131.com/131newunity/config.xml",
        };

        FixConfigUrls(config_urls);
    }
}
