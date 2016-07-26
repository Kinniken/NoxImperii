
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"
include "dat/scripts/universe/live/live_universe.lua"

title = {}  --stage titles
text = {}   --mission text

payment = 20000

title[1] = "The City in the Cliff"
text[1] = [[During the flight, you've had a bit of time to read on Kert's specie. They are small, compact humanoids, natives to a world on the Imperial fringes. Many of them have dispersed elsewhere in the Empire, fleeing barbarian attacks on their home-world. And as Lieutenant Breton-Smith alluded to, they do prefer underground dwellings. The database has little else to say; there are too many species in the Empire to keep track of all of them.

You land on ${startPlanet} and are quickly directed to Kert's family dwelling. Far from the claustrophobic caves you were fearing, it's a bright and airy complex of halls built in a white cliff overlooking a little sea.

You are soon greeted by an imposing-looking humanoid dressed in a long coat threaded with complex silver patterns. He introduces himself as Kert's mentor, then stands silent while you deliver the news. "His parents and me feared the day we would get this news. But Kert chose this freely. We will grieve freely as well." he finally speaks, in a voice deeper than any human.

"One thing I do not understand however. You are not his commanding officer, or even from the Navy. Did he die fighting as well?". You quickly correct him, providing a somewhat censored version of Breton-Smith's request. You can tell immediately that he is taking the news badly. "This is outrageous behaviour, and against all Navy regulations!", he starts, his voice now rumbling with anger. "We have always supported the Empire and contributed gold and blood to the Navy, but we demand the respect that is due in return. I will write to the Admiralty immediately. We will have this Lieutenant in our halls to tell us about Kert's death yet."

An hour later, he hands you over a formal complaint, hand-written and addressed to the Emperor himself, as is customary, as well as payment for its delivery to Terra.]]

title[2] = "A Case of Conscience"
text[2] = [[As you lift-off from ${startPlanet}, you consider your options. Petitions such as the one you're carrying hardly ever lead to anything - most likely it will just stay buried in an Imperial bureaucrat's office. However it just could end up embarrassing Breton-Smith, should a zealous official take an interest.

You can take it to Terra, in the probably vain hope that Zert's family will get some redress.

Or you can head to Luna, where Breton-Smith might generously reward the disappearance of the document.

In any case, you are off to Sol, the centre of the Empire!]]


title[3] = "For the Sake of a Name"
text[3] = [[You find Breton-Smith in one of the best hotels of Luna, preparing for a few days of revelry before he heads back to the frontier. As you relate your encounter with Kert's mentor, he becomes increasingly agitated - "How dare that little beast threaten me like that! Does he really believe His Majesty's officers have nothing better to do than offer condolences to the families of idiots who couldn't complete a simple survey mission without getting themselves killed?" he fumes. As he turns to face you again, you can see his gaze narrow. "And it's not hard to see why you are here. Very well, I'll pay for that document if I have to. Take those ${payment} credits and get out of here!".

]].."[Your decision has slightly affected the Nox Imperii universe. Check its effects in the \"Universe\" tab of the \"Info\" screen.]"

title[4] = "Duty Complete"
text[4] = [[After hours of waiting, you are finally received by a minor clerk in the Imperial bureaucracy. He receives the petition without much interest, asks a few questions and let you go. That's already farther than most petition ever gets. You cash in your payment and head back to your ship.]]

title[5] = "Rank and Responsibilities"
text[5] = [[You have almost forgotten about Breton-Smith and his lacking sense of duty when you tune into Imperial news channel one morning. "Admiralty blasts lack of leadership among privileged young cadets", the headline screams. The article goes on to detail how the ambitious Lord Lee-Santos, a high-ranking member of the Navy Discipline Commission, has launched a crackdown on dereliction of duty among young officers. One of the example given, all anonymously, is that of a "young Lieutenant from a great noble family" accused of not having fulfilled his responsibilities toward a fallen subordinate. The report claims that he is to be made an example of and striped of his rank.

]].."[Your decision has slightly affected the Nox Imperii universe. Check its effects in the \"Universe\" tab of the \"Info\" screen.]"

-- Mission Details
misn_title = "A Case of Conscience"
misn_desc = "Decide between delivering the petition to Terra or handing it over to Lieutenant Breton-Smith for a likely reward."
misn_reward = ""..payment.." cr on Terra; unknown on Luna"

-- OSD
osd_msg = {}
osd_msg[1] = "Chose between:"
osd_msg[2] = "Deliver the petition to the authorities on Terra"
osd_msg[3] = "Hand it over to Breton-Smith on Luna"

function getStringData()
	local stringData={}
	stringData.playerName=player:name()
	stringData.shipName=player:ship()
	stringData.startPlanet=startPlanet:name()
	stringData.startSystem=startPlanet:system():name()
	stringData.payment=payment

	return stringData
end

function create ()

	if not (planet:cur() == planet.get(var.peek("intro_3_planet"))) then
		misn.finish()
	end

	misn.accept()

	startPlanet=planet.cur()

	local stringData=getStringData()

	tk.msg( gh.format(title[1],stringData), gh.format(text[1],stringData) )

	landmarker = misn.markerAdd(system.get("Sol"), "plot" )

	-- mission details
	misn.setTitle( misn_title )
	misn.setDesc( misn_desc )
	misn.setReward( misn_reward )

	osd_msg = gh.formatAll(osd_msg,stringData)
	misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

	-- hooks
	landhook = hook.land ("land")
end

function land ()
   if planet.cur() == planet.get("Luna") then

		hook.rm(landhook)

		payment=500000

		local stringData=getStringData()
		tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

		player.pay(payment)

		var.push("intro_breton_side",true)

		local bop=var.peek("universe_balanceofpower")
		bop=bop-5
		var.push("universe_balanceofpower",bop)
		updateUniverseDesc()

		misn.finish( true )
	elseif planet.cur() == planet.get("Terra") then
		hook.rm(landhook)
		local stringData=getStringData()
		tk.msg( gh.format(title[4],stringData), gh.format(text[4],stringData) )
		hook.rm(landhook)

		player.pay(payment)
		misn.osdDestroy()

		hook.timer(100000, "displayMessage")
   end
end

function displayMessage()
	tk.msg( gh.format(title[5],stringData), gh.format(text[5],stringData) )

	var.push("intro_kert_side",true)

	local bop=var.peek("universe_balanceofpower")
	bop=bop+5
	var.push("universe_balanceofpower",bop)
	updateUniverseDesc()

	misn.finish( true )
end

function abort()
   misn.finish()
end