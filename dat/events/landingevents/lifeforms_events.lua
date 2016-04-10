	local event

	event=landingevent_class.createNew()
	event.validPlanets={planetTemplateJungleVenus=true,planetTemplateWarmTerra=true,planetTemplateTemperateTerra=true}
	event.uncivilizedOnly=true
	event.weight=20
	event.startTitle="Marsh Monster"
	event.startText=[[One of your crew is taking samples on the bank of a large marsh when a hungry mass of writhing tentacles surges from the water. Your man rolls away in a split-second, but the beast grasps an expensive sample analyser before diving back in the marsh.

	Should you order the marsh drained to recover your equipment?]]

	event:addYesOption("Value in Everything",[[A maintenance pump from the ${shipname} is quickly brought to the site, and the drainage starts. The monster hides underwater as long as possible, before rising to the surface when the level gets too low. All its tentacles are useless faced with blaster fire, and you soon recover the analyser.

				And bonus, it turns out the monster's carcass contains valuable organic solvents! Not that you care to know to what use they were put by the beast... ${crewJob}]],30,
					{crewType=CW.WEAPON,crewPresentText="Good thing your weapon officer, ${crewName}, proved ${crewAdj} at directing your men to kill the beast without damaging it too much.",crewAbsentText="Without a weapon officer to guide them however, your men blasted away most of the monster before killing it.",goodQuantity=1,goodQuantityBonus=1,goodType=C.EXOTIC_ORGANIC})

	event:addYesOption("A Beast Cornered",[[A maintenance pump from the ${shipname} is quickly brought to the site, and the drainage starts. Everything seems to be going smoothly when the creature emerges again from the middle of the marsh. Your men are ready for an other tentacle attack, but not for the high-pressure acid stream the beast aims at the pump and ${woundedCrewName} before disappearing again.

				It looks like the analyser is gone for good, and so is the pump. Another ${damages} credits lost, and your crewman will be in the medical bay until further notice.]],30,{woundCrew=true,damages=500,damagesBonus=1000})

	event:addYesOption("A Foolish Attempt",[[A maintenance pump from the ${shipname} is quickly brought to the site, and the drainage starts. Several hours later the surface has not appreciably dropped. It seems the marsh is connected to other water sources underground.

				You stop the efforts and write-off your analyser for ${damages} credits.]],40,{damages=300,damagesBonus=0 })

	event:addNoOption("Small Losses","No need wasting time on this. You write-off your analyser for ${damages} credits.",100,{damages=300,damagesBonus=0 })

	landing_events.marshMonster=event




	event=landingevent_class.createNew()
	event.validPlanets={planetTemplateWarmTerra=true,planetTemplateTemperateTerra=true}
	event.uncivilizedOnly=true
	event.weight=10
	event.startTitle="Valley of Flowers"
	event.startText=[[Nested in the lower slopes of a mountain range on ${planetname}'s largest landmass, your men discover a lush, earth-like valley full of fruit-bearing trees and thick grass dotted with flowers. Its attraction on your men is irresistible after so many days in the confines of ${shipname}. And those fruits might be edible, a welcome addition to your depleting on-board stores!

	Do you organise a supply team?]]

	event:addYesOption("A Taste of Eden",[[Your men return with samples of the most common fruits and a blissful look on their faces. The analysis quickly comes back: they are edible. Furthermore, they are delicious!

				You order the collection of as many fruits as can be easily gathered; your men come back with ${quantity} tonnes. They will fetch a good price on sophisticated worlds.]],50,
					{goodQuantity=2,goodQuantityBonus=5,goodType=C.GOURMET_FOOD})

	event:addYesOption("A Serpent in the Fruit",[[Your men set foot on the valley, even more beautiful up close than in the long-distance views. The peaceful scene might have dulled their senses as none of them notice the unnatural silence surrounding them - up to the moment where one man reaches toward one of the hanging fruit. Suddenly the valley is swarming with small flying creatures with leathery wings and sharp teeth, swooping down on the exposed team. Only your insistence that they wear suits and carry blasters allows them to escape with only minor injuries. Good thing too, as the bat-like creatures turn out to be highly poisonous. Bitten crew members are only saved by the medical bay's capacity to generate antidotes to the poison; for ${woundedCrewName} however, lesions are more severe and ${heshe} is put in stasis until a hospital can be reached.

				You've lost ${damages} credits in medicinal supplies, one crewman is out, and your team's moral is rock-bottom. You'll leave ${planetname} without regrets.]],50,{woundCrew=true,damages=500,damagesBonus=1000})

	landing_events.temptationForest=event


	event=landingevent_class.createNew()
	event.validPlanets={planetTemplateJungleVenus=true,planetTemplateWarmTerra=true,planetTemplateTemperateTerra=true,planetTemplateJungleVenus=true}
	event.uncivilizedOnly=true
	event.weight=10
	event.startTitle="Steak on the Horizon"
	event.startText=[[In a wide plain cut into by a mighty river, your probes notice an inviting sight: a horde of plump, slow-moving herbivores. ${planetname}'s biology being human-compatible, they are probably safe to eat, and they look yummy!

	Order a foraging party?]]

	event:addYesOption("The Barbecue of Your Lives",[[The clumsy beasts fail to react as your men take position, trapping them against the river. On your count they open fire on pre-identified animals - particularly handsome-looking specimens. They fall like bricks while the rest of the herd panics.

				You do the inventory in the dying lights of the bonfire your men have roasted the animals on. ${quantity} tonnes of fresh meat! Buffalo Bill would have been proud.]],80,
					{goodQuantity=5,goodQuantityBonus=5,goodType=C.FOOD})

	event:addYesOption("The Shepherds of the Flock",[[If your men had been attentive they might have noticed sooner the strange ripples in the long grass around the herd. Instead the first sign of trouble is a muffled cry by ${woundedCrewName} who was leading the party, falling to the ground with blood streaming from ${hisher} savaged back. In an instant your men find themselves fighting shadows - small, unbelievably quick creatures with razor teeth striking without warning before melting back in the long grass. Only a quick retreat, blasters blazing, gets them out of danger.

				Later surveys by probes shed light on the events: the placid herbivores are shepherded by intelligent social carnivores who protect them from outside threats - and take their pounds of flesh in return.

				Medical bills for wounded crew members set you back ${damages}, ${woundedCrewName} is fighting for ${hisher} life in the medical bay, and there's nothing but soup left in the ship's stores.]],20,{woundCrew=true,damages=500,damagesBonus=1000})

	landing_events.steacksInHerd=event
