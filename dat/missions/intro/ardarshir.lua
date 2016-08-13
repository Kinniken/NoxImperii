
include "jumpdist.lua"

bar_desc = "You see a young student sipping a cheap beer at the bar, lost in his thoughts."

-- Mission Details
misn_title = "Student on a Scholarship"
misn_reward = "The student will pay you what he can."
misn_desc = "Take the student to Ardarshir."

-- OSD
OSDtitle = "Student on a Scholarship"
OSDdesc = "Go to Ardarshir in the Koiych system with the student."
OSDtable = {}

-- defines Previous Planets table
prevPlanets = {}
prevPlanets.__save = true

payment = 12000

carg_type = "Student" 

title = {}  --stage titles
text = {}   --mission text

title[1] = "Student on a Scholarship"
text[1] = [[    You begin to approach the student. He is furiously scribing down notes. As you approach, he suddenly raises his head and notice you. "What do you think of the increased Ardar demand for Terran luxuries? A long-term cultural shift or mere fashion?", he suddenly blurts out. He is a lively if difficult to follow fellow, and soon both of you are trading stories on weird galactic trade.

"But tell me - you seem to have a knack for trade, and you'd make a good traveling companion. The Luna Imperial College of Economy has offered me a scholarship to go to Ardarshir study the economy of the Roidhunate. Purely for the sake of science, of course. Would you be up for the trip? The grant includes some money, and I can give you a few tips on good trades to be made there."]]

title[2] = "Accept"
text[2] = [[    "Excellent! And we can discuss that new theory I've been working on on the way...", he approves. "Ah, and first trading tip: you might have heard that the Ardars elites have taken a liking to fine wine. I suggest you buy some before departing. You'll have to get it from Terra, of course. The Roidhunate aristocracy won't drink anything from a colony."]]

title[3] = "Refuse"
text[3] = [[    "Ah well, there are other captains out there. Though maybe not with such amusing stories as you do. Safe travels!"]]

finishedtitle = "Arrival"
finishedtxt = [[    "Incredible! Ardarshir itself. I feel like an American in Moscow in say 1960. Sorry, pre-spatial reference... Anyway. Before I leave, one last tip: Ardar Telloch sells very well on Terra and other rich Imperial worlds. You'll only get good one here, so stock up. And here are the %s credits from the grant. Not much, I know... university budgets are not what they used to be."]]

function create ()
   -- Note: this mission does not make any system claims.

   -- creates the NPC at the bar to create the mission
   misn.setNPC( "Working Student", "neutral/unique/youngbusinessman" )
   misn.setDesc( bar_desc )

   startplanet, startsys = planet.cur()

   prevPlanets[1] = startplanet
   prevPlanets.__save = true
end

function accept ()
   if not tk.yesno( title[1], text[1] ) then
      tk.msg( title[3], text[3] )
      misn.finish()

   else
      misn.accept()

      landmarker = misn.markerAdd( planet.get("Ardarshir"):system(), "low" )

      carg_id = misn.cargoAdd( carg_type, 0 )

      -- mission details
      misn.setTitle( misn_title )
      misn.setReward( misn_reward )
      misn.setDesc( misn_desc )

      tk.msg( title[2], text[2] )

      misn.osdCreate(OSDtitle, {OSDdesc})

      -- hooks
      landhook = hook.land ("land")
   end
end

function land ()
   if planet.cur() == planet.get("Ardarshir") then
      tk.msg( finishedtitle, finishedtxt:format( gh.numstring(payment) ) )
      player.pay( payment )

      misn.cargoJet(carg_id)

      hook.rm(landhook)
      misn.finish( true )
   end
end

function abort()
   misn.finish()
end
