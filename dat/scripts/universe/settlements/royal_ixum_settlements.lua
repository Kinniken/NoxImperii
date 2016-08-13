include('universe/generate_nameGenerator.lua')
include('dat/scripts/general_helper.lua')
include('universe/settlements/bar_desc.lua')

if (not settlement_generator) then
	settlement_generator={}  --shared public interface
end

settlement_generator.royalIxumSettlements={}

settlement_generator.royalIxumSettlements[#settlement_generator.royalIxumSettlements+1]={
	appliesTo="royalixumites",
	applyOnPlanet=function(planet)
		planet.lua.settlements.royalixumites:addTag("weaponcentre")
		planet.lua.settlements.royalixumites.military=planet.lua.settlements.royalixumites.military+0.5
		planet.lua.settlements.royalixumites:addGoodSupply(C.MODERN_ARMAMENT,300,1)
		planet.lua.settlements.royalixumites:addGoodSupply(C.ARMAMENT,500,1)
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.royalixumites==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was colonised only a hundred year before the war, and was of very limited importance then. Now that its proximity to the Empire makes it one of the few worlds still under the monarchy's control, it has been turned into a significant weapon production centre thanks to massive Terran help."
	end,
	weight=10,
  barDescGenerators=bar_desc.royalixum
}

settlement_generator.royalIxumSettlements[#settlement_generator.royalIxumSettlements+1]={
	appliesTo="royalixumites",
	applyOnPlanet=function(planet)
		planet.lua.settlements.royalixumites:addTag("slums")
		planet.lua.settlements.royalixumites.stability=planet.lua.settlements.royalixumites.stability-0.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.royalixumites==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The slums of #planetname# were boiling even before the war, and numerous uprisings have been crushed here by the royal police. If the war does not end soon, this world will end up in open revolt; whether in favour of the Holy Flame or not is less certain."
	end,
	weight=10,
  barDescGenerators=bar_desc.royalixum
}

settlement_generator.royalIxumSettlements[#settlement_generator.royalIxumSettlements+1]={
	appliesTo="royalixumites",
	applyOnPlanet=function(planet)
		planet.lua.settlements.royalixumites:addTag("nobleestate")
		planet.lua.settlements.royalixumites.stability=planet.lua.settlements.royalixumites.stability+0.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.royalixumites==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "A mostly rural planet, #planetname# belongs almost entirely to one of the Kingdom's leading family. Backward and traditional, it has remained loyal to the King."
	end,
	weight=10,
  barDescGenerators=bar_desc.royalixum
}
