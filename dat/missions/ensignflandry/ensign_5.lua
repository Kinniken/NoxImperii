include "universe/generate_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = 50000

-- Mission Details
misn_title = "Bring back Evenfall to Harkan"
misn_reward = ""..payment.." cr"
misn_desc = "Take \"Charlie\", the Siravo alien captured by Flandry, to ${targetPlanet} on ${targetSystem} for treatment."



-- Messages
osd_msg = {}
osd_msg[1] = "Bring back Evenfall to Harkan"
osd_msg["__save"] = true

title = {}  --stage titles
text = {}   --mission text

title[1] = "${startPlanet} Hospital Complex"
text[1] = [[You land on ${startPlanet} and head for the hospital complex where the alien is being treated. As you arrive, the head of the aquatic sophont medical team comes and meet you.

"Captain ${playerName}, we have good news. Evenfall - that's his name, as close as our linguists can translate it - has made a full recovery. His biology is fascinating. He's not a fish, for a start. He's homeothermic; his females give live birth and nurse their young. And under the high atmospheric pressures of his home world, there's enough oxygen dissolved in water to support an active metabolism and a good brain. He's closer to us than he looks.". The scientist continues with long explanations on how they manufactured the needed drugs based on research on similar species from two dozen worlds, but you've stopped listening. In any case you've reached the room where he is hosted.

As you enter the room, Evenfall is moving in his tank. The Siravo is exchanging with the linguist with the aid of a vocalizer. He notices you entering and seems to recognize you, emitting some greeting in his under-sea language. "The Swimmer in the Deep! Be thanked, ${playerName}. Your people have shown great mercy to bring a captive so far to save him. A Hunter would have left me to die away from the Sea.", the vocalizer translates. "They tell me you will bring me home. Do so and I will show you Shellgleam, our city deep in our ocean. And then we can discuss a truce, if the Hunters you supply with weapons are willing to leave us in peace."]]

title[2] = "Incoming Pirates"
text[2] = [[As you liftoff from ${startPlanet}, your ship's computer suddenly flashes an alert: hostile ships inbound! They look like pirates, and are heading straight for you.]]

title[3] = "Highport"
text[3] = [[You land on Highport, glad to have brought Evenfall back safely. During the trip, while not fighting of pirates, he has regaled you with long stories of the cities under the sea and the wonders of his civilization.

Commander Abrams and Lieutnant Flandry are waiting as you exit the ship. You give a quick briefing. Abrams looks distinctly worried when you mention the pirates. Flandry is not listening - he is looking at Evenfall's tank being carried away, in deep thoughts.

The next step will be decided once Abrams has had time to absorb the information from Evenfall.]]