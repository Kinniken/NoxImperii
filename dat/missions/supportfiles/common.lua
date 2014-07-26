   include "numstring.lua"
   include "universe/generate_helper.lua"
   include "jumpdist.lua"

-- Gets a planet of a given faction
function get_faction_planet( sys,factionName,minDist,maxDist)
   local planets = {}
    getsysatdistance(sys, minDist,maxDist,
        function(s)
            for i, v in ipairs(s:planets()) do
                if v:faction() == faction.get(factionName) then
                    planets[#planets + 1] = {v, s}
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

function get_empty_sys( sys, min, max)
  local systems=getsysatdistance(system.cur(), min, max,
    function(s)
        for _,p in pairs(s:planets()) do
          if p:faction() and p:faction()~=faction.get("Natives") then
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