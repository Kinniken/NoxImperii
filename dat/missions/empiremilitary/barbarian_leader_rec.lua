--[[

   barbarian leader assassination

--]]

include "numstring.lua"
include "dat/missions/templates/ship_kill.lua"
include "dat/missions/supportfiles/barbarians.lua"
include("universe/generate_nameGenerator.lua")
include('universe/objects/class_planets.lua')

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   -- Whether mission ends in bar (if not, it ends in space in start system)
   mission_return_to_bar=false

   computer_title  = "NAVY: Kill Barbarian Lord in ${targetSystem}"

   -- Mission details
   misn_title  = "Kill Barbarian Lord"
   misn_desc   = "Kill ${targetShipName} in the ${targetSystem} system"


  -- Text if mission ends in space in starting system.
space_success_text = "You enter system ${startSystem} and transfer the data on the death of ${targetShipName} to the Navy base. Your payment of ${credits} cr is immediately wired."

-- Scripts we need
include("pilot/barbarians.lua")


function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship_name, target_ship, target_ship_outfits = barbarian_lord_generate()

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
   faction.modPlayerSingle( "Empire of Terra", 1 )
   faction.modPlayerSingle( "Pirate", -5 )
   
  local planet=planet_class.load(target_planet)

   planet.settlements.barbarians.military=planet.settlements.barbarians.military*0.9
   planet.settlements:addHistory("The death of "..target_ship_name.." started a civil war, diminishing the world's military potential.")

   planet:save()

   template_give_rewards()
end