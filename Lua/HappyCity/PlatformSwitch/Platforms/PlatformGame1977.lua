 local this =  PlatformEntity.new()  
PlatformGame1977 = this

local m_GameData = 
{
         ["srnn"]={ wxAppId = "wx34dd29a7afb1f4f4",wxAppSecret = "178d364d4b38294fc8f6aeacc8358aab",baiduYuntui = ""} ,
        ["dznn"]={ wxAppId = "wxf061fa352de2a275", wxAppSecret = "8bac4a783e76cc80309d3284ee559098",baiduYuntui = "91AkogNFuyGHaoqrTFFnXGtt"} , 
        ["tbnn"]={ wxAppId = "wx8088e326bc6c2227", wxAppSecret = "32939d1c7eefa31bfce024940a951137",baiduYuntui = ""} , 
        ["fkby"]={ wxAppId = "wx69b9a7a4bdd980b0", wxAppSecret = "1458ffd49ed70bafb2697711685c248c",baiduYuntui = "adgjGn7T8TKtVZXGcSymWk3X"}
}; 
function this:Init()  
	this:InitAll();
    this.aliAppId = "2016090701862162";
	 this.wxAppId = "wxcd00aad1c9746cfe";
        this.wxAppSecret = "dec310f07cfd4b3b6c366eb2dbe322d9";
        this.wxShareUrl = "http://downnwe.game597.com/app/";
        this.wxShareDesciption = "游戏描述信息";
        this.wxPayAppId = "wxbe68985ca99cb404";
		this.wxPayAppSecret = "2c866a73475b6eb09117fae5b107bd43";
        this.baiduYuntui = "czFpuckEtGV8u3Vw9aXdPrha";
         this.wxShareAppIds = {};
	local singleGameName = string.sub(Utils.bundleId,1,string.find(Utils.bundleId,"%.")-1); 
	
    if (m_GameData[singleGameName] ~= nil) then 
        this.wxAppId = m_GameData[singleGameName].wxAppId;
        this.wxAppSecret = m_GameData[singleGameName].wxAppSecret;  
        this.baiduYuntui = m_GameData[singleGameName].baiduYuntui;  
    end

        this.game_URL_ipv6 = "9009.game597.cn:9009"
        this.hostURL_ipv6 = "9011.game597.cn:9011"
        this.isSocketLobby = true;
		
        this.instantUpdateUrl = {
            "http://oss.aliyuncs.com/ggdownload/game597/InstantUpdate/",
            --"http://oss.aliyuncs.com/bak998899/InstantUpdate/"
        };
	
        this.platformName = "1977game2";
	this.hostURL = "http://pay.6666.cn";
        this.hostURL_socketLobby = "http://pay.6666.cn";
        this.rechargeURL = "";
	this.feedbackContent = "客服QQ: 4000168747";	--客服QQ
	this.unityMoney = "欢乐豆";	-- 欢乐豆
	this.downloadURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/download/unity/1977game/";
		--game_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/787go.conf";
        this.game_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/mob787goa.conf";
        --web_HostURL = "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/787go-web.conf";
        this.web_HostURL =  "http://hxdgame-download.oss-cn-hangzhou.aliyuncs.com/api/mob787goa-web.conf";
 
	this.config_urls = {
            --"http://download.game597.com/597unity/config.xml",

			-----------2016-12-31 Alien 注释
			--"http://bb.game597.cn/597unity/config.xml",
            --"http://bb.game597.net/597unity/config.xml",
            --"http://bb.game131.com/597unity/config.xml",
            --"http://dow1.game597.net/597unity/config.xml",
            --"http://dow2.game597.net/597unity/config.xml",
            --"http://dow3.game597.net/597unity/config.xml",
            --"http://dow4.game597.net/597unity/config.xml",
            --"http://dow5.game597.net/597unity/config.xml",
            --"http://dow6.game597.net/597unity/config.xml",
            --"http://dow7.game597.net/597unity/config.xml",
            --"http://dow8.game597.net/597unity/config.xml",
            --"http://dow9.game597.net/597unity/config.xml",
            --"http://dow10.game597.net/597unity/config.xml"
			
            
			
			-----------2016-12-31  Alien 写入  597手机新客户端 
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

        this:FixConfigUrls(this.config_urls);
 end