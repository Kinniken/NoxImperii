include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/trader.lua")
include("dat/ai/include/civilian_chatter.lua")

mem.shield_run = 100
mem.armour_run = 100
mem.defensive  = false
mem.enemyclose = 500
mem.distressmsgfunc = sos

formation_default_type = "trade column"
formation_tightness = 100
formation_sticky = 2

chatter_trade_perc = 25
chatter_random_perc = 25

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

   civilianChatter(system.cur(),ai.pilot())

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

add_chatter("Trade's on the frontier isn't easy, but that's where the money is.")
add_chatter("Imperial traders are coddled weaklings, sheltering behind the navy.")
add_chatter("Barbarians, pirates... I've met them all in space, I'm still trading.")
add_chatter("I escaped a barbarian fleet on my last run. Good thing their ships are not that fast.")
add_chatter("Buy medicine in the Inner Worlds and sell on the edge, can't go wrong with that.")