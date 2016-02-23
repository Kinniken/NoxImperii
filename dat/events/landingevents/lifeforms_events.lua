

landing_events.marshMonster={
	runEvent=function(planet)

	local textData=landingEventsTextData(planet)

	local eventText1=[[One of your crew is taking samples on the bank of a large marsh when a hungry mass of writhing tentacles surges from the water. Your man rolls away in a split-second, but the beast grasps an expensive sample analyser before diving back in the marsh.

	Should you order the marsh drained to recover your equipment?]]

	if tk.yesno( "Marsh Monster", eventText1 ) then
		if math.random() <0.3 then
			tk.msg( "Value in Everything", gh.format([[A maintenance pump from the ${shipname} is quickly brought to the site, and the drainage starts. The monster hides underwater as long as possible, before rising to the surface when the level gets too low. All its tentacles are useless faced with blaster fire, and you soon recover the analyser.

				And bonus, it turns out the monster's carcass contains valuable organic solvents! Not that you care to know to what use they were put by the beast...]],textData) )
			player.addCargo(EXOTIC_ORGANIC,1)
		elseif math.random() <0.5 then
			local damages=gh.floorTo(500+math.random()*1000,-2)
			textData.damages=damages
			tk.msg( "A Beast Cornered", gh.format([[A maintenance pump from the ${shipname} is quickly brought to the site, and the drainage starts. Everything seems to be going smoothly when the creature emerges again from the middle of the marsh. Your men are ready for an other tentacle attack, but not for the high-pressure acid stream the beast aims at the pump before disappearing again.

				It looks like the analyser is gone for good, and so is the pump. Another ${damages} credits lost.]],textData) )
			player.pay(-damages)
		else
			local damages=300
			textData.damages=damages
			tk.msg( "A Foolish Attempt", gh.format([[A maintenance pump from the ${shipname} is quickly brought to the site, and the drainage starts. Several hours later the surface has not appreciably dropped. It seems the marsh is connected to other water sources underground.

				You stop the efforts and write-off your analyser for ${damages} credits.]],textData) )
			player.pay(-damages)
		end
	else
		local damages=300
		textData.damages=damages
		tk.msg( "Small Losses", gh.format("No need wasting time on this. You write-off your analyser for ${damages} credits.",textData) )
		player.pay(-damages)
	end
	end,
	weightValidity=function(planet)
	local validPlanets={planetTemplateJungleVenus=true,planetTemplateWarmTerra=true,planetTemplateTemperateTerra=true}

	return validPlanets[planet.lua.planetType]
	end,
	uncivilizedOnly=true,
	weight=20
}

landing_events.temptationForest={
	runEvent=function(planet)

	local textData=landingEventsTextData(planet)

	local eventText1=[[Nested in the lower slopes of a mountain range on ${planetname}'s largest landmass, your men discover a lush, earth-like valley full of fruit-bearing trees and thick grass dotted with flowers. Its attraction on your men is irresistible after so many days in the confines of ${shipname}. And those fruits might be edible, a welcome addition to your depleting on-board stores!

	Do you organise a supply team?]]

	if tk.yesno( "Valley of Flowers", gh.format(eventText1,textData) ) then
		if math.random() <0.5 then
			local quantity=gh.floorTo(2+math.random()*2)
			textData.quantity=quantity
			tk.msg( "A Taste of Eden", gh.format([[Your men return with samples of the most common fruits and a blissful look on their faces. The analysis quickly comes back: they are edible. Furthermore, they are delicious!

				You order the collection of as many fruits as can be easily gathered; your men come back with ${quantity} tonnes. They will fetch a good price on sophisticated worlds.]],textData) )
			player.addCargo(GOURMET_FOOD,quantity)
		else
			local damages=gh.floorTo(500+math.random()*1000,-2)
			textData.damages=damages
			tk.msg( "A Serpent in the Fruit", gh.format([[Your men set foot on the valley, even more beautiful up close than in the long-distance views. The peaceful scene might have dulled their senses as none of them notice the unnatural silence surrounding them - up to the moment where one man reaches toward one of the hanging fruit. Suddenly the valley is swarming with small flying creatures with leathery wings and sharp teeth, swooping down on the exposed team. Only your insistence that they wear suits and carry blasters allows them to escape with only minor injuries. Good thing too, as the bat-like creatures turn out to be highly poisonous. Bitten crew members are only saved by the med bay's capacity to generate antidotes to the poison.

				You've lost ${damages} credits in medicinal supplies and your team's moral is rock-bottom. You'll leave ${planetname} without regrets.]],textData) )
			player.pay(-damages)
		end
	end
	end,
	weightValidity=function(planet)
	local validPlanets={planetTemplateWarmTerra=true,planetTemplateTemperateTerra=true}

	return validPlanets[planet.lua.planetType]
	end,
	uncivilizedOnly=true,
	weight=10
}


landing_events.steacksInHerd={
	runEvent=function(planet)

	local textData=landingEventsTextData(planet)

	local eventText1=[[In a wide plain cut into by a mighty river, your probes notice an inviting sight: a horde of plump, slow-moving herbivores. ${planetname}'s biology being human-compatible, they are probably safe to eat, and they look yummy!

	Order a foraging party?]]

	if tk.yesno( "Steak on the Horizon", gh.format(eventText1,textData) ) then
		if math.random() <0.8 then
			local quantity=gh.floorTo(5+math.random()*5)
			textData.quantity=quantity
			tk.msg( "The Barbecue of Your Lives", gh.format([[The clumsy beasts fail to react as your men take position, trapping them against the river. On your count they open fire on pre-identified animals - particularly handsome-looking specimens. They fall like bricks while the rest of the herd panics.

				You do the inventory in the dying lights of the bonfire your men have roasted the animals on. ${quantity} tonnes of fresh meat! Buffalo Bill would have been proud.]],textData) )
			player.addCargo(FOOD,quantity)
		else
			local damages=gh.floorTo(500+math.random()*1000,-2)
			textData.damages=damages
			tk.msg( "The Shepherds of the Flock", gh.format([[If your men had been attentive they might have noticed sooner the strange ripples in the long grass around the herd. Instead the first sign of trouble is a muffled cry by the lead man, falling to the ground with blood streaming from his savaged back. In an instant your men find themselves fighting shadows - small, unbelievably quick creatures with razor teeth striking without warning before melting back in the long grass. Only a quick retreat, blasters blazing, gets them out of danger.

				Later surveys by probes shed light on the events: the placid herbivores are shepherded by intelligent social carnivores who protect them from outside threats - and take their pounds of flesh in return.

				Medical bills for wounded crew members set you back ${damages}, and there's nothing but soup left in the ship's stores.]],textData) )
			player.pay(-damages)
		end
	end
	end,
	weightValidity=function(planet)
	local validPlanets={planetTemplateJungleVenus=true,planetTemplateWarmTerra=true,planetTemplateTemperateTerra=true,planetTemplateJungleVenus=true}

	return validPlanets[planet.lua.planetType]
	end,
	uncivilizedOnly=true,
	weight=10
}