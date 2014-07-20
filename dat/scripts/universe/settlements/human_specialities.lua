if (not settlements_specialities) then
	settlements_specialities={}  --shared public interface
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

settlements_specialities.specialityUniversity={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.humans.technology>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("university")
		planet.lua.settlements.humans.technology=planet.lua.settlements.humans.technology+0.5
		planet.lua.settlements.humans:addGoodDemand(NATIVE_TECHNOLOGY,10,3)
		planet.lua.settlements.humans:addGoodDemand(NATIVE_ARTWORK,10,2)
	end,
	getDesc=function(planet)
		return "The planet is famous for its university, founded early in the colony's history and today a major center of learning for surrounding systems. "
	end
}

settlements_specialities.specialityNavalBase={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.humans.military>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("navalbase")
		planet.lua.settlements.humans.military=planet.lua.settlements.humans.military+0.5
		planet.lua.settlements.humans:addGoodDemand(NATIVE_WEAPONS,10,2)
	end,
	getDesc=function(planet)
		return "The #planetname# naval base is a major command center for this area of space, and a large community of retired soldiers and officers has settled around it. "
	end
}

settlements_specialities.specialityHeavyIndustry={
	weight=10,
	weightValidity=function(planet)		
		return (planet.lua.settlements.humans.industry>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("shipyards")
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry+0.5
		planet.lua.settlements.humans:addGoodDemand(EXOTIC_ORGANIC,10,2)
	end,
	getDesc=function(planet)
		return "#planetname# is now a major industrial world, famous for its massive shipyards. "
	end
}

settlements_specialities.specialityLuxuryResort={
	weight=5,
	weightValidity=function(planet)
		return (planet.lua.humanFertility>0.9)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("resorts")
		planet.lua.settlements.humans.services=planet.lua.settlements.humans.services+0.5
		planet.lua.settlements.humans:addGoodDemand(LUXURY_GOODS,50,2)
		planet.lua.settlements.humans:addGoodDemand(EXOTIC_FURS,10,3)
		planet.lua.settlements.humans:addGoodDemand(EXOTIC_FOOD,10,2)
	end,
	getDesc=function(planet)
		return "The leisure resorts of #planetname# are popular with the Empire's nobility. "
	end
}

settlements_specialities.specialityCraftBeer={
	weight=5,
	weightValidity=function(planet)
		return (planet.lua.settlements.humans.agriculture>1)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("craftbeers")
		planet.lua.settlements.humans:addGoodSupply(GOURMET_FOOD,50,1)
	end,
	getDesc=function(planet)
		return "#planetname#'s craft beers are legendary for the religious care with which they are brewed by numerous small producers. "
	end
}

settlements_specialities.specialityHam={
	weight=5,
	weightValidity=function(planet)
		return (planet.lua.settlements.humans.agriculture>1)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("curatedham")
		planet.lua.settlements.humans:addGoodSupply(GOURMET_FOOD,50,1)
	end,
	getDesc=function(planet)
		return "Porks brought from Earth thrive on #planetname#, and local plants give their meat a distinctive flavor. #planetname# curated hams are legendary among the empire's gourmets. "
	end
}


settlements_specialities.specialityWeaponLab={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.humans.industry>0.7 and planet.lua.settlements.humans.technology>0.8)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("weaponlab")
		planet.lua.settlements.humans:addGoodSupply(MODERN_ARMAMENT,50,1)
	end,
	getDesc=function(planet)
		return "The world is home to a major high-tech armament manufacturer whose products are renowned for their reliability. "
	end
}



settlements_specialities.specialityFrontierBase={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("frontierbase")
		planet.lua.settlements.humans:addGoodDemand(ARMAMENT,50,2)
		planet.lua.settlements.humans.military=planet.lua.settlements.humans.military*1.5
	end,
	getDesc=function(planet)
		return "The Imperial Navy has setup a significant naval base on #planetname# to protect the sector from barbarian raids. "
	end
}


settlements_specialities.specialityFrontierIndustry={
	weight=10,
	weightValidity=function(planet)
		planet.lua.settlements.humans:addTag("strategicindustries")
		return (planet.lua.settlements.humans.industry>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addGoodDemand(ORE,50,2)
		planet.lua.settlements.humans:addGoodSupply(INDUSTRIAL,50,1)
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*1.5
	end,
	getDesc=function(planet)
		return "#planetname#'s industries are developed for a frontier world, making it a strategic asset for the Empire. "
	end
}


settlements_specialities.specialityFrontierNightLife={
	weight=5,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("partytown")
		planet.lua.settlements.humans:addGoodDemand(LUXURY_GOODS,30,3)
		planet.lua.settlements.humans:addGoodDemand(EXOTIC_FOOD,30,3)
		planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*1.5
	end,
	getDesc=function(planet)
		return "Despite the ever-present fear of barbarian raids, #planetname#'s capital is known for its active night life throughout the sector. Party-goers feel more alive with the thrill of danger. "
	end
}


settlements_specialities.specialityFrontierOre={
	weight=10,
	weightValidity=function(planet)
		planet.lua.settlements.humans:addTag("richores")
		return (planet.lua.minerals>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addGoodSupply(ORE,50,1)
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*1.5
	end,
	getDesc=function(planet)
		return "The world's rich sources of ore are a major industrial asset, especially so far from the Inner Worlds. "
	end
}