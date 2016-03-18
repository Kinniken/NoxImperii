--[[

   Rec version of Ardarshir recon

--]]

include "dat/missions/templates/recon.lua"
include "dat/missions/supportfiles/ardarshir.lua"


-- Whether mission starts in bar (if false, it starts in computer)
mission_bar=false
-- Whether mission ends in bar (if not, it ends in space in start system)
mission_return_to_bar=false

computer_title ="NAVY: Investigate Ardar systems"

-- Mission details
misn_title  = "Investigate Ardar systems"
misn_desc = "Perform a recon in Ardar systems ${targetSystem1}, ${targetSystem2}, ${targetSystem3} and ${targetSystem4}."

  -- Text if mission ends in space in starting system.
space_success_text = "You enter system ${startSystem} and transfer the data to the Navy base. Your payment of ${credits} cr is immediately wired."

-- Messages
msg[1]   = "System %s investigated."
msg[2]   = "All systems investigated. Return to ${startPlanet}."
osd_msg[1] = "Investigate the targeted systems."
osd_msg[2] = "Return to ${startPlanet}."



function create ()
  local cursys=system.cur()

   -- Get target system
   _,main_target_system = get_ardarshir_system( cursys )

   -- Handle edge cases where no suitable neighbours exist.
   if not main_target_system then
      misn.finish(false)
   end

   local _,target_sys_2 = get_ardarshir_system(cursys)
   local _,target_sys_3 = get_ardarshir_system(cursys,{target_sys_2})
   local _,target_sys_4 = get_ardarshir_system(cursys,{target_sys_2,target_sys_3})

   if not target_sys_4 then
      misn.finish(false)
   end

   target_systems={main_target_system,target_sys_2,target_sys_3,target_sys_4}

   -- Get credits
   credits  = rnd.rnd(20,40) * 1000  

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
   faction.modPlayerSingle( G.EMPIRE, 1 )

   template_give_rewards()
end