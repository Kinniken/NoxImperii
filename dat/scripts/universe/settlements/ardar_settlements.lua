include('universe/generate_nameGenerator.lua')
include('dat/scripts/general_helper.lua')
include('universe/settlements/ardar_specialities.lua')
include('universe/settlements/bar_desc.lua')


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
	weight=10,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("minority")
		planet.lua.settlements.ardars.minorityName=nameGenerator.generateNameArdarshir()
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return ("While humans tend to think of the Ardars as being of a single, monolithic race, there is in fact a similar level of  diversity within the Roidhunate, though the original culture and ethnicity of the early Roidhunate continues to dominates the realm far more than any equivalent in the Empire. #planetname# is an example of this continuing diversity: it was essentially settled by "..planet.lua.settlements.ardars.minorityName.." Ardars wanting to escape the discrimination they were victims of on Ardarshir. This largely failed; while they make-up the majority of the world's population, leadership positions are firmly in the hands of Roidhunate Ardars. ")
	end,
	specialities={
	ardar_specialities.specialityNavalBase,ardar_specialities.specialityHeavyIndustry,ardar_specialities.specialityLuxuryResort,ardar_specialities.specialityGourmetFood,ardar_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.ardar
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
		if (not planet.lua.natives) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was colonized in the first major expansion of the Roidhunate. The Ardars were ruthless in pushing the natives away from the land they coveted, though relations have since improved. "
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityNavalBase,ardar_specialities.specialityHeavyIndustry,ardar_specialities.specialityLuxuryResort,ardar_specialities.specialityGourmetFood,ardar_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.ardar
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
		if (planet.lua.natives) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return gh.randomObject({"Empty of all sentient life, #planetname# was quickly settled by the land-hungry Roidhunate. ","#planetname# was a prime choice for expansion due to its fertility and absence of natives. "})
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityNavalBase,ardar_specialities.specialityHeavyIndustry,ardar_specialities.specialityLuxuryResort,ardar_specialities.specialityGourmetFood,ardar_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("rural")
	end,
	weightValidity=function(planet)
		if (not planet.lua.settlements.ardars) then
			return false
		end
		if (planet.lua.humanFertility < 1) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return gh.randomObject({"#planetname#'s fertile plains attracted rural Ardars who felt increasingly out of place in the growing megalopolises of Ardarshir. A century from now, their descendants might have to do the same. ","One of the oldest Ardar noble family founded the settlement on #planetname#, seeking to exploit its agricultural riches. ","Particularly positive analysis by Roidhunate scouts decided an early colonization of #planetname#. "})
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityLuxuryResort,ardar_specialities.specialityGourmetFood},
	weight=10,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("orewealth")
	end,
	weightValidity=function(planet)
		if (not planet.lua.settlements.ardars) then
			return false
		end
		if (planet.lua.minerals < 1) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return gh.randomObject({"Ardar settlers on #planetname# were attracted by its rich ore veins, with their promises of rapid industrial expansion. ","The Ardar navy prioritized #planetname# for settlement due to its rich mineral wealth, making it an interesting addition to the Roidhunate's military capacities. "})
	end,
	specialities={ardar_specialities.specialityUniversity,ardar_specialities.specialityNavalBase,ardar_specialities.specialityHeavyIndustry,ardar_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.coreArdarSettlements[#settlement_generator.coreArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars:addTag("navyplanet")
		planet.lua.settlements.ardars.military=planet.lua.settlements.ardars.military+0.5
		planet.lua.settlements.ardars:addGoodDemand(C.NATIVE_WEAPONS,2000,3)
		planet.lua.settlements.ardars:addGoodSupply(C.MODERN_ARMAMENT,300,1)
		planet.lua.settlements.ardars:addGoodDemand(C.ARMAMENT,500,1)
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The Ardar Navy has a much greater role in the Roidhunante's settlement program than that of the Imperial Navy. Entire worlds like #planetname# have been settled and are still run by the Navy, with civilian government existing only at the local level. Almost everyone on the planet works for the Navy itself or for a defence company. "
	end,
	specialities={},
	weight=5,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.asteroidMoonArdarSettlements={}

settlement_generator.asteroidMoonArdarSettlements[#settlement_generator.asteroidMoonArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)

	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Ardar ships use it as a convenient refuelling spot. "
	end,
	weight=10,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.asteroidMoonArdarSettlements[#settlement_generator.asteroidMoonArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars.military=planet.lua.settlements.ardars.military*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The moon has been heavily fortified by the Ardar Navy, which controls the surrounding space from it. "
	end,
	weight=20,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.asteroidMoonArdarSettlements[#settlement_generator.asteroidMoonArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars.services=planet.lua.settlements.ardars.services*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Ardar traders from #planetname# use it as a minor trading base. "
	end,
	weight=10,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.worldMoonArdarSettlements={}

settlement_generator.worldMoonArdarSettlements[#settlement_generator.worldMoonArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The Roidhunate has built up automated mining industries on the moon, exporting ore to #planetname# and nearby systems. "
	end,
	weight=10,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.worldMoonArdarSettlements[#settlement_generator.worldMoonArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Ardars living in underground cities work in extensive low-gravity industries. "
	end,
	weight=10,
  barDescGenerators=bar_desc.ardar
}

settlement_generator.worldMoonArdarSettlements[#settlement_generator.worldMoonArdarSettlements+1]={
	appliesTo="ardars",
	applyOnPlanet=function(planet)
		planet.lua.settlements.ardars.military=planet.lua.settlements.ardars.military*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.ardars==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Abundant minerals and low gravity makes #moonname# a useful location for shipbuilding, something the Ardar Navy is taking full advantage of. "
	end,
	weight=30,
  barDescGenerators=bar_desc.ardar
}