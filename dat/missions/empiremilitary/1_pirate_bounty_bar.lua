--[[

   Pirate Bounty

   Randomly appearing bar mission to kill a unique pirate. Heavily based on bobbens's Pirate Bounty mission for Naev

   Authors: Kinniken, bobbens

--]]

include "dat/missions/templates/ship_kill.lua"
include "dat/missions/supportfiles/pirates.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include("pilot/pirate.lua")

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=true
   -- Whether mission ends in bar (if not, it ends in space in start system)
   mission_return_to_bar=true


   -- Mission details
   misn_title  = "Eliminate ${targetShipName}"
   misn_desc   = [[ 
   Pirate ship ${targetShipName} needs 'investigation'.
   Last seen in system ${targetSystem}.]]


   -- Bar information
   bar_desc   = "An Imperial Lieutenant is drinking scotch, looking glum."
   bar_accept_title = "Spaceport Bar"
   bar_accept_text  = [[You sit down next to him, order a drink for yourself and ask him what he is so gloomy about. He seems the friendly, eager type.

"Have you heard of the pirate ship ${targetShipName}?" he starts explaining. "He's been targeting local trade for months now. I finally located him just days ago - in system ${targetSystem}. But I have orders from above to 'wait for strategic analysis'. You know what this means..."
"Whoever owns that ship has political backing?", you suggest.
"Indeed. Close to the governor. An open secret here. So he's going to continue terrorizing traders and depressing the local economy. Rotten system! If only the Empire knew!"
"I doubt he would care. As long as a cut of the benefices trickle upwards."
"Let's say I never heard that... Barman, an other drink!"

The officer seems genuinely upset. He must be new. Still, you wonder if you could do something... for a small fee?]]
   bar_accept_text_extra = [["Tell me, would you have some extra money in your unit's budget? I could take care of this for you... unofficially..."]]

   bar_success_text = [[Lieutenant Palacios waves as you enter the bar. "I've heard for ${targetShipName} - well done! Of course, the crew should have been captured and tried in court... but this is still justice of sort. And yes, I did manage to get you your ${credits} credits. Never thought I'd be one to fiddle my own unit's accounts. Anyway! Cheers to you, captain! What an officer you would have made! Speaking of which, you're now a Reserve Ensign - you deserve it. I might mention your services to other dedicated young officers... quietly, of course. Check your messages whenever you land!"

You check the transaction cleared, thank the officer and leave the bar.]]


function create ()

   if (not system.cur():presences()[G.PIRATES]) or system.cur():presences()[G.PIRATES] <50 then
      misn.finish(false)
   end

   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship_name, target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = pir_generate()

   -- Get target system
   target_system = get_suitable_system( system.cur() )

   -- Get credits
   credits  = rnd.rnd(10,30) * 10000

   -- Spaceport bar stuff
   misn.setNPC( "Lieutenant Palacios", "empire/unique/czesc" )
   misn.setDesc( bar_desc )

   template_create()
end


--[[
Mission entry point.
--]]
function accept ()
   template_accept()
end

-- Gets a new suitable system
function get_suitable_system( sys )
   local newsys=get_nearby_pirate_system(sys)
   if newsys then
      return newsys
   else
      return sys
   end
end

-- Player won, gives rewards.
function give_rewards ()

   -- Give factions
   faction.modPlayerSingle( G.EMPIRE, 1 )
   faction.modPlayerSingle( G.PIRATES, -5 )

   player.addOutfit("Reserve Ensign",1)
   
   local planet=planet_class.load(start_planet)

   if (planet.lua.settlements.humans) then
      planet.lua.settlements.humans.services=planet.lua.settlements.humans.services*1.2
   end
   if (planet.lua.settlements.natives) then
      planet.lua.settlements.natives.services=planet.lua.settlements.natives.services*1.2
   end
   planet:addHistory("The killing of notorious pirate "..target_ship_name.." has boosted local trade.")
   generatePlanetServices(planet)
   planet:save()

   template_give_rewards()
end

