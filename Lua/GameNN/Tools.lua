
local this = LuaObject:New()
Tools = this

function this.CurrentTimeMillis()
	return (System.DateTime.UtcNow.Ticks- 621355968000000000)/10000;
end

--给结算的信息添加颜色
function this.SetLabelForColor(label, money, col1, col2)

	local color = "999999";
	local moneyStr = "";
	if money > 0 then
		color=col1;
		moneyStr="+";
	elseif money<0 then
		color=col2;
	end
	--最后结算的金钱输赢数目
	moneyStr = moneyStr..money;
	
	label.text = System.String.Format ("[{0}]{1}[-]",color,moneyStr);
end
--给结算的信息添加颜色(明星牛牛)
function this.SetLabelForColorMX(label,labelAdd, money)
	label.gameObject:SetActive(false);
	labelAdd.gameObject:SetActive(false);
	if money > 0 then   
		labelAdd.gameObject:SetActive(true);
		labelAdd.text = "+"..money;
	else 
		label.gameObject:SetActive(true);
		label.text = tostring(money);
	end
	  
end
--给结算的信息添加颜色
function this.SetLabelForColor5(label, msg, money, col1, col2)
	--ffffff白色
	local color = "ffffff";
	if  money > 0 then 
		color = col1;
	elseif money < 0 then
		color = col2;
	end
	label.text= System.String.Format ("[{0}]{1}[-]",color,msg);
end

function this.drawPathGrid( parent, path,loopNum)
	local node = path[1];
	local index = 0;
	local sp = nil;
	for key,value in ipairs(path) do
		local i = 0;
		if value > 0 then
			i = 1;
		end
		sp=parent:FindChild("PathItem"..index):GetComponent("UISprite");
		sp.spriteName=Define.NN_PATH_ICON[i+1];
		NGUITools.SetActive(sp.gameObject,true);
		index = index+1;
	end
	
	for i = index, loopNum do 
		NGUITools.SetActive(parent:FindChild("PathItem"..index).gameObject,false);
	end

end

function this.drawPathGrid_1( parent, path,loopNum)
	local index = 1;
	local sp = nil;
	for key,value in ipairs(path) do
		sp=parent.transform:FindChild("chebiao_"..index):GetComponent("UISprite");
		sp.spriteName=Define.PPC_PATH_ICON[value];
		NGUITools.SetActive(sp.gameObject,true);
		index = index+1;
	end
	
	for i = index, loopNum do 
		NGUITools.SetActive(parent.transform:FindChild("chebiao_"..index).gameObject,false);
	end

end

function this.initPathGrid( parent, prefab,localPosition,offsetx,offsety,loopNum,modulus,multiple)
	local localScale=prefab.transform.localScale;
	local gobj=nil;
	local d = 0;
	for i=0,loopNum do
		gobj=Object.Instantiate(prefab.gameObject);
		gobj.transform.parent=parent;
		gobj.transform.localScale=localScale;
		gobj.name="PathItem"..i;
		gobj.transform.localPosition=localPosition;
		d=d+1;
		if d%modulus==0 then
			localPosition.x=localPosition.x-offsetx;
			localPosition.y=localPosition.y+offsety*multiple;
		else
			localPosition.y=localPosition.y-offsety;
		end
	end
end

function this.MoveFrome( transform, x, y, w, h, timeC)
	NGUITools.SetActive (transform.gameObject, true);
	local scaleVec3 = Vector3.one;
	scaleVec3.x = w / transform.localScale.x;
	scaleVec3.y = h / transform.localScale.y;
	iTween.ScaleFrom (transform.gameObject,iTween.Hash("scale",scaleVec3,"time",timeC));
	iTween.MoveFrom (transform.gameObject,iTween.Hash("position",Vector3.New(x, y, 0),"time",timeC,"islocal", true));
end
--点数的计算
function this.dianShu(arr)
	local retu_vl = 0;
	if arr ~=nil and #arr>0 then
		for i=1,#arr do
			if  arr[i]~= -1 then
				local nuu = 0;
				if arr[i]%13+1>=10 then
					nuu=0;
				else 
					nuu = arr[i]%13+1;
				end
				retu_vl = retu_vl+nuu;
			end
		end		
	end
	return retu_vl%10;
end
	
	