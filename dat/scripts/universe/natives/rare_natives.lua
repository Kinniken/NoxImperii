--To be included ONLY via generate_natives


local all = {}

natives_generator.rare_natives=all

all.symbionts={
	weight=2,
	label="Symbionts",
	applyOnPlanet=function(planet)
		local natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({1000000,10000000}),
			planet:areNativeCivilized())
		planet.lua.natives=natives
		if (not natives.civilized) then			
			natives_generator.setNativeDemands(planet,1,1,0.5,0,0.5)
		else
			natives_generator.generateNativeCivilizedData(planet,0.3,0.5,1,0.5,0.5)
		end

		natives:addTag("rare")

		planet.lua.natives:addGoodSupply(C.NATIVE_SCULPTURES,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		local desc="The "..planet.lua.natives.name.." civilization is the product of a rare symbiosis of two sapient species of comparable intelligence: one of quadrupedal carnivores, with limited tool-making capacities but keen abstract minds, and one of herbivorous bipeds, industrious and practical. On most of #planetname#, the formers still prey on the latter and dominate their shared civilization; in other areas relations are more equal. Their most striking productions are complex sculptures designed by artists of the hunter specie but sculpted by the bipeds. Art resulting from the efforts of two different non-spatial species is extremely rare and hence valuable to collectors."
		return desc
	end,
	specialities={}
}
natives_generator.ordered[#natives_generator.ordered+1]=all.symbionts

all.hives={
	weight=2,
	label="Hive-minds",
	applyOnPlanet=function(planet)
		local natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({10000000,100000000}),
			planet:areNativeCivilized())
		planet.lua.natives=natives
		if (not natives.civilized) then
			natives_generator.setNativeDemands(planet,0.2,1,0.1,1,0.5)
		else
			natives_generator.generateNativeCivilizedData(planet,1,0.5,0.5,0.5,0.5)
		end

		natives:addTag("rare")

		planet.lua.natives:addGoodSupply(C.NATIVE_TECHNOLOGY,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		local desc="Collectivist intelligent species like the "..planet.lua.natives.name.." are rare; while some achieve impressive degrees of tool usage they rarely reach true sapience. The mound dwellers of #planetname# are an exception; individually, their intelligence is comparable to that of apes, while a full colony is of above-human intelligence in many areas. The mechanisms they develop to keep air flowing within their vast underground cities and water out of them are remarkable, with performances space-faring races could not duplicate without large-scale electrical power."
		return desc
	end,
	specialities={}
}
natives_generator.ordered[#natives_generator.ordered+1]=all.hives

all.lavacrabs={
	weight=2,
	label="Ceramic Crabs",
	applyOnPlanet=function(planet)
		local natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({1000000,10000000}),
			planet:areNativeCivilized())
		planet.lua.natives=natives
		if (not natives.civilized) then
			natives_generator.setNativeDemands(planet,0.2,1,0.1,1,0.5)
		else
			natives_generator.generateNativeCivilizedData(planet,1,0.5,0.5,0.5,0.5)
		end

		natives:addTag("rare")

		planet.lua.natives:addGoodSupply(C.NATIVE_TECHNOLOGY,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		local desc="Life on #moonname# gets ever more luxuriant the closer to the volcanic spots, where the rare and primitive lifeforms of the cold deserts make room for more dynamic species. The "..planet.lua.natives.name.." are the pinnacle of that; fearsome-looking crab-like creature, they protect themselves from the heat with tough ceramic shields. Their metallurgical and material skills are exceptional for a pre-industrial species."
		return desc
	end,
	specialities={}
}
natives_generator.ordered[#natives_generator.ordered+1]=all.lavacrabs

--copying the keys to an id value for future reference
for k,v in pairs(all) do
  v.id=k
end

