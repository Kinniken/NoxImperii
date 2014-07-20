include('universe/generate_nameGenerator.lua')
include('universe/settlements/merseian_specialities.lua')


if (not settlement_generator) then
	settlement_generator={}  --shared public interface
end

settlement_generator.coreMerseianSettlements={}

settlement_generator.coreMerseianSettlements[#settlement_generator.coreMerseianSettlements+1]={
	appliesTo="merseians",
	applyOnPlanet=function(planet)
		planet.lua.settlements.merseians:addTag("oldcolony")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.merseians==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was one of the first system colonized by the Roidhunate beyond their home system. Its inhabitants are particularly proud of the fact, and tend to look down on Merseians from more recent colonies. "
	end,
	specialities={},
	weight=10
}

settlement_generator.coreMerseianSettlements[#settlement_generator.coreMerseianSettlements+1]={
	appliesTo="merseians",
	applyOnPlanet=function(planet)
		planet.lua.settlements.merseians:addTag("navyplanet")
		planet.lua.settlements.merseians.military=planet.lua.settlements.merseians.military+0.5
		planet.lua.settlements.merseians:addGoodDemand(NATIVE_WEAPONS,20,3)
		planet.lua.settlements.merseians:addGoodSupply(MODERN_ARMAMENT,30,1)
		planet.lua.settlements.merseians:addGoodDemand(ARMAMENT,50,1)
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.merseians==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The Merseian Navy has a much greater role in the Roidhunante's settlement program than that of the Imperial Navy. Entire worlds like #planetname# have been settled and are still run by the Navy, with civilian government existing only at the local level. Almost everyone on the planet works for the Navy itself or for a defense company. "
	end,
	specialities={},
	weight=5
}

