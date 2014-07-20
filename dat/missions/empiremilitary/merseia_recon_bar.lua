--[[

   Unique version of Merseia recon

--]]

include "dat/missions/templates/recon.lua"
include "dat/missions/supportfiles/merseia.lua"


-- Whether mission starts in bar (if false, it starts in computer)
mission_bar=true
-- Whether mission ends in bar (if not, it ends in space in start system)
mission_return_to_bar=false


-- Mission details
misn_title  = "Investigate Merseian systems"
misn_desc = "Perform a recon in Merseian systems ${targetSystem1}, ${targetSystem2}, ${targetSystem3} and ${targetSystem4}."

-- Text if mission from bar
bar_desc   = "A short, squat humanoid is sitting in a corner of the bar, looking at you very intently."
bar_accept_title = "Spaceport Bar"
bar_accept_text  = [[As you look back at him, he gestures in your direction. His face is mostly humanoid, but with a strange rigid skin that looks like leather. His eyes are small and very deep-sited, and his expression is bland.

"Captain ${playerName}. I heard from you from a good friend. Your services to the Navy in the Fringe have proven valuable." he starts in a deep voice, below that of any human. "I work for the Intelligence Service.". Before you have time to express surprise, you realize he has beamed his credentials to your com device. Either he is the real thing or he is very, very good.

"We are in constant need of intelligence on the Roidhunate. Some of that is very targeted, secret gathering of information for which we use internal resources. But we also need regular updates simply on civilian and military activities in various systems. For this we generally use traders like you. Would you be interested?"]]
bar_accept_text_extra = [["The mission is nothing complex. We just need you to fly through the following systems: ${targetSystem1}, ${targetSystem2}, ${targetSystem3} and ${targetSystem4}. Come back to this system and beam back the results."]]

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
   _,main_target_system = get_merseia_system( cursys )

   -- Handle edge cases where no suitable neighbours exist.
   if not main_target_system then
      misn.finish(false)
   end

   local _,target_sys_2 = get_merseia_system(cursys)
   local _,target_sys_3 = get_merseia_system(cursys,{target_sys_2})
   local _,target_sys_4 = get_merseia_system(cursys,{target_sys_2,target_sys_3})

   if not target_sys_4 then
      misn.finish(false)
   end

   target_systems={main_target_system,target_sys_2,target_sys_3,target_sys_4}

   -- Get credits
   credits  = rnd.rnd(20,40) * 1000

   -- Spaceport bar stuff
   misn.setNPC( "Intelligence Officer", "empire/empire1" )
   

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
   faction.modPlayerSingle( "Empire of Terra", 1 )

   template_give_rewards()
end