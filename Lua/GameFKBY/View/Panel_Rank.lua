local this = LuaObject:New()
Panel_Rank = this
local go_rankCell;
local grid;
local btnClose;

local cellTable = {};
require "GameFKBY/Lua_UIHelper";
local cjson = require "cjson"

--启动事件--
function this.Awake()
	--this.gameObject = obj;
	--this.transform = obj.transform;

	this.InitPanel();

	
	--warn("Awake lua--->>"..gameObject.name);
end
function this.OnEnable()
    -- body
    --if Global.instance.isMobile == false then
    --    UIHelper.On_UI_Show(this.gameObject);
    --end
	coroutine.start(this.LoadRankInfo);
end

function this.LoadRankInfo()
	-- body
	UIHelper.ShowProgressHUD(nil,"");
	local  www = HttpConnect.Instance:HttpRequestWithSession(FKBYConnectDefine.HANDSEL_RANK_URL,nil);
	coroutine.www(www);
	print(www.text);
	local js = cjson.decode(www.text);
	local data = {};
	if(js["result"] == "ok") then
		local body = js["body"]["ranking"];
		for i=1,#body do
			local _nickName = body[i][1];
			local _money = body[i][2];
			local _uid = body[i][3];
			local _avatarNo = body[i][4];
			data[i] = {nickName = _nickName,money = _money,uid = _uid,avatarNo = _avatarNo};
		end
	end
	this.CreatCell(data);
	UIHelper.HideProgressHUD();
	
end

--初始化面板--
function this.InitPanel()
	btnClose = this.transform:FindChild("Button_close").gameObject;
	this.mono:AddClick(btnClose, this.OnHide);
	go_rankCell = this.transform:FindChild("Scroll View/rank_cell").gameObject;
	grid = this.transform:FindChild("Scroll View/Grid"):GetComponent("UIGrid");
	--this.CreatCell();
end
function this.CreatCell(data) --data [i] = {nickName ,money ,uid,avatarNo };
	-- body
	print(#data);
	for i=1,#data do
		local clone = NGUITools.AddChild(grid.gameObject,go_rankCell);
		local _ranking = clone.transform:FindChild("ranking"):GetComponent("UISprite");
		local _icon = clone.transform:FindChild("Sprite_icon"):GetComponent("UISprite");
		local _name = clone.transform:FindChild("player"):GetComponent("UILabel");
		local _score = clone.transform:FindChild("score"):GetComponent("UILabel");
		local _lb_rank = clone.transform:FindChild("Label-rank"):GetComponent("UILabel");
		--设置排名
		if i > 3 then
			_ranking.gameObject:SetActive(false);
			_lb_rank.text = v.rank;
		else
			if i == 1 then
				_ranking.spriteName = "pai_m_01";
			elseif i == 2 then
				_ranking.spriteName = "2-nd";
			elseif i == 3 then
				_ranking.spriteName = "3-nd";	
			end
			_ranking.gameObject:SetActive(true);
			_lb_rank.text = "";
		end


		_icon.spriteName = "avatar_"..data[i].avatarNo;
		_name.text = data[i].nickName;
		_score.text =math.floor(data[i].money);
		clone:SetActive(true);
	end
	grid.repositionNow = true;

end
function  this.Start()
	-- body
		--this.OnShow();
end

--单击事件--
function this.OnDestroy()
	warn("OnDestroy---->>>");
end
function this.OnClose(go)
	-- body
	destroy(this.gameObject);
end
function this.OnShow()
	-- body
	Lua_UIHelper.UIShow(this.gameObject);
end
function this.OnHide()
	-- body
	--Lua_UIHelper.UIHide(this.gameObject,true);
	--if Global.instance.isMobile == false then
	--	Panel_Follow.HidePanel(this.gameObject);
	--else
		this.gameObject:SetActive(false);
	--end
end