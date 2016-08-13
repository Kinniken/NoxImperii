include('universe/generate_nameGenerator.lua')
include('universe/settlements/bar_desc.lua')

if (not settlement_generator) then
	settlement_generator={}  --shared public interface
end

settlement_generator.barbarianSettlements={}

settlement_generator.barbarianSettlements[#settlement_generator.barbarianSettlements+1]={
	appliesTo=G.BARBARIANS,
	applyOnPlanet=function(planet)

	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.barbarians==nil) then
			return false
		end
		return (planet.lua.settlements.barbarians.population>1000000 and not planet.lua.natives)
	end,
	getDesc=function(planet)
		return "The local sapient specie was unremarkable - large humanoids with primitive tool-making capacities surviving mainly from hunting. And then a few centuries back they came in contact with outlaws, shady traders and barbarians of other backward races. They traded for modern technologies they did not understand, made their first arms in the navies of other species, and now armed with shaky hulls kept running by stolen technology they venture on their own to plunder what they can. "
	end,
	weight=10,
  barDescGenerators=bar_desc.barbarians
}

settlement_generator.barbarianSettlements[#settlement_generator.barbarianSettlements+1]={
	appliesTo=G.BARBARIANS,
	applyOnPlanet=function(planet)

	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.barbarians==nil) then
			return false
		end
		return (planet.lua.settlements.barbarians.population<=1000000 or planet.lua.natives)
	end,
	getDesc=function(planet)
		return "An outpost of barbarian troops has recently been setup on #planetname#. The activity present seems limited to the minimum necessary to support roving barbarian fleets, extending their plundering range. It looks unlikely that a serious colonization effort will ever be attempted. "
	end,
	weight=10,
  barDescGenerators=bar_desc.barbarians
}

