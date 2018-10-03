 local this = PlatformEntity.new() 
PlatformGame7997 = this
 
 function this:Init() 
	this:InitAll();
	this.isSocketLobby = true;  
	
	this.instantUpdateUrl = {
			"http://ggdownload.oss-cn-hangzhou.aliyuncs.com/game597/InstantUpdate/"
		};

	this.platformName = "game7997";
	this.hostURL = "http://b.game7997.com";--web 54.254.211.231:80 --game 54.254.229.244:8211
	this.hostURL_socketLobby = "http://pay.game597.cn";
	 
	this.rechargeURL = "";
	this.feedbackContent = "客服QQ: 1400195533";	--客服QQ
	this.unityMoney = "吧豆";	--吧豆
	this.downloadURL = "http://download.hxdgame.com/download/unity/game7997/";

	this.game_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/hxdgame.conf";
	this.web_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/hxdgame-web.conf";
	this.aliAppId = "2016090701862162";
	--this.wxAppId = "wxcd00aad1c9746cfe";
	--this.wxPayURL = "http://54.254.211.231/unity/pay/?username={0}&money_amount={1}&bank_type_code=WECHATPAY";
	this.config_urls = {
			--"http://oss.aliyuncs.com/bak998899/test/game7997/config.xml",

 			"http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/game7997/config.xml",
             "http://oss.aliyuncs.com/hxdgame-download/download/unity/game7997/config.xml",
		 };
		 
end
