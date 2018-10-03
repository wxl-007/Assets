headInfoPanel ={}
local self = headInfoPanel

local recSelect = 1;
function headInfoPanel.Awake(obj)
	self.gameObject = obj
	self.transform = obj.transform
	self.Init()
end
function headInfoPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');

	self.OKBtn = self.transform:FindChild("headInfo/OKBtn").gameObject

	self.CloseBtn = self.transform:FindChild("backBtn").gameObject;
	for i=1,8 do
		local str = "headInfo/manlist/"..i
		local icon = self.transform:FindChild(str).gameObject	
		icon:GetComponent("UISprite").spriteName = "nan_"..i
		self.behaviour:AddClick(icon,self.SelectCallBack)
	end
	for i = 1,8 do 
		local str = "headInfo/wonanlist/"..(i+20)
		local icon = self.transform:FindChild(str).gameObject	
		icon:GetComponent("UISprite").spriteName = "nv_"..i
		self.behaviour:AddClick(icon,self.SelectCallBack)
	end

	self.behaviour:AddClick(self.OKBtn,self.OKBtnCallBack)
	self.behaviour:AddClick(self.CloseBtn,function() self.gameObject:SetActive(false) end)
end

function headInfoPanel.OKBtnCallBack()
	--[[
	HomePanel.headicon:GetComponent("UISprite").spriteName = Avatar.avatarIcon
	personInfoPanel.headiconBtn:GetComponent("UISprite").spriteName = Avatar.avatarIcon
	personInfoPanel.headiconBtn:GetComponent("UIButton").normalSprite = Avatar.avatarIcon
	self.gameObject:SetActive(false)
	]]
	--发送更换头像消息
	coroutine.start(headInfoPanel.DoOnClickUpdateAvatar);
end
function headInfoPanel.Select(index)
	--Avatar.avatarIcon = self.itemList[index]:GetComponent("UISprite").spriteName
	recSelect = index;
	self.OKBtnCallBack();
end
function headInfoPanel.SelectCallBack(go)
	local  id = 1;
	if go.transform.parent.name == "manlist" then
		id = go.name * 2;
	else
		id = (tonumber(go.name) - 20) * 2 - 1;
	end
	self.Select(id);
end
function headInfoPanel.DoOnClickUpdateAvatar() 
		local aid = recSelect;
		print(aid);
		local form = UnityEngine.WWWForm.New();
		form:AddField("aid", aid);
		local www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.USERINFO_AVATAR_URL, form);
		coroutine.www(www);
		
		local result = HttpConnect.Instance:BaseResult(www);
		if(HttpResult.ResultType.Sucess == result.resultType)  then
			headInfoPanel.UpdateAvatarSucess(aid);
			print("HttpConnectSucess");
		else 
			print(tostring(result.resultObject:ToString()));
		end
end

function headInfoPanel.UpdateAvatarSucess (aid) 
	EginUser.Instance:UpdateAvatarNo(tonumber(aid));
	Avatar.avatarIcon = EginUser.Instance.avatarNo;
	--更新
	HomePanel.headicon:GetComponent("UISprite").spriteName = Avatar.getAvatarIcon();
	personInfoPanel.headiconBtn:GetComponent("UISprite").spriteName = Avatar.getAvatarIcon()
	personInfoPanel.headiconBtn:GetComponent("UIButton").normalSprite = Avatar.getAvatarIcon()
	self.gameObject:SetActive(false)
end
