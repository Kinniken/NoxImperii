
include('universe/objects/class_settlements.lua')
include('universe/objects/class_planets.lua')
include('universe/objects/class_natives.lua')
include('dat/scripts/general_helper.lua')
include('universe/planets/planet_templates.lua')
include('universe/settlements/base_populations.lua')
include('universe/generate_nameGenerator.lua')

starGenerator = {}

local planetRandomAttributes={"mass","ua","planetRadius","temperature","dayLength","yearLength"}--temporary for generation
local planetLuaRandomAttributes={"nativeFertility","humanFertility","minerals"}--saved in lua data

local handleNames,generatePlanetCoords,generatePlanets,nameTaken,generatePopulations,generatePlanetLuaData,populateSystem

function starGenerator.generateStar(x,y,nameTakenSystem,nameTakenPlanet)
	local star={}
	star.x=x
	star.y=y

	star.template=gh.pickWeightedObject(starTemplates.starsTemplate)
	star.populationTemplate=pickPopulationTemplate(star)

	star.spacePict=star.template.spacePicts[math.random(#star.template.spacePicts)]

	star.nameGenerator=nameGenerator.generateNameEmpty

	star.planets={}

	generatePlanets(star)

	handleNames(star,nameTakenSystem,nameTakenPlanet)

	if star.populationTemplate.zoneName then
		star.zone=star.populationTemplate.zoneName(star)
	else
		star.zone=""
	end

	return star
end

function pickPopulationTemplate(star)
	local pickedTemplate
	local priority=0

	for k,template in pairs(base_populations.templates) do
		if (not pickedTemplate) then
			pickedTemplate=template
			priority=template.priority(star)
		elseif (template.priority(star)>priority) then
			pickedTemplate=template
			priority=template.priority(star)
		end
	end

	return pickedTemplate
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