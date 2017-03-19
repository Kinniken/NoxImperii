include "general_helper.lua"

local MAX_DELAY = 60
local DELAY = 200
local MASS_PER_PRESENCE = 20

fleet_table = {}

-- return 0 if not suitable, 1 is fine, something in-between if not so good
local function test_range(range,value)
  local validity=1

  --first value is minimum required
  if range[1] and range[1]>value then
    return 0
  end
  --second value is minimum wanted
  if range[2] and range[2]>value then
      validity = validity * value/range[2]
  end
  --third value is maximum wanted
  if range[3] and range[3]<value then
    validity = validity * range[3]/value
  end
  --fourth value is maximum required
  if range[4] and range[4]<value then
    return 0
  end

  return validity
end

local fleet_prototype = {
	weightValiditySelf=function(self,values)

    if (self.params.presence) then
      local ret=test_range(self.params.presence,values.max)
      
      if ret == 0 then
        --warn("Refused fleet "..self.id.." with presence of "..values.max)
        return false
      end
    end

		if (self.params.enemies) then
      local ret=test_range(self.params.enemies,values.danger)
      
      if ret == 0 then
        --warn("Refused fleet "..self.id.." with danger of "..values.danger)
        return false
      end
    end

    --warn("Fleet "..self.id.." ok")
		return true
	end,
  dynamicWeight=function(self,values)
    local weight = self.weight

    if (self.params.presence) then
      weight = weight * test_range(self.params.presence,values.max)
    end

    if (self.params.enemies) then      
      weight = weight * test_range(self.params.enemies,values.danger)
    end

    return weight
  end
}

fleet_prototype.__index = fleet_prototype

function declare_fleet(fleetNames,weight,params)
  local o={}
  setmetatable(o, fleet_prototype)

  if (type(fleetNames) == "string") then
    o.fleetNames={fleetNames}
  else
    o.fleetNames=fleetNames
  end  
  o.weight=weight
  if params then
    o.params=params
  else
    o.params={}
  end
  fleet_table[#fleet_table+1] = o
  o.id = #fleet_table
end


function chooseSpawn(used, max_presence, cur_faction)

  local danger = 0
  local presences = system.cur():presences()

  -- danger is the total presence of enemie factions
  for _,f in pairs(cur_faction:enemies()) do
    if presences[f] then
      danger = danger + presences[f]
    end
  end

	local fleet = gh.pickConditionalWeightedObject(fleet_table,{max=max_presence,danger=danger})

	if fleet == nil then
		warn("No suitable fleet for "..cur_faction:name().."! Max presence: "..max_presence..", danger: "..danger)
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
-- cur_faction: faction we are generating for
-- return:
--  - delay before next spawn (calculated from the next fleet size)
--  - table of pilots as a series of { pilot = pilot, presence = presence }

function spawn ( used, max_presence, cur_faction )

	-- Over limit
  if used > max_presence then
     return 5--retry in 5 seconds
  end

  local fleet=chooseSpawn(used,max_presence,cur_faction)

  if (fleet == nil) then
  	return 10000--retry in a long time, probably won't work ever
  end

  origin = spawn_findOrigin(cur_faction)

  if not origin then
    warn("Could find no valid origin for faction "..cur_faction:name().." in system "..system.cur():name())
    return 10000
  end

  local ps={}

  local fleetList

  if (type(fleet.fleetNames)=="function") then
    fleetList = fleet.fleetNames()
  else
    fleetList = fleet.fleetNames
  end

  for _,f in ipairs(fleetList) do
    local addedPilots=pilot.add( f, nil, origin )

    for _,p in ipairs(addedPilots) do
      ps[#ps+1] = p
    end
  end

  local pilots={}

	for i,p in ipairs(ps) do

    if #ps > 1 then
      local mem = p:memory()
      if i == 1 then        
        --warn(p:name().." is fleet leader.")
        mem.is_fleet_leader = true
        if fleet.params.formation then
          mem.fleet_formation = fleet.params.formation
        end
      else
        --warn(p:name().." is in the fleet of "..ps[1]:name())
        p:setLeader(ps[1])
      end
    end

		local presence

  	if (fleet.presence == nil) then
  		--by default, calculated from ship mass
  		presence = math.ceil(p:stats().mass/MASS_PER_PRESENCE)
  	else
  		--split between pilots if more than one ship
  		presence = fleet.presence / #ps
  	end

  	pilots[#pilots+1] = {pilot=p, presence=presence}
  end

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

--@brief returns a list of ships of provided types with random quantities
--@param list of types in the following format, as seperate arguments: {"Fish Bone",1,4},{"Zheng He",2,4}
--First number for each type is the minimum quantity, second the max
function spawn_variableFleet(...)
  local ships = {}

  for _,v in ipairs(arg) do
    local nb=math.random(v[2],v[3])

    for i=1,nb do
      ships[#ships+1] = v[1]
    end
  end

  return ships
end