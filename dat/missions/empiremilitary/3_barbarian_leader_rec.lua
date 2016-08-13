--[[

   barbarian leader assassination

--]]

include "dat/missions/templates/ship_kill.lua"
include "dat/missions/supportfiles/barbarians.lua"
include("universe/generate_nameGenerator.lua")
include('universe/objects/class_planets.lua')
include "dat/scripts/universe/live/live_universe.lua"

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   -- Whether mission ends in bar (if not, it ends in space in start system)
   mission_return_to_bar=false

   computer_title  = "NAVY: Kill Barbarian Lord in ${targetSystem}"

   -- Mission details
   misn_title  = "Kill Barbarian Lord"
   misn_desc   = "Kill ${targetShipName} in the ${targetSystem} system"


  -- Text if mission ends in space in starting system.
  space_success_title = "Confirmed Kill"
space_success_text = "You enter system ${startSystem} and transfer the data on the death of ${targetShipName} to the Navy base. Your payment of ${credits} cr is immediately wired."

-- Scripts we need
include("pilot/barbarians.lua")


function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship_name, target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = barbarian_lord_generate()

   -- Get target system
   target_planet,target_system = get_barbarian_planet( system.cur() )

   -- Get credits
   credits  = rnd.rnd(50,90) * 10000

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

   local bop=var.peek("universe_balanceofpower")
   bop=bop+1
   var.push("universe_balanceofpower",bop)
   
   local planet=planet_class.load(target_planet)

   planet.lua.settlements.barbarians.military=planet.lua.settlements.barbarians.military*0.9
   planet:addHistory("The death of "..target_ship_name.." started a civil war, diminishing the world's military potential.")
   generatePlanetServices(planet)
   planet:save()

   template_give_rewards()
end