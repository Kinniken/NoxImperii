
include "universe/generate_helper.lua"
include "dat/missions/supportfiles/common.lua"

-- Mission Details
misn_title = "Meet Abrams on Harkan"
misn_reward = ""
misn_desc = "Head to Harkan to meet Commander Abrams, who requires your services urgently."



-- Messages
osd_msg = {}
osd_msg[1] = "Head to Harkan."
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "Incoming Message"
text[1] = [[As your ship connects to the system's communication network, a coded message from Commander Abrams appears: "Your services are needed for an urgent mission. Hurry. Abrams.".

Time to head for Harkan again, it seems.]]

function getStringData()
	local stringData={}
	stringData.playerName=player:name()

	return stringData
end

function create ()
	if not has_system_faction_planet(system.cur(),G.EMPIRE) then
		misn.finish()
	end

	misn.accept()


	local stringData=getStringData()

	   tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )

	   landmarker = misn.markerAdd( planet.get("Harkan"):system(), "plot" )

	  -- mission details
	  misn.setTitle( misn_title )
	  misn.setDesc( misn_desc )

	  osd_msg[1] = gh.format(osd_msg[1],stringData)
	  misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

	  -- hooks
	  landhook = hook.land ("land")
end

function land ()
	local stringData=getStringData()

   if planet.cur() == planet.get("Harkan") then
      hook.rm(landhook)
      misn.finish( true )
   end
end

function abort()
   misn.finish()
end
