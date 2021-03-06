include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/patrol.lua")

-- Settings
mem.armour_run = 40
mem.armour_return = 70
mem.aggressive = true


-- Create function
function create ()

   -- Credits
   --ai.setcredits( rnd.int(ai.pilot():ship():price()/300, ai.pilot():ship():price()/70) )

   -- Bribing
   bribe_no = {
         "\"And you call yourself civilized?\"",
         "\"Your species has long forgotten what honour is.\"",
         "\"This land will never be yours!\""
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
         "I will bring your head back to my people!",
         "I shall wash my hull in your blood!",
         "Your head will make a great trophy!",
         "These moments will be your last!"
   }
   ai.pilot():comm( target, taunts[ rnd.int(1,#taunts) ] )
end

