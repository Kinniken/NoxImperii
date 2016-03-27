include('universe/generate_nameGenerator.lua')
include('universe/settlements/betelgeuse_specialities.lua')


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
	weight=10
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
	weight=5
}

