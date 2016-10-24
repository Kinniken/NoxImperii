include("dat/factions/spawn/common.lua")


-- @brief Spawns a small patrol fleet.
function spawn_patrol ()
    local pilots = {}
    local r = rnd.rnd()

    if r < 0.3 then
       scom.addPilot( pilots, "Pirate Shark", 15 );
    elseif r < 0.5 then
       scom.addPilot( pilots, "Pirate Admonisher", 20 );
    elseif r < 0.8 then
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Shark", 15 );
    else
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Admonisher", 20 );
    end

    return pilots
end


-- @brief Spawns a medium sized squadron.
function spawn_squad ()
    local pilots = {}
    local r = rnd.rnd()

    if r < 0.4 then
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Admonisher", 20 );
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Vendetta", 80 );
    elseif r < 0.6 then
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Vendetta", 40 );
       scom.addPilot( pilots, "Pirate Delta", 80 );
    elseif r < 0.8 then
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Rhino", 80 );
    else
       scom.addPilot( pilots, "Pirate Admonisher", 20 );
       scom.addPilot( pilots, "Pirate Shark", 15 );
       scom.addPilot( pilots, "Pirate Vendetta", 80 );
       scom.addPilot( pilots, "Pirate Kestrel", 120 );
    end

    return pilots
end


-- @brief Spawns a capship with escorts.
function spawn_capship ()
    local pilots = {}
    local r = rnd.rnd()

    -- Generate the capship
    scom.addPilot( pilots, "Pirate Kestrel", 125 )

    -- Generate the escorts
    if r < 0.5 then
       scom.addPilot( pilots, "Pirate Vendetta", 25 );
       scom.addPilot( pilots, "Pirate Vendetta", 25 );
       scom.addPilot( pilots, "Pirate Admonisher", 45 );
    elseif r < 0.8 then
       scom.addPilot( pilots, "Pirate Shark", 20 );
       scom.addPilot( pilots, "Pirate Vendetta", 25 );
       scom.addPilot( pilots, "Pirate Delta", 20 );
       scom.addPilot( pilots, "Pirate Admonisher", 45 );
    else
       scom.addPilot( pilots, "Pirate Shark", 20 );
       scom.addPilot( pilots, "Pirate Vendetta", 25 );
       scom.addPilot( pilots, "Pirate Delta", 20 );
       scom.addPilot( pilots, "Pirate Rhino", 35 );
       scom.addPilot( pilots, "Pirate Admonisher", 45 );
    end

    return pilots
end


-- @brief Creation hook.
-- return is just delay before first spawn
function create ( max )
    local weights = {}

    -- Create weights for spawn table
    weights[ spawn_patrol  ] = 100
    weights[ spawn_squad   ] = math.max(1, -80 + 0.80 * max)
    weights[ spawn_capship ] = math.max(1, -500 + 1.70 * max)
   
    -- Create spawn table base on weights
    spawn_table = scom.createSpawnTable( weights )

    -- Calculate spawn data for next time (spawn_data persists between calls)
    spawn_data = scom.choose( spawn_table )

    return scom.calcNextSpawn( 0, scom.presence(spawn_data), max )
end


-- @brief Spawning hook
-- presence: presence used by pilots of that faction currently
-- max: maximum presence allowed
-- return:
--  - delay before next spawn (calculated from the next fleet size)
--  - table of pilots as a series of { pilot = pilot, presence = presence }

function spawn ( presence, max )

    --safety if create() was not called
   --(can happen in border cases in Nox, unlike Naev)
   if spawn_data==nil then
      return 10000,nil
    end

    local pilots

    -- Over limit
    if presence > max then
       return 5--retry in 5 ticks
    end
  
    -- Actually spawn the pilots & returns them in a table of elements { pilot = pilot, presence = presence }
    -- if a fleet was spawned, each pilot is returned seperately
    pilots = scom.spawn( spawn_data )

    -- Calculate spawn data for next time (spawn_data persists between calls)
    spawn_data = scom.choose( spawn_table )

    return scom.calcNextSpawn( presence, scom.presence(spawn_data), max ), pilots
end
