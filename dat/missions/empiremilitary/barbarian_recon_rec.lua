--[[
   Recurring version of barbarian recon
--]]

include "dat/missions/templates/recon.lua"
include "dat/missions/supportfiles/barbarians.lua"


-- Whether mission starts in bar (if false, it starts in computer)
mission_bar=false
-- Whether mission ends in bar (if not, it ends in space in start system)
mission_return_to_bar=false

computer_title  = "NAVY: Investigate barbarians in system ${mainTargetSystem}"

-- Mission details

misn_title  = "Investigate Barbarian activity."
misn_desc   = "Investigate barbarians in systems ${mainTargetSystem}, ${targetSystem2} and ${targetSystem3}"

-- Text if mission ends in space in starting system.
space_success_text = "As you enter system ${startSystem}, your computer sends the result of your scouting mission to ${startPlanet}. Your payment of ${credits} cr is immediately wired."

-- Messages
msg[1]   = "System %s investigated."
msg[2]   = "All systems investigated. Return to ${startPlanet}."
osd_msg[1] = "Investigate the targeted systems."
osd_msg[2] = "Return to ${startPlanet}."



function create ()
   -- Get target system
   main_target_planet,main_target_system = get_barbarian_planet( system.cur() )

   -- Handle edge cases where no suitable neighbours exist.
   if not main_target_system then
      misn.finish(false)
   end

   local target_sys_2 = get_adjacent_barbarian_system(main_target_system)
   local target_sys_3 = get_adjacent_barbarian_system(main_target_system,{target_sys_2})

   if not target_sys_2 or not target_sys_3 then
      misn.finish(false)
   end

   target_systems={main_target_system,target_sys_2,target_sys_3}

   -- Get credits
   credits  = rnd.rnd(30,40) * 1000

   template_create ()
end

--[[
Mission entry point.
--]]
function accept ()
  template_accept()
end

-- Player won, gives rewards.
function give_rewards ()
   -- Give factions
   faction.modPlayerSingle( G.EMPIRE, 3 )
   faction.modPlayerSingle( G.BARBARIANS, -1 )

   template_give_rewards()
end
