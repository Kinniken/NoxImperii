
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = 10000

-- Mission Details
misn_title = "Complete Betelegian courier mission"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Deliver the wine cargo to the Rialto family on ${targetPlanet}."

bar_desc="The famous Betelegian trader Rastapopoulos is sitting at a small table, surrounded by harassed-looking pilots."

-- Messages
osd_msg = {}
osd_msg[1] = "Deliver wine to ${targetPlanet} on ${targetSystem}."
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "A Career Opportunity"
text[1] = [[As you move closer, you hear the trader berate his staff. You can hear him swearing from the other side of the bar: "Blistering blasters! Neurotic nebulas! Criminal clusters of cowardly comets!".

It seems like they are short of pilots and running late on deliveries. This could be an occasion to enter Betelgeuse's famed courier network!]]

title[2] = "An Urgent Request"
text[2] = [[You approach and offer your services. You can see a glimmer of interest in the trader's eyes, immediately replaced by an inscrutable poker face. "Very well, Captain ${playerName}, I'll hire you for a test mission. But I'm taking a risk there, so I'll pay you ${payment} credits only. If you do a good job, you'll be eligible for more lucrative missions. Done? Good."

What appears to be his right-hand man takes over. "You can take over the delivery of Bordeaux wine for the Rialto family. It's expected on ${targetPlanet} in ${targetSystem} system. Hurry!", he snaps at you.]]

title[3] = "All in good time"
text[3] = [[You land on ${targetPlanet} and head for the Betelgian trade guild's warehouses. They quickly unload your cargo. 

An old-looking Betelgian intendant comes out to meet you. "So you are the new courier Rastapopoulos hired? You look better than some of his choices. You really got stiffed on your fee, boy. Still, here are your ${payment} credits. And you are now registered with the Betelgian courier missions - at the normal rates. Fly well, earn gold!", he tells you, winking throughout.]]


function getStringData()
   local stringData={}
   stringData.playerName=player:name()
   stringData.targetPlanet=targetPlanet:name()
   stringData.targetSystem=targetPlanet:system():name()
   stringData.payment=payment
   return stringData
end

function create ()

   targetPlanet=get_faction_planet(system.cur(),G.BETELGEUSE,2,7)

   if not pickupPlanet then
      misn.finish()
   end

   -- creates the NPC at the bar to create the mission
   misn.setNPC( "Rastapopoulos", "neutral/unique/aristocrat" )
   misn.setDesc( bar_desc )
end

function accept()
   local stringData=getStringData()

   if not tk.yesno( gh.format(title[1],stringData), gh.format(text[1],stringData) ) then
      misn.finish()
   end

   tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

   misn.accept()

   landmarker = misn.markerAdd( targetPlanet:system(), "plot" )

   carg_id = misn.cargoAdd( C.BORDEAUX, 0 )

  -- mission details
  misn.setTitle( gh.format(misn_title,stringData) )
  misn.setReward( gh.format(misn_reward,stringData)  )
  misn.setDesc( gh.format(misn_desc,stringData) )

  osd_msg = gh.formatAll(osd_msg,stringData)
  misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

     -- hooks
   landhook = hook.land ("land")
end

function land ()
   if planet.cur() == targetPlanet then
      local stringData=getStringData()

       tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

      misn.cargoJet(carg_id)

      misn.markerRm(landmarker)

      player.pay( payment )

      faction.modPlayerSingle( G.BETELGEUSE, 5 )
      player.addOutfit("Betelgian Courier",1)

      var.push("betelgeuse_1_done",true)

      hook.rm(landhook)
      misn.finish( true )
   end
end


function abort()
   misn.finish()
end
