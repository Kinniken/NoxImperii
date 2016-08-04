
include "dat/missions/templates/recon.lua"
include "dat/missions/supportfiles/barbarians.lua"
include "dat/missions/ardarmilitary/common.lua"


-- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   mission_return_to_bar=false

computer_title  = "ROIDHUNATE: Survey Imperial forces around ${mainTargetSystem}"

-- Mission details
misn_title  = "Survey Imperial Systems."
misn_desc   = "Survey the Imperial systems of ${mainTargetSystem}, ${targetSystem2} and ${targetSystem3} for the Roidhunate."

space_success_title = "Recon Completed"
space_success_text = "You beam up your results to the Ardar command on ${startPlanet}. Your payment of ${credits} cr is immediately wired."

-- Messages
msg[1]   = "System %s investigated."
msg[2]   = "All systems investigated. Return to ${startPlanet}."
osd_msg[1] = "Investigate the targeted systems."
osd_msg[2] = "Return to ${startPlanet}."



function create ()
   -- Get target system
   main_target_planet,main_target_system = get_faction_planet( system.cur(), G.EMPIRE, 2,8)

   -- Handle edge cases where no suitable neighbours exist.
   if not main_target_system then
      misn.finish(false)
   end

   local target_sys_2 = get_adjacent_system(main_target_system, {}, G.EMPIRE)
   local target_sys_3 = get_adjacent_system(main_target_system,{target_sys_2}, G.EMPIRE)

   if not target_sys_2 or not target_sys_3 then
      misn.finish(false)
   end

   target_systems={main_target_system,target_sys_2,target_sys_3}
   target_systems["__save"] = true

   -- Get credits
   credits  = rnd.rnd(5,15) * 10000

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
   faction.modPlayerSingle( G.ROIDHUNATE, 1)

   template_give_rewards()
end