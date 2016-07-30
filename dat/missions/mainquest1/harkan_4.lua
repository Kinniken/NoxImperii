include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = 50000

-- Mission Details
misn_title = "Capture Avian"
misn_reward = ""..payment.." cr"
misn_desc = "Take \"Chicken\", the Yren alien captured by Beauval, to ${targetPlanet} on ${targetSystem} for treatment."



-- Messages
osd_msg = {}
osd_msg[1] = "Take \"Chicken\" to ${targetPlanet}"
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "Commander Suarez' Office"
text[1] = [[You land at Harkan Outpost and go looking for Commander Abrams. You find him at his desk, chewing one of his cigars and looking sombre. "${playerName}, I've just had news from Japor. The city's been attacked - Yren commandos equipped with Ardar-provided mortars; they managed to take positions on the hills above the city and subjected it to intense bombardment. Luckily Beauval was there on a diplomatic mission with an armed flyer and was able to silence them before they did too much damage."

"There's one interesting development however. Not only did that rascal save the city, he managed to capture one of the attacker, and prevent the Tigaray from grilling him alive. We've been fighting a proxy war with them for months now and still know almost nothing about them - most of it from the Tigaray, who considers them more demons than people. Maybe if we can question one we can figure out why they are lashing out at the Tigaray like that and what their relations with the Ardars really are. I've sent a team to bring him back here. Shouldn't take long.

Wait for the team to return?"]]

title[2] = "Harkan Outpost Research Center"
text[2] =  [[After a few hours of waiting at the mess, a staff member comes to fetch you and take you to the base's research center, where the captured alien has been housed.

Tied down on a clinical bed, the Yren is not impressive - save for his folded wings. Short, maybe a metre and a half, skinny-looking with a leathery brown skin, he reminds you more of a bat than a bird. Only his wings break that impression: large but airy-looking, covered in what looks like very fine hairs, they shimmer with colours, giving the alien the odd look of a giant butterfly pinned on a board. He looks at you as you enter the the room, his gaze darting quickly from human to human.

Commander Suarez turns your way. "${playerName}, turns out we need you again. Our "friend" here is wounded and I'm under orders to keep him alive and cooperative. I need you to take him to ${targetPlanet} for treatment. We know little of his biology but they have a good multi-species hospital there. Bring him back in top shape. We hope to interrogate him peacefully - though if this fails, we'll try the probes."]]

title[3] = "${targetPlanet} Hospital Complex"
text[3] =  [[Accompanying you on the trip is Suarez ' finest xenologist. She spends the journey locked up in the hatch where "Chicken" - as the alien has been nicknamed by Suarez - has been installed. With the experience accumulated in understanding the thousands of alien languages Mankind has encountered, the specialist manages to assimilate the rudiments of the alien's language.

Exchanges between Chicken, her and you remain limited, halting and frustrating. It is still hard not to be impressed by the apparent self-control of the alien, a pre-technology sophont suddenly finding himself kidnapped away from his world.

You feel a pang of regret when you deliver him to ${targetPlanet}'s hospital complex. The Intelligence agent in charge of supervising the transfer instructs you to be back in a week to check on the patient.]]

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.targetPlanet=targetPlanet:name()
	stringData.targetSystem=targetPlanet:system():name()

	return stringData
end

function create ()
	if not (planet.cur()==planet.get("Harkan")) then
		misn.finish()
		return
	end

	targetPlanet=planet.get("Fez")

	local stringData=getStringData()
	
	if not tk.yesno( gh.format(title[1],stringData), gh.format(text[1],stringData) ) then
		misn.finish()
	end

	misn.accept()


	var.push("harkan_4_started",true)

	local stringData=getStringData()

	tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

	landmarker = misn.markerAdd( targetPlanet:system(), "plot" )

	  -- mission details
	  misn.setTitle( gh.format(misn_title,stringData) )
	  misn.setReward( gh.format(misn_reward,stringData)  )
	  misn.setDesc( gh.format(misn_desc,stringData) )

	  osd_msg[1] = gh.format(osd_msg[1],stringData)
  		misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

  		carg_id = misn.cargoAdd( "Captured Avian", 0 )

	  -- hooks
	  landhook = hook.land ("land")
end

function land ()
   if planet.cur() == planet.get("Fez") then
   	  local stringData=getStringData()

   	  tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

   	  player.pay( payment )

   	  faction.modPlayerSingle( G.EMPIRE, 1 )

      misn.cargoJet(carg_id)

      var.push("harkan_5_start_time",time.tonumber(time.get() + time.create( 0,0,15, 0, 0, 0 )))

      hook.rm(landhook)
      misn.finish( true )
   end
end

function abort()
   misn.finish()
end