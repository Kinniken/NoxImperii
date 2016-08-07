--[[

   barbarian leader assassination

--]]

include "numstring.lua"
include "dat/missions/templates/ship_kill.lua"
include "dat/missions/supportfiles/barbarians.lua"
include("pilot/barbarians.lua")
include("universe/generate_nameGenerator.lua")
include('universe/objects/class_planets.lua')

   -- Whether mission starts in bar (if false, it starts in computer)
   mission_bar=true
   -- Whether mission ends in bar (if not, it ends in space in start system)
   mission_return_to_bar=true


   -- Mission details
   misn_title  = "Kill Barbarian Lord"
   misn_desc   = "Kill ${targetShipName} in the ${targetSystem} system"


   -- Bar information
   bar_desc   = "Colonel Zhongzheng is discussing with his ensign, looking very agitated."
   bar_accept_text  = [[As you get closer, you overhear the Colonel and his ensign. They are discussing a new barbarian chief known as ${targetShipName} thought to be responsible for recent raids on Imperial worlds.

   "You know we can't take him out.", the ensign is telling Colonel Zhongzheng. "Then it would be a question of honor for his tribe - they'd throw everything they have at us."
   "So we sit there waiting for the next raid instead!" growls the Colonel. "What has the Empire come to?"

   The ensign notices you and smiles, or at least exposes his sharp carnivorous teeth in an unsettling mimic of a human smile. "Captain ${playerName}! Maybe you could help us again...". The Colonel gloomy nods an agreement. "Would you feel capable of taking on a Barbarian Lord deep inside barbarian space?"]]
   bar_accept_text_extra = [["Very well. If a lone operator targets him it won't trigger a vendetta against the Empire. We'll make it worth your time, should you come back." states the Colonel, clearly not happy to be accepting your help again.

   "He's based on ${targetPlanet}, in the ${targetSystem} system, in the fringe.", adds the ensign. "Good luck, you are brave - for a human!"]]

   bar_success_text = [[The Colonel and his ensign are waiting for you as you enter the bar.

   "Well, well, even mercenaries can be efficient. That should teach a lesson to those scums. Here are your credits." the Colonel tells you sharply.

   "We've heard reports from ${targetPlanet} that the death of ${targetShipName} has triggered a lot of infighting! Their raids have already diminished. The Navy is grateful." adds the ensign, under the disapproving eye of his superior. "We might need your services again for that kind of missions."]]




function create ()
   -- Note: this mission does not make any system claims.
   -- Create the target pirate
   target_ship_name, target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = barbarian_lord_generate()

   -- Get target system
   target_planet,target_system = get_barbarian_planet( system.cur() )

   -- Get credits
   credits  = rnd.rnd(50,90) * 10000

   -- Spaceport bar stuff
   misn.setNPC( "Colonel Zhongzheng", "empire/unique/soldner" )

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
   faction.modPlayerSingle( G.PIRATES, -5 )
   
  local planet=planet_class.load(target_planet)

   planet.lua.settlements.barbarians.military=planet.lua.settlements.barbarians.military*0.7
   planet:addHistory("The death of "..target_ship_name.." started a civil war, diminishing the world's military potential.")

   planet:save()

   template_give_rewards()
end

