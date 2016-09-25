include('universe/generate_system.lua')
include('universe/live/live_desc.lua')
include('universe/live/live_universe.lua')
include('dat/scripts/general_helper.lua')
include('universe/objects/class_planets.lua')
include('universe/locations.lua')

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

	for k,c_system in pairs(system.getAll()) do
		local pos={}
		pos.x,pos.y = c_system:coords()

		local zone=get_zone(pos)

		if c_system:getZone()==nil or c_system:getZone()=="" then
			c_system:setZone(zone.zoneName(pos))
		end

		if stellar_templates[zone.star_template].background() ~= "" then
 			c_system:setBackground(stellar_templates[zone.star_template].background())
 		end

		c_system:setStars(stellar_templates[zone.star_template].starNumbers())
	end

	evt.finish()
end



