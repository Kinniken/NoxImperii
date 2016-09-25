include('dat/scripts/general_helper.lua')
include('universe/objects/class_planets.lua')
include('universe/live/live_desc.lua')
include('universe/live/live_info.lua')
include("universe/locations.lua")

--[[
Main class for all the dynamic stuff happening on planets (random or not).
Used to dynamically calculate available tech groups, commodity prices and quantities,
and faction presence (including pirates and barbarians).
]]

--factors to apply to base calculations to change good supply and demand
local productionFactors={}

productionFactors.humans={[C.TELLOCH]={price=3}}--mostly empty, humans are default

--Ardars: less luxury, more weapons & industry
productionFactors.ardars={
	[C.FOOD]={demand=1,supply=1},[C.EXOTIC_FOOD]={demand=0.5},[C.GOURMET_FOOD]={demand=0.5,supply=0.5},[C.BORDEAUX]={demand=0.7,price=3},[C.TELLOCH]={demand=2},
	[C.PRIMITIVE_CONSUMER]={demand=1,supply=1},[C.CONSUMER_GOODS]={demand=1,supply=1},
	[C.LUXURY_GOODS]={demand=0.5,supply=0.2},[C.EXOTIC_FURS]={demand=0.5},[C.NATIVE_ARTWORK]={demand=0.5},[C.NATIVE_SCULPTURES]={demand=0.5},
	[C.ORE]={demand=1.5},[C.PRIMITIVE_INDUSTRIAL]={supply=1.2,demand=1.5},[C.INDUSTRIAL]={supply=1.2,demand=1.5},[C.MODERN_INDUSTRIAL]={supply=1.2,demand=1.5},[C.EXOTIC_ORGANIC]={demand=1.5},
	[C.MEDICINE]={demand=1,supply=1},
	[C.NATIVE_WEAPONS]={demand=2},[C.BASIC_WEAPONS]={supply=1.2},[C.PRIMITIVE_ARMAMENT]={supply=1.2,demand=1.5},[C.ARMAMENT]={supply=1.2,demand=1.5},[C.MODERN_ARMAMENT]={supply=1.2,demand=1.5}
}

--betelgeuse: more luxury, less high-tech
productionFactors.betelgeuse={
	[C.FOOD]={demand=1,supply=1},[C.EXOTIC_FOOD]={demand=1.5},[C.GOURMET_FOOD]={demand=1.5,supply=1},[C.BORDEAUX]={demand=1.5,price=3},[C.TELLOCH]={demand=1.5},
	[C.PRIMITIVE_CONSUMER]={demand=1.5,supply=1},[C.CONSUMER_GOODS]={demand=1.5,supply=1},
	[C.LUXURY_GOODS]={demand=1.5,supply=1},[C.EXOTIC_FURS]={demand=2},[C.NATIVE_ARTWORK]={demand=1},[C.NATIVE_SCULPTURES]={demand=1},
	[C.ORE]={demand=1},[C.PRIMITIVE_INDUSTRIAL]={supply=1,demand=1},[C.INDUSTRIAL]={supply=1,demand=1},[C.MODERN_INDUSTRIAL]={supply=0.5,demand=1},[C.EXOTIC_ORGANIC]={demand=1},
	[C.MEDICINE]={demand=1,supply=0.7},
	[C.NATIVE_WEAPONS]={demand=2},[C.BASIC_WEAPONS]={supply=1},[C.PRIMITIVE_ARMAMENT]={supply=1,demand=1},[C.ARMAMENT]={supply=0.7,demand=1.5},[C.MODERN_ARMAMENT]={supply=0.3,demand=1}
}

--Royal Ixum: some luxury, lots of military, little consumer good
productionFactors.royalixumites={
	[C.FOOD]={demand=0.7,supply=0.7},[C.EXOTIC_FOOD]={demand=1},[C.GOURMET_FOOD]={demand=1,supply=1},[C.BORDEAUX]={demand=3,price=3},[C.TELLOCH]={demand=3,price=3},
	[C.PRIMITIVE_CONSUMER]={demand=0.5,supply=1},[C.CONSUMER_GOODS]={demand=0.5,supply=1},
	[C.LUXURY_GOODS]={demand=1.5,supply=1},[C.EXOTIC_FURS]={demand=1.5},[C.NATIVE_ARTWORK]={demand=0.5},[C.NATIVE_SCULPTURES]={demand=0.5},[C.NATIVE_WEAPONS]={demand=2},
	[C.ORE]={demand=1},[C.PRIMITIVE_INDUSTRIAL]={supply=1.2,demand=1.5},[C.INDUSTRIAL]={supply=0.7,demand=1},[C.MODERN_INDUSTRIAL]={supply=0.5,demand=0.7},[C.EXOTIC_ORGANIC]={demand=0.5},
	[C.MEDICINE]={demand=1.5,supply=0.5,price=1.5},
	[C.BASIC_WEAPONS]={demand=2,supply=1,price=1.5},[C.PRIMITIVE_ARMAMENT]={supply=1,demand=2,price=1.5},[C.ARMAMENT]={supply=1,demand=2,price=1.5},[C.MODERN_ARMAMENT]={supply=0.5,demand=2,price=2}
}

--Holy Flame: lots of military, little consumer good, little luxury
productionFactors.holyflame={
	[C.FOOD]={demand=0.7,supply=0.7},[C.EXOTIC_FOOD]={demand=0.5},[C.GOURMET_FOOD]={demand=0.5,supply=0.5},[C.BORDEAUX]={demand=0},[C.TELLOCH]={demand=0},
	[C.PRIMITIVE_CONSUMER]={demand=0.5,supply=1},[C.CONSUMER_GOODS]={demand=0.5,supply=1},
	[C.LUXURY_GOODS]={demand=0.5,supply=0.5},[C.EXOTIC_FURS]={demand=0.5},[C.NATIVE_ARTWORK]={demand=0},[C.NATIVE_SCULPTURES]={demand=0},
	[C.ORE]={demand=1},[C.PRIMITIVE_INDUSTRIAL]={supply=1.2,demand=1.5},[C.INDUSTRIAL]={supply=0.7,demand=1},[C.MODERN_INDUSTRIAL]={supply=0.5,demand=0.7},[C.EXOTIC_ORGANIC]={demand=0.5},
	[C.MEDICINE]={demand=1.5,supply=0.5,price=1.5},
	[C.NATIVE_WEAPONS]={demand=0},[C.BASIC_WEAPONS]={demand=2,supply=1,price=1.5},[C.PRIMITIVE_ARMAMENT]={supply=1,demand=2,price=1.5},[C.ARMAMENT]={supply=1,demand=2,price=1.5},[C.MODERN_ARMAMENT]={supply=0.5,demand=2,price=2}
}

--Civilized natives
productionFactors.natives={
	[C.FOOD]={demand=0,supply=0},[C.EXOTIC_FOOD]={demand=1.5},[C.GOURMET_FOOD]={demand=0.5,supply=0.5},[C.BORDEAUX]={demand=0},[C.TELLOCH]={demand=0},
	[C.PRIMITIVE_CONSUMER]={demand=1,supply=1},[C.CONSUMER_GOODS]={demand=1,supply=1},
	[C.LUXURY_GOODS]={demand=0.5,supply=0.5},[C.EXOTIC_FURS]={demand=1},[C.NATIVE_ARTWORK]={demand=1},[C.NATIVE_SCULPTURES]={demand=1},
	[C.ORE]={demand=1},[C.PRIMITIVE_INDUSTRIAL]={supply=1,demand=1.5},[C.INDUSTRIAL]={supply=1,demand=1},[C.MODERN_INDUSTRIAL]={supply=0,demand=0},[C.EXOTIC_ORGANIC]={demand=1},
	[C.MEDICINE]={demand=1,supply=0.5},
	[C.NATIVE_WEAPONS]={demand=1},[C.BASIC_WEAPONS]={supply=1},[C.PRIMITIVE_ARMAMENT]={supply=1,demand=1.5},[C.ARMAMENT]={supply=1,demand=1.5},[C.MODERN_ARMAMENT]={supply=0,demand=0}
}

--Barbarians
productionFactors.barbarians={
	[C.FOOD]={demand=0,supply=0},[C.EXOTIC_FOOD]={demand=0},[C.GOURMET_FOOD]={demand=0,supply=0},[C.BORDEAUX]={demand=0},[C.TELLOCH]={demand=0},
	[C.PRIMITIVE_CONSUMER]={demand=2,supply=0.5},[C.CONSUMER_GOODS]={demand=2,supply=0.2},
	[C.LUXURY_GOODS]={demand=3,supply=0.2},[C.EXOTIC_FURS]={demand=0},[C.NATIVE_ARTWORK]={demand=0},[C.NATIVE_SCULPTURES]={demand=0},
	[C.ORE]={demand=1},[C.PRIMITIVE_INDUSTRIAL]={supply=0.5,demand=1.5},[C.INDUSTRIAL]={supply=0.3,demand=1.5},[C.MODERN_INDUSTRIAL]={supply=0,demand=0},[C.EXOTIC_ORGANIC]={demand=0},
	[C.MEDICINE]={demand=2,supply=0.3,price=1.5},
	[C.NATIVE_WEAPONS]={demand=0},[C.BASIC_WEAPONS]={supply=1},[C.PRIMITIVE_ARMAMENT]={supply=1,demand=1.5},[C.ARMAMENT]={supply=1,demand=1.5},[C.MODERN_ARMAMENT]={supply=0,demand=0}
}

function initStatusVar()

	var.push("universe_emperor","George Michel Ramanendra IV")

	for k,v in pairs(imperial_stability_zones) do
		var.push("universe_stability_"..k,v.initStability)
		var.push("universe_stability_min_"..k,v.initStability-0.1)
		var.push("universe_stability_max_"..k,v.initStability+0.1)
	end

	for _,v in pairs(imperial_barbarian_zones_array) do
		var.push("universe_barbarian_activity_"..v.key,0.6)
		var.push("universe_barbarian_activity_min_"..v.key,0.5)
		var.push("universe_barbarian_activity_max_"..v.key,0.7)
	end

	var.push("universe_balanceofpower",0)
end

function getSectorStability(sectorName)
	for _,v in pairs(imperial_stability_zones) do
		if sectorName==v then
			return var.peek("universe_stability_"..v),var.peek("universe_stability_min_"..v),var.peek("universe_stability_max_"..v)
		end
	end

	return nil,nil,nil
end

function setSectorStability(sectorName,stability)
	for _,v in pairs(imperial_stability_zones) do
		if sectorName==v then
			var.push("universe_stability_"..v,stability)
		end
	end
	
	for _,p in pairs(planet.getAll()) do
		if p:system() and p:system():getZone()==sectorName then
			generatePlanetServices(planet_class.load(p))
		end
	end
end

function adjustSectorStability(sectorName,change)
	local stability,min,max=getSectorStability(sectorName)

	if not stability then
		print("No stability for zone: ")
		print(sectorName)
	else

		if change<1 and stability*change<min then
			return
		elseif change>1 and stability*change>max then
			return
		end

		setSectorStability(sectorName,stability*change)
	end
end

function getBarbarianActivity(sectorName)

	for _,v in pairs(imperial_barbarian_zones) do
		print("comparing "..sectorName.." with "..v.name)
		if sectorName==v.name then
			return var.peek("universe_barbarian_activity_"..v.key),var.peek("universe_barbarian_activity_min_"..v.key),var.peek("universe_barbarian_activity_max_"..v.key)
		end
	end

	return nil,nil,nil
end

function setBarbarianActivity(sectorName,activity)
	for _,v in pairs(imperial_barbarian_zones) do
		if sectorName==v.name then
			var.push("universe_barbarian_activity_"..v.key,activity)
		end
	end
	
	for _,p in pairs(planet.getAll()) do
		if p:system() and p:system():getZone()==sectorName then
			generatePlanetServices(planet_class.load(p))
		end
	end
end

function adjustBarbarianActivity(sectorName,change)
	local activity,min,max=getBarbarianActivity(sectorName)

	if not activity then
		print("No activity for zone: ")
		print(sectorName)
	else

		if change<1 and activity*change<min then
			return
		elseif change>1 and activity*change>max then
			return
		end
		
		print("Adjusting to: "..activity*change)
		setBarbarianActivity(sectorName,activity*change)
	end
end

local function addCommodity(commodities,commodity,price,supply,demand)

	if supply>0 and supply<5 then
		supply=5
	end

	if demand>0 and demand<5 then
		demand=5
	end

	if (not commodities[commodity]) then
		commodities[commodity]={price=price,supply=supply,demand=demand}
	else
		--Simply a ratio of previous price to new price weighted by demand supply
		commodities[commodity].price=(commodities[commodity].price*(math.abs(commodities[commodity].demand)+math.abs(commodities[commodity].supply))+price*(math.abs(supply)+math.abs(demand)))/(math.abs(commodities[commodity].demand)+math.abs(commodities[commodity].supply)+math.abs(supply)+math.abs(demand))

		commodities[commodity].supply=commodities[commodity].supply+supply
		commodities[commodity].demand=commodities[commodity].demand+demand
	end
end

local function suppressCommodityDemand(commodities,commodity)
	if (not commodities[commodity]) then
		commodities[commodity]={price=1,supply=0,demand=0,demandSuppressed=true}
	else
		commodities[commodity].demandSuppressed=true
	end
end

local function suppressCommoditySupply(commodities,commodity)
	if (not commodities[commodity]) then
		commodities[commodity]={price=1,supply=0,demand=0,suplySuppressed=true}
	else
		commodities[commodity].supplySuppressed=true
	end
end

local function generateCommodity(settings,commodities,name,price,need,production,baseQuantity)

	if price > 5 then
		price = 5
	elseif price < 0.2 then
		price = 0.2
	end

	if (settings and settings[name] and settings[name].demand) then
		need=need*settings[name].demand
	end

	if (settings and settings[name] and settings[name].supply) then
		production=production*settings[name].supply
	end

	if (settings and settings[name] and settings[name].price) then
		price=price*settings[name].price
	end

	if (production>0 or need>0) then
		addCommodity(commodities,name,price,production*baseQuantity,need*baseQuantity)
	end
end

local function generateNativesNonCivilizedCommodities(planet,commodities)

	planet.c:addService("c")

	if (planet.lua.natives.extraGoodsDemand) then
		local populationScore=gh.populationScore(planet.lua.natives.population)
		for k,good in pairs(planet.lua.natives.extraGoodsDemand) do
			local price=good.price*(planet:isCivilized() and 2 or 5)

			addCommodity(commodities,good.type,price,0,populationScore*good.demand*70)
		end
	end
	if (planet.lua.natives.extraGoodsSupply) then
		local populationScore=gh.populationScore(planet.lua.natives.population)
		for k,good in pairs(planet.lua.natives.extraGoodsSupply) do
			local price=good.price*(planet:isCivilized() and 2 or 1)
			addCommodity(commodities,good.type,price,populationScore*good.supply*20,0)
		end
	end
	for k,good in pairs(planet.lua.natives.suppressGoodDemand) do
		suppressCommodityDemand(commodities,good.type)
	end
	for k,good in pairs(planet.lua.natives.suppressGoodSupply) do
		suppressCommoditySupply(commodities,good.type)
	end
end

local function generateSettlementCommoditiesNeedsSupply(settings,planet,settlementKey,commodities)

	local settlement=planet.lua.settlements[settlementKey]

	--Calculating gap between buying and selling prices. 1% for most advanced worlds, 5% for most backward
	buySellGap=(1/(settlement.technology+1)-0.5)*0.05

	if (buySellGap>0.05) then
		buySellGap=0.05
	elseif (buySellGap<0.01) then
		buySellGap=0.01
	end

	planet.c:setTradeBuySellRation(buySellGap);

	local price,need,production

	populationScore=(math.log10(settlement.population)/10)

	need=populationScore*8
	production=10*settlement.agriculture
	price=settlement.services/(settlement.agriculture)

	generateCommodity(settings,commodities,C.FOOD,price,need,production,1000)

	need=0
	if (settlement.services>0.7) then
		need=populationScore*(settlement.services-0.7)*2
	end
	production=0
	if (settlement.agriculture>1.0) then
		production=(settlement.agriculture-1)*2
	end
	price=(settlement.services+0.3)/(settlement.agriculture)+0.1

	generateCommodity(settings,commodities,C.GOURMET_FOOD,price,need,production,200)

	--Consumer Goods
	need=0
	if (settlement.technology<0.5) then
		need=populationScore
	end
	production=0
	if (settlement.services>0.3 and settlement.services<1) then
		production=(settlement.services*2)
	end
	price=1/(settlement.technology/3+0.8)
	generateCommodity(settings,commodities,C.PRIMITIVE_CONSUMER,price,need,production,1000)

	need=0
	if (settlement.services>0.3) then
		need=settlement.services/2
	end
	production=0
	if (settlement.technology>0.5) then
		production=settlement.services
	end
	price=1/(settlement.technology/2+0.7)
	generateCommodity(settings,commodities,C.CONSUMER_GOODS,price,need,production,1000)

	need=0
	if (settlement.services>0.8) then
		need=populationScore/4
	end
	production=0
	if (settlement.services>1) then
		production=settlement.services/4
	end
	price=1/(settlement.technology+0.5)
	generateCommodity(settings,commodities,C.LUXURY_GOODS,price,need,production,250)



	--Medicine
	need=populationScore
	production=0
	if (settlement.technology>0.8) then
		production=settlement.services/2
	end
	price=1/(settlement.technology*2+0.5)+0.5
	generateCommodity(settings,commodities,C.MEDICINE,price,need,production,200)


	--Industrial
	need=0
	if (settlement.industry>0.3) then
		need=(settlement.industry*2)
	end
	production=0
	if (planet.lua.minerals>0.5) then
		production=(planet.lua.minerals*2)
	end
	price=0.7+settlement.technology/3
	generateCommodity(settings,commodities,C.ORE,price,need,production,1000)


	need=0
	production=0
	if (settlement.technology<1) then
		production=(settlement.industry*2)
	end
	price=1/(settlement.technology/5+0.9)
	generateCommodity(settings,commodities,C.BASIC_TOOLS,price,need,production,200)

	need=0
	if (settlement.technology<0.5) then
		need=populationScore
	end
	production=0
	if (settlement.technology>0.3 and settlement.technology<1) then
		production=(settlement.industry*2)
	end
	price=1/(settlement.technology/4+0.8)
	generateCommodity(settings,commodities,C.PRIMITIVE_INDUSTRIAL,price,need,production,500)

	need=0
	if (settlement.technology>0.3 and settlement.technology<1) then
		need=populationScore/2
	end
	production=0
	if (settlement.technology>0.5) then
		production=settlement.industry
	end
	price=1/(settlement.technology/3+0.8)
	generateCommodity(settings,commodities,C.INDUSTRIAL,price,need,production,500)

	need=0
	if (settlement.technology>0.8) then
		need=populationScore/4
	end
	production=0
	if (settlement.technology>1) then
		production=settlement.industry/4
	end
	price=1/(settlement.technology*2+1)+0.5
	generateCommodity(settings,commodities,C.MODERN_INDUSTRIAL,price,need,production,200)


	--Weapons
	need=0
	production=0
	if (settlement.technology<1) then
		production=(settlement.industry*2)
	end
	price=1/(settlement.technology/5+0.9)
	generateCommodity(settings,commodities,C.BASIC_WEAPONS,price,need,production,200)

	need=0
	if (settlement.technology<0.5) then
		need=populationScore*settlement.military
	end
	production=0
	if (settlement.technology>0.3 and settlement.technology<1) then
		production=(settlement.industry*2)
	end
	price=1/(settlement.technology/4+0.8)
	generateCommodity(settings,commodities,C.PRIMITIVE_ARMAMENT,price,need,production,1000)

	need=0
	if (settlement.technology>0.3 and settlement.technology<1) then
		need=populationScore/2*settlement.military
	end
	production=0
	if (settlement.technology>0.5) then
		production=settlement.industry
	end
	price=1/(settlement.technology/3+0.8)
	generateCommodity(settings,commodities,C.ARMAMENT,price,need,production,500)

	need=0
	if (settlement.technology>0.8) then
		need=populationScore/4*settlement.military
	end
	production=0
	if (settlement.technology>1) then
		production=settlement.industry/4
	end
	price=1/(settlement.technology*2+1)+0.5
	generateCommodity(settings,commodities,C.MODERN_ARMAMENT,price,need,production,250)



	--Buying only exotic luxuries
	need=0
	if (settlement.technology>0.5) then
		need=populationScore*settlement.industry
	end
	price=0.8+settlement.technology*2
	generateCommodity(settings,commodities,C.EXOTIC_ORGANIC,price,need,0,100)

	need=0
	if (settlement.services>0.7) then
		need=populationScore*(settlement.services-0.7)*2
	end
	price=0.8+settlement.technology
	generateCommodity(settings,commodities,C.EXOTIC_FOOD,price,need,0,100)

	need=0
	if (settlement.services>1) then
		need=populationScore*(settlement.services-1)*2
	end
	price=1/(settlement.technology*2+1)+0.8
	generateCommodity(settings,commodities,C.BORDEAUX,price,need,0,5)

	need=0
	if (settlement.services>1) then
		need=populationScore*(settlement.services-0.7)*2
	end
	price=1/(settlement.technology*2+1)+0.5
	generateCommodity(settings,commodities,C.TELLOCH,price,need,0,5)

	need=0
	if (settlement.services>1) then
		need=populationScore*(settlement.services-0.7)*2
	end
	price=0.7+settlement.technology*1.5
	generateCommodity(settings,commodities,C.NATIVE_ARTWORK,price,need,0,100)

	need=0
	if (settlement.services>1) then
		need=populationScore*(settlement.services-0.7)*2
	end
	price=0.8+settlement.technology*1.3
	generateCommodity(settings,commodities,C.NATIVE_SCULPTURES,price,need,0,100)

	need=0
	if (settlement.military>1) then
		need=populationScore*(settlement.military-0.7)*2
	end
	price=0.8+settlement.technology
	generateCommodity(settings,commodities,C.NATIVE_WEAPONS,price,need,0,100)

	if (settlement.suppressGoodDemand) then
		for k,good in pairs(settlement.suppressGoodDemand) do
			suppressCommodityDemand(commodities,good.type)
		end
	end
	if (settlement.suppressGoodSupply) then
		for k,good in pairs(settlement.suppressGoodSupply) do
			suppressCommoditySupply(commodities,good.type)
		end
	end
end

--uses the extra presence mechanism to add presence from other factions
--than the asset's owners. This includes "good" ones like traders but also
--pirates
local function generateExtraPresences(planet,sectorStability)

	local f=planet.c:faction()
	local factionName=""

	if (f and not (f==faction.get(G.NATIVES))) then
		factionName=f:name()
	end


	if (planet.lua.settlements.humans) then
		local settlement=planet.lua.settlements.humans

		local amount=100*(settlement.services+settlement.industry+settlement.agriculture/2)*sectorStability
		local range=1
		if (settlement.technology>0.8) then
			range=2
		end
		if (settlement.technology>1.2) then
			range=3
		end

		if amount<5 then
			amount=5
		end

		if (factionName==G.EMPIRE) then
			planet.c:setFactionExtraPresence(G.IMPERIAL_TRADERS,amount,range)
			planet.c:setFactionExtraPresence(G.INDEPENDENT_TRADERS,amount/2,range)
		else
			planet.c:setFactionExtraPresence(G.INDEPENDENT_TRADERS,amount,range)
		end

		if (settlement.stability<0.6) then
			local amount=100*(1.2-settlement.stability*2)/sectorStability
			local range=2

			if amount<5 then
				amount=5
			end

			planet.c:setFactionExtraPresence(G.PIRATES,amount,range)
		end
	end

	if (planet.lua.settlements.ardars) then
		local settlement=planet.lua.settlements.ardars

		local amount=100*(settlement.services+settlement.industry+settlement.agriculture/2)*sectorStability
		local range=1
		if (settlement.technology>0.8) then
			range=2
		end
		if (settlement.technology>1.2) then
			range=3
		end

		if amount<5 then
			amount=5
		end

		planet.c:setFactionExtraPresence(G.ARDAR_TRADERS,amount,range)

		if (settlement.stability<0.5) then
			local amount=30*(1-settlement.stability*2)/sectorStability
			local range=2

			if amount<5 then
				amount=5
			end

			planet.c:setFactionExtraPresence(G.PIRATES,amount,range)
		end
	end

	if (planet.lua.settlements.betelgeuse) then
		local settlement=planet.lua.settlements.betelgeuse

		local amount=100*(settlement.services+settlement.industry+settlement.agriculture/2)*sectorStability
		local range=1
		if (settlement.technology>0.8) then
			range=2
		end
		if (settlement.technology>1.2) then
			range=3
		end

		if amount<5 then
			amount=5
		end

		planet.c:setFactionExtraPresence(G.BETELGIAN_TRADERS,amount,range)

		if (settlement.stability<0.3) then
			local amount=40*(1-settlement.stability*3)/sectorStability
			local range=2

			if amount<5 then
				amount=5
			end

			planet.c:setFactionExtraPresence(G.PIRATES,amount,range)
		end
	end


	if (planet.lua.settlements.royalixumites) then
		local settlement=planet.lua.settlements.royalixumites

		local amount=100*(settlement.services+settlement.industry+settlement.agriculture/2)*sectorStability
		local range=1
		if (settlement.technology>0.8) then
			range=2
		end
		if (settlement.technology>1.2) then
			range=3
		end

		if amount<5 then
			amount=5
		end

		planet.c:setFactionExtraPresence(G.IMPERIAL_TRADERS,amount,range)
		planet.c:setFactionExtraPresence(G.INDEPENDENT_TRADERS,amount/2,range)
		planet.c:setFactionExtraPresence(G.ARDAR_TRADERS,-1000,1)

		if (settlement.stability<0.5) then
			local amount=100*(1-settlement.stability*2)/sectorStability
			local range=2

			if amount<5 then
				amount=5
			end

			planet.c:setFactionExtraPresence(G.PIRATES,amount,range)
		end
	end

	if (planet.lua.settlements.holyflame) then
		local settlement=planet.lua.settlements.holyflame

		local amount=100*(settlement.services+settlement.industry+settlement.agriculture/2)*sectorStability
		local range=1
		if (settlement.technology>0.8) then
			range=2
		end
		if (settlement.technology>1.2) then
			range=3
		end

		if amount<5 then
			amount=5
		end

		planet.c:setFactionExtraPresence(G.ARDAR_TRADERS,amount,range)
		planet.c:setFactionExtraPresence(G.INDEPENDENT_TRADERS,amount/2,range)

		if (settlement.stability<0.5) then
			local amount=100*(1-settlement.stability*2)/sectorStability
			local range=2

			if amount<5 then
				amount=5
			end

			planet.c:setFactionExtraPresence(G.PIRATES,amount,range)
		end
	end


end

local function removeAllTechGroups(planet)
	for i=1,5 do
		planet.c:removeTechGroup("Generic Civil "..i)
		planet.c:removeTechGroup("Generic Military "..i)
		planet.c:removeTechGroup("Empire Civil "..i)
		planet.c:removeTechGroup("Empire Military "..i)
		planet.c:removeTechGroup("Roidhunate Civil "..i)
		planet.c:removeTechGroup("Roidhunate Military "..i)
		planet.c:removeTechGroup("Betelgeuse Civil "..i)
		planet.c:removeTechGroup("Betelgeuse Military "..i)
		planet.c:removeTechGroup("Royal Ixum Military "..i)
		planet.c:removeTechGroup("Holy Flame Military "..i)
		planet.c:removeTechGroup("Barbarian Civil "..i)
		planet.c:removeTechGroup("Barbarian Military "..i)
	end
end

local function generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,faction)
	planet.c:addTechGroup(faction.." Military 1")
	if (bestIndustry>0.2 and bestTechnology>0.5 and bestMilitary>0.5) then
		planet.c:addTechGroup(faction.." Military 2")
	end
	if (bestIndustry>0.4 and bestTechnology>0.6 and bestMilitary>0.6) then
		planet.c:addTechGroup(faction.." Military 3")
	end
	if (bestIndustry>0.6 and bestTechnology>0.7 and bestMilitary>0.8) then
		planet.c:addTechGroup(faction.." Military 4")
	end
	if (bestIndustry>0.9 and bestTechnology>1 and bestMilitary>0.8) then
		planet.c:addTechGroup(faction.." Military 5")
	end
end

local function generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,faction)
	planet.c:addTechGroup(faction.." Civil 1")
	if (bestIndustry>0.2 and bestTechnology>0.5) then
		planet.c:addTechGroup(faction.." Civil 2")
	end
	if (bestIndustry>0.4 and bestTechnology>0.6) then
		planet.c:addTechGroup(faction.." Civil 3")
	end
	if (bestIndustry>0.6 and bestTechnology>0.7) then
		planet.c:addTechGroup(faction.." Civil 4")
	end
	if (bestIndustry>0.9 and bestTechnology>1) then
		planet.c:addTechGroup(faction.." Civil 5")
	end
end

local function generateCivilizedPlanetServices(planet)

	local bestPop=0
	local bestIndustry=0
	local bestTechnology=0
	local bestMilitary=0
	local bestStability=0

	for k,settlement in pairs(planet.lua.settlements) do
		if (settlement.population>bestPop) then
			bestPop=settlement.population
		end
		if (settlement.industry>bestIndustry) then
			bestIndustry=settlement.industry
		end
		if (settlement.technology>bestTechnology) then
			bestTechnology=settlement.technology
		end
		if (settlement.military>bestMilitary) then
			bestMilitary=settlement.military
		end
		if (settlement.stability>bestStability) then
			bestStability=settlement.stability
		end
	end

  --test to allow this to run in LUA editor
  if planet.c["system"] then
  	local sectorName=planet.c:system():getZone()
  	local sectorStability=getSectorStability(sectorName)
  else
  	local sectorStability=1
  end

  if not sectorStability then
  	sectorStability=1
  end

  bestIndustry=bestIndustry*sectorStability
  bestTechnology=bestTechnology*sectorStability

  planet.c:addService("r")

  if (bestPop>1000) then
  	planet.c:addService("b")
  	planet.c:addService("m")
  	planet.c:addService("c")
  else
  	planet.c:removeService("b")
  	planet.c:removeService("m")
  	planet.c:removeService("c")
  end

  if (bestIndustry>0.5) then
  	planet.c:addService("o")
  else
  	planet.c:removeService("o")
  end

  if (bestIndustry>0.9) then
  	planet.c:addService("s")
  else
  	planet.c:removeService("s")
  end

  removeAllTechGroups(planet)

  local f=planet.c:faction()

  if (f and not (f==faction.get(G.NATIVES))) then
  	factionName=f:name()

  	generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Generic")

  	if (factionName==G.EMPIRE) then
  		generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Empire")
  	elseif (factionName==G.ROIDHUNATE) then
  		generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Roidhunate")
  	elseif (factionName==G.BETELGEUSE) then
  		generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Betelgeuse")
  	elseif (factionName==G.BARBARIANS) then
  		generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Barbarian")
  	elseif (factionName==G.INDEPENDENT_WORLDS) then
  		generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Fringe")
  	end

  	generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Generic")

  	if (factionName==G.EMPIRE) then
  		generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Empire")
  	elseif (factionName==G.ROIDHUNATE) then
  		generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Roidhunate")
  	elseif (factionName==G.BETELGEUSE) then
  		generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Betelgeuse")
  	elseif (factionName==G.BARBARIANS) then
  		generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Barbarian")
  	elseif (factionName==G.ROYAL_IXUM) then
  		generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Royal Ixum")
  	elseif (factionName==G.HOLY_FLAME) then
  		generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Holy Flame")
  	elseif (factionName==G.INDEPENDENT_WORLDS) then
  		generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Fringe")
  	end

  	--special case of Pirate techs
  	if bestStability<0.8 then
  		planet.c:addTechGroup("Pirate Military 1")  		
  	end
  	if bestStability<0.8 and bestTechnology>0.5 then
		planet.c:addTechGroup("Pirate Military 2")
	end
	if bestStability<0.6 and bestTechnology>0.5 then
		planet.c:addTechGroup("Pirate Military 3")
	end
	if bestStability<0.6 and bestTechnology>0.8 then
		planet.c:addTechGroup("Pirate Military 4")
	end
	if bestStability<0.6 and bestTechnology>1 then
		planet.c:addTechGroup("Pirate Military 5")
	end

  	if (bestTechnology<0.5) then
  		range=1
  	elseif (bestTechnology<1) then
  		range=2
  	else
  		range=3
  	end

  	if (factionName==G.BARBARIANS) then
  		range=range*3
  		presence=math.pow(bestPop/10,1/3.4)*bestTechnology/sectorStability
  	else
  		presence=math.pow(bestPop/10,1/3.4)*bestTechnology*sectorStability
  	end

  	planet.c:setFactionPresence(factionName,presence,range)
  end

  generateExtraPresences(planet,sectorStability)


  if debugMode and planet.c:name()=="Luna" then
  	planet.c:addTechGroup("All")
  	planet.c:addService("o")
  	planet.c:addService("s")
  end

end

local function handleSettlementExtraDemandAndSupply(settlement,commodities)
	if (settlement.extraGoodsDemand) then
		for k,good in pairs(settlement.extraGoodsDemand) do
			addCommodity(commodities,good.type,good.price,0,good.demand)
		end
	end
	if (settlement.extraGoodsSupply) then
		for k,good in pairs(settlement.extraGoodsSupply) do
			addCommodity(commodities,good.type,good.price,good.supply,0)
		end
	end
	if (settlement.lesserGoodsDemand) then
		for k,good in pairs(settlement.lesserGoodsDemand) do
			addCommodity(commodities,good.type,good.price,0,-good.demand)
		end
	end
	if (settlement.lesserGoodsSupply) then
		for k,good in pairs(settlement.lesserGoodsSupply) do
			addCommodity(commodities,good.type,good.price,-good.supply,0)
		end
	end
end

function generatePlanetServices(planet)

	if (planet:isCivilized()) then
		generateCivilizedPlanetServices(planet)
	end

	local commodities={}

	if (planet.lua.natives) then
		generateNativesNonCivilizedCommodities(planet,commodities)
	end


	if (planet.lua.settlements) then
		for k,settlement in pairs(planet.lua.settlements) do
			generateSettlementCommoditiesNeedsSupply(productionFactors[k],planet,k,commodities)
			handleSettlementExtraDemandAndSupply(settlement,commodities)
		end
	end

	for name,comData in pairs(commodities) do

		if (comData.supply<0) then
			comData.supply=0
		end
		if (comData.demand<0) then
			comData.demand=0
		end

		if (comData.demandSuppressed) then
			comData.demand=0
		end
		if (comData.supplySuppressed) then
			comData.supply=0
		end

		if (debugMode) then
			if (comData.price<0.1) then
				--error("Extreme low price factor for "..name.." on "..planet.c:name()..": "..comData.price)
				comData.price=0.1
			elseif (comData.price>10) then
				--error("Extreme high price factor for "..name.." on "..planet.c:name()..": "..comData.price)
				comData.price=10
			end
		end

		if (comData.supply>0 or comData.demand>0) then
			planet.c:addOrUpdateTradeData(commodity.get(name),comData.price,comData.supply,comData.demand)
		end
	end

	planet.c:setDescSettlements(generateLiveSettlementsDesc(planet))
	planet.c:setDescHistory(generateLiveHistoryDesc(planet))
end