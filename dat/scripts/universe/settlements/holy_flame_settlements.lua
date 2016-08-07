include('universe/generate_nameGenerator.lua')
include('dat/scripts/general_helper.lua')


if (not settlement_generator) then
	settlement_generator={}  --shared public interface
end

settlement_generator.holyFlameSettlements={}

settlement_generator.holyFlameSettlements[#settlement_generator.holyFlameSettlements+1]={
	appliesTo="holyflame",
	applyOnPlanet=function(planet)
		planet.lua.settlements.holyflame:addTag("slums")
		planet.lua.settlements.holyflame.stability=planet.lua.settlements.holyflame.stability-0.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.holyflame==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Life in the sprawling slums of #planetname# has always been harsh, particularly for a formerly nomadic specie like the Ixumites. It is thus no surprise that some of the very first riots against the Monarchy happened here. The bloody repression that followed only increased the clergy's hold on the world, and massive popular celebrations were held when the Holy Flame finally overthrew the royalists on the planet. Fifty years later the mood is sombre again; the new rulers have not brought the hoped-for prosperity, and the sons and daughters of #planetname# have paid a heavy price to the continuing war."
	end,
	weight=10
}


settlement_generator.holyFlameSettlements[#settlement_generator.holyFlameSettlements+1]={
	appliesTo="holyflame",
	applyOnPlanet=function(planet)
		planet.lua.settlements.holyflame:addTag("university")
		planet.lua.settlements.holyflame:addGoodSupply(C.MODERN_ARMAMENT,20,1)
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.holyflame==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Before the war, #planetname# was renowned for its Terran-style university, a sprawling complex that was driving Ixumite science forward with the help of resident human scientists. Today the complex is closed, save only for the engineering department which focuses on helping the war effort."
	end,
	weight=10
}

settlement_generator.holyFlameSettlements[#settlement_generator.holyFlameSettlements+1]={
	appliesTo="holyflame",
	applyOnPlanet=function(planet)
		planet.lua.settlements.holyflame:addTag("religiousminority")
		planet.lua.settlements.holyflame.minorityReligion=nameGenerator.generateNameIxum()
		planet.lua.settlements.holyflame.stability=planet.lua.settlements.holyflame.stability-0.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.holyflame==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was colonised centuries ago by Ixumites of the "..planet.lua.settlements.holyflame.minorityReligion.." minority religion, keen to escape the grasp of the expanding Holy Flame. They were never royalists, but have seen with dismay the soft discrimination of the monarchy replaced with outright persecution at the hands of the victorious clergy. They would welcome a liberator with open arms now - even the kings they used to call tyrants."
	end,
	weight=5
}

settlement_generator.holyFlameSettlements[#settlement_generator.holyFlameSettlements+1]={
	appliesTo="feudal",
	applyOnPlanet=function(planet)
		planet.lua.settlements.holyflame:addTag("religiousminority")
		planet.lua.settlements.holyflame.minorityReligion=nameGenerator.generateNameIxum()
		planet.lua.settlements.holyflame:addGoodSupply(C.ARMAMENT,50,1)
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.holyflame==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Before the war, #planetname# was unusually feudal, even for Ixum. Loyalties to both the King and the clergy ran deep, and the war between them was particularly traumatic. The Council's forces prevailed, but only after a long, bloody struggle that divided local society and turned brothers against brothers, tribes against tribes. Today the world seems united again, mass-producing weapons for the Holy Flame."
	end,
	weight=10
}

