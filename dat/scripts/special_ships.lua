include('general_helper.lua')
include('universe/locations.lua')

special_ships = {}

include('universe/specialships/imperial.lua')

local MAX_DELAY = 60
local DELAY = 200

ships_by_location = {}

-- pre-populate ships declared by the faction scripts by location, to save time later
for _,ss in ipairs(special_ships) do

	for _,loc in ipairs(ss.locations) do

		if not ships_by_location[loc] then
			ships_by_location[loc] = {}
		end

		ships_by_location[loc][#ships_by_location[loc]+1] = ss
	end
end

function create()
	local sys = system.cur()

	totalPres = 0

	for _,pres in pairs(sys:presences()) do
		totalPres = totalPres + pres
	end

	if totalPres < 100 then
		maxShip = math.random(0,1)
	elseif totalPres < 1000 then
		maxShip = 1
	else
		maxShip = 2
	end

	spawnedShip = 0

	local x,y = sys:coords()
	location = get_zone({x=x,y=y})

	if not ships_by_location[location.id] then
		maxShip = 0
		warn("No special ships for location: "..location.id)
		return 100000000
	else
		return math.random(0,math.min(MAX_DELAY,DELAY/totalPres))
	end
end

function spawn()

	if (spawnedShip < maxShip ) then

		local ship_template = gh.pickWeightedObject(ships_by_location[location.id])

		if not ship_template then
			-- shouldn't happen, but apparently no ships qualifies
			warn("No ships qualified in location "..location.id)
			return 100000000
		end

		warn("Picked ship: "..ship_template.fleet)

		local ps=pilot.add(ship_template.fleet)

		warn("Generated "..#ps.." pilots.")

		for _,p in ipairs(ps) do
			p:rename(ship_template.names[math.random(#ship_template.names)])
			p:setHilight()
			warn("Generated ship: "..p:name())
		end

		spawnedShip = spawnedShip + 1

		return math.random(0,math.min(MAX_DELAY,DELAY/totalPres))
	else
		return math.random(0,math.min(MAX_DELAY,DELAY/totalPres))
	end

end

