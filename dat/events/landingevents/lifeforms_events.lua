

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