
if (not ardar_specialities) then
	ardar_specialities={}  --shared public interface
end


ardar_specialities.specialityUniversity={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.ardars.technology>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("hightechcenter")
		planet.lua.settlements.ardars.technology=planet.lua.settlements.ardars.technology+0.5
		planet.lua.settlements.ardars:addGoodDemand(C.NATIVE_TECHNOLOGY,10,3)
		planet.lua.settlements.ardars:addGoodSupply(C.MODERN_ARMAMENT,30,1)
		planet.lua.settlements.ardars:addGoodDemand(C.MODERN_INDUSTRIAL,30,1)
		planet.lua.settlements.ardars:addGoodDemand(C.ANCIENT_TECHNOLOGY,10,1.5)
	end,
	getDesc=function(planet)
		return "Ardars do not have universities in the human style, instead choosing to focus research in high technology production centres. #planetname# is an important one in armament and communication technology. "
	end
}

ardar_specialities.specialityNavalBase={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.ardars.military>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("navalbase")
		planet.lua.settlements.ardars.military=planet.lua.settlements.ardars.military+0.5
		planet.lua.settlements.ardars:addGoodDemand(C.NATIVE_WEAPONS,20,3)
	end,
	getDesc=function(planet)
		return "All Ardar worlds of any significance have a naval base, but the one on #planetname# is larger than most. From it the Roidhunate's fleet patrol the surrounding system, guarding the inner worlds. "
	end
}

ardar_specialities.specialityHeavyIndustry={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.ardars.industry>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("chemistrycenter")
		planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry+0.5
		planet.lua.settlements.ardars:addGoodDemand(C.EXOTIC_ORGANIC,10,2)
	end,
	getDesc=function(planet)
		return "#planetname# is a major Ardar industrial world, specialized in chemistry and ship-building. "
	end
}

ardar_specialities.specialityLuxuryResort={
	weight=3,
	weightValidity=function(planet)
		return (planet.lua.humanFertility>0.9)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("huntingreserve")
		planet.lua.settlements.ardars.services=planet.lua.settlements.ardars.services+0.5
		planet.lua.settlements.ardars:addGoodDemand(C.LUXURY_GOODS,30,2)
		planet.lua.settlements.ardars:addGoodDemand(C.EXOTIC_FURS,10,2)
		planet.lua.settlements.ardars:addGoodDemand(C.NATIVE_WEAPONS,10,2)
	end,
	getDesc=function(planet)
		return "Large tracks of #planetname# are kept as a hunting reserve for the Ardar nobility. "
	end
}

ardar_specialities.specialityGourmetFood={
	weight=5,
	weightValidity=function(planet)
		return (planet.lua.settlements.ardars.agriculture>1)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("gourmetfood")
		planet.lua.settlements.ardars:addGoodSupply(C.GOURMET_FOOD,30,1)
	end,
	getDesc=function(planet)
		return "While Ardar culture does not have quite the human tradition of fine food, parts of the Roidhunate elite has adopted the Imperial love of gourmet food. Entrepreneurs on #planetname# have seized the opportunity and now produce fancy versions of traditional Ardar food. "
	end
}


ardar_specialities.specialityWeaponLab={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.ardars.industry>0.7 and planet.lua.settlements.ardars.technology>0.8)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("hightechweapon")
		planet.lua.settlements.ardars:addGoodSupply(C.MODERN_ARMAMENT,50,1)
	end,
	getDesc=function(planet)
		return "The Roidhunate has setup a center for advanced weapon manufacture on the world. "
	end
}



ardar_specialities.specialityFrontierBase={
	weight=10,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("bordernavalbase")
		planet.lua.settlements.ardars:addGoodDemand(C.ARMAMENT,50,2)
		planet.lua.settlements.ardars.military=planet.lua.settlements.ardars.military*1.5
	end,
	getDesc=function(planet)
		return "The Roidhunate Navy has setup a significant naval base on #planetname# to protect the sector from barbarian raids. "
	end
}


ardar_specialities.specialityFrontierIndustry={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.settlements.ardars.industry>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("frontierindustry")
		planet.lua.settlements.ardars:addGoodDemand(C.ORE,50,2)
		planet.lua.settlements.ardars:addGoodSupply(C.INDUSTRIAL,50,1)
		planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry*1.5
	end,
	getDesc=function(planet)
		return "The Roidhunate has developed #planetname#'s industries, making it a strategic asset on the Ardar border. "
	end
}


ardar_specialities.specialityFrontierOre={
	weight=10,
	weightValidity=function(planet)
		return (planet.lua.minerals>0.7)
	end,
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("richores")
		planet.lua.settlements.ardars:addGoodSupply(C.ORE,50,1)
		planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry*1.5
	end,
	getDesc=function(planet)
		return "The rich ore deposits on the world are an important source of resources for the Ardar navy. "
	end
}