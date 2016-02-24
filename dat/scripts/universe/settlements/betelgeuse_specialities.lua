
if (not betelgeuse_specialities) then
	betelgeuse_specialities={}  --shared public interface
end

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


betelgeuse_specialities.specialityUniversity={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.betelgeuse.technology>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse:addTag("hightechcenter")
		planet.lua.settlements.betelgeuse.technology=planet.lua.settlements.betelgeuse.technology+0.5
		planet.lua.settlements.betelgeuse:addGoodSupply(MODERN_INDUSTRIAL,30,1)
	end,
	getDesc=function(planet)
		return "While the Oligarchy is not known for its scientific research, it has attempted to copy human-style universities. #planetname# is home to one such installation, originally setup with Terran help and now the nexus of a small advanced industrial goods industry. "
	end
}

betelgeuse_specialities.specialityNavalBase={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.betelgeuse.military>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse:addTag("navalbase")
		planet.lua.settlements.betelgeuse.military=planet.lua.settlements.betelgeuse.military+0.5
		planet.lua.settlements.betelgeuse:addGoodDemand(ARMAMENT,20,1.2)
    planet.lua.settlements.betelgeuse:addGoodDemand(MODERN_ARMAMENT,10,1.5)
	end,
	getDesc=function(planet)
		return "#planetname# is home to one of the most public-minded of the Patrician families, who ensure that the local base of the Betelgian navy is unusually well-supplied, and its officers particularily loyal to Betelgeuse... and their local patrons. "
	end
}

betelgeuse_specialities.specialityHeavyIndustry={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.betelgeuse.industry>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse:addTag("industrialcenter")
		planet.lua.settlements.betelgeuse.industry=planet.lua.settlements.betelgeuse.industry+0.5
		planet.lua.settlements.betelgeuse:addGoodSupply(INDUSTRIAL,10,0.8)
    planet.lua.settlements.betelgeuse:addGoodSupply(CONSUMER_GOODS,10,0.8)
	end,
	getDesc=function(planet)
		return "While Betelgeuse is famous for its trading fleets, it does have industrial centres. On #planetname#, large factory complexes produce basic industrial and consumer goods for export to the rest of the Oligarchy. "
	end
}

betelgeuse_specialities.specialityLuxuryResort={
	weight=3,
	weightValidity=function(planet)
		return (planet.lua.humanFertility>0.9)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse:addTag("greatpalace")
		planet.lua.settlements.betelgeuse.services=planet.lua.settlements.betelgeuse.services+0.5
		planet.lua.settlements.betelgeuse:addGoodDemand(LUXURY_GOODS,30,2)
		planet.lua.settlements.betelgeuse:addGoodDemand(EXOTIC_FURS,10,2)
	end,
	getDesc=function(planet)
		return "In one of the lushest vales of #planetname#, a great palace has been built by one of Betelgeuse' leading family. Its eleguant arches surrounded by acres of manicured gardens are famous throughout the Oligarchy, and its constant celebrations drive a strong interest in luxury goods. "
	end
}


betelgeuse_specialities.specialityOre={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.minerals>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse:addTag("richores")
		planet.lua.settlements.betelgeuse:addGoodSupply(ORE,50,0.9)
		planet.lua.settlements.betelgeuse.industry=planet.lua.settlements.betelgeuse.industry*1.5
	end,
	getDesc=function(planet)
		return "The mountains of #planetname# hide unusually important mineral resources, extracted by subject races for the great benefit of one of the leading Patrician family. "
	end
}