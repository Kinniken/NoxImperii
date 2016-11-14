include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/patrol.lua")
include("dat/ai/include/chatter.lua")

-- Settings
mem.armour_run = 40
mem.armour_return = 70
mem.aggressive = true

formation_default_type = "wall"
formation_tightness = 80
formation_sticky = 2


-- Create function
function create ()

   chatter(system.cur(),ai.pilot())

   -- Bribing
   bribe_no = {
         "\"You imperials believe you buy anything.\"",
         "\"You disgust me.\"",
         "\"You should never have left Imperial space!\""
   }
   mem.bribe_no = bribe_no[ rnd.rnd(1,#bribe_no) ]

  -- Get refuel chance
   p = player.pilot()
   if p:exists() then
      standing = ai.getstanding( p ) or -1
      mem.refuel = rnd.rnd( 2000, 4000 )
      if standing < 20 then
         mem.refuel_no = "\"My fuel belongs to my people.\""
      elseif standing < 70 then
         if rnd.rnd() > 0.2 then
            mem.refuel_no = "\"My fuel belongs to my people.\""
         end
      else
         mem.refuel = mem.refuel * 0.6
      end
      -- Most likely no chance to refuel
      mem.refuel_msg = string.format( "\"I suppose I could spare some fuel for %d credits.\"", mem.refuel )
   end

   mem.loiter = 3 -- This is the amount of waypoints the pilot will pass through before leaving the system

   -- Finish up creation
   create_post()
end

-- taunts
function taunt ( target, offense )
   -- Offense is not actually used
   taunts = {
         "You should never have left Imperial space!",
         "I shall wash my hull in your blood!",
         "Your head will make a great trophy!",
         "These moments will be your last!",
         "You are a parasite!"
   }
   ai.pilot():comm( target, taunts[ rnd.int(1,#taunts) ] )
end

chatter_chance = 100
chatter_trade_weight = 0
chatter_random_weight = 10
chatter_tag_weight = 10

add_chatter("I am the law here, not the Emperor.")
add_chatter("Disorder will not be tolerated.")
add_chatter("We are Humanity's first line of defense.")
add_chatter("Remember this is not the Empire anymore.")


-- event chatter
add_tag_chatter("event_fringe_barbarian_raid","Barbarian raids on ${planet}, system ${system}, will be stopped, no matter the cost!")
add_tag_chatter("event_fringe_nativeclashes","Rest assured that the native uprising on ${planet} will be thoroughly crushed.")
add_tag_chatter("event_fringe_alienfungus","The alien fungus threat on ${planet} in ${system} is being investigated. Please return to your normal activities.")