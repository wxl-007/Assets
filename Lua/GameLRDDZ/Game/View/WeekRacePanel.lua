WeekRacePanel = {}
local self = WeekRacePanel

local transform
local gameObject
local mono

local last_rank50
local sum_score
local awards
local ave_score
local rank
local restseconds
local top50
local gameend
local range
local round
local close
local tag
local win_round
local fail_round

local recPlayerNum = 0

local recSession = nil

local lastMatchRank = 0

--131正式服
self.CJF_MATCH_INFO = "http://139.196.107.158/unity/htddz/user_rank_info/"
self.CJF_MATCH_VER = "http://139.196.107.158/unity/htddz/send_phone_code/"
self.CJF_MATCH_GET_JD_CARD = "http://139.196.107.158/unity/htddz/reward_jd_card/"
--测试服
-- self.CJF_MATCH_INFO = "http://114.215.158.161/unity/htddz/user_rank_info/"
-- self.CJF_MATCH_VER = "http://114.215.158.161/unity/htddz/send_phone_code/"
-- self.CJF_MATCH_GET_JD_CARD = "http://114.215.158.161/unity/htddz/reward_jd_card/"

-- self.CJF_MATCH_INFO = "http://114.215.156.145/unity/htddz/user_rank_info/"
-- self.CJF_MATCH_VER = "http://114.215.156.145/unity/htddz/send_phone_code/"
-- self.CJF_MATCH_GET_JD_CARD = "http://114.215.156.145/unity/htddz/reward_jd_card/"



function WeekRacePanel.Awake(obj)
	print("Awke WeekRacePanel");
	obj:SetActive(true)
	gameObject = obj
	transform = obj.transform
	mono = gameObject:GetComponent('LRDDZ_LuaBehaviour');
	self.init()
end 
function self.init()

	self.sce1 = transform:FindChild("Label_sce1"):GetComponent("UILabel")
	self.rule = transform:FindChild("Rule").gameObject
	self.rule:SetActive(false)
	self.btnrule = transform:FindChild("btnRule").gameObject
	mono:AddClick(self.btnrule,WeekRacePanel.OnRuleCallBack)
	mono:AddClick(self.rule.transform:FindChild("btn_close").gameObject,WeekRacePanel.OnRuleCallBack)


	self.rank = transform:FindChild("Rank").gameObject
	self.rank:SetActive(false)
	self.btnrank = transform:FindChild("btnrank").gameObject
	mono:AddClick(self.btnrank,WeekRacePanel.OnRankCallBack)
	mono:AddClick(self.rank.transform:FindChild("btnclose").gameObject,WeekRacePanel.OnRankCallBack)


	self.btnclose = transform:FindChild("btnExit").gameObject
	mono:AddClick(self.btnclose,WeekRacePanel.OnCloseCallBack)

	self.btnApply = transform:FindChild("btnapply").gameObject
	mono:AddClick(self.btnApply,WeekRacePanel.OnApplyCallBack)
	self.btnAward = transform:FindChild("btnaward").gameObject
	self.btnAward:GetComponent("UIButton").isEnabled = false
	mono:AddClick(self.btnAward,self.OnAwardCallBack)
	self.eff = transform:FindChild("cansai").gameObject
	self.eff:SetActive(false)



	--排行榜
	self.lb_rank = self.rank.transform:FindChild("ScrollView/Label_rank"):GetComponent("UILabel")
	self.lb_rank_name = self.rank.transform:FindChild("ScrollView/Label_name"):GetComponent("UILabel")
	self.lb_rank_round = self.rank.transform:FindChild("ScrollView/Label_round"):GetComponent("UILabel")
	self.lb_rank_win = self.rank.transform:FindChild("ScrollView/Label_win"):GetComponent("UILabel")
	self.lb_rank_lose = self.rank.transform:FindChild("ScrollView/Label_lose"):GetComponent("UILabel")
	self.lb_rank_score = self.rank.transform:FindChild("ScrollView/Label_score"):GetComponent("UILabel")

	coroutine.start(self.LoadInof)

	self.SetRank(top50)

	--领取奖励
	self.award = transform:FindChild("Award").gameObject
	self.input_phone = self.award.transform:FindChild("Label_phonenumb"):GetComponent("UIInput")
	--绑定的手机号
	if EginUser.Instance.telephone ~= nil and EginUser.Instance.telephone ~= "" and string.len(EginUser.Instance.telephone) == 11 then
		self.input_phone.value = tostring(EginUser.Instance.telephone)
	end

	self.input_verin = self.award.transform:FindChild("Label_verification"):GetComponent("UIInput")
	self.btnGetVern = self.award.transform:FindChild("btnGetVern").gameObject
	self.btnOk = self.award.transform:FindChild("btnOk").gameObject
	self.btncloseAward = self.award.transform:FindChild("btn_awardclose").gameObject
	mono:AddClick(self.btnGetVern,self.OnAwardGetVernCallBack)
	mono:AddClick(self.btnOk,self.OnAwardOkCallBack)
	mono:AddClick(self.btncloseAward,self.OnCloseAwardCallBack)
	self.lb_verinTimer = self.award.transform:FindChild("Label_btntime"):GetComponent("UILabel")
	self.vertimer = Timer.New(self.VerificationTimer,1,-1,true) --验证码计时器


	--弹出获奖提示
	self.hasawardPanel = transform:FindChild("HasAwardPanel").gameObject
	self.btnget = self.hasawardPanel.transform:FindChild("btnget").gameObject
	self.lb_desc = self.hasawardPanel.transform:FindChild("Label_Desc"):GetComponent("UILabel")
	self.sp_title = self.hasawardPanel.transform:FindChild("Sprite_title"):GetComponent("UISprite")
	self.btnclosepanel = self.hasawardPanel.transform:FindChild("btnclosepanel").gameObject
	mono:AddClick(self.btnget,self.OnAwardCallBack)
	mono:AddClick(self.btnclosepanel,self.OnCloseHasAwardPanelCallBack)




	--提示信息
	self.tipobj = transform:FindChild("Tips").gameObject
	self.lb_tips = transform:FindChild("Tips/Label_desc"):GetComponent("UILabel")

	--等待
	self.waitting = transform:FindChild("Waitting").gameObject
	self.lb_waitting = transform:FindChild("Waitting/Label_desc"):GetComponent("UILabel")
	self.waitting:SetActive(false)
	self.waittingtimer = Timer.New(WeekRacePanel.CountWaittingTime,1,-1,true)
	--物品显示
	self.itembtn = {}
	for i=1,7 do
		local btn = transform:FindChild("AwardDesc/item/btnitem"..i).gameObject
		mono:AddClick(btn,self.OnItemCallBack)
	end
	self.itemobj = transform:FindChild("itemInfo").gameObject
	self.itemName = transform:FindChild("itemInfo/Label_name"):GetComponent("UILabel")
	self.itemNum = transform:FindChild("itemInfo/Label_num"):GetComponent("UILabel")
	self.itemUsed = transform:FindChild("itemInfo/Label_use"):GetComponent("UILabel")
	self.itemIcon = transform:FindChild("itemInfo/Sprite_iocn"):GetComponent("UISprite")
	self.itemDesc = transform:FindChild("itemInfo/Label_desc"):GetComponent("UILabel")
	mono:AddClick(transform:FindChild("itemInfo/btnitemclose").gameObject,self.OnCloseItemCallBack)


	if tag == "apply" or restseconds == -1 or restseconds > 0 then
		self.btnApply:SetActive(true)
	else
		self.btnApply:SetActive(false)
	end

	self.timer = Timer.New(WeekRacePanel.CountDown,1,-1,true)--比赛开始倒计时
	WeekRacePanel.SetTime(restseconds)


end
function self.OnCloseItemCallBack(  )
	self.itemobj:SetActive(false)
end
function self.OnItemCallBack(go)
	local index = tonumber(string.sub(go.name,-1))
	self.itemName.text = WeekMatchAward[index].name
	self.itemNum.text = WeekMatchAward[index].value
	self.itemUsed.text = WeekMatchAward[index].usedesc
	self.itemDesc.text = WeekMatchAward[index].otherdesc
	self.itemIcon.spriteName = WeekMatchAward[index].icon
	self.itemobj:SetActive(true)
end
function self.ShowTipsMsg(msg)
	self.lb_tips.text = msg
	self.tipobj:SetActive(true)
	local function func()
		coroutine.wait(3)
		self.tipobj:SetActive(false)
	end
	coroutine.start(func)
end
function self.setPopAward()
	if lastMatchRank > 20  then
		self.sp_title.spriteName ="获得金币"
		self.sp_title:MakePixelPerfect()
		self.btnclosepanel:SetActive(true)
		self.btnget:SetActive(false)
	else
		self.sp_title.spriteName = "获得京东卡"
		self.sp_title:MakePixelPerfect()
		self.btnclosepanel:SetActive(false)
		self.btnget:SetActive(true)
	end
end
function self.OnCloseHasAwardPanelCallBack(  )
	self.hasawardPanel:SetActive(false)
	self.btnAward:GetComponent("UIButton").isEnabled = false
end
function self.OnAwardGetVernCallBack()
	if self.input_phone.value == "" then
		return
	end
	coroutine.start(self.SendGetVerification)
end
function self.SendGetVerification(  )
	--请求验证码
	--[[
	if recSession == nil then
		local form = UnityEngine.WWWForm.New();
		local Username = UnityEngine.PlayerPrefs.GetString("EginUsername")
		form:AddField("username",Username);
		form:AddField("password",UnityEngine.PlayerPrefs.GetString(Username));
		local www = HttpConnect.Instance:HttpRequest(self.LOGIN_URL, form);
	    coroutine.www(www);
	    recSession = www.responseHeaders['SET-COOKIE']
	end
	]]
	local pForm = UnityEngine.WWWForm.New();
	pForm:AddField("type",0) --0:使用绑定手机号发送验证码 1:使用当前输入手机号发送验证码(推荐)
	--pForm:AddField("mobile",self.input_phone.value)
	pForm:AddField("userid",EginUser.Instance.uid)
	local infowww = HttpConnect.Instance:HttpRequest(self.CJF_MATCH_VER, pForm)
    coroutine.www(infowww)
    local jsonmsg = cjson.decode(infowww.text)
    if jsonmsg["body"]~= nil then
    	self.ShowTipsMsg(jsonmsg["body"])
    	
    end 
    if jsonmsg["result"]~=nil and jsonmsg["result"] == "ok" then
    	self.btnGetVern:SetActive(false)
    	self.vertimer:Start()
    end
end
local sumtime = 60
function self.VerificationTimer()
	sumtime = sumtime - 1
	if sumtime >= 0 then
		self.lb_verinTimer.text = "请稍候("..sumtime.."s)"
	else
		self.btnGetVern:SetActive(true)
		self.vertimer:Stop()
		self.lb_verinTimer.text = ""
	end
end
function self.OnAwardOkCallBack(  )
	if self.input_verin.value ~= "" then
		--发送领取信息
		coroutine.start(self.SendGetAward)
		self.input_verin.value = ""
	end
end
function self.SendGetAward( )
	--[[
	if recSession == nil then
		local form = UnityEngine.WWWForm.New();
		local Username = UnityEngine.PlayerPrefs.GetString("EginUsername")
		form:AddField("username",Username);
		form:AddField("password",UnityEngine.PlayerPrefs.GetString(Username));
		local www = HttpConnect.Instance:HttpRequest(self.LOGIN_URL, form);
	    coroutine.www(www);
	    recSession = www.responseHeaders['SET-COOKIE']
	end
	]]
	local pForm = UnityEngine.WWWForm.New();
	pForm:AddField("type",0) --0:使用绑定手机号发送验证码 1:使用当前输入手机号发送验证码(推荐)
	--pForm:AddField("mobile",self.input_phone.value)
	pForm:AddField("phonecode",self.input_verin.value)
	pForm:AddField("roomid",2095)
    pForm:AddField("userid",EginUser.Instance.uid)
	local infowww = HttpConnect.Instance:HttpRequest(self.CJF_MATCH_GET_JD_CARD, pForm)
    coroutine.www(infowww)
    --测试消息
    --local temp = "{\"result\": \"ok\",\"body\": \"领取成功\"}"
	--local jsonmsg = cjson.decode(temp)
   	local jsonmsg = cjson.decode(infowww.text)
    if jsonmsg["body"]~= nil then
    	self.ShowTipsMsg(jsonmsg["body"])
    end
    if jsonmsg["result"]~= nil and jsonmsg["result"] == "ok" then
    	--领取成功
    	self.btnAward:GetComponent("UIButton").isEnabled = false
    	self.award:SetActive(false)
    end
end
function WeekRacePanel.OnRuleCallBack(go)
	self.rule:SetActive(go.name == self.btnrule.name)
end
function WeekRacePanel.OnRankCallBack( go )
	self.rank:SetActive(go == self.btnrank)
end
function WeekRacePanel.OnCloseCallBack()
	if LRDDZ_Game.platform == PlatformType.PlatformMoble then
    	LRDDZ_Game:BackHall()
    else
    	--直接退出游戏
		Application.Quit()
	end
end
local cTime = 0  --距离开赛时间
function WeekRacePanel.OnApplyCallBack( go)
	if close==nil or close == false then
		if restseconds == -1 then
			self.ShowTipsMsg("比赛已经结束了\n(比赛时间："..range..")")
		else
			if cTime < 0 then
				LRDDZ_Game:UserReady()
			else
				self.ShowTipsMsg("还没到开赛时间,请稍候...\n(比赛时间："..range..")")
			end
		end
		--self.waitting:SetActive(true)
	else
		if restseconds == -1 then
			self.ShowTipsMsg("比赛已经结束了\n(比赛时间："..range..")")
		else
			self.ShowTipsMsg("还没到开赛时间,请稍候...\n(比赛时间："..range..")")
		end
		
	end
end
local waittime = 0
function WeekRacePanel.Waitting( isshow )
	if self.waittingtimer ~= nil then
			self.waittingtimer:Stop()
		end
	if isshow == true then
		waittime = 15
		self.CountWaittingTime()
		self.waittingtimer:Start()
	end
	self.waitting:SetActive(isshow)
end
function self.CountWaittingTime( )
	if waittime > 0 then
		self.lb_waitting.text = "正在匹配中...... 等待"..waittime.."秒"
		waittime = waittime - 1
	else
		self.lb_waitting.text = "正在匹配中..."
		self.waittingtimer:Stop()
	end
end
function self.OnAwardCallBack( )
	if EginUser.Instance.telephone ~= nil and EginUser.Instance.telephone ~= "" and string.len(EginUser.Instance.telephone) == 11 then

		if self.hasawardPanel.activeSelf then
			self.hasawardPanel:SetActive(false)
		end
		self.award:SetActive(true)

	else
		--请先绑定手机号
		self.ShowTipsMsg("您的账号暂未绑定手机号码，请绑定")
		--跳转到其他界面
		local function func()
			coroutine.wait(3)
			SocketConnectInfo.Instance.roomFixseat = true;  
	        SocketConnectInfo.Instance.roomHost = "";
	        SocketManager.Instance.socketListener = null;
	        SocketManager.Instance:Disconnect("Exit from the game.");
			Utils.LoadLevelGUI("Module_UpdateAvatar");
			if Module_UpdateAvatar.safetyTabToggle~= nil then
				coroutine.wait(2)
				Module_UpdateAvatar.safetyTabToggle.value = true
				Module_UpdateAvatar:OnShowSafetyTabToggleView()
			end
		end
		coroutine.start(func)
	end


	
end
function self.OnCloseAwardCallBack(  )
	self.award:SetActive(false)
end
function WeekRacePanel.OnDestroy()
	gameObject = nil
	transform = nil
	mono = nil
	self.min = nil
	self.sce1 = nil
	self.timer:Stop()
	self.timer = nil
	self.waitting = nil
	self.vertimer:Stop()
	self.waittingtimer:Stop()
	self.tipobj=nil
	self.hasawardPanel = nil
end



function WeekRacePanel.SetTime(time)
	cTime = time
	if self.timer~=nil then
		self.timer:Stop()	
	end
	self.timer:Start()
end
function WeekRacePanel.CountDown()
	if cTime > 0 then
		local h = math.floor(cTime/3600)
		local m = math.floor(math.mod(cTime,3600)/60)
		local s = math.mod(math.mod(cTime,3600),60)
		local str = "距离比赛开始："
		if h<10 then
			str = str.."0"..h..":"
		else
			str = str..h..":"
		end
		if m<10 then
			str = str.."0"..m..":"
		else
			str = str..m..":"
		end
		if s < 10 then
			str = str.."0"..s
		else
			str = str..s
		end
		self.sce1.text = str
		cTime = cTime - 1
		if self.eff.activeSelf == true then
			self.eff:SetActive(false)
		end
	else
		self.sce1.text = "比赛时间："..range
		cTime = -2
		if self.eff.activeSelf == false then
			self.eff:SetActive(true)
		end
		if restseconds > 0 then
			restseconds = -2
			close = false
		end
	end
end
function WeekRacePanel.GetAwards(_awards)
	if _awards ~= nil then
		awards = _awards
	else
		return awards
	end
end
function WeekRacePanel.SetPanel(messageObj)
	--{"body": {"last_rank50": [], "sum_score": 0, "ave_score": 0, "rank": 0, "restseconds": 641, 
	--"awards": [["第1名", "300元京东E卡"], ["第2名", "200元京东E卡"], ["第3名", "100元京东E卡"], 
	--["第4-10名", "50元京东E卡"], ["第11-20名", "30元京东E卡"], ["第21~30名", "100W金币"], 
	--["第31~50名", "50W金币"]], "close": true, "top50": [[215, 30, 299829, "srw3fUaiVhjBMLV", 23, 7, 0, 0]], 
	--"end": "22:00", "range": "10:00-22:00", "round": 0}, "tag": "apply", "type": "ddz7"}
	local body = messageObj["body"]
	last_rank50 = body["last_rank50"] --
	sum_score = body["sum_score"]--总积分
	ave_score = body["ave_score"] --场积分
	rank = body["rank"]--当前排名
	restseconds = body["restseconds"]--开赛倒计时
	awards = body["awards"]--奖励 
	top50 = body["top50"]--前50名
	gameend = body["end"]--开赛时间
	range = body["range"]--开赛时间段
	round = body["round"]--当前第几局
	close = body["close"]
	win_round = body["win_round"]
	fail_round = body["fail_round"]
	tag = messageObj["tag"]
end
function self.SetRank(ranks)
	local rankstr = ""
	if rank == 0 then
		rankstr = "[FFF21C]暂无[-]\n"
	else
		rankstr = "[FFF21C]"..rank.."[-]\n"
	end
	local namestr = "[FFF21C]"..EginUser.Instance.nickname.."[-]\n"
	local roundstr = "[FFF21C]"..round.."[-]\n"
	local winstr = "[FFF21C]"..win_round.."[-]\n"
	local losestr = "[FFF21C]"..fail_round.."[-]\n"
	local scorestr = "[FFF21C]"..ave_score.."[-]\n"

	
	for i=1,#ranks do
		if i>50 then 
			break
		end
		rankstr = rankstr..i
		namestr = namestr..ranks[i][4]
		roundstr = roundstr..ranks[i][2]
		winstr = winstr..ranks[i][5]
		losestr = losestr..ranks[i][6]
		scorestr = scorestr..ranks[i][1]
		--if i >= 10 then
			--break
		--end
		if i~=#ranks then
			rankstr = rankstr.."\n"
			namestr = namestr.."\n"
			roundstr = roundstr.."\n"
			winstr = winstr.."\n"
			losestr = losestr.."\n"
			scorestr = scorestr.."\n"
		end
	end
	self.lb_rank.text = rankstr
	self.lb_rank_name.text = namestr
	self.lb_rank_score.text = scorestr
	self.lb_rank_win.text = winstr
	self.lb_rank_lose.text = losestr
	self.lb_rank_round.text = roundstr

	self.rank.transform:FindChild("ScrollView/no1").gameObject:SetActive(#ranks>=1)
	self.rank.transform:FindChild("ScrollView/no2").gameObject:SetActive(#ranks>=2)
	self.rank.transform:FindChild("ScrollView/no3").gameObject:SetActive(#ranks>=3)
end



function WeekRacePanel.LoadInof()
	--登录
	--[[
	--if recSession == nil then
		if ProtocolHelper._LoginType == LoginType.Username then
			--帐号登录
			local form = UnityEngine.WWWForm.New();
			local Username = UnityEngine.PlayerPrefs.GetString("EginUsername")
			form:AddField("username",Username);
			form:AddField("password",UnityEngine.PlayerPrefs.GetString(Username));
			local www = HttpConnect.Instance:HttpRequest(self.LOGIN_URL, form);
		    coroutine.www(www);
		    error("帐号"..www.text)
		    self.ShowTipsMsg("帐号"..www.text)
		    recSession = www.responseHeaders['SET-COOKIE']
		elseif ProtocolHelper._LoginType == LoginType.WeChat  then
			--微信登录
			local form = UnityEngine.WWWForm.New();
			form:AddField("openid",EginUser.Instance.wxOpenId )
			form:AddField("nickname", EginUser.Instance.wxNickname)
			form:AddField("sex",EginUser.Instance.wxSex)
			form:AddField('is_unity',1)
			local tUrl = self.REGISTER_WEIXIN_URL..'?openid='..EginUser.Instance.wxOpenId..'&nickname='.. UnityEngine.WWW.EscapeURL(EginUser.Instance.wxNickname).."&sex=" ..EginUser.Instance.wxSex.. "&is_unity=1"
			local www = HttpConnect.Instance:HttpRequest(tUrl, nil);
			coroutine.www(www);
			error("微信"..www.text)
			self.ShowTipsMsg("微信"..www.text)
			recSession = www.responseHeaders['SET-COOKIE']
			local result = HttpConnect.Instance:GuestLoginResult(www);
		elseif ProtocolHelper._LoginType == LoginType.Guest then
			--游客登录
			local www = HttpConnect.Instance:HttpRequest(self.GUEST_LOGIN_URL, nil);
			coroutine.www(www);
			error("游客"..www.text)
			self.ShowTipsMsg("游客"..www.text)
			recSession = www.responseHeaders['SET-COOKIE']
		elseif ProtocolHelper._LoginType == LoginType.Phone then
			--手机登录
			local form = UnityEngine.WWWForm.New();
			form:AddField("phone", this.kPhoneNumber.value);
			form:AddField("nickname", this.kPhoneNickname.value);
			local www = HttpConnect.Instance:HttpRequest(self.REGISTER_MOBILE_PHONE_URL, form);
			coroutine.www(www);
			error("手机"..www.text)
			self.ShowTipsMsg("手机"..www.text)
			recSession = www.responseHeaders['SET-COOKIE']
		end
	--end
	]]
    --加载排名信息
    local rform = UnityEngine.WWWForm.New();
    rform:AddField("roomid",2095);
    rform:AddField("userid",EginUser.Instance.uid)
    local infowww = HttpConnect.Instance:HttpRequest(self.CJF_MATCH_INFO, rform)
    error("获取排名")
    coroutine.www(infowww)
   	local info = cjson.decode(infowww.text)
   	error(infowww.text)
   	--测试消息
   	--local text = "{\"result\": \"ok\",\"body\": {\"rank\": 1, \"uid\": 1, \"name\": \"test\", \"ave_score\": 8000,\"update_time\": \"2016-12-13 14:10:00\", \"round\": 25,\"win_round\": 25, \"fail_round\": 0, \"add_coin\": 0, \"item_id\": 121, \"is_reward\": 0}}"
   	--local info = cjson.decode(text)
   	if info["result"] ~= nil and info["result"] == "ok" then
   		local body = info["body"]
   		lastMatchRank = body["rank"]
   		if body["add_coin"] ~= nil and body["add_coin"] > 0 then
   			self.lb_desc.text = "恭喜您在斗地主比赛中获得第"..lastMatchRank.."名\n并获得"..body["add_coin"].."金币已存入背包"
   			--self.setPopAward()
		end
		if body["item_id"]~= nil and body["item_id"] > 0 then
			local itemid = body["item_id"]
			local str = ""
			if itemid == 121 then
				str = "300元京东E卡"
			elseif itemid == 122 then
				str = "200元京东E卡"
			elseif itemid == 123 then
				str = "100元京东E卡"
			elseif itemid == 124 then
				str = "50元京东E卡"
			elseif itemid == 125 then
				str = "30元京东E卡"
			end
			self.lb_desc.text = "恭喜您在斗地主比赛中获得第"..lastMatchRank.."名\n并获得"..str
			--self.setPopAward()
		end
		if body["item_id"]~= nil and body["item_id"] > 0 then
			if body["is_reward"] == 1 then
				--显示已领取
				self.btnAward:GetComponent("UIButton").isEnabled = false
			else
				--弹出领取
				self.hasawardPanel:SetActive(true)
				self.btnAward:GetComponent("UIButton").isEnabled = true
			end
		end
   	else
   		if info["body"]~= nil then
   			error(info["body"])
   		end
   		self.btnAward:GetComponent("UIButton").isEnabled = false
   	end
end
function WeekRacePanel:HttpRequestWithSession(pUrl,pForm,session)
	local tCookie =nil 
	if session ~= nil then
		tCookie = session
	else
		tCookie = ''
	end

	local tRequestHeaders = {}
	tRequestHeaders['Cookie'] = tCookie

	local tHeaders = {}
	tHeaders['Cookie'] = tCookie

	if pForm ==nil then
		pForm = UnityEngine.WWWForm.New()
		pForm:AddField('Cookie',tCookie)
	end
	if pForm ~= nil then
		local tMs = EginTools.nowMinis()
		local tMms = tMs + EginTools.localBeiJingTime
		local tCcode = EginTools.encrypTime(tostring(tMms))
		pForm:AddField('client_code',tCcode)
	end
	local www = Util.GetWWW(pUrl,pForm,tHeaders)   --UnityEngine.WWW.New(pUrl,pForm.data,tHeaders)
	return www
end