event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.INDEPENDENT_WORLDS) and planet.lua.settlements.humans and planet.c:system():presence(G.BARBARIANS)>0)
end
event.weight=5
event.applyOnWorldCustom=function(self,planet,textData)
	textData.casualties=gh.prettyLargeNumber(planet.lua.settlements.humans.population*0.05)
	planet.lua.settlements.humans.population=planet.lua.settlements.humans.population*0.9--5% dead, 5% captives
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The ravages of the recent barbarian raids is causing a humanitarian crisis.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:addGoodDemand(C.MEDICINE,20,3,effectId)
	planet.lua.settlements.humans:addGoodDemand(C.FOOD,20,3,effectId)
end
event.eventMessage="NEWS ALERT: The independent world of ${world} is reeling under heavy barbarian raids."

event.worldHistoryMessage="Major barbarian raids leave ${casualties} colonists dead and as many taken captive."

event:addBarNews(G.EMPIRE,"Barbarian Raids on Fringe Worlds","Disturbing reports continue to come in from fringe worlds of increasing barbarian raids. On the remote world of ${world} last week, almost ${casualties} people died in a major attack and as many were taken captive. When will the independent worlds see wisdom and take shelter in the Empire?",time.create(0,2,0, 0,0,0))

event:addBarNews(G.INDEPENDENT_WORLDS,"An other free world hit!","Almost ${casualties} people died in a major barbarian attack on ${world} and as many were taken captive. Where is the protection promised by the Empire to the independent worlds?",time.create(0,2,0, 0,0,0))

table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.INDEPENDENT_WORLDS) and planet.lua.settlements.humans and planet.c:system():presence(G.BARBARIANS)>0)
end
event.weight=5
event.applyOnWorldCustom=function(self,planet,textData)
	textData.casualties=gh.prettyLargeNumber(planet.lua.settlements.humans.population*0.05)
	planet.lua.settlements.humans.population=planet.lua.settlements.humans.population*0.9--5% dead, 5% captives
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The ravages of the recent barbarian raids is causing a humanitarian crisis.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:addGoodDemand(C.MEDICINE,20,3,effectId)
	planet.lua.settlements.humans:addGoodDemand(C.FOOD,20,3,effectId)
end
event.eventMessage="NEWS ALERT: The independent world of ${world} is reeling under heavy barbarian raids."

event.worldHistoryMessage="Major barbarian raids leave ${casualties} colonists dead and as many taken captive."

event:addBarNews(G.EMPIRE,"Barbarian Raids on Fringe Worlds","Disturbing reports continue to come in from fringe worlds of increasing barbarian raids. On the remote world of ${world} last week, almost ${casualties} people died in a major attack and as many were taken captive. When will the independent worlds see wisdom and take shelter in the Empire?",time.create(0,2,0, 0,0,0))

event:addBarNews(G.INDEPENDENT_WORLDS,"An other free world hit!","Almost ${casualties} people died in a major barbarian attack on ${world} and as many were taken captive. Where is the protection promised by the Empire to the independent worlds?",time.create(0,2,0, 0,0,0))

table.insert(world_events.events,event)