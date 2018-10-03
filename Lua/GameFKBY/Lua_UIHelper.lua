Lua_UIHelper ={};
local this = Lua_UIHelper;

function this.UIShow(obj)
	-- body
	--obj.transform.localScale = Vector3.New(1,1,1);
	--iTween.ScaleFrom(obj, iTween.Hash("scale",Vector3.New(0.8,0.8,0.8),"speed",0.4, "easeType", iTween.EaseType.easeOutElastic));

	--obj.transform.localScale = Vector3.New(1,1,1);
	--obj.transform.localScale = Vector3.New(0.9,0.9,0.9);
	--DG.Tweening.TweenExtensions.Restart(DG.Tweening.TweenSettingsExtensions.SetEase(DG.Tweening.ShortcutExtensions.DOScale(obj.transform, Vector3.New(1,1,1), 1.2), DG.Tweening.Ease.OutElastic), true);
	UIHelper.On_UI_Show(obj);

end
function this.UIHide(obj,isDestroy)
	-- body
	--[[
	iTween.ScaleTo(obj, iTween.Hash("sca/le",Vector3.New(0.8, 0.8, 0.8), "speed",1,"easeType", iTween.EaseType.easeInBack)); 
	if isDestroy == true then
		coroutine.start(this.Destroy,obj);
	end
	return 0.35;--返回动画播放的时间
	--]]
	UIHelper.On_UI_Hiden(obj);
	if isDestroy == true then
		coroutine.start(this.Destroy,obj);
	else
		coroutine.start(this.Hide,obj);
	end
	return 0.3;
end
function this.Destroy(obj)
	-- body
	coroutine.wait(0.3);
	destroy(obj);
end
function this.Hide( obj )
	coroutine.wait(0.3);
	obj:SetActive(false);
end
function  this.pairsByKeys(t)
	-- body
	local a = {};
	for n in pairs(t) do
		a[#a+1] = n;
	end
	table.sort(a);
	local i = 0;
	return function()
		i = i+1;
		return a[i],t[a[i]];
	end
end
--图标按比例缩放
function this.MakePixelPerfect(sprite,scale)
	--sprite.keepAspectRatio = UIWidget.AspectRatioSource.Free;
	sprite:MakePixelPerfect();
	sprite.height = sprite.height * scale;
	sprite.width = sprite.width * scale;
end