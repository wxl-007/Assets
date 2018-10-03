local this = LuaObject:New()
HallUtil = this
this.Instance = this
function this:AddMenu(pModule)
        if pModule.menu == nil then
            pModule.menu = NGUITools.AddChild(pModule.gameObject, ResManager:LoadAsset("happycity/menu","Menu"))						
            local tGameRecordBtn = pModule.menu.transform:FindChild("GameRecord").gameObject						
            local tBankBtn = pModule.menu.transform:FindChild("Bank").gameObject						
            local tRechargeBtn = pModule.menu.transform:FindChild("Recharge").gameObject						
            local tLeaderBoardBtn = pModule.menu.transform:FindChild("leaderboard").gameObject						
            local tYbShopBtn = pModule.menu.transform:FindChild("Exchange").gameObject						
                                    
            pModule.mono:AddClick(tGameRecordBtn,function()						
                                        
            end)						
            pModule.mono:AddClick(tBankBtn,function()						
                                        
            end)						
            pModule.mono:AddClick(tRechargeBtn,function()						
                                        
            end)						
            pModule.mono:AddClick(tLeaderBoardBtn,function()										
                Utils.LoadLevelGUI("Module_Leaderboard")						
            end)						
            pModule.mono:AddClick(tYbShopBtn,function()						
                                        
            end)	
        end
end

function this:ShowPanelAni(pPanel)
	error("ShowPanelAni:"..pPanel.name)
	pPanel:SetActive(true)	
	local tAni = pPanel:GetComponent("Animator")
	tAni.transform.localScale = Vector3(0.001,0.001,0.001);
	coroutine.start(this.AfterDoing,pPanel,0, function()
		tAni.transform.localScale = Vector3(1,1,1); 
		tAni.enabled = true; 
		tAni:Play("FrameShowAnimation")
		tAni:Update(0); 		
	end);
end	
function this:HidePanelAni(pPanel)
	local tAni = pPanel:GetComponent("Animator")
	tAni.transform.localScale = Vector3(0.001,0.001,0.001);
	coroutine.start(this.AfterDoing,pPanel,0, function()
		tAni.transform.localScale = Vector3(1,1,1); 
		tAni.enabled = true; 
		tAni:Play("FrameOutAnimation")
		tAni:Update(0); 		
	end);
	coroutine.start(this.AfterDoing,pPanel,0.5, function()
		pPanel:SetActive(false)
	end);
end	

function this:AfterDoing(offset,run)																																						
	coroutine.wait(offset);																																							
	if Hall.mono then																																						
		run();																																						
	end																																						
end	

--pPanelN panel name    
function this:PopupPanel(pPanelN,pIsShow,pObj,pFunc)
	if pIsShow == true then 
		Utils.LoadAdditiveGameUIwithFunc(pPanelN,Vector3.zero,function (tObj)
		 	if tObj ~= nil then 
		 		ShowHallPanel(tObj,pIsShow,nil,function ( )
					Hall:ShowOrHideBlackBG(pIsShow)
				end)
			end
	 	end)
	else
		 ShowHallPanel(pObj,pIsShow,function ()
			EginProgressHUD.Instance:HideHUD()
			Hall:Start() 
		end,nil)
		Hall:ShowOrHideBlackBG(pIsShow)
	end
	if type(pFunc) == 'function' then 
		pFunc()
	end
end

function this:PopupSecondPanel( pObj )
	if pObj ~= nil then
		pObj.transform.localScale = Vector3.one*0.5
		pObj:SetActive(true)
		
		iTween.ScaleTo(pObj,iTween.Hash('scale',Vector3.one,'time',0.6,"islocal",true,"easetype",iTween.EaseType.easeOutElastic))
	end
end