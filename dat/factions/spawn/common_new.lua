include('dat/scripts/general_helper.lua')

fleet_table = {}

local fleet_prototype = {
	getFleets=function(self)
		local fleets={}

		for _,v in ipairs(fleetNames) do
			fleets[#fleets+1] = {{fleet=v}}
		end

		return fleets
	end,
	weightValidity=function(obj)
		if (obj.fleet.min_presence and presences.max > obj.fleet.min_presence) then
			return false
		end
		if (obj.fleet.max_presence and presences.max > obj.fleet.max_presence) then
			return false
		end
		return true
	end
}

fleet_prototype.__index = fleet_prototype

function new_fleet(fleetNames,weight,min_presence,max_presence)
  local o={}
  setmetatable(o, fleet_prototype)
  o.fleetNames=fleetNames
  o.weight=weight
  o.min_presence=min_presence
  o.max_presence=max_presence
  return o
end


function chooseSpawn(used, max)
	local fleet = gh.pickConditionalWeightedObject(fleet_table,{used=used,max=max})

	return fleet
end


-- @brief Creation hook.
-- return is just delay before first spawn
function create ( max )
    return math.random(0,10000/max)
end


-- @brief Spawning hook
-- presence: presence used by pilots of that faction currently
-- max: maximum presence allowed
-- return:
--  - delay before next spawn (calculated from the next fleet size)
--  - table of pilots as a series of { pilot = pilot, presence = presence }

function spawn ( used, max )

  	-- Over limit
    if used > max then
       return 5--retry in 5 ticks
    end

    local fleet=chooseSpawn(used,max)

    if (fleets == nil) then
    	return 10000--retry in a long time, probably won't work ever
    end

    local pilots={}

    for _,v in ipairs(fleets) do
    	local ps=pilot.add( v.fleet )

    	for _,p in ipairs(ps) do
    		local presence

	    	if (v.presence == nil) then
	    		--by default, calculated from ship mass
	    		presence = math.ceil(p:ship():mass()/100)
	    	else
	    		--split between pilots if more than one ship
	    		presence = v.presence / #ps
	    	end

	    	pilots[#pilots+1] = {pilot=p, presence=presence}
	    end
    end

    return math.random(0,10000/max), pilots
end