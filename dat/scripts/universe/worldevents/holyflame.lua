event=worldevent_class.createNew()
event.eventMessage="NEWS ALERT: Royalist strikes on ${world}; important infrastructure damage, casualties reported."
event.weight=30
event.duration=time.create(0,1,0, 0, 0, 0 )
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.HOLY_FLAME) and planet.lua.settlements.holyflame and planet.c:system():presence(G.ROYAL_IXUM)>20 and planet.lua.planet==nil)
end
event.applyOnWorldCustom=function(self,planet,textData)
	textData.casualties=gh.prettyLargeNumber(planet.lua.settlements.holyflame.population*0.01)
	planet.lua.settlements.holyflame.population=planet.lua.settlements.holyflame.population*0.99
	planet.lua.settlements.holyflame.industry=planet.lua.settlements.holyflame.industry*0.95
	
	local effectId=planet:addActiveEffect("holyflame","Reconstruction following the bombings is causing strong demand in industrial goods.",
		(time.get() + self.duration):tonumber(), "holyflame_bombingraid" )
	planet.lua.settlements.holyflame:addGoodDemand(C.INDUSTRIAL,50,3,effectId)
	planet.lua.settlements.holyflame:addGoodDemand(C.PRIMITIVE_INDUSTRIAL,20,3,effectId)
end
event.worldHistoryMessage="Royal strikes cause ${casualties} casualties, major industrial damage."

event:addBarNews(G.ROYAL_IXUM,"Targeted strikes hits fanatics on ${world}","The Order's installations on ${world} were decisively hit in targeted raids on their armament production centres. The King has thanked the brave Officers which lead the successful raid.")
event:addBarNews(G.HOLY_FLAME,"Cowardly attacks on ${world}","The faithless tyrant has continued his campaign of terror by bombing the peace-loving world of ${world}. The Holy Flame will transcend the victims of this unholy aggression and guide us to victory!")
event:addBarNews(G.EMPIRE,"Roidhunate client hit on ${world}","The Ardar Ixumite client state, the so-called Order, has been dealt a stinging blow by our gallant Ixumite allies as targeted strikes hit ${world}. With Imperial help, the Roidhunate's nefarious plans against the legitimate King of Ixum will be foiled.")
event:addBarNews(G.ROIDHUNATE,"Ixumite tyrant strikes at ${world}","The so-called Royal Ixumite Navy has struck at ${world}, causing significant civilian casualties. The Roidhun himself has warned the Emperor again: restrain your lap dog, or the Empire itself will be held to account.")
table.insert(world_events.events,event)





event=worldevent_class.createNew()
event.eventMessage="NEWS ALERT: Mass protests rock ${world}; economy at standstill."
event.weight=10
event.duration=time.create(0,1,0, 0, 0, 0 )
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.HOLY_FLAME) and planet.lua.settlements.holyflame and planet.lua.settlements.holyflame:hasTag("slums") and planet.lua.planet==nil)
end
event.applyOnWorldCustom=function(self,planet,textData)
	local effectId=planet:addActiveEffect("holyflame","Protests against the war paralyse consumer goods production.",
		(time.get() + self.duration):tonumber(), "holyflame_protests" )
	planet.lua.settlements.holyflame:reduceGoodSupply(C.CONSUMER_GOODS,500,3,effectId)
	planet.lua.settlements.holyflame:reduceGoodSupply(C.PRIMITIVE_CONSUMER,500,3,effectId)
end
event.worldHistoryMessage="Mass protests against the war were severely repressed."

event:addBarNews(G.ROYAL_IXUM,"Loyal subjects on ${world} protest against Order usurpers","In welcome news for Ixum, loyalists on ${world} are protesting the usurpation of power by the Order's fanatics. Soon they will be swept from power on all Ixumite worlds.")
event:addBarNews(G.HOLY_FLAME,"Agitation on ${world} to be strictly repressed","Unfaithful elements on ${world} are protesting against our just battle against the Tyrant, claiming our holy crusade has costs too many lives. Don't the fools realise how little their sacrifices weight in our struggle against the enemies of the Flame? Rest assured the Temple forces will put an end to this foolishness.")
table.insert(world_events.events,event)



event=worldevent_class.createNew()
event.eventMessage="NEWS ALERT: Religious persecutions on ${world}; people fleeing."
event.weight=50
event.duration=time.create(0,1,0, 0, 0, 0 )
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.HOLY_FLAME) and planet.lua.settlements.holyflame and planet.lua.settlements.holyflame:hasTag("religiousminority") and planet.lua.planet==nil)
end
event.applyOnWorldCustom=function(self,planet,textData)

	textData.departures=gh.prettyLargeNumber(planet.lua.settlements.holyflame.population*0.05)
	planet.lua.settlements.holyflame.population=planet.lua.settlements.holyflame.population*0.95
	textData.minorityReligion=planet.lua.settlements.holyflame.minorityReligion

	local effectId=planet:addActiveEffect("holyflame",gh.format("Departure of skilled ${minorityReligion} Ixumites is reducing industrial production.",textData),
		(time.get() + self.duration):tonumber(), "holyflame_minoritydeparture" )
	planet.lua.settlements.holyflame:reduceGoodSupply(C.INDUSTRIAL,500,3,effectId)
	planet.lua.settlements.holyflame:reduceGoodSupply(C.MODERN_INDUSTRIAL,500,3,effectId)
end
event.worldHistoryMessage="Up to ${departures} ${minorityReligion} Ixumites left, fleeing religious persecution."

event:addBarNews(G.ROYAL_IXUM,"Persecuted ${minorityReligion} followers flee ${world}","The rabid Order continues its persecutions of fellow Ixumites on ${world}, with the ${minorityReligion} minority particularly persecuted. The Kingdom opens its arm to any refugees able to reach our borders. While His Majesty the King rules under the benediction of the Holy Flame, he has always guaranteed the freedom of the ${minorityReligion} followers, provided they are faithful to the Crown.")
event:addBarNews(G.HOLY_FLAME,"${minorityReligion} heathens flee ${world}","The ${minorityReligion} heathens are fleeing the Order's holy efforts to purify ${world}. The Council has accepted the departure of limited numbers of troublesome elements to the tyrant's worlds. Can more proof be needed of the would-be King's lack of faith in the Flame than his willingness to shelter unbelievers?")
table.insert(world_events.events,event)



event=worldevent_class.createNew()
event.eventMessage="NEWS ALERT: Major religious festival on ${world}; consumer goods in high demand."
event.weight=10
event.duration=time.create(0,1,0, 0, 0, 0 )
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.HOLY_FLAME) and planet.lua.planet==nil)
end
event.applyOnWorldCustom=function(self,planet,textData)

	local effectId=planet:addActiveEffect("holyflame","A major religious festival is driving up demand for consumer goods.",
		(time.get() + self.duration):tonumber(), "holyflame_religiousfestival" )
	planet.lua.settlements.holyflame:addGoodSupply(C.CONSUMER_GOODS,50,3,effectId)
	planet.lua.settlements.holyflame:addGoodSupply(C.PRIMITIVE_CONSUMER,50,3,effectId)
end
event.worldHistoryMessage="A major religious festival was held."

event:addBarNews(G.HOLY_FLAME,"Holy Flame honoured on ${world}","The faithful population of ${world} is celebrating the Holy Flame in a month-long festival. May this show of popular piety gains us the favour of the Flame!")
table.insert(world_events.events,event)