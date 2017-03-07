include "dat/ai/include/formation_ai.lua"
include("dat/ai/include/chatter.lua")

-- Default task to run when idle
function idle ()

  chatter(system.cur(),ai.pilot())

   if mem.is_fleet_leader == true and not mem.fleet then
      create_fleet(ai.pilot())
  elseif mem.formation_leader_id ~= nil then
      ai.pushtask("formation")
      return
  end

-- The pilot has no boss, he chooses his target
  local planet = ai.landplanet( mem.land_friendly )
   -- planet must exist.
   if planet == nil or mem.land_planet == false then
      ai.settimer(0, rnd.int(1000, 3000))
      ai.pushtask("enterdelay")
   else
      mem.land = planet:pos()
      ai.pushtask("hyperspace")
      if not mem.tookoff then
         ai.pushtask("land")
      end
   end
end
