include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/missions/supportfiles/empire.lua"
include "dat/missions/supportfiles/ardarshir.lua"
include('universe/live/live_universe.lua')
include('universe/objects/class_planets.lua')
include "pilot/pilots_ardarshir.lua"
include "dat/scripts/universe/live/live_universe.lua"

payment = 500000

-- Mission Details
misn_title = "Get weapons for the raid"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Bring back weapons for the raid on the Ardar base."


-- Messages
osd_msg = {}
osd_msg[1] = "Get weapons from ${targetPlanet} in the ${targetSystem} system for the commando assault"
osd_msg[2] = "Return to ${startPlanet}"
osd_msg["__save"] = true

osd_msg_2 = {}
osd_msg_2[1] = "Get weapons from ${targetPlanet} in the ${targetSystem} system for the commando assault"
osd_msg_2[2] = "Return to ${startPlanet}"
osd_msg_2[3] = "Defend Harkan from the Ardar forces!"
osd_msg_2[4] = "Return to Harkan"
osd_msg_2["__save"] = true

start_title = "Shadow Conclaves"
start_text = [[As you leave the ${shipName}, an ensign notifies you to report immediately to Commander Suarez. "You took your time, ${empireRank} ${playerName}. Colonel Syrnd has been here for two days already and things are moving fast. Beauval and him have reached Shadowlines' clan and are negotiating a truce between the Tigarays and them. If it works Shadowlines' people will let us slip task forces right up to the Ardar base and we'll have control of the planet before the Roidhunate has understood a thing.". Suarez takes a deep breath and continues. He looks a little ragged, but more animated than you've seen him in days. 

"It would help to have real commando equipment however, and that's not something we can get from anonymous third-party suppliers on neutral worlds. I'll need you to fetch it from the Navy base on ${targetPlanet}. Be careful, that's bound to attract some attention. Dismissed!"]]



target_title = "Pickup Boy"
target_text = [[You land on ${targetPlanet} and report to the colonel in charge. He looks surprised and not very happy to supply such advanced weapons to an unknown reserve officer, but Suarez' request is in order and soon the crates are loaded in the ${shipName}.]]

target_2_title = "Contact with the Enemy"
target_2_text = [[You've barely landed, straight off the brush with the Ardar fighters, when Suarez in person appears at your airlock. "Get back in space immediately, ${empireRank}! Our plans have been leaked to the Ardars, they are bringing in reinforcement! I'm scrambling everything I've got and Beauval and Syrnd are rushing the ground assault. Give them hell!"]]

end_title = "Peace on Harkan"
end_text = [[The remains of the Imperial fleet land alongside you on Harkan under the cheers of the small staff of the naval base. The next days are a blur of celebration and activities; Beauval and Syrnd are busy wrapping up a peace treaty, Suarez is locked up in the communication room justifying his action to his superiors, and you alternate between sumptuous receptions in Tigaray cities and austere gatherings of the Yren clans.

When you are finally called to his office, Commander Suarez looks even more harried than usual. "${playerName}, those idiots at HQ might not realise it but the Empire is in your debt. It's still a mess but things are falling into place; the main Tigaray and Yren groups have signed the new treaty and welcomed us as protectors. Ardarshir is furious and threatening war but everyone know they are bluffing, they'd be here already otherwise. ${rankReward} And of course, here your payment for your services... ${payment} credits. I'm sure you can find a good use for it. I have also authorised the transfer of one of our new unobtainium-boosted shield capacitor to your ship; we can finally make them widely available."

"One last thing... I've heard your Tigaray friend is no longer content with this world's oceans. He's looking for work as a warrior on board a ship. Maybe you should speak to him, he's taken to the base's mess. Dismissed, ${playerName}.".]]

function getStringData()
  local stringData={}
  stringData.playerName=player:name()
  stringData.shipName=player.ship()
  stringData.startPlanet=start_planet and start_planet:name() or ""
  stringData.startSystem=start_planet and start_planet:system():name() or ""
  stringData.targetPlanet=target_planet and target_planet:name() or ""
  stringData.targetSystem=target_planet and target_planet:system():name() or ""
  stringData.payment=gh.numstring(payment)
  stringData.empireRank=emp_getRank()
  return stringData
end

function create ()

	if not (planet.cur()==planet.get("Harkan")) then
		misn.finish(false)
	end

	start_planet=planet.get("Harkan")

	

	target_planet=get_faction_planet(system.cur(),G.EMPIRE,2,10)

	local stringData=getStringData()

	if not tk.yesno(gh.format(start_title,stringData), gh.format(start_text,stringData) ) then
		misn.finish(false)
	end

	misn.accept()

   landmarker = misn.markerAdd( target_planet:system(), "plot" )

   osd_msg[1]=gh.format(osd_msg[1],stringData)
   osd_msg[2]=gh.format(osd_msg[2],stringData)
   misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

   -- mission details
   misn.setTitle( misn_title )
   misn.setDesc( misn_desc )

   -- hooks
   landhook = hook.land ("land")
   
end

function space_interceptors()
	if system.cur() == start_planet:system() then
		local ardarPos=gh.randomPosAround(player.pos(),1500,2000)

		generate_ship("Ardar Interceptors", ardarshir_createMeteor,ardarPos,50,100,true)
		--generate_ship("Ardar Interceptors", ardarshir_createMeteor,ardarPos,50,100,true)
	end
end

function land ()	
    if planet.cur() == target_planet then

    	local stringData=getStringData()
   	  
	  	tk.msg( gh.format(target_title,stringData), gh.format(target_text,stringData) )

	  	carg_id = misn.cargoAdd( C.MODERN_ARMAMENT, 10 )

	  	misn.markerMove(landmarker,start_planet:system())

	  	misn.osdActive(2)

	  	spacehook = hook.enter("space_interceptors")
	  	landhook2 = hook.land("land2")
      	hook.rm(landhook)
    end
end

function land2()
	if planet.cur() == start_planet then

    	local stringData=getStringData()
   	  
	  	tk.msg( gh.format(target_2_title,stringData), gh.format(target_2_text,stringData) )

		misn.osdDestroy()
	  	osd_msg_2[1]=gh.format(osd_msg_2[1],stringData)
	  	osd_msg_2[2]=gh.format(osd_msg_2[2],stringData)
	  	osd_msg_2[3]=gh.format(osd_msg_2[3],stringData)
	  	osd_msg_2[4]=gh.format(osd_msg_2[4],stringData)
   	  	misn.osdCreate(gh.format(misn_title,stringData), osd_msg_2)
   	  	misn.osdActive(3)

   	  	misn.cargoJet(carg_id)

   	  	hook.rm(spacehook)
      	hook.rm(landhook2)
      	spacehook = hook.enter("space_final_fight")
    end
end

function space_final_fight()
	if system.cur() == start_planet:system() then

		local ardarPos=gh.randomPosAround(planet.get("Harkan"):pos(),1500,2000)

		--leader, to be killed
		target_ship_pilot=generate_ship("Ardar Strike Leader", ardarshir_createContinent,ardarPos,50,100,true)
		deathhook=hook.pilot( target_ship_pilot, "death", "ship_defeated" )
		jumphook=hook.pilot( target_ship_pilot, "jump", "ship_defeated" )

		--rest of team
		generate_ship("Ardar Strike Team", ardarshir_createComet,ardarPos,50,100,true)
		generate_ship("Ardar Strike Team", ardarshir_createMeteor,ardarPos,50,100,true)
		generate_ship("Ardar Strike Team", ardarshir_createMeteor,ardarPos,50,100,true)

		--Imperial forces
		local imperialPos=gh.randomPosAround(planet.get("Harkan"):pos(),100,1000)
		generate_ship("Imperial Task Force", empire_createContinent,imperialPos,50,100,false)
		generate_ship("Imperial Task Force", empire_createComet,imperialPos,50,100,false)
		generate_ship("Imperial Task Force", empire_createMeteor,imperialPos,50,100,false)
		generate_ship("Imperial Task Force", empire_createMeteor,imperialPos,50,100,false)
	end
end

function ship_defeated()
	player.msg( "The Ardar task force has been driven off! Head back to Harkan." )

	misn.osdActive(4)

	local lua_planet=planet_class.load(start_planet)

    lua_planet:addHistory("Following the Yren-Tigaray peace treaty, Harkan has been accepted as a protectorate of the Empire of Terra.")
    lua_planet.lua.natives.civilized = true
    lua_planet.lua.settlements.natives = lua_planet.lua.natives
    lua_planet.lua.natives = nil
    lua_planet.c:setFactionPresence(G.EMPIRE,1,1)--values don't really matter, they are updated by the live service method anyway
    generatePlanetServices(lua_planet)
    lua_planet:save()

	hook.rm(spacehook)
	hook.rm(deathhook)
	hook.rm(jumphook)

	landhook = hook.land("land3")
end

function land3()
	if planet.cur() == start_planet then

    	local stringData=getStringData()

    	if player.numOutfit( "Reserve Major" )==0 then
			player.addOutfit("Reserve Major",1)
			stringData.rankReward="And so I'm raising you to the rank of Major, a well-deserved promotion."
		else
			stringData.rankReward="I was prepared to raise you to the rank of Major, but it seems someone else got there before me."
		end

		player.addOutfit("Terran Unobtainium Shield Capacitor",1)
   	  
	  	tk.msg( gh.format(end_title,stringData), gh.format(end_text,stringData) )

      	player.pay(payment)

      	faction.modPlayerSingle( G.EMPIRE, 10 )

      	var.push("harkan_empire_win",true)

	    local bop=var.peek("universe_balanceofpower")

		if bop==nil then
			bop=0
		end

		bop=bop+100

		var.push("universe_balanceofpower",bop)

      	hook.rm(landhook)
		misn.finish(true)
    end
end