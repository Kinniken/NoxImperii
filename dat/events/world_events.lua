include('universe/objects/class_planets.lua')
include("universe/worldevents/worldevents_main.lua")
include("universe/generate_helper.lua")

function create()
	c_sys=system.cur()

	possibleTargets={}
	
	local cx,cy=c_sys:coords()
	for k,s in ipairs( system.withinRadius(cx,cy,200) ) do
		for k2,c_planet in ipairs(s:planets()) do
			if c_planet:getLuaData()~=nil and c_planet:getLuaData()~="" then
				possibleTargets[#possibleTargets+1]=c_planet
			end
		end
	end

	if (#possibleTargets>0) then
		for i=1,5 do
			local c_planet=possibleTargets[math.random(#possibleTargets)]
			local planet=planet_class.load(c_planet)

			local existingEffect=false

			for k,v in pairs(planet.lua.settlements) do
				if (v.activeEffects and #v.activeEffects>0) then
					existingEffect=true
				end
			end

			if (not existingEffect) then
				local event=gh.pickConditionalWeightedObject(world_events.events,planet)

				if (event) then

					local textData={}
					textData.world=planet.c:name()
					textData.system=planet.c:name()


					event:applyOnWorld(planet,textData)

					local msg=event.eventMessage
					if (msg ~=nil) then
						player.msg(gh.format(msg,textData))
					end

					local history=event.worldHistoryMessage
					if (history ~=nil) then
						planet:addHistory(gh.format(history,textData))
					end
					generatePlanetServices(planet)
					planet:save()

					for k,v in ipairs(event.barNews) do
						news.add( v.faction, gh.format(v.title,textData), gh.format(v.message,textData), time.get() + v.duration )
					end
				end
			end
		end
	end

	evt.finish()
end
