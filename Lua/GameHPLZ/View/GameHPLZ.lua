require "GameHPLZ/HPLZPlayerCtrl"

local cjson = require "cjson"

local this = LuaObject:New()
GameHPLZ = this

--/ 游戏玩家的控制脚本
local userPlayerCtrl = {};
local _userAvatar = nil;
local _userNickname = nil;
local _userBagmoney = nil;
local _userLevel = nil;
local otherUid="0";
--/ 动态生成的玩家实例名字的前缀
local _nnPlayerName = "NNPlayer_";
local _bankerPlayer = nil;
local _isPlaying = false;
local _late = false;
local _reEnter = false;
local _colorBtns = {};
--/ 游戏开始时正在游戏的玩家
local _playingPlayerList = {};


function this:clearLuaValue()
	userPlayerCtrl = {};
	_userAvatar = nil;
	_userNickname = nil;
	_userBagmoney = nil;
	_userLevel = nil;
	otherUid="0";
	_nnPlayerName = "NNPlayer_";
	_bankerPlayer = nil;
	_isPlaying = false;
	_late = false;
	_reEnter = false;
	_colorBtns = {};
	_playingPlayerList = {};



	this.mono = nil
	this.gameObject = nil
	this.transform = nil

	
	--/ 同桌其他玩家的预设
	this.hplzPlayerPrefab = nil;
	this.userPlayerObj = nil;
	this.btnBegin = nil;
	this.btnCallBankers = nil;
	this.btnShow = nil;
	this.msgWaitNext = nil;
	this.msgWaitBet = nil;
	--/ 供选择的筹码
	this.chooseChipObj = nil;
	this.msgQuit = nil;
	this.msgAccountFailed = nil;
	this.msgNotContinue = nil;
	this.soundStart = nil;
	this.soundWanbi = nil;
	this.soundXiazhu = nil;
	this.soundTanover = nil;
	this.soundWin = nil;
	this.soundFail = nil;
	this.soundEnd = nil;
	this.soundNiuniu = nil;
	
	this:RemoveAllPlayerCtrl();
	LuaGC();
end
function this:Init()
	--初始化变量
	userPlayerCtrl = {};
	_userAvatar = nil;
	_userNickname = nil;
	_userBagmoney = nil;
	_userLevel = nil;
	otherUid="0";
	_nnPlayerName = "NNPlayer_";
	_bankerPlayer = nil;
	_isPlaying = false;
	_late = false;
	_reEnter = false;
	_colorBtns = {};
	_playingPlayerList = {};
	
	
	--/ 同桌其他玩家的预设
	this.hplzPlayerPrefab = ResManager:LoadAsset("gamehplz/hplzplayer","hplzplayer");
	this.userPlayerObj = this.transform:FindChild("Content/User").gameObject			--GameObject

	--/ 供选择的筹码
	this.chooseChipObj = this.transform:FindChild("Content/User/ChooseChips").gameObject;
	this.btnCallBankers = this.transform:FindChild("Content/User/BtnCallBanker").gameObject	;
	this.btnBegin = this.transform:FindChild("Content/User/Button_begin").gameObject				--GameObject
	this.btnShow = this.transform:FindChild("Content/User/Button_show").gameObject				--GameObject
	
	this.msgWaitBet = this.transform:FindChild("Content/MsgContainer/MsgWaitNext").gameObject;
	this.msgWaitNext =	this.transform:FindChild("Content/MsgContainer/MsgWaitNext").gameObject;	--GameObject
	this.msgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit").gameObject				--GameObject
	this.msgAccountFailed = this.transform:FindChild("Content/MsgContainer/MsgAccountFailed").gameObject		--GameObject
	this.msgNotContinue = this.transform:FindChild("Content/MsgContainer/MsgNotContinue").gameObject			--GameObject
	 
	 
	--音效
	this.soundStart = ResManager:LoadAsset("gamenn/Sound","GAME_START") --AudioClip
	this.soundWanbi = ResManager:LoadAsset("gamenn/Sound","wanbi") --AudioClip
	this.soundXiazhu = ResManager:LoadAsset("gamenn/Sound","xiazhu") 	--AudioClip
	this.soundTanover = ResManager:LoadAsset("gamenn/Sound","tanover") --AudioClip
	this.soundWin = ResManager:LoadAsset("gamenn/Sound","win") 		--AudioClip
	this.soundFail = ResManager:LoadAsset("gamenn/Sound","fail") 		--AudioClip	
	this.soundEnd = ResManager:LoadAsset("gamenn/Sound","GAME_END") 		--AudioClip
	this.soundNiuniu = ResManager:LoadAsset("gamenn/Sound","niuniu") 	--AudioClip
end
function this:Awake()
	log("------------------awake of Game-------------")
	this:Init();
	
	----------绑定按钮事件--------
	
	--退出按钮
	local btn_back = this.transform:FindChild("Button_back").gameObject
	this.mono:AddClick(btn_back, this.OnClickBack);
	--开始按钮
	this.mono:AddClick(this.btnBegin, this.UserReady);
	--摊牌按钮
	this.mono:AddClick(this.btnShow, this.UserShow);
	--确认退出按钮
	local btn_MsgQuit = this.transform:FindChild("Content/MsgContainer/MsgQuit/Button_yes").gameObject
	this.mono:AddClick(btn_MsgQuit, this.UserQuit);
	--叫庄
	local btn_zhuang = this.btnCallBankers.transform:FindChild("Button0").gameObject
	this.mono:AddClick(btn_zhuang, this.UserCallBanker,this);
	local btn_buzhuang = this.btnCallBankers.transform:FindChild("Button1").gameObject
	this.mono:AddClick(btn_buzhuang, this.UserCallBanker,this);
	--下注数按钮
	for i=0,this.chooseChipObj.transform.childCount-1  do
		local tempbutton = this.chooseChipObj.transform:GetChild(i).gameObject;
		this.mono:AddClick(tempbutton, this.UserChip,this);
	end
	
	
	
	------------逻辑代码------------
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
	if sceneRoot then 
		sceneRoot.manualHeight = 800;
		sceneRoot.manualWidth = 1422;
	end
	
	local footInfoPrb = ResManager:LoadAsset("gamenn/FootInfo2Prb","FootInfo2Prb")
	local settingPrb = ResManager:LoadAsset("gamenn/settingprb","SettingPrb")
	GameObject.Instantiate(footInfoPrb)
	GameObject.Instantiate(settingPrb)
end

function this:Start()
	if SettingInfo.Instance.autoNext == true then
		this.btnBegin:SetActive (false);  
	end
	this.mono:StartGameSocket();
	
	coroutine.start(this.Update);
end

function this:OnDisable()
	this:clearLuaValue()
	
end



----解析JSON
function this:SocketReceiveMessage(Message)
	local Message = self;
	
	if  Message then
		
		--解析json字符串
		local messageObj = cjson.decode(Message);
		local typeC = messageObj["type"];
		local tag = messageObj["tag"];
		if typeC=="game" then
			if tag=="enter" then
				this:ProcessEnter(messageObj);		
			elseif tag=="ready" then
				this:ProcessReady(messageObj);		
			elseif tag=="come" then
				this:ProcessCome(messageObj);		
			elseif tag=="leave" then
				this:ProcessLeave(messageObj);	
			elseif tag=="deskover" then
				--this:ProcessDeskOver(messageObj);
			elseif tag=="notcontinue" then
				coroutine.start(this.ProcessNotcontinue,this);
			end
		elseif typeC=="lz2p" then
			if tag=="time" then
				local t = messageObj["body"]
				Count.Instance:UpdateHUD(t);
			elseif tag=="re_enter" then
				this:ProcessLate(messageObj);
			elseif tag=="deal" then
				this:ProcessDeal(messageObj);
			elseif tag=="commit" then
				this:ProcessOk(messageObj);
			elseif tag=="ask_banker" then
				this:ProcessAskbanker(messageObj);
			elseif tag=="start_chip" then
				this:ProcessStartchip(messageObj);
			elseif tag=="game_over" then
				coroutine.start(this.ProcessEnd,this,messageObj);
			end
		elseif typeC=="seatmatch" then
			if tag=="on_update" then
				this:ProcessUpdateAllIntomoney(messageObj);
			end
		end
	else
		log("---------------Message=nil")
	end
end

----JSON解析后分发函数----


function this:ProcessLate( messageObj)
	if not _reEnter then
		_late = true
		this.msgWaitNext:SetActive(true)
	end
	--（late进入时不显示开始按钮，显示等待）
	this.btnBegin:SetActive (false);
	
	local body = messageObj["body"];
	local t =  tonumber(body["timeout"]);
	local step =  tonumber(body["step"]);
	local nnBid =  tonumber(body["bid"]);
	local chip = body["chips"];
	local gid =  tostring(body ["bid"]);
	
	NNCount.Instance:UpdateHUD(t);
	
	--庄家
	if nnBid ~= 0 then
		this:GetPlayerCtrl(_nnPlayerName..nnBid):SetBanker(true);
	end
	
	local infos = body["infos"];
	for key,info in pairs(infos) do
		-- [玩家id, 是否等待, 是否摊牌, cards, 牌型, 自己的下注额],#后3项非自己的不出现 
		--uid:100000 , card s:[前三张 牛 后二张 几]  ,type:版型数值0-10 , final:结算-100,is _ commit:0/1 }
		local uid =  tostring(info["uid"]);
		local showNum =  tonumber(info["is_commit"]);
		local cards = info["cards"];
		local cardType = info["type"];
		local jk =  tonumber(cardType[1]);
	
		if jk==19 then
			jk = 19+tonumber(cardType[2]);
		end

		local perChip =  tonumber(info["final"]);

		local player = GameObject.Find(_nnPlayerName..uid);
		if not IsNil(player) then
			local ctrl = this:GetPlayerCtrl(player.name);

			if player ~= this.userPlayerObj then
				if perChip ~= 0 then ctrl:SetBet(perChip); end
				if step == 3 then
					ctrl:SetLate(nil);
					if showNum ==1 then ctrl:SetShow(true); end
				end
			else 
				if step == 1 then
					if gid==EginUser.Instance.uid then
						this.btnCallBankers:SetActive (true);
					end
				elseif step == 2 then
					if perChip ~= 0 then
						ctrl:SetBet(perChip);
					elseif perChip == 0 then
						this.chooseChipObj:SetActive (true);

						local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true))
						
						for i=0,#(chip)-1 do
							local btn = btns[i].gameObject;
							btn.transform.localPosition = Vector3.New(-360 + 240*i, 0, 0);
							userPlayerCtrl:SetStartChip(btn,  tonumber((chip[i+1])));
							btn.name =  tostring(chip[i+1]);
						end
					end
				elseif step == 3 then
					ctrl:SetLate(cards);
					if showNum ==1 then
						ctrl:SetCardTypeUser(cards, jk);
					else 
						ctrl:SetShow(true);
						this.btnShow:SetActive (true);
					end
				end
			end
		end
	end
end

function this:ProcessEnter( messageObj)
	local body = messageObj["body"];
	local memberinfos = body["memberinfos"];
	userPlayerCtrl = this:GetPlayerCtrl(this.userPlayerObj.name,this.userPlayerObj);
	for key,memberinfo in ipairs(memberinfos) do
		if memberinfo then
			if tostring(memberinfo["uid"])  == EginUser.Instance.uid then
				table.insert(_playingPlayerList,this.userPlayerObj)
				_reEnter = true;
				
				this:ReplaceNamePlayerCtrl(this.userPlayerObj.name,_nnPlayerName..EginUser.Instance.uid);	
				this.userPlayerObj.name = _nnPlayerName..EginUser.Instance.uid;
				if SettingInfo.Instance.autoNext == true then
					this:UserReady();
				end
				break;
			end	
		end
	end
	
	for key,memberinfo in ipairs(memberinfos) do
		if memberinfo then
			if tostring(memberinfo["uid"]) ~= EginUser.Instance.uid then
				this:AddPlayer(memberinfo,_userIndex);
			end
		end
	end

	local deskinfo = body["deskinfo"];
	local t =  tonumber(deskinfo ["continue_timeout"]);
	NNCount.Instance:UpdateHUD(t);
end


function this:AddPlayer( memberinfo)
	local player1 = GameObject.Find (_nnPlayerName..otherUid);
	if player1 ~= nil then
		player1:SetActive(false);
		this:RemovePlayerCtrl(player1.name);
		if tableContains(_playingPlayerList,player1) then
			tableRemove(_playingPlayerList,player1);
		end
		destroy(player1);
	end
	otherUid =  tostring(memberinfo["uid"]);
	
	local uid =  tostring(memberinfo["uid"]);
	local bag_money =  tostring(memberinfo["bag_money"]);
	local nickname = tostring(memberinfo["nickname"]);
	local avatar_no =  tonumber((memberinfo["avatar_no"]));
	local level = memberinfo ["level"];

	local content = this.transform:FindChild("Content").gameObject
	local player = NGUITools.AddChild(content, this.hplzPlayerPrefab);
	player.name = _nnPlayerName..uid;
	local anchor = player:GetComponent("UIAnchor");
	anchor.side = UIAnchor.Side.Top;
	anchor.relativeOffset=Vector2.New(-0.06,-0.11); 

	local ctrl = this:GetPlayerCtrl(player.name,player);
	ctrl:SetPlayerInfo (avatar_no, nickname, bag_money, level);

	table.insert(_playingPlayerList,player);

	return player;
end
 

function this:ProcessReady( messageObj)
	local uid =  tostring(messageObj["body"]);
	local ctrl =this:GetPlayerCtrl(_nnPlayerName..uid);
	
	--去掉牌型显示
	coroutine.start(ctrl.SetDeal,ctrl,false,nil);
	if uid == EginUser.Instance.uid then
		ctrl:SetCardTypeUser(nil,0);
	else
		ctrl:SetCardTypeOther(nil,0);
	end
	ctrl:SetScore(-1);
	--显示准备
	ctrl:SetReady(true);
end
	


function this:ProcessAskbanker( messageObj)
	--游戏开始，将_readyPlayerList中的玩家放入_playingPlayerList
	_isPlaying = true;
	--清除未被清除的牌,清楚叫庄中提示
	for key,player in ipairs(_playingPlayerList) do
		if player ~= this.userPlayerObj then
			local ctrl = this:GetPlayerCtrl(player.name);
			coroutine.start(ctrl.SetDeal,ctrl,false,nil);
			ctrl:SetCardTypeOther(nil, 0);
			ctrl:SetScore(-1);
			ctrl:SetCallBanker(false);
		end
	end

	--去掉“准备”
	for key,player in ipairs(_playingPlayerList) do
		this:GetPlayerCtrl(player.name):SetReady(false);
	end
	
	local body = messageObj["body"];
	local uid =  tostring(body["uid"]);
	
	--显示叫庄提示信息
	if uid==EginUser.Instance.uid then
		this.btnCallBankers:SetActive (true);
	elseif not uid==EginUser.Instance.uid  and not _late then
		if this.btnCallBankers.activeSelf then this.btnCallBankers:SetActive (false); end
		this:GetPlayerCtrl(_nnPlayerName..uid):SetCallBanker(true);
	end
	
	local t =  tonumber(body["timeout"]);
	NNCount.Instance:UpdateHUD(t);
end



function this:ProcessStartchip( messageObj)

	for key,player in ipairs(_playingPlayerList) do
		if player ~= this.userPlayerObj then
			local ctrl1 =  this:GetPlayerCtrl(player.name);
			ctrl1:SetCallBanker(false);
		end
	end


	if this.btnCallBankers.activeSelf then this.btnCallBankers:SetActive (false); end

	local body = messageObj["body"];
	local bid =  tostring(body["bid"]);

	_bankerPlayer = GameObject.Find(_nnPlayerName..bid);
	local ctrl = this:GetPlayerCtrl(_bankerPlayer.name);
	ctrl:SetCallBanker(false);
	--庄家
	ctrl:SetBanker(true);
	
	if not _late and _bankerPlayer ~= this.userPlayerObj then
		--可选的筹码
		local chip = body["chip"];
		this.chooseChipObj:SetActive (true);

		local btns = this.chooseChipObj:GetComponentsInChildren(Type.GetType("UIButton",true))
		for  i=0,#(chip)-1 do
			local btn = btns[i].gameObject;
			btn.transform.localPosition = Vector3.New(-360 + 240*i, 0, 0);
			userPlayerCtrl:SetStartChip(btn,  tonumber((chip[i+1])));
			btn.name =  tostring(chip[i+1]);
		end
	end
	--倒计时
	local t =  tonumber(body["timeout"]);
	NNCount.Instance:UpdateHUD(t);
end

function this:ProcessChip( messageObj)
	local infos = messageObj["body"];
	local uid =  tostring(infos[1]);
	local chip =  tonumber(infos[2]);

	local player = GameObject.Find (_nnPlayerName..uid);
	 this:GetPlayerCtrl(player.name):SetBet(chip);

	--如果收到主玩家的下注消息则隐藏可选筹码
	if player == this.userPlayerObj then
		this.chooseChipObj:SetActive (false);
	end
	EginTools.PlayEffect (this.soundXiazhu);
end


function this:ProcessDeal( messageObj)
	--去掉“等待闲家下注”
	if this.msgWaitBet.activeSelf then this.msgWaitBet:SetActive (false) end

	local body = messageObj["body"];
	local cards = body ["cards"];
	local chip =  tonumber(body ["chipnum"]);

	if _bankerPlayer ~= this.userPlayerObj then
		this:GetPlayerCtrl(_nnPlayerName..EginUser.Instance.uid):SetBet(chip);
		--如果收到主玩家的下注消息则隐藏可选筹码
		this.chooseChipObj:SetActive (false);
	else 
		this:GetPlayerCtrl(_nnPlayerName..otherUid):SetBet(chip);
	end
	EginTools.PlayEffect (this.soundXiazhu);

	--发牌
	for key,player in ipairs(_playingPlayerList) do
		if player == this.userPlayerObj then
			coroutine.start(userPlayerCtrl.SetDeal,userPlayerCtrl,true,cards);
		else 
			local ctrl = this:GetPlayerCtrl(player.name)
			coroutine.start(ctrl.SetDeal,ctrl,true,nil);
		end
	end

	
	--非late进入时才显示摊牌按钮
	if not _late then this.btnShow:SetActive (true); end
	
	local t =  tonumber(body ["timeout"]);
	NNCount.Instance:UpdateHUD(t);
end

function this:ProcessOk( messageObj)

	local body = messageObj ["body"]; 
	
	if body==nil or body["cards"]==nil then
		local player = GameObject.Find(_nnPlayerName..otherUid);
		if player ~= nil then
			this:GetPlayerCtrl(player.name):SetShow(true);
		end
	else 
		local cards = body["cards"];
		local cardType = body["type"];
		local jk =  tonumber(cardType[1]);
		if jk==19 then
			jk = 19+ tonumber(cardType[2]);
		end
		userPlayerCtrl:SetCardTypeUser(cards, jk);
	end
	
	EginTools.PlayEffect (this.soundTanover);
end



function this:ProcessEnd( messageObj)
	--去掉筹码显示
	for key,player in ipairs(_playingPlayerList) do
		 this:GetPlayerCtrl(player.name):SetBet(0);
	end

	--去掉“摊牌”字样和下注额
	for key,player in ipairs(_playingPlayerList) do
		if player ~= this.userPlayerObj then
			this:GetPlayerCtrl(player.name):SetShow(false);
		end
	end

	if this.msgWaitNext.activeSelf then this.msgWaitNext:SetActive (false); end

	local body = messageObj["body"];
	--[玩家id, cards, 牌型, 输赢钱数]
	--uid:100000 , cards:[前三张 牛 后二张 几]  ,type:版型数值0-10 , final:结算-100} 
	local infos = body["infos"];
	
	--玩家扑克牌信息
	for key,info in ipairs(infos) do
		local jos = info;
		local uid =  tostring(jos["uid"]);
		local player = GameObject.Find(_nnPlayerName..uid);
		if player ~= nil then
			local ctrl = this:GetPlayerCtrl( player.name);
			local cards = jos["cards"];
			local cardType = jos["type"];
			local jk =  tonumber(cardType[1]);
			
			if jk==19 then
				jk = 19+ tonumber(cardType[2]);
			end
			--得分
			local score =  tonumber(jos["final"]);
			--明牌
			if uid ~= EginUser.Instance.uid then
				ctrl:SetCardTypeOther(cards, jk);
			else 
				if this.btnShow.activeSelf then
					this.btnShow:SetActive (false);
					ctrl:SetCardTypeUser(cards,jk);
				end
				
				if score>0 then
					EginTools.PlayEffect(this.soundWin);
				else 
					EginTools.PlayEffect(this.soundFail);
				end
			end
			ctrl:SetScore(score);
		end
	end


	if _late then
		EginTools.PlayEffect(this.soundEnd);
		_late = false;
	else 
		this.btnBegin.transform.localPosition =  Vector3.New(300, 0, 0);
	end

	if SettingInfo.Instance.autoNext then
		coroutine.wait(2)
		this:UserReady();
	else 
		this.btnBegin:SetActive (true);
	end

	local t =  tonumber(body ["timeout"]);
	NNCount.Instance:UpdateHUD(t);

	_isPlaying = false;
end

function this:ProcessUpdateAllIntomoney( messageObj)
	local jsonStr = cjson.encode(messageObj);
	local a11=string.find(jsonStr,EginUser.Instance.uid);
	if not a11 then return nil; end 
	
	local infos = messageObj ["body"];
	for key,info in ipairs(infos) do
		local uid =  tostring(info[1]);
		local intoMoney =  tostring(info[2]);
		local player = GameObject.Find(_nnPlayerName..uid);
		if not IsNil(player) then
			this:GetPlayerCtrl(player.name):UpdateIntoMoney(intoMoney);
		end
	end
end

function this.ProcessUpdateIntomoney( messageStr)
	local messageObj = cjson.decode(messageStr);
	local intoMoney =  tostring(messageObj["body"]);
	local info = GameObject.Find ("Panel_info");
	if not IsNil(info) then
		FootInfo:UpdateIntomoney(intoMoney);
	end
end

function this:ProcessCome( messageObj)
	local body = messageObj["body"];
	local memberinfo = body["memberinfo"];
	this:AddPlayer(memberinfo);
end

function this:ProcessLeave( messageObj)
	local uid =  tostring(messageObj["body"]);
	if tostring(uid)~=EginUser.Instance.uid then
		local player = GameObject.Find (_nnPlayerName..uid);
		this:RemovePlayerCtrl(player.name);
		if tableContains(_playingPlayerList,player) then
			tableRemove(_playingPlayerList,player);
		end
		
		destroy(player);
	end
end
---------end---------

-------向服务器发送消息---------
--将用户下注的筹码发送给服务器
function this:UserChip( go)
	local chip = tonumber(go.name);
	local startJson = {type="lz2p",tag="chip_in",body=chip}; 
	local chip_in = cjson.encode(startJson);
	
	this.mono:SendPackage(chip_in);
end
function this:UserShow()

	local startJson = {type="lz2p",tag="commit"}; 
	local ok = cjson.encode(startJson);
	this.mono:SendPackage(ok);

	this.btnShow:SetActive (false);
end
function this:UserCallBanker( btn)
	local startJson = nil;
	if btn.name=="Button1" then
		startJson = {type="lz2p",tag="re_banker",body=1}; 
		this.msgWaitBet:SetActive (true);
	elseif btn.name=="Button0" then
		startJson = {type="lz2p",tag="re_banker",body=0}; 
	end
	local re_banker = cjson.encode(startJson);
	this.mono:SendPackage(re_banker);

	this.btnCallBankers:SetActive (false);
end
function this:UserLeave()
	local startJson = {type="game",tag="leave",body=EginUser.Instance.uid}; 
	local userLeave = cjson.encode(startJson);
	this.mono:SendPackage(userLeave);
end

function this:UserReady()
	--避免了已经点击过开始按钮但是还是有倒计时声音
	NNCount.Instance:DestroyHUD ();
	--新的一句开始时去掉庄家标志
	if _bankerPlayer ~= nil then
		this:GetPlayerCtrl(_bankerPlayer.name):SetBanker(false);
	end

	--向服务器发送消息（开始游戏）
	
	local startJson = {type="lz2p",tag="start"}; 
	local ok = cjson.encode(startJson);
	this.mono:SendPackage(ok);

	EginTools.PlayEffect (this.soundStart);
	this.btnBegin:SetActive (false);
end
	
function this:UserQuit()

	SocketConnectInfo.Instance.roomFixseat = true;

	local userQuit = {type="game",tag="quit"};    --最终产生json的表
	--将表数据编码成json字符串
	local jsonStr = cjson.encode(userQuit);
	this.mono:SendPackage(jsonStr);
	this.mono:OnClickBack();

end
----------end-------------

function this:OnClickBack ()
	
	if not _isPlaying then
		this:UserQuit();
	else
		this.msgQuit:SetActive(true);
	end
end

function this:ProcessNotcontinue()
	this.msgNotContinue:SetActive(true);
	--等待3秒
	coroutine.wait(3);	
	if this.mono==nil then
		return;
	end
	this:UserQuit()
end
function this:AfterDoing(offset,run)
	coroutine.wait(offset);	
	if this.mono then
		run();
	end
end
function this.ShowPromptHUD(errorInfo)

	this.btnBegin:SetActive(false);
	this.msgAccountFailed:SetActive(true)
	this.msgAccountFailed:GetComponentInChildren(Type.GetType("UILabel",true)).text = errorInfo;
end
-------end---------




-----_PlayerCtrl对象的操作-----
function this:GetPlayerCtrl(tbName,tbObj)

	if this._PlayerCtrl == nil then
		this._PlayerCtrl = {};
	end
	
	local temp = this._PlayerCtrl[tbName]
	if temp == nil then
		
		if not IsNil(tbObj) then
			this._PlayerCtrl[tbName] = HPLZPlayerCtrl:New(tbObj);
			temp = this._PlayerCtrl[tbName]
		end
		
	end
	return temp
end
function this:ReplaceNamePlayerCtrl(oldName,newName)
	
	if oldName ~= newName then
		local temp = this._PlayerCtrl[oldName]
		if temp ~= nil then
			this._PlayerCtrl[newName] = temp
			this._PlayerCtrl[oldName] = nil
		end
	end
end
--删除_PlayerCtrl对象
function this:RemovePlayerCtrl(tbName)
	
	local temp = this._PlayerCtrl[tbName];
	if temp then
		temp._alive = false;
		temp:clearLuaValue();
		this._PlayerCtrl[tbName] = nil;
		temp = nil;
	end
end
function this:RemoveAllPlayerCtrl()
	if this._PlayerCtrl then
		for key,v in pairs(this._PlayerCtrl) do
			v._alive = false;
			v:clearLuaValue();
		end
		this._PlayerCtrl = nil;
	end
end
----------end-------------

function this:Update()
    while this._PlayerCtrl do
		for key,v in pairs(this._PlayerCtrl) do
			if v._alive then
				v:Update();
			end
		end
		coroutine.wait(Time.deltaTime);
	end
end