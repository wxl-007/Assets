personInfoPanel ={}
local self = personInfoPanel
function personInfoPanel.Awake(obj)
	self.gameObject = obj.gameObject
	self.transform = obj.transform
	self.Init()
end
function personInfoPanel.Init()
	self.behaviour = self.gameObject:GetComponent('LRDDZ_LuaBehaviour');

	self.headiconBtn = self.transform:FindChild("personInfo/headicon").gameObject
	self.backBtn = self.transform:FindChild("backBtn").gameObject
	self.sexicon = self.transform:FindChild("personInfo/sex").gameObject
	self.biBtn = self.transform:FindChild("personInfo/biBtn").gameObject
	self.name = self.transform:FindChild("personInfo/name").gameObject;

	if Avatar.avatarSex ==1 then
		self.sexicon:GetComponent('UISprite').spriteName = "nan"
	elseif Avatar.avatarSex ==2 then
		self.sexicon:GetComponent('UISprite').spriteName = "nv"
	end
	--self.headiconBtn:GetComponent('UISprite').spriteName = Avatar.getAvatarIcon();
	self.behaviour:AddClick(self.headiconBtn,self.headiconBtnCallBack)
	self.behaviour:AddClick(self.backBtn,self.backBtnCallBack)
	self.behaviour:AddClick(self.biBtn,self.biBtnCallBack)
	personInfoPanel.UpdateNickName();
end

function personInfoPanel.headiconBtnCallBack()
	MainCtrl.OpenheadInfoPanel()
end

function personInfoPanel.backBtnCallBack()
	self.gameObject:SetActive(false)
	HomePanel.moneyPanel:SetActive(false);
end
function personInfoPanel.biBtnCallBack()	
	--发送改名消息
	if self.name:GetComponent("UIInput").value ~= "" then
		coroutine.start(self.OnClickChangeNickname,self.name:GetComponent("UIInput").value);
 	else
 		
 		print("名字不能为空");
 	end
	--Avatar.avatarName = self.name:GetComponent('UILabel').text
	--HomePanel.namelabel:GetComponent("UILabel").text = Avatar.avatarName
end
function personInfoPanel.UpdateNickName()
	Avatar.avatarName = EginUser.Instance.nickname;
	HomePanel.namelabel:GetComponent("UILabel").text = Avatar.avatarName;
	self.name:GetComponent("UILabel").text = Avatar.avatarName;
	self.headiconBtn:GetComponent('UISprite').spriteName = Avatar.getAvatarIcon();
end
function personInfoPanel.OnClickChangeNickname(_nickname )
	if _nickname ~= nil then
		print(_nickname);
		local form = UnityEngine.WWWForm.New();
		form:AddField("nickname",_nickname);
		local  www = HttpConnect.Instance:HttpRequestWithSession(ConnectDefine.USERINFO_NICKNAME_URL,form);
		coroutine.www(www);
		local result = HttpConnect.Instance:BaseResult(www);
		if result.resultType == HttpResult.ResultType.Sucess then
			personInfoPanel.UpdateNickNameSucess(_nickname,10000);
			--更新
			self.UpdateNickName();
		else
			print(result.resultObject);
		end
	end
end
 function personInfoPanel.UpdateNickNameSucess( nickname,expense )	
 	print("UpdateNickNameSucess");
 	EginUser.Instance:UpdateNickName(nickname,expense);


 end

