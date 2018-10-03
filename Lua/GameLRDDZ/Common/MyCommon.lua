MyCommon = {}

MyCommon.SceneId = 1  --场景Id

local autoReady = false

local soundType = 0--1普通话配音，2川话配音

local gameEffState = 0 -- 1显示特效，2不显示

function MyCommon.SetSoundType(s_type)
	soundType = s_type
	UnityEngine.PlayerPrefs.SetInt("SoundType",soundType)
end
function MyCommon.GetSoundType()
	if soundType == 0 then
		soundType = UnityEngine.PlayerPrefs.GetInt("SoundType",1)
	end
	return soundType;
end
function MyCommon.GetSoundTypeAbName()
	if soundType == 0 then
		soundType = UnityEngine.PlayerPrefs.GetInt("SoundType",1)
	end
	if soundType == 1 then
		return "Mandarin"
	elseif soundType == 2 then
		return "Sichuan"
	else
		return "None"
	end
end
function MyCommon.SetAutoReady(isAuto)
	autoReady = isAuto
end
function MyCommon.GetAutoReady( )
	return autoReady
end

--1显示 2不显示
function MyCommon.SetGameEffState(s_type)
	gameEffState = s_type
	UnityEngine.PlayerPrefs.SetInt("GameEffState",gameEffState)
end
function MyCommon.GetGameEffState()
	if gameEffState == 0 then
		gameEffState = UnityEngine.PlayerPrefs.GetInt("GameEffState",1)
	end
	return gameEffState
end
local initScore = 1
function MyCommon.InitScore(score)
	if score ~= nil then
		initScore = score 
	else
		return initScore
	end
end
function MyCommon.CreatePrompt(string,okFunc,cancelFunc)
	LRDDZ_ResourceManager.Instance:CreatePanel('PromptPanel','PromptPanel', true,function(obj)
			local luabe = obj:GetComponent('LRDDZ_LuaBehaviour');
			obj.transform:FindChild("Label"):GetComponent("UILabel").text = string
			local okbtn = obj.transform:FindChild("OkBtn").gameObject 
			local cancelbtn = obj.transform:FindChild("CancelBtn").gameObject 

			if type(okFunc) == "function" then 
				local function okCall(ob)
					destroy(obj)
					okFunc(ob)
				end 
				luabe:AddClick(okbtn,okCall) 
			end 
			if cancelFunc ~= nil then
				if type(cancelFunc) == "function" then 
					local function cancalCall(ob)
						destroy(obj)
						cancelFunc(ob)
					end 
					luabe:AddClick(cancelbtn,cancalCall) 
				end 

				okbtn.transform.localPosition = Vector3.New(-200,-163,0)
				cancelbtn:SetActive(true)
			else
				cancelbtn:SetActive(false)
				okbtn.transform.localPosition = Vector3.New(0,-163,0)
			end
		end);
end 
function MyCommon.ShowTips(str)
	LRDDZ_ResourceManager.Instance:CreatePanel('TipsPanel','TipsPanel', false,function(obj)
			obj.transform:FindChild("Label_desc"):GetComponent("UILabel").text = str
			obj.transform.localScale = Vector3.New(2,2,2)
			iTween.ScaleTo(obj,iTween.Hash("scale", Vector3.New(1,1,1), "time", 0.5, "islocal", true, "easetype", iTween.EaseType.easeOutQuad))
			local function func()
				coroutine.wait(3)
				destroy(obj)
			end
			coroutine.start(func)
		end)
end
function MyCommon.SetNumFormat(num)
	local tNum = tonumber(num)
	local tNumR = ''
	while tNum>=1000 do 
		local tS = tostring(tNum %1000)
		if 1 == string.len(tS) then
			tS = '00'..tS
		elseif 2 == string.len(tS) then
			tS = '0'..tS
		end
		tNumR = ','..tS ..tNumR
		tNum = math.modf(tNum /1000)
	end
	-- print('==================='..tNum .. tNumR)
	return tostring(tNum) ..tNumR
end
--设置名字个数,中文占1个，英文占0.5个
--string.byte(char) > 127则代表是中文
function MyCommon.SetName(name,num)
	local recNum = 0
	local tempString = ""
	local j = 1
	for i=1,#name do
		if i == j then 
			if  string.byte(name,i)>127 then
				--中文
				recNum = recNum + 2 

				if recNum <= num*2 then
					tempString = tempString..string.sub(name,i,i+2)
				else
					tempString = tempString.."..."
					return tempString
				end

				j = j + 3
			else
				recNum = recNum + 1
				if recNum <= num*2 then
					tempString = tempString..string.sub(name,i,i)
				else
					tempString = tempString.."..."
					return tempString
				end
				j = j + 1
			end
		end
		
	end
	return tempString
end
function MyCommon.Set2DCard(obj,suits,weight)
	if weight >= Weight.SJoker then
		obj.transform:GetComponent("UISprite").spriteName = WeightString[weight]
		obj.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor[suits]..WeightText[weight]
	else
		if GameCtrl.changeCardWeight == weight then
			obj.transform:GetComponent("UISprite").spriteName = Suits.LaiZi
			obj.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor.LaiZi..WeightText[weight]
			
		else
			obj.transform:GetComponent("UISprite").spriteName = suits
			obj.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor[suits]..WeightText[weight]
		end
	end
end
function MyCommon.SetPut2DCard(obj,suits,weight,isLz)
	if weight >= Weight.SJoker then
		obj.transform:GetComponent("UISprite").spriteName = WeightString[weight]
		obj.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor[suits]..WeightText[weight]
	else
		if isLz then
			obj.transform:GetComponent("UISprite").spriteName = Suits.LaiZi
			obj.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor.LaiZi..WeightText[weight]
			
		else
			if GameCtrl.changeCardWeight == weight then
				obj.transform:GetComponent("UISprite").spriteName = Suits.LaiZi
				obj.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor.LaiZi..WeightText[weight]
				
			else
				obj.transform:GetComponent("UISprite").spriteName = suits
				obj.transform:FindChild("Label"):GetComponent("UILabel").text =  SuitsColor[suits]..WeightText[weight]
			end
		end
	end
end