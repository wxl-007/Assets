
MainCtrl = {};
local self = MainCtrl;

local transform;
local gameObject;


--构建函数--
function MainCtrl.New()
	return self;
end

function MainCtrl.Awake()
	self.BankPanel = nil 
	self.RankPanel = nil
	self.EmailPanel = nil 
	self.SettingPanel = nil 
	self.TaskPanel = nil
	self.ExplainPanel = nil
	self.payPanel = nil
	self.headInfoPanel = nil
	self.personInfoPanel = nil
	self.shopPanel = nil
	self.noticePanel = nil
	self.recordPanel = nil 

	LRDDZ_ResourceManager.Instance:CreatePanel('HomePanel','HomePanel', true,function(obj)
		-- local player = LRDDZ_PanelManager:LoadAsset("StandPlayer"..Avatar.getAvatarSex(),"StandPlayer",false)
		-- player.transform.parent = obj.transform
		-- player.transform.localScale = Vector3.New(1,1,1)		
		LRDDZ_ResourceManager.Instance:Create3DOjbect("StandPlayer"..Avatar.getAvatarSex(),"StandPlayer"..Avatar.getAvatarSex(), "StandPlayer",Vector3.New(1,1,1),Vector3.New(-1000,0,0), true,function(obj)end,obj)	
	end);

end
--打开个人信息面板
function MainCtrl.OpenpersonInfoPanel()
	if self.personInfoPanel == nil then 
		LRDDZ_ResourceManager.Instance:CreatePanel('personInfoPanel','personInfoPanel', true,function(obj)
			self.personInfoPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.personInfoPanel:SetActive(true)
	end 	
end
--打开头像面板
function  MainCtrl.OpenheadInfoPanel()
	if self.headInfoPanel == nil then 
		LRDDZ_ResourceManager.Instance:CreatePanel('headInfoPanel','headInfoPanel', true,function(obj)
			self.headInfoPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.headInfoPanel:SetActive(true)
	end 
end 
--打开银行卡面板
function  MainCtrl.OpenBankPanel()
	if self.BankPanel == nil then 
		LRDDZ_ResourceManager.Instance:CreatePanel('BankPanel','BankPanel', true,function(obj)
			self.BankPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.BankPanel:SetActive(true)
	end 
end 
--打开排行榜面板
function MainCtrl.OpenRankPanel()
	if self.RankPanel == nil then 
		LRDDZ_ResourceManager.InstanceCreatePanel('RankPanel','RankPanel', true,function(obj)
			self.RankPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.RankPanel:SetActive(true)
	end 
end 
--打开邮件系统
function MainCtrl.OpenEmailPanel()
	if self.EmailPanel == nil then 
		LRDDZ_ResourceManager.Instance:CreatePanel('EmailPanel','EmailPanel', true,function(obj)
			self.EmailPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.EmailPanel:SetActive(true)
	end 
end 
--打开系统设置
function MainCtrl.OpenSettingPanel()
	if self.SettingPanel == nil then 
		LRDDZ_ResourceManager.Instance:CreatePanel('SettingPanel','SettingPanel', true,function(obj)
			self.SettingPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.SettingPanel:SetActive(true)
	end 
end 
--打开任务
function MainCtrl.OpenTaskPanel()
	if self.TaskPanel == nil then 
		LRDDZ_ResourceManager.Instance:CreatePanel('TaskPanel','TaskPanel', true,function(obj)
			self.TaskPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.TaskPanel:SetActive(true)
	end 
end 
--打开说明
function MainCtrl.OpenExplainPanel()
	if self.ExplainPanel == nil then 
		LRDDZ_ResourceManager.Instance:CreatePanel('ExplainPanel','ExplainPanel', true,function(obj)
			self.ExplainPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.ExplainPanel:SetActive(true)
	end 
end  
--打开充值
function MainCtrl.OpenPayPanel()
	if self.payPanel == nil then 
		LRDDZ_ResourceManager.Instance:CreatePanel('PayPanel','PayPanel', true,function(obj)
			self.payPanel = obj
			obj:SetActive(true);
		end);
	else 
		self.payPanel:SetActive(true)
	end 
end 
--打开商场
function MainCtrl.OpenShopPanel()
	if self.shopPanel == nil then
		LRDDZ_ResourceManager.Instance:CreatePanel("ShopPanel","ShopPanel",true,function(obj)
			self.shopPanel = obj
			obj:SetActive(true);
			end);
	else
		self.shopPanel:SetActive(true);
	end
end
--打开公告
function MainCtrl.OpenNoticePanel()
	if self.noticePanel == nil then
		LRDDZ_ResourceManager.Instance:CreatePanel("NoticePanel","NoticePanel",true,function(obj)
			self.noticePanel = obj
			obj:SetActive(true);
		end);
	else
		self.noticePanel:SetActive(true);
	end
end
function MainCtrl.OpenRecordPanel()
	if self.recordPanel == nil then
		LRDDZ_ResourceManager.Instance:CreatePanel("RecordPanel","RecordPanel",true,function(obj)
			self.recordPanel = obj
			obj:SetActive(true);
		end)
	else
		self.recordPanel:SetActive(true);
	end
end
local openPanels = {}
function MainCtrl.ShopPanel(obj)
	table.insert(openPanels,obj);
	obj:SetActive(true);
end
function MainCtrl.HidePanel(obj)
	iTableRemove(openPanels,obj)
	obj:SetActive(false);
end
function MainCtrl.Clear()
	self.BankPanel = nil 
	self.RankPanel = nil 
	self.EmailPanel = nil 
	self.SettingPanel = nil 
	self.TaskPanel = nil
	self.ExplainPanel = nil
	self.payPanel = nil
	self.shopPanel = nil
	self.noticePanel = nil
	self.recordPanel = nil 
end 

