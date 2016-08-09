--[[

   Pirate Bounty

   Randomly appearing bar mission to kill a unique pirate. Heavily based on bobbens's Pirate Bounty mission for Naev

   Authors: Kinniken, bobbens

--]]

include "numstring.lua"
include "dat/missions/templates/ship_kill.lua"
include "pilot/pilots_empire.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include("pilot/pirate.lua")

osd_msg[2] = "Kill the scout"

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   mission_return_to_bar=false

   mission_return_to_bar=false
   mission_return_to_planet=true

   computer_title  = "ROIDHUNATE: Eliminate scout in ${targetSystem}"

   -- Mission details
   misn_title  = "Eliminate ${targetShipName}"
   misn_desc   = [[Eliminate the Imperial scout ship in ${targetSystem}.

Last seen in system ${targetSystem}.]]


   bar_success_title = "One More Notch"
   bar_success_text = [[You arrive on ${startPlanet} to report your new kill. The Ardar officer on duty grins when checking your ship's records and hands you over your ${credits} credits.]]


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
   faction.modPlayerSingle( G.ROIDHUNATE, 3 )
   faction.modPlayerSingle( G.EMPIRE, -1 )
   
   template_give_rewards()
end

