include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/trader.lua")

formation_default_type = "trade column"
formation_tightness = 50
formation_sticky = 5


mem.shield_run = 100
mem.armour_run = 100
mem.defensive  = false
mem.enemyclose = 500
mem.distressmsgfunc = sos
mem.careful   = true

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

   chatter(system.cur(),ai.pilot())

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

chatter_chance = 40
chatter_trade_weight = 10
chatter_random_weight = 10
chatter_tag_weight = 10

add_chatter("Every year trade is getting harder.")
add_chatter("I used to trade with independent worlds, but it's gotten too dangerous.")
add_chatter("I can't believe how much of my profits disappears in taxes!")
add_chatter("Aristocrats and officers get all the respect, but it's us traders that keep the Empire afloat.")

add_trade_chatter("cheap","I'm back from ${planet}, system ${system}, they basically give away ${commodity} there!")
add_trade_chatter("cheap","I've heard ${commodity} is very cheap on ${planet}. It's in system ${system}.")

add_trade_chatter("expensive","I've just sold ${commodity} on ${planet}, system ${system}, they pay a fortune for it there!")
add_trade_chatter("expensive","People pay a fortune for ${commodity} on ${planet} in system ${system}.")

add_trade_chatter("cheapBulk","If you are looking to buy ${commodity} in bulk, head to ${planet}, system ${system}; prices are decent and the market is deep.")
add_trade_chatter("cheapBulk","Last time I was on ${planet} in system ${system}, they were selling cheap ${commodity} in large quantities.")

add_trade_chatter("expensiveBulk","Looking to sell ${commodity} in bulk? Try ${planet}, system ${system}: they pay decent prices.")
add_trade_chatter("expensiveBulk","I know ${planet} in system ${system} is looking for large quantities of ${commodity} and pays good prices for it.")

-- event chatter
add_tag_chatter("event_empire_barbarian_raid","Have you heard of the barbarian raid on ${planet}, system ${system}? The casualty reports are horrible!")
add_tag_chatter("event_empire_bankcollapse","I've heard the Industrial Bank of ${planet} has collapsed... Good thing I keep my credits onboard.")
add_tag_chatter("event_empire_miningboom","I have a cousin that went into mining on ${planet}, system ${system}. With the recent boom he's earned more in a month than me in a year.")
add_tag_chatter("event_empire_newgovernor","The governor of ${planet} in system ${system} was really horribly corrupt. I hope the new one is better.")
add_tag_chatter("event_empire_pirateattacks","Avoid system ${system} for now! There are reports that ${planet} has been hit hard by pirate raids.")
add_tag_chatter("event_empire_departingcolonists","My brother was settled on ${planet} in system ${system}, but he's leaving. It's not safe so far from the centre any more.")
add_tag_chatter("event_empire_plague","Have you heard of the plague on ${planet} in system ${system}? They are in urgent need of medical supplies. I'm not risking my life going there though.")
add_tag_chatter("event_winefair","The wine fair of ${planet} in system ${system} has started! I'm finishing my deliveries and heading there.")
add_tag_chatter("event_mela","The mela of ${planet} in system ${system} has just started. It's really an incredible festival.")
add_tag_chatter("event_empire_carnival","As soon as I'm done with this I'm heading to ${planet} in system ${system} for the carnival! I was there last year, it was a blast.")
add_tag_chatter("event_empire_chinesenewyear","Happy New Year! It's the Chinese New Year on ${planet}, system ${system}!")


-- world tags chatter
add_tag_chatter("french","Waiters on ${planet} in system ${system} can be snobbish, but the food is worth it, trust me.")
add_tag_chatter("chinese","You should visit ${planet}, system ${system}, during Chinese festivals. Well, unless you can't stand crowds.")
add_tag_chatter("hindu","Whenever I visit ${planet} in system ${system}, I leave an offering to Lakshmi. It has worked well so far!")
add_tag_chatter("penal","You don't need to be a convict to settle on ${planet} in system ${system}, but it does help to blend in.")
add_tag_chatter("amish","I'm originally from ${planet} in system ${system}. Everybody think there are only Amish there, but it's not true!")
add_tag_chatter("serbian","I don't care much for their food, but the Serbs on ${planet} in system ${system} make one mean rakia.")
add_tag_chatter("buddhist","Don't believe what people say, people on ${planet}, system ${system} may be Buddhists, but you get steaks and beer.")
