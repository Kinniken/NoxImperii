include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = 50000

-- Mission Details
misn_title = "Decide Shadowlines' fate"
misn_reward = "Unknown"
misn_desc = "Bring Shadowlines to Harkan or betray the Empire and take her to an Ardar world."

osd_msg_initial = {}
osd_msg_initial[1] = "Head back to ${startPlanet} to pick up the alien."
osd_msg_initial["__save"] = true

-- Messages
osd_msg = {}
osd_msg[1] = "Chose between:"
osd_msg[2] = "Bring back Shadowlines to Harkan [Side with the Empire]"
osd_msg[3] = "Take Shadowlines to an Ardar world [Side with the Roidhunate]"
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title_space = "A Message from Fez"
text_space = [[Your terminal suddenly beeps and a message from the Fez hospital complex is displayed on your comm screen; your passenger is ready to be picked up.]]

title[1] = "${startPlanet} Hospital Complex"
text[1] = [[You land on ${startPlanet} and head for the hospital complex where the alien is being treated. As you arrive, the head of the avian sophont medical team comes and meet you.

"${empireRank} ${playerName}, we have good news. Shadowlines - that's her name, as close as our linguists can translate it - has made a full recovery. And yes, she's female, though it seems to matter little in her species. Her biology is fascinating; her bones are the lightest and strongest we've seen on aviants so far. She's refused to tell us much about her people, but it's clear they've evolved as night hunters, something akin to our owls.  They seem less social than humans - I doubt they have true cities, probably just family settlements. One thing puzzles us however; the linguist says they live mainly in high mountain ranges, but that doesn't really fit with their biology. We would have thought them adapted more for sea-level flying." The scientist continues with long explanations on how they manufactured the needed drugs based on research on similar species from two dozen worlds, but you've stopped listening. In any case you've reached the room where she is hosted.

As you enter the room, Shadowlines is moving back and forth behind a reinforced glass panel. The Yren is exchanging with the linguist with the aid of a vocalizer. She notices you entering and seems to recognize you, quickly calling out a greeting in her high-pitched language. "The Flyer in the Deep Night! Be thanked, ${playerName}. Your people have shown strange mercy to bring a captive so far to save him. We would have given only a clean death to a captive Crawler.", the vocalizer translates.

Shadowlines looks agitated, but suddenly stops speaking. It's time to head to the ship.]]

title[2] = "Discussions in the night"
text[2] = [[You visit Shadowlines again soon after lift-off; this time the Imperial linguist is away working on her report and you are alone with the alien. It is obvious she is very agitated, beating her wings in the narrow confine of her cell. "${playerName}!" she hisses, the translator turning her piercing screeches in understandable language. "You do not wear the Sun-symbol of your tribe. What does this mean?". You try and explain that while indeed human, you are working for the Imperial Navy without being part of it. It is clear she understands little - the concepts of governments and armies are aliens to her. But she unexpectedly switch back to the history of her people. "You work with the Crawlers", she hisses. "That Sun female that has spoken long with me spoke with them too. She told me of how we Yrens hunts the Crawlers, kill their children and ambush isolated groups. And we do, when the wind favours us! But the Crawlers never spoke of why, have they?". You can see her anger, her small mouth opening and closing, flashing her carnivorous teeth.

Slowly, with much explanations and detours to go around the translator's limits, she explains how the Tigaray keep expending, growing more numerous since they discovered agriculture and ranching, ceaselessly pushing back the Yrens away from lands they used to dominate. "The remaining clans are all high in mountains now. Do not think it was always like this! My own line once flew above a great forest, above the fish-rich sea. Now the Crawlers have cut the forest to make room for their food animals, and the fishes they catch from their wooden ships. There is not a single true hunter left in that terrible race!", the translator monotonously renders as her screeches become more piercing.

While she refuses to ask anything of you, her fear is obvious: that with Terran help, the Tigaray will definitely get the upper hand in their long-running conflict. It is clear she has little faith in the Ardars, and is smart enough to recognises their help will not be free for her race; but she sees in it the only chance her race has left of not losing more living space to the more numerous Tigarays.

You have been mandated to bring her back to the Empire on Harkan - but nobody could stop you heading to Ardar space instead.]]

title[3] = "Harkan Outpost"
text[3] = [[You land on Harkan Outpost after a quiet flight. Your discussions with Shadowlines, all interesting that they were, could not get you to head to Ardar space.

Commander Suarez and Lieutenant Beauval are waiting as you exit the ship. You give a quick briefing. Suarez seems pleased by your report; Beauval is not listening - he is looking at Shadowlines being carried away, in deep thoughts.

Suarez gestures for you to follow him to his office. "Beauval told me how hard you had taken your eviction from the Navy, though you've clearly done well for yourself since.", he starts. "Navy or not, you've given valuable services, son. And that should be recognised.

${rankReward} And of course, here is your payment. ${payment} credits. I'll be interrogating our guest and figuring our next step. If you're needed, I'll call for you at the mess. Dismissed, sub-lieutenant.]]

title[4] = "The Roidhunate"
text[4] = [[Your decision taken, you head for the nearest Ardar world, land and head to the spaceport authorities. At first they do not believe you; then they struggle to find someone authorized to deal with someone like you.  Hours after you entered the facility, you are finally face to face with the local head of the military secret services.

"So one more human chooses to leave the decrepit Empire and joins our expanding Roidhunate.", he starts in fluent Terran. "Though I undeserved your motivations are a little more complicated than most. It is good to see humans with noble aspirations - from time to time. You have rendered us an unexpected service, ${ardarRank} ${playerName}. You will find the Roidhunate generous with people that help it, no matter their race.

${rankReward} And as your kind is known for its cupidity, here is your first payment of ${payment} credits.

We will call for you when you are needed. Dismissed, Auxiliary.]]

function getStringData()
  local stringData={}
  stringData.playerName=player:name()
  stringData.startPlanet=start_planet and start_planet:name() or ""
  stringData.startSystem=start_planet and start_planet:system():name() or ""
  stringData.payment=gh.numstring(payment)
  stringData.empireRank=emp_getRank()
  stringData.ardarRank=ardar_getRank()
  return stringData
end

function create ()

	if not has_system_faction_planet(system.cur(),G.EMPIRE) then
		misn.finish()
	end

	misn.accept()

	hook.timer(3000, "space_start")

end

function space_start()

	start_planet=planet.get("Fez")

   local stringData=getStringData()

   tk.msg( gh.format(title_space,stringData), gh.format(text_space,stringData) )

	-- mission details
   misn.setTitle( "Pick up the Alien" )
   misn.setDesc( "Pick up the alien from the Fez hospital." )

   osd_msg_initial = gh.formatAll(osd_msg_initial,stringData)
   misn.osdCreate(gh.format("Pick up the Alien",stringData), osd_msg_initial)

   landmarker = misn.markerAdd( start_planet:system(), "plot" )

	landhook = hook.land ("land_start")
end

function land_start ()

	if not (planet.cur()==start_planet) then
		misn.finish(false)
	end

	local stringData=getStringData()

	tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )

	carg_id = misn.cargoAdd( "Captured Avian", 0 )

	misn.markerRm(landmarker)
	landmarker = misn.markerAdd( planet.get("Harkan"):system(), "plot" )

   -- hooks
   hook.rm(landhook)
   spacehook = hook.enter ("enter_space")
   landhook = hook.land ("land_target")

end

function land_target ()
	local stringData=getStringData()

    if planet.cur() == planet.get("Harkan") then
       if player.numOutfit( "Reserve Lieutenant" )==0 then
			player.addOutfit("Reserve Lieutenant",1)
			stringData.rankReward="I've pulled a few strings - you are a lieutenant now! Reserve status, of course. That means you won't be called. But you do get to buy basic Imperial supplies that are off-limit to civilians."
		else
			stringData.rankReward="I was planning to make you a reserve lieutenant - but I see someone got there before me."
		end

		player.pay(payment)

		faction.modPlayerSingle( G.EMPIRE, 2 )

		tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

		var.push("harkan_empire_choice",true)
		misn.cargoJet(carg_id)
		hook.rm(landhook)
		misn.finish( true )
    elseif  planet.cur():faction()==faction.get(G.ROIDHUNATE) then

		payment = 250000

		stringData.payment = payment

		if player.numOutfit( "Ardarshir Auxiliary, Class II" )==0 then
			player.addOutfit("Ardarshir Auxiliary, Class II",1)
			stringData.rankReward="As such I grant you from now onwards the status of Auxiliary, class II."
		else
			stringData.rankReward="I would have granted you Auxiliary status but our archives states that you are already on the list."
		end

	    faction.modPlayerSingle( G.ROIDHUNATE, 10 )



	    player.pay(payment)

	    tk.msg( gh.format(title[4],stringData), gh.format(text[4],stringData) )

	    var.push("harkan_roidhunate_choice",true)
	    var.push("harkan_roidhunate_planet",planet.cur():name())
	    var.push("harkan_roidhunate_6_start_time",time.tonumber(time.get() + time.create( 0,0,1, 0, 0, 0 )))
	    misn.cargoJet(carg_id)
		hook.rm(landhook)
		misn.finish( true )
   end
end

function enter_space ()
	local stringData=getStringData()

	tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

	misn.osdDestroy()
	osd_msg = gh.formatAll(osd_msg,stringData)
    misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

    -- mission details
   misn.setTitle( misn_title )
   misn.setDesc( misn_desc )

	hook.rm(spacehook)
end

function abort()
   misn.finish()
end