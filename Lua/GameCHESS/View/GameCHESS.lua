
local cjson = require "cjson"
require "GameNN/UISoundManager"
local this = LuaObject:New()
GameCHESS = this

function this:Awake()
	
	
	this:Init();
	this:HandleBtnsFunc()
	local sceneRoot = find('GUI'):GetComponent("UIRoot")
    if sceneRoot then 
        sceneRoot.fitWidth = true 
        sceneRoot.fitHeight = false 
        sceneRoot.manualHeight = 1080;
		sceneRoot.manualWidth = 1920;
    end


	if  SettingInfo.Instance.bgVolume > 0 then
		SettingInfo.Instance.bgVolume = 0.15
		this.musicOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName = "On";
		this.musicOn.transform:FindChild("Thumb").localPosition = Vector3.New(90,0,0)
		this.mxSettBGBar = 1
	else
		this.musicOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName = "Off";
		this.musicOn.transform:FindChild("Thumb").localPosition = Vector3.New(-90,0,0)
		this.mxSettBGBar = 0
	end 
	
	if  SettingInfo.Instance.effectVolume > 0 then
		this.mxSettEFBar = 1
		this.yinxiaoOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName = "On";
		this.yinxiaoOn.transform:FindChild("Thumb").localPosition = Vector3.New(90,0,0)
	else
		this.yinxiaoOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName = "Off";
		this.yinxiaoOn.transform:FindChild("Thumb").localPosition = Vector3.New(-90,0,0)
		this.mxSettEFBar = 0
	end 
	UISoundManager.Instance.BGVolumeSet(this.mxSettBGBar);
	UISoundManager.Instance._EFVolume = this.mxSettEFBar;

end


function this:clearLuaValue( )
	this.mBtnBack=nil
	this.mBtnSetting=nil
	this.mBtnDraw=nil
	this.mBtnGiveUp=nil
	this.mBtnRegret=nil
	-- this.mBtnBet=nil
	this.mBtnStart=nil
	this.mMyName=nil
	this.mMyMoney=nil
	this.mStepTime=nil
	this.mRoundTime=nil
	this.mMyHeadImage=nil
	this.mOtherHeadImage=nil
	this.mOtherName=nil
	this.mMyPos=nil
	this.mMyUid=nil
	this.mOtherId=nil
	this.mOtherPos=nil
	this.mBetId=nil
	this.mxSettBGBar=nil
	this.mxSettEFBar=nil
	this.mMyReady=nil
	this.mOtherReady=nil
	this.mStartAni=nil
	this.mBtnKickOut=nil
	this.mMessageBG=nil
	this.mMsgBtnSure=nil
	this.mMsgBtnCancel=nil
	this.mAgreePart=nil
	this.mGarbageTran=nil
	this.mResultObj=nil
	this.mResultTitleSp=nil
	this.mResultObj=nil
	this.mLab_Name1=nil
	this.mResultObj=nil
	this.mLab_Name2=nil
	this.BetMoney=nil 
	this.ChessPointGroup=nil
	this.ChessGroup=nil
	this.CurrentChessMatrix = {}
	this.mStartClock = false 
	this.mClockReset = false
	this.mCurrentSelect = nil 
	this.mCurSelectPos = {-1,-1}
	this.mCount = -1
	this.MyRound = false   -- true 我回合  --false 对手
	this.ChessItemSet = {}
	this.mLastMove = nil 
	this.mScaleArray = {}
	this.mState1 = nil
	this.mState2  =nil 
	this.mLabScore1 =nil
	this.mLabScore2 = nil
	-- this.mPoint1 = nil
	-- this.mPoint2 = nil

	this.mMsgAsk = nil
	this.mSettingPanel =nil
	this.musicOn = nil 
	this.yinxiaoOn = nil

	this.RedInitPos = {}
	this.BlackInitPos = {}
	coroutine.Stop()
	UISoundManager.finish()
	LuaGC();
end
function this:Init()
	this.mBtnBack = this.transform:FindChild('Btn_Back').gameObject
	this.mBtnSetting = this.transform:FindChild('Btn_Setting').gameObject
	this.mBtnDraw = this.transform:FindChild('Btn_Draw').gameObject
	this.mBtnGiveUp = this.transform:FindChild('Btn_GiveUp').gameObject
	this.mBtnRegret = this.transform:FindChild('Btn_Regret').gameObject
	-- this.mBtnBet = this.transform:FindChild('BetArea/Btn_Bet').gameObject
	this.mBtnStart = this.transform:FindChild('Btn_Start').gameObject
	this.mMyName = this.transform:FindChild('UserInfo/UserHead/Lab_Name').gameObject:GetComponent('UILabel')
	this.mMyMoney = this.transform:FindChild('UserInfo/BG_Info/Lab_Money').gameObject:GetComponent('UILabel')
	this.mStepTime = this.transform:FindChild('UserInfo/BG_Info/Lab_StepTime').gameObject:GetComponent('UILabel')
	this.mRoundTime = this.transform:FindChild('UserInfo/BG_Info/Lab_LabRoundTime').gameObject:GetComponent('UILabel')
	this.mHeadLight = this.transform:FindChild('UserInfo/UserHead/BGLigtht').gameObject
	this.mMyHeadImage = this.transform:FindChild('UserInfo/UserHead/Panel/HeadImage').gameObject:GetComponent('UISprite')
	this.mOtherHeadImage = this.transform:FindChild('OtherInfo/Panel/HeadImage').gameObject:GetComponent('UISprite')
	this.mOtherName = this.transform:FindChild('OtherInfo/Lab_Name').gameObject:GetComponent('UILabel')
	this.mOtherHeadLight = this.transform:FindChild('OtherInfo/BGLigtht').gameObject
	this.mMyPos = -1
	this.mMyUid = -1
	this.mOtherId = -1 
	this.mOtherPos = -1 
	this.mBetId = -1
	this.mxSettBGBar = -1;
	this.mxSettEFBar = -1; 
	this.BetMoneyInput = this.transform:FindChild('BetArea/Sp_Num').gameObject:GetComponent('UIInput')
	this.BetMoney = this.transform:FindChild('BetArea/Sp_Num/Label').gameObject:GetComponent('UILabel')
	this.ChessGroup = this.transform:FindChild('Checkerboard/ChessPosGrid').gameObject
	this.ChessPointGroup = this.transform:FindChild('Checkerboard/ChessGridPoint').gameObject
	this.mMyReady = this.transform:FindChild('UserInfo/SpReady').gameObject
	this.mOtherReady = this.transform:FindChild('OtherInfo/SpReady').gameObject
	this.mStartAni = this.transform:FindChild('TipGroup/StartAni').gameObject:GetComponent('UISpriteAnimation')
	this.mEatAni = this.transform:FindChild('TipGroup/EatAni').gameObject:GetComponent('UISpriteAnimation')
	this.mCheckAni = this.transform:FindChild('TipGroup/CheckAni').gameObject:GetComponent('UISpriteAnimation')
	
	this.mBtnKickOut = this.transform:FindChild('OtherInfo/Btn_KickOut').gameObject
	this.RoundTime= -1
	this.StepTimeLimit = {-1,-1}
	this.mMessageBG = this.transform:FindChild('MessageArea/BGMsg').gameObject
	this.mMsgBtnSure = this.transform:FindChild('MessageArea/BGMsg/Btn_Sure').gameObject
	this.mMsgBtnCancel = this.transform:FindChild('MessageArea/BGMsg/Btn_Cancel').gameObject
	this.mAgreePart = this.transform:FindChild('MessageArea/MsgAgree').gameObject
	this.mGarbageTran = this.transform:FindChild('Checkerboard/GarbageDustbin')
	this.mMsgWaiting = this.transform:FindChild('MessageArea/MsgWaiting').gameObject
	this.mResultObj = this.transform:FindChild('MessageArea/ResultMsg').gameObject
	this.mResultTitleSp = this.mResultObj.transform:FindChild('Title').gameObject:GetComponent('UISprite')
	this.mLab_Name1 = this.mResultObj.transform:FindChild('LabName_1').gameObject:GetComponent('UILabel')
	this.mLab_Name2 = this.mResultObj.transform:FindChild('LabName_2').gameObject:GetComponent('UILabel')
	this.mState1 = this.mLab_Name1.gameObject.transform:FindChild('sp_State').gameObject:GetComponent('UISprite')
	this.mState2 = this.mLab_Name2.gameObject.transform:FindChild('sp_State').gameObject:GetComponent('UISprite')
	this.mLabScore1 = this.mLab_Name1.gameObject.transform:FindChild('LabScore').gameObject:GetComponent('UILabel')
	this.mLabScore2 = this.mLab_Name2.gameObject.transform:FindChild('LabScore').gameObject:GetComponent('UILabel')
	-- this.mPoint1 = this.mLab_Name1.transform:FindChild('State').gameObject
	-- this.mPoint2 = this.mLab_Name2.transform:FindChild('State').gameObject

	this.mMsgAsk = this.transform:FindChild('MessageArea/MsgAsk').gameObject
	

	this.RedInitPos = {[1]={20, 19, 18, 17, 16, 17, 18, 19, 20},
						[2]={0,  0,  0,  0,  0,  0,  0,  0,  0},
						[3]={0, 21,  0,  0,  0,  0,  0, 21,  0},
						[4]={22,  0, 22,  0, 22,  0, 22,  0, 22},
						[5]={0,  0,  0,  0,  0,  0,  0,  0,  0},
						[6]={0,  0,  0,  0,  0,  0,  0,  0,  0},
						[7]={14,  0, 14,  0, 14,  0, 14,  0, 14},
						[8]={0, 13,  0,  0,  0,  0,  0, 13,  0},
						[9]={0,  0,  0,  0,  0,  0,  0,  0,  0},
						[10]={12, 11, 10,  9,  8,  9, 10, 11, 12}}
	this.BlackInitPos = {[1]={12, 11, 10,  9,  8,  9, 10, 11, 12},
						[2]={0,  0,  0,  0,  0,  0,  0,  0,  0},
						[3]={0, 13,  0,  0,  0,  0,  0, 13,  0},
						[4]={14,  0, 14,  0, 14,  0, 14,  0, 14},
						[5]={0,  0,  0,  0,  0,  0,  0,  0,  0},
						[6]={0,  0,  0,  0,  0,  0,  0,  0,  0},
						[7]={22,  0, 22,  0, 22,  0, 22,  0, 22},
						[8]={0, 21,  0,  0,  0,  0,  0, 21,  0},
						[9]={0,  0,  0,  0,  0,  0,  0,  0,  0},
						[10]={20, 19, 18, 17, 16, 17, 18, 19, 20}}
	this.CurrentChessMatrix = {}
	this.mStartClock = false 
	this.mClockReset = false
	this.mCurrentSelect = nil 
	this.mCurSelectPos = {-1,-1}
	this.mCount = -1
	this.MyRound = false   -- true 我回合  --false 对手
	this.ChessItemSet = {}
	this.mLastMove = nil 
	this.mScaleArray = {}
	UISoundManager.Init(this.gameObject);
	UISoundManager.AddAudioSource("gamechess/sounds","begin");
	--添加音效资源
	UISoundManager.AddAudioSource("gamechess/sounds","bg",true);
	UISoundManager.AddAudioSource("gamechess/sounds","eat");  
	UISoundManager.AddAudioSource("gamechess/sounds","eat_s");
	UISoundManager.AddAudioSource("gamechess/sounds","error");
	UISoundManager.AddAudioSource("gamechess/sounds","gameover");
	UISoundManager.AddAudioSource("gamechess/sounds","gamewin"); 
	UISoundManager.AddAudioSource("gamechess/sounds","go");
	UISoundManager.AddAudioSource("gamechess/sounds","heqi");
	UISoundManager.AddAudioSource("gamechess/sounds","jiang");
	UISoundManager.AddAudioSource("gamechess/sounds","over");
	UISoundManager.AddAudioSource("gamechess/sounds","Man_jiangjun");
	UISoundManager.AddAudioSource("gamechess/sounds","select");
	UISoundManager.AddAudioSource("gamechess/sounds","Woman_jiangjun");
	UISoundManager.AddAudioSource("gamechess/sounds","clock");
	
	this.mSettingPanel = this.transform:FindChild('MessageArea/MsgSetting').gameObject
	this.musicOn = this.transform:FindChild('MessageArea/MsgSetting/BGM/Slider').gameObject
	this.yinxiaoOn = this.transform:FindChild('MessageArea/MsgSetting/GameEffect/Btn').gameObject
	this.mLastStepBG = this.transform:FindChild('Checkerboard/Light').gameObject
	this.BasicPos = Vector3.New(-379,448,0)
	this.mWarning = this.transform:FindChild('MessageArea/MsgWarning').gameObject
	this.BetValue = 0
end

function this:HandleBtnsFunc( )
	this.mono:AddClick(this.mBtnBack,this.UserQuit,this)
	-- this.mono:AddClick(this.mBtnStart,function ()
	-- 	local tSendBegin = {type="xq",tag="next",body = 2}	
	-- 	local jsonStr = cjson.encode(tSendBegin);
	-- 	this.mono:SendPackage(jsonStr);
	-- end)
	this.mono:AddClick(this.mBtnStart,function ()
		local tNum = 0
		if this.BetMoney.text ~= nil and this.BetMoney.text ~= '' and this.BetMoney.text ~= '0' then 
			tNum= tonumber(this.BetMoney.text)
		else
			local tSendBegin = {type="xq",tag="next",body = 2}	
			local jsonStr = cjson.encode(tSendBegin);
			this.mono:SendPackage(jsonStr);
			return
		end
		local tSendBet = {type="xq",tag="bet",body =tNum}    
		local jsonStr = cjson.encode(tSendBet);
		this.mono:SendPackage(jsonStr);
	end)

	-- 初始化棋盘上所有点击事件
	for i=1,10 do 
		for j=1,9 do 
			local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(i))
			local tClickArray = {i,j}
			local tPoint = tLine:FindChild(tostring(i)..'_'..tostring(j)).gameObject
			
			this.mono:AddClick(tPoint,function (  )
				this:ChessBoardClick(tClickArray)
			end)   
		end
	end
	this.mono:AddClick(this.mBtnRegret,function (  )
		local tPackage = {type="xq",tag="ask",body = 2}
		local jsonStr = cjson.encode(tPackage);
		this.mono:SendPackage(jsonStr);
		this.mBtnRegret:GetComponent('UIButton').isEnabled =false
		-- this:ShowMessage(6,2)
	end)
	this.mono:AddClick(this.mBtnGiveUp,function (  )
		this:ShowMessage(2,2)
	end)
	this.mono:AddClick(this.mBtnDraw,function (  )
		local tPackage = {type="xq",tag="ask",body = 0}
		-- this:ShowMessage(7,2)
		local jsonStr = cjson.encode(tPackage);
		this.mono:SendPackage(jsonStr);
		this.mBtnDraw:GetComponent('UIButton').isEnabled =false 

	end)
	this.mono:AddClick(this.mBtnSetting,function ( )
		this:ShowMessage(4)
	end)
		-- body
	this.mono:AddClick(this.musicOn, this.ChangeMusic,this);
	this.mono:AddClick(this.yinxiaoOn, this.ChangeYinxiao,this);
end


function this:UserQuit()
	
	SocketConnectInfo.Instance.roomFixseat = true;
	local userQuit = {type="xq",tag="quit"};    --最终产生json的表
	--将表数据编码成json字符串
	local jsonStr = cjson.encode(userQuit);
	this.mono:SendPackage(jsonStr);
	this.mono:OnClickBack();

end

function this:Start()
	this.mono:StartGameSocket();
	coroutine.start(this.UpdateInLua);
	this.ChessGroup:SetActive(false)
	this.mBtnKickOut:SetActive(false)
	this.mOtherHeadImage.gameObject:SetActive(false)
	this.mOtherName.text = ''
	this.BetMoney.text = '0'
	this.BetMoneyInput.value = '0'
	this.mStepTime.text = '00:00'
	this.mRoundTime.text = '00:00'
	this.BetValue = 0
	UISoundManager.Start(true);
	UISoundManager.Instance.PlaySound("bg"); 
	this.mBtnRegret:GetComponent('UIButton').isEnabled = false 
	 this.mBtnDraw:GetComponent('UIButton').isEnabled = false 
	 this.mBtnGiveUp:GetComponent('UIButton').isEnabled = false 


	SettingInfo.Instance.bgVolume = this.mxSettBGBar
	SettingInfo.Instance.effectVolume = this.mxSettEFBar
	SettingInfo.Instance:SaveInfo();
	
end


function this:UpdateInLua()
	while(this.mono) do
		if this.mStartClock == true then 
			coroutine.wait(0.5)
			this.RoundTime = this.RoundTime +1
			local tM = math.floor(this.RoundTime/60)
			local tS = this.RoundTime%60
			if tM<10 then
				tM = '0'..tostring(tM)
			end
			if tS < 10 then
				tS = '0'..tostring(tS)
			end

			this.mRoundTime.text = tostring(tM)..':'..tostring(tS)
			
				
			this.mCount = this.mCount + 1
			local tColor = '[ffffff]'
			if this.mCount > this.StepTimeLimit[1] then 
				if this.StepTimeLimit[2] + this.StepTimeLimit[1] - this.mCount <10 and this.StepTimeLimit[2] + this.StepTimeLimit[1] - this.mCount >0 then 
					UISoundManager.Instance.PlaySound("clock"); 
					 tColor = '[FF0000]'
				end
			end

			if this.mCount <0 then 
				this.mCount = 0 
			end


			local tMin = math.floor(this.mCount /60)
			local tSec = this.mCount %60
			if tMin<10 then
				tMin = '0'..tostring(tMin)
			end
			if tSec < 10 then
				tSec = '0'..tostring(tSec)
			end
			this.mStepTime.text =tColor .. tostring(tMin)..':'..tostring(tSec)
		end
		coroutine.wait(0.5)
	end
end


function this:SocketReceiveMessage(message)
	local message = self;
	local messageObj = cjson.decode(message);
	local typeL = messageObj["type"];
	local tag = messageObj["tag"]    
	if ("account" ==typeL) then
		if tag == "login_success"  then
			-- this:ProcessAccountSucess(messageObj);
		elseif ( string.find( tag,"login_failed_") ~= nil)  then
			local errorInfo = "";
			if ("login_failed_auth" ==tag)  then
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_auth");
			elseif ("login_failed_inactive" ==tag)  then 
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_inactive");
			elseif ("login_failed_otherroom" ==tag)   then
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_otherroom");
			elseif ("login_failed_nomoney" ==tag)  then
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_nomoney");
				errorInfo = errorInfo.."\n";
				errorInfo = errorInfo..ZPLocalization.Instance:Get("Socket_login_failed_nomoney_min");
				errorInfo = errorInfo..SocketConnectInfo.Instance.roomMinMoney;
			elseif ("login_failed_nousemoney" ==tag)  then
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_nousemoney");
				errorInfo = errorInfo.."\n";
				errorInfo = errorInfo..ZPLocalization.Instance:Get("Socket_login_failed_nomoney_min");
				errorInfo = errorInfo..SocketConnectInfo.Instance.roomMinMoney;
			elseif ("login_failed_notexist" ==tag)   then
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_notexist");
			elseif ("login_failed_guest" ==tag)   then
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_guest"); 
			
			elseif ("login_failed_online" ==tag) then
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_online");
			elseif ("login_failed_closed" ==tag)  then
				errorInfo = ZPLocalization.Instance:Get("Socket_login_failed_closed");
				if (messageObj["body"] ~= nil  and   string.len(tostring(messageObj["body"]))  > 0) then
					errorInfo = errorInfo..ZPLocalization.Instance:Get("Socket_login_failed_closed_reason");
					errorInfo = errorInfo..System.Text.RegularExpressions.Regex.Unescape( tostring(messageObj["body"]) );
				end
			else 
				errorInfo = ZPLocalization.Instance:Get("Socket_Unkonw");
			end
			this:ProcessAccountFailed(errorInfo);
		

		end
	elseif typeL == 'xq' then
		print(message)
		if tag == 'run' then
			this:ProcessRun(messageObj)
			
		elseif tag == 'run2' then 

		elseif tag == 'bet' then 
			this:ProcessSetBet(messageObj)
		elseif tag =='next' then 
			this:ProcessSetReady(messageObj)	
		elseif tag == 'bet_error' then 
			this:ShowMessage(1,'下注方必须在10万游戏币以上')
			-- EginProgressHUD.Instance:ShowPromptHUD('下注方必须在10万游戏币以上')
		elseif tag == 'go' then 
			this:ProcessChessGo( messageObj)
		elseif tag == 'ask' then 
			this:ProcessAsk(messageObj)
		elseif tag =='answer' then 
			this:ProcessAnswer(messageObj)
		elseif tag == 'over' then 
			this:ProcessGameOver(messageObj)
		elseif tag == 'banker' then 
			if tostring(messageObj['body']) == tostring(EginUser.Instance.uid) then 
				this.mMyPos =0 
				this.mOtherPos = 1
			else
				this.mMyPos = 1
				this.mOtherPos=0
			end
			this:InitChessBoard()
		end
	elseif typeL =='game' then 
			print(message)
		if tag=="enter" then
			this:ProcessEnter(messageObj)
		elseif tag == 'come' then 
			
			this:ProcessCome(messageObj)
		elseif(tag == "leave") then
			this:ProcessLeave(messageObj)
		elseif(tag == "deskover") then
			this:ProcessDeskOver(messageObj)
		elseif(tag == "notcontinue")then
			coroutine.start(this.ProcessNotcontinue)
		end
	end
end

--{"body": [881751, 1111111], "tag": "bet", "type": "xq"}
function this:ProcessSetBet(messageObj )
	local body = messageObj['body']
	if tostring(body[1]) == tostring(EginUser.Instance.uid) then
		this.mBetId = body[1]
		this.BetValue =tonumber(body[2])
		this.BetMoney.text = body[2]

		this.BetMoneyInput.value = body[2]
		-- this.mBtnBet.gameObject:SetActive(false)
		local tSendBegin = {type="xq",tag="next",body = 2}	
		local jsonStr = cjson.encode(tSendBegin);
		this.BetMoneyInput.gameObject:GetComponent('BoxCollider').enabled =false
		this.mono:SendPackage(jsonStr);
		this.mBtnStart:SetActive(false)
		this:ShowMessage(1,'下注成功')
		-- this.mMsgWaiting:SetActive(true)
	else 
		if body[2] == -1 then
			this:ShowMessage(5,0)
		else
			this.BetValue =tonumber(body[2])
			this:ShowMessage(5,body[2])

		end
	end
end

				
function this:ProcessSetReady(messageObj)
	local tBody = messageObj['body']
	if tostring(tBody[1]) == tostring(EginUser.Instance.uid) then 
		this.mMyReady:SetActive(true)
		this.mBtnStart:SetActive(false)
		-- this.BeginDic[tostring(EginUser.Instance.uid)] = 1
	else
		this.mOtherReady:SetActive(true)
		this.mBtnStart:SetActive(false)
		if this.mMyReady.gameObject.activeSelf == false then 
			this:ShowMessage(5,this.BetValue)
		end
	end 

end
function this:ProcessEnter(messageObj)
	local body = messageObj["body"]
		if body['bet'] ~= nil then
			if body['bet'][2] ~= -1 then  
				this.BetValue = body['bet'][2]
			end
		end
	for k,v in pairs(body['memberinfos']) do 
		if tostring(v['uid']) == tostring(EginUser.Instance.uid) then 
			this.mMyName.text = tostring(v['nickname'])
			this.mMyMoney.text = tostring(v['bag_money'])
			this.mMyHeadImage.spriteName = 'avatar_'..tostring(v['avatar_no'])
			this.mMyUid = v['uid']
		
		else
			this.mOtherName.text = tostring(v['nickname'])
			this.mOtherHeadImage.gameObject:SetActive(true)
			this.mOtherHeadImage.spriteName = 'avatar_'..tostring(v['avatar_no'])
		end
	end
	this:JudgeEnter(body)
end

function this:JudgeEnter(body)

	--做初始逻辑的判断 是否同意 开局
	local tShowTip = 0
	if body['ready'] ~= nil then 
		for k,v in pairs(body['ready']) do 
			if tostring(EginUser.Instance.uid) == tostring(v[1])  then 
				if v[2] == 0 then
					tShowTip = tShowTip +1
				end
			else
				if v[2] == 1 then
					tShowTip = tShowTip + 1
					this.mOtherReady:SetActive(true)
				end
			end
		end
	end
	if tShowTip==2 then 
		if body['bet'] ~= nil then 
			if body['bet'][2] == -1 then
				this:ShowMessage(5,0)
			else
				this:ShowMessage(5,body['bet'][2])
			end
		end
	end

end

--[[{"body": 
			{"memberinfo":
			 {"uid": 889657154, "stream": "", "bag_money": 2642220, "into_money": 2642220, "is_staff": false, "ready": true, 
			 "client_address": "北京市", "wzcardnum": 11, "winning": 31, "waiting": true, "vip_level": 0, "avatar_img": "", "lose_times": 837,
			  "win_times": 390, "mobile_type": 0,
			  "avatar_no": 12, "keynum": 300, "nickname": "罐头食物", "active_point": 0, "level": 1, "exp": 1798, "position": 0}},
			  "tag": "come", "type": "game"}]]--
function this:ProcessCome( messageObj)
	local body = messageObj['body']['memberinfo']
	this.mOtherName.text = tostring(body['nickname'])
	this.mOtherHeadImage.gameObject:SetActive(true)
	this.mOtherHeadImage.spriteName = 'avatar_'..tostring(body['avatar_no'])
	this.mOtherId = body['uid']
end

function this:ProcessLeave( messageObj)
	local body = messageObj['body']
	this.mOtherName.text = ''
	this.mOtherHeadImage.gameObject:SetActive(false)
	this.mOtherReady:SetActive(false)
	this:ShowResult(nil)
end

function this:ProcessDeskOver( messageObj)
	local body = messageObj['body']
end

function this:ProcessNotcontinue( messageObj)
end

function this:ProcessAnswer(messageObj)
	local body = messageObj['body']
	if body == 0 then 
		--不同意和棋
		this:ShowMessage(1,'对方不同意和棋!')
		this.mBtnDraw:GetComponent('UIButton').isEnabled =true 

	elseif body ==2 then 
		this:ShowMessage(1,'对方不同意悔棋!')
		if this.MyRound == false then 
			this.mBtnRegret:GetComponent('UIButton').isEnabled =true
		end 
		--不同意悔棋
	end 
end
function this:ProcessAsk(messageObj)
	local body = messageObj['body']
	if  body ==0 then 
		--求和
		this:ShowMessage(7,1)
	elseif body==2 then 
		--悔棋
		this:ShowMessage(6,1)
	end
end
--[[{'type': 'xq': 'tag': 'run',
 'body': {
'cinfo': [玩家座位, 玩家ID, 昵称,头像编号,头像图片,输赢,用户级别,VIP等级,客户端所在地文字描述,本局押注]
--'time': [每步时长,*读秒]
--}
--]]
--{"body": {"zdf": 100001, 
--"cinfo": [0, 889383113, "4514514", 14, "", 234260, 2, 0, "北京市", 0],
-- "time": [30, 20]}, "tag": "run", "type": "xq"}

--{"body": {"zdf": 100001, "cinfo": 
--[0, 889383113, "4514514", 14, "", 236260, 2, 0, "北京市", 0], [1, 889657154, "罐头食物", 12, "", 2642220, 1, 0, "北京市", 0]
--, "time": [30, 20]}, "tag": "run", "type": "xq"}

--{"body": {"cinfo": [0, 299022, "sygame12", 0, "", 17486, 0, 0, 17486, 0],
-- [1, 881708, "wyg1234", 6, "", 0, 0, 0, 10107475, 0],
-- "limit": [100000, 100000000], "time": [30, 20],
 --"ready": [881708, 0], [299022, 1], "zdf": 100000, 
 --"bet": [0, -1]}, "tag": "run", "type": "xq"}
function this:ProcessRun(messageObj )
	local body = messageObj['body']
	
	 this.StepTimeLimit={ tonumber(body['time'][1]),tonumber(body['time'][2])}
	 this:JudgeEnter(body)
end

--[[红方：
帥8 仕9相10 馬11車12 砲13兵14
黑方：
將16 士17象18 馬19車20 炮21卒22
数据初始化：
[20, 19, 18, 17, 16, 17, 18, 19, 20],
[0,  0,  0,  0,  0,  0,  0,  0,  0],
[0, 21,  0,  0,  0,  0,  0, 21,  0],
[22,  0, 22,  0, 22,  0, 22,  0, 22],
[0,  0,  0,  0,  0,  0,  0,  0,  0],
[0,  0,  0,  0,  0,  0,  0,  0,  0],
[14,  0, 14,  0, 14,  0, 14,  0, 14],
[0, 13,  0,  0,  0,  0,  0, 13,  0],
[0,  0,  0,  0,  0,  0,  0,  0,  0],
[12, 11, 10,  9,  8,  9, 10, 11, 12]]

function this:InitChessBoard(  )
	this:RefreshBoard()
	 this:TipAnimate('Start')
	 UISoundManager.Instance.PlaySound("begin"); 
	 this.mLastStepBG:SetActive(false)
	 this.mMsgWaiting:SetActive(false)
	 this.mBtnRegret:GetComponent('UIButton').isEnabled = false 
	 this.mBtnDraw:GetComponent('UIButton').isEnabled = false 
	 this.mBtnGiveUp:GetComponent('UIButton').isEnabled = false 
	 --1 红  0 黑
	 -- print('My pos  == '..this.mMyPos)
	 if this.mMyPos == 0 then 
	 	
	 	this.CurrentChessMatrix  = {}
	 	for i=1,10 do
	 		local tYArr = {} 
	 		for j=1,9 do 
	 			table.insert(tYArr,this.RedInitPos[i][j])	
	 		end
	 		table.insert(this.CurrentChessMatrix,tYArr)
	 	end 
	 	this.MyRound = true 
	 else 	
 		this.CurrentChessMatrix  = {}
 		for i=1,10 do
	 		local tYArr = {} 
	 		for j=1,9 do 
	 			table.insert(tYArr,this.BlackInitPos[i][j])	
	 		end
	 		table.insert(this.CurrentChessMatrix,tYArr)
	 	end 
	 	this.MyRound = false  

	 end	 	
 	for i=1,10 do 
		for j=1,9 do 
			local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(i))
			local tRow = tLine:FindChild(tostring(i)..'_'..tostring(j)).gameObject
			if tRow.transform.childCount ==1 then 
				local tItem = tRow.transform:FindChild('ChessItem').gameObject 
				local tRole =	tItem.transform:FindChild('ChessRole').gameObject
				
				if tRole ~= nil then 
					local tSp = tRole:GetComponent('UISprite')
					local tItemNum = this.CurrentChessMatrix[i][j]
					tSp.spriteName = 'qizi_'..tItemNum
					tItem:GetComponent('UISprite').spriteName = 'qizi_BG'
					tItem:GetComponent('UISprite'):MakePixelPerfect();
					tRole:GetComponent('UISpriteAnimation').enabled =false
					tItem:GetComponent('UISpriteAnimation').enabled =false

				end
			end
		end
	end
	this.mStartClock = true
	this.ChessGroup:SetActive(true)
	this.mOtherReady:SetActive(false)
	this.mMyReady:SetActive(false)

end



function this:ProcessGameOver(messageObj)
	local body = messageObj['body']
	local tColor = {green='[68d31d]',blue='[2F67A1]',yellow = '[D6BE2B]'}
	for k,v in pairs(body['info']) do
		if tostring(v[1]) == tostring(EginUser.Instance.uid) then 
			local tC = '[000000]'
			local tPicName = ''
			local win_state = v[4] 
			if win_state == 0 then
				this:ShowResult(0)
				tC = tColor.green
				tPicName = 'Lab_Draw1'
				UISoundManager.Instance.PlaySound("heqi"); 
			elseif win_state == 1 then 
				this:ShowResult(1)
				tC = tColor.yellow	
				tPicName ='Lab_Win1'
				UISoundManager.Instance.PlaySound("gamewin"); 
			else
				this:ShowResult(-1)
				tC = tColor.blue
				tPicName ='Lab_Lose1'
				UISoundManager.Instance.PlaySound("gameover"); 
			end
			this.mLab_Name1.text = this.mMyName.text  
			this.mLabScore1.text = tC .. v[2]
			this.mState1.spriteName = tPicName
			-- this.mPoint1:SetActive(true )
		else
			local tC = '[000000]'
			local tPicName = ''
			local win_state = v[4] 
			if win_state == 0 then
				tC = tColor.green
				tPicName = 'Lab_Draw1'
			elseif win_state == 1 then 
				tC = tColor.yellow	
				tPicName ='Lab_Win1'
			else
				tC = tColor.blue
				tPicName ='Lab_Lose1'
			end
			this.mLab_Name2.text = this.mOtherName.text 
			this.mLabScore2.text = tC .. v[2]
			this.mState2.spriteName = tPicName
			-- this.mPoint2:SetActive(false)

		end
	end
end

--{"body": {"e": 0, "g": [7, 7, 13, 7, 4, 0]}, "tag": "go", "type": "xq"}
--'e': 0没错 1不可走, 没有e表示悔棋
-- X从第几行y第几列c1走哪个棋子的值
-- X2走到第几行y2第几列c2对方阵亡棋子的值,没有为空
-- 阵亡为將帥则自然分出输赢
function this:ProcessChessGo( messageObj)
	local body = messageObj['body']
	local tEated = false 
	local tIsEnd = false 
	if body['e'] ~= nil then 
		if body['e'] ==0 then
			local tMoveArray = body['g']
			local tMoveItem  = tMoveArray[3]
			if this.mMyPos == 1 then 
				tMoveArray[1] = 10- tMoveArray[1]
				tMoveArray[4] = 10- tMoveArray[4]
				tMoveArray[2] = 9- tMoveArray[2]
				tMoveArray[5] = 9- tMoveArray[5]
			else
				tMoveArray[1] =  tMoveArray[1]+1
				tMoveArray[4] =  tMoveArray[4]+1
				tMoveArray[2] =  tMoveArray[2]+1
				tMoveArray[5] =  tMoveArray[5]+1
			end
			if this:IsMyItem(tMoveItem) == true then 
				this.MyRound = false 
				this.mCount = 0

				this.mBtnRegret:GetComponent('UIButton').isEnabled = true 
			else
				this.MyRound = true 
				this.mCount = 0 
				this.mBtnRegret:GetComponent('UIButton').isEnabled = false 
			end
			if this.mStartClock == true then 
				if this.MyRound == true then 
					this.mOtherHeadLight:SetActive(false)
					this.mHeadLight:SetActive(true)
					coroutine.start(function ()
						local i =0
						local tA =1
						local tC = 1
						while (true) do
							i = i+1
							coroutine.wait(0.1)
							tA = tA - 0.1 *tC
							if tA < 0 then 
								tA = 0
								tC = -1
							elseif tA > 1 then
								tA = 1
								tC = 1
							end
							this.mHeadLight:GetComponent('UISprite').alpha =  tA
							if this.MyRound == false then
								break
							end
						end
						

					end)
					
				else
					this.mHeadLight:SetActive(false)
					this.mOtherHeadLight:SetActive(true)
					coroutine.start(function ()
						local i =0
						local tA =1
						local tC = 1
						while (true) do
							i = i+1
							coroutine.wait(0.1)
							tA = tA - 0.1 *tC
							if tA < 0 then 
								tA = 0
								tC = -1
							elseif tA > 1 then
								tA = 1
								tC = 1
							end
							this.mOtherHeadLight:GetComponent('UISprite').alpha =  tA
							if this.MyRound == true then
								break
							end
						end

					end)
				end
			end


			local tMoveItemObj =  this:GetItemObj(tMoveArray[1],tMoveArray[2])
			-- print('('..(tMoveArray[1] )..','..(tMoveArray[2] )..')')
			this.CurrentChessMatrix[tMoveArray[1]][tMoveArray[2]] = 0
			this.CurrentChessMatrix[tMoveArray[4]][tMoveArray[5]] = tMoveItem
			this.mLastMove = tMoveItemObj 
			
			if tMoveArray[6] ==0 then
				local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(tMoveArray[4]))
				local tPoint = tLine:FindChild(tostring(tMoveArray[4])..'_'..tostring(tMoveArray[5]))
				tMoveItemObj.transform.parent = tPoint	
				-- tMoveItemObj.transform.localScale = Vector3.one
				tMoveItemObj.transform.localPosition = Vector3.zero
				if this.MyRound == false then 
					this:ItemAni(tMoveItemObj,tMoveItem,2)
					UISoundManager.Instance.PlaySound("go")
				end

			else
				--吃子
				if tMoveArray[6] == 8 or tMoveArray[6] == 16 then
					tIsEnd = true 
				else
					local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(tMoveArray[4]))
					local tPoint = tLine:FindChild(tostring(tMoveArray[4])..'_'..tostring(tMoveArray[5]))
					local tItemObj = this:GetItemObj(tMoveArray[4],tMoveArray[5])
					if tItemObj ~= nil then 
						tItemObj.transform.parent = this.mGarbageTran
						tMoveItemObj.transform.parent = tPoint
						tMoveItemObj.transform.localPosition = Vector3.zero
						-- tMoveItemObj.transform.localScale = Vector3.one
						if this.MyRound == false then 
							this:ItemAni(tMoveItemObj,tMoveItem,3)
						end
						tItemObj:SetActive(false)
						tEated = true 
						UISoundManager.Instance.PlaySound("eat"); 
						-- this:TipAnimate('Eat')
					end
				end
			end
			this.mLastStepBG.transform.localPosition= this.BasicPos  + Vector3.New((tMoveArray[5]-1)*95,-(tMoveArray[4]-1)*95,0)
			this.mLastStepBG:SetActive(true)

		end

		-- 清除 可走点 
		for i=1,#this.mScaleArray do 
			local tP = this.mScaleArray[i]
			local tLine =  this.ChessPointGroup.transform:FindChild( tostring( tP.x	)..'_'..tostring( tP.y	)).gameObject
			if tLine ~= nil then 
				tLine:SetActive(false)
			else 
				error(tP.x..' == '..tP.y)
			end 
		end
		this.mScaleArray = {}
		--检测将军
		-- print('Check  ==  ' .. tostring(this:IsCheck()))
		if tIsEnd == false then  
			if this:IsCheck() == true then 
				this:TipAnimate('Check')
				UISoundManager.Instance.PlaySound("jiang"); 
			elseif tEated == true then 
				this:TipAnimate('Eat')
				UISoundManager.Instance.PlaySound("eat_s"); 
			end
		end

		
	 	this.mBtnDraw:GetComponent('UIButton').isEnabled = true 
	 	this.mBtnGiveUp:GetComponent('UIButton').isEnabled = true 
	else
		--悔棋 
		local tMoveArray = body['g']
		local tMoveItem  = tMoveArray[3]
		if this.mMyPos == 1 then 
			tMoveArray[1] = 10- tMoveArray[1]
			tMoveArray[4] = 10- tMoveArray[4]
			tMoveArray[2] = 9- tMoveArray[2]
			tMoveArray[5] = 9- tMoveArray[5]
		else
			tMoveArray[1] =  tMoveArray[1]+1
			tMoveArray[4] =  tMoveArray[4]+1
			tMoveArray[2] =  tMoveArray[2]+1
			tMoveArray[5] =  tMoveArray[5]+1
		end
		if this.MyRound == true then 
			this.MyRound = false 
			this.mBtnRegret:GetComponent('UIButton').isEnabled = true
		else
			this.MyRound = true
			this.mBtnRegret:GetComponent('UIButton').isEnabled = false  
		end
		--last move  step  错了 ！！
		
		local tMoveItemObj =  this.mLastMove
		this.CurrentChessMatrix[tMoveArray[1]][tMoveArray[2]] = tMoveItem
		local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(tMoveArray[1]))
		local tPoint = tLine:FindChild(tostring(tMoveArray[1])..'_'..tostring(tMoveArray[2]))
		tMoveItemObj.transform.parent = tPoint	
		tMoveItemObj.transform.localScale = Vector3.one
		tMoveItemObj.transform.localPosition = Vector3.zero
		this.CurrentChessMatrix[tMoveArray[4]][tMoveArray[5]] = tMoveArray[6]
		if tMoveArray[6] ~= 0 then 
			if this.mGarbageTran.childCount >0 then  
				local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(tMoveArray[4]))
				local tPoint = tLine:FindChild(tostring(tMoveArray[4])..'_'..tostring(tMoveArray[5]))
				local tObj = this.mGarbageTran:GetChild(0).gameObject
				tObj.transform.parent = tPoint
				tObj.transform.localPosition = Vector3.zero
				tObj.transform.localScale = Vector3.one
				tObj.transform:FindChild('ChessRole').gameObject:GetComponent('UISprite').spriteName ='qizi_'..tMoveArray[6]
				tObj:GetComponent('UISprite').spriteName ='qizi_BG'
				tObj:GetComponent('UISprite'):MakePixelPerfect()

				tObj:SetActive(true)
			end
		end
		this.mLastStepBG:SetActive(false)
		if this:IsCheck() == true then 
			this:TipAnimate('Check')
			UISoundManager.Instance.PlaySound("jiang"); 
		end
	end
end


function this:GetItemObj(pX,pY )
	local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(pX))
	local tPoint = tLine:FindChild(tostring(pX)..'_'..tostring(pY)).gameObject
	if tPoint.transform.childCount == 1 then 
		local tItemObj = tPoint.transform:FindChild('ChessItem').gameObject
		if tItemObj ~= nil then 
			return tItemObj
		else
			return nil 
		end
	end
	return nil 
end
--[[Lab_Check,Lab_Draw,Lab_Eat,Lab_Start,Lab_Lose,Lab_Win]]
function this:TipAnimate(pTipName)
	
	this.mStartAni.gameObject:SetActive(false)
	this.mEatAni.gameObject:SetActive(false)
	this.mCheckAni.gameObject:SetActive(false)
	local tAni = nil 
	if pTipName == 'Eat'  then 
		tAni= this.mEatAni
		tAni.gameObject:SetActive(true)
	elseif pTipName == 'Start' then 
		tAni= this.mStartAni
		tAni.gameObject:SetActive(true)
	elseif pTipName == 'Check' then 
		tAni= this.mCheckAni
		tAni.gameObject:SetActive(true)
	end

	tAni:ResetToBeginning(); 
	tAni:Play();
	tAni:playWithCallback(Util.packActionLua(function (self)
		coroutine.start(function ( )
			coroutine.wait(0.5)
			tAni.gameObject:SetActive(false)
						
		end)
	end,self)) 
end


--棋盘点击方法 传入点击位置
function this:ChessBoardClick(pClickArray)
	if this.MyRound == false then 
		return 
	end

	if this.mCurrentSelect == nil then 
		local tClickRole = this.CurrentChessMatrix[pClickArray[1]][pClickArray[2]]
		if tClickRole ~= 0 and  this:GetItemObj(pClickArray[1],pClickArray[2]) ~= nil and this:IsMyItem(tClickRole) == true then
			--选中棋子
			this.mCurrentSelect = this:GetItemObj(pClickArray[1],pClickArray[2])
			this.mCurSelectPos = {pClickArray[1],pClickArray[2]}
			if this.MyRound == true then
				this:ItemAni(this.mCurrentSelect,tClickRole,1)
				UISoundManager.Instance.PlaySound("select")
			end
			-- this.mCurrentSelect.transform.localScale = Vector3.one*1.2
			local tClickPoint = {x=pClickArray[1],y=pClickArray[2]}
			local tScale =  this:CheckScale(tClickRole,tClickPoint)
			this.mScaleArray = tScale
			for i=1,#tScale do 
				local tP = tScale[i]
				local tLine = this.ChessPointGroup.transform:FindChild( tostring( tP.x	)..'_'..tostring( tP.y	)).gameObject
				
				if tLine ~= nil then 
					tLine:SetActive(true)
				else
					error(tP.x ..' == '.. tP.y)
				end 
			end

		end
	else
		local tClickRole = this.CurrentChessMatrix[pClickArray[1]][pClickArray[2]]
		if this:IsMyItem(tClickRole) == true then
			if this.mCurrentSelect ~= nil then 
				this.mCurrentSelect.transform.localScale = Vector3.one 

			end
			
			for i=1,#this.mScaleArray do 
				local tP = this.mScaleArray[i]
				local tLine = this.ChessPointGroup.transform:FindChild( tostring( tP.x	)..'_'..tostring( tP.y	)).gameObject
				tLine:SetActive(false) 
			end
			this.mScaleArray  ={}
			local tClickPoint = {x=pClickArray[1],y=pClickArray[2]}
			local tScale =  this:CheckScale(tClickRole,tClickPoint)
			this.mScaleArray = tScale
			for i=1,#tScale do 
				local tP = tScale[i]
				local tLine = this.ChessPointGroup.transform:FindChild( tostring( tP.x	)..'_'..tostring( tP.y	)).gameObject
				tLine:SetActive(true) 
			end

			if this.MyRound == true then 
				local tLastRole = this.CurrentChessMatrix[this.mCurSelectPos[1]][this.mCurSelectPos[2]]
				this:ItemAni(this.mCurrentSelect,tLastRole,2)
			end

			this.mCurrentSelect = this:GetItemObj(pClickArray[1],pClickArray[2])
			if this.MyRound == true then 
				this:ItemAni(this.mCurrentSelect,tClickRole,1)
			end
			this.mCurSelectPos = {pClickArray[1],pClickArray[2]}
		else
			local tCurRole = this.CurrentChessMatrix[ this.mCurSelectPos[1]][this.mCurSelectPos[2]]
			local tTar = {['x'] = pClickArray[1],['y'] = pClickArray[2]}
			local tCur = {['x'] =this.mCurSelectPos[1],['y'] = this.mCurSelectPos[2]}
			if this:CanGo(tonumber(tCurRole),tCur,tTar) == true then 
				
				
				local tMoveA = {}
				if this.mMyPos == 1 then 
					--黑棋坐标转换
					tMoveA[1] = 10- this.mCurSelectPos[1]
					tMoveA[2] = 9- this.mCurSelectPos[2]
					tMoveA[3] = 10- pClickArray[1]
					tMoveA[4] = 9- pClickArray[2]
				else
					tMoveA[1] = this.mCurSelectPos[1] -1
					tMoveA[2] = this.mCurSelectPos[2] -1
					tMoveA[3] =  pClickArray[1] -1
					tMoveA[4] =  pClickArray[2] -1
				end 
				local tMoveA = {tMoveA[1],tMoveA[2],tMoveA[3],tMoveA[4]}
				local tMoveMsg = {type="xq",tag="go",body=tMoveA};    --最终产生json的表
				local jsonStr = cjson.encode(tMoveMsg);
				this.mono:SendPackage(jsonStr);
				this.mCurrentSelect = nil 
				this.mCurSelectPos = {-1,-1}
			else
				-- print('in  can not go ')
				UISoundManager.Instance.PlaySound("error")
			end
		end
	end
end

function this:CanGo(pCurRole,pCurPos,pTargetPos)
	if pCurPos.x >10 or pCurPos.y<1 or pTargetPos.x >10 or pTargetPos.y<1 then 
		return false 
	end

	if pCurRole ==8 or pCurRole==16 then
	    --老将 只能走一步 不能对脸

	    if pTargetPos.x<=10 and pTargetPos.x >=8 and pTargetPos.y <=6 and pTargetPos.y >=4 then 
			if math.abs(pTargetPos.x - pCurPos.x) ==1 and pTargetPos.y== pCurPos.y  then  
				if this:CheckFace(pCurRole,pCurPos,pTargetPos) == false then 
					return  false 
				else
					return true 
				end
			elseif pTargetPos.x == pCurPos.x and  math.abs(pTargetPos.y- pCurPos.y) ==1 then 
				if this:CheckFace(pCurRole,pCurPos,pTargetPos) == false then 
					return  false 
				else
					return true 
				end
			end 
		end
		return false 
	elseif pCurRole == 9 or pCurRole ==17 then 
	  --仕
		-- print('in  仕 ')

	    if pTargetPos.x<=10 and pTargetPos.x >=8 and pTargetPos.y <=6 and pTargetPos.y >=4 then 
			if  math.abs(pTargetPos.x - pCurPos.x) ==1 and  math.abs(pTargetPos.y- pCurPos.y) ==1  then  
				return true 
			end
	    end
	    -- print('仕 不能走 ')
	    return false 
	elseif pCurRole == 12 or pCurRole ==20 then 
		--车 
		-- print('in  车 ')
		if pTargetPos.x == pCurPos.x  then
			local tNum = 0

			if pTargetPos.y > pCurPos.y then
				tNum =-1 
			else
				tNum = 1 
			end 
			for i=pTargetPos.y+tNum,pCurPos.y-tNum,tNum do 
				if this.CurrentChessMatrix[pTargetPos.x][i] ~= 0 then 
					return false 
				end	
			end
			return true 
		elseif pTargetPos.y == pCurPos.y then 
			local tNum = 0

			if pTargetPos.x > pCurPos.x then
				tNum =-1 
			else
				tNum = 1 
			end 
			for i=pTargetPos.x+tNum,pCurPos.x-tNum,tNum do 
				if this.CurrentChessMatrix[i][pTargetPos.y] ~= 0 then 
					return false 
				end	
			end
			return true 
		end
		return false 
	elseif pCurRole ==14 or pCurRole ==22 then
			--兵 
		-- print('in  兵 ')
		-- 待检查
		if pTargetPos.x <= 7 then
			if pTargetPos.x > 5 then 
				if pTargetPos.y == pCurPos.y and (pCurPos.x - pTargetPos.x) ==1 then 
					return  true 
				end 
			else
				if math.abs(pTargetPos.y - pCurPos.y) ==1 or  pTargetPos.x - pCurPos.x == -1 then
					if math.abs(pTargetPos.y- pCurPos.y) ==1 and pTargetPos.x - pCurPos.x ==-1 then 
						return false 
					end
					return true 
				end 
			end 
		end 
		return false 
	elseif pCurRole == 10 or pCurRole == 18 then 
		--相
		-- print('in  相')
		if math.abs(pTargetPos.x - pCurPos.x) ==2 and math.abs(pTargetPos.y - pCurPos.y) == 2 then 
			local tStoneX =(pTargetPos.x + pCurPos.x)/2 
			local tStoneY =(pTargetPos.y + pCurPos.y)/2  
			-- print(tStoneX  .. ' ===  '.. tStoneY)
			if this.CurrentChessMatrix[tStoneX][tStoneY] == 0 then
				return true 
			end
		end
		return false 
	elseif pCurRole == 11 or pCurRole == 19 then 
		--马 
		-- print('in  马')
		if math.abs(pTargetPos.x - pCurPos.x) + math.abs(pTargetPos.y- pCurPos.y) ==3 then 
			local tX =   pTargetPos.x - pCurPos.x 
			local tY = pTargetPos.y - pCurPos.y
			local tStoneX = 0
			local tStoneY =0
			if math.abs(tX) ==2 then 
				tStoneX =  tX/2 + pCurPos.x 
				tStoneY = pCurPos.y
			elseif math.abs(tY) ==2 then 
				tStoneY = tY/2 +pCurPos.y
				tStoneX = pCurPos.x 
			end
			if this.CurrentChessMatrix[tStoneX][tStoneY] == 0 then 
				return true 
			end
			-- print('别腿')
			return false 
		end
	elseif pCurRole ==13 or pCurRole ==21 then 
		--炮
		-- print('in == 炮')
		local tTargetRole = this.CurrentChessMatrix[pTargetPos.x][pTargetPos.y]
		if pTargetPos.x == pCurPos.x  then

			local tNum = 0

			if pTargetPos.y > pCurPos.y then
				tNum =-1 
			else
				tNum = 1 
			end 
			--检测吃子
			
			if this:InSameSide(pCurRole,tTargetPos) == false then 
				local tN = 0
				for i=pTargetPos.y,pCurPos.y,tNum do
					if tTargetRole~= 0 then 
						if this.CurrentChessMatrix[pTargetPos.x][i] ~= 0 then
							tN = tN +1 
						end
					end 
				end
				if tN == 3 then
					return true 
				elseif tN >3 or tN==2 then  
					return false 
				end
			else 
				return false 
			end

			for i=pTargetPos.y+tNum,pCurPos.y-tNum,tNum do
				if this.CurrentChessMatrix[pTargetPos.x][i] ~= 0 then 
					return false 
				end	
			end
			return true 
		elseif pTargetPos.y == pCurPos.y then 
			local tNum = 0

			if pTargetPos.x > pCurPos.x then
				tNum = -1 
			else
				tNum = 1 
			end 


			if this:InSameSide(pCurRole,tTargetPos) == false then 
				local tN = 0
				for i=pTargetPos.x,pCurPos.x,tNum do
					if tTargetRole~= 0 then 
						if this.CurrentChessMatrix[i][pTargetPos.y] ~= 0 then
							tN = tN +1 
						end
					end 
				end
				if tN == 3 then
					return true 
				elseif tN >3 or tN==2 then  
					return false  
				end
			else
				return false 
			end

			for i=pTargetPos.x+tNum,pCurPos.x-tNum,tNum do 
				if this.CurrentChessMatrix[i][pTargetPos.y] ~= 0 then 
					return false 
				end	
			end
			return true 
		end
		return false 
	end
	return false 
end
--用于检测对脸 和 炮的 和 别腿
--true 不对脸  false 是对脸
function this:CheckFace(pRole,pCurPos,pTarPos  )
	if pRole == 8 or pRole == 16 then 
		local tOtherPosX = -1
		local tY = -1 
		for i=1,4 do 
			for j=4,6 do
				if this.CurrentChessMatrix[i][j] == 8 or this.CurrentChessMatrix[i][j] == 16 then 
					tOtherPosX = j
					tY = i
					break
				end
			end
		end
		if tOtherPosX ~= -1 and tY ~= -1 then 
			if tOtherPosX == pTarPos.y  then
				--检测是否有间隔 
				for i=tY+1,pTarPos.x-1 do 
					if this.CurrentChessMatrix[i][tY] ~= 0 then 
						return true 
					end 
				end
			else
				return true 
			end
			return false
		end
		return true 
	end
	return true 
end
-- 红方：帥8 仕9相10 馬11車12 砲13兵14
-- 黑方：將16 士17象18 馬19車20 炮21卒22
function this:IsMyItem(pNum)
	if this.mMyPos == 0 then 
		if pNum == 8 or pNum == 9 or pNum == 11 or pNum == 12 or pNum==13 or pNum==14 or pNum==10 then
			return true 
		else
			return false 
		end
	else
		if pNum == 16 or pNum == 17 or pNum == 18 or pNum == 19 or pNum==20 or pNum==21 or pNum==22 then
			return true 
		else
			return false 
		end
	end

end

function this:InSameSide( pCur,pTar )
	local tRed = {8,9,10,11,12,13,14}
	local tBlack = {16,17,18,19,20,21,22}
	local tIn = -1
	if pCur == pTar then
		return true 
	end 
	for i=1,7 do 

		if tRed[i] == pCur then 
			tIn = tIn +1  
		end 
		if tRed[i]==pTar then 
			tIn = tIn +1
		end
	end
	if tIn ==1 then
		return true 
	else
		return false
	end


end
--[[   1 = 金币不足  2=认输 3= 长将警告 4=设置 5=同意下注并开始 6=悔棋 7=求和棋 ]]

function this:ShowMessage(pType,...)
	local arg = {...}
	if pType == 5 then 
		-- this.mMessageBG:SetActive(true)
		this.mAgreePart:SetActive(true)
		local tBetMoney = this.mAgreePart.transform:FindChild('Lab_2').gameObject:GetComponent('UILabel')
		if arg[1]~= nil and type(arg[1]) =='number' then 
			tBetMoney.text = '对方下注'..tostring(arg[1])..',您是否同意？点击同意即开始游戏'
		else
			tBetMoney.text =''
		end
		local tCanBtn = this.mAgreePart.transform:FindChild('Btn_Cancel').gameObject
		local tSureBtn = this.mAgreePart.transform:FindChild('Btn_Sure').gameObject
		this.mono:AddClick(tSureBtn,function ()
			local tSendBegin = {type="xq",tag="next",body = 2}	
			local jsonStr = cjson.encode(tSendBegin);
			this.mono:SendPackage(jsonStr);
			this.mMessageBG:SetActive(false)
			this.mAgreePart:SetActive(false)
			this.BetMoney.text = tostring(arg[1])
			this.BetValue  = tonumber(arg[1])
			this.BetMoneyInput.gameObject:GetComponent('BoxCollider').enabled =false
		end)
		this.mono:AddClick(tCanBtn,function ()
			local tSendBegin = {type="xq",tag="next",body = 0}	
			local jsonStr = cjson.encode(tSendBegin);
			this.mono:SendPackage(jsonStr);
			this:UserQuit()
		end)
	elseif pType == 6 or pType ==2  or pType ==7  then 
		this.mMsgAsk:SetActive(true)
		this.mMessageBG:SetActive(true)
		if this.MyRound == true then 
			if this.mCurrentSelect ~= nil and this.mCurSelectPos[1]~= -1 and this.mCurSelectPos[2]~= -1  then 
				local tLastRole = this.CurrentChessMatrix[this.mCurSelectPos[1]][this.mCurSelectPos[2]]
				this:ItemAni(this.mCurrentSelect,tLastRole,2)
			end
			for i=1,#this.mScaleArray do 
				local tP = this.mScaleArray[i]
				local tLine =  this.ChessPointGroup.transform:FindChild( tostring( tP.x	)..'_'..tostring( tP.y	)).gameObject
				if tLine ~= nil then 
					tLine:SetActive(false)
				end 
			end
			this.mCurrentSelect = nil 
		end
		local tContent = ''
		local tCode = -1
		local tPackage = nil 
		 if pType ==6 then 
		 	tContent =  'LabRegret'
		 	tCode = 2 
		 	tPackage = {type="xq",tag="",body = {-1,2}}
		 elseif pType ==2 then 
		 	tContent ='LabLose'
		 	tCode = 1
		 	tPackage = {type="xq",tag="ask",body = 1}
		 elseif pType == 7 then 
		 	tContent ='LabDraw'
		 	tCode =0
		 	tPackage = {type="xq",tag="",body = {-1,0}}
		 end

		 local tLab = this.mMsgAsk.transform:FindChild('Lab_Sp').gameObject:GetComponent('UISprite')
		 if arg[1] ~= nil and type(arg[1])=='number' then 
			if arg[1] == 1 then 
				--对方请求 
				tLab.spriteName = tContent
				tPackage.tag = 'answer'
				
			else
				this.mMsgAsk.transform:FindChild('Lab_1').gameObject:GetComponent('UILabel').text = '你确定要'
				tLab.spriteName = tContent
				tPackage.tag = 'ask'
				this.mMsgAsk.transform:FindChild('Lab_2').gameObject:SetActive(false)

				local tNo = 1
				if type(tPackage.body) ~= 'number' then  
					tNo = tPackage.body[2] 
				end
				tPackage.body=tNo
			end
		end
		this.mMessageBG:SetActive(true)
		print('-----------------------------------------------------')
		this.mono:AddClick(this.mMsgBtnSure,function ()
			-- local tSendBegin = {type="xq",tag="ask",body = tCode}	
			if type(tPackage.body) ~= 'number' then 
				tPackage.body[1]=1
			end

			local jsonStr = cjson.encode(tPackage);
			this.mono:SendPackage(jsonStr);
			this.mMessageBG:SetActive(false)
			this.mMsgAsk:SetActive(false)
			this.mMsgAsk.transform:FindChild('Lab_2').gameObject:SetActive(true)
			this.mMsgAsk.transform:FindChild('Lab_1').gameObject:GetComponent('UILabel').text = '对方要请求'
		end)
		this.mono:AddClick(this.mMsgBtnCancel,function ()
			if type(tPackage.body) ~= 'number' then
				tPackage.body[1]=0 
				local jsonStr = cjson.encode(tPackage);
				this.mono:SendPackage(jsonStr);
			end 

			this.mMessageBG:SetActive(false)
			this.mMsgAsk:SetActive(false)
			this.mMsgAsk.transform:FindChild('Lab_2').gameObject:SetActive(true)
			this.mMsgAsk.transform:FindChild('Lab_1').gameObject:GetComponent('UILabel').text = '对方要请求'
		end)
	elseif pType ==4 then 
		
		this.mSettingPanel:SetActive(true) 
		this.mono:AddClick(this.mSettingPanel.transform:FindChild('Btn_Sure').gameObject,function ()
			SettingInfo.Instance.bgVolume = this.mxSettBGBar;
			SettingInfo.Instance.effectVolume = this.mxSettEFBar;
			SettingInfo.Instance:SaveInfo();

			-- this.mMessageBG:SetActive(false)
			this.mSettingPanel:SetActive(false) 
		end)
		this.mono:AddClick(this.mSettingPanel.transform:FindChild('Btn_Close').gameObject,function ( )
			this.mSettingPanel:SetActive(false) 
		end)

	elseif pType ==1 then 	
		coroutine.start(function ( )
			this.mWarning:SetActive(true)
			this.mWarning.transform:FindChild('Lab_1').gameObject:GetComponent("UILabel").text = arg[1] 
			coroutine.wait(1)
			iTween.NGUIFadeTo (this.mWarning,iTween.Hash ("from",1.0,"to",0.1,"time",0.5,"onupdate","SetToastAlpha", "looptype", "linear", "nguitarget",this.mWarning:GetComponent('UISprite')));
			coroutine.wait(1)
			this.mWarning:SetActive(false)
			this.mWarning:GetComponent('UISprite').alpha = 1 
		end)
		
	end

end
-- -1=lose  0=draw 1=win 
function this:ShowResult(pState)
	if pState ~= nil then 
		this.mResultObj:SetActive(true)
	end
	this.ChessGroup:SetActive(false)
	this.mBtnStart:SetActive(true)
	this.mMessageBG:SetActive(false)
	this.mAgreePart:SetActive(false)
	this.mSettingPanel:SetActive(false)
	this.mWarning:SetActive(false)
	this.mLastStepBG:SetActive(false)
	this.mLastMove = nil
	this.mMsgAsk:SetActive(false)
	--复原棋子 
	this.mBtnRegret:GetComponent('UIButton').isEnabled = false 
	this.mBtnDraw:GetComponent('UIButton').isEnabled = false 
	this.mBtnGiveUp:GetComponent('UIButton').isEnabled = false 
	this.mCurrentSelect = nil 
	this.mCurSelectPos = {-1,-1}
	this.mStartClock = false
	this.mRoundTime.text = '00:00' 
	this.mCount =0 
	this.RoundTime = 0
	this.mStepTime.text = '00:00'
	this.BetMoneyInput.value = 0
	this.BetMoney.text = '0'
	this.BetValue = 0
	this.BetMoneyInput.gameObject:GetComponent('BoxCollider').enabled =true
	this.mHeadLight:SetActive(false)
	this.mOtherHeadLight:SetActive(false)
	if pState ~= nil then 
		for i=1,#this.mScaleArray do 
			local tP = this.mScaleArray[i]
			local tLine =  this.ChessPointGroup.transform:FindChild( tostring( tP.x	)..'_'..tostring( tP.y	)).gameObject
			if tLine ~= nil then 
				tLine:SetActive(false)
			end 
		end

		if pState ==-1 then 
			this.mResultTitleSp.spriteName = 'Lab_Lose'	
		elseif pState ==0 then 
			this.mResultTitleSp.spriteName = 'Lab_Draw'
		else
			this.mResultTitleSp.spriteName = 'Lab_Win'
		end
		this.mono:AddClick(this.mResultObj.transform:FindChild('Btn_Close').gameObject,function ()
			this.mResultObj:SetActive(false)
		end)
		this.mono:AddClick(this.mResultObj.transform:FindChild('Btn_Sure').gameObject,function ()
			this.mResultObj:SetActive(false)
		end)
	end
end
--重置棋盘 
function this:RefreshBoard()
	if #this.ChessItemSet == 0 or #this.ChessItemSet<32 then 
		this.ChessItemSet = {}
		for i=1,10 do 
			for j=1,9 do 
				local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(i))
				local tRow = tLine:FindChild(tostring(i)..'_'..tostring(j)).gameObject
				if tRow.transform.childCount ==1 then 
					local tItem = tRow.transform:FindChild('ChessItem').gameObject
					table.insert(this.ChessItemSet,tItem)
				end
			end
		end
		if #this.ChessItemSet < 32 then
			for i=0,this.mGarbageTran.childCount-1 do 
				table.insert(this.ChessItemSet,this.mGarbageTran:GetChild(i).gameObject)
			end
		end
		
	elseif  #this.ChessItemSet == 32 then 
		this.CurrentChessMatrix  = {}
 		for i=1,10 do
	 		local tYArr = {} 
	 		for j=1,9 do 
	 			table.insert(tYArr,this.RedInitPos[i][j])	
	 		end
	 		table.insert(this.CurrentChessMatrix,tYArr)
	 	end

		local tNum =0
		for i=1,10 do 
			for j=1,9 do 
				local tLine = this.ChessGroup.transform:FindChild( 'Line_'..tostring(i))
				local tRow = tLine:FindChild(tostring(i)..'_'..tostring(j)).gameObject
				
				if this.CurrentChessMatrix[i][j]~=0 then 
					tNum = tNum +1
					this.ChessItemSet[tNum].transform.parent = tRow.transform
					this.ChessItemSet[tNum].transform.localPosition = Vector3.zero
					this.ChessItemSet[tNum]:SetActive(true)			
				end
			end
		end
	end
end

--检测将军 
-- 红方：帥8 仕9相10 馬11車12 砲13兵14
-- 黑方：將16 士17象18 馬19車20 炮21卒22
function this:IsCheck()
	--确定老将
	local tRedBoss = {}
	local tBlackBoss = {} 
	for i=1,4 do 
		for j=4,6 do
			if this.CurrentChessMatrix[i][j] == 8  then 
				tRedBoss = {i,j}
				break 
			elseif this.CurrentChessMatrix[i][j] == 16 then 
				tBlackBoss = {i,j}
				break
			end
		end
	end
	for i=8,10 do 
		for j=4,6 do 
			if this.CurrentChessMatrix[i][j] == 8  then 
				tRedBoss = {i,j}
				break 
			elseif  this.CurrentChessMatrix[i][j] == 16 then 
				tBlackBoss = {i,j}
				break
			end
		end
	end
	if #tRedBoss ~= 0  then 
	--兵检测 
		if this.CurrentChessMatrix[tRedBoss[1]][tRedBoss[2]+1]== 22 then 
			return true 
		end

		if tRedBoss[1]>1 then 
			if this.CurrentChessMatrix[tRedBoss[1]-1][tRedBoss[2]] == 22 then
				return true 
			end
		end
		if tRedBoss[2]>1 then 
			if this.CurrentChessMatrix[tRedBoss[1]][tRedBoss[2]-1] == 22 then
				return true 
			end
		end
	end
	if #tBlackBoss ~= 0 then 
		if this.CurrentChessMatrix[tBlackBoss[1]][tBlackBoss[2]+1] == 14 then 
			return true 
		end
		if tBlackBoss[1]>1 then 
			if this.CurrentChessMatrix[tBlackBoss[1]-1][tBlackBoss[2]] == 22 then
				return true 
			end
		end
		if tBlackBoss[2]>1 then 
			if this.CurrentChessMatrix[tBlackBoss[1]][tBlackBoss[2]-1] == 22 then
				return true 
			end
		end
	end

	--车 炮 检测
	for i=1,10 do 

		if this.CurrentChessMatrix[i][tRedBoss[2]]==20 then 
		--车 
			local tCur ={x=i,y=tRedBoss[2]}
			local tTar = {x=tRedBoss[1],y=tRedBoss[2]}
			if this:CanGo(20,tCur,tTar) == true  then 
				-- print('in che=='..tCur.x..' == '..tCur.y)

				return true
			end
		elseif this.CurrentChessMatrix[i][tRedBoss[2]]==21 then 
			--炮
			local tCur ={x=i,y=tRedBoss[2]}
			local tTar = {x=tRedBoss[1],y=tRedBoss[2]}
			if  this:CanGo(21,tCur,tTar) == true then 
				return true 
			end

		elseif this.CurrentChessMatrix[i][tBlackBoss[2]]==12  then 
			--车
			local tCur ={x=i,y=tBlackBoss[2]}
			local tTar = {x=tBlackBoss[1],y=tBlackBoss[2]}
			if this:CanGo(12,tCur,tTar) == true then 
				-- print('in che=='..tCur.x..' == '..tCur.y)
				return true 
			end
		elseif this.CurrentChessMatrix[i][tBlackBoss[2]]==13 then 
			--炮

			local tCur ={x=i,y=tBlackBoss[2]}
			local tTar = {x=tBlackBoss[1],y=tBlackBoss[2]}
			if  this:CanGo(13,tCur,tTar) == true then 

				return true 
			end
		end
	end

	for i=1,9 do 
		if this.CurrentChessMatrix[tRedBoss[1]][i]==20 then 
			local tCur ={x=tRedBoss[1],y=i}
			local tTar = {x=tRedBoss[1],y=tRedBoss[2]}
			if this:CanGo(20,tCur,tTar) == true then 
				return true 
			end

		elseif  this.CurrentChessMatrix[tRedBoss[1]][i]==21 then 
			
			 local tCur ={x=tRedBoss[1],y=i}
			  -- print('in pao=11='..tCur.x..' == '..tCur.y)
			local tTar = {x=tRedBoss[1],y=tRedBoss[2]}
			 if  this:CanGo(21,tCur,tTar) == true  then 
				return true 
			end
		elseif this.CurrentChessMatrix[tBlackBoss[1]][i]==12 then

			local tCur ={x=tBlackBoss[1],y=i}
			local tTar = {x=tBlackBoss[1],y=tBlackBoss[2]}
			if this:CanGo(12,tCur,tTar) == true then
				return true 
			end


		elseif  this.CurrentChessMatrix[tBlackBoss[1]][i]==13 then 
			
			local tCur ={x=tBlackBoss[1],y=i}
			-- print('in pao=22='..tCur.x..' == '..tCur.y)
			local tTar = {x=tBlackBoss[1],y=tBlackBoss[2]}
			if  this:CanGo(13,tCur,tTar) == true then 
				return true 
			end
		end
	end
	--马
	--print('in  马')

	for i=1,2 do
		for  j=1,2 do 
			if i~=j then
				for m=1,2 do 
					
					if tBlackBoss[1]+i*(-1)^m >0 and tBlackBoss[1]+i*(-1)^m <10 and tBlackBoss[2]+j*(-1)^m >0 and tBlackBoss[2]+j*(-1)^m <9 then
						if  this.CurrentChessMatrix[tBlackBoss[1]+i*(-1)^m][tBlackBoss[2]+j*(-1)^m] == 11 then 
							local tCur = {x=tBlackBoss[1]+i*(-1)^m,y=tBlackBoss[2]+j*(-1)^m}
							local tTar = {x=tBlackBoss[1],y=tBlackBoss[2]}
							if this:CanGo(11,tCur,tTar) == true then 
								return true 
							end
						end
					end
					if tBlackBoss[1]+i*(-1)^m >0 and tBlackBoss[1]+i*(-1)^m <10 and tBlackBoss[2]+j*(-1)^(m+1) >0 and tBlackBoss[2]+j*(-1)^(m+1) <9  then 
						if  this.CurrentChessMatrix[tBlackBoss[1]+i*(-1)^m][tBlackBoss[2]+j*(-1)^(m+1)] ==11 then 
							local tCur = {x=tBlackBoss[1]+i*(-1)^m,y=tBlackBoss[2]+j*(-1)^(m+1)}
							local tTar = {x=tBlackBoss[1],y=tBlackBoss[2]}
							if this:CanGo(11,tCur,tTar) == true then 
								return true 
							end
						end
					end

					if tRedBoss[1]+i*(-1)^m >0 and tRedBoss[1]+i*(-1)^m <10 and tRedBoss[2]+j*(-1)^m >0 and tRedBoss[2]+j*(-1)^m <9 then
						if this.CurrentChessMatrix[tRedBoss[1]+i*(-1)^m][tRedBoss[2]+j*(-1)^m] == 19 then 
							local tCur = {x=tRedBoss[1]+i*(-1)^m,y=tRedBoss[2]+j*(-1)^m}
							local tTar = {x=tRedBoss[1],y=tRedBoss[2]}
							if this:CanGo(19,tCur,tTar) == true then 
								return true 
							end
						end
					end
					if tRedBoss[1]+i*(-1)^m >0 and tRedBoss[1]+i*(-1)^m<10 and tRedBoss[2]+j*(-1)^(m+1) >0 and tRedBoss[2]+j*(-1)^(m+1) <9   then
						if  this.CurrentChessMatrix[tRedBoss[1]+i*(-1)^m][tRedBoss[2]+j*(-1)^(m+1)] ==19 then 
							local tCur = {x=tRedBoss[1]+i*(-1)^m,y=tRedBoss[2]+j*(-1)^(m+1)}
							local tTar = {x=tRedBoss[1],y=tRedBoss[2]}
							if this:CanGo(19,tCur,tTar) == true then 
								return true 
							end
						end
					end
				end
			end
		end 
	end
	return  false 
end
--
function this:CheckScale(pCurRole,pCurPos)
	local tCanGoArr = {}
	local tTargetPos = {}
	if pCurRole ==8 or pCurRole==16 then
		-- 只能走一步
		for i=1,2 do
			if i==2 then 
				tTargetPos = {}
				tTargetPos.x =pCurPos.x -1 
				tTargetPos.y = pCurPos.y
				if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
					table.insert(tCanGoArr,tTargetPos)
				end
				tTargetPos = {}
				tTargetPos.x =pCurPos.x  
				tTargetPos.y = pCurPos.y-1
				if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
					table.insert(tCanGoArr,tTargetPos)
				end
			else
				tTargetPos = {}
				tTargetPos.x =pCurPos.x +1 
				tTargetPos.y = pCurPos.y
				if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
					table.insert(tCanGoArr,tTargetPos)
				end
				tTargetPos = {}
				tTargetPos.x =pCurPos.x  
				tTargetPos.y = pCurPos.y +1
				if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
					table.insert(tCanGoArr,tTargetPos)
				end
			end
		end

		
		return tCanGoArr

	elseif pCurRole == 9 or pCurRole ==17 then 
	  --仕
		tTargetPos = {} 
		tTargetPos.x = pCurPos.x +1
		tTargetPos.y = pCurPos.y+1
		if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
			table.insert(tCanGoArr,tTargetPos)
		end 
		tTargetPos = {} 
		tTargetPos.x = pCurPos.x-1
		tTargetPos.y = pCurPos.y+1
		if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
			table.insert(tCanGoArr,tTargetPos)
		end 
		tTargetPos = {} 
		tTargetPos.x = pCurPos.x +1
		tTargetPos.y = pCurPos.y-1
		if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
			table.insert(tCanGoArr,tTargetPos)
		end 
		tTargetPos = {} 
		tTargetPos.x = pCurPos.x -1
		tTargetPos.y = pCurPos.y-1
		if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
			table.insert(tCanGoArr,tTargetPos)
		end 
		
	  	return tCanGoArr
	elseif pCurRole == 12 or pCurRole == 20 then 
		--车 

		for i=1,10 do 
			tTargetPos = {}
			tTargetPos.x = i
			tTargetPos.y = pCurPos.y
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then
				table.insert(tCanGoArr,tTargetPos)
			end
		end


		for i=1,9 do 
			tTargetPos = {}
			tTargetPos.x = pCurPos.x
			tTargetPos.y = i
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then
				table.insert(tCanGoArr,tTargetPos)
			end
		end

		
		return tCanGoArr 
	elseif pCurRole ==14 or pCurRole ==22 then
			--兵 
		if pCurPos.x >1 then 
			tTargetPos = {}
			tTargetPos.x =pCurPos.x -1 
			tTargetPos.y = pCurPos.y
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
				table.insert(tCanGoArr,tTargetPos)
			end
		end
		if pCurPos.y >1 then 
			tTargetPos = {}
			tTargetPos.x =pCurPos.x  
			tTargetPos.y = pCurPos.y-1
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
				table.insert(tCanGoArr,tTargetPos)
			end
		end
		tTargetPos = {}
		tTargetPos.x =pCurPos.x  
		tTargetPos.y = pCurPos.y + 1
		if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
			table.insert(tCanGoArr,tTargetPos)
		end

		return tCanGoArr
	elseif pCurRole == 10 or pCurRole == 18 then 
		--相

		tTargetPos = {}
		tTargetPos.x = pCurPos.x +2
		tTargetPos.y = pCurPos.y +2

		if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
			table.insert(tCanGoArr,tTargetPos)
		end
		if pCurPos.x >2 then 
			tTargetPos = {}
			tTargetPos.x = pCurPos.x -2
			tTargetPos.y = pCurPos.y +2
			
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
				table.insert(tCanGoArr,tTargetPos)
			end
			if pCurPos.y>2 then 
				tTargetPos = {}
				tTargetPos.x = pCurPos.x -2
				tTargetPos.y = pCurPos.y -2
				if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
					table.insert(tCanGoArr,tTargetPos)
				end
			end
		end
		if pCurPos.y>2 then 
			tTargetPos = {}
			tTargetPos.x = pCurPos.x +2
			tTargetPos.y = pCurPos.y -2
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
				table.insert(tCanGoArr,tTargetPos)
			end
		end


		return tCanGoArr 
	elseif pCurRole == 11 or pCurRole == 19 then 
		--马 
		tTargetPos = {}
		tTargetPos.x = pCurPos.x +2
		tTargetPos.y = pCurPos.y +1
		if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
			table.insert(tCanGoArr,tTargetPos)
		end
		
		if pCurPos.y>1 then 
			tTargetPos = {}
			tTargetPos.x = pCurPos.x +2
			tTargetPos.y = pCurPos.y -1
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
				table.insert(tCanGoArr,tTargetPos)
			end
			if pCurPos.x >2 then 
				tTargetPos = {}
				tTargetPos.x = pCurPos.x -2
				tTargetPos.y = pCurPos.y -1
				if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
					table.insert(tCanGoArr,tTargetPos)
				end
			end
		end
		if pCurPos.x >2 then
			tTargetPos = {}
			tTargetPos.x = pCurPos.x -2
			tTargetPos.y = pCurPos.y +1
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
				table.insert(tCanGoArr,tTargetPos)
			end
		end
		if pCurPos.x >1 then
			if pCurPos.y>2 then 
				tTargetPos = {}
				tTargetPos.x = pCurPos.x -1
				tTargetPos.y = pCurPos.y -2
				if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
					table.insert(tCanGoArr,tTargetPos)
				end

			end
			tTargetPos = {}
			tTargetPos.x = pCurPos.x -1
			tTargetPos.y = pCurPos.y +2
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
				table.insert(tCanGoArr,tTargetPos)
			end
		end
		if pCurPos.y >2 then 
			tTargetPos = {}
			tTargetPos.x = pCurPos.x +1
			tTargetPos.y = pCurPos.y -2
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
				table.insert(tCanGoArr,tTargetPos)
			end
		end
		tTargetPos = {}
		tTargetPos.x = pCurPos.x +1
		tTargetPos.y = pCurPos.y +2
		if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then 
			table.insert(tCanGoArr,tTargetPos)
		end

		return tCanGoArr
		
	elseif pCurRole ==13 or pCurRole ==21 then 
		--炮
		for i=1,10 do 
			tTargetPos = {}
			tTargetPos.x = i
			tTargetPos.y = pCurPos.y
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then
				table.insert(tCanGoArr,tTargetPos)
			end
		end
		for i=1,9 do 
			tTargetPos = {}
			tTargetPos.x = pCurPos.x
			tTargetPos.y = i
			if this:CanGo(pCurRole,pCurPos,tTargetPos) == true then
				table.insert(tCanGoArr,tTargetPos)
			end
		end 
		return tCanGoArr
	end
	return tCanGoArr
end


function this:ItemAni(pObj,pRole,pUpAndDown)

	local tAni = pObj.transform:FindChild("ChessRole").gameObject:GetComponent('UISpriteAnimation')
	tAni.namePrefix = this:AnimationName(pRole,pUpAndDown) 
	tAni.enabled=true
	tAni:ResetToBeginning(); 
	tAni:Play();
	tAni:playWithCallback(Util.packActionLua(function (self)
			tAni.enabled=false
			if pUpAndDown ~= 1 then 
				pObj.transform:FindChild("ChessRole").gameObject:GetComponent('UISprite').spriteName = 'qizi_'..pRole
				pObj.transform:FindChild("ChessRole").gameObject:GetComponent('UISprite'):MakePixelPerfect();
			end
		
	end,self)) 

	tRoleAni = pObj:GetComponent('UISpriteAnimation')
	tRoleAni.namePrefix = this:AnimationName(0,pUpAndDown) 
	tRoleAni.enabled=true
	tRoleAni:ResetToBeginning(); 
	tRoleAni:Play();
	tRoleAni:playWithCallback(Util.packActionLua(function (self)
			tRoleAni.enabled=false
			if pUpAndDown ~= 1 then 
				pObj:GetComponent('UISprite').spriteName = 'qizi_BG'
				pObj:GetComponent('UISprite'):MakePixelPerfect();
			end
	end,self)) 
end


--1提子  2落子  3吃子
-- 红方：帥8 仕9相10 馬11車12 砲13兵14
-- 黑方：將16 士17象18 馬19車20 炮21卒22

function this:AnimationName (pRole , pUpAndDown )
	local tTitle = ''
	if pRole == 0 then
		if pUpAndDown ==1 then 
		 	tTitle= 'qizi00'
		elseif pUpAndDown ==2 then 
		 	tTitle = 'luozi00'
		elseif pUpAndDown ==3 then 
			tTitle ='chizi00'
		end
		return tTitle
	end
	
	if pRole >15 then 
		tTitle = 'B'
	else
		tTitle = 'R'
	end
	if pUpAndDown == 2 then 
		tTitle = tTitle..'L'
	elseif pUpAndDown ==3 then 
		tTitle = tTitle ..'C'
	end
	if pRole ==8 then
		tTitle = tTitle..'shuai'
	elseif pRole ==9 or pRole == 17 then
		tTitle = tTitle..'shi'
	elseif pRole ==10 or pRole ==18 then  
		tTitle = tTitle..'xiang'
	elseif pRole==11 or pRole ==19 then 
		tTitle = tTitle .. 'ma'
	elseif pRole==12 or pRole ==20  then 
		tTitle = tTitle .. 'che'
	elseif pRole==13 or pRole ==21 then 
		tTitle = tTitle .. 'pao'
	elseif pRole == 14 then
		tTitle = tTitle .. 'bing'
	elseif pRole == 22 then 
		tTitle = tTitle .. 'zu'	
	elseif pRole == 16 then 
		tTitle = tTitle .. 'jiang'
	end

	if pUpAndDown == 1 then
		tTitle = tTitle .. '00'
	elseif pUpAndDown ==2 then 
		tTitle = tTitle .. '00'	
	elseif pUpAndDown ==3 then
		tTitle = tTitle .. '00'
	end
	return tTitle
end


function this:ChangeMusic()
	if  this.musicOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName == "On" then
		this.musicOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName = "Off" 
		this.musicOn.transform:FindChild("Thumb").localPosition = Vector3.New(-90,0,0)
		this.mxSettBGBar = 0
		
	elseif this.musicOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName == "Off" then
		this.musicOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName = "On"
		this.musicOn.transform:FindChild("Thumb").localPosition = Vector3.New(90,0,0)
		this.mxSettBGBar =1
	end
	SettingInfo.Instance.bgVolume = this.mxSettBGBar
	UISoundManager.Instance.BGVolumeSet(this.mxSettBGBar);
end
function this:ChangeYinxiao()
	if this.yinxiaoOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName == "On"  then
		this.yinxiaoOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName = "Off" 
		this.yinxiaoOn.transform:FindChild("Thumb").localPosition = Vector3.New(-90,0,0)
		this.mxSettEFBar = 0
	elseif  this.yinxiaoOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName == "Off" then
		this.yinxiaoOn.transform:FindChild("Foreground").gameObject:GetComponent('UISprite').spriteName = "On" 
		this.yinxiaoOn.transform:FindChild("Thumb").localPosition = Vector3.New(90,0,0)
		this.mxSettEFBar = 1
	end
	UISoundManager._EFVolume =this.mxSettEFBar;
	SettingInfo.Instance.effectVolume =this.mxSettEFBar
end

function this:OnDisable()
	this:clearLuaValue()
end