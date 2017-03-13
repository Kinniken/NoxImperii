include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/patrol.lua")

-- Settings
mem.armour_run = 40
mem.armour_return = 70
mem.aggressive = true

formation_default_type = "vee"
formation_tightness = 20
formation_sticky = 5


function create ()

   -- Not too many credits.
   --ai.setcredits( rnd.rnd(ai.pilot():ship():price()/300, ai.pilot():ship():price()/70) )

   -- Get refuel chance
   p = player.pilot()
   if p:exists() then
      standing = ai.getstanding( p ) or -1
      mem.refuel = rnd.rnd( 2000, 4000 )
      if standing < 20 then
         mem.refuel_no = "\"My fuel is property of the Roidhunate.\""
      elseif standing < 70 then
         if rnd.rnd() > 0.2 then
            mem.refuel_no = "\"My fuel is property of the Roidhunate.\""
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
            "\"This is not the Empire, scum. Bribery does not work in the Roidhunate!\"",
            "\"Face the laws of the Roidhunate, Terran vermin!\""
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
            "Prepare to face the Ardar Navy, Terran scum!",
            "Your fate will one day be shared by the Empire.",
      }
   else
      taunts = {
            "We Ardars laugh at people like you."
      }
   end

   ai.pilot():comm(target, taunts[ rnd.rnd(1,#taunts) ])
end


chatter_chance = 20
chatter_trade_weight = 0
chatter_random_weight = 10
chatter_tag_weight = 10

add_chatter("You are in the Roidhunate. Disorder will not be tolerated!")
add_chatter("The Laws of the Roidhunate are backed by the Ardar Navy.")
add_chatter("The Ardar Race stands united behind our great Roidhun.")
add_chatter("Order reigns in the Roidhunate.")


-- event chatter
add_tag_chatter("roidhunate_native_repression","Ardar citizens should rest assured that the natives of ${planet} in ${system} system will be severely punished for their resistance against the mighty Roidhunate.")
add_tag_chatter("roidhunate_navyshipbuilding","Be informed that the shipbuilding effort on ${planet} is proceeding at full speed. Glory to the Roidhun!")
add_tag_chatter("roidhunate_anticorruption","Any citizen in the possession of informations related to anti-Ardar activities on ${planet} is encouraged to immediately report it to the closest Navy Intelligence officer.")
add_tag_chatter("roidhunate_minorityprotests","Law-abiding citizens on ${planet} will be protected from rioters by all means necessary.")
add_tag_chatter("roidhunate_militaryparade","Patriotic Ardars and citizens of minor Races are expected to show their loyalty to the Roidhunate by witnessing the military parade on ${planet}, in person or on the appropriate Navy channels.")