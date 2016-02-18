include('universe/generate_nameGenerator.lua')
include('universe/generate_helper.lua')
include('universe/settlements/ardar_specialities.lua')


if (not settlement_generator) then
	settlement_generator={}  --shared public interface
end

settlement_generator.coreArdarSettlements={}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("oldcolony")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was one of the first system colonized by the Roidhunate beyond their home system. Its inhabitants are particularly proud of the fact, and tend to look down on Ardars from more recent colonies. "
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityNavalBase,ardar_specialities.specialityHeavyIndustry,ardar_specialities.specialityLuxuryResort,ardar_specialities.specialityGourmetFood,ardar_specialities.specialityWeaponLab},
	weight=10
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("oldcolony")
	end,
	weightValidity=function(planet)
		if (not planet.lua.settlements.ardars) then
			return false
		end
		if (not planet.natives) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was colonized in the first major expension of the Roidhunate. The Ardars were ruthless in pushing the natives away from the land they coveted, though relations have since improved. "
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityNavalBase,ardar_specialities.specialityHeavyIndustry,ardar_specialities.specialityLuxuryResort,ardar_specialities.specialityGourmetFood,ardar_specialities.specialityWeaponLab},
	weight=10
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("oldcolony")
	end,
	weightValidity=function(planet)
		if (not planet.lua.settlements.ardars) then
			return false
		end
		if (planet.natives) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return gh.randomObject({"Empty of all sentient life, #planetname# was quickly settled by the land-hungry Roidhunate. ","#planetname# was a prime choice for expension due to its fertility and absence of natives. "})
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityNavalBase,ardar_specialities.specialityHeavyIndustry,ardar_specialities.specialityLuxuryResort,ardar_specialities.specialityGourmetFood,ardar_specialities.specialityWeaponLab},
	weight=10
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("oldcolony")
	end,
	weightValidity=function(planet)
		if (not planet.lua.settlements.ardars) then
			return false
		end
		if (planet.humanFertility < 1) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return gh.randomObject({"#planetname#'s fertile plains attracted rural ardars who felt increasingly out of place in the growing megalopolises of Ardarshir. A century from now, their descendants might have to do the same. ","One of the oldest ardar noble family founded the settlement on #planetname#, seeking to exploit its agricultural riches. ","Particularly positive analysis by Roidhunate scouts decided an early colonization of #planetnale#. "})
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityLuxuryResort,ardar_specialities.specialityGourmetFood},
	weight=10
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("oldcolony")
	end,
	weightValidity=function(planet)
		if (not planet.lua.settlements.ardars) then
			return false
		end
		if (planet.minerals < 1) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return gh.randomObject({"Ardar settlers on #planetname# were attracted by its riche ore veins, with their promises of rapid industrial expension. ","The ardar navy prioritized #planetname# for settlement due to its rich mineral wealth, making it an interesting addition to the Roidhunate's military capacities. "})
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityNavalBase,ardar_specialities.specialityHeavyIndustry,ardar_specialities.specialityWeaponLab},
	weight=10
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("navyplanet")
		planet.lua.settlements.ardars.military=planet.lua.settlements.ardars.military+0.5
		planet.lua.settlements.ardars:addGoodDemand(NATIVE_WEAPONS,20,3)
		planet.lua.settlements.ardars:addGoodSupply(MODERN_ARMAMENT,30,1)
		planet.lua.settlements.ardars:addGoodDemand(ARMAMENT,50,1)
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The Ardar Navy has a much greater role in the Roidhunante's settlement program than that of the Imperial Navy. Entire worlds like #planetname# have been settled and are still run by the Navy, with civilian government existing only at the local level. Almost everyone on the planet works for the Navy itself or for a defense company. "
	end,
	specialities={},
	weight=5
}

