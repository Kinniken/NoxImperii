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

   mission_bar=false
   mission_return_to_bar=false

   mission_return_to_bar=false
   mission_return_to_planet=true

   computer_title  = "ROIDHUNATE: Strike Imperial Fleet"


   -- Mission details
   misn_title  = "Destroy Imperial Fleet"
   misn_desc   = [[Destroy the Imperial fleet in the ${targetSystem} system.]]

   bar_success_title = "Nox Imperii"
   bar_success_text = [[You land once more on an Ardar spaceport to great acclaim, the crowd cheering the defeat of the Imperial Navy and the seemingly unstoppable rise of the Roidhunate.

That a human lead this effort seems to make the crowd only wilder. "${playerName}! ${playerName}! ${playerName}!", they hiss as they slap their tails in rhythm.]]


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
   faction.modPlayerSingle( G.ROIDHUNATE, 5 )

   planet=planet_class.load(start_planet)
   planet:addHistory("Ardar fleets based here struck a mighty blow against the Empire in the "..target_system:name().." system.")

   if planet.lua.settlements.ardars then
      planet.lua.settlements.ardars.military=planet.lua.settlements.ardars.military+0.1
   end
   generatePlanetServices(planet)
   planet:save()

   local bop=var.peek("universe_balanceofpower")
   bop=bop-2
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