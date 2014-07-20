include('universe/objects/class_planets.lua')
include("universe/worldevents/worldevents_main.lua")
include("universe/live/live_services.lua")
include("universe/generate_helper.lua")

function create()
		
	c_sys=system.cur()
	timeNumber=time.get():tonumber()

	for k,c_planet in pairs(c_sys:planets()) do
		local planet=planet_class.load(c_planet)
		local nbCleared=0

		for k2,settlement in pairs(planet.lua.settlements) do
			nbCleared=nbCleared+settlement:clearObsoleteEffects()
		end

		if (nbCleared>0) then--things have changed, need to recalculate
			generatePlanetServices(planet)
			planet:save()
		end
	end

	evt.finish()
end
