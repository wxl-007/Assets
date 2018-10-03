Avatar = {} 
local self = Avatar

--初始化
function Avatar.Init()
	if EginUser.Instance.uid ~= "" then
		self.avatarId = EginUser.Instance.uid      --角色Id
		self.avatarName = EginUser.Instance.nickname		   --角色名字
		self.avatarLevel = EginUser.Instance.level		   --等级
		        -- 1 表示男 2 表示女
		if EginUser.Instance.avatarNo%2 == 0 then 
			self.avatarSex = 1;
		else
			self.avatarSex = 2;
		end
		self.avatarGold = EginUser.Instance.bagMoney           --金币
		self.avatarIcon = EginUser.Instance.avatarNo;
	else
		self.avatarId = 1;
		self.avatarName = "游客1";
		self.avatarLevel = 1;
		self.avatarSex = 1;
	end
	--self.Register_Server()
end 
--初始化服务器接口
function Avatar.Register_Server()
	Network.register_server_message_dispatch("S2C_FINISH_LOGIN_LOGIC_RESPOND", Avatar.S2C_FINISH_LOGIN_LOGIC_RESPOND)
	Network.register_server_message_dispatch("S2C_GET_AVATAR_BASE_INFO_RESPOND", Avatar.S2C_GET_AVATAR_BASE_INFO_RESPOND)
end 
function Avatar.whenLoginLogicServerSuccess()
	--获取基本数据信息
	Network.send_server_message("C2S_GET_AVATAR_BASE_INFO_REQUEST")
end 
function Avatar.S2C_FINISH_LOGIN_LOGIC_RESPOND(param_dict)
	--登录完成

end 
function Avatar.S2C_GET_AVATAR_BASE_INFO_RESPOND(param_dict)
	Avatar.avatarId = param_dict.avatarid
	Avatar.avatarName = param_dict.name
	Avatar.avatarLevel = param_dict.level
	Avatar.avatarExp = param_dict.exp
	Avatar.avatarGold = param_dict.gold
	Avatar.avatarPhysical = param_dict.physical
	Avatar.avatarJewel = param_dict.jewel
	Avatar.avatarCrystal = param_dict.crystal
end

function Avatar.getAvatarId()
	return self.avatarId 
end 
function Avatar.getAvatarName()
	return self.avatarName
end 
function  Avatar.getAvatarSex()
	return self.avatarSex
end
function Avatar.getAvatarIcon()
	local icon = "";
	if EginUser.Instance.avatarNo%2 == 0 then 
		icon = "nan_"..EginUser.Instance.avatarNo /2;
	else
		icon = "nv_"..math.floor(EginUser.Instance.avatarNo /2) +1;
	end
	return icon;
end
function Avatar.getAvatarIconIndex()
	iconIndex = 1;
	if EginUser.Instance.avatarNo%2 == 0 then 
		iconIndex = EginUser.Instance.avatarNo /2;
	else
		iconIndex = math.floor(EginUser.Instance.avatarNo /2) +1;
	end
	return iconIndex;
end
function Avatar.setAvatarId(index)
	local id = 1;
	if avatarSex == 1 then --男
		id = index * 2;
	else
		--女
		id = index * 2 -1;
	end
	return id;
end