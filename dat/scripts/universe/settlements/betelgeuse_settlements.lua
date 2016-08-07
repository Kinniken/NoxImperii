include('universe/generate_nameGenerator.lua')
include('universe/settlements/betelgeuse_specialities.lua')
include('universe/settlements/bar_desc.lua')

if (not settlement_generator) then
	settlement_generator={}  --shared public interface
end

settlement_generator.betelgeuseSettlements={}

settlement_generator.betelgeuseSettlements[#settlement_generator.betelgeuseSettlements+1]={
	appliesTo="betelgeuse",
	applyOnPlanet=function(planet)
    
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.betelgeuse==nil) then
			return false
		end
    if (planet.lua.natives~=nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return gh.randomObject({"Settled early by the Betelgians, #planetname# has long been one of the most integrated world of the Oligarchy. ","#planetname# had no sapient inhabitants when it was first discovered by the Betelgians, who promptly settled it. " , "#planetname# is home to large communities of subject races from the Oligarchy, though power is firmly in the hands of Betelgian nobility. "})
	end,
	specialities={betelgeuse_specialities.specialityUniversity,betelgeuse_specialities.specialityNavalBase,betelgeuse_specialities.specialityHeavyIndustry,betelgeuse_specialities.specialityLuxuryResort,betelgeuse_specialities.specialityOre},
	weight=10,
  barDescGenerators=bar_desc.betelgeuse
}

settlement_generator.betelgeuseSettlements[#settlement_generator.betelgeuseSettlements+1]={
	appliesTo="betelgeuse",
	applyOnPlanet=function(planet)

	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.betelgeuse==nil) then
			return false
		end
    if (planet.lua.natives==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return gh.randomObject({"As elsewhere in the Oligarchy, trade relations with the natives quickly led to the creation of trading posts, and then to full colonisation by the Betelgian and already-assimilated subject races. ","Today, the most fertile parts of #planetname# are in the hands of Betelgian settlers. ","Legend that the site of the earliest Betelgian settlement was bought from the natives for a box of luminescent necklaces; it now has the highest real-estate prices on the planet. "})
	end,
	specialities={betelgeuse_specialities.specialityUniversity,betelgeuse_specialities.specialityNavalBase,betelgeuse_specialities.specialityHeavyIndustry,betelgeuse_specialities.specialityLuxuryResort,betelgeuse_specialities.specialityOre},
	weight=5,
  barDescGenerators=bar_desc.betelgeuse
}


settlement_generator.asteroidMoonBetelgianSettlements={}

settlement_generator.asteroidMoonBetelgianSettlements[#settlement_generator.asteroidMoonBetelgianSettlements+1]={
	appliesTo="betelgeuse",
	applyOnPlanet=function(planet)

	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.betelgeuse==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "It is used as a fuel depot by ships from #planetname#. "
	end,
	weight=10,
  barDescGenerators=bar_desc.betelgeuse
}

settlement_generator.asteroidMoonBetelgianSettlements[#settlement_generator.asteroidMoonBetelgianSettlements+1]={
	appliesTo="betelgeuse",
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse.military=planet.lua.settlements.betelgeuse.military*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.betelgeuse==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The Betelgian navy maintains a small base on the rock, keeping a lookout for pirates. "
	end,
	weight=10,
  barDescGenerators=bar_desc.betelgeuse
}

settlement_generator.asteroidMoonBetelgianSettlements[#settlement_generator.asteroidMoonBetelgianSettlements+1]={
	appliesTo="betelgeuse",
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse.services=planet.lua.settlements.betelgeuse.services*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.betelgeuse==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Expeditions for far-away worlds are sometime assembled on the rock. "
	end,
	weight=30,
  barDescGenerators=bar_desc.betelgeuse
}

settlement_generator.worldMoonBetelgianSettlements={}

settlement_generator.worldMoonBetelgianSettlements[#settlement_generator.worldMoonBetelgianSettlements+1]={
	appliesTo="betelgeuse",
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse.industry=planet.lua.settlements.betelgeuse.industry*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.betelgeuse==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Betelgian traders export ores from automated mines to #planetname# and nearby systems. "
	end,
	weight=10,
  barDescGenerators=bar_desc.betelgeuse
}

settlement_generator.worldMoonBetelgianSettlements[#settlement_generator.worldMoonBetelgianSettlements+1]={
	appliesTo="betelgeuse",
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse.services=planet.lua.settlements.betelgeuse.services*1.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.betelgeuse==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Massive exploration fleets assemble on #moonname# before embarking for deep space exploration journeys. "
	end,
	weight=20,
  barDescGenerators=bar_desc.betelgeuse
}

settlement_generator.worldMoonBetelgianSettlements[#settlement_generator.worldMoonBetelgianSettlements+1]={
	appliesTo="betelgeuse",
	applyOnPlanet=function(planet)
		planet.lua.settlements.betelgeuse.military=planet.lua.settlements.betelgeuse.military*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.betelgeuse==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The Betelgian Navy assembles large warships on #moonname#, using local minerals and the shallow gravity well. "
	end,
	weight=10,
  barDescGenerators=bar_desc.betelgeuse
}
