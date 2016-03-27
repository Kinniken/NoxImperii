event=worldevent_class.createNew()
event.weight=10
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.BETELGEUSE) and planet.lua.settlements.betelgeuse)
end
event.applyOnWorldCustom=function(self,planet,textData)

	textData.house=nameGenerator.generateNameBetelgeuse()

	local effectId=planet.lua.settlements.betelgeuse:addActiveEffect("The exploration fleet's purchases are driving up the price of basic goods.",
		(time.get() + time.create(0,0,10, 0, 0, 0 )):tonumber(), "betelgeuse_fleetleaving" )
	planet.lua.settlements.betelgeuse:addGoodDemand(C.BASIC_TOOLS,50,3,effectId)
	planet.lua.settlements.betelgeuse:addGoodDemand(C.BASIC_WEAPONS,50,3,effectId)
	planet.lua.settlements.betelgeuse:addGoodDemand(C.PRIMITIVE_CONSUMER,30,3,effectId)
end
event.duration=time.create( 0,0,2, 0, 0, 0 )
event.eventMessage="NEWS ALERT: A Betelgian exploration fleet is assembling on ${world}, loading up goods to trade with natives."

event.worldHistoryMessage="A great exploration fleet assembled, seeking out unexplored systems."

event:addBarNews(G.BETELGEUSE,"Great fleet leaving to explore, trade","Under the patronage of House ${house}, a great trade and exploration fleet is assembling on ${world}. May it soon return loaded with rare goods and knowledge of distant suns!")
event:addBarNews(G.EMPIRE,"Another Betelgian fool's journey?","Word from the Betelgian planet of ${world} is that a new exploration fleet is being assembled, at considerable expenses. The promoters hope for riches from undiscovered worlds, but what will they find there that the Empire cannot provide already?")
event:addBarNews(G.ROIDHUNATE,"Betelgeuse's dangerous ambitions","Under the guise of trade and exploration, a Betelgian fleet is assembling on ${world}. Its goals are said to be peaceful, but can such a force be gathered for other purposes than expansion in one form or another? Be assured that the Roidhunate is watching closely.")
table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weight=10
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.BETELGEUSE) and planet.lua.settlements.betelgeuse)
end
event.applyOnWorldCustom=function(self,planet,textData)

	textData.house=nameGenerator.generateNameBetelgeuse()

	local effectId=planet.lua.settlements.betelgeuse:addActiveEffect("The exploration fleet is selling all kinds of native goods.",
		(time.get() + time.create(0,0,10, 0, 0, 0 )):tonumber(), "betelgeuse_fleetleaving" )

	planet.lua.settlements.betelgeuse:addGoodSupply(C.NATIVE_ARTWORK,20,1,effectId)
	if (math.random()<0.5) then planet.lua.settlements.betelgeuse:addGoodSupply(C.NATIVE_SCULPTURES,20,1,effectId) end
	if (math.random()<0.5) then planet.lua.settlements.betelgeuse:addGoodSupply(C.NATIVE_TECHNOLOGY,20,1,effectId) end
	if (math.random()<0.5) then planet.lua.settlements.betelgeuse:addGoodSupply(C.NATIVE_WEAPONS,20,1,effectId) end
	if (math.random()<0.5) then planet.lua.settlements.betelgeuse:addGoodSupply(C.EXOTIC_FOOD,20,1,effectId) end
	if (math.random()<0.5) then planet.lua.settlements.betelgeuse:addGoodSupply(C.EXOTIC_FURS,20,1,effectId) end
end
event.duration=time.create( 0,0,2, 0, 0, 0 )
event.eventMessage="NEWS ALERT: A Betelgian exploration fleet has come back to ${world}, loaded with rare goods."

event.worldHistoryMessage="An exploration fleet came back, loaded with precious goods and tales of unknown suns."

event:addBarNews(G.BETELGEUSE,"Exploration fleet returns carrying precious goods","In another great success for Betelgeuse's exploration policy, an exploration fleet has returned to ${world} loaded with rare goods and data on new worlds. Traders are bidding over the commodities on sale.")
event:addBarNews(G.EMPIRE,"Betelgian fleet returns after dubious trip","A much-hyped Betelgian \"exploration fleet\" has returned to ${world} among tales of great discoveries and untold riches. Imperial experts remain sceptical; consensus remains that nothing of great value lies beyond the Imperial sphere.")
event:addBarNews(G.ROIDHUNATE,"Is Betelgeuse mapping a future empire?","Roidhunate experts are careful analysing known data on the Betelgian fleet recently returned from the wilderness to ${world}. While the goal was officially trade and peaceful exploration, who believes Betelgeuse would do all this only for a few native trade goods?")
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weight=10
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.BETELGEUSE) and planet.lua.settlements.betelgeuse)
end
event.applyOnWorldCustom=function(self,planet,textData)

	textData.house=nameGenerator.generateNameBetelgeuse()

	local effectId=planet.lua.settlements.betelgeuse:addActiveEffect("The sale of the ${house} estate makes cheap luxury goods available.",
		(time.get() + time.create(0,0,10, 0, 0, 0 )):tonumber(), "betelgeuse_housecollapse" )
	planet.lua.settlements.betelgeuse:addGoodSupply(C.LUXURY_GOODS,50,0.5,effectId)
	if math.random()<0.5 then planet.lua.settlements.betelgeuse:addGoodSupply(C.BORDEAUX,10,0.5,effectId) end
	if math.random()<0.5 then planet.lua.settlements.betelgeuse:addGoodSupply(C.TELLOCH,10,0.5,effectId) end
	if math.random()<0.5 then planet.lua.settlements.betelgeuse:addGoodSupply(C.NATIVE_ARTWORK,10,0.5,effectId) end
	if math.random()<0.5 then planet.lua.settlements.betelgeuse:addGoodSupply(C.NATIVE_SCULPTURES,10,0.5,effectId) end
end
event.duration=time.create( 0,0,2, 0, 0, 0 )
event.eventMessage="NEWS ALERT: Family feudal causes trading house collapse on ${world}, estate put out on auction."

event.worldHistoryMessage="House ${house} collapsed due to inheritance disputes."

event:addBarNews(G.BETELGEUSE,"Family feud destroys House ${house}","Infighting over the inheritance of late Lord ${house} on ${world} had been ongoing for ten years, with the running of the once-great trading house neglected as a result. A series of bad deals last year cemented the fate of the trading house, and starting today the estate is on sale to cover the debts owned.")
table.insert(world_events.events,event)	




event=worldevent_class.createNew()
event.weight=10
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.BETELGEUSE) and planet.lua.settlements.betelgeuse)
end
event.applyOnWorldCustom=function(self,planet,textData)

	textData.house=nameGenerator.generateNameBetelgeuse()

	local effectId=planet.lua.settlements.betelgeuse:addActiveEffect("The ongoing political crisis is undermining the economy, causing a collapse in trade good prices.",
		(time.get() + time.create(0,0,10, 0, 0, 0 )):tonumber(), "betelgeuse_noblemurder" )
	planet.lua.settlements.betelgeuse:reduceGoodDemand(C.LUXURY_GOODS,30,0.5,effectId)
	planet.lua.settlements.betelgeuse:reduceGoodDemand(C.GOURMET_FOOD,30,0.5,effectId)
end
event.duration=time.create( 0,0,2, 0, 0, 0 )
event.eventMessage="NEWS ALERT: Important Lord assassinated in intrigues over ${world}'s Council seat."

event.worldHistoryMessage="Lord ${lord}'s assassination caused a major political crisis."

event:addBarNews(G.BETELGEUSE,"Lord ${lord} assassinated!","The powerful Lord ${lord}, a major political power and lead candidate for ${world}'s Council seat, was assassinated as he left his residence to attend official functions. The killer has not been caught and his motives are unknown. His Excellency the Doge has promised a full injury in the issue.")
event:addBarNews(G.EMPIRE,"Political murder rocks Betelgeuse","Lord ${lord}, a major figure on Betelgian world ${world}, was killed yesterday by a professional killer. Betelgian intrigues are notoriously difficult to unravel, but Terran intelligence suspect Ardar involvement as Lord ${world} was know for his Imperial sympathies. Is another sinister Roidhunate plot taking shape?")
event:addBarNews(G.ROIDHUNATE,"Imperial involvement suspected in Betelgian murder","Reports from Betelgian world ${world} of the murder of prominent politician Lord ${lord} have immediately triggered suspicion of Imperial involvement. What can the Empire hope to gain from such a cowardly and dishonourable move? The Ardar services have vowed to find out and extract a just revenge.")
table.insert(world_events.events,event)	




event=worldevent_class.createNew()
event.eventMessage="NEWS ALERT: Lobbying for Council position heats up on ${world}, luxury goods in high demand."
event.weight=10
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.BETELGEUSE) and planet.lua.settlements.betelgeuse)
end
event.applyOnWorldCustom=function(self,planet,textData)

	textData.house=nameGenerator.generateNameBetelgeuse()

	local effectId=planet.lua.settlements.betelgeuse:addActiveEffect("Ongoing political lobbying is driving up the price of luxury and other rare goods.",
		(time.get() + time.create(0,0,10, 0, 0, 0 )):tonumber(), "betelgeuse_lobbying" )
	planet.lua.settlements.betelgeuse:addGoodDemand(C.LUXURY_GOODS,30,3,effectId)
	planet.lua.settlements.betelgeuse:addGoodDemand(C.GOURMET_FOOD,30,3,effectId)
end
event.duration=time.create( 0,0,2, 0, 0, 0 )

event.worldHistoryMessage="Intense political lobbying preceded the election of a new Council member."

event:addBarNews(G.BETELGEUSE,"${world} to choose a new Council member",
	"The Great Families of ${world} are gathering in the capital to begin the exacting process of selecting a worthy representative on the Council. No doubt their careful deliberations will lead to the choice of a brilliant and capable Merchant-Prince.")
event:addBarNews(G.EMPIRE,"Election on ${world} to affect Betelgian policies",
	"The Betelgian world of ${world} is preparing to choose a new Council member as the leading families gather to cast their votes. As favours are traded and alliances made, Imperial experts are carefully analysing what this could mean for relations with Terra.")
event:addBarNews(G.ROIDHUNATE,"Betelgian \"election\" under influence from Terra",
	"Betelgeuse's odd and inefficient form of government is displaying its glaring weakness as the leading families of ${world} gather to choose a new Council member. Ardar intelligence report scandalous Terran involvement in the process; Ardars everywhere can rest assured that the Roidhunate security service will ensure the selected candidate is friendly to our interest.")
table.insert(world_events.events,event)	