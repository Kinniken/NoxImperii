--[[

   Pirate Bounty

   Randomly appearing bar mission to kill a unique pirate. Heavily based on bobbens's Pirate Bounty mission for Naev

   Authors: Kinniken, bobbens

--]]

include "numstring.lua"
include "dat/missions/templates/ship_kill.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include("pilot/pilots_empire.lua")
include("pilot/pilots_ardarshir.lua")
include('universe/generate_nameGenerator.lua')

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   mission_land=true

   mission_return_to_bar=false
   mission_return_to_planet=true


   -- Mission details
   misn_title  = "Destroy Imperial Fleet"
   misn_desc   = [[Destroy the Imperial fleet in the ${targetSystem} system.]]

   start_title = "Escalating Conflict"
   start_text  = [[As you land, you are summoned once again by the commanding officer. He is not alone in his bare office; standing next to him is Lord Roch in person, cousin of the Roidhun and Lord Admiral of the Ardar Navy.

"So here is that human pilot that has served us so well." he starts, under the respectful gaze of the base commander. "We have followed your progress closely and believe you are the right man for a new phase of our old conflict with Terra. Your rewards will be great if you serve us well once again. I can even promise you something no human had ever earned - the status of Ally, not simply Auxiliary.", he tells you, his small eyes peering intently at you.

"We believe it is time to take our conflict with the Empire to a new stage. We intend to hit anything they send in the border zone below fleet-size with auxiliary forces. They'll react by regrouping their ships even more - and we'll gain de facto control of even larger space. The first strike will be on their forces of system ${targetSystem}. You will lead our forces in this battle; the other ships will meet you there. Expect the Empire to field at least a cruiser. Good hunting, ${ardarRank} ${playerName}.". You can hear their excitement in the strength with which they smash their tails to dismiss you.]]

   bar_success_title = "To the Victor, the Spoils"
   bar_success_text = [[When you land on ${startPlanet}, the crew of the entire base is lined up in the spaceport, slapping their tails as hard as they can, shaking the concrete floor. "${playerName}! ${playerName}! ${playerName}!" they hiss, excited like you've never seen an Ardar crowd be.

Lord Roch in person is there to welcome you. "Ally ${playerName}! It is an honour to salute you. Though it is a sharp sent to taste that a human pilot has struck such a blow on our behalf. We now recognise you as more than a simple auxiliary. Take those ${credits} credits as a token of our gratitude, Ally of the Roidhunate!". He then bows slightly towards you, a very human gesture you had never seen an Ardar perform.]]


function create ()

   target_ship_name = "Imperial Flagship"

   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = empire_createPlanet()

   -- Get target system
   target_system = get_empty_sys( system.cur(),3,7,function(s) return s:presence(faction.get(G.EMPIRE))>10 and s:presence(faction.get(G.EMPIRE))<50 end )


   if (not target_system) then
      misn.finish(false)
   end

   -- Get credits
   credits  = rnd.rnd(3,5) * 1000000

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
   faction.modPlayerSingle( G.ROIDHUNATE, 15 )

   player.addOutfit("Ardarshir Ally",1)
   
   planet=planet_class.load(start_planet)
   planet:addHistory("Ardar fleets based here struck a mighty blow against the Empire in the "..target_system:name().." system.")

   if planet.lua.settlements.ardars then
      planet.lua.settlements.ardars.military=planet.lua.settlements.ardars.military+0.2
   end
   generatePlanetServices(planet)
   planet:save()

   var.push("roidhunate_missions_5",true)
   local bop=var.peek("universe_balanceofpower")
   bop=bop-10
   var.push("universe_balanceofpower",bop)
   updateUniverseDesc()
   
   template_give_rewards()
end

function get_escorts()
   local enemies={}

   local enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = empire_createContinent()
   enemie.ship_name="Imperial Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = empire_createContinent()
   enemie.ship_name="Imperial Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = empire_createComet()
   enemie.ship_name="Imperial Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = empire_createComet()
   enemie.ship_name="Imperial Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = empire_createComet()
   enemie.ship_name="Imperial Fleet"
   enemies[#enemies+1] = enemie

   return enemies
end


function get_allies()
   local escorts={}

   local escort={}
   escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = ardarshir_createContinent()
   escort.ship_name="Ardar Strike Force"
   escorts[#escorts+1] = escort

   escort={}
   escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = ardarshir_createContinent()
   escort.ship_name="Ardar Strike Force"
   escorts[#escorts+1] = escort

   escort={}
   escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = ardarshir_createComet()
   escort.ship_name="Ardar Strike Force"
   escorts[#escorts+1] = escort

   escort={}
   escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = ardarshir_createComet()
   escort.ship_name="Ardar Strike Force"
   escorts[#escorts+1] = escort

   return escorts
end