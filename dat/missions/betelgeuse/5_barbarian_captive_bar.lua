
include "dat/scripts/general_helper.lua"
include "dat/missions/supportfiles/common.lua"

payment = 1000000

-- Mission Details
misn_title = "Rescue the Doge's brother from ${targetPlanet}"
misn_reward = gh.numstring(payment).." cr"
misn_desc = "Locate ${targetPlanet} in the Orion nebula, north-west of Betelgeuse, and rescue the Doge's brother from it."

bar_desc="A group of senior Betelgian officials is clustered in a corner of the room. You recognised an angry-looking Rastapopoulos among them."

-- Messages
osd_msg = {}
osd_msg[1] = "Find ${targetPlanet} in the Orion Nebula, north-west of Betelgeuse."
osd_msg[2] = "Bribe your way into ${targetPlanet} to free the Prince."
osd_msg[3] = "Return to ${returnPlanet} with him."
osd_msg["__save"] = true


title = {}  --stage titles
text = {}   --mission text

title[1] = "A Doge' Ransom"
text[1] = [[The group quietens as you approach, stern faces turning toward you. One of the official starts gesturing for you to leave when Rastapopoulos interferes: "Blistering novas, let him come through! He might be just the man we need.". Objections from other officials are quickly drowned in a sea of creative insults. "Lily-livered space baboons! Gibbering galactic gadflies! Don't you know ${playerName}? He's assisted me numerous times, and other Great Houses also. He's exactly the man we need - all expensive that he is.", Rastapopoulos berates them.

"Very well.", starts what looks like the most senior of them. "I shall be brief. Lord Navi, brother of His Splendour the Doge, has been captured by barbarians while leading an exploration fleet in the far coreward. We have just received the random demand. It is... astronomical". Behind him, Rastapopoulos is getting agitated again. "Rotten replicants! Shameless sycophants! They've asked for a billion credits, plans for all our warships, and a million bottles of telloch, can you imagine that?", he interrupts, shaking the table with his fists. The official signals gun to stop and continues. 

"There is no possibility of us honouring their demands. It would not just bankrupt us - it would leave that barbarian horde with the means to dominate the coreward fringes, possibly even to threaten the Empire and Betelgeuse directly. Thankfully, we did manage to bribe the messenger into revealing more than he was supposed to. We know where the Prince is held. Will you help us rescue him?]]

title[2] = "Legends and Fear"
text[2] = [["I'm glad we could count on you, ${playerName}. I'm afraid we have not told you the whole thing yet. Captain ${playerName}, have you heard of Kaznor? Few people have, even among Betelgian explorers, and even less know that it really exists.", the official continues, fear showing on his stern faces.

"No Betelgian has ever been there and back, but the little information we have describe it as a large, cold planet in orbit around a small red star. It is home to a fierce humanoid race that possess primitive FTL technology. So far, not very different from many barbarian worlds... The Kaznorites have proven craftier than most such species however, and turned their world into a kind of meeting place for the surrounding kingdoms. It's there that major raids are decided, captives traded, stolen technology exchanged...", he continues, hiding his fear behind his long-winded explanations.

"Miserable mandarin, cut the blabber!", Rastapopoulos suddenly interjects. "The important thing is this: Kaznor is deep in the Orion nebula. And we don't know where."]]

title[3] = "Where no Betelgian has Explored Before"
text[3] = [["So the mission is this: you have to explore a barbarian-filled nebula nobody has ever mapped, find a world nobody has come back from, land a rescue team there, and get out alive." Rastapopoulos continues, looking very excited. "Blistering Big Bang! If I was any younger, I'd surely join you."

"One more thing, thundering novas! Deep in the nebula, we've had reports that shields start to fail, leaving ships dependant on their hulls only. Bad luck, armour is exactly what the rascals have lots of. Give them hell, ${playerName}!", he finishes, almost toppling the telloch bottle standing in front of him.]]

title[4] = "Heart of Darkness"
text[4] = [[As you came down, you had a longer view of the world than you'd have liked - cold and dreary, with little signs of civilized presence; most Kraznorite settlements seem stuck in the stone age. There's only one settlement with a real modern industrial presence and an active spaceport. You land at the edge of it, attracting little attention among the varied crowd.

The Betelgian commando team quickly exits and head toward the city. You hunker down with your crew and wait.

You're falling asleep in front of the ${shipName}'s controls when your communicator suddenly lights up. The head of the commando team has located the barely-guarded prince and escaped with him. The guards are following quickly behind. You lift off the the ${shipName} as soon as they are aboard, just as the Kraznorite soldiers start firing at you.]]

title[5] = "Prince Among Prince"
text[5] = [[You land on Dandalo in triumph, exiting the ${shipName} under wild cheers alongside the Prince and the leader of the commando. The Doge in person is there to welcome back his brother.

The banquet that follows is memorable; toasts follows toasts. Most participants are a little drunk by the time the Doge himself makes the commando leader and you honorary princes.

You leave the feast with a shiny new medal, not to mention a ${payment} credits reward from a grateful Betelgian government.]]


function getStringData()
   local stringData={}
   stringData.playerName=player:name()
   stringData.shipName=player:ship()
   stringData.targetPlanet=targetPlanet:name()
   stringData.targetSystem=targetPlanet:system():name()
   stringData.returnPlanet=returnPlanet:name()
   stringData.returnSystem=returnPlanet:system():name()
   stringData.payment=gh.numstring(payment)
   return stringData
end

function create ()
   targetPlanet=planet.get("Kaznor")
   returnPlanet=planet.get("Dandalo")
   -- creates the NPC at the bar to create the mission
   misn.setNPC( "Rastapopoulos", "neutral/unique/aristocrat" )
   misn.setDesc( bar_desc )
end

function accept()
   local stringData=getStringData()

   if not tk.yesno( gh.format(title[1],stringData), gh.format(text[1],stringData) ) then
      misn.finish()
   end

   tk.msg( gh.format(title[2],stringData), gh.format(text[2],stringData) )

   tk.msg( gh.format(title[3],stringData), gh.format(text[3],stringData) )

   misn.accept()

  -- mission details
  misn.setTitle( gh.format(misn_title,stringData) )
  misn.setReward( gh.format(misn_reward,stringData)  )
  misn.setDesc( gh.format(misn_desc,stringData) )

  osd_msg = gh.formatAll(osd_msg,stringData)
  misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

     -- hooks
   landhook = hook.land ("land_target")
   spacetargethook = hook.enter ("space_target")
   spaceorionhook = hook.enter ("space_orion")
end

function space_target ()
  if system.cur() == targetPlanet:system() then
    player.msg ("You have discovered the legendary Kaznor!")
    misn.osdActive(2)    
    hook.rm(spacetargethook)
  end
end

function space_orion ()
  if system.cur():getZone()=="Outer Orion Nebula" or system.cur():getZone()=="Inner Orion Nebula" then
    player.msg ("You have reached the Orion Nebula. Kaznor is supposedly in the middle of it.")
    hook.rm(spaceorionhook)
  end
end

function land_target ()
   if planet.cur() == targetPlanet then
      local stringData=getStringData()

       tk.msg( gh.format(title[4],stringData), gh.format(text[4],stringData) )

       misn.markerRm(landmarker)
       landmarker = misn.markerAdd( returnPlanet:system(), "plot" )
       misn.osdActive(3)

       hook.rm(landhook)
       landhook = hook.land ("land_final")
      
   end
end

function land_final()

  if planet.cur() == returnPlanet then

    local stringData=getStringData()

    tk.msg( gh.format(title[5],stringData), gh.format(text[5],stringData) )

    misn.markerRm(landmarker)
    player.pay( payment )
    faction.modPlayerSingle( G.BETELGEUSE, 10 )
    player.addOutfit("Betelgian Merchant Prince",1)
    var.push("betelgeuse_missions_5",true)

    hook.rm(landhook)
    misn.finish( true )
  end
end


function abort()
   misn.finish()
end
