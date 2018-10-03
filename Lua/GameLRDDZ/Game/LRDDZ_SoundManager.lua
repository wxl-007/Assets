LRDDZ_SoundManager = {}
local self = LRDDZ_SoundManager

local soundConfig = require "GameLRDDZ/config/LRDDZ_Sound"
local soundEffect = require "GameLRDDZ/config/LRDDZ_SoundEffect"

--人物打牌音效
function LRDDZ_SoundManager.PlayHumanSound(characterType,cards,cardtype,isman)
	--播放出牌的音效
	local obj = nil
	if characterType == CharacterType.Player then
		obj = CharacterPlayer.GameObject()
	elseif characterType == CharacterType.Computer then
		obj = CharacterComputer.GameObject()
	else
		obj = CharacterOtherComputer.GameObject() 
	end
	if obj == nil then
		obj = GameObject.New("TempSound");
		GameObject.Destroy(obj,10)
	end
	local soundString = ""
	if cardtype == CardsType.Straight then --顺子
		soundString = "straight"
	elseif cardtype ==CardsType.TripleStraight then --三顺，暂放在飞机
		soundString = "tripleStraight"
	elseif cardtype == CardsType.DoubleStraight then --连对
		soundString = "doubleStraight"
	elseif cardtype == CardsType.TripleStraightAndSingle or cardtype == CardsType.TripleStraightAndDouble then --飞机
		soundString = "tripleStraightWithOther"
	elseif cardtype == CardsType.ThreeAndOne then--三带一
		soundString = "threeAndOne"
	elseif cardtype == CardsType.ThreeAndTwo then--三带一对
		soundString = "threeAndTwo"
	elseif cardtype == CardsType.FourAndSingle then--四带二
		soundString = "fourAndSingle"
	elseif cardtype == CardsType.FourAndDouble then--四带两对
		soundString = "fourAndDouble"
	elseif cardtype == CardsType.Boom then --炸弹
		soundString = "boom"
	elseif cardtype == CardsType.JokerBoom then --王炸
		soundString = "jokerBoom"
	elseif cardtype == CardsType.OnlyThree then
		soundString = "onlyThree";
	elseif cardtype == CardsType.Single then --单牌
		if cards[1].weight == Weight.Five then
			soundString = "single5"
		elseif cards[1].weight == Weight.Four then
			soundString = "single4"
		elseif cards[1].weight == Weight.Three then
			soundString = "single3"
		elseif cards[1].weight == Weight.Six then
			soundString = "single6"
		elseif cards[1].weight == Weight.Seven then
			soundString = "single7"
		elseif cards[1].weight == Weight.Eight then
			soundString = "single8"
		elseif cards[1].weight == Weight.Nine then
			soundString = "single9"
		elseif cards[1].weight == Weight.Ten then
			soundString = "single10"
		elseif cards[1].weight == Weight.Jack then
			soundString = "singleJ"
		elseif cards[1].weight == Weight.Queen then
			soundString = "singleQ"
		elseif cards[1].weight == Weight.King then
			soundString = "singleK"
		elseif cards[1].weight == Weight.One then
			soundString = "singleA"
		elseif cards[1].weight == Weight.Two then
			soundString = "single2"
		elseif cards[1].weight == Weight.SJoker then
			soundString = "singleSjoker"
		elseif cards[1].weight == Weight.LJoker then
			soundString = "singleLjoker"
		end
	elseif cardtype == CardsType.Double then --对子
		if cards[1].weight == Weight.Five and cards[2].weight == Weight.Five then
			soundString = "double5"
		elseif cards[1].weight == Weight.Four and cards[2].weight == Weight.Four then
			soundString = "double4"
		elseif cards[1].weight == Weight.Three and cards[2].weight == Weight.Three then
			soundString = "double3"
		elseif cards[1].weight == Weight.Six and cards[2].weight == Weight.Six then
			soundString = "double6"
		elseif cards[1].weight == Weight.Seven and cards[2].weight == Weight.Seven then
			soundString = "double7"
		elseif cards[1].weight == Weight.Eight and cards[2].weight == Weight.Eight then
			soundString = "double8"
		elseif cards[1].weight == Weight.Nine and cards[2].weight == Weight.Nine then
			soundString = "double9"
		elseif cards[1].weight == Weight.Ten and cards[2].weight == Weight.Ten then
			soundString = "double10"
		elseif cards[1].weight == Weight.Jack and cards[2].weight == Weight.Jack then
			soundString = "doubleJ"
		elseif cards[1].weight == Weight.Queen and cards[2].weight == Weight.Queen then
			soundString = "doubleQ"
		elseif cards[1].weight == Weight.King and cards[2].weight == Weight.King then
			soundString = "doubleK"
		elseif cards[1].weight == Weight.One and cards[2].weight == Weight.One then
			soundString = "doubleA"
		elseif cards[1].weight == Weight.Two and cards[2].weight == Weight.Two then
			soundString = "double2"
		end
	end
	--判断大你的音效是否要播
	--[[
	if cardsType==CardsType.OnlyThree or cardsType==CardsType.ThreeAndOne or cardsType==CardsType.ThreeAndTwo or cardsType==CardsType.Straight or cardsType==CardsType.DoubleStraight or cardsType==CardsType.TripleStraight or cardsType==CardsType.TripleStraightAndSingle or cardsType==CardsType.TripleStraightAndDouble or cardsType==CardsType.FourAndSingle or cardsType==CardsType.FourAndDouble then
		if OrderCtrl.bigest ~= CharacterType.Player then --判断大你的牌是否是对方出的
			audio_name = "_dani" .. math.random(1,3)
		end
	end
	]]
	local audio_name = ""
	if isman == true then
		audio_name = "nan/m_"
	else
		audio_name = "nv/w_"
	end
	local soundInfo = soundConfig[soundString];
	if soundInfo == nil then return end
	audio_name = audio_name..soundInfo.Name
	local j = soundInfo.RandomNum
	for i=1,soundInfo.RandomNum do
		if j == 1 then
			if LRDDZ_MusicManager.instance:CheckHasAudioFile(MyCommon.GetSoundTypeAbName(),audio_name) == false then
				audio_name =  audio_name..1 
			end
			break
		else
			local rand = math.random(1,j);
			j = j-1
			if LRDDZ_MusicManager.instance:CheckHasAudioFile(MyCommon.GetSoundTypeAbName(),audio_name..rand) == true then
				audio_name = audio_name..rand
				break
			end
		end
	end
	return LRDDZ_MusicManager.instance:PlayAudio(obj,MyCommon.GetSoundTypeAbName(),audio_name,false,true,true,1.0)
end
--人物其他音效
function LRDDZ_SoundManager.OtherHumanSound(characterType,name,isman)
	local obj = nil 
	if characterType == CharacterType.Player then
		obj = CharacterPlayer.GameObject()
	elseif characterType == CharacterType.Computer then
		obj = CharacterComputer.GameObject()
	else
		obj = CharacterOtherComputer.GameObject()
	end
	if obj == nil then
		obj = GameObject.New("TempSound");
		GameObject.Destroy(obj,10)
	end
	local audio_name = ""
	if isman == true then
		audio_name = "nan/m_"
	else
		audio_name = "nv/w_"
	end
	local soundInfo = soundConfig[name]
	audio_name = audio_name..soundInfo.Name
	local j = soundInfo.RandomNum
	for i=1,soundInfo.RandomNum do
		if j == 1 then
			if LRDDZ_MusicManager.instance:CheckHasAudioFile(MyCommon.GetSoundTypeAbName(),audio_name) == false then
				audio_name =  audio_name..1 
			end
			break
		else
			local rand = math.random(1,j);
			j = j-1
			if LRDDZ_MusicManager.instance:CheckHasAudioFile(MyCommon.GetSoundTypeAbName(),audio_name..rand) == true then
				audio_name = audio_name..rand
				break
			end
		end
	end
	return LRDDZ_MusicManager.instance:PlayAudio(obj,MyCommon.GetSoundTypeAbName(),audio_name,false,true,true,1.0)
end
--音效
function LRDDZ_SoundManager.PlaySoundEffect(name,obj,volume)
	local audio_name = soundEffect[name].Name
	if obj == nil then
		obj = LRDDZ_Game.gameObject;
	end
	if volume == nil then
 		LRDDZ_MusicManager.instance:PlaySoundEffect("Sounds",audio_name)
 	else
 		LRDDZ_MusicManager.instance:PlaySoundEffect("Sounds",audio_name,volume)
 	end
	--LRDDZ_MusicManager.instance:PlayAudio(obj,"Sounds",audio_name,false,false,true,1.0)
end
