include "dat/missions/templates/ship_kill.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/missions/supportfiles/traders.lua"
include "pilot/pilots_ardarshir.lua"

payment = 250000

-- Whether mission starts when landing (if false, it starts in computer)
mission_land=true
mission_bar=false
-- Whether mission ends when landing (if not, it ends in space in start system)
mission_return_to_planet=true
mission_return_to_bar=false



-- Mission Details
misn_title = "Intercept the mysterious cargo"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Destroy one of the mysterious cargo and analyse its debris."

-- Messages
msg      = {}
msg[1]   = "MISSION SUCCESS! Head to ${endPlanet} with the cargo."
msg[2]   = "Pursue ${targetShipName} to ${targetSystem}!"
msg[3]   = "MISSION FAILURE! Somebody else eliminated ${targetShipName}."
msg["__save"] = true

-- Messages
osd_msg = {}
osd_msg[1] = "Fly to the ${targetSystem} system"
osd_msg[2] = "Kill ${targetShipName} and examine its cargo"
osd_msg[3] = "Head to ${endPlanet} to report your success"
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

start_title = "The mysterious digs"
start_text = [[You're settled at the bar with Beauval, drinking what passes for whisky in military messes while your friend efficiently extract from you everything Shadowlines said during the journey when Suarez calls for the two of you.

"The avian was very cooperative. My xenopsycologist adviser claims that going to such efforts to cure her makes us - and ${playerName}, you in particular - honorary tribe member or something of that kind. That it served our own purposes doesn't seem to matter. In any case, we now have some idea of why the damned crocodiles are so keen on this wretched place.". Beauval leans in, waiting for every word. "High in the mountains, in an area not far from Chicken's roaming grounds, Ardar teams are mining. And from her description it seems like whatever they are digging up is dangerous - toxic or radioactive or both. It's obviously valuable but we have no idea what it is and no way to reach there without making this conflict much hotter than it is now."

"However...", continues Suarez, "our new friend had another interesting info for us. The Ardars are discreetly shipping this stuff in civilian cargo, with only limited escorts. We need someone to intercept one of them and figure out what's in them. ${empireRank} ${playerName}?"]]



accept_title = "Buccaneer for the Empire"
accept_text = [[Commander Suarez provides you with all the known details on those cargo' route. One of them seems to have its rendez-vous point in the nearby system of ${targetSystem}. Time to hunt!]]



success_title = "Crates at sea"
success_text = [[As the transport dislocate, your sensors are focused on analysing the debris for traces of odd elements. A few heavily-reinforced crates floating from the broken hull flash on your screens; they are clearly radioactive, and their emission profile is unusual. You lead the ship close to the crates and send a crew member to bring them in.]]


bar_success_title = "Home Sweet Home"
bar_success_text = [[You land on Harkad Outpost your hull still smoking from the encounter. Suarez's teams waste no time unloading your precious cargo. You also notice your credit terminal beeping - the Commander has just wired you money credits as your mission fee.

You should probably head for the bar while Suarez gets the crate analysed.]]

cargo_name = "Mysterious Cargo"
cargo_quantity = 1


function create ()


	if not (planet.cur()==planet.get("Harkan")) then
		misn.finish(false)
	end

   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship_name, target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = trader_createSmallArdarBorderTrader()

   -- Get target system
   target_system = get_suitable_system( planet.get("Harkan"):system() )


   -- Get credits
   credits  = payment

   end_planet=planet.get("Harkan")

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
   faction.modPlayerSingle( G.EMPIRE, 5 )

   template_give_rewards()
end


function get_escorts()

	local escorts={}

	local escort={}
	escort.ship,escort.ship_outfits,escort.ship_ai,escort.ship_faction = ardarshir_createMeteor()

   escort.ship_name="Ardar Escort"

	escorts[#escorts+1] = escort

   return escorts
end