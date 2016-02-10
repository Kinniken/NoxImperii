include("dat/factions/spawn/common.lua")

-- @brief Creation hook.
function create ( max )
    return 100000000
end


-- @brief Spawning hook
function spawn ( presence, max )
    return 100000000, nil
end
