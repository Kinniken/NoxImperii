
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"
include "universe/live/live_universe.lua"

title = {}  --stage titles
text = {}   --mission text

title[1] = "An Invitation for Dinner"
text[1] = [[As the ${shipName} enters ${startSytem}, your communication system flashes : you have just received a personal message.

"Dear Captain ${playerName},

We are delighted to inform you of the return of our son Lieutenant Breton-Smith after his first tour of duty in service of His Imperial Majesty. In honour of this, we will be hosting a great Dinner Party in our estate of ${targetPlanet}, ${targetSystem} system. We would be delighted to count you among our guests.

Sincerely,

Lord & Lady Breton-Smith"

You remember Breton from the academy; stuck-up little snob, though a competent officer. ${targetPlanet} is not far - if nothing else the food will be good and you'll get news of your fellow cadets.]]

-- Mission Details
misn_title = "An Invitation for Dinner"
misn_desc = "Attend the Breton-Smith's dinner party."
misn_reward = "Free food!"

-- OSD
osd_msg = {}
osd_msg[1] = "Attend the dinner party on ${targetPlanet}."

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.shipName=player:ship()
	stringData.startSytem=startSytem:name()
	stringData.targetPlanet=targetPlanet:name()
	stringData.targetSystem=targetPlanet:system():name()

	return stringData
end

function create ()

	if not has_system_faction_planet(system.cur(),G.EMPIRE) then
		misn.finish()
	end

	misn.accept()

	startSytem=system.cur()

	targetPlanet=get_faction_planet(system.cur(),G.EMPIRE,1,4,planetValidator)
	var.push("intro_2_planet",targetPlanet:name())

	hook.timer(3000, "displayMessage")
end

function planetValidator(aplanet)

	local lua_planet=planet_class.load(aplanet)

	if (lua_planet.lua.humanFertility ~= nill and lua_planet.lua.humanFertility>0.8) then
		return true
	else
		return false
	end
end

function displayMessage()

	local stringData=getStringData()

	tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )

	landmarker = misn.markerAdd( targetPlanet:system(), "plot" )

	-- mission details
	misn.setTitle( misn_title )
	misn.setDesc( misn_desc )
	misn.setReward( misn_reward )

	osd_msg[1] = gh.format(osd_msg[1],stringData)
	misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

	-- hooks
	landhook = hook.land ("land")
end

function land ()
   if planet.cur() == targetPlanet then
		hook.rm(landhook)
		misn.finish( true )		
   end
end

function abort()
   misn.finish()
end