include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/trader.lua")

mem.shield_run = 100
mem.armour_run = 100
mem.defensive  = false
mem.enemyclose = 500
mem.distressmsgfunc = sos

formation_default_type = "trade column"
formation_tightness = 100
formation_sticky = 2

-- Sends a distress signal which causes faction loss
function sos ()
   msg = {
      "Local security: requesting assistance!",
      "Requesting assistance. We are under attack!",
      "Vessel under attack! Requesting help!",
      "Help! Ship under fire!",
      "Taking hostile fire! Need assistance!",
      "We are under attack, require support!",
      "Mayday! Ship taking damage!",
   }
   ai.settarget( ai.target() )
   ai.distress( msg[ rnd.int(1,#msg) ])
end

function create ()

   chatter(system.cur(),ai.pilot())

   -- No bribe
   local bribe_msg = {
      "\"Just leave me alone!\"",
      "\"What do you want from me!?\"",
      "\"Get away from me!\""
   }
   mem.bribe_no = bribe_msg[ rnd.int(1,#bribe_msg) ]

   -- Refuel
   mem.refuel = rnd.rnd( 1000, 3000 )
   p = player.pilot()
   if p:exists() then
      standing = ai.getstanding( p ) or -1
      mem.refuel_msg = string.format("\"I'll supply your ship with fuel for %d credits.\"",
            mem.refuel);
   end

   create_post()
end

chatter_chance = 20
chatter_trade_weight = 10
chatter_random_weight = 10
chatter_tag_weight = 10

add_chatter("Trade's on the frontier isn't easy, but that's where the money is.")
add_chatter("Imperial traders are coddled weaklings, sheltering behind the navy.")
add_chatter("Barbarians, pirates... I've met them all in space, I'm still trading.")
add_chatter("I escaped a barbarian fleet on my last run. Good thing their ships are not that fast.")
add_chatter("Buy medicine in the Inner Worlds and sell on the edge, can't go wrong with that.")

add_trade_chatter("cheap","I'm back from ${planet}, system ${system}, they basically give away ${commodity} there!")
add_trade_chatter("cheap","I've heard ${commodity} is very cheap on ${planet}. It's in system ${system}.")

add_trade_chatter("expensive","I've just sold ${commodity} on ${planet}, system ${system}, they pay a fortune for it there!")
add_trade_chatter("expensive","People pay a fortune for ${commodity} on ${planet} in system ${system}.")

add_trade_chatter("cheapBulk","If you are looking to buy ${commodity} in bulk, head to ${planet}, system ${system}; prices are decent and the market is deep.")
add_trade_chatter("cheapBulk","Last time I was on ${planet} in system ${system}, they were selling cheap ${commodity} in large quantities.")

add_trade_chatter("expensiveBulk","Looking to sell ${commodity} in bulk? Try ${planet}, system ${system}: they pay decent prices.")
add_trade_chatter("expensiveBulk","I know ${planet} in system ${system} is looking for large quantities of ${commodity} and pays good prices for it.")


-- event chatter
add_tag_chatter("event_fringe_barbarian_raid","I have family on ${planet}, system ${system}. I hope they are ok, the last barbarian raids were terrible.")
add_tag_chatter("event_fringe_isolation","${planet} is isolating itself even more these days. Few traders make it there anymore.")
add_tag_chatter("event_fringe_miningboom","Last time I was on ${planet} in system ${system}, they were in the middle of an impressive mining boom! It's great to hear good economic news for a change.")
add_tag_chatter("event_fringe_nativeclashes","I'd avoid ${planet} in system ${system} right now if I was you. There are reports of major clashes with the natives.")
add_tag_chatter("event_fringe_alienfungus","Have you heard about the alien fungus ruining crops on ${planet} in system ${system}? It's horrible, but also a good way to sell food for good prices.")


-- world tags chatter
add_tag_chatter("buddhist","I'm from ${planet} in system ${system}. Yes, I'm Buddhist, but don't think I don't fight back when attacked.")
add_tag_chatter("isolated","I recently called at ${planet}, system ${system}. It's a really isolated place, even for the Fringe.")
add_tag_chatter("eximperial","If you're headed for ${planet} in system ${system}, don't advertise that you are Imperial too much. The folks there are not too happy with the Imperial withdrawal.")
add_tag_chatter("disagracedearl","Did you know that ${planet} in system ${system} was settled by a renegate Imperial Earl? His statue is everywhere, it's unearving.")
add_tag_chatter("feudalworld","I was born a serf on ${planet} in system ${system}. I was lucky and managed to flee. No way I'm every going back.")