
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
   misn_desc   = [[We have information that an independent cargo ship is used to supply the Yrens with weapons. It will be passing in ${targetSystem}. Destroy it.]]

   --Success message
   space_success_title = "Once more for the Empire"
   space_success_text = "As you enter the ${startSystem} system, your computer sends proof of the destruction of the ${targetShipName} to Commander Suarez on ${startPlanet}. Your payment of ${credits} cr is immediately wired."

-- Messages
msg      = {}
msg[1]   = "MISSION SUCCESS! Head to ${endPlanet} to report your success."
msg[2]   = "Pursue ${targetShipName} to ${targetSystem}!"
msg[3]   = "MISSION FAILURE! Somebody else eliminated ${targetShipName}."
msg["__save"] = true

osd_msg = {}
osd_msg[1] = "Fly to the ${targetSystem} system"
osd_msg[2] = "Kill ${targetShipName}"
osd_msg[3] = "Head to ${endPlanet} to report your success"
osd_msg["__save"] = true

-- Scripts we need
include("pilot/pirate.lua")


function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship_name, target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = trader_createSmallArdarBorderTrader()

   -- Get target system
   target_system = get_suitable_system( planet.get("Harkan"):system() )

   -- Get credits
   credits  = rnd.rnd(5,8) * 10000

   end_planet=planet.get("Harkan")

   template_create()  
end


--[[
Mission entry point.
--]]
function accept ()
   template_accept()
end

-- Gets a new suitable system
function get_suitable_system( around_sys )
   local newsys=get_empty_sys(around_sys,1,4)
   if newsys then
      return newsys
   else
      return around_sys
   end
end

-- Player won, gives rewards.
function give_rewards ()

   -- Give factions
   faction.modPlayerSingle( G.EMPIRE, 2 )
   
   template_give_rewards()
end