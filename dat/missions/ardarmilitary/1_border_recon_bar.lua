
include "dat/missions/templates/recon.lua"
include "dat/missions/supportfiles/barbarians.lua"
include "dat/missions/ardarmilitary/common.lua"


-- Whether mission starts in bar (if false, it starts in computer)
mission_bar=true
   mission_return_to_bar=false
   mission_return_to_planet=true


-- Mission details
misn_title  = "Survey Imperial Systems."
misn_desc   = "Survey the Imperial systems of ${mainTargetSystem}, ${targetSystem2} and ${targetSystem3} for the Roidhunate."

-- Text if mission from bar
bar_desc   = "A young Ardar officer, looking very annoyed."
bar_accept_title = "A Job Proposal"
bar_accept_text  = [[You are settled in front of your beer when you notice an angry-looking Ardar officer drinking telloch in larger gulps than usual. Suddenly returning your stare, he heads toward you. "well, well, a human pilot. I had not seen you around before. You look like the kind that could cause trouble. If you're looking for that go back to human space. The laws of the Roidhunate are harsh, and we actually apply them. Understood?", he lectures you in harshly accented Terran. You've heard that kind of speeches from many Ardars before, and he's drunk too much to be convincing in the stern-Ardar-officer role. 

"If you are looking for work however I can always use a new auxiliary. Not for anything critical of course, just routine surveillance. Though if you prove reliable there might be more interesting missions later. So?"]]


bar_accept_title_extra = "Routine Surveillance"
bar_accept_text_extra = [["The job is simple: survey a few systems outside the Roidhunate. I'll send you the coordinates. No action necessary - if you meet barbarians or other nuisances just report them to HQ and real ships will take care of it. Pay is ${credits} credits. Non-negotiable. And hurry." he explains, voice slightly slurred in a very human manner.]]

-- Text if mission ends on starting bar
bar_success_title = "Job Well Done"
bar_success_text = [[You return to ${startPlanet} and report to the Ardar base. The same officer is there to greet you, sober this time. "${ardarRank} ${playerName}, I've seen preliminary reports of your data. It seems like you've done a proper job. It's good to see a reliable human, especially working for us! I've added you to our list of auxiliaries, class I. Check the mission network for other jobs of that kind.", he tells you, less dismissively than the previous time.

"Keep it up and we'll offer you more interesting work. Dismissed, ${ardarRank}."]]

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

   -- Spaceport bar stuff
   misn.setNPC( "Young Ardar Officer", "ardar/military_m1" )


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
   faction.modPlayerSingle( G.ROIDHUNATE, 3)

   player.addOutfit("Ardarshir Auxiliary, Class I",1)

   template_give_rewards()
end