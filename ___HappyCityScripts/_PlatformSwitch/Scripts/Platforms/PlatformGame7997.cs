using UnityEngine;
using System.Collections;

public class PlatformGame7997 : PlatformEntity {
	
	// ------ Platform_Game7997 ------	
	public PlatformGame7997 () {
        isSocketLobby = true;
        //instantUpdateUrl = "http://oss.aliyuncs.com/bak998899/test/";
        instantUpdateUrl = new string[] {
            "http://ggdownload.oss-cn-hangzhou.aliyuncs.com/game597/InstantUpdate/",
        };

        platformName = "game7997";
		hostURL = "http://b.game7997.com";//web 54.254.211.231:80 //game 54.254.229.244:8211
        hostURL_socketLobby = "http://pay.game597.cn";
        rechargeURL = "";
		feedbackContent = "\u5ba2\u670dQQ: 1400195533";	//客服QQ
		unityMoney = "\u5427\u8c46";	//吧豆
		downloadURL = "http://download.hxdgame.com/download/unity/game7997/";

		game_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/hxdgame.conf";
		web_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/hxdgame-web.conf";

        //wxAppId = "wxcd00aad1c9746cfe";
        //wxPayURL = "http://54.254.211.231/unity/pay/?username={0}&money_amount={1}&bank_type_code=WECHATPAY";

        config_urls = new string[]{
 			"http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game7997/config.xml",
             "http://oss.aliyuncs.com/hxdgame-download/download/unity/game7997/config.xml",
         };

	}
}
