event=worldevent_class.createNew()
event.weight=10
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.EMPIRE) and planet.lua.settlements.humans and planet.c:system():presence(G.BARBARIANS)>0)
end
event.applyOnWorldCustom=function(self,planet,textData)
	textData.casualties=gh.prettyLargeNumber(planet.lua.settlements.humans.population*0.1)
	planet.lua.settlements.humans.population=planet.lua.settlements.humans.population*0.9
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("Urgent medical help is needed following the barbarian attack.",
		(time.get() + time.create(0,0,10, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:addGoodDemand(C.MEDICINE,20,3,effectId)

	adjustBarbarianActivity(get_nearest_barbarian_zone(system_class.load(planet.c:system())).name,1.01)
end
event.eventMessage="NEWS ALERT: An major barbarian raid on ${world} has decimated the main cities! Urgent help is required by the civilian population."

event.worldHistoryMessage="A major barbarian raid caused important damages to the main human cities."

event:addBarNews(G.EMPIRE,"Barbarian raid on ${world}!","Once again, barbarians have raided ${world}. Losses of lives are reported to be a staggering ${casualties} people. When will the Empire finally push back the barbarian threat?",time.create(0,0,10,0,0,0))
table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weight=10
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.EMPIRE) and planet.lua.settlements.humans and planet.lua.settlements.humans.services>0.8)
end
event.applyOnWorldCustom=function(self,planet,textData)
	planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*0.7
	planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*0.8
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The recent financial crisis has depressed demand for industrial goods.",
		(time.get() + time.create( 0,1,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:reduceGoodDemand(C.INDUSTRIAL,effectId,30,2)
	planet.lua.settlements.humans:reduceGoodDemand(C.MODERN_INDUSTRIAL,effectId,30,2)

	adjustSectorStability(planet.c:system():getZone(),0.99)
end
event.eventMessage="NEWS ALERT: The Industrial Bank of ${world} has collapsed amidst allegations of corruption by officials to hide massive losses."

event.worldHistoryMessage="The collapse of a major bank triggered a financial crisis, damaging the local economy."

event:addBarNews(G.EMPIRE,"Financial crisis on ${world}","The largest bank on ${world} has collapsed, triggering a major recession.",time.create(0,1,0,0,0,0))
event:addBarNews(G.INDEPENDENT_WORLDS,"Financial crisis on ${world}","In one more worrying sign on the poor health of the Imperial economy, the largest bank on ${world} has collapsed, triggering a major recession.",time.create(0,1,0,0,0,0))
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.EMPIRE) and planet.lua.settlements.humans and planet.lua.minerals>0.8)
end
event.weight=20
event.applyOnWorldCustom=function(self,planet,textData)
	planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*1.2
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("A mining boom is fuelling industrial production.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:addGoodSupply(C.ORE,50,0.5,effectId)
	planet.lua.settlements.humans:addGoodSupply(C.INDUSTRIAL,20,0.5,effectId)
	planet.lua.settlements.humans:addGoodSupply(C.MODERN_INDUSTRIAL,10,0.5,effectId)
end
event.eventMessage="NEWS ALERT: The discovery of rich ore veins on ${world} drives an industrial boom."

event.worldHistoryMessage="The discovery of rich ore veins fuelled an industrial boom."

event:addBarNews(G.EMPIRE,"Mining boom on ${world}!","In more good news for the Empire's economy, the world of ${world} is seeing a major increase in industrial production as newly-discovered ore veins fuel local heavy industries. Production and prices are at all-time low!",time.create(0,1,0, 0,0,0))

table.insert(world_events.events,event)






event=worldevent_class.createNew()
event.weight=5
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.EMPIRE) and planet.lua.settlements.humans)
end
event.applyOnWorldCustom=function(self,planet,textData)	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The new governor's celebrations are driving up demands for various luxury goods.",
		(time.get() + time.create( 0,0,10, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:addGoodDemand(C.LUXURY_GOODS,20,3,effectId)
	planet.lua.settlements.humans:addGoodDemand(C.GOURMET_FOOD,20,3,effectId)
	planet.lua.settlements.humans:addGoodDemand(C.EXOTIC_FOOD,10,4,effectId)
	planet.lua.settlements.humans:addGoodDemand(C.EXOTIC_FURS,10,4,effectId)

	adjustSectorStability(planet.c:system():getZone(),0.99)
end
event.eventMessage="NEWS ALERT: The governor of ${world} has been arrested on charges of corruption. New governor throwing massive inauguration party, prices of luxury goods sky-rocket."

event.worldHistoryMessage="The Imperial governor was replaced following corruption charges."

event:addBarNews(G.EMPIRE,"New governor on ${world}","The Emperor has recently nominated a new governor for ${world}, following the arrest of the previous one on corruption charges. The inauguration celebrations are rumoured to be grand!",time.create(0,0,10, 0,0,0))
event:addBarNews(G.INDEPENDENT_WORLDS,"Imperial governor arrested on ${world}","Following a new corruption scandal, yet an other Imperial governor has been arrested, this time on ${world}. Despite recent Imperial proclamations, the Terran administration seems more rotten than ever.",time.create(0,0,10, 0,0,0))
event:addBarNews(G.ROIDHUNATE,"Corruption spreads in the rotten Empire","The human Empire continues its steady moral collapse as news are coming in of another governor arrested for corruption on ${world}. At this rate our glorious navy will soon move in without a fight, welcomed as liberators by the humans themselves!",time.create(0,0,10, 0,0,0))
table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.EMPIRE) and planet.lua.settlements.humans and planet.c:system():presence(G.PIRATES)>0)
end
event.weight=10
event.applyOnWorldCustom=function(self,planet,textData)
	planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*0.9
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The production of industrial and consumer goods is currently slowed by lack of off-world inputs due to pirate attacks.",
		(time.get() + time.create( 0,1,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:reduceGoodSupply(C.INDUSTRIAL,20,3,effectId)
	planet.lua.settlements.humans:reduceGoodSupply(C.CONSUMER_GOODS,20,3,effectId)
	
	adjustSectorStability(planet.c:system():getZone(),0.99)
end
event.eventMessage="NEWS ALERT: Increased pirate attacks on ${world} is hampering local trade."

event.worldHistoryMessage="An increase in pirate attacks has depressed local trade."

event:addBarNews(G.EMPIRE,"Piracy increasing around ${world}","Trade associations on ${world} are complaining of increased piracy, hampering local trade.",time.create(0,1,0, 0,0,0))
table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.EMPIRE) and planet.lua.settlements.humans and planet.c:system():presence(G.BARBARIANS)>0)
end
event.weight=5
event.applyOnWorldCustom=function(self,planet,textData)
	textData.departures=gh.prettyLargeNumber(planet.lua.settlements.humans.population*0.3)
	planet.lua.settlements.humans.population=planet.lua.settlements.humans.population*0.7
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The departure of many colonists is depressing the local economy.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:reduceGoodDemand(C.PRIMITIVE_CONSUMER,20,0.5,effectId)
	planet.lua.settlements.humans:reduceGoodDemand(C.CONSUMER_GOODS,20,0.5,effectId)
	
	adjustSectorStability(planet.c:system():getZone(),0.98)
end
event.eventMessage="NEWS ALERT: Colonists fleeing ${world} as barbarian attacks increase."

event.worldHistoryMessage="An estimated ${departures} colonists have headed home as barbarian attacks increase."

event:addBarNews(G.EMPIRE,"A Failed Colony Abandoned for Greener Pastures","An estimated ${departures} inhabitants of the colony on ${world} have decided to leave the world, heading back to the inner systems. \"This small, distant planet was never worth it\", explained His Eminence the Imperial Representative in the sub-sector to journalists on the way to a major cocktail party. \"The colonists will be much better off in the Core Worlds.\". We thank His Eminence for his time.",time.create(0,2,0, 0,0,0))
event:addBarNews(G.ROIDHUNATE,"The Empire's colonisation efforts falter again","Reports from the human world of ${world} indicate that around ${departures} inhabitants are leaving the planet, frightened by their government's inability to protect them from barbarians. Soon the human Empire will be reduced to Terra and its moon!",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)