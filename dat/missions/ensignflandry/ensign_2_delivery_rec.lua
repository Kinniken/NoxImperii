
include "universe/generate_helper.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/missions/supportfiles/pirates.lua"

payment = 30000

-- Mission Details
misn_title = "Harkan: Weapon delivery"
misn_reward = ""..payment.." cr"
misn_desc = "Collect weapons from ${pickupPlanet} and deliver them to the Toborkos on Harkan."



-- Messages
osd_msg = {}
osd_msg[1] = "Collect weapons from ${pickupPlanet}."
osd_msg[2] = "Return to Harkan."
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "${pickupPlanet} Spaceport"
text[1] = [[As you land on ${pickupPlanet}, a shady-looking man is waiting for you. He signals you over, and dock workers start loading weapon crates in your ship. Time to head back to Harkan.]]


title[2] = "City of Ujanka"
text[2] = [[Once again, you land close to the city of Ujanka. Dragoika is waiting for you and supervises the unloading of the weapons while updating you of the latest conflicts. The death toil seems to be rising inexorably on both side, as Ardarshir and the Empire continue to supply weapons to their allies.

You can feel an ashen taste in your mouth as you leave the city.]]

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.pickupPlanet=pickupPlanet:name()
	stringData.pickupSystem=pickupPlanet:system():name()
	stringData.payment=payment

	return stringData
end

function create ()

	pickupPlanet=get_faction_planet(system.get("Saxo"),G.INDEPENDENT_WORLDS,2,7)

	if not pickupPlanet then
		misn.finish()
	end

	local stringData=getStringData()

	target_ship_name, target_ship, target_ship_outfits,target_ship_ai,target_ship_faction = pir_generate()

	landmarker = misn.markerAdd( pickupPlanet:system(), "low" )

  -- mission details
  misn.setTitle( gh.format(misn_title,stringData) )
  misn.setReward( gh.format(misn_reward,stringData)  )
  misn.setDesc( gh.format(misn_desc,stringData) )

  osd_msg[1] = gh.format(osd_msg[1],stringData)
 	osd_msg[2] = gh.format(osd_msg[2],stringData)
 	
	  
end

-- Mission is accepted
function accept()
  misn.accept()
    misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

    -- hooks
    landhook = hook.land ("land_pickup")
end

function land_pickup ()
   if planet.cur() == pickupPlanet then
   		local stringData=getStringData()

   	  tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )

   	  carg_id = misn.cargoAdd( C.PRIMITIVE_ARMAMENT, 10 )

   	  misn.markerRm(landmarker)
   	  landmarker = misn.markerAdd( planet.get("Harkan"):system(), "low" )

   	  misn.osdActive(2)

      hook.rm(landhook)
      landhook = hook.land ("land_final")
      syshook = hook.enter ("sys_enter")
   end
end

-- Entering a system
function sys_enter()

  cur_sys = system.cur()

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
  ship:setVisplayer(true)
  ship:setHilight(true)
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

      tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

      misn.cargoJet(carg_id)
      player.pay( payment )

      hook.rm(landhook)
      misn.finish( true )
   end
end

function abort()
   misn.finish()
end
