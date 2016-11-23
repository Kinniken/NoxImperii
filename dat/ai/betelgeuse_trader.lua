include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/trader.lua")


-- Sends a distress signal which causes faction loss
function sos ()
   msg = {
      "Calling all Betelgian fleets! Under assault!",
      "Requesting assistance from all Betelgian traders!",
      "Calling all forces of the Doge for assistance!",
      string.format("Betelgian %s being assaulted!", string.lower( ai.pilot():ship():class() ))
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

formation_default_type = "trade column"
formation_tightness = 50
formation_sticky = 4

function create ()

   -- Probably the ones with the most money
   --ai.setcredits( rnd.int(ai.pilot():ship():price()/100, ai.pilot():ship():price()/25) )

   -- Communication stuff
   mem.bribe_no = "\"We Betelgians do not sell our fuel to the like of you.\""
   mem.refuel = rnd.rnd( 3000, 5000 )
   p = player.pilot()
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


add_chatter("See the world, make money, that's my motto!")
add_chatter("I like you humans, so easy to make money by trading with you.")
add_chatter("Make no mistake, Dandalo is the real trade capital of the Galaxy.")
add_chatter("While the Ardars prepare for war and your Empire wallows in luxury, Betelgeuse grows rich.")
add_chatter("If you haven't traded with uncontacted species yet, you're doing it wrong.")

add_trade_chatter("cheap","Free tip since I'm in a good mood: on ${planet}, system ${system}, they basically give away ${commodity}.")
add_trade_chatter("cheap","I'll help you: ${commodity} is very cheap on ${planet}. It's in system ${system}.")

add_trade_chatter("expensive","I've heard humans are not very good at trading... You should try selling ${commodity} on ${planet}, system ${system}, they will give you a good price.")
add_trade_chatter("expensive","My trading house buys ${commodity} on ${planet} in system ${system} for a good price, give it a try.")

add_trade_chatter("cheapBulk","My house is selling plenty of ${commodity} on ${planet}, system ${system}! Cheap prices!")
add_trade_chatter("cheapBulk","You probably don't know, but ${planet} in system ${system} seels cheap ${commodity} in large quantities.")

add_trade_chatter("expensiveBulk","My house needs large quantities of ${commodity} on ${planet}, system ${system}; they'll give you a good deal.")
add_trade_chatter("expensiveBulk","${planet} in system ${system} is looking for large quantities of ${commodity} and the prices are good. Tip on the house, just this once.")


-- event chatter
add_tag_chatter("event_betelgeuse_fleetleaving","There's a great exploration fleet being assembled on ${planet}, system ${system}. They are buying lots of trade goods!")
add_tag_chatter("event_betelgeuse_fleetreturning","Did you know that a trade fleet has returned to ${planet}, system ${system}? They are selling rare goods.")
add_tag_chatter("event_betelgeuse_housecollapse","That House collapse on ${planet} in system ${system} is sad, but there are great deals to be made as they dismantle the Estate.")
add_tag_chatter("event_betelgeuse_noblemurder","Have you heard about the murder on ${planet} in system ${system}? Shocking! And bad for business, too!")

-- world tags chatter
add_tag_chatter("betelgian_hightechcenter","The Betelgian university on ${planet} in system ${system} is the equal of anything in the Empire! I studied there and my teachers said so.")
add_tag_chatter("betelgian_navalbase","I'm from ${planet}, system ${system}. There's a big naval base there, waste of tax money if you ask me.")
add_tag_chatter("betelgian_industrialcenter","You Imperials always think all we can do is trade. Visit ${planet} in system ${system}: you'll see we can produce too!")
add_tag_chatter("betelgian_greatpalace","Are you there for tourism? Check the Palace of ${planet} in system ${system}. Such good taste! So expensive! It trumps the Empire's, I'm sure.")