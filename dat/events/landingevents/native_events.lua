local event

	event=landingevent_class.createNew()
	event.validNatives={leonids=true,simians=true,carnivorousHumanoids=true,hibernatingReptiles=true,beavers=true,burrowers=true,crabs=true,spiders=true,symbionts=true,hives=true}
	event.uncivilizedOnly=true
	event.weight=20
	event.startTitle="Native attack!"
	event.startText=[[You land next to a small river, at the edge of a strange-looking native forest. Your crew has just started taking samples of the local botany when several dozens fierce-looking natives stream out of the jungle, peppering your men with javelins.

	You have a split-second to decide whether to fall back to the ship or fight. Fight back?]]

	event:addYesOption("Cool under Fire",[[Impressed by your cool, your men calmly fire back at the advancing aliens. Startled by your blasters, the natives break and flee, abandoning their weapons. ${crewJob}

		You collect ${quantity} tonnes of dropped weapons: they look valuable!]],50,
					{crewType=CW.WEAPON,crewPresentText="Your weapon officer ${crewName} ${crewAdv} directs your men, confirming the rout.",crewAbsentText="Without a weapon officer however, poor fire discipline enables most natives to withdraw in good order.",goodQuantity=1,goodQuantityBonus=3,goodType=C.NATIVE_WEAPONS})

	event:addYesOption("A Hasty Decision",[[Your men's attempts to fight back falter almost immediately; few have their weapons ready, and the natives are swift. The fight quickly turns into a rout; ${woundedCrewName} is speared by a projectile.

	It will cost at least ${damages} credits to cover the damages, and ${woundedCrewName} is badly wounded.]],50,{woundCrew=true,damages=500,damagesBonus=1000})

	event:addNoOption("A Narrow Escape",[[Your men and you quickly reach the ship's safety, no harm done. You take-off and order a landing in a different spot, and the survey goes on without further incidents.]],80,{})
	event:addNoOption("A Costly Rout",[[While all your men make it, ${woundedCrewName} is badly wounded, pricey equipment is left behind and the ${shipname} takes minor damage.

		After analysis, you estimate it at ${damages} credits, not to mention ${woundedCrewName} out of commission.]],20,{woundCrew=true,damages=500,damagesBonus=1000})

	landing_events.attackByWarBands=event



	event=landingevent_class.createNew()
	event.validNatives={leonids=true,otters=true,bovines=true,simians=true,carnivorousHumanoids=true,beavers=true,avians=true,burrowers=true,crabs=true,spiders=true,symbionts=true,hives=true}
	event.uncivilizedOnly=true
	event.weight=20
	event.startTitle="The Lost Temple"
	event.startText=[[While scanning the planet, the ${shipname}'s sensors localise an important concentration of valuable minerals in the middle of a desertic area. Further investigation reveal a native building complex, clearly old and abandoned. Its use is unclear - temple, tomb, palace, something too alien for you to understand? But inside it must lie great riches!

	Should you send a party to investigate?]]

	event:addYesOption("Gold!",[[Your men walk in the long-empty rooms covered in the natives' hieroglyphs in total silence, following their hand-held scanners. You feel sure something has to go wrong... but not this time. They reach the large chamber where the scanners had located the minerals without incident and find a large collection of gold statues assembled there.

		The workmanship is superb, and you collect ${quantity} tonnes of the statues. You feel a little guilty but also richer as they bring back the goods on board.]],80,
					{goodQuantity=1,goodQuantityBonus=5,goodType=C.NATIVE_SCULPTURES})

	event:addYesOption("Old Traps",[[Things go smoothly initially, with your men making good progress toward the large hall where the precious minerals seem located. But as they reach sight of their goal, the corridor they are travelling in suddenly collapses around them, trapping the explorers and pinning ${woundedCrewName} beneath a rock. It is hours before they are freed, and none of the men want to go any further.

				You'll never know whether the building simply collapsed from age, a sophisticated hidden mechanism or the vengeance of an alien god; whatever the cause, you are left with ${damages} credits of equipment lost  or damaged, ${woundedCrewName} badly wounded and nothing to show for it.]],20,{woundCrew=true,damages=500,damagesBonus=1000})

	landing_events.templeRiches=event



	event=landingevent_class.createNew()
	event.validNatives={leonids=true,otters=true,simians=true,carnivorousHumanoids=true,burrowers=true,crabs=true,spiders=true,symbionts=true,hives=true}
	event.uncivilizedOnly=true
	event.weight=20
	event.startTitle="The monster and the ${nativesname}"
	event.startText=[[You are exploring a remote area of ${planetname} when you see activity in the distance: a small band of ${nativesname} is cornered at the foot of a cliff by a ferocious-looking creature. Obviously an alpha carnivore, it towers over the natives; its four arms end in razor-sharp claws, and close to it lie the prostrate bodies of defeated warriors. It seems inevitable that the remaining natives will soon join their fallen brethren.

	Should you intervene?]]

	event:addYesOption("Well-earned Tribute",[[All monstrous that it is, the creature cannot resist a few well-placed blaster shots. In a few great convulsions, it collapses at the feet of the remaining ${nativesname}. You stride toward the group, your men behind you. The impressively calm-looking natives study you as you come closer. You raise your hand in greeting while still fifty metres away; maybe in reaction, the natives slowly lower their weapons to the ground, wave their alien heads in a circular pattern, turn their back to you and with gathering speed sprint away from your team, leaving their weapons behind.

				You collect the well-crafted weapons wondering what happened. Did they offer them as thanks, were they an offering to supposed gods, were the natives simply afraid? You will likely never know, but you have earned ${quantity} crates of good-looking weapons.]],60,
					{goodQuantity=1,goodQuantityBonus=3,goodType=C.NATIVE_WEAPONS})

	event:addYesOption("Alien Minds",[[Your men and you take down the creature with a few long-distance shots. While it agonises among the alien grasses, the natives slowly turn toward you. A tall, strong-looking one in particular seems to be studying you intently. You take a few step forwards, raising your arm in peace. The ${nativesname} open its mouth in a weird parody of a smile. You are just two metres from it when it suddenly lunges at you, spear in hand.

				Only lightening-quick fire from your men prevents the weapon from hitting you dead-centre. The spear instead glances on your shoulder before hitting ${woundedCrewName} behind you; your men fall back while the native ignites under the beams of half a dozen blasters. Two minutes later, all the ${nativesname} are dead, felled while rushing your men. You are carried back to the ship half-delirious.

				Your damaged shoulder is quickly rebuilt by the medical bay, though it does cost you ${damages} cr in supplies. What happened is harder to tell. Did the ${nativesname} feel dishonoured by your intervention? Were they so xenophobic they despised you despite your rescue? Or where they simply afraid of your men and you? One more mystery to add for the xenoethnologues.]],40,{woundCrew=true})

	landing_events.nativesAndMonster=event

