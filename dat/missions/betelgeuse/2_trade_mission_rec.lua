
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

computer_title  = "BETELGEUSE: Supply ${quantity}t of ${commodity} to ${startPlanet}"

-- Mission Details
misn_title = "Supply ${commodity}"
misn_desc = "Supply ${quantity} tonnes of ${commodity} to ${startPlanet}."

-- Messages
osd_msg = {}
osd_msg[1] = "Supply ${quantity}t of ${commodity} to ${startPlanet} on ${startSystem}."
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "Profitable Trade"
text[1] = [[The Betelgian trader in charge of receiving the order does a quick inspection of the ${quantity} tonnes of ${commodity} and judges the quality acceptable. Your payment of ${payment} credits clears quickly, and the trader and you toast the good deal with a bottle of good Betelgian wine.]]


function getStringData()
   local stringData={}
   stringData.playerName=player:name()
   stringData.startPlanet=startPlanet:name()
   stringData.startSystem=startPlanet:system():name()
   stringData.payment=payment
   stringData.quantity=quantity
   stringData.commodity=commodityName
   return stringData
end

function create ()

  local commodities={C.GOURMET_FOOD, C.BORDEAUX, C.TELLOCH, C.EXOTIC_FURS, C.NATIVE_ARTWORK, C.NATIVE_SCULPTURES, C.NATIVE_WEAPONS, C.NATIVE_TECHNOLOGY}

  quantity = 10+math.floor(math.random()*20)

  commodityName=commodities[math.floor(#commodities*math.random())+1]

  payment = commodity.get(commodityName):price()*2*quantity
  misn_reward = gh.numstring(payment).." cr"

  startPlanet = planet.cur()

  local stringData=getStringData()

  misn.setTitle( gh.format(misn_title,stringData))
  misn.setDesc(gh.format(misn_desc,stringData))
  misn.markerAdd(startPlanet:system(), "computer")

  misn.setReward(misn_reward)

end

function accept()
   local stringData=getStringData()

   misn.accept()

  osd_msg = gh.formatAll(osd_msg,stringData)
  misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

     -- hooks
   landhook = hook.land ("land")
end

function land ()
   if planet.cur() == startPlanet and player.quantityCargo(commodityName) >= quantity then
      local stringData=getStringData()

      tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )

      player.pay( payment )
      player.addCargo(commodityName,-quantity)

      faction.modPlayerSingle( G.BETELGEUSE, 2 )

      hook.rm(landhook)
      misn.finish( true )
   end
end


function abort()
   misn.finish()
end
