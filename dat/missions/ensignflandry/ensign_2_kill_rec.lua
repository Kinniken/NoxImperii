
include "numstring.lua"
include "dat/missions/templates/ship_kill.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/missions/supportfiles/traders.lua"

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   -- Whether mission ends in bar (if not, it ends in space in start system)
   mission_return_to_bar=false

   computer_title  = "Harkan: Ardar Convoy"

   -- Mission details
   misn_title  = "Intercept Ardar Convoy"
   misn_desc   = [[We have information that an independent cargo ship is used to supply the Seatrolls with weapons. It will be passing in ${targetSystem}. Destroy it.]]


-- Scripts we need
include("pilot/pirate.lua")


function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship_name, target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = trader_createSmallArdarBorderTrader()

   -- Get target system
   target_system = get_suitable_system( system.cur() )

   -- Get credits
   credits  = rnd.rnd(5,8) * 10000

   template_create()

   end_planet=planet.get("Harkan")
end


--[[
Mission entry point.
--]]
function accept ()
   template_accept()
end

-- Gets a new suitable system
function get_suitable_system( sys )
   local newsys=get_empty_sys(sys,1,4)
   if newsys then
      return newsys
   else
      return sys
   end
end

-- Player won, gives rewards.
function give_rewards ()

   -- Give factions
   faction.modPlayerSingle( "Empire of Terra", 1 )
   
   template_give_rewards()
end