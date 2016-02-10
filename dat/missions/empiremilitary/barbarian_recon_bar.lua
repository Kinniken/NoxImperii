--[[

   Unique version of barbarian recon

--]]

include "dat/missions/templates/recon.lua"
include "dat/missions/supportfiles/barbarians.lua"


-- Whether mission starts in bar (if false, it starts in computer)
mission_bar=true
-- Whether mission ends in bar (if not, it ends in space in start system)
mission_return_to_bar=true


-- Mission details
misn_title  = "Investigate Barbarian activity."
misn_desc   = "Investigate barbarians in systems ${mainTargetSystem}, ${targetSystem2} and ${targetSystem3}"

-- Text if mission from bar
bar_desc   = "A Navy Colonel is discussing with his ensign."
bar_accept_title = "Spaceport Bar"
bar_accept_text  = [[As you get closer, you overhear the Colonel and his ensign. The Colonel is a stocky but well-built man, whose ancestors seem to have been primarily East Asian. His name tag identifies him as Colonel Zhongzheng. His ensign is a non-human - a tall, thin humanoid who seem to be from a low gravity world and towers above the officer. They are discussing increased barbarian activity in fringe systems.

   "We need more information, simple as that. We are blind in that sector." the Colonel is telling his ensign.
   "But Sir, our last patrols were disaster. We lost three Comets in five missions!" replies his ensign.
   "It's clear those savages knew our men were coming. Damn them. Nothing we do is secret!"
   "You can't keep the men from speaking, Colonel... Humans drink and say anything to anyone."
   "Undisciplined fools! When my grandfather was Admiral the Navy was run differently."

   Clearly they could use some help. And you could do with some credits, though patrolling in Barbarian space won't be much fun. Approach them?]]
bar_accept_text_extra = [["Excellent! Nobody will notice a two-bit Captain heading for that direction." states the Colonel, looking both relieved and annoyed to be accepting help from outside the Navy. "Try and survive to bring data back."

   "We are mostly worried about the Barbarian outpost in system ${mainTargetSystem} and their activities in nearby systems ${targetSystem2} and ${targetSystem3}. Your help would be precious, Captain!" adds the ensign, with what must be enthusiasm on his pale face.]]

-- Text if mission ends on starting bar
bar_success_title = "Spaceport Bar"
bar_success_text = [[The Colonel waits for you to come close before handing the credit chip.

   "Well, well, even mercenaries can be efficient. Your data looks usable. Here are your credits." he tells you sharply.

   "We might have other missions of that kind for you, Captain.", the ensign adds. "But this time we'll send you a direct message. This bar is too public."]]

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
   credits  = rnd.rnd(50,90) * 1000

   -- Spaceport bar stuff
   misn.setNPC( "Colonel Zhongzheng", "empire/unique/soldner" )
   

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
   faction.modPlayerSingle( "Empire of Terra", 5 )
   faction.modPlayerSingle( "Barbarians", -1 )

   template_give_rewards()
end