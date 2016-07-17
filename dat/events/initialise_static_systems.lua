include('universe/generate_system.lua')
include('universe/live/live_desc.lua')
include('universe/live/live_universe.lua')
include('dat/scripts/general_helper.lua')
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

	--only for the zone name
	for k,c_system in pairs(system.getAll()) do
		local pos={}
		pos.x,pos.y = c_system:coords()

		local population_template=pickPopulationTemplate(pos)

		c_system:setZone(population_template.zoneName(pos))
	end

	evt.finish()
end



