settlement_class = {}

settlement_class.settlement_prototype = {
	settlementInit=function(self)
		if (not self.extraGoodsDemand) then
			self.extraGoodsDemand={}
		end
		if (not self.extraGoodsSupply) then
			self.extraGoodsSupply={}
		end
		if (not self.lesserGoodsDemand) then
			self.lesserGoodsDemand={}
		end
		if (not self.lesserGoodsSupply) then
			self.lesserGoodsSupply={}
		end
		if (not self.suppressGoodDemand) then
			self.suppressGoodDemand={}
		end
		if (not self.suppressGoodSupply) then
			self.suppressGoodSupply={}
		end
		if (not self.activeEffects) then
			self.activeEffects={}
		end
		if (not self.tags) then
			self.tags={}
		end
		if (not self.agriculture) then
			self.agriculture=1
		end
		if (not self.industry) then
			self.industry=1
		end
		if (not self.services) then
			self.services=1
		end
		if (not self.technology) then
			self.technology=1
		end
		if (not self.military) then
			self.military=1
		end
		if (not self.stability) then
			self.stability=1
		end
	end,
	addGoodDemand=function(self,good,demand,price,effectId)
		self.extraGoodsDemand[#self.extraGoodsDemand+1]={type=good,demand=demand,price=price,effectId=effectId}
	end,
	addGoodSupply=function(self,good,supply,price,effectId)
		self.extraGoodsSupply[#self.extraGoodsSupply+1]={type=good,supply=supply,price=price,effectId=effectId}
	end,
	reduceGoodDemand=function(self,good,demand,price,effectId)
		self.lesserGoodsDemand[#self.lesserGoodsDemand+1]={type=good,demand=demand,price=price,effectId=effectId}
	end,
	reduceGoodSupply=function(self,good,supply,price,effectId)
		self.lesserGoodsSupply[#self.lesserGoodsSupply+1]={type=good,supply=supply,price=price,effectId=effectId}
	end,
	suppressDemand=function(self,good,effectId)
		self.suppressGoodDemand[#self.suppressGoodDemand+1]={type=good,effectId=effectId}
	end,
	suppressSupply=function(self,good,effectId)
		self.suppressGoodSupply[#self.suppressGoodSupply+1]={type=good,effectId=effectId}
	end,
	addActiveEffect=function(self,desc,timeLimit,methodOnEnd)
		self.activeEffects[#self.activeEffects+1]={id=gh.floorTo(math.random(100000000)),desc=desc,timeLimit=timeLimit,methodOnEnd=methodOnEnd}
		return self.activeEffects[#self.activeEffects].id
	end,
	addTag=function(self,tag)
		for k,v in pairs(self.tags) do
			if v==tag then return end
		end
		if not exists then
			self.tags[#self.tags+1]=tag
		end
	end,
	removeTag=function(self,tag)
		for k,v in pairs(self.tags) do--assumes tag present only once
			if (v==tag) then
				table.remove(self.tags, k)
			end
		end
	end,
	hasTag=function(self,tag)
		for k,v in pairs(self.tags) do
			if (v==tag) then
				return true
			end
		end
		return false
	end,
	clearObsoleteEffects=function(self)
		local nbCleared=0
		if (self.activeEffects) then
			local i
			for i=#self.activeEffects,1,-1 do
			    if time.fromnumber(self.activeEffects[i].timeLimit) < time.get() then

			    	local effectId=self.activeEffects[i]

			    	local j
			    	for j=#self.extraGoodsDemand,1,-1 do
			    		if (self.extraGoodsDemand[j].effectId==effectId) then
			    			table.remove(self.extraGoodsDemand, j)
			    		end
			    	end
			    	for j=#self.extraGoodsSupply,1,-1 do
			    		if (self.extraGoodsSupply[j].effectId==effectId) then
			    			table.remove(self.extraGoodsSupply, j)
			    		end
			    	end
			    	for j=#self.suppressGoodDemand,1,-1 do
			    		if (self.suppressGoodDemand[j].effectId==effectId) then
			    			table.remove(self.suppressGoodDemand, j)
			    		end
			    	end
			    	for j=#self.suppressGoodSupply,1,-1 do
			    		if (self.suppressGoodSupply[j].effectId==effectId) then
			    			table.remove(self.suppressGoodSupply, j)
			    		end
			    	end

			        table.remove(self.activeEffects, i)
			        nbCleared=nbCleared+1
			    end
			end
		end
		return nbCleared
	end,
	setSettlementData=function(self,data)
		local validData={population=true,agriculture=true,industry=true,services=true,military=true,technology=true,stability=true}
		for k,v in pairs(data) do
			assert(validData[k])
			self[k]=v
		end
	end,
	randomizeSettlementData=function(self,factor)
		self.agriculture=gh.randomize(self.agriculture,factor)
		self.industry=gh.randomize(self.industry,factor)
		self.services=gh.randomize(self.services,factor)
		self.technology=gh.randomize(self.technology,factor)
		self.military=gh.randomize(self.military,factor)
		self.stability=gh.randomize(self.stability,factor)
	end

}

settlement_class.settlement_prototype.__index = settlement_class.settlement_prototype

function settlement_class.applyToObject(o)
	setmetatable(o, settlement_class.settlement_prototype)
	o:settlementInit()
	return o
end

function settlement_class.createNew()
	local o={}
	setmetatable(o, settlement_class.settlement_prototype)
	o:settlementInit()
	return o
end