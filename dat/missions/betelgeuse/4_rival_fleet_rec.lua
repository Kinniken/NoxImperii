include "dat/missions/templates/ship_kill.lua"
include("universe/generate_nameGenerator.lua")
include('universe/objects/class_planets.lua')
include "dat/scripts/universe/live/live_universe.lua"
include "pilot/pilots_trader.lua"

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=false
   mission_return_to_bar=false

   mission_return_to_bar=false
   mission_return_to_planet=true


   -- Mission details
   misn_title  = "Destroy the rival trader's ship"
   misn_desc   = "Destroy the rival trader's ship in orbit around ${targetPlanet}."
   computer_title  = "BETELGEUSE: Eliminate rival trader"

   bar_success_title = "Deadly Competition"
   bar_success_text = [[You land the ${shipName} and submit proof of the destruction of the target to a high-ranking member of the Betelgian house concerned. He whitens a little when reviewing the recording; clearly he is not at ease with such methods.

He hands you your ${credits} credits payment, shaking slightly.]]

function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = trader_createArgosy()

   local adj = {"Rich", "Handsome", "Great", "Magnificent"}

   local noun={"Trader", "Merchant", "Magnate"}

   target_ship_name = adj[math.floor(math.random()*#adj)+1].." "..noun[math.floor(math.random()*#noun)+1]

   -- Get target system
   target_planet,target_system = get_faction_planet(system.cur(),G.INDEPENDENT_WORLDS,3,7)

   target_ship_pos = target_planet:pos()

   -- Get credits
   credits  = rnd.rnd(30,80) * 10000

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
   return get_empty_sys(sys,1,4)
end

-- Player won, gives rewards.
function give_rewards ()

   -- Give factions
   faction.modPlayerSingle( G.BETELGEUSE, 3 )

   template_give_rewards()
end

function get_escorts()
   local enemies={}

   local enemie={}

   local nbArgosy=math.random(0,3)
   local nbRhino=math.random(2,4)

   for i=1,nbArgosy do
      enemie={}
      enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = trader_createArgosy()
      enemie.ship_name="Magnate's Fleet"
      enemies[#enemies+1] = enemie
   end 

   for i=1,nbRhino do
      enemie={}
      enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = trader_createRhino()
      enemie.ship_name="Magnate's Fleet"
      enemies[#enemies+1] = enemie
   end 

   return enemies
end

