
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"
include('universe/objects/class_planets.lua')

title = {}  --stage titles
text = {}   --mission text

title[1] = "New Horizons"
text[1] = [[As you land on ${startPlanet}, you receive a convocation to the local Ardar Navy base. "${ardarRank} ${playerName}.", an officer greets you, curtly. "Your record as auxiliary is satisfactory. My superiors have decided to clear you for more sensitive missions. We need an Ardar recon team dropped on an outlying world. Are you ready to begin?"]]

title[2] = "The Interference Principle"
text[2] = [["The world of ${targetPlanet} in system ${targetSystem} is home to an intelligence species, the ${species}. They are currently outside the borders of the Roidhunate and must be monitored. You will drop an Ardar reconnaissance team there and pick them up again a week after.". He slaps his tail in the Ardar manner and you are dismissed.]]

title[3] = "Strange Men on Strange Worlds"
text[3] = [[You approach ${targetPlanet} and stealthily descend at the location provided by the team leader. The seven Ardars leave the ${shipName} and quickly head for the wilderness.]]

title[4] = "Ardar Down"
text[4] = [[You land on ${targetPlanet} at the agreed-upon time. The team leader is there to meet you, alongside five of his men. Several are wounded. "Back to ${startPlanet}, and hurry.", he barks at you.]]

title[5] = "Systematic Interference"
text[5] = [[As soon as you land, the commando is taken away to another party of the base. 

You are sent back to see the Ardar officer. "That was a well-executed drop, ${ardarRank} ${playerName}.", he starts. "The team's difficulties are not of your doing. We'll have other missions of this kind for you, available on the mission network. You are also being raised to class II. Dismissed."]]

-- Mission Details
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

	local luaplanet=planet_class.load(targetPlanet)

	stringData.species=luaplanet.lua.natives.name

	return stringData
end

function create ()

	targetPlanet=get_native_planet(system.cur(),3,7)

	startPlanet=planet.cur()

	if not targetPlanet then
		print("no target!")
		misn.finish(false)
	end

	local stringData=getStringData()

	if not tk.yesno( gh.format(title[1],stringData), gh.format(text[1],stringData) ) then
		misn.finish(false)
	end

	tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

	misn.accept()

	landmarker = misn.markerAdd( targetPlanet:system(), "high" )

	carg_id = misn.cargoAdd( "Commando", 5 )


	credits  = rnd.rnd(10,20) * 10000

	-- mission details
	misn.setTitle( misn_title )
	misn.setDesc( misn_desc )
	misn.setReward( misn_reward )

	osd_msg = gh.formatAll(osd_msg,stringData)
	misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

	-- hooks
	landhook = hook.land ("land_target")
end

function land_target ()
   if planet.cur() == targetPlanet then
   		local stringData=getStringData()

		hook.rm(landhook)
		
		tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

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
		
		tk.msg( gh.format(title[4],stringData), gh.format(text[4],stringData) )

		misn.osdActive(3)
   	  	misn.markerMove(landmarker,startPlanet:system())
   	  	carg_id = misn.cargoAdd( "Commando", 5 )
		landhook = hook.land ("land_return")
	end
end

function land_return ()
	local stringData=getStringData()

	hook.rm(landhook)
		
	tk.msg( gh.format(title[5],stringData), gh.format(text[5],stringData) )

	player.pay( credits )
	player.addOutfit("Ardarshir Auxiliary, Class II",1)
	misn.cargoJet(carg_id)
   	faction.modPlayerSingle( G.ROIDHUNATE, 5 )

   	misn.finish( true )
end

function abort()
   misn.finish()
end