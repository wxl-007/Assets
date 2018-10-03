 Path = luanet.import_type('System.IO.Path'); 
 
 local this = LuaBaseClass("PlatformEntity")
PlatformEntity = this  
 local PlayerPrefs = UnityEngine.PlayerPrefs
 
this.CToLuaIEnumerator = {}; 
 
this.platformName="";		-- 平台代号

this.game_URL="";          -- 当前使用的IP
this.web_URL="";           -- 当前使用的IP. 已过时,使用 hostURL 替代
this.hostURL="";			-- 平台地址 --- 跟web一样的
this.hostURL_socketLobby="";    --使用socket登录的时候 原来的hostURL变成了socket用的 ip地址. 因此该值用来表示socket登录模式下的http固定地址

------------------兼容ios ipv6 审核用----------------------
this.game_URL_ipv6="";          -- 当前使用的IP
this.hostURL_ipv6="";          -- 平台地址 --- 跟web一样的

this.downloadURL="";		-- 平台下载目录地址
this.rechargeURL="";		-- 平台充值地址：如为空则需接入第三方充值
this.feedbackContent="";	-- 平台客服信息
this.unityMoney="";		-- 平台游戏币单位
this.iOSFlagValidVersion="";--控制当前的配置的版本号进行app store 充值
this.iOSPayFlag = false;	-- 平台苹果充值标志
this.iOSPayFlag_bundle_version_contains = false;--热更新地址下(由melissa管理)是否包含了该 bundleid=version 的配置条目
this.config_urls={};		-- 平台配置文件地址列表

this.hostURLInconfig="";

this.isInstantUpdate = false;     --是否开启热更新--默认开启
this.instantUpdateUrl={};  --热更新url地址
this.instantUpdateUrl_test={};  --热更新url地址
this.testers="";

this.versionCode = 0;--(如果不用更新)用于减少一次对version文件的网络访问
this.register_url="";--用于 注册界面 使用系统的webView 加载web网页进行注册

-------------------------------------缓存相关---------------------------
this.isCache_UserIp = true;--是否 使用 用户ip(加密数据) 和 conf加密数据的缓存
this.isCache_config = false;

------------------------SocketManager配置信息------------------------------------
this.socketManager_config_str="";

-------------------------------------------------------
this.game_HostURL="";			-- 游戏IP数组地址
this.web_HostURL="";			-- 网页IP数组地址 
this.socketLobby_HostURL="";           -- 网页IP数组地址 

-- shawn.update
this.game_HostURL_Arr = {};	-- 游戏IP数组
this.web_HostURL_Arr = {};	-- 网页IP数组


this.game_Cutt = 1;			-- 当前第几个
this.web_Cutt=1;			-- 当前第几个
this.socketLobby_Cutt = 1;
----------------------------------------------------------
this.isMsgReceiver = true; 	--是否开启喇叭
this.isPool = false;	-- 是否开启牛牛奖池

this.isYan = false;   -- 是否开启验证码

this.aliAppId="";       --支付宝appid

this.wxAppId="";       --微信appid
this.wxAppSecret="";	--微信appsecret

this.wxPayAppId = "";       --微信支付appid
this.wxPayAppSecret = "";       --微信支付appsecret
--this.wxPayURL="";          --微信支付url
this.wxShareUrl="";    --微信分享 url

this.wxShareDesciption="";	--微信分享描述信息
this.wxShareAppIds={};		--微信分享appid
this.shareGetCoinCount = 0;	--分享获取金币数量，0隐藏显示
this.baiduYuntui = "";		--百度云推id
 
function this.Get:PlatformName() 
	return self.platformName
end 
function this.Get:HostURL() 
	--return "http://121.42.35.14/";
	--return "http://139.224.33.27:80/";
	
	if (Utils._IsIPTest) then 
		if (IPTest_Login._WebURL~=nil and IPTest_Login._WebURL~="") then
			local prefix = "http://";
			 
			if (string.find(IPTest_Login._WebURL, prefix) and string.find(IPTest_Login._WebURL, prefix) == 1) then prefix = ""; end
			return prefix..IPTest_Login._WebURL;
		end
	end 
	if (Utils._IsIPTest2) then 
		if (IPTest2_WebURL~=nil and IPTest2_WebURL~="") then
			local prefix = "http://"; 
			if (string.find(IPTest2_WebURL, prefix) and string.find(IPTest2_WebURL, prefix) == 1) then prefix = ""; end
			return prefix..IPTest2_WebURL;
		end
	end 
	if (self.IsSocketLobby) then return self.hostURL_socketLobby; end--socket大厅模式下使用 hostURL_socketLobby
	if (Utils.PlayformName=="PlatformGame7997") then return "http://54.254.211.231:80"; end
	
	return self.hostURL;
	 
end  
function this.Get:DownloadURL() return self.downloadURL; end
function this.Get:RechargeURL() return self.rechargeURL; end
function this.Get:FeedbackContent() return self.feedbackContent; end
function this.Get:UnityMoney() return self.unityMoney; end

 function this.Get:IOSPayFlag()
	 if (tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_Enterprise or tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_AppStore) and tostring(Utils.BUILDPLATFORM) ~= BuildPlatform.IOS_Enterprise then
		if (self.iOSPayFlag_bundle_version_contains) then
			return false;
		end--如果热更新地址下配置了,就代表要关闭热更新
		if (self.iOSFlagValidVersion~= "") then   
			if (string.find(self.iOSFlagValidVersion, Utils.version)~=nil) then return false; end
		end
	end
	 return self.iOSPayFlag;
 end 

function this.Get:IsPool() return self.isPool; end
function this.Get:IsYan() return self.isYan; end 

function this.Get:VersionCode() 
	 return self.versionCode;
 end  

function this.Get:Register_url() 
	if(Utils.Agent_Id~=nil and Utils.Agent_Id~="") then return ""; end--如果存在 代理 号,这里返回空, 就使用unity的注册. (不使用web网页注册)

	return ""; -- register_url;  
end  
 
function this.Get:gameUrl() 
	if(Utils.isLocalServer) then
		if (not self:IsNullOrEmpty(Local_Login.serverIP))  then return Local_Login.serverIP..":9012"; end  
	end
	if (Utils._IsIPTest) then
		if (not self:IsNullOrEmpty(IPTest_Login._GameURL)) then return IPTest_Login._GameURL; end
	end
	if (Utils._IsIPTest2) then
		if (not self:IsNullOrEmpty(IPTest2_GameURL)) then return IPTest2_GameURL; end
	end
	if (not self.IOSPayFlag) then
		if (not self:IsNullOrEmpty(self.game_URL_ipv6))  then return self.game_URL_ipv6; end
	end
 --[[
	 /** 
      //game_URL = "115.28.12.109:9060";
      //game_URL = "115.28.12.109:30083";
      //game_URL = "115.28.12.109:8510";
     // game_URL = "115.28.12.109:8230";
       
         if (PlatformGameDefine.game.GameID == "1042")//四人牛牛
        {
            game_URL = "115.28.12.109:30083";
        }
        else if (PlatformGameDefine.game.GameID == "1062")//通比五张
        {
            game_URL = "115.28.12.109:8230";
        }
        else if (PlatformGameDefine.game.GameID == "1031")//明星牛牛
        {
            game_URL = "115.28.12.109:8510";
        }
        else
        {
            game_URL = "115.28.12.109:9060";
        }
        Debug.Log("===--------========" + PlatformGameDefine.game.GameID);
      ]]
	  
	 --[[	]]
	if (Utils.PlayformName=="PlatformGame7997") then 
		if (PlatformGameDefine.game.GameID == "1609")then--疯狂通比斗牛
			self.game_URL = "115.28.12.109:11609";
		elseif (PlatformGameDefine.game.GameID == "1091") then--通比斗三张
			self.game_URL = "115.28.12.109:8360";
		elseif (PlatformGameDefine.game.GameID == "1092") then --16人通比斗三张
			self.game_URL = "115.28.12.109:11092";
		elseif (PlatformGameDefine.game.GameID == "1036") then--通比牛牛
			self.game_URL = "115.28.12.109:11602";
		elseif (PlatformGameDefine.game.GameID == "1042") then--四人牛牛
			self.game_URL = "115.28.12.109:30083";
		elseif (PlatformGameDefine.game.GameID == "1077")then --极速豪车
			self.game_URL = "115.28.12.109:8256";
		elseif (PlatformGameDefine.game.GameID == "1062") then--通比五张
			self.game_URL = "115.28.12.109:8230";
		elseif (PlatformGameDefine.game.GameID == "1080") then--快速七张麻将
			self.game_URL = "115.28.12.109:11360";
		elseif (PlatformGameDefine.game.GameID == "1037") then--激情牛牛
			self.game_URL = "115.28.12.109:11652";
		elseif (PlatformGameDefine.game.GameID == "1071") then--飞腾牛神
			self.game_URL = "115.28.12.109:30213";
		elseif (PlatformGameDefine.game.GameID == "1029") then--30s
			self.game_URL = "115.28.12.109:8821";
		elseif (PlatformGameDefine.game.GameID == "1070") then--二人斗地主
			self.game_URL = "115.28.12.109:11330";
		elseif (PlatformGameDefine.game.GameID == "1056") then--百倍牛牛
			self.game_URL = "115.28.12.109:11580";
		elseif (PlatformGameDefine.game.GameID == "1055") then--看牌牛牛
			self.game_URL = "115.28.12.109:12201";
		elseif (PlatformGameDefine.game.GameID == "1034") then--对战牛牛/二人牛牛
			self.game_URL = "115.28.12.109:11561";   --11561    11562   11563
		elseif (PlatformGameDefine.game.GameID == "1031") then--明星牛牛
			self.game_URL = "115.28.12.109:8510";
		elseif (PlatformGameDefine.game.GameID == "1023") then --大话骰子
			self.game_URL = "115.28.12.109:11306";
			--self.game_URL = "121.42.136.89:8515";
		elseif (PlatformGameDefine.game.GameID == "1018") then--德州扑克
			self.game_URL = "115.28.12.109:8587";
		elseif (PlatformGameDefine.game.GameID == "1069") then --赢三张
			self.game_URL = "115.28.12.109:11069";
		elseif (PlatformGameDefine.game.GameID == "30035") then --中国象棋
			self.game_URL =  "115.28.12.109:30035"--"52.220.39.106:30035";
		elseif (PlatformGameDefine.game.GameID == "1020") then --中国象棋
			self.game_URL =  "115.28.12.109:30035"--"52.220.39.106:30035";
		elseif (PlatformGameDefine.game.GameID == "1036") then--通比牛牛
			self.game_URL = "115.28.12.109:11602";
		elseif PlatformGameDefine.game.GameID == "1097" then --四人5张
			self.game_URL = "115.28.12.109:11097"
		elseif PlatformGameDefine.game.GameID == "1043" then --2人5张
			self.game_URL = "115.28.12.109:30093"
		elseif (PlatformGameDefine.game.GameID == "1038") then --火拼两张  
			self.game_URL = "115.28.12.109:11703";	--11701  11703   11705
		elseif (PlatformGameDefine.game.GameID == "1014") then --火拼双扣  
			self.game_URL = "115.28.12.109:8751";	
		elseif (PlatformGameDefine.game.GameID == "1007") then --千变双扣
			self.game_URL = "115.28.12.109:8401";
		elseif (PlatformGameDefine.game.GameID == "1053") then --小九
			self.game_URL = "115.28.12.109:8741";
		elseif (PlatformGameDefine.game.GameID == "1065") then --四人拼十
			self.game_URL = "115.28.12.109:12008";
		elseif (PlatformGameDefine.game.GameID == "1027") then --百人两张
			self.game_URL = "115.28.12.109:8651";	
		end 
	--elseif  (Utils.PlayformName=="PlatformGame1977") then 
			--self.game_URL = "121.42.136.89:8515";--大话骰子
	 end

 
     --[[
        //            if (PlatformGameDefine.playform is PlatformGame7997) return "54.254.229.244:8211";
        //水浒
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:8821";
        //16人通比斗三张
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:11092";
        //通比斗三张
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:8160";
        //极速豪车
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:8255";//高级场
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:8305";//体验场
        //疯狂通比斗牛
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:11609";
        //通比五张
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:8230";
        //通比牛牛
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:11602";
        //四人牛牛
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:30081";//体验场
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:30085";//中级场
        //快速七张麻将
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:11360";
        //快速七张麻将
        //if (PlatformGameDefine.playform is PlatformGame7997) return "52.220.39.106:12200";
		]]
	 
	--if (Utils.PlayformName=="PlatformGame7997") then return "52.220.39.106:11078"; end
	return self.game_URL;
end  
function this:IsNullOrEmpty(tempStr)
	if (tempStr~=nil and tempStr~= "")  then return false end 
	return true
end

function this.Get:webUrl() return self.web_URL; end  

function this.Get:SocketLobbyUrl() 

	if false then
		-- return  "115.28.12.109:9520"
		return "114.215.87.65:9520"
		--return  "114.215.87.65:9520"--597测试（志明）
		--return "52.220.39.106:9520";--597测试地址--"120.76.142.110:9011";
	end
	
	if (Utils.isLocalServer) then
		if ( not self:IsNullOrEmpty(Local_Login.serverIP)) then return Local_Login.serverIP..":9013"; end
	end 
	if (Utils._IsIPTest) then
		if ( not self:IsNullOrEmpty(IPTest_Login._SocketLobbyURL)) then return IPTest_Login._SocketLobbyURL; end
	end 
	if (Utils._IsIPTest2) then
		if ( not self:IsNullOrEmpty(IPTest2_SocketURL)) then return IPTest2_SocketURL; end
	end 
	if ( not self.IOSPayFlag) then
		if ( not self:IsNullOrEmpty(self.hostURL_ipv6)) then return self.hostURL_ipv6; end
	end 
	if (Utils.PlayformName=="PlatformGame7997") then
		-- return "54.254.229.244:9520"; --7997测试地址
		print('in  this  id  ')
		return "115.28.12.109:9520";
	end 
	return self.hostURL;--socketlobby 的url地址就是之前的 http的web地址
end 
 

this.isSocketLobby = true; 
function this.Get:IsSocketLobby() 
 return self.isSocketLobby; 
end 

function this.Get:AliAppId() return self.aliAppId; end  
function this.Get:WXAppId() return self.wxAppId; end  
function this.Get:WxAppSecret() return self.wxAppSecret; end  
function this.Get:WXPayAppId() return self.wxPayAppId; end  
function this.Get:WXPayAppSecret() return self.wxPayAppSecret; end  

--function this.Get:WXPayURL() return self.wxPayURL; end  
function this.Get:WXShareUrl() return self.wxShareUrl; end  
function this.Get:WXShareDescription() return self.wxShareDesciption; end  

--510k
this.hallHomeInfos=""; 
function this.Get:HallHomeInfos() return self.hallHomeInfos; end 

this.web_conf_list = {};--web conf 文件对应的url地址列表
this.game_conf_list = {};--game conf 文件对应的url地址列表 
this.web_confName_list = {};--web conf 文件对应的url地址列表的名字
this.game_confName_list = {};--game conf 文件对应的url地址列表的名字
this.web_IP_list = {};--web IP信息组装列表
this.game_IP_list = {};--game IP信息组装列表
this.m_cur_game_conf_index = 1;
--this.m_cur_web_conf_index = 1;
this.webConfIndexAlter = nil;	--线路修改回调
this.webConfListInit = nil;		--线路初始化回调
 function this.Get:m_cur_web_conf_index()    
	return self.m_Cur_Web_Conf_Index;
end
function this.Set:m_cur_web_conf_index(value)    
	self.m_Cur_Web_Conf_Index = value
	if self.webConfIndexAlter ~= nil then
		self.webConfIndexAlter();
	end
end  
  
  
function this.Get:IsInstantUpdate() return self.isInstantUpdate; end 
function this.Set:IsInstantUpdate(value) 
	self.isInstantUpdate = value;
 end   
local instantUpdateUrl_index = 1; 
function this.Get:InstantUpdateUrl()
 
	local instantUpdateUrl_array = self.instantUpdateUrl; 
--设置测试人员专用 热更新地址
	if (self:IsTester()  and   not self.IsInstantUpdate) then
		if (self.instantUpdateUrl_test  ~= nil  and  #(self.instantUpdateUrl_test) > 0) then
			instantUpdateUrl_array = self.instantUpdateUrl_test;
		end
	end
	
	local instantUpdateUrl = instantUpdateUrl_array[instantUpdateUrl_index];
	instantUpdateUrl_index =instantUpdateUrl_index+1;
	if #(instantUpdateUrl_array)<instantUpdateUrl_index then
		instantUpdateUrl_index = 1;
	end 
	local gameName = Utils.GameName;
        if (gameName == "All") then
		gameName = "";
         else 
		 gameName = "_"..gameName;
	end
	
	 
	if (tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_Enterprise or tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_AppStore) then  
		return instantUpdateUrl.."IOS"..gameName..Constants.UpdateDirName;
	elseif tostring(Utils.BUILDPLATFORM) == BuildPlatform.OSX then
		return instantUpdateUrl.."OSX"..gameName..Constants.UpdateDirName;
	else 
		return instantUpdateUrl.."Android"..gameName..Constants.UpdateDirName;
	end  
end 
--在C#中等待Lua协程
function this.Get:cToLuaIEnumerator()   
	if self.CToLuaIEnumerator == nil then
		self.CToLuaIEnumerator = {}
	end  
	return self.CToLuaIEnumerator;
end 
 function this:SetDoneCoroutineCTOLua(_name,_v)  
	 self.cToLuaIEnumerator[_name] = _v
 end
 function this:GetDoneCoroutineCTOLua(_name)
	if self.cToLuaIEnumerator[_name] == nil then
		self.cToLuaIEnumerator[_name] =  false
	end  
	 return self.cToLuaIEnumerator[_name];
 end
function this:StartLuaCoroutine(func,_fName,...)
	self:SetDoneCoroutineCTOLua(_fName,true);
	coroutine.start(self.StartBranchCoroutine,self,func,_fName,...) 
 end
 function this:StartBranchCoroutine(func,_fName,...)   
	coroutine.branch(coroutine.start(func,self,...)) 
	self:SetDoneCoroutineCTOLua(_fName,false); 
 end
 --Lua中包装Action
  function this:LuaFunctionToAction(action)   
	local tempFunction = function()  
		Utils.CallAction(action);
	end
	return tempFunction;
 end
 ------------
function this:testOnComplete(onComplete)  
	if onComplete ~= nil then  onComplete(); end 
 end
 function this:testCoroutine(_name,name2) 
	 coroutine.wait(10); 
 end
function this.Get:testName()   
	return self.TestName;
end
function this.Set:testName(value)    
	self.TestName = value 
end  
function this:testCall(_name)
	self.testName = _name
	return self.testName;
 end
--/ <summary>
--/ 检测用户是否是测试人员(上一次登录成功是否是测试人员)
--/ </summary>
--/ <returns></returns>
function this:IsTester()  
	
	if (self:IsNullOrEmpty(self.testers)) then
		return false; 
	end
	local username = PlayerPrefs.GetString("EginUsername", "");
	
	 if (self:IsNullOrEmpty(username)) then 
		return false;
	end--如果username 是空的, testers.Contains(username) 就是true;
	local tempList1 = string.split(self.testers,",")
 
	 
	return  tableContains(tempList1,username);
	 
end

function this:ConfigURL()  
	local versionUrl = self.downloadURL.."config.xml";
	return versionUrl;
end


function this:GameNoticeURL() 
	local noticeUrl = self.downloadURL.."game_notices.xml";
	return noticeUrl;
end

function this:LoadURL( game,  web)  

	if (game  ~= "") then
		self.game_HostURL = game;
	end
	if (web  ~= "") then
		self.web_HostURL = web;
	end
end

-------------------------------------------缓存相关------------------------ 
function this.Get:IsCache_UserIp() return self.isCache_UserIp; end  
function this.Get:IsCache_config() return self.isCache_config; end 
------------------------SocketManager配置信息------------------------------------ 
function this.Get:SocketManager_config_str() return self.socketManager_config_str; end 

function this:InitAll() 
	self.platformName="";		-- 平台代号 
	self.game_URL="";          -- 当前使用的IP
	self.web_URL="";           -- 当前使用的IP. 已过时,使用 hostURL 替代
	self.hostURL="";			-- 平台地址 --- 跟web一样的
	self.hostURL_socketLobby="";    --使用socket登录的时候 原来的hostURL变成了socket用的 ip地址. 因此该值用来表示socket登录模式下的http固定地址

	------------------兼容ios ipv6 审核用----------------------
	self.game_URL_ipv6="";          -- 当前使用的IP
	self.hostURL_ipv6="";          -- 平台地址 --- 跟web一样的

	self.downloadURL="";		-- 平台下载目录地址
	self.rechargeURL="";		-- 平台充值地址：如为空则需接入第三方充值
	self.feedbackContent="";	-- 平台客服信息
	self.unityMoney="";		-- 平台游戏币单位
	self.iOSFlagValidVersion="";--控制当前的配置的版本号进行app store 充值
	self.iOSPayFlag = false;	-- 平台苹果充值标志
	self.iOSPayFlag_bundle_version_contains = false;--热更新地址下(由melissa管理)是否包含了该 bundleid=version 的配置条目
	self.config_urls={};		-- 平台配置文件地址列表

	self.hostURLInconfig="";

	self.isInstantUpdate = false;     --是否开启热更新--默认开启
	self.instantUpdateUrl={};  --热更新url地址
	self.instantUpdateUrl_test={};  --热更新url地址
	self.testers="";

	self.versionCode = 0;--(如果不用更新)用于减少一次对version文件的网络访问
	self.register_url="";--用于 注册界面 使用系统的webView 加载web网页进行注册

	-------------------------------------缓存相关---------------------------
	self.isCache_UserIp = true;--是否 使用 用户ip(加密数据) 和 conf加密数据的缓存
	self.isCache_config = false;

	------------------------SocketManager配置信息------------------------------------
	self.socketManager_config_str="";

	-------------------------------------------------------
	self.game_HostURL="";			-- 游戏IP数组地址
	self.web_HostURL="";			-- 网页IP数组地址 
	self.socketLobby_HostURL="";           -- 网页IP数组地址 

	-- shawn.update
	self.game_HostURL_Arr = {};	-- 游戏IP数组
	self.web_HostURL_Arr = {};	-- 网页IP数组


	self.game_Cutt = 1;			-- 当前第几个
	self.web_Cutt=1;			-- 当前第几个
	self.socketLobby_Cutt = 1;
	----------------------------------------------------------
	self.isMsgReceiver = true;
	self.isPool = false;	-- 是否开启牛牛奖池

	self.isYan = false;   -- 是否开启验证码

	self.aliAppId=""; 
	self.wxAppId="";       --微信appid
	self.wxAppSecret="";	--微信appsecret
	self.wxPayAppId = "";       --微信支付appid
	self.wxPayAppSecret = "";       --微信支付appsecret
	--self.wxPayURL="";          --微信支付url
	self.wxShareUrl="";    --微信分享 url
	self.wxShareDesciption="";	--微信分享描述信息
	
	self.web_conf_list = {};--web conf 文件对应的url地址列表
	self.game_conf_list = {};--game conf 文件对应的url地址列表 
	self.web_confName_list = {};--web conf 文件对应的url地址列表的名字
	self.game_confName_list = {};--game conf 文件对应的url地址列表的名字
	self.web_IP_list = {};--web IP信息组装列表
	self.game_IP_list = {};--game IP信息组装列表
	self.m_cur_game_conf_index = 1;
	self.m_Cur_Web_Conf_Index = 1;
	self.webConfIndexAlter = nil;	--线路修改回调
	self.webConfListInit = nil;		--线路初始化回调
	self.wxShareAppIds={};
	self.shareGetCoinCount = 0; --微信分享获取金币数量

	self.baiduYuntui = ""
 end
 
 function this:IsAvailable(json) 
	 if json ~= nil then
		return true
	 else
		return false
	 end
 end
 
 
--region 加载总配置文件
function this:LoadLocalConfig()
	
	--StaticUtils.GetGameManager().StartCoroutine(LoadNewIosPayConfig());--加载ios支付额外控制配置文件--该文件需要在显示登录界面前显示
	coroutine.start(self.LoadNewIosPayConfig,self);
	
	local resultJson = nil;

	if (self.isCache_config) then
	
		local savedJson = cjson.decode(PlayerPrefs.GetString(EginUser.ObtainPlatformKey("m_config_str"), "")) 
		if ( self:IsAvailable(savedJson)) then
			savedJson = savedJson["body"];
		end
		if ( self:IsAvailable(savedJson)  and  self:IsAvailable(savedJson["application_version"] )  and  tostring(savedJson["application_version"])==Utils.version ) then 
			resultJson = savedJson; 
		else
		
			local textAsset = Resources.Load(self.FixConfig("Texts/config", self.IsSocketLobby),Type.GetType("TextAsset",true));
			savedJson = nil;
			if (textAsset) then savedJson = cjson.decode(textAsset.text); end
			if ( self:IsAvailable(savedJson)) then savedJson = savedJson["body"]; end

			if ( self:IsAvailable(savedJson)  and   self:IsAvailable(savedJson["game_hosts"])  and   self:IsAvailable(savedJson["web_hosts"])  and   self:IsAvailable(savedJson["downloadURL"])  and   self:IsAvailable(savedJson["unityMoney"])) then 
				resultJson = savedJson;
			end
		end
	end

	if (resultJson == nil) then
		--本地没有数据,加载网络数据
		coroutine.branch(coroutine.start(self.LoadConfig,self)) 
	else 
		self:UpdateConfig(resultJson);
	end
end
function this:LoadConfig()
	
	local config_urls = self.config_urls;
	
	local config_urls_json_str = PlayerPrefs.GetString("config_urls", "");
	local config_urls_version_str = PlayerPrefs.GetString("config_urls_version", "");
	if ( not self:IsNullOrEmpty(config_urls_json_str)  and   not self:IsNullOrEmpty(config_urls_version_str)  and  config_urls_version_str == Utils.version) then--从config 文件中保存了config_urls 到 PlayerPrefs 中--如果
	
		local json = cjson.decode(config_urls_json_str);
		local configList = {} 
	 
		for key, item in pairs( json) do 
			--log("CK : ------------------------------ name = ".. item tostring() ); 
			if ( not tableContains(configList,tostring(item))) then
				table.insert(configList,tostring(item)) 
			end
		end

		for key, item in pairs(self.config_urls) do 
			if ( not tableContains(configList,tostring(item))) then
				table.insert(configList,tostring(item)) 
			end
		end

		config_urls = configList
	end

	local configObj = nil;
	if (config_urls ~= nil  and  #(config_urls) > 0) then
	 
		local config_urls_queue = {}
		for  key, item in pairs(config_urls) do 
			table.insert(config_urls_queue,item.."?"..math.Random(0, 1))  
		end
		
		local result = CoroutineResult.New();
		local coroutine1 = coroutine.start(self.LoadConfig_concurrent,self, config_urls_queue, result)
		local coroutine2 = coroutine.start(self.LoadConfig_concurrent,self, config_urls_queue, result)
		local coroutine3 = coroutine.start(self.LoadConfig_concurrent,self, config_urls_queue, result)
		coroutine.branchMulti({coroutine1,coroutine2,coroutine3}) 
		 --同时启动3个协程
		
		log("CK : ------------------------------ load config completed = "  );
		configObj = result._objectResult; 
		
	end

	self:UpdateConfig(configObj);--更新配置文件信息
	log("CK : ------------------------------ 更新配置文件信息 "  );
	self:SaveConfig_json_str(configObj);
 
end

function this:SaveConfig_json_str(configObj)
	
	if ( self:IsAvailable(configObj)) then 
		configObj["application_version"]=Utils.version;
		PlayerPrefs.SetString(EginUser.ObtainPlatformKey("m_config_str"), cjson.encode(configObj));
		PlayerPrefs.Save();
	end
end
--/ <summary>
--/ 用于同时启动多个url加载
--/ </summary>
--/ <param name="config_urls_queue"></param>
--/ <param name="outResult">_BoolResult 即为 isDone; _wwwResult 为最终的 www</param>
--/ <returns></returns>
function this:LoadConfig_concurrent(config_urls_queue,  outResult)
	
	if (outResult == nil) then
	
		local errorL = "LoadConfig_concurrent : outResult cannot be nil";
		if (Constants.isEditor) then
			Exception.new(errorL);
		else 
			log("CK : ------------------------------ error = ".. errorL);
		end
		return;
	end

	local coroutineL = nil;
	local result = nil;
	--bool isDone = false;

	while not outResult._BoolResult  and  #(config_urls_queue) > 0 do 
		while  not outResult._BoolResult  and  coroutineL ~= nil do 
			coroutine.wait(0.1);--同一时间只启动一个url
		end

		if (outResult._BoolResult  or  #(config_urls_queue) <= 0) then
			break;
		end
		local curUrl = config_urls_queue[1]
		table.remove(config_urls_queue,1) 
		local filename = ""
		if Utils.Lua_UNITY_EDITOR  then
			filename = Path.GetFileName(curUrl);
			filename = string.sub(filename,1,string.find(filename,"%?")-1);
		end
		if (Constants.isEditor) then log("CK : ------------------------------ curUrl = ".. curUrl); end
		
		
		result = CoroutineResult.New(); 
		local actionToLua = Utils.ActionToLua(function()     
			if( not outResult._BoolResult  and  result.error == nil  and  result._wwwResult.error == nil)  then 
				if (result._wwwResult ~= nil) then 	
					local result_config = HttpConnect.Instance:BaseResult(result._wwwResult, false);
					if (HttpResult.ResultType.Sucess == result_config.resultType) then
						outResult._objectResult = result_config.resultObject; 
						outResult._BoolResult = true; 
						 
						if Utils.Lua_UNITY_EDITOR then 
							local path = "Assets/__BaseLobby/Resources/Texts/";
							if ( not Directory.Exists(path)) then Directory.CreateDirectory(path); end
							File.WriteAllText(path..filename, result._wwwResult.text);
							log("CK : ------------------------------<color=green> 平台: = ".. self.platformName ..", 配置文件: = ".. filename .." 已更新</color>" );
						end
					end
				end 
				if (Constants.isEditor) then
					log("CK : ---------------------------------- curUrl valid = ".. curUrl ..", text = ".. result._wwwResult.text);
				end
			end  
			if (coroutineL ~= nil) then coroutine.Stop(coroutineL); end 
			coroutineL = nil; 
		end,self);
		
		coroutineL = coroutine.start(function()  
			 local iscoroutine = DoneCoroutine.New();
			StaticUtils.StartCoroutineLuaToC(StaticUtils.WWWReConnect( result, curUrl,actionToLua, 8, 1),iscoroutine);
			coroutine.branchC(iscoroutine); 		
		end)
		
	end
	
	  
	
	while coroutineL ~= nil  and  outResult._BoolResult == false do 
		coroutine.wait(0.1);--直到有一个ip获取到或者最后一个url完成连接为止
	end
	if (result) then
		StaticUtils.DisposeAsync(result._wwwResult);
		result._wwwResult = nil;
	end
	result = nil;

	if (coroutineL ~= nil) then coroutine.Stop(coroutineL); end
	coroutineL = nil;

	log("CK : ------------------------------ LoadConfig_concurrent complete = "  );
end

function this:LoadNewIosPayConfig()
	
	self.iOSPayFlag_bundle_version_contains = false;

	if (tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_AppStore  and  #(self.instantUpdateUrl) > 0) then
	
		local result = CoroutineResult.New()  
		
		 local iscoroutine = DoneCoroutine.New();
		StaticUtils.StartCoroutineLuaToC(StaticUtils.WWWReConnect( result, self.instantUpdateUrl[1].."socket_config.xml",nil, 8, 1),iscoroutine);
		coroutine.branchC(iscoroutine); 
		
		if (result._wwwResult ~= nil  and  result._wwwResult.error == nil) then
		
			local bundle_version = Utils.bundleId.."="..Utils.version;
			self.iOSPayFlag_bundle_version_contains = (string.find(result._wwwResult.text,bundle_version)~=nil) 
		end
	end
end

 

--endregion 加载总配置文件
 
 
--region 更新总配置信息
function this:UpdateConfig(configObj)

	if ( self:IsAvailable(configObj)) then 
		 
		self.web_conf_list,self.web_confName_list = self:ParseArrayOrStringJsonIP(configObj["web_hosts"],configObj["web_hostsName"], self.web_conf_list,self.web_confName_list);
		self.game_conf_list,self.game_confName_list = self:ParseArrayOrStringJsonIP(configObj["game_hosts"], configObj["game_hostsName"],self.game_conf_list,self.game_confName_list);
		log("===============web_conf_list")
		printf(self.web_conf_list)
		
		if (self.web_conf_list ~= nil  and  #(self.web_conf_list) > 0) then
			self.web_HostURL = self:GetListOneObj(self.web_conf_list,1);
			self.m_cur_web_conf_index = 1; 
		end
		if (self.game_conf_list ~= nil  and  #(self.game_conf_list) > 0) then
			self.game_HostURL = self:GetListOneObj(self.game_conf_list,1);
			self.m_cur_game_conf_index = 1;
		end

		self.platformName = System.Text.RegularExpressions.Regex.Unescape(tostring(configObj["platformName"]));

		if(self.IsSocketLobby) then 
			self.hostURL_socketLobby = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["hostURL"]));
		else 
			self.hostURL = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["hostURL"]));
		end
		
		if ( self:IsAvailable(configObj["hostURL_ipv6"])) then self.hostURL_ipv6 = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["hostURL_ipv6"])); end
		if ( self:IsAvailable(configObj["game_URL_ipv6"])) then  self.game_URL_ipv6 = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["game_URL_ipv6"])); end

		self.hostURLInconfig = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["hostURL"]));

		self.rechargeURL = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["rechargeURL"]));
		self.feedbackContent = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["feedbackContent"]));
		self.unityMoney = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["unityMoney"]));
		self.iOSPayFlag = toBoolean(configObj["ios_pay_flag"]);
		 
		if ( self:IsAvailable(configObj["iOSFlagValidVersion"])) then self.iOSFlagValidVersion = System.Text.RegularExpressions.Regex.Unescape(tostring(configObj["iOSFlagValidVersion"] )); end--ios_pay_flag 生效的版本号
		self.isPool = toBoolean(configObj["is_pool"]);
		self.isYan = configObj["is_yan"] and toBoolean(configObj["is_yan"]) or false;
		self.downloadURL = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["downloadURL"]));
		
		--game_HostURL = System.Text.RegularExpressions.Regex.Unescape(configObj["game_hosts"] tostring());
		--web_HostURL = System.Text.RegularExpressions.Regex.Unescape(configObj["web_hosts"] tostring());

		if ( self:IsAvailable(configObj["versionCode"])) then self.versionCode = tonumber(configObj["versionCode"]); end
		if ( self:IsAvailable(configObj["socketLobby_hosts"]))  then self.socketLobby_HostURL = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["socketLobby_hosts"])); end
		if ( self:IsAvailable(configObj["register_url"])) then  self.register_url = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["register_url"])); end

		if ( self:IsAvailable(configObj["isMsgReceiver"])) then self.isMsgReceiver = toBoolean(configObj["isMsgReceiver"]); end--是否开喇叭

		if ( self:IsAvailable(configObj["shareGetCoinCount"])) then self.shareGetCoinCount = tonumber(configObj["shareGetCoinCount"]); end--分享获取金币数量 
		
		if ( self:IsAvailable(configObj["isCache_UserIp"])) then self.isCache_UserIp = toBoolean(configObj["isCache_UserIp"]); end--是否开用户ip缓存
		if (self:IsAvailable(configObj["isCache_config"] )) then self.isCache_config = toBoolean(configObj["isCache_config"]);end--是否使用 config 缓存
		
		if ( self:IsAvailable(configObj["isInstantUpdate"])) then self.IsInstantUpdate = toBoolean(configObj["isInstantUpdate"]) end;--是否开启热更新
		self:ParseInstantUpdateUrl(configObj["instantUpdateUrl"]);--热跟新地址解析
		
		self.instantUpdateUrl_test = self:ParseArrayOrStringJson(configObj["instantUpdateUrl_test"]);--测试热更新地址解析
		--Utils.LuaToInstantUpdateUrl_test(self.instantUpdateUrl_test)--instantUpdateUrl_test添加到C#
		
		if ( self:IsAvailable(configObj["testers"])) then self.testers = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["testers"])); end--测试人员用户名
		if ( self:IsAvailable(configObj["aliAppId"])) then self.aliAppId = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["aliAppId"])); end --
		
		if ( self:IsAvailable(configObj["wxAppId"])) then self.wxAppId = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["wxAppId"])); end --微信appid
		if (self:IsAvailable(configObj["wxAppSecret"] ))  then self.wxAppSecret = System.Text.RegularExpressions.Regex.Unescape(tostring(configObj["wxAppSecret"] ));	end--微信appsecret
		if ( self:IsAvailable(configObj["wxShareUrl"])) then  self.wxShareUrl = System.Text.RegularExpressions.Regex.Unescape(tostring(configObj["wxShareUrl"] )); end   --微信分享 url
		if (self:IsAvailable(configObj["wxShareDesciption"] )) then self.wxShareDesciption = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["wxShareDesciption"])); end	--微信分享描述信息
		
		if (self:IsAvailable(configObj["wxShareAppIds"] )) then 
			table.insert( self.wxShareAppIds,1,System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["wxShareAppIds"]))) 
		end	--微信分享和邀请的id
		
		--添加彩金标记
		if (self:IsAvailable(configObj["handselGame"] )) then 
			self.handselGameList = self:ParseArrayOrStringJson(configObj["handselGame"]);
			 
		end	 


		local config_urlsJson = configObj["config_urls"];
		if ( self:IsAvailable(config_urlsJson)) then 
		
			for key, value in pairs(config_urlsJson) do
				value = System.Text.RegularExpressions.Regex.Unescape(tostring(value));
			end  
			Utils.SetConfig_urls(cjson.encode(config_urlsJson));
		else 
			Utils.SetConfig_urls(nil);
		end

		if ( self:IsAvailable(configObj["socketManager_config_str"])) then
			self.socketManager_config_str = System.Text.RegularExpressions.Regex.Unescape( tostring(configObj["socketManager_config_str"]));
		end
		SocketManager.UpdateConfigStr(self.socketManager_config_str);
		 ConnectDefine.updateConfig();--重新加载 http 的 url
	end

	log("CK : ------------------------------ web_conf_list = ".. #(self.web_conf_list) ..", game_conf_list = ".. #(self.game_conf_list));
	if ((self.web_conf_list == nil  or  #(self.web_conf_list) <= 0)  and   not self:IsNullOrEmpty(self.web_HostURL)) then
		self.web_conf_list = {self.web_HostURL}
		self.web_confName_list = {"默认线路"}
	 
	end;
	if ((self.game_conf_list == nil  or  #(self.game_conf_list) <= 0)  and   not self:IsNullOrEmpty(self.game_HostURL)) then  
		self.game_conf_list = {self.game_HostURL}  
		self.game_confName_list = {"默认线路"}
		 
	end;
end

function this:ParseInstantUpdateUrl(instantUpdateUrlJson)

	if ( self:IsAvailable(instantUpdateUrlJson)) then 
		if (instantUpdateUrlJson ~= nil and type(instantUpdateUrlJson) == "table") then 
			self.instantUpdateUrl = {} 
			for key, value in pairs(instantUpdateUrlJson) do
				table.insert(self.instantUpdateUrl, System.Text.RegularExpressions.Regex.Unescape(tostring(value)))
			end
			--Utils.LuaToInstantUpdateUrl(self.instantUpdateUrl)--instantUpdateUrl设置到C#中
		else 
			self.instantUpdateUrl = {}
			self.instantUpdateUrl[1] = System.Text.RegularExpressions.Regex.Unescape( tostring(instantUpdateUrlJson));--热更新url地址
			--Utils.LuaToInstantUpdateUrl(self.instantUpdateUrl) --instantUpdateUrl设置到C#中
		end
	end
end
--endregion 更新总配置信息


--region ip地址不通是,切换ip
--切换游戏IP
function this:swithGameHostUrl( onComplete)

	--if ( not self:IsNullOrEmpty(SocketConnectInfo.Instance.roomHost)) return;

	if (self.game_HostURL_Arr == nil  or  (self.game_HostURL_Arr ~= nil  and  #(self.game_HostURL_Arr) <= 0)) then
	
		if (onComplete ~= nil) then  onComplete(self); end
		return;
	end

	self.game_Cutt=self.game_Cutt+1;

	if (self.game_Cutt > #(self.game_HostURL_Arr)) then
		--如果本线路的ip用完切换线路
		self.game_Cutt = 1;
		self.m_cur_game_conf_index = self.m_cur_game_conf_index+1;
		log("切换线路：第"..self.m_cur_game_conf_index.."个");
		coroutine.start(self.LoadConf_game_hostArr,self,function() 
			 self:swithGameHostUrl_internal(onComplete)  
			 log("切换线路后game IP：第"..self.game_Cutt.."个 :".. self.game_URL);
		end); 
	else
		self:swithGameHostUrl_internal(onComplete);-- shawn.update
	end
	log("切换game IP：第"..self.game_Cutt.."个 :".. self.game_URL);
end

function this:swithGameHostUrl_internal( onComplete)

	if (self.game_Cutt <= #(self.game_HostURL_Arr)) then 
		game_URL = tostring(self.game_HostURL_Arr[self.game_Cutt]);
	end 
	if (onComplete ~= nil) then onComplete(self); end
end

--切换网页IP
--/ <summary>
--/ 
--/ </summary>
--/ <param name="isHttp">由于加了socket大厅后这里有http请求和 socket 大厅请求的切换,因此用 itHttp 来判断是否是http地址. 避免原本为了切换http地址而切换了socket地址</param>
function this:swithWebHostUrl( isHttp ,  onComplete )
	if isHttp == nil then isHttp = true; end
	
	if (isHttp  and  self.IsSocketLobby) then 
		if (onComplete ~= nil) then onComplete(self); end
		return;--请求http地址切换,在socket 大厅模式下,将不会进行切换
	end
	if (self.web_HostURL_Arr == nil  or  (self.web_HostURL_Arr ~= nil  and  #(self.web_HostURL_Arr) <= 0)) then 
		if (onComplete ~= nil) then  onComplete(self); end
		return;
	end
	self.web_Cutt=self.web_Cutt+1;
  
	if (self.web_Cutt > #(self.web_HostURL_Arr)) then 
		self.web_Cutt = 1;
		self.m_cur_web_conf_index = self.m_cur_web_conf_index+1; 

		log("切换线路：第"..self.m_cur_web_conf_index.."个");
		coroutine.start(self.LoadConf_web_hostArr,self,function() 
			 self:swithWebHostUrl_internal(onComplete)  
			 log("切换线路~~~~web IP：第"..self.web_Cutt.."个 :".. self.web_URL);
		end);  
	else
		self:swithWebHostUrl_internal(onComplete);
	end
	
	log("切换web IP：第"..self.web_Cutt.."个 :".. self.web_URL);
end

function this:swithWebHostUrl_internal( onComplete )

	if (self.web_Cutt <= #(self.web_HostURL_Arr)) then
	
		self.hostURL = tostring(self.web_HostURL_Arr[self.web_Cutt]) ;--
		self.web_URL = tostring( self.web_HostURL_Arr[self.web_Cutt]);--web_URL 和 hostURL 是同一个，为了兼容而写成2个
		ConnectDefine.updateConfig(); 
	end

	if (onComplete ~= nil) then onComplete(self); end 
end

--切换socket大厅ip, 已弃用
function this:swithSocketLobbyHostUrl( onComplete)

	self:swithWebHostUrl(false, onComplete);
end
--endregion ip地址不通是,切换ip


 --------------------------------------------------------------------------

--region 获取conf配置文件及ip 相关方法区
function this:LoadConfByUser( username)

	EginUser.Instance.username = username;
	local result = {};
	local coroutine1 = coroutine.start(self.LoadConf_web_hostArr,self)
	local coroutine2 = coroutine.start(self.LoadConf_game_hostArr,self) 
	coroutine.branchMulti({coroutine1,coroutine2})  --并联式启动和停止2个协程
end

function this:Start_LoadAndSaveConfigData(onComplete )
	if onComplete ==nil then onComplete = function() end; end
	coroutine.start(self.LoadAndSaveConfigData,self,onComplete, 0)
end

--/ <summary>
--/ 从网络获取最新的config和conf数据并进行持久化存储(用于加快游戏启动速度, 启动时 首先从本地获取config和ip)
--/ </summary>
--/ <returns></returns>
function this:LoadAndSaveConfigData(onComplete ,   delayTime )
	if delayTime ==nil then delayTime = 15; end
	
	coroutine.wait(delayTime);  
	coroutine.branch(coroutine.start(self.LoadConfig,self))  --重新加载config文件
	 
	 
	local result = {};
	local coroutine1 = coroutine.start(self.LoadConfig_web_hostArr,self, function() end, true)
	local coroutine2 = coroutine.start(self.LoadConfig_game_hostArr,self, function() end, true) 
	coroutine.branchMulti({coroutine1,coroutine2})  --把所有conf文件中有效的 加密的ip 字符串 进行持久化存储

	if (onComplete ~= nil) then onComplete(self); end
end

--region 加载游戏ip相关方法
--/ <summary>
--/ 把所有的conf 的 url 加到一个list中
--/ </summary>
--/ <returns></returns>
function this:LoadConfig_game_hostArr( onComplete ,  isSaveAllConf )
	if isSaveAllConf == nil then isSaveAllConf = false; end
	if (Constants.isEditor) then log("CK : ----------------**********-------------- LoadConfig_Game_hostArr = "); end
	
	self.game_IP_list = self:Loadgame_IP_list();  
	
	coroutine.branch(coroutine.start(self.SwitchConf,self,self.game_IP_list, self.m_cur_game_conf_index, self.LoadGameIPs, function(index, list) 
		if (isSaveAllConf) then 
			self:Save_ListString("game_confName_cryptedStr_list","game_conf_cryptedStr_list", list);
		end--重新获取conf 加密 字符串列表,并持久化存储
		self.m_cur_game_conf_index = index;
	end, isSaveAllConf)) 

	if (onComplete ~= nil)  then onComplete(self); end
end
function this:Loadgame_IP_list()
	local resultList = {};--2个空字符串,是2个占位符,分表代表默认的wfname1和wfname的url地址

	if ( not self:IsNullOrEmpty(EginUser.Instance.username)) then
	
		local gfname1 = PlayerPrefs.GetString(EginUser._GFname1);
		--if (Constants.isEditor) log("CK : ------------------------------LoadConfig_Game_hostArr wfname1 = ".. gfname1);

		if ( not self:IsNullOrEmpty(gfname1)) then
			--resultList[1] = gfname1;  
			table.insert(resultList,{"gfname1",self:StrToList(gfname1,";")});
		end

		local gfname = PlayerPrefs.GetString(EginUser._GFname);
		if ( not self:IsNullOrEmpty(gfname)) then 
			local Game_HostURL = self:UpdateGFnameURL(gfname);
			--resultList[2] = Game_HostURL;
			table.insert(resultList,{"gfname",self:StrToList(Game_HostURL,";")});
			--if (Constants.isEditor) log("CK : ------------------------------LoadConfig_Game_hostArr Game_HostURL = ".. Game_HostURL);
		end
	end 
	for key,value in pairs(self.game_conf_list)  do  
		table.insert(resultList,{self.game_confName_list[key],value});
	end 

	if Utils.Lua_UNITY_EDITOR then
		--[[
		local str = "";  
		for key,value in pairs(resultList)  do  
			str =str..key ..value[1] .." = ".. value[2] .."\r\n";
		end  
		if (Constants.isEditor) then log("CK : ------------------------------ <color=red>result list game</color> = ".. str); end
		]]
		if (Constants.isEditor) then
			log("CK : ------------------------------ <color=red>result list game</color> = ");
			printf(resultList)
		end
	end 
	return  resultList;
end
--/ <summary>
--/ 加载 conf 文件里面的加密字符串(保存在本地) 里的ip
--/ </summary>
--/ <param name="onComplete"></param>
--/ <returns></returns>
function this:LoadConf_game_hostArr( onComplete )

	if (Constants.isEditor) then  log("CK : ----------------**********-------------- LoadConf_Game_hostArr "); end
	 
	 
	-- if self.game_IP_list == nil then
		self.game_IP_list = self:LoadConfgame_IP_list();  
	--end
	

	if( not self:ListExists(self.game_IP_list ,function(a) return not self:IsNullOrEmpty(a[2]); end)   or   not self.IsCache_UserIp) then	
		--不存在有效的conf数据 或者 不使用缓存
		coroutine.branch(coroutine.start(self.LoadConfig_game_hostArr,self,onComplete))  
		return;
	end
	 
	coroutine.branch(coroutine.start(self.SwitchConf,self,self.game_IP_list , self.m_cur_game_conf_index, self.LoadGameIPs, function(index, List) self.m_cur_game_conf_index = index; end))   

	if (onComplete ~= nil) then onComplete(self); end
end
function this:LoadConfgame_IP_list()
	local resultList = {};--1个空字符串,是1个占位符,为用户对应的默认ip

	if ( not self:IsNullOrEmpty(EginUser.Instance.username)) then
	
		local gameIP = EginUser._GameIPForCurUser();
		--if (Constants.isEditor) log("CK : ---------------LoadConf_game_hostArr--------------- gameIP = ".. gameIP);

		if ( not self:IsNullOrEmpty(gameIP)) then 
			table.insert(resultList,{"gameIP",self:StrToList(gameIP,";")});
		end
	end
	
	local tempList = self:Load_ListString("game_confName_cryptedStr_list","game_conf_cryptedStr_list")
	 
	for key,value in pairs(tempList)  do  
		if value ~= "" then
			table.insert(resultList,{value[1],value[2]});
		end 
	end  
	if Utils.Lua_UNITY_EDITOR then
		 --[[
		local str = ""; 
		for key,value in pairs(resultList)  do  
			str =str..key ..value[1].." = ".. value[2] .."\r\n";
		end  
		if (Constants.isEditor) then log("CK : ---------------LoadConf_Game_hostArr--------------- result list game = ".. str); end
		]]
		if (Constants.isEditor) then
			log("CK : ---------------LoadConfgame_IP_list--------------- result list game = "); 
			printf(resultList);
		end
	end 
	return  resultList;
end

function this:LoadGameIPs( isSaveIP,  tempResultStr,  isSaveAllConf)
	if isSaveAllConf == nil then isSaveAllConf =false; end
	local isValidIpLoaded = self:LoadGameIPsT(tempResultStr, isSaveAllConf);--LoadGameIPs(tempResultStr);
	if (isValidIpLoaded  and  isSaveIP) then EginUser.AddGameIPUsers(self:ListToStr(tempResultStr,";")); end--保存用户的ip
	return isValidIpLoaded;  
end
function this:ListExists(list,tempfunction)
	for key,value in pairs(list)  do  
		if (tempfunction(value)) then
			return true;
		end
	end  
	return false;
end

--/ <summary>
--/ 通过加密字符串获取ip地址
--/ </summary>
--/ <param name="tempResultStr"></param>
function this:LoadGameIPsT( tempResultStr,  isSaveAllConf )
	
	if isSaveAllConf == nil then isSaveAllConf =false; end
	--log("CK : -------------------------------------- LoadGameIPs = ".. tempResultStr);
	 
	local game_HostURL_Arr = self:aesDecryptToUrlList(tempResultStr);
	if (game_HostURL_Arr == nil  or  #game_HostURL_Arr <= 0) then return false; end

	if ( not isSaveAllConf  or   not IsCache_UserIp) then--不存在有效的conf数据 或者 不使用缓存
	
		self.game_Cutt = 1;
		self.game_HostURL_Arr = {};
		self.game_HostURL_Arr = game_HostURL_Arr;
		self.game_URL = tostring(self.game_HostURL_Arr[1] );
	end

	if Utils.Lua_UNITY_EDITOR then
		local tempStr = ""; 
		for key,value in pairs(game_HostURL_Arr)  do  
			tempStr =tempStr..value ..",";
		end  
		log("ck debug : -------------------------------- <color=orange>LoadGameIPs </color>= ".. tempStr); 
	end 

	return #game_HostURL_Arr > 0;--大于0 说明获得了有效的ip
end

--/ <summary>
--/ 替换游戏配置文件名
--/ </summary>
--/ <param name="game"></param>
--/ <returns></returns>
function this:UpdateGFnameURL( game)

	local game_HostURL = self.game_HostURL; 
	if (game ~= "") then 
		local arr = string_split(game_HostURL,'/'); 
		game_HostURL = "";
		for  i = 1, (#arr-1) do
			if (i == 1) then 
				game_HostURL = arr[i]; 
			else 
				game_HostURL = game_HostURL .."/".. arr[i];
			end
		end
		game_HostURL = game_HostURL .."/".. game;
	end
	return game_HostURL;
end
--endregion 加载游戏ip相关方法

--region 加载web(大厅)ip 相关方法
--/ <summary>
--/ 把所有的conf 的 url加到一个list中
--/ </summary>
--/ <returns></returns>
function this:LoadConfig_web_hostArr( onComplete ,  isSaveAllConf )
	if isSaveAllConf ==nil then isSaveAllConf = false; end
	log("CK : -------------------**********----------- LoadConfig_web_hostArr ");
	
	self.web_IP_list = self:Loadweb_IP_list();  
	
	if self.webConfListInit ~= nil then
		self.webConfListInit()
	end
	
	 
	coroutine.branch(coroutine.start(self.SwitchConf,self,self.web_IP_list,self.m_cur_web_conf_index,self.LoadWebIPs, function(index, list)   
		self.m_cur_web_conf_index = index;   
		if (isSaveAllConf) then   self:Save_ListString("web_confName_cryptedStr_list","web_conf_cryptedStr_list", list); end--重新获取conf 加密 字符串列表,并持久化存储
	end,isSaveAllConf))  
 
	if (onComplete ~= nil)  then onComplete(self); end
end
function this:Loadweb_IP_list()
	local resultList = {};--2个空字符串,是2个占位符,分表代表默认的wfname1和wfname的url地址

	if ( not self:IsNullOrEmpty(EginUser.Instance.username)) then
	
		local wfname1 = PlayerPrefs.GetString(EginUser._WFname1);
		--if(Constants.isEditor) log("CK : ------------------------------LoadConfig_web_hostArr wfname1 = ".. wfname1);
		 
		if ( not self:IsNullOrEmpty(wfname1)) then
			--resultList[1] = wfname1; 
			table.insert(resultList,{"wfname1",self:StrToList(wfname1,";")});
		end
		
		local wfname = PlayerPrefs.GetString(EginUser._WFname); 
		if ( not self:IsNullOrEmpty(wfname)) then 
			local web_HostURL = self:UpdateWFnameURL(wfname);
			--resultList[2] = web_HostURL;
			table.insert(resultList,{"wfname",self:StrToList(web_HostURL,";")});
			--if (Constants.isEditor) log("CK : ------------------------------LoadConfig_web_hostArr web_HostURL = ".. web_HostURL);
		end
	end
	for key, value in pairs(self.web_conf_list) do
            table.insert(resultList,{self.web_confName_list[key],value});
        end 
		
	if Utils.Lua_UNITY_EDITOR then 
		--[[
		local str = "";
		for i =1, #resultList do 
			str = str..i..resultList[i][1].." = ".. resultList[i][2] .."\r\n";
		end
		log("CK : ------------------------------ result list web = ".. str );
		]]
		log("CK : ------------------------------ result list web = ");
		printf(resultList)
	end 
	
	return resultList;
end
--/ <summary>
--/ 加载 conf 文件里面的加密字符串(保存在本地) 里的ip
--/ </summary>
--/ <param name="onComplete"></param>
--/ <returns></returns>
function this:LoadConf_web_hostArr( onComplete )

	--log("CK : -------------------**********----------- LoadConf_web_hostArr = "..self.m_cur_web_conf_index);
	--if self.web_IP_list == nil then
		self.web_IP_list = self:LoadConfweb_IP_list();
	--end 
	
	if( not self:ListExists(self.web_IP_list,function(a) return not self:IsNullOrEmpty(a[2]); end)   or   not self.IsCache_UserIp) then	
		--不存在有效的conf数据 或者 不使用缓存 
		self.web_IP_list = nil; 
		coroutine.branch(coroutine.start(self.LoadConfig_web_hostArr,self,onComplete))  
		return;
	end
	
	coroutine.branch(coroutine.start(self.SwitchConf,self,self.web_IP_list,self.m_cur_web_conf_index,self.LoadWebIPs, function(index, list)  
		self.m_cur_web_conf_index = index;   
	end))  
	
	if (onComplete ~= nil) then onComplete(self); end
end
function this:LoadConfweb_IP_list()
	local resultList = {};--1个空字符串,是1个占位符,分表代表默认的wfname1和wfname的url地址

	if ( not self:IsNullOrEmpty(EginUser.Instance.username)) then
	
		local webIP = EginUser._WebIPForCurUser();
		--if (Constants.isEditor) log("CK : ----------------LoadConf_web_hostArr-------------- webIP = ".. webIP);
		 
		if ( not self:IsNullOrEmpty(webIP)) then 
			table.insert(resultList,{"webIP",self:StrToList(webIP,";")});
		end
	end
	local tempList = self:Load_ListString("web_confName_cryptedStr_list","web_conf_cryptedStr_list");
	for key, value in pairs(tempList) do
		table.insert(resultList,{value[1],value[2]});  
	end   
	
	if Utils.Lua_UNITY_EDITOR then
		--[[
		local str = "";
		for i =1, #resultList do  
			str = str..i ..resultList[i][1].." = ".. resultList[i][2] .."\r\n";
		end
		if (Constants.isEditor) then log("CK : --------------LoadConf_web_hostArr---------------- result list web = ".. str); end
		]]
		if (Constants.isEditor) then 
			log("CK : --------------LoadConfweb_IP_list---------------- result list web = ");
			printf(resultList)
		end
	end
	
	
	return resultList;
end


function this:LoadWebIPs(isSaveIP,  tempResultStr,  isSaveAllConf )
	if isSaveAllConf == nil then isSaveAllConf = false; end
	local isValidIpLoaded = self:LoadWebIPsT(tempResultStr,isSaveAllConf);--LoadGameIPs(tempResultStr);
	if (isValidIpLoaded  and  isSaveIP) then  EginUser.AddWebIPUsers(self:ListToStr(tempResultStr,";")); end--保存用户的ip
	return isValidIpLoaded; 
end

--/ <summary>
--/ 从加密字符串中获取web ip地址
--/ </summary>
--/ <param name="tempResultStr"></param>
function this:LoadWebIPsT( tempResultStr,  isSaveAllConf)
	if isSaveAllConf == nil then isSaveAllConf = false; end 
	local web_HostURL_Arr = self:aesDecryptToUrlList(tempResultStr, not self.IsSocketLobby);
	 
	if (web_HostURL_Arr == nil  or  #(web_HostURL_Arr) <= 0) then  return false; end
	
	if ( not isSaveAllConf  or   not self.IsCache_UserIp) then --不存在有效的conf数据 或者 不使用缓存
		 
		self.web_Cutt = 1;
		self.web_HostURL_Arr = nil
		self.web_HostURL_Arr = web_HostURL_Arr;
		self.web_URL = tostring(self.web_HostURL_Arr[1]);
		self.hostURL = tostring(self.web_HostURL_Arr[1]);

		if (Constants.isEditor) then 
		
			local tempStr = "";
			for  key, item in pairs(web_HostURL_Arr) do  
				tempStr = tempStr..item ..", ";
			end 
			log("ck debug : --------------------------------<color=red> LoadWebIPs = </color>".. tempStr);
		end
	end 
	return (#(self.web_HostURL_Arr) > 0);
end

--/ <summary>
--/ 替换web配置文件名
--/ </summary>
--/ <param name="web"></param>
--/ <returns></returns>
function this:UpdateWFnameURL( web)

	local web_HostURL = self.web_HostURL;
	if (web ~= "") then 
		local arr = string.split(web_HostURL,'/');
		web_HostURL = "";
		 for key, value in pairs(arr) do
			if (key == 1) then
				web_HostURL = value; 
			else 
				web_HostURL = web_HostURL .."/"..value;
			end
		end 
		web_HostURL = web_HostURL .."/".. web;
	end 
	log("web_HostURL".. web_HostURL);
	return web_HostURL;
end
--endregion 加载web(大厅)ip 相关方法

--region 解密配置文件中的加密字符串的方法
--/ <summary>
--/ 把加密数据的解密后数据装换成list
--/ </summary>
--/ <param name="isHttp"></param>
--/ <param name="tempResultStr"></param>
--/ <returns></returns>
function this:aesDecryptToUrlList( tempResultStr,  isHttp )
	if isHttp == nil then isHttp =false; end 
	local tempTables = {};  
	if type(tempResultStr) == "table" then
	 
		for key,value in pairs(tempResultStr)  do  
			local tempList =  Utils.aesDecryptToUrlList(value,isHttp) 
			local tempTable = {}; 
			Utils.ArryListToLuaTable(tempList,tempTable) 
			table.insert(tempTables,tempTable) 
		end  
	else 
		local tempList =  Utils.aesDecryptToUrlList(tempResultStr,isHttp) 
		local tempTable = {}; 
		Utils.ArryListToLuaTable(tempList,tempTable) 
		table.insert(tempTables,tempTable)
	end
	
	local tempTable = {}; 
	for key,value in pairs(tempTables)  do  
		for key2,value2 in pairs(value)  do   
			table.insert(tempTable,value2) 
		end  
	end  
	return tempTable; 
end
 
--endregion 解密配置文件中的加密字符串的方法
--endregion 获取conf配置文件及ip 相关方法区


--region 辅助方法区
--region 把xml配置文件中的某项值解析到List中,该值可以是string也可以是string 数组
function this:ParseArrayOrStringJson( arrayOrStringJson,  result_List )

	if (result_List == nil) then result_List = {}; end
	local url = nil;
	if ( self:IsAvailable(arrayOrStringJson)) then  
		if (type(arrayOrStringJson) == "table") then 
			for i = 1,  #arrayOrStringJson do  
				url = System.Text.RegularExpressions.Regex.Unescape(tostring(arrayOrStringJson[i]));--热更新url地址
				if ( not tableContains(result_List,url)) then table.insert(result_List,url); end
			end
		 elseif (type(arrayOrStringJson) == "string"  and   not self:IsNullOrEmpty(tostring(arrayOrStringJson))) then 
			url = System.Text.RegularExpressions.Regex.Unescape(tostring(arrayOrStringJson));--热更新url地址
			if ( not tableContains(result_List,url)) then table.insert(result_List,url); end
		end
	end

	return result_List;
end
--对比两个Table中的对象是否相同
function this:TableSameTable(table1,table2)
	local isSame = true;
	local isSameLocal = false;
	for  key1, item1 in pairs(table1) do   
		isSameLocal = false;
		for  key2, item2 in pairs(table2) do   
			if (item2 == item1) then
				 isSameLocal = true;
			end
		end 
		
		if not isSameLocal then
			isSame = false;
			break;
		end
	end
	return isSame;
end
--第一个Table是否包含第二个table
function this:TableContainsTable(table1,table2)
	local iscontains = false; 
	for  key1, item1 in pairs(table1) do   
		if type(item1) == "table" then
			if self:TableSameTable(item1,table2) then
				iscontains = true;
				break;
			end
		end  
	end
	return iscontains;
end
--整理ip列表
function this:ParseArrayOrStringJsonIP( arrayOrStringJson, arrayOrStringJson2, result_List,result_List2 )

	if (result_List == nil) then result_List = {}; end
	if (result_List2 == nil) then result_List2 = {}; end
	local url = nil;
	if ( self:IsAvailable(arrayOrStringJson)) then  
		if (type(arrayOrStringJson) == "table") then 
			for i = 1,  #arrayOrStringJson do   
				local tempJson = arrayOrStringJson[i];
				if (type(tempJson) == "table") then 
				
					
					local urlList = {};
					for i = 1,  #tempJson do    
						url = System.Text.RegularExpressions.Regex.Unescape(tostring(tempJson[i]));--热更新url地址  
						table.insert(urlList,url);
					end
					if (not self:TableContainsTable(result_List,urlList)) then 
						table.insert(result_List,urlList);
						local tempstr = nil
						if self:IsAvailable(arrayOrStringJson2) and arrayOrStringJson2[i] ~=nil then
							tempstr = tostring(arrayOrStringJson2[i])
						else
							tempstr = "线路"..(#(result_List2)+1);
						end
						table.insert(result_List2,tempstr);
					end 
				 elseif (type(tempJson) == "string"  and   not self:IsNullOrEmpty(tostring(tempJson))) then 
					url = System.Text.RegularExpressions.Regex.Unescape(tostring(tempJson));--热更新url地址  
					if (not tableContains(result_List,url)) then  
						table.insert(result_List,url);
						local tempstr = nil
						if self:IsAvailable(arrayOrStringJson2) and arrayOrStringJson2[i] ~=nil then
							tempstr = tostring(arrayOrStringJson2[i])
						else
							tempstr = "线路"..(#(result_List2)+1);
						end
						table.insert(result_List2,tempstr);
					end
				end 
			end
		 elseif (type(arrayOrStringJson) == "string"  and   not self:IsNullOrEmpty(tostring(arrayOrStringJson))) then 
			url = System.Text.RegularExpressions.Regex.Unescape(tostring(arrayOrStringJson));--热更新url地址
			if ( not tableContains(result_List,url)) then
				table.insert(result_List,url); 
				local tempstr = nil
				if self:IsAvailable(arrayOrStringJson2) and type(arrayOrStringJson2) == "string" then
					tempstr = tostring(arrayOrStringJson2)
				else
					tempstr = "线路"..(#(result_List2)+1);
				end
				table.insert(result_List2,tempstr);  
			end
		end
	end

	return result_List,result_List2;
end
--获取列表索引中的第一个对象
function this:GetListOneObj( list, index)
	local tempobj = list[index];
	if type(list[index]) == "string"  then
	
	elseif type(list[index]) == "table" then
		tempobj = tempobj[1];
	else
		tempobj = nil
	end
	
	return tempobj
end
--endregion 把xml配置文件中的某项值解析到List中,该值可以是string也可以是string 数组

--region 对所有的url进行ping处理,如果在2秒内没有ping通,那么就认为该地址无法连接
function this:ObtainPingUrls( urls, resultList)

	if (resultList == nil)  then return; end
	local pingMap = {};
	--List<string> resultList = new List<string>();

	for i = 1,#urls do 
	
		local ping = StaticUtils.ObtainPingFromUrl(urls[i]);--获取所有的ping对象
		if (ping ~= nil) then  pingMap[urls[i]] = ping; end-- StaticUtils.ObtainPingFromUrl(urls[i]);--获取所有的ping对象
	end

	local pingMapTime = {};
	local pingList = {};
	local curTime = 0;

	while (#pingList < #pingMap  and  curTime < 2) do--1秒内ping通为有效
	
		curTime = curTime +Time.deltaTime;
		for  key, item in pairs(pingMap) do  
		
			if (item.Value.isDone  and   not tableContains(pingList,item.Value)  and   not "127.0.0.1"==item.Value.ip) then
				table.insert(pingList,item.Value);--添加用于排序的ping list
				pingMapTime[item.Value] = item.Key;--添加ping 和 原路径的映射关系
			end
		end
		coroutine.wait(0);
	end

	table.sort(pingList,function(a, b) return b.time < a.time; end);--通过时间排序
	for key, item in pairs(pingList) do 
		table.insert(resultList,pingMapTime[item]) --获得排序后的连接地址
	end

	for   key, item in pairs(urls) do 
	
		if ( not tableContains(resultList,item)) then table.insert(resultList,item); end--获得排序后没有添加在内的地址--避免默写host ping的时间大于2秒被遗漏. 连不通的地址很快就会被断开
	end

	for key, item in pairs(pingMap) do 
	
		item.Value:DestroyPing();--销毁ping对象
	end

	pingList = nil;--清空
	pingMapTime = nil;--清空
	pingMap = nil;--清空
	pingMap = nil;
end
--endregion 对所有的url进行ping处理,如果在2秒内没有ping通,那么就认为该地址无法连接

--region 切换 conf 文件. 并通过conf,切换ip地址
function this:SwitchConf( game_HostURL,  curIndex,  loadIpsFunc,  onComplete,  isSaveAllConf)
	if isSaveAllConf == nil then isSaveAllConf = false end 

	--game_HostURL_Arr.Clear(); 
	local result = nil;
	local config_url = nil;-- game_HostURL .."?".. ro.NextDouble();
	local www_config = nil;-- HttpConnect.Instance.HttpRequestAli(config_url);
	local tempResultStr = nil;-- www_config.text.Trim();
	local isConfUrl = false;
	local tempIndex = 0;
	if (curIndex > #(game_HostURL)) then  curIndex = 1; end
	log("jun : ~~~~~~~~curIndex = "..curIndex.."; #(game_HostURL) = "..#(game_HostURL))
	--[[
	local conf_crypted_list = {}; 
	for i=curIndex, #(game_HostURL) do 
		if (not self:IsNullOrEmpty(game_HostURL[curIndex][2])) then --如果字符串(url)为空,就遍历后面的,
			config_url = game_HostURL[curIndex][2];
			tempResultStr = nil; 
			local tempstr = string.lower(config_url); 
			isConfUrl = (string.len(tempstr) == string.find(tempstr,".conf")+4) 
			if (isConfUrl) then --是conf文件的url 
				result = CoroutineResult.New();
				config_url = config_url .."?".. math.Random(0, 1);   
				local iscoroutine = DoneCoroutine.New();
				StaticUtils.StartCoroutineLuaToC(StaticUtils.WWWReConnect( result, config_url,nil, 8, 1),iscoroutine);
				coroutine.branchC(iscoroutine);  
				www_config = result._wwwResult;
				if (result.error == nil  and  www_config.error == nil) then 
					tempResultStr = string.gsub(www_config.text," ","") 
					StaticUtils.DisposeAsync(www_config)
					www_config = nil;  
				end 
			else--字符串不是conf文件--这里的情况为直接base64加密后的字符串,也就是conf文件里面的内容 
				tempResultStr = config_url; 
			end 
			local tempBool = loadIpsFunc(self,(curIndex == 0  and  isConfUrl), tempResultStr, isSaveAllConf);
			 
			if tempResultStr ~= nil  and  tempBool then 
			--获得到有效ip后跳出循环--只有第一个是需要保存ip加密数据的url地址 
				if (isSaveAllConf) then   
					table.insert(conf_crypted_list,tempResultStr)
				else 
					curIndex=curIndex+1;--获取成功后curIndex 需要+1. 避免死循环加载出有效的ip地址,而ip地址却无法正常连接到后台的bug
					break;
				end 
			end 
		end
		curIndex =curIndex +1;
	end
	 ]]
	  
	 --local conf_crypted_list = {}; 
	 local whileNum = #(game_HostURL)
	 while( whileNum > 0 ) do 
		if (not self:IsNullOrEmpty(game_HostURL[curIndex][2])) then --如果字符串(url)为空,就遍历后面的,
			local config_urlList = nil
			if type(game_HostURL[curIndex][2]) == "table" then
				config_urlList = game_HostURL[curIndex][2];
			else
				config_urlList = {};
				config_urlList[1] = game_HostURL[curIndex][2];
			end
			
			tempResultStr = {};
			
			for key, config_url in pairs(config_urlList) do 
				local tempstr = string.lower(config_url); 
				local confNum = string.find(tempstr,"%.conf");
				if confNum == nil then
					confNum = -1;
				end 
				isConfUrl = (string.len(tempstr) == confNum+4) 
				if (isConfUrl) then --是conf文件的url 
					result = CoroutineResult.New();
					config_url = config_url .."?".. math.Random(0, 1);   
					local iscoroutine = DoneCoroutine.New();
					StaticUtils.StartCoroutineLuaToC(StaticUtils.WWWReConnect( result, config_url,nil, 8, 1),iscoroutine);
					coroutine.branchC(iscoroutine);  
					www_config = result._wwwResult;
					if (result.error == nil  and  www_config.error == nil) then 
						log(""..www_config.text)
						local tempResult = string.gsub(www_config.text," ","");
						table.insert(tempResultStr,tempResult);
						StaticUtils.DisposeAsync(www_config)
						www_config = nil;  
					end 
				else--字符串不是conf文件--这里的情况为直接base64加密后的字符串,也就是conf文件里面的内容  
					table.insert(tempResultStr,config_url);
				end  
			end 
			
			local tempBool = loadIpsFunc(self,(curIndex == 1  and  isConfUrl), tempResultStr, isSaveAllConf);
			 
			if #(tempResultStr) > 0  and  tempBool then 
				log("jun : ~~~~~~~~~~~~~得到有效ip的conf下标"..curIndex)
			
				--获得到有效ip后跳出循环--只有第一个是需要保存ip加密数据的url地址 
				if (isSaveAllConf) then   
					--table.insert(conf_crypted_list,tempResultStr)
					if #(tempResultStr) == 1 then
						game_HostURL[curIndex][2] = tempResultStr[1];
					else
						game_HostURL[curIndex][2] = tempResultStr;
					end
					--记录第一个得到有效ip的conf下标
					if tempIndex == 0 then
						tempIndex = curIndex; 
					end 
				else 
					--在切换ip的地方进行了+1操作
					--curIndex=curIndex+1;--获取成功后curIndex 需要+1. 避免死循环加载出有效的ip地址,而ip地址却无法正常连接到后台的bug
					 
					break;
				end 
			else
				
			end 
		end 
		curIndex =curIndex +1; 
		if (curIndex > #(game_HostURL)) then  curIndex = 1; end
		
		whileNum = whileNum-1;
	end 

	--如果是循环一遍者ip序号回溯到第一次得到有效ip的地方
	if (isSaveAllConf) then  
		if tempIndex == 0 then
			log("jun : ~~~~~~~~~~~~~未找到有效ip的conf文件")
		else
			curIndex = tempIndex; 
		end 
		
	end 

	if (onComplete ~= nil) then onComplete(curIndex, game_HostURL); end
end
--endregion 切换 conf 文件,

--region 加载/存储 conf 加密数据列表
function this:Load_ListString( key1,key2)

	local str1 = PlayerPrefs.GetString(EginUser.ObtainPlatformKey(key1), "");
	local str2 = PlayerPrefs.GetString(EginUser.ObtainPlatformKey(key2), "");
	 
	local resultList1 = {}
	if str1~= nil then
		resultList1 = string.split(str1,",")
	end
	
	local resultList2 = string.split(str2,",")  
 
	local resultList = {};
	for  i = 1, #(resultList2) do   
		if resultList1[i]~=nil then
			table.insert(resultList,{resultList1[i],self:StrToList(resultList2[i],";")})
		else
			table.insert(resultList,{tostring(i),self:StrToList(resultList2[i],";")})
		end   
	end  
	return resultList;
end

function this:Save_ListString( key1,key2, list)

	if (list == nil  or  #(list) <= 0) then return; end
	local str1 = "";
	local str2 = "";
	for  i = 1, #(list) do 
		local str = self:ListToStr(list[i][2],";");
		if i == #(list) then
			str1 =str1..list[i][1];
			str2 =str2..str;
		else
			str1 =str1..list[i][1]..",";
			str2 =str2..str..",";
		end 
	end   
	PlayerPrefs.SetString(EginUser.ObtainPlatformKey(key1), str1); 
	PlayerPrefs.SetString(EginUser.ObtainPlatformKey(key2), str2);
	PlayerPrefs.Save();
end
--将Table连成字符串
function this:ListToStr(list,temp) 
	local str = ""
	if type(list) == "table" then
		for key,value in pairs(list)  do  
			if str == "" then
				str = value
			else
				str = str..temp..value
			end 
		end  
	else
		str = list
	end
	
	return str;
end
--将字符串组成Table
function this:StrToList(str,temp)
 
	local resultList = {}
	if str~= nil then
		resultList = string.split(str,temp)
		if #(resultList) == 1 then
			return resultList[1];
		end
	else
		return "";
	end 
	return resultList;
end
--endregion 加载/存储 conf 加密数据列表
function this:IshandselGame(gamename)
	if self.handselGameList then
		for tKey,tValue in ipairs(self.handselGameList) do
			if tValue == gamename then
				return true;
			end
		end 
	end
	
	return false
end


--region 修改不同平台下的config.xml文件名
function this:FixConfigUrls( urls)

	if (urls == nil) then return; end

	for  i = 1, #urls do   
		
		urls[i] = self:FixConfig(urls[i], self.IsSocketLobby);
		 
	end
end

function this:FixConfig( url,  isSocket)

	if (self:IsNullOrEmpty(url)) then return url; end

	local fileName = Path.GetFileName(url);
	local	resultFileName = fileName;
	local fileNameWithOutExtension = Path.GetFileNameWithoutExtension(url);
	 
	if tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_AppStore then --ios app stroe 使用 config.xml
	 
	elseif tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_Enterprise then --企业版使用 config888.xml
		resultFileName = string.gsub(fileName,fileNameWithOutExtension, fileNameWithOutExtension .."888") 
	 
	elseif tostring(Utils.BUILDPLATFORM) == BuildPlatform.OSX then --mac osx 版本, 使用 config777.xml
			resultFileName = string.gsub(fileName,fileNameWithOutExtension, fileNameWithOutExtension .."777") 
			 
	elseif true or tostring(Utils.BUILDPLATFORM) == BuildPlatform.Win or  tostring(Utils.BUILDPLATFORM) == BuildPlatform.Android then --android 使用 config999.xml
	 
		resultFileName = string.gsub(fileName,fileNameWithOutExtension, fileNameWithOutExtension .."999") 
	end 
	if (isSocket) then  
		resultFileName = "socket_".. resultFileName;  
	end--socket 协议的xml, 文件名添加 socket_ 前缀 
	return  string.gsub(url,fileName, resultFileName) 
end
--endregion 修改不同平台下的config文件名

function this:GetPlatformPrefix() 
	-------
	--return Utils.playformUtil:GetPlatformPrefix()
	
	
	local platform_prefix = "";
	if (Utils.PlayformName =="PlatformGame1977"  or  Utils.PlayformName =="PlatformGame597" ) then
		platform_prefix = "597";
	elseif (Utils.PlayformName =="PlatformGame407" ) then
		platform_prefix = "131";
	elseif (Utils.PlayformName =="PlatformGame510k"  ) then
		platform_prefix = "510k";
	end
	return platform_prefix;
	
end
--endregion 辅助方法区

