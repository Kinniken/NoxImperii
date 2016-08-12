event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.INDEPENDENT_WORLDS) and planet.lua.settlements.humans and planet.c:system():presence(G.BARBARIANS)>0 and planet.lua.planet==nil)
end
event.weight=5
event.applyOnWorldCustom=function(self,planet,textData)
	textData.casualties=gh.prettyLargeNumber(planet.lua.settlements.humans.population*0.05)
	planet.lua.settlements.humans.population=planet.lua.settlements.humans.population*0.9--5% dead, 5% captives
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The ravages of the recent barbarian raids is causing a humanitarian crisis.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber(), "fringe_barbarian_raid" )
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
	return (planet.c:faction()==faction.get(G.INDEPENDENT_WORLDS) and planet.lua.settlements.humans and planet.lua.planet==nil)
end
event.weight=10
event.applyOnWorldCustom=function(self,planet,textData)
	planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*0.9
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("Isolation from the Empire is causing a drop in industrial production.",
		(time.get() + time.create( 0,1,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.humans:reduceGoodSupply(C.INDUSTRIAL,20,1,effectId)
	planet.lua.settlements.humans:reduceGoodSupply(C.MODERN_INDUSTRIAL,10,1,effectId)
end
event.eventMessage="NEWS ALERT: The economy of ${world} badly hit as Imperial trade slows. Unexported industrial goods pile up."

event.worldHistoryMessage="Slowing trade with the Empire damages industrial production."

event:addBarNews(G.INDEPENDENT_WORLDS,"Slowing trade hits ${world} economy","The independent world of ${world} is seeing a large drop in trade with the Empire, hitting industrial production badly. Is it time for independent worlds to stop relying on trade with the Empire?",time.create(0,1,0, 0,0,0))

table.insert(world_events.events,event)



event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.INDEPENDENT_WORLDS) and planet.lua.settlements.humans and planet.lua.minerals>0.8 and planet.lua.planet==nil)
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

event:addBarNews(G.INDEPENDENT_WORLDS,"Mining boom on ${world}!","In rare good news from the frontier world of ${world}, mining discoveries are driving an industrial production renaissance. Production and prices are at all-time low!",time.create(0,1,0, 0,0,0))

table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.INDEPENDENT_WORLDS) and planet.lua.settlements.natives and planet.lua.settlements.natives.stability<1 and planet.lua.settlements.humans and planet.lua.planet==nil)
end
event.weight=5
event.applyOnWorldCustom=function(self,planet,textData)
	textData.natives=planet.lua.settlements.natives.name
	textData.nativeCasualties=gh.prettyLargeNumber(planet.lua.settlements.natives.population*0.05)
	planet.lua.settlements.natives.population=planet.lua.settlements.natives.population*0.95

	textData.humanCasualties=gh.prettyLargeNumber(planet.lua.settlements.humans.population*0.01)
	planet.lua.settlements.humans.population=planet.lua.settlements.humans.population*0.99
	
	local effectId=planet.lua.settlements.natives:addActiveEffect("Clashes between natives and human population lead to booming arm sales.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber() )
	planet.lua.settlements.natives:addGoodDemand(C.BASIC_WEAPONS,20,3,effectId)
end
event.eventMessage="NEWS ALERT: Deadly clashes between natives and human settlers on ${world}, arm sales boom."

event.worldHistoryMessage="${nativeCasualties} ${natives} and ${humanCasualties} human casualties reported in widespread clashes between natives and settlers."

event:addBarNews(G.INDEPENDENT_WORLDS,"Deadly tensions on ${world}","Confusing reports are streaming in of major clashes between the ${natives} and the settlers on ${world}, with casualties estimate as high as ${nativeCasualties} natives and ${humanCasualties} humans. No explanation for the events has been given by the local government.",time.create(0,2,0, 0,0,0))

event:addBarNews(G.EMPIRE,"Deadly tensions on independent world","Confusing reports are streaming in of major clashes between the ${natives} and the settlers on ${world}, with casualties estimate as high as ${nativeCasualties} natives and ${humanCasualties} humans. The incompetent local government is unable to provide an explanation of the event. We debate at noon: should the Empire intervene?",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.INDEPENDENT_WORLDS) and planet.lua.settlements.humans and planet.lua.settlements.humans.technology<0.8 and planet.lua.nativeFertility>0.8 and planet.lua.planet==nil)
end
event.weight=20
event.duration=time.create( 0,1, 0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)

	local effectId=planet.lua.settlements.humans:addActiveEffect("The fungus attack on crops is greatly reducing supplies.",
		(time.get() + self.duration):tonumber(),"fringe_alienfungus" )
	planet.lua.settlements.humans:reduceGoodSupply(C.FOOD,100,5,effectId)
	planet.lua.settlements.humans:reduceGoodSupply(C.GOURMET_FOOD,20,5,effectId)
	planet.lua.settlements.humans:addGoodDemand(C.FOOD,50,5,effectId)
end
event.eventMessage="NEWS ALERT: Crops on ${world} under attack by native fungus, major food penury starting."

event.worldHistoryMessage="A native fungus destroyed crops, causing a near-famine."

event:addBarNews(G.INDEPENDENT_WORLDS,"Alien fungus destroys harvest on ${world}","Crops are failing on ${world} as a previously unknown native fungus invades human plantations. A famine is feared if help is not available soon; reports are ${world}'s government is appealing to the Empire for help, a clear sign of despair for this proudly independent world.")
event:addBarNews(G.EMPIRE,"Empire called for help as crops on ${world} fail","The independent world of ${world} has appealed to the Empire for help due to large-scale crop failure; a previously-undetected native fungus is suspected. We debate at noon: should the Empire help such careless colons?")
table.insert(world_events.events,event)