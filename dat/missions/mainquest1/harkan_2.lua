
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/missions/supportfiles/pirates.lua"

payment = 100000

-- Mission Details
misn_title = "Deliver Weapons"
misn_reward = ""..payment.." cr"
misn_desc = "Collect weapons from ${pickupPlanet} and deliver them to the Toborkos on Harkan."



-- Messages
osd_msg = {}
osd_msg[1] = "Collect weapons from ${pickupPlanet}."
osd_msg[2] = "Return to Harkan."
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "Commander Suarez' Office"
text[1] = [["Captain ${playerName}. I am Commander Suarez, Imperial Naval Intelligence Corps, in charge of this garrison. Beauval had a lot to say about you, and not just about your little incident in Navy School.", the Commander starts as you enter his office. He is a stocky man, darkly tanned, with a permanent frown on his broad face. His uniform is rumpled, his collar open, and the bars of his ranks are tarnished on his shoulders.

"I expect he briefed out about the general situation and his little adventures. The attack he helped push back is but one of many. Our allies need more weapons to help fight back, and yet I can't just ask for Imperial supplies - Ardarshir would know and use that as an excuse to escalate further. There's a nearby independent world, ${pickupPlanet}, that will serve as an intermediary. We just need you to pick up the weapons from there and deliver them directly to the nearby Tigaray city. Officially, the Empire isn't involved, understood?"]]

title[2] = "${pickupPlanet} Spaceport"
text[2] = [[As you land on ${pickupPlanet}, a shady-looking man is waiting for you. He signals you over, and dock workers start loading weapon crates in your ship. Time to head back to Harkan. Curiosity tickles you - you'll be meeting the Tigaray prince saved by Beauval. Apparently he's quite the character.]]

title[3] = "Incoming Pirates"
text[3] = [[As you lift-off from ${pickupPlanet}, your ship's computer suddenly flashes an alert: hostile ship inbound! It looks like a pirate, and is heading straight for you.]]

title[4] = "City of Japor"
text[4] = [[Following the instructions, you land close to the city of Japor, among the largest Tigaray city on Harkan; like most Tigaray cities, it is coastal - the mountainous areas being the strongholds of their ancestral rivals the Yrens. Handsomely build of a local white stone, it spreads around a natural harbour and up the flanks of the surrounding hills; it looks somewhat like human cities, but more spread-out and less organised, more a collection of individual dwellings than a true city.

A Tigaray of the prince's retinue is waiting for you. Tall and lean, he is bipedal but leans forward, as if ready to surge forward on all fours like his ancestors; he is covered in sand-coloured fur and his eyes, much bigger than those of a human, seem designed for nocturnal vision. Without a word, he gestures you to follow and takes you to the prince's estate.

Tigaray Princes on Harkan are not just military leaders but also great traders, and the prince's estate reflect this - passing through rooms lighted by flickering torches, you glance at artwork and treasures from what must be all the main Tigaray cultures on the world. Here and there, you even see delicate wood and bone carvings whose radically different style point to another origin - Yren work, secured through trade or plunder.

Prince Haka himself is small for a Tigaray, but an impressive presence nonetheless; the "audience" lasts several hours as you trade stories with him, your AI translator struggling to keep up. Your travels throughout the Galaxy seems almost small compared to his stories of far-away naval explorations. His demeanour turns sombre only when discussing the Yrens; the hatred and fear he feels for the bird-like sophonts clearly runs deep, and he makes it clear he will need much more military help in the escalating struggle.

Time to head back to Harkan Outpost.]]

title[5] = "Harkan Outpost"
text[5] = [[As you land on Harkan Outpost, Commander Suarez is waiting for you. He pays you your ${payment} credits while you describe the mission.

"Sure that pirate ship was looking for you? That's worrying. Until now Ardars had not dared target our ships, even via 'intermediaries'. Well... If that's how they want to play... I also have intel on the greentails' supply ships." says Suarez, waving his lighted cigar around. "You can consider you have an open-ended job in getting more weapons to the Tigaray. Expect more pirates on the way. And I'll let you know whenever I hear of Ardar convoys to Harkan. You'll be notified via the mission computer on imperial worlds."]]

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.pickupPlanet=pickupPlanet:name()
	stringData.pickupSystem=pickupPlanet:system():name()
	stringData.payment=payment

	return stringData
end

function create ()
	if not planet.cur()==planet.get("Harkan") then
		misn.finish()
	end

	pickupPlanet=get_faction_planet(system.cur(),G.INDEPENDENT_WORLDS,2,7)

	if not pickupPlanet then
		misn.finish()
	end

	local stringData=getStringData()

	if not tk.yesno( gh.format(title[1],stringData), gh.format(text[1],stringData) ) then
		misn.finish()
	end

	misn.accept()

	target_ship_name, target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = pir_generate()

	landmarker = misn.markerAdd( pickupPlanet:system(), "plot" )

	  -- mission details
	  misn.setTitle( gh.format(misn_title,stringData) )
	  misn.setReward( gh.format(misn_reward,stringData)  )
	  misn.setDesc( gh.format(misn_desc,stringData) )

	  osd_msg[1] = gh.format(osd_msg[1],stringData)
   		osd_msg[2] = gh.format(osd_msg[2],stringData)
   		misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

	  -- hooks
	  landhook = hook.land ("land_pickup")
end

function land_pickup ()
   if planet.cur() == pickupPlanet then
   		local stringData=getStringData()

   	  tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

   	  carg_id = misn.cargoAdd( C.PRIMITIVE_ARMAMENT, 10 )

   	  misn.markerRm(landmarker)
   	  landmarker = misn.markerAdd( planet.get("Harkan"):system(), "plot" )

   	  misn.osdActive(2)

      hook.rm(landhook)
      landhook = hook.land ("land_final")
      syshook = hook.enter ("sys_enter")
   end
end

-- Entering a system
function sys_enter()
   cur_sys = system.cur()

   local stringData=getStringData()

   if not pirate_message_shown then
   	print(stringData)
   	print(title[3])
   	tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )
   	pirate_message_shown=true
   end

  -- Choose position
  local pos = player.pilot():pos()
  local x,y = pos:get()
  local d = rnd.rnd( 800, 1200 )
  local a = math.atan2( y, x ) + math.pi
  local offset = vec2.new()
  offset:setP( d, a )
  pos = pos + offset

  -- Create the badass enemy
  p     = pilot.addRaw( target_ship, target_ship_ai, pos, target_ship_faction )

  ship   = p[1]
  ship:rename(target_ship_name)
  ship:setHostile()
  ship:rmOutfit("all") -- Start naked
  pilot_outfitAddSet( ship, target_ship_outfits )
  hook.pilot( ship, "death", "ship_dead" )

  last_sys=cur_sys

end

-- Ship is dead
function ship_dead( pilot, attacker )
    hook.rm(syshook)-- won't spawn anymore
end

function land_final ()
   if planet.cur() == planet.get("Harkan") then
   	local stringData=getStringData()

      tk.msg( gh.format(title[4],stringData), gh.format(text[4],stringData) )

      misn.cargoJet(carg_id)

      tk.msg( gh.format(title[5],stringData), gh.format(text[5],stringData) )

      player.pay( payment )

      faction.modPlayerSingle( G.EMPIRE, 2 )

      var.push("harkan_3_start_time",time.tonumber(time.get() + time.create( 0,1,0, 0, 0, 0 )))

      hook.rm(landhook)
      misn.finish( true )
   end
end

function abort()
   misn.finish()
end
