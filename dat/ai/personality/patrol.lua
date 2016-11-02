include "dat/ai/include/formation_ai.lua"

-- Default task to run when idle
function idle ()

  -- if not mem.boss then -- Pilot nover had a boss
  --     mem.boss, radius, angle = ai.getBoss(false)

  --     if radius then
  --       mem.angle = angle
  --       mem.radius = radius
  --     end
  --  end

  --  -- If the boss exists, follow him
  --  if mem.boss and mem.boss:exists() then
  --     if not mem.radius then
  --       mem.angle = rnd.rnd( 0, 360 )
  --       mem.radius = rnd.rnd( 150, 200 )
  --     end
  --     ai.pushtask("formation",mem.boss)
  --     return
  --   end

  if mem.is_fleet_leader == true and not mem.fleet then
      create_fleet()
  elseif mem.formation_leader_id ~= nil then
    ai.pushtask("formation")
    return
  end

    -- Otherwise, normal patrol behaviour
   if mem.loiter == nil then mem.loiter = 3 end
   if mem.loiter == 0 then -- Try to leave.
       local planet = ai.landplanet( mem.land_friendly )
       -- planet must exist
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
   else -- Stay. Have a beer.
      sysrad = rnd.rnd() * system.cur():radius()
      angle = rnd.rnd() * 2 * math.pi
      ai.pushtask("__goto_nobrake", vec2.new(math.cos(angle) * sysrad, math.sin(angle) * sysrad))
   end
   mem.loiter = mem.loiter - 1
end

-- Settings
mem.land_friendly = true -- Land on only friendly by default