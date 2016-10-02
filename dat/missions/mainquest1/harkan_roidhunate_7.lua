include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/missions/supportfiles/traders.lua"
include "pilot/pilots_ardarshir.lua"
include "pilot/pilots_empire.lua"
include "dat/scripts/universe/live/live_universe.lua"

payment = 500000

-- Mission Details
misn_title = "Her Majesty Shadowlines"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Help the Roidhunate conquer Harkan in the name of Shadowlines."


-- Messages
osd_msg = {}
osd_msg[1] = "Head back to ${startPlanet} in ${startSystem} system."
osd_msg["__save"] = true

osd_msg_2 = {}
osd_msg_2[1] = "Head back to ${startPlanet} in ${startSystem} system."
osd_msg_2[2] = "Take an Ardar commando to ${targetPlanet}."
osd_msg_2["__save"] = true

osd_msg_3 = {}
osd_msg_3[1] = "Head back to ${startPlanet} in ${startSystem} system."
osd_msg_3[2] = "Take an Ardar commando to ${targetPlanet}."
osd_msg_3[3] = "Help the Ardar strike force defeat the Imperial ships."
osd_msg_3[4] = "Return to ${targetPlanet}."
osd_msg_3["__save"] = true

start_message = "Auxiliary ${playerName}, report immediately to Ardarshir. Your services are needed."

start_title = "The Return of the Queen"
start_text = [[You land near the capital and are immediately escorted to a small palace in the outskirts, "gifted" by the Roidhunate to the Queen-in-exile Shadowlines. She receives you in her private quarters, escorted by Ardar guards and a stern-looking Ardar aristocrat that serves as her "adviser".

"Welcome, You who fly in the Night! It seem we are to fly together some more." she starts. Her adviser quickly takes over. "Auxiliary, Her Majesty has requested your participation in the coming liberation of her domain of Harkan. You know the ground well and we have reasons to believe your 'transfer of loyalty' has not yet been confirmed on the Imperial side. As such you will be responsible for discreetly landing a commando team on Harkan. Don't disappoint us.". Shadowlines spreads her wings in salute, the adviser slaps his tail on the stone floor, and the interview is over.]]

space_title = "Meeting an Old Friend"
space_text = [[The ${shipName} has just entered the system when you get a high-priority call from Harkan on Imperial frequencies. "You backstabbing crocodile-loving lowlife scum!" a furious Beauval roars at you on the comm display. "Suarez wouldn't believe it but I knew as soon as your ship disappeared that you had deserted. Couldn't handle getting kicked out of the Navy, could you? I'll kill you myself!". The connection breaks while your screen lights up with hostile forces.]]

target_title = "Ardars on the Ground"
target_text = [[Rid of the Imperial fighters, you waste no time landing the Ardar commandos at the Ardar base, from which they quickly head to the Imperial Outpost and the main Tigaray cities. You are immediately sent back to space - things are moving fast there, with Imperial reinforcements arriving and threatening to overwhelm the first Ardar ships on their way to Harkan.]]

success_title = "The Roidhunate and the Queen"
success_text = [[By the time you land the action on the ground is over. The Ardar commandos, assisted by Yren warriors, are in control of Harkan. In the next few days a new order is put in place. The much-extended Ardar base is turned into a stronghold from which to defend the world from the Empire while the Tigarays are forced to give up much of the land they had gained at the Yrens' expense - though Shadowlines is quick to end all Yren talk of bloody revenge.

Keen to impress the local population, the Roidhunate's new representative on the world decides on the organisation of a great coronation ceremony for Shadowlines, cementing her status as monarch of Harkan - and vassal of the Roidhun. He receives you the evening before. "Auxiliary ${playerName}, your role in the bringing of Harkan into the firm embrace of His Majesty will not be publicised, for your benefit as well as that of the Roidhunate. But we are not ungrateful. ${rankReward} We have also transferred one of our new Unobtainium-based shield generators to the ${shipName}. We trust you will use it against the Empire. Dismissed, Auxiliary.".

You arrive early in the hastily-erected Throne Room - the Yrens had no need for such buildings. The hall is full; delegates from all the Yren clans and the main Tigaray cities are all there, carefully monitored by Ardar soldiers. The ceremony follows Ardar protocol in the absence of Yren equivalent, and soon Shadowlines has been officially crowned Queen of Harkan, ruler of Yrens and Tigarays alike. She seems subdued throughout, closely following the whispered instructions of her Ardar adviser.

Two days later the news break on Harkan: Shadowlines has resigned and transferred her authority to a new mixed Yren-Tigaray council! The Ardar adviser is deemed to be furious, though the new council quickly confirms the Roidhun as overload of Harkan and Ardar rights on the precious mining operations. Things calm down again, though the former queen seems to have disappeared.

That is, until you receive a private message one morning: "To He-who-flies-in-the-Night: I have seen enough of the skies of this world. I would be honoured to fly with you once again. I will wait for you where you night-fliers stop and rest. Shadowlines.". Time to head to the mess?]]

function getStringData()
  local stringData={}
  stringData.playerName=player:name()
  stringData.shipName=player.ship()
  stringData.startPlanet=start_planet and start_planet:name() or ""
  stringData.startSystem=start_planet and start_planet:system():name() or ""
  stringData.targetPlanet=target_planet and target_planet:name() or ""
  stringData.targetSystem=target_planet and target_planet:system():name() or ""
  stringData.payment=gh.numstring(payment)
  stringData.ardarRank=ardar_getRank()
  return stringData
end

--space message, head to Ardarshir
function create ()
	if not has_system_faction_planet(system.cur(),G.ROIDHUNATE) then
		misn.finish()
	end

	misn.accept()

	start_planet=planet.get("Ardarshir")
	target_planet=planet.get("Harkan")

	local stringData=getStringData()

	player.msg(gh.format(start_message,stringData))

	-- mission details
	misn.setTitle( misn_title )
	misn.setDesc( misn_desc )

	misn.osdCreate(gh.format(misn_title,stringData), gh.formatAll(osd_msg,stringData))

	landmarker = misn.markerAdd(start_planet:system(), "plot" )

	-- hooks
	landhook = hook.land ("land")
end

--land on Ardarshir, head to Harkan with commando team
function land()
	if not (planet.cur() == start_planet) then
		return
	end

	local stringData=getStringData()

	tk.msg( gh.format(start_title,stringData), gh.format(start_text,stringData) )

	carg_id = misn.cargoAdd( "Commando", 0 )

	misn.osdDestroy()
	misn.osdCreate(gh.format(misn_title,stringData), gh.formatAll(osd_msg_2,stringData))
	misn.osdActive(2)

	misn.markerMove(landmarker,target_planet:system())

	hook.rm(landhook)
	landhook = hook.land ("land2")
	spacehook = hook.enter ("space")
end

--generate Beauval ship in Harkan system
function space()
	if not (system.cur() == target_planet:system()) then
		return
	end

	if not beauval_message_done then

		local stringData=getStringData()

		tk.msg( gh.format(space_title,stringData), gh.format(space_text,stringData) )
		beauval_message_done=true
	end

	generate_ship("Imperial Interceptor", empire_createComet,player:pos(),1000,1500,true)
end

--land, immediately head back to space to fight Empire
function land2 ()
	if not (planet.cur() == target_planet) then
		return
	end

	local stringData=getStringData()

	tk.msg( gh.format(target_title,stringData), gh.format(target_text,stringData) )

	misn.cargoJet(carg_id)

	misn.osdDestroy()
	misn.osdCreate(gh.format(misn_title,stringData), gh.formatAll(osd_msg_3,stringData))
	misn.osdActive(3)

	hook.rm(landhook)
	hook.rm(spacehook)

	spacehook = hook.enter ("space2")
end

--spawn Imperial forces
function space2()
	if not (system.cur() == target_planet:system()) then
		return
	end

	local fleetPos=gh.randomPosAround(planet.get("Harkan"):pos(),1500,2000)

	--leader, to be killed
	target_ship_pilot=generate_ship("Imperial Admiral Ship", empire_createContinent,fleetPos,50,100,true,"Empire of Terra Strike Forces")
	deathhook=hook.pilot( target_ship_pilot, "death", "ship_defeated" )
	jumphook=hook.pilot( target_ship_pilot, "jump", "ship_defeated" )

	--rest of team
	generate_ship("Imperial Defence Force", empire_createComet,fleetPos,50,100,true,"Empire of Terra Strike Forces")
	generate_ship("Imperial Defence Force", empire_createMeteor,fleetPos,50,100,true,"Empire of Terra Strike Forces")
	generate_ship("Imperial Defence Force", empire_createMeteor,fleetPos,50,100,true,"Empire of Terra Strike Forces")

	--Ardar forces
	local ardarPos=gh.randomPosAround(planet.get("Harkan"):pos(),100,1000)
	generate_ship("Ardar Task Force", ardarshir_createContinent,ardarPos,50,100,false,"Roidhunate of Ardarshir Strike Forces")
	generate_ship("Ardar Task Force", ardarshir_createComet,ardarPos,50,100,false,"Roidhunate of Ardarshir Strike Forces")
	generate_ship("Ardar Task Force", ardarshir_createMeteor,ardarPos,50,100,false,"Roidhunate of Ardarshir Strike Forces")
	generate_ship("Ardar Task Force", ardarshir_createMeteor,ardarPos,50,100,false,"Roidhunate of Ardarshir Strike Forces")
end

--leading ship defeated, counts as victory
function ship_defeated()
	player.msg( "The Imperial ships have been defeated! Head back to Harkan." )

	misn.osdActive(4)

	local lua_planet=planet_class.load(target_planet)

    lua_planet:addHistory("Under the short-reigning Queen Shadowlines, Harkan became an Ardar protectorate dominated by the Yren clans.")
    lua_planet.lua.natives.civilized = true
    lua_planet.lua.settlements.natives = lua_planet.lua.natives
    lua_planet.lua.natives = nil
    lua_planet.c:setFactionPresence(G.ROIDHUNATE,1,1)--values don't really matter, they are updated by the live service method anyway
    generatePlanetServices(lua_planet)
    lua_planet:save()

	hook.rm(spacehook)
	hook.rm(deathhook)
	hook.rm(jumphook)

	landhook = hook.land("land3")
end

--rewards and over
function land3()
	if planet.cur() == target_planet then

		local stringData=getStringData()

		if player.numOutfit( "Ardarshir Auxiliary, Class III" )==0 then
			player.addOutfit("Ardarshir Auxiliary, Class III",1)
			stringData.rankReward="You are thus raised to the rank of Class III Auxiliary, an honour for one of your race."
		else
			stringData.rankReward="You would have been raised to Class III Auxiliary."
		end

		player.addOutfit("Ardar Unobtainium Shield Capacitor",1)

		tk.msg( gh.format(success_title,stringData), gh.format(success_text,stringData) )

		player.pay(payment)

		faction.modPlayerSingle( G.ROIDHUNATE, 10 )

		var.push("harkan_roidhunate_win",true)

		local bop=var.peek("universe_balanceofpower")

		bop=bop-100

		var.push("universe_balanceofpower",bop)

		hook.rm(landhook)
		misn.finish(true)
    end
end

function abort()
   misn.finish()
end