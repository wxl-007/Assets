
QBSKPlayer = {}
local self = QBSKPlayer
local this = self


self.library = {}



function this.Clear()
	self.library = {}
	self.promptCards = {}
	self.promptNum = 1
	self.promptObject = {}
	this.SetLandlordIcon(false,false)
	this.IsShowCard(false)
	--清空手上的牌
	for k,obj in pairs(self.CardObjectList) do 
		self.behaviour:MyDestroy(obj.GameObject)
	end 
	self.CardObjectList = {}
	recLastCard = nil
	self.OtherOutCard=-1;
	self.OtherOutCardType=-1;
end 
function this.ClearDealCard()
	EginTools.ClearChildren(self.PlacePoint.transform)
	self.DealCardObjList = {}
end 
---------------------------------------------------------------------------

local transform
local gameObject


self.isCanSelected = false --是否可点击

function this.Awake(obj)
	gameObject = obj
	transform = obj.transform

	self.CardObjectList = {} --拥有的牌

	self.DealCardObjList = {} --出的牌

	self.promptCards = {}
	self.promptNum = 1
	self.promptObject = {}

	self.init()
end 

--注销
function this.OnDestroy()
	self.library = {}
	self.CardObjectList = {}
 	mousePosition = nil
end 
--初始化
function  this.init()
	self.behaviour = gameObject:GetComponent('LRDDZ_LuaBehaviour');
    self.talk = transform:FindChild("talk").gameObject
    self.talk_desc = transform:FindChild("talk/Label_desc"):GetComponent("UILabel")
    self.talk:SetActive(false)
	self._cardPre = "card_";
	self.ownCard_prb=ResManager:LoadAsset("gameqbsk/prefab","ownCard");--实例化自己的牌的预制件
	self.selectedCards={};
	self.OtherOutCard=-1;
	self.OtherOutCardType=-1;
	self.paixing=-1;
end 



--发牌动画(先发牌后排序)
function this.PutUICards(count,cardsList,isBanker)
	self.CardObjectList={};
	--log("开始发牌");
	self.library= cardsList;
	local count = #self.library
	local cardParent=transform:FindChild("cardParent");
	for i = 1, #self.library do 	
		local obj=GameObject.Instantiate(self.ownCard_prb);
		obj.name=tostring(i);
		obj.transform.parent = cardParent.transform;
		obj.transform.localScale = Vector3.New(1,1,1);
		obj.transform.localPosition=Vector3.New(50*(i-1),0,-10*i);
		local CardInfo = {}
		CardInfo.GameObject = obj 
		table.insert(self.CardObjectList,CardInfo)

		--printf(self.CardObjectList);
		--log(i);
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").depth = 40+ i
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").spriteName =self._cardPre..self.library[i]
		
		cardParent.localPosition=Vector3.New(-25*(i-1),0,0);
		
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite"):MakePixelPerfect()
		
		self.CardObjectList[i].Card = self.library[i]
		self.CardObjectList[i].Selected = false;--手里牌是否是选择状态
		self.CardObjectList[i].isTouching = false
		self.CardObjectList[i].isUp=false;--手里牌是否提升位置
		
		
		
		if tonumber(self.library[i])<52 then
			self.CardObjectList[i].weight=(tonumber(self.library[i]))%13+1;
			if self.CardObjectList[i].weight==13 then
				self.CardObjectList[i].weight=18;
			end
		else
			if tonumber(self.library[i])==52 then
				self.CardObjectList[i].weight=19;
			elseif tonumber(self.library[i])==53 then
				self.CardObjectList[i].weight=20;
			end
		end
		UISoundManager.Instance.PlaySound("fa")
		coroutine.wait(0.2)
		
		if i==count then
			--手里牌排序
			self.CardObjectList=QBSKCardRule.SortCardsFunc(self.CardObjectList,true)
			for i=1,#(self.CardObjectList) do
				--log(self.CardObjectList[i].Card.."======="..i);
				--给手里排好序的牌的位置和可点击的区域以及深度进行重新赋值
				if i==count then
					self.CardObjectList[i].offset=120;
				else
					self.CardObjectList[i].offset=0;
				end
				self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").depth = 40+ i
				self.CardObjectList[i].GameObject.transform.localPosition=Vector3.New(50*(i-1),0,-10*i);
			end
			--log(isBanker);
			--log("自己是否是庄家");
			self.isCanSelected=true;
			if isBanker then
				coroutine.wait(0.2);
				
				GameQBSK:SetTiShi(true,0);
				GameQBSK.UserPlayerCtrl:HideOrShowTime(true);
			end
		end
		
		
	end 
end

function this.PutLateUICards(cardsList)
	self.CardObjectList={};
	--log("开始发牌");
	self.library= cardsList;
	local count = #self.library
	local cardParent=transform:FindChild("cardParent");
	for i = 1, #self.library do 	
		local obj=GameObject.Instantiate(self.ownCard_prb);
		obj.name=tostring(i);
		obj.transform.parent = cardParent.transform;
		obj.transform.localScale = Vector3.New(1,1,1);
		obj.transform.localPosition=Vector3.New(50*(i-1),0,-10*i);
		local CardInfo = {}
		CardInfo.GameObject = obj 
		table.insert(self.CardObjectList,CardInfo)

		--printf(self.CardObjectList);
		--log(i);
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").depth = 40+ i
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").spriteName =self._cardPre..self.library[i]
		
		cardParent.localPosition=Vector3.New(-25*(i-1),0,0);
		
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite"):MakePixelPerfect()
		
		self.CardObjectList[i].Card = self.library[i]
		self.CardObjectList[i].Selected = false;--手里牌是否是选择状态
		self.CardObjectList[i].isTouching = false
		self.CardObjectList[i].isUp=false;--手里牌是否提升位置
		
		
		
		if tonumber(self.library[i])<52 then
			self.CardObjectList[i].weight=(tonumber(self.library[i]))%13+1;
			if self.CardObjectList[i].weight==13 then
				self.CardObjectList[i].weight=18;
			end
		else
			if tonumber(self.library[i])==52 then
				self.CardObjectList[i].weight=19;
			elseif tonumber(self.library[i])==53 then
				self.CardObjectList[i].weight=20;
			end
		end
		
		if i==count then
			coroutine.wait(0.2);
			--手里牌排序
			self.CardObjectList=QBSKCardRule.SortCardsFunc(self.CardObjectList,true)
			for i=1,#(self.CardObjectList) do
				--log(self.CardObjectList[i].Card.."======="..i);
				--给手里排好序的牌的位置和可点击的区域以及深度进行重新赋值
				if i==count then
					self.CardObjectList[i].offset=120;
				else
					self.CardObjectList[i].offset=0;
				end
				self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").depth = 40+ i
				self.CardObjectList[i].GameObject.transform.localPosition=Vector3.New(50*(i-1),0,-10*i);
			end	
		end	
	end 
end


local recStartPos = nil
local touchCard = false --是否触摸到手里某张牌
local startCard=nil;
local startX=0;
local isMove=false;
--滑动检测
function this.Update()
	--log("-------++++++++++++--------Update---------+++++++++-------");
	if GameQBSK.biaoqingBgShow==true then
		return;
	end
	if GameQBSK.tuoguanBgShow==true then
		return;
	end
	--log(self.isCanSelected);
	if self.isCanSelected == false  then
		return 
	end 
	if Input.GetMouseButtonDown(0) then	
		recStartPos = self.ScreenToUI(Input.mousePosition);
		--log(recStartPos.x);
		for k,value in pairs(self.CardObjectList) do 
	        if (recStartPos.x > value.GameObject.transform.localPosition.x - 90 and recStartPos.x < value.GameObject.transform.localPosition.x - 25 + value.offset  and
	        	recStartPos.y > value.GameObject.transform.localPosition.y - 125 and recStartPos.y < value.GameObject.transform.localPosition.y + 125) then 
	        	touchCard = true
				startCard=value;
				value.GameObject.transform:GetComponent("UISprite").color =  Color.New(124/255, 124/255, 124/255, 1)
				if not value.Selected then
					value.Selected=true;
				else
					value.Selected=false;
				end
				startX=recStartPos.x;
	        	break;
	    	end
	    end
		--log(touchCard);
	elseif Input.GetMouseButtonUp(0) then
		touchCard=false;
		--if isMove then
			--log("isDown=false");
			for i=1,#(self.CardObjectList) do
				--log(self.CardObjectList[i].Card.."------------"..self.CardObjectList[i].weight);
				local ownPosition=self.CardObjectList[i].GameObject.transform.localPosition;
				if self.CardObjectList[i].Selected==true then
					--log(self.CardObjectList[i].Card.."======================="..self.CardObjectList[i].weight);
					self.CardObjectList[i].GameObject.transform.localPosition=Vector3.New(ownPosition.x,60,ownPosition.z);
					self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(1, 1, 1, 1)
					self.CardObjectList[i].isUp=true;					
				else
					self.CardObjectList[i].GameObject.transform.localPosition=Vector3.New(ownPosition.x,0,ownPosition.z);
					self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(1, 1, 1, 1)
					self.CardObjectList[i].isUp=false;	
				end
			end
			self.AutoSelectCard();--确认选中的牌的类型
		--end
		isMove=false;
	end
	
	if touchCard then
		recStartPos = self.ScreenToUI(Input.mousePosition);
		if not isMove then
			if math.abs(recStartPos.x-startX)>10 then
				isMove=true;
			end
		end
		if isMove then		
			self.rangeSelect(recStartPos.x);
		end
	end
	
	
end

--滑动选牌的判断
function this.rangeSelect(nowX)
	local isR=((nowX-startX)>0);
	for i=1,#(self.CardObjectList) do
		if self.CardObjectList[i]~=nil and self.CardObjectList[i]~=startCard then
			local x_left=self.CardObjectList[i].GameObject.transform.localPosition.x - 90;
			local x_right=self.CardObjectList[i].GameObject.transform.localPosition.x - 25 + self.CardObjectList[i].offset
			if isR then
				if  x_left<nowX and x_left>startX then
					self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(124/255, 124/255, 124/255, 1)
					local ownPosition=self.CardObjectList[i].GameObject.transform.localPosition;
					if ownPosition.y==0 then
						self.CardObjectList[i].Selected=true;
					else
						self.CardObjectList[i].Selected=false;
					end
				else
					self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(1, 1, 1, 1)
					if not self.CardObjectList[i].isUp then
						self.CardObjectList[i].Selected=false;
					else
						self.CardObjectList[i].Selected=true;
					end
				end
			else
				if x_right>nowX and x_right<startX then
					self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(124/255, 124/255, 124/255, 1)
					local ownPosition=self.CardObjectList[i].GameObject.transform.localPosition;
					if ownPosition.y==0 then
						self.CardObjectList[i].Selected=true;
					else
						self.CardObjectList[i].Selected=false;
					end
				else
					self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(1, 1, 1, 1)
					if not self.CardObjectList[i].isUp then
						self.CardObjectList[i].Selected=false;
					else
						self.CardObjectList[i].Selected=true;
					end
				end
			end
		end
	end
end

function  this.ChongZhiCards()
	for i=1,#(self.CardObjectList) do
		local ownPosition=self.CardObjectList[i].GameObject.transform.localPosition;
		self.CardObjectList[i].Selected=false;
		self.CardObjectList[i].GameObject.transform.localPosition=Vector3.New(ownPosition.x,0,ownPosition.z);
		self.CardObjectList[i].GameObject.transform:GetComponent("UISprite").color =  Color.New(1, 1, 1, 1)
		self.CardObjectList[i].isUp=false;	
	end
end

--鼠标与屏幕坐标转换
local mousePosition = nil
function  this.ScreenToUI(pos)
	if mousePosition == nil then
		mousePosition = transform:FindChild("cardParent/mousePosition")
	end
	--测试是否为空
	local function trymousePosition()
		local x = mousePosition.position
	end
	if pcall(trymousePosition) then
		mousePosition.position = UICamera.currentCamera:ScreenToWorldPoint(pos)
		return mousePosition.localPosition
	else
		mousePosition = transform:FindChild("cardParent/mousePosition")
		mousePosition.position = UICamera.currentCamera:ScreenToWorldPoint(pos)
		return mousePosition.localPosition
	end
end 


--滑动选牌之后判断提起的牌是否是一个牌型
function this.AutoSelectCard()	
		--遍历手中提起的牌
		self.selectedCards = {}
		for i=1,#(self.CardObjectList) do
			if self.CardObjectList[i].Selected == true then
				--log(self.CardObjectList[i].Card);
				table.insert(self.selectedCards,self.CardObjectList[i]);
			end
		end
		--log(#(selectedCards).."=====选牌个数");
		--把这些牌相同牌值的归类，确定提起牌的牌型
		
		local selectArray=-1;
		local selectCount=-1;
		if #(self.selectedCards)>0 then
			self.paixing,selectArray,selectCount=self.jianCeCardType(self.selectedCards);
			--log(self.paixing.."========所选牌型");
			--log(selectArray);
			self.IsCanOutCard(self.paixing,selectArray,selectCount);
			
		else
			GameQBSK:SetTiShi(false,0);
		end	
end

--上一个玩家打出的牌以及所打牌的牌型
function this.SetOtherCardInfo(put_type,put_cards)
	if put_cards~=nil and #(put_cards)>0 then
		if tonumber(put_cards[1])<52 then
			self.OtherOutCard=tonumber(put_cards[1])%13+1;
			if self.OtherOutCard==13 then
				self.OtherOutCard=18;
			end
		else
			if tonumber(put_cards[1])==52 then
				self.OtherOutCard=19;
			elseif tonumber(put_cards[1])==53 then
				self.OtherOutCard=20;
			end
		end
		self.OtherOutCardCount=#(put_cards);
	else
		self.OtherOutCard=-1;
		self.OtherOutCardCount=0;
	end
	self.OtherOutCardType=put_type;
	local tishiArray=self.tiShiFun();
	return tishiArray;
end

--检测能不能出牌
function this.IsCanOutCard(cardtype,cardArray,cardCount)
	local isChu=false;
	if self.OtherOutCardType<1 then
		isChu=true;
	else
		if self.OtherOutCardType<10 then--如果对方出牌的牌型是单、对、三张、单顺、连对、连三张 
			if cardtype==self.OtherOutCardType and cardArray>self.OtherOutCard and cardCount==self.OtherOutCardCount then--选牌的牌数量、牌型相同，最小一位大于对方出牌的最小一位
				isChu=true;
			elseif cardtype>40 then--自己出的是炸弹的话
				isChu=true;
			end
		elseif self.OtherOutCardType>10 then
			if cardtype==self.OtherOutCardType and cardArray>self.OtherOutCard then--牌型相同，最小一位大于对方出牌的最小一位
				isChu=true;
			elseif cardtype>self.OtherOutCardType then--牌型大于对方
				isChu=true;
			end
		end
	end
	--log(cardtype.."============"..self.OtherOutCardType);
	--log("是否能出牌");
	--log(isChu);
	if isChu then
		GameQBSK:SetTiShi(false,cardtype);
	else
		GameQBSK:SetTiShi(false,0);
	end
end


--主玩家出牌操作
function this.OutCard()
	local cards={};
	for i=1,#(self.selectedCards) do
		table.insert(cards,self.selectedCards[i].Card);
	end
	GameQBSK.autoOutCardList=cards;
	
	local outcard = {type="shuangkou",tag="play",body=cards}; 	
	local jsonStr = cjson.encode(outcard);
	GameQBSK.mono:SendPackage(jsonStr);
	
	
	local cardParent=transform:FindChild("cardParent");
	for i=1,#(self.selectedCards) do
		self.selectedCards[i].GameObject.transform.parent=GameQBSK.outCardParent;
		self.selectedCards[i].GameObject.transform.localScale=Vector3.one;
		self.selectedCards[i].GameObject.transform.localPosition=Vector3.New(40*(i-1),0,0);
		self.selectedCards[i].GameObject.transform:GetComponent("UISprite").depth = 10+ i
		self.selectedCards[i].GameObject.transform:GetComponent("UISprite").width=142;
		self.selectedCards[i].GameObject.transform:GetComponent("UISprite").height=194;
	end
	GameQBSK.outCardParent.transform.localPosition=Vector3.New(-20*(#(cards)-1),GameQBSK.outCardParent.localPosition.y,0);
	for i=1,#(self.selectedCards) do
		if tableContains(self.CardObjectList,self.selectedCards[i]) then
			iTableRemove(self.CardObjectList,self.selectedCards[i]);
		end
	end
	
	if #(self.CardObjectList)>0 and self.paixing>10 then
		GameQBSK:PlayCardSound(self.paixing,GameQBSK.UserPlayerCtrl.sex);
	end
	
	for i=1,#(self.CardObjectList) do
		self.CardObjectList[i].GameObject.transform.localPosition=Vector3.New(50*(i-1),0,-10*i);
		if i == #(self.CardObjectList) then 
			self.CardObjectList[i].offset = 120
		else 
			self.CardObjectList[i].offset = 0
		end 
	end
	cardParent.localPosition=Vector3.New(-25-25*(#(self.CardObjectList)-1),0,0);
end

function this.SetLatePutOut(cardtype,outcards)
	local cards={};
	local cardParent=transform:FindChild("cardParent");
	for i=1,#(outcards) do
		local obj=GameObject.Instantiate(self.ownCard_prb);
		obj.transform.parent=GameQBSK.outCardParent;
		obj.transform.localScale=Vector3.one;
		obj.transform.localPosition=Vector3.New(40*(i-1),0,0);
		obj.transform:GetComponent("UISprite").depth=10+i;
		obj:GetComponent("UISprite").width=142;
		obj:GetComponent("UISprite").height=194;
		obj.transform:GetComponent("UISprite").spriteName=self._cardPre..tonumber(outcards[#(outcards)-i+1]);
		table.insert(cards,obj);
	end
	GameQBSK.outCardParent.transform.localPosition=Vector3.New(-20*(#(cards)-1),GameQBSK.outCardParent.localPosition.y,0);
	if #(self.CardObjectList)>0 and cardtype>10 then
		GameQBSK:PlayCardSound(self.paixing,GameQBSK.UserPlayerCtrl.sex);
	end
end


--销毁主玩家打出的牌
function this.DestroyCards()
	local sprites = GameQBSK.outCardParent:GetComponentsInChildren(Type.GetType("UISprite",true));
	for i=0,sprites.Length-1 do
		local sprite = sprites[i];
		destroy(sprite.gameObject);
	end
end


--生成对位数组
function this.doDuiweiArray(cardList)
	local zhangArray={{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}};
	for i=1,#(cardList) do
		table.insert(zhangArray[cardList[i].weight],cardList[i]);
	end
	--[[
	for i=1,#(zhangArray) do
		log(#(zhangArray[i]).."=========i="..i);
	end
	]]
	return zhangArray;
end


--返回选中手牌的牌型
function this.jianCeCardType(CardList)
	--log(#(CardList).."====个数");
	local zhangArray=self.doDuiweiArray(CardList);
	local wangArray={};
	local cardType=-1;--所提起的牌的牌型
	for key,value in ipairs(CardList) do
		if value.weight>18 then
			table.insert(wangArray,value);
		end
	end
	--log(#(wangArray).."=====选择王的个数");
	if #(wangArray)~=0 then --选中的扑克牌里有王的时候
		if #(wangArray)==#(CardList) then--只有王
			if #(wangArray)==1 then
				cardType=1;
			elseif #(wangArray)==2 and wangArray[1].weight==wangArray[2].weight then
				cardType=2;
			elseif #(wangArray)==3 then
				cardType=60;
			elseif #(wangArray)==4 then
				cardType=70;
			end
			return cardType,wangArray[1].weight,#(wangArray);
		else--混合牌
			--首先先删除选中牌里面带有大小王的牌
			iTableRemove(zhangArray,zhangArray[#(zhangArray)]);
			iTableRemove(zhangArray,zhangArray[#(zhangArray)]);
			--[[
			for i=1,#(zhangArray) do
				log(#(zhangArray[i]).."=========i="..i);
			end
			]]
			--然后把除了大小王之外的所有分好类的数组中空的数组删除，只留下有牌的数组。（从末尾开始删除，不然报错）
			for i=#(zhangArray),1,-1 do
				--print(zhangArray[i]);
				if #(zhangArray[i])==0 then
					iTableRemove(zhangArray,zhangArray[i]);
				end
			end
			--log(#(zhangArray).."========选择牌的种类");	
			if #(zhangArray)==1 then--如果提起的牌不算大小王，只有一种的话
				if #(CardList)==1 then
					cardType=1;
				elseif #(CardList)==2 then
					cardType=2;
				elseif #(CardList)==3 then
					cardType=3;
				elseif #(CardList)==4 then
					cardType=49;
				elseif #(CardList)==5 then
					cardType=59;	
				elseif #(CardList)==6 then
					cardType=69;
				elseif #(CardList)==7 then
					cardType=79;
				elseif #(CardList)==8 then
					cardType=89;
				elseif #(CardList)==9 then
					cardType=99;
				elseif #(CardList)==10 then
					cardType=109;
				elseif #(CardList)==11 then
					cardType=119;
				elseif #(CardList)==12 then
					cardType=129;
				end
			elseif #(zhangArray)==2 then	--如果提起的牌不算大小王，有两种的话
				if #(zhangArray[1])==1 and #(zhangArray[2])==1 and #(wangArray)==4 then
					if zhangArray[2][1].weight==(zhangArray[1][1].weight+1) or zhangArray[2][1].weight==(zhangArray[1][1].weight+2) then
						cardType=5;--连对
					end
				end
				if #(zhangArray[1])==1 and #(zhangArray[2])==2 and #(wangArray)==3 then
					if zhangArray[2][1].weight==(zhangArray[1][1].weight+1) or zhangArray[2][1].weight==(zhangArray[1][1].weight+2) then
						cardType=5;--连对
					end
				end
				if #(zhangArray[1])==2 and #(zhangArray[2])==1 and #(wangArray)==3 then
					if zhangArray[2][1].weight==(zhangArray[1][1].weight+1) or zhangArray[2][1].weight==(zhangArray[1][1].weight+2) then
						cardType=5;--连对
					end
				end
				if #(zhangArray[1])==2 and #(zhangArray[2])==2 and #(wangArray)==2 then
					if zhangArray[2][1].weight==(zhangArray[1][1].weight+1) or zhangArray[2][1].weight==(zhangArray[1][1].weight+2) then
						cardType=5;--连对
					end
				end
				if #(zhangArray[1])==3 and #(zhangArray[2])==3 and #(wangArray)==3 then
					if zhangArray[2][1].weight==(zhangArray[1][1].weight+1) or zhangArray[2][1].weight==(zhangArray[1][1].weight+2) then
						cardType=6;--连三张
					end
				end
				if #(zhangArray[1])==3 and #(zhangArray[2])==2 and #(wangArray)==4 then
					if zhangArray[2][1].weight==(zhangArray[1][1].weight+1) or zhangArray[2][1].weight==(zhangArray[1][1].weight+2) then
						cardType=6;--连三张
					end
				end
				if #(zhangArray[1])==2 and #(zhangArray[2])==3 and #(wangArray)==4 then
					if zhangArray[2][1].weight==(zhangArray[1][1].weight+1) or zhangArray[2][1].weight==(zhangArray[1][1].weight+2) then
						cardType=6;--连三张
					end
				end
				if #(zhangArray[1])==4 and #(zhangArray[2])==4 and #(wangArray)==4 then
					if zhangArray[2][1].weight==(zhangArray[1][1].weight+1) or zhangArray[2][1].weight==(zhangArray[1][1].weight+2) then
						cardType=73;--四相三连环
					end
				end
			else	--如果提起的牌不算大小王，大于等于三种的话
				local longestLength=-1;--最长数组长度
				for i=1,#(zhangArray) do
					if #(zhangArray[i])>longestLength then
						longestLength=#(zhangArray[i]);--获取到当前数组中的最长数组长度
					end
				end
				if longestLength>=4 then--如果最长长度为4
					--[[
					local aaa=0;
					for i=1,#(zhangArray)-1 do
						--遍历数组
						if zhangArray[i][1].weight==zhangArray[i+1][1].weight-1 then
							--如果连续
							if #(zhangArray[i])<4 then--小于4补王
								aaa=aaa+4-#(zhangArray[i]);
							end
							if aaa>#(wangArray) then--王不够补，X (结束)	
								break;
							end
							if i==#(zhangArray)-1 then
								local length114=math.floor(#(CardList)/#(zhangArray));
								if length114>4 then
									local w2=0;
									for i2=length114,4,-1 do
										for i3=1,#(zhangArray) do
											if #(zhangArray[i3])<i2 then
												w2=w2+(i2-#(zhangArray[i3]));
											end
											if w2>#(wangArray) then
												break;
											end
											if i3==#(zhangArray) then
												cardType=(#(zhangArray)+i2)*10+#(zhangArray);
											end
										end
										if cardType~=-1 then
											break;
										end
									end
									if cardType==-1 then
										cardType=(#(zhangArray)+4)*10+#(zhangArray);
									end
								end
							end
						else
							--不连续，X 
							local sshh=0;
							if #(zhangArray[1][1])==0 and #(zhangArray[#(zhangArray)][1]==12) then
								for y=i+1,#(zhangArray)-1 do
									if #(zhangArray[y]<4) then--小于4补王
										aaa=aaa+4-#(zhangArray[y]);
									end
									if aaa>#(wangArray) then--王不够补，X
										sshh=-1;
										break;
									end
									if y==#(zhangArray)-1 then
										--最后一个数组
										if #(zhangArray[y+1])<4 then
											aaa=aaa+4-#(zhangArray[y+1]);
										end
										if aaa<=#(wangArray) then
											--判断王够不够补
											local length111=math.floor(#(CardList)/#(zhangArray));
											if length111>=4 then
												local ww=0;
												for ii=length111,ii>4,-1 do
													for iii=1,#(zhangArray) do
														if #(zhangArray[iii]<ii) then
															ww=ww+(ii-#(zhangArray[iii]));
														end
														if ww>#(wangArray) then
															break;
														end
														if iii==#(zhangArray)-1 then
															cardType=(#(zhangArray)+ii)*10+#(zhangArray);
															sshh=1;
														end														
													end
													if cardType~=-1 then
														break;
													end
												end
											end
											if cardType==-1 then
												cardType=(#(zhangArray)+length111)*10+#(zhangArray);
											end
										else
											break;
										end
									end
								end
								if sshh==-1 or sshh==1 then
									break;
								end
							else
								break;
							end
						end
						
						if i==#(zhangArray)-1 then
							--最后一个数组
							if #(zhangArray[i+1])<4 then
								aaa=aaa+4-#(zhangArray[i+1]);
							end
							if aaa<=#(wangArray) then
								--判断王够不够补
								local length111=math.floor(#(CardList)/#(zhangArray));
								if length111>4 then
									local ww=0;
									for ii=length111,4,-1 do
										for iii=1,#(zhangArray) do
											if #(zhangArray[iii])<ii then
												ww=ww+(ii-#(zhangArray[iii]));
											end
											if ww>#(wangArray) then
												break;
											end
											if iii==#(zhangArray)-1 then
												cardType=(#(zhangArray)+ii)*10+#(zhangArray);
											end
										end
										if cardType==-1 then
											break;
										end
									end
								end
								if cardType==-1 then
									cardType=(#(zhangArray)+length111)*10+#(zhangArray);
								end
							else
								break;
							end
						end
					end
					]]
					local aaa=0;
					for i=1,#(zhangArray)-1 do
						if zhangArray[i][1].weight==zhangArray[i+1][1].weight-1 then
							if #(zhangArray[i])<longestLength then
								aaa=aaa+longestLength-#(zhangArray[i]);
							end
							if aaa>#(wangArray) then
								break;
							end
						elseif zhangArray[i][1].weight==zhangArray[i+1][1].weight-2 then
							if #(zhangArray[i])<longestLength then
								aaa=aaa+longestLength-#(zhangArray[i]);
							end
							aaa=aaa+longestLength;
							if aaa>#(wangArray) then
								break;
							end 
						end
						if i==#(zhangArray)-1 then
							if #(zhangArray[i+1])<longestLength then
								aaa=aaa+longestLength-#(zhangArray[i+1]);
							end
							if aaa==#(wangArray) then
								cardType=(#(zhangArray)+longestLength)*10+#(zhangArray);
							elseif #(zhangArray)>=3 and aaa==(#(wangArray)-#(zhangArray)) then--如果zhangArray长度大于等于3，并且wangArray数量减去需要的王的数量aaa之后等于zhangArray的长度
									cardType=(#(zhangArray)+longestLength+1)*10+#(zhangArray);
							else
								break;
							end
						end
					end
				elseif longestLength==3 then
					--最长为3
					if #(zhangArray)>=2 then
						local aaa=0;
						for i=1,#(zhangArray)-1 do
							if zhangArray[i][1].weight==(zhangArray[i+1][1].weight-1) then--连续								
								if #(zhangArray[i])<3 then
									--小于3补王
									aaa=aaa+3-#(zhangArray[i]);
								end
								if aaa>#(wangArray) then
									break;
								end
							elseif zhangArray[i][1].weight==(zhangArray[i+1][1].weight-2) then--不连续
								if #(zhangArray[i])<3 then
									--小于3补王
									aaa=aaa+3-#(zhangArray[i]);
								end
								aaa=aaa+3;
								if aaa>#(wangArray) then
									break;
								end
							--else
								--不连续，X
								--aaa=aaa+3;
							end
							if i==#(zhangArray)-1 then
								if #(zhangArray[i+1])<3 then
									aaa=aaa+3-#(zhangArray[i+1]);
								end
								if aaa==#(wangArray) then
									cardType=6;
								elseif #(zhangArray)>=3 and aaa==(#(wangArray)-#(zhangArray)) then--如果zhangArray长度大于等于3，并且wangArray数量减去需要的王的数量aaa之后等于zhangArray的长度
									cardType=(#(zhangArray)+4)*10+#(zhangArray);
								else
									break;
								end
							end							
						end
					end
				elseif longestLength==2 then
					--最长为2
					local aaa=0;
					for i=1,#(zhangArray)-1 do
						--log(zhangArray[i][1].weight.."==========="..zhangArray[i+1][1].weight);
						if zhangArray[i][1].weight==(zhangArray[i+1][1].weight-1) then--如果连续
							if #(zhangArray[i])<2 then--如果当前数组长度小于2，就需要补充一个王
								aaa=aaa+1;
							end
							if aaa>#(wangArray) then--如果需要补充的王过多
								break;
							end
						elseif zhangArray[i][1].weight==(zhangArray[i+1][1].weight-2) then--不连续，隔一
							if #(zhangArray[i])<2 then--如果当前数组长度小于2，就需要补充一个王
								aaa=aaa+1;	
							end
							aaa=aaa+2;--中间间隔的牌值需要再补充两个王
							if aaa>#(wangArray) then
								break;
							end
						elseif zhangArray[i][1].weight==(zhangArray[i+1][1].weight-3) then							
							if #(zhangArray[i])<2 then
								aaa=aaa+1;	
							end
							aaa=aaa+4;--中间间隔的牌值需要再补充四个王
							if aaa>#(wangArray) then--如果需要补充的王过多
								break;
							end
						else
							--不连续，X
							break;
						end
						if i==#(zhangArray)-1 then--当前数组是倒数第二组
							if #(zhangArray[i+1])<2 then--如果最后一组长度小于2，补充一个王
								aaa=aaa+1;
							end
							if aaa==#(wangArray) then--如果王的数量和需要的王数量相同
								cardType=5;
							elseif aaa==#(wangArray)-2 then--如果需要的王的数量比实际王数量小2
								cardType=5;
							else
								break;
							end
						end
					end
				elseif longestLength==1 and #(CardList)>=5 then				
					--都是一张
					local aaa=0;
					for i=1,#(zhangArray)-1 do
						--[[
						if zhangArray[i][1].weight==(zhangArray[i+1][1].weight-2) then--不连续，隔一
							aaa=aaa+1;
						elseif zhangArray[i][1].weight==(zhangArray[i+1][1].weight-3) then--不连续，隔二
							aaa=aaa+2;
						elseif zhangArray[i][1].weight==(zhangArray[i+1][1].weight-4) then--不连续，隔三
							aaa=aaa+3;
						end
						]]
									--判断相邻的两张牌的牌值相差大于1，就补充（差值-1）张大小王
						
						local loseNum=tonumber(zhangArray[i+1][1].weight-zhangArray[i][1].weight-1);
						--log(zhangArray[i+1][1].weight.."==============="..zhangArray[i][1].weight);
						--log(loseNum.."======loseNum");
						aaa=aaa+loseNum;
						if i==#(zhangArray)-1 then
							--log(aaa.."============"..#(wangArray));
							if aaa<=#(wangArray) then
								cardType=4;
							else
								break;
							end
						end
					end
				end	
			end		
		end
	else
		--没有王
		for i=#(zhangArray),1,-1 do
			if #(zhangArray[i])==0 then
				iTableRemove(zhangArray,zhangArray[i]);
			end
		end
		--log(#(zhangArray).."======没有王时的牌型个数");
		if #(zhangArray[1])>=4 then--如果第一组长度大于等于4
			--[[
			if #(zhangArray)>1 then--如果总牌型数组大于1
				--如果最后一组的个数大于等于4，并且类型组数大于等于3
				if #(zhangArray[#(zhangArray)])>=4 and #(zhangArray)>=3 then
					for x=1,#(zhangArray)-1 do
						--如果后一组的长度都大于等于4
						if #(zhangArray[x+1])>=4 then
							--如果上一组的牌值不等于  下一组的牌值减1
							if zhangArray[x][1].weight~=zhangArray[x+1][1].weight-1 then
								--如果第一组的牌值为最小的3，并且 最后一组的牌值为最大的2
								if zhangArray[1][1].weight==1 and zhangArray[#(zhangArray)-1][1].weight==13 then
									local sshh=0;
									for y=x+1,#(zhangArray)-1 do
										--如果后一组牌值比下一组的牌值不是小于1  或者 后一组的长度小于4
										if zhangArray[y][1].weight~=(zhangArray[y+1][1].weight-1) or #(zhangArray[y])<4 then
											sshh=-1;
											break;
										end
									end
									if sshh==-1 then
										break;
									else
										--zhangArray.sort(sortOnPx2);--此处排序有问题
										cardType=(#(zhangArray[#(zhangArray)])+#(zhangArray))*10+#(zhangArray);
										break;
									end
								else
									break;
								end
							end
						else
							break;
						end
						--如果当前是倒数第二组（此处用来判断四相三连环以上的连环牌型）
						if x==#(zhangArray)-1 then
							--zhangArray.sort(sortOnPx2);--此处排序有问题
							cardType=(#(zhangArray[#(zhangArray)])+#(zhangArray))*10+#(zhangArray);
						end
					end
				end	
			else
				cardType=#(zhangArray[1])*10+9;
			end
			]]
			if #(zhangArray)>=3 then
				for i=1,#(zhangArray)-1 do
					--log(#(zhangArray[i]).."=======相邻数组长度========"..#(zhangArray[i+1]));
					--log(zhangArray[i][1].weight.."====相邻牌值==="..zhangArray[i+1][1].weight);
					if #(zhangArray[i])==#(zhangArray[i+1]) and zhangArray[i][1].weight==(zhangArray[i+1][1].weight-1) then
						--log(#(zhangArray).."===数组长度==="..i);
						if i==#(zhangArray)-1 then
							--log(zhangArray[i][1].weight.."===当前i的牌值");
							cardType=(#(zhangArray[#(zhangArray)])+#(zhangArray))*10+#(zhangArray);
						end
					else
						break;
					end
				end
			elseif #(zhangArray)==1 then
				cardType=#(zhangArray[1])*10+9;
			end
		else
			if #(zhangArray[1])==3 then--如果第一组里有三张牌
				if #(zhangArray)>=3 then--如果总的牌类型大于三种
					for i=1,#(zhangArray)-1 do
						--如果总的牌类型等于三种  并且   前一组的值比后一组的牌值小一
						if #(zhangArray[i])==3 and zhangArray[i][1].weight==(zhangArray[i+1][1].weight-1) then
							--如果i等于总牌型数组中的倒数第二组，并且最后一组的长度也为3
							if i==#(zhangArray)-1 and #(zhangArray[i+1])==3 then
								cardType=6;
							end
						else
							break;
						end
					end
				elseif #(zhangArray)==1 then--如果总牌型数组只有一组
					if #(CardList)==3 then
						cardType=3;
					end
				end
			elseif #(zhangArray[1])==2 then--如果第一组里有两张牌
				if #(zhangArray)>2 then--如果总牌型数组大于2组
					for i=1,#(zhangArray)-1 do
						--如果前一组的长度为2， 并且前一组牌值比后一组小一
						if #(zhangArray[i])==2 and zhangArray[i][1].weight==(zhangArray[i+1][1].weight-1) then
							if i==#(zhangArray)-1 and #(zhangArray[i+1])==2 then--如果当前i是倒数第二组，并且最后一组的长度也为2
								cardType=5;
							end
						else
							break;
						end
					end
				elseif #(zhangArray)==1 then--如果总牌型数组只有一组
					if #(CardList)==2 then
						cardType=2;
					end
				end
			elseif #(zhangArray[1])==1 then--如果第一组里只有一张牌
				if #(zhangArray)>4 then--如果总牌型数组大于4组
					for i=1,#(zhangArray)-1 do
						--如果每组的长度为1 ，并且 前一组的值比后一组的牌值小一
						if #(zhangArray[i])==1 and zhangArray[i][1].weight==(zhangArray[i+1][1].weight-1) then
							if i==#(zhangArray)-1 and #(zhangArray[i+1])==1 and #(CardList)>=5 then
								cardType=4;
							end
						else
							break;
						end
					end
				elseif #(zhangArray)==1 then--如果只有一组
					if #(CardList)==1 then--所有牌只有一张
						cardType=1;
					end
				end
			end
		end
		
	end
	return cardType,zhangArray[1][1].weight,#(CardList);

end

--生成提示数组
function this.tiShiFun()
	local tishiArray={};
	if self.OtherOutCardType<10 then
		if self.OtherOutCardType==1 or self.OtherOutCardType==2 or self.OtherOutCardType==3 then
			tishiArray=self.thanNumPaiArray(self.OtherOutCardType,self.OtherOutCard);
		elseif self.OtherOutCardType==4 or self.OtherOutCardType==5 or self.OtherOutCardType==6 then
			tishiArray=self.shaiXuanFun(self.OtherOutCardType,self.OtherOutCard);
		end
		--log(#(tishiArray));
		--printf(tishiArray);
		local zhaDanArray=self.shaiXuanZhaDan();
		for i=#(zhaDanArray),1,-1 do
			if #(zhaDanArray[i])<1 then
				iTableRemove(zhaDanArray,zhaDanArray[i]);
			end
		end
		for i=1,#(zhaDanArray) do
			for j=1,#(zhaDanArray[i]) do
				table.insert(tishiArray,zhaDanArray[i][j]);
			end
		end
	
	else		
		if self.OtherOutCardType==49 then
			tishiArray=self.SelectZhaDan(1,self.OtherOutCard)
		elseif self.OtherOutCardType==59 then
			tishiArray=self.SelectZhaDan(2,self.OtherOutCard)
		elseif self.OtherOutCardType==60 then
			tishiArray=self.SelectZhaDan(3,self.OtherOutCard)
		elseif self.OtherOutCardType==69 then
			tishiArray=self.SelectZhaDan(4,self.OtherOutCard)
		elseif self.OtherOutCardType==70 then
			tishiArray=self.SelectZhaDan(5,self.OtherOutCard)
		elseif self.OtherOutCardType==73 then
			tishiArray=self.SelectZhaDan(6,self.OtherOutCard)
		elseif self.OtherOutCardType==79 then
			tishiArray=self.SelectZhaDan(7,self.OtherOutCard)
		elseif self.OtherOutCardType==83 then
			tishiArray=self.SelectZhaDan(8,self.OtherOutCard)
		elseif self.OtherOutCardType==84 then
			tishiArray=self.SelectZhaDan(9,self.OtherOutCard)
		elseif self.OtherOutCardType==89 then
			tishiArray=self.SelectZhaDan(10,self.OtherOutCard)
		elseif self.OtherOutCardType==93 then
			tishiArray=self.SelectZhaDan(11,self.OtherOutCard)
		elseif self.OtherOutCardType==94 then
			tishiArray=self.SelectZhaDan(12,self.OtherOutCard)
		elseif self.OtherOutCardType==95 then
			tishiArray=self.SelectZhaDan(13,self.OtherOutCard)
		elseif self.OtherOutCardType==99 then
			tishiArray=self.SelectZhaDan(14,self.OtherOutCard)
		elseif self.OtherOutCardType==103 then
			tishiArray=self.SelectZhaDan(15,self.OtherOutCard)
		elseif self.OtherOutCardType==104 then
			tishiArray=self.SelectZhaDan(16,self.OtherOutCard)
		elseif self.OtherOutCardType==105 then
			tishiArray=self.SelectZhaDan(17,self.OtherOutCard)
		elseif self.OtherOutCardType==109 then
			tishiArray=self.SelectZhaDan(18,self.OtherOutCard)
		elseif self.OtherOutCardType==113 then
			tishiArray=self.SelectZhaDan(19,self.OtherOutCard)
		elseif self.OtherOutCardType==119 then
			tishiArray=self.SelectZhaDan(20,self.OtherOutCard)
		elseif self.OtherOutCardType==129 then
			tishiArray=self.SelectZhaDan(21,self.OtherOutCard)
		end
		
	end
	
	return tishiArray;
end

function this.SelectZhaDan(num,card)
	local zhaDanArray=self.shaiXuanZhaDan();
	local autoArray={};
	for i=1,#(zhaDanArray[num]) do
		--log(card.."====对方打出的最小牌");
		--log(zhaDanArray[num][i][1].weight);
		if zhaDanArray[num][i][1].weight>card then
			table.insert(autoArray,zhaDanArray[num][i]);
		end
	end
	
	for i=num+1,#(zhaDanArray) do
		if #(zhaDanArray[i])>0 then
			for j=1,#(zhaDanArray[i]) do
				table.insert(autoArray,zhaDanArray[i][j])
			end
		end
	end
	
	return autoArray;
end


--生成大于指定牌的数组
function this.thanNumPaiArray(cardType,num)
	local zhangArray=self.doDuiweiArray(self.CardObjectList);
	local autoArray={};
	for i=num+1,18 do
		if #(zhangArray[i])==cardType then
			table.insert(autoArray,zhangArray[i]);
		end
	end
	--[[
	for c=1,18 do
		if #(zhangArray[c])>cardType then
			table.insert(autoArray,zhangArray[c]);
		end
	end
	]]
	return autoArray;
end

--过滤连续
function this.shaiXuanFun(count,minValue)
	local zhangArray=self.doDuiweiArray(self.CardObjectList);
	local autoArray={};
	local lianShu=0;
	if count==1 then
		lianShu=4;
	else
		lianShu=2;
	end
 
	local lishiArray={};
	local i=1;
	while (i<=12) do 
		if #(zhangArray[i])<count then
			if #(lishiArray)==(lianShu+1)*count then
				table.insert(autoArray,lishiArray);
			end
			lishiArray={};
		else
			for c=1,count do
				table.insert(lishiArray,zhangArray[i][c].weight);
			end
			if #(lishiArray)==(lianShu+1)*count then
				table.insert(autoArray,lishiArray);
				i=lishiArray[count+1]-1;
				lishiArray={};
			end
		end
		i=i+1;
	end
	return autoArray;
end

--过滤炸弹
function this.shaiXuanZhaDan()
	local autoArray={};
	local zhangArray=self.doDuiweiArray(self.CardObjectList);
	local wangArray={};
	--有王数组的添加
	for key,value in ipairs(self.CardObjectList) do
		if value.weight>18 then
			table.insert(wangArray,value);
		end
	end
	local zhaDanArray={{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}};
	--去掉大小王
	iTableRemove(zhangArray,zhangArray[#(zhangArray)]);
	iTableRemove(zhangArray,zhangArray[#(zhangArray)]);
	
	--王炸的判断
	if #(wangArray)==3 then
		table.insert(zhaDanArray[3],wangArray);
	elseif #(wangArray)==4 then
		table.insert(zhaDanArray[5],wangArray);
	end
	--此处判断是否有王炸
	--printf(zhaDanArray);
	
	--四相到十二相炸弹的判断
	for i=1,#(zhangArray) do
		if #(zhangArray[i])>=4 then
			local array=self.ZhaDanSelect(zhangArray[i],nil);--获取不带大小王的炸弹数组
			self.AddZhaDan(#(zhangArray[i]),array,zhaDanArray);
		end
		if #(wangArray)>0 and #(zhangArray[i])+#(wangArray)>=4 then
			local array=self.ZhaDanSelect(zhangArray[i],wangArray);--获取带大小王的炸弹数组
			self.AddZhaDan(#(zhangArray[i])+#(wangArray),array,zhaDanArray);
		end
	end
	--此处用来打印四相到十二相的牌
	--log("炸弹数组1111111");
	--printf(zhaDanArray);	
	
	
	--连环炸弹的判断
	
	for i=4,9 do
		local aaa=0;
		local bbb=0;
		local lishiArray={};
		local j=1;
		while (j<=12) do	
			--log(j.."=========");
			if #(zhangArray[j])<i then
				aaa=aaa+i-#(zhangArray[j]);
			end
			if aaa>#(wangArray) then
				if (#(lishiArray)+bbb)>=(i*3) then
					for d=1,bbb do
						table.insert(lishiArray,wangArray[d]);
					end
					local cardGroup=(#(lishiArray)+bbb)/i;
					local cardtype=(i+cardGroup)*10+cardGroup;
					if cardtype==73 then
						table.insert(zhaDanArray[6],lishiArray);
					elseif cardtype==83 then
						table.insert(zhaDanArray[8],lishiArray);
					elseif cardtype==84 then
						table.insert(zhaDanArray[9],lishiArray);
					elseif cardtype==93 then
						table.insert(zhaDanArray[11],lishiArray);
					elseif cardtype==94 then
						table.insert(zhaDanArray[12],lishiArray);
					elseif cardtype==95 then
						table.insert(zhaDanArray[13],lishiArray);
					elseif cardtype==103 then
						table.insert(zhaDanArray[15],lishiArray);
					elseif cardtype==104 then
						table.insert(zhaDanArray[16],lishiArray);
					elseif cardtype==105 then
						table.insert(zhaDanArray[17],lishiArray);
					elseif cardtype==113 then
						table.insert(zhaDanArray[19],lishiArray);
					end
					aaa=0;
					bbb=0;
					lishiArray={};
					j=j-1;
				else
					aaa=0;
					bbb=0;
					local cardGroup=math.ceil((#(lishiArray)+bbb)/i);
					j=j-cardGroup;
					lishiArray={};
				end
			else
				local count=0;--当前需要添加进数组的牌的个数
				if i>#(zhangArray[j]) then
					count=#(zhangArray[j]);
				else
					count=i;
				end
				for c=1,count do
					table.insert(lishiArray,zhangArray[j][c]);
				end
				bbb=aaa;
			end
			
			j=j+1;
		end
	end
	--log("炸弹数组");
	--printf(zhaDanArray);
		
	return zhaDanArray;
end

--得到不带大小王的炸弹数组和带大小王的炸弹数组
function this.ZhaDanSelect(putongList,wangList)
	local array={};
	if #(putongList)>0 then
		for i=1,#(putongList) do
			table.insert(array,putongList[i]);
		end
	end
	if wangList~=nil and #(wangList)>0 then
		for i=1,#(wangList) do
			table.insert(array,wangList[i]);
		end
	end
	return array;
end

--将适合的炸弹牌型放进炸弹数组中适当的位置
function this.AddZhaDan(count,array,zhaDanArray)
		if count==4 then
			table.insert(zhaDanArray[1],array);
		elseif count==5 then
			table.insert(zhaDanArray[2],array);
		elseif count==6 then
			table.insert(zhaDanArray[4],array);
		elseif count==7 then
			table.insert(zhaDanArray[7],array);
		elseif count==8 then
			table.insert(zhaDanArray[10],array);
		elseif count==9 then
			table.insert(zhaDanArray[14],array);
		elseif count==10 then
			table.insert(zhaDanArray[18],array);
		elseif count==11 then
			table.insert(zhaDanArray[20],array);
		elseif count==12 then
			table.insert(zhaDanArray[21],array);
		end
	
end


function this.SetTiShiMessage(list)
	self.selectedCards={};
	self.ChongZhiCards();
	for i=1,#(list) do
		table.insert(self.selectedCards,list[i]);
		--log(list[i].GameObject.name);
		local ownPosition=list[i].GameObject.transform.localPosition;	
		--log(list[i].GameObject.transform.localPosition);
		list[i].Selected=true;
		list[i].GameObject.transform.localPosition=Vector3.New(ownPosition.x,60,ownPosition.z);
		--log(list[i].GameObject.transform.localPosition);
	end
end


function this.ClearPrefab()
	--log("开始销毁");
	local sprites = GameQBSK.outCardParent:GetComponentsInChildren(Type.GetType("UISprite",true));
	for i=0,sprites.Length-1 do
		local sprite = sprites[i];
		destroy(sprite.gameObject);
	end
	
	local cardParent=transform:FindChild("cardParent");
	local sprites_1 = cardParent:GetComponentsInChildren(Type.GetType("UISprite",true));
	for i=0,sprites_1.Length-1 do
		local sprite = sprites_1[i];
		destroy(sprite.gameObject);
	end
	self.CardObjectList={};
	self.OtherOutCardType=0;
end


























function this.ShowOutPai()
	log("进入player");
end

