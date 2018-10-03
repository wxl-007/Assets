local this = LuaObject:New()
Panel_Personal = this
local cjson = require "cjson"

local button_icon;
local button_nickName;
local button_OK;
local button_canel;
local button_add;
local button_closeIcon;
local nickName;
local id;
local lv;
local holdCoin;
local holdCoin2;
local bankSave;
local inputNickName;
local kAvatarPrefab;
local vGrid;
local sprite_icon = {};
local panel_icon;
local panel_nickName;

local button_close;

function this.Awake(  )
	this.InitPanel();
end

function this.Start(  )
	
	this.mono:AddClick(button_icon,this.ButtonPersonalHandle);
	this.mono:AddClick(button_nickName,this.ButtonPersonalHandle);
	this.mono:AddClick(button_add,this.ButtonPersonalHandle);
	this.mono:AddClick(button_close,this.ButtonPersonalHandle);
end
function this.InitPanel(  )
	button_icon = this.transform:FindChild("box1/button_icon").gameObject;
	button_nickName = this.transform:FindChild("box1/Button_nickName").gameObject;
	button_OK = this.transform:FindChild("Panel_nickname/Button_OK").gameObject;
	button_canel = this.transform:FindChild("Panel_nickname/Button_close2").gameObject;
	button_add = this.transform:FindChild("box4/Button_add").gameObject;
	button_closeIcon = this.transform:FindChild("Panel_icon/Button_close2").gameObject;
	nickName = this.transform:FindChild("box1/NickName"):GetComponent("UILabel");
	id = this.transform:FindChild("box1/id"):GetComponent("UILabel");
	lv = this.transform:FindChild("box2/Lv"):GetComponent("UILabel");
	holdCoin = this.transform:FindChild("box3/coin/HoldCoin"):GetComponent("UILabel");
	holdCoin2 = this.transform:FindChild("box4/COIN"):GetComponent("UILabel");
	bankSave = this.transform:FindChild("box3/bank/BankSave"):GetComponent("UILabel");
	inputNickName = this.transform:FindChild("Panel_nickname/Control - Simple Input Field"):GetComponent("UIInput");
	kAvatarPrefab = this.transform:FindChild("Panel_icon/Container/Scroll View/avatar").gameObject;
	vGrid = this.transform:FindChild("Panel_icon/Container/Scroll View/vIcon"):GetComponent("UIGrid");
	sprite_icon[1] = this.transform:FindChild("box1/button_icon"):GetComponent("UISprite");
	panel_icon = this.transform:FindChild("Panel_icon").gameObject;
	panel_nickName = this.transform:FindChild("Panel_nickname").gameObject;
	button_close = this.transform:FindChild("Button_close").gameObject;
end
function this.OnEnable(  )
	sprite_icon[2] = this.getIconSprite();
	this.UpdateUserinfo();
    --if Global.instance.isMobile == false then
    --    UIHelper.On_UI_Show(this.gameObject);
    --end
end
function this.UpdateUserinfo(  )
	local user = EginUser.Instance;
	nickName.text = user.nickname;
	id.text = "ID:"..user.uid;
	lv.text = "Lv."..user.level;
	holdCoin.text = UIHelper.SetCoinStandard(user.bagMoney);
	holdCoin2.text = UIHelper.SetCoinStandard(user.bagMoney);
	bankSave.text = UIHelper.SetCoinStandard(user.bankMoney);
	for i=1,#sprite_icon do
		if user.avatarNo < 1 then user.avatarNo = 1;end
		sprite_icon[i].spriteName = "avatar_"..user.avatarNo;
	end
end

function this.OnClickChangeNickname( go,_nickname )
	if _nickname ~= nil then
		UIHelper.ShowProgressHUD(nil,"");
		local form = UnityEngine.WWWForm.New();
		form:AddField("nickname",_nickname);
		local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.USERINFO_NICKNAME_URL,form);
		coroutine.www(www);
		UIHelper.HideProgressHUD();
		local js = cjson.decode(www.text);
		if type(js) == "number" then 
			UIHelper.ShowMessage(js,2);
			return;
		end
		if js["result"] == "ok" then
			this.UpdateNickNameSucess(_nickname,10000);
			local user = EginUser.Instance;
			nickName.text = user.nickname;
			holdCoin.text = user.bagMoney;
			Panel_Follow.UpdateInfo();
			Panel_Follow.HidePanel(panel_nickName,go);
			UIHelper.ShowMessage("操作成功",2);
		else
			UIHelper.ShowMessage(js["body"],2);
		end
	end
end
function this.OnClickUpdateAvatar( selectedObject )
	-- body
	if selectedObject ~= nil then
		UIHelper.ShowProgressHUD(nil,"");
        local aid = selectedObject.gameObject.name;
        local form = UnityEngine.WWWForm.New();
		form:AddField("aid",aid);
		local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.USERINFO_AVATAR_URL,form);
		coroutine.www(www);
		UIHelper.HideProgressHUD();
		local js = cjson.decode(www.text);
		if js["result"] == "ok" then
			local _sprite = selectedObject:GetComponent("UISprite").spriteName;
			for i=1,#sprite_icon do
				sprite_icon[i].spriteName = _sprite;
			end
			Panel_Follow.HidePanel(panel_icon);
			this.UpdateAvatarSucess(aid);
			UIHelper.ShowMessage("操作成功",2);
		else
			UIHelper.ShowMessage(js["body"],2);
		end
	end
end
function this.LoadAvatars(  )
	EginTools.ClearChildren(vGrid.transform);
	for i=1,16 do
		local avatar = GameObject.Instantiate(kAvatarPrefab);
		avatar.name = i;
		avatar.transform.parent = vGrid.transform;
		avatar.transform.localPosition = Vector3.zero;
		avatar.transform.localScale = Vector3.one;
		avatar:SetActive(true);
		this.mono:AddClick(avatar,this.ButtonIconHandle);
		local sprite = avatar.transform:GetComponent("UISprite");
		sprite.spriteName = "avatar_"..i;
		sprite:MakePixelPerfect();
	end
	vGrid.repositionNow = true;
end
function this.UpdateAvatarSucess( aid )
 	-- body
 	EginUser.Instance:UpdateAvatarNo(tonumber(aid));
 end 
 function this.UpdateNickNameSucess( nickname,expense )	
 	EginUser.Instance:UpdateNickName(nickname,expense);
 end
 function this.ButtonPersonalHandle( go )
 	-- body
 	AudioHelper.getInstance():PlayOnClickAudio("onClick");
 	if button_icon.name == go.name then
 		panel_icon:SetActive(true);
 		UIHelper.On_UI_Show(panel_icon);
 		this.LoadAvatars();
 		this.mono:AddClick(button_closeIcon,this.ButtonIconHandle);
	elseif button_nickName.name == go.name then
		panel_nickName:SetActive(true);
 		UIHelper.On_UI_Show(panel_nickName);
 		if inputNickName.value ~= "" then
 			inputNickName.value = "";
 		end
 		this.mono:AddClick(button_OK,this.ButtonNickNameHandle);
 		this.mono:AddClick(button_canel,this.ButtonNickNameHandle);
	elseif button_add.name == go.name then
 		Panel_Follow.ShowShopPanel();	
 	elseif button_close.name == go.name then
 		--if Global.instance.isMobile == false then
 		--	Panel_Follow.HidePanel(this.gameObject);
 		--else
 			this.gameObject:SetActive(false);
 		--end
 	end
 end
 function this.ButtonNickNameHandle( go )
 	AudioHelper.getInstance():PlayOnClickAudio("onClick");
 	if button_OK.name == go.name then
 		if inputNickName.value ~= "" then
			coroutine.start(this.OnClickChangeNickname,go,inputNickName.value);
 		else
 			UIHelper.ShowMessage("昵称不能为空",2);
 		end
 	elseif button_canel.name == go.name then 
 		Panel_Follow.HidePanel(panel_nickName);
 	end
 end

 function this.ButtonIconHandle( go )
 	AudioHelper.getInstance():PlayOnClickAudio("onClick");
 	if button_closeIcon.name == go.name then
 		Panel_Follow.HidePanel(panel_icon);
 	else
 		coroutine.start(this.OnClickUpdateAvatar,go);
 	end
 end

 function this.getIconSprite( ... )
 	-- body
 	if GameObject.Find("FKBY_Select") ~= nil then
 		return GameObject.Find("UI Root/Panel_Select/uInfos/Avatar/Panel/Sprite_icon"):GetComponent("UISprite");
 	elseif UnityEngine.GameObject.Find("FKBY_Game") ~= nil then
		return GameObject.Find("UI Root/Panel_Game/Panel_Other/uInfos/Avatar/Panel/Sprite_icon"):GetComponent("UISprite");
 	elseif UnityEngine.GameObject.Find("FKBY_GameFarm") ~= nil then
		return GameObject.Find("UI Root/Panel_Game/uInfos/Avatar/Panel/Sprite_icon"):GetComponent("UISprite");
 	end
 end