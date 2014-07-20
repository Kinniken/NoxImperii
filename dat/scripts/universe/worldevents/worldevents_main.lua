include('universe/objects/class_worldevents.lua')
include('universe/objects/class_systems.lua')
include('universe/live/universe_status.lua')

--Const copy-pasted for auto-completion. Not best design but avoids mistakes
EXOTIC_FOOD="Exotic Food"
FOOD="Food"
GOURMET_FOOD="Gourmet Food"
BORDEAUX="Bordeaux Grands Crus"
TELLOCH="Roidhun Fine Telloch"

PRIMITIVE_CONSUMER="Primitive Consumer Goods"
CONSUMER_GOODS="Consumer Goods"
LUXURY_GOODS="Luxury Goods"

EXOTIC_FURS="Exotic Furs"
NATIVE_ARTWORK="Native Artworks"
NATIVE_SCULPTURES="Native Sculptures"

ORE="Ore"

BASIC_TOOLS="Non-Industrial Tools"
PRIMITIVE_INDUSTRIAL="Primitive Industrial Goods"
INDUSTRIAL="Industrial Goods"
MODERN_INDUSTRIAL="Modern Industrial Goods"

EXOTIC_ORGANIC="Exotic Organic Components"
HUMAN_MEDICINE="Human Medicine"

NATIVE_WEAPONS="Native Weapons"
BASIC_WEAPONS="Non-Industrial Weapons"
PRIMITIVE_ARMAMENT="Primitive Armament"
ARMAMENT="Armament"
MODERN_ARMAMENT="Modern Armament"

NATIVE_TECHNOLOGY="Native Technology"


world_events= {} --public interface
world_events.events={}


event=worldevent_class.createNew()
event.applyOnWorldCustom=function(self,planet)
	planet.lua.settlements.humans.population=planet.lua.settlements.humans.population*0.9
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("Urgent medical help is needed following the barbarian attack.",
		(time.get() + time.create( 0, 5, 0 )):tonumber() )
	planet.lua.settlements.humans:addGoodDemand(HUMAN_MEDICINE,20,3,effectId)
end
event.getEventMessage=function(self,planet)
	return "NEWS ALERT: An major barbarian raid on "..planet.c:name().." has decimated the main cities! Urgent help is required by the civilian population."
end
event.getWorldHistoryMessage=function(self,planet)
	return "A major barbarian raid caused important damages to the main human cities."
end
event.weightValidity=function(planet)
	return (planet.lua.settlements.humans and planet.c:system():presence("Barbarians")>0)
end
world_events.events[#world_events.events+1]=event


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.lua.settlements.humans and planet.lua.settlements.humans.services>0.8)
end
event.applyOnWorldCustom=function(self,planet)
	planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*0.7
	planet.lua.settlements.humans.industry=planet.lua.settlements.humans.industry*0.8
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The recent financial crisis has depressed demand for industrial goods.",
		(time.get() + time.create( 0, 5, 0 )):tonumber() )
	planet.lua.settlements.humans:reduceGoodDemand(INDUSTRIAL,effectId,30,2)
	planet.lua.settlements.humans:reduceGoodDemand(MODERN_INDUSTRIAL,effectId,30,2)

	adjustSectorStability(planet.c:system():getZone(),0.99)
end
event.getEventMessage=function(self,planet)
	return "NEWS ALERT: The Industrial Bank of "..planet.c:name().." has collapsed amidst allegations of corruption of officials to hide massive losses."
end
event.getWorldHistoryMessage=function(self,planet)
	return "The collapse of a major bank triggered a major financial crisis, damaging the local economy."
end
world_events.events[#world_events.events+1]=event


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.lua.settlements.humans and planet.lua.settlements.humans.services>0.6 and planet.c:faction():name()=="Empire of Terra")
end
event.applyOnWorldCustom=function(self,planet)	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The new governor's celebrations are driving up demands for various luxury goods.",
		(time.get() + time.create( 0, 5, 0 )):tonumber() )
	planet.lua.settlements.humans:addGoodDemand(LUXURY_GOODS,20,3,effectId)
	planet.lua.settlements.humans:addGoodDemand(GOURMET_FOOD,20,3,effectId)
	planet.lua.settlements.humans:addGoodDemand(EXOTIC_FOOD,10,4,effectId)
	planet.lua.settlements.humans:addGoodDemand(EXOTIC_FURS,10,4,effectId)

	adjustSectorStability(planet.c:system():getZone(),0.99)
end
event.getEventMessage=function(self,planet)
	return "NEWS ALERT: The governor of "..planet.c:name().." has been arrested on charges of corruption. New governor throwing massive inauguration party."
end
event.getWorldHistoryMessage=function(self,planet)
	return "The Imperial governor was replaced following corruption charges."
end
world_events.events[#world_events.events+1]=event


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.lua.settlements.humans and planet.c:system():presence("Pirate")>0)
end
event.applyOnWorldCustom=function(self,planet)
	planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*0.9
	
	local effectId=planet.lua.settlements.humans:addActiveEffect("The production of industrial and consumer goods is currently slowed by lack of offworld inputs due to pirate attacks.",
		(time.get() + time.create( 0, 5, 0 )):tonumber() )
	planet.lua.settlements.humans:reduceGoodSupply(INDUSTRIAL,20,3,effectId)
	planet.lua.settlements.humans:reduceGoodSupply(CONSUMER_GOODS,20,3,effectId)
	
	adjustBarbarianActivity(get_nearest_barbarian_zone(system_class.load(planet.c:system())),1.01)

end
event.getEventMessage=function(self,planet)
	return "NEWS ALERT: Increased pirate attacks on "..planet.c:name().." is hampering local trade."
end
event.getWorldHistoryMessage=function(self,planet)
	return "An increase in pirate attacks has depressed local trade."
end
world_events.events[#world_events.events+1]=event