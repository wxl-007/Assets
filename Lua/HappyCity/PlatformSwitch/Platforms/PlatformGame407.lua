 local this =  PlatformEntity.new()  
PlatformGame407 = this

  function this:Init() 
  this:InitAll();
        this.aliAppId = "2016090701862162";
	 this.wxAppId = "wxd4d1e30671770ff4";
        this.wxAppSecret = "b9456c1ed9b2e595194b3ba9db42675e";
        this.wxShareUrl = "https://www.game131.com/download/";
        this.wxShareDesciption = "游戏描述信息";
 

        this.game_URL_ipv6 = "9013.game597.cn:9013";
        this.hostURL_ipv6 = "9012.game597.cn:9012";
        this.isSocketLobby = true;
	
        this.instantUpdateUrl = {
            --"http://ggdownload.oss-cn-hangzhou.aliyuncs.com/game597/InstantUpdate/",
            "http://oss.aliyuncs.com/ggdownload/game131/InstantUpdate/",
        };
	
        this.platformName = "game407";
	this.hostURL = "http://b.game407.com";
        this.hostURL_socketLobby = "http://pay.game131.com";
        this.rechargeURL = "";
	this.feedbackContent = "客服QQ: 4000168747";	--客服QQ
	this.unityMoney = "欢乐豆";	-- 欢乐豆
	this.downloadURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game407/";
        this.game_HostURL = "http://oss.aliyuncs.com/woyou919/api/mgylc.conf";
     
        this.web_HostURL = "http://oss.aliyuncs.com/woyou919/api/131socket.conf";
 
	this.config_urls = {
            --"http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/config.xml",
           --"http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game407/config.xml",
            --"http://b.game131.com/unity/config.xml",
            --"http://b.game131.cc/unity/config.xml",
            --"http://b.game131.net/unity/config.xml"

            --"http://131.game597.com/131newunity/config.xml",
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
            "http://dow10.game131.com/131newunity/config.xml",};

        this:FixConfigUrls(this.config_urls);
 end