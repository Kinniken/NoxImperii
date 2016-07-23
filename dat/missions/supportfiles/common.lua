   include "numstring.lua"
   include "dat/scripts/general_helper.lua"
   include "jumpdist.lua"

-- Gets a planet of a given faction
function get_faction_planet( around_sys,factionName,minDist,maxDist,validator)
   local planets = {}
    getsysatdistance(around_sys, minDist,maxDist,
        function(s)
            for i, v in ipairs(s:planets()) do
                if v:faction() == faction.get(factionName) then
                  if validator==nil or validator(v) then
                      planets[#planets + 1] = {v, s}
                  end
                end
           end
           return true
        end)

    if (#planets==0) then
      return nil,nil
    end

    local id=math.random(#planets)

    return planets[id][1],planets[id][2]
end

function get_empty_sys( around_sys, min, max)
  local systems=getsysatdistance(around_sys, min, max,
    function(s)
        for _,p in pairs(s:planets()) do
          if p:faction() and p:faction()~=faction.get(G.NATIVES) then
            return false
          end
        end
        return true
    end)

   if #systems == 0 then
      return nil
   else
      return systems[ rnd.rnd(1,#systems) ]
   end
end

function has_system_faction_planet(sys,factionName)
  for _,p in pairs(sys:planets()) do
    if p:faction()==faction.get(factionName) then
      return true
    end
  end

  return false
end

function generate_ship(target_ship_name, shipFunc, posCentre,minDistance,maxDistance,aggressive, factionOverride)

  local target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = shipFunc()

  if factionOverride then
    target_ship_faction = factionOverride
  end

  local pos = gh.randomPosAround(posCentre,minDistance,maxDistance)

  -- Create the badass enemy
  p     = pilot.addRaw( target_ship, target_ship_ai, pos, target_ship_faction )

  local target_ship_pilot   = p[1]
  target_ship_pilot:rename(target_ship_name)
  target_ship_pilot:setVisplayer(true)
  target_ship_pilot:setHilight(true)

  if (aggressive) then
    target_ship_pilot:setHostile()
  end

  target_ship_pilot:rmOutfit("all") -- Start naked
  pilot_outfitAddSet( target_ship_pilot, target_ship_outfits )

  return target_ship_pilot
end