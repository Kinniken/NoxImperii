

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

	return validPlanets[planet.lua.planetType] and (#planet.lua.settlements)==0
	end,
	weight=10
}