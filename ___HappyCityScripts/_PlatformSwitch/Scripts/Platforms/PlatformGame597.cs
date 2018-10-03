using UnityEngine;
using System.Collections.Generic;

public class PlatformGame597 : PlatformEntity {

    private Dictionary<string, GameData> m_GameData = new Dictionary<string, GameData>() {
        { "srnn",new GameData { wxAppId = "wx34dd29a7afb1f4f4", wxAppSecret = "178d364d4b38294fc8f6aeacc8358aab"} },
        { "dznn",new GameData { wxAppId = "wxf061fa352de2a275", wxAppSecret = "8bac4a783e76cc80309d3284ee559098"} },
        { "tbnn",new GameData { wxAppId = "wx8088e326bc6c2227", wxAppSecret = "32939d1c7eefa31bfce024940a951137"} }, 
        { "fkby",new GameData { wxAppId = "wx69b9a7a4bdd980b0", wxAppSecret = "1458ffd49ed70bafb2697711685c248c"} },
    };

    // ------ Platform_Game1977 ------	
    public PlatformGame597() {
		aliAppId = "2016090701862162";
        wxAppId = "wxcd00aad1c9746cfe";
        wxAppSecret = "dec310f07cfd4b3b6c366eb2dbe322d9";
        wxShareUrl = "http://downnwe.game597.com/app/";
        wxShareDesciption = "游戏描述信息";
		wxPayAppId = "wxbe68985ca99cb404";
		wxPayAppSecret = "2c866a73475b6eb09117fae5b107bd43";

        string singleGameName = Utils.bundleId.Substring(0,Utils.bundleId.IndexOf("."));
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
        game_URL = "43.227.195.72:9009";
		rechargeURL = "";
		feedbackContent = "\u5ba2\u670dQQ: 4000168747";	//客服QQ
		unityMoney = "\u6b22\u4e50\u8c46";	// 欢乐豆
		downloadURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/1977game/";
		//game_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/787go.conf";
        game_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/mob787goa.conf";
        //web_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/787go-web.conf";
        web_HostURL =  "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/mob787goa-web.conf";

		config_urls = new string[]{
			//"http://download.game597.com/unity/config.xml",
            "http://bb.game597.cn/unity/config.xml",
            "http://bb.game597.net/unity/config.xml",
            "http://bb.game131.com/unity/config.xml",
            "http://dow1.game597.net/unity/config.xml",
            "http://dow2.game597.net/unity/config.xml",
            "http://dow3.game597.net/unity/config.xml",
            "http://dow4.game597.net/unity/config.xml",
            "http://dow5.game597.net/unity/config.xml",
            "http://dow6.game597.net/unity/config.xml",
            "http://dow7.game597.net/unity/config.xml",
            "http://dow8.game597.net/unity/config.xml",
            "http://dow9.game597.net/unity/config.xml",
            "http://dow10.game597.net/unity/config.xml"
		};

        FixConfigUrls(config_urls);
    }
}
