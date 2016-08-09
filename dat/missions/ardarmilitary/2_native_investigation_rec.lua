
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"
include('universe/objects/class_planets.lua')

title = {}  --stage titles
text = {}   --mission text

title[1] = "Ardars in a Hurry"
text[1] = [[A mere fifteen minutes after your acceptance of the mission the team reports to the ${shipName}. Their team leader orders you to lift-off as soon as possible.]]

title[2] = "Ardar Dropoff"
text[2] = [[You land the team on ${targetPlanet} as planned. They immediately disperse in the wilderness, without a backward glance.]]

title[3] = "Heading Home"
text[3] = [[The full team is waiting for you when you land, looking tired but satisfied with their work. While his team mates head straight for one of the sand bath beloved of Ardars, the leader orders you to head straight for ${startPlanet}. ]]

title[4] = "Barrack Sweet Barrack"
text[4] = [[The team exits the ${shipName} quickly upon landing, eager to head back to their barracks. An Ardar lieutenant calls you in for your report; after a short debriefing he hands you your ${credits} credits.]]

-- Mission Details
misn_computer = "ROIDHUNATE: Investigate natives on ${targetPlanet}"
misn_title = "Native Investigation"
misn_desc = "Drop and recover an Ardar team on the native world of ${targetPlanet}"
misn_reward = "${credits} credits"

-- OSD
osd_msg = {}
osd_msg[1] = "Drop the team on ${targetPlanet}."
osd_msg[2] = "Recover the team from ${targetPlanet} after a week."
osd_msg[3] = "Carry the team back to ${startPlanet}."

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.shipName=player:ship()
	stringData.startPlanet=startPlanet:name()
	stringData.startSytem=startPlanet:system():name()
	stringData.targetPlanet=targetPlanet:name()
	stringData.targetSystem=targetPlanet:system():name()
	stringData.ardarRank=ardar_getRank()
	stringData.credits=credits

	local luaplanet=planet_class.load(targetPlanet)

	stringData.species=luaplanet.lua.natives.name

	return stringData
end

function create ()

	targetPlanet=get_native_planet(system.cur(),3,7)

	startPlanet=planet.cur()

	if not targetPlanet then
		misn.finish(false)
	end

	credits  = rnd.rnd(10,20) * 10000

	local stringData=getStringData()

	computer_marker=misn.markerAdd( targetPlanet:system(), "computer" )

	misn_computer=gh.format(misn_computer,stringData)
	misn_desc=gh.format(misn_desc,stringData)
	misn_reward=gh.format(misn_reward,stringData)
	misn_title=gh.format(misn_title,stringData)	

	-- mission details
	misn.setTitle( misn_computer )
	misn.setDesc( misn_desc )
	misn.setReward( misn_reward )	
end

function accept ()
	misn.accept()

	local stringData=getStringData()
	tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )

	misn.setTitle( misn_title )

	misn.markerRm(computer_marker)
	landmarker = misn.markerAdd( targetPlanet:system(), "high" )

	carg_id = misn.cargoAdd( "Commando", 5 )

	osd_msg = gh.formatAll(osd_msg,stringData)
	misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

	-- hooks
	landhook = hook.land ("land_target")	
end

function land_target ()
   if planet.cur() == targetPlanet then
   		local stringData=getStringData()

		hook.rm(landhook)
		
		tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

		pickup_time=time.tonumber(time.get() + time.create( 0,0,7, 0, 0, 0 ))

		misn.cargoJet(carg_id)
		misn.osdActive(2)

		landhook = hook.land ("land_target_2")
   end
end

function land_target_2 ()
	if planet.cur() == targetPlanet and time.tonumber(time.get()) > pickup_time then
		local stringData=getStringData()

		hook.rm(landhook)
		
		tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

		misn.osdActive(3)
   	  	misn.markerMove(landmarker,startPlanet:system())
   	  	carg_id = misn.cargoAdd( "Commando", 5 )
		landhook = hook.land ("land_return")
	end
end

function land_return ()
	local stringData=getStringData()

	hook.rm(landhook)
		
	tk.msg( gh.format(title[4],stringData), gh.format(text[4],stringData) )

	player.pay( credits )
	misn.cargoJet(carg_id)
   	faction.modPlayerSingle( G.ROIDHUNATE, 2 )

   	misn.finish( true )
end

function abort()
   misn.finish()
end