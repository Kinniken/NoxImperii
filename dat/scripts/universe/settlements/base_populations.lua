include('universe/generate_helper.lua')
include('universe/generate_nameGenerator.lua')
include('universe/settlements/human_settlements.lua')
include('universe/settlements/merseian_settlements.lua')
include('universe/settlements/barbarian_settlements.lua')
include('universe/settlements/betelgeuse_settlements.lua')
include('universe/objects/class_settlements.lua')
include("universe/live/universe_status.lua")

base_populations= {} --public interface

local function imperial_sector_names(star)

	local sector=nil
	local bestdist=nil

	for _,v in pairs(imperial_sectors) do
		if not sector then
			sector=v.name
			bestdist=gh.calculateDistance(v.center,star)
		else
			if (gh.calculateDistance(v.center,star)<bestdist) then
				sector=v.name
				bestdist=gh.calculateDistance(v.center,star)
			end
		end
	end

	return sector
end

local function imperial_fringes_names(star)

	local dx=star.x-earth_pos.x
	local dy=star.y-earth_pos.y

	if math.abs(dx)>math.abs(dy) then
		if (dx>0) then
			return "Spinward Fringes"
		else
			return "Anti-spinward Fringes"
		end
	else
		if (dy>0) then
			return "Coreward Fringes"
		else
			return "Rimward Fringes"
		end
	end
end

local function barbarian_fringes_names(star)
	return get_nearest_barbarian_zone(star).name
end

local function outer_zone_generate(star)

end

local function barbarian_priority(star)
	if (gh.calculateDistance(earth_pos,star)<1500 or gh.calculateDistance(merseia_pos,star)<1000) then
		return 5
	end

	return 0
end

local function empire_merseia_border_priority(star,priority)
	local distanceEarth=gh.calculateDistance(earth_pos,star)
	local distanceMerseia=gh.calculateDistance(merseia_pos,star)

	if (distanceEarth<1000 and distanceMerseia<1200) then
		return priority
	end

	return 0
end

local function priority_distance(centre,star,radius,priority)
	local distance=gh.calculateDistance(centre,star)

	if (distance<radius) then
		return priority
	end

	return 0
end

local function generate_human_population(star,planet,minFertility,settlementChance,populationRange,industryFactor,agricultureFactor,technologyFactor,militaryFactor,stabilityFactor,
				factionName)
	if (planet.lua.humanFertility>minFertility and math.random()<settlementChance) then
		local settlement=settlement_class.createNew()
		settlement.population=gh.randomInRange(populationRange)*planet.lua.humanFertility
		settlement.industry=(planet.lua.humanFertility*0.2+planet.lua.minerals*0.5+0.3)*industryFactor
		settlement.agriculture=(planet.lua.humanFertility*0.8+0.2)*agricultureFactor
		settlement.technology=technologyFactor
		settlement.services=(settlement.industry+settlement.agriculture+math.log10(settlement.population)/10)*(1+settlement.technology)/5
		settlement.military=militaryFactor*(3+settlement.industry+settlement.agriculture+settlement.services)/5
		settlement.stability=stabilityFactor

		settlement:randomizeSettlementData(0.2)
		
		planet.lua.settlements.humans=settlement
		planet.faction=factionName
		planet.factionPresence=1
		planet.factionRange=1

		star.nameGenerator=nameGenerator.getEmpireNameGenerator()
	end
end

local function generate_merseia_population(planet,minFertility,settlementChance,populationRange,industryFactor,agricultureFactor,technologyFactor,militaryFactor,stabilityFactor)
	if (planet.lua.humanFertility>minFertility and math.random()<settlementChance) then
		local settlement=settlement_class.createNew()
		settlement.population=gh.randomInRange(populationRange)*planet.lua.humanFertility
		settlement.industry=(planet.lua.humanFertility*0.2+planet.lua.minerals*0.5+0.7)*industryFactor
		settlement.agriculture=(planet.lua.humanFertility*0.8+0.2)*agricultureFactor
		settlement.technology=technologyFactor
		settlement.services=(settlement.industry+settlement.agriculture+math.log10(settlement.population)/10)*(1+settlement.technology)/7
		settlement.military=militaryFactor*(3+settlement.industry+settlement.agriculture+settlement.services)/4
		settlement.stability=stabilityFactor

		settlement:randomizeSettlementData(0.2)
		
		planet.lua.settlements.merseians=settlement
		planet.faction="Roidhunate of Merseia"
		planet.factionPresence=1
		planet.factionRange=1
	end
end

local function generate_barbarian_population(star,planet,minFertility,settlementChance,populationRange,industryFactor,agricultureFactor,technologyFactor,militaryFactor,stabilityFactor,
				factionName)
	if (planet.lua.nativeFertility>minFertility and math.random()<settlementChance) then
		local settlement=settlement_class.createNew()
		settlement.population=gh.randomInRange(populationRange)*planet.lua.nativeFertility
		settlement.industry=(planet.lua.humanFertility*0.2+planet.lua.minerals*0.5+0.3)*industryFactor
		settlement.agriculture=(planet.lua.nativeFertility*0.8+0.2)*agricultureFactor
		settlement.technology=technologyFactor
		settlement.services=(settlement.industry+settlement.agriculture+math.log10(settlement.population)/10)*(1+settlement.technology)/20
		settlement.military=militaryFactor*(3+settlement.industry+settlement.agriculture+settlement.services)/2
		settlement.stability=stabilityFactor

		settlement:randomizeSettlementData(0.2)
		
		planet.lua.settlements.barbarians=settlement
		planet.faction=factionName
		planet.factionPresence=1
		planet.factionRange=1
	end
end

local function betelgeuse_generate(star)
	for k,planet in pairs(star.planets) do
		if (planet.lua.humanFertility>0) then
			local settlement=settlement_class.createNew()
			settlement.population=1000+planet.lua.humanFertility*1000000000*math.random() --up to a billion
			settlement.industry=planet.lua.humanFertility*0.2+planet.lua.minerals*0.3+0,5
			settlement.industry=settlement.industry*(0.8+0.4*math.random())-- + or - 20%
			settlement.agriculture=planet.lua.humanFertility*0.6+0.4
			settlement.agriculture=settlement.agriculture*(0.8+0.4*math.random())-- + or - 20%
			settlement.technology=0.7
			settlement.technology=settlement.technology*(0.8+0.4*math.random())-- + or - 20%
			settlement.services=(settlement.industry+settlement.agriculture+math.log10(settlement.population)/10)*(1+settlement.technology)/20
			settlement.military=(3+settlement.industry+settlement.agriculture+settlement.services)/3
			settlement.stability=0.8

			settlement:randomizeSettlementData(0.2)
			
			planet.lua.settlements.betelgeuse=settlement
			planet.faction="Oligarchy of Betelgeuse"
			planet.factionPresence=1
			planet.factionRange=1
		end
	end
end

local function empire_inner_generate(star)
	for k,planet in pairs(star.planets) do
		generate_human_population(star,planet,0.2,1,{1000000,1000000000},1.5,1.5,1,0.5,1,"Empire of Terra");
	end
end

local function empire_outer_generate(star)
	for k,planet in pairs(star.planets) do
		generate_human_population(star,planet,0.3,0.7,{100000,100000000},1,1,0.6,1,0.7,"Empire of Terra");
	end
end

local function empire_fringe_generate(star)
	if (math.random()<0.8) then
		for k,planet in pairs(star.planets) do
			generate_human_population(star,planet,0.5,0.7,{50000,20000000},0.8,0.7,0.5,3,0.3,"Empire of Terra");
		end
	else
		for k,planet in pairs(star.planets) do
			generate_human_population(star,planet,0.5,0.7,{50000,20000000},0.5,0.8,0.3,1.5,0.3,"Independent");
		end
	end
end

local function empire_merseia_border_generate(star)
	for k,planet in pairs(star.planets) do
		generate_human_population(star,planet,0.5,0.7,{50000,20000000},0.8,0.7,0.5,5,0.7,"Empire of Terra");
	end
end

local function empire_outer_fringe_generate(star)

	if (math.random()<0.5) then
		for k,planet in pairs(star.planets) do
			generate_human_population(star,planet,0.5,0.7,{50000,10000000},0.5,0.8,0.2,1.5,0.3,"Independent");
		end
	else
		for k,planet in pairs(star.planets) do
			if (math.random()<0.9) then-- barbarian colony
				generate_barbarian_population(star,planet,0.5,0.4,{500000,2000000},0.3,0.5,0.2,3,0.8,"Barbarians");
			else-- barbarian "home world"
				planet.lua.natives=nil
				generate_barbarian_population(star,planet,0.5,0.4,{5000000,500000000},0.3,0.8,0.3,3,0.8,"Barbarians");
			end
		end
	end
end

local function barbarian_fringe_generate(star)
	for k,planet in pairs(star.planets) do
		if (math.random()<0.6) then-- barbarian colony
			generate_barbarian_population(star,planet,0.5,0.4,{500000,2000000},0.3,0.5,0.2,3,0.8,"Barbarians");
		else-- barbarian "home world"
			planet.lua.natives=nil
			generate_barbarian_population(star,planet,0.5,0.4,{5000000,500000000},0.3,0.8,0.3,3,0.8,"Barbarians");
		end
	end
end

local function merseia_inner_generate(star)
	for k,planet in pairs(star.planets) do
		generate_merseia_population(planet,0.2,1,{100000000,1000000000},1.5,1.5,0.9,0.8,1.2)
	end
end

local function merseia_outer_generate(star)
	for k,planet in pairs(star.planets) do
		generate_merseia_population(planet,0.3,0.7,{10000000,100000000},1,1,0.5,1.2,0.9)
	end
end

local function merseia_fringe_generate(star)
	for k,planet in pairs(star.planets) do
		generate_merseia_population(planet,0.5,0.4,{1000000,10000000},0.5,0.5,0.3,1.5,0.6)
	end
end




local outer_zone={name="outer_zone",priority=function() return 1 end,generate=function(star) end,nativeCivilization=0,nativeFaction="Independent",zoneName=function(star) return "Great Beyond" end}
local empire_inner={name="empire_inner",priority=function(star) return priority_distance(earth_pos,star,250,100) end,
	generate=empire_inner_generate,
	specialSettlement=settlement_generator.coreHumanSettlements,nativeCivilization=1,nativeFactors={agriculture=1,industry=1,services=1,technology=1,military=0.5,stability=1},nativeFaction="Empire of Terra",zoneName=function(star) return "Sector Sol" end}
local empire_outer={name="empire_outer",priority=function(star) return priority_distance(earth_pos,star,600,50) end,generate=empire_outer_generate,specialSettlement=settlement_generator.outerHumanSettlements,nativeCivilization=0.9,nativeFactors={agriculture=0.8,industry=0.7,services=0.5,technology=0.7,military=0.7,stability=0.7},nativeFaction="Empire of Terra",zoneName=imperial_sector_names}

local empire_border={name="empire_border",priority=function(star) return priority_distance(earth_pos,star,900,20) end,generate=empire_fringe_generate,
specialSettlement=gh.concatLists({settlement_generator.fringeEmpireSettlements,settlement_generator.fringeHumanIndependentSettlements}),
nativeCivilization=0.6,nativeFactors={agriculture=0.7,industry=0.5,services=0.3,technology=0.5,military=0.9,stability=0.5},nativeFaction="Independent",zoneName=imperial_sector_names}

local empire_merseia_border={name="empire_merseia_border",priority=function(star) return empire_merseia_border_priority(star,25) end,generate=empire_merseia_border_generate,
specialSettlement=settlement_generator.fringeEmpireSettlements,
nativeCivilization=0.6,nativeFactors={agriculture=0.7,industry=0.5,services=0.3,technology=0.5,military=0.9,stability=0.7},nativeFaction="Empire of Terra",zoneName=imperial_sector_names}

local empire_fringe={name="empire_fringe",priority=function(star) return priority_distance(earth_pos,star,1200,10) end,generate=empire_outer_fringe_generate,
specialSettlement=gh.concatLists({settlement_generator.barbarianSettlements,settlement_generator.fringeHumanIndependentSettlements}),
nativeCivilization=0.3,nativeFactors={agriculture=0.5,industry=0.3,services=0.2,technology=0.3,military=1,stability=0.5},nativeFaction="Independent",zoneName=imperial_fringes_names}

local barbarian_fringe={name="barbarian_fringe",priority=function(star) return barbarian_priority(star) end,generate=barbarian_fringe_generate,specialSettlement=settlement_generator.barbarianSettlements,nativeCivilization=0,nativeFactors={agriculture=0.5,industry=0.3,services=0.1,technology=0.2,military=1.2,stability=0.3},nativeFaction="Independent",zoneName=barbarian_fringes_names}

local merseia_inner={name="merseia_inner",priority=function(star) return priority_distance(merseia_pos,star,250,100) end,generate=merseia_inner_generate,specialSettlement=settlement_generator.coreMerseianSettlements,nativeCivilization=1,nativeFactors={agriculture=1,industry=1,services=1,technology=1,military=0.5,stability=1.2},nativeFaction="Roidhunate of Merseia",zoneName=function(star) return "Inner Roidhunate" end}

local merseia_outer={name="merseia_outer",priority=function(star) return priority_distance(merseia_pos,star,500,45) end,generate=merseia_outer_generate,nativeCivilization=0.5,nativeFactors={agriculture=0.8,industry=0.7,services=0.5,technology=0.7,military=0.7,stability=0.9},nativeFaction="Roidhunate of Merseia",zoneName=function(star) return "Outer Roidhunate" end}

local merseia_fringe={name="merseia_fringe",priority=function(star) return priority_distance(merseia_pos,star,700,18) end,generate=merseia_fringe_generate,nativeCivilization=0.3,nativeFactors={agriculture=0.7,industry=0.5,services=0.3,technology=0.5,military=0.9,stability=0.7},nativeFaction="Independent",zoneName=function(star) return "Roidhunate Fringes" end}

local betelgeuse={name="betelgeuse",priority=function(star) return priority_distance(betelgeuse_pos,star,200,100) end,generate=betelgeuse_generate,specialSettlement=gh.concatLists({settlement_generator.betelgeuseSettlements}),nativeCivilization=0.8,nativeFactors={agriculture=0.8,industry=0.7,services=0.5,technology=0.7,military=0.8,stability=0.8},nativeFaction="Oligarchy of Betelgeuse",zoneName=function(star) return "Betelgeuse" end}

base_populations.templates={outer_zone,barbarian_fringe,empire_inner,empire_outer,empire_border,empire_merseia_border,empire_fringe,merseia_inner,merseia_outer,merseia_fringe,betelgeuse}