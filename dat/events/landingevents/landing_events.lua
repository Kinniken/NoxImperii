
include('dat/scripts/general_helper.lua')
include('universe/objects/class_planets.lua')

landing_events={}  --shared public interface

include "dat/events/landingevents/native_events.lua"
include "dat/events/landingevents/lifeforms_events.lua"
include "dat/events/landingevents/geologic_events.lua"

CREW_ENG="Engineer"

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
    if k~=G.BARBARIANS and k~=G.NATIVES then
      return true
    end
  end

  return false
end

--return value multiplied by ratio of ship price to starting ship price
--goes from 1 to 30 for the most expensive ships (+/- 20M)
function adjustForShipPrice(value)

  local shipPrice,b=player.pilot():ship():price()

  return value*(0.75+(shipPrice/150000)/4)
end

function adjustForCrewLevel(value,position)

  local level,name,gender,type,active,status=player.crewByPosition(position)

  if level==0 then--no crew member
    return value
  elseif level==1 then
    return value*2
  elseif level==2 then
    return value*4
  elseif level==3 then
    return value*6
  else
    return value*10
  end
end

function getCrewLevelAdj(level)
  if level<2 then--normally 1 only, 0 makes no sense
    return "passable"
  elseif level==2 then
    return "adequate"
  elseif level==3 then
    return "good"
  else
    return "fantastic"
  end
end

function getRandomCrewType()
  local crewTypes=player.crews()

  if (#crewTypes==0) then
    return nil
  end

  return gh.randomObject(crewTypes)
end

function getGenderPossessive(gender)
  if gender==1 then
    return "his"
  elseif gender==2 then
    return "her"
  else
    return "its"
  end
end

function getGenderPronoun(gender)
  if gender==1 then
    return "he"
  elseif gender==2 then
    return "she"
  else
    return "it"
  end
end

function tryWoundingCrewMember()
  local randomCrewType=getRandomCrewType()

  if (randomCrewType~=nil) then
    local level,name,gender,type,active,status=player.crew(randomCrewType)

    if status==1 then--healthy

      player.setCrewStatus(randomCrewType,2)

      return level,name,gender,type,active,status
    end         
  end

  return nil
end

