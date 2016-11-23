include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/patrol.lua")

--[[

   Pirate AI

--]]

-- Settings
mem.aggressive     = true
mem.safe_distance  = 500
mem.armour_run     = 80
mem.armour_return  = 100
mem.atk_board      = true
mem.atk_kill       = false
mem.careful       = true

formation_default_type = "blob"
formation_tightness = 100
formation_sticky = 2

function create ()

   -- Some pirates do kill
   if rnd.rnd() < 0.1 then
      mem.atk_kill = true
   end

   -- Not too much money
   --ai.setcredits( rnd.int(ai.pilot():ship():price()/80 , ai.pilot():ship():price()/30) )

   -- Deal with bribeability
   if rnd.rnd() < 0.05 then
      mem.bribe_no = "\"No mercy for weaklings like you!\""
   else
      mem.bribe = math.sqrt( ai.pilot():stats().mass ) * (300. * rnd.rnd() + 850.)
      bribe_prompt = {
            "\"You civilised folks are so weak. %d credits and we'll you go.\"",
            "\"Had enough already? %d credits and we'll plunder you later.\"",
      }
      mem.bribe_prompt = string.format(bribe_prompt[ rnd.rnd(1,#bribe_prompt) ], mem.bribe)
      bribe_paid = {
            "\"Now go and train, weakling. Maybe next time you won't be so embarrassingly bad at this.\"",
            "\"See where your precious civilisation got you.\"",
            "\"Soon the Emperor himself will pay like you did.\"",
      }
      mem.bribe_paid = bribe_paid[ rnd.rnd(1,#bribe_paid) ]
   end

   -- Deal with refueling
   p = player.pilot()
   if p:exists() then
      standing = ai.getstanding( p ) or -1
      mem.refuel = rnd.rnd( 2000, 4000 )
      if standing > 60 then
         mem.refuel = mem.refuel * 0.5
      end
      mem.refuel_msg = string.format("\"For you, only %d credits for a hundred units of fuel.\"",
            mem.refuel);
   end

   mem.loiter = 3 -- This is the amount of waypoints the pilot will pass through before leaving the system

   -- Finish up creation
   create_post()
end


function taunt ( target, offense )

   -- Only 50% of actually taunting.
   if rnd.rnd(0,1) == 0 then
      return
   end

   -- some taunts
   if offense then
      taunts = {
            "You folks are just plunder for us!",
            "Civilised ships are just moving plunder.",
            "You are weak, like all humans.",
            "Our conquest of the Galaxy starts with you.",
            "The plunder from your ship will pay for ships for our warriors.",
      }
   else
      taunts = {
            "Finally some warrior spirit!",
            "I like a prey that fights back, it's more honourable.",
            "A human with a bit of courage. Not something I see everyday!",
            "You have guts, but can you fight?",
            "If all humans fought like you, maybe the Empire would have a chance.",
            "Not bad for a degenerate.",
            "Continue, and you might start passing for a warrior.",
      }
   end

   ai.pilot():comm(target, taunts[ rnd.rnd(1,#taunts) ])
end

chatter_chance = 50
chatter_trade_weight = 0
chatter_random_weight = 10
chatter_tag_weight = 10


add_chatter("Civilised ships are just moving plunder.")
add_chatter("My King will soon rule your precious worlds!")
add_chatter("The Emperor himself cowers before us!")
add_chatter("There's not a single true warrior in your wretched Empire!")
add_chatter("Our banners will fly above your burning cities!")
add_chatter("Terra itself will fall to our hordes.")

-- event chatter
add_tag_chatter("event_fringe_barbarian_raid","Our fleets have left nothing but ruins on ${planet}, system ${system}!")
add_tag_chatter("event_fringe_barbarian_raid","The loot from ${planet} in system ${system} will pay for many more fleets!")
add_tag_chatter("event_fringe_barbarian_raid","Contemplate the smoking ruins of ${planet} in system ${system} and know fear.")

add_tag_chatter("event_empire_barbarian_raid","We've raided ${planet} in system ${system} again, and what is your precious Emperor doing? Nothing!")
add_tag_chatter("event_empire_barbarian_raid","Know that soon Terra's cities will be like those of ${planet} in system ${system}: looted ruins with our banners on top!")
add_tag_chatter("event_empire_barbarian_raid","Ask Imperial citizens on ${planet} in system ${system} what Imperial protection is worth!")