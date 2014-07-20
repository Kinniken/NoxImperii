include('universe/generate_helper.lua')
include('universe/objects/class_natives.lua')

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


natives_generator = {} --public interface

local function generateNativeCivilizedData(planet,industryFactor,agricultureFactor,serviceFactor,technologyFactor,militaryFactor)
	local baseFactor=planet.star.populationTemplate.nativeFactors
	planet.lua.natives.industry=(planet.lua.nativeFertility*0.2+planet.lua.minerals*0.5+0.3)*industryFactor*baseFactor.industry
	planet.lua.natives.agriculture=(planet.lua.nativeFertility*0.8+0.2)*agricultureFactor*baseFactor.agriculture
	planet.lua.natives.technology=technologyFactor*baseFactor.technology
	planet.lua.natives.services=(planet.lua.natives.industry+planet.lua.natives.agriculture+math.log10(planet.lua.natives.population)/10)*(1+planet.lua.natives.technology)/3*serviceFactor*baseFactor.services
	planet.lua.natives.military=militaryFactor*(3+planet.lua.natives.industry+planet.lua.natives.agriculture+planet.lua.natives.services)/5*baseFactor.military
	planet.lua.natives.stability=baseFactor.stability

	planet.lua.natives:randomizeSettlementData(0.2)

	planet.faction=planet.star.populationTemplate.nativeFaction
	planet.factionPresence=1
	planet.factionRange=1
end

local function setNativeDemands(planet,basicWeapons,basicTools,primitiveWeapons,primitiveIndustrial,primativeConsumption)
	planet.lua.natives.goodsDemand={}
	if (basicWeapons>0) then
		planet.lua.natives:addGoodDemand(BASIC_WEAPONS,basicWeapons,1)
	end
	if (basicTools>0) then
		planet.lua.natives:addGoodDemand(BASIC_TOOLS,basicTools,1)
	end
	if (primitiveWeapons>0) then
		planet.lua.natives:addGoodDemand(PRIMITIVE_ARMAMENT,primitiveWeapons,1)
	end
	if (primitiveIndustrial>0) then
		planet.lua.natives:addGoodDemand(PRIMITIVE_INDUSTRIAL,primitiveIndustrial,1)
	end
	if (primativeConsumption>0) then
		planet.lua.natives:addGoodDemand(PRIMITIVE_CONSUMER,primativeConsumption,1)
	end
end

local function genericSpecieName()
	nameStart={"mer","bry","roi","brech","y","da","mo","khrai","qan","ur","tach","tel","chydh","gel","fo","mor"}
	nameMiddle={"thio","dhu","na","dwy","thol","rio","ry","dio","ru"}
	nameEnd={"thioch","te","dan","dwyr","tholch","rioch","khraich","ryf","diolch","wyr","loch","dhwan","gelch","daich","chan"}

	if (math.random()>0.5) then
		name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]
	else
		name=nameStart[ math.random(#nameStart)]..nameEnd[ math.random(#nameEnd)]
	end

	name=name:gsub("^%l", string.upper)
	return name
end

local leonids={
	weight=10,
	applyOnPlanet=function(planet)
		local natives=natives_class.createNew(genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({1000000,10000000}),
			planet:areNativeCivilized())
		planet.lua.natives=natives
		if (not natives.civilized) then			
			setNativeDemands(planet,1,1,0.5,0,0.5)
		else
			generateNativeCivilizedData(planet,0.3,1,0.8,0.5,1)
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

leonids.specialities[#leonids.specialities+1]={
	weight=10,
	weightValidity=function(planet)
		return not planet:areNativeCivilized()
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(NATIVE_ARTWORK,gh.populationScore(planet.lua.natives.population)*(planet:isCivilized() and 10 or 20),
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "Their hunting scenes painted inside dried-out animal skins "..(planet:isCivilized() and "are particularly prized by humans and Merseians. " or "would likely have success in many civilized worlds. ")
	end
}
leonids.specialities[#leonids.specialities+1]={
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
leonids.specialities[#leonids.specialities+1]={
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

local otters={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({10000000,100000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			setNativeDemands(planet,0.5,1,0.5,0.5,1)
		else
			generateNativeCivilizedData(planet,0.7,0.5,1,1,0.5)
		end
	end,
	getDesc=function(planet)
		local desc= "In the estuaries and marches of #planetname#, an amphibian race of mammals has reached sapience. "..
		" While the range of the "..planet.lua.natives.name.." is limited to areas where water is widely available, they have developed a promising civilization of autonomous cities connected by long-distance sea trade routes. "..(planet:areNativeCivilized() and " Their integration into space-faring civilization has been smooth, and they have been keen to assimilate modern technologies. " or "")
		return desc
	end,
	specialities={}
}
otters.specialities[#otters.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_ORGANIC,gh.populationScore(planet.lua.natives.population)*20,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "They cultivate a large variety of alga, from which exotic organic components can be extracted for industrial use. "
	end
}
otters.specialities[#otters.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(EXOTIC_FOOD,gh.populationScore(planet.lua.natives.population)*20,
			(planet:isCivilized() and 1 or 0.5))
	end,
	getDesc=function(planet)
		return "They produce a pungent alcohol from fermented alga that can jolt the most jaded Imperial palate. "
	end
}

local bovines={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({50000000,500000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			setNativeDemands(planet,0.5,1,0,1,1)
		else
			generateNativeCivilizedData(planet,0.6,1.2,0.5,0.7,0.3)
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
bovines.specialities[#bovines.specialities+1]={
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
bovines.specialities[#bovines.specialities+1]={
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

local avians={
	weight=10,
	weightValidity=function(planet)
		return (planet.planetRadius>1.1)
	end,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({5000000,50000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			setNativeDemands(planet,0,0,0.5,1,1.5)
		else
			generateNativeCivilizedData(planet,1,0.8,0.8,1.1,0.5)
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
avians.specialities[#avians.specialities+1]={
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
avians.specialities[#avians.specialities+1]={
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

local simians={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({5000000,50000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			setNativeDemands(planet,1,0.5,0.5,0.5,0.2)
		else
			generateNativeCivilizedData(planet,0.8,0.8,0.4,0.5,1.2)
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
simians.specialities[#simians.specialities+1]={
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
simians.specialities[#simians.specialities+1]={
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

local carnivorousHumanoids={
	weight=100000,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({5000000,50000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			setNativeDemands(planet,0.5,0.5,0,1,0.5)
		else
			generateNativeCivilizedData(planet,0.7,1,0.6,0.5,0.8)
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
carnivorousHumanoids.specialities[#carnivorousHumanoids.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(FOOD,gh.populationScore(planet.lua.natives.population)*20,
			(planet:isCivilized() and 0.5 or 0.3))
	end,
	getDesc=function(planet)
		return "The meat of their birds is comestible for humans; it tastes like chicken. "
	end
}
carnivorousHumanoids.specialities[#carnivorousHumanoids.specialities+1]={
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

local hibernatingReptiles={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives=natives_class.createNew(genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({100000,5000000}),false)

		if (not planet.lua.natives.civilized) then
			setNativeDemands(planet,0.5,1,0,0,0)
		else
			generateNativeCivilizedData(planet,0.1,0.5,0.5,0.3,0.2)
		end
	end,
	getDesc=function(planet)
		local desc= "Life on #planetname# is tough, and the "..planet.lua.natives.name.." always seem one tougher winter away from extinction. And yet those large hibernating, cold-blooded sophonts survive even if they do not prosper, using the short summer season to fish enough to resist the next winter. "..(planet:isCivilized() and "Without cooperation with the settlers, they will surely fail to progress. " or "They have shown little interest in visitors beyond limited trading, and prefer to stay away from the settlers. ")
		return desc
	end,
	specialities={}
}
hibernatingReptiles.specialities[#hibernatingReptiles.specialities+1]={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.natives:addGoodSupply(FOOD,gh.populationScore(planet.lua.natives.population)*10,
			(planet:isCivilized() and 0.5 or 0.3))
	end,
	getDesc=function(planet)
		return "They are willing to trade what little surplus fish they produce, as it is comestible by most species. "
	end
}
hibernatingReptiles.specialities[#hibernatingReptiles.specialities+1]={
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

local beavers={
	weight=10,
	applyOnPlanet=function(planet)

		planet.lua.natives=natives_class.createNew(genericSpecieName(),planet.lua.nativeFertility*gh.randomInRange({1000000,5000000}),planet:areNativeCivilized())

		if (not planet.lua.natives.civilized) then
			setNativeDemands(planet,0.5,1,0,0,0.5)
		else
			generateNativeCivilizedData(planet,0.7,0.8,0.8,0.6,0.4)
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
beavers.specialities[#beavers.specialities+1]={
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
beavers.specialities[#beavers.specialities+1]={
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

natives_generator.noNatives={}

natives_generator.warmTerranNatives={leonids,otters,avians,simians}
natives_generator.temperateTerranNatives={leonids,otters,bovines,avians,simians,carnivorousHumanoids}
natives_generator.coldTerranNatives={hibernatingReptiles,beavers}