include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/patrol.lua")
include("dat/ai/include/chatter.lua")

-- Settings
mem.armour_run = 40
mem.armour_return = 70
mem.aggressive = true

formation_default_type = "imperial"
formation_tightness = 20
formation_sticky = 5

function create ()

   chatter(system.cur(),ai.pilot())

   -- Get refuel chance
   p = player.pilot()
   if p:exists() then
      standing = ai.getstanding( p ) or -1
      mem.refuel = rnd.rnd( 2000, 4000 )
      if standing < 20 then
         mem.refuel_no = "\"My fuel is property of the Empire.\""
      elseif standing < 70 then
         if rnd.rnd() > 0.2 then
            mem.refuel_no = "\"My fuel is property of the Empire.\""
         end
      else
         mem.refuel = mem.refuel * 0.6
      end
      -- Most likely no chance to refuel
      mem.refuel_msg = string.format( "\"I suppose I could spare some fuel for %d credits.\"", mem.refuel )
   end

   -- See if can be bribed
   if rnd.rnd() > 0.7 then
      mem.bribe = math.sqrt( ai.pilot():stats().mass ) * (500. * rnd.rnd() + 1750.)
      mem.bribe_prompt = string.format("\"For some %d credits I could forget about seeing you.\"", mem.bribe )
      mem.bribe_paid = "\"Now scram before I change my mind.\""
   else
     bribe_no = {
            "\"You won't buy your way out of this one.\"",
            "\"The Empire likes to make examples out of scum like you.\"",
            "\"You've made a huge mistake.\"",
            "\"Bribery carries a harsh penalty, scum.\"",
            "\"I'm not interested in your blood money!\"",
            "\"All the money in the world won't save you now!\""
     }
     mem.bribe_no = bribe_no[ rnd.rnd(1,#bribe_no) ]
     
   end

   mem.loiter = 3 -- This is the amount of waypoints the pilot will pass through before leaving the system

   -- Finish up creation
   create_post()
end

-- taunts
function taunt ( target, offense )

   -- Only 50% of actually taunting.
   if rnd.rnd(0,1) == 0 then
      return
   end

   -- some taunts
   if offense then
      taunts = {
            "There is no room in this universe for scum like you!",
            "The Empire will enjoy your death!",
            "Your head will make a fine gift for the Emperor!",
            "None survive the wrath of the Emperor!",
            "Enjoy your last moments, criminal!"
      }
   else
      taunts = {
            "You dare attack me!",
            "You are no match for the Empire!",
            "The Empire will have your head!",
            "You'll regret that!",
            "That was a fatal mistake!"
      }
   end

   ai.pilot():comm(target, taunts[ rnd.rnd(1,#taunts) ])
end



chatter_chance = 100
chatter_trade_weight = 0
chatter_random_weight = 10
chatter_tag_weight = 10

add_chatter("The Empire is watching you.")
add_chatter("Peace reigns throughout the Empire.")
add_chatter("The Emperor sees all.")
add_chatter("Long life to His Majesty.")


-- event chatter
add_tag_chatter("event_empire_barbarian_raid","The Navy will avenge ${planet}! Barbarian raids will not be tolerated!")
add_tag_chatter("event_empire_newgovernor","We remind the loyal citizens of the Empire that criticizing the new or the former Governors of ${planet} is illegal and will not be tolerated.")
add_tag_chatter("event_empire_pirateattacks","Traders are advised to stay clear of ${system} for now. The pirate threat is been tackled.")
add_tag_chatter("event_empire_plague","Patriotic traders are encouraged to head to ${planet} in system ${system} with medical supplies in order to contribute to Imperial efforts against the ongoing plague.")

