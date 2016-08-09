--[[

   Pirate Bounty

   Randomly appearing bar mission to kill a unique pirate. Heavily based on bobbens's Pirate Bounty mission for Naev

   Authors: Kinniken, bobbens

--]]

include "numstring.lua"
include "dat/missions/templates/ship_kill.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include("pilot/pilots_pirates.lua")
include('universe/generate_nameGenerator.lua')

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   mission_return_to_bar=false

   mission_return_to_bar=false
   mission_return_to_planet=true

   computer_title  = "ROIDHUNATE: Eliminate ${targetShipName}"

   -- Mission details
   misn_title  = "Eliminate ${targetShipName}"
   misn_desc   = [[Eliminate the Pirate leader in ${targetSystem} system.]]


   bar_success_title = "Culling the Flock"
   bar_success_text = [[You land on ${startPlanet} with proof of the destruction of ${targetShipName}'s ship. The officer that receives you has the mix of sadness and anger on his face you have come to recognise. "Such a promising young Ardar too! He would have made a fine officer if he had not gone astray. Thank you for your services, ${ardarRank}."]]


function create ()

   target_ship_name = "Lord "..nameGenerator.generateNameArdarshir()

   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = pirates_createMerkhrioch()

   -- Get target system
   target_system = get_empty_sys( system.cur(),3,7,function(s) return s:presence(faction.get(G.ROIDHUNATE))>10 and s:presence(faction.get(G.ROIDHUNATE))<50  and s:presence(faction.get(G.EMPIRE))<5 end )

   if (not target_system) then
      misn.finish(false)
   end

   -- Get credits
   credits  = rnd.rnd(150,300) * 10000

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
   
   template_give_rewards()
end

function get_escorts()
   local enemies={}

   local enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = pirates_createGeldoch()
   enemie.ship_name=target_ship_name.."'s Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = pirates_createGeldoch()
   enemie.ship_name=target_ship_name.."'s Fleet"
   enemies[#enemies+1] = enemie

   return enemies
end