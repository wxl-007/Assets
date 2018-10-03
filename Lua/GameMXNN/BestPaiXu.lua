
local this = LuaObject:New()
BestPaiXu = this


----[[*得到最优牌型]]--
function this.getBestPaiType( cards,  paiType)
	--5张牌 取出 3张 有 10中 取法
	if  paiType == 0 then
		return cards;
	else
		return this.zuHe(cards, paiType);
	end
end

--[[*
 * 
 * @param paiarr 牌数组
 * @param paitt   牌的类型
 * @return 
 * 
 ]]--
function this.zuHe( paiarr,  paitt)
	local paiZhiArr = {};
	local isd = -1;
	local isx = -1;
	for   i = 0, 4 do
	
		if  tonumber(paiarr[i+1]) == 52 or tonumber(paiarr[i+1]) == 53 then
			if  tonumber(paiarr[i+1]) == 53 then
				isd = i;
			else
				isx = i;
			end
			paiZhiArr[i+1] = 10;            
		else
			paiZhiArr[i+1] =(((tonumber(paiarr[i+1]) % 13) + 1) >= 10  and 10 or (tonumber(paiarr[i+1]) % 13 + 1));
		end
	end
	--有大猫和小猫的时候
	if  isd > -1 or isx > -1 then
	
		if isd > -1 and isx > -1 then
		
			local daxArrr = {};
			table.insert(daxArrr,isx);
			for  n1 = 0, 4 do
				if  n1 ~= isd and n1 ~= isx then
					table.insert(daxArrr,n1);
				end
			end
			table.insert(daxArrr,isd);
			return daxArrr;
		else
			local kj = -1;
			local rel2 = true;
			if  isd > -1 then 
				kj = isd;
			else 
				kj = isx;
			end
			if  paitt ~= 10 and paitt ~= 11 and paitt ~= 12 then
				local reArr2 = {};
				for j1 = 0, 4  do
					if not rel2 then break; end
					for   k1 = 0,4 do
						if not rel2 then break; end
						if  j1 ~= k1 and j1 ~= kj and k1 ~= kj and ((tonumber(paiZhiArr[j1+1]) + tonumber(paiZhiArr[k1+1]))) % 10 == paitt then
						
							rel2 = false;
							table.insert(reArr2,j1);
							table.insert(reArr2,k1);
						end
					end
				end

				for  n6 = 0 ,4 do
					if  n6 ~= tonumber(reArr2[1]) and n6 ~= tonumber(reArr2[2]) then
						table.insert(reArr2,n6);
					end
				end
				return reArr2;
			else
			
				local reArr = {-1,-1};
				rel2 = true;
				for j1 = 0,4 do
					if not rel2 then break; end
					for k1 = 0,4 do
						if not rel2 then break; end
						if  j1 ~= k1 and j1 ~= kj and k1 ~= kj and (tonumber(paiZhiArr[j1+1]) + tonumber(paiZhiArr[k1+1])) % 10 == 0 then
							rel2 = false;
							reArr[1]=j1;
							reArr[2]=k1;
						end
					end
				end

				if  rel2 then
				
					for  j7 = 0,4 do
						if not rel2 then break; end
						for  k7 = 0, 4  do
							if not rel2 then break; end
							for  m7 = 0, 4  do
								if not rel2 then break; end
								if   j7 ~= k7 and j7 ~= m7 and k7 ~= m7 and k7 ~= kj and m7 ~= kj and j7 ~= kj and (tonumber(paiZhiArr[j7+1]) + tonumber(paiZhiArr[k7+1]) + tonumber(paiZhiArr[m7+1])) % 10 == 0 then
								
									rel2 = false;
									reArr[3]=j7;
									reArr[4]=k7;
									reArr[5]=m7;                             
								end
							end
						end
					end
					for  n2 = 0, 4 do
						if  n2 ~= tonumber(reArr[3]) and #reArr >=5 and n2 ~= tonumber(reArr[4]) and n2 ~= tonumber(reArr[5]) then
						
							if  tonumber(reArr[1]) >= 0 then
							
								reArr[2]=n2;
							else
							
								reArr[1]=n2;
							end
						end
					end
				else
				
					for   n2 = 0,4 do
					
						if  n2 ~= tonumber(reArr[1]) and n2 ~= tonumber(reArr[2]) then
							table.insert(reArr,n2);
						end
					end
				end                   
				return reArr;
			end
		end
	end
	--没有有大猫和小猫的时候

	local rel = true;
	local jk = {};

	for   j = 0, 4 do
		if not rel then break; end
		for  k = 0,4 do
			if not rel then break; end
			for   m = 0,4 do
				if not rel then break; end
				if  j ~= k and j ~= m and k ~= m and (tonumber(paiZhiArr[j+1]) + tonumber(paiZhiArr[k+1]) + tonumber(paiZhiArr[m+1])) % 10 == 0 then
					rel = false;
					jk[1] = j;
					jk[2] = k;
					jk[3] = m;
				end
			end
		end
	end

	local newJK = {};

	for  n = 0,4 do
		if  n ~= tonumber(jk[1]) and n ~= tonumber(jk[2]) and n ~= tonumber(jk[3]) then
			table.insert(newJK,n);
		end
	end
	newJK[3] = jk[1];
	newJK[4] = jk[2];
	newJK[5] = jk[3]; 
	return newJK;
end