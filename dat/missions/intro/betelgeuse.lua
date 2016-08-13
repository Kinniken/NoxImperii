

include "jumpdist.lua"

bar_desc = "You see a sharply-dressed business man, looking tense."

payment = 50000

-- Mission Details
misn_title = "Betelgeuse Luxury"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Take the luxury goods to Dandalo, in the Betelgeuse system."

-- OSD
OSDtitle = "Betelgeuse Luxury"
OSDdesc = "Take the luxury goods to Dandalo, in the Betelgeuse system."
OSDtable = {}

-- defines Previous Planets table
prevPlanets = {}
prevPlanets.__save = true

carg_type = "Latest Fashion" 


title = {}  --stage titles
text = {}   --mission text

title[1] = "Business man in a hurry"
text[1] = [[    You can tell the man is worried about something - and your second sense tells you there might be money to be made. You approach him and offer him a beer. He looks at you suspiciously, but seems interested when he realizes you are a captain. "You've obviously realized I'm in some trouble - yes I am, and maybe you can help. I have a lucrative deal with one of the most important Merchant Prince of the Oligarchy - I ship him the latest Terran fashion as soon as it appears at the Imperial court so he gets it before his peers. And as you probably guessed, I have the latest creation of Sylvie Sainte-Clemence and my pilot has deserted. Interested in the job? Betelgeuse is far but I'll make it worth your while."

Out of habit, you bargain with him. He must be really desperate - he's willing to pay 50000 for a single delivery, of a costume weighting two kilos at most!]]

title[2] = "Accept"
text[2] = [[    "It's a rip-of, but still better than losing that deal! Now hurry, at least."]]

title[3] = "Refuse"
text[3] = [[    "Why did you waste my time with your idle bargaining if you're not even willing to take the deal? Get lost!"]]

finishedtitle = "Arrival"
finishedtxt = [[    Even before you land, the crew of the Merchant Prince has positioned itself. In less than ten minutes the goods have been offloaded. Apparently there is a major festival tomorrow and the Betelgian noble wants to be dressed in the new creations.]]

function create ()
   -- Note: this mission does not make any system claims.

   -- creates the NPC at the bar to create the mission
   misn.setNPC( "Worried businessman", "neutral/unique/shifty_merchant" )
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

      landmarker = misn.markerAdd( planet.get("Dandalo"):system(), "low" )

      -- mission details
      misn.setTitle( misn_title )
      misn.setReward( misn_reward )
      misn.setDesc( misn_desc )

      tk.msg( title[2], text[2] )

      carg_id = misn.cargoAdd( carg_type, 0 )

      misn.osdCreate(OSDtitle, {OSDdesc})

      -- hooks
      landhook = hook.land ("land")
   end
end

function land ()
   if planet.cur() == planet.get("Dandalo") then
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
