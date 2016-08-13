--[[

   barbarian leader assassination

--]]

include "numstring.lua"
include "dat/missions/templates/ship_kill.lua"
include "dat/missions/supportfiles/barbarians.lua"
include "dat/missions/supportfiles/independent_worlds.lua"
include "independent_worlds.lua"

include("pilot/pilots_barbarians.lua")
include("universe/generate_nameGenerator.lua")
include('universe/objects/class_planets.lua')
include "dat/scripts/universe/live/live_universe.lua"
include "pilot/pilots_empire.lua"
include "pilot/pilots_barbarians.lua"

   mission_bar=false
   mission_land=true
   mission_return_to_bar=false
   mission_return_to_planet=true


   -- Mission details
   misn_title  = "Defend ${targetPlanet}"
   misn_desc   = "Protect ${targetPlanet} in ${targetSystem} system from barbarian fleets"

   start_title = "An Imperialist Empire"
   start_text  = [[You land on ${startPlanet} only to be immediately summoned to see the Admiral in charge of the base, a certain Admiral Ali.

"${empireRank} ${playerName}, you come highly recommended by a protege of mine, Colonel Zhongzheng.", he starts, cigar in hand. "The success of the recent policy of pre-emptive strikes against barbarian worlds has been noted in high places, and your name is linked with the policy. I have been put in charge of a more ambitious second stage: attempting to once again shelter key independent worlds from the barbarian menace. It is thought this would in turn lessen the pressure on our own worlds - and eventually lead to greater integration of those wayward planets to the Imperial realm."

He takes a deep puff of his cigar and looks straight at you. "Our first target is ${targetPlanet}, ${targetSystem} system. They have been under heavy attack for months now. Head there and take part in lifting the siege. Hurry."]]



   bar_success_title = "A Navy Career"
   bar_success_text = [[The blockade successfully lifted, you return to ${startPlanet} with the other Imperial ships. A triumph is waiting for you; for two days, you parade in ${startPlanet}'s capital with the Imperial officers.

It is the sector governor in person which pins on your vest a sunburst with the insignia of a Reserve Admiral, the highest rank achievable outside regular duty.

"Take that, dad!", you think as you leave the reception. And you have a brand new cheque of ${credits} credits to spend to celebrate.]]

function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = barbarians_createPlanet()

   target_ship_name = "Fleet Leader"

   -- Get target system
   target_planet,target_system = get_independent_planet( system.cur() )

   target_ship_pos = target_planet:pos()

   -- Get credits
   credits  = rnd.rnd(3,5) * 1000000

   allied_kills_count=true

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
   faction.modPlayerSingle( G.EMPIRE, 10 )
   faction.modPlayerSingle( G.BARBARIANS, -5 )

   player.addOutfit("Reserve Admiral",1)

   local planet=planet_class.load(target_planet)
   planet:addHistory("The destruction by Imperial forces of the barbarian fleets assaulting the world has led to a political and economic recovery.")

   if planet.lua.settlements.humans then
      planet.lua.settlements.humans.stability=planet.lua.settlements.humans.stability+0.2
      planet.lua.settlements.humans.services=planet.lua.settlements.humans.services+0.2
   end
   if planet.lua.settlements.natives then
      planet.lua.settlements.natives.stability=planet.lua.settlements.natives.stability+0.2
      planet.lua.settlements.natives.services=planet.lua.settlements.natives.services+0.2
   end
   generatePlanetServices(planet)
   planet:save()

   planet=planet_class.load(start_planet)
   planet:addHistory("Imperial fleets sailed from here to help defend the independent world of "..target_planet:name()..", to general acclaim.")

   if planet.lua.settlements.humans then
      planet.lua.settlements.humans.stability=planet.lua.settlements.humans.stability+0.2
   end
   if planet.lua.settlements.natives then
      planet.lua.settlements.natives.stability=planet.lua.settlements.natives.stability+0.2
   end
   generatePlanetServices(planet)
   planet:save()

   var.push("empire_missions_5",true)
   local bop=var.peek("universe_balanceofpower")
   bop=bop+10
   var.push("universe_balanceofpower",bop)

   template_give_rewards()
end

function get_allies()
   local escorts={}

   local escort={}
   escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = empire_createPlanet()
   escort.ship_name="Imperial Strike Force"
   escorts[#escorts+1] = escort

   escort={}
   escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = empire_createContinent()
   escort.ship_name="Imperial Strike Force"
   escorts[#escorts+1] = escort

   escort={}
   escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = empire_createComet()
   escort.ship_name="Imperial Strike Force"
   escorts[#escorts+1] = escort

   escort={}
   escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = empire_createComet()
   escort.ship_name="Imperial Strike Force"
   escorts[#escorts+1] = escort

   return escorts
end

function get_escorts()
   local enemies={}

   local enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createPlanet()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createPlanet()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createContinent()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createContinent()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createContinent()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createComet()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createComet()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createComet()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = barbarians_createComet()
   enemie.ship_name="Barbarian Fleet"
   enemies[#enemies+1] = enemie

   return enemies
end