
include('universe/objects/class_settlements.lua')
include('universe/objects/class_planets.lua')
include('universe/objects/class_natives.lua')
include('dat/scripts/general_helper.lua')
include('universe/planets/planet_templates.lua')
include('universe/settlements/base_populations.lua')
include('universe/generate_nameGenerator.lua')
include('universe/locations.lua')

starGenerator = {}

local planetRandomAttributes={"mass","ua","planetRadius","temperature","dayLength","yearLength"}--temporary for generation
local planetLuaRandomAttributes={"nativeFertility","humanFertility","minerals"}--saved in lua data

local handleNames,generatePlanetCoords,generatePlanets,nameTaken,generatePopulations,generatePlanetLuaData,populateSystem

local function nameTakenSystem(name)
	return (system.exists(name))
end

local function nameTakenPlanet(name)
	return (planet.exists(name))
end

function starGenerator.createAroundStar(c_sys,nextlevel,level,visited)

	visited[c_sys:name()]=true

	local known=(debugMode and true or false)

	local sys=system_class.load(c_sys)

	if (not sys.lua.generatedNearbySystems) then
		local x,y=sys.c:coords()

		local stellarTemplate=pickStellarTemplate({x=x,y=y})

		for i=1,25 do

			local radius=stellarTemplate.radius()
			local angle=math.random()*math.pi*2

			local targetx = x + radius * math.cos(angle);
			local targety = y + radius * math.sin(angle);

			local existingSystems=system.withinRadius(targetx,targety,stellarTemplate.minDistance())

			if (#existingSystems==0) then

				local star=starGenerator.generateStar(targetx,targety,nameTakenSystem,nameTakenPlanet)

				if star ~= nil then
					local zoneName=get_zone(star).zoneName(star)

					if (zoneName==nil) then
						error("Nil zone name for "..get_zone(star).id)
					end

					system.createSystem(star.name,targetx,targety,stellarTemplate.starNumbers(),star.template.radius,stellarTemplate.interference(),stellarTemplate.nebuVolatility(),stellarTemplate.nebuDensity(),stellarTemplate.background(),zoneName,known)

					local newsys=system.get(star.name)

					newsys:addStar(star.spacePict)

					for k2,p in pairs(star.planets) do

						if p.baseDesc == nil or p.baseDesc=="" then
							print("Warning: planet with no baseDesc: "..p.name)
							p.baseDesc="MISSING"
						end
						if p.barDesc == nil or p.barDesc=="" then
							print("Warning: planet with no barDesc: "..p.name)
							p.barDesc=" "
						end

						newsys:createPlanet(p.name,p.x,p.y,p.spacePict,p.exteriorPict,p.factionPresence,p.factionRange,p.faction,p.baseDesc," ","History",p.barDesc,0,0,p.template.classification,1,"",p.services.fuel,p.services.bar,p.services.missions,p.services.commodity,p.services.outfits,p.services.shipyard,known)

						p.c=planet.get(p.name)

						generatePlanetServices(p)

						p.lua.initialized=true
						p:save()
					end

					system.createJump(newsys,sys.c,true,known)

					local nearbySystems=system.withinRadius(targetx,targety,105)

					for k2,nearbySystem in pairs(nearbySystems) do
						if (nearbySystem~=newsys) then
							system.createJump(newsys,nearbySystem,true,known)
						end
					end

					--if not enough jumps we try targeting somewhat father systems
					if (#(system.jumps(newsys))<3) then
						nearbySystems=system.withinRadius(targetx,targety,120)

						for k2,nearbySystem in pairs(nearbySystems) do
							if (nearbySystem~=newsys) then
								system.createJump(newsys,nearbySystem,true,known)
							end
						end
					end

					nextlevel[#nextlevel+1]=newsys
				end
			end
		end

		sys.lua.generatedNearbySystems=true
		sys:save()
	else
		for k,nearbySysC in pairs(sys.c:adjacentSystems(true)) do
			nearbySys=system_class.load(nearbySysC)

			if not visited[nearbySysC:name()] then
				nextlevel[#nextlevel+1]=nearbySysC
			end
		end
	end
end

function starGenerator.generateStar(x,y,nameTakenSystem,nameTakenPlanet)
	local star={}
	star.x=x
	star.y=y

	local stellar_template=pickStellarTemplate(star)
	
	if #stellar_template.templates == 0 then--rift etc.
		return nil
	end

	star.template=gh.pickWeightedObject(stellar_template.templates)

	star.populationTemplate=pickPopulationTemplate(star)

	star.spacePict=star.template.spacePicts[math.random(#star.template.spacePicts)]

	star.nameGenerator=nameGenerator.generateNameEmpty

	star.planets={}

	generatePlanets(star)

	handleNames(star,nameTakenSystem,nameTakenPlanet)

	return star
end

function pickStellarTemplate(star)
	local zone=get_zone(star)

	return stellar_templates[zone.star_template]
end

function pickPopulationTemplate(star)
	local zone=get_zone(star)

	if population_templates[zone.pop_template]==nil then
		error("Unknown population template: "..zone.pop_template)
	end

	return population_templates[zone.pop_template]
end

function handleNames(star,nameTakenSystem,nameTakenPlanet)

	--rule: if one or more planet has a generator, we use it for the star
	--(if more than one planet has one, the last one "wins")
	for k,planet in pairs(star.planets) do
		if (planet.nameGenerator) then
			star.nameGenerator=planet.nameGenerator
		end
	end

	star.name=generateUniqueName(star.nameGenerator,nameTakenSystem)

	--planet generator has priority over star generator
	for k,planet in pairs(star.planets) do

		if planet.planet then--actually a moon

			if star.nameGenerator ~= nameGenerator.generateNameEmpty then
				--proper name generator, Moon gets a name of its own
				planet.name=generateUniqueName(star.nameGenerator,nameTakenPlanet)
			else
				--no specific generator, let's go for the a b c moon system
				local alphabet = 'abcdefghijklmnopqrstuvwxyz'
				local id=1

				while (id<=#alphabet and not planet.name) do
					local name=planet.planet.name..alphabet:sub(id, id)
					local taken=false
					--outside system
					if nameTakenPlanet(name) then
						taken=true
					end
					--in-system
					for k2,v in pairs(star.planets) do
						if v.name==name then
							taken=true
						end
					end

					if not taken then
						planet.name=name
					end
					id=id+1
				end
			end

			planet.baseDesc=planet.baseDesc:gsub("#planetname#", planet.planet.name)
			planet.baseDesc=planet.baseDesc:gsub("#moonname#", planet.name)

			planet.lua.planet=planet.planet.name--for future reference
		else
			if (planet.nameGenerator) then
				planet.name=generateUniqueName(planet.nameGenerator,nameTakenPlanet)
			else
				planet.name=generateUniqueName(star.nameGenerator,nameTakenPlanet)
			end

			planet.baseDesc=planet.baseDesc:gsub("#planetname#", planet.name)
		end

		planet.baseDesc=planet.baseDesc:gsub("#sunname#", star.name)
    
    if planet.barDescGenerators ~= nil then
      planet.barDesc=gh.pickConditionalWeightedObject(planet.barDescGenerators,planet).getDesc(planet)
    else
      planet.barDesc=" "
    end
	end

end

function generatePlanetCoords(star,planet)

	local minRadius=star.template.radius*planet.template.minRadius
	local maxRadius=star.template.radius*planet.template.maxRadius

	local attempts=0

	while (attempts<30) do
		local radius=minRadius+math.random(maxRadius-minRadius)
		local angle=math.random()*math.pi*2

		local x = radius * math.cos(angle);
		local y = radius * math.sin(angle);

		local clash=false

		--test if the coords are too close to an existing planet
		for k,planet in pairs(star.planets) do
			if (gh.calculateDistance(planet,{x=x,y=y}) < 2000) then
				clash=true
			end
		end

		if (not clash) then
			planet.x=math.floor(x)
			planet.y=math.floor(y)
			return
		end

		attempts=attempts+1
	end

	--too bad, we'll return clashing coords
	local radius=minRadius+math.random(maxRadius-minRadius)
	local angle=math.random()*math.pi*2

	local x = radius * math.cos(angle);
	local y = radius * math.sin(angle);

	planet.x=math.floor(x)
	planet.y=math.floor(y)

end

function generateMoonCoords(star,planet,moon)

	local minRadius=moon.template.minRadius
	local maxRadius=moon.template.maxRadius

	local attempts=0

	while (attempts<30) do
		local radius=minRadius+math.random(maxRadius-minRadius)
		local angle=math.random()*math.pi*2

		local x = radius * math.cos(angle);
		local y = radius * math.sin(angle);

		local clash=false

		--test if the coords are too close to an existing planet
		for k,aplanet in pairs(star.planets) do
			if ((aplanet ~= planet) and gh.calculateDistance(aplanet,{x=x+planet.x,y=y+planet.y}) < 500) then
				clash=true
			end
		end

		if (not clash) then
			moon.x=math.floor(x)+planet.x
			moon.y=math.floor(y)+planet.y
			return
		end

		attempts=attempts+1
	end

	--too bad, we'll return clashing coords
	local radius=minRadius+math.random(maxRadius-minRadius)
	local angle=math.random()*math.pi*2

	local x = radius * math.cos(angle);
	local y = radius * math.sin(angle);

	moon.x=math.floor(x)+planet.x
	moon.y=math.floor(y)+planet.y

end

 function generatePlanets(star)
 	local nbPlanets=gh.randomInRange(star.template.nbPlanets)

 	for i=1,nbPlanets do
 		local planetType=gh.pickWeightedObject(star.template.planets)
		local planet=planet_class.createNew()
		planet.template=gh.pickWeightedObject(planetType.planetClass).template
    
		for k,randomAttribute in pairs(planetRandomAttributes) do
			if (planet.template[randomAttribute]~=nil) then
				planet[randomAttribute]=gh.randomInRange(planet.template[randomAttribute])
			else
				planet[randomAttribute]=0
			end
		end

		for k,randomAttribute in pairs(planetLuaRandomAttributes) do
			if (planet.template[randomAttribute]~=nil) then
				planet.lua[randomAttribute]=gh.randomInRange(planet.template[randomAttribute])
			else
				planet.lua[randomAttribute]=0
			end
		end
		
		planet.spacePict=planet.template.spacePicts[ math.random(#planet.template.spacePicts)]
		planet.exteriorPict=planet.template.exteriorPicts[ math.random(#planet.template.exteriorPicts)]

		planet.lua.planetType=planet.template.id

		generatePlanetCoords(star,planet)

		star.planets[#star.planets+1]=planet
		planet.star=star

		if (planet.template.moonTemplate) then

			local nb=planet.template.nbMoons[ math.random(#planet.template.nbMoons)]

			for i=1,nb do
				local moonTemplate=gh.pickWeightedObject(planet.template.moonTemplate).template
				local moon=planet_class.createNew()
				moon.template=moonTemplate

				for k,randomAttribute in pairs(planetRandomAttributes) do
					if (moon.template[randomAttribute]~=nil) then
						moon[randomAttribute]=gh.randomInRange(moon.template[randomAttribute])
					else
						moon[randomAttribute]=0
					end
				end

				for k,randomAttribute in pairs(planetLuaRandomAttributes) do
					if (moon.template[randomAttribute]~=nil) then
						moon.lua[randomAttribute]=gh.randomInRange(moon.template[randomAttribute])
					else
						moon.lua[randomAttribute]=0
					end
				end

				moon.spacePict=moon.template.spacePicts[ math.random(#moon.template.spacePicts)]
				moon.exteriorPict=moon.template.exteriorPicts[ math.random(#moon.template.exteriorPicts)]

				moon.lua.planetType=moon.template.id

				generateMoonCoords(star,planet,moon)

				star.planets[#star.planets+1]=moon
				moon.star=star
				moon.planet=planet
			end
		end

	end

	populateSystemNatives(star)
	populateSystemCivilized(star)

	for k,planet in pairs(star.planets) do
		planet.baseDesc=planet.template.descGenerator(planet)

		if (planet.lua.natives) then
			planet.baseDesc=planet.baseDesc.."\n\n"..planet.nativeType.getDesc(planet)
			if (planet.nativeSpeciality) then
				planet.baseDesc=planet.baseDesc..planet.nativeSpeciality.getDesc(planet)
			end
		end
		for k,settlement in pairs(planet.lua.settlements) do
			if (planet.settlementTypes[k]) then
				planet.baseDesc=planet.baseDesc.."\n\n"..planet.settlementTypes[k].getDesc(planet)
				if (planet.settlementSpecialities[k]) then
					planet.baseDesc=planet.baseDesc..planet.settlementSpecialities[k].getDesc(planet)
				end
			end
		end
	end

	--making natives a settlement if they are civilized (to handle them the same way for services etc.)
	for k,planet in pairs(star.planets) do
		if (planet.lua.natives and planet.lua.natives.civilized) then
			planet.lua.settlements.natives=planet.lua.natives
			planet.lua.natives=nil
		end
	end
end

function populateSystemNatives(star)
	for k,planet in pairs(star.planets) do
		if (planet.template.possibleNatives and math.random()<0.3 and ((planet.lua.nativeFertility+0.3)>math.random())) then
			local natives=gh.pickConditionalWeightedObject(planet.template.possibleNatives,planet)

			if (natives) then
				natives.applyOnPlanet(planet)
				planet.nativeType=natives --needed later to generate desc
				planet.lua.natives.type=natives.id

				if (natives.specialities) then
					local speciality=gh.pickConditionalWeightedObject(natives.specialities,planet)
					if (speciality) then
						speciality.applyOnPlanet(planet)
						planet.nativeSpeciality=speciality
					end
				end
			end
		end
	end
end

function populateSystemCivilized(star)
	star.populationTemplate.generate(star)

	if (star.populationTemplate.specialSettlement) then
		for k,planet in pairs(star.planets) do

			if (star.populationTemplate.specialSettlement[planet.template.classification]) then

				local settlement=gh.pickConditionalWeightedObject(star.populationTemplate.specialSettlement[planet.template.classification],planet)

				if (settlement) then
					settlement.applyOnPlanet(planet)
					planet.settlementTypes[settlement.appliesTo]=settlement --needed later to generate desc
          planet.barDescGenerators=settlement.barDescGenerators

					if (settlement.specialities) then
						local speciality=gh.pickConditionalWeightedObject(settlement.specialities,planet)
						if (speciality) then
							speciality.applyOnPlanet(planet)
							planet.settlementSpecialities[settlement.appliesTo]=speciality --needed later to generate desc
						end
					end
				end
			end
        end
	end
end

function generateUniqueName(nameGenerator,nameTaken)

	local cpt=0

	repeat
		local name=nameGenerator()

		if (not nameTaken(name)) then
			return name
		end

		cpt=cpt+1
	until (cpt>20)

	return nameGenerator().." "..math.random(100000)
end



