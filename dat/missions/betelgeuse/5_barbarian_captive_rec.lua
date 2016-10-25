
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = math.random(5,8)*100000

-- Mission Details
misn_title = "Rescue the Betelgian captive from ${targetPlanet}"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Rescue the Betelgian captive from ${targetPlanet} on ${targetSystem}."

computer_title  = "BETELGEUSE: Rescue captive from ${targetPlanet}"

-- Messages
osd_msg = {}
osd_msg[1] = "Bribe your way into ${targetPlanet} to free the captive."
osd_msg[2] = "Return to ${startPlanet} with him."
osd_msg["__save"] = true


title = {}  --stage titles
text = {}   --mission text

title[1] = "Bribable Jailers"
text[1] = [[A few bribes go a long way on barbarian worlds, and ${targetPlanet} is no exception. You are soon landed on the main spaceport under a false identity.

It takes little time for one of your crew member to locate the jail where the Betelgian captive is held, and not much more for a few of the guards to be quietly silenced. Time to head back.]]

title[2] = "Home Sweet Home"
text[2] = [[Working your way around Barbarian fleets, you soon reach ${startPlanet}. The captive's family is there to welcome him and give you a hero's welcome.

You've more than earned your ${payment} credits fee and the gratitude of one more Betelgian house.]]


function getStringData()
   local stringData={}
   stringData.playerName=player:name()
   stringData.shipName=player:ship()
   stringData.targetPlanet=targetPlanet:name()
   stringData.targetSystem=targetPlanet:system():name()
   stringData.startPlanet=startPlanet:name()
   stringData.startSystem=startPlanet:system():name()
   stringData.payment=gh.numstring(payment)
   return stringData
end

function create ()
   targetPlanet=get_faction_planet(system.cur(),G.BARBARIANS,5,8)
   startPlanet=planet.cur()

   landmarker = misn.markerAdd( targetPlanet:system(), "computer" )

   local stringData=getStringData()

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
    faction.modPlayerSingle( G.BETELGEUSE, 5 )

    hook.rm(landhook)
    misn.finish( true )
  end
end


function abort()
   misn.finish()
end
