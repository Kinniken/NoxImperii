   include "numstring.lua"
   include "dat/scripts/general_helper.lua"
   include "jumpdist.lua"
   include('universe/objects/class_planets.lua')

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


function get_native_planet( around_sys,minDist,maxDist,validator)
   local planets = {}
    getsysatdistance(around_sys, minDist,maxDist,
        function(s)
            for i, v in ipairs(s:planets()) do
              if v:faction()==faction.get(G.NATIVES) then
                  if validator==nil or validator(v) then

                      local luaplanet=planet_class.load(v)

                      if luaplanet.lua.natives ~= nil then
                        planets[#planets + 1] = {v, s}
                      end
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

function get_adjacent_system( sys, sysTaken, factionName )
   local systems=getsysatdistance(sys, 1, 1,
        function(s)
            if not s:presences()[factionName] then
               return false
            end
            local taken=false
            if sysTaken then               
               for _,k in pairs(sysTaken) do
                  if k==s then
                     taken=true
                  end
               end
            end
           return not taken
        end)

   if #systems == nil then
      return sys
   else
      return systems[ rnd.rnd(1,#systems) ]
   end
end


function get_empty_sys( around_sys, min, max,validator)
  local systems=getsysatdistance(around_sys, min, max,
    function(s)
        if validator~=nil and (not validator(s)) then
          return false
        end
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


function emp_getRank()
   if player.numOutfit( "Reserve Admiral" )>0 then
      return "Admiral"
    elseif player.numOutfit( "Reserve Colonel" )>0 then
      return "Colonel"
   elseif player.numOutfit( "Reserve Major" )>0 then
      return "Major"
   elseif player.numOutfit( "Reserve Lieutenant" )>0 then
      return "Lieutenant"
   elseif player.numOutfit( "Reserve Ensign" )>0 then
      return "Ensign"
  else
    return "Captain"
  end
end


function ardar_getRank()
if player.numOutfit( "Ardarshir Ally" )>0 then
      return "Ally"
    elseif player.numOutfit( "Ardarshir Auxiliary, Honourable" )>0 then
      return "Honourable Auxiliary"
   elseif player.numOutfit( "Ardarshir Auxiliary, Class III" )>0 then
      return "Auxiliary"
   elseif player.numOutfit( "Ardarshir Auxiliary, Class II" )>0 then
      return "Auxiliary"
   elseif player.numOutfit( "Ardarshir Auxiliary, Class I" )>0 then
      return "Auxiliary"
  else
    return "Captain"
  end
end