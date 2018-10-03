local this = LuaObject:New()
Panel_Explain = this

local fishTable = {};
local gunTable = {};

local item_fish;
local item_weapon;

local vFish_normal;
local vFish_special;
local vFish_king;
local vGun;

local btn_close;

local btn_teshu;
local btn_yuwang;
local btn_wuqi;

function this.OnEnable()
    -- body
    --if Global.instance.isMobile == false then
    --    UIHelper.On_UI_Show(this.gameObject);
    --end
end

function this.Start()
	--Lua_UIHelper.UIShow(this.gameObject);
	this.InitPanel();
	this.LoadFishList("0");
	--this.LoadGunList();
    if Global.instance.isMobile == true then
        this.transform:Find("Content 4/tabs").gameObject:SetActive(false);
    end
end

--初始化面板--
function this.InitPanel()
	item_fish = this.transform:Find("Item_fish").gameObject;
    item_weapon = this.transform:Find("Item_weapon").gameObject;
    --item_fish = PoolDefine.getPrefab("Item_fish");
    --item_weapon = PoolDefine.getPrefab("Item_weapon");

    vFish_normal = this.transform:Find("Content 1/Container/Panel/Grid");
    vFish_special = this.transform:Find("Content 1/Container (1)/Panel/Grid");
    vFish_king = this.transform:Find("Content 1/Container (2)/Panel/Grid");
    vGun = this.transform:Find("Content 2/Container/Panel/Grid");

    btn_teshu = this.transform:Find("Content 1/tabs/Tab 22").gameObject;
    btn_yuwang = this.transform:Find("Content 1/tabs/Tab 33").gameObject;
    btn_wuqi = this.transform:Find("left/Tabs/tab 2").gameObject;
    this.mono:AddClick(btn_teshu,this.btnClick);
    this.mono:AddClick(btn_yuwang,this.btnClick);
    this.mono:AddClick(btn_wuqi,this.btnClick);

    btn_close = this.transform:FindChild("Button_close").gameObject;
    this.mono:AddClick(btn_close,this.Hide);
end

function this.LoadFishList(index)
	for k,v in Lua_UIHelper.pairsByKeys(ConfigData.GetFishTextureData(nil)) do
		local fishInfo = v;

		local go = nil;
        if fishInfo.Cassify == index then
    		if fishInfo.Cassify == "0" then
                local vParent = vFish_normal;
                go = GameObject.Instantiate(item_fish);
                go.transform.parent = vParent;
                local board = go.transform:Find("Sprite_ban"):GetComponent("UISprite");
    			board.spriteName = "pu_t";
    		elseif fishInfo.Cassify == "1" then
    			local vParent = vFish_special;
                go = GameObject.Instantiate(item_fish);
                go.transform.parent = vParent;
                local board = go.transform:Find("Sprite_ban"):GetComponent("UISprite");
                board.spriteName = index;
                local star = go.transform:FindChild("star1");
                if star ~= nil then
                    star.gameObject:SetActive(true);
                end
            elseif fishInfo.Cassify == "2" then
    			local vParent = vFish_king;
                go = GameObject.Instantiate(item_fish);
                go.transform.parent = vParent;
                local board = go.transform:Find("Sprite_ban"):GetComponent("UISprite");
                board.spriteName = "yu_w";
                local star = go.transform:FindChild("star2");
                if star ~= nil then
                    star.gameObject:SetActive(true);
                end
            end
        end
        if go ~= nil then
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;

            local fishimg = go.transform:Find("Sprite_Fish"):GetComponent("UISprite");
            fishimg.spriteName = fishInfo.Name;
            fishimg.width = fishInfo.width;
            fishimg.height = fishInfo.height;
            go.transform:Find("Label_name"):GetComponent("UILabel").text = fishInfo.Name;
            go.transform:Find("label_price"):GetComponent("UILabel").text = "×"..fishInfo.Rate;
            go.transform:Find("Label_des"):GetComponent("UILabel").text = fishInfo.Desc;

            go:SetActive(true);
        end
	end
    if index == "0" then
	   vFish_normal:GetComponent("UIGrid").repositionNow = true;
    elseif index == "1" then
        vFish_special:GetComponent("UIGrid").repositionNow = true;
    elseif index == "2" then
        vFish_king:GetComponent("UIGrid").repositionNow = true;
    end
end

function this.LoadGunList()
    for k,v in Lua_UIHelper.pairsByKeys(ConfigData.GetWeaponTextureData(nil)) do
        local gunInfo = v;
        local go = GameObject.Instantiate(item_weapon);
        go.transform.parent = vGun.transform;
        go.transform.localPosition = Vector3.zero;
        go.transform.localScale = Vector3.one;

        local gunimg = go.transform:Find("Sprite_weapon"):GetComponent("UISprite");
        gunimg.spriteName = gunInfo.Name;
        gunimg.width = gunInfo.width;
        gunimg.height = gunInfo.height;
        go.transform:Find("Label_name"):GetComponent("UILabel").text = gunInfo.Name;
        go.transform:Find("Label_des"):GetComponent("UILabel").text = gunInfo.Desc;
    
        go:SetActive(true);
    end
    vGun:GetComponent("UIGrid").repositionNow = true;
end

function this.Hide()
	--Lua_UIHelper.UIHide(this.gameObject,true);
    --if Global.instance.isMobile == false then
    --    Panel_Follow.HidePanel(this.gameObject);
    --else
        this.gameObject:SetActive(false);
    --end
end

function this.btnClick( go )
    -- body
    if go.name == btn_teshu.name then
        if vFish_special.childCount == 0 then
            this.LoadFishList("1");
        end
    elseif go.name == btn_yuwang.name then
        if vFish_king.childCount == 0 then
            this.LoadFishList("2");
        end
    elseif go.name == btn_wuqi.name then
        if vGun.childCount == 0 then
            this.LoadGunList();
        end
    end
end