local this = LuaObject:New()																					
Module_YBShop = this																					
function this:Awake()																					
    -- EginProgressHUD.Instance:HideHUD();																					
end																					
this.eYbShopItemType = {['real'] = 1, ['virtual']=2,['gold']=11,['phonemoney']=12}																					
function this:Start()																					
           this.mono = Hall.mono																				
           this:autoGetUI()																				
           -- EginProgressHUD.Instance:HideHUD();																					
           --数据																					
           this.totalItemPageCount = 1																					
           this.totalRecordPageCount = 1																					
           this.curItemPageIndex = 1																					
           this.curRecordPageIndex = 1																					
           this.curItemData = nil																					
           this.curRecordData = nil																					
           this.uiWWWPool = {}																					
           this.uiWWWPool1 = {}																					
           this.dataCach ={}																					
           this.uiWWWPool1["t5_10"] = this.transform:FindChild("Offset/itemPanel/icons/t5_10").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t5_20"] = this.transform:FindChild("Offset/itemPanel/icons/t5_20").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t5_30"] = this.transform:FindChild("Offset/itemPanel/icons/t5_30").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t5_50"] = this.transform:FindChild("Offset/itemPanel/icons/t5_50").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t5_100"] = this.transform:FindChild("Offset/itemPanel/icons/t5_100").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t5_200"] = this.transform:FindChild("Offset/itemPanel/icons/t5_200").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t5_300"] = this.transform:FindChild("Offset/itemPanel/icons/t5_300").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t5_500"] = this.transform:FindChild("Offset/itemPanel/icons/t5_500").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t11_10"] = this.transform:FindChild("Offset/itemPanel/icons/t11_10").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t11_20"] = this.transform:FindChild("Offset/itemPanel/icons/t11_20").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t11_50"] = this.transform:FindChild("Offset/itemPanel/icons/t11_50").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t11_100"] = this.transform:FindChild("Offset/itemPanel/icons/t11_100").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t12_10"] = this.transform:FindChild("Offset/itemPanel/icons/t12_10").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t12_30"] = this.transform:FindChild("Offset/itemPanel/icons/t12_30").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t12_50"] = this.transform:FindChild("Offset/itemPanel/icons/t12_50").gameObject:GetComponent("UITexture")																					
           this.uiWWWPool1["t12_100"] = this.transform:FindChild("Offset/itemPanel/icons/t12_100").gameObject:GetComponent("UITexture")																												
           this.uiItemPool = {}																					
           this.uiRecordPool = {}											
										
           this.ui_itemTemplate:SetActive(false)																
           this.ui_recordTemplate:SetActive(false)																															
		   --返回主界面																		
           this.mono:AddClick(this.ui_backBtn,function() 																				
                -- HallUtil:HidePanelAni(this.gameObject)									
              HallUtil:PopupPanel('Hall',false,this.gameObject,nil)                                                                    							
							
           end)										
           --拥有元宝数量												
           this.money = tonumber(EginUser.goldIngot)																		
           this.ui_ybnumLabel.text = tostring(this.money)																				
           --请求物品列表																				
           this:OnSendItemPageRequest(1)																			
           --物品翻页																		
           this.mono:AddClick(this.ui_itemPreBtn,this.OnClickItemPrePage,this)																					
           this.mono:AddClick(this.ui_itemNextBtn,this.OnClickItemNextPage,this)																		
           --记录页面											
           this.mono:AddClick(this.ui_tabRecordBtn,this.OnClickShowRecordGroup,this)			
           this.mono:AddClick(this.ui_tabDetailBtn,function ()			
             			
           end)												
           --兑换京东卡 和 手机话费											
           this.mono:AddClick(this.ui_visualCodeBtn,this.OnClickCardPwdGroupCodeBtn,this)												
           this.mono:AddClick(this.ui_visualSubBtn,this.OnClickCardPwdGroupSubmitBtn,this)													
           --兑换金币											
           this.mono:AddClick(this.ui_goldSubBtn,this.OnClickToBagGroupSubmitBtn,this)									
           -- this.mono:AddClick(this.ui_goldXYBtn,this.OnClickAgreen,this)										
           --兑换实物										
           this.mono:AddClick(this.ui_addressCodeBtn,this.OnClickuiAddressGroupSubmitBtn,this)										
           this.mono:AddClick(this.ui_addressSubBtn,this.OnClickuiAddressGroupSubmitBtn,this)										
           --返修										
           this.mono:AddClick(this.ui_serviceSubBtn,this.OnClickApplyServiceGroupSubmitBtn,this)		  																				
end																					
 																				
function this:PayMoney()																					
    if nil ~= this.curItemData then																					
        this.money = this.money - tonumber(this.curItemData.dollar)																					
        this.ui_ybnumLabel.text =  tostring(this.money)																					
    end																					
end																					
																					
 																			
																					
--兑奖记录																					
function this:OnClickShowRecordGroup()																							
    this:OnSendRecordPageRequest(this.curRecordPageIndex);																					
end																					
																					
--兑奖物品列表																					
    --上一页																					
function this:OnClickItemPrePage()																					
    if this.curItemPageIndex-1 > 0 then																					
        this:OnSendItemPageRequest(this.curItemPageIndex-1)																					
    end																					
end																					
    --下一页																					
function this:OnClickItemNextPage()																					
     if this.curItemPageIndex+1 <= this.totalItemPageCount then																					
        this:OnSendItemPageRequest(this.curItemPageIndex+1)																					
    end																					
end																					
    --请求物品数据																					
function this:OnSendItemPageRequest(pPageIndex)																					
 																					
  -- EginProgressHUD.Instance:ShowPromptHUD('加载数据中...')																					
   local tBody 		 = {}																					
   tBody['category']    = -1																					
   tBody['tradeType'] 	 = -1																					
   tBody['pageindex']   = tonumber(pPageIndex)																					
   tBody['pagesize']    = 4																					
 																					
  this.mono:Request_lua_fun("AccountService/get_awardGoods",cjson.encode(tBody),																					
      function(message)																					
      end,																					
      function(message)																					
          EginProgressHUD.Instance:ShowPromptHUD("网络中断,重连中");																					
      end)																					
end																					
    --刷新可兑换物品列表																					
function this:UpdateItem(pPageInfo,pItemList)																					
    this:clearItemGameObj(this.ui_itemGrid.transform)																					
    this.ui_itemPageLabel.text = pPageInfo['pageindex'].."/"..pPageInfo['pagecount']																					
    this.totalItemPageCount = pPageInfo['pagecount']																					
    this.curItemPageIndex = tostring(pPageInfo['pageindex'])																					
 																					
    for key,recordInfo in ipairs(pItemList) do																					
 																					
        if (type(recordInfo) == "nil") then  break; end																					
        local cell																					
        if this.uiItemPool ~= nil and  #this.uiItemPool >  0 then																					
            cell = this.uiItemPool[1]																					
            table.remove(this.uiItemPool,1)																					
        else																					
          cell = GameObject.Instantiate(this.ui_itemTemplate)																					
        end																					
 																					
        cell:SetActive(true)																					
        cell.transform.parent = this.ui_itemGrid.transform																					
        cell.transform:FindChild("id").gameObject:GetComponent("UILabel").text = recordInfo.title																					
        cell.transform:FindChild("price").gameObject:GetComponent("UILabel").text = ""..tostring(recordInfo.dollar).."元宝"																					
        local tTextureObj = {}																					
        tTextureObj.show = cell.transform:FindChild("Texture").gameObject:GetComponent("UITexture")																					
        tTextureObj.data = recordInfo																					
        coroutine.start(this.showIcon,tTextureObj);																					
        this.mono:AddClick( cell.transform:FindChild("detailBtn").gameObject,this.OnClickShowDetailGroup,tTextureObj)																					
        this.mono:AddClick( cell.transform:FindChild("dhbtn").gameObject,this.OnClickItemDetailBuyBtn,tTextureObj)																					
        this.mono:AddClick( cell.transform:FindChild("Texture").gameObject,this.OnClickItemDetailBuyBtn,tTextureObj)																					
        cell.transform.localPosition = Vector3.New(0, 0, 0)																					
        cell.transform.localScale = Vector3.one																					
																					
    end																					
    this.ui_itemGrid:GetComponent("UIGrid").repositionNow = true																					
 																					
end																					
    --放入物品列表缓存																					
function this:clearItemGameObj(pTransForm)																		
    local tLen = pTransForm.childCount-1																		
    for i=tLen,0,-1 do																		
        local pChildTrans = pTransForm:GetChild(i)																		
        --destroy(pChildTrans:FindChild("bg/Sprite").gameObject:GetComponent("UITexture").mainTexture)																		
        --pChildTrans:FindChild("bg/Sprite").gameObject:GetComponent("UITexture").mainTexture = nil																		
        --pChildTrans.gameObject:SetActive(false)																		
        destroy(pChildTrans.gameObject)																		
        --table.insert(this.uiItemPool,pChildTrans.gameObject)																		
    end																		
end																				
    --显示物品icon																					
function this:showIcon()																					
   local tKey = "nolocalimg"																	
   if self.data.rmb ~= nil then																	
     tKey = "t"..self.data.tradetype.."_"..math.floor(self.data.rmb)																		
   end																				
   if this.uiWWWPool[self.data.pic] ~= nil or this.uiWWWPool1[tKey] ~= nil then																					
       if this.uiWWWPool1[tKey] ~=nil then																					
            self.show.mainTexture = this.uiWWWPool1[tKey].mainTexture																					
       else																					
            self.show.mainTexture = this.uiWWWPool[self.data.pic].texture																					
       end																							
       self.show.gameObject:SetActive(true)																					
   else																					
       local www1 = UnityEngine.WWW.New(self.data.pic)																					
       coroutine.www(www1);																					
       self.show.mainTexture =  www1.texture																					
       this.uiWWWPool[self.data.pic] = www1																					
       self.show.gameObject:SetActive(true)																					
   end																					
end																					
    --显示物品详情																					
function this:OnClickShowDetailGroup()																					
    this.curItemData = self.data																					
    this.ui_detailPanel:SetActive(true)			
									
    --this.uiItemDetailContentLabel.text =  self.data.desc																					
    this.ui_detailItemTex.mainTexture =  self.show.mainTexture																					
    this.mono:AddClick(this.ui_detailDHBtn,this.OnClickItemDetailBuyBtn,self)																					
    this.ui_detailItemLabel.text =  self.data.desc																					
    this.ui_detailScrolView:ResetPosition()																					
end																					
																					
--物品详情																					
    --关闭物品详情																					
function this:OnClickItemDetailCloseBtn()																					
    -- this.uiItemDetailIcon.mainTexture = nil																					
    -- this.uiItemDetailGroup:SetActive(false)																					
end																					
    --购买物品																					
function this:OnClickItemDetailBuyBtn()																					
    if self.data.dollar>this.money  then																					
         EginProgressHUD.Instance:ShowPromptHUD("元宝不足下次再来！")																					
    else 											
        												
        this.curItemData = self.data																					
        -- this.ui_detailPanel:SetActive(false)																																		
        this.ui_visualPhoneInput.value = ""																					
        this.ui_visualCodeInput.value = ""			
        -- this.ui_itemGrid.transform.parent.gameObject:SetActive(self.data.tradetype == this.eYbShopItemType.gold)																				
        if self.data.tradetype == this.eYbShopItemType.real  then																					
            HallUtil:PopupSecondPanel(this.ui_addressPanel)--SetActive(true)		
            															
        elseif self.data.tradetype == this.eYbShopItemType.virtual  then																					
            -- this.ui_tabDetailBtn.gameObject:GetComponent('UIToggle').value = true	
            HallUtil:PopupSecondPanel(this.ui_visualPanel)--:SetActive(true)																					
        elseif self.data.tradetype == this.eYbShopItemType.gold  then																					
            HallUtil:PopupSecondPanel(this.ui_goldPanel)--:SetActive(true)																					
            this.ui_goldTsLabel.text = this:GetToBagStr(self.data.dollar,self.data.title)																									
        elseif self.data.tradetype == this.eYbShopItemType.phonemoney  then																					
            HallUtil:PopupSecondPanel(this.ui_visualPanel)--:SetActive(true)							
            -- this.ui_tabDetailBtn.gameObject:GetComponent('UIToggle').value = true																									
        else																					
            HallUtil:PopupSecondPanel(this.ui_visualPanel)--:SetActive(true)																
            -- this.ui_tabDetailBtn.gameObject:GetComponent('UIToggle').value = true						
        end																					
    end																					
end																					
																				
function this:GetToBagStr(pMoney,pItemName)																					
    local tStr = "您确认要花费[306391]%s元宝[-]兑换[ff0000][%s][-]?"																					
    return string.format(tStr,pMoney,pItemName)																					
end																					
																					
--收货地址																					
    --手机验证码																					
function this:OnClickAddressGroupCodeBtn()																					
    this:SendPhoneCode(this.uiAddressGroupPhoneInput.value)																					
end																					
    --发送手机验证码																					
function this:SendPhoneCode(pPhoneNum)																					
    local tBody 	  = {}																					
    tBody['phone']    = pPhoneNum																					
    local tTipStr =""																					
    if #tBody['phone']<1 then tTipStr="请填写验证手机" end																					
    if tTipStr ~="" then																					
        EginProgressHUD.Instance:ShowPromptHUD(tTipStr)																					
    else																					
        this.mono:Request_lua_fun("AccountService/send_phone_charcode",cjson.encode(tBody),function(message)																					
 																					
        end,																					
            function(message)																					
                EginProgressHUD.Instance:ShowPromptHUD(message)																					
            end);																					
    end																					
end																					
    --提交收货地址																					
function this:OnClickuiAddressGroupSubmitBtn()																					
    local tBody 		= {}																					
    tBody['id']         = this.curItemData.id																					
    tBody['contact']    = this.ui_addressNameInput.value																					
    tBody['address']    = this.ui_addressAddInput.value																					
    tBody['phone']      = this.ui_addressPhoneInput.value																					
    tBody['amount']     = 1																					
    tBody['charcode']   = this.ui_addressCodeInput.value																					
    local tTipStr =""																					
    if #tBody['contact']<1 then tTipStr="请填写姓名" end																					
    if #tBody['address']<1 then tTipStr="请填写地址" end																					
    if #tBody['phone']<11 then tTipStr="请填写手机号" end																					
    if #tBody['charcode']<1 then tTipStr="请填写验证码" end																					
    if tTipStr ~="" then																					
        EginProgressHUD.Instance:ShowPromptHUD(tTipStr)																					
    else																					
        this.mono:Request_lua_fun("AccountService/set_awardGoodsOrder",cjson.encode(tBody),function(message)																					
 																					
        end,																					
            function(message)																					
                EginProgressHUD.Instance:ShowPromptHUD(message)																					
            end);																					
    end																					
end																					
																												
--卡密兑换																					
    --手机验证码																					
function this:OnClickCardPwdGroupCodeBtn()																					
    this:SendPhoneCode(this.ui_visualPhoneInput.value)																					
end																					
    --提交兑换卡密																					
function this:OnClickCardPwdGroupSubmitBtn()																					
    if  this.curItemData.tradetype == this.eYbShopItemType.phonemoney then																					
        local tBody 		= {}																					
        tBody['mobile']     = this.ui_visualPhoneInput.value																					
        tBody['id']         = this.curItemData.id																					
        tBody['charcode']   = this.ui_visualCodeInput.value			
	     local tTipStr =""   
	     if this.UIVisualAgree.value == false then 
          tTipStr="请同意声明"
       end
      																			
        if #tBody['mobile']<11 then tTipStr="请填写手机号" end																					
        if #tBody['charcode']<1 then tTipStr="请填写验证码" end		
	
         if tTipStr ~="" then																					
            EginProgressHUD.Instance:ShowPromptHUD(tTipStr)																					
        else																					
            this.mono:Request_lua_fun("AccountService/treasure_to_mobile_fare",cjson.encode(tBody),function(message)																					
 																					
            end,																					
                function(message)																					
                    EginProgressHUD.Instance:ShowPromptHUD(message)																					
                end);																					
        end																					
    else																					
        local tBody 		= {}																					
        tBody['id']         = this.curItemData.id																					
        tBody['contact']    = EginUser.nickname																					
        tBody['address']    = ""																					
        tBody['phone']      = this.ui_visualPhoneInput.value																					
        tBody['amount']     = 1																					
        tBody['charcode']   = this.ui_visualCodeInput.value																					
        local tTipStr =""																				
        if this.UIVisualAgree.value == false then 
          tTipStr="请同意声明"
       end	
        if #tBody['phone']<11 then tTipStr="请填写手机号" end																					
        if #tBody['charcode']<1 then tTipStr="请填写验证码" end																					
        if tTipStr ~="" then																					
            EginProgressHUD.Instance:ShowPromptHUD(tTipStr)																					
        else																					
            this.mono:Request_lua_fun("AccountService/set_awardGoodsOrder",cjson.encode(tBody),function(message)																					
 																					
            end,																					
                function(message)																					
                    EginProgressHUD.Instance:ShowPromptHUD(message)																					
                end);																					
        end																					
    end																					
end																					
 								 																			
function this:OnClickToBagGroupSubmitBtn()																					
    local tBody 		= {}																					
    tBody['id']         = this.curItemData.id																					
    tBody['contact']    = EginUser.nickname																					
    tBody['address']    = ""																					
    tBody['phone']      = "13611111111"																					
    tBody['amount']     = 1																					
    tBody['charcode']   = ""	
    local tTipStr=''

    if this.ui_goldXYBtn.value == false then 
      tTipStr="请同意声明"
    end		
    if tTipStr ~= ''then 
       EginProgressHUD.Instance:ShowPromptHUD(tTipStr)
    else

      this.mono:Request_lua_fun("AccountService/set_awardGoodsOrder",cjson.encode(tBody),function(message)																					
  																				
      end,																		
          function(message)																					
              EginProgressHUD.Instance:ShowPromptHUD(message)																					
          end);		
    end																			
end												
											
--通过价格来得到充值卡id																					
function this:getPhoneMoneyID(pPrice)																					
    if pPrice==1 or pPrice=="1" then																					
        return 0																					
    elseif  pPrice==5 or pPrice=="5" then																					
        return 1																					
    elseif  pPrice==10 or pPrice=="10" then																					
        return 2																					
    elseif  pPrice==30 or pPrice=="30" then																					
        return 3																					
    elseif  pPrice==50 or pPrice=="50" then																					
        return 4																					
    elseif  pPrice==100 or pPrice=="100" then																					
        return 5																					
    end																					
    return 0																					
end																					
--兑奖记录																					
    --上一页																					
function this:OnClickRecordPrePage()																					
    if this.curRecordPageIndex-1 > 0 then																					
        this:OnSendRecordPageRequest(this.curRecordPageIndex-1)																					
    end																					
end																					
    --下一页																					
function this:OnClickRecordNextPage()																					
    if this.curRecordPageIndex+1 <= this.totalRecordPageCount then																					
        this:OnSendRecordPageRequest(this.curRecordPageIndex+1)																					
    end																					
end																					
    --请求记录数据																					
function this:OnSendRecordPageRequest(pPageIndex)																					
    -- EginProgressHUD.Instance:ShowPromptHUD('加载数据中...')																					
 																					
    if this.dataCach[pPageIndex] ~=nil then																					
        this:SocketReceiveMessage(this.dataCach[pPageIndex])																					
    else																					
        local tBody 		 = {}																					
        tBody['pageindex']   = pPageIndex																					
        tBody['pagesize']    = 3																					
        this.mono:Request_lua_fun("AccountService/get_awardGoodsRecord",cjson.encode(tBody),function(message)																					
 																					
        end,																					
            function(message)																					
                EginProgressHUD.Instance:ShowPromptHUD(message)																					
            end);																					
    end																					
end																					
    --显示记录列表																					
function this:UpdateRecord(pPageInfo,pItemList)																					
    this.ui_recordPageLabel.text = pPageInfo['pageindex'].."/"..pPageInfo['pagecount']																					
    this.totalRecordPageCount = pPageInfo['pagecount']																					
    this.curRecordPageIndex = tostring(pPageInfo['pageindex'])																					
    this:clearRecordGameObj(this.ui_recordGrid.transform)																					
    for key,recordInfo in ipairs(pItemList) do																					
        --error("key"..key..":"..recordInfo.name)																					
        if (type(recordInfo) == "nil") then  break; end																					
        local cell																					
																					
        if this.uiRecordPool ~= nil and  #this.uiRecordPool >  0 then																					
            cell = this.uiRecordPool[1]																					
            table.remove(this.uiRecordPool,1)																					
        else																					
            cell = GameObject.Instantiate(this.ui_recordTemplate)																					
        end																					
        cell.name = key																					
        --error("cell"..cell.name)																					
        cell.transform.parent = this.ui_recordGrid.transform																					
       -- cell.transform.localPosition = Vector3.New(0, (key-1)*-100, 0)																					
        cell.transform.localScale = Vector3.one																					
        cell:SetActive(true)																					
        cell.transform:FindChild("time").gameObject:GetComponent("UILabel").text = this:getMinuteStr(recordInfo.ptime)																					
        cell.transform:FindChild("name").gameObject:GetComponent("UILabel").text = recordInfo.title																					
        cell.transform:FindChild("state").gameObject:GetComponent("UILabel").text = this:getStatusTxt(recordInfo.status)																					
        local tTextureObj = {}																					
        tTextureObj.show = cell.transform:FindChild("IconTexture").gameObject:GetComponent("UITexture")																					
        tTextureObj.data = recordInfo																					
        tTextureObj.cell = cell																					
        tTextureObj.show.gameObject:SetActive(false)																					
        cell.transform:FindChild("ApplyBtn").gameObject:SetActive(recordInfo.status<4)																					
        if(recordInfo.status==3)then																					
            cell.transform:FindChild("ApplyBtn").gameObject:SetActive(false)																					
        end																					
        this.mono:AddClick( cell.transform:FindChild("ApplyBtn").gameObject,this.OnClickShowApplyService,tTextureObj)																					
        coroutine.start(this.showIcon,tTextureObj);																					
    end																					
    this.ui_recordGrid:GetComponent("UIGrid").repositionNow = true																		
end																					
function this:getMinuteStr(pStr)																					
    if pStr ~= nil and #pStr>15 then																					
        local tReversStr = string.reverse(pStr)																					
        local tPos = string.find(tReversStr,":")																					
        return string.sub(pStr,0,#pStr - tPos)																					
    end																					
    return pStr																					
end																					
function this:getStatusTxt(pStatus)																					
    if pStatus ==1 or pStatus == "1" then																					
        return "已兑换"																					
    elseif pStatus>3 then																					
        return "售后处理"																					
    end																					
    return "已兑换"																					
end																					
    --放入记录列表缓存																					
function this:clearRecordGameObj(pTransForm)																					
    local tLen = pTransForm.childCount-1																					
    for i=tLen,0,-1 do																					
        local pChildTrans = pTransForm:GetChild(i)																					
        --destroy(pChildTrans:FindChild("IconTexture").gameObject:GetComponent("UITexture").mainTexture)																					
        --pChildTrans:FindChild("IconTexture").gameObject:GetComponent("UITexture").mainTexture = nil																					
        pChildTrans.gameObject:SetActive(false)																					
        --destroy(pChildTrans.gameObject)																					
        --error("insert"..tostring(i))																					
        table.insert(this.uiRecordPool,pChildTrans.gameObject)																					
    end																					
end																					
    --打开申请售后面板																					
function this:OnClickShowApplyService()																					
    this.curRecordData = self																																								
    this.ui_serviceOrderLabel.text = self.data.orderNum																																
end																					
																					
--售后申请																					
    --关闭售后																					
function this:OnClickApplyServiceGroupCloseBtn()																					
    this.uiApplyServiceGroup:SetActive(false)																					
end																					
    --返修申请																					
function this:OnClickApplyServiceGroupSubmitBtn()																					
    local tBody 		 = {}																					
    tBody['ordernum']   =  this.ui_serviceOrderLabel.text																					
    tBody['status']     =  "4" --this.uiApplyServiceGroupStateLabel.text																					
    tBody['comment']    =  this.ui_serviceDesLabel.value																					
    local tTipStr =""																					
    if #tBody['comment']<1 then tTipStr="请填写问题描述" end																					
    if tTipStr ~="" then																					
        EginProgressHUD.Instance:ShowPromptHUD(tTipStr)																					
    else																					
        this.mono:Request_lua_fun("AccountService/change_awardGoodsOrder",cjson.encode(tBody),function(message)																					
            --print("check_cardpay back message")																					
        end,																					
            function(message)																					
                EginProgressHUD.Instance:ShowPromptHUD(message)																					
            end);																					
    end																					
end																					
																					
--说明																					
function this:OnClickAgreen()																					
    this.ui_xyPanel:SetActive(true)																																	
end																					
function this:OnClickCloseAgreen()																					
    this.uiShuomingGroup:SetActive(false)																					
end																					
																					
 																				
																					
--退出																					
function this:OnDestroy()																					
    this:clearLuaValue()																					
end																					
																					
function this:clearWWW()																					
    if this.uiWWWPool ~= nil then																					
        for tKey,tUIWWW in ipairs(this.uiWWWPool) do																					
            if tUIWWW ~= nil  then																					
                --destroy(tUIWWW.texture)																					
                --destroy(tUIWWW.textureNonReadable)																					
                tUIWWW:Dispose()																					
            end																					
        end																					
        this.uiWWWPool = {}																					
        this.uiWWWPool1 = {}																					
    end																					
end																					
    --清除变量																					
function this:clearLuaValue()																					
    this:clearItemGameObj(this.ui_itemGrid.transform)																					
    this:clearRecordGameObj(this.ui_recordGrid.transform)																					
    this:clearWWW()																					
    this.dataCach = {}																					
    -- this.uiItemDetailIcon.mainTexture = nil																					
    this.totalItemPageCount = nil																					
    this.totalRecordPageCount = nil																					
    this.curItemPageIndex = nil																					
    this.curRecordPageIndex = nil																					
    this.curItemData = nil																					
    this.curRecordData = nil																					
    this.uiItemPool = nil																					
    this.uiRecordPool = nil																					
    this.mono = nil																					
    this.gameObject = nil																					
    this.transform  = nil																					
    LuaGC()																					
    --UnityEngine.Resources.UnloadUnusedAssets()																					
end																					
																					
--消息处理																					
--[[function this.OnSocketManagerTimeOut(disconnectInfo)																					
    print(disconnectInfo);																					
end																					
function this.OnSocketDisconnect(disconnectInfo)																					
    print(disconnectInfo);																					
end--]]																					
function this:SocketDisconnect (disconnectInfo)																					
    print(disconnectInfo);																					
    -- SocketManager.LobbyInstance.socketListener = nil;																					
end																					
function this:SocketReceiveMessage( pMessageObj )																					
    local msgStr = self																					
    local msgData = cjson.decode(msgStr)																					
    if msgStr == nil then																					
        return																					
    end																					
    local tType = msgData['type']																					
    if tType == nil then																					
        print('socket receive message  type is nil ' .. type1)																					
        return																					
    end																					
																					
    local tTag = msgData['tag']																					
    if tType == 'AccountService' then																					
            --error(tTag)																					
            EginProgressHUD.Instance:HideHUD();																					
            if tTag == 'get_awardGoods' then																					
                -- local tMsg = cjson.decode(message)																					
                if msgData ~= nil then																					
                    if tostring(msgData['result']) == 'ok' then																					
                        local body = msgData["body"]																					
                        --warn("body"..type(body))																					
                        local itemPageInfo = body["page"]																					
                        --warn("itemPageInfo"..type(itemPageInfo)..itemPageInfo['total'])																					
                        local itemInfo = body["data"]																					
                        this.dataCach[itemPageInfo.pageindex] = pMessageObj																					
                        --warn("itemInfo"..itemInfo[1].title)																					
                        this:UpdateItem(itemPageInfo,itemInfo)																					
                    else																					
                        if  msgData['body'] ~=nil and msgData['body']~="" then																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['body'])																					
                        else																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['result'])																					
                        end																					
                    end																					
                end																					
            elseif  tTag =='get_awardGoodsRecord' then																					
                if msgData ~= nil then																					
                    if tostring(msgData['result']) == 'ok' then																					
                        local body = msgData["body"]																					
                        local itemPageInfo = body["page"]																					
                        local itemInfo = body["data"]																					
                        this:UpdateRecord(itemPageInfo,itemInfo)																					
                    else																					
                        if  msgData['body'] ~=nil and msgData['body']~="" then																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['body'])																					
                        else																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['result'])																					
                        end																					
                    end																					
                end																					
            elseif  tTag =='send_phone_charcode' then																					
                if msgData ~= nil then																					
                    if tostring(msgData['result']) == 'ok' then																					
                        EginProgressHUD.Instance:ShowPromptHUD('验证码已发送注意查收')																					
                    else																					
                        EginProgressHUD.Instance:ShowPromptHUD(msgData['result'])																					
                    end																					
                end																					
            elseif  tTag =='set_awardGoodsOrder' then																					
                if msgData ~= nil then																					
                    if tostring(msgData['result']) == 'ok' then																					
                        this.ui_visualPanel:SetActive(false)																					
                        this.ui_goldPanel:SetActive(false)										
                        this.ui_addressPanel:SetActive(false)																																			
                        if this.curItemData.tradetype == this.eYbShopItemType.gold  then																					
                            EginProgressHUD.Instance:ShowPromptHUD("兑换成功,游戏币已到账,稍后在银行中查收!")																					
                        else																					
                            EginProgressHUD.Instance:ShowPromptHUD("填写信息成功!等待兑奖处理")																					
                        end																																							
                        this:PayMoney()																					
                    else																					
                        if  msgData['body'] ~=nil and msgData['body']~="" then																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['body'])																					
                        else																					
                             EginProgressHUD.Instance:ShowPromptHUD(msgData['result'])																					
                        end																					
                    end																					
                end																					
            elseif tTag =="treasure_to_mobile_fare" then																					
                if msgData ~= nil then																					
                    if tostring(msgData['result']) == 'ok' then																					
                        this.ui_visualPanel:SetActive(false)																					
                        this.ui_goldPanel:SetActive(false)										
                        this.ui_addressPanel:SetActive(false)																				
                        EginProgressHUD.Instance:ShowPromptHUD('兑换成功')																														
                        this:PayMoney()																					
                    else																					
                        if  msgData['body'] ~=nil and msgData['body']~="" then																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['body'])																					
                        else																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['result'])																					
                        end																					
                    end																					
                end																					
            elseif  tTag =='change_awardGoodsOrder' then																					
                if msgData ~= nil then																					
                    if tostring(msgData['result']) == 'ok' then																					
                        this.ui_servicePanel:SetActive(false)																					
                        if this.curRecordData ~= nil then																					
                            this.curRecordData.cell.transform:FindChild("state").gameObject:GetComponent("UILabel").text = this:getStatusTxt(4)																					
                            this.curRecordData.cell.transform:FindChild("ApplyBtn").gameObject:SetActive(false)																					
                        end																														
                        EginProgressHUD.Instance:ShowPromptHUD('信息已提交,请等待处理')																					
                    else																					
                        if  msgData['body'] ~=nil and msgData['body']~="" then																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['body'])																					
                        else																					
                            EginProgressHUD.Instance:ShowPromptHUD(msgData['result'])																					
                        end																					
                    end																					
                end																					
            end																					
    end																					
end																					
																				
																				
function this:autoGetUI()								
	 this.ui_backBtn=this.transform:FindChild("topback/backBtn").gameObject									
	 this.ui_tabDhBtn=this.transform:FindChild("Offset/tabs/dhBtn").gameObject									
	 this.ui_tabRecordBtn=this.transform:FindChild("Offset/tabs/recordBtn").gameObject					
   this.ui_tabDetailBtn = this.transform:FindChild('Offset/tabs/DetailBtn').gameObject							
	 this.ui_detailItemTex=this.transform:FindChild("Offset/detailPanel/itembg/itemTexture").gameObject:GetComponent("UITexture")									
	 this.ui_detailItemLabel=this.transform:FindChild("Offset/detailPanel/content/Scroll View/nickLabel").gameObject:GetComponent("UILabel")									
	 this.ui_detailDHBtn=this.transform:FindChild("Offset/detailPanel/submitBtn").gameObject									
	 this.ui_detailPanel=this.transform:FindChild("Offset/detailPanel").gameObject									
	 this.ui_detailScrolView=this.transform:FindChild("Offset/detailPanel/content/Scroll View").gameObject:GetComponent("UIScrollView")									
	 this.ui_phone_submitBtn=this.transform:FindChild("Offset/detailPanel/submitBtn").gameObject									
	 this.ui_tjBtn=this.transform:FindChild("Offset/detailPanel/submitBtn").gameObject									
	 this.ui_recordGrid=this.transform:FindChild("Offset/record/recordGrid").gameObject									
	 this.ui_recordPrefBtn=this.transform:FindChild("Offset/record/turnpage/prePage").gameObject									
	 this.ui_recordPageLabel=this.transform:FindChild("Offset/record/turnpage/page").gameObject:GetComponent("UILabel")									
	 this.ui_recordNextBtn=this.transform:FindChild("Offset/record/turnpage/nextPage").gameObject									
	 this.ui_recordTemplate=this.transform:FindChild("Offset/record/recordItem").gameObject									
	 this.ui_ybnumLabel=this.transform:FindChild("Offset/itemPanel/nowmoney/ybnumLabel").gameObject:GetComponent("UILabel")									
	 this.ui_itemGrid=this.transform:FindChild("Offset/itemPanel/grid").gameObject									
	 this.ui_itemTemplate=this.transform:FindChild("Offset/itemPanel/ybitem").gameObject									
	 this.ui_itemPreBtn=this.transform:FindChild("Offset/itemPanel/turnpage/prePage").gameObject									
	 this.ui_itemPageLabel=this.transform:FindChild("Offset/itemPanel/turnpage/page").gameObject:GetComponent("UILabel")									
	 this.ui_itemNextBtn=this.transform:FindChild("Offset/itemPanel/turnpage/nextPage").gameObject									
	 this.ui_visualPhoneInput=this.transform:FindChild("Offset/visualPanel/Grid/phone/bg/input").gameObject:GetComponent("UIInput")									
	 this.ui_visualCodeInput=this.transform:FindChild("Offset/visualPanel/Grid/code/bg/input").gameObject:GetComponent("UIInput")									
	 this.ui_visualCodeBtn=this.transform:FindChild("Offset/visualPanel/Grid/code/codeBtn").gameObject									
	 this.ui_visualSubBtn=this.transform:FindChild("Offset/visualPanel/submitBtn").gameObject									
	 this.ui_visualPanel=this.transform:FindChild("Offset/visualPanel").gameObject	

	 this.ui_goldCloseBtn=this.transform:FindChild("Offset/goldPanel/closeBtn").gameObject									
	 this.ui_goldTsLabel=this.transform:FindChild("Offset/goldPanel/ts").gameObject:GetComponent("UILabel")									
	 this.ui_goldXYBtn=this.transform:FindChild("Offset/goldPanel/xytxt/checkBtn").gameObject:GetComponent('UIToggle')									
	 this.ui_goldSubBtn=this.transform:FindChild("Offset/goldPanel/submitBtn").gameObject									
	 this.ui_goldPanel=this.transform:FindChild("Offset/goldPanel").gameObject									
	 this.ui_serviceCloseBtn=this.transform:FindChild("Offset/servicePanel/closeBtn").gameObject									
	 this.ui_serviceOrderLabel=this.transform:FindChild("Offset/servicePanel/Grid/order/bg/input").gameObject:GetComponent("UILabel")									
	 this.ui_serviceDesLabel=this.transform:FindChild("Offset/servicePanel/Grid/des/bg/input").gameObject:GetComponent("UIInput")									
	 this.ui_serviceSubBtn=this.transform:FindChild("Offset/servicePanel/submitBtn").gameObject									
	 this.ui_servicePanel=this.transform:FindChild("Offset/servicePanel").gameObject									
	 this.ui_xyCloseBtn=this.transform:FindChild("Offset/xyPanel/closeBtn").gameObject									
	 this.ui_xyPanel=this.transform:FindChild("Offset/xyPanel").gameObject									
	 this.ui_xyContentLabel=this.transform:FindChild("Offset/xyPanel/txt/Scroll View/ts").gameObject:GetComponent("UILabel")									
	 this.ui_addressPanel=this.transform:FindChild("Offset/addressPanel").gameObject									
	 this.ui_addressCloseBtn=this.transform:FindChild("Offset/addressPanel/offset/closeBtn").gameObject									
	 this.ui_addressNameInput=this.transform:FindChild("Offset/addressPanel/offset/nickname/input").gameObject:GetComponent("UIInput")									
	 this.ui_addressAddInput=this.transform:FindChild("Offset/addressPanel/offset/address/input").gameObject:GetComponent("UIInput")									
	 this.ui_addressPhoneInput=this.transform:FindChild("Offset/addressPanel/offset/phone/input").gameObject:GetComponent("UIInput")									
	 this.ui_addressCodeInput=this.transform:FindChild("Offset/addressPanel/offset/code/input").gameObject:GetComponent("UIInput")									
	 this.ui_addressCodeBtn=this.transform:FindChild("Offset/addressPanel/offset/code/codeBtn").gameObject									
	 this.ui_addressXyBtn=this.transform:FindChild("Offset/addressPanel/offset/xytxt").gameObject									
	 this.ui_addressSubBtn=this.transform:FindChild("Offset/addressPanel/offset/submitBtn").gameObject
   this.UIVisualAgree =  this.ui_visualPanel.transform:FindChild('AgreeBtn').gameObject:GetComponent('UIToggle')

end																				
function this:autoClearUI()								
	 this.ui_backBtn= nil									
	 this.ui_tabDhBtn= nil									
	 this.ui_tabRecordBtn= nil									
	 this.ui_detailItemTex=nil									
	 this.ui_detailItemLabel=nil									
	 this.ui_detailDHBtn= nil									
	 this.ui_detailPanel= nil									
	 this.ui_detailScrolView=nil									
	 this.ui_phone_submitBtn= nil									
	 this.ui_tjBtn= nil									
	 this.ui_recordGrid= nil									
	 this.ui_recordPrefBtn= nil									
	 this.ui_recordPageLabel=nil									
	 this.ui_recordNextBtn= nil									
	 this.ui_recordTemplate= nil									
	 this.ui_ybnumLabel=nil									
	 this.ui_itemGrid= nil									
	 this.ui_itemTemplate= nil									
	 this.ui_itemPreBtn= nil									
	 this.ui_itemPageLabel=nil									
	 this.ui_itemNextBtn= nil									
	 this.ui_visualPhoneInput=nil									
	 this.ui_visualCodeInput=nil									
	 this.ui_visualCodeBtn= nil									
	 this.ui_visualSubBtn= nil									
	 this.ui_visualPanel= nil									
	 this.ui_goldCloseBtn= nil									
	 this.ui_goldTsLabel=nil									
	 this.ui_goldXYBtn= nil									
	 this.ui_goldSubBtn= nil									
	 this.ui_goldPanel= nil									
	 this.ui_serviceCloseBtn= nil									
	 this.ui_serviceOrderLabel=nil									
	 this.ui_serviceDesLabel=nil									
	 this.ui_serviceSubBtn= nil									
	 this.ui_servicePanel= nil									
	 this.ui_xyCloseBtn= nil									
	 this.ui_xyPanel= nil									
	 this.ui_xyContentLabel=nil									
	 this.ui_addressPanel= nil									
	 this.ui_addressCloseBtn= nil									
	 this.ui_addressNameInput=nil									
	 this.ui_addressAddInput=nil									
	 this.ui_addressPhoneInput=nil									
	 this.ui_addressCodeInput=nil									
	 this.ui_addressCodeBtn= nil									
	 this.ui_addressXyBtn= nil									
	 this.ui_addressSubBtn= nil									
end																				
																			
																		
																	
																
															
														
													
												
											
										
									
								
							
						
					
				
			
		
	

