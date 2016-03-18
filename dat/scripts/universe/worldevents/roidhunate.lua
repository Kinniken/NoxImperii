event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.natives and planet.lua.settlements.natives.stability<1)
end
event.weight=5
event.applyOnWorldCustom=function(self,planet,textData)
	textData.natives=planet.lua.settlements.natives.name
	textData.casualties=gh.prettyLargeNumber(planet.lua.settlements.natives.population*0.05)
	planet.lua.settlements.natives.population=planet.lua.settlements.natives.population*0.95
	
	local effectId=planet.lua.settlements.natives:addActiveEffect("Harsh repression of the native population is driving them to arms.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.natives:addGoodDemand(C.BASIC_WEAPONS,20,3,effectId)
end
event.eventMessage="NEWS ALERT: Native uprising on ${world} in response to Ardar repression, arm sales boom."

event.worldHistoryMessage="${casualties} ${natives} casualties reported in a ferocious Ardar repression campaign, leading to more unrest."

event:addBarNews(G.EMPIRE,"Ardar Atrocities Reported On Frontier World","Reports are coming in of a major wave of repression hitting natives on ${world}, with casualties estimated at ${casualties}. This unfortunate world was recently annexed by the nefarious Roidhunate, and the gallant ${natives} have been fighting hard against the hated invaders. While the Empire is sadly too far to aid them in their just struggle, we wish them all the best against their reptilian foes.",time.create(0,2,0, 0,0,0))

event:addBarNews(G.ROIDHUNATE,"Pacification of ${world} in progress","Recent troubles on ${world} are coming to an end thanks to the prompt and vigorous intervention of the Ardar army. The efforts of suspected Terran agitateurs is believed to be behind the recent events, as the loyalty of the ${natives} to the Roidhunate is beyond doubts.",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.c:system():presence(G.BARBARIANS)>0)
end
event.weight=5
event.applyOnWorldCustom=function(self,planet,textData)
	textData.arrivals=gh.prettyLargeNumber(planet.lua.settlements.ardars.population*0.3)
	planet.lua.settlements.ardars.population=planet.lua.settlements.ardars.population*1.3
	
	local effectId=planet.lua.settlements.ardars:addActiveEffect("Demand for industrial goods increase to accommodate new settlers.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.ardars:addGoodDemand(C.INDUSTRIAL,20,2,effectId)
	planet.lua.settlements.ardars:addGoodDemand(C.PRIMITIVE_INDUSTRIAL,20,2,effectId)
	
end
event.eventMessage="NEWS ALERT: The Roidhunate launches a massive settlement program on ${world}. Industrial supplies urgently needed!"

event.worldHistoryMessage="${arrivals} new Ardar settlers move in as part of new government program."

event:addBarNews(G.ROIDHUNATE,"The Roidhunate strengthens colonization efforts","The Roidhunate is launching a new colonization program aimed at strengthening our hold over ${world}. ${arrivals} settlers are being moved to the planet; demand for industrial goods increases to cope with the arrivals.",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars.industry>1 and planet.lua.settlements.ardars.technology>1)
end
event.weight=10
event.applyOnWorldCustom=function(self,planet,textData)
	planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry*1.1
	
	local effectId=planet.lua.settlements.ardars:addActiveEffect("Major ship-building program drives prices of armament.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.ardars:addGoodDemand(C.ARMAMENT,20,2,effectId)
	planet.lua.settlements.ardars:addGoodDemand(C.MODERN_ARMAMENT,10,2,effectId)
	
end
event.eventMessage="NEWS ALERT: New ship-building program by the Ardar Navy drives up armament prices on ${world}."

event.worldHistoryMessage="A Roidhunate ship-building campaign stimulated the local economy."

event:addBarNews(G.ROIDHUNATE,"New ship-building campaign to strengthen the Ardar Navy","The Roidhun in person has ordered a new program to boost the Ardar Navy; several new dreadnoughts will be built on ${world}. The announcement has sent prices of armament booming on the planet. Glory to the Ardar Navy!",time.create(0,2,0, 0,0,0))
event:addBarNews(G.EMPIRE,"Jingoist Roidhunate on ship-building frenzy","The militaristic and aggressive Ardars are thought to have ordered the construction of yet more ships on ${world}. Imperial experts affirm that this is only idle bluster and that the Imperial Navy would make short work of the new ships.",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasTag("hightechcenter"))
end
event.weight=50--high because so little world qualify
event.applyOnWorldCustom=function(self,planet,textData)
	planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry*1.1
	
	local effectId=planet.lua.settlements.ardars:addActiveEffect("Pioneering industrial techniques is boosting the production of modern armament.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.ardars:addGoodSupply(C.MODERN_ARMAMENT,30,0.5,effectId)
	
end
event.eventMessage="NEWS ALERT: The Ardar research centre on ${world} has developed new technologies boosting armament production."

event.worldHistoryMessage="Technical innovations drove an armament production boom."

event:addBarNews(G.ROIDHUNATE,"Innovative technology drives armament production on ${world}","The Ardar Navy research centre on ${world} is making breakthrough in modern armament production, boosting production and reducing prices! Every passing day the dominance of the Roidhunate in milutary technology grows more assured.",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)