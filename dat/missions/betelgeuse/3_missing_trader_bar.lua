
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = 200000

-- Mission Details
misn_title = "Rescue Betelgian trader"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Rescue the missing trader from ${targetPlanet} and bring him back to ${startPlanet}."

bar_desc="Rastapopoulos is sitting at a small table, looking uncharacteristically worried."

-- Messages
osd_msg = {}
osd_msg[1] = "Rescue the missing trader from ${targetPlanet} on ${targetSystem} system."
osd_msg[2] = "Bring him back to ${startPlanet} on ${startSystem} system."
osd_msg["__save"] = true

osd_msg_2 = {}
osd_msg_2[1] = "Rescue the missing trader from ${targetPlanet} on ${targetSystem} system."
osd_msg_2[2] = "Bring the letter back to ${startPlanet} on ${startSystem} system."
osd_msg_2["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "The Missing Trader"
text[1] = [[He immediately cheers up as he sees you arriving. "${playerName}! Lady Fortune sends you once again to my help! You're not just a decent trader, right? I've heard you are a good man for tough missions. And this one is not even about money..." he starts, agitated as always. 

"I sent a young trader, a gifted young Betelgian from an influential family, to ${targetPlanet}. It's a barely-mapped planet with a native species with interesting commercial potential... anyway, he went missing. I have a beacon for his landing spot and that's it. If you don't go and save him I'll lose my contracts with his family! Celestial craters, I'd be ruined! It's really a matter of life and death!", he pleads, looking more worried than you've ever seen him.]]

title[2] = "${playerName} to the Rescue"
text[2] = [[You negotiate a fee of ${payment} credits and you are on your way to ${targetPlanet}, system ${targetSystem}. ]]

title[3] = "Gone Native"
text[3] = [[You land the ${shipName} on a little field close to the beacon's location. Everything is deserted; you locate the missing trader's hut, but it's empty.

You are still inspecting it when you hear an unusual procession arriving at the site. At the head of a small group of ${nativesName}, a young Betelgian trader is riding a local animal, looking healthy and contented.

Over a herbal tea made from local plants, he explains his "disappearance". It turns out he has decided to leave his family and settle here, among the ${nativesName}. While he understands that you must report his situation, he insists he will not return home, and instead leaves you a letter for Rastapopoulos in which he describes the advantages of keeping a local trader here.]]

title[4] = "Expanding Trade"
text[4] = [[Rastapopoulos's anger at the news you bring quickly soften as he considers the implications. Ruffled feathers with the boy's family are more than compensated by the new commercial possibilities...

You leave with your ${payment} credits fee and the promise you'll be contacted again should the need arise.]]


function getStringData()
   local stringData={}
   stringData.playerName=player:name()
   stringData.shipName=player:ship()
   stringData.targetPlanet=targetPlanet:name()
   stringData.targetSystem=targetPlanet:system():name()
   stringData.startPlanet=startPlanet:name()
   stringData.startSystem=startPlanet:system():name()
   stringData.nativesName=nativesName
   stringData.payment=gh.numstring(payment)
   return stringData
end

function create ()

   targetPlanet=get_native_planet(system.cur(),3,7)

   if not targetPlanet then
      misn.finish()
   end

   local luaplanet=planet_class.load(targetPlanet)

   nativesName=luaplanet.lua.natives.name

   startPlanet=planet.cur()

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

  -- mission details
  misn.setTitle( gh.format(misn_title,stringData) )
  misn.setReward( gh.format(misn_reward,stringData)  )
  misn.setDesc( gh.format(misn_desc,stringData) )

  osd_msg = gh.formatAll(osd_msg,stringData)
  misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

     -- hooks
   landhook = hook.land ("land_target")
end

function land_target ()
   if planet.cur() == targetPlanet then
      local stringData=getStringData()

       tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

       misn.markerRm(landmarker)
       landmarker = misn.markerAdd( startPlanet:system(), "plot" )
       misn.osdDestroy()
      osd_msg_2[1]=gh.format(osd_msg_2[1],stringData)
      osd_msg_2[2]=gh.format(osd_msg_2[2],stringData)
      misn.osdCreate(gh.format(misn_title,stringData), osd_msg_2)
      misn.osdActive(2)

       hook.rm(landhook)
      landhook = hook.land ("land_final")
      
   end
end

function land_final()

  if planet.cur() == startPlanet then

    local stringData=getStringData()

    tk.msg( gh.format(title[4],stringData), gh.format(text[4],stringData) )

    misn.markerRm(landmarker)
    player.pay( payment )
    faction.modPlayerSingle( G.BETELGEUSE, 5 )
    player.addOutfit("Betelgian Explorer",1)
    var.push("betelgeuse_missions_3",true)

    hook.rm(landhook)
    misn.finish( true )
  end
end


function abort()
   misn.finish()
end
