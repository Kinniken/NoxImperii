include('universe/generate_helper.lua')
include('universe/objects/class_planets.lua')
include('universe/live/live_services.lua')

earth_pos={x=0,y=0}
merseia_pos={x=1800,y=-100}
betelgeuse_pos={x=1000,y=460}

local acturus_sector={x=2,y=893}--Diadomes
local taurus_sector={x=340,y=574}--Dennitza
local antares_sector={x=-346,y=-206}--Hermes
local alphacrusis_sector={x=-685,y=131}--Aenas
local leo_sector={x=700,y=-50}
local sol_sector={x=0,y=0}

imperial_sectors={{center=sol_sector,name="Sector Sol",key="sol"},
	{center=acturus_sector,name="Sector Acturus",key="acturus"},
	{center=taurus_sector,name="Sector Taurus",key="taurus"},
	{center=antares_sector,name="Sector Antares",key="antares"},
	{center=alphacrusis_sector,name="Sector Alpha Crucis",key="alphacrusis"},
	{center=leo_sector,name="Sector Leo",key="leo"}}

imperial_barbarian_zones={	coreward_barb={name="Coreward Barbarian Wastes",key="coreward_barb"},
					rimward_barb={name="Rimward Barbarian Wastes",key="rimward_barb"},
					spinward_barb={name="Spinward Barbarian Wastes",key="spinward_barb"},
					anti_barb={name="Anti-spinward Barbarian Wastes",key="anti_barb"}}

imperial_barbarian_zones_array={imperial_barbarian_zones.coreward_barb,imperial_barbarian_zones.rimward_barb,imperial_barbarian_zones.spinward_barb,imperial_barbarian_zones.anti_barb}


roidhunate_barbarian_zones={	coreward_barb={name="Coreward Roidhunate Barbarian Wastes",key="coreward_barb"},
					rimward_barb={name="Rimward Roidhunate Barbarian Wastes",key="rimward_barb"},
					spinward_barb={name="Spinward Roidhunate Barbarian Wastes",key="spinward_barb"},
					anti_barb={name="Anti-spinward Roidhunate Barbarian Wastes",key="anti_barb"}}

roidhunate_barbarian_zones_array={roidhunate_barbarian_zones.coreward_barb,roidhunate_barbarian_zones.rimward_barb,roidhunate_barbarian_zones.spinward_barb,roidhunate_barbarian_zones.anti_barb}

function initStatusVar()

	for _,v in pairs(imperial_sectors) do
		var.push("universe_stability_"..v.key,0.9)
	end
	var.push("universe_stability_sol",1)

	for _,v in pairs(imperial_barbarian_zones_array) do
		var.push("universe_barbarian_activity_"..v.key,0.5)
	end
end

function updateUniverseDesc()
	local desc=[[The Empire is weak - damaged by corruption, hounded by barbarians, locked in a deadly rivalry with the Roidhunate.

Current stability of the Imperial Sectors:

]]

	for _,v in ipairs(imperial_sectors) do
		local stability=var.peek("universe_stability_"..v.key)
		desc=desc..[[	]]..v.name..": "..gh.floorTo(100*stability)..'%\n'
	end

	desc=desc..[[

Beyond the Empire's borders, barbarians are rising to raid civilized worlds.

Current barbarian activity:

]]

	for _,v in ipairs(imperial_barbarian_zones_array) do
		local activity=var.peek("universe_barbarian_activity_"..v.key)
		desc=desc..[[	]]..v.name..": "..gh.floorTo(100*activity)..'%\n'
	end

	var.push("universe_status",desc)
end

function getSectorStability(sectorName)

	for _,v in ipairs(imperial_sectors) do
		if sectorName==v.name then
			return var.peek("universe_stability_"..v.key)
		end
	end

	return nil
end

function setSectorStability(sectorName,stability)
	for _,v in pairs(imperial_barbarian_zones) do
		if sectorName==v.name then
			var.push("universe_stability_"..v.key,stability)
		end
	end
	
	for _,p in pairs(planet.getAll()) do
		if p:system() and p:system():getZone()==sectorName then
			generatePlanetServices(planet_class.load(p))
		end
	end

	updateUniverseDesc()
end

function adjustSectorStability(sectorName,change)
	local stability=getSectorStability(sectorName)

	if not stability then
		print("No stability for zone: ")
		print(sectorName)
	else
		setSectorStability(sectorName,stability*change)
	end
end

function getBarbarianActivity(sectorName)

	for _,v in ipairs(imperial_barbarian_zones) do
		if sectorName==v.name then
			return var.peek("universe_barbarian_activity_"..v.key)
		end
	end

	return nil
end

function setBarbarianActivity(sectorName,activity)
	for _,v in pairs(barbarian_zones) do
		if sectorName==v.name then
			var.push("universe_barbarian_activity_"..v.key,activity)
		end
	end
	
	for _,p in pairs(planet.getAll()) do
		if p:system() and p:system():getZone()==sectorName then
			generatePlanetServices(planet_class.load(p))
		end
	end

	updateUniverseDesc()
end

function adjustBarbarianActivity(sectorName,change)
	local activity=getBarbarianActivity(sectorName)

	if not activity then
		print("No activity for zone: ")
		print(sectorName)
	else
		print("Adjusting to: "..activity*change)
		setBarbarianActivity(sectorName,activity*change)
	end
end

function get_nearest_barbarian_zone(star)

	local dist_earth=gh.calculateDistance(earth_pos,star)
	local dist_merseia=gh.calculateDistance(merseia_pos,star)

	if (dist_earth<dist_merseia) then

		local dx=star.x-earth_pos.x
		local dy=star.y-earth_pos.y

		if math.abs(dx)>math.abs(dy) then
			if (dx>0) then
				return imperial_barbarian_zones.spinward_barb
			else
				return imperial_barbarian_zones.anti_barb
			end
		else
			if (dy>0) then
				return imperial_barbarian_zones.coreward_barb
			else
				return imperial_barbarian_zones.rimward_barb
			end
		end
	else
		local dx=star.x-merseia_pos.x
		local dy=star.y-merseia_pos.y

		if math.abs(dx)>math.abs(dy) then
			if (dx>0) then
				return roidhunate_barbarian_zones.spinward_barb
			else
				return roidhunate_barbarian_zones.anti_barb
			end
		else
			if (dy>0) then
				return roidhunate_barbarian_zones.coreward_barb
			else
				return roidhunate_barbarian_zones.rimward_barb
			end
		end
	end
end