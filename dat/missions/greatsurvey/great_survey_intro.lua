
include "jumpdist.lua"
include "numstring.lua"
include "universe/generate_helper.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_services.lua"

bar_desc = "You see an old pilot sitting in a corner, studying people coming in.."

-- Mission Details
misn_title = "The Great Survey"
misn_reward = "Variable, based on the interest of the planets found."
misn_desc = "Explore planets beyond the influence of major powers."

-- OSD
OSDtitle = "The Great Survey"
OSDdesc = "Explore planets beyond the influence of major powers."
OSDtable = {}

-- defines Previous Planets table
prevPlanets = {}
prevPlanets.__save = true



title = {}  --stage titles
text = {}   --mission text

title[1] = "An Old Man with a Dream"
text[1] = [[As you enter the bar, you notice an old man studying you from a distance. You can tell straight away that he is, or at least was, a pilot - he has the odd posture of a man used to zero gravity environments, and his face bears the tan of a thousand suns. And yet he has none of the bravado so common among pilots; his demeanour is almost that of a university professor, lost in a world of his own.

Curious, you head toward him. "Come here, lad!", he exclaims as you get closer. "I can tell you're a new pilot. You have that fire in your eyes!"

You nod and take a seat opposite him. He is still intently peering at you. "Tell me, young pilot, what do you know of the Great Survey?", he begins. You prepare yourself for a long, rambling lecture, but to your surprise he is straightforward and clear. In a few minutes he covers the history of mankind's first great attempt at mapping the stars, before the Empire was even started, when the human race was rushing to discover new worlds and expand outward.

"And so...", he takes a deep breath and continues, "how would you like to take part into the second one?"]]

title[2] = "Accept"
text[2] = [["He quickly explains the gist of it - a handful of ex-pilot dreamers like him have managed to get patronage from some romantically minded Imperial nobles. Not enough to hire ships and carry out an organised effort on the model of the original survey, but enough to properly reward independent pilots who map planets outside the main galactic civilizations. The more interesting the planet and the furthest from Sol, the greater the reward.

"And if you meet uncontacted races with interesting artwork... let me know personally also. I'm still looking for someone to draw me something special... " he adds, lost in thoughts."]]

title[3] = "Refuse"
text[3] = [["I see you already have much to do. If you ever change your mind, you know where to find me. Fly far, my boy!"]]

finishedtitle = "Exploring a new world"
finishedtxt = [[You orbit the world several times, scanning its surface and atmosphere, letting your systems analyse the geology and any living presence, before landing and taking samples. You enter the report into the survey computer provided by the old pilot, and it immediately computes your reward: %s credits. You have just added your first little stone to the new Great Survey!]]

function create ()
   -- Note: this mission does not make any system claims.

   -- creates the NPC at the bar to create the mission
   misn.setNPC( "Old Pilot", "neutral/male1" )
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

   local presences=system.cur():presences()

   if not presences["Empire of Terra"] and not presences["Roidhunate of Ardarshir"] and not presences["Oligarchy of Betelgeuse"] then
      
      local surveyedPlanet=planet_class.load(planet:cur())

      if not surveyedPlanet:hasTag("surveyed") then
         surveyedPlanet:addTag("surveyed")
         surveyedPlanet:addHistory("The world was surveyed by "..player:name().." on board the "..player:ship().." as part of the Second Great Survey.")
         generatePlanetServices(surveyedPlanet)
         surveyedPlanet:save()

         local payment=computePayement(surveyedPlanet)

         tk.msg( finishedtitle, finishedtxt:format( numstring(payment) ) )
         player.pay( payment )

         hook.rm(landhook)
         misn.finish( true )
      end   
   end
end

function computePayement(surveyedPlanet)
   local lx,ly=surveyedPlanet.c:system():coords()
   local distanceValue=math.max(0,(gh.calculateDistance({x=0,y=0},{x=lx,y=ly})-600)*10)

   local reward=distanceValue

   if #(surveyedPlanet.lua.settlements)>1 then
      reward=reward+1000
   end

   reward=reward+surveyedPlanet.lua.humanFertility*1000
   reward=reward+surveyedPlanet.lua.minerals*1000

   return math.floor(reward)

end

function abort()
   misn.finish()
end
