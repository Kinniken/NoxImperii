include "numstring.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/missions/supportfiles/traders.lua"
include "pilot/pilots_ardarshir.lua"

payment = 50000

-- Mission Details
misn_title = "To Ardarshir"
misn_reward = ""..payment.." cr"
misn_desc = "Take Shadowlines to the Roidhunate's capital on Ardarshir."


-- Messages
osd_msg = {}
osd_msg[1] = "Head back to ${startPlanet} in ${startSystem} system."
osd_msg["__save"] = true

osd_msg_2 = {}
osd_msg_2[1] = "Head back to ${startPlanet} in ${startSystem} system."
osd_msg_2[2] = "Take Shadowlines to Ardarshir"
osd_msg_2["__save"] = true

start_message = "Auxiliary ${playerName}, report to ${startPlanet} on ${startSystem} immediately, on order of the Ardar High Command."

start_title = "Ardar Intelligence"
start_text = [[As you land, you are immediately directed to a secured building on the edge of the spaceport. In a stark empty room a tall Ardar awaits you, wearing a severe uniform you do not recognise. "Auxiliary ${playerName}. You may salute me as Cell Leader Meldar. I have worked with your kind before.", he starts in a flat, slightly hissing Terran. "We will speak your language since your kind rarely knows Ardar. That will change, in good time. You have served us well by bringing us the avian prisoner. She could have been very helpful to the Imperials, had they known how to use her. Still, her capture is a clear sign we need to accelerate our plans. The Empire is slow... but it does move, eventually.

The avian prisoner will serve our needs now. We will train her, make her a proper auxiliary of the Roidhunate. She must report on Ardarshir immediately. She has requested that you transport her, a mark of worrying sentimentality but a favour we can easily grant. Go now, and don't disappoint the Roidhunate."

The Ardar officer slaps his heavy tail on the floor in a clear gesture of dismissal.]]

success_title = "The Winged Princess and the Scaly King"
success_text = [[You are instructed to land in a military spaceport near the Ardar capital. A guard of elite Ardar troops great Shadowlines in a display worthy of the Imperial court; she is whisked away to an estate in the outskirts of the city in no time. You spend the next few days at the spaceport, hearing only rumours of her activities, until you are suddenly provided a fancy-looking Ardar uniform and made to board a floater headed for the royal palace.

Without any of the guards answering your questions, you end up in a small crowd in the palace's throne room, mixing up with Roidhunate nobility, Ardar and non-Ardar alike. The Roidhun in person makes his appearance under the ceremonial hisses of the Ardar guards. Not long after you see Shadowlines, impressively calm and decked in ill-fitting Ardar ceremony clothes, spread her magnificent wings in front of him. The brief ceremony might be held in ardar, its meaning is clear: the Roidhun has recognised Shadowlines as ruler of Harkan and she in turn has sworn fealty to him. Harkan had just become an Ardar protectorate.

When you return to the spaceport, an Ardar ensign is waiting for you. You are paid your ${payment} credits and dismissed for now; you will be called back when you are needed again.]]

function getStringData()
  local stringData={}
  stringData.playerName=player:name()
  stringData.startPlanet=start_planet and start_planet:name() or ""
  stringData.startSystem=start_planet and start_planet:system():name() or ""
  stringData.targetPlanet=target_planet and target_planet:name() or ""
  stringData.targetSystem=target_planet and target_planet:system():name() or ""
  stringData.payment=payment
  return stringData
end

function create ()
	if not has_system_faction_planet(system.cur(),G.ROIDHUNATE) then
		misn.finish()
	end

	misn.accept()

	start_planet=planet.get(var.peek("harkan_roidhunate_planet"))
	target_planet=planet.get("Ardarshir")

	local stringData=getStringData()

	player.msg(gh.format(start_message,stringData))

	-- mission details
	misn.setTitle( misn_title )
	misn.setDesc( misn_desc )

	osd_msg[1] = gh.format(osd_msg[1],stringData)
	misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

	landmarker = misn.markerAdd( start_planet:system(), "plot" )

	-- hooks
	landhook = hook.land ("land")
end

function land()

	if not planet.cur() == start_planet then
		return
	end

	local stringData=getStringData()

	tk.msg( gh.format(start_title,stringData), gh.format(start_text,stringData) )

	carg_id = misn.cargoAdd( "Shadowlines", 0 )

	misn.osdDestroy()
	osd_msg_2[1]=gh.format(osd_msg_2[1],stringData)
	osd_msg_2[2]=gh.format(osd_msg_2[2],stringData)
	misn.osdCreate(gh.format(misn_title,stringData), osd_msg_2)
	misn.osdActive(2)

	misn.markerMove(landmarker,target_planet:system())

	hook.rm(landhook)
	landhook = hook.land ("land2")
end

function land2 ()
	if not planet.cur() == target_planet then
		return
	end

	local stringData=getStringData()

	tk.msg( gh.format(success_title,stringData), gh.format(success_text,stringData) )

	misn.cargoJet(carg_id)

	player.pay(payment)

	faction.modPlayerSingle( G.ROIDHUNATE, 2 )

	var.push("harkan_roidhunate_7_start_time",time.tonumber(time.get() + time.create( 0,0,15, 0, 0, 0 )))

	hook.rm(landhook)
	misn.finish( true )
end

function abort()
   misn.finish()
end