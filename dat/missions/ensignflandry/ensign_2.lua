
include "universe/generate_helper.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/missions/supportfiles/pirates.lua"

payment = 50000

-- Mission Details
misn_title = "Deliver Weapons"
misn_reward = ""..payment.." cr"
misn_desc = "Collect weapons from ${pickupPlanet} and deliver them to the Toborkos on Starkad."



-- Messages
osd_msg = {}
osd_msg[1] = "Collect weapons from ${pickupPlanet}."
osd_msg[2] = "Return to Starkad."
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "Commander Abrams' Office"
text[1] = [["Captain ${playerName}. I am Commander Max Abrams, Imperial Naval Intelligence Corps, in charge of this garrison. Flandry had a lot to say about you, and not just about your little incident in Navy School.", the Commander starts as you enter his office. He is a stocky man, hair grizzled, face big and hooknosed. His uniform is rumpled, tunic collar open, twin planets of his rank tarnished on the wide shoulders, blaster at belt.

"I expect he briefed out about the general situation, and his little maritime adventures. The attack on the Toborko ship he helped push back is but one of many. Our allies need more weapons to help fight back, and yet I can't just ask for Imperial supplies - Merseia would know and use that as an excuse to escalate further. There's a nearby independent world, ${pickupPlanet}, that will serve as an intermediary. We just need you to pickup the weapons from there and deliver them directly to the nearby Toborko city. Officially, the Empire isn't involved, understood?"]]

title[2] = "${pickupPlanet} Spaceport"
text[2] = [[As you land on ${pickupPlanet}, a shady-looking man is waiting for you. He signals you over, and dock workers start loading weapon crates in your ship. Time to head back to Starkad. Curiosity tickles you - your contact is Dragoika, the very captain whose ship rescued Flandry, and apparently an important member of the Sisterhood organization that runs the city.]]

title[3] = "Incoming Pirates"
text[3] = [[As you liftoff from ${pickupPlanet}, your ship's computer suddenly flashes an alert: hostile ship inbound! It looks like a pirate, and is heading straight for you.]]

title[4] = "City of Ujanka"
text[4] = [[Following the instructions, you land close to the city of Ujanka. The principal seaport of Kurijsoviki stands on Golden Bay, ringed by hills and slashed by lithe broad brown Pechaniki River. In the West Housing the Sisterhood kept headquarters. Northward and upward, the High Housing is occupied by the homes of the wealthy, each nestled into hectares of trained jungle where flowers and wings and venomous reptiles vied in coloring. But despite her position--not merely captain of a ship but shareholder in a kin-corporation owning a whole fleet, and speaker for it among the Sisterhood--Dragoika lives in the ancient East Housing, on Shiv Alley itself.

Waiting for you is one of her sailor. The land Starkadian, Tigery, Toborko, or whatever you wanted to call him, is built not unlike a short man with disproportionately long legs. His hands are four-fingered, his feet large and clawed, he flaunts a stubby tail. The head is less anthropoid, round, with flat face tapering to a narrow chin. The eyes are big, slanted, scarlet in the iris, beneath his fronded tendrils. The nose, what there was of it, has a single slit nostril. The mouth is wide and carnivore-toothed. The ears are likewise big, outer edges elaborated till they almost resemble bat wings. Sleek fur covers his skin, black-striped orange that shade into white at the throat. With a few words of greeting, he escorts you inside the city to meet Dragoika.

As she welcomes you to her house, you understand Flandry's fascination - she has curves, a tawny mane rippling down her back, breasts standing fuller and firmer than any girl could have managed without technological assistance, and a nearly humanoid nose. Her clothing consists of some gold bracelets. But her differences from the Terran are deeper than looks. She doesn't lactate; those nipples feed blood directly to her infants. And hers is the more imaginative, more cerebral sex, not subordinated in any culture, dominant in the islands around Ujanka.

You soon find yourself in her reception room, while porters go and unload the crates from your ship. When you leave a few hours later, it is in a daze - the Toborkos might be primitive, but what a race! Adventurous, courageous but not bloodthirsty, civilized without the decadence of the Empire... surely a specie worth helping.

Time to head back to Highport.]]

title[5] = "Highport"
text[5] = [[As you land on Highport, Commander Abrams is waiting for you. He pays you your ${payment} credits while you describe the mission.

"Sure that pirate ship was looking for you? That's worrying. Until now Merseians had not dared target our ships, even via 'intermediaries'. Well... If that's how they want to play... I also have intel on the greentails' supply ships." says Abrams, waving his lighted cigar around. "You can consider you have an open-ended job in getting more weapons to the Toborkos. Expect more pirates on the way. And I'll let you know whenever I hear of Merseian convoys to Starkad. You'll be notified via the mission computer on imperial worlds."]]

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.pickupPlanet=pickupPlanet:name()
	stringData.pickupSystem=pickupPlanet:system():name()
	stringData.payment=payment

	return stringData
end

function create ()
	if not planet.cur()==planet.get("Starkad") then
		misn.finish()
	end

	pickupPlanet=get_faction_planet(system.cur(),"Independent",2,7)

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

   	  carg_id = misn.cargoAdd( "Primitive Armament", 10 )

   	  misn.markerRm(landmarker)
   	  landmarker = misn.markerAdd( planet.get("Starkad"):system(), "plot" )

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
   if planet.cur() == planet.get("Starkad") then
   	local stringData=getStringData()

      tk.msg( gh.format(title[4],stringData), gh.format(text[4],stringData) )

      misn.cargoJet(carg_id)

      tk.msg( gh.format(title[5],stringData), gh.format(text[5],stringData) )

      player.pay( payment )

      var.push("ensign_3_start_time",time.tonumber(time.get() + time.create( 0, 100, 0 )))

      hook.rm(landhook)
      misn.finish( true )
   end
end

function abort()
   misn.finish()
end
