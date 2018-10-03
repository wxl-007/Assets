local this = LuaObject:New()
Panel_Vip = this;

local button_close;
local button_pay;
local button_selectPay;
local lb_curLv;
local lb_nextLv;
local lb_desc;
local progressBar;
local go_cell;
local grid;
function this.Awake()
	this.InitPanel();
end
function this.Start()
	-- body
	--Lua_UIHelper.UIShow(this.gameObject);
end
--初始化面板--
function this.InitPanel()
	button_close = this.transform:FindChild("Button_close").gameObject;
	button_pay = this.transform:FindChild("Button_Pay").gameObject;
	lb_curLv = this.transform:FindChild("Label-vip"):GetComponent("UILabel");
	lb_nextLv = this.transform:FindChild("Label-next_vip"):GetComponent("UILabel");
	lb_desc = this.transform:FindChild("Label-desc"):GetComponent("UILabel");
	go_cell = this.transform:FindChild("ScrollView/cell").gameObject;
	grid = this.transform:FindChild("ScrollView/Grid"):GetComponent("UIGrid");
	progressBar = this.transform:FindChild("ProgressBar"):GetComponent("UIProgressBar");
	button_selectPay = GameObject.Find("UI Root/Panel_Select/Options_bottom/Button_recharge");
	this.mono:AddClick(button_close,this.OnClose);
	this.mono:AddClick(button_pay,this.OnPay);
	this.InitInfo();
	this.CreatCell();
end
function this.CreatCell()
	-- body
	for k,v in Lua_UIHelper.pairsByKeys(ConfigData.VipData()) do 
		local clone = NGUITools.AddChild(grid.gameObject,go_cell);
		local lb_lv = clone.transform:FindChild("Label-lv"):GetComponent("UILabel");
		local sp_icon = clone.transform:FindChild("Sprite-icon"):GetComponent("UISprite");
		local lb_payNum = clone.transform:FindChild("Label-num"):GetComponent("UILabel");
		local label_desc = clone.transform:FindChild("Label-lock"):GetComponent("UILabel");
		local label_desc2 = clone.transform:FindChild("Label-lock2"):GetComponent("UILabel");
		local label_name = clone.transform:FindChild("Label-name"):GetComponent("UILabel");

		lb_lv.text = "VIP"..k;
		sp_icon.spriteName = v.GunName;
		label_name.text = v.GunName;
		sp_icon:MakePixelPerfect();
		lb_payNum.text = string.format("累计充值%d元",v.PayNum);
		local str =string.split(v.Function,"/");
		label_desc.text = str[1];
		label_desc2.text = str[2];

		clone:SetActive(true);
	end
	grid.repositionNow = true;
end
function this.InitInfo()
	local curLv = EginUser.Instance.vipLevel;
	local curCoin = tonumber(EginUser.Instance.goldCoin);
	print("充值的人民币："..curCoin);
	local nextLv = curLv;
	local needCoin = 0;
	lb_curLv.text = "VIP"..curLv;

	if curLv < #ConfigData.VipData() then nextLv = nextLv + 1; end
	needCoin = ConfigData.VipData(nextLv).PayNum;
	lb_nextLv.text = "VIP"..nextLv;
	progressBar.value = curCoin/needCoin;
	print(needCoin..":"..curCoin);
	if needCoin < curCoin then 
		print("<");
		needCoin = 0;
	else
		print(">");
		needCoin = needCoin - curCoin;
	end
	lb_desc.text = string.format("再充值%d元即可升级VIP%d，高级VIP可享受低级VIP的全部特权。",needCoin,nextLv);
end
function this.OnClose( )
	--Lua_UIHelper.UIHide(this.gameObject,true);
	Panel_Follow.HidePanel(this.gameObject);
end
function this.OnPay( )
	-- body
	--暂定 待改
	--Panel_Follow.AddRecPanel(this.gameObject);
	button_selectPay:SendMessage("OnClick");
	this.gameObject:SetActive(false);
	--destroy(this.gameObject);
end