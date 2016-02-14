include('universe/generate_nameGenerator.lua')
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

