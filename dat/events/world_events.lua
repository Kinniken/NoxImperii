include('universe/objects/class_planets.lua')
include("universe/worldevents/worldevents_main.lua")
include("universe/generate_helper.lua")

function create()
	c_sys=system.cur()

	possibleTargets={}
	
	for k,s in ipairs( c_sys:adjacentSystems() ) do
		for k2,c_planet in ipairs(s:planets()) do
			if c_planet:getLuaData()~=nil and c_planet:getLuaData()~="" then
				possibleTargets[#possibleTargets+1]=c_planet
			end
		end
	end

	if (#possibleTargets>0) then
		for i=1,1 do
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
					event:applyOnWorld(planet)
					local msg=event:getEventMessage(planet)
					if (msg ~="") then
						player.msg(msg)
					end

					local history=event:getWorldHistoryMessage(planet)
					if (history ~="") then
						planet:addHistory(history)
					end
					generatePlanetServices(planet)
					planet:save()
				end
			end
		end
	end

	evt.finish()
end
