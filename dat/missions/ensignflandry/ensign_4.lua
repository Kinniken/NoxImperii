include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = 20000

-- Mission Details
misn_title = "Capture Seafolk"
misn_reward = ""..payment.." cr"
misn_desc = "Take \"Charlie\", the Seafolk alien captured by Flandry, to ${targetPlanet} on ${targetSystem} for treatment."



-- Messages
osd_msg = {}
osd_msg[1] = "Take \"Charlie\" to ${targetPlanet}"
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "Commander Abrams' Office"
text[1] = [[You land at Highport and go looking for Commander Abrams. You find him at his desk, chewing one of his cigars and looking somber. "${playerName}, I've just had news from Ujanka. The city's been attacked - sea-folks crafts, plus a Ardar submarine using artillery. Only a very brash attack on that sub by our local hero prevented the city from falling. It's lucky Flandry was there on a diplomatic mission, with an armed flitter."

"There's one interesting development however. Not only did that rascal save the city, he managed to capture one of the attacker, and prevent the Toborkos from grilling him alive. We've been fighting a proxy war with them for months now and still know almost nothing about them - most of it from the Toborkos, who considers them almost animals. Maybe if we can question one we can figure out why they are lashing out at the Toborkos like that and what their relations with the Ardars really are. I've sent a team to bring him back here. Shouldn't take long.

Wait for the team to return?"]]

title[2] = "Highport Research Center"
text[2] =  [[After a few hours of waiting at the mess, a staff member comes to fetch you and take you to the base's research center, where the captured alien has been housed.

At the center of a soundproofed room, whose fluoros glared with Saxo light, the Siravo floats in a vitryl tank surrounded by machines.

He is big, 210 centimeters in length and thick of body. His skin is glabrous, deep blue on the back, paler greenish blue on the stomach, opalescent on the gillcovers. In shape he suggests a cross between dolphin, seal, and man. But the flukes, and the two flippers near his middle, were marvels of musculature with some prehensile capability. A fleshy dorsal fin grew above. Not far behind the head are two short, strong arms; except for vestigial webs, the hands are startlingly humanlike. The head is big and golden of eyes, blunt of snout, with quivering cilia flanking a mouth that had lips.

As you finally take your eyes of him, you notice Abrams discussing with what looks like a high-ranking aristocrat. "That'd be Lord Hauksberg." Flandry silently appeared next to you. He looks shaken - the battle at Ujanka must have been hard. "He's on the Imperial Council, sent to investigate Harkan. That means our little quarrels are starting to attract serious attention back on Terra.". The commander and him seem to be having a serious argument, though Abrams is clearly mindful of how over-ranked he is, while Lord Hauksberg argues with all the grace of a born aristocrat. "They've been discussing for a while. Abrams wants to hypnoprobe the alien. It might damage him, but we'd learn much. His Lordship wants to try a softer approach. Technically it's Commander Abrams's decision... but Hauksberg has a long, long arm.".

As the Lord leaves the room, Commander Abrams heads your way. "${playerName}, turns out we need you again. Our "friend" here seems wounded and I'm under orders to keep him alive and cooperative. I need you to take him to ${targetPlanet} for treatment. We know little of his biology but they have a good multi-species hospital there. Bring him back in top shape. If His Lordship is right he might help us understand the conflict. If he isn't we'll do it my way."]]

title[3] = "${targetPlanet} Hospital Complex"
text[3] =  [[Accompanying you on the trip is Abrams' finest xenologist. She spends the journey locked up in the hatch where "Charlie" - as the alien has been nicknamed by Abrams - has been installed. With the experience accumulated in understanding the thousands of alien languages Mankind has encountered, the specialist manages to assimilate the rudiments of the alien's language.

Exchanges between Charlie, her and you remain limited, halting and frustrating. It is still hard not to be impressed by the apparent self-control of the alien, a pre-technology, sea-dwelling sophont suddenly finding himself kidnapped away from his world.

You feel a pang of regret when you deliver him to ${targetPlanet}'s hospital complex. The Intelligence agent in charge of supervising the transfer instructs you to be back in a week to check on the patient.]]

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.targetPlanet=targetPlanet:name()
	stringData.targetSystem=targetPlanet:system():name()

	return stringData
end

function create ()
	if not planet.cur()==planet.get("Harkan") then
		misn.finish()
	end

	targetPlanet=planet.get("Imhotep")

	local stringData=getStringData()
	
	if not tk.yesno( gh.format(title[1],stringData), gh.format(text[1],stringData) ) then
		misn.finish()
	end

	misn.accept()


	var.push("ensign_4_started",true)

	local stringData=getStringData()

	tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

	landmarker = misn.markerAdd( targetPlanet:system(), "plot" )

	  -- mission details
	  misn.setTitle( gh.format(misn_title,stringData) )
	  misn.setReward( gh.format(misn_reward,stringData)  )
	  misn.setDesc( gh.format(misn_desc,stringData) )

	  osd_msg[1] = gh.format(osd_msg[1],stringData)
  		misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

  		carg_id = misn.cargoAdd( "Captured Seafolk", 0 )

	  -- hooks
	  landhook = hook.land ("land")
end

function land ()
   if planet.cur() == planet.get("Imhotep") then
   	  local stringData=getStringData()

   	  tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

   	  player.pay( payment )

      misn.cargoJet(carg_id)

      hook.rm(landhook)
      misn.finish( true )
   end
end


function abort()
   misn.finish()
end