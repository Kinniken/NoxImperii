--To be included ONLY via generate_natives


--Const copy-pasted for auto-completion. Not best design but avoids mistakes
EXOTIC_FOOD="Exotic Food"
FOOD="Food"
GOURMET_FOOD="Gourmet Food"

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
MEDICINE="Medicine"

NATIVE_WEAPONS="Native Weapons"
BASIC_WEAPONS="Non-Industrial Weapons"
PRIMITIVE_ARMAMENT="Primitive Armament"
ARMAMENT="Armament"
MODERN_ARMAMENT="Modern Armament"

NATIVE_TECHNOLOGY="Native Technology"

local all = {}

natives_generator.rare_natives=all

all.symbionts={
	weight=2,
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

		planet.lua.natives:addGoodSupply(NATIVE_SCULPTURES,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		local desc="The "..planet.lua.natives.name.." civilization is the product of a rare symbiosis of two sapient species of comparable intelligence: one of quadrupedal carnivores, with limited tool-making capacities but keen abstract minds, and one of herbivorous bipeds, industrious and practical. On most of #planetname#, the formers still prey on the latter and dominate their shared civilization; in other areas relations are more equal. Their most striking productions are complex sculptures designed by artists of the hunter specie but sculpted by the bipeds. Art resulting from the efforts of two different non-spatial species is extremely rare and hence valuable to collectors."
		return desc
	end,
	specialities={}
}

all.hives={
	weight=2,
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

		planet.lua.natives:addGoodSupply(NATIVE_TECHNOLOGY,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		local desc="Collectivist intelligent species like the "..planet.lua.natives.name.." are rare; while some achieve impressive degrees of tool usage they rarely reach true sapience. The mound dwellers of #planetname# are an exception; individually, their intelligence is comparable to that of apes, while a full colony is of above-human intelligence in many areas. The mechanisms they develop to keep air flowing within their vast underground cities and water out of them are remarkable, with performances space-faring races could not duplicate without large-scale electrical power."
		return desc
	end,
	specialities={}
}

--copying the keys to an id value for future reference
for k,v in pairs(all) do
  v.id=k
end

