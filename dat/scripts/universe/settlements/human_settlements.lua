include('universe/generate_nameGenerator.lua')
include('universe/settlements/human_specialities.lua')
include('universe/settlements/bar_desc.lua')

if (not settlement_generator) then
	settlement_generator={}  --shared public interface
end

settlement_generator.coreHumanSettlements={}

settlement_generator.coreHumanSettlements[#settlement_generator.coreHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameFrench
		planet.lua.settlements.humans:addTag("french")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The human colony on #planetname# was founded during humanity's first great expansion phase, long before the trouble. Its settlers mostly came from French-speaking areas of Europe and West Africa, and the dominant language on the planet today is a creole based on it. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityWeaponLab,settlements_specialities.specialityHam},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.coreHumanSettlements[#settlement_generator.coreHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("chinese")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was settled early in the first great migrations by the then-expansionist Neo-Chinese Empire. The colony soon broke rank with the motherland however, and developed a local culture which merged the original Chinese culture with that of later waves of immigrants. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityWeaponLab,settlements_specialities.specialityHam},
	weight=10,
  barDescGenerators=bar_desc.imperial
}


settlement_generator.coreHumanSettlements[#settlement_generator.coreHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("hindu")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The original settlers of #planetname# came primarily from the Indian subcontinent, particularly from the gangetic plains. Though they were later joined by migrants of other origins, Hinduism has remained the dominant religion on the world, and the festivals held are regular intervals by the settlers are famous in the sector. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.coreHumanSettlements[#settlement_generator.coreHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("penal")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return (planet.lua.humanFertility<0.7)
	end,
	getDesc=function(planet)
		return "The first human presence on #planetname# was a small penal colony established during the early Empire. As the number of prisoners grew, they were put to work in productive activities and soon a small industrial operation took form. "
	end,
	specialities={settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.coreHumanSettlements[#settlement_generator.coreHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("backward")
		planet.lua.settlements.humans.technology=planet.lua.settlements.humans.technology*0.7
		planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*0.7
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*0.7
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return (planet.lua.humanFertility<0.7)
	end,
	getDesc=function(planet)
		return "#planetname# is not a particularly fertile planet, and colonization has been difficult. With little rewards to offer, the starting settlement did not get the most motivated or valuable settlers, which further handicapped the colony. As a result, it is still more backward than most of its neighbours. "
	end,
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.coreHumanSettlements[#settlement_generator.coreHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("navyplanet")
		planet.lua.settlements.humans.military=planet.lua.settlements.humans.military*2
		planet.lua.settlements.humans:addGoodDemand(C.NATIVE_WEAPONS,20,3)
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was settled early during the rise of the Empire, when the barbarian menace had not yet been banished from the inner Empire. It was initially a purely military settlement, and military life still dominates the colony. The population continues to provide a disproportionate share of the Imperial Navy's officers. "
	end,
	weight=5,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.coreHumanSettlements[#settlement_generator.coreHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("amish")
		planet.nameGenerator=nameGenerator.generateNameEnglish
		planet.lua.settlements.humans.technology=planet.lua.settlements.humans.technology*0.5
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*0.5
		planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*0.5
		planet.lua.settlements.humans.agriculture=planet.lua.settlements.humans.agriculture*1.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		if (planet.lua.settlements.humans.agriculture<0.5) then
			return false
		end

		return true
	end,
	getDesc=function(planet)
		return "#planetname# was settled shortly before the Troubles by religious communities, primarily from North America, that never felt at home with the Commonwealth's mercantile society. Led by the significant Amish settling groups, they have focused on developing the world's agricultural potential. "
	end,
	specialities={settlements_specialities.specialityNavalBase,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityCraftBeer,settlements_specialities.specialityHam},
	weight=5,
  barDescGenerators=bar_desc.imperial
}



settlement_generator.outerHumanSettlements={}

settlement_generator.outerHumanSettlements[#settlement_generator.outerHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("imperialsettlement")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The human colony on #planetname# dates back to the expansion period that followed the establishment of the Empire. The initial settlement was planned and financed by the Imperial government in order to bolster human presence in the region. Though the colony has grown and diversified since then, its citizens remain Imperial loyalists. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.outerHumanSettlements[#settlement_generator.outerHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("serbian")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The human colony on #planetname# is dominated by the descendants of Serbian settlers, who form a tightly-bond community structured around an autonomous Orthodox Church. "
	end,
	specialities={settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityWeaponLab},
	weight=5,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.outerHumanSettlements[#settlement_generator.outerHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("chinese")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The barbarian sacks of Earth during the Troubles laid to waste many of Earth's most settled areas. While the planet recovered after the rise of the Empire, survivors of the worse-hit areas often chose to leave the world behind. Greater China was one of the former nations whose inhabitants left in the largest numbers, and #planetname# was one of their early new colony. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityWeaponLab,settlements_specialities.specialityHam},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.outerHumanSettlements[#settlement_generator.outerHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("boomtown")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Unusually for a planet relatively far from Terra, #planetname# was colonized early in the Commonwealth. At the time, analysis indicated exceptionally rich sources of rare elements. They turned out to be mostly mirages and difficult to exploit, but the colony stayed and prospered. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.outerHumanSettlements[#settlement_generator.outerHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("excorporateworld")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The human colony on #planetname# was initially founded by a large corporation back in the Commonwealth era. After much abuse of indentured workers, a revolution swept-away the corporate administrators. Efforts to regain control of the planet were stopped by the start of the Troubles. "
	end,
	specialities={settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.outerHumanSettlements[#settlement_generator.outerHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("latinamerican")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Following the destruction of much of Latin America during the barbarian invasions of Earth, a large group of Spanish-speaking settlers from the former Andean Confederation left Earth determined to put the destructions behind them. Their settlement on #planetname# proved successful, and the colony has in turn spawned several daughter colonies on other worlds. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityLuxuryResort,settlements_specialities.specialityWeaponLab,settlements_specialities.specialityHam},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.fringeEmpireSettlements={}

settlement_generator.fringeEmpireSettlements[#settlement_generator.fringeEmpireSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("libertarians")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The colony on #planetname# was originally independent, set up by a group of idealist libertarians keen to escape the Empire's heavy hand. Ten years after a promising start, they were raided by a major barbarian force. They rebuilt and boosted their defence. Five years after an other raid over-powered them. A coup soon followed, the original government was deposed, and a protection treaty incorporated the world inside the Empire. "
	end,
	specialities={settlements_specialities.specialityCraftBeer,settlements_specialities.specialityHam,settlements_specialities.specialityFrontierBase,settlements_specialities.specialityFrontierIndustry,settlements_specialities.specialityFrontierNightLife,settlements_specialities.specialityFrontierOre},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.fringeEmpireSettlements[#settlement_generator.fringeEmpireSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("backward")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# was settled with high hopes two centuries ago, in one of the Empire's last boot of expansionism. For a while, the colony developed well - though most of the settlers were not humans but of client species. Since then, the economy of the sector has gradually shrunk, and #planetname# has been reduced to a declining, backward world. "
	end,
	specialities={settlements_specialities.specialityCraftBeer,settlements_specialities.specialityHam,settlements_specialities.specialityFrontierBase,settlements_specialities.specialityFrontierNightLife},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.fringeEmpireSettlements[#settlement_generator.fringeEmpireSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("isolationisthumanoids")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Many worlds were colonized by human groups keen to preserve a distinct identity by moving to a new world - less well-known are worlds colonized by client species for the same purpose. Though #planetname# now has a large human population as well, it was originally settled by humanoids from an inner world seeking refuge from the increasing inflow of other species on their mother world. "
	end,
	specialities={settlements_specialities.specialityFrontierBase,settlements_specialities.specialityFrontierIndustry,settlements_specialities.specialityFrontierOre},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.fringeEmpireSettlements[#settlement_generator.fringeEmpireSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)	
		planet.lua.settlements.humans:addTag("sunnibuddhist")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname#'s human colony was founded by an heretical faction of the Sunni-Buddhist syncretism common on worlds with large Asian populations. While the colony has since diversified, the dominant culture remains much more religious and conservative than is common in this era of general decadence. "
	end,
	specialities={settlements_specialities.specialityFrontierBase,settlements_specialities.specialityFrontierIndustry,settlements_specialities.specialityFrontierOre},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.fringeEmpireSettlements[#settlement_generator.fringeEmpireSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("companytown")
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*1.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.EMPIRE) then
			return false
		end
		return (planet.lua.minerals>0.8)
	end,
	getDesc=function(planet)
		return "Even in an era of decadence and timidity, the long human tradition of for-profit colonization continues. #planetname# was settled a century ago by an industry magnate eager to exploits the world's rich ore deposits. "
	end,
	specialities={settlements_specialities.specialityFrontierBase,settlements_specialities.specialityFrontierIndustry,settlements_specialities.specialityFrontierNightLife},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.fringeHumanIndependentSettlements={}

settlement_generator.fringeHumanIndependentSettlements[#settlement_generator.fringeHumanIndependentSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("buddhist")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.INDEPENDENT_WORLDS) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "For all the risks involved in setting out to found a colony far from the Empire's protection, many are the groups willing to do so - often to preserve an endangered way of life on a world of their own. This world was settled mostly by committed Buddhists originating from different inner worlds. So far, their small self-defence force has proven sufficient against the occasional raiders. "
	end,
	specialities={settlements_specialities.specialityCraftBeer,settlements_specialities.specialityHam,settlements_specialities.specialityFrontierOre},
	weight=10,
  barDescGenerators=bar_desc.independent
}

settlement_generator.fringeHumanIndependentSettlements[#settlement_generator.fringeHumanIndependentSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("isolated")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.INDEPENDENT_WORLDS) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "At the edge of Human Space, the colony of #planetname# feels like the last stop before the wilderness. The few Imperial visitors seem in a hurry to conclude their business and return to the safety of the inner worlds. More numerous are the non-human sophonts of various origins, most of them from races that cannot have joined civilization more than a few generations ago. "
	end,
	specialities={settlements_specialities.specialityCraftBeer,settlements_specialities.specialityHam,settlements_specialities.specialityFrontierOre,settlements_specialities.specialityFrontierNightLife},
	weight=10,
  barDescGenerators=bar_desc.independent
}

settlement_generator.fringeHumanIndependentSettlements[#settlement_generator.fringeHumanIndependentSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("eximperial")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.INDEPENDENT_WORLDS) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Two generations ago, #planetname# was an Imperial world, though on the outer periphery. While links were never officially severed, the Imperial presence gradually lessened, the Navy withdrew from the system, and when the last Imperial governor was promoted to an other system, his replacement never arrived. The residents of #planetname# are now on their own. "
	end,
	specialities={settlements_specialities.specialityCraftBeer,settlements_specialities.specialityHam,settlements_specialities.specialityFrontierOre,settlements_specialities.specialityFrontierNightLife},
	weight=10,
  barDescGenerators=bar_desc.independent
}

settlement_generator.fringeHumanIndependentSettlements[#settlement_generator.fringeHumanIndependentSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("disagracedearl")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.INDEPENDENT_WORLDS) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The human colony on #planetname# was founded three centuries ago by an Imperial Earl victim of court intrigues, who chose to move to a new world instead of facing disgrace in the Empire. A move which showed him to have more determination and leadership than his rivals - a cardinal sin in Imperial circles. "
	end,
	specialities={settlements_specialities.specialityCraftBeer,settlements_specialities.specialityHam,settlements_specialities.specialityFrontierOre,settlements_specialities.specialityFrontierNightLife},
	weight=10,
  barDescGenerators=bar_desc.independent
}

settlement_generator.fringeHumanIndependentSettlements[#settlement_generator.fringeHumanIndependentSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("feudalworld")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.faction~=G.INDEPENDENT_WORLDS) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "With little trade or interactions with the rest of the human race, the settlers on #planetname# have turned inward. The political system has turned quasi-feudal, with a large uneducated underclass. Only members of the elite now have contacts with passing ships. "
	end,
	specialities={settlements_specialities.specialityCraftBeer,settlements_specialities.specialityHam,settlements_specialities.specialityFrontierOre},
	weight=10,
  barDescGenerators=bar_desc.independent
}


settlement_generator.asteroidMoonHumanSettlements={}

settlement_generator.asteroidMoonHumanSettlements[#settlement_generator.asteroidMoonHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)

	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "It is home to a small spaceport used for out-of-atmosphere refuelling and repairs. "
	end,
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.asteroidMoonHumanSettlements[#settlement_generator.asteroidMoonHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans.military=planet.lua.settlements.humans.military*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The Imperial Navy has established a small outpost on it, to protect and control #planetname# below. "
	end,
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.asteroidMoonHumanSettlements[#settlement_generator.asteroidMoonHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "It has become a small hub for trade to and from #planetname#, with shuttle services connecting it to the world. "
	end,
	weight=10,
  barDescGenerators=bar_desc.imperial
}



settlement_generator.worldMoonHumanSettlements={}

settlement_generator.worldMoonHumanSettlements[#settlement_generator.worldMoonHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Automated mining of some value is conducted on it, exporting ore to #planetname# and nearby systems. "
	end,
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.worldMoonHumanSettlements[#settlement_generator.worldMoonHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Low-gravity industries are implanted on the moon, leading to the development of a few small domed cities. "
	end,
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.worldMoonHumanSettlements[#settlement_generator.worldMoonHumanSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans.military=planet.lua.settlements.humans.military*2
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The Imperial Navy has built-up one of its major shipyard on #moonname#, using the abundant local minerals and the low gravity to build large warships. "
	end,
	weight=10,
  barDescGenerators=bar_desc.imperial
}


settlement_generator.hyadesSettlements={}

settlement_generator.hyadesSettlements[#settlement_generator.hyadesSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameArab
		planet.lua.settlements.humans:addTag("iran")
		planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry+0.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.lua.minerals < 1) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Like many worlds in the Hyades Cluster, #planetname#  was populated mainly by Iranians fleeing an increasingly unlivable Middle East in the 22nd century. They used the abundant mineral resources to their advantage, turning the planet into one of the industrial powerhouses that dominate the Cluster. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.hyadesSettlements[#settlement_generator.hyadesSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameArab
		planet.lua.settlements.humans:addTag("arab")
		planet.lua.settlements.humans.services=planet.lua.settlements.humans.services+0.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname#'s original population was mainly from the Near East, and the local architecture still plays tribute to it; golden domes dominate the skyline of most cities. The population today is however very mixed, reflecting its status as a major trade centre in the Cluster's tightly-woven hyperspace lanes. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.hyadesSettlements[#settlement_generator.hyadesSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameArab
		planet.lua.settlements.humans:addTag("arab")
		planet.lua.settlements.humans.agriculture=planet.lua.settlements.humans.agriculture+0.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil or planet.lua.humanFertility > 1) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Less rich in minerals than most worlds in the Cluster, #planetname# quickly specialised in agriculture; its fertile lands are cultivated by farmers of mostly Egyptian origins, who have stayed closer to their culture than most of the Cluster's industrial masses. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.hyadesSettlements[#settlement_generator.hyadesSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameArab
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Even by the standards of the Cluster, #planetname# is home to an odd mix of cultures - the original Hebrew settlers have been joined by colons not only from the rest of the Middle East but also from South America and former India. The local fusion cooking is famous as far as Terra, a rarity for a region more known for heavy industry. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.hyadesSettlements[#settlement_generator.hyadesSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameChinese
		planet.lua.settlements.humans:addTag("chinese")
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "When the extent of the mineral riches of the Cluster became apparent, states that had neglected the area tried to quickly lay claim to what was left. #planetname# thus became one of the only Cluster world populated mainly by Chinese immigrants. "
	end,
	specialities={settlements_specialities.specialityUniversity,settlements_specialities.specialityNavalBase,settlements_specialities.specialityHeavyIndustry,settlements_specialities.specialityWeaponLab},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.blessedSettlements={}

settlement_generator.blessedSettlements[#settlement_generator.blessedSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameHindi
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "The human colony on #planetname# started as a religious community of a syncretic Hindu-Buddhist movement, briefly fashionable in the 23rd century among jaded Terran elites. While the movement has been in decline for a century at least, it still shapes life on #planetname#: contemplative, laid-back, and a little away from the bustle of the rest of the Empire. "
	end,
	specialities={},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.blessedSettlements[#settlement_generator.blessedSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameHindi
		planet.lua.settlements.humans.agriculture=planet.lua.settlements.humans.agriculture+0.5
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "Like many of the Blessed Worlds, #planetname#'s population is mainly of South Asian origin. Sheltered from barbarians by the Rift, but also cut out from the main lines of Imperial trade, #planetname# has evolved as a quiet world focused on agriculture and light industry. "
	end,
	specialities={},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.blessedSettlements[#settlement_generator.blessedSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.nameGenerator=nameGenerator.generateNameHindi
		planet.lua.settlements.humans.population=planet.lua.settlements.humans.population+1000000000
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# stayed a quiet backwater for two centuries after its foundation, too remote from Terra and the main centres of the Empire to attract much settlers. The increase in barbarian activity in the Empire's outlying sectors has changed things; the population of the main cities is now booming as people relocate from more exposed worlds. "
	end,
	specialities={},
	weight=10,
  barDescGenerators=bar_desc.imperial
}

settlement_generator.blessedSettlements[#settlement_generator.blessedSettlements+1]={
	appliesTo="humans",
	applyOnPlanet=function(planet)
		planet.lua.settlements.humans:addTag("hindu")
		planet.nameGenerator=nameGenerator.generateNameHindi
		planet.lua.settlements.humans.population=planet.lua.settlements.humans.population+1000000000
	end,
	weightValidity=function(planet)
		if (planet.lua.settlements==nil or planet.lua.settlements.humans==nil) then
			return false
		end
		return true
	end,
	getDesc=function(planet)
		return "#planetname# is heavily populated for a Blessed World, a legacy of a large-scale settlement programme that shifted millions of Bengalis threatened by rising seas. "
	end,
	specialities={},
	weight=10,
  barDescGenerators=bar_desc.imperial
}