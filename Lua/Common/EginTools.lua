
local this = LuaObject:New()
EginTools = this

this.localBeiJingTime = 0 

--返回 1970 年 1 月 1 日至今的毫秒数
function this.nowMinis()
	return Util.nowMinis()
end
function this.Log( pStr )
	print(pStr)
end
function this.getJavaTimeToCshaopTime(pValue)
	local tNum = tonumber(System.DateTime.New(1970, 1, 1, 0, 0, 0).Ticks) + math.floor(pValue)*10000000
	return math.floor(tNum)
end

function this.MD5Coding(pStr)
	return Util.MD5Coding(pStr)
end

function this.ClearChildren(pTransform)
	if pTransform.childCount ==0  or pTransform == nil then
		return 
	end

	for i=0, pTransform.childCount-1 do 
		local tObj = pTransform:GetChild(i).gameObject
		destroy(tObj)
	end

end

function this.encrypTime(pString)
	return  Util.encrypTime(pString)
end

function this.AddNumberSpritesSize(pNumberObj,pParent,pNumber,pPrefix,pPaddingSize)
	local tNum = tostring(pNumber)
	local tPos = pNumberObj.transform.localPosition 
	local tPaddingWidth = pNumberObj:GetComponent('UISprite').width
	local tSize = pPaddingSize
	if tSize <= 0 then
		tSize = 1 
	end

	for i=1,string.len(tNum) do
		local tStr =  string.sub(tNum,i,i)
		local tObj = GameObject.Instantiate(pNumberObj)
		tObj.transform.parent = pParent
		tObj.transform.localScale = Vector3.one
		tPos.x = (tObj.transform.localPosition.x + i*tPaddingWidth)*tSize
		tObj.transform.localPosition = tPos 
		local tNumberSp = tObj:GetComponent('UISprite')
		if tNumberSp then
			tNumberSp.spriteName = pPrefix ..tStr
		end 
	end
end

function this.AddNumberSpritesCenter(pNumberObj,pParent,pNumber,pPrefix,pSize )
	if type(pNumber) ~= 'string' then
		pNumber = tostring(pNumber)
	end 
	local tPos = pNumberObj.transform.localPosition 
	local tPaddingWidth = pNumberObj:GetComponent('UISprite').width
	local tHalf = 0-string.len(pNumber)/2
	for i=1,string.len(pNumber) do 
		local tStr =  string.sub(pNumber,i,i)
		local tObj = GameObject.Instantiate(pNumberObj)
		tObj.transform.parent = pParent
		tObj.transform.localScale = Vector3.one
		tPos.x = (tHalf+i) * tPaddingWidth 
		if pSize >0 and pSize <=1 then
			tPos = tPos * pSize
		end 
		tObj.transform.localPosition = tPos 

		local tNumberSp = tObj:GetComponent('UISprite')
		if tNumberSp then
			tNumberSp.spriteName = pPrefix ..tStr
		end 
	end
	local tV = Vector3.New((tHalf-1.5)*tPaddingWidth,tPos.y,tPos.z)
	return tV
end

function this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,pDeltaX,pDeltaY,pIndex)
	if type(pNumber) ~= 'string' then
		pNumber = tostring(pNumber)
	end 
	local tPos = pNumberObj.transform.localPosition 
	local tPaddingWidth = pNumberObj:GetComponent('UISprite').width
	local tHalf = 0-string.len(pNumber)/2
	for i=1,string.len(pNumber) do 
		local tStr =  string.sub(pNumber,i,i)
		local tObj = GameObject.Instantiate(pNumberObj)
		tObj.transform.parent = pParent
		tObj.transform.localScale = Vector3.one
		tPos.x = (tHalf+i) * (tPaddingWidth + pIndex) +pDeltaX
		tPos.y = pDeltaY
		if pSize >0 and pSize <=1 then
			tPos = tPos * pSize
		end 
		tObj.transform.localPosition = tPos 

		local tNumberSp = tObj:GetComponent('UISprite')
		if tNumberSp then
			tNumberSp.spriteName = pPrefix ..tStr
		end 
	end
	local tV = Vector3.New((tHalf-1.5)*tPaddingWidth,tPos.y,tPos.z)
	return tV
end

function this.AddNumberSpritesCenterAdjust( pNumberObj,pParent,pNumber,pPrefix,pSize  )
	local tPadWide = pNumberObj:GetComponent('UISprite').width 
	if string.len(pNumber)%2 == 0 then
		tPadWide= tPadWide /2
	else
		tPadWide =0
	end

	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,tPadWide,0,0) 
	return tV
end

function this.AddNumberSpritesCenter_buyu(pNumberObj,pParent,pNumber,pPrefix,pSize )
	
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,35,33,0) 
	return tV
end

function this.AddNumberSpritesCenter_Srps(pNumberObj,pParent,pNumber,pPrefix,pSize )
	
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,0,0,0) 
	return tV
end


function this.AddNumberSprites_closing(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,0,0,0) 
	return tV
end

function this.AddNumberSpritesCenter_1(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,35,65,0) 
	return tV
end
function this.AddNumberSpritesCenter_2(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,10,-29,0) 
	return tV
end

function this.AddNumberSpritesCenter_3(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,47,-26,0) 
	return tV
end

function this.AddNumberSpritesCenter_4(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,30,37,0) 
	return tV
end
function this.AddNumberSpritesCenter_5(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,-7,35,0) 
	return tV
end
function this.AddNumberSpritesCenter_6(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,10,-4920,2) 
	return tV
end
function this.AddNumberSpritesCenter_7(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,5,-3565,2) 
	return tV
end
function this.AddNumberSpritesCenter_8(pNumberObj,pParent,pNumber,pPrefix,pSize )
	local tV =this:AddNumberBasic(pNumberObj,pParent,pNumber,pPrefix,pSize,535,95,5) 
	return tV
end
function this.NumberAddComma( pString )
	-- print(')))))))))))))) '..pString)
	local tNum = tonumber(pString)
	local tNumR = ''
	while tNum>=10000 do 
		local tS = tostring(tNum %10000)
		if 1 == string.len(tS) then
			tS = '000'..tS
		elseif 2 == string.len(tS) then
			tS = '00'..tS
		elseif 3 == string.len(tS) then
			tS = '0'..tS
		end
		tNumR = ','..tS ..tNumR
		tNum = math.modf(tNum /10000)
	end
	-- print('==================='..tNum .. tNumR)
	return tostring(tNum) ..tNumR
end

function this.PlayEffect( pEffectSound )
	local tVolume = SettingInfo.Instance.effectVolume
	if tonumber(tVolume) >0 then
		NGUITools.PlaySound(pEffectSound,tVolume)
	end
end



function this.setScreen(pTransform, pWidth,pHeight)
	local sceneRoot = pTransform.root:GetComponent("UIRoot")	
	if sceneRoot then 	
		sceneRoot.manualHeight = pHeight;	
		sceneRoot.manualWidth = pWidth;	
	end			
end

function this.miao2TimeStr( pMiao,pIgnoreUint,pAddDecimal )
	pIgnoreUint = pIgnoreUint or false 
	pAddDecimal = pAddDecimal or false 
	local tDayS = tonumber(24 * 60 * 60)
	local tHourS = tonumber(60 * 60)
	local tMinS = tonumber(60)

	local tNum = pMiao/tDayS
	local tSNum = (pMiao -tNum*tDayS)/tHourS
	local tFNum = (pMiao -tNum*tDayS-tSNum*tHourS)/tMinS
	local tMNum = pMiao -tNum*tDayS-tSNum*tHourS-tFNum*tMinS

	local tTimeStr = ''
	if tNum >0 then
		local tNumStr = tostring(tNum)
		if pAddDecimal then
			tNumStr = tNum
			if string.len(tNumStr)==1 then
				tNumStr = '0'..tNum
			end 
		end
		if pIgnoreUint then
			tTimeStr = tTimeStr..tNumStr..':'
		else
			tTimeStr = tTimeStr..tNumStr..'日'--"\u65e5"
		end
	end
	if tSNum > 0 or pAddDecimal then
		local tSNumStr = tostring(tSNum)
		if pAddDecimal then
				tSNumStr = tSNum
			if string.len(tSNumStr)==1 then
				tSNumStr = '0'..tSNum
			end 
			if pIgnoreUint then
				tTimeStr = tTimeStr..tSNumStr..':'
			else
				tTimeStr = tTimeStr..tSNumStr.."时" --'\u65f6'
			end
		end

	end
	if tFNum > 0 or pAddDecimal then
		local tFNumStr = tostring(tFNum)
		if pAddDecimal then
			tFNumStr = tFNum
			if string.len(tFNumStr)==1 then
				tFNumStr = '0'..tFNum
			end 
			if pIgnoreUint then
				tTimeStr = tTimeStr..tFNumStr..':'
			else
				tTimeStr = tTimeStr..tFNumStr..'分'--'\u5206'
			end
		end
	end
	local tMNumStr = tMNum .. ''
	if pAddDecimal then
		if string.len(tMNum)==1 then
			tMNumStr = '0'..tMNum
		end 
	end
	if pIgnoreUint then
		tTimeStr = tTimeStr..tMNumStr..':'
	else
		tTimeStr = tTimeStr..tMNumStr..'秒'--'\u79d2'
	end
	return tTimeStr
end


this.m_InStr = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
this.m_NumStr = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" }
this.m_MoneyDigits = {"拾", "佰", "仟", "万", "亿"}
function this.numToCnNum( pMoney)
	local tStr = ''
	for i=1,string.len(pMoney) do 
		if string.sub(pMoney,i,i) ~= this.m_InStr[1] then
			tStr = string.sub(pMoney,i)
			break
		end
	end
	pMoney = tStr
	local tChange = function (pChar,pIsZero,pStr)

		for j=1,#this.m_InStr do 
			if pChar == this.m_InStr[j] then
				if pIsZero==false  and j==1 then
					return ''
				end
				return this.m_NumStr[j]..pStr
			end			
		end
	end
	local tCount = {-1,-1,-1,-1}
	local tFixDigitStr = ''
	for i=0,string.len(pMoney)-1 do 
		if (string.len(pMoney) -i)%4 ==0 then
			local tN = tChange(string.sub(pMoney,i+1,i+1),false,this.m_MoneyDigits[3])
			tCount[1] = tonumber(string.sub(pMoney,i+1,i+1))
			tFixDigitStr = tFixDigitStr..tN
		elseif  (string.len(pMoney) -i)%4 ==2 then
			local tN = tChange(string.sub(pMoney,i+1,i+1),false,this.m_MoneyDigits[1])
			tCount[3] = tonumber(string.sub(pMoney,i+1,i+1))
			if tCount[3] ~= 0 and tCount[2] ==0 then
				tFixDigitStr = tFixDigitStr..this.m_NumStr[1]..tN
			else
				tFixDigitStr = tFixDigitStr..tN
			end
		elseif  (string.len(pMoney) -i)%4 ==3 then
			local tN = tChange(string.sub(pMoney,i+1,i+1),false,this.m_MoneyDigits[2])
			tCount[2] = tonumber(string.sub(pMoney,i+1,i+1))
			if tCount[2] ~= 0 and tCount[1] ==0 then
				tFixDigitStr = tFixDigitStr..this.m_NumStr[1]..tN
			else
				tFixDigitStr = tFixDigitStr..tN
			end
			
		elseif  (string.len(pMoney) -i)%5 ==0 then
			local tN = tChange(string.sub(pMoney,i+1,i+1),false,this.m_MoneyDigits[4])
			tCount[4] = tonumber(string.sub(pMoney,i+1,i+1))
			local tIsAll = false 
			for x =1,4 do 
				if tCount[x] ~= 0 then
					tIsAll = true 
				end
			end
			if tIsAll then
				if tCount[4] ~= 0 and tCount[3] ==0 then
					tFixDigitStr = tFixDigitStr..this.m_NumStr[1] ..tN		
				elseif tCount[4] ~= 0 and tCount[3] ~=0 then
					tFixDigitStr = tFixDigitStr..tN
				else

					tFixDigitStr = tFixDigitStr..this.m_MoneyDigits[4]
				end
			end
			tCount = {-1,-1,-1,-1}
		elseif  (string.len(pMoney) -i)%9==0 then
			tCount = {-1,-1,-1,-1}
			
			local tN = tChange(string.sub(pMoney,i+1,i+1),false,this.m_MoneyDigits[5])
			tCount[4] =tonumber(string.sub(pMoney,i+1,i+1))
			if tCount[4] ~= 0 and tCount[3] ==0 then
				tFixDigitStr = tFixDigitStr..this.m_NumStr[1]..tN
			elseif tCount[4] ~= 0 and tCount[3] ~=0 then 
				tFixDigitStr = tFixDigitStr..tN
			else
				tFixDigitStr = tFixDigitStr .. this.m_MoneyDigits[5]
			end
		else
			local tN = tChange(string.sub(pMoney,i+1,i+1),false,'')
			tCount[4] = tonumber(string.sub(pMoney,i+1,i+1))
			if tCount[4] ~= 0 and tCount[3] ==0 then
				tFixDigitStr = tFixDigitStr ..this.m_NumStr[1] ..tN
			else
				tFixDigitStr = tFixDigitStr ..tN
			end			
		end
	end


	-- print("零, 壹, 贰, 叁, 肆, 伍, 陆, 柒, 捌, 玖")
	print(tFixDigitStr)
	return tFixDigitStr
end

function this.HuanSuanMoney(money)
	local betmoney=tonumber(money);
	local huansuanMoney=nil;
	if betmoney<100000 then
		huansuanMoney=tostring(betmoney);
	elseif betmoney>=100000 and betmoney<10000000 then
		local chushu=tonumber(betmoney/10000);
		--local zhengshu=tostring(tonumber(betmoney)/10000);
		local zhengshu=math.floor(chushu);
		local yushu=betmoney%10000;
		if yushu~=0 then
			local shuzi=tostring(chushu);
			huansuanMoney=SubUTF8String(shuzi,#(tostring(zhengshu))+2).."万";
		else
			huansuanMoney=zhengshu.."万";
		end
	elseif betmoney>=10000000 and betmoney<100000000 then
		--local chushu=betmoney/10000;
		--huansuanMoney=tostring(chushu).."万";
		local chushu=betmoney/10000;
		local zhengshu=math.floor(chushu);
		local yushu=betmoney%10000;
		--[[
		if yushu~=0 then
			local shuzi=tostring(chushu);
			huansuanMoney=SubUTF8String(shuzi,#(tostring(zhengshu))+2).."万";
		else
			huansuanMoney=zhengshu.."万";
		end
		]]
		huansuanMoney=zhengshu.."万";
	else
		local chushu=tonumber(betmoney/100000000);		
		--local zhengshu=tostring(tonumber(betmoney)/100000000);
		local zhengshu=math.floor(chushu);
		local yushu=betmoney%100000000;
		if yushu~=0 then
			local shuzi=tostring(chushu);
			huansuanMoney=SubUTF8String(shuzi,#(tostring(zhengshu))+2).."亿";
		else
			huansuanMoney=zhengshu.."亿";
		end
	end
	return huansuanMoney;
end

