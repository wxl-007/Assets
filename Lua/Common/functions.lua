local Res = require 'Conf.Res'
--输出日志--
function log(str)
    Util.Log(str);
end

--打印字符串--
function print(str) 
	Util.Log(str);
end

--错误日志--
function error(str) 
	Util.LogError(str);
end

--警告日志--
function warn(str) 
	Util.LogWarning(str);
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end
--隐藏全部子物体
function OnhideChildrens(t)
	local count=t.childCount;
	while (count>0)
	do
		local  child = t:GetChild(count-1);
		if not IsNil(child) then
			child.gameObject:SetActive(false)
		end
		count=count-1
    end
end

--删除全部子物体
function DestroyChildren(t)
	--local count=t.childCount;
	--while (t.childCount>0)
	--do
	--	local  child = t:GetChild(count-1);
	--	if not IsNil(child) then
	--		GameObject.Destroy(child);
	--	end
		--count=count-1
    --end

    local count=t.childCount;
	while (count>0)
	do
		local  child = t:GetChild(count-1);
		if not IsNil(child) then
			GameObject.Destroy(child.gameObject);
		end
		count=count-1
    end
end

function newobject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end

--add by 2015.12.15
function resLoad(path)
	return UnityEngine.Resources.Load(path)
end

--add by 2015.12.15
--判断元素是否在本table中
function tableContains(tableT,valueT)
	local isContains = false
	for key, value in pairs(tableT) do      
		if value==valueT then
			isContains = true
			break
		end
	end  
	return isContains;
end
--在table中删除指定元素
function tableRemove(tableT,valueT)
	local isContains = false
	for key, value in pairs(tableT) do      
		if value==valueT then
			tableT[key] = nil;
			break
		end
	end 
end
function iTableRemove(tableT,valueT)
	local k;
	for key, value in pairs(tableT) do      
		if value==valueT then
			k = key;
			break
		end
	end 
	
	table.remove(tableT,k)
end
--找到元素在本table中的key
function tableKey(tableT,valueT)
	
	for key, value in pairs(tableT) do      
		if value==valueT then
			return key;
		end
	end  
	return 0;
end
--add by 2016.3.29
--table的深度拷贝
function tableCopy(tableT)
	local tab = {}
	for k, v in pairs(tableT or {}) do
		if type(v) ~= "table" then
			tab[k] = v
		else
			tab[k] = tableCopy(v)
		end
	end
	return tab
end

--add by 2015.12.24
--截取前n/3个汉字
function SubUTF8String(s, n)    
  local dropping = string.byte(s, n+1)    
  if not dropping then return s end    
  if dropping >= 128 and dropping < 192 then    
    return SubUTF8String(s, n-1)    
  end    
  return string.sub(s, 1, n)    
end 
--返回字符个数汉字算一个，英文也算一个
function LengthUTF8String(str)
	local len = #str;
	local left = len;
	local cnt = 0;
	local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
	while left ~= 0 do
		local tmp=string.byte(str,-left);
		local i=#arr;
	while arr[i] do
		if tmp>=arr[i] then left=left-i;break;end
			i=i-1;
		end
		cnt=cnt+1;
	end
	return cnt;
end
--add by 2016.1.22
--转换数据类型为bool
function toBoolean(source)    
	local sourceType = type(source); 
	local isSource = false;
	if sourceType == "String" or  sourceType == "string" then
		if source == "True" or source == "true" or source == "TRUE" or source ~= "0" then
			isSource = true;
		end
	elseif sourceType == "Number" or  sourceType == "number"  then
		if source ~= 0 then
			isSource = true;
		end
	elseif sourceType == "Boolean"  or  sourceType == "boolean" then
		isSource = source;
	elseif sourceType == "Table" or  sourceType == "table"  then
		if #(source) ~= 0 then
			isSource = true;
		end
	elseif sourceType == "Userdata"  or  sourceType == "userdata" then
		if not IsNil(source) then
			isSource = true;
		end
	end
	return isSource;  
end 
--add by lxtd004 2016.6.1
--打印table
function printf(pTable)
	if pTable == nil then 
		return
	end
	if type(pTable) ~= 'table' then
		print(pTable)
	else
		function tPrint(pT,pSpace,pContent)
			pSpace = pSpace or 0
			local tResult = {}
			if pContent ~= nil or pContent ~= '' then
				table.insert(tResult,pContent)
			end
			for k, v in pairs(pT) do
				if type(k) == "string" then
					k = string.format("%q", k)
				end
				local tStart = ""
				if type(v) == "table" then
					if next(v) == nil then
						tStart = '{'
					else
						tStart = "{\n"
					end
				end
				local tS = string.rep("    ", pSpace)
				local formatting = tS.."["..k.."]".."="..tStart
				local tEnd
				if type(v) == "table" then
					tEnd = tPrint(v, pSpace +1,formatting)..tS.."},"
				else
					local tName = ""
					if type(v) == "string" then
						tName = string.format("%q", v)
					else
						tName = tostring(v)
					end
					tEnd = formatting..tName..","
					-- table.insert(tResult,tEnd)
				end
				if string.sub(tEnd,-1)==',' then
					tEnd = tEnd..'\n'
				end
				table.insert(tResult,tEnd)
			end
			return table.concat(tResult,'')
		end
		print(tPrint(pTable,0,''))
	end
end


function setCoin(number)
	local str = tostring(number)or 0;
	local color = nil;
	if number >=100000000 then
		str = string.format("%.2f",tostring(number/100000000)).."亿";
		color = Color.New(1,1,0);--黄
	elseif number >= 10000000 then
		str = string.format("%.2f",tostring(number/10000000)).."千万";
		color = Color.New(1,1,0);--黄
		--return str,color;
	elseif number >= 1000000 then
		str = string.format("%.2f",tostring(number/1000000)).."百万";
		color = Color.New(0,1,0);--绿
		--return str,color;
	elseif number >= 10000 then
		str = string.format("%.2f",tostring(number/10000)).."万";
	end
	return str,color;
end

function setCoinnocolor(number)
	local str = tostring(number);
	local color = nil;
	if str =="无限" then
		return str;
	end
	local num=tonumber(number)
	if num >=100000000 then
		str = string.format("%.0f",tostring(num/100000000)).."亿";
		
	elseif num >= 10000000 then
		str = string.format("%.0f",tostring(num/10000000)).."千万";
		
		--return str,color;
	elseif num >= 1000000 then
		str = string.format("%.0f",tostring(num/1000000)).."百万";
		
		--return str,color;
	elseif num >= 10000 then
		str = string.format("%.0f",tostring(num/10000)).."万";
	end
	return str;
end

--例子:"2014-09-07 08:23:05"转换成1410049385
function DateTime_To_UnixStamp(date_time)
    local time_table = split_datetime_str(date_time)
    if time_table ~= nil then
        return os.time{year=time_table[1], month=time_table[2], day=time_table[3], hour=time_table[4], min=time_table[5], sec=time_table[6]}
    end
    return 0
end
--输入"2014-10-07 12:23:25" 返回 {2014,10,07,12,23,25}
function split_datetime_str(date_time_str)
    local set_year=0
    local set_month=0
    local set_day=0
    local set_hour=0
    local set_min=0
    local set_sec=0

    if date_time_str == nil or date_time_str == "" then
        return
    end

    local date_time_list = string_split(date_time_str, " ")
    if (date_time_list[1] == nil or date_time_list[1] == " ") or (date_time_list[2] == nil or date_time_list[2] == " ") then
        return
    end

    local date_list = string_split(date_time_list[1], "-")
    local time_list = string_split(date_time_list[2], ":")
    if (date_list == nil or date_list == " ") or (time_list == nil or time_list == " ") then
        return
    end

    set_year=date_list[1]
    set_month=date_list[2]
    set_day=date_list[3]
    set_hour=time_list[1]
    set_min=time_list[2]
    set_sec=time_list[3]
    return {set_year, set_month, set_day, set_hour, set_min, set_sec}
end
function string_split(inputstr, sep)
    if inputstr == nil then
        return {}
    end
    if sep == nil then
        sep = "%s"
    end
    local t={}
    local i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

--例子:1410049385转换成"2014-09-07 08:23:05"
function UnixStamp_To_DateTime(unix_stamp)
    local year = os.date("%Y", unix_stamp)
    local month = os.date("%m", unix_stamp)
    local day = os.date("%d", unix_stamp)
    local hour = os.date("%H", unix_stamp)
    local min = os.date("%M", unix_stamp)
    local sec = os.date("%S", unix_stamp)
    return string.format("%02d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, min, sec)
end
--获得当前时间
function Curtime()
	local date=os.date("%Y-%m-%d %H:%M:%S");
	return date
end
--比较时间大小
function COMPMaxminTime(date_time)
	local time_table = split_datetime_str(date_time)
	local savetime=0;
    if time_table ~= nil then
        savetime= os.time{year=time_table[1], month=time_table[2], day=time_table[3], hour=time_table[4], min=time_table[5], sec=time_table[6]}
    end
    local hastime=savetime-os.time()
    return hastime;
end
--添加ui弹出动画
function showUI(obj)
	--obj:SetActive(true);
	coroutine.start(function() coroutine.wait(0.001);
	--localPosition = Vector3.one;
	obj.transform.localPosition=Vector3.New(0,2000,0)
	obj:SetActive(true);
	--iTween.ScaleFrom(obj,iTween.Hash("scale", Vector3.New(0.8, 0.8, 0.8),"time",0.3));end);
	iTween.MoveTo(obj,iTween.Hash("y", 0,"islocal",true,"time",0.5,"easetype", iTween.EaseType.easeOutCubic));end);
	--iTween.ScaleFrom(obj,iTween.Hash("scale", Vector3.New(0.8, 0.8, 0.8),"speed",0.4, "easeType", iTween.EaseType.easeOutElastic));
	--iTween.ScaleFrom(obj,iTween.Hash("scale", Vector3.New(0.8, 0.8, 0.8),"speed",0.4));
end

--添加ui弹出动画
function showESCUI(obj)
	obj:SetActive(true);
	coroutine.start(
		function() coroutine.wait(0.001);
			--iTween.ScaleTo(obj,iTween.Hash("scale", Vector3.New(0.8, 0.8, 0.8),"time",0.5));
			iTween.MoveTo(obj,iTween.Hash("y", 2500,"islocal",true,"time",0.5,"easetype", iTween.EaseType.easeInCubic));
	    end);

	--iTween.ScaleFrom(obj,iTween.Hash("scale", Vector3.New(0.8, 0.8, 0.8),"speed",0.4, "easeType", iTween.EaseType.easeOutElastic));
	--iTween.ScaleFrom(obj,iTween.Hash("scale", Vector3.New(0.8, 0.8, 0.8),"speed",0.4));
end
function string.split(str, d) --str是需要查分的对象 d是分界符
	local lst = { }
	local n = string.len(str)--长度
	local start = 1
	while start <= n do
		local i = string.find(str, d, start) -- find 'next' 0
		if i == nil then 
			table.insert(lst, string.sub(str, start, n))
			break 
		end
		table.insert(lst, string.sub(str, start, i-1))
		if i == n then
			table.insert(lst, "")
			break
		end
		start = i + 1
	end
	return lst
end
function IndexOf_Collections_cs(collection, val)
 	if(collection ~= nil and collection.Count > 0) then
  		for i=0,collection.Count - 1 do
   			if(collection[i] == val) then
    			return i;
   			end
  		end
 	end
 	return -1;
end
function FormatPhoneNickName(pString)
    if string.find(pString,"_mob") ~= nil then
        tStart,tEnd=string.find(pString,"_mob")
        if tStart<12 then
            return pString
        end
        local tPhoneStr = string.sub(pString,0,tStart)
        local tStr0 = string.sub(tPhoneStr,0,3)
        local tStr1 = "***"
        local tStr2 = string.sub(tPhoneStr,string.len(tPhoneStr)-3)
        tStr2 = tStr2..tPhoneStr.sub(pString,tStart+1)
        return tStr0..tStr1..tStr2
    end
    return pString
end
function ShowFrontEndThree(pString)
    if string.len(pString) <= 3 then
        return pString
    end
    local tStr0 = string.sub(pString,0,3)
    local tStr1 = "***"
    local tStr2 = string.sub(pString,string.len(pString)-2)
    return tStr0..tStr1..tStr2
end
function ShowFrontEnd(pString,num)
    if string.len(pString) <= num then
        return pString
    end
    local tStr0 = string.sub(pString,0,num)
    local tStr1 = ""
    for i = 1 ,num do 
    	tStr1 = tStr1.."*"
    end
    
    local tStr2 = string.sub(pString,string.len(pString)-(num-1))
    return tStr0..tStr1..tStr2
end
--主界面 弹出窗 动画统一  pDir true出现 false 消失
function ShowHallPanel( pObj,pDir,pFunc,pFuncAhead)
	if pFuncAhead ~= nil then 
		if type(pFuncAhead) == 'function'then 
			pFuncAhead()
		end
	end

	pObj.transform.localPosition = Vector3.zero
	
	
	-- local tDis = 2000

	if pDir == true then 
		-- tDis = 0
		-- pObj.transform.localPosition = Vector3.up*2000
		pObj.transform.localScale = Vector3.one*0.5
	end
	pObj:SetActive(true);
	coroutine.start(function() 
		-- iTween.MoveTo(pObj,iTween.Hash("position", Vector3.New(0, tDis, 0),"islocal",true,"time",0.3,"easetype", iTween.EaseType.easeInOutBack));
		iTween.ScaleTo(pObj,iTween.Hash('scale',Vector3.one,'time',0.3,"islocal",true,"easetype",iTween.EaseType.easeInOutBack))
		coroutine.wait(0.3)
		if type(pFunc) == 'function' then 
			pFunc()
		end
		if pDir == false then 
			pObj:SetActive(false)
			destroy(pObj)
		end
    end);
end


--切换弹出框
function SwitchPanel(pCurName,PNextName,pFuncA,pFuncB)
	
end

function AddComma(pNum)
	local tNum = tostring(pNum)
	if type(pNum) ~='number' and type(pNum) ~= 'string' then 
		return error('wrong type ')
	end
	local i =1 
	local tResult =''
	while(true)
	do
		local tSp = string.sub(tNum,-i*4,-i+(-i*4))
		if string.len(tSp) < 4 then 
			tResult =tSp..tResult
			return tResult
		end

		tResult = ','..tSp..tResult
	end
end

--获取配置表文件
-- function GetMessage(pKey)
-- 	if type(pKey) ~= 'string' and type(pKey) ~= 'number' then
-- 		return nil 
-- 	end  
-- 	-- printf(Res)
	
-- 	if Res[pKey] ~= nil then 
-- 		return  Res[pKey]
-- 	else
-- 		print('please check your key !')
-- 		return nil 
-- 	end

-- end

-- local Zh_Hans = require 'Conf.Zh_Hans'
-- function GetLocalization(pKey)
-- 	if type(pKey) ~= 'string' and type(pKey) ~= 'number' then
-- 		return nil 
-- 	end  
-- 	-- printf(Res)
	
-- 	if Zh_Hans[pKey] ~= nil then 
-- 		return  Zh_Hans[pKey]
-- 	else
-- 		print('please check your key !')
-- 		return nil 
-- 	end

-- end