event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.natives and planet.lua.settlements.natives.stability<2)
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