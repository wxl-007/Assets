 local this =  PlatformEntity.new()  
PlatformGame1977Backup = this

  function this:Init() 
  this:InitAll();
        this.platformName = "1977backup";
	this.hostURL = "http://b.1977game.com"; 
        this.rechargeURL = "";
	this.feedbackContent = "客服QQ: 4000168747";	--客服QQ
	this.unityMoney = "欢乐豆";	-- 欢乐豆
	this.downloadURL = "http://download.hxdgame.com/download/unity/1977backup/";
        this.game_HostURL =  "http://download.hxdgame.com/api/787go.conf";
        this.web_HostURL = "http://download.hxdgame.com/api/787go-web.conf";
	 
 end