include('universe/objects/class_planets.lua')
include("universe/worldevents/worldevents_main.lua")
include "general_helper.lua"

function create()

	c_sys=system.cur()

	possibleTargets={}
	
	local cx,cy=c_sys:coords()
	for k,s in ipairs( system.withinRadius(cx,cy,300) ) do
		for k2,c_planet in ipairs(s:planets()) do
			if c_planet:getLuaData()~=nil and c_planet:getLuaData()~="" then
				possibleTargets[#possibleTargets+1]=c_planet
			end
		end
	end

	if (#possibleTargets>0) then

		local nb=10
		local max=1

		if (debug==true) then
			nb=20
			max=5
		end

		local nbDone=0

		for i=1,nb do

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
						--duration either specified in bar news itself or in event
						local duration

						if (v.duration) then
							duration = v.duration
						else
							duration = event.duration
						end

						if (type(duration) == "string") then
							print("World event "..event.eventMessage.." has a string as news duration!")
						end

						news.add( v.faction, gh.format(v.title,textData), time.get():str(1).." - "..gh.format(v.message,textData), time.get() + duration )
					end

					nbDone=nbDone+1
				end
			end

			if (nbDone>=max) then
				break
			end
		end
	end
	
	evt.finish()
end
