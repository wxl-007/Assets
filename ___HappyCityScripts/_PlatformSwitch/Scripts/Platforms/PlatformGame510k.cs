using UnityEngine;
using System.Collections;

public class PlatformGame510k : PlatformEntity {
	
	// ------ Platform_Game1977 ------	
	public PlatformGame510k () {
		aliAppId = "2016090701862162";
        wxAppId = "wx597d9f18438be72c";
        wxAppSecret = "6339e8b870a0be5684edb16001eef4c2";
        wxShareUrl = "http://game510k.com/app/";
        wxShareDesciption = "游戏描述信息";
		wxShareAppIds = new string[]{};
        game_URL_ipv6 = "9006.6666.cn:9006";
        hostURL_ipv6 = "9007.6666.cn:9007";
        isSocketLobby = true;
        instantUpdateUrl = new string[] {
            //"http://oss.aliyuncs.com/ggdownload/game510k/InstantUpdate/",
			"http://oss.aliyuncs.com/hhehe/510klua/InstantUpdate/",
            //"http://oss.aliyuncs.com/bak998899/InstantUpdate/"
        };
        platformName = "game510k";
		hostURL = "http://b.game510k.com";
        hostURL_socketLobby = "http://139.224.31.127:9520";
		rechargeURL = "";
        feedbackContent = "\u5ba2\u670dQQ: 1400195533";	//客服QQ
		unityMoney = "\u6b22\u4e50\u8c46";	// 欢乐豆
        downloadURL = "http://download.hxdgame.com/download/unity/game510k/";
        game_HostURL = "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/api/mobile.conf";
        web_HostURL = "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/api/website.conf";
        //        config_urls = new string[] {"http://webdownload.game510k.net/api/update999.xml"};        

        config_urls = new string[]{
            //"http://download.game510k.net/update/config.xml",

            "http://download.game510k.net/update/config.xml",
            "http://bb.game597.cn/update/config.xml",
            "http://bb.game131.com/update/config.xml",
            "http://bb.game597.com/update/config.xml",
            "http://webdownload.game510k.net/update/config.xml",
            "http://dow1.game510k.net/update/config.xml",
            "http://dow2.game510k.net/update/config.xml",
            "http://dow3.game510k.net/update/config.xml",
            "http://dow4.game510k.net/update/config.xml",
            "http://dow5.game510k.net/update/config.xml",
            "http://dow6.game510k.net/update/config.xml",
            "http://dow7.game510k.net/update/config.xml",
            "http://dow8.game510k.net/update/config.xml",
            "http://dow9.game510k.net/update/config.xml",
            "http://dow10.game510k.net/update/config.xml"
        };

        FixConfigUrls(config_urls);
    }
}
