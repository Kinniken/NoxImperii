--[[

   Pirate Bounty

   Randomly appearing bar mission to kill a unique pirate. Heavily based on bobbens's Pirate Bounty mission for Naev

   Authors: Kinniken, bobbens

--]]

include "dat/missions/templates/ship_kill.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include("pilot/pilots_pirates.lua")
include('universe/generate_nameGenerator.lua')

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   mission_land=true

   mission_return_to_bar=false
   mission_return_to_planet=true


   -- Mission details
   misn_title  = "Eliminate ${targetShipName}"
   misn_desc   = [[Eliminate the Pirate leader in ${targetSystem} system.]]

   start_title = "Black Sheep of the Family"
   start_text  = [[You get an urgent summon to the base's officer as soon as you land; he is waiting for you, looking troubled. "${ardarRank} ${playerName}, the Roidhunate has need of your services once again. There has been a rise in piracy around ${targetSystem} system. It is embarrassing for the Roidhunate, but we believe their leader to be an illegitimate son of a family close to the Roidhun himself... For him to be killed by the Ardar Navy would be scandalous. For him to be arrested would be much worse.". He pauses, but you already know what he will say. 

"It would be best if his ship was destroyed by someone else. Good hunting, ${ardarRank}."]]

accept_title = "A Dirty Job"
   accept_text = [[You head back to the ${shipName} and get your armament in order. Time to hunt!]]

   bar_success_title = "A Scandal Averted"
   bar_success_text = [[You can see intense relief on the guarded face of the Ardar officer as you debrief. "${ardarRank} ${playerName}, the Roidhunate is very much in your debt over this. Take this reward - those ${credits} credits are well-deserved. And know that the Roidhun in person authorised me to raise you to the status of Honourable Auxiliary, a rank few humans have reached.". He stops for a moment, worry creeping back on his scaly face.

"Also... These cases are more common than the public knows. It seems many young Ardar nobles seek other paths than the Navy or Imperial Service, including dishonourable ones. There might be more such missions in store for you."]]


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
   faction.modPlayerSingle( G.ROIDHUNATE, 10 )

   player.addOutfit("Ardarshir Auxiliary, Honourable",1)
   
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