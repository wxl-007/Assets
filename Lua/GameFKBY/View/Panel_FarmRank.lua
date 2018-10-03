local this = LuaObject:New();
Panel_FarmRank = this;

local go_rank;
local grid;
local button_close;
local scrollViewPanel;
local recRankItems = {};

--local rankData; --[rank] = {rank,nickName,avatarNo,sellNum}


function this.Awake()
	--this.gameObject = obj;
	--this.transform = obj.transform;
	print("Panel_FarmRank lua Awake");
	this.InitPanel();
end
function this.Start()
	-- body
	--Lua_UIHelper.UIShow(this.gameObject);
end
function this.OnEnable(  )
	this.LoadRankData();
end
--初始化面板--
function this.InitPanel()
	go_rank = this.transform:FindChild("Scroll View/tengfeiRank_cell").gameObject;
	grid = this.transform:FindChild("Scroll View/Grid"):GetComponent("UIGrid");
	button_close = this.transform:FindChild("Button_close").gameObject;
	scrollViewPanel = this.transform:FindChild("Scroll View"):GetComponent("UIPanel");
	this.mono:AddClick(button_close,this.Hide);
	--this.LoadRankData();
end
function this.LoadRankData()
	SocketMessage.SendGetFarmRankDataMessage();
end
function this.CreateCell(rankData)--rankData; --[rank] = {rank,nickName,avatarNo,sellNum}
	-- body
	for k,v in pairs(recRankItems) do 
		destroy(v);
	end
	recRankItems = {};
	scrollViewPanel.transform.localPosition = Vector3.zero;
	scrollViewPanel.clipOffset = Vector2.zero
	for k,v in Lua_UIHelper.pairsByKeys(rankData) do
		local clone = NGUITools.AddChild(grid.gameObject,go_rank);
		local _ranking = clone.transform:FindChild("ranking"):GetComponent("UISprite");
		local _icon = clone.transform:FindChild("Sprite_icon"):GetComponent("UISprite");
		local _name = clone.transform:FindChild("player"):GetComponent("UILabel");
		local _score = clone.transform:FindChild("score"):GetComponent("UILabel");
		local _lb_rank = clone.transform:FindChild("Label-rank"):GetComponent("UILabel");
		--设置排名
		if v.rank > 3 then
			_ranking.gameObject:SetActive(false);
			_lb_rank.text = v.rank;
		else
			if v.rank == 1 then
				_ranking.spriteName = "pai_m_01";
			elseif v.rank == 2 then
				_ranking.spriteName = "2-nd";
			elseif v.rank == 3 then
				_ranking.spriteName = "3-nd";	
			end
			_ranking.gameObject:SetActive(true);
			_lb_rank.text = "";
		end
		if v.avatarNo == 0 then v.avatarNo = 1 end
		_icon.spriteName = "avatar_"..v.avatarNo;
		_name.text = v.nickName;
		_score.text = v.sellNum;
		clone:SetActive(true);
		recRankItems[#recRankItems+1] = clone;
	end
	grid.repositionNow = true;
end
function this.Hide()
	--Lua_UIHelper.UIHide(this.gameObject,true);
	Panel_Follow.HidePanel(this.gameObject);
	for k,v in pairs(recRankItems) do 
		destroy(v);
	end
	recRankItems = {};
end