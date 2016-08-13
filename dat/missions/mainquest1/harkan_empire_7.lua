include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"
include "pilot/pilots_empire.lua"

payment = 100000

-- Mission Details
misn_title = "Locate Colonel Syrnd"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Find Colonel Syrnd and convince him to head to Harkan."


-- Messages
osd_msg = {}
osd_msg[1] = "Search for Colonel Syrnd on ${targetPlanet} in the ${targetSystem} system"
osd_msg["__save"] = true

osd_msg_2 = {}
osd_msg_2[1] = "Search for Colonel Syrnd on ${targetPlanet} in the ${targetSystem} system"
osd_msg_2[2] = "Search for Colonel Syrnd in the ${targetSystem2} system"
osd_msg_2[3] = "Hail Colonel Syrnd"
osd_msg_2["__save"] = true

osd_msg_3 = {}
osd_msg_3[1] = "Search for Colonel Syrnd on ${targetPlanet} in the ${targetSystem} system"
osd_msg_3[2] = "Search for Colonel Syrnd in the ${targetSystem2} system"
osd_msg_3[3] = "Hail Colonel Syrnd"
osd_msg_3[4] = "Return to Harkan"
osd_msg_3["__save"] = true

start_title = "Obtainable Unobtanium"
start_text = [[You've been drinking and swapping stories with the base pilots' for an hour or two when you're called back to Suarez' office. He wastes no time in getting to the point.

"Have you heard of Unobtainium, ${playerName}? Nickname, of course. The scientific one is a paragraph long. To put it quickly, it's a rare radioactive alloy that's produced naturally only in tiny quantities on a handful of worlds. It's precious, very, very precious - our scientists use it to produce our most powerful shield generators. It's so rare only a handful of our flagships get them. Those crates you brought back contain roughly as much as the entire Empire mined last year on three hundred worlds!", continue Suarez, his cool officer demeanour cracking a little. "The obvious thing now would be to raise this with headquarters and move in in force to expel the Roidhunate. Problem is, this means large reinforcements. They'd notice. In fact they'd probably know about it through their spies in HQ before a single ship moves. This would escalate to open war, and Terra would get the blame. Now, Beauval here has a more interesting idea..."

"Thank you, Sir.". Beauval looks pleased with himself. "${playerName}, your winged princess has given me ideas. I've spoken with her. The Yrens are not happy with the crocodiles. The current conflict is taking a heavy toll on them, and unlike the Tigarays they don't have the numbers to keep it up. So if we can broker a peace deal between the Tigarays and them they might switch to our side and kick the Ardars out - with our help. Then if the green tails want to move back in they'll be the one in need of reinforcements. Now I think I can convince my good friend Prince Hakka of the benefits of peace. To get the Yrens on our side though we need the right envoy. They despise "crawlers" like the Tigarays and us. But if we can get an avian to negotiate for us..."

"Indeed. And I believe we've got the profile. Colonel Syrnd from Navy Intelligence is an old friend of mine; he's a Dryft, an avian race from a world annexed to the Empire three hundred years back. ${playerName}, we need you to meet him discreetly and get him back here as fast as you can. He's posted on ${targetPlanet}, a border world to the galactic south. Try and not run into trouble. Dismissed."]]



target_title = "Missing in action"
target_text = [[You land on ${targetPlanet} and start discreetly enquiring for Colonel Syrnd. He seems well-known in town; hard for a two-metre tall avian with a wingspan of ten metres not to get noticed. Nobody you meet has seen him in over a month however. You are about to give up and head back to Harkan when you get a lucky break - a barman heard him discuss with a fellow officer one night. He is in a long-distance recon mission of barbarian space around the system of ${targetSystem2}. It seems like you'll have to head there yourself.]]


end_title = "Colonel Syrnd"
end_text = [[You finally hail Colonel Syrnd; even rendered as a hologram, he cuts an impressive figure. His sharp features, carnivorous teeth and huge folded wings makes him an intimidating presence. If he is surprised at your arrival and your disjointed tale his stony demeanour hides it well. He questions you with a frightening intensity, efficiently extracting all you know of the situation and of Shadowlines' psychology.

Convinced by your story, he bids you farewell and heads for Harkan.]]



function getStringData()
  local stringData={}
  stringData.playerName=player:name()
  stringData.shipName=player.ship()
  stringData.startPlanet=start_planet and start_planet:name() or ""
  stringData.startSystem=start_planet and start_planet:system():name() or ""
  stringData.targetPlanet=target_planet and target_planet:name() or ""
  stringData.targetSystem=target_planet and target_planet:system():name() or ""
  stringData.targetSystem2=target_system2 and target_system2:name() or ""
  stringData.payment=payment
  return stringData
end

function create ()

	if not (planet.cur()==planet.get("Harkan")) then
		misn.finish(false)
	end

	start_planet=planet.get("Harkan")

	misn.accept()

	target_planet=planet.get("Kashi")

	local stringData=getStringData()

	tk.yesno(gh.format(start_title,stringData), gh.format(start_text,stringData) )

   landmarker = misn.markerAdd( planet.get("Kashi"):system(), "plot" )

   osd_msg[1]=gh.format(osd_msg[1],stringData)
   misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

   -- mission details
   misn.setTitle( misn_title )
   misn.setDesc( misn_desc )

   -- hooks
   landhook = hook.land ("land")
end

function land ()	

    if planet.cur() == planet.get("Kashi") then

      local tw,ts = get_faction_planet(system.cur(),G.BARBARIANS,2,7)

      if ts then
	      target_system2=ts
	  else
	  	target_system2=get_empty_sys(system.cur(),2,7)
	  end

	  local stringData=getStringData()
   	  
	  tk.msg( gh.format(target_title,stringData), gh.format(target_text,stringData) )

	  misn.osdDestroy()
	  osd_msg_2[1]=gh.format(osd_msg_2[1],stringData)
	  osd_msg_2[2]=gh.format(osd_msg_2[2],stringData)
   	  misn.osdCreate(gh.format(misn_title,stringData), osd_msg_2)
   	  misn.osdActive(2)

   	  misn.markerMove(landmarker,target_system2)

	  -- hooks
      spacehook = hook.enter ("enter_space")
      hook.rm(landhook)
   end
end


function enter_space()

	if system.cur() == target_system2 then

		local snyrd_pilot = generate_ship("Syrnd' Ship", empire_createComet,vec2.new(0,0),1000,3000,false)

		hook.pilot( snyrd_pilot, "death", "ship_dead" )
		hook.pilot( snyrd_pilot, "hail", "ship_hail" )
		misn.osdActive(3)
	end
end

function ship_dead()
	player.msg( "Colonel Syrnd is dead, mission failed!" )
	misn.finish(false)
end

function ship_hail()
	local stringData=getStringData()
	tk.msg( gh.format(end_title,stringData), gh.format(end_text,stringData) )

	player.pay(payment)

	faction.modPlayerSingle( G.EMPIRE, 2 )

	misn.osdDestroy()
	osd_msg_3=gh.formatAll(osd_msg_3,stringData)
	misn.osdCreate(gh.format(misn_title,stringData), osd_msg_3)
	misn.osdActive(4)

	hook.rm(spacehook)
	landhook = hook.land ("land_final")
end

function land_final()
	if (planet.cur()==planet.get("Harkan")) then
		misn.finish(true)
	end
end



