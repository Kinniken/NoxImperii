--[[

   Pirate Bounty

   Randomly appearing bar mission to kill a unique pirate. Heavily based on bobbens's Pirate Bounty mission for Naev

   Authors: Kinniken, bobbens

--]]

include "dat/missions/templates/ship_kill.lua"
include "pilot/pilots_empire.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include("pilot/pirate.lua")

osd_msg[2] = "Kill the scout"

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   mission_land=true

   mission_return_to_bar=false
   mission_return_to_planet=true


   -- Mission details
   misn_title  = "Eliminate ${targetShipName}"
   misn_desc   = [[Eliminate the Imperial scout ship in ${targetSystem}.

Last seen in system ${targetSystem}.]]

   start_title = "A Question of Loyalty"
   start_text  = [[The ${shipName} has just landed on ${startPlanet} when you are summoned in the office of the base commander. "${ardarRank} ${playerName}", he starts. "You have proven reliable and loyal to the Roidhunate. We believe you can be trusted to a more... delicate mission. Especially for a human pilot. Can the Roidhun count on your loyalty?"]]

   accept_title = "Licence to Kill"
   accept_text = [["Very well. Know that we shall reward your wise choice. 

As you may know both the Empire and us often survey the border zone between our respective spheres. Officially the zone is neutral and both our navies may operate patrols in it. However we find it advantageous to discourage the Empire from delving too deep in it. It is good that once in awhile one of their patrol do not make it home. Since the Ardar Navy cannot do this without triggering a war, it is up to auxiliaries like you. 

Your first mission will take you to the ${targetSystem} system. The Imperials keep a frigate in it on a regular basis. Destroy it and return here for debriefing.". A slap of his tail and you are dismissed.]]

   bar_success_title = "For the Roidhun!"
   bar_success_text = [[You return with proof of the destruction of the Imperial craft. The base commander reviews it with evident satisfaction. "You have made an excellent choice, ${ardarRank} ${playerName}.", he exclaims with unusual enthusiasm for an Ardar. "Here is a bonus of ${credits} credits. And I believe you have earned a raise to Auxiliary Class III.". He serves the two of you small glasses of telloch.

"For the Roidhun!"]]


function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = empire_createComet()
   target_ship_name="Imperial Scout"

   -- Get target system
   target_system = get_empty_sys( system.cur(),3,7,function(s) return s:presence(faction.get(G.EMPIRE))>10 and s:presence(faction.get(G.EMPIRE))<50 end )

   if (not target_system) then
      misn.finish(false)
   end

   -- Get credits
   credits  = rnd.rnd(20,50) * 10000

   template_create()
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
   faction.modPlayerSingle( G.ROIDHUNATE, 5 )
   faction.modPlayerSingle( G.EMPIRE, -2 )

   player.addOutfit("Ardarshir Auxiliary, Class III",1)
   
   template_give_rewards()
end

