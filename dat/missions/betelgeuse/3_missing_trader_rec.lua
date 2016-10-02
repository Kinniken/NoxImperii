
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = math.random(10,30)*10000

-- Mission Details
misn_title = "Rescue Betelgian trader"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Rescue the missing trader from ${targetPlanet} and bring him back to ${startPlanet}."

computer_title  = "BETELGEUSE: Rescue trader from ${targetPlanet}"

-- Messages
osd_msg = {}
osd_msg[1] = "Rescue the missing trader from ${targetPlanet} on ${targetSystem} system."
osd_msg[2] = "Bring him back to ${startPlanet} on ${startSystem} system."
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "A Lucky Rescue"
text[1] = [[The area around the beacon is a wild land indeed, and locating the missing trader is tough work. You end up finding him in a makeshift hut, his leg broken and in very poor health. He haltingly describe how he injured himself while surveying the area and was unable to return to his ship. 

You take him back to the ${shipName} in a hurry.]]

title[2] = "Home Again"
text[2] = [[As you land on ${startPlanet}, the young trader's family crowd him, looking very relieved at his safe return.

The family head meets you a little while later, handing you your ${payment} credits along with all his thanks.]]

function getStringData()
   local stringData={}
   stringData.playerName=player:name()
   stringData.shipName=player:ship()
   stringData.targetPlanet=targetPlanet:name()
   stringData.targetSystem=targetPlanet:system():name()
   stringData.startPlanet=startPlanet:name()
   stringData.startSystem=startPlanet:system():name()
   stringData.nativesName=nativesName
   stringData.payment=payment
   return stringData
end

function create ()

   targetPlanet=get_native_planet(system.cur(),5,8)

   if not targetPlanet then
      misn.finish()
   end

   local luaplanet=planet_class.load(targetPlanet)

   nativesName=luaplanet.lua.natives.name

   startPlanet=planet.cur()

   landmarker = misn.markerAdd( targetPlanet:system(), "computer" )

   local stringData=getStringData()

    -- mission details
    misn.setTitle( gh.format(computer_title,stringData) )
    misn.setReward( gh.format(misn_reward,stringData)  )
    misn.setDesc( gh.format(misn_desc,stringData) )


end

function accept()
   local stringData=getStringData()

   misn.accept()

   misn.setTitle( gh.format(misn_title,stringData) )

  osd_msg = gh.formatAll(osd_msg,stringData)
  misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

     -- hooks
   landhook = hook.land ("land_target")
end

function land_target ()
   if planet.cur() == targetPlanet then
      local stringData=getStringData()

       tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )

       misn.markerRm(landmarker)
       landmarker = misn.markerAdd( startPlanet:system(), "low" )
       misn.osdActive(2)

       hook.rm(landhook)
      landhook = hook.land ("land_final")
      
   end
end

function land_final()

  if planet.cur() == startPlanet then

    local stringData=getStringData()

    tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

    misn.markerRm(landmarker)
    player.pay( payment )
    faction.modPlayerSingle( G.BETELGEUSE, 3 )

    hook.rm(landhook)
    misn.finish( true )
  end
end


function abort()
   misn.finish()
end
