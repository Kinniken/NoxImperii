include('universe/generate_system.lua')
include('universe/live/live_desc.lua')
include('universe/live/live_services.lua')
include('universe/generate_helper.lua')
include('universe/objects/class_planets.lua')

function create()
		
	math.randomseed(os.time())
	
	for k,c_planet in pairs(planet.getAll()) do

		planet=planet_class.load(c_planet)

		if (not planet.lua.initialized) then
			generatePlanetServices(planet)
			planet.lua.initialized=true
			planet:save()

		end

	end

	evt.finish()
end



