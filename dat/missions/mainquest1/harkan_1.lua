include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

title = {}  --stage titles
text = {}   --mission text

title[1] = "Incoming message"
text[1] = [[As you enter the system, your ship automatically connects to the Imperial communication network. Along with the usual automated communications, a personal message flashes on your command centre. "Pierre Beauval...", you mutter as you read the sender's identity. A cadet a year senior to you in navy school, brash and confidant, roguish but determined to shine in the Navy. He had graduated a year before and been deployed in some frontier world, you remember.

"Greetings, ${playerName}. ", the message starts, after decryption with your standard key. "I heard about that incident with Lady Admiral Junior. Tough luck you had to get caught. Your father must have been livid. He seemed the kind. Also heard you have a ship of your own now. Life of wandering captain for you, eh? I know you wanted to be Navy, but to be blunt I think this will suit you better anyway. Have fun. Beauval."

You're about to dismiss the message as typical Beauval when you have a wild thought - and attempt a second decryption with the mock identity you used in navy school to plan drunken escapades with fellow cadets.

"An other thing - I'm posted on Harkan now, on the Ardar border. Check a map. We could use someone with your piloting skills and no official ties to the Imperial Navy. Be discreet. And bring a bottle of brandy. The navy mess is out of everything drinkable."

Harkan... yes, you've heard of it. A barely-explored planet in the wilderness between the Empire and the Roidhunate, on which the two rivals have gotten embroiled in quarrels between two local sapient species. Typical Beauval to end up there."

]].."\027r[This mission chain requires a decent ship; a Delta or above is recommended.]\0270"

title[2] = "Harkan Outpost"
text[2] = [[You land at Harkan Outpost, the small military outpost maintained by the Empire on the shore of one of the local ocean. Beauval is waiting for you, proudly wearing a spotless Lieutenant uniform - though with a cap more rakishly angled than regulations permit.

He gratefully accept the bottle of brandy you are carrying and take you to a quiet table in the nearby mess. "Let me give you the low down on this place... it might take a while.", he starts. It's a long discussion, but the core of it is simple: the Empire had long established a small outpost on Harkan, from which to monitor activity in the area, as well as friendly but limited relations with the nearby city of Tigaray land dwellers. Despite the world's remoteness from the Roidhunate's borders and little strategic relevance, Ardarshir has secretly set up a base on the other side of Harkan, up in the mountains populated the world's other sentient specie - the avian Yrens. Local quarrels between the two species were now steadily escalating into serious conflicts, with each Empire supplying weapons, technical help and increasing numbers of "instructors" to their client race.

The rest of Beauval's ramblings feel almost like fantasy - he claims to have personally saved one of the local Tigaray chief from an ambush by the Yrens, leading to an audience with the local Tigaray king where he was decorated by his Majesty in person. Knowing Beauval, it might even be true.

"The worse part is that we have no idea why we are fighting here. This world simply isn't worth it. But the greentails are trying to force us out, so we're resisting, see what I mean?" Beauval adds, sipping what is left of the brandy. "But without escalating too much either - they don't seem to want open war and we certainly don't.". He reclines, letting go of the empty glass. "Now, as to where you come in... I need you to meet Commander Suarez. He's the top beret here. I recommended you to him, so be sharp, ok?"]]

-- Mission Details
misn_title = "Message from a friend"
misn_desc = "Visit Beauval in Harkan."

-- OSD
osd_msg = {}
osd_msg[1] = "Visit Beauval in Harkan."

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

	hook.timer(3000, "displayMessage")
end

function displayMessage()
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
	tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

	hook.rm(landhook)
	misn.finish( true )
	end
end

function abort()
   misn.finish()
end