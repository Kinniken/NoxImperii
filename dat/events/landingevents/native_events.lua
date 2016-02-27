
--Const copy-pasted for auto-completion. Not best design but avoids mistakes
EXOTIC_FOOD="Exotic Food"
FOOD="Food"
GOURMET_FOOD="Gourmet Food"
BORDEAUX="Bordeaux Grands Crus"
TELLOCH="Roidhun Fine Telloch"

PRIMITIVE_CONSUMER="Primitive Consumer Goods"
CONSUMER_GOODS="Consumer Goods"
LUXURY_GOODS="Luxury Goods"

EXOTIC_FURS="Exotic Furs"
NATIVE_ARTWORK="Native Artworks"
NATIVE_SCULPTURES="Native Sculptures"

ORE="Ore"

BASIC_TOOLS="Non-Industrial Tools"
PRIMITIVE_INDUSTRIAL="Primitive Industrial Goods"
INDUSTRIAL="Industrial Goods"
MODERN_INDUSTRIAL="Modern Industrial Goods"

EXOTIC_ORGANIC="Exotic Organic Components"
HUMAN_MEDICINE="Human Medicine"

NATIVE_WEAPONS="Native Weapons"
BASIC_WEAPONS="Non-Industrial Weapons"
PRIMITIVE_ARMAMENT="Primitive Armament"
ARMAMENT="Armament"
MODERN_ARMAMENT="Modern Armament"

NATIVE_TECHNOLOGY="Native Technology"

landing_events.attackByWarBands={
	runEvent=function(planet)

	local textData=landingEventsTextData(planet)

	local eventText1=[[You land next to a small river, at the edge of a strange-looking native forest. Your crew has just started taking samples of the local botany when several dozens fierce-looking natives stream out of the jungle, peppering your men with javelins.

	You have a split-second to decide whether to fall back to the ship or fight. Fight back?]]

	if not tk.yesno( "Native attack!", gh.format(eventText1,textData) ) then

		if math.random() <0.8 then
			tk.msg( "A Narrow Escape", "Your men and you quickly reach the ship's safety, no harm done. You take-off and order a landing in a different spot, and the survey goes on without further incidents." )
		else
			local damages=gh.floorTo(500+math.random()*1000,-2)
			textData.damages=damages
			tk.msg( "A Costly Rout", gh.format("While all your men make it, there are wounded, pricey equipment is left behind and the ${shipname} takes minor damage. After analysis, you estimate it at ${damages} credits.",textData) )
			player.pay(-damages)
		end
	else
		if math.random() <0.5 then
			local quantity=gh.floorTo(1+math.random()*3,0)
			textData.quantity=quantity
			tk.msg( "Cool under Fire", gh.format"Impressed by your cool, your men calmly fire back at the advancing aliens. Startled by your blasters, the natives break and flee, abandoning their weapons. You collect ${quantity} of them: they look valuable!",textData) )
			player.addCargo(NATIVE_WEAPONS,quantity)
		else
			local damages=gh.floorTo(1000+math.random()*2000,-2)
			textData.damages=damages
			tk.msg( "A Hasty Decision", gh.format("Your men's attempts to fight back falter almost immediately; few have their weapons ready, and the natives are swift. The fight quickly turns into a rout, with several of your men wounded and much damages to your equipment. It will cost at least ${damages} credits to cover the damages.",textData) )
			player.pay(-damages)
		end
	end
	end,
	weightValidity=function(planet)
	local validNatives={leonids=true,simians=true,carnivorousHumanoids=true,hibernatingReptiles=true,beavers=true,burrowers=true,crabs=true,spiders=true,symbionts=true,hives=true}

	return planet.lua.natives and validNatives[planet.lua.natives.type]
	end,
	uncivilizedOnly=true,
	weight=20
}

landing_events.templeRiches={
	runEvent=function(planet)
	local textData=landingEventsTextData(planet)

	local eventText1=[[While scanning the planet, the ${shipname}'s sensors localise an important concentration of valuable minerals in the middle of a desertic area. Further investigation reveal a native building complex, clearly old and abandoned. Its use is unclear - temple, tomb, palace, something too alien for you to understand? But inside it must lie great riches!

	Should you send a party to investigate?]]

	if tk.yesno( "The Lost Temple", gh.format(eventText1,textData) ) then
		if math.random() <0.8 then
			local loot=gh.floorTo(2000+math.random()*2000,-2)
			textData.loot=loot
			tk.msg( "Gold!", gh.format("Your men walk in the long-empty rooms covered in the natives' hieroglyphs in total silence, following their hand-held scanners. You feel sure something has to go wrong... but not this time. They reach the large chamber where the scanners had located the minerals without incident and find a large collection of gold statues assembled there. The workmanship is crude, but the metal must be worth ${loot} credits. You feel a little guilty but also richer as they bring back the goods on board.",textData) )
			player.pay(loot)
		else
			local damages=gh.floorTo(500+math.random()*1000,-2)
			textData.damages=damages
			tk.msg( "Old Traps", gh.format([[Things go smoothly initially, with your men making good progress toward the large hall where the precious minerals seem located. But as they reach sight of their goal, the corridor they are travelling in suddenly collapses around them, trapping the explorers. It is hours before they are freed, and none of the men want to go any further.

				You'll never know whether the building simply collapsed from age, a sophisticated hidden mechanism or the vengeance of an alien god; whatever the cause, you are left with ${damages} credits of equipment lost or damaged and nothing to show for it.]],textData) )
			player.pay(-damages)
		end
	end
	end,
	weightValidity=function(planet)
	local validNatives={leonids=true,otters=true,bovines=true,simians=true,carnivorousHumanoids=true,beavers=true,avians=true,burrowers=true,crabs=true,spiders=true,symbionts=true,hives=true}
	return planet.lua.natives and validNatives[planet.lua.natives.type]
	end,
	uncivilizedOnly=true,
	weight=20
}

landing_events.nativesAndMonster={
	runEvent=function(planet)
	local textData=landingEventsTextData(planet)

	local eventText1=[[You are exploring a remote area of ${planetname} when you see activity in the distance: a small band of ${nativesname} is cornered at the foot of a cliff by a ferocious-looking creature. Obviously an alpha carnivore, it towers over the natives; its four arms end in razor-sharp claws, and close to it lie the prostrate bodies of defeated warriors. It seems inevitable that the remaining natives will soon join their fallen brethren.

	Should you intervene?]]

	if tk.yesno( gh.format("The monster and the ${nativesname}",textData), gh.format(eventText1,textData) ) then
		if math.random() <0.6 then

			local quantity=gh.floorTo(1+math.random()*3,0)
			textData.quantity=quantity

			tk.msg( "Well-earned Tribute", gh.format([[All monstrous that it is, the creature cannot resist a few well-placed blaster shots. In a few great convulsions, it collapses at the feet of the remaining ${nativesname}. You stride toward the group, your men behind you. The impressively calm-looking natives study you as you come closer. You raise your hand in greeting while still fifty metres away; maybe in reaction, the natives slowly lower their weapons to the ground, wave their alien heads in a circular pattern, turn their back to you and with gathering speed sprint away from your team, leaving their weapons behind.

				You collect the well-crafted weapons wondering what happened. Did they offer them as thanks, were they an offering to supposed gods, were the natives simply afraid? You will likely never know, but you have earned ${quantity} crates of good-lucking weapons.]],textData) )
			player.pay(loot)
		else
			local damages=gh.floorTo(500+math.random()*1000,-2)
			textData.damages=damages
			tk.msg( "Alien Minds", gh.format([[Your men and you take down the creature with a few long-distance shots. While it agonises among the alien grasses, the natives slowly turn toward you. A tall, strong-looking one in particular seems to be studying you intently. You take a few step forwards, raising your arm in peace. The ${nativesname} open its mouth in a weird parody of a smile. You are just two metres from it when it suddenly lunges at you, spear in hand.

				Only lightening-quick fire from your men prevents the weapon from hitting you dead-centre. You instead take the spear in the shoulder, falling back while the native ignites under the beams of half a dozen blasters. Two minutes later, all the ${nativesname} are dead, felled while rushing your men. You are carried back to the ship half-delirious.

				Your damaged shoulder is quickly rebuilt by the med bay, though it does cost you ${damages} cr in supplies. What happened is harder to tell. Did the ${nativesname} feel dishonoured by your intervention? Were they so xenophobic they despised you despite your rescue? Or where they simply afraid of your men and you? One more mystery to add for the xenoethnologues.]],textData) )
			player.pay(-damages)
		end
	end
	end,
	weightValidity=function(planet)
	local validNatives={leonids=true,otters=true,simians=true,carnivorousHumanoids=true,burrowers=true,crabs=true,spiders=true,symbionts=true,hives=true}
	return planet.lua.natives and validNatives[planet.lua.natives.type]
	end,
	uncivilizedOnly=true,
	weight=20
}
