local cjson = require "cjson"
local this = LuaObject:New()
Module_Recharge = this


function this:Init()
	this.panel_other=this.transform:FindChild("Offset/Views/yinhang/panel_other").gameObject;--银行其他金额的显示界面
	this.panel_ZFB_other=this.transform:FindChild("Offset/Views/zfb/panel_other").gameObject;--支付宝其他金额的显示界面
	this.ZFB_cells=this.transform:FindChild("Offset/Views/zfb").gameObject;
	this.panel_ZFBSDK_other=this.transform:FindChild("Offset/Views/zfbSDK/panel_other").gameObject;--支付宝其他金额的显示界面
	this.ZFBSDK_cells=this.transform:FindChild("Offset/Views/zfbSDK").gameObject;
	this.panel_WXPay_other=this.transform:FindChild("Offset/Views/wxpay/panel_other").gameObject;--微信支付其他金额的显示界面
	this.WXPay_cells=this.transform:FindChild("Offset/Views/wxpay").gameObject;
	this.YH_cells=this.transform:FindChild("Offset/Views/yinhang/panel_cell").gameObject;
	this.kalei=this.transform:FindChild("Offset/Views/kalei").gameObject;-- 电话卡 其他卡类充值
	this.applePay=this.transform:FindChild("Offset/Options/Option_Apple").gameObject;	-- 苹果充值
	--this.GameFunction = nil;
	this.yhBL = 15000;
	this.zfbBL = 15000;
	this.zfbSDKBL = 15000;
	this.arrMon={10,20,30,50,100};--= [10,20,30,50,100];
	this.kaData={} ;
	this.oppTypes={};
	this.oppJinEs={};
end
function this:handleBtnsFunc() 
	this.mono:AddClick(this.transform:FindChild("Offset/Options/Option_3").gameObject, this.OnClickTXF,this)
 
	this.mono:AddClick(this.transform:FindChild("Offset/Options/Option_Apple/UISprite").gameObject, this.OnClickApplePay,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Options/Option_3_obsolete/Option_Apple/UISprite").gameObject, this.OnClickApplePay,this)
 
	this.mono:AddClick(this.transform:FindChild("Offset/Options/Option_3_obsolete/UISprite").gameObject, this.OnClickTXF,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/panel_cell/cell0/Button_buy").gameObject, this.OnClickYhBuy,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/panel_cell/cell1/Button_buy").gameObject, this.OnClickYhBuy,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/panel_cell/cell2/Button_buy").gameObject, this.OnClickYhBuy,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/panel_cell/cell3/Button_buy").gameObject, this.OnClickYhBuy,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/panel_cell/cell4/Button_buy").gameObject, this.OnClickYhBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/panel_cell/cell5/Button_buy").gameObject, function ( )
		this:OtherMoney('YH')
	end)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/panel_other/Button_buy").gameObject, this.OnClickYhBuy,this)
 
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/panel_other/shade_back").gameObject, this.OnClickRemoveOther,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/yinhang/Button_others").gameObject, this.OnClickYhOther,this)
 
	this.mono:AddClick(this.transform:FindChild("Offset/Views/kalei/Button_Submit").gameObject, this.OnClickKa,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/panel_cell/cellz0/Button_buy").gameObject, this.OnClickZFBBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/panel_cell/cellz1/Button_buy").gameObject, this.OnClickZFBBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/panel_cell/cellz2/Button_buy").gameObject, this.OnClickZFBBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/panel_cell/cellz3/Button_buy").gameObject, this.OnClickZFBBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/panel_cell/cellz4/Button_buy").gameObject, this.OnClickZFBBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/panel_cell/cellz5/Button_buy").gameObject, function (  )
		this:OtherMoney('ZFB')
	end)
 	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/panel_other/Button_buy").gameObject, this.OnClickZFBBuy,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/panel_other/shade_back").gameObject, this.OnClickRemoveZFBOther,this)
 
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfb/Button_others").gameObject, this.OnClickZFBOther,this)



	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/panel_cell/cellz0/Button_buy").gameObject, this.OnClickZFBSDKBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/panel_cell/cellz1/Button_buy").gameObject, this.OnClickZFBSDKBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/panel_cell/cellz2/Button_buy").gameObject, this.OnClickZFBSDKBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/panel_cell/cellz3/Button_buy").gameObject, this.OnClickZFBSDKBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/panel_cell/cellz4/Button_buy").gameObject, this.OnClickZFBSDKBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/panel_cell/cellz5/Button_buy").gameObject, function (  )
		this:OtherMoney('ZFBSDK')
	end)
 	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/panel_other/Button_buy").gameObject, this.OnClickZFBSDKBuy,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/panel_other/shade_back").gameObject, this.OnClickRemoveZFBSDKOther,this)
 
	this.mono:AddClick(this.transform:FindChild("Offset/Views/zfbSDK/Button_others").gameObject, this.OnClickZFBSDKOther,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/panel_cell/cellz0/Button_buy").gameObject, this.OnClickWXPayBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/panel_cell/cellz1/Button_buy").gameObject, this.OnClickWXPayBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/panel_cell/cellz2/Button_buy").gameObject, this.OnClickWXPayBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/panel_cell/cellz3/Button_buy").gameObject, this.OnClickWXPayBuy,this)
	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/panel_cell/cellz4/Button_buy").gameObject, this.OnClickWXPayBuy,this)
 	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/panel_cell/cellz5/Button_buy").gameObject,function ( )
 		this:OtherMoney('WeChat')
 	end)

	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/panel_other/Button_buy").gameObject, this.OnClickWXPayBuy,this)
	
	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/panel_other/shade_back").gameObject, this.OnClickRemoveZFBOther,this)
 
	this.mono:AddClick(this.transform:FindChild("Offset/Views/wxpay/Button_others").gameObject, this.OnClickWXPayOther,this)
 
	this.mono:AddClick(this.transform:FindChild("Offset/Background Top/Button_Back - Anchor/ImageButton").gameObject, this.OnClickBack,this)
	
	this.mono:AddInput(this.panel_other.transform:FindChild("Input_money").gameObject:GetComponent("UIInput"), this.onChangeText1)
	this.mono:AddInput(this.panel_ZFB_other.transform:FindChild("Input_money").gameObject:GetComponent("UIInput"), this.onChangeText2)
	this.mono:AddInput(this.panel_WXPay_other.transform:FindChild("Input_money").gameObject:GetComponent("UIInput"), this.onChangeText3)

end
function this:Awake()
	--初始化变量
	this:Init();
	--初始化监听函数
	this:handleBtnsFunc();

	-- ShowHallPanel(this.gameObject,true,nil,function ( )
	-- 	this.transform:FindChild('Black_Background').gameObject:SetActive(true)
	-- end)
end
function this:Start ()  
	
	this.panel_other:SetActive(false);
	this.panel_ZFB_other:SetActive(false);
	
	local sceneRoot = this.transform.root:GetComponent("UIRoot")	
	if sceneRoot then 	
		sceneRoot.manualHeight = 1920;	
		sceneRoot.manualWidth = 1080;	
	end	
	 	

	local Option_5 = this.transform:FindChild("Offset/Options/Option_5").gameObject;
	local Option_4 = this.transform:FindChild("Offset/Options/Option_4").gameObject;
	local Option_0 = this.transform:FindChild("Offset/Options/Option_0").gameObject;
	local Option_1 = this.transform:FindChild("Offset/Options/Option_1").gameObject;
	local Option_3 = this.transform:FindChild("Offset/Options/Option_3").gameObject;
		
	
	--支付宝支付
	if true then
		if (PlatformGameDefine.playform.PlatformName == "1977game2" or  PlatformGameDefine.playform.PlatformName == "game597") then
		
		else
			Option_5:SetActive(false);	
			Option_3.transform.localPosition = Option_1.transform.localPosition;
			Option_1.transform.localPosition = Option_0.transform.localPosition;
			Option_0.transform.localPosition = Option_4.transform.localPosition;
			Option_4.transform.localPosition = Option_5.transform.localPosition;
			
		end
	end

	if Utils._IsNoWeChat then
		--隐藏    
		Option_4:SetActive(false);	
		Option_3.transform.localPosition = Option_1.transform.localPosition;
		Option_1.transform.localPosition = Option_0.transform.localPosition;
		Option_0.transform.localPosition = Option_4.transform.localPosition; 
		
	end 
	local tBtnC = this.transform:FindChild('Offset/Options/Option_3').gameObject
	if(tostring(Utils.BUILDPLATFORM) == BuildPlatform.IOS_AppStore) then
		this.applePay:SetActive (true);  
		-- tBtnC.transform.localPosition = Vector3(737,261,0)
		tBtnC.transform:FindChild('UISprite').gameObject:GetComponent('UISprite').spriteName = 'SMSbtn'
		tBtnC.transform:FindChild('UISprite').gameObject:GetComponent('UISprite'):MakePixelPerfect()
		tBtnC.transform:FindChild('UILabel').gameObject:SetActive(false)
		this.applePay:GetComponent('UISprite').spriteName = "btn-IOSCharge"
		tBtnC:GetComponent('UIAnchor').enabled = true 
	else
		this.applePay:SetActive (false);
		tBtnC.transform.localPosition = Vector3(827,0,0)
		tBtnC.transform:FindChild('UILabel').gameObject:SetActive(true)
		tBtnC.transform:FindChild('UISprite').gameObject:GetComponent('UISprite').spriteName = 'pay01'
		tBtnC.transform:FindChild('UISprite').gameObject:GetComponent('UISprite'):MakePixelPerfect()
	end
	--[[if PlatformGameDefine.playform.IOSPayFlag == false then 
		this.applePay:SetActive (true);  
	else	
		this.applePay:SetActive (false);
	end ]]
	
	if  PlatformGameDefine.playform.IsSocketLobby then this.mono:StartSocket(false); end
	
	coroutine.start(this.loadBiLi,this ); 
	coroutine.start(this.UpdateInLua) 
end
function this:UpdateInLua() 
	while(this.mono) do
		 --this:Update();
		coroutine.wait(0.1)
	end
end
function this:clearLuaValue()
	this.mono = nil
	this.gameObject = nil
	this.transform  = nil

	
	this.panel_other=nil;--银行其他金额的显示界面
	this.panel_ZFB_other=nil;--支付宝其他金额的显示界面
	this.ZFB_cells=nil;
	this.panel_WXPay_other=nil;--微信支付其他金额的显示界面
	this.WXPay_cells=nil;
	this.YH_cells=nil;
	this.kalei=nil;-- 电话卡 其他卡类充值
	this.applePay=nil;	-- 苹果充值 
	this.yhBL = 15000;
	this.zfbBL = 15000;
	this.zfbSDKBL = 15000;
	this.GameFunction = nil;
	this.arrMon={};--= [10,20,30,50,100];
	this.kaData={} ;
	this.oppTypes={};
	this.oppJinEs={};
	
	
	LuaGC()
end

function this:OnDestroy()
	this:clearLuaValue()
end
function this:Process_account_login(info) 
end
function this:OnClickBack ()   
	if this.GameFunction ~= nil then
		this.GameFunction();
	else 
		-- this.mono:EginLoadLevel("Hall"); 
		this:ToPanel('Hall')
	end 
end
function this:OnClickWXPayOther ()    
end
function this:loadBiLi () 

	EginProgressHUD.Instance:ShowWaitHUD(ZPLocalization.Instance:Get("HttpConnectWait"),false);
	coroutine.wait(0)
	if PlatformGameDefine.playform.IsSocketLobby then
		this.mono:Request_lua_fun("AccountService/payrate_all","0", 
		function(message)  
			log(message)
			local messageObj = cjson.decode(message); 
			this.yhBL = tonumber(messageObj["shengpay"]);  
			this.zfbBL = tonumber(messageObj["alipay"]); 
			this.zfbSDKBL = this.zfbBL;
			this:ProcessPayrateCardsuit (messageObj["cardsuit"]) 
			 
		end, 
		function(message) 
			 EginProgressHUD.Instance:ShowPromptHUD(message);
		end)
		--[[
		 --1元RMB兑换嘿豆数量(盛付通)
		this.mono:Request_lua_fun("AccountService/payrate_shengpay","0", 
		function(message) 
			this.yhBL = tonumber(message);  
			
			--1元RMB兑换嘿豆数量(支付宝)
			this.mono:Request_lua_fun("AccountService/payrate_alipay","0", 
			function(message) 
				this.zfbBL = tonumber(message); 
				
				--支付配置数据
				this.mono:Request_lua_fun("AccountService/payrate_cardsuit","0", 
				function(message)
					local messageObj = cjson.decode(message); 
					this:ProcessPayrateCardsuit (messageObj) 
				end, 
				function(message) 
					 EginProgressHUD.Instance:ShowPromptHUD(message);
				end)
			end, 
			function(message) 
				 EginProgressHUD.Instance:ShowPromptHUD(message);
			end)
		end, 
		function(message) 
			 EginProgressHUD.Instance:ShowPromptHUD(message);
		end)
		]]
	else
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.BANK_BILI_URL, nil);
		coroutine.www(www);
			
		local result = HttpConnect.Instance:BaseResult(www);
		 
		if (HttpResult.ResultType.Sucess == result.resultType)  then
			this.yhBL = tonumber(result.resultObject:ToString());
		else 
			EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
		end

		--====================
		local www_zfb = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.ZFB_BILI_URL, nil);
		coroutine.www(www_zfb);
		local result_zfb = HttpConnect.Instance:BaseResult(www_zfb);
		
		if (HttpResult.ResultType.Sucess == result_zfb.resultType)  then
			this.zfbBL = tonumber(result_zfb.resultObject:ToString());
			this.zfbSDKBL = this.zfbBL;
		else 
			EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
		end
		  
		--====================
		local www_card = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.CARD_BILI_URL, nil);
		coroutine.www(www_card);
		
		local result_card = HttpConnect.Instance:BaseResult(www_card);
		
		if (HttpResult.ResultType.Sucess == result_card.resultType) then 
			this:InitOppTypes(cjson.decode(result_card.resultObject:ToString()));
		else 
			EginProgressHUD.Instance:ShowPromptHUD(result.resultObject);
		end 

		this:InitInterface ();
	end
	
	
end
  
function this:SocketDisconnect (disconnectInfo) 
	 
end

function this:InitInterface () 
	 EginProgressHUD.Instance:HideHUD();
	
	if(this.oppTypes ~= nil  and  #(this.oppTypes)>0) then
		local first_list = this.kalei.transform:FindChild("first_list"):GetComponent("UIPopupList");
		first_list:Clear();
		for  k=1,#this.oppTypes do
			local oneStr = this.oppTypes[k]
			first_list:AddItem(oneStr,k-1);
		end 
		 
		first_list.value = this.oppTypes[1];
		this.mono:AddPopupList(first_list,this.onFirstChange); 
		
		local second_list = this.kalei.transform:FindChild("second_list"):GetComponent("UIPopupList");

		local secondData = {} 
		local lidata =this.oppJinEs[1]
		for  k=1,#lidata do
			local onedata = lidata[k]
			local oneStr = onedata[2].."元="..onedata[3]..PlatformGameDefine.playform.UnityMoney;
			table.insert(secondData,oneStr);  
		end 
		second_list:Clear();
		for  k=1,#secondData do
			local oneStr = secondData[k]
			second_list:AddItem(oneStr,k-1);
		end  
		second_list.value = secondData[1]; 
	end
	
	for  i=0,4 do
		local ul = this.YH_cells.transform:FindChild("cell"..i).transform:FindChild("lebi").gameObject:GetComponent("UILabel");
		ul.text = this.arrMon[i+1]*this.yhBL..PlatformGameDefine.playform.UnityMoney;
	end

	for  i=0,4 do 
		local ul = this.ZFB_cells.transform:FindChild("panel_cell").transform:FindChild("cellz"..i).transform:FindChild("lebi"):GetComponent("UILabel");
		ul.text = this.arrMon[i+1]*this.zfbBL..PlatformGameDefine.playform.UnityMoney;
	end

	for  i=0,4 do 
		local ul = this.ZFBSDK_cells.transform:FindChild("panel_cell").transform:FindChild("cellz"..i).transform:FindChild("lebi"):GetComponent("UILabel");
		ul.text = this.arrMon[i+1]*this.zfbSDKBL..PlatformGameDefine.playform.UnityMoney;
	end

	if(this.WXPay_cells) then
		for  i = 0, 4 do 
			local ul = this.WXPay_cells.transform:FindChild("panel_cell").transform:FindChild("cellz".. i).transform:FindChild("lebi"):GetComponent("UILabel");
			ul.text = this.arrMon[i+1] * this.zfbBL ..PlatformGameDefine.playform.UnityMoney;
		end
	end
end
function this:ProcessPayrateCardsuit (messageObj)  
	this:InitOppTypes(messageObj);
	this:InitInterface () ;
end
function this:InitOppTypes (messageObj) 
	 this.kaData = messageObj;
	this.oppTypes = {};
	this.oppJinEs ={};
	print('********* list  ************')
	print(cjson.encode(messageObj))
	for  j=1,#(this.kaData) do 
		table.insert(this.oppTypes,tostring(this.kaData[j]["name"]));
		table.insert(this.oppJinEs,this.kaData[j]["suit"] ); 
		
	end  
end
function this:onFirstChange()
	local second_list = this.kalei.transform:FindChild("second_list"):GetComponent("UIPopupList");

	local idex = UIPopupList.current.data;

	local secondData = {};
	local lidata = this.oppJinEs[idex+1];
	for  k=1,#lidata do
		local onedata = lidata[k];
		local oneStr = onedata[2].."元="..onedata[3]..PlatformGameDefine.playform.UnityMoney;
		table.insert(secondData,oneStr); 
	end
	second_list:Clear();
	for  k=1,#secondData do
		local oneStr = secondData[k]
		second_list:AddItem(oneStr,k-1);
	end  
	second_list.value = secondData[1];
end

--=============手机卡  点卡 充值================================================
function this:OnClickKa () --点击了  电话卡/点卡  的确定
	local second_list = this.kalei.transform:FindChild("second_list"):GetComponent("UIPopupList");

	local first_list = this.kalei.transform:FindChild("first_list"):GetComponent("UIPopupList");

	local first_idex = first_list.data;
	local second_idex = second_list.data;

	local lidata = this.oppJinEs[first_idex+1];
	local onedata = lidata[second_idex+1];

	local urlpa =ConnectDefine.BANK_RECHARGE_URL.."?username="..this:EscapeUsername().."&money_amount="..onedata[2].."&bank_type_code="..this.kaData[first_idex+1]["code"];
 
	Application.OpenURL(urlpa);
end

--======================================================
function this:OnClickTXF()
	Application.OpenURL(ConnectDefine.TXF_RECHARGE_URL);
end

--=============苹果充值=========================================
function this:OnClickApplePay() 
	this.mono:EginLoadLevel("Module_Recharge_iOS");
end

--============银行充值==================================================================
function this:OnClickRemoveOther()
	this.panel_other:SetActive(false);
end

function this:OnClickYhOther () --点击了  银行的其他金额  的确定
	HallUtil:PopupSecondPanel(this.panel_other)
	-- this.panel_other:SetActive(true); 
end

function this:OnClickYhBuy (roomEntry) --点击了  银行购买   
	local money = 0;
	if (roomEntry.transform.parent.name == "panel_other") then 

		local ul = roomEntry.transform.parent.transform:FindChild ("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true) );
		local isnum = this:isDigitStr (ul.text);
		if (isnum) then
			this.panel_other:SetActive (false);
			money = tonumber (ul.text);
		end 
	else 
		if roomEntry.transform.parent.name == "cell0" then
			money = 10; 
		elseif  roomEntry.transform.parent.name == "cell1" then
			money = 20;
		elseif  roomEntry.transform.parent.name == "cell2" then
			money = 30;
		elseif  roomEntry.transform.parent.name == "cell3" then
			money = 50;
		elseif  roomEntry.transform.parent.name == "cell4" then
			money = 100;
		end 
	end

	if(money>0  and  EginUser.Instance.username~=nil  and  EginUser.Instance.username ~= "") then
--			local urlpa = ConnectDefine.BANK_RECHARGE_URL.."?username="..EginUser.Instance.username.."&money_amount="..money.."&bank_type_code=SHENGPAY-HTML5";
		local urlpa = ConnectDefine.BANK_RECHARGE_URL.."?username="..this:EscapeUsername().."&money_amount="..money.."&bank_type_code=YEEPAY1KEY";

		Application.OpenURL(urlpa);
	end
 
end
--================================================支付宝==================================
function this:OnClickRemoveZFBOther()
	this.panel_ZFB_other:SetActive(false);
end

function this:OnClickZFBOther () --点击了  银行的其他金额  的确定
	-- this.panel_ZFB_other:SetActive(true); 
	HallUtil:PopupSecondPanel(this.panel_ZFB_other)
end
function this:OnClickZFBBuy (roomEntry) --点击了  银行购买   
	local money = 0;
	if (roomEntry.transform.parent.name == "panel_other")  then
		
		local ul = roomEntry.transform.parent.transform:FindChild ("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true) );
		local isnum = this:isDigitStr (ul.text);
		if (isnum)  then
			this.panel_ZFB_other:SetActive (false);
			money = tonumber (ul.text);
		end 
	else 
		if roomEntry.transform.parent.name == "cellz0" then
			money = 10; 
		elseif  roomEntry.transform.parent.name == "cellz1" then
			money = 20;
		elseif  roomEntry.transform.parent.name == "cellz2" then
			money = 30;
		elseif  roomEntry.transform.parent.name == "cellz3" then
			money = 50;
		elseif  roomEntry.transform.parent.name == "cellz4" then
			money = 100;
		end  
	end
	if(money>0  and  EginUser.Instance.username~=nil  and  EginUser.Instance.username ~= "")  then
		local urlpa = ConnectDefine.BANK_RECHARGE_URL.."?username="..this:EscapeUsername().."&money_amount="..money.."&bank_type_code=ALIPAY"; 
		Application.OpenURL(urlpa);
	end
end
--================================================支付宝SDK==================================
function this:OnClickRemoveZFBSDKOther()
	this.panel_ZFBSDK_other:SetActive(false);
end

function this:OnClickZFBSDKOther () --点击了  银行的其他金额  的确定
	-- this.panel_ZFBSDK_other:SetActive(true); 
	HallUtil:PopupSecondPanel(this.panel_ZFBSDK_other)
end
function this:OnClickZFBSDKBuy (roomEntry) --点击了  银行购买   
	local money = 0;
	if (roomEntry.transform.parent.name == "panel_other")  then
		
		local ul = roomEntry.transform.parent.transform:FindChild ("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true) );
		local isnum = this:isDigitStr (ul.text);
		if (isnum)  then
			this.panel_ZFB_other:SetActive (false);
			money = tonumber (ul.text);
		end 
	else 
		if roomEntry.transform.parent.name == "cellz0" then
			money = 10; 
		elseif  roomEntry.transform.parent.name == "cellz1" then
			money = 20;
		elseif  roomEntry.transform.parent.name == "cellz2" then
			money = 30;
		elseif  roomEntry.transform.parent.name == "cellz3" then
			money = 50;
		elseif  roomEntry.transform.parent.name == "cellz4" then
			money = 100;
		end  
	end
	if money < 10 then
		EginProgressHUD.Instance:ShowPromptHUD("最低充值10元!"); 
		return;
	end
	if(money>0  and  EginUser.Instance.username~=nil  and  EginUser.Instance.username ~= "")  then
		 
		--local urlpa ="http://115.28.129.108/unity/pay/".."?username=".. EginUser.Instance.username .."&money_amount=".. money .."&bank_type_code=ALIPAYAPP";
		 
		local form =  UnityEngine.WWWForm.New();
		form:AddField("username", EginUser.Instance.username);
        form:AddField("money_amount", tonumber(money));
        form:AddField("bank_type_code", "ALIPAYAPP");
		 
		--115.28.129.108/unity/pay/?username=kkkk1231&money_amount=10&bank_type_code=ALIPAYAPP
		--ConnectDefine.BANK_RECHARGE_Ali_URL
		local urlpa = "http://115.28.129.108/unity/payment_confirm/";
		 print('jun : ~~~~~~~~~~~~~~~'..urlpa)
		 print('jun : ~~~BANK_RECHARGE_Ali_URL~~~~~~~~~~~~'..ConnectDefine.BANK_RECHARGE_Ali_URL)
		Utils.Request(this.mono,ConnectDefine.BANK_RECHARGE_Ali_URL,form,Util.packActionStringLua(
		function(self,jsonStr)
			local isbooltemp = string.find(jsonStr,"\"")
			if isbooltemp~=nil and isbooltemp==1 then
				jsonStr = string.sub(jsonStr,2,string.len(jsonStr)-1)  
			end
			log("jun:~~~~~~~~~"..jsonStr)
			local tempjsonMsg = {orderInfo = jsonStr,callbackGameObject = this.gameObject.name};
			
			AliPayUtil.OnAliPay(cjson.encode(tempjsonMsg)); 
			
			if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
				EginProgressHUD.Instance:ShowWaitHUD("请点击支付宝右上角 \"返回".. Application.productName .."\" 或者左上角 \"取消\"",false);
			else
				EginProgressHUD.Instance:ShowWaitHUD("正在跳转到支付宝...",false);
			end
		end,this),Util.packActionStringLua(function(self,result) 
			EginProgressHUD.Instance:ShowPromptHUD("网络连接失败"); 
		end,this));
	end
end

function this.OnAliPayCallback( message)
	  
	--message = "{\"resultStatus\":\\\"9000\",\"result\":\"{\"alipay_trade_app_pay_response\":{\"code\":\"10000\",\"msg\":\"Success\",\"app_id\":\"2016090701862162\",\"auth_app_id\":\"2016090701862162\",\"charset\":\"utf-8\",\"timestamp\":\"2017-01-16 17:54:46\",\"total_amount\":\"0.01\",\"trade_no\":\"2017011621001004880286425617\",\"seller_id\":\"2088421752241200\",\"out_trade_no\":\"011617542221384\"},\"sign\":\"DLN+IqHBuFtawiIiH+7kOA+3vKVJ20WCPRtdoDcvzbVKrgY+Dov5WDrEmvQFrRoHhd6jVvoXCvA1pWps\/vQsKLxU4a3DD6rTEki6qBPxrfOLZkdSEX\/YZW3fWVnoqw51JP0d6ndFUgaVnBYxrCDuHD2dnNWqcI\/ZIy5aEmGNmayJ4AozdDU\/l2hro0t7lgjkEhl+YOtEPtBeATmSAfb28qp67cron+zLegfOFYybPKuHBkV9gw3UmM6V8swxosreZDghDAHTjldu2MEBFTk79zS91aHs6kpjUkBDhOvgQGBVvcL01bwd+PJMXy+xzVRC8avfI+Gc+K4LspnRGyv0mg==\",\"sign_type\":\"RSA2\"}\",\"memo\":\"\"}"
	EginProgressHUD.Instance:HideHUD(); 
	print('jun : ~~~~~~~~~Lua~~~~~OnAliPayCallback = '..message) 
	local messageObj = cjson.decode(message);  
	if messageObj["resultStatus"] == "9000" then
		--支付成功 
		local resultMessageObj = cjson.decode(messageObj["result"]);  

		local form = UnityEngine.WWWForm.New();
		local pay_response = cjson.encode(resultMessageObj["alipay_trade_app_pay_response"]);
		form:AddField("alipay_trade_app_pay_response",pay_response); 
		log('jun : ~~~~~~~~~Lua~~~~~alipay_trade_app_pay_response = '..pay_response); 
		
		local urlpa = "http://115.28.129.108/account/alipayappreturn/";
		--ConnectDefine.BANK_RECHARGE_Ali_Confirm_URL
		Utils.Request(this.mono,ConnectDefine.BANK_RECHARGE_Ali_Confirm_URL, form,Util.packActionStringLua(function(self,jsonStr) 
			EginProgressHUD.Instance:ShowPromptHUD("支付成功"); 
		end,this),Util.packActionStringLua(function(self,result) 
			EginProgressHUD.Instance:ShowPromptHUD("支付验证失败"); 
		end,this));
	else
		if messageObj["memo"] == "" then
			EginProgressHUD.Instance:ShowPromptHUD("支付失败!"); 
		else
			EginProgressHUD.Instance:ShowPromptHUD(messageObj["memo"]); 
		end
		
	end
	 
	 
end
---------------end-----------------------
---------------微信支付-----------------
function this:OnClickWXPayBuy(roomEntry)--微信支付

	local money = 0;
	if (roomEntry.transform.parent.name == "panel_other") then
	 
		local ul = roomEntry.transform.parent.transform:FindChild("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true) );
		local isnum = this:isDigitStr(ul.text);
		if (isnum) then
		
			this.panel_WXPay_other:SetActive(false);
			money = tonumber(ul.text);
		end
	 else
		if roomEntry.transform.parent.name == "cellz0" then
			money = 10; 
		elseif  roomEntry.transform.parent.name == "cellz1" then
			money = 20;
		elseif  roomEntry.transform.parent.name == "cellz2" then
			money = 30;
		elseif  roomEntry.transform.parent.name == "cellz3" then
			money = 50;
		elseif  roomEntry.transform.parent.name == "cellz4" then
			money = 100;
		end   
	end
	if (money > 0  and  EginUser.Instance.username ~= nil  and  EginUser.Instance.username ~= "") then
	 
		local urlpa = ConnectDefine.BANK_RECHARGE_URL .."?username=".. EginUser.Instance.username .."&money_amount=".. money .."&bank_type_code=WECHATPAY";
		--local urlpa = "http://115.28.129.108/client_unity/payment_confirm/";
		--local urlpa = string.Format(PlatformGameDefine.playform.WXPayURL, EginUser.Instance.username, money); 
		 -- print('~~~~~~~'..urlpa)
		local form =  UnityEngine.WWWForm.New();
		form:AddField("username", EginUser.Instance.username);
        form:AddField("money_amount", tonumber(money));
        form:AddField("bank_type_code", "WECHATPAY");
		--如果是597就是用支付appid进行支付
		if (PlatformGameDefine.playform.PlatformName == "1977game2" or  PlatformGameDefine.playform.PlatformName == "game597") then
			form:AddField("appid", PlatformGameDefine.playform.WXPayAppId); 
			log(PlatformGameDefine.playform.WXPayAppId)
		else
			form:AddField("appid", PlatformGameDefine.playform.WXAppId);
		end 
		--,log("ConnectDefine.wx69b9a7a4bdd980b0BANK_RECHARGE_WX_URL = " .. ConnectDefine.BANK_RECHARGE_WX_URL .. ", PlatformGameDefine.playform.WXAppId = " .. PlatformGameDefine.playform.WXAppId)
		Utils.Request(this.mono,ConnectDefine.BANK_RECHARGE_WX_URL, form,Util.packActionStringLua(
		function(self,jsonStr)
			--jsonStr = "\"appid\":\"wxb4ba3c02aa476ea1\",\"noncestr\":\"3ed62e57e63cb94e9a304756c3a9dc89\",\"package\":\"Sign = WXPay\",\"partnerid\":\"10000100\",\"prepayid\":\"wx20160315160535a90139828f0655031675\",\"timestamp\":\"1458029135\",\"sign\":\"751E40311BC7502DA7C7416C4DFA64E7\"}";  
			WXPayUtil.OnWeChatPay(Util.packJSONObjectLua(jsonStr), this.gameObject.name); 
			
			if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
				EginProgressHUD.Instance:ShowWaitHUD("请点击微信右上角 \"返回".. Application.productName .."\" 或者左上角 \"取消\"",false);
			else
				EginProgressHUD.Instance:ShowWaitHUD("正在跳转到微信支付...",false);
			end
		end,this),Util.packActionStringLua(function(self,result) 
		end,this));
	end
end

function this.OnWechatPayCallback( message)
	 
	EginProgressHUD.Instance:HideHUD();
	if (message ~= "0") then  return; end
	 
	 local form = UnityEngine.WWWForm.New();
		form:AddField("out_trade_no", WXPayUtil.out_trade_no);
		--如果是597就是用支付appid进行支付
		if (PlatformGameDefine.playform.PlatformName == "1977game2" or  PlatformGameDefine.playform.PlatformName == "game597") then
			form:AddField("appid", PlatformGameDefine.playform.WXPayAppId);
			log(PlatformGameDefine.playform.WXPayAppId)
		else
			form:AddField("appid", PlatformGameDefine.playform.WXAppId);
		end  
                WXPayUtil.out_trade_no = ""; 
				--ConnectDefine.BANK_RECHARGE_WX_Confirm_URL
				--local urlpa = "http://115.28.129.108/client_unity/wechatmobile/orderquery/";
		
		Utils.Request(this.mono,ConnectDefine.BANK_RECHARGE_WX_Confirm_URL, form,Util.packActionStringLua(function(self,jsonStr)
			--jsonStr = "\"appid\":\"wxb4ba3c02aa476ea1\",\"noncestr\":\"3ed62e57e63cb94e9a304756c3a9dc89\",\"package\":\"Sign = WXPay\",\"partnerid\":\"10000100\",\"prepayid\":\"wx20160315160535a90139828f0655031675\",\"timestamp\":\"1458029135\",\"sign\":\"751E40311BC7502DA7C7416C4DFA64E7\"}";
			EginProgressHUD.Instance:ShowPromptHUD("支付成功"); 
		end,this),Util.packActionStringLua(function(self,result) 
		end,this));
	
	 
end

--========================================================================================================= 
 
function this:onChangeText1()  
	
	local ul =  this.panel_other.transform:FindChild("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true));
	if(ul ~= nil) then 
		local isnum = this:isDigitStr(ul.text);
		if(isnum) then 
			local lebi = this.panel_other.transform:FindChild("lebi"):GetComponentInChildren(Type.GetType("UILabel",true)); 
			if(lebi ~= nil) then 
				lebi.text = tonumber(ul.text)*this.yhBL..PlatformGameDefine.playform.UnityMoney; 
			end
		end 
	end
end

function this:onChangeText2()  
	local ul2 =  this.panel_ZFB_other.transform:FindChild("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true));
	if(ul2 ~= nil) then
		local isnum2 = this:isDigitStr(ul2.text);
		if(isnum2) then
			local lebi = this.panel_ZFB_other.transform:FindChild("lebi"):GetComponentInChildren(Type.GetType("UILabel",true));
			
			if(lebi ~= nil) then
				lebi.text = tonumber(ul2.text)*this.zfbBL..PlatformGameDefine.playform.UnityMoney;
			end
		end 
	end
end

function this:onChangeText3()  
	if (this.panel_WXPay_other) then
	
		ul2 = this.panel_WXPay_other.transform:FindChild("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true));
		if (ul2 ~= nil) then 
			local isnum2 = this:isDigitStr(ul2.text);
			if (isnum2) then 
				local lebi = this.panel_WXPay_other.transform:FindChild("lebi"):GetComponentInChildren(Type.GetType("UILabel",true)); 
				if (lebi ~= nil) then
					lebi.text = tonumber(ul2.text) * this.zfbBL ..PlatformGameDefine.playform.UnityMoney;
				end
			end 
		end
	end
end 

function this:Update()  

	if (Input.anyKeyDown) then  
		local ul =  this.panel_other.transform:FindChild("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true));
		if(ul ~= nil) then 
			local isnum = this:isDigitStr(ul.text);
			if(isnum) then 
				local lebi = this.panel_other.transform:FindChild("lebi"):GetComponentInChildren(Type.GetType("UILabel",true)); 
				if(lebi ~= nil) then 
					lebi.text = tonumber(ul.text)*this.yhBL..PlatformGameDefine.playform.UnityMoney; 
				end
			end

		end
	
		local ul2 =  this.panel_ZFB_other.transform:FindChild("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true));
		if(ul2 ~= nil) then
			local isnum2 = this:isDigitStr(ul2.text);
			if(isnum2) then
				local lebi = this.panel_ZFB_other.transform:FindChild("lebi"):GetComponentInChildren(Type.GetType("UILabel",true));
				
				if(lebi ~= nil) then
					lebi.text = tonumber(ul2.text)*this.zfbBL..PlatformGameDefine.playform.UnityMoney;
				end
			end 
		end

		if (this.panel_WXPay_other) then
		
			ul2 = this.panel_WXPay_other.transform:FindChild("Input_money").transform:GetComponentInChildren(Type.GetType("UILabel",true));
			if (ul2 ~= nil) then 
				local isnum2 = this:isDigitStr(ul2.text);
				if (isnum2) then 
					local lebi = this.panel_WXPay_other.transform:FindChild("lebi"):GetComponentInChildren(Type.GetType("UILabel",true)); 
					if (lebi ~= nil) then
						lebi.text = tonumber(ul2.text) * this.zfbBL ..PlatformGameDefine.playform.UnityMoney;
					end
				end 
			end
		end
	end
end
 
--	判断是不是数字
function this:isDigitStr( cstr)  
	
	if (nil == cstr )  then
		return false;  
	end   
	local tempNum = tonumber(cstr);
	if  type(tempNum) ~= "number" then 
		return false;  
	end
	
	 return true;  
end

--------------调用escapeurl 2 次, --------------------
--------------后台修改了,目前只转一次--------------------------
function this:EscapeURLTwoTimes(str)
	-- return UnityEngine.WWW.EscapeURL(UnityEngine.WWW.EscapeURL(str));
	return UnityEngine.WWW.EscapeURL(str);
	-- return str;
end

function this:EscapeUsername()
	return this:EscapeURLTwoTimes(EginUser.Instance.username);
end

function this:OtherMoney(pType)
	local pDia = this.transform:FindChild('Offset/Views/panel_other').gameObject
	-- pDia:SetActive(true)
	HallUtil:PopupSecondPanel(pDia)
	local tMoney = this.transform:FindChild('Offset/Views/panel_other/Input_money').gameObject:GetComponent('UIInput')
	-- this.mono:AddInput(tMoney, this.onChangeText1)
	local tButtonSure = this.transform:FindChild('Offset/Views/panel_other/Button_buy').gameObject
	local money = 0
	this.mono:AddClick(this.transform:FindChild('Offset/Views/panel_other/shade_back').gameObject,function ()
		pDia:SetActive(false)
	end)
	this.mono:AddClick(this.transform:FindChild('Offset/Views/panel_other/Button_Close').gameObject,function ()
		pDia:SetActive(false)
	end)
	local ul =tMoney.value
	local isnum = this:isDigitStr (ul);
	if (isnum)  then
		this.panel_ZFB_other:SetActive (false);
		money = tonumber (ul);
	end 
	this.mono:AddClick(tButtonSure,function ( )
		if pType == 'WeChat' then
			if (money > 0  and  EginUser.Instance.username ~= nil  and  EginUser.Instance.username ~= "") then
			 
				local urlpa = ConnectDefine.BANK_RECHARGE_URL .."?username=".. EginUser.Instance.username .."&money_amount=".. money .."&bank_type_code=WECHATPAY";
				local form =  UnityEngine.WWWForm.New();
				form:AddField("username", EginUser.Instance.username);
		        form:AddField("money_amount", tonumber(money));
		        form:AddField("bank_type_code", "WECHATPAY");
				--如果是597就是用支付appid进行支付
				if (PlatformGameDefine.playform.PlatformName == "1977game2" or  PlatformGameDefine.playform.PlatformName == "game597") then
					form:AddField("appid", PlatformGameDefine.playform.WXPayAppId); 
					log(PlatformGameDefine.playform.WXPayAppId)
				else
					form:AddField("appid", PlatformGameDefine.playform.WXAppId);
				end 
				Utils.Request(this.mono,ConnectDefine.BANK_RECHARGE_WX_URL, form,Util.packActionStringLua(
				function(self,jsonStr)
					WXPayUtil.OnWeChatPay(Util.packJSONObjectLua(jsonStr), this.gameObject.name); 
					
					if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
						EginProgressHUD.Instance:ShowWaitHUD("请点击微信右上角 \"返回".. Application.productName .."\" 或者左上角 \"取消\"",false);
					else
						EginProgressHUD.Instance:ShowWaitHUD("正在跳转到微信支付...",false);
					end
				end,this),Util.packActionStringLua(function(self,result) 
				end,this));
			end
		elseif pType=='ZFB' then 
		
			if(money>0  and  EginUser.Instance.username~=nil  and  EginUser.Instance.username ~= "")  then
				local urlpa = ConnectDefine.BANK_RECHARGE_URL.."?username="..this:EscapeUsername().."&money_amount="..money.."&bank_type_code=ALIPAY"; 
				Application.OpenURL(urlpa);
			end
		elseif pType == 'YH' then
		
			if(money>0  and  EginUser.Instance.username~=nil  and  EginUser.Instance.username ~= "") then
				local urlpa = ConnectDefine.BANK_RECHARGE_URL.."?username="..this:EscapeUsername().."&money_amount="..money.."&bank_type_code=YEEPAY1KEY";
				Application.OpenURL(urlpa);
			end

		elseif pType == 'ZFBSDK' then 
			if money < 10 then
				EginProgressHUD.Instance:ShowPromptHUD("最低充值10元!"); 
				return;
			end
			if (money > 0  and  EginUser.Instance.username ~= nil  and  EginUser.Instance.username ~= "") then
				local form =  UnityEngine.WWWForm.New();
				form:AddField("username", EginUser.Instance.username);
		        form:AddField("money_amount", tonumber(money));
		        form:AddField("bank_type_code", "ALIPAYAPP");
				local urlpa = "http://115.28.129.108/unity/payment_confirm/";
				Utils.Request(this.mono,ConnectDefine.BANK_RECHARGE_Ali_URL,form,Util.packActionStringLua(
				function(self,jsonStr)
					local isbooltemp = string.find(jsonStr,"\"")
					if isbooltemp~=nil and isbooltemp==1 then
						jsonStr = string.sub(jsonStr,2,string.len(jsonStr)-1)  
					end
					local tempjsonMsg = {orderInfo = jsonStr,callbackGameObject = this.gameObject.name};
					AliPayUtil.OnAliPay(cjson.encode(tempjsonMsg)); 
					if Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
						EginProgressHUD.Instance:ShowWaitHUD("请点击支付宝右上角 \"返回".. Application.productName .."\" 或者左上角 \"取消\"",false);
					else
						EginProgressHUD.Instance:ShowWaitHUD("正在跳转到支付宝...",false);
					end
				end,this),Util.packActionStringLua(function(self,result) 
					EginProgressHUD.Instance:ShowPromptHUD("网络连接失败"); 
				end,this));
			end
		end
	end)

end

function this:ToPanel(pTag )
	if pTag == 'Hall' then 
		local tObj = this.gameObject
		HallUtil:PopupPanel(pTag,false,tObj,nil)
	
	elseif pTag == 'Login' then 
		ShowHallPanel(this.gameObject,false,function ()
			EginProgressHUD.Instance:HideHUD()
			Utils.LoadAdditiveGameUI('Login',Vector3.New(0,2000,0))
			end,function (  )
				-- this.transform:FindChild('Offset/Black_Background').gameObject:SetActive(false)
		end)
	end

end
