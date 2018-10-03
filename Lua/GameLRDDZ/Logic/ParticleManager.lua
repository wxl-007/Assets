ParticleManager = {}
local self = ParticleManager

function ParticleManager.Init()
	self.ParticleList = {}
	self.time = Timer.New(self.ReFunc, 1, -1, true)
	self.time:Start()
end 

function ParticleManager.ReFunc()
	for i= #self.ParticleList, 1, -1 do 
	 	if self.ParticleList[i].time > 0 then 
	 		self.ParticleList[i].time = self.ParticleList[i].time -1
	 	else 
			destroy(self.ParticleList[i].GameObject)
			table.remove(self.ParticleList,i)
		end 
	end 
end 

--创建粒子特效
function ParticleManager.ShowParticle(abname, assetname,scale,position,rotation,time)
	if MyCommon.GetGameEffState() ~= 1 then return end
	LRDDZ_ResourceManager.Instance:Create3DOjbect(abname,assetname, assetname,scale,position, false,function(obj,name)
		obj.transform.localRotation = Quaternion.Euler(rotation.x, rotation.y, rotation.z)

		local par = {}
		 par.name = name
		 par.GameObject = obj
		 par.time = time
		 --table.insert(self.ParticleList,par)
		 if time~= nil then
		 	GameObject.Destroy(obj,time)
		 end
	end,nil)
end
--飞机
function ParticleManager.PlaneFly(character_type)
	if MyCommon.GetGameEffState() ~= 1 then return end
	local startPoint = nil
	local sex = 1
	local name =""
	if character_type == CharacterType.Player then
		startPoint = Vector3.New(294.4,32.8,53) 
		sex = Avatar.avatarSex--判断男女
		if sex == 1 then
			name = "feijiPlayer".."nan"
		else
			name = "feijiPlayer".."nv"
		end
	else
		--startPoint = Vector3.New(296.92,15,-8.62) 
		startPoint = Vector3.New(294.4,32.8,53) 
		sex = Computer.sex		
		if sex == 1 then
			name = "feijiPlayer".."nan"
		else
			name = "feijiPlayer".."nv"
		end
	end
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle",name, name,Vector3.New(1,1,1),startPoint, false,function(obj,name)
		coroutine.start(ParticleManager.PlaneMove,obj,character_type,sex)
	end,nil)
	LRDDZ_SoundManager.PlaySoundEffect("plane");
end
function ParticleManager.PlaneMove(obj,character_type,sex)
	--飞机拖尾特效
	local effname = ""
	if sex == 1 then 
		effname = "feijinan"
	else
		effname = "feijinv"
	end
	
	if character_type == CharacterType.Player then
		self.ShowParticle("Particle",effname,Vector3.New(1,1,1),Vector3.New(-6.2,25.2,39.4),Vector3.New(0,42.0679,0),3)
	else
		self.ShowParticle("Particle",effname,Vector3.New(1,1,1),Vector3.New(-6.2,25.2,39.4),Vector3.New(0,42.0679,0),3)
	end

	coroutine.wait(2.6)
	destroy(obj)
end
--炸弹
function ParticleManager.Boom(character_type)
	if MyCommon.GetGameEffState() ~= 1 then return end
	coroutine.start(self.BoomFunc,character_type)
end
function ParticleManager.BoomFunc(character_type)
	local bombname = ""
	if character_type == CharacterType.Player then	--判断角色和性别
		if Avatar.avatarSex == 1 then
			bombname = "zhadannan"
		elseif Avatar.avatarSex == 2 then
			bombname = "zhadannv"
		end
	elseif character_type == CharacterType.Computer then
		if Computer.sex == 1 then
			bombname = "zhadannan"
		elseif Computer.sex == 2 then
			bombname = "zhadannv"
		end
	else
		if OtherComputer.sex == 1 then
			bombname = "zhadannan"
		elseif OtherComputer.sex == 2 then
			bombname = "zhadannv"
		end
	end
	coroutine.wait(0.3)	--等待手打到桌上然后爆炸时间
	self.ShowParticle("Particle",bombname,Vector3.New(1,1,1),Vector3.New(6.9,24.3,-2.1),Vector3.New(0,0,0),3)
	LRDDZ_SoundManager.PlaySoundEffect("boom");
	

	coroutine.wait(0.8)--等待炸弹特效完成时间
	--震动
	--UnityEngine.Handheld.Vibrate()
	--震动镜头
	local mainCamera = find("MainCamera")
    iTween.ShakePosition(mainCamera,iTween.Hash("x",0.1,"y",0.1,"z",0,"time",0.2,"easetype",iTween.EaseType.linear))
	if character_type == CharacterType.Player then --如果是玩家使出炸弹
		--LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","gaogenxie","gaogenxie",Vector3.New(15,15,15),Vector3.New(299.49,14.59,1.93),false,function(obj,name)
		--	obj:GetComponent('Animator'):SetBool("Player",true)
		--	coroutine.start(self.Destorygaogenxie,obj)
		--end)
	else	--否则是电脑
		--LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","gaogenxie","gaogenxie",Vector3.New(15,15,15),Vector3.New(299.49,14.59,1.93),false,function(obj,name)
		--	obj:GetComponent('Animator'):SetBool("Computer",true)
		--	coroutine.start(self.Destorygaogenxie,obj)
		--end)
	end


	--更换背景音乐
	--[[
	local audioSource = LRDDZ_MusicManager.instance.GetAudioSource
	if audioSource ~= nil and (audioSource.clip.name ~= "bgsound4" and audioSource.clip.name ~= "bgsound5") then
        local rand = math.random(4,5);
        LRDDZ_MusicManager.instance:PlayMuisc("bgsound"..rand, true, true, false, 0.5)
    end
    ]]
end
function ParticleManager.Destorygaogenxie(obj)
	coroutine.wait(1.8)
	destroy(obj)
end
--火箭
function ParticleManager.JokerBoom(character_type)
	if MyCommon.GetGameEffState() ~= 1 then return end
	local startPoint = nil 
	startPoint = Vector3.New(4.2,0.5,33.6)

	
	LRDDZ_ResourceManager.Instance:Create3DOjbect("Particle","huojian", "huojian",Vector3.New(1,1,1),startPoint, false,function(obj,name)
		coroutine.start(ParticleManager.RocketMove,obj,character_type,sex)
		LRDDZ_SoundManager.PlaySoundEffect("jokerBoom");
	end,nil)
	--更换背景音乐
	--[[
	local audioSource = LRDDZ_MusicManager.instance.GetAudioSource
	if audioSource ~= nil and (audioSource.clip.name ~= "bgsound4" and audioSource.clip.name ~= "bgsound5") then
        local rand = math.random(4,5);
        LRDDZ_MusicManager.instance:PlayMuisc("bgsound"..rand, true, true, false, 0.5)
    end
    ]]

end
function ParticleManager.RocketMove(obj,character_type,sex)
	--震动镜头
	local mainCamera = find("MainCamera")
    iTween.ShakePosition(mainCamera,iTween.Hash("x",0.1,"y",0,"z",0,"time",0.1,"easetype",iTween.EaseType.linear))
    iTween.ShakePosition(mainCamera,iTween.Hash("x",0.2,"y",0,"z",0,"time",0.2,"delay",0.1,"easetype",iTween.EaseType.linear))
    	--震动
	--UnityEngine.Handheld.Vibrate()
   
    coroutine.wait(1.5);    
    --obj.transform:FindChild("huojian").localRotation = Quaternion.Euler(Vector3.New(0,180,180));
    iTween.ShakePosition(mainCamera,iTween.Hash("x",0.1,"y",0,"z",0,"time",0.1,"easetype",iTween.EaseType.linear))
    iTween.ShakePosition(mainCamera,iTween.Hash("x",0.2,"y",0,"z",0,"time",0.2,"delay",0.1,"easetype",iTween.EaseType.linear))
    LRDDZ_SoundManager.PlaySoundEffect("boom");
	coroutine.wait(1.5) --等待显示牌的出现
	
	destroy(obj)
	
end 
function ParticleManager.PopCard(charactertype)
	--出牌特效
	if MyCommon.GetGameEffState() ~= 1 then return end
	local startPoint = nil 
	local startRotation = nil
	if charactertype == CharacterType.Player then
		startPoint = Vector3.New(312.9521,-40.53133,-71.85843)
		startRotation = Vector3.New(-90,175,0)
	elseif charactertype == CharacterType.Computer then
		startPoint = Vector3.New(274.17,-27.1,-64)
		startRotation = Vector3.New(-90,5,0)
	else
		startPoint = Vector3.New(328.9,-27.1,-71.85843)
		startRotation = Vector3.New(-90,175,0)
	end
	self.ShowParticle("Particle","NewPlay",Vector3.New(1,1,1),startPoint,startRotation,3)
end
function ParticleManager.Win()
	if MyCommon.GetGameEffState() ~= 1 then return end
	local startPoint = Vector3.New(299.36,35.41,40.32) 
	local startRotation = Vector3.New(-29.44299,0.3622,0.5799)
	self.ShowParticle("Particle","ShengLi",Vector3.New(1,1,1),startPoint,startRotation)
end
function ParticleManager.Clear()
	self.ParticleList = {}
end 