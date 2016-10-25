
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = commodity.get( C.GOURMET_FOOD ):price()*20*2

-- Mission Details
misn_title = "The Lord's Banquet"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Find 20 tonnes of Gourmet food for Lord Morizo and deliver them to ${startPlanet}."

bar_desc="You notice Rastapopoulos sitting at one of the bar's tables, agitated once more."

-- Messages
osd_msg = {}
osd_msg[1] = "Supply 20t of gourmet food to ${startPlanet} on ${startSystem}."
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "Exotic Tastes"
text[1] = [[He notices you approaching and turns toward you. "Ahah, the resourceful ${playerName}! You've come to sort out my problems for a very reasonable fee, have you? You are in luck! Lord Morizo is in dire need of exotic gourmet food for his banquet and I cannot locate enough of it."

This time you are ready and negotiate a good deal: you'll fetch Rastapopoulos his twenty tonnes of exotic food, and he'll buy them for ${payment} credits total - 100% above the standard rate. Where you get them is up to you; you can steal them for all he cares.]]

title[2] = "A King's Ransom for a Lord's Banquet"
text[2] = [[You meet Rastapopoulos at the spaceport with the requested food. He inspects it thoroughly, and makes an attempt at reducing your fee for imaginary defects. Faced with your refusal, he pays you your ${payment} credits and leaves angrily. You are quite sure you heard him mutter "treacherous two-bit turncoat!" as he left.]]



function getStringData()
   local stringData={}
   stringData.playerName=player:name()
   stringData.startPlanet=startPlanet:name()
   stringData.startSystem=startPlanet:system():name()
   stringData.payment=gh.numstring(payment)
   return stringData
end

function create ()
   -- creates the NPC at the bar to create the mission
   misn.setNPC( "Rastapopoulos", "neutral/unique/aristocrat" )
   misn.setDesc( bar_desc )
end

function accept()
  startPlanet=planet.cur()

   local stringData=getStringData()

   if not tk.yesno( gh.format(title[1],stringData), gh.format(text[1],stringData) ) then
      misn.finish()
   end

   misn.accept()

   landmarker = misn.markerAdd( startPlanet:system(), "plot" )

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
   if planet.cur() == startPlanet and player.quantityCargo(C.GOURMET_FOOD) >= 50 then
      local stringData=getStringData()

      tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

      misn.markerRm(landmarker)

      player.pay( payment )
      player.pilot():cargoRm(C.GOURMET_FOOD,50)

      faction.modPlayerSingle( G.BETELGEUSE, 5 )
      player.addOutfit("Betelgian Trader",1)
      var.push("betelgeuse_missions_2",true)

      hook.rm(landhook)
      misn.finish( true )
   end
end


function abort()
   misn.finish()
end
