include('universe/generate_helper.lua')
include('universe/objects/class_planets.lua')
include('universe/live/live_desc.lua')


--Const copy-pasted for auto-completion. Not best design but avoids mistakes
EXOTIC_FOOD="Exotic Food"
FOOD="Food"
GOURMET_FOOD="Gourmet Food"
BORDEAUX="Bordeaux Grands Crus"
TELLOCH="Roidhun Fine Telloch"

PRIMITIVE_CONSUMER="Primitive Consumer Goods"
CONSUMER_GOODS="Consumer Goods"
LUXURY_GOODS="Luxury Goods"

EXOTIC_FURS="Exotic Furs"
NATIVE_ARTWORK="Native Artworks"
NATIVE_SCULPTURES="Native Sculptures"

ORE="Ore"

BASIC_TOOLS="Non-Industrial Tools"
PRIMITIVE_INDUSTRIAL="Primitive Industrial Goods"
INDUSTRIAL="Industrial Goods"
MODERN_INDUSTRIAL="Modern Industrial Goods"

EXOTIC_ORGANIC="Exotic Organic Components"
HUMAN_MEDICINE="Human Medicine"

NATIVE_WEAPONS="Native Weapons"
BASIC_WEAPONS="Non-Industrial Weapons"
PRIMITIVE_ARMAMENT="Primitive Armament"
ARMAMENT="Armament"
MODERN_ARMAMENT="Modern Armament"

NATIVE_TECHNOLOGY="Native Technology"

earth_pos={x=0,y=0}
ardarshir_pos={x=1800,y=-100}
betelgeuse_pos={x=1000,y=460}

local acturus_sector={x=2,y=893}--Diadomes
local taurus_sector={x=340,y=574}--Fez
local antares_sector={x=-346,y=-206}--Kashi
local alphacrusis_sector={x=-685,y=131}--Naeris
local leo_sector={x=700,y=-50}
local sol_sector={x=0,y=0}

imperial_sectors={{center=sol_sector,name="Sector Sol",key="sol"},
	{center=acturus_sector,name="Sector Acturus",key="acturus"},
	{center=taurus_sector,name="Sector Taurus",key="taurus"},
	{center=antares_sector,name="Sector Antares",key="antares"},
	{center=alphacrusis_sector,name="Sector Alpha Crucis",key="alphacrucis"},
	{center=leo_sector,name="Sector Leo",key="leo"}}

imperial_barbarian_zones={	coreward_barb={name="Coreward Barbarian Wastes",key="coreward_barb"},
					rimward_barb={name="Rimward Barbarian Wastes",key="rimward_barb"},
					spinward_barb={name="Spinward Barbarian Wastes",key="spinward_barb"},
					anti_barb={name="Anti-spinward Barbarian Wastes",key="anti_barb"}}

imperial_barbarian_zones_array={imperial_barbarian_zones.coreward_barb,imperial_barbarian_zones.rimward_barb,imperial_barbarian_zones.spinward_barb,imperial_barbarian_zones.anti_barb}


roidhunate_barbarian_zones={	coreward_barb={name="Coreward Roidhunate Barbarian Wastes",key="coreward_barb"},
					rimward_barb={name="Rimward Roidhunate Barbarian Wastes",key="rimward_barb"},
					spinward_barb={name="Spinward Roidhunate Barbarian Wastes",key="spinward_barb"},
					anti_barb={name="Anti-spinward Roidhunate Barbarian Wastes",key="anti_barb"}}

roidhunate_barbarian_zones_array={roidhunate_barbarian_zones.coreward_barb,roidhunate_barbarian_zones.rimward_barb,roidhunate_barbarian_zones.spinward_barb,roidhunate_barbarian_zones.anti_barb}




local productionFactors={}

productionFactors.humans={[TELLOCH]={price=3}}--mostly empty, humans are default

--Ardars: less luxury, more weapons & industry
productionFactors.ardars={
	[FOOD]={demand=1,supply=1},[EXOTIC_FOOD]={demand=0.5},[GOURMET_FOOD]={demand=0.5,supply=0.5},[BORDEAUX]={demand=0.7,price=3},[TELLOCH]={demand=2},
	[PRIMITIVE_CONSUMER]={demand=1,supply=1},[CONSUMER_GOODS]={demand=1,supply=1},
	[LUXURY_GOODS]={demand=0.5,supply=0.2},[EXOTIC_FURS]={demand=0.5},[NATIVE_ARTWORK]={demand=0.5},[NATIVE_SCULPTURES]={demand=0.5},
	[ORE]={demand=1.5},[PRIMITIVE_INDUSTRIAL]={supply=1.2,demand=1.5},[INDUSTRIAL]={supply=1.2,demand=1.5},[MODERN_INDUSTRIAL]={supply=1.2,demand=1.5},[EXOTIC_ORGANIC]={demand=1.5},
	[HUMAN_MEDICINE]={demand=0,supply=0},
	[NATIVE_WEAPONS]={demand=2},[BASIC_WEAPONS]={supply=1.2},[PRIMITIVE_ARMAMENT]={supply=1.2,demand=1.5},[ARMAMENT]={supply=1.2,demand=1.5},[MODERN_ARMAMENT]={supply=1.2,demand=1.5}
}

--betelgeuse: more luxury, less high-tech
productionFactors.betelgeuse={
	[FOOD]={demand=1,supply=1},[EXOTIC_FOOD]={demand=1.5},[GOURMET_FOOD]={demand=1.5,supply=1},[BORDEAUX]={demand=1.5,price=3},[TELLOCH]={demand=1.5},
	[PRIMITIVE_CONSUMER]={demand=1.5,supply=1},[CONSUMER_GOODS]={demand=1.5,supply=1},
	[LUXURY_GOODS]={demand=1.5,supply=1},[EXOTIC_FURS]={demand=2},[NATIVE_ARTWORK]={demand=1},[NATIVE_SCULPTURES]={demand=1},
	[ORE]={demand=1},[PRIMITIVE_INDUSTRIAL]={supply=1,demand=1},[INDUSTRIAL]={supply=1,demand=1},[MODERN_INDUSTRIAL]={supply=0.5,demand=1},[EXOTIC_ORGANIC]={demand=1},
	[HUMAN_MEDICINE]={demand=0,supply=0},
	[NATIVE_WEAPONS]={demand=2},[BASIC_WEAPONS]={supply=1},[PRIMITIVE_ARMAMENT]={supply=1,demand=1},[ARMAMENT]={supply=0.7,demand=1.5},[MODERN_ARMAMENT]={supply=0.3,demand=1}
}

--Civilized natives
productionFactors.natives={
	[FOOD]={demand=0,supply=0},[EXOTIC_FOOD]={demand=1.5},[GOURMET_FOOD]={demand=0.5,supply=0.5},[BORDEAUX]={demand=0},[TELLOCH]={demand=0},
	[PRIMITIVE_CONSUMER]={demand=1,supply=1},[CONSUMER_GOODS]={demand=1,supply=1},
	[LUXURY_GOODS]={demand=0.5,supply=0.5},[EXOTIC_FURS]={demand=1},[NATIVE_ARTWORK]={demand=1},[NATIVE_SCULPTURES]={demand=1},
	[ORE]={demand=1},[PRIMITIVE_INDUSTRIAL]={supply=1,demand=1.5},[INDUSTRIAL]={supply=1,demand=1},[MODERN_INDUSTRIAL]={supply=0,demand=0},[EXOTIC_ORGANIC]={demand=1},
	[HUMAN_MEDICINE]={demand=0,supply=0},
	[NATIVE_WEAPONS]={demand=1},[BASIC_WEAPONS]={supply=1},[PRIMITIVE_ARMAMENT]={supply=1,demand=1.5},[ARMAMENT]={supply=1,demand=1.5},[MODERN_ARMAMENT]={supply=0,demand=0}
}

--Barbarians
productionFactors.barbarians={
	[FOOD]={demand=0,supply=0},[EXOTIC_FOOD]={demand=0},[GOURMET_FOOD]={demand=0,supply=0},[BORDEAUX]={demand=0},[TELLOCH]={demand=0},
	[PRIMITIVE_CONSUMER]={demand=2,supply=0.5},[CONSUMER_GOODS]={demand=2,supply=0.2},
	[LUXURY_GOODS]={demand=3,supply=0.2},[EXOTIC_FURS]={demand=0},[NATIVE_ARTWORK]={demand=0},[NATIVE_SCULPTURES]={demand=0},
	[ORE]={demand=1},[PRIMITIVE_INDUSTRIAL]={supply=0.5,demand=1.5},[INDUSTRIAL]={supply=0.3,demand=1.5},[MODERN_INDUSTRIAL]={supply=0,demand=0},[EXOTIC_ORGANIC]={demand=0},
	[HUMAN_MEDICINE]={demand=0,supply=0},
	[NATIVE_WEAPONS]={demand=0},[BASIC_WEAPONS]={supply=1},[PRIMITIVE_ARMAMENT]={supply=1,demand=1.5},[ARMAMENT]={supply=1,demand=1.5},[MODERN_ARMAMENT]={supply=0,demand=0}
}

function initStatusVar()

	var.push("universe_emperor","Georgios Manuel Krishna Murasaki")

	for _,v in pairs(imperial_sectors) do
		var.push("universe_stability_"..v.key,0.9)
		var.push("universe_stability_min_"..v.key,0.8)
		var.push("universe_stability_max_"..v.key,1)
	end
	var.push("universe_stability_sol",1)

	for _,v in pairs(imperial_barbarian_zones_array) do
		var.push("universe_barbarian_activity_"..v.key,0.5)
		var.push("universe_barbarian_activity_min_"..v.key,0.4)
		var.push("universe_barbarian_activity_max_"..v.key,0.6)
	end
end

function updateUniverseDesc()
	local desc=[[The Empire is weak - damaged by corruption, hounded by barbarians, locked in a deadly rivalry with the Roidhunate.

Current Emperor: His Imperial Majesty, High Emperor ]]..var.peek("universe_emperor")..[[

Current stability of the Imperial Sectors:

]]

	for _,v in ipairs(imperial_sectors) do
		local stability=var.peek("universe_stability_"..v.key)
		desc=desc..[[	]]..v.name..": "..gh.floorTo(100*stability)..'%\n'
	end

	desc=desc..[[

Beyond the Empire's borders, barbarians are rising to raid civilized worlds.

Current barbarian activity:

]]

	for _,v in ipairs(imperial_barbarian_zones_array) do
		local activity=var.peek("universe_barbarian_activity_"..v.key)
		desc=desc..[[	]]..v.name..": "..gh.floorTo(100*activity)..'%\n'
	end

	var.push("universe_status",desc)
end

function getSectorStability(sectorName)
	for _,v in pairs(imperial_sectors) do
		if sectorName==v.name then
			return var.peek("universe_stability_"..v.key),var.peek("universe_stability_min_"..v.key),var.peek("universe_stability_max_"..v.key)
		end
	end

	return nil,nil,nil
end

function setSectorStability(sectorName,stability)
	for _,v in pairs(imperial_barbarian_zones) do
		if sectorName==v.name then
			var.push("universe_stability_"..v.key,stability)
		end
	end
	
	for _,p in pairs(planet.getAll()) do
		if p:system() and p:system():getZone()==sectorName then
			generatePlanetServices(planet_class.load(p))
		end
	end

	updateUniverseDesc()
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

	updateUniverseDesc()
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

function get_nearest_barbarian_zone(star)

	local dist_earth=gh.calculateDistance(earth_pos,star)
	local dist_ardarshir=gh.calculateDistance(ardarshir_pos,star)

	if (dist_earth<dist_ardarshir) then

		local dx=star.x-earth_pos.x
		local dy=star.y-earth_pos.y

		if math.abs(dx)>math.abs(dy) then
			if (dx>0) then
				return imperial_barbarian_zones.spinward_barb
			else
				return imperial_barbarian_zones.anti_barb
			end
		else
			if (dy>0) then
				return imperial_barbarian_zones.coreward_barb
			else
				return imperial_barbarian_zones.rimward_barb
			end
		end
	else
		local dx=star.x-ardarshir_pos.x
		local dy=star.y-ardarshir_pos.y

		if math.abs(dx)>math.abs(dy) then
			if (dx>0) then
				return roidhunate_barbarian_zones.spinward_barb
			else
				return roidhunate_barbarian_zones.anti_barb
			end
		else
			if (dy>0) then
				return roidhunate_barbarian_zones.coreward_barb
			else
				return roidhunate_barbarian_zones.rimward_barb
			end
		end
	end
end

local function addCommodity(commodities,commodity,price,supply,demand)
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

	--Calculating tendency to depart from base price
	--0 equals no departure, 1 max.
	priceMouvement=1-(settlement.technology*settlement.services)/2

	if (priceMouvement<0.1) then
		priceMouvement=0.1
	elseif (priceMouvement>1) then
		priceMouvement=1
	end

	local price,need,production

	populationScore=(math.log10(settlement.population)/10)

	need=populationScore*8
	production=10*settlement.agriculture
	price=settlement.services/(settlement.agriculture)

	generateCommodity(settings,commodities,FOOD,price,need,production,100)

	need=0
	if (settlement.services>0.7) then
		need=populationScore*(settlement.services-0.7)*2
	end
	production=0
	if (settlement.agriculture>1.0) then
		production=(settlement.agriculture-1)*2
	end
	price=(settlement.services+0.3)/(settlement.agriculture)+0.1

	generateCommodity(settings,commodities,GOURMET_FOOD,price,need,production,20)

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
	generateCommodity(settings,commodities,PRIMITIVE_CONSUMER,price,need,production,100)

	need=0
	if (settlement.services>0.3) then
		need=settlement.services/2
	end
	production=0
	if (settlement.technology>0.5) then
		production=settlement.services
	end
	price=1/(settlement.technology/2+0.7)
	generateCommodity(settings,commodities,CONSUMER_GOODS,price,need,production,50)

	need=0
	if (settlement.services>0.8) then
		need=populationScore/4
	end
	production=0
	if (settlement.services>1) then
		production=settlement.services/4
	end
	price=1/(settlement.technology+0.5)
	generateCommodity(settings,commodities,LUXURY_GOODS,price,need,production,25)



	--Medicine
	need=populationScore
	production=0
	if (settlement.technology>0.8) then
		production=settlement.services/2
	end
	price=1/(settlement.technology*2+0.5)+0.5
	generateCommodity(settings,commodities,HUMAN_MEDICINE,price,need,production,20)


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
	generateCommodity(settings,commodities,ORE,price,need,production,100)


	need=0
	production=0
	if (settlement.technology<1) then
		production=(settlement.industry*2)
	end
	price=1/(settlement.technology/5+0.9)
	generateCommodity(settings,commodities,BASIC_TOOLS,price,need,production,20)

	need=0
	if (settlement.technology<0.5) then
		need=populationScore
	end
	production=0
	if (settlement.technology>0.3 and settlement.technology<1) then
		production=(settlement.industry*2)
	end
	price=1/(settlement.technology/4+0.8)
	generateCommodity(settings,commodities,PRIMITIVE_INDUSTRIAL,price,need,production,50)

	need=0
	if (settlement.technology>0.3 and settlement.technology<1) then
		need=populationScore/2
	end
	production=0
	if (settlement.technology>0.5) then
		production=settlement.industry
	end
	price=1/(settlement.technology/3+0.8)
	generateCommodity(settings,commodities,INDUSTRIAL,price,need,production,50)

	need=0
	if (settlement.technology>0.8) then
		need=populationScore/4
	end
	production=0
	if (settlement.technology>1) then
		production=settlement.industry/4
	end
	price=1/(settlement.technology*2+1)+0.5
	generateCommodity(settings,commodities,MODERN_INDUSTRIAL,price,need,production,200)


	--Weapons
	need=0
	production=0
	if (settlement.technology<1) then
		production=(settlement.industry*2)
	end
	price=1/(settlement.technology/5+0.9)
	generateCommodity(settings,commodities,BASIC_WEAPONS,price,need,production,20)

	need=0
	if (settlement.technology<0.5) then
		need=populationScore*settlement.military
	end
	production=0
	if (settlement.technology>0.3 and settlement.technology<1) then
		production=(settlement.industry*2)
	end
	price=1/(settlement.technology/4+0.8)
	generateCommodity(settings,commodities,PRIMITIVE_ARMAMENT,price,need,production,100)

	need=0
	if (settlement.technology>0.3 and settlement.technology<1) then
		need=populationScore/2*settlement.military
	end
	production=0
	if (settlement.technology>0.5) then
		production=settlement.industry
	end
	price=1/(settlement.technology/3+0.8)
	generateCommodity(settings,commodities,ARMAMENT,price,need,production,50)

	need=0
	if (settlement.technology>0.8) then
		need=populationScore/4*settlement.military
	end
	production=0
	if (settlement.technology>1) then
		production=settlement.industry/4
	end
	price=1/(settlement.technology*2+1)+0.5
	generateCommodity(settings,commodities,MODERN_ARMAMENT,price,need,production,25)



	--Buying only exotic luxuries
	need=0
	if (settlement.technology>0.5) then
		need=populationScore*settlement.industry
	end
	price=0.8+settlement.technology*2
	generateCommodity(settings,commodities,EXOTIC_ORGANIC,price,need,0,10)

	need=0
	if (settlement.services>0.7) then
		need=populationScore*(settlement.services-0.7)*2
	end
	price=0.8+settlement.technology
	generateCommodity(settings,commodities,EXOTIC_FOOD,price,need,0,10)

	need=0
	if (settlement.services>1) then
		need=populationScore*(settlement.services-1)*2
	end
	price=1/(settlement.technology*2+1)+0.8
	generateCommodity(settings,commodities,BORDEAUX,price,need,0,5)

	need=0
	if (settlement.services>1) then
		need=populationScore*(settlement.services-0.7)*2
	end
	price=1/(settlement.technology*2+1)+0.5
	generateCommodity(settings,commodities,TELLOCH,price,need,0,5)

	need=0
	if (settlement.services>1) then
		need=populationScore*(settlement.services-0.7)*2
	end
	price=0.7+settlement.technology*1.5
	generateCommodity(settings,commodities,NATIVE_ARTWORK,price,need,0,10)

	need=0
	if (settlement.services>1) then
		need=populationScore*(settlement.services-0.7)*2
	end
	price=0.8+settlement.technology*1.3
	generateCommodity(settings,commodities,NATIVE_SCULPTURES,price,need,0,10)

	need=0
	if (settlement.military>1) then
		need=populationScore*(settlement.military-0.7)*2
	end
	price=0.8+settlement.technology
	generateCommodity(settings,commodities,NATIVE_WEAPONS,price,need,0,10)

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

local function generateExtraPresences(planet,sectorStability)

  local f=planet.c:faction()
  local factionName=""

	if (f and not (f==faction.get("Natives"))) then
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
    
    if (factionName=="Empire of Terra") then
      planet.c:setFactionExtraPresence("Imperial Trader",amount,range)
      planet.c:setFactionExtraPresence("Independent Trader",amount/2,range)
    else
      planet.c:setFactionExtraPresence("Independent Trader",amount,range)
    end

		if (settlement.stability<0.5) then
			local amount=100*(1-settlement.stability*2)/sectorStability
			local range=2
			planet.c:setFactionExtraPresence("Pirate",amount,range)
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

		planet.c:setFactionExtraPresence("Ardar Trader",amount,range)

		if (settlement.stability<0.3) then
			local amount=30*(1-settlement.stability*3)/sectorStability
			local range=2
			planet.c:setFactionExtraPresence("Pirate",amount,range)
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

		planet.c:setFactionExtraPresence("Betelgian Trader",amount,range)

		if (settlement.stability<0.3) then
			local amount=40*(1-settlement.stability*3)/sectorStability
			local range=2
			planet.c:setFactionExtraPresence("Pirate",amount,range)
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

	if (f and not (f==faction.get("Natives"))) then
		factionName=f:name()
    
  generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Generic")

		if (factionName=="Empire of Terra") then
			generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Empire")
		elseif (factionName=="Roidhunate of Ardarshir") then
			generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Roidhunate")
		elseif (factionName=="Oligarchy of Betelgeuse") then
			generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Betelgeuse")
		elseif (factionName=="Barbarians") then
			generateTechnologiesCivilian(planet,bestIndustry,bestTechnology,"Barbarian")
		end

  generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Generic")

		if (factionName=="Empire of Terra") then
			generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Empire")
		elseif (factionName=="Roidhunate of Ardarshir") then
			generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Roidhunate")
		elseif (factionName=="Oligarchy of Betelgeuse") then
			generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Betelgeuse")
		elseif (factionName=="Barbarians") then
			generateTechnologiesMilitary(planet,bestIndustry,bestTechnology,bestMilitary,"Barbarian")
		end


		
		if (bestTechnology<0.5) then
			range=1
		elseif (bestTechnology<1) then
			range=2
		else
			range=3
		end

		if (factionName=="Barbarians") then
			range=range*3
			presence=math.pow(bestPop/10,1/3.4)*bestTechnology/sectorStability
		else
			presence=math.pow(bestPop/10,1/3.4)*bestTechnology*sectorStability
		end
		
		planet.c:setFactionPresence(factionName,presence,range)
	end
	
	generateExtraPresences(planet,sectorStability)
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

		if (comData.supply>0 or comData.demand>0) then
			planet.c:addOrUpdateTradeData(commodity.get(name),comData.price,comData.supply,comData.demand)
		end
	end

	planet.c:setDescSettlements(generateLiveSettlementsDesc(planet))
	planet.c:setDescHistory(generateLiveHistoryDesc(planet))
end