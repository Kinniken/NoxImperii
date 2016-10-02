
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

title = {}  --stage titles
text = {}   --mission text

payment = 100000

title[1] = "All equal under fire"
text[1] = [[The Breton-Smith's estate is grand indeed, and they have spared no expenses to welcome their son and showcase his contribution to the Empire's defence.

It is only late into the night, after many rounds of speeches and more than your share of the excellent Terran wine, that you finally exchange words with the young officer.

"Ah, ${playerName}, I've heard you are an independent courier of some kind now? How regrettable. You'd have liked life on the border. It's terribly rustic, you wouldn't believe what a dump of a world I'm based out of." he starts, glass in hand. You try asking him about his combat experience, but he quickly stops you.

"What, you think High Command is mad? They wouldn't risk a graduate from the Terran Academy itself! And from a family such as mine, too! No, no, I'm there to organise patrols, not carry them out, the Emperor be praised! That reminds me - I had a silly incident in one of my first patrols. One of my pilot got himself killed, the idiot. It was very embarrassing; my superiors claimed I had sent him too close to Ardar space, but that's ridiculous, isn't it? What good are patrols away from the enemy? Anyway, the point is, he was a weird little humanoid from a ghastly troglodyte race from a backward world close to here, and according to Navy traditions I'm supposed to announce his death to his parents or tribe or whatever those things have in person and hand over to them his miserable little possessions. I can't believe the Navy expects this, and for a non-human too! The Empire's really going to the dogs." he pauses for a second. "It's not terribly regular, but I'm expected on Luna soon and that whole thing is frightfully inconvenient. You'd mind doing it for me? It's your job now, these sort of things, isn't it?"

You hesitate for a second between smashing his face or just leaving him hanging. But you do need money, and whoever that pilot was, his family deserves to know.]]

title[2] = "An Irregular Commission"
text[2] = [["Right, I knew you would, you've never missed a chance to make a bit of cash on the side, have you? So the pilot's Squad Leader Kert, and you'll find him on ${targetPlanet} in system ${targetSystem}. I've heard it's a ghastly place. No need to report back to me, I'll be off soon anyway. ${payment} credits should do it, right? Cheers!" he salutes you with his glass and is gone to speak to other guests.]]

-- Mission Details
misn_title = "Bearer of bad news"
misn_desc = "Inform the family of Squad Leader Kert of his death."
misn_reward = gh.numstring(payment).." cr"

-- OSD
osd_msg = {}
osd_msg[1] = "Visit Kert's family on ${targetPlanet}."

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.shipName=player:ship()
	stringData.targetPlanet=targetPlanet:name()
	stringData.targetSystem=targetPlanet:system():name()
	stringData.payment=gh.numstring(payment)

	return stringData
end

function create ()

	if not planet:cur() == planet.get(var.peek("intro_2_planet")) then
		misn.finish()
	end

	misn.accept()

	targetPlanet=get_faction_planet(system.get("Surya"),G.EMPIRE,2,4,function(aplanet) return aplanet:class()=="Earth-like" end)
	var.push("intro_3_planet",targetPlanet:name())

	local stringData=getStringData()

	tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )
	tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

	landhook = hook.land ("land")

	landmarker = misn.markerAdd(targetPlanet:system(), "plot" )

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
		player.pay(payment)
   end
end

function abort()
   misn.finish()
end