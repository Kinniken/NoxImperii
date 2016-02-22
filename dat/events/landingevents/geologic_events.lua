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
	ANCIENT_TECHNOLOGY="Ancient Technology"

	landing_events.desertWorldOreVein={
		runEvent=function(planet)

		local textData=landingEventsTextData(planet)

		local eventText1=[[While investigating ${planetname}, your scanners detect a strong concentration of rare metals, brought to the surface by volcanic activity. They seem easily reachable even without specialised equipment, but it would require landing the ${shipname} dangerously close to active volcanic ground.

		Should you chance it?]]

		if tk.yesno( "The Lure of Metals", gh.format(eventText1,textData) ) then
			if math.random() <0.3 then
				local quantity=gh.floorTo(5+math.random()*5,0)
				local loot=gh.floorTo(3000+math.random()*3000,-2)
				textData.quantity=quantity
				textData.loot=loot
				tk.msg( "Fortune Favours the Brave", gh.format([[You land the ${shipname} a kilometre from the ores and send a well-protected team to recover them. For a few tense hours, they collect the ores in improvised containers and bring them back to the ship as fast as possible. There is a moment of panic when tremors shake ${planetname} and fresh streams of lava flow a few kilometres from the ship, but things calm down and your crew finishes the job.

					After moving the ship to a safer location, you do an inventory of the ores: there are at least ${quantity} tonnes of valuable ores, plus a quantity of precious metal worth a solid ${loot} credits!]],textData) )
				player.addCargo(ORE,quantity)
				player.pay(loot)
			else
				local damages=gh.floorTo(5000+math.random()*5000,-2)
				textData.damages=damages
				tk.msg( "Disaster!", gh.format([[The ${shipname} has barely landed close to the ore veins when the ground shakes furiously. It takes only minutes from fresh lava to come hurling toward the ship while you scramble in an emergency lift-off.

					Your quick reflexes saved the ${shipname}, but not before the lava heavily damaged the lower hull. Your crew is able to carry out repairs in a more tranquil spot on the planet, but the damages still cost you ${damages} credits in supplies.]],textData) )
				player.pay(-damages)
			end
		end
		end,
		weightValidity=function(planet)
		local validPlanets={planetTemplateMercury=true,planetTemplateVenus=true,planetTemplateMars=true}

		return validPlanets[planet.lua.planetType] and (#planet.lua.settlements)==0
		end,
		weight=10
	}

	landing_events.desertWorldAncientMiningStation={
		runEvent=function(planet)

		local textData=landingEventsTextData(planet)

		local eventText1=[[Hidden deep within a massive canyon, your scanners detect the last thing you expected: ruins! Broken-down but still recognisable as such is some kind of mining station. Analysis of the location and the rocks around it soon provide you with an estimate of their age; around fifty thousand years. And since even then ${planetname} was incapable of supporting life, there is only one possibility: those ruins belong to an ancient space-faring civilization.

		You know the price such ancient technologies can fetch in modern capitals; you've also heard of the fates met by many a seeker of such relict. Will you order a search?]]

		if tk.yesno( "Ruins older than the Pyramids", gh.format(eventText1,textData) ) then
			if math.random() <0.3 then
				local quantity=gh.floorTo(1+math.random()*3,0)
				textData.quantity=quantity
				tk.msg( "Mysterious Devices", gh.format([[Up close, the ancient mining station is not so impressive; the Empire and the Ardars build bigger, more sophisticated-looking complexes. And yet the age of the walls you are touching is awe-inspiring.

					Your men locate rooms full of materials and quickly transport it to the ${shipname}, for a total of ${quantity} tonnes of storage space. Your lift-off is strangely anti-climatic.]],textData) )
				player.addCargo(ANCIENT_TECHNOLOGY,quantity)
			else
				local damages=gh.floorTo(5000+math.random()*5000,-2)
				textData.damages=damages
				tk.msg( "The Price of Arrogance", gh.format([[The ${shipname} is still several kilometres away from the site when a blinding light streams from the old mining complex. Your ship's shields struggle to contain the blast of radiations and fail to prevent extensive damages to the electronic systems, though at least the crew is safe. When the light returns to normal and you scan the site from a safer distance, the evidence is overwhelming: a thermonuclear device has just wiped-out the canyon. Why the ancient race thought to booby-trap their installation and how they designed a mechanism capable of surviving across fifty millennia you will never know.

					Repairing your ship's electronics afterwards costs you ${damages} credits.]],textData) )
				player.pay(-damages)
			end
		end
		end,

		weightValidity=function(planet)
		local validPlanets={planetTemplateMercury=true,planetTemplateVenus=true,planetTemplateMars=true}

	local civilizedPresence=(#planet.c:system():presences()>1 or (#planet.c:system():presences()==1 and not planet.c:system():presences()["Barbarians"]))--systems with non-barbarian presence

	return validPlanets[planet.lua.planetType] and not civilizedPresence
	end,
	weight=5
}

landing_events.viableWorldAncientShip={
	runEvent=function(planet)

	local textData=landingEventsTextData(planet)

	local eventText1=[[Your initial scans had picked up no signs of ${planetname} being settled by beings with advanced technology, and so it is with great surprise that you discover the results of surveys in a inhospitable region of dense forests: a few meters below the surface you discern the unmistakable outline of a spaceship! Further analysis confirms that it has been there for several millennia, long before the rise of the Empire or that of any of its rivals.

	There is no way to predict what dangers lie in the ship, and yet it contains promises of great riches. Will you investigate?]]

	if tk.yesno( "The Lost Spaceship", gh.format(eventText1,textData) ) then
		if math.random() <0.3 then
			local quantity=gh.floorTo(1+math.random()*2,0)
			textData.quantity=quantity
			tk.msg( "Ancient Mechanisms", gh.format([[The soil is tightly-packed and the vegetation above it thick, but the modern tools aboard the ${shipname} make quick work of both. Soon the ancient ship is exposed to the air again. Signs point to an ancient crash, and much of the ship is destroyed beyond investigation. However you do manage to recover what looks like parts of the navigation systems.

				On board the ${shipname}, your men carefully store the ${quantity} tonnes of mechanisms recovered. No doubt some scientists somewhere will give you a good price for them.]],textData) )
			player.addCargo(ANCIENT_TECHNOLOGY,quantity)
		else
			local damages=gh.floorTo(2000+math.random()*5000,-2)
			textData.damages=damages
			tk.msg( "Old but Deadly", gh.format([[Your team manages to dig toward the remains of the ship easily enough, and are soon entering the former hull and removing everything that looks like ancient machines. While one of your man is loading the latest cargo in one of the ${shipname}'s rover, he notices rapidly increasing radioactivity coming from the crates. His quick alerts allows the crew to flee the scene fast, but without the rover and the extraction equipment.

				By the time a second team with proper radiation protection arrives on the spot, it is too late to save anything left behind; everything is now highly radioactive. It seems like the equipment removed from the ancient hull included an old fission pile, which got damaged and started leaking. There's nothing left for you to do but to write-off the equipment; ${damages} credits should cover it.]],textData) )
			player.pay(-damages)
		end
	end
	end,
	weightValidity=function(planet)
	local validPlanets={planetTemplateJungleVenus=true,planetTemplateWarmTerra=true,planetTemplateTemperateTerra=true}

	local civilizedPresence=(#planet.c:system():presences()>1 or (#planet.c:system():presences()==1 and not planet.c:system():presences()["Barbarians"]))

	return validPlanets[planet.lua.planetType] and not civilizedPresence
	end,
	weight=5
}

landing_events.gasGiantExtractionStation={

	runEvent=function(planet)

	local textData=landingEventsTextData(planet)

	local eventText1=[[You put the ${shipname} in orbit around ${planetname} and start scanning the rings that surround the planet. The first results are exactly what you expect - the usual mix of small rocky asteroids and of chunks of ice. And then suddenly your scanner detects something quite different: a large metallic object that can only be artificial! Further analysis reveal it to likely be the remain of an atmospheric extraction facility. And it seems old, very old... older than the Empire, at least.

	Valuable technology might lie in that wreck, but it is in a dangerous orbit. And even inert-looking ancient technology can be more dangerous than it looks. Should you bring the ${shipname} closer to investigate?]]

	if tk.yesno( "Ancient Outposts", gh.format(eventText1,textData) ) then
		if math.random() <0.3 then

			local quantity=gh.floorTo(1+math.random()*2,0)

			textData.quantity=quantity

			tk.msg( "Successful Rendez-vous", gh.format([[Lightly manoeuvring the ${shipname}, you settle in an orbit a hundred metres from the derelict station. Your men gingerly explore the ruin in the low light reflected from ${planetname}, loading into crates everything that looks like it was part of an ancient machine or computer before shipping it back to the ${shipname}.

				You settle your ship in a more stable orbit before doing a quick inventory; your men have recovered ${quantity} tonnes of mechanisms of various kinds. Now you just need to find a buyer.]],textData) )

			player.addCargo(ANCIENT_TECHNOLOGY,quantity)

		else

			local damages=gh.floorTo(2000+math.random()*5000,-2)

			textData.damages=damages

			tk.msg( "Unstable Orbits", gh.format([[Approaching the old station is a tricky work, as it is located in the middle of a ring of dust mixed with larger rocks. You feel you are doing well until you need to swerve at the last minute to avoid an unexpected rock - straight into a second one. The ${shipname}'s shields absorb the impact, but not without damages, and you watch helplessly as the rock is deviated in a trajectory sending it toward the antique outpost, striking it with a glancing blow. The venerable structure resists the blow, but the energy transmitted makes it start to tumble on itself and leave its stable orbit. It is now falling toward ${planetname}, and it is rotating too rapidly to attempt a rendez-vous.

				It's time to cut your losses and estimate the damages suffered: at least ${damages} credits.]],textData) )

			player.pay(-damages)

		end
	end
	end,

	weightValidity=function(planet)

	local validPlanets={planetHotJupiter=true,planetJovian=true}

	local civilizedPresence=(#planet.c:system():presences()>1 or (#planet.c:system():presences()==1 and not planet.c:system():presences()["Barbarians"]))

	return validPlanets[planet.lua.planetType] and not civilizedPresence
	end,
	weight=5
}

landing_events.gasGiantOrbitalDebris={

	runEvent=function(planet)

	local textData=landingEventsTextData(planet)

	local eventText1=[[The orbit around the gas giant is difficult to navigate due to the quantity of debris surrounding the world. Distracted by the sumptuous view of ${planetname}'s swirling atmosphere, you fail to notice in time a cluster of rocks in an unstable orbit. They hit the ${shipname}, causing minor damages. On the plus side, they disintegrated during the impact, displaying rich iron ores.

	Should you try and capture those rocks, at the risk of further damage?]]

	if tk.yesno( "Congested Orbits", gh.format(eventText1,textData) ) then
		if math.random() <0.7 then

			local quantity=gh.floorTo(2+math.random()*5,0)
			local damages=gh.floorTo(500+math.random()*500,-2)

			textData.quantity=quantity
			textData.damages=damages

			tk.msg( "An Easy Capture", gh.format([[You carefully compute a corrected trajectory for the ${shipname}, bringing the ship in close proximity to the revealed ores. A small team sorties to bring them in.

				You've collected ${quantity} tonnes of ores, compensation for the ${damages} credits worth of damages suffered.]],textData) )

			player.addCargo(ORE,quantity)
			player.pay(-damages)

		else

			local damages=gh.floorTo(1000+math.random()*1000,-2)

			textData.damages=damages

			tk.msg( "Iceberg Straight Ahead!", gh.format([[Following the rocks quickly turns more complicated than anticipated. Your sensor is confused by the great clouds of orbiting dust, and the ${shipname}'s computers struggle to keep track of all the rocks in orbit. You've almost given up on catching those ores when several tonnes of ice cross your path, battering the ${shipname} again. It's time to give up and move to a less dangerous orbit.

				The two collisions battered your shields and damaged the ship's armour. Your engineer estimates ${damages} credits for the repairs.]],textData) )

			player.pay(-damages)

		end
	else
		local damages=gh.floorTo(500+math.random()*500,-2)

		textData.damages=damages

		tk.msg( "Cutting your Losses", gh.format([[You quickly move the ${shipname} on a more stable orbit around ${planetname} and inspects the damages.

			Thankfully they are quite light; ${damages} credits should cover it.]],textData) )

		player.pay(-damages)
	end
	end,

	weightValidity=function(planet)

	local validPlanets={planetHotJupiter=true,planetJovian=true}

	return validPlanets[planet.lua.planetType] and (#planet.lua.settlements)==0
	end,
	weight=10
}

landing_events.gasGiantRichMoonlet={

	runEvent=function(planet)

	local textData=landingEventsTextData(planet)

	local eventText1=[[Your scan of ${planetname}'s rings reveal the usual mix of dust, ancient rocks and blocks of ice, all of little value. Only one target seems interesting: a moonlet of a few hundred tonnes, on which scanners pick up unusual quantities of platinum.

	The approach trajectory is a little difficult, but nothing you haven't done before. Should you order a mining expedition?]]

	if tk.yesno( "Shiny, Shiny Moon", gh.format(eventText1,textData) ) then
		if math.random() <0.7 then

			local loot=gh.floorTo(2000+math.random()*2000,-2)

			textData.loot=loot

			tk.msg( "Easy Pickings", gh.format([[You confidently slide the ${shipname} in orbit alongside the moonlet, and send hand-picked men on the surface with makeshift mining tools. While there is no time or resources for a proper excavation, they still manage to collect significant amounts of the precious metal.

				You've just collected several kilos of platinum in a few hours, and your bank account is now ${loot} credits heavier.]],textData) )

			player.pay(loot)
		else

			local damages=gh.floorTo(500+math.random()*1000,-2)

			textData.damages=damages

			tk.msg( "Not all that Glitter is Gold", gh.format([[You confidently slide the ${shipname} in orbit alongside the moonlet, and send hand-picked men on the surface with makeshift mining tools. They run into troubles almost immediately; the moonlet's surface is rough and the platinum lies below unstable rocks. Your team persevere for a few hours, with little to show for it but broken drills and narrowly-avoided accidents. When the tunnel painstakingly dug toward a platinum deposit collapses in slow-motion just as one of your man was going to enter it, you call off the attempt.

				You're left with a ${damages} cr bill and no platinum. Better luck next time!]],textData) )

			player.pay(-damages)

		end
	end
	end,

	weightValidity=function(planet)

	local validPlanets={planetHotJupiter=true,planetJovian=true}

	return validPlanets[planet.lua.planetType] and (#planet.lua.settlements)==0
	end,
	weight=10
}