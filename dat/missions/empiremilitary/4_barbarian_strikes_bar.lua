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
   mission_bar=true
   -- Whether mission ends in bar (if not, it ends in space in start system)
   mission_return_to_bar=false
   mission_return_to_planet=true


   -- Mission details
   misn_title  = "Destroy the Barbarian fleets"
   misn_desc   = "Destroy the Barbarian fleets in orbit of ${targetPlanet}"


   -- Bar information
   bar_desc   = "You notice Colonel Zhongzheng and his ensign at the bar. They are sipping small glasses of hard liquor, and the Colonel looks unusually animated."

   bar_accept_title = "A New Hope"
   bar_accept_text  = [[Colonel Zhongzheng and his ensign turn toward you. "${empireRank} ${playerName}. You have a flair for arriving at the right moment.", the Colonel starts, looking less dour than usual. "We finally have authorisation from HQ to take more active measures against the Barbarian threat!", continues his ensign with his usual threatening smile.

"We are planning a direct strike at the Barbarian fleets stationed around ${targetPlanet} in ${targetSystem}. We could do with reinforcements. Are you with us?", he adds, pointed teeth on full display.]]

   bar_success_title = "The Empire Strikes Back"
   bar_success_text = [[The ${shipName} lands on ${startPlanet} among much fanfare, alongside the other victorious Navy ships. The governor of the world himself is waiting for you, and soon the Imperial officers and you are brought on stage for a welcoming ceremony.

When your turn comes, the governor pins a medal on your vest, taps you twice on the shoulder on sends you on your way.

It's only after the ceremony that Colonel Zhongzheng's ensign suddenly appears by your side. "Congratulations, ${empireRank} ${playerName}. And more to the point, the governor has signed your promotion to the rank of colonel. And I have wired your bonus - ${credits} credits, to be precise.", he lets you know in his alien style.

"With the success of this action, more governors are calling for similar strikes. I'll make sure you are notified.". And with these parting words, he disappears, as silently as he has come.]]

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

   -- Spaceport bar stuff
   misn.setNPC( "Colonel Zhongzheng", "empire/unique/soldner" )

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
   faction.modPlayerSingle( G.EMPIRE, 5 )
   faction.modPlayerSingle( G.BARBARIANS, -5 )

   player.addOutfit("Reserve Colonel",1)

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

   var.push("empire_missions_4",true)
   local bop=var.peek("universe_balanceofpower")
   bop=bop+10
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