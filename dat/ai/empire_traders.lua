include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/trader.lua")
include("dat/ai/include/civilian_chatter.lua")


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


mem.shield_run = 100
mem.armour_run = 100
mem.defensive  = false
mem.enemyclose = 500
mem.distressmsgfunc = sos
mem.careful   = true


function create ()

   p = player.pilot()

   -- Probably the ones with the most money
   --ai.setcredits( rnd.int(ai.pilot():ship():price()/100, ai.pilot():ship():price()/25) )

   if p:exists() then
      r = rnd.rnd(1,2)
      if r == 1 then
         local tradeChatter = getTradeDealChatter(system.cur(),ai.pilot())

         if tradeChatter then
           ai.pilot():comm(tradeChatter)
         end
      end
   end

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
