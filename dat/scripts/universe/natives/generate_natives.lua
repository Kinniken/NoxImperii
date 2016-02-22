include('universe/generate_helper.lua')
include('universe/objects/class_natives.lua')

natives_generator = {} --public interface

natives_generator.generateNativeCivilizedData=function(planet,industryFactor,agricultureFactor,serviceFactor,technologyFactor,militaryFactor)
	local baseFactor=planet.star.populationTemplate.nativeFactors
	planet.lua.natives.industry=(planet.lua.nativeFertility*0.2+planet.lua.minerals*0.5+0.3)*industryFactor*baseFactor.industry
	planet.lua.natives.agriculture=(planet.lua.nativeFertility*0.8+0.2)*agricultureFactor*baseFactor.agriculture
	planet.lua.natives.technology=technologyFactor*baseFactor.technology
	planet.lua.natives.services=(planet.lua.natives.industry+planet.lua.natives.agriculture+math.log10(planet.lua.natives.population)/10)*(1+planet.lua.natives.technology)/3*serviceFactor*baseFactor.services
	planet.lua.natives.military=militaryFactor*(3+planet.lua.natives.industry+planet.lua.natives.agriculture+planet.lua.natives.services)/5*baseFactor.military
	planet.lua.natives.stability=baseFactor.stability

	planet.lua.natives:randomizeSettlementData(0.2)

	planet.faction=planet.star.populationTemplate.nativeFaction
	planet.factionPresence=1
	planet.factionRange=1
end

natives_generator.setNativeDemands=function(planet,basicWeapons,basicTools,primitiveWeapons,primitiveIndustrial,primativeConsumption)
	planet.lua.natives.goodsDemand={}
	if (basicWeapons>0) then
		planet.lua.natives:addGoodDemand(BASIC_WEAPONS,basicWeapons,1)
	end
	if (basicTools>0) then
		planet.lua.natives:addGoodDemand(BASIC_TOOLS,basicTools,1)
	end
	if (primitiveWeapons>0) then
		planet.lua.natives:addGoodDemand(PRIMITIVE_ARMAMENT,primitiveWeapons,1)
	end
	if (primitiveIndustrial>0) then
		planet.lua.natives:addGoodDemand(PRIMITIVE_INDUSTRIAL,primitiveIndustrial,1)
	end
	if (primativeConsumption>0) then
		planet.lua.natives:addGoodDemand(PRIMITIVE_CONSUMER,primativeConsumption,1)
	end

	planet.faction="Natives"
	planet.factionPresence=0
	planet.factionRange=0
end

natives_generator.genericSpecieName=function()
	nameStart={"mer","bry","roi","brech","y","da","mo","khrai","qan","ur","tach","tel","chydh","gel","fo","mor"}
	nameMiddle={"thio","dhu","na","dwy","thol","rio","ry","dio","ru"}
	nameEnd={"thioch","te","dan","dwyr","tholch","rioch","khraich","ryf","diolch","wyr","loch","dhwan","gelch","daich","chan"}

	if (math.random()>0.5) then
		name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]
	else
		name=nameStart[ math.random(#nameStart)]..nameEnd[ math.random(#nameEnd)]
	end

	name=name:gsub("^%l", string.upper)
	return name
end

include('universe/natives/common_natives.lua')
include('universe/natives/rare_natives.lua')

local common=natives_generator.common_natives
local rare=natives_generator.rare_natives

natives_generator.noNatives={}

natives_generator.warmTerranNatives={common.leonids,common.otters,common.avians,common.simians,common.octopuses,common.crabs,rare.symbionts,rare.hives,common.spiders}
natives_generator.temperateTerranNatives={common.leonids,common.otters,common.bovines,common.avians,common.simians,common.carnivorousHumanoids,common.octopuses,common.crabs,rare.symbionts,rare.hives,common.spiders}
natives_generator.coldTerranNatives={common.hibernatingReptiles,common.beavers,common.burrowers,common.crabs}