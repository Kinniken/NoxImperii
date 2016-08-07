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
   mission_return_to_bar=false
   mission_return_to_planet=true

   computer_title  = "NAVY: Defend ${targetPlanet}"

   -- Mission details
   misn_title  = "Defend ${targetPlanet}"
   misn_desc   = "Protect ${targetPlanet} in ${targetSystem} system from barbarian fleets."

   bar_success_title = "For the Emperor!"
   bar_success_text = [[The ${shipName} once again lands to the cheers of the crowd. "Captain ${playerName}! Captain ${playerName}!" the massed multitudes scream, human and aliens alike. On a day like this you feel they'd crown you Emperor if you only cheered back hard enough.

You know well that the new victory at ${targetSystem} changes little in the long term; there are a thousand barbarian ships waiting in the Deep Beyond for each that fell to the ${shipName}'s guns. But today the Nox Imperii feels a little more remote, and a rare hope shines on the public's faces.]]

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
   faction.modPlayerSingle( G.EMPIRE, 5 )
   faction.modPlayerSingle( G.BARBARIANS, -5 )

   local planet=planet_class.load(target_planet)
   planet:addHistory("The destruction by Imperial forces of the barbarian fleets assaulting the world has led to a political and economic recovery.")

   if planet.lua.settlements.humans then
      planet.lua.settlements.humans.stability=planet.lua.settlements.humans.stability+0.2
      planet.lua.settlements.humans.services=planet.lua.settlements.humans.services+0.2
   end
   if planet.lua.settlements.natives then
      planet.lua.settlements.natives.stability=planet.lua.settlements.natives.stability+0.2
      planet.lua.settlements.humans.services=planet.lua.settlements.humans.services+0.2
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

   local bop=var.peek("universe_balanceofpower")
   bop=bop+2
   var.push("universe_balanceofpower",bop)
   updateUniverseDesc()

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