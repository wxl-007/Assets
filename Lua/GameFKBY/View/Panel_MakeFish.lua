local this = LuaObject:New()
Panel_MakeFish = this;

local particle;
local particle2;
local button_compund;
local button_close;
local lb_fishTotal;
local lb_diamondTotal;
local sp_compoundFish;
local sp_shadow;
local needItem = {};

local makeData;

local FishData = ConfigData.FishData();

function this.Awake()
	this.InitPanel();
end
function this.Start()
	-- body
	Lua_UIHelper.UIShow(this.gameObject);
end
function this.SetValue(data)
	-- body
	makeData = data;
end
--初始化面板--
function this.InitPanel()
	particle = this.transform:FindChild("Particle_MakeFish"):GetComponent("ParticleSystem");
	particle2 = this.transform:FindChild("Particle_MakeFish2"):GetComponent("ParticleSystem");
	button_compund = this.transform:FindChild("Button_ok").gameObject;
	button_close = this.transform:FindChild("Button_close").gameObject;
	this.mono:AddClick(button_compund,this.OnMake);
	this.mono:AddClick(button_close,this.Hide);
	lb_fishTotal = this.transform:FindChild("compound/left/count"):GetComponent("UILabel");
	lb_diamondTotal = this.transform:FindChild("compound/right/count"):GetComponent("UILabel");
	sp_compoundFish = this.transform:FindChild("compound/middle/fish"):GetComponent("UISprite");
	sp_shadow = this.transform:FindChild("compound/middle/fish-shadow"):GetComponent("UISprite");

	local need_icon = this.transform:FindChild("compound/left/Sprite-icon"):GetComponent("UISprite");
	local need_num = this.transform:FindChild("compound/left/use"):GetComponent("UILabel");

	needItem["NeedFish"] = {sp_icon = need_icon,lb_num = need_num};

	local diamond_icon = this.transform:FindChild("compound/right/Sprite-icon"):GetComponent("UISprite");
	local diamond_num = this.transform:FindChild("compound/right/use"):GetComponent("UILabel");

	needItem["NeedDiamond"] = {sp_icon = diamond_icon,lb_num = diamond_num};

	this.Init();
end
function this.Init()
	-- body
	needItem["NeedFish"].sp_icon.spriteName = FishData[makeData.NeedFishId].SpriteName;
	needItem["NeedFish"].sp_icon:MakePixelPerfect();
	needItem["NeedFish"].lb_num.text = makeData.NeedFishNum;
	needItem["NeedDiamond"].sp_icon.spriteName = "x_js";
	needItem["NeedDiamond"].lb_num.text = makeData.NeedDiamondNum;

	lb_fishTotal.text = LuaBagData.GetItemNumByItemId(makeData.NeedFishId);
	lb_diamondTotal.text = LuaBagData.GetDiamond();

	sp_shadow.spriteName =  FishData[makeData.MakeFishId].SpriteName;
	sp_compoundFish.spriteName = FishData[makeData.MakeFishId].SpriteName;

	sp_compoundFish:MakePixelPerfect();
    sp_shadow:MakePixelPerfect();
    sp_shadow.gameObject:SetActive(true);
    sp_compoundFish.gameObject:SetActive(false);
    particle.gameObject:SetActive(false);
    particle2.gameObject:SetActive(false);
end
function this.OnMake(go)
	print("makeFish");
	SocketMessage.SendCompFishMessage(makeData.NeedFishId);
	--SocketMessage.SendExchangeFish(makeData.NeedFishId,makeData.MakeFishId,1);
end
function this.Hide()
	-- body
	Lua_UIHelper.UIHide(this.gameObject,true);
end
function this.PlayAmin()
	UIHelper.MoveTween(needItem["NeedFish"].sp_icon.gameObject,sp_compoundFish.transform.position,0.9,false,0,DG.Tweening.Ease.Linear);
	UIHelper.MoveTween(needItem["NeedDiamond"].sp_icon.gameObject,sp_compoundFish.transform.position,0.9,false,0,DG.Tweening.Ease.Linear);
	particle.gameObject:SetActive(true);
	particle2.gameObject:SetActive(true);
	UIHelper.SetRenderQueue(particle.gameObject,4000);
	UIHelper.SetRenderQueue(particle2.gameObject,4000);
	--sp_shadow.gameObject:SetActive(false);
    --sp_compoundFish.gameObject:SetActive(true);
    coroutine.start(this.CompoundSucceed);
end
function this.CompoundSucceed(  )
	-- body
	coroutine.wait(1.5)
	sp_shadow.gameObject:SetActive(false);
	sp_compoundFish.gameObject:SetActive(true);
	needItem["NeedFish"].sp_icon.transform.localPosition = Vector3.zero;
	needItem["NeedDiamond"].sp_icon.transform.localPosition = Vector3.zero;
	coroutine.start(this.Reset);
end
function this.Reset()
	-- body
	coroutine.wait(3);
	this.Init();
end

function this.Update(  )
	-- body
	if(Input.GetKeyDown(KeyCode.T) == true) then
		this.PlayAmin();
	end
end