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
HUMAN_MEDICINE="Human Medicine"

NATIVE_WEAPONS="Native Weapons"
BASIC_WEAPONS="Non-Industrial Weapons"
PRIMITIVE_ARMAMENT="Primitive Armament"
ARMAMENT="Armament"
MODERN_ARMAMENT="Modern Armament"

NATIVE_TECHNOLOGY="Native Technology"

local all = {}

natives_generator.common_natives=all

all.leonids={
	weight=10,
	applyOnPlanet=function(planet)
		local natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({1000000,10000000}),
			planet:areNativeCivilized())
		planet.lua.natives=natives
		if (not natives.civilized) then			
			natives_generator.setNativeDemands(planet,1,1,0.5,0,0.5)
		else
			natives_generator.generateNativeCivilizedData(planet,0.3,1,0.8,0.5,1)
		end
	end,
	getDesc=function(planet)
		local desc= "The planet is home to an intelligent race, the "..planet.lua.natives.name..". Tall, sleek humanoids, they are descendants of large carnivorous predators. Their lives are centered on small tribes, which are often very territorial "..
			", though there are exceptions in some cultures. They never developed metallurgy "

			desc=desc..(planet:areNativeCivilized() and " and before contact survived essentially on hunting and grazing, though they have now mostly sedentarized. " or "and survive essentially on hunting and grazing, but they are skilled artists. ")
		return desc
	end,
	specialities={}
}

all.leonids.specialities[#all.leonids.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return not planet:areNativeCivilized()
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_ARTWORK,gh.populationScore(planet.lua.natives.population)*(planet:isCivilized() and 10 or 20),
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "Their hunting scenes painted inside dried-out animal skins "..(planet:isCivilized() and "are particularly prized by humans and Ardars. " or "would likely have success in many civilized worlds. ")
	end
}
all.leonids.specialities[#all.leonids.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return not planet:areNativeCivilized()
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_FOOD,gh.populationScore(planet.lua.natives.population)*20,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "The meat of their prize cattle animal, a graceful mammal covered in multicolored feathers, is a delicacy for human palates. "
	end
}
all.leonids.specialities[#all.leonids.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return planet:areNativeCivilized()
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(FOOD,gh.populationScore(planet.lua.natives.population)*50,1)
	end,
	getDesc=function(planet)
		return "Contact with civilization has let them to focus on commercial ranching. "
	end
}

all.otters={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({10000000,100000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0.5,1,0.5,0.5,1)
		else
			natives_generator.generateNativeCivilizedData(planet,0.7,0.5,1,1,0.5)
		end
	end,
	getDesc=function(planet)
		local desc= "In the estuaries and marches of #planetname#, an amphibian race of mammals has reached sapience. "..
		" While the range of the "..planet.lua.natives.name.." is limited to areas where water is widely available, they have developed a promising civilization of autonomous cities connected by long-distance sea trade routes. "..(planet:areNativeCivilized() and " Their integration into space-faring civilization has been smooth, and they have been keen to assimilate modern technologies. " or "")
		return desc
	end,
	specialities={}
}
all.otters.specialities[#all.otters.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_ORGANIC,gh.populationScore(planet.lua.natives.population)*20,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "They cultivate a large variety of alga, from which exotic organic components can be extracted for industrial use. "
	end
}
all.otters.specialities[#all.otters.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_FOOD,gh.populationScore(planet.lua.natives.population)*20,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "They produce a pungent alcohol from fermented alga that can jolt the most jaded Imperial palate. "
	end
}

all.bovines={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({50000000,500000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0.5,1,0,1,1)
		else
			natives_generator.generateNativeCivilizedData(planet,0.6,1.2,0.5,0.7,0.3)
		end
	end,
	getDesc=function(planet)
		local desc= "Ranging in the plains of #planetname#, the "..planet.lua.natives.name.." are a rarity: a purely vegetarian specie that reached sapience. While they are primarily quadrupeds, they have grasping hands and can stand to manipulate tools. The presence on #planetname# of aggressive, quasi-sapient predators likely explains the development of intelligence among herd mammals. "
		if (planet.lua.natives.civilized) then
			desc=desc.."While originally nomads, contact with the settlers has led several of their herds to settle in large camps and take up agriculture instead of their traditional ranging. "
		else
			desc=desc.."The "..planet.lua.natives.name.." are nomads, moving from pasture to pasture according to the seasons. "
		end
		return desc
	end,
	specialities={}
}
all.bovines.specialities[#all.bovines.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_SCULPTURES,gh.populationScore(planet.lua.natives.population)*10,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "Wood is rare and cherished in the plains they roam, and they carve elaborate sculptures out of it "..(planet:isCivilized() and "that have had some success among connoisseurs on civilized worlds. " or " that should be appreciated by collectors on more civilized worlds. ")
	end
}
all.bovines.specialities[#all.bovines.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives.specialGoods[#planet.lua.natives.specialGoods+1]={type=FOOD,production=gh.populationScore(planet.lua.natives.population)*100,buyingPrice=0.5}
		planet.lua.natives:addGoodSupply(FOOD,gh.populationScore(planet.lua.natives.population)*100,
			0.5)
	end,
	weightValidity=function(planet)
		return (not (planet.lua.settlements.humans==nil))
	end,
	getDesc=function(planet)
		return "They now produce large amount of cereals compatible with human physiology. "
	end
}

all.avians={
	weight=10,
	weightValidity=function(planet)
		return (planet.planetRadius>1.1)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({5000000,50000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0,0,0.5,1,1.5)
		else
			natives_generator.generateNativeCivilizedData(planet,1,0.8,0.8,1.1,0.5)
		end
	end,
	getDesc=function(planet)
		local desc= "Flying sophonts are rare in the galaxy: only peculiar conditions will allow an animal with a brain large enough to reach sapience to fly. "..planet.lua.natives.name.." are such an exception. #planetname#'s large size preserves a thick atmosphere, where those descendants of gliding predators can lift themselves for short durations. Forest-dwellers, they have developed an indigenous pre-industrial civilization. "
		if (planet.lua.natives.civilized) then
			desc=desc.."Integration into space-faring civilization has been smooth - though they look down on non-winged species, more advanced than them or not. "
		elseif (planet:isCivilized()) then
			desc=desc.."Ambitious young "..planet.lua.natives.name.." now often try to get hired as crew by passing ships. "
		else
			desc=desc.."They seem likely to eventually reach space travel on their own. "
		end
		return desc
	end,
	specialities={}
}
all.avians.specialities[#all.avians.specialities+1]={
	weight=5,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_TECHNOLOGY,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "While their technology is far below that of space-faring races, they do produce intricate mechanical computers, chiefly to calculate star movements. Of course, modern navigation computers can produce the same results in a fraction of the cost, but they do not have the same retro cachet. "
	end
}
all.avians.specialities[#all.avians.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_FURS,gh.populationScore(planet.lua.natives.population)*10,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "Their forests are rich in local quasi-mammals with impressively-colored furs which the "..planet.lua.natives.name.." keep in semi-liberty for their meat and their hides. "
	end
}

all.simians={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({5000000,50000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,1,0.5,0.5,0.5,0.2)
		else
			natives_generator.generateNativeCivilizedData(planet,0.8,0.8,0.4,0.5,1.2)
		end
	end,
	getDesc=function(planet)
		local desc= "Small humanoids like the "..planet.lua.natives.name.." are common in the galaxy. Tree-dwellers longer in their evolutionary history than men, they are still not consistent bipeds. Despite an aggressive nature and frequent small-scale wars between tribes, they have developed metallurgy and a productive agriculture centered on local fruit-bearing plants. "
		if (planet.lua.natives.civilized) then
			desc=desc.."Their integration in modern society has been difficult, and conflict between them and the settlers are still frequent.  "
		elseif (planet:isCivilized()) then
			desc=desc.."They mostly ignore the settlers, preferring to retreat in more remote areas. "
		end
		return desc
	end,
	specialities={}
}
all.simians.specialities[#all.simians.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_FOOD,gh.populationScore(planet.lua.natives.population)*20,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return (planet:isCivilized() and "Some of their tribes will however agree to trade their fruits in exchange for industrial weapons. " or "Their fruits look like they would please gourmets on many worlds. ")
	end
}
all.simians.specialities[#all.simians.specialities+1]={
	weight=5,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_WEAPONS,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "Their elaborately-carved bronze and iron weapons, including throwing spears and superbly-crafted bows, are particularly beautiful examples of primitive craftsmanship. "
	end
}

all.carnivorousHumanoids={
	weight=100000,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({5000000,50000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0.5,0.5,0,1,0.5)
		else
			natives_generator.generateNativeCivilizedData(planet,0.7,1,0.6,0.5,0.8)
		end
	end,
	getDesc=function(planet)
		local desc= "From a distance, the "..planet.lua.natives.name.." could pass for humans. Heavily-built humanoids, they are also mammals, bipeds and plain-dwellers. They are however almost exclusively carnivorous and their modern civilization is built around large-scale ranching of large flightless birds. "
		if (not planet.lua.natives.civilized) then
			desc=desc.."The difficulty in preserving and transporting fresh meat has prevented them from developing real cities, and their technology has stagnated at a bronze-age level. "
			if (planet:isCivilized()) then
				desc=desc.."The settlers have found them to be a willing workforce for various semi-skilled tasks, in exchange for modern devices. "
			end
		else
			desc=desc.."Before contacts with galactic civilization, difficulties in preserving and transporting fresh meat has prevented them from developing real cities, and their technology had stagnated at a bronze-age level. Since then, they have started concentrating in larger settlements, but culture resistance has slowed the movement."
		end
		return desc
	end,
	specialities={}
}
all.carnivorousHumanoids.specialities[#all.carnivorousHumanoids.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(FOOD,gh.populationScore(planet.lua.natives.population)*20,
			(planet:isCivilized() and 0.5 or 0.3))
	end,
	getDesc=function(planet)
		return "The meat of their birds is comestible for humans; it tastes like chicken. "
	end
}
all.carnivorousHumanoids.specialities[#all.carnivorousHumanoids.specialities+1]={
	weight=5,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_FURS,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "While their birds are foul-tasting for humans and most other races, their feathers are highly decorative. The "..planet.lua.natives.name.." hangs entire hides on their walls, to superb effect. "
	end
}

all.hibernatingReptiles={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({100000,5000000}),false)

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0.5,1,0,0,0)
		else
			natives_generator.generateNativeCivilizedData(planet,0.1,0.5,0.5,0.3,0.2)
		end
	end,
	getDesc=function(planet)
		local desc= "Life on #planetname# is tough, and the "..planet.lua.natives.name.." always seem one tougher winter away from extinction. And yet those large hibernating, cold-blooded sophonts survive even if they do not prosper, using the short summer season to fish enough to resist the next winter. "..(planet:isCivilized() and "Without cooperation with the settlers, they will surely fail to progress. " or "They have shown little interest in visitors beyond limited trading, and prefer to stay away from the settlers. ")
		return desc
	end,
	specialities={}
}
all.hibernatingReptiles.specialities[#all.hibernatingReptiles.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(FOOD,gh.populationScore(planet.lua.natives.population)*10,
			(planet:isCivilized() and 0.5 or 0.3))
	end,
	getDesc=function(planet)
		return "They are willing to trade what little surplus fish they produce, as it is comestible by most species. "
	end
}
all.hibernatingReptiles.specialities[#all.hibernatingReptiles.specialities+1]={
	weight=5,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_SCULPTURES,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "While they have little resources to spare for artworks, they do produce striking sculptures made in the bones of large naval animals. The seemingly simple geometric patterns are more reminiscent of the latest computer-assisted, laser-carved Terran artworks than of typical native productions. "
	end
}

all.beavers={
	weight=10,
	applyOnPlanet=function(planet)

		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({1000000,5000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0.5,1,0,0,0.5)
		else
			natives_generator.generateNativeCivilizedData(planet,0.7,0.8,0.8,0.6,0.4)
		end
	end,
	getDesc=function(planet)
		local desc= "On the river banks of #planetname#, the "..planet.lua.natives.name.." have reached a surprising level of civilization. Their constructions of embankments and dams to control rivers predate their rise to sapience and enables them to protect the underwater chambers where they hibernate. Small, furry animals with exceptionally efficient fur, they are not true amphibians but can spend significant amount of time out of the water before returning to breath. "

		if (planet.lua.natives.civilized) then
			desc=desc.." While they had developed neither fire nor metallurgy prior to contact with off-world civilization, they have proven willing to assimilate modern technology, as far as their underwater lifestyle allows."
		else
			desc=desc.." In a difficult environment, they have developed a sophisticated civilization without ever developing fire or metallurgy."
		end

		return desc
	end,
	specialities={}
}
all.beavers.specialities[#all.beavers.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_FOOD,gh.populationScore(planet.lua.natives.population)*10,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "Most of the seafood they catch is poisonous to humans and associated species, but certain species of large crustaceans "..(planet:isCivilized() and " are considered delicacies off-world. " or " would be fit to grace the Emperor's table. ")
	end
}
all.beavers.specialities[#all.beavers.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_ORGANIC,gh.populationScore(planet.lua.natives.population)*5,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "Their main predator is a vicious marine reptile, whose venom however "..(planet:isCivilized() and "can be used as catalyst in some key chemical reactions. " or "has industrial potential as a catalyst. ")
	end
}

all.octopuses={
	weight=10,
	applyOnPlanet=function(planet)

		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({100000000,500000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0.5,1,0.2,0.5,0.5)
		else
			natives_generator.generateNativeCivilizedData(planet,0.5,1,0.8,0.8,0.4)
		end
	end,
	getDesc=function(planet)
		local desc= "The volcanic activity of #planetname# is particularly strong under the world's main oceans, creating many underwater hotspots. It is there that millennia ago a specie of octopus-like creatures learnt to use tools, first sharp flakes of volcanic rocks and later metal melted by the lava flows. Today the "..planet.lua.natives.name.." master the planet’s oceans, their sharp metal blades keeping predators at bay from the oceanic depths to the shore line. "
		
		return desc
	end,
	specialities={}
}
all.octopuses.specialities[#all.octopuses.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(FOOD,gh.populationScore(planet.lua.natives.population)*10,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "On most of #planetname#, their traditional hunting lifestyles has given way to large-scale fish herding, feeding a booming population. They are comestible for humans, and the "..planet.lua.natives.name.." can provide them cheaply."
	end
}
all.octopuses.specialities[#all.octopuses.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_WEAPONS,gh.populationScore(planet.lua.natives.population)*5,1)
	end,
	getDesc=function(planet)
		return "Their primitive metal weapons are unusually graceful, their underwater origins showing in their sweeping curves."
	end
}

all.burrowers={
	weight=10,
	applyOnPlanet=function(planet)

		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({1000000,5000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,1,1,0,0,0)
		else
			natives_generator.generateNativeCivilizedData(planet,1,0.5,0.8,0.6,0.5)
		end
	end,
	getDesc=function(planet)
		local desc= "The "..planet.lua.natives.name.." are descended from large rodent-like creatures that lived in groups of fifty to a hundred individuals in shared underground nests, away from #planetname#'s harsh winters. Even though they have developed sophisticated tool-making and extensive farming, they never developed permanent social entities larger than these groups. "
		
		return desc
	end,
	specialities={}
}
all.burrowers.specialities[#all.burrowers.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(FOOD,gh.populationScore(planet.lua.natives.population)*10,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "The core of their diet comes from a wide variety of roots of local plants, cultivated underground with the help of extensive irrigation and coal-based heating. They are bland to human taste, but safe."
	end
}
all.burrowers.specialities[#all.burrowers.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return true
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(ORE,gh.populationScore(planet.lua.natives.population)*10,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "The metallurgic activities of the "..planet.lua.natives.name.." are very extensive for a pre-industrial civilisation, and they mine ores in colossal quantities for a specie without true machines."
	end
}


all.crabs={
	weight=10,
	applyOnPlanet=function(planet)

		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({1000000,5000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0.5,1,0,1,1)
		else
			natives_generator.generateNativeCivilizedData(planet,0.3,1,0.3,1,1)
		end
	end,
	getDesc=function(planet)
		local desc= "The "..planet.lua.natives.name.." are fearsome looking creatures: crab-like beings two metres wide, they sport two pairs of pincers above their ten pairs of spider-like legs. The inner pincers can be used for precise manipulations; the outer ones could have pierced a knight's armour. Despite this, the "..planet.lua.natives.name.." are not particularly bellicose. They live in independent city-states with clearly-defined territories and generally resolve their conflicts through a sophisticated legal system. "
		
		return desc
	end,
	specialities={}
}
all.crabs.specialities[#all.crabs.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_WEAPONS,gh.populationScore(planet.lua.natives.population)*5,1)
	end,
	getDesc=function(planet)
		return "Their shells might be stronger than most tanks' armour, but they are still vulnerable to their terrible pincers. As a result they have developed massive armours, weighting upward of half a tonne, that would make for very impressive show pieces in the retro medieval castles of imperial aristocrats."
	end
}
all.crabs.specialities[#all.crabs.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_ARTWORK,gh.populationScore(planet.lua.natives.population)*5,0.5)
	end,
	getDesc=function(planet)
		return "With their double sets of pincers, the "..planet.lua.natives.name.." make wonderful sculptors. They carve massive but finely detailed mythological sculptures out of entire tree trunks, hacking the general shape with the outer pincers before finishing the details with the inner ones."
	end
}
all.crabs.specialities[#all.crabs.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodDemand(BASIC_WEAPONS,gh.populationScore(planet.lua.natives.population)*15,2)
	end,
	getDesc=function(planet)
		return "Since being dragged into the Galactic civilization, older "..planet.lua.natives.name..", liberated from reproductive duties, have found employment as shock ground troops."
	end
}


all.spiders={
	weight=10,
	applyOnPlanet=function(planet)

		planet.lua.natives=natives_class.createNew(natives_generator.genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({10000000,50000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			natives_generator.setNativeDemands(planet,0.2,1,0,1,2)
		else
			natives_generator.generateNativeCivilizedData(planet,0.5,1,0.8,1,0.5)
		end
	end,
	getDesc=function(planet)
		local desc= "The arachnid "..planet.lua.natives.name.." are fearsome looking eight-limbed carnivores, descended from cunning hunters similar to earth spiders - only a meter wide and much, much smarter. These creatures out of a nightmare have reached the early stages of metallic tool making; their civilization lacks cities due to their intensely solitary natures, and they do not have a human-like drive to expand. "
		
		return desc
	end,
	specialities={}
}
all.spiders.specialities[#all.spiders.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return (not planet.lua.natives.civilized)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_ARTWORK,gh.populationScore(planet.lua.natives.population)*5,0.5)
	end,
	getDesc=function(planet)
		return "Instead they focus on deep meditation, spending days attempting to reach an inner nirvana. The elaborate cocoons every adult "..planet.lua.natives.name.." must build to practise those rituals are things of beauty, airy nests shimmering in ever-changing colours."
	end
}
all.spiders.specialities[#all.spiders.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(GOURMET_FOOD,gh.populationScore(planet.lua.natives.population)*5,(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "Their diet of liquefied insects might seem repelling, but over centuries they have turned it into an art form. What terran aristocrat breed on a diet of live oysters could resist such a novelty as eating #planetname#’s shimmering insects alive - with a straw?"
	end
}

--copying the keys to an id value for future reference
for k,v in pairs(all) do
  v.id=k
end

