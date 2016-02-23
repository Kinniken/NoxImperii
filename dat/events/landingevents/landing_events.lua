
include('universe/generate_helper.lua')
include('universe/objects/class_planets.lua')

landing_events={}  --shared public interface

include "dat/events/landingevents/native_events.lua"
include "dat/events/landingevents/lifeforms_events.lua"
include "dat/events/landingevents/geologic_events.lua"

--copying the keys to an id value for future reference
for k,event in pairs(landing_events) do
  event.id=k
end

function create()
	local landedPlanet=planet_class.load(planet.cur())

	if (debugMode or not landedPlanet:hasTag("visited")) then

    local validEvents=gh.filterConditionalObjects(landing_events,landedPlanet)

    local civilizedSystem=landingEventsIsSystemCivilized(system:cur())

    --remove all wilderness-only events from valid events
    --(could be handled via events' filtering methods but would be slower)
    if civilizedSystem then
      for k, v in pairs(validEvents) do
        if v.uncivilizedOnly then
          validEvents[k]=nil
        end
      end
    end


  		--chances of having an event equal to total weight of events as %
      -- (i.e, below totalWeight>100, the weight and the chance % are the same)
      local totalWeight=0
      for k, v in pairs(validEvents) do
        totalWeight=totalWeight+v.weight
      end


      if debugMode or math.random()*100<totalWeight then

       if (totalWeight>0) then
        local levent=gh.pickWeightedObject(validEvents)

        levent.runEvent(landedPlanet)
      end
    end

    landedPlanet:addTag("visited")
    landedPlanet:save()
  end
end

function landingEventsTextData(landedPlanet)
  local textData={}

  textData.playername=player.name()
  textData.shipname=player.ship()
  textData.planetname=planet.cur():name()
  textData.sunname=system.cur():name()

  if (landedPlanet.lua.natives) then
    textData.nativesname=landedPlanet.lua.natives.name
  elseif (landedPlanet.lua.settlements.natives) then
    textData.nativesname=landedPlanet.lua.settlements.natives.name
  end

  return textData
end

function landingEventsIsSystemCivilized(sys)

  local presences=sys:presences()

  for k,v in pairs(presences) do
    if k~="Barbarians" and k~="Natives" then
      return true
    end
  end

  return false
end