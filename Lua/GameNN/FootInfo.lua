
local this = LuaObject:New()
FootInfo = this


local spriteAvatar = nil
local labelNickname = nil
local labelBagmoney = nil
local labelLv = nil

function this:clearLuaValue()
	
	this.mono = nil
	this.gameObject = nil
	this.transform = nil
	this.AvatarPrefix = nil;
	 spriteAvatar= nil
	labelNickname = nil
	labelBagmoney = nil
	labelLv = nil
		
	LuaGC();
end

function this:Init()
	print("FootInfo Init")
	--this.sliderBgVolume = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_bgmusic/Slider").gameObject:GetComponent("UISlider")
	--this.sliderEffectVolume = this.transform:FindChild("Sprite_popup_container/Label_setting/Label_bgsound/Slider").gameObject:GetComponent("UISlider")
	this.AvatarPrefix = "avatar_"
	if this.transform:FindChild('Foot - Anchor/Info/Sprite_Avatar') == nil then
		spriteAvatar = this.transform:FindChild("Foot - Anchor/Info/Panel/Sprite_Avatar").gameObject:GetComponent("UISprite")
	else 
		spriteAvatar = this.transform:FindChild("Foot - Anchor/Info/Sprite_Avatar").gameObject:GetComponent("UISprite")
	end
	labelNickname = this.transform:FindChild("Foot - Anchor/Info/Label_Nickname").gameObject:GetComponent("UILabel")
	labelBagmoney = this.transform:FindChild("Foot - Anchor/Info/Money/Label_Bagmoney").gameObject:GetComponent("UILabel")
	labelLv = this.transform:FindChild("Foot - Anchor/Info/Level/Label_Level").gameObject:GetComponent("UILabel")
	
	--local scoreBtn = this.transform:FindChild("firstView/fenBtn").gameObject
	--this.mono:AddClick(scoreBtn, this.OnClickList)
	
end
function this:Awake()
	this:Init()
	
	--[[
	local sceneRoot = this.transform.root:GetComponent("UIRoot")
 	if sceneRoot ~= nil then
  		sceneRoot.manualHeight = 800;
  		sceneRoot.manualWidth  = 1422;
 	end
	]]
end

function this:Start()
	spriteAvatar.spriteName = this.AvatarPrefix .. EginUser.Instance.avatarNo
	labelNickname.text = EginUser.Instance.nickname

	if ( LengthUTF8String(labelNickname.text)>5 )then
		labelNickname.text = SubUTF8String(labelNickname.text,15) .. "..."
	end
	
	this:UpdateIntomoney(EginUser.Instance.bagMoney)
	labelLv.text = tostring(EginUser.Instance.level)

end

function this:OnDestroy()
	this:clearLuaValue()
end

function this:UpdateIntomoney( intoMoney )
	if(intoMoney)then
		--labelBagmoney.text = EginTools.NumberAddComma (intoMoney)
		labelBagmoney.text = EginTools.HuanSuanMoney (intoMoney)
	end
end
function this:UpdateIntomoneyString( intoMoney )
	if(intoMoney)then
		labelBagmoney.text = intoMoney
	end
end



