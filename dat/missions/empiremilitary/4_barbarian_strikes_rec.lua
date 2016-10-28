--[[

   barbarian leader assassination

--]]

include "dat/missions/templates/ship_kill.lua"
include "dat/missions/supportfiles/barbarians.lua"
include("pilot/pilots_barbarians.lua")
include("universe/generate_nameGenerator.lua")
include('universe/objects/class_planets.lua')
include "dat/scripts/universe/live/live_universe.lua"
include "pilot/pilots_empire.lua"
include "pilot/pilots_barbarians.lua"

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   mission_return_to_bar=false

   computer_title  = "NAVY: Pre-emptive raids on ${targetSystem}"

   -- Mission details
   misn_title  = "Join raids on ${targetSystem}"
   misn_desc   = "Destroy barbarian fleets in ${targetSystem} system"


  -- Text if mission ends in space in starting system.
  space_success_title = "To the Victor the Spoils"
   space_success_text = "You enter system ${startSystem} and transfer the data on your participation to the raid. Your payment of ${credits} cr is immediately wired."

function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = barbarians_createPlanet()

   target_ship_name = "Fleet Leader"

   -- Get target system
   target_planet,target_system = get_barbarian_planet( system.cur() )

   if (target_planet == nil) then
      misn.finish(false)
   end

   target_ship_pos = target_planet:pos()

   -- Get credits
   credits  = rnd.rnd(150,300) * 10000

   allied_kills_count=true

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
   return get_adjacent_barbarian_system(sys)
end



-- Player won, gives rewards.
function give_rewards ()

   -- Give factions
   faction.modPlayerSingle( G.EMPIRE, 1 )
   faction.modPlayerSingle( G.BARBARIANS, -1 )

   local planet=planet_class.load(target_planet)

   planet.lua.settlements.barbarians.military=planet.lua.settlements.barbarians.military*0.5
   planet:addHistory("Preventive raids by the Imperial Navy have greatly reduced the world's military strength.")
   generatePlanetServices(planet)
   planet:save()

   local planet=planet_class.load(start_planet)
   planet:addHistory("A daring raid on barbarian fleets on "..target_planet:name().." ordered by the governor has greatly boosted confidence in the Imperial government.")

   if planet.lua.settlements.humans then
      planet.lua.settlements.humans.stability=planet.lua.settlements.humans.stability+0.2
   end
   generatePlanetServices(planet)
   planet:save()

   local bop=var.peek("universe_balanceofpower")
   bop=bop+1
   var.push("universe_balanceofpower",bop)

   template_give_rewards()
end

function get_allies()
   local escorts={}

   local escort={}
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

   return enemies
end