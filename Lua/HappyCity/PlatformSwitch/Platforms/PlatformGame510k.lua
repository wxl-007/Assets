 local this =  PlatformEntity.new()  
PlatformGame510k = this

  function this:Init() 
  this:InitAll(); 
  this.aliAppId = "2016090701862162";
	 this.wxAppId = "wx597d9f18438be72c";
        this.wxAppSecret = "6339e8b870a0be5684edb16001eef4c2";
        this.wxShareUrl = "http://game510k.com/app/";
        this.wxShareDesciption = "游戏描述信息";
 

        this.game_URL_ipv6 = "9006.6666.cn:9006";
        this.hostURL_ipv6 ="9007.6666.cn:9007";
        this.isSocketLobby = true;
		
        this.instantUpdateUrl = {
        --"http://oss.aliyuncs.com/ggdownload/game510k/InstantUpdate/",
			"http://oss.aliyuncs.com/hhehe/510klua/InstantUpdate/",
           --"http://oss.aliyuncs.com/bak998899/InstantUpdate/"
        };
	
        this.platformName = "game510k";
	this.hostURL = "http://b.game510k.com";
        this.hostURL_socketLobby = "http://139.224.31.127:9520";
        this.rechargeURL = "";
	this.feedbackContent = "客服QQ: 4000168747";	--客服QQ
	this.unityMoney = "欢乐豆";	-- 欢乐豆
	this.downloadURL ="http://download.hxdgame.com/download/unity/game510k/";
        this.game_HostURL =  "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/api/mobile.conf";
        this.web_HostURL =  "http://ggbbgvg.oss-cn-hangzhou.aliyuncs.com/api/website.conf";
 
	this.config_urls = {
             --"http://download.game510k.net/update/config.xml",

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

        this:FixConfigUrls(this.config_urls);
 end