include "dat/missions/templates/ship_kill.lua"
include("universe/generate_nameGenerator.lua")
include('universe/objects/class_planets.lua')
include "dat/scripts/universe/live/live_universe.lua"
include "pilot/pilots_trader.lua"

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=true
   -- Whether mission ends in bar (if not, it ends in space in start system)
   mission_return_to_bar=false
   mission_return_to_planet=true

   bar_desc="You notice Rastapopoulos fuming at a table."

   -- Mission details
   misn_title  = "Destroy the Magnate's ship"
   misn_desc   = "Destroy the Magnate's ship in orbit of ${targetPlanet}."

   bar_accept_title = "Underhanded Methods"
   bar_accept_text  = [[The Betelgian trader is looking angrier than you've ever seen him, slamming a little liqueur glass on the table. He greets you with a grunt and launches into a tirade without prompting. "Backstabbing buffoons! Green-livered thieves! Great bloated blistering traitors!", he starts, slamming the table at every new insult.

It takes some time for him to calm down enough to explain the situation; a shipping magnate based on the independent world of ${targetPlanet} has double-crossed him, refusing to sell promised goods even after pocketing an advance - and worse, selling the whole lot to Rastapopoulos's own client!

It seems like the famous Betelgian reluctance to open conflict can be set aside in dire enough cases. Rastapopoulos wants that fleet destroyed.]]

   bar_accept_title_extra = "Punitive Expedition"
   bar_accept_text_extra = [[The magnate's flagship is the ${targetShipName}, last seen in the ${targetSystem} system. Expect it to be well-escorted.]]

   bar_success_title = "A Generous Client"
   bar_success_text = [[A beaming Rastapopoulos invites you to the fanciest table in the best bar available, and gets you to describe in great detail the fate of the name, edging you on with a great deal of colourful insults. When the time comes to negotiate your fee, he agrees to a generous ${credits} credits without arguing much.

You have a feeling this is not the last time you'll be called for a mission of this type.]]

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
   credits  = 500000

      -- Spaceport bar stuff
   misn.setNPC( "Rastapopoulos", "neutral/unique/aristocrat" )

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
   faction.modPlayerSingle( G.BETELGEUSE, 5 )

   player.addOutfit("Betelgian Protector",1)

   var.push("betelgeuse_missions_4",true)

   template_give_rewards()
end

function get_escorts()
   local enemies={}

   local enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = trader_createArgosy()
   enemie.ship_name="Magnate's Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = trader_createRhino()
   enemie.ship_name="Magnate's Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = trader_createRhino()
   enemie.ship_name="Magnate's Fleet"
   enemies[#enemies+1] = enemie

   enemie={}
   enemie.ship,enemie.ship_outfits,enemie.ship_ai,enemie.ship_faction = trader_createRhino()
   enemie.ship_name="Magnate's Fleet"
   enemies[#enemies+1] = enemie

   return enemies
end