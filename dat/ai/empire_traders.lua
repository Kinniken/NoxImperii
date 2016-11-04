include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/trader.lua")
include("dat/ai/include/civilian_chatter.lua")

formation_default_type = "trade column"
formation_tightness = 50
formation_sticky = 5


mem.shield_run = 100
mem.armour_run = 100
mem.defensive  = false
mem.enemyclose = 500
mem.distressmsgfunc = sos
mem.careful   = true

chatter_trade_perc = 25
chatter_random_perc = 25

-- Sends a distress signal which causes faction loss
function sos ()
   msg = {
      "Mayday! Imperial trader under attack!",
      "Calling all Imperial forces! We are under attack!",
      "Mayday! Being assaulted in contradiction with Imperial laws!",
      string.format("Mayday! Imperial ship %s being assaulted!", string.lower( ai.pilot():ship():class() ))
   }
   ai.settarget( ai.target() )
   ai.distress( msg[ rnd.int(1,#msg) ])
end

function create ()

   civilianChatter(system.cur(),ai.pilot())

   -- Communication stuff
   mem.bribe_no = "\"Imperial Traders do not negotiate with criminals.\""
   mem.refuel = rnd.rnd( 3000, 5000 )
   
   if p:exists() then
      standing = ai.getstanding( p ) or -1
      if standing > 50 then mem.refuel = mem.refuel * 0.75
      elseif standing > 80 then mem.refuel = mem.refuel * 0.5
      end
      mem.refuel_msg = string.format("\"I'll supply your ship with fuel for %d credits.\"",
            mem.refuel);
   end

   -- Finish up creation
   create_post()
end

add_chatter("Every year trade is getting harder.")
add_chatter("I used to trade with independent worlds, but it's gotten too dangerous.")
add_chatter("I can't believe how much of my profits disapears in taxes!")
add_chatter("Aristocrats and officers get all the respect, but it's us traders that keep the Empire afloat.")
