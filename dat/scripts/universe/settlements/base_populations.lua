include('dat/scripts/general_helper.lua')
include('universe/generate_nameGenerator.lua')
include('universe/settlements/human_settlements.lua')
include('universe/settlements/ardar_settlements.lua')
include('universe/settlements/barbarian_settlements.lua')
include('universe/settlements/betelgeuse_settlements.lua')
include('universe/settlements/royal_ixum_settlements.lua')
include('universe/settlements/holy_flame_settlements.lua')
include('universe/objects/class_settlements.lua')
include("universe/live/live_universe.lua")
include("universe/locations.lua")

--[[
Defines "templates" for populating systems. They have criteria to be valid
(typically defined in terms of coordinates on the map) and define methods to be
used to actually populate the matching systems based on the selected template.
]]

population_templates = {} --public interface



local function generate_human_population(star,planet,minFertility,settlementChance,populationRange,industryFactor,agricultureFactor,technologyFactor,militaryFactor,stabilityFactor,
				factionName)
	if (planet.template.classification=="Earth-like" and planet.lua.humanFertility>minFertility and math.random()<settlementChance) then
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
	elseif planet.planet and factionName==G.EMPIRE and planet.template.classification=="Asteroid Moon" and planet.planet.lua.settlements and planet.planet.lua.settlements.humans then--Asteroid orbiting an Imperial settlement
		if (math.random()*2<planet.planet.lua.settlements.humans.services) then--the higher the services, the more chance the moon will be used
			local settlement=settlement_class.createNew()
			settlement.population=gh.randomInRange(populationRange)*0.001
			settlement.industry=planet.planet.lua.settlements.humans.industry/4
			settlement.agriculture=0.1
			settlement.technology=technologyFactor
			settlement.services=planet.planet.lua.settlements.humans.services
			settlement.military=planet.planet.lua.settlements.humans.military/2
			settlement.stability=stabilityFactor

			settlement:randomizeSettlementData(0.2)

			planet.lua.settlements.humans=settlement
			planet.faction=factionName
			planet.factionPresence=1
			planet.factionRange=1
		end
	elseif planet.planet and factionName==G.EMPIRE and planet.template.classification=="Silicate Moon" and planet.planet.lua.settlements and planet.planet.lua.settlements.humans then--Asteroid orbiting an Imperial settlement
		if (math.random()*2<planet.planet.lua.settlements.humans.services) then--the higher the services, the more chance the moon will be used
			local settlement=settlement_class.createNew()
			settlement.population=gh.randomInRange(populationRange)*0.002
			settlement.industry=planet.planet.lua.settlements.humans.industry/2
			settlement.agriculture=0.1
			settlement.technology=technologyFactor
			settlement.services=planet.planet.lua.settlements.humans.services
			settlement.military=planet.planet.lua.settlements.humans.military/2
			settlement.stability=stabilityFactor

			settlement:randomizeSettlementData(0.2)

			planet.lua.settlements.humans=settlement
			planet.faction=factionName
			planet.factionPresence=1
			planet.factionRange=1
		end
	end
end

local function generate_ardar_population(star,planet,minFertility,settlementChance,populationRange,industryFactor,agricultureFactor,technologyFactor,militaryFactor,stabilityFactor)
	if (planet.template.classification=="Earth-like" and planet.lua.humanFertility>minFertility and math.random()<settlementChance) then
		local settlement=settlement_class.createNew()
		settlement.population=gh.randomInRange(populationRange)*planet.lua.humanFertility
		settlement.industry=(planet.lua.humanFertility*0.2+planet.lua.minerals*0.5+0.7)*industryFactor
		settlement.agriculture=(planet.lua.humanFertility*0.8+0.2)*agricultureFactor
		settlement.technology=technologyFactor
		settlement.services=(settlement.industry+settlement.agriculture+math.log10(settlement.population)/10)*(1+settlement.technology)/7
		settlement.military=militaryFactor*(3+settlement.industry+settlement.agriculture+settlement.services)/4
		settlement.stability=stabilityFactor

		settlement:randomizeSettlementData(0.2)

		planet.lua.settlements.ardars=settlement
		planet.faction=G.ROIDHUNATE
		planet.factionPresence=1
		planet.factionRange=1

		star.nameGenerator=nameGenerator.generateNameArdarshir
	elseif planet.planet and factionName==G.ROIDHUNATE and planet.template.classification=="Asteroid Moon" and planet.planet.lua.settlements and planet.planet.lua.settlements.ardars then--Asteroid orbiting an Ardar settlement
		if (math.random()*2<planet.planet.lua.settlements.ardars.services) then--the higher the services, the more chance the moon will be used
			local settlement=settlement_class.createNew()
			settlement.population=gh.randomInRange(populationRange)*0.001
			settlement.industry=planet.planet.lua.settlements.ardars.industry/4
			settlement.agriculture=0.1
			settlement.technology=technologyFactor
			settlement.services=planet.planet.lua.settlements.ardars.services
			settlement.military=planet.planet.lua.settlements.ardars.military/2
			settlement.stability=stabilityFactor

			settlement:randomizeSettlementData(0.2)

			planet.lua.settlements.ardars=settlement
			planet.faction=factionName
			planet.factionPresence=1
			planet.factionRange=1
		end
	elseif planet.planet and factionName==G.ROIDHUNATE and planet.template.classification=="Silicate Moon" and planet.planet.lua.settlements and planet.planet.lua.settlements.ardars then--Asteroid orbiting an Ardar settlement
		if (math.random()*2<planet.planet.lua.settlements.ardars.services) then--the higher the services, the more chance the moon will be used
			local settlement=settlement_class.createNew()
			settlement.population=gh.randomInRange(populationRange)*0.002
			settlement.industry=planet.planet.lua.settlements.ardars.industry/2
			settlement.agriculture=0.1
			settlement.technology=technologyFactor
			settlement.services=planet.planet.lua.settlements.ardars.services
			settlement.military=planet.planet.lua.settlements.ardars.military/2
			settlement.stability=stabilityFactor

			settlement:randomizeSettlementData(0.2)

			planet.lua.settlements.ardars=settlement
			planet.faction=factionName
			planet.factionPresence=1
			planet.factionRange=1
		end
	end
end

--basically copied from the human one
local function generate_ixumite_population(star,planet,minFertility,settlementChance,populationRange,industryFactor,agricultureFactor,technologyFactor,militaryFactor,stabilityFactor,
				factionName)
	if (planet.template.classification=="Earth-like" and planet.lua.humanFertility>minFertility and math.random()<settlementChance) then
		local settlement=settlement_class.createNew()
		settlement.population=gh.randomInRange(populationRange)*planet.lua.humanFertility
		settlement.industry=(planet.lua.humanFertility*0.2+planet.lua.minerals*0.5+0.3)*industryFactor
		settlement.agriculture=(planet.lua.humanFertility*0.8+0.2)*agricultureFactor
		settlement.technology=technologyFactor
		settlement.services=(settlement.industry+settlement.agriculture+math.log10(settlement.population)/10)*(1+settlement.technology)/5
		settlement.military=militaryFactor*(3+settlement.industry+settlement.agriculture+settlement.services)/5
		settlement.stability=stabilityFactor

		settlement:randomizeSettlementData(0.2)
		
		if (factionName==G.ROYAL_IXUM) then
			planet.lua.settlements.royalixumites=settlement
		else
			planet.lua.settlements.holyflame=settlement
		end
		planet.faction=factionName
		planet.factionPresence=1
		planet.factionRange=1

		star.nameGenerator=nameGenerator.generateNameIxum
	end
end

local function generate_barbarian_population(star,planet,minFertility,settlementChance,populationRange,industryFactor,agricultureFactor,technologyFactor,militaryFactor,stabilityFactor,
				factionName)
	if (planet.template.classification=="Earth-like" and planet.lua.nativeFertility>minFertility and math.random()<settlementChance) then
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

		star.nameGenerator=nameGenerator.getRandomBarbarianGenerator()
	end
end

local function betelgeuse_generate(star)
	for k,planet in pairs(star.planets) do
		if (planet.template.classification=="Earth-like" and planet.lua.humanFertility>0) then
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
			planet.faction=G.BETELGEUSE
			planet.factionPresence=1
			planet.factionRange=1

			star.nameGenerator=nameGenerator.generateNameBetelgeuse
		elseif planet.planet and planet.template.classification=="Asteroid Moon" and planet.planet.lua.settlements and planet.planet.lua.settlements.betelgeuse then--Asteroid orbiting an Betelgian settlement
			if (math.random()*2<planet.planet.lua.settlements.betelgeuse.services) then--the higher the services, the more chance the moon will be used
				local settlement=settlement_class.createNew()
				settlement.population=1000+planet.lua.humanFertility*10000*math.random()
				settlement.industry=planet.planet.lua.settlements.betelgeuse.industry/4
				settlement.agriculture=0.1
				settlement.technology=0.7
				settlement.services=planet.planet.lua.settlements.betelgeuse.services
				settlement.military=planet.planet.lua.settlements.betelgeuse.military/2
				settlement.stability=0.8

				settlement:randomizeSettlementData(0.2)

				planet.lua.settlements.betelgeuse=settlement
				planet.faction=factionName
				planet.factionPresence=1
				planet.factionRange=1
			end
		elseif planet.planet and planet.template.classification=="Silicate Moon" and planet.planet.lua.settlements and planet.planet.lua.settlements.betelgeuse then--Asteroid orbiting an Betelgian settlement
			if (math.random()*2<planet.planet.lua.settlements.betelgeuse.services) then--the higher the services, the more chance the moon will be used
				local settlement=settlement_class.createNew()
				settlement.population=1000+planet.lua.humanFertility*1000000*math.random()
				settlement.industry=planet.planet.lua.settlements.betelgeuse.industry/2
				settlement.agriculture=0.1
				settlement.technology=0.7
				settlement.services=planet.planet.lua.settlements.betelgeuse.services
				settlement.military=planet.planet.lua.settlements.betelgeuse.military/2
				settlement.stability=0.8

				settlement:randomizeSettlementData(0.2)

				planet.lua.settlements.betelgeuse=settlement
				planet.faction=G.BETELGEUSE
				planet.factionPresence=1
				planet.factionRange=1
			end
		end
	end
end

local function empire_inner_generate(star)
	for k,planet in pairs(star.planets) do
		generate_human_population(star,planet,0.2,1,{1000000,1000000000},1.5,1.5,1,0.5,1,G.EMPIRE);
	end
end

local function empire_hyades_generate(star)
	for k,planet in pairs(star.planets) do
		generate_human_population(star,planet,0.2,1,{1000000,200000000},0.8,1.5,0.8,0.8,0.9,G.EMPIRE);
	end
end

local function empire_outer_generate(star)
	for k,planet in pairs(star.planets) do
		generate_human_population(star,planet,0.3,0.7,{100000,100000000},1,1,0.6,1,0.6,G.EMPIRE);
	end
end

local function empire_blessed_generate(star)
	for k,planet in pairs(star.planets) do
		generate_human_population(star,planet,0.3,0.7,{500000,500000000},1,1,0.6,1,1,G.EMPIRE);
	end
end

local function empire_fringe_generate(star)
	if (math.random()<0.8) then
		for k,planet in pairs(star.planets) do
			generate_human_population(star,planet,0.5,0.7,{50000,20000000},0.8,0.7,0.5,3,0.3,G.EMPIRE);
		end
	else
		for k,planet in pairs(star.planets) do
			generate_human_population(star,planet,0.5,0.7,{50000,20000000},0.5,0.8,0.3,1.5,0.3,G.INDEPENDENT_WORLDS);
		end
	end
end

local function empire_ardarshir_border_generate(star)
	
end

local function empire_outer_fringe_generate(star)
	if (math.random()<0.5) then
		for k,planet in pairs(star.planets) do
			generate_human_population(star,planet,0.5,0.7,{50000,10000000},0.5,0.8,0.2,1.5,0.3,G.INDEPENDENT_WORLDS);
		end
	else
		for k,planet in pairs(star.planets) do
			if (math.random()<0.9) then-- barbarian colony
				generate_barbarian_population(star,planet,0.5,0.4,{500000,2000000},0.3,0.5,0.2,3,0.8,G.BARBARIANS);
			else-- barbarian "home world"
				planet.lua.natives=nil
				generate_barbarian_population(star,planet,0.5,0.4,{5000000,500000000},0.3,0.8,0.3,3,0.8,G.BARBARIANS);
			end
		end
	end
end

local function empire_orion_fringe_generate(star)
	if (math.random()<0.3) then
		for k,planet in pairs(star.planets) do
			generate_human_population(star,planet,0.5,0.7,{50000,10000000},0.5,0.8,0.2,1.5,0.3,G.INDEPENDENT_WORLDS);
		end
	else
		for k,planet in pairs(star.planets) do
			if (math.random()<0.6) then-- barbarian colony
				generate_barbarian_population(star,planet,0.5,0.4,{500000,2000000},0.3,0.5,0.2,3,0.8,G.BARBARIANS);
			else-- barbarian "home world"
				planet.lua.natives=nil
				generate_barbarian_population(star,planet,0.5,0.4,{5000000,500000000},0.3,0.8,0.3,3,0.8,G.BARBARIANS);
			end
		end
	end
end

local function barbarian_fringe_generate(star)
	for k,planet in pairs(star.planets) do
		if (math.random()<0.6) then-- barbarian colony
			generate_barbarian_population(star,planet,0.5,0.4,{500000,2000000},0.3,0.5,0.2,3,0.8,G.BARBARIANS);
		else-- barbarian "home world"
			planet.lua.natives=nil
			generate_barbarian_population(star,planet,0.5,0.4,{5000000,500000000},0.3,0.8,0.3,3,0.8,G.BARBARIANS);
		end
	end
end

local function barbarian_heavy_generate(star)
	for k,planet in pairs(star.planets) do
		if (math.random()<0.3) then-- barbarian colony
			generate_barbarian_population(star,planet,0.5,0.4,{500000,2000000},0.3,0.5,0.2,4,0.8,G.BARBARIANS);
		else-- barbarian "home world"
			planet.lua.natives=nil
			generate_barbarian_population(star,planet,0.5,0.4,{5000000,500000000},0.3,0.8,0.3,4,0.8,G.BARBARIANS);
		end
	end
end

local function ardarshir_inner_generate(star)
	for k,planet in pairs(star.planets) do
		generate_ardar_population(star,planet,0.2,1,{100000000,1000000000},1.5,1.5,0.9,0.8,1.2)
	end
end

local function ardarshir_outer_generate(star)
	for k,planet in pairs(star.planets) do
		generate_ardar_population(star,planet,0.3,0.7,{10000000,100000000},1,1,0.5,1.2,0.9)
	end
end

local function ardarshir_fringe_generate(star)
	for k,planet in pairs(star.planets) do
		generate_ardar_population(star,planet,0.5,0.4,{1000000,10000000},0.5,0.5,0.3,1.5,0.6)
	end
end

local function royal_ixum_generate(star)
	for k,planet in pairs(star.planets) do
		generate_ixumite_population(star,planet,0.5,1,{50000,20000000},0.8,0.7,1,3,0.7,G.ROYAL_IXUM);
	end
end

local function holy_flame_generate(star)
	for k,planet in pairs(star.planets) do
		generate_ixumite_population(star,planet,0.5,1,{200000,5000000000},0.8,0.7,0.5,3,0.8,G.HOLY_FLAME);
	end
end



--the templates themselves
population_templates.great_outer={name="great_outer",generate=function(star) end,nativeCivilization=0,nativeFaction=G.INDEPENDENT_WORLDS}

population_templates.empire_inner={name="empire_inner",generate=empire_inner_generate,specialSettlement={["Earth-like"]=settlement_generator.coreHumanSettlements,["Cold Earth-like"]=settlement_generator.coreHumanSettlements,["Warm Earth-like"]=settlement_generator.coreHumanSettlements,["Asteroid Moon"]=settlement_generator.asteroidMoonHumanSettlements,["Silicate Moon"]=settlement_generator.worldMoonHumanSettlements},nativeCivilization=1,nativeFactors={agriculture=1,industry=1,services=1,technology=1,military=0.5,stability=1},nativeFaction=G.EMPIRE}

population_templates.empire_hyades={name="empire_hyades",generate=empire_hyades_generate,
	specialSettlement={["Earth-like"]=settlement_generator.hyadesSettlements,["Cold Earth-like"]=settlement_generator.hyadesSettlements,["Warm Earth-like"]=settlement_generator.hyadesSettlements,["Asteroid Moon"]=settlement_generator.asteroidMoonHumanSettlements,["Silicate Moon"]=settlement_generator.worldMoonHumanSettlements},nativeCivilization=1,nativeFactors={agriculture=1,industry=1,services=1,technology=1,military=0.5,stability=1},nativeFaction=G.EMPIRE}

population_templates.empire_outer={name="empire_outer",generate=empire_outer_generate,specialSettlement={["Earth-like"]=settlement_generator.outerHumanSettlements,["Warm Earth-like"]=settlement_generator.outerHumanSettlements,["Cold Earth-like"]=settlement_generator.outerHumanSettlements,["Asteroid Moon"]=settlement_generator.asteroidMoonHumanSettlements,["Silicate Moon"]=settlement_generator.worldMoonHumanSettlements},nativeCivilization=0.9,nativeFactors={agriculture=0.8,industry=0.7,services=0.5,technology=0.7,military=0.7,stability=0.6},nativeFaction=G.EMPIRE}

population_templates.empire_blessed={name="empire_blessed",generate=empire_blessed_generate,specialSettlement={["Earth-like"]=settlement_generator.blessedSettlements,["Warm Earth-like"]=settlement_generator.blessedSettlements,["Cold Earth-like"]=settlement_generator.blessedSettlements,["Asteroid Moon"]=settlement_generator.asteroidMoonHumanSettlements,["Silicate Moon"]=settlement_generator.worldMoonHumanSettlements},nativeCivilization=0.9,nativeFactors={agriculture=0.8,industry=0.7,services=0.5,technology=0.7,military=0.7,stability=0.7},nativeFaction=G.EMPIRE}


population_templates.empire_border={name="empire_border",generate=empire_fringe_generate,
specialSettlement={["Earth-like"]=gh.concatLists({settlement_generator.fringeEmpireSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Warm Earth-like"]=gh.concatLists({settlement_generator.fringeEmpireSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Cold Earth-like"]=gh.concatLists({settlement_generator.fringeEmpireSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Asteroid Moon"]=settlement_generator.asteroidMoonHumanSettlements,["Silicate Moon"]=settlement_generator.worldMoonHumanSettlements},
nativeCivilization=0.6,nativeFactors={agriculture=0.7,industry=0.5,services=0.3,technology=0.5,military=0.9,stability=0.5},nativeFaction=G.INDEPENDENT_WORLDS}

population_templates.empire_ardarshir_border={name="empire_ardarshir_border",generate=empire_ardarshir_border_generate,
specialSettlement={},nativeCivilization=0.6,nativeFactors={agriculture=0.7,industry=0.5,services=0.3,technology=0.5,military=0.9,stability=0.7},nativeFaction=G.INDEPENDENT_WORLDS}

population_templates.empire_fringe={name="empire_fringe",generate=empire_outer_fringe_generate,
specialSettlement={["Earth-like"]=gh.concatLists({settlement_generator.barbarianSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Warm Earth-like"]=gh.concatLists({settlement_generator.barbarianSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Cold Earth-like"]=gh.concatLists({settlement_generator.barbarianSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Asteroid Moon"]=settlement_generator.asteroidMoonHumanSettlements,["Silicate Moon"]=settlement_generator.worldMoonHumanSettlements},
nativeCivilization=0.3,nativeFactors={agriculture=0.5,industry=0.3,services=0.2,technology=0.3,military=1,stability=0.5},nativeFaction=G.INDEPENDENT_WORLDS}

population_templates.empire_orion_fringe={name="empire_orion_fringe",generate=empire_orion_fringe_generate,
specialSettlement={["Earth-like"]=gh.concatLists({settlement_generator.barbarianSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Warm Earth-like"]=gh.concatLists({settlement_generator.barbarianSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Cold Earth-like"]=gh.concatLists({settlement_generator.barbarianSettlements,settlement_generator.fringeHumanIndependentSettlements}),["Asteroid Moon"]=settlement_generator.asteroidMoonHumanSettlements,["Silicate Moon"]=settlement_generator.worldMoonHumanSettlements},
nativeCivilization=0.3,nativeFactors={agriculture=0.5,industry=0.3,services=0.2,technology=0.3,military=1,stability=0.3},nativeFaction=G.INDEPENDENT_WORLDS}

population_templates.barbarian_fringe={name="barbarian_fringe",generate=barbarian_fringe_generate,specialSettlement={["Earth-like"]=settlement_generator.barbarianSettlements,["Warm Earth-like"]=settlement_generator.barbarianSettlements,["Cold Earth-like"]=settlement_generator.barbarianSettlements},nativeCivilization=0,nativeFactors={agriculture=0.5,industry=0.3,services=0.1,technology=0.2,military=1.2,stability=0.3},nativeFaction=G.NATIVES}

population_templates.barbarian_heavy={name="barbarian_heavy",generate=barbarian_heavy_generate,specialSettlement={["Earth-like"]=settlement_generator.barbarianSettlements,["Warm Earth-like"]=settlement_generator.barbarianSettlements,["Cold Earth-like"]=settlement_generator.barbarianSettlements},nativeCivilization=0,nativeFactors={agriculture=0.5,industry=0.3,services=0.1,technology=0.2,military=1.5,stability=0.3},nativeFaction=G.NATIVES}

population_templates.ardarshir_inner={name="ardarshir_inner",generate=ardarshir_inner_generate,specialSettlement={["Earth-like"]=settlement_generator.coreArdarSettlements,["Warm Earth-like"]=settlement_generator.coreArdarSettlements,["Cold Earth-like"]=settlement_generator.coreArdarSettlements,["Asteroid Moon"]=settlement_generator.asteroidMoonArdarSettlements,["Silicate Moon"]=settlement_generator.worldMoonArdarSettlements},nativeCivilization=1,nativeFactors={agriculture=1,industry=1,services=1,technology=1,military=0.5,stability=1.2},nativeFaction=G.ROIDHUNATE}

population_templates.ardarshir_outer={name="ardarshir_outer",generate=ardarshir_outer_generate,nativeCivilization=0.5,nativeFactors={agriculture=0.8,industry=0.7,services=0.5,technology=0.7,military=0.7,stability=0.9},nativeFaction=G.ROIDHUNATE}

population_templates.ardarshir_fringe={name="ardarshir_fringe",generate=ardarshir_fringe_generate,nativeCivilization=0.1,nativeFactors={agriculture=0.7,industry=0.5,services=0.3,technology=0.5,military=0.9,stability=0.7},nativeFaction=G.ROIDHUNATE}

population_templates.betelgeuse={name="betelgeuse",generate=betelgeuse_generate,specialSettlement={["Earth-like"]=settlement_generator.betelgeuseSettlements,["Warm Earth-like"]=settlement_generator.betelgeuseSettlements,["Cold Earth-like"]=settlement_generator.betelgeuseSettlements,["Asteroid Moon"]=settlement_generator.asteroidMoonBetelgianSettlements,["Silicate Moon"]=settlement_generator.worldMoonBetelgianSettlements},nativeCivilization=0.8,nativeFactors={agriculture=0.8,industry=0.7,services=0.5,technology=0.7,military=0.8,stability=0.8},nativeFaction=G.BETELGEUSE}

population_templates.kingdom_of_ixum={name="kingdom_of_ixum",generate=royal_ixum_generate,specialSettlement={["Earth-like"]=settlement_generator.royalIxumSettlements,["Warm Earth-like"]=settlement_generator.royalIxumSettlements,["Cold Earth-like"]=settlement_generator.royalIxumSettlements},
nativeCivilization=0.3,nativeFactors={agriculture=0.5,industry=0.3,services=0.2,technology=0.3,military=1,stability=0.5},nativeFaction=G.NATIVES}

population_templates.holy_flame_of_ixum={name="holy_flame_of_ixum",generate=holy_flame_generate,specialSettlement={["Earth-like"]=settlement_generator.holyFlameSettlements,["Warm Earth-like"]=settlement_generator.holyFlameSettlements,["Cold Earth-like"]=settlement_generator.holyFlameSettlements},
nativeCivilization=0.3,nativeFactors={agriculture=0.5,industry=0.3,services=0.2,technology=0.3,military=1,stability=0.5},nativeFaction=G.NATIVES}
