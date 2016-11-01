include "general_helper.lua"
include "fleethelper.lua"
include "fleet_form.lua"

local MAX_DELAY = 60
local DELAY = 2000

fleet_table = {}

local fleet_prototype = {
	weightValiditySelf=function(self,presences)
		if (self.min_presence and presences.max < self.min_presence) then
			return false
		end
		if (self.max_presence and presences.max > self.max_presence) then
			return false
		end
		return true
	end
}

fleet_prototype.__index = fleet_prototype

function new_fleet(fleetNames,weight,max_presence,min_presence)
  local o={}
  setmetatable(o, fleet_prototype)

  if (type(fleetNames) == "string") then
    o.fleetNames={fleetNames}
  else
    o.fleetNames=fleetNames
  end  
  o.weight=weight
  o.min_presence=min_presence
  o.max_presence=max_presence
  return o
end


function chooseSpawn(used, max_presence)
	local fleet = gh.pickConditionalWeightedObject(fleet_table,{used=used,max=max_presence})

	if fleet == nil then
		print("No suitable fleet! Max presence: "..max_presence)
		return nil
	end

	return fleet
end


-- @brief Creation hook.
-- return is just delay before first spawn
function create ( max_presence )
    return math.random(0,math.min(MAX_DELAY,DELAY/max_presence))
end


-- @brief Spawning hook
-- presence: presence used by pilots of that faction currently
-- max_presence: maximum presence allowed
-- return:
--  - delay before next spawn (calculated from the next fleet size)
--  - table of pilots as a series of { pilot = pilot, presence = presence }

function spawn ( used, max_presence, cur_faction )

	-- Over limit
  if used > max_presence then
     return 5--retry in 5 seconds
  end

  local fleet=chooseSpawn(used,max_presence)

  if (fleet == nil) then
  	return 10000--retry in a long time, probably won't work ever
  end

  origin = spawn_findOrigin(cur_faction)

  if not origin then
    warn("Could find no valid origin for faction "..cur_faction:name().." in system "..system.cur():name())
    return 10000
  end

  local ps={}

  for _,f in ipairs(fleet.fleetNames) do
    local addedPilots=pilot.add( f, nil, origin )

    for _,p in ipairs(addedPilots) do
      ps[#ps+1] = p
    end
  end

  local pilots={}

	for i,p in ipairs(ps) do

    if #ps > 1 then
      if i == 1 then
        p:memory("is_fleet_leader",true)
      else
        --currently not used due to presumed memoryCheck bug; instead we use setBoss
        p:memory("fleet_leader_id",ps[1]:id())

        --p:setBoss(ps[1])
      end
    end

		local presence

  	if (fleet.presence == nil) then
  		--by default, calculated from ship mass
  		presence = math.ceil(p:stats().mass/20)
  	else
  		--split between pilots if more than one ship
  		presence = fleet.presence / #ps
  	end

  	pilots[#pilots+1] = {pilot=p, presence=presence}
  end

  --atFleet = Forma:new(ps, "cross", 3000)

  return math.random(0,math.min(MAX_DELAY,DELAY/max_presence)), pilots
end

function spawn_findOrigin(cur_faction)

  local dest = {}

  for _,v in ipairs(system.cur():jumps()) do
    if v:dest():presence(cur_faction) then
      dest[#dest+1]={dest=v:dest(),weight=v:dest():presence(cur_faction)}
    end
  end

  for _,v in ipairs(system.cur():planets()) do
    if v:services()["inhabited"] and (v:faction() == nil or not v:faction():areEnemies(cur_faction)) then
      if v:presence(cur_faction) then
        dest[#dest+1]={dest=v,weight=10+v:presence(cur_faction)}
      else
        dest[#dest+1]={dest=v,weight=10}
      end
    end
  end

  local choice=gh.pickWeightedObject(dest)

  if choice then
    return choice.dest
  end
end